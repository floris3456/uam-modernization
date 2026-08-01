# UAM application registry, aliases, ownership, and URL/process matching

**Result path:** `batches/01-foundations/04-application-registry-matching/result-04-application-registry-matching.md`  
**Research date:** 31 July 2026  
**Status:** Proposed implementation foundation; not production authorization  
**Scope:** Application registry, import quality, application ownership metadata, URL/domain and process matching rules, conflict analysis, endpoint snapshot publication, simulation, and realm isolation  
**Evidence classification:** Sanitized internal summaries plus current primary public sources only  

> **Primary publication gate:** **No real rule is published without owner, purpose, revision, synthetic test examples, conflict result, approval, and a tested rollback path.**

## Evidence labels used in this result

- **FACT** — directly supported by an allowed attachment or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from facts; the reasoning is stated.
- **ESTIMATE** — a replaceable numerical hypothesis, never an approved limit.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — evidence is missing.
- **HUMAN DECISION** — organizational, legal, ownership, budget, risk, or business authority is required.
- **CLI EXPERIMENT** — code or lab evidence must establish the claim.

Normative words **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** apply to the proposed UAM implementation in this result. They do not imply that a human policy decision has already been approved.

---

# 1. Executive conclusion

## 1.1 Decision in easy language

**RECOMMENDATION — High confidence:** UAM should own a permanent, opaque application identifier for every application. A catalogue name, alias, CMDB key, or legacy correlation ID must never become that identity. External keys remain optional, source-qualified references. Names and aliases are for people to find and reconcile records; they are never executable matching rules.

**RECOMMENDATION — High confidence:** Rules should use a small, versioned grammar rather than regular expressions, scripts, fuzzy matching, or a general policy language. URL rules should match normalized HTTP(S) hosts and, only after a separate privacy gate, simple exact/prefix paths. Process rules should prefer a verified signer profile plus product metadata, then exact or segment-prefix paths rooted at approved Windows known folders. A filename-only rule is an explicitly disabled-by-default last resort.

**RECOMMENDATION — High confidence:** Matching must be deterministic and fail safely. After priority and provable specificity are applied:

- one winning application means `MATCHED`;
- several equally maximal rules for the same application still mean `MATCHED`;
- equally maximal rules for different applications mean `AMBIGUOUS`, with no application assignment;
- malformed input, unavailable process metadata, incompatible normalization, or an unusable snapshot never becomes a guessed match.

**RECOMMENDATION — High confidence:** URL and process values are matched in the user/session-side collection boundary before Coordinator IPC. Endpoint snapshots contain only opaque application IDs and minimized compiled predicates. They exclude display names, aliases, owners, categories, sensitivity labels, external keys, CMDB references, raw URLs, and raw executable paths. This preserves the accepted endpoint-minimization boundary.

**RECOMMENDATION — Medium confidence pending measurement:** Publish a complete, immutable, signed snapshot per realm first. The Coordinator verifies the signature, realm, product privacy ceiling, sequence, compatibility, times, hash, and size limits; it atomically activates the new snapshot while retaining a last-known-good predecessor. Rollback is a new higher-sequence publication of previously approved content, never a sequence downgrade.

**FACT:** The sanitized catalogue has 173 rows and 173 case-insensitively distinct names, but five rows lack external correlation IDs. No duplicate non-empty IDs were observed in that one snapshot. The evidence supplies no owner, role, lifecycle, sensitivity, alias, entitlement, usage, URL rule, or process rule dimensions. Therefore it cannot justify identity or rules derived from names, and the populated external IDs do not prove a durable uniqueness contract. [S-INT-02]

**INFERENCE:** The simplest safe architecture is therefore a UAM registry with immutable revisions and explicit provenance, plus a deliberately restricted matcher. This follows from the missing authority dimensions in the catalogue, the accepted endpoint privacy boundary, offline operation, realm isolation, and the need for deterministic rollback. [S-INT-01] [S-INT-02] [S-INT-03]

## 1.2 Decision summary

| Decision | Proposed result | Confidence | Main residual risk |
|---|---|---:|---|
| Stable application identity | Realm-scoped UAM UUIDv7; immutable and never reused | High | Incorrect human merge/split decisions remain possible |
| External IDs | Optional, source-qualified, non-authoritative references | High | Source semantics and future duplicates are unknown |
| Names and aliases | Search/reconciliation only; never matching or identity | High | Unicode spoofing and unsafe labels need review tooling |
| Rule language | Closed, typed URL/process grammar; no arbitrary regex/scripts | High | Future use cases may request unsupported expressiveness |
| Rule precedence | Priority, family authority, then partial-order specificity; no author-order tie-break | High | Analyzer implementation must prove parity with endpoint |
| Ambiguous/unknown behavior | No assignment; bounded reason code only | High | More unmatched data until governance improves rules |
| URL normalization | Versioned HTTP(S) pipeline using WHATWG/UTS #46 rules and golden fixtures | Medium | Browser/.NET differentials require conformance experiments |
| Process identity | Verified signer profile preferred; path rules constrained to known-folder tokens | Medium | TOCTOU, cert rollover, inaccessible files, filesystem edge cases |
| Endpoint distribution | Full signed realm snapshot, last-known-good, monotonic sequence | Medium | Size/startup budgets are not yet measured |
| Conflict analysis | Exact static overlap/shadow analysis for the restricted grammar | High for design; Medium for implementation | False negatives must be ruled out by generated fixtures |
| Import workflow | Strict staging, quarantine, human mapping, atomic apply; never publishes rules | High | Source-of-truth and retention decisions are missing |
| Operational roles | Explicit owner fields and separation-of-duty hooks, but no roles invented | Low | Accountable organizational assignments are unresolved |

## 1.3 Confidence and residual risk

The conclusion is **High confidence** for identity, non-authoritative aliases/external keys, restricted grammar, deterministic ambiguity, realm-scoped data, and publication gates. These are directly supported by the supplied data shape, accepted privacy/isolation baseline, and stable standards.

Confidence is **Medium** for exact URL normalizer behavior, Windows process metadata reliability, snapshot size, activation latency, and compiler/analyzer performance. Documentation proves APIs and standards exist, not that the proposed implementation meets UAM budgets on managed endpoints. Those claims require the CLI experiments in sections 8 and 11.

Confidence is **Low** for ownership authority, approved categories and sensitivity, who may approve/publish/retire, operational staffing, retention, and numerical budgets. These are explicitly human decisions or unknowns.

No accepted baseline decision is contradicted, so this result does not raise a baseline change proposal.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 In scope

This result defines:

1. UAM-owned application identity and immutable registry revisions.
2. Optional external keys, aliases, provenance, lifecycle, ownership assignments, sensitivity/category assignments, and CMDB links.
3. Import staging and quality controls for the sanitized catalogue shape.
4. A versioned URL/domain and Windows process matching grammar.
5. Deterministic match precedence, ambiguity, shadowing, and conflict rules.
6. Rule authoring, simulation, approvals, publication, rollback, and retirement.
7. Per-realm signed endpoint snapshots and endpoint activation.
8. Security/privacy failures, observability, feature flags, kill switches, incident handling, tests, fitness functions, and implementation gates in this topic's boundary.

## 2.2 Non-goals

This result does **not**:

- decide legal purpose, prohibited uses, employee consultation, retention, identity precision, or access policy;
- decide application owners, source of truth, category taxonomy, sensitivity taxonomy, or administrative roles;
- infer real rules, owners, roles, or sensitivity from catalogue names;
- redesign endpoint acquisition, durable event delivery, the portal, the database engine decision, or the broader UAM data platform;
- authorize raw URL, query, fragment, executable path, command-line, user profile, or production activity collection;
- propose endpoint access to CMDB/HR systems or central database credentials;
- make UAM telemetry forensic proof, entitlement truth, or a productivity score;
- require a public-suffix-list dependency, external broker, general policy engine, feature-flag SaaS, or separate microservice.

## 2.3 Accepted project inputs

Only the four allowlisted files were used.

| Source | Classification/status | Accepted fact used | Limitation retained |
|---|---|---|---|
| `00-accepted-baseline-attachment.md` | Sanitized working baseline dated 31 July 2026 | Endpoint trust boundaries, minimization before Coordinator IPC/storage/logs/transport, offline operation, realm isolation, recoverable releases, C#/.NET default, first Edge site/domain slice | Not production approval; exact fields, limits, retention, PKI, budgets, SLOs and roles remain gated |
| `02-sanitized-application-catalogue-report.md` | Sanitized aggregate profile, locally generated 31 July 2026 | 173 records; 5 missing external IDs; no observed duplicate non-empty IDs; Unicode, IPv4-like and truncation quality shapes; no owner/rule/role dimensions | No raw values; one snapshot cannot prove semantics, authority, uniqueness contract or currentness |
| `04-data-and-schema-evidence-summary.md` | Sanitized target-data principles | Separate application/rule revisions and provenance; stable dedupe; realm/device derived from authenticated context; narrow integrations | No future volume, retention, RPO/RTO or production-engine benchmark |
| `06-research-evidence-rules.md` | Research quality rules | Evidence labels, primary-source preference, lab-proof boundaries, no sensitive data | Governs method; does not prove a technical claim |

## 2.4 Assumptions

| ID | Assumption | Consequence if false | Required response |
|---|---|---|---|
| A-01 | Each authenticated administrative request can be bound to exactly one effective realm unless it uses a separately controlled cross-realm operations context. | A payload-supplied realm could cause isolation failure. | Stop implementation and resolve identity/context contract before any registry API. |
| A-02 | The product privacy ceiling can enumerate allowed matcher families and allowed fields by release. | Tenant configuration might expand collection beyond product authorization. | Add that capability to release authorization before endpoint matching. |
| A-03 | Synthetic fixtures can represent URL and process edge cases without production values. | Conformance tests could require sensitive evidence. | Build a fixture generator and reserved `.test` corpus first. |
| A-04 | UAM can ship one shared pure matcher library to simulator and endpoint host components. | Server and endpoint may disagree. | Require golden cross-language/byte-for-byte vectors; reconsider implementation family only through ADR. |
| A-05 | Endpoint device authentication supplies realm out of band. | Snapshot audience checks would trust a request parameter. | Block publication/download until authenticated registration contract exists. |
| A-06 | UUIDv7 is available in the chosen execution-time .NET/runtime or can be generated by a small reviewed implementation. | ID generation may not be monotonic/standards-conformant. | Use UUIDv4 temporarily or a reviewed UUIDv7 library; never derive IDs from source data. |

## 2.5 Unknowns and deliberately unresolved matters

| ID | Unknown | Why it matters | Resolution authority/evidence |
|---|---|---|---|
| U-01 | Which system is authoritative for which application fields | Controls overwrite and conflict rules | **HUMAN DECISION:** application-data governance owner; field-authority matrix |
| U-02 | Approved application owners and owner identifiers | Publication gate requires accountable ownership | **HUMAN DECISION:** accountable business/technology governance |
| U-03 | Approved categories and sensitivity vocabulary | Determines central presentation/access, not endpoint matching | **HUMAN DECISION:** privacy/security/data governance |
| U-04 | Who may create, review, approve, publish, retire or emergency-disable rules | Determines separation of duties | **HUMAN DECISION:** security and platform governance |
| U-05 | Whether URL paths may be matched | Paths can disclose sensitive structure | **HUMAN DECISION:** release privacy authority; path feature remains off |
| U-06 | Whether per-user application paths are allowed | User profile paths increase privacy and spoof risk | **HUMAN DECISION:** product privacy and endpoint security; default deny |
| U-07 | Exact snapshot size, startup, CPU and memory budgets | Determines whether full snapshots remain viable | **CLI EXPERIMENT:** synthetic 1k/10k/100k rules on representative endpoints |
| U-08 | Soft/hard snapshot expiry and offline revocation tolerance | Balances offline continuity and stale-rule risk | **HUMAN DECISION** informed by outage and incident drills |
| U-09 | Import staging retention | Staged labels may be confidential reference data | **HUMAN DECISION:** records/privacy/security |
| U-10 | Supported Windows editions/filesystems/VDI variants | Affects path and signature behavior | **CLI EXPERIMENT:** approved lab matrix |
| U-11 | Exact administrative accessibility target beyond the WCAG recommendation | Affects acceptance tests and procurement | **HUMAN DECISION:** product owner/accessibility authority |
| U-12 | Numerical error-rate, ambiguity-rate and operational alert thresholds | Cannot be invented from prose | **HUMAN DECISION** after synthetic and pilot baselines |

---

# 3. Recommended design with exact component responsibilities and trust boundaries

## 3.1 Architectural position

**RECOMMENDATION:** Implement the registry, rule lifecycle, simulator, analyzer and snapshot compiler as modules inside the accepted server modular monolith. Implement matching as a small deterministic C# library reused by the server simulator/compiler and the appropriate endpoint host. Do not deploy a policy-engine sidecar or separate registry service in the first version.

The design has four data planes:

1. **Central registry plane** — human-facing identities, labels, aliases, ownership, categories, sensitivity, external references and CMDB links.
2. **Central rule-control plane** — immutable rule revisions, tests, analyses, approvals, publication and audit.
3. **Endpoint configuration plane** — signed, realm-specific, minimized matcher snapshots.
4. **Endpoint evaluation plane** — user/session-side URL matching and restricted Task Host process matching before privacy-boundary crossing.

Only opaque application/rule/snapshot identifiers and the minimized match result cross from the endpoint evaluation plane to Coordinator IPC. Central display metadata never needs to be present on an endpoint.

## 3.2 Components and responsibilities

| Component | Runs where | Responsibilities | Must not do | Trust boundary |
|---|---|---|---|---|
| Registry module | Server modular monolith | Create UAM application IDs; store immutable revisions, aliases, external refs, ownership/taxonomy/CMDB links and provenance; expose realm-scoped APIs | Infer identity or rules from labels; publish snapshots; allow cross-realm references | Authenticated admin/BFF to realm-scoped server data |
| Import staging module | Server | Accept bounded sanitized imports; parse/validate; produce row-level quality codes and keyed fingerprints; support human mapping; atomically apply approved changes | Log or export raw values broadly; auto-merge by name; create/publish rules; execute spreadsheet formulas | Untrusted file to restricted staging store |
| Rule authoring module | Server | Create immutable rule revisions and fictional test cases; require owner/purpose/effective dates/rollback metadata | Execute arbitrary expressions; accept raw production observations as fixtures | Authenticated administrator to governed configuration |
| Rule analyzer | Server/CLI | Normalize rules; prove overlap, dominance, redundancy, ambiguity and shadowing for the closed grammar; emit deterministic evidence | Treat `UNKNOWN` analysis as safe; inspect production activity | Untrusted authored rules to publish gate |
| Rule simulator | Server/CLI | Run the exact matcher core against synthetic fixtures; show candidate and precedence explanations to authorized administrators | Become a separate interpretation of matcher semantics; expose endpoint raw values | Admin test surface; no production observation input by default |
| Snapshot compiler | Server | Select approved effective rules for one realm; enforce product ceiling; compile canonical minimized payload; run final analysis; calculate hashes and size evidence | Include central labels/owners/external refs; compile unapproved or cross-realm objects | Central rich metadata to minimized endpoint configuration |
| Snapshot signing/publishing module | Server/release-controlled signer | Sign canonical manifest, allocate monotonic realm sequence, persist immutable artifact, expose authenticated endpoint download | Sign arbitrary bytes supplied by clients; reuse/decrease sequence; bypass audit | Highly controlled signing key boundary |
| Coordinator snapshot manager | Low-privilege machine service | Download using authenticated device context; verify envelope; enforce realm/sequence/compatibility/times/sizes; atomically activate pending/current/previous snapshots; report bounded health | Match user-owned raw URL data; crawl profiles; accept payload-supplied realm; log rules/raw values | Server configuration to local machine trust store/SQLite |
| User Host URL matcher | Ordinary user token, one per eligible session | Normalize the URL in-memory; match host/path rule; emit only minimized result/status | Send raw URL, query, fragment or candidate list to Coordinator; access another session | User/session privacy boundary to Coordinator IPC |
| Restricted Task Host process matcher | Short-lived restricted process | Acquire bounded process image metadata, verify signer, normalize known-folder path, match, clear buffers, return minimized result/status | Collect command line/window title/user data; run arbitrary plugins/scripts; keep raw path in logs | Risky Windows metadata boundary to User Host/Coordinator contract |
| Registry administration UI/BFF | Server | Accessible review, diff, conflict explanation, approval, publication and rollback workflows | Let colour alone communicate status; expose cross-realm search by default; silently normalize display labels | Human administrative boundary |
| Audit writer | Server | Durably record privileged mutations, approvals, publication, rollback and emergency switches before acknowledging success | Store forbidden endpoint raw data; permit mutation when audit write fails | Privileged action to durable audit evidence |

## 3.3 Trust-boundary rules

1. **Realm comes from authentication, never the request body.** Every primary key and foreign key in this module includes `realm_id`; repository methods require a non-null `RealmContext`; database constraints reject cross-realm references. PostgreSQL row-level security may be defense in depth if that engine is selected, but composite keys, query scoping and API authorization remain mandatory because table owners and `BYPASSRLS` roles can bypass RLS. [S-WEB-23]
2. **User/session boundary remains a security and privacy boundary.** URL input is evaluated in the User Host. Process metadata is evaluated only in the approved restricted host. No central-only enrichment is sent to endpoints.
3. **Compiled snapshot is untrusted until fully verified.** Transport authentication does not replace signature, hash, realm, monotonic sequence, compatibility, expiry and bounded-decompression checks.
4. **Imported files and authored rules are hostile input.** Parsers use bounded arrays/strings, no expression evaluation, no dynamic code, and structured error returns. Fuzzing is required for import, normalization and snapshot decoding.
5. **Signer and compiler are separate authorities.** The signer accepts only compiler artifacts with a completed gate record and exact payload hash. A compromised compiler must not be able to sign without the signing authorization path; a signer cannot invent a rule.
6. **Audit is part of success.** A privileged registry/rule/publication mutation fails if the audit record cannot be durably committed in the declared failure domain.

## 3.4 Stable application identity

### 3.4.1 Normative identity rules

- `application_id` **MUST** be a UAM-generated UUIDv7 conforming to RFC 9562, scoped by `realm_id`. [S-WEB-07]
- It **MUST NOT** contain, hash, encode, or be deterministically derived from a display name, alias, URL, process name, publisher, external key, CMDB key, owner, category, tenant name, or production activity.
- Once allocated, an ID **MUST NOT** be reused, including after retirement, merge, import reversal, or realm deletion.
- A merge **MUST** preserve both IDs, mark one as `MERGED`, and point to a same-realm successor. Existing historical facts are not silently rewritten; any rematerialization is a separate governed data operation outside this result.
- A split **MUST** allocate new application IDs and preserve lineage. It cannot repurpose the old ID to mean only one child.
- A record without an approved canonical label may exist only in `DRAFT` or import quarantine; it cannot become active or a rule target.

**Why UUIDv7:** It is opaque and standard while providing broadly time-ordered values useful for indexes and operational tracing. Time ordering is not a source timestamp and must never be used as a legal or business event time. [S-WEB-07]

### 3.4.2 Application lifecycle

`DRAFT -> ACTIVE -> RETIRED` and `ACTIVE|RETIRED -> MERGED` are allowed. `MERGED` and tombstone records are terminal. Reactivation of a retired logical application requires a new approved revision of the same ID only when governance confirms it is the same continuing identity; otherwise allocate a new ID.

### 3.4.3 Revision behavior

Human-readable and governance fields live in immutable `application_revision` records. The logical `application` row points to one current approved revision. An approved revision can be superseded, not edited. Draft corrections may be replaced before approval, with audit preserved.

## 3.5 External references

**RECOMMENDATION:** Model each external key as a separate, source-qualified claim:

`(realm_id, application_id, external_system_id, key_type, exact_external_key, contract_revision, valid interval, provenance)`.

Rules:

- Absence of a row represents a missing external key. A present key is non-null.
- External keys are non-authoritative for UAM identity unless a human-approved source contract explicitly grants authority for a named field and scope.
- Comparison semantics are source-contract-specific. The default is ordinal exact comparison after only transport decoding; UAM must not case-fold or trim a key unless the source contract says those transformations preserve identity.
- Uniqueness is not assumed globally. A source contract may declare uniqueness within a realm and key type; only then may a corresponding database constraint be enabled after duplicate evidence is clean.
- A later duplicate, key reuse, or source correction creates a conflict case. It never causes an automatic merge.
- External keys, including the five missing values in the supplied catalogue profile, never enter endpoint snapshots.

## 3.6 Names and aliases

Names and aliases serve search, reconciliation and display only.

- Preserve the approved display string in Unicode NFC and keep the original import value in restricted staging for the approved staging-retention period. UAX #15 defines normalization forms; normalization is not a security test. [S-WEB-06]
- Maintain a separate versioned search key. Search normalization may apply NFC, whitespace canonicalization and culture-independent case folding, but it **MUST NOT** change the stored display value or create identity.
- Detect and visibly flag bidi controls, default-ignorable characters, mixed scripts and confusable skeleton collisions. UTS #39 skeletons are comparison aids, not normalized display values and not automatic identity. [S-WEB-05]
- Non-ASCII text is valid. The ten non-ASCII catalogue names are a test requirement, not a defect. [S-INT-02]
- An address-like IPv4 literal, unsafe control, leading/trailing whitespace, or possible truncation marker receives a quality code and review. It is never silently “fixed.” The nine possible truncations block activation until a reviewer supplies an approved canonical label or confirms the value. [S-INT-02]
- Duplicate search keys and aliases may exist across applications, but the UI must present an ambiguity warning. They do not cause auto-merge.
- An alias has type (`DISPLAY_VARIANT`, `FORMER_NAME`, `PRODUCT_NAME`, `SEARCH_TERM`, `SOURCE_LABEL`), language tag when known, provenance and effective dates.

## 3.7 Ownership, category, sensitivity and CMDB links

These are central governance metadata, not matcher inputs.

- Ownership is a revisioned assignment to an opaque subject/team reference from an approved server-side directory contract. UAM does not invent the owner or source.
- Category and sensitivity are assignments to revisioned, realm-scoped taxonomy terms. The accepted vocabulary and meaning are **HUMAN DECISION**.
- CMDB links are source-qualified references with relationship type (`REPRESENTS`, `DEPLOYMENT_OF`, `RELATED_TO`, or a future approved vocabulary), provenance, confidence status and effective dates.
- No owner, category, sensitivity or CMDB field may be inferred from a name, URL, signer or observed use.
- A field-authority matrix determines which source may propose or overwrite each field. Until approved, imports may only create draft proposals.
- These fields are excluded from endpoint snapshots and match telemetry.

## 3.8 Rule model

A logical `rule_id` has immutable `rule_revision` children. Every revision targets exactly one same-realm `application_id`, has one matcher kind, one normalization version, a half-open effective interval `[effective_from, effective_to)`, an owner reference, purpose, priority, tests, analysis, approval and rollback metadata.

### 3.8.1 Closed grammar

The first version supports these rule families only:

| Matcher | Family | Default | Relative authority within equal priority | Notes |
|---|---|---:|---:|---|
| URL | `URL_HOST` | Enabled after release authorization | 100 | Exact/suffix HTTP(S) host; optional exact port; no query/fragment/userinfo |
| URL | `URL_HOST_PATH` | Disabled | 110 | Same plus exact or segment-prefix path; requires separate privacy approval |
| Process | `SIGNED_PRODUCT` | Disabled until process slice approved | 300 | Verified Authenticode trust plus approved signer profile; optional product/original filename/version bounds |
| Process | `PATH_EXACT` | Disabled until process slice approved | 220 | Exact path from approved known-folder token and literal segments |
| Process | `PATH_PREFIX` | Disabled until process slice approved | 210 | Segment-boundary prefix from approved known-folder token |
| Process | `FILE_NAME_EXACT` | Disabled by default | 100 | Literal filename only; requires explicit exception, expiry and enhanced conflict review |

Authority numbers are internal comparator constants in matcher contract version 1, not editable configuration. They are not confidence scores.

The language has no regular expressions, arbitrary wildcards, negative rules, scripts, expression hooks, network lookups, author-order semantics, fuzzy matching, machine learning, command-line predicates, window-title predicates, user identity predicates, or observed-frequency conditions.

### 3.8.2 Priority

- Default priority is `0`.
- A non-zero priority is an exceptional override. It requires an explicit reason, owner, synthetic counterexamples, conflict report, approval and review/expiry date.
- Higher numeric priority is considered first.
- Priority cannot turn a prohibited matcher family on, expand the product privacy ceiling, cross a realm, or bypass invalid/unavailable input.
- Priority is not a substitute for specificity; broad rules with high priority are shown as high-risk shadowing and block publication unless the override is explicit and approved.

## 3.9 URL/domain rules and normalization

### 3.9.1 Allowed inputs

Version `url-v1` accepts only absolute `http` or `https` URLs. It rejects missing hosts, opaque URLs, malformed percent escapes, credentials/userinfo, control characters, over-limit components, and unsupported schemes. Query and fragment are parsed only enough to exclude them; they are never copied into a matcher object, diagnostic, event or snapshot.

### 3.9.2 Host normalization

The normalizer must:

1. Parse with a documented implementation aligned to the WHATWG URL Standard for special HTTP(S) URLs and lock behavior with golden vectors. The reviewed living standard was updated 6 July 2026. [S-WEB-02]
2. Remove exactly one terminal DNS root dot for comparison.
3. Apply Unicode UTS #46 nontransitional processing and IDNA validity checks, then store/compare the ASCII A-label form. UTS #46 compatibility processing does not solve visual confusables, which remain an authoring warning. [S-WEB-04] [S-WEB-05]
4. Lowercase ASCII host labels.
5. Reject empty labels, labels violating the selected IDNA profile, and input exceeding the normalizer's approved bounds.
6. Match a suffix only at a label boundary. `example.test` matches `a.example.test` when permitted; it never matches `notexample.test`.
7. Apply `include_apex` explicitly for suffix rules.

URL rules must store only the canonical ASCII host form. The authoring UI may display Unicode with the A-label side by side and show confusable warnings.

### 3.9.3 Scheme and port

- A rule contains an explicit non-empty subset of `{http, https}`.
- Default ports are normalized away (`80` for HTTP, `443` for HTTPS).
- A rule may require an exact non-default port or `DEFAULT_OR_OMITTED`.
- A smaller allowed scheme set and an exact port are more specific than a broader set/port predicate when all other predicates are equal.

### 3.9.4 Paths

Path matching is controlled by the release privacy ceiling and a tenant-narrowing feature flag; it is off initially.

When enabled, `url-path-v1` provides only:

- `NONE` — host/port only;
- `EXACT` — exact normalized path;
- `PREFIX_SEGMENTS` — path-segment prefix, not raw string prefix.

Rules and observations use a canonical path representation that rejects malformed escapes, uppercases percent-escape hex, decodes only percent-encoded unreserved characters for comparison, removes dot segments, and does not treat an encoded slash as a literal path separator. Path comparison is ordinal and case-sensitive. A prefix ending at `/app` does not match `/application` unless the next boundary is a slash/end.

The normalizer must ship a golden corpus covering RFC 3986 generic syntax and WHATWG special-URL behavior; browser/.NET differences are resolved by the UAM normalization-version contract, not by whatever library version happens to be installed. [S-WEB-02] [S-WEB-03]

### 3.9.5 Public suffix list

Version 1 does not use the Public Suffix List. “Site/domain-level” means an explicit exact/suffix host rule. The PSL is community-maintained, changes independently, includes browser-oriented use cases and has ICANN/private sections; introducing it would create a second versioned data dependency and ambiguous organizational-boundary semantics. [S-WEB-24]

If a future requirement needs registrable-domain grouping, an ADR must select a pinned PSL data commit, define ICANN/private handling, update/rollback behavior and prove that the list is not used as an authorization or trust boundary.

## 3.10 Windows process rules and normalization

### 3.10.1 Minimal observation

The restricted Task Host may acquire only the fields authorized by the release privacy ceiling and needed by active rule families:

- full process image path in memory;
- final path and known-folder-relative segments;
- bounded file identity/basic metadata for race detection;
- Authenticode trust result and signer certificate identity;
- selected version-resource fields: `ProductName`, `OriginalFilename`, and numeric file version;
- process exit/access/error status.

It must not acquire or retain command line, current directory, window title, user documents, parent-process graph, environment, file contents, or arbitrary profile paths for this matcher.

### 3.10.2 Acquisition sequence

1. Use `QueryFullProcessImageNameW` to obtain the executable image path. [S-WEB-12]
2. Open the executable with the least read access needed and sharing compatible with a running image.
3. Resolve the final path with `GetFinalPathNameByHandleW`; if path resolution or component access fails, return `METADATA_UNAVAILABLE`, not a guessed path. [S-WEB-13]
4. Obtain a stable file identifier and basic metadata from the open handle before and after path-based version-resource calls. If the identity or relevant metadata changes, return `METADATA_RACE`.
5. Verify trust with `WinVerifyTrust`. `WINTRUST_FILE_INFO` supports an optional open file handle while also requiring the full path; use the handle where supported and treat any inconsistency as failure. [S-WEB-14] [S-WEB-15]
6. Read bounded version resources with `GetFileVersionInfoW`/`VerQueryValueW`; treat strings as untrusted metadata and enforce length/encoding bounds. [S-WEB-16] [S-WEB-17]
7. Map the final path to an approved known-folder token using Windows known-folder APIs, not environment-variable or username string substitution. [S-WEB-18]
8. Query per-directory case sensitivity where supported. Windows is normally case-insensitive but can enable directory-specific case sensitivity; if the effective mode cannot be established, a path rule returns `METADATA_UNAVAILABLE` unless an approved contract explicitly defines a safe fallback. [S-WEB-19] [S-WEB-20]
9. Clear raw buffers before the Task Host exits and return only the minimized match result/status.

### 3.10.3 Signed-product rules

A `SIGNED_PRODUCT` rule requires:

- successful platform trust verification under the approved trust-policy configuration;
- an exact approved `publisher_profile_id` and revision;
- an exact match to one active signer identity in that publisher profile, such as a SHA-256 certificate DER fingerprint and/or approved SPKI identity;
- optional exact `ProductName` and `OriginalFilename` constraints;
- optional numeric version interval with explicit inclusive/exclusive endpoints.

Certificate rollover is an explicit publisher-profile revision with old/new signer identities and effective windows. Subject display name or `CompanyName` alone is never publisher identity. The PE signature example warns that an embedded signature does not cover every file byte, so UAM still treats version metadata as a constrained classifier, not sole proof of software provenance. [S-WEB-15]

### 3.10.4 Path rules

Path rules use:

- `known_folder`: one of a release-approved set such as `PROGRAM_FILES_X64`, `PROGRAM_FILES_X86`, `WINDOWS`, `SYSTEM_X64`, or `SYSTEM_X86`;
- literal Unicode-NFC path segments;
- match mode `EXACT` or `PREFIX_SEGMENTS`;
- declared case contract.

Rules reject drive letters, UNC paths, device paths, environment variables, usernames, `.`/`..`, empty segments, alternate separators, wildcards, trailing spaces/dots, and reserved device-name ambiguity. Per-user folders such as `LOCAL_APP_DATA` are denied until separately privacy-approved. A prefix matches whole segments only.

A process in a user-writable location must not match a `SIGNED_PRODUCT` rule merely because its filename/product strings look right; it must pass trust and signer-profile checks. AppLocker documentation similarly distinguishes publisher, path and hash rule conditions, but UAM uses those ideas only as reference for classification—not as code execution control. [S-WEB-21]

### 3.10.5 Failure semantics

Process exit, access denied, signature API error, path resolution failure, unsupported filesystem behavior, version-resource parse error, case-mode uncertainty, or detected replacement returns a bounded non-match status. It does not fall through automatically to a weaker family unless the same observation independently contains all evidence required by an explicitly enabled weaker rule and the downgrade policy permits it. The default is **no implicit fallback from failed signed verification to filename matching**.

## 3.11 Matching algorithm and deterministic precedence

### 3.11.1 Match outcomes

```text
MATCHED
UNMATCHED
AMBIGUOUS
INVALID_OBSERVATION
METADATA_UNAVAILABLE
METADATA_RACE
SNAPSHOT_UNAVAILABLE
SNAPSHOT_EXPIRED
UNSUPPORTED_CONTRACT
MATCHER_DISABLED
```

Only `MATCHED` carries an `application_id`. `AMBIGUOUS` carries no candidate IDs across endpoint IPC. Central simulation may show candidates to an authorized administrator.

### 3.11.2 Algorithm

```text
Match(observation, activeSnapshot, now):
  1. Verify activeSnapshot is already trusted and active for this realm.
     If absent -> SNAPSHOT_UNAVAILABLE.
     If hard-expired -> SNAPSHOT_EXPIRED.
     If matcher family disabled by the release ceiling or kill switch -> MATCHER_DISABLED.

  2. Normalize observation with the exact normalization version named by the snapshot.
     Invalid syntax -> INVALID_OBSERVATION.
     Required OS metadata unavailable -> METADATA_UNAVAILABLE.
     File identity changed during acquisition -> METADATA_RACE.
     Unsupported version -> UNSUPPORTED_CONTRACT.

  3. Select rules of the observation kind whose half-open effective interval contains `now`.

  4. Evaluate every selected rule's closed predicates. Evaluation is pure, bounded,
     allocation-budgeted, and has no I/O or callbacks.

  5. If no rule matches -> UNMATCHED.

  6. Let P be the maximum numeric priority among matching rules. Remove rules below P.

  7. Let A be the maximum fixed family-authority rank among remaining rules. Remove rules below A.

  8. Compute the maximal set under the matcher-kind-specific strict specificity relation.
     Rule x dominates y only when every observation matched by x is also matched by y,
     and at least one predicate in x is strictly narrower. Incomparable rules both remain.

  9. If all maximal rules target one application -> MATCHED.
     Choose the lexicographically smallest (rule_id bytes, revision) only as provenance;
     this tie choice MUST NOT affect the application result.

 10. If maximal rules target more than one application -> AMBIGUOUS.
```

No creation time, author order, database row order, display name, source name, rule UUID, or snapshot array order may resolve a cross-application tie.

### 3.11.3 URL specificity relation

For rules with equal priority and family:

1. An exact host dominates a suffix rule when the exact host is inside the suffix domain and all other predicates are equal or narrower.
2. Between suffix rules, more labels dominate fewer labels when the narrower suffix is contained by the broader suffix.
3. `include_apex=false` and `include_apex=true` are not globally ordered unless containment can be proved for the compared domain.
4. A smaller scheme set dominates a larger set.
5. An exact non-default port dominates `ANY_ALLOWED`/default-or-omitted where containment holds.
6. `EXACT` path dominates a containing `PREFIX_SEGMENTS`; a longer containing segment prefix dominates a shorter one.
7. Specificity is a partial order. Incomparable predicates remain candidates and can cause ambiguity.

### 3.11.4 Process specificity relation

Family authority handles signed product versus path versus filename. Within one family:

- a signed-product rule with all predicates of another plus an additional exact product/original filename constraint is narrower;
- a version interval wholly contained in another is narrower; disjoint intervals do not overlap;
- exact path dominates a containing segment-prefix path;
- longer segment prefix dominates a shorter prefix;
- two different publisher profiles are disjoint only when their active signer-identity sets are proved disjoint for the effective interval;
- uncertain certificate/profile overlap is `UNKNOWN_ANALYSIS`, not assumed disjoint.

### 3.11.5 Why not first-match wins

First-match semantics make row order an invisible policy, let insertions change unrelated results, and make parallel authoring/rollback dangerous. A partial-order maximal-set algorithm exposes real ambiguity instead of hiding it. Deterministic provenance sorting is allowed only after the application result is already unique.

## 3.12 Static conflict, shadow and quality analysis

The analyzer consumes canonical rule revisions and emits a deterministic signed/hashed report tied to their content hashes and matcher contract version.

| Analysis result | Definition | Publication effect |
|---|---|---|
| `DISJOINT` | No possible normalized observation matches both rules | Pass |
| `SAME_TARGET_REDUNDANT` | One same-application rule is completely covered by another | Warning; reviewer may simplify |
| `SAME_TARGET_OVERLAP` | Same application, overlapping but neither dominates | Warning plus fixture requirement |
| `CROSS_TARGET_AMBIGUOUS` | Different applications can be equally maximal for an observation | Block |
| `CROSS_TARGET_SHADOWED` | Higher-priority/authority rule makes a lower rule unreachable over all its domain | Block by default; explicit override approval required |
| `PARTIAL_SHADOW` | A rule loses over part of its domain | Block until synthetic witness and intended behavior are approved |
| `UNKNOWN_ANALYSIS` | Analyzer cannot prove disjointness/containment | Block; grammar or fixture must be changed |
| `UNSUPPORTED` | Rule uses unknown contract/family/field | Block |

The analyzer must produce a synthetic witness for every detected overlap when the grammar permits. Witnesses use RFC 2606 `.test` domains and fictional process metadata, never production observations. [S-WEB-11]

Conflict analysis is run:

1. on draft save for feedback;
2. on submission using immutable content hashes;
3. before approval;
4. again during snapshot compilation against the exact effective rule set;
5. in CI against all fixture corpora and prior published snapshots.

## 3.13 Unknown, unmatched and ambiguous behavior

- `UNMATCHED` is a normal result, not an error and not evidence that a new application exists.
- `AMBIGUOUS` never selects a “best guess,” never creates a rule and never exposes candidate IDs in endpoint telemetry.
- `INVALID_OBSERVATION`, `METADATA_UNAVAILABLE`, and `METADATA_RACE` are operational evidence about matcher ability, not application activity.
- Central administrators may investigate aggregate bounded counts and run synthetic simulations. Raw production URLs/paths must not be submitted to the rule-authoring service.
- A support workflow may ask an approved local lab to reproduce a shape with fictional data. It must not request raw user history, credentials, internal addresses or confidential application labels.
- No real rule may be proposed from a name alone. A rule proposal needs independent owner/purpose evidence and fictional positive/negative examples.

## 3.14 Realm isolation

Realm isolation is enforced at every layer:

1. The authenticated context supplies `realm_id`; public contracts omit writable realm fields.
2. Every registry/rule/import/snapshot table has a leading `realm_id` in its primary key and same-realm composite foreign keys.
3. Repository methods require `RealmContext`; no unscoped “find by ID” method exists in application code.
4. Cache keys start with realm and contract version. No global cache stores rule IDs without realm.
5. Snapshot compiler takes one realm and rejects every referenced object from another realm.
6. Signatures bind the realm, product ceiling and monotonic sequence.
7. Endpoint derives expected realm from authenticated registration, not manifest or request input alone.
8. Metrics do not label realm IDs. Authorized investigations query realm-scoped operational data through audited interfaces.
9. Property-based tests generate identical UUIDs in different realms and prove non-interference.
10. Cross-realm operations, if ever needed, use a separate administrative surface, explicit realm selection, stronger authorization and audit; they are not an implicit superuser mode in normal APIs.

## 3.15 Configuration ownership, feature flags and kill switches

Configuration is split by authority:

- **Release-authorized product ceiling:** supported matcher families, fields, normalizer versions, maximum schema versions and hard safety bounds. Tenant configuration cannot widen it.
- **Realm policy:** approved rules, effective dates, and narrowing flags for that realm.
- **Endpoint local state:** trusted current/previous snapshot and emergency family-disable state received through signed/authorized control.

Required long-lived safety switches:

| Switch | Default | Effect | Authority |
|---|---:|---|---|
| `snapshot_publication_enabled` | Off before first gate | Stops new publication; current snapshot remains | Central release/incident authority — **HUMAN DECISION** assignment |
| `url_host_matching_enabled` | On only for approved first slice | Disables URL host classification when false | Product ceiling plus realm narrowing |
| `url_path_matching_enabled` | Off | Disables path predicates and strips them from compiled snapshot | Product privacy ceiling; tenant may only turn off |
| `process_signed_matching_enabled` | Off | Disables signed process rules | Product ceiling; tenant may only turn off |
| `process_path_matching_enabled` | Off | Disables process path rules | Product ceiling; tenant may only turn off |
| `process_filename_matching_enabled` | Off | Disables weak filename family | Exceptional product/realm approval |
| `rule_family_emergency_disable` | None | Signed list of disabled families; fail closed for that family | Incident authority |

A provider-neutral API such as OpenFeature can inform the in-process abstraction, but UAM should start with a small signed configuration provider rather than an external flag service. The default value on provider absence/error must be the safer disabled state for new matcher families. [S-WEB-25]

## 3.16 Secure coding and review requirements

- Use the supported .NET LTS line selected at execution time; as of the research date .NET 10 is active LTS and .NET 8/9 are near end of support. Patch selection remains lifecycle-managed, not hard-coded into architecture. [S-WEB-01]
- Keep parsers and matcher core deterministic, side-effect-free, culture-invariant and free of dynamic code generation.
- Apply NIST SSDF 1.1 practices for threat modeling, code review, dependency provenance, build integrity, vulnerability response and security testing; monitor the 2025 draft SSDF 1.2 but do not treat a draft as final. [S-WEB-26]
- Require two-person review for normalizer, precedence, signature verification, realm scoping, snapshot activation, import formula handling and audit transaction code. Exact organizational approvers remain a human decision.
- Fuzz URL/IDNA, CSV, JSON/snapshot, PE version-resource wrappers and path tokenization. Enforce cancellation, recursion depth, string/component count and decompression bounds.
- Maintain one canonical matcher conformance corpus used by endpoint, simulator, analyzer witnesses and migration tests.
- Treat all OS API return codes explicitly. No exception message containing input data enters logs.
- Use constant-time comparison for hashes/signature identifiers where applicable; rely on platform cryptography rather than custom algorithms.
- Pin third-party dependencies by lockfile, produce an SBOM, verify repository/release provenance and review licenses. The reference repositories in section 14 are not approved dependencies.

---

# 4. Alternatives, rejection reasons, and conditions that would change the choice

| Alternative | Decision | Rejection reason | Condition that would reopen it |
|---|---|---|---|
| Legacy/external correlation ID as UAM primary key | Reject | Five values are missing; one clean snapshot does not prove durable uniqueness, immutability or realm semantics | Signed source contract proves immutable, non-reused, realm-scoped identity and migration impact is lower; even then keep a UAM surrogate unless a new ADR proves otherwise |
| Case-folded application name as identity | Reject | Names change, collide, truncate, contain Unicode/confusables, and carry no ownership authority | Never for primary identity; may remain a search index only |
| Generate rules from names or aliases | Reject | No evidence connects catalogue names to URLs/processes; creates false attribution and privacy risk | Never automatically. Independent owner evidence plus governed fictional fixtures may create an authored rule |
| One mutable application row with no revisions | Reject | Cannot reproduce historical approvals, imports or rollback | Only if immutable event/audit storage independently preserves complete field history and a benchmark proves revision tables unacceptable; still requires ADR |
| Central matching of raw URL/process data | Reject | Violates endpoint-side minimization/offline design and increases breach scope | Only through an explicit baseline change proposal with new primary evidence, privacy approval and a falsifying experiment |
| General policy engine (OPA/Cedar) on endpoints | Reject as dependency | Broader language/runtime/attack surface than required; authorization threat model differs; risks scripts/recursion/complexity and operational mismatch | Reconsider centrally only if measured rule expressiveness cannot be represented by the closed grammar and sandbox/security/license/performance gates pass |
| Regular-expression or arbitrary glob rules | Reject | ReDoS/escaping ambiguity, hard conflict proof, hidden broad matches | Add only a separately bounded automata grammar with formal overlap analysis and resource proofs; never arbitrary .NET regex |
| First-match/order-wins rules | Reject | Hidden semantic dependence on author/database order; masks ambiguity | No current reopening condition; deterministic partial-order semantics is an invariant |
| Fuzzy/ML classifier | Reject | Non-deterministic explanations, drift, false attribution, hard rollback/audit | Research-only offline suggestion tool could be considered if it never publishes or classifies without governed human conversion to explicit rules |
| Browser public-suffix/eTLD+1 as the v1 application boundary | Reject | PSL is mutable and its organizational semantics do not equal an application; private section decisions are unresolved | Reopen for a specific approved grouping requirement with pinned data/version and non-security use |
| Process hash-only rules | Defer | Highly specific but brittle across updates; collection/cost and publisher strategy not yet justified | Reopen for a narrow high-risk executable use case with update workflow and measured overhead |
| Filename-only process rules | Disabled exception | Easy spoofing and collision; no location/signer evidence | Time-bounded approved exception with negative fixtures, no stronger metadata available, and heightened ambiguity monitoring |
| Delta snapshots first | Reject initially | Adds state/version/rollback complexity before size is known | Full snapshots fail approved size/download/activation budgets in G-AR4 and a delta recovery prototype proves integrity |
| Precompiled native binary/trie snapshot first | Defer | Tighter coupling and parser complexity; JSON/canonical payload may be sufficient | G-AR4 shows unacceptable size/latency and a versioned binary format has fuzz, compatibility and rollback proof |
| External feature-flag SaaS as a hard dependency | Reject initially | Adds availability, data-flow, licensing and control-plane dependency; signed local config suffices | Enterprise standard and threat/data-flow review proves fit; endpoint safer defaults remain local |
| Database row-level security as sole realm control | Reject | Owners/superusers can bypass; application bugs/cache keys still matter | Never sole control; may be defense in depth after production engine selection |
| CMDB as automatic master for all fields | Reject | Field authority, currentness and identifier semantics are unknown | Approved field-by-field authority contract, reconciliation SLAs and safe failure behavior |
| Delete and recreate an application to rename it | Reject | Breaks identity and historical provenance | Never for rename; use a new revision |


---

# 5. Interfaces/protocols and example contracts or schemas

## 5.1 Contract conventions

1. All external server APIs use UTF-8 JSON and an explicit media type, for example `application/vnd.uam.registry.v1+json`.
2. JSON contracts are validated against JSON Schema Draft 2020-12. [S-WEB-09]
3. IDs are lowercase canonical UUID strings on the wire; comparisons use the 16 UUID bytes, not culture-sensitive text.
4. Timestamps are UTC RFC 3339 strings with `Z`. Effective intervals are half-open: `from <= now < to`; absent `to` means open-ended.
5. Hashes are lowercase SHA-256 hex unless an algorithm field says otherwise.
6. Unknown required fields or unknown enum values fail closed. Unknown optional fields are accepted only when the schema minor-version compatibility rule explicitly permits them.
7. APIs never accept a client-writable `realmId` on ordinary realm-scoped routes. The server binds the realm from authenticated context.
8. Optimistic concurrency uses immutable revision IDs/content hashes and `If-Match`, never last-writer-wins.
9. Error details use bounded codes and JSON Pointers. They must not echo raw imported values, URLs, domains, process paths, signer strings or external IDs.
10. Central contracts can carry human-readable labels under authorization. Endpoint contracts cannot.

## 5.2 Logical registry and rule schema

The following is normative logical DDL using PostgreSQL spelling because PostgreSQL is the target reference. It does not settle the production engine. SQL Server mapping must preserve every key, check, immutability and transaction invariant in contract tests.

### 5.2.1 Registry core

```sql
CREATE TABLE registry_source (
    realm_id                 uuid        NOT NULL,
    source_id                uuid        NOT NULL,
    source_code              text        NOT NULL,
    source_kind              text        NOT NULL,
    authority_contract_rev   integer     NULL,
    authority_status         text        NOT NULL
        CHECK (authority_status IN ('UNDECIDED','PROPOSAL_ONLY','APPROVED_FIELDS','REVOKED')),
    external_key_semantics   text        NOT NULL
        CHECK (external_key_semantics IN ('ORDINAL_EXACT','CONTRACT_DEFINED')),
    enabled                   boolean     NOT NULL,
    created_at                timestamptz NOT NULL,
    created_by_subject_id     uuid        NOT NULL,
    PRIMARY KEY (realm_id, source_id),
    UNIQUE (realm_id, source_code)
);

CREATE TABLE application (
    realm_id                 uuid        NOT NULL,
    application_id           uuid        NOT NULL,
    lifecycle_state          text        NOT NULL
        CHECK (lifecycle_state IN ('DRAFT','ACTIVE','RETIRED','MERGED')),
    current_revision         integer     NULL,
    merged_into_application_id uuid      NULL,
    created_at               timestamptz NOT NULL,
    created_by_subject_id     uuid        NOT NULL,
    retired_at               timestamptz NULL,
    PRIMARY KEY (realm_id, application_id),
    FOREIGN KEY (realm_id, merged_into_application_id)
        REFERENCES application (realm_id, application_id),
    CHECK (
      (lifecycle_state = 'MERGED' AND merged_into_application_id IS NOT NULL)
      OR
      (lifecycle_state <> 'MERGED' AND merged_into_application_id IS NULL)
    ),
    CHECK (merged_into_application_id IS NULL OR merged_into_application_id <> application_id)
);

CREATE TABLE application_revision (
    realm_id                 uuid        NOT NULL,
    application_id           uuid        NOT NULL,
    revision                  integer     NOT NULL CHECK (revision > 0),
    revision_state            text        NOT NULL
        CHECK (revision_state IN ('DRAFT','SUBMITTED','APPROVED','SUPERSEDED','REJECTED','WITHDRAWN')),
    display_name_nfc          text        NOT NULL,
    search_key_version        text        NOT NULL,
    search_key                text        NOT NULL,
    description               text        NULL,
    provenance_json           jsonb       NOT NULL,
    content_sha256            char(64)    NOT NULL,
    valid_from                timestamptz NOT NULL,
    valid_to                  timestamptz NULL,
    change_reason             text        NOT NULL,
    created_at                timestamptz NOT NULL,
    created_by_subject_id     uuid        NOT NULL,
    submitted_at              timestamptz NULL,
    approved_at               timestamptz NULL,
    approved_by_subject_id    uuid        NULL,
    PRIMARY KEY (realm_id, application_id, revision),
    FOREIGN KEY (realm_id, application_id)
        REFERENCES application (realm_id, application_id),
    CHECK (valid_to IS NULL OR valid_to > valid_from),
    CHECK (length(display_name_nfc) BETWEEN 1 AND 512)
);

ALTER TABLE application
  ADD CONSTRAINT fk_application_current_revision
  FOREIGN KEY (realm_id, application_id, current_revision)
  REFERENCES application_revision (realm_id, application_id, revision);

CREATE TABLE application_alias (
    realm_id                 uuid        NOT NULL,
    alias_id                  uuid        NOT NULL,
    application_id           uuid        NOT NULL,
    alias_type                text        NOT NULL
        CHECK (alias_type IN ('DISPLAY_VARIANT','FORMER_NAME','PRODUCT_NAME','SEARCH_TERM','SOURCE_LABEL')),
    display_alias_nfc         text        NOT NULL,
    search_key_version        text        NOT NULL,
    search_key                text        NOT NULL,
    language_tag              text        NULL,
    source_id                 uuid        NULL,
    source_fingerprint        char(64)    NULL,
    valid_from                timestamptz NOT NULL,
    valid_to                  timestamptz NULL,
    quality_status            text        NOT NULL
        CHECK (quality_status IN ('VALID','WARNING','BLOCKED','RETIRED')),
    created_at                timestamptz NOT NULL,
    PRIMARY KEY (realm_id, alias_id),
    FOREIGN KEY (realm_id, application_id)
        REFERENCES application (realm_id, application_id),
    FOREIGN KEY (realm_id, source_id)
        REFERENCES registry_source (realm_id, source_id),
    CHECK (valid_to IS NULL OR valid_to > valid_from),
    CHECK (length(display_alias_nfc) BETWEEN 1 AND 512)
);

CREATE INDEX ix_application_alias_search
  ON application_alias (realm_id, search_key_version, search_key);

CREATE TABLE application_external_ref (
    realm_id                 uuid        NOT NULL,
    external_ref_id           uuid        NOT NULL,
    application_id           uuid        NOT NULL,
    source_id                 uuid        NOT NULL,
    key_type                  text        NOT NULL,
    external_key_exact        text        NOT NULL,
    comparison_key            text        NOT NULL,
    source_contract_revision  integer     NULL,
    status                    text        NOT NULL
        CHECK (status IN ('PROPOSED','VERIFIED','CONFLICT','RETIRED')),
    valid_from                timestamptz NOT NULL,
    valid_to                  timestamptz NULL,
    provenance_json           jsonb       NOT NULL,
    created_at                timestamptz NOT NULL,
    PRIMARY KEY (realm_id, external_ref_id),
    FOREIGN KEY (realm_id, application_id)
        REFERENCES application (realm_id, application_id),
    FOREIGN KEY (realm_id, source_id)
        REFERENCES registry_source (realm_id, source_id),
    CHECK (length(external_key_exact) BETWEEN 1 AND 1024),
    CHECK (valid_to IS NULL OR valid_to > valid_from)
);

CREATE INDEX ix_external_ref_lookup
  ON application_external_ref (realm_id, source_id, key_type, comparison_key);
```

A generic unique constraint on `(source_id, key_type, comparison_key)` is intentionally absent. A source-specific filtered/partial unique index may be added only after an approved contract declares uniqueness and all staged duplicates are resolved.

### 5.2.2 Governance links

```sql
CREATE TABLE application_owner_assignment (
    realm_id                 uuid        NOT NULL,
    assignment_id             uuid        NOT NULL,
    application_id           uuid        NOT NULL,
    owner_subject_ref         text        NOT NULL,
    owner_kind                text        NOT NULL,
    responsibility_kind       text        NOT NULL,
    authority_source_id       uuid        NULL,
    status                    text        NOT NULL
        CHECK (status IN ('PROPOSED','VERIFIED','DISPUTED','RETIRED')),
    valid_from                timestamptz NOT NULL,
    valid_to                  timestamptz NULL,
    provenance_json           jsonb       NOT NULL,
    PRIMARY KEY (realm_id, assignment_id),
    FOREIGN KEY (realm_id, application_id)
        REFERENCES application (realm_id, application_id),
    FOREIGN KEY (realm_id, authority_source_id)
        REFERENCES registry_source (realm_id, source_id),
    CHECK (valid_to IS NULL OR valid_to > valid_from)
);

CREATE TABLE taxonomy_term (
    realm_id                 uuid        NOT NULL,
    taxonomy_id               uuid        NOT NULL,
    taxonomy_kind             text        NOT NULL
        CHECK (taxonomy_kind IN ('CATEGORY','SENSITIVITY')),
    term_code                 text        NOT NULL,
    term_revision             integer     NOT NULL,
    display_label             text        NOT NULL,
    status                    text        NOT NULL
        CHECK (status IN ('DRAFT','ACTIVE','RETIRED')),
    definition_text           text        NOT NULL,
    PRIMARY KEY (realm_id, taxonomy_id, term_revision),
    UNIQUE (realm_id, taxonomy_kind, term_code, term_revision)
);

CREATE TABLE application_taxonomy_assignment (
    realm_id                 uuid        NOT NULL,
    assignment_id             uuid        NOT NULL,
    application_id           uuid        NOT NULL,
    taxonomy_id               uuid        NOT NULL,
    term_revision             integer     NOT NULL,
    status                    text        NOT NULL
        CHECK (status IN ('PROPOSED','APPROVED','DISPUTED','RETIRED')),
    provenance_json           jsonb       NOT NULL,
    valid_from                timestamptz NOT NULL,
    valid_to                  timestamptz NULL,
    PRIMARY KEY (realm_id, assignment_id),
    FOREIGN KEY (realm_id, application_id)
        REFERENCES application (realm_id, application_id),
    FOREIGN KEY (realm_id, taxonomy_id, term_revision)
        REFERENCES taxonomy_term (realm_id, taxonomy_id, term_revision),
    CHECK (valid_to IS NULL OR valid_to > valid_from)
);

CREATE TABLE application_cmdb_link (
    realm_id                 uuid        NOT NULL,
    link_id                   uuid        NOT NULL,
    application_id           uuid        NOT NULL,
    source_id                 uuid        NOT NULL,
    cmdb_object_key_exact     text        NOT NULL,
    relationship_kind        text        NOT NULL
        CHECK (relationship_kind IN ('REPRESENTS','DEPLOYMENT_OF','RELATED_TO')),
    status                    text        NOT NULL
        CHECK (status IN ('PROPOSED','VERIFIED','CONFLICT','RETIRED')),
    provenance_json           jsonb       NOT NULL,
    valid_from                timestamptz NOT NULL,
    valid_to                  timestamptz NULL,
    PRIMARY KEY (realm_id, link_id),
    FOREIGN KEY (realm_id, application_id)
        REFERENCES application (realm_id, application_id),
    FOREIGN KEY (realm_id, source_id)
        REFERENCES registry_source (realm_id, source_id),
    CHECK (valid_to IS NULL OR valid_to > valid_from)
);
```

Owner subject references and CMDB keys are server-side integration values. They must not be placed in logs/metrics or endpoint snapshots.

### 5.2.3 Import staging

```sql
CREATE TABLE import_batch (
    realm_id                 uuid        NOT NULL,
    import_batch_id           uuid        NOT NULL,
    source_id                 uuid        NOT NULL,
    state                     text        NOT NULL
        CHECK (state IN ('RECEIVED','PARSED','VALIDATED','QUALITY_REVIEW','MAPPED',
                         'APPROVED','APPLIED','QUARANTINED','REJECTED','CANCELLED')),
    source_sha256             char(64)    NOT NULL,
    parser_contract_version   text        NOT NULL,
    row_count                 integer     NULL,
    warning_count             integer     NOT NULL DEFAULT 0,
    blocking_count            integer     NOT NULL DEFAULT 0,
    received_at               timestamptz NOT NULL,
    received_by_subject_id    uuid        NOT NULL,
    approved_at               timestamptz NULL,
    approved_by_subject_id    uuid        NULL,
    applied_at                timestamptz NULL,
    idempotency_key           text        NOT NULL,
    PRIMARY KEY (realm_id, import_batch_id),
    FOREIGN KEY (realm_id, source_id)
        REFERENCES registry_source (realm_id, source_id),
    UNIQUE (realm_id, idempotency_key)
);

CREATE TABLE import_row (
    realm_id                 uuid        NOT NULL,
    import_batch_id           uuid        NOT NULL,
    row_number                integer     NOT NULL CHECK (row_number > 0),
    raw_ciphertext_ref        text        NULL,
    row_fingerprint_hmac      char(64)    NOT NULL,
    parsed_json               jsonb       NULL,
    quality_codes_json        jsonb       NOT NULL,
    proposed_action           text        NULL
        CHECK (proposed_action IN ('CREATE_DRAFT','LINK_EXISTING','UPDATE_DRAFT','NO_CHANGE','REJECT')),
    proposed_application_id   uuid        NULL,
    reviewer_reason           text        NULL,
    state                     text        NOT NULL
        CHECK (state IN ('PARSED','WARNING','BLOCKED','MAPPED','APPROVED','APPLIED','REJECTED')),
    PRIMARY KEY (realm_id, import_batch_id, row_number),
    FOREIGN KEY (realm_id, import_batch_id)
        REFERENCES import_batch (realm_id, import_batch_id),
    FOREIGN KEY (realm_id, proposed_application_id)
        REFERENCES application (realm_id, application_id)
);
```

`raw_ciphertext_ref` points to a restricted staging object only when approved. It is not a log field. Retention and encryption/key handling remain separate human/design gates.

### 5.2.4 Rules, tests, analysis and approval

```sql
CREATE TABLE matcher_rule (
    realm_id                 uuid        NOT NULL,
    rule_id                   uuid        NOT NULL,
    matcher_kind              text        NOT NULL CHECK (matcher_kind IN ('URL','PROCESS')),
    current_revision          integer     NULL,
    created_at                timestamptz NOT NULL,
    created_by_subject_id     uuid        NOT NULL,
    PRIMARY KEY (realm_id, rule_id)
);

CREATE TABLE matcher_rule_revision (
    realm_id                 uuid        NOT NULL,
    rule_id                   uuid        NOT NULL,
    revision                  integer     NOT NULL CHECK (revision > 0),
    target_application_id     uuid        NOT NULL,
    state                     text        NOT NULL
        CHECK (state IN ('DRAFT','VALIDATING','REVIEW_REQUIRED','APPROVED','SCHEDULED',
                         'PUBLISHED','SUPERSEDED','RETIRED','REJECTED','WITHDRAWN')),
    rule_family               text        NOT NULL
        CHECK (rule_family IN ('URL_HOST','URL_HOST_PATH','SIGNED_PRODUCT',
                               'PATH_EXACT','PATH_PREFIX','FILE_NAME_EXACT')),
    matcher_contract_version  text        NOT NULL,
    normalization_version     text        NOT NULL,
    priority                  smallint    NOT NULL DEFAULT 0,
    condition_json            jsonb       NOT NULL,
    owner_subject_ref         text        NOT NULL,
    purpose_text              text        NOT NULL,
    effective_from            timestamptz NOT NULL,
    effective_to              timestamptz NULL,
    priority_override_reason  text        NULL,
    priority_review_at        timestamptz NULL,
    rollback_plan_text        text        NOT NULL,
    content_sha256            char(64)    NOT NULL,
    change_set_id             uuid        NOT NULL,
    created_at                timestamptz NOT NULL,
    created_by_subject_id     uuid        NOT NULL,
    PRIMARY KEY (realm_id, rule_id, revision),
    FOREIGN KEY (realm_id, rule_id)
        REFERENCES matcher_rule (realm_id, rule_id),
    FOREIGN KEY (realm_id, target_application_id)
        REFERENCES application (realm_id, application_id),
    CHECK (effective_to IS NULL OR effective_to > effective_from),
    CHECK (
      (priority = 0 AND priority_override_reason IS NULL)
      OR
      (priority <> 0 AND priority_override_reason IS NOT NULL AND priority_review_at IS NOT NULL)
    )
);

ALTER TABLE matcher_rule
  ADD CONSTRAINT fk_rule_current_revision
  FOREIGN KEY (realm_id, rule_id, current_revision)
  REFERENCES matcher_rule_revision (realm_id, rule_id, revision);

CREATE TABLE rule_test_case (
    realm_id                 uuid        NOT NULL,
    rule_id                   uuid        NOT NULL,
    rule_revision             integer     NOT NULL,
    test_case_id              uuid        NOT NULL,
    case_kind                 text        NOT NULL CHECK (case_kind IN ('POSITIVE','NEGATIVE','AMBIGUOUS','ERROR')),
    synthetic_input_json      jsonb       NOT NULL,
    expected_outcome          text        NOT NULL,
    expected_application_id   uuid        NULL,
    expected_error_code       text        NULL,
    fixture_contract_version  text        NOT NULL,
    content_sha256            char(64)    NOT NULL,
    created_at                timestamptz NOT NULL,
    PRIMARY KEY (realm_id, rule_id, rule_revision, test_case_id),
    FOREIGN KEY (realm_id, rule_id, rule_revision)
        REFERENCES matcher_rule_revision (realm_id, rule_id, revision)
);

CREATE TABLE rule_analysis (
    realm_id                 uuid        NOT NULL,
    analysis_id               uuid        NOT NULL,
    rule_set_sha256           char(64)    NOT NULL,
    matcher_contract_version  text        NOT NULL,
    analyzer_build_id         text        NOT NULL,
    state                     text        NOT NULL CHECK (state IN ('RUNNING','PASSED','BLOCKED','FAILED')),
    result_json               jsonb       NOT NULL,
    started_at                timestamptz NOT NULL,
    completed_at              timestamptz NULL,
    PRIMARY KEY (realm_id, analysis_id),
    UNIQUE (realm_id, rule_set_sha256, matcher_contract_version, analyzer_build_id)
);

CREATE TABLE rule_approval (
    realm_id                 uuid        NOT NULL,
    rule_id                   uuid        NOT NULL,
    rule_revision             integer     NOT NULL,
    approval_id               uuid        NOT NULL,
    approval_kind             text        NOT NULL,
    decision                  text        NOT NULL CHECK (decision IN ('APPROVE','REJECT','REVOKE')),
    approver_subject_id       uuid        NOT NULL,
    decision_reason           text        NOT NULL,
    decided_at                timestamptz NOT NULL,
    rule_content_sha256       char(64)    NOT NULL,
    test_set_sha256           char(64)    NOT NULL,
    analysis_id               uuid        NOT NULL,
    PRIMARY KEY (realm_id, approval_id),
    FOREIGN KEY (realm_id, rule_id, rule_revision)
        REFERENCES matcher_rule_revision (realm_id, rule_id, revision),
    FOREIGN KEY (realm_id, analysis_id)
        REFERENCES rule_analysis (realm_id, analysis_id)
);
```

Approvals bind exact hashes. Any change to owner, purpose, priority, conditions, dates, tests, normalization, target application or rollback plan invalidates the approval and creates a new revision.

### 5.2.5 Publisher profiles

```sql
CREATE TABLE publisher_profile (
    realm_id                 uuid        NOT NULL,
    publisher_profile_id      uuid        NOT NULL,
    current_revision          integer     NULL,
    created_at                timestamptz NOT NULL,
    PRIMARY KEY (realm_id, publisher_profile_id)
);

CREATE TABLE publisher_profile_revision (
    realm_id                 uuid        NOT NULL,
    publisher_profile_id      uuid        NOT NULL,
    revision                  integer     NOT NULL,
    state                     text        NOT NULL
        CHECK (state IN ('DRAFT','APPROVED','SUPERSEDED','RETIRED')),
    purpose_text              text        NOT NULL,
    effective_from            timestamptz NOT NULL,
    effective_to              timestamptz NULL,
    content_sha256            char(64)    NOT NULL,
    approved_at               timestamptz NULL,
    approved_by_subject_id    uuid        NULL,
    PRIMARY KEY (realm_id, publisher_profile_id, revision),
    FOREIGN KEY (realm_id, publisher_profile_id)
        REFERENCES publisher_profile (realm_id, publisher_profile_id),
    CHECK (effective_to IS NULL OR effective_to > effective_from)
);

CREATE TABLE publisher_signer_identity (
    realm_id                 uuid        NOT NULL,
    publisher_profile_id      uuid        NOT NULL,
    profile_revision          integer     NOT NULL,
    signer_identity_id        uuid        NOT NULL,
    identity_kind             text        NOT NULL CHECK (identity_kind IN ('CERT_DER_SHA256','SPKI_SHA256')),
    identity_sha256           char(64)    NOT NULL,
    effective_from            timestamptz NOT NULL,
    effective_to              timestamptz NULL,
    rollover_reason           text        NULL,
    PRIMARY KEY (realm_id, publisher_profile_id, profile_revision, signer_identity_id),
    FOREIGN KEY (realm_id, publisher_profile_id, profile_revision)
        REFERENCES publisher_profile_revision (realm_id, publisher_profile_id, revision),
    CHECK (effective_to IS NULL OR effective_to > effective_from)
);
```

Publisher display names belong in central revision metadata, not in the endpoint predicate. The endpoint receives only an opaque local profile index and accepted hash material.

### 5.2.6 Snapshot records

```sql
CREATE TABLE matcher_snapshot (
    realm_id                  uuid        NOT NULL,
    snapshot_id               uuid        NOT NULL,
    sequence                  bigint      NOT NULL CHECK (sequence > 0),
    state                     text        NOT NULL
        CHECK (state IN ('BUILDING','VALIDATED','SIGNED','PUBLISHED','REVOKED','SUPERSEDED')),
    schema_major              integer     NOT NULL,
    schema_minor              integer     NOT NULL,
    matcher_contract_version  text        NOT NULL,
    privacy_ceiling_version   text        NOT NULL,
    rule_set_sha256           char(64)    NOT NULL,
    payload_sha256            char(64)    NOT NULL,
    compressed_size_bytes     bigint      NOT NULL,
    uncompressed_size_bytes   bigint      NOT NULL,
    generated_at              timestamptz NOT NULL,
    not_before                timestamptz NOT NULL,
    soft_expires_at           timestamptz NOT NULL,
    hard_expires_at           timestamptz NOT NULL,
    signer_key_id             text        NULL,
    signature_bytes           bytea       NULL,
    rollback_of_snapshot_id   uuid        NULL,
    artifact_uri              text        NOT NULL,
    compiler_build_id         text        NOT NULL,
    analysis_id               uuid        NOT NULL,
    audit_event_id            uuid        NOT NULL,
    PRIMARY KEY (realm_id, snapshot_id),
    UNIQUE (realm_id, sequence),
    FOREIGN KEY (realm_id, rollback_of_snapshot_id)
        REFERENCES matcher_snapshot (realm_id, snapshot_id),
    FOREIGN KEY (realm_id, analysis_id)
        REFERENCES rule_analysis (realm_id, analysis_id),
    CHECK (not_before <= soft_expires_at AND soft_expires_at < hard_expires_at)
);
```

## 5.3 URL rule schema and examples

### 5.3.1 Normative JSON Schema fragment

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://contracts.invalid/uam/rules/url-v1.schema.json",
  "type": "object",
  "additionalProperties": false,
  "required": ["kind", "normalizationVersion", "schemes", "host", "port", "path"],
  "properties": {
    "kind": { "const": "URL" },
    "normalizationVersion": { "const": "url-v1" },
    "schemes": {
      "type": "array",
      "minItems": 1,
      "maxItems": 2,
      "uniqueItems": true,
      "items": { "enum": ["http", "https"] }
    },
    "host": {
      "type": "object",
      "additionalProperties": false,
      "required": ["mode", "ascii"],
      "properties": {
        "mode": { "enum": ["EXACT", "SUFFIX"] },
        "ascii": {
          "type": "string",
          "minLength": 1,
          "maxLength": 253,
          "pattern": "^[a-z0-9](?:[a-z0-9.-]*[a-z0-9])?$"
        },
        "includeApex": { "type": "boolean" }
      },
      "allOf": [
        {
          "if": { "properties": { "mode": { "const": "SUFFIX" } } },
          "then": { "required": ["includeApex"] },
          "else": { "not": { "required": ["includeApex"] } }
        }
      ]
    },
    "port": {
      "oneOf": [
        {
          "type": "object",
          "additionalProperties": false,
          "required": ["mode"],
          "properties": { "mode": { "const": "DEFAULT_OR_OMITTED" } }
        },
        {
          "type": "object",
          "additionalProperties": false,
          "required": ["mode", "value"],
          "properties": {
            "mode": { "const": "EXACT" },
            "value": { "type": "integer", "minimum": 1, "maximum": 65535 }
          }
        }
      ]
    },
    "path": {
      "oneOf": [
        {
          "type": "object",
          "additionalProperties": false,
          "required": ["mode"],
          "properties": { "mode": { "const": "NONE" } }
        },
        {
          "type": "object",
          "additionalProperties": false,
          "required": ["mode", "segments", "trailingSlash"],
          "properties": {
            "mode": { "enum": ["EXACT", "PREFIX_SEGMENTS"] },
            "segments": {
              "type": "array",
              "maxItems": 64,
              "items": { "type": "string", "minLength": 1, "maxLength": 255 }
            },
            "trailingSlash": { "type": "boolean" }
          }
        }
      ]
    }
  }
}
```

The regular expression above validates only the already-canonical ASCII storage shape. It is not the runtime URL matcher and is not used against observations.

### 5.3.2 Fictional exact-host rule

```json
{
  "kind": "URL",
  "normalizationVersion": "url-v1",
  "schemes": ["https"],
  "host": {
    "mode": "EXACT",
    "ascii": "ledger.example.test"
  },
  "port": {
    "mode": "DEFAULT_OR_OMITTED"
  },
  "path": {
    "mode": "NONE"
  }
}
```

### 5.3.3 Fictional suffix/path rule, disabled until path approval

```json
{
  "kind": "URL",
  "normalizationVersion": "url-v1",
  "schemes": ["https"],
  "host": {
    "mode": "SUFFIX",
    "ascii": "studio.example.test",
    "includeApex": true
  },
  "port": {
    "mode": "DEFAULT_OR_OMITTED"
  },
  "path": {
    "mode": "PREFIX_SEGMENTS",
    "segments": ["workspace"],
    "trailingSlash": false
  }
}
```

## 5.4 Process rule schema and examples

### 5.4.1 Normative shape

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://contracts.invalid/uam/rules/process-v1.schema.json",
  "type": "object",
  "additionalProperties": false,
  "required": ["kind", "normalizationVersion", "selector"],
  "properties": {
    "kind": { "const": "PROCESS" },
    "normalizationVersion": { "const": "process-v1" },
    "selector": {
      "oneOf": [
        { "$ref": "#/$defs/signedProduct" },
        { "$ref": "#/$defs/pathExact" },
        { "$ref": "#/$defs/pathPrefix" },
        { "$ref": "#/$defs/fileName" }
      ]
    }
  },
  "$defs": {
    "versionTuple": {
      "type": "array",
      "minItems": 4,
      "maxItems": 4,
      "items": { "type": "integer", "minimum": 0, "maximum": 65535 }
    },
    "signedProduct": {
      "type": "object",
      "additionalProperties": false,
      "required": ["type", "publisherProfileId", "publisherProfileRevision"],
      "properties": {
        "type": { "const": "SIGNED_PRODUCT" },
        "publisherProfileId": { "type": "string", "format": "uuid" },
        "publisherProfileRevision": { "type": "integer", "minimum": 1 },
        "productName": { "type": "string", "minLength": 1, "maxLength": 256 },
        "originalFileName": {
          "type": "string",
          "minLength": 1,
          "maxLength": 255,
          "pattern": "^[^\\\\/:*?\"<>|]+$"
        },
        "version": {
          "type": "object",
          "additionalProperties": false,
          "properties": {
            "minInclusive": { "$ref": "#/$defs/versionTuple" },
            "maxExclusive": { "$ref": "#/$defs/versionTuple" }
          },
          "minProperties": 1
        }
      }
    },
    "pathBase": {
      "type": "object",
      "additionalProperties": false,
      "required": ["knownFolder", "segments", "caseContract"],
      "properties": {
        "knownFolder": {
          "enum": ["PROGRAM_FILES_X64", "PROGRAM_FILES_X86", "WINDOWS", "SYSTEM_X64", "SYSTEM_X86"]
        },
        "segments": {
          "type": "array",
          "minItems": 1,
          "maxItems": 64,
          "items": { "type": "string", "minLength": 1, "maxLength": 255 }
        },
        "caseContract": {
          "enum": ["REQUIRE_CASE_INSENSITIVE", "ORDINAL_CASE_SENSITIVE"]
        }
      }
    },
    "pathExact": {
      "allOf": [
        { "$ref": "#/$defs/pathBase" },
        { "type": "object", "properties": { "type": { "const": "PATH_EXACT" } }, "required": ["type"] }
      ]
    },
    "pathPrefix": {
      "allOf": [
        { "$ref": "#/$defs/pathBase" },
        { "type": "object", "properties": { "type": { "const": "PATH_PREFIX" } }, "required": ["type"] }
      ]
    },
    "fileName": {
      "type": "object",
      "additionalProperties": false,
      "required": ["type", "fileName"],
      "properties": {
        "type": { "const": "FILE_NAME_EXACT" },
        "fileName": {
          "type": "string",
          "minLength": 1,
          "maxLength": 255,
          "pattern": "^[^\\\\/:*?\"<>|]+$"
        }
      }
    }
  }
}
```

The implementation must add semantic validation that JSON Schema cannot express cleanly: no dot segments, no reserved device names, no trailing dot/space, min version below max, approved known-folder/family under the release ceiling, and publisher profile/effective-date consistency.

### 5.4.2 Fictional signed-product rule

```json
{
  "kind": "PROCESS",
  "normalizationVersion": "process-v1",
  "selector": {
    "type": "SIGNED_PRODUCT",
    "publisherProfileId": "00000000-0000-7000-8000-000000000201",
    "publisherProfileRevision": 3,
    "productName": "Cobalt Writer",
    "originalFileName": "CobaltWriter.exe",
    "version": {
      "minInclusive": [3, 2, 0, 0],
      "maxExclusive": [4, 0, 0, 0]
    }
  }
}
```

### 5.4.3 Fictional path rule

```json
{
  "kind": "PROCESS",
  "normalizationVersion": "process-v1",
  "selector": {
    "type": "PATH_EXACT",
    "knownFolder": "PROGRAM_FILES_X64",
    "segments": ["Fictional", "Cobalt", "CobaltWriter.exe"],
    "caseContract": "REQUIRE_CASE_INSENSITIVE"
  }
}
```

## 5.5 Rule revision API

### 5.5.1 Create draft

```http
POST /control/v1/application-rules
Content-Type: application/vnd.uam.rule-draft.v1+json
Idempotency-Key: 8d60...client-generated...
```

```json
{
  "targetApplicationId": "00000000-0000-7000-8000-000000000101",
  "ownerSubjectRef": "opaque-owner-reference",
  "purpose": "Fictional validation purpose; no production data",
  "effectiveFrom": "2026-08-15T00:00:00Z",
  "effectiveTo": null,
  "priority": 0,
  "rollbackPlan": "Publish the previous approved rule set as a higher-sequence snapshot.",
  "condition": {
    "kind": "URL",
    "normalizationVersion": "url-v1",
    "schemes": ["https"],
    "host": { "mode": "EXACT", "ascii": "ledger.example.test" },
    "port": { "mode": "DEFAULT_OR_OMITTED" },
    "path": { "mode": "NONE" }
  },
  "tests": [
    {
      "kind": "POSITIVE",
      "input": { "url": "https://ledger.example.test/home" },
      "expected": { "outcome": "MATCHED", "applicationId": "00000000-0000-7000-8000-000000000101" }
    },
    {
      "kind": "NEGATIVE",
      "input": { "url": "https://notledger.example.test/" },
      "expected": { "outcome": "UNMATCHED" }
    }
  ]
}
```

The BFF converts display-facing input to canonical conditions only after showing the normalized form to the author. The server re-normalizes independently and stores the authored and canonical diff in audit.

### 5.5.2 Submit and analyze

```http
POST /control/v1/application-rules/{ruleId}/revisions/{revision}:submit
If-Match: "sha256:<draft-content-hash>"
```

Response:

```json
{
  "state": "REVIEW_REQUIRED",
  "ruleId": "00000000-0000-7000-8000-000000000301",
  "revision": 4,
  "contentSha256": "...",
  "testSetSha256": "...",
  "analysis": {
    "analysisId": "00000000-0000-7000-8000-000000000401",
    "state": "PASSED",
    "ruleSetSha256": "...",
    "findings": [
      {
        "code": "RULE-CNF-010",
        "severity": "WARNING",
        "kind": "SAME_TARGET_REDUNDANT",
        "relatedRuleId": "00000000-0000-7000-8000-000000000302",
        "witnessFixtureId": "00000000-0000-7000-8000-000000000501"
      }
    ]
  }
}
```

### 5.5.3 Approval

```http
POST /control/v1/application-rules/{ruleId}/revisions/{revision}:approve
If-Match: "sha256:<submitted-content-hash>"
```

```json
{
  "decision": "APPROVE",
  "reason": "Synthetic fixtures and conflict result reviewed.",
  "testSetSha256": "...",
  "analysisId": "00000000-0000-7000-8000-000000000401",
  "analysisRuleSetSha256": "..."
}
```

The API refuses approval if hashes differ, the owner/purpose/rollback fields are absent, analysis is blocked/stale, positive and negative fixtures are missing, the approver lacks authority, or separation-of-duty policy is not met.

### 5.5.4 Simulation

```http
POST /control/v1/application-rule-simulations
Content-Type: application/vnd.uam.rule-simulation.v1+json
```

```json
{
  "ruleSet": {
    "mode": "DRAFT_PLUS_CURRENT_PUBLISHED",
    "draftRuleId": "00000000-0000-7000-8000-000000000301",
    "draftRevision": 4
  },
  "fixtures": [
    { "fixtureId": "fictional-001", "url": "https://ledger.example.test/home" },
    { "fixtureId": "fictional-002", "url": "https://notledger.example.test/" }
  ],
  "includeExplanation": true
}
```

Simulation rejects internal/non-reserved host fixtures by default. An exceptional lab mode requires local-only execution and separate approval; it must not upload values.

## 5.6 Match result contract across endpoint boundary

```json
{
  "contractVersion": "match-result-v1",
  "matcherKind": "URL",
  "outcome": "MATCHED",
  "applicationId": "00000000-0000-7000-8000-000000000101",
  "ruleId": "00000000-0000-7000-8000-000000000301",
  "ruleRevision": 4,
  "snapshotId": "00000000-0000-7000-8000-000000000601",
  "snapshotSequence": 42,
  "normalizationVersion": "url-v1",
  "reasonCode": "MATCH-OK-001"
}
```

Normative rules:

- `applicationId`, `ruleId`, and `ruleRevision` are present only for `MATCHED`.
- No raw or normalized host/path/process value, candidate list, signer display name, file path, external key, application label, user ID or realm claim is present.
- Realm/device/session are derived from authenticated/local context elsewhere, not this payload.
- `reasonCode` is a bounded enum.
- The event identity/dedupe contract is defined by the broader endpoint event design; this matcher result is an input to it, not a durable event itself.

Ambiguous example:

```json
{
  "contractVersion": "match-result-v1",
  "matcherKind": "URL",
  "outcome": "AMBIGUOUS",
  "snapshotId": "00000000-0000-7000-8000-000000000601",
  "snapshotSequence": 42,
  "normalizationVersion": "url-v1",
  "reasonCode": "MATCH-AMB-001"
}
```

## 5.7 Import contract and quality report

### 5.7.1 Accepted input envelope

The import endpoint accepts a bounded file plus metadata; it does not accept a filesystem path or URL to fetch.

```http
POST /control/v1/application-imports
Content-Type: multipart/form-data
Idempotency-Key: <opaque>
```

Metadata part:

```json
{
  "sourceId": "00000000-0000-7000-8000-000000000701",
  "parserContractVersion": "application-catalogue-csv-v1",
  "declaredClassification": "INTERNAL_REFERENCE",
  "purpose": "Governed application registry reconciliation"
}
```

CSV v1 uses strict UTF-8 and RFC 4180 quoting/line rules, with exactly allowlisted headers. [S-WEB-10] The first implementation profile supports:

```text
application_name,external_correlation_id
```

No unrecognized column is ignored; the batch is blocked until a schema revision explicitly supports it.

### 5.7.2 Quality result

```json
{
  "importBatchId": "00000000-0000-7000-8000-000000000702",
  "state": "QUALITY_REVIEW",
  "sourceSha256": "...",
  "rowCount": 173,
  "countsByCode": {
    "REG-EXT-001": 5,
    "REG-DQ-012": 1,
    "REG-DQ-020": 10,
    "REG-DQ-030": 9
  },
  "rows": [
    {
      "rowNumber": 17,
      "rowFingerprint": "hmac-sha256:...",
      "severity": "BLOCKING",
      "codes": ["REG-DQ-030"],
      "messageKey": "possible-truncation-review-required"
    }
  ]
}
```

The example counts reflect only the supplied sanitized shape and must not expose source values. [S-INT-02]

### 5.7.3 Quality codes

| Code | Severity/default | Meaning | Required action |
|---|---|---|---|
| `REG-IMP-001` | Blocking | Invalid UTF-8, CSV quoting or structural parse | Quarantine batch; no partial apply |
| `REG-IMP-002` | Blocking | Unknown/missing header or schema revision | Reject or migrate schema explicitly |
| `REG-IMP-003` | Blocking | Approved input bound exceeded | Reject before full allocation; retain bounded evidence |
| `REG-DQ-001` | Blocking | Missing/empty canonical label | Human correction; no application activation |
| `REG-DQ-002` | Blocking | NUL or prohibited control character | Quarantine row |
| `REG-DQ-003` | Warning/block by character | Bidi/default-ignorable/unsafe Unicode | Visible escaped review; never silent deletion |
| `REG-DQ-010` | Warning | Leading/trailing or repeated whitespace | Show proposed canonical form; reviewer decides |
| `REG-DQ-011` | Warning | Confusable/mixed-script collision | Side-by-side Unicode/A-label/skeleton review |
| `REG-DQ-012` | Warning | Address-like literal in label | Verify it is a label, not leaked configuration |
| `REG-DQ-020` | Informational | Non-ASCII label | Preserve; ensure Unicode tests |
| `REG-DQ-030` | Blocking | Possible truncation marker | Confirm/correct before active revision |
| `REG-EXT-001` | Warning | Missing external key | Allocate UAM ID only through approved mapping; no fabricated key |
| `REG-EXT-002` | Blocking | Duplicate external key under a source contract that declares uniqueness | Quarantine all claims; no auto-merge |
| `REG-EXT-003` | Warning/block | Source key changes or reappears for another app | Reconciliation case and authority review |
| `REG-MAP-001` | Blocking | Ambiguous name/alias candidate | Human mapping; no name-based link |
| `REG-MAP-002` | Blocking | Proposed cross-realm link | Security incident path; reject |
| `REG-EXP-001` | Blocking | Spreadsheet formula injection risk in export | Escape/prefix export cell; raw export restricted |

On any CSV/spreadsheet export, values beginning with `=`, `+`, `-`, or `@` are escaped according to the approved safe-export profile. UAM never opens or evaluates the source as a spreadsheet and never emits formulas.

## 5.8 Endpoint snapshot contract

### 5.8.1 Envelope

The endpoint retrieves the current snapshot through an authenticated endpoint API. The server derives the realm from device registration.

```http
GET /endpoint/v1/application-matcher-snapshots/current
Accept: application/vnd.uam.matcher-snapshot.v1+json
If-None-Match: "sha256:<active-payload-hash>"
```

A `304` means no change. A successful response contains a canonical manifest and compressed payload. Transport is authenticated HTTPS as accepted by the baseline; the exact device PKI remains a separate gate.

Manifest example:

```json
{
  "schemaMajor": 1,
  "schemaMinor": 0,
  "snapshotId": "00000000-0000-7000-8000-000000000601",
  "realmId": "00000000-0000-7000-8000-000000000001",
  "sequence": 42,
  "generatedAt": "2026-07-31T12:00:00Z",
  "notBefore": "2026-07-31T12:05:00Z",
  "softExpiresAt": "2026-08-07T12:05:00Z",
  "hardExpiresAt": "2026-08-14T12:05:00Z",
  "minimumEndpointContract": "matcher-runtime-v1",
  "matcherContractVersion": "matcher-v1",
  "normalizationVersions": ["url-v1"],
  "privacyCeilingVersion": "privacy-ceiling-v1",
  "contentType": "application/vnd.uam.matcher-payload.v1+json",
  "contentEncoding": "gzip",
  "compressedSizeBytes": 12345,
  "uncompressedSizeBytes": 67890,
  "payloadSha256": "...",
  "ruleSetSha256": "...",
  "compilerBuildId": "uam-snapshot-compiler/<signed-build-id>",
  "signerKeyId": "release-signer-2026-a",
  "signatureAlgorithm": "<approved platform algorithm identifier>",
  "rollbackOfSnapshotId": null,
  "signature": "base64url-without-padding"
}
```

The exact illustrative expiry and size values above are examples, not approved settings. Production values are **HUMAN DECISION/CLI EXPERIMENT**.

### 5.8.2 Canonicalization and signature

- Manifest JSON without `signature` is canonicalized using RFC 8785 JSON Canonicalization Scheme. [S-WEB-08]
- The signature covers a domain-separated byte string containing the canonical manifest, payload SHA-256, realm ID, sequence and privacy-ceiling version.
- The payload hash is over the uncompressed canonical payload. Compressed bytes also have transport integrity but cannot substitute for the canonical content hash.
- Signature algorithm/key lifecycle is selected under the release-signing architecture; this result does not invent the enterprise PKI choice.
- The signer accepts only a compiler-produced gate record containing the exact manifest/payload hashes, final conflict report, approvals and audit transaction ID.

### 5.8.3 Minimal payload

```json
{
  "contract": "matcher-payload-v1",
  "applications": [
    "00000000-0000-7000-8000-000000000101",
    "00000000-0000-7000-8000-000000000102"
  ],
  "publisherProfiles": [],
  "rules": [
    {
      "i": 0,
      "id": "00000000-0000-7000-8000-000000000301",
      "rev": 4,
      "app": 0,
      "p": 0,
      "f": "URL_HOST",
      "from": "2026-08-15T00:00:00Z",
      "to": null,
      "n": "url-v1",
      "c": {
        "s": ["https"],
        "h": ["E", "ledger.example.test"],
        "o": ["D"],
        "x": ["N"]
      }
    }
  ]
}
```

The compiler may use short, schema-defined field names in the endpoint payload. It must not include application names, aliases, owners, taxonomy, sensitivity, external keys, CMDB links, rule purpose, approval identities, candidate explanations, raw fixtures, or imported values.

### 5.8.4 Size strategy

1. Start with complete per-realm snapshots and an application UUID dictionary/local integer indexes.
2. Canonicalize before compression; choose the v1 codec after benchmark. `gzip` is shown as an interoperable candidate, not an accepted fixed choice.
3. Compiler rejects duplicate strings, unreachable rules, unsupported fields and rules outside the effective horizon selected for the snapshot.
4. Endpoint verifies declared compressed/uncompressed sizes before and during decompression, enforces an approved ratio/output cap, and parses with bounded depth/count/string lengths.
5. Build in-memory indexes after signature/hash/schema validation. Activation occurs only after all indexes and self-tests succeed.
6. Benchmark 1,000, 10,000 and 100,000 fictional rules. If the approved endpoint budgets fail, evaluate in order: remove redundant data, string table/trie, deterministic compact binary format, then delta delivery. Each step needs its own ADR and compatibility tests.
7. Do not introduce delta snapshots merely to optimize bandwidth before measuring full artifacts. A failed delta chain must always recover from a full snapshot.

### 5.8.5 Verification order

The Coordinator performs this exact order, with bounded reads throughout:

1. Authenticate transport/device context and obtain expected realm.
2. Read a fixed-size manifest envelope; reject over-limit before payload download/decompression.
3. Validate JSON shape and supported schema major.
4. Verify expected realm, product privacy ceiling, signer key authorization and signature.
5. Verify sequence is greater than the highest accepted sequence for the realm; an explicitly identical already-active snapshot may be treated as idempotent.
6. Verify `notBefore`, soft/hard expiry and endpoint contract/normalizer compatibility.
7. Check declared size/codec against release hard bounds.
8. Stream-decompress into a bounded destination while hashing.
9. Compare hash and actual sizes.
10. Parse and validate the canonical payload, rule counts, references, family ceiling and internal duplicates.
11. Build indexes and run embedded self-test vectors.
12. Persist pending snapshot, activate atomically, retain previous, and then acknowledge local activation.

Any failure preserves the last-known-good snapshot and emits one bounded health/error code. If no valid snapshot exists, matching is disabled.

## 5.9 Error envelope and taxonomy

### 5.9.1 Server error envelope

```json
{
  "type": "https://contracts.invalid/uam/errors/RULE-CNF-001",
  "title": "Rule set has a cross-application ambiguity",
  "status": 409,
  "code": "RULE-CNF-001",
  "correlationId": "opaque-random-id",
  "retryable": false,
  "details": [
    {
      "jsonPointer": "/condition/host",
      "messageKey": "overlap-with-another-application",
      "relatedObject": {
        "kind": "RULE_REVISION",
        "id": "00000000-0000-7000-8000-000000000302",
        "revision": 2
      }
    }
  ]
}
```

### 5.9.2 Bounded codes

| Family | Representative codes | Operator meaning |
|---|---|---|
| Import/parser | `REG-IMP-001..003` | File/schema/bound failure |
| Registry quality | `REG-DQ-*`, `REG-EXT-*`, `REG-MAP-*` | Label/key/mapping issue |
| Rule validation | `RULE-VAL-001` unsupported grammar; `RULE-VAL-002` missing gate; `RULE-VAL-003` invalid dates | Author correction required |
| Rule conflict | `RULE-CNF-001` ambiguity; `RULE-CNF-002` shadow; `RULE-CNF-003` unknown proof | Publication blocked |
| Snapshot build | `SNAP-BLD-001` gate failure; `SNAP-BLD-002` ceiling violation; `SNAP-BLD-003` size bound | No sign/publication |
| Snapshot verify | `SNAP-VER-001` signature/hash; `SNAP-VER-002` realm; `SNAP-VER-003` stale/downgrade/expiry; `SNAP-VER-004` decompression/schema | Preserve last-known-good; incident if security relevant |
| Match | `MATCH-NRM-001`; `MATCH-AMB-001`; `MATCH-META-001`; `MATCH-META-002`; `MATCH-DIS-001` | Bounded outcome, no raw input |
| Realm | `REALM-001` cross-realm request/reference; `REALM-002` cache key mismatch | Reject, alert and investigate |
| Audit | `AUD-001` durable audit unavailable; `AUD-002` hash mismatch | Privileged mutation fails |
| Observability | `OBS-001` forbidden dimension/value; `OBS-002` cardinality guard | Drop unsafe label and alert test environment |

Retryability is explicit. Validation, conflict, realm, signature, stale sequence and forbidden-field errors are not blindly retried. Transport/transient storage errors may be retried using the broader bounded retry policy.

## 5.10 Privacy-safe observability

Metrics use bounded dimensions only:

```text
uam_registry_import_batches_total{outcome,error_family}
uam_rule_analysis_total{matcher_kind,outcome,contract_version}
uam_snapshot_build_total{outcome,schema_major,contract_version}
uam_snapshot_verify_total{outcome,error_family,schema_major}
uam_match_total{matcher_kind,outcome,normalization_version}
uam_match_duration_seconds{matcher_kind,outcome}
uam_snapshot_bytes{encoding,schema_major}
uam_feature_state{feature_name,bounded_state}
```

Forbidden metric/log labels include realm ID, application ID, rule ID, snapshot ID, domain, path, process filename/path, signer, external key, CMDB key, user/device/session, imported label and free-form exception message. Prometheus guidance specifically warns against unbounded/high-cardinality labels such as user IDs; UAM makes this a hard design rule rather than a dashboard convention. [S-WEB-28]

Object-specific troubleshooting uses authorized, audited database queries by opaque ID and bounded time window. Traces may contain random correlation IDs and component/stage/error family; they do not contain rule conditions or observations.

A cardinality CI test enumerates every metric definition and fails if a label is not backed by a closed enum or a deliberately bounded build/schema value. Runtime guards reject unknown label values into `other` and count the rejection without logging the original.

Each instrument MUST declare `maximum_series = product(maximum declared values for every label)` in the metric contract. CI sums those maxima per component and compares them with version-controlled limits in `thresholds.json`; a missing limit, an unbounded label, or an exceeded per-instrument/per-process limit blocks release. The exact numerical limits are **HUMAN DECISION/CLI EXPERIMENT** because the telemetry backend, fleet topology and approved operating budget are unknown; until they are set, only the closed low-cardinality instruments above may ship in test builds, not production.

## 5.11 Administrative accessibility contract

The registry/rule UI should target WCAG 2.2 AA, subject to product authority. [S-WEB-27]

At minimum:

- every state, severity and conflict is expressed in text/icon/accessible name, never colour alone;
- all authoring, diff, review, approval, publication and rollback actions are keyboard operable with visible focus;
- normalized and authored values are shown in labelled, selectable text with Unicode/A-label views and clear warnings;
- conflict graphs have an equivalent sortable table and plain-language witness explanation;
- validation errors link to fields and are summarized at the top;
- approval cannot be triggered by an ambiguous icon-only control;
- dangerous operations require an explicit textual confirmation that names the realm, revision and higher-sequence rollback behavior, without requiring a pointer device;
- synthetic fixture export/import is screen-reader labelled and contains no production data.


## 5.12 Data lineage and evidence-chain contract

Every canonical or executable fact MUST be traceable without retaining raw endpoint observations. The minimum central lineage chain is:

```text
source registration
  -> immutable import batch (source ID, parser contract, source SHA-256)
  -> staged row (row number, source-scoped HMAC fingerprint, quality codes)
  -> explicit mapping/reconciliation decision
  -> application + immutable application revision
  -> alias/external-reference/owner/taxonomy/CMDB proposal or assignment revision
  -> rule set + immutable rule revision (condition/test/purpose hashes)
  -> analyzer run (matcher/normalizer/compiler builds, complete result, witnesses)
  -> approval gate record (exact hashes and accountable approvals)
  -> immutable snapshot source manifest
  -> compiled rule entry + signed snapshot artefact
  -> endpoint verification/activation record
  -> minimized match result (snapshot ID/sequence and, only for `MATCHED`, rule/application identity)
```

Normative lineage rules:

- A mutable display label MUST NOT be the join key anywhere in the chain.
- Every link MUST include `realm_id`; cross-realm lineage is invalid and raises `REALM-001`.
- Imported source values stay in the restricted staging/registry boundary under approved retention. Endpoint activity is never joined back to raw import rows.
- Row HMAC fingerprints are source/batch-scoped correlation aids, not global identities, and their key is not exported.
- A rule revision stores the exact target application revision it was reviewed against, while execution uses the stable application ID. A later application label/owner change does not silently rewrite rule history.
- An analyzer result is valid only for the exact rule-set hash, normalizer versions, matcher contract, compiler build and effective-time input recorded in that result.
- A publication gate record and signature bind those same hashes. Re-running analysis or approval produces a new record rather than mutating old evidence.
- Endpoint activation stores only bounded artefact metadata and health codes. It MUST NOT store authored fixtures, owner names, rule purpose, source labels, normalized source inputs or candidate sets.
- A support/audit view may traverse the central chain by opaque IDs only after realm authorization, with durable access audit and bounded time/object scope.
- Merge, split, tombstone, rollback and republish operations preserve predecessor/successor links. They never delete or repurpose an ID to make the historical chain appear different.

**Architecture fitness rule `FF-LIN-01`:** CI creates two fictional realms, two import batches, a merge/split, two rule revisions and a rollback publication; it must reconstruct every permitted predecessor/successor edge, reject every injected cross-realm edge, and prove that no raw URL/process/import label appears in endpoint activation or match-result storage.

The exact central lineage/audit retention is a **HUMAN DECISION**. Until approved, the implementation MUST support deletion/expiry policies without weakening referential integrity: expired sensitive staging content may be deleted while retaining a non-reversible batch/decision digest and the minimum durable audit evidence authorized by policy.

---

# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility rules

## 6.1 Application lifecycle state machine

```text
                 approve revision
  [DRAFT] ------------------------------> [ACTIVE]
     |                                       |
     | reject/abandon                        | retire
     v                                       v
 [tombstoned draft]                       [RETIRED]
                                             |
                           approved merge    |
                           into same realm   |
                                             v
                                          [MERGED] ---> terminal

  [ACTIVE] --approved merge--> [MERGED]
```

Rules:

- Draft abandonment leaves an immutable audit/tombstone; the ID is not reused.
- Only an approved current revision can make an application active.
- An application with published effective rules cannot be retired without conflict/impact preview and either rule retirement or an explicit scheduled transition.
- Merge checks for cycles and same-realm target in the transaction.
- Merge does not automatically retarget existing rules. A change set must create new rule revisions, re-run tests/conflicts and publish.

## 6.2 Import state machine and quality workflow

```text
RECEIVED -> PARSED -> VALIDATED -> QUALITY_REVIEW -> MAPPED -> APPROVED -> APPLIED
    |          |          |             |             |          |
    +--------> QUARANTINED <-------------+-------------+----------+
    +--------> REJECTED
    +--------> CANCELLED
```

### 6.2.1 Step behavior

1. **RECEIVED:** Store bounded encrypted staging object and SHA-256; create audit record. Do not parse in the request thread beyond envelope checks.
2. **PARSED:** Strict CSV parser produces row objects and HMAC row fingerprints. Structural failure quarantines the whole batch; no partial continuation.
3. **VALIDATED:** Apply schema, Unicode, bounds and source-contract checks. Raw values stay in restricted staging; normal logs receive codes/counts only.
4. **QUALITY_REVIEW:** Present exact source values only to authorized reviewers in the realm. Show escaped controls, Unicode code points where relevant, normalization diffs and candidate records without auto-selecting.
5. **MAPPED:** Every row has an explicit action: create draft, link existing, update draft, no change, or reject. Name/alias similarity can order suggestions but never choose an action.
6. **APPROVED:** An authorized approver binds the source hash, row-action hash and quality report. Separation of duties is enforced according to the unresolved human role model.
7. **APPLIED:** One idempotent transaction applies the exact approved action set, creates immutable revisions/provenance and audit, then marks the batch applied.
8. **QUARANTINED:** No registry mutation. Reviewer may create a corrected child batch linked to the original; the original bytes are never altered.
9. **REJECTED/CANCELLED:** Terminal. Cleanup follows approved staging retention and leaves metadata/audit evidence.

### 6.2.2 Import transaction boundary

`APPLY IMPORT` obtains a per-realm/source lock and runs one database transaction:

1. re-read batch in `APPROVED` state;
2. verify source SHA, row-action hash and approval hash;
3. verify no previously applied idempotency key;
4. re-check external-key conflicts and same-realm references against current committed state;
5. allocate UAM UUIDs for approved creates;
6. insert logical application rows and immutable revisions/aliases/external refs/provenance;
7. update current revision pointers for approved updates;
8. insert durable audit entries;
9. set batch `APPLIED` and commit.

A failure rolls back all registry mutations. It never publishes or modifies matcher rules. A retry with the same idempotency key returns the prior result.

## 6.3 Rule revision lifecycle/state machine

```text
[DRAFT]
   |
   | submit: schema + semantic validation + fixtures
   v
[VALIDATING] --validation fail--> [DRAFT with findings]
   |
   | analysis complete, immutable hash fixed
   v
[REVIEW_REQUIRED] --reject--> [REJECTED]
   |       |
   |       +--withdraw--> [WITHDRAWN]
   |
   | approve exact hashes
   v
[APPROVED]
   |
   | effective date in future
   v
[SCHEDULED]
   |
   | included in signed realm snapshot and effective
   v
[PUBLISHED] --new revision--> [SUPERSEDED]
   |
   +--approved retirement snapshot--> [RETIRED]
```

### 6.3.1 Immutability point

When validation succeeds and the revision enters `REVIEW_REQUIRED`, its semantic content and test set become immutable. Any edit creates the next revision. Approval records bind:

- rule content SHA-256;
- test set SHA-256;
- target application/revision state;
- analysis ID, analyzer build and rule-set hash;
- owner, purpose, effective interval and rollback plan;
- product privacy-ceiling compatibility.

### 6.3.2 Publication gate

A rule revision is publishable only when all are true:

```text
application is ACTIVE
AND application/rule/owner are in same realm
AND owner field is non-empty and valid under chosen authority contract
AND purpose is non-empty
AND revision is immutable and APPROVED/SCHEDULED
AND at least one positive and one negative synthetic fixture pass
AND every boundary predicate has a negative fixture
AND conflict analysis is current and not blocked/unknown
AND non-zero priority has explicit override approval and review date
AND matcher family/fields/normalizer fit release privacy ceiling
AND effective interval is valid
AND rollback target/procedure is recorded and testable
AND durable audit is available
```

This is the mechanical form of the primary gate. Human approval authority remains unresolved but cannot be omitted from the schema or workflow.

## 6.4 Rule simulation and impact preview

Before approval and publication, the system produces an impact package containing only governed configuration and synthetic evidence:

- canonical diff from prior revision;
- added/removed/changed normalized predicates;
- applications/rules affected by overlap or shadowing;
- generated overlap witnesses;
- every synthetic fixture before/after outcome;
- snapshot rule/byte delta estimates;
- matcher family/normalizer/endpoint compatibility impact;
- scheduled effective/expiry timeline;
- rollback candidate content hash and expected sequence behavior;
- whether a kill switch can contain the change.

No production event count is required for the initial gate. A future privacy-approved aggregate impact preview may use server-side minimized facts, but it must be a separately reviewed feature and cannot expose raw observations or become an automatic approval.

## 6.5 Snapshot build/publication lifecycle

```text
BUILDING -> VALIDATED -> SIGNED -> PUBLISHED -> SUPERSEDED
    |           |           |          |
    +---------> FAILED      +--------> REVOKED (control-plane status)
```

“Revoked” centrally does not make an offline endpoint forget a snapshot. Containment requires an emergency disabled-family control or higher-sequence replacement to reach the endpoint; hard expiry bounds the offline stale interval.

### 6.5.1 Server publication transaction

Publication uses a per-realm serialization lock and separates deterministic build from the short database transaction.

**Outside transaction:**

1. resolve exact approved rule/publisher-profile revisions at target effective time;
2. verify gates and product ceiling;
3. run complete conflict analysis and fixtures with the release matcher build;
4. compile canonical payload and manifest candidate;
5. enforce build bounds and calculate hashes;
6. obtain signing authorization and signature.

**Inside transaction:**

1. lock realm publication sequence;
2. revalidate that all referenced revisions/approvals/analysis hashes remain current;
3. allocate `sequence = previous + 1`;
4. bind final sequence/realm into manifest and obtain/finalize signature through the controlled signer protocol;
5. insert immutable snapshot/artifact reference;
6. update realm current-snapshot pointer;
7. insert durable audit event;
8. commit.

If signing cannot occur inside the transaction boundary, use a reservation state with a unique sequence and short lease; an abandoned reservation is never reused. Publication pointer changes only after a valid signature is persisted. The exact signer transaction protocol needs an implementation ADR, but monotonic non-reuse is invariant.

## 6.6 Endpoint activation lifecycle and transaction

Local states:

```text
NONE -> DOWNLOADED -> VERIFIED -> INDEXED -> PENDING -> ACTIVE -> PREVIOUS -> ELIGIBLE_FOR_CLEANUP
          |              |          |
          +-----------> REJECTED <---+
```

Validation and index construction occur outside the SQLite write transaction using bounded temporary storage. Activation uses the accepted single writer:

```sql
BEGIN IMMEDIATE;
  INSERT OR IGNORE INTO matcher_snapshot_blob (...immutable verified bytes/hash...);
  UPDATE matcher_snapshot_state
     SET role = 'PREVIOUS'
   WHERE role = 'ACTIVE';
  UPDATE matcher_snapshot_state
     SET role = 'ACTIVE', activated_at = :now
   WHERE snapshot_id = :new_snapshot_id;
  UPDATE matcher_runtime_pointer
     SET active_snapshot_id = :new_snapshot_id,
         highest_accepted_sequence = :sequence,
         contract_version = :contract;
  INSERT INTO local_health_event (...bounded code only...);
COMMIT;
```

A crash before commit leaves the old active snapshot. A crash after commit uses the new active snapshot. Cleanup never deletes active or previous data and occurs only after an approved rollback window/disk policy. No unacknowledged event data is deleted as part of snapshot cleanup.

## 6.7 Rollback

Rollback is forward-moving configuration:

1. Select a previously approved snapshot/rule-set content hash.
2. Re-run current release ceiling, compatibility, conflict and fixture checks. Previously approved content may no longer be safe under a new ceiling or signer policy.
3. Build a new manifest with a sequence greater than every prior accepted sequence and `rollbackOfSnapshotId` pointing to the bad snapshot.
4. Sign, publish and audit it as a new snapshot.
5. Track bounded adoption/verification outcome by snapshot sequence without per-device metric labels.
6. Keep the bad artifact for the approved incident-evidence period, mark it revoked centrally, and prevent republishing its exact rule revisions without a new approval.

The endpoint never accepts a lower sequence, even when its bytes match an older good snapshot. This prevents rollback from becoming a downgrade/replay channel.

## 6.8 Compatibility rules

### 6.8.1 Schema versions

- `schemaMajor` change means potentially incompatible wire structure. Endpoint rejects unsupported majors.
- `schemaMinor` may add fields only when the current major defines them as optional and ignorable. The signer/compiler still strips unknown fields from older endpoints' artifacts.
- Matcher contract and normalization versions are independent explicit identifiers. A schema-compatible snapshot can still be unusable if its normalizer is unsupported.
- The compiler knows endpoint capability cohorts from the governed release inventory and must not publish a single realm snapshot that strands an approved endpoint cohort. If mixed cohorts exist, publish cohort-specific artifacts under the same logical rule set with distinct payload hashes and compatibility manifests; semantics must remain equal under conformance tests.

### 6.8.2 Normalization evolution

A new normalizer version is not an in-place patch. Rollout requires:

1. frozen old/new golden corpora;
2. differential output report for every existing synthetic rule/fixture;
3. explicit handling for changed normalization;
4. endpoint support deployed before snapshots reference the version;
5. dual-simulation period centrally;
6. canary/ring activation using fictional data first;
7. rollback to a higher-sequence artifact using the old supported version.

Rules name one normalization version. They are not silently reinterpreted by a library update.

### 6.8.3 Time behavior

- Effective-time evaluation uses a monotonic snapshot activation decision plus UTC wall time for rule intervals.
- Excessive clock uncertainty causes `SNAPSHOT_UNAVAILABLE`/health degradation according to a bounded policy; it must not activate future rules early.
- `softExpiresAt` produces health degradation while continuing last-known-good matching.
- At `hardExpiresAt`, the affected matcher is disabled and returns `SNAPSHOT_EXPIRED`; stale classification does not continue indefinitely.
- Exact skew tolerances and expiry durations are human/measurement decisions.

## 6.9 Staged rollout

1. **Developer unit stage:** no external data; pure matcher and schema tests.
2. **Sanitized import stage:** reproduce only the supplied aggregate shapes, including five missing external IDs, Unicode, one IPv4-like label and nine truncation warnings, with fictional values.
3. **Fictional simulator stage:** generate URL/process rules, overlaps, shadows and malformed inputs.
4. **Windows lab stage:** process metadata acquisition against purpose-built fictional binaries/paths and test certificates; no production users or activity.
5. **Snapshot stage:** signed test key, realm isolation/adversarial envelopes, offline/expiry/rollback drills.
6. **Endpoint canary stage:** URL host matching only, synthetic browser-history data, path and process families disabled.
7. **Limited approved pilot:** only after human purpose/source/access/retention decisions and all stop gates. Observe bounded outcomes, not raw inputs.
8. **Broader deployment:** only after measured endpoint budgets, support runbooks, incident exercise and owner coverage.

A failed stage stops dependent stages and creates an ADR issue. Passing one stage proves only its named claim.


---

# 7. Security/privacy threat and failure register

## 7.1 Functional owner placeholders

The table uses functional ownership labels so implementation work has a destination without inventing the organization’s actual roles. Assigning accountable people is a **HUMAN DECISION**.

- **Registry owner:** registry schema, import, provenance and data-quality runbooks.
- **Rule governance owner:** rule purpose/ownership/approval process and conflict exceptions.
- **Endpoint runtime owner:** User Host, Task Host, Coordinator matcher and local snapshot state.
- **Release/signing owner:** compiler pipeline, signer keys, privacy ceiling and artifact publication.
- **Platform operations owner:** service/database/artifact availability and restore.
- **Security incident owner:** realm breach, signing compromise, malicious rules and privacy incidents.
- **Product/accessibility owner:** usable and accessible administrative workflow.

## 7.2 Threat and failure register

| ID | Trigger/failure | Detection/evidence | Immediate containment | Recovery | Cleanup | Functional owner | Required test | Residual risk |
|---|---|---|---|---|---|---|---|---|
| T-01 | Import or administrator attempts to derive an application/rule from a label alone | Missing independent mapping evidence; `REG-MAP-001`; audit diff | Block apply/submission; keep draft/quarantine | Obtain owner/source evidence and explicit fixtures or reject | Remove unapproved suggestion cache; retain audit | Registry + rule governance | R-03, RL-03 | Humans can still approve bad evidence; separation/review needed |
| T-02 | Missing, duplicated, reused or changed external ID | Source-contract validator; duplicate query; `REG-EXT-001..003` | Quarantine all conflicting rows; no auto-merge | Human reconcile; add/retire external-reference revisions | Expire staging under approved retention | Registry | R-04 | Source can be wrong while syntactically unique |
| T-03 | Malformed/oversized CSV or formula-injection content | Parser bounds; schema errors; safe-export test | Reject/quarantine before full allocation; disable export if escaping fails | Correct source/export profile and re-import as child batch | Delete staged bytes per policy; retain hash/codes | Registry | R-03, R-06, FZ-01 | Novel spreadsheet clients may interpret additional prefixes; raw export should remain restricted |
| T-04 | Bidi controls, mixed scripts, confusable or truncation creates deceptive label | Unicode quality scanner; escaped/code-point UI; collision report | Block unsafe/truncated activation; warn on confusable | Human chooses canonical display revision; preserve source provenance | Invalidate search index and rebuild versioned keys | Registry + product/accessibility | R-05, UI-02 | Unicode spoofing cannot be eliminated; clear dual display and human judgment remain |
| T-05 | Request, cache entry, FK or snapshot crosses realm | Composite FK, realm context assertion, cache prefix, `REALM-001`, security alert | Reject transaction/download; freeze affected publication path | Rotate compromised credentials if applicable; replay audit; correct code/data through governed migration | Purge unsafe cache/artifact; verify no cross-realm exposure | Security + all component owners | RI-01..RI-06 | Database administrators/signing infrastructure remain high-trust |
| T-06 | Broad/high-priority rule intentionally or accidentally shadows others | Static shadow report, impact preview, non-zero-priority gate | Block publication; emergency freeze if already live | Publish higher-sequence corrected/rollback snapshot | Retire bad revision; preserve incident evidence | Rule governance + release | A-02, U-06, IR-01 | A valid but semantically wrong narrow rule may evade static conflict proof |
| T-07 | Future code introduces regex, script, callback or unbounded expression | Architecture test/dependency scan; schema rejects unknown family | Build fails; publication rejects unsupported contract | Remove feature or open explicit ADR/threat model | Delete experimental artifacts from release path | Endpoint + rule governance | FF-01 | Code review can miss reflection/dynamic paths; static scans are defense in depth |
| T-08 | Cross-application overlap/ambiguity or hidden row-order dependency | Analyzer, generated witness, permutation property tests, `RULE-CNF-*` | Block snapshot; endpoint returns `AMBIGUOUS` if legacy artifact contains it | Correct/split rules and republish | Supersede offending revisions | Rule governance | A-01..A-04, U-06 | Analyzer defect could miss a witness; generated exhaustive boundary corpus reduces risk |
| T-09 | Server and endpoint normalize differently after runtime/library update | Golden corpus hash, differential CI, telemetry `UNSUPPORTED_CONTRACT` | Freeze publication of new normalizer; endpoint retains compatible LKG | Deploy compatible runtime or publish higher-sequence old-version snapshot | Retire incompatible artifacts after evidence retention | Endpoint + release | U-02..U-05, CP-01 | Standards evolve; pinned UAM semantics must be maintained deliberately |
| T-10 | Host-suffix boundary bug maps `notexample.test` to `example.test` | Unit/property tests; analyzer witness | Disable URL family if live and widespread | Patch matcher, republish signed snapshot/runtime under release process | Add regression vector permanently | Endpoint + security | U-01 | Other parser corner cases may remain until fuzzing finds them |
| T-11 | Query, fragment, credentials or raw URL enters IPC/log/snapshot | Contract-schema test, canary scanner, log/metric DLP test, `OBS-001` | Kill URL family and freeze publication; isolate diagnostics | Patch minimizer/contract and verify deletion scope under policy | Purge forbidden diagnostics under incident/legal process; rotate leaked tokens if any | Security + endpoint | PRIV-01..04, IR-02 | Backup/third-party log deletion may be operationally complex |
| T-12 | IDNA/confusable domain authored deceptively | UTS #46 validation; Unicode/A-label dual display; UTS #39 warning | Block invalid; require explicit confirmation for warning | Correct canonical A-label rule and republish | Retire deceptive revision | Rule governance | U-02, UI-02 | Visually similar valid domains can still fool humans |
| T-13 | Unsigned/spoofed executable copies product/filename metadata | Trust status + exact signer profile; negative fixture | Return unmatched/metadata status; never fall back implicitly | Add proper signed rule or path rule through governance | None beyond volatile buffer clearing | Endpoint | P-01, P-02 | Compromised trusted signing key remains outside matcher’s ability to distinguish |
| T-14 | Publisher certificate rollover causes false unmatched or overbroad acceptance | Profile expiry dashboard, synthetic old/new signer tests | Keep explicit old/new windows; block unknown signer | Approve profile revision and republish before rollover | Retire expired signer identities after rollback window | Rule governance + release | P-03 | Vendor may change signing chains without notice; owner monitoring is required |
| T-15 | Path spoof, reparse point, user-writable path or prefix-string confusion | Final-handle path, known-folder mapping, segment boundary, writable-location negative fixtures | Return unmatched/unavailable; disable weak path family on incident | Correct rule/acquisition; publish higher-sequence artifact/runtime | Clear temporary metadata; add regression fixture | Endpoint + security | P-04, P-05 | Filesystem/filter-driver behavior varies and needs lab coverage |
| T-16 | Executable replaced between path, signature and version reads (TOCTOU) | File ID/basic metadata before/after; `MATCH-META-002` | Return `METADATA_RACE`; no weaker fallback | Retry later under bounded policy or leave unmatched | Clear buffers; bounded count only | Endpoint | P-06 | Some filesystem/file-version APIs remain path-oriented; complete atomicity may be impossible |
| T-17 | Process exits or access is denied | Explicit OS error mapping; `MATCH-META-001` | Return `METADATA_UNAVAILABLE`; do not elevate privilege | None or bounded later observation | Clear handle/buffers | Endpoint | P-07 | Operational unmatched rate may be material; measure without raw data |
| T-18 | Malicious PE/version-resource metadata exploits parser/wrapper | Fuzz/ASan-like native harness where possible, crash telemetry, restricted Task Host | Kill process family; Task Host boundary limits blast radius | Patch wrapper/runtime; republish; review security bulletin/dependencies | Remove crash dumps containing raw bytes unless explicitly approved | Endpoint + security | FZ-02, P-08 | Platform parser vulnerabilities are upstream risk; patch lifecycle is essential |
| T-19 | Snapshot modified, signed for wrong realm/ceiling, or hash mismatches | Signature/hash/audience checks; `SNAP-VER-001/002` | Reject and preserve LKG; security alert | Correct artifact/signing path; rotate key if compromise suspected | Quarantine artifact; preserve forensic hash | Release + security | S-01, S-02 | Compromised authorized signer can produce valid malicious artifacts |
| T-20 | Replay/downgrade/sequence reuse | Highest accepted sequence and unique server sequence; `SNAP-VER-003` | Reject; retain LKG | Publish new higher sequence; investigate signer/store | Mark replayed artifact revoked; correct cache/CDN | Release + endpoint | S-03, S-07 | Endpoint restored from an old disk image needs secure highest-sequence recovery design |
| T-21 | Compression bomb/deep JSON/huge counts exhaust endpoint | Declared/actual bounds, streaming decompression, parser depth/count caps | Abort before allocation; keep LKG | Rebuild bounded snapshot or adjust approved limit after evidence | Delete rejected temp file | Endpoint + release | S-04, FZ-03 | Legitimate future scale may approach bounds; capacity governance needed |
| T-22 | Signing key/compiler pipeline compromised | Key-use audit, provenance/SBOM/attestation, unexpected snapshot diff, incident alerts | Freeze publication, disable affected key, issue emergency family disable/new key path | Rebuild from trusted source, rotate keys, republish higher sequence, validate fleet adoption | Revoke artifacts/credentials; preserve evidence | Security + release | SEC-01, IR-01 | Offline endpoints cannot receive immediate revocation; hard expiry bounds but does not remove gap |
| T-23 | Durable audit write fails or approval hash mismatches | Transaction error, `AUD-001/002` | Privileged mutation/publication fails | Restore audit storage or repair through controlled recovery | Reconcile abandoned drafts/reservations | Platform + relevant control owner | TX-01, S-09 | Emergency pressure may tempt bypass; no bypass path should exist in normal service |
| T-24 | Feature flag widens ceiling, defaults on after provider failure, or is changed unaudited | Ceiling intersection test; safer-default test; audit; flag-state health | Force family disabled; freeze provider updates | Restore signed known-good config; correct provider | Retire stale temporary flags; retain incident audit | Release + endpoint | FF-02..05 | Long-lived flags can become confusing policy; ownership/expiry reviews needed |
| T-25 | Logs/metrics expose values or high-cardinality IDs | Schema/cardinality linter, test sink scanner, metric series guard | Drop unsafe label/value; disable affected exporter | Patch instrumentation and rotate/delete data under policy | Purge unsafe telemetry and derived indexes where required | Security + platform | OBS-01..04 | Free-form upstream library messages may leak unless wrapped consistently |
| T-26 | Offline endpoint continues revoked bad rules | Soft/hard expiry state, sequence adoption reports, health counts | Emergency kill switch when reachable; hard expiry disables matcher | Reconnect and install higher-sequence safe snapshot | Remove bad snapshot after rollback window | Endpoint + security | S-06, IR-01 | No control plane can instantly revoke a disconnected endpoint; residual gap is inherent |
| T-27 | Rollback points to incompatible/unsafe old content or fails midway | Pre-rollback revalidation; canary; activation health | Freeze rollout; LKG remains on failed endpoints | Build corrected higher-sequence snapshot; repair runtime compatibility | Mark failed rollback artifact revoked | Release + endpoint | S-07, S-08 | Mixed endpoint versions complicate semantic parity |
| T-28 | User/session A can influence or read User Host/Task Host result for session B | IPC authentication/session binding, negative multi-session tests | Terminate offending IPC/session host; reject message | Patch launcher/ACL/handshake; redeploy under baseline gates | Clear local queues/state linked to invalid session | Endpoint + security | RI-07 | Session isolation relies on broader accepted endpoint architecture and needs its own gate |
| T-29 | Very large valid rule set causes CPU/memory/startup denial | Compiler/endpoint benchmarks and hard ceilings | Reject build; retain current snapshot | Simplify/index/partition only after measured ADR | Delete oversized artifact | Release + endpoint | PERF-01..04 | Exact safe capacity is unknown until representative hardware tests |
| T-30 | CMDB/source sends malicious or stale ownership/category claims | Authority matrix, provenance/currentness, conflict states | Keep as proposal/conflict; do not overwrite approved fields | Source reconciliation and approved revision | Retire stale link/claim | Registry | R-08 | Syntactically valid authoritative source can still be semantically wrong |
| T-31 | Owner disappears or rule purpose becomes stale | Periodic owner/purpose review and failed owner-resolution status | Stop new publication/renewal; optionally schedule retirement per human policy | Assign approved owner and new revision/approval | Retire expired assignments | Rule governance | GOV-01 | Exact review interval/behavior is a human decision |
| T-32 | Support requests raw production URL/path/catalogue/credentials | Runbook guardrails, ticket template, security training audit | Refuse collection; use synthetic reproducer | Escalate to approved privacy/security incident lane if genuinely necessary | Delete accidentally received data under incident process | Support functional owner + security | SUP-01 | Humans can paste sensitive data despite controls; intake filtering helps but is not perfect |
| T-33 | Inaccessible UI causes mistaken approval/rollback | Automated/manual WCAG checks, keyboard/screen-reader test | Block release of affected workflow | Correct UI and repeat approval usability test | Remove inaccessible obsolete view | Product/accessibility | UI-01..04 | Automated testing cannot prove all assistive-technology usability |
| T-34 | Clock skew activates early or accepts expired snapshot | Time-health state, test clock injection | Do not activate future snapshot; degrade/disable at hard expiry | Restore trusted time and reevaluate signed artifact | Clear only temporary pending state | Endpoint + platform | S-06, TM-01 | Long offline periods make trustworthy time difficult; policy must define behavior |
| T-35 | Crash/DB failure partially applies an import or current pointer | Transaction/idempotency tests, invariant query | Rollback transaction; freeze source if invariant breaks | Restore/retry by same idempotency key; run reconciliation | Remove orphan staging/artifacts only after proof | Registry + platform | TX-02..04 | Database/driver defects remain possible; restore drills required |
| T-36 | Snapshot retention/cleanup fills disk or deletes LKG | Disk watermark health, invariant check, cleanup audit | Stop downloads/building indexes before deleting active/previous | Free nonessential temp/rejected artifacts; adjust measured policy | Reconcile artifact table/files | Endpoint + platform | S-10, PERF-04 | Long outage plus many failed snapshots can create pressure; no silent deletion permitted |

## 7.3 Incident response runbooks

### 7.3.1 Bad or overbroad rule already published

1. Declare incident and identify realm, snapshot ID/sequence, rule IDs/revisions and content hashes through authorized central records—never by collecting endpoint raw observations.
2. Set `snapshot_publication_enabled=false` for ordinary changes and, when justified, issue the authorized matcher-family kill switch.
3. Reproduce with the canonical synthetic fixture or generate a safe `.test` witness.
4. Select last approved safe rule-set content, revalidate it under the current privacy ceiling/runtime, and publish it as a higher-sequence rollback.
5. Monitor bounded snapshot verification/activation and matcher outcome health by cohort, not per-device metric labels.
6. Quarantine the bad revision from reuse, preserve audit/compiler/signer evidence and determine whether the signer or authoring path was compromised.
7. Correct rule/analyzer/tests, require new approval, and stage re-enablement through canary.
8. Clean temporary artifacts and unsafe diagnostics under approved retention/deletion procedure; add permanent regression fixture.

### 7.3.2 Suspected privacy leak in logs/IPC

1. Disable the affected matcher family and diagnostic/export path.
2. Freeze log movement/retention changes long enough for the authorized incident owner to identify scope.
3. Verify the exact forbidden field and components using schemas/test sinks; do not repeat the raw value in tickets.
4. Patch minimization and telemetry wrappers; run `PRIV-*` and `OBS-*` tests.
5. Apply approved deletion/credential-rotation/legal notification decisions. Research does not make those decisions.
6. Re-enable only after synthetic canary proves forbidden canaries do not cross the boundary.

### 7.3.3 Suspected signer compromise

1. Freeze publication and mark the key unauthorized in the release trust policy.
2. Compare all artifacts signed by the key to approved gate records/content hashes.
3. Build from trusted source, rotate to an approved replacement key, and publish a higher-sequence safe snapshot plus emergency disable as required.
4. Account for offline endpoints until hard expiry; do not claim immediate revocation.
5. Preserve key-use/signing/audit evidence and follow enterprise key-compromise procedure.

## 7.4 Support ownership and runbook minimums

Before a pilot, each functional owner must have a named accountable team/person and an accessible runbook covering:

- symptoms and bounded error codes;
- safe evidence to collect and forbidden evidence;
- feature/kill-switch authority and exact audit path;
- last-known-good and higher-sequence rollback;
- realm isolation escalation;
- signing-key and privacy incident escalation;
- import quarantine and external-ID conflict handling;
- publisher rollover procedure;
- disk/full-snapshot cleanup without data loss;
- after-hours support expectation, which is a **HUMAN DECISION** tied to SLOs and staffing;
- recovery verification and incident closure evidence.

---

# 8. Detailed test matrix and smallest falsifying prototypes

## 8.1 Test-data rules

All fixtures use fictional application names, UUIDs, signer identities and RFC 2606 `.test` domains. No fixture may contain an internal host, address, credential, personal information, user profile name, real application catalogue value, raw browser history or production process path.

A test-canary scanner rejects common secret formats, non-reserved domains in URL fixtures, network addresses outside documentation ranges, and configured organization-specific forbidden terms before a fixture can enter source control.

## 8.2 Fictional application fixture set

| Application | Application ID | Purpose in tests |
|---|---|---|
| Northwind Ledger | `00000000-0000-7000-8000-000000000101` | Exact/suffix host and ambiguity tests |
| Fabrikam Studio | `00000000-0000-7000-8000-000000000102` | Host/path specificity and overlap tests |
| Cobalt Writer | `00000000-0000-7000-8000-000000000103` | Signed product/path/process tests |
| Contoso Archive (fictional test only) | `00000000-0000-7000-8000-000000000104` | Retirement/merge/rollback tests |

These names are test fiction and are not catalogue values or owner claims.

## 8.3 URL conformance matrix

Assume rule `R-L1` targets Northwind Ledger with exact HTTPS host `ledger.example.test`, default port, no path. Rule `R-L2` is a suffix rule for `ledger.example.test`, `includeApex=false`. Additional rules are stated per test.

| ID | Fictional input | Rule setup | Expected outcome | Property proved |
|---|---|---|---|---|
| U-01 | `https://ledger.example.test/` | `R-L1` | `MATCHED` Northwind | Exact host/basic HTTPS |
| U-02 | `https://LEDGER.EXAMPLE.TEST./home` | `R-L1` | `MATCHED` Northwind | ASCII case and terminal root dot normalization |
| U-03 | `https://a.ledger.example.test/` | `R-L1` only | `UNMATCHED` | Exact host excludes subdomain |
| U-04 | `https://a.ledger.example.test/` | `R-L2` | `MATCHED` Northwind | Suffix at label boundary |
| U-05 | `https://ledger.example.test/` | `R-L2`, apex false | `UNMATCHED` | Explicit apex behavior |
| U-06 | `https://notledger.example.test/` | `R-L2` | `UNMATCHED` | No raw suffix/string-boundary bug |
| U-07 | `http://ledger.example.test/` | HTTPS-only `R-L1` | `UNMATCHED` | Scheme predicate |
| U-08 | `https://ledger.example.test:443/` | `R-L1` default | `MATCHED` | Default port normalization |
| U-09 | `https://ledger.example.test:8443/` | `R-L1` default | `UNMATCHED` | Non-default port excluded |
| U-10 | `https://ledger.example.test:8443/` | Exact port 8443 | `MATCHED` | Exact non-default port |
| U-11 | `https://xn--bcher-kva.example.test/` | Exact A-label rule for fictional `bücher.example.test` | `MATCHED` designated app | IDNA A-label equivalence |
| U-12 | `https://bücher.example.test/` | Same as U-11 | Same result/normalized bytes as U-11 | Unicode input equivalence under `url-v1` |
| U-13 | Visually confusable but different valid host | Only intended A-label rule | `UNMATCHED`; authoring warning | Confusable does not create equivalence |
| U-14 | `ftp://ledger.example.test/` | Any URL v1 rule | `INVALID_OBSERVATION` | Unsupported scheme fails closed |
| U-15 | `https://user:secret@ledger.example.test/` | `R-L1` | `INVALID_OBSERVATION`; no value in logs | Userinfo rejected/privacy |
| U-16 | `https://ledger.example.test/%ZZ` | Path-enabled rule | `INVALID_OBSERVATION` | Malformed percent escape |
| U-17 | `https://studio.example.test/workspace/a` | Fabrikam prefix segments `workspace` | `MATCHED` Fabrikam | Segment prefix |
| U-18 | `https://studio.example.test/workspaces` | Same | `UNMATCHED` | Prefix boundary |
| U-19 | `https://studio.example.test/a/../workspace/` | Same | `MATCHED` after defined dot-segment processing | Canonical path behavior |
| U-20 | `https://studio.example.test/workspace%2Fa` | Prefix `workspace/a` | `UNMATCHED` | Encoded slash is not separator |
| U-21 | `https://studio.example.test/%7Euser` | Exact normalized `~user` path | `MATCHED` | Unreserved percent decode |
| U-22 | `https://studio.example.test/workspace?q=token#fragment` | Host/path rule | Match ignores query/fragment; canaries absent from IPC/log | Minimization |
| U-23 | One exact Northwind rule and equal-priority exact Fabrikam rule for same host | Both | `AMBIGUOUS`, no app/candidates in endpoint result | Cross-target conflict behavior |
| U-24 | Two equally maximal rules for same app | Both target Northwind | `MATCHED` Northwind; stable provenance rule selected | Same-target tie |
| U-25 | Broad suffix priority 10 vs exact host priority 0 | Different apps | Priority rule wins only when override is approved; analyzer reports shadow | Explicit priority semantics |
| U-26 | Permute rule array/database order 10,000 times | Same rules | Identical outcome/provenance bytes every run | Order independence/determinism |
| U-27 | Input over each component/total bound | Any | Bounded `INVALID_OBSERVATION`; no excessive allocation | DoS resistance |
| U-28 | Old snapshot asks for `url-v99` | Endpoint supports v1 | `UNSUPPORTED_CONTRACT`, LKG retained | Compatibility failure |

## 8.4 Process conformance matrix

Use a purpose-built fictional signed test executable `CobaltWriter.exe`, publisher profile `P-FICTIONAL-A`, and known-folder path `PROGRAM_FILES_X64\Fictional\Cobalt\CobaltWriter.exe`. Test certificates and binaries exist only in the isolated lab and are not trusted for production.

| ID | Setup/observation | Rule | Expected outcome | Property proved |
|---|---|---|---|---|
| P-01 | Valid platform trust; signer hash in profile; product/original filename/version in range | `SIGNED_PRODUCT` Cobalt | `MATCHED` Cobalt | Strong family positive |
| P-02 | Same filename/product strings, unsigned or different signer | Same | `UNMATCHED` or trust-status failure; never filename fallback | Spoof resistance |
| P-03 | Old and new approved test cert overlap in rollover window | Profile rev with both | Both binaries match; outside windows only designated signer matches | Explicit rollover |
| P-04 | Valid signer, version below min or at max-exclusive | Signed rule | `UNMATCHED` | Numeric interval boundaries |
| P-05 | Exact known-folder path | `PATH_EXACT` | `MATCHED` | Token/segment mapping |
| P-06 | Same filename under a fictional user-writable local folder | Signed/path rule only | `UNMATCHED` | Location/spoof separation |
| P-07 | Prefix `Fictional\Cobalt` vs `Fictional\CobaltCopy` | `PATH_PREFIX` | First matches, second does not | Segment boundary |
| P-08 | Path directory marked case-sensitive and case differs | Case-insensitive-required rule | `METADATA_UNAVAILABLE` or `UNMATCHED` per exact contract, never silent insensitive match | Case-mode safety |
| P-09 | Final path through allowed reparse behavior resolves outside known folder | Path rule | `UNMATCHED` | Final-path mapping |
| P-10 | Replace test binary between version reads while handle remains | Any process rule | `METADATA_RACE` | TOCTOU detection |
| P-11 | Process exits before path acquisition | Any | `METADATA_UNAVAILABLE` | Ephemeral process handling |
| P-12 | Access denied under restricted token | Any requiring metadata | `METADATA_UNAVAILABLE`; no privilege escalation | Least privilege |
| P-13 | Corrupt/oversized version resource | Signed product | Bounded error; Task Host survives or exits contained; no raw dump | Parser hardening |
| P-14 | `CompanyName` matches but signer identity does not | Signed product | `UNMATCHED` | Display metadata non-authority |
| P-15 | Filename-only family disabled, matching filename present | Filename rule in snapshot rejected/disabled | `MATCHER_DISABLED`/build failure | Privacy/weak-family ceiling |
| P-16 | Rule/profile belongs to other realm | Compile/download attempt | Reject before endpoint; `REALM-001` | Realm isolation |
| P-17 | Permute signed/path rules | Same observation | Identical result | Determinism |

## 8.5 Registry/import/rule lifecycle test matrix

| ID | Setup and instrumentation | Steps | Pass/fail gate | Evidence artifact | **ESTIMATE** duration | Cleanup |
|---|---|---|---|---|---:|---|
| R-01 | Empty test realm; DB constraints; fixed UUID clock/random source | Create, rename, retire, merge fictional apps | ID never changes/reuses; merge same-realm only; cycle rejected | SQL invariant report + audit export | 15 min | Drop test realm/schema |
| R-02 | Two realms with deliberately identical object UUIDs | CRUD/search/link in each context; attempt cross-realm FKs and cache reads | Zero cross-realm result/mutation; every attack returns `REALM-*` | Adversarial test log without values | 20 min | Purge test caches/data |
| R-03 | Generated 173-row fictional CSV matching supplied counts/shapes | Validate, review, map, approve | Counts match fixture manifest; no rule rows created; truncations block | `import-report.json`, source hash, DB diff | 20 min | Destroy staged plaintext; retain synthetic report |
| R-04 | Missing keys, duplicate keys, source key reuse | Import under undecided and uniqueness-declared contracts | Missing warns; duplicates quarantine where contract applies; no auto-merge | Conflict report | 15 min | Drop fixtures |
| R-05 | NFC/NFD pairs, bidi, mixed scripts, confusables, non-ASCII, controls | Import and inspect accessible UI/API | Display preserved NFC; warnings exact; prohibited controls blocked; no identity merge | Unicode report + screenshots with fictional data | 30 min | Remove synthetic strings |
| R-06 | CSV cells beginning `=,+,-,@` and quoted/newline payloads | Import and safe-export | Parser treats as data; export cannot execute formulas in approved viewer test; logs contain no cell | Export scanner report | 20 min | Delete exported file |
| R-07 | Inject DB crashes before/after each import transaction statement | Retry same idempotency key | Either zero or complete application effect; same result on retry; audit consistent | Fault-injection matrix | 45 min | Restore clean DB snapshot |
| R-08 | Conflicting CMDB/owner proposals from two fictional sources | Apply authority matrix variants | Proposal-only source never overwrites approved field; conflict visible | Field-authority test report | 20 min | Drop sources |
| RL-01 | Draft missing each gate field in turn | Submit/approve/publish | Every missing owner/purpose/revision/tests/analysis/approval/rollback blocks | Gate coverage report | 20 min | Drop drafts |
| RL-02 | Approve revision then mutate DB/API payload/hash | Publish | Mutation impossible or hash mismatch blocks; audit alert | Tamper test | 15 min | Restore test DB |
| RL-03 | Import aliases that look like fictional domains/process names | Run suggestion/import | No matcher rule is created or proposed as authoritative | DB zero-row assertion | 10 min | Drop batch |
| RL-04 | Schedule overlapping revisions/effective boundaries | Compile at `t-1`, `t`, `t+1` | Half-open interval behavior exact; no double-active unintended revision | Timeline report | 15 min | Drop fixtures |
| TX-01 | Make durable audit store fail | Attempt every privileged mutation | No mutation acknowledged/committed | Transaction trace | 15 min | Restore audit store |
| TX-02 | Concurrent import/app revision/rule publish races | Run controlled interleavings | Serialization/conflict is explicit; no lost update or mixed hashes | Concurrency trace | 30 min | Reset DB |

## 8.6 Analyzer, matcher and snapshot matrix

| ID | Setup and instrumentation | Steps | Pass/fail gate | Evidence | **ESTIMATE** duration | Cleanup |
|---|---|---|---|---|---:|---|
| A-01 | Generator with seeded known overlaps/disjoint pairs | Generate 10k URL/process pairs; analyze | Detect 100% injected cross-target ambiguities/shadows; witnesses re-match as predicted; no result depends on order | Seed, fixture manifest, analyzer report | 30 min | Retain synthetic corpus in test artifacts |
| A-02 | Broad/narrow rules with priorities | Analyze all containment combinations | Every full/partial shadow classified exactly; unapproved override blocks | Shadow lattice report | 20 min | Drop generated DB rows |
| A-03 | Cases analyzer cannot model | Attempt submission | `UNKNOWN_ANALYSIS` blocks; no “assumed disjoint” branch | Negative test report | 10 min | None |
| A-04 | One canonical rule/fixture corpus | Run endpoint matcher, server simulator, analyzer witnesses | Byte-identical canonical input hashes and identical outcomes/provenance | Cross-host conformance report | 20 min | Retain report |
| CP-01 | Build same logical rules in clean processes/machines | Compile repeatedly with fixed build/toolchain | Canonical payload and rule-set hash identical; signatures differ only where algorithm legitimately does | Reproducibility report | 30 min | Keep hashes, remove artifacts |
| S-01 | Valid snapshot; flip each manifest/payload/signature byte class | Download/verify | Every tamper rejected; LKG unchanged | Verification matrix | 30 min | Delete corrupt artifacts |
| S-02 | Valid signature but wrong realm/audience/ceiling | Verify on endpoint fixture | Rejected before activation | Realm/ceiling report | 15 min | Delete artifacts |
| S-03 | Duplicate, lower, skipped and very large sequences | Activate | Duplicate exact active is idempotent; lower rejected; higher accepted within type bounds; sequence never reused | Sequence state dump | 20 min | Reset local SQLite |
| S-04 | Compression bombs, wrong sizes, deep JSON, excessive arrays/strings | Verify | Bounded memory/disk/time; no activation; LKG remains | Resource trace | 30 min | Delete temporary files |
| S-05 | Kill process/power-fault at every local activation step | Restart | Active pointer is exactly old or new, never missing/mixed; previous preserved | Fault-injection journal/state report | 45 min | Recreate local DB |
| S-06 | Inject wall-clock skew, soft expiry, hard expiry, long offline | Evaluate/download | Future snapshot not early; soft warns; hard disables; reconnect installs safe higher sequence | Timeline/health report | 30 min | Reset clock fixture/state |
| S-07 | Publish bad snapshot then rollback previous content at higher sequence | Activate sequence N then N+1 | N+1 accepted; bytes/rules equal prior safe content; no lower sequence accepted | Rollback report | 30 min | Revoke/delete test artifacts |
| S-08 | Mixed endpoint contract cohorts | Compile compatible artifacts; compare semantics | Unsupported cohort never receives incompatible artifact; supported artifacts have identical fixture outcomes | Cohort compatibility report | 30 min | Drop cohort metadata |
| S-09 | Fail signer/audit/artifact store at each publication boundary | Publish/retry | No unsigned/current pointer; no sequence reuse; abandoned reservation explicit | Publication transaction report | 45 min | Reconcile reservations/artifacts |
| S-10 | Fill disk near watermarks with pending/rejected snapshots | Download/activate/cleanup | Active/previous never deleted; no event data touched; health alert before failure | Disk-state report | 30 min | Remove synthetic filler |

## 8.7 Security, privacy, observability and accessibility matrix

| ID | Setup | Steps | Pass/fail | Evidence | **ESTIMATE** duration | Cleanup |
|---|---|---|---|---|---:|---|
| PRIV-01 | Seed URL query/fragment/userinfo with unique fictional canaries | Run User Host through Coordinator IPC/test sinks | Zero canary bytes in IPC, SQLite, logs, traces, metrics or upload fixture | Binary/text canary scan report | 20 min | Destroy sink files |
| PRIV-02 | Seed process path/user-like segment/signer display canaries | Run Task Host failure/success cases | Only bounded outcome and opaque IDs cross boundary | IPC capture schema report | 20 min | Destroy captures |
| PRIV-03 | Snapshot compiler input includes all central metadata fields | Compile and scan artifact | None of names/aliases/owners/category/sensitivity/external/CMDB appear | Artifact canary scan | 15 min | Delete artifact |
| PRIV-04 | Trigger every exception path with canary inputs | Collect diagnostics | No exception/log contains input; only bounded code/correlation | Diagnostic scanner report | 30 min | Purge test logs |
| OBS-01 | Enumerate metric instruments/labels via source generator/registry | Run cardinality linter | Every label is closed/bounded; forbidden identifiers absent | `metric-contract-report.json` | 10 min | None |
| OBS-02 | Attempt dynamic label values and 100k unique IDs | Emit metrics | Guard maps to bounded `other`/reject counter; series count remains within approved bound | Prometheus scrape count | 15 min | Clear test TSDB |
| FZ-01 | Coverage-guided CSV/Unicode corpus | Fuzz parser/quality scanner | No crash/hang/OOM; failures bounded and deterministic | Fuzzer corpus/crash summary | 60 min initial | Keep minimized synthetic corpus |
| FZ-02 | Purpose-built malformed PE/version-resource corpus | Fuzz native wrapper in isolated lab | No host escape; crashes contained; no sensitive dumps | Fuzzer report | 60–180 min initial | Securely delete generated binaries if not retained |
| FZ-03 | Generated manifest/payload corpus | Fuzz verifier/decompressor/parser | No crash/hang/OOM/activation on invalid input | Fuzzer report | 60 min initial | Keep minimized corpus |
| FF-01 | Static dependency/code scan | Search for `Regex`, scripting/reflection/expression compilation in matcher path | Approved allowlist empty; build fails on violation | Architecture test report | 5 min | None |
| FF-02 | Provider absent/error/stale and tampered flags | Evaluate all families | New/risky families default off; tenant cannot widen ceiling | Flag truth-table report | 15 min | Reset flags |
| UI-01 | Admin workflow with keyboard only | Create/review/approve/rollback synthetic rule | All actions reachable, focus visible, no trap | Manual checklist/video under test policy | 30 min | Delete draft |
| UI-02 | Screen reader + Unicode/conflict pages | Navigate warnings and witness table | Names/relationships/severity understandable without colour/graph | Accessibility report | 45 min | Delete test records |
| UI-03 | Automated WCAG 2.2 checks | Scan all rule/import states | No blocking automated findings; manual findings tracked | Scanner report | 20 min | None |
| SUP-01 | Simulated support ticket requests raw values | Follow runbook | Agent/template refuses and requests synthetic reproducer; escalation correct | Exercise record | 20 min | Delete simulation ticket |
| IR-01 | Tabletop bad signed rule + one offline cohort | Execute rollback/kill-switch runbook | Higher-sequence rollback built; offline residual explicitly accounted; evidence complete | Incident exercise report | 60 min | Revoke test key/artifacts |
| IR-02 | Tabletop diagnostic privacy canary leak | Execute privacy runbook | Family/export stopped, scope identified without repeating canary, cleanup decisions escalated | Incident exercise report | 60 min | Purge test logs |

Durations are replaceable lab-run estimates, not delivery promises or production SLOs.

## 8.8 Performance and size matrix

Exact budgets are unknown. Store approved gates in a reviewed `thresholds.json` rather than hard-code prose values.

| ID | Workload | Instrumentation | Required result |
|---|---|---|---|
| PERF-01 | Compile 1k/10k/100k fictional URL rules with controlled overlap ratios | Wall/CPU time, allocations, peak RSS, output bytes, compression ratio, reproducibility hash | Complete within approved CI/release thresholds; deterministic output |
| PERF-02 | Match positive/negative/worst-overlap URL corpus across sizes | BenchmarkDotNet or equivalent fixed harness; warm/cold; p50/p95/p99/max; allocations | Meet approved per-observation CPU/allocation thresholds; no superlinear surprise without documented index reason |
| PERF-03 | Signed/path process matching with cached/uncached metadata in Windows lab | ETW/process CPU, handle count, wall time, Task Host lifetime, error distribution | Meet approved resource budget; no leaked handles; failure bounded |
| PERF-04 | Endpoint download/decompress/verify/index/activate full snapshots | Peak memory/disk, bytes, CPU, elapsed, SQLite transaction time, crash recovery | Meet approved endpoint budget and leave active+previous; otherwise stop and open size-format ADR |
| PERF-05 | Analyzer all-pairs worst case and indexed case at 1k/10k/100k | CPU/RSS, comparisons, witnesses, timeout count | No `UNKNOWN` due solely to unbounded runtime within approved publication budget; if failed, redesign indexes/grammar before scale claim |
| PERF-06 | Concurrent realms/imports/publications on server | DB waits/locks, throughput, isolation violations, audit latency | No cross-realm effect; per-realm serialization only where intended; meet approved platform thresholds |

## 8.9 Smallest falsifying prototypes

### Prototype FP-01 — Sanitized import validator

- **Claim falsified if:** UAM cannot reproduce the known quality shape without exposing values, auto-merging names or partially applying a bad batch.
- **Setup:** .NET console project; strict CSV library selected under dependency review; generated 173-row fictional fixture manifest with five missing external IDs, one IPv4-like label, ten non-ASCII labels and nine truncation markers.
- **Instrumentation:** SHA-256 input, deterministic JSON report, allocation/elapsed metrics, log canary scanner, test database diff.
- **Steps:** validate; inspect codes; map only clean rows; inject duplicate ID and malformed UTF-8; simulate crash at apply; retry idempotency key.
- **Pass:** exact expected counts; malformed batch quarantined; missing IDs do not block UAM UUID proposal; truncations block activation; no raw values in logs/report; apply is all-or-nothing and creates no rules.
- **Fail:** any name-based auto-link, partial registry mutation, formula execution, value leakage, nondeterministic report or rule creation.
- **Evidence:** fixture generator seed/source, manifest, report hash, DB before/after invariant query, canary scan.
- **ESTIMATE:** 30–60 minutes after build.
- **Cleanup:** delete staged plaintext/test DB; retain synthetic fixtures and hashes.

### Prototype FP-02 — Pure URL normalizer and matcher

- **Claim falsified if:** a small versioned grammar cannot produce deterministic, privacy-safe results across standards edge cases.
- **Setup:** C# library with no I/O; golden `.test` corpus from section 8.3; independent reference-vector generator where practical.
- **Instrumentation:** normalized-byte dump in test only, outcome/provenance hash, allocations, fuzz coverage.
- **Steps:** run all vectors; permute rules; change current culture; run concurrently; fuzz URL components; scan output/log contracts.
- **Pass:** identical results across runs/cultures/order; exact boundary/IDNA/path outcomes; no query/fragment/userinfo in result/diagnostics; bounded failures.
- **Fail:** platform/library update silently changes golden output, ambiguous case selects an app, suffix boundary error, or resource bound exceeded.
- **Evidence:** `url-v1-golden.json`, test report, fuzzer summary, dependency/runtime manifest.
- **ESTIMATE:** 20–45 minutes after build plus continuing fuzz campaign.
- **Cleanup:** retain only synthetic corpus.

### Prototype FP-03 — Conflict/shadow analyzer

- **Claim falsified if:** overlap and dominance cannot be proved completely enough for the closed grammar.
- **Setup:** seeded generator with explicit truth model for host suffixes, schemes, ports, path segment sets, known-folder paths, version intervals and signer sets.
- **Instrumentation:** comparison count, witness verification through matcher core, injected-finding recall, unexpected finding review set.
- **Steps:** generate disjoint/overlap/shadow/incomparable pairs and multi-rule sets; analyze; replay every witness; permute input.
- **Pass:** all injected blocking conflicts found; witnesses match both predicates and produce expected maximal set; deterministic report; unsupported logic blocks.
- **Fail:** any false-negative injected conflict, invalid witness, timeout treated as pass, or order-dependent classification.
- **Evidence:** seed, generator manifest, truth labels, analyzer build/hash, report.
- **ESTIMATE:** 30–90 minutes depending on sizes.
- **Cleanup:** retain minimized synthetic regressions.

### Prototype FP-04 — Windows process metadata adapter

- **Claim falsified if:** least-privilege acquisition cannot reliably distinguish signed product/path cases without sending raw metadata beyond the Task Host.
- **Setup:** approved Windows lab; fictional binaries/test certificates; known-folder and case-sensitive directories; restricted Task Host token; no network/production data.
- **Instrumentation:** ETW/Process Monitor where approved, handle/CPU/time counters, IPC capture, file-ID snapshots, crash containment.
- **Steps:** execute P-01..P-16; replace files mid-read; terminate processes; deny access; malformed version resources; inspect IPC/logs.
- **Pass:** exact expected outcomes; no elevation; no handle leaks; raw path/signature strings absent from IPC/log; races/unavailability do not fall back.
- **Fail:** spoof matches, cross-boundary leak, uncontrolled crash, unbounded latency, or common supported configuration cannot resolve safely.
- **Evidence:** redacted/synthetic lab inventory, binary hashes, test-cert fingerprints, result matrix, IPC canary scan.
- **ESTIMATE:** 60–120 minutes after lab fixture installation.
- **Cleanup:** remove test certificates/binaries/directories; verify trust store returned to prior state.

### Prototype FP-05 — Snapshot compiler, verifier and atomic activation

- **Claim falsified if:** complete signed snapshots cannot be reproducible, bounded, rollback-safe and crash-atomic.
- **Setup:** two synthetic realms; test signing key; 1k/10k/100k rule sets; local SQLite state; fault injector.
- **Instrumentation:** hashes/sizes/times/RSS, sequence/audit records, local transaction state, byte mutation corpus.
- **Steps:** compile twice; sign; tamper each field; cross realms; replay/lower sequence; inject decompression bomb; crash every activation point; publish higher-sequence rollback.
- **Pass:** canonical hashes reproducible; every tamper/wrong realm/downgrade rejected; old or new snapshot active after crash; rollback uses higher sequence; bounds met or explicit stop gate opens format ADR.
- **Fail:** mixed/absent active state, sequence reuse, bad artifact activation, cross-realm acceptance or unbounded resource use.
- **Evidence:** manifests, hashes, fault matrix, SQLite invariant dump, benchmark result.
- **ESTIMATE:** 60–120 minutes.
- **Cleanup:** destroy test key and artifacts; reset SQLite.

### Prototype FP-06 — Realm-isolation adversarial harness

- **Claim falsified if:** a duplicated ID, forged body realm, cache collision or cross-reference can cross realms.
- **Setup:** two realms with identical UUIDs and labels; distinct authenticated test principals/devices; shared process/cache/database instance.
- **Instrumentation:** authorization traces with opaque IDs, SQL query interceptor, cache-key recorder, audit events.
- **Steps:** attempt every CRUD, import mapping, rule target, publisher profile, snapshot download and rollback using other-realm IDs/body claims; run concurrent cache pressure.
- **Pass:** no data/result difference attributable to the other realm; every cross-reference rejects; endpoint artifact audience matches authenticated realm.
- **Fail:** any existence oracle in normal responses beyond approved generic error, data mutation/read, cache hit or accepted signature for wrong realm.
- **Evidence:** attack matrix and invariant queries.
- **ESTIMATE:** 30–60 minutes.
- **Cleanup:** delete both realms/caches/test credentials.

### Prototype FP-07 — Full performance envelope

- **Claim falsified if:** the simple complete-snapshot/index design misses approved endpoint/server budgets.
- **Setup:** representative supported Windows hardware cohorts and server CI runner; fixed generated workloads; release build; no debugger.
- **Instrumentation:** BenchmarkDotNet, ETW, process counters, disk/network byte capture, GC allocations, SQLite timings, analyzer counters.
- **Steps:** run cold/warm compile, download, verify, index, match and conflict workloads at 1k/10k/100k; repeat enough for stable confidence intervals; record environment.
- **Pass:** all values meet human-approved `thresholds.json`; no correctness change under load; cleanup leaves LKG.
- **Fail:** threshold miss, resource leak, nonlinear cliff, timeout treated as safe, or result changes.
- **Evidence:** machine/runtime manifest, command lines, raw benchmark JSON, summary and hashes.
- **ESTIMATE:** 30–90 minutes per representative cohort.
- **Cleanup:** delete synthetic artifacts/filler and restore baseline state.

---

# 9. Architecture fitness functions and measurable acceptance criteria

## 9.1 Build-time fitness functions

| Fitness function | Automated assertion | Failure action |
|---|---|---|
| FF-ID-01 Opaque identity | No code path accepts caller-supplied `application_id` on create; UUID generator conformance vectors pass | Build fails |
| FF-ID-02 No name-derived identity/rules | Static architecture test prevents registry search result from calling create/link/publish without explicit reviewed command; no hash/name ID generator | Build fails/security review |
| FF-RLM-01 Realm in every key | Schema analyzer proves all listed tables have leading `realm_id` PK and same-realm composite FK | Migration rejected |
| FF-RLM-02 No unscoped repository | Dependency/architecture test rejects repository methods without `RealmContext`, except explicitly isolated migration tooling | Build fails |
| FF-RUL-01 Closed grammar | Rule schema enums exactly match reviewed families; matcher assembly has no arbitrary regex/script/expression engine dependency | Build fails |
| FF-RUL-02 Determinism | Same canonical input and snapshot hash yields identical outcome/provenance across repeated, parallel, culture and order permutations | Release blocked |
| FF-RUL-03 Ambiguity safety | Every cross-target maximal tie returns `AMBIGUOUS` with null application/candidates | Release blocked |
| FF-RUL-04 Analyzer parity | Every analyzer witness, fixture and endpoint/server matcher result agrees | Release blocked |
| FF-GATE-01 Publication gate | Property test removes each required owner/purpose/revision/test/conflict/approval/rollback field and proves publish denial | Release blocked |
| FF-REV-01 Immutability | Database/API tests prove submitted/approved revisions cannot update semantic columns | Migration/release blocked |
| FF-PRV-01 Minimized endpoint schema | Snapshot and IPC JSON Schemas contain no forbidden central/raw fields; binary canary scan passes | Release blocked/privacy incident |
| FF-SNP-01 Signature/realm/sequence | Mutation corpus and wrong-realm/lower-sequence artifacts never activate | Release blocked/security incident |
| FF-SNP-02 Crash atomicity | Fault injection leaves exactly one trusted active snapshot and a valid previous pointer | Release blocked |
| FF-SNP-03 Reproducible content | Clean builds with fixed inputs produce identical canonical payload/rule-set hashes | Release blocked/investigate toolchain |
| FF-OBS-01 Bounded telemetry | Metric registry exposes only allowlisted bounded dimensions; log analyzer finds no raw fixture canaries | Release blocked |
| FF-AUD-01 Audit coupled | Every privileged command fails when audit transaction fails | Release blocked |
| FF-ACC-01 Accessible control path | Automated checks plus required keyboard/screen-reader workflow pass | Admin release blocked |
| FF-LIC-01 Dependency/license | SBOM contains only approved dependencies/licenses; reference-only projects have no copied source | Release blocked/legal review |

## 9.2 Runtime invariants

These must be continuously asserted where practical:

```text
For every matched endpoint result:
  application_id is present IFF outcome == MATCHED
  snapshot_sequence == local active snapshot sequence
  rule belongs to same realm snapshot
  rule target exists in snapshot application dictionary

For every active local snapshot:
  signature_verified == true
  payload_hash_verified == true
  realm == authenticated device realm
  sequence == highest_accepted_sequence
  hard_expires_at > activation_time
  schema/normalizer/privacy ceiling supported

For every published server snapshot:
  sequence unique and monotonically increasing per realm
  every rule revision has exact current approval/test/analysis hashes
  no blocking or unknown conflict
  audit event durably exists

For every registry link:
  all referenced rows share realm_id
  application IDs are never reused
  merged target is same realm and acyclic
```

An invariant violation is not silently repaired. It freezes the affected mutation/publication path and opens incident/reconciliation work.

## 9.3 Quantitative acceptance criteria

Numerical performance/capacity limits are unknown and cannot be invented. The implementation repository must contain an approved, versioned threshold file with named evidence owner:

```json
{
  "contract": "uam-matcher-thresholds-v1",
  "status": "HUMAN_DECISION_REQUIRED",
  "endpointCohorts": {
    "representative-cohort-a": {
      "maxCompressedSnapshotBytes": null,
      "maxUncompressedSnapshotBytes": null,
      "maxPeakActivationMemoryBytes": null,
      "maxActivationMilliseconds": null,
      "maxUrlMatchP99Microseconds": null,
      "maxUrlMatchAllocatedBytes": null,
      "maxTaskHostLifetimeMilliseconds": null
    }
  },
  "server": {
    "maxSnapshotCompileMillisecondsAt100k": null,
    "maxAnalyzerMillisecondsAt100k": null,
    "maxAnalyzerPeakMemoryBytesAt100k": null
  },
  "approvedBy": null,
  "evidenceRefs": []
}
```

A null threshold blocks production performance sign-off but does not block correctness prototypes. Once populated, CI/lab commands consume the file; prose and dashboards do not maintain separate limits.

## 9.4 Quality acceptance criteria

Before real import or rule publication:

- 100% of imported rows have an explicit action and quality disposition.
- 100% of missing/duplicate/conflicting external references remain explicit; none are fabricated or auto-merged.
- 100% of active applications have an approved canonical revision.
- 100% of publishable rules satisfy the primary gate and have at least one positive, one negative and all predicate-boundary fixtures.
- 100% of analyzer `UNKNOWN`, cross-target ambiguity and unapproved shadow findings block publication.
- 100% of published snapshots pass all fixtures using the exact release matcher build.
- 100% of tested cross-realm access/mutation attempts fail.
- 100% of forbidden canaries are absent from endpoint boundary, storage, transport and diagnostics test sinks.
- No percentage target is assigned to real unmatched/ambiguous activity until purpose-approved pilot data and governance exist. A low ambiguity rate is not proof of correctness; hidden first-match behavior would be worse.

## 9.5 Stop gates

| Gate | Go condition | Stop condition and next action |
|---|---|---|
| G-AR0 Human scope | Purpose/source/privacy ceiling for synthetic slice documented; accountable decision owners named | Missing purpose/authority: only local unit code may proceed |
| G-AR1 Import safety | FP-01/R-* pass; staging retention/field authority decided before real import | Any leak/partial apply/auto-merge: stop registry ingestion and fix |
| G-AR2 Matcher semantics | FP-02 plus URL golden/fuzz/determinism/privacy tests pass | Any ambiguous guess/normalizer drift/leak: stop endpoint integration |
| G-AR3 Conflict proof | FP-03 detects all injected conflicts and blocks unknown | Any false negative/timeout-as-pass: stop authoring publication path |
| G-AR4 Snapshot/performance | FP-05/07 meet approved thresholds on representative cohorts | Threshold miss: do not add scale claims; open format/index ADR and remeasure |
| G-AR5 Realm/security | FP-06, signer/tamper/audit/privacy tests pass | Any cross-realm/tamper/audit bypass: security stop; no pilot |
| G-AR6 Windows process | FP-04 passes supported lab matrix and process privacy approval exists | Any spoof/leak/uncontrolled common failure: keep all process families off |
| G-AR7 Operational readiness | Named runbooks, rollback/privacy/signing exercises, accessible UI and support model accepted | Missing accountable support/rollback: no real publication |
| G-AR8 First real rule | Primary publication gate satisfied for each rule and human production approval recorded | Any missing element: **STOP—no real rule is published** |


---

# 10. Human decisions and owner questions

Research cannot approve the following. The temporary defaults below are deliberately conservative and permit only synthetic implementation work unless stated otherwise.

## 10.1 Required decisions

| Decision | Options and consequences | Conservative temporary default | Accountable authority to name | Stop/go question |
|---|---|---|---|---|
| Application owners | (A) one accountable owner; simple but may not fit shared apps. (B) business + technical roles; clearer responsibilities but more maintenance. (C) owner group from CMDB/directory; scalable but depends on source quality/currentness | Owner assignment remains `PROPOSED`; no real rule publication | **HUMAN DECISION:** application governance executive/product authority | Who is accountable for confirming that a real rule maps to the intended application and purpose? |
| Field source of truth | One source for all fields is simple but often false; field-by-field authority is safer but needs governance; manual-first avoids overwrite but is costly | Every source is `PROPOSAL_ONLY`; no automatic overwrite | Application-data governance owner with integration owners | Which source may create/update canonical name, external ref, owner, lifecycle, category, sensitivity and CMDB relation, and how are conflicts resolved? |
| Approved categories | Flat list is simple; hierarchy improves navigation but complicates revision/migration; realm-specific vocabulary increases flexibility but harms comparison | No category assigned or required by matcher | Product/data governance | Which vocabulary, definitions, revision/retirement and realm rules are approved? |
| Approved sensitivity | One UAM-wide taxonomy improves consistency; realm-specific labels may reflect local policy but complicate controls | Treat all registry metadata as internal restricted; no endpoint sensitivity field | Privacy/security/data governance | What do labels mean, who may assign them, and what access/retention controls follow? |
| Rule creators/reviewers/approvers/publishers/retirers | Same-person workflow is fast but weak; two-person approval reduces error; separate signing/publishing limits compromise but adds operations | Creator cannot self-approve; signer path separate; exact role mapping unresolved | Security/platform governance | What separation of duties and emergency override applies, and how is it audited? |
| Purpose/prohibited uses | Narrow purpose limits misuse; broad purpose increases feature requests and privacy risk | Synthetic engineering/testing only | Legal/privacy/product authority | What approved purpose allows real application classification, and what uses are explicitly prohibited? |
| URL path matching | Host-only minimizes data; path adds precision but may reveal sensitive structure | Off in product ceiling and realm policy | Privacy/product release authority | Is path classification necessary, and which path forms/categories are prohibited? |
| Process matching | Signed product is stronger but costs OS calls; path rules handle unsigned software but increase spoof/privacy risk; filename is weak | All process families off; lab only | Product privacy + endpoint security | Which process families/fields are approved, on which Windows platforms and for what purpose? |
| Per-user paths | Can identify user-installed apps but exposes profile-relative structure and user-writable spoof surface | Denied | Privacy/security | Is any known-folder-relative per-user path permitted, and what minimization/anti-spoof controls apply? |
| Priority overrides | Useful for intentional exceptions; can conceal shadowing and mistakes | Priority 0 only | Rule governance | Who may approve non-zero priority, what evidence/expiry/review is required? |
| Import staging retention | Longer retention helps reconciliation; increases confidential-data exposure | No real import until period, encryption, deletion and access are approved | Records/privacy/security | How long may source/staged/corrected files and row values remain, including backups? |
| Rule/registry retention | Complete revision history improves audit/rollback; may retain confidential labels longer | Keep synthetic evidence; real retention unresolved | Records/legal/product | Which revisions/audits must be retained or deleted, and how are legal holds handled? |
| Snapshot soft/hard expiry | Longer supports outages; widens stale/revoked-rule window. Shorter improves revocation but disables offline matching sooner | No production value; test several durations | Security/operations/product | What offline continuity and revocation risk are acceptable? |
| Signing keys/algorithm | Enterprise release PKI, platform signing service or dedicated service; each affects custody/rotation/offline verification | Test-only ephemeral key; no production trust | Enterprise security/release authority | Which keys, algorithms, custody, rotation, revocation and recovery process are approved? |
| Device realm/authentication | Existing device PKI or other registration; wrong choice can break isolation | Synthetic test principal/realm only | Device identity/security architecture | What authenticated claim is the authoritative endpoint realm and how is re-registration handled? |
| Numerical budgets | Tight bounds protect endpoints but may limit rules; loose bounds increase DoS/cost | Null thresholds block production performance sign-off | Product/operations with endpoint engineering | What supported hardware cohorts and CPU/memory/disk/network/startup budgets apply? |
| Operational SLO/RPO/RTO/support | Drives staffing, alerting, restore and after-hours response | No production commitment | Service owner/business sponsor | What availability, recovery and support coverage is funded? |
| Accessibility target/acceptance | WCAG 2.2 AA is recommended; organization may have additional standards | Design/test to WCAG 2.2 AA; formal approval pending | Product/accessibility authority | Which manual assistive-technology tests and sign-off are mandatory? |
| Production approval | Requires all previous gates plus legal/security/operations acceptance | Not approved | Named production change authority | Has each gate’s evidence been accepted and every residual risk assigned? |

## 10.2 Questions for application-data governance

1. What constitutes the “same application” across rename, vendor acquisition, major version, SaaS/desktop variants, regional instances and mergers?
2. Are application identities realm-local by policy, or will a separate global reference layer be required? This result keeps endpoint IDs realm-local.
3. Which external systems guarantee key immutability and non-reuse, and what is their correction protocol?
4. How should disputed owners or source conflicts affect rule publication—block all publication, block only new revisions, or allow a time-bounded exception?
5. Does retirement mean “no longer owned,” “no longer in use,” “prohibited,” or merely “hidden”? These meanings must not be collapsed.
6. Who can approve merge/split and historical rematerialization, and how are downstream consumers notified?

## 10.3 Questions for privacy/security

1. Is exact host/suffix classification within the first Edge site/domain slice approved, and are any host categories hard-denied?
2. Are URL paths, non-default ports or internationalized hosts permitted? What must be hidden in UI/audit?
3. Which Authenticode trust action/configuration and signer identity representation are approved?
4. Can a Task Host read file version resources and final paths for the stated purpose, and on which endpoint populations?
5. What maximum offline stale interval is acceptable after a malicious rule or signer compromise?
6. Which incident cases require endpoint family disable versus full agent disable?
7. What audit data is required for approval without storing rule-observation examples from production?

## 10.4 Questions for operations/support

1. Who owns publisher certificate rollover monitoring and how much lead time is available?
2. Which endpoint cohorts represent the lowest supported resource envelope?
3. How are endpoints restored/reimaged without losing the secure highest-accepted snapshot sequence?
4. Which artifact/signing/database restore drills are required before a pilot?
5. How does support reproduce failures without receiving raw URL/path/catalogue values?
6. What is the escalation path when soft expiry, hard expiry, ambiguity or metadata-unavailable rates rise?

---

# 11. CLI experiments/measurements and exact evidence

## 11.1 Reproducibility and evidence conventions

Every CLI experiment writes to a new `artifacts/application-registry-matching/<run-id>/` directory and records:

```text
run.json                  command, UTC start/end, exit code, random seed
source.json               git commit, dirty state, submodule/lockfile hashes
runtime.json              dotnet --info, OS/build/architecture, CPU/RAM class
inputs-manifest.json      fictional input paths, SHA-256, generator parameters
thresholds.json           exact reviewed thresholds consumed, including nulls
results.json              machine-readable findings/measurements
summary.md                human-readable conclusion with evidence labels
stdout.log / stderr.log   sanitized and scanned for forbidden canaries
sha256sums.txt             hashes of all retained evidence
cleanup.json              cleanup actions and verification
```

Commands below use repository-relative placeholders and no network, credential, host, address or SSH value. A future lab runner supplies connection details outside evidence and redacts them before attachment.

Before each run:

```bash
dotnet --info > "$RUN/runtime-dotnet.txt"
git rev-parse HEAD > "$RUN/git-commit.txt"
git status --porcelain=v1 > "$RUN/git-status.txt"
sha256sum contracts/**/*.json fixtures/**/* 2>/dev/null > "$RUN/input-sha256.txt"
```

A dirty source tree is allowed for development but marks evidence `NON-REPRODUCIBLE` and cannot pass a formal gate.

## 11.2 CE-01 — Build and run the sanitized import validator

### Command

```bash
dotnet run --configuration Release \
  --project tools/Uam.Registry.ImportValidator \
  -- validate \
  --input fixtures/application-catalogue/fictional-shape-173.csv \
  --schema contracts/application-catalogue-csv-v1.schema.json \
  --source-contract fixtures/application-catalogue/source-contract-proposal-only.json \
  --expected-shape fixtures/application-catalogue/fictional-shape-173.manifest.json \
  --max-input-bytes-from thresholds.json \
  --report "$RUN/import-report.json"
```

### Required evidence

- input SHA-256 and generator seed;
- parser/schema/runtime versions;
- exact row/code counts, including 173 rows, five missing keys, one address-like warning, ten non-ASCII informational findings and nine truncation blockers in the fictional fixture;
- proof no raw row values appear in report/logs;
- deterministic report hash across two clean runs;
- peak memory/elapsed/input-byte measurements;
- exit codes: `0` clean/pass, `2` quality blockers found as expected, `3` structural reject, `4` unsafe/internal error. The harness, not a human, maps expected blocker exit `2` to a successful test case.

### Pass/fail

Pass only when counts match the manifest, all blockers are represented by row number + HMAC fingerprint, no name-based identity/rule action occurs, and malformed/oversized inputs fail before partial apply.

### Cleanup

```bash
dotnet run --project tools/Uam.TestData.Cleanup -- \
  --run "$RUN" --delete-staged-plaintext --verify
```

## 11.3 CE-02 — Generate fictional rules, conflicts and shadows

### Command

```bash
dotnet run --configuration Release \
  --project tools/Uam.RuleFixtureGenerator \
  -- \
  --seed 404 \
  --applications 200 \
  --url-rules 10000 \
  --process-rules 10000 \
  --inject-cross-target-ambiguities 200 \
  --inject-full-shadows 200 \
  --inject-partial-shadows 200 \
  --inject-same-target-redundancies 200 \
  --reserved-domain-suffix example.test \
  --out "$RUN/generated"


dotnet run --configuration Release \
  --project tools/Uam.RuleAnalyzer \
  -- analyze \
  --rules "$RUN/generated/rules.json" \
  --truth "$RUN/generated/truth.json" \
  --matcher-contract matcher-v1 \
  --report "$RUN/conflict-report.json"
```

### Required evidence

- generator seed, parameters and truth-manifest hash;
- count by expected/actual analysis class;
- recall for every injected blocking conflict (must be all, not a sampled percentage);
- every witness replayed by the release matcher and its outcome hash;
- comparison count, CPU, wall time, peak memory and any timeout/unknown;
- order-permutation report;
- minimized counterexample for every mismatch.

### Pass/fail

Any missed injected ambiguity/shadow, invalid witness, nondeterministic report, or timeout treated as safe is a hard fail for G-AR3.

## 11.4 CE-03 — Matcher conformance and privacy boundary

### Commands

```bash
dotnet test tests/Uam.Matcher.Conformance \
  --configuration Release \
  --logger "trx;LogFileName=$RUN/matcher-conformance.trx" \
  --results-directory "$RUN"


dotnet test tests/Uam.Matcher.PropertyTests \
  --configuration Release \
  --logger "trx;LogFileName=$RUN/matcher-properties.trx" \
  --results-directory "$RUN"


dotnet run --configuration Release \
  --project tools/Uam.ContractCanaryScanner \
  -- scan \
  --inputs "$RUN" \
  --canary-manifest fixtures/privacy/canaries.json \
  --forbid-schema-fields contracts/privacy/endpoint-forbidden-fields.json \
  --report "$RUN/privacy-scan.json"
```

### Required evidence

- `url-v1` and `process-v1` golden corpus hashes;
- culture/order/concurrency permutation results;
- endpoint/server simulator parity;
- IPC/snapshot/log/metric schema scan with zero forbidden findings;
- runtime/dependency lockfile hashes;
- all failing seeds minimized and retained as fictional regressions.

### Pass/fail

All conformance vectors and properties pass. `AMBIGUOUS` never has an application; canary scan has zero findings; every error remains bounded/deterministic.

## 11.5 CE-04 — Build and verify a signed fictional realm snapshot

### Commands

```bash
dotnet run --configuration Release \
  --project tools/Uam.SnapshotCompiler \
  -- build \
  --realm 00000000-0000-7000-8000-000000000001 \
  --rules "$RUN/generated/rules.json" \
  --applications "$RUN/generated/applications.json" \
  --privacy-ceiling fixtures/snapshots/privacy-ceiling-test-v1.json \
  --matcher-contract matcher-v1 \
  --thresholds thresholds.json \
  --out "$RUN/snapshot"


dotnet run --configuration Release \
  --project tools/Uam.TestSnapshotSigner \
  -- sign \
  --manifest "$RUN/snapshot/manifest-unsigned.json" \
  --payload "$RUN/snapshot/payload.json.gz" \
  --ephemeral-key \
  --out "$RUN/snapshot/signed"


dotnet run --configuration Release \
  --project tools/Uam.SnapshotVerifier \
  -- verify \
  --expected-realm 00000000-0000-7000-8000-000000000001 \
  --trust "$RUN/snapshot/signed/test-trust.json" \
  --snapshot "$RUN/snapshot/signed" \
  --report "$RUN/snapshot-verify.json"
```

### Required evidence

- canonical manifest/payload hashes from two clean builds;
- rule/test/analysis/approval gate report;
- signed domain/audience/sequence/ceiling fields;
- compressed/uncompressed byte counts and ratio;
- mutation/wrong-realm/replay/decompression-negative corpus results;
- ephemeral test key destruction evidence.

### Pass/fail

Only the exact valid artifact verifies. Every mutated, wrong-realm, stale/lower-sequence, unsupported or over-bound artifact fails before activation. The test signer can never be trusted by a production build.

## 11.6 CE-05 — Benchmark snapshot and matching performance

### Command

```bash
dotnet run --configuration Release \
  --project tools/Uam.MatcherBench \
  -- \
  --rule-counts 1000,10000,100000 \
  --url-positive-ratio 0.25 \
  --url-ambiguous-ratio 0.01 \
  --process-rule-mix signed:40,pathExact:30,pathPrefix:30 \
  --iterations-from thresholds.json \
  --snapshots "$RUN/bench-snapshots" \
  --thresholds thresholds.json \
  --export-json "$RUN/benchmark.json" \
  --export-csv "$RUN/benchmark.csv"
```

For endpoint activation on Windows:

```powershell
$Run = '<sanitized-local-run-directory>'
dotnet .\tools\Uam.EndpointSnapshotBench.dll `
  --snapshot "$Run\snapshot\signed" `
  --sqlite "$Run\endpoint-state.db" `
  --fault-matrix all `
  --thresholds .\thresholds.json `
  --report "$Run\endpoint-benchmark.json"
```

### Required evidence

- machine/OS/runtime/power-mode manifest;
- compile/analyze/compress/download-simulate/verify/decompress/index/activate times;
- p50/p95/p99/max matcher latency and allocations by family/outcome/size;
- peak RSS, GC, handle count, disk bytes and local SQLite transaction time;
- cold and warm runs, fixture seed, threshold file hash;
- correctness hash before/after load;
- crash-point invariant report.

### Pass/fail

The command cannot claim pass while thresholds are null. Once approved values exist, every supported cohort must pass. A miss opens an optimization/format ADR; it does not justify silently raising the threshold.

## 11.7 CE-06 — Windows process metadata lab

No connection details are recorded. Run locally on the approved lab VM or through an approved wrapper that supplies connection material outside the command transcript.

```powershell
$Run = '<sanitized-local-run-directory>'
dotnet .\tools\Uam.ProcessFixtureBuilder.dll `
  --fictional-publisher `
  --install-root "$env:ProgramFiles\UamFictionalFixtures" `
  --out "$Run\process-fixture-manifest.json"


dotnet .\tools\Uam.ProcessMatcherLab.dll `
  --manifest "$Run\process-fixture-manifest.json" `
  --cases .\fixtures\process\process-v1-cases.json `
  --restricted-task-host `
  --ipc-capture "$Run\ipc.bin" `
  --report "$Run\process-results.json"


dotnet .\tools\Uam.ContractCanaryScanner.dll scan `
  --inputs "$Run\ipc.bin","$Run\logs" `
  --canary-manifest .\fixtures\privacy\process-canaries.json `
  --report "$Run\process-privacy-scan.json"
```

### Required evidence

- sanitized OS/runtime/filesystem capability manifest;
- fictional binary/test-cert SHA-256 only;
- result for P-01..P-16, OS error-code mapping, handle/CPU/time counts;
- file-ID before/after race evidence;
- zero raw path/signer/product canaries across IPC/logs;
- cleanup proof that test certificates/binaries/directories were removed.

### Pass/fail

Any spoof match, implicit weaker fallback, privilege escalation, raw metadata leak, handle leak, uncontrolled parser crash or unsupported common platform behavior blocks G-AR6.

## 11.8 CE-07 — Realm and publication adversarial experiment

```bash
dotnet test tests/Uam.RealmIsolation.Adversarial \
  --configuration Release \
  --settings tests/Uam.RealmIsolation.Adversarial/runsettings.test.json \
  --logger "trx;LogFileName=$RUN/realm-adversarial.trx" \
  --results-directory "$RUN"


dotnet run --configuration Release \
  --project tools/Uam.PublicationFaultMatrix \
  -- \
  --realm-a 00000000-0000-7000-8000-000000000001 \
  --realm-b 00000000-0000-7000-8000-000000000002 \
  --duplicate-object-ids \
  --failpoints all \
  --report "$RUN/publication-faults.json"
```

Required evidence is the complete attack/failpoint matrix, SQL/cache/signer/audit invariant report, absence of cross-realm output, and proof that no failed transaction leaves a current unsigned snapshot or reusable sequence.

## 11.9 Evidence acceptance

A gate reviewer accepts an experiment only when:

- commands and source/runtime/input/threshold hashes are present;
- outputs are machine-readable and retained under the approved evidence policy;
- raw logs pass the forbidden-data scanner;
- failures and excluded environments are reported, not discarded;
- cleanup is verified;
- the conclusion is limited to the tested version, input shape and environment;
- owner and review date are recorded.

---

# 12. ADR proposals

All ADRs are **Proposed**, not accepted. “Owner” is a functional placeholder pending human assignment.

| ADR | Decision | Status | Alternatives | Rationale/evidence | Functional owner | Review trigger |
|---|---|---|---|---|---|---|
| ADR-AR-001 | Use realm-scoped UAM UUIDv7 as permanent application identity; never derive/reuse | Proposed | External key; name/hash; UUIDv4 | Missing external IDs and no uniqueness contract; opaque standard ID; merge/split lineage [S-INT-02] [S-WEB-07] | Registry owner | UUIDv7 implementation/lifecycle issue; global identity requirement; measured index problem |
| ADR-AR-002 | Store immutable application revisions, aliases, external refs and governance links with provenance | Proposed | Mutable row; event store only; CMDB passthrough | Audit/reconciliation/rollback and multi-source conflicts require explicit history | Registry owner | Revision cost fails benchmark; approved source authority changes model |
| ADR-AR-003 | Treat names/aliases/external keys as non-authoritative and prohibit name-derived real rules | Proposed | Auto-link by exact/fuzzy name; external ID as master | Catalogue supplies no rule/owner semantics; Unicode/truncation/missing-key evidence [S-INT-02] | Registry + rule governance | No ordinary reopening for name-derived rules; external authority contract may change link workflow only |
| ADR-AR-004 | Use a closed typed URL/process rule grammar; no regex/scripts/general policy language | Proposed | OPA/Cedar; regex/globs; ordered expressions | Bounded evaluation, exact conflict proof, endpoint attack-surface minimization | Endpoint + rule governance | A required approved use case cannot be represented and a safer extension prototype passes |
| ADR-AR-005 | Deterministic precedence is priority, fixed family authority, then partial-order specificity; cross-target ties are ambiguous | Proposed | First match; newest; rule ID; score/fuzzy | Exposes conflict and is independent of order; supports exact audit/rollback | Rule governance | Formal counterexample shows relation inconsistent or unusable; requires migration plan |
| ADR-AR-006 | Reuse one pure C# matcher/normalizer core in endpoint and central simulator/analyzer witness checks | Proposed | Separate implementations; remote-only matching | Prevents semantic drift and preserves offline/local minimization | Endpoint owner | Runtime/platform constraint prevents reuse; parity corpus proves alternative equivalent |
| ADR-AR-007 | Match URL in User Host and process metadata in restricted Task Host before Coordinator IPC | Proposed, aligned baseline | Coordinator/central matching | User/session privacy boundary and risky-parser containment [S-INT-01] | Endpoint owner | Baseline change proposal with new primary evidence and privacy experiment |
| ADR-AR-008 | Publish full, immutable, signed per-realm snapshots first; monotonic higher-sequence rollback and LKG | Proposed | Deltas; mutable config DB; online evaluation | Simpler integrity/recovery/offline semantics; size unknown but measurable | Release + endpoint | G-AR4 fails approved budgets; delta/binary prototype proves safer fit |
| ADR-AR-009 | Exclude central labels/owners/taxonomy/external/CMDB metadata from endpoint snapshots | Proposed | Rich endpoint registry | Data minimization and lower breach/config size | Privacy + endpoint | A new endpoint feature proves necessity under ceiling and schema privacy tests |
| ADR-AR-010 | Do not use Public Suffix List in matcher v1 | Proposed | eTLD+1/registrable domain matching | Explicit host/suffix semantics suffice; avoids mutable data and organizational-boundary ambiguity [S-WEB-24] | Rule governance | Approved registrable-domain use case and pinned-data ADR |
| ADR-AR-011 | Build an exact custom overlap/shadow analyzer for the restricted grammar; do not depend on SMT initially | Proposed | Z3; brute-force samples; no analyzer | Finite predicates support direct proofs/witnesses; avoids solver/runtime uncertainty | Rule governance | Direct analyzer becomes incomplete/unmaintainable; solver prototype proves sound, licensed and bounded |
| ADR-AR-012 | Import is staged, strict, idempotent and atomic; it never creates/publishes rules | Proposed | Direct upsert; spreadsheet/manual edit; automatic rule generation | Quality shape and source uncertainty require review; separates data import from policy | Registry owner | Approved source contract and volume justify automation while preserving same gates |
| ADR-AR-013 | Use bounded telemetry dimensions and audited object lookup, never IDs/raw values as metric labels | Proposed | Per-app/realm/device metrics | Privacy and cardinality containment [S-WEB-28] | Platform + security | Observability requirement cannot be met through audited queries/aggregates; privacy review required |
| ADR-AR-014 | Product-ceiling intersection plus safer-default feature flags/kill switches; no external flag service dependency initially | Proposed | Hard-coded only; SaaS flag provider | Fast containment while tenant can only narrow; fewer external dependencies | Release + endpoint | Enterprise standard mandates provider and availability/security tests pass |

Every accepted ADR must link exact CLI evidence, source register rows, migration effect and named approver. A review trigger creates a change proposal; it does not silently amend the contract.

---

# 13. Ordered implementation backlog with dependencies and stop gates

## 13.1 Backlog

| Order | Work item and deliverables | Dependencies | Stop gate / done evidence |
|---:|---|---|---|
| 1 | **Create contract/evidence skeleton.** Add evidence labels, ADR templates, source register, JSON Schema 2020-12 validation, fixture-data policy, forbidden-canary scanner and `thresholds.json` with nulls | None | CI proves only allowlisted/synthetic fixtures; no production values |
| 2 | **Implement realm context and schema constraints.** Composite keys/FKs, scoped repositories/cache keys, two-realm adversarial harness | 1 | G-AR5 subset: R-02/FP-06 pass before feature CRUD |
| 3 | **Implement UUIDv7/application core.** Application lifecycle, immutable revisions, merge/tombstone/cycle checks, audit-coupled transactions | 2 | R-01, audit failure and ID conformance pass |
| 4 | **Implement alias/search quality library.** NFC preservation, versioned search key, UTS #39 warnings, escaped accessible display | 3 | R-05/UI-02 pass; no automatic identity decisions |
| 5 | **Implement source/external/owner/taxonomy/CMDB models.** Provenance and proposal/conflict states; no automatic authority | 3 | Field-authority tests pass; real source remains proposal-only until human decision |
| 6 | **Build sanitized import validator CLI.** Strict CSV/bounds/formula-safe export/quality codes/deterministic report | 1, 4, 5 | **G-AR1:** FP-01/R-03..07 pass before any real import |
| 7 | **Implement import staging/review/apply.** Restricted staging, row HMAC, explicit mapping, hash-bound approval, atomic idempotent apply | 6, 3 | Crash/concurrency/audit tests pass; import creates zero rules |
| 8 | **Freeze matcher contracts v1.** URL/process schemas, outcome/error enums, precedence/specification, golden fixture format | 1 | ADR-AR-004/005 proposed and reviewed; schema lints pass |
| 9 | **Implement pure URL normalizer/matcher.** WHATWG/UTS #46 contract, exact/suffix/scheme/port, path code behind disabled ceiling | 8 | **G-AR2:** FP-02/U-*/PRIV tests pass |
| 10 | **Implement rule fixture generator and exact analyzer.** Overlap/dominance/witness/shadow/unknown-block semantics | 8, 9 | **G-AR3:** FP-03/A-* pass; no false negatives in injected truth corpus |
| 11 | **Implement rule authoring/revision lifecycle.** Owner/purpose/tests/dates/priority override/rollback/hash binding; accessible diff/UI | 3, 8, 10 | RL-01/02, UI-* and primary gate property tests pass |
| 12 | **Implement simulator/impact package.** Exact shared matcher, canonical explanations, fictional-only fixture intake, before/after timeline | 9, 10, 11 | A-04 parity and synthetic-data guard pass |
| 13 | **Implement publisher profiles.** Immutable signer identities/rollover/effective windows, central UI, no endpoint display names | 3, 8 | P-03 contract tests; human process authority still blocks production |
| 14 | **Implement Windows process adapter in restricted Task Host.** Minimal APIs, path tokens, file-ID race checks, trust/version wrappers, buffer clearing | 13, broader endpoint host gate | **G-AR6:** FP-04/P-*/FZ-02/privacy pass; otherwise families remain off |
| 15 | **Implement snapshot compiler.** Product-ceiling intersection, complete analysis, canonical minimal payload, deterministic hashes, size report | 10–13 | Compiler reproducibility/privacy scan pass; no signer yet |
| 16 | **Implement signing/publication protocol.** Gate record, per-realm monotonic sequence, audit, immutable artifact, signer separation | 15, enterprise signing design | S-01..03/09/SEC-01; test key cannot reach production trust |
| 17 | **Implement Coordinator verifier/activation.** Bounded stream, signature/hash/realm/sequence/time/compatibility, SQLite LKG/previous/crash state | 16, accepted Coordinator persistence | FP-05/S-01..10 pass |
| 18 | **Integrate URL matcher into User Host.** Raw URL stays in session; minimized result contract to Coordinator | 9, 17, broader browser-source gate | Privacy canaries and first synthetic Edge slice pass; path flag off |
| 19 | **Integrate process matcher into Task Host.** Only after process human approval and G-AR6 | 14, 17 | No raw process metadata across IPC; kill switch tested |
| 20 | **Add observability/error/runbooks.** Bounded metrics, no free-form input logs, dashboards by enums/cohort, import/rule/signer/privacy/rollback runbooks | 6–19 | OBS-*/SUP/IR exercises pass; accountable owners named |
| 21 | **Run full performance/size suite.** 1k/10k/100k compile/analyze/match/activate on representative cohorts | 10, 15–19, approved thresholds | **G-AR4:** all cohorts pass or stop and open optimization/format ADR |
| 22 | **Perform accessibility/security/dependency review.** WCAG manual tests, threat review, fuzz corpus, SBOM/license, supported .NET/Windows lifecycle | All implemented surfaces | G-AR5/7; no unresolved blocking finding |
| 23 | **Prepare migration rehearsal.** Import only sanitized/approved export, assign UAM IDs, compare legacy external refs without copying rules, publish no real rule | G-AR1–7, human source/owner decisions | Reconciliation report accepted; primary gate remains closed |
| 24 | **First real rule approval/publication.** One realm, URL host-only, owner/purpose/fixtures/conflict/approval/rollback, canary and incident readiness | G-AR0–7 + production authority | **G-AR8:** any missing element is a stop |
| 25 | **Post-pilot review.** Evaluate bounded outcomes, support cost, owner coverage, snapshot budgets and false attribution reports; no productivity scoring | Approved pilot evidence | Decide continue/change/stop through ADR; process/path remain separately gated |

## 13.2 Dependency and stop logic

- Items 14 and 19 do not block the first URL-host slice; process matching remains off.
- Item 7 may proceed with fictional/sanitized fixtures while field authority is unresolved, but no real batch may move to `APPROVED`.
- Item 11 can implement generic approval hooks without inventing role names; production authorization remains blocked until section 10 decisions.
- A failed realm/privacy/signature/audit gate stops all publication work, even if performance passes.
- A performance failure does not permit removal of safety checks. It opens indexing/format/sizing work and repeats the same correctness/security matrix.

## 13.3 Cost, licensing, skills and operational impact

**RECOMMENDATION:** Prefer the in-house closed matcher because its code and operational surface are small relative to embedding a general policy engine. This does not mean “free.” The dominant cost is expected to be governance and verification, not per-match compute.

| Area | Expected work/cost driver | Control/decision |
|---|---|---|
| Engineering | C# matcher/normalizer, exact analyzer, schemas, Windows native wrappers, snapshot verifier/activation, fuzz/property tests | Fund as foundation; do not compress by adopting unreviewed general engine |
| Governance | Application ownership, source contracts, rule purpose, reviews, publisher rollover and disputes | **HUMAN DECISION:** staffing and service model; likely ongoing largest manual cost |
| Operations | Signing/artifact/audit availability, expiry/rollback, endpoint compatibility, disk/backpressure, restore drills | SLO/RPO/RTO and after-hours coverage unresolved |
| Security/privacy | Threat reviews, key custody, incident response, diagnostic deletion, dependency patching | Named owners and exercises required before pilot |
| Accessibility | Design/review/manual assistive-technology testing | WCAG 2.2 AA recommended; authority must accept target |
| Licensing | .NET/platform APIs under existing product terms; any new package/reused source needs legal/SBOM review | OPA/Cedar/Backstage/Envoy Apache-2.0, Z3 MIT, osquery dual license and uBlock GPL-3.0 have different obligations; reference does not authorize copying |
| Skills | C#/.NET, relational schema/migrations, Windows Authenticode/file APIs, Unicode/IDNA/URL parsing, formal set/interval reasoning, fuzz/property testing, release signing, accessibility | Training/coverage is a production-readiness decision |
| Data operations | Staging access, conflict review, source reconciliation, deletion and audit | No real import until authority/retention established |
| Future scale | Rule count, snapshot bytes and update cadence unknown | Measure before trie/delta/broker/microservice decisions |

No budget or staffing number is asserted. The architecture deliberately avoids a new runtime language, endpoint sidecar, policy service, broker, SaaS flag control plane and PSL update pipeline until evidence demands one.


---

# 14. Open-source repository assessment table

## 14.1 Review conclusion and method

**RECOMMENDATION:** None of the reviewed repositories should be an endpoint runtime dependency for the first UAM slice. They are useful as design references for immutable policy bundles, schema validation, catalogue provenance, route-predicate testing, Windows metadata handling, high-volume URL indexing, and optional formal analysis. The proposed UAM matcher remains a small C# library with a closed rule grammar because UAM performs deterministic application attribution inside a privacy boundary, not general authorization, network routing, browser blocking, or arbitrary query evaluation.

The review used the exact release tags listed below, not a moving default branch. Release and licence pages were checked on 31 July 2026. Repository activity proves that work occurred; it does not prove UAM fitness. This was a source/design review, not a clone/build/fuzz campaign or a security audit. Any later dependency or source-code reuse requires a fresh SBOM, transitive dependency, licence, vulnerability, support-lifecycle, reproducible-build, and threat-model review at the selected commit.

| Ref | Repository, exact revision and reviewed files/directories | Licence, maintenance, testing and security posture | Architectural similarity and threat-model difference | Ideas worth reusing; ideas/code not to copy | Suitability |
|---|---|---|---|---|---|
| S-OSS-01 | **Open Policy Agent (OPA)** — [repository](https://github.com/open-policy-agent/opa); release [`v1.19.0`](https://github.com/open-policy-agent/opa/releases/tag/v1.19.0), released 30 July 2026, release commit `1e32c79` (verified signature; release marked immutable). Reviewed [`v1/ast`](https://github.com/open-policy-agent/opa/tree/v1.19.0/v1/ast), [`v1/topdown`](https://github.com/open-policy-agent/opa/tree/v1.19.0/v1/topdown), [`v1/bundle`](https://github.com/open-policy-agent/opa/tree/v1.19.0/v1/bundle), [`v1/tester`](https://github.com/open-policy-agent/opa/tree/v1.19.0/v1/tester), and [`cmd/opa`](https://github.com/open-policy-agent/opa/tree/v1.19.0/cmd/opa). | [Apache-2.0](https://github.com/open-policy-agent/opa/blob/v1.19.0/LICENSE), generally compatible with proprietary use subject to notices and legal review. Active release immediately before the research date. The repository has broad unit/integration tooling. The reviewed release fixed an SQL-injection vector in the Compile API and tightened language safety, which is positive maintenance evidence and also evidence that general compilation/evaluation surfaces create security risk. No UAM-specific build or penetration test was performed. | Similar: validates policy, compiles/distributes bundles, evaluates offline, supports tests and explanations. Different: OPA is a general data/policy language and often makes authorization decisions; UAM needs a finite attribution grammar on hostile endpoint inputs, must not execute tenant-authored logic, and must prevent raw values crossing a session boundary. | Reuse concepts: immutable content-addressed bundles, manifest/version validation, deterministic diagnostics, fixture-driven tests, and explicit unknown/error results. Do **not** embed Rego, expose arbitrary built-ins, add dynamic data documents, use the SQL Compile API, or adopt an endpoint policy server. | **Reference only.** Reconsider only if an approved requirement cannot fit the closed grammar and a sandboxed dependency prototype beats the custom matcher on attack surface, deterministic conflict proof, size, latency, lifecycle, and licence/operations gates. |
| S-OSS-02 | **Cedar** — [repository](https://github.com/cedar-policy/cedar); release [`v4.12.0`](https://github.com/cedar-policy/cedar/releases/tag/v4.12.0), released 28 July 2026, release commit `fdcbaed` (verified signature). Reviewed [`cedar-policy`](https://github.com/cedar-policy/cedar/tree/v4.12.0/cedar-policy), [`cedar-policy-validator`](https://github.com/cedar-policy/cedar/tree/v4.12.0/cedar-policy-validator), [`cedar-policy-symcc`](https://github.com/cedar-policy/cedar/tree/v4.12.0/cedar-policy-symcc), [`cedar-policy-cli`](https://github.com/cedar-policy/cedar/tree/v4.12.0/cedar-policy-cli), and [`cedar-policy-tests`](https://github.com/cedar-policy/cedar/tree/v4.12.0/cedar-policy-tests). | [Apache-2.0](https://github.com/cedar-policy/cedar/blob/v4.12.0/LICENSE), subject to normal notice/legal review. Active release three days before the research date. Dedicated parser, validator, symbolic checker, CLI and test packages are visible. The release added malformed-input checks, duplicate-ID checks, structural validation and nesting-depth bounds; these are relevant secure-parser practices. Experimental features and unchecked decode paths must not be treated as production assurances. | Similar: typed schema, stable policy IDs, validation diagnostics, policy-set analysis and symbolic reasoning. Different: Cedar is an authorization language over principals/actions/resources; UAM classifies URL/process evidence, needs partial-order specificity and `AMBIGUOUS`, and cannot give tenant authors a general expression language on endpoints. | Reuse concepts: schema-first validation, distinct syntax/semantic errors, stable rule IDs, bounded decode depth, duplicate rejection, and symbolic analysis as a test oracle. Do **not** copy the authorization model, expression language, Rust runtime, unchecked decoders, or permit/forbid combining semantics. | **Reference only.** Useful for analyzer/test design; not justified as a dependency for the first slice. |
| S-OSS-03 | **Backstage** — [repository](https://github.com/backstage/backstage); release [`v1.53.1`](https://github.com/backstage/backstage/releases/tag/v1.53.1), released 29 July 2026, release commit `eb8e4c0` (verified signature). Reviewed [`packages/catalog-model`](https://github.com/backstage/backstage/tree/v1.53.1/packages/catalog-model), [`packages/catalog-client`](https://github.com/backstage/backstage/tree/v1.53.1/packages/catalog-client), [`plugins/catalog-backend`](https://github.com/backstage/backstage/tree/v1.53.1/plugins/catalog-backend), and [software-catalog documentation](https://github.com/backstage/backstage/tree/v1.53.1/docs/features/software-catalog). | [Apache-2.0](https://github.com/backstage/backstage/blob/v1.53.1/LICENSE), subject to notices/legal review. Large, actively released Node/TypeScript monorepo with package tests and CI; the selected patch was released two days before research. Its breadth and plugin ecosystem materially enlarge dependency and patching scope. Review did not establish a UAM security boundary or operational fit. | Similar: registry entities, references, relations, provenance/ingestion, lifecycle metadata and catalogue APIs. Different: Backstage is a human-facing software catalogue and integration platform, commonly treats human-readable entity references as important identifiers, and is not an offline endpoint matching system or a realm-isolated telemetry privacy boundary. | Reuse concepts: separate canonical identity from source annotations, record provenance, validate references, model relations explicitly, and surface reconciliation errors. Do **not** import the platform/plugin architecture, Kubernetes-style mutable name identity, ingestion processors, Node runtime, or broad integration permissions. | **Reference only.** Registry design inspiration; neither dependency nor deployment component. |
| S-OSS-04 | **Envoy** — [repository](https://github.com/envoyproxy/envoy); release [`v1.39.0`](https://github.com/envoyproxy/envoy/releases/tag/v1.39.0), released 14 July 2026, release commit `8eea328` (verified signature). Reviewed [`api/envoy/config/route/v3/route_components.proto`](https://github.com/envoyproxy/envoy/blob/v1.39.0/api/envoy/config/route/v3/route_components.proto), [`source/common/router/config_impl.cc`](https://github.com/envoyproxy/envoy/blob/v1.39.0/source/common/router/config_impl.cc), and [`test/common/router`](https://github.com/envoyproxy/envoy/tree/v1.39.0/test/common/router). | [Apache-2.0](https://github.com/envoyproxy/envoy/blob/v1.39.0/LICENSE), subject to notices/legal review. Mature CI/test tree and active security maintenance. The selected release included multiple CVE fixes and added/broadened parser and resource bounds, illustrating both strong response and the cost of a very expressive network parser. No UAM-specific code audit occurred. | Similar: compiles declarative predicates, validates configuration, indexes/evaluates host/path conditions, and relies on extensive route tests. Different: Envoy is a network proxy where ordered/first matching can be intentional and raw request data is already in the proxy boundary; UAM must expose cross-application ties as ambiguity and must not move raw URLs into the Coordinator. | Reuse concepts: typed predicate fields, explicit one-of constraints, configuration validation, bounded parsers, golden route matrices and compiled indexes. Do **not** copy first-match ordering, route scoring, dynamic extension modules, C++ runtime, or network-proxy control-plane assumptions. | **Reference only.** Particularly useful for URL fixture/index ideas; not a matcher dependency. |
| S-OSS-05 | **osquery** — [repository](https://github.com/osquery/osquery); release [`5.23.1`](https://github.com/osquery/osquery/releases/tag/5.23.1), released 24 June 2026, release commit `b753833`. Reviewed [`osquery/tables/system/windows/processes.cpp`](https://github.com/osquery/osquery/blob/5.23.1/osquery/tables/system/windows/processes.cpp), [`osquery/tables/system/windows/authenticode.cpp`](https://github.com/osquery/osquery/blob/5.23.1/osquery/tables/system/windows/authenticode.cpp), [`specs/windows/processes.table`](https://github.com/osquery/osquery/blob/5.23.1/specs/windows/processes.table), [`specs/windows/authenticode.table`](https://github.com/osquery/osquery/blob/5.23.1/specs/windows/authenticode.table), and related Windows tests. | Repository licence is [`Apache-2.0 OR GPL-2.0-only`](https://github.com/osquery/osquery/blob/5.23.1/LICENSE); a legal choice and notices are still required before reuse. Active maintenance, but the selected bug/security release fixed heap-buffer overflows in the Windows `processes` and `authenticode` tables. This is valuable evidence that Windows metadata acquisition and native parsing are risky even in mature projects. Broad SQL/table/plugin capabilities increase attack and privacy surface. | Similar: collects typed Windows process path, version and Authenticode metadata under imperfect access. Different: osquery is a general query/telemetry agent and can expose command lines, processes and many system tables; UAM permits only approved fields, does local attribution/minimization, and uses short-lived restricted Task Hosts for risky collection. | Reuse concepts: typed field contracts, per-field unavailability, native API wrappers, security-fix discipline and Windows-specific tests. Do **not** embed osquery, expose SQL, copy broad tables/command-line collection, or assume its process identity semantics satisfy UAM TOCTOU and privacy requirements. Copying source requires separate provenance/licence review even under the permissive option. | **Reference only.** Strong threat-model input; not a dependency. |
| S-OSS-06 | **uBlock Origin** — [repository](https://github.com/gorhill/uBlock); release [`1.72.2`](https://github.com/gorhill/uBlock/releases/tag/1.72.2), released 8 July 2026, release commit `3d370ea` (verified signature). Reviewed [`src/js/static-net-filtering.js`](https://github.com/gorhill/uBlock/blob/1.72.2/src/js/static-net-filtering.js), [`src/js/static-filtering-parser.js`](https://github.com/gorhill/uBlock/blob/1.72.2/src/js/static-filtering-parser.js), and [`platform/nodejs/test`](https://github.com/gorhill/uBlock/tree/1.72.2/platform/nodejs/test). | [GPL-3.0](https://github.com/gorhill/uBlock/blob/1.72.2/LICENSE.txt), a copyleft compatibility concern for source reuse in a differently licensed product. Active release and dedicated parser/matcher tests are present, but the rule language is large and browser-specific. This review was not a security audit. | Similar: compiles and indexes many URL/network filter predicates and tests edge cases. Different: browser content blocking accepts a highly expressive filter syntax, dynamic lists and different false-positive trade-offs; UAM attributes to governed applications, must preserve audit provenance, and must make cross-target ties explicit rather than apply filter ordering. | Reuse only high-level ideas: suffix/index partitioning, generated high-volume fixtures and parser differential tests. Do **not** copy code, grammar, token syntax, list-update model, precedence, cosmetic filtering or browser extension architecture. | **Reference only; no code reuse proposed.** GPL and threat-model mismatch make it unsuitable as a dependency. |
| S-OSS-07 | **Z3** — [repository](https://github.com/Z3Prover/z3); release [`z3-5.0.0`](https://github.com/Z3Prover/z3/releases/tag/z3-5.0.0), released 17 July 2026, release commit `8e3402b` (verified signature). Reviewed [`src`](https://github.com/Z3Prover/z3/tree/z3-5.0.0/src), [`.NET API`](https://github.com/Z3Prover/z3/tree/z3-5.0.0/src/api/dotnet), [`.NET examples`](https://github.com/Z3Prover/z3/tree/z3-5.0.0/examples/dotnet), [`scripts`](https://github.com/Z3Prover/z3/tree/z3-5.0.0/scripts), and [`RELEASE_NOTES.md`](https://github.com/Z3Prover/z3/blob/z3-5.0.0/RELEASE_NOTES.md). | [MIT](https://github.com/Z3Prover/z3/blob/z3-5.0.0/LICENSE.txt), permissive subject to notice/legal review. Active major release with CI/build/security-hardening work, but an SMT solver is intrinsically complex and can return `unknown`, consume unbounded-looking resources without limits, or be affected by theory-specific soundness/performance defects. No UAM formula audit or benchmark was performed. | Similar: can seek witnesses for overlap, implication and satisfiability. Different: UAM v1 predicates are intentionally finite/structured and admit direct algorithms; publication cannot rely on solver heuristics, timeout or `unknown` being interpreted as safe. | Reuse as an **offline test oracle/prototyping aid** only: cross-check generated overlap cases against a separately implemented exact analyzer. Do **not** put Z3 on endpoints, make publication availability depend on it, encode unconstrained strings casually, or accept timeout/`unknown` as “no conflict.” | **Reference only initially.** Consider a build-time analyzer dependency only after a bounded formula model, deterministic resource limits, licence/SBOM review, direct-algorithm parity, and fail-closed operational tests pass. |

## 14.2 Dependency decision gate

A repository may move from “reference only” to “dependency candidate” only when an ADR supplies all of the following:

1. an approved requirement the current closed grammar or implementation cannot meet;
2. an exact immutable commit and reproducible source/build artefact;
3. licence and notice approval, SBOM and transitive dependency inventory;
4. supported platform/runtime lifecycle and a named patch owner;
5. an input-boundary threat model, malformed-input/fuzz results and vulnerability response plan;
6. deterministic semantics for unknown, error, conflict and timeout;
7. endpoint package, memory, startup, match-latency and snapshot impact against approved thresholds;
8. proof that raw user/process values still remain inside the accepted User Host/Task Host privacy boundary;
9. rollback and removal tests; and
10. evidence that the dependency reduces total risk/cost rather than merely reducing initial code volume.

Popularity, stars, vendor adoption, benchmark claims from a different workload, or a permissive licence alone are not sufficient.

---

# 15. Source register with stable links, dates, versions, claims and limitations

## 15.1 Supplied, allowlisted internal evidence

| ID | Source, date/version and integrity | Claim supported | Limitations |
|---|---|---|---|
| S-INT-01 | `00-accepted-baseline-attachment.md`; baseline dated 31 July 2026; supplied SHA-256 `acaee72712c9203a8827cc235b36b12fb3caf65136d64ea6f3cb9b80681cd5f1` | Accepted endpoint process/session boundaries; C#/.NET family; product privacy ceiling; minimization before Coordinator IPC/storage/logs/transport; offline signed/recoverable configuration; realm isolation and audit invariants; first Edge site/domain slice | Working implementation-research baseline, not human production approval or runtime proof. Exact platform versions, fields, budgets and governance decisions remain gated. |
| S-INT-02 | `02-sanitized-application-catalogue-report.md`; profiled 31 July 2026; source SHA-256 `b1f665fb2d381bd220e95b5158d3d84ceed97772cc3dda940a7ac4ed70f2b2e4`; deterministic profiler named in source | Catalogue quality shape: 173 records/names, five missing external IDs, no observed duplicate non-empty IDs, one IPv4-like label, ten non-ASCII labels and nine possible truncation markers; no owner/rule/role/lifecycle/sensitivity dimensions | Raw values intentionally absent. One snapshot does not prove enduring uniqueness, authority, semantics, currency, entitlement, ownership or matching rules. Counts are not a production-volume forecast. |
| S-INT-03 | `04-data-and-schema-evidence-summary.md`; supplied July 2026 research package | Separation of application/rule/provenance concepts; authenticated realm/device context rather than payload claims; stable dedupe/provenance; narrow integration contracts; absence of representative volumes/retention/RPO/RTO/engine benchmark | Curated summary only; no row values, runtime rates, full schema semantics or capacity evidence. |
| S-INT-04 | `06-research-evidence-rules.md`; supplied July 2026 research package | Evidence-label definitions, source-quality hierarchy, human-decision boundaries, need for CLI proof, and change-proposal discipline | Research method, not evidence that a technical design works. |

## 15.2 Standards, platform and engineering primary sources

Links were reviewed on 31 July 2026. A “current” or living page can change after that date; implementation must pin the selected library/data/version and rerun conformance tests.

| ID | Primary source and stable/direct link | Source/release date and reviewed version | Claim supported | Limitations / UAM-specific caution |
|---|---|---|---|---|
| S-WEB-01 | Microsoft, [.NET and .NET Core Support Policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) | Page updated 14 July 2026; reviewed .NET 10 LTS, original release 11 November 2025, patch 10.0.10 on 14 July 2026, support to 14 November 2028; .NET 8/9 support shown ending 10 November 2026 | Use a currently supported .NET release and remain current on patches; point-in-time lifecycle input for C# implementation | Lifecycle can change; this does not select deployment mode, Windows support matrix or a timeless patch. Reverify at build/release. |
| S-WEB-02 | WHATWG, [URL Living Standard](https://url.spec.whatwg.org/) | Living Standard last updated 6 July 2026 | Browser-oriented URL parse/serialize/host behavior, validation errors, idempotence goal and UTS #46 dependency | Living standard can change; a .NET implementation must be pinned and tested against a versioned golden corpus. It does not define UAM rule semantics. |
| S-WEB-03 | IETF, [RFC 3986 — Uniform Resource Identifier: Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986.html) | January 2005 | URI component terminology, generic syntax and normalization/security background | Contemporary browser URL behavior differs in places; UAM uses WHATWG behavior for browser-observed HTTP(S) input and records the distinction. |
| S-WEB-04 | Unicode Consortium, [UTS #46 rev. 35 — Unicode IDNA Compatibility Processing](https://www.unicode.org/reports/tr46/tr46-35.html) | Unicode 17.0.0; revision 35; 4 September 2025 | Versioned domain-to-ASCII/IDNA processing and error handling | IDNA mapping does not establish ownership or safety of a domain. Runtime/library parity needs fixtures; future Unicode revisions can alter results. |
| S-WEB-05 | Unicode Consortium, [UTS #39 rev. 32 — Unicode Security Mechanisms](https://www.unicode.org/reports/tr39/tr39-32.html) | Unicode 17.0.0; revision 32; 4 September 2025 | Confusable/restriction ideas for warning reviewers about suspicious labels | Security guidance, not an identity algorithm. Confusable results MUST NOT auto-merge applications or auto-create rules. |
| S-WEB-06 | Unicode Consortium, [UAX #15 rev. 57 — Unicode Normalization Forms](https://www.unicode.org/reports/tr15/tr15-57.html) | Unicode 17.0.0; revision 57; 30 July 2025 | NFC normalization for human label/search handling while preserving original source values/provenance | Normalized equality is not proof that two records represent one application. Version changes require reconciliation tests. |
| S-WEB-07 | IETF, [RFC 9562 — Universally Unique IDentifiers](https://www.rfc-editor.org/rfc/rfc9562.html) | May 2024 | UUID format and UUIDv7 time-ordered layout for UAM-owned opaque IDs | UUID uniqueness still depends on a correct generator; timestamp bits can disclose coarse creation ordering. IDs remain scoped by realm and never encode business meaning. |
| S-WEB-08 | IETF, [RFC 8785 — JSON Canonicalization Scheme](https://www.rfc-editor.org/rfc/rfc8785.html) | June 2020 | Deterministic JSON canonicalization option for hashing/signing manifests | UAM must implement/test exact numeric/string constraints and should not canonicalize unbounded input in memory. Canonicalization does not replace schema validation. |
| S-WEB-09 | JSON Schema, [Draft 2020-12](https://json-schema.org/draft/2020-12) | Published 16 June 2022; reviewed Core/Validation 2020-12 metaschemas | Normative contract validation, `oneOf`, bounds and closed objects for API/rule/snapshot schemas | Implementations differ in optional formats/vocabularies. Pin validator and conformance suite; schema validation does not prove semantic safety. |
| S-WEB-10 | IETF, [RFC 4180 — Common Format and MIME Type for CSV Files](https://www.rfc-editor.org/rfc/rfc4180.html) | October 2005 | Baseline quoting/record conventions for the import validator | CSV ecosystems vary; RFC does not address spreadsheet formula injection, encoding policy, size bounds or UAM column semantics. Those are explicit UAM controls. |
| S-WEB-11 | IETF, [RFC 2606 — Reserved Top Level DNS Names](https://www.rfc-editor.org/rfc/rfc2606.html) | June 1999 | `.test` and reserved example names for fictional URL fixtures | Reserved names prevent accidental real-domain use; they do not model every IDNA/DNS behavior. |
| S-WEB-12 | Microsoft, [QueryFullProcessImageNameW](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-queryfullprocessimagenamew) | Documentation dated 8 February 2023 | Supported API for obtaining a process executable image path with access/error handling | Process access can fail; returned text alone is not stable file identity and can race. Failure MUST remain unavailable/unmatched. |
| S-WEB-13 | Microsoft, [GetFinalPathNameByHandleW](https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-getfinalpathnamebyhandlew) | Documentation dated 9 February 2023 | Resolve a final path from an open file handle and understand volume/path forms | Output form and access can vary; final path is not sufficient to prove signer/product or defeat all replacement races. UAM canonicalizes only documented forms and records failure. |
| S-WEB-14 | Microsoft, [WinVerifyTrust](https://learn.microsoft.com/en-us/windows/win32/api/wintrust/nf-wintrust-winverifytrust) | Documentation dated 12 October 2021 | Windows trust-verification API and success/error contract | A successful trust call is contextual and policy-dependent; it does not mean the publisher is approved for a UAM application. Revocation/offline behavior and chain policy need lab evidence. |
| S-WEB-15 | Microsoft, [WINTRUST_FILE_INFO](https://learn.microsoft.com/en-us/windows/win32/api/wintrust/ns-wintrust-wintrust_file_info) and [verifying a PE-file signature example](https://learn.microsoft.com/en-us/windows/win32/seccrypto/example-c-program--verifying-the-signature-of-a-pe-file) | Structure documentation dated 22 February 2024; example updated 15 August 2025 | Open-handle input is available to trust verification; PE embedded-signature verification has important coverage limitations | Sample code is illustrative, not production-safe. An embedded signature may not cover every byte; UAM must test file identity before/after metadata reads and avoid claiming binary integrity beyond the API result. |
| S-WEB-16 | Microsoft, [GetFileVersionInfoW](https://learn.microsoft.com/en-us/windows/win32/api/winver/nf-winver-getfileversioninfow) | Documentation dated 20 November 2024 | Retrieve version-resource data used for product/company metadata | Version resources are publisher-controlled, may be absent/malformed/localized and are not authenticated unless bound to a verified signed file. Parse in restricted Task Host with bounds. |
| S-WEB-17 | Microsoft, [VerQueryValueW](https://learn.microsoft.com/en-us/windows/win32/api/winver/nf-winver-verqueryvaluew) | Documentation dated 9 February 2023 | Read specific version-resource values/translations | Pointer/buffer lifetime and malformed resource handling are implementation risks; values are not authoritative identity by themselves. |
| S-WEB-18 | Microsoft, [KNOWNFOLDERID constants](https://learn.microsoft.com/en-us/windows/win32/shell/knownfolderid) | Documentation dated 7 April 2022 | Stable symbolic known-folder identifiers for path-token rules instead of tenant-specific absolute paths | Folder resolution varies by OS/user/configuration and can fail. Tokens do not authorize profile crawling and are resolved only in the correct session/host boundary. |
| S-WEB-19 | Microsoft, [Adjust case sensitivity](https://learn.microsoft.com/en-us/windows/wsl/case-sensitivity) | Documentation dated 26 April 2022 | Windows directories can have case-sensitivity flags; blindly lowercasing every path is unsafe | Page focuses on Windows/WSL interoperability and is not a complete filesystem identity specification. UAM needs supported-volume lab cases and fail-safe behavior. |
| S-WEB-20 | Microsoft, [GetFileInformationByHandleEx](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-getfileinformationbyhandleex), [FILE_INFO_BY_HANDLE_CLASS](https://learn.microsoft.com/en-us/windows/win32/api/minwinbase/ne-minwinbase-file_info_by_handle_class), and [FILE_CASE_SENSITIVE_INFORMATION](https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntifs/ns-ntifs-_file_case_sensitive_information) | Documentation dated 22 February 2024, 2 June 2021 and 22 February 2024 respectively | Handle-based file identity/case-sensitivity metadata can support TOCTOU and path-comparison controls | Availability depends on OS/filesystem/access. File IDs can have scope/reuse nuances; exact invariants require a Windows lab matrix. |
| S-WEB-21 | Microsoft, [Understanding AppLocker rule condition types](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/app-control-for-business/applocker/understanding-applocker-rule-condition-types) and [Working with AppLocker rules](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/app-control-for-business/applocker/working-with-applocker-rules) | Documentation dated 1 October 2024 and 27 May 2026 | Publisher/path/hash condition concepts and operational cautions are useful Windows precedents | AppLocker is application control, not UAM attribution. Its precedence, trust, path risks and authorization consequences MUST NOT be copied as UAM matching semantics. |
| S-WEB-23 | PostgreSQL, [18 documentation — Row Security Policies](https://www.postgresql.org/docs/18/ddl-rowsecurity.html) | PostgreSQL 18 documentation; reviewed 31 July 2026 | RLS behavior, default deny when enabled without policy, and owner/`BYPASSRLS` bypass caveats | RLS is defense in depth, not the sole realm boundary. Application predicates, composite keys, tests and restricted DB roles remain mandatory; production engine is not selected by this result. |
| S-WEB-24 | Public Suffix List project, [official site](https://publicsuffix.org/) and [list repository](https://github.com/publicsuffix/list) | Mutable community-maintained data; reviewed 31 July 2026 | Registrable-domain/eTLD concepts require an external, changing dataset | Not used in matcher v1. The list is mutable and does not define organizational ownership; adoption would need a pinned version, update/rollback/licence and semantic ADR. |
| S-WEB-25 | OpenFeature, [flag evaluation specification](https://openfeature.dev/specification/sections/flag-evaluation/) and [provider events specification](https://openfeature.dev/specification/sections/events/) | Current specification pages reviewed 31 July 2026 | Useful terminology for typed flag evaluation, defaults, errors and provider-state events | Reference only; it does not authorize an external flag service or define UAM product-ceiling intersection, offline safety, signing or realm controls. |
| S-WEB-26 | NIST, [SP 800-218 Secure Software Development Framework v1.1](https://csrc.nist.gov/pubs/sp/800/218/final) and [SP 800-218 Rev. 1 initial public draft](https://csrc.nist.gov/pubs/sp/800/218/r1/ipd) | v1.1 final February 2022; Rev. 1 initial public draft 17 December 2025 | Secure development/review, provenance, vulnerability response and release-integrity practices; draft signals future evolution | Framework practices are not proof of product security. Rev. 1 is draft and MUST NOT silently replace approved normative controls. Tailoring/accountability remain human decisions. |
| S-WEB-27 | W3C, [Web Content Accessibility Guidelines (WCAG) 2.2](https://www.w3.org/TR/WCAG22/) | W3C Recommendation 5 October 2023; reviewed document revision 12 December 2024 | Accessible labels, focus, error identification, status messages and review UI requirements | Conformance requires implementation and human/assistive-technology testing; this result cannot approve the target level. |
| S-WEB-28 | Prometheus, [Metric and label naming](https://prometheus.io/docs/practices/naming/) and [Instrumentation](https://prometheus.io/docs/practices/instrumentation/) | Maintained documentation reviewed 31 July 2026 | Avoid high-cardinality metric labels; use bounded dimensions and count outcomes/errors rather than raw values/IDs | Operational guidance, not a privacy guarantee. Logs/traces/audit/export paths need separate canary and access tests; exact metric backend is not selected. |

## 15.3 Open-source release/source references

| ID | Repository/release/date | Licence source | Claim supported | Limitations |
|---|---|---|---|---|
| S-OSS-01 | OPA [`v1.19.0`](https://github.com/open-policy-agent/opa/releases/tag/v1.19.0), 30 July 2026, release commit `1e32c79` | [Apache-2.0](https://github.com/open-policy-agent/opa/blob/v1.19.0/LICENSE) | Bundle/validation/test ideas; current release and Compile-API security fix | Source review only; no UAM build, transitive audit or runtime fitness proof. General language threat model differs. |
| S-OSS-02 | Cedar [`v4.12.0`](https://github.com/cedar-policy/cedar/releases/tag/v4.12.0), 28 July 2026, release commit `fdcbaed` | [Apache-2.0](https://github.com/cedar-policy/cedar/blob/v4.12.0/LICENSE) | Schema/ID/validation/symbolic-analysis ideas; malformed-input and depth controls | Experimental/unchecked APIs exist; no UAM integration or proof. Authorization semantics differ. |
| S-OSS-03 | Backstage [`v1.53.1`](https://github.com/backstage/backstage/releases/tag/v1.53.1), 29 July 2026, release commit `eb8e4c0` | [Apache-2.0](https://github.com/backstage/backstage/blob/v1.53.1/LICENSE) | Catalogue/provenance/relation design reference and recent maintenance | Large platform/plugin surface; no endpoint/privacy-boundary fit. |
| S-OSS-04 | Envoy [`v1.39.0`](https://github.com/envoyproxy/envoy/releases/tag/v1.39.0), 14 July 2026, release commit `8eea328` | [Apache-2.0](https://github.com/envoyproxy/envoy/blob/v1.39.0/LICENSE) | Typed host/path predicates, config validation, route tests and security-bound lessons | Network proxy and ordered-routing semantics differ; C++ runtime not assessed for UAM. |
| S-OSS-05 | osquery [`5.23.1`](https://github.com/osquery/osquery/releases/tag/5.23.1), 24 June 2026, release commit `b753833` | [`Apache-2.0 OR GPL-2.0-only`](https://github.com/osquery/osquery/blob/5.23.1/LICENSE) | Windows process/Authenticode metadata patterns and concrete native-parser security risk | Broad telemetry/SQL agent; selected release itself fixes Windows heap overflows; no reuse authorization. |
| S-OSS-06 | uBlock Origin [`1.72.2`](https://github.com/gorhill/uBlock/releases/tag/1.72.2), 8 July 2026, release commit `3d370ea` | [GPL-3.0](https://github.com/gorhill/uBlock/blob/1.72.2/LICENSE.txt) | URL filter indexing/parser-test ideas at high rule counts | Copyleft and very different filter grammar/threat model; no code reuse proposed. |
| S-OSS-07 | Z3 [`z3-5.0.0`](https://github.com/Z3Prover/z3/releases/tag/z3-5.0.0), 17 July 2026, release commit `8e3402b` | [MIT](https://github.com/Z3Prover/z3/blob/z3-5.0.0/LICENSE.txt) | Optional offline overlap-analysis oracle and current .NET binding availability | Complex solver; timeout/`unknown`/theory defects must fail closed. No production dependency decision. |

## 15.4 Evidence traceability rules

- A public-source fact in this result is point-in-time as of 31 July 2026 unless the source itself is a fixed historical standard.
- A stable standard or documented API proves syntax/capability, not UAM fitness, performance, security, availability or governance approval.
- A release tag and maintenance activity prove the reviewed source state, not future support or absence of vulnerabilities.
- Every implementation ADR and test report MUST cite the exact source IDs, dependency versions, normalizer version, snapshot schema version and fixture/threshold hashes it relied on.
- A future source that materially conflicts with an accepted decision triggers an explicit change proposal and falsifying experiment; it does not silently change endpoint semantics.

---

# 16. Confidence table for every major conclusion

Confidence levels are qualitative. They express the strength of evidence for the proposed design, not probability or production approval.

| Major conclusion | Label and confidence | Why | Evidence that would reduce/change confidence | Residual risk / containment |
|---|---|---|---|---|
| UAM must own a stable application ID rather than use a name or external key | **RECOMMENDATION — High** | Catalogue has missing external IDs and no durable authority/uniqueness contract; UUID is a standard opaque identifier [S-INT-02] [S-WEB-07] | A binding, realm-safe external master contract with immutable IDs, merge/split semantics and migration proof | Human duplicate/merge mistakes remain; immutable IDs, lineage and two-person review contain them |
| IDs should be realm-scoped UUIDv7 and never reused | **RECOMMENDATION — High** | Supports isolation, ordered indexing and opaque identity without business semantics [S-INT-01] [S-WEB-07] | Generator collision/ordering/privacy/index tests fail, or an enterprise identity standard proves better fit | Coarse creation time is visible; no raw ID in metrics and IDs remain meaningless outside authenticated realm |
| External IDs and CMDB links are nullable, source-qualified references | **RECOMMENDATION — High** | Five missing IDs and no supplied uniqueness contract; integrations should be narrow and explicit [S-INT-02] [S-INT-03] | Approved source contract proves required uniqueness/authority and conflict lifecycle | Stale/duplicate mappings can mislead humans; conflicts block automatic apply and never drive endpoint matching |
| Names/aliases are for display/search/reconciliation only; no real rule may be derived from them | **RECOMMENDATION — High** | Source explicitly lacks matching semantics and has non-ASCII/truncation/address-like quality warnings [S-INT-02] | No ordinary evidence should change the prohibition; a proposed exception would need governance/change ADR and cannot rely on name alone | Manual mapping can still be wrong; preserve provenance, show warnings, require explicit target/application review |
| Registry and rules require immutable revisions and provenance | **RECOMMENDATION — High** | Audit, rollback, conflict review and source reconciliation require reconstructable state; accepted baseline requires durable audit [S-INT-01] [S-INT-03] | Storage/operations prototype shows untenable cost and a different immutable history model preserves all invariants | Revision growth/retention cost unknown; partition/archive only after retention and restore decisions |
| Ownership, category, sensitivity and lifecycle need explicit assignments but their values/authorities are human decisions | **RECOMMENDATION — High for schema; Low for actual assignments** | These dimensions are absent from evidence and explicitly outside research authority [S-INT-02] [S-INT-04] | Named source-of-truth contracts and accountable role decisions | Empty/stale ownership blocks real publication; conservative default is `UNASSIGNED`/proposal-only, not inferred data |
| Import must stage, validate, quarantine, require explicit mapping and apply atomically; it must never create rules | **RECOMMENDATION — High** | Measured quality conditions and uncertain source authority make direct upsert/auto-rule unsafe [S-INT-02] | G-AR1 falsifying tests fail, or a later authoritative API proves safer automation while retaining gates | Manual review load and staging retention cost; strict expiry/access/deletion and idempotent apply contain it |
| A closed typed grammar is safer than regex, scripts or a general policy engine | **RECOMMENDATION — High** | Finite grammar permits bounded evaluation/exact conflicts and minimizes endpoint attack surface; OSS general engines have broader threats [S-INT-01] [S-OSS-01] [S-OSS-02] | Approved use case cannot be represented and a bounded alternative passes security, conflict, offline and operations gates | Feature pressure may cause unsafe extensions; every new predicate requires schema/normalizer/analyzer/snapshot version and kill switch |
| URL v1 should support normalized HTTP(S) exact/suffix hosts, optional scheme/port, with path matching disabled initially | **RECOMMENDATION — High for host scope; Medium for exact implementation** | First slice is site/domain level; WHATWG and UTS #46 provide current parsing/IDNA basis [S-INT-01] [S-WEB-02] [S-WEB-04] | Differential/golden/fuzz tests show runtime divergence or privacy review approves a different representation | Living-standard/library drift; pin versions, reject errors, publish normalization version, no raw URL beyond User Host |
| URL path exact/segment-prefix rules can exist only behind a product-ceiling feature flag and separate privacy approval | **RECOMMENDATION — Medium** | Some future applications may share hosts, but paths raise privacy and canonicalization risk | Approved purpose cannot be met host-only and G-AR2 path corpus/privacy canaries pass; or privacy authority prohibits paths entirely | Paths can encode personal/confidential data; snapshot stores only approved predicates and output never carries path |
| Process rules should prefer verified signer profile plus product metadata | **RECOMMENDATION — Medium** | Windows exposes trust and version APIs; publisher/product is more stable than filename/path alone [S-WEB-14] [S-WEB-16] [S-WEB-17] [S-WEB-21] | Supported-lab tests show common unavailability, unacceptable revocation/offline behavior, spoof cases or rollover operational failure | Trust result is not business approval; explicit publisher profile, handle/file identity checks, no weaker fallback, process kill switch |
| Process path rules should use approved known-folder tokens and exact/segment-prefix semantics; filename-only remains off | **RECOMMENDATION — Medium** | Avoids tenant/user-specific paths and simple filename spoofing; Windows case/filesystem behavior is nuanced [S-WEB-18] [S-WEB-19] [S-WEB-20] | G-AR6 supported-volume/session matrix fails or an approved application cannot be identified safely | Reparse points, case flags, inaccessible files and replacement races; fail unavailable, compare handle identity, restrict Task Host |
| Priority, fixed rule-family authority and partial-order specificity provide deterministic precedence | **RECOMMENDATION — High for specification; Medium for implementation** | Avoids author order/newest/ID guessing and permits explainable maxima | Formal/generated counterexample shows non-transitive/incomplete relation or endpoint/analyzer parity fails | Implementation defect could misattribute; single shared matcher core, property tests and complete analyzer are publication gates |
| Cross-application maximal ties must return `AMBIGUOUS`; unmatched/invalid/unavailable never become guessed matches | **RECOMMENDATION — High** | Fail-safe attribution preserves data quality and exposes governance conflict | A human request for “best effort” is not sufficient; only a new approved risk decision plus privacy/data-quality evidence could challenge it | Under-attribution can increase; bounded reason metrics and rule workflow address it without leaking raw values |
| Static overlap, redundancy, ambiguity and shadow analysis is practical for the restricted grammar | **RECOMMENDATION — High for feasibility; Medium pending code** | Predicates reduce to finite host suffix/equality, segment-prefix and field equality/set relations; generated witnesses can falsify | FP-03 finds false negatives, invalid witnesses, timeout-as-safe, or unsupported predicate combinations | Analyzer bugs are publication-critical; unknown blocks publication, parity corpus and optional Z3 oracle in tests |
| Matching must occur in User Host/Task Host before Coordinator IPC | **RECOMMENDATION — High** | Directly follows accepted session/privacy boundary and first-slice minimization [S-INT-01] | Only a formal baseline change with stronger privacy/security evidence could alter it | Host compromise can still observe source values in its legitimate boundary; least privilege, short-lived Task Host and no raw diagnostics contain exposure |
| Endpoint snapshots should exclude names, owners, external keys, categories, CMDB links and raw values | **RECOMMENDATION — High** | Endpoint needs only opaque target IDs and predicates; exclusion reduces privacy/config breach impact [S-INT-01] [S-INT-03] | An approved endpoint feature proves a field strictly necessary and product-ceiling/privacy tests pass | Rule predicates themselves may be sensitive configuration; sign, encrypt in transit, restrict local ACLs and diagnostics |
| Full immutable signed per-realm snapshots with LKG should be first implementation | **RECOMMENDATION — Medium** | Simplest offline integrity/rollback model; no measured size evidence justifies deltas [S-INT-01] | G-AR4 fails approved size/download/startup/disk budgets and a delta/binary prototype preserves crash/recovery/security invariants | Large rule sets can increase cost; hard bounds, compiled indexes, cohorts and stop gate prevent silent degradation |
| Rollback must be a new higher sequence containing previously approved content | **RECOMMENDATION — High** | Prevents downgrade/replay ambiguity while keeping complete audit and offline monotonicity | Only a cryptographic/publication counterexample or enterprise release protocol incompatibility | A compromised signer can publish bad higher sequence; separate approval/signing, threshold/key controls, kill switch and incident drill |
| Realm isolation must be enforced in auth context, composite keys/FKs, repositories, caches, signing and tests—not payload IDs alone | **RECOMMENDATION — High** | Accepted invariant and target data principle explicitly reject payload-derived realm [S-INT-01] [S-INT-03] | Adversarial G-AR5 tests expose a bypass or chosen database lacks required controls | One missed cache/query/signer scope can breach tenants; deny-by-default context, RLS defense in depth, two-realm property tests |
| Metrics/logs must use bounded enums/cohorts and never raw URLs/paths, application IDs, realm IDs or free labels as metric dimensions | **RECOMMENDATION — High** | Accepted privacy ceiling and standard cardinality guidance [S-INT-01] [S-WEB-28] | Operational diagnosis cannot meet approved SLO through audited lookup/bounded aggregation and privacy review approves a controlled alternative | Debug pressure can cause leaks; canary scanner, schema allowlist, log review and emergency diagnostics expiry/deletion |
| Feature flags and kill switches may only narrow the release-authorized ceiling and must have safer defaults | **RECOMMENDATION — High** | Tenant policy cannot broaden product capability; offline safety needs deterministic defaults [S-INT-01] [S-WEB-25] | Enterprise control-plane requirement proves an external provider meets signing/offline/realm/rollback gates | Stale/mis-scoped flag can disable needed collection or enable risk; signed snapshot binding, local ceiling, audit and family-specific kill switches |
| Reviewed OSS should remain reference-only in the first slice | **RECOMMENDATION — Medium-High** | None matches UAM’s finite attribution/privacy threat model; custom grammar is small; current releases demonstrate both mature practices and broad attack surface [S-OSS-01]–[S-OSS-07] | Implementation cost/defect rate is worse than a dependency candidate that passes section 14.2 gate | In-house code still needs expert review/fuzzing; dependency gate remains open to evidence rather than ideology |
| Exact snapshot/matcher performance, disk, startup, memory and operational cost are unknown until measured | **UNKNOWN / CLI EXPERIMENT — High confidence that evidence is missing** | Supplied evidence has no representative rule/snapshot distributions or approved budgets [S-INT-03] | Representative cohorts, threshold decisions and reproducible G-AR4 results | Architecture could be too slow/large; no scale claim or real publication before thresholds pass |
| Process matching production fitness is unproved and should remain disabled until G-AR6 | **UNKNOWN / RECOMMENDATION — Medium-High** | Documentation proves APIs, while current OSS security fixes and Windows edge cases show real implementation risk [S-WEB-12]–[S-WEB-21] [S-OSS-05] | Approved supported-platform lab matrix passes spoof/race/access/offline trust/resource/privacy tests | Some applications may remain unmatched; safer than false attribution or expanded process surveillance |
| Who may create, approve, publish and retire rules, and who owns applications/source truth, cannot be decided by research | **HUMAN DECISION — High confidence in boundary; Low confidence in outcome** | Explicitly prohibited from invention by the prompt and evidence rules [S-INT-04] | Documented accountable assignments, separation-of-duty policy, emergency process and support rota | Without owners, no real rule reaches publication; temporary conservative state is no production publication |

## 16.1 Residual risk

Research and schemas cannot make the following safe by themselves:

- A human owner can approve the wrong application, purpose, category, sensitivity, external mapping or rule. Immutable history makes the decision visible; it does not make it correct.
- A source system or CMDB can be stale, semantically inconsistent, duplicated or unavailable. UAM can record provenance/conflict and refuse automation, but cannot establish organizational truth.
- URL parsers, IDNA data and Unicode confusable handling can change. A pinned normalization version and golden corpus contain drift, but cannot prove that a domain is benign or belongs to an application.
- Windows process path, signature and version metadata can be inaccessible, malformed, replaced during inspection, differently interpreted across filesystems, or affected by certificate/revocation state. The safe consequence is `UNAVAILABLE`/`UNMATCHED`, which creates coverage gaps.
- A signing-key or privileged publication compromise can produce a valid but malicious higher-sequence snapshot. Separation of duties, constrained signer identity, product-ceiling enforcement, key rollover/revocation, audit and kill switches reduce—not eliminate—this risk.
- Full snapshots may be too large or slow at the eventual rule count; the current evidence provides no approved byte, CPU, memory, disk, network or activation budgets.
- Strict ambiguity and failure-safe behavior deliberately under-attributes uncertain activity. This is a data-quality and support cost, but guessing would create a more serious false-attribution/privacy risk.
- Rule predicates and registry governance metadata may themselves be confidential. Endpoint minimization reduces exposure, but central access, audit retention, backups, exports, support tooling and incident evidence still need approved controls.
- Metrics with bounded labels can hide localized problems; richer diagnosis must occur through audited, time-bounded object lookup rather than unbounded observability labels.
- Accessibility cannot be proved from schemas or automated tests alone. Human review with keyboard and assistive technologies is still required.
- UAM telemetry remains fallible operational evidence. A successful match does not prove application use, intent, entitlement, misconduct, productivity or forensic truth.
- Ownership, legal purpose, prohibited uses, identity level, retention, access, employee consultation, budget, SLO/RPO/RTO, support coverage and production approval remain dependent on accountable humans.

## 16.2 Explicit next stop/go gate

**Next gate: G-AR0 followed by G-AR1–G-AR3 using fictional/sanitized data only.** Work may proceed to the contract skeleton, realm-scoped schema, UUID/application revision model, synthetic import validator, closed URL-host matcher and exact conflict analyzer only after the product purpose/source/privacy ceiling is recorded and functional decision owners are named. No real catalogue row is applied and no real rule is authored or published at this stage.

**STOP** when any of the following is true: owner/source authority is absent for real data; the import validator leaks or auto-merges; the matcher guesses on invalid/ambiguous/unavailable input; analyzer `unknown` or timeout is treated as safe; realm isolation/audit/signature tests fail; approved performance thresholds are missing or fail; rollback is untested; or support/incident ownership is absent.

**GO to the first real URL-host rule only after G-AR0 through G-AR7 pass and G-AR8 records, for that exact revision, an accountable owner, approved purpose, synthetic positive/negative examples, complete conflict result, approval, signed publication evidence, canary plan and tested higher-sequence rollback.** Until then, the primary gate remains closed:

> **No real rule is published without owner, purpose, revision, synthetic test examples, conflict result, approval, and a tested rollback path.**
