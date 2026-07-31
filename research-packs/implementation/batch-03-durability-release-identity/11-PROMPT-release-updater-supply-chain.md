# Prompt 11 — MSI, enterprise deployment, updater, rollback, signing, TUF-style metadata, and supply chain

## Expert role

You are a Windows release-security architect and software supply-chain engineer. Produce a decision-ready, implementation-level research result for the next-generation UAM project. Use easy, precise language, but retain expert technical depth.

## Result target

Save the complete response as `results/batch-03-durability-release-identity/11-release-updater-supply-chain-result.md`.

## Attachments

### Project-file allowlist

The ChatGPT Project may contain all suite attachments. For this chat, you are allowed to read exactly these project files:

- `00-accepted-baseline-attachment.md`
- `03-sanitized-windows-lab-capability.md`
- `05-decisions-contradictions-and-gates.md`
- `06-research-evidence-rules.md`
- `batch-01-review-result.md`
- `batch-02-review-result.md`

Do not open, search, quote, summarize, or use any other Project file, even if it appears relevant. A file being present in the Project is not permission to use it. If an allowed file is missing, report the missing filename instead of substituting another file.

Earlier batch-review results in this allowlist are accepted predecessor decisions. Treat them as stronger project context than the original shared baseline; report any conflict explicitly rather than silently reverting to an older assumption.

Treat attachments according to their classification and limitations. Do not reproduce internal evidence unnecessarily. Do not request raw SSH configuration, credentials, internal addresses, personal data, production activity, or confidential reference data.

## Project context

UAM is replacing a monolithic PowerShell Windows endpoint activity-monitoring system. It must safely support at least 6,000 managed endpoints, offline operation, strict endpoint-side minimization, recoverable releases, tenant/realm isolation, auditable administration, and staged migration. The research baseline is dated July 2026; current platform facts must be freshly verified.

This prompt belongs to **Durability, testing, release, identity, diagnostics, and compatibility**. May run while G2–G5 prototypes are built. Prompts 09–14 can run in parallel but must consume accepted Batch 1–2 decisions.

## Accepted baseline

The following decisions are accepted unless new primary evidence proves a material problem:

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

Do not turn these into facts without evidence:

- Exact event fields, identity/time precision, first-run lookback, hard-deny categories, role-to-application mapping, and production retention.
- Exact SQLite limits, encryption/key-wrapping choice, batch limits, retry values, resource budgets, and ACK replay grace.
- Device PKI integration, TPM coverage, proxy/VPN behavior, autonomous updater need, and extended Windows/VDI/platform support.
- Production database engine, partition/index design, SLOs, capacity, broker need, portal technology details, and audit storage technology.
- All exact point-in-time dependency versions. Research must verify current supported releases and cite the reviewed versions without hardening patch numbers into timeless architecture.

## Research questions

1. Separate MSI/enterprise-management ownership from any optional autonomous updater; define when self-update is justified by measured patch latency.
2. Specify installation/repair/uninstall, stable launcher, immutable version directories, staging, hashes/lengths, Authenticode, repository metadata roles/expiry/thresholds, key rotation/revocation/recovery, freeze/rollback/mix-and-match protection, A/B activation, health proof, bad-version suppression, emergency downgrade, and N/N-1 data compatibility.
3. Threat-model SYSTEM file operations, reparse/TOCTOU, ACL inheritance, service/task changes, untrusted repository responses, compromised CI/signing keys, and offline devices.
4. Define SBOM/provenance/reproducibility, isolated signing, promotion rings, kill switches, incident response, and out-of-band repair.
5. Compare maintained TUF/updater/MSI open-source references without assuming direct dependency suitability.

Include threat modelling, secure coding/review, configuration ownership, feature flags and kill switches, error taxonomy, privacy-safe observability and metric-cardinality limits, incident response, support ownership/runbooks, cost/licensing/skills/operations, realm isolation, data quality, accessibility where relevant, and architecture fitness functions. Cover them in this topic's scope rather than redesigning the whole platform.

## Constraints

- Windows is the endpoint platform; user/session boundaries are security and privacy boundaries.
- Use synthetic or sanitized evidence only. Never propose uploading internal URLs, addresses, credentials, SSH material, personal information, raw production activity, or confidential reference data.
- Prefer the simplest design that satisfies measured requirements and failure containment.
- Do not invent organizational roles, purposes, legal conclusions, retention, SLOs, budgets, or production volumes.
- Define failure, detection, containment, recovery, cleanup, and evidence—not only the happy path.
- Convert unprovable recommendations into bounded CLI experiments with pass/fail gates.

## Required web verification

Verify time-sensitive claims as of the research date. Prefer official specifications, standards, Microsoft/.NET/Windows documentation, browser and database source/documentation, RFCs, regulator publications, maintained source repositories, and original engineering publications. Cite direct, stable links and record document/release dates and versions. Vendor marketing, search snippets, popularity, and synthetic benchmarks are not proof. Clearly distinguish documented capability from UAM-specific fitness.

## Open-source reference review

Actively search GitHub and official open-source sources for TUF clients/repositories, secure Windows updaters, MSI authoring projects, Sigstore/in-toto/SLSA tooling. For every repository used, report:

- repository URL and relevant files/directories;
- exact tag, release, or commit reviewed, preferably with stable permalinks;
- license and compatibility concerns;
- recent maintenance and release activity;
- testing quality and security posture;
- architectural similarities and threat-model differences;
- reusable ideas and ideas that must not be copied;
- suitability as a dependency, reference only, or neither.

Popularity alone is not evidence. Do not recommend copying an architecture without fit, maintenance, licensing, testing, and security analysis.

## Required output

Produce these sections in order:

1. Executive conclusion in easy language, with confidence and residual risk.
2. Scope, non-goals, accepted inputs, assumptions, and unknowns.
3. Recommended design with exact component responsibilities and trust boundaries.
4. Alternatives, rejection reasons, and conditions that would change the choice.
5. Interfaces/protocols and example contracts or schemas; be normative where possible.
6. State machines, transaction boundaries, lifecycle, rollout, and compatibility rules where applicable.
7. Security/privacy threat and failure register: trigger, detection, containment, recovery, cleanup, owner, test, residual risk.
8. Detailed test matrix and smallest falsifying prototypes with setup, instrumentation, steps, pass/fail, evidence, duration, and cleanup.
9. Architecture fitness functions and measurable acceptance criteria.
10. Human decisions and owner questions.
11. CLI experiments/measurements and the exact evidence they must produce.
12. ADR proposals: decision, status, alternatives, rationale, evidence, owner, review trigger.
13. Ordered implementation backlog with dependencies and stop gates.
14. Open-source repository assessment table.
15. Source register with stable links, source/release dates, reviewed versions/commits, claim supported, and limitations.
16. Confidence table for every major conclusion.

Topic-specific mandatory artifacts:

- Release and trust-plane architecture
- Install/update/rollback state machines
- Metadata/package schemas
- Key hierarchy and compromise runbook
- Attack/failure test matrix
- Enterprise deployment versus updater decision gate

Avoid general advice. Give enough detail that the accepted result can be converted into repository tasks and tests without guessing at the architecture.

## Human decisions

Research must not decide:

- Patch SLA and enterprise management coverage
- Signing/key custodians and ceremonies
- Installer tooling license/procurement
- Emergency authority

For each, give options, consequences, a conservative temporary default if safe, and the accountable role—but do not claim approval.

## CLI evidence and experiments

The CLI/lab lane must establish:

- Build test-signed good/bad/stale/tampered packages
- Kill every transition
- Prove MSI repair and rollback without production keys

Primary gate: **Unauthorized or incomplete versions never execute; every interruption leaves an operable known version; key compromise has a tested recovery path.**

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

End with what remains unsafe, uncertain, operationally costly, dependent on humans, or impossible to prove through research alone. State the next stop/go gate explicitly.
