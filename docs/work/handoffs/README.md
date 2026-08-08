# Chat handoffs (gitignored by design)

This folder holds **chat handoffs** — full conversation memory for a continuing
chat (e.g. `CHAT-HANDOFF-2026-08-08.md`). It is intentionally gitignored
(design record row 44): the committed+trash pattern left a dangling uncommitted
deletion that failed the web lane's clean-tree criterion. The durable record of
each handoff is the corresponding design-record row; the full text lives here
and in chat history.

Task handoffs (the small `handoff-template.md` records that travel with task
briefs) are NOT affected — they remain committed and archived per
`docs/work/README.md`.
