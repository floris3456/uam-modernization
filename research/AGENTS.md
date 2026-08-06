# Research evidence rules

Follow the root `AGENTS.md`. Within `research/`:

- Treat populated result files as preserved evidence. Do not summarize, reformat, or rewrite them casually; intentional changes need a recorded reason and a refreshed evidence hash.
- A study keeps its prompt and result together; result filenames are globally unique.
- Package cards (`README.md`) and `research/WORKFLOW.md` are the process sources; validation is walk-based (`node scripts/validate-research.mjs`).
- Never add raw catalogues, SSH material, private/internal addresses, credentials, confidential SQL, personal information, or production data.
- Research statements are recommendations or source evidence, not accepted ADRs, measurements, or production approval.
- Research evidence never becomes acceptance by itself; promotion requires a human disposition.

Run `./scripts/validate-repository.sh` from the repository root before handoff.
