# ADR-FS-032 — External dependency admission

- **Status:** Proposed
- **Date:** 2026-08-01
- **Owner:** Unassigned; dependency and security review must assign owners

## Decision

Every external library, tool, action, container, executable, service, or copied implementation must be classified as:

- an admitted dependency;
- a test or build candidate;
- reference material only; or
- rejected.

Before execution, an admitted artifact needs exact source, package and binary mapping; version or commit; license review; maintenance and security assessment; tests and positive controls; transitive dependencies; required authority and network access; and a removal or replacement path.

Popularity is not evidence of fit.

## Why

External components can add code execution, network access, licensing obligations, supply-chain risk, hidden defaults, or a failure domain that does not match UAM.

## Alternatives considered

- Trust popular or vendor-supported packages automatically: rejected because popularity does not prove UAM security, privacy, or operational fit.
- Review only runtime libraries: rejected because build, test, CI, migration, and operations tools also execute with authority.
- Approve a package from a source-repository review alone: rejected because the downloaded binary may not map cleanly to that source.

## Consequences

- Reference repositories are not copied or executed automatically.
- Dependencies remain behind narrow adapters where practical.
- Mutable branches, short commit references, floating tags, and unexplained binaries are prohibited for load-bearing evidence.
- A successful scanner exit code is never the sole proof of safety or completeness.

## Required before acceptance

- The admission-record schema and review workflow exist.
- Selected candidates pass positive and negative controls.
- Locked restore proves exact artifact provenance.
- Removal paths and accountable owners are recorded.

## Revisit when

A dependency becomes unsupported, changes license or ownership, suffers a relevant incident, fails a positive control, introduces unacceptable transitives, or can no longer be reproduced.

## Source

[Final synthesis, sections 16 and 17](../../research-packs/implementation/results/final-synthesis/next-generation-technical-baseline-result.md).
