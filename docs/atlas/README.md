# UAM Plan Atlas

The Plan Atlas is a generated, offline map of the UAM plan. Start with the [one-minute dashboard](generated/index.html).

It answers four practical questions:

1. Where are we now?
2. What may we work on now?
3. What proof is needed before later work starts?
4. Which detailed document supports each summary?

The Atlas does not approve anything. It cannot accept an ADR, pass a gate, assign an owner, approve policy, or replace measured evidence. Its only hand-maintained source is [atlas.json](atlas.json). Everything under `generated/` and `evidence/source-map.json` is rebuilt from that model and the linked source documents.

## Gate names

The accepted baseline names G0 through G5. It describes ten later aggregate proof gates but does not assign them G-numbers. The Atlas therefore uses neutral stable IDs `AG-06` through `AG-15`. This avoids quietly creating project terminology that has not been accepted.

Solid dependency arrows in the generated map mean a gate cannot pass until its predecessors pass. The gate pages separately describe preparation that may run earlier. Preparation is not permission to use live data or implement a blocked delivery gate.

## Everyday commands

```text
node scripts/atlas.mjs status
node scripts/atlas.mjs generate
node scripts/atlas.mjs validate
node scripts/atlas.mjs check
node scripts/atlas.mjs help
```

`validate` and `check` need the pinned repository-local D2 executable so they can prove that the generated D2 source renders twice to byte-identical SVG. Install it without administrator rights:

```text
node scripts/atlas.mjs bootstrap
```

The same command works in a Linux shell and a current Windows terminal with Node.js and `tar` available. It downloads one pinned official release archive, verifies SHA-256 before extraction, checks the D2 version, and installs under ignored `.tools/atlas/`. It never falls back to a system D2.

## Editing workflow

1. Change authoritative project documents first.
2. Update `atlas.json` only to summarize and link those documents.
3. Run `node scripts/atlas.mjs generate`.
4. Run `node scripts/atlas.mjs check` and `./scripts/validate-repository.sh`.
5. Review the generated dashboard and G0 page. Never change generated files by hand.

The committed SVG is a small deterministic offline preview generated directly from the same model; the D2 source remains the portable diagram definition. Validation renders that D2 source twice and rejects invalid or nondeterministic D2 output. Generation uses a temporary staged directory. A model, checksum, or link failure leaves the previous valid generated Atlas untouched.
