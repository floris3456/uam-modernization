# Prompt 15 result — ingestion API, durable relational inbox, idempotency, leasing, quarantine, and materialization

**Result path:** `batches/04-server-platform/15-ingestion-relational-inbox/result-15-ingestion-relational-inbox.md`  
**Research date:** 31 July 2026  
**Decision status:** **RECOMMENDATION — ACCEPT THE RELATIONAL-INBOX ARCHITECTURE FOR G8 IMPLEMENTATION PROTOTYPES; PRODUCTION FAILURE DOMAIN, ENGINE, SLO/RPO/RTO, RETENTION, SCHEMA HORIZON, AND OPERATIONAL OWNERSHIP REMAIN OPEN**  
**Authority boundary:** server ingestion, durable custody, relational work leasing, idempotent fact materialization, quarantine, projection handoff, reconciliation, and integration outbox; **not** endpoint collection, legal purpose, production retention, production database selection, capacity approval, commercial support, or production deployment  
**Primary gate:** **Every durable receipt remains recoverable and reaches exactly one batch terminal outcome: materialized facts or explicit terminal quarantine. Every unique event creates at most one fact.**

## Evidence vocabulary

This result uses the required labels:

- **FACT** — directly supported by an allowlisted supplied file or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from stated facts; the chain is explained.
- **ESTIMATE** — a numerical hypothesis with replaceable inputs.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — required evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, business, support, or production authority is required.
- **CLI EXPERIMENT** — code, lab work, fault injection, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements define the proposed G8 implementation contract. They do not convert a **HUMAN DECISION**, **UNKNOWN**, or unexecuted **CLI EXPERIMENT** into approval.

---

# 1. Executive conclusion in easy language, with confidence and residual risk

## 1.1 Conclusion

**RECOMMENDATION.** UAM should accept an upload only by committing three things in one short relational transaction:

1. the immutable compressed batch bytes;
2. the authenticated realm/installation binding and batch metadata; and
3. an immutable durable-custody receipt.

The API returns that receipt only after the transaction commits inside the declared failure domain. The receipt does **not** mean that the events are valid, materialized, integrated, aggregated, or visible. It means only that the server has taken durable custody under a named, versioned durability class.

After receipt, leased workers process batches asynchronously. A worker parses and validates outside a database transaction, then performs one short final transaction that:

- rechecks its lease token;
- resolves every event as a same-content duplicate, a new fact, or a conflict;
- inserts all new event-dedupe rows and typed facts;
- enqueues projection and integration work; and
- moves the batch to `MATERIALIZED`.

A deterministic poison, unsupported event schema, identity conflict, or permanent reference failure instead creates an explicit immutable quarantine occurrence and moves the batch to `QUARANTINED_TERMINAL`. A transient infrastructure failure returns the batch to `RETRY_WAIT`. The first implementation treats a batch as one semantic unit: it does not partially materialize a valid subset and silently move past an invalid member.

**INFERENCE.** This is the smallest architecture that composes the accepted predecessor invariants:

- endpoints deliver at least once and replay stable batch/event identities;
- realm and installation authority come from authenticated server context, not the payload;
- a receipt means durable custody only;
- a retry or replay creates one final business effect;
- a modular monolith and relational durable inbox are the accepted default; and
- no external broker is added without measured need.

## 1.2 Recommended decision summary

| Decision | Recommendation | Confidence | Residual risk |
|---|---|---:|---|
| Acceptance boundary | One relational transaction for batch row, exact wire payload, and receipt | **High** | The chosen database/replication/backup profile may not satisfy the future RPO/RTO decision. |
| API identity | Direct mTLS/L4 pass-through first; server creates immutable `AuthenticatedDeviceContext` | **High** | PKI, gateway topology, and rapid-deny operations remain human/Batch 03 dependencies. |
| Duplicate behavior | Same batch ID + same content and wire hashes returns the original receipt; any hash difference is a conflict | **High** | Hash implementation or canonical-byte drift can create false conflicts; contract vectors must prevent that. |
| Worker queue | Relational rows with short claims, database-time leases, heartbeats, fencing token/version, and per-realm fairness | **Medium-High** | PostgreSQL and SQL Server lock behavior and hot-row cost require identical benchmarks and kill tests. |
| Semantic boundary | Whole-batch atomic materialization for the first slice | **Medium-High** | A future very large batch or mixed-schema requirement may justify explicit sub-batch semantics. |
| Event idempotency | Unique `(realm_id, event_id)` plus immutable payload/effect digest | **High** | A producer defect that reuses an event ID with changed content becomes quarantine and can cause backlog. |
| Quarantine | Explicit terminal state, immutable occurrence history, metadata-first operator tooling, governed replay | **High** | Retention, access, legal hold, and reprocessing authority are human decisions. |
| Facts and aggregates | Typed immutable facts are authoritative; projections and integrations are derived through transactional work rows/outbox | **High** | Projection lag and integration duplicates require separate SLOs and idempotent consumers. |
| Database engine | PostgreSQL reference and SQL Server fallback use the same logical contracts and fault suite | **High as process; Low as final engine choice** | No UAM benchmark, restore drill, cost, licensing, or operational-skills evidence exists. |
| External broker | Do not add one initially | **High** | A measured independent failure-domain, replay, fan-out, or cost requirement may later change the decision. |

## 1.3 What this result authorizes

**GO** for:

- strict HTTP and receipt contracts using T1 fictional data;
- an authenticated-context emulator;
- engine-neutral domain models and schemas;
- PostgreSQL and SQL Server dialect adapters behind one contract-test suite;
- relational inbox, payload, receipt, conflict, lease, quarantine, event-dedupe, typed-fact, projection-work, reconciliation, and integration-outbox prototypes;
- a poison corpus and deterministic reference model;
- API/worker/database process-kill, response-loss, failover, and restore experiments;
- a G8 reconciler that proves every receipt reaches one materialized or quarantined terminal outcome;
- synthetic capacity inputs for the later database/capacity prompt.

## 1.4 What this result does not authorize

**STOP** before:

- calling any receipt class production-safe without a human-approved failure domain and successful restore evidence;
- endpoint payload cleanup based on a production receipt;
- selecting PostgreSQL or SQL Server for production by prose;
- accepting live activity or production-derived data;
- partial batch materialization, schema coercion, payload-derived realm authority, free-form tenant SQL, or an arbitrary reprocessing script;
- a broker, object-store payload boundary, per-realm database fleet, or cross-region design without a measured break-even ADR;
- production retention/purge, audit storage, privileged operator access, SLO/RPO/RTO, staffing, on-call, or go-live.

## 1.5 Primary G8 acceptance expression

```text
G8_PASS =
    ZERO_RECEIPTS_WITHOUT_DURABLE_BATCH_AND_PAYLOAD
    AND EVERY_DURABLE_RECEIPT_HAS_EXACTLY_ONE_TERMINAL_BATCH_OUTCOME
    AND TERMINAL_OUTCOME_IN { MATERIALIZED, QUARANTINED_TERMINAL }
    AND EVERY_NEW_EVENT_ID_HAS_EXACTLY_ONE_FACT
    AND EVERY_SAME_EVENT_ID_SAME_HASH_REPLAY_HAS_ZERO_ADDITIONAL_FACTS
    AND EVERY_SAME_EVENT_ID_DIFFERENT_HASH_IS_EXPLICIT_CONFLICT
    AND ZERO_STALE_LEASE_COMMITS
    AND ZERO_CROSS_REALM_READS_WRITES_CLAIMS_OR_REPLAYS
    AND ZERO_UNBOUNDED_POISON_RETRIES
    AND ZERO_INTEGRATION_SENDS_OUTSIDE_THE_MATERIALIZATION_OUTBOX
    AND ZERO_FORBIDDEN_VALUE_CANARY_ESCAPES
    AND ZERO_UNEXPLAINED_RESTORE_RECONCILIATION_FINDINGS
    AND ZERO_CLEANUP_RESIDUE
```

No throughput average, availability percentage, or operator waiver compensates for a nonzero primary invariant count.

## 1.6 Executive residual risk

The design cannot prove that storage hardware, virtualization, filesystems, replication, backups, or operators will honor the declared durability class. Synchronous replication can improve the failure domain but can also couple ingestion availability to another system. Asynchronous replicas and point-in-time backups can still lose transactions newer than their replay point. A valid receipt therefore remains safe for endpoint cleanup only after the accountable humans choose the failure domain/RPO and G8 plus later restore drills prove the implementation matches that choice.

The relational queue can be correct yet operationally expensive. Lease scans, large payload writes, indexes, vacuum/version cleanup, transaction-log growth, aggregate contention, and per-realm fairness must be measured with the same workload and failure plan on PostgreSQL and SQL Server. The result is a decision-ready architecture, not capacity evidence.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 Scope

This result defines the server path from the authenticated HTTP boundary through durable custody and asynchronous materialization:

```text
endpoint sealed batch
  -> network/gateway identity boundary
  -> ingestion API streaming validation
  -> relational receipt transaction
  -> durable inbox and immutable payload
  -> leased materialization worker
  -> event dedupe + typed facts
  -> projection work + integration outbox
  -> quarantine/reprocess/reconciliation
  -> distinct visibility and downstream delivery states
```

It covers:

- direct mTLS and conditional L7 gateway trust boundaries;
- header stripping and immutable authenticated context;
- compressed/decompressed streaming limits and digest verification;
- canonical batch and wire hash semantics;
- synchronous cheap validation and exact receipt behavior;
- engine-neutral inbox schemas and index requirements;
- worker claims, leases, heartbeats, fencing, retry, poison, and quarantine;
- event dedupe, typed facts, aggregate projection, and integration outbox;
- host/process/database failure boundaries, restore, replay, and reconciliation;
- backpressure, fairness, realm isolation, privacy-safe observability, and operational tooling;
- threat model, secure coding/review, feature flags/kill switches, incident response, ownership, cost/skills/licensing considerations, and G8 tests;
- explicit conditions for considering an external broker.

## 2.2 Non-goals

This result does not redesign:

- Windows Coordinator/User Host/Task Host collection boundaries;
- endpoint SQLite page/cursor/outbox logic;
- PKI enrollment, certificate issuance, or gateway product selection;
- product privacy fields, exact site/domain representation, identity precision, or first-run lookback;
- control portal technology;
- HR/directory/CMDB integration semantics;
- production fact retention or deletion policy;
- production audit storage;
- production database topology, cloud/on-premises placement, or vendor contract;
- database capacity for 6,000 endpoints;
- long-outage disk/backpressure policy;
- final deletion/restore/acknowledged-replay behavior.

Those topics remain predecessor inputs or later proof gates.

## 2.3 Allowlisted evidence boundary

**FACT.** This result used exactly the seven allowed project files. No other project file was used.

| Ref | File | Reviewed SHA-256 | Use and limitation |
|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md` | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | accepted system/server/receipt/realm/durability decisions; not production approval |
| I02 | `04-data-and-schema-evidence-summary.md` | `1ed93b3d60d37da96c1f67e401deb10c9d57736e4f4dbfa26e16760bd2a19ce6` | target data principles and missing production distributions; no row-level values or rates |
| I03 | `05-decisions-contradictions-and-gates.md` | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | accepted relational-inbox/no-broker choice and proof-gate order |
| I04 | `06-research-evidence-rules.md` | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | evidence labels, source rules, and human-authority boundaries |
| I05 | `result-review-01-foundations.md` (local file `batch-01-review-result(3).md`) | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | strict contracts, UUIDv7, receipt semantics, realm isolation, repository and control-artifact rules |
| I06 | `result-review-02-endpoint-data.md` | `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | event/page identity, stable event IDs, whole-page endpoint transaction, raw-value boundary, and G5 handoff |
| I07 | `result-review-03-durability-release-identity.md` | `76854c3d6a12b9b717da90d4e368273bd88a672fc64a315afaeacfb3d701a785` | sealed batch/attempt/receipt invariants, `AuthenticatedDeviceContext`, direct mTLS default, release/identity/diagnostic/compatibility constraints |

## 2.4 Accepted predecessor inputs carried forward

The following are **FACT** from I01–I07 and are not reopened:

| ID | Accepted input |
|---|---|
| A15-01 | Endpoint delivery is at least once. Stable event and batch identities plus central uniqueness create one final business effect. |
| A15-02 | Uploads are bounded, versioned, authenticated, compressed HTTPS batches. |
| A15-03 | A receipt means durable custody in its declared failure domain, not validation, materialization, integration, or portal visibility. |
| A15-04 | The server derives realm and installation/device authority from authenticated registration context, not body, route, certificate text, or forwarding headers. |
| A15-05 | The initial server is a modular monolith with an ingestion boundary, relational durable inbox, leased workers, typed facts/aggregates, control API/BFF, and governed integrations. |
| A15-06 | No external broker is the default. It requires measured failure-domain, throughput, replay, fan-out, or cost evidence. |
| A15-07 | PostgreSQL is the reference candidate; SQL Server is a serious transition/fallback candidate. The production engine requires an identical benchmark and operations/skills/licensing/restore evidence. |
| A15-08 | Endpoint batches are sealed once with stable IDs, canonical uncompressed content digest, exact wire bytes/digest, and a durable ambiguous-send attempt before network I/O. |
| A15-09 | Realm, installation, enrollment epoch, credential generation, assurance/status, issuer, and trust-domain facts are supplied in an immutable server-created `AuthenticatedDeviceContext`. |
| A15-10 | Direct origin mTLS or L4 pass-through is the default. L7 termination requires certificate validation, inbound identity-header stripping, gateway-to-backend mTLS, and a short-lived request-bound signed assertion. |
| A15-11 | Event natural identity excludes runtime/normalizer/policy versions. A UUIDv7 event ID is minted once at the endpoint’s first durable effect commit and reused. |
| A15-12 | Forbidden source values have already been removed before endpoint storage/transport. The server must still run canaries and prevent diagnostics/integration from creating new leakage. |
| A15-13 | Distinguish durably received, validated, materialized, quarantined, integrated, and visible states. |
| A15-14 | Facts and aggregates are server-derived; integrations remain behind narrow versioned server-side contracts. |
| A15-15 | A failed early gate stops dependent work. Passing proves only the named claim, workload, engine, topology, and failure domain. |

## 2.5 Assumptions used only to define a prototype

| ID | ASSUMPTION | Containment |
|---|---|---|
| AS15-01 | The first server batch envelope can be represented as strict bounded UTF-8 JSON and the first G8 compression profile can use one streaming algorithm. | The contract is versioned; exact encoding and limits are CLI-tested and may change by ADR. |
| AS15-02 | A bounded batch can be held in pooled process memory long enough to verify wire/uncompressed hashes before a short database transaction. | Admission concurrency and byte caps prevent unbounded memory; G8 measures whether spill or direct streaming is needed. |
| AS15-03 | One batch initially uses one outer envelope version and one event schema/version. | Mixed-schema batches are rejected or quarantined; future sub-batch semantics require a new contract. |
| AS15-04 | One shared logical database can isolate realms through authenticated context, composite keys, least-privilege roles, optional RLS, and negative tests. | Per-realm databases remain an alternative if legal/operational evidence requires stronger physical isolation. |
| AS15-05 | Whole-batch semantic atomicity is affordable for the first slice. | Exact batch/event limits and transaction duration are measured; no partial fallback is added silently. |
| AS15-06 | Typed Edge site/domain facts can be modeled once human field decisions exist. | Example fact columns are illustrative and cannot authorize production fields. |

## 2.6 Unknowns that constrain this result

**UNKNOWN.** There is no representative evidence for:

- events, bytes, batches, retries, duplicates, poison, outage, or burst distributions;
- approved batch/event/decompression/resource limits;
- production retention, legal holds, deletion, or reprocessing horizon;
- approved schema support window;
- durable failure domain, RPO, RTO, SLO, or receipt cleanup grace;
- PostgreSQL versus SQL Server throughput, failover, backup/restore, licensing, skills, or support fitness;
- partition grain, index set, connection-pool size, worker count, lease duration, retry values, or fairness weights;
- external broker need;
- exact projection/query corpus;
- operational ownership, support hours, incident authority, staffing, and budget.

This result converts those unknowns into explicit **HUMAN DECISION** records or **CLI EXPERIMENTS** rather than selecting hidden defaults.

## 2.7 No accepted-baseline conflict

**FACT.** The recommended design preserves all accepted decisions. No baseline change proposal is raised. A future implementation must open an explicit change proposal before it:

- returns a receipt before relational custody commits;
- uses payload/body/header/certificate text as realm authority;
- replaces relational inbox custody with an external broker or object store;
- partially materializes a batch without a new receipt/status contract;
- accepts same batch/event identity with different content as a retry;
- permits a stale lease to commit;
- deletes unacknowledged or unreconciled payloads under pressure;
- makes integration success part of durable receipt or fact materialization;
- adds arbitrary tenant SQL/script/transform/reprocess behavior.

---

# 3. Recommended design with exact component responsibilities and trust boundaries

## 3.1 Component map

| Component | Exact responsibility | Explicit prohibitions |
|---|---|---|
| Public network/L4 load balancer | TLS routing and connection limits without changing client-certificate identity | no trusted realm/device headers; no semantic receipt |
| Optional L7 identity gateway | validate client certificate/status, strip untrusted forwarding/identity headers, enforce bounded body, issue request-bound signed assertion, authenticate to backend | no plain XFCC authority; no direct backend path; no payload mutation/recompression; no receipt |
| Server identity boundary | construct immutable `AuthenticatedDeviceContext`; check current credential status/epoch; inject it into request scope | no body/header/route/cert-subject realm; no stale soft allow |
| Ingestion API | enforce route/header/media/encoding/byte/time/digest/outer-envelope limits; create or replay durable receipt | no application lookup, aggregate update, integration call, broker send, long DB transaction, arbitrary payload log |
| Inbox writer | perform one acceptance transaction for batch metadata, exact wire payload, and receipt/conflict outcome | no semantic materialization; no receipt outside transaction |
| Relational durable inbox | immutable custody, processing state, lease/fencing state, terminal outcome, retention/hold links | no raw endpoint-forbidden data; no mutable payload bytes; no realm-less key |
| Materialization scheduler | choose eligible realms/batches fairly and claim short leases using database time | no long-held transaction; no closest-realm fallback; no payload parsing inside claim transaction |
| Materialization worker | decompress/parse/validate outside transaction; create deterministic plan; heartbeat; commit dedupe/facts/work/outbox/state atomically | no partial commit; no integration call inside transaction; no stale-token commit |
| Quarantine service | record immutable terminal occurrence, reason taxonomy, processor/schema evidence, reprocess eligibility and governed replay history | no raw payload in logs/UI by default; no free-form code/SQL; no silent delete |
| Fact store | immutable typed facts and explicit provenance | no generic mutable JSON fact as the normal model; no direct endpoint writes |
| Projection worker | consume projection-work rows idempotently; insert contribution ledger and update aggregate in one transaction | no fact mutation; no projection result as receipt authority |
| Integration outbox worker | deliver governed contract messages at least once using stable message IDs and record delivery state | no integration network I/O inside fact transaction; no integration acknowledgement as fact authority |
| Reconciler | prove receipt→payload→terminal outcome, event→dedupe→fact, fact→projection/outbox, and restore readiness | no automatic destructive repair; no invented custody/fact |
| Control API/BFF | metadata-first quarantine/replay/drain/health operations with authorization and durable privileged audit | no database credentials to endpoints; no arbitrary SQL; no unrestricted payload download |
| Migration tool | explicit engine-specific DDL migration under separate authority; expand/backfill/contract and rollback evidence | no application-startup destructive migration; no schema drift |

## 3.2 Trust-boundary sequence

```text
[Untrusted public request]
      |
      | TLS client certificate or L4-preserved mTLS
      v
[Identity boundary]
      - validates credential and current status
      - strips/ignores payload/header identity claims
      - creates immutable AuthenticatedDeviceContext
      |
      v
[Ingestion API process]
      - strict headers/media/encoding
      - compressed/decompressed/event/time/allocation limits
      - wire and canonical-content hash verification
      - strict outer envelope validation
      |
      v
[Receipt transaction / declared durable failure domain]
      - insert immutable batch metadata
      - insert exact wire payload
      - insert immutable receipt
      - commit
      |
      +--> response may be lost; identical replay returns same receipt
      v
[Relational inbox queue]
      - per-realm admission/fairness
      - lease owner/token/version/expiry
      |
      v
[Worker process]
      - parse/semantic validation outside transaction
      - deterministic plan or quarantine reason
      |
      v
[Materialization transaction]
      - fence lease
      - event dedupe/identity checks
      - typed facts
      - projection work
      - integration outbox
      - terminal batch state
      - commit
      |
      +--> [projection visibility]
      +--> [governed integrations]
      +--> [reconciliation]
```

## 3.3 Authenticated identity and header stripping

### 3.3.1 Direct/L4 path — default

**RECOMMENDATION.** The first G8 server path terminates mTLS at the ASP.NET Core/Kestrel origin or preserves it through an L4 load balancer. The server certificate-authentication handler validates the certificate chain/profile, then an application identity service checks current UAM credential status and creates:

```text
AuthenticatedDeviceContext {
    realm_id
    installation_id
    enrollment_epoch
    credential_id
    credential_generation
    assurance_level
    credential_status
    status_version
    issuer_id
    trust_domain_id
    authenticated_at_utc
}
```

The context is immutable for the request. The body schema contains no authoritative `realmId`, `tenantId`, `deviceId`, `installationId`, credential status, or role. Hostname, IP, certificate subject/SAN, route/query, and forwarded header cannot override the context.

### 3.3.2 Conditional L7 path

An L7 gateway is **DEFERRED** until its own security/performance gate. If used, it MUST:

1. validate the client certificate and current credential status;
2. remove every inbound instance and case/underscore variant of `Forwarded`, `X-Forwarded-*`, `X-Client-Cert`, `X-Forwarded-Client-Cert`, and all `UAM-Auth-*`, `UAM-Realm-*`, `UAM-Installation-*`, and `UAM-Credential-*` headers;
3. overwrite only the explicitly required proxy headers from trusted gateway facts;
4. prevent direct public/backend access and authenticate to the backend with gateway mTLS;
5. verify the exact bounded request body and its digests;
6. issue a short-lived signed assertion bound to method, normalized target, wire digest, credential ID/generation, realm, installation, enrollment epoch, audience, gateway ID, nonce, issued time, and expiry;
7. ensure the backend independently checks the assertion and current UAM credential status.

A forwarded certificate header alone is not UAM authority. Because request binding needs the body digest, the simplest L7 profile buffers the already bounded batch before backend forwarding; its memory, latency, and failover costs are a **CLI EXPERIMENT**. Until it passes, direct/L4 mTLS remains the supported path.

## 3.4 Ingestion request pipeline

The API pipeline is deliberately narrow:

1. authenticate and construct `AuthenticatedDeviceContext`;
2. apply global and per-authenticated-realm connection/request admission;
3. reject unexpected method/path/query/header duplicates before reading the body;
4. require a single recognized content type and exactly one allowed content encoding;
5. enforce compressed-byte count while reading;
6. compute `wire_content_sha256` over the exact content-coded bytes;
7. stream through the selected decompressor while enforcing decompressed-byte, expansion-ratio, time, depth, string, and event-count limits;
8. compute `batch_content_sha256` over the exact decompressed canonical contract bytes;
9. verify both declared digests and strict UTF-8/outer-envelope constraints;
10. compare header/body batch identity and declared counts;
11. enter one short receipt transaction;
12. return a newly created or replayed receipt only after commit.

The API MUST NOT perform application-registry joins, event-by-event business validation, aggregate updates, integration calls, or projection work before receipt. Those operations are intentionally asynchronous so poison or temporarily unavailable reference data cannot hold the acceptance connection or change custody semantics.

## 3.5 Canonical batch and wire identity

Two hashes have different meanings and both are required:

| Hash | Bytes covered | Purpose |
|---|---|---|
| `wire_content_sha256` | exact content-coded HTTP body bytes as received | proves exact sealed replay bytes, detects recompression/truncation, binds gateway assertion and custody payload |
| `batch_content_sha256` | exact decompressed canonical batch-contract bytes | stable batch content identity independent of transport framing; checked against endpoint sealed metadata |

**FACT.** RFC 9530 `Content-Digest` covers the HTTP message content after content coding and is an integrity field, not sender authentication. UAM therefore uses the standard `Content-Digest` for wire bytes and a separate versioned `UAM-Batch-Content-Digest` for the decompressed canonical contract bytes. mTLS or the gateway assertion supplies authentication.

Canonical bytes are owned by the batch contract. For the first JSON profile they are strict UTF-8 without BOM, duplicate members, comments, trailing data, invalid numbers, or unknown outer members. The exact canonicalization profile and vectors are inherited from Batch 01. The server computes the hash over bytes; it does not “helpfully” normalize Unicode, reorder events, default missing fields, or coerce values.

## 3.6 Cheap synchronous validation versus asynchronous semantic validation

### Synchronous, before receipt

The API MUST establish only what is necessary for safe custody and idempotent replay:

- valid authenticated device context and current status;
- exact route/method/query policy;
- singleton headers and allowed media/encoding;
- bounded compressed/decompressed body, ratio, time, allocations, structure, strings, and event count;
- valid wire and canonical-content digests;
- strict UTF-8 and parseable supported outer batch envelope;
- header/body batch ID/hash/count agreement;
- no authority-bearing realm/device fields;
- batch ID and event list syntactically present and bounded;
- immutable payload is safe to persist as minimized UAM data.

### Asynchronous, after receipt

Workers establish:

- inner event schema support;
- every event structural/semantic rule;
- field ranges and provenance relationships;
- application/rule/reference existence under the declared interpretation;
- event ID/hash duplicate or conflict behavior;
- typed fact construction;
- projection/integration eligibility;
- quarantine or materialization terminal outcome.

An unsupported **outer** envelope that cannot be safely parsed receives no receipt. An outer envelope that is supported but names an unsupported **inner event schema** can be durably received and then explicitly quarantined as `UNSUPPORTED_EVENT_SCHEMA`. This distinction preserves receipt meaning without requiring the API to support every historical event type forever.

## 3.7 Durable receipt transaction

The acceptance transaction is:

```text
BEGIN;

1. Try to insert ingest_batch identity/metadata in RECEIVED state.
2. If the key already exists, lock/read the existing immutable row.
   a. Same content hash AND same wire hash AND same authenticated installation:
      return the existing receipt after transaction completion.
   b. Any immutable mismatch:
      append a conflict/audit record; do not change the original batch/receipt;
      commit conflict evidence; return HTTP 409 and no new receipt.
3. For a new batch, insert exact wire payload and payload metadata.
4. Insert immutable ingest_receipt with declared failure-domain class.
5. Commit according to the configured durability profile.
6. Only after successful commit build/send the HTTP receipt response.
```

Batch, payload, and receipt are in one database transaction. There is no state where a valid receipt exists without its payload or where a payload is accepted without a receipt row. A database commit followed by API process death or network response loss is expected: the endpoint replays the same batch, and uniqueness plus hash comparison returns the original receipt.

## 3.8 Duplicate and conflict matrix

| Condition under same authenticated realm/installation | Result |
|---|---|
| New batch ID | create payload + batch + receipt; `201 Created` |
| Existing batch ID, same canonical content hash and same wire hash | return same immutable receipt; `200 OK`, replay indicator |
| Existing batch ID, same content hash but different wire hash | `409 BATCH_WIRE_IDENTITY_CONFLICT`; preserve original; security/data-quality evidence |
| Existing batch ID, different content hash | `409 BATCH_CONTENT_IDENTITY_CONFLICT`; preserve original; security/data-quality evidence |
| Same content under a different batch ID | accept custody; event-level uniqueness later prevents duplicate facts |
| Same event ID and same event effect hash in same or another batch | materialization no-op for that event; link provenance; no second fact |
| Same event ID and different effect hash | whole batch `QUARANTINED_TERMINAL/EVENT_IDENTITY_CONFLICT`; no partial facts |
| Batch ID exists in a different realm/installation | not visible; request is evaluated only in authenticated scope; generic not-found/conflict behavior prevents enumeration |

The design does not depend on a generic `Idempotency-Key`; `batch_id` is the protocol idempotency identity and is already sealed/persisted by the endpoint.

## 3.9 Relational worker claims, leases, and fencing

A worker never holds a transaction while decompressing, parsing, validating, or calling a reference service.

### Claim transaction

1. select an eligible realm under the fairness policy;
2. select one or a small bounded set of `RECEIVED`, `RETRY_WAIT`, or expired-lease batches using engine-specific queue locks;
3. set `processing_state=LEASED`;
4. set `lease_owner_id`, random `lease_token`, incremented `lease_version`, `lease_acquired_at_utc`, and `lease_expires_at_utc` using database time;
5. increment realm inflight state;
6. commit and return the claimed rows.

### Processing outside transaction

The worker reads the immutable payload, verifies stored hashes again, decompresses with the same safety limits, parses, validates, and creates a deterministic materialization plan. It heartbeats only by matching realm/install/batch, token, and lease version. A zero-row heartbeat means the lease is lost; the worker cancels and cannot commit.

### Final materialization transaction

The worker locks the batch row and requires:

```text
state = LEASED
AND lease_owner_id = expected
AND lease_token = expected
AND lease_version = expected
AND lease_expires_at_utc > database_now
```

It may atomically extend the lease and enter `COMMITTING` at transaction start. It then applies dedupe/facts/work/outbox/state and clears/decrements lease/inflight state in the same commit. A reclaimed or stale worker cannot pass the predicate. Unique event constraints remain a second independent safety layer.

## 3.10 Fairness and backpressure

**RECOMMENDATION.** Use two-level scheduling rather than one global oldest-row scan:

- `realm_work_state` maintains value-free backlog/inflight scheduling facts;
- all realms begin with equal service weight unless an accountable human decision defines a class;
- each realm has a bounded inflight ceiling and admission budget;
- the scheduler selects a realm by oldest eligible work plus a virtual-finish/round-robin value, then claims a batch within that realm;
- no tenant can submit an executable priority expression or create an unbounded dedicated queue;
- global emergency controls can stop acceptance or processing; tenant controls can only narrow/disable their realm.

Exact weights, inflight counts, lease length, batch claim size, and retry delays are **ESTIMATE/CLI EXPERIMENT** inputs. The mandatory property is that one busy realm cannot permanently starve another and cannot exhaust every API/worker/database connection.

Backpressure has three layers:

1. **before body:** reject with `429` or `503` when identity, rate, database health, connection, memory, or durable-storage admission is unavailable;
2. **during body:** terminate on compressed/decompressed/time/ratio/allocation limits with no receipt;
3. **after receipt:** pause workers/integrations while preserving custody; never delete unacknowledged or unmaterialized data to make room.

A response without a valid receipt means no custody claim. `Retry-After` is advisory and never changes the stable endpoint batch identity.

## 3.11 Whole-batch materialization

**RECOMMENDATION.** The first slice materializes a batch atomically at the business-effect level:

```text
BEGIN;
  fence lease;
  validate expected processor/schema generation;
  for every event:
      calculate deterministic effect hash;
      inspect/lock event_dedupe by (realm_id, event_id);
      classify NEW / SAME_REPLAY / CONFLICT;
  if any CONFLICT or deterministic poison:
      insert quarantine occurrence;
      set batch QUARANTINED_TERMINAL;
      clear lease/decrement inflight;
      COMMIT;                 # no new facts from this batch
  else:
      insert NEW event_dedupe rows;
      insert corresponding typed facts;
      record replay provenance for SAME_REPLAY events;
      insert projection_work rows;
      insert integration_outbox rows where governed;
      set batch MATERIALIZED with counts/digests/version;
      clear lease/decrement inflight;
      COMMIT;
```

The worker does not insert a fact and later update the batch in another transaction. Therefore “worker died after fact insert” has only two durable outcomes: the whole transaction committed, including `MATERIALIZED`, or the database rolled it back. Lost worker acknowledgement is resolved by reading the committed batch state.

## 3.12 Facts, projections, visibility, and integrations

Typed facts are authoritative. A common fact envelope records realm, event, batch, installation, source/generation/interpretation provenance, fact type/schema, effect hash, materializer version, and materialized time. Fact-type tables store approved typed fields. The illustrative Edge fact schema in section 5 is not field approval.

Projection work is inserted in the materialization transaction but processed separately. A projection worker uses a unique contribution key `(realm_id, projection_id, projection_version, fact_id)` and updates the aggregate in the same transaction as that contribution row. A retry cannot apply the same fact twice. Facts remain replayable when a projection algorithm changes.

Integration messages are also inserted in the materialization transaction. Delivery is at least once with a stable `integration_message_id`; recipients must implement their governed idempotency contract. Integration failure cannot roll back receipt or facts. Portal visibility is a separate projection/readiness state and is never implied by `MATERIALIZED`.

## 3.13 Quarantine and governed replay

A terminal quarantine means “no automatic retry under the current processor/schema decision,” not “delete or ignore.” It records:

- immutable quarantine occurrence ID and processing generation;
- finite reason family/code and failing stage;
- batch/event schema and processor/materializer versions;
- safe expected/observed digests or counts, never raw payload in ordinary logs;
- first/last time, retry classification, and support owner;
- reprocess eligibility and required minimum artifact/version;
- retention class and legal-hold state;
- audit link for every operator action.

Operators normally see metadata, finite reason codes, counts, schema versions, and hashes. Raw payload export is absent from the normal BFF. T1 lab tooling can inspect fictional payloads. A governed reprocess command creates a new `processing_generation`, records actor/authority/reason/target materializer, and returns the existing batch to `REPROCESS_PENDING`; it never edits or erases the prior quarantine occurrence.

## 3.14 Restore and readiness

After any restore/failover whose exact commit point is uncertain, the service enters `RESTORE_RECONCILIATION_HOLD` before accepting a readiness claim. The reconciler checks:

- every receipt has its batch and payload with matching hashes;
- every materialized batch has the expected event-dedupe/fact counts;
- every quarantined batch has a terminal occurrence;
- no batch is both materialized and terminal-quarantined;
- leases from dead epochs are expired/reclaimed safely;
- projection and integration outboxes are reconstructible from facts;
- receipt IDs/content hashes do not conflict;
- restored deletion/hold state is honored before portal visibility.

If the restore point predates an issued receipt, the server cannot manufacture the lost batch. Endpoints may replay only if they retained it. This is why production endpoint cleanup remains disabled until the failure-domain/RPO and restore evidence are approved.

## 3.15 Configuration ownership, flags, and kill switches

Release/operations configuration is closed, versioned, audited, and narrowing-only. Initial flags are finite IDs such as:

```text
ingestion.accept.enabled
ingestion.accept.schema.<major>.enabled
ingestion.accept.realm.<realm>.enabled
materializer.enabled
materializer.schema.<id>.enabled
projection.<id>.enabled
integration.<destination-id>.enabled
reprocess.enabled
payload_cleanup.enabled
```

No flag value can contain SQL, code, script, regex, URL, path, queue name, transform, arbitrary header, or serializer type. Tenant/realm policy can only disable or reduce limits. Emergency kill can stop new accepts, one schema, one realm, workers, projections, integrations, reprocessing, or cleanup independently. Disabling workers does not invalidate existing receipts; it increases backlog and must surface value-free health.

## 3.16 Database roles and least privilege

The deployment SHOULD use separate credentials/roles:

| Role | Allowed operations | Denied operations |
|---|---|---|
| `uam_ingest_api` | execute acceptance/receipt procedures; insert conflict evidence; lookup receipt in authenticated scope | facts, projections, integration send, schema DDL, arbitrary payload query |
| `uam_materializer` | claim/heartbeat/fence batches; read payload; insert dedupe/facts/work/outbox/quarantine; update terminal state | receipt creation, cross-realm admin, DDL, privileged reprocess |
| `uam_projection` | claim projection work; insert contribution/update aggregate | payload, receipt mutation, fact mutation |
| `uam_integration` | claim/send/update integration outbox | payload, receipt/fact mutation |
| `uam_reconciler` | read integrity views; insert findings and readiness runs | destructive repair by default |
| `uam_control_api` | metadata views and approved stored operations with durable audit | direct table DML, unbounded payload reads, DDL |
| `uam_migrator` | versioned DDL under deployment authority | runtime use |

Endpoints never receive any database credential or submit SQL.

---

# 4. Alternatives, rejection reasons, and conditions that would change the choice

## 4.1 Alternatives table

| Alternative | Decision now | Why rejected/deferred | Condition that would change the decision |
|---|---|---|---|
| Validate/materialize synchronously before receipt | **REJECT** | Couples endpoint availability to semantic/reference/projection work; poison holds requests; receipt meaning becomes ambiguous; long transactions increase locks and response-loss cost. | Only if the business requires semantic rejection before custody and a bounded prototype proves equal durability/availability without weakening receipt semantics. |
| External broker as the first acceptance boundary | **REJECT — accepted baseline** | Adds another failure domain, identity/ACL/retention/restore/operations surface; changes receipt meaning; no measured need. | Measured relational break-even in section 4.4 plus a full broker custody/replay/restore/cost ADR. |
| Broker after relational receipt but before workers | **DEFER** | Duplicates queue state and requires an outbox to the broker; relational inbox already supplies replay and leasing. | Required independent worker failure isolation/fan-out and measured lower total cost/latency than relational claims. |
| Object storage payload plus relational pointer | **REJECT initially** | Creates dual-write/atomic-custody problem and a second access/retention/backup domain. | Inline relational payload demonstrably breaches approved size/cost/restore limits and a transactional manifest/conditional-write design passes all receipt fault tests. |
| Unlogged/temp table then promote | **REJECT** | Receipt could outlive temp/unlogged data under crash/restore; outside declared custody. | No expected ordinary change. |
| One database per realm | **DEFER** | Stronger physical separation but large migration, connection, backup, schema, and operations cost; no requirement or realm count is approved. | Legal/security isolation decision or measured noisy-neighbor limits that shared logical isolation cannot contain. |
| One queue table per realm/schema | **REJECT initially** | DDL/table explosion, unfair operations, complex migrations and observability. | A small bounded realm set plus measured partition/table benefit and manageable lifecycle. |
| Partial valid-event materialization from a poison batch | **REJECT first slice** | Creates multiple acknowledgement/receipt meanings, replay subsets, partial correction, and endpoint/server disagreement. | Batches become too large or heterogeneous and a versioned per-event terminal-status contract proves simpler/safer. |
| Store only parsed normalized JSON | **REJECT** | Loses exact custody evidence and parser-replay ability; may silently change bytes. | Never as sole custody representation. A derived parse cache may be added after measurement. |
| Generic JSON fact table | **REJECT as normal model** | Weak type/constraint/query/privacy boundaries; schema drift moves to application code. | Use only for explicitly governed extension payloads that cannot affect authority and have a typed envelope. |
| Database trigger performs materialization | **REJECT** | Hides business/version/error logic in privileged database code; hard to test/roll back/observe; risks long receipt transaction. | A tiny invariant-enforcement trigger may be used, but not the semantic pipeline. |
| Database `MERGE` as portable idempotency abstraction | **REJECT** | Semantics and lock behavior differ by engine; explicit insert/unique-conflict/read is easier to reason about and fault-test. | No need. Engine adapter may use a proved equivalent internally under the same tests. |
| Exactly-once transport claim | **REJECT** | Response loss and replay remain possible; the controllable property is at-least-once delivery with stable identity and idempotent effect. | No wording change; only a different implementation mechanism could preserve the same business effect. |
| Generic Hangfire/MassTransit/Wolverine/CAP/Brighter dependency for core inbox | **REFERENCE ONLY initially** | Frameworks bring broader scheduler/broker/serialization/UI/migration authority and different threat models; UAM’s state machine is small and security-sensitive. | A dependency admission experiment shows materially lower defect/operations cost without losing contracts, realm isolation, fault hooks, licensing clarity, or engine parity. |
| PostgreSQL selected immediately | **DEFER production choice** | Strong queue primitives and permissive license do not prove UAM operations/restore/skills/cost. | Identical G8/capacity/restore benchmark and human operations/licensing decision. |
| SQL Server selected immediately | **DEFER production choice** | Existing skills/transition fit may help, but commercial licensing, lock behavior, edition/HA and restore evidence are unknown. | Same identical evidence and human decision. |

## 4.2 Why whole-batch atomicity is the conservative first choice

Partial success appears attractive because one poison event would not block siblings. It is not free. It requires the endpoint and server to agree on per-event custody, terminal status, replay and cleanup; a receipt can no longer be explained as one batch state; and a corrected processor must avoid duplicating already accepted siblings. Whole-batch materialization keeps the first G8 invariant small:

```text
one receipt -> one terminal batch outcome
one event ID -> zero or one new fact
```

The cost is that one poison event quarantines the batch. That cost is bounded by the as-yet-unselected batch size. G8 must measure poison amplification and operator burden. A later change requires a contract/ADR, not an internal optimization.

## 4.3 PostgreSQL versus SQL Server adaptation

The logical model is engine-neutral, but queue claims are not hidden behind “generic SQL.” The adapters use documented primitives:

- PostgreSQL: `INSERT ... ON CONFLICT`, row locks, `FOR UPDATE SKIP LOCKED`, `RETURNING`, database time, and explicit synchronous-commit/replication settings.
- SQL Server: unique indexes, explicit `UPDLOCK`/`READPAST`/`ROWLOCK` claim statements, `OUTPUT`, database time, and explicit transaction-log/Always On commit settings.

PostgreSQL documents `SKIP LOCKED` as providing an inconsistent view suitable for queue-like access; it must not be used for authoritative reads. SQL Server documents `READPAST` as a work-queue technique but it may skip row locks rather than page locks, and lock escalation can occur. Both designs therefore require hot-queue, fairness, failover, and starvation experiments rather than assuming equivalent behavior.

## 4.4 External broker break-even requirements

A broker ADR becomes eligible only when at least one approved requirement cannot be met by the relational design and the measured replacement is better overall. The trigger is not endpoint count alone.

| Trigger category | Required evidence before a broker ADR is eligible |
|---|---|
| Relational resource cost | Identical workload shows inbox claim/heartbeat/retry/cleanup consumes more than the approved DB CPU/I/O/log/lock/headroom budget after index/query/batch tuning. |
| Independent failure domain | An approved requirement says ingestion custody must remain available when the fact/materialization database is unavailable, and a broker failure domain/receipt contract is explicitly defined. |
| Replay/log | Approved independent consumers require retained ordered replay that the integration outbox cannot provide economically. |
| Fan-out | Number, independence, or delivery cadence of consumers causes the relational integration outbox to breach approved SLO/cost. |
| Regional availability | Approved cross-region ingestion/processing goals cannot be met by the selected relational topology and restore model. |
| Operational cost | Total three-year infrastructure, licensing, staffing, on-call, security, backup/restore, and incident cost is lower with the broker under the same failure tests. |
| Security/isolation | A broker demonstrably reduces—not merely moves—realm/noisy-neighbor risk under a reviewed identity/ACL/retention model. |

The comparison must include duplicate delivery, poison handling, replay after restore, schema migration, realm isolation, credential compromise, lost acknowledgement, monitoring, and cleanup. Popularity or synthetic throughput alone is not a break-even proof.


---

# 5. Interfaces/protocols and example contracts or schemas; normative where possible

## 5.1 HTTP endpoint contract

### 5.1.1 Submit a batch

```http
POST /ingestion/v1/batches HTTP/1.1
Host: ingestion.example.invalid
Content-Type: application/vnd.uam.ingestion-batch+json; version=1
Content-Encoding: gzip
Content-Length: <bounded compressed bytes>
Content-Digest: sha-256=:<base64 digest of exact gzip bytes>:
UAM-Batch-Id: 019d0000-0000-7000-8000-000000000101
UAM-Batch-Contract: 1.0.0
UAM-Batch-Content-Digest: sha-256=:<base64 digest of decompressed canonical bytes>:
```

All example IDs and values in this result are fictional.

Normative rules:

1. The route has no realm, tenant, device, or installation segment or query parameter.
2. `POST` is the only accepted method. A request query string is rejected.
3. Header names are case-insensitive, but each UAM singleton header MUST occur exactly once after HTTP normalization. A comma-joined duplicate is rejected.
4. `Content-Type` MUST match an allowlisted exact media type/profile. Generic `application/json` is not accepted for the ingestion route.
5. Exactly one `Content-Encoding` is allowed. The first G8 profile is **RECOMMENDATION — `gzip` only**. Multiple codings or unsupported coding return `415` without receipt.
6. `Content-Length`, when present, is the compressed-byte length and MUST be within the configured limit. Chunked transfer remains subject to the same counted limit.
7. `Content-Digest` uses RFC 9530 syntax and covers exact content-coded bytes. `UAM-Batch-Content-Digest` uses the same digest-value syntax but covers the exact decompressed canonical bytes.
8. `UAM-Batch-Id` MUST be canonical lower-case UUIDv7 and must equal the body `batchId`.
9. Client-supplied realm, installation, device, credential, role, forwarding-certificate, or gateway-assertion headers are ignored/stripped at the public boundary and rejected where the strict profile says they are forbidden.
10. The endpoint MUST NOT follow an HTTP redirect to another ingestion authority without an explicit release-owned destination contract.
11. `Expect: 100-continue` MAY be used for admission efficiency, but the server correctness model does not depend on it.
12. Request bodies, digests, certificate fields, and identifiers MUST NOT be included in general access logs or metric labels.

### 5.1.2 First batch-envelope example

```json
{
  "contract": "uam.ingestion.batch",
  "version": "1.0.0",
  "batchId": "019d0000-0000-7000-8000-000000000101",
  "createdAtUtc": "2026-07-31T12:00:00Z",
  "eventContract": "uam.edge-site-activity-event/1.0.0",
  "eventCount": 2,
  "events": [
    {
      "eventId": "019d0000-0000-7000-8000-000000000201",
      "sourceId": "019d0000-0000-7000-8000-000000000301",
      "sourceGenerationId": "019d0000-0000-7000-8000-000000000302",
      "interpretationId": "sha-256:fictional-interpretation",
      "applicationId": "019d0000-0000-7000-8000-000000000401",
      "siteKind": "CANONICAL_HOST",
      "siteValue": "portal.fictional-example.test",
      "observedBucketStartUtc": "2026-07-31T11:00:00Z",
      "timePrecision": "HOUR"
    },
    {
      "eventId": "019d0000-0000-7000-8000-000000000202",
      "sourceId": "019d0000-0000-7000-8000-000000000301",
      "sourceGenerationId": "019d0000-0000-7000-8000-000000000302",
      "interpretationId": "sha-256:fictional-interpretation",
      "applicationId": "019d0000-0000-7000-8000-000000000402",
      "siteKind": "CANONICAL_HOST",
      "siteValue": "docs.fictional-example.test",
      "observedBucketStartUtc": "2026-07-31T11:00:00Z",
      "timePrecision": "HOUR"
    }
  ]
}
```

**HUMAN DECISION.** `siteValue`, `applicationId`, observed time, precision, identity projection, and all real event fields are illustrative, not approved. The load-bearing contract properties are closed outer structure, stable batch/event IDs, one declared event contract, bounded values, and absence of realm/device authority claims.

### 5.1.3 Streaming limits

Every active batch-contract profile MUST publish these named limits, even when the numeric values are still bootstrap estimates:

```text
max_compressed_bytes
max_decompressed_bytes
max_expansion_ratio
max_event_count
max_json_depth
max_object_properties
max_string_utf8_bytes_by_field
max_total_scalar_count
max_header_bytes
max_read_duration
max_decompression_cpu_or_wall_budget
max_concurrent_inflight_requests_global
max_concurrent_inflight_requests_per_realm
```

The implementation MUST enforce compressed and decompressed limits independently. Ratio alone is insufficient because a small but expensive stream can exceed CPU/time, while a low-ratio body can still exceed absolute size. The server MUST stop decompression/parser work promptly on cancellation or any exceeded bound and must not store a partial payload or issue a receipt.

ASP.NET Core request-decompression middleware documents that unsupported or multiple content encodings can be passed onward and that it removes `Content-Encoding` when it wraps the body. **RECOMMENDATION.** The UAM route therefore uses a dedicated strict ingestion reader or an equally tested route-specific wrapper; it does not rely on permissive middleware defaults as the protocol oracle.

## 5.2 Receipt contracts

### 5.2.1 New receipt response

```http
HTTP/1.1 201 Created
Content-Type: application/vnd.uam.ingestion-receipt+json; version=1
Cache-Control: no-store
Location: /ingestion/v1/batches/019d0000-0000-7000-8000-000000000101/receipt

{
  "contract": "uam.ingestion.receipt",
  "version": "1.0.0",
  "receiptId": "019d0000-0000-7000-8000-000000000501",
  "batchId": "019d0000-0000-7000-8000-000000000101",
  "batchContentDigest": "sha-256:fictional-content-digest",
  "wireContentDigest": "sha-256:fictional-wire-digest",
  "custodyState": "DURABLY_RECEIVED",
  "failureDomainClass": "PRIMARY_RELATIONAL_COMMIT_V1",
  "durableAtUtc": "2026-07-31T12:00:01.123456Z",
  "receiptSequence": 1,
  "statusUri": "/ingestion/v1/batches/019d0000-0000-7000-8000-000000000101/receipt",
  "serverContractProfile": "uam-ingestion-server/1"
}
```

Normative rules:

- The receipt body contains no semantic validation, materialization, projection, integration, or visibility claim.
- `durableAtUtc` is database-generated/recorded evidence, not endpoint business time.
- `failureDomainClass` is a closed server-controlled value whose exact meaning is documented and tested. The endpoint cleanup policy accepts only human-approved classes.
- Receipt content is immutable. A lookup/replay returns equivalent receipt fields; it does not rewrite the durable time or mint another receipt ID.
- Receipt authentication comes from the TLS/server identity and strict response contract. If a later signed receipt is required, it is a separate cryptographic profile and does not weaken the database transaction rule.
- The endpoint MUST compare batch ID and both digests before treating the response as a receipt.

### 5.2.2 Duplicate replay response

```http
HTTP/1.1 200 OK
Content-Type: application/vnd.uam.ingestion-receipt+json; version=1
Cache-Control: no-store
UAM-Receipt-Replay: true
```

The body is the original receipt. `UAM-Receipt-Replay` is informational; receipt equality is established by the body contract and stored identity/digests.

### 5.2.3 Receipt lookup

```http
GET /ingestion/v1/batches/{batchId}/receipt HTTP/1.1
```

Rules:

- The authenticated realm and installation scope the lookup; the route parameter is not globally enumerable authority.
- A matching receipt returns `200` and the immutable receipt body.
- No receipt in the authenticated scope returns generic `404` with no cross-realm existence signal.
- A batch payload, quarantine detail, materialization status, or portal visibility is not returned by this endpoint.
- The endpoint may use lookup after an ambiguous response before replaying the exact body. Replay remains safe even without lookup.

### 5.2.4 Conflict response

```http
HTTP/1.1 409 Conflict
Content-Type: application/problem+json
Cache-Control: no-store

{
  "type": "urn:uam:problem:batch-identity-conflict",
  "title": "Batch identity conflict",
  "status": 409,
  "code": "BATCH_CONTENT_IDENTITY_CONFLICT",
  "retryClass": "DO_NOT_RETRY_WITH_CHANGED_CONTENT"
}
```

The problem document follows RFC 9457 but contains only finite safe values. It does not echo received IDs, hashes, certificates, realm, installation, payload, or parser details. A separate privileged audit record retains the authenticated context and safe expected/observed digest references.

## 5.3 HTTP/error taxonomy

| HTTP | Stable code | Receipt? | Retry behavior |
|---:|---|---:|---|
| 201 | `DURABLY_RECEIVED_NEW` | yes | stop/reconcile endpoint outbox under approved cleanup policy |
| 200 | `DURABLY_RECEIVED_REPLAY` | yes | same as above |
| 400 | `REQUEST_HEADER_INVALID`, `OUTER_ENVELOPE_INVALID`, `DIGEST_FORMAT_INVALID` | no | producer/contract defect; do not mutate same batch bytes |
| 401 | `CLIENT_AUTHENTICATION_FAILED` | no | reauthenticate/re-enroll under identity runbook |
| 403 | `CLIENT_NOT_AUTHORIZED` | no | fail closed; no realm existence detail |
| 409 | `BATCH_CONTENT_IDENTITY_CONFLICT`, `BATCH_WIRE_IDENTITY_CONFLICT` | no new receipt | security/data-quality hold; never resend changed bytes under same ID |
| 413 | `COMPRESSED_LIMIT_EXCEEDED`, `DECOMPRESSED_LIMIT_EXCEEDED`, `EXPANSION_LIMIT_EXCEEDED`, `EVENT_COUNT_LIMIT_EXCEEDED` | no | producer must use a new contract-compliant batch identity after rebuilding from still-unacknowledged events |
| 415 | `MEDIA_TYPE_UNSUPPORTED`, `CONTENT_ENCODING_UNSUPPORTED` | no | use supported release contract; no silent fallback |
| 422 | `OUTER_CONTRACT_UNSUPPORTED` | no | consumer-first rollout or endpoint hold; inner schema unsupported is accepted then quarantined, not this response |
| 429 | `REALM_ADMISSION_LIMITED`, `GLOBAL_ADMISSION_LIMITED` | no | same exact batch, bounded backoff; honor `Retry-After` as advisory |
| 503 | `DURABLE_STORE_UNAVAILABLE`, `IDENTITY_STATUS_UNAVAILABLE`, `INGESTION_SAFETY_HOLD` | no | same exact batch after recovery; no custody inference |
| 500 | `INGESTION_INTERNAL_FAILURE` | no unless a separately valid response was received | endpoint treats as ambiguous and looks up/replays same batch |

A connection reset, timeout, TLS close, or malformed response is always ambiguous from the endpoint perspective; the endpoint retains/replays the same sealed batch.

## 5.4 Engine-neutral type mapping

| Logical type | PostgreSQL 18 profile | SQL Server 2025 profile |
|---|---|---|
| `UUID` | `uuid` | `uniqueidentifier` |
| `HASH32` | `bytea` with length check | `binary(32)` |
| `UTC_TIMESTAMP` | `timestamptz` | `datetime2(7)` with UTC contract |
| `BINARY_LARGE` | `bytea` | `varbinary(max)` |
| `TEXT_BOUNDED` | `text` plus check/application bound | `nvarchar(n)`/`varchar(n)` according to field contract |
| `INT64` | `bigint` | `bigint` |
| `BOOL` | `boolean` | `bit` |
| monotonically incremented row version | `bigint` updated explicitly | `bigint` updated explicitly; SQL `rowversion` MAY be additional concurrency evidence but is not portable domain meaning |

UUID textual order is not used as event/business order. Timestamps use database time for receipt, lease, and processing control; endpoint source time remains payload data.

## 5.5 Logical relational schemas

The following DDL is normative at the logical level. Engine-specific migrations must preserve the keys, checks, immutability, and transaction boundaries. Names/types may be adapted only through an accepted schema ADR.

### 5.5.1 Realm scheduler state

```sql
CREATE TABLE realm_work_state (
    realm_id                    UUID          NOT NULL,
    scheduling_class            TEXT_BOUNDED  NOT NULL DEFAULT 'ORDINARY',
    accepting_batches           BOOL          NOT NULL DEFAULT TRUE,
    processing_enabled          BOOL          NOT NULL DEFAULT TRUE,
    backlog_count               INT64         NOT NULL DEFAULT 0,
    inflight_count              INT64         NOT NULL DEFAULT 0,
    next_virtual_finish         INT64         NOT NULL DEFAULT 0,
    oldest_ready_at_utc         UTC_TIMESTAMP NULL,
    row_version                 INT64         NOT NULL DEFAULT 0,
    PRIMARY KEY (realm_id),
    CHECK (backlog_count >= 0),
    CHECK (inflight_count >= 0)
);
```

`backlog_count` and `oldest_ready_at_utc` are scheduling aids, not the integrity oracle; reconciliation derives them from inbox rows. Weights or special classes require a human-approved finite catalogue.

### 5.5.2 Batch metadata and lease state

```sql
CREATE TABLE ingest_batch (
    realm_id                    UUID          NOT NULL,
    installation_id             UUID          NOT NULL,
    batch_id                    UUID          NOT NULL,
    enrollment_epoch            INT64         NOT NULL,
    credential_generation       INT64         NOT NULL,

    batch_contract              TEXT_BOUNDED  NOT NULL,
    event_contract              TEXT_BOUNDED  NOT NULL,
    batch_content_sha256         HASH32        NOT NULL,
    wire_content_sha256          HASH32        NOT NULL,
    content_encoding             TEXT_BOUNDED  NOT NULL,
    compressed_bytes             INT64         NOT NULL,
    decompressed_bytes           INT64         NOT NULL,
    declared_event_count         INT64         NOT NULL,

    received_at_utc              UTC_TIMESTAMP NOT NULL,
    processing_state             TEXT_BOUNDED  NOT NULL,
    processing_generation        INT64         NOT NULL DEFAULT 1,
    processor_profile_id         TEXT_BOUNDED  NULL,
    next_attempt_at_utc          UTC_TIMESTAMP NULL,
    automatic_attempt_count      INT64         NOT NULL DEFAULT 0,

    lease_owner_id               UUID          NULL,
    lease_token                  UUID          NULL,
    lease_version                INT64         NOT NULL DEFAULT 0,
    lease_acquired_at_utc        UTC_TIMESTAMP NULL,
    lease_heartbeat_at_utc       UTC_TIMESTAMP NULL,
    lease_expires_at_utc         UTC_TIMESTAMP NULL,

    new_event_count              INT64         NULL,
    replay_event_count           INT64         NULL,
    fact_count                   INT64         NULL,
    terminal_reason_code         TEXT_BOUNDED  NULL,
    terminal_at_utc              UTC_TIMESTAMP NULL,

    payload_state                TEXT_BOUNDED  NOT NULL DEFAULT 'PRESENT',
    retention_class_id           TEXT_BOUNDED  NOT NULL,
    purge_after_utc              UTC_TIMESTAMP NULL,
    legal_hold_state             TEXT_BOUNDED  NOT NULL DEFAULT 'NONE',
    row_version                  INT64         NOT NULL DEFAULT 0,

    PRIMARY KEY (realm_id, installation_id, batch_id),
    CHECK (compressed_bytes >= 0),
    CHECK (decompressed_bytes >= 0),
    CHECK (declared_event_count >= 0),
    CHECK (processing_generation >= 1),
    CHECK (automatic_attempt_count >= 0),
    CHECK (lease_version >= 0),
    CHECK (processing_state IN (
        'RECEIVED','LEASED','RETRY_WAIT','MATERIALIZED',
        'QUARANTINED_TERMINAL','REPROCESS_PENDING','SAFETY_HOLD')),
    CHECK (payload_state IN ('PRESENT','PURGE_ELIGIBLE','PURGED','HOLD')),
    CHECK (legal_hold_state IN ('NONE','HELD','RELEASE_PENDING'))
);
```

Additional state checks MUST enforce:

- lease owner/token/times are non-null only while `LEASED`;
- terminal fields are present for materialized/quarantined/safety-hold states as applicable;
- a materialized batch cannot reference a current quarantine terminal outcome;
- a quarantined batch has no new facts from that processing generation;
- immutable identity/digest/size/contract/received fields cannot be updated after insert;
- payload cannot become `PURGED` without an approved audit/retention command and no hold.

### 5.5.3 Immutable wire payload

```sql
CREATE TABLE ingest_payload (
    realm_id                    UUID          NOT NULL,
    installation_id             UUID          NOT NULL,
    batch_id                    UUID          NOT NULL,
    payload_storage_class       TEXT_BOUNDED  NOT NULL DEFAULT 'RELATIONAL_INLINE_V1',
    exact_wire_bytes            BINARY_LARGE  NULL,
    wire_content_sha256         HASH32        NOT NULL,
    compressed_bytes            INT64         NOT NULL,
    content_encoding            TEXT_BOUNDED  NOT NULL,
    created_at_utc              UTC_TIMESTAMP NOT NULL,
    purged_at_utc               UTC_TIMESTAMP NULL,
    purge_evidence_id           UUID          NULL,
    PRIMARY KEY (realm_id, installation_id, batch_id),
    FOREIGN KEY (realm_id, installation_id, batch_id)
        REFERENCES ingest_batch(realm_id, installation_id, batch_id),
    CHECK ((exact_wire_bytes IS NOT NULL AND purged_at_utc IS NULL)
        OR (exact_wire_bytes IS NULL AND purged_at_utc IS NOT NULL))
);
```

The initial profile stores exact compressed bytes in the relational database. No object-store pointer is representable in `RELATIONAL_INLINE_V1`. A future storage class requires a new custody ADR and fault suite.

### 5.5.4 Immutable receipt

```sql
CREATE TABLE ingest_receipt (
    realm_id                    UUID          NOT NULL,
    installation_id             UUID          NOT NULL,
    batch_id                    UUID          NOT NULL,
    receipt_id                  UUID          NOT NULL,
    receipt_contract            TEXT_BOUNDED  NOT NULL,
    receipt_sequence            INT64         NOT NULL,
    custody_state               TEXT_BOUNDED  NOT NULL,
    failure_domain_class        TEXT_BOUNDED  NOT NULL,
    batch_content_sha256         HASH32        NOT NULL,
    wire_content_sha256          HASH32        NOT NULL,
    durable_at_utc              UTC_TIMESTAMP NOT NULL,
    server_contract_profile     TEXT_BOUNDED  NOT NULL,
    PRIMARY KEY (realm_id, installation_id, batch_id),
    UNIQUE (realm_id, receipt_id),
    FOREIGN KEY (realm_id, installation_id, batch_id)
        REFERENCES ingest_batch(realm_id, installation_id, batch_id),
    CHECK (custody_state = 'DURABLY_RECEIVED'),
    CHECK (receipt_sequence = 1)
);
```

Application and database permissions MUST make receipt rows append-only. Processing status is not added to this table.

### 5.5.5 Batch-identity conflict evidence

```sql
CREATE TABLE ingest_batch_conflict (
    realm_id                    UUID          NOT NULL,
    installation_id             UUID          NOT NULL,
    batch_id                    UUID          NOT NULL,
    conflict_id                 UUID          NOT NULL,
    conflict_code               TEXT_BOUNDED  NOT NULL,
    expected_batch_content_sha256 HASH32        NOT NULL,
    observed_batch_content_sha256 HASH32        NOT NULL,
    expected_wire_content_sha256  HASH32        NOT NULL,
    observed_wire_content_sha256  HASH32        NOT NULL,
    authenticated_credential_id UUID          NOT NULL,
    observed_at_utc             UTC_TIMESTAMP NOT NULL,
    operation_token             UUID          NOT NULL,
    PRIMARY KEY (realm_id, conflict_id),
    FOREIGN KEY (realm_id, installation_id, batch_id)
        REFERENCES ingest_batch(realm_id, installation_id, batch_id)
);
```

The conflicting body is not retained merely because it reused an ID. Ordinary telemetry records only the finite conflict code; this table is privileged integrity evidence.

### 5.5.6 Processing attempts

```sql
CREATE TABLE ingest_processing_attempt (
    realm_id                    UUID          NOT NULL,
    installation_id             UUID          NOT NULL,
    batch_id                    UUID          NOT NULL,
    processing_generation       INT64         NOT NULL,
    attempt_id                  UUID          NOT NULL,
    lease_version               INT64         NOT NULL,
    worker_build_id             TEXT_BOUNDED  NOT NULL,
    processor_profile_id        TEXT_BOUNDED  NOT NULL,
    started_at_utc              UTC_TIMESTAMP NOT NULL,
    completed_at_utc            UTC_TIMESTAMP NULL,
    outcome_family              TEXT_BOUNDED  NULL,
    reason_code                 TEXT_BOUNDED  NULL,
    retry_class                 TEXT_BOUNDED  NULL,
    safe_stage                  TEXT_BOUNDED  NULL,
    PRIMARY KEY (realm_id, attempt_id),
    FOREIGN KEY (realm_id, installation_id, batch_id)
        REFERENCES ingest_batch(realm_id, installation_id, batch_id)
);
```

Attempt history is bounded/retained under an approved class. It never contains exception messages, stack traces, payload excerpts, site values, or free-form SQL/library text.

### 5.5.7 Quarantine occurrence and reprocess audit

```sql
CREATE TABLE ingest_quarantine_occurrence (
    realm_id                    UUID          NOT NULL,
    installation_id             UUID          NOT NULL,
    batch_id                    UUID          NOT NULL,
    processing_generation       INT64         NOT NULL,
    quarantine_id              UUID          NOT NULL,
    reason_family              TEXT_BOUNDED  NOT NULL,
    reason_code                TEXT_BOUNDED  NOT NULL,
    failing_stage              TEXT_BOUNDED  NOT NULL,
    event_contract             TEXT_BOUNDED  NOT NULL,
    processor_profile_id       TEXT_BOUNDED  NOT NULL,
    first_recorded_at_utc      UTC_TIMESTAMP NOT NULL,
    terminal_at_utc            UTC_TIMESTAMP NOT NULL,
    affected_event_count       INT64         NULL,
    reprocess_eligibility      TEXT_BOUNDED  NOT NULL,
    required_artifact_id       TEXT_BOUNDED  NULL,
    retention_class_id         TEXT_BOUNDED  NOT NULL,
    legal_hold_state           TEXT_BOUNDED  NOT NULL DEFAULT 'NONE',
    PRIMARY KEY (realm_id, quarantine_id),
    UNIQUE (realm_id, installation_id, batch_id, processing_generation),
    FOREIGN KEY (realm_id, installation_id, batch_id)
        REFERENCES ingest_batch(realm_id, installation_id, batch_id)
);

CREATE TABLE ingest_reprocess_command (
    realm_id                    UUID          NOT NULL,
    command_id                  UUID          NOT NULL,
    installation_id             UUID          NOT NULL,
    batch_id                    UUID          NOT NULL,
    from_processing_generation  INT64         NOT NULL,
    to_processing_generation    INT64         NOT NULL,
    target_processor_profile_id TEXT_BOUNDED  NOT NULL,
    reason_code                 TEXT_BOUNDED  NOT NULL,
    authority_claim_id          UUID          NOT NULL,
    requested_by_subject_alias  TEXT_BOUNDED  NOT NULL,
    requested_at_utc            UTC_TIMESTAMP NOT NULL,
    audit_outbox_id             UUID          NOT NULL,
    PRIMARY KEY (realm_id, command_id),
    UNIQUE (realm_id, installation_id, batch_id, to_processing_generation)
);
```

A stored operation MUST insert the command and durable privileged-audit outbox row in the same transaction that changes the batch to `REPROCESS_PENDING`. No successful privileged mutation exists without audit evidence.

### 5.5.8 Event dedupe and provenance

```sql
CREATE TABLE event_dedupe (
    realm_id                    UUID          NOT NULL,
    event_id                    UUID          NOT NULL,
    installation_id             UUID          NOT NULL,
    first_batch_id              UUID          NOT NULL,
    event_contract              TEXT_BOUNDED  NOT NULL,
    event_effect_hash           HASH32        NOT NULL,
    fact_type                   TEXT_BOUNDED  NOT NULL,
    fact_id                     UUID          NOT NULL,
    first_materialized_at_utc  UTC_TIMESTAMP NOT NULL,
    materializer_profile_id    TEXT_BOUNDED  NOT NULL,
    PRIMARY KEY (realm_id, event_id),
    UNIQUE (realm_id, fact_id),
    FOREIGN KEY (realm_id, installation_id, first_batch_id)
        REFERENCES ingest_batch(realm_id, installation_id, batch_id)
);

CREATE TABLE event_replay_provenance (
    realm_id                    UUID          NOT NULL,
    event_id                    UUID          NOT NULL,
    installation_id             UUID          NOT NULL,
    replay_batch_id             UUID          NOT NULL,
    observed_at_utc             UTC_TIMESTAMP NOT NULL,
    effect_hash                 HASH32        NOT NULL,
    PRIMARY KEY (realm_id, event_id, installation_id, replay_batch_id),
    FOREIGN KEY (realm_id, event_id)
        REFERENCES event_dedupe(realm_id, event_id),
    FOREIGN KEY (realm_id, installation_id, replay_batch_id)
        REFERENCES ingest_batch(realm_id, installation_id, batch_id)
);
```

`event_effect_hash` is derived from the approved minimized event contract, not a raw URL or forbidden source value. A matching replay creates no fact. A mismatching effect hash does not update this row.

### 5.5.9 Common typed-fact envelope

```sql
CREATE TABLE fact_envelope (
    realm_id                    UUID          NOT NULL,
    fact_id                     UUID          NOT NULL,
    event_id                    UUID          NOT NULL,
    installation_id             UUID          NOT NULL,
    batch_id                    UUID          NOT NULL,
    fact_type                   TEXT_BOUNDED  NOT NULL,
    fact_schema_version         TEXT_BOUNDED  NOT NULL,
    event_contract              TEXT_BOUNDED  NOT NULL,
    event_effect_hash           HASH32        NOT NULL,
    source_id                   UUID          NOT NULL,
    source_generation_id        UUID          NOT NULL,
    interpretation_id           HASH32        NOT NULL,
    materializer_profile_id     TEXT_BOUNDED  NOT NULL,
    materialized_at_utc        UTC_TIMESTAMP NOT NULL,
    PRIMARY KEY (realm_id, fact_id),
    UNIQUE (realm_id, event_id),
    FOREIGN KEY (realm_id, event_id)
        REFERENCES event_dedupe(realm_id, event_id),
    FOREIGN KEY (realm_id, installation_id, batch_id)
        REFERENCES ingest_batch(realm_id, installation_id, batch_id)
);
```

### 5.5.10 Illustrative first typed fact

```sql
CREATE TABLE edge_site_activity_fact (
    realm_id                    UUID          NOT NULL,
    fact_id                     UUID          NOT NULL,
    application_id             UUID          NOT NULL,
    site_kind                   TEXT_BOUNDED  NOT NULL,
    site_value                  TEXT_BOUNDED  NOT NULL,
    observed_bucket_start_utc  UTC_TIMESTAMP NOT NULL,
    time_precision             TEXT_BOUNDED  NOT NULL,
    PRIMARY KEY (realm_id, fact_id),
    FOREIGN KEY (realm_id, fact_id)
        REFERENCES fact_envelope(realm_id, fact_id),
    CHECK (site_kind IN ('CANONICAL_HOST','REGISTRABLE_DOMAIN'))
);
```

**HUMAN DECISION.** This table is an implementation example only. Real site mode, application field, time precision, identity level, retention, and access require approved records. A schema migration must remove or never create any unapproved column; “nullable for later” is not field authorization.

### 5.5.11 Projection work, contribution ledger, and aggregate

```sql
CREATE TABLE projection_work (
    realm_id                    UUID          NOT NULL,
    projection_id              TEXT_BOUNDED  NOT NULL,
    projection_version         INT64         NOT NULL,
    fact_id                     UUID          NOT NULL,
    work_id                     UUID          NOT NULL,
    state                       TEXT_BOUNDED  NOT NULL,
    next_attempt_at_utc        UTC_TIMESTAMP NULL,
    attempt_count              INT64         NOT NULL DEFAULT 0,
    lease_owner_id             UUID          NULL,
    lease_token                UUID          NULL,
    lease_version              INT64         NOT NULL DEFAULT 0,
    lease_expires_at_utc       UTC_TIMESTAMP NULL,
    created_at_utc             UTC_TIMESTAMP NOT NULL,
    PRIMARY KEY (realm_id, work_id),
    UNIQUE (realm_id, projection_id, projection_version, fact_id),
    FOREIGN KEY (realm_id, fact_id)
        REFERENCES fact_envelope(realm_id, fact_id)
);

CREATE TABLE projection_contribution (
    realm_id                    UUID          NOT NULL,
    projection_id              TEXT_BOUNDED  NOT NULL,
    projection_version         INT64         NOT NULL,
    fact_id                     UUID          NOT NULL,
    aggregate_key_hash         HASH32        NOT NULL,
    contribution_hash          HASH32        NOT NULL,
    applied_at_utc             UTC_TIMESTAMP NOT NULL,
    PRIMARY KEY (realm_id, projection_id, projection_version, fact_id),
    FOREIGN KEY (realm_id, fact_id)
        REFERENCES fact_envelope(realm_id, fact_id)
);

CREATE TABLE site_usage_aggregate (
    realm_id                    UUID          NOT NULL,
    projection_id              TEXT_BOUNDED  NOT NULL,
    projection_version         INT64         NOT NULL,
    aggregate_key_hash         HASH32        NOT NULL,
    application_id             UUID          NOT NULL,
    site_kind                   TEXT_BOUNDED  NOT NULL,
    site_value                  TEXT_BOUNDED  NOT NULL,
    bucket_start_utc           UTC_TIMESTAMP NOT NULL,
    fact_count                 INT64         NOT NULL,
    last_applied_at_utc        UTC_TIMESTAMP NOT NULL,
    PRIMARY KEY (realm_id, projection_id, projection_version, aggregate_key_hash)
);
```

The projection transaction first inserts `projection_contribution`; a uniqueness conflict with the same hash is a no-op, while a different hash is a projection integrity hold. It then updates/inserts the aggregate and marks `projection_work` complete in the same transaction.

### 5.5.12 Integration outbox

```sql
CREATE TABLE integration_outbox (
    realm_id                    UUID          NOT NULL,
    integration_message_id     UUID          NOT NULL,
    destination_id             TEXT_BOUNDED  NOT NULL,
    integration_contract       TEXT_BOUNDED  NOT NULL,
    integration_version        TEXT_BOUNDED  NOT NULL,
    fact_id                     UUID          NOT NULL,
    exact_payload_bytes        BINARY_LARGE  NOT NULL,
    payload_hash               HASH32        NOT NULL,
    state                       TEXT_BOUNDED  NOT NULL,
    next_attempt_at_utc        UTC_TIMESTAMP NULL,
    attempt_count              INT64         NOT NULL DEFAULT 0,
    lease_owner_id             UUID          NULL,
    lease_token                UUID          NULL,
    lease_version              INT64         NOT NULL DEFAULT 0,
    lease_expires_at_utc       UTC_TIMESTAMP NULL,
    created_at_utc             UTC_TIMESTAMP NOT NULL,
    delivered_at_utc           UTC_TIMESTAMP NULL,
    last_safe_result_code      TEXT_BOUNDED  NULL,
    PRIMARY KEY (realm_id, integration_message_id),
    UNIQUE (realm_id, destination_id, integration_contract, fact_id),
    FOREIGN KEY (realm_id, fact_id)
        REFERENCES fact_envelope(realm_id, fact_id)
);
```

Destinations and payload mappings are release/governance-owned. A tenant cannot provide a URL, topic, SQL statement, serializer type, or transform. External delivery uses the stable `integration_message_id` as its idempotency identity.

### 5.5.13 Reconciliation evidence

```sql
CREATE TABLE reconciliation_run (
    run_id                      UUID          NOT NULL,
    run_type                    TEXT_BOUNDED  NOT NULL,
    scoped_realm_id             UUID          NULL,
    started_at_utc             UTC_TIMESTAMP NOT NULL,
    completed_at_utc           UTC_TIMESTAMP NULL,
    source_snapshot_id         TEXT_BOUNDED  NOT NULL,
    reconciler_build_id        TEXT_BOUNDED  NOT NULL,
    outcome                    TEXT_BOUNDED  NULL,
    finding_count              INT64         NULL,
    PRIMARY KEY (run_id)
);

CREATE TABLE reconciliation_finding (
    run_id                      UUID          NOT NULL,
    finding_id                  UUID          NOT NULL,
    realm_id                    UUID          NULL,
    finding_code               TEXT_BOUNDED  NOT NULL,
    severity                    TEXT_BOUNDED  NOT NULL,
    object_class               TEXT_BOUNDED  NOT NULL,
    object_alias               TEXT_BOUNDED  NOT NULL,
    expected_digest            HASH32        NULL,
    observed_digest            HASH32        NULL,
    created_at_utc             UTC_TIMESTAMP NOT NULL,
    PRIMARY KEY (run_id, finding_id),
    FOREIGN KEY (run_id) REFERENCES reconciliation_run(run_id)
);
```

`object_alias` is a case/run-scoped opaque alias, not a raw site, user, certificate, path, or metric label. The reconciler records findings; repair requires a separately audited command.

## 5.6 Required indexes and physical-design starting point

The initial physical design SHOULD use these indexes, adjusted by engine syntax:

| Table | Index purpose |
|---|---|
| `ingest_batch` | unique PK `(realm_id, installation_id, batch_id)` |
| `ingest_batch` | queue scan `(processing_state, next_attempt_at_utc, received_at_utc, realm_id)` including lease/version/size fields where supported |
| `ingest_batch` | per-realm queue `(realm_id, processing_state, next_attempt_at_utc, received_at_utc)` |
| `ingest_batch` | expired lease `(lease_expires_at_utc)` filtered/partial to `processing_state='LEASED'` |
| `ingest_batch` | terminal age `(processing_state, terminal_at_utc)` for retention/reconciliation |
| `ingest_receipt` | unique `(realm_id, receipt_id)` and PK lookup by batch |
| `ingest_batch_conflict` | `(realm_id, batch_id, observed_at_utc)` |
| `ingest_quarantine_occurrence` | `(realm_id, reason_code, terminal_at_utc)` and `(realm_id, installation_id, batch_id, processing_generation)` unique |
| `event_dedupe` | PK `(realm_id, event_id)`, unique fact, and `(realm_id, first_batch_id)` provenance lookup |
| `fact_envelope` | unique event and `(realm_id, batch_id)` reconciliation lookup; time/query indexes only after approved query corpus |
| `projection_work` | `(state, next_attempt_at_utc, realm_id)` and expired lease |
| `integration_outbox` | `(state, next_attempt_at_utc, destination_id, realm_id)` and expired lease |
| reconciliation | run/time/code indexes for operational investigation |

Large payload bytes stay in `ingest_payload`, not the hot queue row. Partitioning is **UNKNOWN/CLI EXPERIMENT**, not a default. Add it only when measured maintenance, retention, index, or query behavior requires it. Every partition key must preserve realm and uniqueness semantics; no partition may silently allow duplicate event/batch IDs.

## 5.7 PostgreSQL claim and heartbeat profile

Illustrative PostgreSQL claim within a scheduler-selected realm:

```sql
WITH candidate AS (
    SELECT realm_id, installation_id, batch_id
    FROM ingest_batch
    WHERE realm_id = @realm_id
      AND processing_state IN ('RECEIVED','RETRY_WAIT','REPROCESS_PENDING')
      AND COALESCE(next_attempt_at_utc, '-infinity') <= clock_timestamp()
    ORDER BY received_at_utc, batch_id
    FOR UPDATE SKIP LOCKED
    LIMIT @claim_count
)
UPDATE ingest_batch AS b
SET processing_state = 'LEASED',
    lease_owner_id = @worker_id,
    lease_token = @lease_token,
    lease_version = b.lease_version + 1,
    lease_acquired_at_utc = clock_timestamp(),
    lease_heartbeat_at_utc = clock_timestamp(),
    lease_expires_at_utc = clock_timestamp() + @lease_interval,
    row_version = b.row_version + 1
FROM candidate AS c
WHERE b.realm_id = c.realm_id
  AND b.installation_id = c.installation_id
  AND b.batch_id = c.batch_id
RETURNING b.*;
```

Heartbeat:

```sql
UPDATE ingest_batch
SET lease_heartbeat_at_utc = clock_timestamp(),
    lease_expires_at_utc = clock_timestamp() + @lease_interval,
    row_version = row_version + 1
WHERE realm_id = @realm_id
  AND installation_id = @installation_id
  AND batch_id = @batch_id
  AND processing_state = 'LEASED'
  AND lease_owner_id = @worker_id
  AND lease_token = @lease_token
  AND lease_version = @lease_version
  AND lease_expires_at_utc > clock_timestamp();
```

Zero affected rows means lease loss. `SKIP LOCKED` is used only for queue selection, not reconciliation or authoritative business reads.

## 5.8 SQL Server claim and heartbeat profile

Illustrative SQL Server claim within a scheduler-selected realm:

```sql
;WITH candidate AS (
    SELECT TOP (@claim_count) *
    FROM dbo.IngestBatch WITH (UPDLOCK, READPAST, ROWLOCK)
    WHERE RealmId = @realm_id
      AND ProcessingState IN ('RECEIVED','RETRY_WAIT','REPROCESS_PENDING')
      AND (NextAttemptAtUtc IS NULL OR NextAttemptAtUtc <= SYSUTCDATETIME())
    ORDER BY ReceivedAtUtc, BatchId
)
UPDATE candidate
SET ProcessingState = 'LEASED',
    LeaseOwnerId = @worker_id,
    LeaseToken = @lease_token,
    LeaseVersion = LeaseVersion + 1,
    LeaseAcquiredAtUtc = SYSUTCDATETIME(),
    LeaseHeartbeatAtUtc = SYSUTCDATETIME(),
    LeaseExpiresAtUtc = DATEADD(millisecond, @lease_ms, SYSUTCDATETIME()),
    RowVersionNumber = RowVersionNumber + 1
OUTPUT inserted.*;
```

Heartbeat uses the same token/version/expiry predicates. `ROWLOCK` is a hint, not a proof; page locking and escalation must be measured. The SQL Server adapter MUST assert/document the database isolation configuration because `READPAST` behavior interacts with read-committed snapshot settings.

## 5.9 Final lease-fence and materialization pseudocode

```text
BEGIN short transaction;

batch = lock authoritative batch row;
require batch.state == LEASED;
require batch.lease_owner/token/version == expected;
require batch.lease_expires_at_utc > database_now;
require batch.processing_generation == plan.processing_generation;
require stored payload hashes == plan.input hashes;
require processor/schema profile == plan profile;

for event_plan in deterministic order:
    existing = lock/select event_dedupe(realm, event_id)
    if existing absent:
        stage NEW
    else if existing.effect_hash == event_plan.effect_hash:
        stage SAME_REPLAY
    else:
        stage EVENT_IDENTITY_CONFLICT

if any deterministic terminal error/conflict:
    assert no new fact/dedupe rows from this generation;
    insert quarantine occurrence;
    update batch -> QUARANTINED_TERMINAL;
else:
    insert NEW dedupe and fact rows;
    insert SAME_REPLAY provenance rows;
    insert projection_work and governed integration_outbox rows;
    update batch counts -> MATERIALIZED;

clear lease fields;
decrement realm inflight and adjust scheduling state;
insert processing-attempt terminal result;
COMMIT;
```

The materialization plan is not trusted merely because it was computed by the worker. The transaction rechecks identity, profile, counts, bounds, and lease. Fixed parameterized SQL or reviewed stored procedures are used; event fields never become identifiers, SQL fragments, table names, clauses, or serializer types.

## 5.10 Realm-isolation model

Realm isolation is enforced redundantly:

1. **Identity boundary:** immutable `AuthenticatedDeviceContext` supplies realm/install/epoch/status.
2. **Contract:** body/route/query cannot carry authoritative realm/install.
3. **Repository API:** every method requires a typed `RealmScope`; no `GetBatch(batchId)` overload exists.
4. **Keys:** every batch, payload, receipt, event, fact, projection, integration, quarantine, and admin relation begins with `realm_id`; FKs include it.
5. **Credentials:** ingestion, worker, projection, integration, control, reconciliation, and migration roles are separate.
6. **Connection/session context:** if RLS is enabled, the app sets the realm in the transaction and proves reset on pooled-connection reuse.
7. **RLS defense in depth:** PostgreSQL RLS with `FORCE ROW LEVEL SECURITY` where appropriate or SQL Server security policies MAY add containment, but neither substitutes for app/context/key enforcement; privileged owners/admins can alter or bypass policies.
8. **Caches:** all keys begin with realm and installation where applicable; no global batch/event cache by ID alone.
9. **Scheduler/admission:** per-realm budgets prevent noisy-neighbor starvation.
10. **Observability:** realm IDs are not ordinary metric labels or log fields; authorized support queries use scoped aliases.
11. **Negative tests:** same UUID values in multiple realms, wrong-session connection context, pooled-context contamination, worker claim, receipt lookup, reprocess, delete, and integration all fail cross-realm.
12. **Backup/restore:** readiness reconciliation is realm-aware and portal visibility remains disabled until restored isolation/control state is verified.

## 5.11 Accessibility of operator surfaces

The ingestion endpoint itself has no visual interface. Quarantine, reconciliation, and receipt-support surfaces MUST expose the same finite states through text—not color alone—support keyboard-only operation, clear focus order, screen-reader labels, sortable/filterable tables with announced headers, and non-time-critical controls. Destructive/reprocess actions require explicit confirmation that identifies the scoped opaque batch alias, target processor, consequence, and audit record. The exact organizational accessibility standard is a **HUMAN DECISION**; WCAG 2.2 AA is the conservative implementation target where no stronger standard is assigned.


---

# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility rules

## 6.1 Receipt/custody state machine

A receipt row has one state only:

```text
NO_CUSTODY
   |
   | one committed acceptance transaction
   v
DURABLY_RECEIVED
```

There is no `RECEIPT_PENDING`, `VALIDATED`, `MATERIALIZED`, `VISIBLE`, `REJECTED`, or `DELETED` value in the receipt state machine. Request handling before commit is not durable state. Batch processing and payload retention are separate state machines.

```text
new POST
  -> request rejected before commit                  = NO_CUSTODY
  -> acceptance transaction rolls back/unknown      = endpoint treats as ambiguous and replays
  -> transaction commits, response arrives           = DURABLY_RECEIVED
  -> transaction commits, response lost              = DURABLY_RECEIVED; same replay returns receipt
  -> same identity/hashes                             = existing DURABLY_RECEIVED
  -> same identity/different immutable hash           = conflict evidence; original receipt unchanged
```

## 6.2 Batch processing state machine

```text
RECEIVED
  -> LEASED
       -> MATERIALIZED
       -> QUARANTINED_TERMINAL
       -> RETRY_WAIT
       -> SAFETY_HOLD
       -> lease expires -> eligible for LEASED by another worker

RETRY_WAIT
  -> LEASED when next_attempt_at <= database_now

QUARANTINED_TERMINAL
  -> REPROCESS_PENDING only through authorized audited command

REPROCESS_PENDING
  -> LEASED under incremented processing_generation
       -> MATERIALIZED
       -> QUARANTINED_TERMINAL (new immutable occurrence)
       -> RETRY_WAIT / SAFETY_HOLD

MATERIALIZED
  -> terminal for ordinary batch semantics

SAFETY_HOLD
  -> no automatic transition
  -> authorized remediation may return to RETRY_WAIT or REPROCESS_PENDING
```

`COMMITTING` is a transaction-local phase, not a separately committed state. If the materialization transaction fails, the prior durable `LEASED` state remains until retry/expiry. If it commits, the durable state is terminal.

## 6.3 Lease state machine

```text
UNCLAIMED
  -> CLAIMED(owner, token, version, expiry)
       -> HEARTBEAT(same owner/token/version, later expiry)
       -> FINAL_TX_FENCED
            -> TERMINAL_COMMIT + lease cleared
            -> TX_ROLLBACK -> CLAIMED remains
       -> EXPIRED
            -> RECLAIMED(new owner, new token, incremented version)
       -> EXPLICIT_RELEASE_TO_RETRY

Any old owner after RECLAIMED
  -> heartbeat affects zero rows
  -> final fence affects zero rows
  -> worker cancels; no commit authority
```

Properties:

- database UTC time is the lease clock;
- token is unpredictable; version is monotonic fencing evidence;
- lease expiry is not a proof that the old process died, so the final transaction must lock/fence the row;
- a heartbeat does not perform semantic work or change receipt meaning;
- lease duration and heartbeat cadence are measured, not embedded as timeless constants;
- a kill switch stops new claims and asks active workers to cancel; expiry provides bounded recovery from unresponsive workers.

## 6.4 Quarantine lifecycle

```text
DETERMINISTIC_TERMINAL_FINDING
  -> create immutable quarantine occurrence
  -> batch QUARANTINED_TERMINAL
  -> metadata visible to authorized support
  -> optional owner decision:
       - retain under policy/hold
       - deploy compatible processor/reference data
       - issue audited reprocess command
       - purge payload when retention permits

AUDITED_REPROCESS
  -> processing_generation + 1
  -> REPROCESS_PENDING
  -> new attempt under target processor
  -> prior quarantine occurrence remains immutable
```

Quarantine reasons are finite and versioned. Suggested families:

| Family | Example codes | Automatic retry |
|---|---|---|
| contract | `EVENT_SCHEMA_UNSUPPORTED`, `EVENT_STRUCTURE_INVALID`, `ENUM_UNSUPPORTED` | no |
| identity | `EVENT_IDENTITY_CONFLICT`, `BATCH_INTERNAL_ID_MISMATCH` | no; incident/data-quality review |
| reference | `APPLICATION_REFERENCE_UNRESOLVED`, `INTERPRETATION_REFERENCE_UNRESOLVED` | temporary retry may precede terminal outcome under an approved horizon |
| privacy/security | `FORBIDDEN_FIELD_PRESENT`, `REALM_INVARIANT_VIOLATION`, `CANARY_DETECTED` | no; safety hold/incident |
| processor | `PROCESSOR_DETERMINISTIC_REJECTION`, `PROCESSOR_UNCLASSIFIED_FAILURE_LIMIT` | no automatic after bounded classified retries |
| payload custody | `STORED_HASH_MISMATCH`, `DECOMPRESSION_REPLAY_FAILED` | safety hold; corruption incident |

An ordinary transient database timeout, deployment drain, or reference-service outage is not poison and does not create a terminal quarantine immediately.

## 6.5 Fact and event state

For each `(realm_id, event_id)`:

```text
UNSEEN
  -> NEW_EFFECT(effect_hash, fact_id) -> FACT_MATERIALIZED

FACT_MATERIALIZED + same effect_hash
  -> SAME_REPLAY -> existing fact_id, no additional fact

FACT_MATERIALIZED + different effect_hash
  -> EVENT_IDENTITY_CONFLICT -> containing batch quarantined; original fact unchanged
```

There is no ordinary in-place fact rewrite. Corrections, if later approved, require a separately governed supersession/correction model with stable lineage, audit, deletion, and projection behavior. This result does not authorize one.

## 6.6 Projection lifecycle

```text
PROJECTION_WORK_READY
  -> LEASED
       -> contribution absent:
            insert contribution + update aggregate + COMPLETE in one tx
       -> contribution present/same hash:
            mark work COMPLETE, no second aggregate effect
       -> contribution present/different hash:
            PROJECTION_SAFETY_HOLD
       -> transient failure:
            RETRY_WAIT
       -> lease expiry:
            reclaim
```

A projection version is immutable. A changed algorithm creates a new version and rebuilds from facts into separate aggregate rows before visibility cutover. Old and new projections can be compared. Portal readiness is granted only after the selected version is complete/reconciled for the required scope.

## 6.7 Integration outbox lifecycle

```text
READY
  -> LEASED
       -> SEND_ATTEMPT_PREPARED
       -> external result:
            acknowledged equivalent -> DELIVERED
            definite rejection       -> TERMINAL_INTEGRATION_FAILURE or RETRY_WAIT by contract
            ambiguous/lost response  -> retry same integration_message_id and exact payload
       -> lease expiry -> reclaim
```

External consumers must dedupe the stable message ID. UAM cannot make a non-idempotent external side effect exactly once merely by using a local transaction. Destination-specific failure/replay semantics belong to the governed integration contract.

## 6.8 Payload retention lifecycle

```text
PRESENT
  -> HOLD                                  # legal/security/restore/incident
  -> PURGE_ELIGIBLE                        # terminal processing + approved retention predicates
  -> PURGED                                # exact payload bytes cleared, purge evidence retained

HOLD
  -> PRESENT or PURGE_ELIGIBLE only through authorized release of hold
```

Payload purge is independent of receipt existence, fact retention, audit retention, or portal visibility. The first G8 implementation keeps cleanup disabled except for T1 fixture cleanup. Production predicates require human retention/RPO/restore decisions and later deletion gates.

## 6.9 Acceptance transaction boundaries

| Boundary | In transaction | Outside transaction | Invariant |
|---|---|---|---|
| API body read | none | TLS/auth, admission, decompression, strict parse, hashes, bounded memory | no partial custody claim |
| Receipt | batch metadata, exact payload, receipt or conflict evidence | HTTP response | receipt exists iff payload/batch commit exists |
| Claim | realm scheduling state, batch lease token/version/expiry, inflight count | payload read/parse | short lock hold; no processing inside claim |
| Heartbeat | lease timestamps/version check | semantic work | stale owner cannot extend |
| Materialization | lease fence, dedupe, facts, replay provenance, projection work, integration outbox, batch terminal state, attempt outcome, realm inflight | payload parse/plan and external calls | fact cannot exist without terminal materialized batch; quarantine has no partial new facts |
| Projection | contribution, aggregate update, work completion | fact read/plan | one contribution per fact/version |
| Integration state | attempt/lease/result update | external network call | ambiguous send retries same ID |
| Reprocess | command, batch generation/state change, privileged audit outbox | deployment/reference remediation | no unaudited privileged mutation |
| Payload purge | retention/hold recheck, payload clear marker, purge evidence, audit outbox | destructive storage action if a future storage class requires one | no purge under hold or without durable evidence |

## 6.10 Failure and recovery matrix

| Failure point | Durable result | Detection | Required recovery | Forbidden response |
|---|---|---|---|---|
| TLS/auth fails | no custody | auth metric/safe code | credential/network runbook; endpoint retains batch | accept body or infer realm from payload |
| API rejects header/body/limit | no custody | HTTP safe code | producer fix or same exact retry for transient admission | create orphan payload/receipt |
| API dies before receipt transaction | no custody | endpoint timeout; no receipt lookup | replay same sealed batch | mint new batch ID for ambiguity |
| DB dies before acceptance commit | rollback or uncertain to client | DB/client error; receipt lookup | replay same batch; uniqueness resolves | claim custody from attempted insert |
| Acceptance commit succeeds, API dies before response | receipt/payload/batch durable | receipt lookup/replay finds row | return same receipt | create second receipt or body |
| Same batch ID, changed body | original custody unchanged; conflict evidence | digest comparison | endpoint/data-quality incident | overwrite original or accept as replay |
| Worker dies after claim before parse | leased until expiry | heartbeat/lease age | reclaim with new token/version | manual fact insertion |
| Worker dies after parse before final tx | no semantic durable change | attempt/lease expiry | recompute deterministic plan | trust in-memory plan after restart |
| Worker dies during final tx after fact statements | either full rollback or full materialized commit | DB transaction/reconciliation | retry/read terminal state | accept fact without terminal batch |
| Final commit succeeds, worker dies before local acknowledgement | materialized/quarantined terminal state | next worker/dispatcher reads state | no-op terminal handling | re-run as a new event identity |
| Lease expires while old worker runs | new worker may reclaim; old token stale | heartbeat/fence zero rows | old cancels; new recomputes | old commit without fence |
| Reference service unavailable | batch remains/re-enters retry wait | finite transient code | bounded backoff; preserve custody | quarantine immediately or guess reference |
| Unsupported inner schema | explicit terminal quarantine | worker reason code | deploy compatible consumer + audited reprocess or retain | HTTP receipt rollback after custody |
| Poison event in whole batch | batch terminal quarantine; no new facts | deterministic validator | governed reprocess/new producer release | materialize valid siblings silently |
| Same event ID/same hash | existing fact, replay provenance | unique/read comparison | no-op | second fact |
| Same event ID/different hash | original fact unchanged; new batch quarantine | hash mismatch | incident/producer correction | overwrite or choose latest |
| Projection worker dies after aggregate statement | tx rollback or full contribution+aggregate commit | contribution reconciliation | retry same work | update aggregate without contribution ledger |
| Integration response lost after external effect | local outcome ambiguous | attempt log/timeouts | retry same stable message ID; destination dedupe | mint new message ID |
| Database failover during claim | no claim or committed lease | reconnect/read row | resume/reclaim based on DB state | assume worker ownership from process memory |
| Database failover during materialization | rollback or commit | reconnect/terminal read/reconcile | retry under current lease/new claim | partial manual repair |
| Restore before some issued receipts | acknowledged custody may be missing | receipt/inbox reconciliation and endpoint replay | stay in restore hold; replay if endpoint retained; declare incident/loss under authority | mark ready or invent receipt/payload |
| Restore loses only projections/outbox | facts remain authoritative | reconciliation | rebuild projection/integration rows idempotently | edit facts to match aggregate |
| Disk/log pressure | acceptance may be rejected; processing paused | DB/storage/admission metrics | free governed capacity, scale, retain custody | drop oldest/unmaterialized payload |
| One realm floods | its admission/inflight limited | per-realm queue age/admission | throttle/drain realm; protect global reserve | starve all realms or expose realm ID metric labels |
| Corrupt stored payload/hash | safety hold | worker/reconciler rehash | preserve evidence, restore/replay under incident plan | parse anyway or delete/recreate |
| Migration incompatibility | startup/migration hold | schema digest/version check | rollback compatible release or enterprise migration | application-startup destructive repair |

## 6.11 Database failover and durability classes

A receipt `failureDomainClass` is a versioned operations contract, not a marketing label. Candidate classes include:

| Candidate class | Meaning | Consequence |
|---|---|---|
| `PRIMARY_RELATIONAL_COMMIT_V1` | transaction log/data is committed according to the primary database durability setting only | simplest; primary storage/site loss after endpoint cleanup can lose acknowledged data unless backup/replay covers it |
| `SYNCHRONOUS_REPLICA_HARDENED_V1` | acceptance commit waits for a named synchronous replica/log hardening condition | lower acknowledged-loss exposure; higher latency and availability coupling; failover correctness must be proved |
| `SYNCHRONOUS_REMOTE_APPLIED_V1` | commit waits for a documented remote apply/readiness condition | strongest of these candidates but highest coupling/latency; still not proof against correlated/admin failure |

Exact PostgreSQL `synchronous_commit`/synchronous-standby or SQL Server synchronous-commit Always On settings are implementation profiles behind the class. Asynchronous replicas cannot be represented as synchronous custody. Backup/PITR evidence is separate. **HUMAN DECISION:** choose the production class/RPO/RTO. **Conservative temporary default:** G8 uses local primary commit and keeps endpoint production cleanup disabled.

## 6.12 Restore lifecycle

```text
NORMAL
  -> RESTORE_REQUESTED
  -> INGESTION_DRAINED_OR_FENCED
  -> DATABASE_RESTORED
  -> SCHEMA/IDENTITY/CONTROL VERIFIED
  -> RESTORE_RECONCILIATION_HOLD
       -> receipts/payloads/terminal outcomes/facts/projections/outboxes reconciled
       -> missing acknowledged custody = INCIDENT / NOT READY
       -> clean result = READINESS_CANDIDATE
  -> authorized READY
```

The public load balancer may return `503` before the body during restore hold. Workers and portal visibility remain off until their respective checks pass. A restore is not complete because the database opens or health query succeeds.

## 6.13 Contract and schema rollout rules

1. Consumers deploy before producers.
2. The API must understand the new outer envelope before any endpoint can send it.
3. A worker may durably quarantine an unknown inner schema, but a production rollout should deploy a compatible materializer before enabling that producer.
4. Supported envelope/event versions are an explicit finite catalogue, never “anything newer.”
5. Unknown fields are rejected unless a named bounded non-authority extension point exists; this batch defines none for receipt, inbox, event identity, facts, quarantine, or admin commands.
6. Existing receipts/payloads remain readable through the support/retention horizon.
7. Schema migration is expand/backfill/verify/contract. Destructive contract steps wait until rollback and schema-support horizons expire and restore evidence exists.
8. A materializer profile binds source/event schema, validation rules, reference snapshot requirements, fact schema, projection/integration mappings, and dependency versions.
9. Reprocessing uses an explicit target materializer profile and new processing generation; it does not silently use “current code.”
10. Database-specific DDL can differ, but both adapters pass identical valid/invalid contracts, state histories, fault points, and reconciliation assertions.

## 6.14 Compatibility matrix

At minimum, the executable matrix covers:

```text
API N accepts endpoint batch N and approved older batches
API N+1 accepts endpoint batch N and N+1 during rollout
Worker N materializes its declared inner schemas only
Worker N+1 can read every retained accepted outer envelope it promises
DB schema N is readable/writable by running release and rollback release
Reconciler N+1 can verify retained N receipts/facts/quarantines
Control/BFF N cannot issue a reprocess command unsupported by workers
```

Exact “current plus previous” or longer support is a **HUMAN DECISION**. Until decided, the conservative technical behavior is: accept only explicitly catalogued outer versions, retain unsupported inner payloads in terminal quarantine, and do not purge them based solely on consumer age.

## 6.15 Rollout rings and kill behavior

The first G8 rollout is T1-only:

1. pure model/DDL/contract tests;
2. single-process API + database, worker disabled;
3. worker materialization with fictional valid/poison batches;
4. process-kill and response-loss campaign;
5. database restart/failover/restore campaign;
6. PostgreSQL/SQL Server identical benchmark;
7. controlled multi-realm fairness/backpressure soak;
8. architecture review of evidence.

Kill switches are monotonic narrowing. Stopping acceptance returns no receipt. Stopping materializers retains accepted batches. Stopping a schema routes no new claims for that schema and may quarantine only under an approved rule; it does not rewrite prior terminal states. Re-enablement requires a higher-version configuration and any incident-specific self-test/reconciliation.

---

# 7. Security/privacy threat and failure register

Owner names below are accountable functions, not assigned people. Residual risk remains even after the proposed test passes.

| ID | Trigger/threat | Detection | Containment | Recovery | Cleanup/evidence | Owner function | Test | Residual risk |
|---|---|---|---|---|---|---|---|---|
| T15-01 | Forged client certificate or inactive credential | TLS/chain/profile/status failure; generic auth code | reject before body; no receipt | renew/re-enroll/revoke runbook | retain finite auth result and status version; no cert dump | Identity/IAM + PKI | invalid chain, expired, revoked, old epoch, wrong issuer | CA/status service compromise or stale enterprise controls remain high consequence |
| T15-02 | Payload/header/route claims another realm/install | strict schema/header deny; context mismatch | ignore/reject claims; authenticated context only | producer fix; security review | no claim values in logs; negative-test evidence | Ingestion Security | hostile realm/device fields and duplicate headers | privileged server code could still misuse context |
| T15-03 | L7 gateway accepts spoofed XFCC/forwarded header | backend assertion/header mutation tests | strip all inbound variants; backend mTLS; signed request-bound assertion | disable L7, use direct/L4; rotate gateway keys | gateway/backend config hashes and safe audit | Gateway Security | case/underscore/duplicate/smuggling/assertion replay corpus | proxy/parser differential and gateway compromise |
| T15-04 | Direct public route bypasses gateway | network policy and backend client identity mismatch | deny direct path | repair routing/firewall; rotate credentials if exposed | access-path evidence without addresses | Network/Gateway | direct-backend negative test | network misconfiguration after qualification |
| T15-05 | Slowloris/header exhaustion | Kestrel/header timeout/connection and admission metrics | bounded headers, data rate/time, connections | shed load, isolate source class | value-free request outcome counts | Ingestion/SRE | slow headers/body, idle streams | distributed low-rate attacks can still consume capacity |
| T15-06 | Compressed bomb or pathological stream | compressed/decompressed/ratio/time/allocation counters | abort stream, close request, no receipt, rate limit | same identity may retry only with compliant body/new batch if rebuilt | canary and resource trace | Ingestion Security | nested gzip, high ratio, CPU-heavy, truncation corpus | decompressor/runtime vulnerability |
| T15-07 | Multiple/unknown content encodings pass through middleware | strict route reader detects exact singleton | reject `415`; no permissive fallback | deploy corrected client/server profile | contract vector evidence | Contract Authority | multiple header values, casing, commas, unsupported coding | framework update can change middleware behavior |
| T15-08 | Request smuggling/CL-TE ambiguity | front/backend differential tests, strict proxy config | one trusted parser path; reject ambiguous framing | disable affected gateway/profile; patch | sanitized packet/trace summary in lab | Gateway/Ingestion Security | CL/TE, duplicate length, HTTP/1.1 and HTTP/2 downgrade corpus | intermediaries outside controlled path |
| T15-09 | Wire/content digest mismatch or implementation drift | streaming recomputation and canonical vectors | reject before custody | fix producer/encoder; do not reuse ID with changed bytes | expected/observed digest evidence in privileged table | Contract/Data Correctness | mutation of one byte, recompression, Unicode/order/number vectors | cryptographic implementation defect; SHA-256 collision is negligible but nonzero in principle |
| T15-10 | Same batch ID with changed body | unique key + locked digest comparison | preserve original; conflict evidence; `409`; possible realm/schema kill | endpoint release rollback/incident | conflict row, audit, no attacker body retention | Endpoint/Ingestion Data Quality | parallel same/different hash submissions | compromised endpoint can create sustained conflicts/backlog |
| T15-11 | API returns receipt before durable commit | receipt-fault hook, DB snapshot, endpoint replay | response construction after commit only | stop release; reconcile every issued receipt | first-failure capsule, receipt/payload ledger | Ingestion Reliability | kill after each insert/commit/response boundary | DB/storage can lie about durability |
| T15-12 | Batch/payload/receipt partial transaction | FK/transaction/reconciler | one transaction; startup hold on impossible state | restore/replay; no manual invention | DB snapshots and reconciliation findings | Ingestion Reliability | kill/fail DB after each statement | engine/provider bug or operator bypass |
| T15-13 | Database commit uncertain during failover | client error + receipt lookup/replay | stable key/hash makes retry safe | reconnect; replay same batch; read original receipt | failover timeline, DB logs sanitized | DB/SRE | process/primary kill at commit phases | correlated storage loss beyond failure domain |
| T15-14 | SQL injection/dynamic identifier from event | architecture analyzer; parameterized command review | fixed SQL/stored procedures; no payload SQL/table/serializer names | patch and rotate affected DB credential | source/command inventory, no payload capture | Application Security | malicious strings/JSON; mutation introducing interpolation | database or driver vulnerability |
| T15-15 | Oversized batch transaction saturates memory/log | admission and DB log/latency metrics | hard limits, bounded concurrency, separate payload table | lower limits or adjust batch contract via consumer-first rollout | benchmark and rejection evidence | Ingestion/SRE | boundary-size concurrent uploads | unknown real burst distribution |
| T15-16 | One realm exhausts connections/workers | per-realm admission/inflight/backlog age | realm throttle/kill; global reserve; fair scheduler | drain/remediate realm; controlled re-enable | per-realm authorized report, no global realm labels | Ingestion/SRE | hostile multi-realm load with one flooder | many colluding realms or global burst |
| T15-17 | Cross-realm batch lookup/claim/materialization | composite keys, typed repositories, RLS negatives, canaries | fail closed, security hold, stop affected release | patch, reconcile affected realms, incident response | scoped integrity report and audit | Security/Data Platform | same UUIDs across realms, pooled context contamination | privileged DB/admin compromise |
| T15-18 | RLS assumed sufficient while owner/superuser bypasses | role/config review and bypass tests | app/context/composite keys remain primary; least privilege | remove excessive role, rotate credential | role grants/config digest | DB Security | table owner/BYPASSRLS/admin negative tests | DB administrators remain powerful insiders |
| T15-19 | Worker holds DB transaction while parsing | transaction duration/lock telemetry, code architecture test | claim/parse/final-tx separation | abort worker; patch | transaction trace and lock report | Materialization/DB | slow parser and blocked DB campaign | future code regression |
| T15-20 | Lease stolen/reclaimed while old worker commits | token/version/expiry fence affects zero rows | old worker cancels; unique constraints second layer | reclaim/recompute | lease history and fault capsule | Materialization Reliability | pause beyond expiry, clock, duplicate workers | long final tx near expiry may reduce throughput |
| T15-21 | Heartbeat storm or hot lease rows overload DB | heartbeat QPS/lock/log metrics | measured cadence, bounded claims, no per-event heartbeat | tune profile via ADR; shed workers | benchmark evidence | Materialization/SRE | many workers/short leases | workload variance and clock stalls |
| T15-22 | Poison batch retries forever | retry counter/classification/oldest age | deterministic reasons terminal; bounded unknown retries then hold | deploy fix, audited reprocess | attempt/quarantine history | Materialization Support | poison corpus and processor bug injection | misclassification may quarantine recoverable data or retry permanent defects |
| T15-23 | Unsupported schema silently dropped | terminal-state reconciler | `UNSUPPORTED_EVENT_SCHEMA` quarantine with payload retained | deploy consumer + audited replay | quarantine evidence | Contract Authority | future/old schema corpus | long support horizon creates storage/operations cost |
| T15-24 | Same event ID reused with changed effect | event unique key + hash comparison | entire batch quarantine; original fact immutable | endpoint bug/compromise investigation; explicit correction design if approved | conflict/quarantine and provenance | Endpoint/Data Correctness | cross-batch parallel same/diff event IDs | one bad event can quarantine siblings under whole-batch rule |
| T15-25 | Worker dies after fact insertion | transaction/terminal-state reconciliation | fact/dedupe/work/outbox/state in one tx | retry/read committed terminal outcome | failpoint DB snapshots | Materialization Reliability | kill after every statement and commit response | storage-level partial durability outside engine guarantee |
| T15-26 | Reference data temporarily unavailable | finite transient result and dependency health | retry wait; no guessing/default | restore dependency; bounded re-evaluation | safe reason/time counts | Registry/Materialization | outage, stale cache, delayed rollout | eventual permanent unresolved case needs human horizon |
| T15-27 | Reference changes make old payload produce different fact | materializer profile/reference digest binding | one explicit profile per processing generation | audited replay only; preserve prior facts/occurrence | profile/digest evidence | Data Governance | change registry/policy between parse and commit | business correction requirements remain unknown |
| T15-28 | Quarantine UI/log leaks payload/site/user data | closed DTOs, canaries, analyzer, access tests | metadata-first UI; no raw export; finite codes | stop support surface; incident/deletion runbook | all-sink scan and access audit | Support/Privacy | malicious payload and canary corpus | authorized DB administrators can access custody bytes |
| T15-29 | Unauthorized reprocess or purge | IAM, command signature/claim, stored operation, durable audit outbox | least privilege, two-step confirmation where approved, no direct DML | revoke access, restore/hold, reconcile | immutable command/audit evidence | Control/IAM/Audit | wrong realm/role/expired approval/replay command | compromised authorized operator/authority |
| T15-30 | Reprocess erases prior quarantine history | schema uniqueness/history checks | new processing generation and immutable occurrence | restore/repair through governed migration | lineage reconciliation | Data Governance | repeat replay generations and migration tests | indefinite replay history cost |
| T15-31 | Aggregate double counts after retry | unique contribution + aggregate in one tx | no second contribution; hold on changed hash | rebuild projection from facts | contribution/fact reconciliation | Projection/Data Quality | kill between insert/update/complete | aggregate hot-key contention |
| T15-32 | Projection bug makes portal wrong while facts correct | dual-version comparison/reconciliation | keep facts authoritative; visibility gate; disable projection | deploy new version/rebuild/cut over | projection run evidence | Analytics/Data Quality | seeded wrong algorithm/mutation | users may see stale data before detection if SLO/alerts weak |
| T15-33 | Integration sends duplicate or wrong realm | stable message ID, realm-scoped outbox, destination contract | consumer idempotency; no dynamic destination; kill affected integration | replay same ID or compensate under integration contract | attempt/outbox/destination receipt evidence | Integration Owner | response loss, wrong realm, destination outage | external system may be non-idempotent or unavailable |
| T15-34 | Integration failure blocks facts/receipt | architecture and transaction tests | network outside fact tx; independent outbox | retry/terminal integration handling | state/reconciliation | Integration/Materialization | long outage/poison destination | integration backlog/cost and downstream inconsistency |
| T15-35 | Database restore loses issued receipts | receipt-to-backup/failover reconciliation | restore hold; production cleanup disabled until approved | endpoint replay if retained; incident/loss decision | restore point, reconciliation, missing set | Data Reliability/SRE | restore to many points, primary/replica loss | if endpoint cleaned and failure domain failed, data may be irrecoverable |
| T15-36 | Restore resurrects purged/held/deleted visibility | deletion/hold state not yet fully designed | portal/worker off until later deletion readiness checks | reapply authoritative deletion/hold state before visibility | restore/deletion reconciliation | Records/Data Reliability | later deletion/restore suite | dependent on future deletion design and backups |
| T15-37 | Database schema drift/manual DDL | schema hash/domain verifier/startup check | safety hold; migrator-only DDL | restore/reapply approved migration | schema diff and audit | Database Engineering | unknown index/trigger/column, wrong constraint | privileged DBA can bypass deployment process |
| T15-38 | Lock escalation/starvation causes unfairness | queue age, lock waits, per-realm service distribution | short tx, indexes, bounded claim, adapter tuning | adjust dialect/index/worker plan by benchmark | lock/plan/evidence | DB/SRE | hot queue and adversarial realm ordering | engine/version/workload behavior changes |
| T15-39 | Metrics/logs create cardinality or identity leak | catalogue/lint/theoretical and runtime series bound | finite labels; no realm/batch/event/site IDs | disable signal, purge under policy, patch | all-sink/cardinality evidence | Observability/Privacy | adversarial distinct IDs/codes | backend/vendor enrichment outside UAM control |
| T15-40 | Generic HTTP tracing logs body/headers/certificate | dependency/config analyzer and canaries | disable broad auto-instrumentation; UAM wrappers only | stop exporter, incident/deletion | config digest/canary report | Observability Security | framework/runtime update | external load balancer/security logs may retain more than UAM |
| T15-41 | Worker/parser vulnerability exploited by stored poison | process/container/service isolation, bounds, dependency scanning | least-privilege worker, no network unless approved, kill schema/release | patch/redeploy; retain payload; reprocess only after fix | crash/canary/SBOM evidence | Application Security | fuzz/malformed corpus and dependency advisories | memory-safe .NET still has logic/DoS/native decompressor risks |
| T15-42 | Payload retention/purge policy wrong | retention/hold query and audit | cleanup disabled by default; explicit predicates | restore where allowed; incident | purge evidence and before/after hash inventory | Records/Privacy | hold/race/clock/restore tests | policy/legal interpretation cannot be proved technically |
| T15-43 | Broker introduced informally and changes custody | architecture/dependency/infra inventory | no broker package/service/credential by default | remove; open break-even ADR | SBOM/config/topology evidence | Architecture | mutation adding broker path | operational pressure may encourage shadow architecture |
| T15-44 | Open-source framework adds dynamic topics/plugins/admin UI | dependency review and architecture tests | reference-only; no dependency until admission | remove/replace via owned contracts | SBOM/source/license/removal plan | Dependency Security | candidate spike with hostile config | future maintenance/licensing changes |
| T15-45 | Support cannot diagnose without raw payload | blind T1 support exercise | add only finite safe signals or narrow support promise | synthetic reproduction; engineering escalation | scorecard/runbook | Support Owner | predefined receipt/lease/quarantine/restore cases | some production-only failures remain hard to reproduce |
| T15-46 | Error response reveals realm/installation existence | cross-realm response differential | generic auth/not-found/conflict messages | patch and incident review | response corpus | API Security | enumeration/timing tests | timing/traffic side channels remain |
| T15-47 | Clock step affects lease/retry/receipt time | DB-time use and clock-health monitoring | single DB time authority per transaction; no endpoint time authority | pause claims if DB clock unsafe; operations repair | clock transition evidence | DB/SRE | forward/backward step, failover clock skew | distributed replica clock differences can affect observability/expiry |
| T15-48 | Reconciler or repair tool becomes destructive general admin channel | read-only default, closed commands, separate role | findings only; repair through audited finite operations | revoke tool/credential; restore | command manifest and audit | Data Reliability/Security | SQL/script injection and permission tests | privileged maintenance remains high risk |

## 7.1 Secure coding and review requirements

The following are release gates, not optional style advice:

- strict source-generated or equivalently reviewed DTOs with unknown-member rejection;
- no generic deserialization type names, reflection-discovered handlers, dynamic assemblies, scripts, SQL, or tenant-provided expressions;
- fixed parameterized SQL and explicit transaction APIs; no ORM-generated queue claim accepted without captured SQL/plan/lock evidence;
- decompressor/parser fuzz and allocation/time tests with exact dependency/runtime versions;
- immutable byte/hash types and purpose-specific UUID/hash wrappers to prevent key/digest swaps;
- typed `RealmScope`, `InstallationScope`, `BatchId`, `EventId`, `LeaseToken`, and `ReceiptId`; no interchangeable raw strings;
- cancellation and deadline propagation without converting cancellation into a terminal poison result;
- code-owner/security review for identity boundary, receipt transaction, lease/fence, dedupe, quarantine/reprocess, RLS/session context, and migrations;
- architecture tests that ban endpoints from SQL packages and ban API/worker projects from arbitrary logging/HTTP clients where not required;
- locked dependencies, SBOM/provenance, exact database driver/server versions, and advisory response;
- first-failure retention and no “retry until green” evidence replacement;
- threat-model review whenever a new schema, encoding, gateway, storage class, integration, repair command, or broker is proposed.

## 7.2 Incident response sequence

A safety incident uses the narrowest kill switch that contains risk:

1. stop affected realm/schema/release acceptance when new custody is unsafe;
2. stop relevant worker/projection/integration/reprocess/cleanup paths independently;
3. preserve received payloads, receipts, facts, quarantine, audit, and first-failure evidence;
4. prevent portal/integration visibility where correctness or privacy is uncertain;
5. run receipt/fact/quarantine/realm reconciliation;
6. classify whether replay is safe under the same identities;
7. deploy a higher-version fixed artifact/configuration;
8. use audited reprocess/rebuild rather than direct table edits;
9. prove cleanup and re-run neighboring invariants before re-enablement;
10. record residual loss/unknowns and human risk decision.

No incident runbook may weaken TLS, realm, hash, lease fence, receipt, or audit checks; delete the database; or expose raw payload through a general support channel.


---

# 8. Detailed test matrix and smallest falsifying prototypes

## 8.1 G8 prototype boundary

**RECOMMENDATION.** Build one deliberately small G8 vertical slice before any capacity claim. It uses only T1 fictional identities, site values, applications, realms, certificates, and payloads.

```text
Uam.G8.ContractEmulator
  -> emits exact valid, boundary, duplicate, conflict, truncated, compressed-bomb,
     unsupported-schema, and poison batches

Uam.Server.Ingestion.Api
  -> strict direct-mTLS test path and authenticated-context stub
  -> streaming byte/hash/contract limits
  -> receipt transaction

Uam.Server.Ingestion.Store.PostgreSql
Uam.Server.Ingestion.Store.SqlServer
  -> identical logical repository interface
  -> explicit captured SQL, plans, locks, and transactions

Uam.Server.Materialization.Worker
  -> claim/heartbeat/fence
  -> parse/plan outside transaction
  -> whole-batch atomic materialization or terminal quarantine

Uam.Server.Projection.Worker
Uam.Server.IntegrationOutbox.Worker
  -> idempotent derived work only

Uam.G8.FaultController                 # test build only
Uam.G8.PoisonCorpus
Uam.G8.Reconciler.Cli
Uam.G8.Evidence
  -> deterministic hooks, process/DB/network faults, invariant queries,
     first-failure capsules, and cleanup receipts
```

The G8 production-shaped build MUST structurally exclude the fault controller, test certificate authority, destructive database commands, arbitrary SQL runner, raw-payload exporter, and synthetic identity bypass. The evidence build and normal build are separate artifacts with file-manifest and dependency checks.

## 8.2 Common experiment setup

Every experiment records:

- source-tree and clean-worktree digest;
- exact .NET SDK/runtime, database engine/build/edition, driver/package, OS/container/VM image, schema, migration, and configuration digests;
- database durability, replication, backup, isolation, RLS/security-policy, connection-pool, and autocommit settings;
- exact API/worker artifact file manifests and signatures where applicable;
- T1 package, poison corpus, canary registry, oracle, seed, and fault-schedule digests;
- sanitized database role/grant and network-topology classes;
- start/end UTC from the orchestrator and database-time samples;
- all commands by stable command ID, with credentials and addresses omitted;
- first failure, every rerun, and classification of harness failures;
- invariant-query results before, during, after restart, and after cleanup;
- database/host/process resource measurements and query/lock plans;
- residue comparison and cleanup/revert receipt.

A failed first run remains part of the evidence. A later pass does not erase it. An unavailable fault mechanism is `BLOCKED`, not `PASS`.

## 8.3 Detailed G8 test matrix

Durations are **ESTIMATE** values for lab planning, not SLOs or promises. The same functional and fault cases run against PostgreSQL and SQL Server; engine-specific diagnostics are additional evidence, not different acceptance semantics.

| ID | Claim | Setup and instrumentation | Steps | Pass/fail | Required evidence | Duration and cleanup |
|---|---|---|---|---|---|---|
| G8-T01 | Strict HTTP route and header profile rejects ambiguity before custody | Direct test mTLS identity stub; raw HTTP/1.1 and HTTP/2 clients; reverse-proxy parser differential lane; access-log canaries | Send wrong methods, query strings, duplicate/comma-joined singleton headers, conflicting content lengths, unexpected identity/forwarding headers, wrong media types and encodings | **PASS:** every invalid case has no batch/payload/receipt row and a stable safe problem code. **FAIL:** one ambiguous request reaches receipt transaction or leaks a value | request-vector ledger, response corpus, zero-row invariant results, sanitized parser traces | **ESTIMATE:** 30–60 min/engine-independent run. Remove test certs/trust, logs, and captures; prove no marker remains |
| G8-T02 | Compressed/decompressed limits and hashes are enforced while streaming | T1 gzip corpus with exact compressed/decompressed sizes, truncations, concatenated members, high ratios, CPU-heavy streams; allocation/CPU/deadline counters | Exercise every byte boundary, ratio boundary, timeout/cancel, malformed/truncated stream and hash mutation | **PASS:** no receipt outside both limits and exact hashes; bounded memory/time; no partial payload. **FAIL:** bomb/resource escape, digest mismatch accepted, or generic exception/body log | corpus manifest, resource curves, computed digests, error taxonomy, DB zero-row evidence | **ESTIMATE:** 1–2 h. Delete corpus expansions and captures; retain canonical tiny fixtures only |
| G8-T03 | A committed receipt always has immutable batch and exact wire payload | Single API instance, fresh DB, receipt hooks after each statement/before and after commit; database snapshots | Kill/throw at batch insert, payload insert, receipt insert, commit request, commit return, response serialization and socket write | **PASS:** pre-commit leaves none; post-commit leaves all three and replay returns original receipt. **FAIL:** orphan receipt/batch/payload or response before durable commit | hook history, transaction log/DB snapshots, receipt replay result, invariant query outputs | **ESTIMATE:** 2–4 h/engine. Drop isolated DB/schema and prove no process/volume residue |
| G8-T04 | Lost response after commit is harmless | Hostile HTTP server/proxy that drops response after DB commit; endpoint emulator persists one batch and replays exact bytes | Submit; force response loss; query receipt; replay exact request many times and concurrently | **PASS:** one receipt ID, one batch, one payload, one terminal processing lineage. **FAIL:** new receipt/batch, duplicate payload custody, or uncertain client causes changed identity | endpoint attempt ledger, API/DB commit timeline, replay responses, row counts | **ESTIMATE:** 30–90 min. Remove proxy rules/certs; reset DB |
| G8-T05 | Same batch ID and identical bytes is idempotent under concurrency | Two or more API hosts, many clients, barrier start; unique-index and lock monitoring | Submit the same exact batch concurrently before/after first commit | **PASS:** all successful callers receive equivalent original receipt; one batch/payload/receipt. **FAIL:** duplicate row, deadlock/livelock without bounded recovery, or conflicting receipt | client results, unique-conflict/lock traces, row/cardinality proof | **ESTIMATE:** 1–2 h. Stop clients and drop data |
| G8-T06 | Same batch ID with changed wire or content hash never mutates original custody | Corpus recompresses same JSON and changes one canonical byte/event while reusing ID; parallel clients | Submit original then each same/different hash variant, including races before original commit | **PASS:** same pair returns original; any hash difference is `BATCH_IDENTITY_CONFLICT`, original bytes/digests unchanged. **FAIL:** overwrite, second custody record, or “last write wins” | conflict occurrence history, before/after payload hashes, safe response corpus | **ESTIMATE:** 1 h. Purge test DB through fixture cleanup and verify conflict evidence lifecycle |
| G8-T07 | Receipt lookup cannot enumerate another realm or reveal existence | Two fictional realms use the same receipt/batch UUIDs; authenticated context variants; timing sampler | Lookup own receipt, other realm's receipt, random receipt, wrong installation, stale epoch | **PASS:** only exact authenticated scope succeeds; denied/not-found responses are intentionally indistinguishable within approved timing class. **FAIL:** cross-realm result or existence oracle | response/timing distributions, access audit, realm-negative DB traces | **ESTIMATE:** 1–2 h. Remove realm fixtures and test credentials |
| G8-T08 | Claiming is short, mutually exclusive, and fair enough to test | Backlog across many fictional realms with one flooder; multiple workers; DB lock/plan/log/CPU instrumentation | Run claim loop at increasing workers/backlogs; pause claimed workers; add high-priority recovery work | **PASS:** no two active tokens for one batch; short claim transaction; nonflooded realms make progress; reserve classes remain serviceable. **FAIL:** duplicate claim, starvation under defined T1 model, table/page lock collapse, or transaction held during parse | claim histories, realm service distribution, lock waits, query plans, transaction-duration histogram | **ESTIMATE:** 2–6 h/engine plus soak. Drop queue fixtures and verify leases cleared |
| G8-T09 | Database-time lease and fencing reject a stale worker | One batch, worker A claim, controlled pause beyond expiry, worker B reclaim; hooks before final fence/update | A claims and pauses; B reclaims/materializes; A resumes and tries heartbeat/final commit | **PASS:** A affects zero fenced rows and exits; one terminal outcome/fact set. **FAIL:** stale heartbeat extends lease or stale worker commits | lease-version/token history, affected-row counts, fact/terminal ledger | **ESTIMATE:** 30–60 min. Stop workers and clear fixture |
| G8-T10 | Worker death during parse causes retry without DB lock or partial fact | Large bounded T1 batch and slow parser hook; process/lock monitoring | Claim, parse outside transaction, kill repeatedly at parse positions, restart | **PASS:** claim expires/retries; no facts/terminal state before final transaction; no long DB transaction. **FAIL:** parse holds row/transaction lock or creates partial durable state | DB session/transaction trace, lease timeline, row snapshots | **ESTIMATE:** 1–2 h. Remove crash dumps and fixture; prove canaries absent |
| G8-T11 | Whole-batch materialization is atomic at every statement/failure boundary | Valid batch containing new and duplicate events; hooks before/after dedupe, each fact, projection work, integration outbox, terminal update, commit | Fail/kill at every hook; restart and replay same processing generation | **PASS:** prior state or complete terminal state only; one fact per new event; no orphan work/outbox. **FAIL:** partial sibling facts, terminal state without complete effects, or changed retry identity | per-hook failure capsules, DB snapshots, oracle diff, transaction-log evidence | **ESTIMATE:** 4–8 h/engine. Drop isolated DB after evidence export |
| G8-T12 | Event replay same ID/same hash adds no fact; different hash quarantines whole batch | Existing fact/dedupe row, then batches with same and changed event effect; parallel workers | Process exact replay, replay mixed with new siblings, then conflicting version | **PASS:** same-hash is no-op for fact; changed hash yields terminal quarantine and no new siblings from that batch. **FAIL:** duplicate fact, overwrite, or partial siblings | dedupe/fact/quarantine ledger and payload/fact hashes | **ESTIMATE:** 1–2 h. Remove fixtures |
| G8-T13 | Unsupported event schema becomes explicit terminal quarantine | Poison corpus with future, retired, malformed, unknown-field and structurally valid but semantically unsupported contracts | Receive each, process, restart, re-run scheduler | **PASS:** one immutable quarantine occurrence and terminal batch; no repeated automatic retry; receipt remains retrievable. **FAIL:** silent drop, coercion, unbounded retries, or fact | reason taxonomy results, attempt count, quarantine provenance, receipt lookup | **ESTIMATE:** 1–2 h. Retain tiny fictional poison vectors only |
| G8-T14 | Transient dependency failure retries without changing outcome identity | Deterministic reference-data stub with fail/recover schedule; worker attempt instrumentation | Fail application/registry lookup, DB connection, and temporary resource; recover and retry | **PASS:** `RETRY_WAIT` with bounded attempt history, same batch/processing generation, eventual exact materialization. **FAIL:** terminal poison misclassification, guessed default, new identity, or hot loop | retry schedule, safe reason codes, final oracle comparison | **ESTIMATE:** 1–2 h. Stop stub and clear data |
| G8-T15 | Deterministic poison does not consume infinite resources | Corpus of parser depth, numeric, string, duplicate, invalid UTF-8, schema, decompression, and semantic conflicts; CPU/memory counters | Submit/process corpus repeatedly and concurrently | **PASS:** finite stable reason, bounded resource, terminal state or pre-receipt rejection as specified. **FAIL:** crash loop, resource growth, reason drift without version change, or repeated terminal processing | per-vector result/resource ledger, crash and canary scan | **ESTIMATE:** 2–4 h. Delete expanded/fuzz artifacts after minimized corpus is retained |
| G8-T16 | Reprocessing is explicit, immutable, realm-bound, and audited | One terminal quarantine; test roles/approvals; reprocess command contract; fixed new processor profile | Attempt wrong realm/role, expired/replayed command, then authorized replay; repeat generations | **PASS:** denied attempts make no state change; approved replay creates new processing generation/occurrence and preserves old history; durable audit outbox is atomic. **FAIL:** in-place erase, arbitrary code/SQL, cross-realm replay, or missing audit | command/audit/occurrence history, authorization matrix, fact result | **ESTIMATE:** 1–2 h. Revoke test roles/tokens and clear fixtures |
| G8-T17 | Projection retry cannot double-count | Facts with projection work; kill hooks around contribution insert, aggregate update and completion | Run/kill/restart projection repeatedly; rebuild projection from facts | **PASS:** one contribution per `(realm,fact,projection_version)` and aggregate equals reference/rebuild. **FAIL:** double count, missing contribution with completed work, or fact mutation | contribution/aggregate/work ledger, rebuild diff | **ESTIMATE:** 1–3 h. Drop projection fixtures |
| G8-T18 | Integration outbox isolates network and preserves stable delivery identity | Hostile downstream stub commits then loses response, rejects, delays and returns duplicate receipt; network traces | Materialize fact, deliver outbox, lose responses/retry/restart | **PASS:** fact transaction never waits on network; same message ID replayed; no cross-realm/dynamic destination; terminal integration state explicit. **FAIL:** direct send in fact tx, new ID, fact rollback/mutation, or hidden drop | DB/HTTP timelines, message IDs, outbox attempts, downstream ledger | **ESTIMATE:** 1–3 h. Stop stub/proxy, remove certs/rules/data |
| G8-T19 | Backpressure contains one noisy realm without silent loss | Several realms, one floods bounded uploads; per-realm admission/queue/worker limits and global reserve | Ramp noisy realm while steady low-rate realms submit/process; trigger queue high-water/kill switches | **PASS:** noisy realm throttled with safe responses; other realms retain progress; every accepted receipt remains; no hidden deletion. **FAIL:** global collapse, cross-realm starvation beyond test bound, or receipt loss | admission/queue-age/service distribution, receipt reconciliation | **ESTIMATE:** 2–6 h. Stop load and drain or delete T1 fixtures through governed cleanup |
| G8-T20 | API/worker host loss and rolling restart preserve custody/leases | Multiple API and worker hosts behind test balancer; process/service kill and rolling replacement | Kill API before/after commit; kill workers in claim/parse/final tx; roll version N to N+1 consumer-first | **PASS:** committed receipt replayable; leases expire/reclaim; supported schemas processed once; no mixed terminal state. **FAIL:** receipt loss, stale commit, unsupported producer enabled first, or cleanup residue | host/process/DB timeline, request/lease/fact ledgers, rollout inventory | **ESTIMATE:** 2–4 h. Restore host images and remove test configuration |
| G8-T21 | Database primary failover has explicit ambiguous-commit recovery | Engine-native HA lab or equivalent supported failover topology; synchronous/asynchronous modes separately labeled; DB/client logs | Fail primary before/during/after receipt and materialization commits; reconnect and replay/reconcile | **PASS:** same identity resolves to prior or committed state; no duplicate fact/receipt; evidence states the actual failure domain. **FAIL:** conflicting outcomes, receipt emitted outside class, or unclassified data loss | failover mode/config, commit timeline, DB logs, invariant report | **ESTIMATE:** 4–8 h/topology/engine. Restore cluster and verify replicas/volumes cleaned |
| G8-T22 | Backup/restore never becomes ready with unexplained receipt/fact gaps | Scheduled full/differential/log or base/WAL backup profile; restore to multiple points; endpoint emulator retains batches | Issue receipts/materialize/quarantine across backup timeline; restore; keep workers/API/portal disabled; reconcile; replay retained batches | **PASS:** readiness only after every receipt is present or explicitly classified/recovered and facts/quarantine reconcile. **FAIL:** automatic readiness, invented receipt, duplicate effect, or unexplained missing acknowledged batch | backup IDs/config, restore points, receipt/fact/quarantine diff, readiness decision | **ESTIMATE:** 4–12 h/engine/profile. Destroy restored lab copies and keys after evidence |
| G8-T23 | Schema migration remains compatible and crash-resumable | N/N+1 API/worker binaries, expand/backfill/contract migrations, fault hooks, old/new fixtures | Upgrade consumer first; crash each migration step; run N and N+1 within declared horizon; roll back | **PASS:** receipt and terminal invariants hold; old consumer behavior matches declared support; no startup destructive DDL. **FAIL:** receipt outage, unreadable state, silent schema coercion, or rollback trap | migration ledger, schema hashes, compatibility matrix, failure capsules | **ESTIMATE:** 4–8 h/migration/engine. Revert schema/DB through isolated fixture reset |
| G8-T24 | Database security and RLS are defense in depth, not sole realm guard | Least-privilege API/worker/reconciler roles; PostgreSQL owner/BYPASSRLS and SQL Server elevated-role negatives; connection-pool context tests | Attempt cross-realm SQL through repositories, session-context contamination, direct DML, owner/admin bypass | **PASS:** application roles cannot cross realm; pooled context reset; privileged bypass is documented/audited, not falsely claimed prevented. **FAIL:** app-role cross-realm access or stale context | grants/policies/config digest, SQL audit, negative results | **ESTIMATE:** 1–3 h. Drop roles/credentials/policies and verify |
| G8-T25 | Privacy-safe observability has bounded vocabulary/cardinality | Generated catalogue, analyzers, canaries in all source fields and errors; metrics/traces/log/access-log/support capture | Exercise every outcome and adversarial distinct UUID/site/error; mutate code to log arbitrary values/exceptions | **PASS:** forbidden calls fail build/runtime; no canary; theoretical and observed series within T1 budget. **FAIL:** body/header/site/realm/ID leak, dynamic label/name, stack/body dump | catalogue, analyzer mutations, all-sink scan, series report | **ESTIMATE:** 1–3 h. Delete telemetry backend/test captures under manifest |
| G8-T26 | Operational CLI is closed and cannot become a general data/SQL channel | Read-only reconciler role and finite repair-operation test role; command schemas; shell/SQL injection corpus | Run status/reconcile/claim-drain/reprocess commands with wrong realm, wildcards, free-form SQL/path/payload export attempts | **PASS:** read-only default, finite authorized mutations, durable audit, no raw export or arbitrary SQL. **FAIL:** generic query/script, unaudited change, or cross-realm scope | command manifest, authorization/audit results, DB diff | **ESTIMATE:** 1–2 h. Revoke credentials and clear command fixtures |
| G8-T27 | Reconciler proves the primary gate after faults | Dataset containing received, processing, retry, materialized and quarantined batches plus deliberate corrupt fixtures | Run read-only reconciliation before/after recovery; inject orphan/mismatch rows through privileged lab fixture only | **PASS:** every legitimate receipt maps to exactly one terminal outcome after drain; every injected impossibility is detected; no destructive auto-fix. **FAIL:** missed defect or false clean | full reconciliation JSON, SQL evidence digests, fixture truth | **ESTIMATE:** 30–90 min. Drop corrupt lab DB after retaining sanitized findings |
| G8-T28 | Relational queue remains simplest under provisional workload | Identical generated workload across engine candidates; broker-free topology; per-stage CPU/I/O/log/locks/latency/cost counters | Run steady, burst, retry storm, poison, outage recovery and fan-out scenarios at replacement-input scales | **PASS:** no primary failure and resource/headroom within later human budget. **FAIL:** primary invariant failure; performance result alone informs, not decides, broker/engine | benchmark manifest, distributions, plans, resource and cost inputs | **ESTIMATE:** hours to multi-day soak. Purge all T1 load data and restore lab baseline |

## 8.4 Smallest falsifying prototypes

### P15-01 — receipt transaction and lost response

**Claim.** Returning a receipt after one relational transaction makes an ambiguous client response safely replayable.

**Setup.** One API process, one database, one fictional authenticated context, one sealed batch, and a fault hook after database commit but before the response leaves the process.

**Instrumentation.** Database transaction log/commit evidence, exact batch/payload/receipt queries, client attempt ledger, API process events, and canary scan.

**Steps.** Submit once, kill at the hook, restart, look up the receipt, and replay the exact request. Repeat with a kill immediately before commit.

**Pass.** Before-commit kill leaves no custody rows. After-commit kill leaves exactly one immutable batch, payload and receipt; lookup and replay return the same receipt.

**Fail.** Any orphan row, second receipt, changed receipt fields, response before commit, or unclassified outcome.

**Evidence.** `p15-01/{request.json,attempts.ndjson,db-snapshots/,receipt-replay.json,invariants.json,cleanup.json}` with fictional values or digests only.

**Duration/cleanup.** **ESTIMATE:** under 60 minutes per engine after harness creation. Drop the isolated database and remove the test identity/trust.

### P15-02 — duplicate versus identity conflict

**Claim.** The pair of content and wire hashes distinguishes safe replay from changed bytes under one batch ID.

**Setup.** Original gzip batch, byte-identical replay, deterministically recompressed equivalent JSON, and one-byte canonical mutation.

**Steps.** Submit original; submit variants serially and concurrently.

**Pass.** Exact same hashes return the original receipt. Either hash mismatch returns stable conflict without changing the original payload or receipt.

**Fail.** Recompression or mutation is accepted as the original, overwrites custody, or creates a second normal batch.

**Evidence.** Original/variant digests, response corpus, immutable-row before/after hashes, conflict occurrence.

### P15-03 — lease fence

**Claim.** An expired worker cannot commit after another worker reclaims the batch.

**Setup.** Worker A pauses after parsing; database time advances beyond lease; worker B reclaims and commits.

**Pass.** A's heartbeat/final update affects zero rows and A exits; there is one terminal state and one fact set.

**Fail.** A commits or extends the superseded lease.

**Evidence.** Claim token/version/expiry history, affected-row counts, terminal/fact ledger.

### P15-04 — worker death after each fact-operation boundary

**Claim.** The final materialization transaction yields no partial batch even when the worker dies after a fact insert.

**Setup.** One batch with a new event, a same-content duplicate and another new event; hooks after every SQL operation.

**Pass.** Every pre-commit death restores the previous state; every post-commit/pre-observation death exposes the complete state on retry. No orphan dedupe/fact/projection/outbox row exists.

**Fail.** Any sibling partial success, missing terminal state, duplicate fact, or changed event identity.

**Evidence.** One minimized failure capsule per hook and the pure-model comparison.

### P15-05 — poison and terminal quarantine

**Claim.** An unsupported or conflicting event cannot retry forever and cannot partially materialize siblings.

**Setup.** A batch with one valid event and one deterministic unsupported-schema or event-identity conflict.

**Pass.** The whole batch reaches `QUARANTINED_TERMINAL`, no fact from that batch is inserted, the receipt remains recoverable, and another scheduler pass does not reclaim it.

**Fail.** Silent drop, valid sibling materialization, automatic retry loop, or payload deletion.

**Evidence.** Batch state, processing attempts, quarantine occurrence, fact absence, receipt lookup.

### P15-06 — cross-realm collision

**Claim.** Identical UUIDs in two realms remain isolated through submit, lookup, claim, materialization, reprocess and projection.

**Setup.** Two fictional realms intentionally reuse batch, receipt, event, fact and command UUIDs; two app roles/contexts.

**Pass.** Each realm produces its own valid lineage; every wrong-realm operation fails without revealing the other realm. Connection pooling does not retain prior realm context.

**Fail.** Any cross-realm read/write/claim/reprocess, uniqueness collision across realms, or diagnostic leakage.

### P15-07 — restore and receipt reconciliation

**Claim.** A restored database cannot return to service while an issued receipt is missing or its terminal lineage is unexplained.

**Setup.** Issue receipts before and after backup/log points; materialize some and quarantine others; restore to selected points while endpoint emulator retains exact batches.

**Pass.** Readiness is blocked; reconciler identifies missing/unresolved receipts; exact endpoint replay restores safe custody without duplicate facts; only then may processing resume.

**Fail.** Automatic readiness, invented custody, duplicate business effect, or missing receipt classified as success without human authority.

### P15-08 — relational broker break-even measurement

**Claim.** The relational design meets the provisional T1 workload without a broker and exposes the exact resource that would justify reconsideration.

**Setup.** Same synthetic workload, schema and fault schedule on PostgreSQL and SQL Server, with no broker packages/services.

**Pass.** Primary invariants remain zero-failure and the measured claim/heartbeat/log/lock/resource profile is below the later approved budget. A breach identifies a reproducible bottleneck and attempted relational tuning.

**Fail.** Any primary invariant failure. A performance-budget breach opens measurement evidence; it does not by itself authorize a broker.

## 8.5 Failure/recovery acceptance matrix

| Failure point | Expected durable state | Detection | Containment | Recovery | Prohibited shortcut |
|---|---|---|---|---|---|
| API process before receipt commit | no batch/payload/receipt | client failure + zero-row reconciliation | retry same sealed batch | ordinary replay | mint new batch ID automatically |
| API process after commit/before response | complete custody/receipt | receipt lookup/replay | no new identity | return stored receipt | infer failure from lost response |
| Database ambiguous commit | prior or committed complete state | reconnect + same-key lookup | stop changed-ID retries | replay exact batch | manual receipt insertion |
| Worker before claim commit | eligible batch remains | scheduler/lease state | none | claim again | mark processed from in-memory state |
| Worker after claim/before final tx | active then expired lease, no semantic effects | heartbeat/expiry | fence stale token | reclaim/recompute | extend lease without token/version |
| Worker inside final tx | prior state after rollback or full state after commit | DB reopen + invariant query | no partial visibility | retry same processing generation | repair individual sibling rows manually |
| Worker after final commit/before observing success | complete terminal state | reload batch | idempotent read | return/continue from terminal state | start new processing generation automatically |
| Projection worker death | fact authoritative; work pending or complete atomically | work/contribution reconciliation | portal visibility can lag | retry/rebuild from facts | mutate fact to match projection |
| Integration response loss | outbox attempt ambiguous | downstream lookup/replay where contract permits | same message ID | retry same message | send direct from fact table with new ID |
| Poison schema/content | receipt/payload plus terminal quarantine | finite reason/attempt history | no scheduler reclaim | deploy compatible processor then audited reprocess | silently drop or coerce |
| Realm mismatch | no affected target rows | affected-row count/security event | deny/kill affected path | fix context/config; incident review | search other realms for a matching ID |
| Primary failover | complete prior/committed transaction per engine guarantee | DB/client failover evidence + reconciliation | pause if class unknown | reconnect/replay same identity | claim stronger durability than configured |
| Restore behind issued receipt | restored state plus missing receipt set | mandatory pre-readiness reconciliation | API/worker/portal off | endpoint replay/other approved recovery; human loss decision | declare ready because DB integrity check passes |
| Disk/log full | no committed partial transaction; accepted receipts retained | DB/storage alerts and errors | admission/worker throttles; cleanup disabled unless safe | add capacity/repair and resume | delete unacknowledged payload/facts |
| Schema migration crash | last complete migration step and readable supported state | migration ledger/schema hash | block incompatible binaries | resume/rollback under declared matrix | application startup drops/recreates tables |

## 8.6 G8 test stop rule

The G8 prototype stops dependent work immediately on any:

- receipt without exact immutable custody payload;
- response before receipt transaction commit;
- changed bytes accepted under an existing batch ID;
- stale lease commit;
- partial batch materialization;
- retry-created duplicate fact;
- silent event/schema coercion or unbounded poison retry;
- cross-realm read, write, claim, replay, reprocess, projection or integration;
- forbidden-value canary escape;
- restore readiness with an unexplained issued receipt;
- destructive or raw-data operational tool path;
- cleanup residue or missing first-failure evidence.

A stop opens the named ADR or implementation defect. It does not permit a lower-assurance fallback.

---

# 9. Architecture fitness functions and measurable acceptance criteria

## 9.1 Fitness-function rules

A fitness function is executable, versioned, engine-specific only where necessary, and has a named failure owner. It runs in pull requests where practical, in trusted integration lanes for database behavior, at startup for read-only schema/config checks, and before/after every fault/restore campaign. A dashboard is not the fitness function; the query/model/assertion is.

Every function emits:

```text
fitnessFunctionId
contractVersion
sourceRevision
engineAndBuild
schemaDigest
configurationDigest
fixtureOrEvidenceRoot
observedValue
expectedPredicate
passFail
firstFailureReference
```

## 9.2 Core invariant fitness functions

| ID | Executable predicate | Frequency | Failure action |
|---|---|---|---|
| FF15-01 | Every `ingest_receipt` has exactly one same-realm `ingest_batch` and `ingest_payload` with matching IDs/digests | PR integration, startup, recurring reconciler, pre/post restore | stop receipt issuance/processing; incident and reconciliation |
| FF15-02 | No batch has more than one receipt; immutable receipt fields never change | migration tests and recurring | stop release; investigate direct DML/schema defect |
| FF15-03 | A batch ID has one immutable `(batch_content_sha256, wire_content_sha256, contract)` tuple per authenticated realm/installation scope | every materialization/reconciler run | security/data-quality hold |
| FF15-04 | Every terminal batch is exactly one of `MATERIALIZED` or `QUARANTINED_TERMINAL`, never both; every accepted batch eventually reaches one after a bounded T1 drain | G8 gate and recurring health | stop gate; classify backlog/worker failure |
| FF15-05 | No nonterminal batch owns an expired active lease that is not reclaimable; no terminal batch owns a lease | recurring worker/reconciler | clear only through fenced state transition; defect if impossible |
| FF15-06 | Final semantic writes require current lease token/version and unexpired database time; affected row count is exactly one | every final transaction and fault tests | rollback; stale-worker event; no retry with changed identity |
| FF15-07 | Each `(realm_id,event_id)` maps to one immutable effect hash and at most one fact | transaction constraint plus reconciliation | whole-batch quarantine/incident |
| FF15-08 | Same event ID/effect hash replay produces no new fact, contribution or integration message | contract/model tests and recurring reconciliation | stop release and rebuild derived state if facts intact |
| FF15-09 | A changed effect hash under an existing event ID cannot create/replace a fact | constraints, transaction tests | terminal conflict quarantine |
| FF15-10 | Every materialized batch's planned new events have matching dedupe/fact/projection-work/integration-outbox rows according to contract | after final tx, recurring | stop processing version; preserve facts; repair through governed operation |
| FF15-11 | Every terminal quarantine has at least one immutable quarantine occurrence with finite reason, processor/schema evidence, and payload custody link | transaction and recurring | stop quarantine/reprocess path |
| FF15-12 | A reprocess generation never deletes or mutates a previous occurrence/generation | migration/model/reconciler | security/data-governance hold |
| FF15-13 | Every completed projection work item has exactly one contribution; aggregate equals contribution recomputation for the test domain | recurring sample/full T1 reconciliation | disable projection visibility; rebuild from facts |
| FF15-14 | Every integration message originates from a materialization transaction/fact and has a stable same-realm ID/destination contract | recurring | disable affected integration; replay/repair through outbox |
| FF15-15 | No endpoint/auth/API payload can supply realm, installation, credential status, DB object name, destination or SQL authority | schema/static/hostile contract tests | reject build/release |
| FF15-16 | Every primary/unique/foreign key and every queue lookup begins with or is transitively constrained by `realm_id` | schema lint and migration gate | reject migration |
| FF15-17 | Application roles cannot read/write/claim another realm; pooled connection context is reset before reuse | integration/security lane | security incident; rotate credential and patch |
| FF15-18 | No general logs, metrics, traces, access logs, support bundles or errors contain a canary or forbidden key | every CI/lab run and release gate | privacy incident; stop exporter/release |
| FF15-19 | Metric names/labels and error/reason values are members of the release catalogue; theoretical/observed series fit the approved budget | build plus runtime test | reject signal or release |
| FF15-20 | API receipt transaction and worker final transaction remain below the approved statement/lock-duration profile for the named workload | benchmark/release qualification | performance stop; tune or ADR; never weaken atomicity silently |
| FF15-21 | No broker client/package/configuration/credential/service is present while ADR status is `BROKER_DEFERRED` | dependency/SBOM/config/topology scan | reject build/deployment |
| FF15-22 | Database schema, functions/triggers, indexes, roles and RLS/security policies match the approved schema digest | startup read-only check and release/migration gate | safety hold; migrator/restore only |
| FF15-23 | Restored environment cannot become API/worker/portal ready until receipt/fact/quarantine/deletion-readiness reconciliation passes | restore orchestration | remain unavailable; recover or human loss decision |
| FF15-24 | Cleanup/purge selects only records satisfying receipt, retention, hold, restore-readiness and audit predicates | purge dry-run and T1 fault tests | cleanup remains disabled |

## 9.3 Representative invariant queries

The following are logical queries. Engine adapters provide checked SQL with captured plans. They are read-only and must use authenticated/privileged reconciliation scope rather than application payload parameters.

### 9.3.1 Receipt without complete custody

```sql
SELECT r.realm_id, r.installation_id, r.receipt_id, r.batch_id
FROM ingest_receipt AS r
LEFT JOIN ingest_batch AS b
  ON b.realm_id = r.realm_id
 AND b.installation_id = r.installation_id
 AND b.batch_id = r.batch_id
LEFT JOIN ingest_payload AS p
  ON p.realm_id = r.realm_id
 AND p.installation_id = r.installation_id
 AND p.batch_id = r.batch_id
WHERE b.batch_id IS NULL
   OR p.batch_id IS NULL
   OR b.batch_content_sha256 <> r.batch_content_sha256
   OR b.wire_content_sha256 <> r.wire_content_sha256
   OR p.wire_content_sha256 <> r.wire_content_sha256;
```

**Acceptance:** zero rows.

### 9.3.2 Impossible or missing terminal outcome after a controlled drain

```sql
SELECT b.realm_id, b.installation_id, b.batch_id, b.processing_state
FROM ingest_batch AS b
JOIN ingest_receipt AS r
  ON r.realm_id = b.realm_id
 AND r.installation_id = b.installation_id
 AND r.batch_id = b.batch_id
WHERE b.processing_state NOT IN ('MATERIALIZED', 'QUARANTINED_TERMINAL');
```

**Acceptance:** zero rows only at the end of the G8 controlled drain. In live operations, nonterminal rows are expected; the fitness function instead checks age/state/lease/retry predicates and does not pretend all work is synchronous.

### 9.3.3 Materialized batch with missing effects

```sql
SELECT b.realm_id, b.installation_id, b.batch_id
FROM ingest_batch AS b
WHERE b.processing_state = 'MATERIALIZED'
  AND EXISTS (
      SELECT 1
      FROM materialization_plan_event AS e
      LEFT JOIN event_dedupe AS d
        ON d.realm_id = e.realm_id
       AND d.event_id = e.event_id
      WHERE e.realm_id = b.realm_id
        AND e.installation_id = b.installation_id
        AND e.batch_id = b.batch_id
        AND d.event_id IS NULL
  );
```

`materialization_plan_event` may be a test/reconciliation projection rather than a permanent production table. The implementation must preserve enough deterministic provenance to prove the same predicate without storing an unnecessary duplicate raw plan.

### 9.3.4 Duplicate or conflicting fact identity

```sql
SELECT realm_id, event_id, COUNT(*)
FROM fact_envelope
GROUP BY realm_id, event_id
HAVING COUNT(*) <> 1;
```

**Acceptance:** zero rows for materialized event IDs. A separate query verifies the dedupe effect hash equals the fact provenance hash.

### 9.3.5 Terminal quarantine without occurrence

```sql
SELECT b.realm_id, b.installation_id, b.batch_id
FROM ingest_batch AS b
LEFT JOIN ingest_quarantine_occurrence AS q
  ON q.realm_id = b.realm_id
 AND q.installation_id = b.installation_id
 AND q.batch_id = b.batch_id
 AND q.processing_generation = b.processing_generation
WHERE b.processing_state = 'QUARANTINED_TERMINAL'
GROUP BY b.realm_id, b.installation_id, b.batch_id
HAVING COUNT(q.quarantine_id) = 0;
```

**Acceptance:** zero rows.

### 9.3.6 Stale/terminal leases

```sql
SELECT realm_id, installation_id, batch_id, processing_state, lease_expires_at_utc
FROM ingest_batch
WHERE (processing_state IN ('MATERIALIZED', 'QUARANTINED_TERMINAL')
       AND lease_token IS NOT NULL)
   OR (processing_state = 'LEASED'
       AND lease_expires_at_utc IS NULL);
```

**Acceptance:** zero rows. Expired processing leases are not inherently corrupt; they must be reclaimable and visible to the scheduler.

## 9.4 Static architecture fitness functions

The build MUST fail when a mutation introduces any of these dependencies or APIs:

- endpoint or contract packages referencing a database driver or SQL API;
- ingestion API referencing application registry, projection, integration clients, broker clients, or arbitrary HTTP clients;
- materialization domain referencing ASP.NET request/response types;
- receipt transaction invoking network, filesystem payload export, semantic application lookup, or projection code;
- worker claim transaction invoking decompression/parsing;
- final materialization transaction invoking external network;
- persistence models reused as public API DTOs or portal view models;
- general `ILogger` interpolated/free-form payload values, raw exception serialization, automatic HTTP body/header logging, dynamic metric/span/event names, or unrestricted tags;
- reflection-discovered handlers, tenant plugins, scripts, regex, SQL, dynamic assemblies, or unbounded extension bags in ingestion/materialization contracts;
- an operator command accepting free-form SQL, filesystem path, URL, executable, assembly, generic JSON patch, or arbitrary realm list;
- a broker package/service configuration before ADR approval;
- test fault hooks/controllers or test CA keys in a production file manifest.

## 9.5 Realm-isolation fitness model

Realm isolation is a composition of controls, not one feature:

```text
AuthenticatedDeviceContext
  + realm-scoped domain keys
  + composite unique/foreign keys
  + explicit repository RealmScope
  + parameterized SQL
  + per-request/per-work-item connection context reset
  + least-privilege DB roles
  + RLS/security policy where selected
  + realm-negative tests
  + scoped caches/queues/metrics/admin authorization
  + reconciliation
```

The primary acceptance criteria are:

1. identical UUID values in two realms coexist without collision;
2. no application role can retrieve or mutate another realm by changing body, route, header, query, cache key, session context or command;
3. a worker claim always returns the realm with the batch and every subsequent query uses that immutable scope;
4. no fallback searches “all realms” when an ID is missing;
5. reprocess, purge, projection, integration and receipt lookup use the same realm scope;
6. realm is not a general metric label or body field used as authority;
7. privileged cross-realm reconciliation is read-only by default, explicitly audited, and not exposed through ordinary support paths.

## 9.6 Backpressure and fairness fitness functions

No exact production threshold is selected. G8 records replacement inputs for later capacity work:

- receipt transaction rate/latency and bytes/log bytes per batch;
- compressed/decompressed/event-count distributions;
- ready/retry/processing/quarantine counts and oldest age by authorized realm view;
- claim scans, rows examined/claimed, skipped-lock counts, lock waits, deadlocks, escalation/page-lock evidence, transaction duration, and heartbeat writes;
- per-realm accepted, throttled, claimed, completed and service-lag distributions;
- worker parse/final-transaction CPU, allocation, memory, and DB log cost;
- projection/integration backlog and attempt distributions;
- database size, index size, dead/versioned row cleanup, WAL/transaction-log growth, backup size/time, restore time, and reconciliation time;
- API/worker/DB connection-pool saturation and global reserve usage.

**RECOMMENDATION.** The scheduler initially uses a bounded per-realm deficit/round-robin selection layer over engine queue claims rather than one global `ORDER BY received_at`. The exact quantum, per-realm concurrent claims, global workers, heartbeat cadence, lease duration and retry backoff are **ESTIMATE/CLI EXPERIMENT** values. Fairness passes only when the defined T1 victim realms make progress under the noisy-realm campaign; no single percentile is promoted to an SLO without human approval.

## 9.7 G8 measurable acceptance criteria

| Area | Technical acceptance criterion | Not decided by this result |
|---|---|---|
| Custody | zero receipt/batch/payload transaction anomalies over every deterministic and real fault point | production durable failure domain and RPO |
| Idempotency | zero duplicate facts and zero changed-content overwrites across serial/concurrent replay/failover/restore corpus | correction business semantics |
| Leases | zero stale-token commits; bounded claim/final transactions; no duplicate active claim | production lease/heartbeat values and worker count |
| Poison | every deterministic poison is pre-receipt reject or terminal quarantine with finite code; zero infinite loops | schema support horizon and operator SLO |
| Realm | zero cross-realm results in all positive/negative/collision/pooling/admin tests | legal definition and production realm ownership |
| Projection | fact-authoritative rebuild equals contribution/aggregate truth in T1 | portal visibility SLO and aggregate catalogue |
| Integration | every send derives from outbox and preserves stable ID; response loss does not change fact | downstream ownership/SLO/compensation |
| Restore | zero unexplained receipt/fact/quarantine findings before readiness | approved RPO/RTO and endpoint cleanup grace |
| Privacy | zero canary/forbidden-field escapes and bounded catalogue/cardinality | production access/retention and backend choice |
| Operations | closed CLI/runbooks diagnose the named T1 failure set without raw payload | staffing, on-call and support promise |
| Engine parity | same primary invariants and workload/fault definitions pass on both candidates | final production engine/licensing/topology |
| Broker | no broker dependency/topology and no approved break-even trigger | future broker decision if measured requirements change |

---

# 10. Human decisions and owner questions

Research does not make the following decisions. A role name identifies an accountable function, not an assigned person. Until a decision is recorded, the conservative state applies and must be representable in code/configuration without a hidden default.

## 10.1 Mandatory human decisions named by the prompt

### HD15-01 — durable receipt failure domain and RPO/RTO

**HUMAN DECISION.** What exact failure domain does `DURABLY_RECEIVED` mean, and what loss/unavailability objectives are accepted?

| Option | Meaning | Consequences |
|---|---|---|
| A — primary database durable commit | Receipt after local engine commit in one primary failure domain | smallest latency/complexity; primary/storage/site loss can invalidate receipts newer than backups/replica replay; endpoint cleanup cannot safely rely on it unless that loss is accepted |
| B — synchronous same-site replica/availability group commit | Receipt after engine reports synchronous remote durability within one site/failure group | stronger server/instance failure containment; higher latency and coupled availability; still exposed to site/operator/correlated storage failure |
| C — synchronous independent-site/zone durability | Receipt after a transaction is durable in an approved independent failure domain | stronger custody claim; material availability/latency/cost and split-brain/operations complexity; must be proved for both failure and recovery |
| D — primary commit plus independently verified backup/archive predicate | Receipt class may require a later asynchronous milestone; endpoint must not treat the early response as final cleanup authority | separates fast custody from cleanup eligibility but creates multiple receipt/durability states and operational lag |

**Conservative temporary default.** For G8, use a named `LAB_SINGLE_PRIMARY` class and set `productionCleanupEligible=false`. It proves state-machine behavior only and MUST NOT authorize endpoint payload cleanup or claim production RPO.

**Accountable function.** Data Reliability/SRE with Product Risk/Data Owner and Records/Privacy; Security/Infrastructure consulted.

**Evidence required.** Engine/topology configuration, commit/failover tests, independent backup/restore drills, measured receipt latency/availability, endpoint retained-replay behavior, and incident recovery.

### HD15-02 — schema support horizon

**HUMAN DECISION.** For how long and across how many producer/consumer releases must ingestion accept and materialize old batch/event schemas?

| Option | Meaning | Consequences |
|---|---|---|
| A — current producer only | only one schema profile at a time | simplest code and assurance; incompatible with offline endpoints and consumer-first rollout unless all producers are synchronized |
| B — current plus one predecessor | bounded compatibility and rollback profile | reasonable first planning target; still may be shorter than real offline/enterprise rollout windows |
| C — time-based horizon | support all schema versions emitted within an approved period | aligns with offline distributions; accumulates parser/test/security/operations cost and requires exact retirement evidence |
| D — long-lived archival replay support | retain old consumers or translation for a much longer period | highest recovery/reprocessing flexibility; largest attack surface, dependencies, test matrix, and cost |

**Conservative temporary default.** Implement strict current plus one explicitly named predecessor in T1 only, with all other schemas terminally quarantined as `UNSUPPORTED_EVENT_SCHEMA`. This is a planning profile, not an approved fleet commitment.

**Accountable function.** Contract Authority/Product Release with Endpoint Fleet/Support, Data Governance, Security and Operations.

**Evidence required.** measured offline and rollout distributions, endpoint receipt/ACK replay grace, support obligations, security lifecycle of parser dependencies, storage/quarantine cost, and migration/rollback evidence.

### HD15-03 — operational ownership and SLOs

**HUMAN DECISION.** Which functions own ingestion API, database, materialization, quarantine, reconciliation, projection, integration, security incidents and support, and what service objectives apply?

Options are organizational rather than purely technical:

- one combined server-platform on-call owns API/DB/workers with specialists on escalation;
- split application and database/SRE ownership with a joint incident protocol;
- managed database provider plus internal application ownership;
- product-team ownership with a central platform providing runtime/observability only.

**Consequences.** Split ownership can improve specialization but create gaps at the receipt/failure-domain boundary. A combined team reduces handoffs but requires deep database, security and support competence. Managed services do not transfer UAM receipt semantics, realm isolation or data-governance accountability.

**Conservative temporary default.** No production SLO or support promise. Every unassigned blocking component remains disabled outside T1 lab. G8 runbooks name accountable functions even before named people exist.

**Accountable function.** Engineering/Operations Leadership with Product Risk, SRE, Database Engineering, Security, Privacy/Data Governance and Support.

**Evidence required.** RACI/on-call/escalation, skill inventory, runbook drills, alert ownership, maintenance/patch policy, capacity/restore exercises, budget and incident command.

## 10.2 Additional human decision register

| ID | HUMAN DECISION | Options/consequences | Conservative temporary default | Accountable function | Blocks |
|---|---|---|---|---|---|
| HD15-04 | Production database engine and topology | PostgreSQL reference, SQL Server transition/fallback, managed/self-hosted, HA/region choices; affect licensing, skills, operations, latency, restore and support | both remain G8 candidates; no production selection | Architecture with DB/SRE, Security, Legal/Procurement, Finance | production DDL/topology/capacity |
| HD15-05 | Production batch compressed/decompressed/event/time limits | smaller limits contain transactions/poison but increase request overhead; larger limits improve efficiency but amplify poison/locks/log/memory | deliberately small T1 limits, versioned and rejected outside profile | Product/Endpoint/Server SRE with Security/Privacy | producer activation/capacity |
| HD15-06 | Retention of wire payload, receipts, conflicts, attempts, quarantine, facts, contributions, outbox and operational evidence | different legal/operational purposes and deletion/hold needs; one global retention is unsafe | no production purge; short manifest-owned T1 cleanup only | Records/Data Controller/Data Owner with Privacy/Legal/SRE | cleanup, storage sizing, restore |
| HD15-07 | Who may inspect custody payload and under what process | DB administrators, restricted incident role, dual approval, no ordinary support access | metadata-only support; raw payload access disabled except isolated T1 lab | Data Controller/Privacy/Security IAM/Incident Authority | production support and investigation |
| HD15-08 | Quarantine reprocess/purge authority and approvals | single authorized operator, separation of request/approval, dual control for broad realm operations | reprocess T1 only; no production purge | Data Governance/Product Security/Operations | control API and runbooks |
| HD15-09 | Fact correction/supersession semantics | immutable correction facts, versioned supersession, rebuild, or no correction feature | no in-place fact mutation and no production correction | Data Owner/Governance with Product/Privacy | changed-content resolution/reprocessing |
| HD15-10 | Projection catalogue, visibility readiness and rebuild policy | synchronous versus asynchronous visibility, dual-version cutover, stale-data warnings, rebuild cost | facts authoritative; portal visibility remains off in G8 except T1 verification | Product/Data/Portal/SRE | portal launch/SLO |
| HD15-11 | Integration destinations, contracts, data fields, consumer idempotency and compensation | each destination changes privacy, security, retention and failure semantics | no production destinations; T1 hostile stub only | Integration Owner with Product/Privacy/Security/Data Governance | integration activation |
| HD15-12 | Realm definition, transfer, merge/split and administrative boundaries | tenant/customer/legal region or another governance unit; affects every key/cache/job/access rule | one fictional isolated realm; no transfer/merge | Data Controller/Product Governance/IAM | production enrollment/admin |
| HD15-13 | RLS/security-policy use and privileged DBA model | defense in depth, operational complexity, owner/admin bypass, support tooling | composite keys and typed scopes mandatory; add RLS in both prototypes and treat as secondary | DB Security/Architecture/SRE | production DB role model |
| HD15-14 | Partitioning/index grain and lifecycle | time/realm/hash partitions can help maintenance but increase migrations, uniqueness and plan complexity | unpartitioned G8 schema with required indexes; measure first | Database Engineering/SRE | capacity/retention operations |
| HD15-15 | Encryption at rest/application-layer payload protection and key recovery | engine/storage encryption, application envelope, KMS/HSM, escrow/recovery; metadata leakage differs | rely only on isolated T1 environment; production profile undecided | Security/Cryptographic Authority with Privacy/Operations | production data storage/backups |
| HD15-16 | Error/health information visible to endpoints, tenants, support and administrators | detailed errors aid support but leak state/realm/schema; generic errors reduce diagnosis | endpoint gets finite generic contract codes; privileged metadata stays server-side | Product Security/Support/Privacy | API/control UI |
| HD15-17 | Fairness objectives and noisy-neighbor policy | equal realm service, weighted contracts, minimum guarantees, priority for recovery, per-installation caps | bounded round-robin T1 model; no commercial priority | Product/SRE/Risk | production scheduler/admission |
| HD15-18 | Audit technology, retention and privileged-operation evidence | same relational DB, separate append store, external immutable service; each has restore/availability coupling | transactional audit outbox only in G8; final audit store open | Security/Governance/Records/SRE | production admin/reprocess/purge |
| HD15-19 | Broker eligibility and ownership if break-even triggers pass | broker type/topology/retention/ACL/replay/operations/licensing | no broker | Architecture/SRE/Security/Finance | any broker implementation |
| HD15-20 | Accessibility requirements for quarantine/control tooling | screen-reader, keyboard, contrast, error semantics, cognitive load, localization and safe disclosure | CLI and metadata schemas designed for machine-readable/plain-language output; no UI claim | Product/Accessibility/Support | portal/control UI acceptance |
| HD15-21 | Cost, licenses, commercial support and staffing | database editions/cores, cloud service, backup, storage, observability, on-call and training | no unapproved production spend; T1 local licensed/evaluation lanes only | Product/Finance/Procurement/Legal/Leadership | production selection |
| HD15-22 | Pilot/production risk acceptance | scope, realms, data, rollback, support, loss and incident criteria | T1 synthetic lab only | Designated Production/Risk Authority | pilot/production |

## 10.3 Configuration ownership

| Configuration/artifact | Who authors | Who may authorize/activate | Runtime behavior on missing/invalid/stale value |
|---|---|---|---|
| Batch/event contract and schema horizon | Contract Authority | Product Release/Architecture governance | reject pre-receipt when outer contract unsupported; terminal quarantine for durably received unsupported event schema according to active horizon |
| Product privacy ceiling and fields | Product Privacy Authority | signed release/control authority | no broadened processing; safety hold/disable affected schema |
| Authenticated device/realm context | Identity service/PKI registration | server identity boundary/current status service | deny request; payload cannot substitute |
| API limits and admission profile | Ingestion/SRE within release ceiling | controlled config/release authority | fail closed to smaller built-in safety ceiling; no unbounded default |
| Receipt durability class | Data Reliability/SRE design | Product Risk/Data Owner approval and release configuration | production cleanup ineligible; do not issue stronger class |
| Queue lease/retry/fairness profile | Materialization/SRE | controlled release/config authority | use bounded conservative compiled profile or stop claims; no zero/indefinite values |
| Processor/schema/reference profile | Materialization/Contract/Data Governance | consumer release authority | unsupported/unknown becomes retry or terminal quarantine by finite taxonomy; no guessing |
| Quarantine/reprocess rules | Data Governance/Security/Operations | authorized audited command and approved processor release | no automatic reprocess/purge |
| Projection version/cutover | Data/Product owner | controlled release plus readiness evidence | facts remain authoritative; visibility stays on previous ready projection or disabled |
| Integration destination/contract | Integration owner/Product Privacy/Security | governed server control artifact | no destination/send; tenant cannot add URL/topic |
| Retention/hold/purge | Records/Data Controller | authorized data-lifecycle policy | cleanup disabled |
| Database schema/migration | Database Engineering/Application data owner | migrator/release authority | application startup read-only verification; safety hold on drift |
| Broker decision | Architecture/SRE/Security/Finance | accepted ADR and production authority | broker absent and dependency/config scan enforced |

## 10.4 Support ownership and minimum runbook set

The functions below are mandatory ownership boundaries; they are not invented team assignments. A production-shaped pilot remains blocked until a named accountable person/on-call path is recorded for every row and each runbook has been exercised with T1 evidence.

| Boundary | Primary accountable function | Required escalation | Minimum runbooks and evidence | Stop condition |
|---|---|---|---|---|
| API identity, admission and body safety | Ingestion Service Owner | Identity/PKI, Gateway Security, SRE | authentication/status outage; digest/contract rejection; slowloris/compression bomb; admission overload; safe client guidance | no owner, unbounded request behavior, or support requires raw headers/body/certificates |
| Receipt and relational custody | Data Reliability/Database SRE | Ingestion Reliability, Infrastructure, Product Risk | commit uncertainty; failover during receipt; receipt lookup/replay; corruption; backup/restore; receipt-to-payload reconciliation | receipt failure domain is undocumented, recovery invents custody, or issued receipts remain unexplained |
| Lease/materialization/dedupe | Materialization Owner | Database Engineering, Contract Authority, Data Quality | stale worker; retry storm; poison/unsupported schema; event hash conflict; worker death before/after commit; backlog drain | stale lease can commit, retry changes identity, or no bounded path reaches a terminal outcome |
| Quarantine and reprocess | Data Governance Operations | Product Security, Contract Authority, Privacy/Records | metadata-only triage; processor fix; audited reprocess generation; hold/purge prohibition; unsupported-schema aging | arbitrary SQL/direct DML is needed, prior evidence is overwritten, or custody bytes are exposed to ordinary support |
| Projection and integration | Data/Projection Owner and each Integration Owner | Product, downstream service owner, SRE | rebuild/cutover; wrong aggregate; duplicate/lost downstream response; compensation; visibility hold | derived work can be lost, portal shows unready data, or downstream idempotency/ownership is absent |
| Realm-isolation/security incident | Product Security/IAM | Database Security, Privacy, Incident Command | cross-realm negative; credential compromise; RLS/context-pool defect; scope reconciliation; key/credential rotation | any cross-realm result, enumerable error difference, or unresolved privileged-access finding |
| Restore/readiness/reconciliation | Data Reliability/SRE | Records/Deletion Owner, Product Risk, all component owners | point-in-time restore; receipts beyond restore point; reapply holds/deletions; rebuild projections; readiness gate | API/worker/portal starts before zero unexplained findings or an explicit human loss decision |
| Privacy-safe diagnostics and support | Support Owner | Engineering, Privacy, Security, SRE | blind support for receipt/lease/quarantine/restore cases; canary incident; cardinality breach; synthetic reproduction | named failure set cannot be handled without raw payload/unrestricted DB access; support promise must narrow instead |

Every runbook MUST state trigger, authority, detection, containment, evidence to preserve, retry/replay identity, recovery, cleanup, re-enable criteria, adjacent gates to rerun, and the explicit actions that are forbidden. A drill failure is retained as first-failure evidence and blocks the affected gate; it is not converted into a documentation exception.

## 10.5 Owner questions before a production-shaped pilot

1. What physical/logical systems must acknowledge before the server may say `DURABLY_RECEIVED`, and which correlated failures are explicitly outside that promise?
2. After which independently verified event may an endpoint delete its retained batch, and how does restore behind that point recover?
3. What are the measured endpoint offline and rollout tails, and which schema versions must remain safe throughout them?
4. Which team owns a receipt at 03:00 when the API says committed but the replica/backup/restore evidence disagrees?
5. Who owns a batch that is durably received but quarantined for weeks because no compatible processor exists?
6. What exact quarantine metadata may support staff view, and which role—if any—may inspect custody bytes?
7. Is one poison event allowed to quarantine its whole batch at the approved batch size, or is a future per-event terminal contract required?
8. What is the approved noisy-neighbor policy when one realm consumes admission, storage or workers?
9. Which facts are authoritative, which projections may be stale, and how is portal visibility held during rebuild/restore?
10. Which integrations are idempotent, how do they expose custody/acceptance, and who owns compensation when they are not?
11. Which database engine/topology can the organization patch, monitor, back up, restore and troubleshoot under the intended support hours and budget?
12. Which privileged operations require separation of duties or dual approval, and where is their durable audit proof stored?
13. How long may raw custody payload, conflict and quarantine history exist, and how do legal hold and deletion propagate through backups?
14. What evidence would justify an external broker, and who would own its credentials, retention, replay, upgrades and incidents?
15. Which named failure cases must first-line and second-line support solve without raw payload or unrestricted database access?

---

# 11. CLI experiments/measurements and the exact evidence they must produce

## 11.1 CLI safety and evidence rules

All examples use logical placeholders such as `<ENGINE_PROFILE>` and `<EVIDENCE_DIR>`. Connection strings, hosts, addresses, users, passwords, certificates, private keys, internal realm names and actual production configuration MUST NOT appear in commands, stdout, evidence or this result. The test orchestrator obtains secrets through an approved local secret binding and emits only a stable redacted profile ID.

The CLI is closed and schema-driven. It MUST NOT accept free-form SQL, arbitrary URL, path glob, shell command, assembly, script, regular expression, payload print/export or tenant-supplied destination. Destructive lab operations require a separate test build/role and an isolated manifest-owned database/VM/container that the orchestrator proves it created.

Common invocation pattern:

```powershell
$env:UAM_G8_PROFILE = "<ENGINE_PROFILE_ID>"          # resolves outside evidence
$Evidence = "<EVIDENCE_DIR>"

dotnet run --project tools/Uam.G8.Cli -- \
  <command> \
  --profile-id $env:UAM_G8_PROFILE \
  --evidence "$Evidence" \
  --fixture-root "<T1_FIXTURE_ROOT_DIGEST>" \
  --source-revision "<SOURCE_TREE_DIGEST>"
```

Each command writes a canonical `evidence.json`, `files.sha256`, `stdout.redacted.txt`, `stderr.redacted.txt`, first-failure reference, canary result and cleanup receipt. A nonzero exit is never hidden by a wrapper.

## 11.2 Ordered G8 CLI experiments

### E15-00 — allowed-input and toolchain manifest

```powershell
dotnet run --project tools/Uam.G8.Cli -- evidence inventory \
  --profile-id <ENGINE_PROFILE_ID> \
  --evidence <EVIDENCE_DIR>/e15-00
```

**Must produce:**

- hashes of the seven allowlisted internal evidence files used by this result;
- source tree/dirty state;
- .NET SDK/runtime, OS/image, DB engine/build/edition, driver/package and migration tool identities;
- API/worker/tool file manifests and dependency lock/SBOM/provenance references;
- database schema/configuration/role/policy profile IDs;
- proof that no fault controller/test CA/destructive CLI/raw exporter/broker package exists in the production-shaped manifest;
- canary positive-control result and cleanup receipt.

**Pass:** every executable byte and configuration input is exact and admitted for T1 use. **Fail:** mutable image/tag/action, unknown native/driver, unreviewed dependency, missing license record or test capability in release artifact.

### E15-01 — generate the contract emulator and poison corpus

```powershell
dotnet run --project tools/Uam.G8.Cli -- fixture generate \
  --scenario-set g8-core \
  --seed <FIXED_SEED> \
  --output <EVIDENCE_DIR>/e15-01/fixtures

dotnet run --project tools/Uam.G8.Cli -- fixture verify \
  --input <EVIDENCE_DIR>/e15-01/fixtures \
  --oracle-version <ORACLE_VERSION>
```

**Must produce:** byte-identical valid/boundary/duplicate/conflict/unsupported/poison batches, exact compressed and canonical bytes, expected HTTP/receipt/terminal/fact/projection/integration ledger, lineage, canaries and mutation results.

**Pass:** two clean generations are byte-identical and the independent oracle detects all mandatory mutations. **Fail:** real/organization-derived value, nondeterminism, production decision-code dependency or mandatory mutation survivor.

### E15-02 — schema create and domain verifier

```powershell
dotnet run --project tools/Uam.G8.Cli -- database provision \
  --profile-id <ENGINE_PROFILE_ID> \
  --schema-version <SCHEMA_VERSION> \
  --evidence <EVIDENCE_DIR>/e15-02

dotnet run --project tools/Uam.G8.Cli -- database verify-domain \
  --profile-id <ENGINE_PROFILE_ID> \
  --expected-schema-digest <SCHEMA_DIGEST>
```

**Must produce:** exact DDL/migration hashes, object/index/constraint/function/trigger/role/security-policy inventory, schema digest, invalid-state fixture results, captured engine version and cleanup plan.

**Pass:** all required constraints/indexes exist; unknown/manual objects and cross-realm/immutable-state violations are detected. **Fail:** startup creates destructive DDL, schema drift is accepted, realm-less key or mutable receipt/payload exists.

### E15-03 — strict HTTP/streaming contract

```powershell
dotnet run --project tools/Uam.G8.Cli -- contract serve \
  --profile-id <API_PROFILE_ID> \
  --scenario g8-http

dotnet run --project tools/Uam.G8.Cli -- contract attack \
  --target-profile-id <API_PROFILE_ID> \
  --corpus <T1_HTTP_CORPUS_DIGEST> \
  --evidence <EVIDENCE_DIR>/e15-03
```

**Must produce:** per-vector request class, expected/actual status/problem code, compressed/decompressed byte and allocation/time buckets, wire/content digest comparison, zero-row DB verification for rejected requests and all-sink canary report.

**Pass:** exact matrix and bounded resources. **Fail:** ambiguous framing/header/encoding reaches custody, bomb escapes, or request data enters diagnostics.

### E15-04 — receipt transaction failpoints

```powershell
dotnet run --project tools/Uam.G8.Cli -- fault run \
  --suite receipt-transaction \
  --profile-id <ENGINE_PROFILE_ID> \
  --faults all-durable-boundaries \
  --evidence <EVIDENCE_DIR>/e15-04
```

**Required test hooks:** `receipt.before_begin`, `receipt.after_batch_insert`, `receipt.after_payload_insert`, `receipt.after_receipt_insert`, `receipt.before_commit`, `receipt.after_commit_before_response`, `receipt.after_response_build_before_write`.

**Must produce:** one failure capsule per hook, DB snapshots/reopen truth, client attempt/replay ledger and FF15-01–03 results.

**Pass:** prior-or-complete state only. **Fail:** orphan, changed replay outcome, or response before commit.

### E15-05 — duplicate/conflict concurrency

```powershell
dotnet run --project tools/Uam.G8.Cli -- load submit \
  --scenario duplicate-conflict-race \
  --clients <T1_CONCURRENCY_SET> \
  --profile-id <ENGINE_PROFILE_ID> \
  --evidence <EVIDENCE_DIR>/e15-05
```

**Must produce:** all client results, original/variant digests, unique-index/lock/deadlock traces, immutable-row before/after hashes, conflict occurrence and query plans.

**Pass:** one receipt/custody for same hashes; explicit conflict for differences. **Fail:** duplicate normal rows, overwrite or unbounded deadlock/livelock.

### E15-06 — receipt lookup and realm isolation

```powershell
dotnet run --project tools/Uam.G8.Cli -- security realm-matrix \
  --scenario receipt-and-batch-collisions \
  --profile-id <ENGINE_PROFILE_ID> \
  --evidence <EVIDENCE_DIR>/e15-06
```

**Must produce:** same-UUID multi-realm ledger; positive/negative lookup, claim, materialize, reprocess and projection results; pooled connection/session-context reset proof; DB role/RLS-policy evidence; safe response/timing classes.

**Pass:** zero cross-realm result and no existence disclosure outside the approved generic class. **Fail:** any wrong-realm row or stale context.

### E15-07 — worker claim, heartbeat, fairness and stale fence

```powershell
dotnet run --project tools/Uam.G8.Cli -- worker exercise-leases \
  --scenario noisy-realm-and-expiry \
  --workers <T1_WORKER_SET> \
  --profile-id <ENGINE_PROFILE_ID> \
  --evidence <EVIDENCE_DIR>/e15-07
```

**Must produce:** captured claim/heartbeat/fence SQL, plans, locks, scanned/claimed rows, DB-time samples, token/version histories, per-realm service distribution, transaction durations and stale affected-row counts.

**Pass:** one active lease per batch, stale commit zero rows, no defined T1 victim starvation, and no parse inside claim transaction. **Fail:** duplicate/stale commit, long claim transaction, or unbounded heartbeat/lock cost.

### E15-08 — materialization transaction failpoints

```powershell
dotnet run --project tools/Uam.G8.Cli -- fault run \
  --suite materialization-transaction \
  --profile-id <ENGINE_PROFILE_ID> \
  --faults all-durable-boundaries \
  --evidence <EVIDENCE_DIR>/e15-08
```

**Required hooks:** before/after lease fence, each dedupe lookup/insert, each fact insert, projection-work insert, integration-outbox insert, batch terminal update, commit and post-commit observation.

**Must produce:** per-hook history, DB state before/reopen/after retry, oracle diff, affected-row counts and FF15-04–14 results.

**Pass:** previous or complete terminal state only; one fact per new event. **Fail:** partial siblings, orphan derived work, changed event identity or stale commit.

### E15-09 — poison/quarantine corpus

```powershell
dotnet run --project tools/Uam.G8.Cli -- poison execute \
  --corpus <T1_POISON_CORPUS_DIGEST> \
  --profile-id <ENGINE_PROFILE_ID> \
  --repeat <T1_REPEAT_SET> \
  --evidence <EVIDENCE_DIR>/e15-09
```

**Must produce:** vector→stage→reason→terminal/retry mapping, attempts, CPU/memory/time, quarantine provenance, fact absence and scheduler post-terminal no-claim proof.

**Pass:** deterministic finite behavior and bounded resources. **Fail:** silent coercion/drop, crash loop, unbounded retry/resource or partial fact.

### E15-10 — authorized quarantine reprocess

```powershell
dotnet run --project tools/Uam.G8.Cli -- quarantine test-reprocess \
  --scenario authorization-and-generation \
  --profile-id <ENGINE_PROFILE_ID> \
  --evidence <EVIDENCE_DIR>/e15-10
```

**Must produce:** command schema/digest, role/realm/expiry/replay negatives, durable audit outbox, old/new processing generations and immutable occurrence lineage.

**Pass:** only authorized finite command creates a new generation; history remains. **Fail:** arbitrary code/SQL, in-place erase, cross-realm or missing audit.

### E15-11 — projection and integration fault suite

```powershell
dotnet run --project tools/Uam.G8.Cli -- fault run \
  --suite projection-and-integration \
  --profile-id <ENGINE_PROFILE_ID> \
  --faults all \
  --evidence <EVIDENCE_DIR>/e15-11
```

**Must produce:** contribution/aggregate truth/rebuild, integration message/attempt/downstream receipt ledger, network/DB timeline and fact immutability proof.

**Pass:** no double count; same integration message ID on retry; no network in fact transaction. **Fail:** fact mutation, duplicate aggregate contribution, new message ID or direct send.

### E15-12 — API/worker/DB transition kills

```powershell
dotnet run --project tools/Uam.G8.Cli -- fault orchestrate \
  --scenario api-worker-db-transitions \
  --profile-id <HA_PROFILE_ID> \
  --evidence <EVIDENCE_DIR>/e15-12
```

**Must produce:** process/service/primary transition timeline, exact configured failure-domain class, client/DB outcomes, receipt/fact/quarantine reconciliation, first failure and cleanup/revert evidence.

**Pass:** same-identity recovery with no duplicate or unexplained receipt. **Fail:** stronger receipt than configured, conflicting state or missing first-failure evidence.

### E15-13 — reconcile receipts to facts/quarantine

```powershell
dotnet run --project tools/Uam.G8.Cli -- reconcile all \
  --profile-id <ENGINE_PROFILE_ID> \
  --mode read-only \
  --output <EVIDENCE_DIR>/e15-13/reconciliation.json
```

**Must produce:** counts and itemized fictional IDs/digests for receipt→batch→payload→terminal, event→dedupe→fact, fact→projection/integration, quarantine lineage, stale leases, schema/config drift and impossible-state findings. Sensitive values are absent.

**Pass at controlled drain:** every receipt has one terminal materialized/quarantined outcome and every intended event has one/no fact according to oracle. **Fail:** unexplained finding or reconciler misses a planted impossible state.

### E15-14 — backup/restore and readiness hold

```powershell
dotnet run --project tools/Uam.G8.Cli -- restore drill \
  --profile-id <BACKUP_RESTORE_PROFILE_ID> \
  --scenario receipt-fact-quarantine-points \
  --evidence <EVIDENCE_DIR>/e15-14
```

**Must produce:** backup/log/archive IDs and verified status, restore-point configuration, service readiness timeline, missing/extra receipt/fact/quarantine set, endpoint replay result, database integrity/domain verification and destroyed-copy cleanup receipt.

**Pass:** no service readiness before reconciliation; safe exact replay restores or explicitly classifies every missing item; zero duplicate fact. **Fail:** automatic readiness, invented custody or unexplained acknowledged loss.

### E15-15 — migration and version compatibility

```powershell
dotnet run --project tools/Uam.G8.Cli -- migration matrix \
  --profile-id <ENGINE_PROFILE_ID> \
  --from <N_SCHEMA_AND_CONSUMER> \
  --to <N_PLUS_1_SCHEMA_AND_CONSUMER> \
  --faults every-step \
  --evidence <EVIDENCE_DIR>/e15-15
```

**Must produce:** expand/backfill/contract ledger, N/N+1 reader/writer matrix, rollback result, schema hashes, old/new batch/event corpus results and no-startup-DDL evidence.

**Pass:** declared horizon works; unsupported versions quarantine explicitly; migration is resumable and rollback-safe. **Fail:** receipt/data loss, silent coercion, destructive startup migration or undeclared incompatibility.

### E15-16 — privacy-safe observability and support

```powershell
dotnet run --project tools/Uam.G8.Cli -- diagnostics verify \
  --catalogue <DIAGNOSTIC_CATALOGUE_DIGEST> \
  --canaries <CANARY_REGISTRY_DIGEST> \
  --profile-id <OBSERVABILITY_PROFILE_ID> \
  --evidence <EVIDENCE_DIR>/e15-16
```

**Must produce:** static analyzer mutation results, runtime sink inventory, all-sink canary scan, theoretical/observed metric series, redacted support/reconciliation bundle and blind-support scorecard for receipt/lease/quarantine/restore cases.

**Pass:** zero escape/dynamic cardinality and support solves the named T1 set. **Fail:** raw/body/identifier leak, arbitrary collector or necessary failure undiagnosable without an unapproved bypass.

### E15-17 — engine-neutral benchmark and cost inputs

```powershell
dotnet run --project tools/Uam.G8.Cli -- benchmark run \
  --workload <T1_WORKLOAD_MANIFEST> \
  --fault-plan <T1_FAULT_PLAN> \
  --profile-id <ENGINE_PROFILE_ID> \
  --evidence <EVIDENCE_DIR>/e15-17
```

**Must produce:** exact workload distribution, hardware/VM/service class, receipt/materialization/projection/integration rates and latency distributions, DB CPU/I/O/log/lock/version-cleanup, connection/worker/memory, backup/restore/reconciliation, storage growth and human cost/licensing input template.

**Pass:** primary invariants pass. Performance/cost values are inputs to Prompt 16/engine decision, not a production pass here. **Fail:** any primary invariant failure invalidates performance results.

### E15-18 — broker break-even falsifier

```powershell
dotnet run --project tools/Uam.G8.Cli -- architecture evaluate-broker-trigger \
  --relational-evidence <EVIDENCE_DIR>/e15-17 \
  --requirements <APPROVED_REQUIREMENT_RECORD_OR_DISABLED> \
  --output <EVIDENCE_DIR>/e15-18/broker-trigger.json
```

**Must produce:** each trigger category as `NOT_APPLICABLE`, `NOT_MET`, `MET` or `UNKNOWN`; approved requirement reference; relational tuning attempted; estimated broker topology/cost/security/operations comparison inputs; ADR eligibility only, never auto-selection.

**Pass:** broker remains absent unless at least one approved trigger is reproducibly `MET` and all comparison inputs exist. **Fail:** popularity/endpoint count/throughput alone enables broker or a broker dependency already exists.

### E15-19 — aggregate G8 gate

```powershell
dotnet run --project tools/Uam.G8.Cli -- gate evaluate \
  --gate g8-relational-inbox \
  --evidence-root <EVIDENCE_DIR> \
  --output <EVIDENCE_DIR>/g8-gate.json
```

The aggregator is a pure strict validator. It cannot execute repairs or accept a hand-edited `pass` field.

```text
G8_TECHNICAL_PASS =
    E15_00_TO_E15_16_REQUIRED_PASS
    AND PRIMARY_INVARIANT_FAILURE_COUNT = 0
    AND FORBIDDEN_CANARY_ESCAPE_COUNT = 0
    AND CROSS_REALM_RESULT_COUNT = 0
    AND STALE_LEASE_COMMIT_COUNT = 0
    AND UNBOUNDED_POISON_RETRY_COUNT = 0
    AND UNEXPLAINED_RECEIPT_RECONCILIATION_COUNT = 0
    AND CLEANUP_FAILURE_COUNT = 0
    AND BLOCKING_ADR_COUNT = 0
    AND REQUIRED_OWNER_FUNCTION_COUNT_WITHOUT_ASSIGNMENT = 0
    AND EVIDENCE_UNEXPIRED = true
```

The pass artifact MUST state:

```json
{
  "gate": "g8-relational-inbox",
  "technicalPass": true,
  "productionEngineSelected": false,
  "productionDurabilityApproved": false,
  "endpointCleanupAuthorized": false,
  "productionApproved": false
}
```

## 11.3 Exact evidence directory contract

```text
<evidence-root>/
  manifest.json
  files.sha256
  source-and-toolchain.json
  database-profile.json
  fixture-root.json
  oracle-root.json
  canary-result.json
  first-failures.ndjson
  experiments/
    e15-00/...
    ...
    e15-19/...
  invariant-results/
  query-plans/
  lock-and-transaction-evidence/
  restore-and-reconciliation/
  redaction-report.json
  cleanup-receipt.json
  g8-gate.json
```

The manifest records classification, owner functions, expiry, commands by stable ID, environment/profile digests, evidence hashes and restricted-artifact deletion. Raw packet captures, database files, transaction logs, dumps or payloads that a destructive T1 lab temporarily needs remain inside the isolated lab and are deleted/reverted after sanitized evidence is approved.

---

# 12. ADR proposals

No accepted-baseline change proposal is required. The recommendations preserve the accepted relational inbox, no-default-broker, receipt-custody, authenticated-realm, modular-monolith and engine-benchmark decisions. A future implementation finding that requires receipt before relational commit, payload-derived realm, partial silent materialization, a broker as default, or changed replay identity must open the full predecessor change-proposal process.

| ADR | Decision | Proposed status | Alternatives | Rationale/evidence | Accountable owner function | Review trigger |
|---|---|---|---|---|---|---|
| ADR-15-001 | The acceptance boundary is one relational transaction containing immutable batch metadata, exact wire payload and immutable custody receipt | **Accept logical architecture; G8 CLI gate open** | broker receipt, object-store-first, parse-first acceptance | smallest composition of A15-01–10; P15-01/E15-04 falsifies | Ingestion/Data Reliability | any failure to make receipt transaction short/durable or new failure-domain requirement |
| ADR-15-002 | A receipt means `DURABLY_RECEIVED` in an explicit durability class only; validation/materialization/integration/visibility remain separate | **Accept** | overloaded success receipt | prevents endpoint cleanup/portal ambiguity; RFC/contract evidence | Contract Authority/Data Reliability | durability class, endpoint cleanup or state vocabulary change |
| ADR-15-003 | Direct origin mTLS/L4 pass-through is the initial identity path; server creates immutable `AuthenticatedDeviceContext` | **Accept predecessor application** | L7 forwarding header, payload realm, API key | preserves realm/credential authority; Batch 03 dependency | Identity/Security Architecture | gateway/network topology change or direct path failure |
| ADR-15-004 | Conditional L7 requires full header stripping, backend mTLS and short-lived request-bound signed assertion bound to wire digest and authenticated identity | **Deferred/conditional** | plain XFCC/proxy headers | prevents spoof/replay/confused deputy; requires separate parser/performance gate | Gateway/Security | approved L7 requirement and E15-03/12 equivalent tests |
| ADR-15-005 | UAM uses a wire digest over exact compressed bytes and a batch-content digest over exact decompressed canonical contract bytes | **Accept** | one digest, parsed-object hash, server recanonicalization | distinguishes exact replay/custody from logical contract identity | Contract Authority/Ingestion | encoding/canonicalization/content-coding change |
| ADR-15-006 | Same batch ID + same content and wire hashes replays original receipt; any hash difference is an immutable conflict | **Accept** | last-write wins, new receipt, server-generated replacement ID | stable endpoint sealed identity and safe ambiguous response recovery | Ingestion/Data Correctness | hash algorithm/profile change or collision/false-conflict evidence |
| ADR-15-007 | Store exact content-coded payload bytes in the relational database for the first implementation | **Accept for G8; production retention/storage still open** | parsed-only, object store, dual storage | one transaction/failure domain and exact replay; simplest proof | Data Platform/Ingestion | measured DB log/storage/backup cost or independent failure-domain requirement |
| ADR-15-008 | The initial semantic unit is the whole batch: all new effects and terminal state commit atomically or the batch quarantines | **Accept first slice** | per-event partial terminal states | keeps receipt→one terminal outcome and retry semantics small | Materialization/Data Correctness | measured poison amplification/large heterogeneous batches justify versioned split contract |
| ADR-15-009 | Worker processing separates short claim transaction, parse/plan outside transaction and short fenced final transaction | **Accept** | hold row/transaction while parsing, destructive dequeue | contains locks/worker death and permits stale-token fence | Materialization/Database Engineering | engine limitation or E15-07/08 failure |
| ADR-15-010 | Leases use database time, random token, monotonic lease version, expiry and affected-row fencing; heartbeat values are measured | **Accept mechanism; defer values** | host clock, owner ID only, advisory lock only | stale worker cannot commit; engine parity tests | Materialization/SRE | clock/topology/queue design change or hot-row cost breach |
| ADR-15-011 | Event idempotency is unique `(realm_id,event_id)` with immutable effect hash; same hash no-op, changed hash terminal conflict | **Accept** | payload hash as ID, upsert overwrite, version in natural identity | composes endpoint stable ID and one-effect invariant | Data Correctness/Contract Authority | approved correction/supersession design or source identity change |
| ADR-15-012 | Typed immutable facts are authoritative; generic JSON is not the normal fact model | **Accept** | generic event/fact JSON, mutable current row | stronger schema/privacy/query/provenance boundaries | Data Architecture/Data Owner | new approved extension domain that cannot be typed economically |
| ADR-15-013 | Projection work and integration outbox are inserted in the materialization transaction; workers are idempotent and network stays outside | **Accept** | synchronous aggregate/integration call, DB trigger send | prevents lost work and network-coupled fact transactions | Data Platform/Integration | projection/integration contract changes or capacity evidence |
| ADR-15-014 | Quarantine is an explicit terminal batch state with immutable occurrence history and metadata-first tooling | **Accept** | infinite retry, delete poison, free-form dead-letter UI | recoverable custody, supportability and audit | Data Governance/Operations | schema horizon, retention/access or partial-batch decision change |
| ADR-15-015 | Reprocess creates a new processing generation under a finite authorized command and durable privileged audit; history is never erased | **Accept logical model; production authority open** | direct DML, in-place reset, arbitrary script | preserves provenance and realm/audit boundaries | Data Governance/Security/Operations | correction/purge/audit technology decision |
| ADR-15-016 | Realm isolation uses authenticated context, typed scope, composite keys, least-privilege roles and optional RLS/security policy as defense in depth | **Accept** | RLS alone, separate DB per realm, payload tenant ID | layered containment and engine neutrality | Security/Data Platform | realm model change, cross-realm test failure or required physical isolation |
| ADR-15-017 | Queue fairness uses bounded realm admission and an explicit realm-aware scheduler; exact quotas/weights are human/measurement inputs | **Accept principle; defer policy/values** | global oldest-first, one queue per realm | noisy-neighbor containment without table explosion | Product/SRE/Materialization | approved service tiers or capacity evidence |
| ADR-15-018 | Reconciliation is read-only by default and mandatory before readiness after restore; repair uses finite audited operations | **Accept** | integrity check only, automatic destructive repair | receipts can outlive restore point; no invented custody | Data Reliability/Security | restore/RPO/deletion design change |
| ADR-15-019 | PostgreSQL and SQL Server implement the same logical contracts/fault suite; production engine is not selected here | **Accept evaluation process** | choose by familiarity or synthetic throughput | accepted baseline plus missing benchmark/restore/cost evidence | Architecture/DB/SRE | completed identical G8/capacity/restore/cost decision |
| ADR-15-020 | No external broker initially; eligibility requires an approved measured break-even trigger and full replacement comparison | **Accept** | broker by default, shadow queue | accepted baseline and smaller failure/operations surface | Architecture/SRE/Security/Finance | one trigger in section 4.4 reproducibly met |
| ADR-15-021 | API/worker observability uses a release-owned finite catalogue; no bodies, headers, cert fields, realm/batch/event/site IDs or free-form exception data | **Accept** | generic auto-instrumentation/logging | privacy/cardinality containment and predecessor diagnostic rules | Observability/Privacy/Security | new signal/backend/library or support gap |
| ADR-15-022 | Schema changes use explicit migrator authority, schema digest and expand/backfill/contract compatibility; no destructive application-startup migration | **Accept** | ORM auto-migrate/drop-recreate | receipt/fact availability and rollback safety | Database Engineering/Release | every schema/index/engine upgrade |
| ADR-15-023 | Production payload cleanup remains disabled until receipt failure domain, RPO, retention/hold, restore and endpoint replay decisions pass | **Accept conservative boundary** | delete after HTTP 2xx or materialization | prevents irreversible loss from premature semantics | Data Reliability/Records/Product Risk | HD15-01/06 and later deletion/restore gate |
| ADR-15-024 | OSS messaging/queue frameworks are reference-only unless a dependency admission spike proves lower total risk without weakening UAM contracts | **Accept** | immediate MassTransit/CAP/Brighter/Wolverine/pg-boss adoption | broader authority, licensing/maintenance and threat-model mismatch | Dependency Security/Architecture | candidate-specific admission result or maintenance/licensing change |

## 12.1 ADR acceptance dependencies

Before an ADR above may be marked `Accepted` for implementation rather than architecture intent:

- its accountable owner function is assigned;
- its contract/schema and invalid vectors exist;
- its named G8 falsifier passes for every engine/topology claimed;
- dependencies and database builds are exact and admitted;
- security/privacy/realm/observability tests pass;
- migration/rollback/cleanup and support runbooks exist;
- no conflicting predecessor ADR remains unresolved;
- every numerical value is still labeled estimate/experiment/human decision until measured and approved.

ADR-15-004, 015, 017, 019, 020 and 023 retain explicit conditional or human-decision gates even after the logical architecture is implemented.

---

# 13. Ordered implementation backlog with dependencies and stop gates

## 13.1 Critical path

| Order | Backlog item | Dependencies | Repository deliverable | Stop gate |
|---:|---|---|---|---|
| 1 | Record the seven-file evidence manifest, public-source register and Prompt 15 result digest | none | `docs/evidence/p15-inputs.json`, result hash, allowlist test | missing/extra project input or hash mismatch |
| 2 | Create ADR-15-001 through ADR-15-024 and the HD15 decision records | 1 | ADR/decision files with owner/review trigger/disabled default | implementation cannot silently choose an open human/security decision |
| 3 | Add G8 project/module boundaries and architecture guards | Batch 01 repo rules, 2 | API/domain/store-worker/projection/integration/reconciler/test projects | forbidden dependency/API/logging/broker/test-hook mutation survives |
| 4 | Freeze strict ingestion/receipt/problem/lookup contracts and canonical vectors | Batch 01 contracts, Batch 03 receipt identity, 2–3 | local schemas, valid/boundary/invalid/old-new vectors, catalogue entries | ambiguous identity/digest/receipt semantics or unassigned contract owner |
| 5 | Implement purpose-specific scalar types and immutable authenticated context adapter | 4 | realm/install/batch/event/receipt/hash/lease wrappers and analyzers | raw interchangeable strings or payload/header realm authority |
| 6 | Implement deterministic T1 contract emulator, poison corpus, canaries and independent oracle | G0 foundations, 4–5 | `Uam.G8.ContractEmulator`, truth ledger, mutation tests | nondeterminism, real value, common decision code or canary miss |
| 7 | Define engine-neutral domain state machines and repository ports | 4–6 | batch/receipt/lease/quarantine/dedupe/fact/projection/outbox models | state permits receipt without custody, stale commit, partial silent terminal or cross-realm key |
| 8 | Author logical DDL and executable domain verifier | 7 | schemas/constraints/index contract and invalid-state fixtures | realm-less key, mutable receipt/payload, weak uniqueness or missing terminal constraints |
| 9 | Implement PostgreSQL adapter with explicit SQL/transactions | 8 | captured claim/receipt/final/reconcile SQL and plans | hidden ORM queue behavior, unbounded query or undocumented lock assumption |
| 10 | Implement SQL Server adapter with explicit SQL/transactions | 8 | equivalent captured SQL/plans/hints/transactions | semantic divergence, unsafe lock/read pattern or unsupported edition/profile |
| 11 | Implement read-only schema/config/role/security-policy verifier for both engines | 9–10 | startup/CLI verifier and schema digest | drift accepted or application startup performs destructive migration |
| 12 | Implement direct test-mTLS identity boundary and header-stripping/route middleware | 4–6 | immutable `AuthenticatedDeviceContext`, hostile header vectors | body/route/header/cert subject supplies realm or stale status soft-allows |
| 13 | Implement bounded streaming request reader and dual digests | 4, 6, 12 | gzip-only T1 reader, limits/cancellation/digest vectors | request-decompression middleware hides compressed-byte limit or logs raw data |
| 14 | Implement receipt transaction and exact replay/conflict behavior | 7–13 | API/inbox writer and receipt lookup | response before commit, partial custody, changed-ID fallback or mutable conflict behavior |
| 15 | Implement receipt transaction deterministic fault hooks in test build | 14 | hook schedule/controller and production absence test | hook/control route in production or first fault invariant failure |
| 16 | Implement realm-aware admission and scheduler model | 7, 9–10 | bounded per-realm admission/selection abstraction | global oldest-first is the only path or cross-realm cache/key risk |
| 17 | Implement claim/heartbeat/reclaim/fence adapters using DB time | 9–10, 16 | worker lease API and captured affected-row rules | stale worker can extend/commit, parsing occurs in claim tx, or engine semantics diverge |
| 18 | Implement strict batch/event parser and deterministic materialization planner | 4–7 | parser/semantic result taxonomy and no-DB plan | unsupported schema coerced, generic deserialization, arbitrary handler/plugin or unbounded input |
| 19 | Implement event dedupe and typed first fact schema for fictional Edge site/domain slice | 7–10, 18 | `event_dedupe`, typed `edge_site_activity_fact`, provenance | event natural key includes processing version or fact permits mutable overwrite |
| 20 | Implement whole-batch fenced final transaction | 17–19 | dedupe/fact/projection-work/integration-outbox/terminal commit | partial sibling state, network in tx, missing lease fence or terminal without effects |
| 21 | Implement terminal quarantine occurrence and finite error taxonomy | 18–20 | reason catalogue, occurrence/history tables, metadata DTO | infinite retry, raw payload UI/log, silent delete/coercion |
| 22 | Implement retry classifier/backoff with bounded attempts and kill switches | 17–21 | retry state transitions/config profile | hot loop, unknown default retry forever or terminal poison retried |
| 23 | Implement governed reprocess command model and transactional audit outbox | 21–22, HD15-08 prototype scope | new processing generation, auth negatives and audit | arbitrary SQL/script, in-place erase, wrong realm/role or missing audit |
| 24 | Implement projection contribution ledger/worker and rebuild verifier | 19–20 | projection work/contribution/aggregate T1 model | fact mutation or retry double count |
| 25 | Implement integration outbox and hostile downstream stub | 19–20 | stable message/attempt/terminal model | direct network in fact tx, dynamic destination or new ID after response loss |
| 26 | Implement privacy-safe diagnostic catalogue/analyzers/metric cardinality lint | 3–25 | generated wrappers, safe problem/health metrics | free-form logs/exceptions/body/header/cert/ID labels or canary escape |
| 27 | Implement read-only reconciler and closed operational CLI | 8–26 | receipt/fact/quarantine/projection/outbox/schema/realm checks | general SQL/raw export/destructive default or planted impossibility missed |
| 28 | Implement explicit migrations and N/N+1 compatibility harness | 8–27 | expand/backfill/contract migrations and failure hooks | destructive startup migration, unreadable rollback or schema-horizon coercion |
| 29 | Implement exact test evidence/failure-capsule/cleanup formats and production-hook absence | 6, 15, 20–28 | `Uam.G8.Evidence`, gate schemas, cleanup verifier | first failure overwritten, cleanup optional or restricted artifact exported |
| 30 | Run E15-00 through E15-10 against PostgreSQL candidate | 1–29 | contract/schema/receipt/lease/materialization/quarantine evidence | any primary failure stops later PG work and engine comparison |
| 31 | Run E15-00 through E15-10 against SQL Server candidate | 1–29 | identical evidence | semantic test suite differs or any primary failure |
| 32 | Run projection/integration/observability/reconciler suites on both engines | 24–31 | E15-11, E15-13, E15-16 evidence | double count/send, raw leak, cross-realm or reconciler miss |
| 33 | Provision approved engine-native failover/backup/restore T1 profiles | human lab/DB authority, 30–32 | sanitized topology/profile records | connection/credential/address enters evidence or failure domain unclear |
| 34 | Run API/worker/DB kill, failover and restore drills on both engines | 33 | E15-12/E15-14 evidence | missing/duplicate receipt/fact, premature readiness or cleanup failure |
| 35 | Run schema migration/version matrix on both engines | 28, 34 | E15-15 evidence | receipt/fact loss, incompatible declared horizon or rollback trap |
| 36 | Run identical engine-neutral workload/fault benchmark | 30–35 | E15-17 evidence and Prompt 16 inputs | any primary invariant failure invalidates performance comparison |
| 37 | Evaluate broker triggers using approved requirements, if any | 36, HD15-19 | E15-18 result and broker ADR eligibility state | broker package/service introduced before accepted trigger/ADR |
| 38 | Aggregate G8 gate | 1–37 | `g8-gate.json` with explicit false production flags | any missing/expired/failed evidence, owner or cleanup |
| 39 | Architecture/security/data/SRE review of G8 evidence | 38 | ADR status updates and residual-risk record | no downstream capacity/pilot claim from an unreviewed technical pass |
| 40 | Feed exact workload, schema, queries, restore and cost evidence to database/capacity Prompt 16 | 39 | reproducible benchmark package | engine selected from prose or unmatched workloads |
| 41 | Preserve accepted later gate order for long outage, deletion/restore and production approval | global suite order | separate results/ADRs | G8 is not used as deletion, capacity, SLO or production proof |

## 13.2 Parallel work

After steps 4–8, these lanes may proceed in parallel:

- T1 emulator/oracle/poison/canary work;
- PostgreSQL and SQL Server DDL/adapter prototypes;
- identity/header/streaming contract implementation;
- pure lease/fairness/materialization/quarantine models;
- privacy-safe diagnostics and reconciliation schema;
- migration and fault-harness scaffolding.

The following cannot be pulled forward:

- receipt response before receipt transaction fault proof;
- worker/fact implementation before stable event identity and whole-batch state model;
- reprocessing before immutable quarantine lineage and audit command exist;
- integration network calls before transactional outbox exists;
- database failover/restore claim before engine-native topology is explicitly configured and authorized;
- capacity/engine selection before identical functional/fault suites pass;
- broker implementation before a measured trigger and accepted ADR;
- endpoint cleanup, live data, pilot or production based on a G8 lab receipt.

## 13.3 Feature flags and kill switches

Flags are finite release-owned controls and can only disable/narrow. Tenant policy cannot introduce a new processor, schema, SQL, destination, retry algorithm or worker capability.

| Control | Scope | Safe effect | Must not do |
|---|---|---|---|
| `ingestion.accept.enabled` | global/realm/release/schema | reject new requests before body or receipt with safe service state | delete or mutate existing custody |
| `ingestion.contract.<id>.enabled` | contract/schema | stop new custody for affected producer profile | reinterpret already received bytes |
| `materialization.claim.enabled` | global/realm/schema/processor | stop new claims; let final in-flight tx finish/fence | clear leases by direct DML without state rule |
| `materialization.processor.<id>.enabled` | processor/schema | route eligible work to hold/retry/quarantine policy | fall back to another unapproved processor |
| `projection.<id>.enabled` | projection version/realm | stop derived work/visibility cutover | mutate facts |
| `integration.<id>.enabled` | destination contract/realm | stop new sends while retaining outbox | drop messages or redirect destination |
| `quarantine.reprocess.enabled` | processor/realm | reject new reprocess commands | auto-replay all quarantine |
| `payload.cleanup.enabled` | global/realm/receipt class | permit only rows satisfying all approved predicates | bypass retention/hold/restore readiness |
| `broker.path.enabled` | global | remains false until accepted ADR and deployment evidence | shadow dual-write to broker |

Every change is authorized, sequence-monotonic, audited, observable with finite codes, and independently tested for wrong realm, stale revision, rollback and restart behavior.

## 13.4 Definition of implementation-ready G8

G8 is implementation-ready—not production-ready—only when:

1. strict contracts and schemas are frozen for the T1 first slice;
2. both engine adapters implement the same state/transaction semantics;
3. every primary deterministic fault hook passes;
4. real API/worker/database process and engine failover companions pass;
5. poison/quarantine/reprocess and realm-negative tests pass;
6. receipt→terminal and event→fact reconciliation passes after controlled drain and restore;
7. no forbidden canary or cardinality failure exists;
8. runbooks, owner functions, first-failure evidence and cleanup are complete;
9. `g8-gate.json` explicitly says no production engine/durability/cleanup/production approval;
10. downstream capacity research consumes the exact evidence rather than replacing it with assumptions.

---

# 14. Open-source repository assessment table

## 14.1 Assessment method

Repositories are design evidence, not automatic dependencies. The review examined exact tags available on 31 July 2026, relevant source/test/documentation structure, stated license, recent release activity, visible security posture, UAM architectural fit and removal cost. Popularity and README claims such as “exactly once” are not proof of UAM receipt, realm, privacy, restore or business-effect semantics.

No repository below is recommended as a G8 dependency. The initial recommendation is **REFERENCE ONLY** so UAM owns its small custody/lease/quarantine state machine and can test both PostgreSQL and SQL Server identically. A later candidate spike must pass the full dependency-admission, threat, contract, migration, fault, license and removal gates.

## 14.2 Consolidated assessment

| Repository and exact revision | Relevant reviewed areas | License and compatibility | Maintenance, tests and security posture | Similarities and threat-model differences | Reusable ideas | Ideas not to copy | Suitability |
|---|---|---|---|---|---|---|---|
| [MassTransit/MassTransit `v8.5.9`](https://github.com/MassTransit/MassTransit/tree/v8.5.9); outbox documentation at [MassTransit transactional outbox](https://masstransit.io/documentation/configuration/middleware/outbox) | `src/`, `tests/`, persistence and outbox packages, transactional/bus outbox documentation, SQL transport packages | Apache-2.0 for v8 repository; NOTICE/COPYRIGHT present. Official current product messaging states v9 is a commercial release, so lifecycle, support, upgrade and production-license implications must be treated as a material future compatibility concern rather than assuming v8's terms continue | Large test/source estate and a repository `SECURITY.md`; mature active project. The v8/v9 licensing/support transition raises maintenance-horizon and procurement questions for a load-bearing adoption | Similar: transactional outbox, inbox/consumer idempotency, retry and SQL persistence concepts. Different: general distributed message framework, broker/transport abstraction, broad serializers/schedulers/UI/integration surface, and service-to-service message threat model rather than authenticated endpoint custody and strict realm-specific receipts | transaction-scoped outbox, stable message IDs, delivery retry tests, separation of bus outbox from business transaction, transport fault cases | broad message bus/consumer conventions, framework-owned receipt semantics, arbitrary message types/transports, scheduler/dashboard/serialization authority, assuming “exactly once” from middleware | **REFERENCE ONLY.** A dependency would be disproportionate and current-major commercial licensing/support must be evaluated explicitly |
| [dotnetcore/CAP `v10.0.1`](https://github.com/dotnetcore/CAP/tree/v10.0.1) | `src/`, `test/`, `docs/`, `samples/`; local message table/outbox, storage/transport plugins, retry/backpressure, dashboard and consumer groups | MIT. Plugin/transitive licenses and the selected storage/transport packages would require separate review | Active 2026 codebase with tests and multiple providers. No dedicated repository security policy was visible in the reviewed tag UI; a broad dashboard/plugin surface increases review needs. Active issue/release work demonstrates continuing change | Similar: local relational table, transactional publish record, retries, backpressure and manual retry concepts. Different: broker/event-bus-first microservice integration, wildcard topics, customizable filters/serialization, dashboard and service discovery; receipt does not equal UAM endpoint custody | local outbox transaction pattern, status/retry schemas, backpressure tests, provider abstraction lessons, explicit cleanup/retention concerns | wildcard/partial topics, runtime plugins, customizable serializers/filters, built-in dashboard as privileged UAM control, automatic broker dependency, framework migrations without UAM schema proof | **REFERENCE ONLY.** Useful for negative/design comparison; not suitable as the narrow G8 inbox dependency |
| [BrighterCommand/Brighter `10.7.0`](https://github.com/BrighterCommand/Brighter/tree/10.7.0), released 29 July 2026 | `src/`, `tests/`, `benchmarks/`, `docs/`, `specs/`, Docker integration files; inbox/outbox and PostgreSQL/MSSQL packages, service activator and distributed-lock documentation | MIT. Many optional transports/providers and transitives mean an actual package selection still needs exact package-to-source/license/SBOM mapping | Very active release cadence, broad tests, benchmarks and testing guide. The reviewed repository UI did not expose a dedicated security policy; recent release notes include concurrency/outbox fixes, reinforcing the need for exact-version fault tests | Similar: inbox/outbox persistence, sweep/clear workers, distributed lock and PostgreSQL/MSSQL adapters. Different: general command dispatcher/service activator, handler middleware, automatic assembly discovery, brokers and many providers; message handlers are broader authority than UAM's closed processor catalogue | explicit outbox/inbox interfaces, sweeper/clear separation, distributed-lock tests, provider parity questions, benchmark structure, handler retry classifications | automatic handler/assembly discovery, startup provisioning/migration, arbitrary command/event middleware, broker abstraction, general logging/observability defaults, using framework IDs as UAM custody identity | **REFERENCE ONLY.** Best .NET comparison for schema/worker ideas, but adoption would import much more authority and migration surface than G8 needs |
| [JasperFx/wolverine `V6.22.0`](https://github.com/JasperFx/wolverine/tree/V6.22.0); durability documentation at [Wolverine durability](https://wolverinefx.net/guide/durability/) | `src/`, `docs/`, `repro/`, `docker/`, build files; durable inbox/outbox, agents, retries/dead letters, database persistence, multi-tenancy and messaging | MIT. Companion JasperFx packages, optional transports/persistence providers and commercial support arrangements would require a complete dependency/licensing/support inventory | Active July 2026 project with source/docs/repro and substantial integration/performance work. No dedicated repository security policy was visible in the reviewed tag UI; rapid feature/release activity raises qualification cadence | Similar: durable inbox/outbox, idempotent envelopes, database-backed agents, dead-letter/replay and multi-tenancy. Different: broad mediator/message bus, endpoint discovery/handlers, agent leadership, transports, tenant modes and framework-owned schema; not designed around exact compressed custody bytes and receipt failure-domain classes | durability-agent restart tests, dead-letter metadata/replay workflow, envelope IDs, database-backed work coordination, operational health concepts | framework-owned handlers/envelopes as UAM contracts, dynamic endpoint/transport discovery, general dead-letter UI, automatic schema/migration authority, conflating message acknowledgement with UAM receipt | **REFERENCE ONLY.** Strong operational design input; core dependency would obscure the small security-sensitive UAM state machine |
| [timgit/pg-boss `12.26.3`](https://github.com/timgit/pg-boss/tree/12.26.3), released 24 July 2026 | `src/`, `test/`, `docs/`, `packages/`, migration/schema code; PostgreSQL `SKIP LOCKED`, scheduling, retries, maintenance, LISTEN/NOTIFY plus polling | MIT. Node.js/PostgreSQL-only runtime conflicts with accepted C#/.NET and engine-neutral requirements if used as a dependency | Active releases and tests. No dedicated GitHub security policy was visible in the reviewed tag UI. Release `12.26.2` repaired half-open LISTEN/NOTIFY degradation; `12.26.3` repaired a severe saturated-group query-plan regression, valuable evidence that queue fairness/notification/query plans require recurring tests | Similar: PostgreSQL relational queue, `SKIP LOCKED`, retries, concurrency/group fairness, heartbeat/listener recovery and schema drift. Different: Node runtime, PostgreSQL-only, generic job data/scheduling, no UAM receipt/payload/fact/quarantine/realm contract and README exactly-once wording has different scope | queue-claim SQL/test cases, polling backstop for notification loss, heartbeat/reconnect tests, group-concurrency starvation/query-plan regression tests, schema-drift checks | treating LISTEN/NOTIFY as correctness, copying exactly-once wording, generic job payload/cron/scheduling, PostgreSQL-only dependency, automatic self-healing DDL without UAM migration authority | **REFERENCE ONLY.** Highest-value relational lease/fairness test source; not an implementation dependency |

## 14.3 Repository-specific conclusions

### MassTransit

- **Architectural similarity:** its transactional outbox demonstrates why business state and pending transport work belong in one transaction.
- **Threat-model mismatch:** MassTransit assumes an application message framework with many transports and consumer conventions; UAM must first prove immutable endpoint custody, authenticated realm context and one batch terminal outcome.
- **License/maintenance concern:** v8 is Apache-2.0, while the current v9 product line is commercial. Selecting v8 could create an aging-major/support decision; selecting v9 would require procurement and exact commercial terms.
- **Decision:** no dependency. Reuse only tests and conceptual separation.

### CAP

- **Architectural similarity:** local message table, retries and manual failure handling.
- **Threat-model mismatch:** wildcard topics, plugin transports/storage, customizable serialization and a dashboard are larger authority and attack surfaces than G8.
- **Security posture:** active project and tests, but no reviewed dedicated security policy; UAM would need to audit every enabled plugin and dashboard route.
- **Decision:** no dependency or architecture transplant.

### Brighter

- **Architectural similarity:** most direct .NET comparison for inbox/outbox stores, service activator and distributed-lock workers across PostgreSQL/MSSQL.
- **Threat-model mismatch:** command middleware/assembly discovery and broker/service-activator semantics are not UAM's finite closed materializer.
- **Testing quality:** broad tests/benchmarks and active concurrency fixes make it valuable as a hostile comparison and test-idea source.
- **Decision:** reference only; a future spike must prove that a minimal package subset reduces defects and does not own UAM schema, migrations or contracts.

### Wolverine

- **Architectural similarity:** durable inbox/outbox agents, dead-letter/replay and database persistence.
- **Threat-model mismatch:** mediator/message-bus framework, dynamic handler/endpoint/transport surface and framework tenancy/migration model.
- **Operational lesson:** dead-letter state and replay need explicit provenance and operator workflow, but UAM must keep raw payload access and replay authority narrower.
- **Decision:** reference only.

### pg-boss

- **Architectural similarity:** clearest relational-queue/lease/fairness reference for PostgreSQL.
- **Maintenance lesson:** recent half-open notification and query-plan regression fixes prove that notifications, group fairness, statistics and query plans require polling backstops and recurring exact-version tests.
- **Threat-model mismatch:** generic jobs, Node.js and PostgreSQL-only; no typed UAM fact/realm/custody model.
- **Decision:** reference for SQL/fairness/fault cases only.

## 14.4 Dependency reconsideration gate

A repository may become a candidate only when a bounded spike provides all of:

1. exact tag/commit, package and binary mapping;
2. license, notice, commercial-support and future-major terms approved;
3. recent maintenance/advisory and dedicated security-response assessment;
4. package/transitive/SBOM/provenance inventory;
5. minimal enabled surface with plugins, dashboards, dynamic handlers, schedulers and brokers excluded where unnecessary;
6. a mapping from UAM contracts/state/invariants to the dependency without semantic loss;
7. both PostgreSQL and SQL Server support where engine neutrality is still required;
8. all E15 receipt, lease, poison, realm, restore and observability tests, including deterministic hooks or an equivalent independently controllable seam;
9. no general raw-payload or administrative UI exposure;
10. migration/rollback/removal plan that returns to UAM-owned tables/contracts without losing custody/facts;
11. measured lower defect, implementation, operations and support cost than the small owned state machine;
12. an accepted ADR and named operational owner.

Failure of any item leaves the repository `REFERENCE ONLY`.

---

# 15. Source register with stable links, dates, reviewed versions/commits, claims and limitations

## 15.1 Supplied internal sources

| Ref | Source and date | Claim supported | Limitation |
|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md`, baseline 31 July 2026, SHA-256 `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | accepted endpoint/server topology, relational inbox, receipt meaning, no-broker default, realm and durability invariants | condensed baseline, not runtime proof or production/human approval |
| I02 | `04-data-and-schema-evidence-summary.md`, reviewed 31 July 2026, SHA-256 `1ed93b3d60d37da96c1f67e401deb10c9d57736e4f4dbfa26e16760bd2a19ce6` | target data concepts, authenticated realm derivation, distinct custody/validation/materialization/quarantine/visibility states and missing distributions | no representative rates, rows, payloads, retention, RPO/RTO or engine benchmark |
| I03 | `05-decisions-contradictions-and-gates.md`, July 2026 synthesis, SHA-256 `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | relational durable inbox/no broker default, engine decision gate and ordered proof gates | accepted for implementation research, not unconditional production authority |
| I04 | `06-research-evidence-rules.md`, reviewed 31 July 2026, SHA-256 `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | evidence labels, primary-source preference, human decision boundary and change-proposal discipline | research-quality rule, not technical fact |
| I05 | `result-review-01-foundations.md` (local `batch-01-review-result(3).md`), 31 July 2026, SHA-256 `10d5e1e73fa7e63156d29b7cff238ea7d4e128587b47f4c75b` | strict contracts, UUIDv7, canonicalization caveats, receipt state separation, realm isolation and repository controls | predecessor architecture accepted with conditions; exact limits/crypto/runtime still gated |
| I06 | `result-review-02-endpoint-data.md`, 31 July 2026, SHA-256 `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | stable event identity, raw-value boundary, whole-page endpoint atomicity, no automatic reinterpretation and G5 handoff | endpoint topic; no server ingestion runtime evidence |
| I07 | `result-review-03-durability-release-identity.md`, 31 July 2026, SHA-256 `76854c3d6a12b9b717da90d4e368273bd88a672fc64a315afaeacfb3d701a785` | sealed batch/exact bytes, durable attempt and receipt, authenticated device context, direct mTLS default, restore/diagnostic/release constraints | Batch 03 gate open; synthetic/server stub did not prove production inbox/failure domain |

## 15.2 Standards and HTTP/API sources

| Ref | Primary source, date/version reviewed | Claim supported | UAM-specific limitation |
|---|---|---|---|
| W01 | IETF, [RFC 9110 — HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110.html), June 2022 | HTTP method/status/header/content semantics and idempotency terminology | does not define UAM batch identity, receipt custody or proxy trust |
| W02 | IETF, [RFC 9457 — Problem Details for HTTP APIs](https://www.rfc-editor.org/rfc/rfc9457.html), July 2023 | standard problem-response structure | UAM must define finite safe codes and prevent realm/payload disclosure |
| W03 | IETF, [RFC 9530 — Digest Fields](https://www.rfc-editor.org/rfc/rfc9530.html), February 2024 | `Content-Digest` syntax and integrity over HTTP content | integrity is not sender authentication; UAM separately binds canonical batch bytes and authenticated context |
| W04 | IETF, [RFC 9562 — Universally Unique IDentifiers](https://www.rfc-editor.org/rfc/rfc9562.html), May 2024 | UUIDv7 layout and canonical UUID rules | UUID timestamp is not business time, authorization, source order or evidence precision |
| W05 | IETF, [RFC 8785 — JSON Canonicalization Scheme](https://www.rfc-editor.org/rfc/rfc8785.html), June 2020 | deterministic JSON canonicalization constraints and preservation of parsed strings | UAM's endpoint batch contract owns exact bytes; JCS is not permission to normalize Unicode or accept non-I-JSON input |
| W06 | JSON Schema, [Draft 2020-12 Core](https://json-schema.org/draft/2020-12/json-schema-core), December 2020 | structural schema dialect and evaluation model | validator conformance, resource bounds and local-only reference closure require CLI proof |
| W07 | OWASP, [API Security Top 10 — 2023](https://owasp.org/API-Security/editions/2023/en/0x11-t10/), 2023 edition | object/authorization, resource consumption, unsafe consumption and inventory threat categories | high-level risk catalogue, not a UAM control or pass result |

## 15.3 .NET and ASP.NET Core sources

| Ref | Primary source, date/version reviewed | Claim supported | UAM-specific limitation |
|---|---|---|---|
| W08 | Microsoft, [.NET and .NET Core support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), reviewed 31 July 2026; .NET 10.0.10 listed 14 July 2026, LTS through 14 November 2028 | current supported .NET line and lifecycle | point-in-time execution input; exact patch must be revalidated and locked, not embedded as timeless architecture |
| W09 | Microsoft, [Request decompression in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/middleware/request-decompression?view=aspnetcore-10.0), updated 3 July 2026; ASP.NET Core 10.0 | framework decompression providers and request-body integration | documented capability does not prove exact compressed/decompressed/ratio/time/allocation controls; G8 uses an explicitly tested strict streaming reader/profile |
| W10 | Microsoft, [Certificate authentication in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/certauth?view=aspnetcore-10.0), updated 28 April 2026; ASP.NET Core 10.0 | origin certificate authentication mechanics and handler behavior | certificate authentication alone does not create UAM realm/install authority or rapid application-status checks |
| W11 | Microsoft, [Kestrel endpoint and limit options](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel/options?view=aspnetcore-10.0), ASP.NET Core 10.0, reviewed 31 July 2026 | server request/header/body/data-rate/connection limit capabilities | exact safe values and intermediary behavior require G8 measurements and parser-differential tests |
| W12 | Microsoft, [Rate limiting middleware in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/performance/rate-limit?view=aspnetcore-10.0), ASP.NET Core 10.0, reviewed 31 July 2026 | partitioned rate limiting and queue/rejection capabilities | not a realm-fairness proof; identity partition keys and distributed deployment behavior require UAM design/tests |

## 15.4 PostgreSQL sources

PostgreSQL 18.4 is the reviewed stable point. The PostgreSQL site also showed PostgreSQL 19 beta activity on 31 July 2026; a beta is not selected as a production candidate by this result.

| Ref | Primary source, date/version reviewed | Claim supported | UAM-specific limitation |
|---|---|---|---|
| P01 | PostgreSQL, [Release 18.4 notes](https://www.postgresql.org/docs/release/18.4/), released 14 May 2026 | reviewed stable maintenance release and current security/bug-fix context | does not prove UAM driver/topology/operations; exact supported minor must be selected at execution time |
| P02 | PostgreSQL 18, [`INSERT`](https://www.postgresql.org/docs/18/sql-insert.html) | `ON CONFLICT` and `RETURNING` primitives for idempotent insert/read | UAM still needs immutable hash comparison, realm keys, concurrency and fault tests |
| P03 | PostgreSQL 18, [`SELECT`](https://www.postgresql.org/docs/18/sql-select.html) | row locking and `FOR UPDATE ... SKIP LOCKED`; documentation notes skipped rows give an inconsistent view suitable for queue-like access | `SKIP LOCKED` is not authoritative reading, fairness or performance proof |
| P04 | PostgreSQL 18, [Explicit locking](https://www.postgresql.org/docs/18/explicit-locking.html) | row/table lock modes, conflicts and deadlock behavior | actual plans/escalation-equivalent effects, long transactions and workload need measurement |
| P05 | PostgreSQL 18, [Transaction isolation](https://www.postgresql.org/docs/18/transaction-iso.html) | isolation-level behavior and serialization phenomena | UAM selects and tests explicit transaction semantics; isolation names alone do not prove state-machine safety |
| P06 | PostgreSQL 18, [`synchronous_commit`](https://www.postgresql.org/docs/18/runtime-config-wal.html#GUC-SYNCHRONOUS-COMMIT) | commit durability/latency configuration concepts | receipt class depends on complete topology/storage/replication and human RPO choice, not this setting alone |
| P07 | PostgreSQL 18, [Warm standby and streaming replication](https://www.postgresql.org/docs/18/warm-standby.html) | synchronous/asynchronous replication capabilities and failover concepts | documented replication cannot define UAM's approved failure domain or prevent operational/correlated loss |
| P08 | PostgreSQL 18, [Continuous archiving and point-in-time recovery](https://www.postgresql.org/docs/18/continuous-archiving.html) | WAL archiving, base backup and PITR capabilities | backup existence is not verified restore/readiness/receipt reconciliation evidence |
| P09 | PostgreSQL 18, [Row security policies](https://www.postgresql.org/docs/18/ddl-rowsecurity.html) | RLS capabilities and owner/superuser/`BYPASSRLS` caveats | RLS is defense in depth; UAM app/context/composite realm keys remain primary and DB admins remain privileged |
| P10 | PostgreSQL 18, [Table partitioning](https://www.postgresql.org/docs/18/ddl-partitioning.html) | declarative partitioning and lifecycle capabilities | no UAM partition grain is selected without workload/retention/query evidence |
| P11 | PostgreSQL, [PostgreSQL License](https://www.postgresql.org/about/licence/), reviewed 31 July 2026 | permissive PostgreSQL license | hosting, support, extensions, managed service and operational costs remain separate |

## 15.5 SQL Server sources

| Ref | Primary source, date/version reviewed | Claim supported | UAM-specific limitation |
|---|---|---|---|
| S01 | Microsoft, [SQL Server 2025 build versions](https://learn.microsoft.com/en-us/troubleshoot/sql/releases/sqlserver-2025/build-versions), reviewed 31 July 2026; CU7 build 17.0.4065.4 released 16 July 2026 | current reviewed SQL Server 2025 cumulative update point | point-in-time input only; edition, licensing, driver and estate support are not decided |
| S02 | Microsoft, [Table hints](https://learn.microsoft.com/en-us/sql/t-sql/queries/hints-transact-sql-table?view=sql-server-ver17), SQL Server 2025 docs | `UPDLOCK`, `READPAST`, `ROWLOCK` and restrictions; `READPAST` work-queue use and row/page-lock caveats | hints are not portable or fairness proof; exact plan/locks/escalation require E15 tests |
| S03 | Microsoft, [Create unique indexes](https://learn.microsoft.com/en-us/sql/relational-databases/indexes/create-unique-indexes?view=sql-server-ver17), SQL Server 2025 docs | unique-index enforcement for idempotency keys | UAM still verifies effect hashes/realm and conflict behavior transactionally |
| S04 | Microsoft, [Row-level security](https://learn.microsoft.com/en-us/sql/relational-databases/security/row-level-security?view=sql-server-ver17), SQL Server 2025 docs | security predicates/policies and session-context patterns | RLS is secondary containment; elevated principals and context pooling require explicit tests |
| S05 | Microsoft, [Transaction locking and row versioning guide](https://learn.microsoft.com/en-us/sql/relational-databases/sql-server-transaction-locking-and-row-versioning-guide?view=sql-server-ver17), SQL Server 2025 docs | locking, escalation, row versioning and isolation behavior | exact queue/final-transaction semantics and resource cost require captured plans/locks/fault tests |
| S06 | Microsoft, [Always On availability modes](https://learn.microsoft.com/en-us/sql/database-engine/availability-groups/windows/availability-modes-always-on-availability-groups?view=sql-server-ver17), SQL Server 2025 docs | synchronous/asynchronous commit modes and availability behavior | does not choose or prove UAM failure domain/RPO; failover and replica health are operational evidence |
| S07 | Microsoft, [Point-in-time restore](https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/restore-a-sql-server-database-to-a-point-in-time-full-recovery-model?view=sql-server-ver17), SQL Server 2025 docs | full-recovery point-in-time restore mechanics | no UAM restore readiness without receipt/fact/quarantine/deletion reconciliation |
| S08 | Microsoft, [SQL Server backup and restore](https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/back-up-and-restore-of-sql-server-databases?view=sql-server-ver17), SQL Server 2025 docs | backup/restore concepts and recovery models | actual verified restore, cost, encryption, retention and operations are human/CLI gates |
| S09 | Microsoft, [SQL Server licensing resources](https://www.microsoft.com/en-us/licensing/product-licensing/sql-server), reviewed 31 July 2026 | licensing is commercial and edition/deployment dependent | exact terms, costs and rights require Legal/Procurement; this is not legal advice or a selection |

## 15.6 Open-source repository sources

| Ref | Repository/release reviewed | Claim supported | Limitation |
|---|---|---|---|
| O01 | [MassTransit `v8.5.9`](https://github.com/MassTransit/MassTransit/tree/v8.5.9), Apache-2.0; `src`, `tests`, `SECURITY.md`; reviewed 31 July 2026 | mature .NET messaging/outbox reference and visible tests/security policy | v9 is a current commercial product line; broader framework/transport threat model and license/support horizon differ |
| O02 | MassTransit official [transactional outbox documentation](https://masstransit.io/documentation/configuration/middleware/outbox), reviewed 31 July 2026 | bus/consumer outbox design patterns | documentation describes MassTransit semantics, not UAM custody/receipt/fact guarantees |
| O03 | [CAP `v10.0.1`](https://github.com/dotnetcore/CAP/tree/v10.0.1), MIT; `src`, `test`, `docs`, `samples`; reviewed 31 July 2026 | local message table/outbox, retries/backpressure/provider ideas | broker/plugin/dashboard/wildcard/general serialization surface; no automatic dependency approval |
| O04 | [Brighter `10.7.0`](https://github.com/BrighterCommand/Brighter/tree/10.7.0), MIT; released 29 July 2026; `src`, `tests`, `benchmarks`, `docs`, `specs` | current .NET inbox/outbox/provider/service-activator reference with active tests/benchmarks | command/broker/middleware/assembly-discovery surface and rapid fixes require exact-version qualification |
| O05 | [Wolverine `V6.22.0`](https://github.com/JasperFx/wolverine/tree/V6.22.0), MIT; `src`, `docs`, `repro`, `docker`; reviewed 31 July 2026 | durable inbox/outbox, database agents, dead-letter/replay and operations ideas | broad mediator/message-bus/tenant/migration surface and different receipt model |
| O06 | Wolverine official [durability documentation](https://wolverinefx.net/guide/durability/), reviewed 31 July 2026 | framework durability and inbox/outbox concepts | not normative for UAM and not independent runtime proof |
| O07 | [pg-boss `12.26.3`](https://github.com/timgit/pg-boss/tree/12.26.3), MIT; released 24 July 2026; `src`, `test`, `docs`, `packages` | PostgreSQL queue, `SKIP LOCKED`, fairness/group concurrency, maintenance and notification/polling test ideas | Node/PostgreSQL-only generic jobs; README exactly-once scope differs from UAM business effects |
| O08 | pg-boss [release history](https://github.com/timgit/pg-boss/releases), reviewed 31 July 2026 | 12.26.2 fixed half-open LISTEN/NOTIFY recovery and 12.26.3 fixed severe group-concurrency query-plan regression | release anecdotes are design/test warnings, not proof of UAM or a dependency recommendation |

## 15.7 Source-quality conclusions

1. **FACT.** HTTP, ASP.NET, PostgreSQL and SQL Server documentation establishes primitives and configuration semantics, not UAM composition fitness.
2. **FACT.** PostgreSQL 18.4 and SQL Server 2025 CU7 are point-in-time reviewed versions as of 31 July 2026. Exact supported builds must be rechecked and recorded when G8 executes.
3. **RECOMMENDATION.** Queue statements, indexes and plans must be captured from the actual driver/engine/configuration. An ORM or framework claim is not accepted evidence.
4. **RECOMMENDATION.** Engine HA/backup documentation cannot define the receipt failure domain. Only approved configuration plus failover/restore/reconciliation evidence can support that claim.
5. **RECOMMENDATION.** Open-source frameworks remain reference-only because their contracts, authority and threat models are broader than UAM. Exact tags/licenses/tests do not prove fit.
6. **RECOMMENDATION.** Mutable branch links, search snippets, popularity, stars, downloads and synthetic throughput are not load-bearing sources.
7. **RECOMMENDATION.** Every dependency/database/runtime update reopens source/advisory review and every affected receipt, parser, lease, materialization, restore and observability lane.

---

# 16. Confidence table for every major conclusion

Confidence describes the strength of the architecture conclusion, not production readiness. A **High** conclusion may still require G8 execution because documentation and reasoning do not prove the composed implementation, engine topology or operations.

| Major conclusion | Confidence | Why | Evidence that would change it |
|---|---|---|---|
| One short relational transaction should own batch metadata, exact wire payload and receipt | **High** | directly composes accepted custody/idempotency/no-broker invariants and gives one falsifiable durability boundary | a G8 engine/provider limitation or measured independent failure-domain requirement showing an alternative has lower total risk without weakening receipt semantics |
| Receipt must remain distinct from semantic validation/materialization/integration/visibility | **High** | explicit accepted predecessor decision and necessary to contain poison/reference outages | no expected ordinary evidence; changing it would require an accepted-baseline change proposal and endpoint migration |
| Direct mTLS/L4 and server-created authenticated context is the correct initial identity path | **High** | accepted Batch 03 architecture and smallest header-spoof surface | a required gateway topology that cannot preserve client identity directly and a signed request-bound L7 profile that passes equivalent tests |
| Plain forwarded certificate/realm headers are insufficient authority | **High** | public requests can spoof them without a fully trusted stripping/authenticated path | no reasonable evidence should weaken this; only an independently authenticated bounded assertion preserves the rule |
| Dual wire and canonical-content hashes are required | **High** | exact replay bytes and logical batch bytes answer different integrity/idempotency questions | a new versioned encoding/content-coding contract proving one digest covers both without recomputation ambiguity |
| Same batch ID/same hashes should return the original receipt; changed hash is conflict | **High** | stable endpoint sealed identity makes ambiguous response loss idempotent; overwrite would corrupt custody | hash/canonicalization false-conflict evidence requiring an explicit contract migration, not last-write wins |
| Exact content-coded payload should be stored relationally in the first implementation | **Medium-High** | simplest one-transaction proof and replay/audit evidence | benchmark/backup/log cost or approved independent failure-domain requirement showing object storage with an atomic receipt protocol is safer/cheaper |
| API should perform only cheap safety/custody validation before receipt | **High** | prevents reference/semantic poison from holding acceptance and preserves narrow receipt meaning | proof that a specific semantic check is necessary to prevent unsafe custody and remains bounded/stable without changing receipt semantics |
| Whole-batch atomic materialization is the conservative first semantic boundary | **Medium-High** | smallest one-receipt/one-terminal model and avoids partial replay/correction complexity | measured poison amplification or batch-size heterogeneity plus a versioned per-event terminal contract that passes equivalent recovery tests |
| Claim, parse and final commit must be separate transaction phases | **High** | avoids long locks while still fencing stale workers and atomically committing effects | an alternative engine-native primitive proving equivalent fault/lock behavior with lower complexity |
| Database-time lease token/version/expiry fencing is required | **High** | owner strings/host clocks cannot safely reject a resumed stale worker | a formal/real-fault proof of another fencing mechanism across both engines and failover |
| Exact lease, heartbeat and retry values remain measurements | **High** | no rate/latency/worker/outage distribution or SLO exists | completed G8/capacity workload and accountable SRE/Product decision |
| Unique `(realm_id,event_id)` plus immutable effect hash is the correct event idempotency key | **High** | follows accepted endpoint stable event ID and one-business-effect invariant | an approved correction/supersession model that explicitly changes identity semantics with migration evidence |
| Same event ID/different hash should quarantine, not overwrite | **High** | overwrite destroys provenance and lets producer bugs/compromise mutate accepted history | approved immutable correction facts/supersession contract; original still cannot be silently overwritten |
| Typed facts should be authoritative and immutable | **High** | stronger constraints, provenance, privacy and rebuild than generic mutable JSON | a defined extensible domain where typed modeling is impractical and a bounded non-authoritative extension contract passes tests |
| Projection and integration work belong in the fact materialization transaction | **High** | prevents lost derived work while keeping network asynchronous | a proved alternative transactional mechanism with equal reconciliation/restore behavior |
| Projection contribution ledger is the right idempotency model for aggregates | **Medium-High** | supports retry and rebuild from facts | measured aggregate hot-key/cost evidence and a different deterministic projection engine with equal audit/rebuild semantics |
| Quarantine must be explicit, terminal and immutable | **High** | avoids infinite retry/silent drop and preserves custody/recovery | no ordinary change; a future partial-event model may change granularity, not the need for explicit terminal evidence |
| Reprocess must create a new processing generation and durable audit | **High** | preserves prior failure evidence and prevents arbitrary replay/in-place reset | an approved correction workflow with equivalent immutable lineage and audit |
| Realm isolation must be layered; RLS alone is insufficient | **High** | PostgreSQL and SQL Server privileged bypass/context caveats plus accepted authenticated-context invariant | a physical-isolation requirement may add controls but would not justify payload realm or RLS-only authority |
| Per-realm admission/fair scheduling is necessary | **Medium-High** | multi-realm noisy-neighbor risk is direct; exact policy is unknown | workload showing global queue naturally meets approved fairness, or approved per-realm physical isolation |
| Reconciler must be mandatory and read-only by default | **High** | receipts, retries, restore and derived work need independent proof; destructive auto-repair can invent state | a formally verified storage system might reduce checks, but restore/custody reconciliation remains necessary |
| Restore must remain unavailable until receipt/fact/quarantine readiness passes | **High** | a valid DB restore can be behind issued receipts or resurrect derived state | approved architecture that guarantees restore point contains every receipt and deletion state, proved by drills; readiness checks still likely needed |
| PostgreSQL and SQL Server can implement the logical design | **Medium-High** | both document unique constraints, queue-lock primitives, transactions, HA and restore | G8/failover/restore or query-plan evidence showing one cannot meet primary invariants/operational constraints |
| PostgreSQL is not yet the production selection | **High** | no identical UAM benchmark, restore, cost, skills or support evidence | completed Prompt 16 decision with human operations/licensing approval |
| SQL Server is not yet the production selection | **High** | same missing evidence plus edition/licensing/HA choices | same completed decision evidence |
| No external broker is needed for the first implementation | **High** | accepted baseline, relational receipt boundary and no approved unmet requirement | one explicit section 4.4 trigger reproducibly met and a broker comparison passing all semantics/security/operations tests |
| Frameworks reviewed should remain reference-only | **Medium-High** | broader authority/threat model, migration/observability surface and lifecycle/licensing concerns relative to small UAM state machine | bounded dependency spike proving materially lower defects/cost while preserving contracts, realm, engine parity, hooks and removal path |
| Privacy-safe finite observability is sufficient for the G8 named support set | **Medium** | predecessor diagnostics design and proposed blind-support tests; no exercise has run | failed blind-support exercise that cannot be solved by an additional finite safe signal; support promise must narrow rather than expose raw data by default |
| G8 can prove custody/idempotency state-machine behavior | **Medium-High** | detailed deterministic and real-fault plan exists | harness/model common-mode defect, engine behavior or cleanup failure discovered during execution |
| G8 cannot approve production failure domain, capacity, retention, SLOs or engine | **High** | explicitly absent human decisions and representative measurements | only later evidence plus accountable human decisions can change those statuses |

## 16.1 Conditions that would require an explicit accepted-baseline change proposal

A prototype finding requires the predecessor change-proposal form—not a local workaround—if it asserts any of the following is necessary:

- issue a receipt before relational durable custody commits;
- derive realm/install authority from payload, route, certificate subject or untrusted proxy header;
- let endpoints submit SQL or database credentials;
- remove exact stable batch/event identity or allow replay to create multiple ordinary effects;
- partially materialize a batch without a new versioned terminal/ACK contract;
- allow raw endpoint-forbidden values into ingestion diagnostics/support;
- make a broker the default receipt boundary;
- silently drop unacknowledged/received payload under pressure;
- treat materialization or portal visibility as the meaning of the existing receipt;
- restore service while acknowledged receipts or deletion/readiness state are unexplained.

The proposal must state the affected accepted decision, new primary evidence, security/privacy/realm/durability impact, alternatives, smallest falsifying experiment, migration/rollback consequences and ADR action.

---

# Final residual risk and next stop/go gate

## Residual risk

Even after a technical G8 pass, the following remains unsafe, uncertain, costly or dependent on humans:

- **UNKNOWN — physical durability.** A database can report commit while storage, virtualization, firmware or a correlated operator failure violates the assumed failure domain. Only a chosen topology and destructive restore/failover evidence can bound this.
- **HUMAN DECISION — acknowledged loss.** The organization has not approved RPO/RTO, receipt failure-domain class, endpoint cleanup grace or what happens when a receipt outlives every retained copy.
- **UNKNOWN — representative workload.** No approved event/byte/batch/retry/outage/fan-out/query distribution exists. Queue plans, log growth, leases, fairness, partitions and cost can change materially at real scale.
- **UNKNOWN — engine operations.** PostgreSQL and SQL Server documentation proves capability, not the organization's ability to patch, monitor, secure, tune, back up, restore and support the selected topology.
- **HUMAN DECISION — schema horizon.** Offline endpoints can produce old schemas; supporting them increases parser/security/test/storage cost, while rejecting them increases quarantine and data gaps.
- **HUMAN DECISION — retention/access.** Exact wire payload, conflict and quarantine evidence can be sensitive even though endpoints minimize. Retention, raw-custody access, legal hold, deletion and backup propagation remain unapproved.
- **UNKNOWN — poison amplification.** Whole-batch atomicity is simpler but one bad event quarantines siblings. Its operational effect depends on the eventual batch limits and defect rate.
- **UNKNOWN — fairness and hot spots.** Realm-aware scheduling reduces obvious noisy-neighbor risk but can still hit hot queue rows, page/lock escalation, vacuum/version cleanup, statistics errors, aggregate hot keys or transaction-log bottlenecks.
- **UNKNOWN — restore composition.** Later deletion/restore design may add tombstones, holds and visibility prerequisites that G8 cannot finalize. A restore can resurrect state unless readiness composes every later lifecycle rule.
- **UNKNOWN — integration semantics.** An external system may not be idempotent, may accept then lose responses, or may be unable to compensate. The server outbox contains but cannot eliminate downstream risk.
- **UNKNOWN — supportability.** Closed diagnostics deliberately refuse raw payload and unrestricted SQL. Some production-only incidents may be slower or impossible to diagnose without synthetic reproduction and higher engineering involvement.
- **SECURITY RESIDUAL.** Database administrators, infrastructure administrators, identity/signing authorities, compromised authorized releases, kernel/hypervisor operators and colluding authorized users remain powerful. Layered controls reduce ordinary application mistakes; they do not eliminate privileged compromise.
- **SUPPLY-CHAIN RESIDUAL.** Database, driver, .NET, decompressor, framework and tool updates can introduce parser, lock, restore or logging defects. Exact-version qualification and rapid advisory response remain recurring cost.
- **HUMAN DEPENDENCY.** Ownership, on-call, budget, licensing, staffing, support hours, incident authority and production risk acceptance are not technical outputs and cannot be inferred from a passing lab.

## Explicit next stop/go gate

**GO next** only for the T1 G8 implementation backlog through the aggregate `g8-gate.json`:

> Implement the contract emulator and poison corpus; build the relational receipt/inbox/lease/materialization/quarantine path for PostgreSQL and SQL Server; kill API, worker and database transitions; restore test backups; and reconcile every receipt to exactly one materialized or terminal-quarantine outcome.

**STOP** before the database/capacity decision if any G8 primary invariant fails. A successful G8 gate may feed Prompt 16 with exact schemas, SQL, plans, rates, resources, failure histories, backup/restore times and cost inputs. It does **not** select the production engine, approve a receipt failure domain, authorize endpoint cleanup, accept live activity, establish SLO/RPO/RTO, or permit pilot/production.

The next technical stop/go question is:

```text
Does the identical PostgreSQL and SQL Server G8 evidence show that every durable
receipt remains recoverable and reaches one materialized effect or explicit
terminal quarantine, with zero duplicate facts, stale-lease commits, cross-realm
results, forbidden-value escapes, unexplained restore findings or cleanup failures?
```

- **GO to database/capacity research** when the answer is yes for both candidates or when one candidate is explicitly eliminated by a reproducible invariant/capability failure and the evidence is reviewed.
- **STOP and open the affected ADR/change proposal** when the answer is no or unknown.

Production remains prohibited until later capacity, long-outage, deletion/restore and human authority gates pass.
