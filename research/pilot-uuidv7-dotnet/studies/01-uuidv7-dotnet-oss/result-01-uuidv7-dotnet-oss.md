# Result 01 — UUIDv7 in .NET: open-source library assessment

**Research date:** 2026-08-07 via web search (Tavily). **Scope:** RFC 9562 UUIDv7 generation for .NET for UAM's contracts and G0 fixtures.

## Summary

**RECOMMENDATION.** For G0 fixtures and contracts, use the built-in `Guid.CreateVersion7(timestamp)` with the fixture harness supplying explicit timestamps — no third-party dependency yet. Defer the production generator choice to the measurement gate, with UUIDNext and Medo.Uuid7 as the assessed candidates. The RFC 9562 §6.2 monotonic counter is the deciding property, and it is a workload-dependent decision.

## Built-in .NET support

**FACT.** `Guid.CreateVersion7()` was added in .NET 9 and is in the .NET 10 LTS (Microsoft Learn, net-10.0 API page). It creates the RFC 9562 v7 layout: 48-bit Unix-epoch milliseconds, version/variant bits, random `rand_a`/`rand_b`.

**FACT (reproducible).** The built-in fills the sub-timestamp fields with pure randomness and does NOT implement the optional §6.2 monotonic counter (verified via Stack Overflow source excerpts and an independent experiment: 100K-row insert burst → `CreateVersion7` tight loop produced 525 index pages / 66.4% avg leaf density vs 388 / 89.8% for an advancing-millisecond or counter-based generator). UUIDs generated within the same millisecond sort randomly.

**UNVERIFIED.** One community source (sdrapkin gist) further disputes byte-order details of the Microsoft claim of RFC conformance; the decisive, reproducible issue is the missing counter, and this finding does not depend on the byte-order dispute.

**FACT.** `CreateVersion7(DateTimeOffset)` accepts an explicit timestamp, enabling deterministic fixture generation from a fixed clock.

## Candidate libraries

| Library | License | Maintenance | Monotonic counter | Notes |
| --- | --- | --- | --- | --- |
| `System.Guid.CreateVersion7` (built-in) | n/a (platform) | .NET release cadence | No | zero dependency; non-monotonic intra-ms |
| UUIDNext (mareek/UUIDNext) | MIT | active (v4.x, 2025+ releases) | Yes — each generated UUID greater than the previous even within the same ms | only candidate with SQL Server-tailored generation (UUIDv8) and decoder helpers; multi-targets net5.0–net8.0+ |
| Medo.Uuid7 (medo64) | MIT | active | Yes — per-thread guaranteed, ≥2^21/ms | high performance, minimal allocations, ID22/ID25 string forms |
| Costasdev.Uuidv7 (arielcostas) | MIT | active (72 commits) | not stated in reviewed material | simple RFC 9562 generator with timestamp overloads; lowercase canonical output |

## Monotonicity evidence

**FACT.** RFC 9562 §5.7/§6.2 make the counter optional ("Implementations may use these fields to improve monotonicity"); ordering within the same millisecond is therefore implementation-defined. For batch-insert workloads (UAM server ingestion, audit), the measured consequence of missing monotonicity is index fragmentation (evidence table above).

**INFERENCE.** UAM's correctness invariants (dedupe, cursor) do not depend on identifier monotonicity; only index locality under burst insertion does. That is a workload/capacity question, not a correctness question.

## Recommendation

1. **G0: built-in only.** Deterministic golden vectors come from the fixture harness (fixed `DateTimeOffset`), not from the library. If deterministic *ordering* of same-timestamp fixtures is needed, the fictional-data generator implements its own counter — the oracle defines expected outputs, so this is free.
2. **Production: decide at the measurement gate.** When measured event/byte rates and the database engine are known (B04/capacity gate), choose between built-in + own counter, UUIDNext (if SQL Server or decoder needs win), or Medo.Uuid7 (if pure performance wins). Admission follows ADR-FS-032 (license, maintenance, security review, pinned version).

## Change conditions

- A .NET release adding an RFC 9562 §6.2 counter to `CreateVersion7` would change the recommendation toward built-in-only everywhere.
- Measured burst-insert fragmentation at UAM volumes, or a SQL Server engine selection, would strengthen the case for UUIDNext.
- Any candidate library's maintenance/security regression would re-run the admission review.

## Residual risk

Third-party library behavior may change across releases; mitigation is pinned versions, golden vectors in the G0 harness, and the dependency-admission log. No library decision made here is production approval.
