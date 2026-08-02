# UAM modernization

Internal technical handover and modernization plan for the User Activity Monitor (UAM).

This repository captures the current PowerShell-based endpoint agent, its SQL data model and PowerShell Universal administration application. It also describes the proposed migration to a modular C#/.NET architecture with offline-first endpoint storage, HTTPS ingestion and a modern administration portal.

## Start here

1. Open the generated [one-minute Plan Atlas](docs/atlas/generated/index.html).
2. Read [what we are building](docs/plain-language/00-what-we-are-building.md).
3. Check [current, next, and later](docs/plain-language/01-current-next-later.md).
4. Open the [current milestone](docs/milestones/G0-fictional-evidence-foundation.md).
5. Before changing files, follow [AGENTS.md](AGENTS.md) and the [repeatable task workflow](docs/work/README.md).
6. Use the [architecture decisions](docs/adr/README.md) and [research baseline](research/implementation/synthesis/result-implementation-technical-baseline.md) when more detail is needed.

The [repository map](docs/architecture/repository-layout.md) explains where everything belongs.

## Repository status

The current contents are a validated handover package, completed implementation research, proposed ADRs, and a G0 pre-implementation foundation. Production implementation of the replacement C# platform has not started. The included legacy source is redacted reference material and must not be deployed.

## Validation

Run all repository checks:

```bash
node scripts/atlas.mjs bootstrap
./scripts/validate-repository.sh
```

Run the documentation validation from PowerShell 7.2 or newer:

```powershell
./UAM-overdracht-INTERN-2026-07-23/scripts/Test-UamDocumentationDeliverables.ps1
```

The same validation runs automatically for pushes and pull requests through GitHub Actions.

## Confidentiality

This repository contains internal technical information, including internal application and URL configuration. Keep the GitHub repository private and do not redistribute its contents without a security and privacy review. See [`SECURITY.md`](SECURITY.md).
