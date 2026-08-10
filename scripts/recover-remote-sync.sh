#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[[ -n "$repo_root" ]] || { echo "Not in a Git repository." >&2; exit 1; }
cd "$repo_root"

branch="$(git symbolic-ref --quiet --short HEAD || true)"
[[ "$branch" == "developer" ]] || { echo "Synchronization recovery is defined for developer only." >&2; exit 1; }
[[ -z "$(git status --porcelain)" ]] || { echo "Working tree must be clean before recovery." >&2; exit 1; }
./scripts/bootstrap-agent-workflow.sh --check >/dev/null

git fetch origin developer
local_sha="$(git rev-parse HEAD)"
remote_sha="$(git rev-parse origin/developer)"
marker="$(git rev-parse --git-dir)/uam-sync-failed"
recovery_authorized="$(git rev-parse --git-dir)/uam-sync-recovery-authorized"
cleanup_authorization() { rm -f "$recovery_authorized"; }
trap cleanup_authorization EXIT

verify_synchronized() {
  git fetch origin developer
  local verified_local verified_remote
  verified_local="$(git rev-parse HEAD)"
  verified_remote="$(git rev-parse origin/developer)"
  if [[ "$verified_local" != "$verified_remote" ]]; then
    {
      printf '%s\n' developer
      printf '%s\n' "$verified_local"
      date -u +'%Y-%m-%dT%H:%M:%SZ'
    } > "$marker"
    echo "Synchronization is not yet confirmed: local $verified_local, remote $verified_remote" >&2
    return 1
  fi
  rm -f "$marker"
  echo "Synchronization verified at $verified_local"
}

if [[ "$local_sha" == "$remote_sha" ]]; then
  verify_synchronized
  exit 0
fi

if git merge-base --is-ancestor "$remote_sha" "$local_sha"; then
  git push origin HEAD:developer
  verify_synchronized
  exit 0
fi

if git merge-base --is-ancestor "$local_sha" "$remote_sha"; then
  git merge --ff-only origin/developer
  verify_synchronized
  exit 0
fi

[[ -f "$marker" ]] || { echo "Divergent recovery requires the failed-push marker." >&2; exit 1; }
marker_branch="$(sed -n '1p' "$marker" 2>/dev/null || true)"
marker_sha="$(sed -n '2p' "$marker" 2>/dev/null || true)"
[[ "$marker_branch" == "developer" && "$marker_sha" == "$local_sha" ]] || {
  echo "Synchronization marker does not match the current developer head." >&2
  exit 1
}

printf '%s %s\n' "$local_sha" "$remote_sha" > "$recovery_authorized"
if ! git merge --no-ff --no-edit -m "Recover developer synchronization" "$remote_sha"; then
  git merge --abort >/dev/null 2>&1 || true
  echo "Divergent synchronization recovery conflicted or failed; both histories and the failure marker were retained." >&2
  exit 1
fi

merge_sha="$(git rev-parse HEAD)"
[[ "$(git rev-parse "$merge_sha^1")" == "$local_sha" ]] || { echo "Unexpected recovery first parent." >&2; exit 1; }
[[ "$(git rev-parse "$merge_sha^2")" == "$remote_sha" ]] || { echo "Unexpected recovery second parent." >&2; exit 1; }
{
  printf '%s\n' developer
  printf '%s\n' "$merge_sha"
  date -u +'%Y-%m-%dT%H:%M:%SZ'
} > "$marker"
git push origin HEAD:developer
verify_synchronized
