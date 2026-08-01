# G1 Windows runtime, session identity, and IPC blueprint

**Result:** `02-g1-windows-runtime-ipc-result.md`  
**Research baseline:** 31 July 2026  
**Status:** Decision-ready implementation research; not production approval  
**Gate:** G1 — Windows session launch, identity, and IPC isolation  
**Platform:** Windows desktop/server process model; C#/.NET implementation family  
**Data used:** synthetic or sanitized evidence only  

## Evidence language

This result uses the required labels exactly:

- **FACT** — directly supported by an allowed attachment or current primary source.
- **ASSUMPTION** — supplied or inferred but not yet proved.
- **INFERENCE** — a conclusion drawn from facts; the reasoning is stated.
- **ESTIMATE** — a replaceable numerical starting value, not an approved budget.
- **RECOMMENDATION** — the proposed UAM design, with alternatives and change conditions.
- **UNKNOWN** — evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, support, or risk authority is required.
- **CLI EXPERIMENT** — implementation or lab evidence is required before the claim can pass.

Source identifiers in square brackets refer to the source register in Section 15.

---

# 1. Executive conclusion

## 1.1 Decision in easy language

**RECOMMENDATION — Proceed to a hostile G1 prototype, not to production.** Build the Windows endpoint as three deliberately different execution contexts:

1. `Uam.Coordinator.Service.exe` runs once per machine in session 0 as `NT AUTHORITY\LocalService`, with a restricted service SID and an SCM required-privilege list containing only `SeChangeNotifyPrivilege`.
2. A machine-installed Scheduled Task starts a small ordinary-token `Uam.UserHost.Launcher.exe` for each eligible interactive logon. The launcher creates exactly one protected `Uam.UserHost.exe` in that same logon session and exits. Neither service nor launcher creates or authenticates a user token.
3. `Uam.UserHost.exe` starts short-lived `Uam.TaskHost.exe` processes only for compiled, release-authorized capability IDs. Each Task Host receives a restricted low-integrity token, a one-process Job Object, an explicit handle allowlist, fixed mitigations, bounded resources, a private scratch directory, and executable-specific firewall blocks.

The Coordinator and each User Host communicate over local named pipes using a two-stage protocol:

- a small, rate-limited bootstrap pipe open to interactive tokens; then
- a fresh one-use pipe whose DACL names the exact logon SID discovered from the kernel-reported client process.

Neither side trusts identity fields supplied in a message. The service binds the connection to a held process handle, PID, process creation time, WTS session ID, token user SID, token logon SID, authentication LUID, integrity/elevation state, and an allowlisted signed image. The client independently verifies that the pipe server is the SCM-reported Coordinator process in session 0 and is running the protected release image. Every post-handoff frame is length-bounded, sequence-strict, and authenticated with a per-connection HMAC key derived from fresh nonces and a handoff secret. [MS-PIPE-01] [MS-PIPE-02] [MS-PIPE-03] [MS-TOKEN-01] [RFC-5869]

**FACT — Baseline alignment.** This keeps the accepted separation between a low-privilege machine Coordinator, one ordinary-token User Host per eligible interactive session, and short-lived restricted Task Hosts. It also keeps user-owned reads in the user session and requires minimization before Coordinator IPC. [INT-BASE] [INT-GATES]

**INFERENCE — Why this is the simplest defensible design.** Windows already provides the required boundaries—service SID isolation, Task Scheduler interactive-token launch, logon SIDs, named-pipe ACLs, process tokens, restricted tokens, integrity levels, Job Objects, process mitigations, and firewall policy. Using those primitives directly avoids a privileged token broker, credentials, loopback networking, or a general plugin sandbox. The price is a small native-interoperability layer and a mandatory hostile lab gate.

## 1.2 Primary gate

G1 passes only when the evidence bundle proves all four clauses below on every environment proposed for support:

> **Zero cross-session accepted messages; no profile access by the service; no prohibited privileges; bounded hostile-client impact.**

Minimum campaign:

- 10,000 cross-session connection/message attempts;
- 10,000 malformed, oversized, replayed, out-of-order, and slow-client attempts;
- 10,000 same-account/different-logon-session process-handle theft attempts where the environment can create that condition;
- full console, lock, unlock, fast-switch, RDP connect/disconnect, reconnect, and logoff transitions that the human support decision places in scope;
- Task Host token, handle, Job Object, write, child-process, network, memory, CPU, cancellation, and kill-tree tests.

A bootstrap connection by an unauthorized interactive client is not itself a failure; an accepted application message, handoff to the wrong identity, or unbounded resource effect is a failure.

## 1.3 Confidence and residual risk

| Major conclusion | Confidence | Why | What would change it |
| --- | --- | --- | --- |
| Three execution contexts are the correct baseline | High | Accepted project baseline plus mature Windows isolation primitives | New primary evidence showing a material Windows/platform incompatibility, followed by a change proposal and falsifying prototype |
| `LocalService` plus restricted service SID and one required privilege is the right Coordinator identity | Medium | Documented capability is strong; exact product access and EDR/GPO interactions are untested | Failure to open only the required User Host process/token objects or inability to operate without a prohibited privilege |
| Group-principal Scheduled Task can produce one ordinary-token User Host per eligible session | Medium | Task Scheduler protocol documents group and interactive-token behavior; enterprise policy is unknown | Lab token/session mismatch, task hardening preventing launch, or enterprise policy prohibiting the registration form |
| Two-stage named-pipe design can enforce logon-session isolation | Medium | Kernel PID/session APIs and logon-SID ACL guidance are documented; UAM composition is not yet tested | Any accepted cross-session frame, PID-reuse bypass, pipe squatting bypass, or same-account handle theft |
| Restricted-token/Job/low-integrity Task Host meaningfully contains faults | Medium | Windows mechanisms are documented and widely used; UAM runtime/native dependencies may conflict | Inability to start under the token, write outside scratch, create descendants, escape job, or obtain network access |
| Task Host is a complete same-user data-read sandbox | Low; explicitly rejected | A restricted ordinary user token can still read resources that the user can read unless a stronger capability/broker model is used | A human threat-model decision requiring protection from hostile collector code or same-user reads |

**Residual risk.** This design does not defend against local administrators, kernel compromise, security software with injection rights, or malicious code already running in the same logon session. A restricted Task Host can still read many same-user-readable resources; it is a fault-containment process, not an untrusted-code boundary. Windows Firewall policy may be overridden by enterprise policy. Session and token behavior differs across client, RDS, VDI, FSLogix, Citrix, and hardened estates. None of those points can be resolved by prose.

**Next stop/go gate:** implement the smallest G1 proof and run the exact harness in Sections 8 and 11. Any cross-session accepted message, successful Coordinator profile read, prohibited effective privilege, uncontrolled Task Host descendant/network/write, or resource exhaustion is **STOP**. Open the relevant ADR; do not continue to G2.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 In scope

This result specifies, down to code and Windows-object behavior:

- executable ownership, release layout, dependencies, startup, shutdown, recovery, and compatibility for Coordinator, launcher, User Host, and Task Host;
- service account, service SID, required privileges, SCM configuration, object DACLs, registry/filesystem/certificate access;
- Scheduled Task principal, logon type, run level, trigger set, task security descriptor, and duplicate-control behavior;
- console, lock, unlock, fast switch, RDP connect/disconnect, reconnect, logoff, and concurrent same-account cases;
- named-pipe namespace, local-only flags, DACL construction, mutual process validation, handshake, wire framing, versioning, nonces, replay control, quotas, timeouts, cancellation, and malformed-client containment;
- Task Host token restriction, integrity, restricting SID, Job Object, handle inheritance, process mitigations, filesystem writes, network prohibition, cancellation, kill tree, and limitations;
- a code-ready .NET solution and allowed dependency graph;
- security/privacy failure handling, observability, incident response, support runbooks, realm isolation, data-quality boundaries, accessibility of operator output, and fitness functions in G1 scope;
- exact hostile CLI experiments, evidence bundle, pass/fail criteria, duration estimates, and cleanup.

## 2.2 Non-goals

This report does **not** decide or prove:

- legal purpose, lawful basis, employee consultation, prohibited uses, identity precision, retention, access policy, or production approval;
- the final Edge acquisition algorithm, source cursor semantics, live browser locking behavior, or browser data fields; those are later gates;
- production database, ingestion, portal, broker, or central analytics design;
- endpoint outbox sizing, upload retry values, encryption/key-wrapping choice, device PKI integration, TPM coverage, proxy/VPN behavior, or updater need;
- supported Windows editions/builds, RDS/VDI/FSLogix/Citrix scope, resource budget, support staffing, on-call, or SLO/RPO/RTO;
- resistance to local administrator, kernel, hypervisor, or same-session code injection;
- a general-purpose script, plugin, or arbitrary assembly execution system.

## 2.3 Accepted inputs

| Input | Evidence statement | Use in this result | Limitation |
| --- | --- | --- | --- |
| **FACT** `[INT-BASE]` | July 2026 accepted three-process model, user-session reads, C#/.NET, privacy ceiling, pre-IPC minimization, MSI-owned privileged boundary | Architectural constraint and invariants | Working baseline; not production approval or runtime proof |
| **FACT** `[INT-LEGACY]` | Legacy monolithic PowerShell combines collection, scheduling, direct SQL, deferred executable SQL, recovery, and user/profile dependence | Explains why orchestration, collection, persistence, and privilege must be separated | Static/sanitized evidence cannot establish every runtime behavior or volume |
| **FACT** `[INT-GATES]` | G1 precedes G2; a failed early gate stops dependent work and opens an ADR | Stop/go sequencing | Passing proves only the named claim |
| **FACT** `[INT-LAB]` | A sanitized Windows lab access path exists; no connection was made; OS, session, policy, runtime, EDR, and platform details are unknown | Allows placeholder-only experiment design | Proves no Windows capability or behavior |
| **FACT** `[INT-RULES]` | Required evidence labels, current primary-source preference, privacy limits, and CLI-proof requirement | Research method and wording | Rules are not technical evidence by themselves |

No other Project file is used.

## 2.4 Assumptions

| ID | Assumption | Consequence if false | Resolution |
| --- | --- | --- | --- |
| A-01 | **ASSUMPTION:** G0 has approved a synthetic G1 capability and dummy event contract before code runs | The harness could accidentally test unapproved source values | Verify G0 evidence; otherwise stop before any collector work |
| A-02 | **ASSUMPTION:** The MSI can run elevated and set service/task/firewall/ACL configuration | Stable privileged boundary cannot be installed | Human deployment decision or redesign through enterprise management tooling |
| A-03 | **ASSUMPTION:** At least one current supported Windows environment can run the approved test executables | No runtime proof is possible | Read-only inventory, then choose an approved lab image |
| A-04 | **ASSUMPTION:** Code signing and a protected release manifest are available to the prototype, even if using a lab certificate | Process-image validation cannot be tested | Create a synthetic lab signing chain; never substitute path-only trust |
| A-05 | **ASSUMPTION:** Exact logon SID and process token information can be queried after the launcher prepares the token/process DACLs | Coordinator cannot bind the pipe to the client identity without impersonation | Stop gate; prototype token-object ACL or submit an ADR for another authenticated local IPC design |
| A-06 | **ASSUMPTION:** Same-logon-session processes are inside one endpoint privacy boundary for G1 | Malicious same-session code could require stronger isolation than this design supplies | Human threat-model decision; consider AppContainer/brokered handles if same-session hostility is in scope |
| A-07 | **ASSUMPTION:** The Task Host collector can operate without a UI and with Win32k disabled | Required native/runtime behavior may fail | Compatibility prototype; remove only the failing mitigation through an ADR with compensating controls |

## 2.5 Unknowns

| ID | Unknown | Why it matters | First evidence |
| --- | --- | --- | --- |
| U-01 | Supported Windows client/server builds and architectures | API, Task Scheduler, Job nesting, mitigation, and session behavior vary | Inventory JSON plus human support decision |
| U-02 | Domain, Entra, local-account, UAC, and credential-guard state | Token elevation and task launch behavior may differ | Sanitized token and OS inventory |
| U-03 | RDP/RDS/VDI/FSLogix/Citrix and fast-switch availability | Determines which lifecycle cases can be proved and supported | Session capability inventory and test matrix selection |
| U-04 | Enterprise Scheduled Task and service hardening policies | Registration, principal, task DACL, restart, and service privilege behavior may be rewritten or blocked | Exported effective task XML/SDDL and SCM evidence after policy refresh |
| U-05 | Firewall local-policy merge and endpoint network controls | Local executable block rules may be ignored or replaced | Effective firewall export and synthetic egress test |
| U-06 | EDR/DLP injection and process protection behavior | Could break mitigations, alter handles, or create false positives | Approved compatibility run; no product names in the evidence package unless authorized |
| U-07 | Whether `CreateProcessAsUserW` is needed or ordinary `CreateProcessW` suffices for Task Host under a restricted duplicate of the current token | Changes privilege and launch complexity | Small token-launch prototype |
| U-08 | Resource budget and acceptable idle/runtime overhead | Initial caps are only safety estimates | Measured distributions plus human budget |
| U-09 | Device certificate/PKI integration | Certificate ACL row is conditional in G1 | Later device-identity gate |
| U-10 | Same-account concurrent logon behavior in proposed environments | Important to handle-stealing and logon-SID isolation | Same-account/different-logon test or explicit scope exclusion |

## 2.6 Research method

**FACT:** Current platform claims were checked against Microsoft Learn, the .NET support policy, RFCs, and immutable open-source tags or commits current to 31 July 2026. [MS-DOTNET-01] [MS-PIPE-01] [MS-SVC-01] [MS-TASK-01] [RFC-5869] [RFC-8949]

**INFERENCE:** Documentation establishes API behavior and support contracts, not UAM fitness under the estate's GPO, EDR, session, and release conditions. Every material composition claim is therefore a **CLI EXPERIMENT** rather than a declared fact.

---

# 3. Recommended design: components, responsibilities, and trust boundaries

## 3.1 Non-negotiable G1 invariants

1. **RECOMMENDATION:** The Coordinator never loads an interactive user profile, opens user-profile files, enumerates user hives, calls `LogonUser`, calls `WTSQueryUserToken`, loads a profile, or creates a User Host token.
2. **RECOMMENDATION:** A User Host accepts assignments only for its kernel-validated logon SID and WTS session; it cannot claim another session, user, device, or realm in a payload.
3. **RECOMMENDATION:** Only already-minimized typed data can cross from User Host/Task Host to Coordinator. Raw URLs, titles, paths, SQL, source records, browser database pages, and exception text are protocol-invalid.
4. **RECOMMENDATION:** A Task Host mode is a compiled enum tied to a signed release manifest. No arbitrary executable path, script, command interpreter, assembly path, dynamic plugin, or user-controlled argument is accepted.
5. **RECOMMENDATION:** All privileged configuration is MSI/enterprise-owned. Runtime components can narrow or disable behavior but cannot install code, broaden ACLs, add privileges, edit their Scheduled Task, or update firewall policy.
6. **RECOMMENDATION:** Identity is taken from Windows kernel objects and authenticated release files, never from a request body.
7. **RECOMMENDATION:** A cursor advances only in the same Coordinator SQLite transaction that durably inserts the minimized events represented by that cursor. The ACK follows commit.
8. **RECOMMENDATION:** Any identity, ACL, privilege, signature, protocol-major, transcript, sequence, MAC, realm-binding, or privacy-schema mismatch closes the connection and produces a bounded, privacy-safe error code.

## 3.2 Process and trust-boundary diagram

```text
                                        MACHINE / ADMIN TRUST
      +----------------------------------------------------------------------------------+
      | MSI / enterprise deployment (elevated only during install, repair, uninstall)    |
      | owns signed files, release manifest, SCM config, Scheduled Task, ACLs, firewall  |
      +-------------------------------------+--------------------------------------------+
                                            |
                                            v
      +------------------------------ SESSION 0 / MACHINE BOUNDARY ----------------------+
      |                                                                                |
      |  Uam.Coordinator.Service.exe                                                   |
      |  LocalService + restricted service SID + only SeChangeNotifyPrivilege          |
      |  - session reconciliation        - IPC identity verifier                        |
      |  - policy/kill-switch evaluator  - minimized-event validation                   |
      |  - one SQLite writer             - uploader (outside G1 data path proof)         |
      |  NEVER reads user profiles; NEVER creates user tokens; NEVER impersonates       |
      |                                                                                |
      |  bootstrap pipe: interactive-connect, handshake-only, strict global quotas      |
      +--------------------+-------------------------+-----------------------------------+
                           | local named pipes       | exact-logon-SID dedicated pipe
                           | kernel PID/session      | per-connection HMAC + sequences
             ==============+=========================+===================================
                           | USER / LOGON-SESSION BOUNDARY
                           v
      +------------------------------ WTS SESSION N -------------------------------------+
      | Task Scheduler starts Uam.UserHost.Launcher.exe with ordinary interactive token  |
      |   - verifies token/session/release                                                |
      |   - prepares token/process DACLs including OWNER RIGHTS                           |
      |   - creates Uam.UserHost.exe suspended with explicit process/thread security      |
      |   - applies startup mitigations; resumes; exits                                   |
      |                                                                                  |
      | Uam.UserHost.exe (one per exact logon SID + WTS session)                          |
      |   - reads only release-authorized user-owned sources                              |
      |   - owns session state and cancellation                                           |
      |   - applies privacy transform before Coordinator IPC                              |
      |   - starts fixed Task Host modes; has no transport/SQL/admin capability           |
      |                                                                                  |
      |      anonymous request/result handles only; no Coordinator pipe inherited         |
      |             +----------------------------------------------------------------+   |
      |             | Uam.TaskHost.exe (short-lived, mode-specific)                  |   |
      |             | restricted token + low IL + restricting SID + one-process Job  |   |
      |             | explicit handles + mitigations + private scratch + firewall     |   |
      |             | residual: may read same-user-readable data needed by capability |   |
      |             +----------------------------------------------------------------+   |
      +----------------------------------------------------------------------------------+

      Separate WTS/logon sessions receive different dedicated-pipe DACLs and identity tuples.
      A realm is machine registration state held by the Coordinator; no User Host payload chooses it.
```

### Trust boundaries

| Boundary | Trusted side | Less-trusted side | Enforcement | Residual limitation |
| --- | --- | --- | --- | --- |
| Install/runtime | MSI/enterprise deployment | All runtime processes | Signed protected files, ACLs, SCM/task/firewall ownership, manifest verification | Local admin or enterprise policy can alter configuration |
| Machine/session | Coordinator | Any interactive process | Bootstrap quotas, PID/session/token/image validation, exact-logon-SID handoff pipe | Bootstrap is intentionally connectable by interactive users; same-session code is not isolated |
| Session/task | User Host | Task Host | Restricted token, low integrity, restricting SID, Job, explicit handles, fixed mode, timeout/kill | Same-user-readable input is not fully hidden from a compromised Task Host |
| Endpoint/realm | Coordinator registration/config | IPC payload | Realm/device stamped by Coordinator; claims absent from payload | Reassignment and wipe policy are human decisions |
| Privacy | Release-authorized transform | Raw source | Transform before page serialization, IPC, durable store, logs | G1 uses synthetic data; production transform is later gated |

## 3.3 Executables and ownership

| Executable | Installed/updated by | Starts it | Security context | Lifetime | May start | Must not do |
| --- | --- | --- | --- | --- | --- | --- |
| `Uam.Coordinator.Service.exe` | MSI/enterprise deployment | SCM, delayed automatic | `LocalService`; restricted service SID; session 0 | Machine lifetime with finite recovery | No user process; no Task Host | Load user profile; create user token; impersonate; discover arbitrary plugins; run scripts |
| `Uam.UserHost.Launcher.exe` | MSI/enterprise deployment | Machine Scheduled Task | Existing ordinary interactive token in target session | Seconds; exits after secure child launch or failure | Exactly protected `Uam.UserHost.exe` | Read sources; retain secrets; connect to transport; accept arbitrary args; elevate |
| `Uam.UserHost.exe` | MSI/enterprise deployment | Launcher using same token | Ordinary medium-integrity token; exact WTS/logon session | Interactive session; pauses while locked/disconnected; exits at logoff/drain | Fixed `Uam.TaskHost.exe` modes | Machine persistence; SQL/network transport; privileged configuration; raw data IPC |
| `Uam.TaskHost.exe` | MSI/enterprise deployment | User Host | Restricted duplicate of User Host token, low integrity, write-restricted where compatible, one-process Job | One bounded collection run | Nothing | Network, child processes, UI, arbitrary files for write, plugins/scripts, Coordinator IPC |
| `Uam.G1.*` proof tools | Lab-only signed package | Approved tester/harness | Synthetic test contexts | Test only | Test children as declared | Ship in production release; read real activity; output identifiers or source values |

**RECOMMENDATION:** The launcher closes a process-object security race. Task Scheduler cannot supply a custom process security descriptor. A tiny launcher can create the real User Host suspended with an explicit DACL before any IPC secret exists, apply startup mitigation attributes, and then resume it. The launcher itself holds no UAM source data or handoff secret; a race against its default process object therefore does not expose a registered channel.

## 3.4 Protected release layout

```text
%ProgramFiles%\UAM\
  releases\<release-id>\
    Uam.Coordinator.Service.exe
    Uam.UserHost.Launcher.exe
    Uam.UserHost.exe
    Uam.TaskHost.exe
    *.dll
    release.manifest.cbor
    release.manifest.sig
  current.manifest                 # protected pointer, not a user-writable junction
  rollback.manifest                # optional signed prior release authorization

%ProgramData%\UAM\
  runtime\                         # service-only state, policy, session ordinals
  data\                            # SQLite/outbox; outside detailed G1 storage design
  diagnostics\                    # service-only staging; sanitized export only
  task-scratch\<random-run-id>\   # per-run ACL + low mandatory label; removed after run
```

**RECOMMENDATION:** Use side-by-side normal files, not a user-writable path, environment expansion, current-directory lookup, or mutable search path. Resolve the current release from a signed protected manifest. At process launch and handshake, compare:

- canonical final path opened by handle;
- volume and file ID;
- SHA-256 from the signed release manifest;
- Authenticode chain/publisher policy;
- allowed current or rollback release ID.

Do not trust a filename, command line, product version string, or path alone.

## 3.5 Code-ready .NET solution and dependency rules

**FACT:** As of 31 July 2026, .NET 10 is an active LTS release; the support page lists runtime patch 10.0.10 released 14 July 2026 with end of support 14 November 2028, and the download page lists SDK 10.0.302 released 14 July 2026. [MS-DOTNET-01] [MS-DOTNET-02]

**RECOMMENDATION:** Target `net10.0-windows`. Select the exact supported SDK/runtime/package patch in the build execution policy; do not hard-code this research snapshot as timeless architecture. Prefer a self-contained, signed, normal-file publish for the first proof. Single-file and NativeAOT are later measurable options, not G1 assumptions.

```text
Uam.sln
  src/
    Uam.Contracts/                  # immutable IDs, enums, bounded DTOs; no Windows/API code
    Uam.Protocol/                   # 88-byte frame, CBOR codecs, HKDF/HMAC, state machine
    Uam.Windows.Interop/            # generated/manual Win32 declarations and SafeHandle types
    Uam.Ipc.Windows/                # native named-pipe server/client, ACL builders, identity proof
    Uam.Session.Model/              # WTS/logon/session state and eligibility logic
    Uam.Privacy/                    # release ceiling and pure minimizers; no I/O
    Uam.Coordinator.Core/           # orchestration, policy intersection, assignments, ACK rules
    Uam.Coordinator.Storage/        # one-writer SQLite transaction boundary
    Uam.Coordinator.Transport/      # future uploader; not referenced by user-side projects
    Uam.Coordinator.Service/        # SCM host, WTS reconciliation, composition root
    Uam.UserHost.Core/              # session controller, collectors, task launcher, page retry
    Uam.UserHost.Launcher/          # secure ordinary-token process creation only
    Uam.UserHost/                   # user-session composition root
    Uam.Collectors.Edge/            # later G2/G3 collector; synthetic adapter in G1
    Uam.TaskHost/                   # fixed mode dispatcher; minimal dependencies
    Uam.Installer.Contracts/        # declarative service/task/ACL/firewall manifest
  tests/
    Uam.UnitTests/
    Uam.ArchitectureTests/
    Uam.Windows.IntegrationTests/
    Uam.Protocol.FuzzTests/
    Uam.HostileClient/
    Uam.TaskHost.SandboxTests/
    Uam.Installer.VerificationTests/
    Uam.G1.EvidenceCollector/
```

### Normative allowed dependencies

| Project | May reference | Forbidden references or behavior |
| --- | --- | --- |
| `Uam.Contracts` | BCL only | Windows handles, file/network/SQLite APIs, serializers with reflection-based polymorphism |
| `Uam.Protocol` | `Uam.Contracts`; pinned cryptography/CBOR packages approved by dependency policy | Windows identity, storage, network, dynamic type loading |
| `Uam.Windows.Interop` | BCL; pinned CsWin32 build-time generator if ADR accepted | Business logic, logging of native buffers, raw `IntPtr` escaping public APIs |
| `Uam.Ipc.Windows` | Contracts, Protocol, Interop, Session.Model | Storage, collector, transport, impersonation |
| `Uam.Session.Model` | Contracts, Interop | Collector/source code, network, storage |
| `Uam.Privacy` | Contracts | I/O, logging raw values, tenant broadening |
| `Uam.Coordinator.Core` | Contracts, Protocol, Session.Model, Privacy abstractions | User-profile paths, browser APIs, token creation, plugins/scripts |
| `Uam.Coordinator.Storage` | Coordinator.Core contracts, SQLite provider | User-source readers, transport, raw payload persistence |
| `Uam.Coordinator.Transport` | Coordinator.Core contracts | Any reference from User Host or Task Host |
| `Uam.UserHost.Core` | Contracts, Protocol, Ipc.Windows client, Session.Model, Privacy, fixed collectors | Coordinator Storage/Transport, SQL client, web/HTTP client, service-management APIs |
| `Uam.UserHost.Launcher` | Interop, Session.Model, release verifier | Collectors, protocol payloads, network, storage, arbitrary command line |
| `Uam.TaskHost` | Contracts, minimal Protocol, Privacy, exactly one fixed collector adapter, Interop | General dependency injection scanning, dynamic assembly load, network client, Coordinator IPC, SQL |
| `Uam.Installer.Contracts` | Declarative records only | Runtime collection logic or updater behavior |

### Automated architecture rules

The build fails if:

- a user-side assembly references `System.Net.Http`, SQL client libraries, Coordinator storage/transport, PowerShell automation, Roslyn scripting, `Assembly.Load*`, `NativeLibrary.Load` outside an allowlisted native provider, `Process.Start` outside the launcher abstraction, or a shell executable string;
- Coordinator assemblies reference browser/source namespaces or known profile APIs;
- Task Host has more than its declared capability adapter;
- unsafe code appears outside `Uam.Windows.Interop`;
- public APIs expose `IntPtr`, unmanaged buffers, or mutable security descriptors;
- reflection discovers executable capabilities;
- protocol DTOs contain path, URL, title, SQL, realm, device, Windows SID, user name, or arbitrary dictionary fields.

## 3.6 Coordinator Service

### Identity and SCM configuration

**FACT:** Microsoft describes `LocalService` as a predefined account with minimum local privileges and anonymous network credentials. Its default token includes enabled `SeChangeNotifyPrivilege`, `SeCreateGlobalPrivilege`, and `SeImpersonatePrivilege`, among others. [MS-SVC-01]

**FACT:** `SERVICE_CONFIG_REQUIRED_PRIVILEGES_INFO` lets SCM remove privileges not declared by the service. A restricted service SID is added to the token's restricted SID list, and a service-SID-type change takes effect on the next system start. [MS-SVC-02] [MS-SVC-03] [MS-SVC-04]

**RECOMMENDATION:** Configure:

```text
Service name:            UamCoordinator
Image:                   protected absolute release path
Account:                 NT AUTHORITY\LocalService
Start:                   Automatic (Delayed Start)
Service SID type:        SERVICE_SID_TYPE_RESTRICTED
Required privileges:     SeChangeNotifyPrivilege\0\0
Dependencies:            none unless a measured hard requirement is proved
Interactive service:     false
Failure actions:         finite restart sequence; reset period; then no action/kill switch
Failure actions on non-crash: enabled only if tested
Preshutdown:             bounded drain only; no long unproved timeout
```

The process must fail startup if its effective token contains any of:

`SeImpersonatePrivilege`, `SeDebugPrivilege`, `SeTcbPrivilege`, `SeAssignPrimaryTokenPrivilege`, `SeIncreaseQuotaPrivilege`, `SeBackupPrivilege`, `SeRestorePrivilege`, `SeTakeOwnershipPrivilege`, `SeLoadDriverPrivilege`, `SeCreateGlobalPrivilege`, or any undeclared enabled privilege other than `SeChangeNotifyPrivilege`.

**CLI EXPERIMENT:** The MSI must set the service SID type before first start and verify the actual token. On upgrade from a different SID type, do not enable collection until a restart has made the restricted SID effective. An unexpected SID type or privilege is a stop gate.

### Startup

1. SCM starts the process in session 0.
2. The service checks release manifest/signature, process path/file identity, service SID, token type, integrity, required privileges, process DACL, Program Files/ProgramData/registry ACLs, task registration, and emergency kill switches.
3. It opens the protected machine registration/realm state. Failure to validate is fail-closed.
4. It opens SQLite and performs integrity/migration checks under the one-writer rule. G1 may use a synthetic transaction stub.
5. It creates and retains the bootstrap named-pipe anchor with `FILE_FLAG_FIRST_PIPE_INSTANCE`, explicit DACL, byte mode, overlapped I/O, and `PIPE_REJECT_REMOTE_CLIENTS`.
6. It creates the bounded bootstrap accept pool.
7. It registers for service session-change notifications and independently enumerates WTS sessions to reconcile missed notifications.
8. It enters `Running` only after every gate above passes.

### Shutdown and recovery

- On stop, preshutdown, or emergency drain: stop new handoffs; issue `DrainAndExit`; cancel assignments; wait only the configured grace; close channels; commit/close local storage; close pipe anchors last.
- On User Host loss: mark its session disconnected, cancel work, retain unacknowledged minimized pages/cursors, and require a fresh handshake.
- On service crash: SCM may execute a finite restart policy. After the crash-loop threshold, no automatic restart; write a fixed error code and leave collection disabled.
- A queued SCM restart cannot be canceled merely by stopping the service. Installer/repair must disable the service during maintenance and verify state before re-enabling. [MS-SVC-04]
- Never recover by changing account, broadening ACLs, adding privileges, enabling impersonation, or creating a user token.

## 3.7 Scheduled Task, launcher, and User Host

### Exact principal and registration intent

**FACT:** The Task Scheduler protocol states that `GroupId` runs the task for each logged-on member, `TASK_LOGON_GROUP` uses the user's interactive session, `LeastPrivilege` chooses the least privileged token, and session-state triggers include console/remote connect/disconnect and lock/unlock. It also defines `TASK_DONT_ADD_PRINCIPAL_ACE`. [MS-TASK-01]

**RECOMMENDATION:** Register one machine task with:

```text
Task path/name:           \UAM\UserHost
Principal GroupId:        S-1-5-4  (INTERACTIVE)
Registration logon type:  TASK_LOGON_GROUP
RunLevel:                 LeastPrivilege
Registration flags:       CREATE_OR_UPDATE | TASK_DONT_ADD_PRINCIPAL_ACE
Action:                   protected absolute Uam.UserHost.Launcher.exe path
Working directory:        protected release directory
Instances:                Parallel
Execution time limit:     PT0S (long-lived); verify effective XML on each supported OS
Triggers:                 any-user Logon, SessionUnlock, RemoteConnect, ConsoleConnect
Battery/idle/network:      must not prevent start; no wake-to-run
Restart on failure:       bounded; no infinite loop
Task DACL:                SYSTEM and Built-in Administrators full only
```

The group principal is chosen so the OS supplies an existing interactive token. A password task, S4U task, service-account task, highest-available task, per-user credential store, or service-created process is prohibited.

### Normative task XML template

The installer must generate and round-trip the XML through Task Scheduler; the exact schema version is selected for the human-approved minimum Windows build. The security descriptor is supplied separately during registration.

```xml
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.4" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <URI>\UAM\UserHost</URI>
  </RegistrationInfo>
  <Triggers>
    <LogonTrigger><Enabled>true</Enabled></LogonTrigger>
    <SessionStateChangeTrigger>
      <Enabled>true</Enabled><StateChange>SessionUnlock</StateChange>
    </SessionStateChangeTrigger>
    <SessionStateChangeTrigger>
      <Enabled>true</Enabled><StateChange>RemoteConnect</StateChange>
    </SessionStateChangeTrigger>
    <SessionStateChangeTrigger>
      <Enabled>true</Enabled><StateChange>ConsoleConnect</StateChange>
    </SessionStateChangeTrigger>
  </Triggers>
  <Principals>
    <Principal id="InteractiveUsers">
      <GroupId>S-1-5-4</GroupId>
      <RunLevel>LeastPrivilege</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>Parallel</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>true</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings><StopOnIdleEnd>false</StopOnIdleEnd><RestartOnIdle>false</RestartOnIdle></IdleSettings>
    <AllowStartOnDemand>false</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT0S</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="InteractiveUsers">
    <Exec>
      <Command>%ProgramFiles%\UAM\releases\&lt;release-id&gt;\Uam.UserHost.Launcher.exe</Command>
      <Arguments>--task-launch --manifest &lt;protected-manifest-id&gt;</Arguments>
      <WorkingDirectory>%ProgramFiles%\UAM\releases\&lt;release-id&gt;</WorkingDirectory>
    </Exec>
  </Actions>
</Task>
```

The final XML must contain an absolute expanded command path rather than a user-controlled environment expansion. The template shows the declarative value; the installer writes the resolved path.

### Launcher sequence

1. Open its own token and verify: primary token; `TokenSessionId` equals the process/WTS session; exact logon SID exists; `INTERACTIVE` is enabled; integrity is medium; `TokenElevationType` is limited/default as allowed; token is not elevated, SYSTEM, service, network, batch-only, AppContainer, or restricted in an unexpected way.
2. Verify the current release manifest and its own image.
3. Resolve the Coordinator service SID and build security descriptors.
4. Add a `TOKEN_QUERY` allow ACE for the exact Coordinator service SID to the current primary-token object. Keep an existing token handle open. Add an `OWNER RIGHTS` ACE that does not grant `WRITE_DAC` or `WRITE_OWNER`; this suppresses the owner's implicit DACL-changing rights for later cross-logon opens. [MS-SID-01]
5. Create `Uam.UserHost.exe` suspended with explicit process and thread DACLs from the first instruction, no inherited handles, exact `lpApplicationName`, mutable quoted command line, protected working directory, Unicode minimal environment, and startup mitigation attributes.
6. Verify child path/file ID, token, session, process DACL, and mitigation results; resume.
7. Wait for a bounded launcher-ready signal that carries no secret, or observe early child exit; then close all child handles and exit.

**CLI EXPERIMENT:** If token-object DACL preparation or secure suspended creation fails under final enterprise policy, fail G1. Do not add `SeImpersonate`, `SeAssignPrimaryToken`, or a service-side token broker as a workaround.

### One User Host per session

The User Host acquires:

```text
Local\uam.userhost.<install-id>.v1
```

with a DACL granting SYSTEM and the exact logon SID, plus an `OWNER RIGHTS` ACE without DACL-write rights. It also registers its identity tuple with the Coordinator. A second host in the same tuple exits. The mutex alone is not authority; the Coordinator's held process/token identity is authority.

### Session behavior

| Event/state | Coordinator behavior | User Host behavior | Task Host behavior |
| --- | --- | --- | --- |
| Logon | Reconcile WTS session; wait for task-launched registration | Launcher starts host; handshake; begin only after Ready | None until assignment |
| Console/RDP connect | Revalidate session state; permit work if policy allows | Resume heartbeat and request work | May start after revalidation |
| Unlock | Mark active after WTS reconciliation and host report agree | Resume; discard stale assignment if deadline/session generation changed | New process only; do not resume a killed risky task |
| Lock | Stop assigning immediately; send pause/cancel | Cancel source reads; retain minimized unacknowledged page only; idle | Cooperative cancel, then job termination |
| Disconnect | Treat as paused even if process remains | Pause/cancel; continue only health heartbeat at bounded rate | Terminate unless capability is explicitly disconnect-safe; temporary default is terminate |
| Fast user switch | Old session pauses; new session gets independent host/pipe | Each exact logon SID/session acts independently | Bound only to parent User Host |
| Same account in two logons | Maintain distinct logon SID/authentication LUID/session tuples | Separate process DACL, mutex, dedicated pipe, connection key | Separate parent/job/scratch |
| Logoff | Drain briefly; close channel; purge ephemeral secrets | Cancel, exit; OS may terminate leftovers | Job is terminated and scratch cleaned |
| Service restart | Close all channels; rebuild bootstrap; require fresh handshakes | Detect pipe loss; bounded reconnect with jitter; no stale handoff reuse | Parent policy determines cancel; default terminate |
| Policy kill switch | Stop handoffs/assignments; drain | Stop collection; retain only allowed minimized state | No launch; active job killed after grace |

Both WTS state and User Host-reported state are inputs. If either says locked, disconnected, logging off, or unknown, collection is paused. This fail-closed rule contains notification races.

## 3.8 Task Host

### Security purpose

**RECOMMENDATION:** Task Host is a crash, resource, write, child-process, UI, and network containment boundary for a fixed risky collector. It is not a safe place for arbitrary third-party code and is not proof that same-user data cannot be read.

### Launch contract

- Parent: only `Uam.UserHost.exe`.
- Executable: exact protected `Uam.TaskHost.exe`; non-null `lpApplicationName`; no path search.
- Command line: only `--protocol 1 --mode <compiled-enum> --run <random-id>`; no paths, URLs, SQL, scripts, or source values.
- Input/output: exactly two inherited anonymous pipe handles, identified through a fixed startup descriptor; no Coordinator pipe, token handle, job handle, registry handle, source database handle, or network handle is inherited.
- Process: suspended, `CREATE_NO_WINDOW | CREATE_SUSPENDED | EXTENDED_STARTUPINFO_PRESENT | CREATE_UNICODE_ENVIRONMENT`.
- Job: associated atomically through `PROC_THREAD_ATTRIBUTE_JOB_LIST` where supported; otherwise assign while suspended and verify before resume. [MS-JOB-03]
- Environment: a small allowlist (`SystemRoot`, safe runtime variables, private `TEMP`/`TMP`, culture if required); remove proxy, credential, diagnostic, profiler, COMPlus/DOTNET startup-hook, and user-controlled loader variables.

### Token

Use a duplicate of the User Host primary token and `CreateRestrictedToken` with:

- `DISABLE_MAX_PRIVILEGE`, retaining only `SeChangeNotifyPrivilege` as documented;
- administrative/elevated groups disabled or deny-only;
- `WRITE_RESTRICTED` plus a unique per-run restricting SID if the runtime prototype succeeds;
- token integrity set to Low;
- no AppContainer capability in the first design;
- token session unchanged;
- token source/authentication LUID recorded only in volatile validation state, never logs.

**FACT:** A restricted token causes an access check against enabled SIDs and restricting SIDs; access succeeds only when both checks pass. `WRITE_RESTRICTED` applies restricting SIDs to write access. A restricted version of the caller's token can be used with `CreateProcessAsUser` without `SeAssignPrimaryTokenPrivilege`; `CreateProcessAsUser` may still require `SeIncreaseQuotaPrivilege`, which must be tested. [MS-TOKEN-02] [MS-PROC-01]

**RECOMMENDATION:** First prototype both launch paths:

1. `CreateProcessAsUserW` with a restricted duplicate of the caller's own token; and
2. `CreateProcessW` after temporarily setting the restricted token only where documented and safe is not acceptable—do not improvise token substitution.

Select the path that works without adding a prohibited privilege. If neither works, stop and open an ADR; do not silently weaken the token.

### Write confinement

Create `%ProgramData%\UAM\task-scratch\<random-run-id>` with:

- SYSTEM and Administrators full;
- exact interactive user SID and unique run restricting SID with the required create/read/write/delete rights;
- a Low mandatory integrity label allowing low-integrity writes;
- no inheritance from a broader user-writable directory;
- no links/reparse points; verify every opened output handle remains under the scratch directory by final path and file ID.

The unique restricting SID means a write-restricted token must pass both the normal user ACL and the run-SID ACL. Other user locations normally lack the run SID and should reject writes. This is a **CLI EXPERIMENT** because .NET runtime/native SQLite/temp behavior may require writes outside scratch. A single successful write outside scratch fails the stronger profile and requires either fixing the dependency or documenting a weaker alternative through ADR.

### Job Object

Initial job limits are **ESTIMATE** safety caps, not production budgets:

```text
JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE
JOB_OBJECT_LIMIT_DIE_ON_UNHANDLED_EXCEPTION
JOB_OBJECT_LIMIT_ACTIVE_PROCESS = 1
No breakaway flags
Process memory cap: 256 MiB
Wall deadline: capability assignment deadline, initially <= 60 s for synthetic G1
CPU time: bounded per-process/job limit selected by prototype
Completion port: observe NEW_PROCESS, EXIT_PROCESS, ACTIVE_PROCESS_ZERO, limit messages
```

The User Host holds the only durable job handle. A User Host crash closes the handle and kills the tree. Cancellation is cooperative token/message, then a short grace, then `TerminateJobObject`, wait, close, and scratch cleanup. Do not infer safety from a missing completion-port notification; use handle waits and postcondition checks as well. [MS-JOB-01] [MS-JOB-02]

### Process mitigations

Apply before resume where supported and compatible:

- DEP; bottom-up/high-entropy ASLR and force-relocate images where compatible;
- terminate on heap corruption;
- strict handle checks;
- disable extension points;
- disallow Win32k system calls for a non-UI Task Host;
- prohibit remote and low-integrity image loads;
- prefer System32 image loading;
- child-process creation restriction as defense in depth;
- CFG when the binary/native dependencies are built compatibly;
- font disable after compatibility proof.

Do not enable these by default without proof:

- Prohibit dynamic code/ACG for JITted .NET; reconsider if NativeAOT passes all tests;
- Microsoft-signed-only/CIG, because UAM and a native SQLite provider may not meet it;
- UI restrictions that conflict with nested jobs or required runtime behavior;
- an alternate desktop unless Win32k cannot be disabled and the human threat model requires it.

**FACT:** Chromium's Windows sandbox uses layered restricted tokens, Job Objects, desktop/integrity controls, and process mitigations; it also documents that integrity alone still permits many reads and that AppContainer without network capability can strengthen network denial. This is reference evidence, not a dependency or proof of UAM equivalence. [OSS-CHROMIUM]

### Network prohibition

- `Uam.UserHost.exe` and `Uam.TaskHost.exe` contain no network client dependency and fail architecture tests if they reference one.
- MSI installs explicit inbound and outbound block rules for every side-by-side executable path, all profiles, all addresses, all protocols.
- A later enterprise `PolicyAppId` may replace per-path rules if approved and measured.
- Effective-policy tests run after GPO refresh. A local rule existing in the registry is not proof that it is active.
- Coordinator alone may own endpoint transport in later gates.

**Residual limitation:** A local administrator or enterprise policy can disable/override rules. AppContainer would provide stronger kernel-enforced capability denial but adds filesystem/runtime deployment complexity; it is a change condition in Section 4.

## 3.9 Realm isolation, configuration ownership, and kill switches

### Realm binding

- The Coordinator obtains realm/device binding only from service-only protected registration state and, later, authenticated device credentials.
- IPC messages contain no realm ID, device ID, tenant ID, user name, SID, or arbitrary subject claim.
- The Coordinator stamps the machine/realm association after validation.
- G1 evidence uses a synthetic realm ordinal (`realm-0`) with no production identifier.
- Realm reassignment requires drain, audited administrative authorization, and a human-approved disposition for queued data and keys. Runtime policy cannot perform it silently.

### Configuration precedence

```text
effective capability set =
    compiled product privacy ceiling
  ∩ signed release manifest
  ∩ signed realm/device policy
  ∩ local emergency deny set
```

Every layer may narrow; none may broaden a preceding layer. Unknown values fail closed.

### Typed feature flags and emergency kill switches

| Flag | Scope | Default for G1 | Effect |
| --- | --- | --- | --- |
| `Collection.Enabled` | machine/realm | false until G0 and G1 prerequisites | Stops all assignments |
| `UserHostRegistration.Enabled` | machine | true for proof | Allows handshake only |
| `TaskHost.<Capability>.Enabled` | capability | synthetic capability only | Allows one compiled mode |
| `Ipc.AcceptData` | machine | false until handshake tests pass | Handshake may run; data frames rejected |
| `EmergencyDrain` | machine | false | No new work; cancel/drain/exit |
| `Protocol.MinMinor` | release | current supported floor | Rejects stale minor versions below signed floor |
| `Build.RollbackFloor` | release | signed value | Prevents unauthorized downgrade |

Flags are typed, signed, versioned, expiry-bounded where emergency use is intended, reason-coded, and audit-relevant. There is no generic key/value script switch or executable path override.

## 3.10 Secure coding and review rules

- Use `SafeHandle` subclasses for service, process, token, pipe, job, completion-port, registry, and file handles.
- Keep `unsafe` and P/Invoke in `Uam.Windows.Interop`; prefer source-generated `[LibraryImport]` or a pinned CsWin32 build-time generator. Never expose a raw pointer or buffer to business code.
- Capture `GetLastError` immediately; use checked size arithmetic; reject integer overflow before allocation.
- Treat every native output length, SID, ACL, token group count, CBOR length, and frame length as hostile.
- No pipe-client impersonation; no thread-token state changes in Coordinator.
- Use constant-time MAC comparison and clear connection secrets with `CryptographicOperations.ZeroMemory`.
- Clear pooled buffers containing payloads before return.
- Enable nullable reference types, warnings-as-errors, analyzers, banned APIs, deterministic builds, package lock files, SBOM, secret scanning, CodeQL, and signed provenance.
- Fuzz frame parsing, CBOR parsing, state transitions, cancellation races, and native error paths.
- Every protocol or contract review includes a privacy-ceiling check. A new field is denied until classified and authorized.
- Exception messages, paths, SIDs, PIDs, user names, URLs, source values, raw payloads, and native buffers never enter durable logs.

## 3.11 Privacy-safe observability and accessible operator output

### Logs and metrics

Durable events contain only:

```text
utc coarse timestamp
component enum
operation enum
outcome enum
stable error code
protocol major/minor
release compatibility class
bounded counters and latency bucket
synthetic/ephemeral boot-session ordinal when needed
```

They do not contain user/session SIDs, authentication LUIDs, user names, device/realm identifiers, PIDs, pipe names/suffixes, file paths, URLs, titles, source cursors, assignment IDs, correlation IDs, payload digests, exception text, or raw values.

Metric labels are a closed enum set: `component`, `operation`, `outcome`, `error_class`, `protocol_major`. Build hash, realm, device, session, PID, capability input, and correlation values are not labels. **ESTIMATE:** static analysis must prove no more than 256 possible time series per process for the G1 metric set; the human resource decision replaces this number.

### Diagnostics

- Verbose diagnostics require a signed, time-limited local authorization and can only add approved structural facts.
- Raw ProcMon/ETW/PML traces remain in a restricted lab directory; the shareable evidence contains normalized counts and categories only.
- Diagnostic export runs a denylist/canary scanner before signing the evidence manifest.

### Data-quality boundary

G1 treats data quality as a protocol and transaction property, not as permission to collect more detail:

- every message type has a closed schema, required-field set, type/range/length limits, canonical ordering, and explicit protocol/schema version; unknown or duplicate keys fail before persistence;
- page identity, assignment identity, sequence, declared event count, cursor generation, minimized-field policy version, and content digest must agree with Coordinator-owned state; payload user, session, device, or realm claims are forbidden rather than reconciled;
- an exact retry of an already committed page returns the prior outcome; reuse of an identity with different canonical content is `IdentityContentConflict` and disables that assignment;
- invalid pages, partial frames, Task Host crashes, timeout/cancellation, or unsupported source state never advance progress and never create a raw fallback record;
- quality telemetry is categorical and bounded: accepted/rejected counts by stable reason, page/event counts, schema version, cursor relation, and latency bucket. It contains no source value, path, URL, title, SID, account, PID, cursor body, or event digest.

The G1 synthetic fixture must include missing/extra/duplicate fields, boundary lengths, non-canonical CBOR, count mismatches, stale/future generations, exact retry, identity/content conflict, and crash-before/after-commit cases. Later source-specific quality semantics remain G2/G3/G4 work.

### Accessibility

All CLI tools:

- emit plain text and `--jsonl`/`--json` modes;
- use stable exit codes and machine-readable error IDs;
- never use color as the only signal;
- support redirected output and screen readers;
- keep progress bounded and avoid constantly rewritten console lines;
- make pass/fail visible in text and structured evidence.

## 3.12 Error taxonomy

| Code | Meaning | Retry class | Operator action |
| --- | --- | --- | --- |
| `G1-IPC-001` | Pipe create/ownership failure | Service restart once, then stop | Check squatter, ACL, namespace, release integrity |
| `G1-IPC-002` | Server identity proof failed | No data retry | Verify SCM PID, session 0, process DACL, release manifest |
| `G1-IPC-003` | Client process/token query failed | Fresh handshake, bounded | Verify launcher token/process ACL and service privilege list |
| `G1-IPC-004` | Session/logon/authentication tuple mismatch | No | Close; run isolation test |
| `G1-IPC-005` | Frame/CBOR/version violation | No on same channel | Close; rate-limit source; preserve structural counter |
| `G1-IPC-006` | MAC, replay, or sequence violation | Fresh handshake only | Treat as hostile; no payload logging |
| `G1-IPC-007` | Quota/backpressure limit | Jittered bounded | Shed handshake/data work, retain committed state |
| `G1-IPC-008` | Handshake/read/write timeout | Fresh handshake | Close and release all resources |
| `G1-TASK-001` | Restricted token construction failed | No automatic weakening | Stop capability; inspect sanitized token facts |
| `G1-TASK-002` | Task Host launch failed | Bounded retry by policy | Check privilege/runtime/manifest |
| `G1-TASK-003` | Job association/limit failure | No resume | Terminate suspended child; close handles |
| `G1-TASK-004` | Mitigation incompatibility | No silent fallback | Open compatibility ADR with one change at a time |
| `G1-TASK-005` | Write or network confinement failed | No | Kill switch capability; preserve evidence |
| `G1-LIFE-001` | Task registration/effective XML mismatch | No collection | Repair MSI/task policy or human redesign |
| `G1-LIFE-002` | Session lifecycle mismatch | Pause | Reconcile WTS; fresh handshake |
| `G1-LIFE-003` | Crash loop | No | Disable collection; incident runbook |
| `G1-INSTALL-001` | ACL/service/task/firewall drift | No collection | Repair and re-run verification |

## 3.13 Incident response, support ownership, and minimum runbooks

**RECOMMENDATION:** assign an accountable support owner before pilot and name one technical owner for each boundary. Runtime code records only stable incident categories; privileged evidence collection and repair are deliberate operator actions. No incident mode may broaden privileges, ACLs, fields, logging, retention, or network access.

| Incident class | Detection and immediate containment | Minimum sanitized evidence | Recovery and cleanup | Accountable function to assign |
| --- | --- | --- | --- | --- |
| Service privilege/ACL/release mismatch | Startup self-check fails; keep collection off; disable restart storm | Effective token categories, binary ACL comparison, release/file identity/signature result, SCM config hash | MSI repair, required reboot, rerun G1 identity checks; remove stale release only after handle/process proof | Endpoint Runtime + Release Engineering |
| IPC cross-session, fake peer, replay, malformed-client or resource event | Close channel, invalidate handoff, rate-limit bootstrap identity, set `IpcIsolationFailure`; do not log payload | Connection-state transitions, redacted peer-role/session relation, stable error/count, resource series, manifest hashes | Stop all collection, preserve sanitized evidence, patch/rollback, rerun full hostile campaign, verify pipe/process cleanup | Product Security + IPC Engineering |
| Task Host write/network/child/handle escape | Close Job, kill tree, disable capability globally within signed/emergency authority | Token/Job/mitigation/handle categories, file-ID/root relation, effective firewall result, stable failure code | Repair/firewall policy or redesign token/broker; delete synthetic scratch; prove no orphan/rule drift | Sandbox/Endpoint Security |
| Privacy canary or raw-value escape | Stop affected capability and diagnostics/export immediately; treat as privacy incident | Canary class/location category only, component/release/schema IDs, bounded counts; raw evidence remains restricted | Governed deletion/containment, code/config fix, independent scan and G4 rerun before enablement | Privacy Engineering + Incident Response |
| Lifecycle/crash-loop/task-policy mismatch | Finite recovery then safe-disable; no token/privilege fallback | State-generation trace, task XML/SDDL hash, WTS event categories, restart ledger | Enterprise policy correction or MSI repair/rollback; terminate stale Hosts/Jobs; rerun lifecycle matrix | Endpoint Operations/Enterprise Management |
| Store/ACK/cursor invariant failure | Stop assignment and upload path; preserve durable synthetic store read-only | Failpoint, transaction/page identity categories, commit/ACK timeline, integrity-check result | Restore proof fixture, fix transaction/idempotency, rerun every crash point; never advance cursor manually | Endpoint Storage Engineering |

Minimum runbooks before pilot: privacy canary; service token/ACL drift; pipe squatting/fake peer; crash-loop disable; stale User/Task Host; task/GPO mismatch; firewall override; signed rollback; repair/reboot; evidence capture and retention; and uninstall disposition. Each runbook names authorization, prerequisites, commands/tool versions, pass/fail, escalation, rollback, evidence sanitization, neighboring-canary protection, and final cleanup verification.

---

# 4. Alternatives, rejection reasons, and change conditions

## 4.1 Process and identity alternatives

| Alternative | Decision | Rejection reason | Condition that reopens it |
| --- | --- | --- | --- |
| One monolithic service, including user-profile collection | Reject | Violates accepted user/session boundary; service would need profile/token access and expands blast radius | Only a formal baseline change with new primary evidence and migration plan; no current evidence supports it |
| Service runs as `LocalSystem` | Reject | Grants broad local authority and makes token creation/profile access tempting; not required by documented design | G1 proves a specific indispensable API cannot work under any lower identity and a narrow broker/PPL design has a better measured risk profile |
| Service runs as `NetworkService` | Reject | Adds machine network credentials without G1 need; still does not solve user-session launch cleanly | A later authenticated transport design proves this identity is required and PKI/network risk is accepted |
| Dedicated virtual service account instead of `LocalService` | Keep as fallback | Could provide a cleaner account SID but increases account/service provisioning and estate-policy questions; restricted service SID already supplies object isolation | `LocalService` cannot query the prepared User Host process/token with the one-privilege list, or enterprise policy requires a managed virtual account |
| Service calls `WTSQueryUserToken`, duplicates tokens, or launches User Host | Reject | Conflicts with accepted “Coordinator does not create user tokens”; commonly pushes service toward highly privileged identities | Only an explicit baseline change after Scheduled Task proof fails across the approved estate |
| Per-user installed service | Reject | Service creation is privileged, lifecycle is difficult, and it blurs machine/user ownership | Enterprise platform provides a supported per-user service mechanism with better isolation and manageable scale |
| Startup folder, Run key, shell extension, or user self-registration | Reject | User-modifiable, hard to repair/audit, poor session-event coverage, and easy to disable or replace | None for privileged boundary; an enterprise user-context deployment agent could replace the task if centrally managed and proved |
| Scheduled Task directly starts `Uam.UserHost.exe` | Reject in final design | Leaves a short process-object DACL hardening race before the host holds secrets | Reopen only if Windows/Task Scheduler gains a supported process-security-descriptor option or measurement proves the threat out of scope |
| One User Host per Windows user SID rather than logon session | Reject | Same account may have multiple logons/sessions; user SID is not a session boundary | Human support model guarantees one logon session and accepts loss of fast-switch/RDS isolation, with explicit ADR |

## 4.2 Scheduled Task alternatives

| Alternative | Decision | Why |
| --- | --- | --- |
| `GroupId=S-1-5-4`, `TASK_LOGON_GROUP`, `LeastPrivilege` | Recommend | Uses the existing interactive token for every logged-on interactive principal without credentials or service token creation |
| `HighestAvailable` | Reject | Can yield elevated/high-integrity User Host and broadens source/process access |
| S4U logon | Reject | Non-interactive token semantics and resource access differ; does not satisfy “ordinary interactive session” |
| Password logon | Reject | Stores/manages credentials and can run while logged off; unacceptable blast radius |
| Per-user task generated at first logon | Reject as default | Adds mutation/race/audit complexity and lets user/task ACL state diverge | Enterprise management cannot support group tasks but can securely deploy per-user tasks before logon |
| Event-log subscriptions instead of session-state triggers | Reference only | Can supplement diagnostics but adds brittle event IDs/query dependencies; WTS reconciliation is still required |

## 4.3 IPC alternatives

| Alternative | Decision | Rejection reason | Change condition |
| --- | --- | --- | --- |
| One global named pipe with only `INTERACTIVE` ACL | Reject | Does not isolate sessions; all interactive users can attempt application traffic |
| One pipe per user SID | Reject | Same account in multiple logon sessions shares the SID |
| Two-stage local named pipes with exact logon-SID handoff | Recommend | Native local identity APIs, explicit ACLs, simple deployment, no listener port or credential |
| Pipe client impersonation for identity | Reject | Requires/encourages `SeImpersonatePrivilege`, adds thread-token state, and is unnecessary if process/token objects are queryable | Token query cannot be made reliable with prepared ACLs and an alternative is shown safer through a hostile prototype |
| ALPC | Reject for first implementation | Excellent local primitive but low-level, sparsely documented for app protocols, and costly to implement/review in managed code | Named pipes fail measured DoS, performance, or identity requirements and an ALPC prototype has lower total risk |
| COM/RPC local server | Reject for G1 | Activation/security configuration is broader, identity and versioning are less transparent, and attack surface is larger | Existing approved enterprise COM/RPC infrastructure materially reduces complexity and passes equivalent hostile tests |
| Loopback TCP/gRPC/HTTP | Reject | Creates a network listener, firewall/proxy ambiguity, port ownership, and more dependencies; local peer identity is harder | Cross-platform endpoint requirement is approved and a mutually authenticated local transport passes equivalent session isolation |
| Windows Unix-domain sockets | Reject | Less mature estate evidence and no advantage over named pipes for Windows token/logon-SID DACLs | Named-pipe platform incompatibility is proved |
| Memory-mapped files/events | Reject as primary IPC | Harder framing, lifetime, ACL, crash, and backpressure semantics; easier shared-memory corruption | Measured throughput makes copying dominant and a rigorously bounded design is proved |
| Third-party secure-pipe package as runtime dependency | Reject initially | UAM needs exact ACL rights, native PID/session calls, held process handles, and a protocol-specific handshake; no reviewed package supplies the whole boundary | A maintained .NET package exposes every required primitive, has security review/fuzzing, and reduces—not hides—risk |

## 4.4 Task Host alternatives

| Alternative | Decision | Rejection reason | Change condition |
| --- | --- | --- | --- |
| In-process collector | Reject for risky collection | A parser/native crash or hang takes down User Host; no job/resource boundary | Collector is proved pure, bounded, memory-safe, and low-risk through a separate ADR |
| Restricted token + low IL + Job + explicit handles | Recommend | Smallest native containment set compatible with an ordinary user source reader |
| Full Chromium sandbox library | Reference only | Large broker/interception architecture and browser-specific complexity; wrong dependency and threat model | UAM adopts hostile third-party collector code and funds a dedicated broker sandbox |
| AppContainer/LPAC Task Host | Defer, not reject | Stronger network/capability isolation but requires extensive filesystem/runtime ACL deployment and compatibility work | Same-user reads or firewall override become in-scope threats, or G1 egress/write tests fail under the restricted-token design |
| Windows Sandbox/VM per collection | Reject | Operational/resource cost and unavailable endpoint assumptions | Extremely high-risk collector with approved cost/support model |
| Arbitrary scripts/plugins in Task Host | Reject | Process isolation does not make arbitrary code safe; defeats release/privacy ceiling | No foreseeable condition under current baseline; requires a new product architecture and security model |
| NativeAOT Task Host | Measure later | Could enable dynamic-code prohibition and reduce runtime surface, but native provider/diagnostic compatibility is unknown | All functional, signing, size, debugging, and mitigation tests pass with lower operational cost |
| Private alternate desktop | Defer | Adds complexity/memory and may conflict with non-UI runtime; Win32k disable may suffice | Win32k cannot be disabled or UI-message attacks are in scope |

## 4.5 Service process protection alternatives

- **PPL/launch-protected service:** reject. Microsoft restricts protected service launch to specially signed classes such as antimalware-light; this is not a normal product control. [MS-SVC-04]
- **Kernel driver:** reject. It expands privilege, deployment, signing, and incident cost without a G1 need.
- **Local administrator resistance:** not claimed. Detect and repair ACL/config drift; do not represent runtime DACLs as protection from administrators.

## 4.6 Change-proposal rule

A change to an accepted baseline decision must include:

1. affected decision and invariant;
2. new primary evidence;
3. security/privacy and operational impact;
4. alternatives considered;
5. smallest falsifying CLI experiment;
6. migration and rollback consequence;
7. ADR status/action and accountable function.

No alternative is adopted merely because a library is popular or because a happy-path demo works.

---

# 5. Interfaces, protocols, contracts, Windows objects, and privileges

## 5.1 Named-pipe namespace

**FACT:** `CreateNamedPipeW` requires `\\.\pipe\pipename`; the `pipename` portion cannot contain a backslash, the name is case-insensitive, and `PIPE_REJECT_REMOTE_CLIENTS`, `FILE_FLAG_FIRST_PIPE_INSTANCE`, and overlapped mode are available. [MS-PIPE-02]

**RECOMMENDATION — canonical lowercase flat names:**

```text
Bootstrap: \\.\pipe\uam.<install-id-32hex>.v1.bootstrap
Handoff:   \\.\pipe\uam.<install-id-32hex>.v1.s.<random-32hex>
```

Rules:

- `<install-id>` is a random public installation namespace identifier generated by MSI, not a device/realm/user identifier.
- `<random>` is 128 random bits generated per handoff with the OS CSPRNG.
- Names contain no SID, user name, realm, tenant, device, capability, path, or production ID.
- Clients and logs use a redacted category, never the random suffix.
- Only local machine syntax is valid. Any UNC/server name is rejected before opening.
- The server sets `PIPE_REJECT_REMOTE_CLIENTS`; the client checks the server session is 0.

## 5.2 Pipe creation modes and ownership

### Bootstrap

```text
CreateNamedPipeW(
  name,
  PIPE_ACCESS_DUPLEX | FILE_FLAG_OVERLAPPED | FILE_FLAG_FIRST_PIPE_INSTANCE,
  PIPE_TYPE_BYTE | PIPE_READMODE_BYTE | PIPE_WAIT | PIPE_REJECT_REMOTE_CLIENTS,
  max_instances,
  out_buffer,
  in_buffer,
  default_timeout,
  explicit_security_attributes)
```

- Keep the first-instance anchor open for service lifetime. It may be a non-accepting anchor; subsequent accept instances use identical attributes without `FILE_FLAG_FIRST_PIPE_INSTANCE`.
- **ESTIMATE:** 16 accepting instances plus one anchor, 64 KiB advisory input/output buffers.
- Never pass a null security descriptor. Microsoft documents that the default pipe DACL grants broad read access and that `FILE_GENERIC_WRITE` includes `FILE_CREATE_PIPE_INSTANCE`; use individual rights. [MS-PIPE-01]

### Dedicated handoff pipe

- Create one instance before sending `ServerHandoff`.
- Use `FILE_FLAG_FIRST_PIPE_INSTANCE`, `PIPE_REJECT_REMOTE_CLIENTS`, byte/overlapped mode, one maximum instance, and an exact-logon-SID DACL.
- The pipe expires after the handshake deadline and is deleted when the last handle closes.
- A second connect, wrong PID/session, or stale handoff closes and invalidates it.

## 5.3 Exact security descriptor templates

Placeholders such as `<SERVICE_SID>` and `<LOGON_SID>` are converted to binary SIDs by the installer/runtime; string substitution is never performed on untrusted text. DACLs are protected from inheritance. The G1 verifier canonicalizes and compares binary ACEs, not only SDDL text order.

### Rights constants used

```text
PIPE_CLIENT_RW_ATTR_SYNC = 0x00120183
  FILE_READ_DATA          0x00000001
  FILE_WRITE_DATA         0x00000002
  FILE_READ_ATTRIBUTES    0x00000080
  FILE_WRITE_ATTRIBUTES   0x00000100
  READ_CONTROL            0x00020000
  SYNCHRONIZE             0x00100000

PROCESS_QUERY_SYNC       = 0x00101000
  PROCESS_QUERY_LIMITED_INFORMATION 0x00001000
  SYNCHRONIZE                       0x00100000

TOKEN_QUERY              = 0x00000008
SERVICE_QUERY_STATUS_RC  = 0x00020004
SERVICE_ALL_ACCESS       = 0x000F01FF
```

`PIPE_CLIENT_RW_ATTR_SYNC` intentionally excludes bit `0x00000004`, which aliases `FILE_APPEND_DATA`/`FILE_CREATE_PIPE_INSTANCE` for named pipes.

### Normative SDDL forms

| Object | SDDL template / exact access intent | Notes |
| --- | --- | --- |
| Coordinator service object | `O:SYG:SYD:P(A;;0x000F01FF;;;SY)(A;;0x000F01FF;;;BA)(A;;0x00020004;;;IU)` | SYSTEM/Admin configure; interactive can only read control/query status for server PID proof |
| Scheduled Task object | `O:SYG:SYD:P(A;;FA;;;SY)(A;;FA;;;BA)` | Register with `TASK_DONT_ADD_PRINCIPAL_ACE`; interactive principal receives no mutation ACE |
| Bootstrap pipe | `O:SYG:SYD:P(A;;FA;;;SY)(A;;FA;;;<SERVICE_SID>)(A;;0x00120183;;;IU)` | Interactive can read/write/attributes/sync, not create a server instance |
| Dedicated pipe | `O:SYG:SYD:P(A;;FA;;;SY)(A;;FA;;;<SERVICE_SID>)(A;;0x00120183;;;<LOGON_SID>)` | Exact logon SID only; no user-SID or generic Interactive ACE |
| Coordinator process object | `O:LSG:SYD:P(A;;GA;;;SY)(A;;GA;;;<SERVICE_SID>)(A;;0x00101000;;;IU)(A;;RC;;;OW)` | Lets User Host verify PID/image; no VM read/dup handle; Owner Rights suppresses implicit DACL write |
| User Host process object | `O:<USER_SID>G:<PRIMARY_GROUP_SID>D:P(A;;GA;;;SY)(A;;GA;;;<LOGON_SID>)(A;;0x00101000;;;<SERVICE_SID>)(A;;RC;;;OW)` | Created before resume by launcher; other logon of same user is owner but `OW` ACE removes implicit `WRITE_DAC`/`WRITE_OWNER` |
| User Host initial thread | Same as User Host process, but Coordinator receives no thread access unless a test proves it necessary | Launcher keeps initial thread handle until resume, then closes |
| User Host primary token object | `O:<USER_SID>G:<PRIMARY_GROUP_SID>D:P(A;;GA;;;SY)(A;;GA;;;<LOGON_SID>)(A;;0x00000008;;;<SERVICE_SID>)(A;;RC;;;OW)` | Enables Coordinator `TOKEN_QUERY`; current launcher retains an existing handle while changing DACL |
| Per-session mutex/event | `O:<USER_SID>G:<PRIMARY_GROUP_SID>D:P(A;;GA;;;SY)(A;;GA;;;<LOGON_SID>)(A;;RC;;;OW)` | `Local\` namespace; exact logon SID, not user SID |
| Task Host process/thread | SYSTEM and exact logon SID full; parent User Host receives required handles at creation; `OWNER RIGHTS` only `RC` | Explicit attributes, never default DACL |
| Task Host scratch directory | DACL: SYSTEM/Admin full; `<USER_SID>` Modify; `<RUN_RESTRICTING_SID>` Modify; protected inheritance. SACL: `S:(ML;;NW;;;LW)` | Both normal user and restricting SID checks must pass for write; low-integrity label permits low writer |

**FACT:** The Owner Rights SID (`S-1-3-4`, SDDL `OW`) represents the current owner. When an ACE for it is present, Windows ignores the owner's implicit `READ_CONTROL` and `WRITE_DAC` rights. [MS-SID-01]

**CLI EXPERIMENT:** Verify the SDDL/masks on every supported OS. If a documented generic mapping differs for a Task Scheduler object or process token, generate the binary ACL from named constants and compare effective access; do not widen to `GENERIC_WRITE` or `Everyone`.

## 5.4 Windows object/ACL/privilege table: filesystem, registry, certificate, process, pipe, and firewall objects

| Resource | Owner/configuration authority | Runtime access | Explicitly denied/absent | Verification |
| --- | --- | --- | --- | --- |
| `%ProgramFiles%\UAM\releases` | MSI; owner SYSTEM; protected DACL | SYSTEM/Admin Full; service SID RX; Built-in Users RX | No user write/create/delete; no inherited user-writable ACE | `Get-Acl`, `icacls`, file ID/hash/signature manifest |
| Current/rollback manifest | MSI/release authority | Service and interactive processes Read | No runtime write | Signature, hash, ACL, rollback-floor test |
| `%ProgramData%\UAM\runtime` | MSI creates; Coordinator owns content | SYSTEM/Admin Full; service SID Modify | Interactive users none | ACL plus hostile create/read/delete attempts |
| SQLite/data directory | Coordinator | SYSTEM/Admin Full; service SID Modify | User Host/Task Host none | Architecture test plus ACL access test |
| Diagnostics staging | Coordinator | SYSTEM/Admin Full; service SID Modify | Interactive users none until sanitized export | Canary scan and ACL evidence |
| `HKLM\Software\UAM\Public` | MSI | Service/User Host Read; Admin/SYSTEM Write | No user write | Registry ACL/effective access |
| `HKLM\Software\UAM\Machine` | MSI/Coordinator for bounded runtime values | SYSTEM/Admin Full; service SID Read/Write | Interactive users none | Registry ACL plus hostile access |
| Task object/folder | MSI/enterprise | Task Scheduler as SYSTEM; Admin management | Principal cannot modify/delete | Export XML, task SDDL, non-admin mutation attempts |
| SCM service object | MSI/enterprise | System/Admin manage; interactive query status only | No user start/stop/change config/delete | `sc.exe sdshow`, hostile service-control attempts |
| Bootstrap/dedicated pipes | Coordinator | Per Sections 5.2–5.3 | Remote clients; server-instance creation by users; wrong logon SID | Native `GetSecurityInfo`, remote/local hostile tests |
| User Host process/token/mutex | Launcher/User Host | Exact logon SID; service query only; SYSTEM | Same user in different logon lacks dup/VM/DACL write | Effective-access and 10,000 handle-theft attempts |
| Task Host scratch | User Host creates; removes | Restricted Task Host can write only here | Reparse points, external writes, broad inheritance | Final-path checks and write corpus |
| Job/completion port/anonymous pipes | User Host | Handle-only; exact explicit inheritance | No names; no Task Host job handle; no Coordinator pipe | Child handle enumeration and `PROC_THREAD_ATTRIBUTE_HANDLE_LIST` evidence |
| Local-machine device certificate private key, if later present | MSI/PKI tooling | SYSTEM and exact Coordinator service SID sign/read as required | User Host/Task Host/interactive users | CNG/CAPI key ACL; **UNKNOWN** until PKI decision |
| Firewall rules | MSI or approved enterprise policy | Blocks User Host/Task Host inbound/outbound, all profiles | Runtime cannot edit; no allow exception | Effective-policy export plus synthetic sink test |

## 5.5 Privilege and token table

| Process | Expected identity/integrity | Required/allowed privileges | Prohibited state | Gate evidence |
| --- | --- | --- | --- | --- |
| MSI custom action/enterprise installer | Elevated administrative install context, temporary | Only what Windows Installer needs during transaction | No persistent updater/admin process | MSI log, resulting ACL/config, rollback test |
| Coordinator | `LocalService`, session 0, restricted service SID | SCM required list exactly `SeChangeNotifyPrivilege`; effective token only that enabled privilege | Any enabled/held prohibited privilege; impersonation; interactive SID; high/system user token | `sc qprivs`, service SID query, custom token dump |
| Launcher | Existing ordinary interactive primary token, medium IL | Ordinary user privileges; no special UAM grant | Elevated/high/system/service/AppContainer; dangerous enabled privilege | Token dump before child creation |
| User Host | Same logon/session ordinary token, medium IL | Ordinary user; only normal policy-provided privileges; UAM grants none | High/elevated; service/batch-only; token/session mismatch | Coordinator and local token dumps agree |
| Task Host | Restricted primary token, low IL | `SeChangeNotifyPrivilege` only after `DISABLE_MAX_PRIVILEGE` | Admin groups enabled; any other privilege; medium/high IL; unexpected capability SID | Parent and child independent token evidence |

Prohibited privilege set for G1 includes at minimum: `SeTcb`, `SeDebug`, `SeImpersonate`, `SeAssignPrimaryToken`, `SeIncreaseQuota`, `SeBackup`, `SeRestore`, `SeTakeOwnership`, `SeLoadDriver`, `SeCreateToken`, `SeCreateGlobal`, and `SeSecurity`. Estate policy may add more denials; it may not remove these without an ADR.

## 5.6 Mutual process and session validation

### Coordinator validates client

Immediately after `ConnectNamedPipe` succeeds, before parsing more than the fixed bootstrap header:

1. Call `GetNamedPipeClientProcessId` and `GetNamedPipeClientSessionId`.
2. Open the client process with `PROCESS_QUERY_LIMITED_INFORMATION | SYNCHRONIZE`; keep the handle open until channel close.
3. Read process creation time with `GetProcessTimes`; this and the held handle bind the PID and defeat PID reuse.
4. Confirm `ProcessIdToSessionId` equals the pipe-reported session.
5. Resolve/open the executable; verify final path, volume/file ID, signed release manifest hash, signature, and allowed release.
6. Open the process token with `TOKEN_QUERY`, enabled by the launcher-prepared token DACL.
7. Read `TokenUser`, `TokenGroups`/logon SID, `TokenStatistics.AuthenticationId`, `TokenSessionId`, `TokenIntegrityLevel`, `TokenElevationType`, `TokenElevation`, `TokenIsAppContainer`, `TokenType`, and restriction state.
8. Require one exact logon SID (`SE_GROUP_LOGON_ID`), ordinary medium token, eligible interactive WTS session, non-elevated state, and consistency among all session values.
9. Reject if a different PID is already registered for the tuple `(logon SID, authentication LUID, WTS session ID)`.
10. Re-run the PID/session/token/image checks on the dedicated pipe and compare with the held bootstrap tuple.

The service never calls `ImpersonateNamedPipeClient` and never accepts a client-supplied SID/session/user claim.

### User Host validates server

Before trusting `ServerHandoff`:

1. Call `GetNamedPipeServerProcessId` and `GetNamedPipeServerSessionId`; require session 0.
2. Open SCM and the `UamCoordinator` service with `SERVICE_QUERY_STATUS`; read `SERVICE_STATUS_PROCESS.dwProcessId` and require equality.
3. Open and hold the server process with `PROCESS_QUERY_LIMITED_INFORMATION | SYNCHRONIZE` using the Coordinator process DACL.
4. Read creation time; verify protected image final path/file ID/hash/signature and current/rollback authorization.
5. Check service state is `SERVICE_RUNNING` and service configuration/manifest ID is compatible.
6. Repeat on the dedicated pipe and compare PID/creation time.

A user cannot trust “the pipe opened” as server authentication. A path string alone is insufficient.

## 5.7 Identity tuple and registration record

The authoritative volatile connection identity is:

```text
ClientIdentity {
  process_handle          // held SafeProcessHandle; never serialized
  process_id              // volatile; never durable metric label
  process_creation_time
  image_file_id
  image_manifest_id
  token_user_sid
  token_logon_sid
  authentication_luid
  token_session_id
  pipe_client_session_id
  process_session_id
  wts_session_generation
  token_integrity_class
  token_elevation_class
}
```

Only privacy-safe categorical facts and an ephemeral session ordinal may be logged. Realm/device association is appended internally by Coordinator registration state, not by the client.

## 5.8 Handshake

### Random values

- `client_nonce`: 32 bytes from `RandomNumberGenerator.Fill`.
- `server_nonce`: 32 bytes from `RandomNumberGenerator.Fill`.
- `handoff_secret`: 32 bytes from `RandomNumberGenerator.Fill`.
- `connection_id`: 16 bytes random.
- dedicated suffix: 16 bytes random, lowercase hex.

No value is persisted. All are zeroed when the channel closes.

### Flow

```text
User Host                             Coordinator
   |                                      |
   |-- open bootstrap ------------------->|  kernel PID/session captured
   |-- BootstrapHello ------------------->|  validate process/token/image/WTS
   |                                      |  create exact-logon-SID one-use pipe
   |<-- ServerHandoff --------------------|  secret + nonces + limits + suffix
   |  verify SCM PID/session/image        |
   |-- open dedicated pipe -------------->|  recapture and compare identity tuple
   |-- ClientFinish [HMAC] -------------->|  transcript/sequence/MAC validation
   |<-- ServerReady [HMAC] ---------------|  connection becomes Ready
   |-- Heartbeat/CollectionPage [HMAC] --->|
   |<-- SessionState/Assignment/Ack ------|
```

### Key derivation

```text
connection_key = HKDF-SHA256(
    input_key_material = handoff_secret,
    salt = client_nonce || server_nonce,
    info = UTF8("uam-ipc-v1") || connection_id || transcript_hash,
    length = 32)
```

`transcript_hash` is SHA-256 over the exact framed `BootstrapHello` and `ServerHandoff` bytes. This uses standard HKDF/HMAC, not a bespoke encryption algorithm. [RFC-5869]

### Replay and PID-reuse controls

- One-use dedicated pipe; fresh suffix, secret, nonces, and connection ID for every connection.
- Held process handles and creation times across bootstrap and dedicated phases.
- Strictly contiguous independent transmit sequence numbers beginning at 1 after handoff.
- A duplicate, gap, wrap, wrong connection ID, or MAC failure closes the channel.
- Reconnect always starts a new handshake; no sequence or key resume.
- Handoff deadline is measured with a system monotonic clock; **ESTIMATE:** 5 seconds.
- Old current/rollback release is accepted only during a signed compatibility window; no payload can request a downgrade.

The HMAC adds protection against a duplicated pipe handle without the connection key. It does not encrypt local pipe data and does not protect secrets from local administrator or same-session process-memory compromise.

## 5.9 IPC wire protocol and exact 88-byte header/framing

All integers are little-endian. The fixed header is exactly 88 bytes.

| Offset | Size | Field | Rule |
| ---: | ---: | --- | --- |
| 0 | 4 | Magic | ASCII `UAM1` |
| 4 | 2 | Header size | `88` |
| 6 | 2 | Protocol major | current major |
| 8 | 2 | Protocol minor | negotiated minor |
| 10 | 2 | Message type | closed enum |
| 12 | 4 | Flags | unknown/reserved bits must be zero |
| 16 | 4 | Payload length | unsigned; checked against type/channel cap before allocation |
| 20 | 4 | Reserved | zero |
| 24 | 8 | Sequence | zero for bootstrap types; starts at 1 after handoff |
| 32 | 8 | Correlation number | random/monotonic local value; never an identity; zero allowed where not applicable |
| 40 | 16 | Connection ID | zero in `BootstrapHello`; selected ID thereafter |
| 56 | 32 | HMAC-SHA-256 | all zero for allowed bootstrap frames; otherwise required |

The MAC input is:

```text
header bytes 0..55
|| 32 zero bytes for the tag slot
|| payload bytes
```

Read algorithm:

1. read exactly 88 bytes with a header deadline;
2. validate magic/header/major/minor/type/flags/reserved/length without allocating payload;
3. rent at most the validated bounded payload buffer;
4. read exactly payload length with total-frame deadline;
5. verify connection ID, sequence, and MAC before CBOR decode;
6. decode with depth/count/type limits;
7. clear and return buffer.


## 5.10 Deterministic CBOR payload profile

**RECOMMENDATION:** use RFC 8949 CBOR with a deliberately small deterministic profile. The encoding is compact, binary-safe, and available in the .NET shared framework through `System.Formats.Cbor`; those facts do not make arbitrary CBOR safe. UAM therefore defines these normative restrictions:

1. A payload is exactly one definite-length CBOR map.
2. Map keys are unsigned integers. Text keys are forbidden on the wire.
3. Definite-length strings, byte strings, arrays, and maps only; indefinite-length items are rejected.
4. Integers use the shortest form. Map keys use deterministic bytewise order.
5. Floating-point numbers, decimal fractions, big numbers, date/time tags, shared-reference tags, and every other CBOR tag are forbidden.
6. Maximum nesting depth is 8. The sum of map entries and array elements in one payload is at most 4,096, and each message type has a smaller schema-specific limit.
7. Duplicate keys, missing required keys, wrong major types, overlong encodings, and non-canonical ordering are protocol errors.
8. Unknown keys below `1024` are errors. Keys `1024..16383` are optional extensions and must be ignored only after their encoded value has passed the generic size/depth checks. Keys above `16383` are reserved.
9. Text must be well-formed UTF-8 and, for enum-like strings allowed by a future major version, NFC-normalized. G1 messages use integer enums rather than free text.
10. The decoder reads from a bounded frame buffer; it never streams an unbounded item into memory and never instantiates arbitrary CLR types through reflection.

The encoder must run in strict deterministic mode. Tests must compare encoded bytes, not only decoded objects. A production minor version may add an optional extension key; it may not reinterpret an existing key or make an optional key mandatory.

## 5.11 Message types and channel rules

| Type | Code | Direction | Channel/state | Maximum payload | Normative purpose |
| --- | ---: | --- | --- | ---: | --- |
| `BootstrapHello` | 1 | User Host → Coordinator | bootstrap/new | 8 KiB | Offers compatible versions and proves the protected client image is running. |
| `ServerHandoff` | 2 | Coordinator → User Host | bootstrap/validated | 8 KiB | Selects a version and supplies one-use dedicated-pipe material. |
| `ClientFinish` | 3 | User Host → Coordinator | dedicated/authenticating | 4 KiB | MAC-protected transcript confirmation. |
| `ServerReady` | 4 | Coordinator → User Host | dedicated/authenticating | 4 KiB | Confirms limits, current state, and readiness. |
| `Heartbeat` | 10 | either | ready | 2 KiB | Liveness plus categorical health; no source values. |
| `SessionState` | 11 | Coordinator → User Host | ready | 4 KiB | Lock/disconnect/drain/kill-switch state. |
| `CollectionAssignment` | 20 | Coordinator → User Host | ready | 16 KiB | Requests one fixed capability with bounded work and a policy digest. |
| `CollectionPage` | 21 | User Host → Coordinator | ready/assignment active | 256 KiB hard cap | Carries only typed, already minimized synthetic or approved events plus source progress. |
| `CommitAck` | 22 | Coordinator → User Host | ready/assignment active | 8 KiB | Acknowledges the exact result digest after the durable local transaction commits. |
| `CollectionTerminal` | 23 | User Host → Coordinator | ready/assignment active | 8 KiB | Reports success-with-no-page, defer, cancellation, or typed failure. |
| `Cancel` | 30 | either | ready | 4 KiB | Cancels one correlation/assignment; idempotent. |
| `DrainAndExit` | 31 | Coordinator → User Host | any post-ready | 4 KiB | Stops new work and requests bounded exit. |
| `ProtocolError` | 255 | either | only when safe to reply | 4 KiB | Categorical error and close intent; never echoes rejected bytes. |

**Normative channel rule:** bootstrap types are never accepted on a dedicated channel; all other types are never accepted on the bootstrap channel. A message arriving in the wrong state closes the connection after a privacy-safe categorical diagnostic.

## 5.12 Example contracts

The notation below is diagnostic YAML for readability. Numbers on the left are the actual CBOR integer keys. It is not a second wire format.

### `BootstrapHello`

```yaml
1: h'32-byte-client-nonce'
2:                         # offered protocol ranges, at most four
  - {1: 1, 2: 0, 3: 2}    # major, minimum minor, maximum minor
3: h'32-byte-release-manifest-sha256'
4: h'16-byte-launch-id'     # random, task invocation only; not durable identity
5: 0                        # feature bits; unknown bits must be zero
6: 1                        # client kind = UserHost
```

The client does not send a SID, username, session number, realm, device identifier, executable path, or claimed PID. The Coordinator obtains those facts from Windows.

### `ServerHandoff`

```yaml
1: {1: 1, 2: 1}            # selected major/minor
2: h'32-byte-server-nonce'
3: h'16-byte-connection-id'
4: "uam.<install>.v1.s.<random>"
5: h'32-byte-one-use-handoff-secret'
6: 5000                     # handoff deadline, milliseconds
7: {1: 262144, 2: 8, 3: 1} # max frame, max queued data frames, active assignments
8: h'32-byte-service-release-manifest-sha256'
```

The suffix is a canonical local pipe leaf, not an arbitrary path. The client rejects separators, prefixes, non-ASCII characters, mixed case, or a value that does not match the exact grammar.

### `CollectionAssignment`

```yaml
1: h'16-byte-assignment-id'
2: 1                        # capability = synthetic edge-site-history proof
3: h'16-byte-source-generation-id'
4: {1: 0}                   # opaque minimized cursor; G1 synthetic unsigned counter
5: 30000                    # wall deadline in milliseconds
6: {1: 500, 2: 262144}      # max events, max encoded result bytes
7: h'32-byte-effective-policy-digest'
8: h'16-byte-cancellation-id'
9: true                     # synthetic-data-required in G1
10: 1                        # task isolation mode enum
```

The assignment contains no user-owned path, URL, title, raw browser row, SQL, script, assembly name, or command line. A later collector contract may use a fixed source selector enum plus a release-owned local derivation; it may not turn this field into an arbitrary path channel.

### `CollectionPage`

```yaml
1: h'16-byte-assignment-id'
2: h'16-byte-result-id'
3: 0                        # page index
4: true                     # final page
5:                         # bounded typed minimized events
  - {1: h'16-byte-event-id', 2: 1, 3: 1780000000000, 4: "example.test"}
6: {1: 42}                  # next minimized source-progress token
7: h'32-byte-content-digest' # SHA-256 of canonical keys 1..6
8: 1                        # schema revision
```

The example domain is fictional. Whether a site/domain string, timestamp precision, or any other field is approved is outside G1 and remains bound by G0/product privacy ceiling. A G1 implementation must use synthetic fixed values only.

### `CommitAck`

```yaml
1: h'16-byte-assignment-id'
2: h'16-byte-result-id'
3: h'32-byte-content-digest'
4: 1                        # disposition = committed
5: {1: 42}                  # authoritative committed cursor
6: h'16-byte-local-commit-id'
```

`local-commit-id` is an opaque Coordinator-generated identifier for diagnostics and retry correlation. It is not a server receipt and does not imply upload.

## 5.13 Version negotiation and schema evolution

The Coordinator chooses the highest common minor within one common major. There is no “best effort” decode:

- Different majors with no overlap: send `ProtocolError(UnsupportedMajor)` on bootstrap and close.
- Same major: select `min(clientMax, serverMax)` if it is not below either side's minimum.
- A minor change may add optional extension keys, new optional enum values only behind negotiated feature bits, and stricter local limits that remain within published hard maxima.
- A field removal, semantic reinterpretation, authentication change, ordering change, or newly required field needs a new major.
- A client with an unknown selected feature bit closes rather than silently ignoring it.
- Compatibility is bounded to the current signed release and one explicitly authorized rollback release in G1. The exact production support window is a **HUMAN DECISION** under lifecycle policy.
- The installed manifest defines a minimum allowed release generation. Neither IPC peer can lower it through a message.

## 5.14 Quotas, deadlines, and hostile-client containment

These values are **ESTIMATES** for G1 safety, not production performance budgets. Replace them only with measured evidence and an ADR.

| Control | G1 value | Failure behavior |
| --- | ---: | --- |
| Bootstrap payload | 8 KiB | Reject before allocation; close. |
| Dedicated hard frame | 256 KiB | Reject before allocation; close. |
| Pipe input/output buffer request | 64 KiB each | Treat as an OS reservation request, not a guaranteed flow-control limit. |
| Ready User Host channels | 1 per validated logon identity tuple | New connection replaces only after old channel is drained/closed; otherwise reject. |
| In-progress handshakes | 2 per WTS session; 32 machine-wide | Refuse excess without blocking accept loop. |
| Data receive queue | 8 frames/channel | Stop reads; if sender misses deadline, cancel/close. |
| Control queue | 4 messages/channel | Coalesce idempotent state updates; never drop drain/cancel. |
| Active collection assignments | 1 per User Host | Reject additional assignment locally as `Busy`; Coordinator queues boundedly. |
| Header deadline | 2 seconds | Cancel overlapped read; disconnect. |
| Full handshake deadline | 5 seconds | Destroy one-use pipe/secret; disconnect. |
| Data-frame deadline | 15 seconds | Cancel assignment; disconnect after one categorical error if safe. |
| Heartbeat interval | 30 seconds | No PII or identity labels. |
| Idle channel timeout | 90 seconds without a valid frame | Disconnect and let task/lifecycle trigger reconnect. |
| Bootstrap rate per WTS session | burst 4, refill 1/second | Delay/reject before expensive token/image work. |
| Bootstrap machine rate | burst 32, refill 16/second | Reject and increment bounded categorical counter. |
| Authentication failures | 5 per session in 60 seconds | Cool down that session's bootstrap for 60 seconds; service remains responsive to others. |
| Decode CPU | one bounded synchronous decode per channel; no parallel recursive decode | Cancel/close on budget breach; fuzz gate. |

The accept loop must create a small connection object, capture PID/session, and enqueue bounded validation work. It must not perform signature verification, file hashing, token enumeration, or CBOR parsing inline. Expensive image validation is cached only by a tuple containing file ID, last-write/size, release manifest digest, and signer result; the cache is bounded and invalidated on release change.

Malformed input handling is fail-closed and non-reflective: do not echo input bytes, requested pipe names, SIDs, paths, or exception messages. Repeated invalid clients cannot force an unbounded task, thread, timer, log label, event source, or allocation.

## 5.15 Cancellation, shutdown, and backpressure

Every async operation accepts a cancellation token linked to:

- service stop/drain;
- channel lifetime;
- assignment deadline;
- explicit `Cancel` correlation;
- Task Host job completion; and
- emergency capability kill switch.

`Cancel` is idempotent. Receipt means “cancellation requested,” not “work has stopped.” The terminal response reports one of `CancelledBeforeStart`, `CancelledDuringRead`, `CancelledAfterMinimizationBeforeSend`, or `AlreadyCommitted`; it never reports raw source state.

On lock, disconnect, policy disable, or service drain:

1. stop assigning new work;
2. signal the active User Host operation;
3. close the Task Host job handle if its grace deadline expires;
4. finish or roll back the Coordinator's current SQLite transaction;
5. ACK only a committed page;
6. close the channel after bounded drain.

Backpressure is explicit. The User Host retains at most one unsafely unacknowledged minimized result page in memory and does not advance its source progress past that page. It may resend exactly the same canonical bytes/result ID after reconnect. It never spills raw source rows or arbitrary SQL to disk.

## 5.16 Transaction and ACK boundary

The G1 proof uses a synthetic local SQLite schema sufficient to prove the invariant; it does not settle the later endpoint data model.

```sql
CREATE TABLE synthetic_event (
    event_id       BLOB PRIMARY KEY CHECK(length(event_id) = 16),
    result_id      BLOB NOT NULL CHECK(length(result_id) = 16),
    page_index     INTEGER NOT NULL,
    event_ordinal  INTEGER NOT NULL,
    event_kind     INTEGER NOT NULL,
    event_time_ms  INTEGER,
    minimized_text TEXT,
    UNIQUE(result_id, page_index, event_ordinal)
) STRICT;

CREATE TABLE source_progress (
    source_generation_id BLOB PRIMARY KEY CHECK(length(source_generation_id) = 16),
    cursor_cbor          BLOB NOT NULL,
    last_result_id       BLOB NOT NULL CHECK(length(last_result_id) = 16),
    last_digest          BLOB NOT NULL CHECK(length(last_digest) = 32),
    local_commit_id      BLOB NOT NULL CHECK(length(local_commit_id) = 16)
) STRICT;
```

For each `CollectionPage`, the single Coordinator writer performs:

```text
BEGIN IMMEDIATE
  validate assignment, canonical digest, schema and product ceiling
  INSERT events with stable event IDs
  UPSERT progress only if cursor transition is valid
  record result ID + digest + local commit ID
COMMIT
send CommitAck
```

Normative retry rules:

- Same `result_id`, same digest, already committed: return the original authoritative ACK; do not create a second business effect.
- Same `result_id`, different digest: classify `Integrity.ResultIdDigestConflict`, disable that session capability, retain only privacy-safe evidence, and require investigation.
- Event uniqueness conflict with identical canonical event: idempotent.
- Event uniqueness conflict with different canonical event: integrity fault; no cursor advance.
- Crash before commit: no ACK; transaction rolls back; exact page is retried.
- Crash after commit but before ACK: exact retry returns original ACK.
- Cursor advancement without corresponding durable minimized events: test failure and release stop.

A Coordinator ACK is local endpoint custody only. It is unrelated to the later server durable receipt boundary.

## 5.17 Task Host private handle protocol

The User Host creates two anonymous pipes before launch:

- request: User Host writes; Task Host receives a read-only inherited handle;
- result: Task Host writes; User Host receives a read-only result.

Only the two child ends and, where needed, a non-inheritable job completion handle are placed in `PROC_THREAD_ATTRIBUTE_HANDLE_LIST`. `bInheritHandles` is true only for the explicit list. Every other handle is non-inheritable. The Task Host receives numeric handle values through fixed command-line switches such as `--request-handle=0x...`; the command line contains no source values, paths, identities, policy, URL, or realm.

The private frames reuse the 88-byte framing idea but use a separate magic `UAT1`, a random per-run key delivered inside the request pipe after launch, a 64 KiB hard frame cap, and exactly these messages:

| Message | Purpose |
| --- | --- |
| `TaskStart` | Fixed capability enum, bounded synthetic selector, limits, policy digest, run nonce. |
| `TaskResult` | Typed minimized result only. |
| `TaskTerminal` | Categorical completion or failure. |
| `TaskCancel` | User Host requests cancellation; job close remains authoritative kill. |

The Task Host cannot open the Coordinator pipe. Its image contains no network client, SQLite writer, dynamic loader, script engine, or central protocol assembly. The User Host validates the result schema and product ceiling again before sending it to the Coordinator.

## 5.18 Error contract

```text
ErrorEnvelope {
  category       : closed enum
  stage          : closed enum
  retryability   : Never | SameConnection | Reconnect | Later | HumanAction
  disposition    : Continue | CancelAssignment | CloseChannel | DisableCapability | StopService
  correlation    : ephemeral uint64
  safe_detail_id : optional release-owned integer
}
```

No `Exception.ToString()`, Win32 message text, path, SID, username, domain, URL, SQL, raw payload, or task command line crosses IPC or enters ordinary logs. A local debug build may map `safe_detail_id` to developer documentation; production diagnostics expose only the ID and source-controlled meaning.

## 5.19 Configuration contracts and ownership

Machine configuration is split so a user cannot widen behavior:

```text
HKLM\Software\UAM\Runtime\Install       MSI/SYSTEM/Admin only
HKLM\Software\UAM\Runtime\Release       signed repository/MSI only
HKLM\Software\UAM\Runtime\Emergency     authorized enterprise control only
HKLM\Software\UAM\Runtime\TenantNarrow  authenticated policy cache; may narrow only
HKCU\Software\UAM\Runtime\Presentation  user preferences only; never collection scope
```

Every policy object has `schema_version`, `policy_id`, `issued_at`, `not_before`, `expires_at`, `release_floor`, `realm_binding_digest`, and a signature/authentication envelope. The effective policy is the intersection of release privacy ceiling, non-expired realm-bound tenant narrowing, emergency kills, and local platform capability. Missing, stale, malformed, cross-realm, or signature-invalid policy cannot widen collection and defaults the affected capability to off.

# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility

## 6.1 Coordinator state machine

```text
Installed
   |
   v
Starting -> ValidateRelease -> ValidateConfig -> OpenStore -> ReconcileSessions
   |              |                |                |
   | failure      | failure        | failure        | bounded errors
   v              v                v                v
Stopped/       SafeStop         SafeStop          Running
Disabled                                           |
                                             +-----+------+------+
                                             |            |      |
                                           Drain       Faulted  UpgradePending
                                             |            |      |
                                             +------> Stopping <-+
                                                        |
                                                     Stopped
```

Normative rules:

- `SERVICE_RUNNING` is reported only after release/config validation, the SQLite writer is ready, the bootstrap anchor exists, and initial WTS reconciliation has completed or produced bounded per-session deferrals.
- SCM controls enqueue work and return promptly. Stop, preshutdown, and session notifications never run collector or database work on the control-handler thread.
- A release-integrity or privilege mismatch is `SafeStop`, not a restart storm.
- Repeated crashes trip the machine emergency disable marker after the configured finite SCM recovery attempts; a queued SCM restart is contained by disabling the service before repair because Windows documents that a queued restart action cannot otherwise be cancelled. [MS-SVC-04]

## 6.2 User Host lifecycle state machine

```text
TaskTrigger
   |
LauncherValidateTokenAndFiles
   | failure --------------------------> Exit(non-sensitive code)
   v
CreateProtectedSuspendedUserHost
   |
Resume -> Bootstrap -> DedicatedHandshake -> Ready
              |                |              |
              |                |              +--> ActiveAssignment
              |                |                        |
              |                |                    Ready/Drain
              |                |
              +------ bounded reconnect with jitter ----+
                                               |
                                 lock/disconnect/logoff/upgrade/kill
                                               v
                                             Drain
                                               |
                                             Exit
```

The Scheduled Task may create parallel launcher instances. The exact-logon-session mutex makes all but one exit after performing no sensitive work. This avoids Task Scheduler's machine-wide “ignore new” behavior suppressing a legitimate second interactive session.

The User Host does not survive logoff. On ordinary lock, it remains resident but collection is disabled unless a later capability is explicitly approved for locked sessions. On disconnect it drains and exits by conservative default; a reconnect trigger launches a fresh process. This minimizes stale-session state while RDP/VDI support is unknown.

## 6.3 Task Host state machine

```text
CreatePipesAndJob
       |
CreateRestrictedToken
       |
CreateSuspendedInJob -> VerifyToken/Job/Mitigations -> Resume
       |                           | failure
       |                           v
       |                        KillJob
       v
ReadOneTaskStart -> ExecuteFixedMode -> WriteOneResult/Terminal -> Exit
       |                 | timeout/cancel/fault
       |                 v
       +-------------- KillJob/Exit
```

Any unexpected second process, inherited handle, network event, write outside scratch, token privilege, or failure to assign the job before execution is a G1 test failure. Normal completion still closes the job handle and deletes the synthetic scratch tree after evidence capture.

## 6.4 Assignment and durability state machine

```text
Queued -> Sent -> Running -> PageReceived -> Validating -> TransactionOpen
  |        |       |             |               |             |
Cancel   timeout  cancel       invalid         invalid       crash
  v        v       v             v               v             v
Terminal/Retry/Disabled       Reject+Contain   Reject       RetrySamePage
                                                               |
                                                             Commit
                                                               |
                                                         AckPending
                                                         /        \
                                                     send ACK     crash
                                                       |           |
                                                    Complete   RetrySamePage
                                                                    |
                                                            ReturnOriginalACK
```

The transaction starts only after complete framing, MAC, CBOR, schema, assignment, minimization-ceiling, and digest validation. No partial event is inserted. ACK serialization happens only after `COMMIT` returns success.

## 6.5 Session lifecycle rules

| Windows event/state | Coordinator action | User Host action | Collection rule |
| --- | --- | --- | --- |
| Console/RDP logon | Reconcile eligible WTS session; task trigger is primary launcher. | Start ordinary token; handshake. | Disabled until ready and policy permits. |
| Console/RDP connect | Mark connected; task trigger starts/restarts if needed. | Handshake; report categorical state. | Candidate for approved capability. |
| Unlock | Mark unlocked; task trigger repairs absence. | Resume readiness; no implicit catch-up beyond policy. | Candidate for approved capability. |
| Lock | Send state/cancel; validate WTS state. | Cancel work; remain idle in conservative default. | Off. |
| RDP disconnect | Cancel and drain. | Exit after bounded drain. | Off. |
| Fast user switch | Keep separate exact logon identity/channel per session. | New session receives own User Host. | No cross-session assignment or ACK. |
| Same account in two sessions | Treat authentication LUID/logon SID/session as different identity tuples. | Separate mutex/pipe/channel. | Cross-use is hostile and tested 10,000 times. |
| Logoff | Cancel, close channel, forget volatile identity. | Task/process terminates; kill Task Host tree. | Off; no profile follow-up by service. |
| Service restart | Reconcile WTS sessions; wait for task trigger or invoke approved task run, never create tokens. | Reconnect with new handshake. | Retry exact unacknowledged minimized page only. |
| Sleep/hibernate | Drain where notified; monotonic deadlines expire. | Reconnect after resume trigger/reconciliation. | No wall-clock assumption. |
| Shutdown | Stop assigning, rollback/commit current local transaction, close pipes. | Cancel/exit. | No raw spill. |

**UNKNOWN:** exact behavior under RemoteApp, RDS multi-user hosts, FSLogix, Citrix, Azure Virtual Desktop, Windows 365, and non-persistent VDI. These are support decisions and platform-specific G1 extensions, not implied by the base design.

## 6.6 Install/uninstall and failure-recovery sequence — installation

The MSI is the only component allowed to establish the privileged boundary.

```text
1. Verify MSI signature, package identity, upgrade code, and release manifest.
2. Fail if an unapproved newer release floor would be lowered.
3. Stop/drain an existing service; close Task Hosts through their jobs.
4. Install versioned binaries under Program Files with inherited ACLs disabled.
5. Apply explicit file/directory ACLs and verify owner is TrustedInstaller or Administrators
   according to packaging policy; ordinary users receive execute/read only where required.
6. Create ProgramData and registry trees with split service-SID/SYSTEM/Admin ACLs.
7. Create service as NT AUTHORITY\LocalService, own process, delayed automatic start.
8. Set SERVICE_SID_TYPE_RESTRICTED and required privileges = SeChangeNotifyPrivilege.
9. Set service object DACL, finite failure actions, failure-action flag, and no dependencies
   beyond RPCSS/Task Scheduler unless a measured requirement proves one.
10. Register the exact group task XML using TASK_LOGON_GROUP, INTERACTIVE SID,
    LeastPrivilege, TASK_DONT_ADD_PRINCIPAL_ACE, and SYSTEM/Admin task DACL.
11. Install outbound and inbound block rules for UserHost and TaskHost on all profiles.
12. Grant the service SID access to a device certificate private key only when an approved
    device-identity design exists; G1 has no certificate dependency.
13. Persist the signed release manifest and install ID; never a tenant-supplied executable path.
14. Re-read every SCM/task/ACL/firewall setting and compare with the manifest.
15. Reboot before the first formal G1 token test so the restricted service SID is effective.
16. Start the service; trigger a synthetic user task; collect health evidence.
```

A fresh proof installation may start before reboot only to validate explicit detection that the SID type is pending. It must not claim G1 passage until after reboot and token inspection.

## 6.7 Upgrade, rollback, and mixed-version sequence

```text
Coordinator current release R
    -> set UpgradePending; stop new assignments
    -> drain User Hosts; kill expired Task Host jobs
    -> stop service
MSI -> install R+1 side-by-side; validate signature/manifest/ACLs
    -> update immutable current-release pointer atomically
    -> update task action and firewall file rules
    -> start R+1; run self-check and synthetic handshake
    -> keep signed R as explicit rollback candidate
    -> remove R only after no R process/handle and rollback window expires
```

Rules:

- A running old User Host can finish only an already committed/acknowledged local operation during drain. It cannot receive new work after `UpgradePending`.
- R+1 accepts R User Host only when R is named in the signed compatibility manifest and the negotiated protocol overlaps. It never accepts an arbitrary older signed binary.
- Rollback is an explicit MSI/enterprise operation that sets the current pointer to the authorized rollback manifest. IPC cannot request rollback.
- Database schema migration must be forward-safe for the declared rollback window or the release is rejected before service start. Destructive migration belongs to a later storage ADR.
- Failed R+1 startup reactivates R only after its manifest and schema compatibility are revalidated; otherwise leave collection off and preserve minimized local data.

## 6.8 Repair and install-failure recovery

MSI repair must compare content hashes, file IDs, owners, ACLs, service configuration, task XML/SDDL, firewall rules, and registry ACLs against the signed install manifest. Drift is restored only by the privileged installer or explicit enterprise repair command; the running Coordinator does not self-elevate or rewrite its executable boundary.

On install failure:

1. stop any partially created service;
2. disable it to cancel queued restart behavior;
3. unregister only the package-owned task and firewall rules;
4. restore the prior immutable release pointer and configurations from MSI rollback data;
5. remove only newly installed version directories after confirming no process holds them;
6. preserve existing minimized endpoint data unless the transaction is a never-activated synthetic G1 install;
7. emit a local installer event with categorical phase/error and package product code, not paths or user identity.

## 6.9 Uninstall sequence

```text
1. Set machine kill switch and disable the task.
2. Drain Coordinator and User Hosts; close every Task Host job.
3. Stop and disable the service; wait for process exit.
4. Capture a privacy-safe inventory of unacknowledged minimized data state.
5. Apply the approved uninstall disposition.
6. Remove service, task, firewall rules, certificate ACL ACEs, registry, ProgramData,
   and versioned binaries in that order, verifying no orphan process/object remains.
7. Reboot-delete only package-owned locked files; never broad directories.
8. Verify service/task/rules/pipes/processes are absent.
```

**HUMAN DECISION:** production uninstall disposition for unacknowledged minimized data: preserve for repair/export under governance, attempt bounded final upload, or securely delete. G1 uses synthetic data and deletes it during cleanup. Research does not choose the production option.

## 6.10 Compatibility rules

| Dimension | Rule |
| --- | --- |
| OS | Only explicitly approved and tested Windows editions/builds; runtime checks reject unsupported builds rather than guessing. |
| Architecture | Publish explicit RID packages; G1 starts with x64 only as a conservative lab default. ARM64 requires its own signed binaries and full G1 rerun. |
| .NET | Target .NET 10 LTS as reviewed on 31 July 2026, with exact supported patch selected at build/release time. Runtime roll-forward is pinned by release policy, not ambient machine state. |
| Protocol | Same major plus negotiated minor; current release and one explicit rollback release only for G1. |
| Task XML | Installer owns a canonical normalized XML digest and the task DACL. Enterprise policy incompatibility fails closed. |
| Store | Schema carries min/max reader/writer release generation; no irreversible migration inside rollback window. |
| Flags | Unknown flag IDs are ignored only when signed schema marks them optional; an unknown safety-critical flag disables the related capability. |
| Release | Signature, repository authorization, freshness/freeze, release floor, and manifest hash all pass before execution. |
| Realm | Installation is bound to one realm registration; policy or payload cannot relabel it. Re-enrollment is an audited administrative workflow. |

# 7. Security/privacy threat and failure register

“Owner” below means the accountable function that must be assigned before implementation or operation. It does not assert an existing organizational title.

| ID | Trigger / failure | Detection | Containment | Recovery and cleanup | Accountable function to assign | Test / evidence | Residual risk |
| --- | --- | --- | --- | --- | --- | --- | --- |
| T01 | User from session A opens session B dedicated pipe. | Pipe DACL denial plus hostile-client counter; service receives no accepted frame. | Exact logon SID DACL and identity-tuple validation. | Close handle; no state change; retain categorical count. | Endpoint Runtime Engineering | G1-X01, 10,000 attempts each direction. | Windows/EDR defects or administrator can bypass DAC. |
| T02 | Same account in two sessions steals/duplicates the other User Host process or token handle. | Hostile handle-open/duplicate attempts, Audit/ETW/ProcMon evidence, creation-time mismatch. | Pre-start process/thread/token DACL with exact logon SID, service query rights, SYSTEM, and `OWNER RIGHTS` restriction; held process handles. | Kill affected channels/processes; rotate handoff; repair ACL; stop release on any success. | Windows Security Engineering | G1-X02, 10,000 attempts; process/token DACL dump. | Same-SID isolation is subtle and must be proven on supported builds; admin/EDR remains outside boundary. |
| T03 | Malicious process squats bootstrap pipe before service. | Service fails `FILE_FLAG_FIRST_PIPE_INSTANCE`; health `PipeNameOccupied`. | Anchor is created before service reports running; service safe-stops. | Identify owner PID/image with privileged support tooling; remove only after investigation; reinstall/repair. | Endpoint Runtime + Incident Response | G1-X03 before/after service start. | Local admin can continuously interfere. |
| T04 | Remote SMB client reaches pipe. | Remote attempt logs network denial; no pipe connection. | `PIPE_REJECT_REMOTE_CLIENTS`, local `\\.\pipe` use, firewall hardening. | Close/alert categorical; verify no remote server service exposure assumption. | Endpoint Security Operations | G1-X04 from isolated lab peer where approved. | Platform bugs/misconfiguration; remote test environment is a human decision. |
| T05 | PID is reused between pipe query and token validation. | Held process handle creation time/file identity differs or process exits. | Open and retain process handle immediately; compare PID, creation time, session and image at both phases. | Reject; destroy one-use pipe/key; retry fresh. | Endpoint Runtime Engineering | G1-X05 rapid process churn/PID pressure. | Kernel compromise is out of scope. |
| T06 | Fake service process creates expected pipe. | User Host compares pipe server PID/session with SCM PID and signed image/manifest. | Bootstrap first-instance plus mutual server validation and service process DACL. | Exit without sending source data; enterprise repair. | Endpoint Runtime Engineering | G1-X06 hostile server/suspended real service. | Admin can alter SCM or inject; release signing must hold. |
| T07 | Client replays a valid frame. | Duplicate/non-contiguous sequence or stale connection ID/MAC. | Fresh nonces/key per connection; strict sequence; one-use handoff. | Close channel; retry assignment from durable state. | IPC Engineering | G1-I07 replay, reorder, gap, wrap. | Same-session memory theft can obtain key. |
| T08 | Client sends wrong MAC or mutates post-validation bytes. | Constant-time MAC failure. | Decode only after MAC; close channel. | Forget key/secret; capability cooldown after threshold. | IPC Engineering | G1-I08 bit-flip corpus. | HMAC is authentication, not local confidentiality. |
| T09 | Oversized/negative/overflowing length. | Header validation before allocation. | Fixed unsigned parsing, checked arithmetic, hard type caps. | Close; clear rented buffer; no echo. | IPC Engineering | G1-F01 malformed corpus/fuzzer. | Unknown runtime/library defect. |
| T10 | Slowloris sends partial header/body. | Monotonic header/frame deadline. | Cancel overlapped I/O; bounded handshake slots. | Disconnect and release all handles/timers. | IPC Engineering | G1-F02 10,000 paced fragments. | Large fleet of local attackers can consume bounded availability. |
| T11 | CBOR nesting, duplicate keys, pathological maps, invalid UTF-8. | Strict deterministic decoder rejects with categorical reason. | Depth/count/type/canonical limits; no reflection. | Close; clear buffer; fuzz regression seed. | IPC Engineering | G1-F03 coverage-guided fuzz and fixed corpus. | Decoder implementation defect. |
| T12 | Log amplification/cardinality attack using random IDs/PIDs. | Metric-series inventory and log-rate limiter. | IDs are not labels; bounded enum dimensions; coalescing/token buckets. | Drop/coalesce diagnostics, never operational data; reset counters on restart. | Observability Engineering | G1-O01 million random correlations. | Aggregate attacks can hide individual events; forensic detail deliberately limited. |
| T13 | Elevated/admin User Host starts due task misconfiguration. | Token dump checks elevation type, integrity, privileges, groups. | LeastPrivilege group task; launcher exits on high/system/AppContainer/restricted unexpected token. | Disable task/capability; MSI repair; no fallback token creation. | Endpoint Runtime Engineering | G1-T01 admin and standard users. | UAC-disabled environments may differ and require support decision. |
| T14 | Coordinator gains prohibited privilege after policy/update. | Startup token self-check plus external evidence collector. | SCM required-privilege allowlist; service safe-stops on mismatch. | Disable service; repair/reboot; security review. | Windows Security Engineering | G1-S01 `sc qprivs` plus token API. | OS may retain mandatory privileges not anticipated; gate decides support. |
| T15 | Coordinator accesses a user profile or user-owned source. | ProcMon/ETW denylist trace keyed to service PID/file ID. | Restricted service SID, ACL design, no profile discovery code/dependency. | Stop service/release; remove data/log artifact; incident review. | Privacy Engineering + Endpoint Runtime | G1-P01 synthetic profile canaries through all lifecycle cases. | Static review cannot prove absence; EDR can generate attributed noise requiring careful filter. |
| T16 | Raw source value enters Coordinator IPC, store, log, dump, or diagnostic. | Synthetic canary scanner over memory-safe evidence, IPC capture, DB, logs, crash artifacts. | User/Task Host minimize first; closed schemas and privacy-ceiling validators. | Kill capability, quarantine build, delete synthetic artifacts, root-cause and add canary. | Privacy Engineering | G1-P02 canary corpus; later G4 is authoritative privacy gate. | G1 synthetic proof does not approve real fields or transformations. |
| T17 | Tenant policy widens release product ceiling. | Effective-policy diff and signed schema validator. | Intersection only; unknown/invalid policy disables capability. | Reject policy; retain previous non-expired narrowing or off. | Policy/Privacy Engineering | G1-C01 property tests. | Correct ceiling content is a human/release governance dependency. |
| T18 | Payload claims another realm/device/session. | Schema rejects identity claim keys; server-side binding differs. | Identity is transport/registration context, never accepted from payload. | Close on forbidden identity fields; investigate issuer. | Endpoint + Control Plane Security | G1-R01 cross-realm synthetic policies/messages. | Registration authority compromise is outside G1. |
| T19 | Task Host launches child/breaks away from job. | Job completion port/process list, ETW process tree. | Active-process limit 1, no breakaway, child-process mitigation, job-at-create preference. | Close job; kill tree; disable task mode. | Sandbox Engineering | G1-H01 child/breakaway attempts. | Job nesting and platform-policy behavior varies; lab gate required. |
| T20 | Task Host writes outside scratch. | ProcMon file/registry trace and synthetic deny canaries. | Low integrity, write-restricted token, unique restricting SID, scratch ACL; no broad write handles. | Kill job; delete scratch; disable mode. | Sandbox + Privacy Engineering | G1-H02 file/registry matrix. | Low integrity/restricted token does not stop reads; some writable user locations may remain depending ACLs. |
| T21 | Task Host reads unrelated same-user files. | Canary files and ProcMon. | G1 does not claim complete read isolation; fixed code/mode and data minimization reduce exposure. | Stop release if required threat model expects denial; evaluate AppContainer/brokered handles. | Security Architecture | G1-H03 read-probe characterization. | **Known residual:** ordinary/restricted same-user tokens can often read same-user content. |
| T22 | Task Host reaches network despite application firewall blocks. | ETW/WFP/firewall log plus loopback/LAN/internet synthetic listeners. | All-profile inbound/outbound block rules; no network code; optionally AppContainer later. | Kill job; repair policy; fail supported environment. | Endpoint Security Operations | G1-H04 IPv4/IPv6/loopback/DNS/HTTP raw-socket attempts. | Higher-precedence enterprise policy or kernel/admin can override; firewall is policy, not token sandbox. |
| T23 | Task Host consumes CPU/memory/handles or hangs. | Job notifications, process counters, wall deadline. | Job memory/process limits, CPU policy where supported, bounded handles, kill-on-close. | Close job; clean scratch; categorical health. | Sandbox Engineering | G1-H05 resource bombs. | Exact safe budgets are measurement/human decisions. |
| T24 | User Host crashes and leaves Task Host running. | Job completion/process-tree reconciliation. | User Host owns kill-on-close job; service also tracks child PID only for health, not control token. | OS kills job members; installer cleanup verifies no orphan. | Endpoint Runtime Engineering | G1-H06 terminate User Host at every launch phase. | If job assignment failed before resume, process must never have run; gate verifies. |
| T25 | `CreateProcessAsUser` requires a privilege intentionally removed from service/User Host design. | Exact Win32 error and token evidence in prototype. | User Host creates from its own restricted primary token; no privilege escalation fallback. | Try documented `CreateProcessWithToken`/native launch alternatives only through ADR; otherwise stop Task Host design. | Windows Security Engineering | G1-H07 restricted-token launch on each supported build. | Platform/EDR policy may block; support choice may change. |
| T26 | Task Scheduler/GPO changes principal, run level, trigger, or task DACL. | Periodic canonical task XML/SDDL digest and launch-token mismatch. | User Host exits; Coordinator disables collection for affected session. | Enterprise policy exception or MSI repair; no service token fallback. | Endpoint Operations + Security | G1-T02 drift mutation set. | Some enterprises prohibit group tasks; human decision. |
| T27 | Firewall rules are deleted/overridden. | Effective WFP test, not registry presence alone. | Task mode disabled if deny cannot be demonstrated in supported environment. | Repair rules/policy; consider stronger sandbox ADR. | Endpoint Security Operations | G1-H04 and configuration drift. | Application firewall semantics vary with enterprise precedence. |
| T28 | Service crash loop/restart storm. | SCM failure count and local monotonic crash ledger. | Finite recovery, service disable marker, no autonomous re-enable. | Repair/rollback; operator runbook. | Endpoint Operations | G1-L01 repeated forced crashes. | Disabling monitoring reduces availability but protects endpoint. |
| T29 | Lock/disconnect races with assignment or ACK. | WTS state generation mismatch and event-timeline evidence. | Cancel; transaction atomicity; ACK only committed exact result. | Retry exact minimized page or defer. | Endpoint Runtime Engineering | G1-L02 randomized lifecycle fault injection. | Windows notifications are asynchronous; design contains, not eliminates, races. |
| T30 | Store commit succeeds but ACK is lost. | Same result ID/digest on reconnect; existing progress row. | Idempotent result/event uniqueness and original ACK replay. | Return original ACK; no duplicate business effect. | Endpoint Storage Engineering | G1-D01 crash at every transaction/ACK edge. | SQLite correctness/performance beyond synthetic schema is later gate. |
| T31 | ACK sent before durable commit or cursor advances alone. | Fault-injection oracle compares store, client cursor and ACK trace. | Single writer and ordered transaction/ACK code path. | Stop build; restore prior synthetic snapshot; fix invariant. | Endpoint Storage Engineering | G1-D02 exhaustive failpoints. | Hardware/filesystem durability is later storage proof. |
| T32 | Old/frozen/downgraded release executes. | Manifest/signature/release-floor/compatibility validation. | MSI-owned immutable versions; no IPC downgrade; service safe-stop. | Explicit authorized rollback or repair. | Release Engineering + Security | G1-U01 substitution/downgrade matrix. | Signing/repository authority and clock/freshness policies remain human/governance dependencies. |
| T33 | Release file is replaced after validation. | Held file handles/file ID/hash mismatch and Windows loader/signature evidence. | Protected Program Files ACL; immutable version path; launch exact path; revalidate file identity. | Kill process; disable service/task; MSI repair. | Release Engineering | G1-U02 rename/link/reparse/race attempts. | Administrator/kernel can replace or inject. |
| T34 | Certificate private-key ACL grants broad endpoint access. | Cryptographic provider ACL inventory and sign test as service SID/hostile users. | No certificate access in G1; later grant exact service SID only. | Remove ACE and re-enroll through approved identity workflow. | Device Identity Engineering | Future identity gate; G1 negative test. | HSM/TPM/provider semantics vary and are provisional. |
| T35 | Reparse point/junction escapes protected or scratch tree. | File ID/reparse checks and ProcMon. | Open with reparse-safe flags; reject reparse components; installer controls roots. | Kill task; delete only by handle/file-ID-confirmed path. | Windows Security Engineering | G1-H08 junction/symlink race. | Windows namespace complexity remains; use handle-relative checks where possible. |
| T36 | Malformed client causes service crash, deadlock, or persistent resource leak. | Process liveness, dump-free WER category, handle/thread/private-byte time series. | Async isolation, bounded pools, top-level per-connection containment. | SCM finite restart; hostile seed retained; cleanup all kernel handles. | IPC Engineering | G1-F04 10,000 malformed attempts plus fuzz soak. | Memory-safety benefits of managed code do not eliminate native interop defects. |
| T37 | Installer/uninstaller deletes unrelated data. | Manifest/file-ID inventory and synthetic neighboring canaries. | Package-owned exact paths/objects only; no wildcard parent deletion. | Abort/rollback; restore canary in lab; incident in production. | Release Engineering | G1-U03 install/repair/uninstall canary test. | MSI custom-action defects can be privileged. |
| T38 | Local administrator, security product, or kernel injects/reads processes. | Best-effort code integrity/EDR events; unexplained process handle access. | Not a claimed boundary; signed files, minimal secrets, rapid key rotation, incident controls. | Reimage/enterprise incident process as appropriate. | Enterprise Security | Characterization only. | **Accepted residual:** local admin/kernel compromise defeats endpoint process isolation. |
| T39 | Support bundle exposes identities or raw activity. | Automated forbidden-pattern/canary scan and schema validation. | Allowlisted categorical bundle; no arbitrary file collection. | Reject bundle generation; delete artifact; fix schema. | Support Engineering + Privacy | G1-O02 synthetic support-bundle scan. | Pattern scans cannot prove absence of every sensitive semantic. |
| T40 | Production environment lacks owner/runbook/on-call capacity. | Readiness checklist has unresolved accountable fields. | No production approval; keep capability off. | Assign owners, train, exercise runbooks, approve support model. | Human governance authority | Operational readiness review. | Research cannot supply organizational authority or staffing. |

# 8. Detailed test matrix and smallest falsifying prototypes

## 8.1 G1 hostile test harness specification and proof solution

The proof repository contains no production collector and uses synthetic data only:

```text
tests/G1/
  Uam.G1.CoordinatorProof/       LocalService Windows service; bootstrap/dedicated pipes
  Uam.G1.UserHost.Launcher/      scheduled-task action; protected suspended launch
  Uam.G1.UserHost/               ordinary-token session client and synthetic producer
  Uam.G1.TaskHost/               fixed hostile/synthetic task modes
  Uam.G1.HostileClient/          cross-session, same-SID, malformed, replay, slowloris tools
  Uam.G1.EvidenceCollector/      token/ACL/process/task/service/store evidence; redaction
  Uam.G1.FaultInjector/          named crash points and deterministic schedule
  Uam.G1.Protocol.Fuzz/          decoder/framing fuzz target
  Uam.G1.Tests.Unit/
  Uam.G1.Tests.Integration/
  install/Uam.G1.Proof.msi
  fixtures/synthetic/            fictional domains and random byte corpora only
```

The hostile tool has explicit verbs, for example:

```text
hostile cross-session --target-session <ordinal> --attempts 10000
hostile duplicate-handle --target-pid <ephemeral-pid> --object process,token --attempts 10000
hostile malformed --case corpus --attempts 10000 --parallel 16
hostile slowloris --header-byte-delay-ms 250 --attempts 10000
hostile replay --capture synthetic-frame.bin --modes duplicate,reorder,gap,old-connection
hostile squat --pipe-leaf <synthetic-install-pipe>
hostile fake-server --service-name UamCoordinatorG1
```

Evidence refers to sessions as run-local ordinals (`S1`, `S2`), never Windows usernames, SIDs, machine names, domains, addresses, or internal connection material.

## 8.2 Evidence bundle contract

Each run produces:

```text
artifacts/g1/<run-id>/
  manifest.json                 hashes, tool versions, test IDs, start/end UTC
  inventory.json               sanitized OS/runtime capability categories
  service.json                 SCM config, SID type, required privileges, service DACL
  tasks/userhost.xml            sanitized canonical task XML
  tasks/userhost-sddl.txt
  tokens/*.json                SID classes hashed/run-local, privilege/group/integrity flags
  acls/*.json                  object type, canonical ACE classes/rights, no raw account names
  events.jsonl                 normalized test observations
  metrics.csv                  time-series resource counters with bounded dimensions
  procmon/summary.json          allow/deny counts by synthetic canary class and operation
  network/summary.json         connection attempts/dispositions by protocol class
  store/checks.json            cursor/event/ACK invariant results
  junit.xml
  cleanup.json
  sha256sums.txt
```

Example `events.jsonl` record:

```json
{"schema":1,"test":"G1-X01","phase":"attempt","session":"S1","target":"S2","outcome":"access_denied","category":"Pipe.DaclDenied","count":10000,"release":"manifest:sha256:..."}
```

Allowed dimensions are `test`, `phase`, run-local session ordinal, categorical target class, outcome enum, error category, build manifest digest, OS family/build bucket, and architecture. PIDs, connection IDs, result IDs, pipe suffixes, raw SIDs, paths, identities, domains, and payload values are evidence fields only where strictly required; they are salted per-run hashes or omitted before the bundle leaves the lab.

## 8.3 Preflight inventory—no lab connection in this research

Use approved local SSH examples only outside this report. Do not paste or record their host, user, address, port, key, identity path, or config. The remote command is represented as `<APPROVED_WINDOWS_LAB_COMMAND>`.

PowerShell run on the lab VM:

```powershell
$ErrorActionPreference = 'Stop'
New-Item -ItemType Directory -Force C:\UamG1Lab\artifacts | Out-Null

Get-ComputerInfo |
  Select-Object WindowsProductName, WindowsVersion, OsBuildNumber, OsArchitecture |
  ConvertTo-Json | Set-Content C:\UamG1Lab\artifacts\inventory-raw.json

dotnet --info | Set-Content C:\UamG1Lab\artifacts\dotnet-info.txt
Get-CimInstance Win32_OperatingSystem |
  Select-Object Caption, Version, BuildNumber, OSArchitecture |
  ConvertTo-Json | Set-Content C:\UamG1Lab\artifacts\os.json

Get-Service Schedule | Select-Object Status, StartType | ConvertTo-Json |
  Set-Content C:\UamG1Lab\artifacts\task-scheduler.json
```

The evidence collector sanitizes these before attachment. **Pass:** supported-build candidate, x64 for base G1, Task Scheduler available, required .NET deployment mode present or self-contained package works. **Fail:** unknown/unsupported build, policy prevents inventory, or evidence cannot be sanitized. **Cleanup:** retain only sanitized outputs and approved test artifacts.

## 8.4 Installation and identity commands

After installing the signed synthetic MSI and rebooting:

```powershell
sc.exe qc UamCoordinatorG1
sc.exe qsidtype UamCoordinatorG1
sc.exe qprivs UamCoordinatorG1
sc.exe showsid UamCoordinatorG1
sc.exe sdshow UamCoordinatorG1
sc.exe qfailure UamCoordinatorG1
sc.exe qfailureflag UamCoordinatorG1

schtasks.exe /Query /TN "\UAM\G1\UserHost" /XML > C:\UamG1Lab\artifacts\task.xml
Get-ScheduledTask -TaskPath '\UAM\G1\' -TaskName 'UserHost' |
  Export-ScheduledTask | Set-Content C:\UamG1Lab\artifacts\task-export.xml

Get-NetFirewallRule -Group 'UAM-G1-LAB' |
  Get-NetFirewallApplicationFilter |
  Select-Object Program | ConvertTo-Json |
  Set-Content C:\UamG1Lab\artifacts\firewall-programs.json

& 'C:\Program Files\UAM\G1\current\Uam.G1.EvidenceCollector.exe' token `
  --service UamCoordinatorG1 --include-groups --include-privileges `
  --include-restrictions --include-default-dacl `
  --out C:\UamG1Lab\artifacts\service-token.json

& 'C:\Program Files\UAM\G1\current\Uam.G1.EvidenceCollector.exe' objects `
  --service UamCoordinatorG1 --task '\UAM\G1\UserHost' --pipes --processes `
  --out C:\UamG1Lab\artifacts\objects.json
```

`EvidenceCollector` is purpose-built and signed. It uses Windows APIs rather than parsing localized command output for pass/fail. The `sc.exe`/PowerShell files are corroboration.

## 8.5 Exact G1 test matrix

All durations and resource values below are **ESTIMATES** for the proof lane. Production budgets remain a human decision. “Evidence” means the sanitized bundle fields in §8.2.

| ID | Setup and instrumentation | Steps | Pass / fail | Evidence | Estimated duration | Cleanup |
| --- | --- | --- | --- | --- | ---: | --- |
| G1-B01 Build reproducibility | Clean pinned SDK container/runner; signed test cert allowed only in lab. | Build twice from same commit/lock files; compare managed/native generated source and package manifests. | Pass: deterministic artifacts except documented signatures/timestamps; dependency lock and SBOM complete. Fail: unpinned package/tool or unexplained binary difference. | hashes, SBOM, generated interop diff. | 20 min | Delete unsigned intermediates. |
| G1-A01 Architecture dependencies | Run NetArchTest/Roslyn rules and `dotnet list package --include-transitive`. | Assert project references against §3.5. | Zero forbidden references; no User/Task Host networking/store dependency; no Coordinator collector dependency. | JUnit, dependency graph. | 2 min | None. |
| G1-U01 Install configuration | Clean VM; ProcMon; MSI verbose log. | Install, reboot, run §8.4, compare signed manifest. | Exact service account/SID type/privileges/DACL/task/firewall/files/registry. Any extra writable executable/config path fails. | installer log, manifest comparison, ACL JSON. | 15 min + reboot | Uninstall after suite. |
| G1-U02 Repair drift | Mutate each lab-owned ACL/task/firewall/service setting one at a time as admin. | Run MSI repair; re-query. | Repair restores exact manifest; ordinary user cannot repair/elevate. | before/after diff. | 20 min | Restore clean snapshot. |
| G1-U03 Uninstall canaries | Place synthetic neighboring files/registry/task/rule outside package ownership. | Uninstall. | All UAM G1 objects removed; every neighboring canary untouched; no process/pipe remains. | cleanup inventory. | 10 min | Delete synthetic canaries. |
| G1-S01 Service token | Reboot after SID-type config; API token dump. | Start service; inspect user SID, service SID, restricted SIDs, privileges, integrity, token type. | LocalService; restricted service SID present/enabled and in restricting list; only `SeChangeNotifyPrivilege`; no prohibited privilege. Any mismatch fails. | service-token.json. | 3 min | Stop service. |
| G1-S02 Service process DACL | Ordinary clients in S1/S2 plus admin control. | Try query, VM read/write, terminate, duplicate handle, write DAC/owner. | Interactive clients obtain only intended limited query/sync; all invasive access denied; admin control characterized. | access matrix. | 5 min | Close handles. |
| G1-S03 SCM recovery | Configure signed proof actions; monitor SCM. | Force 1st/2nd/3rd crash; then trip crash-loop marker. | Finite intended restarts; service disables/safe-stops; no indefinite restart; queued action containment documented. | service event timeline. | 10 min | MSI repair/reset failure count. |
| G1-T01 User Host token | Standard user and admin-group user sessions. | Trigger task; dump launcher/UserHost token before IPC. | Primary ordinary medium interactive token for both; not SYSTEM/high; same authentication LUID/logon SID/session as shell; no new logon session. | token comparison with salted run IDs. | 8 min | Log off test sessions. |
| G1-T02 Task canonicalization | GPO simulation/mutations. | Change run level/principal/action/trigger/DACL; start task. | Host exits and capability remains off on any unsafe drift; exact repair restores. | task XML/SDDL digest, health code. | 12 min | Repair. |
| G1-T03 Lifecycle coverage | Two local users or approved synthetic accounts; WTS/ETW timeline. | Console logon, lock/unlock, fast switch, RDP connect/disconnect if approved, logoff, service restart. | One Host per eligible logon tuple; no stale Host after logoff; conservative lock/disconnect behavior; no cross-assignment. | process/WTS/IPC timeline. | 30 min | Log off; stop service. |
| G1-X01 Cross-session pipe isolation | S1 and S2 active; hostile client in each; exact target pipe handles discovered only inside lab tool. | 10,000 opens/messages S1→S2 and 10,000 S2→S1 across bootstrap/dedicated timing windows. | **Zero cross-session accepted messages.** DACL or identity validation denies every attempt; legitimate channels remain available; no state/cursor change. | attempt counts, accepted count=0, store diff. | 20 min | Close hostile clients; rotate sessions. |
| G1-X02 Same-SID process/token handle isolation | Same account receives two distinct logon sessions where platform permits; User Host launched with protected DACL. | From each session, make 10,000 opens/duplicates against other process and token for query memory, duplicate, terminate, write DAC, read control; race launch. | Zero prohibited handles; only explicitly allowed service query access; Owner Rights behavior matches design. Any prohibited handle is stop gate. | rights-by-attempt matrix, object DACLs, creation times. | 30 min | Log off both sessions; clear run secrets. |
| G1-X03 Pipe squatting | Service stopped and running variants. | Hostile creates bootstrap name before start; then races 10,000 creations around restart. | Service never connects to attacker and never reports running without anchor; safe-stop when occupied; attacker cannot create second first instance after anchor. | service/pipe ownership timeline. | 15 min | Close hostile pipe; repair/start. |
| G1-X04 Local-only | Approved isolated peer only when network lab authorized. | Try SMB remote pipe; local loopback/client; inspect flags. | Remote rejected; local legitimate works. If peer lane unavailable, mark UNKNOWN—not pass. | remote/local outcome and pipe mode. | 10 min | Remove peer fixture. |
| G1-X05 PID reuse | Increase process churn; held-handle instrumentation. | Connect/exit/reuse pressure between all identity-validation stages, 10,000 attempts. | No stale PID accepted; every accepted client handle creation time/image/token matches both phases. | tuple comparisons. | 20 min | Stop churn tools. |
| G1-X06 Fake server | Stop service; hostile creates lookalike; modify service PID timing only within lab. | Start User Host against fake; race real restart. | User Host sends no assignment/result/source material; server PID/SCM/image mismatch exits. | bytes sent before auth=bootstrap-only; error category. | 15 min | Remove fake process; repair service. |
| G1-I01 Happy handshake | Legitimate S1/S2. | Bootstrap, handoff, dedicated, heartbeat. | Mutual validation and selected version correct; unique pipe/key/connection per run; secret zeroized best-effort. | framed trace with payload redacted/hash. | 3 min | Close channels. |
| G1-I02 Version matrix | Build current, rollback, too-old, future-major clients. | Test every range overlap/non-overlap and feature bit. | Highest common minor selected; only manifest-authorized images accepted; no downgrade. | negotiation matrix. | 10 min | Remove old test binaries. |
| G1-I03 Replay/order | Capture synthetic signed frame in tool. | Duplicate, reorder, skip, old connection, sequence wrap, wrong connection ID. | All rejected/closed; exact legitimate retry uses fresh handshake and durable idempotency. | outcomes, no store mutation. | 10 min | Delete capture. |
| G1-F01 Header corpus | Unit/native integration harness with allocation tracking. | Execute zero/short/long magic, every length boundary, overflow, flags, type/state mismatch, reserved bits. | No out-of-cap allocation, crash, hang, or unsafe error reflection; expected category. | corpus/JUnit/allocation peak. | 5 min | Retain non-sensitive seeds. |
| G1-F02 Slowloris 10,000 | 16 parallel hostile clients, resource counters. | Partial headers/bodies with varied delays; abandoned overlapped I/O. | All deadlines enforced; service remains responsive; slots/queues never exceed caps; resources return to baseline. | time series and attempt summary. | 30 min | Close clients; 5-min recovery sample. |
| G1-F03 CBOR fuzz | Coverage-guided fuzz target and deterministic seed corpus. | Duplicate keys, deep nesting, huge counts/strings, invalid UTF-8, tags/floats, noncanonical encodings. | Decoder rejects deterministically within limits; no unexpected exception or allocation. | coverage, crashes=0, max resource. | 60 min CI smoke; longer release soak by policy | Retain minimized seeds only. |
| G1-F04 Malformed clients 10,000 | Mixed framing/CBOR/MAC/state corpus, 16 parallel, legitimate S2 traffic. | Run exactly 10,000 attempts while 1,000 legitimate heartbeats/pages occur. | No service crash/hang; legitimate progress succeeds; bounded failures/logs/resources; no accepted malformed message. | counts, liveness, store. | 30 min | 5-min recovery sample. |
| G1-D01 Commit/ACK crash matrix | Named failpoints before/after each SQLite step and send. | For one synthetic page, crash at every failpoint; reconnect/retry. | Cursor never ahead; committed event never duplicated; precommit crash no ACK; postcommit/pre-ACK retry returns original ACK. | failpoint table, DB snapshots/digests. | 25 min | Reset synthetic DB per case. |
| G1-D02 Result conflict | Construct same result ID/different digest and event-ID conflict. | Send through valid authenticated Host test mode. | Transaction rejected, cursor unchanged, capability disabled/alerted categorically. | DB diff/error. | 5 min | Reset synthetic DB. |
| G1-P01 No service profile access | Synthetic profile tree contains canary filenames/content; ProcMon service-PID filter plus stack/process ancestry. | Install/start/restart, login/lock/switch/logoff, handshake, collect synthetic assignment, upgrade/repair/uninstall. | **No profile access by the service**: zero service-originated opens/enumerations under test-user profile roots. Any access is stop gate after attribution review. | ProcMon summary/raw retained locally, canary scan. | 30 min | Delete synthetic profiles/canaries after approved evidence. |
| G1-P02 Minimization boundary | Inject forbidden synthetic canaries shaped like URLs/titles/paths/SQL/identities. | Exercise TaskHost→UserHost→Coordinator pipe/store/log/support bundle/crash. | Canary values absent everywhere beyond minimizing process; only approved fictional minimized output appears. | multi-artifact scanner. | 20 min | Securely delete synthetic artifacts. |
| G1-R01 Realm binding | Two fictional realm policy/signing fixtures. | Swap cache files/messages/registration claims. | Cross-realm policy rejected; payload identity claim rejected; no state relabel. | policy validation matrix. | 8 min | Delete fixture keys. |
| G1-H01 Task child/job | Task Host hostile modes. | Spawn child, breakaway flags, nested job edge, orphan User Host. | Child creation denied or active-process limit terminates job; no orphan; User Host crash kills tree. | ETW/job completion/process inventory. | 12 min | Kill/verify tree. |
| G1-H02 Task writes | Scratch plus protected/user/system synthetic canaries; ProcMon. | Create/modify/delete/rename/reparse/registry attempts. | Only approved scratch writes succeed; no protected/profile canary mutation; scratch low-label/ACL correct. | operation matrix. | 15 min | Delete scratch by verified root. |
| G1-H03 Task read characterization | Synthetic same-user readable and denied canaries. | Attempt reads across profile/system/scratch; never real user data. | Results match documented residual; any unexpected broader reach is recorded. This is characterization, not a claim of total denial. | read matrix. | 10 min | Delete canaries. |
| G1-H04 Task network | WFP/firewall logging, IPv4/IPv6/loopback listeners, DNS and raw socket probes with fictional endpoints. | Attempt outbound/inbound all protocols from User/Task Hosts; verify Coordinator networking unaffected only if in later test fixture. | Zero successful User/Task Host network connections; effective block on all profiles. Any success stops supported environment. | WFP/firewall summary. | 15 min | Remove listeners/rules via MSI. |
| G1-H05 Task resource limits | Job counters. | CPU loop, memory growth, handle flood, GUI call, crash, hang. | Job/mitigations contain each; wall deadline kills; service/other session stays responsive; caps not exceeded. | job notifications/resource time series. | 15 min | Close job, delete scratch. |
| G1-H06 Handle inheritance | Enumerate child handles with NtQueryObject-safe evidence tool. | Launch at every failure point; attempt access to parent pipe/token/process/store handles. | Exactly request/result handles and allowed standard handles; no Coordinator/user secret/store handle. | handle-type/access list. | 10 min | Close handles. |
| G1-H07 Restricted-token launch | Each supported build/policy profile. | Create restricted primary token and suspended Task Host without elevated privilege; verify token. | Launch succeeds with no prohibited caller privilege, or environment is unsupported. No privilege-adding fallback. | Win32 result/token matrix. | 8 min/profile | Kill job. |
| G1-H08 Reparse races | Synthetic scratch/profile junctions/symlinks; high-rate swaps. | 10,000 open/create/delete races. | No escape write/delete; file-ID/root checks catch changes. | operation/file-ID matrix. | 20 min | Remove links/canaries. |
| G1-L01 Crash recovery | Fault injector in Coordinator/User/Task Host/launcher. | Terminate at every lifecycle state, including lock/logoff/upgrade. | Bounded recovery; no orphan task; no raw spill; no cursor violation; no restart storm. | state-transition trace. | 30 min | Repair/start clean. |
| G1-O01 Metrics cardinality | Random IDs/sessions/errors generated synthetically. | One million diagnostic events through aggregation layer. | Series count remains fixed by schema; no PID/SID/result/correlation labels; logs rate-limited; operational data unaffected. | series inventory and dropped/coalesced counts. | 15 min | Reset local metrics. |
| G1-O02 Support bundle privacy | Synthetic forbidden canaries in all nearby files. | Generate bundle as ordinary support workflow. | Bundle contains allowlisted schemas only and zero forbidden canary/raw identity values. | bundle manifest/scanner. | 8 min | Delete bundle. |
| G1-C01 Kill switches | Signed release/tenant/emergency fixtures. | Disable source/task/IPC/all collection; test stale/invalid/cross-realm config and restart. | Kill takes effect before next assignment, persists as intended, cannot be narrowed away by lower authority, and cannot widen. | effective-config trace. | 10 min | Restore synthetic fixture. |
| G1-U04 Upgrade/rollback | R/R+1/unauthorized R-1 signed lab fixtures; DB failpoints. | Upgrade during idle/active/ACK lost/locked/two sessions; rollback. | Drain is bounded; no unauthorized old binary; exact retry invariant; no orphan; rollback only authorized. | process/manifest/store timeline. | 35 min | Reinstall current proof. |

## 8.6 Primary hostile run and acceptance gate

Run from an elevated lab controller only to orchestrate test sessions; the hostile clients themselves execute in the target ordinary user contexts:

```powershell
$run = New-G1SyntheticRun -Sessions 2 -SameSidVariant -NoRealActivity
Invoke-G1CrossSessionAttack -Run $run -Attempts 10000 -EachDirection
Invoke-G1SameSidHandleAttack -Run $run -Attempts 10000 -EachDirection
Invoke-G1MalformedAttack -Run $run -Attempts 10000 -Parallelism 16
Invoke-G1ProfileCanaryTrace -Run $run
Invoke-G1TaskHostContainment -Run $run
Complete-G1Evidence -Run $run -RecoverySample ([TimeSpan]::FromMinutes(5))
Assert-G1PrimaryGate -Run $run
```

Equivalent direct proof commands, with no connection details:

```powershell
& $Hostile cross-session --from S1 --to S2 --attempts 10000 --jsonl $Out\x-s1-s2.jsonl
& $Hostile cross-session --from S2 --to S1 --attempts 10000 --jsonl $Out\x-s2-s1.jsonl
& $Hostile duplicate-handle --same-sid --attempts 10000 --rights all-prohibited --jsonl $Out\handles.jsonl
& $Hostile malformed --attempts 10000 --parallel 16 --corpus fixtures\malformed --jsonl $Out\malformed.jsonl
& $Evidence assert --profile-access service:none --privilege-allow SeChangeNotifyPrivilege `
    --cross-session-accepted 0 --bounded-hostile-impact --in $Out
```

**Primary gate—exact:** **Zero cross-session accepted messages; no profile access by the service; no prohibited privileges; bounded hostile-client impact.**

“Bounded hostile-client impact” means all of the following G1 estimates pass after the 10,000-attempt runs:

- Coordinator does not crash, hang, enter an unbounded restart loop, or stop serving a legitimate second session.
- Configured handshake/queue/concurrency caps are never exceeded.
- No malformed or replayed message is accepted; no durable event/cursor mutation occurs from hostile input.
- Five minutes after attackers exit, handle count is at most baseline + 10, thread count at most baseline + 2, and private bytes at most baseline + 16 MiB.
- During the run, delta from quiet baseline is below 128 handles, 32 threads, and 256 MiB private bytes.
- CPU returns to the predeclared idle band during the five-minute recovery sample; the exact idle band is measured in preflight rather than invented here.
- Log bytes, metric series, timers, cached identities, and failure records remain within their configured fixed caps.

Any threshold miss is a G1 failure even when security acceptance count is zero. Thresholds are proof-lane safety estimates; production resource budgets require a human decision and representative measurement.

## 8.7 ProcMon and token evidence protocol

ProcMon filters must identify the Coordinator by PID plus process creation time and image file ID, not filename alone. Capture these operations under synthetic profile roots: `CreateFile`, `QueryDirectory`, `ReadFile`, `WriteFile`, `SetDispositionInformationFile`, registry open/query/set, process create, and image load. Exclude ordinary OS noise only through a reviewed, versioned filter; never discard an access merely because it was denied.

Pass/fail attribution:

1. An event whose initiating process is Coordinator is service access.
2. An event initiated by UserHost/TaskHost is recorded separately; it cannot be reclassified as service access.
3. Installer and evidence-collector events are separate phases.
4. Security-product injection/filter-driver callbacks are documented as environment evidence; unexplained service-originated profile I/O remains a failure.
5. Raw ProcMon data stays in the approved lab evidence boundary. The attached research artifact contains only sanitized operation counts and synthetic canary classes.

Token evidence must use `OpenProcessToken`/`GetTokenInformation` and include token user class, groups/attributes, privileges/attributes, restricted SIDs, integrity, elevation type, token type/impersonation level, authentication LUID, session ID, default DACL, UIAccess, virtualization, AppContainer, and linked-token presence. Raw SIDs are transformed to stable run-local roles before export.

## 8.8 Cleanup command

Run only against the disposable G1 package and synthetic roots:

```powershell
$ErrorActionPreference = 'Continue'
Stop-Service UamCoordinatorG1 -Force -ErrorAction SilentlyContinue
sc.exe config UamCoordinatorG1 start= disabled | Out-Null
Get-Process Uam.G1.* -ErrorAction SilentlyContinue | Stop-Process -Force
schtasks.exe /End /TN "\UAM\G1\UserHost" 2>$null
Unregister-ScheduledTask -TaskPath '\UAM\G1\' -TaskName 'UserHost' -Confirm:$false -ErrorAction SilentlyContinue
Get-NetFirewallRule -Group 'UAM-G1-LAB' -ErrorAction SilentlyContinue | Remove-NetFirewallRule
sc.exe delete UamCoordinatorG1 | Out-Null
Remove-Item 'C:\Program Files\UAM\G1' -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item 'C:\ProgramData\UAM\G1-Synthetic' -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item 'HKLM:\Software\UAM\G1-Synthetic' -Recurse -Force -ErrorAction SilentlyContinue

Write-Host 'Verify rather than assume cleanup.'
Get-Service UamCoordinatorG1 -ErrorAction SilentlyContinue
Get-ScheduledTask -TaskPath '\UAM\G1\' -ErrorAction SilentlyContinue
Get-NetFirewallRule -Group 'UAM-G1-LAB' -ErrorAction SilentlyContinue
Get-Process Uam.G1.* -ErrorAction SilentlyContinue
```

Do not adapt these delete paths to a production installation without the approved MSI/uninstall disposition. Evidence files are retained or deleted under the lab's approved sanitized-evidence procedure, not by wildcard.

# 9. Architecture fitness functions and measurable acceptance criteria

These functions turn architectural intent into automated evidence. A release candidate cannot waive a failed security/privacy fitness function through a feature flag; it requires a documented ADR/change proposal and rerun of affected gates.

| Fitness function | Where / cadence | Measurable acceptance criterion | Failure action |
| --- | --- | --- | --- |
| Project dependency boundary | Every build | The dependency graph exactly respects §3.5; Coordinator has no collector/profile project reference; User/Task Host have no transport/store dependency; Task Host has no dynamic loading/scripting package. | Build fails. |
| Native API allowlist | Every build | Generated interop surface contains only reviewed APIs/constants/structs; generated diff reviewed; no hand-written unsafe P/Invoke outside `Uam.Windows.Interop`. | Build fails. |
| Dependency provenance | Every build/release | Locked graph, SBOM, license inventory, source repository, signature/hash and vulnerability scan recorded; no floating versions. | Release fails. |
| Supported .NET | Release | Exact runtime/SDK is in active Microsoft support on release date and lifecycle window covers deployment policy; self-contained runtime is patched by UAM release process. | Select current supported patch or stop release. |
| Service identity | Install + startup + G1 | Account is LocalService; SID type restricted/effective; token is primary; service SID present/restricting; integrity and group set match manifest. | Service safe-stops; G1 fails. |
| Service privilege floor | Install + every startup | Effective token privilege set is exactly the approved allowlist (`SeChangeNotifyPrivilege` in G1) and contains none of the prohibited set. | Service safe-stops; release fails. |
| No service profile access | G1 and supported-platform regression | ProcMon/ETW evidence has zero Coordinator-originated profile/user-source accesses through install, lifecycle, collection proof, upgrade and uninstall. | G1/release fails. |
| User token fidelity | G1 per supported environment | User Host token is ordinary interactive medium token with authentication LUID/logon SID/session matching the existing shell; it is not created by Coordinator and not high/SYSTEM. | Environment unsupported; no fallback. |
| One Host per logon tuple | Integration + lifecycle regression | At most one Ready User Host for each `(logon SID, authentication LUID, session generation)`; different sessions remain independent. | Disable affected session; release fails if reproducible. |
| Cross-session IPC | G1 per supported build | Exactly 0 accepted messages in 10,000 attempts each direction for distinct sessions, including same-account sessions where available. | Primary gate fails. |
| Same-SID handle isolation | G1 per supported build | Exactly 0 prohibited process/token handle opens or duplicates in 10,000 attempts each direction; launch race included. | Stop gate; redesign launcher/object ACL or support scope. |
| Pipe ownership/locality | Startup + G1 | Bootstrap first-instance anchor belongs to current service PID/file identity; all servers use `PIPE_REJECT_REMOTE_CLIENTS`; remote proof passes where supported. | Service safe-stops/environment unsupported. |
| Kernel-derived identity | Unit/integration review | No IPC payload contract contains authoritative SID/PID/session/realm/device; validation uses held process/token/SCM handles and creation times at both phases. | Build/review fails. |
| Protocol determinism | Every build | Golden CBOR/frame bytes stable; decoder rejects all noncanonical/duplicate/over-depth/unknown-required cases; no unbounded allocation. | Build fails. |
| Replay resistance | Integration | Duplicate, reordered, skipped, stale-connection and wrong-MAC frames produce zero accepted state mutation. | Release fails. |
| Bounded hostile impact | G1 + release soak | 10,000 malformed and 10,000 slow/cross-session attempts meet every §8.6 queue/liveness/recovery/resource condition. | G1/release fails. |
| Privacy ceiling enforcement | Every build + G1/G4 | Closed schemas contain only release-authorized fields; tenant config can only remove/narrow; synthetic forbidden canaries absent beyond minimizer. | Build/G1 fails; G4 remains final field proof. |
| Durable result/cursor invariant | Fault-injection build + G1 | At every named crash point: no cursor without durable events, no precommit ACK, and one business effect after retry. | Release fails. |
| Task fixed-mode surface | Every build | Task Host mode enum and command parser accept only source-controlled fixed modes/options; no arbitrary path, URL, command, script, assembly or plugin field. | Build fails. |
| Task token confinement | G1 per supported build | Low IL/restricted/write-restricted token and intended SIDs/groups/privileges exactly match manifest; unsupported launch is fail-closed. | Task capability off; G1 fails for required mode. |
| Task process confinement | G1 | Task Host is assigned before resume; job has kill-on-close and process limit 1; child/breakaway/orphan attempts all fail or kill the job. | Task capability off; release fails. |
| Task write boundary | G1 | Only package-owned synthetic scratch writes succeed; 0 mutations to profile/protected/system canaries across 10,000 reparse races. | Task capability off; release fails. |
| Task network boundary | G1 per enterprise policy profile | 0 successful IPv4/IPv6/loopback/DNS/inbound/outbound connections from User/Task Host in effective WFP evidence. | Environment unsupported or stronger sandbox ADR. |
| Handle inheritance | G1 | Child has exactly allowlisted request/result/standard handles; no parent pipe, token, store, process, job-control or secret handle. | Release fails. |
| File/release immutability | Install/repair/release | Executables/config/manifest cannot be modified by ordinary users; exact file ID/hash/signer matches signed release before launch; old releases bounded. | Stop service/task; repair/rollback. |
| No silent downgrade | Release/upgrade tests | Unauthorized R-1/frozen/incomplete release never executes; only explicitly authorized rollback manifest can become current. | Release fails. |
| Realm isolation | Unit/integration | Cross-realm policy/cache/claims cannot alter effective config or persisted binding; payload cannot set realm. | Capability off; security incident if production. |
| Kill-switch precedence | Every build | Emergency/release disable wins over tenant/local settings; stale/invalid config never widens; effect before next assignment. | Build/release fails. |
| Metric cardinality | Unit/load | Each metric has a source-controlled maximum series count; one million random IDs do not add a series; no identity/path/payload labels. | Build fails. |
| Diagnostic privacy | G1/release | Support bundle and ordinary logs match allowlist and contain zero forbidden synthetic canaries/raw identifiers. | Release fails. |
| Installer ownership | G1 | Install/repair/uninstall changes only manifest-owned objects; neighboring synthetic canaries unchanged; cleanup inventory empty. | Package release fails. |
| Accessibility of operator tools | UI/CLI test | Every state is conveyed in text, exit codes and machine-readable output; no color-only meaning; keyboard/screen-reader-compatible command help; locale-independent codes. | Tool release fails. |
| Runbook readiness | Pre-pilot | Named accountable functions, escalation, evidence retention, privacy incident, repair/rollback, task/firewall drift, crash-loop and uninstall procedures have exercised dry runs. | No pilot/production approval. |

## 9.1 Primary G1 acceptance set

G1 passes only when all of these are true on every platform configuration proposed for support:

1. **Zero cross-session accepted messages; no profile access by the service; no prohibited privileges; bounded hostile-client impact.**
2. Ordinary-token User Hosts are launched by the exact Scheduled Task design with no Coordinator-created user token.
3. The same-SID process/token-handle test passes or that environment is explicitly excluded; no prose assumption substitutes for evidence.
4. Pipe squatting, fake server, PID reuse, replay, malformed and slow-client tests pass.
5. Task Host process/write/network/resource/handle containment tests pass for every enabled fixed mode.
6. Event-plus-cursor commit and commit-before-ACK fault tests pass.
7. Install, repair, upgrade, authorized rollback, crash-loop containment and uninstall cleanup pass.
8. Evidence bundle privacy and metric-cardinality tests pass.

A pass proves only G1. It does not approve browser acquisition, event fields, identity precision, production retention, endpoint store limits, transport, legal purpose, employee monitoring use, or production operation.

# 10. Human decisions and owner questions

## 10.1 Supported Windows and session environments

**HUMAN DECISION — accountable role to designate:** Product/Platform Support Authority, with Endpoint Engineering, Security, Privacy and Operations advice.

| Option | Consequences |
| --- | --- |
| Supported Windows client x64, console plus ordinary RDP only | Smallest test surface; excludes server/RDS/VDI/ARM64 and may not cover parts of the estate. |
| Add Windows Server/RDS multi-user | Requires full same-SID/multi-session/WTS/task/firewall/resource rerun; service/task GPO and density behavior become materially different. |
| Add AVD/Windows 365/Citrix/FSLogix/non-persistent VDI | Requires platform-specific lifecycle, profile container, image sealing, clone identity, network policy and cleanup evidence; persistent machine install assumptions may fail. |
| Add ARM64 | Requires native interop/RID/signing/package and every G1 hostile test on ARM64; x64 emulation is not proof. |
| Support UAC-disabled, kiosk, shared PC, RemoteApp, disconnected long-running sessions | Each changes token/session/lifecycle assumptions and needs explicit threat-model and lab evidence. |

**Conservative temporary default:** G1 proof only on one currently Microsoft-supported x64 Windows client build in an approved disposable lab, testing console logon/lock/unlock/fast switch and ordinary RDP only when the lab permits it. Disconnect drains/exits. All other modes are “unsupported/test-only,” not silently accepted.

Owner questions:

- Which OS editions/builds and architectures are contractually required at first release?
- Are multiple simultaneous sessions for one account expected and supported?
- Which RDP/RDS/AVD/Citrix/FSLogix modes must survive lock/disconnect?
- Are local accounts, Entra/domain accounts, smart-card/WebAuthn logons, shared/kiosk accounts, and mandatory profiles in scope?
- What is the deprecation notice and forced-upgrade policy when a Windows or .NET version exits support?

## 10.2 Enterprise Scheduled Task and service policy constraints

**HUMAN DECISION — accountable role to designate:** Endpoint Platform/Enterprise Management Authority, with Security approval.

| Option | Consequences |
| --- | --- |
| Permit the exact group task and service configuration | Preserves ordinary existing user tokens and the accepted boundary; requires enterprise task/service hardening exceptions and drift monitoring. |
| Deploy a per-user task for each account | Creates account lifecycle/provisioning complexity, stale tasks and user enumeration pressure; incompatible with unknown users/offline-first use. |
| Use startup/Run key/user shell extension | Weaker enterprise ownership/recovery and variable launch behavior; not recommended. |
| Let Coordinator create/duplicate user tokens | Conflicts with accepted baseline and requires prohibited privileges/impersonation complexity; explicit change proposal and new G1 architecture required. |
| Disallow application firewall blocks or job/restricted-token APIs | Task Host risk boundary may be unachievable; disable risky collectors or adopt stronger platform sandbox after ADR. |

**Conservative temporary default:** require the exact `TASK_LOGON_GROUP`/INTERACTIVE/LeastPrivilege task, restricted LocalService service, service privilege list, object ACLs and application firewall rules. Any enterprise policy conflict fails closed and leaves collection off; there is no token-creation or elevated-task fallback.

Owner questions:

- Does endpoint management permit group-principal tasks and `TASK_DONT_ADD_PRINCIPAL_ACE`?
- Which GPO/MDM/EDR rules rewrite tasks, service DACLs, required privileges, firewall precedence, process mitigations or job assignment?
- Can MSI require a reboot before formal activation so restricted service SID is effective?
- Who owns drift repair, exception approval and evidence from representative policy rings?
- Will EDR allow process/token inspection and ProcMon/WFP evidence in the lab without masking results?

## 10.3 Resource budget and support model

**HUMAN DECISION — accountable role to designate:** Product Operations/Service Ownership Authority, informed by Endpoint Performance, Support and Finance.

| Option | Consequences |
| --- | --- |
| Tight resident budgets and one active assignment | Lowest endpoint impact and simplest failure containment; may increase collection latency during bursts/offline recovery. |
| Higher per-session concurrency | More throughput but multiplies memory, file handles, Task Hosts, contention and privacy exposure; needs representative density tests. |
| 24×7 enterprise support with rapid rollback | Higher staffing/runbook/telemetry cost; may be required for broad fleet deployment. |
| Business-hours support with conservative auto-disable | Lower operational cost but longer monitoring gaps; must align with purpose and expectations. |
| Self-contained .NET runtime | Predictable deployment and isolation from machine runtime; UAM owns patch cadence/package size. Framework-dependent reduces package size but depends on enterprise runtime management. |

**Conservative temporary default:** G1 uses safety caps in §5.14/§8.6, one active assignment per User Host, one Task Host process, self-contained x64 .NET 10 normal-file publication, and automatic capability disable rather than resource escalation. These are proof controls, not production SLOs or budgets.

Owner questions:

- What CPU, working/private memory, disk, handle, startup, battery and network budgets are acceptable per machine and per simultaneous session?
- What outage/backlog duration must endpoints tolerate, and what user impact is unacceptable?
- Who responds to crash loops, task/firewall drift, privacy-canary alerts and failed upgrades, at what hours?
- What evidence may Support collect, how long may it be retained, and who can access it?
- What licensing/procurement constraints apply to installer, code signing, EDR/ProcMon alternatives, test infrastructure and support tooling?

## 10.4 Other unresolved authority questions

| Decision | Options and consequence | Conservative temporary default | Accountable role to designate |
| --- | --- | --- | --- |
| Same-user cross-session threat requirement | Require strong denial; or accept same-user read/handle risk for selected environments. Strong denial may require AppContainer/brokered handles or platform exclusions. | Treat every separate logon session as hostile; G1-X02 is a stop gate. | Security Risk Owner + Privacy Authority. |
| AppContainer for Task Host | Adds capability-based network/file isolation but complicates profile/source access and packaging. | Do not claim it; use restricted token/job/firewall, keep fixed modes, and disable if residual read risk is unacceptable. | Security Architecture. |
| Identity/time/event fields | More precision can improve quality but increases privacy/linkability. | Synthetic G1 fields only; defer to G0/G4 and human approvals. | Product Privacy/Data Governance. |
| Service certificate/private key | Device PKI/TPM may improve identity but provider/ACL/renewal/support costs vary. | No certificate dependency in G1. | Device Identity Authority. |
| Production uninstallation data | Preserve, final-send, or delete; each has privacy/durability consequences. | Delete synthetic G1 data only; no production choice. | Data Governance + Operations. |
| Compatibility window | Current only, current+rollback, or longer N-version support. Longer increases attack/test/migration surface. | Current + one explicit signed rollback release. | Release/Lifecycle Authority. |
| Evidence retention | Longer aids diagnosis but increases privacy/security cost. | Keep sanitized G1 evidence only under existing approved research procedure; no production retention claim. | Privacy/Security Governance. |
| Emergency kill authority | Central, release, local enterprise, or combinations; authority/order must be auditable. | Release ceiling and signed emergency disable dominate; tenant may only narrow. | Product Security + Operations Governance. |
| Acceptable Task Host network proof | Firewall policy only versus AppContainer/other kernel-enforced capability. | Require effective WFP zero-success test; fail environment on override. | Endpoint Security Authority. |
| Production support owner | Dedicated endpoint team, shared platform team, vendor/MSP, or hybrid. | No production rollout until named and exercised. | Executive/Service Ownership Authority. |

# 11. CLI experiments and exact evidence required

The commands are templates with synthetic names and local placeholders. They must not include actual SSH command material, internal hosts/addresses, credentials, usernames, keys, production activity, or confidential configuration. Each experiment writes a signed/hash-manifested sanitized bundle.

## 11.1 Experiment catalogue

| Experiment | Command template | Evidence that must be produced | Pass/fail gate |
| --- | --- | --- | --- |
| E01 Platform inventory | `<APPROVED_WINDOWS_LAB_COMMAND> powershell -File .\g1-inventory.ps1 -Out C:\UamG1Lab\artifacts` | Sanitized OS edition/build bucket, arch, Task Scheduler/service status, .NET deployment facts, policy categories, tool versions. | Required APIs/platform candidate present; unknowns remain explicitly marked. |
| E02 Install manifest | `msiexec.exe /i Uam.G1.Proof.msi /qn /l*v C:\UamG1Lab\artifacts\install.log` then reboot and `evidence install --manifest release.json` | MSI log; file hashes/IDs/owners/ACLs; registry ACLs; SCM/task/firewall/canonical manifest diff. | Exact match, ordinary users have no write/change rights. |
| E03 Service token/privileges | `sc qsidtype/qprivs/showsid/sdshow ...` plus `evidence token --service UamCoordinatorG1` | API-derived token groups/restrictions/privileges/integrity/type/default DACL; service object DACL and start config. | LocalService, restricted service SID effective, privilege set exactly allowlist. |
| E04 User Host identity | `evidence token --process-role UserHost --compare-shell --session S1` | Shell/Host run-local authentication LUID/logon SID/session/integrity/elevation relation and image manifest. | Ordinary existing interactive token; no service-created logon/token. |
| E05 Object ACLs | `evidence objects --process-role UserHost --token --pipes --mutex --task` | Canonical ACE/right tables for process/thread/token/pipes/mutex/task/service. | Exact templates; prohibited cross-session rights denied. |
| E06 No service profile access | `procmon-g1.ps1 -ProcessRole Coordinator -SyntheticProfileRoot <root> -Lifecycle All` | Local raw PML plus sanitized per-operation/canary summary and attribution metadata. | Zero Coordinator profile opens/enumerations/reads/writes in all phases. |
| E07 Cross-session 10,000 | `hostile cross-session --from S1 --to S2 --attempts 10000` and reverse | Attempts/denial layer, accepted count, legitimate-channel liveness, store before/after. | Accepted=0 each direction; no hostile state mutation. |
| E08 Same-SID handle 10,000 | `hostile duplicate-handle --same-sid --attempts 10000 --rights all-prohibited` each direction | Process/token creation time, DACL digest, requested/granted rights, race phase, accepted prohibited handles. | Prohibited grants=0. |
| E09 Malformed 10,000 | `hostile malformed --attempts 10000 --parallel 16 --corpus fixtures\malformed` | Case counts; process liveness; allocations; queue maxima; legitimate success; DB diff; logs/cardinality. | Accepted malformed=0 and every §8.6 bound passes. |
| E10 Slowloris 10,000 | `hostile slowloris --attempts 10000 --parallel 16 --delays fixtures\delays.json` | Deadline/slot outcomes, cancelled overlapped I/O count, resource recovery time series. | All sessions bounded; no leak/hang/starvation. |
| E11 Pipe squat/PID reuse/fake server | `hostile suite --cases squat,pid-reuse,fake-server --attempts 10000` | Pipe owner/PID/creation/image/SCM comparisons and bytes sent before mutual auth. | No attacker accepted; no sensitive post-bootstrap bytes sent. |
| E12 Replay/version | `hostile protocol --cases duplicate,reorder,gap,stale,wrong-mac,version,downgrade` | Negotiation and rejection matrix; store/cursor diff. | Only authorized compatible release; zero replay mutation. |
| E13 Commit/ACK faults | `fault run --scenario synthetic-page --all-failpoints` | Per-failpoint DB image/digest, ACK trace, retry effect and cursor relation. | Invariant holds at every point. |
| E14 Task token/job/handles | `taskproof run --modes token,child,breakaway,orphan,handles` | Restricted token, job limits/notifications, process tree, inherited handle set. | Exact token; process count 1; no orphan/extra handle. |
| E15 Task file/reparse | `taskproof run --modes writes,reads,reparse --attempts 10000 --synthetic-root <root>` | ProcMon operation result by canary class, file IDs/reparse transitions, scratch cleanup. | Writes only scratch; zero escape/canary mutation; read residual characterized. |
| E16 Task network | `taskproof network --ipv4 --ipv6 --loopback --dns --inbound --outbound` | Effective firewall/WFP events and listener outcomes by protocol, all profiles/policy rings. | Successful User/Task Host connections=0. |
| E17 Lifecycle | `lifecycle-g1.ps1 -Cases logon,lock,unlock,switch,connect,disconnect,logoff,restart,sleep,upgrade` | WTS/task/process/channel/assignment state timeline using run-local ordinals. | State machine obeyed; no stale/cross-session/orphan work. |
| E18 Kill/config/realm | `configproof run --cases stale,invalid,widen,cross-realm,kill,release-floor` | Signed fixture inputs, effective-policy result, capability state, audit categories. | Never widens/relabels/downgrades; kill wins. |
| E19 Upgrade/rollback/repair | `releaseproof run --from R --to R1 --rollback R --faults all` | Manifest/current-pointer/process/store/task/firewall/ACL timeline. | Only authorized binaries; bounded drain; invariant and cleanup hold. |
| E20 Observability/support | `observeproof run --random-events 1000000 --forbidden-canaries fixtures\privacy` | Metric series inventory, log byte/rate caps, support bundle schema/canary scan. | Fixed series cap; no forbidden value/identity label. |
| E21 Full G1 assertion | `evidence assert --profile-access service:none --privilege-allow SeChangeNotifyPrivilege --cross-session-accepted 0 --bounded-hostile-impact --in <bundle>` | Machine-readable assertion report, JUnit, evidence hashes and cleanup result. | Exact primary gate and every mandatory test pass. |

## 11.2 Required evidence manifest

`manifest.json` must include:

```json
{
  "schema": 1,
  "research_baseline_date": "2026-07-31",
  "run_id": "random-nonidentifying",
  "source_commit": "<full-commit>",
  "release_manifest_sha256": "<sha256>",
  "package_sha256": "<sha256>",
  "os_build_bucket": "<supported-sanitized-bucket>",
  "architecture": "x64",
  "tests": [{"id":"G1-X01","status":"pass","evidence":["events.jsonl","store/checks.json"]}],
  "redaction_schema": 1,
  "cleanup_status": "verified",
  "files": [{"path":"events.jsonl","sha256":"<sha256>","bytes":1234}]
}
```

Every file is SHA-256 hashed after sanitization. The manifest itself is hashed and optionally signed by the lab evidence tool. A failed or skipped test is not omitted. It records `fail`, `blocked`, or `unknown` and why. A screenshot is supporting material only; API-derived machine-readable evidence is authoritative.

## 11.3 Minimum falsifying prototypes

Before building the full runtime, implement these in order:

1. **P1 LocalService token proof:** a service that opens no profiles/network/store and prints sanitized token facts. Falsifier: any prohibited privilege remains after required-privilege configuration/reboot, or service SID restriction prevents required ProgramData/pipe operation.
2. **P2 Group task token proof:** exact task starts launcher/Host in each eligible session. Falsifier: elevated/new/S4U token, missing same-account second session, or enterprise policy rewrites it.
3. **P3 Protected User Host object proof:** launcher creates suspended Host with exact process/thread/token DACL. Falsifier: same-SID other-logon session opens a prohibited handle in one of 10,000 attempts.
4. **P4 Two-stage pipe proof:** exact ACL, first-instance, local-only, PID/session/token/image/SCM validation and HMAC framing. Falsifier: one cross-session/malformed/replay/fake-server acceptance or unbounded impact.
5. **P5 Restricted Task Host proof:** fixed mode, restricted token, pre-resume job, explicit handles, firewall and scratch. Falsifier: child/orphan, network success, write escape, extra handle, or required privilege escalation.
6. **P6 Atomic synthetic page proof:** event/progress transaction and ACK retry. Falsifier: cursor-ahead, precommit ACK, or duplicate business effect at any crash point.

No later prototype should continue after its dependency fails. A failure opens an ADR and the smallest changed experiment; it does not invite a hidden privilege or scope increase.

# 12. ADR proposals

Statuses below are proposals for the implementation repository. Accepted-baseline items remain accepted inputs, but the detailed Windows mechanisms stay `Proposed—G1 evidence required` until the lab gate passes.

| ADR | Decision and status | Alternatives considered | Rationale / evidence | Accountable owner to assign | Review trigger |
| --- | --- | --- | --- | --- | --- |
| ADR-G1-001 | **Three execution contexts**: Coordinator, one User Host per eligible logon session, short-lived Task Host. `Accepted input; implementation details proposed.` | Monolith; service collectors; permanent per-user service; plugins. | Preserves user/session privacy boundary and fault containment; baseline [INT-BASE]/[INT-GATES]. | Endpoint Architecture. | G1 failure, new platform/session support, or collector requiring different boundary. |
| ADR-G1-002 | **Coordinator = LocalService + restricted service SID + exact required privilege list (`SeChangeNotifyPrivilege` in G1).** `Proposed—G1.` | LocalSystem; NetworkService; virtual account; gMSA; unrestricted SID. | LocalService is low local privilege but defaults still include impersonation/create-global, so SCM privilege reduction and token proof are mandatory. [MS-SVC-01..04] | Windows Security Engineering. | Token mismatch, required operation needs another privilege, device identity architecture. |
| ADR-G1-003 | **MSI-owned INTERACTIVE group Scheduled Task, LeastPrivilege, ordinary launcher, protected suspended User Host.** `Proposed—G1.` | Per-user tasks; Run key; service-created token; highest privilege. | Reuses existing interactive token, avoids account provisioning and service token creation; protected launch addresses same-SID handle race. [MS-TASK-*] | Endpoint Runtime Engineering. | Enterprise policy incompatibility, same-SID gate failure, unsupported task behavior. |
| ADR-G1-004 | **Two-stage local named pipes: restricted bootstrap then random exact-logon-SID dedicated pipe.** `Proposed—G1.` | One broad pipe; per-session predictable pipe; loopback TCP; COM/RPC; shared memory. | Simple Windows-native local transport with explicit ACL and identity handoff; minimizes expensive exposure. [MS-PIPE-*] | IPC Engineering. | Cross-session/squat/DoS test failure or required platform lacks semantics. |
| ADR-G1-005 | **Kernel-derived identity tuple; no pipe impersonation and no client identity claims.** `Proposed—G1.` | `RunAsClient`; named-pipe impersonation/token extraction; payload SID/session. | Keeps `SeImpersonate` out, avoids confused-deputy use, binds PID/creation/token/session/image/SCM handles. | Windows Security + IPC Engineering. | APIs unavailable/unreliable on supported platform, false-reject rate, new threat evidence. |
| ADR-G1-006 | **Deterministic CBOR, fixed 88-byte frame, HKDF/HMAC, strict sequence and bounded decoder.** `Proposed—G1.` | JSON; protobuf/gRPC; MessagePack; ad hoc binary; pipe ACL only. | Closed deterministic schema, compact data and independent replay/handle-duplication defense without a network stack. [RFC-5869]/[RFC-8949] | Protocol Engineering. | Interoperability need, fuzz finding, performance measurement, cryptographic review. |
| ADR-G1-007 | **Task Host = own restricted low-integrity token, fixed mode, pre-resume job, explicit handles, scratch and application firewall block.** `Proposed—G1.` | In-process collector; User Host direct; container; AppContainer; VM. | Smallest boundary matching accepted baseline; contains crashes/children/writes/network while admitting same-user read residual. [MS-TOKEN-*]/[MS-JOB-*] | Sandbox Engineering. | Read residual unacceptable, network/write proof failure, launch requires prohibited privilege. |
| ADR-G1-008 | **No arbitrary plugins/scripts/assemblies/paths in Task Host.** `Accepted direction; proposed enforcement.` | Signed plugin ecosystem; PowerShell; dynamic assembly load; tenant script. | Prevents Task Host becoming endpoint code-execution channel and keeps privacy ceiling reviewable. | Product Security + Endpoint Architecture. | New product capability requires code extensibility; must create separate threat model/release governance. |
| ADR-G1-009 | **Commit minimized events and source progress atomically; ACK only after commit; exact retry idempotent.** `Accepted invariant; G1 synthetic proof proposed.` | ACK on receive; cursor first; best-effort drop; raw spill. | Carries baseline durability invariant into IPC boundary. [INT-BASE]/[INT-GATES] | Endpoint Storage Engineering. | Storage engine/schema change, failpoint failure, performance evidence. |
| ADR-G1-010 | **Current release plus one explicit signed rollback release; protocol major/minor negotiation; no IPC downgrade.** `Proposed—G1.` | Current only; N-version indefinite; automatic downgrade. | Enables recoverable release while bounding attack/test surface. | Release Engineering. | Enterprise rollout duration, schema migration need, lifecycle policy. |
| ADR-G1-011 | **MSI owns privileged files/service/task/firewall/ACL boundary; runtime repairs only unprivileged volatile state.** `Accepted input; proposed exact sequence.` | Self-updater/elevated repair service; runtime ACL mutation. | Matches baseline and confines privileged mutation/audit/recovery. | Release/Endpoint Management Engineering. | Repository-authorized updater proposal or enterprise deployment constraint. |
| ADR-G1-012 | **Privacy-safe categorical observability with hard series/rate caps and allowlisted support bundle.** `Proposed—G1.` | Raw exceptions/payload logs; per-user/session/PID labels; arbitrary file bundle. | Supports operation without creating a second activity dataset or DoS amplifier. | Observability + Privacy Engineering. | Incident evidence insufficient, new approved fields, cardinality test failure. |
| ADR-G1-013 | **Release/tenant/emergency configuration forms a monotone narrowing lattice; installation bound to one realm.** `Accepted principle; proposed endpoint contract.` | Last-writer-wins settings; payload realm; tenant-widened features. | Enforces product ceiling and realm isolation offline. | Policy Security Engineering. | Enrollment/realm migration design, policy verification failure. |
| ADR-G1-014 | **Use pinned CsWin32 as a build-time generator with allowlisted APIs and committed/reviewed generated diff; no runtime dependency.** `Proposed.` | Manual P/Invoke; TerraFX; source-copy wrappers. | Reduces signature/struct transcription errors while keeping generated surface reviewable. OSS review §14. | Windows Interop Maintainer. | Generator maintenance/security/licensing issue or generated-code instability. |
| ADR-G1-015 | **Open-source service/IPC/task/sandbox projects are references only, except possible pinned CsWin32 build dependency.** `Proposed.` | Directly depend on go-winio/Tailscale/PowerToys/Chromium/TaskScheduler wrapper. | Languages/threat models/licensing/complexity do not match UAM; ideas are reusable, architectures are not. | Architecture Review Board function. | A dependency-specific fit/security/maintenance ADR demonstrates lower total risk. |

# 13. Ordered implementation backlog with dependencies and stop gates

| Order | Work package | Depends on | Deliverables | Stop gate |
| ---: | --- | --- | --- | --- |
| 0 | Confirm G0 purpose/source/dummy-data contract | Human governance/G0 | Approved synthetic field/source contract, product privacy-ceiling schema, forbidden canary corpus, no real activity. | No G1 collector/page work without G0. |
| 1 | Repository/solution skeleton | 0 | Projects and dependency rules from §3.5; locked SDK/packages; analyzers; SBOM; deterministic build; synthetic fixtures. | Forbidden dependency or unpinned tool stops. |
| 2 | Windows interop layer | 1 | Pinned CsWin32 configuration, reviewed generated APIs, SafeHandle wrappers, checked native structs/constants, native-error taxonomy, interop unit tests. | Any unreviewed P/Invoke/unsafe lifetime stops. |
| 3 | Signed G1 MSI and immutable release layout | 1–2 | Versioned Program Files tree, ProgramData/registry ACLs, manifest/current pointer, uninstall/repair, lab signing path. | Ordinary user writable executable/config or broad delete stops. |
| 4 | Coordinator service identity | 3 | LocalService service, restricted SID, required privilege list, service/process DACL, finite recovery, startup self-check, token evidence command. | **No prohibited privileges**; SID type effective after reboot. Failure opens ADR-G1-002. |
| 5 | Scheduled Task and launcher | 3–4 | Canonical task XML/SDDL, exact group principal/run level/triggers, launcher ordinary-token checks, protected suspended User Host/process/thread/token DACL and mutex. | User Host not ordinary existing token, or enterprise policy rewrites boundary, stops. |
| 6 | Same-SID object isolation prototype | 5 | Hostile process/token handle tool, 10,000 launch-race attempts, evidence. | Any prohibited handle grant stops IPC work and opens ADR-G1-003 change. |
| 7 | Coordinator/User Host lifecycle | 4–6 | WTS reconciliation, task-trigger coexistence, state generations, lock/disconnect/logoff/drain/recovery, no user token creation. | Stale/cross-session process or service profile access stops. |
| 8 | Named-pipe server/client identity | 4–7 | Bootstrap anchor/pool, exact ACLs, local-only flags, process/token/session/image/SCM validation, held handles, rate limits. | Squat/fake/PID-reuse/cross-session prototype failure stops protocol work. |
| 9 | Framing, deterministic CBOR and handshake | 8 | 88-byte codec, schemas, HKDF/HMAC, strict sequences, version negotiation, fuzz target, golden vectors. | Malformed/replay causes acceptance/crash/unbounded allocation stops. |
| 10 | Synthetic assignment and local transaction stub | 0, 7–9 | Closed assignment/page/ACK contracts, one-writer synthetic SQLite schema, exact retry/idempotency and failpoints. | Cursor/ACK invariant failure stops all collector work. |
| 11 | Task Host launcher/confinement | 2, 5, 7 | Restricted token, low IL, unique restricting SID prototype, pre-resume job, explicit handles, fixed modes, scratch, mitigations, firewall MSI rules. | Privilege addition, child/orphan, extra handle, write/network escape stops. |
| 12 | Hostile/fuzz/fault harness | 6, 8–11 | 10,000 cross-session/same-SID/malformed/slow tests, protocol fuzz, resource bombs, reparse/network tests, deterministic failpoints. | Any primary-gate condition fails; do not proceed to real source work. |
| 13 | Privacy-safe observability/evidence | 4–12 | Categorical logs/metrics, series caps, support bundle allowlist, redaction/evidence manifest, canary scanner, accessible CLI output. | Any forbidden canary/identity label/cardinality escape stops. |
| 14 | Install/repair/upgrade/rollback/uninstall | 3–13 | Side-by-side current+rollback, drain, schema compatibility hooks, drift repair, exact cleanup/canary tests, runbooks. | Unauthorized release executes, data invariant fails, or neighboring canary changes. |
| 15 | Full lifecycle and policy-ring matrix | 7–14 | Console/lock/switch/RDP approved cases, service restart/crash loop/sleep/upgrade; representative GPO/EDR/firewall rings. | Any proposed supported environment fails; exclude or redesign through ADR. |
| 16 | Independent secure-code/design review | 1–15 | Threat model review, native boundary review, protocol cryptographic review, installer review, privacy schema review, resolved findings. | Critical/high boundary finding unresolved. |
| 17 | Execute full G1 gate | 0–16 | Signed sanitized evidence bundle, exact primary assertion, cleanup verification, confidence update, ADR statuses. | **Zero cross-session accepted messages; no profile access by the service; no prohibited privileges; bounded hostile-client impact.** |
| 18 | Authorize dependent G2/G3 implementation | G1 pass plus human support decisions | Published supported environment matrix and accepted ADRs. | A G1 pass on one unapproved lab image cannot authorize the fleet. |

## 13.1 Parallelism rules

- Items 1–3 can partially overlap after G0, but service/task security cannot be declared until the installer applies and verifies it.
- Protocol schema/unit work may begin in parallel, but no IPC acceptance claim precedes items 4–8.
- Task Host implementation can begin after launcher/interop, but must remain a fixed synthetic mode until G1 passes and later source/privacy gates authorize collection.
- Observability is built alongside each component; it is not a post-hoc logging task.
- A failed early gate freezes dependent merge/release branches and creates an ADR with affected invariant, new evidence, smallest falsifying experiment and migration consequence.

## 13.2 Skills, cost, licensing, and operational consequences

This design uses built-in Windows/.NET mechanisms, so it adds no endpoint runtime license by itself. That does not mean “zero cost.” The project needs demonstrable skills in Windows tokens/SIDs/DACL/SCM/Task Scheduler/WTS/named pipes/jobs/WFP, .NET async and SafeHandle interop, MSI, code signing, fuzz/fault testing, SQLite crash semantics, privacy engineering and fleet support. The most expensive work is likely representative enterprise-policy testing, same-session/same-SID security validation, installer/rollback engineering, and maintaining signed current/rollback releases—not the CBOR codec.

Open-source licenses reviewed are permissive, but attribution, notices, source-generator/package provenance and transitive licenses still need automated compliance. Chromium is reference-only partly because importing its sandbox would carry substantial code/third-party/license and maintenance surface. A third-party Task Scheduler wrapper may reduce installer code but adds a package and maintainer dependency at the privileged boundary; direct COM interop is preferable for the first proof unless a separate dependency ADR demonstrates lower risk.

Operationally, fail-closed behavior produces visible monitoring gaps when tasks, firewall, tokens or releases drift. Health must distinguish `DisabledByPolicy`, `UnsupportedEnvironment`, `TaskBoundaryMismatch`, `ServicePrivilegeMismatch`, `IpcIsolationFailure`, `TaskConfinementFailure`, `CrashLoopContained`, and `AwaitingHumanRepair` without exposing the user/session identity. Support runbooks must cover evidence capture, privacy canary response, repair/reboot, rollback, stuck task/job, firewall-policy conflict, crash-loop disable and uninstall disposition before pilot.

# 14. Open-source repository assessment

## 14.1 Assessment method and decision

**FACT:** The review below uses immutable tags or commits rather than floating default branches. Release recency, license, security policy, tests, relevant implementation files, and the architectural threat model were reviewed as of 31 July 2026. Popularity is deliberately not an acceptance criterion.

**RECOMMENDATION:** Treat Tailscale, `go-winio`, PowerToys, TaskScheduler, and Chromium as design and test references only. None is a drop-in UAM runtime dependency. Use `microsoft/CsWin32` only as a pinned build-time source generator after an explicit package/provenance check, API allowlist, committed generated-code diff, and native-semantics review. A later installer ADR may reconsider `dahall/TaskScheduler`; G1 should first prove the small required COM surface directly.

The assessment distinguishes two questions:

1. **Documented/repository capability:** what the reviewed project actually implements and tests.
2. **UAM fitness:** whether that code has the same identity, privacy, privilege, lifecycle, offline, and hostile-client boundaries. Similar API use does not establish fitness.

## 14.2 Repository assessment table

| Repository and immutable version | Relevant files/directories reviewed | License and compatibility concerns | Maintenance, testing, and security posture | Architectural similarity and threat-model difference | Reuse / do not copy | Suitability |
| --- | --- | --- | --- | --- | --- | --- |
| **Tailscale** — [`tailscale/tailscale`](https://github.com/tailscale/tailscale), tag [`v1.98.10`](https://github.com/tailscale/tailscale/releases/tag/v1.98.10), commit [`36550d57f4a4055246ef7412f4e650a012a465f1`](https://github.com/tailscale/tailscale/commit/36550d57f4a4055246ef7412f4e650a012a465f1), released 28 July 2026 | [`safesocket/pipe_windows.go`](https://github.com/tailscale/tailscale/blob/36550d57f4a4055246ef7412f4e650a012a465f1/safesocket/pipe_windows.go); [`safesocket/pipe_windows_test.go`](https://github.com/tailscale/tailscale/blob/36550d57f4a4055246ef7412f4e650a012a465f1/safesocket/pipe_windows_test.go); [`LICENSE`](https://github.com/tailscale/tailscale/blob/36550d57f4a4055246ef7412f4e650a012a465f1/LICENSE); [`SECURITY.md`](https://github.com/tailscale/tailscale/blob/36550d57f4a4055246ef7412f4e650a012a465f1/SECURITY.md) | BSD-3-Clause. Go implementation and the surrounding VPN daemon are not usable as a .NET library. Copying small ideas still requires attribution review and an independent native/API implementation. | Active release three days before the research date; repository has a security policy and pipe tests. Reviewed code includes a finite client timeout, 256 KiB buffers, explicit SDDL, client PID retrieval, and token plumbing. Those tests do not exercise UAM's two-stage logon-SID handoff, deterministic framing, privacy ceiling, or 10,000 hostile attempts. | Similar: privileged/background daemon accepting local named-pipe clients and deriving client identity from Windows. Different: Tailscale is a network/VPN control plane and its reviewed pipe grants built-in users broad read/write access, then uses client impersonation. UAM deliberately removes `SeImpersonate` and treats session/logon identity as a privacy boundary. | **Reuse:** explicit security descriptor construction, cancellation/timeout discipline, PID lookup, token-query patterns, and Windows-specific tests. **Do not copy:** `(A;OICI;GWGR;;;BU)` as an authorization policy; `RunAsClient`/impersonation as the normal identity path; 256 KiB buffers without UAM quota analysis; daemon-wide architecture. | **Reference only.** Valuable hostile-test cases and API sequencing; unsuitable as a dependency or authorization design. `[OSS-TAILSCALE]` |
| **Microsoft `go-winio`** — [`microsoft/go-winio`](https://github.com/microsoft/go-winio), tag [`v0.6.2`](https://github.com/microsoft/go-winio/releases/tag/v0.6.2), commit [`3c9576c9346a1892dee136329e7e15309e82fb4f`](https://github.com/microsoft/go-winio/commit/3c9576c9346a1892dee136329e7e15309e82fb4f), released 19 April 2024 | [`pipe.go`](https://github.com/microsoft/go-winio/blob/3c9576c9346a1892dee136329e7e15309e82fb4f/pipe.go); [`sd.go`](https://github.com/microsoft/go-winio/blob/3c9576c9346a1892dee136329e7e15309e82fb4f/sd.go); [`pipe_test.go`](https://github.com/microsoft/go-winio/blob/3c9576c9346a1892dee136329e7e15309e82fb4f/pipe_test.go); [`LICENSE`](https://github.com/microsoft/go-winio/blob/3c9576c9346a1892dee136329e7e15309e82fb4f/LICENSE); [`SECURITY.md`](https://github.com/microsoft/go-winio/blob/3c9576c9346a1892dee136329e7e15309e82fb4f/SECURITY.md) | MIT. Go-only native wrapper; it cannot be used directly by the accepted C#/.NET endpoint. Reimplementing behavior still requires review against Microsoft Win32 documentation rather than treating the wrapper as the specification. | The pinned release is more than two years old at the research date. Its release notes include updated tests/fuzzing, a security-descriptor length fix, named-pipe flush/disconnect support, client impersonation-level support, and CI/toolchain updates. It is mature systems code, but maintenance recency must be checked again before using any idea that depends on current Windows behavior. | Similar: explicit named-pipe creation, SDDL conversion, async/cancellation behavior, deadlines, disconnect semantics, and low-level Windows errors. Different: it is a general transport package; it has no UAM release-image validation, realm/privacy contract, per-logon handoff, minimized-event schema, or service privilege prohibition. | **Reuse:** edge cases for connect cancellation, server close, flush/disconnect, malformed descriptors, deadlines, and race tests. **Do not copy:** package API as UAM authorization; generic pipe defaults; Go-specific unsafe/syscall patterns; impersonation-based identity without a separate privilege decision. | **Reference only.** Good source of native semantics and test ideas, not a .NET dependency or complete protocol. `[OSS-GOWINIO]` |
| **Microsoft PowerToys** — [`microsoft/PowerToys`](https://github.com/microsoft/PowerToys), tag [`v0.100.2`](https://github.com/microsoft/PowerToys/releases/tag/v0.100.2), commit [`1d11b732b7ba7dbb265d1151531655fd8d83c76d`](https://github.com/microsoft/PowerToys/commit/1d11b732b7ba7dbb265d1151531655fd8d83c76d), released 26 June 2026 | [`src/runner`](https://github.com/microsoft/PowerToys/tree/1d11b732b7ba7dbb265d1151531655fd8d83c76d/src/runner); [`src/common`](https://github.com/microsoft/PowerToys/tree/1d11b732b7ba7dbb265d1151531655fd8d83c76d/src/common); [`src/ActionRunner`](https://github.com/microsoft/PowerToys/tree/1d11b732b7ba7dbb265d1151531655fd8d83c76d/src/ActionRunner); [`LICENSE`](https://github.com/microsoft/PowerToys/blob/1d11b732b7ba7dbb265d1151531655fd8d83c76d/LICENSE); [`SECURITY.md`](https://github.com/microsoft/PowerToys/blob/1d11b732b7ba7dbb265d1151531655fd8d83c76d/SECURITY.md) | MIT, but the large repository has many components and third-party notices. Direct source reuse would import a broad build/toolchain/telemetry/updater/elevation surface that is unrelated to G1. | Current, high-activity Windows desktop project with a security policy, broad CI/tests, installer hashes, and release engineering. The reviewed patch fixed a Command Palette memory leak, which is useful evidence of active maintenance and of why bounded lifecycle/resource tests matter. The repository's breadth also makes narrow security review expensive. | Similar: signed multi-process Windows product, machine/per-user installation concepts, runners, common native utilities, process decomposition, elevation boundaries, telemetry discipline, and release artifacts. Different: it is an interactive utility suite with many modules, actions, plugins, UI surfaces, and updater/elevation paths; UAM needs a closed capability set and a privacy/session isolation gate. | **Reuse:** decomposition conventions, manifest/release hygiene, installer hashes, crash/resource testing, accessibility and telemetry review patterns. **Do not copy:** general action runner, plugin loading, arbitrary command surface, broad elevation helper, autonomous updater, or per-feature IPC without UAM identity validation. | **Reference only.** Useful operational and Windows-product engineering comparison; not a focused dependency. `[OSS-POWERTOYS]` |
| **David Hall Task Scheduler Managed Wrapper** — [`dahall/TaskScheduler`](https://github.com/dahall/TaskScheduler), tag [`v2.12.2`](https://github.com/dahall/TaskScheduler/releases/tag/v2.12.2), commit [`59a6a2234a44ce885133301345b85f9d2bd6b86a`](https://github.com/dahall/TaskScheduler/commit/59a6a2234a44ce885133301345b85f9d2bd6b86a), released 8 July 2025 | [`TaskService`](https://github.com/dahall/TaskScheduler/tree/59a6a2234a44ce885133301345b85f9d2bd6b86a/TaskService); [`TaskService.cs`](https://github.com/dahall/TaskScheduler/blob/59a6a2234a44ce885133301345b85f9d2bd6b86a/TaskService/TaskService.cs); [`TaskFolder.cs`](https://github.com/dahall/TaskScheduler/blob/59a6a2234a44ce885133301345b85f9d2bd6b86a/TaskService/TaskFolder.cs); [`TaskSecurity.cs`](https://github.com/dahall/TaskScheduler/blob/59a6a2234a44ce885133301345b85f9d2bd6b86a/TaskService/TaskSecurity.cs); [`TestTaskService`](https://github.com/dahall/TaskScheduler/tree/59a6a2234a44ce885133301345b85f9d2bd6b86a/TestTaskService); [`LICENSE`](https://github.com/dahall/TaskScheduler/blob/59a6a2234a44ce885133301345b85f9d2bd6b86a/LICENSE) | MIT. It is a broad managed wrapper around Task Scheduler 1.0/2.0 and includes far more capability than UAM needs. Adding it to the privileged installer boundary adds a package-maintainer and transitive-build dependency; package signing/provenance and supported framework targets require a separate execution-time check. | The reviewed release was about one year old and added recursive folder enumeration, a .NET Standard 2.1 `TaskService`, and .NET 9 editor support. The repository includes a substantial test project and long-lived API coverage. Its tests establish wrapper behavior, not estate policy compatibility or security of UAM's exact task principal/DACL. | Similar: C# registration/query/export/security-descriptor handling for Windows Scheduled Tasks. Different: it intentionally exposes remote connections, credentials, COM handlers, arbitrary actions, and broad scheduler features that UAM must not expose at runtime. | **Reuse:** XML round-trip tests, registration/error cases, task security-descriptor queries, principal/logon/run-level mappings, and cleanup tests. **Do not copy/use:** remote scheduler credentials, COM handlers, arbitrary action construction, runtime task mutation, or package-wide API exposure. | **Reference only for G1.** A possible installer-only dependency later, but only after an ADR demonstrates lower total risk than the small direct COM surface. `[OSS-TASKSCHED]` |
| **Chromium Windows sandbox** — [`chromium/src/sandbox`](https://chromium.googlesource.com/chromium/src/sandbox/), exact commit [`ee302baa5ed512cef29f848253dd8f4e9991b140`](https://chromium.googlesource.com/chromium/src/sandbox/+/ee302baa5ed512cef29f848253dd8f4e9991b140), authored 3 February 2026 | [`restricted_token_utils.cc`](https://chromium.googlesource.com/chromium/src/+/ee302baa5ed512cef29f848253dd8f4e9991b140/sandbox/win/src/restricted_token_utils.cc); [`target_process.cc`](https://chromium.googlesource.com/chromium/src/+/ee302baa5ed512cef29f848253dd8f4e9991b140/sandbox/win/src/target_process.cc); [`job.cc`](https://chromium.googlesource.com/chromium/src/+/ee302baa5ed512cef29f848253dd8f4e9991b140/sandbox/win/src/job.cc); [`sandbox/win/tests`](https://chromium.googlesource.com/chromium/src/+/ee302baa5ed512cef29f848253dd8f4e9991b140/sandbox/win/tests/); [sandbox design](https://chromium.googlesource.com/chromium/src/+/HEAD/docs/design/sandbox.md); [reviewed change](https://chromium.googlesource.com/chromium/src/sandbox/+/ee302baa5ed512cef29f848253dd8f4e9991b140%5E%21/) | Chromium's top-level BSD-style license is permissive, but the repository carries extensive third-party code/notices and a very large continuous maintenance burden. Importing the sandbox is not a small dependency decision. | Very active, mature, heavily reviewed security subsystem with dedicated Windows tests. The exact reviewed change adds test coverage around restricted-token access semantics. Chromium documents broker/target separation and limitations, including that low integrity alone still permits many reads and does not itself deny all networking. Its security strength depends on the complete browser architecture and continuous hardening, not isolated utility files. | Similar: restricted tokens, deny-only/restricting SIDs, integrity levels, Job Objects, pre-start policy, handle control, mitigations, broker/target separation, and adversarial testing. Different: Chromium assumes hostile web-renderer code and supplies a large broker/interception policy; UAM runs fixed signed collector modes and initially needs fault/privacy containment rather than a general untrusted-code sandbox. | **Reuse:** layered primitive model, immutable pre-resume policy, explicit residual limitations, token/job/mitigation test cases, and brokered-handle option if the threat model later strengthens. **Do not copy:** claim equivalence from a subset; import the interception/broker framework; expose a broad broker API; rely on low integrity as a read/network boundary. | **Reference only.** Strongest security design reference, but intentionally not a dependency. `[OSS-CHROMIUM]` |
| **Microsoft CsWin32** — [`microsoft/CsWin32`](https://github.com/microsoft/CsWin32), tag [`v0.3.298`](https://github.com/microsoft/CsWin32/releases/tag/v0.3.298), commit [`e4a7320acd0c62f7490efd4c34421c181212dd8d`](https://github.com/microsoft/CsWin32/commit/e4a7320acd0c62f7490efd4c34421c181212dd8d), released 22 June 2026 | [`src`](https://github.com/microsoft/CsWin32/tree/e4a7320acd0c62f7490efd4c34421c181212dd8d/src); [`test`](https://github.com/microsoft/CsWin32/tree/e4a7320acd0c62f7490efd4c34421c181212dd8d/test); [`integration-tests`](https://github.com/microsoft/CsWin32/tree/e4a7320acd0c62f7490efd4c34421c181212dd8d/integration-tests); [`CodeQL.yml`](https://github.com/microsoft/CsWin32/blob/e4a7320acd0c62f7490efd4c34421c181212dd8d/.github/workflows/CodeQL.yml); [`SECURITY.md`](https://github.com/microsoft/CsWin32/blob/e4a7320acd0c62f7490efd4c34421c181212dd8d/SECURITY.md); [`LICENSE`](https://github.com/microsoft/CsWin32/blob/e4a7320acd0c62f7490efd4c34421c181212dd8d/LICENSE) | MIT. It is a build-time source generator, not a Windows security abstraction. Generated signatures and types become UAM source/build output and still require semantic review. Version locking, package provenance, generated-code diffing, notices, and SBOM entry are mandatory. | Active release five weeks before the research date; repository has unit/integration tests, a security policy, and CodeQL workflow. The reviewed release added Windows-latest COM runtime tests and fixed COM pointer overload generation. Current activity lowers transcription risk but does not transfer responsibility for access masks, object lifetime, DACL ordering, token semantics, or unsafe buffer use. | Similar only at the interop layer: it generates strongly typed Win32 declarations used by service, task, token, pipe, process, job, ACL, WTS, and firewall code. It does not implement the Coordinator/User Host/Task Host architecture, IPC protocol, sandbox policy, or lifecycle. | **Reuse:** only the allowlisted APIs in `NativeMethods.txt`, generated structs/constants, and SafeHandle-friendly signatures. **Do not generate:** the entire Win32 surface; obsolete/ANSI variants; APIs not linked to a reviewed wrapper/test. Do not merge generated changes without human/native review. | **Pinned build-time dependency candidate.** Use `PrivateAssets="all"`, package lock, hash/provenance/SBOM, a generated API surface check, and an exit plan to manual P/Invoke for blocked fixes. `[OSS-CSWIN32]` |

## 14.3 Dependency admission rules

An open-source reference becomes a dependency only through a separate ADR containing all of the following:

1. exact package/tag/commit and package hash;
2. license, notice, patent, export, and transitive-dependency review;
3. supported framework/Windows matrix and maintainer/release activity;
4. security policy, vulnerability intake, signed-release/provenance evidence, and update SLA decision;
5. API surface actually used, with all unused capability unavailable to runtime code;
6. threat-model match and explicit list of security decisions that remain UAM's responsibility;
7. deterministic tests, fuzz/fault cases, SBOM, package lock, offline restore/build proof, and removal/patch plan;
8. measurement showing less total security and operational risk than the in-house alternative.

**Stop gate:** no package may enter `Uam.Windows.*`, installer custom actions, Coordinator, launcher, User Host, or Task Host merely because it wraps a difficult Win32 API. The privileged/runtime boundary must remain reviewable from UAM source and generated output.

## 14.4 Ideas incorporated and deliberately excluded

| Incorporated idea | Source influence | UAM-specific change |
| --- | --- | --- |
| Explicit pipe SDDL and cancellation/deadline tests | Tailscale and `go-winio` | Exact rights instead of generic write; no broad built-in-users authorization; no impersonation privilege; two-stage exact-logon pipe and HMAC transcript |
| Multi-process release/installer discipline | PowerToys | Closed service/launcher/host/task dependency graph; no plugin/action/updater surface in G1 |
| Canonical task XML, security descriptor query, and round-trip cleanup tests | TaskScheduler wrapper | Direct minimal COM implementation first; fixed group principal, least privilege, triggers, task DACL, and no runtime mutation |
| Layered token + integrity + job + mitigations + brokered-handle thinking | Chromium | Fixed trusted capability modes; smaller boundary; candid same-user read residual; no interception framework |
| Generated typed Win32 declarations | CsWin32 | API allowlist, committed/reviewed generated diff, SafeHandle wrappers, package lock, no runtime package dependency |

**Ideas deliberately excluded:** broad user pipe ACLs, pipe impersonation as identity, runtime task registration, remote scheduler credentials, arbitrary actions/plugins/scripts, general elevation helpers, self-update, a general Chromium-style broker API, low integrity as a claimed read/network sandbox, and generating the whole Win32 API surface.

# 15. Source register

## 15.1 Reading the register

All web sources were checked on **31 July 2026**. Microsoft Learn and .NET policy pages are living documents; their visible update date is recorded where available, but the release process must re-check them rather than treating this report as a frozen platform contract. Immutable repository commits are used for code review. Internal evidence is sanitized and is identified by filename, date/hash, purpose, and limitation; no raw configuration, activity, address, credential, or SSH material appears here.

Citation shorthand used earlier:

- A range such as `[MS-SVC-01..04]`, `[MS-PIPE-01..03]`, or `[MS-JOB-01..03]` means every numbered row in the inclusive family range.
- `[MS-TASK-*]`, `[MS-PIPE-*]`, `[MS-TOKEN-*]`, and `[MS-JOB-*]` mean every row in that named family.
- An aggregate row may contain several closely related first-party API pages. The claim remains limited to the capabilities those pages document.

## 15.2 Supplied internal evidence

| ID | Source, date, and reviewed version | Claim supported | Limitation |
| --- | --- | --- | --- |
| `[INT-BASE]` | `00-accepted-baseline-attachment.md`; baseline dated 31 July 2026; synthesis SHA-256 `acaee72712c9203a8827cc235b36b12fb3caf65136d64ea6f3cb9b80681cd5f1` | Accepted three-context endpoint model, user-session reads, C#/.NET default, privacy ceiling, pre-IPC minimization, atomic event/cursor invariant, MSI-owned privileged boundary, and human-decision boundaries | Working implementation-research baseline, not legal approval, production authority, runtime proof, supported-environment decision, or exact field/resource policy |
| `[INT-LEGACY]` | `01-existing-system-evidence-summary.md`; deterministic sanitized summary of committed legacy endpoint/admin/schema sources; listed source fingerprints reviewed | Legacy monolith combines collection, scheduling, database access, deferred executable SQL, recovery, and user/profile dependence; supports the need for boundary separation | Static and metadata-only evidence; does not establish every runtime path, production setting, consumer, volume, currentness, or approval to preserve behavior |
| `[INT-LAB]` | `03-sanitized-windows-lab-capability.md`; local capability inspection dated 31 July 2026 | An approved path for later Windows/PowerShell CLI work exists and placeholder-only experiments can be designed | Proves no OS build, identity, RDP/RDS/VDI, runtime, Edge, TPM, proxy, EDR, policy, permission, or Windows behavior; no connection details may enter evidence |
| `[INT-GATES]` | `05-decisions-contradictions-and-gates.md`; July 2026 synthesis, SHA-256 `acaee72712c9203a8827cc235b36b12fb3caf65136d64ea6f3cb9b80681cd5f1` | G1 precedes G2, failed early gates stop dependent work and open an ADR, and the primary accepted architecture/invariants | Accepted for implementation research only; passing a gate proves only its stated claim and is not fleet or production approval |
| `[INT-RULES]` | `06-research-evidence-rules.md`; current research-package rules | Evidence labels, primary-source preference, privacy boundaries, conflict handling, and requirement for CLI/lab proof | Method rule, not evidence that a Windows or UAM technical claim is true |

## 15.3 .NET platform and Windows Service sources

| ID | Stable primary source | Source/release date and reviewed version | Claim supported | Limitation |
| --- | --- | --- | --- | --- |
| `[MS-DOTNET-01]` | [.NET and .NET Core support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) | Page last updated 14 July 2026; reviewed .NET 10 row: latest patch `10.0.10`, patch date 14 July 2026, LTS/Active, end of support 14 November 2028 | .NET 10 is the current active LTS baseline at the research date and supported installations must stay current on patches | Point-in-time lifecycle fact; does not choose UAM's exact runtime packaging, Windows support matrix, servicing ring, or release patch |
| `[MS-DOTNET-02]` | [.NET downloads](https://dotnet.microsoft.com/en-us/download) | Reviewed 31 July 2026; SDK `10.0.302`, released 14 July 2026 | Current SDK available for a `net10.0-windows` G1 implementation | Download page changes; exact SDK/runtime must be locked and revalidated at build/release time |
| `[MS-DOTNET-03]` | [Create Windows Service using `BackgroundService`](https://learn.microsoft.com/en-us/dotnet/core/extensions/windows-service) | Microsoft Learn page last updated 22 October 2025; reviewed with .NET 10 examples | .NET Worker/Generic Host can run as a Windows Service and integrate with SCM lifecycle | Tutorial capability only; it does not provide UAM's token, service SID, privilege, ACL, recovery, or privacy design |
| `[MS-DOTNET-04]` | [.NET named-pipe IPC tutorial](https://learn.microsoft.com/en-us/dotnet/standard/io/how-to-use-named-pipes-for-network-interprocess-communication) | Microsoft Learn page last updated 7 May 2026; reviewed against .NET 10 | Managed named-pipe APIs and asynchronous stream patterns are available | Example authorization/framing is not adequate for UAM; native flags, exact ACLs, peer validation, quotas, HMAC, and hostile tests remain UAM work |
| `[MS-SVC-01]` | [LocalService account](https://learn.microsoft.com/en-us/windows/win32/services/localservice-account) | Page last updated 7 January 2021; reviewed 31 July 2026 | `LocalService` has low local privilege and anonymous network credentials, but its default token includes enabled `SeChangeNotifyPrivilege`, `SeCreateGlobalPrivilege`, and `SeImpersonatePrivilege` | Account name alone is not least privilege; effective token and estate policy must be measured after SCM required-privilege configuration |
| `[MS-SVC-02]` | [`SERVICE_SID_INFO`](https://learn.microsoft.com/en-us/windows/win32/api/winsvc/ns-winsvc-service_sid_info) | Page last updated 22 February 2024 | `SERVICE_SID_TYPE_RESTRICTED` places the service SID in the token and restricted SID list; the change takes effect on the next system start | Documents SCM behavior, not whether UAM's ProgramData/pipe/process ACLs are sufficient; shared-process caveat is avoided by a dedicated executable |
| `[MS-SVC-03]` | [`SERVICE_REQUIRED_PRIVILEGES_INFO`](https://learn.microsoft.com/en-us/windows/win32/api/winsvc/ns-winsvc-service_required_privileges_infoa); [service changes for Windows Vista](https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista) | Structure page last updated 20 November 2024; service isolation page last updated 7 January 2021 | A service can declare the privileges it requires and SCM removes privileges not listed; supports the G1 one-privilege allowlist | Unicode implementation must use the `W` form/correct multi-string. Whether one privilege is sufficient is a CLI gate, not a documentation fact |
| `[MS-SVC-04]` | [`ChangeServiceConfig2W`](https://learn.microsoft.com/en-us/windows/win32/api/winsvc/nf-winsvc-changeserviceconfig2w); [Service security and access rights](https://learn.microsoft.com/en-us/windows/win32/services/service-security-and-access-rights); [Service failure actions](https://learn.microsoft.com/en-us/windows/win32/services/service-failure-actions) | `ChangeServiceConfig2W` last updated 20 November 2024; service-security page last updated 7 January 2021; reviewed 31 July 2026 | Installer can configure service SID, required privileges, delayed start/failure actions, and a constrained service-object DACL; broad service change/stop rights are dangerous | API/configuration capability only. Exact SDDL, crash-loop containment, policy refresh, reboot, repair, and uninstall behavior must be exported and tested |

## 15.4 Scheduled Task, session, pipe, and Windows security sources

| ID | Stable primary source | Source/release date and reviewed version | Claim supported | Limitation |
| --- | --- | --- | --- | --- |
| `[MS-TASK-01]` | [`TASK_DONT_ADD_PRINCIPAL_ACE` in MS-TSCH](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-tsch/849c131a-64e4-46ef-b015-9d4c599c5167); [`Principal.LogonType`](https://learn.microsoft.com/en-us/windows/win32/taskschd/principal-logontype); [`Principal.RunLevel`](https://learn.microsoft.com/en-us/windows/win32/taskschd/principal-runlevel); [`TaskSettings.MultipleInstances`](https://learn.microsoft.com/en-us/windows/win32/taskschd/tasksettings-multipleinstances); [`SessionStateChangeTrigger`](https://learn.microsoft.com/en-us/windows/win32/taskschd/sessionstatechangetrigger) | MS-TSCH page updated 24 June 2021; LogonType 25 August 2021; RunLevel, MultipleInstances, and session-trigger pages reviewed with 11 December 2020 update family | Task Scheduler supports group activation, existing interactive sessions, least-privilege run level, parallel instances, session-state triggers, and registration without adding a principal ACE to the task file | Does not prove one task instance per eligible logon session in every estate, ordinary-token shape, effective task DACL, GPO rewrite behavior, or same-account session handling; all are G1 tests |
| `[MS-WTS-01]` | [`WTSEnumerateSessionsW`](https://learn.microsoft.com/en-us/windows/win32/api/wtsapi32/nf-wtsapi32-wtsenumeratesessionsw); [`WTSQuerySessionInformationW`](https://learn.microsoft.com/en-us/windows/win32/api/wtsapi32/nf-wtsapi32-wtsquerysessioninformationw); [Service control handler session events](https://learn.microsoft.com/en-us/windows/win32/api/winsvc/nc-winsvc-lphandler_function_ex) | Living Microsoft Learn API pages reviewed 31 July 2026 | Coordinator can observe/reconcile WTS session IDs and lifecycle notifications without acquiring user tokens | Session enumerations are mutable observations, not authentication. Event delivery, races, RDS/VDI behavior, and support scope require the lifecycle matrix |
| `[MS-PIPE-01]` | [Named Pipe Security and Access Rights](https://learn.microsoft.com/en-us/windows/win32/ipc/named-pipe-security-and-access-rights) | Page last updated 7 January 2021 | Pipe DACLs control client/server access; default DACL is too broad; generic write includes create-pipe-instance; a logon SID can restrict another terminal/logon session | Logon-SID guidance does not alone defeat pipe squatting, PID reuse, same-session malware, inherited/duplicated handles, or DoS; UAM adds exact rights and peer validation |
| `[MS-PIPE-02]` | [`CreateNamedPipeW`](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-createnamedpipew) | Page last updated 2 February 2023 | Pipe name is flat under `\\.\pipe\`, security attributes apply on creation, `FILE_FLAG_FIRST_PIPE_INSTANCE`, overlapped I/O, instance/buffer limits, and `PIPE_REJECT_REMOTE_CLIENTS` are available | Buffer sizes are advisory and consume nonpaged pool; flags and flat naming do not authenticate peers or prove local DoS bounds |
| `[MS-PIPE-03]` | [`GetNamedPipeClientProcessId`](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-getnamedpipeclientprocessid); [`GetNamedPipeServerProcessId`](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-getnamedpipeserverprocessid); [`GetNamedPipeClientSessionId`](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-getnamedpipeclientsessionid); [`GetNamedPipeServerSessionId`](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-getnamedpipeserversessionid) | Microsoft Learn API pages reviewed 31 July 2026; current page family last-updated metadata reviewed at 22 February 2024 where shown | A connected endpoint can obtain kernel-reported peer PID and session ID, enabling process/token validation without trusting payload identity | PID/session are evidence inputs, not authentication by themselves; process handle, creation time, token, image/signature, expected SCM PID, transcript and reconnect checks are required |
| `[MS-TOKEN-01]` | [`OpenProcess`](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-openprocess); [`GetProcessTimes`](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getprocesstimes); [`OpenProcessToken`](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-openprocesstoken); [`GetTokenInformation`](https://learn.microsoft.com/en-us/windows/win32/api/securitybaseapi/nf-securitybaseapi-gettokeninformation); [`TOKEN_STATISTICS`](https://learn.microsoft.com/en-us/windows/win32/api/winnt/ns-winnt-token_statistics) | Living Microsoft Learn API pages reviewed 31 July 2026 | Service/client can hold a process handle and query creation time, user/logon groups, authentication LUID, token type, session, integrity, elevation, restriction, and related identity facts | Required query rights may be denied by default or by security software; launcher-created process/token DACL and same-SID theft resistance are CLI gates |
| `[MS-TOKEN-02]` | [`CreateRestrictedToken`](https://learn.microsoft.com/en-us/windows/win32/api/securitybaseapi/nf-securitybaseapi-createrestrictedtoken); [Restricted Tokens](https://learn.microsoft.com/en-us/windows/win32/secauthz/restricted-tokens) | Function page last updated 13 October 2021; reviewed 31 July 2026 | A duplicate token can disable SIDs, delete privileges, and add restricting SIDs; `DISABLE_MAX_PRIVILEGE` leaves `SeChangeNotifyPrivilege`; `WRITE_RESTRICTED` affects restricting-SID evaluation for writes | A restricted ordinary-user token remains able to read many same-user resources; exact SID/privilege list and launch behavior require access-check and hostile tests |
| `[MS-PROC-01]` | [`CreateProcessAsUserW`](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-createprocessasuserw); [`CreateProcessW`](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-createprocessw) | `CreateProcessAsUserW` page last updated 9 February 2023; reviewed 31 July 2026 | Windows can create a process under a primary token; using a restricted version of the caller's primary token has documented privilege exceptions; executable path/command-line/inheritance semantics are explicit | Whether UAM can launch its restricted Task Host with zero privilege additions and the required environment/mitigations is not proved until P5/E13 |
| `[MS-JOB-01]` | [Job Objects](https://learn.microsoft.com/en-us/windows/win32/procthread/job-objects) | Page last updated 14 July 2025 | Job Objects group processes, apply limits, expose notifications/accounting, and close/terminate a process tree according to configured limits | Nested-job, breakaway, EDR, crash, shutdown, and .NET runtime behavior vary; UAM needs pre-resume assignment and explicit kill-tree tests |
| `[MS-JOB-02]` | [`AssignProcessToJobObject`](https://learn.microsoft.com/en-us/windows/win32/api/jobapi2/nf-jobapi2-assignprocesstojobobject); [`SetInformationJobObject`](https://learn.microsoft.com/en-us/windows/win32/api/jobapi2/nf-jobapi2-setinformationjobobject); [`TerminateJobObject`](https://learn.microsoft.com/en-us/windows/win32/api/jobapi2/nf-jobapi2-terminatejobobject); [`JOBOBJECT_EXTENDED_LIMIT_INFORMATION`](https://learn.microsoft.com/en-us/windows/win32/api/winnt/ns-winnt-jobobject_extended_limit_information) | Living Microsoft Learn API pages reviewed 31 July 2026 | Supports one-process limit, kill-on-job-close, unhandled-exception behavior, CPU/memory limits, completion-port notifications, explicit termination, and accounting | Limits can fail or interact with existing jobs; numerical caps are estimates pending measurement and every descendant/orphan path must be tested |
| `[MS-JOB-03]` | [`InitializeProcThreadAttributeList`](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-initializeprocthreadattributelist); [`UpdateProcThreadAttribute`](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-updateprocthreadattribute); [Process mitigation policies](https://learn.microsoft.com/en-us/windows/win32/procthread/process-mitigation-policy) | `UpdateProcThreadAttribute` page last updated 1 November 2022; page family reviewed 31 July 2026 | Extended startup attributes support an explicit handle list, Job list, parent/mitigation policy, and pre-resume confinement | Attribute availability/compatibility depends on Windows/runtime/EDR; mitigations such as ACG or Microsoft-only image policy can break .NET and are not enabled without proof |
| `[MS-SID-01]` | [Well-known SID structures in MS-DTYP](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-dtyp/11e1608c-6169-4fbc-9c33-373fc9b224f4); [Security identifiers](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-identifiers); [Getting the logon SID](https://learn.microsoft.com/en-us/windows/win32/secauthz/getting-the-logon-sid-in-c--) | MS-DTYP page last updated 28 August 2023; SID overview updated 26 June 2025; reviewed 31 July 2026 | Defines well-known SIDs including INTERACTIVE and OWNER RIGHTS; a logon SID identifies a logon session and can be placed in object DACLs | SID construction must use binary APIs, not string parsing; logon SID does not protect against malicious code in the same logon session or a stolen process handle |
| `[MS-MIC-01]` | [Mandatory Integrity Control](https://learn.microsoft.com/en-us/windows/win32/secauthz/mandatory-integrity-control) | Page last updated 8 July 2025 | Integrity labels impose a mandatory access check, and low integrity limits writes to higher-integrity objects unless labels permit them | MIC is principally a write boundary; it does not remove ordinary read access or guarantee network denial |
| `[MS-FW-01]` | [Windows Firewall rules](https://learn.microsoft.com/en-us/windows/security/operating-system-security/network-security/windows-firewall/rules); [Windows Filtering Platform](https://learn.microsoft.com/en-us/windows/win32/fwp/windows-filtering-platform-start-page) | Firewall rules page last updated 6 June 2025; reviewed 31 July 2026 | Enterprise/MSI can define application-specific outbound blocks and query effective policy; WFP is the underlying enforcement platform | Local rules may be disabled/overridden, path/publisher behavior can drift, and successful policy creation does not prove egress is blocked; effective tests are mandatory |
| `[MS-CODE-01]` | [`WinVerifyTrust`](https://learn.microsoft.com/en-us/windows/win32/api/wintrust/nf-wintrust-winverifytrust); [Verifying a PE signature](https://learn.microsoft.com/en-us/windows/win32/seccrypto/example-c-program--verifying-the-signature-of-a-pe-file) | Living Microsoft Learn pages reviewed 31 July 2026 | Authenticode trust/signature state can be verified for the exact executable opened through a held handle/path identity workflow | A valid generic signature is not sufficient authorization; UAM must pin an allowed release manifest/signer policy and address TOCTOU/reparse/file-identity cases |

## 15.5 Cryptographic and serialization standards

| ID | Stable primary source | Source date/version | Claim supported | Limitation |
| --- | --- | --- | --- | --- |
| `[RFC-5869]` | [RFC 5869 — HMAC-based Extract-and-Expand Key Derivation Function](https://www.rfc-editor.org/rfc/rfc5869.html) | May 2010 | Standard HKDF extract/expand construction for deriving direction-specific per-connection keys from the handoff secret and transcript nonces | Correct primitive use does not prove transcript design, secret lifecycle, implementation constant-time behavior, or endpoint compromise resistance; vectors and review remain required |
| `[RFC-8949]` | [RFC 8949 — Concise Binary Object Representation](https://www.rfc-editor.org/rfc/rfc8949.html) | December 2020 | CBOR data model and deterministic-encoding rules used for closed, canonical UAM contracts | CBOR permits much more than UAM; decoder must reject indefinite lengths, duplicate/unknown keys where required, excessive nesting, floats/tags, and non-deterministic encodings |
| `[RFC-2104]` | [RFC 2104 — HMAC: Keyed-Hashing for Message Authentication](https://www.rfc-editor.org/rfc/rfc2104.html) | February 1997 | HMAC construction underlying frame authentication | HMAC authenticates possession of a connection key, not Windows identity or authorization; those are established before key handoff and revalidated per connection |

## 15.6 Immutable open-source source register

| ID | Stable source | Release date and reviewed tag/commit | Claim supported | Limitations / dependency decision |
| --- | --- | --- | --- | --- |
| `[OSS-TAILSCALE]` | [`tailscale/tailscale`](https://github.com/tailscale/tailscale); [`safesocket/pipe_windows.go`](https://github.com/tailscale/tailscale/blob/36550d57f4a4055246ef7412f4e650a012a465f1/safesocket/pipe_windows.go); [tests](https://github.com/tailscale/tailscale/blob/36550d57f4a4055246ef7412f4e650a012a465f1/safesocket/pipe_windows_test.go) | Tag `v1.98.10`, released 28 July 2026; commit `36550d57f4a4055246ef7412f4e650a012a465f1`; BSD-3-Clause | Concrete Windows pipe SDDL, timeout/cancellation, PID/token and test patterns in an actively maintained local daemon | Broad built-in-users ACL and impersonation model do not fit UAM; Go/VPN architecture; reference only |
| `[OSS-GOWINIO]` | [`microsoft/go-winio`](https://github.com/microsoft/go-winio); [`pipe.go`](https://github.com/microsoft/go-winio/blob/3c9576c9346a1892dee136329e7e15309e82fb4f/pipe.go); [`sd.go`](https://github.com/microsoft/go-winio/blob/3c9576c9346a1892dee136329e7e15309e82fb4f/sd.go); [tests](https://github.com/microsoft/go-winio/blob/3c9576c9346a1892dee136329e7e15309e82fb4f/pipe_test.go) | Tag `v0.6.2`, released 19 April 2024; commit `3c9576c9346a1892dee136329e7e15309e82fb4f`; MIT | Native named-pipe, SDDL, deadline, cancellation, flush/disconnect, fuzz/test edge cases | General Go transport with older release and no UAM threat/privacy model; reference only |
| `[OSS-POWERTOYS]` | [`microsoft/PowerToys`](https://github.com/microsoft/PowerToys); [`src/runner`](https://github.com/microsoft/PowerToys/tree/1d11b732b7ba7dbb265d1151531655fd8d83c76d/src/runner); [`src/common`](https://github.com/microsoft/PowerToys/tree/1d11b732b7ba7dbb265d1151531655fd8d83c76d/src/common); [`src/ActionRunner`](https://github.com/microsoft/PowerToys/tree/1d11b732b7ba7dbb265d1151531655fd8d83c76d/src/ActionRunner) | Tag `v0.100.2`, released 26 June 2026; commit `1d11b732b7ba7dbb265d1151531655fd8d83c76d`; MIT | Current multi-process Windows product, installer/release hashes, operational decomposition, resource-fix and telemetry/accessibility patterns | Broad interactive utilities/plugins/elevation/updater threat model; reference only |
| `[OSS-TASKSCHED]` | [`dahall/TaskScheduler`](https://github.com/dahall/TaskScheduler); [`TaskService`](https://github.com/dahall/TaskScheduler/tree/59a6a2234a44ce885133301345b85f9d2bd6b86a/TaskService); [`TestTaskService`](https://github.com/dahall/TaskScheduler/tree/59a6a2234a44ce885133301345b85f9d2bd6b86a/TestTaskService) | Tag `v2.12.2`, released 8 July 2025; commit `59a6a2234a44ce885133301345b85f9d2bd6b86a`; MIT | Mature managed Task Scheduler COM wrapper, registration/security/XML/test patterns | Much larger capability than UAM and a privileged installer dependency; reference only for G1, later dependency requires ADR |
| `[OSS-CHROMIUM]` | [Chromium Windows sandbox source](https://chromium.googlesource.com/chromium/src/sandbox/); [`restricted_token_utils.cc`](https://chromium.googlesource.com/chromium/src/+/ee302baa5ed512cef29f848253dd8f4e9991b140/sandbox/win/src/restricted_token_utils.cc); [`target_process.cc`](https://chromium.googlesource.com/chromium/src/+/ee302baa5ed512cef29f848253dd8f4e9991b140/sandbox/win/src/target_process.cc); [`job.cc`](https://chromium.googlesource.com/chromium/src/+/ee302baa5ed512cef29f848253dd8f4e9991b140/sandbox/win/src/job.cc); [design](https://chromium.googlesource.com/chromium/src/+/HEAD/docs/design/sandbox.md) | Exact commit `ee302baa5ed512cef29f848253dd8f4e9991b140`, authored 3 February 2026; Chromium BSD-style license plus third-party notices | Mature layered restricted-token, integrity, job, mitigation, broker/target design and adversarial tests; documents low-integrity/read/network limitations | Browser renderer threat model and enormous broker/interception/maintenance surface differ; reference only; no equivalence claim |
| `[OSS-CSWIN32]` | [`microsoft/CsWin32`](https://github.com/microsoft/CsWin32); [`src`](https://github.com/microsoft/CsWin32/tree/e4a7320acd0c62f7490efd4c34421c181212dd8d/src); [`test`](https://github.com/microsoft/CsWin32/tree/e4a7320acd0c62f7490efd4c34421c181212dd8d/test); [`integration-tests`](https://github.com/microsoft/CsWin32/tree/e4a7320acd0c62f7490efd4c34421c181212dd8d/integration-tests); [`CodeQL.yml`](https://github.com/microsoft/CsWin32/blob/e4a7320acd0c62f7490efd4c34421c181212dd8d/.github/workflows/CodeQL.yml) | Tag `v0.3.298`, released 22 June 2026; commit `e4a7320acd0c62f7490efd4c34421c181212dd8d`; MIT | Active typed Win32 source generation with tests/security policy/CodeQL; reduces signature and structure transcription risk | Build-time generator only; pinned/locked/API-allowlisted/generated-diff-reviewed dependency candidate, never a substitute for Windows security-semantic review |

## 15.7 Source sufficiency and conflicts

No reviewed primary source materially contradicts the accepted three-context baseline. The sources support the availability of the selected Windows primitives, but **none proves their UAM-specific composition**. In particular:

- Microsoft documentation recommends a logon SID for terminal-session pipe isolation, but does not prove UAM's bootstrap/handoff protocol, process-DACL construction, same-SID handle isolation, or hostile resource bounds.
- `LocalService` is described as low privilege, yet its default token includes privileges prohibited by this design; this is why required-privilege configuration plus effective-token evidence is mandatory rather than a baseline change.
- `CreateRestrictedToken`, low integrity, jobs, mitigations, and firewall policy improve containment but do not make fixed collector code an untrusted-code sandbox or remove same-user reads.
- Open-source implementations demonstrate engineering patterns and edge cases, not authorization to copy their ACLs, impersonation, broker, updater, plugin, or task surfaces.

Therefore, the correct evidence status is **documented capability plus proposed UAM composition**, with the exact CLI/lab experiments in Sections 8 and 11 as the falsifying gate.

# 16. Confidence table for major conclusions

## 16.1 Conclusion-by-conclusion confidence

Confidence describes the evidence quality for the stated conclusion, not the severity of failure and not a probability. A documented Windows feature can be **High** confidence while UAM's composition of that feature remains **Medium** or **Low** until the hostile gate runs.

| Major conclusion | Evidence label and confidence | Why this confidence is justified | Evidence that would change the conclusion or confidence |
| --- | --- | --- | --- |
| The accepted **Coordinator + one User Host per eligible interactive session + short-lived Task Host** split is the correct G1 architecture | **FACT / RECOMMENDATION — High** | It is an accepted project baseline, directly addresses the legacy monolith's privilege/profile coupling, and maps cleanly to mature Windows process/token/session boundaries. [INT-BASE] [INT-LEGACY] [INT-GATES] | New primary evidence that an approved Windows/session environment cannot sustain the split, or that a required source cannot be read/minimized inside the user session. That would require an explicit baseline change proposal, not a silent merge of contexts. |
| The Coordinator should run as **`LocalService` with a restricted service SID and SCM required-privilege list containing only `SeChangeNotifyPrivilege` for G1** | **RECOMMENDATION — Medium** | Microsoft documents the account, service SID, and privilege-reduction mechanisms. The proposal removes default impersonation/create-global privileges and avoids network identity. Exact filesystem, process/token-query, SQLite, EDR, and policy interactions are untested. [MS-SVC-01..04] | Effective token contains a prohibited privilege after reboot; required operations fail without another privilege; restricted service SID prevents the narrow ACL design; or estate policy rewrites service configuration. The smallest failing operation must drive ADR-G1-002. |
| The Coordinator can satisfy G1 **without user profile access or user-token creation** | **RECOMMENDATION / CLI EXPERIMENT — Medium** | Responsibilities and allowed dependencies make those operations unnecessary; service access can be restricted to machine-owned release/config/store and User Host process/token query handles. | ProcMon/ETW shows any access below a real/synthetic user profile, user hive, browser source, or profile-loading API; code review finds `LogonUser`, `WTSQueryUserToken`, profile loading, impersonation, or user-path discovery. Any occurrence fails G1. |
| An MSI-owned **INTERACTIVE group Scheduled Task at least privilege** can launch an ordinary-token launcher in every eligible session without credentials | **RECOMMENDATION — Medium** | Task Scheduler documents group activation and existing interactive-token behavior; the design requires token-shape verification and uses no stored password/S4U/elevation. [MS-TASK-01] | Task does not start in a supported session; token is elevated/new/S4U rather than the existing ordinary token; GPO blocks/rewrites the principal, trigger, run level, task DACL, or multi-instance behavior; same-account sessions are collapsed. |
| A small launcher should create the real User Host **suspended with explicit process/thread/token DACLs before any secret exists** | **RECOMMENDATION — Medium** | It removes a post-start self-hardening race and permits exact logon-SID/service-SID query rights with `OWNER RIGHTS` constrained. Windows securable-object/SID primitives support the construction. [MS-SID-01] [MS-TOKEN-01] | AccessCheck/handle-theft tests show a same-SID process from another logon can open prohibited rights, the service cannot query required fields, EDR changes object security, or runtime startup requires broad owner/admin rights. |
| The protected User Host object design prevents **same-account, different-logon-session handle theft** | **CLI EXPERIMENT — Low until proved** | The exact logon SID should distinguish logons and the pre-start DACL plus `OWNER RIGHTS` is a reasoned defense, but same user SID ownership, privilege, object-manager behavior, launch races, and security products create material uncertainty. | 10,000 same-SID/different-logon attempts across process, thread, token, duplication, synchronization, debug, VM read/write, terminate, set-information, and DACL-change rights produce zero prohibited handles on every supported environment. A clean independent review could raise confidence; any success rejects this mechanism. |
| Coordinator reconciliation plus task triggers can implement console, lock, fast switch, RDP connect/disconnect/reconnect, logoff, and duplicate cleanup without cross-session reuse | **RECOMMENDATION — Medium** | WTS and Task Scheduler expose the necessary observations/triggers, and generation/state machines address races rather than relying on one event source. [MS-TASK-01] [MS-WTS-01] | Lifecycle matrix shows missing/duplicated/stale Hosts, incorrect drain on lock/disconnect, wrong session binding, logoff survivors, or unsupported RDS/VDI behavior after policy refresh/restart/sleep. |
| A **two-stage named-pipe protocol**—small bootstrap then random exact-logon-SID dedicated pipe—is the simplest defensible local IPC choice | **RECOMMENDATION — Medium** | Windows supplies local pipe ACLs, logon-SID restriction, first-instance/local-only flags, peer PID/session APIs, cancellation, and asynchronous I/O. The second pipe narrows the broad bootstrap exposure and prevents predictable per-session object names. [MS-PIPE-01..03] | One cross-session handoff or application message is accepted; a hostile process squats either pipe, reuses a suffix, steals/duplicates the handoff, or forces unbounded bootstrap work; an approved platform lacks reliable semantics. Then evaluate authenticated ALPC/RPC or another local transport through an ADR. |
| Pipe ACLs are **necessary but not sufficient**; identity must be bound to held kernel objects and authenticated release images, never payload fields | **INFERENCE / RECOMMENDATION — High for principle, Medium for implementation** | PID/session APIs and token/process queries are documented, while PID reuse and caller-controlled identity are obvious composition risks. Holding the process handle and creation time closes PID reuse; token/logon/session/image checks provide independent evidence. [MS-PIPE-03] [MS-TOKEN-01] [MS-CODE-01] | API access is unreliable under supported policy/EDR; file identity/signature has a TOCTOU/reparse bypass; fake process/server passes the tuple; or false rejection is operationally unacceptable. |
| The User Host must perform **mutual server validation** against SCM-reported Coordinator PID/session/image before sending a handoff or minimized data | **RECOMMENDATION — Medium** | It contains fake-server/pipe-squatting attacks and prevents an interactive attacker from collecting handoff secrets merely by owning a pipe name. Windows exposes server PID/session and SCM status; image trust is available. | Hostile fake-server campaigns, SCM PID rollover, upgrade races, or signature/file-replacement tests bypass or permanently wedge validation. |
| Fresh nonces, one-use handoff secret, **HKDF-SHA-256**, direction-specific keys, fixed transcript and per-frame **HMAC-SHA-256** provide connection integrity/replay defense after Windows peer authorization | **RECOMMENDATION — Medium** | HKDF/HMAC are standardized and the design avoids a long-lived machine/user shared secret. Strict sequence and connection ID make exact replay detectable. [RFC-5869] [RFC-2104] | Cryptographic review finds key separation/transcript ambiguity, secret exposure/zeroization problem, parser/MAC-order flaw, timing/oracle issue, nonce reuse, or a replay accepted after reconnect/crash. |
| A fixed **88-byte little-endian header plus deterministic CBOR closed schemas** is preferable to JSON/gRPC/general serialization | **RECOMMENDATION — Medium** | It gives an inspectable bounded parser, stable golden vectors, version fields, exact lengths/sequences, and no network framework. RFC 8949 supports deterministic encoding. | Fuzzing finds ambiguous/non-canonical encodings, parser allocation/stack risk, incompatible evolution, or measured implementation cost exceeds a similarly bounded alternative. Protocol changes require new golden vectors and an ADR. |
| The proposed bootstrap/frame sizes, deadlines, queue/rate limits, and one-ready-channel rule are safe **proof defaults**, not production budgets | **ESTIMATE — Low for exact numbers; High for need to bound** | Every attacker-controlled allocation, timer, instance, work item and log must be bounded, but no representative endpoint/resource distribution exists. | G1 measurements show caps are too high to contain impact or too low for valid traffic; resource-budget owner approves different values with the same boundedness fitness functions. |
| Task Host should use a **fixed compiled mode, own restricted low-integrity token, explicit inherited handles, pre-resume one-process Job, mitigations, scratch DACL, and executable firewall block** | **RECOMMENDATION — Medium** | Windows and Chromium document complementary confinement layers. Fixed modes avoid turning the process boundary into an arbitrary endpoint code channel. [MS-TOKEN-02] [MS-JOB-01..03] [MS-MIC-01] [MS-FW-01] [OSS-CHROMIUM] | Launch requires prohibited privileges; runtime/JIT fails; extra handle appears; child/orphan survives; write escapes scratch; network succeeds; job/mitigation conflicts with supported platform or EDR; fixed source capability cannot operate. |
| `WRITE_RESTRICTED` plus a unique run SID is a useful **prototype**, not an accepted final token recipe until access checks run | **CLI EXPERIMENT — Low** | The flag changes restricting-SID evaluation for writes and may preserve required reads, but exact Windows ACL interactions are subtle and collector needs are not yet known. | AccessCheck and real file/process tests establish the minimal token recipe across supported platforms, or show it grants too much/too little. The final recipe must be generated and asserted, not inferred from flags. |
| A restricted low-integrity Task Host is **not a complete same-user read sandbox** | **FACT / residual-risk conclusion — High** | Restricted tokens and MIC chiefly reduce privileges/SID grants/writes; low integrity still permits many reads, and Chromium documents the need for stronger capability/broker designs for hostile code. [MS-TOKEN-02] [MS-MIC-01] [OSS-CHROMIUM] | Only a threat-model change plus a proven stronger architecture—such as AppContainer with brokered pre-opened handles and no internet capability—would change the containment claim. |
| Closing the User Host's Job handle can provide deterministic **Task Host kill-tree behavior** | **RECOMMENDATION — Medium** | Job kill-on-close and process-limit mechanisms are documented, and pre-resume job assignment removes the normal child-before-assignment race. [MS-JOB-01..03] | Descendant escapes through breakaway/nested job/COM/broker, survives Host crash/logoff/uninstall, or EDR/runtime causes assignment failure. All such cases fail P5/E14. |
| Task Host network prohibition requires both **token/process design and effective firewall/egress testing**; a configured rule is not proof | **INFERENCE — High** | Low integrity/restricted token does not guarantee no sockets, and local firewall rules can be overridden. [MS-MIC-01] [MS-FW-01] [OSS-CHROMIUM] | A stronger platform boundary with measured deny semantics is adopted. In current design, any successful DNS, TCP, UDP, loopback broker, proxy, or inherited-socket path is failure. |
| Only minimized typed pages cross User Host→Coordinator; Coordinator **commits event plus progress atomically and ACKs after commit** | **Accepted invariant / RECOMMENDATION — High for rule, Medium for code** | It follows the accepted privacy and cursor durability invariants and makes retries safe. [INT-BASE] [INT-GATES] | Failpoint campaign finds cursor-ahead, precommit ACK, raw value in IPC/store/diagnostics, or duplicate final business effect. Any result stops dependent source work. |
| Stable page/run/event identities and exact retry can make the local business effect **idempotent under ACK loss** | **RECOMMENDATION — Medium** | The closed contract and single-writer transaction can detect an exact repeat and return the prior commit outcome; no central behavior is required for the G1 synthetic proof. | Crash/restart/fuzz tests produce duplicate durable events, different outcomes for identical identity/content, or acceptance of identity reuse with different content. |
| MSI/enterprise deployment should own signed files, service, task, ACLs and firewall; current plus one rollback release provides a recoverable privileged boundary | **Accepted input / RECOMMENDATION — Medium** | Matches baseline, avoids a permanent updater privilege surface, and side-by-side immutable releases allow bounded rollback. | Installer cannot apply/verify exact state in estate tooling; rollback crosses an incompatible schema/protocol; unauthorized/stale/downgraded release executes; cleanup mutates neighboring data. |
| Runtime components should fail closed on privileged drift and may repair only unprivileged volatile state | **RECOMMENDATION — Medium** | Prevents compromised low-privilege runtime code from broadening its own service/task/firewall/ACL boundary. MSI repair provides an auditable privileged path. | Operational evidence shows excessive unrecoverable gaps and a separately authorized narrow repair mechanism can be proved without widening the attack surface. |
| Release ceiling, realm binding, tenant policy and emergency flags should form a **monotone narrowing configuration lattice** | **Accepted principle / RECOMMENDATION — Medium** | It enforces the product privacy ceiling offline and prevents a tenant or payload from widening source/field/destination/capability authority. [INT-BASE] | Signature/rollback/merge tests find a widening path, realm migration requires a different state model, or governance approves another formally verified mechanism. |
| Endpoint realm/session/device identity must not be accepted from User Host payloads | **RECOMMENDATION — High** | The Coordinator owns installation/realm state and derives peer session identity from Windows; accepting payload claims would create a confused-deputy and cross-realm path. | Only an explicit enrollment/realm-migration protocol with independently authenticated authority could alter this rule. |
| Privacy-safe observability should use closed categorical events and bounded cardinality, with no SID, user, session, PID, pipe suffix, source value, path, URL, title, token, nonce, secret or raw exception text | **RECOMMENDATION — Medium** | This prevents diagnostics from becoming a parallel activity/identity store and contains malformed-client log amplification. | G1 support incidents cannot be diagnosed from the allowed evidence; privacy owner approves a narrowly expanded schema with retention/access/audit controls and canary tests. Raw source values remain prohibited. |
| Metric series/rate caps and support-bundle allowlists are security controls, not operational polish | **INFERENCE — High** | Attacker-controlled identity/error labels and unbounded event streams can create memory, cost, privacy, and disk DoS even when IPC rejects messages. | A different telemetry design provides equivalent closed-cardinality and bounded-rate proof. |
| **.NET 10 LTS** is the correct implementation baseline as of 31 July 2026, with the exact current supported patch selected at release | **FACT / RECOMMENDATION — High for point-in-time lifecycle, Medium for deployment fit** | Official policy lists .NET 10 as active LTS through November 2028 and the current SDK/runtime releases are available. [MS-DOTNET-01] [MS-DOTNET-02] | Supported Windows matrix, self-contained servicing burden, enterprise patch policy, or a later release date changes the lifecycle choice. Re-check at every release. |
| **CsWin32** is acceptable only as a pinned build-time generator with an API allowlist and reviewed generated diff | **RECOMMENDATION — Medium** | It is current, tested, permissively licensed, and reduces signature transcription errors, but it does not understand UAM security semantics. [OSS-CSWIN32] | Package provenance/maintenance/security degrades; generated output is unstable or too broad; locked offline builds fail; manual interop proves lower total risk. |
| Tailscale, `go-winio`, PowerToys, TaskScheduler, and Chromium are **reference only** for G1 | **RECOMMENDATION — High** | Their languages, scope, privilege surfaces, and threat models differ materially; importing them would not remove UAM's security responsibility and would increase review/maintenance surface. §14 | A dependency-specific ADR demonstrates exact fit, current maintenance/security, narrow API surface, testing, license/provenance, and lower total lifecycle risk. |
| The hostile impact thresholds in §8—post-campaign baseline `+10` handles, `+2` threads, `+16 MiB` private bytes; bounded peak deltas—are appropriate initial **falsifying estimates** | **ESTIMATE — Low** | They provide an objective stop condition before a human resource budget exists, but are not derived from fleet measurements or an approved SLO. | Repeatable baseline/noise distributions on representative environments and an accountable resource-budget decision. Thresholds may change only before the campaign, not after observing a failure. |
| The exact **10,000 cross-session and 10,000 malformed-client campaigns** are sufficient to pass G1's named assertion | **RECOMMENDATION — Medium** | They give repeated race/resource exposure and deterministic evidence across required attack classes; combined with fuzzing, lifecycle, failpoints, ACL/token/ProcMon evidence, they are materially stronger than happy-path tests. | Statistical/race analysis or an observed rare failure shows more iterations/interleavings are needed; supported platform count increases; independent review adds cases. Passing never proves absence of all bugs. |
| Supported Windows/session environments can be named from research alone | **UNKNOWN / HUMAN DECISION — Low; not decided** | The lab summary proves no OS/session capability, and support entails operational commitment beyond API minimum versions. [INT-LAB] | Human owner chooses candidate client/server/RDS/VDI environments and each passes inventory, lifecycle, policy and hostile G1 evidence. |
| Enterprise Scheduled Task/service/firewall policy will permit the design | **UNKNOWN / HUMAN DECISION — Low** | GPO, MDM, EDR, firewall merge, task hardening, service rights and code-signing controls are unknown and can materially change behavior. | Representative policy-ring exports and effective runtime tests, plus accountable enterprise endpoint-management acceptance. |
| The proposed process/resource limits fit acceptable endpoint overhead | **UNKNOWN / HUMAN DECISION — Low** | No approved resource budget or representative distribution exists. | Measured idle/active/hostile distributions plus a documented owner decision and operational alert/support thresholds. |
| The organization has the skills, on-call model, repair authority and release discipline to operate this boundary | **UNKNOWN / HUMAN DECISION — Low** | The design requires uncommon Windows security/interop/MSI/fuzz/support skills, and no ownership/staffing/budget evidence was supplied. | Named accountable functions, trained maintainers, runbook exercises, package/signing/rollback custody, incident drill, and approved support model. |
| Legal purpose, prohibited uses, exact identity/time precision, source fields, retention, access and employee consultation can be decided by this report | **HUMAN DECISION — Low; explicitly out of scope** | Those are legal, policy, governance, and business authorities reserved by the baseline. Technical minimization cannot confer purpose or approval. [INT-BASE] [INT-RULES] | Formal human decisions with recorded authority, scope, review date, and product/privacy-ceiling update. G1 must remain synthetic until permitted. |
| Passing G1 proves the endpoint is generally secure or ready for production | **REJECTED — High confidence in rejection** | G1 proves only the named Windows session/token/IPC/fault-containment assertion on tested configurations. It does not prove Edge acquisition, cursor semantics, privacy transformation, outbox durability, release authorization, network identity, server custody/idempotency, scale, deletion, restore, legal approval, or operations. [INT-GATES] | Nothing turns G1 alone into production approval; subsequent gates and human approvals remain mandatory. |

## 16.2 What remains unsafe by design

The following risks remain outside, or deliberately weaker than, the G1 boundary:

- A local administrator, kernel-mode attacker, hypervisor compromise, security product with equivalent rights, or compromised trusted installer/signing path can inspect or alter endpoint processes, tokens, memory, files, IPC, firewall, or releases.
- Malicious code already running in the **same logon session** may share the accepted privacy boundary, race User Host resources, inject through allowed same-user mechanisms, or operate with the user's readable files. The process/token DACL and mutual pipe validation reduce specific attacks; they do not make the session trustworthy.
- The restricted Task Host is a **fault, write, child-process, resource, and network containment boundary**, not an untrusted-code confidentiality sandbox. It can retain same-user read access unless a later AppContainer/brokered-handle design is separately authorized and proved.
- A signed executable or package can still contain a logic flaw or supply-chain compromise. Signature verification establishes an authorization/provenance input, not correctness.
- Local firewall policy may be overridden or bypassed by an allowed broker, proxy, inherited handle, kernel component, or enterprise setting. Only effective egress tests establish the supported configuration.
- At-least-once local transfer and commit-before-ACK contain crash/retry ambiguity, but later central ingestion/receipt/materialization/idempotency behavior remains outside G1.

## 16.3 What remains uncertain until CLI/lab evidence

**UNKNOWN / CLI EXPERIMENT:** research cannot establish these composition claims:

- effective service privilege list after installation, reboot, policy refresh and EDR injection;
- service's actual filesystem/registry/certificate/profile access;
- group-task token type/elevation/authentication LUID and per-session behavior;
- exact User Host process/thread/token DACL behavior, particularly same-account/different-logon handle theft;
- pipe namespace squatting, client/server PID validation, process creation-time binding, signature/file-identity checks, handoff secrecy, reconnect/replay, cancellation and malformed-client resource behavior;
- Task Host launch under the restricted token, .NET/native compatibility, inherited handle set, job membership/descendants, mitigation state, write surface, network denial, cancellation and cleanup;
- crash-point atomicity, ACK loss retry, exact-page idempotency and privacy-canary absence;
- behavior after sleep/resume, fast switch, RDP/RDS disconnect/reconnect, task/service restart, upgrade/rollback/repair/uninstall and policy refresh;
- representative idle/active/hostile CPU, memory, handles, threads, pipe/nonpaged-pool effects, disk/log volume and support burden.

A unit test, source review, API documentation, installer success code, task registration success, firewall-rule existence, or one happy-path session does not settle any item above.

## 16.4 What remains operationally costly

Even though the runtime primitives and reviewed licenses do not add a per-endpoint license fee, the design has material lifecycle cost:

- MSI authoring, signing custody, protected current/rollback release storage, deterministic repair, schema/protocol compatibility, and exact uninstall disposition;
- specialist Windows token/SID/DACL/SCM/Task Scheduler/WTS/pipe/job/WFP and .NET `SafeHandle` interop review;
- representative GPO/MDM/EDR/firewall/task/service policy rings and repeated testing after Windows, .NET, EDR, deployment-tool, or policy changes;
- continuous parser fuzzing, hostile/race/failpoint campaigns, SBOM/package/license/provenance handling, and security advisory response;
- privacy-safe but useful diagnostics, bounded support bundles, accessible operator tools, incident triage, repair/reboot/rollback authorization, and monitoring-gap communication;
- support for concurrency and lifecycle combinations, especially same-account sessions, RDS/VDI/FSLogix/Citrix, and long-lived disconnected sessions if humans place them in scope.

Those costs are not reasons to weaken the boundary silently. They are inputs to the human support, budget, resource and supported-platform decisions.

## 16.5 What remains dependent on humans

The following must have an accountable organizational function and recorded approval before fleet use:

1. **Supported Windows/session environments:** options include a narrow Windows client console/RDP subset, broader client/server/RDS, or VDI/Citrix/FSLogix support. The conservative temporary default is **no declared support beyond the exact approved G1 lab configurations**. The endpoint product/support owner must decide after evidence.
2. **Enterprise Scheduled Task/service/firewall constraints:** options are accept the proposed machine task/service/rules, provide an equivalent enterprise-managed registration, or declare the design incompatible. The conservative default is fail closed and report `UnsupportedEnvironment`/boundary mismatch; never elevate or create tokens as fallback. Enterprise endpoint management/security owns the decision.
3. **Resource budget and support model:** options range from narrow synthetic pilot caps with business-hours support to broader fleet/on-call commitments. The conservative default is the proof caps and crash-loop/kill switches in this report, with no claim that they meet production SLOs. Product operations/endpoint engineering owns the budget and support commitment.
4. Purpose, prohibited uses, exact fields/identity/time precision, retention/access, employee consultation, incident authority, signing/release custody, rollback approval, and production deployment remain the accountable legal/privacy/security/product/operations decisions identified by the organization. This report does not invent names or approval.

## 16.6 What research alone cannot prove

Research can define a falsifiable architecture and find contradictions in primary sources. It cannot prove:

- absence of implementation defects, races, native memory/lifetime bugs, parser bugs, privilege drift, malicious dependencies, or future Windows/.NET regressions;
- behavior under the organization's actual GPO/MDM/EDR/firewall/identity/session/deployment stack without executing there;
- fleet capacity, reliability, supportability, incident response competence, rollback/restore performance, or user impact without measurement and drills;
- legal necessity/proportionality, employee expectations, permitted purpose, approved fields, access/retention, or production authority;
- security against administrators/kernel compromise or confidentiality from arbitrary same-user code with the chosen Task Host boundary.

The correct response to those limits is not an unbounded claim. It is the exact evidence campaign, explicit exclusions, contained failure modes, and stop/go authority below.

## 16.7 Residual risk and explicit next stop/go gate

**Residual risk summary:** the proposed design contains privilege, session, IPC, parser, task-process, write/network, retry, release and diagnostic failures more effectively than the legacy monolith, but remains exposed to privileged compromise, same-session hostility, same-user-readable data in Task Hosts, enterprise policy variability, unsupported session products, signing/supply-chain failure, runtime bugs, and human/operational error. Same-account/different-logon process-object isolation is the highest unresolved local identity risk. Task Host network denial and zero-privilege launch are the highest unresolved confinement risks. Exact resource thresholds and supported environments are unapproved.

**Next gate — execute G1, using synthetic data only:**

> **Zero cross-session accepted messages; no profile access by the service; no prohibited privileges; bounded hostile-client impact.**

`STOP` immediately and open the affected ADR/change proposal when any one of these occurs:

- one cross-session, wrong-logon, replay, fake-server, fake-client, PID-reuse, pipe-squat, malformed or unauthorized application message is accepted;
- the Coordinator reads or enumerates any user profile/source/hive, creates/acquires a user token, impersonates a pipe client, or holds a prohibited effective privilege;
- another logon session obtains a prohibited User Host process/thread/token handle;
- a Task Host obtains an unapproved handle/path/write/network capability, creates or leaves a descendant/orphan, runs an arbitrary mode/path/script/assembly, or requires a prohibited privilege fallback;
- cursor advances before its minimized events commit, ACK precedes commit, retry creates a second business effect, or any forbidden canary enters IPC/storage/log/metric/evidence;
- hostile clients cause a crash, hang, starvation, unbounded restart, unbounded allocation/timer/log/cardinality growth, or exceed the predeclared resource criteria;
- install, reboot, policy refresh, repair, upgrade, rollback, shutdown, logoff or uninstall leaves an unauthorized release, broadened ACL, stale task/host/job/firewall rule, or alters a neighboring canary.

A failure creates an ADR change record containing the affected decision and invariant, new evidence, impact, smallest falsifying re-test, security/privacy and migration consequences, and proposed status. **Do not** compensate by giving the service more privilege, creating user tokens, broadening pipe/task/file ACLs, enabling arbitrary plugins, dropping peer checks, logging raw values, or treating an unsupported environment as passed.

`GO` to G2 only after all of the following are true:

1. the complete Sections 8 and 11 campaign passes on **every environment proposed for support**, including the 10,000 cross-session, 10,000 malformed/slow/replay, and applicable 10,000 same-SID handle attempts;
2. an independent security/native/installer/privacy review closes all boundary-critical findings;
3. the evidence bundle is sanitized, complete, reproducible, hashed, retains every failure/blocked/unknown result, and cleanup verification passes;
4. ADR-G1-001 through ADR-G1-015 have accepted or explicitly deferred statuses with owners and review triggers;
5. humans record the supported Windows/session set, enterprise task/service/firewall policy compatibility, resource budget, support/incident model, signing/release custody, and permission to proceed with the synthetic first source slice.

A G1 pass authorizes only the next proof gate. It does not authorize production collection, real activity data, broad platform support, or a claim that endpoint telemetry is complete or forensic truth.
