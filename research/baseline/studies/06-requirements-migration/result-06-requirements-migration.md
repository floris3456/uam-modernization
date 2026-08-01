# UAM requirements, acceptance, and migration framework

**Prepared:** 30 July 2026  
**Scope:** Replacement of the legacy UAM endpoint agent, ingestion path, data model, administration portal, operational processes, and retained legacy estate.

## Decision status and governing defaults

The supplied reference explicitly says that static code and schema are evidence of current behaviour, not an approved or secure specification, and that runtime configuration, external consumers, and dynamic SQL may not be visible.

This framework therefore preserves **approved outcomes**, not automatically the old implementation, table layout, privilege model, field set, or administrative authority. Requirements are written to be traceable, feasible, and objectively verifiable, following the requirements-quality principles described by NASA. ([NASA](https://www.nasa.gov/reference/4-2-technical-requirements-definition/ "https://www.nasa.gov/reference/4-2-technical-requirements-definition/"))

Throughout this document:

| Marking               | Meaning                                                                                                  |
| --------------------- | -------------------------------------------------------------------------------------------------------- |
| **Decision question** | Code and schema cannot answer this. A named owner must decide.                                           |
| **Proposed default**  | Temporary conservative behaviour until the owner decides. It is not itself a business or legal decision. |
| **Consequence**       | What the default prevents, omits, or changes.                                                            |
| **P0**                | Required before any live pilot that processes employee or user data.                                     |
| **P1**                | Required before rollout beyond the controlled pilot population.                                          |
| **P2**                | Required before decommissioning, or a planned later improvement.                                         |

The conservative defaults are:

| Area                           | Proposed default pending decision                                                                              |
| ------------------------------ | -------------------------------------------------------------------------------------------------------------- |
| Collection scope               | Do not collect a field or source unless its purpose and owner are recorded.                                    |
| Historical lookback            | Start at installation time; no historical backfill.                                                            |
| Browser data                   | Domain-level output only; no full URLs, query strings, fragments, or titles.                                   |
| File/process data              | No full paths unless explicitly approved; prefer approved application/category identifiers.                    |
| Unknown rules or configuration | Import as disabled drafts or quarantine them.                                                                  |
| Scripts and schedules          | Archive for review, but never execute automatically.                                                           |
| Credentials and permissions    | Do not migrate endpoint database credentials, service secrets, roles, or inherited administrative rights.      |
| Checkpoints                    | Advance only after the corresponding accepted events and aggregates are durably committed.                     |
| Parallel operation             | Do not create a second unrestricted detail-data store merely for comparison.                                   |
| Legacy authority               | Move the legacy portal to read-only after cutover; do not leave legacy mutation functions active indefinitely. |

Privacy and legal owners must determine applicable purposes, legal basis, transparency, employee consultation, rights handling, retention, and whether a data-protection impact assessment is required. The technical default should nevertheless enforce data minimisation, protection by design/default, and security proportionate to risk. Article 35 assessment is triggered under the GDPR where processing is likely to present high risk; whether that threshold is met here is a decision for the responsible privacy/legal function, not an inference from the code. ([EUR-Lex](https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX%3A02016R0679-20160504 "https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX%3A02016R0679-20160504"))

## Decision method: preserve, redesign, retire, or investigate

Every discovered legacy behaviour should receive a decision record containing the evidence, business purpose, consumers, data fields, decision owner, disposition, acceptance test, migration action, and rollback action.

| Gate            | Question                                                                                                                      | Result when unanswered                         |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------- |
| Purpose         | What approved outcome does this behaviour support?                                                                            | **Investigate; disabled.**                     |
| Consumer        | Which named report, team, integration, or operational process uses it?                                                        | **Investigate; do not migrate automatically.** |
| Necessity       | Is each field required for that outcome, or can less detailed data work?                                                      | **Use the least detailed form.**               |
| Authority       | Who may collect, view, export, configure, delete, or execute it?                                                              | **No access or execution until assigned.**     |
| Correctness     | Are semantics known, including identity, time, checkpoint, matching, and aggregation rules?                                   | **Quarantine or retain read-only.**            |
| Safety          | Can it be implemented without endpoint database credentials, arbitrary code, excessive privilege, or silent policy expansion? | **Redesign.**                                  |
| Verifiability   | Is there an objective acceptance test and migration reconciliation?                                                           | **Not Ready.**                                 |
| Continued value | Is the outcome still required after redesign, or is it duplicated elsewhere?                                                  | **Retire with owner approval.**                |

**Preserve** means preserve an approved externally observable outcome.  
**Deliberately change** means the outcome remains useful but its semantics or implementation must change.  
**Retire** means no approved purpose or consumer remains.  
**Investigate** means evidence is insufficient; the safe default is off, read-only, or quarantined.

### Legacy evidence key used below

| Code    | Evidence                                                                                                                                                                                 |
| ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **L0**  | The source itself says static inspection is incomplete and behaviour must not be treated as a secure specification.                                                                      |
| **L1**  | Browser, Recent, and Process events use source-specific checkpoints; checkpoint updates are assembled with event/minimal writes and deferred for later database execution.               |
| **L2**  | “Minimal” rows remain linked to username/domain and distinct domains, file paths, or process paths, with per-day usage rows.                                                             |
| **L3**  | Settings combine global typed string values, user/device-row properties, and later-applied user overrides.                                                                               |
| **L4**  | Failed work can be held as executable SQL in memory or CSV, recovered on restart, and cleared after execution; a failure path can also delete a buffer during restart handling.          |
| **L5**  | The endpoint reads or creates a locally protected central database connection string using application-embedded key material and supports passing a connection string at startup.        |
| **L6**  | Browser and process exclusions use wildcard expression matching; the portal can derive exclusions or application-match entries from observed data.                                       |
| **L7**  | The portal contains logging-user controls, telemetry views, settings, exclusions, application matches, device types, scripts, schedules, HR/organization views, errors, and audit views. |
| **L8**  | Error records can contain user/device identifiers, messages, script locations, command lines, call stacks, settings, and Windows information; the portal exposes recent errors.          |
| **L9**  | The agent can execute centrally supplied PowerShell through expression evaluation, while the schema and portal also support scripts and schedules.                                       |
| **L10** | Legacy enrolment and identity semantics combine AD-group-derived enablement, user/device records, and special handling for non-persistent devices.                                       |

---

# 1. Stakeholder and decision-owner map

Actual organizational names must replace these proposed roles before requirements are baselined.

| Stakeholder / proposed accountable role                                     | Decisions owned                                                                                                       | Decisions code cannot answer                                                     | Required sign-off                                               |
| --------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| **Executive sponsor / service authority**                                   | Whether UAM should exist, funding, accepted organizational risk, ultimate service ownership                           | Whether the benefits justify monitoring and operational costs                    | Business case; production authorization; final decommission     |
| **Product owner**                                                           | Product outcomes, supported workflows, feature priorities, report compatibility                                       | Which legacy portal functions and reports remain necessary                       | Requirements baseline; disposition matrix; release acceptance   |
| **Business data owner / controller representative — legal role to confirm** | Permitted purposes and use of collected information                                                                   | Why each signal is needed and which decisions may be made from it                | Purpose and use-case register                                   |
| **Privacy, legal, and DPO function**                                        | Lawful-basis assessment, minimisation, notice, rights, retention, DPIA assessment, employee consultation requirements | Whether URL/path/process telemetry and user linkage are permissible              | Privacy acceptance for each data class and pilot phase          |
| **Security authority / CISO delegate**                                      | Threat acceptance, authentication, signing, secrets, incident thresholds                                              | Acceptable residual endpoint, supply-chain, and administrative risk              | Threat model; security architecture; production risk acceptance |
| **Endpoint engineering owner**                                              | Service/session architecture, collectors, outbox, updater, device resource limits                                     | Which endpoint edge cases are business-critical                                  | Agent acceptance and rollback readiness                         |
| **Platform/SRE owner**                                                      | API, queue, workers, database, backup, restore, capacity, SLO implementation                                          | Business tolerance for ingestion delay or temporary unavailability               | Operational acceptance and capacity test                        |
| **Data/reporting owner**                                                    | Metric definitions, transformations, historical comparability, downstream contracts                                   | Whether legacy “minimal” semantics remain useful or should be changed            | Data contract and comparison acceptance                         |
| **Portal product/IAM owner**                                                | Portal features, capability model, identity provider integration, administrative workflows                            | Who should have which capability and which actions need approval                 | RBAC matrix and access-review process                           |
| **AD/device-management owner**                                              | Device identity, managed certificates, deployment groups, eligibility group integration                               | Whether AD membership remains an eligibility input or an authorization mechanism | Device enrolment and rollout design                             |
| **HR source-system owner**                                                  | Approved HR attributes, authoritative identifiers, freshness, correction                                              | Whether HR data may be copied or should only be referenced                       | HR interface contract                                           |
| **Records-management owner**                                                | Retention schedule, archive status, deletion evidence, legal-hold process                                             | Exact retention periods and archive ownership                                    | Retention and disposal schedule                                 |
| **Operations/change manager**                                               | Release windows, ring progression, change records, emergency changes                                                  | Acceptable automatic rollback limits                                             | Rollout authorization                                           |
| **Service desk and support owner**                                          | Support model, severities, support hours, diagnostic handling                                                         | Which symptoms users report and what support information is necessary            | Support readiness and handover                                  |
| **Representative users and, where applicable, employee representation**     | Consultation input, usability feedback, observed endpoint impact                                                      | Whether notices and support routes are understandable and workable               | Pilot feedback; consultation record where required              |
| **Internal audit/compliance**                                               | Evidence expectations and control testing                                                                             | What evidence must be retained for independent review                            | Audit-evidence acceptance                                       |

### Decisions that must not be inferred from code

The following are formal open decisions:

1. The approved purpose for browser, recent-item, process, extension, HR, and organization data.

2. Whether full URLs, file paths, executable paths, titles, or only coarser identifiers are necessary.

3. Whether identity must be person-level, account-level, device-level, pseudonymous, or aggregated.

4. Initial history lookback for each source.

5. Detail, aggregate, error, audit, migration-staging, and backup retention.

6. Who may enable collection, create exceptions, inspect detail, export data, run tasks, or delete records.

7. Whether an AD group is merely an eligibility source or grants collection authority.

8. The intended semantics of “application match.”

9. Whether arbitrary or customer-authored scripts remain in scope.

10. Reporting tolerances, service objectives, support hours, and recovery objectives.

11. Whether and how data-subject access, correction, objection, restriction, or deletion processes apply.

12. Whether a DPIA, employee notice, or consultation process is required.

---

# 2. Requirement catalogue

## Functional requirements

| ID         | Requirement and rationale                                                                                                                                                                                                                                                                                                          | Evidence | Priority | Acceptance test                                                                                                                                                                                              | Owner to confirm      |
| ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------- |
| **FUN-01** | Each collector shall be independently enabled, scheduled, versioned, stopped, and health-scored. A fault in one collector shall not stop other approved collectors.                                                                                                                                                                | L1       | P0       | Inject an exception, timeout, corrupt source, and schema mismatch into each collector. Other collectors continue; the faulty collector reports a bounded error and stops according to policy.                | PO, Endpoint          |
| **FUN-02** | The product shall maintain a field-level catalogue for Browser, Recent, Process, and future Extension events. No field may enter the outbox unless listed in an approved schema and purpose record.                                                                                                                                | L0, L1   | P0       | Automated contract test rejects an extra synthetic field. Schema report links every accepted field to purpose, retention class, and owner.                                                                   | PO, Privacy, Data     |
| **FUN-03** | Browser History shall explicitly define supported browsers, user profiles, profile identity, private/incognito exclusions, and multiple-profile behaviour.                                                                                                                                                                         | L1       | P0       | Fixtures cover Edge, Chrome, Firefox, two profiles, no profile, locked database, WAL files, corrupt database, and browser update. Results identify the correct user/profile and never cross user boundaries. | PO, Endpoint, Privacy |
| **FUN-04** | Detailed and minimized outputs shall be separate policy modes with separate schemas, access, and retention. “Minimal” shall not be labelled anonymous merely because fewer rows or fields are produced.                                                                                                                            | L2       | P0       | Run identical fixtures in both modes. The minimized output contains only approved fields and portal labels accurately describe its person-level or aggregate nature.                                         | PO, Privacy, Data     |
| **FUN-05** | Each source/profile shall have an explicit initial-lookback and checkpoint policy. **Decision question:** how far back may first installation scan? **Proposed default:** installation time, with Process always starting “now.” **Consequence:** older activity is not imported.                                                  | L1       | P0       | First-run tests for no checkpoint, valid checkpoint, future checkpoint, corrupt checkpoint, and policy-reduced lookback all produce the approved window without gaps or unauthorized backfill.               | PO, Privacy, Data     |
| **FUN-06** | Policy shall be typed, versioned, validated, and resolved deterministically across global, group, device, and user scopes. **Proposed default:** the more restrictive privacy or disable rule wins; user exceptions cannot broaden scope without separately approved capability.                                                   | L3       | P0       | Exhaustive precedence tests cover conflicting scopes, duplicate overrides, expired policy, unknown setting, rollback, and unsupported agent version. Effective-policy explanation is available per endpoint. | PO, Privacy, Endpoint |
| **FUN-07** | Exclusion, allowlist, and application-match evaluation shall have documented normalization, wildcard/regex semantics, case rules, AND/OR behaviour, priority, expiry, and reason.                                                                                                                                                  | L6       | P0       | Golden-rule suite compares legacy compatibility rules and new rules. Portal simulator explains each match and blocks ambiguous or invalid expressions.                                                       | PO, Privacy, Data     |
| **FUN-08** | Identity shall distinguish stable managed device, Windows user/session, browser profile, and non-persistent/shared-device cases. **Decision question:** which identifier is authoritative for reporting? **Proposed default:** device identity plus scoped user/session identity; do not infer a person solely from computer name. | L10      | P0       | Tests cover laptop, non-persistent VDI, RDP, fast user switching, shared workstation, renamed device, reimaged device, and reused computer name.                                                             | PO, AD owner, Privacy |
| **FUN-09** | Administrative bulk actions shall be idempotent, previewable, and protected by explicit confirmation and capability checks.                                                                                                                                                                                                        | L7       | P1       | Repeating the same bulk request has no additional effect; preview shows target count and policy change; unauthorized users receive no mutation capability.                                                   | Portal, Security, PO  |

## Privacy requirements

| ID         | Requirement and rationale                                                                                                                                                                                                                                                                                      | Evidence | Priority | Acceptance test                                                                                                                                                                             | Owner to confirm             |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| **PRI-01** | A processing register shall record, for every source and field, purpose, necessity, data subjects, recipients, location, retention, access roles, and deletion method.                                                                                                                                         | L0–L2    | P0       | No live policy can enable a schema whose register entry lacks approved purpose, owner, and retention.                                                                                       | Privacy, Business data owner |
| **PRI-02** | Filtering, allowlisting, URL reduction, path reduction, and redaction shall occur before an event is committed to the endpoint outbox.                                                                                                                                                                         | L2, L6   | P0       | Synthetic sensitive URLs, query strings, fragments, usernames in paths, and disallowed processes never appear in the outbox, upload payload, server logs, quarantine, or diagnostic bundle. | Privacy, Endpoint            |
| **PRI-03** | Full URL, file path, and executable path collection shall be individually gated. **Proposed default:** domain or approved application identifier only. **Consequence:** reports cannot reconstruct page-level or document-level activity.                                                                      | L1, L2   | P0       | Policy without explicit detail approval cannot serialize detailed values, even when a collector obtains them temporarily.                                                                   | PO, Privacy                  |
| **PRI-04** | Detail, minimized/person-level, aggregate, error, audit, staging, and backup data shall have separate retention and deletion rules. **Decision question:** exact periods. **Proposed default:** broad rollout is blocked until periods are approved; pilot data uses the shortest technically workable period. | L2, L8   | P0       | Time-accelerated test proves expiry, deletion propagation, backup handling, failed-deletion alerting, and auditable completion for every class.                                             | Privacy, Records, Data       |
| **PRI-05** | HR/AD attributes shall not be copied into telemetry events merely to simplify reporting. **Proposed default:** perform authorized joins on demand using stable identifiers and return only necessary columns.                                                                                                  | L7, L10  | P1       | Event schemas contain no HR profile fields. Portal role tests show users only the approved organizational attributes.                                                                       | HR owner, Privacy, Data      |
| **PRI-06** | Parallel-run, diagnostics, support, and error collection shall use minimized summaries and pseudonymous comparison identifiers. Such identifiers shall still be treated as restricted data.                                                                                                                    | L4, L8   | P0       | Comparison succeeds using counts, digests, checkpoints, and error classes. Raw detail access requires a time-limited break-glass approval and is audited.                                   | Privacy, Support, Data       |
| **PRI-07** | Privacy/legal shall record whether notice, consultation, DPIA, rights handling, and specific lawful-basis documentation are required before broad rollout. **Proposed default:** no rollout beyond controlled pilot without the assessment.                                                                    | L0       | P0       | Signed assessment links every required organizational measure to an implemented control or accepted action.                                                                                 | Privacy/Legal                |
| **PRI-08** | Portal exports, screenshots, saved searches, and APIs shall be subject to purpose, capability, masking, row limits, and audit controls.                                                                                                                                                                        | L7       | P1       | Export attempts are denied without the export capability; approved exports carry classification, requester, purpose, expiry, and audit metadata.                                            | Privacy, Portal, Security    |

## Security requirements

Secure development, signing, update, and verification work should be integrated into the development lifecycle rather than added only at release. NIST’s SSDF provides the baseline vocabulary and practice model for this. ([NIST Computer Security Resource Center](https://csrc.nist.gov/pubs/sp/800/218/final "https://csrc.nist.gov/pubs/sp/800/218/final"))

| ID         | Requirement and rationale                                                                                                                                                                                                                                                | Evidence | Priority | Acceptance test                                                                                                                                                                                         | Owner to confirm               |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| **SEC-01** | Endpoints shall never receive central database credentials or submit SQL. All endpoint communication shall use a scoped device/control API.                                                                                                                              | L4, L5   | P0       | Secret and filesystem scan finds no database connection strings or legacy key material. Network test proves endpoints cannot reach the database port.                                                   | Security, Endpoint, Platform   |
| **SEC-02** | Each managed device shall authenticate with a revocable device identity bound to the correct customer/tenant and authorized capabilities.                                                                                                                                | L10      | P0       | Stolen, expired, revoked, duplicated, wrong-tenant, and unregistered credentials are rejected and generate bounded alerts.                                                                              | Security, AD owner, Platform   |
| **SEC-03** | Uploads shall be confidential, authenticated, replay-resistant, size-limited, and bound to device, schema, batch identifier, and policy version.                                                                                                                         | L4       | P0       | Replay, tampering, decompression bomb, oversized batch, wrong tenant, and altered policy version are rejected without worker or database corruption.                                                    | Security, Platform             |
| **SEC-04** | Bootstrapper, service, taskhost, collector packages, policies, and updates shall be signed and verified before use. Anti-rollback rules shall prevent unauthorized downgrade.                                                                                            | L9       | P0       | Modified, unsigned, expired-signature, wrong-publisher, and older-than-minimum packages never execute. Emergency rollback requires an audited, signed authorization.                                    | Security, Release, Endpoint    |
| **SEC-05** | Portal authorization shall be capability-based and deny by default, separating data viewing, export, policy editing, rule approval, deployment, script approval, deletion, and audit review.                                                                             | L7       | P0       | Automated authorization matrix tests every route and API operation for each role, including direct API calls that bypass the UI.                                                                        | Security, Portal, PO           |
| **SEC-06** | All privileged actions shall create append-only audit events containing actor, capability, target, before/after digest, reason, ticket, result, and correlation ID. Sensitive full records shall not be copied into audit merely because a row changed.                  | L7, L8   | P0       | Change, bulk action, failed action, export, break-glass access, script approval, policy rollback, and deletion all produce complete audit events that ordinary admins cannot alter.                     | Audit, Security, Portal        |
| **SEC-07** | Legacy arbitrary PowerShell and script schedules shall not be migrated into an automatic execution path. Any retained task system shall use signed, reviewed, constrained packages with explicit capabilities, resource limits, output schema, target scope, and expiry. | L9       | P0       | Importing legacy code creates a disabled review item. Attempts to invoke shells, unsigned binaries, network destinations, or undeclared privileges are blocked according to the task capability policy. | Security, PO, Endpoint         |
| **SEC-08** | Signing keys, device credential issuers, API secrets, and break-glass credentials shall have named owners, protected storage, rotation, revocation, recovery, and compromise runbooks.                                                                                   | L5       | P0       | Key-compromise exercise revokes the affected trust, blocks new use, identifies exposed versions/devices, deploys replacement trust, and leaves an audit trail.                                          | Security, Platform, Operations |

## Reliability requirements

| ID         | Requirement and rationale                                                                                                                                                                                                                                | Evidence | Priority | Acceptance test                                                                                                                                                                              | Owner to confirm                  |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| **REL-01** | The endpoint shall atomically commit approved events, aggregate inputs, and collection progress to a transactional local outbox before upload.                                                                                                           | L1, L4   | P0       | Power loss and forced termination are injected at every transaction boundary. After restart, an event is either fully present with correct progress or absent with unchanged progress.       | Endpoint                          |
| **REL-02** | The server shall provide idempotent acceptance and exactly-once business effect for repeated batches.                                                                                                                                                    | L4       | P0       | Submit each batch concurrently and repeatedly before and after timeouts. Final event, aggregate, and checkpoint effects occur once.                                                          | Platform, Data                    |
| **REL-03** | A source checkpoint shall not advance past the latest event that is durably accepted or deliberately suppressed by an approved rule with recorded evaluation.                                                                                            | L1       | P0       | Inject upload failure, worker failure, database rollback, and rule change. No missing range results; checkpoint monotonicity and source coverage invariants hold.                            | Endpoint, Platform, Data          |
| **REL-04** | Retries shall use exponential backoff, jitter, server-directed backpressure, and a circuit breaker. Fleet reconnects shall be spread rather than synchronized.                                                                                           | L4       | P0       | One-hour client outage, multi-day outage, and 30-minute server outage tests show bounded request rate, no retry storm, and eventual drain within the approved recovery window.               | Endpoint, Platform                |
| **REL-05** | Outbox growth shall be bounded by approved byte and age limits with clear prioritization. **Decision question:** loss or pause behaviour at the bound. **Proposed default:** stop new collection rather than silently deleting the oldest approved data. | L4       | P0       | Fill disk and hold server offline. Agent remains healthy, emits a clear state, protects OS free space, and follows the approved overflow policy.                                             | PO, Privacy, Endpoint, Operations |
| **REL-06** | Browser collection shall read a consistent source snapshot and handle locked databases, WAL files, profile changes, source schema changes, and browser upgrades without advancing checkpoints on uncertain reads.                                        | L1       | P0       | Automated fixtures modify source and WAL during collection, remove a profile, and alter schema. The collector either returns a consistent approved result or a retryable/quarantined status. | Endpoint                          |
| **REL-07** | Poison payloads and unsupported schema versions shall be isolated per batch/device/source. Healthy batches shall continue.                                                                                                                               | L1, L8   | P0       | Malformed event, impossible timestamp, invalid encoding, and unsupported version enter quarantine with bounded metadata; workers do not loop indefinitely and unrelated partitions progress. | Platform, Data                    |
| **REL-08** | Service shutdown, sleep, reboot, user logoff, updater restart, and rollback shall preserve outbox and collection invariants.                                                                                                                             | L1, L4   | P0       | Repeated lifecycle tests at each processing stage show no lost accepted events, no checkpoint regression, and no duplicate business effect.                                                  | Endpoint, Release                 |
| **REL-09** | Event time, collection time, receipt time, and processing time shall be distinct. UTC shall be canonical; source precision and timezone conversion shall be documented.                                                                                  | L1       | P0       | DST transition, timezone change, clock skew, browser epoch formats, and future/ancient timestamps are normalized or quarantined according to policy.                                         | Data, Endpoint                    |

## Operations requirements

| ID         | Requirement and rationale                                                                                                                                                                                                                                                                              | Evidence | Priority | Acceptance test                                                                                                                                            | Owner to confirm                    |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| **OPS-01** | Fleet health shall show installed version, effective policy, last contact, collector health, source coverage, outbox bytes/age, upload status, update state, and diagnostic consent state without exposing activity detail.                                                                            | L7, L8   | P1       | Support can diagnose offline, policy, source, outbox, and update failures from metadata alone on representative cases.                                     | Operations, Support                 |
| **OPS-02** | There shall be global, tenant/customer, ring, collector, policy-version, and device kill switches. Privacy/security kill switches shall take precedence over normal scheduling.                                                                                                                        | L3, L7   | P0       | Exercise each kill switch during queued and active work. Collection and upload stop within the approved maximum and the state is auditable.                | Service owner, Security, Operations |
| **OPS-03** | Service-level indicators and objectives shall cover acceptance availability, processing latency, backlog age, fleet check-in, policy convergence, outbox age, data-quality errors, and deletion completion. **Decision question:** numeric objectives.                                                 | L4, L7   | P1       | Dashboards and alerts are tested with synthetic breaches; every alert has an owner and runbook.                                                            | Service owner, SRE                  |
| **OPS-04** | Capacity, backup, restore, and disaster-recovery tests shall cover at least 6,000 endpoints, reconnect waves, policy fan-out, database slowdown, partition rollover, and retention jobs. **Proposed engineering test:** twice measured peak load until production measurements replace the assumption. | L4       | P1       | Load report shows resource headroom, queue drain, restore time, restored data integrity, and no privacy-control bypass.                                    | SRE, Data                           |
| **OPS-05** | Incident response, operational change, privacy incident, and data-correction processes shall be rehearsed before broad rollout.                                                                                                                                                                        | L8       | P1       | Game days cover bad policy, bad update, credential compromise, queue/database outage, unauthorized field, deletion failure, and rollback.                  | Operations, Security, Privacy       |
| **OPS-06** | Policy and rule changes shall use staged validation, diff, approval, rollout ring, effective-time, expiry, and rollback.                                                                                                                                                                               | L3, L6   | P1       | A malformed or scope-expanding policy is rejected before publication; approved rollback restores the prior effective version and records affected devices. | PO, Privacy, Operations             |

Incident response should be part of ordinary risk management and operational preparation rather than a separate document that is first used during a crisis. ([NIST Computer Security Resource Center](https://csrc.nist.gov/pubs/sp/800/61/r3/final "https://csrc.nist.gov/pubs/sp/800/61/r3/final"))

## Data requirements

| ID         | Requirement and rationale                                                                                                                                                                                                        | Evidence   | Priority | Acceptance test                                                                                                                                      | Owner to confirm         |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| **DAT-01** | Event, policy, command, error, aggregate, and audit contracts shall be versioned and backward-compatible across the supported rollout window.                                                                                    | L1, L3     | P0       | Current server accepts supported old/new versions; unsupported combinations fail safely without checkpoint advancement.                              | Data, Platform, Endpoint |
| **DAT-02** | Canonical normalization shall define hostname/domain handling, URL reduction, path separators, case, Unicode, process identity, source timestamps, and null/unknown values.                                                      | L1, L2, L6 | P0       | Golden input corpus produces identical canonical values on endpoint and server; normalization-version changes create a new contract version.         | Data, Endpoint           |
| **DAT-03** | Every stored record shall retain provenance sufficient to explain collector, source/profile, event/schema version, policy version, device, processing version, and migration origin without retaining unnecessary source detail. | L1         | P0       | A sampled record can be traced to its accepted batch and effective policy; a migrated historical row is distinguishable from native new-system data. | Data, Audit              |
| **DAT-04** | The replacement for legacy “minimal” logging shall have a formally approved semantic definition. **Proposed default:** call the old construct “per-user daily distinct-value presence,” not aggregate or anonymous.              | L2         | P0       | For a fixed fixture, expected identity, distinct-value, first-seen, and used-on-day outputs are exact and documented in report definitions.          | PO, Privacy, Data        |
| **DAT-05** | Current detail, archive detail, and aggregate storage shall be separated by lifecycle and access. Historical legacy data shall not be copied into active operational tables unless a named requirement needs it.                 | L7         | P1       | Historical portal query uses a read-only source; active ingestion cannot update historical partitions; access and retention differ by class.         | Data, Records            |
| **DAT-06** | Migration validation shall include manifests, row counts, rejected-row counts, hashes/checksums, key uniqueness, referential checks, semantic report queries, and sampled owner validation.                                      | L0, L7     | P0       | Reconciliation report accounts for every source row as migrated, deliberately excluded, duplicate, invalid, or quarantined.                          | Data, PO                 |
| **DAT-07** | Deletion shall address detail, minimized/person-level data, derived aggregates where applicable, errors, exports, caches, replicas, comparison data, and backups according to the approved schedule and legal-hold process.      | L2, L8     | P0       | Deletion test searches all named stores and proves removal, approved irreversible aggregation, or documented backup expiry.                          | Privacy, Records, Data   |
| **DAT-08** | Downstream consumers shall use documented APIs or governed views, not direct assumptions about replacement tables.                                                                                                               | L0, L7     | P1       | Consumer inventory is complete; contract tests pass; direct unidentified database consumers are blocked or explicitly accepted during transition.    | Data, Platform           |

## Portal requirements

| ID         | Requirement and rationale                                                                                                                                                      | Evidence | Priority | Acceptance test                                                                                                                                     | Owner to confirm           |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| **POR-01** | Portal navigation and APIs shall be generated from capabilities, not merely broad roles or hidden UI controls.                                                                 | L7       | P0       | Users cannot discover or call unauthorized pages, routes, APIs, exports, or mutations through direct requests.                                      | Portal, Security           |
| **POR-02** | Detail and minimized data views shall provide masking, bounded search, pagination, purpose notice, export restrictions, and access audit.                                      | L7       | P1       | Large-data tests remain responsive; unauthorized columns remain masked in UI, API, logs, and export.                                                | Portal, Privacy, Data      |
| **POR-03** | Policy editing shall show typed validation, human-readable effective changes, affected population, privacy impact, approval state, rollout ring, expiry, and rollback version. | L3       | P1       | Admin cannot publish an unknown field, invalid type, unsupported version, or unapproved scope expansion.                                            | Portal, PO, Privacy        |
| **POR-04** | Exclusion, allowlist, and application-match management shall include a simulator using synthetic or authorized test values and explain why a rule matched.                     | L6       | P1       | Golden rule cases pass; conflicting and shadowed rules are reported before publication.                                                             | Portal, Data, Privacy      |
| **POR-05** | Error and audit views shall separate operational metadata from sensitive diagnostics; break-glass detail access shall be time-limited and audited.                             | L8       | P1       | Standard support role sees error class and correlation ID but not raw URLs, paths, command lines, or call stacks.                                   | Support, Security, Privacy |
| **POR-06** | HR/organization views shall expose only approved fields and shall not implicitly grant telemetry access or collection authority.                                               | L7, L10  | P1       | HR-only, telemetry-only, and combined roles are tested independently. AD-group mutation requires a separate named capability and approval workflow. | HR owner, Portal, Security |
| **POR-07** | Every destructive or population-wide action shall provide preview, target count, reason, ticket, two-step confirmation, result summary, and partial-failure recovery.          | L7       | P1       | Simulated bulk enable, disable, deletion, and rule publication prove idempotency, audit completeness, and safe partial retry.                       | Portal, Operations         |

## Deployment requirements

| ID         | Requirement and rationale                                                                                                                                                                                        | Evidence | Priority | Acceptance test                                                                                                                              | Owner to confirm                |
| ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| **DEP-01** | Installation and update packages shall be signed, reproducibly versioned, atomically installed, health-checked, and safely reversible.                                                                           | L9       | P0       | Interrupted install, low disk, locked file, failed service start, and invalid signature return the device to the last known working version. | Release, Endpoint, Security     |
| **DEP-02** | Rollout shall use defined rings with bake periods and automated health gates. Ring expansion shall be an explicit decision.                                                                                      | L7       | P0       | No ring expands until all entry/exit queries pass and an authorized release owner approves.                                                  | Release, Operations             |
| **DEP-03** | Agent, policy, API, queue message, and database changes shall have a documented compatibility window and expansion/contraction strategy.                                                                         | L1, L3   | P0       | New and old agents operate safely during rollout; rollback does not require destructive schema reversal.                                     | Architecture, Data, Release     |
| **DEP-04** | New collectors shall support shadow mode in which comparison summaries are produced but new detail is not independently retained or used for decisions.                                                          | L1, L2   | P0       | Shadow mode cannot feed production reports or administrative actions; its outputs expire automatically.                                      | PO, Privacy, Data               |
| **DEP-05** | Automatic pause and rollback thresholds shall cover privacy scope, signature/authentication, crashes, resource use, outbox growth, ingestion health, checkpoint integrity, duplicate effect, and support impact. | L4, L8   | P0       | Fault injection crosses every threshold and produces the configured pause, task disable, or version rollback.                                | Operations, Security, PO        |
| **DEP-06** | Deployment inventory shall reconcile targeted, installed, healthy, excluded, failed, and unreachable endpoints.                                                                                                  | L10      | P1       | Every managed endpoint is in exactly one status; exceptions have owner, reason, expiry, and remediation.                                     | AD owner, Operations            |
| **DEP-07** | Legacy and replacement systems shall have explicit writer/read-only authority by phase. Both shall never independently act as authoritative writers for the same downstream contract without reconciliation.     | L4, L7   | P0       | Database and API telemetry prove which system is authoritative; unauthorized legacy writes alert immediately.                                | Service owner, Data, Operations |
| **DEP-08** | Rollback shall revert code and policy without deleting new outbox data or reactivating endpoint database credentials.                                                                                            | L4, L5   | P0       | Rollback from every production-supported version preserves queued events and returns to a compatible policy.                                 | Endpoint, Security, Release     |

Microsoft’s safe-deployment guidance supports staged rollout, bake periods, health indicators, immediate rollout stop on detected problems, versioning, feature flags, and rollback to a known working configuration. ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/safe-deployments "https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/safe-deployments"))

## Support requirements

| ID         | Requirement and rationale                                                                                                                                                               | Evidence | Priority | Acceptance test                                                                                                                                    | Owner to confirm              |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- |
| **SUP-01** | L1, L2, L3, endpoint, platform, privacy, security, and data ownership shall be documented for every alert and failure class.                                                            | L8       | P1       | A support simulation routes representative cases to the correct owner without relying on a developer who is not on call.                           | Support, Operations           |
| **SUP-02** | A case-scoped diagnostic bundle shall contain version, effective-policy digest, health, counters, bounded recent errors, and redacted configuration, but no activity detail by default. | L8       | P0       | Automated sensitive-token corpus is absent from the bundle. Bundle expires and its collection is audited.                                          | Support, Privacy, Endpoint    |
| **SUP-03** | Support shall have tested runbooks, known-error articles, user-facing guidance, escalation templates, and training environments.                                                        | L7, L8   | P1       | Staff complete scenario exercises and meet the approved triage and escalation criteria.                                                            | Support                       |
| **SUP-04** | Privacy and security incidents shall use dedicated escalation paths that preserve evidence while stopping unauthorized collection or disclosure.                                        | L8       | P0       | Exercise an unauthorized field and stolen device identity; collection is contained, evidence retained appropriately, and decision owners notified. | Privacy, Security, Operations |
| **SUP-05** | Support metrics shall distinguish deployment defect, policy defect, data-quality issue, source incompatibility, environmental issue, and user question.                                 | L8       | P1       | Weekly pilot report attributes all cases and identifies recurrent issues and affected versions.                                                    | Support, PO                   |

---

# 3. Legacy behaviour disposition matrix

| Legacy behaviour                                                                  | Disposition                                | Proposed target/default                                                                                | Decision still required                                                          |
| --------------------------------------------------------------------------------- | ------------------------------------------ | ------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------- |
| Edge, Chrome, and Firefox collection                                              | **Preserve outcome**                       | Supported adapters with explicit source/profile/version capability reporting                           | Which browsers and release channels are in service scope?                        |
| Selecting one “newest valid” browser database                                     | **Deliberately change**                    | Discover and track each approved profile separately                                                    | Are all local profiles in scope, only active profiles, or a nominated profile?   |
| Browser domain extraction                                                         | **Preserve conditionally**                 | Normalize host and apply approved allowlist/redaction before outbox                                    | Is domain-level data necessary for each use case?                                |
| Full browser URL                                                                  | **Investigate; default off**               | Separate detail field with query/fragment reduction and restricted retention                           | Which report genuinely requires page-level information?                          |
| Browser title read from source                                                    | **Retire by default**                      | Do not introduce it merely because the source contains it                                              | Is there an approved purpose not visible in current storage?                     |
| Browser checkpoint per browser                                                    | **Preserve outcome**                       | Per browser/profile durable checkpoint with source cursor metadata                                     | Exact initial lookback and late-event policy                                     |
| Recent/Quick Access collection                                                    | **Investigate; default off**               | Prefer approved file category/application signal; full path separately gated                           | Is document-level or path-level monitoring necessary?                            |
| Directory exclusion and path wildcard settings                                    | **Redesign**                               | Typed rule policy with endpoint test simulator and explicit default action                             | Which locations are permitted rather than merely excluded?                       |
| Process name collection                                                           | **Preserve conditionally**                 | Approved process/application identity                                                                  | Whether raw process names are sufficient or should map to applications           |
| Full executable path/product/company                                              | **Investigate; default off**               | Normalize and map to approved application catalogue before person-level storage                        | Which fields are necessary for application reporting?                            |
| Detail/minimum toggles                                                            | **Preserve concept**                       | Separate policy products with separate schemas and access                                              | Which combinations are legally and operationally approved?                       |
| Legacy “minimal” rows                                                             | **Deliberately change**                    | Name accurately as per-user daily distinct-value presence, or redesign as true aggregate               | Whether person-level distinct values remain needed                               |
| Per-day minimal-use rows                                                          | **Preserve only if approved**              | Idempotent daily-presence record with explicit timezone/day definition                                 | Local day, UTC day, or reporting-calendar day?                                   |
| Checkpoint appended to event SQL                                                  | **Preserve invariant; redesign mechanism** | Atomic local event/progress transaction plus idempotent server commit                                  | Accepted treatment of deliberately filtered source rows                          |
| Ten-year first-run Browser/Recent fallback                                        | **Retire by default**                      | No historical backfill until approved                                                                  | Permitted historical lookback                                                    |
| Process first-run “now” behaviour                                                 | **Preserve proposed default**              | Start at installation/service activation                                                               | Whether process backfill is needed at all                                        |
| Browser/process exclusion lists                                                   | **Redesign**                               | Import semantically proven rules as disabled compatibility rules; build positive allowlists separately | Whether each rule still reflects approved policy                                 |
| Inverting exclusions into allowlists                                              | **Do not automate**                        | Treat allowlist design as a new privacy decision                                                       | Approved set of domains, paths, applications, and rule owners                    |
| Application-match expressions                                                     | **Investigate**                            | Disabled drafts with documented output semantics and tests                                             | What constitutes an application, tie-breaking, versioning, and reporting effect? |
| Global settings                                                                   | **Preserve required outcomes**             | Typed, versioned policy fields with validation                                                         | Which settings remain business configurable?                                     |
| User and computer overrides                                                       | **Redesign**                               | Explicit scoped exception object with approval, reason, and expiry                                     | Whether user-level broadening is ever permitted                                  |
| AD-group-derived enablement                                                       | **Deliberately change**                    | Eligibility input only; effective collection requires approved policy                                  | Is group membership intended to authorize collection?                            |
| Per-user `startlogging` switch                                                    | **Preserve outcome**                       | Audited targeted enable/disable capability                                                             | Who may change it and under what evidence?                                       |
| Non-persistent-device identity handling                                           | **Redesign**                               | Stable managed device instance plus user/session identity                                              | Reporting key for reimaged or pooled devices                                     |
| Direct SQL from endpoints                                                         | **Retire**                                 | Authenticated HTTPS ingestion/control APIs                                                             | None; security owner verifies removal                                            |
| Endpoint database credential file                                                 | **Retire**                                 | Managed device identity and API authorization                                                          | Revocation and endpoint-cleanup plan                                             |
| Executable SQL CSV buffering                                                      | **Retire**                                 | Structured SQLite transactional outbox                                                                 | How to drain or quarantine existing buffers                                      |
| Offline continuation and retry                                                    | **Preserve outcome**                       | Durable structured outbox, jitter, limits, backpressure                                                | Maximum outage and local storage policy                                          |
| Local rotating log files                                                          | **Redesign**                               | Structured, redacted, bounded operational log                                                          | Local retention and support access                                               |
| Rich errors with command lines/call stacks                                        | **Redesign**                               | Error code and safe metadata by default; protected diagnostic escalation                               | Which detail support legitimately needs                                          |
| Centrally supplied `PSCode` expression execution                                  | **Retire**                                 | No arbitrary expression execution                                                                      | None unless a new, separately approved automation product is created             |
| Device scripts                                                                    | **Investigate; disabled**                  | Archive, classify, review, package, sign, constrain                                                    | Which script outcomes remain required?                                           |
| Script schedules                                                                  | **Investigate; disabled**                  | Recreate only after task approval and target review                                                    | Which schedules, windows, and targets remain valid?                              |
| Device types and lookups                                                          | **Preserve conditionally**                 | Validated reference data and targeting attributes                                                      | Authoritative source and current owner                                           |
| Logging-user and activity-data portal views                                       | **Preserve outcomes**                      | Modern, masked, capability-controlled views                                                            | Required columns, filters, exports, and retention                                |
| HR and organization views                                                         | **Investigate separately**                 | Source-linked, least-data views independent of telemetry privileges                                    | Approved HR fields and user populations                                          |
| Bulk enable/disable                                                               | **Preserve with stronger controls**        | Preview, approval, target count, audit, idempotency                                                    | Who can authorize population-wide changes?                                       |
| Bulk deletion                                                                     | **Redesign**                               | Governed lifecycle/deletion workflow, not direct row deletion                                          | Whether this is correction, privacy deletion, or operational cleanup             |
| Generic action audit table                                                        | **Preserve outcome; redesign schema**      | Immutable structured audit with before/after digest and purpose                                        | Audit retention and auditor access                                               |
| Current and archive detail tables                                                 | **Investigate by consumer**                | Read-only historical estate or governed migration                                                      | Which reports need historical detail and for how long?                           |
| Forced elevation, same-session process killing, and memory-triggered self-restart | **Retire implementation**                  | Proper service recovery, singleton control, updater coordination, and resource limits                  | Approved resource limits and recovery behaviour                                  |

---

# 4. Open-question interview guide

Each question is deliberately phrased for non-technical interviews. The default is applied only until the decision owner answers.

## Product owner

| Question                                                                               | Proposed default                                                                                                               | Consequence                                                |
| -------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------- |
| What decision or service does each type of collected data support?                     | Collect only the currently approved core signal at the least detailed level.                                                   | Features with no named outcome will be omitted.            |
| Do reports need full URLs and file paths, or are domains and application names enough? | Domains and approved application identifiers only.                                                                             | Page- and document-level reports will not be available.    |
| How far back should a new installation look?                                           | Start from installation time.                                                                                                  | No historical backfill.                                    |
| Which current portal pages are used in real work, by whom, and how often?              | Preserve read-only core status/data views; other pages become disabled migration candidates.                                   | Low-use or unknown functions may not be rebuilt initially. |
| How close must new reports be to old reports before cutover?                           | Exact for authorization, policy, aggregate definitions, and checkpoints; proposed 2% event-count tolerance for timing effects. | Cutover may be delayed where semantics are unclear.        |

## Privacy, legal, and security

| Question                                                                        | Proposed default                                                                | Consequence                                             |
| ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------- |
| What is the approved purpose and legal basis for each signal and identity link? | That source remains disabled.                                                   | Some collectors cannot enter pilot.                     |
| What is the shortest time each data class needs to be retained?                 | Pilot-only short retention; no broad rollout until approved.                    | Long-term trend reporting may be unavailable.           |
| Who may view or export person-level detail?                                     | A small separately approved capability group; no routine export.                | Administrators may see only health and aggregate views. |
| Is a DPIA, employee notice, or consultation required?                           | Complete the assessment before rollout beyond the controlled pilot.             | Broad rollout pauses until recorded.                    |
| Which diagnostic details are permitted during support or incidents?             | Error class, version, correlation ID, and counters only; detail is break-glass. | Some investigations may require an approval step.       |

## Administrators

| Question                                                                        | Proposed default                                                                       | Consequence                                                  |
| ------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| When global, group, device, and user settings conflict, which should win?       | The more restrictive collection/privacy rule wins.                                     | A user override cannot silently broaden scope.               |
| Should the system collect everything except exclusions, or only approved items? | Positive allowlisting.                                                                 | Unlisted applications, domains, and paths are not collected. |
| Who may approve an exception, and when should it expire?                        | Separate approver, reason, ticket, and maximum expiry.                                 | Permanent informal exceptions are not migrated.              |
| Which bulk actions are necessary?                                               | Preview and two-step confirmation; population-wide operations require a change record. | Ad hoc “all users” changes take longer.                      |
| Which existing scripts and schedules are still needed?                          | None execute until separately reviewed and signed.                                     | Legacy automation may be unavailable during transition.      |

## Support

| Question                                                       | Proposed default                                                                      | Consequence                                    |
| -------------------------------------------------------------- | ------------------------------------------------------------------------------------- | ---------------------------------------------- |
| What problems do users and administrators currently report?    | Build support around known health, policy, source, outbox, and update categories.     | Unknown cases escalate to engineering.         |
| What information is genuinely needed to diagnose each problem? | Metadata-only diagnostic bundle.                                                      | Raw activity cannot be gathered casually.      |
| What support hours and response times are required?            | Controlled pilot during staffed hours; production expansion waits for ownership.      | No unsupported 24/7 commitment is implied.     |
| Who handles a suspected privacy or security incident?          | Immediate dedicated Privacy/Security escalation rather than ordinary troubleshooting. | Some cases bypass normal L1 investigation.     |
| How long may a diagnostic bundle exist?                        | Proposed 14 days, encrypted and case-bound; owner to approve.                         | Older cases may need a newly generated bundle. |

## Infrastructure and operations

| Question                                                                | Proposed default                                                          | Consequence                                                        |
| ----------------------------------------------------------------------- | ------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| Which managed identity or certificate system should identify endpoints? | Existing managed device certificate/identity platform, where suitable.    | Unmanaged devices cannot enrol automatically.                      |
| How long may endpoints be offline, and how much local disk may UAM use? | Test multi-day outage; proposed 250 MB outbox bound pending measurements. | Collection pauses at the bound rather than silently dropping data. |
| Which endpoint-management system controls rollout rings?                | Use the existing authoritative deployment platform.                       | A separate unmanaged updater inventory will not be created.        |
| What recovery time and data-loss objectives apply to the service?       | No final cutover until named objectives and restore test exist.           | Pilot remains non-authoritative.                                   |
| Which maintenance windows and network restrictions apply?               | Stagger updates and uploads; no direct database network path.             | Catch-up may take longer but avoids reconnect waves.               |

## Data and reporting

| Question                                                                                    | Proposed default                                                                                     | Consequence                                                    |
| ------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | -------------------------------------------------------------- |
| What exactly does each metric mean—for example “used,” “first used,” and “number of times”? | Preserve the current label only as “unvalidated legacy semantic” until defined.                      | Reports cannot claim semantic equivalence prematurely.         |
| Is “minimal” intended to be anonymous, aggregate, or person-level daily presence?           | Treat it as person-level daily presence.                                                             | It receives person-level access and retention controls.        |
| Which historical detail reports must remain available?                                      | Legacy history stays read-only; do not copy it into the new active database.                         | Users may use a separate historical view.                      |
| Which HR or organization fields are required in reports?                                    | Join only approved fields on demand.                                                                 | Some convenient legacy columns may disappear.                  |
| What difference between legacy and new output is acceptable?                                | Exact on policy/checkpoints/aggregates; proposed bounded count and timing tolerances for raw events. | Larger differences require disposition, not silent acceptance. |

## Representative users

| Question                                                                               | Proposed default                                                | Consequence                                                       |
| -------------------------------------------------------------------------------------- | --------------------------------------------------------------- | ----------------------------------------------------------------- |
| Is the purpose, collected information, and support route clear?                        | Provide plain-language notice and support contact before pilot. | Users are not expected to infer behaviour from installation.      |
| Does the agent noticeably affect login, browser use, battery, disk, or network?        | Any repeatable noticeable impact blocks ring expansion.         | Performance optimization takes precedence over rollout speed.     |
| How should shared, RDP, VDI, or multiple-profile devices behave?                       | Never combine one user’s data with another’s identity.          | Some shared-device data may be omitted until identity is certain. |
| What should happen when a user believes information is wrong or should not be present? | Provide a documented correction/privacy escalation path.        | Support does not directly edit telemetry without governance.      |

---

# 5. Data and configuration migration matrix

Migration extracts should be immutable, encrypted, manifested, and reconciled. Row counts are useful as a first check, while hashes/checksums and business-function validation provide stronger evidence. ([Microsoft Learn](https://learn.microsoft.com/th-th/azure/cloud-adoption-framework/migrate/execute-migration "https://learn.microsoft.com/th-th/azure/cloud-adoption-framework/migrate/execute-migration"))

**Proposed staging default:** encrypted isolated staging; access limited to the migration team; delete within 30 days after signed reconciliation unless Privacy/Records approves another period.

| Asset and provenance                                         | Target transformation                                                                                                               | Validation                                                                             | Rollback                                                       | Retention handling                                | Auto-migrate?                                       |
| ------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- | -------------------------------------------------------------- | ------------------------------------------------- | --------------------------------------------------- |
| Global settings from legacy settings table                   | Map known codes to typed versioned policy fields; normalize units; preserve source code and export hash                             | Schema/type/range tests; compare effective values on sample devices                    | Re-activate prior new-policy version; source remains read-only | Source retained under legacy archive schedule     | **Conditional**                                     |
| User/device settings and overrides                           | Create explicit scoped exception objects with reason, owner, expiry, and precedence                                                 | Detect duplicate/conflicting values; compare effective policy for every pilot identity | Disable imported exceptions and restore baseline policy        | Delete staging after reconciliation               | **Conditional; conflicts quarantined**              |
| Per-user collection-enable flags                             | Import as **eligibility candidates**, not automatic authority                                                                       | Compare counts and sample identities; owner approves intended population               | Disable candidate set                                          | Retain decision/audit, not temporary extract      | **No automatic enablement**                         |
| Eligibility AD-group membership                              | Reference authoritative group or copy minimal membership snapshot with timestamp                                                    | Compare source membership and effective eligibility                                    | Revert policy source; no direct telemetry deletion required    | Per IAM audit schedule                            | **Conditional**                                     |
| Device/user/non-persistent identity rows                     | Map to stable device ID, user/session identity, and legacy alias                                                                    | Detect reused names, duplicate users, reimaged devices, ambiguous pools                | Restore alias map; no destructive merge                        | Preserve only required aliases                    | **Conditional**                                     |
| Browser checkpoints                                          | Convert to per-browser/profile cursor only from last durably committed legacy state                                                 | Confirm no pending buffer contains later events; compare max committed event time      | Reset new cursor to signed snapshot and replay idempotently    | Migration snapshot retained with cutover evidence | **Conditional**                                     |
| Process and Recent checkpoints                               | Same approach, with explicit first-run policy                                                                                       | Check against source maximums and pending buffers                                      | Reset/replay                                                   | As above                                          | **Conditional**                                     |
| Browser exclusion rules                                      | Translate legacy wildcard semantics into versioned compatibility rules; import disabled until dual-evaluated                        | Golden samples; legacy/new match-set comparison; identify broad/empty rules            | Disable imported rule set                                      | Keep decision history; retire obsolete rules      | **Conditional**                                     |
| Process exclusion rules                                      | Normalize process/path/product/company fields and preserve AND/OR semantics explicitly                                              | Golden process corpus; compare special “unknown/access denied” behaviour               | Disable imported rules                                         | As above                                          | **Conditional**                                     |
| New positive allowlists                                      | Create from approved purposes and application/domain catalogue, not by reversing exclusions                                         | Privacy/product review; synthetic match tests                                          | Revert allowlist version                                       | Governed policy history                           | **No**                                              |
| Application-match entries                                    | Import as disabled drafts with source provenance                                                                                    | Define expected application ID and tie-breaking; run conflict analysis                 | Delete/disable draft                                           | Retain approved catalogue only                    | **No automatic activation**                         |
| Device types and OU targeting                                | Map to managed targeting attributes with authoritative source and expiry                                                            | Compare target population before activation                                            | Revert targeting policy                                        | Governed reference-data retention                 | **Conditional**                                     |
| Legacy script bodies                                         | Store encrypted read-only archive with hash, owner if known, and classification                                                     | Malware/security review; dependency and privilege inventory                            | No runtime rollback because not executable                     | Records/security schedule                         | **No execution**                                    |
| Script schedules                                             | Import as disabled draft referencing archived script and old target criteria                                                        | Validate time zone, target population, validity, and owner                             | Delete draft                                                   | Retain only approved schedules                    | **No activation**                                   |
| System lookups/reference data                                | Map known categories/codes; quarantine unknown or duplicate values                                                                  | Referential and uniqueness checks; owner review                                        | Restore prior lookup version                                   | Governed reference-data retention                 | **Conditional**                                     |
| Legacy minimized base rows and daily rows                    | Prefer historical read-only access; transform only if the exact new semantic is approved                                            | Row counts, key uniqueness, daily-presence equivalence, first-seen checks              | Restore historical view; discard failed transformed copy       | Privacy/Records decision distinct from detail     | **Conditional**                                     |
| Current detailed Browser/Process/Recent tables               | Expose through historical read-only store; do not insert into new active partitions by default                                      | Counts, checksums, date ranges, consumer query tests                                   | Restore old historical view                                    | Exact detail retention decision required          | **No by default**                                   |
| Detailed archive tables                                      | Keep encrypted and read-only or delete under approved schedule                                                                      | Restore test and representative report validation                                      | Restore archive snapshot                                       | Exact archive schedule required                   | **No active-table import**                          |
| Error records                                                | Map safe error class/version/time/device alias; omit raw command line, paths, settings, and call stack unless specifically approved | Compare class counts; sample redaction; quarantine unsafe records                      | Use legacy read-only error archive                             | Separate diagnostic retention                     | **Conditional**                                     |
| Audit history                                                | Preserve immutable historical audit; optionally normalize actor/action/target/result metadata                                       | Sequence/count/date validation; test tamper evidence                                   | Fall back to legacy read-only audit                            | Audit/records schedule                            | **Yes for safe metadata; conditional for payloads** |
| HR/AD/personnel data                                         | Do not bulk-copy into telemetry store; build approved source interface or minimal cache                                             | Attribute contract, freshness, identity match, access-role tests                       | Disable interface/cache                                        | HR owner’s source retention                       | **No bulk migration**                               |
| Existing deferred CSV/SQL buffers                            | Inventory and hash; parse only in an isolated converter; reconstruct structured events where semantics are certain                  | Account for every statement; compare event/checkpoint effects; never execute blindly   | Preserve encrypted original until disposition is signed        | Proposed 30-day quarantine after reconciliation   | **No direct execution**                             |
| Endpoint database credential files and embedded key material | Revoke, rotate where shared, securely erase, and verify absence                                                                     | Endpoint scan, database-login audit, network deny test                                 | No rollback to endpoint DB access                              | No retention except security evidence             | **Never**                                           |
| Local legacy logs and fallback error files                   | Leave local under approved short retention; collect only case-scoped redacted diagnostics                                           | Sensitive-value scan and deletion proof                                                | None                                                           | Local log schedule                                | **No central bulk migration**                       |
| Portal data dictionary and UI labels                         | Map approved business definitions and field classifications                                                                         | Owner review; contract/UI consistency tests                                            | Restore prior portal metadata version                          | Governed configuration history                    | **Conditional**                                     |

### Migration reconciliation record

Every migration execution must produce:

1. Source snapshot identifier, extraction time, tool version, operator, and hashes.

2. Source row count and distinct-key count.

3. Migrated, duplicate, deliberately excluded, invalid, and quarantined counts.

4. Target row count, target hashes/checksums, and referential checks.

5. Semantic queries for key reports and checkpoint ranges.

6. Sampled validation by the data/reporting owner.

7. Privacy review for unexpectedly detailed values.

8. Rollback point and evidence that rollback was tested.

9. Staging-deletion date and evidence.

10. Signed acceptance or rejection.

---

# 6. Phased pilot and canary plan

All ring sizes, bake periods, and numeric rollback limits below are **proposed engineering estimates**. They must be calibrated using lab and pilot measurements.

| Phase                            | Proposed population and mode                                                       | Entry criteria                                                                                        | Exit criteria                                                                                           |
| -------------------------------- | ---------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| **0. Governance and baseline**   | No live deployment                                                                 | Owner map assigned; purpose/field decisions recorded; legacy configurations and consumers inventoried | P0 requirements baselined; disposition matrix approved; legacy comparison baseline frozen               |
| **1. Lab and synthetic VM**      | Representative Windows VMs; synthetic browser/process/recent data                  | Browser vertical slice meets Definition of Ready                                                      | Functional, crash, source-lock, policy, upgrade, rollback, privacy-filter, and outbox fault tests pass  |
| **2. Engineering canary**        | 10–25 managed devices; shadow summaries only; detail upload off                    | Signed build; monitoring, kill switch, and staffed support active                                     | Proposed 3 working days with no P0 violation; stable resource profile; all discrepancies explained      |
| **3. Representative pilot**      | 50–100 devices across laptop, VDI/RDP, browser/profile, network, and user patterns | Engineering canary accepted; privacy/security pilot approval                                          | Proposed 5 working days; comparison tolerances pass; no unresolved Sev-1/Sev-2; support workflow proven |
| **4. Production ring A/B**       | Approximately 1% then 5%: about 60 then 300 of 6,000 endpoints                     | Capacity and reconnect test passed; operational owner approves                                        | Proposed 7 days per ring; health, outbox, API, queue, database, data-quality, and support gates green   |
| **5. Broad rings**               | Approximately 20% then 50%: about 1,200 then 3,000                                 | Restore test and operational game days passed                                                         | Proposed 7–14 days per ring; no unexplained cohort-specific issue; legacy/new report acceptance signed  |
| **6. Full controlled rollout**   | Remaining managed endpoints; legacy detail writer disabled in completed cohorts    | 50% ring accepted; exception inventory complete                                                       | At least 98% healthy managed coverage or approved exceptions; rollback remains available                |
| **7. Stabilization and cutover** | New system authoritative; legacy read-only                                         | Zero unauthorized legacy writes; buffers inventoried and drained                                      | Proposed 30-day stable period; operational and data owners accept                                       |
| **8. Decommission**              | Legacy services, credentials, mutation functions, and endpoint files removed       | Decommission checklist complete except final approvals                                                | Final evidence pack signed by service, privacy, security, data, operations, and records owners          |

## Automatic pause and rollback limits

| Signal                                                    | Proposed threshold                                                                          | Automatic action                                                                                           |
| --------------------------------------------------------- | ------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| Unauthorized field, source, user, or profile              | **Any confirmed occurrence**                                                                | Disable affected collector immediately; stop ring; preserve restricted evidence; Privacy/Security incident |
| Cross-tenant/customer or cross-user attribution           | **Any occurrence**                                                                          | Stop ingestion and affected fleet policy; incident response                                                |
| Invalid signature, package, or policy authenticity        | **Any execution or acceptance attempt**                                                     | Block artifact; stop rollout; revoke affected version if necessary                                         |
| Checkpoint regression or confirmed skipped accepted range | **Any confirmed occurrence**                                                                | Stop affected collector; retain outbox; rollback policy/build                                              |
| Duplicate business effect after idempotency               | Greater than **0.1%** of accepted events in a ring, or any aggregate/checkpoint corruption  | Stop ring and affected processor                                                                           |
| Agent crash/unavailable                                   | Greater than **1% of ring for 30 minutes**, or three times measured baseline                | Pause rollout; rollback agent if version-correlated                                                        |
| Endpoint idle CPU                                         | p95 greater than **2% for 15 minutes** after excluding active collection windows            | Disable collector or rollback based on attribution                                                         |
| Private memory                                            | p95 greater than **150 MB** or 50 MB above accepted baseline                                | Pause; capture safe diagnostics; rollback if version-correlated                                            |
| Outbox bound                                              | Greater than **250 MB**, or oldest item over 24 hours on more than 1% of online ring        | Stop new collection; retain existing data; pause expansion                                                 |
| API errors                                                | 5xx greater than **1% for 5 minutes**                                                       | Stop ring expansion; invoke server incident runbook                                                        |
| Processing backlog                                        | Oldest accepted batch greater than **15 minutes for 15 minutes** outside planned fault test | Apply backpressure; pause rollout                                                                          |
| Authentication failures                                   | Greater than **2% of ring for 15 minutes** and version/policy-correlated                    | Pause and investigate identity/configuration                                                               |
| Data comparison                                           | Raw count or set tolerance fails in more than **1% of compared windows**                    | Do not expand ring; investigate before rollback decision                                                   |
| Support impact                                            | Two Sev-2 incidents attributable to the release, or user-impact reports over **2% of ring** | Pause ring; service owner decides rollback                                                                 |
| Deletion/retention control                                | Any missed mandatory deletion deadline                                                      | Stop scope expansion; Privacy/Records incident                                                             |

The default rollback boundary should be the **smallest safe unit**: rule or policy first, then collector, then task package, then agent version. A full fleet rollback is reserved for systemic defects.

---

# 7. Parallel-run comparison without unnecessary sensitive duplication

## Comparison architecture

1. Freeze the legacy policy, exclusion rules, time normalization, and known legacy defects for the comparison cohort.

2. Keep the legacy system as the sole authoritative detail writer during shadow comparison.

3. Let the new agent perform normal endpoint-side filtering, but upload only:
   
   - event counts by source and time window;
   
   - distinct-value counts;
   
   - keyed digests of canonical event identifiers;
   
   - minimum and maximum source timestamps;
   
   - checkpoint/cursor metadata;
   
   - excluded/allowed counts by rule identifier;
   
   - safe error categories;
   
   - resource and outbox metrics.

4. Compute equivalent keyed digests from the legacy authoritative store inside a restricted comparison service.

5. Use a rotating, comparison-period-specific HMAC key. Delete the key and comparison digests after the approved short period.

6. Treat comparison digests as restricted pseudonymous data, not anonymous data.

7. Do not place raw URLs, paths, titles, or process command lines in a second central comparison database.

8. Escalate to raw inspection only for a small, explicitly approved break-glass sample with purpose, scope, expiry, and audit.

9. Delete comparison artefacts after sign-off or the approved investigation period.

## Canonical comparison key

The exact key is a data-contract decision. A proposed key is:

`device pseudonym + scoped user/session pseudonym + source + profile pseudonym + normalized source timestamp + canonical approved value + event type + normalization version`

For domain-only Browser mode, the canonical value must be the approved normalized domain, not the original URL.

## Proposed tolerances

| Dimension                                  | Proposed acceptance                                                              | Rationale                                                                                  |
| ------------------------------------------ | -------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| Effective policy and enabled collectors    | **Exact**                                                                        | Scope differences may create privacy or coverage changes.                                  |
| Unauthorized fields or values              | **Zero**                                                                         | This is a control invariant, not a statistical metric.                                     |
| Identity/user/profile association          | **Exact**                                                                        | Cross-user attribution cannot be averaged away.                                            |
| Rule allow/exclude result                  | **Exact for frozen rule set**                                                    | Any difference must be explained as an approved semantic change.                           |
| Minimized daily-presence output            | **Exact after normalization and settling**                                       | Defined keys and dates should be deterministic.                                            |
| Raw event count per device/user/source/day | Difference no greater than `max(2 events, 2%)` after two collection intervals    | Poll timing, live database changes, and source timing may cause small edge differences.    |
| Distinct canonical event set               | Jaccard similarity at least **0.98**                                             | Detects both missing and unexpected values without duplicating raw detail.                 |
| Source timestamp                           | p95 absolute difference no greater than **5 seconds** after canonical conversion | Allows representation and collection timing differences without changing source semantics. |
| Checkpoint position                        | No regression; lag no greater than one scheduled interval plus **5 minutes**     | Prevents silent gaps while allowing asynchronous acceptance.                               |
| Duplicate new-system business effect       | **Zero**                                                                         | Retries are expected; duplicate final effect is not.                                       |
| Error rate                                 | No new recurring source error over **1% of eligible cohort**                     | Detects browser/profile/schema incompatibility.                                            |
| Resource use                               | Within approved lab/pilot baseline and automatic limits                          | Prevents functional parity at unacceptable endpoint cost.                                  |

A mismatch should be classified as:

- a new-system defect;

- a known legacy defect not to be preserved;

- an approved semantic change;

- an expected timing-window difference;

- an identity/source-population difference;

- an exclusion/normalization-version difference; or

- unresolved, which blocks rollout.

No discrepancy may be dismissed simply because total counts happen to be similar.

---

# 8. Operational readiness, ownership, runbooks, training, and handover

## Proposed operational ownership model

| Capability                         | Accountable                | Responsible                | Consulted                           |
| ---------------------------------- | -------------------------- | -------------------------- | ----------------------------------- |
| Product purpose and scope          | Service owner              | Product owner              | Privacy, Data, representative users |
| Privacy controls and retention     | Privacy/data owner         | Product, Data, Platform    | Records, Security                   |
| Endpoint agent and updater         | Endpoint owner             | Endpoint engineering       | Security, Support                   |
| Ingestion, queue, database         | Platform/SRE owner         | Platform engineering       | Data, Security                      |
| Data contracts and reporting       | Data owner                 | Data engineering/BI        | PO, Privacy                         |
| Portal and capability model        | Portal owner               | Portal engineering/IAM     | Security, Privacy, Support          |
| Device identity and rollout groups | AD/device-management owner | Endpoint management        | Security, Operations                |
| Release and canary decisions       | Change/release owner       | Operations and engineering | PO, Security, Privacy               |
| Incident command                   | Operations owner           | On-call responders         | Security, Privacy, service owner    |
| User support                       | Support owner              | L1/L2                      | Endpoint, Platform, Portal          |
| Legacy archive and disposal        | Records/data owner         | Database/records team      | Privacy, Audit                      |

## Operational readiness checklist

| Gate                       | Required evidence                                                                                       | Proposed owner       |
| -------------------------- | ------------------------------------------------------------------------------------------------------- | -------------------- |
| Service ownership          | Named service owner, technical owners, on-call roster, deputies                                         | Service owner        |
| Service catalogue          | Purpose, users, hours, dependencies, data classification, support route                                 | PO                   |
| SLOs                       | Approved availability, latency, backlog, policy convergence, and restore objectives                     | SRE, Service owner   |
| Fleet monitoring           | Version, policy, health, outbox, source coverage, update and exception dashboards                       | Endpoint, Operations |
| Server monitoring          | API, auth, queue depth/age, worker errors, DB latency/locks/storage, partition and retention status     | SRE                  |
| Data-quality monitoring    | Duplicates, invalid schema, timestamp anomalies, checkpoint lag, source coverage, aggregate consistency | Data                 |
| Security monitoring        | Authentication abuse, wrong tenant, signing failure, policy tamper, privilege use, unusual exports      | Security             |
| Privacy monitoring         | Unauthorized-field canary, retention misses, export/break-glass use, deletion failures                  | Privacy, Data        |
| Capacity                   | 6,000-endpoint baseline, morning/reconnect peaks, 2× measured peak test, storage forecast               | SRE                  |
| Backup/restore             | Successful restore into isolated environment and application-level validation                           | Data, SRE            |
| Change management          | Ring definitions, release approval, rollback thresholds, emergency process                              | Release              |
| Incident readiness         | Completed game days and post-exercise actions                                                           | Operations           |
| Support                    | Trained L1/L2, escalation map, KB, safe diagnostics, known errors                                       | Support              |
| Access                     | Role/capability matrix, access reviews, break-glass procedure, privileged audit                         | Security, Portal     |
| Retention                  | Active deletion jobs, alerts, evidence reports, backup schedule                                         | Records, Privacy     |
| Customer/tenant separation | Contract tests and operational query proving isolation                                                  | Security, Platform   |
| Dependency inventory       | Certificate issuer, endpoint manager, IdP, queue, DB, HR/AD interfaces, monitoring                      | Architecture         |
| Exit criteria              | No open P0 defect; accepted residual risks and exception expiries                                       | Service owner        |

## Required runbooks

| Runbook                              | Minimum content                                                                          |
| ------------------------------------ | ---------------------------------------------------------------------------------------- |
| Endpoint not checking in             | Identity, version, network, service state, policy, update and escalation checks          |
| Collector source unavailable         | Browser/profile discovery, locked/WAL/schema states, safe retry, checkpoint rule         |
| Outbox growing                       | Server reachability, backpressure, disk protection, collection pause, drain verification |
| Device authentication failure        | Certificate/token status, revocation, tenant binding, re-enrolment                       |
| Bad policy or privacy scope          | Kill switch, affected population, evidence preservation, rollback, notification          |
| Bad update                           | Ring stop, health correlation, version rollback, outbox preservation                     |
| API/queue/database backlog           | Backpressure, worker scaling, DB diagnosis, queue age, recovery validation               |
| Poison batch/schema mismatch         | Quarantine, bounded retries, schema-owner escalation, replay after fix                   |
| Checkpoint anomaly                   | Stop collector, preserve outbox/source snapshot, compare committed range, safe reset     |
| Duplicate business effect            | Idempotency diagnosis, affected aggregates, correction and evidence                      |
| Privacy incident                     | Stop collection/access, preserve restricted evidence, Privacy/Security escalation        |
| Credential or signing-key compromise | Revoke, rotate, identify affected devices/artifacts, replace trust                       |
| Deletion or retention failure        | Stop expansion, identify stores/subjects, retry, verify, document                        |
| Backup/restore                       | Restore steps, secrets replacement, integrity validation, service reopening              |
| Legacy buffer drain                  | Inventory, hash, isolate, convert/reconcile, quarantine, approve disposal                |
| Legacy decommission rollback         | Conditions for temporary read-only restoration without reissuing endpoint DB access      |

## Training

| Audience                    | Required training                                                                |
| --------------------------- | -------------------------------------------------------------------------------- |
| Portal administrators       | Capabilities, policy workflow, rule simulator, approvals, bulk actions, audit    |
| L1/L2 support               | Health interpretation, safe diagnostics, privacy boundaries, escalation          |
| On-call engineering         | Failure modes, kill switches, rollback, queue/database and checkpoint invariants |
| Privacy/security responders | Scope breach, break-glass access, evidence preservation, credential compromise   |
| Release managers            | Ring progression, health gates, automatic thresholds, exception handling         |
| Data/reporting users        | New metric definitions, historical-vs-active views, known semantic changes       |
| Records/data administrators | Retention, deletion evidence, legal hold, archive restore                        |

## Support handover exit criteria

Handover is complete only when:

- all runbooks have named owners and review dates;

- at least one endpoint failure game day and one platform/privacy game day have been completed;

- dashboards and alerts are accessible to the actual on-call roles;

- L1/L2 can resolve or correctly route the agreed common cases;

- diagnostic bundles pass privacy tests;

- the known-error catalogue identifies affected versions and workarounds;

- support hours and severity objectives are approved;

- engineering escalation does not depend on one individual;

- the pilot support report has been accepted; and

- outstanding exceptions have owner, risk, remediation date, and expiry.

---

# 9. Decommission checklist

The legacy system should first become **read-only and non-authoritative**, then be removed only after evidence confirms that endpoint credentials, writes, buffers, schedules, portal functions, and retained data have been handled.

| Check                                              | Required proof                                                                                                   | Owner               |
| -------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- | ------------------- |
| ☐ Freeze legacy feature/config changes             | Approved freeze record and emergency exception process                                                           | PO, Change          |
| ☐ Inventory all endpoint installations             | Device list with version, path, service/task/schedule, credential-file presence, and last contact                | Endpoint            |
| ☐ Inventory all legacy portal functions            | Each page/action mapped to preserve, change, retire, or historical read-only                                     | PO, Portal          |
| ☐ Inventory external consumers                     | Database audit, query logs, jobs, reports, exports, and owner for each consumer                                  | Data                |
| ☐ Disable creation of new legacy scripts/schedules | Portal mutation removed; database permission denied; audit confirms no new rows                                  | Security, Portal    |
| ☐ Stop legacy policy mutations                     | Global/user settings and exclusions become read-only at agreed cutover                                           | PO, Data            |
| ☐ Inventory endpoint CSV/memory buffers            | Each known device classified as empty, drained, quarantined, unreachable, or approved loss                       | Endpoint, Data      |
| ☐ Drain buffers safely                             | Structured converter/reconciliation record; no blind SQL execution                                               | Data, Security      |
| ☐ Freeze and snapshot legacy checkpoints           | Signed checkpoint snapshot and final accepted-event range                                                        | Data                |
| ☐ Stop legacy endpoint collection                  | Service/task/scheduled launch disabled; process absence verified                                                 | Endpoint            |
| ☐ Stop direct database writes                      | Database permissions revoked; firewall/network path denied; database audit shows zero endpoint writes            | Security, DBA       |
| ☐ Revoke endpoint SQL credentials                  | Login disabled/deleted, shared secret rotated where necessary, credential use alarms checked                     | Security, DBA       |
| ☐ Remove local credential material                 | Managed endpoint scan finds no legacy credential file, embedded key artefact, or command-line deployment secret  | Endpoint, Security  |
| ☐ Remove legacy binaries and helpers               | Uninstall evidence covers executable, scripts, SQLite helper, updater, logs per retention, and scheduled tasks   | Endpoint            |
| ☐ Disable forced self-launch mechanisms            | No startup item, scheduled task, service recovery, or old deployment assignment can reinstall/start legacy code  | Endpoint            |
| ☐ Put legacy database in governed read-only mode   | Write-deny test, named archive owner, restricted access, monitoring                                              | DBA, Records        |
| ☐ Preserve required historical data                | Archive manifest, classification, encryption, retention, access model, and restore test                          | Data, Records       |
| ☐ Delete data no longer approved                   | Destruction report covering tables, staging, exports, local logs, and backups according to schedule              | Privacy, Records    |
| ☐ Convert legacy portal to historical read-only    | No AD mutation, start/stop, deletion, settings, exclusions, scripts, or schedules remain callable                | Portal, Security    |
| ☐ Retire legacy portal                             | Usage review, replacement links, support communication, access revocation                                        | PO, Portal          |
| ☐ Verify new portal function coverage              | Required workflows pass acceptance or have explicit retirement decision                                          | PO                  |
| ☐ Verify support and incident ownership            | Legacy incidents no longer route to unowned components                                                           | Support, Operations |
| ☐ Verify backup and restore                        | Final legacy archive restores and key reports execute in isolation                                               | Data                |
| ☐ Record unreachable exceptions                    | Each offline/lost device has risk owner, expiry, and remediation on next contact                                 | Endpoint, Security  |
| ☐ Monitor for residual activity                    | **Proposed:** 14 days with zero legacy endpoint DB connections/writes and 30 days without legacy operational use | Operations          |
| ☐ Revoke residual accounts and roles               | PSU/service accounts, vault entries, DB roles, deployment rights, and group capabilities removed or re-scoped    | IAM, Security       |
| ☐ Update architecture and CMDB                     | New ownership, dependencies, data stores, retention, recovery and support records                                | Architecture        |
| ☐ Final sign-off                                   | Service, PO, Privacy, Security, Data, Operations, Records, and Support approvals                                 | Service owner       |

**Rollback after credential revocation must never mean restoring central database credentials to endpoints.** A rollback may temporarily restore the last approved legacy application in read-only mode or restore the new agent’s previous version, but the insecure endpoint-to-database trust boundary remains retired.

---

# 10. Definitions of Ready and Done

## Definition of Ready: first Browser History vertical slice

The Browser History slice is Ready for implementation only when every applicable row is complete.

| Ready gate                     | Required evidence                                                                                     |
| ------------------------------ | ----------------------------------------------------------------------------------------------------- |
| ☐ Approved outcome             | Named use case, consumer, and product owner                                                           |
| ☐ Approved data scope          | Decision on domain, URL components, title, browser/profile identifiers, device/user linkage           |
| ☐ Privacy decision             | Purpose, legal assessment, minimisation, access, pilot retention, notice/consultation/DPIA assessment |
| ☐ Browser support              | Approved Edge/Chrome/Firefox versions and profile/session scope                                       |
| ☐ First-run behaviour          | Approved initial lookback and no-checkpoint handling                                                  |
| ☐ Source-time contract         | WebKit/Unix conversions, UTC canonical form, source precision, DST tests                              |
| ☐ Event schema                 | Versioned Browser event, error, health, and comparison-summary schemas                                |
| ☐ Policy schema                | Typed browser policy, rule semantics, precedence, expiry, minimum agent version                       |
| ☐ Filtering design             | Endpoint-side domain reduction, query/fragment handling, allowlist, sensitive-value tests             |
| ☐ Profile/checkpoint model     | Per-source/profile cursor and atomic event/checkpoint invariant                                       |
| ☐ Outbox/API contract          | Transactional write, batch format, compression limits, idempotency, acknowledgment                    |
| ☐ Security design              | Device identity, tenant binding, TLS, package/policy signing, anti-replay, secret ownership           |
| ☐ Source-consistency prototype | Locked DB, WAL, live writes, corrupt DB, profile removal, browser update                              |
| ☐ Failure isolation            | Schema mismatch, poison event, local disk full, server offline, worker failure                        |
| ☐ Test fixtures                | Synthetic, non-sensitive corpus with expected detailed/minimized/filtered outputs                     |
| ☐ Legacy baseline              | Frozen legacy policy, rules, checkpoints, normalization, and known-defect list                        |
| ☐ Comparison plan              | Digest design, tolerances, cohort, retention, discrepancy workflow                                    |
| ☐ Resource budget              | Proposed CPU, memory, disk, network thresholds and measurement method                                 |
| ☐ Pilot plan                   | Named devices/users, support window, consent/notice where applicable, rollback authority              |
| ☐ Observability                | Health counters, fleet dashboard, alerts, correlation IDs                                             |
| ☐ Runbooks                     | Browser source failure, outbox growth, bad policy, bad update, checkpoint anomaly                     |
| ☐ Owner approval               | PO, Privacy, Security, Endpoint, Platform, Data, Operations, Support                                  |

## Definition of Done: production rollout

Production rollout is Done only when:

| Done gate               | Required evidence                                                                                               |
| ----------------------- | --------------------------------------------------------------------------------------------------------------- |
| ☐ Requirements          | All P0 and P1 requirements accepted or formally waived by the correct risk owner                                |
| ☐ Functional acceptance | Approved Browser, Recent, Process, and retained task/portal functions pass tests                                |
| ☐ Privacy               | Field register, minimisation, retention, deletion, access, transparency, and required assessment complete       |
| ☐ Security              | Threat model accepted; no unresolved critical/high release blocker; signing and key operations exercised        |
| ☐ Reliability           | Power loss, reboot, sleep, locked source, disk bound, server outage, duplicate, poison, and rollback tests pass |
| ☐ Scale                 | At least 6,000-endpoint model tested using measured event sizes/rates and reconnect scenarios                   |
| ☐ Capacity headroom     | API, queue/workers, database, storage, partitions, retention and backups meet approved limits                   |
| ☐ Data contracts        | Versioned schemas, normalization, provenance, aggregate semantics, and consumer contracts baselined             |
| ☐ Parallel run          | All exact invariants pass; statistical tolerances pass; every material mismatch is dispositioned                |
| ☐ Reporting             | Required operational and business reports accepted by named owners                                              |
| ☐ Portal                | Capability authorization, masking, export, policy workflow, rules, errors, audit, and bulk-action tests pass    |
| ☐ Deployment            | Signed release completed through all rings; bake periods and health gates accepted                              |
| ☐ Coverage              | At least the approved managed-fleet target is healthy; all exceptions have owner and expiry                     |
| ☐ Monitoring            | Fleet, API, queue, DB, data-quality, security, privacy, retention, and backup alerts operational                |
| ☐ Restore               | Isolated restore completed within approved objectives and validated at application/report level                 |
| ☐ Operations            | Game days complete; on-call, SLOs, runbooks, kill switches, and rollback available                              |
| ☐ Support               | L1/L2 training, diagnostic bundle, KB, escalation and support objectives accepted                               |
| ☐ Retention/deletion    | Scheduled jobs running; missed-deletion alert and evidence report demonstrated                                  |
| ☐ Legacy writes         | Legacy endpoint and portal mutation paths disabled; zero unauthorized writes observed                           |
| ☐ Legacy buffers        | Drained, quarantined, or explicitly dispositioned for every reachable endpoint                                  |
| ☐ Legacy credentials    | Database logins revoked; endpoint credential artefacts removed; network path blocked                            |
| ☐ Historical estate     | Required history is read-only, encrypted, access-controlled, retained, restorable, and owned                    |
| ☐ Decommission          | Checklist complete, or a time-bounded residual read-only exception is formally approved                         |
| ☐ Final acceptance      | Service owner, PO, Privacy, Security, Data, Operations, Records, Support, and Change sign-off                   |

The resulting transition preserves proven and approved UAM outcomes while explicitly refusing to copy uncertain privacy scope, ambiguous reporting semantics, executable legacy buffers, arbitrary scripts, endpoint database trust, or inherited administrative authority into the replacement.
