# Agent-system rebuild deviations

This record compares the generated rebuild package with the implementation that was required to make the accepted architecture function in the verified repository and tool environment.

| Package expectation | Implemented reality | Reason |
| --- | --- | --- |
| `opencode/gpt-5.6-luna` and `opencode/gpt-5.6-sol` | `openai/gpt-5.6-luna` and `openai/gpt-5.6-sol` | OpenCode 1.18.15 exposes the required models under the configured `openai` provider; the generated provider IDs do not exist in model discovery. |
| Failed-push recovery handles only one-sided ancestry | Directed recovery can create one exact-head, non-conflicting merge commit | The failure marker otherwise blocks the only history-preserving recovery from real divergence. Conflicts still fail closed. |
| Promotion is a normal delegated task and assumes both pushes succeed | Promotion is a no-edit operation with resumable post-`main` synchronization | A normal task snapshot invalidates exact-SHA approval, and a failed second push must not strand accepted `main`. |
| Web-branch bootstrap is rerun with `--push` but rejects its own local ref | Creation and later push are separate validated phases | The reviewed local orphan commit must be pushable without reseeding or replacing an existing remote ref. |
| The local improvement backlog is a baseline rewrite | The path is an addition reconciled from pre-migration local work | The accepted baseline does not contain the path, so rewrite classification made check mode fail correctly. |
| Generated scouting configuration omits newer local runtime facts | Strict freshness and the time-bounded remote summarizer data flow are retained in current architecture | These public-safe facts were valid uncommitted work newer than the package baseline and cannot be silently overwritten. |

These corrections preserve the accepted authority, branch, public-safety, review-range, and no-history-rewrite semantics.
