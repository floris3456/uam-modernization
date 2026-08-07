# Design record — repository workflow redesign

**Purpose:** the durable design record of the repository workflow redesign (research packages, as-built layer, promotion, prompt craft). Operative homes: `AGENTS.md` (invariants + skill triggers), `research/WORKFLOW.md` (research lifecycle overview), `.opencode/skills/` (role procedures), `.opencode/agents/` (agent definitions), `docs/architecture/repository-layout.md` (structure), `research/templates/` (shapes), `docs/work/README.md` + `docs/work/templates/` (task lifecycle and forms), `scripts/*.mjs` + `.github/workflows/` (validation and CI), `opencode.example.json` (committed config template) vs global `opencode.json` (uncommitted credentials). This file records the design and its decisions; it does not duplicate the operative homes.
**Adopted:** 2026-08-07, after heavy-model execution review (ses_024d20c08ffeRh11coFO4CwdQ6) and triage.

## Mission

Remove bloat and make the repository easy to understand and maintain for a human. Token minimization and speed are priorities in architectural decisions — never at the cost of the reliability that good documentation provides.

## Three kinds of truth — never mixed in one file

| Kind | Format | Status marker | Can it be wrong? |
| --- | --- | --- | --- |
| Proposal | research synthesis / future implementation plan | labeled (FACT / ASSUMPTION / RECOMMENDATION / CLI EXPERIMENT / HUMAN DECISION) | Yes — expected |
| Decision | ADR | Proposed → Experimenting → Accepted | Only by supersession |
| Fact | as-built record | verified by proof command | No — the record |

Where each kind lives: `research/<package>/` (proposals, immutable), `docs/milestones/<gate>.md` (plans), `docs/adr/` (decisions), `src/<component>/AS-BUILT.md` (facts), `<gate>-deviations.md` (deltas), `docs/architecture/adopted-packages/` (human-signed acceptances).

## Core principles

1. **One home per fact** — a fact has one normative place; everywhere else links.
2. **Presentation is allowed, duplication is not** — summaries are the document's own framing; honesty test: if editing the source forces an edit of the summary, it is duplication.
3. **Research is never acceptance** — gates are human-accepted; results are immutable evidence (hash ledger).
4. **Raw data never travels** — never committed outside the preserved handover boundary (`UAM-overdracht-INTERN-*`), never zipped for research.
5. **Small, reversible changes** — validator after each.
6. **Know the objective state** — know what is disposable, frozen, uncertain; when a premise is uncertain, ASK the human.

## Research packages

- Lifecycle: Start (package card) → Scaffold (study template) → Run (fresh chats, code zips + curated attachments, reading list embedded) → Validate (review checklist + `node scripts/validate-research.mjs`) → Promote (conclusions sheet, human-gated) → Archive (status `complete`, stays in place).
- Statuses: `Draft` → `in progress` → `complete` · `abandoned` · `superseded`.
- Types: Type 1 `extensive` (implementation pauses) · Type 2 `one-off` (implementation continues in the safe lane; PRE-FLIGHT / IN-FLIGHT / LANDING / PIVOT cycle).
- Output modes: `synthesis` (conclusions + visible reasoning; 1-page Human summary front section) · `synthesis+implementation` (adds `theoretical-implementation.md`, THEORETICAL/ESTIMATE labels, unverified until CLI experiment).
- Inputs: one zip per code-bearing root (`git archive` of the declared ref; new roots auto-included); non-code context as curated attachments; never videos, PDFs, `docs/`, `research/`, `evidence/`, or handover content.
- Destination: results stay in place, immutable; only conclusions travel, each human-gated (ADR proposal / gate input / as-built facts / deviation-log entries / adopted-package record).
- Rejected routes are recorded in `research/README.md` and checked at PRE-FLIGHT.
- Reading ladder: conclusions.md (1 page) → Human summary (1 page) → milestone About (5 lines) → full results.
- `conclusions.md` is a living file OUTSIDE the hash ledger; dispositions fill its column; the ledger protects raw results only.

## Prompt authoring

Ingredient catalogue with inclusion conditions lives in the `prompt-authoring` skill. Output-mode rule: next artifact is a PLAN → `synthesis+implementation`; decision or next step → `synthesis`. OSS research synthesis shape is mandatory when the ingredient is included. Every prompt demands visible reasoning and stable ASCII heading anchors; the package card records chosen ingredients and why.

## Milestones and plans

Later gates materialize as framing stubs when they become active (5-line About + links to informing studies); until then they remain in the research baseline. Full plans are written on demand. Summaries are the plan's own framing, never copies.

## As-built records and deviations

- `src/<component>/AS-BUILT.md`, updated during work; pure current-state truth with a proof command per fact; direct dependencies only, no patch versions; facts replaced, history in git; quality bar = 1:1 reconstruction from records + code + tests + contracts, verified by proof commands.
- A fact without a proof command is a claim, not a fact.
- Differences between plan and reality are recorded in a separate per-gate deviation log (`<gate>-deviations.md`: plan ref → as-built ref → because), never inside as-built records.

## Implementation procedure

Task loop: pre-flight (read as-built, gate status, safe lane) → work (small commits, as-built + deviation lines as you go) → finish (validator, handoff with as-built delta, deviation lines, next safe task, review decision). Review policy: the agent decides (uncertain → human, certain → not, explicit request → always); skipped reviews record `review skipped because …`; required human reviews carry a human review guide in the handoff.

## Agent team and relay

| Agent | Model | Role | Write scope |
| --- | --- | --- | --- |
| `orchestrator` | deepseek flash | main chat; owns docs/, research/, evidence/, AGENTS.md, skills, task briefs | its scope only |
| `developer` | deepseek flash | code + tests + self-review; owns src/, tests/, contracts/, as-built records, own handoffs | its scope only |
| `heavy` | Kimi K3 | thinking/review only; separate session | NOTHING (read-only) |
| fork of `orchestrator` | deepseek flash | writing relay: distills conversations into docs | only with human approval |

Rules: personas are skills on the same model (never switch models mid-chat — cache); agents committed to the repo, credentials stay global; heavy read-only enforced by permission config (best-effort — allow patterns are prefix globs; separator chains `&&`/`||`/`;`/`|` are denied, and instruction plus git are the backstop); driving the heavy chat via `opencode run --session` (append) and `opencode export` (read, includes reasoning); no handoff files between relay chats — git is the handoff; the write-scope map prevents conflicts without worktrees.

## Validation

`./scripts/validate-repository.sh` runs: code-reference freshness, suite-agnostic research validation (structure, README presence, prompt sections, prompt/result co-location, uniqueness, secrets, private addresses, internal URLs, stale references, attachment fields, link + heading-anchor resolution, synthesis Human summary, conclusions shape, package-card fields), evidence-manifest freshness (hash ledger — results AND prompts; conclusions.md deliberately excluded as a living file), pre-implementation checks (required files, links + anchors in docs, action pins, skill-trigger ↔ skills-directory sync), and the handover validation (Windows CI). GitHub Actions workflows run the single entry point `validate-repository.sh`.

## Documentation protocol for system changes

Applied when the system itself changes — workflow, agents, skills, governance, tooling, validation, CI.

1. **Record the decision** — one dated row in the decisions log: what changed, why, when. Scope threshold: rule/contract/constraint changes get a row; editorial batches get one combined row. Rows are written by the orchestrator under human approval (the conversation-distiller pattern).
2. **Update exactly one operative home per fact** — the change lands where it belongs:
   - invariants + skill triggers → `AGENTS.md`
   - role procedures → `.opencode/skills/<group>/<name>/SKILL.md`
   - agents, models, permissions → `.opencode/agents/`
   - research lifecycle → `research/WORKFLOW.md`
   - task lifecycle + forms → `docs/work/README.md`, `docs/work/templates/`
   - structure → `docs/architecture/repository-layout.md`
   - shapes → `research/templates/`
   - validation + CI → `scripts/*.mjs`, `.github/workflows/`
   - committed config template → `opencode.example.json` (credentials stay global)
   - governance/ownership → `docs/governance/`
   The design record links to homes; it never copies them.
3. **Extend the validator when the change is checkable** — any structural rule the change introduces gets a check (template + validator are one contract). First dogfood targets already live: AGENTS.md trigger table ↔ skills directories; package-card ingredients ↔ prompt-authoring catalogue.
4. **Sweep stale references** — old rules, files, or commands the change invalidates get updated or explicitly marked retired.
5. **Verify** — `./scripts/validate-repository.sh` green; evidence hashes refreshed when preserved files change intentionally.
6. **Small commits** — one observable change per commit.

Adopted 2026-08-07 (decision #25), per heavy-review verdict (adopt with adjustments).

## Decisions log

| # | Date | Decision |
| --- | --- | --- |
| 1 | 2026-08-05 | Research results stay in place, immutable; completed packages never move |
| 2 | 2026-08-05 | Destination: only conclusions travel, each human-gated |
| 3 | 2026-08-05 | Tooling: templates + suite-agnostic validator; catalog/generators/manifests deleted |
| 4 | 2026-08-05 | As-built: per-component, periodic during work, proof commands, 1:1 reconstruction quality bar |
| 5 | 2026-08-05 | Deviations recorded in a separate per-gate log, never inside as-built |
| 6 | 2026-08-05 | Milestones: stubs materialize on demand, full plans on demand |
| 7 | 2026-08-05 | Reading ladder: conclusions.md + Human summary + milestone About |
| 8 | 2026-08-05 | Anchors: heading links everywhere; templates mandate anchors |
| 9 | 2026-08-05 | Input: per-root code zips via `git archive`; reading list always embedded |
| 10 | 2026-08-05 | Output modes on the card; theoretical-implementation separate and safety-labeled |
| 11 | 2026-08-05 | Research types (extensive / one-off) + Type-2 continuation cycle |
| 12 | 2026-08-05 | Prompt authoring: ingredient framework, auditable choices, living catalogue |
| 13 | 2026-08-05 | Adopted-package records live in `docs/architecture/adopted-packages/` |
| 14 | 2026-08-05 | Archiving = status change, keep-in-place |
| 15 | 2026-08-05 | Frozen suites: facts unchanged; Human summary front sections backfilled (option A) |
| 16 | 2026-08-05 | Template + validator are one contract; pilot proves it |
| 17 | 2026-08-05 | AGENTS.md + skills: invariants + trigger table; seven role skills, committed; skills own procedures |
| 18 | 2026-08-05 | Implementation procedure + review policy with human review guides and skip audit line |
| 19 | 2026-08-05 | Agent team + expensive-think/cheap-write relay; git is the handoff |
| 20 | 2026-08-06 | Disposability stance + heavy-review triage: repo setup disposable until gates/ADRs make parts permanent |
| 21 | 2026-08-07 | Review follow-ups: zip roots + auto-include, example config, end-states + rejected-routes register, skip audit line, token measurement excluded, plugin dependency out of git, tavily skills grouped |
| 22 | 2026-08-07 | Backfill = option A; `adopted-packages/` naming |
| 23 | 2026-08-07 | Heavy execution-review triage: pilot attribution, disposition columns, register table, statuses, sweep completion, validator extensions, terminology alignment; deferred — heavy bash-glob chaining test, local plugin scaffolding |
| 24 | 2026-08-07 | Second heavy review triage (ses_024d20c08ffeRh11coFO4CwdQ6 successor): bash-prefix-glob hole confirmed live → separator-chain denies added + enforcement wording made honest; validator de-coupled from hard-coded task/result paths; review policy de-duplicated to one home (docs/work/README.md); raw-data invariant narrowed to the handover boundary; prompts joined the hash ledger; CI workflows unified on `validate-repository.sh`; skill-trigger sync check added; package-card ingredients completed; templates pointer fixed; card-check exemption documented. Pending human decisions: documentation-protocol adoption (review verdict: adopt with adjustments), web-lane admission, prevention-vs-detection for the remote lane |
| 25 | 2026-08-07 | Documentation protocol adopted (six steps; extended homes mapping; orchestrator writes rows under human approval; scope threshold: rule changes get rows, editorial batches one row) |
| 26 | 2026-08-07 | Web lane Stage 1 admitted by the human (read-only): jCodeMunch installed + indexed (handover package excluded) + served on streamable-http (127.0.0.1:8901/mcp, bearer token at ~/.config/jcodemunch/token) + public tunnel (cloudflared quick tunnel, ephemeral URL) + ChatGPT connector pending. Web-lane instructions created at docs/web-lane/instructions.md (contract, MCP usage, review method, rules). Stage 2 (opencode bridge) still pending admission |
| 27 | 2026-08-07 | Web lane docs access: jDocMunch (same author as jCodeMunch) installed, markdown indexed by heading hierarchy (197 files; handover + evidence excluded), served via mcp-proxy (SSE bridge — jDocMunch is stdio-only) on 127.0.0.1:8902, second cloudflared tunnel (gospel-broad-temporarily-pete.trycloudflare.com). Web-lane instructions split into code (jCodeMunch) and docs (jDocMunch) tool sections. Bounded no-auth window now covers both lanes |
| 28 | 2026-08-07 | AI symbol summaries: DEFERRED. Not enabled now (marginal value at current repo size; cloud summaries would send code snippets to an external provider, violating the raw-data-never-travels invariant). Planned for when the codebase scales, with a MECHANICAL confidentiality fix first: local LLM provider (Ollama / LM Studio via OPENAI_API_BASE) so summaries are generated on-machine and no code ever leaves — re-evaluate cloud providers only with an explicit admission decision (ADR-FS-032) |
| 29 | 2026-08-07 | raw-database-evidence anonymized: the 519 MB iamdev production backup was restored in a local SQL Server container, deterministically mangled (structure/relationships/domains preserved; values fictionalized — key remaps via mapping tables, length-preserving hash fakes, date offset, closed-domain enums rotated), verified (0 untrusted FK/CHECK; 0 original values remaining except closed-domain enums by design; 0 identity coincidences), and re-exported as a 146 MB MANGLED .bak (sha256 6d7a4677…). Original deleted from disk (user holds a copy; original checksum 02449519…); iamdev_orig dropped; macOS junk removed. Container retains the live mangled DB for future sanitized subset exports |
| 30 | 2026-08-07 | Web lane moved to permanent infrastructure: named Cloudflare tunnel (`uam-mcp`) with stable hostnames code.quettaforge.com (jCodeMunch) and docs.quettaforge.com (jDocMunch); jCodeMunch + jDocMunch served as systemd services from stable venvs (~/.local/share/mcp-venvs/); docs lane converted from deprecated SSE (mcp-proxy, removed) to a custom streamable-http bridge (bridge.py, mcp SDK StreamableHTTPSessionManager, root endpoint on :8902) — both lanes now on the current MCP transport; connector URLs: https://code.quettaforge.com/mcp and https://docs.quettaforge.com/ |

## Open / deferred items

- Resolved 2026-08-07: opencode bash permission patterns are prefix globs over the whole command string — chained commands (`git status && …`) matched an allowed prefix. Hardened with separator-chain denies (`*&&*`, `*||*`, `*;*`, `*|*`); documented that permission enforcement is best-effort and git is the backstop.
- `.opencode/package.json` plugin scaffolding is recreated by opencode at startup; it is runtime state, not a committed dependency.
- Human dispositions for all conclusions sheets are pending (the promotion ledger's first real use).
- Pending human decisions: web-lane admission (jCodeMunch / Secure MCP Tunnel / opencode-mcp are external, UNVERIFIED, ADR-FS-032 territory) — to be revisited at MCP setup.
- Remote-lane change policy: DETECTION (direct changes, checks after) enabled by the as-built workflow; human-visibility documentation (so the human always knows what is going on) is to be strengthened — planned AFTER the MCPs are set up.
