# ChatGPT Project files and per-chat allowlists

## One-time Project setup

Upload exactly these seven sanitized files from `research-packs/implementation/attachments/` to the ChatGPT Project:

- [`00-accepted-baseline-attachment.md`](attachments/00-accepted-baseline-attachment.md)
- [`01-existing-system-evidence-summary.md`](attachments/01-existing-system-evidence-summary.md)
- [`02-sanitized-application-catalogue-report.md`](attachments/02-sanitized-application-catalogue-report.md)
- [`03-sanitized-windows-lab-capability.md`](attachments/03-sanitized-windows-lab-capability.md)
- [`04-data-and-schema-evidence-summary.md`](attachments/04-data-and-schema-evidence-summary.md)
- [`05-decisions-contradictions-and-gates.md`](attachments/05-decisions-contradictions-and-gates.md)
- [`06-research-evidence-rules.md`](attachments/06-research-evidence-rules.md)

Do not upload the raw application catalogue, `.ssh` files, the older full code reference, source files, production data, confidential SQL, or internal configuration. The prompts themselves may be pasted into their chats; they do not need to be Project attachments.

The Project contains a shared pool, but each prompt has a strict file allowlist. The web researcher must not use a Project file merely because it is available.

## Topic-chat allowlists

| Topic | Prompt | Only Project files this chat may read |
| ---: | --- | --- |
| 01 | [G0 dummy-data and test-oracle architecture](batch-01-foundations/01-PROMPT-g0-dummy-data-test-oracle.md) | `00-accepted-baseline-attachment.md`<br>`02-sanitized-application-catalogue-report.md`<br>`04-data-and-schema-evidence-summary.md`<br>`06-research-evidence-rules.md` |
| 02 | [G1 Windows Coordinator, User Host, Task Host, session identity, and IPC blueprint](batch-01-foundations/02-PROMPT-g1-windows-runtime-ipc.md) | `00-accepted-baseline-attachment.md`<br>`01-existing-system-evidence-summary.md`<br>`03-sanitized-windows-lab-capability.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md` |
| 03 | [Contract, compatibility, and versioning strategy](batch-01-foundations/03-PROMPT-contract-versioning.md) | `00-accepted-baseline-attachment.md`<br>`05-decisions-contradictions-and-gates.md`<br>`04-data-and-schema-evidence-summary.md`<br>`06-research-evidence-rules.md` |
| 04 | [Application registry, aliases, ownership, and URL/process matching](batch-01-foundations/04-PROMPT-application-registry-matching.md) | `00-accepted-baseline-attachment.md`<br>`02-sanitized-application-catalogue-report.md`<br>`04-data-and-schema-evidence-summary.md`<br>`06-research-evidence-rules.md` |
| 05 | [Product privacy ceiling and tenant-policy narrowing](batch-01-foundations/05-PROMPT-privacy-ceiling-tenant-policy.md) | `00-accepted-baseline-attachment.md`<br>`05-decisions-contradictions-and-gates.md`<br>`02-sanitized-application-catalogue-report.md`<br>`06-research-evidence-rules.md` |
| 06 | [Repository, solution, build, dependency, and CI architecture](batch-01-foundations/06-PROMPT-repository-build-ci.md) | `00-accepted-baseline-attachment.md`<br>`01-existing-system-evidence-summary.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md` |
| 07 | [G2/G3 Edge profile discovery, safe acquisition, source identity, and cursor correctness](batch-02-endpoint-data/07-PROMPT-g2-g3-edge-acquisition-cursor.md) | `00-accepted-baseline-attachment.md`<br>`01-existing-system-evidence-summary.md`<br>`03-sanitized-windows-lab-capability.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md`<br>`batch-01-review-result.md` |
| 08 | [G4 URL canonicalization, application matching, and endpoint privacy transformation](batch-02-endpoint-data/08-PROMPT-g4-url-privacy-transformation.md) | `00-accepted-baseline-attachment.md`<br>`02-sanitized-application-catalogue-report.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md`<br>`batch-01-review-result.md` |
| 09 | [G5 SQLite outbox, batching, receipts, encryption, migrations, and state machines](batch-03-durability-release-identity/09-PROMPT-g5-sqlite-outbox-state-machines.md) | `00-accepted-baseline-attachment.md`<br>`04-data-and-schema-evidence-summary.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md`<br>`batch-01-review-result.md`<br>`batch-02-review-result.md` |
| 10 | [Model-based, property-based, fault-injection, and invariant testing](batch-03-durability-release-identity/10-PROMPT-invariant-fault-testing.md) | `00-accepted-baseline-attachment.md`<br>`05-decisions-contradictions-and-gates.md`<br>`03-sanitized-windows-lab-capability.md`<br>`06-research-evidence-rules.md`<br>`batch-01-review-result.md`<br>`batch-02-review-result.md` |
| 11 | [MSI, enterprise deployment, updater, rollback, signing, TUF-style metadata, and supply chain](batch-03-durability-release-identity/11-PROMPT-release-updater-supply-chain.md) | `00-accepted-baseline-attachment.md`<br>`03-sanitized-windows-lab-capability.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md`<br>`batch-01-review-result.md`<br>`batch-02-review-result.md` |
| 12 | [Device enrollment, certificates, TPM, cloning, revocation, proxy, VPN, and realm identity](batch-03-durability-release-identity/12-PROMPT-device-identity-network.md) | `00-accepted-baseline-attachment.md`<br>`03-sanitized-windows-lab-capability.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md`<br>`batch-01-review-result.md`<br>`batch-02-review-result.md` |
| 13 | [Privacy-safe diagnostics, logging, support bundles, and temporary diagnostic access](batch-03-durability-release-identity/13-PROMPT-diagnostics-support.md) | `00-accepted-baseline-attachment.md`<br>`01-existing-system-evidence-summary.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md`<br>`batch-01-review-result.md`<br>`batch-02-review-result.md` |
| 14 | [Windows, browser, RDP/RDS, profile, ARM64, EDR, sleep, and compatibility policy](batch-03-durability-release-identity/14-PROMPT-windows-compatibility-policy.md) | `00-accepted-baseline-attachment.md`<br>`03-sanitized-windows-lab-capability.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md`<br>`batch-01-review-result.md`<br>`batch-02-review-result.md` |
| 15 | [Ingestion API, durable relational inbox, idempotency, leasing, quarantine, and materialization](batch-04-server-platform/15-PROMPT-ingestion-relational-inbox.md) | `00-accepted-baseline-attachment.md`<br>`04-data-and-schema-evidence-summary.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md`<br>`batch-01-review-result.md`<br>`batch-02-review-result.md`<br>`batch-03-review-result.md` |
| 16 | [PostgreSQL versus SQL Server experimental comparison](batch-04-server-platform/16-PROMPT-database-comparison-experiment.md) | `00-accepted-baseline-attachment.md`<br>`04-data-and-schema-evidence-summary.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md`<br>`batch-01-review-result.md`<br>`batch-02-review-result.md`<br>`batch-03-review-result.md` |
| 17 | [Capacity model, 6,000-device simulator, reconnect storms, recovery, and broker break-even](batch-04-server-platform/17-PROMPT-capacity-fleet-simulator.md) | `00-accepted-baseline-attachment.md`<br>`04-data-and-schema-evidence-summary.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md`<br>`batch-01-review-result.md`<br>`batch-02-review-result.md`<br>`batch-03-review-result.md` |
| 18 | [Retention, deletion, backup, restore, tombstones, exports, and integration deletion](batch-04-server-platform/18-PROMPT-retention-deletion-restore.md) | `00-accepted-baseline-attachment.md`<br>`04-data-and-schema-evidence-summary.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md`<br>`batch-01-review-result.md`<br>`batch-02-review-result.md`<br>`batch-03-review-result.md` |
| 19 | [Portal capability model, RBAC/ABAC, JIT access, approvals, and break-glass](batch-05-portal-governance/19-PROMPT-portal-authorization.md) | `00-accepted-baseline-attachment.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md`<br>`batch-01-review-result.md`<br>`batch-02-review-result.md`<br>`batch-03-review-result.md`<br>`batch-04-review-result.md` |
| 20 | [Portal information architecture and administrative workflows](batch-05-portal-governance/20-PROMPT-portal-information-workflows.md) | `00-accepted-baseline-attachment.md`<br>`02-sanitized-application-catalogue-report.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md`<br>`batch-01-review-result.md`<br>`batch-02-review-result.md`<br>`batch-03-review-result.md`<br>`batch-04-review-result.md` |
| 21 | [Transactional audit, tamper evidence, external verification, and audit access](batch-05-portal-governance/21-PROMPT-transactional-audit.md) | `00-accepted-baseline-attachment.md`<br>`04-data-and-schema-evidence-summary.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md`<br>`batch-01-review-result.md`<br>`batch-02-review-result.md`<br>`batch-03-review-result.md`<br>`batch-04-review-result.md` |
| 22 | [Legacy consumer, report, script, schedule, credential, buffer, and integration discovery](batch-06-migration/22-PROMPT-legacy-discovery.md) | `00-accepted-baseline-attachment.md`<br>`01-existing-system-evidence-summary.md`<br>`04-data-and-schema-evidence-summary.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md`<br>`batch-01-review-result.md`<br>`batch-02-review-result.md`<br>`batch-03-review-result.md`<br>`batch-04-review-result.md`<br>`batch-05-review-result.md` |
| 23 | [Parallel-run comparison, reconciliation, compatibility projection, and migration validation](batch-06-migration/23-PROMPT-parallel-run-reconciliation.md) | `00-accepted-baseline-attachment.md`<br>`01-existing-system-evidence-summary.md`<br>`04-data-and-schema-evidence-summary.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md`<br>`batch-01-review-result.md`<br>`batch-02-review-result.md`<br>`batch-03-review-result.md`<br>`batch-04-review-result.md`<br>`batch-05-review-result.md` |
| 24 | [Cutover, rollback, legacy read-only operation, credential removal, monitoring, and decommissioning](batch-06-migration/24-PROMPT-cutover-decommission.md) | `00-accepted-baseline-attachment.md`<br>`01-existing-system-evidence-summary.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md`<br>`batch-01-review-result.md`<br>`batch-02-review-result.md`<br>`batch-03-review-result.md`<br>`batch-04-review-result.md`<br>`batch-05-review-result.md` |

## Batch-review allowlists

Before each batch review, add that batch's completed result files to the Project. Reviews from earlier batches remain available as accepted predecessor decisions. The reviewer may read only the files in its row.

| Batch | Prompt | Only Project files this reviewer may read |
| ---: | --- | --- |
| 01 | [Batch reviewer](batch-01-foundations/90-BATCH-01-REVIEW-PROMPT.md) | `01-g0-dummy-data-test-oracle-result.md`<br>`02-g1-windows-runtime-ipc-result.md`<br>`03-contract-versioning-result.md`<br>`04-application-registry-matching-result.md`<br>`05-privacy-ceiling-tenant-policy-result.md`<br>`06-repository-build-ci-result.md`<br>`00-accepted-baseline-attachment.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md` |
| 02 | [Batch reviewer](batch-02-endpoint-data/90-BATCH-02-REVIEW-PROMPT.md) | `07-g2-g3-edge-acquisition-cursor-result.md`<br>`08-g4-url-privacy-transformation-result.md`<br>`batch-01-review-result.md`<br>`00-accepted-baseline-attachment.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md` |
| 03 | [Batch reviewer](batch-03-durability-release-identity/90-BATCH-03-REVIEW-PROMPT.md) | `09-g5-sqlite-outbox-state-machines-result.md`<br>`10-invariant-fault-testing-result.md`<br>`11-release-updater-supply-chain-result.md`<br>`12-device-identity-network-result.md`<br>`13-diagnostics-support-result.md`<br>`14-windows-compatibility-policy-result.md`<br>`batch-01-review-result.md`<br>`batch-02-review-result.md`<br>`00-accepted-baseline-attachment.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md` |
| 04 | [Batch reviewer](batch-04-server-platform/90-BATCH-04-REVIEW-PROMPT.md) | `15-ingestion-relational-inbox-result.md`<br>`16-database-comparison-experiment-result.md`<br>`17-capacity-fleet-simulator-result.md`<br>`18-retention-deletion-restore-result.md`<br>`batch-01-review-result.md`<br>`batch-02-review-result.md`<br>`batch-03-review-result.md`<br>`00-accepted-baseline-attachment.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md` |
| 05 | [Batch reviewer](batch-05-portal-governance/90-BATCH-05-REVIEW-PROMPT.md) | `19-portal-authorization-result.md`<br>`20-portal-information-workflows-result.md`<br>`21-transactional-audit-result.md`<br>`batch-01-review-result.md`<br>`batch-02-review-result.md`<br>`batch-03-review-result.md`<br>`batch-04-review-result.md`<br>`00-accepted-baseline-attachment.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md` |
| 06 | [Batch reviewer](batch-06-migration/90-BATCH-06-REVIEW-PROMPT.md) | `22-legacy-discovery-result.md`<br>`23-parallel-run-reconciliation-result.md`<br>`24-cutover-decommission-result.md`<br>`batch-01-review-result.md`<br>`batch-02-review-result.md`<br>`batch-03-review-result.md`<br>`batch-04-review-result.md`<br>`batch-05-review-result.md`<br>`00-accepted-baseline-attachment.md`<br>`05-decisions-contradictions-and-gates.md`<br>`06-research-evidence-rules.md` |

## Final-synthesis allowlist

Before final synthesis, add the six accepted batch-review results. The final chat may read only:

- `batch-01-review-result.md`
- `batch-02-review-result.md`
- `batch-03-review-result.md`
- `batch-04-review-result.md`
- `batch-05-review-result.md`
- `batch-06-review-result.md`
- `00-accepted-baseline-attachment.md`
- `06-research-evidence-rules.md`

Individual topic results are deliberately excluded: each batch reviewer is the evidence-quality boundary. Measured CLI evidence is excluded by default. If approved sanitized CLI evidence is needed, add its exact filename to the final prompt's allowlist before running it.
