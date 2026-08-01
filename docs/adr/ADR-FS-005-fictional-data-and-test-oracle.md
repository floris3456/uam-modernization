# ADR-FS-005 — Fictional data and independent test oracle

- **Status:** Experimenting — next gate
- **Date:** 2026-08-01
- **Owner:** Unassigned; test-data and independent verification owners must be different people or functions

## Decision

G0 uses deterministic, classified fictional data only. A generator creates the input package from a fixed seed and clock. A separately owned oracle predicts expected events, rejections, cursor changes, receipts, visibility, and cleanup before the system runs.

Exact privacy canaries must be detectable in every declared output sink. Mutation tests must prove that the oracle, canary scanner, and gate fail when mandatory rules are deliberately broken.

The 173-application catalogue may contribute aggregate shape only. Raw application names, internal identifiers, URLs, addresses, ownership values, or organizational mappings must not be copied into fixtures.

## Why

Tests based on production data create privacy and deletion risk. An oracle that calls the same production logic can repeat the same defect and falsely agree with the implementation.

## Alternatives considered

- Copy and anonymize production data: rejected as the default because derived values can remain identifying and hard to delete.
- Let implementation output become expected output: rejected because it cannot detect semantic errors.
- Use only generic secret scanners: rejected because UAM needs exact domain-specific canaries and positive controls.
- Commit one database binary as canonical truth: rejected because it hides generation and version differences.

## Consequences

- G0 blocks live data and organization-derived fixtures.
- Fixtures have classification, lineage, owner, expiry, and deletion records.
- Generator and oracle implementations are separated.
- The detailed application catalogue can inform safe aggregate scenarios after a sanitized profile is generated.

## Required before acceptance

- Two clean challenged runs create byte-identical canonical packages.
- The independent oracle detects every required implementation and oracle mutation.
- Every mandatory canary and positive control is detected without leaking the canary in reports.
- Cleanup removes all temporary artifacts and produces a receipt.
- An independent evaluator recomputes the G0 result.

## Revisit when

A required scenario cannot be represented fictionally, the generator or oracle shares production decision code, a canary escapes, or new approved evidence tiers are introduced.

## Source

[Final synthesis, section 11](../../research/implementation/synthesis/result-implementation-technical-baseline.md).
