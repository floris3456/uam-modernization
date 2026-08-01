# Prompt 17 result — capacity model, 6,000-device simulator, reconnect storms, recovery, and broker break-even

**Result path:** `batches/04-server-platform/17-capacity-fleet-simulator/result-17-capacity-fleet-simulator.md`  
**Research date:** 31 July 2026  
**Decision status:** **RECOMMENDATION — ACCEPT THE SIMULATOR AND MEASUREMENT ARCHITECTURE; KEEP PRODUCTION CAPACITY, DATABASE ENGINE, SLO/RPO/RTO, COST LIMITS, AND BROKER ADOPTION OPEN**  
**Authority boundary:** server-ingestion capacity modelling, synthetic fleet simulation, failure/recovery experiments, safe measurement, relational-inbox worker pressure, and broker break-even evidence; **not** legal purpose, prohibited use, live-data permission, identity level, retention, support commitment, budget, staffing, production engine selection, SLO/RPO/RTO approval, pilot, or production deployment  
**Primary gate:** **Capacity choices require measured tails and recovery tests with agreed headroom; an external broker is added only after a stated quantitative trigger is crossed.**

## Evidence vocabulary

This result uses the required labels:

- **FACT** — directly supported by supplied evidence or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from facts; the chain is stated.
- **ESTIMATE** — a replaceable numerical hypothesis, never a production commitment.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — required evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, business, support, or production authority is required.
- **CLI EXPERIMENT** — code, lab work, measurement, restore, or fault injection must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements define the proposed implementation contract for this topic. They do not turn an **ESTIMATE**, **UNKNOWN**, or **HUMAN DECISION** into approval.

---

# 1. Executive conclusion in easy language, with confidence and residual risk

## 1.1 Decision

**RECOMMENDATION.** Build a UAM-owned, stateful fleet simulator in C#/.NET and make it part of the governed repository. It MUST reuse the production ingestion contracts, serializer, compressor, stable identifiers, authentication client, retry classifier, exact wire bytes, and receipt verifier. It MUST model each endpoint as a durable state machine rather than as a stateless HTTP loop. It MUST be able to run 6,000 and 12,000 logical devices, create deterministic reconnect and backlog shapes, preserve per-device batch identity across ambiguity, and reconcile the server result against an independent truth ledger.

The simulator has two complementary load mechanisms:

1. a **stateful fleet lane** that represents long-lived installations, local backlog, batches, attempts, receipts, policy revisions, offline periods, and rolling versions; and
2. an **open-arrival pressure lane** whose offered arrival rate is scheduled independently of server response time, so a slowing server cannot silently throttle the generator and appear healthy.

A small **Windows fidelity cohort** MUST run the exact supported endpoint transport, TLS, certificate, compression, retry, and receipt code on approved disposable Windows machines. The large 6,000–12,000-device scale lane MAY run on cheaper homogeneous load agents, but only after byte-for-byte and state-transition equivalence with the Windows cohort is proved.

**RECOMMENDATION.** Keep the accepted relational durable inbox and leased-worker modular monolith as the first architecture. Do not add a broker to “handle 6,000 devices.” Endpoint count is not the load unit. Add a broker only after the identical workload proves a stated failure-domain, throughput, replay, fan-out, recovery, or total-cost trigger that cannot be met acceptably by the relational design.

**RECOMMENDATION.** Benchmark PostgreSQL and SQL Server with the same application build, schema semantics, input corpus, worker algorithm, data volumes, faults, query corpus, backup/restore steps, hardware class, and evidence format. PostgreSQL remains the reference target and SQL Server remains the serious transition/fallback candidate; this topic does not select the production engine.

## 1.2 What can be decided now

The following decisions are strong enough to implement now:

| Conclusion | Classification | Decision |
|---|---|---|
| Simulator ownership | **RECOMMENDATION** | UAM owns the state model, scenario format, deterministic seed profile, truth ledger, production-wire adapter, evidence schema, and gate evaluator. |
| Load model | **RECOMMENDATION** | Combine stateful device actors with an independent open-arrival scheduler; record offered, started, completed, delayed, and generator-dropped work separately. |
| Scale targets | **CLI EXPERIMENT** | Execute reproducible 6,000-device, 12,000-device, and 72-hour campaigns. Passing proves only the exact workload and environment. |
| Server architecture | **FACT / RECOMMENDATION** | Preserve modular monolith + relational durable inbox + leased workers. No broker by default. |
| Database comparison | **RECOMMENDATION** | Use one engine-neutral benchmark contract and compare PostgreSQL and SQL Server operationally, not by vendor claims. |
| Recovery | **RECOMMENDATION** | Capacity is unacceptable when it handles the peak but cannot drain an outage backlog while serving new arrivals with agreed headroom. |
| Observability | **RECOMMENDATION** | Collect finite, value-free, metadata-only distributions. Device, person, URL, host, source, application, and realm identifiers MUST NOT become metric labels. |
| Fairness | **RECOMMENDATION** | Prevent a large realm, reconnecting site, or poison batch from starving other realms; measure per-class lag and starvation, not only global percentiles. |
| Broker decision | **RECOMMENDATION** | Use the break-even table in section 9.4. A trigger opens an ADR and prototype; it does not automatically authorize a broker. |

## 1.3 What remains open

**UNKNOWN.** The supplied evidence contains no representative event-rate, byte-size, compression, batch-size, retry, outage, local-backlog, central-backlog, query, retention, restore, or cost distributions. It also contains no production database benchmark, approved SLO, RPO, RTO, maximum outage, permitted measurement cohort, or budget. Therefore this result does not claim that any hardware size, worker count, partition grain, connection-pool size, batch limit, index set, retention period, or database engine is sufficient.

**HUMAN DECISION.** Production SLO/error budgets, maximum outage and recovery objectives, cost/support constraints, and the permitted measurement cohort remain accountable human choices. Section 10 gives options, consequences, conservative temporary lab defaults, and owner questions without claiming approval.

## 1.4 Immediate go / stop

**GO** for:

- a repository project for contracts, deterministic scenarios, simulator actors, production-wire adapters, truth ledger, evidence validation, and CLI tooling;
- T1 fictional devices, realms, certificates, events, batches, policies, poison records, query parameters, and restore data;
- engine-neutral ingestion and worker benchmark adapters for PostgreSQL and SQL Server;
- sealed lab deployment, network-fault tooling, database failpoints, restore drills, 6k/12k runs, and a 72-hour soak;
- metadata-only distribution collection from an approved legacy/pilot cohort after the human gate;
- a broker spike only after a trigger in section 9.4 is crossed and an ADR authorizes the experiment.

**STOP** before:

- claiming “6,000 devices supported” from a smoke test, average rate, or endpoint count alone;
- using production activity, internal URLs, addresses, user identities, credentials, SSH material, confidential configuration, or raw reference data;
- issuing a durable receipt before the declared relational failure-domain transaction commits;
- deleting endpoint payload because an HTTP response was successful rather than because a matching durable-custody receipt was verified;
- choosing PostgreSQL or SQL Server solely from feature lists, familiarity, popularity, or one synthetic throughput number;
- adding Kafka, RabbitMQ, Azure Service Bus, or another broker “for scale” without the break-even evidence and changed custody/replay threat model;
- setting production retention, SLOs, recovery objectives, quotas, costs, or support obligations in code defaults;
- allowing the fault controller, test identity authority, test certificates, or destructive tools into a production artifact or network.

## 1.5 Confidence and residual risk

| Major conclusion | Confidence | Reason | Evidence that could change it |
|---|---|---|---|
| A custom stateful simulator is required | **High** | Accepted contracts require persistent device/batch/receipt identity and offline behavior that a stateless request loop cannot represent. | A reviewed tool proves production-contract reuse, deterministic durable device state, exact receipt semantics, and equivalent evidence with less custom code. |
| Open-arrival pressure is required | **High** | Closed loops reduce offered rate when the server slows, hiding overload. | A different scheduler proves offered-arrival independence and generator-drop accounting. |
| Relational inbox first, no broker default | **High** | It is accepted baseline and 6,000 endpoints alone gives no throughput/failure-domain evidence. | Measured trigger in section 9.4 plus a successful smallest broker prototype with lower total risk/cost. |
| PostgreSQL and SQL Server must use an identical benchmark | **High** | Engine choice is already measurement-gated and operations/restore evidence matters as much as throughput. | A human constraint removes one candidate before benchmarking, recorded as an explicit scope decision rather than technical proof. |
| Exact production capacity is known | **Low / not established** | Required distributions, SLOs, retention, query corpus, hardware, and restore evidence are absent. | Approved metadata distributions, 6k/12k/72h campaigns, recovery tests, identical engine benchmark, and human objectives. |
| A 12,000-device synthetic pass predicts all production behavior | **Low** | Synthetic actors cannot reproduce every Windows, proxy, certificate, OS scheduler, EDR, operator, storage, or workload correlation. | Expanded Windows/pilot cohorts and repeated production-safe metadata comparisons reduce, but never eliminate, this residual risk. |

**Residual risk.** Even a complete synthetic pass cannot prove lawful use, future workload, firmware/storage honesty, every enterprise network, every operator action, or zero defects. A database can meet steady throughput and still fail during checkpoint, vacuum/index maintenance, backup, restore, policy fanout, or reconnect. Generator saturation, clock error, correlated retries, and hidden high-cardinality telemetry can invalidate results. The design contains these risks through independent offered-load accounting, exact evidence manifests, deterministic replay, generator self-tests, real boundary faults, realm-negative tests, restore drills, and conservative stop gates.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 Scope

This result covers:

- replaceable capacity variables and equations for fleet activity, sessions, events, bytes, compression, batches, retries, outages, local and central backlog, drain, storage, indexes, WAL/log, retention, query workload, and cost;
- a production-contract-compatible stateful simulator for 6,000–12,000 logical installations;
- deterministic traffic shapes and fairness controls for steady operation, morning start, reconnect, site outage, multi-day backlog, policy fanout, poison, slow database, restore, and rolling update;
- safe measurement and observability schemas;
- load, soak, failure, recovery, and restore evidence;
- provisional SLI/SLO and headroom hypotheses that remain human-owned;
- relational inbox worker pressure and database comparison;
- quantitative conditions for opening an external-broker ADR.

## 2.2 Non-goals

This result does not:

- redesign endpoint collection, privacy transformation, outbox durability, device identity, release, diagnostics, or Windows compatibility;
- authorize live employee activity, raw browsing data, production credentials, production certificates, or customer configuration;
- select event fields, identity precision, time precision, first-run lookback, hard-deny categories, retention, access roles, or prohibited uses;
- select the production database engine, cloud/on-premises provider, hardware, partition grain, index list, connection pool, broker product, observability backend, or audit store;
- approve SLO, error budget, RPO, RTO, maximum outage, recovery time, budget, staffing, support hours, or production deployment;
- prove deletion or acknowledged-data restore beyond the specific synthetic restore experiments in this topic; the later deletion/restore gate remains separate;
- claim that a benchmark result transfers to different schemas, versions, hardware, security products, network paths, retention, queries, or operational practices.

## 2.3 Allowlisted evidence record

**FACT.** Exactly the seven allowlisted project files were used. No other Project file was opened, searched, summarized, or treated as evidence.

| Ref | Allowlisted file | Reviewed local file | SHA-256 | Use and limitation |
|---|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md` | same | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Accepted topology, privacy, endpoint durability, batch/receipt, modular-monolith, relational-inbox, database, broker, realm, release, and restore invariants. Not production approval or runtime proof. |
| I02 | `04-data-and-schema-evidence-summary.md` | same | `1ed93b3d60d37da96c1f67e401deb10c9d57736e4f4dbfa26e16760bd2a19ce6` | Target concepts and explicit absence of representative volume, byte, retry, outage, retention, query, RPO/RTO, and engine evidence. |
| I03 | `05-decisions-contradictions-and-gates.md` | same | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | Accepted relational inbox/no-broker default and proof-gate order: inbox, capacity, long-outage/backpressure, then deletion/restore. |
| I04 | `06-research-evidence-rules.md` | same | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | Evidence labels, source quality, human authority, sanitization, and CLI-proof rules. |
| I05 | `result-review-01-foundations.md` | local `batch-01-review-result(3).md` | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | Strict contracts, independent oracle, UUIDv7, receipt states, realm isolation, safe metrics, repository and dependency gates. |
| I06 | `result-review-02-endpoint-data.md` | same | `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | Whole-page progress, version-independent natural identity, interpretation lineage, raw-value boundary, and privacy-safe observability. |
| I07 | `result-review-03-durability-release-identity.md` | same | `76854c3d6a12b9b717da90d4e368273bd88a672fc64a315afaeacfb3d701a785` | Immutable batches, durable `PREPARED` attempt, ambiguous replay, receipt-gated cleanup, deterministic fault evidence, per-installation identity, direct mTLS, closed diagnostics, and exact compatibility scope. |

No accepted-baseline change proposal is raised by this result.

## 2.4 Accepted inputs carried forward

| ID | Accepted input |
|---|---|
| A17-01 | Endpoints send bounded, versioned, authenticated, compressed HTTPS batches; endpoints never submit SQL or hold central database credentials. |
| A17-02 | A server receipt means durable custody in the declared failure domain, not validation, materialization, integration, or portal visibility. |
| A17-03 | Retry or replay creates one final business effect through stable identity and central uniqueness. |
| A17-04 | The initial server is a modular monolith with an ingestion boundary, relational durable inbox, leased workers, typed facts/aggregates, a control API/BFF, and governed integrations. |
| A17-05 | No external broker is a default. Failure domain, throughput, replay, fan-out, or cost evidence must justify one. |
| A17-06 | PostgreSQL is the reference target and SQL Server is a serious transition/fallback candidate. Production selection requires an identical benchmark plus operations, skills, licensing, and restore evidence. |
| A17-07 | Realm and installation authority derives from authenticated identity, never request-body claims. One realm cannot submit, view, mutate, or delete as another. |
| A17-08 | No component silently drops unacknowledged data under pressure. |
| A17-09 | Restore cannot lose acknowledged events and cannot expose deleted data before deletion/readiness state is restored. |
| A17-10 | Metrics and diagnostics use finite, value-free dimensions; raw activity and sensitive dynamic values are structurally absent. |
| A17-11 | Exact numeric limits, SLOs, capacity, engine, partition/index design, retention, broker, and cost remain provisional. |

## 2.5 Assumptions

| ID | ASSUMPTION | Why it is needed | How it is falsified |
|---|---|---|---|
| AS-01 | The accepted ingestion and receipt contracts are stable enough to compile into simulator adapters. | The simulator must use production bytes and semantics. | Contract build or compatibility matrix fails; stop simulator integration and repair predecessor contract. |
| AS-02 | Logical devices can be partitioned across load agents without changing per-device order or random sequence. | Enables 6k/12k distributed scale. | Same seed produces different device histories after repartitioning. |
| AS-03 | The first server benchmark can use a single-region relational failure domain. | Matches accepted initial modular monolith and relational inbox. | Human availability/RPO objective requires a different topology before the test. |
| AS-04 | T1 fictional event payloads can cover approved schema and size classes without copying source values. | Protects privacy while exercising contracts. | A required parser/compression behavior depends on real content; escalate for a minimum T3 aggregate, never raw activity. |
| AS-05 | A small Windows cohort is sufficient to validate byte/state equivalence while large logical scale runs elsewhere. | Controls lab cost. | Windows cohort reveals scheduling, TLS, compression, retry, or socket behavior absent from generic agents. Expand cohort or run larger Windows lane. |
| AS-06 | Realm classes can be represented by fictional weighted populations. | Tests isolation and fairness. | Approved pilot shows a materially different safe aggregate shape; update the scenario distribution. |

## 2.6 Unknowns that block production capacity

- **UNKNOWN:** managed endpoint count by active/disabled/offline state and by realm/site class.
- **UNKNOWN:** eligible users and concurrent sessions per endpoint over time.
- **UNKNOWN:** event generation distributions by source, session, weekday, and policy.
- **UNKNOWN:** canonical event bytes, compression ratios, batch occupancy, flush causes, and exact wire overhead distributions.
- **UNKNOWN:** retry attempts, status-query rates, timeout classes, certificate/network failures, and correlated reconnect behavior.
- **UNKNOWN:** local endpoint backlog bytes and event age after real outages.
- **UNKNOWN:** central inbox, validation, materialization, quarantine, and integration service times and variance.
- **UNKNOWN:** production query corpus, concurrency, scanned rows/pages, aggregation cadence, and portal freshness expectation.
- **UNKNOWN:** retention by state, backup frequency, replica topology, legal hold, deletion cadence, and storage growth.
- **UNKNOWN:** restore time, redo/recovery rate, failover behavior, acknowledged replay, and operator competence.
- **UNKNOWN:** database hardware/service tier, storage latency/IOPS/throughput, checkpoint/vacuum/index maintenance, and connection limits.
- **UNKNOWN:** acceptable cost, license position, support model, skills, on-call coverage, and maintenance windows.
- **UNKNOWN:** production SLO, error budget, RPO, RTO, maximum outage, backlog drain target, and permitted measurement cohort.

## 2.7 Unit of capacity

**RECOMMENDATION.** Never report a capacity result as endpoint count alone. Every result MUST bind at least:

```text
fleet population and active fraction
sessions per endpoint
source/event-rate distribution
canonical and compressed byte distributions
batch occupancy and flush-cause distribution
logical batch arrival and retry/status-query amplification
outage/backlog age and reconnect correlation
realm/site mix and fairness weights
contract/schema/serializer/compressor versions
database engine/build/configuration and hardware/storage class
worker count/lease algorithm and query/maintenance workload
retention/loaded history volume
faults, restore steps, duration, seed, and generator capacity
SLO/headroom hypotheses and human decision IDs
```

A statement missing any load-bearing term is an observation, not a capacity claim.

---

# 3. Recommended design with exact component responsibilities and trust boundaries

## 3.1 Architecture overview

```text
T1 Scenario Package + approved aggregate distributions
                  |
                  v
        Scenario Compiler / Validator
                  |
        immutable Run Plan + root seed
                  |
      +-----------+-----------------------+
      |                                   |
      v                                   v
Stateful Fleet Scheduler            Open-Arrival Scheduler
(device timelines)                  (independent offered rate)
      |                                   |
      +----------------+------------------+
                       v
               Distributed Load Agents
      +----------------+------------------+
      | production contract / serializer / compression |
      | stable IDs / mTLS client / retry / receipt     |
      +----------------+------------------+
                       v
      Network fault boundary / ingress load balancer
                       v
       UAM modular monolith ingestion boundary
                       v
        relational durable inbox transaction
                       v
    leased workers -> validate -> facts/aggregates
                       v
          query/API/integration synthetic mix

Windows fidelity cohort --------------^  (same run plan subset)
Fault controller ---------------------^  (network/DB/process/storage)
Independent oracle/reconciler <-------+  (receipts, rows, effects, lag)
Evidence collector -------------------+  (finite safe metrics + manifests)
```

## 3.2 Component responsibilities

| Component | MUST do | MUST NOT do |
|---|---|---|
| `Uam.Capacity.Model` | Hold named variables, units, distributions, formulas, uncertainty, and calculated scenarios; emit machine-readable assumptions and sensitivity results. | Hide defaults, infer production volumes from legacy row counts, or turn one point estimate into a requirement. |
| `Uam.FleetSim.Contracts` | Define strict scenario, run-plan, measurement, fault, truth, and evidence schemas; reference accepted production contract versions by digest. | Re-declare or fork production ingestion/event/receipt schemas. |
| Scenario Compiler | Validate closed input, normalize units, expand fictional populations, derive deterministic device/realm/site seeds, and create an immutable run plan. | Read production activity, accept arbitrary code/scripts/URLs/SQL, use wall-clock randomness, or silently coerce invalid values. |
| Stateful Fleet Scheduler | Maintain each logical installation’s online state, event production, local backlog, sealed batches, attempts, ambiguity, receipt state, policy version, software version, and next action. | Let server latency reduce intended device event generation or regenerate identity after ambiguous send. |
| Open-Arrival Scheduler | Start upload/status-query/API operations on the planned timeline independently of completion latency; record offered, started, delayed, generator-dropped, and completed counts. | Substitute achieved throughput for offered load or omit insufficient-generator-capacity evidence. |
| Load Agent | Execute assigned deterministic partitions, hold only test credentials, use the production client adapter, record bounded operation facts, and expose resource saturation. | Contain production secrets, use shared fleet credentials, create dynamic metric labels, or make capacity decisions locally. |
| Production Wire Adapter | Call the exact production serializer, compressor, digest, HTTP, retry classification, and receipt verification code; compare output against golden bytes. | Implement a “faster test-only” codec, bypass mTLS, synthesize receipts, or infer custody from HTTP success. |
| Test Identity Authority | Issue fictional per-installation lab credentials and realm bindings with bounded validity; support revocation and wrong-realm negatives. | Reuse production CA/key material, export real private keys, or use one fleet secret. |
| Windows Fidelity Cohort | Run the exact endpoint transport build and verify TLS, identity, timer, retry, compression, socket, CPU, memory, and cleanup behavior for a deterministic subset. | Claim 6k Windows fidelity from non-Windows agents or use real activity. |
| Fault Controller | Apply predeclared network, process, database, storage, clock, and restore faults by run-plan event; write signed/content-addressed fault evidence. | Expose a production route, accept arbitrary shell/SQL from scenario input, retain credentials, or change the truth ledger. |
| Independent Oracle/Reconciler | Derive expected batches, attempts, receipt outcomes, final effects, quarantine, lag, and fairness from the run plan without calling production decision code; compare server/agent evidence. | Treat server rows, metrics, or HTTP output as the expected result; suppress unexplained extras/misses. |
| Evidence Collector | Collect finite counters, histograms, resource facts, database statistics, query plans, logs by safe code, and artifact digests; verify completeness and clocks. | Collect URL/host/path/user/session/source/application values, arbitrary exception text, payloads, credentials, or unbounded IDs. |
| Gate Evaluator | Apply exact zero-tolerance invariants plus human-bound thresholds; produce one immutable result with first failures and uncertainty. | Accept an average-only pass, overwrite first failure, or waive a primary invariant through a performance score. |

## 3.3 Trust boundaries

### Boundary T17-1 — scenario input

Scenario files are code-adjacent authority. They MUST be closed schemas containing only release-owned enums, bounded numbers, fictional IDs, distributions, and references to approved artifacts. They MUST NOT contain SQL, shell, template code, arbitrary URLs, certificate material, secrets, internal addresses, file paths, regular expressions, or plugin names.

### Boundary T17-2 — load agent to UAM ingress

The load agent behaves as a fictional endpoint installation. mTLS/authenticated context supplies realm and installation authority. Request bodies MUST NOT establish realm or installation. The agent sends exact production batches and accepts only exact production receipts.

### Boundary T17-3 — receipt

A valid receipt is generated inside the declared durable inbox transaction or through a mechanism with equivalent proved failure-domain semantics. The fault controller cannot fabricate a valid receipt. A lost response after server commit causes exact-batch replay or status query, never a new batch identity.

### Boundary T17-4 — fault control

Fault-control APIs bind only to disposable test infrastructure and a run ID. Destructive credentials are short-lived and unavailable to load agents and application code. Production builds and deployments MUST contain no fault-controller client, endpoint, key, or schedule parser.

### Boundary T17-5 — measurements

The evidence plane receives only approved finite metadata. Exact device, realm, batch, receipt, and event IDs may exist inside a restricted truth store for reconciliation, but MUST be replaced by run-scoped ordinal or one-way random aliases before metric/log export. Exact identifiers MUST NOT be metric labels.

## 3.4 Repository placement and dependency rules

```text
/src/tools/Uam.Capacity.Model/
/src/tools/Uam.FleetSim.Contracts/
/src/tools/Uam.FleetSim.Compiler/
/src/tools/Uam.FleetSim.Agent/
/src/tools/Uam.FleetSim.WindowsCohort/
/src/tools/Uam.FleetSim.Oracle/
/src/tools/Uam.FleetSim.Evidence/
/src/tools/Uam.FleetSim.Gate/
/tests/capacity/{unit,contracts,determinism,agent-selftest,6k,12k,soak,fault,restore,broker}/
/scenarios/capacity/{templates,compiled,invalid}/
/eng/capacity/{postgres,sqlserver,network,restore,evidence}/
/docs/capacity/{model,runbooks,decisions,results}/
```

Normative dependency rules:

1. The production server and endpoint projects MUST NOT reference simulator projects.
2. The simulator production-wire adapter MAY reference public production contract/client assemblies; the independent oracle MUST NOT.
3. Fault-controller packages and credentials MUST be test-scope only and structurally absent from production manifests/SBOMs.
4. Database-specific benchmark adapters implement one engine-neutral contract; scenario definitions cannot branch on the engine except for explicitly declared engine-fault mechanics.
5. The same application container/binary digest and contract bundle MUST be used for the PostgreSQL and SQL Server comparison where technically possible.
6. A load framework or chaos tool remains replaceable behind UAM-owned interfaces; its reporting format is not the capacity evidence schema.

## 3.5 Configuration ownership, feature flags, and kill switches

| Configuration | Owner function | Mutability | Safety rule |
|---|---|---|---|
| Scenario templates and distributions | Capacity/Test Architecture | repository-reviewed | T1 only by default; any T3 aggregate reference requires approval ID, expiry, and lineage. |
| Production contract/client digest | Contract Authority | immutable per run | Mismatch stops before load. |
| Fleet size and shape | Capacity Engineering + run approver | run-scoped | Cannot imply production volume. |
| Database configuration | Database Reliability | environment-scoped and captured | Any unrecorded change invalidates comparison. |
| Worker count/lease policy | Ingestion Reliability | run-scoped | Changes are separate result dimensions, not hidden tuning. |
| Fault schedule | Reliability Test Owner | immutable per run | Faults cannot be added interactively without invalidating determinism. |
| Global test stop | Lab Operations / Incident Authority | immediate narrowing | Cancels offered work safely, preserves evidence, and begins cleanup. |
| Realm/site stop | Ingestion Operations | immediate narrowing | Stops one fictional class to test containment; cannot broaden authority. |
| Broker feature | Architecture Authority | compiled/configured off | Cannot be enabled until ADR trigger and prototype gate. |
| Cleanup/purge | Data Reliability + Records test owner | disabled by default | Only T1 lifecycle evidence; production cleanup remains separately approved. |

Required kill switches:

- stop all new simulated device operations;
- stop one agent, site class, realm class, protocol version, endpoint version, or scenario phase;
- pause ingestion acceptance while preserving already received transactions;
- pause worker leasing while leaving inbox rows durable;
- disable one poison type or integration consumer;
- stop restore/failover progression before readiness;
- stop broker prototype independently of the relational path.

Every kill switch MUST be tested for activation latency, stale-work rejection, idempotence, evidence retention, and safe re-enable through a higher run-plan revision or explicit operator action.

## 3.6 Realm isolation and fairness design

- Every simulated installation is bound to exactly one fictional realm through authenticated test identity.
- The same UUID values MAY deliberately appear in different realms to prove realm-prefix uniqueness and cache isolation.
- Ingestion, inbox, worker leases, materialization, query test data, and reconciliation keys begin with authenticated `realm_id`.
- Global capacity metrics MAY aggregate realm classes; per-realm diagnostics use bounded run-scoped ordinal classes, not production realm names or IDs.
- Worker scheduling SHOULD use explicit fairness classes such as weighted deficit round robin, bounded per-realm concurrency, or an equivalent measured algorithm. FIFO across the whole fleet is not assumed fair under a reconnect storm.
- A large realm MUST NOT starve a small realm, and poison work in one realm MUST NOT block healthy work in another.
- Fairness is evaluated using maximum lag, starvation duration, normalized drain share, and a Jain index as a secondary summary. A high Jain index cannot compensate for one starved class.

## 3.7 Privacy-safe observability and cardinality budget

Allowed high-level dimensions are fixed enums such as:

```text
component
operation_family
scenario_phase
fleet_size_class
realm_size_class
site_state_class
endpoint_version_class
contract_major
batch_size_bucket
backlog_age_bucket
attempt_number_bucket
outcome_family
retry_family
receipt_state
worker_stage
poison_class
database_engine_class
database_wait_class
fault_class
build_ring
```

Forbidden dimensions and record content include:

```text
real or fictional device ID as a metric label
realm ID/name as a metric label
batch/event/receipt UUID as a metric label
URL, host, path, application, rule, source, user, SID, session
certificate subject/serial/private material
IP, internal address, proxy URL, connection string
SQL text with dynamic values
raw request/response body
exception message/stack containing dynamic content
```

Exact IDs are permitted only in the restricted run truth database, encrypted evidence capsule, or deterministic NDJSON ledger required to prove one final effect. They are never exported to the general telemetry backend.

A run MUST calculate its theoretical maximum time-series count before starting:

```text
series_bound = Σ(instrument_i × Π(cardinality of each allowed label_i))
```

The run is rejected when the bound exceeds the approved lab budget or contains an unbounded label. Runtime actual series and churn MUST be compared with the theoretical bound.

---

# 4. Alternatives, rejection reasons, and conditions that would change the choice

| Alternative | Decision now | Reason | Condition that could change it |
|---|---|---|---|
| Stateless HTTP loop with 6,000 virtual users | **REJECTED** | Cannot faithfully model local backlog, immutable batches, ambiguous attempts, stable replay, receipts, policy/version state, or per-device fairness. | None for the authoritative fleet lane; it may remain a narrow ingress microbenchmark. |
| Closed-loop virtual users only | **REJECTED** | Server slowdown reduces offered traffic and can hide overload/coordinated omission. | A scheduler proves equivalent independent arrival timing and reports skipped/delayed starts. |
| k6-only simulator | **REFERENCE / OPTIONAL CROSS-CHECK** | Strong open-arrival HTTP tooling, but UAM device state and production .NET client semantics would be duplicated in JavaScript; AGPL review is required. | Use as an independent open-arrival cross-check after Legal/Dependency approval, never the sole truth source. |
| NBomber as core simulator | **REFERENCE ONLY PENDING LICENSE** | C# and open-load models fit, but organizational use requires a commercial license and UAM still needs its own durable actor/oracle/evidence semantics. | Procurement, legal, provenance, and a bake-off show lower total implementation cost without losing determinism or state fidelity. |
| Azure IoT Telemetry Simulator fork | **REJECTED AS DEPENDENCY; REFERENCE ONLY** | It targets IoT Hub/Event Hub/Kafka and AMQP multiplexing/shared connection models, not UAM HTTPS/mTLS batches/receipts. Maintenance is limited. | No expected core adoption; bounded ideas such as deterministic device configuration may be reused independently. |
| Run 6,000 full Windows VMs/process stacks | **REJECTED AS DEFAULT** | Excessive lab cost and operational noise; scale would measure virtualization more than ingestion. | A Windows-specific behavior cannot be represented or validated by a smaller fidelity cohort. |
| Database microbenchmark (`pgbench` or synthetic SQL) as capacity proof | **REJECTED AS SOLE PROOF** | Omits HTTP/TLS, serialization, compression, receipt, application transactions, worker logic, poison, query mix, and restore. | Retain as a diagnostic subtest correlated with the end-to-end benchmark. |
| PostgreSQL selected without SQL Server benchmark | **REJECTED** | Conflicts with accepted measurement gate and transition/operations evidence. | A recorded human procurement/platform constraint removes SQL Server before the technical comparison. |
| SQL Server selected for legacy familiarity | **REJECTED** | Familiarity is relevant but not sufficient; licensing, restore, throughput, support, and migration must be evidenced. | Identical benchmark plus human operations/skills/licensing decision favors it. |
| Add an external broker before benchmark | **REJECTED** | Adds another custody, replay, partitioning, security, operations, cost, and failure domain without measured need. | One or more quantitative triggers in section 9.4 are crossed and the broker prototype passes. |
| Use broker as the durable receipt boundary while retaining relational inbox | **DEFERRED CHANGE PROPOSAL** | Changes accepted receipt failure domain and can create dual-write ambiguity. | Explicit ADR defines one custody boundary, transactional handoff, replay, restore, migration, and endpoint receipt semantics; smallest prototype passes. |
| Size from average event rate | **REJECTED** | Tails, bursts, retries, correlated outages, query/maintenance contention, and recovery dominate risk. | Never sufficient alone; averages remain one input to a distribution. |
| Copy production events into the simulator | **REJECTED** | Violates synthetic-first and minimization constraints; creates disclosure, lineage, retention, and deletion risk. | Only approved minimum aggregate metadata may replace distributions, never raw activity. |
| One global FIFO worker queue | **REJECTED AS ASSUMED DEFAULT** | Can starve small realms and healthy work behind reconnect/poison bursts. | Measured workload proves no starvation and lower complexity; otherwise explicit fairness remains. |
| Unlimited retries for poison/transient work | **REJECTED** | Causes retry amplification and queue capture. | No condition; retries remain bounded/classified with quarantine and operator evidence. |
| Dynamic per-device telemetry labels for diagnosis | **REJECTED** | Privacy and cardinality risk; can destabilize the observability system during the incident being measured. | Use restricted run truth records and sampled case aliases, not general metrics. |

## 4.1 Change-proposal boundary

A baseline change proposal is mandatory if experiments claim UAM requires any of the following:

- a broker as the initial durable custody boundary;
- endpoint-supplied realm/device authority;
- a receipt before relational durable commit;
- best-effort dropping of unacknowledged data;
- multiple final effects from one stable source event outside an explicit correction model;
- a separate stateless test codec that differs from production bytes;
- raw production activity to size the system;
- cross-realm co-mingling to reach performance;
- a database engine not subjected to the accepted identical benchmark unless removed by a human constraint.

The proposal must name the affected invariant, new primary evidence, alternatives, privacy/security/durability impact, smallest falsifying experiment, operational and migration consequences, and ADR action.

---

# 5. Interfaces/protocols and example contracts or schemas

## 5.1 Formula-based capacity model

### 5.1.1 Modelling rules

**RECOMMENDATION.** The capacity model is an executable library and machine-readable document, not a spreadsheet with hidden constants. Every variable MUST include:

```text
name
symbol
unit
distribution or series
source = T1 | T2 | approved T3 aggregate | human decision | estimate
cohort/environment
sample count and interval
observed date range
quantiles and confidence/uncertainty method
owner
expiry/review trigger
```

Calculations MUST preserve distributions or use simulation/bootstrapping where nonlinear effects make averages unsafe. A single mean MAY be displayed, but no gate is based on it alone.

### 5.1.2 Fleet and activity variables

| Symbol | Unit | Meaning |
|---|---:|---|
| `N_m` | endpoints | Managed installations in the scenario. |
| `N_r` | realms | Fictional realm count; each realm has weight and size class. |
| `p_enabled(i,t)` | probability/0–1 | Installation enabled by product/tenant/compatibility/identity state. |
| `p_online(i,t)` | probability/0–1 | Network-reachable at time `t`. |
| `p_active(i,t)` | probability/0–1 | Eligible to generate events at time `t`. |
| `S_i(t)` | sessions | Eligible interactive sessions for installation `i`. |
| `λ_{i,s}(t)` | events/s | Event generation rate for session `s` on installation `i`. |
| `λ_i(t)` | events/s | Total event generation rate for installation `i`. |
| `Λ_e(t)` | events/s | Fleet event arrival rate before batching. |

```text
λ_i(t) = Σ over eligible sessions s of λ_{i,s}(t)

Λ_e(t) = Σ from i=1 to N_m of
         p_enabled(i,t) × p_active(i,t) × λ_i(t)
```

`p_online` does not change event generation while an endpoint is permitted to collect offline; it changes upload availability and therefore backlog. When product policy disables collection, `p_enabled` or `p_active` becomes zero.

For class-based planning:

```text
Λ_e(t) ≈ N_m × Σ_c [w_c × p_enabled,c(t) × p_active,c(t)
                    × E(S_c(t)) × E(λ_event_per_session,c(t))]
```

This approximation is for sensitivity analysis only. The simulator samples per-device/session distributions and correlations.

### 5.1.3 Event bytes and compression

| Symbol | Unit | Meaning |
|---|---:|---|
| `B_e` | bytes/event | Canonical uncompressed event bytes, including event framing. |
| `B_env` | bytes/batch | Uncompressed envelope and fixed batch metadata. |
| `ρ_c` | compressed/uncompressed | Compression ratio for content class `c`; lower is better compression. |
| `B_tls` | bytes/request | Measured TLS/HTTP framing and transport overhead allocated to the request. |
| `B_wire` | bytes/batch | Exact wire request bytes, including compressed body and transport overhead. |

For a batch with events `e=1..K`:

```text
B_uncompressed = B_env + Σ_e B_e
B_body          = CompressProduction(B_uncompressed)
ρ_observed      = B_body / B_uncompressed
B_wire          = B_http_headers + B_tls_allocated + length(B_body)
```

**RECOMMENDATION.** The authoritative model uses the exact production compressor and records actual lengths. The formula `B_body ≈ ρ × B_uncompressed` is for planning and sensitivity only. Compression ratio MUST be stratified by schema version, event-size bucket, batch occupancy, and content class. Do not assume one ratio across small and large batches.

### 5.1.4 Batch formation

| Symbol | Unit | Meaning |
|---|---:|---|
| `K_max` | events/batch | Release safety ceiling, provisional until measured. |
| `U_max` | uncompressed bytes/batch | Contract ceiling. |
| `C_max` | compressed bytes/batch | Contract/ingress ceiling. |
| `τ_flush` | seconds | Maximum age before sealing a nonempty batch. |
| `K_i,j` | events | Actual occupancy of batch `j` for device `i`. |
| `F_flush` | enum | Flush cause: event limit, byte limit, age, shutdown, policy/version boundary, explicit drain. |

A simulator batch closes at the first allowed condition:

```text
close when:
  event_count == K_max
  OR predicted_uncompressed_bytes + next_event > U_max
  OR production_compressor would exceed C_max
  OR oldest_event_age >= τ_flush
  OR a contract/policy/release boundary forbids mixing
  OR a safe lifecycle drain requests sealing
```

Approximate logical batch rate:

```text
Λ_b(t) ≈ Λ_e(t) / E(K_actual(t))
```

The exact simulator calculates batch formation per device; it does not divide a global event rate by an average batch size when events are sparse or correlated.

### 5.1.5 Retry and ambiguity amplification

| Symbol | Unit | Meaning |
|---|---:|---|
| `A_attempt` | attempts/logical batch | Mean and tail upload attempts per sealed batch. |
| `P_k` | probability | Probability a logical batch reaches attempt number `k`. |
| `Λ_status` | requests/s | Ambiguous-outcome status-query rate. |
| `Λ_http` | requests/s | Total upload/status request rate offered to ingress. |
| `R_retry_bytes` | bytes/s | Repeated wire bytes caused by retries/replay. |

```text
A_attempt = Σ_{k>=1} P(attempt_count >= k)
          = total upload attempts / logical sealed batches

Λ_http(t) = Λ_b(t) × A_attempt(t) + Λ_status(t)

R_retry_bytes(t) = Σ attempts of replayed exact bodies / Δt
```

Retry amplification MUST be reported by reason family and attempt bucket. Averages can hide a small poison or site class retrying indefinitely; therefore the gate includes maximum attempt state, quarantine rate, and work-age tails.

### 5.1.6 Local endpoint backlog

For endpoint `i`, outage interval `[t_0,t_1]`:

```text
Q_local_events,i(t_1) = Q_local_events,i(t_0)
                      + ∫_{t_0}^{t_1} λ_i(t) dt
                      - durable receipts applied during the interval
                      - approved terminal dispositions

Q_local_bytes,i(t_1)  = exact stored event + batch + index + WAL bytes
```

Because the accepted baseline prohibits silent deletion of unacknowledged data, an endpoint reaching its local safety budget pauses collection or enters an approved explicit terminal state; the capacity model MUST NOT subtract an implicit drop rate.

Fleet local backlog:

```text
Q_local_total_events = Σ_i Q_local_events,i
Q_local_total_bytes  = Σ_i Q_local_bytes,i
```

Required local capacity for an assumed outage `T_out`:

```text
S_endpoint_required,p = quantile_p[
    base_store_bytes
  + event_and_batch_bytes_generated_over(T_out)
  + endpoint_WAL_and_index_overhead
  + migration/repair reserve
]
```

`T_out`, percentile `p`, and pause/loss semantics are **HUMAN DECISION**.

### 5.1.7 Reconnect and central backlog

Let `Q_0` be logical batches or events waiting at the beginning of recovery, `λ_new` the continuing new arrival rate, and `μ_safe` the sustainable processing/drain rate while all required query, backup, maintenance, and fairness work remains active.

```text
dQ_central/dt = λ_arrival(t) - μ_effective(t)
```

For a constant approximation:

```text
T_recover = Q_0 / (μ_safe - λ_new), only when μ_safe > λ_new
```

Required drain capacity for a human-selected recovery target `T_target`:

```text
μ_required = λ_new_peak + Q_0 / T_target
```

With reserve factor `h`:

```text
μ_design = (λ_new_peak + Q_0 / T_target) × (1 + h)
```

A system with `μ_safe <= λ_new` cannot recover regardless of peak acceptance. It remains in backlog growth and fails the recovery gate.

Backlog age is more important than only row count:

```text
age_oldest(t) = t - min(received_at of uncompleted work)
lag_p99(t)    = p99(t - received_at over unfinished work)
```

The simulator records inbox custody lag, validation lag, materialization lag, visibility lag, and per-realm oldest age separately.

### 5.1.8 Ingestion and worker service rates

| Symbol | Unit | Meaning |
|---|---:|---|
| `μ_ingress` | batches/s | Sustainable durable-custody transactions at the receipt boundary. |
| `μ_validate` | batches/s | Validation service rate. |
| `μ_materialize` | events/s | Typed fact/materialization service rate. |
| `μ_integrate` | items/s | Optional governed integration service rate. |
| `W_stage` | seconds | Stage service-time distribution. |
| `L_stage` | concurrent work | Mean work in stage. |

Little’s Law is used only after verifying a stable observation interval:

```text
L_stage = λ_stage × W_stage
```

A benchmark MUST distinguish:

```text
accepted/durably received
validated
quarantined
materialized
visible
integration-complete
```

Receipt latency is measured only to durable custody. Portal freshness cannot be inferred from it.

### 5.1.9 Relational inbox storage

| Symbol | Unit | Meaning |
|---|---:|---|
| `D_inbox` | seconds/days | Retention of received payload/tombstone state. |
| `B_inbox_row` | bytes/batch | Measured heap/row bytes excluding payload. |
| `B_inbox_index` | bytes/batch | Measured aggregate index bytes. |
| `B_receipt` | bytes/batch | Receipt/evidence row bytes. |
| `F_bloat` | multiplier | Measured table/index bloat or free-space factor under the workload. |
| `F_replica` | copies | Primary + replicas/log copies included in cost/storage. |
| `F_backup` | multiplier/copies | Backup/snapshot retention factor. |

Planning estimate:

```text
S_inbox_live ≈ batches_retained ×
              (E(B_wire_body) + B_inbox_row + B_inbox_index + B_receipt)
              × F_bloat

batches_retained ≈ ∫ over D_inbox Λ_b(t) dt
```

Total storage is not merely table size:

```text
S_platform = F_replica × (S_inbox_live + S_fact_live + S_aggregate_live
                          + S_audit_live + S_quarantine_live
                          + S_indexes + S_free_space_and_maintenance)
           + S_backups
           + S_logs/WAL_retained
           + S_restore_staging
```

Retention terms remain human-owned. Benchmarks MUST load the historical volume required by the candidate retention/query decision; an empty database result is not representative.

### 5.1.10 Facts, aggregates, indexes, and partitions

```text
S_fact_live ≈ events_retained ×
             (B_fact_row + Σ B_fact_index_tuple) × F_bloat_fact

S_aggregate_live ≈ aggregate_keys × time_buckets ×
                  (B_aggregate_row + B_aggregate_indexes)
```

Partitioning is justified by measured lifecycle, query, maintenance, and recovery behavior, not row count alone. A candidate partition grain MUST be compared for:

- ingestion/index locality;
- partition creation/attachment overhead;
- query pruning and plan stability;
- vacuum/statistics/index maintenance or SQL Server equivalent;
- deletion/retention operation duration;
- backup/restore and replica behavior;
- operational object count and migration risk.

### 5.1.11 WAL / transaction-log model

Payload bytes do not predict WAL/log bytes reliably because indexes, page images, allocation, checkpoint, compression, and engine behavior matter. The authoritative value is measured:

```text
R_wal = Δ(wal_or_log_bytes) / Δt
WAL_bytes_per_custody_tx = Δwal_bytes / durable_receipt_transactions
WAL_bytes_per_event      = Δwal_bytes / materialized_events
```

Planning estimate:

```text
R_wal ≈ tx_ingress × E(W_ingress_tx)
      + tx_worker × E(W_worker_tx)
      + tx_control × E(W_control_tx)
      + maintenance_wal_rate
```

The benchmark records checkpoint frequency/duration, flush latency, log write waits, replica lag, archive/backup throughput, and recovery replay rate. A system that meets request latency while log retention grows without bound fails.

### 5.1.12 Query and portal workload

Each query class `q` has:

```text
arrival process λ_q(t)
concurrency C_q
parameter selectivity distribution
historical window/retention depth
rows/pages examined
result row/byte bounds
CPU time, elapsed time, logical/physical reads
plan fingerprint and plan-change evidence
cache state = warm | cold | mixed
priority class
```

For query class `q`:

```text
L_q = λ_q × W_q                       # stable interval only
IO_rate_q = λ_q × E(pages_read_q)
CPU_rate_q = λ_q × E(cpu_seconds_q)
```

The capacity run MUST execute the approved synthetic query corpus concurrently with ingest, workers, maintenance, backup, and recovery. A write-only benchmark cannot select a production engine.

### 5.1.13 Network and TLS

```text
R_egress_agents = Σ B_wire_attempt / Δt
R_ingress_server = same request bytes at boundary
R_receipts       = Σ receipt_wire_bytes / Δt
connections_open = new + reused connections by agent/site/version class
TLS_handshake_rate = new authenticated connections / Δt
```

The reconnect scenario separates:

- device logical reconnect rate;
- TCP/TLS connection rate;
- mTLS authentication rate;
- HTTP request rate;
- batch replay rate;
- status-query rate.

Connection reuse and HTTP version are captured as evidence, not assumed.

### 5.1.14 Headroom

For measured sustainable capacity `μ_sustainable` under the complete workload and selected peak `λ_peak`:

```text
headroom_fraction H = (μ_sustainable - λ_peak) / λ_peak
```

Recovery-aware headroom:

```text
H_recovery = (μ_sustainable - λ_peak - Q_0/T_target) / λ_peak
```

`H_recovery >= 0` is necessary but not sufficient; tail latency, fairness, error, resource, log, and restore gates must also pass. The final required `H` and `T_target` are human decisions.

### 5.1.15 Fairness

For `n` realm/site classes, let `x_r` be actual normalized drain share divided by configured weight during an interval:

```text
Jain_fairness = (Σ_r x_r)^2 / (n × Σ_r x_r^2)
```

Also record:

```text
max_starvation_interval_r
oldest_lag_r
p99_lag_r
work_completed_r / offered_work_r
lease_conflict_rate_r
```

A fairness pass requires zero starvation beyond the human threshold and bounded lag ratios. The Jain index is supplementary; it can conceal a short but unacceptable outage.

### 5.1.16 Cost model

All costs are versioned inputs in local currency and date; no vendor list price is treated as the organization’s actual cost.

```text
C_total_period = C_compute
               + C_database_license_or_service
               + C_primary_storage
               + C_replica_and_log_storage
               + C_backup_and_restore_staging
               + C_network
               + C_observability
               + C_load_lab
               + C_support_and_on_call
               + C_maintenance_and_upgrade
               + C_expected_incident_loss
```

Unit economics:

```text
C_per_managed_endpoint = C_total_period / N_m
C_per_million_events    = C_total_period / (events_period / 1,000,000)
C_per_GiB_durable       = storage_and_backup_cost / durable_GiB_period
C_per_recovery_drill    = drill infrastructure + labour + service impact
```

A broker comparison includes broker service/license, replicas, storage, network duplication, schema/connector operations, security, monitoring, on-call skills, upgrade, replay, and dual-system migration—not only message price.

### 5.1.17 Sensitivity and uncertainty

The model MUST produce at least:

- base, p50, p95, p99, and bounded worst-case input scenarios where meaningful;
- one-at-a-time sensitivity ranking;
- correlated stress cases, especially active fraction × event rate × retry × outage;
- Monte Carlo or deterministic stratified sampling with recorded algorithm/seed;
- confidence/uncertainty intervals for measured quantiles where sample size permits;
- a “decision flips when” report for engine, headroom, storage, and broker choices.

No confidence percentage is assigned to an architecture conclusion. Statistical intervals describe measured data only.

## 5.2 Scenario package contract

The canonical scenario is strict JSON or YAML converted into canonical JSON before hashing. Example values are wholly fictional.

```yaml
contract: uam.capacity.scenario
version: 1.0.0
scenarioId: cap-reconnect-24h-v1
classification: T1_FICTIONAL
purpose: reconnect backlog and recovery
rootSeed:
  algorithm: xoshiro256ss-v1
  valueHex: 8d72c1a1f0e4b2c39017e56a4d88f011
clock:
  startUtc: 2026-07-31T06:00:00Z
  mode: simulated-monotonic
fleet:
  managedInstallations: 6000
  realms:
    - classId: small
      count: 30
      devicesPerRealmDistribution: { kind: fixed, value: 50 }
      fairnessWeight: 1
    - classId: large
      count: 3
      devicesPerRealmDistribution: { kind: fixed, value: 1500 }
      fairnessWeight: 30
  sessionsPerActiveDevice:
    kind: empirical-discrete
    values: [{ value: 0, weight: 20 }, { value: 1, weight: 75 }, { value: 2, weight: 5 }]
  eventRatePerSession:
    kind: bounded-lognormal
    unit: events/minute
    parameters: { median: 0.5, sigma: 0.8, maximum: 20 }
    classification: ESTIMATE
batching:
  contractDigest: sha-256:fictional-production-contract-digest
  eventLimit: 500
  uncompressedByteLimit: 1048576
  compressedByteLimit: 524288
  flushAge: PT5M
  limitsClassification: ESTIMATE
network:
  initialState: OFFLINE
  reconnect:
    startOffset: PT0S
    duration: PT10M
    jitter: deterministic-uniform
  ambiguityRate: 0.01
  ambiguityClassification: ESTIMATE
backlog:
  preGenerateDuration: PT24H
  preserveExactBatchBytes: true
serverWorkload:
  queryMixRef: query-mix-synthetic-v1
  policyFanoutRef: none
faults: []
stopConditions:
  - primaryInvariantFailure
  - generatorOfferedLoadErrorAboveBudget
  - evidenceSinkCardinalityAboveBudget
```

Normative rules:

- Unknown fields, duplicate keys, invalid units, remote includes, and unbounded distributions are rejected.
- Scenario values that are **ESTIMATE** or **HUMAN DECISION** are explicitly classified.
- A compiled plan contains every sampled device timeline and derived seed, so rerun does not depend on library iteration order.
- The scenario cannot name a real realm, user, host, URL, address, certificate, or connection string.
- Secrets and endpoint addresses enter only through the sealed lab deployment layer, never the canonical scenario or evidence package.

## 5.3 Deterministic identity and random stream contract

```text
run_id                 = UUIDv7 from fixed scenario clock and root seed
realm_id(r)            = deterministic UUIDv7(domain="realm", ordinal=r)
installation_id(i)     = deterministic UUIDv7(domain="installation", ordinal=i)
event_id(i,n)          = production-compatible stable ID derived/minted by the owning test adapter
batch_id(i,b)          = production-compatible stable ID persisted in device actor state
attempt_id(batch,k)    = stable attempt identity per accepted contract
stream_seed(component, key...) = KDF(root_seed, domain_separator, canonical_key_bytes)
```

The exact pseudo-random algorithm and test vectors are part of the contract. Parallel partitioning MUST NOT consume one shared global random stream. Every device, scenario component, and fault has a domain-separated stream so changing one class does not reorder unrelated devices.

A deterministic fixture may generate UUIDv7 values under a fixed test clock, but UUID timestamp bits are not business time, event order, receipt time, or authorization.

## 5.4 Simulator actor state schema

```json
{
  "contract": "uam.capacity.device-state",
  "version": "1.0.0",
  "runOrdinal": 42,
  "realmOrdinal": 3,
  "installationOrdinal": 812,
  "softwareClass": "N",
  "contractMajor": 1,
  "policyRevision": 7,
  "networkState": "ONLINE",
  "collectionState": "ENABLED",
  "localEventCount": 124,
  "localUncompressedBytes": 38120,
  "sealedBatches": [
    {
      "batchOrdinal": 9,
      "state": "AMBIGUOUS",
      "eventCount": 100,
      "uncompressedBytes": 30100,
      "wireBytes": 4102,
      "attemptCount": 2,
      "nextRetryAtTick": 971231
    }
  ],
  "lastDurableReceiptOrdinal": 8,
  "nextActionTick": 971231
}
```

This state is test evidence, not a production endpoint schema. It uses ordinals in shareable evidence. The restricted ledger maps ordinals to deterministic fictional UUIDs for exact reconciliation.

## 5.5 Production wire adapter

Illustrative interface:

```csharp
public interface IProductionIngestionClientAdapter
{
    ContractIdentity Contract { get; }
    SerializerIdentity Serializer { get; }
    CompressorIdentity Compressor { get; }

    ValueTask<PreparedWireBatch> PrepareAsync(
        SimulatedInstallationContext authenticatedContext,
        IReadOnlyList<MinimizedSyntheticEvent> events,
        StableBatchIdentity existingOrNewBatch,
        CancellationToken cancellationToken);

    ValueTask<TransportObservation> SendExactAsync(
        PreparedWireBatch exactBatch,
        TestClientCredential credential,
        CancellationToken cancellationToken);

    ReceiptVerificationResult VerifyReceipt(
        PreparedWireBatch exactBatch,
        TransportObservation observation);
}
```

Normative rules:

- `PreparedWireBatch` is immutable and includes canonical content digest, exact compressed body bytes, wire digest, headers permitted by the production contract, and stable batch ID.
- `SendExactAsync` cannot rebuild or recompress after ambiguity.
- The adapter must expose actual byte counts and timings without exposing payload content.
- The simulator and Windows cohort produce byte-identical output for the same prepared fixture or the gate stops.
- Authentication context comes from the test identity boundary, not body fields.

## 5.6 Ingestion request and receipt examples

All values are fictional and illustrative; the accepted production contract remains authoritative.

```http
POST /ingestion/v1/batches HTTP/1.1
Content-Type: application/vnd.uam.batch+json
Content-Encoding: gzip
Idempotency-Key: 019d0000-0000-7000-8000-000000000101
Digest: sha-256=:fictional-base64-digest:

<exact compressed bytes>
```

Illustrative receipt body:

```json
{
  "contract": "uam.ingestion.custody-receipt",
  "version": "1.0.0",
  "receiptId": "019d0000-0000-7000-8000-000000000201",
  "batchId": "019d0000-0000-7000-8000-000000000101",
  "contentDigest": "sha-256:fictional-content",
  "wireDigest": "sha-256:fictional-wire",
  "custodyState": "DURABLY_RECEIVED",
  "failureDomainClass": "RELATIONAL_PRIMARY_COMMIT_V1",
  "durableAtUtc": "2026-07-31T06:10:00Z"
}
```

The endpoint applies a receipt only when authenticated response context, batch ID, content digest, wire digest, contract version, state, and allowed failure-domain class match. Semantic rejection may be represented separately and does not undo custody.

## 5.7 Engine-neutral durable-inbox benchmark interface

```csharp
public interface IDurableInboxBenchmarkStore
{
    Task InitializeAsync(BenchmarkSchemaManifest manifest, CancellationToken ct);

    Task<ReceiptOutcome> AcceptBatchAsync(
        AuthenticatedDeviceContext context,
        ExactWireBatch batch,
        CancellationToken ct);

    Task<IReadOnlyList<LeasedInboxItem>> LeaseAsync(
        WorkerIdentity worker,
        LeaseRequest request,
        CancellationToken ct);

    Task<WorkerCommitOutcome> CommitValidationAsync(
        WorkerIdentity worker,
        ValidationCommit commit,
        CancellationToken ct);

    Task<WorkerCommitOutcome> CommitMaterializationAsync(
        WorkerIdentity worker,
        MaterializationCommit commit,
        CancellationToken ct);

    Task<ReceiptStatus> QueryReceiptAsync(
        AuthenticatedDeviceContext context,
        StableBatchIdentity batch,
        CancellationToken ct);
}
```

Both engine adapters implement the same semantic tests. Engine-specific SQL and hints are contained within adapters and recorded by digest. The benchmark compares semantics first; a faster adapter that violates lease, uniqueness, receipt, or realm invariants fails.

## 5.8 Worker lease contract

Logical lease fields:

```text
realm_id
inbox_id
state
available_at
attempt_count
lease_owner
lease_token
lease_until
payload_digest
received_at
priority/fairness_class
poison_class?  # only after classified failure
row_version
```

Rules:

1. Leasing is atomic: one active lease token owns an item for the lease interval.
2. A worker commits only with the matching owner/token/version.
3. Lease expiry permits recovery but does not create a second final business effect.
4. Poison classification is finite and bounded; arbitrary exception text is not stored as a queue key or metric label.
5. Realm is part of every uniqueness, lookup, lease, and materialization key.
6. Fairness selection cannot allow one realm/priority to starve another beyond the configured bound.
7. A lease query plan and wait profile are captured during load; “skip locked” or `READPAST` capability does not prove fitness by itself.

## 5.9 Measurement schema and safe instrumentation

Canonical measurement record:

```json
{
  "contract": "uam.capacity.measurement",
  "version": "1.0.0",
  "runId": "019d0000-0000-7000-8000-000000000001",
  "source": "LOAD_AGENT",
  "agentOrdinal": 4,
  "intervalStartTick": 120000,
  "intervalDurationMs": 1000,
  "operationFamily": "UPLOAD",
  "scenarioPhase": "RECONNECT_DRAIN",
  "offered": 2000,
  "started": 1998,
  "completed": 1975,
  "generatorDelayed": 2,
  "generatorDropped": 0,
  "outcomes": {
    "DURABLE_RECEIPT": 1900,
    "AMBIGUOUS": 50,
    "RETRYABLE": 20,
    "SECURITY_HOLD": 0,
    "CONTRACT_REJECT": 5
  },
  "wireBytes": 8312231,
  "latencyHistogramRef": "hist/upload-receipt/interval-120",
  "agentCpuBucket": "LT_60_PERCENT",
  "agentMemoryBucket": "LT_70_PERCENT",
  "clockErrorBucket": "LT_2_MS"
}
```

Separate histogram files contain bounded integer buckets or a reviewed histogram encoding; no exemplars with device/batch IDs are exported. Exact reconciliation uses a restricted operation ledger:

```text
run ordinal
agent ordinal
device ordinal
batch ordinal
attempt ordinal
planned tick
actual start tick
completion tick
transport outcome code
receipt ordinal/state
exact body digest
server inbox ordinal
final effect count/digest
```

## 5.10 Required SLIs

### Offered-load and generator SLIs

- offered operations/s by family and phase;
- started/offered ratio;
- generator delayed-start distribution;
- generator dropped-start count;
- agent CPU, memory, sockets, TLS handshakes, event-loop/thread-pool delay, GC pause, and network utilization;
- clock synchronization error and monotonic-clock anomalies;
- per-agent partition skew.

### Ingress and custody SLIs

- accepted/durable receipts/s;
- receipt latency from first byte and from planned arrival;
- duplicate replay response latency;
- durable transaction latency and log flush time;
- HTTP/TLS outcome family;
- request/response bytes and compression distributions;
- connection reuse and handshake rate;
- receipt conflicts and unauthorized/cross-realm attempts.

### Inbox and worker SLIs

- inbox rows/bytes and oldest age by bounded fairness class;
- lease acquisition latency, empty polls, conflicts, expiries, and stale commits;
- validation/materialization/quarantine throughput and latency;
- retry/poison amplification;
- worker CPU, allocations, database connections, lock waits, deadlocks, and plan fingerprints;
- final business-effect duplicates/misses/conflicts.

### Database SLIs

- CPU, memory, connections, transaction rate, commits/rollbacks;
- WAL/log bytes, flush latency, checkpoint/log growth, replica/archive lag where present;
- logical/physical reads/writes, IOPS, throughput, queue depth, latency;
- table/index sizes, bloat/free-space proxies, statistics freshness, autovacuum/maintenance or SQL Server equivalents;
- blocking/deadlocks, wait classes, temp/spill, query-plan changes;
- backup duration/throughput, restore/recovery duration, redo/replay rate, integrity checks.

### Recovery and fairness SLIs

- starting backlog by events/batches/bytes/age;
- net drain rate `μ - λ_new`;
- time to return to each backlog-age threshold;
- per-realm/site oldest and p99 lag;
- starvation interval, normalized service share, Jain summary;
- steady workload impact while draining;
- post-recovery resource and storage normalization.

### Query/API SLIs

- offered/started/completed query rate by finite query class;
- end-to-end and database elapsed/CPU/read distributions;
- result bounds, timeout/cancellation, plan fingerprint;
- portal/API freshness state, distinct from receipt latency;
- accessibility-oriented API behavior where relevant: deterministic pagination, bounded response, stable error codes, no load-induced loss of keyboard/screen-reader semantics in any later UI test. This topic does not select portal technology.

## 5.11 Error taxonomy

| Family | Examples | Simulator behavior | Server expectation |
|---|---|---|---|
| `GENERATOR_CAPACITY` | delayed/dropped starts, CPU/socket/memory saturation, clock error | mark run invalid or reduce claimed offered range; never blame SUT automatically | none |
| `CONTRACT_PERMANENT` | unknown version, malformed body, digest mismatch | no blind retry; record deterministic reject | bounded reject/quarantine, no receipt conflict |
| `AUTH_SECURITY` | bad cert, wrong realm, revoked installation, tamper | safety hold; stop affected actor/class | generic denial, no realm leakage, no durable receipt |
| `TRANSIENT_NETWORK` | timeout, reset, DNS/route, response loss | bounded retry of exact batch; ambiguity rules | idempotent receipt/status behavior |
| `AMBIGUOUS_CUSTODY` | server may have committed but response lost | preserve exact body and batch ID; replay/status query | equivalent matching receipt or authoritative no-custody state |
| `TRANSIENT_DATABASE` | timeout, deadlock victim, unavailable primary | bounded server retry/backpressure; endpoint ambiguity | no premature receipt or duplicate effect |
| `POISON_DATA` | schema-valid but semantic failure, deterministic transformer error | send predeclared T1 poison; no actor-side mutation | bounded attempts, quarantine, healthy work continues |
| `RESOURCE_PRESSURE` | disk/log full, pool exhaustion, backlog threshold | continue offered profile until stop rule; record containment | backpressure, no silent loss, priority recovery path |
| `RESTORE_RECOVERY` | database restart, restored snapshot, redo lag | preserve actors and replay exact ambiguous/unreceipted work | acknowledged data remains; readiness withheld until reconciliation |
| `UNKNOWN` | unclassified state | fail the gate and retain capsule | fail closed; no infinite retry or generic success |

## 5.12 Run evidence manifest

```json
{
  "contract": "uam.capacity.evidence-manifest",
  "version": "1.0.0",
  "runId": "019d0000-0000-7000-8000-000000000001",
  "scenarioDigest": "sha-256:fictional",
  "compiledPlanDigest": "sha-256:fictional",
  "sourceTreeDigest": "sha-256:fictional",
  "applicationImageDigest": "sha-256:fictional",
  "contractBundleDigest": "sha-256:fictional",
  "agentBuildDigests": ["sha-256:fictional"],
  "databaseEngine": "POSTGRESQL",
  "databaseVersion": "18.4",
  "databaseConfigurationDigest": "sha-256:fictional",
  "infrastructureManifestDigest": "sha-256:fictional",
  "faultScheduleDigest": "sha-256:fictional",
  "queryCorpusDigest": "sha-256:fictional",
  "truthLedgerDigest": "sha-256:fictional",
  "measurementRootDigest": "sha-256:fictional",
  "firstFailureCapsules": [],
  "cleanupReceiptDigest": "sha-256:fictional",
  "humanDecisionRefs": ["HD17-SLO-PENDING"],
  "result": "NOT_EVALUATED"
}
```

A run without exact source, application, contract, engine, configuration, infrastructure, scenario, fault, truth, and cleanup evidence cannot be compared or used for a capacity decision.

---

# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility rules

## 6.1 Simulator run lifecycle

```text
DRAFT_SCENARIO
  -> STRUCTURALLY_VALIDATED
  -> CLASSIFICATION_AND_AUTHORITY_VALIDATED
  -> COMPILED_PLAN
  -> ENVIRONMENT_INVENTORIED
  -> GENERATOR_SELF_TESTED
  -> SUT_READY_AND_EMPTY_OR_BASELINE_LOADED
  -> WARMUP
  -> ACTIVE_PHASES
  -> CONTROLLED_DRAIN
  -> RECONCILIATION
  -> CLEANUP
  -> EVIDENCE_SEALED
  -> GATE_EVALUATED

Any invariant, canary, cross-realm, generator, evidence, or cleanup failure
  -> FAILED_PRESERVE_FIRST_CAPSULE
```

The environment is never reused as a clean baseline without a verified reset/rebuild and evidence that old rows, credentials, agents, faults, and metrics are absent.

## 6.2 Logical device lifecycle

```text
PROVISIONED_T1
  -> IDENTITY_ACTIVE
  -> POLICY_ACTIVE
  -> ONLINE_IDLE
      -> GENERATING
      -> OFFLINE_GENERATING
      -> DISABLED_NO_COLLECTION
      -> SAFETY_HOLD

OFFLINE_GENERATING
  -> LOCAL_BACKLOG
  -> RECONNECT_JITTER
  -> ONLINE_DRAINING
  -> ONLINE_IDLE

Any active state
  -> ROLLING_VERSION_N_MINUS_1 | N | N_PLUS_1_CANDIDATE
  -> DECOMMISSIONED_TEST
```

An actor cannot upload before identity and policy are active. Identity, policy, compatibility, or kill failure stops new work but does not delete already sealed unacknowledged batches.

## 6.3 Event and batch lifecycle

```text
SYNTHETIC_EVENT_CREATED
  -> LOCAL_DURABLE_EFFECT_REPRESENTED
  -> BATCH_BUILDING
  -> SEALED_EXACT_BYTES
  -> ATTEMPT_PREPARED
  -> SENT_OR_NOT_KNOWN
       -> DEFINITE_NO_CUSTODY -> RETRY_SAME_BATCH
       -> AMBIGUOUS -> STATUS_OR_REPLAY_SAME_BATCH
       -> MATCHING_DURABLE_RECEIPT -> RECEIPTED
       -> SECURITY_OR_CONTRACT_HOLD
  -> CLEANUP_ELIGIBLE_T1_ONLY
  -> TOMBSTONE/TRUTH_RETAINED
```

Simulator actors preserve exact body bytes and stable identity after `SEALED_EXACT_BYTES`. Recompression, event reordering, or new batch identity after ambiguity is a test failure.

## 6.4 Server receipt transaction

Logical transaction:

```text
BEGIN
  authenticate context already established outside body
  validate hard request bounds and contract framing
  insert or find inbox row by realm + installation + batch identity
  verify same identity has same content and wire digest
  persist exact custody payload/evidence within declared failure domain
  persist receipt ID/state/failure-domain class
COMMIT DURABLY
return/replay matching receipt
```

A duplicate with identical identity/digests returns the existing receipt. Same identity with different bytes is a security/identity conflict and cannot overwrite the prior row. No worker validation or materialization is required before receipt, but hard request bounds and identity/digest checks occur before accepting custody.

## 6.5 Inbox worker lifecycle

```text
DURABLY_RECEIVED
  -> AVAILABLE
  -> LEASED(worker, token, until)
      -> VALIDATED
          -> MATERIALIZATION_AVAILABLE
          -> QUARANTINED
      -> TRANSIENT_RETRY_AVAILABLE
      -> LEASE_EXPIRED_AVAILABLE
      -> SAFETY_HOLD

MATERIALIZATION_AVAILABLE
  -> LEASED
  -> MATERIALIZED
  -> VISIBLE / INTEGRATION_AVAILABLE
```

Rules:

- Leases are renewable only under bounded policy and matching ownership.
- A crash before worker commit leaves work available after expiry.
- A crash after commit but before worker acknowledgement returns the already committed state.
- Poison attempts are bounded and then quarantined with finite reason code.
- Healthy work bypasses quarantined or repeatedly failing work.
- A worker cannot read or mutate another realm through a payload claim.

## 6.6 Policy fanout lifecycle

```text
POLICY_CANDIDATE_PUBLISHED
  -> SERVER_CONSUMERS_READY
  -> CONTROL_DISTRIBUTION_STARTED
  -> ENDPOINT_CLASSES_APPLY_WITH_DETERMINISTIC_JITTER
  -> ACK/STATUS AGGREGATED
  -> TARGET_COVERAGE OR HOLD

Emergency narrowing
  -> stop new permits/work
  -> outstanding incompatible pages/batches handled by predecessor rules
```

The fanout scenario measures control-plane read/write pressure separately from activity ingestion. Policy publication cannot invalidate already durably received custody or rewrite events. A tenant policy never broadens the product ceiling.

## 6.7 Poison lifecycle

```text
VALID_CONTRACT_T1_POISON
  -> DURABLY_RECEIVED
  -> LEASED
  -> DETERMINISTIC_FAILURE(reason)
  -> BOUNDED_RETRY if classified transient
  -> QUARANTINED_FINAL if permanent/budget exhausted
  -> OPERATOR/SYNTHETIC_RECOVERY TEST
```

Poison state contains only finite safe codes and digests. Arbitrary exception strings or source values are absent. Requeue after operator correction uses an explicit higher recovery action and preserves audit/evidence.

## 6.8 Restore lifecycle

```text
RUNNING
  -> BACKUP_POINT_IDENTIFIED
  -> FAILURE/LOSS INJECTED
  -> INGESTION_STOPPED OR ROUTED PER TEST
  -> RESTORE_TO_ISOLATED_TARGET
  -> ENGINE_RECOVERY COMPLETE
  -> SCHEMA/IDENTITY/REALM/RECEIPT INTEGRITY CHECK
  -> ACKNOWLEDGED SET RECONCILED
  -> UNACKNOWLEDGED/AMBIGUOUS REPLAY
  -> MATERIALIZATION/QUARANTINE RECONCILED
  -> READINESS HELD UNTIL GATES PASS
  -> CONTROLLED RESUME
```

The test never marks readiness merely because the database starts. Acknowledged batches, receipts, final effects, deletion/tombstone state where in scope, lease state, and realm isolation must reconcile first.

## 6.9 Rolling-update lifecycle

```text
CONSUMER N SUPPORTS CONTRACT V AND V+1
  -> DEPLOY SERVER N
  -> ENABLE MIXED ENDPOINT N-1/N TEST
  -> DEPLOY ENDPOINT N RING
  -> PROBATION
  -> WIDEN
  -> RETIRE N-1 ONLY AFTER INVENTORY/ROLLBACK/HUMAN WINDOW
```

Capacity tests MUST include mixed endpoint versions, schema/contract compatibility, old/new compression where applicable, and rollback. A new producer cannot send a version before every required consumer supports it. One semantic path is active for a given contract/version; hidden dual interpretation is prohibited.

## 6.10 Compatibility rules

A result is valid only for the exact tuple:

```text
application image and configuration digest
contract/serializer/compressor/client versions
database engine/build/edition/configuration
schema and migration digest
operating system/container/runtime architecture
hardware/service tier and storage class
network/TLS/load-balancer topology
worker count and lease algorithm
query/maintenance/backup mix
historical loaded volume and retention assumptions
scenario/fault/seed/duration
load-agent build and capacity proof
```

Changing a load-bearing tuple element expires or narrows the evidence. Nearby database patches may be tested through an explicit equivalence/sentinel lane; version proximity alone does not inherit capacity.

## 6.11 Fair worker scheduling transaction

One acceptable logical algorithm is weighted deficit round robin over bounded realm classes:

```text
for each scheduling epoch:
  add configured quantum to each active class deficit
  select classes with available work and positive deficit
  lease bounded items using engine-specific atomic skip-locked/read-past pattern
  decrement deficit by normalized item cost
  cap concurrent leases and oldest-age priority per class
```

The exact algorithm is provisional until measured. The implementation MUST preserve:

- atomic one-owner lease;
- bounded database scans;
- oldest-work progress;
- no starvation;
- stable performance as empty and saturated class counts change;
- safe behavior when statistics are stale or a large poisoned backlog precedes eligible work.

## 6.12 Backpressure lifecycle

```text
NORMAL
  -> EARLY_WARNING
  -> REDUCE OPTIONAL QUERY/INTEGRATION WORK
  -> LIMIT NEW WORKER CONCURRENCY OR INGRESS BY APPROVED POLICY
  -> ENDPOINT RETRIES WITH BOUNDED JITTER
  -> CAPACITY_HOLD / COLLECTION PAUSE SIGNAL WHERE AUTHORIZED
  -> RECOVERY_DRAIN
  -> NORMAL_AFTER_HYSTERESIS
```

Backpressure cannot acknowledge data that is not durable and cannot silently drop accepted/unacknowledged work. Retry advice is bounded and versioned; correlated clients include deterministic per-device jitter and server hints only where the contract authorizes them.

---

# 7. Security/privacy threat and failure register

| ID | Trigger / threat | Detection | Containment | Recovery | Cleanup | Owner function | Test | Residual risk |
|---|---|---|---|---|---|---|---|---|
| T17-01 | Generator saturates and offered load falls while SUT slows | offered/started/dropped counters; agent CPU/socket/GC/clock gates | invalidate claimed load range; add agents or reduce only after preserving failure | rerun with generator headroom and same SUT plan | destroy stale measurements; retain first failure | Capacity Test Architecture | generator self-saturation and deliberate CPU/network cap | Hidden runtime/library bottlenecks can remain. |
| T17-02 | Closed-loop pacing masks overload | compare independent planned arrivals with actual starts | authoritative gate uses open-arrival lane | rerun scenario with sufficient workers/VUs | none beyond evidence | Capacity Test Architecture | inject fixed SUT delay and prove offered rate remains planned | Very high latency may exhaust finite generator resources; drops must be visible. |
| T17-03 | Scenario nondeterminism or partition-dependent random streams | repeat compile/run hashes under different agent counts/order | stop run; no comparison | fix domain-separated PRNG and canonical ordering | remove invalid compiled plans | Verification Architecture | same seed on 1/2/8 agents; byte-identical device histories | OS/network timing remains nondeterministic; logical plan must still match. |
| T17-04 | Simulator codec/retry differs from production | golden wire bytes, assembly digest, Windows cohort differential | block scale run | update adapter or production contract; rerun all vectors | remove stale test artifacts | Contract Authority | byte, digest, compression, retry, receipt differential | Shared production library can contain a common defect; independent protocol vectors remain needed. |
| T17-05 | Test credential or fault authority escapes lab | artifact/SBOM scan, egress, trust-store and secret canaries | revoke lab CA/credentials; stop environment | rebuild isolated environment and rotate all test authority | remove trust, keys, containers, rules, agents | Lab Security / Identity | production-artifact absence and cleanup diff | Compromised host administrators remain outside application containment. |
| T17-06 | Payload/body realm claim crosses isolation | authenticated-context vs hostile body/header negatives; DB key audit | reject and security hold | correct middleware/cache/query; purge only T1 invalid run | remove T1 hostile rows if any after evidence | Server Identity / Data Security | same IDs across realms, wrong body/header/cert | Misconfigured downstream analytics can reintroduce cross-realm joins. |
| T17-07 | Receipt issued before durable commit | server failpoint after response construction/before commit; DB truth | stop ingress build | fix transaction boundary; rerun all response-loss tests | revert lab DB | Ingestion Reliability | kill/restart at every receipt boundary | Storage may falsely report durability; later platform/restore evidence still matters. |
| T17-08 | Response lost after commit causes new batch or duplicate effect | exact body/batch ledger and central uniqueness reconciliation | hold affected actor/build | replay/status same identity; correct client/server | retain conflict capsule; reset T1 run | Endpoint Transport / Ingestion | commit-then-drop response at scale | Rare protocol intermediaries may create novel ambiguity. |
| T17-09 | Retry storm amplifies outage | attempt distribution, retry bytes, handshake rate, synchronized start histogram | server hint/endpoint jitter where authorized; ingress protection; site kill | drain with bounded retry and fair scheduling | clear fault and verify no stale timers | Endpoint Transport / SRE | site outage and reconnect with clock-aligned devices | Real estate may have more correlated clocks/network recovery. |
| T17-10 | Poison item captures workers/DB CPU | per-poison attempt, queue age, query plan, healthy-class lag | bounded attempts, quarantine, per-class concurrency | deploy fix; explicit requeue of T1 poison | purge test quarantine after evidence | Ingestion Processing | poison at head, middle, multiple realms, varying ratios | Unknown poison shapes can still cause expensive parsing before classification. |
| T17-11 | Lease query scans huge backlog or changes plan | plan fingerprint, rows/pages read, CPU, latency, stats state | concurrency cap, alternative indexed predicate, safety hold | refresh/statistics or deploy reviewed query/index | remove temporary test indexes unless part of manifest | Database Reliability | saturated backlog + stale stats + many workers | Optimizer changes can recur after upgrades/data-shape drift. |
| T17-12 | One large realm starves smaller realms | per-class oldest age, completion share, starvation timer | fairness scheduler and per-class bounds | drain oldest/starved class under approved policy | none | Ingestion Reliability | 90/9/1 population mix plus reconnect/poison | Weights are a human/service policy and may be disputed. |
| T17-13 | Cross-realm cache, uniqueness, or worker bug | duplicate fictional IDs across realms, negative queries, effect ledger | stop build; quarantine run | correct key prefixes and invalidate caches | reset T1 DB/cache | Data Security | realm collision campaign under load | Third-party observability/BI tooling can still mis-scope data. |
| T17-14 | Database disk/log fills | disk/log trend, reserve thresholds, failed writes, checkpoint/backup state | stop new acceptance before unsafe state where contract permits; preserve accepted work | add capacity or drain/backup after root cause; no data deletion guess | remove filler and verify files/log normalize | Database Reliability / SRE | data volume fill during ingest, receipt, worker, restore | Cloud/provider quotas or storage throttling can be less predictable. |
| T17-15 | WAL/log, replica, or archive backlog grows unbounded | bytes/time, lag, archive failure, recovery ETA | rate limit optional work; capacity hold | restore archive path, scale or tune after evidence | clean T1 archives/snapshots | Database Reliability | 72h soak + checkpoint/backup faults | Long-term bloat may exceed 72h observation. |
| T17-16 | Backup or restore appears successful but acknowledged rows are missing | receipt/batch/effect truth reconciliation, integrity checks | readiness remains false | restore another verified point and replay unacknowledged exact batches | destroy failed restore target after capsule | Data Reliability / Incident | backup during load; corrupt/missing backup; restore then replay | Underlying backup service can have correlated failure not represented in lab. |
| T17-17 | Restore exposes stale/deleted state before ready | readiness gate, tombstone/deletion state where fixture covers it | isolate restored target; no user/API traffic | complete reconciliation/deletion reapplication | destroy invalid target | Data Reliability / Records | synthetic tombstone and visibility negatives | Full deletion/legal-hold design remains later gate. |
| T17-18 | Policy fanout overwhelms DB/control plane | fanout queue, cache miss, control API/database load, ingest tail | jitter, bounded fanout, separate pools/priority | resume waves; keep last valid policy per predecessor rules | remove T1 policy artifacts | Control Plane / SRE | 6k/12k simultaneous and jittered fanout during backlog | Real network/offline distributions may delay convergence. |
| T17-19 | Rolling update creates incompatible mixed traffic | contract-version outcomes, old/new matrix, canary errors | stop candidate ring; keep current/previous support | rollback higher release sequence; redeploy consumer first | remove candidate test payloads | Release / Contract Authority | N-1/N/N+1 mixed fleet and server rollback | Long-offline endpoints can exceed tested window. |
| T17-20 | Slow DB causes connection/thread pool collapse | pool wait, queued requests, thread-pool delay, timeouts, memory | bounded pools/queues; load shedding before resource exhaustion without false receipt | recover DB, drain backlog under fairness | reset fault and verify pool state | Application Reliability / Database | latency, IOPS, CPU, lock, and connection faults | Multiple slow dependencies may compound nonlinearly. |
| T17-21 | Metrics/logs contain raw or high-cardinality values | schema/analyzer, canary, theoretical/actual series count | stop telemetry export and run; privacy incident process | remove field at source; rebuild; rerun all-sink tests | delete T1 telemetry per manifest | Observability / Privacy | dynamic-ID mutation and encoded canaries at 12k | Opaque vendor agents may capture data outside application control. |
| T17-22 | Exact IDs in general telemetry create linkability | field catalogue and backend schema scan | block export; use run ordinals/buckets | migrate/delete T1 evidence and update schema | verify backend deletion | Privacy / Observability | intentionally add UUID labels and expect gate failure | Restricted truth ledger still contains linkable fictional IDs; access must remain narrow. |
| T17-23 | Fault controller accepts arbitrary command/SQL or reaches production | static schema, network policy, binary manifest, auth audit | revoke controller and isolate environment | rebuild with finite fault catalogue | remove rules/accounts/tokens | Lab Security | hostile scenario file and network reachability test | Infrastructure admin remains powerful by design. |
| T17-24 | Test framework/dependency compromised | exact tag/binary/source, SBOM/provenance, egress, checksum, canaries | freeze runs and promotion | update/remove tool and rerun affected gates | destroy images/caches | Supply Chain Security | substituted load/fault binary and mutable tag | Upstream signed release does not guarantee absence of malicious code. |
| T17-25 | Generator clock skew corrupts latency/reconnect shape | monotonic vs UTC comparison, agent sync error, planned/actual tick | exclude agent/run; rely on monotonic durations | repair time source; rerun | none | Lab Operations | skew/step/rollback injection | Cross-host one-way latency still needs careful clock methodology. |
| T17-26 | Query workload is unrepresentative or absent | query corpus digest, coverage/class mix, loaded retention volume | result labelled write-only diagnostic, not capacity | obtain approved synthetic corpus/aggregates and rerun | reset DB | Product Data / Capacity | empty, hot-cache, cold-cache and skewed selectivity negatives | Future product/report changes alter query mix. |
| T17-27 | Cost comparison omits labour/license/backup/observability | signed cost-input register and sensitivity report | no cost-based decision | complete inputs with Finance/Operations/Procurement | archive stale estimates | Product/Finance/Operations | deliberately omit cost categories and expect gate failure | Incident probability/cost is uncertain and value-laden. |
| T17-28 | Broker prototype creates dual custody or split-brain replay | end-to-end batch/receipt ledger across relational and broker states | broker remains off; isolate prototype | redesign to one authoritative custody boundary | delete T1 broker topics/credentials | Architecture / Data Reliability | crash at each relational↔broker handoff | Managed broker internals/failure domain may be opaque. |
| T17-29 | Broker benchmark compares a different workload/configuration | evidence diff and benchmark-contract validator | comparison invalid | rerun identical application semantics, faults, retention, and queries | reset environments | Architecture / Capacity | mutation test changes one side only | Some broker-specific capabilities cannot be perfectly normalized; disclose them. |
| T17-30 | Database comparison is biased by hidden tuning/hardware difference | infrastructure/config digests, resource normalization, operator log | invalidate comparison | reproduce on matched classes or explain controlled difference | reset both environments | Database Architecture | hidden parameter/index/hardware mutation | Engine-specific optimal designs may require a second fair “best supported design” round. |
| T17-31 | 72h soak passes but periodic weekly/monthly maintenance fails | scheduled maintenance coverage and long-horizon model | no long-term production claim | run accelerated/extended maintenance scenarios | cleanup | Database/SRE | statistics, index, backup, retention boundary during soak | Some calendar/vendor maintenance cannot be accelerated faithfully. |
| T17-32 | Windows fidelity cohort diverges from scale agents | same fixture wire/state/resource differential | stop scale claim | expand/fix cohort or agent adapter | remove invalid evidence | Endpoint Compatibility / Capacity | cross-platform and Windows side-by-side run | Small cohort may miss rare Windows scheduling/network tails. |
| T17-33 | Support/on-call cannot interpret safe evidence | blind incident exercise | capacity claim cannot become operationally supported | add finite safe signals/runbook or narrow scope | remove exercise artifacts | Support Operations / SRE | blind reconnect/poison/restore diagnosis | Real incidents can combine failures not in exercise. |
| T17-34 | Accessibility/regression test traffic is dropped under load | synthetic control/API/UI accessibility probes and deterministic response checks | keep control-plane reserve; stop release on functional regression | scale/fix prioritization; rerun | reset fixtures | Product Quality / Accessibility | concurrent API/control probes during storm | Full portal accessibility remains separate UI technology work. |
| T17-35 | Cleanup leaves data, credentials, agents, topics, rules, or faults | before/after manifest, trust/key/topic/DB/resource diff | gate fails; quarantine environment | manifest-scoped cleanup or full environment destruction | signed cleanup receipt | Lab Operations / Security | deliberate interrupted cleanup | Cloud control-plane eventual consistency may delay proof; wait/recheck explicitly. |

## 7.1 Mandatory incident/runbook set

Before the capacity gate can close, exercise at least:

1. generator saturation or clock corruption;
2. receipt-before-commit or response-loss ambiguity;
3. reconnect/retry storm containment;
4. poison/quarantine and healthy-work fairness;
5. database slow, unavailable, deadlock, and disk/log-full behavior;
6. WAL/log/archive/replica backlog;
7. backup failure and restore/reconciliation;
8. policy fanout overload and emergency narrowing;
9. rolling-version incompatibility and rollback;
10. cross-realm acceptance or cache leak;
11. observability canary/cardinality escape;
12. load/fault-tool supply-chain compromise;
13. broker prototype split custody, if the spike is ever authorized;
14. complete lab teardown and credential revocation.

Each runbook names trigger, authority, containment, evidence, recovery, cleanup, re-enable condition, neighboring realms/scenarios protected, and required reruns.

---

# 8. Detailed test matrix and smallest falsifying prototypes

## 8.1 Test-lane hierarchy

| Lane | Purpose | Scale | Authority |
|---|---|---:|---|
| L0 — pure model | Formula, state-machine, deterministic plan, fairness, retry, receipt, and recovery checking | millions of generated histories possible | Proves model/checker consistency only. |
| L1 — in-process contract | Production serializer/compressor/client adapter, strict schemas, fake transport, exact bytes | 1–1,000 devices | Proves contract reuse and deterministic identity; not network/database capacity. |
| L2 — single-node integration | Real application + one database + local agents/faults | 10–1,000 devices | Finds transaction, lease, poison, and query defects cheaply. |
| L3 — distributed synthetic fleet | Multiple load agents + production ingress + database | 6,000 and 12,000 logical devices | Primary throughput/backlog/recovery evidence for the exact tuple. |
| L4 — Windows fidelity cohort | Exact Windows endpoint transport and lab identity on disposable Windows machines | **ESTIMATE:** 12–100 installations, selected by behavior class | Proves Windows/client equivalence, not fleet-scale server capacity by itself. |
| L5 — restore/operations | Backup, restore, restart, failover, upgrade, maintenance and runbooks | same loaded volume as L3 | Proves recovery and operational fitness for exact objective. |
| L6 — broker spike | Relational baseline plus one authorized broker candidate | minimum scale that crossed trigger, then 6k/12k if promising | Only after ADR trigger; cannot silently replace receipt boundary. |

Every load-bearing simulated fault has a real-boundary companion where safe. A pure model or container-only result cannot prove Windows, database durability, or restore.

## 8.2 Bootstrap scenario parameters

The values below are **ESTIMATE** defaults for reproducible laboratory work. They are intentionally replaceable and are not production volumes or SLOs.

| Parameter | Temporary lab default | Why | Replacement evidence |
|---|---:|---|---|
| Fleet A | 6,000 installations | accepted minimum scale target | approved managed/active fleet and growth decision |
| Fleet B | 12,000 installations | 2× sensitivity/headroom and future-growth stress | human growth horizon and measured capacity curve |
| Soak | 72 hours | required prompt gate; catches leak/log/bloat/maintenance behavior | longer periodic-maintenance evidence if required |
| Realm mix | 30 small × 50, 10 medium × 150, 3 large × 1,000 plus remainder balanced | creates skew/fairness cases with fictional classes | approved aggregate realm-size histogram |
| Active fraction | time-varying 20–80% | exercises sparse/peak batch occupancy | metadata-only active distribution |
| Sessions | 0/1/2/3 bounded discrete | endpoint architecture allows multiple eligible sessions | approved aggregate session counts |
| Event rate | bounded distribution with explicit p50/p95/p99/max | prevents average-only sizing | approved metadata-only counts per interval |
| Batch limits | accepted contract limits or current provisional candidate | exact bytes must use production code | contract/endpoint measurement gate |
| Reconnect jitter | 10 minutes for storm default | avoids impossible zero-time synchronized start while preserving correlation | pilot/site recovery distribution |
| Backlog windows | 2h, 24h, 72h | short/site/multi-day stress | maximum outage human decision and safe cohort evidence |
| Poison share | 0, 0.01%, 0.1%, 1% bounded phases | explores nonlinear quarantine cost | failure metadata; never raw content |
| Headroom hypothesis | 50% over selected peak and positive recovery headroom | conservative lab screen, not SLO | human objective and capacity curve |

## 8.3 Scenario catalogue

### S17-01 — steady mixed fleet

| Field | Specification |
|---|---|
| Classification | **CLI EXPERIMENT** |
| Shape | 6,000 devices for warmup plus 2–8 hours steady; active/session/event distributions vary by deterministic time-of-day class; normal retry background. |
| Purpose | Establish baseline throughput, batch occupancy, compression, receipt tails, worker/query contention, storage/WAL rate, and generator margin. |
| Instrumentation | all SLIs in section 5.10; generator resource and offered-load fidelity; DB plans/stats; exact effect ledger. |
| Fairness | all realm classes active; configured weights; no poison. |
| Pass | zero primary invariant failures; no generator drops; planned arrival error within temporary lab budget; stable backlog and resources; human-bound tail/headroom hypotheses pass. |
| Fail | backlog grows in a steady interval, log/archive grows without recovery, query tails diverge, starvation, duplicate/missing effect, receipt conflict, generator saturation, or cardinality escape. |
| Evidence | `s17-01-steady/{plan,offered-load,agent,ingress,db,workers,queries,truth,cost,cleanup}` |
| Cleanup | stop load, drain by plan, reconcile, snapshot sizes, destroy/revert environment or restore baseline. |

### S17-02 — morning start wave

| Field | Specification |
|---|---|
| Shape | **ESTIMATE:** 60% of enabled devices become active across 20 minutes with deterministic site/realm correlation; event generation begins before some first upload timers. |
| Purpose | Test session/event/batch ramp, new connections/TLS, sparse-to-full batches, policy/config reads, and worker autoscaling without a prebuilt backlog. |
| Fairness | at least one large and several small realms start together. |
| Pass | offered wave maintained; no synchronized retry amplification; custody and materialization recover to steady lag; no small-realm starvation. |
| Duration | 30m warmup, 20m wave, 2h stabilization. |
| Stop | unauthorized/cross-realm, receipt invariant, generator overload, or backlog not declining after wave under selected capacity. |

### S17-03 — fleet reconnect storm

| Field | Specification |
|---|---|
| Shape | Generate 2h and 24h local backlogs offline; reconnect 6k, then 12k devices over deterministic 10m jitter; preserve exact sealed batch bytes and per-device retry state. |
| Purpose | Measure connection/TLS rate, request burst, duplicate/ambiguous replay, central backlog, fairness, net drain, and recovery time. |
| Fault variants | 0%, 1%, and **ESTIMATE** 5% response-loss ambiguity; one site has extra latency/reset. |
| Pass | `μ_safe > λ_new`; backlog and oldest age decline after burst; exact replay yields one receipt/effect; no starvation; recovery target/headroom hypothesis passes. |
| Fail | backlog equilibrium/growth, new batch minted after ambiguity, DB/pool collapse, retry synchronization, or one class remains starved. |
| Duration | backlog pre-generation simulated; 3–12h wall time depending on drain target. |

### S17-04 — site outage and partial recovery

| Field | Specification |
|---|---|
| Shape | One or more fictional site classes containing 5%, 25%, and 50% of fleet lose network for 2h; remaining fleet stays steady; sites reconnect independently and then simultaneously. |
| Purpose | Test containment, route/load-balancer behavior, retry jitter, localized fairness, and whether healthy sites remain within tails. |
| Pass | unaffected sites stay within human hypothesis; failed site retains exact backlog; recovery does not starve unaffected realms; no network-location identity change. |
| Faults | DNS failure, TCP reset, TLS handshake failure, response loss, bandwidth/latency, route restoration. |
| Cleanup | remove proxy/toxics/routes, verify no persistent direct-bypass rule or credential residue. |

### S17-05 — multi-day backlog

| Field | Specification |
|---|---|
| Shape | 10%, 50%, and 100% of 6k/12k devices accumulate 72h of T1 events; backlog age/size distributions are retained per device; new events continue during drain. |
| Purpose | Prove endpoint/server limits, storage, batch replay, recovery equation, long-tail fairness, query/maintenance coexistence, and capacity to catch up. |
| Pass | no silent endpoint/server loss; accepted data remains; `μ_safe` exceeds new arrivals plus selected recovery demand; oldest age declines monotonically outside known faults. |
| Fail | local quota causes undocumented drop, server disk/log exhaustion, recovery cannot converge, or a recent small realm permanently stays behind old large-realm backlog. |
| Duration | up to the selected recovery objective plus 2h post-recovery observation. |

### S17-06 — policy fanout during load

| Field | Specification |
|---|---|
| Shape | Publish product/tenant narrowing artifacts to 6k/12k devices while steady or reconnect traffic runs; compare synchronized versus 30m deterministic jitter. |
| Purpose | Measure control-plane, cache, database, outbound fanout, endpoint status, and ingestion interference. |
| Variants | ordinary compatible update; unsupported candidate; wrong realm; lower sequence; emergency narrowing/kill. |
| Pass | invalid artifacts never authorize; last valid behavior follows predecessor rules; emergency narrowing stops new work within human/lab bound; ingest custody unaffected except measured resource contention. |
| Fail | tenant broadening, wrong-realm activation, mixed policy within one page/batch where prohibited, or control work starves custody. |

### S17-07 — poison and quarantine

| Field | Specification |
|---|---|
| Shape | Inject strict T1 poison classes at 0.01%, 0.1%, and 1%; cluster poison at queue head, random positions, and one realm; include expensive-but-bounded payload sizes. |
| Purpose | Validate bounded attempts, lease expiry, quarantine, plan/index behavior, healthy throughput, and operator recovery. |
| Pass | permanent poison reaches quarantine within bounded attempts; healthy work continues; no infinite retry; safe finite reason only; requeue after synthetic fix creates no duplicate final effect. |
| Fail | poison captures all workers/CPU, grows attempts indefinitely, blocks a realm, leaks exception/payload, or is silently discarded before custody. |

### S17-08 — slow database and contention

| Field | Specification |
|---|---|
| Shape | Introduce storage latency/IOPS limits, CPU pressure, lock contention, long transaction, connection exhaustion, stale statistics, and a bad plan while offered load remains fixed. |
| Purpose | Find queueing collapse, pool/thread behavior, lease correctness, backpressure, timeout/ambiguity, and recovery hysteresis. |
| Pass | no premature receipt; bounded queues/pools; explicit backpressure/holds; stable retry identity; recovery drains after fault; evidence classifies bottleneck. |
| Fail | generator silently slows, receipt precedes commit, memory/threads/connections grow without bound, or stale leases double-process. |

### S17-09 — database restart/failover and response ambiguity

| Field | Specification |
|---|---|
| Shape | Kill/restart primary/application at before-commit, after-commit-before-response, worker lease, worker commit, and checkpoint/maintenance boundaries. |
| Purpose | Prove custody ambiguity, exact replay, lease recovery, one effect, and connection/pool recovery under load. |
| Pass | prior or complete state only; matching receipt replay; no changed ID/body; workers recover leases; no cross-realm error. |
| Fail | accepted-but-missing row, duplicate effect, false no-custody, or unrecoverable pool/lease state. |

### S17-10 — backup and restore under load

| Field | Specification |
|---|---|
| Shape | Run backup during steady and reconnect phases; restore selected points to isolated targets; corrupt/omit one backup in negative lane; replay endpoint ambiguous/unreceipted batches. |
| Purpose | Measure backup interference, recovery rate, RPO evidence, acknowledged-set preservation, and readiness reconciliation. |
| Pass | valid backup restores; acknowledged receipt/batch/effect set reconciles; no readiness before checks; new arrivals/replay produce one effect; query and maintenance recover. |
| Fail | acknowledged item absent, deleted fixture visible before ready, receipt conflict, or restore only works with undocumented manual surgery. |
| Duration | full backup + restore + catch-up + 2h stable observation. |

### S17-11 — rolling update and mixed contracts

| Field | Specification |
|---|---|
| Shape | Fleet fractions 90/10, 50/50, and 10/90 on endpoint N-1/N; server consumer N then N+1; candidate rollback; mixed serializer/compression only where contract permits. |
| Purpose | Capacity and compatibility during rollout, cache warming, connection churn, schema migration, and rollback. |
| Pass | consumer-first; unsupported producer blocked; no duplicate interpretation; N-1 remains within declared window; rollback preserves custody/effects. |
| Fail | old endpoint rejected unexpectedly, candidate traffic corrupts inbox, one-way migration blocks rollback, or version labels cause cardinality explosion. |

### S17-12 — query and reporting contention

| Field | Specification |
|---|---|
| Shape | Synthetic API/report queries with skewed realm/time windows, warm/cold cache, pagination, aggregate refresh, and bounded export while ingest/recovery runs. |
| Purpose | Select engine/index/partition design under total workload, not ingest only. |
| Pass | custody invariant remains; query SLO hypothesis and freshness class pass; plans stable or explainable; no unbounded result/scan. |
| Fail | portal query starves receipt/workers, scan grows unexpectedly, wrong realm result, or spill/temp/log destabilizes recovery. |

### S17-13 — 72-hour soak

| Field | Specification |
|---|---|
| Shape | 6k steady with daily morning wave, one site outage/recovery, policy fanout, periodic poison, backup, maintenance, and a rolling update; optional 12k soak after 6k passes. |
| Purpose | Detect leaks, bloat, log/archive growth, timer/retry drift, plan/statistics changes, connection churn, and evidence/metric cardinality growth. |
| Pass | zero primary invariant/canary/realm/cleanup failures; stable resource trend after expected steps; bounded storage/log/index growth matching model; no unexplained latency drift. |
| Fail | monotonic memory/handle/connection/series/backlog growth, log retention leak, increasing retry/lease expiry, or missed maintenance/backup recovery. |
| Evidence | interval summaries plus raw safe engine stats retained in restricted lab; first deviation capsule. |

### S17-14 — broker break-even spike, conditional

| Field | Specification |
|---|---|
| Entry condition | One or more triggers in section 9.4 crossed and ADR-17-011 authorizes candidate/product/profile. |
| Shape | Same exact device corpus, offered arrivals, faults, query mix, retention, restore, and final-effect reconciliation as relational baseline. |
| Purpose | Test whether the broker removes the measured bottleneck or failure-domain gap at acceptable total cost/complexity. |
| Pass | trigger is materially improved; one custody boundary is explicit; no dual-write loss/duplicate; restore/replay/fairness/security/runbooks pass; cost/skills accepted. |
| Fail | only headline throughput improves, relational bottleneck moves downstream, dual custody appears, cost/operations worsen, or receipt semantics weaken. |

## 8.4 Common setup and instrumentation matrix

| Area | Setup | Instrumentation | Mandatory evidence |
|---|---|---|---|
| Application | exact signed/content-addressed application image; production contract/client assemblies; no debug/fault path in production build | build/file/SBOM/provenance digests, startup inventory | application manifest and hook-absence report |
| PostgreSQL | exact supported release/build/config, isolated storage, loaded baseline volume | `pg_stat_*`, WAL bytes, plans, waits/locks, table/index sizes, logs by safe code | engine/config/schema/infrastructure manifests |
| SQL Server | exact SQL Server 2025 build/edition/config, matched resource class and baseline volume | Query Store/DMVs/Extended Events only with safe templates, log bytes, waits/locks, plans, sizes | engine/build/edition/license-use/config manifests |
| Load agents | clean immutable images/VMs, exact agent build, isolated test credentials | offered/started/completed, resources, clock, sockets, TLS, network | per-agent inventory and self-test |
| Windows cohort | exact endpoint transport build, disposable Windows tuples, test CA | client state, bytes/digests, TLS, retry, CPU/memory, cleanup | differential and environment evidence |
| Network faults | private Toxiproxy/custom hostile server or platform fault controls | exact toxic/fault timeline, bytes, connection outcomes | fault schedule and cleanup receipt |
| Truth | independent T1 oracle database/ledger | planned device/event/batch/attempt/receipt/effect states | root digest and reconciliation report |
| Observability | closed finite catalogue, no auto-capture of payload/URL/identity | theoretical/actual series, canary, export completeness | all-sink and cardinality report |
| Query corpus | strict fictional query templates and parameter distributions | offered/completed, result bound, plan/read/CPU/latency | query corpus digest and coverage |
| Backup/restore | exact engine-supported procedure and isolated restore target | duration, throughput, LSN/WAL/log point, integrity, reconciliation | backup/restore manifest and readiness report |

## 8.5 Pass/fail principles

Zero-tolerance failures:

```text
acknowledged batch missing after declared durability/restore claim
receipt emitted outside declared durable transaction
same stable event or batch produces more than one final business effect
same batch identity accepts different content/wire digest
cross-realm submit/read/mutate/delete or cache collision
forbidden activity/identity/secret value enters telemetry/evidence
silent loss of unacknowledged data
unbounded poison/retry/lease loop
unsupported/stale/downgraded release or contract executes
load generator reports achieved work without offered/dropped accounting
cleanup residue of credentials, test authority, faults, agents, data, or rules
```

Performance/capacity thresholds are human-bound variables. A run that has zero invariant failures but misses a temporary latency/headroom hypothesis is a valid failed capacity run, not a product correctness failure. A run with a primary invariant failure can never pass because average throughput is high.

## 8.6 Smallest falsifying prototypes

### P17-01 — production-wire and deterministic-partition prototype

**Claim.** The custom simulator can generate the exact production bytes/state transitions deterministically, independent of agent partitioning.

**Setup.** One strict T1 package; 100 fictional devices; production serializer/compressor/retry/receipt assemblies; fake transport with commit/response-loss cases; one, two, and eight agent partitions.

**Instrumentation.** Compiled-plan digest, per-device history digest, exact body/wire digest, attempt/receipt ledger, agent resource and random stream identities.

**Steps.** Compile twice; run each partitioning; reorder agent startup; inject response loss; replay; compare Windows cohort for a 10-device subset.

**Pass.** Byte-identical compiled plan and per-device histories; exact production wire match; same batch/body after ambiguity; one effect; no partition-dependent random sequence.

**Fail.** Any identity/body/state divergence, production/test codec difference, or generator hidden drop.

**Evidence.** `p17-01/{plans,wire-vectors,partition-diffs,windows-diff,truth,cleanup}`.

**Duration.** **ESTIMATE:** under 30 minutes automated.

**Cleanup.** Revoke test credentials, delete fake transport state, verify no test trust/artifacts in production manifest.

### P17-02 — relational custody and leased-worker prototype

**Claim.** One relational database can atomically accept/replay batches and lease/process healthy and poison work without duplicate effects.

**Setup.** 1,000 devices; 1 million synthetic events or the smallest volume that reaches stable plans; PostgreSQL and SQL Server adapters; 1–64 workers; poison and response-loss faults.

**Steps.** Ramp offered uploads; replay 10% exact duplicates; inject same-ID/different-digest negatives; kill workers; expire leases; add poison; vary statistics and worker count.

**Pass.** Matching receipt replay; conflicts rejected; one effect; poison quarantined; healthy progress; bounded plans/scans; zero realm leakage.

**Fail.** Any premature receipt, duplicate effect, worker starvation, unbounded query, or semantic difference between adapters.

**Duration.** **ESTIMATE:** 1–3 hours per engine.

### P17-03 — 6,000-device reconnect and recovery prototype

**Claim.** The candidate relational deployment can accept and drain a 24h 6k-device backlog while serving continuing arrivals and queries with temporary 50% headroom hypothesis.

**Setup.** Production application build; 6k stateful actors; 24h simulated backlog; 10m reconnect jitter; synthetic query mix; backup disabled for first run then enabled; matched engine environments.

**Steps.** Verify generator capacity at 2× planned offered rate against a null/sink endpoint; run reconnect; inject 1% response loss; measure backlog; continue until target recovery and 2h stability.

**Pass.** Zero primary failures; offered plan achieved without generator drop; positive net drain; selected recovery/headroom hypothesis; no starvation; resource/log/plan stable.

**Fail.** `μ_safe <= λ_new`, growing oldest age, retry collapse, or any invariant failure.

**Duration.** Based on measured recovery, capped by explicit run plan; no arbitrary early stop labelled pass.

### P17-04 — 12,000-device saturation curve

**Claim.** The system’s sustainable capacity and knee can be measured without generator/SUT coupling.

**Setup.** 12k actors; step/ramp open-arrival rates; complete query/maintenance mix; sufficient agents proven against a null target.

**Steps.** Increase offered load in fixed stages; hold each until stable; record throughput, tails, queues, WAL/log, waits, plans, and generator delay; stop before unsafe disk/resource state.

**Pass.** Reproducible capacity curve and identified knee with no generator drops below claimed range; no primary failures.

**Fail.** Generator saturation precedes SUT knee, unbounded state, unexplained non-repeatability, or safety invariant failure.

**Duration.** **ESTIMATE:** 4–12 hours per engine/configuration.

### P17-05 — restore and acknowledged replay prototype

**Claim.** The declared backup/restore procedure preserves acknowledged custody and allows exact ambiguous/unacknowledged replay before readiness.

**Setup.** Loaded 6k database with known acknowledged, ambiguous, quarantined, materialized, and query fixture states; backup under load; isolated restore.

**Steps.** Lose response after selected commits; take backup; continue writes; fail primary; restore target; reconcile; replay exact batches; verify readiness and query visibility.

**Pass.** Every batch inside declared RPO/custody domain matches the approved expectation; no duplicate effect; readiness withheld until complete; restore/runbook time measured.

**Fail.** Acknowledged event missing beyond the stated failure-domain/RPO claim, stale/deleted fixture visible too early, or manual undocumented repair needed.

**Duration.** Full backup/restore/catch-up; evidence records actual time rather than assumed RTO.

### P17-06 — broker trigger prototype, conditional

**Claim.** A named broker candidate materially resolves the crossed relational trigger with acceptable failure-domain, replay, cost, and operations.

**Setup.** Exact relational baseline and broker design, one authoritative receipt boundary, identical workload and truth; broker disabled outside the test.

**Steps.** Repeat trigger workload and faults; crash each handoff; restore/replay; fan out consumers if that was the trigger; calculate total cost/skills/runbook burden.

**Pass.** Quantified trigger improvement meets ADR target and every invariant/restore/security/operations gate; no dual custody.

**Fail.** Throughput shifts bottleneck downstream, semantics weaken, replay duplicates, cost/skills unacceptable, or no material improvement.

**Duration.** Prototype first at smallest falsifying load; 6k/12k only after semantics pass.

## 8.7 Generator qualification

Before every 6k/12k run, agents target a private null/custody emulator that:

- consumes exact bytes and returns deterministic valid/ambiguous responses without database work;
- can accept at least `planned_peak × (1 + generator_test_margin)` where the temporary margin is **ESTIMATE: 100%**;
- proves zero generator-dropped arrivals in the claimed range;
- measures agent CPU, GC, memory, sockets, TLS, network, clock, and partition skew;
- proves evidence export does not throttle the run;
- detects an intentionally overloaded agent and marks the run invalid.

The null target is not a server capacity result. It proves only the generator’s offered-load capability.

## 8.8 Database comparison protocol

Two rounds are required:

1. **Semantic parity round.** Same logical schema, indexes where semantically equivalent, worker count, transactions, query corpus, faults, and resource class. Purpose: prove both adapters satisfy invariants and expose comparable baseline.
2. **Best-supported-design round.** Each engine MAY use its reviewed operational strengths—engine-specific indexes, partitioning, maintenance, connection/pool tuning—while preserving contracts and workload. Every difference is recorded and must be operable by the proposed team.

The production decision considers:

```text
correctness and realm isolation
steady and recovery capacity/tails
storage/WAL/log/backup/restore
query and maintenance behavior
failure and upgrade behavior
operational skills/on-call/tooling
license/procurement/support
migration and fallback cost
total cost under selected objectives
```

A single TPS value never decides the engine.

# 9. Architecture fitness functions and measurable acceptance criteria

## 9.1 Fitness-function rules

A fitness function is executable evidence, not an architectural slogan. Each function below MUST have:

- an owning component and accountable owner function;
- a machine-readable assertion and evidence path;
- an exact workload/scenario and environment identity;
- an evidence expiry or rerun trigger;
- a zero-tolerance result for safety, privacy, realm, custody, and idempotency invariants;
- an approved threshold for service, cost, and operational objectives;
- a failure action that blocks dependent work rather than averaging the failure away.

A run with an unknown expected result, missing arrivals, generator saturation, expired evidence, unclassified error, or incomplete cleanup is `INVALID`, not `PASS`.

## 9.2 Core fitness-function register

| ID | Classification | Executable assertion | Measurement and acceptance | Failure action |
|---|---|---|---|---|
| FF-17-01 — exact offered load | **RECOMMENDATION** | `offered_arrivals == scheduled_arrivals` for the claimed load interval, excluding only explicitly cancelled test control | Agent/orchestrator counters reconcile by scenario/partition/second; generator-start-delay and dropped-start counts are zero inside the claimed envelope | Invalidate the capacity run; add agents or lower the claimed range |
| FF-17-02 — production-code path | **RECOMMENDATION** | Every accepted request used the production contract model, serializer, compression, stable identity, retry classifier, and receipt verifier | Evidence records assembly/package and contract digests; architecture test rejects simulator-local wire implementations | Stop; simulator result cannot support architecture |
| FF-17-03 — one durable custody effect | **FACT/RECOMMENDATION** | Each stable batch identity has zero or one durable inbox row and zero or one authoritative receipt state | Independent truth query compares `(realm, installation, batch, digest)` uniqueness and receipt ledger after retries/faults | Primary gate failure; stop dependent capacity conclusions |
| FF-17-04 — no false receipt | **FACT/RECOMMENDATION** | No receipt is emitted before the declared relational durable transaction commits | Failpoints and response-loss history show receipt only after commit; invalid/mismatched receipt never acknowledges | Primary gate failure and security incident path |
| FF-17-05 — realm isolation | **FACT/RECOMMENDATION** | No request, lease, query, cache, metric body, or support operation crosses its authenticated realm | Negative corpus plus database predicates/RLS or equivalent guard; zero cross-realm result | Primary security gate failure; global hold for candidate build |
| FF-17-06 — bounded ingress | **RECOMMENDATION** | Compressed/uncompressed bytes, item count, nesting, decompression ratio, parse time, and allocation remain inside the release contract | Hostile body corpus and run-time counters; every over-limit body is rejected with finite safe code before durable application state | Stop ingress promotion; classify parser/resource defect |
| FF-17-07 — no silent loss | **FACT/RECOMMENDATION** | Every offered batch reaches exactly one terminal state: durable receipt, authoritative no-custody, retained ambiguous/retry, or explicit test cancellation | Truth ledger reconciles all batch IDs; `unexplained_missing == 0` | Primary reliability gate failure |
| FF-17-08 — poison isolation | **RECOMMENDATION** | A poison item cannot starve another realm or block the global worker pool | Scenario S17-07; bounded attempts/time; healthy-realm lag remains under approved threshold; poison reaches quarantine with evidence | Stop worker design; add bounded isolation/quarantine |
| FF-17-09 — fair recovery | **RECOMMENDATION** | No active realm/device partition is indefinitely starved during reconnect/backlog drain | Per-realm/device service lag plus Jain index and maximum starvation interval; exact threshold is **HUMAN DECISION** | Reject scheduling policy or reduce concurrency until fair |
| FF-17-10 — stable queue | **RECOMMENDATION** | During a declared steady interval, queue/backlog slope is non-positive after warm-up | Robust slope and confidence interval over inbox/worker queues; no hidden maintenance backlog | Claimed sustainable rate is above capacity; lower it |
| FF-17-11 — recovery feasibility | **RECOMMENDATION** | `μ_safe > λ_new` and measured `T_recover <= T_recover_target` under the approved outage/backlog case | Use measured p95/p99 drain and new-arrival rate; include maintenance/query load | Stop; scale/tune or change objective before rollout |
| FF-17-12 — agreed headroom | **RECOMMENDATION** | `μ_safe >= λ_peak × (1 + h_approved)` for ingress and every downstream constrained stage | The same complete workload at 6k/12k, including queries, retention, backup, policy, poison, and retries | Capacity choice is not accepted until owner approves headroom and run passes |
| FF-17-13 — tail latency | **ESTIMATE/HUMAN DECISION** | Receipt p95/p99/p99.9 and worker/materialization age meet approved hypotheses under each mandatory shape | Histograms use fixed boundaries and record offered/achieved load; no percentile from an invalid run | Do not claim SLO fitness; retain raw distribution evidence |
| FF-17-14 — bounded resource | **RECOMMENDATION** | DB CPU, memory, connections, lock waits, temp spill, disk latency, WAL/log, storage, API sockets, GC, and worker queues stay below approved guardrails | Time series and maxima/quantiles; no emergency OOM/disk reserve consumption | Stop run safely; classify bottleneck and rerun from clean state |
| FF-17-15 — plan stability | **RECOMMENDATION** | Load-bearing queries retain an approved plan class and bounded logical/physical work across data scale | Normalized plan fingerprints and row/page/read counters at seed, 6k, 12k, backlog, retention, and post-maintenance states | Open schema/index ADR; no capacity extrapolation |
| FF-17-16 — restore readiness | **FACT/RECOMMENDATION** | Restored service does not declare readiness until custody, receipt, realm, uniqueness, quarantine, migration, and query checks pass | Automated restore verifier plus exact known truth; zero acknowledged event loss outside declared RPO/failure-domain semantics | Primary restore failure; block production-engine choice |
| FF-17-17 — rolling compatibility | **RECOMMENDATION** | Old/new compatible server workers and endpoint batches coexist without duplicate effect, rejected supported contract, or state corruption | Scenario S17-11 with executable compatibility matrix and rollback | Stop rollout; expand consumer compatibility or revert |
| FF-17-18 — 72-hour stability | **RECOMMENDATION** | No monotonic leak, queue drift, plan degradation, WAL/log runaway, connection churn, fairness collapse, or unexplained restart over 72 hours | Slope/change-point tests over memory, handles, threads, queues, latency, WAL/log, storage, and errors | Soak fails; no 6,000-device capacity approval |
| FF-17-19 — evidence cardinality | **RECOMMENDATION** | Metric series and evidence dimensions remain inside the declared formula and approved budget | Static catalogue calculation plus run-time unique-series count; dynamic realm/device/batch IDs absent from metric labels | Disable offending instrumentation; rerun affected tests |
| FF-17-20 — evidence reproducibility | **RECOMMENDATION** | Same seed/scenario/artifacts on an equivalent clean environment yields the same workload ledger and statistically compatible service distributions | Byte-identical scheduled workload; configuration/evidence digests; documented tolerance test for timing distributions | Classify nondeterminism; block regression use |
| FF-17-21 — cleanup | **RECOMMENDATION** | Test databases, accounts, certificates, queues, proxy rules, files, processes, and synthetic telemetry are removed or reverted exactly as declared | Before/after inventory and deletion receipts; no secret/address/raw value in evidence | Run is failed, not merely dirty |
| FF-17-22 — accessible evidence | **RECOMMENDATION** | Gate summaries, dashboards, and reports do not require colour, hover, or image-only interpretation | Text labels, tabular export, units, threshold annotations, keyboard-readable dashboard checks | Fix reporting before review; raw evidence remains authoritative |

## 9.3 SLO and headroom hypotheses

The values below are deliberately hypotheses. They make tests executable before business objectives are approved; they MUST NOT appear in a production support promise, contract, dashboard target, or capacity purchase without the named **HUMAN DECISION**.

| Hypothesis | Temporary lab value | Why it is conservative/useful | Required human decision and replacement evidence |
|---|---:|---|---|
| Ingestion availability/error budget | no production value; report raw success, rejection, and ambiguous-custody distributions | Avoids inventing an availability promise | Product/Risk and SRE approve SLO/error budget using pilot and business impact |
| Receipt latency | report p50/p95/p99/p99.9; provisional gate p99 ≤ 5 s in steady synthetic direct-network lane | Provides a falsifiable bootstrap without implying end-user visibility | SRE/Product approve based on actual network, custody, and operational need |
| Backlog recovery | provisional target: clear selected outage backlog within `min(4 h, outage_duration)` only for the T1 benchmark | Forces meaningful drain measurement and exposes `μ_safe <= λ_new` | Product/SRE choose max outage and recovery objective |
| Sustainable headroom | **ESTIMATE:** 50% over measured mandatory peak (`h_lab = 0.50`) at every constrained stage | Safer than sizing to the observed peak; intentionally revisable | Product/Risk/SRE approve headroom from uncertainty, growth, maintenance, and failure assumptions |
| Resource reserve | **ESTIMATE:** keep normal run below 70% sustained CPU, 70% memory, 70% connection pool, and 70% usable data/log volume | Leaves room for bursts, failover, maintenance, and estimation error | Operations/DBA approve engine/environment-specific guardrails |
| Fairness | no realm starved for more than **ESTIMATE:** 2 scheduling quanta; Jain index ≥ **ESTIMATE:** 0.95 for equally weighted active realms | Detects obvious monopolization while weights are unapproved | Product/SRE approve weighting, priority, and allowed starvation |
| Poison containment | one poison item consumes at most **ESTIMATE:** 3 attempts and 60 s worker time before quarantine | Gives finite test limits and prevents retry storms | Data/Operations approve retry/quarantine policy and support path |
| Query responsiveness | report full distribution; provisional admin read p95 ≤ **ESTIMATE:** 2 s for the approved T1 corpus under steady ingest | Prevents a throughput-only design | Product/Portal/SRE approve user-facing objectives and query corpus |
| Restore | no assumed RTO/RPO; measure every phase and require zero truth mismatch to the declared backup boundary | Research cannot invent recovery objectives | Data Reliability/Product/Risk approve RPO/RTO and custody failure domain |
| 72-hour soak | zero primary invariant failure, zero unexplained process restart, and no positive backlog/resource slope after warm-up | Safety and leak requirements do not require a business SLO | SRE approves statistical drift tolerance and recurring cadence |

A production capacity recommendation requires all of the following, not merely a high TPS number:

```text
approved workload distributions and peak definition
AND approved outage/recovery objective
AND approved SLO/error budget and headroom
AND valid 6,000-device steady/morning/reconnect/restore evidence
AND valid 12,000-device saturation and 72-hour evidence
AND complete query, maintenance, retention, backup, and policy load
AND generator qualification and zero primary invariant failure
AND engine operations/licensing/skills evidence
```

## 9.4 Quantitative broker break-even decision table

**RECOMMENDATION.** Crossing one threshold below opens a broker prototype ADR; it does not authorize adoption. Broker adoption requires the conditional prototype P17-06 to pass semantics, restore, security, operations, skills, and cost gates. If no trigger is crossed, the relational inbox remains the accepted design.

| Trigger family | Quantitative trigger to open a prototype | Relational evidence required first | Broker must prove | Do not count as a trigger |
|---|---|---|---|---|
| Sustainable throughput/headroom | Best-supported relational design cannot achieve `μ_safe >= λ_peak × (1 + h_approved)` at the constrained stage on the approved resource/cost class, in two clean runs per engine | Query/plan/index/partition/pool/worker tuning, restore, maintenance and complete workload evidence for both PostgreSQL and SQL Server candidates | Required headroom and tails without moving the bottleneck downstream; one final effect and bounded state | Endpoint count, a synthetic TPS headline, or poor first-pass SQL |
| Recovery drain | `μ_safe <= λ_new` or measured `T_recover` exceeds approved target after an approved outage/backlog, while scale-up/out is infeasible or more costly | Exact backlog composition, new-arrival load, fairness, maintenance/query mix, and relational tuning | Materially faster recovery with fair service and no duplicate/lost custody | A backlog caused by generator delay, disabled workers, or unrepresentative poison |
| Failure-domain decoupling | Approved RTO requires ingress custody during relational unavailability longer than the relational HA/maintenance design can safely provide | Measured failover/maintenance/restore window and documented receipt failure domain | A single unambiguous custody boundary, durable receipt semantics, replay after DB recovery, and restore reconciliation | Desire for “more resilient architecture” without a quantified outage gap |
| Replay horizon/rate | Approved replay requires `R_replay` that consumes more than **ESTIMATE: 25%** of sustained relational capacity or misses the approved replay completion target in repeated tests | Measured relational replay with production schema/query/maintenance load and bounded retention | Required replay rate/horizon with isolation and cost, without dual writes or changed business identity | Occasional operator query or speculative future analytics |
| Independent fan-out | At least `F_approved` independent consumers require incompatible pace/retry/retention, and measured relational polling/lease work exceeds **ESTIMATE: 20%** of DB capacity or causes objective failure | Concrete consumer contracts, read amplification, lock/cache effect, and alternative governed server-side materialization | Consumer isolation, per-consumer replay, deletion/retention compatibility, and no uncontrolled data spread | One processing pipeline plus portal queries; hypothetical consumers |
| Noisy-neighbour isolation | A bounded poison/slow consumer repeatedly causes another approved consumer/realm to breach its objective despite relational queue partitioning/fair scheduling | Exact isolation design and fault evidence | Stronger isolation under the same fault with bounded operational state | A bug that should be fixed in a worker or query |
| Geographic/availability topology | Approved topology requires asynchronous regional buffering or data sovereignty behavior the single relational custody boundary cannot implement within objectives | Named regions, legal/data-residency authority, failure model, latency and restore evidence | Exact regional custody, conflict, replication, deletion, and failover semantics | General “multi-region readiness” or future possibility |
| Cost break-even | Three-year approved NPV of broker design is at least **ESTIMATE: 20%** lower than relational scale/HA/operations alternative, or the relational alternative exceeds an approved budget cap, at equal objectives | Itemized hardware/cloud/license/support/on-call/backup/egress/migration estimates with sensitivity ranges | Same or better objectives, staffing viability, predictable egress/storage/replay cost, and exit path | Free-tier pricing, list price alone, or excluding on-call/migration cost |
| Operational support | Relational design cannot meet approved 24x7/restore/maintenance obligations with available skills/support, and a broker has demonstrably lower total operating risk | Skills inventory, runbook exercises, support contracts, incident record, training cost | Named owners, patch/upgrade/backup/restore/security/capacity runbooks and successful drills | Technology preference, popularity, or managed-service marketing |

`25%`, `20%`, and `20% NPV margin` are **ESTIMATE** bootstrap thresholds. The architecture forum MUST replace them with approved values before a production broker decision.

### Hard broker disqualifiers

A broker candidate is rejected regardless of throughput when any of these is true:

- endpoint receipts would ambiguously acknowledge both broker and relational storage;
- the endpoint would need broker credentials/protocols or bypass the HTTPS ingestion contract;
- stable event/batch identity or central uniqueness is weakened;
- a broker outage, replay, rebalance, retention, compaction, or restore can create multiple final effects or silent loss;
- realm isolation, deletion, audit, or support evidence becomes less enforceable;
- the team cannot operate, patch, restore, monitor, and fund the broker alongside the relational system;
- the measured improvement is within run noise or is offset by downstream bottlenecks.

## 9.5 Data-quality acceptance

Capacity evidence MUST distinguish volume from correctness. For every scenario, the gate records:

```text
scheduled devices/sessions/events/batches
accepted, duplicate, rejected, quarantined, materialized and visible counts
uncompressed and compressed byte distributions
stable natural-key and event/batch uniqueness conflicts
schema/contract/version and policy-disposition distributions
per-realm/source/interpretation provenance completeness
source-time quality classes separately from custody/processing time
unknown/unclassified outcome count
```

Acceptance requires `unknown_unclassified = 0`, complete truth reconciliation for T1 fixtures, no inferred business meaning from source labels, and no use of a success-rate denominator that omits rejected, delayed, or generator-dropped work.

# 10. Human decisions and owner questions

Research defines options and consequences but does not approve policy, objectives, money, staffing, or production measurement. The role names below are accountable functions, not assumed people.

## 10.1 Mandatory human-decision register

| ID | HUMAN DECISION | Options and consequences | Conservative temporary lab default | Accountable role/function | Blocked until decided |
|---|---|---|---|---|---|
| HD-17-01 — maximum outage model | Select maximum planned/unplanned endpoint or site outage, including whether multiple days must be recoverable. A larger value increases endpoint storage, reconnect load, central backlog, recovery capacity, and cost | Model 1 h, 24 h, and 72 h T1 cases; make no production promise | Product/Risk with Endpoint and SRE | Production local/central sizing and recovery gate |
| HD-17-02 — recovery objective | Select target time to return backlog/event age to normal after each approved outage. Faster recovery requires more headroom and may reduce fairness/query capacity | Report measured recovery curve; provisional T1 target in §9.3 only | Product/Risk and SRE/Data Reliability | Production drain rate and capacity purchase |
| HD-17-03 — SLO and error budget | Select ingestion availability, receipt tail, materialization age, portal/query objectives, and allowable error budget. Tight objectives increase redundancy/operations cost | Record raw distributions; no production SLO | Product Owner/Risk with SRE | SLO gate, alerts, support promise |
| HD-17-04 — capacity headroom | Select margin for growth, model error, maintenance, node loss, failover, and bursts. Too little risks instability; too much raises cost | 50% T1 hypothesis | Product/Risk and SRE/Finance | Final node/database sizing |
| HD-17-05 — cost/support constraint | Select budget cap, license/support posture, cloud/on-prem constraints, and acceptable three-year TCO. Lower spend can reduce redundancy/support and increase staff burden | Compare transparent cost components; choose no engine/broker by price alone | Product/Finance/Procurement with Operations | Engine/broker/platform selection |
| HD-17-06 — permitted measurement cohort | Choose whether metadata-only legacy measurement, a T1 Windows cohort, a controlled pilot, or no organization-shaped measurement is allowed; define consent/approval, fields, access, expiry, and deletion | T1 synthetic only; zero live activity values | Data Controller/Product Governance with Legal/Privacy and Workforce Governance | Replacing workload estimates with organization evidence |
| HD-17-07 — approved metadata fields | Decide which value-free distributions may be collected: counts, byte buckets, timings, retry classes, outage classes, version classes, and resource metrics. More detail improves sizing but increases privacy/cardinality risk | Use the closed schema in §5; no IDs, URLs, users, apps, paths, addresses, or raw activity | Privacy/Data Governance with SRE | T3-safe measurement collector |
| HD-17-08 — retention and deletion | Select retention for inbox, typed facts, aggregates, quarantine, audit, evidence, backups, and measurement records. Longer retention increases storage/index/restore/delete cost | T1 artifacts follow short manifest expiry; production formula leaves `R_*` unknown | Data Controller/Records/Data Owner with Legal/Privacy | Storage forecast, partition/deletion design, restore test |
| HD-17-09 — query corpus and concurrency | Approve the reports/admin/integration queries, freshness, concurrency, export limits, and accessibility expectations. Unbounded ad hoc queries can invalidate ingest sizing | Fixed T1 query corpus; no arbitrary SQL or broad export | Product/Data Owner with Portal/Support and SRE | Complete engine benchmark and portal objective |
| HD-17-10 — realm fairness and priority | Decide equal versus weighted realms, premium/critical classes, maximum starvation, and whether policy/control work outranks data ingest | Equal-weight synthetic realms; no realm-specific business priority | Product Governance/Risk with SRE | Fair scheduling and alert thresholds |
| HD-17-11 — poison/quarantine policy | Decide retry count/time, who may inspect/release/discard, retention, notification, and whether malformed data can ever be corrected | Finite T1 quarantine; no automatic discard or payload exposure | Data Reliability/Security/Support with Privacy | Production poison runbook and storage |
| HD-17-12 — production database engine | Choose PostgreSQL, SQL Server, or defer after identical evidence, considering operations, skills, licensing, support, restore, HA, and migration | Benchmark both; no prose selection | Architecture Forum with Database Operations, Product, Finance/Procurement | Production persistence implementation |
| HD-17-13 — broker trigger values and adoption | Replace provisional break-even values; decide whether a crossed trigger justifies another platform and operations surface | No broker; relational inbox | Architecture Forum with SRE/Data Reliability/Product/Finance/Security | Broker prototype/adoption |
| HD-17-14 — HA/failure domain | Define what a durable receipt survives: process, VM, node, zone, site, regional loss, and backup lag. Stronger domains increase latency and cost | T1 receipt names only the exact local test transaction; no production cleanup authority | Data Reliability/Product Risk with Infrastructure | Receipt contract, HA design, RPO/cleanup |
| HD-17-15 — RPO/RTO and restore authority | Select accepted data loss window, recovery time, readiness criteria, drill cadence, and who may invoke restore/failover | Measure all phases; zero invented objective | Product/Risk with SRE/Data Reliability/Records | Production restore acceptance |
| HD-17-16 — workload growth horizon | Select planning horizon, adoption curve, realm/device/session growth, and seasonal/business peaks | Evaluate 6k and 12k plus sensitivity; do not forecast production growth | Product/Portfolio with Finance/SRE | Procurement and capacity reservation |
| HD-17-17 — overload/loss semantics | Decide whether collection pauses indefinitely, what happens when endpoint or central storage is exhausted, and whether any audited loss is ever allowed | Pause/backpressure; never silently drop unacknowledged data | Product/Risk/Data Owner with Privacy/Legal/SRE | Long-outage and disk-pressure production policy |
| HD-17-18 — operations and support model | Assign DBA/SRE/on-call/support/security ownership, service hours, escalation, patching, capacity review, and incident command | Capability remains lab-only without assigned functions | Engineering/Operations Leadership | Production readiness and cost comparison |
| HD-17-19 — licensing/procurement | Approve database/tool/support licenses, benchmark rights, test-tool commercial terms, and supplier review | Use only approved T1/reference tooling; no assumption that repository license covers service/binary use | Legal/Procurement with Architecture | Tool/engine/broker admission |
| HD-17-20 — production approval | Decide pilot and production risk acceptance after all applicable suite gates | No pilot/production | Designated Production/Risk Authority | Deployment |

## 10.2 Owner questions

The architecture forum and accountable functions MUST answer these questions before production capacity approval:

1. What is the largest endpoint/site outage that the product promises to absorb, and what recovery time is acceptable while new work continues?
2. Which receipt failure domain is being sold or relied upon, and which backup/restore boundary supports it?
3. What is the authoritative peak: morning logon, reconnect after a site outage, rolling update, policy fanout, query/report window, or a documented combination?
4. Which event, byte, compression, batch, retry, session, and offline distributions are approved and how current are they?
5. Which queries, integrations, exports, and administrative operations must run during peak ingest and recovery?
6. What headroom covers model error, growth, one-node/zone loss, maintenance, vacuum/checkpoint/log backup, and incident diagnosis?
7. How are realms weighted, and what maximum starvation or age is acceptable for a small realm during a large-realm reconnect storm?
8. What poison payload state may support see, who may release or discard it, and how is that action audited?
9. Which database skills and support arrangements exist today, and what training/on-call burden is acceptable for each engine?
10. What cost horizon and sensitivity range will decide scale-up, scale-out, database licensing, storage, backup, observability, and broker adoption?
11. Which value-free metadata may be measured from legacy or a pilot, for how long, and who proves deletion and no raw activity collection?
12. What evidence expires on an OS, runtime, serializer, schema, database patch, network, hardware, or query-corpus change?
13. Who can invoke ingestion, worker, policy, query, realm, or global kill switches, and who can safely re-enable them?
14. Which incident classes require global stop versus realm/source isolation, and what communication/support coverage is required?
15. What accessibility standard applies to dashboards, runbooks, evidence, and administrative capacity controls?


# 11. CLI experiments, measurements, and exact evidence

## 11.1 CLI safety and reproducibility rules

All commands are examples for repository-owned tools and use placeholders. They MUST NOT print, accept on the command line, or persist actual credentials, hostnames, addresses, proxy values, connection strings, certificate private material, production realm/device IDs, user data, URLs, application names, or raw activity.

Secrets and network endpoints MUST be provided through the approved lab secret/reference mechanism. Shareable evidence records only a redacted connection-profile ID and configuration digest. Every command MUST support `--dry-run`, strict schema validation, an evidence directory, and nonzero exit on an unmet assertion.

A common run envelope is:

```bash
dotnet run --project src/tools/Uam.Capacity.Runner -- \
  run \
  --scenario artifacts/scenarios/<scenario>.yaml \
  --workload artifacts/workloads/<workload>.json \
  --contracts artifacts/contracts/<bundle>.json \
  --environment-ref <approved-lab-profile-id> \
  --seed <unsigned-64-bit-seed> \
  --evidence-dir artifacts/evidence/<run-id> \
  --no-secret-output \
  --strict
```

The CLI MUST refuse:

- a dirty or unidentifiable source tree unless an explicit non-gate development mode is selected;
- mutable dependency, container, VM image, schema, or workload references;
- missing expected-result authority;
- an unknown engine adapter or contract profile;
- unapproved raw measurement fields;
- output paths outside the declared evidence root;
- a gate run without cleanup and canary positive controls;
- a broker mode without an accepted trigger ADR and single custody definition.

## 11.2 Experiment E17-00 — allowlisted-input and toolchain manifest

**Classification:** **CLI EXPERIMENT**  
**Claim:** the research and implementation evidence use exactly the approved inputs and identifiable tools.

```bash
dotnet run --project src/tools/Uam.Evidence.Manifest -- \
  create \
  --allowlist artifacts/research/prompt-17-allowlist.json \
  --toolchain global.json \
  --locks Directory.Packages.props \
  --output artifacts/evidence/e17-00-inputs/manifest.json
```

**Evidence required:** logical file names, sizes, SHA-256 digests, source-tree digest, clean-state proof, .NET/OS/runtime inventory, package locks, simulator assemblies, serializer/compressor identities, database client/driver identities, selected native modules, test tools, and license/admission record IDs.

**Pass:** all required files match; no unallowlisted Project file is listed; every executable byte has an admission/source mapping.  
**Fail:** missing/substituted file, mutable version, hidden native module, unresolved executable license, or a production secret/test key in evidence.

## 11.3 Experiment E17-01 — compile and validate capacity inputs

**Claim:** every variable in the formula model has a unit, distribution, provenance, owner class, sensitivity class, validity, and replacement status.

```bash
dotnet run --project src/tools/Uam.Capacity.Compiler -- \
  compile \
  --model capacity/model.yaml \
  --measurements capacity/measurements.t1.json \
  --scenario-dir capacity/scenarios \
  --schema contracts/capacity \
  --output artifacts/compiled/capacity-plan.json \
  --strict
```

**Evidence required:** resolved variable table, dimensional-analysis result, distribution parameters, correlations, scenario expansion, formula dependency graph, all estimates/unknowns, owner questions, and exact compiler digest.

**Pass:** zero dimension mismatch, unbounded variable, silent default, or production-labeled estimate.  
**Fail:** missing unit/provenance, incompatible percentile arithmetic, point estimate where a distribution is required, or an unknown used as approved fact.

## 11.4 Experiment E17-02 — production-adapter and deterministic-fleet conformance

**Claim:** the simulator uses the production endpoint upload code path and deterministic identities/state.

```bash
dotnet test tests/Uam.FleetSim.Conformance \
  --configuration Release \
  --no-restore \
  --logger "trx;LogFileName=e17-02.trx"

dotnet run --project src/tools/Uam.FleetSim.Cli -- \
  self-test \
  --devices 12000 \
  --seed 170002 \
  --contracts artifacts/contracts/ingestion-bundle.json \
  --output artifacts/evidence/e17-02-fleet-self-test
```

**Evidence required:** architecture-test graph, production assembly references, canonical request/receipt vectors, identity collision report, deterministic replay hashes, agent state transitions, retry classifications, compression ratios, and negative contract vectors.

**Pass:** byte-identical workload ledger for repeated seed; no simulator-local serializer/retry/receipt logic; zero identity collision; every hostile vector gets the expected finite result.  
**Fail:** mock-only client path, random non-reproducible identity, receipt accepted without production verifier, or hidden per-device state outside the model.

## 11.5 Experiment E17-03 — generator open-arrival qualification

**Claim:** the load system can offer at least twice the planned peak without SUT backpressure controlling the schedule.

```bash
dotnet run --project src/tools/Uam.FleetSim.Orchestrator -- \
  qualify-generator \
  --scenario capacity/scenarios/generator-null-target.yaml \
  --null-target-ref <approved-private-null-target> \
  --planned-peak <requests-per-second> \
  --margin 2.0 \
  --agents <agent-count> \
  --seed 170003 \
  --evidence-dir artifacts/evidence/e17-03-generator
```

**Evidence required:** scheduled/offered/started/completed counts per second and agent, start-delay histogram, dropped-start count, CPU/GC/memory/sockets/network, TLS/compression cost, clock skew, evidence-export overhead, and deliberately overloaded negative control.

**Pass:** zero dropped starts and bounded start delay through `2 × planned_peak`; overloaded control is detected and invalidated.  
**Fail:** agent or orchestrator saturation, coordinated-omission behavior, evidence exporter throttling, or unobserved clock/partition skew.

## 11.6 Experiment E17-04 — metadata-only distribution collection

**Classification:** **CLI EXPERIMENT + HUMAN DECISION**  
**Claim:** approved value-free distributions can replace estimates without collecting activity, identity, address, or confidential configuration.

The collector MUST be disabled unless an immutable approved measurement manifest exists.

```bash
dotnet run --project src/tools/Uam.Capacity.Measure -- \
  collect \
  --approval artifacts/approvals/<measurement-approval-id>.json \
  --mode metadata-only \
  --source-ref <approved-lab-or-pilot-source> \
  --output artifacts/restricted/e17-04-measurement \
  --delete-at <approved-expiry> \
  --strict

dotnet run --project src/tools/Uam.Capacity.Measure -- \
  sanitize-and-summarize \
  --input artifacts/restricted/e17-04-measurement \
  --schema contracts/capacity/measurement-safe.schema.json \
  --output artifacts/evidence/e17-04-safe-summary
```

Permitted candidate fields are only those approved from the schema in §5. Examples include count/byte/latency buckets, finite retry/outage classes, endpoint/runtime version classes, and bounded resource distributions. The collector MUST structurally reject strings or dimensions for URL, host, path, application, user, realm, device, installation, session, IP/address, certificate, proxy, internal topology, raw error, or payload.

**Evidence required:** approval scope, schema/config digest, exact field inventory, cohort size bucket, aggregation and minimum-cell rules, collection start/end, access log, canary scan, safe summary, deletion/reversion receipt, and proof that raw records never entered the shareable evidence root.

**Pass:** only approved fields; no raw or stable subject/device values; expiry/deletion succeeds; positive controls are detected.  
**Fail:** unapproved field, small-cell disclosure, raw string, external egress, undeleted record, or missing authority.

## 11.7 Experiment E17-05 — relational semantic parity

**Claim:** PostgreSQL and SQL Server adapters implement the same durable-inbox, lease, idempotency, realm, poison, and receipt semantics.

```bash
for engine in postgresql sqlserver; do
  dotnet run --project src/tools/Uam.ServerBench.Cli -- \
    semantic-parity \
    --engine "$engine" \
    --environment-ref "<approved-${engine}-lab>" \
    --schema contracts/server/inbox-logical-schema.json \
    --workload capacity/workloads/semantic-parity.json \
    --faults capacity/faults/semantic-parity.yaml \
    --seed 170005 \
    --evidence-dir "artifacts/evidence/e17-05-${engine}"
done
```

**Evidence required:** normalized DDL/index mapping, exact transaction histories, lease/attempt/receipt/quarantine states, uniqueness truth, realm-negative results, plan fingerprints, lock/wait evidence, restart and response-loss histories, and cleanup.

**Pass:** both engines pass every primary invariant; any semantic difference is explicit and does not alter the contract.  
**Fail:** duplicate final effect, false receipt, lease theft, wrong-realm access, poison starvation, or an engine adapter that requires payload-derived authority.

## 11.8 Experiment E17-06 — 6,000-device complete-workload gate

```bash
dotnet run --project src/tools/Uam.FleetSim.Orchestrator -- \
  run-matrix \
  --devices 6000 \
  --scenarios capacity/matrices/mandatory-6k.json \
  --engines postgresql,sqlserver \
  --agents <qualified-agent-count> \
  --seed-set capacity/seeds/mandatory-6k.txt \
  --environment-map capacity/environments/approved.json \
  --evidence-dir artifacts/evidence/e17-06-6k
```

The mandatory matrix includes steady, morning, reconnect, site outage, multi-day backlog, policy fanout, poison, slow DB, database restart, restore/replay, rolling update, and approved query/maintenance load.

**Evidence required:** all safe measurements in §5, formula input/output table, offered/achieved rates, event/byte/batch distributions, receipt/materialization tails, queues and slopes, fairness, resource and storage growth, query plans, backup/log behavior, error taxonomy, truth reconciliation, and per-scenario cleanup.

**Pass:** every primary invariant is zero-failure; the selected lab SLO/headroom hypotheses pass or are explicitly reported as failed; generator remains qualified.  
**Fail:** any invalid run, hidden dropped arrival, positive queue slope at claimed steady rate, restore mismatch, or unclassified error.

## 11.9 Experiment E17-07 — 12,000-device saturation and knee

```bash
dotnet run --project src/tools/Uam.FleetSim.Orchestrator -- \
  saturation \
  --devices 12000 \
  --scenario capacity/scenarios/12k-saturation.yaml \
  --rate-plan capacity/rates/open-arrival-steps.json \
  --engines postgresql,sqlserver \
  --seed-set capacity/seeds/saturation.txt \
  --stop-before-resource-reserve \
  --evidence-dir artifacts/evidence/e17-07-12k
```

**Evidence required:** reproducible throughput/latency/queue/resource curves, detected knee method, agent capacity, plan/wait changes, bottleneck attribution, safe stop record, and confidence/sensitivity analysis.

**Pass:** the sustainable region and knee are reproducible and occur before generator saturation; no safety invariant fails.  
**Fail:** capacity is reported beyond the knee, emergency resource reserve is consumed, plan regression is unexplained, or engine comparison uses different workload/objectives.

## 11.10 Experiment E17-08 — 72-hour soak

```bash
dotnet run --project src/tools/Uam.FleetSim.Orchestrator -- \
  soak \
  --devices 6000 \
  --duration 72:00:00 \
  --scenario capacity/scenarios/72h-mixed.yaml \
  --engine <candidate-engine> \
  --seed 170008 \
  --evidence-dir artifacts/evidence/e17-08-72h
```

**Evidence required:** full time series and slope/change-point analysis for ingress/worker/query age, memory, handles, threads, pools, sockets, GC, DB cache, locks/waits, WAL/log, data/index/storage, backup, maintenance, fairness, errors, restarts, and evidence cardinality; daily integrity/truth checks; cleanup.

**Pass:** FF-17-18 passes and all primary invariants remain zero.  
**Fail:** monotonic leak/drift, unbounded log/WAL/table, repeated plan degradation, unexplained restart, cardinality explosion, or truth mismatch.

## 11.11 Experiment E17-09 — fault and reconnect campaign

```bash
dotnet run --project src/tools/Uam.FleetSim.Orchestrator -- \
  fault-campaign \
  --devices 6000 \
  --scenario capacity/scenarios/reconnect-and-faults.yaml \
  --network-fault-ref <approved-private-fault-proxy> \
  --database-fault-profile capacity/faults/database.json \
  --seed-set capacity/seeds/faults.txt \
  --evidence-dir artifacts/evidence/e17-09-faults
```

Faults include response loss after durable commit, bounded latency/jitter, disconnect/reset, ingress restart, worker kill, lease expiry, database slow/deny/restart, disk/log pressure, poison, policy fanout, and clock-independent retry scheduling. Fault tooling cannot define custody truth; the independent database/receipt ledger does.

**Pass:** exact same batch is retried; one custody/effect; bounded recovery; fair service; no retry amplification beyond model; no fault-tool residue.  
**Fail:** new batch after ambiguity, false no-custody, correlated retry avalanche beyond scenario, or failure tooling changes the production security boundary.

## 11.12 Experiment E17-10 — backup, restore, and catch-up

```bash
dotnet run --project src/tools/Uam.ServerBench.Cli -- \
  restore-drill \
  --engine <candidate-engine> \
  --environment-ref <approved-restore-lab> \
  --fixture artifacts/fixtures/restore-6k.json \
  --backup-profile capacity/restore/<engine>.json \
  --continue-load-during-backup \
  --seed 170010 \
  --evidence-dir artifacts/evidence/e17-10-restore
```

**Evidence required:** backup start/end and consistency marker, transaction/log positions, continued-write ledger, failure point, restore phases, integrity and schema checks, receipt/custody reconciliation, exact replays, materialization/readiness gates, query truth, storage, RPO/RTO measurement without assumed objective, and cleanup.

**Pass:** restored state matches the declared boundary and exact fixture; no acknowledged custody loss beyond a separately approved failure-domain/RPO statement; readiness stays false until reconciliation completes.  
**Fail:** manual undocumented edit, duplicate business effect, missing custody, wrong-realm visibility, or restore declared ready early.

## 11.13 Experiment E17-11 — query, retention, and maintenance interference

```bash
dotnet run --project src/tools/Uam.ServerBench.Cli -- \
  mixed-workload \
  --engine <candidate-engine> \
  --ingest capacity/workloads/approved-ingest.json \
  --queries capacity/workloads/approved-query-corpus.json \
  --maintenance capacity/workloads/maintenance.json \
  --retention capacity/workloads/retention-delete.json \
  --data-scale capacity/scales/retention-horizons.json \
  --evidence-dir artifacts/evidence/e17-11-mixed
```

**Evidence required:** per-query plan/read/temp-spill/lock/tail evidence, ingestion effect, retention/delete/log/backup amplification, realm-negative checks, admin/export limits, and accessible report output.

**Pass:** both ingest and approved query/maintenance objectives meet the selected hypotheses with agreed headroom; no cross-realm result or unbounded ad hoc query.  
**Fail:** benchmark excludes production-shaped reports, retention destroys ingest headroom, query plan degrades at retention horizon, or one realm can infer another.

## 11.14 Experiment E17-12 — cost, skills, licensing, and operations comparison

```bash
dotnet run --project src/tools/Uam.Capacity.Cost -- \
  compare \
  --technical-results artifacts/evidence/index/accepted-runs.json \
  --cost-inputs capacity/cost/approved-inputs.json \
  --skills capacity/operations/skills-and-support.json \
  --licenses capacity/operations/license-records.json \
  --sensitivity capacity/cost/sensitivity.json \
  --output artifacts/evidence/e17-12-cost-ops
```

**Evidence required:** infrastructure, storage, backup, HA/DR, license/subscription, support, observability, egress, testing, patching, training, on-call, incident, migration, and exit costs; assumptions and ranges; skill coverage and runbook-drill results; no confidential commercial terms in broadly shared evidence.

**Pass:** comparable three-year ranges and sensitivity, approved license use, named operating model, and no omitted material category.  
**Fail:** price-only comparison, free/dev license used as production assumption, staffing omitted, or materially different objectives.

## 11.15 Experiment E17-13 — conditional broker prototype

This command is rejected unless an accepted trigger record exists.

```bash
dotnet run --project src/tools/Uam.BrokerGate.Cli -- \
  prototype \
  --trigger artifacts/decisions/<accepted-broker-trigger>.json \
  --baseline artifacts/evidence/index/relational-baseline.json \
  --candidate capacity/broker/<candidate>.json \
  --scenario capacity/scenarios/broker-falsifier.yaml \
  --seed-set capacity/seeds/broker.txt \
  --evidence-dir artifacts/evidence/e17-13-broker
```

**Evidence required:** trigger arithmetic, one custody-boundary contract, crash matrix at every handoff, stable identity/replay, downstream capacity, retention/deletion/realm/security, restore, fan-out isolation, operational drill, cost/sensitivity, license/support, and decommission path.

**Pass:** the quantified trigger is materially resolved and every hard broker disqualifier is false.  
**Fail:** bottleneck merely moves, dual custody, changed endpoint contract, replay duplicate/loss, cost/skills failure, or improvement within noise.

## 11.16 Experiment E17-14 — gate aggregation

```bash
dotnet run --project src/tools/Uam.Capacity.Gate -- \
  evaluate \
  --evidence-root artifacts/evidence \
  --gate-definition capacity/gates/prompt-17-gate.json \
  --human-decisions artifacts/decisions/human-decision-index.json \
  --output artifacts/evidence/capacity-gate.json \
  --strict
```

The aggregator MUST calculate assertions from evidence; it MUST NOT accept a manually entered `pass=true`.

```text
CAPACITY_PRIMARY_GATE =
    INPUTS_AND_TOOLS_IDENTIFIED
    AND PRODUCTION_CONTRACT_PATH_PROVED
    AND GENERATOR_QUALIFIED
    AND SAFE_WORKLOAD_DISTRIBUTIONS_APPROVED_OR_EXPLICITLY_T1
    AND RELATIONAL_SEMANTIC_PARITY_PASS
    AND MANDATORY_6K_MATRIX_PASS
    AND SATURATION_12K_VALID
    AND SOAK_72H_PASS
    AND RESTORE_AND_REPLAY_PASS
    AND QUERY_MAINTENANCE_RETENTION_INCLUDED
    AND ZERO_PRIMARY_INVARIANT_FAILURES
    AND ZERO_GENERATOR_DROPPED_ARRIVALS_IN_CLAIMED_RANGE
    AND ZERO_UNCLASSIFIED_ERRORS
    AND ZERO_CLEANUP_FAILURES
    AND APPROVED_HEADROOM_AND_RECOVERY_OBJECTIVES_RECORDED
    AND ENGINE_OPERATIONS_COST_LICENSE_EVIDENCE_COMPLETE
    AND (BROKER_DISABLED OR ACCEPTED_TRIGGER_AND_BROKER_PROTOTYPE_PASS)
```

**Pass artifact:** exact input/evidence digests, engine/configuration, approved objective references, capacity envelope, workload validity, expiry/retest triggers, residual risks, `brokerRequired`, and explicit `productionApproved=false`.  
**Fail behavior:** no capacity choice or broker adoption; preserve first failure and open the named ADR/work item.

# 12. ADR proposals

Each ADR below requires an accountable owner and review trigger. `Accepted` in this research result means recommended for architecture-forum acceptance at the stated scope; it does not mean its CLI evidence or human decisions have passed.

| ADR | Decision | Proposed status | Alternatives considered | Rationale and evidence | Accountable owner function | Review trigger |
|---|---|---|---|---|---|---|
| ADR-17-001 — formula capacity model | Adopt the replaceable variable/distribution/formula model in §3/§5 as the sole basis for capacity claims | **Proposed — accept model** | endpoint-count ratio; legacy row-count extrapolation; vendor calculator | Explicitly models events, bytes, retries, outage, backlog, drain, storage, queries, cost, and uncertainty; supplied evidence says these distributions are missing | Capacity Architecture with SRE/Data Reliability | new source/contract, approved measurements, objective, topology, or major cost change |
| ADR-17-002 — UAM-owned stateful simulator | Build a C#/.NET stateful fleet simulator using production contracts/client/serializer/compression/IDs/retry/receipt code | **Proposed — accept** | k6/NBomber-only scripts; endpoint VMs for all devices; protocol mock | Preserves endpoint state and semantic fidelity while remaining deterministic and economical; external tools cannot define UAM truth | Verification Architecture/Endpoint and Server Engineering | contract/client/runtime change or simulator fidelity defect |
| ADR-17-003 — dual load model | Combine stateful device actors with an independent open-arrival scheduler and record offered versus achieved load | **Proposed — accept** | closed-loop virtual users only; replay file only | Prevents server latency from pacing arrivals and hiding overload while retaining long-lived device behavior | Performance Engineering | scheduler/generator result invalidation or better proved mechanism |
| ADR-17-004 — simulator topology | Use horizontally scaled headless agents plus stateless orchestrator/control plane and independent evidence sink; qualify generator before SUT run | **Proposed — accept** | single process; per-device process/VM; Kubernetes-specific architecture | Supports 6k–12k actors without binding design to one orchestrator; makes generator saturation visible | Verification/Lab Operations | agent resource curve, orchestration platform, or evidence bottleneck changes |
| ADR-17-005 — Windows fidelity cohort | Use a small exact Windows cohort for mTLS, proxy/network, identity, compression, timing, service lifecycle, and compatibility checks; do not use it as the scale generator | **Proposed — accept** | all Linux/headless; 6k Windows VMs | Separates platform fidelity from scale and cost; predecessor evidence requires exact Windows proof | Windows Compatibility/Endpoint Platform | new Windows/network/identity tuple or fidelity mismatch |
| ADR-17-006 — workload/scenario contract | Store every scenario as strict immutable input with seed, distributions, correlations, faults, expected truth, safety limits, and expiry | **Proposed — accept** | ad hoc scripts; dashboard-defined load; operator manual timing | Reproducibility, reviewability, privacy classification, and stop behavior require a versioned contract | Verification Architecture | scenario schema or approved workload change |
| ADR-17-007 — safe measurements and observability | Adopt closed metadata-only measurement schema, finite labels, per-run high-cardinality evidence, and cardinality budgets | **Proposed — accept** | raw request/activity logs; dynamic device/realm labels; vendor auto-instrumentation defaults | Aligns with endpoint minimization and OpenTelemetry guidance that prevention starts with not collecting sensitive data | Observability/SRE with Privacy | new signal/use case, backend/tool change, cardinality incident |
| ADR-17-008 — relational inbox benchmark | Keep the relational durable inbox as default and benchmark PostgreSQL and SQL Server through identical semantic and complete-workload rounds | **Proposed — accept** | select PostgreSQL by target preference; select SQL Server by legacy familiarity; broker first | Accepted baseline requires measurement; two-round protocol separates semantics from engine-specific fitness | Server Architecture/Database Operations | schema/workload/objective/engine version or operations model change |
| ADR-17-009 — worker lease/fairness | Use bounded transactional leases, idempotent final effects, poison quarantine, and explicit fair scheduling by realm/partition | **Proposed — accept logical model** | one global FIFO; unbounded retry; first-come polling | Contains poison and reconnect storms and makes fairness measurable; exact SQL is adapter-specific | Data Processing/Data Reliability | fairness policy, queue schema, consumer topology, or fault counterexample |
| ADR-17-010 — primary capacity gate | Require measured tails, recovery, agreed headroom, complete 6k/12k/72h/restore evidence, and generator validity before capacity approval | **Proposed — accept** | steady average throughput gate; endpoint-count gate; short smoke test | Directly implements the prompt’s primary gate and prevents false confidence from average TPS | Architecture Forum with Product Risk/SRE | objective or mandatory-scenario change |
| ADR-17-011 — broker break-even | Do not add a broker unless a quantified trigger in §9.4 is crossed and P17-06/E17-13 passes | **Proposed — accept** | broker by default; broker never; technology preference | Preserves simplest design and creates falsifiable conditions for change | Architecture Forum/Data Reliability | approved trigger values, measured relational failure, new fan-out/topology requirement |
| ADR-17-012 — restore in capacity gate | Treat backup/restore/catch-up/readiness as a capacity and engine-selection requirement, not a later operational afterthought | **Proposed — accept** | benchmark throughput only; backup check separate | A database that cannot restore within approved objectives is not fit regardless of TPS | Data Reliability/Database Operations | backup topology, RPO/RTO, engine/storage change |
| ADR-17-013 — cost/skills/operations comparison | Choose engine/broker only with comparable three-year cost ranges, skills, support, patching, on-call, restore, and migration evidence | **Proposed — accept** | license list price; cloud calculator; benchmark winner alone | Operational capacity and incident recovery are part of fitness | Product/Finance/Operations/Procurement | commercial/support/hosting/team change |
| ADR-17-014 — evidence expiry | Bind capacity evidence to exact release/contracts/schema/engine/runtime/hardware/query/workload and expire it on material changes | **Proposed — accept** | timeless benchmark number; major-version-only validity | Fast-moving dependencies and workload changes invalidate performance conclusions | Release/Compatibility Authority | any bound input, incident, or expiry changes |
| ADR-17-015 — overload and kill controls | Implement signed/release-owned narrowing controls for global/realm ingestion, workers, queries, policy fanout, batch size/concurrency, and diagnostics | **Proposed — accept properties** | operator SQL edits; tenant broadening; automatic drop | Supports containment without changing custody or privacy semantics | Operations/Security/Product Authority | control-artifact profile or incident change |

# 13. Ordered implementation backlog with dependencies and stop gates

## 13.1 Critical path

| Order | Work item | Dependencies | Deliverable/evidence | Stop gate |
|---:|---|---|---|---|
| 1 | Record the seven-file Prompt 17 evidence manifest and public-source review plan | none | immutable input manifest and allowlist test | Missing, changed, or unallowlisted Project evidence |
| 2 | Create ADR-17-001 through ADR-17-015 and owner placeholders | 1 | ADR files with status/owner/review trigger | No implementation may silently choose an open human decision |
| 3 | Create the human-decision register and conservative disabled/T1 defaults | 2 | machine-readable decision index | Any production-shaped behavior enabled by an unresolved decision |
| 4 | Implement strict capacity variable/distribution/unit schema | Batch 01 contracts, 1–3 | model compiler, dimensional checks, invalid vectors | Unit/provenance/estimate ambiguity survives |
| 5 | Implement strict scenario/workload/fault/evidence schemas | 4 | JSON/YAML schemas, canonicalizer, validator, golden/hostile vectors | Unknown field, unbounded value, remote ref, or nondeterministic canonical input |
| 6 | Define production simulator adapter interfaces and architecture rules | endpoint/server contracts, 4–5 | `IEndpointUploadAdapter`, clock/PRNG/state interfaces, dependency tests | Simulator-local serializer/receipt/retry logic is possible |
| 7 | Implement deterministic UUID/state/PRNG and fictional distribution library | 4–6 | seed vectors, collision/replay tests, correlation support | Same seed differs or identities collide |
| 8 | Implement stateful device actor and endpoint backlog/retry/receipt model | 6–7, accepted Batch 02/03 contracts | actor state machine with independent truth ledger | Endpoint invariant or receipt semantics diverge |
| 9 | Implement open-arrival scheduler and offered-load ledger | 5–8 | schedule independent of completion, start-delay/drop evidence | Closed-loop pacing is the only load mechanism |
| 10 | Implement headless load agent with bounded resources and safe telemetry | 8–9 | agent executable, production adapter, local evidence buffer | Raw values/dynamic labels or unbounded per-device objects |
| 11 | Implement orchestrator/control plane and agent partitioning/rebalancing | 9–10 | deterministic partition maps, run lifecycle, cancellation, cleanup | Rebalance changes actor identity/state or hides arrivals |
| 12 | Implement private null/custody emulator for generator qualification | 6–11 | deterministic receipt/no-custody/ambiguity emulator | Emulator is used as server capacity evidence |
| 13 | Implement evidence sink, manifest, canary, cardinality and accessible report tools | 5–12 | immutable evidence root and gate-summary renderer | Evidence export throttles load or canaries/cardinality controls fail |
| 14 | Run E17-00 through E17-03 | 1–13 | inputs, model, conformance and generator evidence | Any failed mandatory mutation or generator invalidity |
| 15 | Implement safe metadata-only measurement collector, disabled by default | 4–5, privacy review | strict closed collector and deletion tool | Raw/stable identity field representable or collection can run without approval |
| 16 | Obtain decision on permitted measurement cohort/fields | HD-17-06/07 | approved manifest or explicit synthetic-only record | No legacy/pilot connection without approval |
| 17 | If approved, run E17-04 and update distribution package | 15–16 | safe summary, lineage, expiry/deletion evidence | Any unapproved/raw value or cleanup failure |
| 18 | Freeze logical server inbox/lease/receipt/poison benchmark contract | accepted server baseline, 4–8 | engine-neutral schema and truth vectors | Engine-specific feature changes business semantics |
| 19 | Implement PostgreSQL benchmark adapter | 18, dependency admission | DDL/transactions/leases/metrics/restore hooks | Semantic invariant or source/license/operations gap |
| 20 | Implement SQL Server benchmark adapter | 18, dependency admission | DDL/transactions/leases/metrics/restore hooks | Semantic invariant or license/operations gap |
| 21 | Implement independent database truth/checker and fault controller | 18–20 | exact custody/effect/realm/lease checks, deterministic faults | Checker shares adapter decision code or fault tool defines truth |
| 22 | Run E17-05 semantic parity on both engines | 19–21 | semantic parity evidence | Any primary invariant failure blocks performance comparison |
| 23 | Create complete T1 workload package: event/byte/batch/retry/outage/query/retention/policy | 4–8, 17 or synthetic default | immutable workload root and oracle | Missing correlation/provenance or hidden production value |
| 24 | Implement safe server/API/DB instrumentation and cardinality lints | 13, 18–23 | closed metric catalogue, plan/wait/storage collectors | Sensitive/dynamic label or instrumentation changes semantics |
| 25 | Implement scenario S17-01 through S17-14 and smallest prototypes P17-01 through P17-06 | 8–24 | executable scenario catalogue | A mandatory failure cannot be represented/detected |
| 26 | Provision identical benchmark environments and capture cost/resource classes | human lab authority, 19–25 | environment manifests, isolated secrets, cleanup plans | Environments materially incomparable or unidentified |
| 27 | Run P17-01/P17-02 and E17-06 6k semantic/complete-workload matrix | 14, 22–26 | per-engine 6k evidence | Generator invalid, primary failure, or incomplete workload |
| 28 | Tune each engine only through reviewed best-supported design round | passed semantic parity and first 6k | configuration/index/partition/maintenance ADR evidence | Tuning changes contract, hides faults, or is not operable |
| 29 | Rerun full 6k matrix on tuned designs | 28 | final 6k comparative evidence | Selective scenario rerun or stale evidence |
| 30 | Run E17-07 12k saturation and identify sustainable envelope/knee | 29 | capacity curves and bottleneck evidence | Generator knee or safety reserve reached first |
| 31 | Run E17-11 query/retention/maintenance interference at selected scales | 29–30, HD-17-08/09 or explicit T1 corpus | mixed-workload evidence | Throughput result excludes approved query/maintenance work |
| 32 | Run E17-09 reconnect/fault/poison/slow-DB campaigns | 29–31 | recovery/fairness/ambiguity evidence | Duplicate/loss/starvation/unbounded retry or cleanup failure |
| 33 | Run E17-10 backup/restore/catch-up on both engines | 29–32 | restore/readiness evidence and measured phases | Acknowledged custody mismatch or manual undocumented repair |
| 34 | Record human outage/recovery/SLO/headroom decisions | evidence from 27–33, HD-17-01–04/14/15 | approved objectives and exact gate inputs | Capacity approval remains blocked while any is absent |
| 35 | Run final objective-bound 6k recovery/headroom matrix | 34 | measured pass/fail against approved objectives | Any stage lacks headroom or recovery feasibility |
| 36 | Select provisional candidate engine for soak, without production approval | 27–35 plus operations evidence | architecture-forum candidate record | Benchmark winner chosen without restore/skills/license/cost |
| 37 | Run E17-08 72-hour soak on candidate and fallback where risk warrants | 36 | soak evidence and drift analysis | Any primary failure, drift, restart, or evidence/cardinality issue |
| 38 | Run E17-12 cost/skills/license/operations comparison | 27–37, HD-17-05/18/19 | comparable TCO/sensitivity and operating model | Omitted material cost or unassigned critical function |
| 39 | Decide production database engine or retain measurement hold | 38, HD-17-12 | accepted ADR or explicit no-decision | No production schema commitment without complete gate |
| 40 | Evaluate broker trigger arithmetic | 29–39, HD-17-13 | signed trigger record: none crossed or named trigger crossed | Endpoint count/popularity cannot open prototype |
| 41 | If and only if triggered, implement/run P17-06 and E17-13 | accepted trigger, broker dependency/ops approval | conditional broker evidence | Any hard disqualifier or immaterial improvement |
| 42 | Implement gate aggregator and run E17-14 | all required evidence/decisions | `capacity-gate.json` | Missing/expired evidence, failed invariant, unknown objective, or cleanup failure |
| 43 | Architecture/human review of capacity gate and residual risk | 42 | decision record, `productionApproved=false` | No implementation baseline update without explicit acceptance |
| 44 | Convert accepted result into repository tasks, alerts, runbooks, recurring qualification, and procurement plan | 43 | implementation backlog and evidence cadence | Provisional threshold becomes production default silently |
| 45 | Proceed to integrated server batch review and later pilot/production gates | accepted Batch 04 review and human authority | reviewed cross-topic result | This topic result alone cannot authorize production |

## 13.2 Parallel work

After contracts and schemas exist, these lanes may run in parallel:

- deterministic fleet actor, open-arrival scheduler, and generator qualification;
- PostgreSQL and SQL Server adapter implementation against the same logical contract;
- T1 workload/scenario/oracle construction;
- safe observability/cardinality tools;
- disconnected Windows fidelity-cohort preparation;
- safe measurement-collector implementation, while collection itself stays disabled pending approval;
- cost/skills/license template preparation without selecting a technology.

These may not be pulled forward:

- performance comparison before semantic parity;
- 6k/12k claims before generator qualification;
- engine selection before restore, query/maintenance, cost, skills, and licensing evidence;
- production capacity approval before outage/recovery/SLO/headroom decisions;
- broker implementation before a measured trigger;
- live/pilot measurement before governance approval;
- production use before the eventual Batch 04 review, applicable later gates, and designated human approval.

## 13.3 Required runbooks and ownership

Before the capacity gate can pass, the repository MUST contain exercised T1 runbooks for:

1. generator saturation or evidence-pipeline distortion;
2. reconnect/retry storm and realm fairness degradation;
3. ingress overload and global/realm kill switch;
4. database slow, unavailable, failed-over, or log/disk pressure;
5. poison/quarantine containment and release;
6. false/mismatched/ambiguous receipt incident;
7. worker lease expiry, duplicate processing, and stuck backlog;
8. plan/index/statistics regression;
9. backup failure, restore, catch-up, and readiness withholding;
10. metric-cardinality or sensitive-observability escape;
11. simulator/fixture/oracle defect and evidence invalidation;
12. broker-trigger review and, if applicable, broker rollback/decommission;
13. synthetic data/evidence expiry and cleanup failure;
14. cost/license/support assumption change.

Every runbook names trigger, detection, authority, containment, evidence preservation, rollback/recovery, cleanup, re-enable criteria, and neighboring scenarios/gates that must be rerun.


# 14. Open-source repository assessment table

## 14.1 Assessment method

**RECOMMENDATION.** UAM should own the fleet actor, workload package, production-wire adapter, truth checker, evidence format, and broker decision arithmetic. External projects are useful as independent design inputs and regression sources, but none reviewed here has the same combination of per-installation identity, bounded HTTPS batches, durable-custody receipts, whole-device offline state, realm isolation, privacy-safe diagnostics, and one-final-effect semantics.

A project is not admitted because it is popular, recent, or benchmark-oriented. Admission requires an immutable revision, exact package/binary-to-source mapping, license and procurement approval, security and maintenance review, tests that cover the selected use, isolated execution, SBOM/provenance, positive and negative controls, an accountable owner, and a removal path. The classification in this section is therefore one of:

- **dependency candidate** — may be trialled only after the repository admission gate;
- **test-only candidate** — may run in an isolated T1 lane but is not production code or the semantic oracle;
- **reference only** — ideas and regressions may inform UAM tests; no source, package, service, or architecture is adopted;
- **neither / no-go as reviewed** — a material provenance, license, maintenance, security, or threat-model mismatch blocks use.

## 14.2 Repository assessment

| Repository and exact revision reviewed | Relevant files/directories | License and compatibility concerns | Maintenance, testing, and security posture | Architectural similarity and threat-model difference | Reusable ideas / ideas that MUST NOT be copied | Suitability |
|---|---|---|---|---|---|---|
| [Grafana k6 `v2.1.0`](https://github.com/grafana/k6/tree/v2.1.0), release commit [`83a87a41e2c56eedbadbab4001dc11fe78d95942`](https://github.com/grafana/k6/commit/83a87a41e2c56eedbadbab4001dc11fe78d95942); released 30 June 2026; release page reviewed 31 July 2026 | `.github/`, `api/v1/`, `cmd/`, `docs/`, `examples/`, `internal/`, `lib/`, `metrics/`, `openspec/`, `output/`; [constant-arrival-rate documentation](https://grafana.com/docs/k6/latest/using-k6/scenarios/executors/constant-arrival-rate/) | AGPL-3.0. Any execution, modification, distribution, embedded extension, managed service, or output-integration plan requires Legal review. Go/JavaScript and its extension ecosystem do not match the accepted C#/.NET family. | Active 2026 release, large test/build surface, contribution/support/security documentation, signed release commit. Its breadth and extension surface increase dependency and configuration assurance work. | Strong reference for open-arrival scheduling: iterations begin independently of system response. It is primarily request/iteration oriented and does not own UAM device backlog, persistent retry state, receipt ambiguity, realm fairness, or production serializer identity. | Reuse the open-arrival concept, dropped-start accounting, separate offered versus achieved load, threshold/report patterns, and generator-capacity checks. Do **not** replace the UAM stateful actor, use JavaScript as the production contract oracle, infer fleet identity from VUs, or rely on k6 summary percentiles as complete evidence. | **Reference only initially.** Optional independent HTTP open-arrival cross-check after license and dependency admission; not the core simulator. |
| [NBomber `v6.5.0`](https://github.com/PragmaticFlow/NBomber/tree/v6.5.0), release commit [`68aa75d12fde2fccd5d9ef50b5212d21ffc53b6e`](https://github.com/PragmaticFlow/NBomber/commit/68aa75d12fde2fccd5d9ef50b5212d21ffc53b6e); release page reviewed 31 July 2026, released 15 July 2026 | `.github/workflows/`, `examples/`, `performance/`, `src/NBomber/`; [open/closed load-model documentation](https://nbomber.com/docs/nbomber/load-simulation/) | Public source does not mean free organizational use. The reviewed [license documentation](https://github.com/PragmaticFlow/NBomber.Docs/blob/dev/docs/getting-started/license.md) states that free use is personal only and organizations need a Business or Enterprise license. The license page is on mutable `dev`, so exact commercial terms must be obtained from the vendor and Procurement. | Recent release; repository has workflows, examples, a performance solution, and core source. The release notes state that cluster and runner tests were made deterministic. A dedicated repository security policy was not established from the reviewed tag page. | C#/.NET, open and closed load models, cluster coordination, and reports are close to the implementation environment. Its generic virtual-user/scenario model still lacks UAM’s durable device state, one-final-effect receipt oracle, exact realm fairness, and safe evidence restrictions. | Reuse load-model terminology, deterministic runner-test lessons, report accessibility ideas, and an independent C# arrival-rate comparison. Do **not** import its licensing assumptions, cluster control plane, report sinks, dynamic scenario model, or treat successful iterations as durable custody. | **Reference only / procurement-gated.** Not a dependency until exact commercial rights, offline-license behavior, security posture, package mapping, and removal path are accepted. |
| [Shopify Toxiproxy `v2.12.0`](https://github.com/Shopify/toxiproxy/tree/v2.12.0), commit [`3ccd6a79cbc6c6a72b884d295ad314b75cdf3962`](https://github.com/Shopify/toxiproxy/commit/3ccd6a79cbc6c6a72b884d295ad314b75cdf3962); release page reviewed 31 July 2026, released 18 March 2025 | `client/`, `toxics/`, `.github/`, `api_test.go`, `proxy_test.go`, `stream_test.go`, `METRICS.md`, `SECURITY.md`, release/build files | MIT. Exact test binary, container/image digest, Go toolchain, transitive packages, listening interfaces, admin API exposure, and cleanup still require admission. It must never be reachable from production or an untrusted network. | Maintained release with tests, signed tag/commit, security policy, metrics, and explicit development/test instructions. Its own performance numbers are not UAM evidence. | Good at TCP-level latency, bandwidth, reset, timeout, slicing, and intermittent fault injection. It cannot know whether the server committed an inbox transaction, whether a receipt is authentic, or whether a retry creates one business effect. | Reuse deterministic network toxic profiles, private control API, fault timelines, and cleanup verification. Do **not** use proxy response loss as proof of custody, expose its admin API, run it in production, or replace application-level receipt/status fault injection. | **Test-only dependency candidate** after admission. Pair every load-bearing toxic with a UAM semantic checker and, where needed, a real network/process fault. |
| [Azure IoT Telemetry Simulator `1.15.0`](https://github.com/Azure-Samples/Iot-Telemetry-Simulator/tree/1.15.0), commit [`e47561951c54bab746e90279590f8b23cef4d265`](https://github.com/Azure-Samples/Iot-Telemetry-Simulator/commit/e47561951c54bab746e90279590f8b23cef4d265); released 9 March 2023; tag/release page reviewed 31 July 2026 | `charts/iot-telemetry-simulator/`, `src/`, `test/IotTelemetrySimulator.Test/`, `AUTOMATION.md`, `SECURITY.md`, `SimulatorCloudRunner.ps1`, fixture/config files | MIT files are present, but deployment examples use Azure service connection strings/SAS credentials and cloud/container infrastructure. Those patterns conflict with UAM’s no-fleet-secret, per-installation identity, no-production-credential-in-tests, and HTTPS-batch boundary. | Repository has a security policy, tests, automation, Helm/cloud material, and a tagged release; the release commit’s signing key is shown as expired, so tag verification must not be treated as current release assurance. | Useful example of partitioning many synthetic devices across processes/containers, payload distributions, variable intervals, and deliberate duplicates. It multiplexes roughly 995 simulated devices per AMQP connection and targets IoT Hub/Event Hub/Kafka, which is a different identity, connection, receipt, and failure model. | Reuse device partitioning, configurable distributions, synthetic duplicate injection, and explicit cleanup of cloud runners. Do **not** copy shared connection strings, AMQP multiplexing assumptions, device-name authority, generic templates containing machine identifiers, or cloud-service success semantics. | **Reference only.** No package, image, credential model, or deployment script should be adopted for UAM. |
| [`pg-boss` `12.26.3`](https://github.com/timgit/pg-boss/tree/12.26.3), commit [`b98853bf67032ccca996edfa675d0c07c6182369`](https://github.com/timgit/pg-boss/commit/b98853bf67032ccca996edfa675d0c07c6182369); release page reviewed 31 July 2026, displayed release date 24 July 2026 | `.github/`, `docs/`, `examples/`, `packages/`, `scripts/`, `src/`, `test/`, query/schema code, Docker test files | MIT. Node.js and framework APIs do not match the accepted implementation family or server module boundary. No dedicated security policy was established from the reviewed tag page. | Active release and substantial tests. The reviewed release fixed a severe `groupConcurrency` fetch-plan regression in which a reported fetch rose from 4 ms to 400 ms and database CPU reached 100 percent. | Relational job claiming, retries, grouping, and maintenance are relevant to a leased inbox. UAM’s receipt, realm, poison, materialization, audit, and one-final-effect semantics remain stricter and engine-neutral; a library’s “exactly once” wording is not UAM proof. | Reuse the regression as a mandatory test: saturated realm/group ahead of eligible work, stale statistics, plan-shape monitoring, CPU knee, and fairness. Reuse schema/query-review ideas only. Do **not** adopt Node.js, framework migrations, implicit retention, library retry semantics, or a framework claim as the custody oracle. | **Reference only.** Valuable queue/inbox benchmark and regression source; not a UAM dependency. |
| [JasperFx Wolverine `V6.24.2`](https://github.com/JasperFx/wolverine/tree/V6.24.2), commit [`d49a1f5b472aa4b2765528503337ce0ce131e744`](https://github.com/JasperFx/wolverine/commit/d49a1f5b472aa4b2765528503337ce0ce131e744); release page reviewed 31 July 2026, displayed release date 30 July 2026. Operational regressions also reviewed in [`V6.24.1`](https://github.com/JasperFx/wolverine/releases/tag/V6.24.1). | `.github/`, `build/`, `docker/`, `docs/`, `repro/`, `src/`, release/performance plans, relational and transport test projects | MIT repository. It is a broad messaging, durability, transport, scheduling, and integration framework whose authority and dependency surface are much larger than the narrow UAM modular-monolith inbox. No dedicated security policy was established from the reviewed tag page. | Very active 2026 releases and extensive source/test/reproduction material. `V6.24.1` documents a diagnostic table that reached 36,135,221 rows/16 GB in five days because age-only pruning did not bound a high-rate table, plus catch-up/ownership fixes. | Relational inbox/outbox, workers, catch-up, dead-lettering, and multi-tenancy are relevant. The framework also spans brokers, transports, dynamic handlers, and operational conventions not authorized for the first UAM server. | Reuse bounded-row **and** bounded-age retention tests, pruning-cadence tests, one-writer/owner catch-up tests, dead-letter expiration tests, and real production-reproduction discipline. Do **not** copy the framework architecture, dynamic handler discovery, broker abstractions, generic message semantics, automatic schema ownership, or diagnostic retention defaults. | **Reference only.** The regressions are mandatory test inputs; framework adoption is rejected for the initial server. |
| [PostgreSQL source `REL_18_4`](https://github.com/postgres/postgres/tree/REL_18_4), stable release 18.4 dated 14 May 2026 | `src/bin/pgbench/`, `src/backend/`, `src/test/`, `doc/src/sgml/`, regression/isolation tests, server monitoring code | PostgreSQL License. Production binaries, extensions, packaging, OS images, support providers, and operations still require exact admission. Source license does not prove UAM capacity or supportability. | Current stable major 18 release line with extensive regression, isolation, recovery, and source tests plus a documented security and versioning process. | PostgreSQL is the accepted reference database candidate, not the simulator architecture. `pgbench` can generate database sessions/scripts but cannot reproduce UAM HTTPS identity, compression, receipt, poison, realm fairness, worker/business semantics, or portal queries by itself. | Reuse official monitoring views, `pgbench` only as a supplemental engine baseline, isolation/regression test styles, and exact source-tag capture. Do **not** use stock `pgbench` TPS as UAM capacity, select PostgreSQL from popularity, or add extensions without identical benchmark and operations evidence. | **Database candidate and normative engine reference.** `pgbench` is **supplemental only**; the UAM production-contract simulator remains authoritative. |

## 14.3 Consolidated adoption decision

**RECOMMENDATION.** Build the core simulator in the governed UAM repository. The only immediately credible external executable candidate is Toxiproxy in an isolated lab lane after admission. k6 and NBomber may provide independent open-arrival comparisons, but neither should own device state or truth. The Azure simulator, pg-boss, and Wolverine are reference-only regression sources. PostgreSQL source and official tools support the database candidate but do not decide fitness.

Popularity and headline throughput are explicitly excluded from the decision. The most valuable external evidence is negative: queue plans can collapse under skew, age-only retention can grow without bound at high rates, broad frameworks can acknowledge or prune under semantics unlike UAM, and a load generator can hide saturation unless offered load and dropped starts are measured independently.

# 15. Source register with stable links, dates, versions, claims, and limitations

## 15.1 Supplied project evidence

The internal sources below were the only Project files used. They are sanitized architecture evidence, not links to raw internal systems.

| Ref | Source and reviewed version/date | Claim supported | Limitation |
|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md`, baseline date 31 July 2026, SHA-256 `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Accepted endpoint/server boundary, bounded authenticated batches, narrow receipt meaning, relational inbox, modular monolith, no-broker default, database candidates, realm and restore invariants | Condensed working baseline; no production authority, measured volume, performance, cost, or operations proof |
| I02 | `04-data-and-schema-evidence-summary.md`, reviewed 31 July 2026, SHA-256 `1ed93b3d60d37da96c1f67e401deb10c9d57736e4f4dbfa26e16760bd2a19ce6` | Target concepts and the explicit absence of representative event, byte, batch, retry, outage, retention, query, RPO/RTO, and engine evidence | Schema shape and principles do not imply throughput, retention, payload size, or future capacity |
| I03 | `05-decisions-contradictions-and-gates.md`, reviewed 31 July 2026, SHA-256 `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | Relational durable inbox and no-broker default; ordered proof gates for inbox, capacity, long-outage/backpressure, deletion, and restore | Implementation-research authority only; passing one gate proves only its claim |
| I04 | `06-research-evidence-rules.md`, reviewed 31 July 2026, SHA-256 `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | Evidence vocabulary, primary-source preference, human-authority boundary, sanitization, and explicit conflict handling | Research-quality rule, not evidence that a platform or design works |
| I05 | `result-review-01-foundations.md` (local `batch-01-review-result(3).md`), review date 31 July 2026, SHA-256 `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | Strict contracts, independent oracle, UUIDv7 identities, receipt-state distinction, realm isolation, safe metrics, repository and dependency gates | Foundation architecture accepted with conditions; no server capacity, restore, cost, or operations result |
| I06 | `result-review-02-endpoint-data.md`, review date 31 July 2026, SHA-256 `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | Whole-page progress, version-independent natural identity, interpretation lineage, raw-value boundary, and privacy-safe observability | Endpoint source/privacy architecture; no central workload distributions or server benchmark |
| I07 | `result-review-03-durability-release-identity.md`, review date 31 July 2026, SHA-256 `76854c3d6a12b9b717da90d4e368273bd88a672fc64a315afaeacfb3d701a785` | Immutable batches, durable prepared attempts, ambiguous replay, receipt-gated cleanup, deterministic fault evidence, per-install identity, direct mTLS, closed diagnostics, and exact compatibility scope | Architecture accepted but gate open; no production inbox, 6k capacity, restore, or platform support claim |


## 15.2 Current platform and standards sources

All public sources were reviewed on 31 July 2026. Point-in-time versions belong in the evidence manifest and MUST be revalidated at execution time.

| Ref | Stable primary source and source/release date | Reviewed version or subject | Claim supported | Limitation |
|---|---|---|---|---|
| W01 | Microsoft, [.NET and .NET Core support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), last updated 14 July 2026 | .NET 10 LTS, latest listed patch 10.0.10 dated 14 July 2026, support through 14 November 2028 | A current supported .NET line exists for the accepted C#/.NET implementation family; exact patch must be current | Lifecycle status does not prove simulator or server performance; self-contained deployments still require UAM republishing/qualification |
| W02 | PostgreSQL Global Development Group, [PostgreSQL home/release list](https://www.postgresql.org/), reviewed 31 July 2026 | Stable 18.4 released 14 May 2026; PostgreSQL 19 Beta 2 released 16 July 2026 | The identical benchmark should use a supported stable release, not the current beta | Release status does not prove UAM fitness, schema design, restore competence, or cost |
| W03 | PostgreSQL, [`SELECT` documentation for version 18](https://www.postgresql.org/docs/18/sql-select.html) | `FOR UPDATE ... SKIP LOCKED` syntax and semantics | PostgreSQL has a documented primitive suitable for a queue-like lease experiment | `SKIP LOCKED` can produce an inconsistent view; UAM must prove fairness, lease recovery, and one-final-effect semantics rather than infer them |
| W04 | PostgreSQL, [`pgbench` documentation for version 18](https://www.postgresql.org/docs/18/pgbench.html) | Built-in benchmark/script tool | Useful as an engine baseline and calibration aid | It does not exercise UAM production HTTP, identity, serializer, compression, receipt, poison, realm, query, or restore semantics |
| W05 | PostgreSQL, [cumulative statistics documentation for version 18](https://www.postgresql.org/docs/18/monitoring-stats.html) | Official statistics views and monitoring behavior | Supports collection of database waits/activity/I/O/maintenance evidence in the PostgreSQL lane | Monitoring can add overhead and does not replace OS/storage/application evidence |
| W06 | PostgreSQL, [PostgreSQL License](https://www.postgresql.org/about/licence/) | PostgreSQL License | Establishes the core project license for legal review | Packaging, extensions, managed service, support, and operational costs remain separate |
| W07 | Microsoft, [SQL Server 2025 build versions](https://learn.microsoft.com/en-us/troubleshoot/sql/releases/sqlserver-2025/build-versions), reviewed 31 July 2026 | SQL Server 2025 CU7 build 17.0.4065.4 released 16 July 2026; GDR lines also listed | Exact benchmark build and servicing track must be recorded; SQL Server is current enough to benchmark as the serious fallback | Latest build does not select edition, license, support model, or prove UAM capacity |
| W08 | Microsoft, [Table hints — `READPAST`](https://learn.microsoft.com/en-us/sql/t-sql/queries/hints-transact-sql-table?view=sql-server-ver17) | SQL Server 2025 Transact-SQL table-hint behavior | SQL Server has documented row-skipping primitives that can support a leased-worker experiment | Isolation-level restrictions and plan/locking behavior require an exact implementation and fault benchmark |
| W09 | Microsoft, [`OUTPUT` clause](https://learn.microsoft.com/en-us/sql/t-sql/queries/output-clause-transact-sql?view=sql-server-ver17) | SQL Server 2025 DML output behavior | Supports atomic claim/update-return patterns in the SQL Server adapter | `OUTPUT` semantics alone do not prove custody, idempotency, fairness, rollback, or retry safety |
| W10 | Microsoft, [Editions and supported features of SQL Server 2025](https://learn.microsoft.com/en-us/sql/sql-server/editions-and-components-of-sql-server-2025?view=sql-server-ver17) | SQL Server 2025 edition differences | Edition/feature choice is a material benchmark and cost input | Feature availability is not a license quote or procurement approval; exact terms and deployment rights must be reviewed separately |
| W11 | Microsoft, [SQL Server 2025 Enterprise/Standard license terms](https://www.microsoft.com/content/dam/microsoft/usetm/documents/sql-server/sql-server-2025-enterprise%2C-standard/retail/SQL_Server_2025_Standard_Enterprise_English.pdf), last updated 18 November 2025; reviewed 31 July 2026 | Retail license terms document | Confirms licensing is a first-class selection input rather than a benchmark afterthought | Legal/Procurement must interpret actual rights, virtualization, passive instances, and support for the selected deployment; research does not provide legal advice |
| W12 | OpenTelemetry, [Handling sensitive data](https://opentelemetry.io/docs/security/handling-sensitive-data/), last modified 14 January 2026 | Sensitive-data prevention guidance | Supports UAM’s position that the strongest control is not collecting sensitive values and that instrumentation owners remain responsible | OpenTelemetry is broad observability guidance, not a UAM-safe field catalogue or proof that a backend/configuration is private |

## 15.3 Open-source and public repository sources

| Ref | Stable source and review date | Reviewed revision/date | Claim supported | Limitation |
|---|---|---|---|---|
| R01 | [k6 repository at `v2.1.0`](https://github.com/grafana/k6/tree/v2.1.0), [release commit](https://github.com/grafana/k6/commit/83a87a41e2c56eedbadbab4001dc11fe78d95942), and [constant-arrival-rate docs](https://grafana.com/docs/k6/latest/using-k6/scenarios/executors/constant-arrival-rate/) | Release displayed 30 June 2026; commit `83a87a41e2c56eedbadbab4001dc11fe78d95942`; reviewed 31 July 2026 | Open-model iterations start independently of system response; repository contains load, metric, output, test, support, and security material | AGPL-3.0 and Go/JavaScript architecture; not UAM device-state or custody semantics |
| R02 | [NBomber repository `v6.5.0`](https://github.com/PragmaticFlow/NBomber/tree/v6.5.0), [release commit](https://github.com/PragmaticFlow/NBomber/commit/68aa75d12fde2fccd5d9ef50b5212d21ffc53b6e), [load-model docs](https://nbomber.com/docs/nbomber/load-simulation/), and [license page](https://github.com/PragmaticFlow/NBomber.Docs/blob/dev/docs/getting-started/license.md) | Release displayed 15 July 2026; commit `68aa75d12fde2fccd5d9ef50b5212d21ffc53b6e`; reviewed 31 July 2026 | .NET open/closed load models and deterministic runner-test maintenance; organization use is commercially licensed | Mutable license-doc branch, procurement need, generic virtual-user semantics, and unestablished dedicated security policy |
| R03 | [Toxiproxy repository `v2.12.0`](https://github.com/Shopify/toxiproxy/tree/v2.12.0) and [release commit](https://github.com/Shopify/toxiproxy/commit/3ccd6a79cbc6c6a72b884d295ad314b75cdf3962) | Released 18 March 2025; commit `3ccd6a79cbc6c6a72b884d295ad314b75cdf3962`; reviewed 31 July 2026 | Deterministic TCP fault profiles, tests, metrics, and security policy | TCP fault tool only; cannot determine application custody or business effect; test-lab use only |
| R04 | [Azure IoT Telemetry Simulator `1.15.0`](https://github.com/Azure-Samples/Iot-Telemetry-Simulator/tree/1.15.0) and [reviewed commit](https://github.com/Azure-Samples/Iot-Telemetry-Simulator/commit/e47561951c54bab746e90279590f8b23cef4d265) | Released 9 March 2023; commit `e47561951c54bab746e90279590f8b23cef4d265`; reviewed 31 July 2026 | Device partitioning, intervals, payload distributions, deliberate duplicates, tests and automation | AMQP/cloud/shared-secret model differs materially; release signing key shown expired; reference only |
| R05 | [`pg-boss` `12.26.3`](https://github.com/timgit/pg-boss/tree/12.26.3), [release](https://github.com/timgit/pg-boss/releases/tag/12.26.3), and [reviewed commit](https://github.com/timgit/pg-boss/commit/b98853bf67032ccca996edfa675d0c07c6182369) | Release displayed 24 July 2026; commit `b98853bf67032ccca996edfa675d0c07c6182369`; reviewed 31 July 2026 | Concrete queue-fetch plan regression under backlog/skew; source/tests for a PostgreSQL queue | Node.js library and its semantics are not UAM; no dedicated security policy established; reference only |
| R06 | [Wolverine `V6.24.2`](https://github.com/JasperFx/wolverine/tree/V6.24.2), [release commit](https://github.com/JasperFx/wolverine/commit/d49a1f5b472aa4b2765528503337ce0ce131e744), and [`V6.24.1` regression notes](https://github.com/JasperFx/wolverine/releases/tag/V6.24.1) | `V6.24.2` displayed 30 July 2026; commit `d49a1f5b472aa4b2765528503337ce0ce131e744`; reviewed 31 July 2026 | Real retention, diagnostic-table growth, catch-up, and ownership regressions useful for UAM tests | Broad framework scope and semantics; no dedicated security policy established; reference only |
| R07 | [PostgreSQL source `REL_18_4`](https://github.com/postgres/postgres/tree/REL_18_4) | Stable tag for release 18.4, released 14 May 2026 | Exact source point, tests, official benchmark source, and engine internals for the reference lane | Engine source does not prove selected packaging, configuration, hardware, operations, or UAM fitness |

## 15.4 Source-quality conclusions

1. **FACT.** The supplied project evidence establishes architecture and missing-evidence boundaries, not capacity numbers.
2. **FACT.** PostgreSQL and SQL Server both document relational primitives that can implement a leased inbox. Capability is not UAM-specific fitness; the identical semantic, load, fault, query, restore, cost, and operations benchmark remains mandatory.
3. **FACT.** Open-arrival generators explicitly separate arrival rate from system response. UAM must also preserve long-lived device state; therefore a combined stateful-actor/open-arrival design is required.
4. **INFERENCE.** Queue framework regressions show that skewed backlog, stale statistics, diagnostic retention, and catch-up ownership are load-bearing test dimensions, not incidental implementation details.
5. **RECOMMENDATION.** Mutable branches, short commit prefixes without a stable target, package/source gaps, absent license clarity, or absent security ownership are no-go for executable gate use.
6. **RECOMMENDATION.** Every execution-time dependency/version refresh reopens the affected conformance, generator, performance, fault, restore, cardinality, and cost evidence. This source register must not be treated as a timeless upgrade list.

# 16. Confidence table for every major conclusion

Confidence describes the strength of the architectural conclusion, not production readiness. A **High** conclusion can still require a CLI experiment because documentation and reasoning do not establish the behavior of the composed UAM system.

| Major conclusion | Confidence | Why | Evidence that would change it |
|---|---|---|---|
| Capacity must be modeled from events, bytes, batches, retries, outages, queries, retention, recovery, and cost—not endpoint count alone | **High** | The allowlisted evidence explicitly lacks these distributions, and the formulas show that the same 6,000 endpoints can create radically different work | A validated simpler predictor that bounds all accepted workload/failure dimensions and passes the same tails/recovery tests |
| The formula model in section 5 is the correct planning structure | **High** | Units and conservation equations cover offered work, custody, backlog, drain, storage/log, queries, and cost with replaceable inputs | A falsifying workload showing a material resource/failure dimension cannot be represented without hidden assumptions |
| The core simulator should be UAM-owned and reuse production contracts/serializer/compression/IDs/retry/receipt code | **High** | Contract drift would otherwise make capacity evidence non-transferable; predecessors require exact identity and receipt semantics | Evidence that a third-party tool can consume the exact production adapter while preserving all state, privacy, realm, and evidence rules at lower assurance cost |
| Stateful logical device actors are required | **High** | Offline backlog, retries, ACK ambiguity, rollout state, and per-device fairness are histories, not independent requests | A proven stateless representation that reproduces every actor history and invariant with equivalent shrink/replay evidence |
| Offered load must be scheduled by an open-arrival lane independent of server latency | **High** | Closed loops hide coordinated omission and reduce offered load when the server slows | Generator comparison showing a different mechanism records all intended arrivals, late/dropped starts, and saturation without feedback bias |
| A small Windows fidelity cohort is required in addition to the headless scale lane | **High** | Headless load cannot prove Windows TLS, certificate store, proxy/runtime behavior, production packaging, or process/resource effects | A formally equivalent runtime/network environment with exact production binaries and demonstrated parity across all fidelity checks |
| One machine/process is unlikely to be a trustworthy 12,000-device generator by default | **Medium** | Generator resource capacity is unknown and a single failure domain can distort arrivals/evidence | E17-03/E17-07 showing one exact host sustains all required distributions and reserve with independent timing/evidence validation |
| The relational durable inbox remains the right initial custody boundary | **High at logical level; Medium for performance** | It is accepted baseline and directly supports atomic receipt/uniqueness with the simplest failure domain | Semantic failure, sustainable-throughput failure after reasonable tuning, restore infeasibility, or an external broker prototype that materially improves the named crossed trigger without hard disqualifiers |
| PostgreSQL remains the target reference candidate | **Medium** | Accepted predecessor choice and suitable documented relational primitives/current stable release | Identical benchmark, restore, skills, support, cost, or licensing evidence showing SQL Server materially lower total risk, or PostgreSQL failing a primary invariant |
| SQL Server remains a serious transition/fallback candidate | **Medium** | Current supported version and documented claim/update primitives; likely organizational transition value | License/edition/skills/operations cost, semantic limitation, or benchmark/restore result making it non-viable |
| A production database engine cannot be selected from prose or a microbenchmark | **High** | Engine choice includes semantics, mixed workload, maintenance, restore, operations, skills, license, and cost | No expected evidence should weaken this; a decision can close only after the complete identical gate or an explicit risk-authority exception |
| The exact 6,000-device sustainable envelope is known | **Low / not established** | No executed workload or agreed SLO/headroom inputs exist | Passed E17-00–E17-06 with complete distributions, independent generator qualification, and no primary failure |
| The exact 12,000-device headroom/saturation knee is known | **Low / not established** | No execution evidence exists; generator and server knees are both unknown | Passed E17-07 with measured capacity curves, independent bottleneck attribution, and reproducible evidence |
| A 72-hour soak is necessary before a capacity claim | **High** | Slow storage/index/statistics/retention/cardinality/resource drift can be invisible in short bursts | Stronger evidence that all relevant slow processes are separately bounded and no long-duration state can accumulate; absent that, soak remains required |
| Morning/reconnect and multi-day backlog recovery must be first-class capacity scenarios | **High** | Offline operation and at-least-once retry create burst and recovery work unlike steady state | Approved estate evidence proving these conditions cannot occur, plus a revised maximum-outage human decision |
| Recovery feasibility is governed by positive excess service rate and recovery-window arithmetic | **High** | This follows work conservation: backlog cannot drain when effective service is at or below concurrent arrival | A different queue topology/failure domain that changes the defined work or service boundary; equations would be updated, not ignored |
| Realm fairness must be measured independently from global throughput | **High** | A large realm can dominate a shared lease queue while global percentiles remain acceptable | A proven isolation/scheduling design that mathematically and empirically prevents cross-realm starvation under all allowed workloads |
| Tail latency, wait, lock, log/WAL, backlog age, and restore phases are more decision-relevant than average TPS | **High** | Accepted goals are durability/recovery/fairness, and queueing failures occur in tails and phases | A validated objective that uses another statistic while preserving all tails and failure evidence |
| Safe observability requires a fixed low-cardinality catalogue and evidence side channel | **High** | Dynamic device/realm/source labels would create privacy and cardinality failure; metrics can distort the benchmark | A bounded alternative with formal cardinality proof, equivalent privacy controls, and lower measurement effect |
| Metadata-only legacy/pilot measurement can improve the model without collecting raw activity | **Medium** | Aggregate histograms can replace key estimates, but governance and implementation have not been approved or executed | Approved collector plus T1 canaries, no-raw schema proof, deletion receipt, and representative cohort evidence; or a finding that even aggregates create unacceptable singling-out risk |
| The provisional SLO/headroom thresholds in this report are production commitments | **Low / explicitly false** | They are labelled hypotheses pending human decisions and measurement | Formal owner decisions recorded in the capacity manifest and rerun against exact objectives |
| Restore and catch-up must be part of engine/capacity selection | **High** | A fast running system that cannot restore acknowledged custody or safely catch up fails accepted invariants | No expected evidence should remove this; only a changed durable failure-domain architecture with equivalent recovery proof |
| Cost must include steady, peak, restore, test, observability, support, licenses, and staffing | **High** | Headline compute/storage price omits material operational and failure costs | A procurement/operating model proving omitted categories are zero or externally borne without transferring risk |
| The current need for an external broker is established | **Low / not established** | No measured trigger has been crossed; baseline says no broker by default | A signed trigger record plus P17-06/E17-13 showing material benefit and no hard disqualifier |
| The broker break-even decision table is the correct gate structure | **High** | It requires a named failure/throughput/replay/fan-out/cost trigger and measures benefit against added complexity | A credible trigger class not represented, or a broker design whose value is independent of all listed dimensions; add it explicitly by ADR |
| A broker should be added because there are 6,000 or 12,000 endpoints | **Low / rejected** | Endpoint count does not define arrival rate, bytes, fan-out, backlog, durability, or failure domains | No valid evidence should make count alone sufficient; it can only be one input to measured work |
| k6/NBomber can replace the UAM simulator | **Low** | They model load well but not the complete UAM actor/custody/realm/privacy state and create license/dependency differences | A complete adapter/conformance demonstration preserving every mandatory invariant and evidence rule |
| Toxiproxy is useful as a fault tool | **Medium-High** | It has focused TCP fault capability, tests, and a stable reviewed revision | Admission failure, inability to reproduce required network faults, excessive distortion, or a simpler native harness with better evidence |
| Queue-framework regressions should become UAM regression tests, not dependencies | **High** | pg-boss and Wolverine provide directly relevant failures while their frameworks exceed UAM scope | A future framework-adoption ADR proving lower total risk, exact semantic fit, supportability, license/security admission, and clean removal/migration |
| Production capacity, broker, SLO, RPO/RTO, budget, and deployment are approved by this result | **Low / explicitly false** | These are human decisions and later/integrated gates; this report is implementation research | Only the designated human authorities plus passed current evidence and the eventual Batch 04/integrated gates can change status |

# Final residual risk and next stop/go gate

**Residual risk.** Even after the proposed tests pass, research cannot prove future workload, storage firmware honesty, database defects, security-product interference, administrator error, key/root compromise, human policy quality, cost stability, or behavior after unqualified software/hardware/configuration changes. Synthetic distributions can share a conceptual defect with the implementation; a permitted metadata cohort can be unrepresentative; a 72-hour soak can miss slower drift; a restore drill can miss a different corruption pattern; and relational or broker technology can fail under a workload shape not yet observed. Fail-closed controls can create collection gaps and local backlog, and support without raw activity deliberately limits diagnosis.

The principal operational costs are recurring qualification, two-engine benchmark maintenance until selection, safe fixture/evidence management, Windows fidelity capacity, backup/restore drills, plan/statistics regression surveillance, cardinality control, incident exercises, database and platform skills, licensing/procurement, and the possibility that long outages require endpoint resource or policy decisions outside this topic.

**GO now:** implement the strict formula/input schemas, production-wire adapter, deterministic stateful actors, independent open-arrival scheduler, T1 scenario/oracle package, generator qualification, engine-neutral inbox/worker contracts, PostgreSQL and SQL Server semantic adapters, safe instrumentation, evidence aggregator, and disconnected Windows fidelity cohort. Run E17-00 through E17-05 before treating any throughput result as evidence.

**STOP:** do not select production capacity, database engine, partition/index layout, SLO/error budget, outage/recovery objective, headroom, retention, budget, or external broker from this report. Do not collect a legacy/pilot cohort without the named human approval. Do not issue a production receipt or delete endpoint payload from a synthetic benchmark. Do not infer a production support or deployment decision.

**Next stop/go gate:** the next technical go decision requires E17-00 through E17-06 to pass for the exact 6,000-device complete workload on both relational candidates, with a qualified generator, zero primary invariant failures, complete tails/fairness/resource evidence, and cleanup. The capacity/engine decision remains stopped until the 12,000 saturation curve, 72-hour soak, fault/reconnect campaign, mixed query/maintenance test, backup/restore/catch-up drill, cost/skills/license comparison, and the four mandatory human decisions on maximum outage, recovery objective, SLO/error budget, and headroom are complete. A broker remains prohibited unless the signed break-even trigger is crossed and E17-13 passes without a hard disqualifier.
