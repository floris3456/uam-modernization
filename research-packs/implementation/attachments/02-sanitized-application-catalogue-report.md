# Sanitized application-catalogue report

**Classification:** internal summary sanitized for an approved research chat.
**Source:** internal CSV catalogue, profiled locally on 2026-07-31.
**Generation:** deterministic aggregate profiling by `scripts/profile-application-catalogue.mjs`.
**Source SHA-256:** `c1e186edfff01ef21bbd728e953e3c62242c88e8fffb5c4879a15c3191a0e4ed`.

## Safe structural facts

| Measure | Value |
| --- | ---: |
| Records | 173 |
| Unique application names, case-insensitive | 173 |
| Missing application names | 0 |
| Missing external correlation IDs | 5 |
| Distinct non-empty external correlation IDs | 167 |
| Duplicated non-empty ID values | 1 |
| Records sharing duplicated non-empty IDs | 2 |
| Names containing an address-like IPv4 literal in the raw source | 1 |
| Names containing non-ASCII characters | 10 |
| Names ending in a possible truncation marker | 9 |

The raw values are deliberately absent. The source contains no role, organization-unit, owner, lifecycle, sensitivity, URL/domain rule, process/publisher/product rule, alias, entitlement, or observed-usage dimension. Do not infer these from names. Legacy correlation IDs are nullable and not unique; treat them as external references, not UAM primary keys.

## Safe use

- Use counts and quality shapes to design import validation and synthetic data.
- Use fictional application names, external references, roles, URLs, processes, owners, and realms in research examples.
- Assign UAM-owned stable IDs only through a governed import.
- Never request or reproduce the raw catalogue in a web research answer.

## Limitation

This profile proves catalogue shape and a few quality conditions only. It does not prove application ownership, business purpose, user roles, matching rules, entitlement, usage, or currentness.
