# NN — Study title

**Status:** draft
**Decision informed:**

- [Prompt](prompt.md)
- Result target: `result-NN-short-topic.md`

## Inputs

- Code zips:
- Attachments:
- Dataset use: `NONE` with reason, or `RANDOMIZED_VALUES` with the literal current contract path, basename, byte count, SHA-256, and covered property/value claims:

## Completion rule

The prompt contains a complete `## Dataset contract`; otherwise research does not start. A `RANDOMIZED_VALUES` prompt also states `Structure: UNTRUSTED`, the forbidden inference classes, its `TEST_AUTHORED` constructs, and affected-claim `HOLD` behavior. The result is saved verbatim, reviewed with the review checklist, validated (`node scripts/validate-research.mjs`), and converted into explicit ADR proposals, human decisions, or CLI experiments through the conclusions sheet.
