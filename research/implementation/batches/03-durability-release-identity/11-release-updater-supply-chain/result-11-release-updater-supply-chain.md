# Prompt 11 result — MSI, enterprise deployment, updater, rollback, signing, TUF-style metadata, and supply chain

**Result path:** `batches/03-durability-release-identity/11-release-updater-supply-chain/result-11-release-updater-supply-chain.md`  
**Research date:** 31 July 2026  
**Decision status:** **ACCEPT THE ENTERPRISE-FIRST RELEASE ARCHITECTURE; KEEP AUTONOMOUS UPDATE DISABLED UNTIL ITS MEASURED DECISION GATE PASSES**  
**Authority boundary:** Windows installation, repair, release authorization, staged payload activation, rollback, repository metadata, signing, build provenance, and out-of-band recovery architecture; **not** patch SLA, enterprise-management coverage, signing custodians or ceremonies, installer-tool procurement, emergency authority, production risk acceptance, pilot, or production deployment  
**Predecessor authority:** accepted shared baseline and accepted Batch 01 foundation review  
**Primary proof gate:** **Unauthorized or incomplete versions never execute; every interruption leaves an operable known version; key compromise has a tested recovery path.**

## Evidence vocabulary

This result uses the required labels consistently:

- **FACT** — directly supported by an allowlisted supplied result or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from facts; the chain is stated.
- **ESTIMATE** — a numerical hypothesis with replaceable inputs.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — required evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, business, support, or production authority is required.
- **CLI EXPERIMENT** — code, lab work, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements are the proposed implementation baseline for this topic. They do not turn an **UNKNOWN**, **ESTIMATE**, or **HUMAN DECISION** into an approved production fact.

---

# 1. Executive conclusion in easy language, with confidence and residual risk

## 1.1 Conclusion

**RECOMMENDATION — keep enterprise deployment as the normal and privileged release path.** The MSI and enterprise-management system must continue to own the stable Windows service boundary, Scheduled Task/launcher boundary, protected directories, root trust material, ACLs, repair, uninstall, and out-of-band recovery. This carries forward the accepted baseline; no change proposal is needed.

An autonomous updater is **not** part of the default architecture. It becomes eligible only after representative measurements show that enterprise management, rather than offline devices or unrelated network conditions, repeatedly misses a human-approved patch-latency or coverage objective, and only after the updater itself passes the full release-security gate. Until that evidence exists, the safe state is `ENTERPRISE_ONLY`.

If autonomous update is later authorized, it must be much smaller than the product:

1. A low-privilege **Release Fetcher** may retrieve untrusted repository metadata and bytes into a non-executable staging area.
2. A minimal MSI-owned **Release Activator** running with machine authority may verify and copy already-extracted files into a protected immutable version directory. It has no network client, no general archive extractor, no arbitrary command channel, and no authority to alter the service, Scheduled Task, launcher, updater, root trust, ACL model, or product privacy ceiling.
3. A stable MSI-owned **Service Launcher** and **User Host Launcher** select a verified active version at process start. They never execute directly from staging, user-writable storage, a junction, a symbolic link, or a mutable `current` directory.
4. Every executable release needs two independent authorization checks: the target package and every shipped executable/library must match the length and SHA-256 digests authorized by signed repository metadata, and Windows code signatures must satisfy the product Authenticode policy. Either failure blocks execution.
5. Versions live side by side in immutable directories. Activation is an A/B state change, not an in-place overwrite. The previous known-good version remains available through probation and rollback.
6. A rollback is published as a **higher release sequence** that points to a previously approved digest. The client never accepts lower metadata versions merely because an operator calls the action a rollback.
7. Endpoint data remains readable by both N and N-1 during the rollback window. Destructive or one-way storage migrations are enterprise-maintenance events, not autonomous updates.
8. Repository authorization follows TUF 1.0.35 semantics: offline root authority, release/targets authority, snapshot protection against mix-and-match, short-lived timestamp freshness, threshold-capable roles, expiration, rollback protection, consistent snapshots, and sequential root rotation. UAM must publish a Protocol, Operations, Usage, and Format document. An ad hoc single-signature appcast is not an acceptable substitute. [W17–W21]

## 1.2 Decision summary

| Decision | Classification | Result |
|---|---|---|
| Privileged installation owner | **RECOMMENDATION** | MSI plus enterprise management own services, tasks, launchers, ACLs, root trust, bootstrap upgrades, repair, uninstall, and out-of-band recovery. |
| Default update mode | **RECOMMENDATION** | `ENTERPRISE_ONLY`; autonomous update remains compiled/administratively disabled until the decision gate passes. |
| Optional updater shape | **RECOMMENDATION** | Low-privilege network fetcher plus minimal offline privileged activator; neither can modify the MSI-owned bootstrap. |
| Payload layout | **RECOMMENDATION** | Immutable version directories under protected Program Files; non-executable staging under ProgramData; no in-place overwrite or reparse-point activation. |
| Release authorization | **RECOMMENDATION** | TUF-conformant repository workflow plus exact length/hash plus Authenticode; same signed digest promoted through rings. |
| Rollback | **RECOMMENDATION** | A/B activation; retain previous; automatic rollback on bounded local health failure; emergency downgrade is a new higher release sequence. |
| Data compatibility | **RECOMMENDATION** | N/N-1 bidirectional read compatibility through the rollback window; incompatible schema epoch requires enterprise maintenance. |
| Key compromise | **RECOMMENDATION** | Role-specific rotation/revocation; root-threshold compromise is out-of-band MSI recovery, not an in-band update. |
| Build supply chain | **RECOMMENDATION** | Two challenged clean unsigned builds, final-file manifest, reconciled SBOM, verified provenance, isolated digest-bound signing, no rebuild per ring. |
| Production enablement | **HUMAN DECISION** | Patch SLA, management coverage, key custodians/ceremonies, installer tooling procurement, emergency authority, and production approval remain unapproved. |

## 1.3 Why this is the smallest safe design

**FACT.** The accepted baseline already assigns the stable privileged boundary to MSI and enterprise deployment and makes autonomous update optional, minimal, repository-authorized, rollback-safe, and separately justified. It also requires unauthorized, incomplete, stale, frozen, or downgraded releases never to execute. [I01–I03]

**FACT.** Windows Installer provides transactional rollback machinery for MSI-managed changes, repair modes through `msiexec`, declarative service controls, and rollback custom actions for changes that cannot be expressed in tables. Microsoft also warns that disabled rollback and `AlwaysInstallElevated` weaken security. [W01–W08]

**FACT.** TUF separates root, targets, snapshot, and timestamp authority, supports thresholds, binds target lengths and hashes, prevents rollback/freeze/mix-and-match attacks when its workflow is correctly implemented, and explicitly treats root-threshold compromise as an out-of-band recovery problem. [W17–W21]

**INFERENCE.** Combining the accepted MSI ownership boundary with TUF’s repository-compromise model gives a simpler separation than a monolithic SYSTEM updater: enterprise management owns rare privileged topology changes, while an optional updater can only install a repository-authorized product payload into a pre-created constrained location. A compromise in the network fetcher or online timestamp key can deny or delay update but cannot independently authorize arbitrary executable bytes.

## 1.4 Confidence

- **High confidence** in the enterprise-first ownership model, immutable side-by-side payloads, dual repository/Authenticode checks, higher-sequence rollback, and separate signing authority. These directly reinforce accepted invariants and established Windows/TUF capabilities.
- **Medium confidence** in the exact split between Release Fetcher and Release Activator, the A/B activation record implementation, and the N/N-1 storage contract. They are strongly reasoned designs but require Windows crash, reparse, ACL, EDR, storage, and migration experiments.
- **Low confidence** that an autonomous updater is needed at all. No patch-latency distribution, enterprise-management coverage, offline-device distribution, proxy/VPN behavior, or approved patch SLA was supplied.

## 1.5 Residual risk at executive level

Even after all proposed tests pass, the design cannot prove that every enterprise policy, endpoint security product, filesystem filter, disk failure, certificate-validation environment, clock condition, or operator action will behave safely. It cannot make a root-threshold compromise recoverable in-band, guarantee secure deletion on modern storage, or guarantee N-1 compatibility without testing each actual migration. Authenticode proves signer/payload integrity under its policy; it does not prove the code is benign. TUF constrains repository attacks; it does not prevent a threshold-authorized malicious release. Build provenance records how an artifact was produced; it does not prove source correctness or SBOM completeness.

The containment is deliberate: keep the privileged bootstrap rare and MSI-owned, keep prior versions, verify every byte before execution, use independent release and code-signing authorities, fail closed for new activation while continuing the last known-good version, and retain an enterprise out-of-band repair path.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 Scope

This result covers:

- MSI installation, upgrade, repair, rollback, uninstall, and enterprise detection;
- the ownership boundary between enterprise deployment and an optional autonomous updater;
- stable launcher and bootstrap responsibilities;
- immutable version directories, staging, file-copy hardening, A/B activation, health proof, bad-version suppression, and emergency downgrade;
- TUF-conformant repository metadata and UAM custom target metadata;
- package length/hash verification and Authenticode policy;
- root/release/snapshot/timestamp key purposes, rotation, revocation, and compromise recovery;
- N/N-1 endpoint-data compatibility during rollback;
- build reproducibility, SBOM, provenance, isolated signing, ring promotion, kill switches, incident response, and out-of-band repair;
- privacy-safe observability, realm/channel isolation, error taxonomy, support ownership, cost/licensing/skills, and architecture fitness functions;
- CLI and disposable-Windows-VM experiments using only synthetic/test-signed artifacts.

## 2.2 Non-goals

This result does not:

- approve an autonomous updater;
- choose a production patch SLA or enterprise-management coverage target;
- assign real people as key custodians, incident commanders, release approvers, or emergency authorities;
- choose a commercial installer tool or approve its license/EULA;
- approve a production code-signing certificate, HSM/KMS, threshold, algorithm, certificate chain policy, or signing ceremony;
- redesign the Coordinator/User Host/Task Host runtime, endpoint outbox, server ingestion, identity, browser acquisition, or privacy transformation;
- approve live data, production credentials, production signing, a pilot, or production deployment;
- claim that MSI alone provides safe application-level activation or that TUF alone provides Windows code-signing trust;
- require interactive endpoint UI. Managed releases should normally be silent; any later administrator UI is a separate control-plane design.

## 2.3 Allowlisted project evidence and presence record

**FACT.** All five allowlisted project files were present. The accepted predecessor appears locally as `batch-01-review-result(3).md`; its title and declared result path identify it as the allowlisted `result-review-01-foundations.md`. No other Project file was opened, searched, summarized, quoted, or used.

| Ref | Allowlisted file | Reviewed attachment SHA-256 | Use and limitation |
|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md` | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Accepted process, privacy, durability, realm, release, and restore invariants; condensed baseline, not production approval. |
| I02 | `03-sanitized-windows-lab-capability.md` | `8da73d913e7f1b01d943e4c8b0ed7bb2722571ff6a3a20cef0b8f47738a4658f` | Proves only that a placeholder-based Windows lab connection path exists; proves no OS, MSI, runtime, privilege, EDR, or update behavior. |
| I03 | `05-decisions-contradictions-and-gates.md` | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | Accepted decisions and proof-gate order; release/update authorization and rollback is gate 7 after G0–G5. |
| I04 | `06-research-evidence-rules.md` | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | Evidence labels, primary-source preference, human-authority boundary, and change-proposal discipline. |
| I05 | `result-review-01-foundations.md` (local `batch-01-review-result(3).md`) | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | Accepted repository, build, contract, Windows-lab, reproducibility, SBOM/provenance, separate signing, and same-digest-promotion foundations. |

## 2.4 Accepted inputs carried forward

The following are **FACT** from the allowlisted accepted evidence and remain unchanged:

1. Windows endpoints use a low-privilege machine Coordinator, an ordinary-token User Host in each eligible interactive session, and restricted short-lived Task Hosts.
2. C#/.NET is the default implementation family; exact patch versions remain execution-time lifecycle inputs.
3. The product privacy ceiling is release-authorized and tenant policy can only narrow it.
4. Endpoint storage contains minimized typed data; release work must not introduce central database credentials, SQL submission, or raw activity into release diagnostics.
5. MSI and enterprise deployment own the stable privileged boundary.
6. An autonomous updater is optional, minimal, repository-authorized, rollback-safe, and separately justified.
7. An unauthorized, incomplete, stale, frozen, or downgraded release never executes.
8. Build inputs are exact and locked; untrusted code receives no signing/deployment authority.
9. Real disposable/reverted Windows VMs are mandatory for MSI, service, task, ACL, certificate, crash, and cleanup claims.
10. Canonical unsigned payloads require challenged clean-build comparison; unexplained differences stop release.
11. SBOM and provenance must be reconciled with the final file manifest and lock graph.
12. Signing is a separate digest-bound authority; promotion moves the same signed digest through rings without rebuilding.
13. Exact crypto algorithms, quorum, KMS/HSM, installer tool, release limits, ring sizes, version windows, and operational budgets remain provisional or human-owned.
14. The ordered release/update proof gate cannot bypass G0–G5 prerequisites for a production-shaped endpoint.

No accepted-baseline conflict or change proposal is raised by this result.

## 2.5 Assumptions

| Assumption | Why it is used | Required confirmation |
|---|---|---|
| **ASSUMPTION.** Payload binaries are small enough that full manifest/hash verification at activation and launcher start is operationally acceptable. | Avoids unsafe mutable-cache shortcuts. | Measure on representative signed payloads and endpoint storage. |
| **ASSUMPTION.** Program Files and ProgramData ACLs can be installed so ordinary users cannot create, replace, hard-link, or reparse product-owned protected objects. | Underpins immutable version and stable launcher model. | Effective-access, hard-link, reparse, EDR, and filesystem tests per supported environment. |
| **ASSUMPTION.** The product can keep N-1 payload bytes through N probation without violating disk policy. | Enables local A/B rollback. | Human disk budget plus outage/version-size measurements. |
| **ASSUMPTION.** A low-privilege fetcher can use enterprise proxy/VPN policy without machine-wide credential exposure. | Allows network retrieval outside SYSTEM. | Device identity/network prompt and exact proxy/VPN lab evidence. |
| **ASSUMPTION.** The endpoint data model can be constrained to additive/expand-only migrations during the rollback window. | Enables N/N-1 rollback. | G5/database migration prototype and per-release compatibility tests. |
| **ASSUMPTION.** Enterprise deployment can run a post-MSI detection/health command and remediate failed installations. | Separates MSI transaction from product A/B activation. | Tool-specific enterprise-management prototype; no product chosen here. |

## 2.6 Unknowns

- **UNKNOWN.** Patch SLA, ring deadlines, percentage/coverage objective, and management-attributable deployment-latency distribution.
- **UNKNOWN.** Which endpoints are fully managed, partly managed, long-offline, internet-only, VDI/non-persistent, behind proxy/VPN, or blocked from a product repository.
- **UNKNOWN.** Supported Windows editions/builds, filesystems, EDR/CFA policies, WDAC/AppLocker posture, certificate-revocation connectivity, and trusted-clock quality.
- **UNKNOWN.** Exact MSI authoring tool, bootstrap packaging pattern, product/upgrade codes, component GUID strategy, custom-action need, and procurement/license constraints.
- **UNKNOWN.** Exact TUF client implementation in C#, exact algorithms/key types, threshold values, expiries, root-key custody, timestamp service, and recovery ceremony.
- **UNKNOWN.** Code-signing CA profile, timestamp service, revocation policy while offline, and certificate rollover overlap.
- **UNKNOWN.** Production payload size, file count, disk budget, staging limits, download retry policy, health probation, and bad-version retention.
- **UNKNOWN.** Exact endpoint schema migration sequence and whether every candidate can meet N/N-1 compatibility.
- **UNKNOWN.** Secure machine-key storage need for local state authenticity; repository revalidation remains authoritative regardless.
- **UNKNOWN.** Support/on-call competence and cost for a TUF repository, signing service, updater qualification, and emergency response.

## 2.7 Conservative defaults while unknowns remain

- Autonomous update: **disabled**.
- New release activation with uncertain time, expired metadata, invalid chain, unsupported schema, missing health proof, or storage incompatibility: **disabled; continue the current verified release**.
- Bootstrap update: **enterprise MSI only**.
- Destructive migration: **enterprise maintenance only**.
- Differential/delta package: **disabled**.
- Disk cleanup of previous release: retain at least the current and previous known-good through an approved rollback window; exact duration is a **HUMAN DECISION**.
- Production key material: **none in development or ordinary CI**.
- Lab signing: isolated test-only keys/certificates generated in the disposable lab and removed during cleanup.
- Uninstall data disposition: no production choice is implied; T1 lab runs delete product-owned test data and prove cleanup.

---

# 3. Recommended design with exact component responsibilities and trust boundaries

## 3.1 Release and trust-plane architecture

```text
                           HUMAN / ENTERPRISE AUTHORITY
                                      |
                    patch SLA, rings, emergency authority
                                      |
       +------------------------------+------------------------------+
       |                                                             |
       v                                                             v
Enterprise deployment system                                Release repository
(MSI install/repair/uninstall,                               (untrusted transport/
 bootstrap upgrade, OOB repair)                             mirror by client model)
       |                                                             |
       | signed MSI / repair command                                 |
       v                                                             v
+---------------------------+                     +--------------------------------+
| MSI-owned stable boundary |                     | TUF metadata roles             |
|                           |                     | root / targets / snapshot /     |
| - Service Launcher        |                     | timestamp / optional recovery  |
| - User Host Launcher      |                     +--------------------------------+
| - optional Activator      |                                      |
| - service/task/ACLs       |                                      |
| - trusted root set        |                                      |
| - bootstrap epoch         |                                      |
+-------------+-------------+                                      |
              |                                                    |
              | fixed local protocol                               |
              v                                                    v
+---------------------------+      HTTPS       +---------------------------+
| Low-privilege Fetcher     |<---------------->| metadata and target bytes |
| - no machine mutation     |                  | exact length/hash         |
| - bounded download        |                  +---------------------------+
| - untrusted staging only  |
+-------------+-------------+
              |
              | verified request + opened staged-file handles
              v
+---------------------------+
| MSI-owned Activator       |
| - no network              |
| - no general archive      |
| - verifies metadata chain |
| - hashes/lengths/signing  |
| - safe copy to CREATE_NEW |
| - writes A/B state        |
+-------------+-------------+
              |
              v
%ProgramFiles%\UAM\versions\<release-id>\   (immutable, protected, no reparse)
              |
              | stable launcher independently re-verifies
              v
      current candidate process
              |
              | local health proof, no live-data dependency
              v
  probation -> healthy/current OR automatic previous-version rollback
```

**RECOMMENDATION.** The network repository is treated as untrusted even when TLS is valid. TLS provides transport confidentiality/integrity and server authentication; TUF metadata and exact target digests provide release authorization. The endpoint never grants repository content authority merely because it came from an expected host.

## 3.2 Ownership matrix

| Component | Owner boundary | Required responsibilities | Explicit prohibitions |
|---|---|---|---|
| Enterprise deployment definition | Enterprise endpoint-management function | install signed MSI, select ring, detect healthy target, invoke repair/uninstall/OOB recovery, record management timings | must not rebuild/re-sign per realm/ring; must not bypass release verification; must not silently disable MSI rollback |
| MSI package | Installer/release engineering under separate signing authority | install/upgrade/repair stable launchers, optional activator, service/task, ACLs, root/bootstrap trust, baseline payload, uninstall manifest | no production activity; no tenant executable policy; no arbitrary script channel; no general online updater privilege |
| Service Launcher | MSI-owned machine bootstrap | validate bootstrap self, load valid activation record, revalidate target metadata/manifest/file hashes/Authenti­code, start Coordinator payload with safe DLL search, observe process/health | no network; no source collection; no arbitrary executable/path; no activation of staging; no trust in filename/version alone |
| User Host Launcher | MSI-owned user-session bootstrap | validate own release, select same authorized payload generation, start ordinary-token User Host in exact session | no elevation, update download, source read, machine mutation, or independent version selection |
| Release Fetcher | Optional, low privilege | obtain metadata/target bytes; enforce HTTP, size, timeout, retry, and staging limits; parse under untrusted-process limits; request activation by exact digest | no Program Files write; no service/task/ACL/root change; no SYSTEM; no code execution from staging; no arbitrary destination |
| Release Activator | Optional, MSI-owned, machine authority | independently verify trusted root/workflow, target custom metadata, length/hash, file manifest, Authenticode, compatibility, filesystem identities; copy safely; update A/B activation state | no network; no browser/UI; no arbitrary archive/script/command; no bootstrap/updater self-update; no service/task/ACL/root replacement except through MSI |
| Release Verifier library | Built into each stable launcher and activator | strict metadata/manifest parsing, version/expiry/threshold checks, hashes, target authorization, Authenticode policy, path/file checks | no network callback in verification; no dynamic algorithm/plugin loading; no permissive unknown fields at authority boundary |
| Repository publisher | Trusted release lane, not ordinary CI | publish same signed target digest, TUF metadata, bad-version/recovery metadata, immutable evidence; enforce role/key separation | cannot produce artifact bytes; cannot alone code-sign; cannot overwrite immutable published version names |
| Build lane | Trusted but not signing authority | restore locked inputs, two challenged clean builds, tests, final unsigned manifest, SBOM, provenance, evidence | no production signing keys; no deployment/repository promotion credential; no mutable dependency/action/tag |
| Signing lane | Separate digest-bound authority | sign approved PE/DLL/MSI artifacts and timestamp; emit signing attestation and audit | must not compile, modify source, choose release semantics, or sign an unapproved digest |
| Release approval function | Human/governed control | approve exact target digest, compatibility, release sequence, ring eligibility, emergency rollback | cannot approve outside product privacy ceiling; exact authority remains a **HUMAN DECISION** |
| Support/incident functions | Assigned before enablement | monitor finite health, execute runbooks, collect sanitized evidence, freeze/recover/re-enable under authority | no request for raw activity, profiles, credentials, SSH material, or unbounded memory dumps |

## 3.3 Stable privileged boundary

**RECOMMENDATION.** The following objects are the stable privileged boundary and can change only through a signed MSI or an independently trusted out-of-band enterprise repair package:

- Windows service registration and its stable launcher path;
- Scheduled Task/group-task registration and stable User Host launcher path;
- stable Service Launcher, User Host Launcher, and optional Release Activator binaries;
- product-owned protected root directories and their explicit ACLs;
- the bootstrap trusted-root metadata and bootstrap epoch;
- optional local IPC endpoint definitions between fetcher, activator, and launcher;
- uninstaller/repair registration;
- product event-provider manifests or firewall rules, if any are approved;
- the allowlist of release-verification algorithms and minimum metadata profile.

The autonomous updater MUST NOT update itself, the stable launchers, service registration, task registration, root trust bootstrap, product ACL policy, or privilege configuration. That rule prevents an ordinary release target from turning a narrow payload update into a durable privilege-boundary mutation.

## 3.4 Endpoint directory and ACL layout

The exact SDDL remains a **CLI EXPERIMENT**, but the logical layout is normative:

```text
%ProgramFiles%\UAM\
  bootstrap\
    Uam.ServiceLauncher.exe
    Uam.UserHostLauncher.exe
    Uam.ReleaseActivator.exe          # only if autonomous updater is authorized
    bootstrap.manifest.json
    bootstrap-root.json
  versions\
    <release-id-a>\
      release.manifest.json
      bin\...
      sbom\...
      evidence\release-summary.json
    <release-id-b>\
      ...

%ProgramData%\UAM\
  release-state\
    activation-slot-a.json
    activation-slot-b.json
    suppression-slot-a.json
    suppression-slot-b.json
    trusted-metadata\...
    release-audit\...
  release-staging\
    <attempt-id>\
      package.download
      extracted\...
      staging.manifest.json
  health\
    bounded value-free records
```

Normative rules:

1. Ordinary users and ordinary product payload processes MUST NOT create, replace, rename, delete, hard-link, reparse, or change ACLs beneath `bootstrap`, `versions`, or `release-state`.
2. `release-staging` is product-owned but treated as untrusted and non-executable. It MUST NOT be in `PATH`, DLL search paths, service image paths, or task actions.
3. Every traversed component from the protected root to a file MUST be opened and checked for reparse behavior. `FILE_FLAG_OPEN_REPARSE_POINT`, final-path-by-handle, file identity, link/stream inspection, and post-operation rechecks are candidate mechanisms requiring lab proof. [W11–W16]
4. Version directories are created with `CREATE_NEW` semantics, never merged with an existing directory, and become immutable before activation.
5. Version directory names are opaque release IDs or content-derived safe names; the displayed semantic version is not trusted as identity.
6. No `current` symlink, junction, user-writable shortcut, or registry path selects executable content. The stable launcher reads the protected A/B activation state and constructs a path only under the verified versions root.
7. Alternate data streams and unexpected hard links are rejected. Every final file must be a regular file with exactly the expected relative path, length, digest, and allowed link/stream state.
8. Staging and final directories reside on the expected local volume unless a separately tested same-volume copy/rename contract says otherwise. Network and removable destinations are unsupported.
9. File and directory ACLs are explicit at protected boundaries; reliance on uncontrolled inherited ACEs is not sufficient. ACL inheritance and effective access must be captured after install, upgrade, repair, and enterprise policy refresh. [W16]

## 3.5 Safe package materialization

**RECOMMENDATION.** Do not parse a general archive under SYSTEM. The safer flow is:

1. The low-privilege fetcher downloads one bounded package to a newly created attempt directory.
2. It validates the TUF chain enough to reject obviously unauthorized content, enforces target length/hash before extraction, and extracts with a strict allowlist: relative paths only, no `..`, no absolute/device/UNC path, no reparse entry, no alternate stream syntax, no duplicate or case-colliding path, bounded file count/length/ratio/depth, and no executable launch.
3. It writes a canonical staging manifest with exact relative paths, file lengths, hashes, modes/attributes, and package/metadata digests.
4. The activator independently repeats the complete TUF and package verification; it does not trust the fetcher’s verdict.
5. For each staged file, the activator opens the source without following a reparse point, obtains final path and file identity, checks regular-file/link/stream/attribute rules, hashes and measures from the opened handle, and verifies Authenticode where required.
6. It creates the final directory and each destination file with exclusive `CREATE_NEW`, copies from the validated source handle, flushes the destination, reopens it, and rechecks length/hash/file identity/signature in the protected destination.
7. It rejects any extra staged or final file, unexpected stream, duplicate canonical path, case collision, hard-link anomaly, path escape, or source identity change.
8. Only after the entire final directory passes does it write a sealed release record and make the version eligible for activation.
9. Staging is deleted after success or bounded quarantine. Failure cleanup never recursively follows reparse points and deletes only manifest-authenticated product-owned attempt paths.

**INFERENCE.** Verifying the source handle and then independently re-verifying the protected destination prevents a same-user staging race from becoming a SYSTEM write primitive. Keeping archive parsing outside the privileged process limits the consequences of parser defects. It does not protect against a kernel, filesystem, or SYSTEM-level attacker; that remains outside this narrow updater boundary.

## 3.6 A/B activation record

A single mutable `current.json` is avoidable. Use two fixed protected slots:

- each slot contains a complete, checksummed activation generation;
- a new generation is written to the older/invalid slot with `CREATE_ALWAYS` only in the protected directory, then flushed;
- the launcher reads both slots, strictly validates both, and chooses the highest complete generation whose referenced release independently verifies;
- a torn or corrupt newest slot leaves the older valid slot usable;
- a generation never decreases;
- local state cannot authorize a release absent valid repository metadata and file verification.

The activation state records `current`, `previous`, `candidate`, probation status, compatibility epoch, metadata versions/digests, and the last transition. It contains no URL, user/session identity, realm identity, source activity, or arbitrary command.

## 3.7 Stable launcher execution rules

Before creating a product payload process, each stable launcher MUST:

1. verify its own MSI-owned bootstrap manifest and Authenticode status or enter `BOOTSTRAP_REPAIR_REQUIRED`;
2. take a shared release-selection lock and read both activation slots;
3. select the highest complete, non-suppressed state compatible with its bootstrap epoch;
4. validate cached trusted TUF metadata and the exact target custom metadata for the selected release;
5. validate release manifest schema, package digest/length, every executable/library/config file digest and length, forbidden-extra-file rule, and required Authenticode policy;
6. validate final paths, no reparse traversal, file identities, ACL expectations, and that no selected file is in a user-writable or staging location;
7. validate storage-format compatibility before letting a writer start;
8. create the payload process from the protected path with a fixed argument contract, safe DLL-search configuration, explicit inherited handles, and the existing G1 process/session policy;
9. bind the launched process identity and health channel to the selected release digest and activation generation;
10. refuse fallback to an arbitrary directory. It may choose only the recorded previous known-good release or the MSI baseline when those independently verify.

Full hashing at each process start is the conservative initial profile. A future verified-cache optimization requires its own ADR and must remain safe against file replacement, hard-link/reparse changes, ACL drift, servicing, and reboot.

## 3.8 Optional Release Fetcher

The Release Fetcher, if authorized, SHOULD run as the low-privilege Coordinator identity or a still narrower service identity, subject to G1’s privilege findings. Its responsibilities are:

- fetch only from a release-owned repository/mirror allowlist selected by protected configuration;
- use authenticated HTTPS and enterprise proxy behavior without accepting repository bytes as trusted merely because TLS succeeded;
- enforce separate hard caps for metadata, target, redirect count, decompressed bytes, file count, total disk use, elapsed time, retry count, and concurrent attempts;
- store no endpoint activity or central credentials;
- never log repository URL query strings, proxy credentials, response bodies, signatures, or raw metadata extensions;
- persist only finite state and digests needed for resumable, auditable update attempts;
- request activation by package digest, target path ID, metadata-version tuple, and attempt ID through a strict local protocol;
- stop on an enterprise freeze, signed emergency narrowing, repository metadata expiry, uncertain clock, disk-pressure stop, or bad-version suppression.

The exact use of device PKI, proxy credentials, VPN, and machine identity belongs to the parallel identity/network prompt and remains **UNKNOWN** here.

## 3.9 Minimal Release Activator

The activator SHOULD be a demand-start MSI-owned service or otherwise constrained machine process. It MUST:

- expose only a fixed local operation set: `VerifyAndStage`, `Activate`, `Rollback`, `CleanupAttempt`, `VerifyInstalled`, and `ReportState`;
- derive caller identity from the local IPC boundary; payload claims are not authority;
- accept only opaque attempt IDs and exact digests, never arbitrary paths, URLs, command lines, registry keys, service names, task names, SDDL, scripts, or MSI properties;
- perform no network operation and load no plug-in;
- parse only strict bounded metadata/manifests under a closed schema;
- take one global exclusive release-mutation lock also honored by MSI repair helpers;
- refuse to run while Windows Installer owns the product transaction unless the operation is an explicitly designed MSI helper phase;
- never update `bootstrap`, service/task configuration, root trust bootstrap, or itself;
- leave current known-good activation unchanged until the new version is fully materialized and verified;
- write durable audit evidence before a privileged state mutation is treated as successful, consistent with the accepted audit invariant;
- make cleanup idempotent and manifest-scoped.

## 3.10 MSI responsibilities

The MSI MUST own:

- ProductCode/UpgradeCode and component identity strategy;
- install scope, prerequisites, launchers, optional activator, service/task definitions, protected ACL roots, bootstrap root metadata, baseline version, repair/uninstall metadata, and enterprise detection helper;
- rollback-enabled transaction behavior;
- signed package and cabinet/media integrity;
- custom actions only where a declarative MSI table cannot safely perform the operation;
- paired rollback custom actions for every deferred custom action that changes system state directly;
- a quiet/silent enterprise mode with stable exit codes and logs that contain no activity or secret material.

The MSI MUST NOT:

- enable `AlwaysInstallElevated` or require it;
- set `DISABLEROLLBACK`/policy as an installation convenience;
- execute user-controlled values as SYSTEM;
- download release bytes from a custom action;
- run PowerShell, a script interpreter, or a general executable command assembled from MSI properties;
- switch the product payload to a candidate inside a rollback-unsafe custom action;
- delete unknown user/profile paths on uninstall;
- store production signing keys or repository credentials;
- infer successful product health solely from MSI exit code 0.

**RECOMMENDATION.** Keep MSI transaction and product activation as two composable transactions. MSI installs or repairs the stable boundary and baseline/candidate payload. After `msiexec` succeeds, the enterprise deployment definition invokes the same A/B activation/health protocol used by any optional updater. Enterprise detection is `healthy target digest/sequence`, not merely “MSI product is installed.” A failed activation leaves the prior verified payload selected and makes enterprise deployment report failure/remediation-required.

## 3.11 Configuration ownership, flags, and kill switches

| Control | Authority | May do | Must not do |
|---|---|---|---|
| Product release ceiling | Signed product/release authority | enumerate supported bootstrap epochs, metadata profile, capabilities, storage epochs, destinations, update modes | tenant cannot broaden or add executable logic |
| Enterprise update mode | enterprise management | disable autonomous update; select ring/channel; freeze version; require MSI-only | cannot authorize a digest absent product/repository authorization |
| Tenant narrowing | existing signed policy plane | disable updater or feature; narrow release eligibility where representable | cannot introduce repository URL, signer, executable path, or algorithm |
| Repository metadata | TUF roles | authorize exact target bytes and custom release constraints; revoke/delegate within role scope | cannot alter MSI bootstrap privilege boundary |
| Local safety | launcher/activator | suppress bad version; enter SafetyHold; preserve previous | cannot self-reenable after a security-significant hold without approved recovery |
| Emergency narrowing | assigned emergency authority | stop new activation, disable a release/digest/capability, force higher-sequence known-good target | cannot lower metadata sequence or silently bypass evidence |

Minimum kill switches:

- `AUTONOMOUS_UPDATE_DISABLED` — prevents fetch/activation; enterprise MSI remains available.
- `RELEASE_SEQUENCE_BLOCKED` — blocks one or more exact release sequences/digests.
- `BOOTSTRAP_EPOCH_BLOCKED` — prevents payload execution under an unsafe bootstrap; requires enterprise repair.
- `ACTIVATION_GLOBAL_HOLD` — no new activation; current verified version may continue.
- `PAYLOAD_EXECUTION_HOLD` — stop/disable affected payload when continued execution is unsafe; use only under approved emergency authority.
- `CAPABILITY_DISABLED` — narrows product behavior without changing release bytes, through the accepted privacy/policy plane.

Every switch is fail-closed, versioned, auditable, and non-broadening. A local endpoint cannot remove a signed or enterprise hold on its own.

## 3.12 Key hierarchy

```text
Independent enterprise/OOB trust
  └─ signs recovery MSI / bootstrap replacement

TUF root role (offline, threshold-capable)
  ├─ authorizes targets/release keys
  ├─ authorizes snapshot key(s)
  ├─ authorizes timestamp key(s)
  └─ optionally authorizes constrained recovery delegated role

Targets/release role (offline or tightly controlled signing)
  └─ authorizes exact package hashes/lengths and UAM release metadata

Snapshot role
  └─ binds exact targets/delegated metadata versions/hashes/lengths

Timestamp role (online, shortest authority)
  └─ binds latest snapshot version/hash/length and freshness

Code-signing authority (separate from TUF keys)
  └─ Authenticode-signs PE/DLL/MSI and obtains trusted timestamp

Build-provenance/attestation authority (separate purpose)
  └─ attests build inputs, builder identity, subject digest
```

Normative separation:

1. The online timestamp key cannot authorize a target file.
2. Snapshot authority cannot authorize arbitrary package content absent targets metadata.
3. Targets/release authority cannot alter root keys or the MSI-owned bootstrap.
4. Code-signing authority cannot choose repository release sequence or ring by itself.
5. CI has none of the production private keys above.
6. A provenance signature is not a release authorization signature.
7. The same key/certificate MUST NOT serve multiple purposes merely for convenience.
8. Exact algorithms, threshold `M-of-N`, custodians, hardware, expiry, and ceremony are **HUMAN DECISIONS**. The lab SHOULD use independent test keys and at least a multi-key root threshold so recovery behavior is exercised; that is not a production choice.

## 3.13 Build, signing, packaging, and promotion chain

```text
locked source + dependencies
  -> clean build A (unsigned payload)
  -> clean build B (unsigned payload)
  -> R2 byte/file manifest comparison
  -> tests + architecture/security/privacy gates
  -> SBOM candidates + independent final-file reconciliation
  -> build provenance subject = canonical unsigned payload digest
  -> quarantine
  -> digest-authorized isolated code signing
  -> final signed-file manifest
  -> MSI/package creation from exact signed inputs
  -> MSI Authenticode signing
  -> package hash/length + signing attestation
  -> targets metadata approval/signing
  -> snapshot and timestamp publication
  -> same target digest promoted through rings
```

**RECOMMENDATION.** Reproducibility applies first to canonical unsigned payloads. Authenticode signatures/timestamps are expected to change bytes. The signing lane must therefore emit a signed-output manifest and attestation linking approved unsigned input digests to final signed output digests. No environment or ring rebuilds the artifact.

The SBOM is generated against the final shipped file tree and reconciled against:

- final file manifest;
- NuGet/tool/native dependency lock graphs;
- generated files and embedded runtimes;
- installer content/cabinet tables;
- third-party notices and license decisions.

A zero-exit SBOM tool run is not proof of completeness. The predecessor review already requires independent reconciliation. [I05]

## 3.14 Realm, channel, and audience isolation

Release package bytes SHOULD be product-global unless a separately approved requirement demands realm-specific binaries. Realm/channel/ring assignment is authenticated control-plane context, not an untrusted payload field.

If separate repositories or delegated target paths exist:

- each repository has an independently pinned root; TUF does not mix trust between repositories;
- target custom metadata binds exact product, bootstrap epoch, architecture, channel/audience, and storage compatibility;
- the endpoint derives realm/installation from authenticated registration, never from package claims;
- a tenant can narrow eligibility but cannot make a package executable if product/repository authorization is absent;
- caches are keyed by repository root identity, audience/channel, target path, metadata-version tuple, and digest;
- a wrong-realm or wrong-channel response is rejected before activation;
- package URLs, realm IDs, tenant names, and endpoint IDs are not metric labels or ordinary logs.

## 3.15 Privacy-safe observability, data quality, and accessibility

Release telemetry MUST contain only finite operational evidence. Candidate dimensions are:

```text
component
phase
outcome_family
error_family
ring_class
bootstrap_epoch_major
release_compatibility_family
update_mode
```

Forbidden labels/details include user, SID, session, realm/tenant, installation/device ID, source/activity data, URL, filesystem path, repository query string, proxy identity, certificate private material, arbitrary exception text, exact hash as an unbounded metric label, and exact version as an unbounded high-cardinality label. Exact digests/versions belong in bounded access-controlled evidence records.

Required timestamps are separate and semantically named: `releaseAuthorizedAt`, `enterpriseAvailableAt`, `endpointEligibleOnlineAt`, `downloadStartedAt`, `materializedAt`, `activationStartedAt`, `healthyAt`, and `rollbackCompletedAt`. Missing values carry a finite reason; they are not silently imputed. This separation is necessary to distinguish management latency from device-offline or repository-unreachable time.

Endpoint update must not require a visual prompt. Any later central release/status interface SHOULD expose textual state, stable reason codes, keyboard-operable controls, screen-reader labels, non-color-only severity, and downloadable structured evidence. Accessibility requirements do not justify an endpoint UI or broader update authority.

## 3.16 Cost, licensing, skills, and operations

| Area | Enterprise-only cost | Additional cost if updater is enabled |
|---|---|---|
| Engineering | MSI, enterprise packaging, launch/verification, rollback tests | TUF client/repository profile, fetcher, activator, secure filesystem copy, root rotation, offline/clock handling, updater qualification |
| Operations | enterprise ring/package operations and repair | repository availability, metadata expiry, signing rotations, updater monitoring, bad-version suppression, on-call incident response |
| Security | code signing, build isolation, enterprise controls | TUF role/key separation, updater attack surface, repository incident drills, clock/freeze analysis |
| Skills | Windows Installer, endpoint management, Authenticode | TUF protocol, Windows reparse/ACL/TOCTOU, cryptographic operations, supply-chain attestations |
| Licensing/procurement | selected MSI tool and signing service | potentially HSM/KMS, repository service, additional support tooling; OSS licenses/EULAs still require review |
| Endpoint resources | MSI cache and current payload | staging plus at least current/previous/candidate, metadata cache, verification CPU/disk I/O |

**INFERENCE.** Unless measured patch-latency benefit is material, the autonomous updater adds a permanent high-consequence security and operations subsystem without proving a business benefit. That is why evidence, not convenience, must trigger it.

---
# 4. Alternatives, rejection reasons, and conditions that would change the choice

## 4.1 Alternatives

| Alternative | Decision | Why | Condition that would change the decision |
|---|---|---|---|
| Enterprise MSI only, no endpoint fetcher | **RECOMMENDATION — default** | Smallest endpoint authority; uses existing managed deployment, repair, inventory, and emergency channels. No evidence yet shows it misses an approved patch objective. | Representative, repeated management-attributable latency/coverage failure plus successful updater pilot and security gates. |
| Enterprise MSI for bootstrap plus optional constrained payload updater | **RECOMMENDATION — conditional target design** | Preserves enterprise ownership of privileged topology while allowing faster product-payload activation if justified. | Remains disabled until section 4.2 gate passes. Rejected if updater cannot meet primary gate or adds unacceptable support cost. |
| Monolithic SYSTEM service downloads, extracts, installs, and restarts itself | **REJECTED** | Combines network parser, repository response, archive extraction, arbitrary filesystem mutation, service control, trust-root change, and execution under highest local authority. One defect becomes a privileged code-install path. | No expected change for this product. A proposal would need stronger primary evidence and a baseline change because it contradicts the minimal privileged boundary. |
| Run the whole updater as the ordinary User Host | **REJECTED** | User-session process cannot safely own machine-wide service payloads and creates cross-session/user ownership confusion. Elevation prompts or stored credentials would enlarge risk. | None for machine-wide endpoint service. User-level helper may display read-only status only if later required. |
| Every release is a full MSI major upgrade | **ACCEPTABLE enterprise alternative** | Simplest authorization and inventory model; good when enterprise patch speed is sufficient. | Prefer this permanently if measured patch objectives pass and payload release frequency/cost are manageable. |
| MSI patches/MSP for frequent payload updates | **DEFERRED** | Can reduce transfer size but adds sequencing, supersedence, baseline/cache, repair, and operational complexity. Does not remove the need for payload health/rollback. | Measured bandwidth/install-time need, competent packaging ownership, and full patch-chain repair/rollback evidence. |
| MSIX as the product deployment boundary | **NOT SELECTED** | MSIX has useful signing/packaging properties, but this project needs a stable machine service, exact session launcher/task behavior, enterprise repair, side-by-side payload/data compatibility, and existing MSI baseline. Fit is not established. | A supported Windows estate and MSIX service/enterprise lifecycle prototype proves equal or better capability with lower risk and a migration ADR. |
| In-place overwrite of Program Files binaries | **REJECTED** | A crash or lock can leave a mixed version; it destroys the known-good rollback image and creates DLL/executable mix-and-match. | No ordinary condition. Only an out-of-band bootstrap repair may replace MSI-owned files transactionally. |
| `current` symlink/junction or user-modifiable path pointer | **REJECTED** | Reparse/TOCTOU and ACL mistakes can redirect privileged launch to attacker-controlled content; path resolution is harder to audit than an opaque protected activation record. | Only if a future Windows mechanism provides a measured stronger atomic, non-reparse selector with equal recovery; open an ADR. |
| Privileged process extracts ZIP/MSIX/NuGet-like archive directly | **REJECTED** | Archive parsers and path normalization create traversal, duplicate/case collision, decompression, stream, link, and parser attack surfaces under SYSTEM. | A formally bounded package format and parser with stronger evidence than low-privilege extraction plus handle copy. |
| Download deltas and patch existing binaries | **REJECTED initially** | Adds parser complexity and turns the previous version into input; a single wrong base or interrupted patch can produce unreviewed bytes. Full target hash still required. | Measured bandwidth/cost need, full reconstructed-target verification, fallback to full package, fuzzing, and no loss of A/B safety. |
| Single signed JSON/appcast plus HTTPS | **REJECTED** | One online or release key cannot provide TUF’s role separation, threshold-capable root recovery, expiration, rollback, freeze, and mix-and-match protections. Common appcast updaters have a different threat model. | None for autonomous machine payloads. Appcast projects remain references for UX/tests only. |
| Authenticode only | **REJECTED** | A valid signer may sign many products/builds; certificate compromise or valid-but-unapproved artifact is not constrained to exact UAM target digest, sequence, audience, or compatibility. | No. Authenticode remains required but not sufficient. |
| TUF metadata only, unsigned PE/DLL/MSI | **REJECTED** | Loses Windows-native signer/reputation/policy checks and weakens enterprise trust/incident response. Repository authorization and Authenticode address different risks. | No for production Windows executables/installers. |
| General endpoint package manager/updater framework as dependency | **NOT SELECTED** | Existing frameworks usually own user-app install paths, UI, process restart, appcast/feed semantics, or broad installer execution, not this MSI-owned stable service boundary. | Exact dependency review proves it can be reduced to the UAM interface without importing excess authority, and all TUF/Windows gates pass. |
| Custom “TUF-like” protocol with only selected ideas | **REJECTED** | Security properties depend on the whole client workflow and persistent state, not naming four JSON files. Selective imitation risks subtle rollback/freeze/threshold defects. | Implement a documented TUF 1.0.35 POUF and pass the conformance/attack suite; otherwise autonomous update remains disabled. |
| Embed python-tuf or go-tuf on endpoints | **NOT SELECTED** | Adds Python/Go runtime/FFI/packaging/support surface to the accepted C#/.NET endpoint and does not automatically integrate safely with Windows launch/activation. | A C# implementation cannot meet conformance and a tightly isolated helper proves lower total risk, supportability, signing, and installer fit. |
| Destructive endpoint-data migration during autonomous update | **REJECTED** | Can make previous version unable to read state, defeating rollback. Repair becomes data restoration rather than code rollback. | Enterprise-controlled maintenance with explicit backup, migration, restore, compatibility epoch, and human approval. |
| Delete previous version immediately after health | **REJECTED** | Health proof cannot cover every delayed defect; emergency rollback would require a download and may fail offline. | Human-approved rollback window expires, fleet/risk data justifies cleanup, and an enterprise/OOB recovery version remains. |

## 4.2 Enterprise deployment versus autonomous updater decision gate

### 4.2.1 Default

```text
updateMode = ENTERPRISE_ONLY
```

This remains true until a signed/human-approved decision record changes it. Presence of updater code is not authorization to run it.

### 4.2.2 Required measurements

For each representative security and ordinary release, collect these value-free timestamps/reasons:

```text
releaseAuthorizedAt
enterpriseAvailableAt
endpointEligibleOnlineAt
enterpriseInstallStartedAt
installedAt
healthyAt
updateMode
managementAttemptCount
terminalReasonFamily
```

Classify intervals:

```text
publisher_delay       = enterpriseAvailableAt - releaseAuthorizedAt
eligibility_delay     = endpointEligibleOnlineAt - enterpriseAvailableAt
management_delay      = enterpriseInstallStartedAt - max(enterpriseAvailableAt,
                                                        endpointEligibleOnlineAt)
install_health_delay  = healthyAt - enterpriseInstallStartedAt
end_to_end_delay      = healthyAt - releaseAuthorizedAt
```

A device is included in **management-attributable latency** only when it was enrolled in the relevant management channel, eligible/online for the measured interval, not explicitly frozen, and had the required enterprise prerequisites. Offline, powered-off, non-persistent, unsupported, or unrelated repository/proxy failures are reported separately; they cannot be used to justify an updater that would face the same condition.

### 4.2.3 Human-selected thresholds

The following are **HUMAN DECISIONS**, not chosen here:

- security-patch deadline and ordinary-release deadline;
- population/coverage target and percentile/statistical rule;
- number of representative releases and observation window;
- acceptable exclusions and non-persistent-device treatment;
- whether autonomous update is allowed on all devices or only an approved subset.

### 4.2.4 Gate expression

Autonomous update is eligible for an architecture decision only when all terms are true:

```text
UPDATER_ELIGIBLE =
    APPROVED_PATCH_SLA_EXISTS
    AND APPROVED_ENTERPRISE_COVERAGE_TARGET_EXISTS
    AND REPRESENTATIVE_ENTERPRISE_MEASUREMENTS_EXIST
    AND REPEATED_MANAGEMENT_ATTRIBUTABLE_MISS = true
    AND MISS_IS_NOT_PRIMARILY_OFFLINE_OR_UNSUPPORTED_NETWORK
    AND UPDATER_PILOT_IMPROVES_APPROVED_METRIC_MATERIALLY
    AND UPDATER_SECURITY_PRIMARY_GATE_PASS = true
    AND TUF_CLIENT_CONFORMANCE_AND_ATTACK_TESTS_PASS = true
    AND MSI_REPAIR_AND_OOB_RECOVERY_PASS = true
    AND OPERATIONS_SUPPORT_AND_KEY_OWNERS_ASSIGNED = true
    AND COST_LICENSE_AND_RISK_APPROVED = true
```

If any term is false or unknown, the result is `ENTERPRISE_ONLY`, not a partial updater.

### 4.2.5 Responsibilities that never move to autonomous update

Even if the gate passes, enterprise deployment retains:

- bootstrap/service/task/ACL/root-trust upgrade;
- full repair and uninstall;
- enterprise freeze and forced ring assignment;
- out-of-band root/signing compromise recovery;
- incompatible storage-epoch migration;
- recovery when current and previous payloads are both unusable;
- final production enablement and emergency authority.

## 4.3 Conditions that would force a baseline change proposal

The following proposals conflict with accepted decisions and require the full change process rather than a local implementation choice:

- the updater must modify service/task/launcher/root-trust/ACL topology outside MSI;
- a privileged process must accept a tenant-provided path, URL, script, command, assembly, package format, signer, or repository;
- a release must execute before minimization/privacy-ceiling checks are available or must broaden product capability outside the release-authorized ceiling;
- a lower metadata version or unsigned local override is needed for rollback;
- the stable launcher must execute from staging, user-writable storage, reparse-selected storage, or an unverified directory;
- N/N-1 rollback is intentionally broken for an autonomous release;
- code-signing and release-metadata authority are intentionally collapsed into one online key;
- root-threshold compromise is claimed recoverable using the same compromised in-band trust;
- per-ring or per-realm rebuilding replaces same-digest promotion.

A change proposal must identify the accepted decision, new primary evidence, affected invariants, alternatives, security/privacy/realm/data impact, smallest falsifying prototype, migration/rollback consequence, and ADR action.

---

# 5. Interfaces/protocols and example contracts or schemas

## 5.1 Normative protocol profile

**RECOMMENDATION.** Publish `UAM Release Repository POUF 1.0` implementing TUF specification 1.0.35. [W17–W21]

The POUF MUST define:

- JSON encoding and canonical signature representation;
- key types and algorithm allowlist;
- role names, thresholds, delegation paths, and expiration policy;
- consistent-snapshot naming;
- metadata and target maximum sizes;
- download order and fixed update-start time semantics;
- persistent trusted metadata layout and atomic replacement;
- root-update loop and maximum root-rotation steps per cycle;
- target custom metadata schema;
- mirror/redirect rules;
- error taxonomy and retry classes;
- trusted-time/clock-uncertainty behavior;
- offline behavior;
- repository publication transaction;
- bad-version and recovery semantics;
- supported client/spec versions and deprecation;
- conformance and UAM attack vectors.

The exact crypto profile remains provisional. The client MUST reject algorithms, key types, signature encodings, hash algorithms, or metadata formats outside the POUF; it MUST NOT accept “whatever the crypto library supports.”

## 5.2 TUF role profile

| Role | Key posture | UAM authority | Expiration/rotation rule | Compromise consequence |
|---|---|---|---|---|
| `root` | offline, threshold-capable, separately held | authorizes role keys/thresholds/algorithms/spec profile/consistent snapshots | sequential N+1 root; new root verified by old and new thresholds; exact period human-owned | threshold compromise requires out-of-band MSI/root repair; less-than-threshold compromise uses normal rotation |
| `targets` or delegated `releases` | offline or tightly controlled signing | authorizes exact package target length/hash and UAM release custom metadata | new metadata version for release, revocation, delegation change, or rollback target | compromise can authorize malicious target metadata until root rotates/revokes; code-signing check remains an independent barrier |
| `snapshot` | controlled online/offline according to operations | binds exact version/hash/length of targets/delegated metadata; prevents mix-and-match | regenerated for every targets metadata publication | compromise cannot invent target signatures but can participate in mix/version manipulation; targets verification still required |
| `timestamp` | online, narrowest and shortest-lived | binds latest snapshot version/hash/length and freshness | frequently renewed; exact expiry human/operations decision | compromise can delay/freeze within role limits but cannot authorize target bytes |
| optional delegated `recovery` | separate constrained authority | authorizes only enumerated known-good digests and/or exact out-of-band recovery targets under higher sequence | invoked only under approved incident authority | cannot change root/bootstrap in-band; dangerous if delegation scope is broad, so scope must be statically checked |

An online key MUST NOT be the sole ultimate authority for installable bytes. Root private keys should remain offline, consistent with TUF guidance. [W17]

## 5.3 Repository publication transaction

Publication MUST be ordered so clients never observe a timestamp that references unavailable or inconsistent content:

1. upload final immutable target package at its consistent-snapshot/content-addressed name;
2. verify remote target length/hash by independent readback;
3. publish new targets/delegated metadata at versioned immutable name;
4. verify metadata signature/length/hash by independent client;
5. publish new snapshot metadata binding the exact targets metadata versions/hashes/lengths;
6. verify snapshot independently;
7. publish new timestamp metadata binding the snapshot;
8. update any mutable mirror pointer only after immutable objects exist;
9. execute a clean-client conformance/update test from every supported mirror;
10. retain old immutable objects for the approved offline/rollback window;
11. record publication evidence and signer/audit identities.

Timestamp is last. A failed publication before timestamp leaves clients on the prior trusted repository generation. A failed timestamp publication cannot make a partially published target trusted.

## 5.4 Target package schema

A TUF target path identifies one immutable package. The TUF target record already supplies authoritative target `length` and `hashes`. Its `custom.uam` object supplies UAM semantics. Example values are fictional:

```json
{
  "length": 48123901,
  "hashes": {
    "sha256": "b9f4c75f5d9a6ff57bf904d393f1c338b2c095b9fe837c3d2ee87ab77a010001"
  },
  "custom": {
    "uam": {
      "schemaVersion": "1.0.0",
      "productId": "uam-endpoint",
      "releaseId": "019d0000-0000-7000-8000-000000001101",
      "releaseSequence": 41,
      "semanticVersion": "3.4.0",
      "architecture": "x64",
      "channelId": "stable",
      "bootstrapEpochMin": 2,
      "bootstrapEpochMax": 2,
      "storage": {
        "readerMin": 7,
        "readerMax": 8,
        "writerSchema": 8,
        "rollbackReadableThrough": 8,
        "migrationClass": "EXPAND_ONLY"
      },
      "contractCompatibility": {
        "coordinatorUserHost": ["3.3", "3.4"],
        "endpointStore": ["7", "8"]
      },
      "packageFormat": "uam-release-package-v1",
      "packageManifestSha256": "8a7717f93c7782349ba0806c42af00101bf12e3b2f0cd7d9c301e2d8a0100002",
      "packageManifestLength": 18921,
      "privacyCeilingDigest": "sha256:fictional-privacy-ceiling",
      "requiredSigners": ["uam-code-signing-production"],
      "rollbackOfReleaseSequence": null,
      "healthProfileId": "uam-health-v1",
      "flags": {
        "autonomousActivationEligible": true,
        "requiresEnterpriseMaintenance": false,
        "deltaPackage": false
      }
    }
  }
}
```

Normative rules:

- `releaseSequence` is a strictly increasing unsigned integer in this product/repository lineage. It is the anti-rollback order; semantic version is display/compatibility data only.
- A known-good downgrade has a new higher `releaseSequence`, the exact old package digest, and `rollbackOfReleaseSequence` pointing to the bad release.
- `productId`, architecture, channel/audience, bootstrap epoch, privacy ceiling, storage compatibility, package format, and required signer profile must match local authority.
- `autonomousActivationEligible=false` forces enterprise deployment even if bytes are otherwise valid.
- `requiresEnterpriseMaintenance=true` blocks autonomous activation and requires an approved maintenance workflow.
- Unknown fields are rejected at this authority boundary unless a future POUF defines a bounded non-authoritative extension point.
- Realm/installation claims are absent. Authenticated control context selects an eligible repository/channel.

## 5.5 Release package layout and manifest

The package is an immutable container with one root manifest. The privileged activator does not trust archive entry metadata as the final manifest.

```text
uam-release-package-v1/
  release.manifest.json
  files/
    Coordinator/Uam.Coordinator.dll
    Coordinator/Uam.Coordinator.runtimeconfig.json
    UserHost/Uam.UserHost.dll
    TaskHost/Uam.TaskHost.exe
    ...
  sbom/
    uam.spdx.json
  evidence/
    provenance.bundle
    signing-attestation.json
    release-summary.json
```

Example manifest:

```json
{
  "schemaVersion": "1.0.0",
  "releaseId": "019d0000-0000-7000-8000-000000001101",
  "releaseSequence": 41,
  "packageTargetSha256": "b9f4c75f5d9a6ff57bf904d393f1c338b2c095b9fe837c3d2ee87ab77a010001",
  "createdFromUnsignedPayloadSha256": "ce6a7a8100a4f03f4d9ea88d8b9275153015f5a6de4f30cd2b47ec6601000003",
  "entrypoints": {
    "coordinator": "files/Coordinator/Uam.Coordinator.exe",
    "userHost": "files/UserHost/Uam.UserHost.exe",
    "taskHost": "files/TaskHost/Uam.TaskHost.exe"
  },
  "files": [
    {
      "path": "files/TaskHost/Uam.TaskHost.exe",
      "length": 912384,
      "sha256": "96d7eb4f22a77dcc90aa04a77781bfe2819aa7e0c17767f145e6964101000004",
      "kind": "PE_EXECUTABLE",
      "authenticodeProfile": "uam-code-signing-production",
      "mayExecute": true,
      "mayLoad": false
    },
    {
      "path": "files/Coordinator/Uam.Coordinator.runtimeconfig.json",
      "length": 631,
      "sha256": "a7277316caf7c3935915a965a260dd4574dc982d640802bc19a0122e01000005",
      "kind": "CONFIGURATION",
      "authenticodeProfile": null,
      "mayExecute": false,
      "mayLoad": false
    }
  ],
  "forbiddenExtraFiles": true,
  "sbom": {
    "path": "sbom/uam.spdx.json",
    "sha256": "9348cf4db6a8f225fb7292e5011d1b2b4a734aebfd486229766cd87601000006"
  },
  "provenance": {
    "path": "evidence/provenance.bundle",
    "sha256": "5a014f92a0b660792560f92da7afc19c5465be18e665225931db08ae01000007"
  }
}
```

Manifest invariants:

1. UTF-8 strict JSON, duplicate/unknown member rejection, bounded nesting/items/strings, local schema only.
2. Paths use `/` in canonical form, are relative, normalized exactly once, and contain no empty/dot/dot-dot/device/UNC/drive/ADS component.
3. Case-insensitive Windows path uniqueness is checked before extraction and before finalization.
4. Every final file appears exactly once; every listed file exists; no extra file exists.
5. `mayExecute` and `mayLoad` form a closed release-owned allowlist; data files cannot become executable merely due to extension.
6. Every PE/DLL/MSI in the package has an Authenticode profile unless an approved signed-manifest exception exists for a non-loadable data PE; ordinary exceptions are rejected.
7. The package target digest from TUF is checked before extraction, and the manifest digest from target custom metadata is checked before trusting the file list.

## 5.6 Authenticode verification contract

The verifier MUST:

- verify the final protected file, not only a staging path;
- call the documented Windows trust provider and treat exactly `ERROR_SUCCESS`/zero as success; boolean conversion or “no exception” is insufficient. [W09]
- use an explicit policy for trusted code-signing identities, EKUs, chain, timestamp, digest algorithms, revocation behavior, and certificate rollover;
- require an RFC 3161 timestamp according to the approved profile so a signature may remain valid after certificate expiry when policy allows;
- bind expected signer profile from signed target metadata, not an untrusted file property;
- reject unsigned, catalog-only unless explicitly supported, wrong-purpose, weak/unknown algorithm, untrusted chain, invalid timestamp, or revoked signer according to policy;
- record only signer-profile ID, result family, and certificate/thumbprint in a bounded protected evidence record; no private material;
- never use Authenticode signer display name as application/release identity;
- still check exact length and SHA-256 because Authenticode does not replace repository target identity and may not cover every file byte in the same way as a whole-file digest. [W10]

Exact chain/revocation behavior for offline endpoints is a **HUMAN DECISION** plus **CLI EXPERIMENT**. Conservative behavior is: no new activation when required revocation/trust evidence is unavailable or stale; continue a previously verified known-good release and report `AUTHENTICODE_TRUST_UNAVAILABLE`.

## 5.7 Activation state schema

```json
{
  "schemaVersion": "1.0.0",
  "activationGeneration": 122,
  "bootstrapEpoch": 2,
  "current": {
    "releaseId": "019d0000-0000-7000-8000-000000001101",
    "releaseSequence": 41,
    "targetSha256": "b9f4c75f5d9a6ff57bf904d393f1c338b2c095b9fe837c3d2ee87ab77a010001",
    "state": "PROBATION",
    "activatedAtUtc": "2026-07-31T12:00:00Z"
  },
  "previous": {
    "releaseId": "019d0000-0000-7000-8000-000000001001",
    "releaseSequence": 40,
    "targetSha256": "41cc42a9c2130fef050b49a7b70551bb3d507fe4505d6b47e4df103101000008",
    "state": "KNOWN_GOOD"
  },
  "candidate": null,
  "lastTransition": {
    "kind": "ACTIVATE_CANDIDATE",
    "attemptId": "019d0000-0000-7000-8000-000000009001",
    "reasonCode": "REPOSITORY_AUTHORIZED",
    "atUtc": "2026-07-31T12:00:00Z"
  },
  "checksum": "sha256:fictional-canonical-record-checksum"
}
```

This local record is not a signature-based release authority. The launcher independently checks TUF metadata, package manifest, files, Authenticode, compatibility, and suppression before execution.

## 5.8 Health proof contract

Health proof is local, bounded, release-bound, and does not require user activity or central network success:

```json
{
  "schemaVersion": "1.0.0",
  "activationGeneration": 122,
  "releaseId": "019d0000-0000-7000-8000-000000001101",
  "targetSha256": "b9f4c75f5d9a6ff57bf904d393f1c338b2c095b9fe837c3d2ee87ab77a010001",
  "processIdentity": {
    "pid": 4321,
    "creationTimeClass": "BOUND_TO_HELD_PROCESS_HANDLE",
    "imageFileIdDigest": "sha256:fictional-local-file-id-digest"
  },
  "checks": [
    {"id":"BOOTSTRAP_HANDSHAKE","result":"PASS"},
    {"id":"MANIFEST_AND_SIGNATURE","result":"PASS"},
    {"id":"ENDPOINT_STORE_OPEN","result":"PASS"},
    {"id":"SCHEMA_ROLLBACK_COMPATIBILITY","result":"PASS"},
    {"id":"LOCAL_IPC_BIND","result":"PASS"},
    {"id":"SYNTHETIC_INTERNAL_CYCLE","result":"PASS"}
  ],
  "completedAtUtc": "2026-07-31T12:01:00Z"
}
```

The exact time/attempt thresholds are **ESTIMATE/CLI EXPERIMENT**. Required properties are fixed:

- health is bound to the candidate process handle, release digest, and activation generation;
- a different process cannot replay health;
- central service, browser source, real user, and network reachability are not required;
- crash, hang, invalid store compatibility, failed self-check, invalid IPC identity, or missing health within the bounded window fails probation;
- a later severe health incident can suppress the version and roll back if the previous release remains compatible.

## 5.9 Bad-version suppression schema

```json
{
  "schemaVersion": "1.0.0",
  "suppressionGeneration": 18,
  "entries": [
    {
      "releaseSequence": 41,
      "targetSha256": "b9f4c75f5d9a6ff57bf904d393f1c338b2c095b9fe837c3d2ee87ab77a010001",
      "scope": "LOCAL_ENDPOINT",
      "reasonFamily": "HEALTH_PROBATION_FAILED",
      "firstObservedAtUtc": "2026-07-31T12:01:30Z",
      "retryPolicy": "HIGHER_ACTIVATION_GENERATION_AND_EXPLICIT_AUTHORITY_ONLY"
    }
  ],
  "checksum": "sha256:fictional-checksum"
}
```

Repository-wide suppression is expressed through higher-version signed targets/delegation/emergency metadata. Local suppression prevents crash loops before the endpoint can refresh metadata. A local suppression does not authorize any replacement version.

## 5.10 Local updater IPC

Logical operations:

```text
GetReleaseState
SubmitStagedTarget
VerifyAndMaterialize
ActivateMaterializedRelease
RollbackToPrevious
CleanupAttempt
VerifyInstalledRelease
```

Every request MUST include:

```text
protocol version
operation ID
one-use request ID
caller process/session evidence from the accepted local IPC boundary
attempt ID
expected target SHA-256
expected metadata version tuple
deadline/budget
```

Forbidden request fields include arbitrary path, URL, executable, arguments, service/task name, registry path, SDDL, archive format, signer, trust root, algorithm, MSI property, script, or environment block. The activator obtains all filesystem paths from protected roots plus validated opaque IDs.

Responses contain finite state/error codes, stable retry class, and evidence-record digest. They never echo untrusted metadata, path, URL, certificate text, or exception message.

## 5.11 Error taxonomy

| Family | Examples | Retry class |
|---|---|---|
| `INSTALL_*` | `INSTALL_SIGNATURE_INVALID`, `INSTALL_PREREQUISITE_MISSING`, `INSTALL_TRANSACTION_FAILED` | usually enterprise remediation |
| `MSI_ROLLBACK_*` | `MSI_ROLLBACK_DISABLED`, `MSI_ROLLBACK_FAILED`, `MSI_CUSTOM_ACTION_ROLLBACK_FAILED` | stop; OOB/repair |
| `REPAIR_*` | `REPAIR_BOOTSTRAP_MISMATCH`, `REPAIR_ACL_DRIFT`, `REPAIR_NO_VALID_PAYLOAD` | enterprise repair |
| `METADATA_*` | `METADATA_SIGNATURE_INVALID`, `METADATA_EXPIRED`, `METADATA_ROLLBACK`, `METADATA_MIX_MATCH`, `METADATA_ROOT_CHAIN_GAP` | refresh if transient; otherwise hold |
| `PACKAGE_*` | `PACKAGE_LENGTH_MISMATCH`, `PACKAGE_HASH_MISMATCH`, `PACKAGE_FORMAT_UNSUPPORTED`, `PACKAGE_EXTRA_FILE` | permanent for target |
| `AUTHENTICODE_*` | `AUTHENTICODE_INVALID`, `AUTHENTICODE_WRONG_SIGNER`, `AUTHENTICODE_REVOKED`, `AUTHENTICODE_TRUST_UNAVAILABLE` | hold/enterprise according to policy |
| `STAGE_*` | `STAGE_DISK_FULL`, `STAGE_PATH_ESCAPE`, `STAGE_REPARSE`, `STAGE_LIMIT` | retry only after resource condition; security cases hold |
| `ACTIVATE_*` | `ACTIVATE_INCOMPATIBLE_BOOTSTRAP`, `ACTIVATE_STATE_TORN`, `ACTIVATE_LOCK_TIMEOUT` | previous remains; bounded retry |
| `HEALTH_*` | `HEALTH_TIMEOUT`, `HEALTH_CRASH`, `HEALTH_STORE_INCOMPATIBLE`, `HEALTH_IDENTITY_MISMATCH` | rollback and suppress |
| `ROLLBACK_*` | `ROLLBACK_PREVIOUS_MISSING`, `ROLLBACK_DATA_INCOMPATIBLE`, `ROLLBACK_HEALTH_FAILED` | OOB/enterprise repair |
| `CLEANUP_*` | `CLEANUP_REPARSE_DETECTED`, `CLEANUP_RESIDUE`, `CLEANUP_ACCESS_DENIED` | hold affected attempt; support |
| `OFFLINE_*` | `OFFLINE_REPOSITORY_UNREACHABLE`, `OFFLINE_METADATA_EXPIRED`, `OFFLINE_CLOCK_UNCERTAIN` | continue current; retry refresh later |
| `STORAGE_COMPAT_*` | `STORAGE_N_MINUS_1_UNREADABLE`, `STORAGE_EPOCH_MISMATCH`, `STORAGE_MIGRATION_NOT_EXPAND_ONLY` | enterprise maintenance/stop |
| `SUPPLYCHAIN_*` | `SUPPLYCHAIN_PROVENANCE_INVALID`, `SUPPLYCHAIN_SBOM_MISMATCH`, `SUPPLYCHAIN_BUILD_NONREPRODUCIBLE`, `SUPPLYCHAIN_SIGNING_SUBJECT_MISMATCH` | release blocked |

Stable codes are safe for metrics. Detailed evidence is access-controlled, bounded, and scrubbed.

---

# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility rules

## 6.1 Fresh MSI installation state machine

```text
NOT_INSTALLED
  -> MSI_VALIDATING
      -> MSI_REJECTED                         signature/prerequisite/policy failure
      -> MSI_TRANSACTION
          -> BOOTSTRAP_FILES
          -> ACLS_AND_DIRECTORIES
          -> SERVICE_AND_TASK
          -> BASELINE_PAYLOAD_MATERIALIZED
          -> MSI_COMMIT_PENDING
              -> MSI_ROLLBACK                 transaction failure
                  -> NOT_INSTALLED_OR_PRIOR_STATE
              -> MSI_COMMITTED
                  -> BASELINE_ACTIVATION_PENDING
                      -> BASELINE_HEALTHY -> INSTALLED_HEALTHY
                      -> BASELINE_FAILED  -> INSTALLED_SAFE_DISABLED
```

Rules:

- An MSI rollback restores the prior MSI-managed state where Windows Installer can do so. [W01]
- Product activation is not hidden inside a non-rollbackable custom action.
- Fresh-install failure may leave an MSI-owned safe-disabled bootstrap if the MSI transaction committed but product health failed. Enterprise detection MUST mark this as failed and invoke remediation/uninstall; no unauthorized payload runs.
- The service/task cannot point directly at a candidate version.
- Test-signing is lab-only; production MSI signing remains unapproved.

## 6.2 MSI upgrade state machine

```text
INSTALLED_HEALTHY(N-1)
  -> ENTERPRISE_FREEZE_CHECK
  -> MSI_UPGRADE_VALIDATING
  -> GLOBAL_RELEASE_MUTATION_LOCK
  -> MSI_TRANSACTION
      -> UPDATE_STABLE_BOOTSTRAP_IF_NEEDED
      -> REPAIR_ACLS_SERVICE_TASK_ROOT
      -> MATERIALIZE_BASELINE_OR_CANDIDATE_N
      -> MSI_COMMIT
          -> prior MSI state restored on transaction failure
  -> RELEASE_ACTIVATION(N)
      -> PROBATION
          -> HEALTHY      -> INSTALLED_HEALTHY(N), retain N-1
          -> FAILED       -> INSTALLED_HEALTHY(N-1), suppress N
          -> INCOMPATIBLE -> INSTALLED_HEALTHY(N-1), enterprise remediation
```

The old payload remains intact through the MSI transaction and candidate probation. A bootstrap upgrade must itself remain able to launch the previous payload or provide an enterprise rollback package. Bootstrap/payload compatibility is tested as a matrix, not assumed.

## 6.3 Repair state machine

```text
REPAIR_REQUESTED
  -> VERIFY_MSI_SOURCE_AND_SIGNATURE
  -> ACQUIRE_GLOBAL_RELEASE_MUTATION_LOCK
  -> MSI_REPAIR
      -> restore bootstrap files
      -> restore service/task registration
      -> restore explicit ACLs/root trust
      -> restore required baseline payload files
  -> UAM_VERIFY_INSTALLED
      -> active valid -> REPAIR_HEALTH_CHECK
      -> active invalid + previous valid -> SELECT_PREVIOUS
      -> no valid payload + baseline valid -> SELECT_BASELINE
      -> no valid payload -> SAFE_DISABLED + OOB_REQUIRED
  -> CLEAN_STALE_ATTEMPTS_MANIFEST_SCOPED
  -> REPAIR_COMPLETE
```

`msiexec /f...` supports repair modes; the exact approved flags are an enterprise packaging decision and lab experiment. [W02]

Repair MUST NOT erase or recreate endpoint durable data merely to make code start. Data repair/migration is a separate explicit operation. Repair re-establishes the trusted bootstrap and selects only a verified compatible payload.

## 6.4 Uninstall state machine

```text
UNINSTALL_REQUESTED
  -> AUTHORITY_AND_POLICY_CHECK
  -> STOP_NEW_ACTIVATION
  -> DRAIN_OR_STOP_PAYLOADS
  -> MSI_UNINSTALL_TRANSACTION
      -> remove service/task/bootstrap/MSI-owned files
      -> rollback on transaction failure where supported
  -> DATA_DISPOSITION_PENDING
      -> PRESERVE_PRODUCT_DATA      human-approved option
      -> REMOVE_PRODUCT_DATA        human-approved manifest-scoped option
  -> CLEANUP_VERIFY
      -> COMPLETE
      -> RESIDUE_REQUIRES_SUPPORT
```

**HUMAN DECISION.** Production endpoint data disposition on uninstall is unresolved. Options are preserve for reinstall/incident, remove product-owned data, or managed cryptographic/key disposal if an approved encryption design exists. Consequences include privacy/records obligations, supportability, reinstallation behavior, and inability to guarantee physical erasure on SSD/virtualized storage. Conservative production default until decided is **do not silently delete durable product data**; lab T1 default is delete all product-owned test artifacts and prove cleanup.

## 6.5 Metadata refresh state machine

```text
IDLE_WITH_TRUSTED_METADATA
  -> FIXED_UPDATE_START_TIME_CAPTURED
  -> FETCH_TIMESTAMP
      -> transport failure             -> OFFLINE_CONTINUE_CURRENT
      -> invalid/expired/rollback       -> METADATA_HOLD
      -> valid
  -> FETCH_SNAPSHOT_BOUND_BY_TIMESTAMP
      -> length/hash/version/signature/expiry failure -> METADATA_HOLD
  -> FETCH_TARGETS_AND_DELEGATIONS_BOUND_BY_SNAPSHOT
      -> any required failure           -> METADATA_HOLD
  -> SEQUENTIAL_ROOT_UPDATE_LOOP
      -> root N+1 verified by old and new thresholds
      -> persist each root atomically
      -> gap/limit/expiry failure        -> ROOT_UPDATE_HOLD
  -> TARGET_RESOLUTION
      -> no eligible target             -> IDLE_CURRENT
      -> eligible target                -> DOWNLOAD_ELIGIBLE
  -> PERSIST_TRUSTED_METADATA_ATOMICALLY
  -> IDLE_WITH_NEW_TRUSTED_METADATA
```

Implementation order follows the selected POUF/TUF workflow exactly. Root update placement in the cycle must follow that POUF and conformance tests; the diagram shows required states, not permission to reorder security checks casually.

Persistence rules:

- trusted root, timestamp, snapshot, targets, and delegated metadata versions never decrease;
- same version with different canonical content is rejected;
- every trusted metadata write is atomic/redundant enough that a crash leaves the old or new complete value;
- expired metadata blocks **new update activation**, not continued execution of an already verified current release;
- a backward/uncertain system clock blocks new activation under the conservative profile and raises finite health; exact trusted-time design is unresolved;
- repeated root rotation is bounded per update cycle to prevent resource abuse, but the exact limit is an **ESTIMATE**.

## 6.6 Download and materialization state machine

```text
DOWNLOAD_ELIGIBLE
  -> CREATE_NEW_ATTEMPT_DIR
  -> DOWNLOAD_TARGET_BOUNDED
      -> pause/retry/offline            -> STAGED_PARTIAL_NOT_EXECUTABLE
      -> length/hash mismatch           -> QUARANTINE_AND_SUPPRESS_TARGET
      -> exact target
  -> LOW_PRIVILEGE_EXTRACT_AND_MANIFEST
      -> traversal/collision/limit      -> SECURITY_HOLD + CLEANUP
      -> staged complete
  -> ACTIVATOR_VERIFY_REQUEST
  -> ACTIVATOR_INDEPENDENT_TUF_CHECK
  -> PER_FILE_HANDLE_VERIFY_AND_COPY
      -> any identity/hash/signature/ACL/reparse/stream failure
                                         -> DELETE_INCOMPLETE_FINAL + HOLD
  -> FINAL_DIRECTORY_SEAL_VERIFY
      -> failure                         -> DELETE_INCOMPLETE_FINAL + HOLD
      -> success                         -> MATERIALIZED_NOT_ACTIVE
```

No transition executes a staged file. A crash at any point before final seal leaves the current release unchanged. Incomplete final directories are never referenced by activation state and are deleted only through safe manifest-scoped cleanup.

## 6.7 Activation and rollback state machine

```text
MATERIALIZED_NOT_ACTIVE(N)
  -> ELIGIBILITY_RECHECK
      metadata current enough, not suppressed, enterprise/policy allows,
      bootstrap/storage/contracts compatible
  -> WRITE_ACTIVATION_GENERATION(current=N as PROBATION, previous=N-1)
  -> LAUNCHER_REVALIDATES_N
  -> START_N
  -> HEALTH_PROBATION
      -> PASS
          -> WRITE_ACTIVATION_GENERATION(current=N KNOWN_GOOD, previous=N-1)
          -> PROMOTION_COMPLETE
      -> FAIL/CRASH/TIMEOUT/IDENTITY_MISMATCH
          -> SUPPRESS_N
          -> WRITE_ACTIVATION_GENERATION(current=N-1, failed=N)
          -> START_AND_HEALTH_N-1
              -> PASS -> ROLLBACK_COMPLETE
              -> FAIL -> SAFE_DISABLED + OOB_REPAIR_REQUIRED
```

Transaction boundary: materialization completes before activation-state mutation. Activation-state mutation completes before candidate launch. Health completes before known-good promotion. Previous-version deletion cannot occur inside this state machine.

## 6.8 Bad-version handling

Bad-version evidence can originate from:

- local probation failure;
- repeated local crash/health threshold;
- repository/release incident;
- enterprise freeze/deny;
- signing/repository compromise analysis;
- storage incompatibility discovered during rollout.

Containment order:

1. stop new activation through repository/enterprise/local hold;
2. cancel outstanding candidate work;
3. locally suppress exact release sequence and digest;
4. roll back to verified compatible previous where possible;
5. publish higher-version metadata withdrawing/delegating away the bad target;
6. publish a higher release sequence pointing to a known-good digest if an emergency downgrade is required;
7. use enterprise MSI/OOB repair if bootstrap trust or both payload slots are affected;
8. preserve sanitized evidence and do not auto-retry the same target until higher activation generation plus explicit authority permits it.

## 6.9 Emergency downgrade

A downgrade is not permission to accept old metadata. The repository publishes:

```text
releaseSequence = priorHighestSequence + 1
packageDigest   = exact previously approved known-good digest
rollbackOf      = bad release sequence
```

The target is signed under current valid role keys and bound by a new snapshot/timestamp. The client sees a forward metadata/release transition to old semantics. This preserves rollback/freeze protection and creates an auditable incident action.

Emergency downgrade is permitted only when:

- human emergency authority is assigned and invokes it;
- the known-good target’s Authenticode and repository authorization remain valid under the recovered trust profile;
- N-1 can read current endpoint data;
- the bootstrap can launch it;
- health proof passes;
- no product privacy-ceiling conflict exists.

If data or bootstrap is incompatible, autonomous downgrade is blocked and the incident requires enterprise maintenance or out-of-band repair.

## 6.10 Root rotation state machine

```text
TRUSTED_ROOT_N
  -> FETCH_VERSIONED_ROOT_N_PLUS_1
  -> VERIFY_VERSION_EXACTLY_N_PLUS_1
  -> VERIFY_THRESHOLD_UNDER_ROOT_N
  -> VERIFY_THRESHOLD_UNDER_ROOT_N_PLUS_1
  -> VERIFY_EXPIRY/FORMAT/ROLE_INVARIANTS
  -> PERSIST_ROOT_N_PLUS_1_ATOMICALLY
  -> TRUSTED_ROOT_N_PLUS_1
  -> repeat while next sequential root exists and budget remains
```

Skipping versions is prohibited. A root update that removes/replaces keys is trusted only through this chain. If fewer than the production threshold keys are compromised, normal root rotation revokes them. If a threshold is compromised, in-band root rotation cannot be trusted; section 7’s out-of-band runbook applies. [W17]

## 6.11 Offline and clock behavior

| Condition | New download | New activation | Current known-good execution | Recovery |
|---|---|---|---|---|
| Repository unreachable, trusted metadata unexpired | defer | no unseen target; already fully verified materialized candidate may activate only if policy explicitly permits | continue | retry when online |
| Timestamp/snapshot/targets expired | no trusted update | blocked | continue current | refresh metadata or enterprise/OOB |
| System clock moved backward/uncertain | download may be cached as untrusted bytes | blocked under conservative profile | continue current | restore trustworthy time; exact policy human-owned |
| Long-offline device has old root | sequential root refresh required | blocked until chain validates | continue current if locally valid | online refresh or OOB root repair |
| Current release suppressed remotely but endpoint offline | cannot learn remote hold | local state governs | residual exposure remains | enterprise/OOB/local kill mechanism; human incident design |
| Current and previous invalid | none | none | safe-disabled | enterprise/OOB repair |

TUF cannot prevent denial of update when the network is blocked. The endpoint must expose stale/unreachable health without turning telemetry absence into proof of safety.

## 6.12 N/N-1 data compatibility

### 6.12.1 Contract

Every release target declares:

```text
readerMin
readerMax
writerSchema
rollbackReadableThrough
migrationClass = NONE | EXPAND_ONLY | ENTERPRISE_MAINTENANCE
```

Autonomous activation is allowed only when all are true:

1. N can open and correctly use the state written by N-1.
2. N-1 can open and correctly use the state after N has completed every startup/runtime migration permitted during probation.
3. N does not drop, repurpose, narrow, or reinterpret data required by N-1 during the rollback window.
4. New fields/tables/indexes are additive and older code safely ignores them where contracts allow.
5. N never marks a schema irreversible until the rollback window is explicitly closed by enterprise authority.
6. Both directions pass crash/failpoint tests, not only clean startup.
7. A rollback does not lose unacknowledged data, advance cursors, duplicate business effects, or reveal deleted data; those adjacent invariants remain governed by their own gates.

### 6.12.2 Migration classes

| Class | Autonomous updater | Rules |
|---|---|---|
| `NONE` | allowed | no persistent format change |
| `EXPAND_ONLY` | conditionally allowed | additive schema; N/N-1 read/write matrix passes; no irreversible cleanup during rollback window |
| `ENTERPRISE_MAINTENANCE` | prohibited | requires managed stop, backup/verification, migration, restore/rollback plan, owner approval, and OOB recovery path |

### 6.12.3 Compatibility test matrix

```text
N-1 binary on N-1 fresh state
N binary on N-1 state
N binary after crash at each migration step
N-1 binary on post-N state
N binary after rollback/re-activation
N and N-1 against full/backpressured/outbox states
repair MSI with N/N-1 state
uninstall/reinstall data-preservation option
```

No “works on my empty database” result closes compatibility.

## 6.13 Ring rollout

Recommended logical rings, with exact population/duration as **HUMAN DECISION/ESTIMATE**:

```text
BUILD_EVIDENCE
  -> DISCONNECTED_WINDOWS_LAB
  -> INTERNAL_SYNTHETIC_CANARY
  -> CONTROLLED_PILOT
  -> LIMITED_ENTERPRISE_RING
  -> BROADER_ENTERPRISE_RING
  -> CURRENT
```

Rules:

- rings promote the same signed target digest;
- consumer/bootstrap/storage compatibility deploys before metadata authorizes a producer behavior that needs it;
- each ring has explicit entry, observation, stop, rollback, evidence, and cleanup criteria;
- zero-tolerance security invariants stop immediately; performance/health thresholds are human-approved measurements;
- promotion cannot continue with unresolved `UNKNOWN` release health, missing evidence, or unassigned incident owner;
- a repository rollback publishes higher metadata/release sequence; it never edits an existing target in place;
- endpoints remain able to repair through enterprise management independent of repository health.

## 6.14 Cleanup and retention lifecycle

- Partial download/extraction attempts are bounded and age/size-scavenged by manifest, never arbitrary recursive deletion.
- Incomplete final directories not referenced by a valid activation generation are removed after handle/reparse/link checks.
- Current and previous known-good versions are never scavenged.
- A candidate under active probation or evidence hold is not scavenged.
- Bad-version bytes may be retained in restricted quarantine only under incident/records policy; otherwise delete product-owned copies after sanitized evidence capture.
- Metadata history retains enough versions for rollback/freeze/root-rotation evidence according to approved policy.
- Exact version retention, evidence retention, and disk budget are human decisions.
- Cleanup failure is visible and can block further update attempts under disk/safety policy; it never silently deletes the current or previous release.

---
# 7. Security/privacy threat and failure register

## 7.1 Consolidated threat and failure register

Owner names below are accountable functions, not assigned people.

| ID | Trigger / failure | Detection | Containment | Recovery and cleanup | Owner / test | Residual risk |
|---|---|---|---|---|---|---|
| T11-01 | Untrusted repository or MITM serves arbitrary package | TUF target signature/threshold, exact target length/hash, TLS diagnostics | reject target; no extraction/activation; current remains | refresh another mirror; preserve finite failure evidence; no raw response body | Release Security; E11-08/E11-09 | network attacker can deny updates |
| T11-02 | Freeze attack serves old but signed metadata | timestamp/snapshot/targets expiry against fixed update start time; persisted highest versions | block new activation; report `METADATA_EXPIRED/FREEZE`; current continues | obtain fresh metadata or enterprise repair; investigate clock/repository | Repository Ops; E11-07 | trusted clock can be weak/offline |
| T11-03 | Rollback attack serves lower metadata/release | persisted version floors and strictly increasing release sequence | reject; SafetyHold after repeated/security-significant event | rotate/recover repository as needed; no local version-floor reset | Release Security; E11-07 | local state loss may require root/OOB bootstrap |
| T11-04 | Mix-and-match of timestamp/snapshot/targets | hash/length/version bindings at every metadata layer | abort complete update cycle | republish coherent repository generation; retain current | Repository Ops; E11-07 | publisher bug can cause availability incident |
| T11-05 | Same metadata version with different bytes | canonical digest comparison with persisted trusted metadata | reject as conflict/compromise signal | freeze repository; investigate signing/publisher; publish higher coherent versions | Release Security; E11-07 | corrupted local state must be distinguished from attack |
| T11-06 | Package truncated, padded, or modified | bounded download byte count plus SHA-256 before extraction and after materialization | delete/quarantine attempt; suppress exact bad object | re-fetch immutable target; investigate mirror/storage | Fetcher/Activator; E11-08 | denial/disk wear remains possible within limits |
| T11-07 | Archive path traversal, absolute/device/UNC path, ADS, duplicate/case collision, decompression bomb | low-privilege strict extractor plus manifest/path/limit checks; activator rechecks | terminate extractor/job; security hold; no privileged copy | safe manifest-scoped deletion without following reparse points | Package Security; E11-09 | parser/library defect may still consume bounded resources |
| T11-08 | SYSTEM activator is tricked by staging symlink/junction/reparse race | opened-handle identity, no-follow/reparse attributes, final-path check, pre/post file identity/hash | abort before copy or activation; retain current | delete attempt by safe handle/manifest; update code and rerun race campaign | Windows Security; E11-10 | kernel/SYSTEM attacker is outside this boundary |
| T11-09 | Source file is swapped after verification but before copy | activator hashes/copies from same opened source handle; source identity recheck | abort on identity/read anomaly | remove incomplete destination; rerun from new attempt | Windows Security; E11-10 | filter drivers may expose unexpected semantics |
| T11-10 | Destination path is redirected or pre-created | protected root ACL, no reparse traversal, `CREATE_NEW`, final-path/file-ID verification | refuse existing/colliding object; no overwrite | repair ACL/root; delete only incomplete product-owned object | Windows Security/MSI; E11-10/E11-04 | ACL/GPO/EDR drift across estate |
| T11-11 | Hard link or alternate stream makes final bytes differ from expected semantics | link-count/name and stream enumeration; final whole-file hash; forbidden extra stream rule | reject version; no activation | remove incomplete directory; repair root ACL | Windows Security; E11-10 | filesystem-specific behavior may differ |
| T11-12 | ACL inheritance grants ordinary user write/change permission | post-install/upgrade/repair binary security descriptor and effective-access tests | bootstrap SafetyHold; no activation from affected root | MSI repair re-applies explicit ACL; investigate enterprise policy | MSI/Endpoint Security; E11-04/E11-12 | domain policy may reapply unsafe ACL after repair |
| T11-13 | Malicious MSI property/custom action becomes SYSTEM command injection | static MSI/ICE/custom-action allowlist, hostile property corpus, process/file trace | package release blocked; lab install aborted | remove dynamic command construction; prefer declarative tables | Installer Security; E11-03/E11-04 | third-party installer extension defects |
| T11-14 | Rollback disabled or custom action lacks rollback partner | MSI property/policy inventory, package lint, kill/failpoint test | installation gate fails | correct package/policy; enterprise repair/OOB restore | Installer Engineering; E11-04/E11-05 | enterprise policy outside product may disable rollback |
| T11-15 | Power loss/kill during MSI transaction | Windows Installer log, before/after inventory, rollback script behavior | installer rollback; stable old payload remains | repair MSI; verify service/task/ACL/root/payload | Installer Engineering; E11-05 | Windows Installer cannot undo every external side effect |
| T11-16 | Power loss/kill while writing activation state | dual-slot generation/checksum and launcher scan | launcher chooses older complete valid state | rewrite state from verified current/previous; clean corrupt slot | Release Runtime; E11-11 | storage/firmware faults may corrupt both slots |
| T11-17 | Power loss/kill during file copy or seal | candidate never referenced; final manifest completeness and seal state | current remains; incomplete directory ineligible | manifest-scoped cleanup and fresh materialization | Activator; E11-09/E11-11 | disk-full/residue can block future attempts |
| T11-18 | Launcher executes partial/mixed version | every start verifies closed manifest, exact files, digests, signatures, no extras | refuse candidate; choose verified previous or safe-disable | repair/re-materialize; investigate source of drift | Bootstrap/Release Security; E11-11 | verification cost and untested delayed DLL loading |
| T11-19 | DLL search hijack from current directory/PATH/user storage | fixed protected entrypoint, safe DLL-search policy, process module/ProcMon test | launch fails rather than loading unlisted module | fix packaging/search configuration; suppress release | Windows Security; E11-13 | OS/runtime-specific dynamic loading paths |
| T11-20 | Validly code-signed but repository-unauthorized binary | TUF/manifest exact digest mismatch despite valid Authenticode | reject | publish exact authorized target or investigate signer misuse | Release Security; E11-08/E11-13 | threshold-authorized malicious release remains possible |
| T11-21 | Repository-authorized but unsigned/wrong-signer PE/MSI | Authenticode policy verification on final files | reject target; current remains | correct signing; rotate/revoke signer if incident | Signing Authority; E11-06/E11-13 | revocation availability and policy errors |
| T11-22 | Code-signing key compromise | signing logs/digest authorization anomalies, CA/CT/provider alerts, unexpected signed digest | freeze all promotion; block affected signer profile/digests; stop new activation | CA revocation, new signer, root/target metadata update, known-good higher sequence, OOB MSI if bootstrap cannot trust new signer | Signing Authority/Incident; P11-06 | already executed malicious signed code may own endpoint |
| T11-23 | Online timestamp key compromise | unexpected timestamp signatures/version cadence; repository audit | freeze timestamp publication/mirrors; current continues | rotate timestamp key through new root, advance metadata versions, republish coherent repository | Repository Security; P11-06 | attacker can deny/freeze within expiry and network control |
| T11-24 | Snapshot key compromise | anomalous snapshot metadata or target-version binding failure | reject unless targets chain validates; freeze repository | rotate via root; rebuild snapshot from approved targets | Repository Security; P11-06 | availability impact; combined key compromise worsens risk |
| T11-25 | Targets/release key compromise | unauthorized target metadata, signing audit mismatch, unexpected release sequence | global activation hold, enterprise freeze, local suppression where known | rotate/revoke targets key via root; publish higher metadata and known-good sequence; assess executed endpoints | Release/Incident; P11-06 | valid code-signing key plus target compromise can authorize malware |
| T11-26 | Fewer than root threshold keys compromised | custody/audit incident | stop root ceremony; compromised key excluded from future quorum | normal sequential root rotation signed by old/new thresholds | Root Custodians; P11-06 | attacker may delay or combine with other compromise |
| T11-27 | Root threshold compromised | ceremony/audit evidence or malicious root observed | assume in-band trust is lost; isolate affected endpoints/repository | independent enterprise OOB recovery MSI replaces stable verifier/root; investigate for installed malware | Enterprise Incident/Root Authority; P11-06 | safe remote recovery may be impossible; rebuild/reimage may be required |
| T11-28 | CI runner/source dependency compromise | reproducibility mismatch, provenance/material change, secret scanner, builder anomaly | quarantine outputs; no signing/promotion | destroy/recreate runners/cache, rebuild twice, reconcile SBOM/provenance, rotate CI credentials | Build Security; E11-01/E11-02/E11-14 | common-mode source/tool compromise may reproduce identically |
| T11-29 | Signing service/HSM account compromised | digest authorization/signing audit mismatch, provider alerts | disable signing credential; release freeze | rotate credentials/key/cert, inspect all signed digests, revoke where necessary | Signing Authority; P11-06 | timestamped signatures may remain accepted until revocation policy acts |
| T11-30 | Build provenance is valid but subject does not match shipped artifact | independent subject digest/file manifest verification | release blocked | regenerate correct attestation from isolated builder/signing chain | Supply Chain; E11-14 | attestation does not prove source is safe |
| T11-31 | SBOM tool silently omits files/components | final-file and lock-graph reconciliation, dual-tool/positive controls | release blocked on unexplained omission | fix detector, add manual component record, rerun | Dependency/Supply Chain; E11-14 | no finite tool proves complete licensing/security knowledge |
| T11-32 | Per-ring rebuild or package mutation | target digest comparison across promotion records | stop promotion | restore same-digest promotion; invalidate mutated ring | Release Engineering; E11-15 | metadata differs by ring by design; target bytes must not |
| T11-33 | Candidate health forged/replayed by another process | held process handle, creation identity, release/activation binding, one-use health channel | reject health; rollback/suppress candidate | investigate local IPC/identity; rerun hostile process tests | Runtime Security; E11-11 | local admin/SYSTEM attacker can defeat local proof |
| T11-34 | Candidate starts but hangs/crashes during probation | launcher process observation, bounded health deadline, crash count | kill candidate tree; activate previous; suppress candidate | gather sanitized dump policy evidence; fix/release higher sequence | Release Runtime; E11-11 | delayed defect after probation may remain |
| T11-35 | Previous version cannot read post-N data | pre-activation N/N-1 matrix and runtime compatibility check | autonomous activation blocked; no migration | enterprise maintenance/restore or compatible release | Storage/Release; E11-16 | hidden semantic incompatibility can escape tests |
| T11-36 | Both current and previous fail | launcher health and verification | safe-disable; no arbitrary third fallback | MSI repair or OOB recovery/reimage | Endpoint Support; E11-12/P11-05 | monitoring/control may be unavailable while agent is disabled |
| T11-37 | Bad version is retried in crash loop | local suppression generation plus repository/enterprise deny | exact digest/sequence blocked | higher activation generation and explicit authority after fix; or higher-sequence target | Release Runtime; E11-11 | suppression state corruption may require repair |
| T11-38 | Offline device misses revocation/kill switch | stale metadata/last-contact health and enterprise inventory | current local controls only; no new activation on expiry | reconnect, enterprise push, OOB repair, possible isolation | Incident/Operations; E11-17 | impossible to remotely control a fully disconnected device |
| T11-39 | Clock rollback lets expired metadata appear valid | persisted trusted-version/time-floor anomaly and OS clock checks | block new activation | restore trusted clock or OOB enterprise action | Endpoint Security/Operations; E11-07/E11-17 | endpoint lacks guaranteed secure wall clock |
| T11-40 | Proxy/VPN/auth failure is misclassified as enterprise patch delay | distinct eligibility/network/management timestamps and finite reason families | do not use as updater-need evidence | fix network/identity lane; rerun decision measurement | Endpoint Management/SRE; E11-18 | classification depends on accurate management telemetry |
| T11-41 | Repository response or error leaks realm/device/proxy data | strict logging schema, outbound/inbound capture, canary scanner | stop affected build; redact/quarantine evidence | remove field, rotate exposed credential if any, rerun all-sink test | Privacy/AppSec; E11-19 | third-party proxy/EDR logs outside product control |
| T11-42 | Release metrics create high-cardinality/device tracking | metric-cardinality lint and production-series inventory | reject deployment/dashboard | reduce to finite dimensions; exact detail stays in bounded evidence | SRE/Privacy; E11-19 | rare ring/bootstrap combinations may still identify small populations |
| T11-43 | Uninstall deletes unrelated/user data through reparse/path bug | MSI/component ownership plus manifest-scoped cleanup, reparse test | abort cleanup/uninstall action; rollback where possible | repair manifest/ACL, restore from enterprise backup if affected | Installer/Privacy; E11-12 | deletion restoration may be impossible |
| T11-44 | Repair silently trusts corrupt activation/current directory | repair verifier independently checks metadata/files/signatures | select only verified previous/baseline or safe-disable | re-materialize/enterprise repair | Installer/Release; E11-12 | source MSI cache may itself be unavailable/corrupt |
| T11-45 | Service/task action changed to attacker path after install | periodic/bootstrap self-check, SCM/task inventory, ACL/audit evidence | safe-disable/bootstrap repair required | MSI repair or OOB package; investigate privileged mutation | Endpoint Security; E11-04/E11-12 | local admin can change system configuration; detection latency remains |
| T11-46 | Enterprise MSI and autonomous updater race | one global release mutation mutex plus Windows Installer/product-state checks | one operation waits/fails safely | rerun after first completes; verify state and cleanup | Installer/Activator; E11-11/E11-12 | abandoned lock/reboot semantics need proof |
| T11-47 | Disk full during staging/activation/state write | bounded free-space preflight plus write/flush errors/failpoints | current/previous untouched; block new work | clean safe attempts, free space, repair state if needed | Release Runtime; E11-09/E11-11 | disk failure can corrupt unrelated endpoint data |
| T11-48 | EDR/AV quarantines or delays signed files | file/health/enterprise product event category, exact lab instrumentation | no activation until final verification/health; rollback if post-activation failure | allowlisting decision by Endpoint Security; re-materialize/repair | Endpoint Security/Support; E11-13 | estate-specific false positives and timing races |
| T11-49 | Production key/certificate/test key leaks into repository or logs | secret/certificate inventory, test-canary positive controls, isolated signing | release blocked; incident response | revoke/remove/rotate, history scan, rebuild evidence | AppSec/Signing; E11-01/E11-06 | scanners have false negatives |
| T11-50 | Emergency authority makes unaudited unsafe change | mandatory signed decision/metadata and durable release audit before success | no local override; operation rejected without authority | use formal higher-sequence rollback or OOB procedure | Emergency Authority/Audit; P11-06 | human collusion/threshold-authorized malicious decision |

## 7.2 Key hierarchy and compromise runbook

### 7.2.1 Common incident sequence

Every key/supply-chain incident runbook MUST follow:

```text
DETECT
  -> FREEZE signing/publication/activation as appropriate
  -> CLASSIFY key role, time window, digests, metadata versions, rings, endpoints
  -> CONTAIN credentials, repository, mirrors, CI, signing lane
  -> PRESERVE sanitized immutable evidence
  -> ROTATE/REVOKE using a still-trusted higher authority
  -> PUBLISH coherent higher-version recovery metadata/artifacts
  -> REPAIR/ROLLBACK affected endpoints
  -> VERIFY cleanup and fleet state
  -> RE-ENABLE only under assigned authority
  -> POST-INCIDENT dependency/key/runbook review
```

No runbook asks for raw endpoint activity, SSH configuration, production database credentials, or user data.

### 7.2.2 Online timestamp key compromise

**Trigger:** provider alert, unexpected timestamp signatures/version cadence, key exposure, or audit mismatch.

**Containment:** stop timestamp service, freeze repository promotion, preserve current immutable objects, publish enterprise activation hold if a separately trusted path exists. Current verified payloads continue.

**Recovery:** root authority signs a new root version replacing the timestamp key; publisher advances timestamp/snapshot/targets versions coherently even if content is unchanged; clean clients and long-offline sequential-root tests pass; old key is disabled/deleted/revoked in its service.

**Cleanup/evidence:** credential destruction receipt, root/repository metadata digests, signing logs, affected expiry window, mirror readback, fleet refresh status.

**Residual:** attacker could have delayed updates or served a stale valid snapshot within expiry but could not authorize new target bytes without other roles.

### 7.2.3 Snapshot key compromise

Freeze publication. Root rotates snapshot key. Reconstruct snapshot only from independently approved targets/delegation metadata. Advance all necessary versions and publish timestamp last. Test mix-and-match, missing metadata, duplicate key/signature, and old-snapshot replay. Investigate combined compromise with targets or timestamp.

### 7.2.4 Targets/release key compromise

**Containment:** stop signing and publication; enterprise/global activation hold; block exact suspicious target digests/sequences; prevent new updater attempts; preserve current/previous unless evidence says their execution is unsafe.

**Recovery:** root rotates/revokes release key/delegation; publish higher-version targets metadata removing affected authorization; publish a higher release sequence to an exact known-good signed digest where N/N-1 compatibility allows; refresh snapshot/timestamp; use enterprise repair for endpoints unable to receive metadata.

**Fleet response:** identify endpoints by release sequence/digest, not user/activity. If malicious code may have executed, assume endpoint compromise and follow enterprise incident/reimage policy; rollback alone is not proof of cleanup.

### 7.2.5 Code-signing key compromise

1. Freeze signing, release approval, repository publication, and new activation for affected signer profile.
2. Obtain CA/signing-provider incident evidence and revoke/disable certificate/key according to the approved policy.
3. Inventory every digest signed during the exposure window from signing audit and final-file manifests.
4. Rotate to a new signer/certificate through the product’s trusted signer profile. If stable launchers cannot trust the new profile through existing signed repository/bootstrap policy, distribute a signed enterprise/OOB MSI update.
5. Rebuild cleanly from locked source, compare unsigned payloads, sign only approved digests with the new key, and publish higher metadata versions.
6. Publish bad-version suppression/known-good sequence as needed.
7. Test online and offline chain/revocation/timestamp behavior before re-enable.

Repository target hashes remain decisive: a stolen code-signing key alone must not make an arbitrary binary executable. Conversely, repository authorization cannot waive the signer incident.

### 7.2.6 Fewer than root threshold keys compromised

Stop ceremonies involving the affected key. Confirm that fewer than threshold are affected. Use the remaining old threshold and the intended new threshold to publish sequential root N+1 with compromised key removed. Rotate any downstream keys whose confidentiality might also be affected. Run conformance, long-offline root-chain, and bad-old-root tests. Destroy or quarantine the compromised key material under custody policy.

### 7.2.7 Root threshold compromise

**FACT.** TUF states that if a threshold of root keys is compromised, root should be updated out of band and it is safest to assume attackers may have installed malware on affected machines. [W17]

UAM response:

- declare the in-band repository trust lost;
- isolate/freeze repository and affected endpoint population;
- do not publish an in-band “new root” and claim recovery;
- prepare an independently authorized and code-signed enterprise/OOB recovery MSI containing a new stable verifier, bootstrap epoch, and root trust;
- verify the OOB package through enterprise signing/catalog controls independent of the compromised root;
- repair or reimage endpoints based on incident evidence; a root-compromised malicious payload may have achieved machine-level impact;
- reset repository lineage/bootstrap epoch only through an explicit migration and evidence record;
- inventory success and retain endpoints that cannot be repaired in a non-compliant/quarantined state.

Exact emergency authority, OOB signer, custody, and reimage threshold are **HUMAN DECISIONS**.

### 7.2.8 CI/build compromise

Keys are absent from CI, so containment focuses on artifact integrity: freeze promotion; preserve runner/cache/material/provenance; destroy ephemeral runners/caches; rotate CI tokens; review source/dependency changes; rebuild in two new challenged environments; reconcile unsigned payload, final files, SBOM, provenance, and signing input; rerun hostile release gates. Reproducible malicious input is still malicious, so source review and dependency admission remain necessary.

### 7.2.9 Signing service/HSM compromise

Disable the signing identity and service authorization; preserve HSM/KMS audit; compare requested/approved/signed digests; revoke/rotate credentials or certificate; investigate every unexpected operation; rebuild/re-sign only after clean evidence; update repository signer profile and bootstrap through normal or OOB authority as required. A service audit gap blocks re-enable.

## 7.3 Incident response and support ownership

Before any autonomous updater pilot, these functions must be assigned and on-call/escalation-tested:

- release incident commander;
- Windows installer/endpoint owner;
- repository/TUF owner;
- signing/root-custody authority;
- build/supply-chain owner;
- endpoint storage compatibility owner;
- enterprise management owner;
- privacy/security reviewer;
- support/operations owner;
- emergency/risk authority.

Runbooks must include trigger, authority, exact stop mechanism, affected digest/sequence selection, evidence capture, rollback/OOB repair, cleanup, validation, communication, and re-enable conditions. An unassigned owner is a blocking release-gate failure.

---
# 8. Detailed test matrix and smallest falsifying prototypes

## 8.1 Evidence rules for every test

Every release-security experiment MUST emit an immutable machine-readable record containing:

- experiment/test ID and one falsifiable claim;
- exact source tree, MSI, package, target, metadata, root, signer-profile, schema, and configuration digests;
- exact SDK/runtime, installer tool, signing tool, TUF test implementation, OS image/build class, filesystem class, architecture, EDR/policy class, and VM image digest;
- T1 fixture and test-key/certificate identities;
- start/end UTC and **ESTIMATE** duration versus actual duration;
- placeholder-only command identity with connection details removed;
- ordered steps, injected failure point, first failure, retries, and exit/result codes;
- before/after inventory of services, tasks, ACLs, files, streams, hard links, processes, handles, registry, certificates, firewall rules, trusted metadata, activation state, endpoint store, and product-owned disk use as applicable;
- Windows Installer log and process/file/registry traces retained only in restricted lab storage, with a sanitized shareable summary;
- canary/secret scan with mandatory positive controls;
- cleanup/revert receipt;
- accountable owner/reviewer functions and exception expiry;
- no internal host/address/user/key path, credential, raw activity, or production signer.

A rerun does not erase the first failure. A test that could not execute because the environment lacks a capability is `BLOCKED`, not `PASS`.

## 8.2 Attack and failure test matrix

| ID | Setup and instrumentation | Steps / injected attack | Pass criteria | Fail / stop | Evidence | **ESTIMATE** duration | Cleanup |
|---|---|---|---|---|---|---|---|
| TM11-01 | Clean disposable Windows VM; test-signed MSI; MSI verbose log; service/task/file/ACL inventory | fresh install, reboot, first health; repeat quiet/basic UI modes | exact MSI-owned objects; baseline only executes after verification; detection reports healthy; no forbidden files/credentials | wrong path/ACL, unsigned execution, incomplete health accepted, residue | MSI log, object diff, activation/health records | 1–2 h per OS profile | uninstall, remove test certs, revert VM |
| TM11-02 | Prior version installed and healthy | major upgrade with stable bootstrap unchanged, then changed; kill at each standard action/custom action boundary | unsuccessful MSI returns prior operable state; successful MSI retains prior payload until N health | mixed bootstrap, missing previous, rollback disabled/failed | action/kill matrix, before/after hash inventory | 4–8 h per package/profile | repair/uninstall/revert |
| TM11-03 | MSI with deliberate declarative/custom-action mutations | inject hostile public properties, quoted paths, shell metacharacters, user-writable temp, missing rollback CA | every unsafe mutation blocked by build/lint or lab; no arbitrary process/command/file write | any property controls SYSTEM command/path; non-rollback side effect | MSI table dump, ICE/custom guard results, ProcMon categories | 2–4 h | delete mutated packages, revert |
| TM11-04 | Installed product; corrupt/delete bootstrap files, ACLs, service/task, active payload | run approved `msiexec /f...` modes and UAM verifier | stable boundary restored; only verified compatible payload selected; data untouched | repair trusts corrupt target, changes/deletes endpoint data, leaves unsafe ACL | repair log, hashes, descriptors, state/store diff | 2–4 h per profile | restore baseline/revert |
| TM11-05 | Installed product with T1 data; uninstall options | kill at uninstall boundaries; reparse/hard-link decoys near product roots | no unrelated/user path deletion; rollback/known state on interruption; chosen T1 data policy enforced | path escape, reparse follow, unknown directory deletion, service/task residue | file operation trace, manifest, cleanup diff | 2–4 h | remove lab data/certs, revert |
| TM11-06 | Test code-signing CA/cert, correct/wrong/expired/revoked/timestamped/tampered PE/MSI | sign variants; mutate covered/uncovered bytes; verify staging/final; offline revocation cases | exact approved signer/profile only; zero return required; target hash catches any whole-file change; policy is deterministic | wrong signer/unsigned/tampered accepted; valid signature alone bypasses target authorization | SignTool/WinVerifyTrust outputs, package digests, policy matrix | 3–5 h | remove test roots/private keys, revert |
| TM11-07 | TUF 1.0.35 fixture repository and clean client state | stale/expired/lower/same-version-different/missing metadata, root gap, duplicate signatures/keys, threshold failures, clock shifts | exact expected rejection and persistent version floors; current release continues | one attack accepted; trusted state rolls back; expiry ignored | conformance/attack vectors, trusted metadata before/after | 4–8 h | delete fixture repo/client state |
| TM11-08 | Good/bad/truncated/padded/tampered target packages | network interruption, resume, wrong length/hash, target replacement after timestamp | only exact target becomes extraction-eligible; bounded disk/retry; no execution | mismatch reaches extractor/activator; unbounded partials | HTTP fixture logs, disk/resource curve, digests | 2–4 h | safe attempt cleanup |
| TM11-09 | Malicious archives: `..`, absolute, UNC, device path, ADS, duplicate case, duplicate entry, symlink/junction, huge ratio/count/depth | low-privilege extraction then activator request; kill every extraction/copy/seal transition | every malicious case rejected; activator never parses archive; current unchanged; no outside write | any path escape, SYSTEM parser, incomplete version eligible, unbounded resource | corpus IDs, process/job resource data, file trace | 6–12 h | manifest-scoped deletion/revert |
| TM11-10 | Ordinary hostile process with write access to its own staging; protected final roots | race replace/reparse/rename/hard-link/ADS/source identity at every activator check/copy step; ACL inheritance mutations | zero unauthorized final byte/path; every race rejected or copies exact opened-handle bytes; no bootstrap mutation | one attacker-controlled byte/path enters final; activator overwrites protected existing file | high-volume race counts, file IDs/final paths, ProcMon, hashes | 8–24 h per filesystem/security profile | kill jobs, repair ACL, remove attempts, revert |
| TM11-11 | A/B current/previous/candidate; fault-injection hooks | kill service/activator/VM before/after every state slot write/flush, materialization seal, candidate launch, health, known-good promotion, rollback | launcher always selects a complete verified current/previous or safe-disables; no partial execution; monotonic generations | no operable known version despite prior valid release; torn slot chosen; crash loop | failpoint ledger, slot bytes, selected digest, process history | 8–16 h | verify state, repair/revert |
| TM11-12 | Corrupt active, previous, bootstrap, service/task/ACL separately and in combinations | restart, repair, uninstall/reinstall preserving data, OOB recovery package | correct escalation: previous, baseline, safe-disabled, then repair; no arbitrary fallback | corrupt file executes; repair cannot restore promised case; data loss | recovery matrix, logs, store hashes, object diff | 6–12 h | remove test keys/artifacts, revert |
| TM11-13 | Candidate payloads with malicious DLL search, delayed load, unsigned dependency, EDR delay/quarantine | launch from varied CWD/PATH, user-writable DLLs, module loads; run under security products if approved | only manifest-listed protected modules load; invalid/quarantined candidate fails health and rolls back | user-writable/unlisted module loads; health passes despite missing dependency | module/ETW/ProcMon inventory, signer/digest results | 4–8 h per profile | remove decoys/allowlists, revert |
| TM11-14 | Two clean builders, isolated signing, final file tree | alter path/user/locale/time; poison cache; omit native/generated file; tamper provenance subject; SBOM tool false-success fixture | unsigned R2 match or explained approved R3 difference; every shipped byte maps; provenance subject exact; omissions detected | unexplained mismatch, omitted component, signer builds/modifies output, bad subject accepted | file manifests, diffs, SBOM reconciliation, provenance verification | 4–12 h | destroy runners/caches |
| TM11-15 | Same signed package and multiple ring repositories/policies | promote, demote, freeze, republish metadata, attempt per-ring byte change | target digest identical across rings; metadata authorization changes only; mutation blocked | rebuild/re-sign or byte drift per ring; unauthorized ring accepted | promotion ledger, target hashes, metadata roots/audiences | 2–4 h | remove fixture repos |
| TM11-16 | N-1 and N binaries; seeded synthetic endpoint stores/outboxes; migration failpoints | N on N-1, N-1 after N, crash at each migration, rollback/re-activate, full/disk-pressure states | both versions preserve declared invariants and read/write compatibility; no cursor/data loss/duplicate | N-1 unreadable, destructive change, mismatch hidden until rollback | DB/store hashes, schema/state/effect ledger | 8–24 h per migration | restore fixture copies/revert |
| TM11-17 | Devices simulated offline, stale metadata, old roots, clock rollback/forward, repository outage | reconnect after multiple root versions; expire each role; block network during stages | current continues; no stale/unverified activation; sequential root refresh; finite health | current stops solely due metadata expiry; expired candidate activates; version floor reset | time/root matrix, client state, network trace | 4–8 h | reset clock/state/revert |
| TM11-18 | Synthetic enterprise-management timing data and optional updater pilot simulator | classify offline, eligible, management delay, install/health; vary exclusions | decision metric separates causes and reproduces approved definitions; no updater recommendation without all inputs | offline/network delay attributed to management; missing timestamp imputed; policy threshold invented | dataset/schema, calculation tests, decision record | 1–3 h | delete T1 dataset |
| TM11-19 | Full endpoint release path with canary metadata, URLs, proxy values, realm/device-like fictional markers | success/failure/crash/support bundle/metrics/logs/dumps/network capture | zero forbidden marker in unapproved sink; only finite dimensions; scanner positive controls pass | marker/credential/path leaks; dynamic high-cardinality metric | all-sink manifest, metric-series count, scanner evidence | 4–8 h | delete captures/revert |
| TM11-20 | Test root/targets/snapshot/timestamp/code-signing keys and OOB MSI trust | compromise each role, rotate/revoke, threshold-root loss, offline endpoints | role-specific recovery succeeds; root-threshold uses independent OOB path; old keys rejected | in-band root compromise “recovery,” inability to restore known state, old key accepted | ceremony simulation, metadata chains, endpoint inventory | 8–16 h | destroy all test keys/certs/repos, revert |
| TM11-21 | MSI and activator concurrent controls | start repair/upgrade/uninstall and update activation/materialization at controlled offsets; abandon lock/reboot | one global mutation owner; loser waits/fails; resulting state passes full verifier | simultaneous writes, deadlock without recovery, mixed state | lock/state timeline, MSI/activator logs | 3–6 h | repair/revert |
| TM11-22 | Disk-full/I/O fault injection and filesystem corruption simulation | fail every write/flush/rename/copy/state/metadata persistence boundary | old trusted state/current release survives or safe-disabled; no partial activation | corrupt newest chosen, current deleted, endless retry/disk growth | failpoint/store/image evidence | 6–12 h | restore disk/VM snapshot |

## 8.3 Smallest falsifying prototypes

### P11-01 — MSI transactional boundary and independent activation

**Claim.** A signed MSI can install/upgrade/repair the stable service/task/launcher/ACL/root boundary while a separate A/B activation transaction leaves the prior payload operable whenever candidate health fails.

**Setup:** one disposable Windows VM; T1 test certificate; baseline MSI N-1; upgrade MSI N; synthetic payload with selectable healthy/crash/hang modes; MSI verbose logging; service/task/ACL/file inventory; no network or live data.

**Instrumentation:** Windows Installer log, process/file/registry trace, exact file digests, binary security descriptors, activation slots, health channel, cleanup manifest.

**Steps:**

1. install N-1 and prove healthy;
2. upgrade to N; kill at every MSI action boundary;
3. on committed upgrades, activate N in healthy/crash/hang modes;
4. corrupt service/task/launcher/ACL and run repair;
5. uninstall with interruption;
6. compare all states against the oracle.

**Pass:** each MSI interruption yields prior MSI state or fully committed bootstrap; activation failure selects healthy N-1; no service/task points to candidate; repair restores stable boundary without changing synthetic endpoint data; uninstall never escapes product ownership.

**Fail:** mixed bootstrap or payload executes, rollback is disabled/ineffective, candidate activation destroys N-1, repair trusts corrupt bytes, or cleanup touches unrelated paths.

**Evidence:** package hashes/signatures, action/failpoint ledger, object diffs, health/activation records, test-canary scan, cleanup receipt.

**ESTIMATE duration:** 1–2 engineering days once hooks exist.  
**Cleanup:** uninstall, remove test certificate/private key, delete T1 artifacts, revert VM.

### P11-02 — SYSTEM reparse/TOCTOU-safe materialization

**Claim.** A low-privilege hostile process cannot cause the activator to write attacker-chosen bytes or paths into the protected version root.

**Setup:** hostile T1 staging controller; fixed activator request; protected Program Files root; corpus of symlink/junction/reparse, rename, hard-link, ADS, case collision, source replacement, delayed I/O, and path-length attacks.

**Instrumentation:** held-handle file IDs/final paths, operation barriers at every check/copy step, per-process filesystem trace, destination hashes/streams/link count/ACL.

**Steps:** race each transition repeatedly under supported filesystems and security-policy profiles; kill activator and VM during copy/seal; attempt to pre-create/collide final paths.

**Pass:** zero unauthorized destination byte or path; copied bytes always match the exact source handle and signed manifest; all anomalous cases reject; incomplete destination never becomes eligible; current release unchanged.

**Fail:** one path escape, reparse follow, overwrite, source-swap byte, extra stream/hard link, or incomplete version activation.

**Evidence:** reproducible race seed/schedule, attempt counts, file identity timeline, hashes, traces, cleanup diff.

**ESTIMATE duration:** 2–5 engineering days for harness plus overnight campaigns.  
**Cleanup:** kill hostile job, safe-delete manifest-owned attempts, MSI repair ACLs, revert VM.

### P11-03 — TUF workflow, rollback, freeze, and mix-and-match

**Claim.** The UAM client implements the documented TUF 1.0.35 POUF and never exposes a target until all role, threshold, version, expiry, length, and hash checks pass.

**Setup:** local T1 repository generator; test root/targets/snapshot/timestamp keys; clean and persisted clients; official TUF conformance suite at an exact pinned commit; UAM adversarial extensions.

**Instrumentation:** every fetched/persisted metadata digest/version, fixed update start time, target resolution, request byte caps, trusted-state diff.

**Steps:** run conformant workflow plus expired metadata, lower versions, same-version different content, root gaps, insufficient/duplicate signatures, wrong target hash/length, missing delegated metadata, timestamp/snapshot/targets mix, clock shifts, and offline reconnect.

**Pass:** exact oracle result for every vector; no attack target returned; trusted versions never decrease; current known-good execution unaffected by metadata expiry; sequential root rotation works.

**Fail:** any unauthorized/stale/mixed target becomes materialization-eligible, persisted trust rolls back, or root threshold is counted incorrectly.

**Evidence:** POUF version, conformance report/expected failures, attack corpus, trusted-state hashes, resource bounds.

**ESTIMATE duration:** 2–4 engineering days after client prototype.  
**Cleanup:** destroy fixture keys/repository/client state.

### P11-04 — A/B crash invariance and health proof

**Claim.** Killing every activation transition always leaves an operable verified current or previous release, or a safe-disabled state when neither is valid; it never executes an incomplete candidate.

**Setup:** current N-1, candidate N, two activation slots, fault hooks, healthy/crash/hang/forged-health payloads.

**Instrumentation:** exact state-slot bytes/checksums/generations, file seals, process handles/image IDs, health messages, selected release per restart.

**Steps:** kill before/after every slot write/flush, candidate launch, health check, known-good promotion, suppression write, previous activation, and cleanup. Replay forged and old health records.

**Pass:** launcher chooses highest complete independently verified generation; prior valid version survives every pre-known-good interruption; health cannot replay; failed N is suppressed; monotonic generation holds.

**Fail:** partial N executes, both valid slots become unusable from one transition, old health promotes N, or crash loop retries N without authority.

**Evidence:** exhaustive transition/failpoint table and restart outcomes.

**ESTIMATE duration:** 2–3 engineering days.  
**Cleanup:** restore baseline state, remove candidates, revert VM.

### P11-05 — N/N-1 data compatibility

**Claim.** Every autonomous-update candidate permits N-1 to open and correctly operate on the state after N’s allowed migrations.

**Setup:** synthetic endpoint SQLite/outbox/store snapshots covering empty, ordinary, maximum-bound, disk-pressure, unacknowledged, retry, and migration states; N-1 and N binaries; migration failpoints.

**Instrumentation:** schema, page/store hashes, logical event/progress/outbox ledger, startup/write/read results, rollback health.

**Steps:** run N-1; upgrade to N; kill at every migration/commit boundary; write under N; roll back; operate under N-1; re-activate N; run repair.

**Pass:** declared read/write semantics and accepted durability/privacy invariants hold; no destructive cleanup during rollback window; both releases health-check.

**Fail:** N-1 refuses or misinterprets state, cursor/effect/outbox changes incorrectly, data is silently dropped, or migration cannot recover.

**Evidence:** exact migration code/digests, before/after logical ledgers, failpoint results.

**ESTIMATE duration:** 2–5 engineering days per migration family.  
**Cleanup:** delete T1 stores, revert VM.

### P11-06 — Key-compromise recovery drill

**Claim.** Compromise of any non-root-threshold role has a tested rotation/revocation path, while root-threshold compromise uses an independent OOB MSI path.

**Setup:** complete T1 key hierarchy, signing service simulator, repository, online/offline clients, current/previous packages, independent OOB test CA/MSI trust.

**Instrumentation:** signing/custody simulation logs, metadata chains, certificate/revocation state, endpoint selected releases, enterprise repair results.

**Steps:** compromise timestamp, snapshot, targets, code-signing, CI, signing service, one root key, then threshold root; execute each runbook; include long-offline endpoint.

**Pass:** old compromised keys cease authorizing new content; higher-version recovery is coherent; known-good rollback works where compatible; threshold-root case refuses in-band recovery and succeeds only via OOB MSI or produces explicit reimage-required state.

**Fail:** old key remains accepted, one online key authorizes arbitrary code, root-threshold is “recovered” in-band, or no known state can be restored.

**Evidence:** role-by-role drill report, destroyed-key receipts, target/root/signer inventories, endpoint outcome map.

**ESTIMATE duration:** 2–4 engineering days plus human tabletop.  
**Cleanup:** destroy all test keys/certs/repositories, uninstall/revert.

### P11-07 — Supply-chain subject and same-digest promotion

**Claim.** The exact final package promoted to every ring is traceable to two matching unsigned builds, approved signing inputs, a reconciled final file/SBOM inventory, and correct provenance subjects.

**Setup:** two clean isolated builders, isolated test signing, final MSI/package, two ring repositories, poisoned/missing-component/provenance-substitution mutations.

**Instrumentation:** complete file manifests, binary diffs, dependency locks, SBOM outputs, provenance/signing attestations, target metadata, ring target digests.

**Steps:** build twice under changed path/user/locale/time; sign approved digest; package; reconcile; promote; inject every mutation.

**Pass:** unexplained unsigned differences block; all shipped files/components map; incorrect provenance subject or missing component blocks; target digest is identical across rings; no signing key in builder.

**Fail:** zero-exit tool result overrides mismatch, per-ring bytes differ, or signer accepts unapproved digest.

**Evidence:** R2/R3 report, manifests, SBOM reconciliation, attestations, promotion ledger.

**ESTIMATE duration:** 1–3 engineering days after pipeline exists.  
**Cleanup:** destroy runners/caches/test signing material and fixture repos.

### P11-08 — Enterprise versus updater decision measurement

**Claim.** The decision dataset can distinguish enterprise-management latency from endpoint-offline/network/ineligibility latency and cannot recommend updater enablement without all human thresholds and security gates.

**Setup:** deterministic T1 fleet/release timeline generator with devices that are managed, offline, frozen, unsupported, proxy-failing, slow-management, successful, and updater-pilot eligible.

**Instrumentation:** versioned schema/calculation code, independent oracle, missing-value/reason cases, output decision record.

**Steps:** calculate intervals and classifications; mutate formulas/exclusions; omit each human threshold and technical gate in turn.

**Pass:** exact oracle; updater remains ineligible when misses are not management-attributable or any authority/gate is absent; no identity/raw endpoint data needed.

**Fail:** offline device is treated as management delay, missing timestamp is guessed, threshold is invented, or updater is enabled by code alone.

**Evidence:** T1 package root, formulas, mutation results, decision output.

**ESTIMATE duration:** 1–2 engineering days.  
**Cleanup:** delete T1 measurement artifacts.

## 8.4 Primary acceptance expression

```text
RELEASE_UPDATE_GATE_PASS =
    UNAUTHORIZED_VERSION_EXECUTIONS = 0
    AND INCOMPLETE_OR_MIXED_VERSION_EXECUTIONS = 0
    AND STALE_FROZEN_OR_DOWNGRADED_ACTIVATIONS = 0
    AND INTERRUPTIONS_WITHOUT_OPERABLE_KNOWN_VERSION_WHEN_ONE_EXISTED = 0
    AND SYSTEM_PATH_ESCAPE_OR_ATTACKER_CONTROLLED_FINAL_BYTES = 0
    AND MSI_ROLLBACK_OR_REPAIR_PRIMARY_FAILURES = 0
    AND AUTHENTICODE_OR_TARGET_DIGEST_BYPASSES = 0
    AND TUF_CONFORMANCE_BLOCKING_FAILURES = 0
    AND N_MINUS_1_COMPATIBILITY_FAILURES = 0
    AND KEY_ROLE_WITHOUT_TESTED_RECOVERY_PATH = 0
    AND SUPPLY_CHAIN_SUBJECT_OR_FILE_INVENTORY_MISMATCHES = 0
    AND PER_RING_TARGET_DIGEST_DRIFT = 0
    AND PRIVACY_CANARY_OR_SECRET_ESCAPES = 0
    AND CLEANUP_RESIDUE_BLOCKERS = 0
    AND BLOCKING_OWNER_COUNT = 0
    AND BLOCKING_ADR_COUNT = 0
```

No success percentage, average latency, tool exit code, code-signature validity, or risk waiver compensates for a nonzero primary invariant count.

---
# 9. Architecture fitness functions and measurable acceptance criteria

## 9.1 Fitness functions

| ID | Fitness function | Automated/measured check | Acceptance criterion | Review trigger |
|---|---|---|---|---|
| FF11-01 | Stable privileged boundary changes only by MSI/OOB | repository dependency/API/file graph and installed-object diff | updater cannot write bootstrap/service/task/root/ACL objects; zero mutation tests survive | any new privileged object or updater feature |
| FF11-02 | No execution from staging/user-writable/reparse path | launcher path/file-handle verifier plus hostile path corpus | zero launched image/module outside manifest-authenticated protected version directory | launcher/runtime/Windows/filesystem change |
| FF11-03 | Repository authorization is complete | TUF conformance and UAM attack vectors | zero unauthorized/stale/frozen/rollback/mix-and-match target resolved | TUF spec/client/POUF change |
| FF11-04 | Authenticode is independent | correct/wrong/expired/revoked/tampered matrix | target must pass both target digest and signer profile; one cannot substitute for the other | certificate/chain/policy/tool change |
| FF11-05 | Every final byte is known | final manifest closed-world reconciliation | listed files equal shipped files; all lengths/hashes match; no extra streams/links/files | package/tool/runtime change |
| FF11-06 | A/B interruption safety | exhaustive activation failpoint campaign | if a valid current/previous existed before transition, one remains operable after every interruption | state format/filesystem/bootstrap change |
| FF11-07 | Candidate health is release-bound | process-handle/activation-generation challenge tests | no replay/foreign process health accepted; failed candidate never becomes known-good | health protocol change |
| FF11-08 | Bad release does not loop | suppression and restart model | exact failed digest/sequence not retried without higher generation and explicit authority | suppression/state change |
| FF11-09 | Emergency downgrade remains anti-rollback safe | metadata/release model tests | rollback target always has a higher release sequence and current valid metadata | repository model/change |
| FF11-10 | N/N-1 rollback remains possible | per-release migration matrix and failpoints | N-1 operates correctly on post-N state for autonomous releases | any schema/persistence change |
| FF11-11 | MSI rollback/repair works | install/upgrade/repair/uninstall kill matrix | no mixed bootstrap; repair restores declared boundary; service/task/ACL exact | MSI/tool/OS/GPO change |
| FF11-12 | SYSTEM copy resists reparse/TOCTOU | race harness | zero attacker-selected path/byte reaches final; current unchanged on failure | activator/file API/filesystem/EDR change |
| FF11-13 | Build output is reproducible enough | challenged clean-build comparison | byte-identical canonical unsigned payload or approved explained R3 boundary; unexplained mismatch blocks | toolchain/dependency/build image change |
| FF11-14 | SBOM/provenance match shipped subject | independent final-file/lock/provenance reconciliation | zero unexplained omitted/invented component or subject mismatch | SBOM/provenance tool change |
| FF11-15 | Same bytes cross rings | promotion ledger target digest check | exact signed target digest identical for every ring/realm authorization | release process/repository change |
| FF11-16 | No production secret in CI/artifact | secret/certificate positive-control scans and signing-boundary tests | all mandatory controls detected; no production private key/credential accessible in build | CI/signing/tool change |
| FF11-17 | Release observability is privacy-safe | schema/cardinality/canary lint | fixed finite dimensions; zero forbidden marker/credential/path; approved series budget | telemetry/support change |
| FF11-18 | Offline behavior is safe | expiry/root/clock/network matrix | current verified version continues; no new stale/unverified activation | clock/repository/support-window change |
| FF11-19 | Key compromise is recoverable at the correct authority | role-by-role drill | each non-root-threshold role rotates/revokes; root-threshold requires independent OOB path | key hierarchy/custody/provider change |
| FF11-20 | Updater exists only for measured need | decision-record validator | updater disabled unless all measurement, human, security, support, and cost gates are present and current | SLA/management/estate/release model change |
| FF11-21 | Cleanup is ownership-bounded | manifest/reparse-safe cleanup tests | no non-product path touched; current/previous retained; zero blocking residue | cleanup/retention/uninstall change |
| FF11-22 | Privileged mutation is auditable | state/audit transaction tests | no successful activation/rollback/bootstrap repair without durable audit record/evidence digest | audit/store/activator change |

## 9.2 Zero-tolerance criteria

These values are architectural invariants, not configurable performance targets:

```text
unauthorized_executions                         = 0
incomplete_or_mixed_executions                  = 0
lower_or_stale_metadata_activations             = 0
attacker_controlled_privileged_final_writes     = 0
release_target_hash_or_signer_bypasses          = 0
cursor/data invariant regressions from rollback = 0
cross_realm_release_authorizations              = 0
unapproved_activity_or_secret_observability     = 0
per_ring_target_byte_drift                      = 0
root_threshold_in_band_recovery_claims          = 0
```

## 9.3 Measured or human-owned criteria

The following require replaceable measurements and accountable approval rather than invented numbers:

- metadata/target/file count/size/decompression caps;
- download timeout/retry/backoff and concurrent attempt count;
- free-space reserve and retained-version count/duration;
- full-hash startup CPU/I/O budget;
- health probation duration and delayed-crash threshold;
- ring population, observation period, promotion threshold, and automatic rollback threshold;
- patch SLA/coverage percentile;
- trusted-clock tolerance and metadata expiries;
- code-signing revocation/offline policy;
- metric-series and evidence-retention budget;
- support staffing/on-call and recovery-time objective;
- MSI install/repair/uninstall duration and reboot policy.

Each approved value must identify its source distribution, hardware/estate scope, owner, review date, compatibility consequence, and replacement trigger.

## 9.4 Release gate artifact

The release pipeline should emit `release-gate.json`:

```json
{
  "schemaVersion": "1.0.0",
  "releaseId": "019d0000-0000-7000-8000-000000001101",
  "releaseSequence": 41,
  "targetSha256": "b9f4c75f5d9a6ff57bf904d393f1c338b2c095b9fe837c3d2ee87ab77a010001",
  "bootstrapEpoch": 2,
  "updateModeEligibility": "ENTERPRISE_ONLY",
  "gates": [
    {"id":"FF11-03","result":"PASS","evidenceSha256":"sha256:fictional"},
    {"id":"FF11-10","result":"PASS","evidenceSha256":"sha256:fictional"}
  ],
  "humanDecisions": [
    {"id":"HD11-01","status":"UNDECIDED","conservativeDefault":"ENTERPRISE_ONLY"}
  ],
  "blockingFailures": 0,
  "blockingUnknowns": 1,
  "productionAuthorized": false
}
```

A release can be build/test complete while `productionAuthorized=false`. Tooling must not collapse technical evidence and human approval into one boolean.

---

# 10. Human decisions and owner questions

## 10.1 Decision register

Role names are accountable functions, not assignments. The conservative default applies only until an authorized decision is recorded.

| ID | Human decision | Options and consequences | Conservative temporary default | Accountable role/function | Blocked work |
|---|---|---|---|---|---|
| HD11-01 | Patch SLA and enterprise-management coverage | Define security/ordinary deadlines, population/percentile, exclusions, and observation window. Tight targets may justify updater cost; loose targets may leave risk longer. | no SLA inferred; `ENTERPRISE_ONLY` | Product/Risk with Endpoint Management and Security | updater decision gate |
| HD11-02 | Enterprise management coverage and supported device classes | fully managed only; internet-only subset; non-persistent VDI; long-offline; exceptions. Wider support increases testing/operations. | only named lab capability; no autonomous coverage claim | Endpoint Platform/Product Support | support matrix, updater pilot |
| HD11-03 | Signing/root custodians and ceremonies | internal HSM/KMS; external signing service; offline hardware; M-of-N structures. Affects compromise, availability, cost, audit. | test keys only; no production signing | Cryptographic/Signing Authority with Security/Risk | production metadata/code signing |
| HD11-04 | Exact role thresholds, algorithms, key types, expiries, rotation overlap | stronger separation reduces compromise risk but raises availability/ceremony burden. | POUF profile remains proposed; no production root | Cryptographic/Repository Authority | production TUF repository/client |
| HD11-05 | Installer tool and license/procurement | WiX source build, WiX binary with OSMF EULA, another MSI authoring tool, internal support. Affects legal/support/skills. | prototype may evaluate pinned source/tool in isolated lane; no procurement assumption | Installer Engineering with Legal/Procurement | production MSI toolchain |
| HD11-06 | Emergency authority | single executive, dual control, incident quorum, separate product/repository authority. Too broad enables unsafe rollback; too narrow delays response. | no emergency mutation; only ordinary enterprise freeze | Designated Emergency/Risk Authority | emergency downgrade/kill/re-enable |
| HD11-07 | Code-signing CA, timestamp, revocation/offline policy | public/private PKI, provider/HSM, online revocation required or bounded cached evidence. Affects offline activation and recovery. | no new activation when required trust evidence unavailable; test CA only | Signing Authority/Endpoint Security | production Authenticode profile |
| HD11-08 | Autonomous updater authorization and population | never; all managed; limited internet-only; security releases only. Adds permanent attack surface and on-call. | disabled | Product/Risk with Security/Operations | updater deployment |
| HD11-09 | Repository hosting/mirrors/proxy/VPN/device identity | internal, internet, CDN, multiple roots, proxy auth. Affects availability, privacy, isolation, cost. | local T1 repository only | Platform/Network/Identity/Security | network updater tests |
| HD11-10 | Retained version count/window and disk budget | current+previous; current+previous+candidate; longer incident retention. Affects offline recovery and disk. | keep current, previous, active candidate in lab; no production duration | Product/SRE/Endpoint Platform | cleanup thresholds |
| HD11-11 | Trusted-clock and offline metadata policy | OS time with monotonic floor; enterprise signed time; no offline activation; bounded grace. Security/availability trade-off. | uncertain/backward clock blocks new activation, current continues | Security/Operations/Risk | production expiry policy |
| HD11-12 | Storage migration authority | expand-only autonomous; scheduled maintenance; backup/restore/reimage. Affects rollback and downtime. | only `NONE`/proved `EXPAND_ONLY` autonomous | Data/Storage Owner with Product/Operations | incompatible release activation |
| HD11-13 | Uninstall data disposition | preserve, remove product-owned data, key destruction, enterprise archival. Privacy/records/support consequences. | no silent production deletion; T1 lab deletes | Data Controller/Records/Product/Privacy | production uninstall behavior |
| HD11-14 | Incident evidence/dump/retention/access | value-free evidence only; bounded dumps; vendor support path. Affects diagnosability/privacy. | automatic raw payload-process dumps disabled for release tests; sanitized evidence only | Security Incident/Privacy/Operations | production support profile |
| HD11-15 | Ring definitions and automatic stop/rollback thresholds | manual, statistical, zero-tolerance plus measured health. Affects speed/blast radius. | manual synthetic/lab rings; zero-tolerance invariants only | Release/Product Risk/Operations | pilot/broad rollout |
| HD11-16 | Support staffing, on-call, RTO, and OOB repair channel | business hours/24x7, regional, vendor support, reimage authority. Affects credible recovery. | updater cannot be enabled without named coverage | Engineering Leadership/Operations | updater pilot/production |
| HD11-17 | Budget and acceptable total cost | enterprise packaging, repository, signing/HSM, test VMs, telemetry, support. | no unapproved spend or dependency/service | Product/Finance/Procurement | tool/service selection |
| HD11-18 | Production risk acceptance and go-live | reject, limited pilot, phased production, full production. Technical pass does not decide risk. | no pilot/production | Designated Production/Risk Authority | deployment |

## 10.2 Owner questions

1. What patch-latency and coverage result would justify adding a privileged update subsystem rather than improving enterprise deployment?
2. Which device populations are online and manageable during the relevant patch window, and which failures are truly management-attributable?
3. Which exact bootstrap objects may ever change outside MSI? The recommended answer is none; any exception needs an ADR and baseline review.
4. Who holds root, release, snapshot, timestamp, code-signing, provenance, and OOB recovery authority, and which combinations must be impossible for one actor?
5. What happens operationally when timestamp metadata expires on a long-offline device or the clock moves backward?
6. Which certificate chain/revocation evidence is required before offline activation, and how is signer rollover delivered to old bootstrap versions?
7. How many prior versions can endpoints retain, for how long, and what disk-pressure state is acceptable?
8. Can every planned endpoint migration be expand-only through N/N-1? Which release requires an enterprise maintenance epoch?
9. Who can publish a known-good higher-sequence downgrade, stop a ring, block a signer, and re-enable after incident?
10. Which independent trust signs the OOB repair MSI if root or normal signing authority is compromised?
11. What MSI authoring/support model is licensed and staffed, including source build versus vendor binary/EULA?
12. What exact support evidence can be collected without raw activity, credentials, full memory, or high-cardinality endpoint identity?
13. Which enterprise tool executes post-MSI health detection and remediation, and how is that definition versioned/tested?
14. Are WDAC/AppLocker/EDR/CFA controls part of the support contract, and who owns allowlisting without weakening verification?
15. What is the decision for uninstall data and secure deletion limits on SSD/VDI/storage snapshots?

---

# 11. CLI experiments/measurements and exact evidence

## 11.1 Lab and command safety boundary

**FACT.** The allowlisted lab summary proves only that a Windows-oriented connection path exists; it proves no OS, MSI, service, privilege, filesystem, or update capability. Connection details, usernames, addresses, ports, key paths, credentials, and SSH configuration must never enter this result or future evidence. [I02]

All examples use placeholders. The approved runner supplies connection configuration outside evidence. Raw PML/ETL/MSI logs may remain in restricted disposable lab storage; shareable outputs contain normalized categories and hashes only.

## 11.2 Evidence envelope

```json
{
  "schemaVersion": "1.0.0",
  "experimentId": "E11-00",
  "claim": "one falsifiable sentence",
  "classification": "T1",
  "startedAtUtc": "<RFC3339-Z>",
  "endedAtUtc": "<RFC3339-Z>",
  "sourceTreeSha256": "<digest>",
  "msiSha256": "<digest-or-null>",
  "releaseTargetSha256": "<digest-or-null>",
  "metadata": {
    "rootVersion": 1,
    "targetsVersion": 1,
    "snapshotVersion": 1,
    "timestampVersion": 1,
    "poufVersion": "1.0.0"
  },
  "environment": {
    "osBuildClass": "<sanitized>",
    "architecture": "<exact>",
    "filesystemClass": "<sanitized>",
    "edrPolicyClass": "<sanitized>",
    "vmImageDigest": "<digest>"
  },
  "tools": [{"name":"<tool>","version":"<exact>","sha256":"<digest>"}],
  "commands": [{"argvRedacted":"<placeholder-only>","exitCode":0}],
  "faults": [{"transition":"<id>","fault":"KILL_PROCESS"}],
  "assertions": [{"id":"<id>","result":"PASS"}],
  "artifacts": [{"path":"<safe relative path>","sha256":"<digest>","classification":"T1"}],
  "canaryScan": {"positiveControlsPassed":true,"escapes":0},
  "cleanup": {"result":"PASS","receiptSha256":"<digest>"},
  "ownerFunction": "<assigned>",
  "reviewerFunction": "<independent>",
  "exceptions": []
}
```

## 11.3 Ordered CLI experiments

| ID | CLI experiment | Exact evidence required | Pass | Stop/fail |
|---|---|---|---|---|
| E11-00 | hash allowlisted inputs and record public-source/repository review | five exact names/hashes, research date, no extra Project input | matches section 2 | missing/extra/substituted input |
| E11-01 | capture build/install/release toolchain | `dotnet --info`, exact MSI tool/source/binary/EULA state, SignTool/SDK, TUF test client, SBOM/provenance tools, VM image, package locks | every executable input exact and admitted | floating/latest/mutable/unmapped tool |
| E11-02 | challenged double clean build | unsigned file manifests/diffs, dependency/material identities | byte-identical canonical unsigned payload or explicit approved R3 boundary | unexplained byte/file mismatch |
| E11-03 | static MSI and architecture guards | MSI tables, ICE/custom guards, project/API mutation results, forbidden command/script/path tests | all unsafe mutations fail | one mutation passes |
| E11-04 | install and effective boundary inventory | service/task XML, stable paths, binary descriptors/effective access, root trust, file manifests, reboot behavior | exact least-authority layout; ordinary users cannot mutate protected roots | unsafe ACL/path/task/service/root |
| E11-05 | MSI kill/rollback campaign | failpoint/action ledger, MSI logs, before/after state | prior operable state or complete commit after every kill | mixed/broken state or failed rollback |
| E11-06 | test Authenticode matrix | correct/wrong/expired/revoked/timestamped/tampered outputs, WinVerifyTrust exact status, whole-file digests | exact policy; target hash independent | any invalid/wrong target accepted |
| E11-07 | TUF conformance/attack/root/clock campaign | exact POUF/spec/conformance commit, expected failures, trusted metadata before/after | no blocking conformance failure; every UAM attack rejected | stale/rollback/mixed/threshold attack accepted |
| E11-08 | good/bad/stale/tampered target build/download | good/bad/stale/tampered package set, lengths/hashes, bounded retry/disk | only exact current target eligible | unauthorized bytes reach extraction |
| E11-09 | archive/materialization/kill campaign | corpus, file operation trace, final/incomplete directory manifests | no escape; no incomplete eligibility; current remains | path escape/partial activation/unbounded resource |
| E11-10 | SYSTEM reparse/TOCTOU race campaign | attempt seeds/counts, handle/final-path/file-ID/stream/link/hash evidence | zero attacker-controlled final path/byte | one unauthorized final byte/path |
| E11-11 | A/B activation/health/suppression kill campaign | all transition failpoints, slot generations, process/health identities | operable known version or safe-disable; no forged health | partial execution/crash loop/no rollback |
| E11-12 | repair/uninstall/OOB campaign | corruption matrix, repair/uninstall logs, object/data diffs, OOB package verification | declared recovery paths restore state and bounded cleanup | repair trusts corrupt target or deletes unrelated data |
| E11-13 | DLL/module/EDR compatibility | loaded-module inventory, user-writable decoys, security product outcomes | only listed protected modules; safe rollback | DLL hijack/unlisted module/unsafe workaround |
| E11-14 | SBOM/provenance/signing reconciliation | final file manifest, lock graph, SBOM(s), provenance subjects, signing attestation | no unexplained omission/subject mismatch | zero-exit tool masks mismatch |
| E11-15 | ring same-digest promotion | target digests/metadata roots per ring, publication sequence | same signed bytes in all rings | per-ring rebuild/mutation |
| E11-16 | N/N-1 data migration/failpoint matrix | exact store/schema/effect ledgers before/after | bidirectional compatibility for autonomous class | previous cannot operate correctly |
| E11-17 | offline/expiry/root-chain/clock matrix | role expiry, clock, root chain, current execution, activation results | current continues; no stale activation | expired/rollback target activates or current needlessly stops |
| E11-18 | enterprise patch-latency measurement | versioned data contract, classifications, calculations, independent oracle, approved thresholds or explicit absence | accurate causal intervals; updater ineligible without full decision | offline delay misattributed/invented SLA |
| E11-19 | privacy-safe release observability | all logs/metrics/traces/dumps/support/network captures and cardinality inventory | zero forbidden canary/credential/path; fixed dimensions | one leak or unbounded label |
| E11-20 | role-by-role compromise drill | rotation/revocation/root/OOB chains, endpoint outcomes, destroyed-key receipts | correct authority recovery for every role | no recovery path or in-band root-threshold claim |
| E11-21 | global MSI/updater concurrency | lock ownership/timeline and resulting full verifier | one writer/mutator; recoverable abandoned lock | mixed/deadlocked/unverifiable state |
| E11-22 | aggregate release/update gate | immutable `release-update-gate.json` binding all evidence, ADRs, owners, human defaults | all primary criteria zero; no blocking unknown/owner for claimed scope | no autonomous/pilot/production permission |

## 11.4 Command outlines

These commands are examples for repository scripts. Exact flags/tool versions are pinned in the execution manifest.

### 11.4.1 Create good/bad/stale/tampered packages

```powershell
# All inputs are fictional and local to the disposable VM/build lane.
& .\eng\release\New-TestRelease.ps1 `
  -Scenario Good `
  -OutputDirectory '<T1_OUTPUT>\good'

& .\eng\release\New-TestRelease.ps1 `
  -Scenario WrongTargetHash `
  -OutputDirectory '<T1_OUTPUT>\bad-hash'

& .\eng\release\New-TestRelease.ps1 `
  -Scenario ExpiredTimestamp `
  -OutputDirectory '<T1_OUTPUT>\stale'

& .\eng\release\New-TestRelease.ps1 `
  -Scenario TamperedAfterSigning `
  -OutputDirectory '<T1_OUTPUT>\tampered'

& .\eng\release\Verify-TestReleaseSet.ps1 `
  -RootDirectory '<T1_OUTPUT>' `
  -ExpectedLedger '<T1_ORACLE>\release-ledger.json'
```

Evidence: package/metadata/file hashes, scenario IDs, signer/test-key IDs, expected/actual verification outcome, no private-key file path in shareable output.

### 11.4.2 Test-sign binaries and MSI

```powershell
& .\eng\signing\New-LabSigningMaterial.ps1 `
  -OutputDirectory '<VM_PRIVATE_TEST_KEY_DIR>'

& '<PINNED_SIGNTOOL>' sign `
  /fd SHA256 `
  /f '<VM_PRIVATE_TEST_PFX>' `
  /p '<IN_MEMORY_TEST_PASSWORD>' `
  /tr '<LOCAL_TEST_RFC3161_ENDPOINT>' `
  /td SHA256 `
  '<T1_BINARY>'

& '<PINNED_SIGNTOOL>' verify /pa /all /v '<T1_BINARY>'
& .\eng\signing\Invoke-UamAuthenticodePolicy.ps1 `
  -Path '<T1_BINARY>' `
  -Profile '<T1_SIGNER_PROFILE>'
```

Shareable evidence redacts certificate private material, password, local endpoint, and absolute paths. Cleanup removes private key, certificate store entries, and test trust.

### 11.4.3 Install, verbose log, repair, uninstall

```powershell
$msi = '<T1_SIGNED_MSI>'
$log = '<T1_EVIDENCE_DIR>\install.log'

Start-Process -FilePath 'msiexec.exe' -Wait -PassThru -ArgumentList @(
  '/i', $msi,
  '/qn',
  '/norestart',
  '/l*v', $log
)

& '<INSTALLED_RELEASECTL>' verify-installed --format json `
  > '<T1_EVIDENCE_DIR>\verify-after-install.json'

Start-Process -FilePath 'msiexec.exe' -Wait -PassThru -ArgumentList @(
  '/f', '<APPROVED_REPAIR_FLAGS>', $msi,
  '/qn', '/norestart',
  '/l*v', '<T1_EVIDENCE_DIR>\repair.log'
)

Start-Process -FilePath 'msiexec.exe' -Wait -PassThru -ArgumentList @(
  '/x', $msi,
  '/qn', '/norestart',
  '/l*v', '<T1_EVIDENCE_DIR>\uninstall.log'
)
```

The approved repair flags are selected by the installer ADR/lab, not hard-coded from this research.

### 11.4.4 Kill every transition

```powershell
$transitions = Get-Content '<T1_ORACLE>\release-transitions.json' | ConvertFrom-Json
foreach ($transition in $transitions) {
  & .\eng\windows-lab\Restore-CleanSnapshot.ps1 -SnapshotId '<PLACEHOLDER>'
  & .\eng\release\Invoke-TransitionKillCase.ps1 `
    -TransitionId $transition.id `
    -Fault $transition.fault `
    -EvidenceDirectory "<T1_EVIDENCE_ROOT>\$($transition.id)"
  & .\eng\release\Assert-KnownVersionInvariant.ps1 `
    -EvidenceDirectory "<T1_EVIDENCE_ROOT>\$($transition.id)"
}
```

The snapshot/connection implementation stays outside exported evidence. `Assert-KnownVersionInvariant` verifies files, metadata, signatures, state slots, process identity, health, and cleanup.

### 11.4.5 TUF conformance and attack corpus

```bash
# In a sealed T1 Linux/build test lane, with exact image and commit pinned.
make -C '<PINNED_TUF_CONFORMANCE_CHECKOUT>' dev
'<PINNED_TUF_CONFORMANCE_CHECKOUT>/env/bin/pytest' \
  '<PINNED_TUF_CONFORMANCE_CHECKOUT>/tuf_conformance' \
  --entrypoint '<UAM_TUF_CLIENT_CONFORMANCE_CLI>' \
  -rA \
  --junitxml '<T1_EVIDENCE>/tuf-conformance.xml'

'<UAM_RELEASE_TEST_CLI>' verify-attack-corpus \
  --pouf '<POUF_JSON>' \
  --corpus '<T1_TUF_ATTACK_CORPUS>' \
  --evidence '<T1_EVIDENCE>/tuf-attacks.json'
```

No mutable GitHub Action major tag is sufficient release evidence; use an exact commit/image/tool digest.

### 11.4.6 Reparse/TOCTOU campaign

```powershell
& '<UAM_RELEASE_RACE_HARNESS>' run `
  --scenario-set '<T1_RACE_CORPUS>' `
  --activator '<INSTALLED_ACTIVATOR>' `
  --attempts '<MEASURED_CAMPAIGN_COUNT>' `
  --evidence '<T1_EVIDENCE_DIR>\race-results.json'

& '<INSTALLED_RELEASECTL>' verify-installed --deep --format json `
  > '<T1_EVIDENCE_DIR>\post-race-verify.json'
```

The exact campaign count is an **ESTIMATE** replaced by fault-detection evidence; zero unauthorized writes is fixed.

### 11.4.7 N/N-1 compatibility

```powershell
& .\eng\release\Invoke-CompatibilityMatrix.ps1 `
  -PreviousRelease '<T1_N_MINUS_1_RELEASE>' `
  -CandidateRelease '<T1_N_RELEASE>' `
  -FixtureRoot '<T1_STORE_FIXTURES>' `
  -FailpointManifest '<T1_MIGRATION_FAILPOINTS>' `
  -EvidenceDirectory '<T1_EVIDENCE_DIR>\compatibility'
```

Evidence includes logical store/effect ledgers, not raw production data.

### 11.4.8 Role-compromise drill

```bash
'<UAM_KEY_DRILL_CLI>' run \
  --scenario timestamp-compromise \
  --fixture '<T1_KEY_REPOSITORY>' \
  --evidence '<T1_EVIDENCE>/timestamp.json'

'<UAM_KEY_DRILL_CLI>' run \
  --scenario root-threshold-compromise \
  --fixture '<T1_KEY_REPOSITORY>' \
  --oob-msi '<T1_OOB_RECOVERY_MSI>' \
  --evidence '<T1_EVIDENCE>/root-threshold.json'
```

The root-threshold scenario MUST reject an in-band-only recovery.

### 11.4.9 Patch-latency decision measurement

```powershell
& .\eng\release\Measure-DeploymentLatency.ps1 `
  -Input '<T1_RELEASE_TIMELINE_NDJSON>' `
  -DecisionPolicy '<HUMAN_APPROVED_OR_EXPLICITLY_UNDECIDED_POLICY>' `
  -Output '<T1_EVIDENCE_DIR>\updater-decision.json'
```

If required human policy fields are absent, output is `INELIGIBLE_MISSING_HUMAN_DECISION`, never an inferred threshold.

## 11.5 Exact evidence needed to close the primary gate

1. Test-signed good, bad, stale, wrong-signer, wrong-hash, truncated, padded, mixed, and tampered packages.
2. Kill/failpoint result for every install, materialization, state, launch, health, rollback, repair, and cleanup transition.
3. MSI rollback and repair evidence on every claimed Windows/installer profile without production keys.
4. TUF conformance and UAM-specific attack results at an exact pinned spec/client/conformance revision.
5. Reparse/TOCTOU/ACL/hard-link/ADS/DLL-search hostile results on every claimed filesystem/security profile.
6. N/N-1 compatibility and migration failpoints for every candidate storage change.
7. Role-by-role key compromise and independent root-threshold OOB recovery drill.
8. Two clean unsigned builds, final signed-file manifest, SBOM reconciliation, provenance subject verification, and same-digest ring promotion.
9. Privacy/secret/canary all-sink and metric-cardinality evidence.
10. Complete cleanup/revert receipts and assigned owner/runbook records.

---
# 12. ADR proposals

## 12.1 ADR register

| ADR | Decision | Proposed status | Alternatives | Evidence/owner/review trigger |
|---|---|---|---|---|
| ADR-011-001 | Enterprise MSI owns the stable privileged boundary; autonomous updater is disabled by default | **Accept** | monolithic updater; user-level updater; MSI-only forever | accepted baseline; Release/Endpoint Architecture; revisit only through section 4.2 gate |
| ADR-011-002 | Optional updater is split into low-privilege network Fetcher and no-network minimal privileged Activator | **Proposed, conditional** | SYSTEM downloader/extractor; enterprise-only | P11-02, updater decision; Windows Security owner; any privilege/API expansion |
| ADR-011-003 | Stable launchers execute only independently verified payloads from immutable version directories | **Accept** | in-place overwrite; current junction/symlink; direct staging execution | P11-02/P11-04; Bootstrap owner; filesystem/launcher change |
| ADR-011-004 | Use dual repository authorization and Authenticode | **Accept** | either TUF or Authenticode alone | E11-06/E11-07/E11-08; Release/Signing owners; signer/POUF change |
| ADR-011-005 | UAM repository follows TUF 1.0.35 with a published POUF and conformance gate | **Proposed, blocking for autonomous update** | appcast; custom TUF-like; enterprise-only | P11-03; Repository Security; TUF spec/client change |
| ADR-011-006 | Release order uses strictly increasing `releaseSequence`; emergency downgrade is higher sequence to known-good digest | **Accept** | semantic-version ordering; lower metadata rollback | E11-07/E11-11; Release owner; correction/repository model change |
| ADR-011-007 | A/B activation uses redundant complete state generations and retains previous through probation | **Accept logical model; CLI proof required** | single current file; registry pointer; in-place switch | P11-04; Runtime/Storage owners; state/filesystem change |
| ADR-011-008 | Privileged materialization copies from verified opened handles and rejects reparse/link/stream/path anomalies; no archive parser under SYSTEM | **Accept design; CLI proof required** | SYSTEM extraction; path-only checks | P11-02; Windows Security; package/filesystem/API change |
| ADR-011-009 | MSI transaction and product activation are separate; enterprise detection requires healthy target | **Accept** | candidate switch in custom action; MSI exit code as health | P11-01; Installer/Endpoint Management; deployment-tool change |
| ADR-011-010 | Autonomous releases require N/N-1 data compatibility; destructive epochs are enterprise maintenance | **Accept** | one-way autonomous migration | P11-05; Storage owner; persistence change |
| ADR-011-011 | Build supply chain uses two challenged unsigned builds, final-file/SBOM reconciliation, provenance subject checks, isolated digest-bound signing, same-digest promotion | **Accept** | one build; tool-only SBOM; rebuild per ring | P11-07; Build/Signing/Release; tool/platform change |
| ADR-011-012 | Role-purpose key separation and root-threshold OOB recovery are mandatory; exact crypto/threshold/custody are human-owned | **Accept invariants; defer profile** | one online key; in-band root recovery | P11-06; Cryptographic Authority; key/provider/POUF change |
| ADR-011-013 | Offline expiry/clock uncertainty blocks new activation but does not stop current known-good release | **Accept conservative rule; exact time policy deferred** | indefinite grace; stop current at expiry | E11-17; Security/Operations/Risk; trusted-time design evidence |
| ADR-011-014 | Bad-version suppression exists locally and in repository/enterprise control; retry requires higher generation and explicit authority | **Accept** | automatic same-version retries | E11-11; Runtime/Incident; health/suppression change |
| ADR-011-015 | Release observability is finite, value-free, low-cardinality; exact details are bounded protected evidence | **Accept** | dynamic version/device/path labels; raw logs | E11-19; SRE/Privacy; telemetry/support change |
| ADR-011-016 | MSI repair restores bootstrap/service/task/ACL/root and selects only verified current/previous/baseline; no data reset | **Accept** | reinstall-and-delete; trust activation pointer | E11-12; Installer/Storage; repair design change |
| ADR-011-017 | Previous-version cleanup is policy-owned and never occurs during activation; current and previous are protected from scavenging | **Accept principle; duration deferred** | immediate deletion | E11-09/E11-11; Product/SRE; disk/retention decision |
| ADR-011-018 | Updater authorization is a measured decision using management-attributable latency, not release frequency or convenience | **Accept** | build updater by default | P11-08/E11-18; Product/Risk/Management; SLA/coverage change |
| ADR-011-019 | Installer/updater OSS tools are admitted only after exact tag/commit, license/EULA, source/binary mapping, tests, security, fit, and removal evidence | **Accept** | popularity/default package choice | section 14 and E11-01/E11-14; Dependency/Legal; version/tool change |
| ADR-011-020 | Global release mutation lock serializes MSI repair/upgrade/uninstall with activator materialization/activation/cleanup | **Proposed; CLI proof required** | independent locks; optimistic conflict | E11-21; Installer/Runtime; concurrency/reboot change |

## 12.2 ADR details

### ADR-011-001 — Enterprise-first ownership

**Decision.** MSI and enterprise management own all stable privileged topology. Autonomous update is absent/disabled until the measured gate passes.

**Rationale.** This is the accepted baseline, minimizes privileged network/parser authority, and preserves independent repair/OOB control.

**Evidence.** I01, I03, I05; section 4.2 measurement.

**Owner.** Endpoint Architecture with Enterprise Management and Security.

**Review trigger.** Repeated approved patch-SLA misses attributable to management, not offline/network conditions.

### ADR-011-002 — Fetcher/Activator split

**Decision.** If authorized, network retrieval is low privilege; SYSTEM only performs a fixed no-network verify/copy/activate protocol.

**Rationale.** Separates hostile network/archive parsing from protected filesystem mutation and limits confused-deputy inputs.

**Smallest falsifier.** P11-02; any attacker-controlled final byte/path rejects the design.

**Migration.** Optional components remain MSI-owned. Disabling/removing autonomous update does not change payload/enterprise release compatibility.

### ADR-011-005 — TUF POUF

**Decision.** Autonomous repository resolution conforms to TUF 1.0.35 under a UAM POUF; no selective imitation.

**Alternatives.** Appcast/single key rejected; enterprise-only remains safe fallback.

**Evidence.** Official TUF specification/release and conformance suite [W17–W21].

**Stop.** No autonomous updater if a C# client/profile cannot pass conformance and UAM attack tests.

### ADR-011-007 — A/B activation

**Decision.** Complete redundant state generations, immutable current/previous/candidate directories, independent launcher verification, and health-bound known-good promotion.

**Rationale.** Preserves an operable known version across interruption without relying on a mutable path pointer.

**Stop.** Any failpoint that makes a pre-existing valid current/previous unavailable or executes a partial candidate.

### ADR-011-008 — Handle-based privileged copy

**Decision.** No archive parser under SYSTEM; verify and copy from opened source handles into exclusive protected destinations; reverify final objects.

**Rationale.** Contains reparse/TOCTOU and archive-parser risk.

**Stop.** Any path escape, attacker-chosen final byte, or unexplained filesystem behavior on a claimed environment.

### ADR-011-010 — N/N-1 compatibility

**Decision.** Autonomous release migrations are none or expand-only and bidirectionally compatible through rollback window.

**Rationale.** Code rollback without data rollback is unsafe when old code cannot read new state.

**Stop.** N-1 compatibility failure makes the release enterprise-maintenance-only.

### ADR-011-012 — Key hierarchy and OOB recovery

**Decision.** Role/purpose separation is fixed; exact production thresholds/algorithms/custody are human decisions; threshold-root compromise uses independent OOB trust.

**Rationale.** Prevents one online/service key from becoming universal code-install authority and avoids pretending compromised in-band root can recover itself.

**Stop.** No production signing/repository without assigned owners and exercised role-specific runbooks.

### ADR-011-018 — Measured updater gate

**Decision.** Updater need is established by a versioned causal latency dataset and approved SLA/coverage, plus security/ops/cost gates.

**Rationale.** Release frequency and intuition do not prove enterprise deployment is the bottleneck.

**Conservative default.** Enterprise-only.

---

# 13. Ordered implementation backlog with dependencies and stop gates

## 13.1 Critical path

| Order | Backlog item | Dependencies | Deliverable | Stop gate |
|---:|---|---|---|---|
| 1 | Record five-file evidence manifest and open ADRs/human-decision records | none | immutable input/source register; ADR files; owner templates | missing/extra Project input or silent baseline conflict |
| 2 | Assign accountable owner functions for installer, repository, signing, build, storage, endpoint management, support, incident | 1 | owner/escalation map | any safety-critical function unassigned before its gate |
| 3 | Define stable privileged-boundary object manifest | Batch 01 architecture | exact service/task/launcher/root/ACL/directory ownership contract | updater can mutate bootstrap topology |
| 4 | Add release contracts and strict schemas | contract foundations | target custom metadata, release manifest, activation, health, suppression, errors, evidence | unknown/duplicate/remote reference accepted; arbitrary path/command field |
| 5 | Implement deterministic T1 release/package/key/fault generator and independent oracle | 4, G0 foundations | good/bad/stale/tampered package corpus and expected state ledger | nondeterminism, production value/key, oracle common code |
| 6 | Select/evaluate MSI authoring tool in isolated lane | HD11-05, 3–5 | exact tool/source/binary/license record and minimal MSI | unresolved EULA/license/source mapping or unsafe tool behavior |
| 7 | Implement MSI with stable launchers, protected roots, service/task, baseline payload, repair/uninstall | 3–6 | test-signed MSI and static/ICE/custom guards | `AlwaysInstallElevated`, rollback disabled, dynamic SYSTEM command/path |
| 8 | Implement deep installed-boundary verifier and evidence CLI | 3–7 | file/signature/ACL/service/task/root/state verifier | verifier trusts path/name/pointer without bytes/identity |
| 9 | Implement isolated test-signing lane and Authenticode policy harness | 4–8 | good/wrong/expired/revoked/tampered matrix | valid signature alone authorizes target or wrong signer passes |
| 10 | Implement codec-neutral release repository models and UAM TUF POUF draft | 4–5 | role/profile/root/target custom metadata and publication model | ad hoc weakened TUF semantics |
| 11 | Select or implement C# TUF verifier prototype behind narrow interface | 10 | strict bounded verifier and persistent trusted metadata | cannot pass exact conformance/attack requirements; then updater stays disabled |
| 12 | Pin and run TUF conformance plus UAM attack corpus | 10–11 | immutable conformance/attack report | blocking failure or expected failure affecting UAM profile |
| 13 | Implement two-slot trusted metadata and activation/suppression state store | 4, 8, 10–12 | crash-tolerant local state library | torn/lower/conflicting state accepted |
| 14 | Implement stable Service/User Host launchers with full verification and safe process/module contract | 7–13, G1 contracts | launcher selects only verified immutable payload | staging/user-writable/reparse/unlisted module execution |
| 15 | Implement low-privilege release fetcher prototype, administratively disabled | 10–13 | bounded metadata/target fetch and untrusted staging | machine mutation, central credential, arbitrary URL/destination, execution |
| 16 | Implement strict low-privilege package extractor and staging manifest | 5, 15 | hostile archive corpus and bounded extraction | path escape/collision/stream/link/resource failure |
| 17 | Implement minimal no-network Release Activator with fixed IPC | 3–16 | handle-based verify/copy/seal/state operations | general archive/network/script/path/command or bootstrap mutation |
| 18 | Implement global release mutation lock shared with MSI helper/repair | 7, 17 | concurrent operation model | mixed/deadlocked state under kill/reboot |
| 19 | Implement candidate launch, health proof, probation, rollback, suppression | 13–18 | A/B state machine and hooks | health replay, partial execution, failed candidate loop |
| 20 | Implement release/storage compatibility declaration and test harness | G5/storage contract, 4, 19 | N/N-1 matrix and migration classification | autonomous candidate cannot prove rollback compatibility |
| 21 | Implement build R2, final file manifest, signing attestation, package build | Batch 01 build controls, 5–20 | reproducible unsigned payload and final signed package chain | unexplained difference or signer mutates unapproved input |
| 22 | Implement SBOM/provenance generation and independent reconciliation | 21 | final-file/lock/SBOM/provenance report | omitted component/subject mismatch/unresolved license |
| 23 | Implement TUF repository publisher and immutable same-digest ring promotion | 10–12, 21–22 | targets/snapshot/timestamp publication transaction | timestamp before content, mutable overwrite, per-ring byte drift |
| 24 | Implement finite release observability/support CLI and all-sink canaries | 4, 8–23 | stable codes, bounded evidence, cardinality lint | path/URL/device/activity/secret leak or unbounded label |
| 25 | Prepare disconnected placeholder-only Windows lab scripts | 5–24 | inventory/install/trace/fault/cleanup scripts | connection/user/host/key/credential/production value appears |
| 26 | Obtain approved supported Windows/installer/filesystem/security lab matrix | HD11-02/05/07/09 | named capability list | unsupported/unknown environment treated as passed |
| 27 | Run MSI install/upgrade/repair/uninstall and effective-boundary campaigns | 25–26 | E11-03–E11-05 evidence | rollback/repair/ACL/service/task primary failure |
| 28 | Run Authenticode/TUF/package/reparse/TOCTOU/A-B/DLL campaigns | 25–27 | E11-06–E11-13 evidence | any unauthorized/incomplete execution or privileged path/byte escape |
| 29 | Run supply-chain, ring, compatibility, offline, privacy campaigns | 20–28 | E11-14–E11-19 evidence | subject/SBOM/ring/N-1/stale/privacy primary failure |
| 30 | Exercise role-by-role compromise, OOB repair, concurrency, disk/I/O runbooks | 18–29 | E11-20–E11-21 plus TM11-22 evidence | missing recovery path, in-band root-threshold claim, mixed mutation state |
| 31 | Aggregate technical release/update gate for `ENTERPRISE_ONLY` | 1–30 | immutable `release-update-gate.json` | any primary failure/owner/ADR missing |
| 32 | Integrate signed MSI into enterprise-management synthetic ring | passed 31, enterprise tool owner | install/health/remediation/detection evidence | enterprise deployment cannot preserve/repair known version |
| 33 | Measure representative enterprise deployment latency/coverage | production-safe metadata contract and human approval | versioned causal measurements, no raw activity | no approved SLA/coverage or cause classification |
| 34 | Decide whether updater is needed | 31–33 and HD11-01/02/08/16/17 | signed human decision record | any section 4.2 term false/unknown -> remain enterprise-only |
| 35 | If rejected, keep fetcher/activator disabled or omit from production MSI | 34 | reduced production attack surface | updater accidentally enabled |
| 36 | If conditionally approved, run limited updater pilot with same full security gate | 34 plus network/identity decisions | pilot evidence and rollback/OOB drill | one primary invariant failure or no material latency benefit |
| 37 | Production approval decision | all applicable gates and human decisions | designated go/no-go record | technical evidence alone cannot authorize production |

## 13.2 Parallel work

After section 13 items 3–5, these may run in parallel:

- MSI tool evaluation and minimal package;
- pure TUF POUF/client/conformance work;
- activation-state/failpoint model;
- T1 package/archive/race corpus;
- build/SBOM/provenance tool bake-off;
- enterprise latency measurement schema/oracle;
- disconnected lab script preparation.

These may not be pulled forward:

- production keys/signing;
- network-connected updater tests before approved network/identity/lab scope;
- autonomous activation before TUF, filesystem, A/B, N/N-1, and key recovery gates;
- incompatible migrations before enterprise maintenance design;
- per-ring rebuilds or tenant-specific binaries without a baseline/realm ADR;
- pilot/production before owner, risk, cost, SLA, support, and emergency decisions.

## 13.3 Stop/go gates

1. **GO now** for pure contracts, fictional packages/keys, POUF/client prototype, MSI/tool bake-off, repository/build controls, and disconnected scripts.
2. **STOP** before any Windows claim until a named disposable lab environment is inventoried and approved.
3. **GO to MSI lab** only with test-signed artifacts and no production keys/data.
4. **STOP** on any rollback/repair/ACL/service/task/path/DLL primary failure.
5. **GO to optional updater prototype** only after stable launcher/MSI boundary passes and updater remains administratively disabled.
6. **STOP** on one unauthorized/incomplete/stale/frozen/downgraded execution, privileged path escape, or missing known-version recovery.
7. **GO to technical enterprise release gate** after all role/supply-chain/compatibility/offline/privacy tests pass.
8. **STOP updater decision** unless a human-approved SLA/coverage and representative management-attributable miss exist.
9. **GO to updater pilot** only if the full decision expression passes and assigned support/emergency/OOB paths exist.
10. **STOP before production** until designated human risk/production authority approves. There is no silent risk acceptance in code, configuration, installer properties, or expired exceptions.

---

# 14. Open-source repository assessment table

## 14.1 Admission rule

**RECOMMENDATION.** Open-source projects in this section are design evidence and implementation inputs, not automatic dependencies. A repository may enter a UAM trusted build, signing, installer, repository, or endpoint path only when an admission record establishes all of the following for the exact revision actually used:

1. immutable tag or full commit and package/binary-to-source mapping;
2. license, notices, EULA, maintenance-fee, patent, and redistribution review;
3. supported runtime/OS/toolchain and removal/rollback path;
4. recent maintenance, release cadence, security policy/advisory handling, and issue ownership;
5. unit, integration, negative, fuzz/conformance, and release tests relevant to UAM's use;
6. no network, telemetry, dynamic download, plugin, script, or broad authority beyond the admitted interface;
7. exact SBOM/provenance inclusion and final-file reconciliation;
8. a UAM threat-model comparison, not a popularity comparison;
9. positive and negative controls proving that the tool fails closed for UAM's required invariant; and
10. an accountable dependency owner with a review trigger for release, advisory, license, maintainer, or platform change.

A project classified **reference only** contributes ideas, fixtures, or threat cases. Its source, package, service, executable, or runtime is not approved. A project classified **candidate after admission** may be evaluated in an isolated trusted lane but is not selected. **Neither** means that the reviewed architecture/revision is too stale or mismatched to justify further work for this topic.

## 14.2 TUF specification, clients, and conformance

| Project, exact revision, repository, and reviewed areas | License and maintenance | Tests/security posture | Similarities, differences, reusable ideas, and do-not-copy rules | UAM suitability |
|---|---|---|---|---|
| **TUF specification `v1.0.35`**, released 15 July 2026. Repository: [theupdateframework/specification](https://github.com/theupdateframework/specification/tree/v1.0.35). Relevant: [`tuf-spec.md`](https://github.com/theupdateframework/specification/blob/v1.0.35/tuf-spec.md), `taps/`, `json-schema/`, release workflows and published specification rendering. | Community Specification License 1.0 for the specification; this is a standards license, not a software-library license. The tagged specification was current at the research date and the rendered document is dated 15 July 2026. | Versioned normative text, schema and release automation exist. A specification cannot test UAM's implementation, storage, clock, network, or incident behavior. | **Reuse:** complete client workflow, role separation, threshold rules, version and expiry checks, consistent snapshots, target length/hash, sequential root updates, rollback/freeze/mix-and-match defenses, and explicit root-compromise recovery assumptions. **Do not copy selectively:** naming four files “TUF” without persistent trusted state and the prescribed workflow loses the security argument. UAM must publish a POUF and conformance evidence. | **Normative reference.** Required design basis for any autonomous repository. Not an endpoint dependency. [W17–W18] |
| **python-tuf `v7.0.0`**, commit `353bdb7`, released 18 May 2026. Repository: [theupdateframework/python-tuf](https://github.com/theupdateframework/python-tuf/tree/v7.0.0). Relevant: `tuf/ngclient/`, `tuf/api/metadata.py`, `tests/`, `docs/`. | Dual Apache-2.0/MIT. Actively maintained. The reviewed release fixed GHSA-qp9x-wp8f-qgjj, an incorrect delegation-path-matching issue on Windows, and made bootstrap intent clearer. | Substantial unit/integration tests, documentation, CI, and a security process. The Windows path advisory is directly relevant evidence that target-path semantics need hostile platform tests. | **Reuse:** updater workflow structure, trusted-metadata persistence, error taxonomy, delegation/path attack tests, and bootstrap-root discipline. **Do not copy:** Python runtime/service packaging, general delegation features UAM does not need, or endpoint-side dynamic extensibility. Its platform/runtime and operational surface differ from a minimal C# Windows service payload activator. | **Reference and conformance oracle; not selected as endpoint dependency.** It may run in sealed T1 test lanes. An isolated helper would require a separate ADR proving lower total risk than a conformant C# implementation. [W19] |
| **go-tuf `v2.4.2`**, released 19 May 2026; tagged release reviewed with updater package at `metadata/updater/`. Repository: [theupdateframework/go-tuf](https://github.com/theupdateframework/go-tuf/tree/v2.4.2). Relevant: `metadata/`, `metadata/updater/`, `metadata/trustedmetadata/`, repository tooling and tests. | Apache-2.0. Actively maintained. The v2.4 line includes stricter validation and security-relevant fixes; the reviewed project publishes a current-version security policy rather than promising retrospective fixes for old versions. | Unit and integration coverage, signed releases, dependency updates, client/repository APIs and public security reporting. Exact UAM-relevant expected failures still require the conformance suite and attack corpus. | **Reuse:** typed metadata model, trusted metadata state separation, consistent-snapshot handling, target verification, and test cases for malformed hashes/threshold counting. **Do not copy:** Go runtime/FFI, repository authoring authority in the endpoint, broad delegation support, or assumptions about POSIX path behavior. | **Reference and independent behavioral comparator; not selected as endpoint dependency.** May run in isolated T1 tests. [W20] |
| **tuf-conformance**, mutable `main` reviewed 31 July 2026; exact commit was not recorded in the available evidence. Repository: [theupdateframework/tuf-conformance](https://github.com/theupdateframework/tuf-conformance). Relevant: `tuf_conformance/`, `clients/`, `CLIENT-CLI.md`, `action.yml`, `SECURITY.md`, and conformance report. | MIT. Active repository with 509 commits shown at review time, CI/action integration, development and release instructions, and a security policy. **Provenance gap:** a moving branch is not acceptable release evidence. | Tests multiple clients against a common CLI protocol; supports expected failures, local pytest execution, lints, and included python-tuf/go-tuf clients. It improves interoperability but does not cover UAM's Windows filesystem, Authenticode, package, activation, realm, or incident requirements. | **Reuse:** exact client-under-test CLI, cross-client fixtures, expected-failure discipline, clock manipulation, and reproducible conformance reporting. **Do not copy:** mutable major action tags or accept an expected failure merely because another client lists it. Every expected failure must be justified against the UAM POUF and threat model. | **Blocking test input only after pinning an exact full commit and dependencies. NO-GO at the mutable revision recorded here.** [W21] |

### 14.2.1 TUF dependency conclusion

**RECOMMENDATION.** Do not embed Python or Go solely to obtain TUF. First implement or select a narrowly scoped C# verifier whose public interface is limited to bootstrap, metadata refresh, target resolution, and exact target verification. Run it against a pinned `tuf-conformance` revision, python-tuf and go-tuf behavioral comparisons, and the UAM Windows/path/clock/root-rotation corpus. If no C# implementation can pass, autonomous update stays disabled; failure is not permission to weaken the protocol.

## 14.3 MSI authoring and Windows updater references

| Project, exact revision, repository, and reviewed areas | License and maintenance | Tests/security posture | Similarities, differences, reusable ideas, and do-not-copy rules | UAM suitability |
|---|---|---|---|---|
| **WiX Toolset `v7.0.0`**, commit `b8977d6`, published 6 April 2026. Repository: [wixtoolset/wix](https://github.com/wixtoolset/wix/tree/v7.0.0). Relevant: `src/wix/`, `src/ext/`, `src/burn/`, `src/test/`, SDK/build tooling, installer test infrastructure. | Source is Microsoft Reciprocal License (MS-RL), with file-level reciprocal conditions. The binary release is also subject to the Open Source Maintenance Fee EULA; source license and binary-use terms are not interchangeable. Active annual release line and issue tracking. | Mature compiler/linker/extensions, extensive installer tests, security/release practices and a long Windows Installer history. Its broad surface, Burn bootstrapper, extensions, custom actions and binary tooling create supply-chain and procurement obligations. | **Reuse:** declarative MSI tables, component/key-path discipline, service/task/upgrade authoring patterns, ICE/static validation, test infrastructure, and deterministic source authoring. **Do not copy:** Burn as an autonomous SYSTEM updater, arbitrary custom actions, immediate impersonation assumptions, bundled online download behavior, or broad extension admission. UAM needs an MSI, not an installer framework with unbounded runtime authority. | **Leading installer-tool candidate after Legal/Procurement and exact binary/source admission.** No selection is made here. Building from source does not remove MS-RL obligations; consuming binaries does not avoid the OSMF EULA. [W28] |
| **WixSharp `v2.14.1.0`**, commit `a40d106`, released 5 July 2026. Repository: [oleg-shilo/wixsharp](https://github.com/oleg-shilo/wixsharp/tree/v2.14.1.0). Relevant: `Source/`, examples, compiler/generator code, tests and WiX integration. | MIT for WixSharp; generated installer and underlying WiX tooling still carry their own terms. Active 2026 release and issue fixes, including migration/tooling issues. | Useful C# authoring examples and tests; the repository page showed no dedicated GitHub security feature at review time. Generated authoring can hide MSI table behavior unless UAM validates the emitted MSI directly. | **Reuse:** typed/C# generation concepts, deterministic source generation, small installer examples. **Do not copy:** treat the DSL as the authority, emit opaque custom actions, or assume C# authoring makes MSI semantics safe. The emitted MSI tables, binary custom-action payloads, signatures, ICE results and rollback behavior remain the oracle. | **Build-time candidate or reference only after WiX decision.** Adds another generator/dependency and is not needed if direct WiX authoring remains reviewable. [W29] |
| **Velopack `1.2.0`**, commit `f2edcbc`, released 3 June 2026. Repository: [velopack/velopack](https://github.com/velopack/velopack/tree/1.2.0). Relevant: `src/`, `test/`, packaging, locator, update and delta logic. | MIT. Active cross-platform project; the reviewed release included validation and updater fixes. | Maintained test/release automation and practical update lifecycle coverage. GitHub showed no dedicated security-policy surface at review time. Its cross-platform/user-application focus and broad packaging/update behavior differ materially from UAM's MSI-owned machine boundary. | **Reuse:** side-by-side package lifecycle, staging/locator failure tests, rollback UX ideas, and version suppression cases. **Do not copy:** self-owned install root, application-controlled bootstrap, delta packages, arbitrary process restart, broad package formats, network-to-execution path, or assumption that app ownership equals machine-service authority. | **Reference only.** Direct dependency would import more authority than UAM permits and does not supply TUF role semantics or MSI repair ownership. [W30] |
| **NetSparkleUpdater `3.1.0`**, commit `b3df04a`, released 5 May 2026. Repository: [NetSparkleUpdater/NetSparkle](https://github.com/NetSparkleUpdater/NetSparkle/tree/3.1.0). Relevant: `src/`, downloader/appcast/signature code, `TestAppFiles/`, UI integrations and appcast generator. | MIT. Maintained, with .NET 10 compatibility in the reviewed release. | Tests and sample applications cover appcast parsing, download and UI flows. The project page showed no dedicated security policy at review time. Appcast and application-UI semantics do not provide TUF threshold/root/snapshot/timestamp recovery. | **Reuse:** malformed-feed/download tests, finite UI/state messaging, signature-failure and cancellation scenarios. **Do not copy:** single-feed authorization, interactive user approval as machine authorization, downloader logging, general installer execution, or application-managed privilege. | **Reference only.** Suitable as a source of negative feed/UI tests, not as UAM's release authority or endpoint updater dependency. [W31] |
| **WinSparkle `v0.9.4`**, commit `a8986ca`, released 21 July 2026. Repository: [vslavik/winsparkle](https://github.com/vslavik/winsparkle/tree/v0.9.4). Relevant: `src/`, `include/`, `tests/`, `examples/`, `winsparkle-tool/`, appcast and signature handling. | MIT, with bundled/third-party notice obligations including OpenSSL-related text. Actively released in July 2026. | Native Windows code, tests/examples, appcast tooling and release activity. The repository page showed no dedicated security feature at review time. Its desktop application update model and cryptographic/feed assumptions differ from UAM's service payload, TUF and enterprise boundary. | **Reuse:** Windows-native download/cancellation/UI edge cases, appcast parser attacks, signature-failure fixtures. **Do not copy:** app-owned update loop, broad DLL integration, feed as sole authority, automatic interactive prompts, or updater-owned install topology. | **Reference only.** Not a dependency candidate for the privileged UAM path. [W32] |
| **Squirrel.Windows `2.0.1`**, commit `eef3746`, released 27 September 2020. Repository: [Squirrel/Squirrel.Windows](https://github.com/Squirrel/Squirrel.Windows/tree/2.0.1). Relevant: `src/`, `test/`, packaging/update logic. | MIT. The reviewed stable release is nearly six years old relative to the research date; open issues and pull requests do not replace a maintained supported release. | Historically substantial updater logic and tests, but the stable maintenance point is too old for a new 2026 machine-service trust boundary. | **Reuse:** historical side-by-side/app activation and failure cases only. **Do not copy:** user-local install/update ownership, NuGet package semantics, shortcut/process management, delta assumptions, or stale platform behavior. | **Neither as dependency; historical reference only where a specific test idea is independently reimplemented.** [W33] |

### 14.3.1 Installer/updater conclusion

**RECOMMENDATION.** Evaluate WiX and, optionally, WixSharp solely as MSI build tools. Do not adopt Velopack, NetSparkle, WinSparkle, or Squirrel as the release authority or privileged updater. Their useful material is failure cases and lifecycle tests, not their trust boundary. UAM's combination—enterprise-owned MSI bootstrap, constrained offline activator, TUF repository authorization, Authenticode, and N/N-1 rollback—is materially narrower and must remain explicit.

## 14.4 Sigstore, in-toto, SLSA, and SBOM tooling

| Project, exact revision, repository, and reviewed areas | License and maintenance | Tests/security posture | Similarities, differences, reusable ideas, and do-not-copy rules | UAM suitability |
|---|---|---|---|---|
| **cosign `v3.1.2`**, commit `193d215`, released 17 July 2026. Repository: [sigstore/cosign](https://github.com/sigstore/cosign/tree/v3.1.2). Relevant: `cmd/cosign/`, `pkg/cosign/`, bundle, verification, key/KMS and test/release workflows. | Apache-2.0. Very active; signed release, public security-quality features and frequent security/compatibility fixes. The release notes signal upcoming v4 removals, so interface stability must be treated explicitly. | Extensive tests, security reporting, bundle verification and release hardening. Large Go/OCI/KMS/transparency surface; many features are irrelevant to MSI/PE endpoint activation. | **Reuse:** immutable bundle/attestation verification, subject-digest checks, isolated signing CLI patterns, identity constraints, negative malformed-bundle tests. **Do not copy:** OCI registry as endpoint repository by default, keyless online identity as the only recovery model, broad KMS plugins in endpoint code, or cosign as a replacement for Authenticode/TUF. | **Trusted build/signing-tool candidate after exact binary/source admission; reference only for endpoint architecture.** Use only a bounded offline verification/signing workflow if selected. [W24] |
| **in-toto-golang `v0.11.0`**, commit `36d782f`, released 4 May 2026. Repository: [in-toto/in-toto-golang](https://github.com/in-toto/in-toto-golang/tree/v0.11.0). Relevant: `in_toto/`, `runlib/`, `verifylib/`, `cmd/`, metadata/link/layout tests. | Apache-2.0. Active signed release and security-quality features. The reviewed line includes security-relevant pattern-processing fixes, reinforcing the need for exact version review. | Unit/integration tests, layout/link verification and command tooling. It is a supply-chain attestation implementation, not a Windows release activator or TUF client. | **Reuse:** subject/material digest binding, step/functionary separation, threshold layout ideas, and policy verification tests. **Do not copy:** arbitrary command execution in a signing lane, broad glob/path semantics, or assume a valid in-toto layout proves binary safety or reproducibility. | **Build/provenance reference or isolated tool candidate.** Not an endpoint dependency. [W25] |
| **SLSA GitHub Generator `v2.1.0`**, commit `f7dd8c5`, released 24 February 2025. Repository: [slsa-framework/slsa-github-generator](https://github.com/slsa-framework/slsa-github-generator/tree/v2.1.0). Relevant: reusable workflows, `internal/builders/`, `internal/generator/`, adversarial/e2e tests and release documentation. | Apache-2.0. Maintained but platform-specific; release age and later workflow/module issues require exact revalidation at adoption. | Strong reusable-workflow, adversarial and provenance-generation tests. Security rests on GitHub Actions identities, reusable workflows and platform controls, which have no authority unless GitHub is selected. | **Reuse:** isolated builder/generator pattern, unforgeable subject/material binding goals, adversarial provenance tests. **Do not copy:** mutable action tags, platform assumptions in architecture, or claim a SLSA level without satisfying the current specification and verifying the actual builder. | **Platform adapter candidate only if GitHub Actions is the approved trusted build platform.** Otherwise reference only. [W22, W26] |
| **Microsoft SBOM Tool `v4.1.5`**, commit `c83b43dee2dd70b4d6ba16a97cde6b43f971d9c3`, released 15 December 2025. Repository: [microsoft/sbom-tool](https://github.com/microsoft/sbom-tool/tree/c83b43dee2dd70b4d6ba16a97cde6b43f971d9c3). Relevant: `src/`, component detectors, manifest generation, validation and tests. | MIT. Maintained Microsoft project; the reviewed release updated component detection and fixed build/release issues. | Tests and release artifacts exist. GitHub showed no dedicated repository security feature at review time. Component detection cannot observe every native, generated, bundled, dynamically loaded, license, or transitive condition. | **Reuse:** SPDX generation, package/file scanning, validation, deterministic CLI evidence. **Do not copy:** treat tool exit zero or generated SBOM as completeness; trust an online component detector without sealed inputs; or omit shipped bytes not recognized as packages. | **SBOM tool candidate after exact binary/source/egress test.** Mandatory independent final-file and lock-graph reconciliation remains authoritative. [W27] |

## 14.5 Consolidated repository decision

| Need | Selected direction | Candidate dependency status | Required next evidence |
|---|---|---|---|
| Update security model | TUF specification 1.0.35 plus UAM POUF | normative reference | approved POUF and role/key/expiry human decisions |
| TUF client | narrow C# verifier or separately justified isolated helper | **UNKNOWN; no dependency selected** | exact source/package review, pinned conformance, UAM attack corpus, persistent-state failpoints |
| Installer authoring | MSI; evaluate WiX v7 and optionally WixSharp | candidate after Legal/Procurement/admission | emitted MSI table/static/ICE review, reproducibility, rollback/repair lab evidence |
| Privileged updater | UAM minimal Release Activator | custom narrow component; no general updater dependency selected | filesystem/reparse/ACL/activation/health/compatibility proof |
| Feed/app updater | none | NetSparkle/WinSparkle/Velopack reference only; Squirrel neither | no reconsideration without a full trust-boundary ADR |
| Provenance | in-toto/SLSA-compatible subject/material attestations | exact tool/platform not selected | builder-platform decision, adversarial verification, same-digest promotion |
| Artifact signing helper | isolated signer; Authenticode remains Windows executable policy | cosign is optional build-tool candidate only | exact offline use, key service, bundle/profile and license/security review |
| SBOM | final-file inventory plus SPDX SBOM and lock reconciliation | SBOM Tool is one candidate | positive-control omissions, native/generated/bundled file reconciliation, legal review |

**RECOMMENDATION.** Keep the trusted endpoint dependency set smaller than the reference set. A direct dependency is justified only where it reduces assurance work after accounting for parser surface, runtime, installer, incident, patch, license, and operator costs. Popularity is not an admission criterion.

---

# 15. Source register with stable links, dates, versions, claims, and limitations

## 15.1 Allowlisted project sources

| Ref | Source and reviewed identity | Claim supported | Limitation |
|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md`, baseline date 31 July 2026, SHA-256 `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Stable privileged MSI/enterprise boundary; unauthorized/incomplete/stale/frozen/downgraded release never executes; N/N-1 and exact mechanisms remain gated. | Condensed accepted research baseline, not legal, budget, operational, pilot, or production approval. |
| I02 | `03-sanitized-windows-lab-capability.md`, reviewed 31 July 2026, SHA-256 `8da73d913e7f1b01d943e4c8b0ed7bb2722571ff6a3a20cef0b8f47738a4658f` | A placeholder-based Windows lab connection path exists. | Proves no OS/build, privilege, MSI, proxy, EDR, filesystem, signing, service, task, or updater behavior; connection details are deliberately excluded. |
| I03 | `05-decisions-contradictions-and-gates.md`, July 2026 synthesis, SHA-256 `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | Release/update authorization and rollback is ordered proof gate 7; MSI/enterprise management owns stable boundary. | Implementation research authority only; passing one gate proves only its stated claim. |
| I04 | `06-research-evidence-rules.md`, SHA-256 `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | Evidence labels, source quality, human-decision boundary, conflict/change discipline. | Research-governance rules, not evidence that a technical mechanism works. |
| I05 | `result-review-01-foundations.md`, review date 31 July 2026, local attachment `batch-01-review-result(3).md`, SHA-256 `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | Monorepo boundaries, locked inputs, untrusted/trusted CI separation, real Windows proof, R2 builds, SBOM/provenance reconciliation, separate signing and same-digest promotion. | Accepted foundation with mandatory conditions; no production signing, deployment, updater, or numeric budget approval. |

## 15.2 Microsoft Windows Installer, Authenticode, and filesystem sources

| Ref | Primary source, document date/version reviewed | Claim supported | Limitation |
|---|---|---|---|
| W01 | Microsoft Learn, [Rollback Installation](https://learn.microsoft.com/en-us/windows/win32/msi/rollback-installation), living Windows Installer documentation reviewed 31 July 2026 | Windows Installer can generate and run a rollback script for transactional changes; rollback must remain enabled for the release gate. | Does not make arbitrary deferred custom actions transactional or prove UAM package rollback under enterprise policy. |
| W02 | Microsoft Learn, [Command-Line Options](https://learn.microsoft.com/en-us/windows/win32/msi/command-line-options), living documentation reviewed 31 July 2026 | `msiexec` install, uninstall, administrative and repair modes; basis for deterministic repair/uninstall experiments. | Tool syntax is not an enterprise deployment design or proof of component/key-path correctness. |
| W03 | Microsoft Learn, [Rollback Custom Actions](https://learn.microsoft.com/en-us/windows/win32/msi/rollback-custom-actions), living documentation reviewed 31 July 2026 | A deferred mutating custom action needs a paired rollback action and careful sequencing when declarative tables cannot express the change. | Custom actions remain high risk; documentation does not justify their use or make external effects atomic. |
| W04 | Microsoft Learn, [Windows Installer Best Practices](https://learn.microsoft.com/en-us/windows/win32/msi/windows-installer-best-practices), living documentation reviewed 31 July 2026 | Avoid fragile custom actions, preserve installer security, use supported tables/repair semantics and validate packages. | General guidance; exact product/component/upgrade authoring requires emitted-MSI review and lab proof. |
| W05 | Microsoft Learn, [AlwaysInstallElevated](https://learn.microsoft.com/en-us/windows/win32/msi/alwaysinstallelevated), living documentation reviewed 31 July 2026 | Enabling this policy is a serious elevation risk; UAM lab/production gate requires it not to authorize untrusted MSI elevation. | Enterprise policy state must be measured; documentation cannot enforce it. |
| W06 | Microsoft Learn, [DisableRollback](https://learn.microsoft.com/en-us/windows/win32/msi/disablerollback), living documentation reviewed 31 July 2026 | Installer policy/property can disable rollback; UAM must detect and reject an environment/package mode that removes required recovery. | A successful MSI with rollback enabled still may leave non-MSI external effects unless tested. |
| W07 | Microsoft Learn, [ServiceInstall Table](https://learn.microsoft.com/en-us/windows/win32/msi/serviceinstall-table) and [ServiceControl Table](https://learn.microsoft.com/en-us/windows/win32/msi/servicecontrol-table), living documentation reviewed 31 July 2026 | Declarative service install/control ownership belongs in MSI where possible. | Does not prove service token, SID, privileges, executable ACLs, launchers, or third-party tool behavior. |
| W08 | Microsoft Learn, [RemoveExistingProducts Action](https://learn.microsoft.com/en-us/windows/win32/msi/removeexistingproducts-action) and [Upgrade Table](https://learn.microsoft.com/en-us/windows/win32/msi/upgrade-table), living documentation reviewed 31 July 2026 | Major-upgrade sequencing affects rollback, component state and removal; UAM must choose/test one deliberate strategy. | No universal safe sequence; exact product/component authoring and interruption behavior are CLI evidence. |
| W09 | Microsoft Learn, [`WinVerifyTrust`](https://learn.microsoft.com/en-us/windows/win32/api/wintrust/nf-wintrust-winverifytrust), updated 12 October 2021, reviewed 31 July 2026 | Windows trust-provider API can verify an Authenticode trust decision for a file under a selected policy/state. | A success result does not prove UAM repository authorization, manifest completeness, benign code, revocation availability, or loaded-module identity. |
| W10 | Microsoft Learn, [SignTool](https://learn.microsoft.com/en-us/windows/win32/seccrypto/signtool) and [PE Format](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format), living documentation reviewed 31 July 2026 | Authenticode signing/verification and PE certificate-table model; supports signer-policy tests and explains why repository whole-file hashes remain a separate authorization layer. | Exact certificate, digest, timestamp and revocation policy are human/security decisions and execution-time evidence. |
| W11 | Microsoft Learn, [`CreateFileW`](https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilew), reviewed 31 July 2026 | `FILE_FLAG_OPEN_REPARSE_POINT`, no-share/handle semantics and object opening are ingredients for reparse-resistant verification/copy. | Flags alone do not prevent all races, hard links, filter-driver behavior or later path replacement. |
| W12 | Microsoft Learn, [`GetFinalPathNameByHandleW`](https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-getfinalpathnamebyhandlew), reviewed 31 July 2026 | Final path is derived from the opened object, allowing root-containment verification after handle acquisition. | Path format/namespace handling and filesystem behavior require normalization and hostile tests. |
| W13 | Microsoft Learn, [`GetFileInformationByHandleEx`](https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-getfileinformationbyhandleex) and [`FILE_ID_INFO`](https://learn.microsoft.com/en-us/windows/win32/api/winbase/ns-winbase-file_id_info), reviewed 31 July 2026 | Open-handle file identity can bind copy/verify state and detect object substitution within the tested operation. | File IDs are not eternal global identifiers and do not replace content hashing or held-handle discipline. |
| W14 | Microsoft Learn, [`FlushFileBuffers`](https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-flushfilebuffers), reviewed 31 July 2026 | Explicit durability boundary for file writes before state publication. | Flush success does not prove storage hardware persistence or atomic multi-file commit; power-loss experiments remain required. |
| W15 | Microsoft Learn, [`MoveFileExW`](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-movefileexw), reviewed 31 July 2026 | Same-volume rename/replace primitives can support versioned state-file publication under a tested profile. | Exact atomicity/durability under filters, filesystem, crash and replacement flags is not a universal guarantee. |
| W16 | Microsoft Learn, [Automatic Propagation of Inheritable ACEs](https://learn.microsoft.com/en-us/windows/win32/secauthz/automatic-propagation-of-inheritable-aces), reviewed 31 July 2026 | ACL inheritance and protected-DACL behavior must be controlled rather than assumed; supports effective ACL/child-object tests. | Does not prove actual MSI-emitted ACLs, owner, hard-link/reparse permissions, or enterprise policy effects. |

## 15.3 TUF, SLSA, in-toto, and open-source release sources

| Ref | Primary/repository source, date/version reviewed | Claim supported | Limitation |
|---|---|---|---|
| W17 | The Update Framework, [Specification `v1.0.35`](https://theupdateframework.github.io/specification/v1.0.35/), dated 15 July 2026 | Normative root/targets/snapshot/timestamp workflow, thresholds, expiration, rollback/freeze/mix-and-match protection, consistent snapshots, target length/hash and root-compromise guidance. | TUF does not supply Windows code signing, package extraction safety, filesystem activation, health proof, N/N-1 migration, or UAM implementation correctness. |
| W18 | TUF specification repository, [release/tag `v1.0.35`](https://github.com/theupdateframework/specification/releases/tag/v1.0.35), released 15 July 2026 | Exact version/release provenance and maintained specification source. | Community Specification License applies to the specification; no software dependency is thereby admitted. |
| W19 | python-tuf, [release `v7.0.0`](https://github.com/theupdateframework/python-tuf/releases/tag/v7.0.0), commit `353bdb7`, released 18 May 2026 | Maintained client implementation, Windows delegation-path advisory fix, bootstrap and updater reference behavior. | Python implementation/runtime differs from UAM; reference/conformance use does not prove C# client correctness. |
| W20 | go-tuf, [release `v2.4.2`](https://github.com/theupdateframework/go-tuf/releases/tag/v2.4.2), released 19 May 2026 | Maintained independent implementation and updater/trusted-metadata reference. | Go implementation/runtime differs from UAM; exact short/full commit must be captured in the dependency record if executed. |
| W21 | TUF, [tuf-conformance repository](https://github.com/theupdateframework/tuf-conformance), mutable `main` reviewed 31 July 2026 | Cross-client conformance suite, CLI protocol, expected-failure mechanism and included comparison clients. | Exact commit was not captured; it is not admissible release evidence until pinned. Conformance is necessary but not sufficient for UAM. |
| W22 | SLSA, [Supply-chain Levels for Software Artifacts specification `v1.2`](https://slsa.dev/spec/v1.2/), approved 24 November 2025 | Current reviewed provenance/build-track concepts, builder identity and verification expectations. | SLSA does not select a platform/tool, prove source correctness, or replace UAM's final-file/signing/ring evidence. |
| W23 | in-toto, [Attestation Framework](https://github.com/in-toto/attestation) and [release predicate](https://github.com/in-toto/attestation/blob/main/spec/predicates/release.md), current repository reviewed 31 July 2026 | Standard subject/predicate envelope and release/provenance vocabulary. | Mutable repository references must be pinned when implemented; a valid attestation proves only its stated, verified predicate. |
| W24 | sigstore/cosign, [release `v3.1.2`](https://github.com/sigstore/cosign/releases/tag/v3.1.2), commit `193d215`, released 17 July 2026 | Maintained signing/bundle verification tool and security/release activity. | Large OCI/KMS/transparency feature set; not an endpoint TUF or Authenticode replacement. |
| W25 | in-toto-golang, [release `v0.11.0`](https://github.com/in-toto/in-toto-golang/releases/tag/v0.11.0), commit `36d782f`, released 4 May 2026 | Maintained in-toto layout/link verification implementation and tests. | Go/tooling surface; may be reference/tool only and does not prove reproducibility or code safety. |
| W26 | SLSA GitHub Generator, [release `v2.1.0`](https://github.com/slsa-framework/slsa-github-generator/releases/tag/v2.1.0), commit `f7dd8c5`, released 24 February 2025 | Reusable-workflow builder/generator separation and adversarial provenance tests. | GitHub-specific and older than the research date; exact current platform compatibility and later issues must be re-reviewed. |
| W27 | Microsoft SBOM Tool, [release `v4.1.5`](https://github.com/microsoft/sbom-tool/releases/tag/v4.1.5), full commit `c83b43dee2dd70b4d6ba16a97cde6b43f971d9c3`, released 15 December 2025 | SPDX SBOM generation/validation candidate and maintained detector updates. | Tool output is not proof of completeness, licensing, vulnerability status, or actual loaded/shipped content. |
| W28 | WiX Toolset, [release `v7.0.0`](https://github.com/wixtoolset/wix/releases/tag/v7.0.0), commit `b8977d6`, published 6 April 2026; [source license](https://github.com/wixtoolset/wix/blob/v7.0.0/LICENSE.TXT) | Current reviewed MSI authoring candidate, source license and binary OSMF EULA warning. | No procurement/license approval; broad toolchain and emitted package behavior require exact admission and lab evidence. |
| W29 | WixSharp, [release `v2.14.1.0`](https://github.com/oleg-shilo/wixsharp/releases/tag/v2.14.1.0), commit `a40d106`, released 5 July 2026 | Maintained C# MSI-authoring wrapper/generator candidate. | Adds generator and WiX dependencies; emitted MSI, not DSL intent, is authoritative. |
| W30 | Velopack, [release `1.2.0`](https://github.com/velopack/velopack/releases/tag/1.2.0), commit `f2edcbc`, released 3 June 2026 | Maintained updater reference and practical lifecycle/failure cases. | Cross-platform application updater with broader authority and different trust model; reference only. |
| W31 | NetSparkleUpdater, [release `3.1.0`](https://github.com/NetSparkleUpdater/NetSparkle/releases/tag/3.1.0), commit `b3df04a`, released 5 May 2026 | Maintained .NET appcast/updater reference and test/UI cases. | Appcast/single-app authority is not TUF or enterprise-machine authorization; reference only. |
| W32 | WinSparkle, [release `v0.9.4`](https://github.com/vslavik/winsparkle/releases/tag/v0.9.4), commit `a8986ca`, released 21 July 2026; [MIT license](https://github.com/vslavik/winsparkle/blob/v0.9.4/COPYING) | Maintained Windows-native app updater reference, parser/signature/download tests. | Desktop-app/appcast model and bundled notices differ from UAM; reference only. |
| W33 | Squirrel.Windows, [release `2.0.1`](https://github.com/Squirrel/Squirrel.Windows/releases/tag/2.0.1), commit `eef3746`, released 27 September 2020 | Historical side-by-side updater and failure-mode reference. | Stable release is stale for a new 2026 trust boundary; neither as dependency. |

## 15.4 Source-quality conclusions

1. **FACT.** Microsoft documentation establishes Windows Installer, trust-provider and filesystem primitives. It does not prove the proposed UAM composition under a supported estate.
2. **FACT.** TUF 1.0.35 is the normative repository-security model used here. python-tuf and go-tuf are implementation references; neither is automatically suitable for the C# Windows endpoint.
3. **FACT.** A repository release page, tag signature, SBOM, provenance attestation, Authenticode result or MSI exit code is one evidence item, not a complete release verdict.
4. **RECOMMENDATION.** Every mutable repository/source link in an execution gate must be replaced by a full immutable commit and archived dependency manifest. `latest`, `main`, mutable major action tags and search snippets cannot be the sole evidence.
5. **RECOMMENDATION.** Source and binary license terms are reviewed separately. WiX v7 is the clearest example: MS-RL source terms and OSMF binary EULA/procurement implications both matter.
6. **RECOMMENDATION.** UAM's own hostile T1 corpus and Windows failpoint matrix remain decisive. Upstream tests can reduce common-mode error but cannot authorize a privileged boundary.

---

# 16. Confidence table for every major conclusion

| Major conclusion | Confidence | Why | Evidence that would reduce or change confidence |
|---|---|---|---|
| MSI and enterprise management must own the stable privileged bootstrap | **High** | Accepted baseline and predecessor; minimizes permanent SYSTEM/network/parsing authority and gives enterprise repair/uninstall ownership. | A supported estate proves MSI/management cannot maintain the boundary and a narrower alternative passes equivalent privilege, repair, rollback and OOB gates through an explicit baseline change proposal. |
| Autonomous update should remain disabled by default | **High** | No approved SLA, management coverage or causal latency evidence exists; optionality is accepted baseline. | Representative versioned measurements show repeated management-attributable misses against an approved objective and the full updater gate passes. |
| Whether autonomous update is actually needed | **Low confidence that it is needed** | No fleet/offline/proxy/management distribution or approved patch SLA was supplied. | Human-approved causal measurement demonstrating material risk/cost reduction from the updater. |
| A low-privilege fetcher plus no-network minimal activator is safer than a monolithic SYSTEM updater | **Medium-High** | Separates untrusted network/parsing from machine mutation and constrains activator interface. | Lab evidence shows handle/IPC/copy complexity creates a larger attack surface or cannot operate under supported policy without broader privilege. |
| The activator must not modify MSI-owned services, tasks, launchers, root trust or ACL topology | **High** | Preserves the accepted stable privileged boundary and ensures MSI repair/OOB recovery remain authoritative. | Only a formal baseline change with stronger evidence; ordinary update convenience cannot change this. |
| Immutable side-by-side versions plus A/B activation are the correct rollback model | **High for direction; Medium for exact implementation** | Avoids in-place mixed bytes and keeps known-good payload available. | Power-loss/filter/filesystem tests reveal the state publication/copy scheme cannot preserve one operable version; another scheme then requires an ADR and equivalent proof. |
| No execution directly from staging or mutable current directory | **High** | Directly blocks incomplete/user-writable/reparse-controlled content from becoming code. | No expected ordinary evidence should weaken this; only a stronger immutable execution primitive may replace it. |
| Repository authorization and Authenticode are both required | **High** | They cover different risks: authorized release digest/rollback/freeze versus Windows signer/trust policy. | A supported Windows enterprise policy provides a stronger equivalent that still preserves exact repository authorization and incident separation; removing either requires a change ADR. |
| TUF 1.0.35 with a published UAM POUF is preferable to a custom appcast/TUF-like protocol | **High** | Role separation and client workflow address rollback, freeze, mix-and-match and compromise recovery that ad hoc feeds omit. | A future standard/profile supersedes it and passes a migration/conformance/attack review. |
| A conformant C# TUF client can be implemented or selected | **Medium-Low** | The model is language-neutral, but no exact C# implementation/dependency/conformance evidence is supplied. | Passing pinned conformance, UAM attacks, persistent-state failpoints and dependency review increases confidence; failure keeps updater disabled. |
| Root authority must be offline and threshold-capable; online keys cannot be ultimate authority | **High** | Core TUF compromise-containment model and prompt requirement. | Human availability/ceremony evidence may change exact threshold/key technology, not the separation principle. |
| Root-threshold compromise requires out-of-band enterprise repair | **High** | TUF explicitly treats trust loss as OOB recovery and potentially compromised endpoints; in-band signatures from compromised roots cannot restore trust. | A separate independently anchored hardware/enterprise trust channel is approved and proved; it is still out-of-band relative to the compromised root. |
| Rollback/downgrade must be published at a higher release sequence | **High** | Preserves anti-rollback floors and prevents emergency language from bypassing authorization. | A new formal repository protocol with equivalent monotonic recovery semantics. |
| MSI transaction and payload A/B activation must remain separate state machines | **High** | MSI owns topology; payload probation/health is longer-lived and cannot safely be one installer transaction. | A measured deployment mechanism proves equivalent interruption recovery without long transactions or topology ambiguity. |
| Launcher re-verification must be independent of fetcher/activator success | **High** | Last gate before code execution; contains privileged updater or state corruption. | Performance evidence may change verification caching details, but not the requirement to bind selected bytes to current authority. |
| Full hash/manifest verification at each launch is operationally acceptable | **Medium-Low** | Safer conservative design, but no payload size/storage/launch-latency measurements exist. | Representative measurements may justify an authenticated immutable verification cache tied to file identity, USN/change evidence and periodic full verification; such a cache needs a separate hostile proof. |
| Handle-based final-path/file-identity checks materially reduce reparse/TOCTOU risk | **Medium-High** | Established Windows primitives and narrow copy flow support the reasoning. | Hostile hard-link/reparse/filter/filesystem tests find a substitution path, or supported storage lacks required semantics. |
| Exact ACL inheritance/owner/DACL profile is viable across the supported estate | **Medium-Low** | Correct intent is clear, but lab/environment/GPO/EDR behavior is unknown. | Effective-access and mutation campaigns per supported environment. |
| N/N-1 read compatibility is the correct autonomous-update storage rule | **High for principle; Medium for each migration** | Rollback is meaningless if the prior binary cannot read current data. | A specific migration cannot be made bidirectionally compatible; that release becomes enterprise maintenance rather than weakening the rule. |
| Destructive/one-way migrations must be enterprise maintenance events | **High** | They eliminate autonomous rollback and require backup/restore/operational authority. | A proven shadow-copy/dual-write migration retains exact N-1 operation and cleanup; then it is no longer destructive during the window. |
| Local health proof should be bounded, authenticated and release-specific | **High** | Prevents process-start-only success and cross-version/replay health. | A better deterministic local proof replaces the exact schema; the binding and bounded probation principles remain. |
| Automatic rollback and bad-version suppression should prevent retry loops | **High** | Required for interruption safety and failure containment. | Lab evidence may tune suppression scope/expiry, not remove loop prevention. |
| Same signed digest must be promoted through rings without rebuild | **High** | Preserves subject identity, reproducibility and causal rollout comparison. | A legally/technically required realm-specific binary model with independent build/provenance/release identities and explicit architecture change. |
| Two challenged clean unsigned builds are necessary release evidence | **High** | Accepted predecessor and effective substitution/nondeterminism control. | Toolchain limitations may require a bounded R3 exception, but unexplained differences remain a stop. |
| SBOM/provenance must be reconciled against final shipped files and locks | **High** | Generator success alone has blind spots; final bytes are the release subject. | A future verified inventory mechanism can simplify tools, not remove independent completeness checks. |
| SBOM completeness can be proved absolutely | **Low** | Dynamic/native/generated/licensing knowledge and detector blind spots remain. | Stronger deterministic build manifests and multiple independent detectors increase confidence but do not make absolute proof. |
| Realm/ring repositories need independently pinned trust and no cross-realm fallback | **High for principle; Medium for operations** | Prevents one realm/channel from authorizing another and aligns accepted realm isolation. | Repository/registration topology evidence may select one shared byte store with separate signed metadata, but trust roots/audience resolution remain isolated. |
| Privacy-safe finite release observability is sufficient for first support | **Medium-High** | Release diagnostics do not need activity, URLs, users or paths; finite codes control cardinality. | Support exercises show a necessary missing value-free signal; adding it requires privacy/cardinality review, not raw-value bypass. |
| WiX is the leading MSI authoring candidate | **Medium** | Mature and current Windows Installer toolchain, but binary EULA/MS-RL/support/procurement and UAM output remain unresolved. | Legal/procurement rejection, reproducibility issue, emitted-package defect, or another tool passes the same comparison with lower total cost. |
| Existing app updater frameworks should not be direct dependencies | **High** | Their appcast/user-app/install-root authority is broader and mismatched; none supplies the complete UAM trust model. | An exact reduced integration proves no excess authority/dependency and passes all TUF/MSI/Windows gates; this appears unlikely but is testable. |
| Cosign/in-toto/SLSA tooling belongs in build/signing evidence, not endpoint authorization | **High** | Their subjects/predicates complement but do not replace TUF/Authenticode/activation. | A future endpoint architecture explicitly adopts a standard bundle verifier while retaining repository and Windows execution policy; requires dependency and threat ADR. |
| The proposed test matrix is sufficient to falsify the major design claims | **Medium** | It covers every requested transition, attack class, key role, supply-chain path and cleanup. It has not run. | Escaped defect, missing supported environment, or mutation survivor expands the matrix and lowers confidence until rerun. |
| A technical pass is production approval | **High confidence that it is not** | Human SLA, coverage, keys, installer procurement, emergency authority, support, budget and risk decisions are explicitly unresolved. | Only designated human authorities and all applicable later project gates can change status. |

## 16.1 Confidence-changing evidence in priority order

The most valuable next evidence is:

1. a real emitted MSI table/static analysis plus install/repair/upgrade/uninstall kill matrix on an approved disposable Windows VM;
2. pinned TUF client conformance and UAM attack results, including persistent trusted-state corruption and root rotation;
3. reparse/hard-link/TOCTOU/ACL/DLL-load campaigns against the exact launcher/activator/filesystem profile;
4. A/B activation failpoints and N/N-1 migration tests with exact endpoint storage versions;
5. two clean builds, isolated test signing, final-file/SBOM/provenance reconciliation and same-digest ring publication;
6. role-specific key compromise and independent out-of-band MSI repair drill;
7. representative enterprise-management deployment latency/coverage measurements against a human-approved objective.

---

# Final residual risk and next stop/go gate

## What remains unsafe or impossible to prove through research alone

- **HUMAN DECISION.** No patch SLA, enterprise-management coverage objective, key custodians/ceremony, installer procurement, emergency authority, support model, budget or production risk acceptance exists in this result.
- **UNKNOWN.** The actual supported Windows editions/builds, filesystems, GPO, EDR/CFA, WDAC/AppLocker, proxy/VPN, certificate-revocation, clock, offline and VDI behavior are unmeasured.
- **UNKNOWN.** The exact C# TUF implementation, MSI authoring tool, code-signing profile, key technologies, thresholds, expiries, root overlap and release package limits are not selected.
- **UNKNOWN.** Every real N/N-1 data migration remains release-specific. One incompatible migration is enough to block autonomous activation for that release.
- **Residual attack risk.** A threshold-authorized malicious release can still be installed; TUF and Authenticode establish authority/integrity, not benevolence. Compromised source/dependencies can reproduce deterministically. A valid SBOM/provenance record can truthfully describe a malicious build.
- **Residual denial risk.** Repository, timestamp-key, network, proxy, clock, disk and management failures can keep endpoints stale. The safe response is to continue the last verified release and expose honest stale health, not bypass authorization.
- **Residual local-host risk.** A sufficiently privileged local attacker, kernel/filter compromise, or compromised enterprise deployment authority can subvert files, trust or recovery outside this design's boundary.
- **Residual storage risk.** Flush/rename semantics, media failure and secure deletion are not absolute. The design contains them with redundant state, retained known-good versions, manifests and OOB repair; it cannot prove physical persistence or erasure.
- **Residual operational cost.** TUF role operations, code signing, recurring Windows/update qualification, installer repair, ring monitoring, incident response, key rotation, OOB repair and support require sustained specialist ownership. An optional updater creates permanent patch and incident obligations even when no update is active.
- **Residual privacy risk.** Release observability can still become identifying through rare combinations or excessive retention. Fixed dimensions, access control and cardinality budgets reduce but do not remove this risk.

## Explicit next gate

**GO now** for repository tasks that use only T1 fictional data and test-only keys: release contracts and schemas, deterministic good/bad/stale/tampered package generation, MSI/tool comparison, stable-launcher and immutable-slot prototypes, a pinned TUF POUF/client/conformance spike, build/SBOM/provenance controls, disabled fetcher/activator prototypes, and placeholder-only disconnected Windows-lab scripts.

**STOP** before production signing, production repository trust, network-connected autonomous update, live enterprise deployment, pilot or production.

The next stop/go gate is:

```text
RELEASE_UPDATE_TECHNICAL_GATE =
    E11-00_THROUGH_E11-22_PASS
    AND UNAUTHORIZED_OR_INCOMPLETE_EXECUTIONS = 0
    AND INTERRUPTIONS_WITHOUT_OPERABLE_KNOWN_VERSION = 0
    AND UNRECOVERABLE_KEY_COMPROMISE_PATHS = 0
    AND PRIVILEGED_PATH_OR_BYTE_ESCAPES = 0
    AND CURSOR_OR_DATA_COMPATIBILITY_ROLLBACK_FAILURES = 0
    AND SUPPLY_CHAIN_SUBJECT_OR_INVENTORY_MISMATCHES = 0
    AND CLEANUP_RESIDUE = 0
    AND BLOCKING_OWNER_COUNT = 0
    AND BLOCKING_ADR_COUNT = 0
```

Passing that gate authorizes only an **enterprise-managed, synthetic, test-signed MSI ring** and produces an immutable `release-update-gate.json` bound to the exact source tree, MSI, payload, metadata roots, tool/native versions, Windows capability, evidence and cleanup receipts.

The autonomous-updater decision remains a separate **HUMAN DECISION** after representative enterprise deployment measurements. It is **GO** only when the section 4.2 decision expression is true and the updater demonstrates a material approved patch-latency/coverage benefit without weakening any primary invariant. Otherwise the final architecture remains `ENTERPRISE_ONLY`, with the optional updater omitted or permanently disabled.

**Non-waivable final stop rule:** an unauthorized, incomplete, stale, frozen or lower-sequence release executing; any interruption leaving no operable known version; any root-threshold compromise claimed recoverable through the compromised in-band trust; any privileged reparse/TOCTOU/DLL path escape; any N/N-1 rollback failure during an autonomous release; any signer or publisher changing unapproved bytes; or any silent release-diagnostic privacy leak stops dependent work and requires an explicit ADR/change proposal. It cannot be accepted silently in code, an MSI property, repository metadata, a support workaround, or an expired exception.
