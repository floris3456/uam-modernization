#!/usr/bin/env node
import crypto from "node:crypto";
import fs from "node:fs";
import path from "node:path";

const repoRoot = path.resolve(path.dirname(new URL(import.meta.url).pathname), "..");
const packageManifest = JSON.parse(fs.readFileSync(path.join(repoRoot, "research-packs/implementation/manifest.json"), "utf8"));
const outputPath = path.join(repoRoot, "evidence/manifests/research-baseline.json");
const checkOnly = process.argv.includes("--check");
const results = packageManifest.prompts.map((prompt) => {
  const fullPath = path.join(repoRoot, prompt.result);
  if (!fs.existsSync(fullPath)) throw new Error(`Missing research result: ${prompt.result}`);
  const bytes = fs.readFileSync(fullPath);
  if (bytes.length < 100) throw new Error(`Research result is empty or too small: ${prompt.result}`);
  return { kind: prompt.kind, topicId: prompt.topicId ?? null, batchId: prompt.batchId ?? null, path: prompt.result, byteCount: bytes.length, sha256: crypto.createHash("sha256").update(bytes).digest("hex") };
});
const manifest = {
  schemaVersion: 1,
  classification: "Internal research evidence manifest; contains paths, sizes, and hashes but no research content",
  generation: "node scripts/generate-research-baseline-manifest.mjs",
  sourceManifest: "research-packs/implementation/manifest.json",
  canonicalBatch4Review: "research-packs/implementation/results/batch-04-server-platform/batch-04-review-result.md",
  resultCount: results.length,
  results,
  limitations: ["A hash proves file identity, not correctness or human acceptance.", "Research conclusions remain subject to experiments, gates, and current primary-source verification."],
};
const content = `${JSON.stringify(manifest, null, 2)}\n`;
if (checkOnly) {
  if (!fs.existsSync(outputPath) || fs.readFileSync(outputPath, "utf8") !== content) throw new Error("Research baseline manifest is stale");
  console.log("Research baseline manifest is current.");
} else {
  fs.mkdirSync(path.dirname(outputPath), { recursive: true });
  fs.writeFileSync(outputPath, content, "utf8");
  console.log(`Recorded ${results.length} populated research results.`);
}
