# Repeatable research workflow

## 1. Define one decision area

Create a study only when research can reduce a real uncertainty. State the decision informed, boundaries, accepted inputs, provisional matters, human decisions, and measurements that research cannot replace.

## 2. Create one study folder

Copy `templates/study/` into the correct suite and batch. Use a two-digit ID and a short lowercase slug:

```text
NN-short-topic/
├── README.md
├── prompt.md
└── result-NN-short-topic.md
```

The unique result filename is required because multiple results may be uploaded to the same ChatGPT Project.

## 3. Declare inputs before running

Add the prompt, result target, permitted attachments, and predecessor results to the suite manifest. The prompt’s Project-file allowlist must match the manifest exactly. Never give a chat implicit access to every project file.

## 4. Run and preserve

Run the prompt in a fresh chat, save the complete answer at the declared result path, and do not silently rewrite the result. Corrections need a task record, reason, and refreshed evidence hash.

## 5. Review at the right boundary

Topics may run in parallel when dependencies allow. A batch review reconciles its topic results and all accepted predecessor reviews. Only accepted reviews flow into the final synthesis.

## 6. Convert research into work

Research outputs become proposed ADR changes, human-decision workshops, or falsifying CLI experiments. They do not directly become accepted implementation requirements.

## 7. Validate

```bash
node scripts/generate-implementation-research.mjs --check
node scripts/generate-research-index.mjs --check
node scripts/generate-research-evidence-manifest.mjs --check
node scripts/validate-research.mjs
```

Validation checks structure, unique names, manifests, allowlists, links, generated state, secrets, private addresses, and synthesis dependencies.
