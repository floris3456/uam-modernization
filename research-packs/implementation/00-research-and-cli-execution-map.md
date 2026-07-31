# Research and CLI execution map

| Batch | Research | Parallel timing | CLI work while research runs | Gate |
| --- | --- | --- | --- | --- |
| 01 | Immediate pre-implementation foundations | Run first. Prompts 01–06 may run in parallel, then run the batch reviewer. | Profile evidence; prepare decision/ADR templates; prepare the Windows lab without connecting; create fictional identity seeds; establish repository quality gates. Do not implement G1 security details until prompt 02 is reviewed. | Accept the G0 data contract, G1 blueprint, contract rules, application identity model, privacy ceiling, and repository boundaries before production-shaped endpoint code. |
| 02 | Endpoint source and privacy transformation | May run while G1 is implemented. Prompts 07–08 may run in parallel after the Batch 1 accepted baseline is available. | Implement and test G1; create synthetic Edge profiles and localhost fixtures; build a canary corpus; collect no real activity data. | G1 must pass before integrating live source acquisition. G2/G3 and G4 must pass before any source value enters the production outbox. |
| 03 | Durability, testing, release, identity, diagnostics, and compatibility | May run while G2–G5 prototypes are built. Prompts 09–14 can run in parallel but must consume accepted Batch 1–2 decisions. | Finish source/privacy prototypes; prepare crash, reboot, disk-pressure, certificate, proxy, package-tamper, and compatibility harnesses; keep production credentials and data out. | Outbox invariants, update authorization, device identity, privacy-safe support, and the initial supported-platform claim must pass before an engineering canary. |
| 04 | Server ingestion, database, capacity, and data lifecycle | Run after endpoint contracts are stable enough to simulate. Prompts 15–18 may run in parallel; database choice remains measurement-gated. | Build a contract-accurate endpoint simulator; prepare isolated PostgreSQL and SQL Server candidates; implement synthetic poison/replay workloads; gather metadata-only distributions when approved. | Durable receipt/idempotency must pass before endpoint deletion after ACK. Database, capacity, retention, RPO/RTO, and broker decisions require measured evidence and human approval. |
| 05 | Portal authorization, workflows, and audit | Run once control-plane concepts and data classifications are stable. Prompts 19–21 may run in parallel. | Prepare API authorization test scaffolding, synthetic personas, accessibility tooling, and audit fixtures; do not encode final roles before owners approve them. | Capability authorization, purpose-bound access, transactional audit, accessibility, and break-glass controls must pass before administrative production use. |
| 06 | Legacy discovery, parallel validation, cutover, and decommissioning | Run after the new contracts and first vertical slice are understood. Prompts 22–24 may run in parallel, then reconcile them. | Inventory consumers and credentials read-only; build comparison digests with synthetic fixtures; monitor legacy paths; never execute deferred legacy SQL or disable production paths during research. | Named owners must approve every consumer/configuration disposition, reconciliation result, rollback boundary, credential removal, and final decommission action. |

## Dependency handoff

After accepting each batch review, add its named result file to the ChatGPT Project. Every topic and reviewer in later batches explicitly includes all earlier batch-review results in its Project-file allowlist. This is how accepted decisions flow forward; shared attachments alone are not the evolving baseline.

## Human-only decision lane

Across all batches, named humans must approve purpose, prohibited uses, field/identity scope, role ownership, retention, access, consultation/legal assessment, budget/licensing, SLO/RPO/RTO, production support, risk acceptance, migration/cutover, and decommissioning. Research supplies options and consequences; CLI supplies evidence; neither supplies authority.

## Measurement lane

Windows/session/browser behavior, SQLite fault safety, updater recovery, PKI/proxy compatibility, resource use, production rates, database performance, restore/deletion, accessibility, supportability, and migration reconciliation are established by reproducible CLI/lab evidence—not additional prose.
