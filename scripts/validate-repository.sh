#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

./scripts/generate-code-reference.sh
git diff --exit-code -- research-packs/attachments/UAM-CODE-REFERENCE.md
node scripts/validate-implementation-research-packs.mjs
node scripts/validate-preimplementation.mjs

if command -v pwsh >/dev/null 2>&1; then
  pwsh -NoLogo -NoProfile -File ./UAM-overdracht-INTERN-2026-07-23/scripts/Test-UamDocumentationDeliverables.ps1
else
  echo "Notice: PowerShell handover validation skipped locally because pwsh is unavailable; Windows CI runs it."
fi

echo "Repository validation passed."
