# PostgreSQL versus SQL Server experimental comparison

**Result path:** `results/batch-04-server-platform/16-database-comparison-experiment-result.md`  
**Research date:** 31 July 2026  
**Decision status:** **EXPERIMENT DESIGN ACCEPTED — DATABASE ADR REMAINS OPEN; NO PRODUCTION ENGINE IS SELECTED**  
**Authority boundary:** relational server-ingestion, database, capacity, lifecycle, operations, licensing, and decision-gate research for the next-generation UAM modular monolith; **not** legal purpose, prohibited uses, workforce governance, production fields, retention approval, strategic platform standards, budget, licensing approval, staffing, on-call acceptance, SLO/RPO/RTO, pilot, or production approval  
**Primary gate:** **The database ADR requires production-shaped paired results, restore and failover evidence, a skills/TCO assessment, and accountable owner approval.**

## Evidence vocabulary

This result uses the required labels:

- **FACT** — directly supported by an allowlisted supplied file or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from stated facts; the chain is explained.
- **ESTIMATE** — a numerical hypothesis with replaceable inputs.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — required evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, business, support, or production authority is required.
- **CLI EXPERIMENT** — code, lab work, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements define the proposed experiment and portable database contract. They do not convert a **HUMAN DECISION**, **UNKNOWN**, or unexecuted **CLI EXPERIMENT** into approval.

---

# 1. Executive conclusion in easy language, with confidence and residual risk

## 1.1 Conclusion

**RECOMMENDATION — KEEP THE DATABASE ADR OPEN.** PostgreSQL remains the UAM reference candidate and SQL Server remains a serious transition and fallback candidate. The available evidence does not justify selecting either engine in prose.

Both products document the capabilities needed for the proposed design: transactional durable receipt, uniqueness, bulk loading, work leasing, partitioning, row-level security, online observation, backup, point-in-time recovery, replication, and failover. That proves capability exists; it does **not** prove UAM fitness on the intended edition, topology, hardware, service tier, workload, support model, or operating team. [W01–W27]

The decision should therefore be made by one engine-neutral harness that executes the same UAM semantics against both candidates and publishes raw reproducible evidence. The harness must prove correctness first and compare performance and cost only after both candidates pass the same hard gates.

The proposed portable design is:

1. a relational durable inbox and receipt in one transaction;
2. a narrow mutable work table leased by bounded workers;
3. an unpartitioned global event-identity ledger that owns idempotency;
4. partitioned typed facts and server-derived aggregates;
5. per-session temporary bulk staging because the inbox is already the durable source;
6. realm-first keys, application authorization, and database row-level security as defense in depth;
7. identical query, late-arrival, retention, backup, restore, failover, and report-coexistence tests;
8. a decision model that includes operations, skills, licensing, support, and three-year TCO rather than throughput alone.

**INFERENCE.** Separating the global identity ledger from the partitioned fact table is the smallest engine-neutral way to preserve one final business effect while retaining practical time partitioning. PostgreSQL and SQL Server both constrain uniqueness on partitioned indexes in ways that require the partitioning column to participate in the unique key; a separate non-partitioned identity ledger avoids making event identity depend on an unsettled partition grain. [W06, W18]

## 1.2 What is authorized now

**GO** for:

- strict logical schemas, engine adapters, fictional fixtures, an independent oracle, run manifests, evidence schemas, and analysis code;
- disconnected or isolated T1 benchmark environments using only fictional realms, devices, batches, events, URLs, applications, reports, and identities;
- a common self-managed hardware comparison and separately labelled managed-service experiments;
- PostgreSQL and SQL Server prototypes at current supported releases, with exact patch/CU, edition, driver, OS, configuration, and image digests captured in each run;
- correctness, lease, dedupe, realm, backup, restore, failover, maintenance, report, retention, and cost experiments defined in this result.

## 1.3 What is not authorized

**STOP** before:

- selecting a production engine, edition, service, topology, or support provider;
- calling a generic benchmark score, one run, a 6,000-device smoke test, or a vendor SLA “capacity proof”;
- using production activity, internal URLs, customer configuration, credentials, addresses, SSH material, personal data, or confidential reference data;
- issuing a receipt before the exact durable inbox transaction commits;
- weakening uniqueness, realm isolation, durability, backup, or failover settings to improve a score;
- comparing SQL Server Enterprise performance with Standard pricing, or comparing a tuned engine with an untuned peer;
- using a reporting replica as “passive” in a licensing assumption without Procurement/Legal review;
- adding a broker merely because a benchmark reaches saturation;
- applying production retention, deletion, or payload-cleanup behavior before the later human and restore/deletion gates.

## 1.4 Gate status

| Gate | Current status | Closure evidence | Non-waivable stop condition |
|---|---|---|---|
| DBX-CORRECTNESS | **OPEN — CLI EXPERIMENT** | durable receipt, exact replay, dedupe, conflict, poison, lease, and realm histories reconciled against the independent oracle | false receipt, duplicate final effect, cross-realm access, silent coercion, or uncertain state treated as success |
| DBX-CAPACITY | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | paired production-shaped steady, reconnect-burst, reporting, late-arrival, and saturation runs using approved demand inputs | required workload unknown, confidence interval crosses the approved limit, or hard correctness gate fails under load |
| DBX-RESTORE | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | actual full restore and point-in-time recovery with receipt/effect/deletion reconciliation | acknowledged event missing, unacknowledged data reported as acknowledged, or deleted data visible before readiness |
| DBX-FAILOVER | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | real planned and unplanned failover under commit, receipt, lease, report, and backup load | split-brain effect, false receipt, duplicate materialization, failed fencing, or recovery outside approved objective |
| DBX-OPERATIONS | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | runbooks, blind on-call drills, maintenance, patch, backup, restore, capacity, and incident exercises | no accountable owner, operator cannot recover safely, or routine operation requires prohibited raw data/privilege |
| DBX-TCO | **OPEN — HUMAN DECISION + MEASUREMENT** | edition/topology quotes, support, OS, service, storage, backup, egress, monitoring, people, training, migration, and DR costs | edition or licensing topology is ambiguous, cost inputs are stale, or material costs are omitted |
| DBX-ADR | **OPEN** | all hard gates pass; weighted and sensitivity analyses are robust; owners approve strategic, skills, TCO, RPO/RTO, and report assumptions | any hard gate fails, result changes under plausible weights without an explicit tie decision, or owner approval is absent |

## 1.5 Confidence and residual risk

**Confidence in the experiment architecture: High.** It directly preserves accepted UAM invariants and makes engine-specific claims falsifiable.

**Confidence that both engines can implement the portable contract: Medium-High.** The required primitives are documented, but the exact composition has not run.

**Confidence in either production choice: Low.** Representative demand, retention, query corpus, RPO/RTO, staffing, support, budget, edition, topology, and paired benchmark evidence are missing.

Material residual risks remain even after a technical pass:

- storage hardware, hypervisor, filesystem, managed service, or firmware can violate assumed durability or latency behavior;
- workload distributions can shift after pilot, invalidating headroom and partition conclusions;
- PostgreSQL vacuum, WAL retention, replica lag, and failover operations can impose more on-call burden than the available team can support;
- SQL Server edition limits, licensing, passive-failover rules, Windows/Linux choice, and feature differences can materially change cost and architecture;
- row-level security can be bypassed by privileged roles or misconfigured connection-pool context;
- a separate identity ledger concentrates write contention and must be measured at reconnect peaks;
- restore and failover drills prove only the exact topology and failure tested, not every disaster;
- managed-service behavior and pricing can change independently of engine capability;
- a benchmark harness can share a conceptual defect with both adapters or the oracle.

Containment is a strict semantic contract, two independently reviewed engine adapters, an independent truth oracle, paired randomized runs, exact configuration evidence, real restore/failover drills, no production data, finite observability, and a decision gate that can return **NO ROBUST WINNER** rather than forcing a selection.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 Allowlisted project evidence and presence record

**FACT.** All seven allowlisted project files were present. No missing-file substitution was needed. This result did not use another Project file.

| Ref | Allowlisted logical file | Reviewed local file | SHA-256 | Use and limitation |
|---|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md` | same | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | accepted architecture, invariants, and human-authority boundary; not runtime or production proof |
| I02 | `04-data-and-schema-evidence-summary.md` | same | `1ed93b3d60d37da96c1f67e401deb10c9d57736e4f4dbfa26e16760bd2a19ce6` | legacy shape, target concepts, and explicit missing capacity/query/retention evidence; contains no production rows |
| I03 | `05-decisions-contradictions-and-gates.md` | same | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | accepted database decision posture, broker deferral, and proof-gate order |
| I04 | `06-research-evidence-rules.md` | same | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | evidence labels, source quality, human boundaries, and conflict discipline |
| I05 | `batch-01-review-result.md` | `batch-01-review-result(3).md` | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | accepted predecessor contracts, realm rules, modular-monolith boundary, repository/evidence controls, database benchmark gate |
| I06 | `batch-02-review-result.md` | same | `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | accepted endpoint source, identity, interpretation, whole-page, and stable event semantics; not server capacity proof |
| I07 | `batch-03-review-result.md` | same | `76854c3d6a12b9b717da90d4e368273bd88a672fc64a315afaeacfb3d701a785` | accepted endpoint durability, receipt, identity, diagnostics, release, and exact-evidence principles; later inbox/capacity/restore gates remain open |

## 2.2 Accepted inputs carried forward

The following are **FACT** from I01, I03, I05, I06, and I07:

1. UAM endpoints never receive central database credentials and never submit SQL.
2. Uploads are bounded, versioned, authenticated, compressed HTTPS batches.
3. A receipt means durable custody in the declared failure domain, not validation, materialization, integration, reporting, or portal visibility.
4. Delivery is at least once; stable event and batch identities plus central uniqueness produce one final business effect.
5. The initial server is a modular monolith with an ingestion boundary, relational durable inbox, leased workers, typed facts/aggregates, control API/BFF, and governed integrations.
6. No external broker is the default. It requires measured failure-domain, throughput, replay, fan-out, or cost evidence.
7. PostgreSQL is the target reference and SQL Server is a serious transition/fallback candidate. Production selection requires an identical benchmark plus operations, skills, licensing, and restore evidence.
8. Realm and installation authority comes from authenticated server context, never payload claims.
9. One realm cannot submit, read, mutate, delete, cache, or execute jobs as another.
10. Restores cannot lose acknowledged events or make deleted data visible before deletion/readiness state is restored.
11. UAM telemetry is fallible operational evidence, not sole forensic proof and not an employee-productivity score.
12. A failed early proof gate stops dependent work and opens an ADR; passing proves only the named claim and environment.

## 2.3 Scope

This result covers:

- a semantically identical relational schema and workload for PostgreSQL and SQL Server;
- durable inbox receipt, idempotency, poison handling, work leasing, bulk staging, materialization, reports, maintenance, partitioning, retention, backup, restore, HA/failover, and observability;
- self-managed and managed-service comparison boundaries;
- security and privacy controls for realm isolation and evidence handling;
- reproducible statistics, cost normalization, skills assessment, and decision sensitivity;
- exact CLI evidence and repository tasks required to close the database ADR.

## 2.4 Non-goals

This result does not:

- redesign endpoint collection, privacy transformation, local outbox, release, or device identity;
- approve legal purpose, prohibited uses, identity projection, exact fields, time precision, retention, access, or workforce governance;
- invent production event rates, payload sizes, outage distributions, query mix, RPO/RTO, SLOs, budget, staffing, or support commitments;
- select cloud, on-premises, operating system, database edition, support vendor, or managed service;
- approve an external broker, event-stream architecture, data lake, columnar warehouse, or microservice split;
- treat legacy DDL, row counts, reports, or direct-SQL endpoint behavior as a target design;
- prove production capacity with a generic TPC-style workload, vendor marketing, service SLA, download count, or popularity;
- authorize production data in the benchmark;
- decide audit-store technology, portal technology, or downstream analytical platform.

## 2.5 Known data facts and limits

**FACT.** The supplied schema summary records 27 legacy tables, 569 fields, 13 primary keys, two physical foreign keys, and 15 indexes. It also states that large activity/history tables exist, but legacy row counts are snapshots rather than future throughput, payload, retention, or capacity requirements. [I02]

**FACT.** The target data model distinguishes device, installation, session, subject projection, source, generation, cursor, run, event, batch, receipt, policy, application, rule revision, health, audit, deletion, and integration concepts. [I02]

**UNKNOWN.** No representative distribution is available for events, bytes, batches, retries, reconnect bursts, outage length, duplicate rate, late arrival, poison rate, query concurrency, report window, data skew, approved retention, RPO/RTO, or production hardware/service tier. [I02]

## 2.6 Assumptions used only to build the harness

| ID | ASSUMPTION / ESTIMATE | Why it is needed | Replacement evidence |
|---|---|---|---|
| A16-01 | **ASSUMPTION:** C#/.NET remains the benchmark-client family | accepted implementation default and comparable official providers exist | repository/runtime decision at execution time |
| A16-02 | **ASSUMPTION:** both engines can run on a common x64 Linux self-managed lab profile | reduces OS as a confounder; SQL Server and PostgreSQL support Linux | strategic platform/OS decision and exact support matrix |
| A16-03 | **ESTIMATE:** minimum seven independent paired repetitions, maximum fifteen | enough to expose run-to-run variance without pretending a universal sample-size proof | pilot variance and power analysis |
| A16-04 | **ESTIMATE:** 20-minute minimum warmup and 45-minute measured steady window | starting test budget | stability analysis and run-cost review |
| A16-05 | **ESTIMATE:** 24-hour soak | catches maintenance, memory, queue-age, and log-growth behavior missed by short runs | observed failure/maintenance timescales |
| A16-06 | **ESTIMATE:** monthly partitions are the first partition candidate | simple and common; no approved retention or volume exists | measured rows/bytes/late-arrival/maintenance windows |
| A16-07 | **ASSUMPTION:** immutable inbox payload is the sole durable source for materialization | accepted receipt model and simplest replay boundary | a later broker/change proposal with measured benefit |
| A16-08 | **ASSUMPTION:** reporting first coexists with ingestion on the same primary under bounded resource governance | simplest modular-monolith start | report SLO/load evidence justifying readable replicas or a separate analytical store |
| A16-09 | **ASSUMPTION:** database adapters may use engine-specific SQL but not engine-specific business semantics | required for a fair semantic comparison | ADR showing a product-specific feature materially lowers total risk without semantic drift |
| A16-10 | **ASSUMPTION:** all benchmark values are fictional and visibly non-production | privacy constraint | no expected replacement for this research lane |

## 2.7 Time-sensitive version snapshot

The architecture does not freeze point versions. Each run records the exact release selected under lifecycle and advisory policy.

| Candidate | FACT as of 31 July 2026 | Architectural treatment |
|---|---|---|
| PostgreSQL | current documented supported release is PostgreSQL 18.4, released 14 May 2026; major 18 is supported through 14 November 2030 [W01, W02] | pin exact major/minor, package, build, extensions, OS image, configuration, and support provider in evidence; rerun affected gates after change |
| SQL Server | current documented SQL Server 2025 update line includes CU7 build 17.0.4065.4 released 16 July 2026 [W14, W15] | pin exact CU, edition, OS/container image, feature set, trace flags/configuration, driver, and licensing topology; rerun affected gates after change |
| Npgsql | reviewed release v10.0.3, commit `d3768398c17877b3a916c3c4d87e8e11698991fc`, 27 May 2026 [R03] | runtime candidate only after dependency admission and provider-specific regression tests |
| Microsoft.Data.SqlClient | reviewed stable release v7.0.2, commit `8c70cec98444338ddb0b97be94c34fde93970241`, 25 June 2026 [R04] | runtime candidate only after dependency/transitive/native-SNI admission and regression tests |

## 2.8 Evidence hierarchy

The decision uses this order:

1. accepted UAM predecessor invariants;
2. executable UAM correctness and failure evidence;
3. actual restore/failover/operations evidence for the exact topology;
4. current primary vendor specifications and lifecycle documents;
5. exact open-source source/release review;
6. generic benchmark cross-checks;
7. vendor marketing, popularity, and synthetic headline scores — never decision proof.

No accepted-baseline change proposal is raised by this result. The baseline already requires a measured decision and keeps the engine provisional.

---

# 3. Recommended design with exact component responsibilities and trust boundaries

## 3.1 Design principle

**RECOMMENDATION.** Build one UAM-owned database comparison harness and one portable logical data contract. Engine adapters may implement physical DDL, leasing SQL, bulk APIs, telemetry collection, backup, restore, and failover controls, but they MUST NOT change receipt meaning, identity, realm authority, poison semantics, final business effects, query answers, retention rules, or evidence labels.

## 3.2 Components

| Component | Exact responsibility | Prohibited responsibility | Trust/evidence boundary |
|---|---|---|---|
| `Uam.DbBench.Cli` | strict command parsing, manifest validation, run orchestration, exit codes, evidence root | embedded credentials, production address, business oracle, hidden retries | local trusted T1 runner |
| `Uam.DbBench.Generator` | deterministic fictional realms/installations/batches/events/late arrivals/retries/reports from seed | production-derived values/distributions, wall clock, implicit randomness | T1 package boundary |
| `Uam.DbBench.Oracle` | independently calculate expected receipts, effects, conflicts, work states, aggregates, query results, retention and restore ledger | call either engine adapter, production mapping logic, or inspect actual output before truth creation | independent truth authority |
| `Uam.DbBench.Core` | logical commands, states, contracts, error taxonomy, common metrics, workload schedule | engine SQL, provider types, tuning knobs | portable semantic boundary |
| `Uam.DbBench.Postgres` | PostgreSQL DDL/type map, Npgsql binary COPY, lease SQL, RLS/session context, telemetry, backup/failover controls | UAM business decisions or changed expected result | engine-specific adapter |
| `Uam.DbBench.SqlServer` | SQL Server DDL/type map, `SqlBulkCopy`, lease SQL, RLS/session context, telemetry, backup/failover controls | UAM business decisions or changed expected result | engine-specific adapter |
| `Uam.DbBench.Faults` | test-only fault scheduling and process/network/storage/database actions | production build inclusion, arbitrary customer host mutation | isolated destructive lab only |
| `Uam.DbBench.Analysis` | raw validation, pairing, confidence intervals, effect ratios, TCO, weighted scoring, sensitivity | delete failed runs, substitute missing metrics, declare winner when hard gate failed | read-only evidence consumer |
| `Uam.DbBench.Evidence` | immutable manifests, hash tree, redaction, raw samples, normalized metrics, cleanup receipt, accessible report | secrets, payload values, production data, mutable “latest” pointer as proof | publication boundary |
| Provisioner | create exact isolated candidate topology and storage/network classes | select unequal hardware silently, reuse dirty data state | infrastructure evidence boundary |
| Database runtime role | execute fixed parameterized UAM commands for one authenticated realm context | DDL, bypass RLS, cross-realm context, arbitrary SQL | least-privileged application boundary |
| Migration role | apply signed/reviewed schema versions and static security policy | ordinary ingestion/reporting, unreviewed dynamic SQL | privileged maintenance boundary |
| Backup/restore role | run bounded backup, verification, restore and evidence operations | read application payload for support, change business results | operations boundary |
| Decision aggregator | enforce hard gates, scoring/sensitivity, owner fields, expiry | accept manual pass, waive zero-tolerance invariant, select on popularity | ADR gate boundary |

## 3.3 Trust-boundary sequence

```text
T1 workload package + immutable run manifest
  -> strict schema/hash/classification validation
  -> deterministic generator
  -> independent oracle ledger
  -> isolated load client
  -> authenticated ingestion API stub
  -> server-derived realm/installation context
  -> engine-neutral inbox command
  -> engine adapter transaction
       durable inbox + stable receipt + work row
  -> response or response loss
  -> replay same batch identity
  -> leased materializer
       immutable inbox -> temporary bulk stage -> identity ledger
       -> facts/aggregates/quarantine -> terminal work state
  -> report/retention/backup/failover workload
  -> normalized engine telemetry + raw operation samples
  -> oracle reconciliation
  -> cleanup/revert proof
  -> paired statistical/TCO/sensitivity analysis
  -> strict database ADR gate
```

The database never authenticates an endpoint directly. The server identity boundary supplies immutable authenticated realm and installation context. Payload realm/device fields are structurally absent or hostile-test inputs that cannot override context.

## 3.4 Comparable schema/workload specification — mandatory artifact

### 3.4.1 Design rules

1. Every business primary key, foreign key, unique key, query predicate, cache key, lease, and job begins with `realm_id` unless a table is explicitly global product metadata.
2. `batch_id` and `event_id` are opaque stable UAM identifiers. Database sequences may optimize storage but never replace external identity.
3. Receipt and inbox insertion are one transaction.
4. Inbox body and digests are immutable after receipt.
5. Work lease columns live in a narrow table, avoiding repeated updates to the large inbox payload row.
6. Event identity and final effect uniqueness are independent of time partitioning.
7. Facts contain minimized typed values only. The benchmark uses visibly fictional site/application/time values.
8. Aggregates are server-derived and reproducible from facts/effect ledger.
9. Validation, quarantine, materialization, visibility, integration, deletion, and receipt remain distinct states.
10. No trigger, procedure, or computed default may infer realm, identity, receipt, or business semantics from payload.

### 3.4.2 Logical entities

| Entity | Purpose | Mutability | Required key/invariant |
|---|---|---|---|
| `ingest_batch` | immutable compressed durable inbox payload and custody metadata | insert only except protected administrative hold flag | unique `(realm_id, installation_id, batch_id)`; same identity/different digest is conflict |
| `custody_receipt` | stable durable-custody evidence | insert only | one stable receipt per accepted batch identity and digest |
| `ingest_work` | narrow worker state and lease | bounded state transitions | one row per inbox batch; lease token/fence required for terminal write |
| `event_identity` | global natural identity and one-effect ledger | insert once; terminal effect metadata may be filled exactly once in same materialization transaction | unique `(realm_id, installation_id, event_id)` independent of partition grain |
| `activity_fact` | typed minimized fact | append only; correction requires explicit supersession contract | FK to identity ledger; partition candidate by time |
| `realm_day_application_aggregate` | report aggregate | deterministic upsert/rebuild | unique realm/day/application/output-profile tuple |
| `quarantine_record` | finite value-free validation/poison result | append only/status transition | references batch/event identity without copying forbidden payload |
| `processing_attempt` | bounded operational attempt evidence | append only with retention | finite reason/stage/latency/resource fields; no exception text |
| `retention_tombstone` | dropped-partition/deletion evidence | append only | object/digest/range/reason/authorization/readiness |
| `schema_evidence` | migration/schema/config digest and compatibility | append only | exact migration sequence and candidate identity |

### 3.4.3 Normative logical DDL

The following is a portable contract, not copy-paste production DDL. Physical types and index options are adapter-owned and recorded in evidence.

```sql
CREATE TABLE ingest_batch (
    realm_id               UUID        NOT NULL,
    installation_id        UUID        NOT NULL,
    batch_id               UUID        NOT NULL,
    receipt_id             UUID        NOT NULL,
    contract_version       VARCHAR(32) NOT NULL,
    body_codec             VARCHAR(32) NOT NULL,
    event_count            INTEGER     NOT NULL,
    uncompressed_bytes     BIGINT      NOT NULL,
    compressed_bytes       BIGINT      NOT NULL,
    content_digest         BINARY_32   NOT NULL,
    wire_digest            BINARY_32   NOT NULL,
    compressed_body        BINARY_LARGE NOT NULL,
    received_at_utc        TIMESTAMP_UTC NOT NULL,
    authenticated_epoch    BIGINT      NOT NULL,
    custody_domain_id      VARCHAR(64) NOT NULL,
    hold_state             VARCHAR(32) NOT NULL,
    PRIMARY KEY (realm_id, installation_id, batch_id),
    UNIQUE (realm_id, receipt_id),
    CHECK (event_count >= 0),
    CHECK (compressed_bytes >= 0 AND uncompressed_bytes >= compressed_bytes)
);

CREATE TABLE custody_receipt (
    realm_id               UUID        NOT NULL,
    installation_id        UUID        NOT NULL,
    batch_id               UUID        NOT NULL,
    receipt_id             UUID        NOT NULL,
    content_digest         BINARY_32   NOT NULL,
    wire_digest            BINARY_32   NOT NULL,
    custody_state          VARCHAR(32) NOT NULL,
    custody_domain_id      VARCHAR(64) NOT NULL,
    durable_at_utc         TIMESTAMP_UTC NOT NULL,
    PRIMARY KEY (realm_id, receipt_id),
    UNIQUE (realm_id, installation_id, batch_id),
    FOREIGN KEY (realm_id, installation_id, batch_id)
      REFERENCES ingest_batch(realm_id, installation_id, batch_id),
    CHECK (custody_state = 'DURABLY_RECEIVED')
);

CREATE TABLE ingest_work (
    realm_id               UUID        NOT NULL,
    installation_id        UUID        NOT NULL,
    batch_id               UUID        NOT NULL,
    received_sequence      BIGINT      NOT NULL,
    state                   VARCHAR(32) NOT NULL,
    available_at_utc       TIMESTAMP_UTC NOT NULL,
    lease_token            UUID        NULL,
    lease_owner_class      VARCHAR(32) NULL,
    lease_until_utc         TIMESTAMP_UTC NULL,
    attempt_count           INTEGER     NOT NULL,
    terminal_reason        VARCHAR(64) NULL,
    completed_at_utc       TIMESTAMP_UTC NULL,
    row_version             BIGINT      NOT NULL,
    PRIMARY KEY (realm_id, installation_id, batch_id),
    FOREIGN KEY (realm_id, installation_id, batch_id)
      REFERENCES ingest_batch(realm_id, installation_id, batch_id),
    UNIQUE (realm_id, received_sequence)
);

CREATE TABLE event_identity (
    realm_id               UUID        NOT NULL,
    installation_id        UUID        NOT NULL,
    event_id               UUID        NOT NULL,
    event_identity_id      BIGINT_GENERATED NOT NULL,
    source_natural_digest  BINARY_32   NOT NULL,
    payload_digest         BINARY_32   NOT NULL,
    effect_kind            VARCHAR(32) NOT NULL,
    first_batch_id         UUID        NOT NULL,
    first_seen_at_utc      TIMESTAMP_UTC NOT NULL,
    PRIMARY KEY (realm_id, installation_id, event_id),
    UNIQUE (realm_id, event_identity_id),
    CHECK (effect_kind IN ('FACT','CONSUMED_NO_EVENT','QUARANTINED'))
);

CREATE TABLE activity_fact (
    realm_id               UUID        NOT NULL,
    fact_partition_time    TIMESTAMP_UTC NOT NULL,
    event_identity_id      BIGINT      NOT NULL,
    installation_id        UUID        NOT NULL,
    event_id               UUID        NOT NULL,
    application_id         UUID        NULL,
    site_value             VARCHAR_BOUNDED NULL,
    observed_bucket_utc    TIMESTAMP_UTC NULL,
    output_profile_id      VARCHAR(64) NOT NULL,
    interpretation_digest  BINARY_32   NOT NULL,
    materialized_at_utc    TIMESTAMP_UTC NOT NULL,
    PRIMARY KEY (realm_id, fact_partition_time, event_identity_id),
    UNIQUE (realm_id, fact_partition_time, installation_id, event_id),
    FOREIGN KEY (realm_id, event_identity_id)
      REFERENCES event_identity(realm_id, event_identity_id)
) PARTITION_BY_RANGE (fact_partition_time);
```

### 3.4.4 Type mapping

| Logical type | PostgreSQL candidate | SQL Server candidate | Equality rule |
|---|---|---|---|
| `UUID` | `uuid` | `uniqueidentifier` | canonical 16-byte UUID; no engine sort order used as business order |
| `BINARY_32` | `bytea` with exact-length check | `binary(32)` | byte equality |
| `BINARY_LARGE` | `bytea` | `varbinary(max)` | byte equality; not queried by payload value |
| `TIMESTAMP_UTC` | `timestamptz` | `datetime2(7)` plus UTC-only contract | normalized UTC instant and declared precision |
| `BIGINT_GENERATED` | `bigint GENERATED ... AS IDENTITY` | `bigint IDENTITY` or sequence | storage surrogate only |
| `VARCHAR_BOUNDED` | `text` plus byte/scalar checks or bounded `varchar` | bounded `nvarchar`/`varchar` selected by field contract | exact field-specific Unicode/collation contract; no default database collation authority |
| boolean | `boolean` | `bit` | explicit true/false only |
| JSON metadata, if retained | `jsonb` only for non-authoritative bounded evidence | `nvarchar(max)` with JSON check only for non-authoritative bounded evidence | canonical contract remains external; JSON is not identity or query authority |

### 3.4.5 Partition variants

Every engine runs the same three physical variants:

- `P0_NONE` — no fact partitioning; control for overhead and small-data simplicity.
- `P1_RECEIVED_MONTH` — range by server receipt/materialization month; simple operational locality, but not necessarily aligned to business retention.
- `P2_OCCURRED_MONTH` — range by approved event bucket month; aligns to event-time reporting/retention but stresses late arrivals and old partitions.

**ESTIMATE.** Month is the first candidate grain. The harness also generates a projection for weekly and daily partitions without deploying them. A real grain is selected only after rows/bytes/late-arrival/maintenance evidence and approved retention exist.

### 3.4.6 Normative comparable workload specification

The workload is a versioned logical schedule. Both adapters receive the same canonical batches, event identities, arrival times, fault markers, query parameters, worker counts, report schedules, retention authorizations, and expected results. Engine-specific setup time and maintenance are measured but cannot change the logical schedule.

| Workload ID | Logical behavior | Replaceable inputs | Required outputs | Why it exists |
|---|---|---|---|---|
| `WLD-00-CORRECTNESS` | low-rate receipt, replay, duplicate, conflicting duplicate, validation, quarantine, materialization and query | fixture counts only | exact receipt/effect/work/query ledger | prove semantics before speed |
| `WLD-01-STEADY` | stable bounded endpoint arrivals with ordinary batch and event-size distribution | rates, bytes, events/batch, realm/install counts | durable receipt and materialization rates/latencies/resources | normal operating point |
| `WLD-02-RECONNECT` | synchronized reconnect burst after fictional outage while steady arrivals continue | outage duration, reconnect spread, backlog and burst multiplier | queue age, backlog-clear time, latency, resource and retry distributions | accepted offline/retry shape |
| `WLD-03-DUPLICATE` | exact batch and event replay at controlled duplicate rates, including response loss | duplicate/replay percentages and timing | same receipt, one final effect, lookup/log cost | at-least-once and idempotency |
| `WLD-04-CONFLICT` | same stable identity with a different digest/content | conflict rate and placement | explicit conflict/hold, zero overwrite | identity integrity |
| `WLD-05-POISON` | structurally valid custody payload that cannot be semantically materialized plus transient failures | poison/transient mix, retry policy | bounded attempts, quarantine or recovery, unaffected peers | poison containment |
| `WLD-06-LATE` | old event-time rows arriving in current receipt-time batches | lateness distribution and maximum permitted lateness | correct partition/routing/report/retention outcome | partition and policy choice |
| `WLD-07-SKEW` | hot realm/application/time buckets and quiet peers | skew distribution and hot-set rotation | fairness, lock/index/plan and noisy-neighbor evidence | real-world concentration risk |
| `WLD-08-REPORT` | Q01–Q10 at controlled concurrency over facts and governed aggregates | query mix, lookback, concurrency, freshness target | canonical result hashes and interference/freshness | report coexistence |
| `WLD-09-MAINTENANCE` | ingestion/materialization/reporting while statistics, index, vacuum/ghost, partition and backup work runs | cadence and candidate operations | blocking, duty cycle, log/write and recovery evidence | on-call/maintenance cost |
| `WLD-10-RETENTION` | authorized time-range removal with adjacent realms, holds, late rows and restore | retention clock/grace/hold fixtures | exact tombstone/deletion/visibility result | lifecycle safety |
| `WLD-11-BACKUP-RESTORE` | continuous load around backup marker, isolated full/PITR restore and validation | approved backup classes and targets | RPO/RTO and complete oracle reconciliation | durable recovery |
| `WLD-12-FAILOVER` | receipt/materialization/report/backup load during planned and unplanned topology faults | exact HA/fault schedule | fencing, client recovery, one-effect and RPO/RTO evidence | HA fitness |
| `WLD-13-SATURATION` | stepwise offered-load and worker/connection sweeps beyond the stable knee | levels and duration from pilot plan | sustainable capacity, queue slope, latency and failure mode | headroom/capacity |
| `WLD-14-SOAK` | mixed stable workload long enough to exercise background maintenance and resource retention | duration/cadence, initially 24 hours as ESTIMATE | bloat/log/queue/memory/session/plan stability | durability of operation, not just peak speed |

Every workload manifest MUST declare:

- canonical input-package and oracle digests;
- fictional realm, installation, batch and event cardinalities;
- arrival distribution, batch/event byte classes, duplicate/retry/late/poison/skew parameters;
- worker/connection/report schedules and cancellation behavior;
- warmup, measurement, cooldown, repetition and pairing plan;
- expected terminal state and hard invariants;
- allowed engine-specific implementation points;
- observability/cardinality and canary profile;
- reset, backup, restore and cleanup requirements;
- which numerical inputs are **ESTIMATE**, measured metadata, or approved **HUMAN DECISION**.

The adapter MUST reject a manifest when it cannot represent the semantics. It MUST NOT silently approximate, drop a workload class, rewrite a query, change the transaction boundary, or reduce durability.

## 3.5 Receipt transaction

The ingestion boundary MUST execute this semantic transaction:

```text
1. Authenticate endpoint/gateway and derive immutable realm, installation,
   enrollment epoch and credential status outside the payload.
2. Validate contract, compressed/uncompressed bounds, digest format and
   declared counts before starting the database transaction.
3. BEGIN.
4. Look up (realm, installation, batch_id).
5. If absent:
     insert immutable ingest_batch;
     create stable receipt_id;
     insert custody_receipt = DURABLY_RECEIVED;
     insert ingest_work = READY;
   If present and both digests match:
     return the previously committed receipt without creating another effect;
   If present and a digest differs:
     record a finite security conflict and do not accept new bytes.
6. COMMIT within the declared custody failure domain.
7. Only after successful COMMIT return the receipt.
8. If the response is lost, the endpoint retries the same batch; the server
   returns an equivalent committed receipt.
```

No materialization, report, integration, or portal work is part of this receipt transaction.

## 3.6 Durable inbox leasing

### 3.6.1 Common semantics

A lease is a recoverable scheduling hint, not ownership of business truth.

- Eligible states are finite and exact.
- Ordering is `(available_at_utc, received_sequence, batch_id)`.
- Claim returns a new random lease token and bounded expiry.
- Terminal update requires the exact token and non-expired/fenced lease.
- A crashed worker loses the lease; another worker may retry the immutable inbox.
- Clock and lease duration are test inputs. Database server time is used consistently within one profile.
- A lease cannot acknowledge, delete, or mutate inbox bytes.
- Starvation and hot-realm monopolization are measured; no fairness claim comes from `SKIP LOCKED` or `READPAST` alone.

### 3.6.2 PostgreSQL candidate

```sql
WITH candidate AS (
    SELECT realm_id, installation_id, batch_id
    FROM ingest_work
    WHERE state = 'READY'
      AND available_at_utc <= clock_timestamp()
    ORDER BY available_at_utc, received_sequence, batch_id
    FOR UPDATE SKIP LOCKED
    LIMIT @take
)
UPDATE ingest_work AS w
SET state = 'LEASED',
    lease_token = @lease_token,
    lease_owner_class = @owner_class,
    lease_until_utc = clock_timestamp() + @lease_interval,
    attempt_count = attempt_count + 1,
    row_version = row_version + 1
FROM candidate AS c
WHERE w.realm_id = c.realm_id
  AND w.installation_id = c.installation_id
  AND w.batch_id = c.batch_id
RETURNING w.realm_id, w.installation_id, w.batch_id,
          w.lease_token, w.lease_until_utc, w.row_version;
```

PostgreSQL documents that `SKIP LOCKED` provides an inconsistent view for general queries but can be useful for queue-like tables. UAM treats that as a scheduling primitive only. [W04]

### 3.6.3 SQL Server candidate

```sql
;WITH candidate AS (
    SELECT TOP (@take) *
    FROM dbo.ingest_work WITH (UPDLOCK, READPAST, ROWLOCK, INDEX(ix_work_ready))
    WHERE state = 'READY'
      AND available_at_utc <= SYSUTCDATETIME()
    ORDER BY available_at_utc, received_sequence, batch_id
)
UPDATE candidate
SET state = 'LEASED',
    lease_token = @lease_token,
    lease_owner_class = @owner_class,
    lease_until_utc = DATEADD(millisecond, @lease_ms, SYSUTCDATETIME()),
    attempt_count = attempt_count + 1,
    row_version = row_version + 1
OUTPUT inserted.realm_id, inserted.installation_id, inserted.batch_id,
       inserted.lease_token, inserted.lease_until_utc, inserted.row_version;
```

SQL Server documents `READPAST` as primarily useful for work queues; it skips row locks rather than page locks. The experiment must detect page locks, escalation, missed eligibility, and starvation rather than assuming the hint guarantees fairness. [W17]

## 3.7 Bulk materialization

**RECOMMENDATION.** The immutable inbox remains the durable source. The worker parses and validates a bounded batch, loads an engine-local temporary staging table on the same connection, then performs one final transaction:

1. verify lease token and batch digest;
2. insert new event identities and compare existing digests;
3. classify exact retries versus identity conflicts;
4. insert typed facts/no-event/quarantine effects;
5. update aggregates;
6. mark work terminal using the lease token;
7. commit.

The temporary stage may be lost without business loss because it can be rebuilt from the inbox.

| Engine | Bulk candidate | Required controls |
|---|---|---|
| PostgreSQL | Npgsql binary `COPY` into a session temporary table [W03, R03] | exact column order/types, bounded row count/bytes, no unlogged permanent business table, same connection through final transaction, provider cancellation tests |
| SQL Server | `SqlBulkCopy` into a same-session temporary table [W16, R04] | explicit column mappings, bounded batch, options recorded, same connection through final transaction, no accidental trigger/constraint difference, cancellation tests |

A row-by-row implementation is retained only as a small correctness comparator. It is not the production candidate if bulk materially improves resource use without changing semantics.

## 3.8 Realm isolation

Application authorization is primary; database row-level security is defense in depth.

### PostgreSQL profile

- application runtime role is not table owner, superuser, or `BYPASSRLS`;
- RLS is enabled and forced on every realm table;
- transaction-scoped realm context is established after connection checkout and cleared by transaction end;
- policies compare the row's `realm_id` with the authenticated context;
- security-definer functions are avoided or strictly pinned, schema-qualified, and reviewed;
- connection pooling, prepared statements, failed transactions, retries, and cancellation are hostile-tested. [W07–W10]

### SQL Server profile

- application runtime principal lacks schema/DDL and RLS bypass authority;
- `sp_set_session_context` establishes a read-only realm key for the checked-out connection/transaction;
- RLS filter predicates and block predicates cover reads and writes;
- pool checkout verifies/sets context before any query; pool return and exception paths are tested;
- modules using `EXECUTE AS`, ownership chaining, cross-database access, or elevated signed modules require separate review. [W19–W21]

### Common negative gate

For every query and mutation family, the harness uses two fictional realms with colliding installation, batch, event, application, time, and external-reference values. Any cross-realm row, count, timing-dependent authorization, cache mix, job claim, or report result is a hard failure.

## 3.9 Report coexistence

The base profile runs bounded reports on the primary because that is the simplest modular-monolith topology. It measures:

- report latency and timeout;
- ingestion throughput and p95/p99 latency change;
- queue oldest age;
- CPU, memory, I/O, temp space, locks/waits, WAL/log bytes;
- plan stability and statistics state;
- replica lag in optional read-replica profiles.

Optional profiles are evaluated separately:

- PostgreSQL physical read-only standby;
- SQL Server Enterprise readable availability-group secondary;
- SQL Server Standard Basic availability group without assuming a readable reporting secondary;
- managed-service read replicas where supported.

A readable secondary may change SQL Server licensing and failover assumptions. Cost and architecture must use the exact edition/topology rather than a generic “SQL Server” label. [W13, W22–W24, W30–W33]

## 3.10 Observability and cardinality

The harness emits raw per-operation records and bounded aggregated metrics. Allowed dimensions are finite:

```text
run_id
engine_profile_id
workload_profile_id
operation_family
result_class
topology_class
partition_variant
concurrency_level
```

Forbidden labels and ordinary log fields include realm, installation, device, batch, event, application, site, URL, payload digest, SQL parameter value, connection string, address, user, certificate, or arbitrary exception text.

Database-native query identifiers and normalized statement fingerprints may be recorded; literal SQL parameter values and payload-bearing query logs are prohibited. The evidence report is generated as JSON, CSV/Parquet, Markdown, and accessible HTML. Status is never conveyed by color alone; tables include text labels and machine-readable fields.

## 3.11 Feature flags and kill switches

All flags are release-owned, finite, narrowing, and auditable:

| Flag | Disabled behavior | Safety rule |
|---|---|---|
| `db.ingestion.accept` | API refuses new custody; no receipt | cannot acknowledge while disabled |
| `db.worker.lease` | no new leases; inbox retained | active worker may finish only under current lease/policy |
| `db.worker.materialize` | leased work returns/requeues; inbox retained | cannot skip effects and mark complete |
| `db.report.read` | reports fail with finite unavailable state | does not affect custody/materialization |
| `db.maintenance.partition` | partition creation/drop stops | missing target partition fails closed, never falls into an ungoverned default |
| `db.retention.apply` | no deletion/drop | default for production until retention/deletion approval |
| `db.backup.start` | no new backup | does not delete prior backup or change receipt |
| `db.failover.test` | destructive failover control absent | lab-only artifact; structurally absent from production |
| `db.cleanup.payload` | no inbox-payload cleanup | production default until receipt/RPO/restore/deletion gates approve |

## 3.12 Configuration ownership

Configuration is divided into:

- **portable semantic configuration:** contract versions, state vocabulary, limits, workload IDs, hard gates, oracle rules;
- **engine profile:** DDL, index options, memory, parallelism, durability, isolation, autovacuum/maintenance, temp, checkpoint/log, statistics, backup, HA;
- **environment profile:** OS, CPU, memory, storage, IOPS/throughput/latency class, network, virtualization, service tier;
- **human decision profile:** required demand, retention, RPO/RTO, report priority, budget, skills, support, scoring weights.

Every run records all four digests. A tuning change creates a new engine-profile ID; it never edits prior evidence.

---

# 4. Alternatives, rejection reasons, and conditions that would change the choice

## 4.1 Alternatives register

| Alternative | Decision now | Reason | Condition that would change it |
|---|---|---|---|
| Select PostgreSQL immediately because it is the reference | **REJECTED** | baseline explicitly keeps production selection measurement-gated; no restore, capacity, skills, or operations proof | paired hard gates, robust score/sensitivity, TCO/skills approval, owner ADR |
| Select SQL Server immediately because the legacy system used it or skills may exist | **REJECTED** | legacy direct SQL and schema are not target authority; current skills and licensing evidence are unknown | same paired gate and human approval; transition cost may legitimately influence score |
| Let a generic benchmark choose | **REJECTED** | TPROC-C, TPC-C-like, pgbench, or BenchBase workloads do not encode UAM custody, replay, realm, poison, reports, late arrival, retention, or restore semantics | may remain a secondary hardware/engine sanity cross-check only |
| Use different schemas optimized for each engine | **REJECTED FOR PRIMARY DECISION** | changes semantics and makes comparison non-causal | after a portable baseline, equally budgeted engine-specific tuned variants may compete if results remain semantically identical |
| Use only default configurations | **REJECTED AS SOLE RESULT** | defaults are not production design and can favor one candidate accidentally | run defaults as reproducibility baseline, then one preregistered equally budgeted tuned profile per candidate |
| Tune only the apparent loser | **REJECTED** | creates asymmetric effort and hindsight bias | tuning budget, allowed knobs, review, and number of iterations are fixed before results are visible |
| Compare PostgreSQL on Linux with SQL Server on Windows and attribute difference to engine | **REJECTED FOR BASE PROFILE** | OS becomes a confounder | separate production-shaped OS profiles may follow; conclusions must identify engine-plus-OS, not engine alone |
| Compare managed PostgreSQL with self-managed SQL Server, or vice versa | **REJECTED FOR ENGINE CLAIM** | includes service/operations differences | allowed as a separately named deployment-option comparison after common self-managed semantics are established |
| Use an external broker before the relational inbox | **REJECTED BY BASELINE** | adds a failure domain and duplicate custody semantics without measured need | trigger when measured throughput, replay, fan-out, maintenance isolation, or failure containment cannot meet approved requirements and an ADR proves lower total risk |
| Put mutable lease fields on the large inbox row | **REJECTED AS DEFAULT** | repeated updates increase log/WAL amplification and bloat/maintenance pressure | may be a control variant if it demonstrably lowers complexity without material write amplification or lock contention |
| Put event dedupe uniqueness directly on a time-partitioned fact table | **REJECTED AS COMMON BASELINE** | partitioned unique constraints require partition keys, making event identity depend on unsettled time grain | only if event identity contract deliberately includes the partition key and replay/late-arrival migration consequences are approved |
| One database/schema/table per realm | **REJECTED INITIALLY** | operational object explosion, migration complexity, pool pressure, and uneven sizing without evidence | a small number of legally/operationally isolated realms, extreme noisy-neighbor evidence, or separate-key/restore requirements may justify a dedicated topology |
| Hash partition by realm first | **DEFERRED** | may spread hotspots but complicates time retention and object count; no skew evidence | measured realm hotspot or latch/index contention after portable time-partition variants |
| No partitioning | **ACCEPT AS CONTROL, NOT PRESELECTED PRODUCTION** | simplest and may win at actual scale | choose if measured retention/maintenance/restore and table size stay within approved windows |
| Partition by receipt time only | **CANDIDATE** | operationally simple and stable under late arrivals | choose if retention/report semantics permit and tests outperform event-time partitioning |
| Partition by event time only | **CANDIDATE** | aligns with event-time reports/retention but reopens old partitions for late arrivals | choose if approved retention semantics require it and old-partition maintenance remains acceptable |
| Use unlogged PostgreSQL or minimally logged SQL Server paths as headline ingest result | **REJECTED** | durability and conditions differ; can create unfair log-amplification results | separate exploratory profile only, never custody or ADR result unless equal durable semantics are proved |
| Run reports without resource governance | **REJECTED** | an unbounded report can invalidate ingestion comparison and production safety | query corpus, timeouts, concurrency, resource limits, and cancellation are fixed and measured |
| Require a read replica from day one | **DEFERRED** | adds HA/licensing/lag/operations cost before report need is measured | report coexistence fails approved latency/headroom or failure-isolation gate |
| Use production data for realism | **REJECTED** | violates research constraints and creates disclosure, deletion, and reproducibility risk | no expected change for benchmark; approved metadata-only distributions may parameterize fictional generation later |
| Dual-write both production engines during migration | **REJECTED AS DEFAULT** | creates two truths, hard reconciliation, and double operations burden | a separately governed transition ADR with one authoritative source, bounded duration, replay/reconciliation proof, rollback, and deletion plan |
| Choose on license price alone | **REJECTED** | omits support, people, downtime, HA, backup, migration, OS, tooling, and operational risk | price remains one input in complete TCO and sensitivity |
| Choose on current team familiarity alone | **REJECTED** | familiarity can be stale or incomplete and is not durability proof | measured skills/runbook exercise is a legitimate weighted decision input after hard gates |
| Choose the faster engine even if restore or realm isolation fails | **REJECTED** | correctness and containment are hard gates | no condition; failed hard gate disqualifies the profile |

## 4.2 Benchmark anti-patterns

The following invalidate a run or its use in the ADR:

1. different semantic schemas, indexes, durability, isolation, data, query corpus, hardware, or client placement;
2. row-by-row loading on one candidate and bulk loading on the other;
3. warm-cache-only results, one repetition, means without distributions, or discarded failed runs;
4. client and database on the same host for one candidate only;
5. a fresh empty database versus an aged/bloated/fragmented peer;
6. tuning after viewing results without preregistration and equal budget;
7. PostgreSQL community engine cost compared with SQL Server Enterprise performance while pricing Standard;
8. SQL Server Developer edition performance treated as licensed production capacity without checking intended edition limits and features;
9. a readable SQL Server secondary counted as free passive failover without licensing review;
10. unlogged/minimal-logging/no-sync settings on one side only;
11. disabled RLS, weaker commit durability, relaxed receipt, or omitted backup to improve throughput;
12. measuring only ingestion while excluding materialization, reports, vacuum/index work, backup, retention, and failover;
13. calling 6,000 connected identities a capacity test without events, bytes, retries, outage, queries, retention, and objectives;
14. `RESTORE VERIFYONLY`, backup checksum, or file existence treated as an actual restore;
15. treating a managed-service SLA or vendor benchmark as UAM failover evidence;
16. hiding retries, first failures, maintenance pauses, replica lag, or cleanup residue;
17. using payload values, production identifiers, or high-cardinality realm/device metrics;
18. changing error classifications per engine so one appears more successful;
19. accepting HTTP success as custody without committed receipt evidence;
20. allowing a worker to create a new batch/event identity after ambiguity.

## 4.3 Conditions for a baseline change proposal

A full accepted-baseline change proposal is required if implementation evidence claims UAM needs:

- endpoint SQL or database credentials;
- a receipt outside the relational durable inbox failure domain;
- an external broker as the first custody boundary;
- engine-specific business identity or different final-effect semantics;
- payload-derived realm authority;
- automatic loss of unacknowledged data;
- raw source values or reversible derivatives in the server benchmark/evidence;
- multiple ordinary business effects per stable event outside an explicit correction model;
- a topology that cannot restore acknowledged data or preserve deletion readiness.

The proposal must name the affected accepted decision, new primary evidence, smallest falsifying experiment, security/privacy/realm/durability impact, alternatives, migration consequence, rollback, and ADR action.

# 5. Interfaces/protocols and example contracts or schemas

## 5.1 Normative boundary contracts

The benchmark and later implementation MUST keep these contracts separate:

| Contract | Producer | Consumer | Durable/atomic meaning | Must not mean |
|---|---|---|---|---|
| `IngestBatchCommand` | ingestion API after authentication | database application service | request to create/replay one durable inbox batch | receipt, validation, materialization, report visibility |
| `CustodyReceipt` | database application service after commit | endpoint transport/API | exact batch bytes are in declared durable custody | facts accepted, reports updated, backup complete |
| `LeaseRequest/LeaseGrant` | worker scheduler | materializer | temporary fenced permission to attempt one batch | ownership of event identity or right to ACK/delete |
| `MaterializationResult` | materializer transaction | processing coordinator | one stable terminal effect per event and terminal/retry batch state | receipt or endpoint ACK |
| `QueryCorpusRequest/Result` | benchmark/report client | query API/DB adapter | exact fictional report result and bounded performance sample | business approval or production report priority |
| `BackupEvidence` | backup controller | ADR gate | backup artifact, configuration, digests and verification state | successful restore |
| `RestoreEvidence` | restore controller + oracle | ADR gate | actual restored database reconciled to selected recovery point | every disaster is covered |
| `FailoverEvidence` | topology controller + oracle | ADR gate | exact planned/unplanned failure state and recovery | general cloud/vendor SLA proof |
| `RetentionPlan/Result` | signed lab manifest | maintenance adapter | fictional range selected, detached/dropped/deleted, reconciled | production retention authorization |
| `RunEvidence` | harness | analysis/ADR gate | immutable inputs, raw outputs, first failures and cleanup | permission to hide excluded or failed runs |

## 5.2 `IngestBatchCommand`

```json
{
  "contract": "uam.server.ingest-batch-command",
  "version": "1.0.0",
  "authenticatedContextRef": "context:fictional-run-local",
  "batchId": "019d0000-0000-7000-8000-000000000101",
  "contractVersion": "1.0.0",
  "bodyCodec": "ZSTD_NDJSON_V1",
  "eventCount": 128,
  "uncompressedBytes": 65536,
  "compressedBytes": 8192,
  "contentDigest": "sha-256:fictional-content-digest",
  "wireDigest": "sha-256:fictional-wire-digest",
  "compressedBodyRef": "fixture-object:batch-000101"
}
```

Normative rules:

- realm, installation, device, enrollment epoch, and assurance are supplied by authenticated server context, not trusted from this body;
- `compressedBodyRef` is a harness-local reference; production uses bounded bytes, never a path supplied by the endpoint;
- `batchId`, digests, codec, counts, and bytes are immutable for the operation;
- duplicate member, unknown authority-bearing field, wrong case, unsupported version/codec, digest mismatch, or bounds violation is rejected before custody;
- same authenticated identity plus same `batchId` and same digests is a replay; a different digest is a security conflict;
- no error includes payload, URL, site, user, realm, installation, or raw exception text.

## 5.3 `CustodyReceipt`

```json
{
  "contract": "uam.server.custody-receipt",
  "version": "1.0.0",
  "receiptId": "019d0000-0000-7000-8000-000000000201",
  "batchId": "019d0000-0000-7000-8000-000000000101",
  "contentDigest": "sha-256:fictional-content-digest",
  "wireDigest": "sha-256:fictional-wire-digest",
  "custodyState": "DURABLY_RECEIVED",
  "custodyDomainId": "DB_PROFILE_DECLARED_DOMAIN_V1",
  "durableAtUtc": "2026-07-31T12:00:00.000000Z",
  "receiptContractVersion": "1.0.0"
}
```

A receipt is valid only when all fields match the committed inbox row under the authenticated context. Equivalent replay returns the same `receiptId` or a contract-defined equivalent proof bound to the same batch/digests. A response generated before commit, from a replica that cannot prove the required domain, or from an in-memory queue is invalid.

## 5.4 Work lease contract

```json
{
  "contract": "uam.server.work-lease",
  "version": "1.0.0",
  "workKey": {
    "realmAlias": "fictional-realm-a",
    "installationAlias": "fictional-installation-001",
    "batchId": "019d0000-0000-7000-8000-000000000101"
  },
  "leaseToken": "019d0000-0000-7000-8000-000000000301",
  "leaseOwnerClass": "MATERIALIZER",
  "leasedAtUtc": "2026-07-31T12:00:01Z",
  "leaseUntilUtc": "2026-07-31T12:00:31Z",
  "rowVersion": 7
}
```

The production contract contains opaque IDs rather than display aliases. The benchmark evidence substitutes fictional aliases only in human-readable reports. Terminal transition requires the exact key, token, and expected row version or a stronger engine-native fence. Lease expiry alone does not authorize a stale worker to commit.

## 5.5 Materialization effect contract

The oracle and both adapters use the same effect vocabulary:

```json
{
  "eventId": "019d0000-0000-7000-8000-000000000401",
  "sourceNaturalDigest": "sha-256:fictional-natural-key",
  "payloadDigest": "sha-256:fictional-minimized-payload",
  "expectedEffect": {
    "kind": "FACT",
    "applicationId": "019d0000-0000-7000-8000-000000000501",
    "siteValue": "portal.fictional-example.test",
    "observedBucketUtc": "2026-07-31T11:00:00Z",
    "outputProfileId": "SITE_HOUR_V1",
    "interpretationDigest": "sha-256:fictional-interpretation"
  }
}
```

Allowed effect kinds are `FACT`, `CONSUMED_NO_EVENT`, and `QUARANTINED`. A stable event identity with the same digest/effect is retry-equivalent. A different digest/effect is `IDENTITY_CONFLICT`; neither engine may silently overwrite or create a second ordinary effect.

## 5.6 Query corpus contract

Each query has an immutable ID, parameters generated from fictional fixtures, expected result digest, concurrency class, timeout, freshness class, and privacy/cardinality review.

| Query ID | Semantic result | Shape | Required indexes/notes |
|---|---|---|---|
| Q01 | realm/day/application counts | narrow aggregate scan | aggregate PK/index; no fact scan expected |
| Q02 | realm/application trend over bounded days | ordered aggregate range | realm-first day/application range |
| Q03 | installation health: received/validated/materialized/quarantined counts | inbox/work/effect aggregate | no payload/body access |
| Q04 | recent facts for one fictional application and bounded time | partition-pruned fact range | realm/time/application index candidate |
| Q05 | unmatched/ambiguous/denied reason counts | value-free effect/quarantine aggregate | finite reason code |
| Q06 | batch custody-to-materialization latency buckets | inbox/work relation | bounded range, no body projection |
| Q07 | late-arrival reconciliation by occurred versus received bucket | aggregate and partition metadata | stresses P1/P2 differences |
| Q08 | deletion/readiness evidence for a fictional range | tombstone/readiness tables | no deleted payload access |
| Q09 | cross-realm negative query | must return authorization failure/zero according to API contract | hard isolation gate |
| Q10 | operator queue-age and poison summary | narrow work/attempt tables | no realm/device metric label in exported metrics |

The query corpus is not approved reporting policy. It is a representative technical corpus that must be replaced or extended by a human-approved production report set before final capacity approval.

## 5.7 Run manifest — mandatory artifact

```yaml
contract: uam.dbbench.run-manifest
version: 1.0.0
runId: dbx-2026-07-31-fictional-0001
classification: T1_FICTIONAL
sourceTreeDigest: sha-256:replace-at-execution
workloadPackageDigest: sha-256:replace-at-execution
oracleDigest: sha-256:replace-at-execution
engineProfile:
  engineFamily: POSTGRESQL   # or SQL_SERVER
  productVersion: 18.4
  edition: COMMUNITY
  buildDigest: sha-256:replace-at-execution
  driver:
    name: Npgsql
    version: 10.0.3
    sourceCommit: d3768398c17877b3a916c3c4d87e8e11698991fc
  durabilityProfileId: DURABLE_SYNC_V1
  isolationProfileId: REALM_RLS_V1
  partitionVariant: P1_RECEIVED_MONTH
  tuningProfileId: DEFAULT_BASELINE
  configurationDigest: sha-256:replace-at-execution
environmentProfile:
  topologyId: SELF_MANAGED_SYNC_STANDBY_V1
  osImageDigest: sha-256:replace-at-execution
  cpuClass: exact-at-execution
  memoryBytes: exact-at-execution
  storageClass: exact-at-execution
  clientClass: exact-at-execution
  networkClass: exact-at-execution
workloadProfile:
  profileId: OUTAGE_RECONNECT_V1
  endpointIdentityCount: 6000
  generationSeed: 16001
  steadyEventsPerSecond: ESTIMATE_REPLACE
  reconnectMultiplier: ESTIMATE_REPLACE
  duplicateRate: ESTIMATE_REPLACE
  lateArrivalDistributionId: ESTIMATE_REPLACE
  reportConcurrency: ESTIMATE_REPLACE
  retentionDays: HUMAN_DECISION_PLACEHOLDER
statisticsPlan:
  pairedBlockId: block-001
  repetition: 1
  randomizedOrder: true
  warmupPolicyId: STABILITY_V1
  measurementPolicyId: WINDOW_V1
faultPlanId: NONE
cleanupPlanId: REVERT_AND_VERIFY_V1
```

Published manifests contain no placeholder, credential, hostname, address, secret, production identifier, or mutable image tag. The CLI refuses a manifest containing `ESTIMATE_REPLACE`, `HUMAN_DECISION_PLACEHOLDER`, an unpinned dependency, or a missing owner for a blocking run.

## 5.8 Evidence bundle contract

```text
evidence/dbx/<run-id>/
  manifest/run-manifest.yaml
  manifest/inputs.sha256
  manifest/environment.json
  manifest/engine-config.json
  manifest/schema-indexes.json
  manifest/licenses-and-edition.json
  generator/package-root.json
  oracle/expected-ledger.ndjson
  operations/raw-operations.ndjson.zst
  operations/error-ledger.ndjson
  database/normalized-metrics.csv
  database/engine-native-snapshots/
  database/query-plans/
  database/log-wal-accounting.json
  database/maintenance-events.ndjson
  backup/backup-manifest.json
  restore/restore-ledger.json
  failover/failover-timeline.ndjson
  analysis/paired-summary.json
  analysis/confidence-intervals.csv
  analysis/tco-inputs.json
  analysis/sensitivity.json
  reports/result.md
  reports/result.html
  privacy/all-sink-canary.json
  cleanup/cleanup-receipt.json
```

Raw engine snapshots must be reviewed for sensitive fields before publication. Access-controlled raw evidence may remain in the isolated lab; the shareable bundle contains finite classes, fictional values, counts, digests, configurations, and exact public software versions only.

## 5.9 Error taxonomy

| Family | Examples | Retry rule | Decision impact |
|---|---|---|---|
| `INPUT_CONTRACT` | unsupported version, digest/count/bounds mismatch | corrected request only | correctness failure if accepted |
| `AUTH_CONTEXT` | missing/stale credential context | after re-auth only | hard security gate |
| `REALM_ISOLATION` | context mismatch, RLS/block failure | no automatic retry | hard disqualification |
| `DUPLICATE_REPLAY` | exact repeated batch/event | return stable prior result | expected path |
| `IDENTITY_CONFLICT` | same stable ID, different digest/effect | hold/quarantine | hard correctness/security path |
| `TRANSIENT_LOCK` | deadlock victim, serialization retry, lock timeout | bounded same-operation retry | measured; cannot create new identity |
| `LEASE_LOST` | token/version/fence mismatch | discard local result and requeue | expected recovery path |
| `POISON` | structurally valid batch repeatedly fails deterministic semantic validation | finite quarantine path | must not block unrelated work indefinitely |
| `RESOURCE_PRESSURE` | log/WAL, disk, temp, memory, connection, worker saturation | backpressure/pause | no silent loss or false receipt |
| `DURABILITY_AMBIGUOUS` | connection lost around commit/failover | reconcile/replay same ID | cannot guess custody |
| `BACKUP_RESTORE` | backup, archive/log chain, restore, PITR mismatch | operator/runbook | hard restore gate |
| `FAILOVER` | promotion, listener, fencing, split-brain risk | bounded recovery | hard HA gate |
| `SECURITY_INTEGRITY` | RLS bypass, untrusted module, config/signature drift | safety hold | hard disqualification |
| `CONFIG_DRIFT` | engine setting, edition, extension, driver or schema mismatch | no run; re-provision | evidence invalid |
| `LICENSE_POLICY` | edition/topology/replica use not approved | no ADR selection | TCO/authority blocker |
| `HARNESS` | missing sample, clock/collector failure, checker disagreement | repair harness; retain run | neither product pass nor fail |
| `UNKNOWN` | unclassified error/state | fail closed | blocks ADR |

---

# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility rules

## 6.1 Benchmark run lifecycle

```text
DRAFT
  -> INPUTS_VERIFIED
  -> ENVIRONMENT_PROVISIONED
  -> CONFIGURATION_VERIFIED
  -> DATASET_LOADED
  -> WARMING
  -> STABLE
  -> MEASURING
  -> FAULTING(optional named phase)
  -> QUIESCING
  -> ORACLE_RECONCILING
  -> CLEANING
  -> EVIDENCE_SEALED
  -> ANALYZED
  -> GATE_EVALUATED

Any input/config/schema/environment mismatch -> INVALID_RUN
Any harness failure                         -> HARNESS_FAULT
Any cleanup failure                         -> FAILED_CLEANUP
Any hard product invariant failure          -> PRODUCT_FAIL
```

An invalid or harness-fault run is retained and cannot be converted to a product pass. A product failure remains in aggregate evidence even if a later run succeeds.

## 6.2 Inbox and receipt lifecycle

```text
ABSENT
  -> INSERTING
      -> COMMITTED_DURABLE + RECEIPT_COMMITTED
          -> RESPONSE_RETURNED
          -> RESPONSE_LOST -> REPLAY_SAME_BATCH -> SAME_RECEIPT
      -> ROLLED_BACK -> ABSENT

Existing same ID + same digests      -> REPLAY_EQUIVALENT
Existing same ID + different digest  -> IDENTITY_CONFLICT / SECURITY_HOLD
```

Transaction boundary: inbox, receipt, and initial work row commit together. Neither engine may use a separate queue/store for the primary receipt unless a later change proposal redefines the failure domain.

## 6.3 Work lease lifecycle

```text
READY
  -> LEASED(token, owner, expiry, row-version)
      -> MATERIALIZING
          -> COMPLETED
          -> QUARANTINED
          -> RETRY_SCHEDULED
      -> LEASE_EXPIRED -> READY/RETRY_SCHEDULED
      -> LEASE_REVOKED -> READY/SAFETY_HOLD

Stale token/version terminal update -> REJECTED_STALE_WORKER
```

The worker may parse outside the final materialization transaction, but final effects and terminal work state commit together. Lease expiry during work does not allow a stale commit.

## 6.4 Event identity and final effect lifecycle

```text
UNSEEN
  -> IDENTITY_INSERTED(effect digest, first batch)
      -> FACT_INSERTED
      -> NO_EVENT_RECORDED
      -> QUARANTINE_RECORDED

Same key + same digest/effect -> RETRY_REUSES_EFFECT
Same key + different digest/effect -> IDENTITY_CONFLICT
```

A correction feature, if later approved, must create explicit supersession and audit state. It must not update the ordinary identity row in place or create an unlabelled second fact.

## 6.5 Poison lifecycle

```text
READY
  -> LEASED
  -> DETERMINISTIC_FAILURE
      -> retry while classification is transient/unknown and below bounded policy
      -> QUARANTINED(reason, contract, evidence)
      -> SAFETY_HOLD if invariant/security failure
```

A poison item cannot monopolize the oldest-work ordering indefinitely. The finite quarantine path is part of the semantic workload; engine-specific dead-letter tables or job frameworks are not the authority.

## 6.6 Partition lifecycle

```text
PLANNED
  -> CREATED_EMPTY
  -> WRITE_ENABLED
  -> ACTIVE
  -> CLOSED_TO_ORDINARY_WRITES
  -> RETENTION_CANDIDATE
  -> HOLD_CHECKED
  -> DETACHED/SWITCHED(optional engine profile)
  -> VERIFIED_EMPTY_FROM_ACTIVE_VIEW
  -> DROPPED
  -> TOMBSTONE_COMMITTED
```

Late arrivals against closed partitions follow the active workload policy: route to a still-writable old partition, quarantine, or reject/defer. No engine may silently place a row in an ungoverned default partition. Production behavior remains a **HUMAN DECISION**; benchmark variants make consequences measurable.

## 6.7 Backup and restore lifecycle

```text
BACKUP_PLANNED
  -> CONFIG_CAPTURED
  -> BACKUP_RUNNING
  -> BACKUP_COMPLETE
  -> ARTIFACT_HASHED
  -> NATIVE_VERIFY_COMPLETE
  -> RESTORE_SCHEDULED
  -> ISOLATED_RESTORE
  -> DATABASE_RECOVERY_COMPLETE
  -> SCHEMA/CONFIG/IDENTITY VERIFIED
  -> ORACLE/RECEIPT/EFFECT/DELETION RECONCILED
  -> RESTORE_READY
  -> EVIDENCE_SEALED
```

Native backup verification is necessary but not sufficient. Only an actual isolated restore and UAM ledger reconciliation closes the restore test.

## 6.8 Point-in-time recovery lifecycle

```text
BASE_BACKUP + CONTINUOUS_LOG/WAL_CHAIN
  -> SELECT_TARGET_POINT
  -> RESTORE_BASE
  -> REPLAY_TO_TARGET
  -> STOP_BEFORE/AT_DECLARED_BOUNDARY
  -> RECOVER_ISOLATED
  -> CLASSIFY_BATCHES/EVENTS:
       committed-before-target
       ambiguous-at-target
       after-target
  -> RECONCILE RECEIPTS AND EFFECTS
  -> READY_OR_FAIL
```

The target is defined by engine-native recovery evidence plus a harness marker committed in the same database. Wall-clock alone is not the sole oracle.

## 6.9 Failover lifecycle

```text
PRIMARY_HEALTHY
  -> FAILURE_INJECTED / PRIMARY_LOST
  -> WRITES_FENCED
  -> FAILURE_DETECTED
  -> CANDIDATE_VALIDATED
  -> PROMOTED/FAILED_OVER
  -> ROUTING_UPDATED
  -> APPLICATION_RECONNECTED
  -> AMBIGUOUS_OPERATIONS_RECONCILED
  -> BACKLOG_DRAINED
  -> OLD_PRIMARY_QUARANTINED/REJOINED
  -> HA_READY
```

A second writable primary, false receipt, or duplicate final effect is a hard failure even when service resumes quickly.

## 6.10 Report lifecycle

```text
QUERY_ADMITTED
  -> REALM_CONTEXT_SET
  -> TIMEOUT/RESOURCE_BUDGET_SET
  -> EXECUTING
      -> RESULT_VALIDATED
      -> CANCELLED/TIMEOUT
      -> AUTHORIZATION_FAIL
  -> CONTEXT_CLEARED/TRANSACTION_ENDED
```

The connection must not return to the pool with a mutable realm context that another request can inherit.

## 6.11 Database ADR lifecycle

```text
PROPOSED
  -> HARNESS_ACCEPTED
  -> CANDIDATES_PINNED
  -> CORRECTNESS_PASS
  -> CAPACITY_PASS
  -> RESTORE_PASS
  -> FAILOVER_PASS
  -> OPERATIONS/SKILLS_PASS
  -> TCO_COMPLETE
  -> WEIGHTS_APPROVED
  -> SENSITIVITY_COMPLETE
      -> ROBUST_WINNER
      -> NO_ROBUST_WINNER
      -> BOTH_FAIL
  -> OWNER_REVIEW
      -> ACCEPTED ENGINE+EDITION+TOPOLOGY+SUPPORT MODEL
      -> DEFERRED / RE-RUN
```

The ADR selects a complete candidate profile, not a brand name. A profile includes engine release, edition, OS/service, topology, storage, HA, backup, support, driver, operational owner, and evidence expiry.

## 6.12 Rollout and compatibility

1. Schema migrations are engine-neutral at the logical level and adapter-specific physically.
2. The current application and one authorized rollback application version MUST both understand the database schema during the rollback window.
3. Expand/backfill/contract is the default migration pattern.
4. A destructive migration requires actual backup/restore and an explicit maintenance ADR; it is not coupled to ordinary deployment.
5. Engine driver updates, database minor/CU updates, extension changes, OS images, configuration changes, and service-tier changes invalidate affected evidence and create a new candidate profile.
6. Query-plan equality is not required; semantic results and approved performance/operations bounds are.
7. Engine-specific optional optimization may be enabled only through a named feature flag/profile with a portable fallback and semantic equivalence tests.
8. Connection-pool, RLS/session context, and transaction behavior are compatibility-critical and rerun on provider change.
9. SQL Server edition changes are architecture changes because feature limits, HA, online operations, memory/core limits, and licensing differ. [W13]
10. Managed-service major version, backup retention/PITR implementation, HA zone topology, maintenance behavior, and pricing are profile identity, not invisible infrastructure.

---

# 7. Security/privacy threat and failure register

Role names below are accountable functions, not assigned people or approved organizational structures.

| ID | Trigger / threat / failure | Detection | Containment | Recovery | Cleanup | Accountable function | Required test | Residual risk |
|---|---|---|---|---|---|---|---|---|
| T16-01 | receipt response generated before durable commit | transaction failpoint, server/endpoint receipt ledger mismatch | block response path; safety hold build | replay same batch after corrected build | remove T1 artifacts/revert DB | Ingestion Reliability | DBX-05 | storage can still misreport flush durability |
| T16-02 | server commits inbox but response is lost | fault proxy, attempt/receipt timeline | retain immutable inbox; no new batch identity | replay same batch and return equivalent receipt | close proxy/session; reconcile | Ingestion Reliability | DBX-06 | network ambiguity remains normal and must be handled forever |
| T16-03 | same batch ID arrives with different digest | unique-key conflict plus digest comparison | security hold for identity; do not overwrite | investigate fictional reproducer; higher release if defect | clear only T1 conflicting fixture after evidence | Product Security / Ingestion | DBX-07 | a compromised endpoint credential can still send hostile bytes, but not rewrite custody |
| T16-04 | concurrent duplicate batch insert races | unique constraint and oracle ledger | one winner; other transaction returns stable replay | bounded retry/re-read | none beyond normal connection cleanup | Database Engineering | DBX-08 | hot-key contention may reduce throughput |
| T16-05 | concurrent duplicate event races across batches | global identity unique constraint | one final effect; conflicting digest holds | retry same materialization or quarantine conflict | release temp stage | Data Correctness | DBX-09 | identity ledger can become a contention hotspot |
| T16-06 | time partition cannot enforce global event uniqueness | schema verifier and hostile duplicate across partitions | separate unpartitioned identity ledger | migrate through expand/backfill/verify | remove failed prototype | Data Architecture | DBX-10 | identity-ledger retention may differ from fact retention and needs governance |
| T16-07 | payload realm/device claim overrides authenticated context | negative API/DB vectors | reject/ignore hostile claim; context is immutable | fix contract/middleware; rerun all realm tests | purge T1 hostile request | Identity / Ingestion Security | DBX-11 | upstream identity compromise remains outside DB proof |
| T16-08 | connection pool leaks prior realm context | colliding-realm alternating/concurrent tests | close/poison connection; deny query | reset architecture; transaction-scoped context | drain pool | Application Security | DBX-12 | privileged DBA can bypass RLS by design and requires governance |
| T16-09 | RLS policy omitted, disabled, or bypassed by role ownership/elevation | schema/role verifier and cross-realm corpus | revoke runtime; safety hold deployment | apply corrected signed migration and requalify | remove bad role/policy in T1 | Database Security | DBX-13 | RLS is defense in depth, not a substitute for app authorization |
| T16-10 | SQL injection through dynamic DDL, table/partition name, or report filters | static analysis, hostile names, query audit | fixed allowlist and parameterization; reject unknown | patch and rotate affected credentials if needed | delete T1 objects | Secure Coding Owner | DBX-14 | privileged maintenance scripts remain high consequence |
| T16-11 | lease query starves older work or hot realm monopolizes workers | oldest-age/per-realm service distribution | bounded scheduler, fairness lanes, partitioned worker pools only if measured | tune ordering/index/concurrency; re-run | release leases | Processing Owner | DBX-15 | lock-skip primitives do not promise global fairness |
| T16-12 | SQL Server page locks/escalation defeat `READPAST` intent | lock DMV, skipped eligibility oracle, wait data | cap claim size/transaction; correct index/profile | adjust profile or reject SQL profile | kill T1 blockers | SQL Server Operations | DBX-15 | lock behavior changes with row width, statistics, and load |
| T16-13 | PostgreSQL `SKIP LOCKED` causes unfair/inconsistent scheduling | queue oracle and age distribution | treat as scheduler only; bounded rechecks | tune claim size/index/backoff | rollback T1 tx | PostgreSQL Operations | DBX-15 | fairness remains application responsibility |
| T16-14 | stale worker commits after lease loss | lease token/version failpoint | reject terminal transaction | discard local result; re-lease immutable batch | clear temp stage | Processing Owner | DBX-16 | long GC/OS pauses can create wasted duplicate work |
| T16-15 | poison batch retries forever and blocks queue | attempt count, deterministic reason, oldest-age alert | finite quarantine; independent queue progress | fix parser/contract or explicit replay | remove T1 poison after evidence | Data Quality / Support | DBX-17 | without raw data, some production-only poison may be hard to reproduce |
| T16-16 | decompression bomb or declared/actual size mismatch | streaming byte/count limits and canary | abort before bulk/DB mutation beyond receipt policy | classify invalid/hold; patch codec | release buffers/temp | Ingestion Security | DBX-18 | native compression/parser defects remain dependency risk |
| T16-17 | bulk stage maps columns/types incorrectly | golden vectors, row counts, digest/effect oracle | rollback final transaction; disable bulk profile | correct explicit mappings; compare row-by-row reference | drop temp table | Database Adapter Owner | DBX-19 | provider updates may change edge behavior |
| T16-18 | cancellation/connection loss during bulk leaves partial final effects | failpoints and transaction ledger | final transaction all-or-nothing; stage is disposable | replay from inbox | drop temp stage/connection | Database Adapter Owner | DBX-20 | temp resources can pressure server under repeated failures |
| T16-19 | WAL/transaction log amplification exhausts storage | bytes written per payload, growth, reserve alerts | backpressure before reserve; no false receipt | add capacity/checkpoint/log backup; tune schema/index | shrink only through approved maintenance; revert lab | Database SRE | DBX-21 | emergency capacity expansion may still miss objective |
| T16-20 | PostgreSQL autovacuum/vacuum falls behind | dead tuples, freeze age, vacuum lag, table/index size | reduce load/pause reports; profile autovacuum | vacuum/reindex under runbook, then soak | remove T1 database | PostgreSQL Operations | DBX-22 | vacuum cost and bloat depend on real update/delete patterns |
| T16-21 | SQL Server ghost cleanup/index fragmentation/stats maintenance harms workload | DMVs, waits, plans, log/IO, maintenance timeline | bounded maintenance windows/resource governor where approved | update stats/rebuild/reorganize under exact edition/profile | revert lab | SQL Server Operations | DBX-22 | online maintenance availability differs by edition |
| T16-22 | partition create/attach/switch/drop blocks or misroutes writes | DDL fault, lock timeline, row oracle | stop maintenance; no default catch-all | retry under window or revert; keep data intact | drop only manifest-owned T1 objects | Data Lifecycle Owner | DBX-23 | metadata locks and catalog pressure scale with object count |
| T16-23 | late arrival targets closed/dropped partition | generated late-arrival matrix | explicit defer/quarantine/approved old write; never silent loss | create governed partition or replay after policy | clear T1 rows | Data Governance / Lifecycle | DBX-24 | production late-arrival distribution is unknown |
| T16-24 | report query saturates CPU/I/O/temp and increases queue age | paired report/no-report A/B, waits, temp metrics | timeout/cancel, report kill switch, concurrency cap | tune/index/replica decision | cancel sessions/drop temp | Reporting Owner / SRE | DBX-25 | approved report priorities are a human decision |
| T16-25 | query-plan regression after statistics/version change | plan digest/class, latency CI, row estimates | stop promotion; use known profile | update stats/index/query or requalify | clear plan hints in T1 | Database Engineering | DBX-26 | plan shape cannot be guaranteed indefinitely |
| T16-26 | disk full during receipt/materialization/maintenance | filesystem quota and engine errors | stop new custody before unsafe reserve where possible; no false receipt | extend/restore space, reconcile exact commits | remove filler; verify DB | Database SRE | DBX-27 | receipt commit can succeed while subsequent response fails; replay still required |
| T16-27 | backup job reports success but artifact is incomplete/unusable | native verification plus actual restore | mark unusable; no cleanup authority | take new backup and restore test | delete failed T1 backup by manifest | Backup/Restore Owner | DBX-28 | verification tools can share engine defects |
| T16-28 | PITR target includes/excludes wrong transaction | database marker and oracle classification | restore remains isolated/not ready | choose corrected target and rerun | destroy failed restore | Backup/Restore Owner | DBX-29 | clock ambiguity near target requires database markers |
| T16-29 | failover creates split-brain/two writers | fencing probes, divergent commit markers | stop routing/writes; quarantine both | choose authoritative lineage under runbook; restore/reconcile | rebuild old primary | HA Owner | DBX-30 | network partitions can expose orchestrator/cluster defects |
| T16-30 | commit outcome ambiguous during failover | client exception plus primary/standby ledgers | replay same batch/event identity | reconnect and reconcile | close failed sessions | Ingestion/HA Owners | DBX-31 | duplicate work is expected; duplicate effect is not |
| T16-31 | replica lag makes report stale or failover lose acknowledged data | LSN/LSN-equivalent lag, receipt marker, report freshness | do not route report/failover outside profile | wait/catch up, choose other target, or fail test | reset topology | HA/Reporting Owners | DBX-32 | asynchronous DR inherently permits loss within approved RPO only |
| T16-32 | old primary rejoins incorrectly after promotion | timeline/replica metadata and write fencing | quarantine; never auto-route | rewind/reseed/rebuild according to engine runbook | delete old T1 data directory after evidence | HA Owner | DBX-33 | operator error remains high consequence |
| T16-33 | backup/replica/report topology changes SQL Server license need | topology and connection/use audit | block ADR until licensed interpretation approved | obtain quote/legal review or change topology | none | Procurement/Legal/Architecture | DBX-34 | licensing terms and benefits can change |
| T16-34 | SQL Server Developer edition hides Standard limits/features | edition/feature inventory and Standard Developer lane | invalidate run for production Standard claim | rerun on intended edition-equivalent profile | tear down invalid instance | SQL Server Owner / Procurement | DBX-35 | cloud services can package features differently |
| T16-35 | PostgreSQL “no license fee” omits support/people/HA tooling | TCO completeness validator | no cost score until all rows supplied | obtain support/ops estimates and sensitivity | none | Finance/Operations | DBX-36 | future staffing and incident rates are uncertain |
| T16-36 | managed service silently differs in backup/HA/maintenance behavior | exact service/SKU docs and real drills | separate profile; no engine-general inference | rerun or reject service tier | delete managed T1 resources | Cloud Platform Owner | DBX-37 | provider changes remain external dependency |
| T16-37 | engine native metrics expose SQL literals or high-cardinality values | all-sink scan and schema allowlist | stop exporter; restrict views/config | clean evidence, rotate any leaked secret, rerun | delete contaminated bundle | Observability/Privacy | DBX-38 | privileged engine logs may still contain operational details under incident access |
| T16-38 | benchmark contains production-derived values | canary/classification review and provenance | quarantine evidence; stop publication | regenerate T1 package; incident handling | delete contaminated data under authority | Privacy/Test Data Owner | DBX-39 | distribution realism remains limited without approved aggregate measurements |
| T16-39 | configuration drift between paired runs | configuration/environment digest diff | invalidate pair | re-provision from immutable profile | revert both environments | Verification Owner | DBX-40 | hidden firmware/cloud host differences may remain |
| T16-40 | harness/oracle shares defect with both adapters | mutation, hand-worked cases, third implementation/cross-check | no ADR pass | correct model; rerun full affected corpus | preserve old failure capsule | Verification Architecture | DBX-41 | no finite test removes all common-mode error |
| T16-41 | failed runs are omitted or retried away | evidence aggregator checks first-failure lineage | gate fails publication | restore missing evidence or repeat full block transparently | none | Evidence Governance | DBX-42 | incentives can still bias workload/weight selection |
| T16-42 | retention drop deletes held or wrong-realm range | hold/tombstone oracle and cross-realm partitions | retention kill; restore from backup if allowed | restore/reconcile, fix selector | remove T1 dropped-range artifacts | Records/Data Lifecycle | DBX-43 | production legal holds and retention are unresolved |
| T16-43 | restored database makes deleted data visible before readiness | deletion-state/readiness reconciliation | isolate restore, deny serving | replay deletion/tombstones, verify, then ready | destroy unsafe restore if unrecoverable | Restore/Data Governance | DBX-44 | backup retention and legal hold can conflict and need human resolution |
| T16-44 | operator cannot diagnose/recover without prohibited raw activity | blind runbook exercise | capability remains unapproved; add finite safe evidence | improve tools/runbook or narrow support promise | clear T1 case | Support/Operations | DBX-45 | privacy-safe diagnostics intentionally limit some forensics |
| T16-45 | dependency or driver compromise/malformed server response | locked source/binary, SBOM, provider tests, advisory review | freeze profile/release | update dependency and rerun affected gates | remove old artifacts | Supply Chain Security | DBX-46 | database/client parsers remain large attack surfaces |
| T16-46 | clock skew affects lease/latency/retention conclusions | server/client clock capture and monotonic timers | use database time for lease; classify clock uncertainty | resync/reprovision and rerun | none | SRE/Verification | DBX-47 | cross-host wall-clock comparisons remain imperfect |
| T16-47 | excessive worker/connection count exhausts server and masks engine capacity | connection/worker resource curves | bounded pools/backpressure | tune pool/worker profile; rerun | close pools | Application SRE | DBX-48 | production concurrency distribution is unknown |
| T16-48 | one realm's burst creates noisy-neighbor impact | per-realm fictional fairness samples without exported realm labels | bounded fair scheduler/quotas only if approved | tune lanes or dedicated topology proposal | clear T1 burst data | Product/SRE | DBX-49 | tenant fairness policy is a human decision |

---

# 8. Detailed test matrix and smallest falsifying prototypes

## 8.1 Evidence rules for every experiment

Every run MUST produce:

- exact source tree, dirty-state, package, driver, engine, edition, OS/service, image, configuration, schema, index, extension, and topology digests;
- immutable T1 workload package, seed, schedule, oracle, fault, and query-corpus revisions;
- raw operation records including failures, retries, timeouts, cancellations, and ambiguous outcomes;
- engine-native metrics and configuration snapshots with sensitive fields removed;
- receipt, work, event, aggregate, partition, backup, restore, and failover ledgers;
- first failure and all rerun links;
- all-sink canary result and cardinality report;
- actual cleanup/revert evidence;
- owner/reviewer functions and exception/expiry references;
- no credential, address, production identifier, personal data, raw source value, or confidential configuration.

A cleanup failure fails the run. A missing sample or metric that is required by the statistical plan produces `HARNESS_FAULT`, not a favorable imputation.

## 8.2 Detailed matrix

Durations are **ESTIMATE** test budgets and must be replaced after pilot variance and lab-cost review.

| ID | Setup and instrumentation | Steps | Pass | Fail/stop | Exact evidence | Duration ESTIMATE | Cleanup |
|---|---|---|---|---|---|---|---|
| DBX-00 | seven allowlisted hashes; exact public/repo register | generate input manifest from files; compare to declared set | exact seven inputs, no extra project file | missing/changed/extra input | `inputs.json`, SHA-256 list | 5 min | none |
| DBX-01 | clean checkout; locked .NET/tools/providers; two clean work dirs | build twice; generate T1 package/oracle twice | byte-identical canonical outputs; all dependencies pinned | nondeterminism, floating input, production value | build manifests, package roots | 20 min | delete work dirs |
| DBX-02 | pure contract/schema validators | run valid/boundary/invalid/duplicate/unknown vectors | exact acceptance matrix both adapters | differential semantic acceptance | vector ledger | 10 min | drop scratch DBs |
| DBX-03 | logical DDL + both physical adapters | create schema; introspect tables, keys, RLS, indexes, partition metadata | schema verifier matches contract; no hidden semantic object | missing realm key/constraint, extra trigger/default authority | DDL, introspection JSON | 15 min/engine | drop DB |
| DBX-04 | independent hand-worked ledger and mutations | mutate oracle/adapter: early receipt, duplicate effect, cross-realm, skipped poison | every mandatory mutation detected | survivor or checker common code | mutation report, minimal history | 30 min | none |
| DBX-05 | commit failpoints around inbox/receipt/work insert and response | fail/kill before/after each statement/commit/response | no receipt before commit; post-commit replay returns same receipt | false receipt, missing inbox/work, changed receipt | transaction snapshots, client ledger | 45 min/engine | reset DB |
| DBX-06 | fault proxy between client/API and DB/API response | commit then drop response; repeat loss/retry | one inbox/receipt; endpoint gets equivalent receipt | new batch/receipt semantics or duplicate custody | network timeline, DB ledger | 30 min/engine | stop proxy/reset |
| DBX-07 | hostile same batch ID with digest variants | sequential and concurrent submissions | exact replay accepted; differing digest held | overwrite or second accepted body | conflict ledger | 20 min/engine | clear T1 conflicts |
| DBX-08 | high-contention single and distributed batch identities | randomized concurrent insert/replay | one row/effect per key, bounded errors | duplicate final row or deadlock loop | operation history, locks/waits | 30 min/engine | reset |
| DBX-09 | two batches containing same event; same/different payload digests | materialize concurrently and with crashes | one final effect for same digest; conflict for different | duplicate ordinary effect/overwrite | identity/fact ledger | 45 min/engine | reset |
| DBX-10 | P0/P1/P2, duplicate event placed in different time partitions | execute dedupe/materialization and late arrival | global identity invariant preserved in every variant | partition-specific duplicate | schema + ledger | 30 min/variant/engine | drop partitions |
| DBX-11 | hostile payload realm/install fields and authenticated colliding contexts | submit/query/mutate with mismatches | authority always from context | payload changes realm or row | API/DB negative ledger | 20 min/engine | reset |
| DBX-12 | pooled connections alternating two realms; exceptions/cancel/retry | high concurrency checkout/query/return | zero cross-realm rows; context not inherited | any leak or ambiguous context | pool trace, query ledger | 60 min/engine | drain pool |
| DBX-13 | runtime/migration/owner/admin roles and RLS policies | attempt read/write/DDL/bypass/ownership paths | runtime confined; owner/bypass separated and audited | runtime can bypass or cross realm | privilege matrix | 30 min/engine | revoke/drop roles |
| DBX-14 | hostile identifiers/filter values; static query inventory | fuzz fixed query interfaces and maintenance name allowlists | parameterized/fixed identifiers only | injected SQL/object access | query audit, analyzer output | 30 min/engine | drop T1 objects |
| DBX-15 | work table aged to target size; 1..N workers; locked rows/pages | claim/expire/retry under skew/hot realm | no loss/duplicate; bounded oldest age after approved threshold supplied | starvation, page-lock invisibility, unbounded retries | claim history, waits, age distribution | 45 min/level/engine | release leases/reset |
| DBX-16 | barrier after lease and before terminal commit | expire/reclaim; allow stale worker to finish | stale commit rejected; new worker produces one effect | two terminal commits or effect | token/version history | 30 min/engine | reset |
| DBX-17 | deterministic/transient/unknown poison corpus mixed with good work | run retries/quarantine and unrelated progress | good work progresses; finite poison state | infinite poison monopolization or silent skip | attempt/quarantine ledger | 45 min/engine | clear fixtures |
| DBX-18 | compression/decompression boundary corpus and declared sizes | stream parse with bombs/truncation/count mismatch | bounded resource; no unauthorized custody/effect | limit bypass, crash, raw evidence leak | resource/error/canary ledger | 30 min/client profile | clear buffers |
| DBX-19 | same fictional rows loaded row-by-row and by bulk | compare temporary stage and final effect digests | identical effects/query results | mapping/type/collation difference | stage/final hashes | 30 min/path/engine | drop temp/reset |
| DBX-20 | cancel/kill/network break at bulk and final transaction boundaries | retry immutable inbox | all-or-nothing final state; stage disposable | partial fact/work state | failpoint snapshots | 45 min/engine | close/drop temp |
| DBX-21 | ingestion/materialization levels with log/WAL capture | measure bytes, flushes, checkpoints/log backups, disk reserve | no false receipt/loss; amplification reported with CI | reserve exhaustion or hidden logging difference | WAL/log accounting | 45 min/level/engine | reset/checkpoint per runbook |
| DBX-22 | aged DB with updates/deletes/indexes/stats; maintenance enabled | steady+report+maintenance soak | maintenance keeps health within owner thresholds without invariant failure | runaway bloat/fragmentation/blocking or unsupported edition operation | maintenance timeline, size/waits/plans | 24 h/variant/engine | drop/revert |
| DBX-23 | precreated adjacent partitions; writers/reporters active | create/attach/switch/detach/drop with faults | correct rows, bounded blocking, recoverable DDL | misroute/loss/cross-realm/unguarded default | DDL/lock/row ledger | 90 min/variant/engine | drop T1 partitions |
| DBX-24 | generated late arrivals across current/old/closed/dropped ranges | materialize under each policy variant | exact documented effect/defer/quarantine | silent loss or ungoverned partition | late-arrival ledger | 60 min/variant/engine | reset |
| DBX-25 | fixed Q01–Q10, no-report baseline and report concurrency levels | randomized paired A/B | exact results; ingestion/report metrics and CIs published | wrong result/cross realm/unbounded queue impact | query result digests, plans, samples | 45 min/level/engine | cancel/drop cache only per manifest |
| DBX-26 | statistics/version/config perturbations allowed by profile | rerun query corpus and detect plan/latency change | semantic results exact; change classified | hidden regression or result difference | plan class, stats snapshot | 45 min/engine | restore config |
| DBX-27 | dedicated test volume quota; pressure during receipt/work/report/checkpoint | fill through soft/hard reserve and recover | no false receipt/silent loss; bounded pause/recovery | acknowledged loss, corruption, recovery impossible | filesystem/DB ledger | 60 min/engine | remove filler/verify |
| DBX-28 | backup under steady and report load | perform native backup, verify, hash | backup completes with measured impact and exact config | error hidden, missing chain, unbounded impact | backup manifest/native verify | workload-dependent | retain for restore then delete |
| DBX-29 | isolated target, selected recovery marker, base+log/WAL chain | full restore and PITR to multiple targets | oracle, receipts, effects, schema, RLS, deletion state exact | any reconciliation mismatch | restore ledger/query hashes | 2–6 h/target/engine | destroy restore |
| DBX-30 | synchronous HA base topology; write/report/backup load | kill primary/network; promote/fail over | fencing, one writer, no false receipt/duplicate; measured RTO | split-brain or unapproved loss | failover timeline/markers | 90 min/scenario/engine | rebuild topology |
| DBX-31 | response/commit ambiguity during failover | inject at receipt/materialization commit boundaries | same identity reconciliation | new identity/double effect | client/server histories | 60 min/engine | reset |
| DBX-32 | optional async DR/read replica and lag controls | load, lag, report, failover negative | behavior matches declared RPO/freshness profile | report/failover exceeds approved profile or claims sync | replication/receipt ledger | 90 min/engine | rebuild replica |
| DBX-33 | promoted topology with old primary return | test rewind/reseed/rejoin and hostile direct write | old primary fenced; rejoin exact | divergent writer or unsafe auto-rejoin | topology timeline | 2 h/engine | rebuild/drop old node |
| DBX-34 | exact SQL Server editions/topologies and usage, PostgreSQL support/topology | fill licensing/support questionnaire and evidence | no ambiguous edition/replica/use assumption | incomplete or contradictory license model | license/TCO manifest | 2 h tabletop + quote | none |
| DBX-35 | SQL Server Standard Developer and intended Standard-equivalent limits | run feature/limit verifier and production-shaped profile | no Enterprise-only feature sneaks into Standard claim | feature/limit mismatch | edition/feature inventory | 30 min + load | tear down |
| DBX-36 | complete operations and three-year TCO input schema | collect quote/rate/people/training/support/DR inputs; sensitivity | every material input present with source/date/range | omitted category or stale quote | TCO JSON/sensitivity | 1–3 days human work | none |
| DBX-37 | managed PostgreSQL and SQL Server candidate services as separate profiles | provision exact SKU; run semantic, backup, PITR, failover, maintenance tests | profile-specific pass; no engine-general claim | missing control/evidence or service behavior mismatch | service config/drill evidence | 1–2 days/profile | delete resources/prove billing stop |
| DBX-38 | all exporters/logs/traces/query stores/evidence sinks | plant fictional canaries and high-cardinality values | all mandatory canaries caught; no forbidden label/value | one leak or scanner miss | all-sink matrix | 45 min/profile | delete contaminated evidence |
| DBX-39 | classification/provenance scanner | inspect generated data and every evidence file | T1 only; no real/organization value | unclassified/real value | provenance/canary report | continuous | delete contaminated package |
| DBX-40 | paired environment verifier | compare CPU/memory/storage/network/OS/config/time/order | only intended engine differences remain | uncontrolled confounder | pair-diff JSON | 10 min/pair | reprovision |
| DBX-41 | hand histories, oracle mutations, generic-tool cross-checks | compare independent calculations | required defects detected; differences classified | common-mode discrepancy unresolved | checker comparison | 60 min | none |
| DBX-42 | evidence aggregator with intentionally failed/omitted run | evaluate strict completeness and first-failure preservation | aggregate fails and names cause | manual pass or hidden failure | gate mutation report | 20 min | none |
| DBX-43 | fictional retention ranges, holds, adjacent realms, late rows | detach/drop/delete and query all paths | only exact authorized range gone; tombstone exact | wrong range/realm/held data removed | before/after/restore ledger | 90 min/variant/engine | restore/revert |
| DBX-44 | restore containing previously deleted fictional range | restore isolated; apply readiness/deletion state | not served until deletion reconciled | deleted data visible/readiness false | access/query/readiness log | 2–4 h/engine | destroy restore |
| DBX-45 | blind operator receives safe bundle/runbook only | diagnose and recover defined fault set | correct classification/recovery without raw payload | unsafe command/raw request or unresolved required case | scorecard/commands/cleanup | 2 h/profile | revert lab |
| DBX-46 | exact provider binaries/transitives and hostile server/protocol cases | dependency admission, malformed response, cancellation, update diff | bounded fail-closed behavior and exact provenance | package/source mismatch or parser bypass | SBOM/provenance/test output | 60 min/provider | remove test server |
| DBX-47 | deliberate client/server clock skew and jump | lease, latency, retention/failover runs | lease correctness uses DB time; skew classified | stale worker commit or wrong retention based on client time | clock/timeline ledger | 45 min/engine | restore clocks/revert |
| DBX-48 | connection/worker sweep through saturation | measure throughput, latency, queue age, errors, server/client resources | stable knee identified; no invariant failure | uncontrolled connection storm or hidden retry amplification | saturation curves | 45 min/level/engine | close pools/reset |
| DBX-49 | one fictional realm burst plus steady peers | measure peer latency/queue age and final effects | zero cross-realm mix; fairness data published | starvation/mix/silent loss | per-fixture internal ledger, aggregated output | 60 min/engine | reset |
| DBX-50 | complete paired block and decision inputs | run randomized repetitions, analyze, score, sensitivity | strict gate result reproducible from raw evidence | missing pair/CI/weight/owner or result cannot reproduce | `db-adr-gate.json` | analysis only | none |

## 8.3 Smallest falsifying prototypes

### P16-01 — false receipt and response loss

**Claim.** A receipt is returned only after the durable inbox/receipt/work transaction commits, and replay after response loss returns the same custody result.

**Setup.** One engine instance, one fictional realm/installation, one batch, an API stub, database commit hooks, and a response-dropping proxy.

**Instrumentation.** Transaction log/WAL markers, DB rows, API timeline, client attempt ledger, process-kill controller, and independent oracle.

**Steps.** Fail before insert, between each insert, before commit, after commit before response, and after response serialization. Retry the same batch after each ambiguous case.

**Pass.** No pre-commit receipt; no partial inbox/receipt/work state; every post-commit retry returns equivalent receipt; one batch row and one work row.

**Fail.** Receipt without committed inbox, changed receipt meaning, second accepted body, or missing work row after receipt.

**Evidence.** Full state snapshots and first-failure capsule for every hook.

**Duration.** **ESTIMATE:** 45 minutes per engine after harness setup.

**Cleanup.** Drop/recreate the T1 database and verify no process/proxy/listener remains.

### P16-02 — lease, stale worker, poison, and starvation

**Claim.** Lock-skipping leases improve concurrency without losing eligible work, allowing stale commits, or letting poison block unrelated work.

**Setup.** Aged work table, mixed fictional realms, locked rows/pages, deterministic poison, N workers, and a barrier around terminal commit.

**Instrumentation.** Claim order, lock/wait data, oldest age, attempt/quarantine ledger, lease token/version, CPU/I/O, and oracle.

**Steps.** Sweep worker count and claim size; expire/reclaim leases; release stale workers; hold oldest rows; alternate hot and quiet realms.

**Pass.** One terminal outcome per batch, stale commit rejected, finite poison quarantine, all eligible ordinary work eventually progresses within the supplied human threshold.

**Fail.** Missing/duplicate work, unbounded starvation, page-lock invisibility causing permanent skip, or poison monopolization.

**Duration.** **ESTIMATE:** 45 minutes per concurrency level per engine.

### P16-03 — global dedupe across partitions

**Claim.** One event identity creates one final effect even when duplicate copies map to different time partitions.

**Setup.** P0/P1/P2 schemas; two batches carry the same event ID; event times straddle months; one duplicate has a conflicting payload.

**Steps.** Materialize concurrently, crash at identity/fact boundaries, and replay.

**Pass.** Same digest yields one effect; different digest yields conflict; partition grain does not change identity.

**Fail.** Duplicate fact in different partition, overwrite, or identity key includes processing version/time only for convenience.

### P16-04 — realm context and pool reuse

**Claim.** Application authorization plus RLS prevents one realm from reading or writing another across pooled connection reuse.

**Setup.** Two colliding fictional realms, smallest realistic runtime/migration/admin role set, pooled connections, prepared statements, cancellations, and transaction failures.

**Steps.** Alternate realms on the same physical connections; omit/set/wrong-set context; invoke every CRUD/report/lease path and known privileged module path.

**Pass.** Zero cross-realm result or mutation; missing/wrong context fails; pool remains usable only after safe reset/transaction completion.

**Fail.** Any row/count/timing-dependent authorization leak, owner bypass in runtime, or stale context inheritance.

### P16-05 — bulk path and log/WAL amplification

**Claim.** Temporary bulk staging preserves row-by-row semantics while reducing client/engine work without weakening durability.

**Setup.** One fixed fictional batch corpus, row-by-row reference, PostgreSQL binary COPY, SQL Server `SqlBulkCopy`, and final transaction failpoints.

**Steps.** Compare effects/results; measure client CPU, DB CPU, elapsed, bytes sent, temp, WAL/log, checkpoints, and cancellation.

**Pass.** Exact semantic equality; no partial final state; raw amplification metrics published.

**Fail.** mapping/collation/precision difference, trigger/default side effect, or durable semantics differ.

### P16-06 — report coexistence

**Claim.** The chosen primary profile can meet approved ingest and report objectives together, or the evidence clearly justifies a reporting replica/separate store.

**Setup.** Aged database, Q01–Q10, fixed ingestion/materialization, no-report baseline, report concurrency sweep.

**Pass.** Exact results, no cross-realm access, and confidence intervals within human-approved limits.

**Fail.** Wrong result, invariant failure, unstable plans, unbounded queue age, or hidden maintenance debt.

### P16-07 — actual restore and PITR

**Claim.** The exact backup chain can restore acknowledged fictional events and preserve deletion/readiness semantics to a selected database marker.

**Setup.** Full backup plus continuous WAL/log, known receipt/effect/deletion markers, isolated restore host/service.

**Steps.** Restore full and multiple PITR targets before/after key markers; run schema/security/oracle reconciliation.

**Pass.** Every committed-before-target receipt/effect present, after-target absent, ambiguous boundary explicitly classified, RLS/config correct, deleted data not served before readiness.

**Fail.** Any acknowledged loss, false acknowledged row, wrong realm/security state, or failed deletion readiness.

### P16-08 — failover during receipt and materialization

**Claim.** The HA topology fences writers and preserves stable identity during primary loss.

**Setup.** One synchronous standby candidate per engine, active load, failure controller, routing/listener, and independent commit markers.

**Steps.** Kill/isolate primary around inbox commit, response, lease, final effect commit, backup, and report query; reconnect and rejoin/rebuild old primary.

**Pass.** Exactly one writer, no false receipt or duplicate effect, ambiguous operations replay same ID, and measured recovery is reported.

**Fail.** split-brain, unsafe old-primary rejoin, or unapproved acknowledged loss.

### P16-09 — retention and late arrivals

**Claim.** The partition strategy can apply fictional retention without deleting holds/wrong realms or silently losing permitted late arrivals.

**Setup.** Adjacent time partitions, two realms, hold ranges, late arrivals, backup/restore copy, and P0/P1/P2.

**Pass.** Only the exact authorized range is removed; tombstone matches; late-arrival result follows declared policy; restore does not serve deleted range before readiness.

### P16-10 — skills, on-call, and TCO tabletop

**Claim.** A passing engine profile can be operated and funded under explicitly approved assumptions.

**Setup.** Same defined failure set for both engines; sanitized evidence bundle; runbooks; licensing/TCO questionnaire; no engine specialist coaching during blind phase.

**Steps.** Operators diagnose lock saturation, disk pressure, lag, failed backup, PITR, failover, RLS context leak, and patch/config drift. Finance/Procurement complete exact topology ranges.

**Pass.** Required cases are safely handled within approved objectives; no prohibited raw data or broad privilege; every cost category has source/date/range.

**Fail.** unsafe workaround, inability to restore/fence, hidden license assumption, or owner/staffing gap.

## 8.4 Benchmark harness and runbook — mandatory artifact

### Phase A — freeze inputs

1. Approve T1 workload package and independent oracle.
2. Fill every human-required demand placeholder or mark the run `EXPLORATORY_ONLY`.
3. Pin engine, edition, CU/minor, driver, OS/service image, hardware/service class, topology, schema, indexes, durability, isolation, backup, HA, and monitoring.
4. Generate and review pair-diff; only engine-specific implementation differences may remain.
5. Seal run order using a recorded random seed before results exist.

### Phase B — provision and verify

1. Create isolated candidates from immutable automation.
2. Confirm CPU topology, memory, storage device/class, filesystem, network, clock, NUMA, power/virtualization class, and client separation.
3. Apply schema and engine profile.
4. Run role/RLS/schema/config/dependency/edition verification.
5. Load the same generated dataset and age it through the same history schedule.
6. Snapshot/checkpoint the clean pre-run state for deterministic reset.

### Phase C — warmup

1. Start the fixed workload without recording decision metrics.
2. Track throughput, p95 latency, CPU, I/O, cache, queue age, WAL/log rate, waits, checkpoint/maintenance.
3. **ESTIMATE:** warm for at least 20 minutes and until three consecutive equal windows meet the preregistered stability rule, initially coefficient of variation no more than 5% for throughput and p95.
4. If stability is not reached within the maximum warmup, mark `UNSTABLE`; do not cherry-pick a stable interval.

### Phase D — measure

1. **ESTIMATE:** record at least 45 minutes for ordinary steady profiles.
2. Retain every operation sample and error.
3. Do not clear caches, restart, checkpoint, update statistics, or tune during the window unless the workload profile explicitly tests that action.
4. End only at the predefined duration/sample count or a hard stop.

### Phase E — fault/maintenance phase

Run only the named fault profile. Capture exact start, detection, containment, commit ambiguity, recovery, backlog drain, and cleanup. Fault controllers are test-only and absent from production artifacts.

### Phase F — reconcile

1. Quiesce new work without deleting state.
2. Compare receipts, inbox, work, event identity, facts, aggregates, quarantine, partitions, and query results to the oracle.
3. Classify every mismatch before performance analysis.
4. A hard mismatch disqualifies the run even if performance is excellent.

### Phase G — seal and clean

1. Hash all evidence and generate privacy/cardinality reports.
2. Revert/destroy resources according to manifest.
3. Prove database, backup, object storage, network, credential, key, process, and billing cleanup.
4. Only then mark evidence complete.

## 8.5 Metrics and statistical analysis plan — mandatory artifact

### 8.5.1 Primary metrics

| Category | Metrics |
|---|---|
| Correctness | false receipts, final duplicate effects, identity conflicts handled, cross-realm accepts, oracle mismatches, missing/extra query rows |
| Ingestion | durable receipts/s, batch latency p50/p95/p99, bytes/s, response-loss recovery, error/retry classes |
| Materialization | events/s, batch completion latency, oldest queue age, lease retries/losses, poison progress, duplicate ratio |
| Resources | client/DB CPU, memory, connections, threads/workers, storage IOPS/throughput/latency, temp, network |
| Log/maintenance | WAL/log bytes per uncompressed and compressed payload byte, flush latency, checkpoint/log-backup rate, bloat/fragmentation, vacuum/index/statistics time |
| Reports | exact-result rate, latency p50/p95/p99, timeout, ingestion degradation ratio, replica freshness/lag |
| Lifecycle | partition operation duration/blocking/log bytes, late-arrival outcome, retention duration, backup duration/impact, restore/PITR duration |
| HA | detection, fencing, failover, reconnect, ambiguous reconciliation, backlog drain, data loss within declared domain |
| Cost | cost per million durably received events, per million materialized events, retained TB-month, thousand report queries, 3-year TCO |
| Operations | operator success, manual steps, privileged steps, pages/alerts, maintenance hours, training/support assumptions |

### 8.5.2 Repetitions and pairing

- Use randomized paired blocks: one PostgreSQL run and one SQL Server run under the same workload/environment generation and close temporal proximity.
- **ESTIMATE:** minimum seven independent paired repetitions and maximum fifteen before design review.
- Each repetition starts from the same aged-state recipe, not a copied database from the other engine.
- Block order is randomized and recorded before execution.
- Failed product runs remain in the data. Harness-fault runs are marked and repeated as new linked runs; they are not silently discarded.

### 8.5.3 Confidence intervals

- Report raw distributions, median, p50/p95/p99 where sample count supports them, and throughput.
- Use paired ratios/differences by block.
- **RECOMMENDATION:** BCa bootstrap 95% confidence intervals for medians, p95, and paired ratios; document resample seed/count.
- If p99 has insufficient independent observations or is dominated by coarse sampling, label it `INSUFFICIENT_EVIDENCE` rather than extrapolating.
- Multiple workload profiles are reported separately; no single synthetic composite score hides a hard failure.

### 8.5.4 Stability and saturation

- Warmup stability is preregistered.
- Saturation sweep increases offered load until queue age or latency no longer reaches steady state, errors rise, or a hard resource limit appears.
- Sustainable capacity is the greatest offered load whose confidence interval satisfies all approved latency/queue/resource/error requirements with required headroom.
- The “knee” and failure mode are published even when below demand.

### 8.5.5 Decision weighting and sensitivity

Hard gates are evaluated first. Only passing profiles receive a score.

Suggested weight ranges are **ESTIMATE/RECOMMENDATION**, not approval:

| Dimension | Suggested range |
|---|---:|
| durability, restore, and failover | 25–40 |
| performance and capacity headroom | 15–30 |
| operations/on-call/supportability | 10–25 |
| three-year TCO | 15–30 |
| security and realm isolation | 10–20 |
| available skills/training | 5–15 |
| portability/exit complexity | 0–10 |

The approved weights must sum to 100. Run a grid or Monte Carlo sensitivity over approved ranges. If the winner changes across plausible weights or cost ranges, the outcome is **NO ROBUST WINNER**. Human owners may then select transparently on strategic grounds, request more evidence, or retain both as bounded options; the analysis may not manufacture certainty.

## 8.6 Operations, skills, license, and TCO matrix — mandatory artifact

| Dimension | PostgreSQL candidate | SQL Server candidate | Evidence required | Decision effect |
|---|---|---|---|---|
| Engine license | PostgreSQL License permits use/modification/distribution; no engine license fee [W28] | edition and licensing model required; per-core/server+CAL/subscription/PAYG options exist [W29, W30] | Legal/Procurement record and exact topology | TCO, deployment constraints |
| Point-in-time price input | no community engine list price; support/service separate | Microsoft SQL Server 2025 pricing PDF lists estimated retail, including Enterprise and Standard per-core/server/CAL and subscription/PAYG figures; reseller quote required [W30] | dated quote and benefits/discounts | range, not architecture truth |
| Edition limits/features | community engine; features/extensions/support provider selected separately | Standard and Enterprise differ in compute/memory limits, online operations, and availability-group capabilities; Developer editions are dev/test only [W13] | edition verifier and production quote | candidate identity; may disqualify Standard |
| OS | commonly Linux; exact platform is human standard | Windows and Linux are possible; exact feature/support profile required | strategic OS/platform decision and ops evidence | cost/skills/tooling |
| HA | streaming replication and external/native orchestration choices; topology/support owner required [W11, W12] | Basic AG for Standard and full AG capabilities for Enterprise; cluster/listener dependencies [W22–W24] | real failover/fencing drill | hard gate and TCO |
| Read reporting | physical standby can serve read-only with lag/recovery-conflict behavior | readable AG secondary depends on edition/topology; using secondary for reports can affect passive-failover licensing | report/lag and licensing review | performance/TCO |
| Backup/PITR | `pg_basebackup`/WAL archive or admitted tool/service; actual restore required [W11] | native full/diff/log backup/restore; actual restore required [W25–W27] | recurring restore drill | hard gate |
| Routine maintenance | autovacuum/vacuum, analyze, reindex, WAL/slots, bloat | statistics, index maintenance, ghost cleanup, log backup, AG health | 24h soak and runbook | on-call/maintenance cost |
| Partition operations | declarative range partitions; attach/detach/index considerations [W05, W06] | partition functions/schemes, aligned indexes, switching; edition/online-operation differences [W18] | active-load DDL tests | retention/availability |
| Bulk client | Npgsql binary COPY | `SqlBulkCopy` | provider admission and paired tests | throughput/resource |
| .NET driver | Npgsql, PostgreSQL License, reviewed v10.0.3 [R03] | Microsoft.Data.SqlClient, MIT, reviewed v7.0.2 [R04] | dependency/security/protocol tests | supply chain and support |
| Monitoring | PostgreSQL stats, `pg_stat_statements`, OS/exporter chosen [W08, W09] | DMVs, Query Store/extended events/agent/tooling as selected | privacy-safe profile and cardinality | diagnostics/on-call |
| Commercial support | optional third-party/vendor/cloud support; exact SLA and skills unknown | Microsoft support/licensing ecosystem; exact contract unknown | quotes and escalation drill | TCO/risk |
| Existing skills | **UNKNOWN** | **UNKNOWN** | blind exercises and inventory, not anecdotes | weighted human input |
| Patch cadence | PostgreSQL minor releases and five-year major support policy [W02] | CUs/GDRs and product lifecycle; exact CU evidence [W14, W15] | patch/rollback drill and owner | recurring qualification cost |
| Managed options | Azure Database for PostgreSQL, AWS RDS/Aurora-compatible options, Google Cloud SQL and others; each is separate profile | Azure SQL Managed Instance/SQL Server VM, AWS RDS for SQL Server and others; each separate profile | service-specific backup/HA/failover drills | operations/TCO, not engine-only score |
| Migration/exit | logical/physical tools, SQL dialect and extensions create switching cost | T-SQL, edition features, agent/integration ecosystem create switching cost | schema/query portability inventory | strategic sensitivity |
| On-call burden | vacuum/replication/WAL/backup/orchestrator and Linux skills | AG/cluster/log backup/index/edition/licensing and OS skills | defined incident set and time-on-task | operations score |

### Point-in-time SQL Server list-price snapshot

**FACT, not a quote or licensing approval.** The reviewed SQL Server 2025 pricing document publishes estimated retail prices including approximately USD 15,123 per two-core pack for Enterprise and USD 3,945 per two-core pack for Standard per-core, plus Standard server/CAL and subscription/PAYG options. Exact eligibility, minimums, passive failover, virtualization, cloud benefits, reseller discounts, and regional terms require Microsoft licensing materials and Procurement/Legal review. [W29, W30]

### TCO formula

```text
ThreeYearTCO =
    engine_and_os_license_or_subscription
  + primary_compute_and_memory
  + HA_and_DR_compute
  + storage_IO_and_capacity
  + backup_object_storage_and_egress
  + monitoring_and_security_tooling
  + managed_service_or_support_contract
  + DBA/SRE/on_call_hours
  + training_and_hiring
  + patching_and_recurring_qualification
  + migration_and_dual_run
  + restore/failover_exercises
  + expected_incident_cost_range
  + decommission_and_exit_cost
```

The analysis also reports:

```text
cost_per_million_durable_receipts
cost_per_million_materialized_events
cost_per_retained_TB_month
cost_per_thousand_Q01_to_Q10_queries
cost_per_successful_restore_drill
```

No cost result is valid when edition/topology, support, people, or DR inputs are blank.


# 9. Architecture fitness functions and measurable acceptance criteria

## 9.1 Fitness-function policy

**RECOMMENDATION.** The database ADR MUST evaluate fitness in two stages:

1. **hard invariants and evidence completeness** — one failure disqualifies that exact engine/edition/topology/profile;
2. **weighted comparison among profiles that passed every hard gate** — cost, speed, operations, skills, portability, and strategic fit may then distinguish them.

A score MUST NOT average away a durability, realm-isolation, restore, security, or evidence failure. A passing engine name also does not transfer to another edition, patch, service tier, storage class, HA topology, driver, schema variant, or configuration.

## 9.2 Non-negotiable hard fitness functions

| ID | Fitness function | Measurement | Acceptance | Failure consequence |
|---|---|---|---|---|
| FF-01 | durable custody truth | compare every emitted receipt with the independent server durability ledger and crash/failover history | `false_durable_receipts = 0` | disqualify exact profile; ingestion and endpoint cleanup remain blocked |
| FF-02 | one final business effect | reconcile natural event identities, identity-ledger rows, facts, aggregates, quarantine, retries, and restores | `duplicate_final_business_effects = 0` and `missing_final_effects = 0` for every committed test input | disqualify profile; open defect/ADR |
| FF-03 | realm isolation | hostile connection, pooled-session, RLS, API, backup/restore, report, and admin-negative corpus | `cross_realm_reads + writes + leases + deletes + receipts = 0` | security stop; no score |
| FF-04 | acknowledged-data durability | compare receipts against restored/promoted state inside the declared failure domain | `acknowledged_batches_lost = 0` within the candidate's declared and actually tested domain | disqualify topology; do not broaden receipt semantics |
| FF-05 | semantic equivalence | canonical result hashes for every query, materialization, late-arrival, poison, retention, and replay scenario | `canonical_result_mismatches = 0` | schema/workload defect or engine profile disqualified |
| FF-06 | lease fencing | force lease expiry, clock movement, worker pause, restart, failover, and concurrent claim | `stale_worker_state_changes = 0`; every stale completion is rejected or idempotently recognized | disqualify lease implementation |
| FF-07 | exact replay | replay same batch/body after lost response and after failover | same receipt/custody outcome; no new business effect; `identity_conflicts = 0` except deliberately conflicting fixtures | disqualify receipt/idempotency design |
| FF-08 | restore correctness | restore from each approved backup class and reconcile all ledgers, policy state, tombstones, and visibility | `restore_reconciliation_errors = 0`; restore evidence complete; readiness withheld until validation | disqualify backup profile |
| FF-09 | failover fencing | detect accepted writes on more than one primary or an unfenced old primary | `accepted_split_brain_writes = 0`; one authoritative writable primary at a time | disqualify HA topology |
| FF-10 | retention safety | exercise detach/switch/drop/delete with late arrivals, legal hold fixture, backup, reporting, and restore | `wrong_partition_deletes = 0`; held/undeletable rows preserved; deleted data not visible after readiness | disqualify partition/retention design |
| FF-11 | privacy-safe evidence | exact canaries across SQL text, parameters, plans, waits, traces, logs, metrics, dumps, backups, and evidence bundle | `forbidden_value_or_derivative_escapes = 0`; mandatory positive controls all detected | privacy incident; stop all dependent work |
| FF-12 | configuration identity | compare effective settings, extensions/features, edition, build, driver, schema, statistics, storage, and HA state against manifest | `unexplained_configuration_drift = 0` | run invalid; no comparison score |
| FF-13 | cleanup | compare lab resources, credentials, databases, backups, files, agents, jobs, routes, certificates, and monitoring objects before/after | `cleanup_failures = 0` | run and aggregate gate fail |
| FF-14 | reproducibility | repeat from clean inputs on a second authorized runner and compare manifests and conclusions | input/package/schema/workload digests equal; result differences fall inside declared statistical/operational explanation | no ADR until explained |
| FF-15 | production-shaped evidence | verify approved workload distributions, retention, query corpus, topology, service class, and owner inputs are present | every mandatory field non-null and approved; synthetic-only status explicit where still applicable | gate remains open; no engine selection |
| FF-16 | owner and runbook readiness | execute defined blind incidents and check accountable approvals | every blocking function assigned; every mandatory runbook executed successfully | no production/canary selection |

## 9.3 Capacity and latency fitness functions

The benchmark MUST report offered load and completed durable work separately. Client-side submission rate is not throughput.

```text
DurableReceiptRate =
    valid_durable_custody_receipts / measurement_seconds

MaterializationRate =
    newly_materialized_unique_business_effects / measurement_seconds

RequiredHeadroom = HD_REQUIRED_CAPACITY_HEADROOM

SustainableCapacity =
    greatest offered load where all hard gates pass
    AND queue growth is non-positive after warmup
    AND approved latency/resource limits pass
    AND maintenance/reporting/failure companions pass

CapacityHeadroomRatio =
    SustainableCapacity / HD_REQUIRED_PEAK_DURABLE_RECEIPT_RATE
```

**HUMAN DECISION.** `HD_REQUIRED_PEAK_DURABLE_RECEIPT_RATE`, `HD_REQUIRED_CAPACITY_HEADROOM`, latency limits, burst duration, and recovery backlog deadline are not supplied. Until approved, capacity results are descriptive and cannot close the ADR.

For each operation class, publish at least:

- p50, p90, p95, p99, and maximum latency;
- throughput and offered load;
- timeout, cancellation, retry, conflict, quarantine, and rejection counts;
- confidence intervals and run-to-run distributions;
- queue depth/age and oldest unprocessed custody age;
- warm/cold-cache and ordinary/failure modes separately.

A candidate meets a latency fitness function only when the entire approved confidence interval is within the approved bound, or when the approved statistical plan explicitly defines another conservative decision rule.

## 9.4 Log, storage, and write-amplification fitness

```text
DatabaseGrowthPerMillionEvents =
    delta_primary_database_bytes / unique_materialized_events * 1_000_000

BackupGrowthPerMillionEvents =
    delta_backup_and_archive_bytes / unique_materialized_events * 1_000_000

LogAmplificationCompressed =
    durable_WAL_or_transaction_log_bytes / accepted_compressed_batch_bytes

LogAmplificationUncompressed =
    durable_WAL_or_transaction_log_bytes / canonical_uncompressed_payload_bytes

IndexAmplification =
    total_index_bytes / retained_fact_table_bytes

MaintenanceRewriteRatio =
    bytes_written_by_maintenance / bytes_written_by_business_workload
```

The result MUST distinguish:

- primary data, indexes, temporary/staging activity, WAL/transaction log, backups, archive/PITR logs, replicas, and diagnostic evidence;
- user workload writes from checkpoint, vacuum, ghost cleanup, index rebuild/reorganize, statistics, backup, and replication writes;
- logical retained bytes from provisioned/billed storage;
- compression settings and their CPU cost.

**RECOMMENDATION.** No universal amplification threshold is accepted. The human-approved storage, backup, I/O, cost, and recovery budgets become the pass/fail inputs. The gate rejects an unexplained discontinuity, unbounded growth under a stable workload, inability to preserve log chain/WAL archive, or maintenance that violates approved availability.

## 9.5 Work-leasing fitness

```text
LeaseDuplicateExecutionRate =
    work_items_executed_by_more_than_one_live_owner / claimed_work_items

LeaseUsefulCompletionRate =
    successfully_fenced_completed_items / eligible_claims

LeaseStarvationAge =
    max(now - first_eligible_at) for continuously eligible work

LeaseFairnessByRealm =
    distribution of service lag after normalizing for each realm's offered work
```

Acceptance requires:

- no stale owner can commit after lease loss;
- duplicate physical execution, when deliberately induced, produces one final effect;
- no page-lock/table-lock or plan change silently makes eligible work permanently invisible;
- a noisy realm cannot make another approved realm exceed its approved service-lag budget;
- poison work moves to a bounded, explicit state and does not spin forever;
- every claim query remains a scheduling primitive only, never an authoritative completeness query.

Exact fairness and starvation limits are **HUMAN DECISION** inputs. The experiment still publishes the complete distributions and worst cases.

## 9.6 Report-coexistence fitness

For each report/query class `Q01`–`Q10`:

```text
ReportInterferenceRatio(metric) =
    metric_with_report_load / metric_without_report_load

IngestDegradation =
    1 - (durable_receipt_rate_with_reports / durable_receipt_rate_baseline)

ReportFreshnessLag =
    report_visible_cutoff_time - newest_durably_materialized_event_time
```

The comparison MUST test:

- reports on the primary;
- approved aggregate/read-model queries;
- a read replica/secondary only when that topology and its cost/license are candidates;
- lag, recovery conflicts, redo pressure, long transactions, memory grants/work memory, temp space, plan regressions, and cancellation;
- concurrency with ingest, materialization, partition maintenance, backup, and failover.

**RECOMMENDATION.** The simplest initial target is bounded reports against governed aggregates on the primary. Move reports to a secondary only when measured coexistence, freshness, failover, operations, and TCO evidence is better overall. A readable secondary is not “free capacity.”

## 9.7 Maintenance fitness

```text
MaintenanceDutyCycle =
    maintenance_active_seconds / wall_clock_seconds

MaintenanceAvailabilityViolation =
    sum(seconds where approved ingest/query limits fail because of maintenance)

StatisticsStaleness =
    engine-specific measured divergence from the approved analyzed state
```

Pass conditions:

- routine maintenance is bounded, observable, repeatable, and represented in TCO/on-call estimates;
- no required operation relies on an edition or managed-service feature absent from the candidate manifest;
- partition attach/detach/switch, index creation/rebuild/reorganize/reindex, vacuum/analyze/statistics, backup, and log/WAL retention are tested under load;
- no maintenance task requires broad tenant data access or emits forbidden values;
- maintenance failure has a tested recovery and cleanup path;
- the 24-hour soak has no unexplained monotonic bloat, log growth, queue growth, handle/session leak, or performance collapse.

## 9.8 HA, restore, and retention fitness

The following placeholders are mandatory inputs, not values selected here:

```text
HD_RPO
HD_RTO
HD_FAILOVER_DETECTION_LIMIT
HD_RESTORE_VALIDATION_LIMIT
HD_REPORT_RECOVERY_PRIORITY
HD_ALLOWED_DATA_LOSS_CLASS
HD_RETENTION_POLICY
HD_LATE_ARRIVAL_POLICY
```

Fitness functions:

```text
MeasuredRPO =
    newest_expected_durable_custody_time
  - newest_recovered_valid_custody_time

MeasuredRTO =
    incident_start
  -> identity/connection recovery
  -> database writable
  -> invariant validation complete
  -> ingestion readiness restored

FailoverWriteUnavailability =
    time from last accepted write on old primary
    to first accepted and receipt-valid write on new primary

RestoreReadinessTime =
    restore_start
    to completed schema/invariant/receipt/realm/deletion validation
```

A candidate passes only when all repetitions meet the approved objective and zero hard invariants fail. Reporting a fast promotion before invariant validation does not satisfy RTO. A backup command returning success does not satisfy restore fitness.

## 9.9 Operations, skills, and support fitness

Use a fixed blind-exercise corpus. For each incident, record:

```text
TimeToDetect
TimeToCorrectlyClassify
TimeToContain
TimeToRecoverService
TimeToReconcileData
TimeToCleanUp
EscalationsRequired
UnsafeActionsAttempted
RunbookDeviations
SpecialistHours
```

Mandatory incidents include:

- blocked/slow lease queue;
- runaway report;
- disk/log/WAL pressure;
- failed backup;
- point-in-time restore;
- replica lag;
- planned and unplanned failover;
- stale statistics or bad plan;
- index/partition maintenance failure;
- expired/incorrect credential or realm context;
- receipt conflict;
- corruption/integrity hold;
- patch rollback;
- evidence and cleanup failure.

**HUMAN DECISION.** Available on-call skills, support hours, vendor support, and acceptable recovery effort are unknown. The conservative default is that neither engine is operationally approved. Self-reported familiarity is supporting context only; timed blind exercises and staffing/coverage records are the decision evidence.

## 9.10 Cost-normalized fitness

A cost result is valid only for the exact edition, topology, support arrangement, service tier, reservation/discount, OS, backup, network, monitoring, staffing, and DR profile in the manifest.

```text
CostPerMillionDurableReceipts =
    comparable_period_cost / durable_receipts * 1_000_000

CostPerMillionMaterializedEffects =
    comparable_period_cost / unique_materialized_effects * 1_000_000

CostPerRetainedTBMonth =
    comparable_period_cost / average_retained_TB_months

CostPerSuccessfulRestoreDrill =
    annual_backup_restore_people_and_service_cost / successful_restore_drills

ThreeYearRiskAdjustedTCO =
    deterministic_three_year_cost
  + approved_expected_incident_cost_range
  + approved_migration_exit_cost_range
```

Every TCO line MUST identify whether it is:

- quoted/contracted;
- public point-in-time list price;
- measured consumption;
- salary/hour assumption;
- modelled range;
- excluded or unknown.

Unknown material inputs produce a range or `INCOMPLETE`, not zero.

## 9.11 Decision robustness and sensitivity fitness

For every approved weight vector and cost range:

1. remove profiles failing any hard gate;
2. normalize soft metrics using declared direction and range;
3. calculate total score without rounding intermediate values;
4. repeat over approved weight, license, support, staffing, growth, and cloud/on-prem ranges;
5. publish the proportion and exact regions in which each candidate wins; do not turn that proportion into a confidence probability;
6. run one-at-a-time and global sensitivity;
7. list the smallest input change that reverses the decision.

Decision states:

| State | Rule |
|---|---|
| `NO_PROFILE_PASSES` | both fail at least one hard gate; redesign or remediate, do not select |
| `ONE_PROFILE_PASSES` | only one passes all hard gates; selection still needs TCO/skills/owner approval and no hidden strategic blocker |
| `ROBUST_WINNER` | both pass, and one wins across every approved plausible weight/cost range |
| `CONDITIONAL_WINNER` | winner depends on a recorded strategic, staffing, license, support, or workload assumption |
| `NO_ROBUST_WINNER` | candidates trade places within approved ranges or scores are practically indistinguishable |
| `EVIDENCE_INCOMPLETE` | a mandatory production-shaped, restore/failover, TCO/skills, or owner input is absent |

A `CONDITIONAL_WINNER` is a valid decision state when the human authority explicitly accepts the named condition. The analysis must not hide it behind one arbitrary weight set.

## 9.12 Accessibility and evidence usability fitness

Accessibility is relevant to the benchmark and operations artifacts even though it is not an end-user portal comparison.

Acceptance requires:

- every chart also has a machine-readable CSV/Parquet table and text summary;
- color is never the only status encoding;
- units, axes, sample counts, exclusions, confidence intervals, and missing values are explicit;
- command output has stable text/JSON forms usable without a graphical console;
- runbooks are keyboard-navigable, use descriptive headings, and avoid screenshot-only instructions;
- evidence bundles avoid flashing/animated dashboards and have printable/static alternatives;
- engine-specific consoles are not the sole recovery path;
- blind-support exercises include at least one CLI/text-only route.

## 9.13 Consolidated acceptance matrix

| Area | Hard pass | Soft comparison after pass | Evidence owner |
|---|---|---|---|
| custody/idempotency | zero false receipts, losses, duplicate effects, conflicts | receipt latency, replay cost | Ingestion/Data Reliability |
| realm/security | zero cross-realm action and canary escape | policy complexity, review burden | Security/IAM/Privacy |
| schema/data quality | zero canonical mismatches | storage/index footprint, migration effort | Data Architecture |
| leases/workers | zero stale-owner commit | throughput, fairness, starvation, operator effort | Server Runtime |
| ingestion | no loss/corruption | throughput, latency, log amplification, CPU | Performance/SRE |
| reports | no unsafe access or invariant effect | freshness, interference, query latency | Product/Data/SRE |
| retention | zero wrong delete/visibility failure | operation duration, blocking, storage recovery | Records/Data Reliability |
| backup/restore | zero reconciliation error | RPO/RTO margin, cost, operator time | SRE/DB Operations |
| HA/failover | zero accepted split-brain write | unavailability, lag, automation burden | SRE/Platform |
| observability | zero forbidden value, bounded cardinality | diagnostic time, tooling cost | Observability/Privacy |
| operations/skills | every mandatory incident safely resolved | time-on-task, specialist need, coverage | Operations/Support |
| supply chain | exact admitted versions and no unknown executable byte | update cadence, support quality | Dependency/Release |
| TCO | complete approved model | three-year range and unit costs | Finance/Procurement/Product |
| reproducibility | clean rerun and complete evidence | execution cost/time | Verification |

# 10. Human decisions and owner questions

## 10.1 Decision boundary

Research and the benchmark may show consequences, but MUST NOT approve strategic standards, budget, license terms, staffing, SLO/RPO/RTO, reporting priority, retention, or production deployment. Until the relevant decision record exists, the conservative state is:

- database ADR remains `PROPOSED/MEASUREMENT-GATED`;
- PostgreSQL remains the reference implementation, not the production winner;
- SQL Server remains an equally serious benchmark candidate, not an assumed legacy default;
- no engine-specific production contract is published;
- cleanup of acknowledged endpoint/server payloads remains disabled outside T1 fixture policy;
- no external broker is added;
- no managed-service result is generalized to on-premises or another service.

## 10.2 Human decision register

Role names identify accountable functions, not assigned individuals.

| ID | HUMAN DECISION | Options to evaluate | Consequences | Conservative temporary default | Accountable function | Required owner questions |
|---|---|---|---|---|---|---|
| HD-16-01 | strategic database/platform standard | PostgreSQL; SQL Server; approved managed variants; exception model | constrains OS, skills, procurement, hosting, support, integration, exit cost | no strategic preference used as a benchmark pass; record it only in sensitivity | Enterprise Architecture with Technology Governance | Is either engine mandatory/preferred/prohibited? What is the exception process and migration horizon? |
| HD-16-02 | deployment model | self-managed on-prem; self-managed cloud VM; managed database; hybrid/DR combinations | changes responsibility, HA controls, backup access, extensions/features, costs, evidence | compare self-managed lab first; managed profiles are separate candidates | Platform/Cloud Architecture with Operations | Which models are genuinely deployable? Are data locality, control, or vendor concentration constraints binding? |
| HD-16-03 | SQL Server edition and licensing model | Standard per-core; Standard server/CAL; Enterprise per-core; subscription/PAYG; cloud-included license | changes compute/memory/HA/online features and TCO; may change schema/maintenance plan | do not claim SQL Server profile until edition/topology is exact; test Standard and Enterprise only when both are realistic | Procurement/Legal/License Management with Architecture | Which edition is licensed/affordable? Are passive replicas, virtualization, containers, DR, or cloud benefits covered? |
| HD-16-04 | PostgreSQL support model | community/self-support; third-party support; cloud-provider support; distribution vendor | affects on-call depth, escalation, patches, SLA, cost, approved binaries/extensions | community docs plus internal T1 lab only; no production support claim | Operations/Support with Procurement | Is 24x7 vendor escalation required? Which distribution and support boundary are approved? |
| HD-16-05 | budget and three-year cost horizon | capital/operating budget ranges; reserved/on-demand; growth and exit scenarios | can reverse the result even when performance is similar | cost model `INCOMPLETE`; no zero-valued unknowns | Product/Finance/Procurement | What spend range, horizon, discount assumptions, growth range, and contingency are approved? |
| HD-16-06 | available skills and on-call coverage | current team; training; hiring; managed support; shared DBA function | changes risk, recovery time, and recurring cost | neither engine operationally approved until blind exercises and coverage record pass | Engineering/Operations Leadership | Who covers nights/weekends? What incidents must be solved internally? What training/hiring lead time is acceptable? |
| HD-16-07 | RPO/RTO and failure domain | per service/data class objectives; zonal/regional/site failure; backup and replica loss | defines receipt, HA, backup, topology, cost, and pass/fail | receipt means only the actually proved local durable domain; production cleanup disabled | Product/Risk with SRE and Data Reliability | What data loss and outage are acceptable? At what readiness point is service “recovered”? Which disasters are in scope? |
| HD-16-08 | reporting freshness and priority | near-real-time; bounded delay; scheduled; primary vs aggregate vs replica | changes indexes, replicas, report isolation, cost, and ingest interference | bounded aggregate queries on primary; reports may be throttled/cancelled before ingestion | Product/Data Owner with SRE | Which reports are critical? What freshness/latency/concurrency is required? May reports lag or be unavailable during recovery? |
| HD-16-09 | production workload distribution | endpoint rates, payload bytes, duplicates, reconnect bursts, outages, poison, skew, growth | supplies production-shaped benchmark and capacity gate | use transparent synthetic range; mark gate open | Product/Data Owner with Endpoint/Server SRE | What percentile distributions are approved? Which metadata can be measured safely? What future growth range must be covered? |
| HD-16-10 | retention and late-arrival policy | retention by fact/custody/audit; event-time vs receipt-time; grace; holds; correction | determines partition key/grain, deletion, backup, and restore behavior | no production partition deletion; retain T1 data only per fixture manifest | Records/Data Governance with Legal/Privacy/Product | Which clock governs deletion? How late can data arrive? What holds and deletion proof are required? |
| HD-16-11 | HA/DR topology | single node plus restore; synchronous local HA; asynchronous DR; multi-zone/region/site | changes failure domain, latency, licensing, operations, and cost | no production topology; test one explicit local HA and one restore profile per engine | SRE/Platform with Risk | What failures must be automatic? Who controls fencing? Is cross-region/site required? What lag is acceptable? |
| HD-16-12 | managed-service candidate set | Azure/AWS/Google/private offerings with exact tier and version | feature restrictions, maintenance windows, metrics, backups, failover, lock-in differ | no managed service inherits the engine score | Cloud Platform/Product/Procurement | Which providers/regions/tiers are approved? Which native controls are unavailable? How are exports/exit tested? |
| HD-16-13 | encryption and key management | platform storage encryption; engine encryption; client/application fields; KMS/HSM; backup keys | affects CPU, restore, operations, support, and breach scope | use lab-only encryption profile; no production key decision | Security/Cryptographic Authority with Data Governance | What threats and compliance apply? Who owns keys, rotation, escrow, restore, revocation, and separation of duties? |
| HD-16-14 | production fields and indexes | exact minimized event fields, subject projection, time precision, application/site outputs, aggregates | determines row width, privacy, indexes, queries, and capacity | fictional schema fields and replaceable width classes only | Product/Data Owner with Privacy and Data Architecture | What is the minimum approved schema? Which fields may be indexed, reported, or retained? |
| HD-16-15 | realm isolation topology | shared database with RLS; database/schema per realm; dedicated deployment for selected realms | affects blast radius, cost, operations, migrations, cache keys, and support | shared logical schema plus defense-in-depth RLS in T1; no production approval | Security/IAM/Data Architecture/Product | Are any realms legally/contractually dedicated? What scale and noisy-neighbor limits apply? Who can administer across realms? |
| HD-16-16 | administrative and audit authority | DBA roles, deployment roles, break-glass, report/support access, approval separation | affects least privilege, audit, incident recovery, and staffing | separate test roles; no production broad owner login | Security/IAM/Operations Governance | Who may alter schema, RLS, backup, restore, failover, retention, and audit? What approvals and durable evidence are required? |
| HD-16-17 | maintenance and patch policy | cadence, emergency SLA, outage window, rolling/side-by-side, extension/driver updates | recurring qualification and availability cost | exact lab versions only; every change invalidates named evidence | Operations/Release/Security | How quickly must security fixes deploy? What rollback/support window exists? Which changes require full rerun? |
| HD-16-18 | observability and evidence retention | metric cardinality, query text policy, plans/waits, logs, access, retention | affects privacy, diagnosis, storage, and support | finite IDs/classes; no raw payload/query parameters; short T1 evidence | Observability/SRE with Privacy/Records | Which engine diagnostics are allowed? Who can access exact plans/text? How long is evidence retained? |
| HD-16-19 | acceptable operational complexity | maximum components, orchestrators, agents, extensions, clusters, consoles | can favor a simpler but costlier/slower profile | no external broker; minimal native topology per candidate | Architecture/Operations Leadership | Which extra control planes are supportable? What is the maximum specialist dependency? |
| HD-16-20 | commercial/support commitments | vendor SLA, internal escalation, customer commitments, maintenance communication | affects risk and recurring cost | no commercial support statement | Product Support/Operations Leadership | What service promise will be made? Which failure classes need vendor escalation? |
| HD-16-21 | migration and exit tolerance | dual-write/dual-run duration, portability target, acceptable downtime, decommission | influences engine-specific feature use and cost | keep contract/schema engine-neutral; engine-specific optimizations behind adapters | Architecture/Product/Data Migration Owner | How much lock-in is acceptable? What evidence is needed to move later? Which data must remain portable? |
| HD-16-22 | scoring weights and tie policy | approved weight ranges; hard floors; strategic tie-break | determines conditional/robust winner | publish unweighted facts and sensitivity; no single hidden score | Architecture Forum with Product/Risk/Finance/Operations | Which dimensions matter most? What score difference is material? Who may choose under `NO_ROBUST_WINNER`? |
| HD-16-23 | accountable database owner | internal DBA/SRE/product team; managed provider boundary | required for configuration, incidents, upgrades, restore, evidence | `UNASSIGNED` blocks ADR acceptance | Engineering/Operations Leadership | Who owns configuration, capacity, patching, restore, performance, security, and cost after go-live? |
| HD-16-24 | production approval | accept one exact engine/edition/topology or defer | converts evidence into authority and residual-risk acceptance | no production deployment | Designated Production/Risk Authority | Are all technical gates, owner assignments, legal/license decisions, budgets, and residual risks accepted? |

## 10.3 Required owner answers before a decision run is called production-shaped

The decision package MUST contain explicit answers to these questions:

1. What endpoint event/byte/batch/retry/outage distributions define the load, and who approved their privacy-safe derivation?
2. What exact peak, burst, backlog-clear, and growth requirements must the database meet?
3. What query corpus, concurrency, freshness, and report availability are required?
4. What is the authoritative retention clock, late-arrival grace, deletion proof, and legal-hold behavior?
5. What exact RPO, RTO, failure domain, and restore-readiness definition apply?
6. What SQL Server edition/license rights and what PostgreSQL support/distribution are realistically available?
7. Which OS, cloud/on-prem model, service tier, storage class, network, and security controls are approved?
8. Which engineers and support functions own the service, and what blind exercises did they pass?
9. What three-year budget range, support quote, people cost, training cost, growth, and exit cost are approved?
10. What strategic platform preference exists, and is it mandatory, weighted, or merely contextual?
11. Who may approve RLS/policy/schema/partition changes, failover, restore, retention, and break-glass actions?
12. What exact evidence expiry and requalification trigger apply after patches, configuration, schema, workload, driver, hardware, or topology changes?
13. What residual risks are accepted if the result is conditional rather than robust?
14. Who signs the final ADR and who can revoke it after an incident or cost/skill change?

# 11. CLI experiments/measurements and the exact evidence they must produce

## 11.1 Repository layout for the benchmark lane

```text
/src/tools/Uam.DbBench.Cli/
/src/tools/Uam.DbBench.Contracts/
/src/tools/Uam.DbBench.Generator/
/src/tools/Uam.DbBench.Oracle/
/src/tools/Uam.DbBench.Analysis/
/src/tools/Uam.DbBench.Adapters.PostgreSql/
/src/tools/Uam.DbBench.Adapters.SqlServer/
/benchmarks/database/v1/
  manifests/
  schemas/logical/
  schemas/postgresql/
  schemas/sqlserver/
  migrations/
  workloads/
  queries/
  faults/
  retention/
  operations/
  analysis/
  gates/
  runbooks/
/tests/database/{unit,contract,model,integration,restore,ha,security,performance}/
/evidence/database/<run-id>/
```

The oracle MUST NOT reference either engine adapter, production materializer, lease implementation, or query implementation. Engine adapters may translate the normative logical operations but may not change the workload mix, semantics, result projection, or pass rule.

## 11.2 Environment and secret rules

- Commands below use placeholders and environment-variable names only.
- Connection strings, hosts, users, addresses, certificate material, tokens, passwords, SSH configuration, and cloud account IDs MUST NOT appear in committed manifests, command transcripts, process arguments captured in evidence, or the result document.
- Authentication is injected by the approved runner/secret store and redacted before evidence publication.
- The harness records a one-way credential-profile ID, not secret content.
- Raw production data is prohibited. Only T1 fictional or separately approved aggregate workload parameters are accepted.
- `--dry-run` MUST produce the full operation/evidence plan without connecting.

## 11.3 Input verification and deterministic generation

```bash
# Verify allowlisted benchmark inputs, schemas, workload manifest, owner decisions,
# tool locks, and that no secret/raw-production file is included.
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  inputs verify \
  --manifest benchmarks/database/v1/manifests/experiment.json \
  --evidence "$EVIDENCE_DIR/00-inputs"

# Generate the canonical fictional population, batch stream, duplicate/retry stream,
# late-arrival and poison scenarios twice from a fixed seed and clock.
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  data generate \
  --manifest benchmarks/database/v1/manifests/experiment.json \
  --seed "$UAM_T1_SEED_ID" \
  --output "$RUN_DIR/canonical-data-a"

dotnet run --project src/tools/Uam.DbBench.Cli -- \
  data generate \
  --manifest benchmarks/database/v1/manifests/experiment.json \
  --seed "$UAM_T1_SEED_ID" \
  --output "$RUN_DIR/canonical-data-b"

# Build independent expected ledgers and compare the two generated roots.
dotnet run --project src/tools/Uam.DbBench.Oracle -- \
  truth build \
  --input "$RUN_DIR/canonical-data-a" \
  --output "$RUN_DIR/oracle"

dotnet run --project src/tools/Uam.DbBench.Cli -- \
  data compare-roots \
  --left "$RUN_DIR/canonical-data-a" \
  --right "$RUN_DIR/canonical-data-b" \
  --evidence "$EVIDENCE_DIR/01-generation"
```

Required evidence:

- source tree and dirty-state digest;
- manifest/schema/query/fault/runbook digests;
- classification and approval IDs;
- deterministic data roots and file hashes;
- generator/oracle build and dependency identities;
- canonical row/batch/query counts by fictional realm and scenario;
- mutation-positive controls and canary registry;
- proof that no unapproved input or secret-shaped value exists.

## 11.4 Provision and inventory commands

```bash
# Produce a connection-free plan first.
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  environment plan \
  --engine postgresql \
  --profile benchmarks/database/v1/manifests/postgresql-self-managed.json \
  --dry-run \
  --evidence "$EVIDENCE_DIR/02-pg-plan"

dotnet run --project src/tools/Uam.DbBench.Cli -- \
  environment plan \
  --engine sqlserver \
  --profile benchmarks/database/v1/manifests/sqlserver-self-managed.json \
  --dry-run \
  --evidence "$EVIDENCE_DIR/02-sql-plan"

# After lab authorization, provision through an approved provider adapter.
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  environment provision \
  --engine postgresql \
  --profile benchmarks/database/v1/manifests/postgresql-self-managed.json \
  --secret-profile "$UAM_DB_SECRET_PROFILE" \
  --evidence "$EVIDENCE_DIR/03-pg-provision"

dotnet run --project src/tools/Uam.DbBench.Cli -- \
  environment provision \
  --engine sqlserver \
  --profile benchmarks/database/v1/manifests/sqlserver-self-managed.json \
  --secret-profile "$UAM_DB_SECRET_PROFILE" \
  --evidence "$EVIDENCE_DIR/03-sql-provision"

# Capture effective engine, edition, build, OS/service image, CPU/memory/storage,
# driver, feature, collation, time-zone, durability, HA, and configuration facts.
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  environment inventory \
  --engine postgresql \
  --connection-profile "$UAM_PG_CONNECTION_PROFILE" \
  --evidence "$EVIDENCE_DIR/04-pg-inventory"

dotnet run --project src/tools/Uam.DbBench.Cli -- \
  environment inventory \
  --engine sqlserver \
  --connection-profile "$UAM_SQL_CONNECTION_PROFILE" \
  --evidence "$EVIDENCE_DIR/04-sql-inventory"
```

Required evidence:

- exact engine and build identities;
- SQL Server edition and effective feature limits;
- package/image/repository digests and licenses;
- CPU topology, memory, NUMA, storage class/size/IOPS/throughput/latency and filesystem;
- durability and checkpoint/log settings;
- locale/collation/time-zone and compatibility level;
- extensions/features, agents, jobs, trace flags/startup options;
- HA/replica/backup configuration;
- effective privileges for each benchmark role;
- monitoring configuration and cardinality budget;
- before-state cleanup manifest.

Any material mismatch between paired profiles invalidates the pair or requires a documented normalization decision and rerun.

## 11.5 Apply schema and verify semantic equivalence

```bash
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  schema apply \
  --engine postgresql \
  --variant P0 \
  --connection-profile "$UAM_PG_CONNECTION_PROFILE" \
  --evidence "$EVIDENCE_DIR/05-pg-schema-p0"

dotnet run --project src/tools/Uam.DbBench.Cli -- \
  schema apply \
  --engine sqlserver \
  --variant P0 \
  --connection-profile "$UAM_SQL_CONNECTION_PROFILE" \
  --evidence "$EVIDENCE_DIR/05-sql-schema-p0"

# Verify tables, constraints, indexes, RLS policies, procedures, grants,
# migration ledger, and canonical semantic contract.
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  schema verify \
  --engine postgresql \
  --expected benchmarks/database/v1/schemas/logical/schema-contract.json \
  --connection-profile "$UAM_PG_CONNECTION_PROFILE" \
  --evidence "$EVIDENCE_DIR/06-pg-schema-verify"

dotnet run --project src/tools/Uam.DbBench.Cli -- \
  schema verify \
  --engine sqlserver \
  --expected benchmarks/database/v1/schemas/logical/schema-contract.json \
  --connection-profile "$UAM_SQL_CONNECTION_PROFILE" \
  --evidence "$EVIDENCE_DIR/06-sql-schema-verify"
```

Required evidence:

- normalized catalog manifest;
- DDL and migration digest;
- constraint and index proof, including partition uniqueness behavior;
- exact role/grant/RLS matrix;
- hostile mutation results;
- proof that no engine-side trigger/default/computed value changes semantics;
- schema creation duration and log/storage cost;
- rollback/cleanup result.

## 11.6 Correctness, receipt, dedupe, and lease commands

```bash
# Run correctness first at low load.
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  correctness run \
  --engine postgresql \
  --scenario-set benchmarks/database/v1/workloads/correctness.json \
  --connection-profile "$UAM_PG_CONNECTION_PROFILE" \
  --evidence "$EVIDENCE_DIR/07-pg-correctness"

dotnet run --project src/tools/Uam.DbBench.Cli -- \
  correctness run \
  --engine sqlserver \
  --scenario-set benchmarks/database/v1/workloads/correctness.json \
  --connection-profile "$UAM_SQL_CONNECTION_PROFILE" \
  --evidence "$EVIDENCE_DIR/07-sql-correctness"

# Run lease/fencing campaign using the same logical operation history.
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  leases run \
  --engine postgresql \
  --schedule benchmarks/database/v1/faults/lease-schedule.json \
  --connection-profile "$UAM_PG_CONNECTION_PROFILE" \
  --evidence "$EVIDENCE_DIR/08-pg-leases"

dotnet run --project src/tools/Uam.DbBench.Cli -- \
  leases run \
  --engine sqlserver \
  --schedule benchmarks/database/v1/faults/lease-schedule.json \
  --connection-profile "$UAM_SQL_CONNECTION_PROFILE" \
  --evidence "$EVIDENCE_DIR/08-sql-leases"
```

Required evidence:

- every input batch and event identity with expected/actual final state;
- transaction boundary trace with no payload values;
- receipt ledger and server commit point;
- duplicate/replay/conflict outcomes;
- lease claim/renew/expire/fence history;
- lock/wait/deadlock/escalation summaries;
- worker fairness/starvation distributions;
- canonical result hashes and minimal counterexamples;
- cleanup/reseed proof.

## 11.7 Bulk-ingestion and materialization commands

```bash
# Load the identical canonical stream through the engine-specific provider adapter.
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  ingest run \
  --engine postgresql \
  --workload benchmarks/database/v1/workloads/ingest-steady.json \
  --provider-mode binary-copy \
  --connection-profile "$UAM_PG_CONNECTION_PROFILE" \
  --evidence "$EVIDENCE_DIR/09-pg-ingest"

dotnet run --project src/tools/Uam.DbBench.Cli -- \
  ingest run \
  --engine sqlserver \
  --workload benchmarks/database/v1/workloads/ingest-steady.json \
  --provider-mode sql-bulk-copy \
  --connection-profile "$UAM_SQL_CONNECTION_PROFILE" \
  --evidence "$EVIDENCE_DIR/09-sql-ingest"

# Materialize with identical worker counts and logical lease parameters.
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  workers run \
  --engine postgresql \
  --workload benchmarks/database/v1/workloads/materialize.json \
  --connection-profile "$UAM_PG_CONNECTION_PROFILE" \
  --evidence "$EVIDENCE_DIR/10-pg-materialize"

dotnet run --project src/tools/Uam.DbBench.Cli -- \
  workers run \
  --engine sqlserver \
  --workload benchmarks/database/v1/workloads/materialize.json \
  --connection-profile "$UAM_SQL_CONNECTION_PROFILE" \
  --evidence "$EVIDENCE_DIR/10-sql-materialize"
```

Required evidence includes raw per-operation timings, offered/completed load, queue age/depth, CPU/memory/I/O/temp/log/WAL, storage growth, network bytes, provider allocations/GC, plans, waits, retries, timeouts, and result reconciliation. The command records exact bulk API options and column mappings.

## 11.8 Workload matrix, reports, maintenance, and partition variants

```bash
# Run the paired matrix; order is randomized from the manifest seed.
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  matrix run \
  --engines postgresql,sqlserver \
  --variants P0,P1,P2 \
  --workloads benchmarks/database/v1/workloads/production-shaped-matrix.json \
  --run-plan benchmarks/database/v1/manifests/paired-run-plan.json \
  --evidence "$EVIDENCE_DIR/11-matrix"

# Execute report corpus with and without ingestion/materialization/maintenance.
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  reports run \
  --engines postgresql,sqlserver \
  --query-corpus benchmarks/database/v1/queries/q01-q10.json \
  --paired-plan benchmarks/database/v1/manifests/report-coexistence.json \
  --evidence "$EVIDENCE_DIR/12-reports"

# Run partition/retention operations under load.
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  retention run \
  --engines postgresql,sqlserver \
  --scenario-set benchmarks/database/v1/retention/scenarios.json \
  --evidence "$EVIDENCE_DIR/13-retention"

# Run 24-hour maintenance/soak profile after correctness gates pass.
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  soak run \
  --engines postgresql,sqlserver \
  --manifest benchmarks/database/v1/workloads/soak-24h.json \
  --evidence "$EVIDENCE_DIR/14-soak"
```

The matrix command MUST refuse to run when hardware/service class, load-generator headroom, configuration identity, data root, schema variant, query corpus, warmup, measurement duration, or repetition plan differs without an approved pairing exception.

## 11.9 Engine-native inspection commands

The harness SHOULD invoke engine-native CLIs through redacted wrappers so raw output can be retained in a restricted evidence area and a sanitized summary can be published.

### PostgreSQL examples

```bash
# Authentication comes from an approved non-logged service profile.
psql "service=$UAM_PG_SERVICE_PROFILE" \
  --set=ON_ERROR_STOP=1 \
  --file benchmarks/database/v1/operations/postgresql/capture-inventory.sql \
  --output "$RESTRICTED_EVIDENCE_DIR/postgresql-inventory.txt"

psql "service=$UAM_PG_SERVICE_PROFILE" \
  --set=ON_ERROR_STOP=1 \
  --file benchmarks/database/v1/operations/postgresql/capture-stats.sql \
  --output "$RESTRICTED_EVIDENCE_DIR/postgresql-stats.txt"

pg_verifybackup "$UAM_PG_BACKUP_PATH_PLACEHOLDER"
```

### SQL Server examples

```bash
# Endpoint and authentication are supplied by the approved runner profile.
sqlcmd -S "$UAM_SQL_ENDPOINT_PLACEHOLDER" \
  -d "$UAM_SQL_DATABASE_PLACEHOLDER" \
  -b \
  -i benchmarks/database/v1/operations/sqlserver/capture-inventory.sql \
  -o "$RESTRICTED_EVIDENCE_DIR/sqlserver-inventory.txt"

sqlcmd -S "$UAM_SQL_ENDPOINT_PLACEHOLDER" \
  -d "$UAM_SQL_DATABASE_PLACEHOLDER" \
  -b \
  -i benchmarks/database/v1/operations/sqlserver/capture-stats.sql \
  -o "$RESTRICTED_EVIDENCE_DIR/sqlserver-stats.txt"
```

**Security rule.** The published evidence MUST not contain connection endpoints, login names, database names derived from an organization, certificate subjects, file paths, SQL parameters, customer/realm labels, or payload text. Exact engine plans and query texts are retained only when they contain fixed T1 statements and pass the canary scanner.

## 11.10 Backup, restore, and PITR commands

```bash
# Create backup through the candidate-specific adapter and record exact boundary.
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  backup create \
  --engine postgresql \
  --profile benchmarks/database/v1/operations/postgresql/backup-profile.json \
  --connection-profile "$UAM_PG_CONNECTION_PROFILE" \
  --evidence "$EVIDENCE_DIR/15-pg-backup"

dotnet run --project src/tools/Uam.DbBench.Cli -- \
  backup create \
  --engine sqlserver \
  --profile benchmarks/database/v1/operations/sqlserver/backup-profile.json \
  --connection-profile "$UAM_SQL_CONNECTION_PROFILE" \
  --evidence "$EVIDENCE_DIR/15-sql-backup"

# Restore into a new isolated target; never overwrite the source candidate.
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  restore run \
  --engine postgresql \
  --backup-evidence "$EVIDENCE_DIR/15-pg-backup/backup.json" \
  --target-profile "$UAM_PG_RESTORE_TARGET_PROFILE" \
  --point-in-time "$UAM_T1_PITR_MARKER_ID" \
  --evidence "$EVIDENCE_DIR/16-pg-restore"

dotnet run --project src/tools/Uam.DbBench.Cli -- \
  restore run \
  --engine sqlserver \
  --backup-evidence "$EVIDENCE_DIR/15-sql-backup/backup.json" \
  --target-profile "$UAM_SQL_RESTORE_TARGET_PROFILE" \
  --point-in-time "$UAM_T1_PITR_MARKER_ID" \
  --evidence "$EVIDENCE_DIR/16-sql-restore"

# Reconcile before marking ready.
dotnet run --project src/tools/Uam.DbBench.Oracle -- \
  restore reconcile \
  --expected "$RUN_DIR/oracle" \
  --postgresql "$EVIDENCE_DIR/16-pg-restore/result.json" \
  --sqlserver "$EVIDENCE_DIR/16-sql-restore/result.json" \
  --evidence "$EVIDENCE_DIR/17-restore-reconciliation"
```

Required evidence:

- backup start/end and included log/WAL boundary;
- exact tool/build/config and checksums;
- encrypted/key-profile class without key material;
- backup size, throughput, CPU/I/O impact, archive/log continuity;
- restore/PITR target and timeline;
- schema/invariant/realm/receipt/effect/quarantine/retention/tombstone reconciliation;
- measured RPO/RTO from incident start through readiness;
- proof source environment was not mutated;
- deletion of temporary restore targets and backup test artifacts.

## 11.11 Failover commands

```bash
# The controller invokes only approved topology operations; no arbitrary shell/SSH
# command is accepted from a manifest.
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  ha exercise \
  --engine postgresql \
  --topology "$UAM_PG_HA_PROFILE" \
  --fault-plan benchmarks/database/v1/faults/ha-failover.json \
  --evidence "$EVIDENCE_DIR/18-pg-ha"

dotnet run --project src/tools/Uam.DbBench.Cli -- \
  ha exercise \
  --engine sqlserver \
  --topology "$UAM_SQL_HA_PROFILE" \
  --fault-plan benchmarks/database/v1/faults/ha-failover.json \
  --evidence "$EVIDENCE_DIR/18-sql-ha"
```

The exercise MUST include planned switchover, unplanned primary loss, response loss after receipt commit, network partition/fencing, replica lag, restart, and rejoin. Required evidence includes role timeline, fencing proof, connection recovery, accepted/rejected writes, batch identities, receipt ledger, RPO/RTO, data reconciliation, operator actions, and cleanup.

An unavailable or unsafe failure-injection authority yields `BLOCKED`, not `PASS`.

## 11.12 Security and realm-isolation commands

```bash
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  security run \
  --engines postgresql,sqlserver \
  --scenario-set benchmarks/database/v1/workloads/security-realm-negative.json \
  --evidence "$EVIDENCE_DIR/19-security"

dotnet run --project src/tools/Uam.DbBench.Cli -- \
  observability scan \
  --evidence-root "$EVIDENCE_DIR" \
  --canary-registry "$RUN_DIR/canonical-data-a/canaries/registry.json" \
  --output "$EVIDENCE_DIR/20-canary-scan"
```

Required evidence:

- role and pooled-connection transition matrix;
- server-derived realm context proof;
- RLS predicate/policy result and plan behavior;
- direct-table, procedure, view, bulk, report, maintenance, backup/restore, agent/job, and admin-negative tests;
- cross-realm accepted-action count;
- audit event for every privileged mutation;
- exact canary positive-control result and zero forbidden escapes;
- bounded error taxonomy and metric series.

## 11.13 Operations, skills, and cost commands

```bash
# Time blind runbook exercises and capture finite action codes.
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  operations exercise \
  --engine postgresql \
  --runbook-set benchmarks/database/v1/runbooks/blind-exercises.json \
  --evidence "$EVIDENCE_DIR/21-pg-operations"

dotnet run --project src/tools/Uam.DbBench.Cli -- \
  operations exercise \
  --engine sqlserver \
  --runbook-set benchmarks/database/v1/runbooks/blind-exercises.json \
  --evidence "$EVIDENCE_DIR/21-sql-operations"

# Validate quotes/assumptions and calculate ranges; no blank is treated as zero.
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  cost calculate \
  --postgresql benchmarks/database/v1/manifests/tco-postgresql.json \
  --sqlserver benchmarks/database/v1/manifests/tco-sqlserver.json \
  --workload "$EVIDENCE_DIR/11-matrix/workload-summary.json" \
  --output "$EVIDENCE_DIR/22-tco"
```

Required evidence:

- operator role/skill class and exercise authorization, not personal identity;
- timestamps for detection/classification/containment/recovery/reconciliation/cleanup;
- runbook deviations and unsafe attempts;
- vendor/support escalation result;
- training gaps and recurring labor estimate;
- point-in-time quotes/list-price references, license assumptions, topology counts, cloud calculator exports by digest, support costs, and expiration dates;
- three-year low/base/high ranges and unit-cost metrics;
- sensitivity to growth, discounts, staffing, HA, DR, support, and exit.

## 11.14 Statistical analysis and gate commands

```bash
# Validate raw data before analysis.
dotnet run --project src/tools/Uam.DbBench.Analysis -- \
  validate \
  --evidence "$EVIDENCE_DIR" \
  --plan benchmarks/database/v1/analysis/statistical-plan.json \
  --output "$EVIDENCE_DIR/23-analysis-validation"

# Generate paired summaries, bootstrap intervals, outlier audit, capacity curves,
# cost normalization, and sensitivity surfaces.
dotnet run --project src/tools/Uam.DbBench.Analysis -- \
  analyze \
  --evidence "$EVIDENCE_DIR" \
  --plan benchmarks/database/v1/analysis/statistical-plan.json \
  --output "$EVIDENCE_DIR/24-analysis"

# Strict final gate. It reads evidence; it does not execute database work.
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  gate evaluate \
  --gate benchmarks/database/v1/gates/database-adr-gate.json \
  --evidence "$EVIDENCE_DIR" \
  --owner-decisions benchmarks/database/v1/manifests/human-decisions.json \
  --output "$EVIDENCE_DIR/25-gate/db-adr-gate.json"
```

The final gate MUST produce one of the decision states in section 9.11 and include:

- exact candidates and all configuration/evidence digests;
- every first failure and rerun relation;
- missing/expired/blocked evidence;
- hard-gate counts;
- production-shaped workload approval;
- restore/failover results;
- operations/skills/TCO completeness;
- sensitivity outcome;
- accountable owner approvals;
- `productionApproved=false` unless a separate designated authority acts.

## 11.15 Cleanup command

```bash
dotnet run --project src/tools/Uam.DbBench.Cli -- \
  environment cleanup \
  --run-manifest "$EVIDENCE_DIR/run-manifest.json" \
  --evidence "$EVIDENCE_DIR/26-cleanup"
```

Cleanup MUST be manifest-scoped and verify deletion/revocation of:

- benchmark databases, users/roles, credentials and temporary certificates;
- backup/PITR/failover artifacts and restored targets;
- agents/jobs/extensions created for the run;
- test monitoring dashboards/alerts/exporters;
- generated files and caches outside the immutable evidence root;
- cloud/VM/storage/network resources;
- secret-store leases and runner access.

It MUST NOT broad-delete a shared server, user directory, backup repository, or organization resource. Cleanup failure is a gate failure, not an operations footnote.

## 11.16 Evidence directory contract

```text
/evidence/database/<run-id>/
  run-manifest.json
  00-inputs/
  01-generation/
  02-*-plan/
  03-*-provision/
  04-*-inventory/
  05-*-schema-*/
  06-*-schema-verify/
  07-*-correctness/
  08-*-leases/
  09-*-ingest/
  10-*-materialize/
  11-matrix/
  12-reports/
  13-retention/
  14-soak/
  15-*-backup/
  16-*-restore/
  17-restore-reconciliation/
  18-*-ha/
  19-security/
  20-canary-scan/
  21-*-operations/
  22-tco/
  23-analysis-validation/
  24-analysis/
  25-gate/db-adr-gate.json
  26-cleanup/
  hashes.sha256
```

Every directory contains a strict `evidence.json` with tool/source/environment/input identities, start/end UTC, result, first failure, retry relation, artifact digests, redaction/canary status, owner/reviewer functions, expiry, and cleanup dependency. Raw metrics are append-only. Analysis products never replace raw evidence.

# 12. ADR proposals: decision, status, alternatives, rationale, evidence, owner, and review trigger

## 12.1 ADR register

| ADR | Proposed decision | Status | Alternatives considered | Rationale | Evidence required before acceptance | Accountable owner function | Review trigger |
|---|---|---|---|---|---|---|---|
| ADR-B04-016-001 | Keep the production database engine decision open; PostgreSQL is the reference implementation and SQL Server is a full paired candidate | **Proposed — measurement gate open** | select PostgreSQL now; retain SQL Server now; abstract indefinitely; use managed service only | preserves accepted baseline and prevents brand/legacy preference from replacing production-shaped evidence | strict `db-adr-gate.json`, production-shaped load, restore/failover, skills/TCO, owner approval | Architecture Forum with Data Reliability/Product | gate evidence, strategic mandate, material new primary evidence |
| ADR-B04-016-002 | Use one normative logical schema/workload and two thin engine adapters | **Proposed — accept for harness** | independent optimized schemas; ORM-generated schema; generic benchmark schema | isolates engine differences while retaining semantic fairness and reviewability | contract/schema mutation tests and canonical result equivalence | Data Architecture | required semantic cannot be represented portably or adapter causes material unfixable distortion |
| ADR-B04-016-003 | Separate unpartitioned global `event_identity` from partitioned `activity_fact` | **Proposed — prototype** | partitioned unique key containing date; no partitioning; hash/list realm partitioning; engine-specific global indexes | preserves one natural event identity independently of an unsettled partition key/grain and works around both engines' partitioned uniqueness constraints | concurrency, duplicate, late-arrival, restore, retention, storage, and performance experiments | Data Architecture/Data Reliability | identity-ledger contention or cost fails; approved retention/partition semantics enable a simpler proved model |
| ADR-B04-016-004 | Durable inbox and matching custody receipt are inserted in one transaction; receipt means only the declared tested durable domain | **Proposed — logical invariant accepted, server proof open** | receipt after materialization; HTTP-success receipt; broker receipt; asynchronous receipt record | directly preserves accepted receipt semantics and endpoint cleanup safety | crash, failover, replay, backup/restore, receipt-conflict and false-receipt zero gate | Ingestion/Data Reliability | failure domain, topology, or receipt contract changes |
| ADR-B04-016-005 | Use a narrow mutable `ingest_work` row and fenced leases; immutable inbox/payload is not the lease queue | **Proposed — experiment** | update inbox row; external broker; in-memory queue; engine agent jobs | limits write amplification and contention while retaining durable custody and replay | stale-owner, fairness, starvation, lock escalation, failover and poison campaigns | Server Runtime | lease gate failure, broker trigger, or worker topology change |
| ADR-B04-016-006 | Bulk into same-session temporary staging, then validate/merge in one bounded transaction | **Proposed — experiment** | row inserts; permanent unlogged/staging table; stored procedure with table parameter; broker | uses each official .NET provider's bulk path without weakening final semantics or leaving a second durable queue | provider/cancellation/fault, log amplification, transaction, plan and cleanup tests | Ingestion/Performance | provider/API change or temp staging becomes limiting/unsafe |
| ADR-B04-016-007 | Realm authority is server-derived; realm-first keys plus database RLS are defense in depth | **Proposed — security invariant** | application filtering only; database/schema per realm only; dedicated cluster per realm | preserves authenticated context and limits one missed application predicate; allows later topology specialization | pooled-session reset, direct SQL, backup/report/admin negative corpus and zero cross-realm results | Security/IAM/Data Architecture | RLS performance/operability failure, dedicated-realm mandate, or engine policy limitation |
| ADR-B04-016-008 | Compare partition variants P0, P1 receipt-time, and P2 event-time; do not select grain/key before retention and measurement | **Proposed — measurement gate** | monthly only; daily only; no partition; partition by realm/hash | retention, late arrival, uniqueness, report pruning, index and operational cost trade off differently | production-shaped retention/late-arrival workload, active-load DDL, restore and TCO evidence | Data Architecture/Records/SRE | approved retention/late-arrival policy or materially different volume distribution |
| ADR-B04-016-009 | Treat report coexistence as part of the database gate; start with governed aggregates on primary | **Proposed — default** | direct facts on primary; read replica; analytical store; external warehouse | simplest path until measured interference/freshness/fan-out justify another failure domain | Q01–Q10 correctness/interference/freshness, replica cost/lag/failover if candidate | Product/Data/SRE | approved report priority/freshness or measured interference trigger |
| ADR-B04-016-010 | No external broker by default; add one only on accepted measured triggers | **Proposed — carry accepted baseline** | Kafka/service bus/queue first; database queue indefinitely | avoids an unproved failure domain and preserves simple durable receipt boundary | relational queue/throughput/replay/fan-out evidence plus broker comparative ADR when trigger fires | Architecture/Ingestion/SRE | sustained relational failure-domain, throughput, replay, fan-out, isolation, or cost trigger |
| ADR-B04-016-011 | Use randomized paired blocked runs, deterministic inputs, raw evidence, BCa bootstrap intervals, and sensitivity analysis | **Proposed — accept for experiment** | single best run; vendor benchmark; unpaired averages; one weight set | reduces order/noise bias and exposes uncertainty without pretending synthetic precision | statistical-plan review, positive controls, clean rerun and raw-data validation | Performance/Verification | design review finds violated assumptions or evidence shows insufficient repetitions |
| ADR-B04-016-012 | Restore and failover are hard gates; command success/promotion alone is not recovery | **Proposed — accept** | rely on documentation/service SLA; backup-only test; failover-only smoke | custody safety depends on recovered validated state, fencing, and readiness | repeated PITR/backup restore, planned/unplanned failover, partition/fencing, full reconciliation | SRE/Data Reliability | RPO/RTO, topology, service provider, storage or receipt-domain change |
| ADR-B04-016-013 | Operations, available skills, support, licensing, and three-year TCO are mandatory decision evidence | **Proposed — human/measurement gate** | decide on benchmark speed; assume existing skill; ignore support/exit | UAM must be operable and affordable, and SQL Server edition/licensing can alter architecture | blind exercises, owner coverage, quotes/license review, complete cost ranges and sensitivity | Operations/Product/Finance/Procurement | staffing, contract, price, topology, growth or support model changes |
| ADR-B04-016-014 | Managed database services are separate candidate profiles, not inherited engine results | **Proposed — accept principle** | treat managed PostgreSQL/SQL Server as equivalent; compare only brands | service tiers constrain HA, backup, extensions, access, maintenance, metrics, pricing and exit | service-specific inventory, workload, failover, restore, security, operations and cost gates | Cloud Platform/Architecture | approved provider/tier list or service capability change |
| ADR-B04-016-015 | Exact engine, driver, tool and repository revisions are evidence inputs; OSS references are not automatic dependencies | **Proposed — accept** | floating latest; copy reference implementation; popularity-based selection | protects reproducibility, licensing, supply chain, and removal ability | dependency admission record, package/source/binary mapping, tests/security/license/fit | Dependency Security/Legal/Architecture | every version/update/new dependency |
| ADR-B04-016-016 | Select a complete engine profile, not a product name | **Proposed — accept** | “PostgreSQL” or “SQL Server” generic ADR | edition, patch, OS/service, topology, storage, HA, driver, support and configuration materially affect fitness | exact profile manifest and unexpired evidence | Architecture/SRE | any material profile dimension changes |
| ADR-B04-016-017 | Use hard-zero invariants before weighted scoring; publish `ROBUST`, `CONDITIONAL`, `NO ROBUST WINNER`, or `INCOMPLETE` explicitly | **Proposed — accept** | total weighted score only; architecture vote; cheapest/fastest wins | prevents trade-off scoring from normalizing security/durability failures and exposes decision dependence | gate implementation mutation tests and approved weights/ranges | Architecture Forum/Risk | scoring policy or human priorities change |
| ADR-B04-016-018 | Database evidence expires on engine/CU/minor, driver, schema/index, configuration, topology, hardware/service tier, workload, RPO/RTO, or incident change | **Proposed — accept** | permanent benchmark; vendor major-version inheritance | fitness is composition-specific and fast-moving | signed/content-addressed evidence manifest and recurring qualification policy | Release/Compatibility/SRE | every named change or primary incident |

## 12.2 No accepted-baseline change proposal

**FACT.** This result does not conflict with the accepted predecessor decision that PostgreSQL is the reference, SQL Server is the serious fallback, and production selection is measurement-gated. It also preserves the initial modular monolith, relational durable inbox, no-default-broker, server-derived realm, receipt, idempotency, privacy, release, and restore invariants.

A future finding MUST open an explicit baseline change proposal if it claims UAM needs:

- endpoint-to-database credentials or direct SQL;
- a receipt outside the tested durable failure domain;
- a broker as the initial mandatory custody boundary;
- multiple final business effects for one stable event identity;
- payload-derived realm authority or application-only realm filtering;
- a schema that cannot preserve the accepted receipt/materialization/visibility states;
- database cleanup that can lose acknowledged data or expose deleted data before readiness;
- a production engine selected without identical evidence, restore/failover, skills/TCO, and owner approval.

The change proposal must identify the affected accepted decision, new primary evidence, invariant impact, alternatives, smallest falsifying experiment, migration/rollback consequence, and ADR action.

## 12.3 Database ADR decision template with thresholds — mandatory artifact

```markdown
# ADR-DB-001 — Production relational engine for UAM server

Status: Proposed | Accepted | Rejected | Superseded | Deferred
Decision date:
Evidence cutoff:
Evidence expiry:
Accountable architecture owner:
Accountable database operations owner:
Product/Risk approver:
Finance/Procurement approver:
Security/Privacy reviewer:

## Candidate profiles

### PostgreSQL
- exact engine release/build/distribution:
- OS or managed service/tier:
- driver and commit/package:
- topology, storage, HA, backup, support:
- schema/partition variant and configuration digest:
- evidence root:

### SQL Server
- exact engine release/CU/edition:
- OS or managed service/tier:
- driver and commit/package:
- topology, storage, HA, backup, license/support:
- schema/partition variant and configuration digest:
- evidence root:

## Human-approved requirements

- HD_REQUIRED_PEAK_DURABLE_RECEIPT_RATE:
- HD_REQUIRED_BURST_PROFILE:
- HD_REQUIRED_CAPACITY_HEADROOM:
- HD_INGEST_P95_LIMIT:
- HD_INGEST_P99_LIMIT:
- HD_REPORT_QUERY_LIMITS:
- HD_REPORT_FRESHNESS:
- HD_BACKLOG_CLEAR_DEADLINE:
- HD_RPO:
- HD_RTO:
- HD_FAILOVER_DETECTION_LIMIT:
- HD_RETENTION_POLICY:
- HD_LATE_ARRIVAL_POLICY:
- HD_STORAGE_AND_IO_BUDGET:
- HD_THREE_YEAR_BUDGET_RANGE:
- HD_ON_CALL_AND_SUPPORT_REQUIREMENT:
- HD_SCORING_WEIGHT_RANGES:
- HD_MATERIAL_SCORE_DIFFERENCE:

A blank required field makes the decision EVIDENCE_INCOMPLETE. It is never treated as zero or unlimited.

## Hard gates

- false_durable_receipts == 0
- duplicate_final_business_effects == 0
- missing_final_business_effects == 0
- cross_realm_accepted_actions == 0
- acknowledged_batches_lost == 0 within the declared tested domain
- canonical_result_mismatches == 0
- stale_worker_state_changes == 0
- accepted_split_brain_writes == 0
- restore_reconciliation_errors == 0
- wrong_partition_or_retention_deletes == 0
- forbidden_value_or_derivative_escapes == 0
- unexplained_configuration_drift == 0
- unexplained_reproducibility_failures == 0
- cleanup_failures == 0
- blocking_owner_gaps == 0
- mandatory_evidence_missing_or_expired == 0

No weighting can waive a hard-gate failure.

## Performance and capacity

- production-shaped workload approval:
- sustainable capacity and confidence interval:
- capacity headroom ratio:
- ingest/materialization latency intervals:
- reconnect/outage recovery:
- log/storage/index amplification:
- report interference and freshness:
- maintenance/soak result:

## Restore and failover

- backup classes and actual restores:
- PITR repetitions:
- measured RPO/RTO including validation:
- planned/unplanned failover repetitions:
- fencing/split-brain result:
- rejoin/cleanup result:

## Security, realm, and audit

- server-derived realm proof:
- RLS/direct SQL/pooling/admin/report/backup negative matrix:
- privileged mutation audit:
- observability/canary/cardinality result:

## Operations, skills, support, and TCO

- blind exercise results:
- named coverage and escalation:
- support contract/quote:
- license legal review:
- three-year low/base/high TCO:
- unit costs:
- training/hiring/migration/exit:

## Statistical analysis

- preregistered plan digest:
- paired repetitions and exclusions:
- confidence intervals and practical margins:
- capacity curves and knee:
- sensitivity result:
- decision state: NO_PROFILE_PASSES | ONE_PROFILE_PASSES | ROBUST_WINNER | CONDITIONAL_WINNER | NO_ROBUST_WINNER | EVIDENCE_INCOMPLETE

## Decision

Selected exact profile, or explicit deferral:
Conditions and assumptions that make it win:
Alternatives rejected and why:

## Residual risk

## Migration, rollback, and exit

## Evidence and approvals

## Review triggers

- engine/CU/minor/distribution/edition/driver change
- schema/index/partition/query/materialization change
- OS/service tier/storage/topology/HA/backup/support/license change
- workload/retention/reporting/RPO/RTO/budget/skills change
- primary durability/security/realm/restore/performance incident
- evidence expiry
```

## 12.4 ADR acceptance rule

The database ADR may be marked `Accepted` only when:

1. every hard gate passes for the exact selected profile;
2. production-shaped workload inputs are approved;
3. actual restore/PITR and failover/fencing evidence meets approved RPO/RTO;
4. operations/skills/support and licensing/TCO records are complete;
5. sensitivity identifies a robust or explicitly accepted conditional winner;
6. all blocking owner functions sign the decision;
7. migration, rollback, exit, evidence expiry, and recurring qualification are recorded;
8. a separate production authority acts. A research result or technical gate alone is not production approval.

# 13. Ordered implementation backlog with dependencies and stop gates

## 13.1 Critical path

| Order | Backlog item | Dependencies | Deliverable | Stop/go gate |
|---:|---|---|---|---|
| 1 | record the seven-file project evidence manifest and public-source snapshot | none | immutable input hash/source register | stop on missing/extra Project file or hash mismatch |
| 2 | create ADR-B04-016-001 through 018 and owner decision records | 1 | ADR and human-decision files with `UNASSIGNED` where necessary | pure work may continue; no decision run with blocking owner absent |
| 3 | define strict benchmark/evidence/gate contracts | Batch 01 contract rules, 1–2 | JSON schemas, invalid vectors, evidence lifecycle | stop on unknown authority-bearing field, permissive default, or remote schema dependency |
| 4 | scaffold custom .NET harness projects and architecture guards | 3 | buildable CLI/contracts/generator/oracle/analysis/adapters | stop if oracle can reference adapter/production logic or adapters change semantics |
| 5 | implement deterministic T1 generator, workload composer, canaries, and independent oracle | 3–4 | byte-stable data roots and expected ledgers | stop on real value, nondeterminism, oracle common code, or mandatory mutation survivor |
| 6 | freeze logical schema, operation contracts, query corpus Q01–Q10, state machines, and error taxonomy | 3–5 | comparable schema/workload v1 | stop on unresolved semantic difference or payload-derived realm authority |
| 7 | implement PostgreSQL and SQL Server DDL/migration generators from the same logical model | 6 | P0 DDL, normalized catalog verifier, rollback | stop on engine-only semantic default/trigger or missing constraint |
| 8 | implement Npgsql and SqlClient dependency admission/protocol tests | 4–7 | exact package/source/binary records and thin adapters | stop on provenance/license/security/transitive gap or hidden provider behavior |
| 9 | implement receipt transaction and identity-ledger model in both adapters | 6–8 | low-load correctness prototype | stop on false receipt, identity overwrite, missing/duplicate effect |
| 10 | implement fenced work leasing and poison states in both adapters | 6–9 | lease operation API and model checker | stop on stale-owner commit, invisible eligible work, or endless poison spin |
| 11 | implement same-session temp staging with binary COPY/`SqlBulkCopy` | 8–10 | bounded bulk adapters and cancellation tests | stop on persistent second queue, semantic bypass, or residue |
| 12 | implement server-derived realm context, realm-first keys, RLS, roles, audit, and pooled reset | 6–11 | security model and negative corpus | stop on any cross-realm accepted action or unaudited privileged mutation |
| 13 | implement run manifest, environment inventory, configuration drift, and redaction/canary scan | 3–12 | strict evidence envelope and preflight | stop on unknown material config, secret/raw value, or scanner miss |
| 14 | select one fair self-managed lab hardware/service class and provision both candidates | HD deployment authority, 13 | paired environments and before-state manifest | stop if CPU/memory/storage/network/security cannot be made comparable or normalized transparently |
| 15 | pin exact current engine releases, SQL Server edition/CU, PostgreSQL distribution, drivers, OS/images, settings | 14 | candidate profile manifests | stop on unsupported/unlicensed/unmapped component |
| 16 | run schema/constraint/RLS/receipt/dedupe/lease correctness at low load | 9–15 | DBX correctness evidence | any hard invariant failure blocks performance work |
| 17 | repair/freeze schema contract v1 after correctness review | 16 | accepted experiment schema digest | no post-freeze semantic tuning without restarting affected paired runs |
| 18 | calibrate load generator and monitoring overhead off-system/on-system | 13–17 | generator headroom and observer-effect evidence | stop if generator or telemetry saturates first or materially differs by engine |
| 19 | run paired bulk-ingest and materialization micro/macro workloads | 17–18 | throughput/latency/log/resource raw evidence | stop on correctness drift or configuration mismatch |
| 20 | run reconnect burst, duplicate/replay, poison, late-arrival, skew, noisy-realm, and backlog-clear workloads | 19 | production-shape stress evidence | stop on one-effect/realm/fencing failure |
| 21 | implement and test P1 receipt-time partition variant | 17–20, provisional retention profile | DDL, migration, query/retention evidence | stop on identity/receipt/restore/retention mismatch |
| 22 | implement and test P2 event-time partition variant | 17–21, late-arrival scenarios | DDL, routing/correction/retention evidence | stop on late-arrival loss, wrong delete, or unbounded operational complexity |
| 23 | compare P0/P1/P2 and freeze one candidate variant per engine for HA/restore | 20–22 | partition decision evidence, not production ADR | keep P0 when no partition variant has measured overall benefit |
| 24 | run Q01–Q10 report coexistence on primary and governed aggregates | 19–23 | correctness/interference/freshness evidence | stop on query mismatch, realm leak, or approved ingest floor failure |
| 25 | test readable secondary/report-offload only if it remains a real candidate | 24, HD report/HA/license | separate topology/cost evidence | no inference from primary result; stop on lag/licensing/failover mismatch |
| 26 | run active-load index/statistics/vacuum/ghost/partition/log/checkpoint maintenance | 23–25 | maintenance duty, blocking, recovery evidence | stop on unbounded growth or unavailable recovery |
| 27 | run 24-hour soak for each surviving profile | 20–26 | soak/bloat/leak/log/queue evidence | stop on unexplained monotonic degradation or invariant failure |
| 28 | implement exact backup/PITR profiles and restore into isolated targets | 23–27, provisional RPO/RTO inputs | verified backup and reconciliation harness | backup success alone is not pass; stop on any restore mismatch |
| 29 | run repeated point-in-time and corrupted/missing-chain restore scenarios | 28 | restore distributions and incident runbook | stop on acknowledged loss, hidden dependency, or readiness before validation |
| 30 | provision exact HA topologies and fencing controller | HD topology/license/lab authority, 27–29 | PostgreSQL and SQL Server HA candidate manifests | stop if topology cannot be made safe/approved; do not fake with process-only restart |
| 31 | run planned/unplanned failover, network partition, lag, response-loss, rejoin, and cleanup | 30 | RPO/RTO/fencing/receipt evidence | one accepted split-brain write or receipt error disqualifies topology |
| 32 | execute realm/security/observability/all-sink campaign across backup, restore, reports, maintenance, HA | 12–31 | zero cross-realm/canary evidence | any privacy/security failure stops all dependent decision work |
| 33 | execute blind operator exercises for both profiles | 26–32, owner assignments | time-on-task, runbook, skills/support gaps | unresolved mandatory incident or unsafe workaround blocks ADR |
| 34 | obtain PostgreSQL support and SQL Server license/support quotes; complete low/base/high TCO | 15, 20–33, HD budget/procurement | complete TCO and unit costs | blank material input makes gate incomplete |
| 35 | optionally run exact managed-service profiles | approved provider/tier, 16–34 | service-specific evidence | never merge with self-managed engine result |
| 36 | validate raw evidence and run preregistered statistical analysis | 16–35 | paired intervals, capacity curves, sensitivity | stop on data corruption, post-hoc exclusion, insufficient repetitions, or unreproducible result |
| 37 | rerun from a second clean environment/runner | 36 | reproducibility evidence | unexplained conclusion reversal or config drift blocks ADR |
| 38 | exercise cleanup for every environment and artifact | every lab step | complete before/after cleanup receipt | one cleanup failure blocks aggregate gate |
| 39 | evaluate strict `db-adr-gate.json` | 1–38 plus required human inputs | decision state and exact evidence index | no partial pass; `INCOMPLETE` remains open |
| 40 | architecture/operations/security/product/finance review | 39 | accepted, conditional, deferred, or rejected ADR | no selection without explicit owners and accepted assumptions |
| 41 | implement selected adapter/profile behind existing modular-monolith boundary | accepted ADR | repository tasks, migration/rollback plan, recurring qualification | stop if implementation differs from evidenced profile |
| 42 | run a production-shaped T1 engineering canary of the selected profile | 41 plus canary authority | canary evidence, rollback, support, cleanup | first hard-gate failure returns ADR to review |
| 43 | later pilot/production approval | all applicable suite gates and human decisions | separate authority record | research/ADR/canary never implies production approval |

## 13.2 Parallel work permitted

After steps 3–6, these may run in parallel:

- generator/oracle/canary implementation;
- two engine DDL/adapters;
- provider dependency admission;
- pure receipt/lease/RLS models;
- query-corpus and statistics-plan review;
- disconnected environment/runbook/TCO templates;
- OSS/reference review.

After low-load correctness passes, paired ingest, lease contention, reports, partition prototypes, and backup tooling may run in parallel on isolated resettable environments. They MUST converge on the same frozen schema/workload revision before results enter one decision set.

## 13.3 Work that may not be pulled forward

- performance scoring before correctness, realm, receipt, lease fencing, and evidence gates;
- production-shaped claim before human-approved distributions and service objectives;
- partition selection before retention/late-arrival evidence;
- endpoint payload cleanup before the real receipt/restore failure domain is approved;
- a readable secondary before license/cost/freshness/failover implications are included;
- HA pass from containers/process restart alone;
- restore pass from backup creation alone;
- managed-service inheritance from engine results;
- broker adoption from generic best practice;
- engine ADR before skills/TCO/owners and sensitivity;
- production deployment from a technical research pass.

## 13.4 Stop/go gates

1. **GO** for pure contracts, T1 data, oracle, schema generators, adapters, and disconnected runbooks.
2. **STOP performance** on any low-load semantic, receipt, idempotency, lease, RLS, audit, canary, or configuration failure.
3. **GO performance** only with paired immutable environment/schema/workload manifests and verified load-generator headroom.
4. **STOP a profile** on one hard invariant failure; remediation creates a new evidence revision and reruns dependent tests.
5. **GO partition/maintenance/report tests** only after base ingest/materialization correctness and sustainable operating point exist.
6. **STOP HA/restore claim** until real topology/backup operations and full reconciliation pass repeatedly.
7. **STOP database selection** while production-shaped inputs, RPO/RTO, skills/support, license/TCO, owners, or sensitivity are incomplete.
8. **GO to ADR review** only when `db-adr-gate.json` is a strict pass or explicitly reports a transparent conditional/no-winner state with complete evidence.
9. **STOP before production** until separate production/risk authority and all later applicable capacity, outage, deletion, restore, support, and governance gates pass.

# 14. Open-source repository assessment table

## 14.1 Adoption rule

No repository below is adopted merely because it is maintained, popular, multi-engine, or used by others. Admission requires an immutable full revision, package/binary-to-source mapping, license and notices, maintenance and security review, tests, exact execution boundary, UAM-specific positive/negative controls, SBOM/provenance, owner, and removal path. Reference code never defines UAM custody, realm, idempotency, retention, restore, or decision semantics.

## 14.2 Assessment

| Ref | Repository, URL, and relevant files/directories | Exact revision reviewed | License and compatibility | Maintenance, testing, and security posture | Similarity and threat-model difference | Reusable ideas / ideas not to copy | Classification |
|---|---|---|---|---|---|---|---|
| R01 | [CMU BenchBase](https://github.com/cmu-db/benchbase): `src/`, `config/`, benchmark worker/rate-control and histogram output | public `main` reviewed 31 Jul 2026; repository has no GitHub release and the public page did not expose an immutable full SHA in this review | Apache-2.0 repository license; Java/JDBC/Maven stack would add a second client/runtime | active public repository with CI/contribution structure and many workload implementations; public issues include benchmark-correctness defects, reinforcing need for independent truth; no reviewed dedicated security policy | multi-DB load generation and workload-mixture control are relevant; generic OLTP models do not express UAM receipt, replay, realm, late arrival, poison, retention, or restore | reuse rate/mix/histogram and cross-engine test ideas; do not use its schema/results as UAM oracle or compare its PostgreSQL support with absent SQL Server profile; do not execute until full SHA/dependencies are pinned | **REFERENCE ONLY / NO-GO FOR GATE EXECUTION until immutable pin** |
| R02 | [HammerDB](https://github.com/TPC-Council/HammerDB): `src/`, `scripts/`, `config/`, TPROC-C/TPROC-H drivers for PostgreSQL and SQL Server | v6.0, commit `d33f879aec858063edd17aa2daa46db03abb2bae`, released 26 Jun 2026 | GPL-3.0; executable/test use needs license review; Tcl/C++/packaging surface is separate from .NET harness | active multi-engine benchmark with docs, scripts and release activity; repository page did not show a dedicated security policy; benchmark conformance and configuration remain user responsibilities | useful same-tool hardware/engine sanity cross-check; TPC-derived workload and metrics do not model UAM semantics, privacy, receipt, or operator gates | reuse paired environment sanity, driver-rate, and result-cross-check ideas; never call results TPC-certified or use as primary decision; no architecture/schema copying | **SEALED T1 REFERENCE/CROSS-CHECK after license and binary pin; not primary harness** |
| R03 | [Npgsql](https://github.com/npgsql/npgsql): `src/Npgsql`, binary import/export APIs, pooling, multiplexing/failover, `test/` | v10.0.3, commit `d3768398c17877b3a916c3c4d87e8e11698991fc`, released 27 May 2026 | PostgreSQL License; compatible in principle, but NuGet/transitives and notices require exact admission | active mature .NET provider, extensive source tests/CI and public security process; broad protocol/type surface and pooling behavior still require UAM tests | exact client candidate for PostgreSQL; provider controls transport and bulk path but not server receipt/realm/business truth | reuse `NpgsqlDataSource`, binary COPY and cancellation/pooling APIs behind thin adapter; do not expose provider types in domain contracts, enable dynamic mappings/extensions casually, or treat multi-host failover as HA proof | **RUNTIME CANDIDATE after dependency and protocol admission** |
| R04 | [Microsoft.Data.SqlClient](https://github.com/dotnet/SqlClient): `src/Microsoft.Data.SqlClient`, `SqlBulkCopy`, connection resiliency, `src/Microsoft.Data.SqlClient/tests` | v7.0.2, commit `8c70cec98444338ddb0b97be94c34fde93970241`, released 25 Jun 2026 | MIT; native SNI/authentication/transitive components and platform notices require complete binary mapping | actively maintained Microsoft provider with broad tests and security handling; authentication, pooling, encryption and native/managed network paths create a large profile | exact SQL Server client candidate; provider can affect bulk, retry, pooling/session context and failure classification but cannot define custody | reuse `SqlBulkCopy`, strict mappings, pooling reset and cancellation tests; do not enable provider retries that duplicate non-idempotent work or let driver failover infer receipt | **RUNTIME CANDIDATE after full package/native admission** |
| R05 | [pgBackRest](https://github.com/pgbackrest/pgbackrest): `src/`, `test/`, backup/restore/archive commands and docs | v2.59.0, commit `f84c8357d49ea9452cd606531e9c4c322c41bc2e` | MIT; extra daemon/tool/config/repository authority and storage credentials require review | active PostgreSQL backup project with extensive unit/integration tests, release documentation and security-conscious repository features; exact binary/build/support remains execution evidence | directly relevant to PostgreSQL backup/WAL archive operations; it does not define UAM RPO, custody, key, restore validation, or managed-service behavior | reuse backup manifest, verification, archive continuity and restore test ideas; do not assume a successful command proves restore/readiness or deploy it automatically when native/service backup suffices | **BACKUP TOOL CANDIDATE OR REFERENCE after need/admission; not mandatory** |
| R06 | [dbatools](https://github.com/dataplat/dbatools): `public/`, `internal/`, backup/restore, AG, migration and validation commands; `tests/` | v2.8.3, commit `e1f250f786c3d585a4e52ab73a9707297368d134` | MIT; large PowerShell module and dependencies run with potentially high database/OS authority | active community project with broad Pester tests/docs and release activity; command breadth, remoting, discovery and credential handling enlarge the lab threat surface | useful SQL Server operations/runbook reference and optional lab automation; not part of the server runtime or decision oracle | reuse command sequencing and validation concepts behind a strict allowlisted lab adapter; do not import generic migration/discovery/remoting or run it with production authority by default | **LAB/OPERATIONS CANDIDATE after command allowlist and admission; reference initially** |
| R07 | [River](https://github.com/riverqueue/river): PostgreSQL queue schema, unique jobs, workers, leadership and tests | v0.40.0, commit `cd033bea27ed7db8cb0dc778c0465b53b3113b32` | MPL-2.0; Go/runtime mismatch and file-level copyleft obligations require Legal review if code is reused | actively maintained with tests, migrations and documented queue semantics; primarily PostgreSQL-specific and application-job oriented | relevant relational queue/lease/idempotency reference; UAM has two engines, custody receipts, immutable inbox, realm isolation and different poison/replay rules | reuse ideas for transaction-bound enqueue, uniqueness, leasing and test cases; do not copy schema/API, introduce Go service, or infer PostgreSQL victory from a PostgreSQL-only design | **REFERENCE ONLY** |
| R08 | [Microsoft SQL Server samples](https://github.com/microsoft/sql-server-samples): bulk-load, availability group, backup/restore, security and partition examples | reviewed repository point recorded only as commit prefix `1ab31bc`; full immutable SHA was not established | MIT repository license with per-sample notices possible; samples are not supported product code | broad Microsoft examples and CI vary by directory; samples can lag, omit hostile validation, or use permissive/demo configuration | useful API/T-SQL syntax examples for SQL Server-specific prototypes; samples do not share UAM threat, privacy, error, or support model | reuse small documented patterns after checking against current Microsoft docs; do not copy credentials, broad permissions, demo defaults, or treat samples as performance/security proof | **REFERENCE ONLY / NO-GO FOR EXECUTION until full SHA and selected-file review** |
| R09 | [Testcontainers for .NET](https://github.com/testcontainers/testcontainers-dotnet): PostgreSQL/SQL Server modules, wait strategies, resource cleanup and tests | v4.13.0, commit `1717807affaae9b967035516ebedcd76dd7eaffb` | MIT; container images have separate licenses; Docker daemon is high authority | actively maintained with tests, security policy and package provenance features | valuable for fast contract/schema/provider tests; container filesystem/network/process behavior is not production HA, storage durability, managed service, Windows cluster, licensing or restore proof | reuse disposable integration setup and cleanup in trusted T1 CI; do not use containers as sole performance, failover, physical durability or SQL Server licensing evidence | **TEST-ONLY CANDIDATE after image digest/license admission** |
| R10 | [Toxiproxy](https://github.com/Shopify/toxiproxy): proxy server/client and latency, timeout, cut, bandwidth toxics; tests | v2.12.0; only commit prefix `3ccd6a7` was available in the reviewed record | MIT; proxy binary and admin API are high-authority test tools | maintained and widely tested for TCP fault injection; full source/binary identity and security posture must be pinned before gate use | useful for socket faults between harness and database/gateway; cannot model server commit point, disk fault, database crash, fencing, or receipt truth | reuse bounded TCP disruption with private admin endpoint; do not expose admin API, run in production, or treat response loss as no custody | **REFERENCE / NO-GO FOR GATE EXECUTION until full commit/binary pin** |
| R11 | [PostgreSQL source](https://github.com/postgres/postgres/tree/REL_18_4): `src/backend`, `src/bin/pg_basebackup`, `src/test`, isolation/regression tests | tag `REL_18_4`; release 18.4 dated 14 May 2026 | PostgreSQL License | authoritative source and extensive project regression/isolation tests; a custom test build is not an ordinary production build and must be paired with black-box tests | useful to understand documented locking, WAL, backup and inject test faults in a sealed lane; SQL Server source is not available equivalently | reuse official tests and test-build injection ideas; do not copy internals into UAM, depend on undocumented behavior, or compare a debug/test build against ordinary SQL Server | **NORMATIVE SOURCE/TEST-BUILD REFERENCE; ordinary binaries remain primary performance evidence** |

## 14.3 Repository conclusions

1. The custom UAM .NET harness remains the primary benchmark because no reviewed generic harness represents the required semantic and threat model.
2. Npgsql and Microsoft.Data.SqlClient are the only likely runtime dependencies from this table; both remain unadmitted until exact package/native/transitive and behavior gates pass.
3. pgBackRest and dbatools may reduce lab/operations effort, but neither is necessary to prove the design and neither substitutes for actual restore reconciliation.
4. BenchBase and HammerDB are useful only as independent sanity cross-checks. A disagreement triggers investigation; agreement does not validate UAM semantics.
5. River is a design/test reference for relational queues, not a reason to choose PostgreSQL or copy a queue framework.
6. Testcontainers is suitable for fast CI contracts, never for production-shaped HA, storage durability, licensing, or managed-service proof.
7. Any mutable branch, short commit prefix, or unresolved package/binary mapping is a no-go for executable gate evidence.

# 15. Source register with stable links, dates, versions/commits, supported claims, and limitations

## 15.1 Supplied project evidence

Only the seven allowlisted Project files were used. No other Project file was opened, searched, summarized, quoted, or used.

| Ref | Allowlisted file | SHA-256 reviewed | Claim supported | Limitation |
|---|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md` | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | accepted endpoint/server boundaries, relational inbox, receipt/idempotency/realm/release/restore invariants, PostgreSQL reference and SQL Server fallback | working baseline, not production approval or runtime proof |
| I02 | `04-data-and-schema-evidence-summary.md` | `1ed93b3d60d37da96c1f67e401deb10c9d57736e4f4dbfa26e16760bd2a19ce6` | legacy schema shape, target data principles, and missing rate/retention/query/RPO/RTO/benchmark evidence | contains no row values, production volume, future capacity, approved retention, or engine result |
| I03 | `05-decisions-contradictions-and-gates.md` | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | accepted decisions, resolved tensions, and proof-gate order, including database/capacity gate after durable inbox | implementation-research authority only; passing one gate proves only its claim |
| I04 | `06-research-evidence-rules.md` | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | evidence labels, source quality, human-decision boundaries, change-proposal discipline | research-quality rule, not evidence that a technical capability works |
| I05 | `batch-01-review-result.md` (local `batch-01-review-result(3).md`) | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | accepted contracts, realm authority, modular monolith, repository/supply-chain, strict evidence and privacy foundations | predecessor architecture with mandatory open CLI/human gates; not server capacity proof |
| I06 | `batch-02-review-result.md` | `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | stable event identity, minimized page/effect semantics, server-derived realm and G5 handoff | endpoint/source review; no production server workload, retention, query, or database benchmark |
| I07 | `batch-03-review-result.md` | `76854c3d6a12b9b717da90d4e368273bd88a672fc64a315afaeacfb3d701a785` | accepted endpoint durability/release/identity/diagnostics/compatibility principles and test architecture | endpoint-focused predecessor; explicitly leaves durable inbox, capacity, deletion, and restore gates open |

## 15.2 PostgreSQL primary sources

| Ref | Primary source | Date/version reviewed | Claim supported | Limitation for UAM |
|---|---|---|---|---|
| W01 | PostgreSQL, [Release 18.4 notes](https://www.postgresql.org/docs/current/release-18-4.html) | PostgreSQL 18.4, released 14 May 2026; reviewed 31 Jul 2026 | current reviewed PostgreSQL maintenance release and security/backup/replication fixes | release existence does not prove selected distribution, extension set, OS, topology, performance, or UAM safety |
| W02 | PostgreSQL, [Versioning Policy](https://www.postgresql.org/support/versioning/) | reviewed 31 Jul 2026 | annual major cadence, minor fixes, five-year major support; PostgreSQL 18 support horizon used as point-in-time lifecycle input | policy does not provide commercial SLA or eliminate recurring qualification |
| W03 | PostgreSQL 18 documentation, [`COPY`](https://www.postgresql.org/docs/current/sql-copy.html) and Npgsql binary import reference through R03 | current PostgreSQL 18 docs, reviewed 31 Jul 2026 | official bulk-load capability and server-side semantics | Npgsql API behavior, temporary staging, cancellation, error handling, WAL cost and UAM transaction semantics require tests |
| W04 | PostgreSQL 18 documentation, [`SELECT` locking clause / `SKIP LOCKED`](https://www.postgresql.org/docs/current/sql-select.html) | current docs, reviewed 31 Jul 2026 | `SKIP LOCKED` can avoid waiting and provides an inconsistent view suitable for queue-like access rather than general correctness queries | does not prove fairness, starvation resistance, lease fencing, plan stability, or UAM throughput |
| W05 | PostgreSQL 18 documentation, [Table Partitioning](https://www.postgresql.org/docs/current/ddl-partitioning.html) | current docs, reviewed 31 Jul 2026 | declarative range/list/hash partitioning, pruning, maintenance and attach/detach concepts | exact grain, index layout, lock duration, late arrivals, backup/restore and retention safety are UAM measurements |
| W06 | PostgreSQL 18 documentation, [Partitioning limitations and unique constraints](https://www.postgresql.org/docs/current/ddl-partitioning.html#DDL-PARTITIONING-DECLARATIVE-LIMITATIONS) | current docs, reviewed 31 Jul 2026 | unique/primary constraints on a partitioned table must include all partition-key columns under the documented rules | supports the identity-ledger rationale but does not prove it is optimal or contention-free |
| W07 | PostgreSQL 18 documentation, [Row Security Policies](https://www.postgresql.org/docs/current/ddl-rowsecurity.html) | current docs, reviewed 31 Jul 2026 | RLS policy capability, default deny when enabled without policy, role/bypass considerations | superusers/owners/BYPASSRLS, pooling, functions, backups and operational tooling require hostile UAM tests |
| W08 | PostgreSQL 18 documentation, [Cumulative Statistics System](https://www.postgresql.org/docs/current/monitoring-stats.html) | current docs, reviewed 31 Jul 2026 | built-in database/activity/table/index/WAL/replication statistics capabilities | statistics timing/reset/overhead and privacy-safe export profile require measurement and configuration |
| W09 | PostgreSQL 18 documentation, [`pg_stat_statements`](https://www.postgresql.org/docs/current/pgstatstatements.html) | current extension docs, reviewed 31 Jul 2026 | normalized statement planning/execution statistics and configuration requirements | extension may expose query text/identifiers and adds shared-memory/overhead; exact privacy and admission are open |
| W10 | PostgreSQL 18 documentation, [Function Security](https://www.postgresql.org/docs/current/perm-functions.html), [`CREATE POLICY`](https://www.postgresql.org/docs/current/sql-createpolicy.html), and [`SET`](https://www.postgresql.org/docs/current/sql-set.html) | current docs, reviewed 31 Jul 2026 | security-definer/search-path risks, policy expressions, and session setting mechanisms relevant to realm context | UAM must avoid unsafe dynamic SQL/search paths and prove pooled-context reset; docs do not prove composition |
| W11 | PostgreSQL 18 documentation, [`pg_basebackup`](https://www.postgresql.org/docs/current/app-pgbasebackup.html), [`pg_verifybackup`](https://www.postgresql.org/docs/current/app-pgverifybackup.html), and [Continuous Archiving/PITR](https://www.postgresql.org/docs/current/continuous-archiving.html) | current docs, reviewed 31 Jul 2026 | physical base backup, verification and WAL/PITR primitives | backup completion is not restore/readiness; topology, archive durability, credentials, encryption, RPO/RTO and operations remain gated |
| W12 | PostgreSQL 18 documentation, [High Availability, Load Balancing, and Replication](https://www.postgresql.org/docs/current/high-availability.html) | current docs, reviewed 31 Jul 2026 | streaming replication, synchronous/asynchronous choices, hot standby and failover building blocks | PostgreSQL core does not select/fence/orchestrate the complete UAM HA topology; operator/service implementation must be tested |
| W28 | PostgreSQL, [License](https://www.postgresql.org/about/licence/) | current PostgreSQL License text, reviewed 31 Jul 2026 | permissive engine/source license | no license fee does not mean zero support, operations, distribution, extension, hosting or compliance cost |
| W37 | PostgreSQL 18 documentation, [`VACUUM`](https://www.postgresql.org/docs/current/sql-vacuum.html), [Routine Vacuuming](https://www.postgresql.org/docs/current/routine-vacuuming.html), and [`REINDEX`](https://www.postgresql.org/docs/current/sql-reindex.html) | current docs, reviewed 31 Jul 2026 | vacuum/analyze/reindex behavior and maintenance options | exact autovacuum tuning, bloat, blocking, I/O, replica and report interaction require production-shaped soak evidence |

## 15.3 SQL Server primary sources

| Ref | Primary source | Date/version reviewed | Claim supported | Limitation for UAM |
|---|---|---|---|---|
| W13 | Microsoft Learn, [Editions and supported features of SQL Server 2025](https://learn.microsoft.com/en-us/sql/sql-server/editions-and-components-of-sql-server-2025?view=sql-server-ver17) | SQL Server 2025 feature matrix, reviewed 31 Jul 2026 | Standard/Enterprise scale, HA, online-operation and feature differences; Standard limit of lesser of four sockets/32 cores and 256 GB buffer pool in reviewed matrix; Basic AG versus full AG distinctions | exact licensing rights, deployment, patch, hardware and UAM workload still require evidence; feature presence is not fitness |
| W14 | Microsoft Learn, [Latest updates and version history for SQL Server](https://learn.microsoft.com/en-us/troubleshoot/sql/releases/download-and-install-latest-updates) | reviewed 31 Jul 2026 | CU/GDR servicing model and need to use supported updates | does not select CU branch or prove patch compatibility/rollback |
| W15 | Microsoft Learn, [SQL Server 2025 build versions](https://learn.microsoft.com/en-us/troubleshoot/sql/releases/sqlserver-2025/build-versions) | CU7 build `17.0.4065.4`, released 16 Jul 2026; page updated 16 Jul 2026 | exact current reviewed SQL Server 2025 CU point | point-in-time only; exact installed binaries/edition/configuration must be inventoried |
| W16 | Microsoft Learn, [Bulk copy operations in SQL Server](https://learn.microsoft.com/en-us/sql/connect/ado-net/sql/bulk-copy-operations-sql-server?view=sql-server-ver17) and [`SqlBulkCopy`](https://learn.microsoft.com/en-us/dotnet/api/microsoft.data.sqlclient.sqlbulkcopy) | SQL Server 2025 / current SqlClient docs, reviewed 31 Jul 2026 | supported ADO.NET bulk-copy capability | mappings, options, constraints/triggers, transaction/cancellation, temp-table behavior and log cost need UAM tests |
| W17 | Microsoft Learn, [Table hints — `READPAST`, `UPDLOCK`, `ROWLOCK`](https://learn.microsoft.com/en-us/sql/t-sql/queries/hints-transact-sql-table?view=sql-server-ver17) | SQL Server 2025 docs, reviewed 31 Jul 2026 | work-queue-oriented `READPAST` behavior, row-versus-page-lock caveats and hint constraints | hints do not guarantee fairness, row locks, no escalation, or correct lease fencing; query plans and isolation settings matter |
| W18 | Microsoft Learn, [Partitioned tables and indexes](https://learn.microsoft.com/en-us/sql/relational-databases/partitions/partitioned-tables-and-indexes?view=sql-server-ver17) and [`CREATE INDEX`](https://learn.microsoft.com/en-us/sql/t-sql/statements/create-index-transact-sql?view=sql-server-ver17) | SQL Server 2025 docs, reviewed 31 Jul 2026 | partition functions/schemes, aligned indexes, switching and unique-index partition-column rules | edition/online operations, locks, late arrivals, restore, retention and UAM query performance remain measurements |
| W19 | Microsoft Learn, [Row-Level Security](https://learn.microsoft.com/en-us/sql/relational-databases/security/row-level-security?view=sql-server-ver17) | SQL Server 2025 docs, reviewed 31 Jul 2026 | security predicates/policies and filter/block predicate capability | ownership, privileged roles, function/schema binding, session context, bulk/admin/report paths require negative tests |
| W20 | Microsoft Learn, [`SESSION_CONTEXT`](https://learn.microsoft.com/en-us/sql/t-sql/functions/session-context-transact-sql?view=sql-server-ver17) | SQL Server 2025 docs, reviewed 31 Jul 2026 | read access to key/value session context and read-only semantics | pooled connections can retain context; memory limits/parallel plan behavior and authoritative binding require UAM handling |
| W21 | Microsoft Learn, [`sp_set_session_context`](https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-set-session-context-transact-sql?view=sql-server-ver17) | SQL Server 2025 docs, reviewed 31 Jul 2026 | setting/clearing session context | application must set from authenticated context, clear on pool reuse, prohibit payload override, and test failure paths |
| W22 | Microsoft Learn, [Always On availability groups overview](https://learn.microsoft.com/en-us/sql/database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server?view=sql-server-ver17) | SQL Server 2025 docs, reviewed 31 Jul 2026 | availability-group replicas, listeners, modes and operational concepts | exact Windows/Linux/clusterless topology, edition, quorum/fencing, license and UAM behavior remain gated |
| W23 | Microsoft Learn, [Availability modes](https://learn.microsoft.com/en-us/sql/database-engine/availability-groups/windows/availability-modes-always-on-availability-groups?view=sql-server-ver17) | SQL Server 2025 docs, reviewed 31 Jul 2026 | synchronous/asynchronous commit and failover mode semantics | mode labels do not prove RPO/RTO, client recovery, receipt truth, or split-brain containment |
| W24 | Microsoft Learn, [Basic availability groups](https://learn.microsoft.com/en-us/sql/database-engine/availability-groups/windows/basic-availability-groups-always-on-availability-groups?view=sql-server-ver17) | SQL Server 2025 docs, reviewed 31 Jul 2026 | Standard edition Basic AG limitations, including two replicas/one database in reviewed feature documentation | may materially constrain UAM topology/reporting; exact edition/license and operations evidence required |
| W25 | Microsoft Learn, [Backup and restore of SQL Server databases](https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/back-up-and-restore-of-sql-server-databases?view=sql-server-ver17) | SQL Server 2025 docs, reviewed 31 Jul 2026 | full/differential/log backup, recovery models and restore concepts | backup strategy, media durability, encryption, chain, PITR, RPO/RTO and full reconciliation remain UAM gates |
| W26 | Microsoft Learn, [`BACKUP` Transact-SQL](https://learn.microsoft.com/en-us/sql/t-sql/statements/backup-transact-sql?view=sql-server-ver17) | SQL Server 2025 docs, reviewed 31 Jul 2026 | exact native backup command capabilities/options | command success does not prove readable/recoverable/complete UAM state; cloud/object behavior and credentials vary |
| W27 | Microsoft Learn, [`RESTORE` statements](https://learn.microsoft.com/en-us/sql/t-sql/statements/restore-statements-transact-sql?view=sql-server-ver17) | SQL Server 2025 docs, reviewed 31 Jul 2026 | native restore/PITR command capabilities | readiness requires schema/invariant/receipt/realm/deletion validation, not database online state alone |
| W29 | Microsoft, [SQL Server licensing](https://www.microsoft.com/en-us/licensing/product-licensing/sql-server) and Product Terms referenced there | reviewed 31 Jul 2026 | existence of per-core/server+CAL and current licensing resources | authoritative rights depend on agreement, Product Terms, virtualization, passive failover, benefits, region and legal review |
| W30 | Microsoft, [SQL Server 2025 pricing PDF](https://cdn-dynmedia-1.microsoft.com/is/content/microsoftcorp/microsoft/bade/documents/products-and-services/en-us/cloud/SQL-Server-2025-Pricing.pdf) | point-in-time one-page pricing sheet reviewed 31 Jul 2026 | published estimated retail examples: Enterprise and Standard per-core, Standard server/CAL, subscription and Azure Arc PAYG | not a quote, entitlement, regional price, discount, minimum-core, passive-replica or total-cost analysis; Procurement/Legal decision required |
| W38 | Microsoft Learn, [`sys.dm_db_index_physical_stats`](https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-objects/sys-dm-db-index-physical-stats-transact-sql?view=sql-server-ver17) and index operational DMVs | SQL Server 2025 docs, reviewed 31 Jul 2026 | physical index fragmentation/page-density observation | scans can have cost/locking implications; metrics do not prescribe universal maintenance thresholds |
| W39 | Microsoft Learn, [Ghost cleanup process guide](https://learn.microsoft.com/en-us/sql/relational-databases/ghost-record-cleanup-process-guide?view=sql-server-ver17) | SQL Server docs, reviewed 31 Jul 2026 | background ghost-record cleanup and related operational behavior | UAM must measure sustained delete/retention effects; disabling or manually forcing cleanup is not a default recommendation |
| W40 | Microsoft Learn, [`ALTER INDEX`](https://learn.microsoft.com/en-us/sql/t-sql/statements/alter-index-transact-sql?view=sql-server-ver17), statistics and Query Store documentation | SQL Server 2025 docs, reviewed 31 Jul 2026 | rebuild/reorganize/resumable/online and maintenance options by edition/profile | exact edition, lock/resource/log/AG/report impact and runbook need active-load evidence |

## 15.4 Managed-service primary sources

Managed services are cited only to show that service-specific backup/HA behavior exists and differs. They are not recommendations and do not transfer results between providers or from self-managed engines.

| Ref | Primary source | Reviewed scope | Claim supported | Limitation |
|---|---|---|---|---|
| W31 | Microsoft Learn, [Backup and restore in Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/backup-restore/concepts-backup-restore) | current service documentation reviewed 31 Jul 2026 | managed backup/retention/PITR concepts for an exact Azure PostgreSQL service profile | service tier/region/version, retention, restore time, access, pricing and UAM reconciliation require an actual service test |
| W32 | Microsoft Learn, [Business continuity in Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/backup-restore/concepts-business-continuity) | current docs reviewed 31 Jul 2026 | service HA/DR choices and recovery concepts | SLA/documented architecture is not measured UAM RPO/RTO/fencing/receipt evidence |
| W33 | Microsoft Learn, [Business continuity for Azure SQL Managed Instance](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/business-continuity-high-availability-disaster-recover-hadr-overview?view=azuresql) | current docs reviewed 31 Jul 2026 | service-provided HA, failover groups/DR and backup concepts | Azure SQL MI is not identical to self-managed SQL Server; feature, cost, maintenance and access differ |
| W34 | AWS, [Multi-AZ deployments for Amazon RDS for SQL Server](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_SQLServerMultiAZ.html) | current docs reviewed 31 Jul 2026 | RDS SQL Server Multi-AZ service behavior and restrictions | exact engine edition/version/tier, failover, backup, licensing, metrics and UAM evidence remain profile-specific |
| W35 | Google Cloud, [High availability for Cloud SQL for PostgreSQL](https://cloud.google.com/sql/docs/postgres/high-availability) | current docs reviewed 31 Jul 2026 | Cloud SQL regional HA design/failover concepts | does not prove UAM client recovery, receipt semantics, RPO/RTO, cost or operational access |
| W36 | Google Cloud, [Point-in-time recovery for Cloud SQL for PostgreSQL](https://cloud.google.com/sql/docs/postgres/backup-recovery/pitr) | current docs reviewed 31 Jul 2026 | managed PITR capability and configuration concepts | actual retention, restore duration, readiness validation, cost and provider incident behavior require experiments |

## 15.5 Open-source repository source register

Detailed fit, license, maintenance, testing, security, reuse and rejection analysis appears in section 14.

| Ref | Stable repository/revision link | Revision/date reviewed | Claim supported | Limitation |
|---|---|---|---|---|
| R01 | [cmu-db/benchbase](https://github.com/cmu-db/benchbase) | mutable `main`, reviewed 31 Jul 2026; no release/full SHA established | multi-DB workload/rate/histogram reference | not executable gate evidence until immutable source/dependencies are pinned; no UAM semantic authority |
| R02 | [TPC-Council/HammerDB at `d33f879…`](https://github.com/TPC-Council/HammerDB/tree/d33f879aec858063edd17aa2daa46db03abb2bae) | v6.0, commit `d33f879aec858063edd17aa2daa46db03abb2bae`, 26 Jun 2026 | multi-engine TPROC sanity cross-check | GPL-3.0/license and binary admission; not UAM workload/oracle |
| R03 | [npgsql/npgsql at `d376839…`](https://github.com/npgsql/npgsql/tree/d3768398c17877b3a916c3c4d87e8e11698991fc) | v10.0.3, commit `d3768398c17877b3a916c3c4d87e8e11698991fc`, 27 May 2026 | PostgreSQL .NET driver/binary bulk candidate | exact NuGet/transitive/runtime behavior and support require admission |
| R04 | [dotnet/SqlClient at `8c70cec…`](https://github.com/dotnet/SqlClient/tree/8c70cec98444338ddb0b97be94c34fde93970241) | v7.0.2, commit `8c70cec98444338ddb0b97be94c34fde93970241`, 25 Jun 2026 | SQL Server .NET driver/`SqlBulkCopy` candidate | native/managed SNI, auth and transitive package mapping require admission |
| R05 | [pgbackrest/pgbackrest at `f84c835…`](https://github.com/pgbackrest/pgbackrest/tree/f84c8357d49ea9452cd606531e9c4c322c41bc2e) | v2.59.0, commit `f84c8357d49ea9452cd606531e9c4c322c41bc2e`, reviewed 31 Jul 2026 | PostgreSQL backup/archive reference/candidate | optional extra control plane; actual restore and support still required |
| R06 | [dataplat/dbatools at `e1f250f…`](https://github.com/dataplat/dbatools/tree/e1f250f786c3d585a4e52ab73a9707297368d134) | v2.8.3, commit `e1f250f786c3d585a4e52ab73a9707297368d134`, reviewed 31 Jul 2026 | SQL Server operations/reference automation | broad PowerShell/high-authority surface; strict command allowlist and admission required |
| R07 | [riverqueue/river at `cd033be…`](https://github.com/riverqueue/river/tree/cd033bea27ed7db8cb0dc778c0465b53b3113b32) | v0.40.0, commit `cd033bea27ed7db8cb0dc778c0465b53b3113b32`, reviewed 31 Jul 2026 | PostgreSQL relational queue design/test reference | Go/PostgreSQL-specific threat and semantics; not a UAM dependency or engine proof |
| R08 | [microsoft/sql-server-samples](https://github.com/microsoft/sql-server-samples) | reviewed record only had prefix `1ab31bc`; full SHA not established | SQL Server API/T-SQL sample reference | no executable use or stable evidence until selected files and full SHA are reviewed |
| R09 | [testcontainers/testcontainers-dotnet at `1717807…`](https://github.com/testcontainers/testcontainers-dotnet/tree/1717807affaae9b967035516ebedcd76dd7eaffb) | v4.13.0, commit `1717807affaae9b967035516ebedcd76dd7eaffb`, reviewed 31 Jul 2026 | disposable .NET integration-test candidate | container/images/daemon authority; not production HA/durability/license proof |
| R10 | [Shopify/toxiproxy](https://github.com/Shopify/toxiproxy) | v2.12.0; reviewed record had prefix `3ccd6a7`, full SHA not established | TCP fault-injection reference | no gate execution until full source/binary pin; cannot model database custody or fencing alone |
| R11 | [postgres/postgres `REL_18_4`](https://github.com/postgres/postgres/tree/REL_18_4) | tag `REL_18_4`, release 14 May 2026 | authoritative PostgreSQL source/test reference | test builds must be paired with ordinary binaries; no symmetric SQL Server source comparison |

## 15.6 Source-quality conclusions

1. Official engine documentation proves documented capability, not UAM-specific correctness, performance, durability, restore, supportability, or cost.
2. Exact versions, editions, service tiers and prices are point-in-time evidence as of 31 July 2026; they MUST be refreshed at experiment execution and ADR review.
3. SQL Server edition is part of the architecture because limits, HA, online operations and license cost differ.
4. PostgreSQL's permissive engine license does not establish zero TCO or adequate support; SQL Server's list pricing does not establish the organization's actual entitlement or quote.
5. Managed-service SLAs and documentation do not replace UAM failover/restore/client-recovery and cost evidence.
6. A repository's popularity, benchmark label, test suite or maintenance activity is insufficient to make it a dependency or oracle.
7. A mutable branch, short commit prefix or missing package-to-source mapping is no-go for executable gate evidence.
8. Public benchmark results produced on unrelated hardware, schema, workload or settings are not evidence for the UAM decision.
9. Search snippets and vendor marketing are discovery aids only and are not cited as decision proof.

# 16. Confidence table for every major conclusion

Confidence describes the strength of the architectural/research conclusion, not production readiness. A High-confidence design rule can still require a CLI gate because documented capability and reasoning do not prove the exact UAM composition.

| Major conclusion | Confidence | Why | Evidence that would change it |
|---|---|---|---|
| No production engine can be selected from current project evidence | **High** | I02 explicitly lacks representative workload, retention, query, RPO/RTO and benchmark evidence; predecessors keep selection gated | a complete accepted `db-adr-gate.json` with production-shaped, restore/failover, skills/TCO and owner evidence |
| PostgreSQL should remain the reference and SQL Server a full paired candidate until the gate | **High** | direct accepted baseline; both document required relational capabilities and neither has UAM fitness proof | an explicit accepted baseline change with primary evidence or a hard-gate failure that cannot be remediated for one candidate |
| The decision must select an exact engine/edition/topology profile, not a brand | **High** | editions, patches, drivers, HA, service tiers, storage, support and settings materially change capability and cost | evidence proving a broad equivalence class through repeated exact-profile testing and accepted manifest rule |
| One normative logical workload/schema with thin adapters is the fairest first comparison | **High** | controls semantic drift while allowing documented engine-native primitives | a required UAM semantic that cannot be represented without materially disadvantaging one engine, demonstrated by a falsifying prototype |
| Immutable inbox plus same-transaction custody receipt is the correct acceptance boundary | **High** | directly carries the accepted receipt invariant and contains retries/failure | a composed prototype showing the invariant cannot be preserved or a smaller boundary with equal durability/restore proof |
| Separate global event identity from partitioned facts is a strong candidate | **Medium-High** | resolves both engines' partitioned uniqueness constraints without changing natural identity | measured identity-ledger contention/storage/operations failure, or approved retention model enabling a simpler equally safe key |
| A narrow mutable work table is safer than leasing immutable inbox rows | **Medium-High** | limits hot updates/index amplification and separates custody from scheduling | workload evidence showing extra join/state cost dominates and an inbox-row design passes all fencing/amplification gates better |
| PostgreSQL `SKIP LOCKED` and SQL Server `READPAST` can implement queue-like claiming | **High for capability; Medium for UAM fitness** | official docs describe queue-oriented behavior; exact locks/plans/fairness differ | stale commit, starvation, page-lock/escalation, plan or throughput evidence that fails the lease gate |
| Same-session temporary staging with Npgsql binary COPY/`SqlBulkCopy` is the best first bulk profile | **Medium-High** | official providers offer efficient bulk paths while final semantics remain in the bounded merge transaction | cancellation/transaction/log/resource evidence showing row/TVP/permanent-stage alternative has lower total risk and equal semantics |
| Database RLS should be defense in depth, not the sole realm authority | **High** | accepted server-derived realm plus realm-first keys and RLS reduces missed-filter risk without trusting payload | operational/performance failure that cannot be contained, or approved dedicated-database topology replacing shared RLS with equal negative proof |
| Partition key and grain remain unknown | **High** | retention, late arrivals, volumes, query corpus and RPO/RTO are not approved; P0/P1/P2 trade off differently | production-shaped retention/late-arrival/query/operations evidence and human policy approval |
| No partition is the conservative prototype baseline | **Medium-High** | smallest schema avoids premature identity/routing/maintenance choices while measuring whether partitioning is needed | base table exceeds measured maintenance/query/retention limits and a partition variant passes overall gates |
| Reports should start on governed aggregates on the primary | **Medium** | simplest topology and accepted modular monolith; no report corpus/priority evidence yet | measured primary interference or freshness/availability needs proving a secondary/analytical profile has lower total cost/risk |
| A readable replica/secondary is not free report capacity | **High** | lag, recovery conflicts/redo, failover, operations and SQL Server license/topology implications are documented | exact profile evidence showing negligible extra cost/complexity and approved freshness/failover behavior |
| Both products can express the required logical schema and transactions | **High for documented capability** | transactions, constraints, bulk, RLS, partitioning, backup and HA are documented | low-load schema/correctness prototype exposes an unworkable semantic or edition limitation |
| Production capacity for 6,000 endpoints is unknown | **High** | endpoint count alone does not define events/bytes/retries/outages/queries/retention; no production-shaped run exists | approved distributions and repeated sustainable-capacity evidence with headroom |
| Generic TPC-like/BenchBase/HammerDB results cannot decide UAM fitness | **High** | they omit UAM custody, replay, realm, poison, reports, late arrivals, retention and restore semantics | a generic harness extension that exactly implements the normative UAM workload and independent oracle without semantic drift |
| Randomized paired blocked runs and bootstrap intervals are appropriate | **High** | address order/environment noise and non-normal performance distributions; raw evidence remains available | statistical review or pilot data showing violated pairing/independence assumptions and a better preregistered method |
| Exact repetition count and duration remain replaceable estimates | **High** | variance and incident frequency are not known until pilot runs | preregistered pilot variance/power/practical-margin analysis and owner-approved evidence budget |
| Restore and failover must be hard gates rather than scored features | **High** | acknowledged-data and readiness invariants cannot be traded for speed/cost | no expected evidence should weaken this; only a baseline change redefining failure domain/RPO with human risk acceptance |
| Documentation or service SLA cannot substitute for actual restore | **High** | backup creation and promotion do not prove complete, realm-correct, deletion-safe ready state | repeated independent audit showing an alternate verified mechanism provides equivalent end-to-end proof |
| PostgreSQL operational burden is currently unknown | **High** | available Linux/PostgreSQL/replication/vacuum/backup/on-call skills and support are not supplied | blind exercises, staffing inventory and support agreement |
| SQL Server operational burden is currently unknown | **High** | available SQL Server/AG/cluster/backup/index/license/on-call skills and support are not supplied | blind exercises, staffing inventory and support agreement |
| PostgreSQL may have lower engine-license cost, but TCO winner is unknown | **High** | permissive license is factual; support, people, HA, cloud, migration and incident costs remain unknown | complete comparable three-year quotes/measurements and sensitivity |
| SQL Server Standard may be sufficient or disqualified depending on requirements | **Low-Medium** | documented limits/features are known but workload, memory, online maintenance, HA/report topology and license decision are not | exact Standard profile passing all gates within cost/skills objectives, or a requirement/evidence exceeding its limits |
| SQL Server Enterprise may improve capability but can materially increase TCO | **High for trade-off; Low for selection** | edition matrix and public list-price difference are point-in-time facts | actual entitlement/discount/topology quote and measured feature benefit |
| Managed PostgreSQL and managed SQL Server profiles require separate experiments | **High** | providers/tier implementations differ in access, versions, HA, backup, metrics, maintenance, cost and exit | an accepted service equivalence contract proven for every relevant dimension |
| No external broker should be added before measured trigger evidence | **High** | accepted baseline; relational inbox/leased-worker design is plausible and simpler | paired evidence showing relational failure-domain, throughput, replay, fan-out, isolation or TCO cannot meet approved requirements and broker does |
| Open-source benchmark/queue/backup repositories are references, not architecture | **High** | licenses, threat models, semantics, dependencies and support differ; several lack immutable reviewed points | full admission plus UAM-specific evidence showing a dependency reduces total risk/cost without weakening invariants |
| Npgsql and Microsoft.Data.SqlClient are plausible runtime candidates | **High for role; Medium for exact versions** | official ecosystem clients and required bulk capabilities; exact versions are actively maintained | package/native/protocol/security/cancellation/pooling failure or a better admitted provider |
| Decision weighting must include sensitivity | **High** | license, staffing, support, HA and report priorities can plausibly reverse the result | a single candidate passes hard gates or one dominates every approved range so sensitivity no longer changes the outcome |
| `NO_ROBUST_WINNER` or `CONDITIONAL_WINNER` is an acceptable result | **High** | transparent dependence is more decision-ready than an arbitrary score; human strategy may legitimately break a tie | complete evidence demonstrating robust dominance |
| The recommended experiment can produce decision-ready evidence | **Medium-High** | contracts, schema, workload, faults, statistics, operations, TCO and gates are specified; no implementation run exists yet | harness common-mode defect, inability to provision fair topology, or evidence cost exceeding approved budget |
| This result is not production approval | **High** | prompt, accepted baseline and human-decision boundaries are explicit | only designated authorities after all applicable technical, legal, budget, support and risk gates |

## 16.1 Residual risk

Even after a technically passing comparison, material residual risk remains:

- synthetic production-shaped data can omit real skew, reconnect storms, report behavior, operational mistakes, storage defects, and rare engine bugs;
- an independent oracle can share a conceptual defect with the implementation;
- hardware, hypervisor, cloud service, filesystem, storage cache, firmware or network can violate assumptions below the database;
- database/driver/OS patches and configuration changes can alter plans, locks, durability, HA, diagnostics or cost after qualification;
- RLS and realm-first keys reduce but do not eliminate risk from privileged administrators, compromised application code, backup access or platform compromise;
- synchronous replication can still have ambiguous failure boundaries and asynchronous DR can lose acknowledged data if receipt semantics overclaim it;
- a passing restore drill cannot prove every future backup remains readable; recurring drills and key/support continuity are required;
- fail-closed behavior protects data but can create outage, backlog and endpoint retention pressure;
- closed privacy-safe observability may make rare production-only failures harder to diagnose;
- licensing, vendor support, staffing and strategic platform decisions can change faster than technical evidence;
- a robust benchmark winner can still be rejected by an accountable strategic/risk authority, and a conditional winner remains dependent on its recorded condition;
- research cannot approve purpose, fields, retention, access, SLO/RPO/RTO, budget, staffing, legal/license interpretation or production risk.

Containment is exact-profile manifests, hard-zero invariants, immutable raw evidence, independent reconciliation, recurring restore/failover/security drills, bounded diagnostics, evidence expiry, owner/runbook gates, rollback/exit plans, sensitivity, and explicit human authority.

## 16.2 Next stop/go gate

**GO** for repository implementation of the T1 benchmark harness, logical schema, two adapters, deterministic data/oracle, low-load correctness, disconnected runbooks, and fair-lab preparation.

**STOP** any engine selection, production schema commitment, production cleanup authority, capacity claim, pilot, or production deployment until the primary gate is strictly satisfied:

> **Database ADR requires production-shaped results, actual restore and failover evidence, a complete skills/support/licensing/TCO assessment, and accountable owner approval.**

The exact gate artifact is `evidence/database/<run-id>/25-gate/db-adr-gate.json`. It must identify a passing exact profile and a robust or explicitly accepted conditional decision. `EVIDENCE_INCOMPLETE`, `NO_PROFILE_PASSES`, `NO_ROBUST_WINNER` without a human strategic decision, any hard-gate failure, missing owner, expired evidence, or cleanup failure means **STOP and keep the database ADR open**.
