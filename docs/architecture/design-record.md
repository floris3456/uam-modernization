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

`./scripts/validate-repository.sh` is the web-safe check-only entry point: suite-agnostic research validation (structure, README presence, prompt sections, prompt/result co-location, uniqueness, secrets, private addresses, internal URLs, stale references, attachment fields, link + heading-anchor resolution, synthesis Human summary, conclusions shape, package-card fields), evidence-manifest freshness (`--check`; hash ledger — results AND prompts; conclusions.md deliberately excluded as a living file), pre-implementation checks (required files, links + anchors in docs, action pins, skill-trigger ↔ skills-directory sync). It never writes tracked files and never reads the protected boundary. Protected-lane checks — code-reference regeneration/freshness and handover validation — run only in CI (`validate-handover.yml`) and trusted local sessions (Semantic System Review A9.2).

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
| 31 | 2026-08-08 | Web lane: discovered ChatGPT disables MCP tools in PRO-model chats — lane must use a non-Pro model (5.6-sol xhigh); zero Codex/Work usage is the hard constraint. Added Stage 2 delegation connector: opencode-mcp (v, stdio) exposed via the generalized bridge (BRIDGE_PORT/BRIDGE_CHILD env) on :8903, in-process opencode SDK server (:4096), sessions run the machine's cheap agents (deepseek flash, OPENCODE_DEFAULT_MODEL pinned); public hostname task(s).quettaforge.com in the Cloudflare dashboard; web-lane instructions extended with the delegation pattern (precise briefs, verify sessions, human confirmation for writes) and the model-selection note |
| 32 | 2026-08-08 | opencode-mcp function test: discovery + session creation worked; execution failed ONLY due to argument-name guessing by the web agent (`sessionID`/`prompt` vs schema `sessionId`/`text`; `id` for get/delete). Full flow verified locally end-to-end (create → message_send → conversation → delete; sample run cost $0.0007). Instructions extended with an EXACT argument cheat-sheet; orphaned test sessions deleted |
| 33 | 2026-08-08 | Web-lane instructions finalized and renamed to `docs/web-lane/developer-instructions.md` — end-state document (no stage language; all three connectors live; stale "watchers keep the index fresh" claim corrected — jDocMunch is refreshed manually); old `instructions.md` removed |
| 34 | 2026-08-08 | jDocMunch watcher installed (systemd `jdocmunch-watch`, `jdocmunch-mcp watch --quiet`), verified live — index auto-refreshes on doc change; developer-instructions corrected back to "auto-refreshed by a local watcher" |
| 35 | 2026-08-08 | Web-lane benchmark v1 results: 7/8 tasks correct. Genuine findings, both fixed — (1) jCodeMunch index CONTAINED handover-package files despite the exclusion claim (the `--extra-ignore` flag did not exclude the directory); re-indexed via `--paths-from` with explicit exclusions, verified handover files gone (only legitimate cross-references remain); (2) same-file anchor links (`(#anchor)`) were never validated — empty-targetPath skip in BOTH validators; fixed, probe-tested, reverted. T5 answered from a stale docs index (row #29 vs live #31) — agent honestly flagged the code/docs index SHA mismatch; the class of error is prevented by the jDocMunch watcher (row 34). Trace: 38 tool calls, ~328 s, no `_meta` latency/tokens surfaced (recorded as null); two OpenAI safety-blocks worked around; one invalid action guess; honest reporting throughout |
| 36 | 2026-08-08 | opencode-mcp function test (post cheat-sheet): delegation connector FULLY functional — discovery, read-only session (transcript verified), `opencode_ask`, write probe (filesystem-confirmed: /tmp/opencode/delegation-test.txt), parallel validator sessions (both green), cleanup exact (baseline restored). No wrong-argument errors; the cheat-sheet works. Verified on our side: working tree clean — the `opencode_wait` patch event was a phantom tool quirk, not a modification. Remaining: true concurrency not conclusively observed (deferred, optional check); OpenAI safety layer intermittently blocks some calls (session_create with title, opencode_wait) — worked around, not our bug |
| 37 | 2026-08-08 | Chat handoff created (`docs/work/current/CHAT-HANDOFF-2026-08-08.md`): full conversation memory for a continuing chat — instructions, condensed-early/detailed-late summary (last 8 responses in full detail, last response verbatim), reference appendix. Semantic System Review prompt queued for the web lane; its findings to be triaged into fixes |
| 38 | 2026-08-08 | Delegation connector swapped to hardened fork: `@mekareteriker/opencode-mcp` 1.14.0-mekareteriker.0 (upstream 1.11.0 has a generic retry loop that replays non-idempotent POSTs — the duplicate-send/wedged-session anomaly from the Semantic System Review). Diff-reviewed vs installed upstream: MEK-281 (retry only GET/HEAD/OPTIONS/DELETE; `/session/{id}/message` and `/prompt_async` never retried), 60s in-memory idempotency dedup (sha256 of method+path+body) for POST/PUT/PATCH, MEK-284 reconnect re-issues a POST once after connection errors (documented residual — send-ambiguity instruction rule stays), structured errors, Windows CI; supply-chain scan clean (no postinstall, no external endpoints, documented env knobs); tool surface: +`opencode_run_streaming` +`opencode_write_file`, −`opencode_project_init`, our tools unchanged (cheat-sheet stays valid). Installed to dedicated prefix `~/.local/lib/opencode-mcp-hardened` (bin `opencode-mcp-hardened`); upstream package untouched (revert = unit edit). Unit `opencode-mcp.service` BRIDGE_CHILD updated; fork auto-starts `opencode serve` (:4096, 1.18.15) and now owns the server lifecycle. Local function test PASS through the bridge: 81 tools, create → send → conversation → delete, probe appears exactly once (cost $0.0000). Web-lane function test in ChatGPT still to be re-run |
| 39 | 2026-08-08 | P0 confidentiality hardening (Semantic System Review anomalies A1 + A8): (1) committed project config `.jcodemunch.jsonc` with `extra_ignore_patterns` AND `watch_extra_ignore` covering `UAM-overdracht-INTERN-*` and `raw-database-evidence` (index-time exclusions were proven non-durable in A1 — the 09:55 boot reindex resurrected 18 protected files); (2) index purged and rebuilt — 17 files / 0 protected; REGRESSION VERIFIED: protected count 0 after rebuild AND after a full service restart (the exact resurrection scenario); (3) `opencode.json` + `opencode.example.json` gained a `permission` block (read + bash denies for the protected prefixes; last-match-wins ordering with catch-all allow first); live probe through a delegated session: protected-path read DENIED by permission rule, normal reads unaffected (note: a config change requires an opencode server restart to take effect — first probe hit stale in-memory config). Defense-in-depth only, not a sandbox: the strong boundary (sanitized exported workspace without the protected tree and its `.git`) remains an open architecture decision |
| 40 | 2026-08-08 | P1 batch (RCA follow-ups): (1) jDoc ghost pruned — `docs/web-lane/instructions.md` removed via `index-local --paths-from` (watcher stopped during the operation), verified absent from `doc_paths`; observed again during P0: the watcher admitted the three root JSON configs (`.jcodemunch.jsonc`, `opencode.json`, `opencode.example.json`) on change — benign files, but independently confirms the A3 corpus-widening mechanism (upstream fix still pending); (2) `developer-instructions.md` updated with the five RCA rules — jCode protected-index boundary (persistent config; verify count 0 after upgrade/rebuild/restart), jDoc corpus/freshness (approved allowlist, not inferred exclusion; watcher is not a reconciliation guarantee), jDoc exact-path rule (`get_document_outline` forgiving fallback; prove with `get_doc`/`list_docs`), jDoc top-level argument-contract rule (`ignored_arguments`/`ignored_arguments_note`, not `_meta`), opencode send-ambiguity / empty-response / shell rules; dropped the removed `opencode_project_init` reference; (3) upstream issue drafts prepared for the human (gh not authenticated on this machine): jCodeMunch — persist admission policy + `deny_paths` invariant; jDocMunch — startup deletion reconciliation, strict corpus-membership mode, exact `doc_path` default (tracker reportedly restricts public issues); opencode-mcp fork (MekaretEriker) — neutral empty-response warning wording (the fork already ships the MEK-281 retry fix, row 38) |
| 41 | 2026-08-08 | P2 batch (RCA A9 cleanups): (1) trust-lane split — `validate-repository.sh` is now web-safe check-only (research validation, manifest `--check`, pre-implementation; never writes tracked files, never reads the protected boundary); `generate-research-code-reference.sh` gained `--check`; `.github/workflows/validate-handover.yml` gained a Linux `code-reference-check` job so code-reference freshness is machine-enforced in the protected lane alongside handover validation; (2) manifest schema v4 — `entryCount`/`resultFileCount`/`promptFileCount` added, `resultCount` retained as deprecated alias; regenerated (81 = 40 results + 41 prompts; consistency asserts pass); (3) REPO-002 moved to `docs/work/archive/2026/` (no backlinks existed); (4) design record: stale "web-lane admission pending" open item resolved, validator/CI wording corrected; AGENTS.md pointer updated to web-safe scope; (5) `scripts/check-lane-boundaries.sh` — local web-lane boundary health check (jCode protected count = 0; jDoc has no protected doc paths), passing now, referenced from developer-instructions (the machine check for the A1/A3 confidentiality invariant) |
| 42 | 2026-08-08 | AI symbol summaries ENABLED with the row-28 mechanical fix: local provider only (Ollama at 127.0.0.1:11434, model qwen2.5:3b; GPU-fast — 287 symbols in ~9 s; zero cost, code never leaves the machine). Config: `~/.code-index/config.jsonc` `use_ai_summaries: true`, `summarizer_provider: "openai"`, `summarizer_model: "qwen2.5:3b"`; `OPENAI_API_BASE` added to `jcodemunch-mcp.service` env. Full rebuild verified via debug log ("AI summarization starting: 287 symbols … provider=openai model=qwen2.5:3b"); index 18 files / 287 symbols, protected count 0, boundary check green. Notes learned: (1) CLI `index` needs `OPENAI_API_BASE` exported — the unit env only applies to the service; (2) the indexer PRESERVES summaries when files are unchanged — `delete-index` first for a true rebuild; (3) YAML/JSON config files show structural Tier-1 summaries by design (docstring extraction takes precedence) |
| 43 | 2026-08-08 | Summarizer upgraded to vLLM + Qwen2.5-Coder-32B-AWQ after the 3B acceptance spot-check FAILED (qwen2.5:3b hallucinated a detail in `append_source` and was vague elsewhere). Setup: uv venv `/opt/vllm-venv` (python 3.12), `vllm` 0.26.0 from PyPI (Blackwell sm_120 verified, torch 2.11+cu130, driver 610.57.04); systemd `vllm-serve.service` serves `/opt/models/qwen2.5-coder-32b-instruct-awq` (19 GB, AWQ) on 127.0.0.1:8000, `--served-model-name qwen2.5-coder-32b --max-model-len 8192 --gpu-memory-utilization 0.9`. Two infra fixes needed: (1) systemd units don't inherit the shell env — `CUDA_HOME=/opt/cuda` + `PATH` (with `/opt/cuda/bin` and venv bin) required for flashinfer's JIT; (2) `ninja` installed into the venv (flashinfer build tool). jCodeMunch rewired: `OPENAI_API_BASE=http://127.0.0.1:8000/v1` (unit) + `summarizer_model: "qwen2.5-coder-32b"` (config); full rebuild 13.2 s for 287 symbols. ACCEPTANCE TEST PASSED: 12+ symbols source-verified, zero hallucinations, the 3B `append_source` hallucination is gone; the acceptance rule is "no contradiction with the code + specific enough to identify the symbol". Notes: PyPI installs behind this machine's HTTP proxy need proxies unset (uv); ollama remains available but jCodeMunch now uses vLLM; if vLLM is down the summarizer falls back to signatures |
| 44 | 2026-08-08 | Chat-handoff state resolved + new convention: (1) the uncommitted deletion of `docs/work/current/CHAT-HANDOFF-2026-08-08.md` is COMMITTED — the full record persists in git history (1bd4162) and its summary in row 37; (2) NEW CONVENTION: chat handoffs (conversation memory for continuing chats) live in `docs/work/handoffs/`, gitignored by design (`docs/work/handoffs/*` with a committed README via negation); task handoffs (handoff-template) are unaffected and stay committed/archived; (3) rationale: the committed+trash pattern left a dangling uncommitted deletion that failed the web lane's "no tracked-file changes" criterion in the function re-test; (4) the re-test also surfaced a stale ChatGPT connector tool snapshot (80 tools / `opencode_project_init` present vs the live fork surface of 81 tools) — verified server-side that the bridge serves the fork surface; the mismatch is client-side and fixed by the human re-adding the connector in ChatGPT (not something the web agent can do, so no instruction change was made) |

## Open / deferred items

- Resolved 2026-08-07: opencode bash permission patterns are prefix globs over the whole command string — chained commands (`git status && …`) matched an allowed prefix. Hardened with separator-chain denies (`*&&*`, `*||*`, `*;*`, `*|*`); documented that permission enforcement is best-effort and git is the backstop.
- `.opencode/package.json` plugin scaffolding is recreated by opencode at startup; it is runtime state, not a committed dependency.
- Human dispositions for all conclusions sheets are pending (the promotion ledger's first real use).
- Resolved 2026-08-07/08: web-lane admission — the three connectors (jCodeMunch, jDocMunch, opencode-mcp) were admitted and brought into service (rows 26, 30, 31); subsequent operational issues are tracked by the later web-lane rows (33–40).
- Remote-lane change policy: DETECTION (direct changes, checks after) enabled by the as-built workflow; human-visibility documentation (so the human always knows what is going on) is to be strengthened — planned AFTER the MCPs are set up.
