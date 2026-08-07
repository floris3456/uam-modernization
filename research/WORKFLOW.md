# Repeatable research workflow

The lifecycle for any research package. Procedures for the specific roles (authoring prompts, reviewing, distilling) live in the skills (`.opencode/skills/`); this document is the human-facing overview.

## Lifecycle

1. **Start** — one decision area. Create the package card (`research/<area>/README.md`) with scope, decisions informed, status `Draft`, type, output mode, ETA, parallel plan, and chosen prompt ingredients.
2. **Scaffold** — copy the study template (`templates/study/`) per bounded question: `prompt.md`, `README.md`, and a unique `result-NN-<slug>.md` target. Non-code inputs the researcher needs go in `attachments/` with classification, source, generation, and limitations.
3. **Run** — fresh chats. The agent receives one zip per code-bearing root (`git archive` of the declared ref) plus curated attachments; the prompt embeds its own reading list. Save answers verbatim at the declared result targets.
4. **Validate** — review checklist per study, then `node scripts/validate-research.mjs`. Contradictions are reconciled in a package review.
5. **Promote** — only conclusions travel, each human-gated: ADR proposal, gate input, per-component as-built facts, deviation-log entries, or (rare) an adopted-package record. `conclusions.md` carries the dispositions.
6. **Archive** — status `complete`; the package stays in place; the hash ledger is current. Rejected routes are recorded in `research/README.md` so they are never re-researched.

## Research types

- **Type 1 `extensive`** — many parallel prompts, optional batching; implementation usually pauses.
- **Type 2 `one-off`** — one step (possibly parallel); implementation continues in the safe lane.

Type-2 cycle: PRE-FLIGHT (card, draft prompt committed, safe lane named) → IN-FLIGHT (safe-lane work only; dependent tasks marked blocked) → LANDING (results saved verbatim, validated, conclusions disposed; continue or pivot) → PIVOT (deviation-log line, ADR amendment if the decision changed, rejected-route disposition).

## Inputs and outputs

- **Inputs:** per-root code zips (code-bearing roots only; newly created roots are added) + curated attachments for non-code context (ADRs, decisions-and-gates, evidence rules). No videos, PDFs, `docs/`, `research/`, `evidence/`, or handover content ships. A quick human check approves the pack before upload.
- **Output mode** (`synthesis` | `synthesis+implementation`): if the next artifact is a plan, request the theoretical implementation (separate file, THEORETICAL/ESTIMATE labels, change conditions); otherwise synthesis only, with labeled seeds when they help the next step.
- **Reading list** is always embedded in the prompt itself — inputs are shared by all parallel prompts and every multi-step run.

## Validation

```bash
node scripts/validate-research.mjs
./scripts/validate-repository.sh
```

Validation is walk-based and suite-agnostic: structure, README presence, prompt/result co-location, globally unique result names, secrets, private addresses, internal URLs, stale layout references, attachment classification fields, link resolution, and heading-anchor resolution. Package-card field checks apply to all packages except the preserved `baseline` and `implementation` suites (grandfathered) and `templates/`.

## Links and anchors

All cross-references use heading-anchor markdown links. Existing results keep their structure; new templates mandate stable heading anchors for every load-bearing section. Line-level links are not portable; the heading is the precision unit.

## Promotion boundaries

Research recommends and explains. ADRs record human decisions. CLI experiments provide project-specific proof. Research evidence never becomes acceptance by itself.
