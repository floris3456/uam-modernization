#!/usr/bin/env node
import crypto from "node:crypto";
import fs from "node:fs";
import path from "node:path";
import { batches, topics } from "./implementation-research-topics.mjs";

const repoRoot = path.resolve(path.dirname(new URL(import.meta.url).pathname), "..");
const packageRoot = path.join(repoRoot, "research-packs/implementation");
const attachmentRoot = path.join(packageRoot, "attachments");
const resultRoot = path.join(packageRoot, "results");
const checkOnly = process.argv.includes("--check");
const generated = new Map();
const manifestPrompts = [];

const rel = (absolutePath) => path.relative(repoRoot, absolutePath).split(path.sep).join("/");
const pad = (value) => String(value).padStart(2, "0");
const sha256 = (filePath) => crypto.createHash("sha256").update(fs.readFileSync(filePath)).digest("hex");
const bullets = (items) => items.map((item) => `- ${item}`).join("\n");
const numbered = (items, start = 1) => items.map((item, index) => `${index + start}. ${item}`).join("\n");

function register(filePath, content) {
  generated.set(path.resolve(filePath), content.endsWith("\n") ? content : `${content}\n`);
}

const acceptedBaseline = [
  "Windows endpoints use a low-privilege machine Coordinator Service, one ordinary-token User Host per eligible interactive session, and short-lived restricted Task Hosts for risky collection.",
  "The Coordinator does not crawl user profiles or create user tokens. User-owned sources are read in the user's session. Task Hosts are process boundaries, not arbitrary plugin or script channels.",
  "C#/.NET is the accepted default implementation family. Exact supported patches and fast-moving libraries are selected at execution time under lifecycle policy.",
  "A release-authorized product privacy ceiling limits sources, fields, transformations, destinations, and capabilities. Tenant policy may only narrow it.",
  "Minimization occurs before Coordinator IPC, durable storage, logs, diagnostics, or transport. Endpoints never receive central database credentials or submit SQL.",
  "SQLite WAL with one writer stores minimized events and source progress atomically. Delivery is at least once; stable identities and central uniqueness make the business effect idempotent.",
  "Uploads are bounded, versioned, authenticated, compressed HTTPS batches. A server receipt means durable custody, not necessarily semantic acceptance or portal visibility.",
  "The initial server design is a modular monolith with an ingestion boundary, relational durable inbox, leased workers, typed facts/aggregates, control API/BFF, and integrations through governed contracts.",
  "No external broker is a default. Add one only after measured failure-domain, throughput, replay, fan-out, or cost conditions justify it.",
  "PostgreSQL is the target reference and SQL Server is a serious transition/fallback candidate; the production engine is selected by an identical benchmark plus operations, skills, licensing, and restore evidence.",
  "MSI and enterprise deployment own the stable privileged boundary. Any autonomous updater is optional, minimal, repository-authorized, rollback-safe, and separately justified.",
  "The first functional slice is Edge browser history at site/domain-level minimized output, using synthetic data until governance permits otherwise.",
  "UAM telemetry is fallible operational evidence, not sole forensic proof or an employee-productivity score.",
  "Legal purpose, prohibited uses, identity level, retention, access, employee consultation, budget, SLO/RPO/RTO, ownership, and production approval remain human decisions.",
];

const provisionalMatters = [
  "Exact event fields, identity/time precision, first-run lookback, hard-deny categories, role-to-application mapping, and production retention.",
  "Exact SQLite limits, encryption/key-wrapping choice, batch limits, retry values, resource budgets, and ACK replay grace.",
  "Device PKI integration, TPM coverage, proxy/VPN behavior, autonomous updater need, and extended Windows/VDI/platform support.",
  "Production database engine, partition/index design, SLOs, capacity, broker need, portal technology details, and audit storage technology.",
  "All exact point-in-time dependency versions. Research must verify current supported releases and cite the reviewed versions without hardening patch numbers into timeless architecture.",
];

const evidenceLabels = `Use these labels consistently:\n\n- **FACT** — directly supported by supplied evidence or a current primary source.\n- **ASSUMPTION** — supplied or inferred but not proven.\n- **INFERENCE** — reasoned from facts; explain the chain.\n- **ESTIMATE** — numerical hypothesis with replaceable inputs.\n- **RECOMMENDATION** — proposed decision with alternatives and trade-offs.\n- **UNKNOWN** — missing evidence.\n- **HUMAN DECISION** — policy, legal, ownership, budget, risk, or business authority.\n- **CLI EXPERIMENT** — must be established by code, lab work, or measurement.\n\nDo not use invented numerical confidence percentages. Give High/Medium/Low confidence per major conclusion, state why, and name the evidence that would change it. If you conflict with the accepted baseline, create an explicit change proposal: affected decision, new evidence, impact, smallest falsifying experiment, migration consequence, and ADR action. Do not silently redesign adjacent components. Never call the result “bulletproof”; state residual risk and containment.`;

const primarySourceRules = `Verify time-sensitive claims as of the research date. Prefer official specifications, standards, Microsoft/.NET/Windows documentation, browser and database source/documentation, RFCs, regulator publications, maintained source repositories, and original engineering publications. Cite direct, stable links and record document/release dates and versions. Vendor marketing, search snippets, popularity, and synthetic benchmarks are not proof. Clearly distinguish documented capability from UAM-specific fitness.`;

function openSourceSection(topic) {
  return `Actively search GitHub and official open-source sources for ${topic.oss.join(", ")}. For every repository used, report:\n\n- repository URL and relevant files/directories;\n- exact tag, release, or commit reviewed, preferably with stable permalinks;\n- license and compatibility concerns;\n- recent maintenance and release activity;\n- testing quality and security posture;\n- architectural similarities and threat-model differences;\n- reusable ideas and ideas that must not be copied;\n- suitability as a dependency, reference only, or neither.\n\nPopularity alone is not evidence. Do not recommend copying an architecture without fit, maintenance, licensing, testing, and security analysis.`;
}

function priorBatchReviewNames(batchId) {
  return batches.filter((batch) => batch.id < batchId).map((batch) => `batch-${pad(batch.id)}-review-result.md`);
}

function priorBatchReviewPaths(batchId) {
  return batches.filter((batch) => batch.id < batchId).map((batch) => path.join(resultRoot, batch.slug, `batch-${pad(batch.id)}-review-result.md`));
}

const topicDependencyPlan = new Map([
  ...[1, 2, 3, 4, 5, 6].map((id) => [id, { batchReviews: [], topicResults: [] }]),
  ...[7, 8].map((id) => [id, { batchReviews: [1], topicResults: [] }]),
  ...[9, 10, 14].map((id) => [id, { batchReviews: [1, 2], topicResults: [] }]),
  ...[11, 12, 13].map((id) => [id, { batchReviews: [1], topicResults: [] }]),
  ...[15, 16, 17, 18].map((id) => [id, { batchReviews: [1, 2, 3], topicResults: [] }]),
  ...[19, 20, 21].map((id) => [id, { batchReviews: [1, 2, 3, 4], topicResults: [] }]),
  [22, { batchReviews: [1], topicResults: [] }],
  [23, { batchReviews: [1, 2, 3, 4], topicResults: [22] }],
  [24, { batchReviews: [1, 2, 3, 4, 5], topicResults: [22, 23] }],
]);

function batchReviewPath(batchId) {
  const batch = batches.find((item) => item.id === batchId);
  return path.join(resultRoot, batch.slug, `batch-${pad(batch.id)}-review-result.md`);
}

function topicResultPath(topicId) {
  const topic = topics.find((item) => item.id === topicId);
  const batch = batches.find((item) => item.id === topic.batch);
  return path.join(resultRoot, batch.slug, `${pad(topic.id)}-${topic.slug}-result.md`);
}

function topicDependencyPaths(topic) {
  const dependency = topicDependencyPlan.get(topic.id);
  if (!dependency) throw new Error(`Missing dependency plan for topic ${topic.id}`);
  return [
    ...dependency.batchReviews.map(batchReviewPath),
    ...dependency.topicResults.map(topicResultPath),
  ];
}

function topicDependencyNames(topic) {
  return topicDependencyPaths(topic).map((file) => path.basename(file));
}

function topicPrompt(topic) {
  const batch = batches.find((item) => item.id === topic.batch);
  const resultPath = `results/${batch.slug}/${pad(topic.id)}-${topic.slug}-result.md`;
  const allowedFiles = [...topic.attachments, ...topicDependencyNames(topic)].map((name) => `- \`${name}\``).join("\n");
  return `# Prompt ${pad(topic.id)} — ${topic.title}

## Expert role

You are a ${topic.role}. Produce a decision-ready, implementation-level research result for the next-generation UAM project. Use easy, precise language, but retain expert technical depth.

## Result target

Save the complete response as \`${resultPath}\`.

## Attachments

### Project-file allowlist

The ChatGPT Project may contain all suite attachments. For this chat, you are allowed to read exactly these project files:

${allowedFiles}

Do not open, search, quote, summarize, or use any other Project file, even if it appears relevant. A file being present in the Project is not permission to use it. If an allowed file is missing, report the missing filename instead of substituting another file.

Batch-review results in this allowlist are accepted predecessor decisions. Explicitly listed topic results are required same-stream evidence that has not yet passed its eventual batch reviewer. Treat accepted reviews as stronger project context than the original shared baseline, keep unreviewed topic conclusions provisional, and report conflicts explicitly.

Treat attachments according to their classification and limitations. Do not reproduce internal evidence unnecessarily. Do not request raw SSH configuration, credentials, internal addresses, personal data, production activity, or confidential reference data.

## Project context

UAM is replacing a monolithic PowerShell Windows endpoint activity-monitoring system. It must safely support at least 6,000 managed endpoints, offline operation, strict endpoint-side minimization, recoverable releases, tenant/realm isolation, auditable administration, and staged migration. The research baseline is dated July 2026; current platform facts must be freshly verified.

This prompt belongs to **${batch.title}**. ${batch.timing}

## Accepted baseline

The following decisions are accepted unless new primary evidence proves a material problem:

${bullets(acceptedBaseline)}

## Provisional matters

Do not turn these into facts without evidence:

${bullets(provisionalMatters)}

## Research questions

${numbered(topic.questions)}

Include threat modelling, secure coding/review, configuration ownership, feature flags and kill switches, error taxonomy, privacy-safe observability and metric-cardinality limits, incident response, support ownership/runbooks, cost/licensing/skills/operations, realm isolation, data quality, accessibility where relevant, and architecture fitness functions. Cover them in this topic's scope rather than redesigning the whole platform.

## Constraints

- Windows is the endpoint platform; user/session boundaries are security and privacy boundaries.
- Use synthetic or sanitized evidence only. Never propose uploading internal URLs, addresses, credentials, SSH material, personal information, raw production activity, or confidential reference data.
- Prefer the simplest design that satisfies measured requirements and failure containment.
- Do not invent organizational roles, purposes, legal conclusions, retention, SLOs, budgets, or production volumes.
- Define failure, detection, containment, recovery, cleanup, and evidence—not only the happy path.
- Convert unprovable recommendations into bounded CLI experiments with pass/fail gates.

## Required web verification

${primarySourceRules}

## Open-source reference review

${openSourceSection(topic)}

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

${bullets(topic.deliverables)}

Avoid general advice. Give enough detail that the accepted result can be converted into repository tasks and tests without guessing at the architecture.

## Human decisions

Research must not decide:

${bullets(topic.human)}

For each, give options, consequences, a conservative temporary default if safe, and the accountable role—but do not claim approval.

## CLI evidence and experiments

The CLI/lab lane must establish:

${bullets(topic.cli)}

Primary gate: **${topic.gate}**

## Evidence labels and conflict handling

${evidenceLabels}

## Residual risk

End with what remains unsafe, uncertain, operationally costly, dependent on humans, or impossible to prove through research alone. State the next stop/go gate explicitly.
`;
}

function lessonsDocument() {
  return `# Lessons from the previous research suite

## What worked

- Adversarial expert roles prevented automatic agreement with the proposed design.
- Primary-source requirements produced a strong evidence base.
- Explicit alternatives, failure scenarios, acceptance gates, and a final synthesis made contradictions visible.
- The Windows feasibility result was especially useful because it required hypotheses, setup, instrumentation, pass/fail, cleanup, and environment limitations.
- Separating facts, assumptions, recommendations, unknowns, human decisions, and experiments kept the final baseline honest.

## What needs improvement

- The six broad prompts overlapped heavily on session architecture, SQLite, update security, device identity, privacy, database choice, and reliability. The implementation suite gives each decision one primary owner prompt and uses batch reviewers for cross-topic conflicts.
- The full 392 KB code attachment was costly and too broad for focused chats. The implementation suite uses small sanitized attachments and no raw code by default.
- Some answers used overly precise confidence percentages without a defensible statistical basis. New prompts require qualitative confidence plus evidence and change conditions.
- Exact patch versions and fast-moving frontend/database claims became stale quickly. New prompts require current verification and lifecycle policy, not timeless commitment to a patch number.
- Some recommendations were premature: database engine, retention periods, local caps, encryption, portal details, and capacity numbers. New prompts classify them as human decisions or CLI measurements.
- Broad prompts sometimes produced strong architecture prose but not exact schemas, message framing, state machines, transaction boundaries, compatibility rules, or recovery algorithms. Those are now mandatory.
- Open-source references lacked consistent commit, license, maintenance, test, security, and reuse assessment. Every relevant prompt now requires it.
- Research occasionally answered questions only real Windows, browser, fault, load, restore, or operations evidence can settle. New prompts explicitly convert those claims into CLI experiments.

## Applied prompt rules

1. One primary decision area per prompt; adjacent concerns are constraints, not invitations to redesign everything.
2. Every conclusion is labeled and includes its evidence basis and change trigger.
3. Every load-bearing recommendation includes failure/recovery behavior, a falsifying prototype, and acceptance criteria.
4. Human policy and legal decisions are presented as options with consequences, never silently selected.
5. Numerical values are hypotheses until measured and approved.
6. Stable interfaces and invariants are specified more strongly than replaceable technologies.
7. Batch reviewers reconcile conflicts before their results become baseline inputs.
8. Only final accepted batch decisions and real CLI evidence enter the next technical baseline.
`;
}

function baselineDocument() {
  const synthesis = path.join(repoRoot, "research-packs/results/07-final-synthesis-technical-baseline.md");
  return `# Shared accepted baseline

**Classification:** internal summary sanitized for an approved research chat.
**Source:** July 2026 final synthesis; SHA-256 \`${sha256(synthesis)}\`.
**Generation:** deterministic curated baseline produced by \`scripts/generate-implementation-research-packs.mjs\`.
**Status:** working baseline for implementation research; production authority remains gated.
**Limitation:** condensed decisions and gates, not full evidence, human approval, or runtime proof.
**Baseline date:** 31 July 2026.

## Accepted decisions

${bullets(acceptedBaseline)}

## Provisional and measurement-gated matters

${bullets(provisionalMatters)}

## Non-negotiable invariants

- A source cursor never advances ahead of the durable minimized events it represents.
- A server receipt never acknowledges data outside the declared durable failure domain.
- A retry or replay creates one final business effect.
- Forbidden source values never cross the endpoint privacy boundary or enter diagnostics.
- One user/session/realm cannot submit, view, mutate, or delete as another.
- A privileged mutation cannot succeed without durable audit evidence.
- An unauthorized, incomplete, stale, frozen, or downgraded release never executes.
- No component silently drops unacknowledged data under pressure.
- Restores neither lose acknowledged events nor make deleted data visible before readiness.

## How to challenge this baseline

Do not silently replace an accepted decision. Submit a change proposal with new primary evidence, affected invariants, alternatives, migration cost, security/privacy impact, smallest falsifying CLI experiment, and proposed ADR status.
`;
}

function sanitizedAppAttachment(profile) {
  return `# Sanitized application-catalogue report

**Classification:** internal summary sanitized for an approved research chat.
**Source:** internal CSV catalogue, profiled locally on ${profile.source.profiledOn}.
**Generation:** deterministic aggregate profiling by \`scripts/profile-application-catalogue.mjs\`.
**Source SHA-256:** \`${profile.source.sha256}\`.

## Safe structural facts

| Measure | Value |
| --- | ---: |
| Records | ${profile.structure.recordCount} |
| Unique application names, case-insensitive | ${profile.quality.uniqueApplicationNamesCaseInsensitive} |
| Missing application names | ${profile.quality.missingApplicationNames} |
| Missing external correlation IDs | ${profile.quality.missingExternalCorrelationIds} |
| Distinct non-empty external correlation IDs | ${profile.quality.distinctNonEmptyExternalCorrelationIds} |
| Duplicated non-empty ID values | ${profile.quality.duplicatedNonEmptyExternalIdValues} |
| Records sharing duplicated non-empty IDs | ${profile.quality.recordsUsingDuplicatedNonEmptyExternalIds} |
| Names containing an address-like IPv4 literal in the raw source | ${profile.quality.namesContainingIpv4Literal} |
| Names containing non-ASCII characters | ${profile.quality.namesContainingNonAsciiCharacters} |
| Names ending in a possible truncation marker | ${profile.quality.namesEndingInPossibleTruncationMarker} |

The raw values are deliberately absent. The source contains no role, organization-unit, owner, lifecycle, sensitivity, URL/domain rule, process/publisher/product rule, alias, entitlement, or observed-usage dimension. Do not infer these from names. The populated legacy correlation IDs are unique in this measured snapshot, but five are missing and no durable uniqueness contract is supplied; treat them as external references, not UAM primary keys.

## Safe use

- Use counts and quality shapes to design import validation and synthetic data.
- Use fictional application names, external references, roles, URLs, processes, owners, and realms in research examples.
- Assign UAM-owned stable IDs only through a governed import.
- Never request or reproduce the raw catalogue in a web research answer.

## Limitation

This profile proves catalogue shape and a few quality conditions only. It does not prove application ownership, business purpose, user roles, matching rules, entitlement, usage, or currentness.
`;
}

function evidenceSummary() {
  const legacy = path.join(repoRoot, "UAM-overdracht-INTERN-2026-07-23/sources/legacy/uam.redacted.ps1");
  const portal = path.join(repoRoot, "UAM-overdracht-INTERN-2026-07-23/uam-logging.ps1");
  const ddl = path.join(repoRoot, "UAM-overdracht-INTERN-2026-07-23/artifacts/database/01_legacy_uam_prod_schema.sql");
  return `# Existing-system evidence summary

**Classification:** internal summary sanitized for an approved research chat.
**Source:** committed redacted legacy agent, DEV administration app, and production-schema metadata.
**Generation:** deterministic metadata-only summary from committed sources. No source code, URLs, credentials, production values, or SSH material is copied.

## Source fingerprints

| Evidence | Size/shape | SHA-256 | What it supports | Limitation |
| --- | --- | --- | --- | --- |
| Redacted legacy endpoint agent | 4,805 lines; 53 function definitions | \`${sha256(legacy)}\` | Current orchestration, collectors, settings, checkpoints, deferred writes, SQL coupling, and error handling | One credential is redacted; runtime configuration and external consumers are absent |
| DEV PSU administration app | 1,217 lines | \`${sha256(portal)}\` | Current administrative modules, queries, settings, organization views, matches, errors, and audit | DEV differs from inspected production; it is not a secure target design |
| Production database DDL | 27 tables; 569 fields; 13 PKs; 2 FKs | \`${sha256(ddl)}\` | Physical legacy schema and weak/implicit relationship surface | DDL does not prove semantics, consumers, rates, values, or data quality |

## Proved legacy characteristics

- A monolithic PowerShell endpoint combines collection, scheduling, database access, deferred execution, recovery, and restart behavior.
- Endpoints write directly to Microsoft SQL Server and may defer executable SQL text through CSV.
- Collection is user/profile/session dependent and includes browser, Recent/Quick Access, and process families.
- Settings, user overrides, checkpoints, application matching/exclusions, errors, schedules/scripts, aggregates, and audit exist in some form.
- The administration app and schema contain customer-specific HR/directory relationships and broad mutation surfaces.

## Evidence limits

Static inspection cannot reveal every dynamic SQL path, production setting, report, manual consumer, runtime volume, external integration, or operational practice. Presence in legacy code is evidence of behavior, not approval to preserve it. The full code reference is intentionally not an automatic attachment for focused implementation research.
`;
}

function dataSummary() {
  return `# Data and schema evidence summary

**Classification:** internal summary sanitized for an approved research chat.
**Source:** committed inventory, schema metadata, data dictionary, and final synthesis.
**Generation:** deterministic manually curated summary; no production row values or internal configuration copied.

## Legacy data shape

- 27 tables and 569 fields.
- 13 primary keys, 2 physical foreign keys, and 15 indexes in the isolated documentation schema.
- Large activity/history tables exist, but row counts are snapshots—not throughput, payload, retention, or future capacity requirements.
- Many relationships to users, HR/directory data, applications, settings, schedules, and audit are implicit in code or SQL.
- Current deferred work may contain executable SQL rather than typed events.

## Target data principles

- Separate device, installation, session, subject projection, source, generation, cursor, run, event, batch, receipt, policy, application, rule revision, health, audit, deletion, and integration concepts.
- Store only minimized typed events on endpoints; event plus cursor commits atomically.
- The server derives realm/device from authenticated registration, not payload claims.
- Distinguish durably received, validated, materialized, quarantined, and visible states.
- Use stable dedupe keys and explicit provenance. Generate aggregates server-side.
- Keep HR/directory/CMDB integrations behind narrow versioned server-side contracts.

## Missing evidence

No representative event/byte/batch/retry/outage distributions, approved retention, query corpus, RPO/RTO, or production engine benchmark is available. These require metadata-only measurement, synthetic load, restore drills, owner decisions, and reproducible CLI evidence.
`;
}

function decisionAttachment() {
  const synthesis = path.join(repoRoot, "research-packs/results/07-final-synthesis-technical-baseline.md");
  return `# Accepted decisions, contradictions, and proof gates

**Classification:** internal summary sanitized for an approved research chat.
**Source:** the July 2026 final synthesis of six prior research results; SHA-256 \`${sha256(synthesis)}\`.
**Generation:** deterministic curated extract by \`scripts/generate-implementation-research-packs.mjs\`.
**Limitation:** accepted for implementation research, not unconditional production approval.

## Strong agreements

${bullets(acceptedBaseline.slice(0, 12))}

## Important resolved tensions

- PostgreSQL is a target reference; SQL Server remains a benchmark fallback and migration boundary. The production choice is not settled by prose.
- A relational durable inbox is the default acceptance boundary; an external broker is deferred to measured triggers.
- MSI/enterprise management owns the stable privileged boundary; a self-updater is optional and evidence-gated.
- Browser acquisition uses a short read-only attempt, SQLite Online Backup fallback, then defer—never a raw copy of live main/WAL/SHM files.
- Outbox limits, resource budgets, retention, partition grain, process collection, and extended platform support remain measurements or human decisions.

## Proof-gate order

1. G0 purpose/source/dummy-data contract.
2. G1 session launch, identity, and IPC isolation.
3. G2 live Edge acquisition safety.
4. G3 profile/source-generation/cursor correctness.
5. G4 privacy transformation and canary containment.
6. G5 outbox/checkpoint crash invariant.
7. Release/update authorization and rollback.
8. Device identity and enterprise network compatibility.
9. Durable inbox/idempotency/poison handling.
10. Database and 6,000-device capacity evidence.
11. Disk/backpressure and long-outage behavior.
12. Deletion, restore, acknowledged replay, and extended Windows fidelity.

A failed early gate stops dependent work and opens an ADR change; passing proves only the stated claim.
`;
}

function researchRulesAttachment() {
  return `# Research evidence rules

**Classification:** safe research instructions; contains no source values.
**Source:** lessons from the previous UAM research suite and current package requirements.
**Generation:** deterministic text from \`scripts/generate-implementation-research-packs.mjs\`.
**Limitation:** governs research quality; it is not evidence that any technical claim is true.

${evidenceLabels}

## Source quality

${primarySourceRules}

## Boundaries

- Research cannot approve purpose, legal basis, prohibited uses, identity level, retention, access, budget, SLO/RPO/RTO, ownership, staffing, or production deployment.
- Research cannot prove Windows/browser behavior, durability, performance, capacity, restore, supportability, or operational competence without a CLI/lab experiment.
- Internal source names, addresses, credentials, personal data, raw activity, confidential configuration, and SSH material must not appear in research packages or answers.
- Open-source references are evidence and design input, not automatic dependencies.
`;
}

function labAttachment() {
  return `# Sanitized Windows lab capability summary

**Classification:** internal capability statement sanitized for an approved research chat.
**Source:** local inspection of the ignored \`.ssh\` directory on 31 July 2026.
**Generation:** manual boolean capability review; no connection values, filenames, credentials, keys, users, hosts, ports, addresses, or SSH configuration copied.
**Hash:** intentionally omitted because SSH material must not enter the research evidence chain.
**Limitation:** this proves only that a lab connection path exists; it proves no Windows capability or runtime behavior.

## Known safe facts

- Terminal SSH examples for a Windows VM are available locally.
- The examples use identity-based SSH material.
- Windows/PowerShell-oriented indicators are present.
- No connection was made while producing the research suite.

## What is not established

OS edition/build, architecture, domain state, installed runtimes, Edge version, RDP/RDS/FSLogix/Citrix, TPM, proxy/VPN, EDR, sleep modes, permissions, and available test users remain unknown until an approved read-only lab inventory runs.

## Research instruction

Design commands and experiments using placeholders only. Never ask for or reproduce the actual SSH command, user, host, address, port, identity path, key, or configuration. CLI evidence must redact connection details before it is attached to a future research chat.
`;
}

function evidenceMapDocument() {
  return `# Evidence and attachment map

| Attachment | Classification | Source/generation | Use | Limitation |
| --- | --- | --- | --- | --- |
| \`00-accepted-baseline-attachment.md\` | Internal sanitized | Generated from accepted synthesis decisions | Shared architecture constraints | Not production approval |
| \`01-existing-system-evidence-summary.md\` | Internal sanitized | Metadata/hashes from committed legacy sources | Legacy behavior and migration surface | No source code or runtime proof |
| \`02-sanitized-application-catalogue-report.md\` | Internal sanitized | Aggregate local profile of internal CSV | Registry/import/dummy-data shape | No names, IDs, roles, URLs, ownership, or usage |
| \`03-sanitized-windows-lab-capability.md\` | Internal sanitized | Boolean review of ignored SSH examples | Shows a Windows SSH lab can later be used | No connection or environment facts |
| \`04-data-and-schema-evidence-summary.md\` | Internal sanitized | Curated schema/inventory summary | Data-model and migration context | No values or capacity distributions |
| \`05-decisions-contradictions-and-gates.md\` | Internal sanitized | Curated final-synthesis extract | Prevents casual redesign and preserves gates | Requires review when evidence changes |
| \`06-research-evidence-rules.md\` | Safe instructions | Generated prompt rules | Labels, sources, conflicts, boundaries | No project evidence |

The older full code reference remains in the repository but is not part of the default implementation suite. A future topic-specific code excerpt requires deliberate redaction, source path/hash, classification, limitation, and validation before upload.
`;
}

function executionMapDocument() {
  const rows = batches.map((batch) => `| ${pad(batch.id)} | ${batch.title} | ${batch.timing} | ${batch.cli} | ${batch.gate} |`).join("\n");
  return `# Research and CLI execution map

| Batch | Research | Parallel timing | CLI work while research runs | Gate |
| --- | --- | --- | --- | --- |
${rows}

## Dependency handoff

After accepting each batch review, add its named result file to the ChatGPT Project. Later topic prompts include the accepted reviews they materially depend on; every later batch reviewer remains cumulative. Topics 22, 23, and 24 also form an explicit evidence chain. This is how accepted decisions flow forward; shared attachments alone are not the evolving baseline.

## Human-only decision lane

Across all batches, named humans must approve purpose, prohibited uses, field/identity scope, role ownership, retention, access, consultation/legal assessment, budget/licensing, SLO/RPO/RTO, production support, risk acceptance, migration/cutover, and decommissioning. Research supplies options and consequences; CLI supplies evidence; neither supplies authority.

## Measurement lane

Windows/session/browser behavior, SQLite fault safety, updater recovery, PKI/proxy compatibility, resource use, production rates, database performance, restore/deletion, accessibility, supportability, and migration reconciliation are established by reproducible CLI/lab evidence—not additional prose.
`;
}

function projectFileAllowlistDocument() {
  const projectAttachments = [
    "00-accepted-baseline-attachment.md",
    "01-existing-system-evidence-summary.md",
    "02-sanitized-application-catalogue-report.md",
    "03-sanitized-windows-lab-capability.md",
    "04-data-and-schema-evidence-summary.md",
    "05-decisions-contradictions-and-gates.md",
    "06-research-evidence-rules.md",
  ];
  const topicRows = topics.map((topic) => {
    const batch = batches.find((item) => item.id === topic.batch);
    const prompt = `${batch.slug}/${pad(topic.id)}-PROMPT-${topic.slug}.md`;
    const allowed = [...topic.attachments, ...topicDependencyNames(topic)];
    return `| ${pad(topic.id)} | [${topic.title}](${prompt}) | ${allowed.map((name) => `\`${name}\``).join("<br>")} |`;
  }).join("\n");
  const reviewerRows = batches.map((batch) => {
    const resultNames = topics.filter((topic) => topic.batch === batch.id).map((topic) => `\`${pad(topic.id)}-${topic.slug}-result.md\``);
    const predecessorNames = priorBatchReviewNames(batch.id).map((name) => `\`${name}\``);
    const common = ["`00-accepted-baseline-attachment.md`", "`05-decisions-contradictions-and-gates.md`", "`06-research-evidence-rules.md`"];
    return `| ${pad(batch.id)} | [Batch reviewer](${batch.slug}/90-BATCH-${pad(batch.id)}-REVIEW-PROMPT.md) | ${[...resultNames, ...predecessorNames, ...common].join("<br>")} |`;
  }).join("\n");
  const finalFiles = [...batches.map((batch) => `\`batch-${pad(batch.id)}-review-result.md\``), "`00-accepted-baseline-attachment.md`", "`06-research-evidence-rules.md`"];
  return `# ChatGPT Project files and per-chat allowlists

## One-time Project setup

Upload exactly these seven sanitized files from \`research-packs/implementation/attachments/\` to the ChatGPT Project:

${projectAttachments.map((name) => `- [\`${name}\`](attachments/${name})`).join("\n")}

Do not upload the raw application catalogue, \`.ssh\` files, the older full code reference, source files, production data, confidential SQL, or internal configuration. The prompts themselves may be pasted into their chats; they do not need to be Project attachments.

The Project contains a shared pool, but each prompt has a strict file allowlist. The web researcher must not use a Project file merely because it is available.

## Topic-chat allowlists

| Topic | Prompt | Only Project files this chat may read |
| ---: | --- | --- |
${topicRows}

## Batch-review allowlists

Before each batch review, add that batch's completed result files to the Project. Reviews from earlier batches remain available as accepted predecessor decisions. The reviewer may read only the files in its row.

| Batch | Prompt | Only Project files this reviewer may read |
| ---: | --- | --- |
${reviewerRows}

## Final-synthesis allowlist

Before final synthesis, add the six accepted batch-review results. The final chat may read only:

${finalFiles.map((name) => `- ${name}`).join("\n")}

Individual topic results are deliberately excluded: each batch reviewer is the evidence-quality boundary. Measured CLI evidence is excluded by default. If approved sanitized CLI evidence is needed, add its exact filename to the final prompt's allowlist before running it.
`;
}

function topicLaunchCard(topicId) {
  const topic = topics.find((item) => item.id === topicId);
  const batch = batches.find((item) => item.id === topic.batch);
  const dependencies = topicDependencyNames(topic);
  return `### Chat ${pad(topic.id)} — ${topic.title}

- Copy/paste prompt: [\`${pad(topic.id)}-PROMPT-${topic.slug}.md\`](../${batch.slug}/${pad(topic.id)}-PROMPT-${topic.slug}.md)
- Additional Project context beyond the seven shared attachments: ${dependencies.length ? dependencies.map((name) => `\`${name}\``).join(", ") : "none"}
- Save answer as: \`${pad(topic.id)}-${topic.slug}-result.md\`
`;
}

function reviewLaunchCard(batchId) {
  const batch = batches.find((item) => item.id === batchId);
  const ownResults = topics.filter((topic) => topic.batch === batch.id).map((topic) => `${pad(topic.id)}-${topic.slug}-result.md`);
  const dependencies = [...ownResults, ...priorBatchReviewNames(batch.id)];
  return `### Batch ${pad(batch.id)} reviewer

- Copy/paste prompt: [\`90-BATCH-${pad(batch.id)}-REVIEW-PROMPT.md\`](../${batch.slug}/90-BATCH-${pad(batch.id)}-REVIEW-PROMPT.md)
- Additional Project context beyond the seven shared attachments: ${dependencies.map((name) => `\`${name}\``).join(", ")}
- Save answer as: \`batch-${pad(batch.id)}-review-result.md\`
`;
}

function launchWaveReadme() {
  return `# Optimized research launch waves

These launch lists replace the coarse rule that every topic must wait for every earlier batch. They preserve result quality by using topic-level dependencies and cumulative batch reviewers.

## How to use each chat

1. Keep the seven sanitized shared attachments in the ChatGPT Project.
2. Add only the additional result/review files named on the launch card.
3. Open a new chat inside the Project and copy/paste the linked prompt.
4. Save the complete answer under the exact result filename.
5. Do not add an unlisted result file to a prompt's allowlist.

Batch-review results are accepted context. Individual topic results are provisional until reviewed. Topic 22 feeds 23, and both feed 24, so migration planning follows discovered evidence rather than assumptions.

## Run order from the current position

1. [Wave 1 — finish Batch 2 and start independent work](01-current-batch-02-and-independent-work.md)
2. [Wave 2 — endpoint durability and compatibility](02-after-batch-02-review.md)
3. [Wave 3 — server and platform](03-after-batch-03-review.md)
4. [Wave 4 — portal/governance plus migration comparison](04-after-batch-04-review.md)
5. [Wave 5 — cutover and migration review](05-after-batch-05-review.md)
6. [Wave 6 — final synthesis](06-final-synthesis.md)

Do not wait for Topic 23 before running the Batch 5 reviewer: they are separate parallel branches. Do wait for both the Batch 5 review and Topic 23 before starting Topic 24.
`;
}

function launchWaveDocuments() {
  return new Map([
    ["01-current-batch-02-and-independent-work.md", `# Wave 1 — current Batch 2 and independent work

## Already running

Allow chats 07 and 08 to finish. Do not restart them. They use \`batch-01-review-result.md\` as their additional accepted context.

## Start now in parallel

${[11, 12, 13, 22].map(topicLaunchCard).join("\n")}

These four topics do not depend materially on Edge acquisition or URL transformation. Their later batch reviewers will still reconcile them against the accepted Batch 2 review.

## When chats 07 and 08 finish

${reviewLaunchCard(2)}

Wave 2 may begin only after \`batch-02-review-result.md\` is saved in the Project. Chats 11–13 and 22 may continue running in parallel.
`],
    ["02-after-batch-02-review.md", `# Wave 2 — after the Batch 2 review

## Start in parallel

${[9, 10, 14].map(topicLaunchCard).join("\n")}

## Then run the Batch 3 reviewer

Wait until chats 09–14 are all complete, including early-start chats 11–13.

${reviewLaunchCard(3)}

Wave 3 begins only after \`batch-03-review-result.md\` is saved.
`],
    ["03-after-batch-03-review.md", `# Wave 3 — after the Batch 3 review

## Start in parallel

${[15, 16, 17, 18].map(topicLaunchCard).join("\n")}

## Then run the Batch 4 reviewer

${reviewLaunchCard(4)}

Wave 4 begins only after \`batch-04-review-result.md\` is saved.
`],
    ["04-after-batch-04-review.md", `# Wave 4 — after the Batch 4 review

## Start these four chats in parallel

${[19, 20, 21, 23].map(topicLaunchCard).join("\n")}

Topic 23 also requires the already completed \`22-legacy-discovery-result.md\`. If Topic 22 has not finished, start chats 19–21 now and delay only Topic 23.

## Run the Batch 5 reviewer when chats 19–21 finish

${reviewLaunchCard(5)}

The Batch 5 reviewer does not consume Topic 23, so it may run while Topic 23 is still finishing.
`],
    ["05-after-batch-05-review.md", `# Wave 5 — cutover and migration review

## Start Topic 24

This requires both \`batch-05-review-result.md\` and \`23-parallel-run-reconciliation-result.md\`.

${topicLaunchCard(24)}

## Then run the Batch 6 reviewer

Wait until Topics 22, 23, and 24 are complete.

${reviewLaunchCard(6)}

Wave 6 begins only after \`batch-06-review-result.md\` is saved.
`],
    ["06-final-synthesis.md", `# Wave 6 — final synthesis

## Start the final chat

- Copy/paste prompt: [\`99-FINAL-SYNTHESIS-PROMPT.md\`](../final-synthesis/99-FINAL-SYNTHESIS-PROMPT.md)
- Additional Project context beyond the seven shared attachments: ${batches.map((batch) => `\`batch-${pad(batch.id)}-review-result.md\``).join(", ")}
- Save answer as: \`next-generation-technical-baseline-result.md\`

The final prompt may read only the six batch-review results plus its named shared control attachments. It must not read the 24 individual topic results.
`],
  ]);
}

function batchReviewPrompt(batch, batchTopics) {
  const inputs = [
    ...batchTopics.map((topic) => `${pad(topic.id)}-${topic.slug}-result.md`),
    ...priorBatchReviewNames(batch.id),
  ].map((name) => `- \`${name}\``).join("\n");
  const resultPath = `results/${batch.slug}/batch-${pad(batch.id)}-review-result.md`;
  return `# Batch ${pad(batch.id)} reviewer — ${batch.title}

## Expert role

You are the chief architect, evidence reviewer, security reviewer, and implementation planning chair. Reconcile this batch without choosing the most confident wording or majority opinion.

## Result target

Save the complete response as \`${resultPath}\`.

## Attachments

### Project-file allowlist

The ChatGPT Project may contain every suite attachment and earlier result. For this reviewer chat, you are allowed to read exactly these project files:

${inputs}
- \`00-accepted-baseline-attachment.md\`
- \`05-decisions-contradictions-and-gates.md\`
- \`06-research-evidence-rules.md\`

Do not open, search, quote, summarize, or use any other Project file, including topic results from another batch. If an allowed file is missing, report the missing filename instead of substituting another file.

Earlier batch-review results in this allowlist are accepted predecessor decisions. Preserve their accepted invariants unless stronger evidence justifies an explicit change proposal.

## Accepted baseline

${bullets(acceptedBaseline)}

## Provisional matters

${bullets(provisionalMatters)}

## Research questions

1. Which conclusions agree and are supported strongly enough to accept?
2. Which conclusions overlap, contradict, depend on stale claims, or exceed the prompt's authority?
3. Which proposed technologies or numeric values remain provisional?
4. Which missing schemas, protocols, state machines, failures, recovery paths, tests, or owners prevent implementation?
5. Which questions are human decisions and which require CLI evidence?
6. What is the smallest safe implementation sequence and stop/go gate for this batch?

## Required web verification

Do not redo all research. For load-bearing disputed or time-sensitive claims: ${primarySourceRules}

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

${batch.cli}

Batch gate: **${batch.gate}**

## Evidence labels and conflict handling

${evidenceLabels}

## Residual risk

End with unresolved risks, blocked dependencies, and the exact conditions under which this batch may update the main technical baseline.
`;
}

function finalPrompt() {
  const inputs = batches.map((batch) => `- \`batch-${pad(batch.id)}-review-result.md\``).join("\n");
  return `# Final synthesis — next-generation UAM technical baseline

## Expert role

You are the chief architect chairing the final implementation-baseline review. You are responsible for evidence quality and consistency, not for maximizing scope.

## Result target

Save the complete response as \`results/final-synthesis/next-generation-technical-baseline-result.md\`.

## Attachments

### Project-file allowlist

The ChatGPT Project may contain every suite attachment and result. For this final-synthesis chat, you are allowed to read exactly these project files:

${inputs}
- \`00-accepted-baseline-attachment.md\`
- \`06-research-evidence-rules.md\`

Do not open, search, quote, summarize, or use any other Project file, including individual topic results. Optional measured CLI evidence is forbidden by default. Before running this prompt, a human may add exact sanitized CLI-evidence filenames to this allowlist; only those explicitly added files then become readable. If an allowed file is missing, report the missing filename instead of substituting another file.

Do not accept a claim merely because it appears in more than one chat.

## Accepted baseline

${bullets(acceptedBaseline)}

## Provisional matters

${bullets(provisionalMatters)}

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

${evidenceLabels}

## Residual risk

Never claim completeness or bulletproof safety. End with risks that remain even after all planned controls and the exact next gate that can invalidate the plan.
`;
}

const profilePath = path.join(packageRoot, "source-profiles/application-catalogue-profile.json");
if (!fs.existsSync(profilePath)) throw new Error(`Missing sanitized source profile: ${profilePath}`);
const appProfile = JSON.parse(fs.readFileSync(profilePath, "utf8"));

register(path.join(packageRoot, "00-lessons-from-previous-research.md"), lessonsDocument());
register(path.join(packageRoot, "00-shared-accepted-baseline.md"), baselineDocument());
register(path.join(packageRoot, "00-evidence-and-attachment-map.md"), evidenceMapDocument());
register(path.join(packageRoot, "00-research-and-cli-execution-map.md"), executionMapDocument());
register(path.join(packageRoot, "00-chatgpt-project-file-allowlists.md"), projectFileAllowlistDocument());
register(path.join(packageRoot, "execution-waves/README.md"), launchWaveReadme());
for (const [name, content] of launchWaveDocuments()) register(path.join(packageRoot, "execution-waves", name), content);
register(path.join(attachmentRoot, "00-accepted-baseline-attachment.md"), baselineDocument());
register(path.join(attachmentRoot, "01-existing-system-evidence-summary.md"), evidenceSummary());
register(path.join(attachmentRoot, "02-sanitized-application-catalogue-report.md"), sanitizedAppAttachment(appProfile));
register(path.join(attachmentRoot, "03-sanitized-windows-lab-capability.md"), labAttachment());
register(path.join(attachmentRoot, "04-data-and-schema-evidence-summary.md"), dataSummary());
register(path.join(attachmentRoot, "05-decisions-contradictions-and-gates.md"), decisionAttachment());
register(path.join(attachmentRoot, "06-research-evidence-rules.md"), researchRulesAttachment());

for (const topic of topics) {
  const batch = batches.find((item) => item.id === topic.batch);
  const promptPath = path.join(packageRoot, batch.slug, `${pad(topic.id)}-PROMPT-${topic.slug}.md`);
  const resultRelative = `${batch.slug}/${pad(topic.id)}-${topic.slug}-result.md`;
  const resultPath = path.join(resultRoot, resultRelative);
  register(promptPath, topicPrompt(topic));
  manifestPrompts.push({ kind: "topic", topicId: topic.id, batchId: topic.batch, prompt: rel(promptPath), result: rel(resultPath), attachments: topic.attachments.map((name) => rel(path.join(attachmentRoot, name))), consumes: topicDependencyPaths(topic).map(rel) });
}

for (const batch of batches) {
  const batchTopics = topics.filter((topic) => topic.batch === batch.id);
  const promptPath = path.join(packageRoot, batch.slug, `90-BATCH-${pad(batch.id)}-REVIEW-PROMPT.md`);
  const resultPath = path.join(resultRoot, batch.slug, `batch-${pad(batch.id)}-review-result.md`);
  register(promptPath, batchReviewPrompt(batch, batchTopics));
  manifestPrompts.push({ kind: "batch-review", batchId: batch.id, prompt: rel(promptPath), result: rel(resultPath), attachments: ["00-accepted-baseline-attachment.md", "05-decisions-contradictions-and-gates.md", "06-research-evidence-rules.md"].map((name) => rel(path.join(attachmentRoot, name))), consumes: [...batchTopics.map((topic) => path.join(resultRoot, batch.slug, `${pad(topic.id)}-${topic.slug}-result.md`)), ...priorBatchReviewPaths(batch.id)].map(rel) });
}

const finalPromptPath = path.join(packageRoot, "final-synthesis/99-FINAL-SYNTHESIS-PROMPT.md");
const finalResultPath = path.join(resultRoot, "final-synthesis/next-generation-technical-baseline-result.md");
register(finalPromptPath, finalPrompt());
manifestPrompts.push({ kind: "final-synthesis", prompt: rel(finalPromptPath), result: rel(finalResultPath), attachments: [rel(path.join(attachmentRoot, "00-accepted-baseline-attachment.md")), rel(path.join(attachmentRoot, "06-research-evidence-rules.md"))], consumes: batches.map((batch) => rel(path.join(resultRoot, batch.slug, `batch-${pad(batch.id)}-review-result.md`))) });

const promptRows = topics.map((topic) => {
  const batch = batches.find((item) => item.id === topic.batch);
  const prompt = `${batch.slug}/${pad(topic.id)}-PROMPT-${topic.slug}.md`;
  const result = `results/${batch.slug}/${pad(topic.id)}-${topic.slug}-result.md`;
  return `| ${pad(topic.id)} | ${batch.id} | [${topic.title}](${prompt}) | \`${result}\` |`;
}).join("\n");

const firstBatchPrompts = topics.filter((topic) => topic.batch === 1).map((topic) => `- [${pad(topic.id)} — ${topic.title}](batch-01-foundations/${pad(topic.id)}-PROMPT-${topic.slug}.md)`).join("\n");

const readme = `# Next-generation UAM implementation research suite

This suite turns the July 2026 technical baseline into focused implementation research. It contains 24 topic prompts, six batch reviewers, one final synthesis, safe generated attachments, matching result targets, and automated validation.

## Current optimized launch order

Use the [optimized execution-wave README](execution-waves/README.md). It starts from the current position where Batch 2 research is nearly complete and safely overlaps independent Topics 11, 12, 13, and 22.

## First batch to run

Run these six chats in parallel, then run \`batch-01-foundations/90-BATCH-01-REVIEW-PROMPT.md\`:

${firstBatchPrompts}

While they run, the CLI may profile evidence, prepare ADR/specification directories, prepare fictional seeds/canaries, inspect harmless Windows lab facts later under approval, and strengthen CI. Do not implement G1 identity/IPC security details until the batch review accepts them.

## Prompt index

| Topic | Batch | Prompt | Result target |
| ---: | ---: | --- | --- |
${promptRows}

## Batch review and final sequence

${batches.map((batch) => `- Batch ${pad(batch.id)}: run \`${batch.slug}/90-BATCH-${pad(batch.id)}-REVIEW-PROMPT.md\` after its topic results; save to \`results/${batch.slug}/batch-${pad(batch.id)}-review-result.md\`.`).join("\n")}
- Final: attach all six accepted batch-review results and run [the final synthesis](final-synthesis/99-FINAL-SYNTHESIS-PROMPT.md); save to \`results/final-synthesis/next-generation-technical-baseline-result.md\`.

## Attachments

For the one-time ChatGPT Project setup, upload the seven files listed in the [Project file and per-chat allowlist](00-chatgpt-project-file-allowlists.md). Every prompt contains a strict allowlist telling the web researcher which of those shared Project files it may read. A file being present in the Project is not permission to use it.

Do not upload the older full code reference, raw application catalogue, SSH files, internal configuration, production data, confidential SQL, or confidential reference data.

## Operating rules

1. Use a fresh Pro research chat per topic.
2. Save the complete result at the named target.
3. Run one batch reviewer only after all results in that batch are present.
4. Add each accepted batch-review result to the Project before starting the next batch; later prompt allowlists name it explicitly.
5. Convert accepted findings into ADRs/specifications and validate them through CLI experiments.
6. Feed measured evidence to later reviewers; do not replace it with online claims.
7. Research supplies options and evidence. Humans approve policy/risk/business decisions. CLI/lab work proves behavior and performance.

See [Project file allowlists](00-chatgpt-project-file-allowlists.md), [lessons](00-lessons-from-previous-research.md), [accepted baseline](00-shared-accepted-baseline.md), [evidence map](00-evidence-and-attachment-map.md), and [execution map](00-research-and-cli-execution-map.md).
`;
register(path.join(packageRoot, "README.md"), readme);

const manifest = {
  schemaVersion: 1,
  generatedOn: "2026-07-31",
  topicCount: topics.length,
  batchCount: batches.length,
  promptCount: manifestPrompts.length,
  generatedFiles: [...generated.keys()].map(rel).sort(),
  prompts: manifestPrompts,
};
register(path.join(packageRoot, "manifest.json"), `${JSON.stringify(manifest, null, 2)}\n`);

let failures = 0;
for (const [filePath, content] of generated) {
  if (checkOnly) {
    if (!fs.existsSync(filePath) || fs.readFileSync(filePath, "utf8") !== content) {
      console.error(`Generated file is missing or stale: ${rel(filePath)}`);
      failures += 1;
    }
  } else {
    fs.mkdirSync(path.dirname(filePath), { recursive: true });
    fs.writeFileSync(filePath, content, "utf8");
  }
}

if (!checkOnly) {
  for (const entry of manifestPrompts) {
    const resultPath = path.join(repoRoot, entry.result);
    if (!fs.existsSync(resultPath)) {
      fs.mkdirSync(path.dirname(resultPath), { recursive: true });
      fs.writeFileSync(resultPath, "", "utf8");
    }
  }
  console.log(`Generated ${generated.size} package files and ensured ${manifestPrompts.length} result targets.`);
} else if (failures) {
  process.exitCode = 1;
} else {
  console.log(`All ${generated.size} generated package files are current.`);
}
