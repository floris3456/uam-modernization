# Shared accepted baseline

**Classification:** internal summary sanitized for an approved research chat.
**Source:** July 2026 final synthesis; SHA-256 `d456e5945d672d454a8d204a3d2b1ec1a9710aad865fea15a59d8cb42d408fa1`.
**Generation:** deterministic curated baseline produced by `scripts/generate-implementation-research.mjs` (retired 2026-08-07; file frozen).
**Status:** working baseline for implementation research; production authority remains gated.
**Limitation:** condensed decisions and gates, not full evidence, human approval, or runtime proof.
**Baseline date:** 31 July 2026.

## Accepted decisions

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
- UAM telemetry is fallible operational evidence, not sole forensic proof or an employee-productivity score.
- Legal purpose, prohibited uses, identity level, retention, access, employee consultation, budget, SLO/RPO/RTO, ownership, and production approval remain human decisions.

## Provisional and measurement-gated matters

- Exact event fields, identity/time precision, first-run lookback, hard-deny categories, role-to-application mapping, and production retention.
- Exact SQLite limits, encryption/key-wrapping choice, batch limits, retry values, resource budgets, and ACK replay grace.
- Device PKI integration, TPM coverage, proxy/VPN behavior, autonomous updater need, and extended Windows/VDI/platform support.
- Production database engine, partition/index design, SLOs, capacity, broker need, portal technology details, and audit storage technology.
- All exact point-in-time dependency versions. Research must verify current supported releases and cite the reviewed versions without hardening patch numbers into timeless architecture.

## Non-negotiable invariants

- A source cursor never advances ahead of the durable minimized events it represents.
- A server receipt never acknowledges data outside the declared durable failure domain.
- A retry or replay creates one final business effect.
- Forbidden source values never cross the endpoint privacy boundary or enter diagnostics.
- One user/session/realm cannot submit, view, mutate, or delete as another.
- A privileged mutation cannot succeed without durable audit evidence.
- An unauthorized, incomplete, stale, frozen, or downgraded release never executes.
- No component silently drops unacknowledged data under pressure.
- Restores neither lose acknowledged events nor make deleted data visible before readiness.

## How to challenge this baseline

Do not silently replace an accepted decision. Submit a change proposal with new primary evidence, affected invariants, alternatives, migration cost, security/privacy impact, smallest falsifying CLI experiment, and proposed ADR status.
