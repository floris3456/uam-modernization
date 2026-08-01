# Prompt 05 — scale, reliability, and capacity

Act as a reliability and capacity engineer. Today is July 2026. Design a measurement-based capacity and resilience plan for UAM. Use primary technical sources and clearly label estimates. The attached `code-reference.md` provides legacy code/schema evidence, but no representative production event-rate dataset is supplied.

## Context

At least 6,000 Windows endpoints may upload minimized browser, process, recent-item, and extension events. Agents have a transactional SQLite outbox and use compressed idempotent HTTPS batches with retry/jitter/backpressure. Proposed server flow is API → durable queue → workers → partitioned PostgreSQL. Large reconnect waves after outages are expected. Detail retention should be shorter than aggregate retention.

## Research task

Determine which measurements are needed, create low/base/high scenarios without pretending unknown values are facts, and test whether the proposed topology is justified. Compare queue-based ingestion with a PostgreSQL inbox/outbox-first design and any simpler credible alternative.

Cover steady state, morning peaks, one-hour and multi-day client outages, 30-minute server outages, simultaneous policy updates, poison payloads, schema mismatch, duplicate batches, slow database, partition rollover, backup/restore, retention purge, and regional/site network constraints.

## Required output

1. Variable-based capacity model with formulas for events, bytes, compression, requests, local disk, queue depth, database growth, indexes, retention, and recovery time.
2. Low/base/high illustrative scenarios, with every assumed input highlighted and easy to replace.
3. Proposed SLOs/SLIs and error budgets for agent acceptance, ingestion, backlog recovery, data freshness, loss, duplication, and portal queries.
4. Batch-size, concurrency, retry, jitter, timeout, quota, and backpressure starting values—explicitly labelled test hypotheses.
5. Queue versus database-inbox decision matrix and break-even/complexity conditions.
6. Load-test architecture capable of simulating 6,000+ agents, including traffic shapes, data safety, clocks, fault injection, observability, and reproducibility.
7. Test stages from laptop/VM through pre-production soak, with pass/fail gates.
8. Database partition/index/retention benchmark plan rather than an assumed final tuning.
9. Dashboard and alert specification.
10. Missing production measurements and the exact queries/instrumentation needed to obtain them safely.

Do not infer capacity from user count alone. Separate architectural correctness, performance, and cost conclusions.

