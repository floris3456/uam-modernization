---
name: gate-workflow
description: Use when working on milestones, deviation logs, or gate records — expanding framing stubs into plans, recording plan-vs-reality deltas, and preparing gate acceptance evidence.
---

# Gate workflow

## Milestones

- Later gates materialize as framing stubs when they become active: a 5-line "About this gate" in the plan's own voice + links to the informing studies. Until then they remain in the research baseline (see `docs/milestones/README.md`).
- Plan format: 5-line summary → key-facts table (each row links to its source) → ordered steps (own text) → links. Summaries are the plan's own framing, never copies of research (honesty test: if editing the source forces an edit of the summary, it is duplication).

## Deviation log

- One file per gate (`<gate>-deviations.md`), opened when the gate starts, closed when the gate is accepted.
- Entries contain only references + explanation: plan ref → as-built ref → because.
- Differences are NEVER recorded inside as-built records — the as-built is truth; it does not justify itself.

## Gate acceptance

- Milestone plan → tasks consume it → evidence accumulates → gate record (evidence hashes, residual risks) → human accepts → deviation log closes → next gate stub expands.
- Gate acceptance is the only place the build phase ends for a gate. A gate passes when its named evidence exists, validation succeeds, residual risks are recorded, and an accountable human accepts the gate record.
