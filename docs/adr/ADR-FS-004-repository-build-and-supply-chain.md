# ADR-FS-004 — Repository, build, and supply chain

- **Status:** Experimenting
- **Date:** 2026-08-01
- **Owner:** Unassigned; repository and release governance must assign one

## Decision

Use a monorepo with explicit project boundaries. Deployable components may depend only on approved foundation and boundary modules. Builds use locked SDKs, dependencies, tools, package sources, CI actions, and generated output.

Build evidence must include reproducibility checks, a final-file manifest, dependency inventories, SBOM, provenance, and a clear handoff to signing. No floating versions or mutable release inputs are allowed for load-bearing builds.

## Why

The endpoint, server, portal, migration tools, test oracle, and privileged release path have different trust levels. Uncontrolled shared code or dependencies could quietly cross these boundaries.

## Alternatives considered

- Separate repositories immediately: rejected because contract and evidence changes would be harder to keep atomic at the current stage.
- A broad shared `Common` project: rejected because it hides dependency and authority growth.
- Floating dependencies and mutable CI tags: rejected because builds would not be reproducible.
- Treat an SBOM or scanner success as complete proof: rejected because tools can omit files and dependencies.

## Consequences

- Architecture tests must detect forbidden dependencies.
- Restore and builds must work from approved locked sources.
- Generated files are reviewed and reproducible.
- Signing remains a separate authority; CI build success does not authorize release.

## Required before acceptance

- Injected architecture violations are detected.
- Two clean builds reconcile to the expected output or explain permitted differences.
- File manifests, dependency inventories, SBOM, and provenance agree.
- Every external artifact has an admission record.

## Revisit when

Repository scale, team ownership, release isolation, or security evidence shows that separate repositories provide a clear benefit that outweighs atomic-change costs.

## Source

[Final synthesis, sections 4, 11, 16 and 17](../../research-packs/implementation/results/final-synthesis/next-generation-technical-baseline-result.md).
