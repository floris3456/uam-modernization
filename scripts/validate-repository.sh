#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

# Web-safe trust lane (Semantic System Review, A9.2): check-only, no tracked-file
# writes, no protected-boundary reads. Everything here can run in read-only
# delegation sessions and on any runner.
#
# Protected lane (code-reference regeneration/freshness and handover validation)
# reads protected handover material and is owned by the Windows CI workflow
# (.github/workflows/validate-handover.yml) and trusted local sessions — it must
# never run in the web lane.
node scripts/validate-research.mjs
node scripts/generate-research-evidence-manifest.mjs --check
node scripts/validate-preimplementation.mjs

echo "Repository validation passed."
