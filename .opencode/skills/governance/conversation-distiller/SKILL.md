---
name: conversation-distiller
description: Use when turning a conversation (own history or an exported opencode transcript) into repository documentation — typically in a fork of the orchestrator chat after a heavy-model discussion or review. Covers inventory, mapping to proper homes, the summary rule, approval, and the gap check.
---

# Conversation distillation

## Objective state first

Before distilling, state (and confirm with the human when uncertain) what is disposable, frozen, and uncertain in the repo right now. Never assume.

## Process

1. **Inventory** — list every decision, correction, and new element from the conversation.
2. **Map to homes** — each item goes to exactly one place: the design record, an ADR proposal, a milestone, a research package, a template, a skill, or the decisions log. Use the ownership map: orchestrator owns docs/, research/, evidence/, AGENTS.md, skills, task briefs.
3. **Apply the summary rule** — own-voice framing; one home per fact; references, not copies. Honesty test: if editing the source forces an edit of the summary, it is duplication.
4. **Draft → approval → write → commit** — never write without human approval; commit as small reversible changes.
5. **Gap check** — list what remains open or undecided explicitly; do not silently drop anything.

## Format discipline

Heading-anchor links for cross-references; terse tables over prose; keep each artifact within its size budget. A fact without a proof command is a claim, not a fact.

## What NOT to do

Never rewrite preserved research results; never duplicate a fact already at its normative home; never write beyond the approval scope.
