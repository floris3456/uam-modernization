# Pinned Atlas tool

The Atlas uses D2 v0.7.1 under the Mozilla Public License 2.0. D2 is the only added tool dependency. The generator itself uses Node.js built-in modules; there is no npm package tree, frontend framework, browser, Graphviz, or TALA dependency.

The version and official Linux/Windows release-archive SHA-256 values are pinned in [d2-tools.json](d2-tools.json). The values match the digests published with the official v0.7.1 GitHub release assets.

## Safe repository-local install

Run this from a Linux shell or a current Windows terminal:

```text
node scripts/atlas.mjs bootstrap
```

The command:

- supports Linux and Windows on x64 and ARM64;
- downloads only the matching pinned `tar.gz` from the official GitHub release;
- accepts redirects only to a small HTTPS GitHub host allowlist;
- computes SHA-256 while downloading and deletes a mismatch before extraction;
- rejects absolute paths and `..` archive paths;
- extracts only the named D2 executable;
- verifies `d2 --version` before the final rename; and
- installs under ignored `.tools/atlas/d2-v0.7.1/` without administrator rights.

Node.js and a `tar` command are prerequisites. Modern Windows includes `tar`; if a managed Windows image removes it, stop and add an approved pinned extraction method rather than bypassing validation. The Atlas never uses a system D2 as a fallback.

## Why SVG and Dagre

D2 renders SVG directly. Validation renders the generated D2 source twice to temporary SVG files and requires byte equality. The committed offline SVG preview is generated directly from the same Atlas model so ordinary generation does not depend on a network download. PNG and PDF use a headless browser path, so they are intentionally excluded. Dagre is D2’s bundled default layout engine and is pinned explicitly on the command line. Graphviz and the separately licensed TALA engine are not installed because no measured layout problem requires them.

The official D2 documentation says its convenience install script does not yet verify signatures. This repository therefore does not use `curl | sh` locally or in CI.
