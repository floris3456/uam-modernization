---
name: as-built
description: Use when implementing or touching a component under src/ — maintaining the component's AS-BUILT.md record, adding proof commands, and keeping claims verifiable. Also when reviewing as-built records for consistency with reality.
---

# As-built records

## Rules

- Location: `src/<component>/AS-BUILT.md`, next to the code.
- Maintained DURING work — a workflow step, not a habit. Update it alongside the code, per task.
- Pure current-state truth: what exists, how it was made (commands run, dependencies added, files created), and the command that proves each fact. No plan-comparison inside.
- One page max, terse, no prose. Direct dependencies only; no patch versions.
- Facts are REPLACED (not appended) when they change; history lives in git.
- Quality bar: all as-built records combined, with code, tests, and contracts, allow an agent to reconstruct the system 1:1 from scratch. The reconstruction is a hypothesis until the proof commands pass.

## Verification layers

1. Structure (CI): exists, required sections, size budget, links resolve, no secrets.
2. Claims vs reality (CI): each structured claim diffed against the repo — file exists, dependency referenced in the project file, version matches the lock file, proof command exists.
3. Proof commands (on demand): run a fact's command; green = verified.
4. Reconstruction drill (human-gated, at gate acceptance): fresh checkout, execute the records in order, build, test.
5. Human review (every handoff): spot-check claims against reality.

## Rule

A fact without a proof command is a claim, not a fact.
