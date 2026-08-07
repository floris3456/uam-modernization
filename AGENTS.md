# Repository working agreement

Human-first; token-efficient; small reversible changes; run the validator before handoff.

## Invariants

- Research is never acceptance; gates are human-accepted.
- Research results are immutable evidence; intentional changes are recorded and the hash ledger refreshed.
- Raw production data never travels: never committed outside the preserved handover boundary (`UAM-overdracht-INTERN-*`), never zipped for research.
- A fact has one normative home; everywhere else links (references, not copies).
- Plans are proposals; as-built records are facts; reality wins.
- Know the objective state of the repository (what is disposable, frozen, uncertain) — when a premise is uncertain, ASK the human.
- System changes follow the documentation protocol in the design record.

## Skill triggers

| When | Load |
| --- | --- |
| Work under `research/` | `research-workflow` |
| Writing or reviewing a research prompt | `prompt-authoring` |
| Implementing or touching a component | `as-built` |
| Reviewing code or PRs | `code-review` |
| Milestone, deviation-log, or gate work | `gate-workflow` |
| Starting or finishing a task | `task-workflow` |
| Turning a conversation into documentation | `conversation-distiller` |

Skills live in `.opencode/skills/`; agents in `.opencode/agents/` (orchestrator, developer, heavy — heavy is read-only).

## Pointers

- [README.md](README.md) — start here
- [docs/work/README.md](docs/work/README.md) — task workflow
- [research/WORKFLOW.md](research/WORKFLOW.md) — research lifecycle overview
- [docs/architecture/repository-layout.md](docs/architecture/repository-layout.md) — where things belong
- `./scripts/validate-repository.sh` — all checks
