#!/usr/bin/env bash
set -euo pipefail

# Local web-lane boundary health check (Semantic System Review, A1/A3).
# Verifies the confidentiality invariant: NO protected-boundary path may be
# present in either retrieval index. Run locally on the machine that hosts the
# index stores (~/.code-index, ~/.doc-index); CI cannot see user-home stores.
# After any jCode upgrade/rebuild/restart, this is the machine check that the
# protected count is zero again (the 09:55 boot-reindex resurrection scenario).

code_db="$HOME/.code-index/floris3456-uam-modernization.db"
doc_idx="$HOME/.doc-index/local/uam-modernization.json"
fail=0

if [[ -f "$code_db" ]]; then
  count=$(sqlite3 -readonly "$code_db" "SELECT COUNT(*) FROM files WHERE path LIKE 'UAM-overdracht-INTERN-%' OR path LIKE 'raw-database-evidence/%';")
  if [[ "$count" != "0" ]]; then
    echo "FAIL: jCodeMunch indexes $count protected file(s). Purge + rebuild, verify after restart." >&2
    fail=1
  else
    echo "ok: jCodeMunch protected count = 0"
  fi
else
  echo "skip: jCodeMunch index db not found ($code_db)"
fi

if [[ -f "$doc_idx" ]]; then
  bad=$(python3 -c "
import json
idx = json.load(open('$doc_idx'))
bad = [p for p in idx.get('doc_paths', []) if 'UAM-overdracht-INTERN-' in p or 'raw-database-evidence/' in p]
print('\n'.join(bad))
")
  if [[ -n "$bad" ]]; then
    echo "FAIL: jDocMunch indexes protected path(s):" >&2
    echo "$bad" >&2
    fail=1
  else
    echo "ok: jDocMunch has no protected doc paths"
  fi
else
  echo "skip: jDocMunch index not found ($doc_idx)"
fi

if [[ $fail -eq 0 ]]; then
  echo "Web-lane boundary check passed."
else
  exit 1
fi
