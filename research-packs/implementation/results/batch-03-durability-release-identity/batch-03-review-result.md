# Batch 03 review result — durability, testing, release, identity, diagnostics, and compatibility

**Result path:** `results/batch-03-durability-release-identity/batch-03-review-result.md`  
**Review date:** 31 July 2026  
**Decision status:** **ACCEPT WITH MANDATORY CONDITIONS — ARCHITECTURE MAY PROCEED; THE BATCH GATE IS OPEN AND NO ENGINEERING CANARY IS AUTHORIZED YET**  
**Authority boundary:** reconciliation of endpoint durability, invariant testing, release/update authorization, per-installation device identity, privacy-safe diagnostics/support, and Windows compatibility qualification; **not** legal purpose, prohibited uses, identity level, retention, access, employee consultation, ownership, budget, licensing approval, staffing, SLO/RPO/RTO, commercial support, pilot, production risk acceptance, or deployment approval  
**Predecessors:** accepted Batch 01 and Batch 02 review results  
**Primary batch gate:** **Outbox invariants, release/update authorization, device identity, privacy-safe support, and one exact initial platform tuple must all pass, with complete cleanup evidence, before a T1 engineering canary.**

## Evidence vocabulary

This review uses the required labels:

- **FACT** — directly supported by an allowlisted supplied file or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from facts; the chain is stated.
- **ESTIMATE** — a numerical hypothesis whose inputs must be replaced by measurement.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — required evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, business, support, or production authority is required.
- **CLI EXPERIMENT** — code, lab work, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements are the proposed consolidated Batch 03 implementation baseline. They do not convert a **HUMAN DECISION**, **UNKNOWN**, or unexecuted **CLI EXPERIMENT** into approval.

---

# 0. Evidence boundary, file-presence record, and review method

## 0.1 Allowlisted project evidence

**FACT.** All eleven allowlisted Project files were present. No other Project file was opened, searched, quoted, summarized, or used. The six topic results were supplied locally with a `(1)` suffix and the Batch 01 review with a `(3)` suffix; their titles and declared result paths identify the allowlisted logical filenames.

| Ref | Allowlisted logical file | Reviewed local file | SHA-256 | Role and limitation |
|---|---|---|---|---|
| I01 | `09-g5-sqlite-outbox-state-machines-result.md` | `09-g5-sqlite-outbox-state-machines-result(1).md` | `e5ec42682267ffb2e97a3abe18d4bf74f366ae1b0766ae3b8d1a318b6e94068e` | G5 store, batching, receipts, encryption, migration, pressure, and recovery blueprint; proposed design, not passed lab evidence or human approval. |
| I02 | `10-invariant-fault-testing-result.md` | `10-invariant-fault-testing-result(1).md` | `865d19103219002cfca1a510f80139c2fea27fdd0ddefc391cd7b6e9be9b7bb9` | Verification architecture and tool review; does not itself prove any product invariant. |
| I03 | `11-release-updater-supply-chain-result.md` | `11-release-updater-supply-chain-result(1).md` | `c95dd4ec636e9572bc822757e18d4bcb261af011477586cc089a6209bfd78906` | Enterprise-first MSI, optional updater, TUF, signing, rollback, and supply-chain blueprint; production authorities remain open. |
| I04 | `12-device-identity-network-result.md` | `12-device-identity-network-result(1).md` | `711e1b030358fef7c01815a9b1c92ad0327b4b8a93f582e0a94ebaa3bfdcfaaa` | Enrollment, key assurance, certificates, realms, cloning, revocation, gateways, and network blueprint; PKI/realm/platform decisions remain open. |
| I05 | `13-diagnostics-support-result.md` | `13-diagnostics-support-result(1).md` | `5fa3f03bf01896aa99e25a926bd47354d663fcb3c0a3e7f01f592cc24b0f03b8` | Privacy-safe diagnostics and support blueprint; backend, access, retention, and support authority remain open. |
| I06 | `14-windows-compatibility-policy-result.md` | `14-windows-compatibility-policy-result(1).md` | `71a285d493e69796a1a9660f3c3f9f7439ecdeb96c17d9d906320169aff2427a` | Rolling exact-tuple compatibility policy; explicitly proves no platform is supported yet. |
| I07 | `batch-01-review-result.md` | `batch-01-review-result(3).md` | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | Accepted predecessor foundations and mandatory gates. |
| I08 | `batch-02-review-result.md` | same | `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | Accepted predecessor source/privacy architecture and G2–G5 handoff. |
| I09 | `00-accepted-baseline-attachment.md` | same | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Accepted baseline and non-negotiable invariants; not production approval. |
| I10 | `05-decisions-contradictions-and-gates.md` | same | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | Accepted proof-gate order and stop rule. |
| I11 | `06-research-evidence-rules.md` | same | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | Research quality, source, authority, and conflict-handling rules; not technical proof. |

## 0.2 Conflict-resolution method

Conflicts were resolved in this order:

1. preserve I07–I10 accepted predecessor decisions and invariants;
2. prefer narrower authority, smaller privacy/security surface, and fail-closed behavior;
3. distinguish documented vendor capability from UAM-specific fitness;
4. distinguish an architecture invariant from a point-in-time dependency, numeric value, or support commitment;
5. prefer one explicit owner and state machine over overlapping authorities;
6. require the smallest falsifying **CLI EXPERIMENT** where prose cannot decide;
7. leave policy, legal, support, budget, staffing, and production choices as **HUMAN DECISION**;
8. create a baseline change proposal only when a consolidated conclusion actually conflicts with an accepted predecessor.

**FACT.** No accepted-baseline change is required by this review. Several topic-level recommendations are narrowed, conditioned, or moved behind explicit gates; none changes the accepted Coordinator/User Host/Task Host topology, privacy boundary, one-writer WAL decision, at-least-once delivery, receipt meaning, MSI privileged boundary, or gate order.

---

# 1. Executive batch verdict and residual risk

## 1.1 Verdict

**RECOMMENDATION — ACCEPT WITH MANDATORY CONDITIONS.** The six topic results agree strongly enough to accept the Batch 03 architecture at blueprint level:

1. one realm-bound endpoint store with one writer, atomic page effects/progress, immutable batches, durable ambiguity before network send, and receipt-gated acknowledgement;
2. one UAM-owned invariant/model/fault evidence system that combines deterministic test hooks with real process, filesystem, database, network, and VM failures;
3. enterprise MSI as the normal privileged release path, immutable signed payloads and rollback, with autonomous update disabled unless a measured decision gate later justifies it;
4. one locally generated asymmetric identity per specialized installation, server-derived realm authority, fail-closed revocation/clone handling, and no fleet secret;
5. a closed, privacy-safe diagnostics/support subsystem with no raw activity, identity, path, exception, process-memory, or general remote-command channel;
6. a rolling exact-tuple compatibility allowlist in which documented lifecycle or successful installation is insufficient for a support claim.

**FACT.** No supplied result contains executed evidence that closes all five required Batch 03 gate families. I06 explicitly states that no platform is supported at research close. I01, I03, I04, and I05 each describe implementation blueprints and experiments rather than passed evidence.

**Therefore:**

> **The Batch 03 architecture is accepted for implementation prototypes, but the Batch 03 gate remains OPEN. No engineering canary, commercial support statement, pilot, or production deployment is authorized.**

## 1.2 Batch gate status

| Gate | Current status | Required closure evidence | Exact stop condition |
|---|---|---|---|
| B03-G5 — outbox/checkpoint/receipt invariants | **OPEN — CLI EXPERIMENT** | deterministic model and failpoint histories plus real process/VM/disk faults for atomic page commit, immutable batch replay, receipt application, pressure, migration, and recovery | cursor ahead; missing effect; changed retry identity; delete before valid receipt/grace; silent unacknowledged loss; corrupt/mixed state accepted; cleanup residue |
| B03-REL — release/update authorization | **OPEN — CLI EXPERIMENT** | signed/test-signed MSI install/repair/upgrade/rollback, immutable payload and manifest verification, package-tamper/reparse/ACL faults, N/N-1 storage evidence, cleanup | unauthorized/incomplete/mixed/stale/downgraded version executes; prior known-good unavailable; repair deletes data; privileged residue |
| B03-ID — installation identity and realm | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | local key creation/proof, one-use enrollment, active certificate, server-derived realm, revoke/expire/clone/wrong-realm rejection, key cleanup, direct mTLS | shared secret; exported/copied private key; payload-derived realm; wrong realm accepted; revoked/duplicate credential authorizes; clone silently wins |
| B03-DIAG — privacy-safe support | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | catalogue/analyzers, all-sink canaries, cardinality bounds, deterministic support bundle, permit expiry/revocation, blind support exercise, deletion/cleanup | raw/derived forbidden value escapes; arbitrary field/command/file accepted; dump generated; expired permit remains active; cross-realm access; unbounded series; residue |
| B03-COMPAT — initial exact platform claim | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | exact environment inventory, native package/module proof, current predecessor evidence, core G1–G5/release/identity/diagnostic lanes, zero primary failure, unexpired manifest | broad family/major-only match; unsupported state collects; stale evidence; wrong architecture/module; EDR exclusion required without approval; cleanup failure |
| B03-AGG — aggregate engineering-canary gate | **OPEN** | all five gates above, accepted ADR actions, assigned owner functions, T1-only canary plan, evidence/root digests, and cleanup receipt | any missing/expired/contradictory evidence, primary failure, unassigned blocking owner, or human scope not recorded |

## 1.3 Smallest candidate engineering-canary tuple

**RECOMMENDATION.** The initial tuple in I06 is still too broad for the first aggregate gate because it combines multiple Windows releases/editions, browser channels, session classes, network paths, and security states. The smallest credible candidate is one exact tuple selected at execution time:

| Dimension | First candidate scope | Explicitly outside the first tuple |
|---|---|---|
| Operating system | one exact **Windows 11 Enterprise 25H2 x64** serviced build and update revision in a disposable/reverted lab | Education/Pro/Home, 24H2, 26H1, LTSC, Server, ARM64, other builds |
| Package | one native, self-contained, non-single-file `win-x64` MSI/payload digest; exact .NET/native-SQLite/module inventory | AnyCPU, x86, ARM64, x64-on-ARM emulation, single-file, AOT, framework-dependent drift |
| Browser | one exact Microsoft Edge Stable build and one exact accepted source-schema capability | Extended Stable, Beta/Dev/Canary, Chrome, Firefox, WebView2, custom command-line roots |
| Session | one local console logon, one eligible User Host, no concurrent same-SID source sharing | RDP, fast user switching, RDS/AVD/RemoteApp/Citrix, simultaneous same-SID sessions |
| Profile | one local, non-roaming, non-containerized, non-temporary profile on local fixed storage | FSLogix, Citrix profile management, roaming, container/cloud cache, UNC/network root |
| Endpoint security | Microsoft Defender in one recorded primary-mode policy, no UAM-specific exclusion | passive/EDR block variants not in the exact tuple; third-party EDR; broad exclusions |
| Network | direct HTTPS with end-to-end mTLS and no TLS interception | explicit proxy, proxy authentication, PAC/WPAD, VPN dependency, captive portal, L7 termination |
| Power | ordinary awake/restart lifecycle only for the first VM tuple | claimed Modern Standby, physical S3/S4, battery, firmware, hibernate support |
| Data | T1 fictional browser fixtures and fictional realm/installation identities only | live activity, production-derived URLs, customer configuration, production credentials |

**INFERENCE.** This narrowing removes variables that do not need to be combined to prove the first Batch 03 architecture. RDP, explicit machine proxy, Edge Extended Stable, Education edition, physical power, ARM64, VDI/profile virtualization, and third-party EDR each become separate later tuples rather than hidden dimensions of the first claim.

The manifest state for a technically passed tuple remains `QUALIFIED`, not `SUPPORTED`. An internal release record MAY state `engineeringCanaryEligible=true` only when all Batch 03 technical gates pass. `SUPPORTED` remains a separate **HUMAN DECISION** requiring commercial/support scope, owners, evidence validity, deprecation, budget, and risk approval.

## 1.4 Immediate permission and prohibition

**GO now** for strict contracts, pure models, DDL, T1 fixtures, canaries, analyzers, test-only hooks, package manifests, identity state machines, lab-only CA/keys, disconnected placeholder-only scripts, compatibility inventory code, and local support-bundle prototypes.

**STOP** before:

- any live or production-derived source data;
- any T1 engineering canary until B03-AGG passes;
- autonomous update enablement unless the separate measured need and TUF gates pass;
- software-key identity fallback without an explicit, time-bounded human exception;
- production cleanup of acknowledged payloads until receipt failure domain, RPO, clock, and grace are approved;
- remote production diagnostics export, support-bundle upload, or raw dump capture;
- any platform, browser, proxy, EDR, VDI, ARM64, power, or support statement not represented by an exact unexpired qualified tuple;
- pilot, production signing, production PKI, commercial support, or deployment approval.

## 1.5 Executive residual risk

The accepted architecture contains rather than eliminates risk:

- SQLite can only trust the operating system, filesystem, firmware, and virtual storage when they report durable flush completion.
- A local administrator, kernel compromise, malicious signed release, hypervisor operator, or security product can still observe process memory or misuse an authorized key.
- A TPM proves a bounded key property under a selected trust model; it does not prove a clean OS, correct collector, lawful purpose, or human identity.
- Browser internals, Windows servicing, proxy/TLS behavior, EDR policy, profile virtualization, and physical power behavior can change after qualification.
- Fail-closed identity, update, compatibility, and diagnostics behavior can create outages, backlog, coverage gaps, and support cost.
- Closed diagnostics deliberately make some production-only failures harder to diagnose; reproduction with synthetic evidence may be the only safe path.
- Test models and checkers can share a conceptual defect with implementation; real-boundary campaigns and mutation reduce but cannot remove this risk.
- Root/signing/CA/gateway compromise and human approval error remain high-consequence governance failures.

Containment is exact scope, immutable evidence, purpose-separated keys, independent authorization layers, strict state machines, one final effect, no silent loss, fail-closed holds, rollback/repair, value-free health, expiry, kill switches, reproducible failure capsules, and explicit human authority.

## 1.6 Confidence summary

| Major conclusion | Confidence | Reason | Evidence that could change it |
|---|---|---|---|
| Consolidated Batch 03 architecture is internally coherent | **High** | Six results independently converge on narrow authority, immutable state, fail-closed control, exact evidence, and predecessor invariants. | A falsifying prototype showing the boundaries cannot compose without weakening an accepted invariant. |
| G5 logical model is correct enough to implement | **High** | Directly expresses accepted atomic cursor/effect, at-least-once, receipt, and no-silent-loss invariants. | Model counterexample, provider limitation, or crash history producing cursor-ahead/missing effect. |
| G5 operational fitness on Windows | **Medium** | SQLite primitives are documented; actual flush, AV/EDR, disk-full, key, and crash behavior is unproved. | Exact Windows/physical/VM campaigns and provider/native inventory. |
| Enterprise-first MSI release ownership | **High** | It is accepted baseline and minimizes privileged online authority. | Repeated approved enterprise-management misses plus a safer updater passing every security/operations gate. |
| Autonomous updater is needed | **Low** | No approved patch SLA or management-attributable latency evidence was supplied. | Representative measured misses and materially better constrained-updater results. |
| Per-installation asymmetric identity and server-derived realm | **High** | Directly protects realm isolation, revocation, cloning, and no-shared-secret requirements. | A required platform/network case that cannot meet the model without an explicit alternative proof protocol. |
| TPM-backed profile will fit the first estate | **Medium** | Windows documents the primitives; actual TPM/vTPM/CA/firmware/VM coverage is unknown. | Read-only inventory, key/attestation experiments, and operational recovery drills. |
| Closed privacy-safe diagnostics are the right baseline | **High** | Follows minimization and support-risk evidence; generic telemetry defaults expose too much. | A defined support case that cannot be solved with safe signals and cannot be reproduced synthetically. |
| First exact platform tuple is qualifiable | **Medium-Low** | Narrow tuple is technically plausible, but no runtime lane has passed. | Complete exact-tuple evidence, including G1–G5, release, identity, diagnostics, resources, and cleanup. |
| Any platform is currently supported | **Low / not established** | I06 explicitly states no platform is supported; no aggregate gate evidence exists. | An accepted unexpired technical gate plus the separate human support decision. |

---

# 2. Accepted decisions and invariants

## 2.1 Accepted predecessor baseline carried forward

The following are **FACT** from I07–I10 and remain non-negotiable:

| ID | Accepted invariant |
|---|---|
| A-01 | Windows endpoints use a low-privilege machine Coordinator, one ordinary-token User Host per eligible interactive session, and short-lived restricted Task Hosts. |
| A-02 | The Coordinator does not crawl or load user profiles, create user tokens, or read user-owned browser sources. |
| A-03 | Task Hosts are fixed release-authorized capabilities, not plugin, script, path, assembly, SQL, command, or arbitrary-code channels. |
| A-04 | C#/.NET is the default implementation family; exact patches and fast-moving dependencies are selected and recorded at execution time. |
| A-05 | A release-authorized product privacy ceiling limits sources, fields, transformations, destinations, diagnostics, and capabilities; tenant policy only narrows. |
| A-06 | Forbidden source values are removed before User Host/Coordinator IPC, endpoint durability, logs, diagnostics, support artifacts, or transport. |
| A-07 | SQLite WAL with one writer atomically stores minimized effects and source progress; a cursor never advances ahead of the durable effects or approved no-event facts it represents. |
| A-08 | Delivery is at least once; stable event/batch identities and central uniqueness yield one final business effect. |
| A-09 | Uploads are bounded, versioned, authenticated, compressed HTTPS batches. A receipt means durable custody in its declared failure domain only. |
| A-10 | Receipt, validation, quarantine, materialization, integration, and portal visibility are distinct states. |
| A-11 | Realm, installation, device, user, and session authority comes from authenticated context, never payload claims. |
| A-12 | One user/session/realm cannot submit, view, mutate, or delete as another. |
| A-13 | MSI and enterprise deployment own the stable privileged boundary; an autonomous updater is optional, minimal, repository-authorized, rollback-safe, and separately justified. |
| A-14 | An unauthorized, incomplete, stale, frozen, or downgraded release never executes. |
| A-15 | No component silently drops unacknowledged data under pressure. |
| A-16 | A privileged mutation cannot succeed without durable audit evidence. |
| A-17 | Restores do not lose acknowledged events or make deleted data visible before deletion/readiness state is restored. |
| A-18 | The first functional slice is Edge history at site/domain-level minimized output using synthetic data until governance permits otherwise. |
| A-19 | UAM telemetry is fallible operational evidence, not sole forensic proof and not an employee-productivity score. |
| A-20 | A failed early proof gate stops dependent work; passing proves only the named claim and environment. |

## 2.2 Endpoint durability and G5

**RECOMMENDATION — ACCEPT as the logical implementation baseline; keep every exact value and runtime claim gated.**

1. Each active `(realm_id, installation_id, store_epoch)` has one protected business SQLite store and one serialized write authority.
2. The business store uses WAL and `synchronous=FULL` for the G5 profile. Automatic checkpointing is disabled or explicitly controlled; checkpoint behavior is application-owned, bounded, measured, and serialized with the writer.
3. A collection page commits its immutable source effects, minimized outbox events, deterministic no-event facts, page/run facts, bounded witnesses, and compare-and-swap checkpoint in one `BEGIN IMMEDIATE` transaction.
4. Network I/O never occurs inside the page or store transaction.
5. Stable natural source identity excludes runtime, collector, normalizer, policy, matcher, and interpretation versions. A UUIDv7 `event_id` is minted once at first durable effect commit and reused on retry.
6. A batch is sealed once with immutable membership, canonical uncompressed content digest, exact compressed wire bytes, and wire digest before any send.
7. A delivery attempt is durably `PREPARED` before the first socket write. A crash before send and a crash after send are both treated as ambiguous custody and replay/query the same batch.
8. Only a matching authenticated durable-custody receipt moves the batch to `RECEIPTED`. HTTP success, socket completion, or semantic acceptance is insufficient.
9. Payload cleanup requires a valid receipt, approved grace/RPO/clock policy, no hold, and retained tombstone/evidence. Unknown or conflicting receipt state never deletes payloads.
10. Disk pressure pauses new collection before unacknowledged deletion. Receipt application, recovery, clean shutdown, integrity, and explicitly authorized cleanup receive priority.
11. Corruption enters hold/quarantine; there is no automatic `.recover`, delete-and-recreate, or silent cursor reset.
12. Storage migration is signed/release-owned, expand/backfill/contract, crash-resumable, independently verified, and N/N-1 readable through the rollback window. Destructive epochs are enterprise maintenance.

## 2.3 Verification architecture

**RECOMMENDATION — ACCEPT.**

1. UAM owns the invariant registry, pure models, command/event/fault alphabets, reference checkers, seed format, shrink rules, history format, failure capsule, cleanup receipt, and gate aggregation.
2. Seeded model/property campaigns provide deterministic replay and minimal counterexamples.
3. Test-only semantic hooks localize boundaries such as `after_commit_before_ack`; production artifacts structurally exclude controllers, schedules, destructive test tools, and test keys.
4. Every load-bearing simulated fault has a real-boundary companion unless automation is unsafe or impossible and an owned manual exercise is recorded.
5. Real lanes include process/service kill, reboot/VM reset, disk full/denied write, socket reset/response loss, database restart, certificate expiry/revocation, package tamper, proxy failure, and actual backup/restore where the gate requires it.
6. A passing mock, line-coverage percentage, mutation percentage, container smoke test, scanner, or VM count is never the sole proof.
7. The first failure is preserved. Reruns do not overwrite it; unexplained nondeterminism is `FlakyUnclassified` and blocks release.
8. A recurring “harness lies” campaign must prove the harness fails when a checker, canary, hook, operation, cleanup, or evidence step is deliberately broken.
9. Batch 03 adopts only the testing architecture relevant to current gates. Durable inbox, 6,000-device capacity, deletion, restore, and extended-platform suite gates remain later work and are not claimed closed here.

## 2.4 Release, installer, and optional updater

**RECOMMENDATION — ACCEPT the enterprise-first release architecture.**

1. MSI/enterprise management owns service/task/launcher registration, protected roots/ACLs, bootstrap trust, repair, uninstall, incompatible storage epochs, and out-of-band recovery.
2. The default mode is `ENTERPRISE_ONLY`. No autonomous updater is authorized by release frequency, convenience, or code presence.
3. The MSI package and every executable/library are bound to exact file length/hash manifests and an approved Authenticode policy. Enterprise deployment promotes the same signed digest through rings.
4. Payload versions are immutable and side-by-side. The stable MSI-owned launchers select only independently verified current/previous/baseline payloads; they never execute from staging, user-writable storage, a symlink/junction, or a mutable `current` directory.
5. Activation and health are separate from MSI transaction success. A successful `msiexec` is not product health; enterprise detection requires the intended verified digest and health state.
6. Rollback is a higher authorized release sequence pointing to a known-good digest; metadata sequence never decreases.
7. Current and previous payloads remain readable against the endpoint store during probation. A one-way migration is not an autonomous update.
8. A constrained autonomous updater MAY be reconsidered only after a human-approved patch SLA/coverage target, representative management-attributable misses, measured material benefit, and the complete security/operations gate.
9. If authorized, the updater is split into a low-privilege network Fetcher and a no-network minimal privileged Activator. It cannot modify the MSI-owned bootstrap, service/task/ACLs, root trust, or itself.
10. TUF-conformant repository authorization and POUF are mandatory only for the optional autonomous updater. They are not a blocker for an enterprise-only MSI engineering canary.

## 2.5 Installation identity, realm, certificate, and network authority

**RECOMMENDATION — ACCEPT for prototypes with the named human and CLI gates.**

1. A specialized installation creates one UAM-owned `installation_id` and one local asymmetric key. The private key never appears in an image, package, PFX, server, log, support bundle, evidence archive, or test export.
2. A one-use, short-lived, audience- and realm-bound bootstrap authorization permits one enrollment attempt. No reusable fleet secret or shared API key exists.
3. The server assigns and stores the authoritative realm, installation, enrollment epoch, credential generation, assurance level, and status. Certificate subject/SAN, hostname, SID, IP, `MachineGuid`, body `realmId`, or forwarding header is not authority.
4. TPM-backed Microsoft Platform Crypto Provider keys are the preferred A2 profile. Provider name alone does not prove assurance; effective properties, fresh challenge signing, and optional issuer attestation are independently verified.
5. Software-key A1 is disabled by default. It requires an explicit time-bounded human exception and never occurs as silent fallback.
6. Direct origin mTLS or L4 TLS pass-through is the default. L7 termination is conditional on certificate validation, current status, inbound identity-header stripping, gateway-to-backend mTLS, and a short-lived request-bound signed assertion verified by the backend.
7. Every request or stream start checks current UAM credential status or a bounded-freshness deny cache. CRL/OCSP and certificate expiry supplement but do not replace application status.
8. Golden images are captured before enrollment and contain no installation/realm ID, key/certificate, bootstrap token, outbox/cursor, policy cache, or support evidence.
9. Post-enrollment cloning places the shared credential in `DUPLICATE_HOLD`; the server does not select a winner automatically.
10. Realm transfer is decommission plus cleanup plus new enrollment, key, credential, epoch, and realm binding. No active credential or endpoint store changes realm in place.
11. Nonpersistent pooled VDI with shared identity is unsupported. Any future per-boot identity profile is a separate design and load model.
12. Network location, proxy, VPN, or certificate text never establishes realm or installation identity.

## 2.6 Privacy-safe diagnostics and support

**RECOMMENDATION — ACCEPT the closed diagnostics architecture.**

1. A release-owned compile-time catalogue defines every event, error, metric, span, attribute, safe message, owner, retry class, retention class, and cardinality formula.
2. User Host and Task Host diagnostic APIs accept closed enums and bounded primitives only. They have no overload for URL, host, path, user, SID, realm, source, application, arbitrary string, object, exception, stack, dictionary, or command.
3. The Coordinator is the only endpoint process that may persist or export diagnostics. Task Hosts never write logs, bundles, traces, dumps, or network telemetry.
4. Diagnostic persistence is separate from the business store and business transaction. Diagnostic failure cannot advance a cursor, acknowledge a batch, block the page commit, or become audit evidence.
5. Endpoint traces and automatic process dumps are off at baseline. Production support cannot enable raw D3 collection; D0–D2 are finite precompiled safe signals only.
6. A signed diagnostic permit is purpose-, realm-, target-, release-, ceiling-, level-, destination-, byte/event-, and time-bound; it can only narrow the release privacy ceiling. Expiry, revocation, kill, clock uncertainty, canary detection, or target mismatch stops enhanced diagnostics and cleans up.
7. A support bundle is deterministic and contains only approved hashes, versions, counts, finite status classes, cardinality reports, and value-free timelines. It never contains a DB copy, raw logs, arbitrary file, registry dump, event-log export, ETL, PCAP, process dump, URL, host, path, user, or secret.
8. Plaintext bundle assembly is memory-only; schema/canary checks precede encryption. Exact encryption and key-wrapping remain a separate human/crypto decision.
9. Operational logs are not the durable privileged-audit ledger.
10. A local T1 blind-support exercise can close the engineering-canary supportability gate. A production remote support backend is not required for that canary and remains separately gated.

## 2.7 Rolling compatibility and platform claims

**RECOMMENDATION — ACCEPT the exact-tuple/expiry policy; reject every broad support statement until evidence exists.**

1. Compatibility is the intersection of vendor-serviced platform, release-owned representable capability, exact qualified tuple, unexpired evidence/manifest, no safety hold, tenant narrowing, and current matching runtime facts.
2. Missing, conflicting, unknown, stale, unsupported, or multiply matching facts produce no collection permit.
3. A tuple binds release/package digest, OS edition/version/build/update class, architecture/RID/native modules, .NET/native SQLite profile, browser build/source capability, session/profile topology, network, security product/policy class, power class, and required predecessor evidence.
4. Wildcards or build ranges are allowed only for an explicitly proved equivalence class. “Windows 11,” “current Edge,” “third-party EDR,” and “current/previous” are not executable support rules.
5. The state vocabulary remains `UNKNOWN`, `UNSUPPORTED`, `TEST_ONLY`, `CONDITIONAL`, `QUALIFIED`, `SUPPORTED`, `DEPRECATED`, `EXPIRED`, and `SAFETY_HOLD`.
6. `QUALIFIED` means technical evidence passed for a named purpose but the commercial/support decision is incomplete. `SUPPORTED` requires the separate human coverage/support decision.
7. Evidence expires at the earliest relevant vendor, manifest, evidence, release, dependency rebuild, source-capability, exception, incident, or deprecation boundary.
8. A self-contained package controls the runtime version but makes UAM responsible for publishing security/runtime updates. Exact patches remain execution-time inputs.
9. Architecture-native packages are separate. x64 emulation is not ARM64 support; VM evidence is not physical power/firmware/ARM64 proof; one RDP test is not RDS/AVD/Citrix support.
10. No UAM-specific EDR exclusion is the default. A broad exclusion is prohibited; any narrow temporary exception is human/security-owned, expiring, auditable, and requalified.

## 2.8 Cross-topic invariants added by this review

The following cross-topic rules are necessary for the six designs to compose safely:

| ID | Consolidated invariant |
|---|---|
| X-01 | **Machine bootstrap/control state is separate from realm business state.** Installation, enrollment, release slots, signed-control caches, and compatibility state may exist before or outside a realm; activity/outbox/cursor state may not. |
| X-02 | The realm-bound G5 store is created only after installation identity is active and the server has assigned the authoritative realm. A golden image and unenrolled install contain no G5 business store. |
| X-03 | Device-authentication keys, G5 data-encryption/wrapping keys, release/TUF keys, control-artifact signing keys, diagnostic-permit keys, bundle-encryption keys, and provenance keys are purpose-separated and never reused. |
| X-04 | Product ceiling, compatibility manifest, diagnostic permit, emergency kill, and optional updater metadata MAY share a common signed-control envelope profile, but each has a distinct purpose, audience, authority, schema, key, and state machine. |
| X-05 | One `EndpointStorageCompatibility` artifact owns reader/writer schema epochs and N/N-1 facts. Release metadata and compatibility manifests reference its digest; they do not maintain competing migration truth. |
| X-06 | The compatibility/control-artifact cache and diagnostics journal are not tables in the G5 business store. If SQLite is used for either, each is a separate bounded store with one writer and no cross-store atomicity claim. |
| X-07 | Identity revocation or expiry never changes batch/event identity or receipt meaning. It stops authorization; unacknowledged minimized data remains durable until an approved recovery, re-enrollment, retention, or loss policy applies. |
| X-08 | A compatibility or diagnostic control-plane failure cannot rewrite, delete, or acknowledge business data. It can only stop new work and expose bounded health. |
| X-09 | An update cannot activate unless its storage compatibility, compatibility tuple, identity/client prerequisites, diagnostic catalogue, and rollback evidence match the exact signed release. |
| X-10 | No topic result may use later durable-inbox, capacity, deletion/restore, or extended-platform work as if those suite gates were already passed. |

---

# 3. Rejected and deferred recommendations

## 3.1 Rejected now

| Recommendation or interpretation | Decision | Reason |
|---|---|---|
| Claim “Windows supported,” “Windows 11 supported,” or “current Edge supported” | **REJECTED** | No exact aggregate evidence exists; names and vendor servicing do not prove UAM fitness. |
| Mark the first technically passed tuple `SUPPORTED` automatically | **REJECTED** | Commercial/support coverage is a human authority; technical evidence yields `QUALIFIED`. |
| Qualify Windows 11 Enterprise/Education 24H2/25H2, Edge Stable/Extended, console/RDP, and direct/proxy in one first tuple | **REJECTED AS FIRST GATE** | Too many independent variables; failures become ambiguous and unsupported combinations inherit confidence. |
| Require TUF before an enterprise-only MSI canary | **REJECTED** | TUF is required for an autonomous network repository; MSI-only release authorization has a smaller accepted path. |
| Enable an autonomous updater by default or because releases are frequent | **REJECTED** | No approved patch-SLA or management-attributable miss evidence; adds permanent privileged/security operations surface. |
| Monolithic SYSTEM downloader/extractor/self-updater | **REJECTED** | Combines untrusted network, parser, filesystem mutation, service/root update, and execution authority. |
| In-place overwrite, mutable `current` directory, symlink/junction-selected executable, or execution from staging | **REJECTED** | Can leave mixed versions and creates redirection/TOCTOU risk; destroys known-good rollback. |
| Lower metadata/release sequence as “rollback” | **REJECTED** | Defeats anti-rollback; known-good bytes are republished at a higher authorized sequence. |
| Destructive endpoint schema migration in an autonomous release | **REJECTED** | Breaks N/N-1 rollback; requires enterprise maintenance, backup, restore, and human authority. |
| Create/enroll identity in a golden image or reuse one certificate/key across clones | **REJECTED** | Breaks per-installation uniqueness, revocation, audit, and realm binding. |
| Shared API key, fleet secret, permanent bootstrap token, or body/header realm authority | **REJECTED** | One leak compromises the fleet and destroys independent revocation/isolation. |
| Silent software-key fallback when TPM is unavailable | **REJECTED** | Materially lowers assurance and clone resistance without accountable risk acceptance. |
| Treat provider name alone as TPM assurance | **REJECTED** | Provider claims require effective-property/challenge evidence and optional attestation; local privilege can spoof weaker signals. |
| Use CRL/OCSP publication alone as rapid application deny | **REJECTED** | Distribution/cache/connection delay is not the same as current UAM authorization state. |
| Trust client-supplied XFCC/identity headers or raw certificate subject at L7 | **REJECTED** | Headers are attacker-controlled at the public boundary; gateway proof must be sanitized, authenticated, short-lived, and request-bound. |
| Fall back from failed proxy/PAC to direct egress automatically | **REJECTED** | Can bypass enterprise controls and change destination exposure. |
| Disable TLS validation for interception compatibility | **REJECTED** | Removes server authentication; use an approved trust/bypass/proof profile or fail closed. |
| Broad AV/EDR exclusion, profile/drive exclusion, or endpoint-created allow rule | **REJECTED** | Creates a protection gap and self-authorizes security weakening. |
| Store raw diagnostic text, URLs, hosts, paths, exception messages/stacks, arbitrary objects, or process dumps | **REJECTED** | Violates minimization before diagnostics and turns support into a disclosure path. |
| “Log locally, redact before upload” | **REJECTED** | Raw data already crossed the durable diagnostic boundary and may enter backup/pagefile/security products. |
| Generic OpenTelemetry/ASP.NET/HTTP auto-instrumentation defaults | **REJECTED BY DEFAULT** | Common conventions/defaults can include full URL, path, headers, addresses, query text, and high-cardinality values. |
| Collector redaction/filtering as the primary privacy boundary | **REJECTED** | Data has already crossed the application boundary; defaults and transform error modes can change. |
| Remote debugger, diagnostic port, arbitrary command/file support collector, or production fault-hook endpoint | **REJECTED** | Becomes a process-memory/control/exfiltration channel outside the privacy ceiling. |
| Automatic WER/.NET full dumps in production | **REJECTED** | Dumps can contain full process memory and forbidden values. |
| Hash/HMAC raw URL, host, path, user, or identity for ordinary diagnostics | **REJECTED** | Predictable spaces can be enumerated and stable digests create unnecessary linkability. |
| Use the diagnostic journal as audit evidence or include diagnostics in the page transaction | **REJECTED** | Diagnostics have different loss/retention/access semantics and must not affect business durability. |
| Treat x64-on-ARM emulation, hosted ARM64 build success, or one VM as ARM64/physical support | **REJECTED** | Native dependencies, firmware, power, EDR, installer, and hardware differ. |
| Treat one RDP/FSLogix/Citrix/AVD vendor document or smoke test as platform support | **REJECTED** | UAM-specific session, profile, source, concurrency, cleanup, and origin semantics remain unproved. |
| Treat exact current patches, retries, byte limits, key algorithms, expiry, or budgets as timeless architecture | **REJECTED** | They change with releases, estate, threat, workload, support, and lifecycle evidence. |
| Treat future durable-inbox/capacity/deletion/restore gates as closed because the testing result models them | **REJECTED** | A test design is not executed proof; the global sequence remains unchanged. |

## 3.2 Deferred technologies and values

| Area | Provisional/deferred item | Classification | Resolution path |
|---|---|---|---|
| SQLite | exact managed provider, native bundle/build, compile options, VFS, checkpoint thresholds, busy limits | **CLI EXPERIMENT + HUMAN DECISION** | source/package/binary/license/support admission; loaded-module evidence; G5 campaigns |
| Endpoint encryption | AES-GCM profile, nonce format, CNG provider, TPM/software/enterprise dual wrap, SQLCipher/SEE | **HUMAN DECISION + CLI EXPERIMENT** | threat model, recovery/RPO, estate coverage, crypto review, performance/recovery bake-off |
| Storage pressure | DB/WAL/reserve/backup/quarantine quota, max offline duration, pause/loss rule, ACK grace | **HUMAN DECISION + ESTIMATE** | measured T1/T3-safe distributions, RPO/restore evidence, data/risk decision |
| Batching/retry | event/byte/age caps, retry/backoff, status-query cadence | **ESTIMATE** | synthetic fault/load plus later approved metadata-only measurements |
| Release | installer authoring tool, exact WiX version, Authenticode profile, code-signing CA/timestamp, key threshold/custody | **HUMAN DECISION + DEPENDENCY ADMISSION** | procurement/legal/security/signing ceremony and exact package evidence |
| Updater | need, population, repository hosting, TUF client implementation, POUF algorithms/expiry/threshold | **DEFERRED** | approved patch SLA, measured misses, full TUF/client/OOB recovery gate |
| Device identity | CA/MDM/RA, A2/A3 requirements, A1 exceptions, algorithms/EKU/OID, certificate lifetime/overlap | **HUMAN DECISION** | PKI/realm/security decision plus exact lab interoperability |
| Revocation | deny-cache freshness, CRL/OCSP fail policy, status-service topology, clock tolerance | **HUMAN DECISION + CLI EXPERIMENT** | security/SRE targets, outage simulations, capacity and incident drills |
| Gateway/network | L7 gateway implementation/assertion profile, certificate-bound tokens, DPoP/HTTP signatures, proxy/PAC/VPN/TLS inspection | **DEFERRED** | named customer requirement, ADR, interop/replay/canonicalization/security tests |
| Diagnostics | OpenTelemetry packages/exporter/backend, sampling, series budgets, journal size, bundle limits | **DEPENDENCY ADMISSION + ESTIMATE** | exact version/config, all-sink/cardinality/load tests, backend/human decisions |
| Support bundle | encryption/recipient/key-wrap profile, destination, access, retention, deletion, case workflow | **HUMAN DECISION + CLI EXPERIMENT** | crypto/backend/access/deletion interoperability and governance |
| Compatibility | evidence validity, qualification cadence, exception duration, deprecation window, support matrix | **HUMAN DECISION** | product/support/platform ownership and recurring-lab capacity |
| Platforms | RDP, RDS/AVD, RemoteApp, FSLogix/Citrix, ARM64, LTSC/Server, Chrome/Firefox, physical power, third-party EDR | **DEFERRED** | exact demand decision and independent tuple campaigns |
| Operational | SLO/RPO/RTO, support hours, staffing, budget, licenses, incident authority, pilot/production acceptance | **HUMAN DECISION** | accountable approval; research cannot select them |

---
# 4. Contradiction register with evidence-quality resolution

## 4.1 Register

| ID | Overlap, contradiction, or authority problem | Evidence-quality resolution | Consolidated decision | ADR/action |
|---|---|---|---|---|
| C03-01 | I06 proposes a support policy while also stating no platform is supported. | The no-support statement is factual; the tuple/matrix is a proposed future claim. | Accept the policy architecture; keep every tuple `UNKNOWN/TEST_ONLY/QUALIFIED` until evidence and human support approval. | ADR-B03-012; compatibility state tests. |
| C03-02 | I06's proposed first slice spans two Windows releases, two editions, two Edge channels, console/RDP, and two network classes. | No evidence establishes equivalence across these dimensions. Smaller scope gives a clearer falsifier. | First aggregate tuple is one exact Win11 Enterprise 25H2 x64 build, Edge Stable build, console, local profile, Defender state, and direct mTLS. | ADR-B03-013; update Prompt 14 tuple. |
| C03-03 | The user gate says an “initial supported-platform claim” must pass before an engineering canary, but support is a human decision. | Technical qualification and commercial support are different authorities. | The batch gate produces an internal `QUALIFIED` tuple with `engineeringCanaryEligible=true`; `SUPPORTED` remains human-owned. | ADR-B03-012/013; schema distinction. |
| C03-04 | I03 makes TUF central to secure updates; the accepted baseline makes autonomous update optional. | TUF is primary evidence for an autonomous repository, not necessary for an enterprise-delivered signed MSI. | Enterprise-only MSI can close B03-REL without TUF. Enabling autonomous update makes TUF/POUF/conformance/OOB recovery blocking. | ADR-B03-006. |
| C03-05 | I03 recommends dual TUF + Authenticode for every executable release. | Dual authorization is valuable for autonomous repository content; enterprise MSI already has separate enterprise/release/signing controls. | Enterprise-only path requires signed MSI, exact manifest/hash, protected source, launcher verification, and enterprise authorization. TUF is conditional. | Update ADR-011-004/005 wording. |
| C03-06 | I01 recommends software-CNG payload-key wrapping as the T1 prototype; I04 disables software-key fallback for device identity. | The keys protect different assets and have different assurance consequences. | Software CNG MAY be a T1 data-encryption prototype; device-authentication A1 remains disabled without human exception. No inference transfers between them. | ADR-B03-002 and ADR-B03-008. |
| C03-07 | I01 and I04 both use TPM/CNG concepts and could encourage key reuse. | Key purpose separation is an accepted security principle; reuse creates cross-protocol compromise and lifecycle coupling. | Device mTLS key, G5 KEK/DEK, diagnostic bundle key, signing keys, and permit keys are distinct and independently rotated/revoked. | ADR-B03-002/015; architecture tests. |
| C03-08 | I01 proposes a realm-bound store; I04 requires installation identity before authoritative realm exists. | A realm-bound DB cannot be safely created in an image or untrusted pre-enrollment state. | MSI installs only machine bootstrap/control state. After active enrollment, create the realm-bound business store. | ADR-B03-014; lifecycle state machine. |
| C03-09 | I06 suggests manifest candidate/activation in SQLite; I01's one-writer SQLite is the business outbox store. | Compatibility state is machine/release control, can predate realm store, and must not be coupled to activity durability. | Signed-control cache is a separate A/B slot or separate one-writer control DB; never a business-store table. | ADR-B03-014/015. |
| C03-10 | I05 proposes a persistent endpoint diagnostic journal; I01 says one writer owns SQLite. | “One writer” is per business store and protects event/progress atomicity. A diagnostic journal has different content and failure semantics. | Diagnostic journal is a separate bounded value-free store with its own single writer or append discipline; no cross-store transaction or business dependency. | ADR-B03-010/014. |
| C03-11 | I05's primary gate discusses remote bundle upload/backend, while the batch gate is before an engineering canary. | A T1 canary does not require a production backend, retention, or support staffing model. | Close the canary gate with a local encrypted bundle and blind-support exercise; remote backend remains production-gated. | ADR-B03-011. |
| C03-12 | I05 requires a signed diagnostic permit but exact signing format/keys are unresolved in Batch 01. | Security properties are load-bearing; exact JWS/COSE/algorithm/quorum is not yet approved. | Use the common signed-control envelope contract with a distinct diagnostic-purpose key. Keep exact crypto profile provisional. | ADR-B03-015; update Batch 01 control-artifact ADR. |
| C03-13 | I01 recommends AES-256-GCM as normative-looking architecture while local sensitivity/recovery is a human decision. | Application pre-bind encryption is a useful prototype, but algorithm/provider/recovery selection exceeds research authority. | Accept “authenticated application-layer payload protection before SQLite bind” as the architecture; AES-256-GCM/CNG is the first T1 candidate, not a production decision. | ADR-B03-002. |
| C03-14 | I01 allows cleanup after receipt/grace; the real server receipt failure domain and RPO are outside G5. | A synthetic receipt cannot authorize production deletion. | Production `cleanup_enabled=false` until ingestion receipt semantics, RPO, status replay, clock, and grace are accepted. T1 cleanup uses fixture policy only. | ADR-B03-001; later ingestion/restore gate. |
| C03-15 | I04 says offline endpoints may continue locally under valid policy; compatibility and identity failures are fail-closed. | Local collection authority requires all relevant active authorities, not merely cached policy. | Identity upload failure alone does not rewrite durable data; new collection follows the strict intersection of valid product/realm policy, compatibility, identity/offline policy, clock, and local safety. Unknown disables. | ADR-B03-008/012. |
| C03-16 | I04 includes explicit proxy/PAC/VPN/TLS interception research; I06's candidate support statement includes machine proxy. | Network products and authentication create independent failure/identity paths. | First tuple is direct mTLS only. Explicit machine proxy is the next separate network tuple; PAC/WPAD, TLS inspection, VPN dependency, and L7 are later profiles. | ADR-B03-009/013. |
| C03-17 | I04 conditionally permits L7 termination with identity forwarding; generic forwarding headers are commonly spoofable. | The result already requires header stripping and trusted backend path, but plain metadata remains too weak. | L7 requires a UAM-owned signed request-bound assertion plus backend credential/status lookup. No plain XFCC is authority. | ADR-B03-009. |
| C03-18 | I03 and I01 independently define storage compatibility and migration fields. | Duplicate authority can diverge between release metadata, store, and compatibility manifest. | Create one content-addressed `EndpointStorageCompatibility` contract; release target and platform tuple reference the same digest. | ADR-B03-003/007. |
| C03-19 | I03 permits automatic rollback; I01 requires no destructive migration and N/N-1 compatibility. | Rollback is safe only while both versions can read/write the store under a declared epoch. | Launcher verifies the shared storage-compatibility artifact before start; incompatible epochs are enterprise maintenance and block autonomous activation. | ADR-B03-003/007. |
| C03-20 | I06 records exact current .NET/Windows/Edge patches in tuple examples. | Point-in-time evidence is useful but stale as architecture. | Store exact patches/builds in evidence and manifests; architecture references lifecycle-selected exact versions, never timeless numbers. | ADR-B03-012; release-time inventory gate. |
| C03-21 | I05 uses OpenTelemetry Collector as a privacy backstop, but upstream defaults can change. | Current Collector Contrib v0.157.0 changed several processor/connector default error modes to `ignore`. | Pin exact custom distribution and config; explicitly set fail-safe behavior; unknown attributes/transforms reject and alert rather than silently continue. | ADR-B03-010; dependency/config mutation tests. |
| C03-22 | I05 treats semantic conventions as input; standard URL/HTTP conventions include sensitive fields. | OpenTelemetry documents full URL/path/header attributes, not a UAM-safe profile. | UAM catalogue/allowlist is authoritative; semantic conventions are reference names only and never an automatic field set. | ADR-B03-010. |
| C03-23 | I03 names WiX v7 as leading installer candidate; licensing can be misread as ordinary open-source binary use. | Current release page states source is licensed but binary use is subject to the OSMF EULA. | Keep WiX a candidate only after Legal/Procurement/EULA and exact binary/source admission. No tool selection is made by this review. | ADR-B03-016; HD-B03-06. |
| C03-24 | I01 proposes TLA+ tools v1.8.0 pre-release as a gate candidate. | A pre-release can support exploratory work but is weak for a load-bearing reproducibility gate. | Model text is accepted; use an admitted stable TLC/tool artifact or explicitly accepted exact pre-release in isolated T1 lane. Until then it is reference/test candidate, not mandatory dependency. | ADR-B03-004/016. |
| C03-25 | I03 records `tuf-conformance` mutable `main`. | Mutable branch lacks reproducible source/dependency identity. | No-go until full commit and dependencies are pinned; autonomous updater stays disabled. | ADR-B03-006/016. |
| C03-26 | I02 records SharpFuzz package 2.3.0 without exact reviewed source mapping. | Package/source mismatch fails the accepted dependency gate. | No-go as reviewed. Continue deterministic hostile corpora or close exact provenance first. | ADR-B03-016. |
| C03-27 | I02 discusses Microsoft Coyote as a possible systematic scheduler. | Exact package/source/support recency and coverage of native/process boundaries are weak. | Reference/bounded spike only after a concrete race escapes the UAM scheduler; never primary evidence. | ADR-B03-004/016. |
| C03-28 | I02 models server inbox, audit, deletion, restore, and capacity along with current batch gates. | Modeling scope is broader than executed gate order. | Preserve models as future assets; Batch 03 acceptance does not promote later global gates. | Backlog separation; no ADR change. |
| C03-29 | I06 and I04 discuss same-SID concurrent sessions and clone detection using runtime observations. | Session/IP/host/platform observations can be ambiguous and privacy-sensitive. | Same physical source has one lease; no visit-origin session claim. Same credential conflict enters hold; no automatic winner based on IP/host/hardware. | ADR-B03-008/012. |
| C03-30 | I06 discusses Defender and third-party EDR support classes; I01/I03/I05 also mention security-product interference. | EDR name/version alone is not a stable configuration and exclusions can alter protection. | Support binds exact product/sensor/content/policy/mode tuple. First tuple uses Defender with zero UAM exclusions. | ADR-B03-012/013; EDR lane. |
| C03-31 | I05 support bundles may include file hashes and exact versions; metrics prohibit high cardinality. | Exact values are useful for bounded evidence but unsafe as metric labels/global search keys. | Exact build/digest/version belongs in access-controlled bundle/inventory records; metrics use finite classes only. | ADR-B03-010/011. |
| C03-32 | I03 and I06 both define kill switches, while tenant policy only narrows. | Multiple independently broadening flag systems would undermine the privacy lattice. | Product/release/compatibility/diagnostic kill switches are finite, signed, monotonic narrowing controls. Tenant policy can only disable/narrow; local safety can only stop. | ADR-B03-015; update policy catalogue. |
| C03-33 | I04 and I05 could place realm/device identifiers in telemetry or bundle payloads for correlation. | Authenticated context is authority; payload identifiers create cross-realm/index risk. | Realm/target are out-of-body authorization/index keys. Bundle/diagnostic bodies use case-scoped opaque aliases only. | ADR-B03-010/011. |
| C03-34 | I03 allows current known-good release to run when update metadata time is uncertain; I04/I06 fail closed on identity/compatibility expiry. | Running already verified code and starting new collection are different decisions. | Current verified launcher/payload may remain operable for repair/health; new collection/upload requires current identity, compatibility, policy, and permit authority. | ADR-B03-007/008/012. |
| C03-35 | I01 recommends one DB per realm and I04 allows ownership transfer. | In-place realm change would make existing encryption, cursor, receipt, backup, and audit associations ambiguous. | Transfer decommissions old store/identity; new realm creates new install/epoch/store. Historical data remains under old realm unless separately governed centrally. | ADR-B03-001/008/014. |
| C03-36 | I05 wants support to diagnose a defined failure set without raw data, but no supportability result has run. | Architecture can be accepted; fitness is still an experiment. | A blind T1 support exercise is a zero-tolerance gate. Failure narrows the support promise or adds safe signals; it never authorizes raw data. | ADR-B03-011; B03-DIAG. |

## 4.2 Change-proposal status

**FACT.** No consolidated decision above conflicts with I07–I10. Therefore no accepted-baseline change proposal is opened. A future prototype MUST open one if it claims any of the following is necessary:

- cursor/progress outside the atomic effect transaction;
- raw value crossing Task Host output or entering diagnostics;
- shared fleet secret or payload-derived realm authority;
- privileged update outside MSI/approved constrained activator;
- lower-sequence rollback;
- silent unacknowledged loss;
- broad support inheritance from vendor version/family;
- arbitrary diagnostic/fault/command channel;
- a second business-store writer or destructive autonomous migration;
- weakening cross-session, realm, release, or receipt semantics.

The proposal must identify the affected accepted decision, new primary evidence, security/privacy/realm/durability impact, smallest falsifying experiment, migration/rollback consequence, and ADR action.

---

# 5. Normative component, interface, schema, and state-machine baseline

## 5.1 Component and authority baseline

| Component | Normative responsibility | Explicit prohibitions | State/evidence owner |
|---|---|---|---|
| MSI / enterprise deployment | install/repair/uninstall stable launchers, optional activator, services/tasks, protected roots/ACLs, bootstrap trust, baseline payload, and out-of-band recovery | no live data; no permanent bootstrap secret; no arbitrary script/command from tenant input; no silent rollback disablement | Installer/Enterprise Deployment |
| Service Launcher / User Host Launcher | verify MSI-owned bootstrap, release state, payload manifest/hash/signature, storage compatibility, safe path/ACL/module set; start exact Coordinator/User Host | no network, source read, policy broadening, staging execution, symlink/junction target, arbitrary path/args | Runtime Bootstrap |
| Machine Bootstrap State Manager | own pre-realm installation ID reservation, key reference, enrollment request/result, credential reference, release A/B state, signed-control cache, clock confidence, and safety holds | no activity, raw source, outbox, cursor, receipt payload, user/profile data | Endpoint Identity/Control State |
| Installation Identity Manager | create local key after specialization, prove possession, enroll/activate/renew/retire, expose finite assurance/status | no private export/PFX, shared key, body-derived realm, silent assurance downgrade | Device Identity |
| Compatibility Evaluator | exact-match observed environment to signed manifest; intersect tenant narrowing/kill/local safety; issue capability verdict | no closest match, family inference, runtime download, tenant-added tuple, stale grace without authority | Compatibility Authority |
| Coordinator | authenticate User Hosts, own machine/realm state, run intents, permits validation, one business-store writer, batches/attempts/receipts, transport orchestration, bounded health | no profile crawl/token creation/raw source; no SQL exposure; no payload realm authority; no arbitrary diagnostic/fault/update command | Endpoint Runtime |
| User Host | exact-session discovery/eligibility, independent policy check, fixed Task Host launch, minimized-page validation | no machine persistence/upload/SQL, cross-session read, raw diagnostic export, arbitrary collector | Session Runtime |
| Task Host | one fixed release-authorized source capability, bounded raw handling and minimization, return closed page or finite failure | no network, child process, arbitrary path/SQL/script/plugin, durable raw scratch, logs/dumps/support bundle | Source Capability |
| EndpointStore Writer | own one realm business SQLite connection and every business transition, checkpoint, migration, backup coordination, integrity, and cleanup | no network, second writer, raw source, automatic salvage/recreate, tenant SQL | Endpoint Storage |
| Batch/Transport Worker | send exact prepared body, obtain typed transport observation/receipt, retry same identity | no DB connection, batch rebuild after ambiguity, ACK/delete inference from HTTP success | Endpoint Transport |
| Diagnostic Gateway / Journal | validate closed records, persist bounded value-free journal/counters, enforce permit and export/bundle limits | no raw values/objects/exceptions/dumps, no business-state mutation, no audit substitution | Diagnostics |
| Support Bundle Builder | freeze safe snapshot, canonicalize, scan, encrypt, upload/local handoff, delete on lifecycle | no command/file glob/registry/profile crawl, plaintext temp archive, raw logs/DB/dumps | Support Engineering |
| Release Fetcher | optional low-privilege metadata/target download into untrusted non-executable staging | disabled by default; no Program Files/service/task/root/ACL mutation; no execution | Optional Update |
| Release Activator | optional no-network independent verification, safe handle copy, immutable materialization, A/B activation/rollback/cleanup | no general archive under SYSTEM, arbitrary path/URL/command, bootstrap/self/root change | Optional Update |
| Server Identity Boundary | validate TLS/gateway proof, derive immutable authenticated device context, consult current status, inject realm/install/epoch | no trust in body/header/subject; no stale soft-fail allow | Server Identity/IAM |
| Ingestion Boundary stub for Batch 03 | in T1 only, atomically store exact batch and return/replay a contract-valid custody receipt | no claim of production failure domain, validation/materialization/visibility, or cleanup authority | Later Ingestion Gate |
| Lab Orchestrator | provision/revert disposable lanes, run T1 fixtures/faults, normalize evidence, prove cleanup | no production credentials/data/signing, no actual SSH details in evidence, no arbitrary customer system mutation | Verification/Lab Operations |

## 5.2 Store and state separation

**RECOMMENDATION.** The endpoint has four logically distinct durable state classes. Implementations may choose protected A/B files or separate one-writer SQLite databases, but MUST preserve the boundaries below.

| State class | Exists when | Allowed content | Transaction authority | Failure consequence |
|---|---|---|---|---|
| `MachineBootstrapState` | after MSI install, before/after enrollment | installation state, key references, enrollment/credential status, clock class, opaque realm binding after server assignment | Identity/Control writer | identity/control hold; never imply source progress |
| `ReleaseAndControlState` | after install | release slots, manifests, signed product/control artifacts, compatibility manifest/evidence IDs, kill states | Stable launcher/control writer | continue verified LKG where safe; block new authority |
| `RealmEndpointStore` | only after active realm-bound identity | minimized source effects, events, cursor, outbox, sealed batches, attempts, receipts, migration/backup/cleanup evidence | one G5 writer | pause/hold/quarantine; no silent reset or realm rebinding |
| `DiagnosticJournal` | when diagnostics component is enabled | closed value-free events/counters, permit state, bounded bundle lifecycle | diagnostic writer | diagnostic degradation/hold; business transaction continues |

Rules:

1. No cross-store transaction is claimed. A component that needs facts from two stores revalidates them at the final authority boundary.
2. Business state never moves into `MachineBootstrapState`, `ReleaseAndControlState`, or `DiagnosticJournal` for convenience.
3. A compatibility, release, identity, or diagnostic safety hold cancels new permits and uncommitted work; it does not rewrite committed business history.
4. Realm transfer/decommission closes the old `RealmEndpointStore`; it is never renamed/rebound to a new realm.
5. Backups and support bundles preserve the same separation and key-purpose boundaries.

## 5.3 Common signed-control artifact envelope

**RECOMMENDATION.** Product ceiling, tenant narrowing, compatibility manifest, diagnostic permit, emergency kill, and optional updater metadata use separate schemas and keys but conform to one logical envelope security profile:

```json
{
  "envelopeVersion": "1.0.0",
  "artifactType": "PLATFORM_COMPATIBILITY_MANIFEST",
  "artifactId": "019d0000-0000-7000-8000-000000000001",
  "sequence": 42,
  "issuerPurposeId": "compatibility-authority-v1",
  "audience": "uam-endpoint",
  "realmBinding": null,
  "productReleaseId": "uam-endpoint-example",
  "productCeilingDigest": "sha-256:fictional",
  "issuedAtUtc": "2026-07-31T12:00:00Z",
  "notBeforeUtc": "2026-07-31T12:00:00Z",
  "notAfterUtc": "2026-08-31T00:00:00Z",
  "contentDigest": "sha-256:fictional",
  "content": {},
  "signatureProfileId": "PROVISIONAL"
}
```

All values are fictional. Normative properties:

- canonical bytes and digest are fixed before signing;
- signature key is authorized for exactly one `artifactType`/purpose;
- realm binding is mandatory where the artifact is realm-specific and absent where product-global;
- sequence is monotonic; byte-identical retry is allowed; same sequence/different content is a security failure;
- rollback republishes prior semantics at a higher sequence;
- audience, release, ceiling, schema, time, key, and chain are verified before candidate activation;
- unknown authority-bearing fields/enums fail closed;
- tenant artifacts cannot broaden product artifacts;
- local state cannot create or extend authority;
- exact serialization, algorithm, threshold, KMS/HSM, and clock tolerance remain the Batch 01 crypto/control-artifact ADR and **HUMAN DECISION**.

## 5.4 Core cross-component contracts

### 5.4.1 `EndpointStorageCompatibility`

One immutable artifact owns endpoint storage compatibility:

```text
storageCompatibilityId
schemaVersion
readerSchemaMin / readerSchemaMax
writerSchema
rollbackReadableThrough
migrationClass = NONE | EXPAND_ONLY | BACKFILL | ENTERPRISE_EPOCH
requiredMigrationDigests[]
requiredKeyProfileIds[]
requiredSQLiteRuntimeProfileId
compatibleReleaseIds[]
validity / evidence digest
```

Rules:

- release target metadata, stable launcher, G5 migration manager, and compatibility manifest reference the same digest;
- no candidate starts a writer until the running payload and store satisfy it;
- N and N-1 must both read/write as declared through probation;
- `ENTERPRISE_EPOCH` cannot be activated by autonomous update;
- a mismatch yields `STORAGE_COMPATIBILITY_HOLD`, never implicit migration or store deletion.

### 5.4.2 `AuthenticatedDeviceContext`

Created only by the server identity boundary:

```text
realm_id
installation_id
device_id?                 # optional governance relation; not authentication
 enrollment_epoch
credential_id
credential_generation
assurance_level
credential_status
status_version
issuer_id
trust_domain_id
authenticated_at
```

It is immutable for the request. Body, URL, host, certificate subject/SAN, proxy header, IP, SID, hostname, or cache key cannot create or override it. Every realm-aware cache/database/job key begins with its authenticated `realm_id`.

### 5.4.3 `PlatformCompatibilityManifest`

The manifest MUST bind:

```text
product release and protected package/file manifest digests
OS family/edition/version/build/update class
OS/process/package/native-module architecture
.NET runtime and native SQLite source/compile profile
browser family/channel/exact build/source capability
session topology and same-source concurrency class
profile provider/storage/container/roaming class
network/proxy/TLS/VPN class
security product/version/policy/mode and exclusion state
power/lifecycle class
required predecessor and Batch 03 evidence roots/expiry
storage compatibility digest
capability IDs, kill switches, state, deprecation
```

Zero or multiple matches are `UNKNOWN`. Tenant policy can only remove/narrow tuples or capabilities. A tuple in `QUALIFIED` state MAY become engineering-canary eligible through a separate gate record; only human authority sets `SUPPORTED`.

### 5.4.4 `ReleaseManifest`

The release manifest binds:

```text
release ID and strictly increasing release sequence
package/installer length and digest
complete file manifest and allowed extra-file rule
per-file length/digest/architecture/AuthentiCode requirement
bootstrap epoch and minimum launcher/evaluator versions
storage compatibility digest
contract/catalogue/product-ceiling/compatibility schema digests
runtime/native module inventory
SBOM/provenance/signing evidence digests
health profile and rollback target eligibility
```

The launcher independently verifies the selected installed directory. Local A/B state is selection evidence, not release authorization.

### 5.4.5 `CustodyReceipt`

A valid endpoint receipt contains at least:

```text
receipt contract/version
receipt ID
batch ID
batch content digest
exact wire-body digest
custody state = DURABLY_RECEIVED
failure-domain class
durable time
server status/version evidence
```

Authenticated server context supplies realm/installation authority. Replayed equivalent receipts are idempotent. Any authoritative mismatch is `RECEIPT_CONFLICT` and holds cleanup.

### 5.4.6 `DiagnosticPermit`

A permit contains only release-owned bounded choices:

```text
permit ID / sequence / purpose code / case-scoped alias
realm and target binding outside or protected within envelope
diagnostic level D0 | D1 | D2
authorized event/instrument/span/bundle entry IDs
maximum bytes/events/duration/rate
destination/key profile ID
product release, ceiling, catalogue and config digests
not-before/not-after, nonce, revocation/kill version
required approval claims
```

There is no D3/raw level. No path, command, regex, script, OTTL, SQL, file glob, URL, backend address, dynamic event name, or arbitrary field is representable.

### 5.4.7 `DiagnosticEvent` and `SupportBundleManifest`

Diagnostic events use fixed catalogue IDs, finite enums, bounded counters/buckets, safe fingerprints, and short-lived operation tokens. Realm/target authority is out of the body. Support bundle manifests list only approved entry IDs, exact sizes/digests, permit/evidence/config IDs, encryption profile, expiry, and lifecycle. Any unknown entry or forbidden key fails the bundle.

## 5.5 State machines

### 5.5.1 Install, specialization, enrollment, and store creation

```text
ABSENT
  -> MSI_INSTALLED_UNCONFIGURED
  -> SPECIALIZATION_CONFIRMED
  -> INSTALLATION_ID_RESERVED
  -> KEY_CREATED
  -> ENROLLMENT_SUBMITTED (same idempotency ID on retry)
       -> REJECTED / DISABLED
       -> CERT_STAGED
  -> MTLS_ACTIVATION
       -> ACTIVE_IDENTITY
  -> REALM_BINDING_DURABLE
  -> REALM_STORE_CREATED_AND_VERIFIED
  -> CONTROL_ARTIFACTS_ACTIVE
  -> COMPATIBILITY_QUALIFIED
  -> ENDPOINT_READY_FOR_PERMIT
```

A crash resumes from the last complete state. A key without complete installation binding is cleaned before retry. The G5 store does not exist before `REALM_BINDING_DURABLE`. A realm transfer never edits the binding; it decommissions and creates a new identity/store lineage.

### 5.5.2 Page, outbox, and cursor

```text
PAGE_PREPARED
  -> BEGIN IMMEDIATE
  -> EFFECTS/NO_EVENT FACTS
  -> OUTBOX EVENTS
  -> WITNESSES/PAGE/RUN FACT
  -> CHECKPOINT CAS
  -> COMMIT_DURABLE
       -> LOCAL_ACK
       -> ACK_LOST -> RETRY_SAME_PAGE -> EXISTING_RESULT

Any failure before COMMIT_DURABLE -> prior durable state
Any incompatible stable key       -> IDENTITY_CONFLICT / SAFETY_HOLD
```

No row-level cursor authority exists. Defer, cancellation, policy transition, source movement, mixed interpretation, invalid page, or uncertain effect causes whole-page failure and unchanged progress.

### 5.5.3 Batch, delivery attempt, and receipt

```text
READY EVENTS
  -> BATCH_BUILDING
  -> SEALED (immutable membership + exact bytes/hashes)
  -> ATTEMPT_PREPARED (durable before socket)
  -> SEND_OBSERVED
       -> VALID_RECEIPT -> RECEIPTED
       -> DEFINITE_NO_CUSTODY -> retry same batch under policy
       -> AMBIGUOUS -> status query/replay same exact batch
       -> SECURITY/CONTRACT HOLD
  -> CLEANUP_ELIGIBLE (receipt + human policy predicates)
  -> PAYLOAD_PURGED / TOMBSTONE RETAINED
```

No network outcome except a valid receipt acknowledges. A semantic rejection may still have custody. A new batch after ambiguity is prohibited unless authoritative no-custody and an explicit supersession contract exist.

### 5.5.4 Release and rollback

```text
CURRENT_VERIFIED(N)
  -> CANDIDATE_AUTHORIZED(N+1)
  -> BYTES_COMPLETE
  -> MATERIALIZED_IMMUTABLE
  -> STORAGE_COMPATIBLE
  -> ACTIVATION_SLOT_WRITTEN
  -> CANDIDATE_BOOT
  -> PROBATION
       -> HEALTHY -> CURRENT_VERIFIED(N+1), PREVIOUS=N
       -> FAILED  -> HIGHER_GENERATION_ROLLBACK -> CURRENT_VERIFIED(N)

Unauthorized/incomplete/stale/frozen/downgraded/mixed -> REJECTED
Both current/previous unverifiable -> BOOTSTRAP_REPAIR_REQUIRED
```

Enterprise MSI owns bootstrap repair. The optional updater, if later enabled, cannot repair or replace compromised root/bootstrap authority in-band.

### 5.5.5 Credential lifecycle

```text
BOOTSTRAP_ONLY
  -> STAGED
  -> ACTIVE
  -> RETIRING (bounded overlap during fresh-key renewal)
  -> RETIRED / EXPIRED / REVOKED / DECOMMISSIONED

Any clone/conflict -> DUPLICATE_HOLD
Any wrong realm/epoch/status/unknown/stale cache -> DENIED
```

The endpoint cannot self-clear a hold or reduce assurance. A server status change is monotonic for authorization until a separately approved higher-version recovery action.

### 5.5.6 Diagnostic permit and bundle

```text
D0_BASELINE
  -> PERMIT_CANDIDATE
       -> REJECTED
       -> ACTIVE_D1_OR_D2
          -> SNAPSHOT_FROZEN
          -> CANONICAL_BUNDLE_BUILT_IN_MEMORY
          -> SCHEMA/CANARY/CARDINALITY PASS
          -> ENCRYPTED
          -> LOCAL_HANDOFF_OR_AUTHENTICATED_UPLOAD
          -> CUSTODY/CASE_STATE
          -> EXPIRED/REVOKED/DELETED

Any canary/forbidden field/clock/target/realm/config mismatch -> DIAGNOSTIC_SAFETY_HOLD
```

Expiry, revocation, kill, or process restart cannot leave enhanced collection active. Plaintext temp archives are prohibited.

### 5.5.7 Compatibility lifecycle

```text
MANIFEST_CANDIDATE
  -> SIGNATURE/SEQUENCE/SCHEMA/RELEASE VERIFIED
  -> EVIDENCE/EXPIRY VERIFIED
  -> ATOMIC ACTIVE/PREVIOUS CACHE
  -> OBSERVED ENVIRONMENT
       -> EXACTLY_ONE_MATCH
           -> QUALIFIED CAPABILITY PERMIT
       -> ZERO/MULTIPLE/MISSING/STALE
           -> UNKNOWN / NO PERMIT

Incident or primary invariant failure -> SAFETY_HOLD
Human support approval + active evidence -> SUPPORTED
Expiry/deprecation end -> EXPIRED / no new collection
```

A previously valid tuple does not inherit support to a new OS/browser/runtime/EDR build automatically. Sentinel work may produce an explicit equivalence decision; version proximity does not.

## 5.6 Transaction and authority boundaries

| Boundary | Atomic/durable unit | Authority source | Cannot be inferred from |
|---|---|---|---|
| Page progress | one SQLite transaction containing all effects/no-events/outbox/witness/page/checkpoint | authenticated Coordinator context + validated page/permit | Task Host return, local ACK, row-level success |
| Batch seal | one transaction storing immutable membership and exact bytes/hashes | writer actor + release-owned batch contract | in-memory envelope or transport intent |
| Attempt ambiguity | durable `PREPARED` attempt before network | writer actor | socket start/absence |
| Receipt | server durable inbox transaction under authenticated device context | ingestion boundary and allowed failure-domain class | HTTP 2xx, TLS success, response body alone |
| Release activation | complete immutable payload plus durable A/B generation | MSI/release authority and stable launcher verification | filename, semantic version, staging, local pointer |
| Enrollment | atomic server token reservation/credential mapping plus mTLS activation | bootstrap authority + server identity service + issuer | certificate subject, body realm, installer property alone |
| Revocation | durable UAM status/audit plus deny propagation outbox/feed | authorized identity administration | CRL publication alone or endpoint local delete |
| Diagnostic activation | valid permit and active local state | diagnostic authority + product ceiling + authenticated target | support ticket text, tenant free-form config |
| Platform qualification | signed exact tuple with unexpired evidence | compatibility/release authority plus human support decision for `SUPPORTED` | vendor lifecycle, successful install, one smoke test |

## 5.7 Common error and recovery taxonomy

| Family | Examples | Default response | Automatic retry? |
|---|---|---|---|
| `INPUT_OR_CONTRACT` | unknown/duplicate field, unsupported version, wrong hash, malformed manifest | reject; preserve active LKG where safe | no coercion; only corrected higher artifact |
| `AUTHENTICATION` | missing/expired/rejected credential, invalid gateway proof | no authorization; retain local data | after re-auth/re-enrollment only |
| `AUTHORIZATION_OR_REALM` | wrong realm/target/epoch, tenant broadening | security hold/deny; generic external error | no until authority changes |
| `PRIVACY` | forbidden field/canary/dump/raw sink | immediate safety hold and incident | no automatic retry |
| `COMPATIBILITY` | no exact tuple, stale evidence, module/arch mismatch | no new permit; value-free health | after higher manifest or environment remediation |
| `DURABILITY` | cursor/effect conflict, receipt mismatch, corruption, unknown commit | hold/reconcile same identity; never guess | only modeled same-identity recovery |
| `TRANSIENT_DEPENDENCY` | busy, timeout, proxy unavailable, CA temporary failure | bounded backoff/jitter, same stable operation | yes when explicitly safe |
| `RESOURCE_PRESSURE` | disk reserve, queue, memory, cardinality budget | pause/backpressure; no silent drop | after measured recovery state |
| `SECURITY_INTEGRITY` | signature/key/tamper/rollback/clone/unexpected module | safety hold; kill/rollback/repair/incident | no self-reenable |
| `CLEANUP_FAILURE` | leftover service/task/file/key/rule/permit/temp archive | gate failure; quarantine/revert environment | cleanup/revert then rerun |
| `HARNESS_FAULT` | checker/controller/fixture/evidence failed | neither product pass nor fail; repair harness | preserve original evidence |
| `UNKNOWN` | unclassified exception/state | fail closed with generic safe code | no until classified |

---
# 6. Human decision register

Research cannot make the decisions below. The conservative state is disabled, T1-only, or fail-closed until the accountable function records the decision. A role name identifies an accountable function, not an assigned person.

| ID | HUMAN DECISION | Accountable role/function | Conservative state until decided | Consequence of delay / blocked work |
|---|---|---|---|---|
| HD-B03-01 | Legal purpose, prohibited uses, employee consultation, source/field/time/identity precision, access, retention, and production data use | Data Controller/Product Governance with Legal/Privacy and Workforce Governance | T1 fictional data only; no live collection | Blocks live source, pilot, production, and any employee/customer-facing interpretation |
| HD-B03-02 | Maximum offline duration, pause/loss policy, and whether any audited lossy terminal state is ever allowed | Product/Risk Authority with Data Owner, Privacy/Legal, SRE, Support, Records | Pause and retain; no automatic unacknowledged loss | Blocks production disk sizing, outage promise, and loss semantics |
| HD-B03-03 | Endpoint DB/WAL/reserve/backup/quarantine budget and logical event/batch quotas | Product Owner and Endpoint SRE/Operations with Finance/Support | deliberately small T1 quotas only | Blocks production pressure profile and estate resource claim |
| HD-B03-04 | Receipt failure-domain classes, server status replay, backup RPO, cleanup grace, and clock uncertainty policy | Ingestion/Data Reliability and SRE with Data Owner/Records/Risk | production cleanup disabled; T1 fixture policy only | Blocks endpoint payload deletion and acknowledged-data restore claim |
| HD-B03-05 | Local data sensitivity, threat actors, encryption assurance, metadata protection, key recovery/escrow, and key-loss consequence | Product Security/Cryptographic Authority with Privacy/Data Controller, Operations, Records | authenticated application encryption prototype; no production provider/escrow | Blocks production key profile, backup recovery, cleanup, and full-DB encryption choice |
| HD-B03-06 | Production SQLite managed/native provider, build/support arrangement, SQLCipher/SEE need, licenses, and commercial support | Architecture/Dependency Security with Legal/Procurement/Support | exact prototype adapter only | Blocks production store/runtime admission |
| HD-B03-07 | Patch SLA, enterprise-management coverage/latency target, and whether an autonomous updater is needed | Product/Risk with Enterprise Endpoint Management and Security | `ENTERPRISE_ONLY` | Blocks autonomous updater; does not block enterprise-only prototype/canary |
| HD-B03-08 | Installer authoring tool, binary/source licensing/EULA, ProductCode/component strategy, enterprise deployment owners | Installer/Endpoint Management with Legal/Procurement | no tool assumed; test MSI only after admission | Blocks production MSI authoring and support contract |
| HD-B03-09 | Code-signing CA, timestamp, certificate profile, revocation behavior, key custody, quorum, ceremonies, emergency authority | Release/Signing/Cryptographic Authority | lab/test signing only | Blocks production-signed release and emergency operations |
| HD-B03-10 | TUF POUF algorithms, role thresholds, expiries, custodians, repository service, root recovery, and client selection | Release Repository Security/Cryptographic Authority | no autonomous updater | Blocks optional updater only |
| HD-B03-11 | Realm definition and governance boundary | Data Controller/Product Governance with IAM, Legal/Privacy, Data Architecture | one fictional isolated realm | Blocks production enrollment, transfer, administration, and data-isolation contract |
| HD-B03-12 | Enterprise CA/MDM/RA/PKI owner and issuance architecture | Enterprise PKI Authority with Endpoint Management, Security, Operations, Procurement | disposable lab CA only | Blocks production enrollment/renewal/revocation |
| HD-B03-13 | Required device-key assurance per platform and allowed A1 software-key exceptions | Product Security Risk Owner with Endpoint Platform/Realm Authority | A1 disabled; A2 prototype target | Can block even the T1 canary if the lab has no qualifying TPM and no lab-only exception |
| HD-B03-14 | Certificate algorithms, sizes, EKU/OID, subject/SAN, chain, lifetime, renewal, overlap, offline grace | PKI/Cryptographic Authority with Security/SRE/Support/Risk | finite lab profile only | Blocks production certificate template and long-offline support |
| HD-B03-15 | Rapid-deny freshness/availability, CRL/OCSP policy, clock tolerance, and lost-device recovery | Identity Service Owner and SRE with PKI/Security Risk | status uncertainty fails closed; no production bound | Blocks identity SLO/capacity/support acceptance |
| HD-B03-16 | Direct/L4 versus L7 gateway, gateway assertion keys/protocol, downstream delegation/token need | Security Architecture with Network/Gateway and API/IAM Owners | direct/L4 only; L7 disabled | Blocks L7 topology and multi-hop delegation; does not block first direct tuple |
| HD-B03-17 | Proxy/PAC/WPAD/VPN/TLS-inspection support policy and named customer network profiles | Customer Network Security with Endpoint Networking/Product Security | direct network only | Blocks proxy/VPN/interception support claims |
| HD-B03-18 | Golden-image owner, specialization event, image scan/promotion, clone/restore policy, duplicate-hold operations | Endpoint Image/Virtualization Authority with Product Security/Asset Management | image before enrollment only; conflict holds all copies | Blocks image-based scale and clone incident automation |
| HD-B03-19 | Supported platform matrix: Windows editions/releases, browser channels/builds, RDP/RDS/AVD, profile providers, ARM64, physical power | Product/Support with Windows, Browser, Virtualization, Accessibility, Operations | one proposed exact T1 tuple only; no support label | Blocks commercial support and every extended tuple |
| HD-B03-20 | EDR/security product/policy classes and any narrow time-bound exclusion | Endpoint Security Authority with Product Security/Support | Defender exact test state, zero UAM exclusions; other products unsupported | Blocks third-party EDR claims; broad exclusion remains prohibited |
| HD-B03-21 | Compatibility evidence validity, cadence, exception authority/duration, deprecation notice, customer readiness and support commitment | Compatibility Authority with Product/Support/Release/Risk | short T1 evidence windows; no commercial support | Blocks `SUPPORTED`, published matrix, and durable exceptions |
| HD-B03-22 | Diagnostic backend, data residency, storage/index/search model, backup, deletion, and vendor/procurement | Observability/Support Platform Owner with Privacy/Security/Legal/Procurement | local T1 bundle only | Blocks production remote diagnostic export/upload |
| HD-B03-23 | Diagnostic access roles, approvals, separation of duties, support hours, escalation, incident communication | Support Operations/IAM/Product Governance with Privacy/Security | no production permit/access | Blocks live support workflow and remote access |
| HD-B03-24 | Diagnostic/support retention, legal hold, rare fingerprint handling, metric cardinality/access, and audit retention | Privacy/Data Governance/Records with SRE/Support | short T1 fixture retention; finite dimensions | Blocks production telemetry and support backend acceptance |
| HD-B03-25 | Support-bundle encryption/recipient/key wrapping, recovery, destination, access, deletion, and case workflow | Cryptographic Authority with Support Platform/Security/Privacy | lab keys and local handoff only | Blocks production bundle upload/decryption |
| HD-B03-26 | Support promise: which failures L1/L2/L3 must solve without raw data and acceptable limitations | Product Support Owner with Engineering/Privacy | only the explicitly tested T1 diagnosable set | Blocks commercial support scope and staffing model |
| HD-B03-27 | SLO/RPO/RTO, capacity, outage/backlog, release deadlines, deny propagation, and restore objectives | Product/Risk and SRE/Operations | no production objectives claimed | Blocks capacity, operational acceptance, pilot, and production |
| HD-B03-28 | Owner assignment, staffing, skills, on-call, incident command, destructive-lab authority, and support coverage | Engineering/Operations Leadership | affected capability disabled if owner absent | Blocks aggregate gate, pilot, and production |
| HD-B03-29 | Budget, licensing, procurement, HSM/KMS/CA/gateway/lab/physical hardware and external support | Product/Finance/Procurement/Legal | no unapproved spend/dependency | Blocks selected technology and sustainable qualification cadence |
| HD-B03-30 | Engineering-canary scope and residual-risk acceptance | Architecture Forum and designated Lab/Risk Authority | no canary | Blocks B03-AGG even after technical evidence |
| HD-B03-31 | Pilot and production go-live/risk acceptance | Designated Production/Risk Authority | T1 disposable lab only | Blocks all pilot/production use |

## 6.1 Human decisions not required to begin pure implementation

The absence of production decisions does **not** block pure contracts/models, T1 fixtures, analyzers, DDL, state machines, package manifests, test-only keys, local support-bundle code, or disconnected lab scripts. It **does** block any behavior that would silently choose a real realm, live data field, production retention, production key/issuer, customer support promise, or production network/platform profile.

---

# 7. CLI experiment and measurement plan

## 7.1 Evidence rules

Every experiment uses T1 fictional data, placeholder connection instructions, lab-only keys/certificates, and an immutable evidence envelope. Production credentials, production signing keys, raw organization activity, internal addresses, actual SSH commands, user/host names, proxy URIs, certificate private material, and customer configuration are prohibited.

Each evidence root MUST record:

```text
source tree digest and dirty-state proof
release/test artifact file manifests and digests
OS image/edition/version/build/UBR and architecture
.NET runtime/source revision and self-contained file inventory
managed SQLite package and loaded native SQLite source ID/compile options/VFS
Edge exact build/channel and source-schema fixture capability
MSI/installer/signature profile and protected ACL/effective access
security product/mode/policy class and exclusion state
session/profile/network/power tuple
fixture/oracle/canary revisions
root seed, schedule, hook/fault and shrink chain
operation history and durable snapshots
first failure and all rerun outcomes
all-sink canary/cardinality results
cleanup/revert receipt and final residue diff
owner/reviewer functions, ADRs and exceptions
```

A passing aggregate omits no failed lane. A rerun does not overwrite the first failure. A cleanup failure is a gate failure.

## 7.2 Ordered experiments

### E03-00 — evidence, toolchain, and artifact inventory

**Classification:** **CLI EXPERIMENT**  
**Purpose:** establish that the exact source, dependencies, native modules, test tools, packages, fixtures, and environment are known before behavior claims.

Required actions:

- produce exact lock/source/package/binary/license records for every candidate;
- hash every MSI, executable, DLL, native library, schema, manifest, fixture, model, checker, and test tool;
- verify production candidate file manifests contain no fault controller, schedule parser, lab key, test CA trust, dynamic plugin, arbitrary command collector, or forbidden dependency;
- capture loaded-module architecture and signatures;
- generate the theoretical metric-series budget from the catalogue.

**Pass:** every shipped/tested byte maps to reviewed source/package and role; production hook/test artifacts are structurally absent; no mixed/unknown architecture; no unreviewed executable dependency.  
**Fail:** mutable tag/image/action, package/source mismatch, unexplained file, hidden native module, test capability in release artifact, license/EULA unresolved for selected use, or missing positive-control scanner.

Evidence: `e03-00-inventory/{environment.json,files.sha256,modules.json,dependencies.json,licenses.json,hook-absence.json,cardinality-bound.json,cleanup-receipt.json}`.

### E03-01 — pure contracts, models, and “harness lies” campaign

**Purpose:** prove closed schemas, state invariants, deterministic replay/shrink, and harness sensitivity before Windows execution.

Required campaigns:

- strict valid/invalid vectors for all contracts in section 5;
- model histories for page/outbox, batch/receipt, release, identity, diagnostic permit, and compatibility;
- property checks for monotonic sequence, tenant narrowing, exact one-match, stable retry identity, no cursor ahead, no ACK before commit, no self-reenable, and no realm/purpose-key crossover;
- mutations that deliberately advance cursor early, mint a retry ID, delete before receipt, accept stale release, trust payload realm, leave permit active, log a canary, accept a broad tuple, skip cleanup, and disable a checker.

**Pass:** same seed produces byte-identical minimal history/capsule; every deliberate defect is detected; no unknown/duplicate/broadening vector is accepted.  
**Fail:** surviving mandatory mutation, nondeterministic expected truth, checker/production common decision code, canary miss, or `HarnessFault` reported as product pass.

Evidence: `e03-01-model/{invariants.yaml,model-coverage.json,mutation-results.json,failure-capsules/,canary-scan.json,cleanup-receipt.json}`.

### E03-02 — executable G5 schema/domain verifier

**Purpose:** prove DDL, singleton binding, realm/install/store keys, constraints, triggers, immutable fields, indexes, schema hash, migration ledger, and domain invariants.

Required campaigns:

- create/open/close synthetic stores for every legal state;
- inject unknown table/column/trigger/index, wrong schema hash, wrong realm/install/store epoch, invalid key reference, duplicate natural key, conflicting digest, invalid batch membership, illegal state transition, and orphan reference;
- verify `STRICT`, foreign keys, trusted-schema/extension/attach policy, pooling off, one writer, and exact native inventory.

**Pass:** all illegal states are rejected or enter hold without progress; legal N/N-1 fixtures open under declared readers/writers.  
**Fail:** silent schema drift, cross-realm row relation, second writer, mutable sealed fields, identity conflict overwrite, or delete/recreate fallback.

Evidence: `e03-02-schema/{ddl.sql,schema-digest.json,domain-verifier.json,invalid-fixtures/,native-inventory.json,cleanup-receipt.json}`.

### E03-03 — deterministic G5 instruction-boundary failpoints

**Purpose:** localize every load-bearing transition.

Minimum hooks:

```text
page.before_begin
page.after_effect_before_outbox
page.after_outbox_before_checkpoint
page.after_checkpoint_before_commit
page.after_commit_before_ack
batch.after_membership_before_bytes
batch.after_bytes_before_seal_commit
attempt.after_prepare_commit_before_socket
transport.after_server_commit_before_response
receipt.after_verify_before_apply
receipt.after_apply_commit_before_cleanup
cleanup.after_payload_clear_before_tombstone
migration.before/after each durable step
checkpoint.before/after sync/reset
key.before/after wrap/unwrap/rotation state
```

At each hook, use finite actions: return error, cancel, wait barrier, kill process, or request controller kill. Reopen the exact store and compare durable truth to the pure checker.

**Pass:** every history is either prior complete state or complete committed state; retry returns the same event/batch/receipt outcome; no cursor-ahead/missing effect; no premature cleanup.  
**Fail:** partial page, mixed sealed batch, new batch after ambiguity, ACK before commit, incompatible overwrite, hidden drop, or unexplained store state.

Evidence: `e03-03-g5-failpoints/<hook>/<seed>/failure-capsule`.

### E03-04 — real crash, service, reboot, VM reset, and power-boundary companions

**Purpose:** prove hooks did not mock away Windows/process/filesystem behavior.

Campaigns:

- hard-kill Coordinator at each G5 stage;
- stop/restart service and logoff/restart session where applicable;
- reboot and VM hard reset during write/checkpoint/migration/activation;
- physical power-interruption lane later for any durability claim that relies on hardware flush, under separate lab authority;
- repeat with clean shutdown and unclean shutdown startup integrity policy.

**Pass:** exact durable state reconciles with checker; store opens or enters explicit integrity hold; current/previous release remains operable; no residue.  
**Fail:** acknowledged local commit absent beyond claimed domain, database accepted after unexplained corruption, launcher selects mixed version, stale permit/channel survives, or cleanup/revert fails.

Evidence: `e03-04-real-crash/{process-lifecycle.ndjson,store-snapshots/,release-state/,integrity.json,cleanup-receipt.json}`.

### E03-05 — disk pressure, WAL/checkpoint, filesystem, and security-product interference

**Purpose:** replace quota/checkpoint/AV assumptions with measurements and prove no silent loss.

Campaigns:

- fill the dedicated test volume through soft/hard reserve, including WAL/checkpoint, receipt write, clean shutdown, migration rollback, bundle generation, and cleanup;
- create checkpoint starvation and long-lived read faults only through test adapters;
- deny/sharing-lock files and inject short/Nth/sticky I/O errors in test builds;
- run exact Defender state with zero UAM exclusions; record scans/holds/quarantine and source/store impact;
- trace product filesystem writes and prove manifest-scoped paths only.

**Pass:** collection pauses before hard reserve; unacknowledged data remains; priority operations have measured reserve; no infinite spin; WAL recovers/holds explicitly; zero unapproved exclusion; no source write.  
**Fail:** drop-oldest/sample path, reserve exhaustion prevents receipt/recovery, unbounded WAL/queue, broad deletion, unexplained source/store mutation, required broad EDR exclusion, or residue.

Evidence: `e03-05-pressure/{thresholds.json,wal-checkpoints.ndjson,logical-ledger.json,filesystem-trace-summary.json,security-profile.json,cleanup-receipt.json}`.

### E03-06 — payload encryption and key lifecycle

**Purpose:** determine whether the selected prototype keeps plaintext out of DB/WAL/backups/ordinary diagnostics and survives key failures safely.

Campaigns:

- encrypt before bind and scan DB/WAL/SHM/backups/quarantine/dumps/logs for exact T1 plaintext canaries;
- verify nonce uniqueness and AAD binding across realm/install/store/object/schema/content;
- test wrong key/provider/ACL, auth-tag failure, key loss, TPM unavailable/clear in a disposable profile, software provider, rotation, old-key decrypt-only, backup restore, and uninstall cleanup;
- prove device-authentication key cannot be used by the data crypto API and vice versa.

**Pass:** no plaintext canary in durable/sink surfaces; failures hold without plaintext fallback; cross-purpose key use is structurally impossible; rotation/restore matches ledger.  
**Fail:** plaintext durable copy, nonce reuse, wrong-realm decrypt, silent fallback, key export, unrecoverable state reported healthy, or leftover key/test trust.

Evidence: `e03-06-crypto/{provider-properties.json,canary-scan.json,nonce-ledger.json,rotation-history.ndjson,restore.json,key-cleanup.json}`.

### E03-07 — migration and N/N-1 rollback matrix

**Purpose:** prove release/storage composition.

For every candidate schema change, run:

```text
N-1 opens N-1 store
N expands store
N writes new and old paths under compatibility contract
N-1 reopens/reads/writes as declared
N resumes/backfills
kill/reboot at every migration step
rollback release activates at higher generation
contract step remains disabled until rollback window closes
pre-migration backup is actually restored and verified
```

**Pass:** both declared versions operate within contract; no event/cursor/receipt/key loss; migration is idempotent; rollback selects complete known-good; store digest/ledger reconciles.  
**Fail:** one-way autonomous change, N-1 unreadable unexpectedly, partial backfill accepted, backup not restorable, or migration deletes/recreates.

Evidence: `e03-07-migration/<migration-id>/{compatibility-matrix.json,failpoints/,restore.json,ledger-diff.json}`.

### E03-08 — enterprise MSI lifecycle and stable privileged boundary

**Purpose:** close the enterprise-only release path without assuming an updater.

Campaigns:

- clean install, repair, minor/major upgrade as selected, rollback, uninstall, reinstall, interrupted install, reboot-required cases, enterprise detection, and service/task/ACL policy refresh;
- effective access by service SID, ordinary user, other session, administrator, installer, and untrusted staging identity;
- verify rollback-enabled MSI behavior and paired custom-action rollback if custom actions exist;
- verify no user-controlled MSI property becomes SYSTEM command/path/script;
- prove uninstall/repair does not delete/reset realm business data unless a separate explicit data-disposition operation is authorized.

**Pass:** exact stable boundary and ACLs after every transition; failed install restores prior operable state; enterprise health detects target digest, not mere MSI presence; no residue.  
**Fail:** mixed bootstrap, rollback disabled, user-writable service/task path, arbitrary elevated input, data loss, or incomplete uninstall/repair.

Evidence: `e03-08-msi/{msi-tables.json,signatures.json,transition-results.ndjson,effective-access/,health-detection.json,cleanup-receipt.json}`.

### E03-09 — package tamper, path, reparse, hard-link, ADS, and launcher campaign

**Purpose:** prove unauthorized/incomplete bytes never execute.

Campaigns:

- wrong/truncated/padded package, missing/extra/swapped DLL, wrong architecture, wrong signer, stale/revoked test cert, changed config/schema, DLL search hijack, case collision, path traversal, reparse/junction race, hard link, alternate data stream, source-handle replacement, activation-slot tear/corruption;
- kill activator/launcher at every copy/flush/state/launch boundary;
- verify previous/baseline fallback independently, not from pointer trust.

**Pass:** no unauthorized byte starts; each interruption leaves one verified known version; current/previous are immutable; bad version is suppressed; repair works.  
**Fail:** executable from staging/user path, hash/signature mismatch ignored, TOCTOU write outside root, mixed module set, lower-sequence activation, or both known versions lost without repair state.

Evidence: `e03-09-release-security/{attack-corpus.json,transition-failures/,executed-image-audit.json,activation-slots.json,cleanup-receipt.json}`.

### E03-10 — autonomous updater decision and conditional TUF lane

**Purpose:** ensure updater work does not become implicit.

Step A measures management-attributable deployment latency using human-approved thresholds. If any required human field is absent or misses are not attributable to management, result is `INELIGIBLE` and updater remains disabled.

Only when eligible, Step B runs:

- exact pinned TUF 1.0.35 POUF/client/conformance and UAM attack corpus;
- root/targets/snapshot/timestamp role compromise/expiry/rollback/freeze/mix-and-match;
- sequential root rotation and less-than-threshold compromise;
- root-threshold compromise requiring out-of-band MSI recovery;
- Fetcher/Activator privilege, proxy, offline, clock, repository, cleanup, and no-self-update lanes.

**Pass:** every TUF and Windows gate passes and updater materially improves the approved metric.  
**Fail:** missing human SLA, mutable conformance input, in-band root-threshold recovery, online sole target authority, updater modifies bootstrap, or operations/owner/cost missing.

Evidence: `e03-10-updater-decision/{measurement.json,decision.json}` and, only if eligible, `tuf/{pouf.json,conformance.xml,attack-results.json,key-drills/,cleanup-receipt.json}`.

### E03-11 — installation key, one-use enrollment, activation, renewal, and cleanup

**Purpose:** prove one installation/realm identity without key export or shared secret.

Campaigns:

- create key after specialization; inspect effective KSP/implementation/export/usage/ACL properties; sign fresh challenge;
- consume one-use bootstrap atomically; replay/expire/wrong audience/wrong realm/parallel attempts;
- issuance timeout/unknown reconciliation; stage certificate; activate only via mTLS proof;
- fresh-key renewal, overlap, old-key retirement, re-enrollment epoch, decommission, uninstall/cleanup;
- optional TPM attestation in exact Enterprise CA lane where available; do not treat it as universal.

**Pass:** private key never exported; token one-use; realm is server-derived; same request id returns same terminal result; only active credential authorizes; old epoch denied; no key/token residue.  
**Fail:** reusable secret, PFX/export, provider name accepted without proof, body realm overrides, duplicate issuance without reconciliation, silent A1 fallback, or cleanup failure.

Evidence: `e03-11-enrollment/{key-properties.json,challenge-results.json,enrollment-history.ndjson,certificate-profile.json,activation.json,renewal.json,cleanup-receipt.json}`.

### E03-12 — revocation, expiry, wrong realm, clone, and status-cache campaign

**Purpose:** prove fail-closed authorization under identity ambiguity.

Campaigns:

- revoke/suspend/deny/decommission/expire while connections exist;
- stale/missing/partitioned deny cache; CRL/OCSP success/failure; clock step/rollback;
- wrong realm/body/header/certificate-subject claims;
- clone software-key disk in T1 lane, duplicate physical/vTPM observations where available, simultaneous and sequential use;
- gateway/header spoofing negative tests if L7 is prototyped.

**Pass:** every new request/stream denies within the declared test bound; existing connection does not grandfather authorization; conflict holds all copies; no automatic winner; generic external errors reveal no identity/realm existence.  
**Fail:** revoked/wrong-realm/old-epoch authorizes, stale cache soft-allows, clone silently selected, or identity header bypasses middleware.

Evidence: `e03-12-identity-faults/{status-timeline.ndjson,cache-results.json,connection-results.json,clone-results.json,realm-negative.json,cleanup-receipt.json}`.

### E03-13 — direct mTLS and certificate/network fault lane

**Purpose:** qualify the first direct network class.

Campaigns:

- valid/invalid server trust, name mismatch, expired/not-yet-valid client/server cert, chain/intermediate rollover, status hold, network cut/latency/response loss, DNS failure, route change, reboot, and retry of the same exact batch;
- prove no certificate-validation bypass callback, no proxy/user credential borrowing, and no identity change on network change;
- server commits then loses response; endpoint replays same batch and receives equivalent receipt.

**Pass:** TLS and identity fail closed; no direct fallback from a configured unsupported path; same stable batch yields one custody/effect; no secret/address in evidence.  
**Fail:** validation disabled, wrong server accepted, new batch minted, receipt before durable stub commit, network location changes realm, or sensitive network detail escapes.

Evidence: `e03-13-direct-network/{tls-matrix.json,network-faults.ndjson,batch-replay.json,receipt-ledger.json,canary-scan.json,cleanup-receipt.json}`.

### E03-14 — separate proxy/L7/VPN/TLS-inspection lanes

**Purpose:** later qualification only; not part of the first tuple.

Each exact profile gets its own environment, product/version/policy, credential source, route/DNS behavior, failover order, certificate behavior, and cleanup. L7 additionally tests duplicate/conflicting headers, request smuggling differentials, signed assertion method/target/body/nonce/audience/expiry binding, backend mTLS, and direct-backend denial.

**Pass:** exact profile works without identity weakening, direct bypass, secret leakage, false receipt, or unbounded resource use.  
**Fail:** user-token borrowing, PAC/script escape, TLS validation disabled, untrusted header accepted, assertion replay, or unsupported path silently falls back.

### E03-15 — telemetry catalogue, analyzers, cardinality, and all-sink canaries

**Purpose:** prove the diagnostics code surface cannot express forbidden data.

Campaigns:

- mutate code to call generic logging, interpolated templates, exception overloads, arbitrary Activity tags, runtime metric/span/event names, unknown attributes, baggage, HTTP logging, WER/dump APIs, file collectors, and dynamic OTTL/config;
- feed adversarial distinct values to every instrument and calculate actual/theoretical series;
- run all-sink canaries across journal, stdout/stderr, logs, metrics, traces, access logs, Collector, backend stub, support bundle, crash paths, test results, and evidence;
- pin Collector distribution/config; explicitly set processor/connector error behavior and reject unknown attributes.

**Pass:** build/runtime rejects every forbidden sink/value; positive controls are detected; series stay within declared T1 budget; no endpoint traces/dumps at D0.  
**Fail:** dynamic/sensitive field accepted, unknown field silently ignored, Collector default weakens behavior, canary miss, unbounded cardinality, or dump created.

Evidence: `e03-15-diagnostics-controls/{catalogue.json,analyzer-mutations.json,series-bound.json,runtime-cardinality.json,all-sink-canary.json,collector-config-digest.json}`.

### E03-16 — diagnostic permit, support bundle, expiry/revocation, and blind-support exercise

**Purpose:** close B03-DIAG without raw data.

Campaigns:

- valid/invalid/wrong-realm/wrong-target/wrong-release/stale/downgraded/expired/revoked permits;
- D0→D1/D2→D0 transitions across restart, clock step, kill, and network outage;
- deterministic bundle build twice from the same safe snapshot; unknown entry, oversize, duplicate/case-collision, canary, encryption failure, upload loss, deletion failure;
- give a support operator the sanitized bundle and a predefined failure set without implementation internals or raw fixture values; require correct classification/runbook.

**Pass:** enhanced mode cannot outlive permit; bundle plaintext never touches disk; byte-identical canonical inputs produce declared deterministic content before randomized encryption; canaries/unknowns block; operator solves the defined set; deletion/cleanup proved.  
**Fail:** hidden D3/raw field, arbitrary collector, wrong realm/target, permit self-extension, plaintext residue, unresolved defined failure, or access/delete audit gap.

Evidence: `e03-16-support/{permit-matrix.json,mode-timeline.ndjson,bundle-manifest.json,plaintext-residue-scan.json,encryption-interop.json,blind-support-scorecard.json,cleanup-receipt.json}`.

### E03-17 — exact compatibility inventory, evaluator, package, and first-tuple lane

**Purpose:** close the internal platform claim.

Campaigns:

- read-only bounded inventory with no raw paths/users/addresses/policy text/activity;
- exact package architecture/PE/module/signature/SBOM/provenance checks;
- manifest sequence/expiry/kill/zero/multiple-match tests;
- predecessor evidence binding to exact source tree/package/environment;
- execute G1 session/IPC, G2/G3 Edge acquisition/source, G4 privacy, G5 storage, release, identity, direct network, diagnostics, resource, and cleanup lanes for the narrow tuple;
- run near-miss negatives: adjacent UBR, Edge build, Education edition, RDP, proxy, temporary profile, unexpected module, Defender policy change.

**Pass:** exact tuple alone yields `QUALIFIED`; every near miss yields no permit; all required evidence is current and content-bound; no raw inventory; no primary failure; complete cleanup.  
**Fail:** family/major-only support, closest match, stale evidence, unsupported combination collects, package/module mismatch, or cleanup residue.

Evidence: `e03-17-compatibility/{inventory.json,package-validation.json,manifest.json,evaluator-matrix.json,evidence-index.json,prompt-14-gate.json,cleanup-receipt.json}`.

### E03-18 — aggregate Batch 03 gate

The aggregator is a pure strict validator over signed/content-addressed evidence; it executes no product work and accepts no manual “pass” field.

```text
B03_ENGINEERING_CANARY_ELIGIBLE =
    BATCH01_REQUIRED_EVIDENCE_CURRENT
    AND BATCH02_REQUIRED_EVIDENCE_CURRENT
    AND E03_00_TO_E03_09_REQUIRED_PASS
    AND E03_11_TO_E03_13_REQUIRED_PASS
    AND E03_15_TO_E03_17_REQUIRED_PASS
    AND (AUTONOMOUS_UPDATE_DISABLED OR E03_10_FULL_PASS)
    AND ZERO_PRIMARY_INVARIANT_FAILURES
    AND ZERO_CANARY_ESCAPES
    AND ZERO_CROSS_REALM_OR_CROSS_SESSION_ACCEPTS
    AND ZERO_UNAUTHORIZED_EXECUTIONS
    AND ZERO_UNACKNOWLEDGED_SILENT_LOSS
    AND ZERO_CLEANUP_FAILURES
    AND ALL_BLOCKING_OWNER_FUNCTIONS_ASSIGNED
    AND REQUIRED_LAB/CANARY_HUMAN_SCOPE_RECORDED
    AND EVIDENCE_AND_MANIFESTS_UNEXPIRED
```

**Pass artifact:** `batch-03-gate.json` containing exact input digests, per-gate status, first failures, exceptions, owners, expiry, tuple ID, `engineeringCanaryEligible`, and an explicit `productionApproved=false`.

**Fail behavior:** no partial canary. The failed lane and every dependent lane stop. A broader tuple, production support, or production use cannot be inferred from a pass.

## 7.3 Batch gate evidence retention and confidentiality

Shareable evidence contains finite codes, counts, digests, exact public software versions, fictional IDs, sanitized environment classes, and cleanup receipts. Restricted raw traces/dumps, if a destructive lab explicitly needs them, remain in the disposable lab and are never normal Batch 03 evidence. Test certificate serials, private keys, actual proxy/internal addresses, SSH configuration, and real profile/activity values are never exported.

---
# 8. Threat, failure, and recovery gaps

## 8.1 Consolidated register

| ID | Threat/failure | Current gap | Required containment/recovery | Gate/owner |
|---|---|---|---|---|
| T03-01 | OS/filesystem/firmware falsely reports durable flush | SQLite cannot detect lying storage; VM reset is not physical power proof | WAL/FULL, conservative checkpoints, exact estate tests, physical lane for hardware claim, receipt/backup containment, no zero-loss overclaim | B03-G5; Endpoint Storage/SRE |
| T03-02 | SQLite/provider/native regression | Exact provider/native build and compile profile not selected; recent SQLite history shows serious WAL bugs can exist | source ID/module pin, advisory watcher, startup inventory, G5 rerun on change, safety hold on mismatch | B03-G5/B03-COMPAT; Dependency/Storage |
| T03-03 | Business DB corruption or key loss | No production backup/RPO/key-recovery decision | quarantine original, no auto salvage/recreate, verified backup/restore and receipt reconciliation, explicit unconfirmed loss state | HD-B03-04/05; Storage/Incident |
| T03-04 | Disk pressure or long outage | No approved quota/offline/loss policy | reserve, pause/backpressure, value-free health, no silent unacknowledged deletion, explicit human terminal policy only | HD-B03-02/03; Product/SRE |
| T03-05 | Batch response lost after server commit | Real ingestion failure domain not yet implemented | durable attempt before send, exact byte replay/status query, stable batch/event uniqueness, matching receipt only | B03-G5; Endpoint/Ingestion |
| T03-06 | Receipt implementation overclaims custody | Synthetic stub cannot prove production failure domain | later durable-inbox gate, explicit allowed failure-domain classes, receipt replay, backup/restore evidence before cleanup | Global gate 9/12; Ingestion/Data Reliability |
| T03-07 | One-way migration defeats rollback | Every real schema change is future evidence | shared storage compatibility artifact, expand/backfill, N/N-1 matrix, enterprise epoch for destructive change | B03-REL/G5; Release/Storage |
| T03-08 | Malicious or compromised release authority | Authenticode/TUF can authorize malicious bytes if authorized humans/keys are compromised | independent source/build/provenance/signing/release approval, thresholds where chosen, kill/rollback, OOB repair; governance residual remains | B03-REL; Release/Security |
| T03-09 | Root-threshold or bootstrap compromise | Cannot be safely recovered by same in-band trust | enterprise OOB signed MSI/root replacement, block payload, incident drill; no in-band “repair” claim | Conditional updater gate; Signing/Enterprise Management |
| T03-10 | Staging parser/reparse/TOCTOU becomes SYSTEM write | Exact Windows filesystem composition unproved | low-privilege extraction, opened-handle verification/copy, exclusive creation, protected final recheck, hostile race campaign | B03-REL; Windows Security |
| T03-11 | Enterprise deployment misses urgent patch objective | No approved objective or measurement | remain enterprise-only; collect value-free timestamps; authorize updater only on repeated attributable miss and full gate | HD-B03-07; Product/Endpoint Management |
| T03-12 | Private key copied/exported or enrollment token reused | Exact KSP/ACL/installer/MDM behavior unknown | no export/PFX APIs, service-SID ACL, fresh proof, one-use atomic token, cleanup, architecture scan | B03-ID; Identity/Windows Security |
| T03-13 | Local admin/kernel/hypervisor misuses valid key | TPM/nonexportability does not stop authorized malicious code or hypervisor | narrow key/credential, status/rotation/revocation, signed release, incident response; explicitly out of assurance where applicable | Residual; Product Security/Risk |
| T03-14 | TPM clear, motherboard replacement, vTPM copy, CA outage | Estate/recovery behavior unknown | fail closed, one-use re-enrollment/epoch, no silent A1 fallback, platform-specific runbook and human recovery decision | B03-ID/HD-B03-13/14; PKI/Endpoint |
| T03-15 | Clone used sequentially and evades concurrency signal | No universal privacy-safe hardware oracle | duplicate-hold on evidence/operator report, short credentials, attestation where chosen, MDM lifecycle, accept residual uncertainty | Residual; Product Security/Asset Management |
| T03-16 | Revoked credential continues on live HTTP/2/3 connection | Status/revalidation implementation unproved | request/stream-start status lookup, bounded deny cache, connection close as defense in depth, stale fails closed | B03-ID; Identity/Gateway/SRE |
| T03-17 | Gateway trusts spoofed identity header/request differential | L7 profile not implemented | direct/L4 first; if L7, strip all variants, backend mTLS, signed request-bound assertion, smuggling/replay tests | Later network tuple; Security/Gateway |
| T03-18 | Proxy/PAC/TLS interception leaks or bypasses controls | Exact enterprise networks unknown | direct first; explicit profiles only; no silent direct fallback; no TLS bypass; future PoP only after ADR/interoperability | Later network tuple; Network/Product Security |
| T03-19 | Browser/Windows update changes schema/session/filesystem behavior | Vendor cadence outpaces broad static claims | exact tuple, sentinel lanes, evidence expiry, source capability, kill switch, no automatic inheritance | B03-COMPAT; Compatibility/Browser/Windows |
| T03-20 | RDS/AVD/FSLogix/Citrix same-source concurrency loses or misattributes visits | No integrated platform evidence; shared DB cannot prove origin session | one source/lease, no origin attribution, exact profile/provider lane, unsupported until pass | Later platform tuple; Virtualization/Source |
| T03-21 | EDR injects, quarantines, captures memory, or needs exclusion | First exact policy unproved; third-party estate unknown | Defender zero-exclusion core lane, exact product/policy tuples, prefer code/vendor fix, narrow expiring exception only | B03-COMPAT/DIAG; Endpoint Security |
| T03-22 | Diagnostics code bypasses catalogue | New sink/API can leak despite design | analyzers, architecture rules, canaries, generated catalogue, review, no generic overload, all-sink scans | B03-DIAG; Observability/Privacy |
| T03-23 | OTel Collector default silently ignores transform/filter error | Current upstream release changed defaults | custom pinned distribution/config, explicit propagate/reject behavior, startup config test, unknown attribute rejection | B03-DIAG; Observability Platform |
| T03-24 | Generic HTTP/trace conventions capture URL/path/header/address/query/SQL | Library conventions are broader than UAM | manual UAM wrappers/allowlist, disable broad auto-instrumentation, safe route-template logs, no baggage | B03-DIAG; Application/Privacy |
| T03-25 | WER/.NET/EDR captures process memory | External enterprise settings can override UAM assumptions | dumps off, detect UAM-specific LocalDumps config, SafetyHold, lab-only raw dump permit, customer readiness check | B03-DIAG/CN; Endpoint Security |
| T03-26 | Support permit remains active after expiry/restart/clock change | State machine unproved | signed monotonic permit, trusted clock class, restart reset/revalidation, revocation/kill, cleanup scan | B03-DIAG; Support Access/Diagnostics |
| T03-27 | Support bundle contains forbidden/extra entry or plaintext residue | Encryption/backend profile unresolved | closed entry catalogue, in-memory plaintext, schema/canary scan, authenticated encryption, manifest-scoped deletion | B03-DIAG/HD-B03-25; Support/Security |
| T03-28 | Support operator cannot solve a necessary failure without raw data | Supportability is a hypothesis | blind T1 exercise; add safe finite signal or narrow support promise; never add raw escape by default | B03-DIAG; Product Support/Engineering |
| T03-29 | Cross-realm diagnostic search/case lookup | Backend not selected | realm as protected authorization/index key, case-scoped aliases, negative tests/audit, no realm metric label | Production diagnostics gate; IAM/Support Platform |
| T03-30 | Compatibility evaluator accepts closest/multiple/stale match | No implementation evidence | pure independent evaluator, exact one-match, strict schemas, expiry/kill/monotonicity tests | B03-COMPAT; Compatibility Authority |
| T03-31 | Evidence or manifest expires between qualification and canary | Validity windows/cadence not decided | gate checks time/evidence immediately before run; no grace; regenerate/review under higher sequence | B03-AGG/HD-B03-21; Release/Compatibility |
| T03-32 | VM evidence is promoted to physical/ARM64/power support | Lab strata can be confused | manifest records lane/evidence class; physical/ARM64/power claims require their own lane; architecture gate rejects promotion | B03-COMPAT; Lab/Compatibility |
| T03-33 | Test harness gives false confidence | Model/checker/common assumptions or flaky real tests | independent oracle/checker, mutations, hand histories, harness-lies campaign, first-failure retention, real companions | All CLI gates; Verification |
| T03-34 | Destructive lab tool or test hook reaches production | High-impact test capabilities are security-sensitive | separate artifacts/runners, binary/SBOM/manifest absence checks, no control-plane route, cleanup/revert | E03-00/01; Build/Verification |
| T03-35 | Unresolved license/EULA or unsupported OSS becomes load-bearing | Several recommendations are references or missing immutable proof | classifications in section 11, admission records, exact pin, removal path; no implicit dependency | B03-REL/DIAG/COMPAT; Dependency/Legal |
| T03-36 | Later restore/deletion/capacity assumptions are mistaken for current proof | Batch 03 models them but has no executed global evidence | preserve gate sequence; no production cleanup/restore/capacity claim; later identical benchmark/drills | Global gates 9–12; Architecture/SRE |

## 8.2 Recovery hierarchy

Recovery MUST choose the narrowest authority that preserves evidence and accepted invariants:

1. retry the same stable operation identity when the outcome is transient or ambiguous;
2. revalidate active signed policy, compatibility, identity, and release state;
3. restart the affected unprivileged/ordinary product process under the same verified release;
4. select the recorded previous known-good payload through the stable launcher;
5. repair the MSI-owned bootstrap through enterprise deployment;
6. re-enroll with a one-use recovery authorization and new key/epoch when identity is lost/compromised;
7. restore a verified hidden endpoint/server backup and reconcile receipts/tombstones before readiness;
8. quarantine corrupt/uncertain evidence and require incident authority;
9. use out-of-band enterprise root/bootstrap recovery after root-threshold compromise.

Recovery MUST NOT invent custody, mint a new business identity for an ambiguous operation, weaken TLS/release/realm checks, silently fall back to plaintext/software identity, delete the store, or make raw diagnostics available.

---

# 9. ADR create/update list

## 9.1 Batch 03 ADR register

| ADR | Decision/action | Proposed status | Evidence/review trigger |
|---|---|---|---|
| ADR-B03-001 | One realm-bound G5 store, one writer, atomic page effect/progress, immutable batch, durable prepared attempt, authenticated custody receipt, no silent unacknowledged loss | **Create — accept logical architecture; CLI gate open** | E03-02–05; any schema/provider/receipt/cleanup change |
| ADR-B03-002 | Authenticated payload protection before SQLite bind; purpose-separated data keys; exact AES/CNG/TPM/software/escrow/full-DB profile deferred | **Create — accept boundary, defer profile** | E03-06; HD-B03-05/06; crypto/provider/threat change |
| ADR-B03-003 | One `EndpointStorageCompatibility` artifact and expand/backfill/N/N-1 policy; destructive epoch is enterprise maintenance | **Create — accept** | E03-07; any endpoint schema/key format change |
| ADR-B03-004 | UAM-owned invariant registry/models/checkers/seeds/shrinks/failure capsules; deterministic hooks plus real-boundary companions; production hook absence | **Create — accept** | E03-00/01; new invariant/fault boundary or testing tool |
| ADR-B03-005 | MSI/enterprise deployment owns stable privileged boundary; default update mode `ENTERPRISE_ONLY` | **Create — accept** | E03-08/09; measured updater decision trigger |
| ADR-B03-006 | Optional updater is Fetcher + no-network Activator and requires TUF 1.0.35 POUF/conformance/OOB recovery; no TUF requirement for MSI-only path | **Create — conditional/deferred** | E03-10 and HD-B03-07/10; TUF/client/updater change |
| ADR-B03-007 | Immutable side-by-side payloads, exact manifest/AuthentiCode, A/B activation, higher-sequence rollback, current/previous/baseline verification | **Create — accept logical model; CLI gate open** | E03-08/09; launcher/filesystem/signing/storage change |
| ADR-B03-008 | Per-installation asymmetric identity, one-use realm-bound enrollment, server-derived realm/epoch/status, TPM preferred, A1 exception only, clone hold, transfer by decommission/new enrollment | **Create — accept prototype architecture; human/CLI gates open** | E03-11/12; HD-B03-11–15/18; PKI/platform change |
| ADR-B03-009 | Direct/L4 mTLS default; current status per request; L7 only with sanitized request-bound assertion and backend mTLS; proxy/TLS/VPN profiles separate | **Create — accept default, condition alternatives** | E03-13/14; network/gateway requirement/change |
| ADR-B03-010 | Closed compile-time diagnostic catalogue, UAM-only telemetry profile, Coordinator-owned bounded journal, endpoint traces/dumps off, explicit Collector fail behavior | **Create — accept** | E03-15; new signal/sink/library/backend |
| ADR-B03-011 | Signed D0–D2 diagnostic permit and deterministic privacy-safe support bundle; local blind-support gate; no general collector/remote shell | **Create — accept architecture; production backend deferred** | E03-16; HD-B03-22–26; bundle/access change |
| ADR-B03-012 | Exact rolling `PlatformCompatibilityManifest`, one-match/expiry/kill, `QUALIFIED` distinct from `SUPPORTED`, no automatic version inheritance | **Create — accept** | E03-17; OS/browser/runtime/security/profile change |
| ADR-B03-013 | First engineering-canary tuple is one exact Win11 Enterprise 25H2 x64/Edge Stable/console/local-profile/Defender/direct-mTLS environment | **Create — proposed candidate, not support** | E03-17/18; HD-B03-19/20/21/30; lab evidence |
| ADR-B03-014 | Separate machine bootstrap/release/control, realm business, and diagnostic durable state; G5 store created only after active realm identity | **Create — accept** | lifecycle/store/control-plane change |
| ADR-B03-015 | Common signed-control envelope properties with strict purpose/key/audience/realm/sequence/expiry separation; tenant/local controls only narrow | **Create — accept security properties, defer crypto profile** | Batch 01 crypto ADR; any artifact/key/control change |
| ADR-B03-016 | OSS/reference classification and dependency admission: immutable revision, license/EULA, maintenance/tests/security, fit, isolation, provenance, removal path | **Create — accept** | every new/updated package/tool/reference |
| ADR-B03-017 | First aggregate gate requires current Batch 01/02 evidence, all five Batch 03 gate families, zero primary failures/canary escapes/cleanup failures, owners, and T1 scope | **Create — accept** | gate-schema or predecessor evidence change |
| ADR-B03-018 | Release/identity/compatibility expiry may stop new collection/upload while preserving current verified repair/health and committed data; no authority is inferred from LKG bytes alone | **Create — accept conservative rule** | offline/clock/expiry human decision or incident evidence |
| ADR-B03-019 | EDR default is zero UAM exclusions; every supported product/policy is an exact tuple; broad exclusions prohibited | **Create — accept** | exact security-product lane or human exception |
| ADR-B03-020 | Remote production diagnostics backend, support access, retention, bundle crypto, and commercial support are separate human/production gates, not canary prerequisites | **Create — accept scope boundary** | HD-B03-22–26 or production architecture change |

## 9.2 Predecessor ADR updates

| Predecessor area | Required update |
|---|---|
| Batch 01 contract/control-artifact ADR | Add `artifactType`/key-purpose separation and the common envelope security properties; do not select an exact algorithm/quorum silently. |
| Batch 01 repository/release ADR | Add Batch 03 production-hook absence, exact native-module inventory, and enterprise-only versus optional-TUF path distinction. |
| Batch 01 Windows G1 ADR | Bind compatibility evidence and release digest to session/IPC claims; preserve exact-session negative gate. |
| Batch 01 privacy/permit ADR | Add diagnostics permit and compatibility/kill artifacts as narrowing-only authorities; no diagnostic level outside product ceiling. |
| Batch 02 page/G5 handoff ADR | Replace “later G5” placeholder with ADR-B03-001 transaction/identity/ACK semantics and `EndpointStorageCompatibility`. |
| Batch 02 source/interpretation ADR | Add exact platform tuple/source capability expiry and no automatic reinterpretation under servicing updates. |
| Release topic ADR-011-004/005 | Clarify dual TUF + Authenticode is blocking for autonomous update; enterprise-only MSI uses its own independent enterprise/release/signing controls. |
| Diagnostics topic ADR set | Add explicit Collector `error_mode`/unknown-attribute fail-safe configuration and local blind-support canary path. |
| Compatibility topic ADR set | Narrow first candidate tuple and distinguish internal canary qualification from published `SUPPORTED`. |

No predecessor ADR may be silently marked accepted solely because this file recommends an update. The architecture forum must record acceptance/rejection and owner/review trigger.

---

# 10. Ordered implementation backlog and dependency/stop gates

| Order | Backlog item | Dependencies | Deliverable | Stop/go rule |
|---:|---|---|---|---|
| 1 | Record the eleven-file evidence manifest and this review digest | none | repository evidence record | Stop on missing/extra Project input or hash mismatch |
| 2 | Create ADR-B03-001 through ADR-B03-020 and predecessor update actions | 1 | ADR files with owner/review trigger and `UNASSIGNED` markers | No implementation may imply an unaccepted human/crypto/support choice |
| 3 | Consolidate human-decision register and assign blocking owner functions | 2 | decision/owner matrix | Pure work may continue; lab/canary stops when required owner absent |
| 4 | Define strict cross-topic schemas/contracts from section 5 | Batch 01 contracts, 2 | schemas, catalogue, valid/invalid vectors | Stop on generic extension bag, payload realm authority, unbounded field, or duplicate truth |
| 5 | Implement pure state models and independent checkers | 4 | models M-G5/M-REL/M-ID/M-DIAG/M-COMPAT | Stop on common decision code or mandatory mutation survivor |
| 6 | Implement seed/history/shrink/failure-capsule/evidence/cleanup formats | 5 | verification libraries and T1 fixtures | Stop on nondeterminism, real data, overwritten first failure, or optional cleanup |
| 7 | Implement machine bootstrap/control-state model and lifecycle | 4–6 | install/enroll/release/control state module | Stop if activity/outbox can exist before realm binding |
| 8 | Implement G5 DDL/domain verifier and one-writer adapter | 4–7, Batch 02 page contract | synthetic store prototype | Stop on second writer, schema drift, cross-realm relation, or raw input type |
| 9 | Implement page/batch/attempt/receipt state machines and deterministic hooks | 8 | T1 end-to-end local durability prototype | Stop on cursor-ahead, batch mutation, ACK inference, or hook route in production |
| 10 | Implement payload-crypto abstraction with strict key-purpose types | 8–9 | T1 software-CNG profile and optional TPM experiment adapter | Stop on plaintext durable sink, export, key reuse, or fallback |
| 11 | Implement migration/backup/quarantine/recovery prototype | 8–10 | N/N-1 fixtures and restore verifier | Stop on destructive autonomous step, auto salvage/recreate, or unverified backup |
| 12 | Implement release manifest, stable launcher verification, A/B slots, storage compatibility | 4–11, Batch 01 repo | test-signed immutable payload prototype | Stop on staging/user-path execution, mixed files, or competing storage truth |
| 13 | Select/admit a test MSI tool and build enterprise-only package | 12, HD-B03-08 lab scope | disposable test MSI, tables/static analysis | Stop on licensing/EULA gap, rollback disablement, arbitrary elevated input |
| 14 | Implement MSI lifecycle/repair/rollback/cleanup harness | 13 | E03-08 evidence | Stop on mixed boundary, data reset/loss, or residue |
| 15 | Implement release-tamper/reparse/path/launcher harness | 12–14 | E03-09 evidence | Stop on unauthorized execution or prior-version loss |
| 16 | Implement installation identity/one-use enrollment state and lab server | 4–7, 12 | disposable CA/identity stub, no production trust | Stop on shared secret, export, payload realm, or silent A1 fallback |
| 17 | Implement direct mTLS authenticated context and status service stub | 16 | E03-11–13 harness | Stop on stale/wrong-realm/revoked authorization or false receipt |
| 18 | Implement closed diagnostics catalogue, wrappers, analyzers, bounded journal | 4–7 | no-raw D0 prototype | Stop on generic logging/object/exception/dynamic metric/span API |
| 19 | Implement diagnostic permit and deterministic support bundle | 18 | D1/D2 local bundle prototype | Stop on D3/raw path, arbitrary collector, plaintext temp, or wrong target |
| 20 | Implement compatibility manifest/evaluator/inventory and exact package validator | 4–19 | pure/static E03-17 components | Stop on closest/multiple match, raw inventory, stale evidence, or mixed architecture |
| 21 | Run E03-00 through E03-03 in trusted CI | 1–20 | inventory/model/schema/failpoint evidence | Any primary failure stops Windows campaigns |
| 22 | Prepare placeholder-only disconnected Windows lab scripts | 21 | read-only inventory/install/fault/cleanup plans | Stop if actual connection/user/host/address/key/config enters evidence |
| 23 | Obtain lab authority, exact first tuple, licenses, test keys, owner assignments | 3, 22, HD-B03-13/19/20/30 | approved T1 lab scope | No Windows connection/canary without recorded scope |
| 24 | Run read-only exact environment inventory and bind Batch 01/02 evidence | 23 | sanitized tuple/evidence index | Stop if predecessor evidence absent/stale/mismatched |
| 25 | Run E03-04 through E03-07 G5 real-fault/pressure/crypto/migration lanes | 21–24 | G5 gate evidence | Any cursor/effect/loss/corruption/key/cleanup failure stops release/identity integration |
| 26 | Run E03-08 and E03-09 MSI/release lanes | 25 | enterprise-only release gate evidence | Any unauthorized/mixed release or repair/cleanup failure stops identity/canary |
| 27 | Run E03-11 through E03-13 identity/direct-network lanes | 26 | identity/network gate evidence | Any shared/exported/wrong-realm/revoked/clone bypass stops canary |
| 28 | Run E03-15 and E03-16 diagnostics/support lanes | 27 | supportability gate evidence | Any canary/raw/cardinality/permit/bundle/blind-support failure stops canary |
| 29 | Run E03-17 exact compatibility/first-tuple lane | 25–28 | `prompt-14-gate.json`, tuple `QUALIFIED` or failed | No broad/near-match support; no pass with expired evidence |
| 30 | Run E03-18 aggregate gate | 1–29 | `batch-03-gate.json` | All terms must pass; no partial canary |
| 31 | Human architecture/lab review of aggregate gate and residual risk | 30, HD-B03-30 | signed canary decision with `productionApproved=false` | No engineering canary without explicit scope/owner/rollback/support |
| 32 | Execute one T1 engineering canary on the exact qualified tuple | 31 | canary evidence, kill/rollback/support/cleanup | Stop on first primary failure; tuple returns to `SAFETY_HOLD` |
| 33 | Decide whether evidence justifies updating the main technical baseline | 32 | baseline change/acceptance record | Update only the exact proven decisions/tuple; no production implication |
| 34 | Measure enterprise deployment latency only after approved patch objective exists | HD-B03-07 | updater decision evidence | Autonomous update remains disabled when any term unknown/false |
| 35 | If updater eligible, implement and run E03-10 full TUF/Fetched/Activator/OOB lane | 34, HD-B03-09/10/29 | conditional updater ADR decision | Stop on any TUF/root/privilege/operations failure |
| 36 | Add separate explicit-proxy/RDP/Extended Stable/Education/physical power lanes in that order of business need | exact owner/demand + 32 | new exact tuples | No inheritance from first tuple |
| 37 | Add ARM64, RDS/AVD/FSLogix/Citrix, third-party EDR, PAC/TLS/VPN, Chrome/Firefox only through separate ADRs/lanes | human scope, lab, prior core pass | per-profile evidence/manifest entries | Unsupported until exact pass; no generic family claim |
| 38 | Later global gates: durable inbox, capacity, long outage, deletion/restore, extended fidelity | global suite order | separate review results | Batch 03 evidence is prerequisite/input, not substitute |

## 10.1 Critical stop/go summary

1. **GO** for orders 1–22 using pure/T1 work and disconnected scripts.
2. **STOP** before connecting to the Windows lab without exact T1 scope, owner, tuple, license, and key decisions required for that lane.
3. **STOP** dependent work on the first primary invariant, canary escape, cross-session/realm acceptance, unauthorized execution, identity bypass, or cleanup failure.
4. **GO** to an engineering canary only after `batch-03-gate.json` is a strict pass and human canary scope is recorded.
5. **STOP** before `SUPPORTED`, pilot, or production; those require additional human and later global gates.

---
# 11. Source and open-source quality corrections

## 11.1 Current primary-source verification

The table records point-in-time facts verified for this review. Exact versions belong in release/evidence manifests and must be rechecked at execution time; they are not timeless architecture.

| Ref | Primary source, reviewed date/version | Verified fact | Batch 03 correction/limitation |
|---|---|---|---|
| W01 | [SQLite release history](https://www.sqlite.org/changes.html), reviewed 31 Jul 2026; **3.53.4**, released 24 Jul 2026; source ID `bf7c7f30031888f4e796e429ab3978879485813aaca6f641c7b33e4e09459bcc` | 3.53.4 is the current recorded release and exact source ID. The history also records the WAL-reset corruption fix in the 2026 release line. | Record and verify the loaded native source ID; a managed package version is not native-engine proof. Every native change reopens G5 and compatibility evidence. |
| W02 | [SQLite WAL documentation](https://www.sqlite.org/wal.html), updated/current at review | WAL permits concurrent readers but one writer; `synchronous=FULL` syncs WAL on each commit; default auto-checkpoint is about 1,000 pages and can run on a committing thread; WAL requires same-machine shared memory. | Accept one writer/WAL/FULL and application-owned checkpoint as the first G5 profile. Do not claim network-filesystem support or leave checkpoint behavior implicit. |
| W03 | [SQLite PRAGMA documentation](https://www.sqlite.org/pragma.html#pragma_synchronous), current at review | In WAL mode, `FULL` adds a WAL sync after each commit and is documented ACID; `NORMAL` can lose recent committed transactions on power loss; `EXTRA` is not stronger than `FULL` in WAL. | Reject `NORMAL` for G5 unless a baseline change supplies an equivalent durability mechanism and human risk decision. Do not create a fake separate `EXTRA` profile. |
| W04 | [SQLite corruption guidance](https://www.sqlite.org/howtocorrupt.html), current at review | SQLite must trust OS/hardware sync behavior; WAL is more forgiving, but checkpoint sync failure can corrupt. Removing/separating WAL from the DB can lose committed data or corrupt. | Runtime proof cannot promise durability against lying firmware or mishandled file sets. Preserve DB/WAL/SHM as one state and use actual recovery/restore evidence. |
| W05 | [Microsoft.Data.Sqlite.Core 10.0.10 package](https://www.nuget.org/packages/Microsoft.Data.Sqlite.Core/10.0.10), reviewed 31 Jul 2026 | `Microsoft.Data.Sqlite.Core` is the managed ADO.NET provider and does **not** bring a native SQLite binary automatically. | Treat managed adapter and native SQLite as separate dependency/admission records. The topic’s exact provider recommendation is not complete without the native bundle/source/compile profile. |
| W06 | [TUF specification](https://theupdateframework.github.io/specification/latest/), **1.0.35**, modified 15 Jul 2026 | Current reviewed spec version is 1.0.35 and defines the role/metadata workflow used by I03. | It is the normative design basis only if autonomous update is enabled. The architecture must not freeze 1.0.35 forever; a POUF and exact client/conformance evidence select the execution version. |
| W07 | [Windows 11 release information](https://learn.microsoft.com/en-us/windows/release-health/windows11-release-information), reviewed 31 Jul 2026 | Windows 11 26H1 is scoped to new devices and is not offered as an in-place update from 24H2/25H2. | Reject a single “Windows 11 current” equivalence class. 26H1/ARM64/new-device behavior is a separate tuple/lane. |
| W08 | [Microsoft Edge release schedule](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-release-schedule), reviewed 31 Jul 2026 | Starting with Edge 152, Stable moves to a two-week major cadence; managed Extended Stable remains eight weeks. | A browser-major or timeless “current/previous” claim will age faster. Exact builds and source capability require sentinel/evidence expiry. Extended Stable is not automatically safer. |
| W09 | [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy), reviewed 31 Jul 2026 | At review time supported patch lines include .NET 10.0.10, 9.0.18, and 8.0.29. | Record the exact execution-time supported patch; do not hardcode these values into architecture. |
| W10 | [.NET publishing overview](https://learn.microsoft.com/en-us/dotnet/core/deploying/), updated 28 Oct 2025 and reviewed 31 Jul 2026 | Self-contained deployments are platform-specific, include the runtime, do not roll forward to newer security patches, and require a new application release to update the runtime. | Native self-contained x64 is a good first qualification profile, but UAM accepts patch/release responsibility and must republish/requalify. |
| W11 | [Microsoft TPM key attestation](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/component-updates/tpm-key-attestation), reviewed 31 Jul 2026 | The documented AD CS feature requires Microsoft Platform Crypto Provider, supports RSA for the attested profile, is not supported on a standalone CA, and does not support non-persistent certificate processing. | Do not turn AD CS TPM attestation constraints into universal UAM crypto architecture. A2 key proof and optional A3 attestation are distinct; exact issuer/profile is human-owned. |
| W12 | [Microsoft Defender Antivirus exclusions overview](https://learn.microsoft.com/en-us/defender-endpoint/microsoft-defender-antivirus-exclusions-overview), reviewed 31 Jul 2026 | Microsoft states each exclusion is a protection gap and recommends narrowly scoped, specific use. | Default zero UAM exclusions is correct. No broad profile/drive/process-tree exclusion can be normalized as compatibility. |
| W13 | [OpenTelemetry sensitive-data guidance](https://opentelemetry.io/docs/security/handling-sensitive-data/), reviewed 31 Jul 2026 | The strongest prevention is not collecting data that may be sensitive; post-processing is a secondary measure. | Application/source minimization remains the privacy boundary. Collector filtering/redaction cannot authorize raw endpoint telemetry. |
| W14 | [OpenTelemetry URL attributes](https://opentelemetry.io/docs/specs/semconv/registry/attributes/url/) and [HTTP attributes](https://opentelemetry.io/docs/specs/semconv/registry/attributes/http/), reviewed 31 Jul 2026 | Standard conventions include full URL/path and HTTP header/address fields that can be sensitive/high-cardinality. | Semantic conventions are reference vocabulary only. UAM's closed allowlist is authoritative; broad auto-instrumentation is off. |
| W15 | [OpenTelemetry Collector Contrib v0.157.0 release](https://github.com/open-telemetry/opentelemetry-collector-contrib/releases/tag/v0.157.0), 21 Jul 2026, commit `89e43555904cd97c2d36605347c5d5237b1bdc8c` | v0.157.0 changed routing/filter/transform default error modes toward `ignore` for named components/feature gates. | A default can weaken fail-closed processing between releases. Pin a custom build/config and explicitly test `propagate/reject` behavior; never rely on defaults. |
| W16 | [OpenTelemetry semantic conventions v1.43.0](https://github.com/open-telemetry/semantic-conventions/releases/tag/v1.43.0), 3 Jul 2026, commit `89aae438b3b3b0a8dd33003c9d70592baf7dbd0d` | Current reviewed convention release is 1.43.0 and continues to evolve/deprecate fields. | It is a versioned reference/schema input, not a direct UAM field allowlist or immutable architecture. |
| W17 | [Windows Error Reporting local dumps](https://learn.microsoft.com/en-us/windows/win32/wer/collecting-user-mode-dumps), reviewed 31 Jul 2026 | WER LocalDumps can be configured to capture full user-mode dumps. | Production UAM dump generation remains off; detect unexpected UAM-specific dump configuration and treat it as a diagnostic/privacy safety issue. |
| W18 | [ASP.NET Core HTTP logging](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/http-logging/?view=aspnetcore-10.0), reviewed 31 Jul 2026 | Generic HTTP logging can include request path, status, and selected headers; body logging is configurable. | Disable generic defaults unless a UAM wrapper proves only route-template/method/status/latency/auth outcome fields pass. |
| W19 | [WiX Toolset v7.0.0 release](https://github.com/wixtoolset/wix/releases/tag/v7.0.0), 6 Apr 2026, commit `b8977d6` | The release page states source is available under its license, while binary release use requires the OSMF EULA. | WiX is a candidate, not an approved free/default tool. Legal/Procurement/EULA and exact binary/source mapping are blocking for selection. |
| W20 | [RFC 5280](https://www.rfc-editor.org/rfc/rfc5280), May 2008 | Defines X.509 PKI and revocation structures. | Standards capability does not prove rapid UAM authorization; application status remains separate. |
| W21 | [RFC 8705](https://www.rfc-editor.org/rfc/rfc8705), Feb 2020; [RFC 9449](https://www.rfc-editor.org/rfc/rfc9449), Sep 2023; [RFC 9421](https://www.rfc-editor.org/rfc/rfc9421), Feb 2024; [RFC 9530](https://www.rfc-editor.org/rfc/rfc9530), Feb 2024 | Define certificate-bound access tokens, DPoP, HTTP Message Signatures, and HTTP content digests. | These are future profile ingredients, not selected architecture. They add issuer, replay, clock, canonicalization, and proxy-interoperability obligations. |

## 11.2 Source-quality corrections

1. **FACT.** Vendor documentation proves a primitive or servicing state, not UAM fitness. Every Windows, SQLite, Edge, .NET, TPM, Defender, proxy, and OpenTelemetry claim remains bounded by the exact UAM composition and lane.
2. **RECOMMENDATION.** Do not cite a search snippet, popularity, download count, one current-version smoke test, or vendor marketing as support proof.
3. **RECOMMENDATION.** Exact release dates/versions in this review are historical evidence as of 31 July 2026. Release automation MUST revalidate lifecycle/advisory state and record the selected exact revision.
4. **FACT.** An upstream project being actively maintained or signed on GitHub does not establish package-to-source mapping, license approval, absence of vulnerabilities, operational support, reproducibility, or UAM fit.
5. **RECOMMENDATION.** Reference implementations may inspire tests but cannot become UAM's oracle for privacy, realm, custody, release, diagnostic, or compatibility semantics.
6. **RECOMMENDATION.** An open-source project missing a full immutable commit/tag, license/EULA review, maintenance/test/security evidence, exact fit, execution boundary, and removal path is `REFERENCE ONLY` or `NO-GO`, never a dependency candidate.

## 11.3 Consolidated open-source/repository audit

### 11.3.1 Runtime, storage, modeling, and verification

| Project / immutable point from supplied results | Consolidated classification | Correction and admission condition |
|---|---|---|
| SQLite **3.53.4**, source ID `bf7c…9bcc` | **Runtime engine candidate and normative reference** | Admit only exact native binary/source/compile/VFS/module profile with G5 and advisory evidence. Public-domain core does not remove provider/bundle/support review. |
| `Microsoft.Data.Sqlite.Core` **v10.0.10** | **Managed adapter candidate** | Package does not include native SQLite. Require exact package-to-source plus separate native bundle/source ID; direct native APIs may be needed for required controls. |
| SQLCipher **v4.17.0**, commit `810db22f575ee7cf94ea96a3e91622b5fcece3dc` | **Conditional alternative** | Only after HD-B03-05 requires full-file/metadata encryption and license/native/performance/WAL/backup/migration/recovery bake-off passes. |
| Litestream **v0.5.15**, commit `4e3f0c0f98a8808788c721b3637b41e7f9ce4a9c` | **Reference only** | Windows support/fit is insufficient; do not add as endpoint backup/replication dependency. Reuse only independent backup ideas. |
| Wolverine **v6.24.2**, commit `d49a1f5b472aa4b2765528503337ce0ce131e744` | **Reference only** | Framework authority/dependency surface is disproportionate to a narrow endpoint writer/outbox. No code/dependency adoption. |
| goqite **v0.4.0**, commit `471f9d49ce356737fc756a287007d7b4c54c61e1` | **Reference only** | Different language/runtime and queue semantics; reuse test ideas only. |
| Watermill SQLite modules **v0.1.2**, commit `a2a915319684f030296ccb15403b37f292640ad2` | **Reference only** | Server/pub-sub design differs; no endpoint dependency or broker inference. |
| TLA+ Tools **v1.8.0 pre-release**, commit `30cc360` | **Test/reference candidate; not admitted as blocking tool** | Pre-release status weakens gate stability. Keep model text reviewable; select an exact admitted stable artifact or obtain explicit test-tool exception. |
| FsCheck **3.3.4**, commit `7c583d6df4939643fd36f0439694be1456833aff` | **Test-only dependency candidate** | BSD-3-Clause; exact NuGet/source mapping and trusted T1 lane required. UAM owns model, history, shrink, and evidence semantics. |
| Hedgehog .NET **v2.0.0**, recorded commit `6beeb96` | **Reference/alternative** | Full commit should be captured before executable bake-off. Use only if FsCheck cannot economically shrink valid histories; do not operate both by default. |
| Stryker.NET **4.16.0**, recorded commit `f9109e2` | **Test-tool candidate for pure modules** | Apache-2.0; exact package/source and isolated high-authority lane. Current CsWin32/generated-symbol issue blocks interop mutation until proved. |
| Testcontainers for .NET **4.13.0**, commit `1717807affaae9b967035516ebedcd76dd7eaffb` | **Trusted server-integration test candidate** | MIT; container daemon is high authority and images need immutable digests/licenses. It is not Windows endpoint/physical/restore proof. |
| Toxiproxy **v2.12.0**, recorded commit `3ccd6a7` | **Lab/CI tool candidate** | Full commit/binary checksums and private admin endpoint required. Pair with UAM hostile HTTP server; TCP faults are not custody semantics. |
| PostgreSQL **REL_18_4** source | **Test-build/reference candidate** | PostgreSQL License; developer injection points must be paired with black-box ordinary-image tests and actual restore. Not an endpoint dependency or production-engine selection. |
| SharpFuzz package **2.3.0** / source only tied to **v2.2.0** commit `28c353b41a1ff60039bf78293dbd5edd9d7c3014` | **NO-GO AS REVIEWED** | Exact package-to-source mapping is unresolved. No execution until source/native fuzzer/provenance/T1/crash/redaction/removal evidence closes. |
| Microsoft Coyote package **1.7.11** | **Reference/bounded spike only** | Exact package-to-source commit/support recency is unresolved; instrumentation cannot prove process/native/SQLite/DB behavior. |
| Jepsen **v0.3.13**, recorded commit `0aad6ff` | **Reference only initially** | EPL-1.0/JVM/destructive SSH topology is disproportionate to a modular monolith. Reconsider only for a genuinely distributed custom protocol/topology. |
| FoundationDB **7.3.77**, recorded commit `3ea44ce` | **Reference only** | Reuse deterministic simulation concepts; no C++/Flow/storage/replication architecture transplant. |
| TigerBeetle **0.17.9**, recorded commit `cc1c06a` | **Reference only** | Reuse VOPR/reality-lane discipline; no Zig/custom ledger/storage dependency or semantics import. |
| Microsoft Detours **v4.0.1**, commit `e4bfd6b` | **Last-resort lab reference** | Old release and invasive interception. Requires separate ADR, exact signed test binary, narrow API target, disposable lab, and cleanup; never production. |

### 11.3.2 Release, installer, supply chain, and updater

| Project / immutable point | Consolidated classification | Correction and admission condition |
|---|---|---|
| TUF specification **v1.0.35** | **Normative reference for optional autonomous updater** | Not an endpoint dependency and not required for MSI-only canary. Execution profile requires a POUF and current-version review. |
| python-tuf **v7.0.0**, recorded commit `353bdb7` | **Reference/conformance oracle in sealed T1 lane** | Not selected as endpoint dependency. An isolated helper needs a separate architecture/dependency decision. |
| go-tuf **v2.4.2** | **Reference/independent comparator** | Full release commit should be recorded before executable use. Not selected as endpoint dependency. |
| `tuf-conformance` mutable `main` | **NO-GO AS REVIEWED** | No immutable full commit/dependency set; pin before any gate. Autonomous updater remains disabled. |
| WiX Toolset **v7.0.0**, commit `b8977d6` | **Leading installer candidate, not selected** | Source license and binary OSMF EULA require Legal/Procurement; exact emitted MSI/static/ICE/repro/rollback/repair evidence mandatory. |
| WixSharp **v2.14.1.0**, recorded commit `a40d106` | **Build-time alternative/reference** | Adds generator/dependency; full commit and package/source mapping required. Consider only after WiX authoring decision and measurable reviewability benefit. |
| Velopack **1.2.0**, recorded commit `f2edcbc` | **Reference only** | Imports broader updater authority and lacks UAM TUF/MSI boundary. No endpoint dependency. |
| NetSparkleUpdater **3.1.0**, recorded commit `b3df04a` | **Reference only** | Use negative feed/UI test ideas only; appcast/signature model is not UAM release authority. |
| WinSparkle **v0.9.4**, recorded commit `a8986ca` | **Reference only** | Not suitable for privileged UAM path; no dependency. |
| Squirrel.Windows **2.0.1**, recorded commit `eef3746` | **Historical reference only** | Old release and different user-app threat model; no dependency. |
| cosign **v3.1.2**, recorded commit `193d215` | **Trusted build/signing-tool candidate** | Exact binary/source/license/KMS/offline profile and isolated signing lane required. Reference only for endpoint architecture. |
| in-toto-golang **v0.11.0**, recorded commit `36d782f` | **Build/provenance reference or isolated tool candidate** | Not endpoint dependency; exact layout/profile/interoperability and provenance verification required. |
| SLSA GitHub Generator **v2.1.0**, recorded commit `f7dd8c5` | **Conditional build-platform adapter** | Only if GitHub Actions is the approved trusted platform; immutable workflow/action references and adversarial verification required. |
| Microsoft SBOM Tool **v4.1.5**, commit `c83b43dee2dd70b4d6ba16a97cde6b43f971d9c3` | **SBOM tool candidate** | Exact binary/source/egress/license admission; independent final-file/native/generated/lock-graph reconciliation remains authoritative. |

### 11.3.3 Identity, PKI, gateway, and attestation

| Project / immutable point | Consolidated classification | Correction and admission condition |
|---|---|---|
| smallstep `certificates` **v0.30.2**, commit `6e8ec61405239cf3f37b2bbf260a587b7d2e4e31` | **Lab CA candidate/reference** | Use only in disposable T1 lane now. Dedicated production CA requires HD-B03-12 plus full operations/security/license/support/G7 admission. |
| SPIRE **v1.15.2**, commit `e78e2eeca03a8a420bfe1b23b6eaf3db0db78630` | **Reference only** | SPIFFE workload identity topology differs; no endpoint/server dependency for first design. |
| cert-manager **v1.21.1**, commit `24e33194fb39488eff2bbf10c6dc640f407cad44` | **Reference only** | Relevant only if a Kubernetes CA control plane is separately selected; never endpoint component or realm authority. |
| Envoy **v1.39.0**, commit `8eea3285d6bdb89f8ea34632cfe7ce1608a8f374` | **Conditional L7 gateway candidate** | Direct/L4 remains default. Requires exact binary/config/license/security admission, mTLS/header sanitization/assertion/status/replay/smuggling tests. |
| google/go-attestation **v0.6.1**, commit `b6e905e7ae52937f02b5ca494dd1c6a3ac7a1003` | **Reference only** | Different language/platform integration; first Windows prototype uses native CNG/AD CS evidence. |

### 11.3.4 Diagnostics, support, and telemetry

| Project / immutable point | Consolidated classification | Correction and admission condition |
|---|---|---|
| OpenTelemetry .NET **core-1.17.0**, commit `e432cd549a81dabfc8b1c7c346c03cdf933013f1` | **Server/portal dependency candidate** | Apache-2.0; exact packages/transitives, wrappers, attribute tests, performance, source mapping, and removal path required. Endpoint export stays through product transport initially. |
| OTel Collector Contrib **v0.157.0**, commit `89e43555904cd97c2d36605347c5d5237b1bdc8c` | **Custom server-gateway candidate; not endpoint agent** | Build only required components, pin config/feature gates, explicit fail-safe error modes, no host/file/process receivers, all-sink/canary/load/advisory evidence. |
| OTel semantic conventions **v1.43.0**, commit `89aae438b3b3b0a8dd33003c9d70592baf7dbd0d` | **Reference/schema input only** | Never auto-adopt standard attributes; UAM allowlist overrides broad URL/HTTP/DB conventions. |
| replicatedhq/troubleshoot **v0.131.1**, commit `b279b2bef9cbad8e5ad36df2a91dd5a3488f79e0` | **Reference only** | General collectors/commands/files are prohibited. Reuse bounded recipe/test ideas only after independent implementation. |
| HashiCorp `hcdiag` **v0.5.13**, release commit only recorded as `a9c30a1` | **Reference only; no executable use** | Full commit is missing; general command collectors do not fit endpoint boundary. |
| Mozilla Glean **v69.0.0**, release commit only recorded as `566b08e` | **Reference only** | Full commit missing for deeper review. Reuse typed telemetry design concepts, not SDK/runtime architecture. |
| Sentry **26.7.2**, commit `a8da553fe6f01f51cb05d253c641d2a074e38484` | **Reference only; neither SDK nor backend recommendation** | Common crash/user/request/breadcrumb models exceed UAM privacy scope. |
| Elastic support-diagnostics **v9.4.1**, commit only recorded as `ebab5af` | **NO-GO as UAM dependency; reference at most** | Full commit missing and broad collection model conflicts with closed support bundle. |

### 11.3.5 Compatibility, Windows interop, browser fixtures, and architecture tests

| Project / immutable point | Consolidated classification | Correction and admission condition |
|---|---|---|
| .NET runtime **v10.0.10**, commit `8f030f80c0dd2722eb2f618984e9db6784765963` | **Inherent runtime candidate under accepted .NET family** | Exact self-contained patch/files/native modules/SBOM/provenance and UAM regressions required. Current patch is point-in-time evidence only. |
| Microsoft PowerToys **v0.100.2**, commit `1d11b732b7ba7dbb265d1151531655fd8d83c76d` | **Reference only** | Packaging/ARM64 ideas only; not dependency or support oracle. |
| `actions/runner-images` ARM64 image `win11-arm64/20260727.122`, commit `a261cdeaf340cf923fb371dfca4afef4f71d529e` | **Optional T1 build-lane reference** | Hosted preview/build success is not physical ARM64, power, MSI, EDR, firmware, or customer support evidence. |
| Microsoft CsWin32 **0.3.298**, commit `e4a7320acd0c62f7490efd4c34421c181212dd8d` | **Pinned build-time dependency candidate** | MIT; `PrivateAssets`, API allowlist, exact package/source, generated-source diff/review, manual fallback, and Stryker compatibility required. |
| Selenium **4.46.0**, tag plus only commit prefix `df5a634` recorded | **Test-only browser automation candidate after full pin** | Capture full commit/package/driver/browser hashes; offline operation; no automatic downloads/Grid/telemetry; automation is not source fitness. |
| Microsoft Playwright **v1.62.1**, tag plus only commit prefix `26a9e47` recorded | **Test-only alternative, not co-default** | Capture full commit/package/browser bundle identity; no runtime downloads/traces outside lab. Select one stack by bake-off. |
| Web Platform Tests URL corpus commit `181476aa16e8b28a07698bef3a0275fa53dd22e5` | **Pinned test-data/reference candidate** | BSD-3-Clause notices/bounds; UAM owns expected classifications and privacy semantics. Never sole oracle or endpoint dependency. |
| ArchUnitNET **0.13.3**, commit `b25c4f940b1d067e97092783d0ef16e4fe12d8c3` | **Optional test dependency candidate** | Admit only if mutation comparison detects architecture violations beyond custom graph/source/binary checks at acceptable cost. |
| Azure AVD Landing Zone Accelerator mutable `main` | **NO-GO AS REVIEWED / reference after pin** | No immutable revision; IaC deployment success is not UAM session/profile/source support and must not carry customer configuration into evidence. |
| Azure `RDS-Templates` mutable `master` | **NO-GO AS REVIEWED / reference after pin** | No immutable full commit; broad scripts/templates are not a compatibility harness or authority. |

## 11.4 Open-source adoption rules

1. A dependency/tool cannot move from `reference` or `candidate` to `admitted` without an immutable full revision, package/binary digest, source mapping, license/EULA, security/advisory review, tests, exact execution boundary, UAM fit, SBOM/provenance inclusion, positive/negative controls, owner, and removal path.
2. Test tools with high authority—mutation, containers, network proxies, database test builds, API interception, destructive VM tools—run only in isolated trusted lanes with no production data, secrets, signing, or deployment authority.
3. A test-build result needs an ordinary-build companion at every load-bearing native/process/database boundary.
4. No OSS project becomes the oracle for UAM privacy, identity, receipt, release, support, realm, or compatibility semantics.
5. Missing full commit or mutable branch is an immediate no-go for executable gate use, even when the project is reputable.
6. Exact versions in this review are reviewed points, not upgrade recommendations. Every update reopens admission and affected lanes.

---
# 12. Confidence by major conclusion, residual risk, and baseline-update conditions

## 12.1 Confidence register

Confidence describes the strength of the architecture conclusion, not production readiness. A **High** conclusion may still require a CLI gate because documentation and design agreement do not prove the composed UAM implementation on Windows.

| Major conclusion | Confidence | Why | Evidence that would change the conclusion |
|---|---|---|---|
| One writer, SQLite WAL, `synchronous=FULL`, and one atomic page/effect/progress transaction are the correct endpoint durability baseline | **High** | It directly implements the accepted no-cursor-ahead invariant and is consistent across I01, I02, I07, I08, and current SQLite documentation. | A reproducible real-boundary failure showing the invariant cannot be preserved on an otherwise qualified store profile, or a simpler transactional substrate that passes the same model/crash/restore evidence with lower total risk. This would require an explicit baseline change proposal. |
| Immutable sealed batches, a durable `PREPARED` attempt before network I/O, exact-byte replay, and receipt-only acknowledgement are required | **High** | They are the smallest coherent response to an ambiguous post-commit/lost-response outcome and preserve at-least-once delivery with one final effect. | A stronger authenticated custody protocol that proves an authoritative no-custody result and permits safe supersession without weakening stable identity; or evidence that the server receipt contract cannot bind batch and content identity as required. |
| Application-level payload encryption before SQLite bind is the preferred prototype | **Medium** | It reduces ordinary DB/WAL/backup exposure without selecting a SQLite fork, but endpoint sensitivity, local-administrator threat, key provider, recoverability, and performance are human/CLI matters. | A human classification accepting plaintext minimized payload under full-volume controls; or an admitted SQLCipher/SEE profile proving lower total risk, metadata confidentiality, recovery, licensing, patching, N/N-1, and performance. |
| Exact encryption algorithm, nonce/profile, wrapping provider, TPM requirement, recovery/escrow, and key lifetime remain provisional | **High** | The supplied evidence explicitly leaves encryption assurance, TPM estate, recovery, and ownership open. | Approved cryptographic profile, estate inventory, provider/ACL/non-exportability evidence, key-loss and recovery drills, and security/privacy authority acceptance. |
| The verification system must combine a UAM-owned model/checker with deterministic hooks and real-boundary companion failures | **High** | Each evidence type catches a different defect class; mocks or hooks alone cannot establish Windows, SQLite, network, installer, database, or reboot behavior. | Repeated evidence that a proposed layer adds no independent defect detection and can be removed without reducing named invariant coverage, mutation sensitivity, or real-fault localization. |
| Production artifacts must structurally exclude fault controllers, schedules, destructive helpers, and test credentials | **High** | Runtime-disable flags are weaker than absence for a high-impact capability. This follows from the accepted release and repository boundaries. | No ordinary evidence is expected to justify a callable production fault plane. Any proposal would require a new privileged-control threat model and explicit baseline change. |
| MSI and enterprise deployment must own the stable privileged boundary | **High** | It is an accepted predecessor invariant and limits how often service/task/ACL/root-trust topology changes. | New primary and lab evidence that another signed deployment boundary gives equal or smaller authority, repair, uninstall, rollback, enterprise control, and recovery risk, plus a migration ADR. |
| Autonomous update should remain disabled by default | **High** for the default; **Low** that it is needed | No approved patch SLA or representative enterprise-management miss distribution was supplied. An updater adds a permanent high-consequence subsystem. | Repeated management-attributable misses against an approved objective, a materially better constrained-updater result, complete TUF/activation/rollback/recovery evidence, assigned operations/key owners, and approved cost/risk. |
| If autonomous update is enabled, a TUF-conformant repository workflow plus exact digest and Authenticode checks is required | **High** | The controls address different threats: repository rollback/freeze/mix-and-match, exact release authorization, and Windows signer/policy integration. | A different documented update-security protocol that proves equal role separation, threshold/root recovery, expiration, rollback/freeze/mix-and-match protection, exact target authorization, conformance, and Windows integration at lower risk. |
| Immutable side-by-side payloads, A/B activation, a retained previous version, and higher-sequence rollback are the right payload model | **Medium-High** | The design avoids mixed binaries and lower-version anti-rollback exceptions, but filesystem, health, disk, EDR, and migration behavior require exact Windows proof. | Real experiments showing another atomic selector/materialization scheme has stronger recovery and lower filesystem/operational risk, or showing N/N-1 cannot be maintained for the accepted endpoint schema. |
| Every installation needs a locally generated, non-exported asymmetric identity; shared fleet secrets are unacceptable | **High** | It enables independent revocation, realm binding, clone handling, and proof of possession while containing compromise to one installation. | No expected ordinary evidence supports a fleet secret. A different hardware/workload identity mechanism would need equal per-installation uniqueness, offline behavior, clone handling, revocation, realm isolation, and deployment fit. |
| The preferred Windows assurance is TPM-bound where proved; software-bound identity is a separately approved lower-assurance exception | **Medium-High** | Microsoft documents the primitive and stronger attestation options, but provider-name evidence alone is insufficient and estate/vTPM/CA behavior is unknown. | Exact estate and G7 evidence proving another provider/profile has equal or better non-exportability, operations, availability, cloning, recovery, and support; or a human risk decision that A1 is adequate for a named tuple. |
| Direct origin mTLS or L4 TLS pass-through is the initial network identity path | **Medium-High** | It has the fewest trusted identity-forwarding components and preserves peer-certificate binding. Enterprise proxy/TLS paths remain unproved. | Representative customer-network evidence that direct/L4 cannot meet approved coverage and a separately proved application proof-of-possession or L7 assertion profile closes replay, canonicalization, status, header, and trust gaps. |
| L7 TLS termination is conditional, not equivalent to direct mTLS | **High** | It introduces a gateway identity translation boundary; header stripping, gateway-to-backend mTLS, request binding, replay defense, and fresh credential status are necessary. | A platform mechanism that cryptographically exposes the original verified peer credential end-to-end with equal or stronger semantics and passes adversarial differential tests. |
| Server-side credential status/deny is required in addition to CRL/OCSP | **High** | Application authorization must react within a declared bound and cannot assume cached PKI revocation or an existing connection changes immediately. | A selected PKI/gateway design proving equivalent bounded revocation and per-request authorization under outages, caches, existing connections, and realm changes. |
| Diagnostics must use a closed release-owned catalogue, finite fields/labels, no raw exceptions, and no ordinary production dumps | **High** | This follows directly from the accepted pre-diagnostics minimization invariant and current OpenTelemetry/Windows documentation. | No ordinary support need is sufficient to broaden the ceiling. A new diagnostic field/source would need a privacy-ceiling change, typed contract, all-sink canaries, bounded supportability proof, and human authority where applicable. |
| Coordinator-owned bounded diagnostics, D0–D2 expiring permits, and deterministic safe support bundles are the correct endpoint support model | **Medium-High** | They preserve the existing process and privacy boundaries and avoid a remote shell/general collector. Exact usability, limits, encryption, and backend operations remain unproved. | A blind-support campaign showing the defined support promise cannot be met without a narrower promise or additional safe signals; or a smaller mechanism proving equal supportability and privacy. Raw collection is not the automatic remedy. |
| OpenTelemetry .NET plus a minimal custom server-side Collector is an admissible candidate, not an accepted production dependency | **Medium** | The projects are current and fit server observability, but conventions/defaults can expose or silently ignore data; exact packages/config/backend/load/skills are open. | Dependency admission failure, a Collector default/config that cannot be made fail-safe, unacceptable cost/operations, or a proprietary/direct schema proving lower risk and equal interoperability. |
| Compatibility must be a signed, expiring, exact-tuple allowlist with no nearest-match behavior | **High** | Windows, Edge, .NET, native modules, profile, session, network, and security policy evolve independently; a broad label is not falsifiable. | A proved equivalence class with bounded dimensions and recurring sentinels may replace selected exact fields, but the equivalence evidence must be explicit and expiring. |
| The proposed Windows 11 Enterprise 25H2 x64/Edge Stable/local-console/local-profile/direct-mTLS tuple is the smallest useful first engineering-canary candidate | **Medium** | It minimizes variables and preserves the accepted Edge first slice, but no exact environment has yet passed the aggregate gate. | Estate/business need, lab availability, or an exact-build failure may select another equally narrow tuple. The replacement must not add multiple unproved dimensions simultaneously. |
| Any platform is technically `QUALIFIED` now | **Low / not established** | No E03-17 aggregate evidence exists. The lab attachment proves only a connection path. | A complete, current, content-bound E03-17 evidence set for the exact tuple with zero primary failures and cleanup residue. |
| Any platform is product `SUPPORTED` now | **Low / not established** | Technical qualification, support commitment, lifecycle, owners, customer scope, and risk acceptance are incomplete human and operational decisions. | Technical qualification plus approved support matrix, owners, lifecycle/deprecation, evidence cadence/expiry, staffing/budget/licensing, customer communication, and production authority. |
| Batch 03 is eligible for an engineering canary now | **Low / no** | The aggregate evidence set and blocking owner/scope decisions do not yet exist. | Every term of E03-18 evaluates true for one exact tuple and the generated gate record states `engineeringCanaryEligible=true` and `productionApproved=false`. |

## 12.2 Evidence most likely to change the architecture or priority

The following evidence has the highest decision value, in order:

1. **CLI EXPERIMENT — G5 real crash and disk campaign.** A cursor-ahead, missing effect, changed retry identity, unacknowledged deletion, or receipt mismatch would stop the batch and reopen the storage/transaction ADR before release, identity, or compatibility work continues.
2. **CLI EXPERIMENT — exact Windows release/installer campaign.** A mixed executable set, reparse/path escape, unauthorized execution, failed known-good recovery, unrepairable MSI state, or N/N-1 incompatibility would block the canary and may force the payload/activation design to change.
3. **CLI EXPERIMENT — key, clone, revocation, and network campaign.** A cloned or denied credential that remains authorized, payload-derived realm authority, shared-secret fallback, or stale status beyond the declared bound would require an identity/gateway redesign.
4. **CLI EXPERIMENT — diagnostics canary and blind-support campaign.** A forbidden value in any sink, permit that survives expiry/revocation, plaintext bundle residue, cross-realm support access, or inability to diagnose the stated failure set would block remote diagnostics and may narrow the support promise.
5. **CLI EXPERIMENT — exact compatibility campaign.** A near-miss environment receiving a permit, unexplained package/native-module drift, or an exact tuple that cannot pass all predecessor and Batch 03 gates would change the first-tuple proposal.
6. **HUMAN DECISION plus measurement — enterprise update coverage.** Only an approved patch objective and representative management-attributable misses can elevate the optional updater from a design reference to an implementation priority.
7. **HUMAN DECISION plus estate evidence — TPM, proxy, VDI, ARM64, and extended platform scope.** These inputs determine future lanes; they do not broaden the first tuple automatically.
8. **HUMAN DECISION plus restore/retention/RPO evidence — cleanup and key recovery.** These are required before acknowledged endpoint payload deletion, production backup, enterprise key escrow, or destructive migration can be enabled.

## 12.3 Unresolved residual risks and blocked dependencies

| Unresolved risk or dependency | Current containment | What remains blocked |
|---|---|---|
| Storage hardware, hypervisor, or filter driver may misreport flush/durability | `FULL`, stable identity, WAL recovery, real process/VM reset companions, pause/hold on uncertainty | Platform qualification and canary until the exact environment passes E03-03 through E03-05. |
| Endpoint destruction before custody, unrecoverable local key loss, or source deletion before observation can lose evidence | No false receipt; retain unacknowledged data; explicit health; no forensic/productivity claim | Any zero-loss promise, production RPO, cleanup grace, key escrow, or recovery promise. |
| Exact G5 limits, reserve, batch, retry, checkpoint, offline duration, and resource budgets are unknown | Hard implementation ceilings plus conservative pause/no-drop behavior | Production capacity, long-outage support, and any loss-under-pressure policy. |
| Application encryption protects ordinary files but not a privileged live-process attacker | Minimize first, key separation, no plaintext DB bind, no dump/support export, restricted access | High-assurance local-confidentiality claim and production crypto profile. |
| N/N-1 migrations may prove too costly or constrain schema evolution | Expand/backfill first, delayed contract, backup/verification, enterprise maintenance for destructive changes | Autonomous activation of any release whose storage compatibility is not proved. |
| Build/signing/repository/operator compromise can still authorize harmful code with sufficient authority | Independent build, signing, release roles; exact digest; provenance; same-digest promotion; OOB recovery | Production release until custodians, thresholds, ceremonies, KMS/HSM, incident authority, and drills are approved. |
| Root-threshold or stable bootstrap compromise is not safely recoverable in-band | Enterprise/OOB MSI recovery remains separate | Claim that autonomous update can repair every release-trust compromise. |
| Local administrator, kernel, CA, gateway, hypervisor, or management compromise can misuse a legitimate identity | Narrow per-installation key/status/realm, assurance classification, deny/epoch/clone hold | Claim that TPM or certificate proves a trustworthy endpoint or monitored person. |
| Sequential software-key cloning can evade simple overlap detection | A1 disabled by default; anomaly/operator signals; destructive re-enrollment | Broad software-key support without a human assurance exception and exact controls. |
| CRL/OCSP, clocks, deny caches, gateways, and long-lived connections can be stale or unavailable | Per-request current/bounded-freshness UAM status, fail closed, connection closure as defense in depth | Production revocation SLO and offline grace policy. |
| Enterprise proxies, PAC/WPAD, TLS interception, VPN transitions, and customer trust stores vary materially | Direct mTLS first; no direct fallback; separate finite modes; exact test lanes | Proxy/PAC/TLS-interception/VPN support claims and broad customer readiness. |
| General logging, OTel auto-instrumentation, WER, EDR, paging, backup, screenshots, or human behavior may create external copies | Closed application catalogue, generic sinks off, canaries, dump detection, documented blind spots | Absolute no-copy claim; production support access until backend, policy, retention, and staff controls pass. |
| Value-free diagnostics may not solve every real incident | Blind-support gate and explicit support promise; synthetic reproduction instead of raw collection | Any promise to diagnose incidents requiring production raw activity or memory. |
| Exact support backend, encryption/key service, indexing, access, deletion, data residency, and retention are unknown | Local encrypted deterministic bundle prototype; remote upload off | Production support-bundle upload and remote diagnostic access. |
| Browser, OS, runtime, native SQLite, Defender/EDR, and policy updates can invalidate a tuple rapidly | Exact manifest, evidence expiry, kill switch, no closest match, sentinel lanes | Timeless “Windows supported,” browser-major-only support, and automatic new-build enablement. |
| Physical ARM64, Modern Standby, RDS/AVD/Citrix/FSLogix, roaming/container profiles, and third-party EDR remain unproved | Explicitly excluded or test-only; native x64/local profile first | Any extended-platform support commitment. |
| The exact first tuple may not match business estate needs | Keep tuple technical and narrow; estate scope is human-owned | Commercial support statement and pilot population selection. |
| Batch 01 G1 and Batch 02 G2–G4 evidence may be absent, stale, or tied to a different source/package/environment | E03-17 binds predecessor evidence by digest and rejects stale/mismatched inputs | Live source collection and the aggregate Batch 03 canary gate. |
| Later global gates—server durable inbox/idempotency/poison, database/capacity, outage/backpressure, deletion/restore—remain open | Batch 03 does not infer their pass; receipt remains custody only | Production-shaped end-to-end delivery, production capacity, deletion, restore, or service readiness. |
| Legal purpose, prohibited uses, field set, identity/time precision, retention, access, workforce consultation, and product use remain unapproved | T1 synthetic only; privacy ceiling remains an upper technical bound | Real activity, pilot, production, and any employee/productivity interpretation. |
| Blocking owner, staffing, budget, licensing, SLO/RPO/RTO, risk, and production decisions remain unassigned or unapproved | Owner functions and consequences are explicit in section 6 | Gate closure where the decision is named, product support, and production operation. |

## 12.4 Exact conditions for updating the main technical baseline

### 12.4.1 Architecture-level update

**RECOMMENDATION.** This review may update the main technical baseline at the **architecture/prototype level** only after the architecture authority accepts the ADR create/update actions in section 9. The accepted update may add these invariants and no broader claim:

1. G5 uses one realm-bound business store, one writer, atomic page/effect/progress, immutable exact batches, durable pre-send ambiguity, receipt-only acknowledgement, and no silent loss.
2. Verification uses an independent UAM model/checker, deterministic hooks, real-boundary companions, failure capsules, and structural production-hook absence.
3. MSI/enterprise deployment remains the stable privileged boundary; autonomous update defaults off and is separately evidence-gated.
4. Installation identity is locally generated asymmetric proof bound server-side to installation, epoch, assurance, status, and realm; payload claims and shared secrets are never authority.
5. Endpoint diagnostics use a closed privacy-safe catalogue, bounded Coordinator-owned state, expiring D0–D2 permits, and deterministic encrypted support bundles; no raw mode exists.
6. Compatibility is an expiring exact-tuple permit system; `QUALIFIED` is technical evidence and `SUPPORTED` is a later human/operational commitment.
7. Pre-enrollment machine control state is separate from realm-bound business data, and all cryptographic purposes/authorities remain separated.

Architecture acceptance does **not** close a CLI gate, label a platform supported, enable real data, select production numeric/crypto/tool values, or approve a canary.

### 12.4.2 Engineering-canary update

The main technical baseline may add **one engineering-canary-eligible tuple** only when all of these exact conditions are evidenced in the same content-addressed gate record:

```text
B03_ENGINEERING_CANARY_BASELINE_UPDATE =
    ARCHITECTURE_ADRS_ACCEPTED
    AND BATCH01_REQUIRED_EVIDENCE_CURRENT_AND_MATCHING
    AND BATCH02_REQUIRED_EVIDENCE_CURRENT_AND_MATCHING
    AND E03_00_TO_E03_09_REQUIRED_PASS
    AND E03_11_TO_E03_13_REQUIRED_PASS
    AND E03_15_TO_E03_17_REQUIRED_PASS
    AND (AUTONOMOUS_UPDATE_DISABLED OR E03_10_FULL_PASS)
    AND EXACT_ONE_TUPLE_ID_AND_PACKAGE_DIGEST
    AND ZERO_PRIMARY_INVARIANT_FAILURES
    AND ZERO_CANARY_ESCAPES
    AND ZERO_CROSS_SESSION_OR_CROSS_REALM_ACCEPTS
    AND ZERO_UNAUTHORIZED_EXECUTIONS
    AND ZERO_UNACKNOWLEDGED_SILENT_LOSS
    AND ZERO_CLONE_REVOKED_EXPIRED_OR_WRONG_REALM_AUTHORIZATIONS
    AND ZERO_DIAGNOSTIC_PERMIT_OR_PLAINTEXT_RESIDUE_FAILURES
    AND ZERO_CLEANUP_FAILURES
    AND ALL_BLOCKING_OWNER_FUNCTIONS_ASSIGNED
    AND HUMAN_ENGINEERING_CANARY_SCOPE_AND_RISK_RECORDED
    AND EVIDENCE_MANIFEST_AND_EXCEPTIONS_UNEXPIRED
    AND productionApproved = false
```

The first candidate tuple remains no broader than the exact Windows 11 Enterprise 25H2 x64, exact Edge Stable build/source capability, local console, local non-roaming/non-containerized profile, native self-contained x64 package, exact Defender policy with zero UAM exclusion, and direct origin mTLS environment stated in section 1. A different first tuple requires the same narrowness and complete E03-17 evidence; it cannot combine several unproved extension classes.

A canary pass updates only this statement:

> The exact tuple identified by manifest and evidence digest is eligible for a T1 synthetic engineering canary under the recorded scope. It is not a product support statement, pilot approval, real-data approval, or production approval.

### 12.4.3 Supported-platform update

The main baseline may label a tuple **`SUPPORTED`** only after, in addition to technical qualification:

- accountable Product/Support ownership accepts the exact published scope, lifecycle, evidence expiry/cadence, deprecation, migration, customer communication, and exclusion language;
- Security, Privacy/Data Governance, Endpoint Operations, PKI/Network, Release, and Support functions accept their named operational responsibilities without waiving a primary invariant;
- licensing/procurement, staffing, budget, support hours, incident/escalation, SLO/RPO/RTO, retention/access, and production risk decisions are approved where applicable;
- the tuple remains vendor-serviced and evidence-current, with an active signed compatibility manifest and no safety hold;
- a production release and deployment decision is separately authorized.

Technical research alone cannot perform this transition.

### 12.4.4 Conditional baseline updates

The following require their own exact triggers and cannot be inferred from the core Batch 03 pass:

- **Autonomous updater:** only after the E03-10 business/coverage gate and full TUF, activation, rollback, root/key recovery, operations, cost, and human approval pass. Otherwise `ENTERPRISE_ONLY` remains the baseline.
- **Acknowledged endpoint cleanup:** only after approved retention/RPO/ACK-grace/clock/key/restore rules and the corresponding deletion/restore gates pass. Receipt alone is not an approved retention decision.
- **TPM-attested-only or software-key support:** only after estate/issuer evidence and an assurance-level human decision for each tuple.
- **Proxy, PAC/WPAD, TLS interception, VPN dependency, L7 gateway, or application proof-of-possession:** only after its separate network/security contract and adversarial lane pass.
- **ARM64, emulation, RDP/RDS/AVD/Citrix/FSLogix, roaming/containerized profiles, Modern Standby, Server/LTSC, Chrome/Firefox, or third-party EDR:** only as separate exact tuples with all applicable predecessor and Batch 03 evidence and support decisions.
- **Remote support backend and production diagnostic upload:** only after realm access, permit, encryption, custody, retention, deletion, audit, staffing, backend, and supportability evidence and human decisions pass.
- **Exact dependency version, package, installer, CA, gateway, telemetry backend, crypto profile, numeric limit, or resource budget:** only through execution-time admission/measurement and the owning ADR; reviewed point versions are not timeless defaults.

### 12.4.5 Research-close status

**FACT.** At research close on **31 July 2026**, the Batch 03 architecture is coherent enough for ADR review and T1 prototype implementation, but the aggregate engineering-canary evidence does not exist. No platform is technically `QUALIFIED`, no platform is product `SUPPORTED`, autonomous update remains disabled, production diagnostic export remains disabled, and no real activity, pilot, or production deployment is authorized.

**Blocked dependencies:** current matching Batch 01 and Batch 02 runtime evidence; E03-00 through E03-18 results; exact Windows/Edge/package/Defender/direct-mTLS lab tuple; installer and package proof; key/PKI/revocation/clone proof; diagnostics blind-support and deletion proof; owner assignments; canary scope/risk decision; and all later global gates required for end-to-end production.

**Unresolved risks:** real storage and filesystem behavior, key loss and privileged compromise, release/root/signing compromise, enterprise network variation, support blind spots and external copies, browser/platform drift, extended-platform behavior, human misuse, and every open legal/privacy/retention/access/SLO/RPO/RTO/production decision. These risks are contained by narrow exact tuples, fail-closed state machines, no-silent-loss rules, key/authority separation, all-sink canaries, evidence expiry, kill switches, rollback, cleanup proof, and explicit refusal to infer a broader claim.

**Exact baseline-update condition:** this batch may update the main technical baseline only by the architecture acceptance in 12.4.1 or by a content-addressed gate satisfying every term in 12.4.2. Any broader support, updater, identity assurance, network, diagnostics, cleanup, extended-platform, pilot, or production claim requires the additional conditions in 12.4.3–12.4.4. A failed term leaves the existing baseline unchanged and stops the dependent work; it does not create a waiver or a nearest-match fallback.
