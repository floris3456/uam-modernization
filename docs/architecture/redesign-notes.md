# Redesign working notes

**Purpose:** living record of the repository redesign — research packages, as-built layer, promotion, prompt craft.
**Status:** this is NOT the permanent location; it will be absorbed into `research/WORKFLOW.md`, root `AGENTS.md`, `docs/architecture/repository-layout.md`, and the research templates.
**Started:** 2026-08-05 · **Updated:** continuously during the conversation

---

## 1. Mission — the yardstick

Remove bloat and make the repository easy to understand and maintain for a human.
Token minimization and speed are priorities in architectural decisions — never at the cost of the reliability that good documentation provides.

## 2. The design at a glance

**Three kinds of truth — never mixed in one file:**

| Kind | Format | Status marker | Can it be wrong? |
| --- | --- | --- | --- |
| Proposal | research synthesis / future implementation plan | labeled (FACT / ASSUMPTION / RECOMMENDATION / CLI EXPERIMENT / HUMAN DECISION) | Yes — expected |
| Decision | ADR | Proposed → Experimenting → Accepted | Only by supersession |
| Fact | as-built record | verified by proof command | No — the record |

**Where each kind lives:**

```text
research/<package>/            proposals — immutable, labeled, human-gated promotion
docs/milestones/<gate>.md      plans — framing stubs now, full plans on demand
docs/adr/                      decisions — humans only
src/<component>/AS-BUILT.md    facts — incremental, proof commands
<gate>-deviations.md           deltas — references + why, nothing more
```

**How research flows into work:**

```text
research package
   └─ conclusions.md (produced by the research, 1 page)
        └─ human dispositions → ADR proposal · gate input · adopted baseline · no action
implementation tasks
   └─ as-built records (updated during work) + deviation-log entries (when plan ≠ reality)
        └─ ADR amendment if the decision itself changed
```

## 3. Current problems (what we are fixing)

1. The research machinery (`catalog.json` + generators + manifests) is hard-coded to ONE package; a new package means editing four scripts.
2. There is a proposal layer (research) and a decision layer (ADRs), but no fact/as-built layer: nothing records what was actually done during implementation.
3. No written contract for how research results flow into docs / ADRs / gates.
4. Confirmed duplication: `accepted-baseline.md` ×2 identical · application-catalogue profile ×2 vintages · workflow described ×4 places · empty `.tools/`.

## 4. Core principles

1. **One home per fact** — a fact has one normative place; everywhere else links (references, not copies).
2. **Presentation is allowed, duplication is not** — summaries must be the document's own framing (honesty test in §7).
3. **Research is never acceptance** — gates are human-accepted; results are immutable evidence (hash ledger).
4. **Raw data never travels** — never committed, and now never even zipped (`git archive` only).
5. **Small, reversible changes** — validator runs after each.
6. **Know the objective state** — before writing prompts for other agents or judging a design, understand what in the repo is disposable, frozen, or uncertain; the repository setup is disposable until gates and ADRs make parts permanent. When a premise is uncertain, ASK the human — never assume.

## 5. Research packages

### 5.1 Lifecycle (the contract, plain language)

1. **Start** — one decision area; package card created (fields in §5.3); status `Draft`.
2. **Scaffold** — studies copied from the template; globally unique result filenames.
3. **Run** — fresh chats; zip input; reading list embedded in the prompt; results saved verbatim.
4. **Validate** — review checklist + suite-agnostic validator (structure, secrets, links, anchors, sizes).
5. **Promote** — one page of dispositions on the conclusions sheet (§5.6).
6. **Archive** — status `complete`; the package stays in place; hash ledger current.

### 5.2 Package anatomy

```text
research/<area>/
├── README.md            package card
├── attachments/         OPTIONAL — only things not already in the repo
├── studies/NN-<slug>/   prompt.md + result-NN-<slug>.md (verbatim, anchors) + README.md
├── review/              only if the area is big enough for batching
└── synthesis/
    ├── prompt.md
    ├── result-<area>-synthesis.md      = 1-page Human summary + full synthesis
    ├── conclusions.md                 = decision sheet, produced BY the research
    └── theoretical-implementation.md  = only when output = synthesis+implementation
```

### 5.3 Package card fields

| Field | Meaning |
| --- | --- |
| Scope + decisions informed | what this research is for |
| Status | Draft → in progress → complete · abandoned · superseded |
| Type | `extensive` (implementation pauses) or `one-off` (implementation continues) |
| Output | `synthesis` or `synthesis+implementation` |
| ETA / expected duration | Type 2 typical wait: 30–90 minutes |
| Parallel plan | how many lanes, which steps depend on which |
| Ingredients chosen + why | from the prompt guide (§6) — auditable prompts |

### 5.4 Research types and the Type-2 continuation cycle

- **Type 1 `extensive`** — new-feature or large research. Many parallel prompts, optional batching (one result feeds the next step when useful). Implementation usually pauses.
- **Type 2 `one-off`** — smaller research during active implementation (or a failed Type 1 needing a new route). One step, possibly several parallel one-step prompts. Implementation continues.

Repeatable Type-2 cycle (checklist in `research/WORKFLOW.md`):

```text
PRE-FLIGHT (5 min)   card (type, ETA, decisions informed); prompt committed as a draft study;
                     name the SAFE LANE from the next-safe-task lists
IN-FLIGHT (30–90 m)  work only the safe lane; dependent tasks get status
                     "Blocked: pending research <package>"
LANDING (15 min)     save results verbatim → validate → dispose conclusions → continue or pivot
PIVOT (only if needed)  deviation-log line; ADR amendment if the decision changed;
                     "rejected route" disposition so the route is never re-researched
```

This works structurally: research is the proposal layer, implementation runs on facts — proposals never block accepted work.

### 5.5 Inputs and output modes

**Input (code zips + curated attachments):** the web agent receives one zip per code-bearing root directory (`src`, `tests`, `contracts`, `tools`, `scripts`, `frontend` when it exists — the list is declared per research run; newly created code-bearing roots are added when they appear), produced via `git archive` of a declared ref (tracked files only; committed state). Code roots contain only codebase material — as-built records are explicitly included, nothing else. Everything non-code the researcher needs (ADRs, decisions-and-gates, evidence rules, research context) travels as curated attachments, never in the zip. No videos, PDFs, `docs/`, `research/`, `evidence/`, or handover content ships. A quick human check approves the pack before upload. The prompt embeds a default reading list with judgment permission.

- **Reading-list note:** the reading list is ALWAYS written into the prompt itself — inputs are shared by all parallelized prompts (and every step of a multi-step run), so each prompt must name its own list; it cannot rely on the shared context.

**Output modes** (`output` field on the card, independent of type):

- `synthesis` — conclusions + visible reasoning. Small labeled *implementation seeds* are allowed when they practically help the next research step.
- `synthesis+implementation` — additionally produces `theoretical-implementation.md`: a draft plan, every claim labeled THEORETICAL / ESTIMATE, grounded in cited facts, "unverified until CLI experiment", with change conditions.
- **Reading-list note 2:** `+implementation` requires a MUCH broader reading list than `synthesis` — the agent must ground the design in the actual repo state (contracts, as-built records, ADRs, relevant code). Plan the reading list accordingly.
- **Safety rule:** a theoretical implementation is a draft plan — never acceptance, never a task on its own. It enters milestone plans only after a human accepts the relevant conclusions; reality wins via as-built records.

**Reasoning depth** is an explicit template demand, not a hope: prompts require visible reasoning — conflict reconstruction, evidence weighting ("which evidence did you weight and why"), explicit UNKNOWNs, and per-conclusion change conditions.

### 5.6 Destination of results (confirmed)

A completed package goes nowhere by itself. It stays in `research/` as the immutable proposal layer. Conclusions travel as exactly one kind of truth, each human-gated:

| Becomes | Goes to | Gate |
| --- | --- | --- |
| Decision | ADR proposal | human accepts |
| Plan | milestone / gate input | cited, never copied |
| Fact | per-component as-built record | when actually implemented |
| Delta | deviation-log entry | when plan ≠ reality |
| Working baseline | adopted-package record in `docs/architecture/adopted-packages/` | human-signed (rare capstone) |

Results are never copied into docs; docs reference them.

A rejected-routes register (a table in `research/README.md`) records dead-end packages and un-promoted conclusions; PRE-FLIGHT checks it so routes are not re-researched.

### 5.7 Reading ladder (human-friendly access to large results)

```text
conclusions.md            (1 page)  → what the research means + what needs a decision
synthesis Human summary   (1 page)  → the reasoning in brief
milestone "About"         (5 lines) → what we're building at this gate
full results                        → only when a detail actually matters
```

- Every synthesis has a mandatory 1-page "Human summary" front section, produced in the same ChatGPT run (born together, no drift).
- `conclusions.md` is PRODUCED BY the research: mandated table (ID, conclusion, label, confidence, source anchor, suggested promotion). The human's job is one page of dispositions.
- Dispositions fill a status column → conclusions.md doubles as the promotion ledger: conclusion → artifact traceability.
- `conclusions.md` is a LIVING file OUTSIDE the hash ledger (decision #20): the ledger protects raw results only; disposition edits need no ceremony.

## 6. Prompt authoring guide (ingredient framework)

Prompt composition is a repeatable decision, not a feeling. Fixed ingredient catalogue in `research/templates/prompt-guide.md`; each ingredient has an inclusion condition; the package card records which conditional ingredients were chosen and why.

| Ingredient | What it produces | When to include |
| --- | --- | --- |
| Role + bounded questions | Focus | ALWAYS |
| Inputs + reading list embedded in the prompt | Grounding | ALWAYS |
| Evidence labels + visible reasoning | Adjudicable output | ALWAYS |
| Human decisions / CLI experiments / residual risk | Honesty boundaries | ALWAYS |
| Time-sensitivity re-verification | Freshness | ALWAYS (tech claims) |
| Theoretical implementation | Draft design | next artifact is a PLAN; decision or next step → synthesis-only |
| OSS library research | Prior art + inspiration | default ON for technical subjects; OFF for policy/governance/informational |
| Standards/regulatory check | Compliance facts | subject touches standards / RFCs / law |
| Objective-state declaration | Shared premise | ALWAYS when delegating to another agent (heavy review, distiller, research): state what is disposable, frozen, and uncertain; ask the human when in doubt |
| Adversarial/falsification pass | Failure modes | trust boundaries (IPC, auth, privacy, durability) |
| Compatibility matrix | Platform truth | platform/version support claims |
| Cost/ops review | TCO, licensing, on-call | budget or operations factor |
| Migration impact | Change surface | alters existing behavior |
| Negative-evidence search | Change conditions | load-bearing decisions |

**OSS research synthesis shape (mandatory):** comparison table (candidate, license, maintenance, fit, gaps, security assessment) + "what we would take inspiration from" + explicit "no relevant prior art exists" when true. Feeds dependency admission (ADR-FS-032).

**Authoring flow:** subject kind → consumer of the result → unknowns → match conditions → load-bearing claims get negative-evidence + CLI experiment + change conditions → review against the template (sections complete, anchors mandated).

The guide is a living catalogue: new ingredients are added with their condition when discovered. The mock-package dry run (step 7) is authored through this guide to prove it.

## 7. Milestones and plans

- Later milestones exist now as **framing stubs**: a 5-line "About this gate" in the plan's own voice + links to the informing studies. Full plans materialize on demand (anti-staleness, anti-bloat). Full-milestones-upfront was explicitly rejected.
- **Summary rule:** every plan layer carries its own short "About" in its own voice + a key-facts table whose rows link to their sources. Honesty test: if editing the source file forces an edit of the summary, it is duplication — shrink it until it is framing, not copy.
- The repo already demonstrates this pattern: `docs/plain-language/`, the synthesis's plain-language recommendation, `decisions-and-gates.md`.
- Plan format sketch: 5-line summary → key-facts table (fact + link) → ordered steps (own text) → links. Token-efficient for agents: one page read, links opened only when needed.

## 8. AGENTS.md and skills (role-based instructions)

Context: token minimization — instructions split into an always-on layer and on-demand role packages. Replaces nested AGENTS.md files and per-role worktrees.

**AGENTS.md (root, always loaded, ~15 lines):**

- Universal invariants: research is never acceptance; results are immutable; raw data never travels; gates are human-accepted; small reversible changes.
- The skill activation table: when working in X, load skill Y.
- One-line pointers to the permanent docs.

**Skills (`.opencode/skills/`, loaded on demand):** each is `SKILL.md` with frontmatter (name; description with front-loaded trigger keywords) and a self-contained body — the agent acts from the skill without opening other files.

**Role → skill mapping:**

| Skill | Activates when | Contains |
| --- | --- | --- |
| `research-workflow` | work under `research/` | lifecycle §5.1, types + Type-2 continuation cycle §5.4, zip input + reading lists §5.5, package anatomy §5.2 |
| `prompt-authoring` | writing/reviewing a research prompt | ingredient framework §6, authoring flow, anchor mandate §12 |
| `as-built` | implementing / touching a component | as-built rules §9, verification layers, proof commands |
| `code-review` | reviewing code / PRs | review procedure §11.2: what to check, what blocks, human-review-guide rules |
| `gate-workflow` | milestone / deviation / gate work | framing stubs §7, deviation log §10, gate acceptance |
| `task-workflow` | starting/finishing a task | task lifecycle, safe lane, handoff |
| `conversation-distiller` | turning a conversation (own history or exported transcript) into repo documentation — e.g. in a fork of the orchestrator | inventory decisions → map each to its home (ownership map) → summary rule + one-home-per-fact → draft → approval → write + commit → gap check |

**Folder structure (findability as the skill folder grows):** skills are grouped by subject in nested folders — the loader scans recursively, so grouping costs nothing:

```text
.opencode/skills/
├── research/        research-workflow · prompt-authoring
├── implementation/  as-built · task-workflow · code-review
└── governance/      gate-workflow · conversation-distiller
```

**Design rules:**

- One home per fact: SKILL.md bodies are the operational home of procedures; `research/WORKFLOW.md` shrinks to a human overview that links to the skills (summary rule, §7).
- The nested `research/AGENTS.md` is deleted; its rules move into `research-workflow`.
- `.opencode/.gitignore` is adjusted so `.opencode/skills/` is committed (repo-shared).
- ~6 role-sized skills, not micro-skills; descriptions front-load trigger keywords; AGENTS.md repeats the same triggers as a table.

### 8.1 Agent team and the expensive-think/cheap-write relay

| Agent | Model | Role | Write scope |
| --- | --- | --- | --- |
| `orchestrator` | deepseek flash (small) | main chat; owns docs/, research/, evidence/, AGENTS.md, skills, task briefs | its scope only |
| `developer` | deepseek flash | writes code + tests + self-review; owns src/, tests/, contracts/, as-built records, its own handoffs | its scope only |
| `heavy` | Kimi K3 | thinking/discussion only — reviews work of the other two; separate session | NOTHING (read-only) |
| fork of `orchestrator` | deepseek flash | the writing relay: distills a conversation into docs | only with human approval |

Rules:

- Same-chat switching only among personas on the SAME model and system prompt (personas = skills / message-level instructions). Model or thinking-effort changes go to separate sessions — mid-chat switches bust the provider prefix cache.
- Agent definitions are COMMITTED to the repo (`.opencode/agents/`) so the setup is portable across machines; provider credentials and keys stay in the global config and are never committed. Heavy's read-only is enforced via its permission config, not by instruction.
- A key-free `opencode.example.json` is committed so the setup is copyable to a new machine. The `.opencode/package.json` plugin dependency was removed (skills replace it); the global Tavily MCP stays.
- Heavy chat is read-only by design. When docs must be written from a conversation, fork the orchestrator chat (`opencode --fork --session <id>`; the `session_fork` keybind is off by default). The fork inherits full context — cache-friendly (same model, same prefix → mostly cache hits) — drafts, the human approves, writes to the proper places, commits. No handoff files: git is the handoff.
- Driving the heavy chat from the orchestrator: `opencode run --session <id> "…"` appends a message and returns only the new reply (the transcript stays in the session, not in orchestrator context); `opencode export <id>` reads the full transcript — verified to include reasoning parts; `opencode --session <id>` lets the human take over the thread. No native "only last N responses" selector — use fork / snapshots / export+distill instead.
- The ownership map prevents conflicts without worktrees; never two agents writing the same file simultaneously.

## 9. As-built records (per component)

- **Location:** `src/<component>/AS-BUILT.md`, next to the code.
- **Maintenance:** periodically DURING implementation — a workflow step (a line in the task template), not a habit; the human may forget under context pressure.
- **Content:** pure current-state truth — what exists, how it was made (commands run, dependencies added, files created), and the command that proves each fact. No plan-comparison inside.
- **Budget:** one page max, terse, no prose. Direct dependencies only; no patch versions.
- **Changes:** facts are replaced (not appended) when they change; history lives in git.
- **Quality bar:** all as-built records combined, together with code, tests, and contracts, allow an agent to reconstruct the system 1:1 from scratch. The reconstruction is a hypothesis until the proof commands pass. Data and environment-specific state are not reconstructible from docs.

**Verification layers (how as-built claims are tested):**

1. **Structure** (machine, in CI) — every AS-BUILT.md exists, required sections present, size budget, links resolve, no secrets.
2. **Claims vs reality** (machine, in CI) — each structured claim diffed against the repo: file exists, dependency actually referenced in the component's project file, version matches the lock file, proof command exists. The "does the doc lie?" test — same pattern as the existing research validation.
3. **Proof commands** (machine, on demand) — run the command a fact claims; green means the fact is verified.
4. **Reconstruction drill** (human-gated, rare — at gate acceptance or after a major change) — fresh checkout, execute the as-built records in order, build, run tests. The 1:1 quality bar made checkable.
5. **Human review** (every handoff) — reviewer spot-checks claims against reality using the existing review checklist.

Rule: a fact without a proof command is a claim, not a fact. Tests are the deeper truth; the as-built is the agreed record.

## 10. Deviation log (per gate)

- A separate file — differences are NOT recorded inside as-built records (the as-built is truth; it does not justify itself against the plan).
- One file per gate (`<gate>-deviations.md`), opened when the gate starts, closed when the gate is accepted. The gate record includes it as an input, so plan-vs-reality drift is part of human acceptance.
- Contains only references + explanation: plan ref → as-built ref → because.
- Feeds ADR amendments when a decision actually changed, and better research prompts for later packages.

## 11. Implementation procedure (the build phase)

Context: the phase after the refactor when the repository is actually used — writing and reviewing code, gate by gate (G0 → G1 → …). Most pieces exist or are designed; this section assembles them into the daily loop.

### 11.1 The task loop

```text
PRE-FLIGHT   task brief from template
             · read the component's AS-BUILT.md → current facts (never start blind)
             · check gate status, relevant ADRs, pending-research blockers
             · if research is running: is this task in the safe lane? (§5.4)
WORK         small reversible steps; commit per step
             · update AS-BUILT.md alongside the code (§9) — the workflow line, not a habit
             · if reality diverged from the plan: one deviation-log line NOW (§10)
FINISH       focused checks + validator
             · handoff: outcome, evidence, as-built delta, deviation lines, next safe task,
               and — when human review is required — a human review guide (§11.2)
             · review → Done → archived → next task
```

### 11.2 Code review

- **Who decides:** the agent decides whether human review is necessary. Uncertain → yes. Certain → no. Always → when the human explicitly requests it. Every handoff records one line when review is skipped: `review skipped because …`.
- **When human review is required**, the agent writes a short human review guide in the handoff: what to look at when testing, which tools/commands to use, what to verify.
- **Mechanical (CI):** claims-vs-reality checker audits as-built records against the repo (files, dependencies, versions, proof commands).
- **Human checklist** stays in `docs/work/templates/`; the agent-side review procedure lives in a `code-review` skill.
- **Deep check (rare):** reconstruction drill at gate acceptance (§9, layer 4).

### 11.3 Gates

Milestone plan expands on demand (§7) → tasks consume it → evidence accumulates → gate record (hashes, residual risks) → human accepts → deviation log closes → next gate stub expands. Gate acceptance is the only place the build phase ends for a gate.

### 11.4 Research ↔ implementation interplay

Type-2 one-off research runs in the safe lane while coding continues (§5.4); human-accepted theoretical implementations become the next milestone plans (§5.5); failed routes become deviation lines + rejected-route dispositions.

### 11.5 New pieces introduced by this section

- Task template gains: the as-built update line, the deviation question, and the optional human-review-guide section.
- New `code-review` skill (agent-side procedure).
- Claims-vs-reality checker is built when `src/` has its first real component.

## 12. Dependencies

A dependency is recorded once, at the level that governs it; the same dependency never appears in two places:

| Dependency fact | Where recorded |
| --- | --- |
| Exact version | Lock file + central package management (`Directory.Packages.props`) |
| Why it is allowed (license, purpose, review) | Dependency admission log (ADR-FS-032) |
| Where a component uses it | One line in that component's AS-BUILT.md (direct only) |
| Full dependency graph | Generated (SBOM, `dotnet list package`, architecture tests) — never hand-maintained |

- Version bumps never touch as-built records.
- Add/remove/restructure of a dependency updates the using component's as-built line + the admission entry.
- Reverse lookups ("who depends on this component?") are grep/generated, not hand-maintained lists.

## 13. Links and anchors

- All cross-references (conclusions sheet, milestone key-facts tables, deviation log) use heading-anchor markdown links: link-text pointing to `file.md` plus a `#heading-slug` anchor. Ctrl+click in VS Code (built-in + zaaack MDE) and a plain click on GitHub both jump to the heading.
- Line-level links (`#L42`) are NOT portable in markdown — the heading is the precision unit.
- Existing results are RETROFITTED with headings (structure only, facts untouched) in scoped rounds: (1) the two syntheses + 7 ADRs, (2) the 6 batch reviews, (3) the 24 studies — only if a real link needs one. Each round: one commit, heading-strip diff check proves zero content change, hash ledger refreshed with recorded reason.
- New study/synthesis templates mandate stable heading anchors for every load-bearing section — links are born with the file.
- The validator gains an anchor-resolution check: every `#slug` link must resolve to an existing heading.

## 14. Deletions and consolidation (go/no-go given)

**Approved for deletion:**

| Group | Item | Why safe |
| --- | --- | --- |
| A | `.tools/` (empty directory) | nothing depends on it |
| B | `research/implementation/context/accepted-baseline.md` | byte-identical to `attachments/accepted-baseline.md` |
| B | `research/implementation/evidence/application-catalogue-profile.json` | old vintage; `evidence/sanitized/` is canonical |
| C | `context/project-file-allowlists.md` | superseded — allowlists now generated into every prompt |
| C | `context/workflow.md` table | hand-copy of catalog batch metadata; trim to the 3 prose sections (dependency handoff, human lane, measurement lane) |
| C | `templates/README.md` + "Repeat the workflow" block | folded into `research/WORKFLOW.md` |
| D | Machinery: `catalog.json`, both manifests, three generator scripts | everything they produced stays committed; future packages use templates + suite-agnostic validator; recoverable from git |

**Stays untouched:** all placeholders (`contracts/`, `src/`, `tests/`, `tools/`), profile scripts, `validate-repository.sh`, the handover package, all research results, ADRs, evidence, `.opencode/` (local-only).

## 15. Refactor steps

| # | Step | Effort |
| --- | --- | --- |
| 1 | Green snapshot: run validator, commit branch point — INCLUDING committing the redesign-notes (untracked today) | S |
| 2 | Delete Groups A–C (empty dir, duplicates, superseded files) | S |
| 3 | Delete machinery + write suite-agnostic validator (incl. anchor-resolution check), keep CI green | M |
| 4 | Reading-ladder backfill for the two frozen suites: a cheap agent writes the Human summary as a front section INSIDE each synthesis (option A) + conclusions.md, faithful to the future format; hash ledger refreshed with recorded reason — replaces the anchor-retrofit rounds | M |
| 5 | Design template+validator contract + build a mock package (authored through the prompt guide) to prove the dry run | M |
| 6 | Write the seven role skills (research-workflow, prompt-authoring, as-built, code-review, gate-workflow, task-workflow, conversation-distiller) + templates (anchors, Human summary, conclusions.md, package card, prompt guide) | M |
| 7 | Create committed agent definitions (`.opencode/agents/`: orchestrator, developer, heavy with read-only permissions) + rewrite AGENTS.md (invariants + skill trigger table); delete `research/AGENTS.md`; commit `.opencode/skills/`; sweep old policy docs (docs/work/README.md, CONTRIBUTING.md, repository-layout.md, milestones README, ADR README) | M |
| 8 | Write `research/WORKFLOW.md` v2 as the human overview linking to the skills | S |
| 9 | Pilot one real research package end-to-end (exercises skills and the code-zip contract) | M |
| 10 | Absorb the redesign-notes into its final homes and remove the file | S |

Every step is one revertible commit; the validator runs after each; no evidence content changes (structure only, documented + hash-refreshed). Token measurement (`opencode stats`) is deliberately excluded — deepseek economics don't justify the complexity.

## 16. Decisions log

| # | Decision | Status |
| --- | --- | --- |
| 1 | Research results stay in place, immutable; completed packages never move | ✓ |
| 2 | Destination: only conclusions travel, each human-gated (ADR / gate / as-built / delta / baseline) | ✓ |
| 3 | Tooling: templates + suite-agnostic validator; catalog/generators/manifests deleted | ✓ |
| 4 | As-built: per-component, periodic during work, proof commands, 1:1 reconstruction quality bar | ✓ |
| 5 | Deviations recorded in a separate per-gate log, never inside as-built | ✓ |
| 6 | Milestones: framing stubs now, full plans on demand | ✓ |
| 7 | Reading ladder: Human summary + conclusions.md + milestone About | ✓ |
| 8 | Anchors: heading links everywhere; existing results retrofitted in rounds | ✓ |
| 9 | Input: `git archive` zip; reading list always embedded in the prompt | ✓ |
| 10 | Output modes on the card; `theoretical-implementation.md` separate and safety-labeled; +implementation broadens the reading list | ✓ |
| 11 | Research types (extensive / one-off) + Type-2 continuation cycle | ✓ |
| 12 | Prompt authoring guide: ingredient framework, auditable choices, living catalogue | ✓ |
| 13 | Adopted-package records live in `docs/architecture/adopted-packages/` | ✓ |
| 14 | Archiving = status change, keep-in-place | ✓ |
| 15 | Frozen suites: facts unchanged; heading-only retrofit + backfill Human summary front section approved (option A — summary embedded inside the syntheses, hash ledger refreshed with recorded reason) | ✓ |
| 16 | Template + validator are one contract; mock package proves it | ✓ |
| 17 | AGENTS.md + skills: always-on invariants + trigger table; seven role skills grouped in subject folders, committed; `research/AGENTS.md` deleted; skills own procedures, WORKFLOW.md becomes the overview | ✓ |
| 18 | Implementation procedure: task loop (as-built + deviation lines per task); review policy — agent decides (uncertain → human, certain → not, explicit request → always), with a human review guide in the handoff; `code-review` skill added | ✓ |
| 19 | Agent team + relay: orchestrator (flash) · developer (flash) · heavy (Kimi, read-only) · fork-of-orchestrator as the writing relay; no handoff files, git is the handoff; `conversation-distiller` skill added | ✓ |
| 20 | Disposability stance + heavy-review triage: the current repo setup is disposable until gates/ADRs make parts permanent; heavy-review consistency findings are moot (final docs written fresh); accepted — conclusions.md lives OUTSIDE the hash ledger · per-root code zips only (as-built included, no non-codebase files) · agents committed to the repo (credentials stay global) · frozen suites backfilled by a cheap agent faithful to the future format · old policy docs updated in the refactor | ✓ |
| 21 | Heavy-review follow-ups: zip roots accepted + new code roots auto-included · key-free `opencode.example.json` committed · package statuses gain abandoned/superseded + rejected-routes register · review-skip audit line in handoffs · token measurement excluded · `.opencode` plugin dependency removed (Tavily MCP stays) · tavily skills grouped under global `web-search/` | ✓ |
| 22 | Backfill format = option A: Human summary embedded INSIDE the frozen syntheses (hash ledger refreshed with recorded reason) · `adopted-baselines/` renamed to `adopted-packages/` | ✓ |

## 17. Conversation record

- 2026-08-05: user described two implementation documentation families — "current" (as-built: what was done, words not code, detailed enough to recreate the state) and "future" (planned, research-based, deliberately not exact instructions because research is fallible).
- 2026-08-05 (corrections): as-built is added periodically during implementation, not after the fact. Differences between plan and reality are NOT recorded inside the as-built; they go in a separate file with only references + explanation.
- 2026-08-05: per-component as-built location and the 1:1 reconstruction quality bar confirmed. Destination question answered from the three-kinds-of-truth model. As-built verification layers agreed.
- 2026-08-05: deep-research structure noted as NOT definitive — to be revisited later, not binding on this design.
- 2026-08-05: go/no-go given — delete the research machinery; Groups A–C approved.
- 2026-08-05: summary rule agreed; clickable links (anchors) + retrofit agreed; reading ladder agreed; future-package dry run agreed.
- 2026-08-05: input method (git archive zip), research types, and the Type-2 continuation cycle agreed.
- 2026-08-05: output modes + visible reasoning agreed; prompt authoring guide (ingredient framework) agreed; reading-list notes (always in the prompt; broader for +implementation) added.
- 2026-08-05: AGENTS.md + skills agreed — always-on invariants + trigger table; five role skills grouped in subject folders (`.opencode/skills/research|implementation|governance/`); skills own procedures, WORKFLOW.md becomes the overview; nested `research/AGENTS.md` deleted.
- 2026-08-05: implementation procedure (build phase) agreed — task loop, gates, research interplay; review policy: agent decides (uncertain → human review, certain → not, explicit request → always) and writes a human review guide in the handoff; `code-review` skill added.
- 2026-08-05: agent team + relay agreed — heavy chat read-only; forks of the orchestrator distill conversations into docs (cache-friendly, git as handoff, no handoff files); export verified to include reasoning parts; `conversation-distiller` skill added.
- 2026-08-06: heavy-chat design review delivered (Kimi K3, read-only, ses_0278eadfeffePB4ypiutTh8qX5). Findings triaged under the disposability stance: notes-consistency findings moot, design/enforcement findings accepted.
- 2026-08-06: five review decisions answered — conclusions.md outside the hash ledger · per-root code zips only · agents committed for portability · frozen suites backfilled by a cheap agent in the future format · old policy docs updated.
- 2026-08-06: lesson recorded (principle #6) — the entire current repo state is disposable; understanding the objective state when writing prompts for other agents is mandatory; ask the human when in doubt.
- 2026-08-07: heavy-review follow-ups decided — zip roots + auto-include, key-free example config, package end-states + rejected-routes register, review-skip audit line, token measurement excluded, plugin dependency removed (MCP stays), tavily skills grouped under `web-search/` (recursive loading confirmed at next restart).
- 2026-08-07: Q2 = option A (Human summary embedded inside the frozen syntheses) · baseline terminology = rename to `adopted-packages/`. All decisions made; refactor ready to start as a continuous loop.

## 18. Remaining open items

None — all decisions are made (see §16). Refactor ready to start; execution runs as a continuous loop that stops only for new questions.

## 19. Permanent location

This file will be absorbed into `research/WORKFLOW.md` (as the human overview), root `AGENTS.md` (invariants + skill triggers), `.opencode/skills/` (role procedures incl. `code-review`), `docs/architecture/repository-layout.md`, the research templates, and the task/handoff templates. Until then it is the authoritative record of this conversation.
