# Baseline package — conclusions

**Source package:** research/baseline (historical) · **Synthesis:** [result-baseline-technical-synthesis.md](result-baseline-technical-synthesis.md)  
**Status:** backfilled 2026-08-07 by the reading-ladder task; conclusions were consumed by the implementation package.

| # | Conclusion | Label | Confidence | Source | Suggested promotion | Disposition |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Endpoint split: low-privilege machine service + per-session user host + restricted child collectors | RECOMMENDATION | High | [§1.1](result-baseline-technical-synthesis.md#11-recommendation) | historical — refined by implementation suite | |
| 2 | Privacy ceiling is an endpoint invariant; filter and minimize before the outbox | RECOMMENDATION | High | [§1.1](result-baseline-technical-synthesis.md#11-recommendation) | historical — refined by implementation suite | |
| 3 | C#/.NET with pinned SQLite locally; versioned JSON over mTLS; durable receipts | RECOMMENDATION | High | [§1.1](result-baseline-technical-synthesis.md#11-recommendation) | historical — refined by implementation suite | |
| 4 | Relational durable inbox + workers centrally; broker only on quantitative break-even | RECOMMENDATION | High | [§1.1](result-baseline-technical-synthesis.md#11-recommendation) | historical — refined by implementation suite | |
| 5 | PostgreSQL 18.4 target reference; SQL Server 2025 benchmarked fallback | RECOMMENDATION | Moderate | [§1.1](result-baseline-technical-synthesis.md#11-recommendation) | historical — refined by implementation suite | |
| 6 | MSI + enterprise deployment owns the stable boundary; updater optional and TUF-style signed | RECOMMENDATION | High | [§1.1](result-baseline-technical-synthesis.md#11-recommendation) | historical — refined by implementation suite | |
| 7 | Six thousand endpoints is not a throughput requirement; capacity is rates, backlog, recovery | RECOMMENDATION | High | [§1.2](result-baseline-technical-synthesis.md#12-where-the-six-packs-agree) | historical — refined by implementation suite | |
| 8 | Named missing evidence blocks unconditional production approval; each gap becomes an experiment or owner decision | FACT | High | [§1.3](result-baseline-technical-synthesis.md#13-missing-evidence-that-prevents-unconditional-production-approval) | → gate input (evidence backlog) | |
| 9 | Approve the falsification-oriented proof program and first vertical slice only | RECOMMENDATION | High | [§1.4](result-baseline-technical-synthesis.md#14-approval-position) | historical — superseded by implementation suite | |

**Note:** this package is complete-historical. Its conclusions were inputs to the implementation package and are recorded here for provenance; they are not separately promoted.
