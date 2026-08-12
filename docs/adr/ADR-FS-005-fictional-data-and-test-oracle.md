# ADR-FS-005 — Randomized-property data and independent test oracle

- **Status:** Experimenting — next gate
- **Date:** 2026-08-01
- **Owner:** Unassigned; test-data and independent verification owners must be different people or functions

## Decision

G0 uses the exact [current randomized dataset contract](../../research/current-randomized-dataset-contract.md) for covered positive values and declared property facts. Its structure is inaccurate and untrusted. A scenario composer creates only the required structure, identities, clocks, boundaries, canaries, and negative mutations and labels every construct `TEST_AUTHORED`. A separately owned oracle predicts outcomes before the system runs.

The dataset cannot establish grouping, keys, relationships, joins, hierarchy, order, cardinality, co-occurrence, distributions, topology, scale, representativeness, behavior, or production safety. Missing or mismatched bytes put only dependent claims in `HOLD`.

Exact privacy canaries must be detectable in every declared output sink. Mutation tests must prove that the oracle, canary scanner, and gate fail when mandatory rules are deliberately broken.

The 173-application catalogue may contribute aggregate shape only. Raw application names, internal identifiers, URLs, addresses, ownership values, or organizational mappings must not be copied into fixtures.

## Why

Tests based on production data create privacy and deletion risk. An oracle that calls the same production logic can repeat the same defect and falsely agree with the implementation.

## Alternatives considered

- Use generic fictional positive data when the dataset covers the property: rejected because it discards the supplied evidence.
- Treat the mangled layout as real structure: rejected because the user explicitly says it is inaccurate.
- Let implementation output become expected output: rejected because it cannot detect semantic errors.
- Use only generic secret scanners: rejected because UAM needs exact domain-specific canaries and positive controls.
- Commit one database binary as canonical truth: rejected because it hides generation and version differences.

## Consequences

- G0 blocks live collection and production authority.
- Fixtures have classification, lineage, technical provenance, expiry, and deletion records.
- Dataset adaptation, `TEST_AUTHORED` scenario composition, and oracle implementations are separated.
- The detailed application catalogue can inform safe aggregate scenarios after a sanitized profile is generated.

## Required before acceptance

- Two clean challenged runs create byte-identical canonical packages.
- Dataset-dependent evidence binds the exact path, byte count, and SHA-256.
- Every structural element is labeled `TEST_AUTHORED` and cannot be cited as source or production evidence.
- The independent oracle detects every required implementation and oracle mutation.
- Every mandatory canary and positive control is detected without leaking the canary in reports.
- Cleanup removes all temporary artifacts and produces a receipt.
- An independent evaluator recomputes the G0 result.

## Revisit when

A required declared property is absent, the dataset identity changes, a structural inference enters a claim, the composer or oracle shares production decision code, or a canary escapes.

## Source

[Final synthesis, section 11](../../research/implementation/synthesis/result-implementation-technical-baseline.md).
