# ADR-FS-003 — Contract and identifier rules

- **Status:** Experimenting
- **Date:** 2026-08-01
- **Owner:** Unassigned; contract authority must assign one

## Decision

Use versioned, closed contracts with strict validation. Unknown fields, duplicate fields, wrong casing, invalid values, and unsafe defaults fail validation.

Use:

- JSON Schema 2020-12 for structural contracts;
- lower-case UUIDv7 for new UAM identifiers;
- SHA-256 for content and evidence digests;
- explicit UTC timestamps and stated precision; and
- text normalization rules defined separately for each field.

Physical IPC encoding remains undecided until strict JSON and deterministic CBOR are compared.

## Why

Loose contracts create silent compatibility, privacy, identity, and migration errors. One global text-normalization rule would also change values whose exact spelling matters.

## Alternatives considered

- Accept unknown fields for forward compatibility: rejected because an unknown field could carry unauthorized data.
- Use names, paths, or external catalogue IDs as UAM identity: rejected because they can change, collide, or be missing.
- Normalize every string globally: rejected because field semantics differ.
- Select JSON, CBOR, or Protobuf immediately: deferred until measured.

## Consequences

- Every contract requires valid, boundary, invalid, and compatibility examples.
- Changes require explicit compatibility rules and migrations.
- External identifiers remain references, not UAM primary keys.
- Parser resource limits and physical codecs remain evidence-backed profiles.

## Required before acceptance

- Parser, schema-validator, UUID, time, Unicode, and compatibility vectors pass.
- Selected tooling passes hostile input and resource tests.
- Remote schema resolution is disabled for locked builds.

## Revisit when

Interoperability evidence, a contract migration, or a security finding shows that the selected profile is insufficient.

## Source

[Final synthesis, sections 5, 9 and 11](../../research-packs/implementation/results/final-synthesis/next-generation-technical-baseline-result.md).
