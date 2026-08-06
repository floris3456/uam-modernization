# Pilot synthesis prompt

## Expert role

Lead identifier-standards reviewer; adjudicate the study result into a one-page synthesis.

## Result target

Save the complete response as `result-pilot-uuidv7-dotnet-synthesis.md`, with a one-page `## Human summary` front section and stable heading anchors.

## Inputs

- Code zips: none.
- Attachments: none.
- Accepted predecessor results: `result-01-uuidv7-dotnet-oss.md`.

## Reading list

Read only the study result listed above.

## Accepted baseline and provisional matters

Baseline: UAM identifiers are canonical lower-case UUIDv7. Provisional: the production generator choice is measurement-gated.

## Research questions

1. What does the study conclude for G0 fixtures?
2. What does it conclude for the production choice, and what changes the decision?

## Required web verification

Not required: the study already verified claims and marked UNVERIFIED items; represent it faithfully.

## Open-source reference review

Not re-run; the study's comparison table is the evidence.

## Required output

Synthesis only: one-page Human summary + conclusions, each load-bearing section anchored.

## Human decisions

Dependency admission under ADR-FS-032 remains human-owned; the synthesis frames the trade-off.

## CLI evidence and experiments

Name the G0 fixture harness golden-vector check and the measurement gate as the falsifying experiments.

## Evidence labels and conflict handling

FACT · ASSUMPTION · INFERENCE · ESTIMATE · RECOMMENDATION · UNKNOWN · HUMAN DECISION · CLI EXPERIMENT. Preserve the study's UNVERIFIED marking.

## Residual risk

No library decision made here is production approval; pinned versions and golden vectors contain the residual risk.
