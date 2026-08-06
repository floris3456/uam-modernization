---
name: prompt-authoring
description: Use when writing, reviewing, or assembling a research prompt for another agent (web research, heavy-model reviews, distillers). Covers the ingredient catalogue, output-mode rule, OSS research shape, and the authoring flow. The package card records chosen ingredients and why.
---

# Prompt authoring

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
| Objective-state declaration | Shared premise | ALWAYS when delegating: state what is disposable, frozen, and uncertain; ask the human when in doubt |

## Output-mode rule

If the next artifact after this research is a PLAN → `synthesis+implementation` (separate `theoretical-implementation.md`, THEORETICAL/ESTIMATE labels, change conditions, unverified until CLI experiment). If it is a decision or another research step → `synthesis` (labeled seeds allowed when they help the next step).

## OSS research synthesis shape (when included)

Comparison table (candidate, license, maintenance, fit, gaps, security) + "what we would take inspiration from" + explicit "no relevant prior art exists" when true. Feeds dependency admission (ADR-FS-032).

## Authoring flow

1. Subject kind → technical / decision / informational / governance.
2. Consumer of the result → plan (+implementation) or decision/next step (synthesis).
3. Unknowns → drive the research questions.
4. Match conditions → tick ingredients.
5. Load-bearing claims → negative-evidence + CLI experiment + change conditions.
6. Review against the study template → sections complete, anchors mandated, reading list embedded.

## Mandates

Every prompt demands: visible reasoning (conflict reconstruction, evidence weighting, explicit UNKNOWNs, per-conclusion change conditions); stable ASCII heading anchors for load-bearing sections; a one-page Human summary front section for synthesis results. The study template (`research/templates/study/prompt.md`) is the assembly basis.
