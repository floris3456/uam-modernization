# UAM pre-implementation research packs

These prompts are designed for separate ChatGPT web chats with web research enabled. Run packs 01–06 in parallel, then run pack 07 after saving their complete results.

## Before uploading anything

The supplied code reference is internal technical material. Use only an organization-approved ChatGPT workspace and confirm its data-handling policy. Do not upload `02_legacy_uam_reference_data.sql`; it contains real internal URLs and application configuration.

## Files to upload

Upload [`attachments/UAM-CODE-REFERENCE.md`](attachments/UAM-CODE-REFERENCE.md) to chats 01–06. Each prompt says which sections matter most. Pack 07 needs the six research results rather than the code reference.

## Execution map

| Pack | Purpose | Can run immediately | Suggested result filename |
| --- | --- | --- | --- |
| 01 | Validate the proposed architecture | Yes | `01-architecture-result.md` |
| 02 | Select languages and full stack | Yes | `02-language-stack-result.md` |
| 03 | Security and privacy threat model | Yes | `03-security-privacy-result.md` |
| 04 | Windows feasibility and prototypes | Yes | `04-windows-feasibility-result.md` |
| 05 | Scale, reliability, and capacity | Yes | `05-scale-reliability-result.md` |
| 06 | Requirements and migration | Yes | `06-requirements-migration-result.md` |
| 07 | Reconcile all findings into one baseline | After 01–06 | `07-synthesis-result.md` |

## How to run a pack

1. Start a fresh ChatGPT web chat with deep web research enabled.
2. Upload the requested attachment(s).
3. Paste the complete prompt without shortening it.
4. Let the agent ask only questions that truly block research; otherwise it must state assumptions.
5. Save the complete answer, including links, tables, uncertainties, and proposed experiments.

## Quality bar

The prompts require current primary sources, explicit assumptions, alternatives, failure analysis, confidence labels, and measurable recommendations. Vendor claims must be distinguished from independently demonstrated behaviour. “It depends” is not an answer unless the deciding conditions and a recommended default are provided.

