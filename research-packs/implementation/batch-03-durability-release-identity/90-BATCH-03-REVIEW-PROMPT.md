# Batch 03 reviewer — Durability, testing, release, identity, diagnostics, and compatibility

## Expert role

You are the chief architect, evidence reviewer, security reviewer, and implementation planning chair. Reconcile this batch without choosing the most confident wording or majority opinion.

## Result target

Save the complete response as `results/batch-03-durability-release-identity/batch-03-review-result.md`.

## Attachments

Attach and read these result files completely:

- `results/batch-03-durability-release-identity/09-g5-sqlite-outbox-state-machines-result.md`
- `results/batch-03-durability-release-identity/10-invariant-fault-testing-result.md`
- `results/batch-03-durability-release-identity/11-release-updater-supply-chain-result.md`
- `results/batch-03-durability-release-identity/12-device-identity-network-result.md`
- `results/batch-03-durability-release-identity/13-diagnostics-support-result.md`
- `results/batch-03-durability-release-identity/14-windows-compatibility-policy-result.md`

Also attach `00-accepted-baseline-attachment.md`, `05-decisions-contradictions-and-gates.md`, and `06-research-evidence-rules.md`.

## Accepted baseline

- Windows endpoints use a low-privilege machine Coordinator Service, one ordinary-token User Host per eligible interactive session, and short-lived restricted Task Hosts for risky collection.
- The Coordinator does not crawl user profiles or create user tokens. User-owned sources are read in the user's session. Task Hosts are process boundaries, not arbitrary plugin or script channels.
- C#/.NET is the accepted default implementation family. Exact supported patches and fast-moving libraries are selected at execution time under lifecycle policy.
- A release-authorized product privacy ceiling limits sources, fields, transformations, destinations, and capabilities. Tenant policy may only narrow it.
- Minimization occurs before Coordinator IPC, durable storage, logs, diagnostics, or transport. Endpoints never receive central database credentials or submit SQL.
- SQLite WAL with one writer stores minimized events and source progress atomically. Delivery is at least once; stable identities and central uniqueness make the business effect idempotent.
- Uploads are bounded, versioned, authenticated, compressed HTTPS batches. A server receipt means durable custody, not necessarily semantic acceptance or portal visibility.
- The initial server design is a modular monolith with an ingestion boundary, relational durable inbox, leased workers, typed facts/aggregates, control API/BFF, and integrations through governed contracts.
- No external broker is a default. Add one only after measured failure-domain, throughput, replay, fan-out, or cost conditions justify it.
- PostgreSQL is the target reference and SQL Server is a serious transition/fallback candidate; the production engine is selected by an identical benchmark plus operations, skills, licensing, and restore evidence.
- MSI and enterprise deployment own the stable privileged boundary. Any autonomous updater is optional, minimal, repository-authorized, rollback-safe, and separately justified.
- The first functional slice is Edge browser history at site/domain-level minimized output, using synthetic data until governance permits otherwise.
- UAM telemetry is fallible operational evidence, not sole forensic proof or an employee-productivity score.
- Legal purpose, prohibited uses, identity level, retention, access, employee consultation, budget, SLO/RPO/RTO, ownership, and production approval remain human decisions.

## Provisional matters

- Exact event fields, identity/time precision, first-run lookback, hard-deny categories, role-to-application mapping, and production retention.
- Exact SQLite limits, encryption/key-wrapping choice, batch limits, retry values, resource budgets, and ACK replay grace.
- Device PKI integration, TPM coverage, proxy/VPN behavior, autonomous updater need, and extended Windows/VDI/platform support.
- Production database engine, partition/index design, SLOs, capacity, broker need, portal technology details, and audit storage technology.
- All exact point-in-time dependency versions. Research must verify current supported releases and cite the reviewed versions without hardening patch numbers into timeless architecture.

## Research questions

1. Which conclusions agree and are supported strongly enough to accept?
2. Which conclusions overlap, contradict, depend on stale claims, or exceed the prompt's authority?
3. Which proposed technologies or numeric values remain provisional?
4. Which missing schemas, protocols, state machines, failures, recovery paths, tests, or owners prevent implementation?
5. Which questions are human decisions and which require CLI evidence?
6. What is the smallest safe implementation sequence and stop/go gate for this batch?

## Required web verification

Do not redo all research. For load-bearing disputed or time-sensitive claims: Verify time-sensitive claims as of the research date. Prefer official specifications, standards, Microsoft/.NET/Windows documentation, browser and database source/documentation, RFCs, regulator publications, maintained source repositories, and original engineering publications. Cite direct, stable links and record document/release dates and versions. Vendor marketing, search snippets, popularity, and synthetic benchmarks are not proof. Clearly distinguish documented capability from UAM-specific fitness.

## Open-source reference review

Audit repository recommendations in the supplied results. Reject entries without stable commit/tag, license, maintenance, test, security, fit, and dependency/reference classification.

## Required output

1. Executive batch verdict and residual risk.
2. Accepted decisions and invariants.
3. Rejected/deferred recommendations with reasons.
4. Contradiction register with evidence-quality resolution.
5. Normative component/interface/schema/state-machine baseline for this batch.
6. Human decision register.
7. CLI experiment/measurement plan with evidence and pass/fail.
8. Threat/failure/recovery gaps.
9. ADR create/update list.
10. Ordered implementation backlog and dependency/stop gates.
11. Source and open-source quality corrections.
12. Confidence by major conclusion and evidence that could change it.

## Human decisions

Do not approve legal, privacy, ownership, access, retention, budget, licensing, SLO/RPO/RTO, staffing, risk acceptance, or production decisions. List the accountable role and consequence of delay.

## CLI evidence and experiments

Finish source/privacy prototypes; prepare crash, reboot, disk-pressure, certificate, proxy, package-tamper, and compatibility harnesses; keep production credentials and data out.

Batch gate: **Outbox invariants, update authorization, device identity, privacy-safe support, and the initial supported-platform claim must pass before an engineering canary.**

## Evidence labels and conflict handling

Use these labels consistently:

- **FACT** — directly supported by supplied evidence or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proven.
- **INFERENCE** — reasoned from facts; explain the chain.
- **ESTIMATE** — numerical hypothesis with replaceable inputs.
- **RECOMMENDATION** — proposed decision with alternatives and trade-offs.
- **UNKNOWN** — missing evidence.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, or business authority.
- **CLI EXPERIMENT** — must be established by code, lab work, or measurement.

Do not use invented numerical confidence percentages. Give High/Medium/Low confidence per major conclusion, state why, and name the evidence that would change it. If you conflict with the accepted baseline, create an explicit change proposal: affected decision, new evidence, impact, smallest falsifying experiment, migration consequence, and ADR action. Do not silently redesign adjacent components. Never call the result “bulletproof”; state residual risk and containment.

## Residual risk

End with unresolved risks, blocked dependencies, and the exact conditions under which this batch may update the main technical baseline.
