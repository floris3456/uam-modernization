# Sanitized detailed application-catalogue summary

**Classification:** Internal sanitized aggregate; safe for repository review, not automatically approved for public distribution  
**Source:** Ignored local file `applicaties_alle_zichtbare_informatie.csv`, SHA-256 `8356990630e2a7dcce2972bafb5ac572c886e2f976532b17cd892f74357110af`  
**Generation:** `node scripts/profile-detailed-application-catalogue.mjs`

## Useful facts

- 173 records and 22 columns were parsed; row numbering is sequential.
- All 173 populated application names are case-insensitively unique.
- Correlation IDs are populated for 168 records; 5 are missing and 0 populated records duplicate an ID.
- Descriptions are populated for 167 records, versions for 168, vendors for 168, functional-management fields for 171, and assignment groups for 172.
- The management-owner field is populated for only 7 records.
- The nominal GUID column contains 0 syntactically valid UUIDs and must not become the new stable identifier.
- The two catalogue corrections explicitly requested during review are present in the ignored source.
- 11 cells contain IPv4-looking text and 1 cell contains URL text, confirming that the raw CSV must not be uploaded as a research attachment.

## What this means for G0

Create UAM-owned stable fictional identifiers and treat legacy correlation IDs as nullable external references. Model aliases, ownership, match rules, status, and source provenance explicitly; catalogue population alone is not proof that those meanings are correct.

## Limitations

This output contains aggregate transcription facts only. It does not validate row values against the source system, identify real owners, approve monitoring, define match rules, or expose names and addresses. Re-run the generator after any source correction.
