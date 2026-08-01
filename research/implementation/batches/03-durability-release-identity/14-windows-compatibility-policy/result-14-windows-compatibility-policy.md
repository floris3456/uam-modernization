# Prompt 14 result — Windows, browser, RDP/RDS, profile, ARM64, EDR, sleep, and compatibility policy

**Result path:** `batches/03-durability-release-identity/14-windows-compatibility-policy/result-14-windows-compatibility-policy.md`  
**Research date:** 31 July 2026  
**Decision status:** **PROPOSED — ACCEPT THE POLICY ARCHITECTURE; NO PLATFORM IS YET LABELLED SUPPORTED**  
**Authority boundary:** Windows/browser/session/profile/network/security compatibility policy, qualification evidence, packaging architecture, health reporting, exceptions, and support lifecycle; **not** legal purpose, workforce monitoring approval, customer coverage commitments, budget, staffing, EDR-vendor approval, pilot, or production deployment  
**Primary gate:** **No platform is labelled supported until its security, acquisition, update, durability, resource, and cleanup gates pass for the exact declared environment tuple.**  
**Predecessors:** accepted Batch 01 and Batch 02 reviews, both accepted with mandatory conditions and open runtime proof gates  

## Evidence vocabulary

This result uses the required labels:

- **FACT** — directly supported by an allowlisted supplied attachment or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from stated facts; the reasoning chain is explained.
- **ESTIMATE** — a numerical hypothesis whose inputs must be replaced by measurement.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, business, support, or production authority is required.
- **CLI EXPERIMENT** — code, lab work, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements form the proposed compatibility baseline. They do not convert vendor documentation into UAM fitness or a **HUMAN DECISION** into approval.

---

# 1. Executive conclusion in easy language, with confidence and residual risk

## 1.1 Conclusion

**RECOMMENDATION — use a rolling, evidence-backed allowlist, not a broad “Windows supported” statement.** UAM should never infer compatibility from an operating-system name, vendor lifecycle page, processor family, browser major version, or successful installation alone. A platform is supported only when an immutable, release-authorized `PlatformCompatibilityManifest` lists the exact environment class and binds current evidence that all applicable UAM gates passed.

**FACT.** The supplied Windows-lab summary proves only that a sanitized connection path to a Windows VM exists. It proves no edition, build, architecture, browser, RDP/RDS, FSLogix, Citrix, EDR, proxy, power mode, permissions, or UAM behavior [I02].

**FACT.** The accepted reviews require real disposable or reverted Windows VMs for service, token, session, ACL, MSI, certificate, browser-source, and cleanup claims; vendor documentation does not prove their composition is fit for UAM [I05, I06].

**Therefore, current support status is:**

> **No OS/browser/session/profile/network/security tuple is supported at research close.**

This is not a negative product decision. It is the accurate state before the lab gates run.

## 1.2 Proposed minimum first-slice support claim after qualification

**RECOMMENDATION — the smallest useful candidate claim is deliberately narrow.** After every named gate passes, the first support statement should be no broader than:

> UAM release `<release-id>` supports the Edge site/domain first slice on the exact Windows 11 Enterprise or Education 24H2/25H2 x64 builds listed in compatibility manifest `<manifest-digest>`, using the native `win-x64` self-contained package, Microsoft Edge Stable or Extended Stable builds explicitly listed in that manifest, one local console session or one non-concurrent RDP session, one local non-roaming and non-containerized user profile, the listed .NET/native-SQLite payload, and the listed direct or machine-proxy HTTPS profile. Defender must be in one of the qualified states and no UAM-specific antivirus or EDR exclusion is required. Sleep, hibernate, and resume are supported only as tested pause/revalidate/resume lifecycle transitions; collection is not promised while the device is asleep. Every other combination is conditional, test-only, or unsupported.

This candidate **excludes**, until separate evidence exists:

- Windows on ARM64 and Windows 11 26H1;
- x64 execution through ARM64 emulation;
- Windows Server, RDS multi-session, AVD, RemoteApp, Citrix, FSLogix, roaming or profile-container sources;
- simultaneous same-SID sessions sharing one physical browser profile;
- third-party EDR products or policies;
- proxy auto-discovery, PAC, TLS interception, captive portals, and mandatory VPN dependencies;
- Chrome or Firefox collection;
- Edge Beta, Dev, Canary, command-line-only custom roots, UNC/network roots, and disk-backed raw scratch.

**INFERENCE.** This is the minimum credible claim because it preserves the accepted session and profile boundaries, matches the Edge-only first slice, avoids unproved virtualization/profile redirection, uses one architecture-native package, and keeps network/security variables small enough to falsify independently.

## 1.3 Compatibility policy in one sentence

**RECOMMENDATION.** Support is the intersection of:

```text
vendor-serviced platform
∧ release-owned representable capability
∧ exact qualified environment tuple
∧ unexpired evidence
∧ unexpired compatibility manifest
∧ no active safety hold or kill switch
∧ tenant policy that only narrows
∧ runtime health that still matches the qualified tuple
```

A missing or undecidable term evaluates to **not collection-capable**.

## 1.4 Why exact tuples and expiry are necessary

**FACT.** Windows 11 currently has 24H2, 25H2, and hardware-scoped 26H1 servicing lines, with different builds and end dates; 26H1 is not designed as an in-place feature update from 24H2 or 25H2 [W01].

**FACT.** Starting with Edge 152, Stable moves to a two-week major-release cadence while Extended Stable remains eight weeks; only the current release is serviced, even though assisted-support windows cover additional releases [W06, W07].

**FACT.** .NET self-contained deployment gives UAM exact runtime control but makes UAM responsible for shipping each runtime security patch through a new product release [W09, W10].

**INFERENCE.** A timeless policy such as “Windows 11 plus current Edge” would silently change meaning faster than the evidence can be reviewed. The manifest must bind exact facts and expire automatically.

## 1.5 Confidence

| Conclusion | Confidence | Reason |
|---|---|---|
| Rolling evidence-backed allowlisting is the correct support model | **High** | It directly enforces the accepted fail-closed, release, privacy, session, and proof-gate invariants. |
| The proposed x64/local-profile/Edge-only tuple is the right first target | **Medium-High** | It is the smallest useful continuation of the accepted first slice, but no runtime evidence has passed yet. |
| VM lanes can prove the core service/session/browser state machine | **Medium** | They can exercise controlled software states, but enterprise policy, physical power, hardware, and security products remain different failure domains. |
| ARM64, Modern Standby, RDS/AVD, FSLogix/Citrix, PAC, and third-party EDR can be supported later | **Low-Medium** | Vendors document capabilities, but UAM composition, operations, and cleanup are unproved. |
| Any platform is supported today | **Low / not established** | The allowlisted lab evidence proves no runtime capability. |

## 1.6 Residual risk in plain language

Even after the first tuple passes, browser internals can change between updates; Windows servicing can alter session, token, power, storage, and security behavior; EDR can inject, delay, quarantine, or block binaries; proxy and TLS interception can change authentication and certificate behavior; VDI products can attach, detach, copy, cache, merge, or discard profiles; and sleep/resume can preserve stale in-memory assumptions. UAM can contain these risks through exact qualification, expiry, kill switches, native packaging, state revalidation, one-source leases, privacy-safe health, rollback, and cleanup tests. Research alone cannot prove every customer policy or future update.

## 1.7 Immediate stop/go decision

**GO now** for pure contracts, manifest/evaluator code, synthetic fixtures, package-architecture validation, disconnected lab scripts, and read-only inventory using placeholders.

**STOP** before claiming support, enabling live source collection, adding EDR exclusions, qualifying an enterprise proxy, or enabling an extended platform until the applicable lane passes and the evidence is bound to an unexpired manifest.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 Allowlisted evidence and file-presence record

**FACT.** All six allowlisted Project files were present. No other Project file was opened, searched, quoted, summarized, or used.

| Ref | Allowlisted file | SHA-256 reviewed | Use and limitation |
|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md` | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Accepted endpoint, privacy, durability, release, realm, and restore invariants; working baseline, not production approval. |
| I02 | `03-sanitized-windows-lab-capability.md` | `8da73d913e7f1b01d943e4c8b0ed7bb2722571ff6a3a20cef0b8f47738a4658f` | Proves only that a sanitized Windows-VM connection path exists; every runtime fact remains unknown. |
| I03 | `05-decisions-contradictions-and-gates.md` | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | Accepted decisions, acquisition choice, ordered gates, and stop rule. |
| I04 | `06-research-evidence-rules.md` | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | Evidence labels, source quality, human authority, and conflict discipline. |
| I05 | `result-review-01-foundations.md` (local file `batch-01-review-result(3).md`) | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | Accepted contracts, G1 topology, privacy lattice, repository, release, test-data, and Windows proof requirements. |
| I06 | `result-review-02-endpoint-data.md` | `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | Accepted prototype architecture for Edge discovery/acquisition, source lineage, ASCII host privacy transform, whole-page progress, and G2–G5 gates. |

## 2.2 Accepted inputs carried forward

The following are **FACT** from I01, I03, I05, and I06 and are not reopened:

1. The Coordinator is a low-privilege machine service; one ordinary-token User Host exists per eligible interactive session; restricted short-lived Task Hosts execute fixed risky capabilities.
2. The Coordinator does not crawl profiles, load profiles, create user tokens, or read user-owned browser sources.
3. C#/.NET is the default family; exact patches and fast-moving dependencies are execution-time lifecycle inputs.
4. Product privacy authority is release-owned; tenant policy only narrows.
5. Raw/forbidden source values are eliminated before User Host/Coordinator IPC, endpoint durability, diagnostics, logs, or transport.
6. Endpoint SQLite uses WAL and one writer; a source cursor never advances ahead of the durable minimized effect or approved progress fact it represents.
7. Delivery is at least once with stable identity and one final business effect.
8. MSI and enterprise deployment own the stable privileged boundary; an autonomous updater is optional and separately gated.
9. The first slice is Edge history at site/domain level with synthetic data until governance permits otherwise.
10. Edge acquisition is short read-only, eligible memory backup, then defer; never raw-copy live main/WAL/SHM files.
11. Browser-source continuity, collector runtime, source-schema capability, and interpretation identity are separate.
12. One physical shared browser source has one source/lease; acquisition session is not proof of visit-origin session.
13. G1 precedes live source work; G2/G3/G4 precede source values entering a production outbox; G5 proves atomic effect/progress durability.
14. No vendor page, current-version smoke test, passing scanner, or VM count alone proves UAM support.

No accepted-baseline change proposal is raised.

## 2.3 Scope

This result defines:

- Windows client, LTSC, and Server support classes;
- x64 and ARM64 packaging/qualification policy;
- Edge, Chrome, and Firefox channel handling;
- console, RDP, RDS, AVD, RemoteApp, fast-user-switching, and same-SID rules;
- local, roaming, FSLogix, Citrix, and other profile-provider classes;
- sleep, hibernate, Modern Standby, fast startup, restart, and resume behavior;
- direct, proxy, PAC/WPAD, TLS-interception, VPN, and captive-network classes;
- Defender, Controlled Folder Access, and third-party EDR qualification/exclusion policy;
- qualification cadence, expiry, exception, deprecation, and customer-readiness workflow;
- test-lane architecture and the boundary between VM, physical, and enterprise proof;
- environment inventory and privacy-safe health contracts;
- native-architecture/package validation;
- compatibility incidents, runbooks, metrics, costs, skills, and fitness functions.

## 2.4 Non-goals

This result does not:

- approve live activity collection, business purpose, lawful basis, workforce consultation, retention, identity precision, or access;
- decide which customer platforms UAM must commercially support;
- select a customer EDR vendor, proxy, VPN, VDI platform, or hardware fleet;
- claim browser-history source stability for Chrome or Firefox;
- redesign G1–G5, transport, server ingestion, central identity, database, portal, or deployment authority;
- create a general hardware-inventory or endpoint-management product;
- use device/network/profile facts to infer a person, role, location, productivity, or risk score;
- request or expose SSH commands, connection details, user names, addresses, credentials, tenant identifiers, raw profiles, URLs, or production security configuration.

## 2.5 Assumptions

| ID | Assumption | Why it is safe only temporarily | Replacement evidence |
|---|---|---|---|
| A-14-01 | Windows 11 Enterprise/Education x64 is the likely first managed-client target | Fits the stated enterprise context, but customer coverage is a human choice | Approved target matrix and estate inventory aggregates |
| A-14-02 | A self-contained architecture-specific .NET package is operationally preferable | Gives deterministic runtime/native assets but transfers patch responsibility to UAM | Release/update/rollback and support-cost evidence |
| A-14-03 | Edge Extended Stable may reduce major-version qualification churn | Eight-week cadence is documented, but security servicing and customer policy still matter | Measured release lag, incident rate, and customer browser policy |
| A-14-04 | One local console plus one non-concurrent RDP session is a feasible first session scope | G1 design supports interactive sessions, but no exact runtime proof exists | G1/G2/G3/G4/G5 campaign on each tuple |
| A-14-05 | Default zero UAM-specific AV/EDR exclusions is viable | Safest security posture, but some enterprise products may block/slow UAM | Defender and third-party product campaigns |
| A-14-06 | Exact versions belong in evidence/manifest rather than metric labels | Preserves cardinality/privacy, but support needs bounded inventory access | Metrics cardinality and support-runbook tests |

## 2.6 Unknowns

The following are **UNKNOWN** until measured or decided:

- the actual Windows lab OS, build, architecture, security baseline, browser, runtime, session, profile, network, and power capabilities;
- customer estate distributions and required editions/channels;
- whether RDP, RDS, AVD, FSLogix, Citrix, roaming profiles, ARM64, LTSC, Server, or third-party browsers are commercially required;
- native package/installer behavior on physical ARM64;
- Task Scheduler, service, token, named-pipe, firewall, source-read, update, and cleanup behavior under each enterprise policy;
- browser schema and lock behavior after future servicing;
- real EDR injection, quarantine, scan, reputation, Controlled Folder Access, and tamper-protection effects;
- direct/proxy/PAC/authentication/TLS-interception/VPN behavior in customer-like networks;
- Modern Standby and battery impact on real hardware;
- exact qualification cadence, evidence expiry, deprecation notice, waiver duration, resource budgets, metric-series budget, staffing, lab cost, SLO/RPO/RTO, and support-hours commitment.

## 2.7 VM-provable versus non-VM claims

| Claim class | VM can establish | VM cannot establish by itself |
|---|---|---|
| Process/session security | service/token/session/pipe/ACL logic on that virtual image; console/RDP lifecycle; malformed-client containment | physical firmware, device drivers, OEM policy, all hypervisor/VDI agents, every enterprise hardening stack |
| Browser acquisition | synthetic exact-build schema, locks, direct-read/backup/defer, source-write tracing | every real profile provider, storage filter, synchronizer, disk failure, customer extension/security stack |
| Packaging | MSI install/repair/upgrade/rollback/uninstall, file manifests, signatures, architecture on the VM | physical ARM64 reliability, OEM deployment stack, every enterprise software-distribution product |
| Power state machine | injected notifications, VM suspend/resume/hibernate where exposed, crash/restart logic | Modern Standby energy use, battery drain, firmware wake, S3/S4 hardware timing, connected-standby networking |
| Network | synthetic direct/proxy/PAC/TLS fault harness and selected enterprise test network | every customer proxy authentication, VPN route, certificate interception, captive portal, DNS policy |
| EDR | Defender and installed product policy on that image | another product/version/policy/cloud tenant, real SOC workflows, broad performance/false-positive distribution |
| RDS/VDI | configured RDS/AVD/Citrix/FSLogix reference environment | a differently configured customer farm, storage backend, image lifecycle, profile conflict policy, licenses and operations |

---

# 3. Recommended design with exact component responsibilities and trust boundaries

## 3.1 Design principle

**RECOMMENDATION.** Compatibility is a release safety control, not a marketing string and not a dynamic tenant rule engine. Product/release authority defines the finite environment vocabulary and approved tuples. Tenant policy may disable or narrow a tuple. The endpoint observes harmless local facts, evaluates them against the signed manifest, and either enables a specifically qualified capability or emits a bounded value-free health reason.

## 3.2 Components and responsibilities

| Component | Normative responsibility | Forbidden responsibility | Trust boundary |
|---|---|---|---|
| Compatibility Authority | Own finite vocabularies, tuple schema, evidence requirements, expiry, and support-state transitions | Approve business/legal purpose; invent runtime facts; sign arbitrary tenant logic | Product/release governance |
| Qualification Evidence Registry | Store immutable evidence envelopes, artifact digests, exact environment facts, failures, cleanup receipts, and reviewer decisions | Store raw URLs, profile paths, user identities, credentials, network addresses, or unredacted traces | Restricted engineering evidence boundary |
| Manifest Compiler | Compile only accepted, unexpired evidence and human coverage decisions into a canonical manifest | Fetch evidence at endpoint runtime; broaden policy; accept missing gates | Trusted release build lane |
| Manifest Signer/Publisher | Sign and publish the canonical digest under purpose-separated release authority | Build binaries; rewrite manifest content; sign stale/unreviewed evidence | Separate signing/promotion boundary |
| Coordinator Environment Probe | Read bounded harmless machine facts: OS family/edition/version/build, architecture, package identity, service/runtime/native modules, machine network/security classes | Enumerate users/profiles, collect addresses, read browser history, infer customer identity or location | Low-privilege machine context |
| User Host Session/Profile Probe | Read exact-session facts: session class, eligibility, profile-provider class, root capability, browser product/channel/build, same-source collision state | Send user/profile names, paths, SIDs, account labels, raw policy values, URLs, or browser content | Ordinary-token exact session |
| Fixed Browser Task Host Probe | Run synthetic schema/acquisition self-tests and return minimized capability results | Browse arbitrary profiles, upload raw database/schema samples, run general SQL/scripts/plugins | Restricted short-lived capability |
| Compatibility Evaluator | Meet/intersect product manifest, tenant narrowing, kill switches, evidence expiry, observed facts, and runtime capability | Guess unknowns; accept nearest match; authorize a family/major when exact tuple is required | Coordinator pure policy boundary |
| Feature/Kill-Switch Evaluator | Disable source, browser, profile, session, network, architecture, build, ring, or global capability | Enable an unqualified capability; bypass manifest expiry | Release + emergency narrowing authority |
| Health Reporter | Emit finite reason/state codes and bounded exact inventory only through approved diagnostic contract | Dynamic metric labels, raw exception text, exact paths/hosts/users, silent success | Endpoint privacy boundary |
| Lab Orchestrator | Provision/revert disposable lanes, run synthetic fixtures/faults, capture redacted evidence, verify cleanup | Hold production credentials; use real activity; mutate customer systems | Trusted test infrastructure |
| Customer Readiness Collector | Gather questionnaire answers and optional signed aggregate capability inventory | Declare support, request sensitive configuration, or upload raw GPO/EDR/proxy/profile data | Human pre-deployment workflow |
| Release Gate | Block promotion when any supported tuple lacks current evidence, package architecture, rollback, or cleanup proof | Waive primary invariants; rebuild per environment | Trusted release pipeline |
| Support CLI | Display local bounded state, evidence/manifest IDs, and safe diagnostics after authorization | Export raw profile/source/network/security values or create an exclusion | Local authorized support boundary |

## 3.3 Trust-boundary flow

```text
Primary sources + T1 fixtures + approved lab/customer-like environments
        -> qualification lanes
        -> immutable evidence envelopes + cleanup receipts
        -> independent review
        -> compatibility decision record
        -> canonical PlatformCompatibilityManifest
        -> separate signing and same-digest promotion

Endpoint startup / relevant change
        -> Coordinator harmless machine inventory
        -> authenticated User Host session/profile inventory
        -> optional fixed Task Host synthetic capability self-test
        -> strict manifest match + tenant narrowing + kill switches
        -> SUPPORTED capability permit
           OR value-free CONDITIONAL/TEST_ONLY/UNSUPPORTED/EXPIRED/SAFETY_HOLD health
```

No environment fact supplied by an upload payload establishes realm, installation, device, or user authority. Realm comes from authenticated registration, as required by the accepted baseline.

## 3.4 Compatibility state vocabulary

| State | Meaning | May collect? | May be advertised as supported? |
|---|---|---:|---:|
| `UNKNOWN` | Required fact missing, conflicting, or unparseable | No | No |
| `UNSUPPORTED` | Explicit product decision or fundamental mismatch | No | No |
| `TEST_ONLY` | Fixture/sentinel lane only; no customer collection | No | No |
| `CONDITIONAL` | May be evaluated in a named controlled pilot/lab under an unexpired exception; not general support | Only if the exception explicitly permits a synthetic/approved test and no primary invariant is waived | No |
| `QUALIFIED` | Technical evidence passed, but human coverage/support/release approval not complete | No live production collection | No |
| `SUPPORTED` | Exact tuple is in an active manifest and all technical/human conditions are current | Only named capabilities | Yes, with exact scope |
| `DEPRECATED` | Still supported for a declared transition window, no new enablement by default | Existing approved installations only if manifest says so | Yes, with end date and migration path |
| `EXPIRED` | Vendor, evidence, manifest, release, or exception expiry reached | No new collection; drain/retain durable state safely | No |
| `SAFETY_HOLD` | Security, privacy, identity, durability, cleanup, source-write, update, or evidence-integrity signal | No | No |

## 3.5 Rolling compatibility policy

### 3.5.1 Rule

A tuple is `SUPPORTED` only when all of these identifiers match:

```text
product release + privileged-boundary package digest
+ OS family + edition + servicing channel + version + build range + update class
+ process architecture + package RID + every loaded native module architecture
+ .NET runtime/source revision + native SQLite source ID/compile profile
+ browser product + channel + exact build range + source-schema capability
+ session topology + profile-provider/access mode + same-source concurrency class
+ power capability class
+ network/proxy/TLS class
+ endpoint-security product/version/policy class
+ required G0–G5 and release/update evidence set
+ evidence/manifest/exception expiry
```

A wildcard is legal only for a property whose equivalence class has been explicitly proved. For example, a build interval may be used only when every build in the interval is either tested or a bounded equivalence argument plus sentinel evidence is accepted. “All Windows 11” and “Edge 150+” are prohibited wildcards.

### 3.5.2 Expiry

Support expires at the earliest of:

1. vendor servicing end for any mandatory platform;
2. manifest `notAfter`;
3. evidence `validUntil`;
4. product release end or revocation;
5. package/runtime/native dependency security-rebuild deadline;
6. browser source-schema capability invalidation;
7. exception expiry;
8. active incident safety hold;
9. human deprecation end date.

An endpoint with an expired manifest may upload already minimized durable data only under the separately qualified transport/replay policy; it MUST NOT start new source collection.

## 3.6 Rolling support matrix — Windows editions and releases

**Status below is the recommended policy at research close, not proof of support.** `Target` means the first lanes should attempt it. `Conditional` means separate customer/business need and evidence. `Test-only` means compatibility sentinel or migration evidence. `Unsupported` means no implementation commitment in this slice.

| Platform | Recommended status | Reason and exact condition |
|---|---|---|
| Windows 11 Enterprise 25H2 x64 | **Target / currently unqualified** | Current managed-client candidate; qualify exact build(s), policies, G1–G5, package, update, resource, rollback, and cleanup. |
| Windows 11 Education 25H2 x64 | **Target / currently unqualified** | Same kernel line does not remove edition-policy differences; run exact edition lane. |
| Windows 11 Enterprise/Education 24H2 x64 | **Target / currently unqualified** | Supported by Microsoft beyond Home/Pro 24H2 end; exact build and deprecation plan required [W01]. |
| Windows 11 Home 24H2/25H2 | **Unsupported initially** | Unmanaged/consumer policy and support model are not required by evidence; human coverage decision could reopen. |
| Windows 11 Pro 24H2/25H2 | **Conditional** | Technically plausible, but management, licensing, security, and support expectations differ; exact customer need and lanes required. |
| Windows 11 26H1 | **Test-only sentinel** | Hardware-scoped line for new devices, not an in-place update from 24H2/25H2; likely overlaps ARM64/new hardware risks [W01]. |
| Windows 11 Enterprise LTSC 2024 | **Conditional/test-only** | Special-purpose channel; Edge is not in-box under the same model and external tool support can diverge [W05]. Separate browser packaging/policy and operations case required. |
| Windows 11 IoT Enterprise LTSC 2024 | **Unsupported initially** | Fixed-function/specialty-device lifecycle and licensing; no approved UAM use case [W01, W05]. |
| Windows 11 Enterprise multi-session | **Conditional/test-only** | Requires AVD/RDS/session/profile/source-concurrency lanes; no visit-origin session claim. |
| Windows 10 22H2 standard editions | **Unsupported** | Standard Windows 10 servicing ended 14 October 2025; Edge updates/ESU do not by themselves qualify UAM. |
| Windows 10 LTSC/IoT LTSC | **Unsupported initially** | A distinct special-purpose support, browser, runtime, and security matrix would be required. |
| Windows Server 2025 Desktop Experience/RDSH x64 | **Conditional/test-only** | Server lifecycle is current, but interactive-session, browser, Defender role exclusions, RDS, licensing, and operations differ [W03]. |
| Windows Server 2025 Core | **Unsupported** | No ordinary desktop/browser user-session first-slice fit. |
| Windows Server 2022 Desktop Experience/RDSH x64 | **Test-only/deprecation candidate** | Mainstream support ends 13 October 2026; a new commitment now needs explicit transition value [W04]. |
| Windows Server 2022 Core | **Unsupported** | No first-slice desktop/browser fit. |
| Older Server releases | **Unsupported** | No supplied requirement and larger lifecycle/security/compatibility cost. |

## 3.7 Architecture matrix

| Architecture/runtime form | Recommended state | Normative rule |
|---|---|---|
| Native x64 OS + `win-x64` self-contained payload | **Target** | Every EXE/DLL/native asset MUST be x64 or an explicitly approved architecture-neutral managed assembly; loaded-module inventory must match. |
| Native ARM64 OS + `win-arm64` self-contained payload | **Test-only until physical lane** | Separate MSI/product code, file manifest, SBOM/provenance, native SQLite, interop, signing, install/rollback, resource, power, and cleanup evidence. |
| x64 UAM package under ARM64 emulation | **Unsupported** | Installation success is not native compatibility; mixed-architecture injection/EDR/interop/SQLite behavior is a separate unproved system [W11]. |
| Arm64EC mixed process | **Unsupported** | Unnecessary mixed-ABI complexity and threat surface for the first slice. |
| AnyCPU/portable executable as privileged deployable | **Unsupported** | Architecture selection becomes environment-dependent and native asset mistakes can hide until runtime. |
| Framework-dependent global .NET runtime | **Rejected initially** | Reduces package size but allows estate runtime drift and environment-dependent roll-forward; reconsider only with equivalent patch/rollback evidence. |
| Single-file bundle | **Deferred** | Platform-specific but adds extraction/startup/diagnostic/EDR behavior; no demonstrated need [W10]. |
| Native AOT | **Deferred** | Potential footprint/startup benefits do not justify interop/reflection/debugging differences before baseline evidence. |

## 3.8 Browser matrix

| Browser/channel | Recommended state | Qualification policy |
|---|---|---|
| Microsoft Edge Stable | **Target** | Exact qualified build and source-schema capability only. Every security/minor update triggers targeted source/privacy regression. |
| Microsoft Edge Extended Stable | **Conditional target** | Preferred where customer management policy chooses eight-week major cadence; exact servicing build still required [W06, W07]. |
| Microsoft Edge Beta | **Test-only sentinel** | Detect upcoming schema/policy/runtime changes; never production source authority. |
| Edge Dev/Canary | **Unsupported** | No supported lifecycle and excessive drift [W07]. |
| Edge command-line-only custom user-data root | **Unsupported** | Safe discovery would require broader process inspection; Batch 02 rejected it. |
| Google Chrome Stable/Extended Stable | **Test-only/future source family** | Browser installation/schema fixtures may run, but no collection support without a new source contract and full G2–G5 evidence. |
| Chrome Beta/Dev/Canary | **Test-only sentinel or unsupported** | Preview drift only; no production source claim. |
| Firefox Rapid Release | **Detection/schema research only** | Firefox 153.0.1 was current on 28 July 2026, but no UAM acquisition/privacy contract exists [W16]. |
| Firefox ESR | **Detection/schema research only** | ESR reduces major cadence, not source-contract risk; exact ESR branch/point update and profile semantics would need a separate result [W17]. |
| WebView2 | **Unsupported as activity source** | It is not the accepted Edge browser-history source and may have app-specific profile roots. |
| Other Chromium browsers | **Unsupported** | Different update, profile, policy, schema, and support contracts. |

## 3.9 Session and remote-delivery matrix

| Session topology | Recommended state | Rule |
|---|---|---|
| One local console session | **Target** | Exact ordinary token/logon/session, one User Host, G1/G2/G3/G4/G5 pass. |
| One non-concurrent RDP session on client Windows | **Target after console** | Reconnect/disconnect/lock/logoff/service restart and source identity must pass; no origin-session inference. |
| Fast User Switching, different SIDs/profiles | **Conditional** | One User Host per eligible session; cross-session attempts zero; resource budgets aggregate safely. |
| Same SID, separate logons, distinct physical profiles | **Conditional** | Exact logon SID/LUID separation; distinct physical source IDs; no payload session authority. |
| Same SID, concurrent sessions, same physical profile | **Unsupported until dedicated gate** | One source/lease; losing session MUST NOT read or advance; UAM cannot attribute a visit to one session. |
| Windows Server RDS multi-session | **Conditional/test-only** | Server/RDS role, session broker, logon/logoff, profile provider, Defender/EDR, install/update, scale, and cleanup lanes. |
| Azure Virtual Desktop single-session | **Conditional/test-only** | Exact image, join, profile, host-pool, agent, network, update, drain, and support evidence. |
| AVD multi-session | **Conditional/test-only** | Adds same-host concurrent sessions and profile-container semantics; Arm64 Azure VMs are currently not supported for AVD session hosts [W18]. |
| RemoteApp/published browser | **Conditional/test-only** | Shell absence, lifecycle, source ownership, and profile attach/detach must be proved; no assumption from ordinary RDP. |
| Citrix Virtual Apps/Desktops | **Conditional/test-only** | Exact VDA/Profile Management version and policy; one RW/other RO/write-back behavior can discard session changes [W22]. |
| Disconnected/stale remote session | **Paused** | No new run until session eligibility and source/manifest facts revalidate. |

## 3.10 Profile matrix

| Profile/source provider | Recommended state | Compatibility rule |
|---|---|---|
| Local, non-roaming, non-containerized profile on local NTFS | **Target** | Release-owned default or mandatory-policy local Edge root; no recursive crawl. |
| Windows roaming profile | **Conditional/test-only** | Exact profile version, sync/cache behavior, offline/conflict/logoff, source continuity, and cleanup. |
| Folder redirection only | **Conditional** | Edge root must remain an approved local root; redirected arbitrary/network browser roots remain unsupported. |
| FSLogix Profile Container, one connection | **Conditional/test-only** | Exact FSLogix version, VHD/VHDX mode, SMB/storage/identity/AV policy, attach/detach, failover, lock, source identity, and source-write proof [W19–W21]. |
| FSLogix concurrent/multiple connections | **Unsupported until dedicated lane** | Same-container modes differ; AVD host-pool concurrent connection is documented as unsupported; OneDrive forbids same-profile concurrent connections [W20, W21]. |
| FSLogix Cloud Cache | **Conditional/test-only** | Multiple providers, local cache/proxy disks, failover, latency, offline behavior, AV exclusions, and cleanup are separate evidence. |
| Citrix profile container | **Conditional/test-only** | Exact policy can make only one session RW and discard RO-session changes; source completeness and continuity must be tested [W22]. |
| Citrix streamed/file-based profile | **Conditional/test-only** | Hydration, cache, synchronization, exclusion, and logoff semantics must be proved. |
| Mandatory/temporary profile | **Unsupported by default** | Source continuity and purpose are unclear; temporary-profile detection should disable collection. |
| UNC/network Edge user-data root | **Unsupported** | Batch 02 and vendor guidance reject initial network root support. |

## 3.11 Power and lifecycle matrix

| Power/lifecycle state | Support meaning | Required behavior |
|---|---|---|
| Awake S0 | Normal capability if tuple supported | Continue bounded scheduling. |
| Traditional sleep S1–S3 | Lifecycle target on physical hardware | Stop new runs, cancel/defer safely, no cursor advance, revalidate after resume. |
| Modern Standby S0 low-power idle | Physical test-only | UAM is not an activator and does not prevent low power; no background-collection promise; revalidate on resume [W23, W24]. |
| Hibernate S4 | Lifecycle target on physical/qualified VM | Pre-suspend quiesce; restored services/sessions are treated as stale until revalidated [W24]. |
| Fast startup | Separate lifecycle case | User sessions are logged off but session-0 kernel state may be restored; startup self-check and fresh User Hosts required [W24]. |
| Restart/full shutdown S5 | Core target | Clean stop/start, installer/release integrity, no stale IPC/lease/permit. |
| Critical battery/abrupt power loss | Fault case | No reliance on notification; G5/recovery invariants and cleanup on next start. |

UAM MUST register only for notifications needed to pause/revalidate. It MUST NOT use away mode or execution-state calls to keep portable devices awake for collection.

## 3.12 Network/proxy/VPN matrix

| Network class | Recommended state | Rule |
|---|---|---|
| Direct HTTPS, no proxy | **Target** | Exact endpoint/TLS/auth contract, offline queue, retry, network-change revalidation. |
| Explicit machine-context proxy, no auth | **Target candidate** | Exact configured profile; no silent direct bypass. |
| Explicit proxy with machine credentials | **Conditional** | Credential source, service identity, delegation, proxy challenge, lockout, and logging evidence. No credentials in endpoint health/evidence. |
| User-context proxy | **Unsupported for Coordinator transport initially** | Coordinator must not borrow user identity/token; use a separately designed machine path. |
| PAC URL | **Conditional/test-only** | Script download/execution, cache, failover, time/resource bounds, and destination privacy must pass [W30, W31]. |
| WPAD/DHCP/DNS auto-discovery | **Conditional/test-only** | Network-dependent discovery and malicious/misconfigured PAC risk; no silent fallback. |
| TLS interception | **Conditional/test-only** | Trust chain, revocation, mutual-auth/device identity, certificate rotation, content inspection policy, and failure semantics. Never disable validation. |
| VPN present | **Network condition only** | VPN does not establish device/realm identity. Qualify exact route/DNS/proxy transitions and offline behavior. |
| Captive portal | **Unsupported collection/transport state** | Report bounded `NETWORK_CAPTIVE_OR_UNTRUSTED`; retain data; no credential UI or bypass. |
| Metered network | **Conditional scheduling input** | May defer transport under approved policy; cannot silently drop or alter source truth. |

## 3.13 Defender and EDR policy

**RECOMMENDATION — default to zero UAM-specific exclusions.** Defender documentation states that every exclusion is a protection gap and should exist only for a specific demonstrated problem [W27].

Normative rules:

1. UAM MUST pass core lanes with Defender active and no UAM-specific exclusion.
2. Defender passive mode, EDR block mode, Controlled Folder Access audit/block, ASR rules, Smart App Control, WDAC/AppLocker where required, and tamper protection are separate security-policy classes.
3. Third-party EDR support is exact vendor + sensor + engine/content + policy + operating mode + OS + UAM release evidence. “Third-party EDR” is not one class.
4. An EDR exclusion is never an endpoint self-remediation. UAM MUST NOT add, broaden, or remove security exclusions.
5. A proposed exclusion requires a reproducible failure, vendor/customer security coordination, alternatives analysis, smallest scope, explicit effect, owner, expiry, deployment authority, rollback, audit, and regression test.
6. Prohibited exclusion shapes include: entire browser profile; user profile; drive root; recursive UAM process tree; generic executable name without protected path identity; all SQLite files; all network activity; or all files opened by Coordinator/User Host/Task Host.
7. Prefer vendor fix, code/signing/package correction, workload scheduling, or a contextual/narrow allow rule before an AV exclusion.
8. Presence of an unapproved UAM-related exclusion produces `SAFETY_HOLD` or `CONDITIONAL` according to release policy; it never silently improves compatibility status.

## 3.14 Runtime packaging and native-architecture policy

**RECOMMENDATION.** Publish separate self-contained, non-single-file products for `win-x64` and, later, `win-arm64`.

Each package MUST:

- contain only the declared RID assets;
- record exact .NET runtime patch, source revision, package lock, native SQLite source ID/compile options, Windows SDK/interop generator identity, and every native file digest;
- verify PE/COFF machine type for every `.exe`, `.dll`, `.sys`, custom action, and helper using the official machine constants [W12];
- fail CI if an x86/x64 native asset enters ARM64 output or an ARM64 asset enters x64 output;
- verify loaded modules at runtime against the release manifest; an unexpected architecture/native module is `SAFETY_HOLD`;
- avoid runtime downloading, package repair from arbitrary internet sources, and mutable “latest” dependencies;
- install side-by-side only where the release/rollback ADR explicitly allows it;
- use architecture-specific MSI upgrade/product/package identifiers and deterministic file manifests;
- remove every product-owned file/task/service/firewall/certificate/test artifact on uninstall according to the signed install manifest, without broad deletion.

**FACT.** Self-contained publishing includes the .NET runtime and is platform/RID specific; it does not automatically roll forward to later security patches, so UAM owns patch release cadence [W09, W10].

## 3.15 Configuration ownership and feature controls

| Configuration | Owner/authority | Endpoint behavior |
|---|---|---|
| Product representable platform/source/browser/profile/network/security vocabulary | Release/product compatibility authority | Immutable in signed release/manifest |
| Tenant enablement/narrowing | Authenticated realm policy authority | Can disable tuples/capabilities or require narrower bounds only |
| Global/source/browser/profile/build kill switch | Product emergency-narrowing authority | Stops new permits; never enables |
| Local safety disablement | Coordinator self-protection | Stops affected capability on corruption, residue, mismatch, or resource breach |
| OS/browser/EDR/proxy/VDI configuration | Customer platform/security authority | Observed read-only and classified; UAM does not rewrite it |
| Exception | Separate compatibility/risk approval authority | Narrow, time-bound, exact tuple; cannot waive primary invariant |
| Support/deprecation statement | Product/support human authority | Must match active manifest and published migration window |

## 3.16 Privacy-safe observability and accessibility

Endpoint metric dimensions MUST come from a finite release-owned vocabulary such as:

```text
component
compatibility_state
reason_family
os_family
architecture
browser_family
browser_channel_class
session_class
profile_provider_class
network_class
security_product_class
power_state_class
release_ring
```

Exact build numbers, product versions, evidence digests, manifest IDs, and package hashes belong in bounded inventory/evidence records, not metric labels. User, SID, session ID, host name, domain, tenant name, profile label/path, browser URL, proxy address, VPN name, EDR policy name, certificate subject, network SSID, or exception text MUST NOT be metric labels.

Administrative and support interfaces MUST:

- expose stable codes plus human-readable explanations;
- not rely on color alone;
- support keyboard navigation, screen readers, text scaling, and copyable machine-readable output;
- clearly distinguish `unsupported`, `unknown`, `temporarily unavailable`, `privacy-disabled`, and `healthy` so absence is not interpreted as no activity;
- never pop up UI or interrupt the monitored user from Coordinator/User Host compatibility logic.

## 3.17 Threat modelling, secure coding, and review gates

Every deployable, privileged mutation, compatibility detector, parser, native interop boundary, installer action, and support diagnostic MUST have a repository-owned threat model. The model MUST identify assets, trust boundaries, attacker positions, forbidden data, elevation/session/realm paths, update and rollback threats, enterprise-policy interference, failure containment, cleanup, and the exact tests that falsify the claimed control. A change that alters a trust boundary, source field, process/token/ACL, IPC message, native dependency, installer mutation, compatibility authority, EDR/proxy behavior, or diagnostic sink MUST update the threat model before merge.

The secure coding and review baseline is:

1. C# nullable analysis, warnings-as-errors, deterministic analyzers, dependency/source locks, architecture tests, secret/canary scans, and banned-API rules MUST run in the trusted validation lane. Suppression requires a narrow code-local justification, owner, expiry or removal trigger, and a test showing the intended boundary remains enforced.
2. Unsafe code and P/Invoke MUST be isolated in the Windows interop project. Public callers receive typed safe handles and finite result codes, not raw pointers, unmanaged buffers, arbitrary handles, paths, command lines, or native exception text. Every native allocation, duplicated/inherited handle, callback, and cancellation path MUST have ownership and cleanup tests.
3. Parsers and detectors MUST be closed, bounded, cancellation-aware, allocation/time limited, culture-independent where identity is involved, and hostile-input tested. They MUST NOT execute tenant text, scripts, regular expressions, PAC content outside the approved network lane, dynamic plug-ins, reflection-discovered capabilities, or untrusted type metadata.
4. Raw browser values and sensitive environment facts MUST use types that cannot be referenced by Coordinator storage, transport, logs, metrics, health, or support projects. Exceptions MUST map to stable value-free codes; exception messages, paths, proxy addresses, profile names, security-product details, and source values are never ordinary telemetry.
5. Authentication, authorization, compatibility, and cleanup decisions MUST fail closed on ambiguity, arithmetic overflow, invalid encoding, unsupported enum/version, partial inventory, stale evidence, cancellation, timeout, or dependency mismatch. Retry logic MUST be bounded and MUST NOT convert a permanent or security failure into progress.
6. Security/privacy-sensitive changes require review by the accountable Windows/security function and the owning privacy/data-boundary function; installer/release, storage/durability, browser, network, or VDI reviewers are additionally required when their boundary changes. These are reviewer functions, not claims that named organizational roles are already assigned. The change record binds reviewed files, threat-model delta, generated/native code diff, tests, residual risk, and rollback/cleanup impact by digest.
7. Generated interop, schema, serializer, installer, and dependency-update diffs MUST be reviewed as executable code. A zero-exit generator, static analyzer, antivirus scan, or AI review is supporting evidence only; none is the sole approval oracle.
8. A security finding, unexplained analyzer regression, canary escape, native crash, handle/resource leak, cross-session/realm result, unowned suppression, or missing cleanup proof blocks promotion. The correction reruns the affected lane and every adjacent lane named by the threat-model dependency graph.

---

# 4. Alternatives, rejection reasons, and conditions that would change the choice

| Alternative | Decision | Rejection reason | Evidence that could change it |
|---|---|---|---|
| Claim support by vendor lifecycle and minimum OS version | **Rejected** | Lifecycle means vendor servicing, not G1–G5, update, EDR, source, resource, or cleanup fitness. | None without converting the claim into exact evidence-backed tuples. |
| “Current and previous Windows/Edge versions” global rule | **Rejected** | Version cadence and support topology differ; a relative rule silently changes. | Per-family executable compatibility policy with exact evidence and expiry. |
| Support every Windows 11 edition sharing a build | **Rejected** | Edition, policy, management, licensing, multi-session, security, and servicing differ. | Exact edition equivalence campaign and accepted support commitment. |
| One AnyCPU or x64 package for x64 and ARM64 | **Rejected** | Native dependencies, interop, installer custom actions, EDR, and emulation differ. | No expected need; native architecture-specific products remain simpler. |
| x64 emulation counts as ARM64 support | **Rejected** | Running is not native compatibility; mixed architecture adds unproved behavior. | A human requirement plus full emulation-specific lanes and accepted ADR; native remains preferred. |
| Framework-dependent .NET | **Rejected initially** | Runtime patch/version can differ per endpoint and complicate exact qualification/rollback. | Enterprise runtime ownership proves stronger servicing and identical behavior with lower cost. |
| Single-file or Native AOT immediately | **Deferred** | New extraction/interop/trimming/debugging/EDR surface without a measured need. | Measured resource/deployment need and complete package/security/cleanup comparison. |
| Qualify browser major only | **Rejected** | Minor/security updates can change browser binaries, schema, locks, policies, and controlled rollouts. | Exact evidence proves a bounded interval is equivalent; sentinel remains required. |
| Treat Edge Extended Stable as automatically safer | **Rejected as proof** | Slower major cadence does not remove minor servicing or source-contract drift. | Measured lower qualification/incident cost and customer policy decision. |
| Add Chrome/Firefox because their DBs appear similar | **Rejected** | Different schemas, profiles, locks, semantics, channels, and source contracts. | New source-specific G2–G5 research and human scope decision. |
| Treat one RDP test as RDS/AVD/Citrix support | **Rejected** | Multi-session, brokers, agents, image lifecycle, profile containers, storage, and licensing differ. | Exact platform lane for each named product/version/configuration. |
| Treat FSLogix/Citrix vendor support as UAM support | **Rejected** | Their concurrent read/write/discard/cache/failover behavior can change source completeness and identity. | Exact synthetic source and failure evidence under the chosen configuration. |
| Infer visit-origin session from acquisition session | **Rejected** | A shared browser database cannot prove which simultaneous session caused a row. | A different approved source with authoritative origin identity; requires baseline change. |
| Keep collecting through sleep/Modern Standby | **Rejected** | Can increase battery drain, create stale state, and rely on unpredictable activations. | A product need plus physical power instrumentation showing bounded impact and no invariant risk. |
| Rely on `HttpClient.DefaultProxy` and user proxy settings | **Rejected for Coordinator** | Default proxy can read user settings/environment and vary by context; Coordinator cannot borrow user identity. | Explicit machine-context network profile with tested authentication and no privacy/identity violation. |
| Fall back direct when proxy/PAC fails | **Rejected** | Can bypass enterprise egress controls and leak destination metadata. | Only an explicit release/customer policy that authorizes both paths and proves no bypass. |
| Disable TLS validation for interception compatibility | **Rejected** | Breaks authentication and custody security. | No acceptable condition. Install/qualify enterprise trust correctly or fail closed. |
| Broad antivirus/EDR exclusions | **Rejected** | Creates a large protection gap and can bypass ASR/network inspection [W27]. | No broad exclusion is acceptable; only exact narrow temporary exceptions may be reviewed. |
| Let endpoint create its own EDR allow rule | **Rejected** | Self-authorization defeats security ownership and audit. | No acceptable condition. |
| Treat EDR product name as compatibility | **Rejected** | Sensor, engine/content, policy, mode, cloud service, OS, and release all matter. | Exact configuration family equivalence evidence. |
| Permanent customer waiver | **Rejected** | Stale risk becomes silent support and can outlive evidence/releases. | No permanent waiver; human deprecation/unsupported choice is explicit instead. |
| Waive source-write, privacy, cross-session/realm, cursor-ahead, unauthorized release, or cleanup failures | **Rejected** | These are accepted primary invariants. | Only a full accepted-baseline change proposal replacing the mechanism; not an exception. |
| Dynamic online compatibility service required at startup | **Rejected initially** | Adds availability and central authority dependency to offline endpoints. | A later operational need with signed cached fallback and no availability/privacy regression. |
| Customer uploads raw GPO, EDR logs, PAC files, profile paths, or activity for readiness | **Rejected** | Excessive sensitive configuration and activity exposure. | Use sanitized booleans/classes or controlled on-site evidence; raw data remains outside this workflow. |

---

# 5. Interfaces/protocols and example contracts or schemas

## 5.1 Contract ownership and boundary rules

**RECOMMENDATION.** Compatibility is a release and runtime authorization boundary, not a diagnostic convenience. Its contracts therefore follow the accepted strict UAM contract profile from Batch 01:

1. objects are closed by default; duplicate, unknown, wrong-case, invalid, unbounded, and trailing members are rejected;
2. all identifiers use their declared types; new UAM identifiers are canonical lower-case UUIDv7 and digests are algorithm-qualified;
3. realm, installation, device, user, and session authority comes from authenticated context, never from an endpoint payload claim;
4. only release-owned finite vocabularies may influence collection authority;
5. tenant policy may select or narrow a release-owned compatibility tuple but cannot invent an OS, package, executable, proxy, EDR, or exception rule;
6. manifests and exception artifacts are canonical, immutable, content-addressed, signature-verified, audience/realm bound where applicable, monotonic, and expiry limited;
7. runtime inventory is descriptive evidence only. It cannot grant capability absent from an active manifest;
8. a manifest or exception parser failure never falls back to an older or broader interpretation;
9. compatibility output contains no raw user-owned source value, path, URL, proxy address, network name, account, SID, certificate subject, security-event detail, or customer policy text;
10. every protocol has hard byte, item, nesting, processing-time, and allocation limits chosen by CLI evidence rather than left implementation-defined.

The initial physical encoding SHOULD be the accepted strict UTF-8 JSON profile. Exact signature serialization and algorithm remain under the Batch 01 signed-control-artifact ADR; this result requires the security properties, not an unapproved algorithm.

## 5.2 `PlatformCompatibilityManifest`

The release authority publishes one immutable manifest per product release or a higher-revision replacement. A manifest may add evidence-backed tuples, narrow or revoke tuples, or republish an earlier semantic set at a higher sequence. It MUST NOT make a lower revision current.

### 5.2.1 Normative logical schema

```json
{
  "schemaVersion": "1.0.0",
  "manifestId": "019d1234-5678-7abc-8def-0123456789ab",
  "sequence": 42,
  "productReleaseId": "uam-endpoint-2026.08-r1",
  "productCeilingDigest": "sha-256:0000000000000000000000000000000000000000000000000000000000000000",
  "issuedAtUtc": "2026-07-31T12:00:00Z",
  "notBeforeUtc": "2026-07-31T12:00:00Z",
  "notAfterUtc": "2026-09-30T00:00:00Z",
  "minimumEvaluatorVersion": "1.0.0",
  "packages": [
    {
      "packageId": "endpoint-win-x64",
      "rid": "win-x64",
      "architecture": "X64",
      "installerType": "MSI",
      "installerSha256": "0000000000000000000000000000000000000000000000000000000000000000",
      "fileManifestSha256": "0000000000000000000000000000000000000000000000000000000000000000",
      "dotnetRuntime": "10.0.10",
      "nativeSqliteSourceId": "fictional-source-id",
      "signingProfileId": "release-signing-v1"
    }
  ],
  "tuples": [
    {
      "tupleId": "win11-ent-25h2-x64-edge-stable-local-v1",
      "state": "QUALIFIED",
      "packageId": "endpoint-win-x64",
      "capabilityIds": [
        "g1.session-ipc.v1",
        "g2.edge-direct-read.v1",
        "g3.edge-native-id-cursor.v1",
        "g4.url-host-ascii.v1",
        "g5.atomic-page-commit.v1",
        "release.msi-upgrade-rollback.v1"
      ],
      "environment": {
        "os": {
          "family": "WINDOWS_11",
          "editionClasses": ["ENTERPRISE", "EDUCATION"],
          "displayVersion": "25H2",
          "buildMinimum": 26200,
          "buildMaximum": 26200,
          "ubrAllowlist": [8973]
        },
        "architecture": {
          "osArchitecture": "X64",
          "processArchitecture": "X64",
          "emulation": "NONE"
        },
        "browser": {
          "family": "EDGE",
          "channels": ["STABLE"],
          "versionAllowlist": ["150.0.4078.105"],
          "sourceCapabilityId": "edge-history-schema-capability-fictional"
        },
        "session": {
          "classes": ["CONSOLE_SINGLE", "RDP_SINGLE_NONCONCURRENT"],
          "maximumEligibleInteractiveSessions": 1,
          "sameSidConcurrentSessions": "DISALLOWED"
        },
        "profile": {
          "provider": "WINDOWS_LOCAL",
          "containerization": "NONE",
          "roaming": "NONE",
          "rootStorage": "LOCAL_FIXED_DISK"
        },
        "power": {
          "supportedTransitions": ["LOCK", "UNLOCK", "S3_RESUME", "S4_RESUME"],
          "modernStandby": "NOT_CLAIMED"
        },
        "network": {
          "profiles": ["DIRECT_EXPLICIT", "MACHINE_PROXY_EXPLICIT"],
          "pac": "DISALLOWED",
          "tlsInterception": "DISALLOWED",
          "vpnDependency": "NONE"
        },
        "security": {
          "productClasses": ["DEFENDER_PRIMARY"],
          "uamSpecificExclusion": "DISALLOWED",
          "controlledFolderAccessStates": ["OFF", "AUDIT", "ENFORCED_QUALIFIED"]
        }
      },
      "requiredEvidence": [
        {
          "laneId": "L2-CORE-X64",
          "evidenceRootSha256": "0000000000000000000000000000000000000000000000000000000000000000",
          "completedAtUtc": "2026-07-31T11:00:00Z",
          "validUntilUtc": "2026-08-31T00:00:00Z"
        }
      ],
      "validUntilUtc": "2026-08-31T00:00:00Z",
      "deprecation": {
        "state": "ACTIVE",
        "announcedAtUtc": null,
        "collectionStopsAtUtc": null,
        "supportEndsAtUtc": null,
        "replacementTupleIds": []
      }
    }
  ],
  "killSwitches": [
    {
      "scope": "BROWSER_VERSION",
      "selector": "EDGE:150.0.4078.105",
      "action": "DISABLE_NEW_COLLECTION_PERMITS",
      "reasonCode": "COMPAT_BROWSER_EMERGENCY_STOP"
    }
  ],
  "signatureProfileId": "control-artifact-profile-provisional"
}
```

All example hashes and identifiers are fictional. The example does not claim that the tuple has passed.

### 5.2.2 Manifest invariants

A manifest evaluator MUST establish all of the following before a tuple can authorize collection:

```text
signature/authorization valid
AND productReleaseId equals the running protected release
AND package digest and loaded-file manifest equal the declared package
AND sequence is strictly greater than the last accepted sequence, or byte-identical retry
AND evaluator understands schema and every authority-bearing enum
AND current time is within manifest and tuple evidence windows with acceptable clock confidence
AND observed environment matches exactly one active tuple
AND every required capability evidence is present, unexpired, and for the same source tree/package/environment class
AND no global, package, browser, tuple, source, security, or local safety kill switch applies
AND effective realm policy selects/narrows the tuple
```

Zero or multiple matching tuples is `COMPATIBILITY_UNKNOWN`; it is not resolved by row order or “closest match.”

## 5.3 Endpoint environment inventory schema

The `uam-compat inventory` command and Coordinator self-check emit a bounded, privacy-safe inventory. It describes harmless platform facts needed to find a manifest tuple. It MUST NOT inspect browser activity, enumerate arbitrary installed software, crawl profiles, read PAC contents, dump GPO, collect network addresses, or list usernames.

```json
{
  "schemaVersion": "1.0.0",
  "inventoryId": "019d1234-5678-7abc-8def-0123456789ac",
  "observedAtUtc": "2026-07-31T12:05:00Z",
  "collectorBuildId": "uam-compat-1.0.0",
  "os": {
    "family": "WINDOWS_11",
    "editionClass": "ENTERPRISE",
    "installationType": "CLIENT",
    "displayVersion": "25H2",
    "build": 26200,
    "ubr": 8973,
    "servicingChannelClass": "GENERAL_AVAILABILITY",
    "isServerCore": false,
    "isMultiSessionSku": false
  },
  "architecture": {
    "nativeMachine": "AMD64",
    "osArchitecture": "X64",
    "coordinatorProcess": "X64",
    "userHostProcess": "X64",
    "taskHostProcess": "X64",
    "emulationObserved": false
  },
  "package": {
    "packageId": "endpoint-win-x64",
    "installerSha256": "0000000000000000000000000000000000000000000000000000000000000000",
    "fileManifestSha256": "0000000000000000000000000000000000000000000000000000000000000000",
    "loadedUnexpectedModuleCount": 0
  },
  "browser": {
    "edge": {
      "installed": true,
      "channelClass": "STABLE",
      "version": "150.0.4078.105",
      "executableSignatureState": "TRUSTED_EXPECTED_PUBLISHER",
      "policyRootClass": "DEFAULT_OR_MANAGED_LOCAL"
    },
    "chrome": {"installed": true, "channelClass": "STABLE", "version": "151.0.7922.72"},
    "firefox": {"installed": false, "channelClass": "NONE", "version": null}
  },
  "session": {
    "currentClass": "CONSOLE",
    "eligibleInteractiveSessionCount": 1,
    "sameSidConcurrentSessionClass": "NONE_OBSERVED",
    "remoteDeliveryClass": "NONE"
  },
  "profile": {
    "providerClass": "WINDOWS_LOCAL",
    "containerClass": "NONE",
    "rootStorageClass": "LOCAL_FIXED_DISK",
    "currentProfileAttached": true,
    "concurrentAccessClass": "NONE_OBSERVED"
  },
  "power": {
    "availableSleepClasses": ["S3", "S4"],
    "modernStandbyCapable": false,
    "batteryPresent": false,
    "lastTransitionState": "ACTIVE"
  },
  "network": {
    "machineProxyClass": "STATIC_EXPLICIT",
    "autoDetectEnabled": false,
    "pacConfigured": false,
    "tlsInterceptionClass": "NOT_OBSERVED",
    "vpnClass": "NONE_OBSERVED",
    "connectivityClass": "INTERNET_AVAILABLE"
  },
  "security": {
    "primaryProductClass": "DEFENDER",
    "sensorHealthClass": "HEALTHY",
    "realTimeProtectionClass": "ENABLED",
    "controlledFolderAccessClass": "AUDIT",
    "uamSpecificExclusionClass": "NONE_OBSERVED",
    "binaryReputationClass": "NOT_QUARANTINED"
  },
  "redaction": {
    "mode": "STRICT",
    "forbiddenFieldCount": 0
  }
}
```

Exact browser versions are permitted in this bounded inventory because they are necessary for qualification. They MUST NOT become unbounded metric labels. Product names other than a finite release-owned browser/security classification are absent. A third-party EDR may be represented by a release-owned opaque product/configuration-family ID approved for that vendor lane; arbitrary display names or tenant policy text are forbidden.

## 5.4 Compatibility evaluation and health contract

```json
{
  "schemaVersion": "1.0.0",
  "evaluatedAtUtc": "2026-07-31T12:05:01Z",
  "manifestId": "019d1234-5678-7abc-8def-0123456789ab",
  "manifestSequence": 42,
  "productReleaseId": "uam-endpoint-2026.08-r1",
  "state": "UNSUPPORTED",
  "collectionAuthorization": "DISABLED",
  "matchedTupleId": null,
  "reasonCodes": ["COMPAT_NO_EXACT_TUPLE"],
  "capabilities": [
    {"id": "g1.session-ipc.v1", "state": "NOT_AUTHORIZED"},
    {"id": "g2.edge-direct-read.v1", "state": "NOT_AUTHORIZED"}
  ],
  "evidence": {
    "earliestExpiryUtc": null,
    "staleEvidenceCount": 0,
    "missingEvidenceCount": 1
  },
  "recommendedActionCode": "CONTACT_PLATFORM_OWNER_OR_INSTALL_SUPPORTED_RELEASE",
  "diagnosticDetailAvailableLocally": true
}
```

The stable state vocabulary is:

| State | Meaning | Collection behavior |
|---|---|---|
| `SUPPORTED` | Exact active tuple and all evidence match. | Only listed capabilities may receive permits. |
| `CONDITIONAL` | Exact approved exception or restricted customer condition applies. | Only exception-scoped capabilities; visibly not a support claim. |
| `TEST_ONLY` | Lab tuple exists but product/support has not accepted it. | T1/synthetic lab only. |
| `UNSUPPORTED` | Known tuple is explicitly excluded or outside commitment. | Disabled. |
| `UNKNOWN` | Inventory incomplete, ambiguous, newer/unrecognized, or evaluator cannot decide. | Disabled. |
| `EXPIRED` | Manifest, evidence, vendor lifecycle, release, or exception window ended. | Disabled. |
| `SAFETY_HOLD` | Security/privacy/durability/cleanup invariant or control-artifact integrity failed. | New work stopped; stale work discarded; incident path. |
| `TEMPORARILY_UNAVAILABLE` | Supported tuple exists but session/profile/network/security/runtime condition is transiently unavailable. | No new acquisition; bounded retry according to policy. |
| `PRIVACY_DISABLED` | Product/tenant/emergency privacy policy disallows the capability. | Disabled; not a compatibility failure. |

`SUPPORTED` is never inferred from a green health bit alone. Health is a runtime observation under an already authorized tuple.

## 5.5 Qualification evidence envelope

Every lane emits an immutable envelope. Raw ETW, ProcMon, power, EDR, profile-container, network, or browser traces remain in the restricted lab and are deleted/reverted after sanitized findings are approved.

```json
{
  "schemaVersion": "1.0.0",
  "experimentId": "E14-L2-CORE-X64-001",
  "claim": "Exact x64 tuple passes security, acquisition, update, durability, resource, and cleanup gates",
  "laneId": "L2-CORE-X64",
  "classification": "T1",
  "startedAtUtc": "2026-07-31T09:00:00Z",
  "endedAtUtc": "2026-07-31T10:00:00Z",
  "sourceTreeSha256": "0000000000000000000000000000000000000000000000000000000000000000",
  "package": {
    "installerSha256": "0000000000000000000000000000000000000000000000000000000000000000",
    "fileManifestSha256": "0000000000000000000000000000000000000000000000000000000000000000"
  },
  "environmentInventorySha256": "0000000000000000000000000000000000000000000000000000000000000000",
  "fixtureRootSha256": "0000000000000000000000000000000000000000000000000000000000000000",
  "assertions": [
    {"id": "NO_CROSS_SESSION_ACCEPT", "result": "PASS", "observedCount": 0},
    {"id": "SOURCE_WRITE_COUNT", "result": "PASS", "observedCount": 0},
    {"id": "FORBIDDEN_VALUE_ESCAPE_COUNT", "result": "PASS", "observedCount": 0},
    {"id": "CURSOR_AHEAD_COUNT", "result": "PASS", "observedCount": 0},
    {"id": "CLEANUP_RESIDUE_COUNT", "result": "PASS", "observedCount": 0}
  ],
  "resourceSummary": {
    "budgetProfileId": "lab-budget-provisional-v1",
    "allHardLimitsRespected": true
  },
  "artifacts": [
    {"kind": "SANITIZED_REPORT", "sha256": "0000000000000000000000000000000000000000000000000000000000000000"}
  ],
  "canaryScan": {
    "scannerSha256": "0000000000000000000000000000000000000000000000000000000000000000",
    "positiveControlsPassed": true,
    "escapeCount": 0
  },
  "cleanup": {
    "result": "PASS",
    "receiptSha256": "0000000000000000000000000000000000000000000000000000000000000000"
  },
  "validUntilUtc": "2026-08-31T00:00:00Z",
  "ownerFunction": "ENDPOINT_COMPATIBILITY",
  "reviewerFunction": "INDEPENDENT_SECURITY_OR_ARCHITECTURE",
  "exceptions": []
}
```

A rerun MUST retain the first failure and link the later run. It cannot overwrite history. The evidence root is eligible for a manifest only when every primary invariant assertion is present, has the expected zero count, and cleanup passed.

## 5.6 Compatibility exception contract

An exception is not a support tuple. It is a separately authorized, exact, temporary deviation that narrows exposure while a customer or product issue is resolved.

```json
{
  "schemaVersion": "1.0.0",
  "exceptionId": "019d1234-5678-7abc-8def-0123456789ad",
  "sequence": 7,
  "realmAudience": "realm-opaque-fictional",
  "productReleaseId": "uam-endpoint-2026.08-r1",
  "baseTupleId": "win11-ent-25h2-x64-edge-stable-local-v1",
  "exactObservedInventoryDigest": "sha-256:0000000000000000000000000000000000000000000000000000000000000000",
  "exceptionClass": "TEMPORARY_THIRD_PARTY_EDR_POLICY_VARIANCE",
  "allowedCapabilities": ["health.inventory.v1"],
  "disabledCapabilities": ["g2.edge-direct-read.v1"],
  "notBeforeUtc": "2026-07-31T12:00:00Z",
  "notAfterUtc": "2026-08-07T12:00:00Z",
  "reasonCode": "EDR_VENDOR_CASE_OPEN",
  "caseReference": "opaque-case-token",
  "compensatingControls": ["COLLECTION_DISABLED", "DAILY_LOCAL_HEALTH_CHECK"],
  "nonWaivableInvariants": [
    "NO_FORBIDDEN_VALUE_ESCAPE",
    "NO_SOURCE_WRITE",
    "NO_CROSS_SESSION_OR_REALM_AUTHORITY",
    "NO_CURSOR_AHEAD",
    "NO_UNAUTHORIZED_RELEASE",
    "NO_SILENT_UNACKNOWLEDGED_DROP",
    "CLEANUP_COMPLETE"
  ],
  "ownerFunction": "COMPATIBILITY_RISK_AUTHORITY",
  "reviewerFunctions": ["SECURITY", "PRIVACY", "SUPPORT"],
  "signatureProfileId": "control-artifact-profile-provisional"
}
```

An exception MUST NOT:

- add a source, field, transform, destination, executable, path, rule, browser, package, or product not already representable by the release;
- bypass signature, realm, anti-rollback, package-integrity, privacy, source-write, cursor, release, or cleanup gates;
- authorize a broad antivirus/EDR exclusion;
- outlive the underlying product release, vendor servicing date, evidence, or certificate/key authority;
- be renewed automatically or by endpoint code;
- change `UNSUPPORTED` to `SUPPORTED` in customer-facing status.

## 5.7 Customer readiness questionnaire contract

The readiness questionnaire collects only categorical answers needed to select lab lanes and identify blockers. It SHOULD be generated from the active compatibility vocabulary. No answer grants support.

Minimum fields:

```text
Windows family, edition class, display version, build class, architecture
single-session versus multi-session host
console/RDP/RDS/AVD/Citrix class
profile provider class: local/roaming/FSLogix/Citrix/other
same-SID concurrent session requirement
Edge channel/update-management class
machine proxy/direct/PAC/TLS-interception/VPN classes
primary security product family and enforcement/audit class
Controlled Folder Access class
sleep/hibernate/Modern Standby and battery-device requirement
MSI deployment/rollback capability
ability to provide disposable/reverted test machines
ability to run synthetic localhost browser fixtures
availability of security/network/profile vendor coordinators
```

Forbidden questionnaire content includes user names, device names, IP addresses, proxy URLs, PAC contents, VPN names, raw GPO, EDR event logs, certificate details, browser history, profile paths, customer domains, credentials, or SSH material.

## 5.8 Error taxonomy

Errors are stable value-free codes with one retry class. They MUST NOT embed exception text or source values across trust boundaries.

| Family | Examples | Retry class | Default containment |
|---|---|---|---|
| Manifest | `COMPAT_MANIFEST_SIGNATURE_INVALID`, `..._ROLLBACK`, `..._EXPIRED`, `..._UNSUPPORTED_SCHEMA` | Never until new artifact | `SAFETY_HOLD` or disabled |
| Package | `COMPAT_PACKAGE_DIGEST_MISMATCH`, `..._ARCH_MISMATCH`, `..._UNEXPECTED_MODULE` | Never until reinstall/release | `SAFETY_HOLD` |
| Inventory | `COMPAT_INVENTORY_INCOMPLETE`, `..._AMBIGUOUS`, `..._UNRECOGNIZED_OS` | Bounded after state change | `UNKNOWN` |
| Browser | `COMPAT_BROWSER_VERSION_UNLISTED`, `..._SIGNATURE_INVALID`, `..._SOURCE_CAPABILITY_DRIFT` | After update/manifest | Source disabled |
| Session/profile | `COMPAT_SESSION_CLASS_UNLISTED`, `..._SAME_SID_CONCURRENT`, `..._PROFILE_PROVIDER_UNLISTED`, `..._PROFILE_ATTACH_UNSTABLE` | After lifecycle change | Acquisition disabled |
| Power | `COMPAT_POWER_TRANSITION_UNCLEAN`, `..._RESUME_REVALIDATION_FAILED` | After restart/new permit | Drain/disable capability |
| Network | `COMPAT_PROXY_PROFILE_UNLISTED`, `..._PAC_UNQUALIFIED`, `..._TLS_INTERCEPTION_UNQUALIFIED`, `..._VPN_TRANSITION` | Bounded network retry | No direct fallback |
| Security | `COMPAT_EDR_PROFILE_UNLISTED`, `..._QUARANTINE`, `..._EXCLUSION_DETECTED`, `..._CFA_BLOCK` | According to security owner | Disable/hold |
| Evidence | `COMPAT_EVIDENCE_MISSING`, `..._EXPIRED`, `..._ENVIRONMENT_MISMATCH`, `..._CLEANUP_FAILED` | New lane required | Not supported |
| Exception | `COMPAT_EXCEPTION_EXPIRED`, `..._BROADENS`, `..._INVARIANT_WAIVER` | Never until valid replacement | Reject artifact |

## 5.9 Realm isolation

Compatibility manifests may be product-global; tenant selections and exceptions are realm-bound. The Coordinator MUST cache realm policy/exception material under authenticated realm and installation keys. It MUST NOT accept realm in inventory or manifest payload as authority. Cache keys and local database keys begin with authenticated realm/installation where realm-scoped material is stored. A wrong-realm exception, same exception ID in another realm, or cross-realm cache substitution is a `SAFETY_HOLD` negative test.

---

# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility rules

## 6.1 Qualification lifecycle

```text
DISCOVERED
  -> INVENTORY_DEFINED
      -> TEST_ONLY
          -> EVIDENCE_PENDING
              -> QUALIFIED_TECHNICALLY
                  -> SUPPORT_DECISION_PENDING
                      -> SUPPORTED

Any state
  -> FAILED_GATE
  -> SAFETY_HOLD
  -> WITHDRAWN

SUPPORTED
  -> DEPRECATION_ANNOUNCED
      -> COLLECTION_DISABLED_AT_DEADLINE
          -> SUPPORT_ENDED

SUPPORTED or QUALIFIED_TECHNICALLY
  -> EVIDENCE_STALE/EXPIRED
      -> TEST_ONLY or UNSUPPORTED
```

Normative rules:

1. `DISCOVERED` means vendor or customer demand has identified a candidate; it grants no implementation or support claim.
2. `TEST_ONLY` authorizes only controlled synthetic lanes.
3. `QUALIFIED_TECHNICALLY` means all technical gates for the exact tuple passed; it does not decide customer coverage, licensing, support cost, deprecation, or production risk.
4. `SUPPORTED` requires a human product/support decision plus an active signed manifest.
5. any primary invariant failure enters `FAILED_GATE` or `SAFETY_HOLD`; a numeric performance waiver cannot compensate;
6. evidence expiry automatically removes authorization even if no new defect is known;
7. a newer OS/browser/security product is `UNKNOWN` until qualified, never inherited from a nearby tuple;
8. rollback is a higher-sequence manifest that points to prior approved semantics and exact packages. Sequence never decrements.

## 6.2 Endpoint compatibility evaluation state machine

```text
STARTING
  -> PACKAGE_SELF_CHECK
      -> PACKAGE_SAFETY_HOLD
      -> INVENTORY
          -> INVENTORY_UNKNOWN
          -> MANIFEST_VERIFY
              -> MANIFEST_DISABLED_OR_HOLD
              -> EXACT_TUPLE_MATCH
                  -> NO_MATCH / AMBIGUOUS -> DISABLED
                  -> EVIDENCE_AND_POLICY_CHECK
                      -> EXPIRED / PRIVACY_DISABLED / TENANT_DISABLED
                      -> RUNTIME_PRECONDITION_CHECK
                          -> TEMPORARILY_UNAVAILABLE
                          -> COLLECTION_CAPABLE

COLLECTION_CAPABLE
  -> environment, manifest, package, policy, browser, session, profile,
     network, security, power, or kill-switch change
  -> cancel outstanding intent/permit
  -> discard uncommitted page
  -> REEVALUATE
```

The evaluator MUST run at least at:

- Coordinator start and post-update start;
- manifest/policy/exception activation;
- User Host session creation and reconnect;
- browser executable/version/policy-root change detected by bounded means;
- profile attach/detach/provider state change;
- network/proxy/VPN class change relevant to transport;
- security-product/quarantine/exclusion/CFA state change exposed through approved interfaces;
- suspend, hibernate, resume, Modern Standby exit, clock-confidence change;
- before issuing every `RunIntent` and before accepting a page under Batch 02;
- before transport if network/security tuple changed after local commit.

It SHOULD debounce noisy notifications, but debounce cannot allow stale authorization. A coalesced reevaluation uses the latest facts and cancels earlier pending work.

## 6.3 Qualification evidence transaction boundary

Evidence publication is one logical transaction:

```text
raw restricted-lab artifacts complete
AND assertions evaluated by exact oracle
AND mandatory canary positive controls pass
AND sanitized report generated
AND cleanup/revert receipt passes
AND dependency/package/native inventory reconciles
AND independent reviewer signs/reviews the evidence index
-> publish immutable evidence root
```

No evidence root is published if cleanup is unknown. Raw lab artifacts may be deleted only after the sanitized evidence is approved and its assertions can be independently reproduced from declared T1 fixtures and commands. Deletion failure is itself retained as a failing sanitized assertion.

## 6.4 Manifest activation transaction boundary

Coordinator manifest activation MUST be crash-safe:

1. download/receive into an untrusted candidate slot without execution authority;
2. strict parse, canonical-content digest, signature/key-purpose/audience/product-release/expiry/anti-rollback validation;
3. validate every tuple and referenced package/evidence/enum locally;
4. compute complete candidate state without mutating active state;
5. in one local SQLite writer transaction, store candidate artifact, validation result, sequence, previous-active pointer, activation audit, and active pointer;
6. commit;
7. only then make the new evaluator state visible;
8. cancel work whose tuple or capability is no longer authorized;
9. preserve previous artifact for diagnostics/rollback according to retention, but never reactivate a lower sequence.

Crash before commit leaves the previous active state. Crash after commit and before reevaluation loads the committed active artifact on restart. A partial file, missing evidence reference, or stale sequence cannot become active.

## 6.5 Exception lifecycle

```text
REQUESTED
  -> SCOPE_VALIDATED
      -> REJECTED_BROADENING_OR_INVARIANT_WAIVER
      -> SECURITY/PRIVACY/SUPPORT_REVIEW
          -> APPROVED_PENDING_SIGNATURE
              -> ACTIVE_CONDITIONAL
                  -> RESOLVED_EARLY
                  -> EXPIRED
                  -> REVOKED/SAFETY_HOLD
```

Rules:

- request fields are categorical and sanitized;
- the exact inventory digest, product release, realm, tuple, capabilities, compensating controls, owner, case, and expiry are mandatory;
- an exception expiry is measured in an approved policy window, not “until fixed”;
- renewal is a new higher-sequence artifact with fresh evidence and review;
- the endpoint cannot request, approve, extend, or self-sign an exception;
- public/customer status remains `CONDITIONAL`, and reports distinguish it from `SUPPORTED`;
- expiry cancels new permits immediately; uncommitted results are discarded; committed minimized events remain governed by normal delivery semantics.

## 6.6 Browser servicing lifecycle

```text
VENDOR_RELEASE_DISCOVERED
  -> OFFLINE_METADATA_CAPTURED
  -> SENTINEL_TEST_ONLY
      -> FAILED -> BLOCK_VERSION/KILL_SWITCH
      -> PASSED_CORE
          -> FULL_REQUIRED_LANES
              -> QUALIFIED
                  -> CONSUMER MANIFEST PUBLISHED
                      -> CUSTOMER/BROWSER ROLLOUT
```

**RECOMMENDATION.** Browser rollout is consumer-first: the UAM release/evaluator and manifest support arrive before a producer/browser update is allowed into a supported ring. Because Edge Stable changes quickly, automatic discovery can open a qualification issue but cannot add a version to the manifest. Progressive vendor rollout does not imply UAM support.

For each Edge security/minor or major update used by a supported tuple:

- capture executable version, signature/publisher state, file digest, channel, updater policy class, source schema capability, and exact synthetic fixture result;
- rerun at least package/browser/source/privacy/resource/cleanup sentinel lanes;
- rerun full G2–G5 and release lanes when source schema, lock behavior, browser major, native runtime, OS servicing baseline, or prior incident risk changes;
- expire the previous browser evidence according to the human support window and vendor servicing state;
- issue a kill switch on any source write, raw escape, cross-profile/session/realm mix, cursor invariant, crash/corruption, or cleanup failure.

Chrome/Firefox versions are inventoried only to identify environmental change and future demand. Their update does not trigger Edge collection qualification unless it changes shared profile/security/runtime behavior.

## 6.7 OS servicing lifecycle

Every monthly Windows cumulative update and every feature/edition transition creates a new observed build/UBR. The default is `UNKNOWN` until the selected lane policy says the update can inherit evidence after a passing sentinel. Inheritance is allowed only when an ADR defines the exact equivalence rule and the sentinel proves no changed security, session, browser-source, power, network, durability, resource, release, or cleanup behavior.

At minimum:

| Change | Mandatory response |
|---|---|
| Monthly cumulative/security update on an active build line | L2 core sentinel; L4/L5/L6 subset when changed components or incident history require it. |
| Feature update or new build line, such as 24H2 → 25H2 or 25H2 → 26H1 | Full applicable qualification; no inheritance by version proximity. |
| Edition/SKU change | New tuple; verify service/task/session/policy/licensing and source behavior. |
| Server/LTSC/IoT line | Separate human scope and full lanes; vendor longevity alone is insufficient. |
| Preview/OOB update | Test-only sentinel; no support expansion without explicit evidence. |
| End of vendor servicing | Collection authorization ends no later than that date unless an approved baseline explicitly permits a separately serviced program; current default is no. |

## 6.8 Runtime and dependency lifecycle

- The supported .NET line is selected at release execution time. As of 31 July 2026, .NET 10 LTS patch 10.0.10 is current and support requires staying on current patches [W09].
- A self-contained UAM release freezes its runtime; every .NET servicing update creates a new product package and requires package, runtime, native module, G1, source, privacy, durability, resource, update/rollback, EDR, and cleanup sentinel evidence.
- Native SQLite, Windows interop generation, installer/custom-action tooling, browser automation, and every shipped native library have the same exact-version admission and expiry treatment.
- A vulnerable, unsupported, provenance-unmapped, or unexpected loaded native module invalidates the tuple immediately.
- Dependency replacement cannot silently alter the environment inventory or evaluator contract. Contract changes use consumer-first rollout and a manifest/evaluator compatibility matrix.

## 6.9 Power lifecycle

```text
ACTIVE_ELIGIBLE
  -> LOCK/DISCONNECT -> PAUSED
  -> SUSPEND_PENDING -> DRAINING
      -> SLEEP/S3/S0_LOW_POWER_IDLE/S4
          -> RESUME_DETECTED
              -> CLOCK/SESSION/PROFILE/POLICY/PACKAGE/NETWORK/SECURITY REVALIDATION
                  -> ACTIVE_ELIGIBLE
                  -> DISABLED/TEMPORARILY_UNAVAILABLE/SAFETY_HOLD
```

Before suspend/hibernate, UAM SHOULD stop issuing new work and cooperatively cancel bounded Task Hosts. It MUST NOT advance a cursor for a discarded page. On resume it MUST create fresh G1 IPC channels, treat prior permits/nonces as invalid, re-open source handles, re-check source generation, reload active policy/manifest, and re-evaluate clock confidence and network/security state. Hibernate restores memory; it is not equivalent to a clean service restart. Modern Standby is a separate physical-hardware lane because Windows may briefly activate software during low-power idle [W22–W24].

No support statement promises collection while asleep. A powered-off, asleep, disconnected, or profile-detached interval is an explicit coverage state, not evidence of no activity.

## 6.10 RDP/RDS/AVD/profile lifecycle

The User Host lifecycle follows the exact logon session, not account name or SID alone:

```text
SESSION_DISCOVERED -> TOKEN/LOGON_SID/LUID VERIFIED -> USER_HOST_READY
LOCK/DISCONNECT -> PAUSE
RECONNECT SAME LOGON -> REVERIFY + FRESH CHANNEL
LOGOFF -> CANCEL/KILL/CLEANUP -> EXIT
NEW LOGON SAME SID -> NEW USER HOST AND DISTINCT AUTHORITY
```

For shared or containerized profiles:

```text
PROFILE_PROVIDER_DETECTED
  -> ATTACHING/UNKNOWN -> NO SOURCE READ
  -> ATTACHED_STABLE + EXACT PROVIDER TUPLE
      -> SOURCE IDENTITY + ONE SOURCE LEASE
  -> DETACHING/FAILOVER/READ-ONLY/DISCONNECTED -> CANCEL/NO ADVANCE
```

FSLogix and Citrix configuration can permit concurrent sessions, read-only secondary access, differential disks, caching, failover, discarded changes, or write-back [W17–W21]. Therefore each exact provider version and access mode is a compatibility dimension. UAM never interprets acquisition session as visit-origin session. If a customer requires origin-session attribution, shared-profile support is technically unsuitable for this source and must remain unsupported.

## 6.11 Network lifecycle

```text
NETWORK_STATE_CHANGED
  -> classify approved machine-context route
      -> DIRECT_EXPLICIT
      -> STATIC_MACHINE_PROXY
      -> PAC/WPAD
      -> TLS_INTERCEPTION
      -> VPN_REQUIRED/OPTIONAL
      -> OFFLINE/UNKNOWN
  -> exact tuple evaluation
      -> transport eligible
      -> bounded defer; no direct bypass
```

The Coordinator owns upload and uses machine-context credentials/configuration only. It MUST NOT read a user's browser proxy state or borrow a user's token. A PAC/WPAD profile is conditional until its download, parser/runtime, proxy failover, authentication, timeout, privacy, and malicious-script cases pass. A static proxy failure cannot trigger unapproved direct egress. TLS validation is never disabled. Certificate/private-key/proxy credential values never enter health or evidence.

## 6.12 Security-product lifecycle

A security configuration tuple binds at least product family, sensor/platform/engine/content version classes where exposed, enforcement mode, policy family, CFA/ASR/network protection classes, quarantine/allow state, and the presence of UAM-specific exceptions. Product display name alone is insufficient.

```text
SECURITY_INVENTORY
  -> UNLISTED/UNKNOWN -> COLLECTION DISABLED
  -> QUALIFIED PROFILE
      -> executable/file/module reputation check
      -> install/start/source-read/IPC/network/upgrade/uninstall campaigns
      -> HEALTHY

Any quarantine, injected failure, exclusion variance, policy change, or sensor update
  -> cancel work -> re-evaluate -> hold/defer/test lane
```

The default UAM qualification target requires no UAM-specific antivirus/EDR exclusion. Defender documentation explicitly treats each exclusion as a protection gap and notes that process exclusions affect network protection and ASR inspection [W27]. A vendor recommendation for another product, including FSLogix exclusions, is not permission to exclude UAM.

## 6.13 Qualification cadence

The following cadence is a **RECOMMENDATION**, not an unapproved staffing or SLO commitment:

| Trigger/cadence | Lane set | Purpose |
|---|---|---|
| Every commit/PR | L0 static/package and L1 pure synthetic | Prevent architecture, contract, RID, privacy, and state-machine regressions. |
| Every release candidate | L2 exact core x64, L8 install/upgrade/rollback/uninstall; applicable L3–L7 | Release authorization for claimed tuples. |
| Every Windows cumulative/OOB update | L2 sentinel; risk-selected L4/L6 | Detect token/session/storage/network/security drift. |
| Every Edge update intended for supported rings | Browser/source/privacy/durability/resource/cleanup sentinel; full on major/risk change | Match accelerated browser cadence. |
| Every .NET/native SQLite/installer/native dependency patch | L0/L1 plus L2/L8 and applicable security lanes | Self-contained payload changed. |
| Nightly | Current support tuple core smoke with T1 fixtures | Early detection; not support proof alone. |
| Weekly | Preview/candidate OS/browser lane and stale-evidence scan | Advance warning and expiry management. |
| Monthly | Full active tuple replay from clean images | Refresh evidence and test clean reproducibility. |
| Quarterly or before support expansion | Physical power/ARM64 and enterprise EDR/proxy/VDI matrix | Claims not provable in ordinary VM. |
| After incident or waiver | All affected and adjacent lanes | Prove containment and prevent narrow patch-only closure. |

A human operations decision must fund and own this cadence. If it cannot be sustained, the supported matrix must shrink to what can be requalified safely.

## 6.14 Support expiry and deprecation

For each tuple, effective authorization ends at the earliest of:

```text
product release notAfter
manifest notAfter
required evidence validUntil
vendor OS servicing end
browser servicing eligibility end
.NET/native dependency support/advisory deadline
package-signing/revocation deadline
exception expiry
human-declared collection stop
emergency kill/revocation
```

A deprecation policy MUST distinguish:

- announcement date;
- last date new installations may enter the tuple;
- collection-disabled date;
- transport/support-only grace, if approved;
- support-end date;
- uninstall/data-drain/cleanup behavior;
- replacement tuple and migration evidence;
- long-offline endpoint behavior.

The conservative default is: no new collection after expiry; retain unacknowledged minimized data without silent deletion; continue only the minimum authenticated control/transport needed to obtain a valid narrowing/recovery artifact and deliver already-committed data if that behavior is separately authorized by the release policy. Exact offline grace is a human security/operations decision.

## 6.15 Feature flags and kill switches

Compatibility-related flags are release-owned finite booleans/enums, not a generic remote configuration language. They MAY:

- disable a package, build, browser version/channel, source capability, profile provider, network class, security profile, architecture, or test lane;
- force direct-read off and backup off independently only within accepted G2 rules;
- require a stronger health precondition;
- reduce page/resource limits;
- force diagnostic detail to a lower level;
- stop new collection permits globally or by exact tuple.

They MUST NOT add arbitrary executable paths, source paths, SQL, scripts, regexes, proxy destinations, trust roots, exclusions, collection fields, transforms, destinations, or unsupported platform matches. A kill switch activates at a higher revision and is evaluated before new work. Endpoint self-reenable is forbidden.

---

# 7. Security/privacy threat and failure register

The accountable functions below identify necessary responsibilities; they are not claims that the organization has assigned people. Every row requires a runbook before the affected tuple can be supported.

| ID | Trigger / threat / failure | Detection | Containment | Recovery | Cleanup | Accountable owner function | Required test | Residual risk |
|---|---|---|---|---|---|---|---|---|
| T14-01 | Manifest signature, key purpose, audience, product release, or canonical digest invalid | Strict verifier and independent vectors | Reject candidate; keep valid unexpired active narrowing only; security-significant failure enters `SAFETY_HOLD` | Publish higher-sequence authorized recovery artifact; rotate/revoke key as required | Delete untrusted candidate after evidence retention; preserve digest/result | Signing authority / Product security | Malformed signatures, key confusion, duplicate fields, wrong audience/release | Authorized signer can still make a mistaken policy; human separation remains necessary |
| T14-02 | Freeze, replay, downgrade, same-sequence different content | Sequence/content comparison and monotonic store constraint | Reject; stop if active chain integrity is uncertain | Higher-sequence manifest referencing approved semantics | Remove stale candidate; retain audit | Release security | Lower revision, repeated nonce/content, clock rollback, offline replay | Long-offline endpoints need bounded recovery policy |
| T14-03 | Manifest/evidence expires while endpoint is offline | Local monotonic/UTC confidence, artifact deadlines | Stop new permits at expiry; never extend locally | Obtain new valid artifact after connectivity/time recovery | No raw cleanup; retain minimal audit | Compatibility authority / Operations | Expiry before/during run, long offline, bad clock | Fail-closed can create coverage gaps and support load |
| T14-04 | Inventory spoof or untrusted payload claims a supported OS/session/realm | Inventory from kernel/OS/package handles; authenticated context; cross-checks | `UNKNOWN` or `SAFETY_HOLD`; no collection | Repair detector or protected installation | Remove tampered files/config under MSI manifest | Windows security / Endpoint runtime | API mocking, registry-only spoof, wrong realm/session payload | A privileged local adversary can influence the OS; UAM is not forensic proof |
| T14-05 | Unknown environment is accidentally mapped to nearest tuple | Exact-match evaluator; ambiguity count | Disabled; no first-match/fallback | Add a separately qualified tuple | None | Compatibility architecture | Property tests over generated tuples and unknown enums | Vocabulary omissions can still block legitimate devices |
| T14-06 | Cross-realm manifest/exception/cache substitution | Authenticated realm key and audience checks; negative cache tests | Reject and hold realm-scoped control path | Purge affected cache; publish correct higher revision | Delete wrong-realm cached artifact; preserve audit | Realm security | Same IDs/digests across fictional realms, replay between stores | Upstream registration compromise is outside this topic |
| T14-07 | Installer/package/file digest mismatch or unauthorized file replacement | MSI repair/self-check; signed file manifest; loaded-module inventory | Do not start collection-capable processes; hold package | Reinstall same authorized digest or promote a new qualified release | Manifest-bounded uninstall/repair; verify no residue | Release engineering / Endpoint security | Bit flip, side-load, path swap, signer mismatch, repair | EDR or admin tooling may change files after verification; recurring checks needed |
| T14-08 | x64/ARM64/x86 native asset mixed into wrong package | PE machine-type scanner, RID graph, runtime module architecture | Build/release fail; endpoint hold on unexpected module | Correct dependency selection and rebuild/requalify | Remove rejected artifacts/caches | Build/release | Every EXE/DLL/custom action/helper; mutation inserts wrong machine type | Drivers or opaque vendor modules may hide architecture-specific behavior |
| T14-09 | x64 process runs under ARM64 emulation and is treated as native support | Native machine/process architecture detection | Classify separate `EMULATED_X64_ON_ARM64`; unsupported by default | Ship/qualify native `win-arm64` or run full emulation lane by human decision | Remove wrong package on migration | ARM64 platform owner | Install/run both packages on physical ARM64; module inventory | Emulation behavior and performance can change with OS servicing |
| T14-10 | Browser update changes schema, locking, policy root, signature, or source behavior | Exact version/signature/source-capability sentinel | Block version/source capability; issue kill switch | New adapter/release/evidence and consumer-first manifest | Revert disposable profile/image; no user-profile broad cleanup | Browser compatibility | Exact signed browser fixture, G2–G5, update/rollback, canaries | Edge internal history remains unsupported public interface and can drift again |
| T14-11 | Browser progressive rollout creates mixed versions within a ring | Inventory distribution and manifest match counts | Only listed versions collect; unknown versions report disabled | Qualify/add exact version or pause browser rollout | None | Browser/platform operations | Mixed-version fleet simulation; restart/update mid-run | Delayed update state can reduce coverage |
| T14-12 | Profile path/provider changes between checks | Held handles, final-path/file identity, provider notifications | Cancel Task Host; no page commit or cursor advance | Re-discover after stable attach and exact tuple evaluation | Close handles; remove private scratch only | Profile compatibility / Windows security | Reparse/path swap, attach/detach/failover during every stage | Same-user races and eventual file-ID reuse cannot be eliminated fully |
| T14-13 | FSLogix/Citrix read-only secondary or discarded changes produce incomplete/ambiguous source | Provider mode inventory, synthetic visit oracle, lease state | Conditional/unsupported; one source lease; no origin-session claim | Reconfigure exact approved access mode or use a different source | Revert containers/differencing disks; verify detach | VDI/profile owner / Data correctness | Concurrent sessions, write-back, read-only, failover, reconnect, discard | Product internals and network storage failures remain complex |
| T14-14 | Same SID has concurrent logons with one physical profile | Logon SID/LUID/session plus source identity/lease | One acquisition lease; loser performs no read/advance; unsupported if origin attribution required | End concurrency or use approved distinct roots | Kill orphan hosts/jobs; release lease | Session runtime / Data owner | Console+RDP, RDP+RDP/RDS, reconnect/logoff races | Visit-origin session remains unprovable from shared browser database |
| T14-15 | User Host/Task Host crosses session or accepts wrong peer | G1 kernel process/session/token/release checks | Reject, terminate, rate-limit; global source stop on accepted message | Fix G1 and rerun all dependent lanes | Kill jobs/processes and remove pipe/task residue | Windows security | Cross-session/same-account hostile campaign | Local privileged adversary remains outside ordinary boundary |
| T14-16 | UAM writes or requests a write to browser source | OS write denial, SQLite read-only/effective controls, per-PID tracing, positive control | Immediate global source kill and incident | Correct adapter/package; full G2 and adjacent requalification | Revert disposable profile; prove no product residue | Native storage / Browser compatibility | Main/WAL/SHM write/create/rename/delete/checkpoint corpus | Security filter drivers can obscure intent; multiple independent controls required |
| T14-17 | Forbidden URL/path/profile/identity value escapes Task Host | Exact canaries across IPC/store/log/trace/metric/network/dump/support sinks | Stop source and transport for build/ring; quarantine artifacts | Locate/delete/contain under incident authority; fix and full G4 rerun | All-sink scan and deletion/revert receipt | Privacy / AppSec | Success/no-event/failure/crash/EDR capture variants | Pagefile, hypervisor, privileged EDR memory may be outside UAM control |
| T14-18 | Suspend/hibernate/Modern Standby preserves stale permit, pipe, handle, policy, or clock state | Power notifications, session/profile/package/manifest generation checks | Drain/cancel; invalidate permits/channels; no uncommitted advance | Fresh handshake, handles, source generation, policy/manifest and network/security evaluation | Kill orphan jobs; remove temp files; verify store | Runtime / Power compatibility | Transition at every G1–G5 boundary; repeated cycles | Firmware and physical-device behavior varies beyond VM |
| T14-19 | Modern Standby activity drains battery or unexpectedly runs collection | SleepStudy/ETW/power counters and Task Host/process state | Never schedule source acquisition in low-power phase; kill switch | Adjust lifecycle implementation; requalify physical model class | Restore power plan; remove test traces | Power/platform owner | Connected/disconnected standby, AC/battery, network transitions | OEM firmware/drivers and later updates may change results |
| T14-20 | Proxy failure silently falls back direct | Transport route instrumentation and firewall egress oracle | Block send; bounded defer; no alternate route unless explicitly authorized | Repair proxy/auth/network or publish exact dual-route policy after qualification | Remove temporary proxy/test certificates/rules | Network security / Transport | Static proxy unavailable, bad auth, failover list, DNS and firewall | Enterprise middleboxes may change behavior without notice |
| T14-21 | PAC/WPAD script is malicious, slow, unavailable, or chooses unqualified proxy | PAC/WPAD class, timeout/resource counters, route oracle | PAC tuple unsupported/conditional; stop transport; no script logging | Customer fixes PAC or UAM qualifies exact bounded implementation | Delete test PAC/cache; restore network config | Network security | Script loops/errors, multiple proxies, changing result, unavailable discovery | PAC logic is customer-controlled executable behavior; full assurance is difficult |
| T14-22 | TLS interception causes trust bypass or credential leakage | Normal TLS validation, chain/policy class, redacted failure code | Never disable validation; fail closed | Install approved enterprise trust through customer management and qualify exact class | Remove test root/private key and prove trust-store cleanup | PKI/network security | Trusted/untrusted intercept, hostname, expiry, revocation, client cert, proxy auth | Enterprise trust compromise remains a high-impact external dependency |
| T14-23 | VPN connects/disconnects mid-upload or changes DNS/proxy/routes | Network-change notifications, route/connection generation, receipt state | Abort/retry bounded batch; never interpret partial send as receipt | Reconnect under exact eligible profile; at-least-once retry | Close sockets; remove test VPN profile/rules | Network operations / Transport | Required/optional/split tunnel, transition before/during/after custody | VPN products and policy can vary by customer and update |
| T14-24 | EDR quarantines, blocks, injects into, delays, or kills UAM process | Security health, process exit, file integrity, ETW/vendor console sanitized evidence | Disable affected capability; do not weaken token/ACL or self-allow | Vendor/customer case; signed fix/allow decision; full exact profile rerun | Remove test allow/exclusion; reinstall; verify no quarantine residue | Endpoint security / EDR coordinator | Install/start/IPC/source read/upload/update/uninstall under enforcement | Closed-source product internals and cloud policy changes remain opaque |
| T14-25 | Broad UAM antivirus/EDR exclusion is added | Read approved exclusion inventory as categorical exact match; customer attestation | `SAFETY_HOLD` or explicit conditional health-only state; do not rely on exclusion | Remove exclusion; prove normal operation or narrow temporary customer-owned control | Verify exclusion removal and protection restoration | Security authority | Folder/process/wildcard/contextual exclusion mutations | UAM may not be able to observe every vendor-specific exclusion surface |
| T14-26 | Controlled Folder Access blocks legitimate UAM store/update operation | CFA audit/enforce event classification, expected file operation oracle | Stop affected write/update; preserve unacknowledged data; no broad allow | Correct product-owned path/installer or exact approved app allow; rerun | Remove temporary CFA rule and test data | Endpoint security / Release | Off/audit/enforce, update/rollback/uninstall, disk full | Reputation/cloud decisions can change independently |
| T14-27 | Resource overhead under EDR/VDI/power state breaches budget | CPU, working set, I/O, handles, wakeups, battery, logon delay, browser impact | Cancel/defer; source/build/ring kill according to approved hard limits | Tune bounded work or narrow matrix; requalify | Terminate jobs; remove traces/fixtures | SRE / Endpoint product | A/B paired runs and saturation/failure recovery | Exact budgets and estate distributions are human/measurement dependent |
| T14-28 | Security/product update occurs during UAM upgrade or rollback | File/process/version inventory and transactional installer evidence | Do not run mixed protected boundary; rollback/repair | Reapply same signed digest or new qualified release | Complete install-manifest cleanup and reboot/retest if required | Release engineering / Endpoint security | Power loss, EDR kill, browser/OS update, service restart during MSI | Windows Installer/customer tooling interactions can be environment-specific |
| T14-29 | Rollback binary cannot read newer local schema or reuses stale policy | Migration compatibility matrix and startup self-check | Safe-disabled; never destructive downgrade | Forward repair or explicitly supported reversible migration | Preserve data; remove abandoned binaries/files | Storage/release architecture | N/N-1 package and schema, interrupted migration, old manifest | Some migrations may be intentionally irreversible; rollback policy must be explicit |
| T14-30 | Uninstall or failed install leaves service/task/firewall/cert/file/process/data residue | Before/after manifest diff and process/job inventory | Tuple cannot qualify; cleanup incident | Product-manifest-scoped repair/uninstall; manual runbook only for owned artifacts | Signed deletion receipt; never broad-delete user profiles | Installer/release owner | Normal/failure/power-loss/EDR-blocked uninstall | Customer management systems may recreate settings after cleanup |
| T14-31 | Metrics/logs create high-cardinality or sensitive side channel | Schema lint, runtime series counter, canary scan | Drop/disable violating telemetry; local health only | Fix finite vocabulary; delete/contain affected telemetry under policy | Purge test telemetry and evidence of canary | Observability / Privacy | Generated dynamic values, exception messages, version labels, Unicode canaries | Aggregated rare classes can still reveal small populations; access policy needed |
| T14-32 | Crash dump/WER/EDR support bundle captures raw source memory | Dump policy inventory, canary in controlled crash, sink inspection | Disable automatic raw dumps for Task Host; source kill on escape | Use synthetic repro; vendor coordination; approved sanitized minidump profile only if proven | Delete test dump and verify remote/local locations | Incident response / Endpoint security / Privacy | Crash at every raw-data stage with WER/EDR enabled | Privileged security tooling may retain memory outside UAM authority |
| T14-33 | Exception silently broadens or becomes permanent | Strict scope comparison, expiry, human review, status separation | Reject; never map to `SUPPORTED` | New narrow time-bound artifact or remove unsupported demand | Delete expired local candidate; retain audit | Compatibility risk authority | Property/mutation tests for every authority-bearing field | Organizational pressure may lead to repeated renewals; governance is essential |
| T14-34 | Customer readiness questionnaire captures secrets or personal data | Closed categorical schema, client-side validation, canary/DLP checks | Reject upload; do not store raw attachment | Resubmit sanitized categorical answers | Delete rejected artifact and incident evidence | Support/privacy | Hostile free text, pasted GPO/PAC/log/history/credentials | Users may still place sensitive text in allowed descriptions; avoid free text |
| T14-35 | Lab image is contaminated, not reverted, or differs from declared tuple | Image digest/snapshot ID, clean baseline diff, package inventory | Mark run invalid; no evidence publication | Rebuild/revert and rerun | Destroy VM/test accounts/certs/rules/artifacts | Lab operations | Dirty snapshot, time travel, hidden agent/update, failed revert | Cloud/hypervisor layers can change outside guest evidence |
| T14-36 | Physical/enterprise claim is inferred from VM success | Evidence-lane type and claim-propagation rules | Prevent manifest publication for non-VM tuple | Obtain physical/customer-like lane or narrow claim | None | Architecture review | Negative test: attempt to publish ARM64/Modern Standby/EDR tuple from L2 evidence | Human reviewers may overread “green” VM results |
| T14-37 | Support operator bypasses fail-closed state using undocumented registry/file edit | Protected config ownership, integrity scan, audit, runbook review | Hold altered installation; no collection | Reinstall/repair authorized package and artifact; retrain/update runbook | Remove unauthorized changes, verify clean state | Support leadership / Security | Manual tamper, stale script, local admin “fix” | Local admins retain power; product status must show unsupported modification |
| T14-38 | Accessibility defect makes unsupported/expired state indistinguishable | Automated accessibility checks and manual assistive-technology review | Do not ship affected admin/support UI; CLI remains machine-readable | Fix labels/focus/contrast/announcements and retest | None | Portal/support UX owner | Keyboard, screen reader, zoom, color-only, copy JSON | Accessibility behavior varies by platform/AT version |
| T14-39 | Repeated environment changes cause reevaluation storm/DoS | Debounce counters, queue bounds, CPU/handle metrics | Coalesce latest state; pause collection; bounded backoff | Fix detector or vendor instability; restart safely | Drain queues/jobs; no checkpoint change | Runtime/SRE | Rapid network/power/session/security notifications | Coalescing can delay recovery; limits need measurement |
| T14-40 | Clock rollback/uncertainty keeps stale artifact valid or expires valid one | Trusted time/monotonic observations and discontinuity code | Stop authority-sensitive work when confidence insufficient | Restore time confidence; fetch new signed artifact; no local grace extension | None | Security/operations | Forward/backward jumps, hibernate, offline boot, timezone change | Secure time is an external dependency; availability trade-off is human-owned |
| T14-41 | Browser/OS/EDR release is withdrawn after qualification | Vendor advisory watcher plus support owner review | Emergency kill exact tuple/version | Update/downgrade using approved enterprise mechanism, then requalify | Remove withdrawn package/version where authorized | Compatibility incident owner | Simulated advisory and emergency manifest rollout | Advisory discovery latency remains operational risk |
| T14-42 | Compatibility state is interpreted as data quality or employee activity | Product wording, separate coverage/health model, governance tests | Suppress misleading aggregate; incident correction | Correct UI/report and educate consumers | Remove/repair derived report where governed | Product/data governance | Missing/unsupported/deferred state reporting and accessibility review | Downstream consumers can misuse telemetry despite warnings |

## 7.1 Incident severity and mandatory stop classes

The following are primary stop classes and cannot be overridden by a compatibility exception:

```text
forbidden source value or reversible derivative outside Task Host
source write or write intent defect against browser source
cross-session, cross-profile, or cross-realm authority acceptance
cursor ahead of durable effect/no-event fact
retry creating more than one final business effect
receipt outside declared durable custody boundary
unauthorized, stale, incomplete, frozen, or downgraded release/control artifact execution
silent loss of unacknowledged minimized data
unbounded hostile resource effect
cleanup residue that can execute, retain authority, or expose forbidden data
```

Any occurrence stops the affected capability and all dependent qualification. The incident review identifies adjacent tuples and versions; a local patch does not restore support until the affected and adjacent lanes pass.

## 7.2 Minimum runbook content

Each threat row's runbook MUST identify:

1. stable trigger and severity;
2. who may issue a kill switch or recovery artifact;
3. exact scope: global, release, package, tuple, browser, source, realm, security profile, or lane;
4. immediate containment and whether transport of already-committed minimized data remains allowed;
5. evidence preservation that excludes raw activity and secrets;
6. customer/support message that distinguishes coverage from activity;
7. rollback/repair/reinstall/provider/customer action;
8. cleanup/deletion limits and proof;
9. re-enable prerequisites and lanes to rerun;
10. expiry and follow-up owner.

---

# 8. Detailed test matrix and smallest falsifying prototypes

## 8.1 Test-lane architecture

**RECOMMENDATION.** A lane proves only the claims explicitly assigned to it. Evidence does not propagate upward from a cheaper lane to a different failure domain.

| Lane | Environment | Claims it may prove | Claims it cannot prove | Promotion use |
|---|---|---|---|---|
| `L0-STATIC-PACKAGE` | Sealed build/CI, no Windows execution needed except PE tooling | project/API boundaries, closed contracts, RID/file/PE architecture, dependency locks, SBOM/provenance, manifest evaluator, metric-cardinality lint, forbidden field/secret scans | Windows service/token/session, browser source, EDR, proxy, power, installer runtime, cleanup | Mandatory for every commit and package |
| `L1-PURE-SYNTHETIC` | Cross-platform or Windows test process with T1 fixtures | deterministic compatibility matching, state machines, expiry, exception monotonicity, schema/parser, failure taxonomy, browser schema fixtures, model checking, kill-switch behavior | kernel identity, real browser/SQLite locks, MSI, EDR, physical power, VDI | Mandatory for every commit/release |
| `L2-CORE-X64-VM` | Disposable/reverted x64 Windows client VM | exact x64 package install, G1 session/IPC, console/single RDP, local profile, synthetic Edge, G2–G5, machine proxy, Defender software states, OS/browser update, resources within VM, rollback/uninstall/cleanup | Modern Standby/battery, ARM64, physical firmware, enterprise TLS/PAC/VPN/EDR, real RDS/AVD/Citrix/FSLogix storage | First-slice technical gate |
| `L3-MULTISESSION-VDI-VM` | Purpose-built RDS/AVD/Citrix/FSLogix lab with multiple synthetic accounts/sessions | exact broker/session/profile-provider/access-mode/lease/source identity/reconnect/failover behavior | physical power, unrepresented customer storage/network/security policies | Required for each remote/multi-session/profile tuple |
| `L4-PHYSICAL-X64-POWER` | Representative physical x64 desktop/laptop classes | S3/S4/Fast Startup/Modern Standby, battery/AC wake behavior, device/firmware, real power/resource impact, sleep cleanup | ARM64, other OEM/firmware classes, enterprise EDR/network | Required for claimed physical power classes |
| `L5-PHYSICAL-ARM64` | Representative physical Windows on Arm64 devices | native win-arm64 install/runtime/interop/SQLite/browser/EDR/power, optional separate x64-emulation negative lane | all Arm64 models/firmware, AVD Arm64 where vendor excludes it | Required before native or emulated ARM64 support |
| `L6-ENTERPRISE-NETWORK-SECURITY` | Controlled customer-like lab with named proxy/PAC/TLS/VPN and Defender/third-party EDR profiles | exact product/configuration-family install/start/source/network/update/cleanup and credential/trust behavior | other vendors/policies/cloud back ends; broad customer claim | Required for each EDR/network tuple |
| `L7-SERVICING-SENTINEL` | Current support images plus OS/browser/.NET/native preview/new releases | early drift, schema/locking/parser/package/signature and update warnings | support by itself; full customer/physical/enterprise assurance | Opens/block qualification work; never auto-adds tuple |
| `L8-RELEASE-LIFECYCLE-SOAK` | Clean and upgrade paths on every claimed lane class | same-digest promotion, MSI repair/upgrade/rollback/uninstall, long-running state transitions, repeated restarts, disk/backpressure integration as applicable, cleanup | untested platform class | Mandatory before release promotion |

### 8.1.1 Evidence claim propagation

- `L0`/`L1` success is prerequisite evidence, never a substitute for Windows runtime evidence.
- `L2` success may support only the exact x64 VM software tuple. It cannot label Modern Standby, physical ARM64, FSLogix/Citrix, third-party EDR, or enterprise proxy/TLS/VPN supported.
- `L3` results are provider/version/configuration specific. “FSLogix passed” is invalid without access mode, storage, concurrent-session, provider version, OS, browser, package, and security tuple.
- `L4` and `L5` results are hardware-class evidence. The manifest must list the hardware/power capability class or state that support is limited to software transitions proved on the tested representatives.
- `L6` results are security/network configuration-family evidence, not product-name equivalence.
- `L7` may revoke or block, but passing a sentinel cannot create support without the normal review.
- `L8` binds the package and upgrade path; a clean-install-only pass cannot authorize upgrade or rollback.

## 8.2 Representative matrix

The matrix below is the smallest useful research/qualification plan. Rows marked `HUMAN DECISION` are not support commitments.

| Matrix ID | OS/SKU | Arch | Browser | Session | Profile | Power | Network | Security | Lane/status target |
|---|---|---|---|---|---|---|---|---|---|
| M14-01 | Windows 11 Enterprise 25H2 exact current qualified build | x64 native | Edge Stable exact | console single | local | VM S3/S4 simulation where available | direct explicit | Defender primary, no UAM exclusion | L2; first candidate |
| M14-02 | Windows 11 Enterprise 24H2 exact current qualified build | x64 native | Edge Stable exact | console single | local | VM | static machine proxy | Defender + CFA off/audit/enforce | L2; first candidate alternative |
| M14-03 | Windows 11 Education 24H2/25H2 exact builds | x64 native | Edge Extended Stable exact | one RDP, non-concurrent | local | VM | direct/static proxy | Defender | L2; only after edition equivalence evidence |
| M14-04 | Windows 11 Enterprise 25H2 | x64 native | Edge update N→N+1 | console/RDP transitions | local | VM | direct | Defender | L7+L2 browser servicing |
| M14-05 | Windows 11 Enterprise 25H2 | x64 native | Edge Stable | console+RDP same SID concurrent | same local profile | VM | direct | Defender | L2/L3 negative; expected unsupported unless one-lease semantics pass and no origin claim |
| M14-06 | Windows 11 Enterprise multi-session 25H2 on AVD | x64 | Edge Stable | AVD multi-session | FSLogix exact mode | VM | AVD network | Defender/EDR exact | L3+L6; conditional/test-only pending human demand |
| M14-07 | Windows Server 2025 RDS | x64 | Edge Stable | RDS multi-session/RemoteApp variants | local/FSLogix exact | VM | enterprise proxy | Defender/EDR exact | L3+L6; test-only |
| M14-08 | Windows Server 2022 RDS | x64 | Edge Stable | RDS multi-session | FSLogix exact | VM | enterprise | exact security | L3+L6; test-only; servicing/support cost review |
| M14-09 | Windows 11 Enterprise 25H2 | x64 | Edge Stable | Citrix published desktop/application variants | Citrix Profile Management 2603 exact modes | VM | enterprise | exact security | L3+L6; test-only |
| M14-10 | Windows 11 Enterprise 24H2/25H2 laptop | x64 | Edge Stable | console | local | S3/S4/Fast Startup | direct/proxy | Defender | L4; physical claim |
| M14-11 | Windows 11 24H2/25H2 Modern Standby laptop | x64 | Edge Stable | console | local | S0 low-power idle AC/battery | Wi-Fi/VPN transitions | Defender | L4; physical test-only until pass |
| M14-12 | Windows 11 supported Arm64 build/device class | Arm64 native | Edge Arm64 Stable | console | local | physical S0/S4 | direct/proxy | Defender Arm64 | L5; unsupported until full pass |
| M14-13 | Same physical Arm64 device | x64 emulated package | Edge native Arm64 | console | local | physical | direct | Defender | L5 negative; do not infer native support |
| M14-14 | Windows 11 Enterprise exact supported build | x64 | Edge Stable | console | local | VM | PAC/WPAD, static failover, TLS interception | Defender | L6; conditional/test-only |
| M14-15 | Same core tuple | x64 | Edge Stable | console | local | VM | required/split-tunnel VPN changes | named security profile | L6; conditional/test-only |
| M14-16 | Same core tuple | x64 | Edge Stable | console | local | VM | direct/proxy | each named third-party EDR product/configuration family | L6; one tuple per exact family |
| M14-17 | Windows 11 Enterprise LTSC 2024 | x64 | Edge exact | console | local | physical/VM as applicable | exact | Defender | Separate human scope; test-only; LTSC longevity is not proof |
| M14-18 | Windows 11 26H1 hardware line | native device architecture | Edge exact | console | local | physical | exact | Defender | New full lane; unsupported until qualified |
| M14-19 | Windows 11 Home/Pro | x64 | Edge exact | console | local | VM/physical | consumer/machine proxy variants | Defender | HUMAN DECISION; default unsupported due management/support boundary |
| M14-20 | Chrome Stable 151 / Firefox 153 or ESR 140.13 present | x64 | not a collection source | any | any | any | any | any | Inventory/detection only; no source support |

## 8.3 Browser schema fixtures and servicing corpus

The browser compatibility corpus MUST include:

1. deterministic handcrafted Edge `History` SQLite fixtures for every admitted schema/page-size/journal state;
2. exact Edge-generated synthetic profiles for each qualified build, created from localhost/reserved-domain visits only;
3. empty, minimal, busy, WAL-active, high-row-count, corrupted, incompatible-future, extra-column, missing-column, wrong-type, trigger/view/virtual-table, page-size, and replacement fixtures;
4. native IDs with equal timestamps, late synchronized older time, gaps, deletion, sequence above maximum, and restore/regression;
5. browser update and downgrade fixtures where enterprise mechanisms permit them;
6. profile provider attach/detach/copy/cache/failover/differencing states for L3;
7. exact expected source generation, page, minimized event/no-event, cursor, and cleanup ledger from the independent oracle;
8. exact canaries in URL components, profile labels/paths, file identities, exception text, proxy/security fields, logs, traces, dumps, and support artifacts;
9. signed browser executable/version/source-capability inventory and fixture-root digest.

A fixture proves only the source shape encoded. Exact signed browser runtime behavior remains necessary.

## 8.4 Smallest falsifying prototypes

Durations below are **ESTIMATE** planning values for one automated run after infrastructure exists. They are not staffing commitments or SLOs and must be replaced by observed distributions.

### P14-01 — manifest/evaluator monotonicity and fail-closed matching

| Field | Definition |
|---|---|
| Claim | Only one exact, unexpired, authorized tuple can enable a capability; unknown, ambiguous, stale, downgraded, or broadened artifacts disable it. |
| Setup | L1 pure model; generated finite vocabularies for OS, architecture, browser, session, profile, power, network, security, package, evidence, realm, clock, and policy. |
| Instrumentation | Reference evaluator independent of production evaluator; property generator; mutation suite; allocation/time counters; canonical/signature test vectors. |
| Steps | Generate valid manifest/inventory pairs; mutate every authority-bearing field; create overlap/ambiguous tuples; replay lower/same revision; expire each deadline; cross realms; apply tenant narrowing/exception. |
| Pass | Exact state/reason equivalence with reference; zero broadening; zero unknown-to-supported mappings; lower/same-different revision rejected; bounded resources; mandatory mutations detected. |
| Fail/stop | One counterexample enables a capability without complete exact authority or permits exception to waive an invariant. |
| Evidence | Seeds/minimal counterexamples, vector root, implementation/reference results, mutation ledger, resource report. |
| Estimated duration | 5–20 minutes per CI shard; exact generated case count chosen by detection evidence. |
| Cleanup | Delete ephemeral cases; retain minimal fictional counterexamples and digests. |

### P14-02 — package and native-architecture closure

| Field | Definition |
|---|---|
| Claim | `win-x64` and `win-arm64` packages contain only declared architecture/native assets and load no undeclared module. |
| Setup | L0 packages; deliberate x86/x64/ARM64 fixture binaries; exact file manifest and dependency lock. |
| Instrumentation | PE/COFF scanner, Authenticode verifier, SBOM/file/lock reconciliation, runtime loaded-module inventory in L2/L5. |
| Steps | Scan every executable/library/custom action; mutate package with wrong architecture and unsigned/extra file; install; start all processes; compare loaded modules. |
| Pass | Correct machine types and signatures; every shipped/loaded byte maps to manifest; all mutations fail before collection. |
| Fail/stop | Wrong/mixed architecture, unexpected module, unmapped binary, or emulation silently accepted. |
| Evidence | Per-file machine type/digest/signature, file/SBOM/lock reconciliation, loaded module list by digest. |
| Estimated duration | 2–10 minutes static; 20–40 minutes per runtime architecture. |
| Cleanup | Destroy mutated packages; uninstall/revert runtime machines; verify file/service/task residue zero. |

### P14-03 — first x64 core tuple

| Field | Definition |
|---|---|
| Claim | Exact Windows 11 Enterprise/Education x64 + Edge + local-profile tuple passes G1–G5, release, resource, and cleanup gates with no UAM-specific security exclusion. |
| Setup | Fresh L2 VM, exact declared OS build/UBR, exact Edge build, native self-contained package, synthetic account/profile, localhost fixture server, Defender profile, no real activity. |
| Instrumentation | Token/session/pipe ACL verifier; ProcMon/ETW or equivalent per-process file oracle; SQLite failpoints; IPC/network captures; canary scanner; CPU/memory/I/O/handle counters; install manifest diff. |
| Steps | Install; inventory/evaluate; console logon; run hostile G1; create synthetic visits; direct/backup/defer G2; G3 cursor/replacement; G4 all-sink; G5 crashes; network upload; restart; repair; upgrade/rollback; uninstall. |
| Pass | All predecessor primary invariant counts zero; exact controlled effects; bounded approved resources; no browser corruption/crash; same digest/tuple; complete cleanup. |
| Fail/stop | Any primary invariant, source impact, stale tuple, raw escape, unsupported state recorded as success, or residue. |
| Evidence | Complete L2 envelope, sanitized traces/counts, exact inventory/package/browser/native identities, cleanup receipt. |
| Estimated duration | 2–6 hours automated per exact tuple, excluding image creation and review. |
| Cleanup | Uninstall and before/after diff, then destroy/revert VM and delete restricted raw traces. |

### P14-04 — console/RDP/same-SID authority and one-source lease

| Field | Definition |
|---|---|
| Claim | Each logon session has a distinct User Host authority; same-SID concurrent access never produces cross-session IPC, duplicate source readers, or visit-origin claims. |
| Setup | L2/L3 VM with synthetic account(s), console and at least two RDP/RDS sessions, shared and distinct fictional Edge roots. |
| Instrumentation | Logon SID/LUID/session/process tuple trace; source identity/lease ledger; Task Host count; page/cursor oracle; hostile pipe client. |
| Steps | Connect/disconnect/reconnect/lock/unlock/fast-switch/logoff in all orders; same SID new logon; shared source and session-variable distinct roots; crash lease owner; service restart. |
| Pass | Exact session peer validation; one active acquisition per physical source; loser performs no read/advance; distinct roots remain distinct; no origin-session field; cleanup complete. |
| Fail/stop | One cross-session accepted message, two source readers, duplicate effect, stale channel reuse, or origin attribution. |
| Evidence | Sanitized state-transition and lease ledger, attempt counts, process/job cleanup. |
| Estimated duration | 1–3 hours per session technology/configuration. |
| Cleanup | Log off all synthetic sessions; kill jobs; release leases; remove profiles/accounts via lab manifest; revert. |

### P14-05 — browser servicing and schema drift

| Field | Definition |
|---|---|
| Claim | An exact new Edge build remains disabled until sentinel/full evidence passes, and schema/locking drift cannot emit or advance silently. |
| Setup | L7/L2 images with previous qualified build, candidate update, incompatible future-shaped fixture, synthetic profile and update policy. |
| Instrumentation | Browser signature/version/hash, source capability detector, fixed query plan, write trace, browser health, page/effect oracle. |
| Steps | Run baseline; update while stopped and during UAM lifecycle; restart; run direct/backup/cursor/privacy; inject missing/changed schema and lock outcomes; attempt stale manifest. |
| Pass | Candidate initially `UNKNOWN`; stale manifest cannot collect; passing evidence can be published explicitly; incompatible shape disabled with no effect/advance; previous committed state preserved. |
| Fail/stop | Version proximity authorizes, guessed schema emits, update creates source write/corruption, or old tuple remains active incorrectly. |
| Evidence | Before/after inventory, source capability diff, exact effects/checkpoints, browser health, manifest transition. |
| Estimated duration | 45–120 minutes sentinel; 2–6 hours full qualification. |
| Cleanup | Revert browser/profile/image; delete test updater state and traces. |

### P14-06 — physical x64 sleep, hibernate, Fast Startup, and Modern Standby

| Field | Definition |
|---|---|
| Claim | Power transitions pause work, preserve durability invariants, invalidate stale authority, resume safely, and remain within approved physical power/resource limits. |
| Setup | L4 representative x64 desktop/laptop classes; AC/battery; S3 or Modern Standby capability; S4/Fast Startup; synthetic source. |
| Instrumentation | `powercfg /a`, SleepStudy where applicable, ETW/power transition trace, process/job/handle/store snapshots, battery/energy counters, canaries. |
| Steps | Transition before/after every G1–G5 boundary; repeated lock/sleep/resume; hibernate with outstanding intent/page; network/profile/security changes during sleep; power loss where lab-safe. |
| Pass | No work authorized in disallowed low-power state; pre-commit state unchanged; post-commit retry stable; fresh IPC/permit/handles on resume; zero orphan/raw residue; human-approved energy limits pass. |
| Fail/stop | Stale permit/channel/handle, cursor/effect error, unintended collection during standby, material unexplained drain, or cleanup residue. |
| Evidence | Power-capability class, transition ledger, SleepStudy/energy summary, store truth, cleanup receipt. |
| Estimated duration | 4–12 hours per hardware/power class including repeated cycles; longer soak is separate. |
| Cleanup | Restore power plans/network/security settings; remove traces/fixtures; uninstall/reimage as required. |

### P14-07 — native ARM64 and x64-emulation separation

| Field | Definition |
|---|---|
| Claim | A native `win-arm64` release passes independently; x64 emulation never satisfies native support and cannot load mixed undeclared assets. |
| Setup | L5 physical supported Arm64 devices, native Edge, native Defender, exact win-arm64 package; separate x64 package negative run. |
| Instrumentation | Native machine/process/module architecture, token/interop/SQLite/browser/source tests, EDR/power/resource/installer traces. |
| Steps | Static scan; install native; run all applicable L2/L4 gates; update/rollback/uninstall; then try x64 package under emulation and verify classification. |
| Pass | Native processes/modules only; all gates pass for native tuple; emulated run is separate `TEST_ONLY/UNSUPPORTED` and cannot match native tuple. |
| Fail/stop | Missing native dependency, emulation hidden, interop/token/source difference, EDR block, resource failure, or residue. |
| Evidence | Hardware/OS capability class, package/module architecture, full gate envelope. |
| Estimated duration | 1–3 days per representative device class for full qualification and soak. |
| Cleanup | Uninstall both package variants; verify architecture-specific MSI/product/file residue; reimage. |

### P14-08 — proxy, PAC, TLS interception, and VPN route control

| Field | Definition |
|---|---|
| Claim | Coordinator uses only authorized machine-context routes, never direct-falls back, never leaks credentials/configuration, and preserves at-least-once custody semantics across route changes. |
| Setup | L6 controlled proxy/PAC/TLS/VPN lab, synthetic ingestion endpoint, test PKI, no customer addresses or credentials in evidence. |
| Instrumentation | Firewall/route oracle, proxy logs sanitized to counts, TLS verifier, socket/receipt state, batch IDs, credential/canary scanner. |
| Steps | Direct/static proxy; bad/unavailable proxy; multiple proxy failover; PAC success/error/timeout/change; trusted/untrusted TLS intercept; VPN connect/disconnect/split tunnel before/during upload; offline. |
| Pass | Only authorized route used; no direct bypass; TLS never disabled; no secret/config leak; no false receipt; retry yields one final effect; bounded time/resources. |
| Fail/stop | Unauthorized egress, trust bypass, credential in logs, PAC unbounded execution, premature custody, duplicate effect. |
| Evidence | Route decision counts, TLS/receipt outcomes, exact network-profile class, sanitized packet/endpoint evidence, cleanup receipt. |
| Estimated duration | 2–8 hours per network profile; PAC/vendor complexity may require longer. |
| Cleanup | Remove test root/private key, proxy/VPN/PAC/firewall settings and credentials; verify trust/network baseline. |

### P14-09 — Defender and third-party EDR without broad exclusions

| Field | Definition |
|---|---|
| Claim | Exact security profile allows signed UAM install, runtime, browser read, IPC, upload, update/rollback, and uninstall within resource limits without a broad UAM-specific exclusion. |
| Setup | L6 exact OS/package/security product and policy family; enforcement and audit variants; synthetic fixtures; vendor/customer coordinator. |
| Instrumentation | File/process integrity, security event categories, process exit/latency/resources, network route, exclusion inventory class, canary/dump sinks. |
| Steps | Install/start; hostile IPC; direct/backup reads; upload; crash; update; rollback; uninstall; signature/reputation change; quarantine simulation; CFA/ASR/network controls; sensor/content update. |
| Pass | All functions work or fail closed with finite codes; primary invariants zero; no broad exclusion; bounded approved overhead; cleanup restores protection/config. |
| Fail/stop | Exclusion required, raw dump/escape, quarantine leaves partial privileged boundary, source write, network bypass, unbounded impact, residue. |
| Evidence | Exact product/configuration-family inventory, sanitized event/result counts, resource A/B, exclusions class, cleanup. |
| Estimated duration | 1–3 days per product/configuration family plus vendor review. |
| Cleanup | Remove temporary vendor policies/allow entries/test submissions; uninstall/reimage; verify exclusions/protection restored. |

### P14-10 — FSLogix/Citrix profile-container concurrency and failover

| Field | Definition |
|---|---|
| Claim | Exact profile-provider mode preserves source identity, one-source lease, complete synthetic observation under declared limits, no cross-session/realm mix, and safe detach/failover cleanup. |
| Setup | L3 exact FSLogix or Citrix version/configuration, synthetic users, file storage, read/write and read-only modes, failover/cache/differencing controls. |
| Instrumentation | Provider attach/access-mode state, VHD/container identity, source/lease/generation ledger, network/storage faults, page/effect oracle, file/handle cleanup. |
| Steps | Single session; concurrent same SID; read-only secondary; write-back on/off; disconnect/reconnect; storage interruption; in-session failover; container replacement/restore; provider update. |
| Pass | Exact declared mode only; one active acquisition; no discarded visit counted as authoritative outside source truth; safe defer on instability; no origin-session claim; zero duplicate/mix/write/residue. |
| Fail/stop | Provider unknown treated supported, two readers, wrong lineage, partial/discarded state silently accepted, cross-session/realm effect, orphan mount/handle. |
| Evidence | Exact provider/version/mode/storage class, transition/effect ledger, sanitized fault results, cleanup/detach receipt. |
| Estimated duration | 1–3 days per provider/mode, excluding infrastructure setup. |
| Cleanup | Log off sessions; detach/remove fictional containers/differencing disks; remove synthetic identities/shares; revert hosts. |

### P14-11 — MSI upgrade, rollback, repair, uninstall, and power-loss cleanup

| Field | Definition |
|---|---|
| Claim | Enterprise deployment preserves the privileged boundary, promotes the same digest, supports only declared schema/package rollback, and leaves no executable/authority residue. |
| Setup | L8 clean N-1/N packages, declared local store schemas, signed test certificates, management deployment simulator, EDR/power interruption hooks. |
| Instrumentation | MSI logs restricted/sanitized, file/service/task/ACL/firewall/certificate/store/process diff, package/file digests, startup/evaluator health, canary scan. |
| Steps | Clean install; repair; upgrade N-1→N; service/browser/session active; failure at each installer phase; reboot/power interruption; supported rollback; unsupported rollback; uninstall with backlog/store. |
| Pass | No mixed unauthorized boundary; exact same digest promoted; startup safe-disabled on incompatible schema; acknowledged/unacknowledged data behavior follows accepted contracts; full manifest-scoped cleanup. |
| Fail/stop | Stale/partial binary executes, destructive rollback, data silently dropped, privilege/ACL widened, certificate/rule/task/file/process residue. |
| Evidence | Phase/failpoint matrix, before/after manifests, store truth, package/signature identities, cleanup receipt. |
| Estimated duration | 4–12 hours automated per upgrade pair/environment. |
| Cleanup | Product-manifest uninstall, certificate/private-key/rule/task/service removal, store handling per T1 manifest, machine revert. |

### P14-12 — expiry, deprecation, exception, kill switch, and recovery

| Field | Definition |
|---|---|
| Claim | Time and control-state transitions stop only the affected capabilities, never broaden, preserve committed data, and require higher-revision authorized recovery. |
| Setup | L1 plus L2 runtime with controllable clock-confidence abstraction, manifests/evidence/exceptions at boundary times, offline periods, outstanding intents/pages/batches. |
| Instrumentation | Evaluator state trace, local SQLite control/audit rows, process/permit/page/batch state, network custody oracle. |
| Steps | Expire manifest/evidence/vendor/release/exception independently; announce deprecation and pass deadlines; activate global/tuple/browser/source kill; clock jump; offline; recover with higher revision; attempt lower/self-reenable. |
| Pass | No new permits after stop; uncommitted page discarded/no advance; committed minimized data preserved/delivered only as authorized; status exact; lower/self-reenable rejected; audit durable. |
| Fail/stop | Grace silently invented, exception becomes supported/permanent, committed data deleted, stale work commits, lower revision activates, wrong realm recovers. |
| Evidence | Complete transition ledger and store/network truth; exact artifact digests/sequences; cleanup. |
| Estimated duration | 30–120 minutes automated plus long-offline accelerated model; real offline soak separate. |
| Cleanup | Remove test artifacts/caches; restore clock/network safely; revert machine. |

## 8.5 Failure-injection and cleanup matrix

Every claimed tuple MUST run applicable failures at all meaningful boundaries, not only the happy path.

| Failure point | Expected invariant | Required cleanup evidence |
|---|---|---|
| Before MSI writes, after files, after service/task, before commit, during rollback | No partial unauthorized executable boundary | File/service/task/ACL/firewall/cert/store diff; installer transaction result |
| Coordinator start/self-check/manifest load | No collection before package/control validity | No User Host/Task Host; stable health code; no residue |
| User Host launch/handshake/dedicated pipe | No cross-session authority; bounded hostile effect | Process/job/pipe/handle count returns to baseline |
| Before/after Task Host restriction/job binding/permit | No source access before all controls | No source handle/file/network/child; process gone |
| Before/during/after direct source snapshot | Zero source write; failed page no advance | Source metadata/trace/browser health; handles closed |
| Every Online Backup step, completion, finish, destination query | Incomplete backup never accepted | Memory destination destroyed; source closed; no temp file |
| Every URL parse/match/minimize/serialize point | Forbidden values never escape | All-sink canary report; Task Host exited |
| Before/after each local effect/no-event/witness/checkpoint/commit/ACK write | Cursor never ahead; one effect | SQLite truth/WAL recovery; stable retry result |
| Before/during upload compression/TLS/send/server custody/receipt persistence | No false receipt; at least-once one effect | Socket closed, batch state exact, no temp plaintext/residue |
| Browser update/source replacement while page runs | Old capability cannot commit under changed source | Old handles closed; page discarded; source generation evidence |
| Lock/disconnect/reconnect/logoff/service restart | Stale channel/permit cannot survive | Processes/jobs/pipes/leases removed; fresh handshake |
| Sleep/hibernate/Modern Standby transition | No stale authorization or cursor change | Power/process/store state and fresh-resume evidence |
| Proxy/VPN/TLS/EDR policy transition | No direct bypass or security weakening | Route/trust/exclusion/protection state restored |
| Profile attach/detach/failover/container replacement | No mixed lineage or duplicate reader | Handles/mounts/leases removed; container state restored |
| Disk full/store corruption/backpressure | No silent unacknowledged loss | Store copied only as T1 evidence; repaired/reverted; backlog state exact |
| Kill switch/expiry during every stage | No new work; stale uncommitted work discarded | Process/page/permit state empty; committed data intact |
| Uninstall after every prior failure | No executable/security/profile/network residue | Signed cleanup receipt with zero unexpected differences |

## 8.6 Pass/fail aggregation

A compatibility tuple can reach `QUALIFIED_TECHNICALLY` only when:

```text
STATIC_ARCHITECTURE_VIOLATIONS = 0
PACKAGE_OR_LOADED_ARCH_MISMATCH = 0
UNMAPPED_SHIPPED_OR_LOADED_COMPONENTS = 0
UNAUTHORIZED_CROSS_SESSION_MESSAGES = 0
SOURCE_WRITE_OR_WRITE_INTENT_DEFECTS = 0
CONTROLLED_FIXTURE_MISSING_OR_EXTRA_EFFECTS = 0
CROSS_SOURCE_PROFILE_SESSION_REALM_MIXES = 0
FORBIDDEN_VALUE_OR_DERIVATIVE_ESCAPES = 0
GUESSED_APPLICATION_AMBIGUITIES = 0
TENANT_OR_EXCEPTION_BROADENING_COUNTEREXAMPLES = 0
CURSOR_AHEAD_OR_DOUBLE_FINAL_EFFECTS = 0
PREMATURE_DURABLE_RECEIPTS = 0
UNAUTHORIZED_STALE_FROZEN_DOWNGRADED_RELEASE_EXECUTIONS = 0
SILENT_UNACKNOWLEDGED_DATA_LOSSES = 0
UNBOUNDED_RESOURCE_FAILURES = 0
CLEANUP_RESIDUE_COUNT = 0
MANDATORY_CANARY_SCANNER_MISSES = 0
MISSING_OR_EXPIRED_REQUIRED_EVIDENCE = 0
BLOCKING_OWNER_OR_ADR_COUNT = 0
```

Performance averages, vendor support statements, assisted support windows, test pass percentages, or a human exception cannot offset a nonzero primary count.

---

# 9. Architecture fitness functions and measurable acceptance criteria

Fitness functions are executable repository or evidence-gate assertions. A prose review cannot substitute.

## 9.1 Build and package fitness functions

| ID | Executable assertion | Acceptance criterion |
|---|---|---|
| FF14-001 | Project graph forbids Coordinator references to user-profile/browser source APIs, token creation, scripting, arbitrary process launch, SQL clients, and source collectors. | Every injected forbidden project/API/package mutation fails CI; clean graph passes. |
| FF14-002 | User Host and Task Host cannot reference HTTP upload, central storage, service management, dynamic plug-ins/scripts, arbitrary SQL/path capability, or raw diagnostics. | Every forbidden mutation fails; only approved boundary projects remain. |
| FF14-003 | Every shipped/loaded executable and library has a declared digest, signer state, license record, SBOM entry, source/package mapping, and PE machine type matching the RID. | Zero unexplained file/module; zero architecture mismatch. |
| FF14-004 | Release packages are self-contained and architecture-specific; no mutable download or runtime dependency resolution occurs after sealed restore. | Network-denied install/start/tests pass; no undeclared egress or package fetch. |
| FF14-005 | Two challenged clean builds produce byte-identical canonical unsigned payloads, or every allowed container/signature difference is bounded by accepted R3 evidence. | Zero unexplained byte difference. |
| FF14-006 | Installer manifest owns every privileged file/service/task/ACL/firewall/certificate mutation and cleanup. | Mutation outside manifest fails; cleanup diff has zero executable/authority residue. |
| FF14-007 | Secure coding analyzers, banned-API rules, nullable/warnings policy, suppression ledger, and threat-model-delta check cover every deployable and generator/native boundary. | Zero unexplained analyzer regression; zero unowned/expired suppression; every boundary-changing mutation requires an updated threat model and named review evidence. |
| FF14-008 | Unsafe/P/Invoke ownership and cleanup are explicit. | Every injected leaked handle/buffer, unsafe public pointer, unrestricted inheritance, and native-exception-text mutation fails; process/file/handle cleanup returns to baseline. |
| FF14-009 | Security/privacy review evidence is digest-bound to the exact changed files, generated/native diff, tests, residual risk, rollback, and cleanup impact. | Publisher rejects missing, stale, wrong-digest, or sole-tool approval evidence. |

## 9.2 Contract and control-artifact fitness functions

| ID | Executable assertion | Acceptance criterion |
|---|---|---|
| FF14-010 | Manifest, inventory, health, evidence, exception, and questionnaire schemas are closed and bounded. | Duplicate/unknown/wrong-case/remote-reference/oversize/depth/allocation hostile vectors all reject deterministically. |
| FF14-011 | Compatibility matching is exact and order independent. | Permuting tuples produces identical outcome; zero/one/multiple matches map to `UNKNOWN`/selected/`UNKNOWN`. |
| FF14-012 | Product ceiling and tenant/exception behavior are monotonic. | For generated domains, effective capabilities are always a subset of release-owned capabilities and base tuple; zero counterexamples. |
| FF14-013 | Anti-rollback and content consistency hold. | Lower sequence, same sequence different bytes, stale chain, wrong release/audience/realm all reject. |
| FF14-014 | Expiry is the minimum of every applicable deadline. | Boundary-time vectors show no permit at or after earliest stop; no locally invented grace. |
| FF14-015 | Kill switches only narrow. | Every generated kill switch removes capabilities or tightens limits; no enabling mutation exists. |
| FF14-016 | Exception status can never be `SUPPORTED` and cannot waive primary invariants. | Schema/reference/production evaluator property test has zero counterexamples. |
| FF14-017 | Authenticated realm/install context dominates payload claims. | Wrong-realm/inventory/exception payload mutations cannot change store key or authority. |

## 9.3 Runtime/security/session fitness functions

| ID | Executable assertion | Acceptance criterion |
|---|---|---|
| FF14-020 | Coordinator effective token contains only the accepted privilege/SID profile for the exact lane. | Zero prohibited privilege; requested and effective profile recorded; any drift disables. |
| FF14-021 | One ordinary-token User Host exists per eligible logon session and validates kernel-reported peers. | Zero cross-session accepted application messages in hostile campaign; stale channel count zero. |
| FF14-022 | Task Host resumes only after restricted token, job, handle, network, permit, and executable checks. | Zero source access before controls; zero child/network/outside-scratch write; one-process job. |
| FF14-023 | Same physical source has at most one active acquisition lease across sessions. | Maximum concurrent readers for one source identity is one; loser read/advance count zero. |
| FF14-024 | Unsupported/unknown/expired/safety-hold platform cannot obtain `RunIntent` or `CollectionPermit`. | Permit count exactly zero for every non-eligible state. |
| FF14-025 | A runtime environment change cancels stale uncommitted work. | Stale page commit count zero across browser/session/profile/power/network/security/manifest transitions. |

## 9.4 Source, privacy, durability, and delivery fitness functions

| ID | Executable assertion | Acceptance criterion |
|---|---|---|
| FF14-030 | UAM source mutation is impossible/detected under every claimed tuple. | Successful source writes = 0; unexpected write-intent defects = 0; positive-control detector passes. |
| FF14-031 | Raw URL/profile/path/file identity and declared derivatives never cross Task Host privacy boundary. | Escape count across every declared sink/encoding = 0; mandatory scanner misses = 0. |
| FF14-032 | One source record produces one durable final ordinary effect under a fixed interpretation. | Controlled missing/extra/duplicate effects = 0; conflicting retry enters hold. |
| FF14-033 | Cursor and effect/no-event fact commit atomically. | Cursor-ahead count = 0 at every failpoint; post-commit ACK-loss retry reuses stable identity. |
| FF14-034 | Server receipt is emitted only after durable custody in declared failure domain. | Premature receipt count = 0; partial network send never changes local acknowledged state. |
| FF14-035 | No component silently deletes unacknowledged minimized data under pressure or expiry. | Unexplained unacknowledged-row delta = 0; state reports backpressure/disabled explicitly. |
| FF14-036 | Browser/profile/provider/version drift cannot silently reuse wrong lineage. | Observable discontinuity retained in old generation = 0; false generation from processing-only change = 0. |

## 9.5 Resource, power, observability, and accessibility fitness functions

| ID | Executable assertion | Acceptance criterion |
|---|---|---|
| FF14-040 | Every queue, retry, parser, Task Host, source page, backup, upload, and reevaluation path has a hard configured bound. | Static bound inventory complete; hostile input cannot exceed approved hard limits or create monotonic resource growth. |
| FF14-041 | Compatibility/health metrics have finite cardinality. | Build-time upper-bound calculation is at or below the approved series budget; dynamic value mutation fails lint. |
| FF14-042 | Logs/errors/support artifacts are value-free. | Forbidden field schema count zero; exception-message/raw-to-string mutation detected; canary escape zero. |
| FF14-043 | Power transitions preserve state invariants and approved energy budget. | Stale permit/channel/handle count zero; effect/cursor oracle exact; physical energy/wakeup limits pass the human-approved profile. |
| FF14-044 | Repeated notifications cannot cause unbounded reevaluation. | Queue depth, CPU, thread, handle, and log growth remain within measured hard limits; latest state wins. |
| FF14-045 | Administrative compatibility state is accessible. | Automated accessibility suite passes; manual keyboard/screen-reader/200% zoom review finds no blocking issue; state never conveyed by color alone. |
| FF14-046 | Missing telemetry cannot be presented as absence of activity. | Every report/query test preserves coverage state and distinguishes unsupported/deferred/disabled from zero events. |

## 9.6 Qualification and operations fitness functions

| ID | Executable assertion | Acceptance criterion |
|---|---|---|
| FF14-050 | A tuple cannot be published without all required lane types and unexpired evidence. | Manifest publisher rejects every missing/stale/mismatched lane mutation. |
| FF14-051 | VM evidence cannot authorize physical/ARM64/VDI/enterprise-EDR claims. | Claim-propagation negative tests all reject. |
| FF14-052 | First failure is immutable and reruns are linked. | Evidence store mutation attempting overwrite fails; failure chain retained. |
| FF14-053 | Cleanup is part of qualification. | No evidence root or support tuple can publish with cleanup other than `PASS`. |
| FF14-054 | Support status equals active manifest plus human decision record. | No code/test-only tuple appears as public `SUPPORTED`; deprecation/expiry transitions match exact dates. |
| FF14-055 | Customer readiness input is categorical and privacy-safe. | Free text/raw attachment/secret/activity canaries reject; stored forbidden-field count zero. |
| FF14-056 | Every supported tuple has named owner functions, runbooks, support window, and review trigger. | Publisher rejects `UNASSIGNED`, missing runbook, or missing trigger. |

## 9.7 Primary acceptance expression

```text
UAM_PLATFORM_SUPPORTED(tuple, release, manifest, now) =
    HumanCoverageDecision(tuple) = APPROVED
    AND ReleaseDigestMatchesProtectedInstallation(release)
    AND ManifestAuthorizedAndMonotonic(manifest)
    AND now < EarliestApplicableExpiry(tuple)
    AND ExactObservedEnvironmentMatch(tuple) = 1
    AND RequiredEvidenceCompleteCurrentAndSameTuple(tuple)
    AND AllPrimaryInvariantFailureCounts(tuple) = 0
    AND CleanupResult(tuple) = PASS
    AND ActiveKillSwitchesRemoveNoRequiredCapability(tuple)
    AND EffectiveTenantPolicyAllowsAndOnlyNarrows(tuple)
    AND RuntimePreconditionsStillMatch(tuple)
```

Any unknown term evaluates to false.

---

# 10. Human decisions and owner questions

Research cannot make the decisions below. The accountable role names are functions, not invented assignments. The conservative temporary default is used until an authorized decision exists.

| ID | HUMAN DECISION | Options and consequences | Conservative temporary default | Accountable role/function | Owner questions |
|---|---|---|---|---|---|
| HD14-01 | Required customer/platform coverage | Narrow x64 client only minimizes cost/risk; adding Server/RDS/AVD/Citrix/FSLogix/ARM64/consumer editions multiplies lanes, support and failure modes. | Only the proposed first-slice x64 local-profile tuple is a qualification target; all others test-only/unsupported. | Product owner with Endpoint platform and Support | Which customer commitments are contractual? Which exact SKUs, builds, architectures, session/profile products and configurations are necessary? What revenue/operational harm results from exclusion? |
| HD14-02 | Exception and deprecation policy | No exceptions is safest but may block customers; narrow time-bound conditional exceptions add governance; broad/permanent waivers undermine support. Deprecation can be rapid or provide migration time. | Exceptions disabled unless exact artifact/process is approved; no primary invariant waiver; expired tuple stops collection. | Product risk/compatibility authority with Security, Privacy, Support | Maximum duration? Who approves/revokes? Are renewals capped? What notice, install-stop, collection-stop, support-end and offline grace dates apply? |
| HD14-03 | Hardware and enterprise lab access | Internal VMs are cheap but cannot prove physical/enterprise claims; dedicated physical/VDI/security labs cost money; customer-assisted lanes add coordination/privacy controls. | No physical/ARM64/Modern Standby/VDI/third-party EDR/proxy support claim without approved representative access. | Engineering leadership / Lab operations / Product | Which physical device classes, AVD/RDS/Citrix/FSLogix systems, proxy/TLS/VPN and EDR products can be maintained? Who owns images, licensing, reset, evidence and vendor access? |
| HD14-04 | EDR/vendor coordination | Self-service testing is limited; formal vendor/customer cases improve diagnosis but need agreements and support time; exclusions can reduce security. | Defender core profile only as a candidate; no UAM-specific exclusion; every third-party product unsupported until coordinated lane passes. | Endpoint security authority / Vendor management | Which vendors/configuration families are required? Who can submit binaries and sanitized evidence? Who owns false positives, allow indicators and requalification after engine/content changes? |
| HD14-05 | Supported Windows editions/releases/LTSC/Server | Enterprise/Education client aligns with managed estate; Home/Pro adds management variance; LTSC/Server have different lifecycle/use/licensing and source/session behavior. | Windows 11 Enterprise/Education 24H2/25H2 x64 exact builds as candidate only. | Endpoint product/support | Are Home/Pro, Enterprise LTSC 2024, IoT LTSC, Server 2022/2025, Server Core, or 26H1 required? Is special-purpose LTSC use appropriate? |
| HD14-06 | Browser channels and update strategy | Stable maximizes currency but qualification cadence is high; Extended Stable reduces major cadence but not minor/security drift; freezing old versions loses servicing. | Edge Stable and optionally Extended Stable exact builds; no Beta/Dev/Canary support. | Browser platform owner / Security | Which channel is managed? Can browser rollout wait for UAM consumer evidence? What emergency browser update latency is acceptable? |
| HD14-07 | ARM64 and emulation coverage | Native ARM64 requires package/lab/support investment; x64 emulation may work but adds uncertainty and overhead. | ARM64 and emulation unsupported. | Product/Endpoint platform | Is ARM64 fleet material? Which device/OEM classes? Is emulation ever acceptable, or must UAM be native-only? |
| HD14-08 | Remote/multi-session and visit-origin semantics | Supporting one non-concurrent RDP session is simpler; multi-session/shared profile lacks reliable visit-origin attribution and needs source leases/provider semantics. | One console or one non-concurrent RDP only; omit origin-session identity. | Product/Data owner with Privacy and VDI platform | Is origin-session attribution required? Are shared profiles acceptable with only acquisition provenance? Which RDS/AVD/RemoteApp/Citrix patterns matter? |
| HD14-09 | Profile-provider coverage | Local profiles are simplest; roaming, FSLogix and Citrix add network/storage/concurrency/failover/discard semantics. | Local non-roaming profile only. | Endpoint/VDI platform with Data correctness | Which provider versions/modes/storage are deployed? Must concurrent sessions be supported? What completeness statement is acceptable during detach/failover/read-only use? |
| HD14-10 | Power coverage and resource budget | Pause-only sleep semantics are conservative; Modern Standby qualification needs physical devices and battery/wakeup limits. | Collection pauses; resume revalidates; no Modern Standby claim. | Endpoint product / SRE / Device engineering | Which device classes and sleep states matter? What battery, wakeup, CPU, memory, I/O, logon and browser-impact limits are acceptable? |
| HD14-11 | Proxy/PAC/TLS interception/VPN coverage | Static machine proxy is bounded; PAC/WPAD/interception/VPN expand executable/configuration/trust failure domains. | Direct explicit or static machine proxy only; no fallback; TLS validation always on. | Network security / Operations | Which authentication modes, PAC/WPAD, proxy failover, enterprise roots, client certificates and VPN classes are required? Who owns test infrastructure and incident response? |
| HD14-12 | Runtime packaging and servicing | Self-contained gives exact behavior and UAM-owned patching; framework-dependent reduces package size but delegates runtime drift. Single-file/AOT change EDR/debug/interop. | Architecture-specific self-contained, non-single-file packages. | Release architecture / Endpoint platform | Can enterprise runtime management provide stronger evidence? What release latency for .NET security patches is required? Is single-file/AOT worth added assurance cost? |
| HD14-13 | Compatibility evidence validity and cadence | Short windows reduce stale risk but increase lab cost; long windows reduce cost but can miss fast browser/security drift. | Evidence expires at risk-based release-defined windows; browser/OS/runtime changes trigger sentinels; no automatic inheritance. | Compatibility authority / SRE / Support | What cadence can be staffed? Which changes require full versus sentinel lanes? Who monitors vendor releases/advisories and stale evidence? |
| HD14-14 | Support ownership and hours | Narrow business-hours support is cheaper but may not meet emergency browser/security release needs; on-call coverage costs more. | Capability stays disabled without assigned owner/runbook/escalation. | Engineering leadership / Support / Operations | Who owns compatibility, browser, Windows, VDI, security, network, power and release incidents? What response coverage is funded? |
| HD14-15 | SLO/RPO/RTO/backlog/long-offline behavior | Strict fail-closed can create data gaps; longer grace increases stale authority/security risk; backlogs consume disk/support. | No production objective; fail closed at authority expiry; never silently drop unacknowledged data. | Product/SRE/Risk | What collection availability, backlog duration, disk budget, recovery time, and offline grace are acceptable? What coverage gaps must reports show? |
| HD14-16 | Metrics/access/retention and rare-population privacy | Rich version/configuration metrics help support but increase cardinality and re-identification; coarse metrics reduce diagnosis. | Finite value-free dimensions; exact inventory local/bounded; no production retention decision. | SRE with Privacy/Data governance | Who may see exact device compatibility inventory? How long? Which aggregates require suppression? What cardinality budget applies? |
| HD14-17 | Customer readiness and evidence sharing | Self-assessment is scalable but error-prone; on-site/managed collection improves accuracy but raises privacy/security concerns. | Categorical questionnaire and sanitized local CLI only; no raw attachments/config/activity. | Support/Privacy/Security | Can customers run signed inventory? What evidence may leave their environment? Who validates answers and deletes rejected material? |
| HD14-18 | Cost, licensing and procurement | Physical devices, AVD/RDS/Citrix/FSLogix, EDR products, proxies, CI runners and vendor support all create recurring cost. | No unapproved product/lab/tool dependency or support commitment. | Product/Finance/Procurement/Legal | What annual lab, license, cloud, support and staffing budget is approved? Which licenses permit automated testing and evidence retention? |
| HD14-19 | Production release and risk acceptance | Technical qualification is necessary but not sufficient; legal/workforce/privacy/security approvals and pilot evidence remain required. | T1 lab only; no pilot/production. | Designated production/risk authority | Have all earlier gates and human decisions passed? What pilot scope, rollback authority, communications and stop criteria apply? |

## 10.1 Required owner assignments before the compatibility gate can close

At minimum, named accountable and support functions are required for:

```text
compatibility manifest and evaluator
Windows service/session security
browser/source acquisition and schema fixtures
endpoint storage/durability
privacy/canary containment
release/MSI/signing/rollback
ARM64 and physical power (if claimed)
RDS/AVD/FSLogix/Citrix (if claimed)
network/proxy/PKI/VPN (if claimed)
Defender/third-party EDR coordination
lab images/evidence/cleanup
SRE/observability/cardinality
support/readiness/incident communication
human coverage, exception, deprecation, budget, and production risk
```

An `UNASSIGNED` blocking function prevents manifest publication for its capability.

---

# 11. CLI experiments/measurements and the exact evidence they must produce

## 11.1 CLI design

The repository SHOULD provide a signed, non-interactive `uam-compat` tool with no arbitrary command execution. Subcommands accept only typed release-owned identifiers and manifest paths. It MUST default to read-only inventory, T1 fixtures, strict redaction, no network upload, and no live source access.

```text
uam-compat inventory
uam-compat validate-package
uam-compat validate-manifest
uam-compat evaluate
uam-compat prepare-lane
uam-compat run-lane
uam-compat qualify
uam-compat verify-cleanup
uam-compat render-report
uam-compat questionnaire validate
```

No subcommand accepts raw SQL, PowerShell, script, executable path, profile path, URL, proxy address, credential, arbitrary environment variable, or free-form test plug-in. The lane catalogue maps a fixed `lane-id` and `scenario-set-id` to code compiled into the signed test release.

### 11.1.1 Read-only inventory

```powershell
uam-compat inventory `
  --redaction strict `
  --output .\evidence\inventory.json `
  --include os,architecture,package,browser,session,profile,power,network-class,security-class
```

Expected behavior:

- emits only the schema in section 5.3;
- never prints connection information, machine/user/network names, paths, IP addresses, certificate subjects, policy contents, browser activity, or installed-software inventory outside the finite browser/security classes;
- does not modify service, task, registry, firewall, proxy, power, browser, security, profile, or network state;
- returns a distinct exit code for complete, incomplete, unsupported, and internal-error inventory;
- writes a local SHA-256 sidecar and machine-readable redaction assertion.

The approved lab connection mechanism is outside this contract. Commands in evidence use a placeholder such as `<APPROVED-LAB-INVOKER>`; actual user, host, address, port, identity file, key, and configuration MUST NOT appear.

### 11.1.2 Package validation

```powershell
uam-compat validate-package `
  --package .\artifacts\endpoint-win-x64.msi `
  --expected-rid win-x64 `
  --file-manifest .\artifacts\file-manifest.json `
  --sbom .\artifacts\sbom.cdx.json `
  --provenance .\artifacts\provenance.json `
  --output .\evidence\package-validation.json
```

It verifies package/file digests, signatures, machine types, lock/source mapping, duplicate/unexpected files, native SQLite identity, .NET runtime identity, installer metadata, SBOM/provenance subjects, and architecture-specific identifiers. It performs no installation.

### 11.1.3 Manifest validation and local evaluation

```powershell
uam-compat validate-manifest `
  --candidate .\control\platform-compatibility.json `
  --active-state .\state\active-control-state.json `
  --product-release-id uam-endpoint-2026.08-r1 `
  --now-source system-verified `
  --output .\evidence\manifest-validation.json

uam-compat evaluate `
  --inventory .\evidence\inventory.json `
  --manifest .\control\platform-compatibility.json `
  --realm-policy .\control\fictional-realm-policy.json `
  --output .\evidence\compatibility-evaluation.json
```

The offline evaluation must be deterministic for identical canonical inputs. It cannot contact a compatibility service or fetch a schema/key/reference from the network.

### 11.1.4 Lane preparation and execution

```powershell
uam-compat prepare-lane `
  --lane-id L2-CORE-X64 `
  --scenario-set-id core-edge-first-slice-v1 `
  --fixture-package .\fixtures\edge-t1-package.json `
  --output .\evidence\lane-plan.json

uam-compat run-lane `
  --plan .\evidence\lane-plan.json `
  --evidence-root .\evidence\run-001 `
  --redaction strict `
  --network-mode sealed-except-declared-fixture `
  --cleanup required
```

`prepare-lane` must prove the plan contains only compiled scenario IDs, T1 fixtures, approved mutations, exact limits, expected assertions, instrumentation and cleanup. `run-lane` refuses an unknown environment or missing prerequisite; it records `BLOCKED`, never `PASS`.

### 11.1.5 Qualification and cleanup

```powershell
uam-compat verify-cleanup `
  --before .\evidence\baseline-inventory.json `
  --after .\evidence\post-run-inventory.json `
  --install-manifest .\artifacts\install-manifest.json `
  --output .\evidence\cleanup-receipt.json

uam-compat qualify `
  --lane-evidence .\evidence\run-001\evidence-envelope.json `
  --required-claims .\policy\tuple-claims.json `
  --output .\evidence\qualification-candidate.json
```

`qualify` cannot sign or publish a manifest. It emits a candidate only if every required assertion exists and passes, canary positive controls pass, no primary invariant failure occurred, evidence matches exact package/environment, and cleanup passed.

## 11.2 Exit-code profile

| Exit code class | Meaning | Support interpretation |
|---|---|---|
| `0` | Command completed and all requested assertions passed | Not automatically supported; inspect signed evidence and human gate. |
| `10` | Environment inventoried but unsupported/unlisted | Correct fail-closed result. |
| `11` | Inventory incomplete/ambiguous/unknown | Correct fail-closed result; never convert to pass. |
| `12` | Prerequisite evidence or owner/ADR missing | Lane blocked. |
| `20` | Test assertion failed | Gate failed; first failure retained. |
| `21` | Primary security/privacy/durability/release/cleanup invariant failed | Immediate stop/incident. |
| `22` | Cleanup failed or unknown | Run invalid and gate failed. |
| `30` | Candidate control/package integrity failure | Reject/hold. |
| `40` | Infrastructure failure before a claim could be tested | `BLOCKED`, not pass or fail of product claim; original evidence retained. |
| `50` | Tool internal error | `UNKNOWN`, no support claim. |

## 11.3 Exact evidence directory

```text
evidence/<experiment-id>/
  evidence-envelope.json
  inventory.json
  package-validation.json
  manifest-validation.json
  lane-plan.json
  assertions.ndjson
  state-transitions.ndjson
  resource-summary.json
  canary-scan.json
  cleanup-receipt.json
  artifacts-manifest.json
  commands-redacted.ndjson
  first-failure.json                # present on any initial failure
  rerun-links.json                  # never replaces first failure
  hashes.sha256
```

Raw restricted traces are not copied into this directory. `artifacts-manifest.json` can refer to a restricted-lab artifact by opaque local retention token and digest until deletion; the shareable package contains only sanitized aggregates/findings.

## 11.4 CLI experiments

| ID | CLI EXPERIMENT / command outline | Exact evidence required | Pass | Fail / stop |
|---|---|---|---|---|
| E14-00 | Hash the prompt and six allowlisted inputs; validate no other project input | File name, size, SHA-256, research date | Exact hashes in section 2.1; no extra input | Missing/changed/substituted/unallowlisted file |
| E14-01 | `validate-package` for x64 and candidate ARM64 packages | Per-file digest/signature/machine type; lock/SBOM/provenance/native mapping | Zero mismatch/unmapped/extra file | Wrong architecture, mutable source, unexpected module |
| E14-02 | `validate-manifest` official/hostile corpus | Canonical bytes, verifier result, sequence/audience/expiry/key cases | Exact expected matrix; bounded resources | One false accept, rollback, key/realm/release confusion |
| E14-03 | `evaluate` generated exact/unknown/ambiguous tuple corpus | Seed, minimal counterexample, reference/production result | Zero semantic difference; unknown never supported | Any broadening/order/fallback counterexample |
| E14-04 | Inventory self-test on synthetic/VM environments | Schema, forbidden-field scan, before/after configuration hashes | Complete harmless facts; zero mutation/value leak | Raw name/path/address/policy/activity or state modification |
| E14-05 | Architecture/API mutation suite | Mutation ID and expected build/test failure | Every forbidden dependency/API passes only after mutation removal | One mutation survives |
| E14-06 | Metric-cardinality and observability mutation | Static bound, runtime series count, canary scan | Within approved budget; dynamic/sensitive labels rejected | Budget exceeded or value appears |
| E14-07 | Disconnected lab-script preparation | Placeholder-only script hashes and lint | No connection/credential/address/identity material; read-only first | Any actual SSH/host/user/key/config detail or mutating preflight |
| E14-08 | Approved lab `inventory` | Sanitized exact environment and capability classification | Every fact explicit; unsupported states recorded | Unknown stated as supported or sensitive output |
| E14-09 | `run-lane L2-CORE-X64` | Full G1–G5/release/resource/cleanup envelope | All primary counts zero | Any primary failure or residue |
| E14-10 | OS cumulative/feature update sentinel | Before/after OS/package/browser/source/security evidence | New build remains disabled until passing policy; no regression | Auto-inheritance or changed behavior |
| E14-11 | Edge update/schema fixture sentinel | Exact Edge signature/version/hash/source capability/effect ledger | Candidate exact result; incompatible shape disables | Guessed schema/advance/source write/raw escape |
| E14-12 | Console/RDP/same-SID session campaign | Kernel session/token/process/lease state and attempts | Zero cross-session; one source lease; fresh reconnect | Accepted wrong peer, duplicate reader/effect |
| E14-13 | L3 FSLogix/Citrix/RDS/AVD campaign | Exact provider/version/mode/storage/session facts and effect/cleanup ledger | Only declared tuple passes; no mix/discard misclaim | Broad provider claim, wrong lineage, orphan container/lease |
| E14-14 | L4 physical power campaign | Power capabilities, transition/store/process/energy summary | Safe pause/resume; approved physical budgets | Stale authority, cursor error, drain/regression, residue |
| E14-15 | L5 native ARM64 and emulation campaign | Hardware/OS/package/module/interop/source/EDR/power evidence | Native exact tuple only; emulation separate | Mixed assets or emulation treated native |
| E14-16 | L6 proxy/PAC/TLS/VPN campaign | Route/TLS/receipt/credential-scan/profile-class evidence | Authorized route only; no bypass/secret/false receipt | Direct fallback, TLS bypass, credential leak, duplicate effect |
| E14-17 | L6 Defender/third-party EDR campaign | Exact security profile, event/result/resource/exclusion/cleanup evidence | No broad UAM exclusion; all gates pass/fail closed | Exclusion required, quarantine residue, raw dump, unbounded impact |
| E14-18 | L8 MSI install/repair/upgrade/rollback/uninstall failpoints | Phase matrix; before/after manifests; store truth; cleanup | Same digest boundary; safe schema behavior; zero residue | Partial/stale executable, destructive rollback, silent data loss |
| E14-19 | Expiry/deprecation/exception/kill switch transitions | Artifact sequences/digests, evaluator/permit/page/batch/store ledger | Exact stop/recovery behavior; no lower/self-reenable | Invented grace, stale commit, exception broadening/permanence |
| E14-20 | Customer questionnaire hostile/privacy test | Schema results and canary/secret/activity rejection | Only categorical safe fields stored | Free text/raw attachment/sensitive value accepted |
| E14-21 | Double-clean build and supply-chain reconciliation | R2/R3 diffs, file manifest, two SBOM views, provenance subjects | Zero unexplained difference/omission | Mutable input, missing native/generated file, subject mismatch |
| E14-22 | Runbook drills: browser withdrawal, EDR quarantine, source-write, raw escape, cleanup failure | Trigger-to-kill/recovery timeline, authority/actions, sanitized evidence | Work stops; no self-reenable; correct lanes rerun; cleanup pass | Continued work, raw evidence export, incomplete recovery |
| E14-23 | Aggregate gate `uam-compat qualify` | `prompt-14-gate.json` binding all exact evidence/ADRs/owners/human states | No failed/missing/expired item; no unsupported claim | Support remains false; open ADR/incident |

## 11.5 `prompt-14-gate.json`

The final machine-readable gate MUST contain at least:

```json
{
  "schemaVersion": "1.0.0",
  "gateId": "PROMPT14-COMPATIBILITY",
  "decision": "FAIL",
  "researchDate": "2026-07-31",
  "inputHashes": [],
  "sourceTreeSha256": null,
  "productReleaseId": null,
  "candidateTupleIds": [],
  "requiredLaneIds": [],
  "evidenceRoots": [],
  "primaryInvariantFailureCounts": {},
  "cleanupResults": [],
  "adrStates": [],
  "ownerAssignments": [],
  "humanDecisionStates": [],
  "exceptions": [],
  "earliestExpiryUtc": null,
  "supportPublicationAuthorized": false,
  "reasons": ["NO_RUNTIME_EVIDENCE_AT_RESEARCH_CLOSE"]
}
```

At research close this gate is necessarily `FAIL` or `BLOCKED`, because I02 proves no runtime environment and no lane has run. Repository implementation must never fabricate a passing gate from this document.

---

# 12. ADR proposals

Every ADR requires an accountable owner and named review trigger before acceptance. Status below is the recommendation from this research, not organizational approval.

| ADR | Decision | Proposed status | Alternatives considered | Rationale/evidence | Owner function | Review trigger |
|---|---|---|---|---|---|---|
| ADR-14-001 | Compatibility is an exact, evidence-backed, expiring allowlist; no broad OS/browser support inference. | **Proposed — accept architecture** | Minimum-version rule; vendor-lifecycle-only; nearest match | Preserves fail-closed and proof-gate invariants; current lab proves nothing. | Compatibility architecture | Any evidence that exact tuples are operationally infeasible without losing invariants |
| ADR-14-002 | Publish signed immutable `PlatformCompatibilityManifest` and strict local evaluator. | **Proposed — accept logical contract** | Dynamic online service; hard-coded checks; tenant-defined matrix | Offline operation, anti-rollback, release binding, audit, and narrow authority. | Release/security | Signed-control-artifact profile or evaluator contract change |
| ADR-14-003 | Support states are `SUPPORTED`, `CONDITIONAL`, `TEST_ONLY`, `UNSUPPORTED`, `UNKNOWN`, `EXPIRED`, `SAFETY_HOLD`, `TEMPORARILY_UNAVAILABLE`, `PRIVACY_DISABLED`. | **Proposed — accept** | Boolean supported; free-text reason | Prevents silent success and activity/coverage confusion. | Product/support/data governance | Portal/report semantics or incident reveals ambiguity |
| ADR-14-004 | Environment inventory is bounded and privacy-safe; exact versions live in inventory/evidence, not metric labels. | **Proposed — accept** | Full software/GPO/EDR inventory; customer raw uploads | Minimum necessary facts and cardinality containment. | Endpoint runtime/privacy | Missing fact blocks a required tuple; privacy incident |
| ADR-14-005 | First candidate is native x64, Windows 11 Enterprise/Education 24H2/25H2 exact builds, Edge exact build, local profile, console or one non-concurrent RDP, Defender/no broad exclusion. | **Proposed — qualification target, not support** | Broader client/Server/VDI/ARM64 initial matrix | Smallest useful continuation of accepted first slice. | Product/endpoint support | Human coverage decision or prototype failure |
| ADR-14-006 | Separate self-contained `win-x64` and later `win-arm64` packages; no AnyCPU/mixed native support; no emulation equivalence. | **Proposed — accept x64; ARM64 deferred** | Framework-dependent; AnyCPU; x64-only on Arm; single package | Exact runtime/native identity and simpler support/rollback. | Release architecture | Measured deployment cost or enterprise runtime evidence |
| ADR-14-007 | Non-single-file .NET packaging initially; single-file/Native AOT require separate evidence. | **Proposed — accept deferral** | Single-file; Native AOT; ReadyToRun everywhere | Avoids extraction/trimming/interop/EDR/debug surface without need. | Release/runtime | Measured resource/deployment need |
| ADR-14-008 | Browser qualification binds exact signed version/source capability; consumer-first manifest precedes rollout. | **Proposed — accept** | Major-version support; current/previous implicit rule | Browser minor/major cadence and internal source drift. | Browser compatibility | Exact interval equivalence evidence or browser source replacement |
| ADR-14-009 | Edge Stable and optional Extended Stable only; Beta/Dev/Canary test-only. | **Proposed — provisional** | All channels; Extended Stable only | Vendor servicing/support cadence and enterprise management; no need for preview support. | Product/browser owner | Human channel requirement and lane evidence |
| ADR-14-010 | RDP/RDS/AVD/Citrix/FSLogix/profile modes are separate tuples; acquisition session never becomes visit-origin session. | **Proposed — accept principle; extended tuples deferred** | One generic remote-session support flag | Session/profile authority and shared-source ambiguity. | Windows/VDI/data owner | New authoritative source or approved origin semantics |
| ADR-14-011 | Power support is pause/drain/revalidate/resume; Modern Standby requires physical lane and no collection promise while asleep. | **Proposed — accept** | Continue scheduled collection during low power | Prevents stale authority and unmeasured battery/wakeup cost. | Runtime/device engineering | Approved business need and physical evidence |
| ADR-14-012 | Coordinator network support uses exact machine-context profiles; no user proxy identity, direct fallback, or TLS bypass. | **Proposed — accept** | Default proxy/user proxy; bypass on failure; disable certificate validation | Preserves enterprise egress, identity, and custody security. | Network security/transport | Required enterprise pattern with equivalent evidence |
| ADR-14-013 | Defender/EDR qualification requires exact configuration family and no broad UAM-specific exclusion. | **Proposed — accept** | Product-name support; broad folder/process exclusion | Vendor documentation calls exclusions protection gaps; exact product behavior varies. | Endpoint security | Vendor-approved narrow alternative and full rerun |
| ADR-14-014 | Compatibility exception is separate, realm/exact-tuple bound, conditional, time-limited, higher-sequence, and cannot waive primary invariants. | **Proposed — accept logical model; human policy pending** | Permanent waiver; local override; mark supported | Prevents risk from becoming silent support. | Compatibility risk authority | Human exception/deprecation decision or incident |
| ADR-14-015 | Evidence is lane-typed; VM evidence cannot publish physical/ARM64/VDI/enterprise-security claims. | **Proposed — accept** | One green CI matrix as universal proof | Separates distinct hardware/enterprise failure domains. | Architecture review/lab | Stronger reproducible virtualization equivalence evidence |
| ADR-14-016 | Cleanup pass is mandatory evidence; run cannot publish with unknown/failed cleanup. | **Proposed — accept** | Cleanup as best effort; VM revert only | Product residue can retain authority/data and hides uninstall defects. | Release/lab operations | No expected weakening; mechanism replacement only |
| ADR-14-017 | Evidence expiry is the earliest applicable platform/release/vendor/evidence/exception deadline; unknown term disables. | **Proposed — accept principle; exact windows human-owned** | Indefinite evidence; implicit rolling support | Stops stale authority under fast servicing. | Compatibility/support | Fleet/cadence measurements and approved support windows |
| ADR-14-018 | Fixed test-lane architecture L0–L8 and claim propagation rules. | **Proposed — accept** | Ad hoc per-bug testing; vendor docs only | Makes support falsifiable and prevents overclaim. | Test architecture | Lane cost/effectiveness evidence or new platform class |
| ADR-14-019 | Readiness questionnaire accepts only categorical safe data; no raw customer configuration/activity attachments. | **Proposed — accept** | Full diagnostic bundle upload | Minimizes privacy/security exposure and support data custody. | Support/privacy | Demonstrated unresolvable need with controlled alternative |
| ADR-14-020 | Compatibility health is finite, accessible, and cannot be interpreted as activity absence. | **Proposed — accept** | Boolean healthy/failed; raw diagnostic messages | Data quality, accessibility, privacy and support correctness. | Product/support UX | Accessibility or downstream reporting change |
| ADR-14-021 | OS/browser/.NET/native/security updates open sentinel work; no automatic support inheritance unless an explicit equivalence ADR passes. | **Proposed — accept** | Auto-inherit all servicing updates | Updates can change load-bearing behavior. | Compatibility operations | Measured sentinel history justifies bounded inheritance rule |
| ADR-14-022 | Product/realm/tuple/source/browser/security kill switches only narrow and cancel uncommitted work. | **Proposed — accept** | Generic feature flag/policy engine; endpoint local enable | Emergency containment without new authority. | Product security/operations | Control-plane redesign or incident |
| ADR-14-023 | Support publication requires `prompt-14-gate.json`, accepted ADRs, assigned owners, human coverage decision, and zero primary failures. | **Proposed — accept** | Manual release note from engineer; test pass badge | Prevents unsupported state from becoming contractual claim. | Architecture/product/support | Governance process replacement with equivalent controls |

No accepted predecessor decision is changed. If implementation evidence shows the accepted Coordinator/User Host/Task Host topology, Task Host privacy boundary, direct-read/backup/defer acquisition, page atomicity, MSI privileged boundary, or privacy lattice cannot function on a required platform without weakening an invariant, the team must create a baseline change proposal rather than silently alter this ADR set.

---

# 13. Ordered implementation backlog with dependencies and stop gates

| Order | Backlog item | Dependencies | Deliverable | Stop gate |
|---:|---|---|---|---|
| 1 | Record Prompt 14 input manifest and source register | none | Exact six-file hashes, research date, public source snapshot list | Missing/extra Project input or unverified time-sensitive fact |
| 2 | Create ADR-14-001 through ADR-14-023 and human-decision records | 1 | Repository ADR/decision files with `UNASSIGNED` markers | No implementation may imply acceptance of unapproved human scope |
| 3 | Assign compatibility, Windows, browser, privacy, storage, release, lab, support and incident owner functions | 2 | Owner/escalation register | Blocking owner absent before affected lane |
| 4 | Define strict compatibility contracts and schemas | Batch 01 contracts, 2 | Manifest, inventory, evaluation, evidence, exception, questionnaire, error schemas/vectors | Unknown/duplicate/broadening vector accepted |
| 5 | Implement pure reference evaluator and production evaluator separately | 4 | Deterministic exact-match/expiry/monotonicity libraries | Reference/production common decision code or property counterexample |
| 6 | Implement `uam-compat` read-only inventory model with strict redaction | 4–5 | OS/arch/package/browser/session/profile/power/network/security class inventory | Any raw path/name/address/policy/activity or state mutation |
| 7 | Implement metric-cardinality and forbidden-field architecture checks | 4–6 | CI lint and generated upper-bound report | Dynamic/sensitive label or unbounded vocabulary passes |
| 8 | Add architecture-specific publish projects/profiles and package manifest | Batch 01 repo controls, 4 | `win-x64` package; placeholder-disabled `win-arm64` pipeline | Any mixed/unknown native asset or mutable dependency |
| 9 | Implement PE/signature/file/module/SBOM/provenance validation | 8 | `validate-package` and mutations | Unmapped file/module, wrong arch, signature/provenance mismatch |
| 10 | Implement manifest candidate/activation SQLite transaction and evaluator hooks | 4–6, Batch 01 policy/store patterns | Crash-safe active/previous candidate state, audit, anti-rollback | Partial/stale/wrong-realm artifact activates |
| 11 | Implement compatibility gates before Coordinator run intent, User Host permit, page acceptance and transport | 5–10, accepted Batch 01/02 contracts | Typed authorization checks and state-change cancellation | Non-eligible state produces permit/commit/upload |
| 12 | Implement finite health/error/accessibility contracts and local support CLI | 4–7, 11 | Value-free health JSON/UI requirements and tests | Activity absence confusion, raw detail, inaccessible blocking state |
| 13 | Build deterministic OS/browser/session/profile/network/security inventory fixtures | G0 foundations, 4–12 | T1 fixture package and independent expected outcomes | Nondeterminism, real/customer values, oracle common code |
| 14 | Build Edge schema/servicing fixture corpus | Batch 02 fixtures, 13 | Handcrafted and exact browser-generated T1 profiles, truth ledger | Raw real activity or unsupported fixture treated as proof |
| 15 | Implement L0/L1 lane runner, evidence envelope, first-failure and cleanup contracts | 4–14 | `prepare-lane`, `run-lane`, `qualify` pure/static lanes | Failure overwritten, cleanup not mandatory, arbitrary command path |
| 16 | Run E14-01 through E14-06 | 15 | Static/package/evaluator/privacy/cardinality evidence | Any architecture/monotonicity/redaction failure |
| 17 | Prepare placeholder-only disconnected Windows lab scripts | 15–16 | Inventory/install/test/fault/cleanup plans with no connection data | Any actual user/host/address/port/key/SSH config/credential |
| 18 | Obtain human-approved first x64 lab matrix and licenses | HD14-01/03/05/06/10/11/12/18 | Named exact OS/browser/package/security/network/power scope | Unknown environment or unlicensed setup |
| 19 | Execute read-only lab inventory and bind exact Batch 01 G1 evidence | 17–18, Batch 01 gate | Sanitized inventory and predecessor evidence index | G1 absent/stale/mismatched; live source remains blocked |
| 20 | Build/execute L2 first x64 core lane with T1 Edge source | 14–19, Batch 02 prototypes | P14-03 evidence | Any G1–G5/source/privacy/release/resource/cleanup primary failure |
| 21 | Run console/RDP/same-SID negative matrix | 20 | P14-04 evidence and first-session scope result | Cross-session/duplicate reader/effect/origin claim |
| 22 | Run OS and Edge servicing sentinels | 20–21 | E14-10/11 evidence and exact version allow/block policy | Version proximity or stale manifest collects |
| 23 | Implement and run L8 MSI lifecycle/failpoints | 20–22 | P14-11 evidence for clean/upgrade/rollback/uninstall | Mixed boundary, destructive rollback, silent data loss, residue |
| 24 | Run expiry/exception/kill switch/recovery campaign | 10–23 | P14-12 evidence | Invented grace, broadening, stale commit, lower/self-reenable |
| 25 | Aggregate technical first-tuple candidate gate | 1–24 | `prompt-14-gate.json` with technical status | Any missing/expired evidence, owner, ADR or primary failure |
| 26 | Human decision on first support tuple, evidence windows, deprecation and support ownership | 25, HD14 series | Approved/rejected support publication record | No manifest/public support without approval |
| 27 | Publish test-signed then production-authorized manifest through release process | 10, 25–26, signing authority | Higher-sequence exact manifest; same package digest | Wrong release/digest/audience/realm, unsigned/manual edit |
| 28 | Pilot only after all earlier suite gates and production authorities | 27 plus global suite | Narrow ring with kill/rollback/support | Prompt 14 alone never authorizes pilot |
| 29 | Add L4 physical x64 power lane if power classes are claimed | 20, HD14-03/10 | P14-06 per hardware/power class | VM result used as physical proof; stale state or budget failure |
| 30 | Add native ARM64 build/lab/lane only after demand decision | 8–16, HD14-01/03/07/18 | P14-07 and separate tuple | Emulation/mixed assets or missing native dependency |
| 31 | Add L3 RDS/AVD/FSLogix/Citrix lane per exact demand | 14–21, HD14-01/03/08/09/18 | P14-10 per provider/mode | Generic VDI/profile support claim or origin attribution |
| 32 | Add L6 static proxy/TLS/VPN/PAC profiles per demand | Transport gate, HD14-03/11/18 | P14-08 per exact network class | Direct fallback, TLS bypass, secret leak, false receipt |
| 33 | Add L6 third-party EDR profiles per demand | Core tuple, HD14-03/04/18 | P14-09 per exact product/config family | Broad exclusion, raw capture, quarantine residue, unbounded impact |
| 34 | Establish recurring L7 vendor release/advisory watcher and stale-evidence scheduler | 22–27, HD14-13/14 | Automated issue creation, never auto-support | New version silently inherits support or evidence expires unnoticed |
| 35 | Exercise incident/runbook drills and adjacent-lane rerun policy | 20–34 | E14-22 receipts | Work continues after primary failure or raw evidence exported |
| 36 | Quarterly matrix/skills/cost review; shrink unsupported matrix when cadence cannot be sustained | Human operations/budget | Matrix decision and support-cost evidence | Unsupported commitment retained without lab/owner/cadence |

## 13.1 Critical stop/go sequence

1. **GO** for sections 4–17 using pure code, T1 fixtures, exact packages, and disconnected scripts.
2. **STOP** before any live browser-source operation until the exact Batch 01 G1 gate passes for the intended machine/package.
3. **GO** to L2 only in an approved disposable/reverted VM with synthetic Edge profiles and localhost/reserved-domain activity.
4. **STOP** the tuple on any primary invariant, source impact, unbounded resource effect, unsupported state recorded as success, or cleanup failure.
5. **GO** to a technical candidate only after L0/L1/L2/L8 and exact applicable update/expiry campaigns pass.
6. **STOP** before publishing `SUPPORTED` until human coverage, exception/deprecation, owners, lab, EDR/network scope, budget/support and production authorities are recorded.
7. **GO** to physical ARM64/power, VDI/profile, enterprise network, or EDR support only through their separate lanes and exact tuples.
8. **STOP** every tuple automatically on expiry, evidence invalidation, package mismatch, emergency kill, or relevant vendor servicing withdrawal.

---
# 14. Open-source repository assessment table

## 14.1 Assessment method and decision rule

**RECOMMENDATION.** Open-source code, public images, test corpora, and vendor deployment templates may reduce common-mode error, but none may create a UAM support claim. Every candidate must have an immutable revision or exact release, license/notice approval, maintained source, relevant tests, a security-reporting path, package-to-source/binary mapping where consumed, a UAM-specific threat comparison, an owner, and a removal path. In table 14.2, the linked repository name is the repository URL; the next column identifies the relevant files/directories; the remaining columns record the exact tag, release, or commit, license, recent maintenance/release activity, testing quality, security posture, architectural similarity, threat-model differences, reuse/no-copy decision, and dependency/reference/no-go suitability.

The classification meanings are:

- **Dependency candidate** — may be consumed only after the repository dependency-admission gate, exact lock, SBOM/provenance reconciliation, hostile tests, and Legal/Security approval.
- **Test-only candidate** — may execute only in sealed T1 qualification lanes; it is not shipped to endpoints and cannot define expected UAM privacy or support outcomes by itself.
- **Reference only** — ideas and test cases may be studied; no source, package, binary, workflow, or architecture is authorized for reuse by this result.
- **Neither / no-go as reviewed** — the revision, provenance, security posture, license, maintenance, or UAM fit is insufficient.

**FACT.** The repository search found useful Windows packaging, ARM64 image, browser automation, architecture-test, and AVD deployment references. It did **not** find a maintained public repository that proves the combined UAM threat model: low-privilege machine service, per-session user host, fixed restricted collector, browser-history zero-write acquisition, pre-IPC minimization, atomic page progress, MSI rollback, exact RDS/FSLogix/Citrix behavior, enterprise proxy/EDR behavior, physical power, and complete cleanup. Vendor deployment repositories and hosted CI images therefore remain environment-building inputs, not compatibility proof.

## 14.2 Consolidated repository review

| Repository and immutable revision reviewed | Relevant files/directories | License, maintenance, tests, and security posture | Architectural similarity, threat-model difference, reusable ideas, and ideas not to copy | Suitability |
|---|---|---|---|---|
| [.NET runtime `v10.0.10`](https://github.com/dotnet/runtime/tree/8f030f80c0dd2722eb2f618984e9db6784765963), commit `8f030f80c0dd2722eb2f618984e9db6784765963` | `src/coreclr`, `src/libraries`, `src/native`, `eng`, `.github/workflows` | MIT plus component notices. Active supported release, extensive unit/integration/runtime/architecture CI, public security process, generated/native code and large transitive notice surface. | Similarity: UAM uses this runtime family and Windows interop. Reuse exact RID/native-asset validation, host/runtime inventory, servicing discipline, and cross-architecture test ideas. Do not copy repository scale, broad reflection/runtime surface, friend-assembly patterns, or assume runtime tests prove UAM G1–G5 behavior. | **Inherent runtime dependency candidate** under the accepted .NET family. Exact self-contained files, patch, SBOM, native modules, package provenance, and UAM regression lanes remain mandatory. |
| [Microsoft PowerToys `v0.100.2`](https://github.com/microsoft/PowerToys/tree/1d11b732b7ba7dbb265d1151531655fd8d83c76d), commit `1d11b732b7ba7dbb265d1151531655fd8d83c76d` | `installer`, `src`, `tools`, `.github/workflows`; release assets include machine-wide and per-user x64 and ARM64 installers | MIT plus third-party notices. Actively maintained; release dated 26 June 2026; broad CI and a public security process. The reviewed release publishes x64/ARM64 installer hashes. | Similarity: large C#/C++ Windows product with multiple processes, architecture-specific installers, signing, diagnostics, and enterprise deployment concerns. Reuse artifact naming, architecture separation, installer-hash publication, upgrade/cleanup fixture ideas. Do not copy its plug-in/action surface, UI/elevation breadth, autonomous updater, arbitrary utility execution, or broad telemetry architecture. | **Reference only.** Strong packaging/ARM64 comparison input; not a UAM dependency or support oracle. |
| [`actions/runner-images` Windows 11 ARM64 image `win11-arm64/20260727.122`](https://github.com/actions/runner-images/tree/a261cdeaf340cf923fb371dfca4afef4f71d529e), commit `a261cdeaf340cf923fb371dfca4afef4f71d529e` | `images/windows/Windows11-Arm64-Readme.md`, `images/windows`, image-generation workflows | MIT. Frequently updated public image definitions and release manifests; reviewed image released 28 July 2026 and explicitly described as a public preview. Image construction has CI, but hosted-runner availability, installed software, and preview terms can change. | Similarity: useful architecture-native build/test lane and exact software inventory. Reuse immutable image/readme capture, architecture/package smoke checks, and early ARM64 compile/test feedback. Do not treat emulated tools, hosted hypervisor behavior, or a green hosted run as proof of physical ARM64, Modern Standby, MSI/EDR, firmware, or customer policy. | **Test infrastructure reference / optional T1 build-lane candidate.** Never sufficient for ARM64 support and never the physical L4 lane. |
| [Microsoft CsWin32 `0.3.298`](https://github.com/microsoft/CsWin32/tree/e4a7320acd0c62f7490efd4c34421c181212dd8d), commit `e4a7320acd0c62f7490efd4c34421c181212dd8d` | `src/Microsoft.Windows.CsWin32`, generator code, metadata handling, tests | MIT. Microsoft-maintained source generator with tests. Generated code and metadata are executable supply-chain inputs; API coverage and generated output may change between versions. | Similarity: UAM needs narrowly typed Windows service, token, session, pipe, job, power, file-identity, and PE APIs. Reuse generated strongly typed signatures and generated-source diffing. Do not expose the full Win32 surface, let generator output bypass review, or make raw handles/pointers public domain APIs. | **Pinned build-time dependency candidate** only with `PrivateAssets`, an API allowlist, generated-source review/diff, exact package-to-source mapping, and a maintained manual fallback for critical calls. |
| [Selenium `selenium-4.46.0`](https://github.com/SeleniumHQ/selenium/tree/selenium-4.46.0), release 11 July 2026; predecessor review recorded commit prefix `df5a634` | `dotnet`, WebDriver bindings, browser-driver tests, Grid and integration tests | Apache-2.0. Active cross-browser project with broad tests and security reporting. Selenium Manager can resolve/download drivers unless explicitly disabled, which is incompatible with sealed evidence lanes. | Similarity: can create deterministic localhost browser visits and exercise Edge/Chrome/Firefox exact builds. Reuse W3C WebDriver orchestration, browser/driver version checks, and deterministic visit plans. Do not use Grid, remote telemetry, automatic driver/browser downloads, BiDi/CDP as an acquisition source, or infer ordinary-user behavior from automation alone. | **Test-only candidate** after exact tag/package/binary pinning, driver hash/signature checks, offline operation, and proof that automation artifacts are not mistaken for source compatibility. |
| [Microsoft Playwright `v1.62.1`](https://github.com/microsoft/playwright/tree/v1.62.1), release 30 July 2026; predecessor review recorded commit prefix `26a9e47` | `packages/playwright-core`, browser launch/fixture code, tests, `.github/workflows` | Apache-2.0 plus Node/browser package surface. Very active with extensive tests and a security process; rapid release cadence and bundled/downloaded browser behavior enlarge provenance and storage cost. | Similarity: deterministic browser fixtures, tracing, isolation, and multi-browser orchestration. Reuse fixture ergonomics and fault reproduction ideas. Do not ship it, enable runtime browser downloads, use traces containing raw URLs outside the restricted lab, or adopt its browser bundle as the product support target. | **Test-only alternative to Selenium.** Select one default automation stack through a bake-off; do not carry both without measured fault-detection value. |
| [Web Platform Tests URL corpus](https://github.com/web-platform-tests/wpt/tree/181476aa16e8b28a07698bef3a0275fa53dd22e5/url), commit `181476aa16e8b28a07698bef3a0275fa53dd22e5` | `url`, parser/host/IDNA/IP fixtures and harness metadata | BSD-3-Clause contributions. Large cross-browser standards corpus with active maintenance. It tests web-platform behavior, not UAM privacy, resource, realm, policy, or support semantics. | Similarity: useful hostile/differential URL input for the Batch 02 parser and future Chrome/Firefox research. Reuse selected pinned vectors with UAM-owned expected classifications and notices. Do not make browser recovery semantics authoritative, import the whole corpus without bounds, or let WPT expected results define UAM hard-deny/privacy outcomes. | **Pinned test-data/reference candidate.** No endpoint dependency and never the sole oracle. |
| [Testcontainers for .NET `4.13.0`](https://github.com/testcontainers/testcontainers-dotnet/tree/1717807affaae9b967035516ebedcd76dd7eaffb), commit `1717807affaae9b967035516ebedcd76dd7eaffb` | `src`, `tests`, resource-reaper/cleanup logic, CI, package provenance | MIT. Maintained project with tests, security policy, and package/provenance practices. It requires a container runtime with substantial local authority. | Similarity: reproducible disposable server/integration dependencies and cleanup receipts. Reuse resource ownership labels, deterministic teardown, and fault-environment composition for non-Windows server tests. Do not use containers as proof of Windows services, interactive sessions, MSI, browser profile providers, power, ARM64 hardware, EDR, or RDS/VDI. | **Trusted server-integration test candidate only.** Not part of endpoint compatibility evidence. |
| [ArchUnitNET `0.13.3`](https://github.com/TNG/ArchUnitNET/tree/b25c4f940b1d067e97092783d0ef16e4fe12d8c3), commit `b25c4f940b1d067e97092783d0ef16e4fe12d8c3` | architecture-test library and tests | Apache-2.0. Maintained test library with a focused surface. It observes compiled structure but cannot see every reflection, native, installer, generated, or runtime action. | Similarity: UAM needs executable component/reference rules and forbidden API checks. Reuse readable architecture assertions where they add coverage. Do not replace custom MSBuild graph, source, binary, P/Invoke, installer, SBOM, or mutation checks with one library. | **Test dependency candidate** only if a mutation comparison proves extra detection at acceptable maintenance cost. |
| [Azure Virtual Desktop Landing Zone Accelerator](https://github.com/Azure/avdaccelerator), `main` screened 31 July 2026; no immutable revision was adopted | `.github`, `avm`, `workload`, deployment templates, monitoring/examples | MIT with Microsoft security/support files. Active IaC repository with thousands of commits and customer deployment scenarios. The reviewed public page states Microsoft Support does not handle the published tools. No exact commit was accepted into this result. | Similarity: can help construct repeatable AVD host pools, session hosts, storage, and image environments. Reuse only high-level environment-as-code and teardown ideas after an immutable pin. Do not copy production topology, assume its policies fit UAM, treat deployment success as session/profile/source proof, or include customer identifiers/network configuration in evidence. | **Neither as reviewed; reference only after pinning and separate IaC security review.** Not a compatibility harness or dependency. |
| [Azure `RDS-Templates`](https://github.com/Azure/RDS-Templates), `master` screened 31 July 2026; no immutable full commit was adopted | `AVD-TestShortpath`, `ARM-wvd-templates`, `Custom-Image-Templates`, `Scripts`, `test`, `.github` | MIT; repository exposes CI, security guidance, and many deployment/scripts, but tools are provided as-is and the reviewed mutable branch is not a reproducible evidence anchor. | Similarity: RDS/AVD deployment and network test examples may help build an isolated lab. Reuse only bounded environment-creation or negative-network ideas after pinning and code review. Do not copy broad PowerShell execution, certificate/network shortcuts, customer-shaped configuration, or infer UAM source/session/profile behavior from template success. | **Neither as reviewed / reference only.** No endpoint dependency; no support evidence. |

## 14.3 Repository search gaps and explicit no-copy rules

**UNKNOWN.** No suitable public end-to-end test harness was found for any of these claims:

1. FSLogix/Citrix profile attach, concurrent same-SID access, one-writer/read-only/write-back semantics, browser-source continuity, and UAM cleanup under one repeatable oracle;
2. RDS/AVD logon, disconnect, reconnect, RemoteApp, broker drain, image update, profile attach/detach, and G1–G5 evidence in one maintained project;
3. third-party EDR injection/quarantine/reputation/performance/cleanup qualification across products and policy families;
4. physical Modern Standby, hibernate, firmware, battery, and ARM64 device qualification for a Windows service plus per-session helper;
5. a UAM-like compatibility-manifest evaluator that prevents VM evidence from promoting physical/enterprise support claims.

These gaps are not permission to build a broad custom framework. UAM should implement only the small typed lane runner, evidence envelope, manifest evaluator, fixtures, and cleanup diff required by sections 5, 8, and 11. Deployment automation for AVD/Citrix/FSLogix or EDR products remains separate, access-controlled lab infrastructure owned by the relevant platform/security team.

The following ideas MUST NOT be copied from references unless a later ADR changes the accepted design:

- arbitrary plug-ins, scripts, command paths, browser extensions, DevTools/CDP collection, or broad process inspection;
- self-update or release-channel behavior that bypasses MSI/enterprise deployment and digest-bound promotion;
- dynamic browser/driver/runtime downloads in a qualification or release evidence lane;
- hosted VM success as physical hardware, power, ARM64, VDI, proxy, or EDR proof;
- deployment templates as authority for customer identities, networks, certificates, proxy rules, profile locations, exclusions, or production topology;
- test traces, browser profiles, crash artifacts, or support bundles containing raw URLs, profile paths, file identities, addresses, credentials, or customer configuration.

---

# 15. Source register with stable links, dates, reviewed versions, claims, and limitations

## 15.1 Supplied allowlisted sources

| Ref | Source and reviewed digest | Source date/status | Claim supported | Limitation |
|---|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md`, SHA-256 `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Baseline dated 31 July 2026 | Accepted process, privacy, durability, release, realm, restore, and human-decision invariants. | Condensed implementation baseline; not runtime evidence or production approval. |
| I02 | `03-sanitized-windows-lab-capability.md`, SHA-256 `8da73d913e7f1b01d943e4c8b0ed7bb2722571ff6a3a20cef0b8f47738a4658f` | Inspected 31 July 2026 | A sanitized connection path to a Windows VM exists. | Proves no OS, architecture, browser, session, profile, power, network, security, permission, or UAM behavior; connection material is deliberately excluded. |
| I03 | `05-decisions-contradictions-and-gates.md`, SHA-256 `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | July 2026 synthesis | Accepted decisions, direct-read/backup/defer acquisition, ordered G0–G12 proof gates, and stop rule. | Implementation-research authority only; exact compatibility remains measurement/human owned. |
| I04 | `06-research-evidence-rules.md`, SHA-256 `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | Current suite rules | Evidence labels, primary-source hierarchy, human authority, and conflict/change-proposal discipline. | Quality rule, not evidence that a technical claim is true. |
| I05 | `result-review-01-foundations.md` (local file `batch-01-review-result(3).md`), SHA-256 `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | Review dated 31 July 2026; accept with mandatory conditions | G0/G1 contracts, Windows topology, policy lattice, repository/release, identity, test, evidence, and cleanup requirements. | Accepted architecture direction; G1 runtime, literal Windows configuration, exact tools/limits, and production authority remain open. |
| I06 | `result-review-02-endpoint-data.md`, SHA-256 `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | Review dated 31 July 2026; prototypes only | Edge discovery/acquisition, source/generation/cursor, raw Task Host boundary, ASCII host matching, page progress, and G2–G5 gates. | No live-source, exact Edge/Windows/native stack, output-field, resource, or production support proof. |

## 15.2 Windows, browser, runtime, profile, power, network, and security primary sources

| Ref | Stable source; document/release date and version reviewed | Claim supported | Limitation for UAM |
|---|---|---|---|
| W01 | Microsoft, [Windows 11 release information](https://learn.microsoft.com/en-us/windows/release-health/windows11-release-information), reviewed 31 July 2026; quality updates dated 28 July 2026 for 24H2/25H2/26H1 | Current servicing branches/builds and end dates; 26H1 is scoped to new devices and is not an in-place feature update from 24H2/25H2; LTSC rows and lifecycle dates. | Vendor servicing fact only. It does not qualify an edition/build, feature set, hardware, browser source, GPO, EDR, or UAM release. |
| W02 | Microsoft, [Windows 10 Home and Pro lifecycle](https://learn.microsoft.com/en-us/lifecycle/products/windows-10-home-and-pro), reviewed 31 July 2026; standard Windows 10 22H2 support ended 14 October 2025 | Standard Windows 10 servicing status. | ESU, LTSC, browser support, or customer presence does not automatically create UAM support. |
| W03 | Microsoft, [Windows Server 2025 lifecycle](https://learn.microsoft.com/en-us/lifecycle/products/windows-server-2025), reviewed 31 July 2026; product start 1 November 2024, mainstream support through 13 November 2029, extended support through 14 November 2034 | Server 2025 lifecycle is current. | Lifecycle says nothing about Desktop Experience/RDS roles, interactive browser use, profile providers, Defender role exclusions, licensing, or UAM G1–G5 fitness. |
| W04 | Microsoft, [Windows Server 2022 lifecycle](https://learn.microsoft.com/en-us/lifecycle/products/windows-server-2022), reviewed 31 July 2026; mainstream support ends 13 October 2026, extended support 14 October 2031 | Server 2022 lifecycle and near-term mainstream-support transition. | Extended security support is not a reason to create a new UAM interactive-browser commitment without operational value and full lanes. |
| W05 | Microsoft, [Windows Enterprise LTSC overview](https://learn.microsoft.com/en-us/windows/whats-new/ltsc/overview) and [Windows 11 Enterprise LTSC 2024](https://learn.microsoft.com/en-us/windows/whats-new/ltsc/whats-new-windows-11-2024), version 24H2/LTSC 2024, reviewed 31 July 2026 | LTSC is a special-purpose servicing channel with a different feature/application model. | Does not prove Edge packaging/policy, .NET/native dependency support, ordinary knowledge-worker use, or UAM fitness. IoT licensing/purpose remain human decisions. |
| W06 | Microsoft, [Microsoft Edge release schedule](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-release-schedule), updated 11 June 2026; Edge 152 introduces a two-week Stable major cadence and Extended Stable remains eight weeks | Browser qualification cadence and need for recurring exact-build sentinels. | Target dates can change; a schedule does not prove schema, profile, locking, update, rollback, or source safety. |
| W07 | Microsoft, [Microsoft Edge support lifecycle](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-support-lifecycle), updated 11 June 2026 | Only the current Stable release is serviced; assisted support windows differ for Stable and Extended Stable; preview channels lack normal enterprise support. | Vendor support windows do not define UAM compatibility windows and cannot extend stale UAM evidence. |
| W08 | Microsoft, [Microsoft Edge Stable release notes](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-relnote-stable-channel), updated 27 July 2026; reviewed Stable `150.0.4078.105` | Point-in-time exact Edge release/advisory input. | Not a source-schema contract or evidence that UAM can read the internal database safely. Progressive rollout and later patches require recapture. |
| W09 | Microsoft, [.NET and .NET Core support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), updated 14 July 2026; .NET 10 LTS `10.0.10`, supported through 14 November 2028 | Current supported .NET line, patch policy, and lifecycle. | Exact patch is a release input, not timeless architecture. Microsoft support does not prove UAM interop, packaging, update, EDR, or source behavior. |
| W10 | Microsoft, [.NET application publishing overview](https://learn.microsoft.com/en-us/dotnet/core/deploying/), reviewed 31 July 2026 | Framework-dependent versus self-contained, RID/platform specificity, single-file characteristics, and runtime ownership trade-off. | Documented deployment capability does not choose UAM packaging or prove MSI, startup, extraction, update, rollback, diagnostics, EDR, or cleanup behavior. |
| W11 | Microsoft, [How x64 and x86 emulation work on Windows on Arm](https://learn.microsoft.com/en-us/windows/arm/apps-on-arm-x86-emulation), reviewed 31 July 2026 | Windows on ARM can emulate non-native application architectures. | Emulation capability is not native ARM64 equivalence and does not prove mixed native dependencies, interop, EDR injection, installer, resource, power, or UAM support. |
| W12 | Microsoft, [PE format — machine types](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#machine-types), reviewed 31 July 2026 | Authoritative PE/COFF machine constants for architecture validation. | File headers alone do not prove a dependency will load or behave correctly; runtime loaded-module and hostile package evidence remains required. |
| W13 | Google Chrome Releases, [Stable Channel Update for Desktop](https://chromereleases.googleblog.com/2026/07/stable-channel-update-for-desktop_0887107924.html), published 29 July 2026; Chrome `151.0.7922.71/.72` for Windows/Mac | Point-in-time Chrome Stable version and release cadence input for detection/sentinel planning. | Google release status does not create a UAM Chrome source contract, profile discovery rule, privacy transform, or support claim. |
| W14 | Google Chrome Enterprise, [Extended Stable channel](https://support.google.com/chrome/a/answer/16942104?hl=en), reviewed 31 July 2026; Chrome 153 moves Stable to a two-week cadence and Extended Stable remains eight weeks | Stable/Extended Stable channel concepts and enterprise cadence context. | Cadence is not internal-history schema compatibility; exact builds and a separate source result would still be required. |
| W15 | Microsoft, [Azure Virtual Desktop supported operating systems and prerequisites](https://learn.microsoft.com/en-us/azure/virtual-desktop/prerequisites), updated 20 June 2025, reviewed 31 July 2026 | AVD-supported session-host operating-system families and stated exclusions. | AVD platform support does not prove UAM G1–G5, profile, agent, broker, network, image, resource, or cleanup behavior. This result uses W18 as the citation anchor for the same source. |
| W16 | Mozilla, [Firefox 153.0.1 release notes](https://www.mozilla.org/en-US/firefox/153.0.1/releasenotes/), release 28 July 2026 | Point-in-time Firefox Rapid Release version and Windows servicing evidence. | No UAM Firefox discovery/acquisition/cursor/privacy contract exists; release notes are not history-schema evidence. |
| W17 | Mozilla, [Security vulnerabilities fixed in Firefox ESR 140.13](https://www.mozilla.org/en-US/security/advisories/mfsa2026-70/), announced 21 July 2026 | Point-in-time ESR branch/security release; ESR reduces major cadence but still receives point updates. | ESR lifecycle does not prove profile/source semantics or UAM support; a separate source-family design and full gates are required. |
| W18 | Microsoft, [Azure Virtual Desktop prerequisites](https://learn.microsoft.com/en-us/azure/virtual-desktop/prerequisites), updated 20 June 2025, reviewed 31 July 2026 | Supported AVD session-host OS families; Windows 11 Enterprise multi-session capability; listed exclusions including Arm64 Azure VM session hosts. | Documentation does not prove customer host-pool, profile, agent, image, session, network, or UAM behavior. |
| W19 | Microsoft, [FSLogix prerequisites](https://learn.microsoft.com/en-us/fslogix/overview-prerequisites), reviewed 31 July 2026; current documentation includes Windows 11 and Windows Server 2025 support considerations | FSLogix-supported OS prerequisites and dependency/security-product considerations. | Vendor prerequisites and suggested exclusions do not authorize UAM support or exclusions. Exact FSLogix build, storage, identity, policy, and UAM lane are required. |
| W20 | Microsoft, [FSLogix multiple and concurrent connections](https://learn.microsoft.com/en-us/fslogix/concepts-multi-concurrent-connections), reviewed 31 July 2026 | Different profile-container connection modes and constraints, including concurrency limitations in AVD scenarios. | Does not establish browser visit origin, source completeness, one-writer behavior, or UAM correctness under those modes. |
| W21 | Microsoft, [FSLogix configuration settings](https://learn.microsoft.com/en-us/fslogix/reference-configuration-settings), reviewed 31 July 2026 | Exact settings can alter attach, concurrent access, differencing/write-back, Cloud Cache, redirection, and profile behavior. | The setting surface is large and customer-specific; documentation alone cannot define a UAM-equivalent tuple or safe default. |
| W22 | Citrix, [Profile container configuration](https://docs.citrix.com/en-us/profile-management/current-release/configure/citrix-profile-management-profile-container.html), current release/Profile Management 2603 reviewed 31 July 2026 | Profile-container concurrency, read-write/read-only secondary sessions, write-back/differencing, caching, and discarded-change behavior. | Citrix documentation is not UAM source-completeness or origin-attribution evidence; exact VDA/Profile Management/storage/policy lanes are required. |
| W23 | Microsoft, [What is Modern Standby](https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/modern-standby), last updated 3 March 2021, reviewed 31 July 2026 | Modern Standby is S0 low-power idle with controlled activity and hardware/software-specific behavior. | Old but still load-bearing platform concept; it does not prove a specific physical system, firmware, battery impact, activator behavior, or UAM suitability. |
| W24 | Microsoft, [System power states](https://learn.microsoft.com/en-us/windows/win32/power/system-power-states), last updated 14 July 2025, plus [System sleeping states](https://learn.microsoft.com/en-us/windows-hardware/drivers/kernel/system-sleeping-states), last updated 1 May 2025 | S1–S5, hibernate, fast startup, resume, and retained/restored context semantics. | API/state documentation cannot prove notification timing, firmware/drivers, stale process assumptions, power cost, or cleanup on a particular machine. |
| W25 | Microsoft, [Modern Standby SleepStudy](https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/modern-standby-sleepstudy), reviewed 31 July 2026 | SleepStudy is an inbox low-impact measurement tool and physical/instrumented measurement is the strongest power evidence. | Reports can contain machine/firmware/component details and remain restricted lab evidence; thresholds are not UAM budgets until human approval. |
| W26 | Microsoft, [`PowerRegisterSuspendResumeNotification`](https://learn.microsoft.com/en-us/windows/win32/api/powerbase/nf-powerbase-powerregistersuspendresumenotification), reviewed 31 July 2026 | Windows service/application notification primitive for suspend/resume lifecycle handling. | Notifications can be missed by crash/power loss and do not replace startup revalidation or G5 recovery. |
| W27 | Microsoft, [Microsoft Defender Antivirus exclusions overview](https://learn.microsoft.com/en-us/defender-endpoint/microsoft-defender-antivirus-exclusions-overview), updated 17 July 2026 | Every exclusion creates a protection gap; process exclusions can affect network protection and ASR inspection. | Defender guidance does not qualify UAM or another EDR. Exact product/policy/version tests are required and broad exclusions remain rejected. |
| W28 | Microsoft, [Controlled folder access overview](https://learn.microsoft.com/en-us/defender-endpoint/controlled-folder-access-overview), reviewed 31 July 2026 | Controlled Folder Access can block or allow applications and has audit/enforced behavior. | Documentation does not prove UAM installation, source read, SQLite store, update, or cleanup under an enterprise policy; exact lane evidence is required. |
| W29 | Microsoft, [.NET `HttpClient` proxy behavior](https://learn.microsoft.com/en-us/dotnet/fundamentals/networking/http/httpclient#http-proxy), reviewed 31 July 2026 | Managed proxy configuration primitives and default-proxy behavior. | User-context defaults may be inappropriate for a machine service; exact authentication, TLS, failover, privacy, and receipt behavior require the transport lane. |
| W30 | Microsoft, [WinHTTP AutoProxy functions](https://learn.microsoft.com/en-us/windows/win32/winhttp/winhttp-autoproxy-api), last updated 7 January 2021, reviewed 31 July 2026 | WPAD/PAC discovery, download, script execution, explicit PAC URL, and current-user proxy limitations in a service context. | Example code may fall back direct; UAM explicitly rejects such bypass unless a separately authorized profile proves it. PAC security/resource/availability remain unproved. |
| W31 | Microsoft, [`WINHTTP_AUTOPROXY_OPTIONS`](https://learn.microsoft.com/en-us/windows/win32/api/winhttp/ns-winhttp-winhttp_autoproxy_options) and [`WinHttpGetProxyForUrl`](https://learn.microsoft.com/en-us/windows/win32/api/winhttp/nf-winhttp-winhttpgetproxyforurl), reviewed 31 July 2026 | Auto-detect/PAC flags, authentication options, and proxy evaluation API surface. | API existence does not provide bounded execution, safe fallback, customer PAC correctness, credential policy, or UAM support. |

## 15.3 Open-source and public engineering source register

| Ref | Repository/release/commit and date reviewed | Claim supported | Limitation |
|---|---|---|---|
| W32 | Microsoft [.NET runtime `v10.0.10`](https://github.com/dotnet/runtime/tree/8f030f80c0dd2722eb2f618984e9db6784765963), commit `8f030f80c0dd2722eb2f618984e9db6784765963`; release page dated 15 July 2026; reviewed 31 July 2026 | Exact runtime source revision and active engineering/test/security posture. | Repository scale/tests do not prove UAM. Component notices, generated/native files, installed bits, and package provenance remain release evidence. |
| W33 | Microsoft [PowerToys `v0.100.2`](https://github.com/microsoft/PowerToys/releases/tag/v0.100.2), commit [`1d11b732b7ba7dbb265d1151531655fd8d83c76d`](https://github.com/microsoft/PowerToys/commit/1d11b732b7ba7dbb265d1151531655fd8d83c76d), released 26 June 2026 | Real maintained Windows project publishing x64/ARM64 user/machine installer hashes and multi-process/installer patterns. | Reference only; its updater, plug-ins, UI, elevation, action, and telemetry surfaces conflict with UAM's narrow authority. |
| W34 | GitHub [`actions/runner-images` Windows 11 ARM64 `win11-arm64/20260727.122`](https://github.com/actions/runner-images/releases/tag/win11-arm64%2F20260727.122), commit [`a261cdeaf340cf923fb371dfca4afef4f71d529e`](https://github.com/actions/runner-images/commit/a261cdeaf340cf923fb371dfca4afef4f71d529e), released 28 July 2026 | Exact ARM64 hosted-image inventory and early architecture-native build/test capability. | Public preview hosted VM; not physical ARM64, firmware, MSI/EDR, power, enterprise policy, or support proof. |
| W35 | Microsoft [CsWin32 `0.3.298`](https://github.com/microsoft/CsWin32/tree/e4a7320acd0c62f7490efd4c34421c181212dd8d), commit `e4a7320acd0c62f7490efd4c34421c181212dd8d`, reviewed 31 July 2026 | Pinned Win32 source-generation candidate and test patterns. | Generated code is supply-chain code; API allowlist, package mapping, diff, manual fallback, and UAM hostile tests are mandatory. |
| W36 | Selenium [`selenium-4.46.0`](https://github.com/SeleniumHQ/selenium/tree/selenium-4.46.0), released 11 July 2026; reviewed 31 July 2026 | Maintained cross-browser WebDriver automation for T1 browser fixtures. | Tag/package/binary mapping and driver pinning remain; automatic downloads, Grid, traces, and automation effects must be disabled/contained. |
| W37 | Microsoft [Playwright `v1.62.1`](https://github.com/microsoft/playwright/tree/v1.62.1), released 30 July 2026; reviewed 31 July 2026 | Alternative maintained browser-fixture framework. | Large Node/browser bundle, rapid cadence, downloads/traces, and different browser binaries increase evidence cost; test-only. |
| W38 | Web Platform Tests [`url` corpus](https://github.com/web-platform-tests/wpt/tree/181476aa16e8b28a07698bef3a0275fa53dd22e5/url), commit `181476aa16e8b28a07698bef3a0275fa53dd22e5`, reviewed 31 July 2026 | Independent hostile/differential URL corpus. | Web-platform expected behavior is not UAM privacy authority, resource proof, or sole oracle. |
| W39 | Azure [AVD Landing Zone Accelerator](https://github.com/Azure/avdaccelerator), mutable `main` screened 31 July 2026; no immutable revision adopted | Available official IaC/environment patterns for AVD lab construction. | No-go as evidence/dependency without pinning; deployment success does not prove UAM; public tools are not Microsoft Support-backed. |
| W40 | Azure [`RDS-Templates`](https://github.com/Azure/RDS-Templates), mutable `master` screened 31 July 2026; no immutable full commit adopted | RDS/AVD templates and scripts that may inform isolated lab setup/negative tests. | No-go as evidence/dependency without pinning and review; broad scripts/templates and as-is support posture do not fit UAM's narrow boundary. |
| W41 | Testcontainers for .NET [`4.13.0`](https://github.com/testcontainers/testcontainers-dotnet/tree/1717807affaae9b967035516ebedcd76dd7eaffb), commit `1717807affaae9b967035516ebedcd76dd7eaffb`, reviewed 31 July 2026 | Disposable server-integration resource ownership/cleanup ideas. | Container authority and Linux/server context cannot prove Windows endpoint/session/power/EDR/VDI behavior. |
| W42 | ArchUnitNET [`0.13.3`](https://github.com/TNG/ArchUnitNET/tree/b25c4f940b1d067e97092783d0ef16e4fe12d8c3), commit `b25c4f940b1d067e97092783d0ef16e4fe12d8c3`, reviewed 31 July 2026 | Readable compiled architecture-test candidate. | Cannot replace custom source/API/native/installer/SBOM/runtime mutation checks. |

## 15.4 Source-quality conclusion

1. **FACT.** Microsoft, browser-vendor, Mozilla, Citrix, and standards documentation establishes product capabilities, lifecycle, and API semantics. It does not establish the UAM composition under a claimed estate.
2. **RECOMMENDATION.** Every compatibility evidence package records the exact source URL, retrieval date, document last-update date when available, product/release/build, repository tag/commit, package/binary digest, and the UAM claim it is allowed to support.
3. **RECOMMENDATION.** Mutable `latest`, `main`, `master`, living documentation, and current release pages may open a qualification issue, but they cannot be the sole evidence anchor for a published tuple.
4. **RECOMMENDATION.** Vendor marketing, search snippets, popularity, stars, template deployment success, hosted runner availability, and synthetic benchmark speed remain non-proof.
5. **RECOMMENDATION.** If a primary source and runtime evidence disagree, UAM support follows the narrower safe runtime result while the discrepancy is investigated; documentation never overrides a failed primary invariant.

---

# 16. Confidence table for every major conclusion

| Major conclusion | Confidence | Why | Evidence that would change the conclusion or confidence |
|---|---|---|---|
| No platform may be labelled supported at research close | **High** | I02 proves only a connection path; no exact environment or UAM lane has run. The accepted reviews forbid support inference from prose. | An immutable `prompt-14-gate.json` binding an exact release/tuple, all required passing lanes, cleanup, accepted ADRs, owners, and human support publication. |
| Exact, signed, expiring compatibility allowlisting is the correct model | **High** | It directly enforces fail-closed, anti-rollback, offline, realm, release, privacy, and proof-gate invariants while Windows/browser/runtime/security facts change. | A simpler model proven by exhaustive/runtime tests to preserve every invariant and support rollback/offline operation with lower assurance and operations cost. |
| A missing, stale, ambiguous, or partially detected tuple must disable collection rather than run best-effort | **High** | Best-effort would silently cross unproved session, source, privacy, durability, update, EDR, or network boundaries. | No expected evidence should weaken this; a replacement source/topology would require an explicit accepted-baseline change proposal. |
| The narrow native x64/local-profile/Edge tuple is the best first qualification target | **Medium-High** | It is the smallest useful continuation of the accepted first slice and removes ARM64/VDI/profile-provider/third-party-security variables. | Human platform demand showing a different minimal viable estate, or prototype evidence that the proposed tuple is infeasible while another equally narrow tuple passes. |
| Windows 11 Enterprise/Education 24H2/25H2 can probably support the first tuple | **Medium** | These are current managed-client lines and fit the intended endpoint model, but edition/build/GPO/EDR/runtime evidence is absent. | Full L2/L8 passing evidence raises confidence; a G1–G5, update, resource, or cleanup failure lowers it or blocks the tuple. |
| Windows 11 26H1 should remain sentinel/test-only initially | **High** | It is hardware-scoped and not an ordinary in-place continuation from 24H2/25H2, so inheritance would overclaim hardware/architecture behavior. | Approved business demand plus exact native hardware/package/power/security/G1–G5/update/cleanup evidence. |
| LTSC and Server must be separate tuples, not inherited from Windows 11 client | **High** | Their servicing, app/browser, role, profile, security, and operations assumptions differ materially. | Exact product need and full equivalent lanes showing bounded operational cost; still separate tuple identity would remain. |
| Native self-contained architecture-specific packages are the safest initial packaging choice | **High** | They freeze runtime/native assets and make architecture/provenance/rollback explicit, matching release invariants. | Fleet/release evidence showing a framework-dependent model gives equal exact patch, anti-drift, rollback, SBOM, and support control at lower cost. |
| x64 emulation on ARM64 is not native ARM64 support | **High** | Emulation changes ABI, native dependencies, EDR, installer, performance, and power behavior and cannot prove a native package. | None should make emulation equivalent; it could become a separate explicitly qualified conditional tuple if humans require it. |
| ARM64 support is feasible only through a separate native package and physical lane | **Medium** | .NET/Windows and maintained projects show native ARM64 packaging is possible, but UAM interop/native SQLite/MSI/EDR/power behavior is unproved. | Passing L1/L2/L4/L8 on representative physical devices and exact package dependencies raises confidence; missing native dependency or containment failure blocks it. |
| VM evidence can establish the core software state machine for one image | **Medium-High** | Disposable VMs can exercise service/session/IPC/browser source/update/crash/cleanup deterministically. | Repeated hypervisor-specific divergence or inability to reproduce timing/security behavior would narrow VM claims; cross-hypervisor repeatability would raise confidence. |
| VM evidence cannot by itself establish physical power, firmware, battery, or physical ARM64 claims | **High** | These depend on hardware, firmware, drivers, battery, SoC, and power instrumentation not represented by ordinary VMs. | A rigorously validated hardware-equivalent virtualization environment could narrow the gap, but physical sentinel evidence would still be required for customer support. |
| One console or non-concurrent RDP session is a plausible initial session scope | **Medium** | It preserves one ordinary interactive session and avoids shared-profile concurrency, but G1 and Edge source behavior have not passed. | Passing cross-session/lock/disconnect/reconnect/update/cleanup campaigns raises confidence; any authority mix or duplicate source reader blocks it. |
| RDS/AVD/RemoteApp must be exact provider/session/image tuples | **High** | Broker, multi-session, image, agent, drain, network, and profile behavior create separate failure domains. | A maintained authoritative platform API/source that removes those differences could simplify some dimensions, but UAM runtime evidence remains required. |
| FSLogix/Citrix/roaming/profile-container modes cannot be grouped as “roaming profile support” | **High** | Vendor settings allow attach/detach, cache, failover, one RW/multiple RO, differential/write-back, and discarded changes. | Exact equivalence analysis and exhaustive provider-mode lanes could group a narrowly proven configuration family, never the product name alone. |
| Shared-profile acquisition cannot prove visit-origin session | **High** | The physical database/source does not contain an authoritative mapping from every visit to the simultaneous interactive session that caused it. | Only a new authoritative source that records origin under an approved privacy contract could change this. A heuristic or acquisition-session claim is insufficient. |
| Edge must be qualified by exact signed build/source capability, not major version alone | **High** | The source is an internal browser database and Edge release cadence can change schema, locking, profile, policy, and update behavior. | Longitudinal exact-build evidence could justify a bounded equivalence rule for specified patch classes, but sentinel failure must invalidate it immediately. |
| Edge Stable and optional Extended Stable are the only credible first production channels | **Medium-High** | They have managed servicing/support models; preview channels are intentionally unstable. | Human need plus full preview-channel support/operations evidence could create a test-only or conditional tuple, but not inherit production support. |
| Chrome and Firefox should remain detection/schema research until separate source contracts pass | **High** | No accepted discovery, acquisition, cursor, raw-boundary, privacy, page, or durability contract exists for them. | A separate reviewed result and complete G1–G5/privacy/release/compatibility evidence for each exact source family. |
| Sleep/hibernate support should mean pause/drain/revalidate/resume, not collection while asleep | **High** | Retained/restored state can be stale; UAM has no business need or power authority to become a Modern Standby activator. | A human-approved need plus physical power/resource/privacy evidence and Windows-compliant activator design; accepted invariants still prohibit stale work/authority. |
| Modern Standby requires a physical per-hardware-class lane | **High** | Battery drain, firmware, drivers, SoC states, wake sources, and activators are physical and platform-specific. | Representative physical fleet evidence and a bounded hardware-equivalence model may reduce matrix size, but not eliminate the physical lane. |
| Direct or explicit machine-context proxy is the smallest initial network profile | **Medium-High** | It avoids borrowing user identity, PAC execution, WPAD discovery, and silent egress bypass. | Customer demand and successful exact PAC/proxy-auth/TLS/VPN fault/custody/cleanup lanes could add conditional profiles. |
| PAC/WPAD, TLS interception, and mandatory VPN must be separate conditional tuples | **High** | They alter script execution, credentials, trust, routing, failover, destination privacy, and delivery semantics. | An approved enterprise platform service with a narrow stable machine contract could reduce implementation choices; exact customer-like evidence remains required. |
| UAM should require no broad antivirus/EDR exclusion | **High** | Broad exclusions create protection gaps and can bypass network/ASR inspection; they also hide product defects. | No evidence should justify a broad exclusion. A narrowly scoped, time-limited exact exception could be reviewed only after measured necessity and full security rerun. |
| Third-party EDR support is exact product/sensor/content/policy/release/OS configuration-family support | **High** | Product name alone hides injection, quarantine, reputation, policy, cloud, and update differences. | Vendor-supported equivalence evidence plus repeated UAM campaigns could define a bounded configuration family; every relevant change still opens a sentinel. |
| Compatibility evidence and support must expire automatically | **High** | Windows, Edge, .NET, native dependencies, EDR, and exceptions change; indefinite evidence creates stale authority. | Measured longitudinal evidence may lengthen specific windows, but cannot justify indefinite support or unknown expiry. |
| Exceptions must remain conditional, exact-tuple/realm/release bound, time-limited, and unable to waive primary invariants | **High** | Otherwise risk acceptance becomes a local enable path and silently changes product authority. | Only a formal governance replacement with equal anti-rollback, audit, expiry, narrowing, and incident controls; primary invariants remain non-waivable. |
| Bounded privacy-safe health is necessary even when it reduces support detail | **High** | Raw environment/configuration/activity can leak security or personal data and create unbounded metrics; finite states preserve honest coverage. | A proven additional categorical field that is necessary, non-sensitive, bounded, realm-safe, and passes cardinality/access review. |
| Exact resource, qualification cadence, evidence-window, cost, and staffing values remain unknown | **High** | No representative estate, event, outage, power, EDR, lab throughput, or support-cost measurements and no human budgets/SLOs exist. | Approved T3 aggregate measurement, repeated lane timing/resource evidence, staffing/cost model, and accountable human decisions. |
| Open-source projects are reference/test inputs, not compatibility proof | **High** | Their threat models, release authorities, environments, and privacy boundaries differ; no end-to-end UAM-like harness was found. | A future maintained project with the exact UAM contracts/threat model and reproducible evidence could become a dependency candidate, still subject to admission and local proof. |
| Passing Prompt 14 is not pilot or production approval | **High** | Legal purpose, fields, retention, access, support, budget, SLOs, signing, prior G1–G5, later server/capacity/deletion gates, and designated risk authority remain separate. | Only all applicable suite gates plus explicit human production authorization can change this. |

## 16.1 Confidence interpretation

- **High** means the conclusion follows directly from accepted invariants, primary platform semantics, or a clear absence of required evidence. It does not mean every implementation detail has passed.
- **Medium** means the architecture is plausible and bounded but needs the named Windows/lab measurements.
- **Low-Medium** means vendor capability exists, while UAM fitness, operations, cost, or customer-like environment evidence is materially absent.
- A confidence label never overrides a failed gate, an expired manifest, a safety hold, or a human decision boundary.

---

# Final residual risk and next stop/go gate

## What remains unsafe, uncertain, or operationally costly

**Browser and source risk.** Edge history remains a mutable internal source. A browser servicing update can change schema, lock behavior, profile discovery, synchronization, or timing. Exact-build sentinel qualification reduces but cannot eliminate this risk. Chrome and Firefox remain outside the accepted source contract.

**Windows and hardware risk.** Vendor documentation cannot prove service tokens, Scheduled Tasks, named-pipe access, per-session launch, file identity, MSI, sleep/resume, fast startup, firmware, ARM64, or cleanup under a real managed estate. Virtual machines do not prove Modern Standby, battery, firmware, OEM drivers, or physical ARM64 behavior.

**Session and profile risk.** RDS, AVD, RemoteApp, FSLogix, Citrix, roaming profiles, and same-SID concurrency can attach, detach, copy, cache, merge, make read-only, write back, discard, or fail over profile state. UAM cannot prove visit-origin session from a shared browser database. Supporting these environments is likely to be expensive because every provider/mode/image/storage/security combination is a distinct evidence and support surface.

**Security-product risk.** Defender and third-party EDR can inject into, delay, quarantine, block, reputation-check, or capture the Task Host and installer. UAM cannot prove every policy/content/cloud version, and broad exclusions are unsafe. Vendor coordination and a lab license do not equal customer support evidence.

**Network risk.** PAC/WPAD, authenticated proxies, TLS interception, VPN route changes, captive portals, certificate rotation, revocation, and offline transitions can alter authentication, destination privacy, retry, and custody behavior. Fail-closed behavior can delay delivery and increase local backlog; exact outage and resource budgets are unknown.

**Power and observability risk.** Managed memory, pagefile, crash infrastructure, EDR, hypervisor snapshots, and privileged support tooling can retain source bytes despite process-level minimization. Physical power instrumentation is costly, while diagnostic detail must remain bounded enough not to reveal users, profiles, URLs, security configuration, or high-cardinality environment facts.

**Operations risk.** Edge's faster cadence, monthly Windows servicing, .NET/native security patches, EDR content updates, image changes, and profile-provider releases can outpace the qualification team. The support matrix must shrink when owners, lab capacity, skills, licenses, or evidence cadence cannot sustain it. No budget, staffing, support hours, SLO/RPO/RTO, exception duration, deprecation notice, or commercial coverage is approved.

**Human dependency.** Required platform coverage, exceptions/deprecation, physical and enterprise lab access, EDR/vendor coordination, support ownership, budget, and production risk remain human decisions. A technically passing tuple cannot publish itself.

## Explicit next gate

The next gate is **G14-C0 — compatibility authority and first-lane readiness**. It passes only when:

1. accountable compatibility, Windows, browser, privacy, storage, release, lab, support, incident, network, and endpoint-security owner functions are assigned;
2. humans select the exact first candidate tuple, evidence-expiry policy, exception/deprecation policy, and permitted lab/EDR/network scope;
3. the six allowlisted inputs, this result, accepted ADRs, strict contracts, T1 fixtures, reference evaluator, package manifests, and placeholder-only lab scripts are bound by digest;
4. no live source, customer configuration, raw SSH material, credentials, addresses, personal data, or production activity is present; and
5. the exact Batch 01 G1 evidence required for the intended Windows image/package is available or the lane remains blocked.

After G14-C0:

- **G14-C1** runs L0/L1 contract, manifest, evaluator, packaging, architecture, redaction, and cardinality gates.
- **G14-C2** runs the first exact x64 L2 core tuple and L8 MSI lifecycle with T1 Edge data, then servicing, expiry, kill, exception, incident, and cleanup campaigns.
- Physical power/ARM64, RDS/AVD/profile, enterprise proxy/VPN, and third-party EDR each remain separate later lanes; none inherits from G14-C2.

**Stop/go at research close:**

- **GO** for pure contracts/models, immutable T1 fixtures, reference/production evaluators, native package validation, evidence tooling, and disconnected lab preparation.
- **STOP** every support label and live source operation. The first tuple becomes eligible for a support publication decision only when an immutable `prompt-14-gate.json` reports zero primary invariant failures, every required cleanup result is `PASS`, all evidence is current and exact, blocking ADRs/owners/human decisions are resolved, and an authorized signed compatibility manifest binds the same release and tuple.

Passing that gate proves only the named claim. It does not approve pilot, production, broader platform inheritance, or any prohibited use.
