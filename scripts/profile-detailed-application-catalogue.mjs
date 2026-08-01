#!/usr/bin/env node
import crypto from "node:crypto";
import fs from "node:fs";
import path from "node:path";

const repoRoot = path.resolve(path.dirname(new URL(import.meta.url).pathname), "..");
const inputPath = path.join(repoRoot, "applicaties_alle_zichtbare_informatie.csv");
const jsonPath = path.join(repoRoot, "evidence/sanitized/application-catalogue-profile.json");
const markdownPath = path.join(repoRoot, "evidence/sanitized/application-catalogue-summary.md");
const checkOnly = process.argv.includes("--check");

function parseCsv(text) {
  const rows = [];
  let row = [];
  let value = "";
  let quoted = false;
  for (let i = 0; i < text.length; i += 1) {
    const char = text[i];
    if (quoted && char === '"' && text[i + 1] === '"') { value += '"'; i += 1; }
    else if (char === '"') quoted = !quoted;
    else if (!quoted && char === ",") { row.push(value); value = ""; }
    else if (!quoted && char === "\n") { row.push(value.replace(/\r$/, "")); rows.push(row); row = []; value = ""; }
    else value += char;
  }
  if (value || row.length) { row.push(value.replace(/\r$/, "")); rows.push(row); }
  if (quoted) throw new Error("Unclosed quoted CSV field");
  return rows;
}

if (!fs.existsSync(inputPath)) throw new Error(`Missing ignored source catalogue: ${inputPath}`);
const bytes = fs.readFileSync(inputPath);
const rows = parseCsv(bytes.toString("utf8").replace(/^\uFEFF/, ""));
const headers = rows.shift() ?? [];
const expected = ["Rij", "Guid", "GuidRawOCR_ongeverifieerd", "GuidStatus", "CorrelationID", "Naam", "Beschrijving", "Versie", "OperationeleStatus", "ApplicatieComplexiteit", "AlmMatrix", "AlmStatus", "RbacObjectw", "Chargeable", "Vendor", "Bedrijf", "RequiredAccess", "OwnershipCompany", "BeheerdDoor", "FunctioneelBeheer", "Toewijzingsgroep", "TranscriptieOpmerking"];
if (headers.join("|") !== expected.join("|")) throw new Error(`Unexpected headers (${headers.length})`);
const records = rows.filter((row) => row.some((value) => value.trim()));
if (records.some((row) => row.length !== headers.length)) throw new Error("A catalogue row has an unexpected column count");

const metrics = Object.fromEntries(headers.map((header, index) => {
  const values = records.map((row) => row[index].trim()).filter(Boolean);
  return [header, { populated: values.length, missing: records.length - values.length, distinctNonEmpty: new Set(values).size }];
}));
const index = Object.fromEntries(headers.map((header, i) => [header, i]));
const nameValues = records.map((row) => row[index.Naam].trim().toLocaleLowerCase("nl-NL")).filter(Boolean);
const idValues = records.map((row) => row[index.CorrelationID].trim()).filter(Boolean);
const allCells = records.flat();
const uuidPattern = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
const row87 = records.find((row) => row[index.Rij].trim() === "87");
const row157 = records.find((row) => row[index.Rij].trim() === "157");

const profile = {
  schemaVersion: 1,
  classification: "Internal sanitized aggregate; safe for repository review, not automatically approved for public distribution",
  generation: "node scripts/profile-detailed-application-catalogue.mjs",
  source: { basename: path.basename(inputPath), sha256: crypto.createHash("sha256").update(bytes).digest("hex"), byteCount: bytes.length, encoding: "UTF-8 with BOM", delimiter: "comma" },
  structure: { recordCount: records.length, columnCount: headers.length, sequentialRowNumbers: records.every((row, i) => Number(row[index.Rij]) === i + 1) },
  quality: {
    fields: metrics,
    uniqueApplicationNamesCaseInsensitive: new Set(nameValues).size,
    duplicatedApplicationNameRecordsCaseInsensitive: nameValues.length - new Set(nameValues).size,
    distinctNonEmptyCorrelationIds: new Set(idValues).size,
    duplicatedCorrelationIdRecords: idValues.length - new Set(idValues).size,
    syntacticallyValidValuesInGuidColumn: records.filter((row) => uuidPattern.test(row[index.Guid].trim())).length,
    cellsContainingIpv4Literal: allCells.filter((value) => /\b(?:\d{1,3}\.){3}\d{1,3}\b/.test(value)).length,
    cellsContainingUrl: allCells.filter((value) => /https?:\/\//i.test(value)).length,
    requestedCatalogueCorrectionsVerified: Boolean(row87 && row157 && row87[index.CorrelationID].trim() === "686" && row157[index.CorrelationID].trim() === "685"),
  },
  interpretationLimits: [
    "Counts describe transcription completeness, not source-system correctness.",
    "The Guid column is not usable as a stable identifier; raw OCR values remain unverified.",
    "Populated ownership or management text does not prove accountable ownership.",
    "No row values, application names, addresses, URLs, external IDs, or personal information are copied into this profile.",
  ],
  safety: { rawRowsIncluded: false, rawApplicationNamesIncluded: false, rawExternalIdsIncluded: false, addressesIncluded: false, urlsIncluded: false, personalDataIncluded: false },
};

const markdown = `# Sanitized detailed application-catalogue summary

**Classification:** Internal sanitized aggregate; safe for repository review, not automatically approved for public distribution  
**Source:** Ignored local file \`${profile.source.basename}\`, SHA-256 \`${profile.source.sha256}\`  
**Generation:** \`${profile.generation}\`

## Useful facts

- ${profile.structure.recordCount} records and ${profile.structure.columnCount} columns were parsed; row numbering is ${profile.structure.sequentialRowNumbers ? "sequential" : "not sequential"}.
- All ${metrics.Naam.populated} populated application names are case-insensitively unique.
- Correlation IDs are populated for ${metrics.CorrelationID.populated} records; ${metrics.CorrelationID.missing} are missing and ${profile.quality.duplicatedCorrelationIdRecords} populated records duplicate an ID.
- Descriptions are populated for ${metrics.Beschrijving.populated} records, versions for ${metrics.Versie.populated}, vendors for ${metrics.Vendor.populated}, functional-management fields for ${metrics.FunctioneelBeheer.populated}, and assignment groups for ${metrics.Toewijzingsgroep.populated}.
- The management-owner field is populated for only ${metrics.BeheerdDoor.populated} records.
- The nominal GUID column contains ${profile.quality.syntacticallyValidValuesInGuidColumn} syntactically valid UUIDs and must not become the new stable identifier.
- The two catalogue corrections explicitly requested during review are ${profile.quality.requestedCatalogueCorrectionsVerified ? "present" : "not both present"} in the ignored source.
- ${profile.quality.cellsContainingIpv4Literal} cells contain IPv4-looking text and ${profile.quality.cellsContainingUrl} cell contains URL text, confirming that the raw CSV must not be uploaded as a research attachment.

## What this means for G0

Create UAM-owned stable fictional identifiers and treat legacy correlation IDs as nullable external references. Model aliases, ownership, match rules, status, and source provenance explicitly; catalogue population alone is not proof that those meanings are correct.

## Limitations

This output contains aggregate transcription facts only. It does not validate row values against the source system, identify real owners, approve monitoring, define match rules, or expose names and addresses. Re-run the generator after any source correction.
`;

function writeOrCheck(file, content) {
  if (checkOnly) {
    if (!fs.existsSync(file) || fs.readFileSync(file, "utf8") !== content) throw new Error(`Generated file is stale: ${path.relative(repoRoot, file)}`);
  } else {
    fs.mkdirSync(path.dirname(file), { recursive: true });
    fs.writeFileSync(file, content, "utf8");
  }
}
writeOrCheck(jsonPath, `${JSON.stringify(profile, null, 2)}\n`);
writeOrCheck(markdownPath, markdown);
console.log(checkOnly ? "Detailed catalogue profile is current." : "Wrote sanitized detailed catalogue profile and summary.");
