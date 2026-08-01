# Existing-system evidence summary

**Classification:** internal summary sanitized for an approved research chat.
**Source:** committed redacted legacy agent, DEV administration app, and production-schema metadata.
**Generation:** deterministic metadata-only summary from committed sources. No source code, URLs, credentials, production values, or SSH material is copied.

## Source fingerprints

| Evidence | Size/shape | SHA-256 | What it supports | Limitation |
| --- | --- | --- | --- | --- |
| Redacted legacy endpoint agent | 4,805 lines; 53 function definitions | `541931436f59f0a18e6637c6f2bfb136d0da238b2751b716a0500492d44c5935` | Current orchestration, collectors, settings, checkpoints, deferred writes, SQL coupling, and error handling | One credential is redacted; runtime configuration and external consumers are absent |
| DEV PSU administration app | 1,217 lines | `fb9bcdb8ae9653fbbd7cce00432c97197a31503cd0ea57fd3366d0de809b2176` | Current administrative modules, queries, settings, organization views, matches, errors, and audit | DEV differs from inspected production; it is not a secure target design |
| Production database DDL | 27 tables; 569 fields; 13 PKs; 2 FKs | `2dcfc2009d3a09b7e56db4be2bc8db611f6832c121db17987df140eacd1a3c63` | Physical legacy schema and weak/implicit relationship surface | DDL does not prove semantics, consumers, rates, values, or data quality |

## Proved legacy characteristics

- A monolithic PowerShell endpoint combines collection, scheduling, database access, deferred execution, recovery, and restart behavior.
- Endpoints write directly to Microsoft SQL Server and may defer executable SQL text through CSV.
- Collection is user/profile/session dependent and includes browser, Recent/Quick Access, and process families.
- Settings, user overrides, checkpoints, application matching/exclusions, errors, schedules/scripts, aggregates, and audit exist in some form.
- The administration app and schema contain customer-specific HR/directory relationships and broad mutation surfaces.

## Evidence limits

Static inspection cannot reveal every dynamic SQL path, production setting, report, manual consumer, runtime volume, external integration, or operational practice. Presence in legacy code is evidence of behavior, not approval to preserve it. The full code reference is intentionally not an automatic attachment for focused implementation research.
