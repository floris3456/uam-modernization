# Final synthesis — next-generation UAM technical baseline

## Expert role

You are the chief architect chairing the final implementation-baseline review. You are responsible for evidence quality and consistency, not for maximizing scope.

## Result target

Save the complete response as `results/final-synthesis/next-generation-technical-baseline-result.md`.

## Attachments

### Project-file allowlist

The ChatGPT Project may contain every suite attachment and result. For this final-synthesis chat, you are allowed to read exactly these project files:

- `batch-01-review-result.md`
- `batch-02-review-result.md`
- `batch-03-review-result.md`
- `batch-04-review-result.md`
- `batch-05-review-result.md`
- `batch-06-review-result.md`
- `00-accepted-baseline-attachment.md`
- `06-research-evidence-rules.md`

Do not open, search, quote, summarize, or use any other Project file, including individual topic results. Optional measured CLI evidence is forbidden by default. Before running this prompt, a human may add exact sanitized CLI-evidence filenames to this allowlist; only those explicitly added files then become readable. If an allowed file is missing, report the missing filename instead of substituting another file.

Do not accept a claim merely because it appears in more than one chat.

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

1. What accepted decisions, interfaces, schemas, state machines, invariants, and gates now define the next-generation application?
2. Which earlier baseline decisions must change because of stronger evidence or failed CLI experiments?
3. Which contradictions remain and what exact evidence resolves them?
4. What is ready to implement now, what is experiment-only, what requires humans, and what is safely deferred?
5. Does the plan cover endpoint, data, release, identity, diagnostics, compatibility, server, lifecycle, portal, audit, migration, operations, and decommissioning without hidden trust gaps?

## Required web verification

Verify only disputed or time-sensitive load-bearing facts. Use current primary sources and preserve reviewed dates/versions. Do not replace measured CLI evidence with online claims.

## Open-source reference review

Consolidate only repositories with reproducible permalinks, acceptable license, active maintenance, useful tests, understood security posture, clear fit, and dependency/reference classification.

## Required output

1. Executive implementation recommendation in easy language.
2. Updated constraints, non-goals, prohibited defaults, and residual risks.
3. Complete component/trust/data-flow architecture.
4. Normative responsibility and dependency map.
5. Contract, protocol, schema, state-machine, compatibility, configuration, feature-flag, and kill-switch register.
6. Security/privacy/realm-isolation and incident-response baseline.
7. Release, identity, diagnostics, compatibility, server, retention, portal, audit, migration, and decommissioning baselines.
8. Decision register with status: accepted, provisional, CLI-measurement, human-decision, deferred, or rejected.
9. Contradiction and evidence-quality register.
10. Architecture fitness functions and full proof-gate map.
11. Most-detailed immediate implementation plan for the next unstarted gate, with repository tasks, tests, evidence, dependencies, stop conditions, and cleanup.
12. Later roadmap with progressive precision rather than false certainty.
13. Human decision register and workshop sequence.
14. CLI measurement/experiment register and evidence ingestion method.
15. Operational ownership, runbook, cost/skills/licensing, accessibility, and support gaps.
16. ADR creation/update plan.
17. Source/open-source register with stale/weak claims marked.
18. Exact first 20 project actions.

## Human decisions

Do not decide purpose, legal basis, prohibited use, identity/field scope, retention, role assignments, budget, licensing, SLO/RPO/RTO, risk acceptance, staffing, cutover, or production approval. Show options, consequences, owners, and safe temporary states.

## CLI evidence and experiments

Treat reproducible CLI/lab measurements as stronger project-specific evidence than generic vendor claims. Record environment, versions, commit, seed, commands, fixtures, raw results, pass/fail rule, and limitations. If evidence is absent, keep the decision provisional.

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

Never claim completeness or bulletproof safety. End with risks that remain even after all planned controls and the exact next gate that can invalidate the plan.
