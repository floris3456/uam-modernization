# Research evidence rules

Follow the root `AGENTS.md`. Within `research-packs/`:

- Treat populated result files as preserved evidence. Do not summarize, reformat, or rewrite them casually.
- Prompt files and shared attachments under `implementation/` are generator-owned. Change the generator first and run its `--check` mode.
- The canonical Batch 4 review is `implementation/results/batch-04-server-platform/batch-04-review-result.md`; do not create numbered duplicate filenames.
- Never add raw catalogues, SSH material, private/internal addresses, credentials, confidential SQL, personal information, or production data.
- Research statements are recommendations or source evidence, not accepted ADRs, measurements, or production approval.
- When a research result changes intentionally, regenerate `evidence/manifests/research-baseline.json` and record why in the task handoff.

Run `./scripts/validate-repository.sh` from the repository root before handoff.
