# Batch 04 — Server ingestion, database, capacity, and data lifecycle

**Status:** complete
**Gate:** Durable receipt/idempotency must pass before endpoint deletion after ACK. Database, capacity, retention, RPO/RTO, and broker decisions require measured evidence and human approval.

## Studies

- [15 — Ingestion API, durable relational inbox, idempotency, leasing, quarantine, and materialization](15-ingestion-relational-inbox/README.md)
- [16 — PostgreSQL versus SQL Server experimental comparison](16-database-comparison-experiment/README.md)
- [17 — Capacity model, 6,000-device simulator, reconnect storms, recovery, and broker break-even](17-capacity-fleet-simulator/README.md)
- [18 — Retention, deletion, backup, restore, tombstones, exports, and integration deletion](18-retention-deletion-restore/README.md)

## Review

- [Reviewer prompt](review/prompt.md)
- [Accepted research review](review/result-review-04-server-platform.md)

Topic results remain evidence. The batch review is the accepted research handoff to dependent batches, but it does not replace human approval or CLI measurement.
