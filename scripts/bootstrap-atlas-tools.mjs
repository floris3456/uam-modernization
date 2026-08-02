import { createHash } from 'node:crypto';
import { chmod, copyFile, mkdir, mkdtemp, readFile, rename, rm, writeFile } from 'node:fs/promises';
import { createWriteStream } from 'node:fs';
import { tmpdir } from 'node:os';
import { basename, dirname, join, relative } from 'node:path';
import { pipeline } from 'node:stream/promises';
import { exists, readJson, rootDir, run, toolManifestPath } from './atlas-lib.mjs';

async function downloadPinned(url, target, expectedSha256) {
  let current = new URL(url);
  const allowedHosts = new Set(['github.com', 'release-assets.githubusercontent.com', 'objects.githubusercontent.com']);
  for (let redirects = 0; redirects <= 5; redirects++) {
    if (current.protocol !== 'https:' || !allowedHosts.has(current.hostname)) throw new Error(`Refusing D2 download host: ${current.hostname}`);
    const response = await fetch(current, {redirect: 'manual', headers: {'User-Agent': 'uam-plan-atlas-bootstrap/1'}});
    if ([301,302,303,307,308].includes(response.status)) {
      const location = response.headers.get('location');
      if (!location) throw new Error('D2 download redirected without a Location header.');
      current = new URL(location, current); continue;
    }
    if (!response.ok || !response.body) throw new Error(`D2 download failed with HTTP ${response.status}.`);
    const hash = createHash('sha256');
    const sink = createWriteStream(target, {flags: 'wx'});
    const reader = response.body.getReader();
    const source = new ReadableStream({async pull(controller) { const {done, value} = await reader.read(); if (done) controller.close(); else { hash.update(value); controller.enqueue(value); } }});
    await pipeline(source, sink);
    const actual = hash.digest('hex');
    if (actual !== expectedSha256) { await rm(target, {force: true}); throw new Error(`D2 checksum mismatch: expected ${expectedSha256}, got ${actual}. The archive was deleted and never extracted.`); }
    return;
  }
  throw new Error('D2 download exceeded five redirects.');
}

export async function bootstrapAtlasTools() {
  const manifest = await readJson(toolManifestPath);
  const artifact = manifest.artifacts.find(item => item.platform === process.platform && item.arch === process.arch);
  if (!artifact) throw new Error(`Unsupported platform ${process.platform}/${process.arch}. Supported: ${manifest.artifacts.map(item => `${item.platform}/${item.arch}`).join(', ')}.`);
  if (!/^[a-f0-9]{64}$/.test(artifact.sha256)) throw new Error(`The manifest has no valid SHA-256 for ${artifact.name}.`);
  const installDir = join(rootDir, manifest.installRoot, `${process.platform}-${process.arch}`);
  const executable = join(installDir, process.platform === 'win32' ? 'd2.exe' : 'd2');
  if (await exists(executable)) {
    const reported = (await run(executable, ['--version'])).stdout.trim();
    if (reported.includes(manifest.version.replace(/^v/, ''))) return {executable, alreadyInstalled: true, version: reported};
    throw new Error(`Existing repository-local D2 has the wrong version: ${reported || 'unknown'}. Remove ${relative(rootDir, installDir)} and retry.`);
  }
  const work = await mkdtemp(join(tmpdir(), 'uam-atlas-d2-'));
  const archive = join(work, artifact.name); const extract = join(work, 'extract');
  try {
    await downloadPinned(artifact.url, archive, artifact.sha256);
    const listing = (await run('tar', ['-tzf', archive])).stdout.split(/\r?\n/).filter(Boolean);
    if (listing.some(entry => entry.startsWith('/') || entry.split('/').includes('..'))) throw new Error('D2 archive contains an unsafe path. Nothing was extracted.');
    const member = listing.find(entry => entry === artifact.binaryMember);
    if (!member) throw new Error(`Pinned D2 binary member ${artifact.binaryMember} is absent.`);
    await mkdir(extract, {recursive: true});
    await run('tar', ['-xzf', archive, '-C', extract, member]);
    const extracted = join(extract, ...member.split('/'));
    await mkdir(dirname(executable), {recursive: true});
    const temporaryExecutable = `${executable}.partial-${process.pid}`;
    await copyFile(extracted, temporaryExecutable);
    if (process.platform !== 'win32') await chmod(temporaryExecutable, 0o755);
    const reported = (await run(temporaryExecutable, ['--version'])).stdout.trim();
    if (!reported.includes(manifest.version.replace(/^v/, ''))) { await rm(temporaryExecutable, {force: true}); throw new Error(`Extracted D2 reports ${reported || 'no version'}, expected ${manifest.version}.`); }
    await rename(temporaryExecutable, executable);
    return {executable, alreadyInstalled: false, version: reported};
  } finally { await rm(work, {recursive: true, force: true}); }
}

if (process.argv[1] === new URL(import.meta.url).pathname) bootstrapAtlasTools().then(result => console.log(`${result.alreadyInstalled ? 'Using' : 'Installed'} ${result.version} at ${relative(rootDir, result.executable)}.`)).catch(error => { console.error([error?.message, error?.cause?.message, error?.cause?.cause?.message].filter(Boolean).join('\nCaused by: ')); process.exitCode = 1; });
