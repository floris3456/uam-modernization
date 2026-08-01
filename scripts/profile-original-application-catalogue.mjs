#!/usr/bin/env node
import crypto from "node:crypto";
import fs from "node:fs";
import path from "node:path";

const repoRoot = path.resolve(path.dirname(new URL(import.meta.url).pathname), "..");
const inputPath = process.argv[2] ? path.resolve(process.argv[2]) : path.join(repoRoot, "applicaties_transcriptie.csv");
const outputPath = process.argv[3]
  ? path.resolve(process.argv[3])
  : path.join(repoRoot, "research/implementation/evidence/application-catalogue-profile.json");

function parseCsv(text) {
  const rows = [];
  let row = [];
  let value = "";
  let quoted = false;
  for (let index = 0; index < text.length; index += 1) {
    const char = text[index];
    if (quoted) {
      if (char === '"' && text[index + 1] === '"') {
        value += '"';
        index += 1;
      } else if (char === '"') {
        quoted = false;
      } else {
        value += char;
      }
    } else if (char === '"') {
      quoted = true;
    } else if (char === ",") {
      row.push(value);
      value = "";
    } else if (char === "\n") {
      row.push(value.replace(/\r$/, ""));
      rows.push(row);
      row = [];
      value = "";
    } else {
      value += char;
    }
  }
  if (value.length || row.length) {
    row.push(value.replace(/\r$/, ""));
    rows.push(row);
  }
  return rows;
}

if (!fs.existsSync(inputPath)) {
  throw new Error(`Application catalogue not found: ${inputPath}`);
}

const bytes = fs.readFileSync(inputPath);
const text = bytes.toString("utf8").replace(/^\uFEFF/, "");
const rows = parseCsv(text);
const headers = rows.shift() ?? [];
if (headers.join("|") !== "Rij|CorrelationID|Naam") {
  throw new Error(`Unexpected application catalogue headers: ${headers.join("|")}`);
}

const records = rows.filter((row) => row.some((value) => value.trim() !== "")).map((row) => ({
  sequence: row[0]?.trim() ?? "",
  externalId: row[1]?.trim() ?? "",
  name: row[2]?.trim() ?? "",
}));

const idCounts = new Map();
const nameCounts = new Map();
for (const record of records) {
  if (record.externalId) idCounts.set(record.externalId, (idCounts.get(record.externalId) ?? 0) + 1);
  const normalizedName = record.name.toLocaleLowerCase("nl-NL");
  nameCounts.set(normalizedName, (nameCounts.get(normalizedName) ?? 0) + 1);
}

const profile = {
  schemaVersion: 1,
  classification: "Internal source profile; sanitized for approved web research",
  source: {
    basename: path.basename(inputPath),
    sha256: crypto.createHash("sha256").update(bytes).digest("hex"),
    byteCount: bytes.length,
    encoding: "UTF-8 with optional BOM",
    delimiter: "comma",
    profiledOn: "2026-07-31",
  },
  structure: {
    columns: ["row_sequence", "external_correlation_id", "application_name"],
    recordCount: records.length,
    sequentialRowNumbers: records.every((record, index) => Number(record.sequence) === index + 1),
  },
  quality: {
    uniqueApplicationNamesCaseInsensitive: nameCounts.size,
    missingApplicationNames: records.filter((record) => !record.name).length,
    missingExternalCorrelationIds: records.filter((record) => !record.externalId).length,
    distinctNonEmptyExternalCorrelationIds: idCounts.size,
    duplicatedNonEmptyExternalIdValues: [...idCounts.values()].filter((count) => count > 1).length,
    recordsUsingDuplicatedNonEmptyExternalIds: [...idCounts.values()].filter((count) => count > 1).reduce((a, b) => a + b, 0),
    duplicatedApplicationNamesCaseInsensitive: [...nameCounts.values()].filter((count) => count > 1).length,
    namesContainingIpv4Literal: records.filter((record) => /\b(?:\d{1,3}\.){3}\d{1,3}\b/.test(record.name)).length,
    namesContainingNonAsciiCharacters: records.filter((record) => /[^\x20-\x7E]/.test(record.name)).length,
    namesEndingInPossibleTruncationMarker: records.filter((record) => /(?:…|†)$/.test(record.name)).length,
  },
  absentDimensions: [
    "role or persona",
    "organization unit",
    "user or account",
    "application owner",
    "lifecycle status",
    "sensitivity classification",
    "URL/domain match rules",
    "process/publisher/product match rules",
    "aliases",
    "entitlements or observed usage",
  ],
  safety: {
    rawNamesIncluded: false,
    rawExternalIdsIncluded: false,
    internalAddressesIncluded: false,
    personalDataIncluded: false,
    guidance: "Treat legacy correlation IDs as nullable, non-authoritative external references. Assign new UAM-owned stable identifiers only after import validation.",
  },
};

fs.mkdirSync(path.dirname(outputPath), { recursive: true });
fs.writeFileSync(outputPath, `${JSON.stringify(profile, null, 2)}\n`, "utf8");
console.log(`Wrote sanitized profile: ${outputPath}`);
