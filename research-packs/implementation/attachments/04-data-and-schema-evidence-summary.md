# Data and schema evidence summary

**Classification:** internal summary sanitized for an approved research chat.
**Source:** committed inventory, schema metadata, data dictionary, and final synthesis.
**Generation:** deterministic manually curated summary; no production row values or internal configuration copied.

## Legacy data shape

- 27 tables and 569 fields.
- 13 primary keys, 2 physical foreign keys, and 15 indexes in the isolated documentation schema.
- Large activity/history tables exist, but row counts are snapshots—not throughput, payload, retention, or future capacity requirements.
- Many relationships to users, HR/directory data, applications, settings, schedules, and audit are implicit in code or SQL.
- Current deferred work may contain executable SQL rather than typed events.

## Target data principles

- Separate device, installation, session, subject projection, source, generation, cursor, run, event, batch, receipt, policy, application, rule revision, health, audit, deletion, and integration concepts.
- Store only minimized typed events on endpoints; event plus cursor commits atomically.
- The server derives realm/device from authenticated registration, not payload claims.
- Distinguish durably received, validated, materialized, quarantined, and visible states.
- Use stable dedupe keys and explicit provenance. Generate aggregates server-side.
- Keep HR/directory/CMDB integrations behind narrow versioned server-side contracts.

## Missing evidence

No representative event/byte/batch/retry/outage distributions, approved retention, query corpus, RPO/RTO, or production engine benchmark is available. These require metadata-only measurement, synthetic load, restore drills, owner decisions, and reproducible CLI evidence.
