# Prompt authoring guide

Prompt composition is a repeatable decision, not a feeling. Pick the ingredients below, record your choices and the reasons on the package card, then assemble the prompt from the study template.

## Ingredient catalogue

| Ingredient | What it produces | When to include |
| --- | --- | --- |
| Role + bounded questions | Focus | ALWAYS |
| Inputs + reading list embedded in the prompt | Grounding | ALWAYS |
| Evidence labels + visible reasoning | Adjudicable output | ALWAYS |
| Human decisions / CLI experiments / residual risk | Honesty boundaries | ALWAYS |
| Time-sensitivity re-verification | Freshness | ALWAYS (tech claims) |
| Theoretical implementation | Draft design | next artifact is a PLAN; decision or next step → synthesis-only |
| OSS library research | Prior art + inspiration | default ON for technical subjects; OFF for policy/governance/informational |
| Standards/regulatory check | Compliance facts | subject touches standards / RFCs / law |
| Adversarial/falsification pass | Failure modes | trust boundaries (IPC, auth, privacy, durability) |
| Compatibility matrix | Platform truth | platform/version support claims |
| Cost/ops review | TCO, licensing, on-call | budget or operations factor |
| Migration impact | Change surface | alters existing behavior |
| Negative-evidence search | Change conditions | load-bearing decisions |
| Objective-state declaration | Shared premise | ALWAYS when delegating to another agent: state what is disposable, frozen, and uncertain; ask the human when in doubt |

## Output-mode rule

If the next artifact after this research is a PLAN → `synthesis+implementation`. If it is a decision or another research step → `synthesis` (minimal labeled seeds allowed when they help the next step).

## OSS research synthesis shape (mandatory when included)

Comparison table (candidate, license, maintenance, fit, gaps, security assessment) + "what we would take inspiration from" + explicit "no relevant prior art exists" when true. Feeds dependency admission (ADR-FS-032).

## Authoring flow

1. Subject kind → technical / decision / informational / governance.
2. Consumer of the result → plan (+implementation) or decision/next step (synthesis).
3. Unknowns → drive the research questions.
4. Match conditions → tick ingredients.
5. Load-bearing claims → negative-evidence + CLI experiment + change conditions.
6. Review against the template → sections complete, anchors mandated, reading list embedded.

## Living catalogue

New ingredients are added with their inclusion condition when discovered. The package card records which conditional ingredients were chosen and why, so every prompt is auditable.
