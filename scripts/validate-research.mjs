#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";
import { implementationDefinition, loadResearchCatalog } from "./research-catalog.mjs";

const repoRoot = path.resolve(path.dirname(new URL(import.meta.url).pathname), "..");
const researchRoot = path.join(repoRoot, "research");
const suiteRoot = path.join(researchRoot, "implementation");
const manifestPath = path.join(suiteRoot, "manifest.json");
const failures = [];
const warnings = [];
const requiredSections = [
  "## Expert role",
  "## Result target",
  "## Attachments",
  "### Project-file allowlist",
  "## Accepted baseline",
  "## Provisional matters",
  "## Research questions",
  "## Required web verification",
  "## Open-source reference review",
  "## Required output",
  "## Human decisions",
  "## CLI evidence and experiments",
  "## Evidence labels and conflict handling",
  "## Residual risk",
];
const fail = (message) => failures.push(message);
const catalog = loadResearchCatalog();
const definition = implementationDefinition(catalog);
for (const study of definition.studies) {
  if ((study.status ?? "complete") === "draft") fail(`Study ${study.id} is still draft in research/catalog.json`);
  if (JSON.stringify(study).includes("TODO:")) fail(`Study ${study.id} contains unfinished TODO fields in research/catalog.json`);
}

const repoPath = (relative) => path.join(repoRoot, relative);

if (fs.existsSync(path.join(repoRoot, "research-packs"))) fail("Legacy research-packs directory still exists");
if (!fs.existsSync(path.join(researchRoot, "manifest.json"))) fail("Missing root research manifest");

if (!fs.existsSync(manifestPath)) {
  fail("Missing implementation research manifest");
} else {
  const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf8"));
  const topicPrompts = manifest.prompts.filter((item) => item.kind === "topic");
  const batchReviews = manifest.prompts.filter((item) => item.kind === "batch-review");
  const finalSyntheses = manifest.prompts.filter((item) => item.kind === "final-synthesis");

  if (manifest.topicCount !== definition.studies.length || topicPrompts.length !== definition.studies.length) fail(`Expected ${definition.studies.length} topic prompts; found ${topicPrompts.length}`);
  if (manifest.batchCount !== definition.batches.length || batchReviews.length !== definition.batches.length) fail(`Expected ${definition.batches.length} batch reviews; found ${batchReviews.length}`);
  const expectedPromptCount = definition.studies.length + definition.batches.length + 1;
  if (manifest.promptCount !== expectedPromptCount || manifest.prompts.length !== expectedPromptCount) fail(`Expected ${expectedPromptCount} total prompts; found ${manifest.prompts.length}`);
  if (finalSyntheses.length !== 1) fail(`Expected one final synthesis; found ${finalSyntheses.length}`);

  const topicIds = topicPrompts.map((item) => item.topicId).sort((a, b) => a - b);
  const declaredTopicIds = definition.studies.map((study) => study.id).sort((a, b) => a - b);
  if (topicIds.join(",") !== declaredTopicIds.join(",")) fail("Manifest topic IDs differ from research/catalog.json");

  const allResultTargets = new Set(manifest.prompts.map((item) => item.result));
  const seenQuestionLines = new Map();

  for (const item of manifest.prompts) {
    const promptPath = repoPath(item.prompt);
    const resultPath = repoPath(item.result);
    if (!fs.existsSync(promptPath)) {
      fail(`Missing prompt: ${item.prompt}`);
      continue;
    }
    if (!fs.existsSync(resultPath)) fail(`Missing result target: ${item.result}`);
    else if (fs.statSync(resultPath).size < 100) fail(`Result is empty or too small: ${item.result}`);
    const content = fs.readFileSync(promptPath, "utf8");
    for (const section of requiredSections) {
      if (!content.includes(section)) fail(`${item.prompt} lacks required section: ${section}`);
    }
    if (!content.includes("Do not open, search, quote, summarize, or use any other Project file")) {
      fail(`${item.prompt} does not enforce its Project-file allowlist`);
    }
    const allowlistBlock = content.split("### Project-file allowlist")[1]?.split("Do not open, search, quote, summarize, or use any other Project file")[0] ?? "";
    const actualAllowedFiles = [...allowlistBlock.matchAll(/`([^`/]+\.md)`/g)].map((match) => match[1]).sort();
    const expectedAllowedFiles = [
      ...(item.attachments ?? []).map((file) => path.basename(file)),
      ...(item.consumes ?? []).map((file) => path.basename(file)),
    ].sort();
    if (actualAllowedFiles.join("|") !== expectedAllowedFiles.join("|")) {
      fail(`${item.prompt} Project-file allowlist differs from its manifest inputs`);
    }
    const resultRelativeToSuite = path.relative(suiteRoot, resultPath).split(path.sep).join("/");
    if (!content.includes(`\`${resultRelativeToSuite}\``)) fail(`${item.prompt} does not state its exact result target ${resultRelativeToSuite}`);
    for (const attachment of item.attachments ?? []) {
      const attachmentPath = repoPath(attachment);
      if (!fs.existsSync(attachmentPath)) fail(`${item.prompt} references missing attachment: ${attachment}`);
      if (!content.includes(path.basename(attachment))) fail(`${item.prompt} does not name manifest attachment: ${path.basename(attachment)}`);
    }
    for (const consumed of item.consumes ?? []) {
      if (!allResultTargets.has(consumed)) fail(`${item.prompt} consumes unknown result: ${consumed}`);
      const consumedRelative = path.relative(suiteRoot, repoPath(consumed)).split(path.sep).join("/");
      if (!content.includes(`\`${path.basename(consumedRelative)}\``)) fail(`${item.prompt} does not name consumed result: ${consumedRelative}`);
    }
    if (item.kind === "topic") {
      const research = content.split("## Research questions")[1]?.split("## Constraints")[0] ?? "";
      for (const line of research.split("\n").filter((line) => /^\d+\. /.test(line))) {
        const normalized = line.replace(/^\d+\. /, "").trim().toLocaleLowerCase("en");
        if (seenQuestionLines.has(normalized)) fail(`Exact repeated research question in ${item.prompt} and ${seenQuestionLines.get(normalized)}`);
        seenQuestionLines.set(normalized, item.prompt);
      }
    }
  }

  for (const batchReview of batchReviews) {
    const expected = [
      ...topicPrompts.filter((item) => item.batchId === batchReview.batchId).map((item) => item.result),
      ...batchReviews.filter((item) => item.batchId < batchReview.batchId).map((item) => item.result),
    ].sort();
    const actual = [...(batchReview.consumes ?? [])].sort();
    if (expected.join("|") !== actual.join("|")) fail(`Batch ${batchReview.batchId} reviewer does not consume its topic results and all predecessor reviews`);
  }

  for (const topicPrompt of topicPrompts) {
    const study = definition.studies.find((item) => item.id === topicPrompt.topicId);
    if (!study) {
      fail(`Topic ${topicPrompt.topicId} is absent from research/catalog.json`);
      continue;
    }
    const expected = [
      ...study.dependsOn.batchReviews.map((batchId) => batchReviews.find((item) => item.batchId === batchId)?.result),
      ...study.dependsOn.topicResults.map((topicId) => topicPrompts.find((item) => item.topicId === topicId)?.result),
    ].filter(Boolean).sort();
    const actual = [...(topicPrompt.consumes ?? [])].sort();
    if (expected.join("|") !== actual.join("|")) fail(`Topic ${topicPrompt.topicId} dependencies differ from research/catalog.json`);
  }

  if (finalSyntheses.length === 1) {
    const expected = batchReviews.map((item) => item.result).sort();
    const actual = [...(finalSyntheses[0].consumes ?? [])].sort();
    if (expected.join("|") !== actual.join("|")) fail("Final synthesis does not consume all and only the declared batch-review results");
  }

  for (const generatedFile of manifest.generatedFiles) {
    if (!fs.existsSync(repoPath(generatedFile))) fail(`Manifest generated file missing: ${generatedFile}`);
  }
}

function walk(directory) {
  const files = [];
  for (const entry of fs.readdirSync(directory, { withFileTypes: true })) {
    const fullPath = path.join(directory, entry.name);
    if (entry.isDirectory()) files.push(...walk(fullPath));
    else files.push(fullPath);
  }
  return files;
}

const researchFiles = fs.existsSync(researchRoot) ? walk(researchRoot) : [];
const textFiles = researchFiles.filter((file) => /\.(?:md|json|yml|yaml|txt)$/i.test(file));
for (const file of researchFiles) {
  const relative = rel(file);
  if (/\s|\(\d+\)/.test(relative)) fail(`Research path is not canonical: ${relative}`);
}
const forbiddenContent = [
  [/BEGIN (?:RSA|OPENSSH|EC|DSA) PRIVATE KEY/, "private key material"],
  [/\b(?:github_pat_|ghp_)[A-Za-z0-9_]{16,}/, "GitHub token"],
  [/\b(?:password|passwd|secret|token)\s*[:=]\s*["'][^<\n"']{6,}["']/i, "obvious credential literal"],
  [/\b(?:10(?:\.\d{1,3}){3}|192\.168(?:\.\d{1,3}){2}|172\.(?:1[6-9]|2\d|3[01])(?:\.\d{1,3}){2})\b/, "private IPv4 address"],
  [/https?:\/\/[^\s`)<>]*(?:\.internal|\.local|\.lan)(?=[\s/:`)<>]|$)/i, "internal URL"],
];

for (const file of textFiles) {
  const content = fs.readFileSync(file, "utf8");
  for (const [pattern, label] of forbiddenContent) {
    const matches = [...content.matchAll(new RegExp(pattern.source, pattern.flags.includes("g") ? pattern.flags : `${pattern.flags}g`))];
    if (!matches.length) continue;
    const isResearchResult = /\/result-[^/]+\.md$/.test(file);
    if (label === "GitHub token" && isResearchResult) {
      const allDeclaredInvalidCanaries = matches.every((match) => {
        const context = content.slice(Math.max(0, match.index - 200), Math.min(content.length, match.index + match[0].length + 200));
        return context.includes("secret-shaped-invalid") && context.includes("canaryId");
      });
      if (allDeclaredInvalidCanaries) continue;
    }
    fail(`${rel(file)} contains ${label}`);
  }
  if (path.basename(file) !== "code-reference.md") {
    const staleReferences = [
      /research-packs/,
      /results\/(?:batch|final-synthesis)/,
      /\b\d{2}-[a-z0-9-]+-result\.md\b/,
      /\bbatch-\d{2}-review-result\.md\b/,
      /UAM-CODE-REFERENCE\.md/,
    ];
    for (const pattern of staleReferences) if (pattern.test(content)) fail(`${rel(file)} contains a stale research-layout reference`);
  }
}

const attachmentDir = path.join(suiteRoot, "attachments");
for (const file of fs.existsSync(attachmentDir) ? walk(attachmentDir) : []) {
  if (path.basename(file) === "README.md") continue;
  const content = fs.readFileSync(file, "utf8");
  if (!content.includes("**Classification:**")) fail(`${rel(file)} does not state its classification`);
  if (!content.includes("**Source:**")) fail(`${rel(file)} does not state its source`);
  if (!content.includes("**Generation:**")) fail(`${rel(file)} does not state its generation method`);
  if (!/(?:limitation|evidence limit|missing evidence)/i.test(content)) fail(`${rel(file)} does not explain its limitations`);
  const ipv4 = content.match(/\b(?:\d{1,3}\.){3}\d{1,3}\b/g) ?? [];
  if (ipv4.length) fail(`${rel(file)} contains an IPv4 literal`);
  if (content.length > 30_000) warnings.push(`${rel(file)} is larger than 30 KB and may be unfocused`);
}

const catalogueProfilePath = path.join(suiteRoot, "evidence/application-catalogue-profile.json");
if (!fs.existsSync(catalogueProfilePath)) {
  fail("Missing sanitized application-catalogue profile");
} else {
  const catalogueProfile = JSON.parse(fs.readFileSync(catalogueProfilePath, "utf8"));
  const safety = catalogueProfile.safety ?? {};
  for (const field of ["rawNamesIncluded", "rawExternalIdsIncluded", "internalAddressesIncluded", "personalDataIncluded"]) {
    if (safety[field] !== false) fail(`Application-catalogue profile safety field ${field} must be false`);
  }
}

for (const file of textFiles.filter((item) => item.endsWith(".md") && !/\/result-[^/]+\.md$/.test(item) && path.basename(item) !== "code-reference.md")) {
  const content = fs.readFileSync(file, "utf8");
  const linkPattern = /\[[^\]]*\]\(([^)]+)\)/g;
  for (const match of content.matchAll(linkPattern)) {
    const target = match[1].trim().replace(/^<|>$/g, "");
    if (/^(?:https?:|mailto:|#)/i.test(target)) continue;
    const targetPath = path.resolve(path.dirname(file), target.split("#")[0]);
    if (!fs.existsSync(targetPath)) fail(`${rel(file)} has unresolved Markdown link: ${target}`);
  }
}

const resultFiles = researchFiles.filter((file) => /\/result-[^/]+\.md$/.test(file));
const resultNames = resultFiles.map((file) => path.basename(file));
if (new Set(resultNames).size !== resultNames.length) fail("Research result basenames are not globally unique");
if (researchFiles.some((file) => path.basename(file) === "02_legacy_uam_reference_data.sql")) fail("Research tree contains confidential reference-data SQL");

const forbiddenDirectories = [
  path.join(suiteRoot, "results"),
  path.join(suiteRoot, "execution-waves"),
  path.join(suiteRoot, "final-synthesis"),
];
for (const directory of forbiddenDirectories) if (fs.existsSync(directory)) fail(`Obsolete research directory exists: ${rel(directory)}`);

const baselineStudies = fs.existsSync(path.join(researchRoot, "baseline/studies"))
  ? fs.readdirSync(path.join(researchRoot, "baseline/studies"), { withFileTypes: true }).filter((entry) => entry.isDirectory())
  : [];
if (baselineStudies.length !== catalog.suites.baseline.studies.length) fail(`Expected ${catalog.suites.baseline.studies.length} baseline study directories; found ${baselineStudies.length}`);
for (const entry of baselineStudies) {
  const directory = path.join(researchRoot, "baseline/studies", entry.name);
  const expected = ["README.md", "prompt.md", `result-${entry.name}.md`];
  for (const name of expected) if (!fs.existsSync(path.join(directory, name))) fail(`${rel(directory)} lacks ${name}`);
}

const topicPromptsOnDisk = researchFiles.filter((file) => /\/implementation\/batches\/\d{2}-[^/]+\/\d{2}-[^/]+\/prompt\.md$/.test(file));
if (topicPromptsOnDisk.length !== definition.studies.length) fail(`Expected ${definition.studies.length} colocated implementation topic prompts; found ${topicPromptsOnDisk.length}`);
for (const prompt of topicPromptsOnDisk) {
  const directory = path.dirname(prompt);
  const slug = path.basename(directory);
  if (!fs.existsSync(path.join(directory, "README.md"))) fail(`${rel(directory)} lacks README.md`);
  if (!fs.existsSync(path.join(directory, `result-${slug}.md`))) fail(`${rel(directory)} lacks colocated result-${slug}.md`);
}

function directories(directory) {
  return [directory, ...fs.readdirSync(directory, { withFileTypes: true }).filter((entry) => entry.isDirectory()).flatMap((entry) => directories(path.join(directory, entry.name)))];
}
for (const directory of directories(researchRoot)) {
  if (!fs.existsSync(path.join(directory, "README.md"))) fail(`Research directory lacks README.md: ${rel(directory)}`);
  if (/^batch-/.test(path.basename(directory))) fail(`Batch directory repeats its parent name: ${rel(directory)}`);
}

if (researchFiles.some((file) => rel(file).includes("/.ssh/") || path.basename(file).startsWith("id_"))) fail("Research tree contains SSH material");

if (failures.length) {
  console.error(`Research validation failed (${failures.length}):`);
  for (const failure of failures) console.error(`- ${failure}`);
  process.exitCode = 1;
} else {
  const totalStudies = catalog.suites.baseline.studies.length + definition.studies.length;
  console.log(`Research validation passed: ${researchFiles.length} files, 2 suites, ${totalStudies} studies, ${definition.batches.length} batch reviews, and 2 syntheses.`);
}
for (const warning of warnings) console.warn(`Warning: ${warning}`);

function rel(filePath) {
  return path.relative(repoRoot, filePath).split(path.sep).join("/");
}
