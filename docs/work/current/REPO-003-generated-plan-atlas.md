# REPO-003 — Generate an offline UAM Plan Atlas

**Status:** Blocked
**Gate/milestone:** Repository preparation; no delivery gate changes
**Accountable human:** UNASSIGNED

## Useful outcome

A new reader can quickly understand what UAM is, where the project stands, what each proof gate must establish, and which detailed documents support the summary. The Atlas reduces repeated reading without replacing decisions, evidence, or gate records.

## In scope

- One authoritative visualization model for all 16 aggregate proof gates.
- A detailed, easy-language G0 view and overview-level views of the later gates.
- Generated offline HTML, Markdown, D2, and SVG views.
- A repository-local, checksum-verified D2 bootstrap process for supported Linux and Windows terminals.
- Deterministic, failure-safe generation and strict validation.
- Repository validation and pinned GitHub Actions integration.

## Out of scope

- Accepting an ADR, passing a gate, assigning an owner, or approving policy.
- Implementing G0 product code or any later delivery gate.
- Connecting to the Windows lab, production systems, or real activity data.
- Replacing milestone records, ADRs, measured evidence, or detailed specifications.
- Adding dates, production-readiness claims, legal conclusions, or invented approvals.

## Inputs and source of truth

- [Current/next/later](../../plain-language/01-current-next-later.md)
- [Implementation scope](../../plain-language/implementation-scope.md)
- [G0 milestone](../../milestones/G0-fictional-evidence-foundation.md)
- [Current G0 decision task](G0-001-foundation-decisions.md)
- [ADR register](../../adr/README.md) and the current initial ADRs relevant to G0
- [Implementation technical baseline](../../../research/implementation/synthesis/result-implementation-technical-baseline.md), especially sections 10.2 and 11, as research evidence rather than gate proof
- Existing generators, validation scripts, CI workflows, Git status, and repository history

## Constraints and human decisions

- G0 remains the only active delivery gate and remains open.
- All gate owners remain `UNASSIGNED` until an authoritative source names them.
- Human acceptance of the initial ADRs, privacy ceiling examples, contract vocabulary, and named G0 reviewers remains outside this task.
- Later aggregate gates use neutral stable Atlas IDs because the baseline does not currently name them G6 through G15.
- D2 selection must be based on current official release and installation evidence. Release artifacts must be pinned by SHA-256.

## Acceptance evidence

1. Every generated view derives from `docs/atlas/atlas.json`.
2. All 16 aggregate gates are visible and their hard dependencies form a directed acyclic graph.
3. Research, ADR, implementation, and gate statuses remain visibly separate.
4. G0 explains its decisions, permissions, prohibitions, CLI evidence, stops, recovery, and unlocks in easy language.
5. No status, owner, approval, policy, or production readiness is invented.
6. Static HTML works offline, is keyboard accessible, and makes no external request.
7. Generation is deterministic and does not replace valid output after a failure.
8. Validation rejects a bad dependency, stale output, false pass state, and broken source link.
9. Existing research results remain byte-for-byte unchanged.
10. Focused checks and the complete repository validation pass.
11. Diagram cards open their detailed gate pages and use complete plain-language summaries without cut-off text.

## Failure, recovery, and rollback

- Generation builds and validates a temporary staged tree before replacing generated output.
- Download, checksum, extraction, version, model, render, and link failures leave the previous Atlas intact.
- The repository-local D2 tool can be removed and bootstrapped again without changing source documents.
- Revert the Atlas commit if its summaries conflict with authoritative records; never rewrite evidence to satisfy the visualization.

## Validation commands

```bash
node scripts/atlas.mjs generate
node scripts/atlas.mjs validate
node scripts/atlas.mjs check
node scripts/atlas.mjs smoke-test
./scripts/validate-repository.sh
```

## Handoff requirements

- Record the exact D2 version, license, artifact hashes, and installation paths.
- Report the Atlas entry point, CLI contract, validation results, preservation check, and residual risks.
- Keep G0 open and preserve every unrelated file and change.
- Commit intentionally and push with terminal commands when external GitHub connectivity permits.

## Current validation state

- The model, generated-file set, source links, status rules, confidentiality checks, deterministic generation, research validation, pre-implementation validation, and four required smoke mutations pass locally.
- The required real D2 render check is blocked because this environment's outbound HTTP tunnel returns 403 while downloading the pinned official release archive. The bootstrap fails before extraction and leaves `.tools/atlas/` without an executable.
- The complete repository validator therefore stops at the Atlas D2 check. Do not mark this task `Review` or `Done` until `node scripts/atlas.mjs bootstrap` and `node scripts/atlas.mjs check` pass in a network-enabled terminal.
