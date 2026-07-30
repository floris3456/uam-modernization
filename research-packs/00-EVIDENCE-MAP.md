# UAM evidence map

Use this map when reviewing research answers. A web researcher should not claim that an item was proven by source when it was only proposed in documentation.

| Evidence | What it supports | Important limitation | In code attachment |
| --- | --- | --- | --- |
| `sources/legacy/uam.redacted.ps1` | Endpoint orchestration, collectors, settings, checkpoints, buffering, SQL, logging, and error handling | One credential is redacted; runtime configuration and external systems are absent | Yes, complete |
| `uam-logging.ps1` | DEV PSU portal structure, queries, grids, settings, organization view, exclusions, matches, errors, and audit | DEV source differs in size from the inspected production app; production source is not included | Yes, complete |
| `artifacts/database/01_legacy_uam_prod_schema.sql` | Physical legacy database objects, fields, keys, indexes, and defaults | DDL does not reveal all implicit relationships, consumers, volume, or data quality | Yes, complete |
| `docs/00a-uam-ist-samenvatting-a4.md` | Reviewed short description of the current state and risks | Secondary summary | No; summarized in each prompt |
| `docs/04-csharp-target-architecture.md` | Proposed target component design and rationale | Proposal, not an approved or benchmarked implementation | No; summarized in each prompt |
| `docs/05-migration-map-roadmap.md` | Proposed phases, migration mapping, acceptance ideas, and open decisions | Planning input, not committed scope | No; relevant points are embedded in prompts 01–06 |
| `artifacts/database/00_legacy_uam_prod_inventory.*` | Table counts, row counts, and physical inventory | Snapshot only; not an event-rate or capacity dataset | No |
| `artifacts/database/00_legacy_uam_prod_column_profile.json` | Per-column population counts | Contains counts, not values or semantic correctness | No |
| `artifacts/database/02_legacy_uam_reference_data.sql` | Real configuration examples | Confidential internal URL/application data; must not be uploaded | Deliberately excluded |
| Sanitized samples and screenshots | Examples of current data/UI behaviour | Not representative proof of all production behaviour | No |

## Evidence rules for synthesis

- “Present in code” does not mean “required in the replacement.”
- “Proposed in target documentation” does not mean “validated.”
- Production row counts do not establish events per second, payload size, or future scale.
- Static code analysis cannot prove runtime reliability, privacy correctness, or all external dependencies.
- Current platform/version claims must come from fresh primary web research, not this July 2026 package alone.
