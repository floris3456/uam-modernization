# Repeatable task workflow

## Choose the right unit

A task should deliver one observable outcome. Separate unrelated cleanup, refactoring, experiments, and product changes. If a reviewer cannot explain the change without reading its entire diff, the task is probably too broad.

## Start

1. Copy [task-template.md](templates/task-template.md) to `current/<gate>-<number>-<short-name>.md`.
2. Fill every section before implementation. Use `None` with a reason instead of leaving blanks.
3. Link the milestone, relevant ADRs, sources, and evidence inputs.
4. Mark policy, ownership, risk acceptance, money, and production choices as human decisions.

Use [experiment-template.md](templates/experiment-template.md) when the main output is a measurement rather than product behavior.

## Work

- Keep the brief current when facts change.
- Update the component's AS-BUILT.md alongside the code; record a deviation-log line when reality differs from the plan.
- Save deterministic, sanitized outputs under `evidence/`; do not paste raw evidence into the brief.
- Prefer a command another person can rerun over a screenshot or chat claim.
- Stop at the active gate.

## Finish

1. Run focused checks and `./scripts/validate-repository.sh`.
2. Complete [handoff-template.md](templates/handoff-template.md), including the as-built delta, deviation lines, and the review decision.
3. After review (human when the agent is uncertain, skipped with a recorded reason otherwise), move the task and handoff into `archive/<year>/`.
4. Make the next safe task explicit. Do not leave required context only in a chat.

Note: **chat handoffs** (full conversation memory for a continuing chat, e.g.
`CHAT-HANDOFF-*.md`) are a separate artifact from task handoffs — they live in
`docs/work/handoffs/`, which is gitignored by design (design record row 44).
The durable summary of each chat handoff is its design-record row; task
handoffs above remain committed and archived.

## Status meanings

- `Draft`: outcome or checks are incomplete.
- `Ready`: scope and acceptance evidence are clear; blockers are resolved.
- `In progress`: implementation or measurement is underway.
- `Review`: work is complete and evidence awaits review.
- `Done`: accepted and archived.
- `Blocked`: named external decision or permission prevents safe progress.
