# ADR-FS-002 — Evidence and gate records

- **Status:** Proposed
- **Date:** 2026-08-01
- **Owner:** Unassigned; evidence governance must assign one

## Decision

Every important experiment and gate must produce an immutable, machine-readable evidence record. It records the inputs, versions, environment, commands, expected result, actual result, first failure, cleanup, owner, limitations, and final `PASS`, `FAIL`, `HOLD`, or `INVALID_HARNESS` state.

An evaluator independent from the implementation owner must be able to recompute the gate result.

## Why

A statement such as “the test passed” is not enough to reproduce or audit a safety claim. Results can also become stale when code, dependencies, environments, policies, or owners change.

## Alternatives considered

- Store only CI logs: rejected because logs do not reliably bind all inputs, decisions, and cleanup.
- Let implementation owners approve their own gates: rejected for load-bearing privacy and security claims.
- Replace failed evidence with a successful rerun: rejected because it hides instability.

## Consequences

- Evidence schemas and a gate evaluator are part of G0.
- The first failure is retained and linked to later reruns.
- Missing owners, stale inputs, expired exceptions, failed positive controls, or incomplete cleanup prevent a pass.
- Evidence records must exclude secrets and connection details.

## Required before acceptance

- Evidence and gate schemas exist.
- Evaluator self-tests prove that required failures are detected.
- Cleanup and evidence-expiry behaviour are tested.

## Revisit when

The evidence format cannot represent a required gate, an incident exposes a missing field, or independence cannot be maintained operationally.

## Source

[Final synthesis, sections 10, 11 and 14](../../research-packs/implementation/results/final-synthesis/next-generation-technical-baseline-result.md).
