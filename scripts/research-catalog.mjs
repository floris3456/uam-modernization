import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

export const repoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
export const catalogPath = path.join(repoRoot, "research/catalog.json");

const slugPattern = /^[a-z0-9]+(?:-[a-z0-9]+)*$/;

export function loadResearchCatalog() {
  const catalog = JSON.parse(fs.readFileSync(catalogPath, "utf8"));
  validateResearchCatalog(catalog);
  return catalog;
}

export function validateResearchCatalog(catalog) {
  const errors = [];
  const fail = (message) => errors.push(message);
  if (catalog.schemaVersion !== 1) fail("catalog schemaVersion must be 1");
  if (!Array.isArray(catalog.attachments) || !catalog.attachments.length) fail("catalog attachments must be a non-empty array");
  const implementation = catalog.suites?.implementation;
  const baseline = catalog.suites?.baseline;
  if (!implementation || !baseline) fail("catalog must define baseline and implementation suites");

  const batches = implementation?.batches ?? [];
  const studies = implementation?.studies ?? [];
  for (const field of ["reviewAttachments", "synthesisAttachments"]) {
    if (!Array.isArray(implementation?.[field]) || !implementation[field].length) fail(`implementation ${field} must be a non-empty array`);
    for (const attachment of implementation?.[field] ?? []) if (!catalog.attachments.includes(attachment)) fail(`implementation ${field} uses undeclared attachment ${attachment}`);
  }
  const batchIds = new Set();
  for (const batch of batches) {
    if (!Number.isInteger(batch.id) || batch.id < 1) fail(`invalid batch id: ${batch.id}`);
    if (batchIds.has(batch.id)) fail(`duplicate batch id: ${batch.id}`);
    batchIds.add(batch.id);
    if (!slugPattern.test(batch.slug ?? "")) fail(`invalid batch slug: ${batch.slug}`);
    for (const field of ["title", "timing", "cli", "gate"]) if (!String(batch[field] ?? "").trim()) fail(`batch ${batch.id} lacks ${field}`);
  }

  const studyIds = new Set();
  const studyById = new Map();
  const studySlugs = new Set();
  const requiredArrays = ["attachments", "questions", "deliverables", "human", "cli", "oss"];
  for (const study of studies) {
    if (!Number.isInteger(study.id) || study.id < 1) fail(`invalid study id: ${study.id}`);
    if (studyIds.has(study.id)) fail(`duplicate study id: ${study.id}`);
    studyIds.add(study.id);
    studyById.set(study.id, study);
    if (!batchIds.has(study.batch)) fail(`study ${study.id} references unknown batch ${study.batch}`);
    if (!slugPattern.test(study.slug ?? "")) fail(`invalid study slug: ${study.slug}`);
    if (studySlugs.has(study.slug)) fail(`duplicate study slug: ${study.slug}`);
    studySlugs.add(study.slug);
    if (!["draft", "in-progress", "complete"].includes(study.status ?? "complete")) fail(`study ${study.id} has invalid status ${study.status}`);
    for (const field of ["title", "role", "gate"]) if (!String(study[field] ?? "").trim()) fail(`study ${study.id} lacks ${field}`);
    for (const field of requiredArrays) if (!Array.isArray(study[field]) || !study[field].length) fail(`study ${study.id} requires non-empty ${field}`);
    for (const attachment of study.attachments ?? []) if (!catalog.attachments.includes(attachment)) fail(`study ${study.id} uses undeclared attachment ${attachment}`);
    if (!Array.isArray(study.dependsOn?.batchReviews) || !Array.isArray(study.dependsOn?.topicResults)) fail(`study ${study.id} requires dependsOn.batchReviews and dependsOn.topicResults arrays`);
  }

  for (const study of studies) {
    for (const batchId of study.dependsOn?.batchReviews ?? []) {
      if (!batchIds.has(batchId)) fail(`study ${study.id} depends on unknown batch review ${batchId}`);
      if (batchId >= study.batch) fail(`study ${study.id} may only consume an earlier batch review`);
    }
    for (const dependencyId of study.dependsOn?.topicResults ?? []) {
      const dependency = studyById.get(dependencyId);
      if (!dependency) fail(`study ${study.id} depends on unknown study ${dependencyId}`);
      else if (dependency.batch > study.batch || dependencyId >= study.id) fail(`study ${study.id} must depend only on an earlier topic ID; found ${dependencyId}`);
    }
  }
  for (const batch of batches) if (!studies.some((study) => study.batch === batch.id)) fail(`batch ${batch.id} contains no studies`);

  const baselineIds = new Set();
  for (const study of baseline?.studies ?? []) {
    if (baselineIds.has(study.id)) fail(`duplicate baseline study id: ${study.id}`);
    baselineIds.add(study.id);
    if (!slugPattern.test(study.slug ?? "")) fail(`invalid baseline study slug: ${study.slug}`);
    if (!String(study.title ?? "").trim()) fail(`baseline study ${study.id} lacks title`);
  }

  if (errors.length) throw new Error(`Invalid research/catalog.json:\n- ${errors.join("\n- ")}`);
  return catalog;
}

export function implementationDefinition(catalog = loadResearchCatalog()) {
  return catalog.suites.implementation;
}
