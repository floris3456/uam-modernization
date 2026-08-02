#!/usr/bin/env node
import fs from "node:fs";
import { spawnSync } from "node:child_process";
import { catalogPath, loadResearchCatalog, repoRoot, validateResearchCatalog } from "./research-catalog.mjs";

const [command = "help", ...args] = process.argv.slice(2);
const scripts = {
  generate: [
    ["scripts/generate-implementation-research.mjs"],
    ["scripts/generate-research-index.mjs"],
    ["scripts/generate-research-evidence-manifest.mjs"],
  ],
  check: [
    ["scripts/generate-implementation-research.mjs", "--check"],
    ["scripts/generate-research-index.mjs", "--check"],
    ["scripts/generate-research-evidence-manifest.mjs", "--check"],
    ["scripts/validate-research.mjs"],
  ],
};

function run(commandArgs) {
  const result = spawnSync(process.execPath, commandArgs, { cwd: repoRoot, stdio: "inherit" });
  if (result.status !== 0) process.exit(result.status ?? 1);
}

function runAll(commands) {
  for (const commandArgs of commands) run(commandArgs);
}

function option(name, fallback = undefined) {
  const index = args.indexOf(`--${name}`);
  return index === -1 ? fallback : args[index + 1];
}

function ids(value) {
  if (!value) return [];
  return value.split(",").filter(Boolean).map((item) => Number.parseInt(item, 10));
}

function titleFromSlug(slug) {
  return slug.split("-").map((part) => part[0].toUpperCase() + part.slice(1)).join(" ");
}

function printHelp() {
  console.log(`Research workflow CLI

Usage:
  node scripts/research.mjs list
  node scripts/research.mjs next
  node scripts/research.mjs add --batch <id> --slug <slug> --title <title> --role <expert role> [--reviews 1,2] [--topics 3,4]
  node scripts/research.mjs generate
  node scripts/research.mjs check
  node scripts/research.mjs validate

The catalogue at research/catalog.json is the only place to define batches, studies, attachments, and dependencies. Generated prompts, indexes, allowlists, and manifests must not be edited directly.`);
}

if (command === "help" || command === "--help" || command === "-h") {
  printHelp();
} else if (command === "list") {
  const { suites: { implementation } } = loadResearchCatalog();
  for (const batch of implementation.batches) {
    console.log(`${String(batch.id).padStart(2, "0")} ${batch.title}`);
    for (const study of implementation.studies.filter((item) => item.batch === batch.id)) console.log(`   ${String(study.id).padStart(2, "0")} ${study.slug} [${study.status ?? "complete"}]`);
  }
} else if (command === "next") {
  const studies = loadResearchCatalog().suites.implementation.studies;
  console.log(Math.max(0, ...studies.map((study) => study.id)) + 1);
} else if (command === "add") {
  const catalog = loadResearchCatalog();
  const implementation = catalog.suites.implementation;
  const batch = Number.parseInt(option("batch"), 10);
  const slug = option("slug");
  const title = option("title", slug ? titleFromSlug(slug) : undefined);
  const role = option("role", "research expert for this decision area");
  if (!Number.isInteger(batch) || !implementation.batches.some((item) => item.id === batch)) throw new Error("--batch must identify an existing batch");
  if (!slug || !/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(slug)) throw new Error("--slug must be lowercase words separated by hyphens");
  if (implementation.studies.some((item) => item.slug === slug)) throw new Error(`study slug already exists: ${slug}`);
  const id = Math.max(0, ...implementation.studies.map((study) => study.id)) + 1;
  implementation.status = "in-progress";
  implementation.studies.push({
    id, batch, slug, title, role, status: "draft",
    attachments: ["accepted-baseline.md", "evidence-rules.md"],
    questions: ["TODO: replace with exact decision-driving research questions."],
    deliverables: ["TODO: replace with implementation-ready mandatory artifacts."],
    human: ["TODO: state decisions the researcher must leave to accountable humans."],
    cli: ["TODO: state claims that require a falsifying prototype or measurement."],
    gate: "TODO: define the exact stop/go gate.",
    oss: ["relevant maintained open-source implementations"],
    dependsOn: { batchReviews: ids(option("reviews")), topicResults: ids(option("topics")) },
  });
  validateResearchCatalog(catalog);
  fs.writeFileSync(catalogPath, `${JSON.stringify(catalog, null, 2)}\n`, "utf8");
  runAll(scripts.generate);
  console.log(`Added draft study ${String(id).padStart(2, "0")}-${slug}. Replace every TODO in research/catalog.json, set status, then run validate.`);
} else if (command === "generate") {
  loadResearchCatalog();
  runAll(scripts.generate);
} else if (command === "check") {
  loadResearchCatalog();
  runAll(scripts.check);
} else if (command === "validate") {
  loadResearchCatalog();
  const result = spawnSync("./scripts/validate-repository.sh", [], { cwd: repoRoot, stdio: "inherit" });
  process.exit(result.status ?? 1);
} else {
  printHelp();
  process.exitCode = 1;
}
