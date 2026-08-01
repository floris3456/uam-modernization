# Prompt 10 result — model-based, property-based, fault-injection, and invariant testing

**Result path:** `batches/03-durability-release-identity/10-invariant-fault-testing/result-10-invariant-fault-testing.md`  
**Research date:** 31 July 2026  
**Decision status:** **ACCEPT AS THE VERIFICATION ARCHITECTURE, WITH MANDATORY IMPLEMENTATION AND LAB GATES**  
**Authority boundary:** verification architecture for endpoint session isolation, privacy, source progress, SQLite durability, server custody and idempotency, release rollback, realm isolation, privileged audit, deletion and restore; **not** legal, privacy, budget, staffing, production-SLO, risk-acceptance, pilot, or deployment approval  
**Primary gate:** **Every load-bearing invariant MUST have an automated falsification path or an explicitly owned manual exercise. A test that only mocks away the relevant operating-system, process, file, database, or network boundary does not close the gate.**

## Evidence vocabulary

This result uses the required labels:

- **FACT** — directly supported by an allowlisted supplied result or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from facts; the chain is stated.
- **ESTIMATE** — a numerical hypothesis with replaceable inputs.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, business, support, or production authority is required.
- **CLI EXPERIMENT** — code, lab work, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements are the proposed Prompt 10 implementation baseline. They do not turn a documented tool capability into UAM fitness or a human decision into approval.

## Evidence boundary and file-presence record

**FACT.** All six allowlisted Project inputs were present. The accepted Batch 01 predecessor is stored locally as `batch-01-review-result(3).md`; its title and declared result path identify it as the allowlisted `result-review-01-foundations.md`. No other Project file was opened, searched, quoted, summarized, or used.

| Ref | Allowlisted file | SHA-256 reviewed | Use and limitation |
|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md` | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | accepted topology, privacy, durability, idempotency, realm, release, pressure, audit, deletion, and restore invariants; not runtime proof |
| I02 | `05-decisions-contradictions-and-gates.md` | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | accepted design tensions and ordered proof gates; passing proves only the named claim |
| I03 | `03-sanitized-windows-lab-capability.md` | `8da73d913e7f1b01d943e4c8b0ed7bb2722571ff6a3a20cef0b8f47738a4658f` | a lab connection path exists; no OS, runtime, Edge, session, policy, or hardware behavior is established |
| I04 | `06-research-evidence-rules.md` | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | evidence labels, primary-source preference, human-authority boundary, and conflict discipline |
| I05 | `result-review-01-foundations.md` (local `batch-01-review-result(3).md`) | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | accepted deterministic fictional data, independent oracle, canaries, strict contracts, G1 intent, privacy lattice, monorepo, CI trust zones, and tool corrections |
| I06 | `result-review-02-endpoint-data.md` | `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | accepted source/generation/interpretation separation, native-ID cursor, Task Host privacy boundary, whole-page progress, and G5 transaction handoff; runtime gates remain open |

No accepted-baseline change proposal is raised. This result adds a verification architecture around the accepted decisions without changing their component topology or authority boundaries.

---

## 1. Executive conclusion in easy language, with confidence and residual risk

### 1.1 Decision

**RECOMMENDATION — ACCEPT.** UAM should use one verification system with four deliberately different kinds of evidence:

1. **A UAM-owned executable model** says what states and outcomes are legal. It is independent from production storage, policy, identity, receipt, update, deletion, and materialization code.
2. **Seeded property and model campaigns** generate long command sequences, schedules, values, and faults, then shrink a failure to the smallest reproducible history.
3. **Deterministic internal fault hooks** stop or fail the exact instruction boundary that matters, such as “after the SQLite commit but before ACK.” These hooks exist only in test artifacts.
4. **Real boundary failures** kill processes, exhaust filesystems, reset sockets, suspend workers, restart databases and VMs, perform actual restore drills, and exercise Windows session and token boundaries. These prove that a test double did not hide the behavior under examination.

**INFERENCE.** This layered design is the simplest one that can falsify all accepted load-bearing invariants. Pure model tests are fast enough for every change but cannot establish Windows, SQLite, HTTP, or database behavior. Real failures establish those behaviors but are slower and often not perfectly replayable. Pairing them gives precise localization and realistic evidence without making a general-purpose chaos platform part of UAM.

### 1.2 Load-bearing choices

| Decision | Status | Reason |
|---|---|---|
| UAM owns state models, command/event alphabets, invariant checkers, seed format, shrink policy, and evidence schema | **ACCEPT** | these define UAM semantics and must not drift with a testing library |
| FsCheck stable property-generation APIs are the initial .NET test candidate | **ACCEPT AS TEST CANDIDATE** | current, permissively licensed, C#/.NET fit; experimental model APIs are not made load-bearing |
| A small UAM state-machine runner sits above the generator | **ACCEPT** | makes model semantics and replay independent of FsCheck/Hedgehog internals |
| Production code uses injected `TimeProvider`; tests wrap `FakeTimeProvider` behind a UAM virtual-clock contract | **ACCEPT** | deterministic expiry, retries, leases, rollback windows, and backpressure without wall-clock sleeps |
| Every durability boundary receives stable, enumerated, test-only hooks plus a real-fault companion | **ACCEPT** | exact transaction localization plus OS/database reality |
| Stryker.NET is used first on pure policy, identity, contract, state, and checker modules | **ACCEPT AS TEST CANDIDATE** | validates test sensitivity; current Windows source-generator issue makes interop mutation a later gate |
| Testcontainers .NET and Toxiproxy are trusted-lane server integration candidates | **ACCEPT AS LAB/CI CANDIDATES** | useful disposable databases and deterministic TCP faults; neither proves Windows endpoint behavior |
| SQLite test VFS ideas and PostgreSQL injection points/isolation tests are reference and test-lane mechanisms | **ACCEPT FOR TEST BUILDS** | strong primary examples of deterministic I/O/concurrency fault testing; never production dependencies |
| Microsoft Coyote, Jepsen, FoundationDB simulation, and TigerBeetle VOPR are reference/spike inputs, not default dependencies | **ACCEPT AS REFERENCE ONLY** | valuable ideas, but support, language, threat model, or architecture differs materially |
| SharpFuzz remains no-go until the reviewed package maps exactly to reviewed source | **NO-GO NOW** | unresolved provenance is incompatible with the accepted dependency gate |
| Randomized production chaos is not a default | **REJECT** | privacy, availability, support, and authority cost is not justified; release and pilot faults remain controlled and pre-authorized |

### 1.3 Confidence

- **High confidence** in the architecture: model first, deterministic replay, independent checkers, paired internal and real faults, and lane separation follow directly from the accepted invariants and mature primary-source practices.
- **Medium confidence** in exact tool adoption: versions, provider behavior, .NET patch behavior, Docker/runner capabilities, and Windows lab behavior require execution-time admission and CLI evidence.
- **Low confidence** in physical-lab breadth, production failure rates, campaign duration, and release-blocking budgets because the supplied lab evidence proves only that a connection path exists.

### 1.4 Immediate permission and prohibition

**GO now** for pure models, invariant registry, command/event alphabets, deterministic seed and failure-capsule formats, fictional generators, reference checkers, architecture rules, test-only hook interfaces, component-level fault prototypes, and disconnected placeholder-only lab scripts.

**STOP** before claiming G1, G5, release/update, receipt/idempotency, capacity, long-outage, deletion, or restore proof until the named real-boundary campaign passes. Production builds MUST NOT contain a callable hook controller, fault schedule parser, test credential, destructive lab tool, or route from tenant policy to a fault action.

### 1.5 Residual risk in plain language

Even a strong test system cannot enumerate every Windows scheduling interleaving, storage-device failure, browser change, database bug, operator action, backup defect, or future dependency defect. Model and property tests can also share a mistaken assumption with the implementation. The design contains that risk by using independent checkers, hand-worked examples, mutation testing, two different fault mechanisms at critical boundaries, exact failure capsules, recurring real restore drills, and explicit manual exercises for residuals that cannot be automated safely.

---

## 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

### 2.1 In scope

This result specifies how to falsify:

- Windows user/session/process and IPC isolation;
- privacy-ceiling monotonicity, fail-closed policy state, kill switches, and forbidden-value containment;
- source/generation/native-ID cursor correctness and whole-page semantics;
- SQLite event/no-event/outbox/witness/checkpoint atomicity and stable retry identity;
- server durable custody, receipt replay, validation, quarantine, leased materialization, poison handling, and one final business effect;
- release authenticity, completeness, anti-rollback, staged activation, health failure, and rollback;
- realm isolation for ingestion, queries, administrative mutation, deletion, cache, jobs, and restore;
- privileged mutation plus durable audit atomicity;
- deletion/tombstone behavior, acknowledged replay, backup restore, readiness, and non-resurrection;
- pressure, long outage, bounded resources, and no silent loss;
- test reproducibility, failure evidence, flaky-test policy, coverage limits, and release gates.

### 2.2 Non-goals

**RECOMMENDATION.** This result does not:

- redesign the accepted endpoint, server, database, release, or privacy architecture;
- select the production database engine by prose;
- authorize a broker, self-updater, process collector, path matcher, disk raw scratch, production chaos service, or general policy engine;
- decide purpose, legal basis, prohibited uses, fields, precision, identity, retention, access, employee consultation, SLO/RPO/RTO, budget, staffing, or production approval;
- claim that line coverage, mutation score, a fuzzer run, a container test, `RESTORE VERIFYONLY`, or one VM run proves production reliability;
- require raw production activity, internal URLs, credentials, addresses, personal information, SSH material, or confidential configuration.

### 2.3 Accepted inputs carried forward

| ID | Accepted input | Verification consequence |
|---|---|---|
| A-01 | Coordinator/User Host/Task Host topology and exact-session authority | model and lab histories must include multiple logons, same account/different logon, lock/disconnect, process replacement, peer verification, and cleanup |
| A-02 | minimization before Coordinator IPC, durability, logs, diagnostics, or transport | canary scanner and type/dependency rules are primary invariant tests, not optional privacy checks |
| A-03 | one-writer SQLite WAL with atomic minimized effect and progress | every logical write boundary gets pre/post failpoints and hard process/VM interruption evidence |
| A-04 | native record identity independent of runtime/interpretation; page owns progress | generated histories vary runtime and interpretation without changing natural identity or replaying old native rows |
| A-05 | at-least-once transport and receipt means durable custody only | model distinguishes request, durable inbox commit, response, validation, materialization, and visibility |
| A-06 | relational durable inbox and leased workers | concurrency model includes stale lease fencing, duplicate work, poison isolation, and recovery |
| A-07 | MSI/enterprise deployment owns stable privileged boundary | release model treats optional updater as absent unless separately approved; MSI crash/repair/rollback remains the base lane |
| A-08 | realm/device authority comes from authenticated context | every interface model generates hostile payload realm claims and cross-realm identifiers |
| A-09 | privileged mutation requires durable audit | mutation and audit form one modeled atomic unit or an explicitly gated durable-audit custody protocol |
| A-10 | deletion/restore invariants | restore remains hidden until integrity, custody, tombstone/deletion, realm, and readiness checks pass |
| A-11 | deterministic T1 fixtures, independent oracle, exact canaries, strict contracts, locked repository | failure capsules and test histories contain only fictional/sanitized evidence and exact dependency/tool identities |

### 2.4 Assumptions

- **ASSUMPTION.** Production code can consistently receive time, randomness, storage, transport, process-launch, and identity services through narrow interfaces without violating the accepted boundaries.
- **ASSUMPTION.** Endpoint and server repositories can produce separate test artifacts in which internal hooks are compiled and separate production artifacts in which they are structurally absent.
- **ASSUMPTION.** The modular monolith can keep mutation plus audit in one relational transaction initially. If this proves false, an explicit audit-custody protocol and change ADR are required.
- **ASSUMPTION.** Disposable database instances and disposable/reverted Windows VMs can be made available in trusted test lanes, subject to the required human decision.
- **ASSUMPTION.** All generated records, realms, users, sessions, applications, URLs, keys, certificates, and releases used by this harness are visibly fictional.

### 2.5 Unknowns

- **UNKNOWN.** Supported Windows editions/builds, session technologies, architecture, installed .NET/native SQLite, EDR, proxy/VPN, sleep modes, and available test users.
- **UNKNOWN.** Exact endpoint disk, memory, CPU, handle, batch, retry, and long-outage budgets.
- **UNKNOWN.** Production engine, high-availability topology, failover mode, backup technology, and restore objectives.
- **UNKNOWN.** Exact release rings, rollback observation window, offline grace, device PKI, clock-confidence rules, and updater need.
- **UNKNOWN.** Required campaign depth, tolerated non-load-bearing flakiness, lab hardware breadth, test-run cost, staffing, and support hours.
- **UNKNOWN.** Whether a model checker or concurrency-runtime instrumenter adds enough defect detection beyond the proposed UAM runner to justify its support and supply-chain cost.

---

## 3. Recommended design with exact component responsibilities and trust boundaries

### 3.1 Verification architecture

```text
T1 declarative scenario + invariant registry + root seed
                         |
                         v
             UAM model/generator/scheduler
             |          |             |
             |          |             +--> minimal failing schedule/shrink chain
             |          +----------------> independent history/invariant checker
             +---------------------------> command/event/fault history
                                                    |
                          +-------------------------+--------------------------+
                          |                         |                          |
                          v                         v                          v
                  pure/reference adapter   in-process/component adapter   real-boundary adapter
                  no OS/database           test-only hooks                processes/files/VM/DB/network
                          |                         |                          |
                          +-------------------------+--------------------------+
                                                    |
                                                    v
                     failure capsule + all-sink canary scan + cleanup receipt
```

### 3.2 Components and responsibilities

| Component/project | MUST do | MUST NOT do |
|---|---|---|
| `Uam.Verification.Contracts` | own versioned schemas for invariant registry, commands, events, faults, histories, evidence and failure capsules | reference endpoint/server implementation assemblies |
| `Uam.Verification.Model` | implement immutable pure models for M1–M8; apply commands; emit expected events; state invariants | call clocks, files, sockets, SQL, Windows APIs, random globals, product repositories, or serializers |
| `Uam.Verification.Generators` | derive deterministic domain-separated streams from one root seed; generate legal and hostile commands, actors, values, schedules and faults | use wall-clock seeds, shared mutable `Random`, real identity/data, or conceal rejected generation |
| `Uam.Verification.Scheduler` | choose enabled actors/commands, model barriers, virtual clock advance and quiescence; record every choice | claim deterministic control over OS or database internal scheduling |
| `Uam.Verification.Checkers` | evaluate invariants over operation histories, durable snapshots and evidence; produce minimal counterexample explanations | call production decision code or treat implementation output as expected truth |
| `Uam.Verification.Hooks` | expose stable internal hook IDs and barrier/fail actions in test builds; capture ordinal and causal context | ship a public controller, parse tenant policy, accept network commands, expose raw values, or exist in production manifest |
| `Uam.Verification.EndpointDriver` | drive synthetic Coordinator/User Host/Task Host, SQLite, process lifecycle, IPC, disk and Windows lab adapters | bypass accepted process boundaries or collect real activity |
| `Uam.Verification.ServerDriver` | drive hostile HTTP, durable inbox, PostgreSQL/SQL Server, worker leases, poison, audit, deletion and restore | derive realm from payload or substitute an in-memory store for a database gate |
| `Uam.Verification.ReleaseDriver` | stage fictional signed/test-signed packages, corrupt components, interrupt activation, verify rollback and cleanup | hold production signing authority or modify enterprise deployment outside disposable lab |
| `Uam.Verification.Evidence` | write content-addressed manifest, operation history, snapshots, canary result, shrink chain, environment and cleanup receipt | include credentials, connection data, raw URLs, personal data, internal addresses, or unrestricted dumps |
| `Uam.Verification.Campaign` | define named lanes, seed sets, model coverage, fault coverage, budgets, stop rules and shard ownership | hide retries, replace first failure, or declare success from aggregate percentages while a primary invariant failed |
| `Uam.Verification.Cleanup` | kill test jobs, reset AppVerifier/Driver Verifier settings, remove test services/tasks/rules/certs/files, drop databases and revert VMs | broad-delete user directories or claim pass when cleanup evidence is missing |

### 3.3 Trust boundaries

1. **Production/test artifact boundary.** Test hooks, fault controllers, destructive tools, fictional test keys, and lab helpers are test artifacts. The release file manifest, architecture tests, binary scan, SBOM and startup self-check MUST prove that production artifacts contain no callable hook controller or test schedule parser.
2. **Repository/tenant boundary.** Fault schedules and verification flags are repository-owned T1 evidence. Tenant policy can never enable, parameterize, or discover fault hooks. Product/tenant kill switches remain narrowing safety controls and are tested separately.
3. **Controller/product boundary.** The lab controller may be privileged inside a disposable environment, but product processes do not trust it as a UAM peer. It drives only documented OS/process/service/test surfaces and test-only inherited handles.
4. **Endpoint privacy boundary.** Raw source canaries remain inside the fixed Task Host fixture. The harness observes sinks and outcomes without creating a diagnostics bypass.
5. **Realm boundary.** Model commands may carry hostile claimed realms; the implementation driver supplies authenticated realm/installation context separately. The checker treats payload-derived authority as a defect.
6. **Database boundary.** The in-process model predicts semantics; real database lanes decide actual transaction, locking, restart, restore, and isolation fitness.
7. **Evidence boundary.** Raw ETW/ProcMon/dumps may remain restricted in a disposable lab where approved. Shareable evidence contains normalized operation classes, counts, digests, finite reason codes and T1 identifiers only.

### 3.4 Model-first workflow

**RECOMMENDATION.** Every feature that changes a load-bearing state machine follows this order:

1. add or change the invariant in `invariants.yaml`;
2. update the pure state and command/event alphabet;
3. add hand-worked positive and negative histories;
4. add generators and shrinkers;
5. add implementation adapter behavior;
6. place deterministic hooks at each new commit/authority boundary;
7. add the real-boundary companion;
8. run mutation tests against the model/checker and production pure logic;
9. preserve the first minimal failure capsule;
10. update the threat model, runbook, ADR and compatibility matrix.

A pull request that adds a transaction, receipt, cursor, release, audit, or deletion transition without steps 1–7 fails the architecture gate.

### 3.5 Clock, randomness, and scheduling design

**FACT.** .NET supplies `TimeProvider` and the `Microsoft.Extensions.TimeProvider.Testing` package with `FakeTimeProvider` for controlled time [W01–W02].

**RECOMMENDATION.** UAM production components consume a narrow `IUamClock` backed by `TimeProvider`. Verification uses a wrapper with four explicit notions:

| Clock | Meaning | Example use |
|---|---|---|
| `WallUtc` | externally meaningful UTC, may step or become uncertain | policy/release expiry, audit timestamp, event time validation |
| `Monotonic` | elapsed duration, never derived from wall-clock | timeouts, retry delay, process budget, lease duration measurement |
| `PolicyClockConfidence` | `Trusted`, `Uncertain`, `Regressed`, `Unavailable` | fail-closed authorization decisions |
| `SchedulerTick` | pure-model logical order | deterministic interleaving and shrink |

Callbacks awakened by virtual time MUST rendezvous at explicit barriers. Correctness tests MUST NOT depend on `Thread.Sleep`, unconstrained `Task.Delay`, or “eventually within N wall-clock seconds.” Real lab lanes may use bounded external timeouts only to detect a hung test, not to define the expected ordering.

The root seed is 256 bits. Domain-separated deterministic bytes are:

```text
block(label, counter) =
  SHA-256(
    UTF8("uam-test-seed-v1") ||
    root_seed_32_bytes ||
    uint32be(length(UTF8(label))) || UTF8(label) ||
    uint64be(counter))
```

Bounded integers use rejection sampling, not modulo bias. Each generator records its label and draw ordinal. Library replay parameters are recorded in addition to, not instead of, the UAM root seed.

### 3.6 Deterministic hook architecture

Hooks are named semantic boundaries, not source line numbers. The production module calls a compile-time/internal no-op abstraction; test builds bind it to a controller through an inherited local handle or in-process adapter. Supported actions are finite:

```text
Continue
Return(errorCode)
Throw(exceptionClass)
Wait(barrierId)
Release(barrierId)
Cancel
TerminateCurrentProcess(exitClass)
RequestControllerKill(processRole)
```

A hook schedule addresses `(hook_id, actor_id, occurrence)` and may be `once`, `nth`, or `sticky`. It cannot carry SQL, paths, URLs, commands, scripts, assemblies, arbitrary exceptions, or method names. Hook context contains only T1 opaque IDs, model state class, operation ordinal, transaction ID, and finite stage/reason codes.

Every load-bearing hook MUST have:

- a model command/event counterpart;
- at least one deterministic pre/post test;
- a real-boundary companion such as process kill, socket reset, disk-full volume, database-session termination, service restart, or VM reset;
- a production-artifact absence assertion.

### 3.7 Tool decision matrix

| Need | Initial choice | Status | Why | Main limitation/containment |
|---|---|---|---|---|
| C# value/sequence generation and shrinking | FsCheck 3.3.4 candidate | **DEPENDENCY CANDIDATE — TEST ONLY** | active, BSD-3-Clause, C#/.NET fit, deterministic replay | UAM owns state-machine semantics and shrink hierarchy; experimental model API is not load-bearing |
| Alternative integrated shrinking | Hedgehog .NET 2.0.0 | **REFERENCE / ALTERNATIVE** | deterministic seeds and shrink trees, Apache-2.0 | do not run two general property frameworks by default; reconsider if FsCheck shrinking cannot preserve valid histories |
| Virtual time | `TimeProvider` + testing package | **FRAMEWORK/PACKAGE CANDIDATE** | official .NET abstraction | does not deterministically schedule arbitrary continuations; explicit barriers required |
| Mutation testing | Stryker.NET 4.16.0 | **TEST CANDIDATE** | current, Apache-2.0, useful sensitivity check | start with pure modules; reviewed CsWin32-generated-symbol issue blocks Windows interop lane until fixed/proved |
| Coverage-guided .NET fuzz bridge | SharpFuzz 2.3.0 | **NO-GO NOW** | useful design, MIT | exact package-to-reviewed-source mapping unresolved; ordinary deterministic hostile corpora continue |
| Systematic .NET concurrency | Microsoft Coyote 1.7.11 | **REFERENCE / BOUNDED SPIKE** | deterministic schedule exploration and replay concepts | older package, support/security/.NET compatibility concerns; instrumentation cannot prove OS/SQLite behavior |
| Disposable server dependencies | Testcontainers .NET 4.13.0 | **TRUSTED-LANE CANDIDATE** | current, MIT, attested release packages; image pinning support | Docker daemon is privileged; exact image digests and isolated runners required; no Windows proof |
| TCP fault proxy | Toxiproxy 2.12.0 | **LAB/CI CANDIDATE** | deterministic latency, cut, reset, bandwidth and half-open patterns | TCP faults do not model HTTP semantic bugs or post-commit response loss alone; pair with hostile test server |
| SQLite I/O/crash mechanism | UAM test VFS + hard process/VM faults | **IMPLEMENT** | SQLite itself uses rigged VFS for nth-I/O and sticky failures [W03] | selected provider/native integration must expose a safe test path; no reliance on unstable `sqlite3_test_control` |
| PostgreSQL internal test faults | source-built PostgreSQL 18 test lane with injection points and isolation specs | **LAB REFERENCE/TEST BUILD** | official developer option and multi-session permutation framework [W05–W07] | never production binary; repeat against ordinary release image with black-box faults |
| SQL Server faults | black-box session kill, process/container stop, disk/network faults, actual restore + `DBCC CHECKDB` | **LAB METHOD** | no equivalent public UAM-facing injection API identified; official restore guidance requires actual restore | exact licensing, image and operations are human/procurement decisions |
| Windows user-mode resource faults | Application Verifier Basics/Cuzz/Low Resource Simulation | **WINDOWS LAB METHOD** | official targeted fault/concurrency/resource checks [W10–W12] | can change timing and paths; run with and without; settings cleanup mandatory |
| Windows machine failure | NotMyFault 4.5 and VM reset | **DESTRUCTIVE LAB ONLY** | official crash/hang tool, current May 2026 [W09] | never endpoint CI/pilot; disposable VM, explicit approval and revert required |
| Distributed history checking | Jepsen 0.3.13 | **REFERENCE ONLY INITIALLY** | strong history/checker/nemesis discipline, recent deterministic-seed work | UAM initial server is not a consensus system; JVM/cluster cost unjustified unless topology changes |
| Deterministic simulation examples | FoundationDB simulation; TigerBeetle VOPR | **REFERENCE ONLY** | mature single-seed virtual-time/fault ideas and independent reality-lane lessons | different languages, storage engines and threat models; no architecture/code copying |

### 3.8 Secure coding, threat modelling, review, and supply-chain controls

**FACT.** NIST SSDF 1.1 and Microsoft SDL emphasize documented security requirements, threat modelling, secure review/testing, protected build pipelines, and lifecycle maintenance [W17–W19].

**RECOMMENDATION.** Verification code is security-sensitive code because it can create privileged lab actions, false confidence, or privacy leaks. It therefore MUST have:

- a maintained data-flow/threat model for controller, hook, product, database, VM, evidence and artifact boundaries;
- two-person review for invariant changes, checker changes, hook placement, destructive lab scripts, and production hook-absence rules;
- exact package/source/binary/license records and locked restore;
- analyzers that prohibit raw source types, dynamic code, reflection-discovered faults, arbitrary process launch, and network access in pure/checker projects;
- mutation tests for critical pure checkers and one deliberately broken reference implementation per invariant family;
- independent hand-worked histories for every invariant, including zero-effect paths;
- a recurring “harness lies” campaign that deliberately disables a checker, skips a hook, loses an operation, leaks a canary and leaves cleanup residue, and requires the harness to fail each case.

### 3.9 Configuration ownership, feature flags, and kill switches

- Fault hooks are **not feature flags**. They are a test-artifact capability with no production control plane.
- Release-owned kill switches MAY disable a source, capability, release ring, upload, materializer, visibility, or administrative action. Tenant controls MAY only narrow where accepted policy permits.
- Every flag MUST have owner function, default, authority, privacy relation, expiry/review trigger, compatibility behavior, audit requirement and generated model semantics.
- Unknown, stale, wrong-realm, unsigned, downgraded, or unsupported control values fail closed according to the accepted policy state machine.
- A test schedule cannot be transported through tenant policy, ordinary endpoint configuration, or the upload channel.

### 3.10 Privacy-safe observability and accessibility

**FACT.** OpenTelemetry describes metric cardinality as the number of unique attribute combinations and notes that high-cardinality values such as user IDs or raw URL paths can create unbounded state [W20].

The verification harness and product test instrumentation MUST use finite dimensions such as:

```text
component_role
model_id
command_kind
fault_kind
hook_id
outcome_family
error_class
build_ring
engine_family
supported_environment_class
```

They MUST NOT use realm, tenant, installation, device, user, SID, session, source, event, URL, host, application, batch, receipt, native ID, policy digest, seed, exact exception message, file path, database name or timestamp as metric labels. Seeds and digests belong in access-controlled evidence records, not metrics.

Metric cardinality budgets are measured and owned; library defaults are not the architecture. The harness MUST generate adversarial distinct values and prove that allowlists/overflow behavior keep memory and series bounded.

Where a web or desktop evidence viewer is built, it SHOULD conform to WCAG 2.2 AA for relevant controls: keyboard operation, visible focus, non-color-only pass/fail status, programmatic table headings, accessible error summaries and stable deep links to a failure capsule. Automated accessibility scanning is supplemented by keyboard and screen-reader exercises; it is not treated as complete proof [W21].

---

## 4. Alternatives, rejection reasons, and conditions that would change the choice

| Alternative | Decision | Rejection reason now | Condition that would change it |
|---|---|---|---|
| Conventional example-based unit tests only | **REJECT** | cannot explore state sequences, retries, concurrent actors, expiry, rollback, or crash boundaries systematically | no expected change; examples remain useful as hand-worked oracle cases |
| Mock all file, process, network and database failures | **REJECT** | proves adapter reactions but can hide real atomicity, buffering, locking, WAL, socket, token and restore behavior | mocks remain a fast inner lane only when paired with the named real-boundary test |
| Use a general chaos platform as the primary harness | **REJECT** | adds control-plane, privilege, privacy, operational and reproducibility surface; does not define UAM semantics | measured multi-service topology/failure-domain need plus security, licensing and operations ADR |
| Run random faults in production by default | **REJECT** | no approved risk, user-impact, privacy, support, or incident authority; failures can destroy evidence or availability | explicit HUMAN DECISION, bounded blast radius, privacy review, pilot proof, rollback and incident exercise |
| Make Microsoft Coyote the core concurrency runtime | **REJECT AS DEFAULT** | predecessor evidence found support/provenance/recency concerns; instrumented .NET scheduling cannot cover Windows processes, native SQLite or database servers | exact current source/package/security/support proof and a bounded spike finding defects the UAM runner cannot find economically |
| Use Jepsen as the initial server test implementation | **REJECT AS DEPENDENCY** | initial server is one modular monolith with one relational authority, not a multi-node consensus database; Clojure/JVM/operations cost is disproportionate | external broker, multi-primary, replicated custom protocol or cross-region failover introduces a genuine distributed consistency claim |
| Adopt both FsCheck and Hedgehog by default | **REJECT** | duplicated generators, seeds, shrink semantics, skills and CI cost; common UAM model remains necessary either way | measured shrinking failure that a Hedgehog pilot solves materially without splitting invariant ownership |
| Use FsCheck experimental state-machine APIs as the semantic authority | **REJECT** | experimental surface has weaker compatibility assurance; UAM semantics must remain stable across library changes | API becomes stable and an ADR proves migration/removal remains trivial; UAM model/checker still remains authoritative |
| Use line/branch coverage as a release gate | **REJECT AS PRIMARY GATE** | execution does not prove assertion sensitivity, state coverage, fault coverage, forbidden transitions or real durability | never replaces invariant gates; may become an informational or minimum hygiene metric |
| Require a universal mutation-score percentage | **REJECT** | equivalent/irrelevant mutants and platform-generated code distort the number; a percentage can hide a surviving critical mutant | per-module measured thresholds may be human-approved after baselining, while named critical mutants remain zero-tolerance |
| Use unseeded random tests and rerun failures until green | **REJECT** | destroys reproducibility and masks race/fault defects | no change expected |
| Use sleeps to force concurrency | **REJECT** | timing-dependent, slow, and flaky; does not establish the intended wait state | external timeout only as a harness hang guard; ordering still uses barriers or observed database/OS wait state |
| Expose a production diagnostic endpoint that activates fault hooks | **REJECT** | becomes a high-impact execution/control vulnerability and bypasses release/policy authority | no ordinary change expected; destructive behavior remains lab-controller-only |
| Depend on SQLite `sqlite3_test_control()` | **REJECT** | SQLite documents it as an internal testing interface that may change or be omitted [W04] | none for product code; an exact source-built SQLite test lane may use internal mechanisms without becoming a UAM dependency |
| Treat `RESTORE VERIFYONLY` as SQL Server restore proof | **REJECT** | it verifies readability/completeness but not the restored data structure; Microsoft recommends actual restore and `DBCC CHECKDB` [W14–W16] | no change expected |
| Copy FoundationDB/TigerBeetle simulation architecture | **REJECT** | different implementation languages, storage engines, deployment topology and threat model | reuse concepts only; any code/architecture adoption needs a separate fit and license review |
| Keep fault hooks as mutable runtime configuration | **REJECT** | configuration drift could expose hooks in production and bypass signed release intent | hooks are compile-time/test-artifact capability only |
| Count a container database pass as database-engine selection proof | **REJECT** | omits production hardware, operations, HA, restore, licensing, support and workload evidence | identical benchmark/restore/operations gate from the accepted baseline remains required |

### 4.1 Change-control rule

A change to the accepted baseline is required if evidence shows that any accepted invariant cannot be falsified without changing a product boundary. The change proposal MUST contain:

- affected baseline decision and invariant IDs;
- new primary evidence;
- security, privacy, realm, durability and operational impact;
- alternatives and migration cost;
- smallest falsifying experiment;
- compatibility, rollback and cleanup consequence;
- ADR action and accountable human authority.

A testing-library limitation is not sufficient evidence to weaken a product invariant.

---

## 5. Interfaces/protocols and example contracts or schemas

### 5.1 Invariant registry contract

The canonical registry is reviewable YAML or JSON, validated by a closed local schema. A load-bearing entry cannot be `active` without a falsifier or manual exercise.

```yaml
schemaVersion: 1.0.0
invariants:
  - id: INV-04
    title: Cursor never advances ahead of durable effects
    status: active
    classification: load-bearing
    model: M3
    formal: >-
      For every committed checkpoint c and native id n <= c,
      exactly one durable ordinary effect or approved no-event fact exists
      for the natural key in the same committed database history.
    plain: >-
      The endpoint cannot remember that it processed a browser row unless the
      corresponding minimized result or final no-event fact is already durable.
    scope:
      components: [Coordinator, EndpointSQLite]
      realms: authenticated-context-only
    falsification:
      automated:
        - P10-03
        - E10-12
      realBoundaryCompanion:
        - E10-13
      manualExercise: null
    hooks:
      - endpoint.page.after_effect_insert
      - endpoint.page.before_checkpoint_cas
      - endpoint.page.after_checkpoint_cas
      - endpoint.page.before_commit
      - endpoint.page.after_commit_before_ack
    checkers: [checkpoint-prefix, one-effect-per-natural-key]
    ownerFunction: Endpoint Storage Verification
    runbook: RB-INV-04
    reviewTriggers:
      - endpoint schema change
      - SQLite provider/native change
      - transaction algorithm change
      - restore algorithm change
```

Normative registry rules:

- `classification` is `load-bearing`, `supporting`, or `informational`.
- `ownerFunction` MUST be assigned before a release gate; this does not invent an individual assignment.
- A load-bearing invariant MUST have `automated` plus a real-boundary companion unless automation is unsafe or impossible. In that case `manualExercise` MUST name owner, cadence, evidence, stop rule and expiry.
- Tests reference invariant IDs; invariant text does not live only in test names.
- Deleting or weakening an invariant requires an ADR and baseline-change review.

### 5.2 Pure model interface

Illustrative normative C# shape:

```csharp
public interface IUamSystemModel<TState, TCommand, TEvent>
    where TState : notnull
    where TCommand : notnull
    where TEvent : notnull
{
    IReadOnlyList<TCommand> EnabledCommands(TState state);

    ModelTransition<TState, TEvent> Apply(
        TState state,
        TCommand command,
        ModelContext context);

    IReadOnlyList<InvariantViolation> CheckState(TState state);

    IReadOnlyList<InvariantViolation> CheckHistory(
        TState initial,
        IReadOnlyList<ObservedOperation<TCommand, TEvent>> history,
        TState final);
}

public sealed record ModelContext(
    RootSeed Seed,
    long SchedulerTick,
    UtcInstant WallUtc,
    MonotonicInstant Monotonic,
    ClockConfidence ClockConfidence,
    RealmBinding AuthenticatedRealm,
    ActorId Actor,
    FaultDecision Fault);
```

Production projects MUST NOT reference this model assembly. Drivers translate between model commands and public/test-only product interfaces; checkers compare observable histories and durable snapshots rather than internal object graphs.

### 5.3 System models and command/event alphabets

| Model | State owned by model | Principal commands | Principal observable events |
|---|---|---|---|
| M1 Session/IPC | sessions, logons, peer processes, bootstrap/dedicated channels, sequence, permit, eligibility | `SessionLogon`, `Lock`, `Disconnect`, `Reconnect`, `StartCoordinator`, `StartUserHost`, `ConnectBootstrap`, `ConnectDedicated`, `SendFrame`, `RestartPeer`, `Logoff` | `PeerObserved`, `PeerVerified`, `ChannelReady`, `FrameAccepted`, `FrameRejected`, `SessionPaused`, `ProcessExited`, `CleanupComplete` |
| M2 Privacy/policy | ceiling, tenant narrowing, emergency/local narrowing, active candidate, clock confidence, permit | `PublishCeiling`, `FetchTenantPolicy`, `ApplyCandidate`, `ExpirePolicy`, `RegressClock`, `IssueRunIntent`, `IssuePermit`, `TransformValue` | `CandidateQuarantined`, `SafetyHold`, `PolicyActive`, `PermitIssued`, `PermitDenied`, `Minimized`, `Suppressed`, `CanaryDetected` |
| M3 Source/page/SQLite | source/generation, native rows, interpretation, page, record effects, outbox, witnesses, checkpoint | `DiscoverSource`, `ReplaceSource`, `StartPage`, `PrepareRows`, `CommitPage`, `LoseAck`, `RetryPage`, `CrashCoordinator`, `RecoverSQLite` | `PagePrepared`, `EffectInserted`, `NoEventInserted`, `WitnessStored`, `CheckpointAdvanced`, `SQLiteCommitted`, `LocalAck`, `IdentityConflict` |
| M4 Upload/custody/materialization | batches, attempts, inbox, receipt, validation, quarantine, lease, facts, visibility | `BuildBatch`, `SendBatch`, `DropResponse`, `RetryBatch`, `Validate`, `Lease`, `Materialize`, `CrashWorker`, `PublishVisibility` | `InboxCommitted`, `ReceiptEmitted`, `ReceiptReplayed`, `Validated`, `Quarantined`, `LeaseGranted`, `LeaseFenced`, `Materialized`, `Visible` |
| M5 Release/update | installed good, candidate, manifest/signature, sequence, staging, activation, health, rollback | `OfferRelease`, `DownloadPart`, `CorruptPart`, `Verify`, `Stage`, `Switch`, `BootCandidate`, `ReportHealth`, `KillAtStage`, `Rollback`, `RepairMSI` | `ReleaseRejected`, `StagedVerified`, `Activated`, `HealthFailed`, `RollbackStarted`, `PreviousRestored`, `SafetyHold` |
| M6 Realm/admin/audit | authenticated principal, realm, authorization, command, mutation, audit, cache, query | `Authenticate`, `AdminRead`, `AdminMutate`, `ChangeRealmClaim`, `CrashTransaction`, `ReplayCommand` | `Authorized`, `Denied`, `MutationCommitted`, `AuditCommitted`, `AuditRejected`, `CacheResult`, `RealmMismatch` |
| M7 Deletion/restore | deletion request/scope/epoch, tombstones, backups, custody, materialization, readiness, visibility | `RequestDeletion`, `CommitTombstone`, `DeleteFacts`, `ReceiveLateEvent`, `TakeBackup`, `RestoreBackup`, `ReplayTombstones`, `ValidateRestore`, `OpenReadiness` | `DeletionAccepted`, `TombstoneCommitted`, `DataHidden`, `LateEventSuppressed`, `RestoreIntegrityPassed`, `DeletionReplayPassed`, `RestoreReady`, `VisibilityOpened` |
| M8 Worker/pressure | queue/inbox, leases, retries, poison, quotas, endpoint disk, backpressure, outage | `Enqueue`, `FillDisk`, `ExpireLease`, `RunWorkers`, `InjectPoison`, `PauseDependency`, `ResumeDependency`, `DropOldestAttempt` | `Backpressured`, `NoDrop`, `LeaseExpired`, `PoisonQuarantined`, `HealthyProgress`, `ResourceLimit`, `DataLossViolation` |

The command alphabet is closed and versioned. New arbitrary “execute,” “run script,” “issue SQL,” “open path,” or “call endpoint” commands are prohibited.

### 5.4 Fault alphabet

| Fault class | Finite actions | Intended boundary |
|---|---|---|
| Logical return | `ReturnTransient`, `ReturnPermanent`, `ReturnIntegrityConflict`, `Cancel` | adapter and state-machine error paths |
| Exception/resource | `ThrowExpected`, `OutOfMemorySimulation`, `AllocationFailure`, `HandleFailure` | .NET/Windows error handling |
| Scheduling | `WaitBarrier`, `ReleaseBarrier`, `PauseActor`, `AdvanceVirtualTime`, `ExpireLease` | deterministic interleavings |
| Process/service | `KillProcess`, `TerminateJob`, `StopService`, `RestartService`, `LogoffSession` | Windows endpoint and worker lifecycle |
| File/storage | `DenyWrite`, `DiskFull`, `NthIoError`, `StickyIoError`, `ShortRead`, `ShortWrite`, `TruncateTestCopy`, `CorruptTestCopy`, `RemoveFile`, `ResetVm` | SQLite, update staging, backup/restore |
| Network/HTTP | `DropRequest`, `DropResponse`, `ResetConnection`, `HalfClose`, `Latency`, `Bandwidth`, `DuplicateRequest`, `ReorderAtApplicationHarness` | upload and control APIs |
| Database | `KillSession`, `Deadlock`, `SerializationFailure`, `PauseBeforeCommit`, `StopDatabase`, `RestartDatabase`, `FailoverTestInstance` | inbox, worker, audit, deletion, restore |
| Clock/control | `StepWallClock`, `FreezeWallClock`, `RegressWallClock`, `ExpireArtifact`, `RevokeTestKey`, `PublishLowerRevision` | policy/release/lease behavior |
| Release | `MissingFile`, `WrongDigest`, `InvalidSignature`, `StaleManifest`, `Downgrade`, `KillBeforeSwitch`, `KillAfterSwitch` | install/update/rollback |
| Restore/deletion | `RestoreOlderBackup`, `OmitTombstoneReplay`, `OpenVisibilityEarly`, `LateAcknowledgedReplay` | non-resurrection and custody preservation |

`CorruptTestCopy` applies only to T1 copies or disposable database images. The harness never corrupts a production source, production backup, real user profile, or uncontrolled filesystem.

### 5.5 Hook contract and placement schema

```json
{
  "schemaVersion": "1.0.0",
  "scheduleId": "019d0000-0000-7000-8000-00000000a001",
  "rootSeedSha256": "sha-256:fictional-seed-digest",
  "artifactKind": "TEST_ONLY",
  "actions": [
    {
      "hookId": "endpoint.page.after_commit_before_ack",
      "actorId": "coordinator-1",
      "occurrence": 1,
      "mode": "once",
      "action": {
        "kind": "RequestControllerKill",
        "processRole": "Coordinator"
      }
    }
  ]
}
```

Rules:

- The schema is closed; `hookId` and action enums come from the release-owned test catalogue.
- `artifactKind` MUST be `TEST_ONLY`; the production contract catalogue has no equivalent schema.
- The controller verifies exact test-build digest, environment class and disposable marker before arming a destructive action.
- A hook action cannot include a path, SQL statement, host, URL, credential, arbitrary exception type, assembly, script or command line.
- A test process emits `HookReached` before waiting. The controller records the causal operation and verifies process death/restart independently.

### 5.6 Reproducible history format

One NDJSON record per invocation/response/observation:

```json
{
  "schemaVersion": "1.0.0",
  "historyId": "019d0000-0000-7000-8000-00000000b001",
  "operationIndex": 17,
  "schedulerTick": 42,
  "actorId": "worker-a",
  "modelId": "M4",
  "command": {
    "kind": "Materialize",
    "opaqueEventId": "019d0000-0000-7000-8000-00000000b101"
  },
  "fault": {
    "kind": "KillProcess",
    "hookId": "worker.after_materialize_before_mark"
  },
  "invokedMonotonicTicks": 10240,
  "completedMonotonicTicks": null,
  "observedEvents": [
    {"kind": "FactInsertCommitted", "finiteCode": "INSERTED"}
  ],
  "outcome": "INDETERMINATE_AT_CLIENT",
  "privacyClassification": "T1"
}
```

Histories use opaque fictional IDs. They do not contain payloads unless the payload is an approved minimal T1 value needed by the checker. Raw URL canaries appear only in the fixture and exact scanner registry, never in a general history.

### 5.7 Failure capsule

A failing run MUST produce:

```text
failure-capsule/
  manifest.json
  invariant-violations.ndjson
  minimal-history.ndjson
  original-history.ndjson
  schedule.json
  seed.json
  shrink-chain.ndjson
  environment.json
  contracts.json
  toolchain.json
  database-inventory.json
  process-lifecycle.ndjson
  durable-snapshots/
  canary-scan.json
  cleanup-receipt.json
  replay.md
  hashes.sha256
```

The capsule manifest binds source tree, test artifact, runtime, native libraries, database image/source, VM image class, contracts, scenario package, seed, schedules, first failure, reruns, shrink result, checker versions, evidence digests, owner/reviewer functions and exceptions. A rerun never overwrites the original capsule.

### 5.8 Shrink policy

Shrink in this order while preserving a valid causal history and the same invariant failure:

1. remove whole phases after the first violation;
2. remove unrelated actors, realms, sessions, sources, batches and workers;
3. remove commands and faults using delta debugging;
4. reduce each actor's operations while preserving barriers and prerequisites;
5. reduce fault set to one boundary and one occurrence;
6. reduce retry/duplicate counts;
7. reduce clock advances and lease windows;
8. reduce collection/page/batch sizes;
9. reduce field and string values to grammar minima;
10. canonicalize IDs while preserving collision/realm relations.

The shrinker records every accepted/rejected candidate and its checker result. A “smaller” history that changes from a product failure to `HarnessFault` is rejected.

### 5.9 Error taxonomy

| Class | Meaning | May a campaign pass? | Retry meaning |
|---|---|---|---|
| `ExpectedInjected` | exact scheduled fault occurred | yes, if invariants and recovery hold | according to modeled contract |
| `TransientDependency` | ordinary retryable dependency failure | yes, if bounded and no invariant breach | stable retry class |
| `AmbiguousCommit` | caller cannot know whether remote commit occurred | yes only if retry/reconciliation yields one effect | retry same identity; never mint new identity |
| `PermanentContract` | structurally/semantically invalid input | yes if rejected/quarantined correctly | no automatic coercion |
| `IntegrityConflict` | same stable key with incompatible content/state | no ordinary progress; safety path expected | no overwrite; operator/ADR path |
| `SecurityBoundary` | session, peer, release, authorization, realm or key invariant failed | **no** | stop affected capability/ring |
| `PrivacyBoundary` | forbidden value or derivative escaped | **no** | incident and full sink review |
| `DurabilityInvariant` | cursor, receipt, effect, audit, deletion or restore invariant failed | **no** | stop dependent gates |
| `ResourceExhaustion` | bounded resource limit reached | may pass only with correct containment/backpressure | bounded retry/defer; no silent drop |
| `EnvironmentUnsupported` | required capability absent/unknown | not a product pass; scope remains unsupported | no fallback that weakens controls |
| `HarnessFault` | controller/checker/evidence/fixture failed | never counts as product pass or product fail | repair harness; retain evidence |
| `CleanupFailure` | residue or verifier setting remains | **no** | environment quarantined/reverted |
| `FlakyUnclassified` | result varied without proved cause | **no release pass** | preserve first failure; investigate |

### 5.10 Driver result contract

Every command returns one of:

```text
Completed(events, observations)
Rejected(finiteReason)
Deferred(finiteReason)
Indeterminate(clientView, durableObservations)
HarnessFault(finiteReason)
EnvironmentUnsupported(capabilityId)
```

An exception string, SQL message, path, source value, host, user, or stack trace is never the contract result. Restricted raw diagnostics may be separately captured in a disposable lab under the evidence policy and are not shared by default.

---

## 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility rules

### 6.1 M1 — session and IPC state machine

```text
NoSession
  -> InteractiveSessionEligible
      -> LauncherStarted
          -> UserHostCreatedOrdinaryToken
              -> BootstrapConnected
                  -> BothPeersKernelValidated
                      -> DedicatedOneUseChannel
                          -> Ready
                              -> PausedOnLockOrDisconnect
                              -> Draining
                              -> Exited

Any wrong logon SID/session/LUID/release/process/sequence/MAC/state
  -> RejectAndClose

Coordinator restart or session lifecycle change
  -> old channel invalid
  -> fresh peer validation required
```

Model rules:

- same account in another logon is a different actor and cannot reuse a dedicated channel;
- payload SID/session/realm claims have no authority;
- no application frame is accepted on bootstrap;
- accepted frame sequence is strictly monotonic and bound to the validated peer/release;
- a paused/ineligible session cannot issue a collection permit;
- process exit, job close, logoff and uninstall eventually leave no test process or product-owned residue.

### 6.2 M2 — privacy and control state machine

```text
NoActiveAuthority
  -> CandidateFetched
      -> StructuralRejected                  active valid policy unchanged
      -> QuarantinedUnsupported              active valid policy unchanged
      -> SafetyHold                          security-significant failure
      -> VerifiedPendingEffective
          -> Active
              -> Superseded
              -> ExpiredOrCorrupt -> Disabled
```

For finite policy lattices:

```text
Effective = ProductCeiling
          ∧ TenantPolicy
          ∧ ProductEmergencyNarrowing
          ∧ TenantEmergencyNarrowing
          ∧ LocalSafetyDisablement
          ∧ RuntimeCapabilityAvailability

Invariant: Effective ⪯ ProductCeiling
```

Unknown, incomparable, wrong-realm, unsupported, overflow, missing, stale, downgraded or expired authority cannot broaden or authorize collection. Rollback republishes prior approved semantics at a higher revision.

### 6.3 M3 — whole-page endpoint transaction

Accepted logical transaction:

```text
BEGIN IMMEDIATE
  validate authenticated realm/installation/source/generation/permit/page
  for each native key in strict order:
      insert or confirm one durable effect/no-event
      insert minimized outbox row when effect is an event
      reject incompatible existing digest as identity conflict
  replace bounded witnesses
  insert page/run fact
  compare-and-swap checkpoint
COMMIT
emit local ACK
```

State machine:

```text
PagePrepared
  -> CommitPending
      -> EffectsWritten
      -> WitnessesWritten
      -> CheckpointCAS
      -> CommitDurable
          -> Acked
          -> AckLost -> RetrySamePage -> ReturnExistingOutcome

Any failure before CommitDurable -> PriorDurableState
Any incompatible stable key       -> IdentityConflict / no progress
```

The checker treats the SQLite commit boundary, not a hook callback or returned method, as durable truth. Recovery opens the exact database, checks integrity according to the selected profile, reads effects/outbox/checkpoint and resumes through stable identity.

### 6.4 M4 — custody, receipt, and materialization

```text
RequestReceived
  -> AuthenticatedContextBound
  -> ContractAndBoundsChecked
  -> InboxTransactionPending
      -> BatchPayloadAndIdentityDurablyCommitted
          -> ReceiptEligible
              -> ReceiptReturned
              -> ResponseLost
                  -> RetrySameBatch
                      -> SameReceiptOutcome

DurablyReceived
  -> Validated
      -> Quarantined
      -> LeaseAvailable
          -> Leased(fencing token)
              -> MaterializationTransaction
                  -> FactCommitted
                  -> WorkMarkedComplete
              -> LeaseExpired/WorkerKilled -> Retry
  -> Visible only after required materialization/read-model state
```

Rules:

- a receipt is impossible before the durable inbox transaction commits in the declared failure domain;
- response loss after commit is an ambiguous client outcome, not permission to create a new batch identity;
- batch/event uniqueness is realm-scoped and derived from authenticated context;
- an expired or stale lease token cannot mark or commit work;
- materialization is idempotent under stable event/natural key uniqueness;
- validation, quarantine, materialization and visibility are distinct states;
- poison work is quarantined without deleting custody or blocking healthy work indefinitely.

### 6.5 M5 — release/update and rollback

MSI and enterprise deployment remain the stable privileged boundary. The model supports an optional updater only as disabled states until its separate gate is approved.

```text
InstalledGood(vN)
  -> CandidateOffered(vN+1)
      -> ManifestAndAuthorityVerified
      -> AllFilesDownloadedAndDigested
      -> StagedVerified
          -> SwitchPending
              -> CandidateBoot
                  -> HealthPending
                      -> CurrentGood(vN+1)
                      -> HealthFailed
                          -> RollbackPending
                              -> PreviousRestored(vN)
                              -> SafetyHold

Any unauthorized/incomplete/stale/frozen/downgraded candidate -> Rejected
```

Atomicity condition: after interruption and recovery, executable/configuration state is either a complete authorized previous-good release or a complete authorized candidate that has passed the required health transition. A mixed privileged boundary is a primary failure.

Rollout rules:

- consumer compatibility precedes producer/control activation;
- one signed digest is promoted through rings; no environment rebuild;
- fault campaigns run against unsigned/test-signed exact payloads before production signing;
- release gate re-runs when installer, updater, signing profile, service/task configuration, runtime/native dependency, schema or rollback mechanism changes;
- a lower revision is never “rollback”; prior semantics are republished at a higher authorized revision.

### 6.6 M6 — realm, administrative mutation, and audit

Initial modular-monolith transaction:

```text
BEGIN
  derive principal and realm from authenticated context
  authorize exact command against exact realm/resource revision
  apply privileged mutation
  insert immutable audit record with command/result/provenance
COMMIT
```

Invariant:

```text
CommittedPrivilegedMutation(command_id)
    iff
CommittedAudit(command_id, same authenticated realm/principal, same transaction outcome)
```

A denied command may have a separately approved security audit fact, but cannot have a successful mutation. If audit storage is later separated, the mutation cannot become effective until the accepted durable-audit custody protocol closes the same invariant; that is an adjacent architecture change, not a test workaround.

Generated histories vary:

- same IDs in different realms;
- payload-claimed realm different from authenticated realm;
- stale resource revisions;
- duplicate command IDs;
- authorization change between read and write;
- crash before mutation, after mutation before audit insert, after audit before commit, and after commit before response;
- cache priming under one realm followed by access under another.

### 6.7 M7 — deletion and restore

The exact legal/retention scope is a HUMAN DECISION. The verification model uses abstract realm-scoped deletion scope and epoch:

```text
DeletionRequested
  -> AuthorizedAndScoped
      -> TombstoneCommitted(epoch)
          -> VisibilitySuppressed
          -> MaterializedFactsDeletedOrMasked
          -> Endpoint/InboxLateArrivalEvaluatedAgainstTombstone
          -> BackupsAwaitExpiryOrRestoreReplayPolicy
          -> DeletionReady
```

Restore:

```text
BackupSelected
  -> RestoredHidden
      -> EngineIntegrityValidated
      -> AcknowledgedCustodyReconciled
      -> TombstonesAndDeletionEpochsReplayed
      -> RealmIsolationValidated
      -> Materialization/Index/CacheReadinessValidated
      -> AuditOfRestoreCommitted
      -> RestoreReady
          -> VisibilityOpened
```

Rules:

- acknowledged data within the declared RPO/RTO policy is reconciled before readiness; exact objectives are human-owned;
- a late replay covered by an effective deletion tombstone cannot silently resurrect visibility;
- visibility cannot open merely because the database engine started;
- old cache/read-model data cannot bypass restored deletion state;
- `RESTORE VERIFYONLY` alone is not SQL Server restore evidence; actual restore and consistency checking are required;
- deletion and restore exercises use T1 data until governance authorizes otherwise.

### 6.8 M8 — lease, poison, pressure, and long outage

```text
CapacityAvailable
  -> PressureIncreasing
      -> BackpressureApplied
          -> NewWorkDeferredOrBounded
          -> UnacknowledgedDataRetained
          -> HealthStateRaised
      -> CapacityRecovered -> DrainInStableOrder

LeasedWork
  -> WorkerCompletesWithFence
  -> WorkerDies/LeaseExpires
      -> AnotherWorkerLeasesWithNewFence
      -> OldWorkerCommitRejected

PoisonItem
  -> FiniteAttempts/Classification
      -> QuarantinedWithCustody
      -> HealthyItemsContinue
```

No component may choose a hidden “drop oldest” path. If a human-approved policy later permits loss after a bounded retention/outage rule, that is an explicit product/data decision with visible state, audit, user impact and a baseline change—not an implementation fallback.

### 6.9 Compatibility rules for the harness

- Model, command, event, hook, evidence and failure-capsule contracts use exact semantic versions and closed schemas.
- A producer of a new command/event version is not enabled until the checker, driver, evidence reader and replay CLI support it.
- Old failure capsules remain replayable for the committed support window or are migrated by a deterministic, tested offline converter that preserves original digests and provenance.
- Hook IDs are never silently reused. Removed hooks remain reserved; replacements have new IDs and mapping notes.
- A changed invariant checker re-evaluates a pinned corpus of historical failure/pass capsules. Any changed classification is reviewed and recorded.
- A dependency/runtime/database patch causes targeted semantic-difference and fault-campaign replay. Patch numbers are evidence inputs, not timeless architecture.

### 6.10 Verification lifecycle

```text
Invariant Proposed
  -> Model + hand histories
  -> Generator + shrinker
  -> Checker self-test/mutants
  -> Component hook campaign
  -> Real-boundary companion
  -> Runbook + cleanup exercise
  -> Candidate gate
  -> Release gate
  -> Pilot/shadow evidence where authorized
  -> Recurring regression
  -> Superseded only by ADR
```

A passing inner lane authorizes the next lane; it never substitutes for it.

---

## 7. Security/privacy threat and failure register

Owner names below are accountable **functions**, not assigned people. Assignment is a HUMAN DECISION and a release prerequisite.

| ID | Trigger/threat | Detection | Containment | Recovery | Cleanup | Owner function | Test | Residual risk |
|---|---|---|---|---|---|---|---|---|
| R-01 | model and implementation share the same conceptual defect | hand-worked histories, independent checker project, mutation, alternate reference calculation | no release decision from production output alone | correct invariant/model/checker; replay historical capsules | remove invalid expected artifacts, retain superseded digests | Verification Architecture | P10-12, E10-04 | independent code can still share human misunderstanding |
| R-02 | generator never reaches a critical state or transition | command/state/fault coverage report, deliberate reachability witnesses | release blocks on missing load-bearing coverage | add constructive generator/precondition/shrinker | regenerate T1 corpus, preserve prior failures | Verification Architecture | E10-05 | state space remains unbounded |
| R-03 | shrinker removes the cause or changes product failure into harness failure | re-run original and every accepted shrink candidate; invariant ID must remain | publish original capsule even when shrink fails | fix shrink predicate; use delta-debug fallback | remove temporary candidates | Verification Tooling | E10-06 | minimality is relative to available shrink operations |
| R-04 | fault hook/controller ships in production | dependency graph, file manifest, symbol/string/API scan, SBOM, startup self-check, deliberate production activation attempt | signing/promotion stop | remove hook artifacts; clean rebuild; incident review if distributed | revoke/quarantine bad artifact and test keys | Release Security | P10-12, E10-22 | compiler/linker artifacts may require evolving scanners |
| R-05 | tenant/configuration can activate a test fault | schema/architecture tests, hostile policy vectors, control-plane route scan | fail closed; stop release | remove route; rotate affected test authority; threat-model update | delete candidate configs/evidence copies | Policy Security | P10-02, E10-22 | undiscovered indirect configuration path |
| R-06 | privileged lab controller escapes disposable environment or holds production credentials | runner/network/credential inventory, egress capture, privilege boundary checks | isolate/quarantine runner; no production network/secret access | destroy/reimage runner; rotate any exposed test secret | destruction receipt and cache wipe | CI/Lab Security | E10-02, E10-23 | hypervisor/host compromise is outside ordinary harness proof |
| R-07 | cross-session or fake peer message is accepted | kernel identity/session/release evidence plus accepted-frame history | close channel, stop source capability/ring | fix peer validation/state machine; rerun full G1 campaign | kill jobs/processes, remove services/tasks/test users | Windows Security | P10-01 | enterprise GPO/EDR can alter behavior by environment |
| R-08 | session lock/disconnect/logoff leaves collection active | lifecycle event trace, permit/page events, Task Host process list | cancel permit/page; kill job; no commit | repair lifecycle reconciliation; higher release | process/job/file/task cleanup and VM revert | Endpoint Runtime | P10-01 | OS events can be delayed or coalesced |
| R-09 | forbidden raw value or reversible derivative crosses Task Host boundary | exact canaries across IPC/store/log/trace/metric/network/dump/support sinks | stop source/upload for affected build; quarantine artifacts | locate all sinks, delete/contain under authority, fix type/logging path | canary scan plus process/file/db cleanup | Privacy Engineering | P10-02, P10-10 | opaque EDR/pagefile/hypervisor capture cannot be fully disproved |
| R-10 | tenant policy broadens product ceiling or unknown defaults permissively | exhaustive finite lattice laws, generated candidates, mutation | candidate grants no permission; `SafetyHold` where security-significant | publish corrected higher revision and re-run campaign | remove invalid candidates from test stores | Policy/Privacy Authority | P10-02 | future lattice extensions can introduce incomparable cases |
| R-11 | clock regression or uncertainty leaves stale authority active | virtual clock histories and Windows clock-change lab trace | fail closed according to accepted policy state | restore trusted clock and higher-revision authority | clear temporary test policies/certs | Product Security/Operations | P10-02, P10-05 | exact offline tolerance is human-owned |
| R-12 | cursor advances before effect/no-event durability | SQLite snapshot checker after every pre/post hook and process kill | stop G5 and dependent work; preserve database | fix transaction/order; retry stable page; migration ADR if schema changed | remove disposable stores; retain failure DB digest | Endpoint Storage | P10-03 | storage device may violate assumed flush semantics beyond lab model |
| R-13 | retry creates different `event_id` or second effect | natural-key/effect uniqueness checker and original/retry history | reject conflict; no progress | reuse persisted outcome; repair mint/lookup order | clean fixture database | Endpoint Storage/Data | P10-03 | latent corruption outside tested path |
| R-14 | SQLite corruption or partial file state after crash/I/O error | native integrity check, logical ledger reconciliation, WAL/recovery evidence | source capability disabled; do not hand-edit | restore/recreate endpoint store according to later recovery policy; retain unacknowledged facts where possible | wipe only product-owned disposable DB after evidence | Endpoint Storage/Operations | P10-03, E10-13 | actual hardware/firmware failure classes are not exhaustible |
| R-15 | source or raw-data file is mutated by a fault test | per-process file trace and before/after identity/digest on T1 fixture | abort, quarantine VM, no source gate pass | fix harness/product write path; regenerate fixture | VM revert; no broad deletion | Endpoint Collector Security | P10-03 companion | trace blind spots or filter-driver behavior |
| R-16 | receipt emitted before durable inbox custody | server hook/history plus independent DB snapshot and forced restart | reject gate; stop ingestion promotion | reorder transaction/response; reconcile attempted batch | drop disposable DB/containers | Ingestion/Data Reliability | P10-04 | declared failure domain itself requires human/operations evidence |
| R-17 | post-commit response loss creates duplicate batch/event/business fact | hostile server/proxy, retry same IDs, uniqueness/history checker | return existing receipt/result; quarantine incompatible duplicate | repair idempotency lookup/transaction; replay capsule | reset proxy and database | Ingestion/Data Reliability | P10-04 | external client/proxy behaviors vary |
| R-18 | stale worker commits after lease expiry or another worker succeeds | fencing token in DB history; two-worker barrier schedule | stale commit rejected; work remains/retries | correct lease/fence transaction; rebuild materialization if needed | stop workers, drop test DB | Processing Reliability | P10-08 | clock/DB failover semantics need exact-engine tests |
| R-19 | poison item blocks healthy work or custody is deleted | mixed queue history, progress counters with finite labels, inbox snapshots | quarantine poison, continue bounded healthy processing | fix partition/lease/retry classifier; replay healthy | remove T1 poison fixture | Processing Operations | P10-08 | pathological shared-resource exhaustion can still reduce throughput |
| R-20 | unauthorized, incomplete, stale, frozen or downgraded release executes | manifest/signature/sequence/file inventory and process image evidence | reject candidate; retain previous good; `SafetyHold` on compromise evidence | higher authorized release or rollback | remove staging, test certs, service/task residue | Release Security | P10-05 | signing/key operations remain human-owned and unproved |
| R-21 | interruption leaves mixed old/new privileged boundary | file/service/task/config manifest after each kill/reset | no health/collection; rollback or repair only | restore complete previous-good or complete candidate | MSI repair/uninstall and VM revert | Release/Endpoint Platform | P10-05 | installer/EDR/GPO interactions vary by estate |
| R-22 | same identifier in another realm crosses ingestion/query/cache/admin boundary | generated paired realms, authenticated context trace, DB row/cache key inspection | deny and raise security condition; no mutation/view | fix key prefix/query authorization/cache partition | clear T1 caches and DB | Realm Security | P10-06 | upstream identity/registration compromise remains outside this model |
| R-23 | privileged mutation commits without audit, or audit claims uncommitted mutation | transaction hooks, command/audit ID ledger, DB snapshot after restart | stop administrative mutation path | fix atomic transaction/protocol; reconcile under approved runbook | drop disposable DB; retain capsule | Audit/Data Governance | P10-06 | external audit-store redesign would need a new proof model |
| R-24 | duplicate/replayed admin command applies twice | command ID uniqueness, resource revision and audit history | return prior result or conflict; never reapply silently | correct idempotency/optimistic concurrency | clear T1 data | Control Plane Reliability | P10-06 | human intent can still be wrong despite technical idempotency |
| R-25 | deletion tombstone loses to a late event/replay | tombstone epoch and visibility checker across late arrivals | keep data hidden; quarantine incompatible late state | replay deletion; repair materializer/cache; audit recovery | delete T1 data and restore baseline | Deletion/Data Governance | P10-07 | exact legal deletion semantics and backup expiry are human-owned |
| R-26 | restore opens visibility before integrity, custody, deletion or realm readiness | restore state events, access probe at every boundary, DB/receipt/tombstone reconciliation | restored system remains hidden/readiness false | complete missing stage or abandon restore and use another backup | destroy failed restore instance | Restore/Operations | P10-07, P10-11 | RPO/RTO and external integrations may be impossible to prove from research |
| R-27 | restore loses acknowledged events within declared target | pre-backup receipt ledger vs restored custody/materialization | no readiness; incident/restore stop | replay from retained custody or select newer backup under approved plan | destroy failed restore | Restore/Data Reliability | P10-07 | exact acknowledged replay grace and backup topology unknown |
| R-28 | endpoint or server silently drops unacknowledged work under pressure | ledger counts/identities before, during and after disk/queue pressure; file/db snapshots | backpressure and visible health; no silent deletion | expand/recover capacity, then drain; explicit human decision required for any loss policy | remove pressure volume/data | Endpoint/Server Operations | P10-09 | source data can disappear before collection during prolonged fail-closed outage |
| R-29 | hostile input/fault causes unbounded memory, handles, tasks, threads, metrics or series | resource curves, job/process counters, cardinality checker | kill bounded process/job; reject/defer input | add hard bounds and admission checks | kill processes, reset metrics backend/test DB | Reliability/SRE | P10-01, P10-09, P10-10 | exact production budgets are unknown |
| R-30 | logs/metrics/evidence leak identifiers, payloads or seed-driven rare populations | schema allowlist, canaries, cardinality and rare-value tests | stop export; quarantine evidence | remove field/label; rotate/delete artifacts under authority | scanner and storage cleanup | Privacy Observability | P10-10 | vendor agent opaque transformations remain residual |
| R-31 | AppVerifier/Driver Verifier/NotMyFault settings or destructive residue remain | explicit before/after inventory and reboot/revert receipt | environment quarantined; no subsequent pass accepted | reset settings, reboot/revert, verify clean snapshot | mandatory tool-specific reset and VM revert | Windows Lab Operations | P10-01, P10-05 | host/hypervisor residue outside VM may remain |
| R-32 | database container/image/tag or native library changes silently | digest/source ID/compile options, file manifest, SBOM/provenance | stop lane/release evidence | pin admitted bytes; rebuild/re-run all engine campaigns | destroy containers/cache per policy | Dependency/Database Security | P10-03, P10-04, P10-11 | upstream build provenance is not absolute proof |
| R-33 | flaky failure is rerun away or quarantined indefinitely | first-result retention, failure-capsule index, quarantine owner/expiry lint | release remains blocked for load-bearing invariant | classify root cause; fix product/harness/environment | remove only expired test resources, not evidence | Test Governance | E10-20 | rare lab/hardware nondeterminism can be costly to reproduce |
| R-34 | accessibility defect hides status, evidence, or destructive action from reviewers/operators | automated scan plus keyboard, focus, screen-reader and non-color review | block evidence UI/release-control UI use for claimed scope | fix semantics/navigation/content and retest | remove stale UI artifact | Product Accessibility/Support | P10-10 | assistive technology diversity requires human evaluation |
| R-35 | support staff bypass minimization to diagnose a failed campaign | support contract tests, role/access logs, synthetic reproducer availability | deny raw export; use opaque failure capsule | improve T1 reproducer and finite diagnostics | delete unauthorized artifact under incident process | Support/Privacy | P10-10 | organizational pressure can still create policy violations |
| R-36 | manual exercise is missed, stale, or has no accountable owner | invariant registry lint and release evidence expiry check | release gate remains closed | assign owner, perform exercise, attach evidence | clean exercise environment | Architecture/Release Governance | E10-21 | staffing and lab availability are human dependencies |

### 7.1 Mandatory incident and support runbooks

Before the corresponding gate can pass, the following runbooks MUST be exercised with T1 data:

1. **Invariant breach:** stop dependent gates; preserve original capsule; classify product versus harness; no rerun-to-green.
2. **Privacy canary escape:** stop source/upload/ring; enumerate sinks; contain/delete under authority; add neighboring encodings; rerun full chain.
3. **Cross-session or cross-realm acceptance:** global affected-capability stop; quarantine unsent state; invalidate caches/channels; rerun complete identity matrix.
4. **Cursor/effect or receipt/custody violation:** stop delivery; preserve database and WAL/transaction evidence; no manual data edit; repair and replay all failpoints.
5. **Release/update mixed state:** stop candidate; restore previous-good through enterprise mechanism; prove complete inventory and cleanup before re-enable.
6. **Audit split:** disable privileged mutation; reconcile only through approved governance procedure; repair atomicity and replay command histories.
7. **Deletion/restore resurrection:** close visibility; replay tombstones; reconcile caches/materialization/custody; require fresh readiness evidence.
8. **Harness compromise or production hook presence:** freeze signing/promotion; destroy/rebuild runner; rotate test authority; inspect released artifacts.
9. **Database/native dependency incident:** bind exact bytes/source ID; update; rerun corruption, transaction, restore and compatibility campaigns.
10. **Cleanup failure:** quarantine and revert environment; no evidence from subsequent tests is accepted until a clean baseline is proved.
11. **Unclassified flake:** retain first failure, assign owner/expiry, and block the load-bearing gate; do not add a blind retry.
12. **Support without raw data:** reproduce from the failure capsule and T1 fixtures; escalate rather than export real source, user, URL, path or credentials.

---

## 8. Detailed test matrix and smallest falsifying prototypes

### 8.1 Invariant catalogue with formal and plain definitions

Notation:

- `auth(x)` is authenticated realm/session/device/principal context, never a payload claim.
- `D(k,t)` means fact `k` is durable after committed transaction/history point `t`.
- `N(r)` is the stable natural key for source record `r`.
- `E(r)` is the ordinary durable effect or approved final no-event fact for `r`.
- `C(s)` is the durable source checkpoint for source/generation `s`.
- `Custody(b)` is the declared durable inbox state for batch `b`.
- `Receipt(b)` is a server receipt for `b`.
- `Visible(x)` means available through an approved read/control surface.
- `Deleted(x,e)` means deletion epoch/tombstone `e` dominates object `x`.
- `≼` means “no broader/more permissive than.”

| ID | Formal definition | Plain definition | Automated falsification | Real/manual companion | Owner function |
|---|---|---|---|---|---|
| INV-01 Session peer authority | `AcceptedFrame(f) => auth(f).session = verifiedPipeSession = verifiedTokenSession ∧ verifiedLogon ∧ verifiedRelease` | A message is accepted only from the exact verified process in the exact eligible logon/session and release. | M1 generated histories; hostile frame/sequence/peer model | P10-01 Windows multi-logon lab | Windows Security |
| INV-02 Session lifecycle containment | `¬Eligible(session,t) => no PermitIssued(session,t+) ∧ no NewSourceRead(session,t+)` until fresh validation | Lock, disconnect, logoff, process exit, or service restart stops new work and invalidates stale channels. | M1 lifecycle sequences and virtual time | P10-01 real lock/disconnect/logoff/restart | Endpoint Runtime |
| INV-03 Privacy monotonicity | `Effective = meet(Ceiling,Tenant,Emergency,Local,Runtime) ∧ Effective ≼ Ceiling`; undefined meet => deny | Tenant and runtime controls can only reduce collection; uncertainty never grants permission. | exhaustive finite domains, algebraic properties, mutants | P10-02 policy artifact/clock integration | Privacy Policy |
| INV-04 Forbidden-value containment | `Forbidden(v) => v ∉ IPC ∪ Store ∪ Log ∪ Trace ∪ Metric ∪ Network ∪ Dump ∪ Support` | Raw source values and reversible derivatives never leave the approved Task Host memory boundary. | exact canary all-sink scan, dependency/type rules | P10-02/P10-10 process chain and crash sinks | Privacy Engineering |
| INV-05 Cursor atomicity | `C(s)=c => ∀n≤c in committed page domain: D(E(n), same-or-earlier-commit)` | A checkpoint never moves past a row whose event/no-event result is not durable. | M3 state/model; failpoint sweep | P10-03 process kill/SQLite recovery | Endpoint Storage |
| INV-06 One ordinary effect per native key | `∀n: count(D(E(n))) = 1`; incompatible digest => conflict | Retry returns the already stored result; it never creates a second event or overwrites a changed result. | generated retries/conflicts; DB uniqueness mutants | P10-03 native SQLite retries | Endpoint Storage/Data |
| INV-07 Local ACK after durability | `LocalAck(page,t) => D(PageEffects ∧ Checkpoint,t-ε)` | The User Host is acknowledged only after the Coordinator transaction is committed. | hook history checker | P10-03 kill after commit/before ACK | Endpoint Storage |
| INV-08 No partial page | `Committed(page) => all valid effects/no-events ∧ one interpretation ∧ valid bounds`; else none | One bad, mixed, or uncertain row rejects the whole page; no sibling commits and no cursor moves. | hostile page generator/model | P10-03 real transaction snapshot | Endpoint Data Correctness |
| INV-09 Receipt custody | `Receipt(b,t) => Custody(b,t-ε)` in declared failure domain | A receipt means the complete bounded batch is already durably held, not merely parsed or queued in memory. | M4 history checker and pre/post commit hooks | P10-04 DB restart after each boundary | Ingestion Reliability |
| INV-10 Stable receipt replay | `SameBatchIdentity(b) ∧ Custody(b) => retry -> same custody/receipt outcome` | Lost responses cause an idempotent retry, not a new batch. | generated request/drop/retry histories | P10-04 hostile HTTP/TCP response loss | Ingestion Reliability |
| INV-11 One final business effect | `∀event key k: count(FinalMaterialized(k)) ≤ 1` despite attempts/workers | Duplicate delivery, worker restart, and replay create one final fact/aggregate effect. | M4/M8 concurrent histories, mutation | P10-04/P10-08 two-worker DB lane | Processing/Data |
| INV-12 Lease fencing | `Commit(worker,lease=a) accepted => a = currentFence(work)` | An old or expired worker cannot commit after a new worker owns the item. | virtual-clock/barrier permutations | P10-08 database concurrency and worker kill | Processing Reliability |
| INV-13 Poison isolation and custody | `Poison(p) => Custody(p) retained ∧ eventually HealthyProgress(other)` under available resources | Bad work is quarantined without deleting it or blocking unrelated healthy work forever. | generated mixed queues and resource bounds | P10-08 real workers/database | Processing Operations |
| INV-14 Release authorization | `Exec(release) => authorizedSignature ∧ completeManifest ∧ digestMatch ∧ supported ∧ monotonicSequence` | Unauthorized, incomplete, stale, frozen, or downgraded code never executes. | M5 artifact mutations | P10-05 MSI/update lab | Release Security |
| INV-15 Update crash safety | `RecoveredExecutableState ∈ {PreviousGood, CandidateGood}` | Power/process failure leaves a complete known-good old or new release, never a mixed privileged boundary. | every M5 stage fault | P10-05 VM/process reset and inventory | Endpoint Platform/Release |
| INV-16 Realm isolation | `Operation(x) may affect/read y => auth(x).realm = realm(y)` and authorized relation | One realm cannot submit, view, cache, mutate, audit, delete, restore, or materialize as another. | cross-realm generated identifiers/claims | P10-04/P10-06/P10-07 DB/cache/API lanes | Realm Security |
| INV-17 Audit atomicity | `CommittedPrivilegedMutation(c) ⇔ CommittedSuccessAudit(c)` | A privileged change cannot succeed without its durable audit record, and audit cannot claim a rolled-back success. | M6 transaction histories/hooks | P10-06 process/DB session kill | Audit/Data Governance |
| INV-18 Admin command idempotency | `same command_id + same intent => same result`; incompatible reuse => conflict | A retried administrative command does not apply twice or silently change meaning. | generated retry/revision histories | P10-06 API/DB response loss | Control Plane Reliability |
| INV-19 Deletion dominance | `Deleted(x,e) ∧ arrival(x,e'≤e) => ¬Visible(x)` | Late retry, replay, materialization, cache, or restore cannot resurrect data covered by deletion state. | M7 histories and tombstone mutants | P10-07 actual restore/late resend | Deletion Governance |
| INV-20 Restore acknowledged preservation | `AcknowledgedWithinDeclaredRecoverySet(x) => present-or-replayable before RestoreReady` | The restored system does not declare readiness while acknowledged in-scope data is missing. | M7 custody/backup histories | P10-07/P10-11 restore drill | Restore/Data Reliability |
| INV-21 Restore readiness and realm/deletion safety | `VisibleAfterRestore => integrity ∧ custodyReconciled ∧ deletionReplayed ∧ realmChecked ∧ readModelsReady ∧ auditCommitted` | Database startup is not readiness; all safety and data stages finish before users can see restored data. | M7 forbidden-transition checker | P10-07 actual hidden restore/access probes | Restore Operations |
| INV-22 No silent pressure loss | `Unacknowledged(x) ∧ no approved explicit loss decision => retained ∨ visibleBackpressure`, never hidden drop | Full disks, queues and outages defer or signal; they do not quietly discard unacknowledged work. | M8 resource model, drop mutants | P10-09 bounded disk/queue outage | Endpoint/Server Operations |
| INV-23 Bounded hostile impact | For each admitted input/fault, resource vector remains within approved bounds or bounded process/job is terminated | Malformed or adversarial input cannot grow memory, handles, threads, files, waits or metrics without a bound. | generated sizes/cardinality/resource model | P10-01/P10-09/P10-10 lab measurements | Reliability/SRE |
| INV-24 Privacy-safe observability | emitted schema fields and metric labels are finite allowlisted; cardinality is bounded; no forbidden values | Logs, metrics, traces and support evidence reveal state classes, not activity or identities. | schema/cardinality/canary tests | P10-10 actual exporters/evidence UI | Privacy Observability |
| INV-25 Compatibility fail-closed | Unsupported version/field/state is rejected or quarantined; never silently coerced into a broader/older meaning | Old and new components roll out explicitly; unknown contracts do not guess. | old/new executable matrices and mutations | P10-04/P10-05 mixed-version lane | Contract Authority |
| INV-26 Evidence reproducibility and hook absence | deterministic lane failure replays from capsule; production manifest has no test hook/controller | A failure can be reproduced and audited, while the shipped product cannot be fault-controlled. | seed replay, capsule validation, production activation negative test | P10-12 clean builds and binary inspection | Verification/Release Security |
| INV-27 Cleanup completeness | `TestEnd => no unexpected process/job/service/task/rule/cert/file/db/verifier-setting delta` | A destructive test is not a pass if it leaves the machine or database dirty. | cleanup manifest/delta checker and deliberate residue mutants | every lab prototype; P10-12 | Lab Operations |
| INV-28 Data-quality state honesty | receipt, validation, quarantine, materialization, visibility, absent, deferred and unsupported remain distinct | Missing or delayed telemetry is never reported as “no activity,” and custody is not confused with usability. | M4/M8 state/portal contract histories | P10-04/P10-10 UI/API checks | Product/Data Governance |

### 8.2 Fault matrix and exact hook placement

| Hook ID | Boundary being proved | Deterministic action | Expected durable state after recovery | Real-fault companion |
|---|---|---|---|---|
| `endpoint.page.before_begin` | no work before transaction | kill/return disk error | prior checkpoint/effects | kill Coordinator before transaction |
| `endpoint.page.after_effect_insert` | partial event write rolls back | kill or injected SQLite error on occurrence `n` | no new page effects/checkpoint | hard process kill during transaction; test VFS nth-I/O failure |
| `endpoint.page.after_noevent_insert` | no-event fact atomicity | kill/error | no new page facts/checkpoint | hard kill and native recovery |
| `endpoint.page.after_outbox_insert` | event/outbox coupled | kill/error | neither ordinary effect nor checkpoint survives partial transaction | hard kill; inspect DB/WAL |
| `endpoint.page.after_witness_write` | witness not an independent progress authority | kill | no new committed page/checkpoint | hard kill |
| `endpoint.page.before_checkpoint_cas` | effects cannot commit alone under algorithm | kill/error | transaction rollback | hard kill / SQLite I/O error |
| `endpoint.page.after_checkpoint_cas` | in-transaction checkpoint update not durable alone | kill | prior state | hard kill |
| `endpoint.page.before_commit` | commit ambiguity before SQLite commit | kill/I/O error | prior state or engine-declared failure, never cursor ahead | hard kill; disk-full/test VFS |
| `endpoint.page.after_commit_before_ack` | ACK-loss retry | kill Coordinator | committed page; retry returns same IDs/effects | hard process kill/service restart |
| `ingest.before_inbox_transaction` | no receipt before transaction | reset/drop | no custody/receipt | reset client/server connection |
| `ingest.after_identity_insert` | partial inbox writes roll back | kill DB session/process | no receipt; retry safe | terminate DB session/process |
| `ingest.after_payload_insert` | complete payload/identity atomicity | kill | no receipt unless transaction committed | DB process/container stop |
| `ingest.before_inbox_commit` | pre-commit response forbidden | block/kill | no receipt; retry may commit later | database restart |
| `ingest.after_commit_before_response` | post-commit response loss | drop response/reset | custody exists; same receipt on retry | hostile HTTP server/Toxiproxy reset |
| `worker.after_lease_grant` | worker may die after owning item | kill worker | lease eventually expires; no double effect | process kill |
| `worker.before_materialize_commit` | no fact from partial transaction | kill/DB error | no final fact/completion | DB session kill/deadlock |
| `worker.after_fact_before_complete` | fact and work completion atomic/idempotent | kill | retry sees one fact and completes safely | process/DB kill |
| `worker.before_fenced_commit` | stale lease rejected | barrier until lease expiry, then continue | stale commit denied | two real workers + database clock/lease |
| `admin.after_authorize` | authorization alone has no effect | kill | no mutation/success audit | API process kill |
| `admin.after_mutation_before_audit` | mutation/audit same transaction | kill/error | neither committed | DB session/process kill |
| `admin.after_audit_before_commit` | audit cannot claim rolled-back success | kill/error | neither success survives | DB stop/restart |
| `admin.after_commit_before_response` | admin retry idempotency | drop response | one mutation/audit; prior result returned | proxy reset |
| `deletion.after_tombstone_commit` | tombstone dominates later work | pause materializer/send late event | hidden/suppressed according to model | real late upload/worker |
| `deletion.after_fact_delete_before_ready` | deletion readiness cannot be early | kill | visibility stays closed/deletion not ready | DB/app process kill |
| `restore.after_database_load` | restored DB is hidden | open-access probe/kill | no visibility | actual restored instance with network access blocked |
| `restore.after_integrity_check` | integrity alone insufficient | attempt readiness | hidden until remaining stages | actual restore + API probe |
| `restore.after_custody_reconcile` | deletion/realm/read model still required | kill/probe | hidden | process kill |
| `restore.after_tombstone_replay` | caches/read models/readiness still required | probe | hidden | actual cache/read-model restart |
| `restore.before_visibility_ready_commit` | readiness and audit atomic | kill | visibility closed | DB/app kill |
| `release.after_download_part` | incomplete candidate rejected | kill/corrupt/missing file | previous good runs | VM/process reset |
| `release.after_manifest_verify` | content still must stage completely | kill | previous good | VM reset |
| `release.after_stage_before_switch` | staging not execution | kill | previous good | service/VM restart |
| `release.after_switch_before_health` | candidate not current-good before health | kill/fail health | rollback or safe hold | VM reset/NotMyFault approved scenario |
| `release.rollback.before_restore_previous` | rollback interruption safe | kill | recoverable previous/candidate-safe state, never mixed | repeated VM reset |

**RECOMMENDATION.** The deterministic hook campaign sweeps every hook with `once` and relevant `nth` occurrences. SQLite I/O hooks also sweep a sticky “all later operations fail” mode, following SQLite's own documented testing pattern [W03].

### 8.3 Cross-layer detailed test matrix

| Concern | Pure/model lane | Component/hook lane | Real CI/lab lane | Pilot/operational lane | Primary stop condition |
|---|---|---|---|---|---|
| Session isolation | all M1 command permutations under bounded actors | fake kernel-identity adapters and message parser faults | two real logons/sessions, process replacement, malformed/slow clients, service restart | authorized shadow health only; no real activity | one unauthorized accepted app message |
| Privacy monotonicity | exhaustive small lattice + generated large lattice | policy parser/signature/time adapter failures | signed/test-signed artifacts, clock changes, all-sink process chain | policy canary monitoring | one broadening or forbidden escape |
| Cursor/SQLite | M3 histories, page validity and natural-key laws | every transaction hook, test VFS I/O faults | native SQLite process kill, disk-full volume, VM reset, integrity/replay | none before G5; later outage drill | cursor ahead, partial page, duplicate effect |
| Receipt/idempotency | M4 histories and checker | commit/response hooks, hostile server | PostgreSQL and SQL Server DB restart/session kill + TCP reset | bounded synthetic traffic/shadow | receipt without custody or >1 effect |
| Update rollback | M5 artifacts/stages | in-process manifest/staging hooks | MSI/service/VM reset, corrupt/missing/stale/downgrade candidates | authorized release ring exercise | unauthorized execution or mixed boundary |
| Realm isolation | generated same IDs/claims across realms | repository/API/DB adapters, cache keys | real relational schemas, APIs and cache/test instances | authorized negative probes | one cross-realm read/mutation/delete |
| Audit atomicity | M6 transaction histories | every mutation/audit hook | process/DB kill and response loss | controlled admin exercise | mutation without durable success audit |
| Deletion/restore | M7 late arrival/backup histories | readiness/tombstone hooks | actual backup, hidden restore, integrity, replay, cache/index rebuild | formal restore drill | acknowledged loss or deleted visibility |
| Pressure/outage | M8 bounded queues/disks/leases | allocation/disk/quota adapters | bounded volumes, stopped dependencies, long synthetic outage | approved pilot backpressure exercise | silent unacknowledged drop |
| Observability | schema/cardinality model | logger/exporter/evidence adapters | real collectors, crash/support paths, accessible viewer | metric-budget and alert review | forbidden value, unbounded series, misleading state |
| Harness trust | checker mutants, seed/shrink tests | deliberate lost event/hook/controller error | production build scan, runner isolation, cleanup mutation | periodic independent review | harness accepts planted invariant breach |

### 8.4 Smallest falsifying prototypes

#### P10-01 — session isolation, IPC state, and real process lifecycle

| Field | Specification |
|---|---|
| Claim | **CLI EXPERIMENT.** An application frame is accepted only from the exact verified ordinary-token User Host in the eligible logon/session and current protected release; lock, disconnect, logoff, restart and process replacement invalidate stale authority. |
| Setup | Approved disposable Windows VM; exact test build; two wholly fictional local test accounts plus two distinct logons for one account where supported; synthetic messages only; G1 topology installed through the test MSI/enterprise mechanism. A missing multi-session capability is `BLOCKED`, never `PASS`. |
| Instrumentation | kernel-reported pipe process/session IDs; process creation time; token/logon SID/authentication LUID/integrity/elevation categories; service/task/job/process events; hook history; finite IPC reasons; handle/thread/memory counts; all-sink canaries; before/after machine inventory. |
| Steps | (1) run hand histories; (2) generate M1 sequences; (3) attempt bootstrap application data; (4) same account/different logon handoff theft; (5) wrong session/process/image and PID-reuse-style replacement; (6) duplicate/reordered/oversized/slow frames; (7) lock/disconnect/reconnect/logoff; (8) kill Coordinator/User Host/Task Host at every hook; (9) restart service and attempt stale channel; (10) run Application Verifier Basics, Cuzz and targeted Low Resource Simulation on each user-mode executable, then repeat without injection. |
| Pass | zero unauthorized accepted application frames; no permit/source work while ineligible; fresh handshake after lifecycle change; bounded resources; no prohibited privilege/profile read; complete cleanup; canaries absent from all unauthorized sinks. |
| Fail | one cross-session/logon frame accepted; bootstrap carries app data; stale channel remains valid; unbounded handle/thread/memory growth; uncontrolled child/network/write; verifier finding without understood resolution; cleanup residue. |
| Evidence | T1 history/failure capsule, sanitized token/session matrix, accepted/rejected counts, process/job lifecycle, verifier configuration/result, canary scan, cleanup receipt, exact OS/runtime/build class. |
| Duration | **ESTIMATE:** pure campaign seconds to minutes; one user-mode verifier matrix 30–120 minutes per named environment; multi-session lifecycle 30–90 minutes. Replace with measured CI/lab distributions. |
| Cleanup | `appverif /n <TEST-EXECUTABLE>` or exact approved equivalent; kill test job/processes; uninstall/repair test MSI; remove fictional users/tasks/services/certs/rules/files; reboot/revert VM; verify zero unexpected delta. |

Smallest expected counterexample:

```text
SessionLogon(logon-A, session-2)
SessionLogon(logon-B-same-account, session-3)
UserHostVerified(logon-A)
DedicatedPipeIssued(logon-A)
ConnectDedicated(from logon-B)
SendFrame(valid-sequence-and-payload-claims-logon-A)
=> FrameAccepted  # INV-01 violation
```

#### P10-02 — privacy lattice, artifact lifecycle, virtual clocks, and raw-value containment

| Field | Specification |
|---|---|
| Claim | **CLI EXPERIMENT.** Every effective policy is no broader than the release ceiling; malformed/unsupported candidates grant no permission; security-significant failures enter `SafetyHold`; forbidden T1 source canaries never cross the Task Host boundary. |
| Setup | Pure finite lattice model; exact strict schemas; fictional product ceiling, realm policies, emergency overlays, clock states, run intents/permits, matcher snapshots and raw URL canary corpus. Component lane uses synthetic Task Host→User Host→Coordinator chain only. |
| Instrumentation | model transitions and meet proof; candidate states; virtual wall/monotonic clocks; permit digests; IPC captures; logs/traces/metrics; endpoint SQLite/WAL/SHM; network capture; controlled crash/support artifacts; scanner positive controls. |
| Steps | (1) exhaust all combinations of a small lattice; (2) generated larger sets/maxima/transform DAGs; (3) test commutativity, associativity, idempotence and absorption/ceiling laws; (4) wrong realm, lower revision, same revision/different content, unknown ID, expiry, clock regression, key-purpose confusion; (5) mutate meet/default/failure logic; (6) issue permit then narrow/expire/cancel during page; (7) transform success, deny, unmatched, ambiguous, invalid, crash and cancellation with every canary/encoding; (8) deliberately break scanner and leak one canary to prove failure. |
| Pass | no broadening counterexample; unknown/incomparable values deny; candidate state matches the accepted split; stale permit/page cannot commit; every planted canary is detected by scanner self-test and zero canary/declared derivative appears outside source fixture. |
| Fail | one broadened effective policy, lower revision accepted, wrong-realm activation, expired authority collects, stale page commits, mandatory scanner miss, or forbidden value/derivative in any sink. |
| Evidence | minimal property counterexamples, law coverage, mutation report, exact artifact digests, clock history, permit/page history, all-sink manifest and scan, cleanup receipt. |
| Duration | **ESTIMATE:** exhaustive/pure lane under 10 minutes per change; full process/sink lane 15–60 minutes. Corpus size is tuned by measured defect yield, not fixed as timeless architecture. |
| Cleanup | delete only T1 policies/keys/certs/databases/captures; stop processes; verify scanner reports contain no raw marker except approved registry location. |

Smallest expected counterexample:

```text
Ceiling.sources = {EdgeHistory}
Tenant.sources  = {EdgeHistory, ProcessList}
Effective       = union(Ceiling, Tenant)
=> ProcessList authorized  # INV-03 violation
```

#### P10-03 — G5 SQLite whole-page crash invariant

| Field | Specification |
|---|---|
| Claim | **CLI EXPERIMENT.** For every transaction boundary and I/O failure point, a recovered endpoint store has either the complete prior page state or the complete committed new page state; ACK loss reuses the same event IDs/effects. |
| Setup | Exact admitted .NET provider/native SQLite test profile; T1 `STRICT` endpoint schema; WAL mode; one writer; page with at least one event, one approved no-event, witness update and checkpoint advance; independent ledger. A test-only VFS/shim is admitted separately and never used in production. |
| Instrumentation | all endpoint hooks; SQLite return/extended codes; loaded native hash/source ID/compile options; operation ordinal; database/WAL/SHM digests; integrity check; row-level logical dump restricted to T1; process/service events; filesystem trace; event/cursor ledger. |
| Steps | (1) run no-fault baseline; (2) for each hook, kill once before/after the boundary; (3) for each VFS I/O ordinal, fail once, then sticky after the first failure, until the operation completes without injected failure; (4) disk-full bounded volume; (5) cancel and service restart; (6) kill after commit/before ACK and retry exact page; (7) repeat an identical page; (8) reuse natural key with changed digest; (9) corrupt only a disposable copy to prove detection; (10) optional approved VM reset at commit-sensitive stages. |
| Pass | pre-commit failures recover prior state; post-commit/pre-ACK recovers complete page; cursor never ahead; every native key has exactly one effect; event ID is stable; incompatible digest is conflict/no progress; no source-file write; database integrity and logical ledger pass; cleanup complete. |
| Fail | partial page, effect without required checkpoint relation, cursor ahead, missing no-event, duplicate effect/outbox, changed event ID, ACK before commit, corruption accepted, write to source fixture, or unknown recovery state. |
| Evidence | one capsule per distinct failing boundary, hook/VFS ordinal map, original/minimal history, DB/WAL/SHM digests and logical snapshots, integrity result, native inventory, process/file trace, cleanup receipt. |
| Duration | **ESTIMATE:** hook sweep 5–20 minutes; nth-I/O sweep 15–120 minutes depending on operation count; VM-reset subset 30–90 minutes. Replace with measured sharding data. |
| Cleanup | close/kill product processes; copy failure DB to restricted T1 evidence by digest; remove product-owned test DB/WAL/SHM; detach pressure volume; revert VM; verify no source or process residue. |

Smallest expected counterexample:

```text
BEGIN
insert effect(native=4201, event_id=A)
update checkpoint=4201
CRASH before durable COMMIT
RECOVER: checkpoint=4201, effect absent
=> INV-05 violation
```

#### P10-04 — durable custody, lost responses, receipt replay, and one materialization

| Field | Specification |
|---|---|
| Claim | **CLI EXPERIMENT.** A receipt is returned only after relational durable custody; a lost response and any number of identical retries yield one inbox item, one stable receipt outcome and one final business effect. |
| Setup | T1 endpoint batch and identities; modular-monolith ingestion API; exact PostgreSQL reference image/test build first and SQL Server candidate lane later; two workers; hostile HTTP server and/or Toxiproxy; strict realm-auth context; no broker. |
| Instrumentation | ingress hooks; request/response operation history; DB transaction IDs/snapshots; batch/event uniqueness; receipt table; validation/quarantine/materialization/visibility states; worker lease/fence history; network proxy event log; resource and canary metrics. |
| Steps | (1) baseline custody/receipt; (2) kill or terminate DB session at each pre-commit hook; (3) commit inbox then drop/reset response; (4) retry identical batch many times; (5) retry same ID with incompatible bytes; (6) duplicate/reorder requests at the app harness; (7) kill worker before fact commit and after fact before completion; (8) two workers race; (9) poison one item while healthy items exist; (10) restart API/database/workers; (11) test unsupported contract/realm claims. |
| Pass | no receipt before custody; response loss retries to same outcome; one inbox identity and one final effect; incompatible reuse conflicts/quarantines; stale lease cannot commit; healthy work progresses; receipt/validation/materialization/visibility states stay distinct; realm comes from authentication. |
| Fail | premature receipt, custody loss, duplicate business effect, new identity minted on retry, wrong-realm acceptance, poison deletes custody/blocks all healthy work, stale worker commit, or state conflation. |
| Evidence | request/network/DB/worker history, durable snapshots, receipt/effect uniqueness queries, checker result, exact engine/image build, canary scan, cleanup receipt. |
| Duration | **ESTIMATE:** 15–45 minutes per engine for hook/proxy matrix; 1–4 hours for repeated process/database restart and poison/worker concurrency lane. |
| Cleanup | reset proxy; stop containers/processes; drop T1 databases/users/certs; remove volumes/networks; verify runner resource cleanup. |

Smallest expected counterexample:

```text
SendBatch(B)
InboxCommit(B)
DropResponse
RetryBatch(B)
InsertInboxAgain(B)
Materialize(event E) twice
=> INV-10 and INV-11 violations
```

#### P10-05 — release authorization, crash-safe activation, and rollback

| Field | Specification |
|---|---|
| Claim | **CLI EXPERIMENT.** Only a complete, authorized, supported and monotonic fictional release executes, and interruption at every stage leaves a complete previous-good or candidate-good state. |
| Setup | Disposable Windows VM; MSI-owned test service/task/files; previous-good and candidate T1 builds; test-only signing hierarchy; higher/lower revisions; corrupt/missing/extra file variants; health probe with finite result. Optional updater remains absent unless separately approved. |
| Instrumentation | file manifest/digests/signatures; service/task configuration hashes; process image/file identity; release state events; hook/controller history; boot/restart results; before/after inventory; Application Verifier where relevant; approved NotMyFault/VM reset only in destructive lane. |
| Steps | (1) valid upgrade/repair/uninstall; (2) invalid signature/key purpose/realm/audience; (3) missing/extra/wrong digest; (4) stale/frozen/lower sequence; (5) kill after every download/stage/switch/health/rollback hook; (6) reboot/VM reset after selected stages; (7) fail candidate health; (8) interrupt rollback repeatedly; (9) old/new local IPC compatibility; (10) attempt to execute a staged but not active binary; (11) scan production-shaped artifact for test hooks. |
| Pass | invalid candidates never execute; staged is not active; each recovery state is complete previous-good, complete health-approved candidate, or explicit safe hold; rollback restores a consistent previous release; no mixed service/task/file/config; same digest is promoted; no test hook/controller in production manifest. |
| Fail | unauthorized/downgraded/incomplete execution, mixed boundary, stale service path, lower revision rollback, staged binary runs, rollback loop without containment, or cleanup residue. |
| Evidence | release state history, file/service/task/process inventories at every crash point, signature/digest results, VM/reboot markers, health/rollback outcome, artifact absence scan, cleanup receipt. |
| Duration | **ESTIMATE:** 1–3 hours for process/reboot matrix per supported environment; destructive VM reset subset 2–6 hours when fully enumerated and sharded. |
| Cleanup | restore snapshot or enterprise uninstall/repair; remove test certificates/keys/tasks/services/firewall rules/staging; reset verifier settings; verify baseline inventory. |

Smallest expected counterexample:

```text
InstalledGood(v2)
Stage(v3, missing UserHost.dll)
SwitchServicePathTo(v3)
Restart
Coordinator(v3) runs with UserHost(v2)
=> INV-14/INV-15 violation
```

#### P10-06 — realm isolation, administrative idempotency, and audit atomicity

| Field | Specification |
|---|---|
| Claim | **CLI EXPERIMENT.** Authenticated realm and authorization constrain every read/mutation/cache row, and each committed privileged mutation has exactly one matching durable success audit in the same outcome. |
| Setup | Two or more fictional realms with deliberately colliding UUIDs/external refs/names; T1 principals/roles; control API; relational database; cache/test read model; privileged command with optimistic revision and command ID. |
| Instrumentation | authenticated-context trace separate from payload; SQL command/parameter shape; realm-prefixed rows/indexes; cache keys; authorization decision; mutation/audit transaction hooks; DB snapshot; response-loss proxy; access logs with finite codes. |
| Steps | (1) cross-realm read/mutate/delete claims; (2) same IDs across realms; (3) prime cache in realm A then query realm B; (4) authorization/revision changes between read/write; (5) crash after authorize, after mutation before audit, after audit before commit, after commit before response; (6) retry same command ID/same intent; (7) same command ID/different intent; (8) deny case and security audit; (9) database restart and consistency queries. |
| Pass | zero cross-realm view/mutation/delete; payload claims ignored/rejected; cache partition correct; mutation and success audit both commit or neither; response retry returns prior outcome; incompatible command reuse conflicts; denied mutation has no success audit. |
| Fail | one cross-realm effect/read, mutation without audit, audit claiming rolled-back success, duplicate mutation, unscoped query/cache, or payload-derived realm authority. |
| Evidence | model and API histories, auth-vs-payload trace, SQL/DB snapshots, mutation/audit reconciliation, cache probes, response-loss history, cleanup. |
| Duration | **ESTIMATE:** pure/property lane under 10 minutes; DB/API hook and proxy lane 20–60 minutes per engine. |
| Cleanup | clear T1 cache; drop T1 realms/database; stop proxy/services; remove test principals/certs. |

Smallest expected counterexample:

```text
Authenticate(realm=A)
Payload.realm=B
AdminMutate(resource=B/id=42)
MutationCommitted(B)
AuditCommitted(A)
=> INV-16 and INV-17 violations
```

#### P10-07 — deletion dominance, late replay, restore readiness, and acknowledged preservation

| Field | Specification |
|---|---|
| Claim | **CLI EXPERIMENT.** A committed deletion state dominates late replay and restore; a restored system remains hidden until integrity, acknowledged custody, deletion, realm, materialization/read-model and audit readiness all pass. |
| Setup | T1 realms/events/batches/receipts/facts/caches; abstract approved deletion scope; backups taken before and after tombstone; late endpoint retry; PostgreSQL first, SQL Server candidate; application visibility gate. Exact retention/RPO/RTO inputs are placeholders owned by humans. |
| Instrumentation | deletion/tombstone epoch ledger; inbox/receipt/fact/cache/index snapshots; backup manifest; restore engine logs; integrity results; API access probes; readiness events; audit record; canary scan. |
| Steps | (1) ingest/materialize/receipt T1 facts; (2) take backup; (3) commit deletion tombstone and hide/delete/mask according to model; (4) resend acknowledged/unacknowledged late batch; (5) restore pre-tombstone backup into isolated hidden instance; (6) probe visibility after every restore hook; (7) engine integrity check; (8) custody reconciliation; (9) replay deletion state; (10) rebuild facts/index/cache; (11) realm-negative probes; (12) commit restore audit/readiness; (13) open visibility; (14) compare receipt/custody ledger; (15) repeat with omitted tombstone replay and missing acknowledged item as deliberate mutants. |
| Pass | late covered data never becomes visible; pre-ready probes fail closed; acknowledged in-scope set is present or replayable before readiness; deletion replay removes/suppresses restored data; cache/read model cannot resurrect; realm isolation and restore audit pass; actual restore/integrity succeeds. |
| Fail | early visibility, deleted resurrection, acknowledged loss while ready, tombstone ignored, wrong-realm visibility, cache resurrection, `VERIFYONLY` treated as full proof, or readiness without audit. |
| Evidence | backup/restore manifests and digests, receipt/tombstone/visibility ledgers, actual engine integrity output, readiness history, access probes, audit row, cleanup receipt. |
| Duration | **ESTIMATE:** small T1 database 30–120 minutes per engine; production-representative restore duration is unknown and belongs to later RPO/RTO evidence. |
| Cleanup | destroy failed/complete restore instance after evidence; delete T1 backups under manifest; clear caches/volumes/users/certs; verify no network visibility remains. |

Smallest expected counterexample:

```text
Backup(before deletion)
Delete(subject X, epoch=5)
Restore(backup)
OpenVisibility before tombstone replay
Read(X) succeeds
=> INV-19/INV-21 violation
```

#### P10-08 — worker lease fencing, poison handling, and concurrency

| Field | Specification |
|---|---|
| Claim | **CLI EXPERIMENT.** With two or more workers, an expired/stale lease cannot commit; one worker crash or poison item does not create duplicate effects or permanently block healthy work. |
| Setup | T1 durable inbox with healthy and poison items; two worker processes; virtual-clock component lane and exact database concurrency lane; fencing token in every commit. |
| Instrumentation | lease/fence rows; worker process IDs/roles; barrier and virtual-time history; DB locks/transactions; fact/completion/quarantine rows; retry counters with finite labels; resource curves. |
| Steps | (1) worker A leases and pauses; (2) advance expiry; (3) worker B leases new fence and commits; (4) release A and attempt commit; (5) kill A/B before/after fact; (6) DB deadlock/serialization failure; (7) poison parse/materialization error; (8) healthy items around poison; (9) restart workers/database; (10) repeat permutations using PostgreSQL isolation-style schedules and SQL Server transactions. |
| Pass | stale A commit rejected; one final effect; work completion/fact consistent; poison retains custody/quarantine; healthy progress occurs; retries bounded/classified; no lease based solely on untrusted wall-clock payload. |
| Fail | stale commit, double effect, lost custody, poison head-of-line blocks all healthy work, unbounded retries, or worker marks complete without effect. |
| Evidence | operation/permutation history, lease/fence/fact snapshots, process and DB events, minimal counterexample, resource/cleanup evidence. |
| Duration | **ESTIMATE:** 15–60 minutes per engine for deterministic permutations; longer soak belongs to pilot/capacity lane. |
| Cleanup | stop workers; clear T1 database/containers; release locks; verify no orphan process or lease remains. |

Smallest expected counterexample:

```text
A leases work with fence=1
lease expires
B leases with fence=2 and commits fact
A resumes and commits with fence=1
=> two facts  # INV-11/INV-12 violation
```

#### P10-09 — endpoint/server pressure, long outage, and no silent loss

| Field | Specification |
|---|---|
| Claim | **CLI EXPERIMENT.** Under bounded disk, queue, dependency and long-outage pressure, unacknowledged T1 work is retained or explicitly backpressured with visible finite health; no hidden discard occurs. |
| Setup | Synthetic endpoint outbox and server inbox; bounded disposable volumes/quotas; controllable network/database outage; fictional 6,000-endpoint identity population for server scheduling without claiming production capacity; exact load distributions are replaceable estimates. |
| Instrumentation | identity ledger at every stage; disk/DB size, queue length, writes, errors, retries; process resources; finite health state; transport attempts/receipts; no-drop checker; metrics cardinality; cleanup. |
| Steps | (1) fill endpoint volume near each boundary; (2) block upload while collection attempts continue; (3) restore network and drain; (4) fill server inbox/worker capacity; (5) stop database/integration; (6) inject poison and resource limits; (7) restart processes; (8) compare every generated identity to durable/acknowledged/final state; (9) deliberately enable a test-only drop-oldest mutant to prove detection; (10) run synthetic 6,000-device scheduling/connection/batch identity smoke without declaring capacity. |
| Pass | zero silent drop; checkpoint does not move for uncommitted pages; unacknowledged work retained; backpressure/unsupported state visible; drain preserves stable identities/one effect; bounded resources and finite labels; cleanup complete. |
| Fail | missing identity without approved explicit state, cursor movement over lost page, hidden drop-oldest, retry storm without bound, deadlock/no recovery, or cardinality/resource escape. |
| Evidence | generated/durable/receipt/materialization set reconciliation, disk/queue/resource time series with finite labels, outage/drain history, mutant result, environment and cleanup. |
| Duration | **ESTIMATE:** short pressure lanes 30–120 minutes; long-outage simulation uses virtual time where semantics allow and a separately approved real soak. Production-duration outage evidence is later-gate work. |
| Cleanup | remove disposable quotas/volumes/databases; restore network; kill processes; verify full drain or record remaining T1 work before deletion. |

#### P10-10 — observability, error taxonomy, canaries, cardinality, support, and accessibility

| Field | Specification |
|---|---|
| Claim | **CLI EXPERIMENT.** Every failure path emits only finite, privacy-safe, bounded observability and evidence; state categories remain honest; the evidence viewer/control status is accessible for the claimed scope. |
| Setup | T1 canaries for raw URL components, identities, paths, secrets and derivatives; every finite error class; logger, trace, metric and support/evidence adapters; optional evidence UI populated from fictional capsules. |
| Instrumentation | all sink collectors; metric-series counter and overflow; schema allowlist; exception summarizer; evidence manifest; access logs; automated accessibility scanner; keyboard/focus/screen-reader checklist. |
| Steps | (1) trigger each error class at each component; (2) generate many distinct hostile IDs/strings/exceptions; (3) scan all sinks/encodings; (4) verify no raw exception/path/payload; (5) verify `Deferred`, `Unsupported`, `Quarantined`, `Received`, `Materialized`, `Visible` remain distinct; (6) exceed cardinality budget; (7) deliberate dynamic-label/raw-message mutants; (8) exercise support CLI with opaque token; (9) keyboard-only navigation, focus order, non-color status, screen-reader headings/error summary, destructive-action confirmation. |
| Pass | zero forbidden values/derivatives; only allowed fields/labels; bounded series/resource behavior; finite stable errors; honest state semantics; support cannot export raw data; accessibility exercise passes declared controls. |
| Fail | sink leak, dynamic/high-cardinality label, raw exception, misleading state, support bypass, inaccessible critical status/action, or scanner positive-control miss. |
| Evidence | sink and cardinality matrix, schema validation, scanner result, metric/resource snapshot, state-contract tests, accessibility automated/manual record, cleanup. |
| Duration | **ESTIMATE:** 10–45 minutes per component chain; manual accessibility exercise 30–90 minutes per viewer release. |
| Cleanup | delete T1 telemetry/evidence/UI deployment; stop collectors; verify no canary outside registry/fixture. |

#### P10-11 — relational-engine parity and actual restore discipline

| Field | Specification |
|---|---|
| Claim | **CLI EXPERIMENT.** PostgreSQL reference and SQL Server candidate run the same UAM semantic scenarios and restore assertions; engine-specific tools may differ but cannot change receipt, idempotency, audit, realm, deletion or readiness meaning. |
| Setup | Identical T1 scenario package, schema semantics and checker; PostgreSQL 18.4 ordinary release image plus separate source-built injection-point test lane; SQL Server 2025 exact admitted CU candidate; disposable instances; exact backup/restore scripts. |
| Instrumentation | engine/version/image/binary identity; schema/index/constraint manifest; transaction/isolation history; hooks or black-box process/session faults; backup manifest; actual restore; PostgreSQL integrity/logical checks; SQL Server restore plus `DBCC CHECKDB`; query-result and UAM checker reconciliation. |
| Steps | (1) run P10-04/P10-06/P10-07/P10-08 semantic corpus on both engines; (2) PostgreSQL injection points and isolation permutations in test build, then black-box ordinary image; (3) SQL Server session kills/deadlocks/process/container stop; (4) backup; (5) `VERIFYONLY` as preliminary check where applicable, not proof; (6) actual isolated restore; (7) integrity checks; (8) replay UAM tombstone/custody/readiness checks; (9) compare semantic outcome and operational evidence. |
| Pass | identical UAM invariant outcomes; engine-specific transient codes map to finite taxonomy; uniqueness/realm/audit/deletion constraints hold; actual restore and integrity pass; no readiness before UAM reconciliation. |
| Fail | semantic divergence, premature receipt, duplicate effect, cross-realm row, audit split, deletion resurrection, restore accepted without actual integrity, or unmapped engine behavior. |
| Evidence | per-engine manifest, scenario histories, schema/constraint diff, backup/restore/integrity records, UAM checker comparison, cost/resource observations, cleanup. |
| Duration | **ESTIMATE:** 1–4 hours per small T1 engine restore/fault suite; production benchmark/restore time remains later evidence. |
| Cleanup | destroy databases/containers/VMs and backups; remove users/certs/volumes; verify no engine process/port/resource remains. |

#### P10-12 — harness self-test, mutation sensitivity, replay, and production-hook absence

| Field | Specification |
|---|---|
| Claim | **CLI EXPERIMENT.** The harness fails when each primary invariant is deliberately broken, preserves/replays a deterministic failure, distinguishes harness failure, and proves production artifacts cannot activate test hooks. |
| Setup | one small deliberate mutant per invariant family; pure model/checker projects; test and production builds from clean locked restore; exact T1 seed/capsule. |
| Instrumentation | mutation report; invariant-to-mutant map; replay CLI exit/result; build/file/SBOM/provenance manifests; binary dependency/symbol/string/API scan; test-hook activation probe; canary and cleanup self-mutations. |
| Steps | (1) invert policy meet; (2) move checkpoint outside transaction; (3) emit receipt before commit; (4) remove uniqueness/fence; (5) allow wrong realm; (6) separate audit commit; (7) open restore early; (8) drop unacknowledged item; (9) add raw log label; (10) ignore cleanup residue; (11) replay each seed; (12) corrupt/remove capsule record and require validation failure; (13) build production; attempt to load/control hook catalogue; (14) compare two clean unsigned builds. |
| Pass | every deliberate primary mutant is detected by at least one named test; deterministic failures replay to same invariant and essential history; corrupt capsule is rejected; harness failures are not product passes; production has no hook/controller/schedule path; clean builds meet accepted reproducibility rules. |
| Fail | critical mutant survives, failure cannot replay without unexplained cause, capsule accepts missing data, production hook activation succeeds, artifact mismatch unexplained, scanner misses canary, or cleanup mutant passes. |
| Evidence | invariant-mutant matrix, Stryker/manual mutation results, replay transcripts, capsule validator results, file/SBOM/provenance and build comparison, production activation negative result. |
| Duration | **ESTIMATE:** pure mutation lane 10–60 minutes per module when sharded; artifact/replay gate 15–45 minutes. Exact budgets are measured and human-approved. |
| Cleanup | remove mutant branches/builds and T1 artifacts after retaining digests/results; destroy disposable runner workspace; verify clean repository and cache policy. |

### 8.5 Prototype dependency order

```text
P10-12 harness core and self-tests
  -> P10-02 policy/privacy pure lane
  -> P10-03 SQLite model/hook lane
  -> P10-04 server custody model/hook lane
  -> P10-06 realm/audit model/hook lane
  -> P10-08 lease model/hook lane

Passed G1 environment + approved Windows lab
  -> P10-01 real Windows lane
  -> P10-03 real endpoint lane
  -> P10-05 release lane

P10-04 + P10-06 + P10-08
  -> P10-11 engine parity

P10-04 + deletion semantics HUMAN DECISION + backup setup
  -> P10-07 restore/deletion

All relevant component lanes
  -> P10-09 pressure/outage
  -> P10-10 observability/support/accessibility
```

A blocked environment or human decision does not convert a skipped real-boundary test into a pass. The invariant registry records `BLOCKED` and names the dependent gate.

---

## 9. Architecture fitness functions and measurable acceptance criteria

### 9.1 Primary acceptance expression

```text
PROMPT_10_PRIMARY_GATE =
    EVERY_LOAD_BEARING_INVARIANT_HAS_FALSIFIER_OR_OWNED_MANUAL_EXERCISE
    AND ALL_INVARIANT_REGISTRY_ENTRIES_SCHEMA_VALID
    AND CRITICAL_HAND_AUTHORED_MUTANTS_SURVIVING = 0
    AND UNCLASSIFIED_LOAD_BEARING_FLAKES = 0
    AND FORBIDDEN_VALUE_ESCAPES = 0
    AND UNAUTHORIZED_SESSION_OR_REALM_EFFECTS = 0
    AND CURSOR_AHEAD_CASES = 0
    AND RECEIPTS_WITHOUT_CUSTODY = 0
    AND FINAL_BUSINESS_DUPLICATES = 0
    AND PRIVILEGED_MUTATIONS_WITHOUT_SUCCESS_AUDIT = 0
    AND UNAUTHORIZED_OR_MIXED_RELEASE_EXECUTIONS = 0
    AND DELETED_DATA_VISIBLE_AFTER_READY = 0
    AND ACKNOWLEDGED_IN_SCOPE_DATA_MISSING_AT_RESTORE_READY = 0
    AND SILENT_UNACKNOWLEDGED_DROPS = 0
    AND PRODUCTION_CALLABLE_TEST_HOOKS = 0
    AND CLEANUP_FAILURES = 0
    AND FIRST_FAILURE_EVIDENCE_RETAINED = true
```

A percentage or risk narrative cannot compensate for a nonzero primary invariant count. Any human-approved exception must be outside the non-negotiable baseline, explicit, time-bounded, owned and recorded as a HUMAN DECISION; code cannot silently waive it.

### 9.2 Static architecture fitness functions

| ID | Fitness function | Measurement | Gate |
|---|---|---|---|
| FF-01 | Production modules do not reference verification projects | compiled project/package dependency graph | zero forbidden edges |
| FF-02 | Production artifact contains no hook controller/schedule schema/test key/destructive tool | final file manifest, SBOM, dependency/symbol/string/API scan, activation negative test | zero callable/control paths |
| FF-03 | Pure models/checkers have no OS, network, SQL, process, ambient clock or global random dependency | analyzer and architecture mutation tests | zero forbidden APIs/references |
| FF-04 | Checker project does not reference production decision/storage code | project graph and namespace/API guard | zero references |
| FF-05 | Governed domain code does not call `DateTime.UtcNow`, `DateTime.Now`, unwrapped `Task.Delay`, `Thread.Sleep`, `Random.Shared`, or `new Random()` | analyzer/source guard with explicit adapter exceptions | zero violations in governed projects |
| FF-06 | Every transaction/authority boundary is listed in hook catalogue and invariant registry | graph between hooks, invariants and prototypes | 100% structural mapping for load-bearing boundaries |
| FF-07 | Every hook has a real-boundary companion or owned manual reason | invariant/hook registry query | zero unowned gaps |
| FF-08 | Contract objects are closed and local-reference-only | schema lint and hostile vectors | no remote refs, duplicate/unknown acceptance or permissive defaults |
| FF-09 | Realm authority is not accepted from payload | schema/API/static query guards plus generated negative tests | zero payload-authority paths |
| FF-10 | Relational data access carries realm/installation scope where required | query/ORM interceptors, schema constraints and dynamic realm tests | zero unscoped load-bearing access paths |
| FF-11 | Feature/kill flag has owner, authority, default, narrowing relation and model semantics | flag catalogue lint | every flag complete; unknown fails closed |
| FF-12 | Observability fields/metric labels come from finite allowlists | schema/analyzer/exporter tests | zero dynamic sensitive fields; measured cardinality within budget |
| FF-13 | Stable errors use finite taxonomy, not exception text | contract/analyzer tests | zero raw exception/path/payload in boundary result |
| FF-14 | Failure capsule is complete and content-addressed | local schema/hash validator | all mandatory files/digests present; missing/corrupt capsule rejected |
| FF-15 | Cleanup is modeled and evidenced | before/after manifest diff | zero unexplained process/job/service/task/rule/cert/file/db/verifier delta |
| FF-16 | Old/new compatibility matrix is executable | consumer/producer matrix | unsupported combinations reject/quarantine without coercion |
| FF-17 | Evidence/admin viewer critical paths are accessible | automated scan + manual keyboard/screen-reader exercise | no blocker for claimed WCAG 2.2 AA-relevant controls |

### 9.3 Dynamic model and fault coverage

Coverage is reported as a tuple, not a single percentage:

```text
Coverage = (
  invariant_status,
  command_kinds_invoked,
  event_kinds_observed,
  legal_transitions_observed,
  forbidden_transitions_witnessed,
  actor_counts,
  realm_relationships,
  hook_occurrences,
  fault_classes,
  pre_commit_boundaries,
  post_commit_boundaries,
  error_taxonomy_classes,
  compatibility_pairs,
  checker_mutants_killed,
  implementation_mutants_killed,
  real_boundary_companions,
  cleanup_receipts
)
```

Required release properties:

- every load-bearing invariant is `PASS` for its required lanes or `BLOCKED` by an explicit human/lab gate; `BLOCKED` is not release approval;
- every command and event in the active model has at least one constructive witness;
- every forbidden state transition has at least one negative witness;
- every load-bearing hook is reached in no-fault and scheduled-fault campaigns;
- both single-failure and sticky-failure SQLite I/O modes cover the admitted operation range until a no-injection completion point;
- every stable error class is observed and mapped;
- every old/new compatibility pair promised by the release is executed;
- every critical deliberate mutant is killed;
- every real-boundary campaign has a cleanup receipt.

### 9.4 Coverage limits

**RECOMMENDATION.** Line, branch, method and mutation percentages are supporting diagnostics. They MUST NOT be the sole or decisive release gate because they do not establish:

- correct expected behavior;
- state-sequence completeness;
- OS/native/database semantics;
- crash transaction boundaries;
- security or privacy boundary absence;
- correctness of the test oracle;
- compatibility or restore readiness;
- absence of rare high-cardinality or cleanup failures.

A module MAY have a human-approved line/branch hygiene floor after baselining, but the primary gate remains named invariant falsification and critical mutant detection. Generated code, defensive impossible branches and platform-specific branches are reported separately rather than hidden by broad exclusions.

### 9.5 Mutation policy

1. Maintain a small, hand-authored **critical mutant set** tied to every invariant family. Zero survivors are allowed.
2. Run Stryker first on pure contracts, policy lattice, identity, state transition, checker and idempotency modules.
3. Do not run Stryker on Windows interop/CsWin32-generated paths until the exact current version proves compatible with generated symbols; use hand mutants and integration faults meanwhile.
4. Equivalent or irrelevant mutants are documented individually or by narrow reviewed pattern; no directory-wide suppressions.
5. A mutation score trend is useful for regression detection but is not a risk percentage.
6. Checker mutations are as important as production pure-logic mutations.

### 9.6 Flaky-test policy

| Situation | Required treatment |
|---|---|
| deterministic seed fails once | product or harness failure until classified; retain capsule; no automatic green retry |
| infrastructure cannot start before product test begins | one bounded infrastructure retry may occur, linked to original attempt; no product assertions are discarded |
| real lab schedule is nondeterministic | preserve event/environment history; rerun only to classify; first product failure remains blocking |
| load-bearing invariant test flakes | cannot be quarantined for release; fix, restrict support scope, or perform explicit owned manual exercise under HUMAN DECISION |
| non-load-bearing test flakes | may be quarantined only with owner, issue, expiry, substitute coverage and visible release note; expiry failure blocks merge/release according to policy |
| same seed changes invariant classification after checker update | mandatory review against pinned historical capsules; cannot silently rewrite history |
| cleanup flakes | environment quarantined; run does not pass |

**Primary release rule:** `FlakyUnclassified` count is zero for load-bearing tests. Repeated passing runs do not erase the first failure.

### 9.7 CI/lab/pilot test pyramid

| Level | Lane | Typical cadence | Inputs | Fault realism | Authority/secrets | What it can prove | What it cannot prove |
|---|---|---|---|---|---|---|---|
| L0 | static architecture/schema/invariant mapping | every PR | source + T1 contracts | none | untrusted/no secrets | forbidden dependencies/APIs, closed contracts, registry completeness | runtime behavior |
| L1 | pure examples/properties/model/state machines | every PR | T1 seed/corpus | logical deterministic | untrusted/no secrets | laws, state transitions, idempotency semantics, minimal histories | OS/native/database semantics |
| L2 | component adapters/test-only hooks/native SQLite temp stores/hostile HTTP | PR or protected merge | T1 | exact application boundary | trusted isolated lane, no production secrets | pre/post transaction logic, parser/resource limits, deterministic retries | actual VM/session/DB restore breadth |
| L3 | disposable relational engines, real subprocess kills, proxy resets, bounded volumes | nightly/protected merge | T1 | process/network/database real | trusted disposable runner | ordinary engine transaction/restart/locking/idempotency | Windows session/security and physical hardware |
| L4 | disposable/reverted Windows VM, AppVerifier, MSI, service/task, VM reset, actual restore | weekly/release candidate | T1 | OS/process/installer/database restore real | isolated lab authority; test keys only | claimed Windows environment, update rollback, real restore, cleanup | production estate breadth or operator competence |
| L5 | synthetic scale/soak and authorized pilot shadow/operational exercise | release/pilot cadence | T1 synthetic; no real activity unless separately approved | long-duration/operational | designated controlled environment | measured resource, backlog, ring and support behavior | universal production guarantees |

No untrusted pull-request lane receives Docker daemon access, Windows lab credentials, signing authority, internal network access, persistent runner state or destructive tools.

### 9.8 Release gates by invariant family

| Gate | Required lanes | Blocking failures |
|---|---|---|
| G10-HARNESS | L0–L2 P10-12 | surviving critical mutant, incomplete capsule, non-replayable deterministic failure, production hook path, scanner/cleanup self-test miss |
| G10-SESSION | L1–L4 P10-01 | unauthorized accepted message, stale session authority, prohibited privilege/profile access, uncontrolled Task Host, residue |
| G10-PRIVACY | L0–L4 P10-02/P10-10 | broadening, wrong-realm policy, stale authority, forbidden sink value, scanner miss, unbounded sensitive observability |
| G10-SQLITE | L1–L4 P10-03 | cursor ahead, partial page, duplicate effect, unstable event ID, corruption accepted, ACK before commit |
| G10-CUSTODY | L1–L3 P10-04 | receipt without custody, unstable receipt, duplicate business effect, state conflation |
| G10-RELEASE | L1–L4 P10-05 | unauthorized/incomplete/downgraded execution, mixed privileged boundary, failed rollback/cleanup |
| G10-REALM-AUDIT | L1–L3 P10-06 | cross-realm read/mutation/delete, mutation/audit split, duplicate admin effect |
| G10-DELETION-RESTORE | L1–L4 P10-07/P10-11 | deleted visibility, acknowledged loss at readiness, early visibility, failed actual integrity/cleanup |
| G10-PRESSURE | L1–L5 P10-09 | silent unacknowledged drop, unbounded resource, unrecoverable drain |
| G10-OPS | L0–L5 P10-10/runbooks | misleading state, inaccessible critical control, unsupported raw-data support path, unowned/stale runbook |

### 9.9 Measurable acceptance criteria

The following are normative even while exact campaign counts/durations remain replaceable:

- **Zero tolerance:** privacy escape, unauthorized session/realm effect, cursor ahead, receipt without custody, duplicate final effect, mutation without success audit, unauthorized/mixed release execution, deleted data visible after readiness, acknowledged in-scope loss at readiness, silent unacknowledged drop, production callable hook, cleanup residue.
- **Deterministic replay:** every L1/L2 failure reproduces from the stored capsule or is classified `HarnessFault` with retained first evidence.
- **Failure localization:** every persistence/authority boundary has before/after evidence and a named hook.
- **Independent sensitivity:** every invariant family has at least one deliberate defect detected by a non-production checker.
- **Realism:** every load-bearing boundary has at least one non-mock fault in L3/L4 or an explicitly owned manual exercise.
- **Boundedness:** generated inputs, schedules, virtual time, wall-clock timeout, disk, memory, processes, handles, retries, network delay and evidence size have hard test-run bounds.
- **Honest scope:** pass records exact OS/runtime/native/database/build/environment and does not generalize to untested variants.
- **Privacy:** all shareable evidence is T1/sanitized and passes exact all-sink canaries.
- **Operations:** every destructive lane produces a cleanup receipt and exercised runbook.

### 9.10 Architecture-review questions

Before accepting a component change, reviewers ask:

1. Which invariant IDs can this change violate?
2. Which model state/command/event changes?
3. What is the smallest hostile sequence?
4. Where is the exact commit/authority boundary and hook?
5. Which real failure proves the dependency/OS/database behavior?
6. How are time, randomness and concurrency controlled?
7. What can appear in evidence, logs and metrics?
8. Which realm/session/source identity is authoritative?
9. What happens after ambiguous commit or lost response?
10. What cleanup and rollback evidence is required?
11. Which existing capsules must still replay?
12. Which human decision or support scope remains unresolved?

---

## 10. Human decisions and owner questions

Role names identify accountable functions, not assigned people. Until a decision is recorded, the conservative default applies.

### 10.1 Decisions this research must not make

| ID | HUMAN DECISION | Options and consequences | Conservative temporary default | Accountable role/function | Blocked work |
|---|---|---|---|---|---|
| HD-10-01 | Risk acceptance for residuals that cannot be fully automated or proved | **A:** accept named residual for a defined scope/ring with monitoring and manual exercise; fastest but carries explicit exposure. **B:** restrict supported scope until the residual can be tested; reduces coverage but preserves assurance. **C:** redesign the boundary; higher cost/migration but may remove exposure. | **STOP or restrict support scope.** No silent acceptance in code, test exception, or runbook. | Designated Production Risk Authority with Security/Privacy/Operations consultation | release/pilot for affected invariant/environment |
| HD-10-02 | Required evidence depth and release-blocking policy | **A:** zero primary failures plus required lane matrix; strongest and costliest. **B:** risk-tiered lane depth with explicit manual substitutes; lower cost but more governance. **C:** advisory-only tests; unacceptable for load-bearing invariants. | Zero primary invariant failures; every load-bearing invariant has automated falsifier plus real companion or owned manual exercise; zero unclassified load-bearing flakes. | Architecture Governance and Release/Risk Authority | release gate configuration and exception process |
| HD-10-03 | Lab and physical-hardware availability | **A:** disposable VMs only; reproducible but limited hardware/EDR fidelity. **B:** VMs plus representative physical devices; better fidelity, higher cost and cleanup burden. **C:** broad estate lab; strongest scope, highest operations cost. | No production support claim beyond exact approved disposable environment; physical-hardware-specific claims remain `UNKNOWN/BLOCKED`. | Endpoint Platform/Product Support with Lab Operations | G1, release/update, sleep/power, EDR, hardware/storage claims |

### 10.2 Additional human decisions

| ID | Decision | Conservative state until decided | Accountable function | Consequence of delay |
|---|---|---|---|---|
| HD-10-04 | exact supported Windows/VDI/session/EDR/storage matrix | only named disposable lab environment | Endpoint Platform/Product Support/Security | no wider Windows claim |
| HD-10-05 | exact production engine and HA/failover topology | PostgreSQL reference and SQL Server candidate remain test targets only | Architecture/Operations/Procurement | production DB implementation/operations blocked |
| HD-10-06 | SLO, RPO, RTO, backlog and long-outage objectives | no production acceptance threshold; zero primary data-loss invariants still apply | Product/SRE/Operations | capacity, restore and pressure gates incomplete |
| HD-10-07 | campaign budgets, cadence and runner spend | short deterministic gates; longer campaigns do not authorize release until agreed | Engineering Leadership/Release/Finance | nightly/release/pilot depth uncertain |
| HD-10-08 | production retention, deletion scope, legal hold and backup expiry | T1 only; abstract tombstones; no production deletion semantics | Data Controller/Records/Privacy/Legal | deletion/restore production contract blocked |
| HD-10-09 | audit storage technology and audit-access policy | same relational transaction in initial modular monolith; no external audit-store decision | Security/Data Governance/Architecture | external audit integration blocked |
| HD-10-10 | signing/KMS/HSM/key rotation/revocation/recovery authority | test keys only; no production signing | Signing/Cryptographic Authority | production release/control artifact gates blocked |
| HD-10-11 | optional autonomous updater need | absent/disabled; MSI/enterprise deployment only | Endpoint Product/Platform/Security/Operations | updater implementation and tests blocked |
| HD-10-12 | metric-series, evidence-size and diagnostic-retention budgets | finite allowlists and smallest T1 evidence; exact limits provisional | SRE/Privacy/Data Governance | observability production configuration blocked |
| HD-10-13 | acceptable non-load-bearing test quarantine policy | owner + issue + expiry + substitute coverage; no load-bearing quarantine | Test/Release Governance | CI stability policy incomplete |
| HD-10-14 | open-source dependency/license policy and support need | no candidate admitted without exact record and Legal/Security approval | Legal/Procurement/Dependency Security | FsCheck/Stryker/Testcontainers/Toxiproxy adoption pending |
| HD-10-15 | pilot scope and whether controlled fault exercises may run there | no production/pilot fault injection; synthetic lab only | Production Risk/Product/Operations | pilot resilience evidence limited to passive/shadow behavior |
| HD-10-16 | support staffing, on-call, incident command and runbook cadence | capability remains disabled if no assigned support/incident owner | Engineering Leadership/Operations/Security/Privacy | pilot/production blocked |
| HD-10-17 | accessible evidence/control UI scope and conformance target | CLI/markdown evidence remains primary; any UI must pass claimed WCAG 2.2 AA-relevant controls before use | Product/Accessibility/Support | web evidence/control UI release blocked |

### 10.3 Owner questions

1. Which exact invariants are non-waivable for every ring, and which residuals may only restrict support scope?
2. Which L3/L4 environments are required before a release can claim support, including physical storage, sleep/resume, EDR and multi-session technology?
3. What is the minimum recurring restore cadence for each database engine and backup type?
4. What acknowledged set and replay source define restore preservation under the eventual RPO/RTO?
5. Who owns deletion tombstone semantics across inbox, facts, aggregates, cache, backups and integrations?
6. Which administrative actions are privileged and must share an atomic success-audit outcome?
7. Which test tools/packages are approved under license, provenance and support policy?
8. What runner authority, network isolation, cache destruction and evidence retention are acceptable for destructive lanes?
9. Which exact metric dimensions and evidence fields are operationally necessary and privacy-approved?
10. What campaign duration/case count gives acceptable defect yield within budget, and who may change it?
11. What is the escalation when a load-bearing real-boundary test is blocked by unavailable hardware or an unsupported environment?
12. May any controlled fault be exercised in pilot, and what blast-radius, authorization and rollback controls would be mandatory?
13. Who independently reviews invariant/checker changes to reduce common-mode error?
14. Which failure capsules and compatibility versions must remain replayable, and for how long?
15. What evidence is required to re-enable a source, release ring, worker or restored system after a primary invariant breach?

---

## 11. CLI experiments/measurements and the exact evidence they must produce

### 11.1 Proposed CLI surface

**RECOMMENDATION.** Implement one repository tool, `Uam.Verify`, with closed subcommands. The following commands are normative interface proposals; they become executable evidence only after implementation and review.

```powershell
# Validate registry/contracts without running product code.
dotnet run --project src/tools/Uam.Verify/Uam.Verify.csproj -- `
  registry validate `
  --invariants eng/verification/invariants.yaml `
  --hooks eng/verification/hooks.yaml `
  --output artifacts/verification/registry

# Run a deterministic model campaign.
dotnet run --project src/tools/Uam.Verify/Uam.Verify.csproj -- `
  model run `
  --model M3 `
  --seed <64-HEX-CHAR-T1-SEED> `
  --campaign endpoint-page-crash-v1 `
  --max-operations <BOUNDED-COUNT> `
  --output artifacts/verification/runs/<RUN-ID>

# Replay an immutable failure capsule.
dotnet run --project src/tools/Uam.Verify/Uam.Verify.csproj -- `
  replay `
  --capsule artifacts/verification/failures/<CAPSULE-DIGEST> `
  --verify-hashes `
  --output artifacts/verification/replay/<RUN-ID>

# Shrink while preserving the same invariant violation.
dotnet run --project src/tools/Uam.Verify/Uam.Verify.csproj -- `
  shrink `
  --capsule artifacts/verification/failures/<CAPSULE-DIGEST> `
  --invariant INV-05 `
  --strategy causal-v1 `
  --output artifacts/verification/shrunk/<RUN-ID>

# Run a named component or real-boundary campaign.
dotnet run --project src/tools/Uam.Verify/Uam.Verify.csproj -- `
  campaign run `
  --id P10-03 `
  --environment <APPROVED-ENVIRONMENT-CLASS> `
  --test-artifact-manifest <DIGEST-BOUND-MANIFEST> `
  --seed <64-HEX-CHAR-T1-SEED> `
  --output artifacts/verification/campaigns/<RUN-ID>

# Validate evidence and cleanup before accepting a result.
dotnet run --project src/tools/Uam.Verify/Uam.Verify.csproj -- `
  evidence validate `
  --capsule artifacts/verification/campaigns/<RUN-ID> `
  --require-canary-scan `
  --require-cleanup-receipt `
  --require-first-failure-link
```

PowerShell lab scripts run **inside an approved disposable Windows environment** or through an external wrapper that strips all connection metadata. They never embed or print an SSH command, host, user, address, port, key, identity path or credential.

```powershell
pwsh -NoProfile -File .\eng\verification\windows\Get-UamLabInventory.ps1 `
  -OutputDirectory <SAFE-T1-EVIDENCE-DIRECTORY>

pwsh -NoProfile -File .\eng\verification\windows\Invoke-UamWindowsCampaign.ps1 `
  -CampaignId P10-01 `
  -ArtifactManifest <DIGEST-BOUND-TEST-MANIFEST> `
  -Seed <64-HEX-CHAR-T1-SEED> `
  -OutputDirectory <SAFE-T1-EVIDENCE-DIRECTORY>

pwsh -NoProfile -File .\eng\verification\windows\Test-UamLabCleanup.ps1 `
  -BaselineManifest <BEFORE-MANIFEST> `
  -OutputDirectory <SAFE-T1-EVIDENCE-DIRECTORY>
```

Application Verifier is invoked by the reviewed wrapper. The underlying official pattern is targeted to each test executable, runs both with and without fault injection, and removes settings afterwards, for example `appverif /verify <TEST-EXE> /faults` and `appverif /n <TEST-EXE>` [W10–W12]. Destructive NotMyFault or VM-reset actions are exposed only through an approved scenario ID; raw tool flags are not accepted from a scenario file.

### 11.2 Reproducible evidence format and envelope

```json
{
  "schemaVersion": "1.0.0",
  "runId": "019d0000-0000-7000-8000-00000000e001",
  "experimentId": "E10-12",
  "prototypeId": "P10-03",
  "claim": "Cursor and effects are atomic across every named endpoint transaction boundary.",
  "classification": "T1",
  "result": "PASS",
  "firstAttemptRunId": "019d0000-0000-7000-8000-00000000e001",
  "rerunOf": null,
  "startedAtUtc": "2026-07-31T12:00:00Z",
  "endedAtUtc": "2026-07-31T12:10:00Z",
  "rootSeedSha256": "sha-256:fictional-seed-digest",
  "sourceTreeSha256": "sha-256:source-tree",
  "testArtifactManifestSha256": "sha-256:test-artifact",
  "productionArtifactManifestSha256": null,
  "contracts": [
    {"id":"uam.edge.minimized-page","version":"1.0.0","sha256":"sha-256:contract"}
  ],
  "environment": {
    "classId": "windows-vm-class-fictional",
    "osBuildClass": "sanitized-exact-class",
    "architecture": "x64",
    "dotnetSdk": "execution-time-exact",
    "dotnetRuntime": "execution-time-exact",
    "sqliteBinarySha256": "sha-256:native-binary",
    "sqliteSourceId": "execution-time-exact",
    "databaseEngine": null,
    "runnerImageDigest": "sha-256:runner"
  },
  "schedule": {
    "id":"endpoint-page-crash-v1",
    "sha256":"sha-256:schedule",
    "faults":[{"hookId":"endpoint.page.after_commit_before_ack","occurrence":1}]
  },
  "assertions": [
    {"invariantId":"INV-05","result":"PASS"},
    {"invariantId":"INV-06","result":"PASS"},
    {"invariantId":"INV-07","result":"PASS"}
  ],
  "artifacts": [
    {"path":"minimal-history.ndjson","sha256":"sha-256:history","classification":"T1"}
  ],
  "canaryScan": {
    "scannerSha256":"sha-256:scanner",
    "positiveControlsPassed":true,
    "escapes":0
  },
  "cleanup": {
    "result":"PASS",
    "receiptSha256":"sha-256:cleanup"
  },
  "ownerFunction":"Endpoint Storage Verification",
  "reviewerFunction":"Independent Verification Review",
  "exceptions": []
}
```

The envelope contains exact versions and digests captured at execution time. A current patch is evidence, not an architectural constant.

### 11.3 Ordered CLI experiments

| ID | CLI EXPERIMENT and command outline | Exact evidence | Pass | Stop/fail |
|---|---|---|---|---|
| E10-00 | input/evidence boundary: hash the six allowlisted inputs and this result | names, sizes, SHA-256, review date, no extra Project input | exact allowlist; no substitution | missing/changed/unallowlisted input without restart |
| E10-01 | toolchain and dependency inventory: `dotnet --info`; locked restore; native SQLite source ID; database image/build; tool hashes/licenses | sanitized toolchain JSON, lock/source map, loaded binary hashes/source IDs, license records | all exact, supported and admitted | floating/unmapped package/native/image/tool |
| E10-02 | runner/lab trust preflight: architecture/credential/network/cache/privilege inventory | no-secret report, egress policy, disposable marker, runner/VM digest, destruction procedure | no production secrets/network; exact authority; disposable/revertible | credential/connection detail in evidence; persistent/untrusted runner authority |
| E10-03 | `registry validate` | invariant/hook/owner/runbook graph and schema result | every load-bearing invariant has automated path or owned manual exercise; no orphan hook | missing owner/falsifier/companion/runbook |
| E10-04 | checker hand histories and oracle independence | positive/negative histories per invariant; project graph; expected violation explanations | all hand cases classified; no production decision-code reference | common production reference, wrong hand classification |
| E10-05 | generated model campaigns M1–M8 | root seeds, command/event/transition/fault coverage tuple, first failure capsules | all active commands/events reachable; forbidden transitions witnessed | unreachable load-bearing transition or unbounded campaign |
| E10-06 | replay and shrink | original/minimal histories, shrink chain, replay transcript and hashes | same invariant/essential cause; deterministic replay | failure disappears, changes to harness fault, or capsule incomplete |
| E10-07 | mutation sensitivity | critical mutant map; Stryker/manual results; surviving mutants and reasons | zero critical survivors; reviewed narrow exclusions | any critical survivor or broad suppression |
| E10-08 | virtual clock and scheduler | clock streams, barriers, quiescence states, no-sleep analyzer report | expiry/leases/retries reproducible; no governed ambient time/sleep/random | timing-dependent expected result or hidden ambient clock |
| E10-09 | history/evidence hostile parser | duplicate/unknown/truncated/reordered/oversized/hash-mismatch capsules and schedules | every invalid artifact rejected with finite code and bounded resource | permissive parse, remote ref, partial evidence accepted |
| E10-10 | P10-01 component lane | generated IPC/lifecycle histories, parser resources, test hook behavior | M1 invariants and bounds pass | unauthorized frame or unbounded resource |
| E10-11 | P10-01 Windows real lane | sanitized token/session/process/pipe/verifier evidence and cleanup | exact environment passes; zero unauthorized frames/residue | any primary G1 failure; unavailable environment is BLOCKED |
| E10-12 | P10-03 deterministic SQLite hook sweep | one result per hook/occurrence; DB/WAL/SHM snapshots; stable identity ledger | full pre/post truth and ACK replay | cursor ahead, partial page, duplicate/changed ID |
| E10-13 | P10-03 real SQLite I/O/process/VM lane | VFS nth/sticky operation map, process/VM kill evidence, integrity and file trace | logical ledger and integrity pass; no source write | corruption/unknown state/source mutation/cleanup failure |
| E10-14 | P10-04 PostgreSQL reference custody lane | exact 18.x test/release builds, hook/injection/isolation and black-box histories, receipt/fact snapshots | receipt custody and one-effect invariants pass in both test and ordinary build | internal test build passes but ordinary build semantic lane fails |
| E10-15 | P10-04/06/07/08 SQL Server candidate parity | exact 17.x build, black-box transaction/session/process faults, actual restore and `DBCC CHECKDB` | same UAM semantic outcomes; actual restore valid | semantic divergence, `VERIFYONLY` substituted for restore, unmapped fault |
| E10-16 | P10-05 release/rollback | artifact/service/task/process manifests at each fault; health/rollback history; production hook scan | invalid never executes; old/new complete; cleanup | mixed/unauthorized execution or residue |
| E10-17 | P10-06 realm/audit | auth-vs-payload history, SQL/cache probes, mutation/audit snapshots, response-loss retry | zero cross-realm; mutation⇔audit; idempotent command | any cross-realm or audit split |
| E10-18 | P10-07 deletion/restore | backups, actual hidden restore, integrity, receipt/tombstone/readiness/audit reconciliation | no resurrection/loss/early visibility | deleted visible, acknowledged missing at ready, no actual restore |
| E10-19 | P10-08/09 pressure, lease and outage | lease/fence, identity-set reconciliation, resource/backpressure curves, drain history | no stale commit/silent drop; bounded recovery | stale commit, missing identity, unbounded storm |
| E10-20 | flake classification drill | planted nondeterministic harness/product cases, first-attempt index, quarantine metadata | first failure retained; classes correct; load-bearing gate remains blocked | blind rerun to green, unowned/expired quarantine |
| E10-21 | manual-exercise completeness | owner, scope, script/checklist, date, evidence, result, expiry, cleanup | every necessary manual residual current and owned | missed/stale/unowned exercise; not a pass |
| E10-22 | production artifact absence and reproducibility | two clean unsigned builds, file/SBOM/provenance diff, hook activation negative probe | accepted R2/R3 rules; zero hook/controller/test authority | unexplained mismatch or callable test surface |
| E10-23 | cleanup and harness self-destruction | deliberate orphan/service/task/cert/rule/db/verifier residue; cleanup detector and VM destruction receipt | every planted residue detected; clean baseline restored | one planted residue missed or environment reused dirty |
| E10-24 | aggregate gate: `gate evaluate --batch prompt-10` | `prompt-10-gate.json` binding inputs, ADRs, owners, experiments, failures, exceptions and cleanup | primary expression true; no expired/missing evidence | any false primary term, owner gap, stale exception or digest mismatch |

### 11.4 PostgreSQL test-build experiment

**FACT.** PostgreSQL `REL_18_STABLE` exposes a Meson `injection_points` developer option and maintains multi-session isolation-test specifications/permutations [W06–W07].

Bounded test-build outline:

```bash
# Exact source commit is pinned in the experiment manifest.
meson setup build -Dinjection_points=true -Dcassert=true
ninja -C build

# UAM wrapper installs only into a disposable test prefix, creates T1 database,
# enables the exact reviewed injection-point module, runs the named scenario,
# then destroys the instance. The ordinary release-image black-box lane follows.
./eng/verification/postgres/run-uam-postgres-campaign.sh \
  --source-commit <FULL-COMMIT> \
  --scenario P10-04 \
  --seed <64-HEX-T1-SEED> \
  --output <SAFE-T1-EVIDENCE-DIR>
```

Pass requires the same UAM checker result in the source-built injection lane and the ordinary release-image black-box lane. An injection-point-only result does not prove deployable behavior.

### 11.5 SQLite nth-I/O campaign

The UAM test VFS/shim mirrors the primary pattern documented by SQLite:

```text
for mode in [FAIL_ONCE, FAIL_STICKY_AFTER_FIRST]:
  for ordinal from 1 until operation completes without injected failure:
      create fresh T1 database
      arm I/O failure at ordinal
      run exact transaction or recovery scenario
      disable injection
      reopen using ordinary admitted native path
      run integrity and UAM logical checker
      emit capsule and cleanup receipt
```

Every operation records VFS operation class, ordinal, selected file role (`main`, `wal`, `shm`, `journal`, temporary where applicable), return code, hook, transaction state and recovered logical state. Exact raw paths are not shareable evidence.

### 11.6 SQL Server actual restore experiment

The SQL file is T1 and uses placeholders resolved inside the isolated lab. The evidence sequence is:

1. create backup with approved checksum/options for the test profile;
2. optionally run `RESTORE VERIFYONLY` as a preliminary readability/completeness check;
3. restore to a new isolated database/location;
4. run `DBCC CHECKDB` on the restored database;
5. keep UAM visibility closed;
6. run custody, deletion, realm, materialization/read-model and audit readiness checkers;
7. open visibility only after all stages pass;
8. destroy the restored database and backup after evidence retention.

`RESTORE VERIFYONLY` cannot replace steps 3–6 [W14–W16].

### 11.7 Evidence handling and retention

- Failure capsules are content-addressed and immutable.
- First failures, subsequent attempts and shrink results are linked, never overwritten.
- T1 canonical histories may be committed when small and reviewed. Large lab capsules live in the approved evidence store with manifest/digests in the repository.
- Restricted raw traces/dumps are not attached to research. Sanitized derived evidence requires an explicit lineage record and canary scan.
- Evidence retention/deletion for production-shaped or measured T3 data is a HUMAN DECISION. Prompt 10 uses T1 by default.
- Cleanup failure invalidates the run, even when product assertions passed.

---

## 12. ADR proposals

| ADR | Decision | Status | Alternatives | Rationale/evidence | Owner function | Review trigger |
|---|---|---|---|---|---|---|
| ADR-P10-001 | Adopt one layered verification architecture: UAM model/checker, deterministic property campaigns, test-only hooks, and real-boundary faults | **Proposed — accept** | unit/mock only; general chaos platform | only combination that closes semantic and real-runtime evidence gaps | Verification Architecture | primary invariant escape or topology change |
| ADR-P10-002 | UAM owns invariant registry, models, command/event/fault alphabets, history checker and failure-capsule schema | **Proposed — accept** | library-owned state-machine semantics | keeps UAM meaning stable and independently reviewable | Architecture/Data Reliability | model contract or invariant change |
| ADR-P10-003 | Use 256-bit root seed, domain-separated streams, recorded library replay data and causal shrink policy | **Proposed — accept** | ambient/random seeds; framework seed only | reproducible cross-tool generation and minimal histories | Verification Tooling | seed/collision/replay defect |
| ADR-P10-004 | Inject `TimeProvider` through UAM clock interfaces; distinguish wall, monotonic, confidence and scheduler time | **Proposed — accept** | wall clock/sleeps; one clock concept | expiry, lease and timeout semantics differ; deterministic tests require explicit time | Runtime Architecture | clock/offline policy or runtime change |
| ADR-P10-005 | Fault hooks are finite, semantic, internal/test-only and structurally absent from production | **Proposed — accept** | runtime diagnostic hooks; source-line breakpoints only | precise boundaries without shipping a control vulnerability | Product/Release Security | new persistence/authority boundary or artifact incident |
| ADR-P10-006 | Every load-bearing deterministic hook requires a real process/file/network/database/VM companion or owned manual exercise | **Proposed — accept** | mocks/hooks alone | prevents mocked-away failure proof | Reliability Architecture | new platform or inability to automate safely |
| ADR-P10-007 | FsCheck stable generator/property APIs are the first property-test dependency; UAM state runner remains authoritative | **Proposed — dependency-gated** | Hedgehog; CsCheck; custom generator only | current C# fit and prior review; minimizes library coupling | Verification Tooling/Dependency Security | maintenance/security/license/provenance change or shrinking failure |
| ADR-P10-008 | Use critical hand mutants plus Stryker.NET initially on pure modules | **Proposed — dependency-gated** | coverage only; mutation everywhere | checks assertion sensitivity while avoiding known Windows source-generator risk | Test Governance | Stryker compatibility/advisory change |
| ADR-P10-009 | SQLite durability uses deterministic test VFS/shim patterns plus ordinary-native hard process/VM recovery; no `sqlite3_test_control` product dependency | **Proposed — accept** | in-memory mocks; internal SQLite API dependency | matches SQLite's mature test method and preserves deployable-path evidence | Endpoint Storage | provider/native/VFS/schema/transaction change |
| ADR-P10-010 | Server fault lane uses Testcontainers/Toxiproxy candidates, hostile HTTP server, engine-specific DB faults and actual restore | **Proposed — dependency-gated** | one in-memory DB; proxy only | tests custody ambiguity, database transactions and restore without a broker/chaos platform | Server Reliability | engine/HA/network topology change |
| ADR-P10-011 | Flaky load-bearing tests cannot be rerun or quarantined into a release pass; first failure remains evidence | **Proposed — accept** | retry-to-green; broad quarantine | protects rare concurrency/durability findings | Test/Release Governance | measured infrastructure policy change |
| ADR-P10-012 | Coverage is an invariant/transition/hook/fault/mutant/real-companion tuple; line percentage is supporting only | **Proposed — accept** | line/branch gate | named semantic evidence is more trustworthy | Architecture Governance | evidence shows missing useful signal |
| ADR-P10-013 | Failure capsules are immutable, content-addressed, T1 by default, replayable and include cleanup receipt | **Proposed — accept** | console log only; mutable test dashboard | reproducibility, privacy and incident evidence | Verification Evidence | evidence-store/retention change |
| ADR-P10-014 | Production promotion requires a negative proof that no hook/controller/schedule/destructive tool shipped | **Proposed — accept** | rely on build configuration convention | build mistakes are foreseeable and high impact | Release Security | build/linker/packaging change |
| ADR-P10-015 | Model deletion/restore as hidden until integrity, custody, tombstone, realm, read-model and audit readiness | **Proposed — accept logical model; semantics human-blocked** | database-started equals ready | directly protects accepted restore/deletion invariants | Restore/Data Governance | approved deletion/RPO/RTO/storage design |
| ADR-P10-016 | Observability/evidence use finite allowlists, measured cardinality and WCAG 2.2-relevant accessible status/control behavior | **Proposed — accept** | dynamic labels/raw exceptions; inaccessible dashboard | contains privacy/resource risk and review error | Privacy/SRE/Accessibility | telemetry backend or UI change |
| ADR-P10-017 | Coyote, Jepsen, FoundationDB simulation and TigerBeetle VOPR remain reference/spike inputs; SharpFuzz remains no-go pending provenance | **Proposed — accept classifications** | immediate adoption | maintenance, language, topology and provenance fit differ | Dependency Security/Architecture | exact new release/evidence or topology change |
| ADR-P10-018 | Manual residual exercises are first-class registry entries with owner, cadence, evidence, stop rule and expiry | **Proposed — accept** | undocumented runbook/manual sign-off | primary gate requires an accountable path for unautomatable residuals | Architecture/Operations Governance | automation becomes safe or residual changes |

Every ADR record MUST include the exact sources, versions/commits, smallest falsifying experiment, rollback/removal plan, security/privacy/realm impact, compatibility and human decisions. No tool ADR becomes `Accepted` until dependency, license, provenance and execution-time compatibility gates pass.

---

## 13. Ordered implementation backlog with dependencies and stop gates

### 13.1 Critical path and ordered harness backlog

| Order | Backlog item | Dependencies | Deliverable | Stop gate |
|---:|---|---|---|---|
| 1 | create Prompt 10 input/evidence manifest | none | six-file hash record and source register skeleton | extra/missing Project input |
| 2 | assign owner functions and open human-decision records | 1 | owner/escalation/expiry registry | any safety-critical item `UNASSIGNED` before candidate gate |
| 3 | create ADR-P10-001 through ADR-P10-018 | 1–2 | proposed ADR files with change triggers | silent conflict with predecessor |
| 4 | scaffold verification contracts/model/checker/generator/scheduler/evidence/tool projects | Batch 01 repository rules | buildable empty boundaries and architecture tests | production reference into model/checker or reverse test dependency |
| 5 | define `invariants.yaml`, command/event/fault catalogues and local schemas | 3–4 | registry v1 with INV-01–INV-28 | load-bearing invariant lacks owner/falsifier |
| 6 | implement evidence envelope, history and failure-capsule validator first | 4–5 | content-addressed capsule CLI and corrupt-input tests | missing/changed file can be accepted |
| 7 | implement root seed/domain stream and deterministic UUID/time/value generators | 4–6 | cross-platform test vectors | nondeterminism, modulo bias or ambient source |
| 8 | implement UAM clock wrapper and no-ambient-time/random analyzers | 4–7 | virtual wall/monotonic/confidence/scheduler clocks | governed direct time/sleep/random use survives |
| 9 | implement generic immutable model runner and causal operation history | 5–8 | enabled-command runner and checker interface | model calls OS/DB/production code |
| 10 | implement causal shrinker/delta-debug fallback and replay | 6–9 | original/minimal histories and shrink chain | same invariant cannot replay on planted case |
| 11 | implement checker self-test corpus and critical mutants | 5–10 | hand histories and invariant-mutant map | one primary planted defect survives |
| 12 | admit one property framework, initially FsCheck candidate | dependency gate, 7–11 | adapter isolated behind UAM interfaces | provenance/license/security/compatibility failure |
| 13 | implement M2 privacy/policy model and P10-02 pure lane | 5–12 | lattice laws, artifacts, clock and canary histories | broadening or scanner self-test miss |
| 14 | implement M3 source/page/SQLite model and schema simulator | 5–12, Batch 02 contracts | page/natural key/checkpoint histories | model permits partial page/cursor ahead |
| 15 | define semantic hook catalogue and test-only controller protocol | 5–14 | closed hooks/schedule schemas and no-op production interface | arbitrary command/path/SQL or production route appears |
| 16 | place endpoint page hooks and implement component fail sweep | 14–15 | E10-12 hook evidence on T1 SQLite | any primary SQLite invariant fails |
| 17 | implement admitted SQLite test VFS/shim and native inventory | dependency/native gate, 16 | nth/sticky I/O lane and source ID evidence | native/provenance mapping or recovery unknown |
| 18 | implement M4/M8 custody/materialization/lease/pressure models | 5–12 | pure server histories/checkers | receipt/effect/fence invariant fails |
| 19 | place ingestion/worker hooks and hostile HTTP server | 15, 18 | deterministic ambiguous-commit lane | premature receipt/double effect |
| 20 | admit Testcontainers/Toxiproxy candidates and exact image policy | dependency/runner gate, 19 | disposable PostgreSQL lane | Docker authority or mutable image not contained |
| 21 | implement PostgreSQL source-built injection/isolation reference lane plus ordinary image lane | 20 | E10-14 evidence | test-build result lacks ordinary-image companion |
| 22 | implement M6 realm/admin/audit model and hooks | 5–12, 18–19 | P10-06 pure/component lane | cross-realm/audit split |
| 23 | implement M5 release/update model and fictional artifact generator | 5–12 | M5 histories and release mutants | unauthorized/mixed state allowed by model |
| 24 | prepare placeholder-only Windows lab inventory/campaign/cleanup scripts | 6, 13–17, 23 | disconnected reviewed scripts | connection detail/credential/real identity or mutating preflight |
| 25 | obtain approved Windows support/lab scope and exact predecessor G1 evidence | HUMAN DECISION | named environment and authority | no live/destructive Windows campaign without it |
| 26 | run read-only Windows inventory and bind exact test artifact | 24–25 | sanitized environment manifest | environment mismatch/unsupported treated as pass |
| 27 | run P10-01 session/IPC real lane | 26 | G10-SESSION evidence/cleanup | one primary session failure |
| 28 | run P10-03 native SQLite process/I/O/VM lane | 17, 26–27 | G10-SQLITE real evidence | cursor/duplicate/corruption/source-write/residue |
| 29 | run P10-05 MSI/release/rollback lane | 23, 26–27 | G10-RELEASE evidence | unauthorized/mixed execution or cleanup failure |
| 30 | implement SQL Server candidate lane after exact legal/runtime admission | 18–22, HUMAN DECISION | E10-15 parity evidence | unmapped build/license/semantic divergence |
| 31 | implement M7 deletion/restore model with abstract epochs | 5–12, 18, 22 | pure late-arrival/restore histories | early visibility or tombstone bypass in model |
| 32 | obtain deletion/RPO/RTO/backup human decisions required for production-shaped semantics | HUMAN DECISION | signed decision records; T1 can proceed abstractly | no production claim without decisions |
| 33 | run P10-07/P10-11 actual restore lanes | 21/30, 31–32 | G10-DELETION-RESTORE evidence | acknowledged loss/deleted visibility/early readiness |
| 34 | implement P10-09 bounded pressure/outage campaigns | 16–22, 28 | identity reconciliation/resource evidence | silent drop/unbounded storm |
| 35 | implement P10-10 observability/cardinality/support/accessibility campaigns | all component contracts | G10-PRIVACY/G10-OPS evidence | sink leak/dynamic label/misleading or inaccessible critical state |
| 36 | admit and run Stryker on selected pure modules | 11–14, 18, 22–23, dependency gate | mutation evidence | critical survivor or Windows interop accidentally included |
| 37 | implement flake/quarantine/first-failure index and manual-exercise registry | 5–6 | governance CLI and expiry checks | rerun can erase first failure or unowned manual gap |
| 38 | implement production hook absence/build/SBOM/provenance gate | 15, Batch 01 release controls | E10-22 | callable hook or unexplained build mismatch |
| 39 | exercise incident/support/cleanup runbooks including planted failures | 27–38 | runbook and cleanup receipts | failure continues, raw-data bypass or residue |
| 40 | execute aggregate E10-24 gate | 1–39 | immutable `prompt-10-gate.json` | any primary expression false/missing/expired |
| 41 | architecture review and Batch 03 reviewer handoff | 40 | accepted/rejected ADR/evidence package | no self-approval of production risk |
| 42 | allow later synthetic release/capacity/pilot work only for passed scope | reviewer/human authority | bounded next-gate permission | real data, production fault or unsupported claim appears |

### 13.2 Parallel work

After items 5–12, these can run in parallel:

- M2 privacy/policy model and canary work;
- M3 endpoint page/SQLite model;
- M4/M8 server custody/worker/pressure model;
- M5 release/update model;
- M6 realm/audit model;
- evidence UI/accessibility prototype;
- disconnected Windows and database lab script preparation.

Real-boundary lanes do not run early merely because their scripts exist. They require exact predecessor gates, approved environment, admitted tools/bytes, test artifacts and cleanup plan.

### 13.3 Stop/go sequence

1. **GO** for repository/model/checker/generator/evidence work using T1 data.
2. **STOP** tool adoption on missing source/package/binary/license/security evidence.
3. **GO** for deterministic component hooks only in test artifacts after hook architecture tests pass.
4. **STOP** real Windows work until exact G1/lab scope is approved and inventoried.
5. **STOP** database-engine claims until ordinary release images and actual restore companions pass.
6. **STOP** deletion/restore production semantics until human scope/RPO/RTO/retention decisions exist.
7. **STOP** every dependent gate on one primary invariant failure, one unclassified load-bearing flake, one production hook path, one scanner miss or one cleanup failure.
8. **GO** to reviewer handoff only when `prompt-10-gate.json` binds all evidence and the primary expression is true for the stated scope.

---

## 14. Open-source repository assessment table

### 14.1 Decision rule

**RECOMMENDATION.** Open-source material in this section is classified as one of four things:

1. **dependency candidate** — may be admitted only after exact package/source/binary, license, security, compatibility, reproducibility and removal-path evidence;
2. **trusted-lane tool candidate** — may execute only in an isolated test or lab lane and is never linked into a production deployable;
3. **reference only** — design and test ideas may be studied, but no package, binary, service or source copy is approved;
4. **no-go as reviewed** — a named evidence gap blocks use until it is closed.

Popularity is deliberately absent from the decision. A mature project can still be a poor UAM fit because its authority, language, deployment topology, data exposure, instrumentation method, support posture or license obligations differ. Every admitted version MUST be locked by immutable package hash or source commit, included in the final file/SBOM/provenance reconciliation, and rerun through UAM positive and negative controls. A repository upgrade is a new evidence event, not routine housekeeping.

### 14.2 Dependency and trusted-lane candidates

| Ref | Repository, exact revision and relevant paths | License and compatibility concerns | Maintenance, tests and security posture | Similarity, difference, reusable ideas and prohibited copying | Suitability |
|---|---|---|---|---|---|
| O01 | [FsCheck repository](https://github.com/fscheck/FsCheck); [release `3.3.4`](https://github.com/fscheck/FsCheck/releases/tag/3.3.4); commit [`7c583d6df4939643fd36f0439694be1456833aff`](https://github.com/fscheck/FsCheck/tree/7c583d6df4939643fd36f0439694be1456833aff). Relevant: [`src/FsCheck`](https://github.com/fscheck/FsCheck/tree/7c583d6df4939643fd36f0439694be1456833aff/src/FsCheck), [`tests`](https://github.com/fscheck/FsCheck/tree/7c583d6df4939643fd36f0439694be1456833aff/tests), [`docs`](https://github.com/fscheck/FsCheck/tree/7c583d6df4939643fd36f0439694be1456833aff/docs). Released 25 July 2026. | BSD-3-Clause. Low copyleft concern, but transitive packages and exact NuGet-to-source mapping still require the standard dependency record. Test-only use avoids runtime support obligations. | Active release immediately before this review; source includes unit/integration-style test projects and C#/F# APIs. No independent security audit is claimed. A generator executes arbitrary test code, so it runs only with T1 inputs in trusted validation. | Similarity: C#/.NET generators, shrinking, replayable seeds. Difference: it does not know UAM state legality, trust boundaries, privacy stages or durable-history semantics. Reuse stable generator/property APIs and distribution combinators. Do not make experimental model APIs, library exception text or library shrink order the UAM contract. | **DEPENDENCY CANDIDATE — TEST ONLY.** Initial preferred property generator behind `Uam.Verification.Generators`; UAM owns command enabling, model transitions, history and shrinking policy. |
| O02 | [Hedgehog .NET repository](https://github.com/hedgehogqa/fsharp-hedgehog); [tag/release `v2.0.0`](https://github.com/hedgehogqa/fsharp-hedgehog/tree/v2.0.0), released 8 December 2025; release commit recorded as `6beeb96`. Relevant: [`src`](https://github.com/hedgehogqa/fsharp-hedgehog/tree/v2.0.0/src), [`tests`](https://github.com/hedgehogqa/fsharp-hedgehog/tree/v2.0.0/tests). | Apache-2.0. Notice and transitive-license review still required. Primarily F#-shaped APIs can add team and interop cost in a C#-default repository. | Recent major release, integrated generation/shrinking design and repository tests. No claim of formal support or independent security assessment. | Similarity: deterministic generation and shrink trees. Difference: language ergonomics and a second seed/shrink vocabulary. Reuse the idea that generated choices and shrinks form inspectable trees. Do not operate two general property frameworks by default or let one library's tree serialization become evidence format. | **REFERENCE / ALTERNATIVE.** Run a bounded bake-off only if FsCheck cannot shrink valid concurrent histories without excessive custom repair. |
| O03 | [Stryker.NET repository](https://github.com/stryker-mutator/stryker-net); [release `dotnet-stryker@4.16.0`](https://github.com/stryker-mutator/stryker-net/releases/tag/dotnet-stryker%404.16.0), released 3 July 2026, release commit recorded as `f9109e2`. Relevant: [`src/Stryker.Core`](https://github.com/stryker-mutator/stryker-net/tree/dotnet-stryker%404.16.0/src/Stryker.Core), [`src/Stryker.CLI`](https://github.com/stryker-mutator/stryker-net/tree/dotnet-stryker%404.16.0/src/Stryker.CLI), repository unit/integration tests. Reviewed issue: [CsWin32 generated symbols lost during mutation compilation](https://github.com/stryker-mutator/stryker-net/issues/3698), opened 9 July 2026. | Apache-2.0. The tool compiles and executes mutated code, so it is high-authority build tooling and MUST run without secrets, signing, deployment authority or untrusted production data. Generated-source compatibility is a material execution risk. | Active 2026 releases and substantial source/test surface. The reviewed current issue is direct evidence that Windows generated interop can fail in a tool-specific way. Mutation score is not a security certificate. | Similarity: tests whether assertions actually detect semantic defects. Difference: source mutation is not fault injection and can create uncompilable or unrealistic programs. Reuse selected operator families and survivor reporting. Do not mutate every project indiscriminately, infer quality from one aggregate score, or treat equivalent-mutant classification as automatic. | **DEPENDENCY CANDIDATE — TEST TOOL.** Admit first for pure policy, identity, contract, checker and state modules. Windows interop remains hand-mutated until the exact toolchain proves generated-symbol fitness. |
| O06 | [Testcontainers for .NET repository](https://github.com/testcontainers/testcontainers-dotnet); [release `4.13.0`](https://github.com/testcontainers/testcontainers-dotnet/releases/tag/4.13.0); commit [`1717807affaae9b967035516ebedcd76dd7eaffb`](https://github.com/testcontainers/testcontainers-dotnet/tree/1717807affaae9b967035516ebedcd76dd7eaffb), released 2 July 2026. Relevant: [`src/Testcontainers`](https://github.com/testcontainers/testcontainers-dotnet/tree/1717807affaae9b967035516ebedcd76dd7eaffb/src/Testcontainers), [`tests`](https://github.com/testcontainers/testcontainers-dotnet/tree/1717807affaae9b967035516ebedcd76dd7eaffb/tests), database modules. | MIT. The library controls a Docker-compatible daemon, which is effectively high privilege on the runner. Container images have independent licenses, notices and supply chains; image tags are insufficient, and exact manifest digests are mandatory. | Current, signed release commit; project reports release-package attestations and has extensive module tests. Its security boundary is the runner/container daemon, not the test API. | Similarity: disposable PostgreSQL/SQL Server candidate environments, lifecycle and cleanup. Difference: containers do not reproduce Windows session, storage-stack, physical power-loss or enterprise database operations. Reuse lifecycle orchestration and wait/readiness patterns. Do not use a mutable image, share the daemon with untrusted code, or call container success restore proof. | **TRUSTED-LANE CANDIDATE.** Server component/integration tests only, on isolated disposable runners with exact images and post-run destruction receipts. |
| O07 | [Toxiproxy repository](https://github.com/Shopify/toxiproxy); [release `v2.12.0`](https://github.com/Shopify/toxiproxy/releases/tag/v2.12.0), released 18 March 2025, release commit recorded as `3ccd6a7`; signed tag/commit reported by the release page. Relevant: [`toxics`](https://github.com/Shopify/toxiproxy/tree/v2.12.0/toxics), [`server`](https://github.com/Shopify/toxiproxy/tree/v2.12.0/server), [`client`](https://github.com/Shopify/toxiproxy/tree/v2.12.0/client), integration tests. | MIT. Tool and client binaries need exact checksums/provenance. It accepts network-control commands and therefore belongs only on a private test network. | Mature fault proxy with tests and a maintained release history, though older than the other selected candidates. No claim that it models HTTP or application semantics. | Similarity: bounded cut, reset, latency, bandwidth and directional failure. Difference: a TCP proxy cannot know whether the server committed, whether a receipt is durable or whether an HTTP body is semantically hostile. Reuse deterministic named toxics and cleanup. Do not expose its admin endpoint, use it as the only network fault mechanism, or equate packet behavior with application correctness. | **LAB/CI TOOL CANDIDATE.** Pair with a UAM hostile HTTP server that can commit then lose the response, truncate compressed bodies and return contract-valid/invalid receipts. |
| O11 | [PostgreSQL source mirror](https://github.com/postgres/postgres), exact tag [`REL_18_4`](https://github.com/postgres/postgres/tree/REL_18_4), corresponding to PostgreSQL 18.4 released 14 May 2026. Relevant: [`src/test/modules/injection_points`](https://github.com/postgres/postgres/tree/REL_18_4/src/test/modules/injection_points), [`src/test/isolation/README`](https://github.com/postgres/postgres/blob/REL_18_4/src/test/isolation/README), [`meson_options.txt`](https://github.com/postgres/postgres/blob/REL_18_4/meson_options.txt). | PostgreSQL License. A source-built test server is not the approved production distribution and may include developer-only features. Build inputs, compiler and modules require their own provenance and cleanup record. | Official database source, mature regression/isolation suites and a current supported release line. Injection points are explicitly a developer/test facility, not ordinary production behavior. | Similarity: relational durable inbox, transactions, leases and concurrency. Difference: internal injection points bypass distribution packaging and may perturb timing. Reuse session-step permutation specs and named internal failure locations. Do not ship a test build, infer ordinary-image behavior from one internal test, or couple application design to private hooks. | **TEST-BUILD/REFERENCE CANDIDATE.** Each internal test MUST have a black-box companion against the exact ordinary release image; actual backup/restore remains separate. |
| O12 | [SQLite official source](https://sqlite.org/src/), [release history](https://www.sqlite.org/changes.html), [testing overview](https://sqlite.org/testing.html); exact reviewed engine `3.53.4`, 24 July 2026, source ID `bf7c7f30031888f4e796e429ab3978879485813aaca6f641c7b33e4e09459bcc`. Relevant concepts: VFS boundary, test scripts and documented nth/sticky I/O-failure methods. | SQLite core is public domain; separately distributed tools, extensions and test suites can have other terms. TH3 and dbsqlfuzz are proprietary and MUST NOT be copied or treated as available source. The actual managed provider and native binary remain separate admission records. | Exceptionally mature engine testing and public documentation. The reviewed release follows recent WAL-related fixes, reinforcing the requirement to record the loaded native source ID. Internal `sqlite3_test_control` is explicitly unstable/test-only. | Similarity: UAM endpoint store is SQLite WAL with one writer. Reuse the public VFS abstraction and nth/sticky failure ideas in a narrow UAM test VFS. Do not copy proprietary suites, depend on undocumented internal controls in application code, or let a simulated VFS replace process/VM/filesystem failures. | **OFFICIAL DESIGN REFERENCE + EXACT NATIVE CANDIDATE SUBJECT TO PROVIDER ADMISSION.** UAM owns its VFS/shim and pairs every load-bearing simulated fault with real-boundary evidence. |

### 14.3 No-go and bounded reference projects

| Ref | Repository, exact revision and relevant paths | License and maintenance posture | UAM fit, reusable ideas and ideas not to copy | Classification |
|---|---|---|---|---|
| O04 | [SharpFuzz repository](https://github.com/Metalnem/sharpfuzz); exact reviewed package [SharpFuzz `2.3.0`](https://www.nuget.org/packages/SharpFuzz/2.3.0), published 16 June 2026. The newest source revision that could be tied confidently in this review was [tag `v2.2.0`](https://github.com/Metalnem/sharpfuzz/releases/tag/v2.2.0), commit [`28c353b41a1ff60039bf78293dbd5edd9d7c3014`](https://github.com/Metalnem/sharpfuzz/tree/28c353b41a1ff60039bf78293dbd5edd9d7c3014). Relevant repository areas: source, test and sample fuzz harnesses. | MIT; current NuGet package exists and targets .NET Standard, but exact `2.3.0` package-to-reviewed-source mapping is **UNKNOWN**. It instruments assemblies and depends on a native fuzzing toolchain, so execution and crash-artifact controls are material. | Reuse coverage-guided corpus and minimal-crasher concepts. Do not consume package bytes that cannot be mapped to reviewed source, upload corpora, or let fuzzing replace strict deterministic invalid vectors and model histories. | **NO-GO AS REVIEWED.** Reconsider only after exact source/package mapping, locked native fuzzer, T1-only corpus, no-network execution, crash redaction and a removal path. |
| O05 | [Microsoft Coyote repository](https://github.com/microsoft/coyote); exact reviewed package [Microsoft.Coyote `1.7.11`](https://www.nuget.org/packages/Microsoft.Coyote/1.7.11), published 18 March 2024. Relevant: [`Source`](https://github.com/microsoft/coyote/tree/main/Source), [`Tests`](https://github.com/microsoft/coyote/tree/main/Tests), [`Tools`](https://github.com/microsoft/coyote/tree/main/Tools), [`Samples`](https://github.com/microsoft/coyote/tree/main/Samples). Exact package-to-source commit for `1.7.11` was not established. | MIT. Repository documentation states the project is open source and provided without formal support. It rewrites/instruments .NET concurrency and therefore adds compatibility and trust risk. Package age and exact source mapping are weaker than the preferred tools. | Reuse controlled scheduler, operation abstraction, schedule replay and liveness-monitor ideas. Do not claim instrumented task scheduling covers processes, named pipes, Windows tokens, native SQLite, HTTP stacks or database engines. Do not make unsupported rewriting a release dependency. | **REFERENCE / BOUNDED SPIKE ONLY.** A one-time T1 spike is allowed only if the UAM scheduler misses a concrete pure-managed race and exact package evidence is first closed. |
| O08 | [Jepsen repository](https://github.com/jepsen-io/jepsen); [release `v0.3.13`](https://github.com/jepsen-io/jepsen/releases/tag/v0.3.13), released 31 July 2026, commit `0aad6ff`. Relevant: [`jepsen/src/jepsen`](https://github.com/jepsen-io/jepsen/tree/v0.3.13/jepsen/src/jepsen), [`jepsen/test`](https://github.com/jepsen-io/jepsen/tree/v0.3.13/jepsen/test), [design overview](https://github.com/jepsen-io/jepsen/blob/v0.3.13/README.md), [project/license metadata](https://github.com/jepsen-io/jepsen/blob/v0.3.13/jepsen/project.clj). | Eclipse Public License 1.0 as declared by the reviewed project metadata. Current release adds final generators/reads and filesystem snapshot fixes. It requires a JVM/Clojure control environment and commonly destructive SSH/root access to nodes. | Reuse generator/client/nemesis/history/checker separation, final-read reconciliation, immutable stores and explicit indeterminate operations. Do not copy its deployment assumptions, point it at production, assume a five-node consensus threat model, or import a JVM cluster just to test a modular monolith. | **REFERENCE ONLY INITIALLY.** Reconsider as an executable framework only if UAM adds a genuinely distributed custom protocol, broker or multi-primary topology that the C# harness cannot check economically. |
| O09 | [FoundationDB repository](https://github.com/apple/foundationdb); [release `7.3.77`](https://github.com/apple/foundationdb/releases/tag/7.3.77), released 16 April 2026, commit `3ea44ce`. Relevant: [`fdbrpc/sim2.actor.cpp`](https://github.com/apple/foundationdb/blob/7.3.77/fdbrpc/sim2.actor.cpp), [`fdbserver/workloads`](https://github.com/apple/foundationdb/tree/7.3.77/fdbserver/workloads), [testing documentation](https://apple.github.io/foundationdb/testing.html). | Apache-2.0 plus acknowledgements and third-party notices. Large C++/Flow build and operational surface. Release-signature/key state and transitive notices require exact legal/security review before any code use; none is proposed. | Reuse single-seed deterministic simulation, virtual time/network/disk, workload assertions, repeated simulation and real-cluster companion tests. Do not copy Flow actors, database architecture, fault probability distribution or claims of equivalence to Windows/SQLite/PostgreSQL. | **REFERENCE ONLY.** Architectural inspiration for scheduler/evidence design, not a package, service or code source. |
| O10 | [TigerBeetle repository](https://github.com/tigerbeetle/tigerbeetle); [release `0.17.9`](https://github.com/tigerbeetle/tigerbeetle/releases/tag/0.17.9), released 3 July 2026, commit `cc1c06a`; [changelog](https://github.com/tigerbeetle/tigerbeetle/blob/0.17.9/CHANGELOG.md). Relevant: [`src`](https://github.com/tigerbeetle/tigerbeetle/tree/0.17.9/src), VOPR and TimeSim test paths referenced by the release/changelog. | Apache-2.0. Zig toolchain, custom storage/replication implementation and release binaries are outside UAM's accepted implementation family. | Reuse the discipline of deterministic simulation per release, invariant-rich generated operations, fixture promotion and a separate reality lane. Do not copy its consensus/ledger architecture, durability assumptions, custom I/O stack or exact fault distributions. | **REFERENCE ONLY.** High-value testing pattern, no dependency or architecture transplant. |
| O13 | [Microsoft Detours repository](https://github.com/microsoft/Detours); [release `v4.0.1`](https://github.com/microsoft/Detours/releases/tag/v4.0.1), released 16 April 2018, commit `e4bfd6b`. Relevant: [`src`](https://github.com/microsoft/Detours/tree/v4.0.1/src), [`samples`](https://github.com/microsoft/Detours/tree/v4.0.1/samples), tests. | MIT. The reviewed release is old. API interception changes process behavior and is security-sensitive; architecture/mitigation compatibility must be proved on each supported Windows build. | Reuse only the concept of narrowly intercepting an exact API in a disposable lab when no supported fault mechanism exists. Do not inject into production, generalize it into a runtime plugin, hook arbitrary processes, or use it before official Application Verifier/OS/storage controls. | **REFERENCE / LAST-RESORT LAB OPTION.** Requires a separate ADR, exact signed test binary, restricted target list and full cleanup proof. |

### 14.4 Consolidated adoption and removal rules

1. **One generator framework.** Admit FsCheck or a later demonstrably superior alternative, not two overlapping frameworks. All UAM history/capsule formats remain library-neutral.
2. **No OSS oracle.** No repository supplies UAM's accepted privacy, custody, audit, realm, deletion or release semantics. The UAM model and checker remain authoritative and independently mutated.
3. **High-authority tools are isolated.** Mutation tools, Docker/Testcontainers, network proxies, AppVerifier, database test builds, source instrumentation and crash tools run in trusted disposable lanes with no production data, secrets, signing or deployment authority.
4. **Test-build evidence needs ordinary-build evidence.** PostgreSQL injection points, SQLite test VFS behavior and any source-instrumented binary are paired with black-box process/network/filesystem/restore tests against the exact ordinary candidate bits.
5. **No unresolved provenance.** SharpFuzz and Coyote remain no-go/reference until exact package bytes map to reviewed source and the execution-time .NET/toolchain gate passes.
6. **Licenses are inputs, not conclusions.** This assessment identifies apparent project licenses; Legal/Procurement still owns use, redistribution, notices, support and commercial obligations.
7. **Removal is designed first.** Every adapter has one repository owner, one lock record, one evidence directory and one documented replacement/removal path. Tests cannot serialize private tool object graphs into the long-lived UAM evidence contract.
8. **Security posture is continuously rechecked.** A new release, advisory, compromised maintainer/signing path, abandoned support line or unexpected network behavior freezes the tool until the dependency record and positive controls are renewed.

---

## 15. Source register with stable links, source/release dates, reviewed versions/commits, claim supported, and limitations

### 15.1 Supplied project evidence

| Ref | Supplied source and reviewed digest | Date/status | Claim supported | Limitation |
|---|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md`; SHA-256 `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | baseline dated 31 July 2026 | accepted architecture, non-negotiable privacy/durability/realm/release/restore invariants, human-decision boundary | condensed working baseline, not runtime proof or production authority |
| I02 | `05-decisions-contradictions-and-gates.md`; SHA-256 `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | July 2026 synthesis | accepted proof-gate order, direct-read/backup/defer choice, early-gate stop rule | implementation-research authority only; does not prove any gate has passed |
| I03 | `03-sanitized-windows-lab-capability.md`; SHA-256 `8da73d913e7f1b01d943e4c8b0ed7bb2722571ff6a3a20cef0b8f47738a4658f` | inspected 31 July 2026 | a placeholder-driven Windows lab connection path exists and a read-only inventory can be designed | proves no OS/build/runtime/session/TPM/proxy/EDR/VDI capability and authorizes no connection; actual connection data is excluded |
| I04 | `06-research-evidence-rules.md`; SHA-256 `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | current research rules | evidence labels, source-quality hierarchy, human-authority boundary, no-secret/no-personal-data rule and explicit change-proposal discipline | process rule, not technical evidence |
| I05 | `result-review-01-foundations.md`, supplied locally as `batch-01-review-result(3).md`; SHA-256 `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | review dated 31 July 2026; accept with mandatory conditions | accepted G0/G1/contracts/identity/privacy/repository foundation, deterministic T1 package, independent oracle, hostile Windows and release gates | predecessor acceptance is conditional; the exact G1/owner/tool gates are not assumed passed in this result |
| I06 | `result-review-02-endpoint-data.md`; SHA-256 `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | review dated 31 July 2026; implementation prototypes only | accepted Edge source/generation/interpretation/page models, raw Task Host boundary, atomic page handoff, source-write/privacy stop gates | G2/G3/G4/G5 runtime evidence remains open; no live-source or production authority |

**FACT.** All six allowlisted files were present. No missing-file substitution was required, and no other Project file was opened, searched, summarized or used.

### 15.2 Current platform, specification and engineering sources

| Ref | Primary source and stable link | Source/release date and reviewed version | Claim supported | Limitation |
|---|---|---|---|---|
| W01 | Microsoft, [TimeProvider overview](https://learn.microsoft.com/en-us/dotnet/standard/datetime/timeprovider-overview) | page updated 20 January 2026; reviewed 31 July 2026 | .NET provides an abstraction for UTC/local time, timestamps, elapsed time and timers; `FakeTimeProvider` is the intended testing companion | documented API capability, not proof every UAM dependency observes the injected clock |
| W02 | Microsoft, [Testing with FakeTimeProvider](https://learn.microsoft.com/en-us/dotnet/core/extensions/timeprovider-testing) | page updated 2 March 2026; reviewed 31 July 2026 | controlled advancement and deterministic timer/time tests are supported | examples can show a point package version; UAM selects/locks the exact supported patch at execution time and still bans ambient time in governed modules |
| W03 | SQLite, [How SQLite is tested](https://sqlite.org/testing.html) | page last updated 21 April 2026 | SQLite's own campaigns include VFS-rigged nth/sticky I/O faults, crash/OOM/fuzz and integrity checks | describes SQLite's engine assurance, not UAM/provider/Windows/filesystem fitness; some named SQLite test suites are not open source |
| W04 | SQLite, [`sqlite3_test_control`](https://sqlite.org/c3ref/test_control.html) | current interface documentation reviewed 31 July 2026 | interface is for SQLite's internal testing, may change and may be compiled out | unsuitable as UAM application/runtime dependency; a source-built isolated engine test may use private facilities without shipping them |
| W05 | PostgreSQL, [PostgreSQL 18.4 release notes](https://www.postgresql.org/docs/release/18.4/) | released 14 May 2026 | exact current reviewed PostgreSQL 18 maintenance release for the source-test reference lane | release existence is not the UAM engine decision, capacity proof or restore evidence |
| W06 | PostgreSQL source, [`REL_18_4` injection-points module](https://github.com/postgres/postgres/tree/REL_18_4/src/test/modules/injection_points) | tag `REL_18_4`; reviewed 31 July 2026 | official developer/test injection-point support exists in the source tree | requires a source-built test configuration; not ordinary production bits and not application semantics |
| W07 | PostgreSQL source, [isolation-test README at `REL_18_4`](https://github.com/postgres/postgres/blob/REL_18_4/src/test/isolation/README) | tag `REL_18_4`; reviewed 31 July 2026 | isolation tests describe concurrent sessions, steps and possible permutations | database-internal schedule exploration does not replace UAM HTTP/worker/history checking or ordinary-image tests |
| W08 | SQLite, [release history](https://www.sqlite.org/changes.html) | `3.53.4`, released 24 July 2026; source ID `bf7c7f30031888f4e796e429ab3978879485813aaca6f641c7b33e4e09459bcc` | exact point-in-time latest reviewed SQLite release and why native source identity must be captured | selected .NET provider may load another binary; execution-time evidence controls the actual version |
| W09 | Microsoft Sysinternals, [NotMyFault](https://learn.microsoft.com/en-us/sysinternals/downloads/notmyfault) | v4.5, published 7 May 2026 | official Windows tool can deliberately crash, hang or leak kernel memory for recovery testing | destructive, administrator-level and unsuitable for endpoint CI/pilot/production; disposable VM and explicit approval required |
| W10 | Microsoft, [Application Verifier](https://learn.microsoft.com/en-us/windows-hardware/drivers/devtest/application-verifier) | page updated 23 July 2025; reviewed 31 July 2026 | official user-mode verification includes Basics, Cuzz, low-resource and privilege-related checks | primarily unmanaged-runtime instrumentation; changes timing and behavior; applicability to each executable/API path must be measured |
| W11 | Microsoft, [Testing applications with Application Verifier](https://learn.microsoft.com/en-us/windows-hardware/drivers/devtest/application-verifier-testing-applications) | current documentation reviewed 31 July 2026 | run target with and without verification/faults; settings must be explicitly removed | command syntax and available tests vary by installed kit; UAM wrapper inventories actual tool version and never accepts raw arbitrary flags |
| W12 | Microsoft, [Systematic Low Resource Simulation](https://learn.microsoft.com/en-us/windows-hardware/drivers/devtest/systematic-low-resource-simulation) | page updated 15 December 2021; reviewed 31 July 2026 | predictable/reproducible kernel-resource failure simulation is available | destructive/persistent settings and reboot requirements make it a targeted physical/VM lab exercise, not a universal test |
| W13 | Microsoft, [SQL Server 2025 build versions](https://learn.microsoft.com/en-us/troubleshoot/sql/releases/sqlserver-2025/build-versions) | SQL Server 2025 CU7, build `17.0.4065.4`, released 16 July 2026 | point-in-time current reviewed SQL Server candidate servicing level | build list does not approve licensing, support, engine selection or UAM semantic parity; exact candidate image must be locked later |
| W14 | Microsoft, [Back up and restore SQL Server databases](https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/back-up-and-restore-of-sql-server-databases?view=sql-server-ver17) | current SQL Server 2025 documentation reviewed 31 July 2026 | a restore strategy is not established until backups have been restored in required combinations and consistency checked | general operational guidance; UAM still needs its own receipt/deletion/readiness oracle, topology and RPO/RTO decisions |
| W15 | Microsoft, [`RESTORE` statements and `VERIFYONLY`](https://learn.microsoft.com/en-us/sql/t-sql/statements/restore-statements-for-restoring-recovering-and-managing-backups-transact-sql?view=sql-server-ver17) | page updated 21 July 2026; reviewed 31 July 2026 | `VERIFYONLY` checks readability/completeness but is not a full restored-data validation | cannot replace actual restore, application reconciliation or deletion/readiness checks |
| W16 | Microsoft, [`DBCC CHECKDB`](https://learn.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-checkdb-transact-sql?view=sql-server-ver17) | current SQL Server 2025 documentation reviewed 31 July 2026 | logical/physical consistency checks are available after restore; known-good restore is preferred to unsafe repair | database consistency does not by itself prove UAM business invariants, acknowledged-event completeness or deleted-data invisibility |
| W17 | NIST, [SP 800-218, Secure Software Development Framework 1.1](https://csrc.nist.gov/pubs/sp/800/218/final) | February 2022 | secure requirements, design, verification, provenance and vulnerability-response practices belong in the lifecycle | framework is technology-neutral and does not specify UAM's test architecture or approve organizational controls |
| W18 | Microsoft, [Microsoft Security Development Lifecycle](https://learn.microsoft.com/en-us/compliance/assurance/assurance-microsoft-security-development-lifecycle) | page updated 29 September 2025; reviewed 31 July 2026 | threat modelling, secure coding/review, testing, release and response are lifecycle controls | describes Microsoft's assurance practice, not evidence UAM has implemented it |
| W19 | Microsoft, [Secure development lifecycle guidance](https://learn.microsoft.com/en-us/azure/well-architected/security/secure-development-lifecycle) | page updated 19 March 2026; reviewed 31 July 2026 | secure design/review, automated checks, supply-chain controls and incident feedback should be integrated | cloud-oriented guidance; UAM must adapt it to Windows endpoints, offline operation and its own authority boundaries |
| W20 | OpenTelemetry, [Metrics concepts](https://opentelemetry.io/docs/concepts/signals/metrics/) | page updated 2 July 2026; reviewed 31 July 2026 | metric cardinality is driven by unique attribute combinations; unbounded identity/path values are dangerous dimensions | specification/concept guidance does not set UAM's metric budget or guarantee an exporter/backend enforces it |
| W21 | W3C, [Web Content Accessibility Guidelines 2.2](https://www.w3.org/TR/WCAG22/) | W3C Recommendation, 12 December 2024 | relevant evidence and administration interfaces need keyboard, focus, semantic, error and non-color-only accessibility behavior | automated scanning is incomplete; scope and conformance claim require human accessibility testing and owner approval |
| W22 | Microsoft, [.NET and .NET Core support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) | page updated 14 July 2026; reviewed 31 July 2026; .NET 10 active LTS, listed patch `10.0.10`, support through 14 November 2028 | accepted .NET family can be implemented on a currently supported LTS line; exact tool/runtime inventory is point-in-time evidence | does not prove application/library compatibility; patch numbers must not be hardened into timeless architecture and must be refreshed at execution/release time |

### 15.3 Open-source source register

| Ref | Exact reviewed source | Date/version | Claim supported | Limitation |
|---|---|---|---|---|
| O01 | [FsCheck `3.3.4`, commit `7c583d6df4939643fd36f0439694be1456833aff`](https://github.com/fscheck/FsCheck/tree/7c583d6df4939643fd36f0439694be1456833aff) | 25 July 2026 | active C#/.NET generator and shrink candidate under BSD-3-Clause | no UAM model/checker semantics; exact NuGet and transitive evidence still required |
| O02 | [Hedgehog .NET `v2.0.0`](https://github.com/hedgehogqa/fsharp-hedgehog/tree/v2.0.0) | 8 December 2025; release commit `6beeb96` | integrated shrinking alternative under Apache-2.0 | F# ergonomics and duplicate-framework cost; reference unless FsCheck bake-off fails |
| O03 | [Stryker.NET `4.16.0`](https://github.com/stryker-mutator/stryker-net/releases/tag/dotnet-stryker%404.16.0) and [issue 3698](https://github.com/stryker-mutator/stryker-net/issues/3698) | release 3 July 2026; issue 9 July 2026 | current mutation-test candidate and direct Windows generated-source compatibility warning | pure modules first; mutation score is supporting evidence, not release proof |
| O04 | [SharpFuzz package `2.3.0`](https://www.nuget.org/packages/SharpFuzz/2.3.0) and [reviewed source `v2.2.0`](https://github.com/Metalnem/sharpfuzz/tree/28c353b41a1ff60039bf78293dbd5edd9d7c3014) | package 16 June 2026; source mapping mismatch unresolved | current package exists and coverage-guided .NET fuzzing is feasible | **NO-GO:** exact package-to-source identity not established; native fuzzer/corpus controls also open |
| O05 | [Microsoft Coyote package `1.7.11`](https://www.nuget.org/packages/Microsoft.Coyote/1.7.11) and [repository](https://github.com/microsoft/coyote) | 18 March 2024 | controlled scheduling/replay concepts | package/source mapping, age, support posture and OS/native blind spots make it reference/spike only |
| O06 | [Testcontainers .NET `4.13.0`, commit `1717807affaae9b967035516ebedcd76dd7eaffb`](https://github.com/testcontainers/testcontainers-dotnet/tree/1717807affaae9b967035516ebedcd76dd7eaffb) | 2 July 2026 | current disposable integration-environment candidate under MIT | Docker daemon/image authority and license/provenance must be isolated and pinned |
| O07 | [Toxiproxy `v2.12.0`](https://github.com/Shopify/toxiproxy/tree/v2.12.0) | 18 March 2025; commit `3ccd6a7` | mature deterministic TCP-fault candidate under MIT | cannot model application commit/receipt semantics without UAM hostile server |
| O08 | [Jepsen `v0.3.13`](https://github.com/jepsen-io/jepsen/tree/v0.3.13), [release](https://github.com/jepsen-io/jepsen/releases/tag/v0.3.13), [license metadata](https://github.com/jepsen-io/jepsen/blob/v0.3.13/jepsen/project.clj) | 31 July 2026; commit `0aad6ff`; Eclipse Public License 1.0 | history/checker/nemesis/final-read patterns and current maintenance | destructive cluster/JVM/Clojure assumptions do not fit initial modular monolith; reference only |
| O09 | [FoundationDB `7.3.77`](https://github.com/apple/foundationdb/tree/7.3.77) and [testing documentation](https://apple.github.io/foundationdb/testing.html) | 16 April 2026; commit `3ea44ce` | mature deterministic simulation plus real-cluster validation pattern | different database, language, topology and large transitive surface; reference only |
| O10 | [TigerBeetle `0.17.9`](https://github.com/tigerbeetle/tigerbeetle/tree/0.17.9) and [changelog](https://github.com/tigerbeetle/tigerbeetle/blob/0.17.9/CHANGELOG.md) | 3 July 2026; commit `cc1c06a` | VOPR/TimeSim-style deterministic release campaign pattern under Apache-2.0 | different storage/replication architecture and language; reference only |
| O11 | [PostgreSQL `REL_18_4`](https://github.com/postgres/postgres/tree/REL_18_4), [injection points](https://github.com/postgres/postgres/tree/REL_18_4/src/test/modules/injection_points), [isolation tests](https://github.com/postgres/postgres/blob/REL_18_4/src/test/isolation/README) | 14 May 2026; PostgreSQL License | official test-build injection and schedule-permutation capabilities | developer/test binary only; pair with ordinary image and actual restore |
| O12 | [SQLite source/testing](https://sqlite.org/testing.html), [3.53.4 release history](https://www.sqlite.org/changes.html) | 24 July 2026; source ID `bf7c7f30031888f4e796e429ab3978879485813aaca6f641c7b33e4e09459bcc` | public VFS and nth/sticky-failure design evidence | actual UAM provider/native mapping is separate; proprietary SQLite suites are not reusable |
| O13 | [Microsoft Detours `v4.0.1`](https://github.com/microsoft/Detours/tree/v4.0.1) | 16 April 2018; commit `e4bfd6b`; MIT | last-resort API-interception reference | old, invasive and high-risk; official Windows mechanisms preferred, lab-only ADR required |

### 15.4 Source interpretation rules

- A documentation page proves a documented capability or warning, not UAM fitness.
- A repository tag proves what was reviewed, not that its package, binary, image or installed native module is identical.
- A test-build result proves the named test build only. The ordinary candidate distribution must repeat the externally observable claim.
- A clean integrity check proves the database is structurally acceptable to that checker, not that UAM custody, deletion, realm, audit or visibility semantics are correct.
- An OSS license indication is not organizational approval. Legal/Procurement owns final obligations and support terms.
- Mutable branch links are discovery aids only. Release evidence pins immutable tags, commits, package hashes, image manifests and native source IDs.
- Any current-version statement in this register expires at execution/release selection and is renewed through the dependency/runtime inventory lane.

---

## 16. Confidence table for every major conclusion

| Major conclusion | Confidence | Why | Evidence that would change it |
|---|---|---|---|
| A layered model/property/concurrency/fault/reality strategy is required | **High** | accepted invariants span pure state semantics, process/session authority, filesystems, transactions, networks, workers, release and restore; no one technique observes all layers | a materially simpler strategy demonstrates automated falsification of every INV-01–INV-28 invariant with equal boundary realism, replay and operating cost |
| UAM must own the models, command/event alphabets, checkers and evidence schema | **High** | these encode project-specific privacy, custody, realm, audit, deletion and release meaning; tool APIs are replaceable and sometimes unstable | a formally specified external standard exactly matches all UAM semantics and proves a lower-risk migration/removal path; UAM would still own the mapping |
| Models must be implemented before components | **High** | the primary gate requires a falsification path before production-shaped behavior, and model-first exposes semantic disagreement before OS/DB noise | a predecessor contract is found internally inconsistent and cannot be modeled; that opens an ADR/change proposal rather than component-first implementation |
| Every load-bearing invariant needs an automated falsifier or explicitly owned manual exercise | **High** | direct prompt gate and accepted evidence rules; it prevents prose-only assurance and hidden residuals | designated governance changes the blocking policy after understanding the residual consequence; no technical result may silently relax it |
| Deterministic root seeds, domain-separated streams, virtual clocks and immutable histories are the correct reproducibility base | **High** | concurrent/fault results require exact replay, independent shrink and time manipulation; .NET supplies a documented clock abstraction | a planted failure cannot replay across supported runners despite captured environment, showing another source of nondeterminism that needs an added contract |
| A UAM causal shrinker should sit above the property framework | **High** | generic value shrinking can violate state preconditions or remove the causal trigger; UAM needs valid minimal histories independent of library version | a selected framework proves stable domain-aware state-history shrinking across all models with portable evidence and lower maintenance; UAM still retains a fallback reducer |
| FsCheck 3.3.4 is the initial property-generator candidate | **Medium-High** | active current release, permissive license, direct .NET/C# fit and accepted predecessor assessment | package/source/security/license/compatibility failure, abandonment, or a Hedgehog/custom pilot materially better at valid concurrent-history shrinking |
| Hedgehog should remain an alternative rather than a parallel default | **Medium-High** | running two general frameworks splits seeds, shrink semantics, expertise and CI without adding a new boundary | a measured FsCheck shrink/replay defect that Hedgehog solves with materially lower custom complexity |
| Mutation testing is a release-supporting sensitivity gate, not a primary correctness oracle | **High** | it verifies that tests notice selected code changes but cannot prove environmental behavior or absence of equivalent mutants | a stronger formal sensitivity technique with comparable C#/tooling cost; coverage alone would not change this conclusion |
| Stryker.NET should start with pure modules, not Windows interop | **High** | reviewed current issue demonstrates generated-symbol risk; pure modules give high value with lower tool-specific noise | exact execution-time Stryker/CsWin32/toolchain evidence passes planted interop mutants and stable builds on the supported matrix |
| Test hooks must be semantic, closed, deterministic and absent from production artifacts | **High** | open hooks become control/injection surfaces; semantic locations make transaction meaning explicit; production absence is testable through architecture, binary and activation negatives | no ordinary reason should weaken absence; a production diagnostic need would require a separate narrow signed capability and baseline/privacy review, not reuse of test hooks |
| Deterministic hooks and real-boundary faults must be paired for load-bearing claims | **High** | hooks localize the exact boundary while real process/file/VM/network/database faults test the unmocked implementation and recovery path | repeated evidence that a real boundary cannot distinguish the claim and a narrower companion exists; removing all real companions would conflict with accepted evidence rules |
| SQLite fault testing should use a UAM test VFS/shim plus process/VM/filesystem reality lanes | **High** | SQLite's own public testing pattern validates nth/sticky VFS faults; internal test controls are unstable; endpoint durability depends on real native/OS behavior | selected provider cannot support a safe VFS/shim and another bounded method proves equivalent nth/sticky coverage plus real-boundary behavior |
| `sqlite3_test_control` must not become application code | **High** | SQLite explicitly documents its unstable, optional, internal-test nature | no expected change; an isolated source-built SQLite reference test does not alter product-code prohibition |
| PostgreSQL injection points and isolation specs are valuable only as a source-built reference lane | **High** | official source contains both, but ordinary production distributions do not expose the same test configuration | production packaging later ships a supported equivalent and operations approve it; ordinary-image and restore companions would still remain |
| SQL Server `VERIFYONLY` cannot replace an actual restore and application reconciliation | **High** | Microsoft documentation distinguishes readability/completeness from restored data structure; UAM also has deletion/readiness/business invariants | no expected documentation change would eliminate the need to execute the restored application state and check UAM history |
| Application Verifier and NotMyFault belong only in approved disposable Windows lab lanes | **High** | they alter or crash the system and can require administrator/kernel authority; accepted lab facts do not establish production safety | a supported non-destructive mechanism proves the same exact boundary; production/pilot use remains inappropriate |
| Testcontainers and Toxiproxy are useful server-lane candidates, not endpoint or semantic oracles | **High** | they provide disposable dependencies and TCP faults but cannot reproduce Windows sessions or decide whether a receipt is legitimate | changed topology or tool evidence; they still require UAM histories/checkers and exact image/network containment |
| Coyote is not the default concurrency runtime | **Medium-High** | package/source/support age concerns and managed instrumentation blind spots; UAM needs process/native/DB scheduling too | current, mapped, supported release plus a bounded spike finds recurring pure-managed defects the UAM scheduler cannot expose economically |
| Jepsen is reference only for the initial modular monolith | **High** | its strongest fit is multi-node distributed-system histories under nemeses; UAM initially has one relational authority and no custom consensus | accepted introduction of broker/multi-primary/custom replication or cross-region failover with a genuine consistency model and a justified JVM/operations lane |
| FoundationDB simulation and TigerBeetle VOPR are design references, not architectures to copy | **High** | their deterministic-test discipline is relevant but implementation language, storage engine, topology and threat model differ materially | a future component adopts a sufficiently similar custom deterministic runtime and a separate ADR proves architectural/license/skills fit |
| Coverage percentages cannot be the primary release gate | **High** | line/branch execution says nothing about correct assertions, schedules, fault boundaries or privacy sinks; invariant/falsifier mapping and mutants are more direct | no conventional coverage metric can prove these semantic properties; it may remain a trend and gap-discovery input |
| Critical mutation survivors block the affected gate unless narrowly justified | **High** | a planted load-bearing semantic defect surviving means the falsification path is ineffective or absent | independent proof the mutant is equivalent/unreachable under the normative contract, recorded with owner and review trigger |
| A rerun must never erase the first load-bearing failure | **High** | preserving first evidence is necessary to diagnose flakes, infrastructure failures and real races; green-on-retry hides uncertainty | no expected change; infrastructure retry policy may classify but cannot overwrite history |
| Unclassified load-bearing flaky tests must block release and cannot be quarantined silently | **High** | nondeterminism can be the defect under test; accepting rerun success would defeat deterministic evidence | accountable human risk policy may define an explicitly owned manual residual, but it cannot be disguised as a passing automated gate |
| Realm isolation, audit atomicity and deletion/restore need explicit state models, not only API tests | **High** | these properties span authorization context, database transactions, queues/workers, epochs and restored visibility | a formally verified database/security policy captures the complete semantics and is independently checked; black-box negative histories still remain necessary |
| Post-commit response loss and stale-worker fencing are mandatory fault cases | **High** | at-least-once delivery and leased workers make ambiguity and stale completion normal failure modes; omitting them can hide duplicate effects or wrong receipts | architecture changes to exactly-once transactional transport or removes leasing through an accepted change proposal; practical response loss/fencing tests still likely remain |
| Deletion must use an epoch/tombstone/readiness model that survives restore and late arrival | **High as a test requirement; Medium for exact production schema** | accepted invariant forbids deleted-data visibility before readiness and demands acknowledged-event preservation; exact retention/deletion scope is human-owned | approved deletion semantics, backup topology and correction contract produce a different formal model that preserves the invariant and passes the same adversarial histories |
| Privacy-safe evidence requires T1 inputs, exact canaries, closed error taxonomy and bounded metric labels | **High** | the test system itself can leak URLs, identities, paths, credentials or high-cardinality state; accepted privacy ceiling applies to diagnostics/evidence | a new diagnostic field is human-approved and formally bounded/minimized; raw source values remain prohibited from general evidence |
| Accessibility is relevant to test evidence and administration interfaces | **High** | operators must perceive, navigate and act on failure/kill/deletion/realm states accurately; inaccessible or color-only state can create operational error | no change expected; exact UI scope and conformance level remain human/product decisions |
| CI/lab/pilot lanes must remain distinct | **High** | destructive authority, supported-environment realism, cost and data exposure differ; one lane cannot safely inherit another's powers | a platform demonstrates equivalent disposable isolation and authority separation; the trust classifications still remain explicit |
| Exact campaign counts, resource budgets, fault distributions, metric limits and duration are not architecture facts | **High** | no representative production distributions, SLOs, budgets or estate evidence is supplied | metadata-safe measurements, synthetic campaigns and accountable owner decisions replace the labeled estimates in versioned gate configuration |
| Current dependency/runtime patch selections are execution-time evidence, not timeless decisions | **High** | .NET, SQLite, database engines and tools continue to service; current support/advisory state can change after this review | no change expected; lifecycle policy is intentionally the stable architecture rule |
| This result authorizes harness/model work, not live data, pilot or production | **High** | predecessor gates and human decisions remain open; research cannot approve purpose, risk, lab availability, retention, SLOs or deployment | designated human authorities plus all predecessor/current/later gates can authorize a bounded next stage; this document cannot self-approve it |

---

## Final residual risk and next stop/go gate

### What remains unsafe or impossible to prove through research alone

**UNKNOWN.** No finite campaign proves every thread schedule, power-loss instant, firmware cache behavior, filesystem filter interaction, EDR interception, hypervisor snapshot state, Windows policy combination, browser/database future change or operator mistake. Deterministic exploration makes failures reproducible; it does not make the explored set exhaustive.

**UNKNOWN.** A component can pass every semantic hook and still fail at an uninstrumented native, kernel, storage, network or deployment boundary. The paired real-boundary lane reduces this common-mode risk but cannot eliminate hardware, firmware, virtualisation and enterprise-control variance.

**UNKNOWN.** The Windows lab summary proves only that a connection path exists. Supported OS builds, session technologies, profile virtualisation, EDR/CFA, storage, proxy/VPN, TPM and installed tool/runtime versions remain unproved until an approved sanitized inventory and exact campaigns run. Destructive Windows work is operationally costly because each run needs a disposable/reverted machine, controlled authority, first-failure preservation and cleanup proof.

**UNKNOWN.** Exact SQLite provider/native behavior, PostgreSQL and SQL Server candidate operations, backup topology, restore duration, disk pressure, long-outage behavior and 6,000-endpoint capacity remain experiments. A test VFS, container or source-built database cannot establish production hardware, ordinary distribution, restore competence or support cost.

**UNKNOWN.** Model/checker independence can still contain a shared conceptual error. The containment is hand-worked histories, critical mutants, independent implementation comparisons where justified, actual state reconciliation and architecture review—not a claim of mathematical completeness.

**HUMAN DECISION.** Risk acceptance for residuals without safe automation, required evidence depth/release-blocking policy, and physical/lab capacity remain explicitly human-owned. Purpose, prohibited uses, fields, identity, retention, access, consultation, budget, staffing, SLO/RPO/RTO, deletion scope and production approval also remain outside this research authority.

**Operational cost.** The recommended design creates real work: model maintenance, deterministic scheduler/evidence infrastructure, exact dependency provenance, disposable Windows/database runners, restore datasets, fault cleanup, flake triage, mutation review, recurring release/runtime qualification and accessible evidence tooling. Removing that work would remove assurance, not merely test overhead.

**Privacy residual.** Synthetic canaries and all-sink scans cannot prove that opaque EDR, crash, pagefile, hypervisor or support tooling never captures transient sensitive memory. Production diagnostics and dump policy therefore require Endpoint Security, Privacy and Incident Response ownership; raw production activity is never used to make this gate convenient.

**Release residual.** Production-hook absence can be strongly tested through project graph, binary/file inspection, activation negatives, SBOM/provenance and challenged builds, but supply-chain compromise, signing-key misuse or a defect in the absence checker remains possible. Separate authority, same-digest promotion, independent verification and incident revocation contain that risk.

### Explicit next stop/go gate

**GO now** for backlog items 1–15: the six-input evidence manifest, ADRs, pure invariant registry, command/event/fault alphabets, UAM-owned models/checkers, deterministic seed/clock/history/shrinker, failure-capsule validator, critical mutants, T1 canaries and test-only hook contracts. These activities use fictional data and do not require a live Windows source or production database.

**GO conditionally** for component/database CI lanes only after the exact tool/package/image/native admission records pass, production-hook architecture tests pass, and each deterministic hook has its named real-boundary companion plan and cleanup contract.

**STOP before real or destructive Windows experiments** until an accountable human approves lab/physical availability and scope, the exact predecessor G1 evidence is bound to the test build/environment, a read-only sanitized inventory succeeds, and placeholder-only commands contain no connection material, credentials, internal addresses, real identities or raw activity.

**STOP before deletion/restore production claims** until deletion scope, retention/legal hold, RPO/RTO and backup/restore authority are decided, then the actual restore and late-arrival/readiness histories pass on every claimed engine/topology.

**STOP before pilot or production** on any missing invariant-to-falsifier mapping, unowned manual residual, critical mutation survivor, unclassified load-bearing flake, forbidden-value/canary escape, cross-session or cross-realm acceptance, cursor-ahead state, premature receipt, duplicate business effect, audit/mutation split, stale-worker completion, unauthorized/mixed release, silent pressure loss, acknowledged-event loss, deleted-data early visibility, callable production hook, uncontained destructive tool or cleanup residue.

**Primary next gate:**

```text
EVERY LOAD-BEARING INVARIANT
    HAS AN AUTOMATED FALSIFICATION PATH
    OR AN EXPLICITLY OWNED, SCHEDULED, EVIDENCED MANUAL EXERCISE;
AND EVERY AUTOMATED LOAD-BEARING PATH
    REPLAYS FROM ITS ROOT SEED/HISTORY,
    PASSES ITS CRITICAL MUTANTS,
    HAS THE REQUIRED REAL-BOUNDARY COMPANION,
    PRESERVES THE FIRST FAILURE,
    SCANS CLEAN FOR FORBIDDEN VALUES,
    AND PROVES CLEANUP.
```

Until that expression is true for the exact claimed scope and is bound by immutable `prompt-10-gate.json`, the decision is **STOP**. A pass authorizes only the next named proof gate; it is not production approval and does not erase the residual risks above.
