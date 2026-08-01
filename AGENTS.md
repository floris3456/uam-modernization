# Repository working agreement

This file is for people and coding agents. It describes how to make safe, reviewable changes in this repository.

## Purpose and current state

UAM modernization is replacing a legacy Windows activity-monitoring system. The repository currently contains validated handover evidence, completed design research, proposed decisions, and pre-implementation scaffolding. It does not yet contain a production replacement.

The only active delivery gate is **G0: fictional evidence and test-oracle foundation**. Do not start G1 or connect to live systems unless a human explicitly changes that gate.

## Read before working

1. `README.md`
2. `docs/plain-language/01-current-next-later.md`
3. the active file in `docs/work/current/`
4. the relevant milestone and ADRs
5. the final research baseline only when the simpler documents are insufficient

Closer `AGENTS.md` files add local rules. They may narrow these instructions but may not weaken security, privacy, evidence, or human-approval rules.

## Repeatable task loop

1. **Orient:** inspect Git status, the current task, relevant code/docs, and validation commands.
2. **Define:** write the outcome, scope, exclusions, acceptance checks, and human decisions in a task brief.
3. **Change:** make the smallest coherent change. Keep unrelated work untouched.
4. **Prove:** run focused tests first, then `./scripts/validate-repository.sh`.
5. **Explain:** update plain-language, architecture, decision, or operational documentation when behavior changes.
6. **Handoff:** record what changed, evidence, remaining risks, rollback, and the next safe task.

A task brief is required for architecture, security, privacy, multi-file, or longer-running changes. Tiny corrections may use the pull-request template alone.

## Boundaries

- Use fictional data in tests and examples. Never commit production data, credentials, private keys, connection details, or personal information.
- Raw evidence stays ignored. Commit only deterministic sanitized profiles or approved redacted evidence.
- Do not connect to the Windows VM, external services, or production systems unless the task explicitly requires and authorizes it.
- Preserve dirty worktree changes that are not part of the task.
- Do not treat research recommendations as proof. Record measurements and gate decisions separately.
- Do not invent owners, policy, retention periods, capacity limits, or access rules. Mark them as human decisions.
- Keep changes small and reversible. Put unrelated refactoring in a separate task.

## Sources of truth

When documents disagree, use this order and record the conflict:

1. accepted ADR and signed gate record;
2. measured evidence produced by a reproducible command;
3. current milestone and task brief;
4. final research baseline and batch reviews;
5. older research results and legacy handover material.

An ADR marked `Proposed` or `Experimenting` is not an accepted human decision.

## Definition of done

A change is done only when its acceptance criteria pass, generated files are current, confidentiality checks pass, relevant documentation is updated, residual risks are explicit, and Git shows no accidental files.
