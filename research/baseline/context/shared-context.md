# Shared UAM research context

This is the canonical short context used by the research prompts.

## Current system

UAM is a Windows endpoint activity-monitoring system. Its endpoint agent is a 4,805-line PowerShell script compiled with PS2EXE. It collects browser history, Windows Recent/Quick Access information, and process information. It loads settings and checkpoints from Microsoft SQL Server, buffers generated SQL in memory/CSV, writes directly to MSSQL, and retries deferred writes after outages.

Administration is through a 1,217-line PowerShell Universal application. The database has 27 tables and 569 fields, only 13 primary keys and 2 physical foreign keys, and many implicit or customer-specific HR/AD relationships.

Valuable behaviours to preserve include per-collector checkpoints, offline/deferred recovery, browser timestamp conversion, profile/file stability checks, compact usage aggregates, user overrides, exclusions/matches, error context, and audit information.

Known problems include one large process owning too many responsibilities, direct database credentials on endpoints, SQL statements as deferred data, weak relational structure, duplicated functions, dynamic SQL, a formerly hardcoded credential, incomplete script scheduling, customer-specific integrations, and insufficient privacy minimization before transport.

## Proposed design—not an approved decision

- A small signed `uam.exe` bootstrapper installs, switches, health-checks, and rolls back agent versions atomically.
- `uam-agent.exe` is a .NET Worker Service responsible for identity, policy, schedules, task coordination, local persistence, upload, and health.
- Collectors are separately versioned signed task packages. Simple managed tasks may run in a collectible `AssemblyLoadContext`; risky/native/PowerShell tasks run in a separate `uam-taskhost.exe` process.
- SQLite in WAL mode stores policy snapshots, overrides, task state, checkpoints, runs, diagnostics policy, and a transactional outbox. Events and their checkpoint commit together.
- Minimized events upload in small gzip-compressed idempotent HTTPS batches with retry, jitter, and backpressure.
- An ingestion API authenticates devices, validates batches, and writes durably to a queue. Workers normalize and bulk-write data.
- PostgreSQL with time partitioning is the proposed default; TimescaleDB is optional only after benchmarking. MSSQL remains a possible deployment adapter.
- A control-plane API and modern portal provide typed versioned policy, application allowlists, task rollout, health, diagnostics, capability-based access, and immutable audit.
- URL/process allowlisting and redaction happen on the endpoint before persistence and transport.

## Constraints and goals

- Windows is the endpoint/client platform.
- Initial design target: at least 6,000 users/endpoints and synchronized reconnect peaks.
- Endpoints must tolerate network/server outages without losing accepted events or duplicating central facts.
- Privacy and data minimization are design requirements, not later filters.
- Updates must be signed, staged, recoverable, and automatically rollback-capable.
- Prefer portable/open server components where practical, but operational simplicity matters more than ideology.
- Customer-specific HR/AD/CMDB tables must become narrow configurable contracts/adapters.
- The first proposed vertical slice is Browser History from Windows endpoint to a minimal read-only portal.

## Evidence attachment

`code-reference.md` contains byte-identified copies of:

1. The redacted legacy endpoint agent.
2. The current DEV PowerShell Universal admin application.
3. The production database DDL without production data.

The source shows current behaviour but is not a secure design specification. Static inspection can miss dynamic SQL, external consumers, production configuration, and operational behaviour.

