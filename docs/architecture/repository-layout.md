# Repository layout

## Design goal

A new person or agent should find purpose, current scope, the next task, governing decisions, and the validation command from the root without searching chat history. Detailed evidence stays available without crowding that path.

## Current and reserved structure

```text
/
├── README.md                    start here
├── AGENTS.md                    shared working agreement
├── CONTRIBUTING.md              contribution and review rules
├── docs/
│   ├── plain-language/          simple explanation and scope
│   ├── milestones/              useful outcomes and gate evidence
│   ├── work/                    current tasks, templates, handoffs
│   ├── adr/                     important decisions
│   ├── architecture/            stable system and repository views
│   └── governance/              ownership and human decisions
├── contracts/                   versioned schemas and examples (G0 onward)
├── src/                         deployable implementation (not started)
├── tests/                       automated tests and fictional fixtures
├── tools/                       repository-owned utilities/simulators
├── evidence/
│   ├── manifests/               hashes and provenance
│   └── sanitized/               safe derived measurements
├── research/                    colocated studies, reviews, syntheses, evidence
├── UAM-overdracht-INTERN-*/     preserved legacy handover evidence
├── scripts/                     deterministic generation/validation
└── .github/                     CI, task forms, and review template
```

README placeholder files reserve future code boundaries without pretending that implementation exists.

## Where a change belongs

| Change | Location | Rule |
| --- | --- | --- |
| Simple explanation of behavior/scope | `docs/plain-language/` | Prefer this for the first reader. |
| Delivery outcome or gate | `docs/milestones/` | State evidence and human acceptance. |
| Work being done | `docs/work/current/` | One observable outcome per task. |
| Architecture decision | `docs/adr/` | Include alternatives and status. |
| Reproducible measurement | `evidence/` | Commit sanitized output and provenance, not sensitive raw input. |
| Contract shape | `contracts/` | Version schema and valid/invalid examples together. |
| Product behavior | `src/` | Keep deployable components explicit. |
| Test behavior | `tests/` | Never depend on production or personal data. |
| Repeatable repository command | `scripts/` or `tools/` | Provide help and a deterministic check mode. |

## Layered agent instructions

The root `AGENTS.md` contains stable repository rules. A nested `AGENTS.md` is added only when a subtree has genuinely different commands or safety constraints. It should state differences, not copy the root. This keeps the instruction chain small and prevents contradictory guidance.

## Cleanup rules

- Generated files must identify a generator and be checkable without rewriting them.
- Raw catalogues, credentials, local environments, build output, and temporary files stay ignored.
- Do not reorganize preserved evidence merely for visual neatness; moves must improve retrieval and retain history.
- No empty framework, service, or dependency is added before its milestone.
- Review temporary placeholders at every gate and remove those that no longer communicate a real boundary.

## Why this layout

It follows established repository guidance: keep root instructions concise, put contribution rules and templates in conventional locations, use layered path-specific instructions sparingly, make small self-contained changes, and protect automated workflows. Applied sources are recorded in [the source register](source-register.md).
