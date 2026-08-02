#!/usr/bin/env node
import crypto from "node:crypto";
import fs from "node:fs";
import path from "node:path";

const repoRoot = path.resolve(path.dirname(new URL(import.meta.url).pathname), "..");
const researchManifest = JSON.parse(fs.readFileSync(path.join(repoRoot, "research/manifest.json"), "utf8"));
const implementationManifest = JSON.parse(fs.readFileSync(path.join(repoRoot, "research/implementation/manifest.json"), "utf8"));
const outputPath = path.join(repoRoot, "evidence/manifests/research-evidence.json");
const checkOnly = process.argv.includes("--check");
const baselineSuite = researchManifest.suites.find((suite) => suite.id === "baseline");
const resultEntries = [
  ...baselineSuite.studies.map((study) => ({ kind: "baseline-topic", topicId: study.id, batchId: null, path: study.result })),
  { kind: "baseline-synthesis", topicId: null, batchId: null, path: baselineSuite.synthesis.result },
  ...implementationManifest.prompts.map((prompt) => ({ kind: prompt.kind, topicId: prompt.topicId ?? null, batchId: prompt.batchId ?? null, path: prompt.result })),
];
const results = resultEntries.flatMap((entry) => {
  const fullPath = path.join(repoRoot, entry.path);
  if (!fs.existsSync(fullPath)) throw new Error(`Missing research result: ${entry.path}`);
  const bytes = fs.readFileSync(fullPath);
  if (bytes.length < 100) return [];
  return [{ ...entry, byteCount: bytes.length, sha256: crypto.createHash("sha256").update(bytes).digest("hex") }];
});
const manifest = {
  schemaVersion: 2,
  classification: "Internal research evidence manifest; contains paths, sizes, and hashes but no research content",
  generation: "node scripts/generate-research-evidence-manifest.mjs",
  sourceManifests: ["research/manifest.json", "research/implementation/manifest.json"],
  canonicalBatch4Review: "research/implementation/batches/04-server-platform/review/result-review-04-server-platform.md",
  resultCount: results.length,
  results,
  limitations: ["Only populated results of at least 100 bytes are recorded; structural validation separately rejects missing required evidence.", "A hash proves file identity, not correctness or human acceptance.", "Research conclusions remain subject to experiments, gates, and current primary-source verification."],
};
const content = `${JSON.stringify(manifest, null, 2)}\n`;
if (checkOnly) {
  if (!fs.existsSync(outputPath) || fs.readFileSync(outputPath, "utf8") !== content) throw new Error("Research baseline manifest is stale");
  console.log("Research evidence manifest is current.");
} else {
  fs.mkdirSync(path.dirname(outputPath), { recursive: true });
  fs.writeFileSync(outputPath, content, "utf8");
  console.log(`Recorded ${results.length} populated research results.`);
}
