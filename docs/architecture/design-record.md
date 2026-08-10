# Current agent-system design record

**Status:** accepted target for implementation package rebuild
**Effective design date:** 2026-08-10

## Decision

UAM repository work uses a human-controlled web-orchestrated implementation system with exact remote evidence and serialized local developers.

- The human is the acceptance authority.
- Remote Git is authoritative repository evidence.
- The ChatGPT web orchestrator designs tasks, routes agents, steers implementation, and independently reviews exact remote commit ranges.
- OpenCode agents implement bounded tasks on `developer`; they do not orchestrate or review.
- `main` contains exact implementation explicitly accepted by the human.
- `web-orchestration` is an orphan-style persistence branch containing only web-orchestrator task context.
- jCodeMunch scouts code symbols only.
- jDocMunch and the old protected-path architecture are retired.
- Historical handover and raw external evidence remain readable but immutable.
- All Git persistence is public-safe.

## Local agents

The normal implementation route uses `small-developer` (GPT 5.6 Luna, maximum supported applicable reasoning tier). `large-developer` (GPT 5.6 Sol, high effort) is selected only by the web orchestrator after two substantive Luna failures or for exceptional intrinsic complexity. Environmental failures, external blockers, missing information, and poor task design do not consume attempts.

This routing rule is an orchestration policy, not a permanent validator rule about the number of files under `.opencode/agents/`.

## Continuity

Task-progress preserves procedural context and the public-safe delegated brief. AS-BUILT preserves current implementation truth and is also live developer memory. Deviations preserve material intended-versus-actual differences. AS-BUILT and deviations change atomically with implementation commits.

The web orchestrator keeps per-task context and routing records on the independent branch when MCP-ON GitHub write capability is available.

## Synchronization and handoff

Every developer commit is pushed immediately. A failed push stops implementation and blocks further commits. Before normal return of control, the developer pushes a dedicated task-progress snapshot commit and responds with only the five-field contract. The web orchestrator reviews the whole range, not only the snapshot.

## Acceptance

After substantive review, finalization, and targeted finalization review, the human may approve an exact `developer` SHA. Luna performs a guarded local `--no-ff` merge to `main` without content changes, then synchronizes `developer` to the accepted merge.

## Validation

Validators enforce only deterministic structure and references. Semantic record correctness, implementation quality, attempt classification, escalation, and human acceptance remain reasoning/judgment controls.

## Replaced architecture

This document replaces the previous active multi-agent orchestration, jDocMunch, protected-lane, connector-permission, and incident-chronology design. Preserved source evidence remains unchanged; obsolete active process archaeology is intentionally not retained here.
