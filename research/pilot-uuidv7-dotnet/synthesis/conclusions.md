# Pilot package — conclusions

**Source package:** research/pilot-uuidv7-dotnet · **Synthesis:** [result-pilot-uuidv7-dotnet-synthesis.md](result-pilot-uuidv7-dotnet-synthesis.md) · **Status:** dispositions pending human review.

| # | Conclusion | Label | Confidence | Source | Suggested promotion |
| --- | --- | --- | --- | --- | --- |
| 1 | G0 fixtures and contracts use built-in `Guid.CreateVersion7(timestamp)`; deterministic golden vectors come from the fixture harness's fixed clocks | RECOMMENDATION | High | [§Recommendation](result-pilot-uuidv7-dotnet-synthesis.md#recommendation) | → gate input (G0 fixture design) |
| 2 | The built-in lacks the RFC 9562 §6.2 monotonic counter; same-millisecond UUIDs sort randomly | FACT | High (reproducible) | [§Human summary](result-pilot-uuidv7-dotnet-synthesis.md#human-summary) | → ADR-FS-003 input |
| 3 | Production generator choice is deferred to the measurement gate; candidates UUIDNext and Medo.Uuid7 | RECOMMENDATION | Medium | [§Candidates shortlist](result-pilot-uuidv7-dotnet-synthesis.md#candidates-shortlist) | → ADR-FS-032 admission review at gate |
| 4 | Correctness never depends on identifier monotonicity; only index locality does | INFERENCE | High | [§Human summary](result-pilot-uuidv7-dotnet-synthesis.md#human-summary) | → no action (design note) |
| 5 | The package format works end-to-end: card → study → web research → verbatim result → synthesis → conclusions → validation | FACT | High | [§Human summary](result-pilot-uuidv7-dotnet-synthesis.md#human-summary) | → pilot accepted; workflow contract proven |
