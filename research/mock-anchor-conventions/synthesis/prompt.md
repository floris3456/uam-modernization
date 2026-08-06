# Mock synthesis prompt

## Expert role

Lead document-engineering reviewer; adjudicate the study result into a one-page synthesis.

## Result target

Save the complete response as `result-mock-anchor-conventions-synthesis.md`, with a one-page `## Human summary` front section and stable heading anchors.

## Inputs

- Code zips: none.
- Attachments: none.
- Accepted predecessor results: `result-01-anchor-slug-rules.md`.

## Reading list

Read only the study result listed above.

## Accepted baseline and provisional matters

Baseline: the repository links by heading anchors and the validator slugifies ASCII. Provisional: renderer agreement for non-ASCII headings.

## Research questions

1. What does the study conclude about the slug algorithm?
2. What consequence does that have for the repository's anchor rule?

## Required web verification

Not required: the study already verified the claims; verify only that the study result is represented faithfully.

## Open-source reference review

Not included.

## Required output

Synthesis only: one-page Human summary + conclusions, each load-bearing section anchored.

## Human decisions

None; the algorithm choice is technical and already reflected in the validator.

## CLI evidence and experiments

Name the editor check as the falsifying experiment for non-ASCII slug agreement.

## Evidence labels and conflict handling

FACT · ASSUMPTION · INFERENCE · ESTIMATE · RECOMMENDATION · UNKNOWN · HUMAN DECISION · CLI EXPERIMENT. Keep the study's UNVERIFIED marking for non-ASCII behavior.

## Residual risk

Renderers outside GitHub/VS Code/MDE may differ; contained by the validator's own algorithm.
