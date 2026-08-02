# REPO-002 — Make research creation repeatable

**Status:** Complete
**Gate/milestone:** Repository preparation; no delivery gate changed
**Accountable human:** Repository owner

## Useful outcome

A person or agent can understand, add, regenerate, and validate research through one documented workflow without editing several copies of the same metadata.

## In scope

- One human-readable catalogue for suites, batches, studies, attachments, and dependencies.
- One CLI for listing, scaffolding, generating, checking, and validating research.
- Generated prompts, indexes, allowlists, and manifests derived from that catalogue.
- Validation that rejects catalogue mistakes and unfinished scaffolds.

## Out of scope

- Changing existing research conclusions or result evidence.
- Starting G0 implementation or changing an accepted product decision.
- Connecting to the Windows lab or any external service.

## Acceptance evidence

1. Existing prompt and result paths remain stable.
2. Dependencies are declared once and consumed by generation and validation.
3. A documented CLI can scaffold a new draft study.
4. Generated files are deterministic and repository validation passes.
5. Existing research result content is unchanged.

## Failure, recovery, and rollback

The catalogue and CLI are ordinary versioned files. Revert the commit if generation changes evidence, loses paths, or makes validation less strict.

## Validation commands

```bash
node scripts/research.mjs check
node scripts/research.mjs validate
```

## Handoff requirements

- Record the command contract and the catalogue ownership rule.
- Report preservation checks for research results.
- Keep G0 as the only active implementation gate.
