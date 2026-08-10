# Task progress

## Task ID

AGENT-SYSTEM-REBUILD-001

## Status

Review

## Task-start developer SHA

99306f47db96acbcde34ead74a949270674b025e

## Review-base developer SHA

1365cd83762d1140ea969faf64b8ea370f6e739c

## Original task brief

# UAM Agent-System Rebuild — Apply, Repair, Validate, and Push

You are implementing the complete UAM agent-system rebuild for:

`floris3456/uam-modernization`

This is a **bootstrap implementation task**. The new repository-side agent workflow may not be installed yet, so use the extracted rebuild package as the implementation specification and starting point until the new files are active.

## Objective

Take the generated `uam-agent-system-rebuild` package, apply the complete intended repository migration, and leave the actual repository in a **working, internally consistent, validated state on `developer`**.

Do not merely copy files and report errors.

If anything in the generated package:

* Does not work.
* Is syntactically invalid.
* References the wrong path.
* Conflicts with the real repository.
* Fails validation.
* Fails Git simulation.
* Has incorrect executable modes.
* Contains broken links.
* Uses an invalid OpenCode configuration.
* Has incomplete migration behavior.
* Leaves stale active architecture behind.
* Breaks existing repository behavior.
* Violates the intended architecture.
* Cannot function as designed.

then **investigate the actual cause and fix it**.

The package is an implementation-ready design and strong starting point, but it is **not infallible**.

The final repository must work.

Do not “fix” failures by weakening, deleting, bypassing, or disabling meaningful validation unless the validator itself is demonstrably wrong. Fix the underlying implementation whenever possible.

---

# Authorization

This prompt explicitly authorizes you to:

* Inspect the local repository.
* Inspect the extracted rebuild package.
* Extract the ZIP locally if necessary.
* Create/use the `developer` branch.
* Apply the migration to `developer`.
* Modify generated files when necessary to make the architecture actually work.
* Rewrite existing incompatible repository files where required.
* Delete only files that are genuinely obsolete under the accepted target architecture.
* Run repository validators.
* Run package validators.
* Run disposable Git simulations.
* Run syntax/configuration checks.
* Activate repository-owned tracked Git hooks locally.
* Commit implementation work to `developer`.
* Push every `developer` commit to `origin/developer`.
* Create and push the initial `web-orchestration` branch **only after its seed tree has been locally verified to contain exclusively `web-orchestration-only/**`**.

This prompt does **not** authorize you to:

* Merge `developer` into `main`.
* Push implementation content directly to `main`.
* Claim human acceptance.
* Modify preserved immutable source evidence.
* Put ChatGPT Project skill/instruction files inside the implementation repository.
* Use force-push to hide or rewrite normal shared history.
* Use `--no-verify` to bypass repository safeguards.

`main` remains human-accepted state and must not be changed by this task.

---

# Locate the rebuild package

Find the extracted package named:

`uam-agent-system-rebuild/`

It may be:

* In the current workspace.
* Adjacent to the repository.
* In another obvious local artifact directory.
* Available only as `uam-agent-system-rebuild.zip`.

If only the ZIP exists, extract it to a temporary/local directory **outside the implementation repository**.

Do not commit the rebuild package itself into `uam-modernization`.

If `uam-agent-system-rebuild.zip.sha256` is available, verify the ZIP before using it.

Expected package ZIP SHA-256 from generation:

`f9c3cf994652a0f03aac9cfe7116767169c259078a7fd2e7df72a7743a95c11e`

If the available ZIP has a different digest, stop before applying it and report the mismatch.

---

# Read the package before applying it

At minimum inspect:

* `README.md`
* `analysis/human-summary.md`
* `analysis/final-architecture.md`
* `analysis/conflict-matrix.md`
* `analysis/completeness-check.md`
* `manifests/file-disposition.csv`
* `manifests/additions.txt`
* `manifests/rewrites.txt`
* `manifests/deletions.txt`
* `manifests/immutable-evidence.txt`
* `migration/migration-plan.md`
* `migration/branch-setup.md`
* `migration/apply-migration.sh`
* `migration/bootstrap-web-orchestration.sh`
* `migration/rollback-plan.md`
* `validation/validation-plan.md`
* `validation/run-validation.sh`
* `validation/validate-package.py`
* `validation/simulate-migration.sh`
* `validation/simulate-git-workflow.sh`
* `validation/simulate-web-orchestration.sh`
* `chatgpt-project/README.md`
* `web-orchestration-branch/README.md`

Also inspect the complete `final-repository/` payload before applying it.

---

# Establish the real repository state

Before changing anything:

1. Confirm this is `floris3456/uam-modernization`.
2. Inspect `origin`.
3. Fetch remote refs.
4. Inspect `main`.
5. Inspect whether `developer` already exists locally or remotely.
6. Inspect whether `web-orchestration` already exists locally or remotely.
7. Confirm the working tree state.
8. Determine the exact current `origin/main` SHA.
9. Compare it with package baseline candidate:

   `1365cd83762d1140ea969faf64b8ea370f6e739c`

Do not blindly override a baseline mismatch.

## If baseline matches

Proceed with the generated migration.

## If baseline does not match

Do **not** simply pass a different `--baseline-sha` to silence the guard.

Instead:

1. Determine what changed since the package baseline.
2. Reconcile those changes against the package target.
3. Determine whether any generated rewrite/deletion is now unsafe or stale.
4. Update the migration implementation/manifests locally if required.
5. Preserve unrelated newer repository work.
6. Continue only when you can establish that the resulting repository still implements the accepted target architecture correctly.

The baseline guard exists to prevent blind overwrite, not to prevent a competent reconciliation.

---

# Immutable evidence

Never modify preserved immutable evidence.

This includes the categories identified by:

`manifests/immutable-evidence.txt`

and particularly:

* Historical handover material.
* Raw externally produced research/baseline evidence.
* Preserved research result evidence identified by the migration safety rules.

You may inspect such material when necessary.

If it contains something incorrect, record the correction elsewhere rather than changing the source evidence.

Before and after migration, verify that immutable evidence has not changed.

---

# Branch setup

Normal implementation happens on:

`developer`

If `developer` does not exist, create it from the exact current accepted `main` baseline and push it.

If `developer` already exists:

* Do not overwrite it.
* Inspect its ancestry.
* Determine whether it already contains implementation work.
* Reconcile safely.
* Preserve valid work.

Do not work directly on `main`.

---

# Task continuity for this bootstrap

Use task ID:

`AGENT-SYSTEM-REBUILD-001`

Once the new task workflow files are installed, create:

`docs/work/current/AGENT-SYSTEM-REBUILD-001-agent-system-rebuild.md`

Use the installed task-progress template and workflow.

The `Original task brief` must contain this exact public-safe delegated prompt verbatim.

Maintain the task record throughout the bootstrap once the workflow exists.

This task is allowed to bootstrap the mechanisms it subsequently uses.

---

# Apply the generated migration

First run the migration in check mode.

Use the package's own:

`migration/apply-migration.sh`

against the actual repository.

Do not continue if it reports a real unresolved safety problem.

If check mode succeeds, apply the migration.

The package's `final-repository/` directory is an **overlay containing additions and rewrites**, not a trustworthy replacement for every unchanged baseline byte.

Therefore:

* Preserve existing files not explicitly added/rewritten/deleted.
* Preserve immutable evidence byte-for-byte.
* Delete only paths listed in the deletion manifest unless you discover an additional active obsolete artifact that must be removed for consistency.
* If you discover such an omitted artifact, inspect its references carefully and fix the package/repository consistently rather than leaving contradictory old machinery active.

---

# Do not blindly trust generated files

After applying the payload, inspect how it interacts with the actual repository.

You are responsible for making the result function.

If the package made an incorrect assumption, correct it.

Examples:

* Wrong path.
* Wrong command.
* Wrong file mode.
* Wrong reference.
* Missing file.
* Broken validator.
* Invalid shell syntax.
* Invalid JSON/JSONC/YAML.
* OpenCode configuration incompatible with the installed/current OpenCode version.
* Skill trigger that cannot resolve.
* Hook that behaves differently in the real Git environment.
* Migration script bug.
* Branch script bug.
* Existing repository mechanism that the package overlooked.
* Documentation that contradicts actual implementation.
* Security language that still incorrectly requires a private repository.
* Active jDocMunch dependency.
* Active protected-path enforcement.
* Old machine configuration that still references replaced agents/skills.
* Incorrect assumptions about AS-BUILT or deviation locations.

Fix the real implementation, update affected documentation, and rerun validation.

Do not stop at “the generated package was wrong.”

---

# OpenCode configuration

The intended implementation agents are:

* `small-developer` — Luna, default.
* `large-developer` — Sol, exceptional escalation.

The generated package currently proposes:

* `opencode/gpt-5.6-luna`
* `reasoningEffort: max`
* `opencode/gpt-5.6-sol`
* `reasoningEffort: high`

Verify that the installed/current OpenCode version accepts the generated configuration.

If model identifiers, reasoning option names, agent frontmatter, permissions, default-agent configuration, or skill-loading configuration do not actually work in the available OpenCode installation:

1. Inspect the actual error.
2. Consult locally available OpenCode help/schema/model discovery where possible.
3. Correct the configuration to the currently functioning equivalent.
4. Preserve the intended semantics:

   * Luna default.
   * Highest applicable Luna reasoning tier.
   * Sol `high`.
   * Web orchestrator controls routing.
   * No automatic local orchestration layer.

Do not invent configuration merely to make parsing pass.

---

# Install and activate tracked hooks

After migration, activate the repository-owned hooks using the installed bootstrap procedure.

Verify:

* `core.hooksPath` points to the tracked hook directory.
* Hook executable bits are correct.
* Normal `developer` commits automatically attempt push.
* Push failure creates the expected local synchronization-failure state.
* Further normal commits are blocked while synchronization is unresolved.
* Ordinary direct `main` pushes are blocked.
* `--no-verify` is not part of the normal workflow.

If hooks do not behave correctly in the actual environment, fix them.

---

# AS-BUILT and deviation discipline

This migration itself is implementation.

Once the new `implementation-records` skill exists, follow it.

AS-BUILT is:

1. Live implementation memory.
2. Durable reverse-engineer-capable truth.

Deviation records describe material intended-versus-actual differences.

If this bootstrap changes a fact represented by an applicable AS-BUILT or deviation record, update that record **in the same implementation commit**.

Do not knowingly push implementation that makes its durable records false and repair them later.

If an existing AS-BUILT record is discovered to be inaccurate, correct it as part of the task.

---

# Commit discipline during implementation

After the migrated hook workflow is active:

* Work only on `developer`.
* Use task ID `AGENT-SYSTEM-REBUILD-001` in task commit messages.
* Every commit must be pushed immediately.
* Do not accumulate local implementation commits.
* Do not force-push.
* Prefer corrective commits or `git revert`.

If push fails:

* Stop implementation.
* Do not make another implementation commit.
* Follow synchronization recovery.
* A push failure is the only reason you may return control without a successful push.

---

# Validation: package first, repository second

Run the package-level validation suite.

At minimum:

`validation/run-validation.sh`

Run every applicable generated simulation/check.

Then run the migrated repository's own validators, including:

`./scripts/validate-repository.sh`

and all underlying checks it invokes.

Also independently run syntax checks where useful for:

* Shell.
* MJS/JavaScript.
* JSON.
* JSONC.
* YAML.
* Markdown links/references where supported.
* Git hook executability.

Do not report “passes” unless the command actually passed.

---

# Disposable Git workflow simulation

Run the generated disposable Git simulations and repair any problem until they pass.

The final implementation must correctly demonstrate at least:

1. Normal implementation commit.
2. Immediate automatic push.
3. Dedicated task handoff snapshot commit.
4. Immediate automatic push.
5. Push failure.
6. Synchronization-failure state.
7. Further commit blocked after failed push.
8. Synchronization recovery.
9. Normal direct `main` push blocked.
10. Non-fast-forward/rewrite protection where designed.
11. Finalization commit deleting task-progress.
12. Correct review-boundary SHA behavior.
13. Human-approved promotion mechanics.
14. Explicit `developer → main` merge.
15. Promotion push.
16. Post-merge `developer` synchronization.

These simulations must use disposable repositories/remotes, never the real repository branches.

If any generated simulation is itself defective, repair the simulation if necessary and ensure it tests the intended behavior meaningfully.

Do not weaken a test merely to obtain green output.

---

# Review-range semantics

A handoff snapshot is only a boundary marker.

Do not assume reviewing the final task-progress snapshot commit alone covers implementation.

For this implementation task, maintain enough state to identify:

* Task-start `developer` SHA.
* Previous reviewed/handoff SHA where applicable.
* Current handoff SHA.

`Files changed` in the final response must cover the full relevant implementation/handoff range, not just the last snapshot commit.

---

# ChatGPT Project package

The following package content is **not repository content**:

`chatgpt-project/`

Do not copy it into `uam-modernization`.

Validate it for:

* Internal links/references.
* Skill naming.
* MCP-ON/MCP-OFF separation.
* Mode-selection consistency.
* Public-safe persistence rules.
* Routing logic.
* Review-range logic.
* Orchestration-state behavior.
* Human acceptance.
* Main-promotion behavior.

If you discover contradictions or broken references, fix them in the extracted/local ChatGPT Project package and mention that in your final handoff.

You cannot install these files into the human's ChatGPT Project yourself.

Do not pretend that you did.

They are to remain ready for manual Project installation.

---

# `web-orchestration` branch

The package contains:

`web-orchestration-branch/`

and:

`migration/bootstrap-web-orchestration.sh`

The final remote branch must contain only:

`web-orchestration-only/**`

It must **not** contain a copy of the normal implementation repository tree.

After the repository migration is validated:

1. Run the web-orchestration bootstrap against the package seed without `--push`.

2. Inspect the resulting local branch/ref.

3. Verify every tracked path begins with:

   `web-orchestration-only/`

4. Verify it contains the intended seed files for:

   * task context;
   * agent routing;
   * branch README/templates.

5. Verify there are no implementation files.

6. Fix the seed/bootstrap mechanism if any invariant fails.

7. Once verified, push the newly created `web-orchestration` branch.

If a remote `web-orchestration` branch already exists, do not overwrite it. Inspect it and reconcile deliberately.

Never merge this branch into `developer` or `main`.

Never merge implementation branches into it as normal synchronization.

---

# Public-safety check

Before committing/pushing anything, ensure every new tracked item is safe for public disclosure.

Do not commit:

* Secrets.
* Credentials.
* Private chat material.
* Sensitive values not already intended for public Git.
* Private human reasoning.
* Unnecessary personal data.

The task-progress file preserves **this delegated public-safe prompt**, not unrelated private conversation.

---

# Architecture cleanup

After migration, search the complete active repository for remaining dependencies on the old system.

Inspect semantically rather than using a simplistic forbidden-word rule.

Pay special attention to active references involving:

* old orchestrator/reviewer agents;
* old developer/heavy agent names;
* jDocMunch;
* protected-path architecture;
* protected lane;
* `allow_state_change`;
* old handoff paths;
* old OpenCode skills;
* old validation scripts;
* old connector assumptions;
* old private-repository requirements;
* deleted workflow names;
* obsolete branch semantics;
* obsolete four-field-only handoff.

Historical/source evidence may legitimately contain old terms.

Do not edit immutable evidence merely because it mentions the old architecture.

Current active machine configuration, instructions, templates, validators, and architecture documentation must be coherent with the new design.

---

# Do not mechanically freeze future architecture

Do not add validators requiring:

* exactly two agent files forever;
* permanent absence of any file named orchestrator/reviewer;
* brittle global denylisting of old words.

Mechanically enforce only things that can be established reliably.

Use semantic inspection for architecture evolution.

---

# Fix-until-working requirement

This is mandatory:

> Do not stop after the first failure if the failure is within your ability to diagnose and repair.

For every failure:

1. Capture the direct observed error.
2. Identify whether the problem is:

   * generated package defect;
   * repository incompatibility;
   * environment/tooling problem;
   * bad assumption;
   * actual external blocker.
3. Fix defects and incompatibilities.
4. Rerun the smallest relevant check.
5. Rerun the larger validator/simulation after the local check passes.
6. Continue until the final repository is internally consistent and all reliable applicable checks pass.

Only stop as blocked when the remaining issue genuinely requires:

* unavailable external authority;
* unavailable credentials/permission;
* unavailable service/tool;
* human decision;
* or another condition you cannot safely resolve yourself.

Do not label an ordinary implementation bug as an external blocker.

---

# Final repository review before handoff

Before returning control:

1. Inspect `git status`.
2. Confirm you are on `developer`.
3. Confirm all intended implementation changes are committed.
4. Confirm every commit has reached `origin/developer`.
5. Confirm immutable evidence is unchanged.
6. Confirm repository validators pass.
7. Confirm package validators pass where applicable.
8. Confirm disposable Git simulations pass.
9. Confirm hook activation/check passes.
10. Confirm active architecture contains no unresolved old-system dependency.
11. Confirm public repository documentation no longer requires GitHub itself to remain private.
12. Confirm ChatGPT Project artifacts remain outside the repository.
13. Confirm the local/remote `web-orchestration` branch has only `web-orchestration-only/**`.
14. Confirm no merge into `main` occurred.
15. Confirm task-progress is completely current.
16. Confirm applicable AS-BUILT/deviation records are current.

---

# End-of-turn handoff

Before the final normal response:

1. Update the task-progress file completely.
2. Ensure implementation records are current.
3. Create the dedicated handoff snapshot commit.
4. Push it successfully.
5. Verify the remote commit exists.

Then return **only**:

```text
Status:
Files changed:
Checks + perceived results:
Blockers/decisions:
Task record:
```

## `Status`

Include:

* Completion/blocker state.
* `developer`.
* Exact final handoff commit SHA.
* Confirmed push state.

## `Files changed`

List every path changed across the complete relevant implementation/handoff range, not only the final task snapshot commit.

## `Checks + perceived results`

List the actual checks/simulations run and concise observed results.

## `Blockers/decisions`

If none:

`None.`

If blocked, state only:

* Observable blocker.
* Where work stopped.
* What external information/decision is required.

Do not write a speculative diagnosis.

## `Task record`

Use the exact task-progress path:

`docs/work/current/AGENT-SYSTEM-REBUILD-001-agent-system-rebuild.md`

Do not merge `developer` into `main`.

That happens only after independent web-orchestrator review and explicit human approval of an exact `developer` SHA.

## Corrective steering

Continue the existing public-safe repository task `AGENT-SYSTEM-REBUILD-001` on `floris3456/uam-modernization` as a corrective continuation. This is the same task and same intended outcome; do not create a new task ID.

Execution exception: for this continuation only, the human authorized the legacy OpenCode `build` agent using `openai/gpt-5.6-sol` with the `high` variant because the live OpenCode runtime did not expose the rebuilt named developer agents. This is an execution-transport exception only. Do not change the repository's intended Luna-default / Sol-exception routing policy merely to accommodate the legacy runtime.

Authoritative reviewed boundaries carried into this continuation:
- Task-start `developer` SHA: `1365cd83762d1140ea969faf64b8ea370f6e739c`
- Previous implementation SHA: `aa1c1099ca4418fe1f7031ddecaf20e73e8dc7f9`
- Last reviewed/current handoff `developer` SHA: `99306f47db96acbcde34ead74a949270674b025e`
- Expected `main` SHA before this correction: `1365cd83762d1140ea969faf64b8ea370f6e739c`
- Expected isolated `web-orchestration` SHA from the prior review: `f3b6793249e3f36733d40bc302bc6011b3814c61`
- Existing task record: `docs/work/current/AGENT-SYSTEM-REBUILD-001-agent-system-rebuild.md`

MANDATORY STOP-GATE BEFORE ANY MUTATION:
1. Work only in the existing UAM checkout on branch `developer`.
2. Fetch `origin` and verify the working tree is clean.
3. Verify `origin/developer` is exactly `99306f47db96acbcde34ead74a949270674b025e` and `origin/main` is exactly `1365cd83762d1140ea969faf64b8ea370f6e739c`.
4. Verify local `developer` can be fast-forwarded/synchronized to that exact remote handoff without rewriting history and that the tracked hooks are active.
5. If either remote ref differs, synchronization is broken, the tree is unexpectedly dirty, or safe continuation is ambiguous: make no implementation commit and return the five-field blocker response. Do not reset, force-push, rebase shared history, or improvise around the mismatch.

General corrective outcome:
Repair the two independent-review defects below while preserving all previously implemented agent-system behavior and the existing reviewed-base semantics. Use corrective commits on shared `developer`; do not rewrite prior commits.

FINDING 1 — failed-push marker can be bypassed by discarding the failed local commit:
The current pre-commit path may remove `uam-sync-failed` merely because current `HEAD` equals its upstream. After a failed push, a user can therefore move/reset local `developer` back to `origin/developer`, abandoning the failed local commit, and the next pre-commit can silently clear the marker. That is not an auditable synchronization recovery of the recorded failed SHA.

Required behavior:
- A failed-push marker must continue to block normal commits until the recorded failed local commit is demonstrably preserved in the synchronized history, or the repository's directed recovery procedure has safely incorporated and verified it.
- Merely changing/resetting `HEAD` to match upstream must not erase the failure state when the marker names a different failed SHA.
- Recovery should remain fast-forward/rebase-free where possible, preserve shared history, and fail closed on ambiguity/conflict/concurrent movement.
- Add a regression simulation that specifically demonstrates the reset/discard bypass is rejected, plus positive recovery coverage showing the marker is cleared only after safe verified synchronization.

FINDING 2 — interrupted promotion resumption is insufficiently bound to the exact promotion:
The current promotion resume logic can recognize `origin/main` as a resumable promotion based mainly on structural properties (two parents, approved SHA as second parent, approved tree). An independently created or otherwise unexpected merge with those structural properties can therefore be mistaken for the exact interrupted human-approved promotion.

Required behavior:
- Resume only the exact promotion that this workflow previously initiated for the same approved developer SHA and expected previous main state, with sufficient durable/local evidence to distinguish it from a merely look-alike merge.
- Validate the first parent / previous-main relationship and any pending-state evidence needed to prove exact continuity.
- Preserve the intended resumable case where `main` was successfully pushed but synchronization of `developer` failed.
- Fail closed if `origin/main` contains a structurally similar but unrecognized merge, if pending evidence conflicts, or if refs moved unexpectedly.
- Add a regression simulation for a crafted/look-alike main merge that previously would have been accepted, and retain positive coverage for genuine interrupted-promotion resumption.

Scope and records:
- Inspect and change only the files needed for these corrections and their truthful documentation/tests. Likely areas include `.githooks/`, `scripts/recover-remote-sync.sh`, `scripts/promote-developer-to-main.sh`, repository validation/simulation coverage, `docs/architecture/branch-workflow.md`, relevant implementation/deviation records, and the existing task-progress file.
- Do not touch immutable evidence or historical source material merely to satisfy current terminology.
- Do not modify `main` or perform a real promotion.
- Do not inspect, modify, merge, or depend on the `web-orchestration` branch.
- All destructive/edge-case Git workflow tests must use disposable repositories/remotes, never the real remote.
- If `/tmp/opencode/uam-agent-system-rebuild` still exists and remains part of this task's generated package, keep its corresponding payload/validation behavior consistent and rerun its validation. If it is absent, do not recreate unrelated package work solely for this correction.

Task-progress continuity:
- Continue `docs/work/current/AGENT-SYSTEM-REBUILD-001-agent-system-rebuild.md`; do not create a new task record.
- Preserve the original task brief. Record this corrective steering verbatim in the task record (for example under a clearly labelled corrective-steering subsection) without copying private chat context.
- Add a `Changed approach` entry identifying the prior behavior, this web-orchestrator steering, and whether existing work is retained/corrected.
- Keep Observed vs Interpretation distinct.
- Keep AS-BUILT/deviation/durable architecture records truthful and update them atomically with implementation commits whose facts they describe.

Checks required before handoff:
- Run the repository's normal validation entry point.
- Run shell/Node syntax checks applicable to changed scripts.
- Run `git diff --check` for the corrective range.
- Run disposable Git simulations covering both negative regressions and their positive safe paths.
- Verify `origin/main` remains exactly unchanged.
- Verify every corrective `developer` commit is pushed and remotely visible before continuing.

Handoff:
- After substantive corrective work is complete and pushed, update task-progress completely and create the required dedicated handoff snapshot commit whose only intended purpose is the task-progress boundary.
- Push it and verify exact remote visibility.
- Do NOT finalize/delete the task-progress file yet. Independent web-orchestrator review must occur first.
- Do NOT merge or promote to `main` and do not claim human acceptance.

Return only these five fields:
Status:
Files changed:
Checks + perceived results:
Blockers/decisions:
Task record:

## Current objective

Apply, repair, validate, and push the agent-system rebuild while preserving newer local facts and immutable evidence.

## Current position

Corrective implementation commit `2a839e127d1c4785ee843c15ae2fc2fa8738b214` is validated and confirmed on `origin/developer`. Failed-push recovery now preserves the marker's recorded commit through reset/discard attempts, promotion resumption requires exact pre-push pending evidence, `origin/main` remains unchanged, and this task-progress update is ready for the dedicated corrective handoff snapshot.

## Observed

- `origin/main` and the package baseline both equal `1365cd83762d1140ea969faf64b8ea370f6e739c`.
- The original package check failed because `docs/work/future/agent-system-improvements.md` was incorrectly classified as a baseline rewrite.
- OpenCode 1.18.15 model discovery exposes the required models as `openai/gpt-5.6-luna` and `openai/gpt-5.6-sol`, not under the generated `opencode` provider ID.
- The first expanded divergent-recovery simulation showed that `MERGE_HEAD` is unavailable to `pre-merge-commit`; exact authorization now uses a transient Git-directory marker and post-merge parent verification.
- The repaired package validation suite passes all package, migration, web-branch, and Git workflow simulations.
- The running OpenCode session cannot hot-load the newly installed skill paths; their installed contents were read directly and are being followed. A restarted OpenCode session will discover them normally.
- The repository validator initially reported 451 false link errors because the generated generic Markdown walker scanned ignored dependencies and immutable generated code evidence; traversal now leaves research to its dedicated parser-aware validator and ignores retired local handoffs/dependencies.
- `web-orchestration` was created as orphan commit `f3b6793249e3f36733d40bc302bc6011b3814c61`, verified to contain exactly five `web-orchestration-only/**` seed files, and pushed to `origin/web-orchestration`.
- The implementation hook pushed `aa1c1099ca4418fe1f7031ddecaf20e73e8dc7f9`; local `HEAD`, `origin/developer`, and the remote branch ref were equal afterward.
- `origin/main` remains `1365cd83762d1140ea969faf64b8ea370f6e739c`; no implementation merge or main push occurred.
- The full implementation range changes no path in the immutable-evidence categories.
- The corrected ChatGPT Project package remains outside the repository and is ready for manual Project installation; no live Project installation was claimed.
- The corrective stop-gate observed clean synchronized `developer` at `99306f47db96acbcde34ead74a949270674b025e`, active tracked hooks, and `origin/main` at `1365cd83762d1140ea969faf64b8ea370f6e739c` before any file mutation.
- The failed-push regression simulation reset local `developer` to its upstream while the marker named the discarded failed commit; the next commit remained blocked, the marker retained that SHA, and directed recovery restored and pushed it before clearing the marker.
- The promotion regression simulation placed an independently crafted two-parent merge on disposable `main` with the approved SHA as second parent and the approved tree; promotion rejected it because no exact pending evidence existed.
- The genuine interrupted-promotion simulation retained the exact merge/approved/previous-main tuple after the `main` push and failed `developer` push, then resumed the same merge and synchronized both disposable remote branches.
- Corrective commit `2a839e127d1c4785ee843c15ae2fc2fa8738b214` is exactly visible at local `HEAD` and `origin/developer`; `origin/main` remained unchanged.

## Interpretation

The accepted architecture remains intact after correcting the two reviewed evidence-binding defects. The durable workflow and deviation records own the implemented recovery invariants; this task record owns the corrective steering, observed simulations, and current review boundary.

## Attempts

- Original package migration check: failed on a missing declared rewrite; corrected by reclassifying the path as an addition and enforcing addition absence.
- Environment-only divergent-merge authorization: pre-merge validation could not establish the merge target because `MERGE_HEAD` was empty at hook time; replaced with a transient exact-head authorization marker and post-merge parent checks.
- Divergent recovery initially relied on `post-commit` to push a merge, but Git did not invoke it for the merge path; recovery now pushes explicitly and verifies the fetched remote head.
- Generated pre-implementation Markdown traversal: failed on ignored dependencies and immutable evidence; corrected by preserving dedicated research validation and narrowing the generic active-document walk.
- The first crafted-merge fixture attempted to move the disposable bare ref to an object that existed only in the primary clone; the remote rejected the missing object, so the fixture was corrected to create and push the independent merge from a hook-free peer clone.
- The first pending-evidence predicate called a shell function inside `[[ ... ]]`; the simulation exposed the runtime conditional error, so format validation and structural merge validation were split into separate fail-closed checks.

## Changed approach

- Moved the untracked rebuild package outside the repository before migration so it could not enter Git or make the baseline checkout dirty.
- Preserved pre-migration local work in a temporary stash while applying the exact-baseline overlay; durable facts are being reconciled semantically rather than blindly replayed over replaced architecture.
- The prior implementation inferred marker resolution from current head/upstream equality and inferred promotion identity from merge shape. This web-orchestrator steering retains the rebuilt workflow and corrects those two inference paths to require exact recorded recovery evidence.

## Checks

- Package SHA ledger before repair: passed for all originally listed files.
- Repaired `validation/run-validation.sh`: passed.
- Repaired actual migration `--check`: passed with 25 additions, 23 rewrites, and 17 deletions.
- Actual migration `--apply`: completed without changing Git history.
- Migrated `./scripts/validate-repository.sh`: passed after repository integration repair.
- Shell and Node syntax checks: passed.
- `git diff --check`: passed.
- `./scripts/bootstrap-agent-workflow.sh --check`: passed with `core.hooksPath=.githooks` and executable hooks.
- OpenCode debug resolution: both developer agents resolved with the intended models, reasoning options, primary mode, and task denial.
- Remote web-branch bootstrap: exact reviewed orphan commit pushed successfully.
- Final repaired `validation/run-validation.sh`: passed with 50 payload files, 17 deletions, linked-worktree migration, isolated web publication, failed-push blocking/recovery, divergent merge recovery, finalization, and resumable promotion.
- Final committed `./scripts/validate-repository.sh`: passed all pre-implementation, agent-system, research, code-reference, evidence-manifest, and hook checks.
- Final local/remote verification: `HEAD` and `origin/developer` both `aa1c1099ca4418fe1f7031ddecaf20e73e8dc7f9`; `origin/main` unchanged; `origin/web-orchestration` at the reviewed seed SHA.
- Preserved PowerShell handover validator: not run because `pwsh` is not installed in this Linux environment (`pwsh: command not found`).
- Corrective `./scripts/validate-repository.sh`: passed all pre-implementation, agent-system, research, code-reference, evidence-manifest, and hook checks.
- Corrective shell and Node syntax checks: passed for all tracked hooks, changed shell scripts, repository shell entry points, and active Node validators.
- Corrective `git diff --check 99306f47db96acbcde34ead74a949270674b025e..2a839e127d1c4785ee843c15ae2fc2fa8738b214`: passed.
- Corrected package `validation/run-validation.sh`: passed package integrity, migration, isolated web publication, and the complete disposable Git workflow simulation.
- Corrective disposable Git workflow: passed reset/discard rejection, verified failed-commit restoration, ordinary and divergent recovery, crafted promotion look-alike rejection, and genuine interrupted-promotion resumption.
- Corrective remote verification: local `HEAD` and `origin/developer` both `2a839e127d1c4785ee843c15ae2fc2fa8738b214`; `origin/main` exactly `1365cd83762d1140ea969faf64b8ea370f6e739c`.

## Blockers / required decisions

None.

## Remaining work

- Create and push the dedicated corrective handoff snapshot commit containing only this task-progress update.
- Independent web-orchestrator review of the corrective range from `99306f47db96acbcde34ead74a949270674b025e` to the new handoff SHA.

## Next action

Create the dedicated corrective handoff snapshot commit and verify its exact remote SHA before returning control.

## Relevant durable records

- `docs/architecture/agent-system.md`
- `docs/architecture/branch-workflow.md`
- `docs/architecture/implementation-records.md`
- `docs/architecture/agent-system-deviations.md`
- `docs/architecture/design-record.md`

## Last handoff commit

99306f47db96acbcde34ead74a949270674b025e
