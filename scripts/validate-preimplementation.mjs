#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";
import { spawnSync } from "node:child_process";

const root = path.resolve(path.dirname(new URL(import.meta.url).pathname), "..");
const failures = [];
const required = [
  "AGENTS.md", "CONTRIBUTING.md", ".github/copilot-instructions.md", ".github/pull_request_template.md",
  "docs/plain-language/00-what-we-are-building.md", "docs/plain-language/01-current-next-later.md",
  "docs/architecture/repository-layout.md", "docs/architecture/source-register.md", "docs/governance/ownership.md",
  "docs/milestones/G0-fictional-evidence-foundation.md", "docs/work/README.md",
  "docs/work/current/G0-001-foundation-decisions.md", "evidence/sanitized/application-catalogue-profile.json",
  "evidence/sanitized/application-catalogue-summary.md", "evidence/manifests/research-evidence.json",
  "research/implementation/batches/04-server-platform/review/result-review-04-server-platform.md",
];
for (const file of required) if (!fs.existsSync(path.join(root, file))) failures.push(`Missing ${file}`);
if (fs.existsSync(path.join(root, "research-packs"))) failures.push("Legacy research-packs directory exists");

const generatedChecks = [
  ["scripts/generate-implementation-research.mjs", ["--check"]],
  ["scripts/generate-research-index.mjs", ["--check"]],
  ["scripts/generate-research-evidence-manifest.mjs", ["--check"]],
];
if (fs.existsSync(path.join(root, "applicaties_alle_zichtbare_informatie.csv"))) {
  generatedChecks.unshift(["scripts/profile-detailed-application-catalogue.mjs", ["--check"]]);
} else {
  console.log("Notice: raw detailed catalogue is absent; validating its committed sanitized profile without regeneration.");
}
for (const [script, args] of generatedChecks) {
  const result = spawnSync(process.execPath, [path.join(root, script), ...args], { cwd: root, encoding: "utf8" });
  if (result.status !== 0) failures.push(`${script} failed: ${(result.stderr || result.stdout).trim()}`);
}

const ignored = spawnSync("git", ["check-ignore", "-q", "applicaties_alle_zichtbare_informatie.csv"], { cwd: root });
if (ignored.status !== 0) failures.push("Detailed raw catalogue is not ignored");

const profilePath = path.join(root, "evidence/sanitized/application-catalogue-profile.json");
if (fs.existsSync(profilePath)) {
  const profile = JSON.parse(fs.readFileSync(profilePath, "utf8"));
  for (const field of ["rawRowsIncluded", "rawApplicationNamesIncluded", "rawExternalIdsIncluded", "addressesIncluded", "urlsIncluded", "personalDataIncluded"]) {
    if (profile.safety?.[field] !== false) failures.push(`Catalogue safety field must be false: ${field}`);
  }
}

const markdownRoots = ["README.md", "AGENTS.md", "CONTRIBUTING.md", "docs", "contracts", "src", "tests", "tools", "evidence"];
function walk(target) {
  const stat = fs.statSync(target);
  if (stat.isFile()) return [target];
  return fs.readdirSync(target, { withFileTypes: true }).flatMap((entry) => walk(path.join(target, entry.name)));
}
for (const relative of markdownRoots) {
  const start = path.join(root, relative);
  for (const file of walk(start).filter((item) => item.endsWith(".md"))) {
    const content = fs.readFileSync(file, "utf8");
    for (const match of content.matchAll(/\[[^\]]*\]\(([^)]+)\)/g)) {
      const target = match[1].trim().replace(/^<|>$/g, "").split("#")[0];
      if (!target || /^(?:https?:|mailto:)/i.test(target)) continue;
      if (!fs.existsSync(path.resolve(path.dirname(file), target))) failures.push(`${path.relative(root, file)} has unresolved link: ${target}`);
    }
  }
}

const workflows = walk(path.join(root, ".github/workflows")).filter((file) => /\.ya?ml$/.test(file));
for (const file of workflows) {
  const content = fs.readFileSync(file, "utf8");
  for (const match of content.matchAll(/^\s*uses:\s*([^\s#]+)(?:\s*#.*)?$/gm)) {
    const reference = match[1];
    if (reference.startsWith("./") || /@[0-9a-f]{40}$/.test(reference)) continue;
    failures.push(`${path.relative(root, file)} has a mutable action reference: ${reference}`);
  }
}

if (failures.length) {
  console.error(`Pre-implementation validation failed (${failures.length}):`);
  for (const failure of failures) console.error(`- ${failure}`);
  process.exit(1);
}
console.log("Pre-implementation validation passed: structure, links, evidence, generators, confidentiality, and action pins.");
