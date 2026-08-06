# UAM research

This directory holds research packages: studies with prompts and preserved results, reviews, syntheses, and decision sheets. Each package is self-contained and described by its package card (`README.md`). The repeatable lifecycle lives in [WORKFLOW.md](WORKFLOW.md); the role procedures live in the skills (`.opencode/skills/`).

## Packages

| Package | Status | Contents |
| --- | --- | --- |
| [baseline](baseline/README.md) | complete-historical | first research cycle, retained for provenance |
| [implementation](implementation/README.md) | complete | 24 studies, 6 batch reviews, one final synthesis |

## Reading order

1. Read the current [implementation synthesis](implementation/synthesis/result-implementation-technical-baseline.md).
2. Open the relevant package card.
3. Open an individual study only for its detailed evidence.

## Layout

```text
research/
├── WORKFLOW.md                 repeatable research lifecycle
├── templates/                  package-card, study, and review templates
├── <package>/
│   ├── README.md               package card: scope, status, decisions informed
│   ├── attachments/            sanitized non-code inputs (optional)
│   ├── studies/NN-<slug>/      prompt + result + README
│   ├── review/                 only when the area is batched
│   └── synthesis/              prompt + result (+ conclusions.md)
└── (a future package sits beside the others)
```

## Invariants

- A study keeps its prompt and result together; result filenames are globally unique.
- Populated results are preserved evidence. Do not rewrite them casually; intentional changes are recorded and the hash ledger refreshed.
- Generated research artifacts no longer exist — validation is walk-based and suite-agnostic; templates give the shape.
- Research evidence cannot approve policy, risk, ownership, or production use; promotion requires a human disposition.

## Rejected routes

Routes rejected by human disposition are recorded here so they are never re-researched. To be filled as packages complete.

## Validate

```bash
node scripts/validate-research.mjs
./scripts/validate-repository.sh
```
