---
name: research-workflow
description: Use when working under research/ — creating, scaffolding, running, validating, promoting, or archiving a research package, or continuing implementation while one-off research runs. Covers package cards, study scaffolding, code-zip inputs, reading lists, the Type-2 continuation cycle, and validation.
---

# Research package workflow

## Lifecycle

1. **Start** — one decision area. Create the package card (`research/<area>/README.md`): scope, decisions informed, status `Draft`, type, output mode, ETA, parallel plan, chosen prompt ingredients.
2. **Scaffold** — copy `research/templates/study/` per bounded question: `prompt.md`, `README.md`, `result-NN-<slug>.md`. Non-code inputs go in `attachments/` with classification, source, generation, and limitations.
3. **Run** — fresh chats. Inputs: one zip per code-bearing root (`git archive` of the declared ref; newly created code roots are added) plus curated attachments (ADRs, decisions-and-gates, evidence rules). The prompt embeds its own reading list. Save answers verbatim at the declared targets.
4. **Validate** — review checklist per study, then `node scripts/validate-research.mjs`.
5. **Promote** — only conclusions travel, each human-gated: ADR proposal, gate input, as-built facts, deviation-log entries, or adopted-package record. Dispositions land in `conclusions.md`.
6. **Archive** — status `complete`; package stays in place; hash ledger current. Rejected routes recorded in `research/README.md`.

Statuses: `Draft` → `in progress` → `complete` · `abandoned` · `superseded`.

## Types

- **Type 1 `extensive`** — many parallel prompts, optional batching; implementation usually pauses.
- **Type 2 `one-off`** — one step (possibly parallel); implementation continues in the safe lane.

## Type-2 continuation cycle

- PRE-FLIGHT: card (type, ETA, decisions informed); prompt committed as a draft study; name the SAFE LANE from the next-safe-task lists.
- IN-FLIGHT: work only the safe lane; dependent tasks get status `Blocked: pending research <package>`.
- LANDING (15 min): save results verbatim → validate → dispose conclusions → continue or pivot.
- PIVOT: deviation-log line; ADR amendment if the decision changed; rejected-route disposition.

## Rules

- Results are preserved evidence: never silently rewrite; intentional changes need a recorded reason and refreshed hash.
- Reading list ALWAYS embedded in the prompt — inputs are shared by all parallel prompts and every multi-step run.
- Research evidence never becomes acceptance; promotion requires a human disposition.
- Know the objective state: what is disposable, frozen, uncertain — ask the human when in doubt.
