import { mkdir, mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import { join } from 'node:path';
import {
  buildSourceMap, generatedDir, loadModel, modelPath, rootDir, safeReplace,
  sourceMapPath, stableJson, validateModel, writeTree
} from './atlas-lib.mjs';
import { validateGenerated } from './validate-atlas.mjs';

export async function stageAtlas(options = {}) {
  const stageBase = join(rootDir, '.tools/atlas');
  await mkdir(stageBase, {recursive: true});
  const stageRoot = await mkdtemp(join(stageBase, 'stage-'));
  const stageGenerated = join(stageRoot, 'generated');
  const stageSourceMap = join(stageRoot, 'source-map.json');
  try {
    const model = await loadModel(options.modelPath ?? modelPath);
    await validateModel(model, {modelPath: options.modelPath ?? modelPath, rootDir});
    await writeTree(stageGenerated, model);
    await writeFile(stageSourceMap, stableJson(await buildSourceMap(model)));
    await validateGenerated(stageGenerated, {renderCheck: options.renderCheck === true});
    return {stageRoot, stageGenerated, stageSourceMap, model};
  } catch (error) {
    await rm(stageRoot, {recursive: true, force: true});
    throw error;
  }
}

export async function generateAtlas() {
  const staged = await stageAtlas();
  try {
    await mkdir(join(rootDir, 'docs/atlas/evidence'), {recursive: true});
    await safeReplace([
      {staged: staged.stageGenerated, target: generatedDir},
      {staged: staged.stageSourceMap, target: sourceMapPath}
    ]);
  } finally { await rm(staged.stageRoot, {recursive: true, force: true}); }
  return {gateCount: staged.model.gates.length};
}

if (process.argv[1] === new URL(import.meta.url).pathname) {
  generateAtlas().then(result => console.log(`Generated Atlas for ${result.gateCount} gates.`)).catch(error => { console.error(error.message); process.exitCode = 1; });
}
