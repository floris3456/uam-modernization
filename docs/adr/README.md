# Architecture decision records

These files explain the important UAM technical decisions in simple language.

An ADR records a decision; it does not prove that the design works. A decision marked `Experimenting` still needs its named tests. An ADR also cannot approve legal purpose, employee monitoring policy, retention, access, budget, production risk, or deployment.

## Initial decisions

| ADR | Subject | Status |
| --- | --- | --- |
| [ADR-FS-001](ADR-FS-001-implementation-baseline-and-gates.md) | Implementation baseline and gate order | Proposed |
| [ADR-FS-002](ADR-FS-002-evidence-and-gate-records.md) | Evidence and gate records | Proposed |
| [ADR-FS-003](ADR-FS-003-contract-and-identifier-rules.md) | Contracts, identifiers, time, and text | Experimenting |
| [ADR-FS-004](ADR-FS-004-repository-build-and-supply-chain.md) | Repository, build, and supply chain | Experimenting |
| [ADR-FS-005](ADR-FS-005-fictional-data-and-test-oracle.md) | Fictional data and independent test oracle | Experimenting — next gate |
| [ADR-FS-030](ADR-FS-030-measured-numeric-settings.md) | Measured numeric settings | Proposed |
| [ADR-FS-032](ADR-FS-032-external-dependency-admission.md) | External dependency admission | Proposed |

## Status meanings

- `Proposed`: recommended, but the accountable owner has not accepted it.
- `Experimenting`: the direction is accepted for testing, but required evidence is incomplete.
- `Accepted`: approved by the accountable owner with its required evidence.
- `Deferred`, `Rejected`, or `Superseded`: not currently active.

The source baseline is the [final research synthesis](../../research/implementation/synthesis/result-implementation-technical-baseline.md).
