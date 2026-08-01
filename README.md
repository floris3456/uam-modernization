# UAM modernization

Internal technical handover and modernization plan for the User Activity Monitor (UAM).

This repository captures the current PowerShell-based endpoint agent, its SQL data model and PowerShell Universal administration application. It also describes the proposed migration to a modular C#/.NET architecture with offline-first endpoint storage, HTTPS ingestion and a modern administration portal.

## Start here

1. Read [`README-OVERDRACHT.md`](UAM-overdracht-INTERN-2026-07-23/README-OVERDRACHT.md).
2. Review the [current-state summary](UAM-overdracht-INTERN-2026-07-23/docs/00a-uam-ist-samenvatting-a4.md).
3. Review the [target-state summary](UAM-overdracht-INTERN-2026-07-23/docs/00b-uam-doelbeeld-samenvatting-a4.md).
4. Use the [migration roadmap](UAM-overdracht-INTERN-2026-07-23/docs/05-migration-map-roadmap.md) for implementation planning.
5. Review the [initial architecture decisions](docs/adr/README.md) before starting implementation.

## Repository status

The current contents are a validated handover package and migration specification. They are not yet the implementation repository for the replacement C# platform. The included legacy source is redacted reference material and must not be deployed.

## Validation

Run the documentation validation from PowerShell 7.2 or newer:

```powershell
./UAM-overdracht-INTERN-2026-07-23/scripts/Test-UamDocumentationDeliverables.ps1
```

The same validation runs automatically for pushes and pull requests through GitHub Actions.

## Confidentiality

This repository contains internal technical information, including internal application and URL configuration. Keep the GitHub repository private and do not redistribute its contents without a security and privacy review. See [`SECURITY.md`](SECURITY.md).
