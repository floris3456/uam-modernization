# CHAT HANDOFF — 2026-08-08

## Instructions for the continuing chat — READ THIS FIRST

You are continuing a long-running, human-assisted project conversation. You did not
participate in it. This file is your memory of everything that happened. Read it fully
before acting, and treat the human's constraints as binding.

**What this project is:** the UAM modernization planning repository
(`/home/bliss/Projects/Active/uam-modernization`). No production code exists; the
active gate is G0 (fictional evidence foundation), blocked on named human decisions.
The repository governs its own workflow: research packages, as-built records,
deviation logs, ADRs, gates, skills, agents, validators.

**Authoritative sources (read these before doing anything):**
- `AGENTS.md` — invariants + skill triggers (the always-on contract)
- `docs/architecture/design-record.md` — the design and its decisions log (36 rows)
- `docs/web-lane/developer-instructions.md` — the ChatGPT web lane contract
- `docs/work/README.md` — task workflow · `research/WORKFLOW.md` — research lifecycle

**Hard constraints (never violate):**
- Research is never acceptance; gates are human-accepted; ask the human when a premise
  is uncertain.
- Raw production data never travels: never committed outside the preserved handover
  boundary, never zipped for research.
- The web lane must run in ChatGPT Chat with a NON-Pro model (e.g. 5.6-sol xhigh) and
  must consume ZERO Codex/Work usage. MCP tools are disabled in Pro-model chats.
- Small reversible changes; run `./scripts/validate-repository.sh` before handoff.

**Live infrastructure on this machine (systemd, reboot-proof):**
- `jcodemunch-mcp` — code retrieval, streamable-http, `127.0.0.1:8901`
- `jdocmunch-mcp-proxy` — docs retrieval via generic bridge, `127.0.0.1:8902`
- `opencode-mcp` — delegation connector via generic bridge, `127.0.0.1:8903`
  (in-process opencode SDK server on `:4096`)
- `jdocmunch-watch` — auto-reindex watcher
- `cloudflared` — named tunnel `uam-mcp`: `code.quettaforge.com` → 8901,
  `docs.quettaforge.com` → 8902, `task(s).quettaforge.com` → 8903
- Docker container `mssql-anon` — SQL Server holding the MANGLED iamdev database
  (fictionalized; original removed, user holds a copy, checksum in design record)

**Working tree state:** clean at the current HEAD. All decisions are recorded in the
design record decisions log (rows 1–36). The web-lane benchmark v1 (7/8) and the
opencode-mcp function test (fully functional) are complete and recorded (rows 35–36).

**Queued next actions:**
1. Run the Semantic System Review prompt (section 5, verbatim) in a fresh ChatGPT web
   chat (5.6-sol xhigh, all three connectors, paste `developer-instructions.md` first).
2. Triage its findings into fixes (the pattern: verify → fix → record decision row →
   commit → validator green).
3. Durable-auth decision for the web lane is still OPEN (connectors currently use
   auth None on stable hostnames).

---

## 1. Conversation summary — full history, condensed early, detailed late

### Phase A — Redesign of the research/governance system (2026-08-05 → 07)

The conversation opened with a redesign mandate: the repository felt bloated and
scattered; the mission is human-first, low-bloat, token-efficient, reliable
documentation; the current setup is DISPOSABLE — anything may be replaced if it does
not serve the mission. Everything below is recorded in `docs/architecture/design-record.md`
(decisions log, rows 1–25).

Key agreements:
- **Three kinds of truth, never mixed in one file:** Proposal (research, labeled,
  fallible) · Decision (ADR, human-accepted) · Fact (as-built record, proof commands).
- **One home per fact**; summaries are presentation, not duplication (honesty test).
- **Research machinery replaced:** the 1,380-line `catalog.json` + generator scripts +
  manifests (hard-coded to one package) were deleted; a suite-agnostic, walk-based
  validator (`scripts/validate-research.mjs`) replaced them. A real pilot package
  (UUIDv7 in .NET) proved the format end-to-end.
- **As-built records** (`src/<component>/AS-BUILT.md`): maintained during work,
  current-state truth, proof command per fact, 1:1 reconstruction quality bar.
- **Deviation logs** (per gate): plan ref → as-built ref → because; never inside
  as-built.
- **Reading ladder** (conclusions.md → Human summary → milestone About → full results);
  frozen suites backfilled with Human summaries + conclusions sheets (disposition
  columns).
- **Seven role skills** under `.opencode/skills/{research,implementation,governance}/`;
  AGENTS.md is the always-on layer (invariants + trigger table).
- **Three committed agents:** `orchestrator` + `developer` (deepseek flash),
  `heavy` (Kimi K3, read-only, permission-enforced best-effort with git as backstop).
- **Two heavy-model execution reviews** were triaged into fixes (pilot attribution,
  disposition columns, register table, validator extensions, policy de-dup, prompt
  ledger, CI unification, bash-glob hardening).
- **Documentation protocol adopted** (row 25): six steps for changing the system
  itself; the design record is the ledger.

### Phase B — Database anonymization (2026-08-07)

The 519 MB production backup (`raw-database-evidence/iamdev-Full-2026-08-03T15-36-03.bak`,
150 tables — users, HR, employments, device logs, memberships) was restored in a local
SQL Server container and **deterministically mangled**: structure/relationships/domains
preserved, values fictionalized (key remaps via mapping tables, length-preserving hash
fakes, date offsets, closed-domain enums rotated). Verified: 0 untrusted FK/CHECK
constraints; 0 original values remaining except closed-domain enums by design; 0
identity coincidences. Re-exported as a 146 MB MANGLED .bak (sha256
`6d7a4677…5045`). Original deleted from disk (user holds a copy; original checksum
`02449519…ad1ff`); `iamdev_orig` dropped; macOS junk removed. Container retains the
live mangled DB for future sanitized subset exports. Row 29.

### Phase C — Web lane setup and testing (2026-08-07 → 08)

The web lane exists to use the biggest model at flat subscription cost with ZERO
Codex usage. It was built from three MCP servers behind a named Cloudflare tunnel and
tested with two benchmarks.

- Connectors: **jCodeMunch** (code/symbol retrieval, streamable-http), **jDocMunch**
  (docs section retrieval, streamable-http via a custom bridge), **opencode-mcp**
  (delegation: spawns local cheap-model sessions).
- **Pro-model restriction discovered:** ChatGPT disables MCP tools in Pro-model chats;
  the lane must use a non-Pro model (5.6-sol xhigh). This is a verified, binding
  constraint.
- **Doc/code benchmark v1:** 7/8 tasks correct; found and fixed two real bugs
  (handover package was in the code index despite the exclusion claim; same-file
  anchor links were never validated).
- **opencode-mcp function test:** fully functional after the argument cheat-sheet
  fix (the web agent had guessed argument names — `sessionID`/`prompt` instead of
  `sessionId`/`text`); write capability filesystem-confirmed; cleanup exact.
- Instruction document finalized as `docs/web-lane/developer-instructions.md`.
- jDocMunch watcher installed; both indexes now auto-refresh.

---

## 2. Last eight responses — full detail

### Response (2026-08-08) — opencode-mcp function test diagnosis: argument names
The first function-test run failed at session execution: after successful discovery
and session creation, `opencode_message_send*` returned "Resource not found" and the
connector surface vanished from the chat. Local diagnosis proved the servers were
healthy (requests flowed from OpenAI IPs; the bridge never crashed). Reproduction
through the bridge showed the real cause: **the web agent guessed argument names** —
the tool schemas require `sessionId` + `text` for messages, `id` for session
get/delete, `prompt` for `opencode_ask`. The "Resource not found" was a validation
error misreported; ChatGPT then dropped the tool surface after repeated errors. The
full corrected flow was verified locally end-to-end (create → message_send → wait →
conversation → delete; a sample run cost $0.0007, 10,082 tokens in). The web-lane
instructions gained an EXACT argument cheat-sheet with the rule "read the validation
error and correct." Orphaned test sessions were deleted. Committed `bac3b9e`
(row 32).

### Response (2026-08-08) — why jDocMunch has no watcher
Explained that this is not a jDocMunch limitation but an omission on our side:
jDocMunch separates watching from serving — its `serve` has no options, but it ships
a dedicated `watch` command and `watch-install`. We had wired `serve` into systemd
but never installed the watcher, so the docs index only refreshed on manual
`index-local` runs (which is why the instructions said "refreshed manually").

### Response (2026-08-08) — install the jDocMunch watcher
Created `jdocmunch-watch.service` (systemd, `jdocmunch-mcp watch --quiet`,
WorkingDirectory = repo). Verified live: a probe doc edit caused the index to
auto-refresh within ~20 seconds (mtime 03:17:15 → 03:17:36); the probe was reverted.
Restored the truthful claim in the instructions ("auto-refreshed by a local watcher
service") and recorded row 34. Committed `96153c6`. The T6 benchmark contradiction
was thereby removed.

### Response (2026-08-08) — developer-instructions consistency
Audited the instructions for leftover inconsistencies; confirmed the watcher change
was committed, then completed the symmetry: the jCodeMunch section now also states
its index is auto-refreshed by the server's built-in watcher, matching the jDocMunch
statement. Both index claims now match reality. Committed `2733cc3`.

### Response (2026-08-08) — re-provided the opencode-mcp function test prompt
Re-issued the standalone function-test prompt (six tests: discovery, read-only
session, quick answer, write probe, parallel sessions, cleanup), updated to require
the EXACT argument names from the cheat-sheet and the "read the validation error and
correct" rule. Instructions: fresh chat, 5.6-sol xhigh, only the opencode-mcp
connector, paste developer instructions first.

### Response (2026-08-08) — benchmark v1 scoring and two real fixes
Scored the doc/code benchmark: **7/8 tasks correct**. T1 (slugify + validator
boundary): correct. T2 (three kinds of truth + destination rule): correct. T3
(cross-lane anchor check): correct + genuine finding — same-file anchor links
(`(#anchor)`) were never validated because both validators skipped empty targetPath;
verified, fixed in both validators, probe-tested, reverted. T4 (stale patterns):
correct, exemption rationale honestly UNVERIFIED. T5: WRONG (answered decision row
#29 from a stale docs index; live was #31) but the agent honestly flagged the
code/docs index SHA mismatch — that failure class is now prevented by the jDocMunch
watcher. T6: correct + more serious finding than intended — the handover package WAS
in the jCodeMunch index (`--extra-ignore` had silently failed); re-indexed with an
explicit `--paths-from` file list, verified handover files gone (only legitimate
cross-references remain). T7/T8: correct with excellent honesty discipline (38 tool
calls, ~328 s, null `_meta` recorded honestly, two OpenAI safety-blocks worked
around). Committed `03a2710` (row 35).

### Response (2026-08-08) — opencode-mcp function test verified fully functional
Assessed the retried function test: all six tests effectively SUCCESS or verified.
Verified locally: the write-probe file `/tmp/opencode/delegation-test.txt` exists
with exactly `opencode-mcp delegation works` (filesystem-confirmed, writes outside
the project are real and permitted by design); the phantom `opencode_wait` patch
event was explained — the working tree is completely clean (0 changes), no session
modified anything; cleanup restored the exact nine pre-existing sessions. The only
remaining gap: true concurrency not conclusively observed (deferred, optional). Two
OpenAI safety-layer blocks (session_create with title, opencode_wait) are
OpenAI-side, not ours. Verdict upgraded to FULLY FUNCTIONAL. Committed `10e03ef`
(row 36).

### Response (2026-08-08) — the Semantic System Review prompt (LAST RESPONSE — VERBATIM)

The complete, unmodified last assistant response — the Semantic System Review prompt —
is reproduced in full in section 3 below (verbatim, unchanged).

## 3. Semantic System Review prompt — VERBATIM (the last response)

```markdown
# SEMANTIC SYSTEM REVIEW — the complete UAM repository setup

**Mission:** perform an EXHAUSTIVE, semantically rigorous review of the ENTIRE
repository setup — every file, every rule, every claim, every home — and document the
findings thoroughly. Nothing is out of scope. Nothing is too small. This is a full
audit of the system the repository uses to govern itself.

**Expected depth:** this is a multi-phase, deep-dive review. Work through ALL phases in
order, without skipping, and pursue each item to its end. Prefer depth over speed:
read the actual content, verify the actual behavior, cross-check every claim. A
superficial pass is a failed pass.

---

## Ground rules

1. FIRST tool call: `jcodemunch_guide`, and follow it strictly.
2. Use all three connectors appropriately: jCodeMunch for code/scripts, jDocMunch for
   documentation, opencode-mcp for anything that requires EXECUTION or full-file walks.
   Follow the developer instructions you were given (argument cheat-sheet — never guess
   argument names; read validation errors and correct).
3. YOU never write files directly. Any file creation or modification (including saving
   the final report) must be proposed to the human and executed only through a
   delegation session with explicit human confirmation.
4. Delegation sessions you spawn MUST be read-only unless the brief explicitly says
   otherwise and the human confirmed. For verification sessions, use briefs like:
   "Run <command>. Report the exact output. Do not modify anything."
5. Every finding: label CONTRADICTION / GAP / ERROR / RISK / FRAGILITY / QUESTION /
   SUGGESTION. Cite file + section/symbol + line where determinable. Mark anything not
   verified as UNVERIFIED with the exact experiment that would settle it.
6. No speculation as fact. No invented line numbers. No invented history.
7. If you encounter something unexpected (tool quirk, block, anomaly): record it as a
   finding and continue — do not silently absorb it.

---

## Phase 0 — Complete inventory

Build a complete, itemized inventory of the repository BEFORE any analysis:

1. Spawn a read-only delegation session with the brief:
   "Output a complete file tree of the repository (git ls-files), grouped by top-level
   directory, with one-line purpose annotations for each file you can determine. Do not
   modify anything. Include: count of files per directory."
   Verify the output against what the indexes cover.
2. Cross-check the inventory against:
   - The repository layout document (`docs/architecture/repository-layout.md`) — every
     directory it claims exists, every reserved directory.
   - The jCodeMunch index (what code/config files are indexed, language counts).
   - The jDocMunch index (what markdown is indexed, section counts).
3. Record in your report: total tracked files, per-directory breakdown, and a list of
   any files NOT covered by either index (out-of-surface files).

## Phase 1 — Per-area deep dives

For EACH area below: read the actual files (sections via jDocMunch, code via
jCodeMunch), evaluate against the checklist, and record findings. Do not move to the
next area until the current one is exhausted.

### 1.1 AGENTS.md (root working agreement)
- Invariants: are all six true of the current system? Quote the system state that
  proves or disproves each. Check "raw data never travels" against every exception.
- Skill trigger table: does it match the actual skills in `.opencode/skills/`?
  (Expected 7/7 — verify.) Any workflow that needs a skill but has no trigger? Any
  trigger pointing at a skill whose content is stale?
- Pointers: do all linked documents exist and contain what they claim?
- Is AGENTS.md the only always-on instruction layer, or does anything else get loaded
  implicitly (`.github/copilot-instructions.md`, etc.)? List every instruction source
  an agent could see and check for contradictions between them.

### 1.2 Skills — all seven, individually and as a set
- `.opencode/skills/research/research-workflow` — lifecycle steps vs
  `research/WORKFLOW.md` vs the actual research packages: do they agree? Statuses,
  types, output modes, continuation cycle.
- `.opencode/skills/research/prompt-authoring` — ingredient catalogue vs
  `research/templates/package-card.md` (does the card template list ALL ingredients?),
  vs the pilot package's card.
- `.opencode/skills/implementation/as-built` — rules vs the design record's as-built
  section; verification layers vs what the validators actually implement.
- `.opencode/skills/implementation/task-workflow` and `code-review` — review policy
  links: does `docs/work/README.md` contain the policy, and do the skills only link?
  (Check for the six-copies problem returning.)
- `.opencode/skills/governance/gate-workflow` and `conversation-distiller` — framing
  stubs claim vs actual milestones; distillation steps vs actual process.
- Cross-skill: does any fact exist in more than one skill? (One-home-per-fact audit.)
- Frontmatter: descriptions with trigger keywords — do they match the AGENTS.md table
  and the actual activation needs?

### 1.3 Agents and opencode configuration
- `.opencode/agents/orchestrator.md`, `developer.md`, `heavy.md` — permissions vs the
  design record's agent table; heavy read-only enforcement (edit denied, bash allow
  list, separator denies); model pins vs the model provider config.
- `opencode.json` (default agent) and `opencode.example.json` (key-free template) —
  consistency with the agent files.
- The global `~/.config/opencode/opencode.json` — is anything there that the repo
  depends on but does not document? (Do not print secrets; describe shape only.)

### 1.4 Workflows
- `research/WORKFLOW.md` — every step vs the validator's actual checks; inputs/outputs
  vs the developer instructions; anchor rules vs validator behavior.
- `docs/work/README.md` — task lifecycle, statuses, review policy; the review policy
  MUST have exactly one home — verify no skill/doc duplicates it.
- Templates: `docs/work/templates/task-template.md`, `handoff-template.md`,
  `experiment-template.md` — required fields vs the workflows that consume them; do
  the templates still match what AGENTS.md and the skills demand (as-built line,
  deviation lines, review-skip audit line)?
- Research templates: `research/templates/package-card.md`, `study/prompt.md`,
  `study/README.md`, `review-checklist.md` — do they match the validator's required
  prompt sections exactly? Does the card template carry the full ingredient list?

### 1.5 Scripts — the validation and generation layer
For EACH script in `scripts/`, read it fully and audit:
- `validate-research.mjs` — every check it performs vs every check the docs claim it
  performs (prompt sections, anchors, uniqueness, secrets, attachment fields, card
  fields, Human summary, conclusions shape, exemption lists, stale-reference patterns).
  Blind spots: what does it NOT check that the docs imply it does?
- `validate-preimplementation.mjs` — required-files list vs the archive workflow
  (does anything hard-code a file that the workflow moves?); link+anchor check vs the
  same-file-anchor fix; skill-trigger sync check; action pins.
- `validate-repository.sh` — single entry point: does it cover everything CI runs?
- `generate-research-evidence-manifest.mjs` — ledger scope (results + prompts),
  freshness flow, what is deliberately excluded (conclusions.md) — verify the
  rationale is documented.
- `generate-research-code-reference.sh` — what it generates, from what, into where;
  is the baseline attachment check sound?
- `profile-detailed-application-catalogue.mjs` / `profile-original-application-catalogue.mjs`
  — purpose, determinism, safety fields.
- Cross-script: hard-coded paths, duplicated logic, anything that would break when the
  repo grows (new schemas, new packages, renamed directories).

### 1.6 As-built
- The concept and its documentation (design record, as-built skill, task templates):
  complete? The verification layers 1–5 — which exist TODAY in code/CI, which are
  aspirational? Any AS-BUILT.md records that exist? Any component that should have one
  but does not? Is the "fact without proof command = claim" rule enforceable, and by
  what?

### 1.7 Structure
- `docs/architecture/repository-layout.md` vs reality: every claimed directory,
  every reserved placeholder, every "where a change belongs" rule — verify each
  against actual locations used in the repo (do files live where the table says they
  should?).
- Empty or near-empty directories: which are deliberate placeholders, which are
  residue?
- Generated vs hand-written files: does every generated file identify its generator
  and have a checkable freshness path?

### 1.8 Research packages
- `research/baseline`, `research/implementation`, `research/pilot-uuidv7-dotnet`:
  package cards complete? Reading ladder present (Human summary, conclusions.md with
  disposition column)? Rejected-routes register in `research/README.md` — populated?
  Statuses consistent with the vocabulary (Draft/in progress/complete/abandoned/
  superseded)?
- The conclusions sheets: dispositions still pending everywhere? Anchor links resolve
  (verify with jCodeMunch/jDocMunch or the validator)? Any conclusions that should
  have been promoted but were not?

### 1.9 Documentation suites
- `docs/plain-language/` — freshness vs current scope (still accurate? any stale
  claims about the system or the lane?).
- `docs/milestones/` — G0 still the active gate? Framing-stub policy consistent with
  the gate-workflow skill?
- `docs/adr/` — all 7 ADRs: statuses, links to the synthesis, contradictions with
  later decisions.
- `docs/governance/ownership.md` — row integrity (the earlier corruption), owners
  still UNASSIGNED?
- `docs/architecture/` — repository-layout, source-register, design-record
  (all 36+ decision rows: any decision no longer true in practice? any open item that
  is actually resolved?), adopted-packages (empty — is that expected?).
- `docs/web-lane/developer-instructions.md` — EVERY claim in it vs the actual current
  system (connectors, URLs, watchers, model restriction, tool surfaces, argument
  names, boundaries). This is the living contract of the web lane — audit it hardest.
- `docs/work/archive/` — archived records: any referencing deleted machinery without
  retirement notes? Any contradictions with current docs?

### 1.10 Evidence layer
- `evidence/manifests/research-evidence.json` — is it current (spawn a read-only
  session: run `node scripts/generate-research-evidence-manifest.mjs` in check mode
  and report)? Does the ledger cover what the docs claim (results + prompts, not
  conclusions)?
- `evidence/sanitized/` — profiles/summary: safety fields, determinism, staleness?
- Cross-check: do the manifest hashes match the actual files (verify a sample)?

## Phase 2 — Cross-cutting semantic analysis

After all areas are reviewed, produce these cross-cutting analyses:

1. **Contradiction matrix** — every pair of normative homes that disagree, with the
   exact conflicting statements and which one is right. Include docs-vs-code,
   docs-vs-docs, code-vs-code, skill-vs-doc, instructions-vs-reality.
2. **Drift map** — for each normative fact (decision, rule, claim), the chain of homes
   that restate it, and where the chain is broken or duplicated. Flag every
   one-home-per-fact violation.
3. **Token-economics audit** — always-on layers vs on-demand layers: measure (by
   reading) the size of every instruction source an agent could load; where does
   context still bloat? Which skills are too large/too small? Are the reading-ladder
   claims true of the actual research?
4. **Security posture** — exposure surface (three public connectors, auth states,
   tokens on disk, tunnel hostnames, write-capable delegation), secret handling in
   scripts/indexes, what an attacker with each access level could do, and the
   documented mitigations.
5. **Process robustness** — rank every discipline-dependent rule by cost of silent
   decay (which one breaks first if everyone stops caring?), and which are
   machine-enforced today.
6. **Decision-log audit** — every row in the design record's decisions log: is it
   still true? Resolved? Superseded? Open items: which are actually closed?

## Phase 3 — Verification sessions (execution evidence)

Spawn read-only delegation sessions to execute and capture real evidence. For each,
use a precise read-only brief; report exact outputs:

1. "Run ./scripts/validate-repository.sh and report the final three lines and any
   errors. Do not modify anything."
2. "Run node scripts/validate-research.mjs and report the output. Do not modify
   anything."
3. "Run node scripts/generate-research-evidence-manifest.mjs --check and report
   whether the manifest is current. Do not modify anything."
4. "Run git status --short and report the result. Do not modify anything."
5. "Run node scripts/validate-preimplementation.mjs and report the output. Do not
   modify anything."
6. "List every tracked file under docs/ and research/ that is NOT covered by either
   MCP index (compare git ls-files against the index contents). Report the list. Do
   not modify anything."

Cross-check every result against what the documentation claims, and flag any claim
the execution contradicts.

## Phase 4 — Synthesis and documentation

Produce the final comprehensive report IN THIS CHAT, structured:

1. **Executive summary** — 10 lines: overall system health, the top three findings,
   the most urgent fix.
2. **Inventory summary** — files/dirs/surface coverage, out-of-surface files.
3. **Findings catalog** — EVERY finding from all phases, in a table: ID, severity
   (Blocking / Should-fix / Nice-to-have / Question), label, area, file+section/line,
   finding, evidence, what happens in practice, suggested fix.
4. **Contradiction matrix** — as computed.
5. **Drift map and one-home-per-fact violations** — as computed.
6. **Verification evidence** — the exact outputs of the Phase 3 sessions and what
   they prove.
7. **Token-economics and security audits** — as computed.
8. **Decision-log audit** — rows that are stale/resolved/superseded, open items
   actually closed.
9. **Recommendations** — prioritized: fix now / this month / watch; each with effort
   and risk.
10. **UNKNOWNs** — everything unverified, with the exact experiment that settles it.
11. **Review ledger** — your own process record: how many tool calls, per connector,
    what was blocked/quirky, wall-clock estimate, and which phases were completed in
    full.

**Final requirement:** before ending, reread the whole report once and explicitly
note anything you under-reviewed or skipped, so the human knows the coverage gap
rather than discovering it.

Your report recommends; the human decides. Failure to be exhaustive is the only real
failure mode.
```

---

## 4. Reference appendix (for the continuing chat)

**Key commits (most recent first):** `10e03ef` (function test verified, row 36) ·
`03a2710` (benchmark v1 results + handover/anchor fixes, row 35) · `2733cc3`
(instructions symmetry) · `96153c6` (jDocMunch watcher, row 34) · `1792e41`
(developer-instructions rename, row 33) · `bac3b9e` (argument cheat-sheet, row 32) ·
`73679e8` (opencode-mcp stage 2, row 31) · `ef57406` (durable tunnel + bridge,
row 30) · `b3b70ea` (database anonymization, row 29).

**Web lane URLs:** code.quettaforge.com/mcp · docs.quettaforge.com/ ·
task(s).quettaforge.com/ (auth None on all three; durable-auth decision OPEN).

**Tokens on disk:** `~/.config/jcodemunch/token` (jCodeMunch bearer token, currently
unused while auth=None) · `/tmp/opencode/mssql-pwd` (SQL Server SA password) ·
`~/.config/jcodemunch/token` only for the code lane.

**Open items (from the design record):** durable auth for the web lane; true
concurrency verification for opencode-mcp; human dispositions pending on all
conclusions sheets; heavy bash-glob chaining test; `.opencode/package.json` plugin
scaffolding note (runtime-created, harmless).

**How to continue:** run the Semantic System Review (section 3) in the web lane, then
triage its findings using the established pattern: verify → fix → record a design-record
row → commit → validator green. When in doubt, ASK the human.
