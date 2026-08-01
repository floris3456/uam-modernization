# Prompt 01 — architecture validation

You are a principal distributed-systems and Windows endpoint architect performing an adversarial design review. Today is July 2026. Use current web research and cite direct links to primary sources such as official documentation, standards, source repositories, and original engineering publications.

I attached `code-reference.md`. Read its introduction and inspect relevant code rather than trusting only this summary.

## Situation

UAM currently uses a large PowerShell Windows endpoint agent, direct MSSQL writes, CSV-deferred SQL, and a PowerShell Universal admin app. It collects approved browser-history, recent-item, and process events. The new design must support at least 6,000 Windows endpoints, outages, reconnect peaks, strict endpoint-side privacy filtering, safe signed updates, auditability, and customer-independent integrations.

The proposed replacement is: signed bootstrapper → .NET Windows Service → signed collector tasks → SQLite WAL transactional outbox → gzip/idempotent HTTPS batches → ingestion API → durable queue → workers → partitioned PostgreSQL → control-plane API and modern portal. Risky tasks run in a separate taskhost process. Endpoints never receive central database credentials.

## Research task

Determine whether this is the best defensible default architecture under these constraints. Do not validate it by default. Find design errors, unnecessary components, missing components, unsafe assumptions, and simpler or stronger alternatives.

Investigate at least:

- Windows Service lifecycle, per-user data access, multi-user devices, sleep/reboot, session boundaries, and least privilege.
- Bootstrapper/update ownership, signing, key rotation, atomic switch, health proof, rollback loops, downgrade/replay attacks, and recovery when the updater itself breaks.
- Task boundaries and whether in-process `AssemblyLoadContext` provides useful reliability or should be avoided in favour of process isolation.
- SQLite WAL durability, transaction design, corruption/recovery, encryption limits, disk quotas, outbox cleanup, checkpoint invariants, and long outages.
- HTTPS batching, device identity, idempotency lifetime, ordering, schema evolution, compression limits, retries, jitter, rate control, and poison payload handling.
- Whether a durable queue is justified at this scale; compare queue-less inbox/database designs and suitable queue choices.
- PostgreSQL partitioning versus SQL Server and other credible options, including operations, retention, bulk ingestion, reporting, and organizational skills.
- Control plane versus data plane separation, multi-tenancy, observability, disaster recovery, privacy deletion, and administrative audit.
- At least two materially different end-to-end alternative architectures.

## Required output

1. Executive verdict: keep, revise, or replace the proposal, with confidence.
2. A clear recommended architecture and text data-flow diagram.
3. Component decision table: proposed choice, verdict, recommended choice, reason, evidence, and validation needed.
4. At least 15 concrete failure scenarios, including detection, containment, recovery, and test method.
5. Security/privacy boundaries and data ownership.
6. Alternatives rejected and the conditions under which they would become preferable.
7. Decisions that cannot be made from documents alone and the smallest prototypes/measurements needed.
8. Measurable architecture acceptance criteria.
9. Proposed ADR list in priority order.
10. Sources, using current primary sources; note source date/version and any inference.

Separate facts, assumptions, recommendations, and unknowns. Do not call anything “bulletproof”; explain residual risk and how the design contains failures.

