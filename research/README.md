# UAM research

This directory contains completed research evidence in a layout designed for people and agents.

## Start here

1. Read the current [implementation synthesis](implementation/synthesis/result-implementation-technical-baseline.md).
2. Open the relevant [implementation batch](implementation/batches/README.md).
3. Open an individual study only for its detailed evidence.
4. Use [the workflow](WORKFLOW.md) when adding or refreshing research.

## Layout

```text
research/
├── README.md                 this index
├── WORKFLOW.md               repeatable research lifecycle
├── AGENTS.md                 local safety and maintenance rules
├── catalog.json              authoritative research definition
├── manifest.json             machine-readable suite index
├── templates/                new-study and review templates
├── baseline/                 completed first research cycle
│   ├── context/
│   ├── attachments/
│   ├── studies/<study>/      prompt + result + README
│   └── synthesis/            prompt + result
└── implementation/           current implementation research
    ├── context/
    ├── attachments/
    ├── evidence/
    ├── batches/<batch>/
    │   ├── <study>/          prompt + result + README
    │   └── review/           prompt + result + README
    └── synthesis/            prompt + result + README
```

## Invariants

- A study keeps its prompt and result together.
- Result filenames are globally unique so they can coexist in a ChatGPT Project.
- Shared context and uploadable attachments are separate.
- A batch review consumes its studies and earlier reviews; the final synthesis consumes batch reviews, not every topic.
- Generated material is changed through its generator and checked in CI.
- Batches, studies, attachments, and dependencies are declared once in `catalog.json`.
- Research evidence cannot approve policy, risk, ownership, or production use.

## Repeat the workflow

Use `node scripts/research.mjs help`. The normal loop is `add`, edit the one catalogue entry, `generate`, run the web research, save its result beside the prompt, then `validate`.
