# G4 URL canonicalization, application matching, and endpoint privacy transformation

**Result path:** `batches/02-endpoint-data/08-g4-url-privacy-transformation/result-08-g4-url-privacy-transformation.md`  
**Research date:** 31 July 2026  
**Decision status:** **ACCEPT WITH MANDATORY CONDITIONS**  
**Authority boundary:** endpoint URL parsing, application matching, and pre-IPC privacy-transformation architecture; **not** legal approval, purpose approval, employee-monitoring approval, field approval, retention approval, production risk acceptance, or deployment approval  
**Predecessor:** Batch 01 foundations, accepted with mandatory conditions  
**Primary G4 gate:** **No forbidden source value or reversible derivative crosses into User Host/Coordinator IPC, durable storage, logs, diagnostics, crash/support artifacts, metrics, traces, or transport.**  
**Immediate safe permission:** pure normalizer/matcher/transform code, fictional golden vectors, pinned reference corpora, offline rule analysis, property/fuzz harnesses, and a synthetic three-process canary prototype after its Batch 01 prerequisites  
**Immediate prohibition:** live-source enablement, production-derived URL testing, URL-path/query/title output, role inference, person-level identity, raw or hashed source-value telemetry, and production deployment

## Evidence vocabulary

This result uses the required labels:

- **FACT** — directly supported by an allowlisted supplied result or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from facts; the chain is stated.
- **ESTIMATE** — a numerical hypothesis with replaceable inputs.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, or business authority is required.
- **CLI EXPERIMENT** — code, lab work, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements form the proposed G4 implementation baseline. They do not convert a **HUMAN DECISION** into approval.

## Evidence boundary and file-presence record

**FACT.** All five allowlisted Project inputs were present. No other Project file was opened, searched, quoted, summarized, or used. The predecessor was exported locally as `batch-01-review-result(3).md`; its own title and declared result path identify it as the allowlisted `result-review-01-foundations.md`. The transport suffix is recorded here rather than silently treated as a different result.

| Ref | Allowlisted input | SHA-256 of reviewed attachment | Use and limitation |
|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md` | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | accepted endpoint/process/privacy invariants; condensed baseline, not production authority |
| I02 | `02-sanitized-application-catalogue-report.md` | `2be034d723dbfc6230deef25898c9555677b0c347fc29ad2562ebfa891d556a5` | catalogue shape only; no raw values, ownership, purpose, role, rule, entitlement, or usage authority |
| I03 | `05-decisions-contradictions-and-gates.md` | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | accepted decisions and ordered G0–G5 proof gates |
| I04 | `06-research-evidence-rules.md` | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | evidence labels, source-quality rules, and human authority boundaries |
| I05 | `result-review-01-foundations.md` (local export `batch-01-review-result(3).md`) | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | accepted predecessor decisions for contracts, G1, application identity/matching, privacy lattice, repository, and test evidence |

**FACT.** I02 proves 173 unique case-insensitive application names, five missing external correlation IDs, 168 distinct non-empty external IDs, no duplicate non-empty values in that snapshot, ten names with non-ASCII characters, one address-like IPv4 literal in a name, and nine possible truncation markers. It expressly does **not** prove ownership, purpose, roles, URL rules, entitlement, usage, or currentness. This result uses those aggregate shapes only for fictional tests.

**Conflict outcome.** No accepted-baseline change proposal is required. Placing the final privacy transformation inside the Task Host before any result serialization is a stricter realization of I01/I05, not a redesign: I05 already requires the Task Host to return only minimized output and forbids raw source data at the Coordinator boundary.

---

# 1. Executive conclusion in easy language, with confidence and residual risk

## 1.1 Decision

**RECOMMENDATION — ACCEPT WITH MANDATORY CONDITIONS.** UAM should treat a browser-history URL as a short-lived secret. The raw URL is read only inside the user-session Task Host, checked by a narrow, versioned parser profile, tested against hard-deny policy, matched to an approved application rule, and transformed into a new minimized record. Only that new record may leave the Task Host. The raw URL, Unicode display host, user information, path, query, fragment, title, source database location, and any hash or HMAC of those forbidden values must not survive as a UAM-owned application artifact beyond the Task Host lifetime and must never appear in IPC, storage, logs, metrics, traces, crash reports, support bundles, or uploads.

The first production-capable grammar remains deliberately small:

- absolute `http` or `https` URLs only;
- DNS host only, represented as a canonical lower-case ASCII A-label;
- exact-host or DNS-label-boundary suffix rules only;
- an explicit scheme set and explicit default/exact port semantics;
- no path, query, fragment, title, regex, wildcard language, fuzzy matching, DNS lookup, role mapping, or first-match ordering;
- one application after deterministic priority/specificity evaluation, otherwise no assignment.

**RECOMMENDATION.** Implement a small UAM strict-profile wrapper in C# over the exact supported .NET runtime parser/IDNA implementation selected at build time. Do not write a complete URL, IDNA, Punycode, or public-suffix parser. Do not treat `System.Uri` as the specification. The wrapper’s behavior is defined by UAM golden vectors and is different from browser navigation behavior: it rejects whitespace/control stripping, backslash recovery, percent-encoded host syntax, user information, legacy IP forms, and other parser-recovery cases even when a browser would accept them. Differential references include the WHATWG URL Standard and WPT corpus, Ada, Rust URL, Unicode IDNA vectors, and a pinned Public Suffix List artifact.

## 1.2 Why this is the safest simple design

**FACT.** The accepted baseline requires minimization before Coordinator IPC, durable storage, diagnostics, or transport and makes user/session boundaries security and privacy boundaries [I01, I05]. **FACT.** The predecessor allows only the URL-host matcher family for the first slice and requires deterministic `AMBIGUOUS` rather than guessing [I05].

**FACT.** The WHATWG URL algorithm intentionally recovers from or normalizes several inputs for browser interoperability, including stripping leading/trailing C0 controls or spaces and ASCII tabs/newlines, handling backslashes for special schemes, and parsing legacy IPv4 representations [W01, W09]. **INFERENCE.** A browser-compatible parser is useful as a differential reference, but browser recovery is too permissive to define a privacy/security boundary. Therefore UAM’s lexical gate rejects those inputs before invoking the candidate parser.

**FACT.** Unicode UTS #46 Revision 35 specifies compatibility processing for internationalized domain names and recommends non-transitional processing; the URL Standard invokes UTS #46 with explicit validation settings [W02]. **INFERENCE.** UAM can support internationalized DNS names without carrying raw Unicode host text across the privacy boundary by converting inside the Task Host to a validated ASCII A-label and matching only that representation.

## 1.3 Confidence and residual risk

| Major conclusion | Confidence | Reason | Evidence that could change it |
|---|---|---|---|
| Raw URLs must be transformed inside the Task Host before any IPC | **High** | direct accepted invariant and predecessor process contract | a stronger, independently proved isolation design that still sends no raw or reversible value across a boundary |
| A narrow, strict UAM profile is safer than browser-lenient parsing | **High** | primary standards document browser recovery behavior; UAM has a different threat model | a falsifying corpus showing strict rejection creates unavoidable data corruption or bypass while a documented alternative preserves all invariants |
| Complete custom URL/IDNA/PSL code is too risky | **High** | specifications are complex and actively maintained; mature implementations carry large conformance/fuzz suites | proof that all candidate libraries fail a bounded UAM profile and a separately reviewed implementation passes full reference, differential, fuzz, and maintenance gates |
| .NET plus a UAM wrapper is the initial implementation candidate | **Medium** | matches accepted C# family and minimizes native dependencies; exact semantic fitness is unproved | differential or fuzz evidence of uncontainable divergence, unsupported UTS #46 behavior, or resource/safety failure |
| Exact/suffix host matching with deterministic ambiguity is sufficient for the first slice | **High** | accepted predecessor decision and site/domain first slice | approved use case and evidence that requires another finite matcher family without weakening minimization |
| Public-suffix data must be pinned and versioned, not an online authority | **High** | offline requirement, list churn, and realm/snapshot reproducibility | a governed offline update mechanism with equal reproducibility and no new network/authority path |
| Production output fields, hard-deny categories, and PSL/private semantics remain human decisions | **High** | explicitly reserved by the prompt and predecessor | only an accountable human decision record can change them |

**Residual risk.** Standards and repository review cannot prove the exact .NET runtime behavior on the supported Windows estate, canary scanners can miss encodings or operating-system sinks, managed strings cannot be reliably zeroized, crash/EDR/pagefile capture may observe process memory, IDNA and PSL data evolve, and a syntactically valid domain can still be sensitive. These risks are contained by short-lived process scope, no raw serialization, dump suppression, bounded inputs, fail-closed disagreement, pinned artifacts, exact sink scanning, kill switches, and the G4 stop gate. They are not eliminated.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 In scope

This result defines:

1. the normative parsing and canonicalization order for the first Edge browser-history slice;
2. host/port/IDNA/trailing-dot/IP/special-use/public-suffix handling;
3. hard-deny, allowlist, application-rule, priority, specificity, and ambiguity evaluation;
4. the final pre-IPC privacy transformation and typed rejection/progress outcome;
5. time and identity reduction decision points without approving their values;
6. feature flags, kill switches, configuration ownership, versioning, realm isolation, and rollout compatibility;
7. privacy-safe observability, error taxonomy, incident response, support/runbook ownership, and metric-cardinality rules;
8. differential, property, fuzz, canary, parser-disagreement, rule-conflict, and all-sink tests;
9. open-source dependency/reference assessment and exact admission gates;
10. fitness functions, CLI experiments, ADRs, backlog, confidence, residual risk, and next stop/go gate.

## 2.2 Non-goals

This result does not:

- design Edge acquisition, profile discovery, source generations, or cursors beyond the contract handed in from G2/G3;
- authorize live collection, a production source, a production realm, or organization-derived activity;
- approve site/domain/path output, exact event fields, time precision, identity level, retention, legal purpose, or prohibited-use policy;
- define hard-deny categories or classify any real domain;
- decide whether the Public Suffix List PRIVATE section expresses UAM business semantics;
- enable URL-path, query, fragment, page-title, filename, process, publisher, fuzzy, regex, role, person, or entitlement matching;
- design endpoint SQLite transaction/failpoint behavior; G5 owns atomic event/progress/cursor persistence;
- design server ingestion, central dedupe, portal display, reporting, retention, deletion, or integrations;
- claim that telemetry is forensic proof or a productivity score.

## 2.3 Accepted inputs to G4

The Task Host may receive only these authorities and source facts:

| Input | Trust source | Permitted content | Must not contain |
|---|---|---|---|
| `CollectionPermit` | User Host, bound to accepted G1 transcript | one-use nonce; realm/installation/session binding digests; source/capability ID; product-ceiling, tenant-policy, snapshot, normalizer, transform, and output-schema IDs/digests; run/input/output/resource limits | executable code, regex, address, arbitrary path, raw URL, display names, role/person policy |
| `RuleSnapshot` | release/realm-authorized immutable artifact already activated by User Host | opaque application/rule UUIDs, exact/suffix predicates, schemes, explicit port mode/value, priority, specificity metadata, hard-deny predicate IDs, normalizer/PSL versions and digests | names, aliases, owners, categories, external IDs, observed URLs, user identities, arbitrary expressions |
| `SourceObservation` | fixed Edge collector capability inside Task Host | source-row stable reference/progress key, observed time at source precision, raw URL in process memory | any claim that realm/device/application/user identity is authoritative |
| `RuntimeContext` | G1/G3 trusted local facts | fixed clock-confidence state, active versions/digests, source generation, bounded run budget | tenant-supplied executable behavior |

**RECOMMENDATION.** The raw URL must enter the canonicalizer as a `ReadOnlySpan<char>` or equivalent bounded view over collector-owned memory when practical. It must not be placed in a general-purpose DTO, exception, activity tag, structured-log scope, cache key, dictionary key, diagnostic object, or IPC serializer.

## 2.4 Assumptions

- **ASSUMPTION.** G0/B01 contract, fictional test-data, canary, repository, policy, and application-registry gates have passed for the code revision under test.
- **ASSUMPTION.** G1 has established the Coordinator/User Host/Task Host process and IPC isolation for the claimed Windows support matrix.
- **ASSUMPTION.** G2/G3 provide a bounded absolute URL string and stable source-progress fact from a synthetic Edge source; G4 does not trust its syntax.
- **ASSUMPTION.** The active product ceiling and tenant policy are already verified, same-realm, unexpired, monotonic, and tenant-narrowing.
- **ASSUMPTION.** A rule snapshot contains only approved finite predicates and has passed offline overlap/shadow analysis.
- **ASSUMPTION.** No production field is emitted until its human decision record is approved; conservative defaults disable that emission.

## 2.5 Unknowns and conservative temporary defaults

| Unknown | Why it matters | Conservative temporary default |
|---|---|---|
| Approved site/domain/path output | determines whether canonical host, registrable domain, application ID, or no event may leave endpoint | **disabled**; in synthetic tests use opaque application ID plus fictional site output only |
| Hard-deny categories and entries | syntactic filters cannot identify all sensitive sites | product ceiling contains an empty fictional-only registry; live collection remains disabled until approved; special-use/IP/local inputs are structurally suppressed |
| PSL ICANN/PRIVATE business meaning | `foo.github.io`-like cases differ by section and are not security truth | PSL-derived site output disabled; exact-host matching only; ICANN-only facts are test/structural evidence and PRIVATE-based decisions are disabled |
| Time precision | exact times can increase singling-out risk | no production event; test profile uses a declared coarse fictional bucket |
| Identity level/projection | raw or stable identity can enable tracking | omit person/user identity; session tuple remains only local authorization context |
| Non-default ports | may reveal internal services and affect application semantics | reject unless a product-ceiling rule explicitly permits the exact port |
| Unicode-host output | Unicode can be confusable and reveals original text | never emit Unicode host; canonical ASCII A-label only if site output is approved |
| Maximum input/resource limits | needed for DoS containment and source compatibility | bootstrap hard ceilings in section 5 are **ESTIMATE** and may only move through compatibility-aware measurement/ADR |
| Parser/IDNA dependency fitness | documentation does not prove UAM semantics | no production-shaped use until golden, differential, fuzz, and Windows all-sink tests pass |
| Crash-dump/EDR/pagefile behavior | raw URL may exist in Task Host memory | disable Task Host dumps where supported, short lifetime/no swap assumptions not claimed, lab evidence and security owner decision required |

---

# 3. Recommended design with exact component responsibilities and trust boundaries

## 3.1 Component baseline

| Component | MUST do | MUST NOT do | Owner function |
|---|---|---|---|
| `Uam.UrlProfile` | implement strict lexical gate, canonicalization state machine, stable reason codes, and canonical host/port tuple | log/copy raw input; resolve DNS; call network; infer application; carry path/query/title output | Endpoint Data/Privacy Engineering |
| `Uam.UrlProfile.Reference` | independently calculate expected outcomes for golden/property tests using declarative vectors | reference production parser/matcher code; become runtime authority | Test Architecture, separate code owner |
| `Uam.IdnaAdapter` | invoke exact admitted IDNA implementation with fixed options; validate errors, DNS lengths, A-label round-trip/version | accept best-effort output after an IDNA error; expose Unicode source text downstream | Endpoint Security/Internationalization |
| `Uam.PublicSuffix` | load a pinned local list by digest; expose explicit `ICANN_ONLY`, `ICANN_AND_PRIVATE`, and `DISABLED` modes; never update at runtime | fetch, auto-refresh, or treat PSL as authorization or proof of ownership | Application Registry/Data Governance |
| `Uam.HardDeny` | evaluate release-owned structural and category predicate IDs before application assignment; allow tenant only to add/narrow | accept tenant executable expressions; reveal which value matched; emit raw denied value | Product Privacy/Security |
| `Uam.ApplicationMatching` | evaluate all same-realm exact/suffix rules, priority, family authority, partial-order specificity, and ambiguity | first-match; row-order tie-break; regex; wildcard language; fuzzy/name/role inference | Application Registry |
| `Uam.PrivacyTransform` | construct a new allowlisted minimized DTO, reduce time/identity, validate output schema and permit binding | mutate/copy source DTO; hash forbidden value; include exception text or source path | Product Privacy/Endpoint Data |
| `Uam.PrivacySinkGuard` | statically and dynamically block forbidden fields/types/sinks; scan all artifacts with exact canaries | rely on one scanner; use broad suppressions; upload artifacts externally | Privacy Engineering/AppSec |
| Task Host | own raw source read, URL profile, deny, match, transform, source-buffer lifetime, and minimized result serialization | send raw URL/path/query/host/title/identity or reversible derivative to User Host; write durable raw data | Endpoint Runtime |
| User Host | validate permit/result versions, schema, bounds, policy/snapshot digests, and source-progress disposition; forward minimized result only | receive a raw URL; reconstruct or enrich from user profile; log rejected value | Endpoint Runtime |
| Coordinator | validate minimized contract and atomically hand event/progress to G5 storage path | parse/canonicalize raw source; receive raw URL; infer realm/device from payload | Endpoint Runtime/Storage |
| Snapshot compiler/analyzer | compile only approved same-realm finite rules; produce overlap/shadow/ambiguity witnesses and immutable minimized snapshot | use observed production activity as a hidden rule source; publish unresolved cross-app ambiguity | Registry Publication |
| Release/Policy authority | authorize normalizer, transform, output schema, PSL digest/mode, deny registry, feature flags, and kill switches | let a tenant broaden source/fields/matcher/destination or select arbitrary code/data URL | Release/Privacy Authority |

## 3.2 Trust boundaries and privacy boundary placement

```text
Edge history row (raw, user-owned source)
  [inside fixed Task Host only]
    -> bounded source adapter
    -> strict lexical gate
    -> syntactic URL parser candidate
    -> scheme/authority/userinfo/port checks
    -> IDNA-to-ASCII + DNS-label validation
    -> IP/special-use/local/PSL structural checks
    -> product + tenant hard-deny intersection
    -> same-realm exact/suffix application matcher
    -> deterministic MATCHED / AMBIGUOUS / UNMATCHED
    -> approved field/time/identity reduction
    -> construct new minimized DTO
    -> output schema + permit + canary guard
    -> serialize minimized DTO or value-free rejection
  [Task Host -> User Host IPC: privacy boundary already crossed]
    -> User Host independent validation
  [User Host -> Coordinator IPC]
    -> Coordinator independent validation
    -> G5 atomic event/progress transaction
```

**Normative boundary.** No raw source component may cross the first closing bracket. The Task Host must produce a minimized typed value before opening its result serializer. This is stronger than “before Coordinator IPC”: the User Host must never receive raw source values either.

**Managed-memory limitation.** C# strings are immutable and cannot be reliably zeroized. Therefore the implementation SHOULD avoid unnecessary `string` copies, substrings, interpolation, regex, LINQ captures, exception messages, and diagnostic scopes; SHOULD use spans and fixed result structs where practical; MUST keep the Task Host short-lived; MUST NOT enable automatic full-memory dumps for this process; and MUST treat process memory/pagefile/EDR capture as residual risk rather than claiming deletion.

## 3.3 Normative canonicalization and transformation pipeline

The following order is mandatory. A later stage may not “repair” a rejection from an earlier stage.

| Step | Operation | Normative rule | Output or rejection |
|---:|---|---|---|
| 0 | Authority precheck | validate active permit, same realm/session, snapshot/ceiling/policy/normalizer/PSL digests, expiry, feature flags, kill switches, and run budget | `POLICY_DISABLED`, `REALM_MISMATCH`, `SNAPSHOT_*`, `NORMALIZER_UNSUPPORTED`, or proceed |
| 1 | Input bound | reject null/empty and input beyond bootstrap scalar/byte limit before expensive work | `INPUT_EMPTY`, `INPUT_TOO_LARGE` |
| 2 | Unicode scalar validation | reject unpaired surrogate, invalid UTF-16, noncharacter policy violations if configured, BOM at any position, C0/C1 control, DEL, U+2028/U+2029, tab, CR, LF | `INVALID_UNICODE`, `CONTROL_CHARACTER` |
| 3 | No recovery/trim | reject any leading/trailing Unicode whitespace; reject raw `\`; reject malformed `%` triplet anywhere | `LEADING_OR_TRAILING_SPACE`, `BACKSLASH_FORBIDDEN`, `PERCENT_ESCAPE_INVALID` |
| 4 | Absolute scheme gate | require ASCII scheme token followed by exact `://`; accept case-insensitive `http` or `https` only; canonicalize scheme lower-case | `SCHEME_SEPARATOR_INVALID`, `SCHEME_UNSUPPORTED` |
| 5 | Raw authority scan | isolate text before first `/`, `?`, or `#`; reject empty authority, any `@`, percent sign in authority, illegal bracket/colon layout, or embedded control | `AUTHORITY_MALFORMED`, `USERINFO_FORBIDDEN`, `PERCENT_IN_AUTHORITY` |
| 6 | Candidate parser | parse as absolute URL without base resolution using exact admitted runtime; require candidate scheme/authority boundaries to agree with strict scan | `PARSER_REJECTED`, `PARSER_DISAGREEMENT` |
| 7 | Host-type gate | reject empty host; reject IPv4/IPv6 and browser legacy numeric forms; reject IPv6 zone identifier | `HOST_EMPTY`, `IP_LITERAL_FORBIDDEN` |
| 8 | Trailing-dot/label structure | accept at most one terminal dot for a DNS FQDN and remove it for UAM comparison; reject multiple terminal dots, leading dot, empty interior label | `TRAILING_DOT_INVALID`, `DNS_LABEL_INVALID` |
| 9 | IDNA | UTS #46 non-transitional; Bidi/Joiner/hyphen checks on; STD3 ASCII rules on; unassigned disallowed; convert to ASCII A-label; lower-case ordinal; reject any reported error | `IDNA_INVALID` |
| 10 | IDNA/DNS postvalidation | round-trip A-label through independent validation profile; labels 1–63 ASCII octets; full canonical host <=253 octets without terminal dot; characters `[a-z0-9-]`; no leading/trailing hyphen except valid A-label rules | `IDNA_ROUNDTRIP_INVALID`, `DNS_LENGTH_INVALID`, `DNS_LABEL_INVALID` |
| 11 | Port | require decimal ASCII, range 0–65535; canonical default 80/443 to absent; non-default only under exact release-owned permission/rule | `PORT_INVALID`, `NON_DEFAULT_PORT_FORBIDDEN` |
| 12 | Local/special-use gate | reject single-label names, `localhost`, `.local`, and current pinned IANA special-use names/subdomains under first-slice conservative policy | `SPECIAL_USE_OR_LOCAL` |
| 13 | PSL structural derivation | use only pinned local digest and explicit mode; derive suffix/registrable domain for policy checks; no network/DNS; `UNKNOWN` is not “safe” | `REGISTRABLE_DOMAIN_UNAVAILABLE`, `PSL_VERSION_MISMATCH`, or derived facts |
| 14 | Component discard | do not decode or normalize path/query/fragment/title; discard references to them. They must not be copied, hashed, measured exactly, or logged | internal only; canary scan proves non-escape |
| 15 | Hard deny | evaluate product structural/category predicates then tenant-added narrowing; deny precedes allowlist/match and produces no application event | `HARD_DENY` |
| 16 | Rule evaluation | evaluate every same-realm active exact/suffix rule against canonical scheme/host/port; apply deterministic priority/family/specificity; never first-match | `MATCHED`, `AMBIGUOUS`, `UNMATCHED` |
| 17 | Output-policy gate | require approved output mode/fields/time/identity and permit; conservative default disables live event | `OUTPUT_NOT_APPROVED` or proceed |
| 18 | Minimize | construct new DTO with opaque IDs and approved site/time/identity reductions; never copy source object; never include raw/reversible derivative | minimized candidate |
| 19 | Final validation | closed schema, field allowlist, bounds, normalizer/PSL/snapshot/permit binding, value-free error type, canary guard | `OUTPUT_SCHEMA_INVALID`, `SAFETY_HOLD`, or serialized minimized result |
| 20 | Result | return minimized event and/or privacy-safe progress disposition; zero references and exit process promptly | Task Host result; no raw value crosses IPC |

### 3.3.1 Schemes and case

- Scheme comparison MUST be ASCII case-insensitive; output MUST use `http` or `https` lower-case.
- An input MUST contain the exact delimiter `://`. Forms such as `http:/x`, `http:x`, scheme-relative URLs, and relative URLs are rejected even if browser resolution could repair them.
- No base URL is supplied. File, FTP, WebSocket, custom, opaque, `data`, `javascript`, and shell schemes are outside the representable product ceiling.
- Host ASCII comparison is ordinal and case-insensitive during input, then lower-case in canonical output. Culture-sensitive casing is forbidden.

### 3.3.2 User information

Any `@` in the raw authority is rejected before parsing. UAM does not distinguish username from password because neither is permitted. It must not percent-decode authority text first. This prevents `user:secret@host`, encoded delimiters, and parser disagreement from turning credentials into a host-matching side effect.

### 3.3.3 Percent encoding and discarded components

- Every `%` in the input must be followed by two ASCII hexadecimal digits; otherwise reject.
- A percent sign in authority/host is always rejected, including values that a WHATWG parser may decode into an ordinary host character.
- UAM does not globally decode or re-encode the URL.
- For the first slice, path, query, and fragment are not normalized at all; they are intentionally discarded before output. `+` is never treated as a space.
- Encoded slash/backslash/dot segments therefore cannot influence host matching. If URL-path matching is later approved, it requires a separate ADR/profile and new golden/fuzz gates; this result does not define safe path semantics.

### 3.3.4 IDNA and Unicode

**RECOMMENDATION.** UAM normalization profile `uam-url-host-v1` uses UTS #46 non-transitional processing with Bidi, Joiner, hyphen, STD3, and DNS-length validation enabled. The exact Unicode data version is bound to the normalizer version. Unicode host input exists only inside Task Host memory. The only match representation is a lower-case ASCII A-label.

The implementation MUST:

1. reject invalid UTF-16 before any parser replacement behavior;
2. invoke the admitted IDNA implementation with fixed options, never caller-supplied options;
3. treat any warning/error bit as failure, not “best effort”;
4. validate fake/malformed `xn--` labels and perform a stable ASCII/Unicode/ASCII round-trip check with the pinned profile;
5. validate lengths after ASCII conversion;
6. bind the Unicode/UTS #46 data version into `normalizationVersion` and golden evidence;
7. never emit the Unicode source or Unicode display form;
8. display both A-label and a separately derived Unicode form only in an offline administrative rule-review UI, never from observed endpoint values, with explicit confusable warnings.

### 3.3.5 Trailing dots

UAM accepts exactly one terminal dot on an otherwise valid DNS name and removes it for matching, so `example.test` and `example.test.` are equivalent under `uam-url-host-v1`. Multiple terminal dots, a leading dot, or empty interior labels are rejected. This is a UAM versioned rule, not a claim that every DNS/PSL API treats the strings identically. Golden and cross-language vectors must lock the behavior.

### 3.3.6 Ports

- Parse the raw port as ASCII decimal only. Signs, whitespace, empty explicit ports, overflow, and non-decimal forms are rejected.
- `http:80` and `https:443` canonicalize to an absent port.
- An explicit non-default port remains semantically significant. It may match only an `EXACT` port rule expressly representable by the product ceiling. Until human/security approval and observed synthetic need, the default is to reject it.
- A rule that omits port cannot silently match a non-default port.

### 3.3.7 IP literals and local names

All IP-literal observations are suppressed for the first slice. This includes ordinary IPv4, IPv6, IPv4-in-IPv6, bracketed zone identifiers, and browser legacy numeric IPv4 forms such as shortened, octal, hexadecimal, or single-integer notation. The strict raw scanner, candidate parser host type, and an independent IP-literal detector must agree; disagreement fails closed.

Single-label names, `localhost`, `.local`, and names/subdomains in the pinned IANA Special-Use Domain Names registry are structurally suppressed by the conservative temporary policy. This does not decide the final hard-deny category list; it prevents accidental internal-address and local-service collection while that decision is absent.

### 3.3.8 Public suffix use

The PSL is a derived classification aid, not a security boundary, ownership registry, entitlement system, or complete list of sensitive domains. UAM MUST:

- package an exact PSL file and license notice with a SHA-256 digest;
- prohibit endpoint network update, auto-refresh, cache fallback, or silent substitution;
- identify `ICANN_ONLY`, `ICANN_AND_PRIVATE`, or `DISABLED` explicitly in the snapshot;
- bind list commit, digest, parser version, and section mode to the snapshot and output provenance;
- fail closed when the configured list is missing, corrupt, unsupported, or mismatched;
- keep exact/suffix rule matching DNS-label-boundary based and independent of PSL membership;
- treat PSL `UNKNOWN` as a reason to suppress output where registrable-domain proof is required.

**HUMAN DECISION.** Whether PRIVATE entries represent organizational/site boundaries for UAM remains unresolved. Temporary default: PRIVATE cannot authorize, broaden, or define output; exact-host application matching may operate synthetically, and all PSL-derived site output remains disabled. ICANN-only facts may be calculated only for tests and structural checks.

## 3.4 Hard-deny and application-rule evaluation

### 3.4.1 Evaluation order

1. structural rejects and special-use/IP suppression;
2. product hard-deny predicates;
3. tenant hard-deny additions/narrowing;
4. product allowability/output policy;
5. application-rule candidates;
6. priority/family/specificity maximal set;
7. ambiguity handling;
8. final output policy/minimization.

A tenant can add a deny, disable a rule, reduce schemes, restrict port, reduce output, or disable collection. It cannot remove a product deny, add a parser feature, enable a path/query/title, introduce a regex/script/destination, or change the normalizer/PSL bytes.

### 3.4.2 Rule grammar

```text
Rule URL_HOST_V1 {
  ruleId: UUIDv7                    # opaque, same realm
  applicationId: UUIDv7             # opaque, same realm
  state: ACTIVE
  schemes: non-empty subset {http, https}
  hostMode: EXACT | SUFFIX
  canonicalHost: lower-case ASCII A-label
  includeApex: bool                  # required for SUFFIX; ignored/rejected for EXACT
  portMode: DEFAULT_OR_OMITTED | EXACT
  exactPort: uint16?                 # required only for EXACT
  priority: bounded signed integer   # explicit, reviewed; not row order
  normalizationVersion: exact ID
}
```

Suffix matching is label-boundary matching only. A suffix `example.test` may match `a.example.test`; it never matches `badexample.test`. `includeApex=false` excludes `example.test` itself. Exact and suffix rules are statically comparable only where the closed grammar proves containment.

### 3.4.3 Deterministic ambiguity

After filtering by scheme/port and selecting maximum priority and fixed family authority, compute the maximal rules under the provable specificity partial order. If all maximal rules target one application, return that application and the selected opaque rule ID(s). If maximal rules target more than one application, return `AMBIGUOUS`, assign no application, emit no activity event, and create only a bounded value-free health count. Author order, database order, creation date, display name, external correlation ID, and lexicographic UUID are forbidden tie-breakers.

## 3.5 Field minimization, time reduction, and identity reduction

### 3.5.1 Output construction rule

The transformer MUST instantiate a new closed output type from approved primitives. It must never serialize, clone, reflect over, or “remove fields from” a source URL object. A compile-time architecture test must make raw-source types inaccessible to IPC/storage assemblies.

### 3.5.2 Candidate field classes

| Field class | First-slice status | Rule |
|---|---|---|
| raw URL/original string | **forbidden** | never leaves Task Host; never logged or hashed |
| userinfo/password | **forbidden** | reject source value |
| Unicode host/source spelling | **forbidden** | ASCII A-label only if approved |
| canonical full host | **HUMAN DECISION** | disabled until approved; exact allowlisted field only |
| registrable domain/site | **HUMAN DECISION** | disabled until approved; derived under pinned PSL mode |
| path/query/fragment/title/search term | **forbidden for first slice** | no parsing/output/hash/telemetry |
| application ID | proposed permitted | opaque same-realm UUIDv7 only after deterministic match |
| rule ID | endpoint provenance only if needed | opaque; do not expose in broad telemetry; HUMAN/contract decision for transport |
| observed time | **HUMAN DECISION** | floor in UTC to approved product/tenant precision; never round up/local time |
| subject/user identity | **HUMAN DECISION** | temporary default absent; raw SID/name/email forbidden |
| session/logon identity | local authorization only | never business payload authority |
| policy/snapshot/normalizer/PSL versions/digests | permitted provenance | fixed-size opaque values; no sensitive source content |
| source progress key | G3/G5 contract | opaque stable source fact, not raw database path or URL-derived key |
| rejection code/disposition | permitted | stable finite enum only; no source value |

### 3.5.3 Time reduction

Time reduction must occur inside the Task Host after the source timestamp has been validated and before serialization. The transformation is `floorUtc(sourceInstant, approvedPrecision)`; it never uses local time or daylight-saving transitions and never rounds to a future bucket. The precision is explicit in the contract. Random time jitter is not the default because it complicates stable event identity, replay, and aggregates; any future jitter requires a deterministic, privacy-reviewed, idempotent transform ADR.

**HUMAN DECISION.** Exact precision is not selected here. Conservative default: no production event. Once approved, use the coarsest product-permitted precision and let tenant policy narrow further.

### 3.5.4 Identity reduction

Raw username, email, SID, object GUID, authentication LUID, profile path, and session ID are forbidden in the event. They are not “made safe” by an unkeyed hash. Temporary default: no person identity field. If a business-approved subject relation is later required, it must be a separate realm-scoped, purpose-bound, revocable projection produced under an approved keyed mapping contract; the endpoint must not invent it from display data.

## 3.6 Rejected-value telemetry and observability

A rejected observation may produce only:

- a finite `reasonCode` and `reasonFamily`;
- an outcome/disposition;
- fixed input-length bucket (`0`, `1–64`, `65–256`, `257–1024`, `over-limit`) determined without logging exact length;
- fixed parser stage number;
- source family;
- normalizer major version;
- aggregate count and bounded latency/allocation bucket;
- optional opaque incident correlation generated independently of the source value.

It must not include the value, host, registrable domain, application/rule ID in broad metrics, exact length, character/code-point sample, exception message, stack data containing arguments, source row content, or any hash/HMAC/token derived from a forbidden value.

Metrics dimensions are limited to fixed enums: `component`, `source_family`, `outcome`, `reason_family`, `normalizer_major`, and `ring`. Realm, application, rule, device, user, session, host, PSL suffix, and exception type/name are not metric labels. Per-realm operational views, if required, are server-side access-controlled aggregates derived from authenticated custody, not endpoint metric labels.

**ESTIMATE.** The bootstrap implementation should expose fewer than 100 possible reason-code series combinations per component and refuse dynamic labels. This is a safety hypothesis, not an approved operations budget; E-G4-12 measures actual cardinality and the SRE/product owner sets the final budget.

## 3.7 Configuration ownership, feature flags, and kill switches

| Control | Owner/authority | May do | Must not do |
|---|---|---|---|
| product ceiling | release-authorized Product Privacy/Security | define available source, fields, transforms, rule grammar, normalizer, PSL modes, deny registry, destinations, diagnostics | be broadened by tenant or endpoint runtime |
| tenant policy | realm authority | disable/narrow fields, frequency, time precision, site mode, rules; add deny | introduce code, URL data, regex, new field/destination, weaker normalizer |
| rule snapshot | registry publication authority | provide approved same-realm finite predicates | carry display/governance metadata or observed values |
| release feature flag | release authority | disable source/Unicode-IDN/non-default-port/PRIVATE-PSL/site output or select an already authorized narrower mode | enable an unapproved source/field/matcher or bypass gate |
| emergency overlay | product or realm emergency authority | narrow/disable, force `SafetyHold`, revoke snapshot/version | broaden or silently expire without evidence |
| local safety switch | protected Coordinator state | stop new work on corruption, mismatch, canary, resource, or incident signal | re-enable itself without valid higher-revision authority/recovery evidence |

Required narrowing-only flags:

```text
DisableEdgeHistorySource
DisableUrlTransformation
DisableUnicodeIdnInput
RequireAsciiHostOnly
DisableNonDefaultPorts
DisablePslPrivateSection
RequireExactHostRuleOnly
EmitApplicationIdOnly
DisableSiteValueOutput
ForceSafetyHold
```

A flag transition that would broaden effective collection is a policy/release change, not an ordinary runtime toggle. Unknown flags fail closed.

## 3.8 Realm isolation

- Snapshot realm comes from verified artifact context; observation payload cannot claim or override it.
- Application/rule IDs are looked up only in the active same-realm snapshot.
- The Task Host result carries realm/installation binding digests only as permit-bound provenance; the Coordinator derives authoritative realm/device from its authenticated installation context.
- Cross-realm application IDs, rules, snapshots, permits, or cached PSL/normalizer artifacts fail before source access or serialization.
- Cache keys include realm plus snapshot/normalizer/PSL digest; no global mutable rule cache may return cross-realm objects.
- Fuzz/property tests generate identical UUIDs in different fictional realms and require isolation by realm context.

## 3.9 Data quality, accessibility, cost, licensing, skills, and operations

**Data quality.** `UNMATCHED`, `AMBIGUOUS`, `HARD_DENY`, invalid URL, and configuration-disabled are distinct outcomes. They are not silently converted to “unknown application.” Changes in normalizer or PSL can change match outcomes; version/digest provenance and dual-run synthetic comparison are required before activation. The catalogue aggregate cannot create rules or resolve ambiguity.

**Accessibility.** The endpoint has no user-facing rule UI. A future administrative rule-review UI should show canonical A-label and separately derived Unicode display form side by side; announce confusable/IDNA warnings in text, not color alone; support keyboard and screen-reader navigation; expose exact/suffix/include-apex/port semantics in plain language; and never display raw observed URLs as examples. Synthetic examples are used instead.

**Cost and skills.** The C# wrapper fits the accepted implementation family and avoids another native runtime. The cost is a large standards/fuzz test corpus and recurring Unicode/PSL/runtime review. Ada is a high-quality reference but a native C++ dependency would add ABI, installer, SBOM, signing, patch, crash, and C# interop obligations. A PSL library can reduce parsing work but must not add endpoint HTTP update behavior. Exact staffing and budget remain human decisions.

**Operations/support.** The endpoint runtime owner supports parser/transform incidents; Product Privacy owns deny/output policy; Application Registry owns rules/snapshot/PSL publication; Release Engineering owns pinned runtime/data artifacts; AppSec owns fuzz/canary/sink tests; SRE owns metric budget and alerts; Incident Response owns containment/forensic handling. Named people and support hours must be assigned before production.

---

# 4. Alternatives, rejection reasons, and conditions that would change the choice

| Alternative | Decision | Rejection/deferral reason | Condition that could change it |
|---|---|---|---|
| Send raw URL to User Host/Coordinator and minimize later | **REJECT** | directly violates accepted privacy boundary; expands process/log/storage/crash exposure | none without an explicit accepted-baseline change proposal and stronger evidence; not expected |
| Store or transmit SHA-256 of raw URL/host/path | **REJECT** | deterministic dictionary attacks and correlation; it is a reversible/practically enumerable derivative for common domains/paths and unnecessary for matching | only a separately approved purpose-specific cryptographic protocol proving non-reversibility and necessity; still cannot contain forbidden components by default |
| HMAC raw URL on endpoint | **REJECT FOR FIRST SLICE** | creates stable cross-event correlation and key-management surface; raw input still reaches crypto/logging paths; unnecessary when app ID/site value can be approved directly | a human-approved purpose, realm-scoped key lifecycle, unlinkability analysis, deletion semantics, and falsifying prototype |
| Use `System.Uri` output directly as canonical truth | **REJECT** | general-purpose/browser-influenced compatibility semantics differ from UAM strict profile; runtime versions can change behavior | never as sole authority; it remains a candidate parsing engine behind UAM gates/vectors |
| Use RFC 3986 textual normalization alone | **REJECT** | does not define browser host/IDNA behavior fully and can diverge from source URL interpretation | may inform lexical tests; not sufficient alone |
| Adopt full WHATWG recovery semantics | **REJECT** | silent trim, control stripping, backslash and legacy IP recovery are inappropriate at a privacy/security boundary | a bounded subset remains reference input; any accepted recovery requires explicit versioned rule and threat proof |
| Write a complete custom URL/IDNA/Punycode/PSL parser | **REJECT** | complex changing standards, Unicode security, resource hazards, and maintenance burden; high common-mode risk | all maintained candidates fail a documented requirement and an independent implementation passes full conformance/differential/fuzz/security/maintenance review |
| Embed Ada C++ as runtime dependency now | **DEFER / REFERENCE ONLY** | excellent tests/fuzz/security posture, but no maintained C# binding in reviewed release and material native/ABI/installer/SBOM cost | .NET candidate fails; exact native package/source mapping, C# interop, Windows lifecycle, reproducibility, crash, fuzz, license, and support gates pass |
| Use Rust URL via native/FFI | **DEFER / REFERENCE ONLY** | good independent WHATWG implementation, but adds Rust/native/FFI lifecycle and is not needed for the first C# slice | same trigger and evidence as Ada, plus stable C ABI/wrapper ownership |
| Use a PSL library with automatic HTTP refresh | **REJECT** | violates offline/reproducibility/authority design and can silently change matching | no runtime refresh; only a pinned-file provider may be admitted |
| Use DNS resolution, search suffixes, or network reputation | **REJECT** | privacy leak, offline failure, TOCTOU, enterprise DNS/proxy dependence, and not required for syntactic site mapping | a separately approved source/capability and privacy/security ADR; not part of G4 |
| Treat PSL as application allowlist or ownership proof | **REJECT** | PSL describes suffix boundaries for selected use cases, not business ownership/sensitivity/authorization | none; it may remain a derived classification input only |
| Use regex, glob, browser-filter grammar, or arbitrary policy engine | **REJECT** | hard to prove overlap/specificity/monotonicity; ReDoS and tenant-code risks | a closed new matcher family with finite semantics, static analyzer, privacy approval, and property proof—not general regex/script |
| First matching rule wins | **REJECT** | order becomes hidden authority and silently misattributes cross-application overlap | none; deterministic maximal-set ambiguity remains invariant |
| Fuzzy-match application/catalogue names | **REJECT** | I02 provides no identity/match authority; creates false attribution and role/purpose inference | governed registry reconciliation may propose human review, never endpoint matching |
| Enable path/query/title matching/output | **DEFER / COMPILED OFF** | much higher sensitivity; percent/dot-segment semantics and human approval unresolved | separate human approval, product-ceiling update, ADR, new normalizer, hard-deny model, million-case corpus, and G4 re-gate |
| Emit unmatched canonical domains for later central matching | **REJECT** | exports unapproved browsing/site data and moves privacy decision centrally | an approved site-output purpose/field and matching design; first slice remains endpoint-matched only |
| Drop invalid/unmatched rows without progress fact | **REJECT** | creates endless rereads or silent data loss; G5 cursor invariant needs typed durable disposition | G4 returns value-free disposition; G5 proves atomic persistence |


---

# 5. Interfaces/protocols and example contracts or schemas; normative where possible

## 5.1 Contract principles

Every G4 boundary contract MUST be closed, versioned, bounded, same-realm, and privacy-stage annotated. Unknown members, duplicate members, wrong case, invalid UTF-8, remote schema references, and implicit defaults are rejected under the Batch 01 contract profile. Runtime code must use pinned local schema bundles.

G4 defines four logical types:

1. `SourceObservationView` — in-process Task Host view; **never serializable**;
2. `CanonicalUrlHostV1` — in-process normalized result; **never serializable outside Task Host** unless an approved site field specifically copies one allowed value;
3. `MinimizedUrlEventV1` — allowed Task Host result after all policy/matching/minimization checks;
4. `UrlObservationDispositionV1` — value-free rejection/progress result.

The Task Host result envelope is a discriminated union with exactly one of `event` or `disposition`. The serializer has no type registration for `SourceObservationView`, raw `Uri`, parser exception, or canonicalization scratch types.

## 5.2 In-process source contract

This is a conceptual C# contract, not an IPC schema:

```csharp
internal readonly ref struct SourceObservationView
{
    // Stable source facts come from G3. Raw URL is never an identity key.
    public required ReadOnlySpan<char> RawUrl { get; init; }
    public required UuidV7 SourceOccurrenceId { get; init; }
    public required Instant SourceObservedAt { get; init; }
    public required TimePrecision SourceTimePrecision { get; init; }
    public required SourceProgressToken ProgressAfter { get; init; }
}
```

Normative constraints:

- `RawUrl` MUST NOT be exposed through `ToString`, debugger display, equality/hash, telemetry, exception data, or object properties.
- `SourceOccurrenceId` MUST be stable across retry according to the accepted G3/G5 identity contract and MUST NOT be derived from the raw URL.
- `ProgressAfter` MUST be opaque to G4 and MUST NOT embed the raw URL, profile path, SQL, or database filename.
- The source adapter MUST supply a bounded span. An oversized input is rejected before materializing another copy.

## 5.3 Canonical in-process result

```csharp
internal readonly record struct CanonicalUrlHostV1(
    HttpScheme Scheme,               // Http | Https
    AsciiDnsName Host,               // lower-case A-label, no terminal dot
    CanonicalPort Port,              // None or explicit non-default
    RegistrableDomainFact PslFact,   // derived under exact digest/mode
    NormalizationVersion Version,
    bool InputHadSingleTrailingDot);
```

`InputHadSingleTrailingDot` is diagnostic state inside the Task Host only and MUST NOT be emitted. `AsciiDnsName` is a validated type whose constructor is internal to the normalizer. No ordinary `string` can be implicitly converted to it.

## 5.4 Task Host result envelope

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "urn:uam:contract:task-host-url-result:1.0.0",
  "title": "TaskHostUrlResultV1",
  "type": "object",
  "required": ["schemaVersion", "permitId", "sourceOccurrenceId", "result"],
  "properties": {
    "schemaVersion": { "const": "1.0.0" },
    "permitId": { "$ref": "urn:uam:scalar:uuidv7" },
    "sourceOccurrenceId": { "$ref": "urn:uam:scalar:uuidv7" },
    "result": {
      "oneOf": [
        { "$ref": "urn:uam:contract:minimized-url-event:1.0.0" },
        { "$ref": "urn:uam:contract:url-observation-disposition:1.0.0" }
      ]
    }
  },
  "unevaluatedProperties": false
}
```

The envelope does not carry authoritative realm, device, user, or session claims. `permitId` is validated against the authenticated G1 channel and active one-use permit.

## 5.5 Minimized output schema

The schema below is normative in shape but leaves the human-controlled field profile explicit. A production policy MUST select one approved `siteMode`; until then `NONE` is the only enabled mode and no event is produced.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "urn:uam:contract:minimized-url-event:1.0.0",
  "title": "MinimizedUrlEventV1",
  "type": "object",
  "required": [
    "kind",
    "eventId",
    "applicationId",
    "sourceFamily",
    "observedBucketStartUtc",
    "timePrecision",
    "siteMode",
    "provenance",
    "progressAfter"
  ],
  "properties": {
    "kind": { "const": "MINIMIZED_URL_EVENT" },
    "eventId": { "$ref": "urn:uam:scalar:uuidv7" },
    "applicationId": { "$ref": "urn:uam:scalar:uuidv7" },
    "sourceFamily": { "const": "EDGE_HISTORY" },
    "observedBucketStartUtc": { "$ref": "urn:uam:scalar:utc-instant" },
    "timePrecision": {
      "enum": ["MINUTE", "FIFTEEN_MINUTES", "HOUR", "DAY"]
    },
    "siteMode": {
      "enum": ["APPLICATION_ID_ONLY", "CANONICAL_HOST", "REGISTRABLE_DOMAIN"]
    },
    "siteValue": {
      "type": "string",
      "minLength": 1,
      "maxLength": 253,
      "pattern": "^(?=.{1,253}$)(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?)(?:\\.(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?))*$"
    },
    "provenance": {
      "type": "object",
      "required": [
        "productCeilingDigest",
        "tenantPolicyDigest",
        "ruleSnapshotDigest",
        "normalizationVersion",
        "pslDigest",
        "pslMode",
        "transformVersion",
        "outputSchemaVersion"
      ],
      "properties": {
        "productCeilingDigest": { "$ref": "urn:uam:scalar:sha256" },
        "tenantPolicyDigest": { "$ref": "urn:uam:scalar:sha256" },
        "ruleSnapshotDigest": { "$ref": "urn:uam:scalar:sha256" },
        "normalizationVersion": { "const": "uam-url-host-v1" },
        "pslDigest": { "$ref": "urn:uam:scalar:sha256" },
        "pslMode": { "enum": ["ICANN_ONLY", "ICANN_AND_PRIVATE", "DISABLED"] },
        "transformVersion": { "const": "uam-url-privacy-v1" },
        "outputSchemaVersion": { "const": "1.0.0" }
      },
      "unevaluatedProperties": false
    },
    "progressAfter": { "$ref": "urn:uam:scalar:source-progress-token" }
  },
  "allOf": [
    {
      "if": { "properties": { "siteMode": { "const": "APPLICATION_ID_ONLY" } } },
      "then": { "not": { "required": ["siteValue"] } }
    },
    {
      "if": {
        "properties": {
          "siteMode": { "enum": ["CANONICAL_HOST", "REGISTRABLE_DOMAIN"] }
        }
      },
      "then": { "required": ["siteValue"] }
    }
  ],
  "unevaluatedProperties": false
}
```

Normative corrections and caveats:

- `eventId` is generated/persisted under the stable event-identity contract; retry MUST reproduce the same logical identity and final business effect. It is not computed from the URL.
- The allowed precision enum is illustrative of a finite product ceiling, not approval of any member. A human decision may remove values or choose a different finite set through a contract revision.
- `siteValue` is absent in `APPLICATION_ID_ONLY` mode. It is never empty, Unicode, a URL, or an IP literal.
- `ruleId` is intentionally absent from this first public event contract. It may remain in protected endpoint provenance/audit only if a later contract owner proves the need and access controls.
- Subject/person identity is intentionally absent.
- `progressAfter` is committed atomically with the event or approved no-event progress by G5; this schema alone does not prove durability.

## 5.6 Rejection and progress schema

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "urn:uam:contract:url-observation-disposition:1.0.0",
  "title": "UrlObservationDispositionV1",
  "type": "object",
  "required": [
    "kind",
    "disposition",
    "reasonCode",
    "reasonFamily",
    "inputSizeBucket"
  ],
  "properties": {
    "kind": { "const": "URL_OBSERVATION_DISPOSITION" },
    "disposition": {
      "enum": [
        "CONSUMED_NO_EVENT",
        "DEFER_CONFIGURATION",
        "RETRY_TRANSIENT",
        "SAFETY_HOLD"
      ]
    },
    "reasonCode": {
      "enum": [
        "INPUT_EMPTY",
        "INPUT_TOO_LARGE",
        "INVALID_UNICODE",
        "CONTROL_CHARACTER",
        "LEADING_OR_TRAILING_SPACE",
        "BACKSLASH_FORBIDDEN",
        "PERCENT_ESCAPE_INVALID",
        "SCHEME_SEPARATOR_INVALID",
        "SCHEME_UNSUPPORTED",
        "USERINFO_FORBIDDEN",
        "AUTHORITY_MALFORMED",
        "PERCENT_IN_AUTHORITY",
        "PARSER_REJECTED",
        "PARSER_DISAGREEMENT",
        "HOST_EMPTY",
        "IP_LITERAL_FORBIDDEN",
        "TRAILING_DOT_INVALID",
        "DNS_LABEL_INVALID",
        "IDNA_INVALID",
        "IDNA_ROUNDTRIP_INVALID",
        "DNS_LENGTH_INVALID",
        "PORT_INVALID",
        "NON_DEFAULT_PORT_FORBIDDEN",
        "SPECIAL_USE_OR_LOCAL",
        "REGISTRABLE_DOMAIN_UNAVAILABLE",
        "HARD_DENY",
        "UNMATCHED",
        "AMBIGUOUS",
        "OUTPUT_NOT_APPROVED",
        "POLICY_DISABLED",
        "REALM_MISMATCH",
        "SNAPSHOT_STALE",
        "SNAPSHOT_INVALID",
        "NORMALIZER_UNSUPPORTED",
        "PSL_VERSION_MISMATCH",
        "OUTPUT_SCHEMA_INVALID",
        "RESOURCE_LIMIT",
        "INTERNAL_TRANSIENT",
        "SAFETY_HOLD"
      ]
    },
    "reasonFamily": {
      "enum": [
        "INPUT",
        "SYNTAX",
        "HOST",
        "IDNA",
        "PORT",
        "STRUCTURAL_PRIVACY",
        "POLICY",
        "MATCHING",
        "CONFIGURATION",
        "RESOURCE",
        "INTERNAL"
      ]
    },
    "inputSizeBucket": {
      "enum": ["ZERO", "ONE_TO_64", "65_TO_256", "257_TO_1024", "OVER_LIMIT"]
    },
    "parserStage": { "type": "integer", "minimum": 0, "maximum": 20 },
    "progressAfter": { "$ref": "urn:uam:scalar:source-progress-token" },
    "retryAfterClass": { "enum": ["NONE", "SHORT_LOCAL", "AFTER_CONFIG_REFRESH"] }
  },
  "unevaluatedProperties": false
}
```

There is deliberately no `message`, `detail`, `invalidValue`, `host`, `url`, `exception`, `stackTrace`, exact `inputLength`, `applicationId`, or `ruleId` field.

## 5.7 Error-to-disposition mapping

| Condition class | Disposition | May G5 advance progress? | Operational response |
|---|---|---:|---|
| permanently invalid syntax, IP/local/special-use suppression, approved hard deny, unmatched, ambiguous | `CONSUMED_NO_EVENT` | yes, but only atomically with the durable progress fact and only after policy says the condition is final for that snapshot/version | aggregate bounded counter; no value |
| output not approved, missing/unsupported normalizer/PSL/snapshot, ordinary compatible config absence | `DEFER_CONFIGURATION` | no | refresh valid artifacts; bounded retry/backoff outside G4 |
| bounded temporary parser/runtime/resource failure with intact safety state | `RETRY_TRANSIENT` | no | retry under G5/run budget; escalate on threshold |
| realm mismatch, artifact digest conflict, canary escape, output schema violation, parser reference contradiction on a golden security case, corruption or impossible invariant | `SAFETY_HOLD` | no | stop source; preserve value-free evidence; incident/recovery authorization required |

A permanent syntactic reject can advance progress only because re-reading the same fixed row under the same normalizer will not create an event. A normalizer or rule-snapshot upgrade may alter behavior, so G3/G5 must record the interpretation/version relation and must not silently replay old rows under new semantics unless an approved migration explicitly requests it.

## 5.8 Rule snapshot contract fragment

```json
{
  "snapshotVersion": "1.0.0",
  "snapshotId": "018f0000-0000-7000-8000-000000000001",
  "sequence": 42,
  "realmBindingDigest": "sha256:<64-lower-hex>",
  "normalizationVersion": "uam-url-host-v1",
  "psl": {
    "commit": "e1b8015c3b2f0f4f8c18659c2480fc1a22c07b20",
    "digest": "sha256:<64-lower-hex>",
    "mode": "ICANN_ONLY"
  },
  "productCeilingDigest": "sha256:<64-lower-hex>",
  "ruleSetDigest": "sha256:<64-lower-hex>",
  "notBeforeUtc": "2026-07-31T00:00:00Z",
  "hardExpiryUtc": "2026-08-31T00:00:00Z",
  "rules": [
    {
      "ruleId": "018f0000-0000-7000-8000-000000000010",
      "applicationId": "018f0000-0000-7000-8000-000000000020",
      "schemes": ["https"],
      "hostMode": "EXACT",
      "canonicalHost": "portal.fictional-example.test",
      "portMode": "DEFAULT_OR_OMITTED",
      "priority": 100
    }
  ]
}
```

This is fictional and illustrative. The real schema MUST use closed objects, exact UUIDv7 validation, bounded arrays, canonical digest syntax, signed/authorized artifact rules, and no `.test` assumption outside T1 fixtures. Snapshot examples must not contain internal or production domains.

## 5.9 Normative rule-evaluation pseudocode/state flow

```text
function TransformObservation(obs, permit, snapshot, productCeiling, tenantPolicy, runtime): Result
    require runtime.killSwitch == OFF
    require permit.isOneUseAndUnspent()
    require authenticatedContext.matches(permit.sessionBinding)
    require authenticatedContext.realmDigest == snapshot.realmBindingDigest
    require snapshot.sequence >= activeMinimumSequence
    require now within permit and snapshot authority windows
    require digests/versions exactly match permit

    effective = Meet(productCeiling, tenantPolicy, runtime.localNarrowing)
    if effective is invalid or cannot prove effective <= productCeiling:
        return SafetyHold(CONFIGURATION_INVARIANT)
    if source/transform/output are disabled:
        return Defer(POLICY_DISABLED)

    // Raw value exists only below this line inside Task Host memory.
    lexical = StrictLexicalGate(obs.RawUrl, effective.inputLimits)
    if lexical.reject:
        return PermanentOrSafetyDisposition(lexical.reason, obs.ProgressAfter)

    parsed = CandidateParser.ParseAbsolute(lexical.input)
    if parsed.reject:
        return ConsumedNoEvent(PARSER_REJECTED, obs.ProgressAfter)
    if not ParserAgreesWithLexicalBoundaries(parsed, lexical):
        return SafetyHold(PARSER_DISAGREEMENT)

    canonical = CanonicalizeHostPort(parsed, lexical, snapshot.normalizationVersion)
    if canonical.reject:
        return PermanentOrSafetyDisposition(canonical.reason, obs.ProgressAfter)

    if IsIpLiteralOrLegacyNumericHost(canonical, lexical):
        return ConsumedNoEvent(IP_LITERAL_FORBIDDEN, obs.ProgressAfter)
    if IsLocalOrPinnedSpecialUse(canonical.host):
        return ConsumedNoEvent(SPECIAL_USE_OR_LOCAL, obs.ProgressAfter)

    pslFact = PinnedPsl.Classify(canonical.host, snapshot.psl)
    if effective.requiresRegistrableDomain and pslFact is not proved:
        return ConsumedNoEvent(REGISTRABLE_DOMAIN_UNAVAILABLE, obs.ProgressAfter)

    if ProductHardDeny.Matches(canonical, pslFact, effective):
        return ConsumedNoEvent(HARD_DENY, obs.ProgressAfter)
    if TenantAdditionalDeny.Matches(canonical, pslFact, effective):
        return ConsumedNoEvent(HARD_DENY, obs.ProgressAfter)

    candidates = []
    for rule in snapshot.rules:
        require rule.realm implicit from snapshot
        if RuleMatches(rule, canonical):
            candidates.add(rule)

    if candidates.empty:
        return ConsumedNoEvent(UNMATCHED, obs.ProgressAfter)

    candidates = KeepMaximumPriority(candidates)
    candidates = KeepMaximumFamilyAuthority(candidates)
    maximal = MaximalUnderProvableSpecificity(candidates)
    targetApps = Distinct(maximal.applicationId)

    if targetApps.count != 1:
        return ConsumedNoEvent(AMBIGUOUS, obs.ProgressAfter)

    outputProfile = effective.outputProfile
    if not outputProfile.humanApproved:
        return Defer(OUTPUT_NOT_APPROVED)

    event = new MinimizedUrlEventV1()
    event.eventId = StableEventIdentity(obs.SourceOccurrenceId, approvedContractContext)
    event.applicationId = targetApps.single
    event.sourceFamily = EDGE_HISTORY
    event.observedBucketStartUtc = FloorUtc(obs.SourceObservedAt, outputProfile.timePrecision)
    event.timePrecision = outputProfile.timePrecision
    event.siteMode = outputProfile.siteMode
    if siteMode == CANONICAL_HOST:
        event.siteValue = canonical.host
    else if siteMode == REGISTRABLE_DOMAIN:
        event.siteValue = pslFact.registrableDomain
    event.provenance = ExactActiveDigestsAndVersions()
    event.progressAfter = obs.ProgressAfter

    require event contains no source/raw/Unicode/path/query/fragment/title/person fields
    require ClosedSchemaValidate(event)
    require PermitAllowsEveryField(event)
    require CanaryGuard.NoForbiddenMarker(event.serializedBytes)

    permit.markSpent()
    DropAllRawReferences()
    return event
```

`StableEventIdentity` is a call to the accepted identity contract, not a URL hash. It must be deterministic across retry and independently tested; exact ownership belongs to the G3/G5 contract.

## 5.10 Secure coding and review rules

1. The raw source namespace/project MUST NOT be referenced by IPC, Coordinator, storage, logging, or transport projects; architecture tests mutate this boundary.
2. Methods that can see `RawUrl` MUST be marked and code-owned by Endpoint Privacy/AppSec reviewers.
3. No interpolation, `ToString`, anonymous-object logging, destructuring, exception `Data`, debugger proxy, or activity tag may accept raw/canonical scratch types.
4. Catch blocks at the raw boundary emit a fixed code chosen from exception type/state without including exception message or input. Unexpected exceptions trigger `INTERNAL_TRANSIENT` or `SAFETY_HOLD` under a fixed mapping.
5. Regex is prohibited in runtime URL parsing/matching. Schema regex is applied only to already-minimized bounded ASCII values.
6. All string comparison and casing in the matcher are explicit ordinal/ASCII operations.
7. Bounds are checked before allocation. Loops are linear in input/labels/rules or have a documented tighter bound.
8. Public-suffix and snapshot files are verified by length, digest, schema, version, and authorization before parsing; parse into immutable structures off the active path.
9. Static analyzers include forbidden API/type rules and taint-style source-to-sink checks; dynamic canaries remain mandatory because static tools are not proof.
10. Two reviewers are required for changes to normalization vectors, deny order, output field allowlist, or sink guard; one must be the privacy/security owner function.

---

# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility rules

## 6.1 Observation transformation state machine

```text
CREATED
  -> AUTHORITY_VALIDATING
      -> DEFER_CONFIGURATION
      -> SAFETY_HOLD
      -> RAW_BOUNDARY_ENTERED
  -> LEXICAL_VALIDATING
      -> CONSUMED_NO_EVENT
      -> CANONICALIZING
  -> CANONICALIZING
      -> CONSUMED_NO_EVENT
      -> SAFETY_HOLD              # impossible disagreement/invariant
      -> STRUCTURAL_PRIVACY_CHECK
  -> STRUCTURAL_PRIVACY_CHECK
      -> CONSUMED_NO_EVENT
      -> HARD_DENY_CHECK
  -> HARD_DENY_CHECK
      -> CONSUMED_NO_EVENT
      -> MATCHING
  -> MATCHING
      -> CONSUMED_NO_EVENT        # unmatched/ambiguous
      -> OUTPUT_POLICY_CHECK
  -> OUTPUT_POLICY_CHECK
      -> DEFER_CONFIGURATION
      -> MINIMIZING
  -> MINIMIZING
      -> SAFETY_HOLD              # schema/canary/permit violation
      -> MINIMIZED_READY
  -> MINIMIZED_READY
      -> SERIALIZED
      -> RAW_REFERENCES_DROPPED
      -> RETURNED
```

No transition returns from `RAW_REFERENCES_DROPPED` to a raw state. The Task Host exits after its bounded page/run. Cancellation before `MINIMIZED_READY` yields no event and no progress advancement. Cancellation after a result is prepared but before G5 commit causes the same source occurrence to retry with the same stable event identity.

## 6.2 Rule snapshot lifecycle

```text
BUILDING
  -> STATIC_ANALYSIS_FAILED
  -> VALIDATED
  -> HUMAN_REVIEW_REQUIRED
  -> APPROVED
  -> AUTHORIZED/SIGNED
  -> PUBLISHED
  -> CANDIDATE_ON_ENDPOINT
      -> REJECTED_WRONG_REALM/VERSION/DIGEST/SEQUENCE
      -> VERIFIED_PENDING
      -> ACTIVE
  -> SUPERSEDED
  -> REVOKED
```

- A content change invalidates validation, human review, approval, and authorization.
- Rollback republishes prior approved semantics at a higher sequence and new artifact digest.
- Current and previous verified snapshots may be retained for crash-safe activation; no lower sequence can become active.
- An unsupported normalization or PSL version does not activate partially. It leaves a valid unexpired active snapshot in place unless the failure indicates compromise; compromise enters `SafetyHold` per Batch 01.
- Hard expiry disables work; no implicit indefinite offline grace is created by this result.

## 6.3 Normalizer and PSL compatibility lifecycle

A `normalizationVersion` is a semantic contract, not an assembly version. It binds:

- lexical rejection rules;
- candidate runtime and exact patch evidence;
- Unicode/UTS #46 profile and data version;
- trailing-dot rule;
- IP/legacy numeric detection;
- port normalization;
- special-use registry snapshot;
- PSL parser semantics and pinned digest/mode;
- golden/cross-language corpus root digest;
- error-code mapping.

Compatibility rules:

1. A patch that changes any accepted/rejected input, canonical host, port, PSL fact, reason code, or resource behavior is a normalizer semantic change and requires a new version or explicit proven-compatible patch record.
2. A snapshot can reference only a normalizer/PSL pair supported by the installed release.
3. Producers (snapshot compiler) deploy after consumers (endpoint normalizer) support the new version.
4. Rollout uses synthetic dual evaluation: old and new normalizers run offline against the same corpus; no raw production URL is duplicated for comparison.
5. During a staged endpoint ring, one observation is evaluated by exactly one active normalizer. The endpoint does not emit two business events for comparison.
6. A normalizer change does not automatically reinterpret historical rows. Replay/reprocessing semantics require G3/G5 owner approval and stable identity analysis.
7. Removal requires fleet-version evidence, rollback evidence, no active snapshot reference, support-owner approval, and a higher-revision policy.

## 6.4 Transaction boundary with G5

G4 is pure with respect to durable endpoint state. It returns either:

- `MinimizedUrlEventV1 + progressAfter`; or
- an approved durable `CONSUMED_NO_EVENT + progressAfter`; or
- a non-consumable defer/retry/hold without `progressAfter` authorization.

G5 MUST commit the minimized event (if any), the no-event progress fact/reason class (if policy permits), stable identity/dedupe state, and source cursor/progress atomically in the one-writer SQLite transaction. G4 must never advance a cursor, write a checkpoint, acknowledge a source row, or delete source data. A Task Host/User Host ACK occurs only after the Coordinator reports the G5 commit outcome.

## 6.5 Run/page lifecycle

1. Coordinator issues a bounded `RunIntent` tied to source generation/cursor epoch and active digests.
2. User Host independently validates session/policy and issues one-use `CollectionPermit`.
3. Task Host starts suspended/restricted/job-bound under G1, loads immutable snapshot/PSL by verified handles or bytes, and validates the permit.
4. It processes a bounded page under input/count/time/allocation limits.
5. It returns only minimized events/dispositions plus page provenance; no raw values.
6. User Host validates and sends the minimized page to Coordinator.
7. Coordinator/G5 atomically commits and returns stable ACK.
8. Task Host/User Host drop page buffers; Task Host exits; retry uses the same source occurrence identities.

Policy narrowing, snapshot revocation, session lock/disconnect, kill switch, resource limit, or canary signal cancels outstanding work. Results prepared under a digest that is no longer authorized are discarded without cursor advance.

## 6.6 Rollout rings and feature controls

**RECOMMENDATION.** Use the repository’s ordinary release rings, with a G4-specific sequence:

1. pure unit/golden/reference vector lane;
2. million-case deterministic fuzz lane;
3. synthetic single-process transform lane;
4. synthetic Task Host sink-scan lane;
5. synthetic full Task Host → User Host → Coordinator → SQLite/log/network-capture lane on disposable Windows VM;
6. disabled production-shaped code deployment (`DisableUrlTransformation=true`);
7. fictional lab source enablement;
8. only after all human decisions and later release gates, a separately approved limited pilot.

A rollout ring may only narrow compared with the signed product ceiling. Emergency rollback is same-digest release rollback plus higher-sequence control artifacts; it never re-enables fields or matcher families absent in the target release.

## 6.7 Failure cleanup and recovery lifecycle

| Failure | Immediate containment | Recovery | Cleanup/evidence |
|---|---|---|---|
| parser/IDNA exception | terminate current observation; fixed code; bounded retry or consume according to map | reproduce with synthetic/minimized vector; patch normalizer under new evidence | scan logs/dumps/sinks; no raw value retained |
| parser disagreement | source kill switch / `SafetyHold` for affected normalizer | add minimal synthetic reproducer; independent review; new normalizer version | invalidate candidate evidence; retain value-free digest of test vector only |
| invalid/wrong-realm snapshot | no source access or stop run | fetch verified higher-sequence artifact; investigate publication | delete candidate artifact; preserve digest/reason/audit |
| canary escape | stop G4 source across affected ring; treat as privacy incident candidate | locate sink, patch, rerun complete all-sink suite and neighboring encodings | remove contaminated artifacts under retention/incident authority; document deletion limits |
| resource exhaustion | kill Task Host tree; no progress advance | reduce page/input bounds or fix complexity; rerun adversarial corpus | verify no orphan process/file/dump; bounded metrics only |
| PSL corruption/mismatch | disable work needing PSL; keep no silent fallback | reinstall same authorized digest or higher-version artifact | remove corrupt file; record digest mismatch, not contents |
| rule ambiguity spike | no event assignment; optionally stop snapshot if threshold indicates publication defect | publish corrected higher-sequence snapshot after analysis/review | preserve fictional witness and aggregate counts; no observed domain |
| output schema violation | `SafetyHold`; no IPC/storage | code/config rollback; contract compatibility investigation | scan all sinks; prove no invalid output crossed boundary |


---

# 7. Security/privacy threat and failure register: trigger, detection, containment, recovery, cleanup, owner, test, residual risk

## 7.1 Register conventions

This register treats parser disagreement, privacy escape, realm confusion, and unauthorized broadening as security events rather than ordinary bad input. “Owner” names an accountable function; it does not claim that a person or team has been assigned. A row is not closed by documentation alone: its named test and recovery evidence must exist.

| ID | Threat or failure | Trigger / attack | Detection | Immediate containment | Recovery | Cleanup and durable evidence | Owner function | Required test | Residual risk |
|---|---|---|---|---|---|---|---|---|---|
| G4-T01 | browser-style whitespace recovery changes authority | leading/trailing space, tab, CR/LF, C0 character, or Unicode line separator around or inside a URL | strict lexical gate reason code; differential vector against WHATWG/.NET candidate | reject observation before parser; no progress decision until disposition contract applies | add minimal synthetic vector; patch only under new normalizer evidence | value-free stage/reason count; scan every sink; retain vector in T1 corpus, not source value | Endpoint Security | V-LEX-01, FZ-LEX | future runtimes may add other recovery behavior; strict pre-scan must remain independent |
| G4-T02 | malformed scheme accepted through recovery or base resolution | `http:/`, missing `//`, relative URL, drive-like text, opaque URL | exact `scheme://` scan and candidate-boundary comparison | reject; never call base-relative parser | update strict scanner/vector if a new candidate behavior is observed | parser/runtime identity and synthetic reproducer | URL Profile owner | V-LEX-02, DIFF-01 | parser APIs may expose alternate constructors that bypass the wrapper |
| G4-T03 | userinfo hides true host or leaks credentials | `user:password@host`, multiple `@`, encoded delimiter | raw authority scan finds any `@`; post-parse assertion confirms no userinfo | reject before IDNA/match | no permissive recovery; source remains consumed/deferred only per approved disposition | no username/password in errors; exact canary sink scan | Privacy Engineering | V-AUTH-01, CAN-USERINFO | source process memory may still contain the original browser row |
| G4-T04 | percent-encoded authority delimiter or host creates parser disagreement | `%40`, `%2f`, `%5c`, invalid triplets, encoded dot in authority | raw percent-in-authority gate; malformed-triplet gate; differential parser result | reject before host normalization | add corpus case and, if needed, parser candidate quarantine | value-free reason and normalizer version | URL Profile owner | V-AUTH-02, FZ-PCT | future parser versions may reinterpret escape handling |
| G4-T05 | backslash is treated as slash by special-URL parser | raw `\` in authority/path or mixed separators | independent raw scan before parser | reject entire input; do not normalize | retain strict rule; no browser-equivalence exception | sink scan for source canary; synthetic vector only | Endpoint Security | V-LEX-03, DIFF-02 | a caller could accidentally pre-normalize before the wrapper; architecture test must prevent it |
| G4-T06 | invalid UTF-16 or surrogate causes exception, replacement, or divergent host | unpaired surrogate, ill-formed source string, replacement performed upstream | scalar validator and exception boundary; source adapter contract test | reject/terminate observation; kill Task Host if runtime invariant is uncertain | correct adapter; add exact code-unit vector | no exception argument; dump/WER scan and sanitized crash evidence | Runtime owner | V-UNI-01, CRASH-01 | .NET strings can contain unpaired surrogates; upstream APIs may already replace data |
| G4-T07 | Unicode compatibility mapping broadens a host unexpectedly | width forms, full-stop variants, case mapping, deviation characters such as `ß` | UTS #46 reference vectors plus independent IDNA runner; normalizer-version diff | use fixed non-transitional profile; reject any error; optionally disable Unicode input | new semantic version if mapping/data changes | record Unicode/IDNA data version and vector root; never original observed host | Internationalization/Security | IDNA-01, DIFF-IDNA | Unicode data updates can change edge cases; confusables are not eliminated by IDNA |
| G4-T08 | Bidi or Joiner violation creates misleading A-label | RTL labels, invalid contextual joiner, mixed directionality | UTS #46/IDNA2008 Bidi and Joiner checks; cross-implementation vectors | reject before rule evaluation | patch adapter/profile; disable Unicode IDN feature if systemic | retain code-point-only synthetic reproducer, not production value | Internationalization/Security | IDNA-02 | valid RTL domains can still be visually deceptive in admin UI |
| G4-T09 | malformed or fake A-label passes as ordinary ASCII | bad `xn--` prefix, impossible punycode, non-round-tripping A-label | ToUnicode/ToASCII round-trip and A-label validation | reject | repair IDNA adapter; invalidate normalizer candidate | reason code and test-vector digest | URL Profile owner | IDNA-03 | independent implementations may disagree on invalid edge cases; disagreement fails closed |
| G4-T10 | trailing dot or empty-label ambiguity changes match | one or multiple terminal dots, leading dot, `a..b`, Unicode dot mapping | pre/post-IDNA label-structure checks; canonical vector | remove exactly one terminal dot after validation; reject other empty labels | semantic-version change only if rule changes | store canonical expected vector and reason; no observed value | URL Profile owner | V-DNS-01 | upstream parser may remove dots first; raw scan/candidate comparison must catch disagreement |
| G4-T11 | legacy numeric IPv4 bypasses IP deny | decimal integer, hex/octal components, shortened forms such as `127.1` | dedicated legacy-numeric recognizer plus WHATWG/Ada/.NET differential corpus | reject as `IP_LITERAL_FORBIDDEN` even if candidate returns DNS text | expand recognizer from minimized synthetic counterexample | value-free count; retain vector corpus | Endpoint Security | V-IP-01, FZ-IP | complete legacy syntax is easy to implement incorrectly; cross-reference runners are mandatory |
| G4-T12 | IPv6 or zone identifier leaks local topology | bracketed literal, IPv4-mapped IPv6, `%25zone`, malformed brackets | strict authority grammar and IP parser/reference checks | reject before output/match | fix scanner/parser; disable source if bypass found | canary in zone and literal scanned from all sinks | Endpoint Security | V-IP-02, CAN-IP | a DNS name may still resolve to local addresses; UAM deliberately performs no DNS lookup |
| G4-T13 | port normalization erases meaningful distinction | explicit default, leading sign/zeros, empty port, overflow, non-default port | raw authority port scanner plus parsed-port assertion | canonicalize only exact default; reject malformed; default profile rejects non-default | authorize exact non-default behavior only through release-owned rule/version | vector and policy/snapshot digest; no source value | URL Profile / Registry | V-PORT-01, RULE-PORT | services behind default ports can still differ by path, which first slice intentionally ignores |
| G4-T14 | local or special-use name is treated as ordinary site | single label, `localhost`, `.local`, IANA special-use name/subdomain | pinned structural registry and deterministic predicate | suppress before hard-deny/allowlist; no event | update pinned registry under release review; no network lookup | registry digest, update diff, synthetic witnesses | Privacy/Security | V-SPECIAL-01 | registry changes between releases; unknown names are not proven public |
| G4-T15 | PSL drift changes registrable-domain output or rule analysis | list update, private section movement, parser bug, corrupted data | digest mismatch; dual-run corpus; rule-snapshot analyzer | disable PSL-dependent output/matching; exact-host matching may continue only if independently authorized | reinstall same digest or publish new normalizer/snapshot with reviewed diff | old/new list digests, generated synthetic changed cases, publication audit | Registry Publication | PSL-01, PSL-UPDATE | PSL is community-maintained policy data, not proof of ownership or sensitivity |
| G4-T16 | PRIVATE versus ICANN semantics silently changes site boundary | `github.io`-like private suffix, private section disabled/enabled | explicit `pslMode` in artifact and output provenance; invariant tests | conservative default: no site output and no PSL-derived authorization; exact host only | human decision and higher-revision policy/snapshot | decision record, corpus and aggregate impact estimate using synthetic names | Product/Data Governance | PSL-MODE-01 | any chosen mode can surprise business users; semantics remain policy-dependent |
| G4-T17 | malformed PSL file or pathological rule exhausts parser | bad encoding, duplicate/wildcard/exception misuse, huge line/list | signed/digest-checked bounded loader; independent lint; load-time resource metric | reject artifact and keep valid active snapshot or enter SafetyHold on compromise | replace with authorized digest; patch parser | candidate file digest, lint report, bounded performance evidence | Release/Registry | PSL-MAL-01 | a correct list can still be operationally large; exact resource budget needs measurement |
| G4-T18 | very large URL causes allocation/CPU denial of service | multi-megabyte string, huge Unicode label, long query/path, quadratic sequence | length gate before parsing; Task Host job/timeout/allocation counters | reject over limit or kill Task Host tree; no progress advance on uncertain outcome | tune bound or fix complexity under compatibility review | length bucket only; process resource trace without source bytes | Runtime/AppSec | RES-01, FZ-LARGE | source API may allocate the row before UAM receives it; acquisition contract must bound page/input |
| G4-T19 | parser exception exposes raw value | exception message, `ArgumentException.ParamName`, structured logging scope, crash telemetry | static analyzer, exception sanitizer, sink canary, WER/dump inspection | catch only at value-free boundary; disable dumps; kill Task Host on invariant failure | remove offending logging/telemetry; rerun all-sink suite | preserve sanitized stack/module offsets and build ID; delete contaminated artifact under incident authority | Runtime/Privacy | CAN-EXC-01, CRASH-02 | OS/EDR may capture process memory outside application control |
| G4-T20 | runtime patch changes parsing semantics | .NET servicing update, globalization data update, native dependency change | exact runtime manifest; golden/differential suite on each patch; semantic diff | do not promote patch for G4-capable ring if unclassified diff exists; disable source if emergency patch forced | classify every diff; issue new normalizer version or compatibility record | old/new runner IDs, corpus root, diff report, security advisory context | Release Engineering | DIFF-RUNTIME | urgent security patching may conflict with semantic stability; kill switch contains until evidence exists |
| G4-T21 | candidate and independent parsers disagree on accepted host | .NET vs Ada/Rust/WHATWG/UTS #46 result differs | differential harness with classified exception list | unclassified disagreement rejects input and blocks release; runtime result never wins by default | determine whether UAM profile intentionally differs; add normative vector and review | minimized input vector from T1 corpus; no production-derived reproducer | URL Standards Review | DIFF-ALL | references themselves can share a standards defect or implement different profiles |
| G4-T22 | suffix matcher crosses DNS label boundary | rule `example.test` matches `badexample.test` through string suffix | property tests and static analyzer witness | no assignment; snapshot publication blocked | fix matcher and regenerate snapshot under higher sequence | synthetic witness, rule IDs, compiler digest | Application Registry | RULE-01 | future grammar families may make containment less decidable |
| G4-T23 | include-apex or exact/suffix specificity is interpreted inconsistently | conflicting rule flags or compiler/runtime version mismatch | cross-implementation rule vectors; snapshot binds interpreter version | reject unsupported snapshot; ambiguity rather than guess | update compiler/runtime together consumer-first | vector digest and compatibility matrix | Registry/Endpoint | RULE-02 | human authors can still misunderstand semantics; accessible preview is required |
| G4-T24 | rule priority or row order hides cross-application conflict | two maximal rules target different apps; database order changes | analyzer computes all maximal rules; randomized rule order test | return `AMBIGUOUS`; emit no event; publication can be blocked on policy threshold | correct rules and publish higher sequence | synthetic minimal witness and value-free ambiguity counts | Registry Publication | RULE-03 | ambiguity may reduce coverage; pressure to add unsafe tie-breakers remains |
| G4-T25 | shadowed/broad rule silently captures sites | broad suffix with higher priority, unreachable exact rules | static overlap/shadow analysis and reviewer diff | block publication for unapproved shadow; endpoint still applies accepted deterministic semantics | revise priority/scope; reapprove | analysis report with fictional witnesses; no observed domains | Registry Governance | RULE-04 | static analysis covers only closed grammar and cannot infer business intent |
| G4-T26 | wrong-realm rule or application ID is selected | cache collision, malicious snapshot, repeated UUID across realms | artifact realm/signature/digest validation; realm-keyed caches; negative tests | stop before source access; SafetyHold on signed realm inconsistency | fetch correct higher-sequence artifact; incident review | audit artifact IDs/digests and fictional realm witnesses | Endpoint Security / Registry | REALM-01 | authenticated upstream realm infrastructure remains outside G4 proof |
| G4-T27 | stale, downgraded, or unsupported snapshot/normalizer activates | lower sequence, expired artifact, same revision different content, unsupported pair | candidate state machine; monotonic sequence/content checks | retain unexpired valid LKG for ordinary incompatible candidate; SafetyHold for rollback/conflict/compromise; disable when active authority invalid | publish verified higher-sequence recovery artifact | candidate digest/reason/audit and activation transaction evidence | Policy/Release | SNAP-01 | offline expiry can cause availability loss; no indefinite grace is authorized |
| G4-T28 | tenant flag or policy broadens product ceiling | tenant enables Unicode/site/path/non-default port absent from product ceiling | lattice property tests; effective-policy proof in permit | deny permit/disable affected capability; SafetyHold for signed broadening attempt | correct policy and rotate/revoke if malicious | value-free policy IDs/digests and proof counterexample | Privacy Policy Authority | MONO-01 | a valid product ceiling may itself be too broad; human governance remains necessary |
| G4-T29 | path, query, fragment, title, or source filename escapes in output | object cloning, serializer reflection, diagnostic enrichment, provenance field | compile-time type boundary; closed schema; exact canaries in each component | stop source/ring immediately; quarantine IPC/storage/network artifacts | remove field/path; migrate/delete contaminated stores per incident authority; rerun complete suite | sink inventory, contamination scope, deletion limitations, fixed build digest | Privacy Engineering | CAN-COMP-01, ARCH-RAW | process memory and third-party security tooling may have captured the value |
| G4-T30 | hash/HMAC/token of forbidden URL is treated as minimized | developer adds dedupe/diagnostic fingerprint or keyed correlation | architecture/source scan; dictionary/reversibility canaries; schema closure | reject build/result; no reversible derivative leaves Task Host | remove derivative and redesign stable identity from approved source occurrence facts | code diff, schema diff, positive-control results | Privacy/AppSec | CAN-DERIV-01 | high-entropy keyed transforms can still enable linkability; this result forbids them without a new human/ADR decision |
| G4-T31 | rejected-value telemetry creates high-cardinality or covert value channel | host/application/rule/realm/error text/exact length as label or message | metric schema lint; cardinality simulation; sink scan | drop dynamic dimension; disable affected exporter | publish fixed enum schema and migrate dashboards | metric descriptor digest, max-series evidence, no raw exemplar | SRE/Privacy | OBS-01 | aggregates can still reveal rare behavior in small populations; access/retention are human decisions |
| G4-T32 | time reduction leaks more precision or changes replay identity | local-time conversion, rounding up, jitter, precision mismatch | golden time vectors; event identity/retry tests; contract validation | reject result; no cursor advance | correct floor-UTC transform; version schema if semantics changed | source-free synthetic vectors and identity comparison | Data Contract/Privacy | TIME-01 | bucketed time can still be personal data depending on context |
| G4-T33 | identity reduction leaks username/SID/session or creates stable unapproved link | direct field, unkeyed hash, profile path, LUID/session ID | schema/architecture tests and identity canaries | reject result; stop source if escaped | remove field; incident deletion; future projection only under separate contract | affected artifact inventory, schema/build digests, canary scan | Identity/Privacy | ID-01 | device/application/time combination may still be linkable even without explicit subject |
| G4-T34 | unstable event identity causes duplicate or loss across retry | event key derived from canonical URL, time rounding changes, nondeterministic app tie | deterministic source-occurrence identity tests; G5 failpoints | no ACK/cursor advance on uncertain commit; stable retry returns same effect | fix identity inputs and migration; reconcile synthetic ledger | event/progress transaction trace, no source URL | Endpoint Storage | G4G5-01 | final production source occurrence semantics are a G3/G5 dependency |
| G4-T35 | consume/drop disposition advances cursor for transient/security failure | parser crash, missing snapshot, SafetyHold incorrectly mapped to consumed-no-event | exhaustive error-to-disposition state tests; failpoints | defer/hold with no progress for uncertain/security conditions | correct mapping and replay; do not infer lost source data | state transition ledger and cursor before/after | Endpoint Data/Storage | DISP-01 | treating permanently invalid rows as retry forever can cause availability pressure; bounded quarantine policy needs owner approval |
| G4-T36 | canary scanner misses encoding or split representation | UTF-16, percent, JSON escape, base64, compression, chunk split, hashed derivative | mandatory positive controls per sink/encoding and scanner version | block release on any miss; stop affected ring if production control fails | improve scanner; rescan retained artifacts; rotate corpus | exact scanner/version report with redacted marker IDs; no broad allowlist | Privacy/AppSec | CAN-SCAN-01 | no finite scanner proves absence in all encodings or opaque vendor telemetry |
| G4-T37 | broad canary allowlist masks a real escape | directory wildcard, generic “test data” exclusion, expired exception | allowlist schema lint, owner/expiry check, mutation test | fail gate; remove suppression | replace with exact path/marker/purpose exception or redesign artifact | immutable allowlist diff and reviewer approval | Privacy/AppSec | CAN-ALLOW-01 | reviewers may approve an overly broad exact exception; independent review is required |
| G4-T38 | realm cache pollution returns another realm’s rule object | global mutable cache keyed only by digest/version or reused Task Host | realm + digest cache key assertion; randomized concurrent realm tests | stop run and SafetyHold; terminate process | clear cache, patch keying, rerun all realm cases | heap/object identity test artifacts using fictional realms | Endpoint Security | REALM-02 | shared framework caches outside UAM code need inspection |
| G4-T39 | supply-chain compromise changes parser/list/generator behavior | malicious package, mutable tag, build generator, Unicode/PSL replacement | locked source/package hashes, SBOM/provenance, double build, corpus diff | quarantine build/artifact; revoke candidate; disable source on deployed mismatch | rebuild from reviewed source, rotate signing/CI credentials as applicable | provenance subject/materials, file manifest, incident timeline | Supply Chain/Release | SUPPLY-01 | upstream signed releases and repository accounts can still be compromised |
| G4-T40 | incident kill switch cannot stop work or re-enables without proof | stale policy, offline endpoint, local state corruption, operator error | synthetic incident drill and endpoint state telemetry | local protected `ForceSafetyHold`; deny new permits; Task Host cancellation | higher-revision recovery artifact plus successful self-test and authorized re-enable | activation/kill timing, affected ring count, cleanup receipt | Incident Response/Endpoint Ops | IR-01 | unreachable/offline devices may continue an already running bounded Task Host until local cancellation/expiry |
| G4-T41 | fail-closed behavior causes persistent endpoint outage/backlog | unsupported runtime, corrupt PSL, repeated malformed row, ambiguity flood | health-state counts, age/backlog indicators with fixed cardinality | source-specific disable; preserve unacknowledged progress; no silent drop | fix artifact/runtime or approved permanent disposition; replay under same identity | backlog/progress evidence and no-data-loss reconciliation | Operations/Product | AVAIL-01 | privacy-safe fail-closed behavior can be operationally costly; SLO and support staffing are undecided |
| G4-T42 | data-quality spike is misread as user behavior or productivity signal | sudden unmatched/ambiguous/rejected counts after rule/runtime change | version-aware aggregate comparison and deployment correlation | suppress business interpretation; pause rollout if threshold exceeded | rollback same digest or publish corrected higher revision | aggregate-only incident report with release/snapshot versions | Product/Data Governance | DQ-01 | even aggregates can be misused; prohibited-use policy is a human control |
| G4-T43 | accessibility defect causes rule reviewer to approve wrong IDN/suffix semantics | UI shows only Unicode or only A-label; color-only warning; unclear apex behavior | accessibility review, keyboard/screen-reader tests, comprehension tests with synthetic examples | block rule publication UI release; endpoint remains fail-closed | correct UI and re-review affected unpublished rules | synthetic screenshots/transcripts and WCAG-oriented test record; no production URLs | Admin UX/Registry Governance | A11Y-01 | accessible presentation does not eliminate human misunderstanding or confusable risk |
| G4-T44 | support bundle or remote troubleshooting exports raw memory/artifacts | ad hoc dump, ETW capture, SQLite copy, IPC trace, vendor support collection | support-tool allowlist and bundle canary; runbook audit | prohibit/export-block bundle; isolate endpoint incident channel | sanitize or destroy contaminated artifact under approved incident/retention process | bundle manifest, scanner report, deletion/recipient evidence | Support/Incident Response | SUPPORT-01 | third-party EDR/support agents may operate outside UAM controls and need enterprise governance |

## 7.2 Severity and response rules

1. **Privacy escape, reversible derivative, cross-realm result, or unauthorized broadening** is a release-blocking incident candidate. The source and affected ring MUST enter `SafetyHold`; the response may not be reduced to “bad data.”
2. **Unclassified parser or normalizer disagreement** blocks promotion. A compatibility allowlist requires a normative UAM vector, rationale, owner, review trigger, and proof that the stricter result does not widen collection.
3. **Permanent source-value rejection** may advance source progress only when the reason is deterministic under the active version, the approved G4/G5 disposition says `CONSUMED_NO_EVENT`, and the no-event fact commits atomically. Resource, authority, corruption, and uncertainty failures do not qualify.
4. **Recovery** requires the same all-sink canary suite that guards initial release. A local restart or successful parse of the triggering example is insufficient.
5. **Cleanup evidence** must distinguish what UAM deleted from what cannot be proven deleted, including OS pagefile, crash infrastructure, EDR, backups, and already exported support artifacts.

---

# 8. Detailed test matrix and smallest falsifying prototypes with setup, instrumentation, steps, pass/fail, evidence, duration, and cleanup

## 8.1 Golden vectors before production logic

**RECOMMENDATION / CLI EXPERIMENT.** Implement the declarative golden corpus and independent reference evaluator before implementing `Uam.UrlProfile`. Production code may not define the expected answer. Each vector has:

```yaml
id: G4-V0001
classification: T1
inputEncoding: utf16-code-units
input: "HTTPS://EXAMPLE.COM./ignored?G4CANARY-Q#G4CANARY-F"
normalizationVersion: uam-url-v1
pslDigest: "<pinned-sha256>"
policyMode: "synthetic-structural-only"
expectedStage: 16
expectedCanonical:
  scheme: https
  asciiHost: example.com
  port: null
expectedMatch: UNMATCHED
expectedDisposition: CONSUMED_NO_EVENT
forbiddenInEverySink:
  - G4CANARY-Q
  - G4CANARY-F
rationale: "case, one terminal dot, discarded query and fragment"
```

The reference evaluator MUST be a separate project and owner, MUST NOT reference production parsing/matching/transform assemblies, and SHOULD use declarative finite functions plus independent runners. Test-vector changes require review before production-code changes are accepted.

## 8.2 Cross-language canonical test vectors

The table below is normative for UAM v1. “Canonical stage result” is the syntactic/IDNA tuple before special-use, hard-deny, matching, and human output approval. Some documentation domains are intentionally suppressed later; that does not change the canonical-stage expectation. `REJECT` means no canonical host may be produced. Differential runners may accept more inputs than UAM; those are expected divergences only when explicitly classified here.

| ID | Synthetic input | UAM canonical-stage result | Later first-slice result / purpose |
|---|---|---|---|
| CV-001 | `https://Example.COM/a?x=G4C-Q#G4C-F` | `https`, `example.com`, no port | path/query/fragment discarded; output still policy-gated |
| CV-002 | `HTTPS://EXAMPLE.COM./` | `https`, `example.com`, no port | exactly one terminal dot is comparison-equivalent |
| CV-003 | `https://example.com../` | `REJECT: TRAILING_DOT_INVALID` | multiple terminal dots never repaired |
| CV-004 | `https://.example.com/` | `REJECT: DNS_LABEL_INVALID` | leading empty label |
| CV-005 | `https://a..example.com/` | `REJECT: DNS_LABEL_INVALID` | interior empty label |
| CV-006 | ` https://example.com/` | `REJECT: LEADING_OR_TRAILING_SPACE` | WHATWG-style trimming is forbidden |
| CV-007 | `https://example.com/ ` | `REJECT: LEADING_OR_TRAILING_SPACE` | no trailing-space recovery |
| CV-008 | `https:\\example.com\a` | `REJECT: BACKSLASH_FORBIDDEN` | browser special-URL slash recovery is forbidden |
| CV-009 | `http:/example.com/` | `REJECT: SCHEME_SEPARATOR_INVALID` | requires exact `://` |
| CV-010 | `//example.com/` | `REJECT: SCHEME_SEPARATOR_INVALID` | no base-relative resolution |
| CV-011 | `ftp://example.com/` | `REJECT: SCHEME_UNSUPPORTED` | first slice HTTP(S) only |
| CV-012 | `https://user:G4C-PASS@example.com/` | `REJECT: USERINFO_FORBIDDEN` | credential canary must not escape |
| CV-013 | `https://example%2ecom/` | `REJECT: PERCENT_IN_AUTHORITY` | no encoded host delimiters |
| CV-014 | `https://example.com/%ZZ` | `REJECT: PERCENT_ESCAPE_INVALID` | malformed escape rejected even in discarded component |
| CV-015 | `https://example.com/%2e%2e/G4C-PATH` | `https`, `example.com`, no port | valid path escapes are not decoded; component is discarded |
| CV-016 | `https://faß.de/` | `https`, `xn--fa-hia.de`, no port | UTS #46 non-transitional; compare Unicode 17 vectors |
| CV-017 | `https://xn--fa-hia.de/` | `https`, `xn--fa-hia.de`, no port | valid A-label round-trip |
| CV-018 | `https://xn--invalid-.de/` | `REJECT: IDNA_INVALID` | malformed A-label |
| CV-019 | `https://www。example.com/` | `https`, `www.example.com`, no port | UTS #46 maps recognized full-stop variant; version-bound behavior |
| CV-020 | UTF-16 containing a lone high surrogate in host | `REJECT: INVALID_UNICODE` | must not reach parser/exception log |
| CV-021 | host with U+202E RIGHT-TO-LEFT OVERRIDE | `REJECT: CONTROL_CHARACTER` or `IDNA_INVALID` per exact pre-scan profile | no formatting-control recovery; expected reason fixed in corpus |
| CV-022 | valid Arabic IDN from pinned UTS #46 vector set | exact expected A-label from pinned vector | proves valid RTL support when Unicode feature enabled |
| CV-023 | invalid Joiner-context vector from UTS #46 | `REJECT: IDNA_INVALID` | ContextJ enforced |
| CV-024 | label of exactly 63 ASCII octets | canonical host accepted if all other rules pass | upper label boundary |
| CV-025 | label of 64 ASCII octets | `REJECT: DNS_LENGTH_INVALID` | no parser-dependent truncation |
| CV-026 | DNS name of 253 ASCII octets without final dot | canonical host accepted if labels valid | total-name boundary |
| CV-027 | DNS name of 254 ASCII octets without final dot | `REJECT: DNS_LENGTH_INVALID` | total-name rejection |
| CV-028 | `https://127.0.0.1/` | `REJECT: IP_LITERAL_FORBIDDEN` | IPv4 literal |
| CV-029 | `https://127.1/` | `REJECT: IP_LITERAL_FORBIDDEN` | legacy shortened IPv4 |
| CV-030 | `https://0x7f000001/` | `REJECT: IP_LITERAL_FORBIDDEN` | legacy hexadecimal IPv4 |
| CV-031 | `https://2130706433/` | `REJECT: IP_LITERAL_FORBIDDEN` | single-integer IPv4 |
| CV-032 | `https://[::1]/` | `REJECT: IP_LITERAL_FORBIDDEN` | IPv6 literal |
| CV-033 | `https://[fe80::1%25G4C-ZONE]/` | `REJECT: IP_LITERAL_FORBIDDEN` | zone/topology canary |
| CV-034 | `https://example.com:443/` | `https`, `example.com`, no port | explicit default omitted canonically |
| CV-035 | `http://example.com:80/` | `http`, `example.com`, no port | explicit default omitted canonically |
| CV-036 | `https://example.com:08443/` | syntactic port `8443`, then `NON_DEFAULT_PORT_FORBIDDEN` in default profile | leading zeros do not create alternate identity; exact permission required |
| CV-037 | `https://example.com:+443/` | `REJECT: PORT_INVALID` | ASCII decimal only |
| CV-038 | `https://example.com:65536/` | `REJECT: PORT_INVALID` | range boundary |
| CV-039 | `https://example.com:/` | `REJECT: PORT_INVALID` | explicit empty port is not silently omitted |
| CV-040 | `https://localhost/` | canonical host then `SPECIAL_USE_OR_LOCAL` | no event |
| CV-041 | `https://intranet/` | canonical single label then `SPECIAL_USE_OR_LOCAL` | no event |
| CV-042 | `https://printer.example/` | canonical host then `SPECIAL_USE_OR_LOCAL` | reserved documentation name suppressed |
| CV-043 | `https://example.invalid/` | canonical host then `SPECIAL_USE_OR_LOCAL` under pinned IANA registry | documentation/test special-use suppressed in production profile |
| CV-044 | `https://tenant.github.io/` | canonical host; PSL fact depends on explicit PRIVATE mode | no site output until human semantics decision |
| CV-045 | exact rule `portal.fiction.test`, input `portal.fiction.test` | `MATCHED` to one synthetic app | exact-host semantics |
| CV-046 | suffix rule `fiction.test`, `includeApex=false`, input `a.fiction.test` | `MATCHED` | label-boundary child match |
| CV-047 | same suffix rule, input `fiction.test` | `UNMATCHED` | apex flag honored |
| CV-048 | suffix `fiction.test`, input `badfiction.test` | `UNMATCHED` | string-suffix bug detector |
| CV-049 | equal maximal rules for two app IDs | `AMBIGUOUS`, no application | row order randomized; no tie-break |
| CV-050 | same rule/application UUIDs in two fictional realms | only permit-bound realm can match | cache/realm isolation |
| CV-051 | valid URL with query canary split at IPC frame boundary | canonical host; canary absent from serialized result and captures | split-buffer sink test |
| CV-052 | over-limit URL with canary at last code unit | `REJECT: INPUT_TOO_LARGE` before parser | exact length not logged; canary absent |

### 8.2.1 Runner matrix

Each vector is run through:

1. the independent UAM reference evaluator;
2. the candidate `.NET 10.0.10` wrapper at the exact reviewed runtime commit/build manifest;
3. Node/browser WHATWG URL behavior at an exact locked runtime, used only as a differential reference;
4. Ada URL `v4.0.0` at commit `b12a893a45809da8103bb4f1e2f6f5ee13f9100b`;
5. Rust `url` `v2.5.7` at commit `43f47e2fcfdd132c531fb05aa16171ca85be95f4`;
6. Unicode UTS #46 Revision 35 `IdnaTestV2.txt`/ToASCII vectors for IDNA-specific cases; and
7. pinned WPT URL data at commit `181476aa16e8b28a07698bef3a0275fa53dd22e5`.

A different result is not automatically a defect because UAM is intentionally stricter than browser parsing. It passes only when the difference is classified in the vector as `UAM_STRICTER`, `PROFILE_DIFFERENCE`, or `REFERENCE_DEFECT`, with owner and evidence. Any unclassified difference blocks release.

## 8.3 Million-case deterministic fuzz and canary plan

**CLI EXPERIMENT.** Generate exactly 1,000,000 deterministic T1 cases from a fixed domain-separated seed. The canonical corpus is reviewable generator configuration plus seed and expected property/oracle rules; the million rendered cases may be ephemeral and content-addressed.

| Partition | Cases | Generation focus | Mandatory assertions |
|---|---:|---|---|
| F1 grammar-valid and one-edit-near-valid absolute HTTP(S) | 300,000 | scheme/authority/host/port/component delimiters, case, one-character mutations | deterministic classification; accepted tuple idempotent; no exception |
| F2 delimiter, whitespace, control, backslash, percent and userinfo attacks | 250,000 | C0/C1, Unicode spaces, CR/LF/tab, `@`, brackets, colons, `%` triplets, mixed slash | strict early rejection where required; no browser recovery; canary absent |
| F3 Unicode/IDNA | 150,000 | UTS #46 categories, Bidi, Joiner, deviations, A-label round trip, dot variants, invalid UTF-16 | fixed Unicode-data result; every error fails closed; accepted host ASCII/lower-case/DNS-valid |
| F4 IP, trailing-dot, label/length, port, local/special-use and PSL boundaries | 100,000 | legacy IPv4 grammar, IPv6/zones, label lengths, wildcard/exception PSL witnesses, default/non-default ports | no IP bypass; exact bound behavior; PSL result matches pinned independent parser |
| F5 discarded-component and very-large-input canaries | 100,000 | path/query/fragment/title canaries, encoding variants, chunk boundaries, limit−1/limit/limit+1 and huge cases | no forbidden byte/encoding/derivative in any sink; bounded allocation/time |
| F6 matcher, policy, realm, version and conflict cases | 50,000 | exact/suffix/apex/priority/ambiguity/shadow, realm collisions, stale snapshot, tenant broadening | reference and production matcher agree; no guessed ambiguity or cross-realm result |
| F7 imported/pinned regression selection | 50,000 | WPT URL cases, Ada/Rust regressions, UTS #46 vectors, previously found UAM defects | every result classified; prior defect cannot recur |
| **Total** | **1,000,000** |  |  |

### 8.3.1 Canary corpus

Each relevant case receives one or more fictional markers in the raw URL, userinfo, Unicode host spelling, path, query, fragment, title, profile/source-path fixture, source row metadata, and error-triggering tail. The scanner expands approved markers into these declared representations:

- UTF-8, UTF-16LE, UTF-16BE and scalar/code-unit sequences;
- JSON escaped, XML escaped, percent encoded (upper/lower case), form encoded;
- Base64/Base64url and hex for exact markers;
- UTF-8 bytes embedded across 1–N byte frame/chunk boundaries;
- compressed test artifacts after decompression by a bounded scanner;
- lower/upper case only where the marker registry declares case-insensitive matching;
- known developer anti-pattern derivatives, including SHA-256 and HMAC with a fixed fictional test key, strictly as positive controls proving the scanner catches prohibited derivatives.

The scanner does not attempt arbitrary cryptanalysis. Its purpose is to catch exact forbidden values and known accidental transformations. The architecture rule—not scanner cleverness—prohibits deriving a value in the first place.

### 8.3.2 Sink inventory

The million-case campaign and smaller Windows campaign scan:

- Task Host result serializer and Task Host → User Host named-pipe capture;
- User Host → Coordinator capture;
- endpoint SQLite databases, WAL/SHM, backups and failpoint copies;
- stdout/stderr, console capture, Windows Event Log, ETW/event source, traces and metric exposition;
- HTTP request/response capture and compression buffers;
- temporary/scratch files, test-result files, coverage output and fuzz crash corpus;
- WER/minidump/full-dump configurations used in the controlled lab;
- support/evidence bundles and CI artifacts;
- source tree, generated code, package manifests, SBOM and provenance metadata where canaries are deliberately planted as positive controls.

A mandatory marker in any forbidden sink is a failed G4 gate. The approved canary source files themselves are exact, path-scoped, owner/expiry-bound exceptions.

## 8.4 Property and metamorphic test catalogue

| Property ID | Property |
|---|---|
| P-01 | For every accepted input, canonicalization is deterministic across repeated runs under the same normalizer/PSL/runtime identity. |
| P-02 | Canonicalization is idempotent: rendering the canonical scheme/host/default-port tuple into the profile’s minimal URL and reprocessing yields the same tuple. |
| P-03 | Every accepted host is lower-case ASCII, contains valid DNS labels, has no terminal dot, is not an IP literal/legacy numeric form, and meets byte limits. |
| P-04 | Adding leading/trailing whitespace, a raw backslash, userinfo, authority percent, invalid percent triplet, or control to a valid input cannot produce an accepted event. |
| P-05 | Changing only path/query/fragment/title cannot change canonical host, rule match, application ID, or event identity—except it may turn the whole observation into deterministic rejection if the raw component contains a profile-forbidden lexical form such as malformed `%`. |
| P-06 | One terminal dot does not change canonical host; adding a second terminal dot always rejects. |
| P-07 | Explicit default port equals absent port; a non-default port never matches a default-only rule. |
| P-08 | Exact host is reflexive and no exact rule matches a child. Suffix matches only whole-label descendants and honors `includeApex`. |
| P-09 | Permuting rule order cannot change the maximal set, match outcome, or application assignment. |
| P-10 | Adding a rule for another realm cannot change an outcome. Reusing every UUID in another realm cannot change an outcome. |
| P-11 | Tenant-policy meet cannot enable Unicode, ports, fields, site mode, rule families, destinations, or metrics absent from the product ceiling. |
| P-12 | Equally maximal cross-application rules always yield `AMBIGUOUS`; adding an arbitrary lexicographic/order field cannot alter that result. |
| P-13 | A hard-deny predicate dominates every allow/match and never emits an application event. |
| P-14 | Every non-success result maps to exactly one approved disposition; authority/resource/security uncertainty never authorizes progress. |
| P-15 | No serialized result, diagnostic, metric, store, transport, crash artifact, or bundle contains a raw canary or declared reversible derivative. |
| P-16 | Accepted minimized event schema contains only fields named by both the product ceiling and effective tenant policy. |
| P-17 | Time is UTC-floored to the declared precision and never exceeds source time; same source occurrence/retry yields the same reduced time. |
| P-18 | Normalizer/runtime/Unicode/PSL/snapshot version changes never silently reuse the same semantic-version evidence when an outcome changes. |
| P-19 | Processing time and allocation remain bounded by declared input/page budgets; malformed cases do not cause unbounded handle/thread/process growth. |
| P-20 | A failure or kill before G5 atomic commit produces no ACK and no cursor advance; retry produces one final business effect. |

## 8.5 Detailed test matrix

Durations below are **ESTIMATE** bootstrap budgets for one clean execution environment and must be replaced by measured CI/lab data. Exceeding a budget is not by itself proof of insecurity, but an unexplained regression blocks promotion until classified.

| Test ID | Setup and instrumentation | Steps | Pass | Fail / stop | Exact evidence | Duration estimate | Cleanup |
|---|---|---|---|---|---|---:|---|
| GOLD-01 | clean checkout; locked SDK/tools; independent reference project; T1 corpus | generate vectors twice; run reference then production; mutate one expected and one production rule | byte-identical corpus roots; exact expected matrix; mutations detected | nondeterminism, common assembly reference, or mandatory mutation survivor | command manifest, roots, dependency graph, result matrix, mutation report | 10 min | delete rendered ephemeral corpus; prove clean tree |
| LEX-01 | production wrapper with allocation/exception instrumentation | run lexical/authority boundary vectors and one-edit generator | exact reason/stage; zero uncaught exception; bounded resource | any repaired forbidden form, raw exception, or stage drift | vector IDs/results, allocation/time buckets, build/runtime IDs | 10 min | remove traces after canary scan |
| IDNA-01 | Unicode 17/UTS #46 Rev 35 data pinned; .NET and independent IDNA runner | run all selected ToASCII/round-trip/Bidi/Joiner vectors | all UAM expected results; every accepted A-label round-trips; every error rejects | unclassified disagreement or accepted error | data digests, options, runner versions, diff report | 30 min | delete generated strings/traces after sink scan |
| DIFF-01 | exact .NET, Node WHATWG, Ada, Rust runners in isolated containers/processes | run CV table plus 50k regression cases; classify each difference | zero unclassified difference; UAM never silently widens on candidate-only acceptance | unclassified output or runtime-dependent result | per-runner manifest, normalized result table, classification file | 30 min | remove containers/cache per dependency policy |
| PSL-01 | pinned PSL digest; production and independent parser; synthetic wildcard/exception corpus | load/lint; compare prevailing-rule and registrable-domain results; corrupt/truncate file | exact agreement; corrupt file rejected; no network | parser difference, silent fallback, dynamic update/egress | list/source digest, parser versions, result/witness table, egress log | 20 min | delete corrupted copies; retain authorized digest only |
| RULE-01 | 50k synthetic rules across fictional realms; independent finite matcher | randomize order; generate overlap/shadow/ambiguity witnesses; compare endpoint/compiler | exact maximal set; cross-app tie ambiguous; cross-realm zero effect | guessed tie, missed overlap, order dependence | seeds, snapshot/compiler digests, witness/result roots | 20 min | delete ephemeral snapshots/witness renderings |
| MONO-01 | finite product/tenant/emergency policy domains | exhaustive small-domain meet plus property/mutation tests | no broadening; unknown/incomparable disables; wrong realm/revision rejected | any broader effective capability | counterexample report, evaluator/build IDs, mutation report | 15 min | remove temporary policy candidates |
| FUZZ-1M | fixed seed; all seven partitions; per-case timeout/allocation counters; exact canaries | render/stream exactly 1,000,000; run reference/production/differential subsets; scan sinks | all properties hold; zero crash/hang/OOM/unclassified diff/canary escape; exact case count | any mandatory property/canary failure or unexplained resource outlier | generator config/seed/root, partition counts, failures/minimal reproducers, resource histograms, scanner report | 2 h per architecture/candidate | preserve only minimized failing T1 cases; delete large corpus and traces |
| RES-01 | disposable Task Host/job; limit−1/limit/limit+1 and pathological cases | measure wall/CPU/allocation/handles/threads; induce cancellation/kill | bounds enforced before expensive work; process tree ends; no residue | unbounded growth, orphan, dump/value escape, progress advance | job/process counters, bucketed timing, cleanup diff | 30 min | kill job; delete scratch/dumps after scan; verify baseline diff |
| CAN-SELF | exact marker registry and all declared encodings/derivatives planted in controlled positive-control sinks | run scanner before any other canary gate | every mandatory planted representation detected; report redacts marker value | one miss or broad suppression | marker IDs, sink/encoding matrix, scanner binary/config digest | 10 min | remove positive-control artifacts; rescan clean workspace |
| CAN-TASK | synthetic source inside restricted Task Host; pipe capture; logs/ETW/metrics/temp/dump collection | process valid/rejected/crash/large cases with canaries in every component | only approved minimized DTO/value-free result crosses pipe; no marker elsewhere | any marker/derivative in forbidden sink | capture/file manifest, schema decode, scanner report, process cleanup | 30 min | delete lab artifacts and test certs/handles; restore VM snapshot |
| CAN-E2E | disposable Windows VM; fictional Coordinator/User Host/Task Host; SQLite/network capture; no live browser profile | run full page, retry, reject, cancel, crash, snapshot revoke and service restart | zero raw marker across both IPC legs/storage/log/network/support bundle; correct atomic disposition | escape, wrong ACK/cursor, cross-session/realm acceptance, residue | VM inventory, binary/artifact digests, captures, DB truth ledger, scanner and cleanup receipt | 60 min | uninstall; remove services/tasks/files/certs/rules; revert VM |
| CRASH-01 | WER/dump profiles explicitly configured in isolated lab; exact canaries | force parser/IDNA/matcher/serializer crashes at each stage | production configuration creates no raw full dump; approved synthetic crash artifacts pass scanner; source stops safely | raw canary in dump/event/report or auto-upload | WER policy snapshot, dump types/manifest, scanner report, egress capture | 30 min | delete dumps/reports; revert policy/VM; record deletion limits |
| CARD-01 | metrics exporter and descriptor lint; synthetic all-code/realm/app cardinality | enumerate combinations and attempt dynamic labels/exemplars | only fixed dimensions; actual maximum within approved budget; dynamic label mutation fails | raw/dynamic label, exemplar leak, unbounded series | descriptor schema, series count, mutation result, scrape scan | 15 min | remove test time series/artifacts |
| G4G5-01 | synthetic SQLite WAL one-writer prototype with failpoints before/after event/progress/commit/ACK | run event and no-event dispositions; crash at every boundary; retry | cursor never ahead; event/no-event fact atomic; retry one effect; ACK after commit | loss, duplicate effect, cursor advance on uncertainty | failpoint matrix, SQLite integrity/state dumps after canary scan, truth reconciliation | 45 min | delete DB/WAL/SHM after evidence extraction and scan |
| ROLLOUT-01 | old/new normalizer, PSL, snapshot and endpoint versions; synthetic fleet inventory | run consumer-first matrix, dual offline corpus, downgrade/expiry/corrupt candidate | unsupported candidate never partially activates; no event duplication; rollback uses higher sequence | silent coercion, lower sequence, old consumer misinterprets result | compatibility matrix, state transitions, corpus diff, artifact digests | 30 min | remove candidate artifacts and restore active state |
| IR-01 | incident tabletop plus disposable VM; kill switch and recovery artifact | simulate canary escape, parser mismatch, corrupt PSL, ambiguity spike and wrong realm | kill switch prevents new permits within measured local bound; recovery requires higher revision and passed self-test; cleanup complete | work continues, local self-reenable, lost evidence, incomplete cleanup | timeline, state/audit events, affected-ring count, recovery/cleanup receipts | 45 min | revoke synthetic artifacts/keys; revert VM |
| A11Y-01 | prototype admin rule preview with synthetic IDNs/suffixes; keyboard and screen-reader tooling | review A-label/Unicode, exact/suffix/apex/port/conflict cases without color cues | all semantics and warnings perceivable/operable; no production observation shown | inaccessible control, Unicode-only deception, ambiguous semantics | accessibility checklist/tool output and synthetic session notes | 30 min | delete prototype data/recordings per test policy |

## 8.6 Smallest falsifying prototypes

### P-G4-01 — strict profile versus candidate parser

- **Claim:** the wrapper can prevent browser/.NET recovery from widening accepted input.
- **Setup:** one pure CLI with raw UTF-16 input, strict scanner, candidate `.NET 10.0.10` parser adapter, no network/logging, and CV-001–CV-044.
- **Instrumentation:** exact stage/reason, allocation/time buckets, candidate boundary tuple, exception sanitizer, sink canaries.
- **Steps:** implement expected vectors first; run candidate behind scanner; mutate scanner to trim, replace backslash, or allow userinfo.
- **Pass:** baseline exact; each unsafe mutation causes at least one mandatory vector/property failure; no marker in output/log.
- **Fail:** candidate-only acceptance reaches canonical output, mutation survives, or raw exception/value appears.
- **Evidence:** source/build/runtime digests, vector root, mutation and scanner reports.
- **Duration:** **ESTIMATE 20 minutes**.
- **Cleanup:** delete generated outputs and traces after canary scan; clean-tree proof.

### P-G4-02 — IDNA profile and round trip

- **Claim:** one fixed UTS #46 non-transitional profile can be implemented reproducibly in the selected .NET line.
- **Setup:** pinned Unicode 17/UTS #46 Rev 35 subset plus independent runner; `IdnMapping` candidate with exact options and runtime identity.
- **Instrumentation:** per-vector status/A-label, error category, round-trip result, no input echo.
- **Steps:** run valid/deviation/Bidi/Joiner/A-label/length cases; swap one option or Unicode dataset as a mutation.
- **Pass:** exact expected outcomes; all accepted A-labels round-trip; option/data mutation is detected as semantic diff.
- **Fail:** candidate silently accepts reference error or outcome changes without version evidence.
- **Evidence:** data/tool/runtime digests and minimized diff.
- **Duration:** **ESTIMATE 30 minutes**.
- **Cleanup:** remove generated vector rendering and traces.

### P-G4-03 — legacy IP and authority smuggling

- **Claim:** no IP literal or legacy numeric representation reaches DNS matching.
- **Setup:** dedicated recognizer plus WHATWG/Ada/Rust/.NET differential corpus of numeric/address edge cases.
- **Instrumentation:** raw authority classification, candidate host type, final reason.
- **Steps:** exhaustive generated components around decimal/octal/hex/shortened IPv4, IPv6 brackets/zones, percent/userinfo/ports.
- **Pass:** every reference-recognized IP form rejects; unclassified reference disagreement blocks.
- **Fail:** any form becomes a DNS A-label or matches a rule.
- **Evidence:** generator seed/root and minimal counterexample.
- **Duration:** **ESTIMATE 20 minutes**.
- **Cleanup:** delete ephemeral corpus.

### P-G4-04 — pinned PSL semantics

- **Claim:** a local pinned PSL can be parsed deterministically without becoming runtime authority or network dependency.
- **Setup:** exact list commit/digest, production parser, small independent parser, wildcard/exception/private-section synthetic fixtures, outbound network denied.
- **Instrumentation:** prevailing rule, section, registrable domain, allocations, file digest, egress capture.
- **Steps:** compare parsers; corrupt/truncate/reorder nonsemantic comments; switch PRIVATE mode; attempt HTTP refresh.
- **Pass:** exact expected facts; corrupt/mismatch rejects; network attempt impossible; mode difference explicit.
- **Fail:** silent fallback/update, parser difference, or PSL result directly authorizes an application absent a rule.
- **Evidence:** list/source digest, results, egress log.
- **Duration:** **ESTIMATE 20 minutes**.
- **Cleanup:** remove corrupt copies and retain only authorized artifact.

### P-G4-05 — deterministic matcher and conflict analyzer

- **Claim:** exact/suffix host matching has order-independent, analyzable ambiguity semantics.
- **Setup:** independent finite matcher, production matcher, 50,000 synthetic same/cross-realm rule sets.
- **Instrumentation:** all candidates, priority/family/maximal set, selected app/result, analyzer witnesses.
- **Steps:** permute rows; add broad/exact rules; collide UUIDs across realms; mutate to first-match/lexicographic tie-break.
- **Pass:** exact equality to reference; every cross-app maximal tie is `AMBIGUOUS`; unsafe mutations fail.
- **Fail:** order dependence, guessed target, missed realm isolation or unknown analysis treated as safe.
- **Evidence:** seeds, snapshots, minimized witnesses, mutation report.
- **Duration:** **ESTIMATE 30 minutes**.
- **Cleanup:** delete ephemeral snapshots.

### P-G4-06 — raw type cannot reach result serializer

- **Claim:** production assembly boundaries make accidental raw-value serialization difficult and test-detectable.
- **Setup:** raw source type in Task Host-private assembly; minimized contract in contracts assembly; architecture/source analyzers; serializer tests.
- **Instrumentation:** dependency graph, reflection/serializer metadata, compile-time forbidden API rules.
- **Steps:** attempt to reference raw type from IPC/storage; add object cloning, exception interpolation, hash field and dynamic diagnostic tag mutations.
- **Pass:** each mutation fails build/test; only closed minimized/rejection types serialize.
- **Fail:** raw object, generic `object`, dictionary/extension bag, or derived fingerprint can cross boundary.
- **Evidence:** graph, mutation diffs/results, schema snapshot.
- **Duration:** **ESTIMATE 15 minutes**.
- **Cleanup:** revert mutations and prove clean tree.

### P-G4-07 — all-sink canary containment

- **Claim:** no forbidden source value or known reversible derivative crosses Task Host IPC or enters endpoint sinks.
- **Setup:** fictional marker registry; positive-control scanner; disposable Windows VM; synthetic source adapter; both IPC captures, SQLite, log/trace/metric/network/dump/support-bundle collectors.
- **Instrumentation:** file/capture manifest, schema decoder, process/job cleanup, outbound capture.
- **Steps:** first prove every planted marker is detected; then run success/reject/defer/ambiguity/hard-deny/large/crash/cancel/restart cases; scan all sinks.
- **Pass:** zero forbidden marker/derivative outside approved source fixtures; only minimized contract; cleanup complete.
- **Fail:** one escape, scanner miss, uncontrolled dump/egress, or residue.
- **Evidence:** exact build/config/corpus roots, sink manifest, redacted scanner report, VM cleanup receipt.
- **Duration:** **ESTIMATE 60 minutes**.
- **Cleanup:** delete contaminated test artifacts, uninstall, remove certificates/services/tasks/rules, revert VM.

### P-G4-08 — G4/G5 disposition and crash invariant

- **Claim:** minimized event or approved no-event progress and cursor commit atomically; uncertainty never advances progress.
- **Setup:** synthetic source occurrence ledger and SQLite WAL one-writer prototype with failpoints.
- **Instrumentation:** transaction log, cursor/event/no-event tables, ACK trace, independent truth ledger.
- **Steps:** crash before/after each write/commit/ACK; retry exact occurrence for every rejection family and success.
- **Pass:** no cursor-ahead state; success/no-event each has one durable effect; transient/security failures have no authorized progress; ACK follows commit.
- **Fail:** loss, duplicate business effect, cursor ahead, or consumed mapping for uncertainty.
- **Evidence:** failpoint/result matrix and scanned DB snapshots.
- **Duration:** **ESTIMATE 45 minutes**.
- **Cleanup:** delete DB/WAL/SHM after evidence extraction and canary scan.

### P-G4-09 — version and rollout compatibility

- **Claim:** normalizer/Unicode/PSL/snapshot changes can roll out consumer-first without duplicate events or silent reinterpretation.
- **Setup:** two endpoint releases, two normalizer versions, two pinned PSLs and snapshots, synthetic fleet inventory.
- **Instrumentation:** activation state, version negotiation, event identity/truth ledger, corpus semantic diff.
- **Steps:** new consumer/old producer; new producer/old consumer; unsupported candidate; lower sequence; same sequence/different content; rollback at higher sequence.
- **Pass:** unsupported combinations fail closed/LKG as defined; no lower sequence; exactly one active semantic path per observation; no duplicate effect.
- **Fail:** partial activation, silent coercion, duplicate event, or historical reinterpretation without contract.
- **Evidence:** compatibility/state matrix and artifact digests.
- **Duration:** **ESTIMATE 30 minutes**.
- **Cleanup:** remove candidates and restore baseline state.

### P-G4-10 — privacy-safe observability and incident recovery

- **Claim:** operators can detect and recover from G4 failure without observing source values.
- **Setup:** fixed metric/error schema, synthetic incidents, local kill switch and higher-revision recovery artifact.
- **Instrumentation:** metric-series counter, audit/state events, response timeline, support-bundle scanner.
- **Steps:** trigger malformed spike, parser disagreement, PSL corruption, canary signal, wrong-realm snapshot; execute runbooks.
- **Pass:** finite value-free telemetry identifies stage/family/version; kill switch stops new permits; recovery requires authorized artifact and passed self-test; support bundle clean.
- **Fail:** raw/dynamic telemetry, inability to locate component/version, self-reenable, or evidence loss.
- **Evidence:** descriptor/audit/runbook outputs and scanner report.
- **Duration:** **ESTIMATE 45 minutes**.
- **Cleanup:** revoke synthetic artifacts, clear test telemetry, restore VM.

---

# 9. Architecture fitness functions and measurable acceptance criteria

## 9.1 Fitness-function register

| ID | Invariant / question | Measurement | Acceptance criterion | Frequency and owner function |
|---|---|---|---|---|
| FF-G4-01 | forbidden source value never crosses the endpoint privacy boundary | exact canaries and declared encodings in every sink; architecture type scan | **zero** marker or prohibited derivative outside exact approved source fixtures; scanner positive controls all pass | every PR affecting G4/contracts/logging; every release; Privacy/AppSec |
| FF-G4-02 | Task Host is the final raw-value boundary | project/reference graph and serializer-type inventory | User Host, Coordinator, storage, transport and shared contracts cannot reference raw URL/source types; no generic object/extension bag | every build; Architecture owner |
| FF-G4-03 | strict input profile does not inherit browser recovery | golden/property corpus for whitespace, slash, userinfo, percent, scheme and controls | 100% exact expected result and stage; unsafe mutations fail | every PR/runtime patch; URL Profile owner |
| FF-G4-04 | canonicalization is deterministic and idempotent | repeated clean runs and canonical minimal-render round trip | identical result bytes/reason; all accepted tuples idempotent | every build; Test Architecture |
| FF-G4-05 | IDNA behavior is fixed and independently checked | pinned UTS #46 vectors and second implementation | zero unclassified difference; all errors reject; accepted A-labels round-trip and meet DNS limits | every Unicode/runtime change; Internationalization/Security |
| FF-G4-06 | no IP/legacy numeric host reaches DNS matching | generated legacy IPv4/IPv6/zone corpus and reference runners | zero accepted/matched IP form | every build; Endpoint Security |
| FF-G4-07 | parser/runtime changes are visible | exact runtime/source IDs and full corpus semantic diff | no outcome change under same `normalizationVersion`; every change gets new version or accepted compatibility record | each SDK/runtime/OS image update; Release Engineering |
| FF-G4-08 | PSL input is pinned, local, deterministic and non-authoritative | digest check, egress denial, dual parser, malformed-list tests | correct authorized digest; zero network; exact parser agreement; mismatch/corruption fails closed | each list/parser update and release; Registry Publication |
| FF-G4-09 | PSL business mode is explicit | artifact/schema lint and synthetic private-suffix cases | every PSL-dependent result binds `pslMode`; no default inference; disabled mode cannot produce site output | every snapshot/policy; Product/Data Governance |
| FF-G4-10 | rule matching is order-independent and ambiguity-safe | randomized rule permutation and independent maximal-set evaluator | exact same outcome for every permutation; cross-app maximal tie always `AMBIGUOUS` with no event | every matcher/compiler change and snapshot publication; Registry |
| FF-G4-11 | realm isolation holds | duplicate-ID cross-realm corpus, cache-key inspection and hostile artifact tests | zero cross-realm candidate/result/cache object; wrong realm rejected before source access | every build and Windows gate; Endpoint Security |
| FF-G4-12 | tenant policy can only narrow | exhaustive finite-domain laws and mutation tests | no generated counterexample where effective capability exceeds product ceiling; unknown/incomparable disables | every policy schema/evaluator change; Privacy Policy owner |
| FF-G4-13 | hard deny dominates allow/match | generated predicate/rule conflicts | every denied case emits no application event regardless of priority/rule | every deny/matcher update; Product Privacy/Security |
| FF-G4-14 | minimized output is a closed allowlist | JSON Schema/serializer snapshot and field-provenance checker | no unknown field; every field has product + tenant authorization and declared derivation; source object never cloned | every contract/transform change; Contract/Privacy owner |
| FF-G4-15 | time reduction never increases precision or time | boundary/property vectors | UTC floor exactly to declared precision; output ≤ source time; retry stable | every time/identity change; Data Contract owner |
| FF-G4-16 | rejected-value telemetry is finite and value-free | descriptor lint, cardinality enumeration, sink scan | only approved fixed dimensions/codes; no exact length/value/host/app/rule/realm/user/session/exemplar; within approved series budget | every observability change and release; SRE/Privacy |
| FF-G4-17 | malformed/large input is resource-bounded | million-case campaign and Task Host job counters | zero crash/hang/OOM; no monotonic handle/thread growth; input/page/time/allocation caps enforced; cleanup complete | every parser/runtime change; Runtime/AppSec |
| FF-G4-18 | G4 dispositions preserve G5 crash invariant | failpoint transaction matrix | cursor never ahead; event/no-event fact atomic; uncertainty no progress; retry one business effect; ACK after commit | every G4/G5 contract/storage change; Endpoint Storage |
| FF-G4-19 | rollout is consumer-first and reversible | old/new normalizer/PSL/snapshot/release matrix | unsupported candidate never partially activates; no lower sequence; one active semantic path; same-digest release rollback plus higher-sequence controls | each rollout plan; Release/Policy |
| FF-G4-20 | dependency evidence is exact | source/package/binary hash, license, SBOM/provenance and admission record | every runtime/build/test dependency maps to reviewed source or is no-go; no mutable tag/latest lookup | each dependency update; Supply Chain/Legal/Security |
| FF-G4-21 | incident controls work without source visibility | synthetic kill/recovery drill | new permits stop within measured local bound; no self-reenable; recovery artifact authorized; all-sink suite passes; cleanup receipt complete | before pilot and at defined drill cadence; Incident Response |
| FF-G4-22 | administrative review is accessible and non-deceptive | keyboard/screen-reader/contrast/text-semantic tests with synthetic IDNs | A-label and Unicode display available; warnings not color-only; exact/suffix/apex/port and conflict semantics perceivable/operable | each rule-review UI release; Admin UX/Governance |
| FF-G4-23 | data-quality outcomes remain distinct | schema/state and aggregate tests | `INVALID`, `HARD_DENY`, `UNMATCHED`, `AMBIGUOUS`, `DISABLED`, `DEFERRED` never collapse into one business event/status | every contract/report change; Data Governance |
| FF-G4-24 | evidence contains no confidential connection or source material | evidence-package lint and canary scan | no SSH details, credentials, internal addresses, real URLs, user data, profile paths or raw production activity | every CLI/lab evidence publication; Lab/Privacy owner |

## 9.2 Primary G4 acceptance criteria

G4 may be marked **passed for a named synthetic release/environment only** when all of the following hold:

1. Golden vectors exist before production logic and the independent reference project has no production-code dependency.
2. The exact one-million-case campaign completes with exactly 1,000,000 classified cases, zero crash/hang/OOM, zero unclassified parser/IDNA/PSL/matcher difference, and zero mandatory canary escape.
3. The full disposable-Windows chain proves that raw URL, host source spelling, userinfo, path, query, fragment, title, source/profile path, identity, and prohibited derivative do not appear in either IPC leg, SQLite/WAL/SHM, logs, traces, metrics, HTTP capture, crash artifacts, or support bundle.
4. Every cross-application maximal conflict returns `AMBIGUOUS`; every cross-realm attempt returns no candidate/result; every tenant broadening attempt fails closed.
5. Exact runtime, Unicode, normalizer, special-use registry, PSL, matcher, snapshot, policy, contract, generator, scanner and build identities are present in evidence.
6. G4/G5 failpoints prove no cursor ahead of event/no-event fact, no progress on uncertainty, one retry effect, and ACK only after commit.
7. Kill switch, `SafetyHold`, higher-sequence recovery and complete cleanup are demonstrated.
8. Accountable owner functions and runbooks are assigned; all HUMAN DECISION items required for the claimed output remain either approved or technically disabled.

Passing this gate does not approve legal purpose, live Edge collection, production fields, site semantics, identity, retention, capacity, pilot, or production deployment.

## 9.3 Release-blocking thresholds

The following thresholds are exact, not estimates:

- forbidden canary/derivative escapes: **0**;
- unauthorized cross-realm matches/results: **0**;
- guessed cross-application ambiguities: **0**;
- tenant-policy broadening counterexamples: **0**;
- cursor-ahead states: **0**;
- unclassified semantic differences in mandatory corpus: **0**;
- mandatory scanner positive-control misses: **0**;
- undeclared runtime/data/dependency identities: **0**;
- orphan Task Host/process/file/rule/certificate after cleanup: **0**.

Input/page/time/allocation limits, metric-series budget, alert thresholds, support windows, and operational SLOs remain **ESTIMATE**, **CLI EXPERIMENT**, or **HUMAN DECISION** until measured and approved.

---

# 10. Human decisions and owner questions

Research does not approve the following decisions. “Conservative temporary default” is the behavior that keeps implementation testable without claiming production authority.

| ID | HUMAN DECISION | Options and consequences | Conservative temporary default | Accountable role/function | Owner question / evidence needed | Blocks |
|---|---|---|---|---|---|---|
| HD-G4-01 | approved site/domain/path output | **A:** application ID only—least URL disclosure but no site analytics. **B:** registrable domain—coarser, depends on PSL mode. **C:** canonical full host—more precise and more sensitive. **D:** path—materially broader and outside first-slice approval; requires new source/field/deny/threat model. **E:** no event. | no production event; synthetic contracts support `APPLICATION_ID_ONLY`, with site fields disabled; path is forbidden | Product/Data Owner with Privacy and Legal | What exact business purpose needs each field, who may access it, and why can application ID or no event not satisfy it? | live G4 output/pilot |
| HD-G4-02 | time output and precision | omit time; coarse UTC day/hour/bucket; finer precision. Finer values improve sequence/analysis but increase linkability and scoring risk. | no production event; when approved, coarsest permitted UTC floor, tenant may narrow further | Product/Data Owner with Privacy | What decision requires time, what is the minimum useful precision, and how will replay/aggregation/identity use it? | event schema/identity |
| HD-G4-03 | identity level | no person identity; realm-scoped pseudonymous subject; device/session-derived relation; named identity. More stable/fine identity increases governance, access, deletion and misuse risk. | no person/user/session identity in event | Data Controller/Product Owner with Privacy/IAM | Is subject attribution necessary for the approved purpose, and what governed server-side projection/revocation contract exists? | identity field, reports |
| HD-G4-04 | hard-deny categories | structural only; release-owned sensitive categories; tenant-added deny; category-specific no-event progress. Overbroad deny reduces coverage; underbroad deny risks collection. | structural suppression of IP/local/special-use; live semantic category registry empty, so live output remains disabled | Product Privacy Authority with Security/Legal | Which categories are prohibited regardless of allowlist, who classifies domains without observing employee activity, and how are false positives appealed? | live permit/deny artifact |
| HD-G4-05 | public-suffix business semantics | `DISABLED`; ICANN only; ICANN+PRIVATE. ICANN-only may group hosted tenants; PRIVATE may reduce grouping but follows community policy and changes more often. | PSL cannot authorize collection; PSL-dependent site output disabled; exact host rules only | Product/Data Governance with Privacy | What does “site” mean for the approved purpose, how should hosted platforms be treated, and what change-management tolerance exists? | site output/rule family |
| HD-G4-06 | Unicode IDN support | ASCII-only; accept UTS #46 Unicode input and emit A-label; display Unicode only in governed admin UI. ASCII-only reduces attack surface but misses valid IDNs. | feature flag `RequireAsciiHostOnly`; Unicode path remains synthetic until IDNA gate and approval | Product Owner with Security/Accessibility | Is valid IDN coverage needed, and can support/review staff safely interpret A-label/Unicode/confusable warnings? | Unicode production enablement |
| HD-G4-07 | non-default ports | reject all; allow exact release-owned ports; collapse ports (not recommended). Exact ports expand rule surface; rejecting may miss applications. | reject all non-default ports | Product/Registry Governance with Security | Which application purpose requires port distinction, and can rules be explicitly governed/tested? | non-default port rules |
| HD-G4-08 | unmatched/ambiguous behavior | no event + progress; defer for rule correction; quarantine bounded occurrences; emit unassigned site (broader disclosure). | no activity event; deterministic invalid/hard-deny may be `CONSUMED_NO_EVENT` only after G3/G5 owner approves; authority uncertainty defers | Product/Data Governance and Endpoint Operations | Is coverage loss acceptable, what backlog pressure is tolerable, and may any unassigned site value be stored? | disposition/runbook |
| HD-G4-09 | legal purpose, lawful basis, notices and prohibited uses | organization-specific legal/governance decision; technical design cannot resolve it | synthetic data only; no live source | Data Controller/Business Owner with Legal/Privacy and workforce consultation authority | What exact purpose and prohibited-use policy applies, including ban on sole forensic proof/productivity scoring? | all live collection |
| HD-G4-10 | source authorization and first-run lookback | no source; Edge history with bounded lookback; other sources. Larger lookback increases volume/privacy/incident scope. | G4 accepts synthetic observation adapter only; live Edge requires G2/G3 and governance | Product Privacy/Data Owner | Which source fields and lookback are authorized, and what evidence supports minimum necessary range? | live acquisition/run |
| HD-G4-11 | retention, deletion, legal hold and backups | field/event/diagnostic/evidence-specific periods; deletion scope and exceptions | no production retention selected; T1 evidence follows test-package lifecycle | Records Management/Data Controller with Privacy/Legal | What is retained at endpoint/server/log/audit/evidence layers, how is deletion proven, and what legal holds apply? | production storage/support |
| HD-G4-12 | access and administrative approval roles | separate authors/reviewers/publishers; emergency authority; support read access | no production publication; owner fields cannot be `UNASSIGNED` for candidate artifacts | Security IAM/Product Governance | Who may author, approve, publish, revoke and view rules/policies/incidents, and what separation is required? | signed artifacts/control plane |
| HD-G4-13 | policy/snapshot signing and offline validity | exact key hierarchy, quorum, expiry, clock tolerance and recovery | unsigned synthetic artifacts only; invalid/expired production authority would disable | Signing/Cryptographic Authority with Security/Operations | What KMS/HSM/PKI and offline risk model is approved, and how is compromise/freeze recovered? | production artifacts |
| HD-G4-14 | supported Windows/runtime estate | named Windows builds/architectures, RDS/VDI/FSLogix/Citrix/EDR combinations | no support claim outside exact disposable lab image | Endpoint Platform/Product Support | Which environments are supported and available for hostile/all-sink evidence? | G4 Windows gate/release |
| HD-G4-15 | crash dump, WER, EDR and remote support policy | disable raw dumps; encrypted/restricted synthetic-only dumps; vendor capture controls; emergency process | full/raw automatic Task Host dump disabled; support bundle excludes process memory and raw traces | Endpoint Security/Operations/Incident Response | Which enterprise agents can capture memory or network, where artifacts go, and how are access/deletion/notification handled? | incident/runbook/pilot |
| HD-G4-16 | observability cardinality, alerting and access | fixed global aggregates; per-realm server-side aggregates; rare-event suppression; retention | fixed value-free endpoint dimensions only; no realm/app/rule/host/user labels | SRE with Privacy/Data Governance | What series budget, alert thresholds, audience and retention are justified without exposing rare populations? | production telemetry |
| HD-G4-17 | normalizer/PSL support and deprecation window | current only; current+rollback; longer offline support | installed release supports current plus explicitly authorized rollback semantics only; no indefinite compatibility promise | Product/Release/Support | What fleet offline/upgrade distribution and support commitment justify each window? | rollout/removal |
| HD-G4-18 | dependency/license acceptance | .NET-only wrapper; native Ada; PSL library; reference runners in CI; in-house finite parser components | .NET platform candidate behind wrapper; Ada/Rust/WPT/Unicode reference-only; pinned PSL data subject to license approval | Legal/Procurement/Security/Engineering | Are MPL-2.0 data distribution, native ABI/support, and test-tool licenses acceptable, and who owns updates? | dependency admission |
| HD-G4-19 | resource budgets and SLO/RPO/RTO | input/page/runtime/disk/backlog/kill/restore objectives | hard safety bounds remain bootstrap estimates and fail closed | Product/Operations/SRE | What measured endpoint budgets and outage/backlog objectives are acceptable across supported estate? | production tuning/capacity |
| HD-G4-20 | support staffing and incident ownership | business-hours/on-call, escalation, privacy/security incident integration | no pilot until named owners, support hours and drills exist | Engineering Leadership/Operations/Privacy/Security | Who owns parser, IDNA, PSL, rule, privacy escape, support and recovery at all hours claimed? | pilot/production |
| HD-G4-21 | production risk acceptance and pilot scope | no pilot; fictional lab; limited named ring; production rollout | fictional lab only | Designated Production/Risk Authority | Which evidence/remaining risks are accepted, for what ring/duration/rollback conditions? | pilot/production |

## 10.1 Consequence of delayed decisions

Delay does not justify a permissive default. The architecture remains implementable with synthetic inputs, exact contracts, disabled output fields, exact-host fictional rules, value-free telemetry and kill switches. Live collection, broader fields, PSL-derived site output, identity, non-default ports, Unicode input and production rollout remain technically disabled until the relevant decision and proof gate both exist.

---

# 11. CLI experiments/measurements and the exact evidence they must produce

## 11.1 Evidence envelope

Every command below runs from a clean checkout or a disposable, reverted Windows VM and emits one `g4-evidence.json` record with this minimum schema:

```json
{
  "schemaVersion": "1.0.0",
  "experimentId": "E-G4-00",
  "claim": "one falsifiable sentence",
  "classification": "T1",
  "startedAtUtc": "<RFC3339-Z>",
  "endedAtUtc": "<RFC3339-Z>",
  "sourceTreeSha256": "<digest>",
  "configurationDigests": ["<digest>"],
  "runtime": {
    "dotnetSdk": "<exact>",
    "dotnetRuntime": "<exact>",
    "osBuildClass": "<sanitized>",
    "architecture": "<exact>",
    "runnerImageDigest": "<digest>"
  },
  "inputs": [{"id":"<T1 package>","rootSha256":"<digest>"}],
  "commands": [{"argvRedacted":"<command with placeholders>","exitCode":0}],
  "artifacts": [{"relativePath":"<safe path>","sha256":"<digest>","classification":"T1"}],
  "assertions": [{"id":"<id>","result":"PASS"}],
  "canaryScan": {"scannerDigest":"<digest>","positiveControlsPassed":true,"escapes":0},
  "cleanup": {"result":"PASS","receiptSha256":"<digest>"},
  "ownerFunction": "<assigned function>",
  "reviewerFunction": "<independent function>"
}
```

The evidence MUST NOT contain connection commands, usernames, hosts, addresses, ports, key paths, credentials, real identities, internal URLs, raw browser activity, or confidential configuration. A failed first run remains in evidence; a retry is a new linked record.

## 11.2 Ordered CLI lane

The commands are illustrative repository contracts; exact project paths may be adjusted by the accepted repository ADR without weakening evidence. `<...>` values are local placeholders and are never copied into shareable evidence.

| ID | Command outline | Exact evidence required | Pass / stop |
|---|---|---|---|
| E-G4-00 | `sha256sum <five-allowlisted-inputs> > artifacts/g4/input-manifest.sha256` and repository evidence linter | names, sizes, hashes, allowlist assertion, prompt/result path | exact allowlist only; missing/extra input stops research/review |
| E-G4-01 | `dotnet --info`; `dotnet workload list`; `dotnet nuget list source`; runtime source-ID helper | exact SDK/runtime/host/OS/arch, `global.json`, lock/source mapping, candidate assembly/file digests | unsupported/floating/unmapped input stops implementation |
| E-G4-02 | `dotnet test tests/G4.Golden --no-restore --configuration Release` **before** production project exists | vector/package roots, independent reference graph, expected-result snapshot, deliberate failing placeholder proof | golden corpus exists and fails for absent logic as expected; production-first sequence stops |
| E-G4-03 | `dotnet test tests/G4.Architecture --filter RawTypeBoundary` plus mutation script | project/API/serializer graph and each forbidden mutation result | every raw type/object/dictionary/hash/log mutation fails; one survivor stops |
| E-G4-04 | `dotnet run --project tools/Uam.UrlProfile.Check -- vectors/g4/cross-language.ndjson --emit-safe-results ...` | CV-001–052 exact matrix, stage/reason/canonical tuple, no input echo | exact matrix; any mismatch stops |
| E-G4-05 | `dotnet run --project tools/Uam.Idna.Check -- --uts46 <pinned> --unicode 17.0.0 --nontransitional --std3 --bidi --joiner` | UTS #46 data digest/revision, options, accepted/error/round-trip counts, minimal diffs | zero unclassified diff; any error accepted stops |
| E-G4-06 | isolated runner commands for exact Node/WHATWG, Ada and Rust revisions; aggregate with `Uam.UrlDifferential` | source/binary/container digests, normalized result matrix, classification owner/rationale | zero unclassified difference; mutable/latest runner stops |
| E-G4-07 | `dotnet run --project tools/Uam.Psl.Check -- --list <pinned-file> --sha256 <expected> --mode <explicit>` under denied network | PSL commit/file digest/license record, lint/dual-parser results, wildcard/exception/private cases, egress capture | exact agreement, zero egress, corrupt/mismatch rejection; otherwise stop |
| E-G4-08 | `dotnet test tests/G4.Matcher --configuration Release` and `dotnet run --project tools/Uam.RuleAnalyze -- --snapshot <T1>` | 50k rule seed/root, maximal-set comparisons, overlap/shadow/ambiguity witnesses, realm negatives | no order dependence/guessed tie/cross-realm result; analyzer `UNKNOWN` blocks publication |
| E-G4-09 | `dotnet test tests/G4.Policy --filter Monotonicity` with exhaustive small-domain generator/mutations | meet-law/counterexample report, product/tenant schema digests, mutation results | zero broadening/wrong realm/lower revision; otherwise SafetyHold and stop |
| E-G4-10 | `dotnet run --project tools/Uam.G4Corpus -- generate --cases 1000000 --seed <fixed> --out <ephemeral>` | exact partition counts, generator/seed/config/root, determinism two-run comparison | exactly 1,000,000 and byte-identical canonical root; otherwise stop |
| E-G4-11 | `dotnet run --project tools/Uam.G4Fuzz -- --corpus <ephemeral> --per-case-timeout <estimate> --evidence <dir>` | case/result counts, crash/hang/OOM/unclassified diff totals, minimized failing reproducers, resource histograms | all mandatory totals zero; any failure stops release |
| E-G4-12 | `dotnet run --project tools/Uam.CanaryScan -- self-test --registry <T1>` | every marker/sink/encoding/known-derivative positive-control result, scanner/config/binary digests | 100% mandatory detection before sink scan; one miss stops |
| E-G4-13 | `dotnet test tests/G4.Observability` and `Uam.MetricLint` | descriptor schema, fixed dimensions, exact possible-series calculation, mutation failures, scrape scan | no dynamic/sensitive label/exemplar; within human-approved budget before production |
| E-G4-14 | single-process transform harness with stdout/stderr/log/trace/temp/coverage captures, then canary scan | output schema bytes, complete file/capture manifest, canary/derivative scan | zero escape and exact result; otherwise incident/stop |
| E-G4-15 | placeholder-only PowerShell: `pwsh -File .\eng\windows\g4-lab-preflight.ps1 -Mode ReadOnly -EvidenceDir <local>` | script hashes, placeholder lint, sanitized OS/runtime/agent capability categories | no connection/identity/address/credential; unsupported environment not claimed |
| E-G4-16 | on approved disposable VM: `pwsh -File .\eng\windows\g4-install-and-run-synthetic.ps1 -EvidenceDir <local>` | signed lab-build digest, service/task/token/process categories, both IPC captures, SQLite/log/ETW/metric/network/support manifests | only synthetic minimized result; no cross-session/realm/raw value; otherwise stop |
| E-G4-17 | `pwsh -File .\eng\windows\g4-crash-and-containment.ps1 -EvidenceDir <local>` | WER/dump policy, forced-stage crash results, job/kill/cancel/resource evidence, dump/support scans | no automatic raw full dump/egress/canary; no orphan/residue; otherwise stop |
| E-G4-18 | `dotnet test tests/G4.G5.Failpoints --configuration Release` | failpoint matrix around event/no-event/progress/commit/ACK, truth ledger, scanned DB/WAL/SHM digests | zero cursor-ahead/loss/double effect; ACK after commit; otherwise G4/G5 gate fails |
| E-G4-19 | `dotnet run --project tools/Uam.G4Compatibility -- --matrix contracts/g4/compatibility.yaml` | old/new endpoint/normalizer/Unicode/PSL/snapshot/policy matrix and activation traces | consumer-first, no partial activation/lower sequence/duplicate event; otherwise stop |
| E-G4-20 | `pwsh -File .\eng\windows\g4-incident-drill.ps1 -Scenario <synthetic> -EvidenceDir <local>` | kill-switch latency, permit cancellations, `SafetyHold`, higher-revision recovery, runbook/audit/cleanup outputs | new work stops; no self-reenable; complete recovery and clean bundle; otherwise stop |
| E-G4-21 | `dotnet run --project tools/Uam.G4Gate -- --evidence artifacts/g4 --out artifacts/g4/g4-gate.json` | immutable index of every required evidence/ADR/owner/human-disable state and SHA-256 | every primary assertion pass, no expired exception/UNASSIGNED blocker; otherwise no G4 acceptance |

## 11.3 Required negative and mutation commands

At minimum, CI MUST inject and revert these changes and prove that the gate fails:

```text
trim input before validation
replace '\\' with '/'
allow unknown scheme or missing '//'
allow userinfo or authority percent
use transitional IDNA
skip Bidi/Joiner/round-trip validation
accept legacy numeric IPv4 as DNS
silently ignore a non-default port
auto-download latest PSL
change PRIVATE mode without artifact version
match suffix by string EndsWith
choose first or lexicographically smallest ambiguous rule
remove realm from a cache key
let tenant enable a product-disabled field/feature
copy raw source DTO into result
add SHA-256(rawUrl) to diagnostic output
log exception with input argument
add host/application/realm as metric label
map parser/resource/SafetyHold failure to consumed progress
ACK before SQLite commit
activate lower snapshot sequence
permit scanner directory wildcard
```

Every mutation must be independently identified in evidence, fail for the intended assertion, and be reverted with a clean-tree digest. A mutation suite that fails only because the project does not compile is useful for architecture boundaries but does not replace runtime behavior mutations.

## 11.4 Bounded measurements that replace estimates

The CLI lane must measure rather than assume:

- maximum source scalar/byte length needed for the approved Edge source while preserving safety;
- per-observation and per-page CPU, wall time and allocation on each supported environment;
- Task Host working set, handles, threads, scratch and kill/cancel latency;
- actual fixed metric-series count and event/log volume;
- PSL file/load/memory/update-diff size;
- rule snapshot size, load time, candidate count and worst-case overlap analysis;
- normalizer/PSL/runtime semantic-diff frequency across servicing updates;
- full-chain canary scan time/artifact storage cost;
- fail-closed backlog/retry behavior under long outage;
- support and incident drill effort.

These measurements do not set budgets. They produce replaceable inputs for the accountable product, SRE, endpoint platform, security, privacy, licensing and finance decisions.

---

# 12. ADR proposals: decision, status, alternatives, rationale, evidence, owner, review trigger

No ADR below changes an accepted Batch 01 invariant. An ADR cannot be marked `Accepted` for production while its accountable owner is unassigned, its named CLI gate has not passed, or a required HUMAN DECISION remains technically enabled by default.

| ADR | Decision | Proposed status | Alternatives considered | Rationale and evidence | Accountable owner function | Review trigger |
|---|---|---|---|---|---|---|
| ADR-G4-001 | Raw URL handling and all canonicalization/deny/match/minimization occur inside the short-lived Task Host; only minimized DTO or value-free disposition may cross Task Host → User Host IPC | **Accept as G4 invariant; CLI proof mandatory** | raw to User Host; raw to Coordinator; central transformation | strongest implementation of accepted privacy boundary; User Host is also outside raw-value trust; CAN-TASK/CAN-E2E and FF-G4-01/02 | Endpoint Architecture + Product Privacy | any source/collector topology change; inability to meet sink gate |
| ADR-G4-002 | Adopt strict `uam-url-v1`: no trim/recovery/base resolution/backslash/userinfo/authority percent; absolute HTTP(S) only | **Accept for first slice** | RFC 3986-only parser; full WHATWG browser parser; permissive `.NET Uri` use | browser recovery is useful for navigation but increases canonicalization ambiguity; strict gate is smaller and independently testable | URL Standards / Endpoint Security | new approved scheme/source; candidate parser incompatibility; corpus counterexample |
| ADR-G4-003 | Use an admitted C#/.NET parser adapter behind UAM pre/post-validation; platform parser is a candidate implementation, not the specification | **Accept direction; exact patch gated** | custom parser; Ada native dependency; Rust native dependency; browser component | matches accepted C# family and lowest operational footprint; independent references contain semantic/runtime risk | Endpoint Engineering / Release | runtime patch semantic diff, security advisory, performance or unsupported required behavior |
| ADR-G4-004 | Use UTS #46 non-transitional with fixed Unicode data, STD3/Bidi/Joiner checks, error rejection, ASCII A-label output and round-trip/DNS validation | **Accept technical profile; production Unicode enablement deferred** | transitional processing; IDNA2008-only custom stack; ASCII-only forever | current Unicode guidance favors non-transitional processing; exact vectors make behavior reviewable; ASCII output avoids source spelling escape | Internationalization + Security | Unicode/runtime update, IDNA defect, human choice to remain ASCII-only |
| ADR-G4-005 | Reject all IP literals and legacy numeric forms; accept/remove exactly one DNS trailing dot; omit default ports; reject non-default ports unless exact release-owned authorization exists | **Accept for first slice** | treat IP as host; browser numeric canonicalization; ignore every port | reduces local/topology collection and parser tricks; keeps host identity explicit | Endpoint Security + Registry | approved IP-based use case or non-default-port requirement with new privacy/threat proof |
| ADR-G4-006 | Pin PSL locally by digest and parser/version; no runtime network/update; PSL is structural data, never authorization | **Accept invariant** | live auto-update; DNS/public lookup; no list under any mode | deterministic offline behavior and release authorization; list changes can alter site boundary and must be reviewed | Registry Publication + Release | list/license/format change, parser defect, measured inability to operate offline |
| ADR-G4-007 | Keep `pslMode` (`DISABLED`, `ICANN_ONLY`, `ICANN_AND_PRIVATE`) explicit; site output and private-domain semantics require human approval | **Proposed / HUMAN DECISION pending** | silently use entire list; ICANN-only fixed; derive business meaning from PSL | PSL does not define UAM business purpose or ownership; modes have materially different grouping consequences | Product/Data Governance + Privacy | accountable decision, changed purpose, hosted-platform evidence |
| ADR-G4-008 | Use closed exact/suffix host grammar with explicit apex/scheme/port, all-rule evaluation, priority/family/partial-order specificity, and `AMBIGUOUS` for cross-app maximal ties | **Accept from predecessor and specialize** | first-match; regex/wildcard; fuzzy/name mapping; general policy engine | preserves deterministic application identity/ambiguity and analyzability; matches Batch 01 accepted registry contract | Application Registry | new matcher family; analyzer `UNKNOWN`; business demand for path/process matching |
| ADR-G4-009 | Hard deny executes after canonical structural derivation and before application allow/match; tenant may only add/narrow; denied input emits no activity event | **Accept mechanism; category content HUMAN DECISION** | allowlist first; central post-ingest deny; tenant executable expressions | deny must dominate every allow and stay endpoint-side; finite release-owned predicates preserve monotonic proof | Product Privacy + Security | approved deny-category change, false-positive incident, insufficient finite grammar |
| ADR-G4-010 | Construct new closed minimized output type; raw source types, component values and reversible derivatives are forbidden from shared contracts/IPC/storage/diagnostics | **Accept as invariant** | clone then redact; omit selected JSON fields; hash/HMAC raw URL | allowlist construction is easier to review than subtraction; hashes remain linkable/reversible for small domains | Contract Authority + Privacy/AppSec | new output field or identity requirement; architecture-test limitation |
| ADR-G4-011 | Time uses explicit UTC floor to approved precision; raw/local time and random jitter are not default; person identity absent unless a separate governed projection is approved | **Technical rule accepted; precision/identity HUMAN DECISION** | local time; nearest rounding; random jitter; raw SID/name/hash | stable, non-future buckets preserve retry semantics; identity cannot be invented from endpoint display data | Data Contract + Privacy/IAM | approved purpose/precision/identity contract or replay defect |
| ADR-G4-012 | Rejection/health telemetry uses finite codes, length/latency/resource buckets and fixed dimensions; never value/host/hash/app/rule/realm/user/session/exact length | **Accept, budget deferred** | detailed exception/value logs; per-realm/app labels; no telemetry | supports detection without building a secondary observation channel; cardinality remains bounded | SRE + Privacy | incident cannot be diagnosed with approved fields; measured budget/rare-population risk changes |
| ADR-G4-013 | `normalizationVersion` binds lexical, runtime, Unicode, IDNA, IP, port, special-use, PSL, error-map and corpus semantics; changed outcome requires new version or explicit compatibility record | **Accept** | assembly version only; latest-data semantics; reinterpret old events | makes data quality and rollout auditable; prevents patch/list drift from silently changing attribution | Contract/Release | any runtime/data update or newly classified differential |
| ADR-G4-014 | Normalizer/snapshot rollout is consumer-first; candidate activation is atomic and monotonic; unsupported/corrupt/rollback states follow Batch 01 LKG/SafetyHold rules; no dual business events | **Accept** | producer-first; lower-sequence rollback; dual emit for comparison | preserves offline compatibility and one business effect; synthetic dual evaluation supplies comparison without extra collection | Release/Policy/Endpoint | compatibility matrix failure, long-offline fleet evidence, incident recovery defect |
| ADR-G4-015 | Every deterministic non-event has an explicit G4→G5 disposition; uncertainty/security/resource failures never advance source progress; event/no-event fact and cursor commit atomically | **Accept logical contract; G5 proof required** | drop-and-advance generically; retry every invalid row; G4 writes cursor | protects cursor invariant while preventing raw dead-letter storage; exact permanent/transient mapping is reviewable | Endpoint Data + Storage | G3 source semantics, G5 failpoint failure, persistent malformed-row backlog |
| ADR-G4-016 | Exact million-case deterministic fuzz/canary campaign, cross-language vectors and all-sink Windows proof are mandatory before G4 acceptance | **Accept gate** | unit tests only; production shadow mode; sample fuzzing | high-risk parser/privacy boundary needs both semantic and leakage falsification; production raw shadowing is prohibited | Test Architecture + AppSec | superior reproducible method with equal or stronger falsification evidence |
| ADR-G4-017 | Runtime/build/test open-source artifacts require exact revision, source/package mapping, license/security/test review and classification as dependency/reference/neither | **Accept** | popularity/latest version; copy snippets; unpinned CI download | parser/PSL/test code is executable/data supply-chain input; point-in-time review is mandatory | Supply Chain + Legal/Security | dependency/release update, advisory, maintenance/provenance change |
| ADR-G4-018 | G4 has source-specific narrowing flags and protected kill/SafetyHold controls; a broadening transition is a release/policy change, never an ordinary toggle | **Accept** | unrestricted feature flags; operator configuration; no local kill | supports incident containment while preserving product ceiling/tenant monotonicity | Release/Privacy/Incident Response | incident drill failure, offline recovery evidence, feature-control redesign |
| ADR-G4-019 | Production Task Host full-memory dumps and raw support bundles are disabled; synthetic controlled crash evidence is allowed only in disposable lab and scanned before retention | **Proposed; enterprise policy decision required** | normal full dumps; always-on remote trace; no crash evidence | immutable managed strings cannot be zeroized; crash/support tooling can bypass application privacy boundary | Endpoint Security/Operations | enterprise EDR/WER requirement, inability to diagnose with safe evidence, approved compensating controls |
| ADR-G4-020 | Administrative rule review shows A-label and Unicode display with textual confusable/semantic warnings and accessible exact/suffix/apex/port/conflict explanation; never uses raw observed URLs as examples | **Proposed for future admin UI** | Unicode-only; A-label-only; production examples | supports correct governance and accessibility without exposing observed activity | Admin UX + Registry Governance | portal design, accessibility testing, new matcher semantics |

## 12.1 Explicit change-proposal status

**FACT.** This result does not conflict with the accepted baseline or Batch 01 predecessor. It strengthens the location of the already accepted minimization boundary by making Task Host → User Host the first serialized boundary. This is a refinement of the accepted User Host/Task Host design, not a request to move source access to the Coordinator or alter G1 authority.

If later evidence shows that the Task Host cannot perform the fixed transformation safely, the change proposal must identify:

- the affected privacy invariant;
- why a larger raw-value trust boundary is unavoidable;
- new primary evidence;
- the smallest falsifying prototype;
- alternative process/handle designs;
- migration, support and incident cost; and
- the ADRs and prior gate results invalidated.

A performance or implementation-convenience argument alone is insufficient.

---

# 13. Ordered implementation backlog with dependencies and stop gates

## 13.1 Backlog

| Order | Repository task | Depends on | Deliverable / definition of done | Stop gate |
|---:|---|---|---|---|
| 1 | record G4 input/evidence manifest and result ADR set | Batch 01 accepted result | five-file allowlist hashes, public-source register, ADR owner fields | missing/extra source or silent predecessor conflict |
| 2 | assign accountable functions and create human-decision records | governance | owners/support/escalation for URL profile, IDNA, PSL, rules, privacy, storage, release, AppSec, incident | blocking owner remains `UNASSIGNED` |
| 3 | create G4 contract catalogue entries and closed schemas | Batch 01 contract standard | observation view, canonical internal tuple, event, rejection, disposition and provenance schemas | raw/source field or extension bag appears in shared contract |
| 4 | create declarative CV-001–052 golden vectors and expected reference results | 3 | reviewed T1 corpus and independent reference project, before production parser | production logic merged first or oracle references production |
| 5 | add raw-type/forbidden-API architecture rules and mutations | 3 | Task Host-private source types; serializer/dependency/log/hash guard | raw type/generic object/clone/hash/log mutation passes |
| 6 | lock exact .NET/runtime/toolchain and reference-runner inputs | repository/dependency policy | `global.json`, package/tool/source locks, exact runner/container/source IDs | floating/latest/unmapped executable input |
| 7 | implement strict UTF-16 scalar/length/whitespace/control/percent/backslash/scheme/authority scanner | 4–6 | pure allocation-bounded scanner with stable stages/reasons | any unsafe recovery vector/mutation passes |
| 8 | implement candidate parser adapter and boundary-agreement assertions | 7 | wrapper with no base resolution, value-free exception boundary and exact runtime provenance | candidate-only boundary reaches output |
| 9 | implement IDNA adapter and DNS/A-label postvalidation | 4, 6–8 | UTS #46 fixed profile, errors, round trip and length checks | unclassified IDNA difference or error accepted |
| 10 | implement IP/legacy numeric and port/trailing-dot gates | 4, 7–9 | exhaustive generated recognizer vectors and exact canonical tuple | one IP bypass or silent port/dot normalization |
| 11 | import and verify pinned IANA special-use and PSL test artifacts under license/admission record | 2, 6 | content-addressed local data, no-network loader, format/lint evidence | runtime fetch, digest mismatch, legal/provenance gap |
| 12 | implement bounded PSL parser/adapter and independent test comparator | 11 | explicit mode/facts, wildcard/exception/private handling, corrupt-file rejection | parser difference, silent fallback, PSL used as application authority |
| 13 | implement release-owned structural/hard-deny finite predicates | 3, 9–12 | typed IDs and product/tenant monotonic tests; category set empty for live use pending decision | tenant executable logic/broadening or deny after match |
| 14 | implement exact/suffix matcher and independent finite reference | 3–4, 9–12 | all-rule maximal-set evaluation, deterministic ambiguity, order/realm properties | guessed tie, string suffix, cross-realm result |
| 15 | implement snapshot compiler overlap/shadow/ambiguity analyzer | 14 | fictional witnesses, publication blockers, normalizer/PSL binding | analyzer `UNKNOWN` treated as safe or unresolved cross-app conflict published |
| 16 | implement field/time/identity reduction as new closed DTO | 3, 13–15 | allowlisted constructor, product/tenant authorization proof, disabled live output modes | clone/redact, forbidden field/derivative, unapproved precision/identity |
| 17 | implement value-free rejection/disposition map and observability schema | 3, 7–16 | finite codes/buckets/dimensions, metric lint/cardinality calculation | exact length/value/dynamic label or uncertainty mapped to progress |
| 18 | implement exact canary registry/scanner and self-test positive controls | G0/Batch 01 scanner boundaries, 3–17 | encoding/sink/known-derivative matrix with exact exceptions | one mandatory marker miss or broad allowlist |
| 19 | build exact cross-language runner harness | 4, 6, 8–12 | .NET/WHATWG/Ada/Rust/UTS46/WPT result normalization and classification | unpinned runner or unclassified difference |
| 20 | build deterministic one-million-case generator and reference properties | 4, 7–19 | exact seven partitions/seed/root and two-run determinism | count/root mismatch or production-code oracle |
| 21 | execute pure million-case fuzz/resource campaign | 18–20 | zero mandatory failures, minimal T1 reproducers, resource histograms | crash/hang/OOM/canary/unclassified diff/property failure |
| 22 | integrate fixed G4 capability into synthetic restricted Task Host | G1 passed, 5–21 | raw adapter + transform + result serializer; no browser profile/live data | architecture violation, arbitrary path/capability, unsafe dump/log |
| 23 | run Task Host single-process all-sink campaign | 22 | pipe/output/log/ETW/metric/temp/dump/support manifest and scanner pass | one escape/derivative/residue |
| 24 | integrate synthetic User Host/Coordinator validation path | 3, G1, 22–23 | permit/digest/schema validation and minimized-only IPC chain | User Host/Coordinator sees raw type/value or accepts wrong realm/version |
| 25 | implement G4→G5 disposition contract and SQLite failpoint prototype | G3 semantics available, 17, 24 | atomic event/no-event/progress/cursor and ACK evidence | cursor ahead, uncertainty progress, duplicate/loss |
| 26 | run full disposable-Windows end-to-end canary/crash/lifecycle campaign | approved lab, 18, 22–25 | CAN-E2E/CRASH/cleanup evidence for each claimed environment | escape, cross-session/realm, auto-upload, orphan/residue |
| 27 | implement consumer-first normalizer/PSL/snapshot compatibility matrix and activation | 6, 11–17, 24 | atomic activation/LKG/SafetyHold/higher-sequence rollback and no dual event | lower sequence, partial activation, silent semantic drift |
| 28 | implement source-specific kill switches and recovery self-test | policy/signed-artifact profile, 24–27 | narrowing-only controls, permit cancellation, protected local hold | broadening flag, self-reenable or incident drill failure |
| 29 | write and exercise runbooks | 17–28 | parser/IDNA/PSL/rule/privacy escape/backlog/kill/recovery/support/cleanup procedures | missing owner/evidence/cleanup or raw-value troubleshooting instruction |
| 30 | complete OSS/legal/security dependency admission | 6, 11, 19 | section 14 records approved/rejected with exact source/package/binary mapping | unresolved license/provenance/advisory for used artifact |
| 31 | execute E-G4-00 through E-G4-21 and generate immutable `g4-gate.json` | 1–30 | all primary assertions pass and evidence is canary-clean | any primary failure, expired exception or missing owner |
| 32 | obtain decisions required for any claimed live output | HD-G4 records | approved purpose/source/site/time/identity/deny/PSL/access/retention/support/risk scope | default remains disabled; no live permit |
| 33 | allow a fictional Edge-source lab slice only | 31, G2/G3 synthetic prerequisites | fixed synthetic source to minimized application/site output in lab | any real/profile/organization-derived value |
| 34 | proceed to G5 accepted implementation and later release gates in baseline order | 31–33 and predecessor gates | production-shaped synthetic path with proven cursor invariant | failed earlier gate stops dependent work and opens ADR |
| 35 | separately authorize limited pilot | every later gate + human authority | named ring, purpose, fields, retention, support, incident/rollback and stop criteria | no production authority or any unresolved non-waivable invariant |

## 13.2 Safe parallelism

After contracts, golden vectors and architecture guards exist, these lanes may proceed in parallel:

- strict scanner/parser/IDNA/IP work;
- pinned PSL parser and independent comparator;
- finite matcher/analyzer;
- privacy DTO/rejection schema and observability lint;
- canary scanner and cross-language runner admission.

The following may not start early:

- Task Host integration before pure semantic/canary gates and G1 prerequisites;
- G4→G5 progress implementation before G3 source-occurrence/disposition semantics are accepted;
- live Edge profile access before G2/G3 and human source approval;
- site/time/identity fields before their human decisions;
- production signing, pilot or rollout before all later proof gates and authorities.

## 13.3 Non-waivable implementation stop gates

Dependent work stops and an ADR/change proposal opens on any of these:

1. a forbidden source value or reversible derivative crosses Task Host IPC or enters a sink;
2. an unclassified parser/IDNA/PSL/matcher semantic difference;
3. a cross-realm match/cache/result or tenant broadening;
4. a guessed ambiguity or first-match/order-dependent assignment;
5. an accepted IP/legacy numeric/local/special-use bypass;
6. cursor ahead, progress on uncertainty, premature ACK, loss or duplicate business effect;
7. unsupported/lower/corrupt artifact partial activation;
8. mandatory scanner positive-control miss;
9. undeclared dependency/runtime/data input or unresolved license/provenance for a used artifact;
10. incomplete Windows cleanup or uncontrolled crash/support artifact.

A waiver cannot silently alter one of these invariants. Only an explicit baseline change proposal with stronger evidence, impact and migration plan can do so.

---

# 14. Open-source repository assessment table

## 14.1 Admission rule

Popularity is not evidence. A repository is a dependency candidate only when the exact source, package/native binary, license/notice obligations, security posture, tests, maintenance, UAM profile, resource behavior, SBOM/provenance and removal path are accepted. A reference runner executes only in a sealed T1 test lane and its output never becomes runtime authority. “Reference only” forbids copying code or architecture without a separate review.

## 14.2 Assessment

| Repository / relevant files and directories | Exact revision reviewed; release/activity | License and compatibility concerns | Tests, maintenance and security posture | Similarities and threat-model differences | Reusable ideas / ideas not to copy | Suitability |
|---|---|---|---|---|---|---|
| [dotnet/runtime](https://github.com/dotnet/runtime/tree/8f030f80c0dd2722eb2f618984e9db6784765963); relevant: `src/libraries/System.Private.Uri/`, `src/libraries/System.Private.CoreLib/src/System/Globalization/`, corresponding URI/globalization tests, `SECURITY.md` | tag [`v10.0.10`](https://github.com/dotnet/runtime/releases/tag/v10.0.10), commit [`8f030f80c0dd2722eb2f618984e9db6784765963`](https://github.com/dotnet/runtime/commit/8f030f80c0dd2722eb2f618984e9db6784765963), released 15 July 2026 | MIT plus third-party notices; platform/runtime servicing is mandatory and can change ICU/globalization behavior; UAM must capture actual runtime files and not assume source tag equals installed bits | very large cross-platform test/build estate, public security process and MSRC route; release includes dependency/runtime changes, so exact patch regression is required | same language/runtime and Windows deployment family; `System.Uri` supports general application compatibility rather than UAM’s strict privacy profile | reuse parser/IDNA primitives behind a strict pre/post wrapper and exact corpus; do not expose `Uri` objects across boundaries, accept every browser-compatible recovery, or treat API docs as UAM conformance proof | **Runtime dependency candidate already inherent in accepted .NET family**, conditional on E-G4-01/04/05/06/11/16 and patch lifecycle evidence |
| [WHATWG URL Standard repository](https://github.com/whatwg/url/tree/9dc3827fc722ac4af3f11061aa3e9adb44a17c8b); relevant: `url.bs`, `review-drafts/`, build/check tooling | exact commit [`9dc3827fc722ac4af3f11061aa3e9adb44a17c8b`](https://github.com/whatwg/url/commit/9dc3827fc722ac4af3f11061aa3e9adb44a17c8b); commit snapshot dated 6 July 2026 | specification text CC BY 4.0; source-code portions BSD-3-Clause; attribution and source/text distinction matter | living standard with multi-implementation review and WPT linkage; not a conventional vulnerability-supported runtime dependency | authoritative browser URL model and critical differential behavior; browser interoperability deliberately recovers inputs that UAM rejects at a privacy boundary | reuse terminology, host/IP parsing edge cases and differential expectations; do not copy full navigation/recovery semantics or make a moving living URL the endpoint contract | **Normative external reference only**, pinned snapshot; UAM profile remains separately versioned |
| [web-platform-tests/wpt URL tests](https://github.com/web-platform-tests/wpt/tree/181476aa16e8b28a07698bef3a0275fa53dd22e5/url); relevant: `url/resources/urltestdata.json`, IDNA/ToASCII resources, URL JS tests and harness metadata | exact commit [`181476aa16e8b28a07698bef3a0275fa53dd22e5`](https://github.com/web-platform-tests/wpt/commit/181476aa16e8b28a07698bef3a0275fa53dd22e5), reviewed commit dated 5 July 2026 | contributions under 3-Clause BSD; preserve notices/provenance for copied test data; corpus is browser-oriented | broad cross-browser corpus maintained with the standards project; not a security audit and does not contain UAM privacy-sink assertions | excellent parser differential/regression corpus; no UAM realm, hard-deny, application ambiguity, field minimization, resource or sink model | import a pinned selected subset with source IDs and add UAM expected classifications; do not accept every browser result or use WPT expected output as the sole oracle | **Pinned test/reference data candidate**, never runtime data or sole oracle |
| [ada-url/ada](https://github.com/ada-url/ada/tree/b12a893a45809da8103bb4f1e2f6f5ee13f9100b); relevant: `src/`, `include/`, `tests/`, `fuzz/`, `singleheader/`, `SECURITY.md` | tag [`v4.0.0`](https://github.com/ada-url/ada/releases/tag/v4.0.0), commit [`b12a893a45809da8103bb4f1e2f6f5ee13f9100b`](https://github.com/ada-url/ada/commit/b12a893a45809da8103bb4f1e2f6f5ee13f9100b), immutable release 27 July 2026 | dual Apache-2.0/MIT; native C++ ABI, installer, signing, crash, SBOM, compiler/runtime and interop obligations if embedded | active release synchronized WPT data; dedicated tests/fuzz; release notes include input bounds and fixes for IDNA Bidi, URLPattern DoS, IPv4, bounds and host canonicalization; security policy present | close parser/canonicalizer and URLPattern problem with strong hostile-input posture; broader WHATWG grammar and native-memory threat differ from strict C# Task Host | reuse as independent runner, regression/fuzz cases and design review for bounds; do not import native library initially, copy URLPattern/general matcher grammar, or claim its output is UAM authority | **High-value differential/reference runner**; **native dependency no-go initially** unless .NET candidate fails and a new ABI/operations ADR passes |
| [servo/rust-url](https://github.com/servo/rust-url/tree/43f47e2fcfdd132c531fb05aa16171ca85be95f4); relevant crates/directories `url/`, `idna/`, URL debug/tests and `SECURITY.md` | tag `v2.5.7`, exact commit [`43f47e2fcfdd132c531fb05aa16171ca85be95f4`](https://github.com/servo/rust-url/commit/43f47e2fcfdd132c531fb05aa16171ca85be95f4); exact release date was not relied upon because the reviewed rendering did not establish it unambiguously | dual Apache-2.0/MIT; a native/FFI dependency would add Rust toolchain, ABI, binary provenance, installer and support work | mature WHATWG-oriented URL/IDNA code with tests and security policy; exact UAM resource behavior and Windows interop unproved | independent language/implementation reduces common-mode defects; still implements browser/general URL semantics, not UAM strict/rejection/realm/privacy policy | reuse as an isolated differential runner and source of edge vectors; do not embed by default or copy permissive semantics/general APIs | **Reference runner only** pending exact build/container admission; runtime dependency neither needed nor justified |
| [publicsuffix/list](https://github.com/publicsuffix/list/tree/e1b8015c3b2f0f4f8c18659c2480fc1a22c07b20); relevant: `public_suffix_list.dat`, `tests/`, `tools/`, linter and [format documentation](https://github.com/publicsuffix/list/wiki/format) | exact commit [`e1b8015c3b2f0f4f8c18659c2480fc1a22c07b20`](https://github.com/publicsuffix/list/commit/e1b8015c3b2f0f4f8c18659c2480fc1a22c07b20), dated 25 July 2026 | MPL-2.0; Legal must confirm distribution/notice treatment for the list and any modified files; PRIVATE entries are policy data, not business truth | actively updated community list with syntax/lint/tests and governed contribution process; changes are not a UAM security review | exactly the structural suffix dataset needed for offline registrable-domain derivation; does not prove domain ownership, sensitivity, public reachability or application identity | reuse exact unmodified pinned data and test cases with digest/mode; do not auto-update, query network, treat PRIVATE/ICANN mode as implicit, or authorize collection from PSL membership | **Pinned data dependency candidate** after license approval, dual-parser/lint and no-network gate |
| [nager/Nager.PublicSuffix](https://github.com/nager/Nager.PublicSuffix/tree/33ff36876529dddcd00916ad5dcb3f32a8a60926); relevant: `src/`, workflows, local/HTTP rule providers | NuGet [`3.8.0`](https://www.nuget.org/packages/Nager.PublicSuffix/3.8.0), updated 4 March 2026; reviewed repository commit [`33ff36876529dddcd00916ad5dcb3f32a8a60926`](https://github.com/nager/Nager.PublicSuffix/commit/33ff36876529dddcd00916ad5dcb3f32a8a60926); no exact 3.8.0 source tag/commit mapping was established | MIT; NuGet brings logging/configuration abstractions; online/hot-reload providers conflict with offline immutable artifact model; package-to-source mapping gap | maintained .NET project with workflows and local/HTTP providers; reviewed repository page did not establish a security policy or comprehensive fuzz posture | convenient C# PSL parser and local-file support; default examples/features favor HTTP refresh/hot reload and a general web-app threat model | reuse API/test ideas only after package provenance and malformed/resource comparison; never use `SimpleHttpRuleProvider`, cached HTTP update or hot reload on endpoint | **NO-GO as dependency now** due exact package-source mapping and UAM-fit gaps; **reference/bake-off candidate** only |
| [TRowbotham/idna](https://github.com/TRowbotham/idna/tree/504900acc8e465a17668a61ae30391d1aebbb4f2); relevant: `src/`, `tests/`, `resources/`, workflows | tag `v0.3.0`, commit [`504900acc8e465a17668a61ae30391d1aebbb4f2`](https://github.com/TRowbotham/idna/commit/504900acc8e465a17668a61ae30391d1aebbb4f2), September 2025; states Unicode 17/UTS #46 Revision 35 alignment | MIT; PHP implementation is not suitable for the C# Windows runtime; exact transitive/package review required even for a container runner | focused IDNA implementation with tests/resources/workflows; no dedicated security policy was established in the reviewed repository | useful independent non-.NET implementation of current UTS #46; narrower than full URL, but language/runtime and error/resource behavior differ | reuse as an isolated ToASCII differential runner/vector source if exact container/package provenance passes; do not embed PHP or let it define UAM output alone | **Reference only**, optional because official Unicode vectors are primary |
| [cedar-policy/cedar](https://github.com/cedar-policy/cedar/tree/fdcbaed32bdb8c8d13e4eaf2b58db5555e9fb8c5); relevant: `cedar-policy-core/`, `cedar-policy/`, `cedar-policy-symcc/`, `cedar-testing/`, schemas, `SECURITY.md`, `deny.toml` | tag [`v4.12.0`](https://github.com/cedar-policy/cedar/releases/tag/v4.12.0), commit [`fdcbaed32bdb8c8d13e4eaf2b58db5555e9fb8c5`](https://github.com/cedar-policy/cedar/commit/fdcbaed32bdb8c8d13e4eaf2b58db5555e9fb8c5), released 28 July 2026 | Apache-2.0 plus notices; Rust/runtime/toolchain and a general executable policy language would materially expand endpoint authority and assurance cost | active, schema validator, integration tests, security policy and symbolic counterexample tooling; v4.12.0 includes stricter malformed-input/duplicate checks and bounded decoding changes | useful reference for closed schemas, explicit deny, validation, counterexamples and policy analysis; UAM needs a tiny monotonic finite privacy/matcher lattice, not principal/action/resource general authorization | reuse analysis/counterexample/testing patterns in offline tooling; do not embed Cedar/Rego-like policy, tenant expressions, extensions, external data or partial evaluation on endpoint | **Reference only; runtime dependency rejected** for G4 because it weakens finite monotonic proof and simplest-design requirement |

## 14.3 Repository conclusions

1. **RECOMMENDATION.** The initial runtime uses the selected .NET line plus UAM-owned strict wrapper and a small reviewed PSL parser/adapter; no native URL parser or general policy engine is introduced.
2. **RECOMMENDATION.** WHATWG/WPT, Ada, Rust URL, official Unicode vectors and optional TRowbotham IDNA execute only as pinned differential/reference inputs in sealed test lanes.
3. **RECOMMENDATION.** The PSL data file may become a shipped data dependency only after MPL-2.0/notice approval and exact file-digest evidence. A parser package does not get to download or hot-reload it.
4. **RECOMMENDATION.** Nager.PublicSuffix 3.8.0 is not admitted until its exact package bytes map to reviewed source and its online/hot-reload surfaces can be excluded and tested. A tiny UAM parser may be lower risk than adopting those unused capabilities, but that claim must be settled by E-G4-07 rather than prose.
5. **RECOMMENDATION.** Cedar contributes analysis ideas only. UAM’s runtime rule grammar remains closed, finite and release-owned.

---

# 15. Source register with stable links, source/release dates, reviewed versions/commits, claim supported, and limitations

## 15.1 Supplied evidence

| Ref | Source and reviewed identity | Claim supported | Limitation |
|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md`, baseline dated 31 July 2026, SHA-256 `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | process topology; minimization boundary; first Edge site/domain slice; privacy/durability/realm invariants | condensed accepted baseline, not runtime, legal or production proof |
| I02 | `02-sanitized-application-catalogue-report.md`, profiled 31 July 2026, SHA-256 `2be034d723dbfc6230deef25898c9555677b0c347fc29ad2562ebfa891d556a5` | 173-row catalogue shape and aggregate quality conditions used for fictional tests | no raw values, owners, roles, purpose, rules, entitlement, usage or currentness |
| I03 | `05-decisions-contradictions-and-gates.md`, July 2026 synthesis, SHA-256 `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | G0–G5 proof-gate order and stop-on-failure rule | implementation-research baseline, not unconditional production approval |
| I04 | `06-research-evidence-rules.md`, SHA-256 `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | evidence labels, primary-source priority, human authority and conflict handling | evidence-governance rule, not technical proof |
| I05 | `result-review-01-foundations.md`, review dated 31 July 2026; local export SHA-256 `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | accepted strict contracts, UUIDv7/application identity, G1 permit/Task Host boundary, finite privacy lattice, exact/suffix matcher, ambiguity, snapshots, repository/canary gates | conditional predecessor; many literal limits/dependencies and all production/human decisions remain gated |

## 15.2 Primary standards, platform documentation and registries

| Ref | Stable source; source/release date and reviewed version | Claim supported | Limitation |
|---|---|---|---|
| W01 | WHATWG, [URL Standard commit snapshot](https://url.spec.whatwg.org/commit-snapshots/9dc3827fc722ac4af3f11061aa3e9adb44a17c8b/), last updated 6 July 2026, commit `9dc3827fc722ac4af3f11061aa3e9adb44a17c8b` | browser URL parser states, special schemes, control/space stripping, backslash and legacy host/IP behavior; terminology for differential testing | living browser-interoperability standard, deliberately more permissive than UAM; not endpoint privacy policy |
| W02 | Unicode Consortium, [UTS #46 Revision 35](https://www.unicode.org/reports/tr46/tr46-35.html), Unicode 17.0.0, 4 September 2025 | IDNA compatibility processing, transitional/non-transitional modes, processing/validation options | Unicode conformance does not prevent visual confusables or decide UAM output/purpose |
| W03 | IETF, [RFC 3986 — URI Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986.html), January 2005 | generic URI components, scheme/authority/path/query/fragment syntax and percent encoding | not a complete modern browser URL algorithm or IDNA profile; UAM intentionally adds stricter rules |
| W04 | IETF, [RFC 5890 — IDNA Definitions](https://www.rfc-editor.org/rfc/rfc5890.html), August 2010 | A-label/U-label/IDNA terminology and DNS-name context | definitions alone do not supply UTS #46 compatibility mapping |
| W05 | IETF, [RFC 5891 — IDNA Protocol](https://www.rfc-editor.org/rfc/rfc5891.html), August 2010 | registration/lookup processing and error handling concepts | UAM uses a UTS #46 compatibility profile and must test concrete implementation |
| W06 | IETF, [RFC 5892 — IDNA Code Points](https://www.rfc-editor.org/rfc/rfc5892.html), August 2010 | valid/disallowed/contextual code-point framework | Unicode-version data and UTS #46 behavior evolve |
| W07 | IETF, [RFC 5893 — Right-to-Left Scripts](https://www.rfc-editor.org/rfc/rfc5893.html), August 2010 | Bidi label rule | valid RTL labels can still be visually confusing; admin presentation remains a separate control |
| W08 | IETF, [RFC 5895 — Mapping Characters for IDNA2008](https://www.rfc-editor.org/rfc/rfc5895.html), September 2010 | background on mapping and user-interface compatibility concerns | informational guidance; UTS #46 revision/profile is the selected concrete reference |
| W09 | web-platform-tests, [URL test tree at commit `181476aa16e8b28a07698bef3a0275fa53dd22e5`](https://github.com/web-platform-tests/wpt/tree/181476aa16e8b28a07698bef3a0275fa53dd22e5/url), commit dated 5 July 2026 | executable browser URL/ToASCII regression corpus and parser recovery edge cases | browser-oriented expected outcomes; not sole UAM oracle and lacks privacy/realm/resource tests |
| W10 | IANA, [Uniform Resource Identifier Schemes](https://www.iana.org/assignments/uri-schemes/uri-schemes.xhtml), reviewed 31 July 2026 | scheme registry context; supports explicit allowlist rather than treating arbitrary tokens as HTTP(S) | registry membership does not authorize UAM collection |
| W11 | IANA, [Special-Use Domain Names](https://www.iana.org/assignments/special-use-domain-names/), registry updated 22 May 2026 | current special-use names and subdomain applicability for structural suppression | registry cannot identify every internal/private name and may change after release |
| W12 | publicsuffix/list, [exact repository commit `e1b8015c3b2f0f4f8c18659c2480fc1a22c07b20`](https://github.com/publicsuffix/list/tree/e1b8015c3b2f0f4f8c18659c2480fc1a22c07b20), 25 July 2026 | exact PSL data, ICANN/PRIVATE sections, wildcard/exception test input and local pinning source | community policy data; not proof of ownership, public reachability, sensitivity or application identity; MPL-2.0 review needed |
| W13 | Microsoft, [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), reviewed 31 July 2026 | .NET 10 active LTS/servicing context used to choose an execution-time supported line | moving lifecycle page; exact supported patch and enterprise estate must be recaptured at build/release time |
| W14 | Microsoft/.NET, [runtime `v10.0.10`](https://github.com/dotnet/runtime/releases/tag/v10.0.10), released 15 July 2026, commit `8f030f80c0dd2722eb2f618984e9db6784765963` | exact point-in-time runtime source/release identity and public security/test posture | source tag does not prove installed Windows runtime bits or UAM semantic fitness |
| W15 | Microsoft Learn, [`System.Uri` .NET 10 API](https://learn.microsoft.com/en-us/dotnet/api/system.uri?view=net-10.0), reviewed 31 July 2026 | candidate absolute URI parsing API and component access | API documentation is capability evidence only; behavior is version/platform dependent and must be locked by vectors |
| W16 | Microsoft Learn, [`Uri.IdnHost`](https://learn.microsoft.com/en-us/dotnet/api/system.uri.idnhost?view=net-10.0) and [`IdnMapping`](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.idnmapping?view=net-10.0), reviewed 31 July 2026 | .NET IDN/ASCII host and IDNA conversion capabilities | does not by itself prove exact UTS #46 option/data behavior, round trip, DNS limits or error profile |
| W17 | Microsoft Learn, [`IPAddress.TryParse`](https://learn.microsoft.com/en-us/dotnet/api/system.net.ipaddress.tryparse?view=net-10.0), reviewed 31 July 2026 | candidate IP-literal detection capability | cannot alone guarantee complete browser legacy-numeric detection; independent generated/reference corpus required |
| W18 | IETF, [RFC 6761 — Special-Use Domain Names](https://www.rfc-editor.org/rfc/rfc6761.html), February 2013 | special-use naming framework and registry rationale | not a complete current list; W11 is the point-in-time registry |
| W19 | IETF, [RFC 1034 — Domain Names: Concepts and Facilities](https://www.rfc-editor.org/rfc/rfc1034.html) and [RFC 1035 — Implementation and Specification](https://www.rfc-editor.org/rfc/rfc1035.html), November 1987 | DNS label/name wire-length and structure background | old DNS base documents; later IDNA/host syntax and application policy must also be applied |
| W20 | IETF, [RFC 1123 — Internet Host Requirements](https://www.rfc-editor.org/rfc/rfc1123.html), October 1989 | host syntax update allowing leading digits and general host requirements | not a URL parser, IDNA profile, special-use list or privacy policy |
| W21 | Unicode Consortium, [`IdnaTestV2.txt` for Unicode 17.0.0](https://www.unicode.org/Public/idna/17.0.0/IdnaTestV2.txt), 2025 Unicode release data | official executable UTS #46 conformance vectors for ToASCII/ToUnicode | test data does not cover UAM lexical, resource, sink, realm, policy or matcher rules |
| W22 | IETF, [RFC 9562 — UUIDs](https://www.rfc-editor.org/rfc/rfc9562.html), May 2024 | canonical UUIDv7 identity profile inherited for UAM application/event/rule/snapshot IDs | UUID timestamp is not business time, source order, authorization or privacy proof |
| W23 | JSON Schema, [Draft 2020-12 Core](https://json-schema.org/draft/2020-12/json-schema-core), December 2020 | closed structural schemas and local bundle vocabulary inherited from Batch 01 | schema validation cannot prove semantic privacy, compatibility, resource safety or implementation correctness |
| W24 | IETF, [RFC 8259 — JSON](https://www.rfc-editor.org/rfc/rfc8259.html), December 2017 | JSON syntax/UTF-8 basis for strict minimized/rejection contracts | permits interoperability choices that UAM narrows, such as duplicate-member behavior being implementation-dependent |
| W25 | IETF, [RFC 3339 — Date and Time on the Internet](https://www.rfc-editor.org/rfc/rfc3339.html), July 2002 | explicit UTC wire-time profile background | does not decide UAM precision, retention or legal/business purpose |

## 15.3 Open-source, governance and operational references

| Ref | Stable source; source/release date and reviewed version | Claim supported | Limitation |
|---|---|---|---|
| W26 | ada-url/ada, [`v4.0.0`](https://github.com/ada-url/ada/releases/tag/v4.0.0), 27 July 2026, commit `b12a893a45809da8103bb4f1e2f6f5ee13f9100b` | maintained independent WHATWG parser, tests/fuzz and recent input/IDNA/IP/DoS hardening for differential review | C++/native threat and operations differ; no UAM privacy/realm authority; not selected runtime dependency |
| W27 | servo/rust-url, [`v2.5.7` source at commit `43f47e2fcfdd132c531fb05aa16171ca85be95f4`](https://github.com/servo/rust-url/tree/43f47e2fcfdd132c531fb05aa16171ca85be95f4), reviewed 31 July 2026 | independent Rust WHATWG URL/IDNA implementation and tests for differential checking | exact release date was not established reliably from the reviewed page; no UAM strict/privacy/Windows proof |
| W28 | NuGet, [`Nager.PublicSuffix 3.8.0`](https://www.nuget.org/packages/Nager.PublicSuffix/3.8.0), updated 4 March 2026; repository commit `33ff36876529dddcd00916ad5dcb3f32a8a60926` | point-in-time .NET PSL parser candidate with local and online rule-provider surfaces | no exact package-to-source revision mapping established; online/hot-reload capabilities conflict with UAM; no-go pending admission |
| W29 | TRowbotham/idna, [`v0.3.0` source commit `504900acc8e465a17668a61ae30391d1aebbb4f2`](https://github.com/TRowbotham/idna/tree/504900acc8e465a17668a61ae30391d1aebbb4f2), September 2025 | optional independent Unicode 17/UTS #46 implementation and resources | PHP/runtime mismatch and no reviewed dedicated security policy; official Unicode vectors remain primary |
| W30 | cedar-policy/cedar, [`v4.12.0`](https://github.com/cedar-policy/cedar/releases/tag/v4.12.0), 28 July 2026, commit `fdcbaed32bdb8c8d13e4eaf2b58db5555e9fb8c5` | schema validation, explicit authorization semantics, symbolic counterexample and malformed-input testing ideas | general policy language is intentionally not a UAM endpoint dependency; broader expression/extension surface impedes finite monotonic proof |
| W31 | European Union, [Regulation (EU) 2016/679 official text](https://eur-lex.europa.eu/eli/reg/2016/679/oj/eng), Official Journal 4 May 2016 | primary legal text containing principles such as purpose limitation and data minimisation that motivate human governance boundaries | this research does not provide legal advice, determine applicability/lawful basis, or approve employee monitoring |
| W32 | OWASP, [Logging Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html), reviewed 31 July 2026 | secondary secure-logging guidance on excluding sensitive data, sanitizing events and protecting logs | community guidance, not primary law/standard or proof that UAM sinks are clean |
| W33 | NIST, [SP 800-92 — Guide to Computer Security Log Management](https://csrc.nist.gov/pubs/sp/800/92/final), September 2006 | general log governance, collection and operational-management background | old and broad; does not address UAM’s endpoint privacy boundary or modern telemetry stack specifically |

## 15.4 Source-use conclusions

- Primary standards define component behavior, not UAM fitness. UAM fitness requires the exact CLI experiments and Windows all-sink evidence.
- Living standards, runtime documentation, registries, Unicode data and PSL data are point-in-time inputs. Their reviewed revision/digest is part of `normalizationVersion`; “latest” is never resolved on the endpoint.
- Open-source repositories provide independent implementations, vectors and threat evidence. They are not automatic dependencies and cannot approve privacy fields or policy semantics.
- Legal and operational references explain why governance/log controls matter but do not decide purpose, lawful basis, retention, employee consultation, risk acceptance or production deployment.

---

# 16. Confidence table for every major conclusion

| Major conclusion | Confidence | Why | Evidence that would change it |
|---|---|---|---|
| Raw URL must be treated as a short-lived secret | **High** | raw path/query/userinfo/title can carry credentials, searches and identifiers; accepted baseline requires pre-IPC minimization | approved evidence that the source contains only a narrower typed host fact and never a URL, with a changed source contract |
| Task Host → User Host is the final raw-value boundary | **High** | predecessor already confines source access to fixed Task Host/User Host context; placing transform before result serialization is the narrowest trust boundary | a falsifying G1/G4 experiment showing this is infeasible without weakening another non-negotiable invariant, plus a stronger alternate design |
| Strict lexical rejection is safer than browser-style recovery | **High** | WHATWG deliberately repairs/normalizes navigation inputs that create security/privacy ambiguity for UAM | corpus evidence that a specific strict rule creates unavoidable misclassification and an alternate rule preserves all privacy/match invariants |
| A complete custom URL/IDNA implementation is too risky | **High** | complex evolving standards and mature implementations require extensive test/fuzz maintenance | every maintained candidate fails the bounded profile and a separately owned custom implementation passes superior conformance, fuzz, security and support gates |
| `.NET 10` behind a UAM wrapper is the best initial candidate | **Medium** | accepted C# family and lowest extra deployment cost; exact parsing/IDNA/resource behavior is not yet proved on supported Windows estate | E-G4 differential/fuzz/Windows evidence of semantic, resource or security failure that cannot be contained |
| `System.Uri` cannot be the normative specification | **High** | runtime behavior can change and supports broader application compatibility; UAM requires stricter profile/version provenance | an official immutable .NET profile exactly matching all UAM rules and compatibility requirements |
| UTS #46 non-transitional plus strict checks is the right IDNA profile | **High** | current Unicode profile and WHATWG alignment; avoids deprecated transitional mappings | new Unicode/IETF primary guidance or conformance evidence showing the chosen profile is unsafe/incompatible for the approved scope |
| Canonical comparison/output should use lower-case ASCII A-label | **High** | deterministic matching and avoids carrying raw Unicode spelling; still supports valid IDNs | approved need for Unicode output with a safe, versioned, non-source display transform and accessibility/security evidence |
| Valid IDNA does not make a domain non-sensitive | **High** | IDNA is syntactic processing, not privacy classification | no likely technical evidence; only policy categories/purpose can decide sensitivity |
| All IP literals and legacy numeric forms should be rejected in first slice | **High** | reduces local/topology collection and parser-bypass surface; no approved IP use case | approved purpose requiring IP targets plus exhaustive normalizer/rule/privacy evidence and new ADR |
| Exactly one terminal dot may be removed for comparison | **Medium-High** | standard FQDN equivalence and deterministic rule behavior; pre/post parser ordering still needs tests | candidate/reference disagreement or source semantics showing terminal dot must remain distinct for approved use |
| Default ports may canonicalize to absent; non-default ports require exact approval | **High** | preserves standard scheme defaults while avoiding silent service conflation | approved application semantics demonstrating a broader port profile with finite rules and privacy proof |
| IANA special-use/local names should be structurally suppressed | **High** | avoids known local/documentation/special namespaces and supports offline deterministic safety | approved purpose for a specific special-use class with release-owned rule and risk evidence |
| PSL must be local, pinned, digest-bound and non-authoritative | **High** | offline/reproducibility requirements and list churn; PSL is policy data, not ownership/security truth | a governed alternative proving equal offline reproducibility, no network authority and better operational/security behavior |
| ICANN versus PRIVATE PSL semantics is a human decision | **High** | sections have different hosted-domain grouping consequences and prompt explicitly reserves the decision | only an accountable approved decision record with purpose and consequence evidence |
| Exact/suffix label-boundary grammar is sufficient for first slice | **High** | predecessor accepts it and first slice is site/domain-level; finite grammar is analyzable | approved use case requiring another finite matcher family and evidence it preserves privacy, ambiguity and realm invariants |
| First-match, row-order and lexicographic tie-breaks are unsafe | **High** | they hide cross-application ambiguity and make data order authoritative | a formal business rule that makes one criterion authoritative, encoded as an explicit reviewed rule property—not incidental storage order |
| Cross-application maximal conflict must produce no assignment | **High** | guessing corrupts application facts and can bypass deny/governance | accountable policy decision plus explicit semantics proving a different outcome is not a guess and does not widen collection |
| Hard deny must run before application assignment/output | **High** | deny must dominate all allows; endpoint minimization cannot rely on central filtering | formal proof that an alternate ordering yields identical no-output behavior for every rule combination |
| Output must be constructed from a closed allowlist, not clone-and-redact | **High** | subtraction/reflection is prone to new-field leakage; architecture/schema mutations are directly testable | evidence of a generated type system providing equivalent compile-time closure and independent canary proof |
| Hash/HMAC of a forbidden URL is not automatically minimized | **High** | domains are enumerable/linkable and stable tokens create tracking; prompt forbids reversible derivative crossing gate | separately approved purpose-bound unlinkable transform with cryptographic/privacy analysis, rotation/deletion and explicit output authority |
| Person/session identifiers should be absent by default | **High** | identity level is provisional/human-owned and raw endpoint identifiers enable tracking | approved identity purpose/projection contract and privacy/security/deletion evidence |
| Time must be UTC-floored to approved precision | **High for method; Low for exact precision** | deterministic non-future reduction preserves retry semantics; precision is explicitly a human decision | approved precision/purpose and G3/G5 identity/replay evidence or superior deterministic transform |
| Rejection telemetry can remain useful without values | **Medium-High** | stage/reason/version/resource buckets locate component failures while avoiding source channel | incident exercises showing an essential failure cannot be diagnosed, followed by a narrower reviewed field proposal |
| Fixed metric dimensions are necessary | **High** | dynamic host/app/rule/realm/user labels create cardinality and privacy channels | measured design with equal privacy/cardinality containment and approved access/retention |
| Realm must be part of artifact/cache/evaluation context, not payload claim | **High** | accepted realm-isolation invariant and duplicate IDs can exist across realms | no likely implementation convenience can change this; only a redesigned authenticated tenancy model with explicit baseline proposal |
| `normalizationVersion` must bind runtime/data semantics, not only code version | **High** | runtime, Unicode, special-use, PSL and error maps can change outcomes independently | a reproducible build/runtime format that cryptographically and semantically captures all those inputs under another equivalent identifier |
| Consumer-first, atomic, monotonic rollout is required | **High** | endpoints operate offline and old consumers must not partially interpret new rules; rollback cannot lower sequence | measured alternate rollout proving no partial activation, downgrade or duplicate effect across the supported fleet |
| G4 must return typed event/no-event/defer semantics and never write cursor | **High** | accepted G5 atomicity boundary and cursor invariant | predecessor change proposal moving transaction authority while preserving all crash/retry/privacy invariants |
| Deterministic million-case fuzz plus cross-language tests are proportionate | **Medium-High** | high-risk parser/privacy boundary and inexpensive synthetic generation; exact case count is an evidence floor, not proof | measured equivalent coverage/fault detection with a smaller formally generated suite or need for a larger corpus after escaped defects |
| All-sink canary testing materially reduces privacy-escape risk | **Medium** | catches real accidental copies/encodings across the composed chain, but no scanner proves universal absence | demonstrated false negatives, opaque OS/vendor sinks or a stronger data-flow/provenance technique; the response would be to strengthen—not remove—the gate |
| Full-memory dump suppression is necessary for production Task Host | **Medium-High** | raw data exists in managed memory and cannot be reliably zeroized | approved enterprise diagnostics need with demonstrated encryption/access/collection minimization, exact sink scan and risk acceptance |
| Ada/Rust/WHATWG/WPT should be references, not initial runtime dependencies | **High** | independent implementations reduce common-mode test error without adding endpoint ABI/runtime attack surface | .NET candidate failure and a native-dependency ADR proving superior total security, privacy, operations, licensing and support fitness |
| Nager.PublicSuffix 3.8.0 is currently no-go | **High for current review** | exact package-to-source mapping not established and online/hot-reload surfaces conflict with design | exact package provenance, security/license admission, feature exclusion and superior malformed/resource evidence |
| Cedar/general policy engine should not run on endpoint | **High** | UAM requires tiny release-owned finite monotonic grammar; a general language adds unnecessary executable authority | a future requirement impossible in the finite model plus formal monotonic/sandbox/operations evidence and explicit baseline change |
| Exact resource limits and metric budget remain unknown | **High** | no representative approved source/rate/estate/SLO measurements are supplied | E-G4 measurements and accountable product/SRE/endpoint decisions |
| G4 research is not live-source or production approval | **High** | explicit prompt/baseline/human authority boundaries and unresolved G2/G3/G5/release gates | only designated human authorities plus all named technical gates can change the status |

## 16.1 Residual risk

### What remains unsafe

- A syntactically valid, public DNS host can still reveal health, finance, union, legal, political, authentication or other sensitive activity. Only an approved hard-deny/purpose policy can reduce that risk, and no category list can be complete.
- The raw URL necessarily exists briefly in Edge/source memory and Task Host managed memory. C# strings cannot be reliably zeroized; OS pagefile, crash infrastructure, EDR, antivirus, virtualization, hypervisor snapshots or privileged tooling may capture it outside UAM’s direct control.
- A compromised same-user context, signed release, product ceiling, policy publisher or endpoint security agent may defeat assumptions that parser tests alone cannot protect.
- Parser/IDNA/Unicode/PSL/reference repositories can contain defects or supply-chain compromise even at pinned commits.

### What remains uncertain

- Exact `.NET` URI/IDNA behavior, resource use and crash artifacts on every supported Windows/VDI/EDR combination.
- Complete legacy numeric-IP detection, every Unicode edge case, and every parser disagreement that future releases may introduce.
- Approved site/time/identity output, hard-deny categories, PSL PRIVATE semantics, non-default ports, Unicode enablement and permanent invalid-row disposition.
- Representative URL length, page/rule/snapshot size, rejection rate, ambiguity rate, endpoint resource budget, long-outage backlog, metric budget, SLO/RPO/RTO and support cost.
- The eventual G3 source-occurrence identity and G5 transaction schema needed to make rejection progress and retry exact.

### What remains operationally costly

- Maintaining pinned runtime/Unicode/IANA/PSL/reference revisions and re-running semantic diffs after servicing updates.
- Reviewing rule overlaps, false denies, ambiguity and data-quality changes without using observed raw URLs.
- Storing and reviewing reproducible million-case evidence, Windows VM captures, SBOM/provenance and cleanup receipts.
- Supporting fail-closed outages/backlogs, incident kill switches, higher-revision recovery and privacy-safe diagnostics across offline endpoints.
- Licensing/procurement review for PSL data and any parser/test dependency, plus native-runner build infrastructure.

### What remains dependent on humans

Purpose, lawful basis, prohibited uses, employee consultation, approved sources/fields/site semantics/time/identity, hard-deny categories, retention/deletion/access, public/private suffix interpretation, signing/key authority, supported estate, diagnostics policy, staffing, budget, SLO/RPO/RTO, pilot scope, risk acceptance and production approval.

### What research alone cannot prove

Research cannot prove legal authorization, workforce legitimacy, absence of every future sensitive domain, absence of every byte from opaque OS/vendor telemetry, production behavior under all endpoint policies, operator competence during an incident, or that a validly signed but mistaken policy will never be issued. Those require accountable governance, constrained authority, lab/production evidence and continuing operations.

## 16.2 Exact next stop/go gate

**Current status: STOP for live Edge data, production-shaped URL output, pilot and production deployment. GO only for the synthetic implementation/backlog through the pure and disposable-lab G4 evidence lanes.**

The next gate is **G4 synthetic privacy transformation and canary containment**. It passes only when:

1. ADR-G4-001 through ADR-G4-018 are accepted for their stated scope; ADR-G4-019/020 are either accepted where applicable or production diagnostics/admin UI remain disabled;
2. all blocking owner functions are assigned and every unresolved human output decision is represented by an effective technical disable;
3. golden vectors and the independent oracle predate production logic and all strict/profile/IDNA/IP/PSL/matcher/policy/schema/architecture mutation tests pass;
4. exact dependency/runtime/data/license/provenance records are complete;
5. E-G4-10/11 execute exactly 1,000,000 cases with zero mandatory crash, hang, OOM, unclassified semantic difference, realm failure, ambiguity guess, broadening or canary escape;
6. E-G4-16/17 prove the full Task Host → User Host → Coordinator synthetic chain and every declared Windows sink clean for each environment claimed, with no residual process/file/certificate/rule/dump/support artifact;
7. E-G4-18 proves event/no-event/progress/cursor atomicity, no progress on uncertainty, one retry effect and ACK only after commit;
8. E-G4-19/20 prove consumer-first activation, monotonic rollback, kill/SafetyHold and authorized recovery; and
9. immutable `g4-gate.json` binds the exact source tree, inputs, corpus, runtime, artifacts, ADRs, owners, evidence, scanner and cleanup receipts with no expired exception.

A pass permits only the next production-shaped **synthetic** G5 integration step in the accepted gate order. It does not permit live source activation. Any forbidden value or reversible derivative crossing Task Host IPC or entering a sink, any cross-realm authority failure, any guessed ambiguity, any tenant broadening, or any cursor-ahead/duplicate/loss outcome is the explicit **STOP** condition and requires an ADR/change proposal before dependent work resumes.
