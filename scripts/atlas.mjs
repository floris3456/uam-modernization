#!/usr/bin/env node
import { mkdtemp, readFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join, relative } from 'node:path';
import { bootstrapAtlasTools } from './bootstrap-atlas-tools.mjs';
import { generateAtlas, stageAtlas } from './generate-atlas.mjs';
import { smokeTest } from './atlas-smoke-test.mjs';
import { generatedDir, listFiles, loadModel, rootDir, sourceMapPath } from './atlas-lib.mjs';
import { validateAtlas } from './validate-atlas.mjs';

const help = `UAM Plan Atlas\n\nUsage:\n  node scripts/atlas.mjs generate    Rebuild every generated Atlas file safely\n  node scripts/atlas.mjs validate    Validate model, sources, statuses, links, SVG and safety rules\n  node scripts/atlas.mjs check       Fail when committed generated output is stale\n  node scripts/atlas.mjs status      Print the current gate in terminal-friendly language\n  node scripts/atlas.mjs bootstrap   Install the pinned D2 release under .tools/atlas\n  node scripts/atlas.mjs smoke-test  Prove key invalid states are rejected\n  node scripts/atlas.mjs help        Show this help\n\nEdit docs/atlas/atlas.json, never generated files. The Atlas visualizes and links the plan; it does not approve an ADR or pass a gate.\n`;

function errorMessage(error) {
  const messages = [];
  for (let current = error; current && messages.length < 4; current = current.cause) if (current.message && !messages.includes(current.message)) messages.push(current.message);
  return messages.join('\nCaused by: ');
}

async function compareFiles(expectedDir, actualDir) {
  const expected = await listFiles(expectedDir); const actual = await listFiles(actualDir);
  if (JSON.stringify(expected) !== JSON.stringify(actual)) throw new Error('Generated Atlas file list is stale. Run node scripts/atlas.mjs generate.');
  for (const file of expected) {
    const a = await readFile(join(expectedDir, file)); const b = await readFile(join(actualDir, file));
    if (!a.equals(b)) throw new Error(`Generated Atlas is stale: ${file}. Run node scripts/atlas.mjs generate.`);
  }
}

async function check() {
  const staged = await stageAtlas();
  try {
    await compareFiles(staged.stageGenerated, generatedDir);
    const a = await readFile(staged.stageSourceMap); const b = await readFile(sourceMapPath);
    if (!a.equals(b)) throw new Error('Generated Atlas is stale: evidence/source-map.json. Run node scripts/atlas.mjs generate.');
  } finally { await rm(staged.stageRoot, {recursive: true, force: true}); }
  await validateAtlas();
}

async function status() {
  const model = await loadModel(); const gate = model.gates.find(item => item.id === model.project.currentGateId);
  console.log(`${model.project.currentPosition}\nCurrent gate: ${gate.id} — ${gate.name}\nResearch: ${gate.statuses.research.value} | ADR: ${gate.statuses.adr.value} | Implementation: ${gate.statuses.implementation.value} | Gate: ${gate.statuses.gate.value}\nOwner: ${gate.owner.value}\nNext proof: ${model.project.nextProof}\nImmediate human decisions: ${gate.humanDecisions.length}\nHard dependencies: ${gate.dependsOn.join(', ') || 'none'}`);
}

const command = process.argv[2] ?? 'help';
try {
  if (command === 'help' || command === '--help' || command === '-h') process.stdout.write(help);
  else if (command === 'generate') { const result = await generateAtlas(); console.log(`Generated Atlas for ${result.gateCount} gates.`); }
  else if (command === 'validate') { const result = await validateAtlas(); console.log(`Atlas valid: ${result.gateCount} gates, ${result.sourceCount} sources, ${result.fileCount} generated files.`); }
  else if (command === 'check') { await check(); console.log('Atlas generated output is current and valid.'); }
  else if (command === 'status') await status();
  else if (command === 'bootstrap') { const result = await bootstrapAtlasTools(); console.log(`${result.alreadyInstalled ? 'Using' : 'Installed'} ${result.version} at ${relative(rootDir, result.executable)}.`); }
  else if (command === 'smoke-test') console.log((await smokeTest()).join('\n'));
  else throw new Error(`Unknown Atlas command: ${command}\n\n${help}`);
} catch (error) { console.error(errorMessage(error)); process.exitCode = 1; }
