# Implementation research

**Status:** complete — 24 studies, 6 batch reviews, and one final synthesis.

## Read in this order

1. [Final technical baseline](synthesis/result-implementation-technical-baseline.md)
2. The relevant [batch review](batches/)
3. An individual study only when its detailed evidence is needed

## Study index

| Study | Batch | Folder |
| ---: | ---: | --- |
| 01 | 01 | [G0 dummy-data and test-oracle architecture](batches/01-foundations/01-g0-dummy-data-test-oracle/README.md) |
| 02 | 01 | [G1 Windows Coordinator, User Host, Task Host, session identity, and IPC blueprint](batches/01-foundations/02-g1-windows-runtime-ipc/README.md) |
| 03 | 01 | [Contract, compatibility, and versioning strategy](batches/01-foundations/03-contract-versioning/README.md) |
| 04 | 01 | [Application registry, aliases, ownership, and URL/process matching](batches/01-foundations/04-application-registry-matching/README.md) |
| 05 | 01 | [Product privacy ceiling and tenant-policy narrowing](batches/01-foundations/05-privacy-ceiling-tenant-policy/README.md) |
| 06 | 01 | [Repository, solution, build, dependency, and CI architecture](batches/01-foundations/06-repository-build-ci/README.md) |
| 07 | 02 | [G2/G3 Edge profile discovery, safe acquisition, source identity, and cursor correctness](batches/02-endpoint-data/07-g2-g3-edge-acquisition-cursor/README.md) |
| 08 | 02 | [G4 URL canonicalization, application matching, and endpoint privacy transformation](batches/02-endpoint-data/08-g4-url-privacy-transformation/README.md) |
| 09 | 03 | [G5 SQLite outbox, batching, receipts, encryption, migrations, and state machines](batches/03-durability-release-identity/09-g5-sqlite-outbox-state-machines/README.md) |
| 10 | 03 | [Model-based, property-based, fault-injection, and invariant testing](batches/03-durability-release-identity/10-invariant-fault-testing/README.md) |
| 11 | 03 | [MSI, enterprise deployment, updater, rollback, signing, TUF-style metadata, and supply chain](batches/03-durability-release-identity/11-release-updater-supply-chain/README.md) |
| 12 | 03 | [Device enrollment, certificates, TPM, cloning, revocation, proxy, VPN, and realm identity](batches/03-durability-release-identity/12-device-identity-network/README.md) |
| 13 | 03 | [Privacy-safe diagnostics, logging, support bundles, and temporary diagnostic access](batches/03-durability-release-identity/13-diagnostics-support/README.md) |
| 14 | 03 | [Windows, browser, RDP/RDS, profile, ARM64, EDR, sleep, and compatibility policy](batches/03-durability-release-identity/14-windows-compatibility-policy/README.md) |
| 15 | 04 | [Ingestion API, durable relational inbox, idempotency, leasing, quarantine, and materialization](batches/04-server-platform/15-ingestion-relational-inbox/README.md) |
| 16 | 04 | [PostgreSQL versus SQL Server experimental comparison](batches/04-server-platform/16-database-comparison-experiment/README.md) |
| 17 | 04 | [Capacity model, 6,000-device simulator, reconnect storms, recovery, and broker break-even](batches/04-server-platform/17-capacity-fleet-simulator/README.md) |
| 18 | 04 | [Retention, deletion, backup, restore, tombstones, exports, and integration deletion](batches/04-server-platform/18-retention-deletion-restore/README.md) |
| 19 | 05 | [Portal capability model, RBAC/ABAC, JIT access, approvals, and break-glass](batches/05-portal-governance/19-portal-authorization/README.md) |
| 20 | 05 | [Portal information architecture and administrative workflows](batches/05-portal-governance/20-portal-information-workflows/README.md) |
| 21 | 05 | [Transactional audit, tamper evidence, external verification, and audit access](batches/05-portal-governance/21-transactional-audit/README.md) |
| 22 | 06 | [Legacy consumer, report, script, schedule, credential, buffer, and integration discovery](batches/06-migration/22-legacy-discovery/README.md) |
| 23 | 06 | [Parallel-run comparison, reconciliation, compatibility projection, and migration validation](batches/06-migration/23-parallel-run-reconciliation/README.md) |
| 24 | 06 | [Cutover, rollback, legacy read-only operation, credential removal, monitoring, and decommissioning](batches/06-migration/24-cutover-decommission/README.md) |

## Shared material

- [Context and workflow](context/workflow.md)
- [Evidence map](context/evidence-map.md)
- [Sanitized attachments](attachments/)

Each study keeps its prompt, result, and short index together. Each batch keeps its studies and review together.

## Validate

```bash
node scripts/validate-research.mjs
./scripts/validate-repository.sh
```

Research recommends and explains. ADRs record human decisions. CLI experiments provide project-specific proof.
