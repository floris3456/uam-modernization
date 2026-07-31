# Accepted decisions, contradictions, and proof gates

**Classification:** internal summary sanitized for an approved research chat.
**Source:** the July 2026 final synthesis of six prior research results; SHA-256 `acaee72712c9203a8827cc235b36b12fb3caf65136d64ea6f3cb9b80681cd5f1`.
**Generation:** deterministic curated extract by `scripts/generate-implementation-research-packs.mjs`.
**Limitation:** accepted for implementation research, not unconditional production approval.

## Strong agreements

- Windows endpoints use a low-privilege machine Coordinator Service, one ordinary-token User Host per eligible interactive session, and short-lived restricted Task Hosts for risky collection.
- The Coordinator does not crawl user profiles or create user tokens. User-owned sources are read in the user's session. Task Hosts are process boundaries, not arbitrary plugin or script channels.
- C#/.NET is the accepted default implementation family. Exact supported patches and fast-moving libraries are selected at execution time under lifecycle policy.
- A release-authorized product privacy ceiling limits sources, fields, transformations, destinations, and capabilities. Tenant policy may only narrow it.
- Minimization occurs before Coordinator IPC, durable storage, logs, diagnostics, or transport. Endpoints never receive central database credentials or submit SQL.
- SQLite WAL with one writer stores minimized events and source progress atomically. Delivery is at least once; stable identities and central uniqueness make the business effect idempotent.
- Uploads are bounded, versioned, authenticated, compressed HTTPS batches. A server receipt means durable custody, not necessarily semantic acceptance or portal visibility.
- The initial server design is a modular monolith with an ingestion boundary, relational durable inbox, leased workers, typed facts/aggregates, control API/BFF, and integrations through governed contracts.
- No external broker is a default. Add one only after measured failure-domain, throughput, replay, fan-out, or cost conditions justify it.
- PostgreSQL is the target reference and SQL Server is a serious transition/fallback candidate; the production engine is selected by an identical benchmark plus operations, skills, licensing, and restore evidence.
- MSI and enterprise deployment own the stable privileged boundary. Any autonomous updater is optional, minimal, repository-authorized, rollback-safe, and separately justified.
- The first functional slice is Edge browser history at site/domain-level minimized output, using synthetic data until governance permits otherwise.

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
