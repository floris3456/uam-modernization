#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";

const repoRoot = path.resolve(path.dirname(new URL(import.meta.url).pathname), "..");
const researchRoot = path.join(repoRoot, "research");
const checkOnly = process.argv.includes("--check");
const generated = new Map();
const baselineStudies = [
  [1, "architecture-validation", "Architecture validation"],
  [2, "language-stack", "Language and stack selection"],
  [3, "security-privacy", "Security and privacy"],
  [4, "windows-feasibility", "Windows feasibility"],
  [5, "scale-reliability", "Scale and reliability"],
  [6, "requirements-migration", "Requirements and migration"],
];
const pad = (value) => String(value).padStart(2, "0");
const rel = (file) => path.relative(repoRoot, file).split(path.sep).join("/");
const register = (file, content) => generated.set(file, content.endsWith("\n") ? content : `${content}\n`);

for (const [id, slug, title] of baselineStudies) {
  const directory = path.join(researchRoot, "baseline/studies", `${pad(id)}-${slug}`);
  register(path.join(directory, "README.md"), `# ${pad(id)} — ${title}

**Status:** complete historical study

- [Prompt](prompt.md)
- [Result](result-${pad(id)}-${slug}.md)

This study informed the first technical baseline. Use the implementation synthesis for current planning.
`);
}

const baselineRows = baselineStudies.map(([id, slug, title]) => `| ${pad(id)} | [${title}](studies/${pad(id)}-${slug}/README.md) |`).join("\n");
register(path.join(researchRoot, "baseline/README.md"), `# Baseline research

**Status:** complete historical research cycle.

This first cycle challenged the original modernization proposal and produced the baseline that seeded the implementation research. It is retained for provenance. Start current planning from the [implementation synthesis](../implementation/synthesis/result-implementation-technical-baseline.md).

| Study | Folder |
| ---: | --- |
${baselineRows}

## Synthesis and context

- [First technical synthesis](synthesis/result-baseline-technical-synthesis.md)
- [Shared context](context/shared-context.md)
- [Evidence map](context/evidence-map.md)
- [Generated code reference](attachments/code-reference.md)
`);
register(path.join(researchRoot, "baseline/studies/README.md"), `# Baseline studies

Each numbered directory contains exactly one prompt, one result, and one short index. These studies are historical inputs; do not silently update their conclusions.
`);
register(path.join(researchRoot, "baseline/context/README.md"), `# Baseline context

Context and evidence boundaries supplied to the first research cycle. These files explain what the researchers were told; they are not current implementation approval.
`);
register(path.join(researchRoot, "baseline/attachments/README.md"), `# Baseline attachments

The code reference is deterministic internal evidence for the historical baseline research. It is not part of the default implementation-research attachment set.

Regenerate it with \`./scripts/generate-research-code-reference.sh\`.
`);
register(path.join(researchRoot, "baseline/synthesis/README.md"), `# Baseline synthesis

- [Prompt](prompt.md)
- [Result](result-baseline-technical-synthesis.md)

This result is historical. The implementation synthesis is the current research entry point.
`);
register(path.join(researchRoot, "templates/README.md"), `# Research templates

- Copy [the study template](study/) for one bounded research topic.
- Use [the review checklist](review-checklist.md) before accepting a result.

After adding a study, declare it in the relevant suite manifest and generator; do not rely on folder discovery alone.
`);

register(path.join(researchRoot, "README.md"), `# UAM research

This directory contains completed research evidence in a layout designed for people and agents.

## Start here

1. Read the current [implementation synthesis](implementation/synthesis/result-implementation-technical-baseline.md).
2. Open the relevant [implementation batch](implementation/batches/README.md).
3. Open an individual study only for its detailed evidence.
4. Use [the workflow](WORKFLOW.md) when adding or refreshing research.

## Layout

\`\`\`text
research/
├── README.md                 this index
├── WORKFLOW.md               repeatable research lifecycle
├── AGENTS.md                 local safety and maintenance rules
├── manifest.json             machine-readable suite index
├── templates/                new-study and review templates
├── baseline/                 completed first research cycle
│   ├── context/
│   ├── attachments/
│   ├── studies/<study>/      prompt + result + README
│   └── synthesis/            prompt + result
└── implementation/           current implementation research
    ├── context/
    ├── attachments/
    ├── evidence/
    ├── batches/<batch>/
    │   ├── <study>/          prompt + result + README
    │   └── review/           prompt + result + README
    └── synthesis/            prompt + result + README
\`\`\`

## Invariants

- A study keeps its prompt and result together.
- Result filenames are globally unique so they can coexist in a ChatGPT Project.
- Shared context and uploadable attachments are separate.
- A batch review consumes its studies and earlier reviews; the final synthesis consumes batch reviews, not every topic.
- Generated material is changed through its generator and checked in CI.
- Research evidence cannot approve policy, risk, ownership, or production use.
`);

const implementationManifest = JSON.parse(fs.readFileSync(path.join(researchRoot, "implementation/manifest.json"), "utf8"));
const manifestPath = path.join(researchRoot, "manifest.json");
const manifest = {
  schemaVersion: 1,
  suites: [
    {
      id: "baseline",
      status: "complete-historical",
      root: "research/baseline",
      studies: baselineStudies.map(([id, slug]) => ({ id, root: `research/baseline/studies/${pad(id)}-${slug}`, prompt: `research/baseline/studies/${pad(id)}-${slug}/prompt.md`, result: `research/baseline/studies/${pad(id)}-${slug}/result-${pad(id)}-${slug}.md` })),
      synthesis: { prompt: "research/baseline/synthesis/prompt.md", result: "research/baseline/synthesis/result-baseline-technical-synthesis.md" },
    },
    {
      id: "implementation",
      status: implementationManifest.status,
      root: "research/implementation",
      manifest: "research/implementation/manifest.json",
      studyCount: implementationManifest.topicCount,
      reviewCount: implementationManifest.batchCount,
      synthesis: implementationManifest.prompts.find((item) => item.kind === "final-synthesis")?.result,
    },
  ],
  generatedFiles: [...generated.keys(), manifestPath].map(rel).sort(),
};
register(manifestPath, `${JSON.stringify(manifest, null, 2)}\n`);

let failures = 0;
for (const [file, content] of generated) {
  if (checkOnly) {
    if (!fs.existsSync(file) || fs.readFileSync(file, "utf8") !== content) {
      console.error(`Generated file is missing or stale: ${rel(file)}`);
      failures += 1;
    }
  } else {
    fs.mkdirSync(path.dirname(file), { recursive: true });
    fs.writeFileSync(file, content, "utf8");
  }
}
if (failures) process.exitCode = 1;
else console.log(checkOnly ? `All ${generated.size} research index files are current.` : `Generated ${generated.size} research index files.`);
