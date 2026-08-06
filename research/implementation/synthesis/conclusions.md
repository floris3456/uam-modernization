# Implementation package — conclusions

**Source package:** research/implementation · **Synthesis:** [result-implementation-technical-baseline.md](result-implementation-technical-baseline.md)  
**Status:** backfilled 2026-08-07 by the reading-ladder task; dispositions pending human review.

| # | Conclusion | Label | Confidence | Source | Suggested promotion |
| --- | --- | --- | --- | --- | --- |
| 1 | Build the replacement as a narrow sequence of independently falsifiable gates, starting with G0 | RECOMMENDATION | High | [§1.1](result-implementation-technical-baseline.md#11-plain-language-recommendation) | → ADR proposal (ADR-FS-001) |
| 2 | G0 is the next safe gate; every later gate consumes its contracts, fixtures, oracle, and canaries | RECOMMENDATION | High | [§1.6](result-implementation-technical-baseline.md#16-confidence-by-major-conclusion) | → gate input (G0 milestone) |
| 3 | Endpoint topology: low-privilege Coordinator, per-session User Host, restricted Task Hosts | RECOMMENDATION | High at architecture; Medium-Low at runtime | [§1.6](result-implementation-technical-baseline.md#16-confidence-by-major-conclusion) | → ADR proposal; runtime proof at G1 |
| 4 | Product privacy ceiling; tenant policy may only narrow; minimization before IPC/storage/logs/transport | RECOMMENDATION | High | [§2.1](result-implementation-technical-baseline.md#21-non-negotiable-constraints) | → ADR proposal + human decision on ceiling |
| 5 | SQLite WAL one-writer outbox; atomic event+cursor; at-least-once delivery with idempotent effect | RECOMMENDATION | High logical; Medium operational | [§1.6](result-implementation-technical-baseline.md#16-confidence-by-major-conclusion) | → gate input (G5) |
| 6 | Edge acquisition: direct read → eligible Online Backup → defer; zero source writes | RECOMMENDATION | Medium-High | [§1.6](result-implementation-technical-baseline.md#16-confidence-by-major-conclusion) | → gate input (G2/G3) |
| 7 | Server: modular monolith, authenticated ingestion, durable relational inbox, leased workers, typed facts | RECOMMENDATION | High | [§1.6](result-implementation-technical-baseline.md#16-confidence-by-major-conclusion) | → ADR proposal |
| 8 | PostgreSQL reference, SQL Server fallback; engine chosen only by identical benchmark + ops/skills/licensing/restore | RECOMMENDATION | Low (not established) | [§1.6](result-implementation-technical-baseline.md#16-confidence-by-major-conclusion) | → CLI experiment + human decision (B04) |
| 9 | No broker by default; add only after measured break-even conditions | RECOMMENDATION | High | [§1.1](result-implementation-technical-baseline.md#11-plain-language-recommendation) | → ADR proposal |
| 10 | Capacity figures are not established; require qualified simulator + approved distributions | UNKNOWN / ESTIMATE | Low | [§1.6](result-implementation-technical-baseline.md#16-confidence-by-major-conclusion) | → CLI experiment + human decision |
| 11 | Portal: same-origin BFF, capability authorization, purpose-bound access, transactional audit | RECOMMENDATION | High at architecture | [§1.6](result-implementation-technical-baseline.md#16-confidence-by-major-conclusion) | → ADR proposal + human decision |
| 12 | Migration: dual observation, one-authority shadow comparison, phase-bounded rollback | RECOMMENDATION | High | [§1.6](result-implementation-technical-baseline.md#16-confidence-by-major-conclusion) | → gate input |
| 13 | No pilot, production database choice, broker, updater, PKI, portal framework, or deployment is ready | RECOMMENDATION | High | [§1.4](result-implementation-technical-baseline.md#14-what-is-not-ready) | → governance boundary |
| 14 | Remaining contradictions are implementation-profile choices or human decisions, not hidden architecture conflicts | FACT | High | [§1.5](result-implementation-technical-baseline.md#15-answer-to-the-research-questions) | → no action (monitor) |
| 15 | The next exact invalidating gate for the architecture is G0 proof | FACT | High | [§19](result-implementation-technical-baseline.md#19-residual-risk-and-exact-next-invalidating-gate) | → gate input |

**Not yet disposed:** all rows above. Dispositions (→ ADR proposal / → gate input / → adopted package / → no action) are filled by the accountable human; this sheet is a living file outside the hash ledger.
