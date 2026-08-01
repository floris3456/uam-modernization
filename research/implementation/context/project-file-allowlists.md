# ChatGPT Project files and per-chat allowlists

## One-time Project setup

Upload exactly these seven sanitized files from `research/implementation/attachments/` to the ChatGPT Project:

- [`accepted-baseline.md`](../attachments/accepted-baseline.md)
- [`existing-system.md`](../attachments/existing-system.md)
- [`application-catalogue.md`](../attachments/application-catalogue.md)
- [`windows-lab.md`](../attachments/windows-lab.md)
- [`data-schema.md`](../attachments/data-schema.md)
- [`decisions-and-gates.md`](../attachments/decisions-and-gates.md)
- [`evidence-rules.md`](../attachments/evidence-rules.md)

Do not upload the raw application catalogue, `.ssh` files, the older full code reference, source files, production data, confidential SQL, or internal configuration. The prompts themselves may be pasted into their chats; they do not need to be Project attachments.

The Project contains a shared pool, but each prompt has a strict file allowlist. The web researcher must not use a Project file merely because it is available.

## Topic-chat allowlists

| Topic | Prompt | Only Project files this chat may read |
| ---: | --- | --- |
| 01 | [G0 dummy-data and test-oracle architecture](../batches/01-foundations/01-g0-dummy-data-test-oracle/prompt.md) | `accepted-baseline.md`<br>`application-catalogue.md`<br>`data-schema.md`<br>`evidence-rules.md` |
| 02 | [G1 Windows Coordinator, User Host, Task Host, session identity, and IPC blueprint](../batches/01-foundations/02-g1-windows-runtime-ipc/prompt.md) | `accepted-baseline.md`<br>`existing-system.md`<br>`windows-lab.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md` |
| 03 | [Contract, compatibility, and versioning strategy](../batches/01-foundations/03-contract-versioning/prompt.md) | `accepted-baseline.md`<br>`decisions-and-gates.md`<br>`data-schema.md`<br>`evidence-rules.md` |
| 04 | [Application registry, aliases, ownership, and URL/process matching](../batches/01-foundations/04-application-registry-matching/prompt.md) | `accepted-baseline.md`<br>`application-catalogue.md`<br>`data-schema.md`<br>`evidence-rules.md` |
| 05 | [Product privacy ceiling and tenant-policy narrowing](../batches/01-foundations/05-privacy-ceiling-tenant-policy/prompt.md) | `accepted-baseline.md`<br>`decisions-and-gates.md`<br>`application-catalogue.md`<br>`evidence-rules.md` |
| 06 | [Repository, solution, build, dependency, and CI architecture](../batches/01-foundations/06-repository-build-ci/prompt.md) | `accepted-baseline.md`<br>`existing-system.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md` |
| 07 | [G2/G3 Edge profile discovery, safe acquisition, source identity, and cursor correctness](../batches/02-endpoint-data/07-g2-g3-edge-acquisition-cursor/prompt.md) | `accepted-baseline.md`<br>`existing-system.md`<br>`windows-lab.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md`<br>`result-review-01-foundations.md` |
| 08 | [G4 URL canonicalization, application matching, and endpoint privacy transformation](../batches/02-endpoint-data/08-g4-url-privacy-transformation/prompt.md) | `accepted-baseline.md`<br>`application-catalogue.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md`<br>`result-review-01-foundations.md` |
| 09 | [G5 SQLite outbox, batching, receipts, encryption, migrations, and state machines](../batches/03-durability-release-identity/09-g5-sqlite-outbox-state-machines/prompt.md) | `accepted-baseline.md`<br>`data-schema.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md`<br>`result-review-01-foundations.md`<br>`result-review-02-endpoint-data.md` |
| 10 | [Model-based, property-based, fault-injection, and invariant testing](../batches/03-durability-release-identity/10-invariant-fault-testing/prompt.md) | `accepted-baseline.md`<br>`decisions-and-gates.md`<br>`windows-lab.md`<br>`evidence-rules.md`<br>`result-review-01-foundations.md`<br>`result-review-02-endpoint-data.md` |
| 11 | [MSI, enterprise deployment, updater, rollback, signing, TUF-style metadata, and supply chain](../batches/03-durability-release-identity/11-release-updater-supply-chain/prompt.md) | `accepted-baseline.md`<br>`windows-lab.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md`<br>`result-review-01-foundations.md` |
| 12 | [Device enrollment, certificates, TPM, cloning, revocation, proxy, VPN, and realm identity](../batches/03-durability-release-identity/12-device-identity-network/prompt.md) | `accepted-baseline.md`<br>`windows-lab.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md`<br>`result-review-01-foundations.md` |
| 13 | [Privacy-safe diagnostics, logging, support bundles, and temporary diagnostic access](../batches/03-durability-release-identity/13-diagnostics-support/prompt.md) | `accepted-baseline.md`<br>`existing-system.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md`<br>`result-review-01-foundations.md` |
| 14 | [Windows, browser, RDP/RDS, profile, ARM64, EDR, sleep, and compatibility policy](../batches/03-durability-release-identity/14-windows-compatibility-policy/prompt.md) | `accepted-baseline.md`<br>`windows-lab.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md`<br>`result-review-01-foundations.md`<br>`result-review-02-endpoint-data.md` |
| 15 | [Ingestion API, durable relational inbox, idempotency, leasing, quarantine, and materialization](../batches/04-server-platform/15-ingestion-relational-inbox/prompt.md) | `accepted-baseline.md`<br>`data-schema.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md`<br>`result-review-01-foundations.md`<br>`result-review-02-endpoint-data.md`<br>`result-review-03-durability-release-identity.md` |
| 16 | [PostgreSQL versus SQL Server experimental comparison](../batches/04-server-platform/16-database-comparison-experiment/prompt.md) | `accepted-baseline.md`<br>`data-schema.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md`<br>`result-review-01-foundations.md`<br>`result-review-02-endpoint-data.md`<br>`result-review-03-durability-release-identity.md` |
| 17 | [Capacity model, 6,000-device simulator, reconnect storms, recovery, and broker break-even](../batches/04-server-platform/17-capacity-fleet-simulator/prompt.md) | `accepted-baseline.md`<br>`data-schema.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md`<br>`result-review-01-foundations.md`<br>`result-review-02-endpoint-data.md`<br>`result-review-03-durability-release-identity.md` |
| 18 | [Retention, deletion, backup, restore, tombstones, exports, and integration deletion](../batches/04-server-platform/18-retention-deletion-restore/prompt.md) | `accepted-baseline.md`<br>`data-schema.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md`<br>`result-review-01-foundations.md`<br>`result-review-02-endpoint-data.md`<br>`result-review-03-durability-release-identity.md` |
| 19 | [Portal capability model, RBAC/ABAC, JIT access, approvals, and break-glass](../batches/05-portal-governance/19-portal-authorization/prompt.md) | `accepted-baseline.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md`<br>`result-review-01-foundations.md`<br>`result-review-02-endpoint-data.md`<br>`result-review-03-durability-release-identity.md`<br>`result-review-04-server-platform.md` |
| 20 | [Portal information architecture and administrative workflows](../batches/05-portal-governance/20-portal-information-workflows/prompt.md) | `accepted-baseline.md`<br>`application-catalogue.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md`<br>`result-review-01-foundations.md`<br>`result-review-02-endpoint-data.md`<br>`result-review-03-durability-release-identity.md`<br>`result-review-04-server-platform.md` |
| 21 | [Transactional audit, tamper evidence, external verification, and audit access](../batches/05-portal-governance/21-transactional-audit/prompt.md) | `accepted-baseline.md`<br>`data-schema.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md`<br>`result-review-01-foundations.md`<br>`result-review-02-endpoint-data.md`<br>`result-review-03-durability-release-identity.md`<br>`result-review-04-server-platform.md` |
| 22 | [Legacy consumer, report, script, schedule, credential, buffer, and integration discovery](../batches/06-migration/22-legacy-discovery/prompt.md) | `accepted-baseline.md`<br>`existing-system.md`<br>`data-schema.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md`<br>`result-review-01-foundations.md` |
| 23 | [Parallel-run comparison, reconciliation, compatibility projection, and migration validation](../batches/06-migration/23-parallel-run-reconciliation/prompt.md) | `accepted-baseline.md`<br>`existing-system.md`<br>`data-schema.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md`<br>`result-review-01-foundations.md`<br>`result-review-02-endpoint-data.md`<br>`result-review-03-durability-release-identity.md`<br>`result-review-04-server-platform.md`<br>`result-22-legacy-discovery.md` |
| 24 | [Cutover, rollback, legacy read-only operation, credential removal, monitoring, and decommissioning](../batches/06-migration/24-cutover-decommission/prompt.md) | `accepted-baseline.md`<br>`existing-system.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md`<br>`result-review-01-foundations.md`<br>`result-review-02-endpoint-data.md`<br>`result-review-03-durability-release-identity.md`<br>`result-review-04-server-platform.md`<br>`result-review-05-portal-governance.md`<br>`result-22-legacy-discovery.md`<br>`result-23-parallel-run-reconciliation.md` |

## Batch-review allowlists

Before each batch review, add that batch's completed result files to the Project. Reviews from earlier batches remain available as accepted predecessor decisions. The reviewer may read only the files in its row.

| Batch | Prompt | Only Project files this reviewer may read |
| ---: | --- | --- |
| 01 | [Batch reviewer](../batches/01-foundations/review/prompt.md) | `result-01-g0-dummy-data-test-oracle.md`<br>`result-02-g1-windows-runtime-ipc.md`<br>`result-03-contract-versioning.md`<br>`result-04-application-registry-matching.md`<br>`result-05-privacy-ceiling-tenant-policy.md`<br>`result-06-repository-build-ci.md`<br>`accepted-baseline.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md` |
| 02 | [Batch reviewer](../batches/02-endpoint-data/review/prompt.md) | `result-07-g2-g3-edge-acquisition-cursor.md`<br>`result-08-g4-url-privacy-transformation.md`<br>`result-review-01-foundations.md`<br>`accepted-baseline.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md` |
| 03 | [Batch reviewer](../batches/03-durability-release-identity/review/prompt.md) | `result-09-g5-sqlite-outbox-state-machines.md`<br>`result-10-invariant-fault-testing.md`<br>`result-11-release-updater-supply-chain.md`<br>`result-12-device-identity-network.md`<br>`result-13-diagnostics-support.md`<br>`result-14-windows-compatibility-policy.md`<br>`result-review-01-foundations.md`<br>`result-review-02-endpoint-data.md`<br>`accepted-baseline.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md` |
| 04 | [Batch reviewer](../batches/04-server-platform/review/prompt.md) | `result-15-ingestion-relational-inbox.md`<br>`result-16-database-comparison-experiment.md`<br>`result-17-capacity-fleet-simulator.md`<br>`result-18-retention-deletion-restore.md`<br>`result-review-01-foundations.md`<br>`result-review-02-endpoint-data.md`<br>`result-review-03-durability-release-identity.md`<br>`accepted-baseline.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md` |
| 05 | [Batch reviewer](../batches/05-portal-governance/review/prompt.md) | `result-19-portal-authorization.md`<br>`result-20-portal-information-workflows.md`<br>`result-21-transactional-audit.md`<br>`result-review-01-foundations.md`<br>`result-review-02-endpoint-data.md`<br>`result-review-03-durability-release-identity.md`<br>`result-review-04-server-platform.md`<br>`accepted-baseline.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md` |
| 06 | [Batch reviewer](../batches/06-migration/review/prompt.md) | `result-22-legacy-discovery.md`<br>`result-23-parallel-run-reconciliation.md`<br>`result-24-cutover-decommission.md`<br>`result-review-01-foundations.md`<br>`result-review-02-endpoint-data.md`<br>`result-review-03-durability-release-identity.md`<br>`result-review-04-server-platform.md`<br>`result-review-05-portal-governance.md`<br>`accepted-baseline.md`<br>`decisions-and-gates.md`<br>`evidence-rules.md` |

## Final-synthesis allowlist

Before final synthesis, add the six accepted batch-review results. The final chat may read only:

- `result-review-01-foundations.md`
- `result-review-02-endpoint-data.md`
- `result-review-03-durability-release-identity.md`
- `result-review-04-server-platform.md`
- `result-review-05-portal-governance.md`
- `result-review-06-migration.md`
- `accepted-baseline.md`
- `evidence-rules.md`

Individual topic results are deliberately excluded: each batch reviewer is the evidence-quality boundary. Measured CLI evidence is excluded by default. If approved sanitized CLI evidence is needed, add its exact filename to the final prompt's allowlist before running it.
