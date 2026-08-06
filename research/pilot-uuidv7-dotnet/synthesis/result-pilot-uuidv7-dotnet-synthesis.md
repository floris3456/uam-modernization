# Pilot synthesis — UUIDv7 in .NET (pilot package)

## Human summary

**What this is:** the pilot package proving the research workflow end-to-end, on a real decision: which .NET UUIDv7 implementation to use for UAM contracts and G0 fixtures.

**The recommendation in one paragraph:** use the built-in `Guid.CreateVersion7(timestamp)` for G0 fixtures and contracts — no third-party dependency yet. Deterministic golden vectors come from the fixture harness's fixed timestamps, not from a library. The built-in lacks the RFC 9562 §6.2 monotonic counter (verified: same-millisecond UUIDs sort randomly, causing index fragmentation under burst inserts — 525 index pages / 66.4% density vs 388 / 89.8% for a counter-based generator). For production, defer the choice to the measurement gate, with two assessed candidates: UUIDNext (MIT, monotonic, SQL Server-tailored) and Medo.Uuid7 (MIT, per-thread monotonic, high performance). Admission follows ADR-FS-032.

**In one line:** correctness never depends on identifier monotonicity — only index locality does, so the production choice is a measured, human-gated decision.

## Recommendation

**RECOMMENDATION.** G0: built-in `Guid.CreateVersion7(timestamp)` with the harness supplying fixed clocks; own counter only where same-timestamp fixture ordering is needed. Production: decide at the measurement gate between built-in+counter, UUIDNext, or Medo.Uuid7.

## Candidates shortlist

Built-in (zero dependency, no counter) · UUIDNext (MIT, monotonic, SQL Server option) · Medo.Uuid7 (MIT, monotonic, performance) · Costasdev.Uuidv7 (MIT, simpler, counter not stated).

## Change conditions

A .NET §6.2 counter release → built-in everywhere. Measured fragmentation or SQL Server selection → UUIDNext. Candidate maintenance/security regression → re-run admission.
