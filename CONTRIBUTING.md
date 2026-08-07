# Contributing

Start with [AGENTS.md](AGENTS.md). The same workflow applies whether the change is made by a person, an agent, or both.

## Before changing anything

- Check `git status` and preserve unrelated changes.
- Read the current task in `docs/work/current/`.
- Confirm which gate is active and which decisions are still human-owned.
- Copy the appropriate template from `docs/work/templates/` when the task needs a brief.

## Make reviewable changes

- Solve one coherent problem per change.
- Keep generated content tied to its generator and provide a `--check` mode where practical.
- Add tests or measured evidence with the behavior they support.
- Update the simplest useful documentation at the same time.
- Explain why the change is needed and what is deliberately excluded.

## Validate

Run:

```bash
./scripts/validate-repository.sh
```

If a check cannot run locally, state exactly which check, why, and who must run it. Never describe an unrun check as passed.

## Review and handoff

Use the pull-request template even for an internal review. A reviewer should be able to understand the outcome, evidence, security/privacy effect, rollback, and remaining human decisions without reconstructing the work from chat history.

Review follows the policy in [docs/work/README.md](docs/work/README.md): the agent decides whether human review is needed (uncertain → yes, certain → no, explicit human request → always); skipped reviews record `review skipped because …` in the handoff; when human review is required, the handoff carries a human review guide (what to look at when testing, which tools/commands to use).
