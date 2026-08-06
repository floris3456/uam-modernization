---
name: code-review
description: Use when reviewing code or PRs — what to check, what blocks, and when a human review guide is required. Covers the mechanical, human, and deep verification layers.
---

# Code review

## What to check

- Behavior against the task's acceptance evidence.
- As-built consistency: the claims-vs-reality checks (as-built skill) and any deviation lines are present when reality differed.
- ADR conformance; architecture tests; fictional-data/canary safety; no raw or personal data in fixtures, logs, or evidence.
- Proof commands exist and pass for the touched component.

## What blocks

- Missing or failed proof commands.
- As-built records not updated for the change.
- Deviation from an ADR without a recorded deviation line.
- Any real data, credentials, or private addresses in tests or evidence.

## Human review

The agent decides whether human review is needed: uncertain → yes; certain → no; explicit human request → always. When required, the handoff carries a human review guide: what to look at when testing, which tools/commands to use, what to verify. When skipped, the handoff records `review skipped because …`.

## Deep check (rare)

Reconstruction drill at gate acceptance: fresh checkout, execute as-built records in order, build, run tests.
