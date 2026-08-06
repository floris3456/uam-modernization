# Study 01 — UUIDv7 in .NET: open-source library assessment

## Expert role

Principal identifier-standards engineer; know RFC 9562 UUIDv7 semantics, .NET ecosystem maturity, and dependency-admission criteria.

## Result target

Save the complete response as `result-01-uuidv7-dotnet-oss.md`, with stable heading anchors for every load-bearing section.

## Inputs

- Code zips: none (no code-bearing roots exist yet).
- Attachments: none.

## Reading list

This study reads no repository files. It researches external primary sources only: RFC 9562, official .NET documentation, and the candidate libraries' repositories/documentation. Mark renderer-independent but unverifiable claims as UNVERIFIED.

## Accepted baseline and provisional matters

Accepted baseline: new UAM domain and wire identifiers use canonical lower-case UUIDv7 (implementation synthesis §1.2). Provisional: which library (if any) is admitted, and whether .NET ships a sufficient built-in implementation.

## Research questions

1. Does .NET (current LTS) provide built-in RFC 9562 UUIDv7 generation, and with what guarantees (RFC-compliance, time source, monotonicity)?
2. Which maintained open-source .NET libraries implement UUIDv7, and how do they compare on license, maintenance, tests, security posture, API shape, and RFC conformance?
3. For UAM's G0 fixtures and contracts, is a third-party library warranted, or is a small internal implementation with golden vectors the lower-risk choice?

## Required web verification

Verify as of the research date; record document/release dates and commit hashes where available. Reject vendor marketing and popularity claims as proof.

## Open-source reference review

Included (mandatory for this study): comparison table with license, maintenance, tests, security, fit, gaps; state what we would take inspiration from; say explicitly when no relevant prior art exists.

## Required output

Synthesis only: conclusions with visible reasoning, per-question answers with labels, and a recommendation for the dependency-admission decision.

## Human decisions

Admission of an external dependency under ADR-FS-032 remains the accountable human's decision; research supplies the assessment table and trade-offs.

## CLI evidence and experiments

Claims about generation determinism, RFC conformance, or monotonicity under clock rollback can be falsified with the G0 fixture harness; name that as the experiment.

## Evidence labels and conflict handling

FACT · ASSUMPTION · INFERENCE · ESTIMATE · RECOMMENDATION · UNKNOWN · HUMAN DECISION · CLI EXPERIMENT. Give High/Medium/Low confidence with reasons, and change conditions per conclusion.

## Residual risk

Any library or built-in API may change behavior across .NET releases; the mitigation is pinned versions, golden vectors, and the dependency-admission log.
