# Repeatable research workflow

## 1. Define one decision area

Create a study only when research can reduce a real uncertainty. State the decision informed, boundaries, accepted inputs, provisional matters, human decisions, and measurements that research cannot replace.

## 2. Scaffold one study

Use the CLI. It assigns the next global study ID, records the batch and dependencies once, and creates the standard folder:

```bash
node scripts/research.mjs add \
  --batch 6 \
  --slug example-topic \
  --title "Example topic" \
  --role "principal example-domain architect" \
  --reviews 1,2,3 \
  --topics 22
```

```text
NN-short-topic/
├── README.md
├── prompt.md
└── result-NN-short-topic.md
```

The new entry is deliberately marked `draft`. Replace every `TODO` in `catalog.json`, check the attachment allowlist and dependencies, then set its status. The unique result filename lets multiple results coexist in one ChatGPT Project.

## 3. Declare inputs before running

Edit only the study entry in `catalog.json`. The generator derives the prompt, result target, Project-file allowlist, suite manifest, dependency handoff, and navigation. Never edit those generated copies to change study metadata.

## 4. Run and preserve

Run the prompt in a fresh chat, save the complete answer at the declared result path, and do not silently rewrite the result. Corrections need a task record, reason, and refreshed evidence hash.

## 5. Review at the right boundary

Topics may run in parallel when dependencies allow. A batch review reconciles its topic results and all accepted predecessor reviews. Only accepted reviews flow into the final synthesis.

## 6. Convert research into work

Research outputs become proposed ADR changes, human-decision workshops, or falsifying CLI experiments. They do not directly become accepted implementation requirements.

## 7. Validate

```bash
node scripts/research.mjs check
node scripts/research.mjs validate
```

Validation checks structure, unique names, manifests, allowlists, links, generated state, secrets, private addresses, and synthesis dependencies.

## Common commands

```bash
node scripts/research.mjs list       # show batches, studies, and status
node scripts/research.mjs next       # print the next global study ID
node scripts/research.mjs generate   # rebuild all derived research files
node scripts/research.mjs check      # fast deterministic and safety checks
node scripts/research.mjs validate   # complete repository validation
```

`catalog.json` is authoritative. `research/manifest.json` and `implementation/manifest.json` are generated indexes for tools and must never become competing sources of truth.

## Catalogue field guide

| Field | Meaning |
| --- | --- |
| `attachments` | Complete safe attachment inventory for the implementation suite. |
| `reviewAttachments` / `synthesisAttachments` | Shared files allowed in reviewer and final-synthesis chats. |
| `batches[]` | Human title, timing, parallel CLI lane, and stop/go gate for one research stage. |
| `studies[].id` / `batch` / `slug` | Stable global ID, owning batch, and filesystem-safe name. Never recycle an ID. |
| `role` / `questions` / `deliverables` | Exact researcher role, bounded questions, and mandatory implementation-ready outputs. |
| `human` / `cli` / `gate` | What research cannot decide, what must be measured, and what stops dependent work. |
| `oss` | Open-source implementation families the researcher must inspect critically. |
| `dependsOn.batchReviews` | Accepted earlier batch reviews this topic may read. |
| `dependsOn.topicResults` | Exceptional same-stream topic evidence this topic may read before batch review. |
| `status` | `draft`, `in-progress`, or `complete`; omitted historical entries default to complete. |

Every batch reviewer automatically consumes all studies in its batch and all earlier batch reviews. The final synthesis automatically consumes every batch review. These are workflow invariants, so they are derived rather than copied into every entry.
