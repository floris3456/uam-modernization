---
name: task-workflow
description: Use when starting or finishing a task brief under docs/work/ — pre-flight checks, safe-lane work while research runs, as-built and deviation updates, handoffs, and next-safe-task naming.
---

# Task workflow

## Pre-flight

- Read the component's AS-BUILT.md → current facts (never start blind).
- Check gate status, relevant ADRs, pending-research blockers.
- If research is running: is this task in the safe lane?

## Work

- Small reversible steps; commit per step.
- Update AS-BUILT.md alongside the code (as-built skill).
- If reality diverged from the plan: one deviation-log line NOW.

## Finish

- Focused checks + `./scripts/validate-repository.sh`.
- Handoff: outcome, evidence, as-built delta, deviation lines, next safe task, and — when human review is required — a human review guide (what to look at when testing, which tools/commands to use).
- Review → Done → archived → next task.

## Review policy

The agent decides whether human review is necessary: uncertain → yes; certain → no; explicit human request → always. Every handoff records one line when review is skipped: `review skipped because …`.

## Statuses

Draft · Ready · In progress · Review · Done · Blocked (named external decision or pending research).
