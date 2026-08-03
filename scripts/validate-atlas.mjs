import { mkdtemp, readFile, rm, stat } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { dirname, extname, join, normalize, relative, resolve, sep } from 'node:path';
import {
  assertNoExternalAssets, assertSafeContent, exists, generatedDir, listFiles, loadModel,
  modelPath, readJson, renderSvg, rootDir, sha256, sourceMapPath, stableJson, toolManifestPath, validateModel
} from './atlas-lib.mjs';

const expected = [
  'gate-map.d2', 'gate-map.svg', 'gate-register.md', 'index.html',
  ...['G0','G1','G2','G3','G4','G5','AG-06','AG-07','AG-08','AG-09','AG-10','AG-11','AG-12','AG-13','AG-14','AG-15'].map(id => `gates/${id}.html`)
].sort();

function localLinks(text) {
  return [...text.matchAll(/(?:href|data)=["']([^"'#]+)(?:#[^"']*)?["']/gi)].map(match => match[1]);
}

async function validateLink(outDir, file, href) {
  if (/^(?:https?:|\/\/|mailto:|javascript:)/i.test(href)) throw new Error(`${file} contains forbidden external or executable link ${href}.`);
  const virtualSource = join(generatedDir, file);
  const virtualTarget = resolve(dirname(virtualSource), href);
  if (virtualTarget.startsWith(`${generatedDir}${sep}`) || virtualTarget === generatedDir) {
    const stagedTarget = join(outDir, relative(generatedDir, virtualTarget));
    if (!await exists(stagedTarget)) throw new Error(`${file} has broken generated link ${href}.`);
  } else if (!await exists(virtualTarget)) throw new Error(`${file} has broken source link ${href}.`);
}

export async function validateGenerated(outDir, options = {}) {
  const actual = await listFiles(outDir);
  if (stableJson(actual) !== stableJson(expected)) throw new Error(`Generated file set differs.\nExpected: ${expected.join(', ')}\nActual: ${actual.join(', ')}`);
  for (const file of actual) {
    const path = join(outDir, file);
    await assertSafeContent(path);
    const text = await readFile(path, 'utf8');
    if (extname(file) === '.html') {
      await assertNoExternalAssets(text, file);
      for (const href of localLinks(text)) await validateLink(outDir, file, href);
    }
  }
  const index = await readFile(join(outDir, 'index.html'), 'utf8');
  for (const required of ['What UAM is', 'Immediate blockers', 'Human decisions needed now', 'Work allowed now', 'Work prohibited now', 'Next proof', 'Research:', 'ADR:', 'Implementation:', 'Gate:', 'map-viewport', 'map-zoom-out', 'map-zoom-reset', 'map-zoom-in', 'onMapWheel', 'Use the scroll wheel']) {
    if (!index.includes(required)) throw new Error(`Dashboard is missing ${required}.`);
  }
  if (index.includes('<object class="diagram"')) throw new Error('Dashboard embeds the map as an object, which prevents reliable card navigation.');
  for (const id of expected.filter(file => file.startsWith('gates/')).map(file => file.slice(6, -5))) {
    if (!index.includes(`href="gates/${id}.html" tabindex="0" aria-label=`)) throw new Error(`Dashboard map card does not link ${id}.`);
  }
  const g0 = await readFile(join(outDir, 'gates/G0.html'), 'utf8');
  for (const required of ['Conservative undecided production state', 'Work prohibited', 'What must humans decide?', 'What must be measured with CLI evidence?', 'Failure, reproduction, cleanup, and recovery', 'What passing never authorizes']) {
    if (!g0.includes(required)) throw new Error(`G0 page is missing ${required}.`);
  }
  const d2 = await readFile(join(outDir, 'gate-map.d2'), 'utf8');
  for (const id of expected.filter(file => file.startsWith('gates/')).map(file => file.slice(6, -5))) {
    if (!d2.includes(`gates/${id}.html`)) throw new Error(`D2 map does not link ${id}.`);
  }
  const svg = await readFile(join(outDir, 'gate-map.svg'), 'utf8');
  if (!svg.includes('<clipPath id="card-') || !svg.includes('clip-path="url(#card-')) throw new Error('SVG cards do not clip their text safely.');
  const svgLines = [...svg.matchAll(/<tspan[^>]*>(.*?)<\/tspan>/g)].map(match => match[1].replaceAll('&amp;', '&').replaceAll('&#39;', "'").replaceAll('&quot;', '"'));
  const overlongLine = svgLines.find(line => line.length > 36);
  if (overlongLine) throw new Error(`SVG card text exceeds its line limit: ${overlongLine}`);
  if (options.renderCheck !== false) {
    const renderDir = await mkdtemp(join(tmpdir(), 'uam-atlas-render-'));
    try {
      const one = join(renderDir, 'one.svg'); const two = join(renderDir, 'two.svg');
      await renderSvg(join(outDir, 'gate-map.d2'), one);
      await renderSvg(join(outDir, 'gate-map.d2'), two);
      const a = await readFile(one); const b = await readFile(two);
      if (!a.equals(b)) throw new Error(`Two D2 renders are not byte-equivalent (${sha256(a)} != ${sha256(b)}).`);
    } finally { await rm(renderDir, {recursive: true, force: true}); }
  }
  return {fileCount: actual.length};
}

export async function validateAtlas(options = {}) {
  const model = await loadModel(options.modelPath ?? modelPath);
  const modelResult = await validateModel(model, {modelPath: options.modelPath ?? modelPath, rootDir});
  const tools = await readJson(toolManifestPath);
  if (tools.version !== 'v0.7.1' || tools.license !== 'MPL-2.0') throw new Error('D2 tool version or license is not the reviewed pinned value.');
  const artifactKeys = new Set();
  for (const artifact of tools.artifacts ?? []) {
    const key = `${artifact.platform}/${artifact.arch}`;
    if (artifactKeys.has(key)) throw new Error(`Duplicate D2 artifact target ${key}.`);
    artifactKeys.add(key);
    if (!/^[a-f0-9]{64}$/.test(artifact.sha256)) throw new Error(`Invalid D2 SHA-256 for ${key}.`);
    if (!artifact.url.startsWith('https://github.com/d2lang/d2/releases/download/v0.7.1/')) throw new Error(`D2 artifact is not an official pinned v0.7.1 URL: ${key}.`);
  }
  for (const key of ['linux/x64','linux/arm64','win32/x64','win32/arm64']) if (!artifactKeys.has(key)) throw new Error(`Missing D2 artifact target ${key}.`);
  const outputResult = await validateGenerated(options.generatedDir ?? generatedDir, {renderCheck: options.renderCheck});
  const map = JSON.parse(await readFile(options.sourceMapPath ?? sourceMapPath, 'utf8'));
  if (map.generatedFrom !== 'docs/atlas/atlas.json' || map.sources.length !== model.sourceDocuments.length) throw new Error('Source map is incomplete or points to the wrong model.');
  if (map.modelSha256 !== sha256(await readFile(options.modelPath ?? modelPath))) throw new Error('Source map model hash is stale.');
  for (const source of map.sources) {
    const bytes = await readFile(join(rootDir, source.path));
    if (source.sha256 !== sha256(bytes)) throw new Error(`Source map hash is stale for ${source.path}.`);
  }
  await assertSafeContent(options.sourceMapPath ?? sourceMapPath);
  return {...modelResult, ...outputResult};
}

if (process.argv[1] && resolve(process.argv[1]) === resolve(new URL(import.meta.url).pathname)) {
  validateAtlas().then(result => console.log(`Atlas valid: ${result.gateCount} gates, ${result.sourceCount} sources, ${result.fileCount} generated files.`)).catch(error => { console.error(error.message); process.exitCode = 1; });
}
