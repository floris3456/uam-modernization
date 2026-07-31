# Next-generation UAM implementation research suite

This suite turns the July 2026 technical baseline into focused implementation research. It contains 24 topic prompts, six batch reviewers, one final synthesis, safe generated attachments, matching result targets, and automated validation.

## Current optimized launch order

Use the [optimized execution-wave README](execution-waves/README.md). It starts from the current position where Batch 2 research is nearly complete and safely overlaps independent Topics 11, 12, 13, and 22.

## First batch to run

Run these six chats in parallel, then run `batch-01-foundations/90-BATCH-01-REVIEW-PROMPT.md`:

- [01 — G0 dummy-data and test-oracle architecture](batch-01-foundations/01-PROMPT-g0-dummy-data-test-oracle.md)
- [02 — G1 Windows Coordinator, User Host, Task Host, session identity, and IPC blueprint](batch-01-foundations/02-PROMPT-g1-windows-runtime-ipc.md)
- [03 — Contract, compatibility, and versioning strategy](batch-01-foundations/03-PROMPT-contract-versioning.md)
- [04 — Application registry, aliases, ownership, and URL/process matching](batch-01-foundations/04-PROMPT-application-registry-matching.md)
- [05 — Product privacy ceiling and tenant-policy narrowing](batch-01-foundations/05-PROMPT-privacy-ceiling-tenant-policy.md)
- [06 — Repository, solution, build, dependency, and CI architecture](batch-01-foundations/06-PROMPT-repository-build-ci.md)

While they run, the CLI may profile evidence, prepare ADR/specification directories, prepare fictional seeds/canaries, inspect harmless Windows lab facts later under approval, and strengthen CI. Do not implement G1 identity/IPC security details until the batch review accepts them.

## Prompt index

| Topic | Batch | Prompt | Result target |
| ---: | ---: | --- | --- |
| 01 | 1 | [G0 dummy-data and test-oracle architecture](batch-01-foundations/01-PROMPT-g0-dummy-data-test-oracle.md) | `results/batch-01-foundations/01-g0-dummy-data-test-oracle-result.md` |
| 02 | 1 | [G1 Windows Coordinator, User Host, Task Host, session identity, and IPC blueprint](batch-01-foundations/02-PROMPT-g1-windows-runtime-ipc.md) | `results/batch-01-foundations/02-g1-windows-runtime-ipc-result.md` |
| 03 | 1 | [Contract, compatibility, and versioning strategy](batch-01-foundations/03-PROMPT-contract-versioning.md) | `results/batch-01-foundations/03-contract-versioning-result.md` |
| 04 | 1 | [Application registry, aliases, ownership, and URL/process matching](batch-01-foundations/04-PROMPT-application-registry-matching.md) | `results/batch-01-foundations/04-application-registry-matching-result.md` |
| 05 | 1 | [Product privacy ceiling and tenant-policy narrowing](batch-01-foundations/05-PROMPT-privacy-ceiling-tenant-policy.md) | `results/batch-01-foundations/05-privacy-ceiling-tenant-policy-result.md` |
| 06 | 1 | [Repository, solution, build, dependency, and CI architecture](batch-01-foundations/06-PROMPT-repository-build-ci.md) | `results/batch-01-foundations/06-repository-build-ci-result.md` |
| 07 | 2 | [G2/G3 Edge profile discovery, safe acquisition, source identity, and cursor correctness](batch-02-endpoint-data/07-PROMPT-g2-g3-edge-acquisition-cursor.md) | `results/batch-02-endpoint-data/07-g2-g3-edge-acquisition-cursor-result.md` |
| 08 | 2 | [G4 URL canonicalization, application matching, and endpoint privacy transformation](batch-02-endpoint-data/08-PROMPT-g4-url-privacy-transformation.md) | `results/batch-02-endpoint-data/08-g4-url-privacy-transformation-result.md` |
| 09 | 3 | [G5 SQLite outbox, batching, receipts, encryption, migrations, and state machines](batch-03-durability-release-identity/09-PROMPT-g5-sqlite-outbox-state-machines.md) | `results/batch-03-durability-release-identity/09-g5-sqlite-outbox-state-machines-result.md` |
| 10 | 3 | [Model-based, property-based, fault-injection, and invariant testing](batch-03-durability-release-identity/10-PROMPT-invariant-fault-testing.md) | `results/batch-03-durability-release-identity/10-invariant-fault-testing-result.md` |
| 11 | 3 | [MSI, enterprise deployment, updater, rollback, signing, TUF-style metadata, and supply chain](batch-03-durability-release-identity/11-PROMPT-release-updater-supply-chain.md) | `results/batch-03-durability-release-identity/11-release-updater-supply-chain-result.md` |
| 12 | 3 | [Device enrollment, certificates, TPM, cloning, revocation, proxy, VPN, and realm identity](batch-03-durability-release-identity/12-PROMPT-device-identity-network.md) | `results/batch-03-durability-release-identity/12-device-identity-network-result.md` |
| 13 | 3 | [Privacy-safe diagnostics, logging, support bundles, and temporary diagnostic access](batch-03-durability-release-identity/13-PROMPT-diagnostics-support.md) | `results/batch-03-durability-release-identity/13-diagnostics-support-result.md` |
| 14 | 3 | [Windows, browser, RDP/RDS, profile, ARM64, EDR, sleep, and compatibility policy](batch-03-durability-release-identity/14-PROMPT-windows-compatibility-policy.md) | `results/batch-03-durability-release-identity/14-windows-compatibility-policy-result.md` |
| 15 | 4 | [Ingestion API, durable relational inbox, idempotency, leasing, quarantine, and materialization](batch-04-server-platform/15-PROMPT-ingestion-relational-inbox.md) | `results/batch-04-server-platform/15-ingestion-relational-inbox-result.md` |
| 16 | 4 | [PostgreSQL versus SQL Server experimental comparison](batch-04-server-platform/16-PROMPT-database-comparison-experiment.md) | `results/batch-04-server-platform/16-database-comparison-experiment-result.md` |
| 17 | 4 | [Capacity model, 6,000-device simulator, reconnect storms, recovery, and broker break-even](batch-04-server-platform/17-PROMPT-capacity-fleet-simulator.md) | `results/batch-04-server-platform/17-capacity-fleet-simulator-result.md` |
| 18 | 4 | [Retention, deletion, backup, restore, tombstones, exports, and integration deletion](batch-04-server-platform/18-PROMPT-retention-deletion-restore.md) | `results/batch-04-server-platform/18-retention-deletion-restore-result.md` |
| 19 | 5 | [Portal capability model, RBAC/ABAC, JIT access, approvals, and break-glass](batch-05-portal-governance/19-PROMPT-portal-authorization.md) | `results/batch-05-portal-governance/19-portal-authorization-result.md` |
| 20 | 5 | [Portal information architecture and administrative workflows](batch-05-portal-governance/20-PROMPT-portal-information-workflows.md) | `results/batch-05-portal-governance/20-portal-information-workflows-result.md` |
| 21 | 5 | [Transactional audit, tamper evidence, external verification, and audit access](batch-05-portal-governance/21-PROMPT-transactional-audit.md) | `results/batch-05-portal-governance/21-transactional-audit-result.md` |
| 22 | 6 | [Legacy consumer, report, script, schedule, credential, buffer, and integration discovery](batch-06-migration/22-PROMPT-legacy-discovery.md) | `results/batch-06-migration/22-legacy-discovery-result.md` |
| 23 | 6 | [Parallel-run comparison, reconciliation, compatibility projection, and migration validation](batch-06-migration/23-PROMPT-parallel-run-reconciliation.md) | `results/batch-06-migration/23-parallel-run-reconciliation-result.md` |
| 24 | 6 | [Cutover, rollback, legacy read-only operation, credential removal, monitoring, and decommissioning](batch-06-migration/24-PROMPT-cutover-decommission.md) | `results/batch-06-migration/24-cutover-decommission-result.md` |

## Batch review and final sequence

- Batch 01: run `batch-01-foundations/90-BATCH-01-REVIEW-PROMPT.md` after its topic results; save to `results/batch-01-foundations/batch-01-review-result.md`.
- Batch 02: run `batch-02-endpoint-data/90-BATCH-02-REVIEW-PROMPT.md` after its topic results; save to `results/batch-02-endpoint-data/batch-02-review-result.md`.
- Batch 03: run `batch-03-durability-release-identity/90-BATCH-03-REVIEW-PROMPT.md` after its topic results; save to `results/batch-03-durability-release-identity/batch-03-review-result.md`.
- Batch 04: run `batch-04-server-platform/90-BATCH-04-REVIEW-PROMPT.md` after its topic results; save to `results/batch-04-server-platform/batch-04-review-result.md`.
- Batch 05: run `batch-05-portal-governance/90-BATCH-05-REVIEW-PROMPT.md` after its topic results; save to `results/batch-05-portal-governance/batch-05-review-result.md`.
- Batch 06: run `batch-06-migration/90-BATCH-06-REVIEW-PROMPT.md` after its topic results; save to `results/batch-06-migration/batch-06-review-result.md`.
- Final: attach all six accepted batch-review results and run [the final synthesis](final-synthesis/99-FINAL-SYNTHESIS-PROMPT.md); save to `results/final-synthesis/next-generation-technical-baseline-result.md`.

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
