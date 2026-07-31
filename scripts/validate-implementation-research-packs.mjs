#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";

const repoRoot = path.resolve(path.dirname(new URL(import.meta.url).pathname), "..");
const packageRoot = path.join(repoRoot, "research-packs/implementation");
const manifestPath = path.join(packageRoot, "manifest.json");
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
const topicDependencyPlan = new Map([
  ...[1, 2, 3, 4, 5, 6].map((id) => [id, { batchReviews: [], topicResults: [] }]),
  ...[7, 8].map((id) => [id, { batchReviews: [1], topicResults: [] }]),
  ...[9, 10, 14].map((id) => [id, { batchReviews: [1, 2], topicResults: [] }]),
  ...[11, 12, 13].map((id) => [id, { batchReviews: [1], topicResults: [] }]),
  ...[15, 16, 17, 18].map((id) => [id, { batchReviews: [1, 2, 3], topicResults: [] }]),
  ...[19, 20, 21].map((id) => [id, { batchReviews: [1, 2, 3, 4], topicResults: [] }]),
  [22, { batchReviews: [1], topicResults: [] }],
  [23, { batchReviews: [1, 2, 3, 4], topicResults: [22] }],
  [24, { batchReviews: [1, 2, 3, 4, 5], topicResults: [22, 23] }],
]);

const fail = (message) => failures.push(message);
const repoPath = (relative) => path.join(repoRoot, relative);

if (!fs.existsSync(manifestPath)) {
  fail("Missing implementation research manifest");
} else {
  const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf8"));
  const topicPrompts = manifest.prompts.filter((item) => item.kind === "topic");
  const batchReviews = manifest.prompts.filter((item) => item.kind === "batch-review");
  const finalSyntheses = manifest.prompts.filter((item) => item.kind === "final-synthesis");

  if (manifest.topicCount !== 24 || topicPrompts.length !== 24) fail(`Expected 24 topic prompts; found ${topicPrompts.length}`);
  if (manifest.batchCount !== 6 || batchReviews.length !== 6) fail(`Expected 6 batch reviews; found ${batchReviews.length}`);
  if (manifest.promptCount !== 31 || manifest.prompts.length !== 31) fail(`Expected 31 total prompts; found ${manifest.prompts.length}`);
  if (finalSyntheses.length !== 1) fail(`Expected one final synthesis; found ${finalSyntheses.length}`);

  const topicIds = topicPrompts.map((item) => item.topicId).sort((a, b) => a - b);
  if (topicIds.join(",") !== Array.from({ length: 24 }, (_, index) => index + 1).join(",")) fail("Topic IDs are not exactly 1 through 24");

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
    const resultRelativeToPackage = path.relative(packageRoot, resultPath).split(path.sep).join("/");
    if (!content.includes(`\`${resultRelativeToPackage}\``)) fail(`${item.prompt} does not state its exact result target ${resultRelativeToPackage}`);
    for (const attachment of item.attachments ?? []) {
      const attachmentPath = repoPath(attachment);
      if (!fs.existsSync(attachmentPath)) fail(`${item.prompt} references missing attachment: ${attachment}`);
      if (!content.includes(path.basename(attachment))) fail(`${item.prompt} does not name manifest attachment: ${path.basename(attachment)}`);
    }
    for (const consumed of item.consumes ?? []) {
      if (!allResultTargets.has(consumed)) fail(`${item.prompt} consumes unknown result: ${consumed}`);
      const consumedRelative = path.relative(packageRoot, repoPath(consumed)).split(path.sep).join("/");
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
    const dependency = topicDependencyPlan.get(topicPrompt.topicId);
    if (!dependency) {
      fail(`Topic ${topicPrompt.topicId} has no optimized dependency plan`);
      continue;
    }
    const expected = [
      ...dependency.batchReviews.map((batchId) => batchReviews.find((item) => item.batchId === batchId)?.result),
      ...dependency.topicResults.map((topicId) => topicPrompts.find((item) => item.topicId === topicId)?.result),
    ].filter(Boolean).sort();
    const actual = [...(topicPrompt.consumes ?? [])].sort();
    if (expected.join("|") !== actual.join("|")) fail(`Topic ${topicPrompt.topicId} does not match the optimized dependency plan`);
  }

  if (finalSyntheses.length === 1) {
    const expected = batchReviews.map((item) => item.result).sort();
    const actual = [...(finalSyntheses[0].consumes ?? [])].sort();
    if (expected.join("|") !== actual.join("|")) fail("Final synthesis does not consume all and only the six batch-review results");
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

const packageFiles = fs.existsSync(packageRoot) ? walk(packageRoot) : [];
const textFiles = packageFiles.filter((file) => /\.(?:md|json|yml|yaml|txt)$/i.test(file));
const forbiddenContent = [
  [/BEGIN (?:RSA|OPENSSH|EC|DSA) PRIVATE KEY/, "private key material"],
  [/\b(?:github_pat_|ghp_)[A-Za-z0-9_]{16,}/, "GitHub token"],
  [/\b(?:password|passwd|secret|token)\s*[:=]\s*["'][^<\n"']{6,}["']/i, "obvious credential literal"],
  [/02_legacy_uam_reference_data\.sql/i, "confidential reference-data SQL filename"],
];

for (const file of textFiles) {
  const content = fs.readFileSync(file, "utf8");
  for (const [pattern, label] of forbiddenContent) {
    const matches = [...content.matchAll(new RegExp(pattern.source, pattern.flags.includes("g") ? pattern.flags : `${pattern.flags}g`))];
    if (!matches.length) continue;
    const isResearchResult = rel(file).startsWith("research-packs/implementation/results/");
    if (label === "GitHub token" && isResearchResult) {
      const allDeclaredInvalidCanaries = matches.every((match) => {
        const context = content.slice(Math.max(0, match.index - 200), Math.min(content.length, match.index + match[0].length + 200));
        return context.includes("secret-shaped-invalid") && context.includes("canaryId");
      });
      if (allDeclaredInvalidCanaries) continue;
    }
    fail(`${rel(file)} contains ${label}`);
  }
}

const attachmentDir = path.join(packageRoot, "attachments");
for (const file of fs.existsSync(attachmentDir) ? walk(attachmentDir) : []) {
  const content = fs.readFileSync(file, "utf8");
  if (!content.includes("**Classification:**")) fail(`${rel(file)} does not state its classification`);
  if (!content.includes("**Source:**")) fail(`${rel(file)} does not state its source`);
  if (!content.includes("**Generation:**")) fail(`${rel(file)} does not state its generation method`);
  if (!/(?:limitation|evidence limit|missing evidence)/i.test(content)) fail(`${rel(file)} does not explain its limitations`);
  const ipv4 = content.match(/\b(?:\d{1,3}\.){3}\d{1,3}\b/g) ?? [];
  if (ipv4.length) fail(`${rel(file)} contains an IPv4 literal`);
  if (content.length > 30_000) warnings.push(`${rel(file)} is larger than 30 KB and may be unfocused`);
}

const catalogueProfilePath = path.join(packageRoot, "source-profiles/application-catalogue-profile.json");
if (!fs.existsSync(catalogueProfilePath)) {
  fail("Missing sanitized application-catalogue profile");
} else {
  const catalogueProfile = JSON.parse(fs.readFileSync(catalogueProfilePath, "utf8"));
  const safety = catalogueProfile.safety ?? {};
  for (const field of ["rawNamesIncluded", "rawExternalIdsIncluded", "internalAddressesIncluded", "personalDataIncluded"]) {
    if (safety[field] !== false) fail(`Application-catalogue profile safety field ${field} must be false`);
  }
}

for (const file of textFiles.filter((item) => item.endsWith(".md") && !rel(item).startsWith("research-packs/implementation/results/"))) {
  const content = fs.readFileSync(file, "utf8");
  const linkPattern = /\[[^\]]*\]\(([^)]+)\)/g;
  for (const match of content.matchAll(linkPattern)) {
    const target = match[1].trim().replace(/^<|>$/g, "");
    if (/^(?:https?:|mailto:|#)/i.test(target)) continue;
    const targetPath = path.resolve(path.dirname(file), target.split("#")[0]);
    if (!fs.existsSync(targetPath)) fail(`${rel(file)} has unresolved Markdown link: ${target}`);
  }
}

const implementationRelative = path.relative(repoRoot, packageRoot).split(path.sep).join("/");
if (packageFiles.some((file) => rel(file).includes("/.ssh/") || path.basename(file).startsWith("id_"))) fail(`${implementationRelative} contains SSH material`);

if (failures.length) {
  console.error(`Implementation research validation failed (${failures.length}):`);
  for (const failure of failures) console.error(`- ${failure}`);
  process.exitCode = 1;
} else {
  console.log(`Implementation research validation passed: ${packageFiles.length} files, 24 topics, 6 batch reviews, 1 final synthesis.`);
}
for (const warning of warnings) console.warn(`Warning: ${warning}`);

function rel(filePath) {
  return path.relative(repoRoot, filePath).split(path.sep).join("/");
}
