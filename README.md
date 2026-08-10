# UAM modernization

This public repository contains the preserved User Activity Monitor (UAM) handover, research evidence, contracts, milestone records, and the implementation workspace for the replacement platform.

## Start here

1. Read [`docs/plain-language/00-what-we-are-building.md`](docs/plain-language/00-what-we-are-building.md).
2. Check [`docs/plain-language/01-current-next-later.md`](docs/plain-language/01-current-next-later.md).
3. Read the active milestone under [`docs/milestones/`](docs/milestones/).
4. Before changing files, follow [`AGENTS.md`](AGENTS.md) and [`docs/work/README.md`](docs/work/README.md).
5. Use [`docs/architecture/agent-system.md`](docs/architecture/agent-system.md) for the web/local authority model and [`docs/architecture/repository-layout.md`](docs/architecture/repository-layout.md) for file placement.

## Branches

- `developer` is the shared active implementation branch. Every implementation commit is pushed immediately.
- `main` contains implementation explicitly accepted by the human. Acceptance occurs through a reviewed local `developer` to `main` merge.
- `web-orchestration` contains only the web orchestrator's persistent task context. It is never merged into implementation branches.

## Working records

- `docs/work/current/<task-id>-<slug>.md` is temporary procedural memory for one active developer task.
- Component `AS-BUILT.md` files are continuously maintained implementation truth and live developer memory.
- Deviation records are continuously maintained when actual implementation differs materially from accepted plans or design.

Task-progress is removed during finalization after its durable information has been reconciled into the correct records.

## Public repository

Anything committed here must be safe for public disclosure. Never commit credentials, private chat text, production exports, personal data, tokens, cookies, browser profiles, or unreviewed sensitive values. Preserved handover and raw external evidence remain readable but immutable. See [`SECURITY.md`](SECURITY.md).

## Validation

```bash
./scripts/bootstrap-agent-workflow.sh
./scripts/validate-repository.sh
```

Run bootstrap once per clone; later use `./scripts/bootstrap-agent-workflow.sh --check` to verify activation without changing configuration.

The preserved handover has its own PowerShell validation:

```powershell
./UAM-overdracht-INTERN-2026-07-23/scripts/Test-UamDocumentationDeliverables.ps1
```

## Current product status

The repository currently contains a validated legacy handover, implementation research, proposed architecture, and pre-implementation foundations. The preserved legacy source is reference evidence and must not be deployed as the replacement platform.
