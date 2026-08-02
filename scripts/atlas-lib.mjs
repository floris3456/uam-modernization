import { createHash } from 'node:crypto';
import { access, mkdir, readFile, readdir, rename, rm, stat, writeFile } from 'node:fs/promises';
import { constants as fsConstants } from 'node:fs';
import { spawn } from 'node:child_process';
import { dirname, join, relative, resolve, sep } from 'node:path';

export const rootDir = resolve(dirname(new URL(import.meta.url).pathname), '..');
export const modelPath = join(rootDir, 'docs/atlas/atlas.json');
export const generatedDir = join(rootDir, 'docs/atlas/generated');
export const sourceMapPath = join(rootDir, 'docs/atlas/evidence/source-map.json');
export const toolManifestPath = join(rootDir, 'tools/atlas/d2-tools.json');

export const canonicalGateId = /^(?:G[0-5]|AG-(?:0[6-9]|1[0-5]))$/;
const allowedStatuses = {
  research: new Set(['not-created', 'in-progress', 'complete']),
  adr: new Set(['not-created', 'proposed', 'experimenting', 'accepted']),
  implementation: new Set(['not-started', 'experimenting', 'blocked', 'complete']),
  gate: new Set(['open', 'hold', 'passed'])
};

export async function exists(path) {
  try { await access(path, fsConstants.F_OK); return true; } catch { return false; }
}

export function sha256(bytes) {
  return createHash('sha256').update(bytes).digest('hex');
}

export async function readJson(path) {
  return JSON.parse(await readFile(path, 'utf8'));
}

export async function loadModel(path = modelPath) {
  return readJson(path);
}

export function stableJson(value) {
  return `${JSON.stringify(value, null, 2)}\n`;
}

export function escapeHtml(value) {
  return String(value).replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;').replaceAll("'", '&#39;');
}

export function escapeD2(value) {
  return String(value).replaceAll('\\', '\\\\').replaceAll('"', '\\"').replaceAll('\n', '\\n');
}

export function sourceById(model) {
  return new Map(model.sourceDocuments.map(source => [source.id, source]));
}

export async function validateModel(model, options = {}) {
  const errors = [];
  const modelFile = options.modelPath ?? modelPath;
  const sourceRoot = options.rootDir ?? rootDir;
  if (model.schemaVersion !== 1) errors.push('schemaVersion must be 1.');
  if (!model.authority?.includes('cannot accept an ADR')) errors.push('The Atlas authority boundary is missing.');
  if (!Array.isArray(model.gates) || model.gates.length !== 16) errors.push('Exactly 16 aggregate gates are required.');
  const sources = sourceById(model);
  const sourceIds = new Set();
  for (const source of model.sourceDocuments ?? []) {
    if (sourceIds.has(source.id)) errors.push(`Duplicate source ID: ${source.id}`);
    sourceIds.add(source.id);
    if (!source.path || resolve(sourceRoot, source.path) === modelFile) errors.push(`Invalid source path for ${source.id}.`);
    else if (!await exists(resolve(sourceRoot, source.path))) errors.push(`Source does not resolve: ${source.id} -> ${source.path}`);
  }
  const ids = new Set();
  const byId = new Map();
  for (const gate of model.gates ?? []) {
    if (!canonicalGateId.test(gate.id)) errors.push(`Non-canonical gate ID: ${gate.id}`);
    if (ids.has(gate.id)) errors.push(`Duplicate gate ID: ${gate.id}`);
    ids.add(gate.id); byId.set(gate.id, gate);
    for (const field of ['name', 'purpose', 'proofClaim', 'whyNow', 'passCondition', 'stopCondition']) {
      if (!gate[field] || !String(gate[field]).trim()) errors.push(`${gate.id} is missing ${field}.`);
    }
    for (const field of ['dependsOn', 'parallelPreparation', 'humanDecisions', 'allowedWork', 'prohibitedWork', 'cliEvidence', 'evidenceRequired', 'failureRecovery', 'unlocks', 'neverUnlocks', 'sources']) {
      if (!Array.isArray(gate[field]) || gate[field].length === 0 && !['dependsOn'].includes(field)) errors.push(`${gate.id} must define ${field}.`);
    }
    for (const kind of Object.keys(allowedStatuses)) {
      const status = gate.statuses?.[kind];
      if (!status || !allowedStatuses[kind].has(status.value)) errors.push(`${gate.id} has invalid ${kind} status.`);
      if (!status?.source || !sources.has(status.source)) errors.push(`${gate.id} ${kind} status has no valid source.`);
    }
    if (gate.owner?.value !== 'UNASSIGNED') {
      if (!gate.owner?.source || !sources.has(gate.owner.source)) errors.push(`${gate.id} owner is not supported by a source.`);
    } else if (!gate.owner.source || !sources.has(gate.owner.source)) errors.push(`${gate.id} UNASSIGNED owner needs a source.`);
    for (const sourceId of gate.sources ?? []) if (!sources.has(sourceId)) errors.push(`${gate.id} references unknown source ${sourceId}.`);
    if (gate.statuses?.gate?.value === 'passed') {
      if (!gate.gateRecord || !await exists(resolve(sourceRoot, gate.gateRecord))) errors.push(`${gate.id} is passed without an applicable gate record.`);
    }
    if (gate.statuses?.adr?.value === 'accepted') {
      const source = sources.get(gate.statuses.adr.source);
      const content = source ? await readFile(resolve(sourceRoot, source.path), 'utf8') : '';
      if (!/(?:\*\*Status:\*\*|\|\s*Status\s*\|)[^\n]*Accepted/i.test(content)) errors.push(`${gate.id} is accepted but its ADR source does not say Accepted.`);
    }
  }
  for (const gate of model.gates ?? []) {
    for (const dependency of gate.dependsOn ?? []) {
      if (!ids.has(dependency)) errors.push(`${gate.id} has unknown dependency ${dependency}.`);
      if (dependency === gate.id) errors.push(`${gate.id} depends on itself.`);
    }
    if (['experimenting', 'complete'].includes(gate.statuses?.implementation?.value)) {
      for (const dependency of gate.dependsOn ?? []) {
        if (byId.get(dependency)?.statuses?.gate?.value !== 'passed') errors.push(`${gate.id} implementation is active while blocking predecessor ${dependency} is open.`);
      }
    }
  }
  const visiting = new Set(); const visited = new Set();
  function visit(id, path = []) {
    if (visiting.has(id)) { errors.push(`Dependency cycle: ${[...path, id].join(' -> ')}`); return; }
    if (visited.has(id)) return;
    visiting.add(id);
    for (const dependency of byId.get(id)?.dependsOn ?? []) visit(dependency, [...path, id]);
    visiting.delete(id); visited.add(id);
  }
  for (const id of ids) visit(id);
  if (!ids.has(model.project?.currentGateId)) errors.push('project.currentGateId does not name a gate.');
  const current = byId.get(model.project?.currentGateId);
  if (current?.statuses?.gate?.value === 'passed') errors.push('The current gate cannot also be displayed as passed.');
  if (errors.length) throw new Error(`Atlas model validation failed:\n- ${errors.join('\n- ')}`);
  return { gateCount: ids.size, sourceCount: sourceIds.size };
}

export function repoLink(fromGeneratedSubpath, sourcePath) {
  const from = join(generatedDir, fromGeneratedSubpath);
  return relative(dirname(from), join(rootDir, sourcePath)).split(sep).join('/');
}

function list(items, className = '') {
  return `<ul${className ? ` class="${className}"` : ''}>${items.map(item => `<li>${escapeHtml(item)}</li>`).join('')}</ul>`;
}

function statusBadge(kind, status) {
  return `<span class="status status-${escapeHtml(status.value)}"><span class="status-kind">${escapeHtml(kind)}:</span> ${escapeHtml(status.value)}</span>`;
}

function sourcesHtml(model, gate, fromSubpath) {
  const sources = sourceById(model);
  return `<ul>${gate.sources.map(id => { const source = sources.get(id); return `<li><a href="${escapeHtml(repoLink(fromSubpath, source.path))}">${escapeHtml(source.label)}</a> <span class="muted">— ${escapeHtml(source.authority)}</span></li>`; }).join('')}</ul>`;
}

const css = `
:root{color-scheme:light;--ink:#17202a;--muted:#566273;--paper:#fff;--panel:#f5f7fa;--line:#c8d0da;--accent:#075a82;--focus:#ffbf47;--danger:#8b1e1e;--ok:#176b38;--hold:#805b00}*{box-sizing:border-box}body{margin:0;background:var(--paper);color:var(--ink);font:16px/1.5 system-ui,-apple-system,"Segoe UI",sans-serif}a{color:var(--accent);text-underline-offset:.15em}a:hover{text-decoration-thickness:.15em}a:focus-visible,button:focus-visible,input:focus-visible,.diagram-viewport:focus-visible{outline:3px solid var(--focus);outline-offset:3px}.skip{position:absolute;left:-9999px}.skip:focus{left:1rem;top:1rem;background:#fff;padding:.5rem;z-index:10}header,main,footer{max-width:1200px;margin:auto;padding:1rem 1.25rem}header{border-bottom:1px solid var(--line)}nav{display:flex;gap:1rem;flex-wrap:wrap}.eyebrow,.status-kind{font-weight:700}.hero{display:grid;grid-template-columns:2fr 1fr;gap:1rem}.panel,.card{background:var(--panel);border:1px solid var(--line);border-radius:.5rem;padding:1rem}.warning{border-left:.4rem solid var(--danger)}.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1rem}.status-row{display:flex;gap:.4rem;flex-wrap:wrap}.status{display:inline-block;border:1px solid #657180;border-radius:999px;padding:.15rem .55rem;background:#fff}.status-open,.status-blocked,.status-not-started,.status-not-created{border-style:dashed}.status-passed,.status-accepted,.status-complete{border-color:var(--ok)}.status-hold{border-color:var(--hold)}.muted{color:var(--muted)}h1{line-height:1.1}h2{margin-top:2rem}h3{margin-bottom:.25rem}.compact li{margin:.15rem 0}.diagram-toolbar{display:flex;align-items:center;gap:.5rem;flex-wrap:wrap;margin:.75rem 0}.diagram-toolbar button{min-width:2.5rem;padding:.4rem .65rem;border:1px solid #657180;border-radius:.3rem;background:#fff;color:var(--ink);font:inherit;font-weight:700;cursor:pointer}.diagram-toolbar output{min-width:4rem;font-variant-numeric:tabular-nums}.diagram-viewport{height:520px;overflow:auto;overscroll-behavior:contain;border:1px solid var(--line);background:#fff}.diagram{display:block;width:4640px;height:425px;border:0;background:#fff}.table-wrap{overflow:auto}table{border-collapse:collapse;width:100%;font-size:.92rem}th,td{text-align:left;vertical-align:top;border:1px solid var(--line);padding:.55rem}th{background:#eaf0f5;position:sticky;top:0}input[type=search]{width:min(100%,32rem);font:inherit;padding:.55rem;border:2px solid #657180;border-radius:.25rem}.facts{display:grid;grid-template-columns:max-content 1fr;gap:.35rem 1rem}.facts dt{font-weight:700}.facts dd{margin:0}@media(max-width:720px){.hero{grid-template-columns:1fr}.facts{grid-template-columns:1fr}.facts dd{margin-bottom:.5rem}.diagram-viewport{height:440px}}@media(prefers-reduced-motion:reduce){*{scroll-behavior:auto!important}}
`;

function shell(title, body, depth = '') {
  return `<!doctype html>\n<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="color-scheme" content="light"><title>${escapeHtml(title)}</title><style>${css}</style></head><body><a class="skip" href="#main">Skip to main content</a><header><nav aria-label="Atlas navigation"><a href="${depth}index.html">Dashboard</a><a href="${depth}index.html#map">Gate map</a><a href="${depth}index.html#register">Gate register</a><a href="${depth}../README.md">Workflow</a></nav></header><main id="main">${body}</main><footer><p>This generated Atlas is for visualization and navigation only. Source documents and measured evidence remain authoritative.</p></footer></body></html>\n`;
}

export function renderIndex(model) {
  const current = model.gates.find(gate => gate.id === model.project.currentGateId);
  const dashboard = model.project.dashboard;
  const rows = model.gates.map(gate => `<tr data-search="${escapeHtml([gate.id, gate.name, gate.purpose, gate.statuses.gate.value, gate.owner.value].join(' ').toLowerCase())}"><th scope="row"><a href="gates/${escapeHtml(gate.id)}.html">${escapeHtml(gate.id)} — ${escapeHtml(gate.name)}</a></th><td>${escapeHtml(gate.purpose)}</td><td>${gate.dependsOn.length ? gate.dependsOn.map(id => `<a href="gates/${id}.html">${id}</a>`).join(', ') : 'None'}</td><td>${statusBadge('Research', gate.statuses.research)} ${statusBadge('ADR', gate.statuses.adr)} ${statusBadge('Implementation', gate.statuses.implementation)} ${statusBadge('Gate', gate.statuses.gate)}</td><td>${escapeHtml(gate.owner.value)}</td><td>${escapeHtml(gate.passCondition)}</td><td>${escapeHtml(gate.stopCondition)}</td></tr>`).join('');
  const body = `<p class="eyebrow">One-minute dashboard</p><h1>${escapeHtml(model.title)}</h1><div class="hero"><section><h2>What UAM is</h2><p>${escapeHtml(model.project.whatItIs)}</p><p><strong>Where we are:</strong> ${escapeHtml(model.project.currentPosition)}. ${escapeHtml(model.project.repositoryToday)}</p><p><a href="gates/${current.id}.html"><strong>Current gate: ${current.id} — ${escapeHtml(current.name)}</strong></a></p><div class="status-row">${statusBadge('Research', current.statuses.research)}${statusBadge('ADR', current.statuses.adr)}${statusBadge('Implementation', current.statuses.implementation)}${statusBadge('Gate', current.statuses.gate)}</div></section><aside class="panel warning"><h2>Immediate blockers</h2>${list(dashboard.immediateBlockers, 'compact')}<p><strong>Owner:</strong> ${escapeHtml(current.owner.value)}</p></aside></div><div class="grid"><section class="card"><h2>Human decisions needed now</h2>${list(dashboard.humanDecisions)}</section><section class="card"><h2>Work allowed now</h2>${list(dashboard.allowedNow)}</section><section class="card warning"><h2>Work prohibited now</h2>${list(dashboard.prohibitedNow)}</section></div><section class="panel"><h2>Next proof</h2><p>${escapeHtml(model.project.nextProof)}</p><p><a href="gates/G0.html">Open the complete G0 permissions, stops, evidence, and recovery details.</a></p><h3>What would stop or invalidate this plan?</h3>${list(model.project.invalidators)}</section><section id="map"><h2>Gate dependency map</h2><p>Arrows show hard proof dependencies. Later preparation may still be possible; each gate page explains the boundary.</p><div class="diagram-toolbar" role="group" aria-label="Diagram zoom controls"><button type="button" id="map-zoom-out" aria-label="Zoom diagram out">−</button><button type="button" id="map-zoom-reset">Reset</button><button type="button" id="map-zoom-in" aria-label="Zoom diagram in">+</button><output id="map-zoom-status" aria-live="polite">100%</output></div><div class="diagram-viewport" id="map-viewport" tabindex="0" aria-label="Zoomable and scrollable gate dependency map"><object class="diagram" id="gate-map-diagram" data="gate-map.svg" type="image/svg+xml" aria-label="Dependency map of all 16 UAM proof gates"><p><a href="gate-register.md">Read the gate register instead.</a></p></object></div><p class="muted">Use the scroll wheel over the diagram to zoom. Use the scrollbars to move through it.</p></section><section id="register"><h2>Gate register</h2><label for="gate-filter">Filter gates</label><br><input id="gate-filter" type="search" placeholder="Try G0, privacy, blocked, or database"><div class="table-wrap"><table><thead><tr><th>Gate</th><th>Purpose</th><th>Depends on</th><th>Four separate states</th><th>Owner</th><th>Pass condition</th><th>Stop condition</th></tr></thead><tbody id="gate-rows">${rows}</tbody></table></div><noscript><p>The complete table and map remain readable without filtering or zoom controls. JavaScript only adds filtering and interactive zoom.</p></noscript></section><script>const f=document.getElementById('gate-filter');const rows=[...document.querySelectorAll('#gate-rows tr')];f?.addEventListener('input',()=>{const q=f.value.trim().toLowerCase();for(const row of rows)row.hidden=q&&!row.dataset.search.includes(q)});const mapViewport=document.getElementById('map-viewport');const mapDiagram=document.getElementById('gate-map-diagram');const mapZoomStatus=document.getElementById('map-zoom-status');const mapBaseWidth=4640;const mapBaseHeight=425;let mapZoom=1;function setMapZoom(next){const oldWidth=mapBaseWidth*mapZoom;const centerRatio=(mapViewport.scrollLeft+mapViewport.clientWidth/2)/oldWidth;mapZoom=Math.min(3,Math.max(.25,next));mapDiagram.style.width=mapBaseWidth*mapZoom+'px';mapDiagram.style.height=mapBaseHeight*mapZoom+'px';mapZoomStatus.value=Math.round(mapZoom*100)+'%';requestAnimationFrame(()=>{mapViewport.scrollLeft=Math.max(0,centerRatio*mapBaseWidth*mapZoom-mapViewport.clientWidth/2)})}function onMapWheel(event){event.preventDefault();setMapZoom(mapZoom*(event.deltaY<0?1.12:1/1.12))}mapViewport?.addEventListener('wheel',onMapWheel,{passive:false});mapDiagram?.addEventListener('load',()=>{try{mapDiagram.contentDocument?.addEventListener('wheel',onMapWheel,{passive:false})}catch{}});document.getElementById('map-zoom-in')?.addEventListener('click',()=>setMapZoom(mapZoom*1.25));document.getElementById('map-zoom-out')?.addEventListener('click',()=>setMapZoom(mapZoom/1.25));document.getElementById('map-zoom-reset')?.addEventListener('click',()=>setMapZoom(1));mapViewport?.addEventListener('keydown',event=>{if(event.key==='+'||event.key==='='){event.preventDefault();setMapZoom(mapZoom*1.25)}else if(event.key==='-'){event.preventDefault();setMapZoom(mapZoom/1.25)}else if(event.key==='0'){event.preventDefault();setMapZoom(1)}});</script>`;
  return shell(model.title, body);
}

export function renderGatePage(model, gate) {
  const dependencies = gate.dependsOn.length ? gate.dependsOn.map(id => `<a href="${id}.html">${id}</a>`).join(', ') : 'None';
  const body = `<p class="eyebrow">Proof gate ${escapeHtml(gate.id)}</p><h1>${escapeHtml(gate.id)} — ${escapeHtml(gate.name)}</h1><p class="muted">Accepted-baseline wording: ${escapeHtml(gate.baselineName)}</p><div class="status-row">${statusBadge('Research', gate.statuses.research)}${statusBadge('ADR', gate.statuses.adr)}${statusBadge('Implementation', gate.statuses.implementation)}${statusBadge('Gate', gate.statuses.gate)}</div><dl class="facts"><dt>Owner</dt><dd>${escapeHtml(gate.owner.value)}</dd><dt>Hard dependencies</dt><dd>${dependencies}</dd><dt>Proof claim</dt><dd>${escapeHtml(gate.proofClaim)}</dd></dl>${gate.ownerGaps ? `<section class="panel warning"><h2>Current owner gaps</h2>${list(gate.ownerGaps)}</section>` : ''}<section><h2>What are we proving?</h2><p>${escapeHtml(gate.purpose)}</p><h2>Why now?</h2><p>${escapeHtml(gate.whyNow)}</p><h2>What depends on it?</h2>${list(gate.unlocks)}<h3>Preparation that may happen earlier</h3>${list(gate.parallelPreparation)}</section>${gate.conservativeState ? `<section class="panel"><h2>Conservative undecided production state</h2><dl class="facts">${Object.entries(gate.conservativeState).map(([key,value]) => `<dt>${escapeHtml(key)}</dt><dd><code>${escapeHtml(value)}</code></dd>`).join('')}</dl><p>This state must never authorize live data or production-shaped source access.</p></section>` : ''}<div class="grid"><section class="card"><h2>Work allowed</h2>${list(gate.allowedWork)}</section><section class="card warning"><h2>Work prohibited</h2>${list(gate.prohibitedWork)}</section></div><section><h2>What must humans decide?</h2>${list(gate.humanDecisions)}<h2>What must be measured with CLI evidence?</h2>${list(gate.cliEvidence)}<h2>What evidence is required?</h2>${list(gate.evidenceRequired)}<h2>What causes failure or hold?</h2><p>${escapeHtml(gate.stopCondition)}</p><h3>Failure, reproduction, cleanup, and recovery</h3>${list(gate.failureRecovery)}<h2>What does passing unlock?</h2>${list(gate.unlocks)}<h3>What passing never authorizes</h3>${list(gate.neverUnlocks)}<h2>Pass condition</h2><p>${escapeHtml(gate.passCondition)}</p><h2>Authoritative and supporting sources</h2>${sourcesHtml(model, gate, `gates/${gate.id}.html`)}</section>`;
  return shell(`${gate.id} — ${gate.name}`, body, '../');
}

export function renderRegisterMarkdown(model) {
  const sources = sourceById(model);
  const cell = value => String(value).replaceAll('|', '\\|').replaceAll('\n', ' ');
  const rows = model.gates.map(gate => {
    const links = gate.sources.map(id => { const source = sources.get(id); return `[${id}](${repoLink('gate-register.md', source.path)})`; }).join(', ');
    return `| [${gate.id}](gates/${gate.id}.html) — ${cell(gate.name)} | ${cell(gate.purpose)} | ${gate.dependsOn.join(', ') || 'None'} | ${gate.statuses.research.value} | ${gate.statuses.adr.value} | ${gate.statuses.implementation.value} | ${gate.statuses.gate.value} | ${gate.owner.value} | ${cell(gate.humanDecisions.join('; '))} | ${cell(gate.cliEvidence.join('; '))} | ${cell(gate.passCondition)} | ${cell(gate.stopCondition)} | ${cell(gate.unlocks.join('; '))} | ${links} |`;
  });
  return `# Generated UAM gate register\n\nThis file is generated from \`docs/atlas/atlas.json\`. It is for visualization and navigation only.\n\n| Gate | Purpose | Dependencies | Research | ADR | Implementation | Gate | Owner | Human decisions | CLI evidence | Pass condition | Stop condition | Unlocks | Sources |\n| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |\n${rows.join('\n')}\n`;
}

export function renderD2(model) {
  const lines = [
    'direction: right',
    'classes: {',
    '  open: {',
    '    style: {',
    '      fill: "#f5f7fa"',
    '      stroke: "#566273"',
    '      stroke-dash: 4',
    '    }',
    '  }',
    '  hold: {',
    '    style: {',
    '      fill: "#fff4cf"',
    '      stroke: "#805b00"',
    '    }',
    '  }',
    '  passed: {',
    '    style: {',
    '      fill: "#e8f5ec"',
    '      stroke: "#176b38"',
    '    }',
    '  }',
    '}'
  ];
  for (const gate of model.gates) {
    const label = `${gate.id} · ${gate.name}\nGate: ${gate.statuses.gate.value} · Owner: ${gate.owner.value}\n${gate.proofClaim}`;
    lines.push(`${gate.id.replace('-', '_')}: "${escapeD2(label)}" {`);
    lines.push(`  class: ${gate.statuses.gate.value}`);
    lines.push(`  link: "gates/${gate.id}.html"`);
    lines.push(`  tooltip: "Research ${gate.statuses.research.value}; ADR ${gate.statuses.adr.value}; implementation ${gate.statuses.implementation.value}"`);
    lines.push('}');
  }
  for (const gate of model.gates) for (const dependency of gate.dependsOn) lines.push(`${dependency.replace('-', '_')} -> ${gate.id.replace('-', '_')}`);
  return `${lines.join('\n')}\n`;
}

export function renderSvgPreview(model) {
  const byId = new Map(model.gates.map(gate => [gate.id, gate]));
  const levels = new Map();
  const levelOf = id => {
    if (levels.has(id)) return levels.get(id);
    const gate = byId.get(id);
    const level = gate.dependsOn.length ? Math.max(...gate.dependsOn.map(levelOf)) + 1 : 0;
    levels.set(id, level); return level;
  };
  for (const gate of model.gates) levelOf(gate.id);
  const groups = new Map();
  for (const gate of model.gates) {
    const level = levels.get(gate.id);
    if (!groups.has(level)) groups.set(level, []);
    groups.get(level).push(gate);
  }
  const nodeWidth = 300; const nodeHeight = 150; const xGap = 55; const yGap = 45; const margin = 40;
  const maxRows = Math.max(...[...groups.values()].map(group => group.length));
  const width = margin * 2 + (Math.max(...levels.values()) + 1) * nodeWidth + Math.max(...levels.values()) * xGap;
  const height = margin * 2 + maxRows * nodeHeight + (maxRows - 1) * yGap;
  const positions = new Map();
  for (const [level, gates] of groups) {
    const groupHeight = gates.length * nodeHeight + (gates.length - 1) * yGap;
    const startY = (height - groupHeight) / 2;
    gates.sort((a,b) => a.order - b.order).forEach((gate, index) => positions.set(gate.id, {x: margin + level * (nodeWidth + xGap), y: startY + index * (nodeHeight + yGap)}));
  }
  const edge = [];
  for (const gate of model.gates) for (const dependency of gate.dependsOn) {
    const from = positions.get(dependency); const to = positions.get(gate.id);
    const x1 = from.x + nodeWidth; const y1 = from.y + nodeHeight / 2; const x2 = to.x; const y2 = to.y + nodeHeight / 2;
    const mid = (x1 + x2) / 2;
    edge.push(`<path d="M ${x1} ${y1} C ${mid} ${y1}, ${mid} ${y2}, ${x2} ${y2}" fill="none" stroke="#657180" stroke-width="2" marker-end="url(#arrow)"/>`);
  }
  const nodes = model.gates.map(gate => {
    const {x,y} = positions.get(gate.id); const claim = gate.proofClaim.length > 88 ? `${gate.proofClaim.slice(0, 85)}…` : gate.proofClaim;
    return `<a href="gates/${escapeHtml(gate.id)}.html" tabindex="0" aria-label="${escapeHtml(`${gate.id} ${gate.name}; gate ${gate.statuses.gate.value}; owner ${gate.owner.value}`)}"><g><title>${escapeHtml(gate.proofClaim)} Research ${escapeHtml(gate.statuses.research.value)}; ADR ${escapeHtml(gate.statuses.adr.value)}; implementation ${escapeHtml(gate.statuses.implementation.value)}</title><rect x="${x}" y="${y}" width="${nodeWidth}" height="${nodeHeight}" rx="10" fill="#f5f7fa" stroke="#566273" stroke-width="2" stroke-dasharray="7 5"/><text x="${x+16}" y="${y+28}" fill="#17202a" font-family="system-ui,Segoe UI,sans-serif"><tspan x="${x+16}" font-size="18" font-weight="700">${escapeHtml(gate.id)} · ${escapeHtml(gate.name)}</tspan><tspan x="${x+16}" dy="25" font-size="14" font-weight="700">Gate: ${escapeHtml(gate.statuses.gate.value)}</tspan><tspan x="${x+16}" dy="21" font-size="14">Owner: ${escapeHtml(gate.owner.value)}</tspan><tspan x="${x+16}" dy="25" font-size="13">${escapeHtml(claim.slice(0, 44))}</tspan><tspan x="${x+16}" dy="19" font-size="13">${escapeHtml(claim.slice(44))}</tspan></text></g></a>`;
  });
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${width} ${height}" role="img" aria-labelledby="title description"><title id="title">UAM proof-gate dependency map</title><desc id="description">All sixteen aggregate proof gates. Arrows show hard pass dependencies. Every gate is open and every owner is unassigned.</desc><defs><marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" fill="#657180"/></marker></defs><rect width="100%" height="100%" fill="#ffffff"/>${edge.join('')}${nodes.join('')}</svg>\n`;
}

export async function buildSourceMap(model) {
  const sources = [];
  for (const source of model.sourceDocuments) {
    const bytes = await readFile(join(rootDir, source.path));
    sources.push({...source, classification: 'Internal repository documentation; sanitize before external sharing', generation: 'Read from the committed path and hashed by scripts/atlas.mjs generate', sha256: sha256(bytes), limitations: source.authority});
  }
  return { schemaVersion: 1, generatedFrom: 'docs/atlas/atlas.json', modelSha256: sha256(await readFile(modelPath)), sources };
}

export async function run(command, args, options = {}) {
  return new Promise((resolvePromise, reject) => {
    const child = spawn(command, args, { cwd: options.cwd ?? rootDir, env: options.env ?? process.env, stdio: options.stdio ?? ['ignore', 'pipe', 'pipe'] });
    let stdout = ''; let stderr = '';
    child.stdout?.on('data', data => { stdout += data; }); child.stderr?.on('data', data => { stderr += data; });
    child.on('error', reject);
    child.on('close', code => code === 0 ? resolvePromise({stdout, stderr}) : reject(new Error(`${command} ${args.join(' ')} failed (${code})${stderr ? `:\n${stderr.trim()}` : ''}`)));
  });
}

export async function locatePinnedD2() {
  const manifest = await readJson(toolManifestPath);
  const platform = process.platform; const arch = process.arch;
  const artifact = manifest.artifacts.find(item => item.platform === platform && item.arch === arch);
  if (!artifact) throw new Error(`D2 ${manifest.version} is not pinned for ${platform}/${arch}. Run "node scripts/atlas.mjs bootstrap" only on a supported platform.`);
  const executable = join(rootDir, manifest.installRoot, `${platform}-${arch}`, platform === 'win32' ? 'd2.exe' : 'd2');
  if (!await exists(executable)) throw new Error(`Pinned D2 is not installed at ${relative(rootDir, executable)}. Run "node scripts/atlas.mjs bootstrap".`);
  const version = (await run(executable, ['--version'])).stdout.trim();
  if (!version.includes(manifest.version.replace(/^v/, ''))) throw new Error(`Pinned D2 version mismatch: expected ${manifest.version}, got ${version || 'no output'}.`);
  return { executable, manifest, artifact };
}

export async function renderSvg(d2Path, svgPath) {
  const {executable} = await locatePinnedD2();
  await run(executable, ['--layout', 'dagre', '--theme', '0', '--pad', '32', d2Path, svgPath]);
  const svg = await readFile(svgPath, 'utf8');
  if (!svg.includes('<svg') || !svg.includes('</svg>')) throw new Error('D2 did not produce a complete SVG.');
}

export async function writeTree(outDir, model, options = {}) {
  await mkdir(join(outDir, 'gates'), {recursive: true});
  await writeFile(join(outDir, 'index.html'), renderIndex(model));
  await writeFile(join(outDir, 'gate-register.md'), renderRegisterMarkdown(model));
  await writeFile(join(outDir, 'gate-map.d2'), renderD2(model));
  await writeFile(join(outDir, 'gate-map.svg'), renderSvgPreview(model));
  for (const gate of model.gates) await writeFile(join(outDir, 'gates', `${gate.id}.html`), renderGatePage(model, gate));
}

export async function listFiles(path, prefix = '') {
  const files = [];
  for (const entry of await readdir(path, {withFileTypes: true})) {
    const rel = join(prefix, entry.name);
    if (entry.isDirectory()) files.push(...await listFiles(join(path, entry.name), rel)); else files.push(rel.split(sep).join('/'));
  }
  return files.sort();
}

export async function treeDigest(path) {
  const entries = [];
  for (const file of await listFiles(path)) entries.push(`${sha256(await readFile(join(path, file)))}  ${file}`);
  return sha256(Buffer.from(`${entries.join('\n')}\n`));
}

export async function safeReplace(replacements) {
  const token = `${process.pid}-${Date.now()}`; const completed = [];
  try {
    for (const {staged, target} of replacements) {
      await mkdir(dirname(target), {recursive: true});
      const backup = `${target}.atlas-backup-${token}`;
      if (await exists(target)) await rename(target, backup);
      try { await rename(staged, target); } catch (error) { if (await exists(backup)) await rename(backup, target); throw error; }
      completed.push({target, backup});
    }
    for (const item of completed) await rm(item.backup, {recursive: true, force: true});
  } catch (error) {
    for (const item of completed.reverse()) {
      await rm(item.target, {recursive: true, force: true});
      if (await exists(item.backup)) await rename(item.backup, item.target);
    }
    throw error;
  }
}

export async function assertNoExternalAssets(html, label) {
  const external = [...html.matchAll(/(?:src|href|data)=["'](https?:|\/\/)/gi)];
  if (external.length) throw new Error(`${label} contains an external HTML asset or request.`);
  if (!html.includes('Skip to main content') || !html.includes(':focus-visible') || !html.includes('name="viewport"')) throw new Error(`${label} is missing an accessibility basic.`);
}

export async function assertSafeContent(path) {
  const bytes = await readFile(path);
  const text = bytes.toString('utf8');
  const patterns = [
    [/-----BEGIN (?:OPENSSH |RSA |EC |DSA )?PRIVATE KEY-----/i, 'private key'],
    [/\b(?:ssh-rsa|ssh-ed25519)\s+[A-Za-z0-9+/]{80,}/, 'SSH public-key material'],
    [/\b(?:10\.(?:\d{1,3}\.){2}\d{1,3}|192\.168\.(?:\d{1,3}\.)\d{1,3}|172\.(?:1[6-9]|2\d|3[01])\.(?:\d{1,3}\.)\d{1,3})\b/, 'private IP address'],
    [/(?:password|client_secret|api[_-]?key)\s*[:=]\s*["'][^"']{8,}["']/i, 'obvious credential assignment']
  ];
  for (const [pattern, label] of patterns) if (pattern.test(text)) throw new Error(`${relative(rootDir, path)} contains ${label}.`);
}
