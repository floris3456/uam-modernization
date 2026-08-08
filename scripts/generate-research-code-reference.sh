#!/usr/bin/env bash
set -euo pipefail

check_only=false
if [[ "${1:-}" == "--check" ]]; then
    check_only=true
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
handover_root="$repo_root/UAM-overdracht-INTERN-2026-07-23"
output_dir="$repo_root/research/baseline/attachments"
output_path="$output_dir/code-reference.md"
temporary_path="$(mktemp)"
trap 'rm -f "$temporary_path"' EXIT

mkdir -p "$output_dir"

append_source() {
    local relative_path="$1"
    local language="$2"
    local purpose="$3"
    local full_path="$handover_root/$relative_path"
    local digest
    local line_count

    digest="$(sha256sum "$full_path" | awk '{print $1}')"
    line_count="$(wc -l < "$full_path" | tr -d ' ')"

    printf '\n## File: `%s`\n\n' "$relative_path"
    printf -- '- Purpose: %s\n' "$purpose"
    printf -- '- Language: %s\n' "$language"
    printf -- '- Lines: %s\n' "$line_count"
    printf -- '- SHA-256: `%s`\n\n' "$digest"
    printf '~~~~%s\n' "$language"
    sed -e 's/\r$//' "$full_path"
    printf '\n~~~~\n'
}

{
    printf '%s\n' '# UAM code reference for external research'
    printf '%s\n' ''
    printf '%s\n' '**Classification:** internal technical material'
    printf '%s\n' ''
    printf '%s\n' 'This mechanically generated document contains the complete code files referenced by the UAM pre-implementation research prompts. It is intended for an organization-approved ChatGPT workspace. Do not publish it or upload it to an unapproved service.'
    printf '%s\n' ''
    printf '%s\n' 'The legacy endpoint copy contains a deliberate `<REDACTED-HARDCODED-CREDENTIAL>` placeholder. The production reference-data SQL is deliberately excluded because it contains real internal URLs and application configuration. No password, token, cookie, browser profile, production data value, or unredacted credential is intentionally included.'
    printf '%s\n' ''
    printf '%s\n' 'Treat these files as evidence of current behaviour, not as a secure design specification. Dynamic SQL, external consumers, runtime configuration, and production behaviour may not be visible through static inspection.'

    append_source 'sources/legacy/uam.redacted.ps1' 'powershell' 'Redacted legacy Windows endpoint agent and primary behavioural evidence.'
    append_source 'uam-logging.ps1' 'powershell' 'Current DEV PowerShell Universal administration application.'
    append_source 'artifacts/database/01_legacy_uam_prod_schema.sql' 'sql' 'Production database structure only; contains DDL and no production data rows.'
} > "$temporary_path"

if $check_only; then
    if [[ ! -f "$output_path" ]] || ! cmp -s "$temporary_path" "$output_path"; then
        echo "Research code reference is stale: ${output_path#$repo_root/}" >&2
        exit 1
    fi
    echo "Research code reference is current."
else
    mv "$temporary_path" "$output_path"
    trap - EXIT
    printf 'Generated %s\n' "$output_path"
fi
