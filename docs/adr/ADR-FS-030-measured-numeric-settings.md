# ADR-FS-030 — Numeric settings must be measured

- **Status:** Proposed
- **Date:** 2026-08-01
- **Owner:** Unassigned; every production numeric setting needs a named owner

## Decision

Timeouts, limits, retry counts, batch sizes, storage caps, retention periods, capacity, headroom, key lifetimes, and similar numbers are not permanent architecture facts. Store them in versioned execution profiles with a source, owner, environment, evidence, expiry date, and safe fallback.

An estimate may guide a test but cannot silently become a production default.

## Why

The research contains useful candidate numbers, but generic documentation and synthetic benchmarks do not establish correct values for the UAM estate. Old numbers also become unsafe as workloads and platforms change.

## Alternatives considered

- Copy research numbers directly into configuration: rejected because they are not project measurements.
- Use unlimited values: rejected because they allow resource exhaustion and uncontrolled data growth.
- Hide values in code constants: rejected because ownership, evidence, and expiry become unclear.

## Consequences

- Numeric settings are traceable and reviewable.
- Missing or expired production profiles fail closed where safety requires it.
- Tests may use deliberately small values clearly labelled as synthetic.
- Capacity, retention, and service objectives still require human approval.

## Required before acceptance

- A numeric-profile schema exists.
- CI rejects unlabeled, ownerless, expired, or hardened estimate values.
- Each production value points to applicable measurements and authority.

## Revisit when

New environments, incidents, workload changes, lifecycle changes, or expired evidence invalidate a profile.

## Source

[Final synthesis, sections 5, 8 and 14](../../research/implementation/synthesis/result-implementation-technical-baseline.md).
