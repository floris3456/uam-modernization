# ADR-FS-001 — Implementation baseline and gate order

- **Status:** Proposed
- **Date:** 2026-08-01
- **Owner:** Unassigned; architecture governance must assign one

## Decision

Use the final research synthesis as the working technical baseline. Implement UAM through ordered proof gates, starting with G0. If a mandatory condition fails or required evidence is missing, stop dependent work instead of treating the result as a partial pass.

The baseline does not authorize live data, a pilot, cutover, decommissioning, or production use.

## Why

Many parts of UAM affect privacy, Windows security boundaries, durable data, administrative authority, and migration safety. Building everything before proving these boundaries would make failures expensive and difficult to isolate.

## Alternatives considered

- Build the complete platform first and test it later: rejected because several early assumptions could invalidate later work.
- Treat research confidence as proof: rejected because Windows, browser, storage, capacity, restore, and operational behaviour require measurements.
- Allow conditional passes: rejected for mandatory privacy, isolation, durability, realm, and cleanup rules.

## Consequences

- Work may proceed on G0, contracts, pure models, manifest-bound randomized-property inputs, `TEST_AUTHORED` scenario structures, and repository scaffolding.
- Later implementation waits for its predecessor gate.
- Gate failures are retained and corrected; a rerun does not erase the first failure.
- Human policy and production decisions remain separate.

## Required before acceptance

- Architecture governance confirms the baseline and gate order.
- Accountable owners are assigned.
- The exact reviewed input hashes are recorded.
- Dataset-backed claims remain property/value-only; inaccurate source structure cannot support a gate claim.

## Revisit when

New primary evidence or a reproducible CLI experiment shows that two accepted invariants cannot work together, or a legal/business constraint changes the permitted design.

## Source

[Final synthesis, sections 1, 8, 10 and 19](../../research/implementation/synthesis/result-implementation-technical-baseline.md).
