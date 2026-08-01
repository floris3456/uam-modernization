# Prompt 12 result — device enrollment, certificates, TPM, cloning, revocation, enterprise network compatibility, and realm identity

**Result path:** `results/batch-03-durability-release-identity/12-device-identity-network-result.md`  
**Research date:** 31 July 2026  
**Decision status:** **RECOMMENDATION — ACCEPT FOR IMPLEMENTATION PROTOTYPES WITH MANDATORY G7/GATE-8 CONDITIONS; PRODUCTION PKI, REALM, ASSURANCE-EXCEPTION, CERTIFICATE-LIFETIME, CUSTOMER-NETWORK, VDI, AND DEPLOYMENT AUTHORITY REMAIN OPEN**  
**Authority boundary:** device bootstrap, per-installation identity, Windows key assurance, certificate lifecycle, realm derivation, clone handling, revocation, gateway trust, proxy/VPN/TLS-inspection compatibility, PKI operations, and laboratory proof; **not** enterprise CA/MDM ownership, realm definition, allowed lower-assurance exceptions, certificate lifetime, legal purpose, retention, access, budget, staffing, SLO/RPO/RTO, pilot, or production approval  
**Primary gate:** **Cloned, revoked, expired, unknown, or wrong-realm identities fail closed without a shared secret workaround.**  
**Gate naming note:** this result calls its laboratory campaign **G7** because the topic prompt requires a “G7 lab plan.” In the accepted project-wide proof order, release/update authorization precedes device identity, so this is the eighth global proof gate. The implementation evidence identifier should therefore record both names: `G7-DEVICE-IDENTITY` and `GLOBAL-GATE-08`.

## Evidence vocabulary

This result uses the required labels:

- **FACT** — directly supported by an allowlisted supplied file or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from stated facts; the chain is given.
- **ESTIMATE** — a numerical hypothesis with replaceable inputs.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, business, support, or production authority is required.
- **CLI EXPERIMENT** — code, lab work, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements form the proposed implementation baseline for this topic. They do not convert a **HUMAN DECISION** into approval or a documented platform capability into UAM fitness.

---

# 1. Executive conclusion in easy language, confidence, and residual risk

## 1.1 Conclusion

**RECOMMENDATION.** Give every installed UAM endpoint its own cryptographic installation identity. The endpoint generates the private key locally; the key never appears in an enrollment package, golden image, support bundle, log, database, or administrator evidence. A one-use, short-lived bootstrap authorization permits exactly one enrollment into exactly one server-assigned realm. The resulting client certificate maps on the server to one installation, one enrollment epoch, one assurance level, and one realm.

The preferred Windows assurance is a key created by the **Microsoft Platform Crypto Provider** and protected by a TPM. A provider name alone is not enough to claim TPM assurance: the laboratory must prove the key can sign a fresh challenge, inspect the effective CNG provider properties, and—where the enterprise PKI supports it—validate TPM key attestation. A software key is a lower-assurance exception, not an automatic fallback. It is permitted only after an accountable human decision, is marked in every server authorization context, and can be disabled independently.

Normal upload and control traffic SHOULD use direct end-to-end mTLS to the UAM ingestion boundary. TLS pass-through is equally acceptable when an L4 load balancer is needed. L7 gateway termination is permitted only when the gateway validates the client certificate, strips all client-supplied identity headers, authenticates itself to the backend with mTLS, and sends a short-lived integrity-protected assertion that binds the validated credential to the exact request. A plain `X-Forwarded-Client-Cert`, certificate subject, body `realmId`, hostname, Windows SID, `MachineGuid`, IP address, or cache key is never identity authority.

Revocation cannot rely on CRL or OCSP publication alone. The ingress path MUST perform a current server-side status lookup, or a bounded-freshness deny cache lookup, for every request authorization. This is necessary because revocation information is cached and because an already-established HTTP/2 connection can survive a status change. A status change to `DENIED`, `REVOKED`, `SUSPENDED`, `EXPIRED`, `DECOMMISSIONED`, or `DUPLICATE_HOLD` stops new authorization immediately within the declared deny-cache freshness bound and closes the connection where the server/gateway can do so safely.

Golden images MUST be captured before enrollment. A golden image contains the signed UAM binaries and an unconfigured enrollment state, but no installation ID, realm assignment, bootstrap authorization, client certificate, private key, outbox, cursor, endpoint database, or prior support evidence. A post-enrollment clone is treated as a security incident. Simultaneous or overlapping use of one certificate/key by two installations puts the credential in `DUPLICATE_HOLD`; the server does not guess which copy is legitimate. Nonpersistent pooled VDI is initially unsupported. A future VDI profile may enroll a new ephemeral installation after specialization on every boot, but it may not share a cloned certificate or durable backlog.

Ownership transfer between realms is not an in-place field edit. The old realm decommissions the old installation and certificate, the endpoint removes old realm-bound state under enterprise management, and a new enrollment creates a new installation ID, key, credential, enrollment epoch, and realm binding. Historical data migration or reassignment is a separate governed server-side operation.

## 1.2 Immediate architecture verdict

| Decision | Verdict | Why |
|---|---|---|
| Per-installation asymmetric identity | **ACCEPT FOR PROTOTYPE** | Contains a compromise to one installation and supports independent revocation, clone detection, and realm mapping. |
| One-use realm-bound bootstrap authorization | **ACCEPT FOR PROTOTYPE** | Avoids a fleet-wide secret and lets enterprise deployment authorize enrollment without giving the endpoint permanent enrollment authority. |
| TPM-backed key as preferred assurance | **ACCEPT FOR PROTOTYPE** | Windows documents TPM key protection and attestation capability; UAM fitness still needs exact estate proof. |
| Software key fallback | **DISABLED BY DEFAULT; HUMAN EXCEPTION ONLY** | A privileged attacker or image clone has a materially easier extraction/duplication path. |
| Server-derived realm/device authority | **ACCEPT** | Preserves the accepted invariant that body claims cannot establish realm or device authority. |
| Direct mTLS or L4 TLS pass-through | **ACCEPT AS DEFAULT** | Smallest trust path and no identity forwarding header. |
| L7 mTLS termination | **CONDITIONAL** | Requires gateway-to-backend mTLS, header stripping, assertion binding, status freshness, and adversarial proof. |
| CRL/OCSP as sole rapid revocation | **REJECT** | Distribution and caching delay do not meet rapid denylisting; existing connections may persist. |
| Golden image containing active identity | **REJECT** | Produces cloned credentials and indistinguishable installations. |
| Nonpersistent VDI with shared identity | **REJECT** | Breaks per-installation uniqueness, revocation, audit, and offline-state semantics. |
| Shared API key/fleet secret fallback | **REJECT WITHOUT EXCEPTION** | One leak compromises the fleet and destroys per-device revocation and accountability. |
| Certificate-bound OAuth token | **DEFER** | Useful for multi-hop delegation but unnecessary in the initial direct device-to-ingress path. |
| DPoP/HTTP Message Signatures fallback | **DEFER** | A possible future TLS-inspection-compatible asymmetric profile, but it adds replay, clock, canonicalization, and gateway complexity. |

## 1.3 Confidence

- **High confidence** in the identity model, server-derived realm authority, no-shared-secret rule, pre-enrollment golden-image rule, duplicate hold, and rapid server-side deny status. These follow directly from the accepted realm/release invariants and standard PKI threat containment.
- **Medium confidence** in the exact Windows TPM/CNG, certificate issuance, renewal, and mTLS composition. Microsoft documents the primitives, but the permitted laboratory evidence says the TPM, OS build, domain state, PKI, proxy, VPN, EDR, and virtualization environment are still unknown.
- **Medium confidence** that direct mTLS and explicit proxy CONNECT cover the simplest enterprise networks. Actual customer proxies, PAC/WPAD, authentication, VPN route changes, and TLS inspection can differ materially.
- **Low confidence** in universal VDI/vTPM support, software-key exception coverage, and automatic CA/MDM integration. Those depend on the selected virtualization platform, image lifecycle, enterprise trust model, and owner decisions.

## 1.4 Residual risk in plain language

A TPM does not make the endpoint trustworthy. A local administrator, kernel compromise, malicious update, hypervisor operator, CA compromise, gateway compromise, or enterprise-management mistake can still misuse a legitimate key or authorize the wrong installation. TPM attestation can prove properties of a key and TPM trust chain; it does not prove that UAM is correctly installed, that the operating system is uncompromised, or that a person should be monitored.

A cloned software key may be used sequentially from two devices and evade simple concurrency detection. A copied vTPM may preserve a key depending on virtualization controls. CRL, OCSP, deny caches, and clocks can be stale or unavailable. TLS inspection can prevent origin mTLS. Fail-closed behavior can create a long outage and local backlog. A lost offline device cannot be forced to erase its key. A passing synthetic test proves only the named build, issuer, gateway, proxy, VPN, TPM/vTPM profile, and network path.

The containment strategy is to make every identity narrow and replaceable; bind it to one installation, epoch, realm, and assurance; deny on ambiguity; retain unacknowledged minimized data rather than weaken authentication; keep bootstrap and recovery paths one-use; separate issuance from UAM authorization; and require recurring lab and customer-network evidence.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 Scope

This result covers:

1. initial bootstrap enrollment and proof of possession;
2. UAM-owned device, installation, enrollment-epoch, credential, and realm identifiers;
3. Windows CNG key creation, TPM-backed assurance, software fallback, and optional attestation;
4. certificate profile, issuance, activation, selection, renewal, overlap, retirement, expiry, and destruction;
5. rapid denylisting, PKI revocation, status-cache behavior, lost/offline devices, and support diagnostics;
6. golden images, physical/VM clones, persistent and nonpersistent VDI, vTPM, duplicate detection, decommission, and ownership transfer;
7. direct mTLS, L4 pass-through, L7 termination, gateway assertions, header stripping, certificate-bound tokens, and future application proof of possession;
8. explicit proxy, CONNECT, PAC/WPAD, proxy authentication, VPN changes, TLS inspection, hostname trust, and network compatibility;
9. server-derived realm authority and isolation in transport, cache, API, database, audit, diagnostics, and recovery planes;
10. threat modeling, error taxonomy, privacy-safe observability, feature flags, kill switches, incident response, ownership, runbooks, cost/skills/operations, tests, CLI evidence, ADRs, and implementation backlog.

## 2.2 Non-goals

This result does not:

- select or approve the enterprise CA, MDM, PKI owner, or certificate-management vendor;
- define the business or legal meaning of a realm;
- approve software-key or other lower-assurance exceptions;
- choose a production certificate lifetime, renewal window, offline grace period, or support promise;
- approve production TPM attestation, EK collection, measured boot, Device Health Attestation, or a hardware inventory;
- make TPM endorsement keys, serials, firmware versions, hostnames, SIDs, IP addresses, MAC addresses, directory objects, or hardware hashes into UAM identity;
- redesign the accepted Coordinator/User Host/Task Host topology, endpoint outbox, server durable inbox, release system, or privacy transformation;
- authorize production activity, credentials, enrollment, signing, network access, pilot, or deployment;
- claim support for every Windows edition, proxy, VPN, EDR, VDI, vTPM, CA, or gateway;
- prescribe a universal CA algorithm or key size beyond requiring an approved current profile and exact test evidence;
- use raw internal addresses, proxy URIs, SSH configuration, credentials, production identities, private keys, or production activity as research evidence.

## 2.3 Allowlisted supplied evidence

All five allowlisted files were present. No missing-file substitution was required.

| Ref | Allowlisted file | Reviewed local attachment | Size | SHA-256 | Use and limitation |
|---|---|---|---:|---|---|
| I01 | `00-accepted-baseline-attachment.md` | same name | 4,761 bytes | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Accepted topology, privacy, durability, realm, release, restore, and human-authority invariants; not production approval. |
| I02 | `03-sanitized-windows-lab-capability.md` | same name | 1,403 bytes | `8da73d913e7f1b01d943e4c8b0ed7bb2722571ff6a3a20cef0b8f47738a4658f` | Proves only that a sanitized Windows lab connection path exists; no connection or capability proof. |
| I03 | `05-decisions-contradictions-and-gates.md` | same name | 4,047 bytes | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | Accepted decisions and ordered global proof gates. |
| I04 | `06-research-evidence-rules.md` | same name | 2,578 bytes | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | Evidence labels, source quality, confidentiality boundaries, and change-proposal rules. |
| I05 | `batch-01-review-result.md` | `batch-01-review-result(3).md` | 135,455 bytes | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | Accepted predecessor contracts, G1 boundary, policy safety, application/realm identity, repository, release, and Windows evidence gates. |

### 2.3.1 Allowlist conflict

**FACT.** The topic prompt says Prompts 09–14 must consume accepted Batch 1–2 decisions, but its explicit project-file allowlist permits Batch 01 and does not permit `batch-02-review-result.md`.

**RECOMMENDATION.** The explicit file allowlist takes precedence for this research chat. Batch 02 was not opened, searched, quoted, summarized, or used. This result therefore cannot claim full reconciliation with Batch 02.

**STOP GATE.** Before an eventual Batch 03 reviewer accepts or merges this result, that reviewer MUST compare it with the accepted Batch 02 review. Any conflict must be resolved by preserving the stronger accepted invariant or by opening an explicit change proposal. This condition does not weaken the primary device-identity gate.

## 2.4 Accepted inputs preserved

The following are **FACT** from I01, I03, and I05 and remain unchanged:

| ID | Accepted input/invariant |
|---|---|
| A-01 | Windows endpoints use a low-privilege machine Coordinator Service, one ordinary-token User Host per eligible interactive session, and short-lived restricted Task Hosts. |
| A-02 | The Coordinator does not crawl user profiles or create user tokens. |
| A-03 | C#/.NET is the default implementation family; exact versions are execution-time lifecycle inputs. |
| A-04 | A release-authorized product privacy ceiling limits sources, fields, transformations, destinations, diagnostics, and capabilities; tenant policy only narrows it. |
| A-05 | Minimization occurs before Coordinator IPC, durable endpoint storage, logs, diagnostics, or transport. |
| A-06 | Endpoint durable state uses SQLite WAL and one writer; minimized effects and source progress commit atomically. |
| A-07 | Delivery is at least once; stable identities and central uniqueness make the business effect idempotent. |
| A-08 | Upload is bounded, versioned, authenticated, compressed HTTPS; a receipt means durable custody only. |
| A-09 | The server is initially a modular monolith with an ingestion boundary and relational durable inbox; no broker by default. |
| A-10 | MSI and enterprise deployment own the stable privileged boundary; no autonomous updater is assumed. |
| A-11 | Realm/device authority comes from authenticated server context, not payload claims. |
| A-12 | One user, session, realm, or installation cannot submit, view, mutate, or delete as another. |
| A-13 | Unauthorized, incomplete, stale, frozen, or downgraded releases never execute. |
| A-14 | A failed early proof gate stops dependent work; passing proves only the named claim/environment. |
| A-15 | Production PKI, TPM coverage, proxy/VPN, VDI, identity level, retention, budget, SLO/RPO/RTO, ownership, and production approval remain provisional or human-owned. |

## 2.5 Terms and identity separation

| Term | Meaning | Authority and lifecycle |
|---|---|---|
| `realm_id` | UAM-owned immutable identifier for an administratively isolated authority/data boundary | Assigned server-side from an approved enrollment authorization. Meaning is a **HUMAN DECISION**. Never accepted from endpoint body/header/cert text. |
| `device_id` | Optional logical managed-device record that can relate installation histories | Server-side governance object. It does not authenticate a request. May be absent until a CMDB/MDM mapping is approved. |
| `installation_id` | UAM-owned UUIDv7 for one installed/specialized UAM instance | Created once per clean installation/specialization. Never copied into a golden image. Immutable and not reused. |
| `enrollment_epoch` | Monotonic server-controlled integer for destructive re-enrollment of an installation lineage | Increments when credentials/state are reset under approved recovery. Old epochs remain denied. |
| `credential_id` | UAM-owned UUIDv7 for one public-key certificate/key lifecycle | Maps certificate fingerprint/issuer+serial to installation/realm/epoch/assurance/status. |
| `credential_generation` | Monotonic integer within an installation epoch | Increments for a fresh renewal key/certificate. |
| `bootstrap_authorization_id` | UUIDv7 identifier for a one-use enrollment authorization | Token value is random and secret; server stores only a purpose-separated digest. Bound to realm, audience, allowed assurance, expiry, and deployment context. |
| `assurance_level` | Server-asserted result of the proved key profile | One of the finite levels in section 3.7. It is not a free-form endpoint claim. |
| `issuer_id` | Server-owned identifier for an approved issuing chain/profile | Used for rollover and policy; certificate subject/issuer display strings are not authority. |
| `trust_domain_id` | Server-owned identifier for one ingress/gateway trust configuration | Distinct from realm. One trust domain may serve several realms while preserving credential-to-realm mapping. |

**RECOMMENDATION.** Hostname, account name, SID, directory object ID, `MachineGuid`, BIOS/SMBIOS UUID, disk serial, TPM EK, MAC address, IP address, certificate subject, and proxy-supplied header MUST NOT be a UAM primary identity. They may be transient, purpose-limited evidence in a separately governed compatibility or fraud investigation, but they are mutable, privacy-sensitive, cloneable, or owned by another system.

## 2.6 Assumptions

- **ASSUMPTION.** Enterprise deployment can deliver a one-use bootstrap authorization or an equivalent signed enrollment instruction without embedding a permanent shared secret.
- **ASSUMPTION.** The Coordinator can access a machine-scope CNG key whose ACL is limited to the Coordinator service identity and installer/repair authority.
- **ASSUMPTION.** The selected ingestion endpoint or gateway can request, validate, and expose the client certificate to trusted application code.
- **ASSUMPTION.** The server relational store can atomically consume bootstrap authorizations and update credential status/audit.
- **ASSUMPTION.** Enterprise network owners can identify at least one approved route: direct, explicit CONNECT proxy, or a separately governed application-level proof path.
- **ASSUMPTION.** Enrollment and identity state is independent of user/session data and remains in the Coordinator/machine boundary.

## 2.7 Unknowns

- Exact supported Windows editions/builds, TPM versions/vendors/firmware, CNG provider behavior, vTPM platforms, domain/GPO state, EDR/CFA behavior, and machine-key ACL behavior.
- Enterprise CA, MDM, RA, HSM/KMS, revocation, certificate-template, issuance, and support ownership.
- Whether TPM key attestation is required, feasible, or accepted for every production class.
- Exact certificate algorithm, lifetime, renewal window, overlap, chain size, revocation mode, offline policy, and clock tolerance.
- Proxy modes, authentication schemes, PAC/WPAD, TLS inspection, DNS, firewall, VPN split/forced tunnel, gateway, and load balancer behavior at customers.
- Whether persistent or nonpersistent VDI, cloned images, vTPM, Citrix, RDS, FSLogix, or other platforms are in scope.
- Realm definition, transfer semantics, support roles, budget, licensing, staffing, SLO/RPO/RTO, and production risk acceptance.
- Batch 02 compatibility because the accepted Batch 02 review was not in this chat’s allowlist.

---

# 3. Recommended design with exact responsibilities and trust boundaries

## 3.1 Trust-boundary overview

```text
Enterprise deployment / MDM / installer authority
  |  one-use, short-lived, realm-bound bootstrap authorization
  |  no active private key, no fleet secret
  v
Coordinator Service — machine boundary
  |-- Installation Identity Manager
  |     creates UUIDv7 installation_id and CNG key after specialization
  |     proves possession; never exports private key
  |-- Certificate Lifecycle Client
  |     enrolls, activates, renews, rotates, retires
  |-- Network Compatibility Adapter
  |     direct / explicit proxy / tested PAC; no user-browser proxy dependency
  |-- Identity Health / SafetyHold
  |     disables collection or upload under identity failure
  |
  | TLS with server authentication + client certificate
  | (or approved application-level asymmetric PoP in a future profile)
  v
L4 pass-through OR trusted L7 gateway
  |  L7 only: validate mTLS, strip inbound identity headers,
  |  create request-bound signed assertion, mTLS to backend
  v
UAM Identity Boundary / Ingestion Boundary
  |-- certificate-chain and TLS validation
  |-- credential lookup and current status check
  |-- immutable AuthenticatedDeviceContext
  |-- realm/device/installation authority injection
  |-- body/header claim mismatch rejection
  v
Realm-keyed application services, caches, relational inbox, audit

Separate trust plane:
Enrollment API -> Enrollment Coordinator -> CA/RA adapter -> approved issuer
                      |                         |
                      + atomic authorization   + signs certificate only;
                        consumption/audit        does not decide UAM realm authorization
```

## 3.2 Component responsibility table

| Component | Must do | Must not do | Trust boundary |
|---|---|---|---|
| MSI/enterprise deployment | Install signed binaries, service identity, machine ACLs, bootstrap-delivery hook, cleanup/repair; keep image unenrolled | Embed an active client cert/key, permanent enrollment secret, realm data, production token, or prior endpoint DB in image | Privileged installation boundary accepted from Batch 01 |
| Coordinator Installation Identity Manager | Create installation ID after specialization; create/open CNG key; emit CSR/proof; store only key reference and public metadata; enforce state machine | Export private key/PFX, use a user key, reuse image identity, accept realm from tenant policy or payload | Machine service boundary |
| Windows Key Provider Adapter | Create signing key with exact KSP/algorithm/ACL/export policy; inspect effective properties; sign challenge; optionally produce attestation evidence | Infer TPM assurance from provider name alone; weaken to software silently; expose TPM/EK evidence to logs/support | CNG/TPM boundary |
| Enrollment Client | Send bounded enrollment/renewal requests; pin contract version; validate server TLS; activate with issued cert; retry idempotently | Persist plaintext bootstrap token after terminal use; accept certificate without proof/activation; bypass server trust | Bootstrap and PKI boundary |
| Credential Selector | Select only active certificate for exact trust domain/profile; support bounded overlap during renewal | Choose any cert by subject/CN; use expired/denied/unknown cert; fallback to shared secret | Runtime transport boundary |
| Network Compatibility Adapter | Apply approved direct/proxy/PAC profile; preserve server hostname validation; classify finite errors; monitor route changes | Trust interactive user settings implicitly, disable validation, log proxy URI/credentials, add arbitrary proxy bypass | Enterprise network boundary |
| Endpoint SafetyHold/kill switch | Stop new upload and, where policy requires, collection; preserve unacknowledged minimized data; expose finite health | Delete unacknowledged events, self-authorize re-enrollment, or auto-downgrade assurance | Local recovery boundary |
| Enrollment API | Validate one-use authorization, audience, expiry, realm, request limits, proof-of-possession, assurance evidence; reserve idempotently | Trust realm/device from request body; issue against a reusable fleet secret; reveal realm existence in error detail | Unauthenticated-to-enrolled transition |
| Enrollment Coordinator | Own installation/epoch/credential records; consume token; call issuer; persist exact certificate; require activation | Put private key in server; let CA subject text define realm; mark active before proof | Server identity domain |
| CA/RA Adapter | Submit validated CSR/profile; normalize issuer outcomes; retrieve issued public cert/chain; support revoke where available | Let arbitrary endpoint attributes become certificate subject/SAN; make CA availability equal UAM authorization; store endpoint private key | External PKI boundary |
| Certificate Issuer/Enterprise PKI | Verify approved request profile, sign client cert, publish chain/revocation as owned | Decide UAM realm/device status unless explicitly governed; receive activity data | Enterprise PKI authority (**HUMAN DECISION**) |
| mTLS Authentication Middleware | Validate chain/profile/ClientAuth/purpose/validity; identify exact certificate; build sealed context after status lookup | Authorize from body/header/subject alone; cache forever; expose detailed identity errors publicly | TLS-to-application boundary |
| Credential Status Service | Authoritative state/version, rapid denylist, bounded-freshness cache feed, audit | Soft-fail a stale deny cache into allow; let endpoint clear deny; omit realm/epoch from lookup result | Authorization boundary |
| L7 Gateway Adapter | Require client cert; validate chain/status/profile; sanitize headers; authenticate to backend; sign request-bound assertion | Forward untrusted XFCC, full PEM/chain, subject, or body realm as authority; use plaintext backend | Optional gateway boundary |
| AuthenticatedDeviceContext | Carry immutable `realm_id`, `installation_id`, `credential_id`, epoch, assurance, status version, trust domain | Be created from deserialized endpoint fields or mutable request headers | Cross-module server authority |
| Realm-aware stores/caches | Prefix composite keys with realm; include installation/epoch where relevant; enforce row/partition policies and negative tests | Cache by certificate subject, installation alone, URL path, or body realm | Data/cache boundary |
| Identity Operations/Admin API | Perform audited enrollment authorization, suspend/deny/re-enroll/decommission/transfer workflows with separation of duty | View/export private keys; mutate realm in place; silently reactivate; return raw TPM/proxy evidence | Privileged administration boundary |
| Support CLI | Produce finite, value-safe status and challenge-sign verification; package sanitized evidence | Export PFX/key, print bootstrap token, cert DER/PEM, serial/fingerprint, TPM EK, proxy URI, internal address, realm/customer name | Support/evidence boundary |

## 3.3 Configuration ownership

Configuration is split to prevent one plane from broadening another:

| Configuration | Owner/authority | Endpoint effect | Rule |
|---|---|---|---|
| Product identity capability ceiling | Release authority + product security | Which key providers, cert profiles, transport modes, gateways, and diagnostics the binary can execute | Tenant cannot add a provider, algorithm, header, destination, or fallback. |
| Realm enrollment policy | Realm governance/PKI authority (**HUMAN DECISION**) | Which assurance levels and issuer profiles are allowed for one realm | May narrow product ceiling only. |
| Enterprise deployment bootstrap | MDM/installer authority (**HUMAN DECISION**) | One installation enrollment attempt into one realm/audience | One-use, short-lived, non-reusable; no permanent shared secret. |
| Emergency product deny | Product security/incident authority | Disable issuer, gateway, build, assurance level, enrollment, renewal, or all upload | Monotonic narrowing; signed/higher revision. |
| Realm emergency deny | Realm incident authority | Suspend one realm, installation, credential, or lower-assurance class | Cannot re-enable a product deny. |
| Local safety state | Endpoint runtime | Stops work on clock/key/store/identity corruption or unsupported network state | Cannot authorize enrollment or broaden policy. |
| Enterprise proxy/VPN profile | Customer network owner (**HUMAN DECISION**) | Select approved route/profile | Cannot disable server trust or turn a proxy header into device authority. |

## 3.4 Feature flags and kill switches

The release MUST expose only finite release-owned flags. Candidate flags are:

```text
identity.enrollment.enabled
identity.assurance.software.enabled
identity.assurance.tpm.enabled
identity.assurance.tpm_attested.enabled
identity.renewal.enabled
identity.activation.enabled
identity.upload.enabled
identity.gateway_termination.enabled
identity.gateway_assertion.required
network.direct.enabled
network.explicit_proxy.enabled
network.pac.enabled
network.tls_inspection_pop.enabled
platform.persistent_vdi.enabled
platform.nonpersistent_vdi.enabled
```

Normative behavior:

1. Flags default disabled until their named evidence and human decisions pass.
2. Tenant/realm policy MAY disable a release-enabled flag but MUST NOT enable one absent from the product ceiling.
3. Product or realm emergency controls MAY suspend enrollment, renewal, issuance profile, gateway, trust bundle, software-key class, or all upload.
4. A disabled or unknown flag produces a finite error and no fallback.
5. Re-enable requires a higher-revision authorized artifact plus a successful local self-test where applicable.
6. No flag may enable a shared secret, skip certificate validation, accept an identity header from the public edge, or ignore realm mismatch.

## 3.5 Identity authority rules

**RECOMMENDATION — normative rules:**

1. The ingress derives `credential_id` from the validated certificate fingerprint plus approved issuer/trust-domain mapping, or from a validated gateway assertion that binds that fingerprint.
2. The credential record supplies `realm_id`, `installation_id`, `device_id` if assigned, `enrollment_epoch`, `assurance_level`, and current status.
3. Request body, URL, host, certificate subject/SAN, forwarding headers, bearer token claims, endpoint cache, and tenant policy do not establish those values.
4. Identity fields are absent from upload bodies where possible. If retained for troubleshooting/compatibility, they are non-authoritative and MUST exactly match the authenticated context or the request is rejected.
5. Every server module receives a sealed `AuthenticatedDeviceContext` from authentication middleware, not raw identity headers.
6. Every cache and durable key includes `realm_id`; every installation/credential relation also includes epoch where stale identity could otherwise reappear.
7. A wrong-realm request receives one generic external rejection. It does not reveal whether the certificate, installation, or target realm exists.
8. A certificate valid under one realm can never be moved to another realm. Transfer requires decommission plus new enrollment.

## 3.6 Per-installation identity and enrollment epochs

### 3.6.1 Installation creation

The Coordinator creates `installation_id` only when all of the following are true:

- MSI/enterprise installation completed and the release self-check passes;
- the machine has reached its specialized, post-image state;
- no active installation state is present;
- a valid one-use enrollment authorization is available;
- the endpoint store can atomically persist the installation state;
- the key provider profile is known and allowed.

Creation and key generation form one local state transition. A crash between them leaves `KEY_PENDING` and retries idempotently. A key without a complete persisted installation binding is deleted by the recovery path before a new attempt.

### 3.6.2 Enrollment epoch

`enrollment_epoch` starts at `1`. It increments only through an audited server recovery/re-enrollment action. Incrementing the epoch immediately invalidates every credential and outstanding bootstrap/renewal request from prior epochs. An endpoint cannot propose or decrement the epoch.

Use cases for a new epoch include:

- confirmed clone/key compromise;
- destructive repair after local identity-store corruption;
- ownership transfer after old-realm decommission and cleanup;
- reinstall where continuity to the prior installation is intentionally preserved by a human-approved mapping;
- issuer/key-profile migration that cannot safely use ordinary renewal.

A normal key renewal increments `credential_generation`, not `enrollment_epoch`.

## 3.7 Trust-boundary and assurance-level matrix

| Level | Name | Key/evidence profile | What the server may claim | What it must not claim | Default eligibility |
|---|---|---|---|---|---|
| A0 | `BOOTSTRAP_ONLY` | No active device credential; one-use enrollment authorization only | The deployment channel authorized one bounded enrollment attempt | Device authenticity, ongoing upload authority, TPM presence | Enrollment endpoint only; no collection/upload |
| A1 | `SOFTWARE_BOUND` | Machine-scope key in approved software KSP; export permission not enabled; ACL limited to Coordinator/installer; fresh challenge proof | Possession of the key by the running installation at request time, subject to OS boundary | Hardware nonexportability, clone resistance, protection from local admin/kernel | Disabled by default; **HUMAN DECISION** exception only |
| A2 | `TPM_BOUND` | Microsoft Platform Crypto Provider; effective hardware/implementation properties; nonexport policy; challenge signing; TPM available | Key operations are backed by the tested TPM/CNG profile on the named environment | Trusted TPM provenance, genuine hardware vs every vTPM, measured boot, uncompromised OS | Preferred prototype profile where lab passes |
| A3 | `TPM_ATTESTED` | A2 plus issuer-validated TPM key attestation and issuance-policy evidence under an approved trust model | The issued key met the exact attestation policy at issuance | Ongoing boot integrity, current TPM health, user identity, legal authorization | Optional; requires enterprise PKI and trust decision |
| A4 | `MEASURED_BOOT_ATTESTED` | A3 plus current signed platform/boot evidence under a separately designed verifier | Only the explicitly verified measurements and freshness | General endpoint trust, collector correctness, privacy approval | Out of scope; change proposal required |

### 3.7.1 Assurance rules

- Assurance is assigned by the server from verified issuance/evidence, not reported by the endpoint.
- A request never silently falls from A3/A2 to A1. A lower profile requires a new explicit enrollment authorization and records the exception reason/expiry.
- A software key whose ACL, export policy, provider, or challenge proof cannot be verified is A0, not A1.
- A provider string alone is not A2. Microsoft’s TPM key-attestation guidance warns that provider-name claims can be spoofed by an administrator; attestation is the stronger issuance proof.
- A vTPM receives A2/A3 only if the named virtualization platform, vTPM lifecycle, attestation chain, clone behavior, and operator threat model pass. “TPM present” is insufficient.
- Assurance can be reduced only by suspending/re-enrolling under explicit authority; historical records retain the assurance at authorization time.

## 3.8 Windows key creation profile

### 3.8.1 Preferred profile

The first falsifiable Windows profile SHOULD:

1. open the **Microsoft Platform Crypto Provider** by exact provider name;
2. create a machine-scope signing key with a release-owned, non-secret local key name derived from the installation/credential IDs;
3. set no export permission unless an approved API requires an internal public-key operation; private export/PFX is prohibited;
4. set the key usage to signing only;
5. apply a security descriptor that grants key use to the Coordinator service SID and controlled installer/repair authority, not interactive users or broad local groups;
6. choose an algorithm supported by the exact TPM, CA/template, gateway, and server stack; the initial AD CS TPM-attestation lane is expected to require RSA because Microsoft documents RSA-only support for that feature;
7. finalize the key, reopen it under the service identity, inspect effective provider/implementation/export/usage/security properties, and sign a fresh server challenge;
8. store only the key reference, public SPKI digest, provider profile ID, and sanitized assurance result.

Exact property identifiers, algorithm, size, padding, ACL text, and KSP behavior are **CLI EXPERIMENT** inputs, not timeless architecture.

### 3.8.2 Software exception profile

A1 uses the **Microsoft Software Key Storage Provider** or another explicitly admitted KSP. It must retain the same machine-scope, no-private-export, signing-only, service-SID ACL, challenge, audit, rotation, and cleanup requirements. The server marks it `SOFTWARE_BOUND`, and realm policy may deny it.

A missing/unavailable TPM does not trigger A1 automatically. The endpoint returns `TPM_REQUIRED` or `KEY_PROVIDER_UNAVAILABLE`, enters a disabled enrollment state, and waits for an authorized lower-assurance enrollment or remediation.

### 3.8.3 Private-key handling prohibition

The implementation, test harness, support CLI, evidence pipeline, installer, and CA adapter MUST NOT:

- call certificate/private-key export to PFX/PKCS#12;
- print or serialize private parameters;
- attach a private key to evidence;
- copy the machine key directory;
- use private-key export as a test for nonexportability;
- transmit a key to the server or CA;
- put a private key in a golden image, backup, crash dump, support package, or fixture.

Proof is challenge signing, provider/property inspection, attempted prohibited operations inside the disposable lab with only pass/fail output, and cleanup—not key extraction.

## 3.9 Bootstrap enrollment

### 3.9.1 Bootstrap authorization

The preferred bootstrap is an opaque random token delivered by enterprise deployment. It is:

- one use;
- short lived under a **HUMAN DECISION** policy;
- bound server-side to one `realm_id`, product/audience, allowed build/ring, allowed assurance levels, maximum enrollment attempts, and optional deployment transaction;
- stored on the server as a purpose-separated digest, never plaintext;
- protected locally with machine ACLs and deleted after terminal success/failure/expiry;
- absent from command line, environment variables, logs, MSI properties visible to ordinary users, crash data, URLs, and support evidence.

A signed MDM/installer enrollment instruction may replace the opaque token if it provides equivalent one-use, realm/audience, expiry, anti-replay, and authorization properties. This is an integration choice, not a reason to add a second permanent secret.

### 3.9.2 Enrollment sequence

```text
UNENROLLED
  -> BOOTSTRAP_PRESENT
  -> INSTALLATION_RESERVED_LOCALLY
  -> KEY_CREATED
  -> CSR_AND_POP_READY
  -> ENROLLMENT_SUBMITTED
       -> REJECTED_TERMINAL -> DISABLED
       -> RETRYABLE         -> ENROLLMENT_SUBMITTED (same request ID)
       -> CERT_ISSUED_STAGED
  -> MTLS_ACTIVATION_PROBE
       -> FAILED            -> STAGED_RETRY / cleanup at expiry
       -> SUCCEEDED
  -> ACTIVE
```

Normative sequence:

1. Endpoint validates local release, bootstrap envelope, audience, expiry, and allowed assurance request without trusting its realm as authority.
2. Endpoint creates `installation_id`, key, `credential_id`, and a canonical CSR; it signs a server nonce or enrollment transcript to prove possession.
3. Endpoint sends the bootstrap token, idempotency request ID, public CSR, proof, requested provider profile, and bounded evidence. It sends no hostname, username, SID, IP, TPM EK, activity, profile, or internal address unless a separately approved attestation profile requires a narrowly defined field.
4. Server hashes/compares the token, validates its realm/audience/expiry/attempt state, validates the CSR/proof/assurance, and atomically consumes or reserves the authorization.
5. Server calls the CA/RA adapter. The CA signs the public key under the approved profile.
6. Server persists the exact issued certificate/chain digest and returns it. The credential is `STAGED`, not active.
7. Endpoint installs the public certificate associated with the existing private key, discards the token, and opens a new mTLS connection.
8. Server verifies possession through TLS, rechecks status/mapping, and atomically changes the credential to `ACTIVE` with an audit event.
9. Only then may the endpoint obtain realm policy or upload minimized data.

### 3.9.3 Enrollment idempotency and CA uncertainty

The server uses `enrollment_request_id` and bootstrap-authorization uniqueness. Retries return the same terminal result. If the CA times out after possibly issuing, the server does not issue a second certificate blindly. It records `ISSUANCE_UNKNOWN`, reconciles by CA request ID/serial/public-key digest, and either attaches the original certificate or revokes/abandons it before a new request.

## 3.10 Certificate profile

The logical client certificate profile is:

| Field | Normative rule |
|---|---|
| Version | X.509 v3 under RFC 5280 and the selected enterprise profile |
| Basic Constraints | `CA=FALSE`; critical according to issuer policy |
| Key Usage | `digitalSignature`; no key encipherment unless a documented algorithm/profile requires it and the security review accepts it |
| Extended Key Usage | `id-kp-clientAuth` plus an optional private UAM-purpose EKU selected by the PKI authority; server requires the exact approved set |
| Subject | Non-authoritative and privacy-minimal. Prefer a constant descriptive value or empty subject where the issuer/toolchain safely supports it. No realm/customer, host, user, IP, or hardware identity. |
| SAN | Not required for authorization. If needed by tooling, contain only an opaque UAM credential URI; no realm/customer/hostname/IP/user. |
| Custom extension | Optional noncritical opaque `credential_id` or issuance-policy marker; exact private OID is a **HUMAN DECISION**. Server still maps by certificate fingerprint/issuer+serial. |
| Serial | Issuer-owned unique value; treated as sensitive operational metadata and never a metric label or public error value |
| Validity | **HUMAN DECISION**. Endpoint/server enforce `notBefore`/`notAfter`; no indefinite certificate. |
| Signature/public-key algorithm | Approved current algorithm supported by endpoint TPM/KSP, CA, gateway, server, and compliance profile; exact value recorded at execution time |
| Revocation pointers | CRL distribution/OCSP according to enterprise PKI design; not the sole UAM rapid-deny mechanism |
| Attestation issuance policy | Present only for A3 and mapped to one server allowlist entry |
| Certificate policies/CPS | Governed by enterprise PKI under an RFC 3647-style CP/CPS where applicable |

The certificate does not carry mutable realm authorization. Realm mapping remains in the UAM credential database so suspension, transfer, and ownership changes do not require trusting stale certificate text.

## 3.11 Renewal and key rotation

**RECOMMENDATION.** Renewal creates a fresh key by default. Reusing the current key is allowed only through an explicit profile because fresh keys bound the exposure window and test replacement behavior.

Renewal sequence:

1. Active credential authenticates the renewal request.
2. Endpoint creates a new key and CSR under the currently allowed assurance profile.
3. Request binds old `credential_id`, installation/epoch, new public-key digest, request ID, server nonce, and proof by both old and new keys where the selected protocol supports it.
4. Server rechecks old credential status, realm, epoch, build/ring, policy, and assurance; reserves `credential_generation + 1` idempotently.
5. CA issues; server stores new credential as `STAGED`.
6. Endpoint activates the new certificate through mTLS.
7. Server moves it to `ACTIVE`, changes old to `RETIRING`, and permits a bounded overlap only for retry/connection drain.
8. After overlap, old credential becomes `RETIRED`/denied and should be revoked according to PKI policy where needed.
9. Endpoint deletes the old key/certificate only after durable activation/receipt of the new state and after no authorized in-flight operation depends on it.

Exact lifetime, renewal trigger, jitter, overlap, retry, and support grace are **HUMAN DECISION** plus measurement. A mass-renewal simulator for at least 6,000 synthetic installations tests distribution, CA rate limits, cache invalidation, and fail-closed behavior; it is not production capacity proof.

## 3.12 Revocation and rapid denylisting

### 3.12.1 Status layers

| Layer | Purpose | Limitation |
|---|---|---|
| UAM authoritative credential status | Immediate application authorization: `STAGED`, `ACTIVE`, `RETIRING`, `SUSPENDED`, `DUPLICATE_HOLD`, `DENIED`, `REVOKED`, `EXPIRED`, `RETIRED`, `DECOMMISSIONED` | Requires highly available, realm-isolated server state and bounded-freshness caches. |
| Rapid deny cache/feed | Make an incident deny effective at every ingress/gateway without waiting for CA publication | Cache age/version must be explicit; stale/unavailable beyond the approved bound fails closed. |
| CRL/OCSP | Standard PKI revocation for chain validation and other relying parties | Publication, retrieval, and caching can delay effect; responder/CDP outages can deny valid clients. |
| Certificate expiry | Bounds maximum lifetime | Depends on reliable time and chosen lifetime; not incident-speed revocation. |
| Endpoint local kill | Stops a cooperative endpoint | A compromised/lost/offline endpoint cannot be trusted to honor it. |

### 3.12.2 Request authorization

Every new application request MUST consult authoritative status or a cache carrying:

```text
credential_id
realm_id
installation_id
enrollment_epoch
status
status_version
not_after
assurance_level
cache_generated_at
cache_valid_until
issuer_id
```

The cache key is the validated certificate identity, not subject text. If the entry is absent, expired, stale beyond policy, wrong realm, wrong epoch, or non-active, authorization fails. Long-lived HTTP/2 or HTTP/3 connections do not grandfather status: middleware re-evaluates at each request or stream start. A status event instructs the gateway/server to close matching idle/active connections where supported, but connection closure is defense in depth rather than the only control.

### 3.12.3 Revocation transaction

A successful privileged deny/revoke operation means:

1. the server durable transaction recorded the new non-authorizing status, monotonic `status_version`, reason class, actor/action authorization, and audit evidence;
2. the rapid deny feed/version was committed or an outbox entry was committed atomically for propagation;
3. the admin response identifies whether CA revocation publication is pending, complete, or failed;
4. no response claims CA revocation succeeded before the issuer confirms it.

A server deny is effective even if CA revocation is pending. A CA revocation alone does not re-authorize or change the UAM status.

## 3.13 Golden images, clones, and VDI

### 3.13.1 Golden-image invariant

Before image capture, a manifest scanner MUST prove absence of:

- UAM installation/device/realm IDs;
- active/staged/retired client certificates and key containers;
- bootstrap token or authorization envelope;
- endpoint SQLite DB, WAL, SHM, outbox, cursor, receipts, or policy cache;
- TPM attestation response/EK material;
- proxy credentials, network traces, internal routes/addresses;
- prior logs, crash dumps, support evidence, test CA trust, or lab firewall rules.

The image may contain only signed installed binaries, service/task definitions, empty protected directories, release-owned defaults, and a specialization/enrollment hook.

### 3.13.2 Clone/revocation/proxy failure matrix

| Scenario | Detection | Required behavior | Recovery | Residual risk |
|---|---|---|---|---|
| Pre-enrollment image cloned | Each clone generates new installation ID/key after specialization | Independent enrollment; no collision | Normal bootstrap | Specialization timing bug could still clone state; image scan and first-boot test required. |
| Post-enrollment disk clone with software key | Same SPKI/cert used from different connection/device observations, overlapping use, or operator report | Put credential/install in `DUPLICATE_HOLD`; reject both; no automatic winner | Investigate; decommission copies; new epoch/key/enrollment for chosen instance | Sequential use may evade observation; hardware fingerprinting is not a safe universal solution. |
| Post-enrollment clone with physical TPM key | Cloned disk cannot normally use the original TPM key; local key-open/sign fails | Endpoint enters `REENROLL_REQUIRED`; server does not accept software fallback | Clean re-enrollment after authorization | Some virtualization/platform configurations differ; test exact estate. |
| vTPM-backed VM clone/snapshot | Duplicate SPKI/attestation identity, platform inventory, overlapping connection | `DUPLICATE_HOLD`; treat copied vTPM as key clone | Platform-specific destroy/recreate and re-enroll | Hypervisor operator may copy vTPM or suppress observations. |
| Persistent VDI | Identity/key/disk persist for one VM | Treat like physical installation only after named platform tests | Normal lifecycle | Image rebuild/restore can regress identity; generation/epoch detection required. |
| Nonpersistent pooled VDI | Same base reverts every boot | Unsupported initially; must not enroll once in image or share cert | Future ephemeral per-boot authorization profile | High enrollment load, no durable backlog, duplicate portal records, clock/network dependencies. |
| Revoked credential retries | Status lookup/deny cache | Reject every request; retain endpoint data locally; no secret fallback | Approved re-enrollment or decommission | Offline endpoint cannot receive wipe; local admin may attempt bypass. |
| Expired credential after outage | TLS/time/status validation | Reject upload; renewal only through explicit recovery path; preserve data | One-use recovery authorization under owner policy | Fail-closed outage may exceed local storage/support budget. |
| Explicit CONNECT proxy | TLS remains end-to-end to origin | mTLS works if CONNECT and client cert handshake are allowed | Customer proxy configuration/runbook | Proxy auth or policy may block non-browser service. |
| TLS inspection proxy | Origin sees proxy TLS, not endpoint mTLS | Fail; require bypass or separately approved application PoP | Network exception or future profile | Inspection appliance can change headers/body; app-PoP must handle canonicalization/replay. |
| PAC/WPAD unavailable/malicious | Resolution timeout/error/change | Fail closed or use only an explicitly approved fallback order | Restore PAC or select explicit/direct profile | PAC can leak destinations or cause availability problems; exact behavior is estate-specific. |
| VPN route/proxy change mid-upload | Connection error, path/proxy mode transition | Retry same batch on new authorized connection; reauthenticate/status check | Reconnect; no identity change | Split/forced tunnel and DNS race can cause delay/duplicate transport attempts. |

### 3.13.3 Duplicate detection

Server duplicate detection uses privacy-minimal signals:

- same certificate/public key active on overlapping independent TLS connections where gateway/connection IDs differ;
- same `credential_id` presenting incompatible activation/renewal nonces or enrollment observations;
- two server installations attempting to claim one bootstrap or key;
- platform/MDM decommission signal conflicting with continued certificate use;
- operator-reported clone incident.

IP address, hostname, user, SID, geography, and hardware ID are not automatic clone proof. They can change legitimately and can become privacy-sensitive tracking. Optional customer-network connection-class observations must be bounded, access-controlled, retention-approved, and never become sole authority.

### 3.13.4 Nonpersistent VDI future profile

A future profile MAY use an orchestrator/MDM-issued one-use boot authorization to create an ephemeral key/certificate after every boot. It must define:

- unique boot/installation identity;
- short lifetime and immediate decommission at shutdown/lease end;
- no durable endpoint backlog or a separately designed external durable store;
- bounded 6,000-device-style enrollment/renewal load;
- portal aggregation without pretending each boot is a stable device;
- clone/parallel boot detection;
- safe image state and trust cleanup;
- outage semantics when CA/network/clock is unavailable.

This is not enabled by the current recommendation.

## 3.14 Decommission and ownership transfer

### 3.14.1 Decommission

A decommission operation:

1. atomically sets installation and all active credentials to non-authorizing status;
2. emits rapid deny updates and durable audit;
3. requests CA revocation according to policy;
4. records whether enterprise management has confirmed uninstall/key/store cleanup;
5. prevents old epoch reactivation or renewal;
6. keeps historical event provenance under the old realm and retention policy.

The server cannot prove an offline/lost endpoint erased its key. It records cleanup as `UNCONFIRMED`, not success.

### 3.14.2 Ownership transfer

Cross-realm transfer is:

```text
Old realm: ACTIVE
  -> TRANSFER_REQUESTED
  -> OLD_REALM_DECOMMISSIONED / credentials denied
  -> ENDPOINT_CLEANUP_REQUIRED
  -> CLEANUP_CONFIRMED or accepted unconfirmed-risk state
  -> NEW REALM one-use enrollment authorization
  -> new installation_id (default), enrollment_epoch, key, credential, realm binding
  -> NEW_REALM_ACTIVE
```

No database update changes `realm_id` on an active installation or credential. A human governance process decides whether a logical `device_id` relation links the old and new installations. Historical UAM data is not moved or made visible across realms merely because ownership changed.

## 3.15 Direct mTLS, pass-through, and termination

### 3.15.1 Preferred path: direct or L4 pass-through

The endpoint validates the server name and trust chain under the selected Windows/.NET trust profile, presents its client certificate, and negotiates current approved TLS. Kestrel or an L4 pass-through path exposes the actual TLS peer certificate to the UAM authentication boundary. This minimizes trusted components and removes certificate-forwarding headers.

The endpoint MUST NOT install a callback that returns success for every server certificate, suppress name mismatch, trust a leaf certificate by hash alone as a permanent design, or disable revocation without an approved, measured reason. Root/intermediate trust and rollover are owned PKI operations.

### 3.15.2 Conditional L7 gateway termination

When a gateway terminates client TLS, all of these are mandatory:

1. Public listener requires client certificate and validates approved chain, EKU/purpose, validity, and policy.
2. Gateway performs current UAM credential status lookup or uses a bounded-freshness deny cache.
3. Gateway removes every incoming identity/forwarding header, including configured variants, before adding trusted metadata.
4. Backend accepts traffic only from allowlisted gateway identities over mTLS; direct public access is blocked.
5. Gateway sends a short-lived signed assertion that binds:
   - gateway identity and trust-domain ID;
   - validated certificate SHA-256 or mapped `credential_id`;
   - request method and normalized target/route ID;
   - request/body digest where a body exists;
   - unique request ID, issued-at, expiry, and nonce;
   - gateway policy/status versions.
6. Backend verifies signature, audience, gateway allowlist, time, nonce/replay, method/target/body binding, status freshness, and then performs or confirms credential lookup.
7. Full certificate, chain, subject, SAN, serial, and raw XFCC are not forwarded unless a narrowly approved diagnostic requires them; they are never application authority.
8. Gateway and backend parsers reject duplicate/conflicting identity headers and request smuggling differentials.

Envoy’s XFCC controls and YARP forwarded-header behavior demonstrate that sanitization features exist; they do not prove a safe UAM configuration. UAM’s signed assertion and backend allowlist remain its own contract.

### 3.15.3 Certificate-bound tokens

RFC 8705 certificate-bound OAuth tokens are useful if UAM later introduces an authorization server, multiple resource servers, or delegated backend calls. Initially they add an issuer/token-validation plane without replacing the need for certificate status and realm mapping. They are therefore deferred.

If adopted, the token thumbprint and the actual TLS peer certificate MUST match; the token audience/scope/realm context must come from server policy; token expiry cannot exceed credential authorization; and gateway termination must preserve the peer-certificate binding through a trusted proof. A bearer token alone is never a fallback.

### 3.15.4 Future application-level asymmetric proof

TLS inspection normally prevents origin mTLS because the inspection appliance terminates the endpoint TLS connection. A future profile may use:

- DPoP under RFC 9449 for sender-constrained OAuth tokens; or
- HTTP Message Signatures under RFC 9421 with `Content-Digest` under RFC 9530.

It must sign an exact UAM profile of method, target, authority/audience, content digest, credential/key ID, nonce, timestamp, and request ID; tolerate only explicitly allowed proxy transformations; enforce replay storage and clock bounds; bind proof to current credential/realm/status; and retain ordinary server TLS validation to the inspection proxy/origin trust path. It cannot use a symmetric fleet MAC. This profile is disabled until a full ADR, interoperability test, security review, and customer approval pass.

## 3.16 Proxy and VPN behavior

### 3.16.1 Supported-mode ladder

The initial support ladder is:

1. **Direct** network connection.
2. **Explicit machine/service proxy with CONNECT** and optional approved proxy authentication.
3. **Explicit PAC URL or WinHTTP auto-proxy/WPAD** only after exact lab and customer-network evidence.
4. **TLS inspection with application PoP** only after a separate profile; otherwise unsupported.

The Coordinator does not depend on an interactive user’s browser proxy settings or credentials. The exact .NET handler proxy configuration is explicit and included in the runtime profile. Environment-variable proxy behavior is disabled or normalized when it could conflict with enterprise policy.

### 3.16.2 Safe inventory

`netsh winhttp show proxy` and `show advproxy` can reveal internal proxy URLs and bypass lists. Raw output remains in the restricted lab/customer environment. Shareable evidence reports only finite categories such as `DIRECT`, `STATIC_PROXY`, `PAC`, `AUTO_DETECT`, `BYPASS_PRESENT`, and `UNKNOWN`, plus success/failure counts. It never includes proxy host, port, URI, username, bypass value, internal domain, or address.

### 3.16.3 VPN transitions

VPN connect/disconnect, sleep/resume, DNS change, and network-category change invalidate pooled connections or trigger a health check. The endpoint retries the same stable batch identity after re-establishing TLS and device authorization. It does not change installation identity, mint a new event, or mark data delivered before a durable receipt. No component interprets network location as realm authority.

## 3.17 Clock, offline, lost-device, and recovery behavior

### 3.17.1 Clock confidence

The endpoint records a finite clock state: `TRUSTED`, `UNCERTAIN`, or `UNTRUSTED`. It may compare wall clock with monotonic elapsed time, signed server time from a previously authenticated exchange, and Windows time-service health, without exposing the enterprise time source.

- New enrollment, activation, and renewal require a clock within the profile’s accepted evidence or an explicit server challenge protocol that safely handles skew.
- Normal TLS/certificate validation remains standards-compliant; the endpoint does not set the clock or disable validity checks to “fix” an error.
- A rollback or large jump creates `CLOCK_UNTRUSTED`, closes outstanding work, and enters fail-closed identity health.
- Exact skew tolerance and offline behavior are **HUMAN DECISION**.

### 3.17.2 Offline device

An offline endpoint may continue only the local collection authorized by a still-valid signed product/realm policy and privacy ceiling. Identity failure does not authorize collection. Upload waits. Unacknowledged minimized data is retained under the accepted durability rules and never silently dropped. When the certificate or policy expires, the endpoint stops the affected capability according to the stricter authority.

A lost device is denied server-side immediately and revoked through PKI. The server cannot remotely prove key deletion. Reappearance with the old credential remains rejected. Recovery uses enterprise management or a one-use re-enrollment authorization, never the old denied credential plus a shared secret.

## 3.18 Error taxonomy

Externally visible authentication responses SHOULD collapse sensitive cases into `DEVICE_AUTH_REJECTED` with a correlation ID. Internal finite categories are:

```text
ENROLL_BOOTSTRAP_MISSING
ENROLL_BOOTSTRAP_EXPIRED
ENROLL_BOOTSTRAP_USED
ENROLL_BOOTSTRAP_REALM_MISMATCH
ENROLL_AUDIENCE_REJECTED
ENROLL_CSR_INVALID
ENROLL_PROOF_OF_POSSESSION_FAILED
ENROLL_REQUEST_CONFLICT
KEY_PROVIDER_UNAVAILABLE
KEY_PROFILE_UNSUPPORTED
KEY_ACL_INVALID
TPM_REQUIRED
TPM_NOT_READY
TPM_ATTESTATION_FAILED
CERT_ISSUANCE_TRANSIENT
CERT_ISSUANCE_PERMANENT
CERT_ISSUANCE_UNKNOWN
CERT_INSTALL_FAILED
CERT_ACTIVATION_FAILED
CERT_RENEWAL_NOT_ALLOWED
CERT_RENEWAL_CONFLICT
CLOCK_UNTRUSTED
TLS_SERVER_TRUST_FAILED
TLS_SERVER_NAME_FAILED
TLS_CLIENT_CERT_NOT_REQUESTED
TLS_CLIENT_CERT_REJECTED
CREDENTIAL_UNKNOWN
CREDENTIAL_NOT_ACTIVE
CREDENTIAL_DENIED
CREDENTIAL_EXPIRED
CREDENTIAL_EPOCH_STALE
WRONG_REALM
DUPLICATE_IDENTITY_DETECTED
DENY_CACHE_STALE
GATEWAY_NOT_TRUSTED
GATEWAY_ASSERTION_INVALID
GATEWAY_ASSERTION_REPLAY
PROXY_AUTH_REQUIRED
PROXY_CONNECT_DENIED
PROXY_CONFIGURATION_UNSUPPORTED
PAC_RESOLUTION_FAILED
TLS_INSPECTION_DETECTED
VPN_ROUTE_UNAVAILABLE
REENROLL_REQUIRED
DECOMMISSIONED
```

Errors never include certificate DER/PEM, serial, fingerprint, subject/SAN, TPM EK, hardware ID, proxy URI, internal host/address, token, realm/customer name, user, SID, or activity value.

## 3.19 Privacy-safe observability and metric cardinality

Allowed metric dimensions are finite release-owned values:

```text
component
operation_stage
outcome_family
assurance_level
credential_state
issuer_profile_id (bounded catalogue token, not display name)
transport_mode
proxy_mode
vpn_transition_class
tls_failure_bucket
gateway_profile_id (bounded token)
build_ring
```

Forbidden labels include realm, tenant, installation, device, credential, certificate fingerprint/serial/subject, user, SID, hostname, IP, proxy host/port/URI, VPN name, TPM EK/manufacturer/firmware as free text, exception message, request target, and customer network identifier.

A cardinality fitness test computes the maximum theoretical series count from the finite catalogues and compares it with an approved **HUMAN DECISION** budget. Rare-population suppression, access, retention, and alert thresholds remain human-owned.

Support output uses accessible plain-language summaries plus stable machine-readable codes. It does not rely on color alone and supplies keyboard-readable text for every state. Accessibility is relevant to administrative error messages and runbooks, not to changing cryptographic policy.

## 3.20 PKI operations, skills, cost, and support

### 3.20.1 Required operational capabilities

Before production, accountable functions must be able to:

- operate or integrate the issuer/RA with separation of duties;
- secure CA/RA/gateway signing keys, backups, HSM/KMS where approved, and recovery ceremonies;
- maintain CP/CPS or equivalent documented issuance/revocation policy;
- publish and monitor roots/intermediates/CRLs/OCSP where selected;
- execute root/intermediate/server/client-profile rollover;
- reconcile issued, active, staged, denied, revoked, expired, and orphan certificates;
- investigate duplicate identities without collecting raw activity or broad hardware fingerprints;
- operate rapid deny propagation and stale-cache fail-closed behavior;
- support customer proxy/VPN/TLS-inspection diagnostics without receiving credentials or internal addresses;
- perform restore drills that preserve status/audit/realm isolation and do not resurrect denied credentials;
- decommission CAs, gateways, realms, and endpoints safely;
- respond to endpoint, CA, issuer, gateway, bootstrap, proxy, and time incidents.

### 3.20.2 Cost and skills categories

No budget is available, so this result does not select a product. The comparison must include:

- CA/RA/HSM/KMS licensing and support;
- gateway/load-balancer licensing and mTLS/header/assertion capability;
- MDM/deployment integration effort;
- Windows CNG/AD CS/TPM engineering expertise;
- 24/7 or business-hours PKI, identity, endpoint, network, and incident support;
- CRL/OCSP and deny-feed availability;
- certificate inventory and audit storage;
- customer-network qualification lab time;
- recurring Windows/TPM/proxy/VPN/VDI compatibility testing;
- renewal/rollover load and failure drills;
- lower-assurance exception review and expiration.

The simplest design remains direct mTLS plus UAM server status mapping. An additional token service, online schema/identity registry, SPIRE deployment, cert-manager controller, or Envoy fleet is justified only by a measured operational requirement.

---

# 4. Alternatives, rejection reasons, and conditions that would change the choice

| Alternative | Decision | Rejection/deferral reason | Condition that could change it |
|---|---|---|---|
| One fleet API key or password | **REJECT** | One leak compromises every endpoint; no per-device revocation, clone detection, or assurance; encourages insecure proxy workaround | No expected reconsideration. Only per-installation asymmetric proof is acceptable. |
| Per-device symmetric secret | **REJECT AS DEFAULT** | Still requires secure secret provisioning/storage/rotation and is easier to copy from image/software; gives no PKI interoperability | A constrained legacy environment that cannot perform asymmetric crypto, with explicit change proposal and HSM-backed server design; still not a fleet secret. |
| Self-signed client certificates allowlisted by fingerprint | **DEFER/REJECT FOR NORMAL PKI** | Avoids CA but moves issuance, trust, renewal, and revocation entirely into UAM; difficult enterprise integration | Very small isolated deployment with approved trust/bootstrap and full lifecycle evidence; production scale/ownership must justify it. |
| Enterprise AD CS autoenrollment alone | **DEFER** | Can issue machine certs, but UAM still needs installation/realm mapping, one-use authorization, clone handling, status, and product-specific profile; domain/AD CS ownership unknown | Enterprise PKI owner selects it and proves CSR/attestation/profile/renewal/revocation/idempotency and non-domain cases. |
| MDM SCEP/PKCS profile alone | **DEFER** | MDM identity is useful authorization but may not express UAM installation epochs/realm mapping or strong proof; exact MDM unknown | MDM/PKI contract provides equivalent one-use realm binding, fresh key, assurance evidence, lifecycle callbacks, and support. |
| ACME/step-ca direct endpoint enrollment | **LAB CANDIDATE; PRODUCTION DEFERRED** | Good automation patterns, but default provisioners may not implement UAM realm/TPM/clone semantics; new CA operations stack | Dedicated PKI decision plus exact provisioner/template/attestation/status integration and support evidence. |
| EST/SCEP/CMP protocol | **DEFER** | Standards may fit enterprise PKI, but choosing one before issuer/MDM ownership is premature | Selected PKI supports it and UAM adapter proves one-use authorization, idempotency, fresh key, realm binding, and failure recovery. |
| TPM mandatory for every device | **HUMAN DECISION; TEMPORARY FAIL-CLOSED** | Strong default but may exclude unsupported/vTPM/repair scenarios; estate coverage unknown | Human owner approves supported classes after coverage/exception analysis. Temporary technical default denies software fallback. |
| Software key for every device | **REJECT** | Weakens clone/extraction containment and ignores available TPM capability | Only if measured estate has no viable TPM and human risk owner explicitly accepts A1; still per-installation and nonexport policy. |
| Provider-name-only TPM detection | **REJECT** | Provider claim is not attestation and can be spoofed by privileged software | Never sufficient for A3; A2 still requires effective properties and challenge tests. |
| Full TPM measured-boot attestation now | **DEFER** | Large verifier/privacy/platform/operations scope; not required to authenticate an installation key | A defined high-assurance use case, approved data fields/retention, supported estate, and separate ADR/prototype. |
| Put device cert/key in golden image | **REJECT** | Creates clones and destroys per-installation identity | No expected reconsideration. Images remain unenrolled. |
| Stable shared certificate for nonpersistent VDI pool | **REJECT** | Cannot revoke/audit one instance and enables parallel impersonation | No expected reconsideration; future per-boot identities only. |
| In-place realm field change | **REJECT** | Cross-realm cache/store/history confusion and stale cert authority | No expected reconsideration; use decommission + new enrollment. |
| Certificate subject/SAN contains realm and is authority | **REJECT** | Stale, hard to transfer, privacy-bearing, and conflicts with server-derived authority | Certificate may carry an opaque hint, but server mapping remains authoritative. |
| Hostname/`MachineGuid`/SID/hardware hash identity | **REJECT** | Mutable, cloneable, privacy-sensitive, or owned by another system | May be optional incident evidence only after governance, never primary authority. |
| Direct Kestrel mTLS | **ACCEPT DEFAULT** | Smallest path | Change only if customer/network/availability requirements require a gateway. |
| L4 TLS pass-through load balancer | **ACCEPT** | Preserves actual TLS peer | Must prove health/availability/routing without terminating identity. |
| L7 termination with plain XFCC | **REJECT** | Public clients can spoof headers; certificate chain may be forwarded unvalidated; backend loses TLS peer | Signed request-bound assertion, header stripping, gateway mTLS, allowlist, and adversarial proof make termination acceptable. |
| L7 gateway with full certificate PEM header | **REJECT AS DEFAULT** | Expands sensitive data and parser/header-smuggling surface | Only bounded forensic diagnostic under separate authorization; not runtime authority. |
| Certificate-bound OAuth token | **DEFER** | Additional authorization server/token lifecycle without current need | Multiple resource servers/delegation or gateway architecture demonstrates clear value. |
| Bearer JWT without key binding | **REJECT AS DEVICE AUTH** | Stolen token is replayable and duplicates certificate status/realm plane | May carry non-authoritative short-lived permissions only when sender-constrained. |
| DPoP | **FUTURE CANDIDATE** | Can survive TLS termination but requires OAuth/token/nonce/replay/clock profile | TLS inspection is mandatory and a full profile passes across proxies. |
| HTTP Message Signatures + Content-Digest | **FUTURE CANDIDATE** | Direct message proof but difficult canonicalization/transform/replay interoperability | Named proxies and endpoint/server libraries pass exact vectors and operational review. |
| Disable TLS validation under proxy inspection | **REJECT** | Enables interception/impersonation and does not restore device identity | No expected reconsideration. Use trust/bypass or approved PoP. |
| Leaf certificate pinning | **REJECT AS DEFAULT** | Brittle rollover and outage risk; does not replace PKI/name validation | A constrained bootstrap may pin a trust anchor/digest with signed rollover, but standard trust remains preferred. |
| CRL/OCSP only | **REJECT** | Publication/cache latency and long-lived connection issue | Retain as PKI layer plus rapid UAM deny status. |
| Soft-fail stale deny cache | **REJECT** | Revoked/unknown identity could be accepted during outage | A human risk decision could define an extremely narrow read-only recovery endpoint; upload remains denied. |
| Endpoint self-wipe as proof of revocation | **REJECT** | Compromised/offline endpoint cannot be trusted to comply | Enterprise management cleanup is separate and recorded as confirmed/unconfirmed. |
| Treat IP/network as realm | **REJECT** | VPN/proxy/NAT changes and cross-realm shared networks make it unreliable | Network may be an additional policy signal, never authority. |
| Add SPIRE/cert-manager as initial dependency | **REJECT/REFERENCE ONLY** | Different workload/Kubernetes scope and material operational footprint | A measured need for workload issuance/controller semantics and a full dependency/operations ADR. |

No accepted baseline decision is changed by this result. If a future experiment shows that safe per-installation asymmetric identity cannot operate under the supported estate without violating an accepted invariant, the change proposal must name the affected decision, new primary evidence, security/privacy/realm impact, smallest falsifying test, migration, rollback, and ADR action.

---

# 5. Interfaces, protocols, and example contracts or schemas

## 5.1 Common normative contract rules

All identity contracts inherit the Batch 01 strict contract profile and MUST:

- use an immutable contract name and exact semantic version;
- use canonical lower-case UUIDv7 for new UAM IDs and SHA-256 for content/file/certificate digests;
- use strict UTF-8 JSON where JSON is selected: no BOM, duplicate members, wrong case, comments, trailing commas, implicit defaults, unbounded values, remote references, or unknown members outside a declared extension point;
- declare byte, item, depth, property, allocation, decompression, processing-time, and retry bounds;
- distinguish required, optional, and nullable fields;
- bind realm/installation authority to authenticated server state, not request fields;
- include idempotency and retry semantics;
- carry finite stable error codes and omit sensitive detail;
- declare allowed logs, metrics, traces, and evidence;
- have valid, boundary, invalid, canonical, replay, wrong-realm, wrong-epoch, duplicate, stale, and old/new compatibility vectors;
- use local pinned schemas in build/runtime validation; no network schema fetch;
- reject unsupported major versions and fail closed on semantic/authorization incompatibility.

The examples below contain fictional identifiers and `.test` values only. They are logical contracts, not approved certificate lifetime, endpoint fields, or production hostnames.

## 5.2 Enrollment authorization schema

The deployment system normally carries the opaque token outside JSON. The server record is authoritative and stores only its digest:

```json
{
  "contract": "uam.identity.enrollment-authorization-record",
  "version": "1.0.0",
  "authorizationId": "019d0000-0000-7000-8000-000000000101",
  "tokenDigest": "sha-256:9a43f0d6f4f1b1a3f0f2e84b071ecdcf52a9697d77e36f7a14bbd90936a99c21",
  "realmId": "019d0000-0000-7000-8000-000000000102",
  "audience": "uam-device-enrollment",
  "allowedProductMajor": 1,
  "allowedBuildRing": "LAB",
  "allowedAssuranceLevels": ["TPM_BOUND", "TPM_ATTESTED"],
  "maxSuccessfulEnrollments": 1,
  "notBeforeUtc": "2026-07-31T10:00:00Z",
  "expiresAtUtc": "2026-07-31T11:00:00Z",
  "state": "ISSUED",
  "issuerProfileId": "uam-lab-client-v1",
  "deploymentTransactionId": "019d0000-0000-7000-8000-000000000103"
}
```

Rules:

- `tokenDigest` is HMAC-SHA-256 or an approved password-hash construction over the random token with server-held purpose separation; exact construction is a security ADR.
- Token plaintext is never returned by a read API, query, log, audit payload, or support export.
- `realmId`, assurance, issuer, audience, and expiry are server-owned. Endpoint copies do not override them.
- An authorization transitions monotonically through `ISSUED`, `RESERVED`, `CONSUMED`, `EXPIRED`, `REVOKED`, or `CONFLICT`.
- A consumed/revoked/expired token never becomes issued again. Recovery creates a new authorization ID/token.

## 5.3 Enrollment request

```json
{
  "contract": "uam.identity.enrollment-request",
  "version": "1.0.0",
  "requestId": "019d0000-0000-7000-8000-000000000201",
  "bootstrapToken": "<opaque-one-use-secret-not-logged>",
  "installationId": "019d0000-0000-7000-8000-000000000202",
  "enrollmentEpochRequested": 1,
  "credentialId": "019d0000-0000-7000-8000-000000000203",
  "credentialGenerationRequested": 1,
  "csrDerBase64Url": "<bounded-public-pkcs10>",
  "csrSha256": "sha-256:2ebda3d5be56a5e39d190f24fcfeddb890e3ed5c60ac174f7075b519a0e2252a",
  "publicSpkiSha256": "sha-256:bcd8dd6ff4388953185455db7b85e929f7cdd7f54f6067308116413ed55cf2f4",
  "keyProviderProfileId": "windows-platform-ksp-rsa-v1",
  "requestedAssuranceLevel": "TPM_ATTESTED",
  "proof": {
    "challengeId": "019d0000-0000-7000-8000-000000000204",
    "algorithmProfileId": "rsa-pss-sha256-v1",
    "signatureBase64Url": "<signature-over-canonical-enrollment-transcript>"
  },
  "attestation": {
    "profileId": "windows-adcs-tpm-key-attestation-v1",
    "evidenceBase64Url": "<bounded-public-attestation-evidence>"
  },
  "clientContractVersions": ["uam.identity.enrollment-response/1"]
}
```

Normative restrictions:

- `realmId`, device ID, customer name, hostname, user, SID, IP, MAC, internal address, source/activity, proxy data, and certificate private key are structurally absent.
- `installationId`, epoch, credential ID, generation, provider profile, and assurance request are claims to validate; the bootstrap record and server state remain authoritative.
- The proof signs a domain-separated canonical transcript containing audience, request ID, installation ID, epoch, credential ID/generation, CSR digest, SPKI digest, challenge ID, and server nonce expiry.
- Attestation is optional at contract level but required by an A3 authorization. Unknown attestation profile fails; it does not fall back.
- Request size and attestation size are hard bounded before parsing/cryptographic work.

## 5.4 Enrollment response

```json
{
  "contract": "uam.identity.enrollment-response",
  "version": "1.0.0",
  "requestId": "019d0000-0000-7000-8000-000000000201",
  "outcome": "CERTIFICATE_STAGED",
  "installationId": "019d0000-0000-7000-8000-000000000202",
  "enrollmentEpoch": 1,
  "credentialId": "019d0000-0000-7000-8000-000000000203",
  "credentialGeneration": 1,
  "assuranceLevel": "TPM_ATTESTED",
  "issuerId": "019d0000-0000-7000-8000-000000000301",
  "certificateDerBase64Url": "<public-leaf-certificate>",
  "chainDerBase64Url": ["<public-intermediate-certificate>"],
  "certificateSha256": "sha-256:f51e3ecbfa1cfe2a5b806944743f2fe1f4086970548d623f0c302d0dd8c80172",
  "activation": {
    "activationId": "019d0000-0000-7000-8000-000000000302",
    "audience": "uam-device-activation",
    "expiresAtUtc": "2026-07-31T11:05:00Z"
  }
}
```

- The response does not need to expose `realmId`; endpoint authority comes through subsequent authenticated policy, while the server stores the binding.
- The endpoint verifies that the certificate public key matches its local key and that certificate profile, issuer, validity, and requested credential ID match expected policy before installation.
- The endpoint sends no activity and receives no ordinary control policy until activation succeeds.
- A response with `ISSUANCE_UNKNOWN`, `REJECTED`, or `RETRYABLE` contains a finite code and no CA/internal detail.

## 5.5 Activation contract

Activation occurs through mTLS using the staged certificate:

```json
{
  "contract": "uam.identity.activation-request",
  "version": "1.0.0",
  "activationId": "019d0000-0000-7000-8000-000000000302",
  "requestId": "019d0000-0000-7000-8000-000000000401",
  "nonce": "<server-issued-one-use-nonce>",
  "clientState": "CERTIFICATE_INSTALLED"
}
```

Authentication middleware supplies the candidate certificate identity. The body cannot choose the credential. Successful activation atomically checks:

- staged credential fingerprint matches TLS peer;
- activation ID/nonce/audience/expiry is valid and unused;
- installation/epoch/generation state is current;
- no clone/deny/decommission state exists;
- assurance/profile and issuer are still allowed;
- activation audit can commit.

The response returns only a stable activation outcome and control-plane bootstrap pointer/digest under the authenticated context.

## 5.6 Renewal request

```json
{
  "contract": "uam.identity.renewal-request",
  "version": "1.0.0",
  "requestId": "019d0000-0000-7000-8000-000000000501",
  "currentCredentialId": "019d0000-0000-7000-8000-000000000203",
  "currentStatusVersionObserved": 17,
  "newCredentialId": "019d0000-0000-7000-8000-000000000502",
  "newCredentialGenerationRequested": 2,
  "csrDerBase64Url": "<bounded-public-pkcs10>",
  "publicSpkiSha256": "sha-256:a1ffb71f0bcac4388e85b520cb5a9194640738042787a04a658b9a175cd8b12a",
  "keyProviderProfileId": "windows-platform-ksp-rsa-v1",
  "newKeyProof": {
    "challengeId": "019d0000-0000-7000-8000-000000000503",
    "signatureBase64Url": "<new-key-proof>"
  },
  "currentKeyBinding": {
    "challengeId": "019d0000-0000-7000-8000-000000000504",
    "signatureBase64Url": "<current-key-authorization>"
  }
}
```

TLS authenticated context supplies realm, installation, epoch, and current credential authority. New and current key proofs bind the same renewal transcript. The server rejects a generation gap, reused SPKI, stale epoch, denied/retiring credential outside its window, assurance downgrade, or wrong issuer profile.

## 5.7 Credential status and rapid deny contract

Privileged mutation command:

```json
{
  "contract": "uam.identity.credential-status-command",
  "version": "1.0.0",
  "commandId": "019d0000-0000-7000-8000-000000000601",
  "realmId": "019d0000-0000-7000-8000-000000000102",
  "credentialId": "019d0000-0000-7000-8000-000000000203",
  "expectedStatusVersion": 17,
  "targetStatus": "DENIED",
  "reasonClass": "DEVICE_REPORTED_LOST",
  "caRevocationRequested": true,
  "authorizationEvidenceId": "019d0000-0000-7000-8000-000000000602"
}
```

Rules:

- The caller is an authenticated/authorized administrator or automation principal; body `realmId` is checked against caller scope.
- Compare-and-swap prevents lost updates.
- The transaction commits new status/version, audit, and deny-feed outbox atomically.
- No free-form incident text enters endpoint status or metrics. Restricted case systems may hold details under separate access/retention.
- Reactivation of `DENIED`, `REVOKED`, `DECOMMISSIONED`, or `DUPLICATE_HOLD` is not an ordinary status edit; it requires a recovery/re-enrollment workflow and new key/credential where applicable.

Rapid deny feed record:

```json
{
  "contract": "uam.identity.rapid-deny-delta",
  "version": "1.0.0",
  "feedSequence": 8831,
  "generatedAtUtc": "2026-07-31T10:30:00Z",
  "entries": [
    {
      "credentialId": "019d0000-0000-7000-8000-000000000203",
      "status": "DENIED",
      "statusVersion": 18,
      "effectiveAtUtc": "2026-07-31T10:29:59Z"
    }
  ],
  "contentSha256": "sha-256:75be56f56d4b5a73cc6a11c8e7e6730fbb0b0b2d8807f92b783753b47fdb94ae"
}
```

The feed is authenticated and integrity-protected between server components. Exact transport is an internal contract. Missing sequence, signature failure, rollback, or stale `validUntil` causes fail-closed authorization for affected trust domains after the bounded cache period.

## 5.8 Authenticated device context

Application code receives an immutable in-process object created only by trusted authentication middleware:

```csharp
public sealed record AuthenticatedDeviceContext(
    Guid RealmId,
    Guid InstallationId,
    Guid? DeviceId,
    Guid CredentialId,
    int EnrollmentEpoch,
    int CredentialGeneration,
    DeviceAssuranceLevel AssuranceLevel,
    long CredentialStatusVersion,
    Guid IssuerId,
    Guid TrustDomainId,
    string TransportProfileId,
    string AuthenticationEvidenceId);
```

Normative implementation rules:

- Constructor/internal factory is unavailable to request DTO binding and ordinary modules.
- Middleware creates the object after TLS/gateway proof, certificate mapping, status, realm, epoch, validity, assurance, and route/audience checks.
- Serialization is prohibited except into a separately defined durable audit/receipt provenance contract.
- `AuthenticationEvidenceId` is opaque and bounded; it supports audit correlation without exposing certificate material.
- A cache hit must reproduce the exact context and status version under a bounded expiry.

## 5.9 Gateway assertion contract

The assertion is an integrity-protected internal artifact. JWS is a candidate representation, not yet a final crypto decision. Its logical payload is:

```json
{
  "iss": "uam-gateway-profile-01",
  "aud": "uam-ingestion-backend",
  "jti": "019d0000-0000-7000-8000-000000000701",
  "iat": 1785493800,
  "exp": 1785493830,
  "trustDomainId": "019d0000-0000-7000-8000-000000000702",
  "credentialId": "019d0000-0000-7000-8000-000000000203",
  "certificateSha256": "sha-256:f51e3ecbfa1cfe2a5b806944743f2fe1f4086970548d623f0c302d0dd8c80172",
  "credentialStatusVersion": 18,
  "gatewayPolicyVersion": 44,
  "method": "POST",
  "routeId": "ingestion-batch-v1",
  "requestId": "019d0000-0000-7000-8000-000000000703",
  "contentDigest": "sha-256:2010c255bfa678bc7d46e7c2dc77edc910b7848b7939aad94bf4c95fa0935ab0"
}
```

- Assertion lifetime is short and exact value is measured/approved.
- Backend checks `jti` replay within the validity window or uses a request/connection design that provides equivalent non-replay.
- The assertion does not carry realm as authority. Backend maps `credentialId` and confirms realm/status; including a non-authoritative realm hint is unnecessary and discouraged.
- Gateway identity is authenticated by mTLS and the assertion key purpose/issuer allowlist. Possession of one without the other is insufficient.
- Client-supplied assertions and XFCC are always deleted at the public edge.

## 5.10 Upload protocol identity rules

The existing bounded authenticated HTTPS batch contract remains unchanged except:

1. mTLS/gateway proof creates `AuthenticatedDeviceContext` before body parsing beyond global safe limits.
2. Body MUST NOT contain authoritative realm, installation, device, credential, assurance, or epoch values.
3. If a temporary compatibility field exists, it MUST equal authenticated context and is removed before durable domain processing.
4. Durable inbox rows record server-derived realm/installation/credential/epoch/assurance provenance separately from the immutable batch body.
5. Batch/event dedupe and receipt lookup are realm-keyed; wrong realm cannot probe existence.
6. A receipt is issued only after the accepted durable-custody transaction and never just because mTLS succeeded.
7. Retry with a renewed credential is allowed only when the new credential maps to the same installation/epoch/realm; business dedupe remains stable across credential generation.

## 5.11 External error contract

```json
{
  "type": "urn:uam:problem:device-auth-rejected",
  "title": "Device authentication was rejected",
  "status": 401,
  "code": "DEVICE_AUTH_REJECTED",
  "correlationId": "019d0000-0000-7000-8000-000000000801"
}
```

Enrollment endpoints may return a little more actionable but still finite codes because the endpoint is not yet authenticated. They never disclose whether a realm, installation, credential, certificate serial, or token exists. Retryability appears as a finite boolean/category and optional bounded `Retry-After` where safe.

## 5.12 Enrollment/certificate/realm logical schema

The schema is logical and portable between the target relational engines. Physical types, indexes, partitions, encryption, and retention require later benchmark/operations decisions. Composite tenant-owned tables begin with `realm_id`.

```sql
CREATE TABLE identity_realm (
    realm_id                  UUID        NOT NULL,
    state                     VARCHAR(32) NOT NULL,
    realm_policy_revision     BIGINT      NOT NULL,
    created_at_utc            TIMESTAMP   NOT NULL,
    row_version               BIGINT      NOT NULL,
    PRIMARY KEY (realm_id)
);

CREATE TABLE identity_device (
    realm_id                  UUID        NOT NULL,
    device_id                 UUID        NOT NULL,
    state                     VARCHAR(32) NOT NULL,
    external_mapping_state    VARCHAR(32) NOT NULL,
    created_at_utc            TIMESTAMP   NOT NULL,
    retired_at_utc            TIMESTAMP   NULL,
    row_version               BIGINT      NOT NULL,
    PRIMARY KEY (realm_id, device_id),
    FOREIGN KEY (realm_id) REFERENCES identity_realm(realm_id)
);

CREATE TABLE identity_installation (
    realm_id                  UUID        NOT NULL,
    installation_id           UUID        NOT NULL,
    device_id                 UUID        NULL,
    enrollment_epoch          INTEGER     NOT NULL CHECK (enrollment_epoch >= 1),
    state                     VARCHAR(32) NOT NULL,
    duplicate_hold            BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at_utc            TIMESTAMP   NOT NULL,
    decommissioned_at_utc     TIMESTAMP   NULL,
    row_version               BIGINT      NOT NULL,
    PRIMARY KEY (realm_id, installation_id),
    UNIQUE (realm_id, installation_id, enrollment_epoch),
    FOREIGN KEY (realm_id, device_id)
      REFERENCES identity_device(realm_id, device_id)
);

CREATE TABLE identity_enrollment_authorization (
    realm_id                  UUID        NOT NULL,
    authorization_id          UUID        NOT NULL,
    token_digest              BINARY(32)  NOT NULL,
    audience                  VARCHAR(64) NOT NULL,
    allowed_assurance_mask    INTEGER     NOT NULL,
    issuer_profile_id         VARCHAR(64) NOT NULL,
    allowed_build_ring        VARCHAR(32) NOT NULL,
    not_before_utc            TIMESTAMP   NOT NULL,
    expires_at_utc            TIMESTAMP   NOT NULL,
    max_successful_enrollments INTEGER    NOT NULL CHECK (max_successful_enrollments = 1),
    state                     VARCHAR(32) NOT NULL,
    deployment_transaction_id UUID        NULL,
    reserved_request_id       UUID        NULL,
    consumed_at_utc           TIMESTAMP   NULL,
    row_version               BIGINT      NOT NULL,
    PRIMARY KEY (realm_id, authorization_id),
    UNIQUE (token_digest)
);

CREATE TABLE identity_enrollment_request (
    realm_id                  UUID        NOT NULL,
    request_id                UUID        NOT NULL,
    authorization_id          UUID        NOT NULL,
    installation_id           UUID        NOT NULL,
    enrollment_epoch          INTEGER     NOT NULL,
    credential_id             UUID        NOT NULL,
    credential_generation     INTEGER     NOT NULL,
    csr_sha256                BINARY(32)  NOT NULL,
    public_spki_sha256        BINARY(32)  NOT NULL,
    key_provider_profile_id   VARCHAR(64) NOT NULL,
    requested_assurance       VARCHAR(32) NOT NULL,
    established_assurance     VARCHAR(32) NULL,
    issuer_request_id         VARCHAR(128) NULL,
    issuance_state            VARCHAR(32) NOT NULL,
    created_at_utc            TIMESTAMP   NOT NULL,
    completed_at_utc          TIMESTAMP   NULL,
    row_version               BIGINT      NOT NULL,
    PRIMARY KEY (realm_id, request_id),
    UNIQUE (realm_id, authorization_id),
    UNIQUE (realm_id, installation_id, enrollment_epoch, credential_generation),
    UNIQUE (realm_id, credential_id)
);

CREATE TABLE identity_issuer (
    issuer_id                 UUID        NOT NULL,
    trust_domain_id           UUID        NOT NULL,
    issuer_profile_id         VARCHAR(64) NOT NULL,
    chain_bundle_sha256       BINARY(32)  NOT NULL,
    state                     VARCHAR(32) NOT NULL,
    not_before_utc            TIMESTAMP   NOT NULL,
    not_after_utc             TIMESTAMP   NOT NULL,
    policy_revision           BIGINT      NOT NULL,
    row_version               BIGINT      NOT NULL,
    PRIMARY KEY (issuer_id),
    UNIQUE (trust_domain_id, issuer_profile_id, policy_revision)
);

CREATE TABLE identity_credential (
    realm_id                  UUID        NOT NULL,
    installation_id           UUID        NOT NULL,
    enrollment_epoch          INTEGER     NOT NULL,
    credential_id             UUID        NOT NULL,
    credential_generation     INTEGER     NOT NULL CHECK (credential_generation >= 1),
    issuer_id                 UUID        NOT NULL,
    certificate_sha256        BINARY(32)  NOT NULL,
    issuer_serial_key         BINARY(32)  NOT NULL,
    public_spki_sha256        BINARY(32)  NOT NULL,
    key_provider_profile_id   VARCHAR(64) NOT NULL,
    assurance_level           VARCHAR(32) NOT NULL,
    state                     VARCHAR(32) NOT NULL,
    status_version            BIGINT      NOT NULL,
    not_before_utc            TIMESTAMP   NOT NULL,
    not_after_utc             TIMESTAMP   NOT NULL,
    activated_at_utc          TIMESTAMP   NULL,
    retiring_at_utc           TIMESTAMP   NULL,
    denied_at_utc             TIMESTAMP   NULL,
    retired_at_utc            TIMESTAMP   NULL,
    row_version               BIGINT      NOT NULL,
    PRIMARY KEY (realm_id, credential_id),
    UNIQUE (certificate_sha256),
    UNIQUE (issuer_serial_key),
    UNIQUE (realm_id, installation_id, enrollment_epoch, credential_generation),
    FOREIGN KEY (realm_id, installation_id)
      REFERENCES identity_installation(realm_id, installation_id),
    FOREIGN KEY (issuer_id) REFERENCES identity_issuer(issuer_id)
);

CREATE TABLE identity_credential_status_event (
    realm_id                  UUID        NOT NULL,
    credential_id             UUID        NOT NULL,
    status_version            BIGINT      NOT NULL,
    previous_state            VARCHAR(32) NOT NULL,
    new_state                 VARCHAR(32) NOT NULL,
    reason_class              VARCHAR(64) NOT NULL,
    authorization_evidence_id UUID        NOT NULL,
    occurred_at_utc           TIMESTAMP   NOT NULL,
    deny_feed_sequence        BIGINT      NOT NULL,
    ca_revocation_state       VARCHAR(32) NOT NULL,
    audit_record_id           UUID        NOT NULL,
    PRIMARY KEY (realm_id, credential_id, status_version),
    FOREIGN KEY (realm_id, credential_id)
      REFERENCES identity_credential(realm_id, credential_id)
);

CREATE TABLE identity_activation (
    realm_id                  UUID        NOT NULL,
    activation_id             UUID        NOT NULL,
    credential_id             UUID        NOT NULL,
    nonce_digest              BINARY(32)  NOT NULL,
    expires_at_utc            TIMESTAMP   NOT NULL,
    state                     VARCHAR(32) NOT NULL,
    activated_at_utc          TIMESTAMP   NULL,
    row_version               BIGINT      NOT NULL,
    PRIMARY KEY (realm_id, activation_id),
    UNIQUE (nonce_digest),
    FOREIGN KEY (realm_id, credential_id)
      REFERENCES identity_credential(realm_id, credential_id)
);

CREATE TABLE identity_duplicate_incident (
    realm_id                  UUID        NOT NULL,
    incident_id               UUID        NOT NULL,
    installation_id           UUID        NOT NULL,
    credential_id             UUID        NOT NULL,
    detection_class           VARCHAR(64) NOT NULL,
    state                     VARCHAR(32) NOT NULL,
    first_seen_utc            TIMESTAMP   NOT NULL,
    last_seen_utc             TIMESTAMP   NOT NULL,
    resolution_class          VARCHAR(64) NULL,
    audit_record_id           UUID        NOT NULL,
    PRIMARY KEY (realm_id, incident_id),
    FOREIGN KEY (realm_id, credential_id)
      REFERENCES identity_credential(realm_id, credential_id)
);

CREATE TABLE identity_decommission_request (
    realm_id                  UUID        NOT NULL,
    decommission_id           UUID        NOT NULL,
    installation_id           UUID        NOT NULL,
    expected_epoch            INTEGER     NOT NULL,
    reason_class              VARCHAR(64) NOT NULL,
    state                     VARCHAR(32) NOT NULL,
    cleanup_state             VARCHAR(32) NOT NULL,
    requested_at_utc          TIMESTAMP   NOT NULL,
    completed_at_utc          TIMESTAMP   NULL,
    audit_record_id           UUID        NOT NULL,
    row_version               BIGINT      NOT NULL,
    PRIMARY KEY (realm_id, decommission_id),
    FOREIGN KEY (realm_id, installation_id)
      REFERENCES identity_installation(realm_id, installation_id)
);

CREATE TABLE identity_gateway_trust (
    trust_domain_id           UUID        NOT NULL,
    gateway_profile_id        VARCHAR(64) NOT NULL,
    gateway_identity_digest   BINARY(32)  NOT NULL,
    assertion_key_id          VARCHAR(64) NOT NULL,
    assertion_public_key      VARBINARY   NOT NULL,
    audience                  VARCHAR(128) NOT NULL,
    state                     VARCHAR(32) NOT NULL,
    policy_revision           BIGINT      NOT NULL,
    not_before_utc            TIMESTAMP   NOT NULL,
    not_after_utc             TIMESTAMP   NOT NULL,
    PRIMARY KEY (trust_domain_id, gateway_profile_id, policy_revision)
);
```

### 5.12.1 Schema invariants

- Certificate private keys, bootstrap plaintext, proxy credentials, raw TPM EK/attestation identity, internal addresses, and activity data do not exist in these tables.
- `certificate_sha256` and `issuer_serial_key` are globally unique across trust domains to prevent accidental dual mapping. If multiple issuer systems can collide in raw serial, `issuer_serial_key` is SHA-256 over canonical issuer identity plus serial.
- Every credential belongs to one realm/installation/epoch. A database constraint or transaction prevents active credential mapping to two realms.
- Status versions increase monotonically. State changes append events and do not overwrite audit history.
- Realm transfer creates new rows; it never updates realm on an existing credential/installation.
- Restore tooling validates that denied/revoked/decommissioned status versions and deny-feed sequence are not regressed.
- Exact certificate DER retention is a **HUMAN DECISION**. The minimum runtime may retain the public cert for validation/audit while applying approved access and retention.

## 5.13 Realm mapping and authority algorithm

```text
Input: TLS peer certificate or validated gateway assertion

1. Validate trust-domain ingress configuration and request route/audience.
2. Validate TLS/gateway cryptographic evidence.
3. Compute certificate_sha256 from exact peer/public cert.
4. Lookup identity_credential by certificate_sha256.
5. Require exactly one record; zero => UNKNOWN; more than one => integrity incident.
6. Join installation and realm using stored foreign keys.
7. Check credential state, status version, validity, epoch, installation state,
   realm state, issuer state, assurance policy, build/ring policy, and deny-cache freshness.
8. Construct sealed AuthenticatedDeviceContext.
9. Parse body under global bounds.
10. Reject any compatibility identity claim that disagrees.
11. Execute realm-keyed application operation.
12. Persist server-derived identity provenance with the operation/receipt/audit.
```

At no point does the algorithm ask which realm the endpoint says it belongs to.

## 5.14 Server cache rules

- Cache key: `(trust_domain_id, certificate_sha256)` or `credential_id` after a trusted mapping.
- Cache value includes realm, installation, epoch, state, status version, assurance, validity, issuer state, policy revision, and absolute expiry.
- Cache entries are immutable and replaced by higher versions.
- Negative/unknown results have a short bounded lifetime to avoid enrollment/activation races and enumeration abuse.
- A deny event invalidates relevant entries proactively.
- A stale cache beyond its `valid_until` does not authorize.
- Cache namespaces include environment/trust domain and cannot be shared accidentally across realms without realm in the value and all downstream keys.
- Restore/startup begins with an empty cache and refuses traffic until authoritative state or a signed/fresh snapshot is available.

## 5.15 Certificate and trust-bundle rollout contract

A trust-bundle artifact binds:

```text
trust_domain_id
bundle_revision
root/intermediate public certificate digests
server certificate profile
approved client issuer/profile IDs
not_before / expires_at
algorithm allowlist
revocation policy profile
previous/current/next rollover relationships
emergency deny entries
release compatibility
signature/provenance
```

Consumers deploy before producers. Endpoint server-trust bundles support old + new server chain before the server switches. Ingress/gateway client-trust bundles support old + new client issuer before endpoints receive new credentials. Rollback republishes previously approved semantics at a higher bundle revision; revisions never decrement.

---

# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility

## 6.1 Installation identity lifecycle

```text
NOT_INSTALLED
  -> INSTALLED_UNSPECIALIZED
  -> SPECIALIZED_UNENROLLED
      -> BOOTSTRAP_PENDING
      -> KEY_PENDING
      -> ENROLLMENT_PENDING
      -> ACTIVE
      -> DISABLED
      -> SAFETY_HOLD

ACTIVE
  -> RENEWAL_PENDING -> ACTIVE
  -> DUPLICATE_HOLD
  -> SUSPENDED
  -> DECOMMISSION_PENDING
  -> DECOMMISSIONED
  -> REENROLL_PENDING(new epoch)

DUPLICATE_HOLD / SUSPENDED / SAFETY_HOLD
  -> DECOMMISSIONED
  -> REENROLL_PENDING(new epoch, explicit authorization)

DECOMMISSIONED is terminal for that realm/epoch.
```

Collection and upload permissions:

| State | Enrollment API | Control/policy | Collection | Upload | Status/recovery endpoint |
|---|---:|---:|---:|---:|---:|
| `SPECIALIZED_UNENROLLED` | one-use only | no ordinary policy | no | no | limited enrollment diagnostics |
| `ENROLLMENT_PENDING` | retry same request | no | no | no | limited |
| `ACTIVE` | renewal only | yes | only under valid privacy policy | yes | yes |
| `SUSPENDED` | recovery only | emergency narrowing | default no new collection | no | limited signed status |
| `DUPLICATE_HOLD` | explicit recovery only | emergency narrowing | no | no | limited |
| `SAFETY_HOLD` | explicit recovery only | last valid narrowing only | no affected capability | no | limited |
| `DECOMMISSIONED` | new independent authorization only | no | no | no | generic rejection |

## 6.2 Credential lifecycle

```text
KEY_CREATED
  -> REQUEST_RESERVED
  -> ISSUANCE_PENDING
      -> ISSUANCE_UNKNOWN
      -> ISSUED_STAGED
      -> ISSUANCE_REJECTED
  -> ACTIVATION_PENDING
      -> ACTIVE
      -> STAGED_EXPIRED

ACTIVE
  -> RETIRING -> RETIRED
  -> SUSPENDED
  -> DUPLICATE_HOLD
  -> DENIED
  -> REVOKED
  -> EXPIRED

SUSPENDED may return to ACTIVE only through an explicit authorized recovery
that preserves the same uncompromised key; default recovery creates a new key.
DENIED, REVOKED, EXPIRED, RETIRED, DUPLICATE_HOLD, and STAGED_EXPIRED
never become ACTIVE by an ordinary state edit.
```

`EXPIRED` can be computed from certificate validity, but a durable status event records the authorization effect when observed/processed. A certificate may be `REVOKED` by CA while UAM state is already `DENIED`; both are retained.

## 6.3 Bootstrap authorization lifecycle

```text
DRAFT
  -> ISSUED
      -> RESERVED(request_id)
          -> CONSUMED
          -> RELEASED_RETRYABLE (only before CA side effect and within policy)
          -> CONFLICT
      -> EXPIRED
      -> REVOKED

CONSUMED / EXPIRED / REVOKED / CONFLICT are terminal.
```

The token is considered consumed when the server has durably reserved the one successful enrollment lineage, not merely after the endpoint receives a certificate. This prevents replay during a response loss. Recovery reconciles the original request.

## 6.4 Enrollment transaction/saga boundaries

A CA call cannot generally participate in the UAM relational transaction. Use a durable saga:

### Transaction E1 — reserve enrollment

1. Strictly validate request and proof outside transaction under safe bounds.
2. Begin transaction.
3. Load authorization by token digest and lock/compare version.
4. Validate state/realm/audience/expiry/attempt/assurance/profile.
5. Create or load idempotent installation/epoch/request/credential placeholder.
6. Set authorization `RESERVED`, request `ISSUANCE_PENDING`, credential `REQUEST_RESERVED`.
7. Commit with audit and issuance outbox/job.

### External step E2 — issue certificate

1. Leased worker loads exact request and issuer profile.
2. Submits CSR using stable CA request identifier.
3. On success, verifies returned certificate public key/profile/chain/ID.
4. On timeout/ambiguous result, records `ISSUANCE_UNKNOWN` and starts reconciliation; it does not submit a different CSR automatically.

### Transaction E3 — stage certificate

1. Compare request/credential version and issuer result.
2. Persist public certificate/digests, assurance, validity, activation nonce digest.
3. Set credential `ISSUED_STAGED`, request complete, authorization `CONSUMED`.
4. Commit audit.

### Transaction E4 — activate

1. Authenticate staged certificate at TLS/gateway boundary.
2. Begin transaction; lock activation/credential/installation.
3. Validate one-use nonce, state, epoch, status, policy, duplicate state.
4. Set credential/installation active and activation consumed.
5. Commit audit/status version.
6. Return success.

A crash or retry at every boundary returns the same result. No transaction marks `ACTIVE` before the mTLS activation proof commits.

## 6.5 Renewal transaction boundaries

### R1 — reserve generation

- Current credential must authenticate and be active/allowed.
- New generation is `current + 1`; new key/SPKI must be distinct.
- Reserve request/credential idempotently with old/new key proofs and policy/assurance.

### R2 — issue and stage

Same external issuer reconciliation as enrollment. Both old and new credentials map to the same realm/installation/epoch.

### R3 — activate and overlap

- mTLS with new certificate proves possession.
- Transaction marks new `ACTIVE`, old `RETIRING`, records overlap expiry/status versions, emits deny-cache update if needed.
- During overlap, both map to the same context; the old credential cannot start another renewal generation.

### R4 — retire old

- Scheduled/reconciled transaction sets old `RETIRED`, emits rapid deny, and requests CA revocation if policy requires.
- Endpoint deletes old local key after observing durable new activation and no in-flight dependency.

A failed new key does not revoke the current valid credential unless compromise is suspected. A security-significant renewal conflict places the installation in `SAFETY_HOLD`.

## 6.6 Revocation and connection lifecycle

```text
Admin/automation command
  -> AUTHORIZED_STATUS_TRANSACTION
  -> RAPID_DENY_SEQUENCE_COMMITTED
  -> INGRESS/GATEWAY CACHE INVALIDATION
  -> NEW REQUESTS REJECTED
  -> CONNECTION CLOSE SIGNAL (best effort)
  -> CA REVOCATION REQUESTED
      -> PUBLISHED/CONFIRMED
      -> FAILED/PENDING (UAM deny remains effective)
  -> INCIDENT/CLEANUP/REENROLL OR DECOMMISSION
```

Request-level middleware rechecks status at each stream/request. A pooled connection cannot bypass a later deny. Exact maximum deny propagation and cache age are **HUMAN DECISION** acceptance values; the test uses replaceable estimates and requires zero authorization after the declared bound.

## 6.7 Duplicate/clone lifecycle

```text
NORMAL
  -> DUPLICATE_SUSPECTED
      -> suspicion disproved -> NORMAL
      -> DUPLICATE_CONFIRMED
          -> credential/install DUPLICATE_HOLD
          -> all copies rejected
          -> evidence preserved (privacy-minimal)
          -> operator selects recovery disposition
              -> all decommissioned
              -> one installation re-enrolled with new epoch/key;
                 every old copy stays denied
```

The system never chooses “the latest IP,” “the first caller,” or “the machine with a matching hostname” as the legitimate clone. Those are not reliable authority.

## 6.8 Clock/offline state machine

```text
CLOCK_TRUSTED
  -> CLOCK_UNCERTAIN (small jump, time service transition, resume)
      -> authenticated server-time validation -> CLOCK_TRUSTED
      -> timeout/large inconsistency -> CLOCK_UNTRUSTED

CLOCK_UNTRUSTED
  -> no new enrollment/activation/renewal/upload authorization
  -> preserve minimized unacknowledged data
  -> collection only while independent signed privacy authority remains valid
  -> explicit time remediation + fresh authenticated validation
  -> CLOCK_TRUSTED
```

A local clock adjustment is an enterprise/OS operation, not something the UAM agent performs.

## 6.9 Network connection state machine

```text
NETWORK_UNKNOWN
  -> PROFILE_SELECTED(direct | explicit_proxy | pac)
  -> SERVER_TRUST_HANDSHAKE
      -> SERVER_TRUST_FAILED -> NETWORK_HOLD
      -> CLIENT_CERT_REQUESTED
          -> CERT_NOT_REQUESTED -> COMPATIBILITY_FAILURE
          -> MTLS_ESTABLISHED
              -> DEVICE_STATUS_AUTHORIZED
                  -> READY
              -> DEVICE_REJECTED -> IDENTITY_HOLD

READY
  -> VPN/ROUTE/PROXY/DNS/RESUME CHANGE
      -> drain/close pooled connection
      -> PROFILE_SELECTED

TLS_INSPECTION_DETECTED
  -> origin mTLS unsupported
  -> approved bypass/profile? yes -> reconnect
  -> otherwise NETWORK_HOLD; never shared-secret fallback
```

## 6.10 Decommission/transfer state machine

```text
ACTIVE_OLD_REALM
  -> TRANSFER_AUTHORIZED
  -> OLD_CREDENTIALS_DENIED
  -> OLD_INSTALLATION_DECOMMISSIONED
  -> ENDPOINT_CLEANUP
      -> CONFIRMED
      -> UNCONFIRMED (record risk; old remains denied)
  -> NEW_BOOTSTRAP_ISSUED_FOR_NEW_REALM
  -> NEW_INSTALLATION/KEY/EPOCH/CREDENTIAL
  -> ACTIVE_NEW_REALM
```

Any request from the old certificate after transfer is denied. The new realm does not gain access to old realm data or audit by virtue of the transfer.

## 6.11 Issuer and gateway rollover

### 6.11.1 Issuer rollover

1. Publish new root/intermediate to endpoint server-trust/control bundle and ingress client-trust validators while old remains valid.
2. Deploy consumers/validators before issuing new client credentials.
3. Issue canary credentials and test direct, gateway, proxy, offline, renewal, and revocation paths.
4. Begin new issuer for a small ring; retain old issuer acceptance for existing active credentials.
5. Renew fleet with jitter and rate limits.
6. Verify no active supported credential remains only on old issuer beyond the approved window.
7. Deny old issuer for new enrollments, then retire trust after all rollback/support conditions close.
8. Decommission CA under a documented PKI runbook, retaining required audit/revocation evidence.

### 6.11.2 Gateway assertion key rollover

- Backend accepts current + next assertion public keys under higher policy revision.
- Gateway begins signing with next key after backend deployment.
- Previous key remains accepted only for the maximum assertion/retry window.
- Compromise triggers immediate deny of the key/profile and direct/L4 fallback only if previously proved; no unsigned header fallback.

## 6.12 Release rollout and compatibility

- Identity protocol consumers deploy before producers.
- Endpoint and server support windows are contract-family-specific; exact old/new majors and duration are **HUMAN DECISION** and measured fleet inputs.
- Same signed endpoint digest is promoted through rings; environment does not rebuild it.
- Product ceiling controls which key/provider/network profiles can execute. Realm policy can only narrow.
- An endpoint with unsupported identity contract or issuer profile is disabled with finite health; it does not coerce fields, ignore unknowns, or use a shared secret.
- Rollback to prior behavior is a new higher-revision release/control artifact. It cannot re-enable a revoked issuer/key/profile or accept a downgraded protocol silently.
- Long-offline endpoints require inventory evidence before a compatibility window is retired. Expiry or unsupported profile fails closed.

## 6.13 Compatibility rule matrix

| Change | Compatible behavior | Stop/re-enroll condition |
|---|---|---|
| Endpoint application patch | Same installation/epoch/credential may continue if release and transport profiles remain supported | Release authorization fails, key access/ACL changes, or protocol major unsupported |
| New credential generation | Same installation/epoch/realm; stable event/batch identity remains | New key proof/profile fails or old credential denied |
| New issuer/intermediate | Dual trust during controlled rollover | Unknown/untrusted issuer or stale bundle |
| New root | Consumer-first trust bundle then issuance | Root absent, name/trust mismatch, rollback/freeze |
| Gateway version | Same signed assertion contract/policy and mTLS identity | Header/assertion semantic differential or status freshness failure |
| Proxy/VPN change | Reconnect/re-authenticate; same installation/event identities | TLS inspection/no CONNECT/unsupported auth/path |
| Realm policy narrowing | Outstanding work cancelled/discarded as required; identity remains same realm | Realm disabled, assurance no longer allowed, issuer/profile denied |
| Realm ownership transfer | New enrollment and usually new installation | In-place realm mutation prohibited |
| OS/TPM firmware change | Continue only if key works and profile remains allowed; record bounded capability evidence | Key unavailable, attestation/profile no longer valid, duplicate/vTPM concern |
| VM restore/snapshot | Continue only when identity continuity and no clone/replay conflict are proved | Epoch/state regression, duplicate use, certificate restored after deny |
| Nonpersistent rebuild | New per-boot profile only if separately accepted | Shared/restored identity always rejected |


---

# 7. Security/privacy threat and failure register

## 7.1 Review method and ownership boundary

The register below is normative for implementation planning. An “owner” is an accountable function, not an invented organizational assignment. Every production-capable profile MUST assign a named person or team to that function before activation. A threat is not closed merely because TLS or a TPM is present; the named detection, containment, recovery, cleanup, and test must exist for the exact deployment profile.

| ID | Trigger, threat, or failure | Detection | Immediate containment | Recovery | Cleanup and evidence | Accountable owner function | Falsifying test | Residual risk |
|---|---|---|---|---|---|---|---|---|
| T-01 | Bootstrap authorization is copied from deployment tooling, command history, log, ticket, or image | Server sees second redemption, wrong deployment binding, wrong nonce, or scanner finds a planted bootstrap canary | Atomically mark authorization consumed/denied; suspend any staged credential; stop further enrollments from the affected deployment batch | Issue new one-use authorization through an approved channel after incident review | Remove exposed artifacts under retention authority; retain digest, audit, and incident facts without token value | Enrollment Authority and Incident Response | Plant a fictional token in every prohibited sink; replay before and after first redemption | A token may be stolen and redeemed before the legitimate device; deployment-channel assurance remains external to UAM |
| T-02 | One authorization is redeemed concurrently by two installations | Serializable consume transaction, distinct request/installation/key digests for one authorization | One reservation wins; all conflicting requests enter `BOOTSTRAP_REPLAY_HOLD`; no certificate becomes active automatically | Human or managed-deployment workflow identifies the intended installation and issues a fresh authorization | Revoke/deny any uncertain issuance; remove staged certificates and record all request IDs | Identity Service Owner | Barrier-start two enrollment requests with the same authorization | CA side effects can occur before the server knows which request won; issuance reconciliation is required |
| T-03 | Enrollment request is replayed after timeout | Stable request ID, CSR digest, key-thumbprint, and authorization digest match a prior request | Return the prior state/result; never create a new installation, epoch, or credential generation | Resume the existing saga; reconcile with CA by request correlation | Remove abandoned local request files; retain value-free saga evidence | Identity Service Owner | Drop responses at each enrollment boundary, then retry identical and modified requests | An external CA without reliable request correlation can leave uncertain issuance requiring deny/revoke cleanup |
| T-04 | CA issues a certificate, but UAM crashes before staging or activation | Reconciliation job finds CA request `ISSUED` with UAM request `ISSUANCE_PENDING` or stale lease | Certificate is not authorized at ingress until explicit activation; bootstrap remains non-reusable | Retrieve by CA request ID, validate exact public key/profile, stage, prove possession, activate; otherwise revoke | Revoke unmatched issuance; delete temporary response files; record issuer serial/fingerprint only in protected store | Enterprise PKI Authority with Identity Service Owner | Kill server after CA issuance and before every UAM state transition | CA APIs and logs may not support perfect idempotency; operational reconciliation is mandatory |
| T-05 | Endpoint claims TPM assurance solely from provider name or request field | Server compares requested profile with attestation result and lab-admitted provider facts; missing evidence is visible | Downgrade is not automatic; request is rejected or placed in assurance hold | Re-enroll under a human-approved lower-assurance authorization, or correct TPM/CA configuration | Delete rejected staged credential and attestation artifacts according to approved retention | Product Security Authority | Submit software key while claiming Platform KSP/attested assurance | Provider and key properties do not prove OS integrity or absence of privileged misuse |
| T-06 | TPM-backed key cannot sign after reboot, servicing, firmware, ACL, or ownership change | Startup challenge-sign self-test; CNG error category; credential-health transition | Stop upload/collection as policy requires; do not create software fallback silently | Repair ACL/provider/TPM state or perform controlled re-enrollment with a new epoch/key | Retire unusable credential; delete UAM-owned orphan key containers only by manifest and handle identity | Endpoint Platform Authority | Reboot, update, change ACL, clear/disable simulated TPM only in disposable lab | TPM reset or hardware replacement can make recovery impossible without re-enrollment |
| T-07 | Software private key is copied, restored, or extracted by a privileged actor | Duplicate-use signals, key-access audit where available, image scan, credential use from incompatible continuity facts | Put credential in `DUPLICATE_HOLD` or `DENIED`; close active sessions; disable lower-assurance profile if systemic | Re-enroll legitimate endpoint with new epoch/key after ownership verification | Revoke old credential and remove copied UAM state from managed images/endpoints | Product Security Authority and Endpoint Platform | Clone software-key VM and attempt simultaneous and sequential authentication | Sequential use with similar network/device facts can evade automated duplicate detection; A1 remains lower assurance |
| T-08 | Code exports a private key as PFX/PKCS#12/PEM or includes it in diagnostics | Architecture test/API guard, source scan, package scan, runtime file/handle monitor, planted export attempt | Block build/release; stop affected ring; deny exposed credentials | Remove export path, rotate all potentially exposed credentials, rerun key and sink campaigns | Delete private-key artifacts using incident-approved process; preserve hashes and access evidence, never key bytes | Product Security and Release Authority | Mutate code to call private-key export APIs and verify CI/runtime gate fails | A local administrator or memory compromise can still invoke cryptographic operations without exporting bytes |
| T-09 | Machine-key ACL permits ordinary users, User Hosts, Task Hosts, or unrelated services | Effective-access test against key container and sign operation; process-token matrix | Fail startup/enrollment; do not broaden ACL as a workaround | Installer repairs descriptor under privileged, audited operation; re-run access campaign | Record descriptor digest/effective result, not environment identities; remove test principals | Windows Security Owner | Attempt open/sign/delete/export from every process/security context | CNG/TPM/provider updates may alter object layout or access semantics |
| T-10 | Golden image contains installation ID, realm, bootstrap token, certificate, private key, endpoint DB, cursor, outbox, or prior evidence | Offline image scanner and first-boot `GOLDEN_IMAGE_CONTAMINATION` self-check | Refuse service activation/enrollment; block image promotion | Rebuild from a pre-enrollment base; do not “clean” an identity-bearing image by ad hoc deletion | Destroy contaminated image versions and snapshots under image-governance policy; retain scanner report | Endpoint Image Authority | Seal images at every enrollment state and verify only pristine state passes | Hidden hypervisor snapshots, backup layers, or vendor capture mechanisms can retain identity state |
| T-11 | Two live machines use one certificate/key due to clone or restore | Overlapping authenticated sessions, mutually incompatible continuity nonces, activation/heartbeat conflict, managed-image evidence | Credential enters `DUPLICATE_HOLD`; both copies fail closed; no automatic winner | Enterprise management proves which installation is legitimate; revoke old credential and re-enroll selected endpoint | Remove identity state from all clones/snapshots; document uncertainty and any custody received before hold | Identity Service Owner and Incident Response | Clone after activation, start both, alternate requests, vary NAT/VPN | NAT and normal mobility make IP/device heuristics unreliable; false positives require a safe support process |
| T-12 | Sequential clone alternates use and avoids overlap detection | Monotonic installation continuity challenge, enrollment-epoch/state regression indicators, management reconciliation, anomaly review | If evidence is strong, `DUPLICATE_HOLD`; otherwise mark reduced confidence without inventing attribution | Managed inventory/owner investigation and destructive re-enrollment | Revoke suspected credential after authority decision; purge cloned identity state | Product Security Authority | Alternate two clones with no overlapping network sessions and restored local state | Research cannot guarantee detection without a trusted external device inventory or non-clonable platform control |
| T-13 | VM snapshot restores an old but still cryptographically valid credential/state | Server sees stale epoch/generation, repeated continuity challenge, retired credential, or rollback counter | Reject stale epoch/generation; keep newer state authoritative; do not reopen retired credential | Re-enroll under higher epoch after owner verifies restore intent | Remove restored stale state and revoke any reactivated credential; update VM recovery runbook | Virtualization/Endpoint Platform Authority | Snapshot before renewal/revocation, advance state, restore, authenticate | A snapshot taken after latest state can still create a clone; vTPM portability depends on platform controls |
| T-14 | vTPM/key material is copied with a VM or host administrator duplicates the VM | Platform inventory/attestation evidence changes, duplicate-use hold, virtualization event evidence | Fail or reduce assurance according to the admitted platform profile; never call it physical-TPM assurance | Re-enroll with a new installation/epoch on a supported protected VM profile | Retire copied vTPM-backed credentials and remove snapshots/clones | Virtualization Security Authority | Clone/migrate/restore on each claimed vTPM platform | Hypervisor and cloud-control-plane compromise remains outside endpoint TPM containment |
| T-15 | Nonpersistent VDI instances share a certificate, database, or installation ID | Golden-image scan, same credential used by many boot instances, nonpersistent capability flag | Reject as unsupported; disable identity profile for the pool | Use separately approved per-boot enrollment with no durable backlog, or exclude the platform | Remove shared identity from master image and pool; verify recompose cleanup | VDI Platform Owner | Boot many clones from one image and check identity uniqueness and teardown | Per-boot issuance/revocation scale and short session lifetime can be operationally expensive |
| T-16 | Endpoint sends a body/header `realmId`, `deviceId`, or certificate subject that conflicts with server mapping | Contract validator compares claims with authenticated context; realm-negative tests and audit code | Reject conflict; use none of the conflicting values for cache/store/routing | Correct endpoint contract or server mapping through governed admin action | Remove poisoned cache entries/quarantine affected requests; retain finite conflict code | Realm/Identity Service Owner | Same certificate with every body/header realm permutation | A compromised identity database or admin mutation can still map a credential to the wrong realm |
| T-17 | Cache key omits realm, credential status revision, epoch, or trust-domain version | Architecture tests and cross-realm collision corpus; cache-hit audit in T1 lane | Disable cache/profile; clear affected cache; reject uncertain requests | Fix composite key and version; replay only from durable custody under original authenticated context | Purge cache and verify no persisted cross-realm effect | Server Architecture Owner | Deliberately create identical installation/credential UUIDs in different fictional realms | Third-party caches/proxies can introduce hidden keys unless bounded by topology and tests |
| T-18 | Relational query/store update omits realm predicate or accepts payload realm | Database architecture tests, generated query guards, row-level negative tests, audit reconciliation | Block deployment or disable affected operation; quarantine uncertain data | Repair query/constraint and execute governed data-integrity review | Correct only through audited migration; do not silently reassign records | Data/Realm Isolation Owner | Mutation removes realm predicate from every identity and ingestion query | ORM/raw SQL/tooling changes can bypass static checks; runtime negatives remain mandatory |
| T-19 | Credential is valid by chain but unknown to UAM registration | No active `(issuer, serial/fingerprint)->credential` mapping | Reject as `IDENTITY_UNKNOWN`; never auto-register from subject/SAN | Enroll through authorized bootstrap or reconcile a known staged issuance | Revoke stray CA issuance if it was intended for UAM; investigate template misuse | Enterprise PKI and Identity Service Owner | Present arbitrary lab-CA cert with allowed EKU/chain | CA compromise or overly broad template can create many unknown certificates, causing denial-of-service/log pressure |
| T-20 | Credential is expired/not-yet-valid, but local clock or server skew differs | Server-authoritative time, TLS validation result, clock-confidence telemetry | Reject new authorization; stop upload; do not extend validity client-side | Correct time service or issue/activate a new valid credential under approved recovery | Retire expired credential and clear stale connection pools; preserve bounded clock evidence | Operations/SRE and PKI Owner | Move endpoint/server clocks within and beyond proposed tolerance | Server time or CA signing time can be wrong; exact tolerance is a human risk decision |
| T-21 | CRL or OCSP reports revoked credential | Chain validator result plus UAM status lookup | Reject and close connection where supported; status remains denied even if revocation responder later fails | New key/credential and explicit re-enrollment; never un-revoke same credential | Retain revocation/audit according to PKI policy; retire trust only after outstanding lifetimes | Enterprise PKI Authority | Revoke while offline/online, refresh CRL/OCSP, reuse pooled connection | Revocation distribution can be stale; UAM rapid deny must remain independent |
| T-22 | Rapid deny status changes while HTTP/2 or HTTP/3/TLS connection remains open | Per-request status revision check and connection registry keyed to credential | Reject next request within freshness bound; send drain/close/abort where safe | Reconnect only with active credential/status | Evict status/cache/connection entries for credential; retain audit of deny revision | Ingress/Gateway Owner | Deny after first request on a persistent multiplexed connection and send concurrent requests | In-flight requests can cross the deny instant; exact custody boundary and freshness are operational decisions |
| T-23 | Status cache is stale or unavailable | Cache age/revision/source health, negative-path metric, signed/status-store version | Fail closed when freshness bound is exceeded; do not “temporarily trust” a cert | Restore authoritative store/cache replication; controlled re-enable after freshness proof | Flush stale entries; reconcile denied credentials and accepted requests during incident window | Identity Service Owner and SRE | Isolate status store, freeze cache, change credential to denied | Strict fail-closed behavior can stop the fleet; availability architecture must be sized and drilled |
| T-24 | CRL/OCSP endpoint is unavailable | Validator categorizes network/freshness/invalid response separately | Follow approved profile: chain/revocation uncertainty fails closed for enrollment/renewal; upload requires explicit policy and rapid UAM deny remains mandatory | Restore publication/responder; deploy fresh CRL; validate from every ingress/gateway zone | Remove stale cached test responses; retain freshness timestamps/digests | Enterprise PKI Operations | Block responder/CDP, expire cached CRL, test direct and gateway paths | Hard-fail revocation can cause widespread outage; soft-fail would accept revoked credentials and is not chosen silently |
| T-25 | CA signing key or issuer profile is compromised | CA incident alert, unauthorized issuance, audit mismatch, key custody event | Stop enrollment/renewal; deny compromised issuer/profile; preserve existing credentials only if formally risk-accepted and distinguishable | Activate preplanned replacement issuer/root; re-enroll/renew fleet with fresh keys; rotate gateway/server trust | Decommission compromised CA according to PKI plan; publish revocation; preserve forensic evidence | Enterprise PKI Authority and Incident Commander | Lab CA compromise drill with unknown issuance and trust withdrawal | Fleet-wide re-enrollment may exceed outage/support capacity; root compromise is high-cost |
| T-26 | Trust-bundle/root/intermediate rollover is deployed producer-first | Endpoint/server reports unknown chain; canary ring failure | Stop issuance/promotion; continue old trusted profile if still safe and unexpired | Deploy consumer trust first, canary, then issue; rollback by higher-revision artifact | Remove prematurely issued test credentials and stale trust entries | Release Authority and PKI Owner | Issue from new chain before one ingress/endpoint has trust and verify rejection | Long-offline devices may miss trust updates and require recovery/re-enrollment |
| T-27 | Renewal storm or CA outage near expiry | Renewal backlog/age distributions, issuance rate, remaining validity buckets | Apply server-directed jitter/backoff and admission control; stop new collection before identity expiry if required | Restore CA; prioritize by remaining validity/realm without weakening assurance; issue fresh key generations | Reconcile abandoned requests and revoke duplicate issuances | PKI Operations and SRE | Simulate at least 6,000 fictional installations with synchronized renewal eligibility and CA throttling | Synthetic count without real network/CA/SLO data is not capacity proof |
| T-28 | Renewal activates new cert but old connection/key remains used indefinitely | Credential-generation status, connection inventory, overlap deadline | Reject retired generation after approved overlap; drain old connections | Endpoint reloads active key/cert and proves new generation; re-enroll if key unavailable | Delete old UAM key only after server activation/audit and rollback conditions close | Endpoint Identity Owner | Kill endpoint/server at every renewal step and keep old connection alive | Certificate selection behavior differs by HTTP stack and connection pooling; exact .NET/Windows profile must be proved |
| T-29 | Gateway accepts client-supplied `X-Forwarded-Client-Cert` or identity header | Header-stripping negative tests, assertion-verification failure, ingress topology check | Reject request and disable route/profile; never fall back to unsigned header | Correct gateway sanitizer and backend trust policy; rotate assertion key if exposure occurred | Purge affected gateway/backend logs under policy; invalidate assertions and caches | Gateway Security Owner | Send duplicate/case/whitespace/folded/smuggled identity headers through public listener | Future proxy/parser differentials can reintroduce smuggling; patch qualification is recurring |
| T-30 | L7 gateway forwards correct identity for wrong request/body | Backend verifies short-lived assertion over method, authority, path, content digest, credential, realm, nonce, and policy revision | Reject mismatch/replay; no body-derived identity | Regenerate assertion only after gateway validates the exact incoming request | Expire nonce/replay entries and preserve finite failure evidence | Gateway and Backend Identity Owners | Swap bodies/paths/methods between concurrent requests; replay assertion | Canonicalization bugs and streaming bodies add complexity; L7 remains conditional |
| T-31 | Gateway assertion signing key is compromised | Signature anomalies, key custody alert, unexpected issuer/key ID | Deny key/profile immediately; stop L7 route; direct/L4 path only if already approved and tested | Rotate to pre-distributed next key and rebuild trust; investigate all assertions in exposure window | Remove compromised key material and revoke gateway machine identity | Gateway Security and Signing Authority | Replace key/sign arbitrary assertions in lab, then exercise emergency rollover | A compromised gateway can also misuse legitimately validated sessions; backend assertion checks limit but do not eliminate this risk |
| T-32 | Backend is reachable directly and accepts spoofed headers without gateway mTLS | Network-policy test, backend checks gateway credential/trust-domain and assertion | Reject direct connection; firewall/service mesh policy blocks route | Restore topology and gateway credential; rerun end-to-end negative tests | Remove temporary bypasses and stale firewall rules | Network/Gateway Owner | Connect directly to backend with correct-looking headers/assertion but no gateway mTLS | Misconfigured alternate listeners or debug ports can bypass the intended boundary |
| T-33 | Explicit proxy does not support CONNECT, client certificate pass-through, or required auth | Finite network profile result, CONNECT/TLS handshake error, proxy challenge category | `NETWORK_HOLD`; do not send bootstrap token/body over downgraded or untrusted path | Approve direct route, compatible CONNECT proxy, or future asymmetric application profile | Remove test proxy credentials/config and close pools | Customer Network Owner with Endpoint Networking Owner | Test no-proxy, CONNECT, auth challenge, deny, timeout, and malformed proxy responses | Proxy products and policies vary; a lab result is not universal customer compatibility |
| T-34 | TLS inspection substitutes the origin certificate and terminates mTLS | Endpoint server-name/chain check and absence of origin certificate request; gateway fingerprint/profile evidence | Stop direct mTLS; never trust inspection CA as UAM origin merely because Windows trusts it | Establish documented bypass or separately approved application-level proof-of-possession profile | Remove inspection test roots/profiles from lab; retain only categorical evidence | Network Security Authority and Product Security | Intercept TLS with lab inspection proxy and attempt origin enrollment/upload | Some inspection products can emulate client cert behavior but shift trust to the appliance; this needs an explicit architecture decision |
| T-35 | Proxy/PAC/WPAD selects an attacker-controlled proxy or changes between requests | Effective WinHTTP proxy classification, endpoint name/chain validation, route-change event | TLS server validation prevents disclosure; close/recreate connection on profile change | Correct enterprise proxy/PAC policy; use explicit approved profile | Remove lab PAC/proxy state and credentials; do not record internal URI | Customer Network Owner | Malicious PAC result, proxy failover, name mismatch, DNS manipulation | A compromised enterprise root store can defeat server authentication; root governance is external but critical |
| T-36 | VPN connect/disconnect changes route, DNS, proxy, MTU, or source address mid-upload | Network-change event, failed health/handshake, bounded upload retry state | Drain connection, preserve unacknowledged batch, re-resolve/re-authenticate | Reconnect under current approved network profile; resume stable batch identity | Close stale sockets and clear temporary network state; no duplicate business effect | Endpoint Networking and Ingestion Owners | Toggle full/split tunnel during enrollment, upload, renewal, and receipt loss | VPN products, always-on behavior, and route policy differ across estates |
| T-37 | TLS server certificate hostname/chain validation is disabled or custom callback accepts all | Architecture/source tests, runtime negative hostname/chain corpus | Block build/release; disable affected profile and rotate any exposed bootstrap/credential | Restore platform validation plus explicit narrow trust policy where required | Remove test roots/certs and inspect exposure window | Product Security and Release Authority | Mutate callback to accept any server certificate; present wrong-name/untrusted cert | Enterprise trust-store compromise or wrongly trusted inspection root remains possible |
| T-38 | Certificate parser/chain builder accepts malformed, oversized, duplicate, or ambiguous identity data | Bounded parser limits, fuzz corpus, exact profile validator, timeout/allocation metrics | Reject before DB/cache/status processing; rate-limit source | Patch/runtime update, narrow profile, reissue only valid credentials | Remove malformed test certs and preserve minimal reproducer | Ingress Security Owner | Fuzz chains/extensions/SANs/serials and submit oversized inputs | Native TLS/crypto stack vulnerabilities remain a dependency risk |
| T-39 | Client certificate subject/SAN is used as realm, device, or authorization | Code/architecture rule and test certs with misleading subjects/SANs | Reject unless credential mapping exists; ignore display fields for authority | Correct mapping logic and reissue only if profile itself is wrong | Purge derived cache/index entries; audit all subject-based decisions | Identity Service Owner | Issue same subject/SAN to many certs across realms and vary body claims | Administrators may still read display strings and make incorrect manual decisions; UI must label them non-authoritative |
| T-40 | Enrollment/identity diagnostics leak realm names, device names, cert bytes, proxy URLs, bootstrap tokens, keys, or internal addresses | Schema allowlist, exact canaries, support-bundle scanner, cardinality lint | Block evidence publication/release; stop affected diagnostic feature | Replace with opaque IDs, finite states, hashes/digests only where approved | Delete contaminated artifacts under incident/records authority | Privacy Engineering and Support Owner | Plant markers in every identity/network field and exercise success/failure/crash/support paths | OS, EDR, WER, hypervisor, and privileged tools can collect memory outside UAM control |
| T-41 | Metrics create unbounded per-realm/device/cert/proxy cardinality or expose rare populations | CI metric-schema lint, runtime series budget, label inventory | Disable offending metric/label; preserve finite health counters | Aggregate by fixed profile/outcome/build ring; move detailed evidence to access-controlled records | Delete high-cardinality time series according to retention policy | SRE with Privacy/Data Governance | Generate 6,000 fictional identities/realms and verify bounded series count | Rare combinations can still identify small populations; dashboard access and retention are human decisions |
| T-42 | Database restore resurrects revoked/decommissioned credential or lowers epoch/status revision | Restore readiness check compares monotonic security ledger/backup point with external deny journal and current audit | Keep restored service isolated; deny all device auth until reconciliation completes | Replay append-only security changes or restore a newer consistent set; verify every active credential | Remove stale cache replicas and publish readiness evidence | Database/Identity SRE | Back up active state, deny/revoke, restore old snapshot, attempt authentication | Disaster recovery depends on RPO/RTO and independent deny-record durability not decided here |
| T-43 | Decommissioned or lost device returns after long offline period | Credential/installation status lookup and epoch mapping | Reject; no offline grace or automatic reactivation | New enrollment only after ownership and policy decision | Keep old credential denied; remove endpoint state when recovered | Asset/Realm Governance and Identity Operations | Decommission while endpoint offline, restore connectivity, replay queued batches | Unacknowledged local data may remain; deletion/transfer authority and custody consequences are separate decisions |
| T-44 | Ownership transfer changes `realm_id` in place or lets new realm see old data | Admin contract forbids update; audit and realm-negative query tests | Reject mutation; decommission old installation first | New bootstrap/new installation/epoch/key/credential in new realm; separate governed data migration if approved | Remove old realm-bound endpoint state and keep old credential denied | Realm Governance Authority | Attempt API/DB mutation and use old/new credentials against both realms | Physical device continuity across realms is business context, not authentication authority |
| T-45 | Lower-assurance exception remains active after expiry, scope change, or risk decision | Exception registry with owner, scope, expiry, policy revision, and active-fleet inventory | Stop new A1 enrollment/renewal; deny or schedule transition according to approved policy | Upgrade to TPM-backed profile or formally renew exception after evidence review | Remove expired exception artifacts/config; retain decision audit | Product Security Risk Owner | Expire exception while endpoint online/offline and attempt renewal/upload | Abrupt fail-closed can strand endpoints; indefinite extension would normalize lower assurance |
| T-46 | Enrollment/status/decommission admin action succeeds without durable audit | Same transaction or fail-closed audit write; privileged API contract | Roll back/deny mutation if audit cannot commit | Restore audit service/store and retry through authorized workflow | Reconcile any external CA action that happened before audit failure | Audit/Security Governance Owner | Fail audit write at every privileged mutation boundary | External CA or deployment systems may have separate logs and partial side effects |
| T-47 | Denial-of-service floods TLS handshakes, unknown certs, bootstrap attempts, or status lookups | Per-stage rate/resource metrics with fixed dimensions; queue/latency bounds | Early bounded reject, connection/rate limits, circuit isolation; never bypass auth to recover availability | Scale/restore affected tier, block abusive source where lawful, preserve genuine device retry semantics | Clear transient queues/caches; review dropped/denied categories without device-level metric labels | Ingress/SRE and Security | Flood valid/invalid chains, unknown certs, replays, slow handshakes, and status-store faults | Strong client authentication is CPU/PKI intensive; exact 6,000-device and attack capacity remains unmeasured |
| T-48 | Compromised authorized endpoint signs valid requests and uploads false minimized data | Identity proves installation, not data truth; anomaly/data-quality controls and fallibility warning | Contain credential/device/ring; do not treat mTLS as semantic truth | Investigate endpoint/release/source pipeline; revoke and re-enroll only after remediation | Quarantine affected custody/materialization as governed; preserve audit | Product Security and Data Quality Owners | Use legitimate lab credential to send schema-valid but false events | Device identity cannot prove endpoint integrity, user attribution, or factual correctness |

## 7.2 Secure coding and review requirements

1. Identity, certificate, gateway-assertion, and realm-mapping code MUST receive security review by a reviewer independent of the author.
2. ASN.1/X.509, TLS, CNG, proxy, and HTTP signature processing MUST use maintained platform/library implementations behind a narrow adapter. UAM MUST NOT implement a general certificate parser, TLS stack, TPM command stack, or PKCS#12 writer.
3. All untrusted certificate, enrollment, header, and proxy inputs MUST be bounded before allocation-heavy work. Duplicate headers/members, wrong case where closed, invalid UTF-8, unsupported algorithms, unknown critical extensions, overlong chains, and trailing data fail closed.
4. Private-key handles MUST be represented by safe, non-serializable types. No domain or transport DTO may contain private-key bytes, PFX/PKCS#12 data, password fields, arbitrary key-container names, or export switches.
5. Source and binary guards MUST prohibit `X509Certificate2.Export` for private-key-bearing content, `ExportPkcs8PrivateKey`, `TryExportPkcs8PrivateKey`, `ExportEncryptedPkcs8PrivateKey`, `RSACng.ExportParameters(true)`, permissive `ServerCertificateCustomValidationCallback`, and equivalent P/Invoke export paths in production deployables. Any legitimate public-certificate export helper stays in a separately reviewed allowlist.
6. TLS client handlers MUST not log request headers or certificate objects. Enrollment and upload retry handlers MUST not serialize `HttpRequestMessage`, exception inner text, proxy URI, or certificate raw data.
7. The gateway MUST remove all external identity-bearing headers before adding its own assertion. The backend MUST reject an assertion unless the connection authenticates an approved gateway identity and the assertion key/profile is active.
8. Every server query/update involving installation, credential, policy, cache, audit, inbox, or administration MUST be scoped by server-derived `realm_id`; composite uniqueness and architecture tests enforce this.
9. Security-sensitive state transitions MUST be monotonic and compare-and-swap or serializable. Retry must return the original outcome, not create a second identity or effect.
10. Fuzzing, malformed-certificate tests, header-smuggling tests, fault injection, mutation tests, and clean-room reproducibility evidence are required release inputs for the selected identity/network profile.

## 7.3 PKI and identity runbook requirements

A production-capable deployment requires the runbooks below. Each runbook MUST name authorized decision-makers, communication/escalation, evidence classification, containment commands/workflows, rollback or recovery, cleanup, re-enable criteria, and the adjacent proof gates to repeat. Test versions use only a lab CA and fictional identities.

| Runbook | Trigger | Required immediate action | Recovery and re-enable evidence | Mandatory drill |
|---|---|---|---|---|
| RB-01 Bootstrap authorization exposure | Token appears in a prohibited sink, replay alert, or deployment-channel compromise | Deny authorization/batch, hold uncertain credentials, stop affected enrollment channel | New channel authorization, scanner clean result, saga reconciliation, incident approval | Steal/replay a planted fictional token before and after redemption |
| RB-02 Endpoint credential compromise or lost device | Theft, suspected key misuse, lost asset, malware, or operator report | Rapid deny credential/installation; close sessions; preserve unacknowledged-data state without uploading | New epoch/key/credential only after ownership and remediation evidence | Deny online/offline endpoint, recover it, prove old identity remains rejected |
| RB-03 Clone or duplicate identity | Overlapping use or image scan finds active identity | `DUPLICATE_HOLD` both copies; no automatic winner | Enterprise management identifies legitimate endpoint; old credential revoked; selected endpoint re-enrolled | Simultaneous and sequential clone campaign |
| RB-04 Issuing CA/intermediate/root compromise | Key custody incident or unauthorized issuance | Stop issuance/renewal; deny compromised issuer/profile; activate incident command | Replacement trust distributed consumer-first, canaries pass, fleet migration plan accepted | Compromise disposable lab CA and perform emergency rollover |
| RB-05 Planned root/intermediate rollover | Expiry, crypto migration, CA migration | Publish trust before issuance; canary exact routes and offline behavior | Current+next trust evidence, issuance/renewal success, old-chain inventory and retirement plan | Dual-chain canary and rollback drill |
| RB-06 CRL/OCSP outage or stale revocation data | Publication/responders unavailable or stale | Follow approved hard-fail policy; preserve UAM rapid deny; communicate coverage state | Fresh response/CRL verified from each ingress zone; caches purged | Block/expire responders with active and revoked lab credentials |
| RB-07 Rapid deny store/cache outage | Status store unavailable or freshness exceeded | Fail closed after declared bound; stop identity-dependent work | Store consistency, revision monotonicity, cache freshness, denied-cert negative tests | Partition store/cache during persistent connections and load |
| RB-08 Mass renewal storm/CA throttling | Large synchronized eligibility or outage recovery | Jitter/backoff/admission control; prioritize by remaining validity without weaker assurance | Backlog drained, no duplicate issuance, no expired accepted identity, capacity evidence | 6,000-fictional-installation renewal simulation; count is an **ESTIMATE**, not fleet proof |
| RB-09 Clock failure | Large skew, rollback, time service failure | Enter `CLOCK_HOLD`; do not widen certificate validity locally | Trusted time restored, validity rechecked, connection pools rebuilt | Clock rollback/advance/offline recovery at enrollment, renewal, and upload |
| RB-10 Proxy/VPN/TLS-inspection incompatibility | CONNECT/auth/route/DNS/inspection failure | `NETWORK_HOLD`; preserve batches; no shared-secret or validation bypass | Approved network profile/bypass, exact TLS name/chain and mTLS proof, customer owner sign-off | Direct, explicit proxy, PAC, inspection, split/full tunnel transitions |
| RB-11 Realm mapping or isolation incident | Wrong-realm context, cache/store/query collision | Stop affected route/module; quarantine uncertain custody/materialization; deny conflicting credential | Composite-key/query repair, negative matrix, data reconciliation and audit approval | Same IDs across fictional realms plus body/header/cache/store attacks |
| RB-12 Ownership transfer/decommission | Asset moves realm/owner or is retired | Deny old credential, decommission old installation, stop upload | Endpoint cleanup plus new realm-bound enrollment; old data remains isolated | Transfer with endpoint online/offline and attempted old/new realm access |
| RB-13 Gateway assertion/header compromise | Spoof success, assertion key exposure, direct backend path | Disable L7 route/key; reject unsigned/header-only identity; use pre-approved direct/L4 only | New gateway identity/assertion key, topology and smuggling tests pass | Rotate compromised assertion key and test direct backend/header attacks |
| RB-14 Lower-assurance exception expiry | Exception reaches expiry or risk scope changes | Stop new A1 issuance/renewal; apply approved transition/deny plan | TPM profile pass or renewed human decision with owner/expiry/evidence | Expire exception for online and long-offline fictional endpoints |
| RB-15 Identity-store disaster/restore | Restore, regional loss, database corruption | Keep ingress isolated; deny device authorization until security ledger reconciles | Monotonic epoch/status/deny replay, cache purge, restore readiness sign-off | Restore pre-revocation backup and prove denied credentials remain denied |
| RB-16 Issuer decommission | CA retirement after migration | Stop new issuance; revoke outstanding as policy requires; preserve CRL/AIA paths for lifetime | Outstanding-cert inventory zero/accepted, revocation evidence retained, trust removal canaries pass | Disposable CA decommission following documented sequence |
| RB-17 Golden-image contamination | Image scanner finds any active UAM state | Block image release and all descendants | Rebuild from clean pre-enrollment base; scanner and first-boot proof pass | Intentionally seal at each identity state and detect every prohibited artifact |
| RB-18 Support without private or internal data | Incident cannot be diagnosed with normal telemetry | Use restricted local evidence and fictional reproduction; no key/cert export or internal network disclosure | Sanitized evidence package passes exact canary/schema scan and owner review | Exercise a failed enrollment/proxy case using only categorical shareable evidence |

## 7.4 Incident severity and evidence rules

- A successful cloned, revoked, expired, unknown, or wrong-realm authorization is a release-blocking identity incident regardless of data volume.
- Any private-key export or bootstrap-token escape is a credential-compromise incident; absence of observed misuse does not downgrade it to a normal defect.
- A gateway identity-header spoof, direct-backend bypass, realm-cache/store collision, or stale-epoch acceptance stops the affected plane and dependent rollout.
- Evidence MUST retain the first failing run. Reruns link to rather than replace it.
- Shareable evidence contains opaque fictional IDs, finite states, digests, exact software versions, counts, and timings. It MUST NOT contain private keys, bootstrap values, certificate raw bytes unless the certificate is a generated public T1 fixture explicitly approved for the corpus, customer addresses, proxy URIs, credentials, SSH material, user/device names, or production activity.
- Cleanup failure makes the experiment fail even when the security assertion itself passed.

---

# 8. Detailed G7 laboratory plan, test matrix, and smallest falsifying prototypes

## 8.1 Lab authority and current evidence state

**FACT.** I02 proves only that a sanitized Windows-lab connection path exists. It does not establish the OS edition/build, architecture, domain state, TPM/vTPM, CNG provider, Edge/runtime, proxy, VPN, EDR, virtualization, test users, or privileges, and no connection was made while producing the supplied capability summary.

**RECOMMENDATION.** G7 begins with disconnected scripts and a disposable synthetic PKI. An approved operator later invokes the scripts with locally held connection information. Shareable evidence never includes the actual command, user, host, address, port, identity path, key, or SSH configuration.

## 8.2 Lab safety and evidence envelope

Every G7 run MUST:

1. use a lab CA and visibly fictional realm, installation, device, certificate, hostname, and network names;
2. generate private keys inside the disposable endpoint or CA boundary and never export a private key into evidence;
3. bind exact source commit, contract/configuration digests, .NET/runtime, OS/build class, architecture, CNG provider, public certificate profile, CA/gateway/proxy versions, and VM-image digest;
4. capture raw ETW/ProcMon/certificate/proxy evidence only in restricted disposable storage; the shareable record contains normalized categories and hashes;
5. plant exact canaries in prohibited fields/sinks and prove the scanner detects every positive control before relying on a clean scan;
6. retain the first failure, every retry link, and cleanup receipt;
7. compare services, tasks, files, registry, CNG key containers, certificate stores, trust roots, firewall/proxy/VPN state, processes, VM snapshots, CA records, gateway keys, identity rows, and status caches before/after;
8. mark unavailable hardware/network/VDI capability as `BLOCKED`, not `PASS`;
9. run with release-like least privilege; an administrator-only success does not prove Coordinator fitness;
10. stop immediately on private-key export, cross-realm acceptance, active-identity image capture, shared-secret path, or cleanup failure.

A shareable evidence record SHOULD conform to:

```json
{
  "schemaVersion": "1.0.0",
  "experimentId": "E-G7-00",
  "claim": "one falsifiable sentence",
  "classification": "T1",
  "startedAtUtc": "<RFC3339-Z>",
  "endedAtUtc": "<RFC3339-Z>",
  "sourceTreeSha256": "<digest>",
  "contracts": [{"id":"<id>","sha256":"<digest>"}],
  "environment": {
    "osBuildClass": "<sanitized exact supported class>",
    "architecture": "<exact>",
    "vmOrHardwareProfile": "<finite profile id>",
    "tpmCapability": "ABSENT|PHYSICAL|VTPM|UNKNOWN",
    "cngProviderProfile": "<finite profile id>",
    "networkProfile": "DIRECT|CONNECT_PROXY|PAC|TLS_INSPECTION|VPN",
    "runnerImageDigest": "<digest>"
  },
  "software": {
    "dotnetSdk": "<exact>",
    "dotnetRuntime": "<exact>",
    "uamBuildDigest": "<digest>",
    "caProfile": "<lab profile and exact version>",
    "gatewayProfile": "<lab profile and exact version or NONE>",
    "proxyProfile": "<finite category and exact product/version in restricted record>"
  },
  "identity": {
    "fictionalRealmId": "<UUIDv7>",
    "installationId": "<UUIDv7>",
    "credentialId": "<UUIDv7>",
    "certificatePublicFingerprintSha256": "<digest>",
    "privateKeyExported": false
  },
  "commands": [{"argvRedacted":"<placeholder-only command>","exitCode":0}],
  "assertions": [{"id":"<id>","result":"PASS"}],
  "canaryScan": {"scannerDigest":"<digest>","positiveControlsPassed":true,"escapes":0},
  "cleanup": {"result":"PASS","receiptSha256":"<digest>"},
  "ownerFunction": "<assigned function>",
  "reviewerFunction": "<independent function>",
  "exceptions": []
}
```

## 8.3 G7 lanes and order

| Lane | Purpose | May start when | Exit evidence | Hard stop |
|---|---|---|---|---|
| G7-L0 | Disconnected contracts, synthetic CA, fixtures, scanners, and scripts | Immediately after repository/contract prerequisites | Deterministic T1 package and placeholder-only commands | Real value, connection detail, private-key artifact, or nondeterminism |
| G7-L1 | Read-only Windows/network/TPM inventory and sanitization | Lab authorization and L0 pass | Named capability matrix with restricted raw and sanitized shareable forms | Mutating preflight, secret/address leakage, or unknown capability called supported |
| G7-L2 | CNG key creation, ACL, sign challenge, generic enrollment, activation | L1 and exact G1 Coordinator boundary pass | A1/A2 profile evidence and no-export proof | Key export, broad ACL, wrong process access, provider claim without effective proof |
| G7-L3 | Optional native AD CS TPM key attestation | Enterprise-CA disposable lab available | Attestation pass/fail matrix and limitation record | Treating lack of attestation as automatic software fallback or universal TPM failure |
| G7-L4 | Clone, snapshot, duplicate, revoke, expire, unknown, wrong-realm, restore | L2 activation/status path | Primary gate negative matrix | Any acceptance or shared-secret workaround |
| G7-L5 | Direct/L4 mTLS and conditional L7 gateway/assertion | L4 identity mapping stable | Header/direct-backend/request-binding evidence | Header spoof, wrong request binding, stale status acceptance |
| G7-L6 | Proxy, PAC/WPAD, TLS inspection, VPN, route and DNS changes | L5 direct route passes | Per-profile compatibility result; unsupported fails closed | Server-validation bypass, token leakage, or unapproved fallback |
| G7-L7 | Renewal, overlap, clock, offline, CA/status outage, and synthetic fleet storm | L4–L6 profile frozen | State/failpoint/capacity distributions and runbook evidence | Old/stale credential acceptance, duplicate issuance, cursor/batch identity mutation |
| G7-L8 | Golden image, persistent clone, vTPM, nonpersistent VDI | Platform owner supplies disposable capability | Image/clone/VDI classification and cleanup | Active identity in image or shared pool identity |
| G7-L9 | Incident drills, cleanup, customer-network qualification template | All claimed lanes pass | Runbook receipts and immutable `g7-device-identity-gate.json` | Missing owner, residue, private/internal data, or waived primary invariant |

## 8.4 Detailed test matrix

Durations are **ESTIMATE** values for planning a disposable lab run. They are not SLOs, staffing commitments, or production support promises.

| ID | Setup and instrumentation | Steps | Pass criteria | Fail/stop criteria | Required evidence | ESTIMATE duration | Cleanup |
|---|---|---|---|---|---|---|---|
| G7-01 | Offline repository; T1 fixture generator; lab CA; exact canary scanner | Generate all contracts, realms, authorizations, CSRs/certs, errors, and expected ledgers twice | Canonical package byte-identical; all private values confined to generated restricted fixtures; scanner positive controls pass | Nondeterminism, production-derived value, or scanner miss | Package root, lineage, truth ledger, scanner matrix | 1–2 h | Delete ephemeral key stores/CA DB; keep public T1 corpus by digest |
| G7-02 | Placeholder-only PowerShell/.NET scripts; no connection | Lint commands/config for host/user/address/port/key/path literals and mutating preflight | Only placeholders; read-only inventory precedes install; evidence sanitizer included | Any connection material or secret-shaped value | Script hashes and lint report | 1 h | Clean worktree proof |
| G7-03 | Approved disposable Windows VM; restricted raw evidence path | Run read-only OS/architecture/TPM/CNG/domain/proxy/VPN/clock/virtualization inventory | Exact capability is classified; unsupported/unknown is explicit; shareable output has no sensitive values | Inventory mutates state or leaks identifiers/network details | Raw-restricted digest plus sanitized JSON | 1 h | Delete restricted export after review; revert snapshot |
| G7-04 | Coordinator service identity and installer authority; CNG tracing/effective access harness | Create machine key under preferred provider; inspect effective properties; sign server nonce; reboot and repeat | Private key never leaves provider; Coordinator can sign; User Host/Task Host/ordinary user cannot; properties match admitted profile | Export succeeds, broad access, sign fails after reboot, or provider unsupported | Public key/fingerprint, provider/property categories, access matrix, no-export result | 2–4 h | Delete UAM-owned lab key by exact container handle; verify absence |
| G7-05 | Same as G7-04 with software provider, policy disabled first | Attempt automatic fallback, then explicit fictional A1 authorization | Automatic fallback rejected; explicit scoped A1 enrolls only when server policy permits and records lower assurance | Silent fallback or A1 accepted outside scope/expiry | State transitions, assurance context, exception ID/expiry | 1–2 h | Revoke credential and delete software key |
| G7-06 | Disposable enterprise CA/template capable of TPM key attestation; RSA Platform KSP profile | Request attested cert; vary trusted/untrusted/no TPM, provider, key type, CA mode, persistent processing | Only exact documented/admitted profile attests; failures are finite and do not fall back | Unattested key labeled A3 or unsupported profile issued as attested | CA request/result, public cert profile, assurance decision | 4–8 h | Revoke certs; remove template/test CA if lane isolated |
| G7-07 | Lab enrollment service/CA; one-use authorization | Enroll and activate through reserve→issue→stage→proof→activate; retry after dropped responses at each boundary | One installation/epoch/generation; one active credential; stable idempotent result; no bootstrap reuse | Duplicate identity/issuance, activation without proof, or token reusable | Saga ledger, CA correlation, audit, cleanup | 3–5 h | Revoke and remove test authorization/key/cert |
| G7-08 | Two clients barrier-synchronized on one authorization | Redeem simultaneously with same and different request IDs/keys | One reservation wins; all others held/rejected; uncertain CA issuance revoked | Two active credentials or silent winner guessing after uncertainty | Transaction trace and CA reconciliation | 2 h | Revoke all issued certs; delete both VMs/state |
| G7-09 | Active lab credential; ingress with status lookup | Present valid, expired, not-yet-valid, unknown-chain-valid, malformed, wrong EKU, unknown registration, and denied certs | Only active known profile succeeds; all others finite fail closed | Any invalid/unknown identity reaches ingestion or status bypass | TLS/identity decision matrix | 2–3 h | Remove test roots/certs/caches |
| G7-10 | Two fictional realms with colliding UUIDs/display fields; direct ingress | Vary body/header realm/device/install, certificate subject/SAN, endpoint, cache/store keys | Authenticated server context remains mapped to certificate record; every conflict rejected; zero cross-realm read/write | Any payload/header/subject changes authority or cache/store collision | Request/DB/audit negative matrix | 3–4 h | Purge fictional data and caches |
| G7-11 | Active software-key VM snapshot and clone; shared NAT and different routes | Start both concurrently, alternate, pause/resume, and use sequentially | Overlap/incompatible continuity enters duplicate hold; both rejected; sequential limitations recorded honestly | Automatic winner or both remain active after conflict | Connection/status timelines, duplicate evidence | 3–5 h | Revoke credential; destroy clones/snapshots |
| G7-12 | TPM/vTPM machine and storage clone variants | Clone disk only, full VM, vTPM-preserving clone, migration, snapshot restore where platform allows | Each claimed profile classified by actual behavior; copied identity never silently considered a distinct valid installation | Unsupported clone passes as unique or physical/vTPM assurance conflated | Platform/TPM categories and auth outcomes | 4–8 h per platform | Destroy clones/snapshots and retire credentials |
| G7-13 | Active persistent HTTP/2 connection with concurrent streams | Change status through suspend/deny/revoke/decommission; send requests before/after and during propagation | Requests after declared freshness/cutover bound rejected; connection drained/closed where designed; no status cached beyond bound | Acceptance after bound or reconnect bypass | Precise status revision/request/connection timeline | 2–3 h | Clear pools/cache; restore lab state only with new credential |
| G7-14 | Status DB/cache fault injector and restored old backup | Partition store, freeze cache, revoke, restore pre-revoke DB, restart ingress | Fails closed after freshness; restored service remains isolated until deny ledger/revision reconciles | Restored/stale status authorizes credential | DB/cache revisions, readiness proof, request matrix | 3–5 h | Recreate clean lab DB and caches |
| G7-15 | Direct endpoint-to-Kestrel/ingress TLS; optional L4 balancer | Test TLS versions/ciphers per approved platform, server name/chain, client request, session resumption, cert selection | End-to-end mTLS identity maps correctly; wrong-name/untrusted/no-client cert fails | Permissive server callback, certificate absent at app, or L4 changes identity | TLS transcript categories, cert mapping, exact versions | 2–4 h | Remove lab roots/config and keys |
| G7-16 | L7 gateway plus backend mTLS and assertion verifier | Send external identity headers, duplicates, smuggling variants, direct backend requests, swapped method/path/body/assertion, replay, stale assertion | Gateway strips input; backend requires gateway mTLS + valid request-bound assertion + current credential status | Any header-only/direct/replayed/misbinding succeeds | Public/gateway/backend capture with canaries, assertion decision ledger | 4–8 h | Remove assertion keys, firewall rules, test headers/logs |
| G7-17 | Explicit HTTP proxy with CONNECT; no-proxy control | Test direct, proxy auth success/failure, denied CONNECT, timeout, challenge loops, proxy failover | mTLS remains end-to-end through approved CONNECT; failures hold/retry without secret/validation downgrade | Origin token/body leaks before trusted TLS, proxy terminates identity unnoticed, or shared secret used | Proxy category, TLS endpoint proof, retry state | 3–5 h per proxy product | Remove credentials/proxy config; reset lab proxy state |
| G7-18 | PAC/WPAD test service with benign/malicious/failing scripts; WinHTTP profile | Change proxy selection and network; verify endpoint server authentication and bounded evaluation | Only supported evaluated route used; wrong proxy cannot defeat origin TLS; loop/failure bounded | User-browser settings silently become authority, PAC leak, or TLS validation bypass | Effective profile transitions and finite errors | 3–5 h | Remove PAC/WPAD and cached state |
| G7-19 | TLS inspection proxy with lab root trusted by Windows | Intercept direct route; test mTLS request and optional future application-PoP prototype separately | Direct origin mTLS detects incompatibility/fails; only explicitly approved PoP profile works and remains asymmetric/request-bound | Inspection CA is treated as origin UAM identity or fleet secret fallback appears | Chain/handshake/profile outcomes | 3–5 h | Remove inspection root and proxy artifacts |
| G7-20 | VPN full/split tunnel and route/DNS/proxy changes | Connect/disconnect during enrollment, upload, renewal, and receipt loss; change MTU where possible | Connections re-established; stable enrollment/batch IDs; no duplicate business effect; invalid route fails closed | Identity changes with IP, raw batch loss, duplicate, or validation bypass | Network transition and state-machine evidence | 3–6 h per VPN profile | Remove VPN profiles/credentials and restore routes/DNS |
| G7-21 | Active credential with renewal failpoints and two generations | Crash before/after reservation, key creation, CA issue, stage, activation, old retirement; keep old connections | Exactly one active generation after recovery; approved overlap only; fresh key; no old acceptance after retirement | Key reuse when fresh required, duplicate active generation, lost identity, or stale connection bypass | Endpoint/server/CA ledger at each failpoint | 4–8 h | Revoke both generations, delete UAM keys, restore DB |
| G7-22 | Endpoint offline across renewal and status changes | Disconnect before renewal, expire/deny while offline, reconnect with queued fictional batches | Expired/denied/stale profile rejected; no offline grace invented; re-enrollment path explicit; batches not silently reassigned | Old credential accepted or data submitted to wrong/new realm automatically | Clock/status/batch identity ledger | 2–4 h plus simulated time | Revoke credentials and delete queued T1 data |
| G7-23 | Endpoint/server clock control and trusted time monitor | Skew/rollback/advance around bootstrap, activation, cert validity, assertion replay, renewal | Server time governs authorization; endpoint enters clock hold as designed; replay windows bounded | Local clock widens cert/assertion validity or creates duplicate enrollment | Exact offsets (restricted), categorical shareable result | 2–4 h | Restore time service; rebuild pools/caches |
| G7-24 | CA/status service outage and recovery; renewal load generator | Deny CA, throttle, return ambiguous errors, restore; run fictional fleet distribution | Backoff/jitter bounded; no shared fallback; no duplicate issue; health remains finite/cardinality-bounded | Retry storm, expiry accepted, or per-device metric explosion | Rate/backlog/resource distributions and first failures | 4–8 h | Clear queue/CA DB/test identities |
| G7-25 | Pre-enrollment image and images captured after each lifecycle state | Offline scan and boot clones from each image | Only pristine image passes; every identity-bearing state blocks first boot/activation | Any active ID/key/cert/token/store survives as valid clone | Image digest, scanner and boot result matrix | 4–8 h | Destroy contaminated images/snapshots |
| G7-26 | Persistent VDI, nonpersistent pooled VDI, and vTPM profiles if available | Boot/recompose/migrate many sessions, enroll after specialization, teardown, reconnect | Persistent profile behaves like unique installation; nonpersistent remains unsupported unless per-boot profile meets all named rules | Shared cert/ID/backlog or cleanup residue | Per-boot identity/status/cleanup matrix | 1–2 days per platform | Recompose/destroy pool; revoke all test credentials |
| G7-27 | Realm ownership transfer workflow | Decommission old realm, attempt old upload, clean endpoint, enroll new realm, query both realms | Old credential always denied; new install/epoch/key/realm distinct; no old data visible in new realm | In-place realm mutation, old cert works, or automatic data reassignment | Audit, auth, DB query, endpoint cleanup evidence | 3–5 h | Revoke new credential and delete both fictional realms/data |
| G7-28 | Support bundle, logs, traces, metrics, crash and dump policy | Exercise every failure above with canaries; request diagnostics | Zero private/bootstrap/raw internal-network marker; metrics within fixed series budget; no raw cert/key export | One marker, unbounded label, or support bypass | All-sink manifest and positive-control proof | 3–6 h | Delete restricted raw traces/dumps; verify bundle removal |
| G7-29 | Installer repair/uninstall and interrupted cleanup | Interrupt install/enroll/renew/uninstall; rerun repair/remove | Only product-owned keys/certs/state affected; no orphan service/key/trust/proxy/firewall; denied server record retained as required | Broad certificate/key deletion, orphan active identity, or residue | Before/after system and server inventory | 3–5 h | Revert VM and remove CA/gateway records |
| G7-30 | Full incident/runbook day | Execute RB-01 through selected high-risk runbooks with independent operators | Authorities/actions/evidence/re-enable criteria work; no undocumented workaround | Shared secret, manual DB edit, private key export, identity-header bypass, or missing owner | Signed/reviewed drill receipts | 1–2 days | Full lab teardown and independent residue review |
| G7-31 | Customer-network qualification kit on a customer-owned sanitized test endpoint | Customer runs placeholder kit locally; returns only categorical/versioned evidence | One named direct/proxy/VPN profile passes exact handshake/status/realm tests; no confidential network data leaves customer | Universal support claimed from another network or raw config requested | Sanitized compatibility manifest and customer owner approval | Customer-specific | Customer removes lab credential/trust/tooling and attests cleanup |

## 8.5 Smallest falsifying prototypes

### P-G7-01 — key assurance and enrollment

**Claim.** The Coordinator can create and use a non-exported machine key under the admitted Windows provider/ACL profile, enroll once, prove possession, and activate exactly one server-mapped credential.

**Setup.** One disposable Windows VM, lab CA, one fictional realm, one one-use bootstrap authorization, release-like Coordinator service identity, CNG/effective-access instrumentation, all-sink canaries.

**Steps.** Create key; inspect effective provider/export/usage properties; attempt access from each process context; create CSR; reserve/issue/stage; sign server nonce; activate; reboot; authenticate; retry every request; attempt export.

**Pass.** Coordinator signs before/after reboot; unauthorized contexts cannot use/delete/export; exactly one installation/epoch/generation becomes active; retries return the same result; private-key evidence count is zero.

**Fail.** Export succeeds, ACL is broad, provider facts are unproved, activation occurs without possession, bootstrap is reusable, or a second active credential appears.

### P-G7-02 — clone and duplicate identity

**Claim.** A credential copied by VM/image cloning cannot remain an accepted identity for two installations.

**Setup.** One activated software-key VM and, where available, TPM/vTPM variants; snapshots and two clones; shared/different NAT routes.

**Steps.** Start both concurrently, alternate requests, pause/resume, restore old snapshots, and attempt sequential use.

**Pass.** Concurrent/incompatible continuity triggers `DUPLICATE_HOLD`; both fail closed; no automatic winner; exact sequential-detection limits are recorded; recovery requires new epoch/key/credential.

**Fail.** Both remain active, clone gets a new identity without re-enrollment, or a shared secret is used to distinguish/recover.

### P-G7-03 — revocation on persistent transport

**Claim.** A status change denies subsequent requests within the declared freshness bound even on an existing multiplexed connection.

**Setup.** Direct and conditional gateway paths, HTTP/2 persistent connection, active lab credential, status cache/store fault controls.

**Steps.** Send concurrent requests; suspend/deny/revoke; continue streams; partition status store; freeze cache; reconnect; restore stale database.

**Pass.** No request after the measured bound is authorized; stale restore remains isolated; reconnect cannot reactivate; CRL/OCSP state cannot override UAM deny.

**Fail.** A pooled connection, stale cache, gateway assertion, or restore authorizes the denied credential after the bound.

### P-G7-04 — realm/header/body/cache/store confusion

**Claim.** Certificate mapping, not endpoint/gateway body or header, establishes realm and installation at every plane.

**Setup.** Two fictional realms with colliding UUIDs/display values; direct and L7 routes; hostile request/header corpus; cache and DB mutation hooks.

**Steps.** Swap realm/device/install fields, subject/SANs, path/host, gateway headers, cache keys, and query predicates.

**Pass.** All authority comes from authenticated credential mapping; conflicts reject; every cache/store operation includes the mapped realm; cross-realm effects are zero.

**Fail.** Any body/header/display/certificate text changes authority or a cache/query collision succeeds.

### P-G7-05 — direct, proxy, and TLS inspection

**Claim.** Direct and compatible CONNECT routes preserve origin mTLS; TLS inspection fails closed without a fleet secret.

**Setup.** One origin ingress, explicit proxy, malicious/inspection proxy, PAC profile, wrong-name/untrusted server certificates, VPN route toggle.

**Steps.** Connect through each route; observe origin/client certificate negotiation; alter proxy/PAC/VPN; intercept TLS; attempt downgraded/shared-token fallback.

**Pass.** Only direct or proven end-to-end CONNECT succeeds; server validation remains exact; inspection enters `NETWORK_HOLD`; shared-fleet-secret path count is zero.

**Fail.** Endpoint trusts substituted origin silently, sends bootstrap/data before trusted TLS, or authenticates with a shared secret.

### P-G7-06 — renewal crash and overlap

**Claim.** Fresh-key renewal survives every crash boundary with exactly one active generation and bounded overlap.

**Setup.** Active credential, lab CA, deterministic failpoints, persistent old connection, server/endpoint state inspection.

**Steps.** Crash at reservation, key creation, issue, stage, activation, old retirement, and ACK; repeat requests; expire old overlap.

**Pass.** State converges without duplicate issue/identity; new key proof required; old credential denied after overlap; retries preserve original outcomes.

**Fail.** Two unbounded active generations, regenerated identity on retry, old connection bypass, or software fallback.

### P-G7-07 — golden image and VDI

**Claim.** A distributable image contains no active UAM identity, and every admitted boot creates identity only after specialization.

**Setup.** Image snapshots before install, after install/unconfigured, after authorization, key creation, enrollment, activation, and data creation; persistent/nonpersistent VM profiles.

**Steps.** Scan offline, clone, boot, authenticate, recompose, teardown.

**Pass.** Only pre-enrollment/unconfigured image passes; every clone gets a new authorized installation/key or remains unsupported; no shared backlog/credential; cleanup complete.

**Fail.** Any cloned image authenticates with inherited identity or a pool shares identity/state.

### P-G7-08 — clock, offline, and lost device

**Claim.** Expiry, deny, and epoch authority remain server-controlled across clock skew and offline recovery.

**Setup.** Active endpoint with queued T1 batches, controllable clocks/network/status, decommission/re-enrollment workflow.

**Steps.** Go offline; skew/rollback time; expire/deny/decommission; reconnect; attempt old batch and credential; re-enroll under higher epoch.

**Pass.** Old identity fails; no client-side grace widens validity; old data is not silently reassigned to new realm/epoch; recovery is explicit.

**Fail.** Endpoint time revalidates cert, old epoch authenticates, or queued data crosses identity/realm silently.

### P-G7-09 — CA and gateway emergency rollover

**Claim.** Consumer-first rollover and emergency key withdrawal preserve identity semantics without accepting unsigned or stale authority.

**Setup.** Current/next lab roots/intermediates, current/next gateway assertion keys, canary endpoints, long-offline simulation.

**Steps.** Publish trust, issue canaries, switch issuer/key, revoke current key, withdraw old trust at staged times, attempt rollback/freeze.

**Pass.** New profile works only after consumers trust it; compromised key is rejected immediately; previous key ends after bounded window; lower revision never re-enables it.

**Fail.** Producer-first issuance is accepted through workaround, stale/unsigned header works, or lower revision restores compromised trust.

## 8.6 Customer-network compatibility profile

No result may claim “supports enterprise proxies/VPNs” in general. A customer capability is one immutable profile such as:

```text
Windows build class
+ .NET/Schannel profile
+ machine/user context
+ direct or exact proxy product/version/auth mode
+ PAC/WPAD mode if used
+ TLS inspection present/absent and approved bypass
+ DNS/resolver class
+ firewall/egress rule class
+ VPN product/version and split/full tunnel state
+ gateway/LB route
+ certificate chain/status reachability
```

A profile is `SUPPORTED` only after the exact customer-owned sanitized kit passes server validation, client-certificate negotiation, realm mapping, deny freshness, renewal, network transition, observability, and cleanup. A difference in any load-bearing element creates a new `UNTESTED` profile; it is not inherited by similarity.

---

# 9. Architecture fitness functions and measurable acceptance criteria

## 9.1 Primary gate

**The primary gate is non-waivable:**

> **Cloned, revoked, expired, unknown, or wrong-realm identities fail closed without a shared secret workaround.**

The technical gate expression is:

```text
G7_DEVICE_IDENTITY_PASS =
    CLONED_CREDENTIAL_ACCEPTED_AFTER_BOUND = 0
    AND REVOKED_CREDENTIAL_ACCEPTED_AFTER_BOUND = 0
    AND EXPIRED_CREDENTIAL_ACCEPTED = 0
    AND NOT_YET_VALID_CREDENTIAL_ACCEPTED = 0
    AND UNKNOWN_CREDENTIAL_ACCEPTED = 0
    AND WRONG_REALM_AUTHORIZATION_OR_EFFECT = 0
    AND STALE_ENROLLMENT_EPOCH_ACCEPTED = 0
    AND RETIRED_CREDENTIAL_GENERATION_ACCEPTED_AFTER_OVERLAP = 0
    AND SHARED_FLEET_SECRET_AUTH_PATH_COUNT = 0
    AND PRIVATE_KEY_EXPORT_ARTIFACT_COUNT = 0
    AND GOLDEN_IMAGE_ACTIVE_IDENTITY_COUNT = 0
    AND PUBLIC_IDENTITY_HEADER_SPOOF_SUCCESSES = 0
    AND DIRECT_BACKEND_IDENTITY_BYPASS_SUCCESSES = 0
    AND GATEWAY_ASSERTION_REPLAY_OR_MISBIND_SUCCESSES = 0
    AND CROSS_REALM_CACHE_OR_STORE_EFFECTS = 0
    AND BOOTSTRAP_AUTHORIZATION_MULTI_CONSUME_SUCCESSES = 0
    AND STATUS_CACHE_ACCEPTANCE_AFTER_DECLARED_FRESHNESS = 0
    AND SOURCE_SERVER_VALIDATION_BYPASSES = 0
    AND IDENTITY_CLEANUP_RESIDUE_COUNT = 0
    AND BLOCKING_OWNER_COUNT = 0
    AND BLOCKING_ADR_COUNT = 0
```

No success percentage, risk statement, performance average, support exception, or compensating control can offset a nonzero primary count. An unavailable clone/TPM/proxy/VDI environment is `BLOCKED`, not zero.

## 9.2 Compile-time and repository fitness functions

The repository gate MUST prove all of the following through architecture tests and deliberate mutations:

| Fitness function | Measurable assertion | Failure action |
|---|---|---|
| No private-key export | Production deployables contain no permitted call path to export private key material, PFX/PKCS#12, private parameters, PKCS#8, or PEM private keys | Block build/release; rotate any credential used in a runtime escape test |
| No permissive server validation | No production handler uses `DangerousAcceptAnyServerCertificateValidator`, an always-true certificate callback, name-mismatch suppression, or unbounded custom trust | Block build/release |
| No fleet secret | No endpoint/server contract, config, secret name, code path, fixture promotion, or fallback authenticates the fleet with one symmetric value | Block build/release and ADR acceptance |
| Narrow CNG boundary | Only the reviewed Windows identity adapter may open/create/delete/sign with UAM key handles; User Host/Task Host assemblies cannot reference it | Block architecture graph |
| No arbitrary key/container selector | Tenant/network policy cannot supply key-container names, providers, algorithms, templates, OIDs, CAs, URLs, or executable certificate logic | Block schema/contract |
| Realm composite keys | Every identity, credential, status, audit, cache, inbox, and admin model/query starts from server-derived realm context or a globally unique credential mapping that produces it | Mutation removing realm scope must fail |
| Credential mapping authority | Certificate subject, SAN, hostname, SID, machine GUID, body, and forwarded header cannot construct `AuthenticatedDeviceContext` | Mutation must fail or hostile vector must reject |
| Gateway assertion boundary | Backend identity is available only after approved gateway mTLS plus assertion verification; public forwarded headers are structurally stripped/rejected | Header/direct-backend mutations must fail |
| Monotonic security states | Epoch, generation, status revision, trust-bundle revision, and exception revision cannot decrement or reactivate denied authority by rollback | Lower-revision vectors reject |
| Audit coupling | Bootstrap consumption, activation, deny/revoke, decommission, realm transfer, issuer/gateway key changes, and lower-assurance exceptions cannot commit without durable audit | Audit failpoint rolls back/holds mutation |
| Strict contract profile | Duplicate/unknown members, unsupported versions/algorithms, wrong casing, invalid nulls, remote references, over-bounds values, and ambiguous identity fields reject | Contract gate fails |
| Finite diagnostics | Error/metric schemas expose only registered finite categories and bounded version/profile IDs; dynamic realm/device/cert/proxy/network values are prohibited labels | Cardinality/privacy lint fails |
| Same-digest release | Identity-capable binaries, configuration templates, and trust/control bundles promoted through rings are the reviewed signed digests; environment does not rebuild | Promotion gate fails |

## 9.3 Runtime identity fitness functions

1. **Key possession:** every activation and renewal proves a fresh server nonce with the exact enrolled public key.
2. **Key assurance:** server assurance is derived from admitted evidence; endpoint claims cannot raise it. If evidence is absent or inconsistent, the request fails or remains at a lower level explicitly permitted by authorization.
3. **One active installation lineage:** a bootstrap authorization creates at most one installation/epoch reservation. A certificate maps to one realm, one installation, one epoch, one generation, and one active status record.
4. **No image identity:** the golden-image scanner and first-boot self-check find zero installation, realm, authorization, credential, key, DB, outbox, cursor, or prior-evidence artifacts.
5. **Rapid deny:** after status revision `N` makes a credential non-active, request authorization at revision `>=N` rejects. Cached authorization cannot exceed the declared freshness bound.
6. **Connection independence:** a pooled/multiplexed/resumed TLS connection does not freeze device authorization for its lifetime; each logical request is bound to current status.
7. **Realm isolation:** every request, cache lookup, durable write, administrative action, receipt, and support lookup uses the realm derived from credential mapping. Cross-realm hostile tests produce zero effects.
8. **Epoch anti-rollback:** credentials from a lower epoch never authorize after a higher epoch is active/denied, including after database/VM restore.
9. **Generation overlap:** at most the approved current+previous renewal generations authorize during a bounded overlap; previous becomes non-active at overlap end and all old pools are drained or rejected.
10. **Failure containment:** CA, revocation, status, proxy, VPN, clock, TPM, gateway, and trust failures produce finite states and preserve unacknowledged batch identity; they never activate weaker authentication silently.
11. **Privacy:** zero private/bootstrap/internal-network canaries appear in logs, traces, metrics, dumps, endpoint DB, server inbox, support bundles, or shareable evidence.
12. **Cleanup:** test uninstall/revert removes every product-owned key/certificate/root/task/service/file/firewall/proxy/VPN/gateway/CA artifact while retaining only the server audit/status facts required by the fixture manifest.

## 9.4 Performance, scale, and operations acceptance

Exact limits are **UNKNOWN** pending human SLO/budget decisions and measurement. Initial prototypes MUST nevertheless enforce hard safety ceilings and emit distributions for replacement. The acceptance rules are:

- No unbounded certificate chain, header, assertion, bootstrap, request body, retry queue, key-operation, CA request, status lookup, or metric-label space.
- A synthetic 6,000-installation enrollment/renewal/status exercise MUST complete without identity duplication, uncontrolled synchronized retry, status-freshness violation, or cardinality explosion. **ESTIMATE:** 6,000 is a project scope smoke count, not proof of production rate, hardware, latency, CA, outage, or SLO fitness.
- The load report MUST provide p50/p95/p99 and maxima for handshake, chain validation, status lookup, enrollment transaction, CA issuance, renewal, gateway assertion verification, and deny propagation, plus CPU, memory, handles, connections, DB operations, cache hit/age, CA queues, and errors. It MUST NOT turn exact timings into architecture constants.
- A security failure count remains zero under load. Performance degradation cannot trigger cached indefinite allow, skipped status, header-only identity, shared secret, weaker key, or data loss.
- The exact deny freshness, certificate lifetime, renewal window, overlap, offline allowance, retry/backoff, rate limits, and capacity headroom require accountable decisions after distributions are reviewed.
- Runbook recovery time and staffing evidence are measured separately from software latency. No laboratory exercise proves operational competence without independent drill review.

## 9.5 Accessibility and administrative fitness

Accessibility is relevant to the administrative/support surfaces, even though device authentication itself has no direct user UI.

- Status and assurance MUST not be conveyed by color alone. Text, icon, and machine-readable state are required.
- Every failure state has a stable plain-language summary, a finite support code, and a safe next action; raw certificate/proxy errors are not shown by default.
- Keyboard-only operation, focus order, screen-reader labels, scalable text, and high-contrast behavior are required for enrollment/deny/clone/realm-transfer administration.
- Destructive actions—deny, revoke, decommission, transfer, issuer removal—show the exact opaque installation/realm context and consequences, require explicit confirmation/authorization, and remain auditable.
- A support operator can distinguish `UNKNOWN`, `EXPIRED`, `REVOKED`, `DUPLICATE_HOLD`, `WRONG_REALM`, `NETWORK_HOLD`, `CLOCK_HOLD`, and `LOW_ASSURANCE_NOT_ALLOWED` without viewing private keys, internal URLs, or raw production activity.

---

# 10. Human decisions and owner questions

Research does not make the decisions in this section. The conservative temporary default remains disabled, lab-only, or fail-closed until the accountable function records a decision.

## 10.1 Mandatory prompt decisions

| ID | HUMAN DECISION | Options and consequences | Conservative temporary default | Accountable role/function |
|---|---|---|---|---|
| HD-01 | Enterprise CA/MDM/PKI ownership | **Existing AD CS:** strong Windows integration and optional native TPM attestation, but template/CA/CRL/domain operations and coupling are material. **MDM-managed certificate service:** fits managed fleets but depends on vendor enrollment/renewal semantics and tenant integration. **Dedicated UAM CA/RA:** narrow UAM profile and control, but creates new HSM/availability/audit/PKI staffing burden. **Managed external PKI:** transfers some operations but introduces vendor, data-location, contract, network, and outage dependencies. | No production issuer or trust. Use a disposable lab CA; optional disposable Enterprise CA for attestation experiments only. | Enterprise PKI Authority with Endpoint Management, Security Architecture, Procurement/Legal, and Operations |
| HD-02 | Allowed lower-assurance exceptions | **None:** strongest consistency, but endpoints without usable TPM/vTPM are unsupported. **Per-installation time-bound A1:** targeted exception with explicit owner/expiry, but operational overhead and residual extraction/clone risk. **Platform-class exception:** easier scale but creates a broad weaker population and larger compromise domain. **Permanent software fallback:** rejected recommendation because it normalizes silent downgrade. | A1/software enrollment and renewal disabled. An endpoint unable to meet A2/A3 remains not enrolled. | Product Security Risk Owner with Endpoint Platform and Realm/Customer Authority |
| HD-03 | Certificate lifetime and support policy | **Shorter lifetime:** limits exposure and forces frequent proof/renewal, but increases CA/network/clock/outage load. **Longer lifetime:** improves long-offline tolerance and reduces renewal operations, but extends stolen-key exposure. **Different profiles by assurance/network class:** can fit estates, but increases compatibility, support, and policy complexity. Support window, overlap, emergency renewal, and long-offline behavior must be explicit. | No production lifetime. Lab certificates have a finite test validity documented in each fixture and cannot define production policy. | Enterprise PKI Authority with Product Security, SRE/Operations, Endpoint Support, and Risk Authority |
| HD-04 | Realm definition | Possible boundaries include customer/tenant contract, legal controller, administrative authority, data-residency boundary, or another approved governance unit. Combining boundaries simplifies operation but may weaken isolation; splitting them increases identity, policy, support, and migration complexity. The realm must own enrollment authorization, data authority, administration, transfer, and incident scope consistently. | One fictional isolated lab realm. No production mapping, transfer, or cross-realm administration. | Data Controller/Product Governance with Security IAM, Legal/Privacy, and Data Architecture |

## 10.2 Additional blocking decisions

| ID | HUMAN DECISION | Conservative state until decided | Consequence of delay / blocked work | Accountable role/function |
|---|---|---|---|---|
| HD-05 | Required assurance per endpoint/platform class and whether native TPM attestation is mandatory | A2 proof prototype only; A3 optional lab lane; no production enrollment | Blocks production key/certificate profile and exception handling | Product Security Authority |
| HD-06 | Approved key/certificate algorithms, sizes, EKU/OIDs, subject/SAN profile, chain length, and crypto-agility migration | Execution-time candidates only; unsupported algorithms reject | Blocks production CSR/template/issuer and interoperability | Cryptographic/PKI Authority |
| HD-07 | Bootstrap delivery authority and deployment binding | Lab CLI creates one-use fictional authorizations; no permanent install token | Blocks mass enrollment and lost-token recovery | Endpoint Management/Enrollment Authority |
| HD-08 | Rapid-deny freshness and availability architecture | Status uncertainty fails closed; no production bound claimed | Blocks SLO/capacity/topology and operational acceptance | Product Security with SRE/Identity Service Owner |
| HD-09 | CRL/OCSP hard-fail policy by operation and network zone | Lab hard-fail; UAM rapid deny mandatory | Blocks CA/revocation network design and customer qualification | PKI Authority with Security Risk and Network Operations |
| HD-10 | Direct/L4 versus L7 gateway topology | Direct/L4 preferred; L7 prototype disabled outside lab | Blocks gateway procurement/deployment and assertion key ownership | Security Architecture and Network/Gateway Owner |
| HD-11 | Whether certificate-bound OAuth tokens are needed for downstream delegation | No token; authenticated context remains inside modular monolith/ingress | Blocks multi-hop authorization only, not direct ingestion | API/IAM Architecture |
| HD-12 | Whether TLS-inspected networks get bypass, remain unsupported, or require an application-level asymmetric proof profile | Direct mTLS fails closed; no PoP production profile | Blocks those customer networks | Customer Network Security with Product Security/Risk |
| HD-13 | Supported proxy products, authentication modes, PAC/WPAD policy, and machine-vs-user proxy source | No universal proxy support; exact profile only | Blocks enterprise-network support claims | Customer Network Owner and Endpoint Networking Owner |
| HD-14 | Supported VPN products and full/split tunnel transitions | Exact lab/customer profile only | Blocks mobile/remote support claims | Customer Network/VPN Owner |
| HD-15 | Supported hardware TPM, firmware, vTPM, VM, VDI, RDS/Citrix/FSLogix, and nonpersistent platform matrix | Unknown/unavailable unsupported; nonpersistent shared identity rejected | Blocks extended platform deployment | Endpoint/Virtualization Product Support |
| HD-16 | Golden-image owner, specialization event, image scan/promotion, and restore/clone policy | Capture only before enrollment; no production image pipeline | Blocks image-based scale deployment | Endpoint Image/Virtualization Authority |
| HD-17 | Duplicate/clone signal threshold, false-positive response, and legitimate-copy selection authority | Conflict holds both; no automatic winner | Blocks support process and automated enforcement tuning | Product Security Risk and Asset Management |
| HD-18 | Offline validity, clock uncertainty, lost-device, and queued-data behavior | Expired/denied fails; no grace; old data not reassigned | Blocks long-offline production support | Product Security, Operations, Data Governance |
| HD-19 | Ownership transfer and historical data policy | Decommission + new enrollment; no historical reassignment | Blocks production asset/customer transfer | Realm Governance/Data Controller |
| HD-20 | Decommission, certificate/status/audit/evidence retention, deletion, and legal hold | T1 fixture manifest only; no production deletion promise | Blocks records/runbook and restore design | Records Management/Data Controller/Legal/Privacy |
| HD-21 | Server/gateway/endpoint trust bundle, root distribution, CA/gateway key custody, rotation, quorum, HSM/KMS, and emergency authority | Lab keys only; no production trust/signing | Blocks issuer/gateway production | Cryptographic/Signing Authority |
| HD-22 | Identity administration roles, separation of duties, approval thresholds, and break-glass | No production admin mutation | Blocks control plane and incident authority | Security IAM/Product Governance |
| HD-23 | Diagnostics, crash dumps, WER/EDR/pagefile/support capture, and evidence access | No automatic identity-process dumps; sanitized value-free support only | Blocks production diagnostics and vendor escalation | Endpoint Security/Privacy/Operations |
| HD-24 | Metric cardinality, rare-population handling, access, and retention | Fixed finite T1 dimensions only | Blocks production dashboards/alerts | SRE with Privacy/Data Governance |
| HD-25 | Customer-network qualification responsibility and support commitment | Customer-specific tests; no inherited/universal claim | Blocks contract/support statements | Product Support/Customer Network Authority |
| HD-26 | Budget, licensing, procurement, CA/HSM/gateway infrastructure, and external support | No unapproved spend/dependency | Blocks technology selection and scale proof | Product/Finance/Procurement/Legal |
| HD-27 | Staffing, PKI/security/network/on-call skills, incident command, and support hours | Capability disabled without assigned coverage | Blocks live pilot and production | Engineering/Operations Leadership |
| HD-28 | SLO, RPO, RTO, deny propagation, enrollment/renewal throughput, outage/backlog tolerance | No production objectives; fail closed | Blocks capacity/restore/pilot acceptance | Product and SRE/Operations |
| HD-29 | Pilot scope, residual-risk acceptance, and production go-live | Disposable fictional lab only | Blocks all production use | Designated Production/Risk Authority |
| HD-30 | Batch 02 reconciliation | Eventual Batch 03 reviewer must consume accepted Batch 02 and resolve conflicts | Blocks merge into accepted batch baseline | Batch 03 Architecture Reviewer/Forum |

## 10.3 Owner questions that require written answers

1. What governance boundary is one realm, and can any administrator, issuer, gateway, cache, restore, or support operation cross it?
2. Which system is authoritative for approving one installation’s enrollment into one realm, and how is that approval delivered without a reusable fleet secret?
3. Which endpoint classes must be TPM-backed, attested, virtual-TPM-backed, software-backed, or unsupported?
4. What evidence lets the server assert each assurance level, and what precisely happens when that evidence is unavailable after an OS/firmware/platform change?
5. Which CA/RA/MDM issues the certificate, who owns its template/profile, and who can revoke, renew, migrate, restore, and decommission it?
6. What lifetime/renewal/overlap/offline policy contains stolen keys while surviving planned outages and long-offline devices?
7. What is the maximum accepted delay between a deny decision and rejection at every ingress/gateway/connection/cache path?
8. Does CRL/OCSP uncertainty hard-fail enrollment, renewal, upload, and control retrieval in the same way, or are operation-specific policies approved?
9. Is direct/L4 mTLS reachable from every supported customer network? For inspected networks, is bypass acceptable, is the network unsupported, or is a separate asymmetric application profile justified?
10. Which proxy/VPN products/authentication/PAC modes are actually supported, and who owns recurring regression evidence after updates?
11. Which persistent/nonpersistent VDI, vTPM, clone, snapshot, migration, image, and restore behaviors are supported? What identity is created after specialization?
12. Who resolves a duplicate hold, and what external evidence may be used without treating mutable hardware/network fields as authentication?
13. What happens to unacknowledged local batches when a device is lost, revoked, decommissioned, restored, or transferred to another realm?
14. Who can view certificate/installation/network evidence, and what information is intentionally unavailable to support because of privacy/key constraints?
15. What CA/status/gateway/database disaster can the team recover from, with what staffing and evidence, before the certificate/status windows make recovery impossible?
16. Which costs—HSM, managed PKI, CA servers, gateway, revocation distribution, customer qualification, VDI issuance, support—are accepted, and which platform classes remain unsupported instead?

---

# 11. CLI experiments and measurements

## 11.1 Command-safety rules

The commands below are templates. `<...>` values are supplied locally by an approved operator and MUST NOT appear in shareable evidence. No raw SSH command, user, host, address, port, identity path, key, proxy URI, credential, CA configuration string, or customer network value may be requested or copied into this result.

- Raw command output is written to `<RESTRICTED_RAW_DIR>` inside the disposable lab.
- `sanitize` emits only approved categories/digests to `<SHAREABLE_EVIDENCE_DIR>`.
- No command exports a private key. Public CSRs and public test certificates may be retained only as T1 fixtures when the manifest permits it.
- `certreq`/`certutil` commands are used only against a disposable lab CA/profile. The actual CA configuration string is redacted from evidence.
- `Get-Tpm`, `tpmtool`, `netsh`, `w32tm`, certificate-store, and provider output can expose environment details; raw output remains restricted.
- Cleanup and post-cleanup inventory are part of every command sequence.

## 11.2 Safe command templates

```powershell
# Read-only inventory: restricted output only.
dotnet run --project tools/Uam.IdentityLab -- inventory `
  --output <RESTRICTED_RAW_DIR> `
  --classification restricted-lab

Get-Tpm | ConvertTo-Json -Depth 4 | Out-File <RESTRICTED_RAW_DIR>\tpm-powershell.json -Encoding utf8
tpmtool getdeviceinformation > <RESTRICTED_RAW_DIR>\tpmtool.txt
netsh winhttp show proxy > <RESTRICTED_RAW_DIR>\winhttp-proxy.txt
netsh winhttp show advproxy > <RESTRICTED_RAW_DIR>\winhttp-advproxy.txt
w32tm /query /status > <RESTRICTED_RAW_DIR>\clock-status.txt

# Sanitize before evidence leaves the restricted lab.
dotnet run --project tools/Uam.IdentityLab -- sanitize `
  --input <RESTRICTED_RAW_DIR> `
  --output <SHAREABLE_EVIDENCE_DIR>\inventory.json `
  --profile device-identity-v1

# Create a UAM-owned key and prove possession; tool returns public facts only.
dotnet run --project tools/Uam.IdentityLab -- key-create `
  --provider-profile <LAB_PROVIDER_PROFILE_ID> `
  --key-purpose device-client-auth `
  --output <RESTRICTED_RAW_DIR>\key-public-facts.json

dotnet run --project tools/Uam.IdentityLab -- sign-challenge `
  --key-ref <OPAQUE_LOCAL_KEY_REF> `
  --challenge-file <LAB_CHALLENGE_FILE> `
  --signature-out <RESTRICTED_RAW_DIR>\signature.bin

# CSR flow against a disposable lab CA. The INF contains fictional values only.
certreq -new <LAB_REQUEST_INF> <RESTRICTED_RAW_DIR>\device.req
certreq -submit -config "<LAB_CA_CONFIG>" <RESTRICTED_RAW_DIR>\device.req <RESTRICTED_RAW_DIR>\device.cer
certreq -accept <RESTRICTED_RAW_DIR>\device.cer

# Scan an offline image or generalized VM disk without exporting keys.
dotnet run --project tools/Uam.IdentityLab -- golden-image-scan `
  --root <OFFLINE_IMAGE_MOUNT> `
  --manifest <UAM_INSTALL_MANIFEST> `
  --output <SHAREABLE_EVIDENCE_DIR>\image-scan.json

# Protocol/client exercises use fictional .test origins supplied locally.
dotnet run --project tools/Uam.IdentityLab -- enroll `
  --origin <LAB_ENROLLMENT_ORIGIN> `
  --authorization-stdin `
  --evidence <RESTRICTED_RAW_DIR>\enroll-evidence.json

dotnet run --project tools/Uam.IdentityLab -- authenticate `
  --origin <LAB_INGESTION_ORIGIN> `
  --credential-ref <OPAQUE_LOCAL_CREDENTIAL_REF> `
  --scenario <SCENARIO_ID> `
  --evidence <RESTRICTED_RAW_DIR>\auth-evidence.json

# Final scan and cleanup proof.
dotnet run --project tools/Uam.IdentityLab -- canary-scan `
  --manifest <SINK_MANIFEST> `
  --output <SHAREABLE_EVIDENCE_DIR>\canary-result.json

dotnet run --project tools/Uam.IdentityLab -- cleanup `
  --lab-manifest <LAB_RESOURCE_MANIFEST> `
  --output <SHAREABLE_EVIDENCE_DIR>\cleanup-receipt.json
```

`--authorization-stdin` means the value is supplied interactively or through a local protected pipe and is never placed in process arguments, environment variables, files, shell history, or evidence.

## 11.3 Ordered CLI evidence catalogue

| ID | CLI EXPERIMENT / measurement | Exact evidence it must produce | Pass condition | Stop condition |
|---|---|---|---|---|
| E-G7-00 | Hash the five allowlisted inputs and this result’s source register | Names, sizes, SHA-256, review date, allowlist-conflict note | Exact input table; no extra project input | Missing/changed/unallowlisted project file used |
| E-G7-01 | Capture locked toolchain and dependency graph | .NET SDK/runtime, package locks/sources, native/runtime files, tool hashes, license/admission records | Exact supported inputs; no floating/latest resolution | Unmapped binary/package/tool or unsupported runtime |
| E-G7-02 | Generate T1 identity package twice | Canonical package roots, fictional realm/install/authorization/cert corpus, independent expected state ledger | Byte-identical canonical files; no real value | Nondeterminism or organization/production-derived value |
| E-G7-03 | Scanner positive controls | Canary/sink/encoding/tool matrix | Every mandatory marker found before clean scan | One miss or broad suppression |
| E-G7-04 | Repository/API architecture mutations | Each prohibited reference/API/config mutation and test result | Every mutation fails; clean tree restored | One private-export/permissive-TLS/shared-secret/cross-realm mutation survives |
| E-G7-05 | Placeholder-only lab-script lint | Script hashes, literal/secret/address detector, command classification | No connection/credential/internal literal; preflight read-only | Any raw connection detail or mutating preflight |
| E-G7-06 | Read-only Windows inventory | Sanitized OS/build/arch/domain/TPM/vTPM/CNG/virtualization/security categories and restricted raw digest | Exact named capability; unknown remains unknown | Environment generalized without evidence |
| E-G7-07 | Read-only network/clock inventory | Direct/proxy/PAC/VPN/DNS/TLS-inspection categories and clock-confidence class | No internal values in shareable output | Proxy URI/address/credential/hostname leaks |
| E-G7-08 | CNG provider/key-property matrix | Provider ID, algorithm/use/export/UI/unique-name categories, public key/fingerprint, exact API results | Admitted profile effective, not merely requested | Provider/name claim substituted for proof |
| E-G7-09 | Key ACL/process matrix | Effective access and sign/delete/export result for Coordinator/installer/User Host/Task Host/ordinary/admin contexts | Only approved principals/actions succeed | Broader access or admin-only normal operation |
| E-G7-10 | Key persistence/reboot/servicing | Challenge signatures and key-handle continuity before/after each transition | Same intended key remains usable or finite re-enrollment state | Silent software fallback or identity duplication |
| E-G7-11 | Software-exception policy | Exception owner/scope/expiry/revision and auth result | A1 works only under exact active authorization | A1 automatic/permanent/out-of-scope |
| E-G7-12 | Generic enrollment saga failpoints | Server/endpoint/CA states at every reserve/issue/stage/activate/audit boundary | One installation/credential; retry idempotent; uncertain issue reconciled | Multiple active identities or auditless mutation |
| E-G7-13 | Native TPM attestation matrix, optional | CA/template/profile, provider/key type, attestation result and limitation | Server assurance exactly matches verified result | Unattested key labeled attested or unsupported setup called pass |
| E-G7-14 | Bootstrap theft/replay/concurrency | Token digest/state, requests, winner/hold, CA reconciliation, scanner result | One consume; all replays fail; no token value in evidence | Multiple consumption or token leak |
| E-G7-15 | Certificate/profile validation corpus | Valid/expired/not-yet-valid/unknown/wrong EKU/algorithm/chain/critical-extension/malformed decisions | Exact profile only succeeds | Any invalid/unknown cert maps to identity |
| E-G7-16 | Realm/body/header/subject negative matrix | Authenticated context, cache/store/query/audit result for every permutation | Zero cross-realm effect; conflict rejects | Any request-controlled authority |
| E-G7-17 | Clone/snapshot/restore matrix | Credential use timelines, duplicate/epoch/generation states, platform categories | Clone cannot remain independently active; stale state rejects | Both copies active or stale epoch accepted |
| E-G7-18 | Golden-image scan and boot campaign | Image digest, prohibited-artifact classes, boot/enrollment result | Zero active identity in distributable image | One inherited active identity |
| E-G7-19 | Direct/L4 mTLS | TLS name/chain/client cert/protocol/session/auth context and status results | End-to-end client identity and current status | Missing/forwarded-only identity or permissive TLS |
| E-G7-20 | L7 gateway/header/assertion campaign | External/gateway/backend captures, sanitizer/assertion/status decisions, direct-route test | Gateway mTLS + bound assertion required; spoof/replay zero | Header/direct/assertion bypass |
| E-G7-21 | Explicit proxy/CONNECT products | Exact restricted product/version/auth plus sanitized route/TLS/state results | Origin mTLS preserved; unsupported fails closed | TLS substitution unnoticed or secret fallback |
| E-G7-22 | PAC/WPAD behavior | Script/profile digest, bounded evaluation/result categories, route changes | Supported finite behavior; origin TLS intact | User/PAC value becomes identity or leaks evidence |
| E-G7-23 | TLS inspection | Origin/inspection chain and mTLS outcome; optional PoP prototype result | Direct mTLS incompatible/fails; no shared secret | Inspection root silently accepted as origin profile |
| E-G7-24 | VPN/direct network transition | Route/DNS/proxy/connection changes, enrollment/batch/receipt IDs | Reconnect preserves stable identity/effect semantics | IP becomes identity, loss/duplicate, or bypass |
| E-G7-25 | Revocation/deny persistent-connection test | Status revisions, cache ages, request start/authorization/custody times, connection actions | No acceptance after declared bound | Stale/pool/resumption bypass |
| E-G7-26 | CRL/OCSP/status outage | Freshness, validator/status-store states and request outcomes | Exact approved hard-fail behavior; UAM deny never softened | Revoked/uncertain accepted without decision |
| E-G7-27 | Renewal/rotation failpoints | Endpoint/server/CA generations, key fingerprints, overlap, retries and old connection result | Fresh key; one active generation; bounded overlap | Duplicate issue, indefinite old credential, key loss |
| E-G7-28 | Clock/offline/lost/decommission/transfer | Clock categories, status/epoch/realm/batch state and auth outcomes | Server authority preserved; old identity/data not reassigned | Client clock/grace or transfer mutates authority |
| E-G7-29 | Synthetic 6,000-installation storm | Replaceable load inputs, distributions, resources, errors, CA/status/cache queues, series count | Zero security invariants; bounded retry/cardinality | Security fallback, uncontrolled storm, or metric explosion |
| E-G7-30 | Persistent/nonpersistent VDI platform campaign | Exact platform/image/vTPM/session lifecycle, identity uniqueness, cleanup | Only separately accepted profile succeeds | Shared identity/backlog or platform similarity inference |
| E-G7-31 | CA/root/intermediate/gateway-key rollover | Trust/issuance/assertion revisions, canary matrix, offline and compromise result | Consumer-first; compromised/lower-revision key rejected | Producer-first workaround or stale trust reactivation |
| E-G7-32 | Database/cache restore | Backup point, later deny/epoch changes, restore/readiness/replay result | Restored service isolated until monotonic security state reconciled | Restored revoked credential accepted |
| E-G7-33 | Privacy-safe observability/cardinality | All sink manifests, positive controls, finite labels/series counts | Zero forbidden marker; within approved finite schema | Leak or dynamic identity/network label |
| E-G7-34 | Installer repair/uninstall/cleanup | Before/after system, key/cert/trust/proxy/firewall/server record diff | No product-owned residue; unrelated state untouched | Orphan identity or broad deletion |
| E-G7-35 | Runbook drills | Trigger/actions/authority/evidence/re-enable/cleanup receipts | Each claimed recovery succeeds without undocumented bypass | Private export, shared secret, DB edit, or missing owner |
| E-G7-36 | Aggregate gate | Immutable `g7-device-identity-gate.json` binding all exact evidence, ADRs, owners, human-disabled features, exceptions, and cleanup | Primary expression true for every claimed profile; no expired exception | No baseline merge or customer support claim |

## 11.4 Measurements that replace estimates

The following values MUST be measured and then decided; research does not set them:

- enrollment and renewal request/byte/CPU/latency distributions;
- CA issuance and reconciliation latency, failure, duplicate, and queue distributions;
- TLS handshake/chain/status/gateway assertion costs with connection reuse and revocation checks;
- deny-store/cache replication and request-authorization freshness under failure;
- endpoint TPM/software sign latency, key failure rates, reboot/servicing compatibility, and ACL support cost;
- percentage/count of approved estate with physical TPM, admitted vTPM, software-only, or unsupported capability—using only approved aggregate evidence;
- proxy/PAC/VPN/TLS-inspection profile prevalence and failure classes without collecting internal addresses/configuration;
- offline and renewal-age distributions; certificate expiry risk during realistic outages;
- clone/restore/VDI lifecycle rates and operational cleanup burden;
- metric series, evidence storage, audit, CA/HSM, gateway, support, and incident costs;
- exact runbook recovery time and staffing requirements.

Every measurement record states its population, period, sampling/aggregation, privacy classification, source owner, expiry/deletion, and limitations. A synthetic or lab distribution cannot be relabeled as production evidence.

---

# 12. ADR proposals

| ADR | Decision | Proposed status | Alternatives considered | Rationale and evidence | Accountable owner function | Review trigger |
|---|---|---|---|---|---|---|
| ADR-G7-001 | One UAM installation has one server-owned UUIDv7 identity, enrollment epoch, and per-generation credential; endpoint/network labels are not primary identity | **Proposed — accept for prototype** | Hostname/SID/MachineGuid/CMDB ID/cert subject | Stable UAM lineage and independent revocation; aligns with realm-authority invariant | Identity Architecture Owner | Identity collision, migration need, or external immutable ID evidence |
| ADR-G7-002 | Enrollment uses a one-use, short-lived, audience/realm/assurance-bound authorization; server stores only purpose-separated digest | **Proposed — accept** | Shared install secret, reusable activation code, auto-enroll from cert subject | Contains theft/replay and avoids fleet compromise | Enrollment Authority | Deployment channel cannot provide one-use binding; new primary evidence |
| ADR-G7-003 | Private key is generated after specialization on endpoint and never exported; golden image contains no active identity/state | **Proposed — accept** | Pre-provisioned PFX/image identity, cloned agent state | Prevents clone/fleet key reuse | Endpoint Image and Product Security | Platform requires pre-provisioning; would need explicit change proposal |
| ADR-G7-004 | Assurance levels A0–A4 are finite; TPM-backed A2 preferred, verified native attestation may yield A3, software A1 is disabled except explicit exception | **Proposed — accept model / human-block exact policy** | Binary TPM/no-TPM, provider-name trust, silent fallback | Makes downgrade visible and policy-enforceable | Product Security Risk Owner | Lab provider/attestation evidence or estate decision changes |
| ADR-G7-005 | Windows key adapter uses CNG with Microsoft Platform Crypto Provider candidate, non-exportable machine key, exact ACL; literal algorithm/profile execution-time gated | **Proposed — prototype** | CAPI, file/PFX keys, third-party provider | Windows-native narrow boundary; Microsoft docs support capability | Windows Security/PKI Owner | G7 key/ACL/provider failure or compliance requirement |
| ADR-G7-006 | Certificate profile is narrow client-auth, server mapping authoritative, subjects/SANs non-authoritative, unknown cert rejected | **Proposed — accept invariants** | Identity encoded in subject/SAN, CA-template auto-registration | Avoids naming/realm confusion and template abuse | PKI/Identity Owner | Approved interoperable profile cannot omit authority fields; still requires mapping |
| ADR-G7-007 | Enrollment is a staged saga: reserve, issue, stage, prove possession, activate, with explicit CA reconciliation | **Proposed — accept** | Single non-transactional request, activation at issuance | Contains CA uncertainty and retry duplication | Identity Service Owner | Selected CA offers stronger atomic/idempotent API proved by experiment |
| ADR-G7-008 | Renewal normally creates a fresh key and credential generation; bounded overlap then old generation retires | **Proposed — accept principle / human-block windows** | Reuse key indefinitely, destructive re-enrollment each time | Limits key exposure while preserving continuity | PKI/Endpoint Identity Owner | Hardware/CA limitation or measured outage evidence |
| ADR-G7-009 | Rapid UAM credential status is checked per request with bounded cache freshness; CRL/OCSP remains PKI layer, not sole rapid deny | **Proposed — accept** | TLS-chain-only revocation, connection-lifetime auth, indefinite cache | Meets rapid deny/clone/decommission requirement | Identity Service/SRE | Status availability/cost evidence demands topology change without weakening bound |
| ADR-G7-010 | Server derives realm/installation/epoch/assurance from registered credential mapping; body/header/subject cannot establish authority | **Proposed — accept** | Endpoint realm claim, host routing, XFCC alone | Preserves non-negotiable realm isolation | Realm Security Owner | No expected ordinary trigger; topology change requires baseline proposal |
| ADR-G7-011 | Golden-image clones are pre-enrollment only; post-enrollment duplicate enters hold; nonpersistent shared identity rejected | **Proposed — accept** | Clone active cert, first-writer wins, IP/device heuristic winner | Fail-safe and auditable | Endpoint/Virtualization Security | Platform-specific per-instance non-clonable evidence and separate VDI ADR |
| ADR-G7-012 | Ownership transfer is decommission + new enrollment/new installation/epoch/key/realm, not in-place realm mutation | **Proposed — accept** | Update realm field, preserve old cert | Prevents cross-realm authority/data confusion | Realm Governance | Approved continuity/migration design with equal isolation and audit |
| ADR-G7-013 | Direct end-to-end mTLS or L4 pass-through is default device route | **Proposed — accept for prototype** | L7 termination everywhere, OAuth/shared API key | Smallest trust path | Network/Ingress Security | Customer-network evidence shows infeasible coverage and alternative passes equal gate |
| ADR-G7-014 | L7 gateway is conditional: validate client cert/status, strip inbound identity headers, backend mTLS, short-lived request-bound signed assertion | **Proposed — conditional** | XFCC/plain header, gateway-issued broad bearer token | Contains spoof/misbind/direct backend risks | Gateway Security | G7-L5 pass, implementation selection, incident |
| ADR-G7-015 | Certificate-bound OAuth tokens are deferred; RFC 8705 profile only if downstream delegation requires it | **Proposed — defer** | Token from day one, unrestricted bearer token | Initial modular-monolith ingress needs no extra credential plane | API/IAM Architecture | Multi-hop/delegation requirement approved |
| ADR-G7-016 | TLS-inspected direct mTLS fails closed; bypass or separately approved request-bound asymmetric PoP is required; no shared secret | **Proposed — accept default / defer PoP** | Trust inspection CA as origin, fleet token | Maintains origin/device proof | Product/Network Security | Customer support decision and RFC 9449/9421 prototype evidence |
| ADR-G7-017 | Proxy/PAC/VPN support is exact-profile compatibility evidence, not universal platform claim | **Proposed — accept** | “WinHTTP supported” blanket claim, user-browser proxy inheritance | Enterprise networks vary materially | Endpoint Networking/Product Support | New product/version/profile qualification |
| ADR-G7-018 | Clock/offline/lost devices fail closed for expired/denied/unsupported identity; no client-created grace | **Proposed — accept principle / human-block exact policy** | Indefinite offline grace, local clock override | Prevents stale authority | Product Security/Operations | Human offline/lifetime decision and measured estate evidence |
| ADR-G7-019 | PKI/identity operations and runbook drills are release gates, including CA compromise, deny outage, clone, restore, gateway, and image incidents | **Proposed — accept** | Documentation-only operations, vendor responsibility assumption | Identity safety depends on operational response | PKI/SRE/Incident Leadership | Runbook or topology change, incident |
| ADR-G7-020 | Identity/network observability uses finite value-free categories; no key/token/cert bytes/internal network values or per-device metric labels | **Proposed — accept** | Raw cert/proxy diagnostics, device-labeled metrics | Privacy/cardinality containment | Privacy/SRE/Support | Approved diagnostic need with equal containment evidence |
| ADR-G7-021 | Open-source projects are reference/lab candidates only until exact dependency admission; none is adopted by this result | **Proposed — accept** | Adopt step-ca/SPIRE/cert-manager/Envoy architecture wholesale | Threat models/platform/operations differ | Dependency/Security/Legal Owner | A concrete implementation selection and admission evidence |
| ADR-G7-022 | Numeric lifetimes, freshness, retries, test counts, resource budgets, and support windows remain estimates/human decisions until measured | **Proposed — accept** | Harden prompt/sample numbers as architecture | Missing production distributions/SLO/budget | Product/SRE/PKI | Each value measured and approved |
| ADR-G7-023 | The eventual Batch 03 review must reconcile this result with accepted Batch 02 before baseline merge | **Proposed — blocking condition** | Assume Batch 02, use disallowed file, ignore conflict | Explicit allowlist prevented use | Batch 03 Reviewer | Batch review with both results |

Each accepted ADR MUST include the exact evidence/versions used, migration and rollback, security/privacy/realm impact, owner, runbook, and a smallest falsifying experiment. No ADR is production-accepted while its owner is `UNASSIGNED`, a human decision is implicit, or its named G7 evidence is missing.

---

# 13. Ordered implementation backlog with dependencies and stop gates

## 13.1 Critical path

| Order | Backlog item | Dependencies | Deliverable | Stop gate |
|---:|---|---|---|---|
| 1 | Record result/input manifest and open ADR/human-decision records | None | Exact five-file hashes, source register, owner templates, Batch 02 reconciliation flag | Missing/extra project input or silent contradiction |
| 2 | Assign accountable owner functions for identity, PKI, Windows, gateway/network, realm, SRE, privacy, support, incident, release, image/VDI, dependency | Human governance | Owner/escalation register | Any safety-critical owner `UNASSIGNED` before its lane |
| 3 | Preserve accepted Batch 01 release/G1 prerequisites and bind intended source tree | 1–2 | Immutable predecessor evidence references | Identity code cannot run in unproved privileged/session/release boundary |
| 4 | Add pure identity/realm/credential/assurance/status contracts and strict vectors | 1–3 | Codec-neutral schemas, closed enums, hostile corpus | Ambiguous/unknown fields, endpoint authority, or version coercion |
| 5 | Add logical identity schema/migrations and realm-composite architecture tests | 4 | Tables/constraints from section 5 and migration tests | Missing realm/epoch/generation/status uniqueness or audit coupling |
| 6 | Add repository/API guards for key export, permissive TLS, shared secret, forwarded identity, dynamic metrics | 3–5 | Mutation-tested architecture gate | One prohibited mutation survives |
| 7 | Build deterministic T1 PKI/identity fixture generator, independent oracle, and all-sink canaries | 4–6 | Lab roots/intermediates/certs/authorizations/state truth with no real values | Nondeterminism, common production decision code, scanner miss |
| 8 | Implement identity error taxonomy, finite health, metric schemas, and safe evidence envelope | 4–7 | Closed diagnostic contracts and cardinality lint | Dynamic/sensitive label or raw exception path |
| 9 | Implement narrow Windows CNG adapter with safe handles and no-export types | 3–8 | Provider/key create/open/sign/delete-public-facts interface | Broad NCrypt surface, private bytes, arbitrary provider/container input |
| 10 | Implement key ACL/install/uninstall ownership and offline golden-image scanner | 6–9 | Installer manifest, effective-access harness, image scan | Active identity in image or broad deletion/ACL |
| 11 | Implement server bootstrap authorization reserve/consume model and audit | 4–8 | One-use digest-bound authorization transactions | Multi-consume, reusable token, auditless state |
| 12 | Implement enrollment saga and lab generic CA adapter | 7, 9, 11 | Reserve/issue/stage/prove/activate/reconcile | Activation without proof or duplicate issuance/identity |
| 13 | Keep CA adapter and certificate profile abstract enough for AD CS/MDM/dedicated CA comparison, not arbitrary | 12 | Narrow issuer interface and admission record | General CA scripting/template/URL channel |
| 14 | Implement credential-to-realm mapping and `AuthenticatedDeviceContext` | 5, 12 | Direct identity middleware and realm-negative tests | Body/header/subject/host authority |
| 15 | Implement credential status/rapid deny service, bounded cache, revision, and connection hooks | 5, 14 | Per-request authorization and deny API | Indefinite connection/cache authorization |
| 16 | Implement fresh-key renewal/overlap/retire state machine and failpoints | 9, 12, 15 | Two-generation prototype and recovery ledger | Duplicate active generation, stale connection, silent fallback |
| 17 | Implement decommission, destructive re-enrollment/new epoch, and ownership-transfer contracts | 5, 11–16 | Audit-coupled server/end-point workflows | In-place realm mutation or stale epoch reactivation |
| 18 | Implement clone/duplicate-hold signals using only non-authoritative evidence and explicit uncertainty | 14–17 | Simultaneous conflict detector and support state | Automatic winner or mutable field becomes identity |
| 19 | Implement direct .NET mTLS client/server prototype with platform server validation and cert selection | 9, 14–15 | End-to-end direct/L4 path | Permissive callback, raw cert logging, missing client identity |
| 20 | Implement optional L7 gateway assertion prototype behind disabled feature flag | 14–15, 19 | Header stripping, gateway mTLS, signed request-bound assertion | Header-only identity, direct backend, replay/misbind |
| 21 | Implement network-profile adapter and state machine for direct/explicit proxy/PAC candidate/VPN changes | 8, 19 | Finite `NETWORK_HOLD` and reconnect behavior | User policy/arbitrary proxy or validation downgrade |
| 22 | Implement clock/offline/lost-device state and preserve stable batch identities | 15–17, 21 | `CLOCK_HOLD`, offline reconnect, no reassignment | Client-created grace or old realm/epoch upload |
| 23 | Implement trust-bundle/issuer/gateway-key consumer-first rollout controls | 6, 12, 20 | Current+next profile, anti-rollback, canary state | Producer-first issuance or lower-revision trust |
| 24 | Build placeholder-only disconnected G7 scripts and cleanup manifest | 7–23 | Inventory/install/CA/proxy/VPN/clone/fault/cleanup kit | Connection detail/credential/private export in repository/evidence |
| 25 | Obtain lab authorization and named capability matrix | Human HD-05/06/10/13–16 | Approved disposable hardware/VM/network/CA lanes | Unknown environment described as supported |
| 26 | Run read-only inventory and bind exact G1/release evidence | 24–25 | Sanitized OS/TPM/CNG/network/virtualization profile | Capability mismatch or stale predecessor evidence |
| 27 | Execute G7-L2 CNG/ACL/no-export/generic enrollment | 9–12, 26 | E-G7-08–12 evidence | Any key/ACL/enrollment primary failure |
| 28 | Execute optional AD CS native TPM attestation lane | 27 plus disposable Enterprise CA | A3 matrix or explicit `BLOCKED/UNSUPPORTED` | Unattested key mislabeled or environment generalized |
| 29 | Freeze prototype assurance/certificate profile by ADR | 27–28 and human input for scope | Accepted/rejected profile with exact limitations | No downstream production-shaped identity on unresolved profile |
| 30 | Execute realm/status/unknown/expiry/epoch/clone/restore primary negative matrix | 14–18, 29 | E-G7-14–18 and primary gate subset | One acceptance/cross-realm/shared secret |
| 31 | Execute direct/L4 mTLS profile | 19, 30 | E-G7-19 | Server validation/client mapping/status failure |
| 32 | Execute conditional L7 gateway profile if selected | 20, 30–31 | E-G7-20 | Header/direct/replay/misbind success |
| 33 | Execute proxy/PAC/TLS-inspection/VPN profiles | 21, 31–32 | E-G7-21–24 per exact profile | Validation bypass, secret fallback, or universal claim |
| 34 | Execute revocation/status/CRL/OCSP persistent-connection/outage matrix | 15, 30–33 | E-G7-25–26 with measured freshness | Acceptance after bound or unsafe soft fail |
| 35 | Execute renewal/clock/offline/lost/decommission/transfer failpoints | 16–17, 22, 34 | E-G7-27–28 | Stale generation/epoch, duplicate, reassignment |
| 36 | Execute golden image, clone, vTPM, persistent/nonpersistent VDI lanes | 10, 18, 25, 30 | E-G7-17–18/30 per platform | Inherited/shared identity or unsupported called pass |
| 37 | Execute consumer-first issuer/root/gateway rollover and compromise drills | 23, 30–36 | E-G7-31 | Compromised/lower-revision trust accepted |
| 38 | Execute synthetic 6,000-installation load/status/renewal storm | 11–23, 30–37 | E-G7-29 distributions and resource/cardinality evidence | Any security fallback or uncontrolled storm |
| 39 | Execute restore/readiness and audit durability campaign | 5, 15, 17, 38 | E-G7-32 and privileged audit failpoints | Revoked/stale state restored or auditless mutation |
| 40 | Execute full all-sink privacy/cardinality/support campaign | 7–8 plus all runtime paths | E-G7-33 | One forbidden marker/dynamic label/private evidence |
| 41 | Exercise PKI/identity/network/clone/gateway/restore runbooks with independent operators | 30–40 and owner assignment | E-G7-35 drill receipts | Undocumented workaround, missing authority, incomplete cleanup |
| 42 | Execute uninstall/revert and independent cleanup review | All lab lanes | E-G7-34 complete residue receipt | Any active identity/key/cert/root/rule/task/file/VM/CA residue |
| 43 | Aggregate immutable `g7-device-identity-gate.json` | 1–42 | Exact inputs, profiles, ADRs, owners, human-disabled items, evidence and cleanup | Any failed/missing/expired/waived primary assertion |
| 44 | Reconcile with accepted Batch 02 in Batch 03 review | 43 plus allowlisted Batch 02 review in reviewer chat | Conflict register/ADR actions | Silent merge or weaker predecessor invariant |
| 45 | Update technical baseline for accepted refinements only | 43–44 and architecture forum approval | Baseline patch distinguishing invariants, profiles, estimates, human decisions | Production detail or unsupported profile hardened as universal |
| 46 | Issue customer-network qualification kit | 45, support/owner decisions | Sanitized exact-profile kit and runbook | Raw internal config requested or another customer’s pass inherited |
| 47 | Select/admit production CA/MDM/gateway/dependencies and run identical G7 profile | HD-01–03/05–29, 45 | Exact technology/operations evidence | Lab/reference technology treated as production by prose |
| 48 | Permit a bounded production pilot | 47 plus all applicable project gates and designated human approval | Pilot plan, stop triggers, support/incident/cleanup | No implicit pilot/production permission from this result |

## 13.2 Parallelism and stop rules

After the pure contracts and repository guards exist, the following may proceed in parallel:

- T1 fixture/oracle/canary work;
- logical identity schema and state-machine tests;
- Windows CNG adapter spike on a disconnected developer/lab machine;
- generic lab CA and gateway assertion reference prototypes;
- placeholder-only inventory/proxy/VPN/image/cleanup scripts;
- server realm/status/cache models and hostile vectors.

The following may not be pulled forward:

- no production CA/template/MDM/gateway selection before owner/human decisions and exact admission;
- no live customer network collection or raw config request before the sanitized qualification contract;
- no software fallback, TLS-inspection workaround, nonpersistent VDI profile, certificate-bound token, DPoP, or HTTP Message Signature as an informal side path;
- no production identity/network support claim before exact G7 profile evidence;
- no production pilot before release/update gate, device identity gate, later applicable server/capacity/restore/deletion gates, and human production authority;
- no weakening of a failed gate by increasing cache lifetime, certificate lifetime, offline grace, retry count, privilege, log detail, or shared credentials without an explicit change proposal.

## 13.3 Exact GO/STOP result from this research

**GO now** for pure contracts/models, strict validators, T1 fictional fixtures, independent oracle/canaries, architecture guards, logical schemas/migrations, disabled feature flags, generic lab CA/gateway prototypes, placeholder-only G7 scripts, and an approved read-only lab inventory.

**STOP** before production issuer/MDM integration, production credentials/trust, customer-network support, lower-assurance exceptions, VDI enablement, certificate lifetime/support promises, production signing/promotion, pilot, or production deployment.

---

# 14. Open-source repository assessment

## 14.1 Decision rule

Open-source projects are design evidence, test tools, or implementation candidates only after exact admission. Popularity does not establish UAM fit. A production dependency requires:

- exact tag/commit and source-to-package/binary mapping;
- license, notices, patents, export/compliance, support, and procurement review;
- active maintenance, security policy/advisory handling, reproducible/attested artifacts where available, and removal path;
- unit, integration, negative, fuzz, upgrade, backup/restore, and incident evidence relevant to the consumed surface;
- UAM-specific realm, privacy, clone, revocation, proxy, offline, and operations tests;
- an accountable owner and runbook.

No repository below is accepted as a production dependency by this result.

## 14.2 Assessment table

| Repository and immutable point reviewed | Relevant files/directories | License and compatibility concerns | Maintenance, tests, and security posture | Architectural similarity and threat-model difference | Reusable ideas / ideas not to copy | Suitability |
|---|---|---|---|---|---|---|
| [`smallstep/certificates`](https://github.com/smallstep/certificates/tree/6e8ec61405239cf3f37b2bbf260a587b7d2e4e31), tag `v0.30.2`, commit `6e8ec61405239cf3f37b2bbf260a587b7d2e4e31`, released 23 March 2026 | `authority/`, `authority/provisioner/`, `api/`, `ca/`, `db/`, `templates/`, `errs/`, `integration/`, release workflows | Apache-2.0. Production use would add a Go CA service, storage, signing-key custody, provisioner policy, upgrades, backup/restore, audit, HSM integration, and vendor/community support obligations. It does not remove enterprise PKI ownership decisions. | Active 2026 release; signed release commit; release assets include checksums and Sigstore bundles; substantial unit/integration surface and public security/advisory process. Exact Windows TPM-attestation and UAM realm/status behavior are not provided by the project. | Similar in CA issuance, provisioners, revocation, templates, and renewal. Different because UAM needs Windows machine CNG/TPM proof, per-installation realm mapping, rapid UAM deny, clone handling, offline outbox identity, and enterprise proxy/VDI support. | Reuse as design input: narrow provisioners, one-use enrollment concepts, CA request/error separation, CRL lifecycle, signed release artifacts, lab CA automation. Do not copy: provisioner identity as UAM realm authority, default templates/lifetimes, broad API surface, or operational topology without measured fit. | **Lab CA candidate and reference only now.** Could become a dedicated-CA candidate only through HD-01 and full dependency/operations/G7 admission. |
| [`spiffe/spire`](https://github.com/spiffe/spire/tree/e78e2eeca03a8a420bfe1b23b6eaf3db0db78630), tag `v1.15.2`, commit `e78e2eeca03a8a420bfe1b23b6eaf3db0db78630`, released 9 July 2026 | `pkg/server/plugin/nodeattestor/`, `pkg/agent/plugin/nodeattestor/`, `pkg/server/ca/`, `pkg/server/datastore/`, `proto/spire/`, `test/`, `doc/` | Apache-2.0. Adopting it introduces server+agent daemons, plugin and workload-API surfaces, SPIFFE ID/trust-domain semantics, datastore/rotation operations, and a non-.NET endpoint component. | Highly active CNCF project; immutable signed release and checksums/attestation; broad integration/security work. Release notes include node-attestor, CA continuity, Windows, and CVE-related changes, demonstrating both maturity and ongoing security churn. | Similar in node attestation, X.509 workload identity, rotation, trust domains, plugins, and server state. Different because SPIRE targets workload identity and dynamic selectors; UAM’s Coordinator is a fixed Windows endpoint, realm/data authority is not a SPIFFE ID, and arbitrary plugin/selector channels conflict with the accepted fixed-capability model. | Reuse: attestation state separation, rotation overlap, CA journal/recovery thinking, explicit trust-domain concepts, plugin-failure handling, negative attestor tests. Do not copy: general selector/plugin ecosystem, agent workload API, identity naming as business realm, or daemon topology. | **Reference only.** Neither endpoint nor server dependency for the first design. |
| [`cert-manager/cert-manager`](https://github.com/cert-manager/cert-manager/tree/24e33194fb39488eff2bbf10c6dc640f407cad44), tag `v1.21.1`, commit `24e33194fb39488eff2bbf10c6dc640f407cad44`, released 29 July 2026 | `pkg/controller/certificates/`, `pkg/controller/certificaterequests/`, `pkg/controller/issuers/`, `pkg/issuer/`, `internal/controller/`, `test/`, `deploy/` | Apache-2.0. It is Kubernetes/OpenShift specific and assumes declarative cluster resources, Secrets, controllers, and issuer plugins. UAM’s initial server is not required to run Kubernetes, and private endpoint keys must not become Kubernetes Secrets. | Very active 2026 release with signed commits, tests, security hardening, and a patch release fixing renewal/controller regressions and dependency vulnerabilities. This is useful evidence that certificate reconciliation logic needs failpoints and exact-version qualification. | Similar in certificate request/issuance/renewal reconciliation, issuer abstraction, conditions, retries, and controller ownership. Different in key custody, Windows endpoint lifecycle, realm mapping, duplicate clones, mTLS request authorization, and network/offline model. | Reuse: declarative state/condition vocabulary, reconcile/idempotency patterns, renewal scheduling concepts, controller failure tests, issuer abstraction. Do not copy: Secret-based private-key storage, Kubernetes CRD/API authority, default retry/lifetime assumptions, or “Ready” as UAM ingress authorization. | **Reference only.** No dependency unless a future Kubernetes-based CA control plane is separately selected; even then not an endpoint component. |
| [`envoyproxy/envoy`](https://github.com/envoyproxy/envoy/tree/8eea3285d6bdb89f8ea34632cfe7ce1608a8f374), tag `v1.39.0`, commit `8eea3285d6bdb89f8ea34632cfe7ce1608a8f374`, released 14 July 2026 | `source/extensions/transport_sockets/tls/`, `source/common/tls/`, `source/extensions/filters/http/`, `source/common/http/`, `test/extensions/transport_sockets/tls/`, XFCC/header documentation and release security notes | Apache-2.0. A large C++ proxy brings Bazel/toolchain, container/binary supply chain, configuration/xDS, patch cadence, TLS library, logging, operational skill, and high-privilege network-boundary risk. | Mature CNCF gateway with extensive tests, fuzzing/security process, and active supported release line. The reviewed release contains TLS behavior changes and many memory/use-after-free/security fixes; exact patch qualification is mandatory. | Similar in mTLS termination, certificate validation, downstream/upstream TLS, header sanitation, connection draining, and rate/resource controls. Different because Envoy’s XFCC/header forwarding is not a UAM identity assertion, and its broad proxy features exceed the required fixed route. | Reuse: TLS configuration/test vectors, SAN/chain verification, header sanitation modes, connection drain, listener/backend isolation, fuzz/resource practices. Do not copy: trust XFCC by itself, broad dynamic configuration, first-party authorization from forwarded subjects, or unneeded filters/protocols. | **Conditional gateway implementation candidate after bake-off and admission.** Never an endpoint dependency; direct/L4 remains simpler default. |
| [`google/go-attestation`](https://github.com/google/go-attestation/tree/b6e905e7ae52937f02b5ca494dd1c6a3ac7a1003), tag `v0.6.1`, commit `b6e905e7ae52937f02b5ca494dd1c6a3ac7a1003`, released 19 June 2026 | `attest/`, `attest/internal/`, `attest/tpm_windows.go`, `docs/event-log-disclosure.md`, `x509/`, `attributecert/`, tests/workflows | Apache-2.0. Go library and TPM APIs do not fit the accepted C# endpoint by default; an FFI/helper process would add a new language/runtime, TPM command/parser, crash, installer, signing, and support boundary. | Maintained and used at Google, with security policy and tests. The project describes initial maturity, possible API changes, relatively immature Windows support, and TPM 1.2 not covered by CI. The reviewed release fixed parser/dependency issues, reinforcing the need for bounded evidence. | Similar in TPM/EK/AK/key attestation and event-log parsing. Different because UAM’s initial requirement is certificate key assurance, not general remote platform-state attestation; Windows AD CS attestation has a narrower supported profile. | Reuse: threat-model concepts, EK privacy caution, challenge/attested-key tests, malformed event-log bounds, disclosure warnings. Do not copy: treat platform attestation as endpoint integrity proof, expose EK/device identifiers broadly, embed Go TPM parser, or assume Linux behavior on Windows. | **Reference only.** Native Microsoft CNG/AD CS evidence is preferred for the first Windows prototype. |

## 14.3 Repositories screened but not used

The research also searched official Microsoft sample/TSS sources for TPM/CNG enrollment examples. `microsoft/TSS.MSR` and `microsoft/Windows-classic-samples` were not used as evidence or implementation recommendations because this review did not establish an exact current release/commit and a narrow maintained sample matching UAM’s CNG key, certificate lifecycle, realm, clone, and network threat model. Their broad sample surfaces would not prove UAM fitness. A future implementation spike may review a pinned file/commit under the same license, maintenance, test, security, and removal criteria; until then they are **neither dependencies nor claim support**.

## 14.4 Consolidated open-source decision

- Use a disposable generic lab CA; `step-ca` is a credible candidate for that role, but a minimal in-repository fixture CA or AD CS lab may be preferable depending on the experiment. The lab tool does not decide production CA ownership.
- Use SPIRE and cert-manager as state-machine/adversarial design references, not as architectural templates for UAM.
- Compare an admitted Envoy profile with the native ASP.NET/YARP or chosen enterprise gateway only if L7 termination is required. Direct/L4 needs no Envoy dependency.
- Use Microsoft Windows APIs/documentation and exact lab behavior as the primary CNG/TPM source. `go-attestation` is a useful independent threat/reference challenger, not the first Windows implementation.
- Any future repository update restarts exact tag/commit, license, advisory, build, test, SBOM/provenance, and UAM compatibility review. “Latest” is not an accepted dependency selector.

---

# 15. Source register

## 15.1 Source-use rules and citation map

The internal source fingerprints and limitations are in section 2.3. The public sources below were reviewed as of 31 July 2026. Their documented capability does not establish UAM fitness; the G7 CLI evidence does.

| Result area | Principal source IDs |
|---|---|
| Windows TPM/CNG assurance and enrollment | S01–S07 |
| AD CS/PKI ownership, revocation, migration, and operations | S08–S13, S29–S33 |
| .NET/ASP.NET mTLS, proxy/gateway, and TLS | S14–S22, S41–S47 |
| Proxy/VPN/customer-network behavior | S23–S26, S48 |
| Golden image, clone, VDI, vTPM | S27–S28, S34–S40 |
| PKIX, TLS, proof-of-possession, request binding, digest, key management | S41–S50 |
| Open-source implementation/reference review | S51–S55 |
| Runtime lifecycle and UUID identity | S56–S57 |

## 15.2 Primary public source table

| ID | Primary source and stable link | Source/release date and reviewed version | Claim supported | Limitation for UAM |
|---|---|---|---|---|
| S01 | Microsoft, [TPM Key Attestation](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/component-updates/tpm-key-attestation) | Updated 12 May 2025; reviewed 31 July 2026 | Native AD CS TPM key attestation requires Microsoft Platform Crypto Provider, RSA key, Enterprise CA; standalone CA and nonpersistent certificate processing are not supported | Documents one Windows/AD CS profile, not estate coverage, endpoint integrity, CA ownership, or UAM assurance policy |
| S02 | Microsoft, [Trusted Platform Module fundamentals](https://learn.microsoft.com/en-us/windows/security/hardware-security/tpm/tpm-fundamentals) | Updated 15 August 2025 | TPM key attestation can let a CA verify that a private key is TPM-protected and the TPM is trusted; TPM protection offers nonexportability/isolation/anti-hammering properties | Does not prove UAM key creation, ACL, firmware, vTPM, or resistance to privileged misuse |
| S03 | Microsoft, [CNG Key Storage Providers](https://learn.microsoft.com/en-us/windows/win32/seccertenroll/cng-key-storage-providers) | Updated 23 June 2026 | CNG separates key storage providers; Microsoft Platform Crypto Provider uses TPM; Software KSP is distinct | Provider selection/name is documented capability, not proof that one key was hardware-backed or nonexportable in the claimed estate |
| S04 | Microsoft, [Key Storage Property Identifiers](https://learn.microsoft.com/en-us/windows/win32/seccng/key-storage-property-identifiers) | Updated 8 May 2025 | Defines CNG properties used to inspect algorithm, provider/key/export/usage-related state | Effective values/provider behavior still require exact API/runtime tests; properties do not prove system integrity |
| S05 | Microsoft, [Key Storage and Retrieval](https://learn.microsoft.com/en-us/windows/win32/seccng/key-storage-and-retrieval) | Updated 17 December 2024 | Documents CNG key isolation/router/storage architecture and private-key operation model | General architecture; exact file/ACL/provider behavior and attack resistance remain implementation evidence |
| S06 | Microsoft .NET API, [`CngKeyCreationParameters.ExportPolicy`](https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.cngkeycreationparameters.exportpolicy?view=net-10.0) | .NET 10 API reviewed 31 July 2026 | Export policy is an explicit key-creation parameter, with provider defaults if not set | API setting alone does not prove effective provider nonexportability; runtime negative export tests remain mandatory |
| S07 | Microsoft, [`certreq`](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/certreq_1) | Updated 2 September 2025 | Windows can create certificate requests, submit/retrieve responses, and accept/install certificates | CLI is a lab/operations primitive, not a safe UAM protocol, idempotency design, or production CA decision |
| S08 | Microsoft, [What is Active Directory Certificate Services?](https://learn.microsoft.com/en-us/windows-server/identity/ad-cs/active-directory-certificate-services-overview) | Updated 20 May 2026 | AD CS issues/manages PKI certificates and supports CA/CRL roles | Capability overview; does not select AD CS or define UAM template, ownership, availability, or lifecycle |
| S09 | Microsoft, [PKI design considerations using AD CS](https://learn.microsoft.com/en-us/windows-server/identity/ad-cs/pki-design-considerations) | Updated 10 August 2023 | PKI requires deliberate CA hierarchy, crypto, HSM, validity, database, AIA/CDP, approval, and revocation planning | General planning guidance; organizational risk, costs, lifetimes, and topology remain human decisions |
| S10 | Microsoft, [Certification Authority role service](https://learn.microsoft.com/en-us/windows-server/identity/ad-cs/certification-authority-role) | Updated 27 July 2023 | Distinguishes enterprise/standalone root/subordinate CAs and their integration/features | Does not establish which UAM deployment can or should use each type |
| S11 | Microsoft, [Certificate Enrollment Policy Web Service configuration](https://learn.microsoft.com/en-us/windows-server/identity/ad-cs/configure-certificate-enrollment-policy-web-service) | Updated 27 March 2025 | Client-auth EKU and certificate-based enrollment service considerations exist | UAM does not automatically adopt AD CS web enrollment or its authentication/authorization model |
| S12 | Microsoft, [Certification Authority migration](https://learn.microsoft.com/en-us/windows-server/identity/ad-cs/migrate-certification-authority) | Updated 29 April 2025 | CA migration requires database/private-key/configuration continuity and planned validation | Production migration is PKI-owner work; UAM still needs consumer-first trust and exact canaries |
| S13 | Microsoft, [Decommission a Windows enterprise CA](https://learn.microsoft.com/en-us/troubleshoot/windows-server/certificates-and-public-key-infrastructure-pki/decommission-enterprise-certification-authority-and-remove-objects) | Updated 12 February 2026 | Decommission requires revoking outstanding certificates and preserving CRL availability/objects appropriately | Procedure is AD CS-specific and does not define UAM credential/status/audit retention |
| S14 | Microsoft, [Configure certificate authentication in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/certauth?view=aspnetcore-10.0) | Updated 28 April 2026; ASP.NET Core 10 | Client certificate authentication occurs at TLS and application handler resolves validated cert to a principal; proxy scenarios need review | Sample principal mapping is not UAM realm authority; revocation/status, gateway, cache, and connection semantics need custom evidence |
| S15 | Microsoft, [Configure ASP.NET Core to work with proxy servers and load balancers](https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/proxy-load-balancer?view=aspnetcore-10.0) | Updated 23 April 2026; ASP.NET Core 10 | Forwarded metadata is obscured by proxies and must be trusted only from known proxies/networks/configuration | Generic forwarded-header guidance; UAM rejects identity authority from plain forwarded headers |
| S16 | Microsoft, [YARP HTTP header guidelines](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/servers/yarp/header-guidelines?view=aspnetcore-10.0) | Reviewed 31 July 2026; ASP.NET Core/YARP 10 documentation | Existing forwarded headers are spoofable and YARP removes/replaces them by default; client-certificate data can be forwarded across a new connection | Plain forwarded cert/header remains insufficient for UAM; request-bound assertion and backend mTLS are additional recommendations |
| S17 | Microsoft, [YARP authentication and authorization](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/servers/yarp/authn-authz?view=aspnetcore-10.0) | Updated 30 July 2025 | Connection-bound incoming client-certificate identity does not automatically flow to backend; identity must be conveyed separately | Does not prescribe UAM assertion format or status freshness; header transform alone is not accepted |
| S18 | Microsoft, [YARP HTTP client configuration](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/servers/yarp/http-client-config?view=aspnetcore-10.0) | Updated 8 November 2025 | Proxy can authenticate itself to destinations with a client certificate | Gateway certificate represents gateway, not endpoint; UAM needs signed endpoint-context assertion |
| S19 | Microsoft, [Configure endpoints for Kestrel](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel/endpoints?view=aspnetcore-10.0) | Updated 1 June 2026; ASP.NET Core 10 | Kestrel endpoint/TLS configuration capabilities | Does not prove production topology, mTLS performance, revocation, or UAM policy |
| S20 | Microsoft .NET API, [`HttpClient`](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpclient?view=net-10.0) | .NET 10 API reviewed 31 July 2026 | .NET HTTP client supports connection pooling/handlers used by endpoint transport | Exact client-certificate selection, proxy, reconnect, HTTP/2/3, and status behavior require lab proof |
| S21 | Microsoft, [Protocols in TLS/SSL (Schannel SSP)](https://learn.microsoft.com/en-us/windows/win32/secauthn/protocols-in-tls-ssl--schannel-ssp-) | Reviewed 31 July 2026 | Windows Schannel provides platform TLS protocol support | Enabled protocols/ciphers/policy vary by supported Windows build/GPO and do not establish UAM compatibility |
| S22 | Microsoft, [Kestrel security considerations](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel/security-considerations?view=aspnetcore-10.0) | ASP.NET Core 10 reviewed 31 July 2026 | Server limits and security configuration are necessary for hostile inputs | Generic server guidance, not an identity-specific capacity or DoS proof |
| S23 | Microsoft, [`netsh winhttp`](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/netsh-winhttp) | Updated 20 August 2025 | Windows machine WinHTTP proxy can be inspected/configured, including advanced proxy settings | Command output may expose internal network configuration; UAM support cannot assume one proxy source/product/auth mode |
| S24 | Microsoft, [How Windows Update client determines proxy server](https://learn.microsoft.com/en-us/troubleshoot/windows-server/installing-updates-features-roles/windows-update-client-determines-proxy-server-connect) | Updated 12 February 2026 | Windows services can use system/user proxy discovery behavior and proxy authentication paths | Windows Update behavior is not automatically UAM `HttpClient` behavior; useful only as enterprise proxy complexity evidence |
| S25 | Microsoft, [Windows VPN settings in Intune](https://learn.microsoft.com/en-us/intune/intune-service/configuration/vpn-settings-windows-10) | Updated 14 April 2026 | Windows VPN profiles can define routes, DNS, proxy, authentication, and always-on behavior | Configuration capability does not prove any customer VPN product/profile or UAM route transition |
| S26 | Microsoft, [Global Secure Access connector troubleshooting](https://learn.microsoft.com/en-us/entra/global-secure-access/troubleshoot-connectors) | Updated 13 March 2026 | System proxy and TLS-inspection incompatibility can materially affect service TLS connectivity | Product-specific evidence; supports testing, not a universal TLS-inspection conclusion for every appliance |
| S27 | Microsoft, [Windows Enterprise multi-session remote desktops](https://learn.microsoft.com/en-us/intune/solutions/azure-virtual-desktop-multi-session) | Updated 16 April 2026 | Intune does not support cloning an already enrolled image; replicated enrollment/identity tokens cause failures | Intune-specific but strong analogous lifecycle evidence; does not itself define UAM VDI behavior |
| S28 | Microsoft, [Device identity and desktop virtualization](https://learn.microsoft.com/en-us/entra/identity/devices/howto-device-identity-virtual-desktop-infrastructure) | Updated 24 June 2026 | VDI device identity requires explicit lifecycle/uniqueness/stale-device planning | Entra identity is not UAM identity; platform-specific UAM tests remain required |
| S29 | Microsoft, [Set up a golden image for Azure Virtual Desktop](https://learn.microsoft.com/en-us/azure/virtual-desktop/set-up-golden-image) | Updated 19 June 2025 | Golden-image preparation/generalization is a distinct pre-deployment stage | Does not specify UAM cleanup; supports placing UAM enrollment after specialization |
| S30 | Microsoft, [Onboard nonpersistent VDI for Defender for Endpoint](https://learn.microsoft.com/en-us/defender-endpoint/configure-endpoints-vdi) | Updated 11 March 2026 | Nonpersistent VDI needs product-specific onboarding/update/identity handling | Defender’s supported design cannot be copied as UAM proof; threat/data/lifecycle differ |
| S31 | Microsoft, [Trusted Launch for Azure VMs](https://learn.microsoft.com/en-us/azure/virtual-machines/trusted-launch) | Updated 17 April 2026 | vTPM/Secure Boot VM security capabilities exist on a named cloud platform | Does not prove vTPM non-clonability, key portability, UAM assurance, or other hypervisors |
| S32 | Microsoft, [Azure Arc connected machine prerequisites — clone/golden-image considerations](https://learn.microsoft.com/en-us/azure/azure-arc/servers/prerequisites) | Updated 16 October 2025 | Clones/restores/golden images require special machine-identity handling | Azure Arc-specific; used as analogous operational evidence only |
| S33 | Microsoft, [Azure Monitor Agent management — cloning note](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-manage) | Updated 8 July 2026 | Cloning a machine with an enrolled agent is unsupported; deploy identity after clone | Product-specific analogous evidence, not UAM implementation proof |
| S34 | Microsoft, [Certificate Revocation List overview for NPS](https://learn.microsoft.com/en-us/windows-server/networking/technologies/nps/network-policy-server-certificate-revocation-list-overview) | Updated 1 November 2024 | CRL checking/distribution/caching is an operational part of certificate validation | NPS-specific presentation; UAM rapid deny and exact hard/soft-fail remain separate decisions |
| S35 | Microsoft, [Renew root CA certificate](https://learn.microsoft.com/en-us/windows-server/identity/ad-cs/renew-root-ca-certificate) | Updated 13 March 2025 | CA certificate/key renewal and chain/CRL continuity require deliberate handling | AD CS procedure; does not set UAM trust rollout or crypto choice |
| S36 | Microsoft, [`certutil`](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/certutil) | Reviewed 31 July 2026 | Windows provides CA/certificate-store/revocation diagnostics used in an approved lab | Output can expose CA/internal details; it is not a UAM API or shareable-evidence format |
| S37 | Microsoft, [TPM and secure boot / health attestation overview](https://learn.microsoft.com/en-us/windows/security/operating-system-security/system-security/protect-high-value-assets-by-controlling-the-health-of-windows-10-based-devices) | Updated 18 August 2025 | TPM can protect keys and participate in attestation/health evidence | Platform health attestation is broader than key assurance and does not prove UAM correctness |
| S38 | Microsoft, [Secure the Windows boot process](https://learn.microsoft.com/en-us/windows/security/operating-system-security/system-security/secure-the-windows-10-boot-process) | Updated 18 August 2025 | TPM can sign measured-boot evidence for remote attestation | UAM does not adopt measured boot in this result; capability is not device authorization by itself |
| S39 | Microsoft, [BitLocker and TPM known issues](https://learn.microsoft.com/en-us/troubleshoot/windows-client/windows-security/bitlocker-and-tpm-other-known-issues) | Updated 12 February 2026 | Real TPM estates have firmware/ownership/operational failure modes | BitLocker-specific; supports lab diversity and recovery planning only |
| S40 | Microsoft, [About Always On VPN](https://learn.microsoft.com/en-us/windows-server/remote/remote-access/overview-always-on-vpn) | Updated 7 May 2025 | Microsoft documents TPM key attestation as higher assurance for VPN certificates | VPN user/device certificate design is not UAM’s identity/realm design |
| S41 | IETF, [RFC 5280 — Internet X.509 PKI Certificate and CRL Profile](https://www.rfc-editor.org/rfc/rfc5280.html) | May 2008 | Normative PKIX chain, extensions, validity, CRL, and path validation basis | Standards profile is broad; UAM narrows algorithms/extensions and still needs implementation evidence |
| S42 | IETF, [RFC 6960 — Online Certificate Status Protocol](https://www.rfc-editor.org/rfc/rfc6960.html) | June 2013 | OCSP protocol and response/status semantics | OCSP freshness/availability alone does not meet UAM rapid application deny |
| S43 | IETF, [RFC 3647 — Certificate Policy and CPS Framework](https://www.rfc-editor.org/rfc/rfc3647.html) | November 2003 | PKI policy/practice statement categories and operational governance | Informational framework; does not approve UAM policy or ownership |
| S44 | IETF, [RFC 8446 — TLS 1.3](https://www.rfc-editor.org/rfc/rfc8446.html) | August 2018 | TLS 1.3 handshake, client authentication, resumption, and connection security basis | Actual Schannel/.NET/gateway support/configuration and per-request status remain empirical |
| S45 | IETF, [RFC 9325 — Recommendations for Secure Use of TLS/DTLS](https://www.rfc-editor.org/rfc/rfc9325.html) | November 2022 | Current secure TLS configuration principles and deprecated protocol guidance | General Internet guidance; enterprise compatibility and exact Windows profile still require decisions/tests |
| S46 | IETF, [RFC 9525 — Service Identity in TLS](https://www.rfc-editor.org/rfc/rfc9525.html) | November 2023 | Server service identity/hostname verification rules | UAM still needs approved names/trust distribution; enterprise inspection roots can alter trust context |
| S47 | IETF, [RFC 8705 — OAuth 2.0 Mutual-TLS Client Authentication and Certificate-Bound Access Tokens](https://www.rfc-editor.org/rfc/rfc8705.html) | February 2020 | Standard mTLS OAuth client authentication and certificate-bound token semantics | Deferred because initial direct ingestion does not require an OAuth token plane |
| S48 | IETF, [RFC 9449 — OAuth 2.0 Demonstrating Proof of Possession](https://www.rfc-editor.org/rfc/rfc9449.html) | September 2023 | DPoP request-bound asymmetric proof and replay considerations | OAuth/HTTP canonicalization, clocks, nonce, proxy, and key lifecycle add complexity; future profile only |
| S49 | IETF, [RFC 9421 — HTTP Message Signatures](https://www.rfc-editor.org/rfc/rfc9421.html) | February 2024 | Standard components and processing model for signing HTTP messages | Flexible profiles are easy to mismatch; UAM would need one strict closed profile and complete gateway/client evidence |
| S50 | IETF, [RFC 9530 — Digest Fields](https://www.rfc-editor.org/rfc/rfc9530.html) | February 2024 | HTTP content digest fields useful for binding gateway assertions to request content | Digest supplies integrity input, not sender authentication or semantic validity |
| S51 | NIST, [SP 800-57 Part 1 Revision 5 — Recommendation for Key Management](https://csrc.nist.gov/pubs/sp/800/57/pt1/r5/final) | May 2020 | Key lifecycle, cryptoperiod, compromise, transition, and management principles | Does not choose UAM algorithms/lifetimes or satisfy organizational compliance by citation |
| S52 | Envoy, [HTTP connection manager headers / X-Forwarded-Client-Cert](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_conn_man/headers) | Current documentation reviewed 31 July 2026 | XFCC behavior and sanitation modes illustrate gateway client-certificate forwarding risks/controls | XFCC remains a header, not UAM authenticated context or request-bound assertion |
| S53 | Smallstep, [`certificates` v0.30.2 release](https://github.com/smallstep/certificates/releases/tag/v0.30.2) and [commit](https://github.com/smallstep/certificates/tree/6e8ec61405239cf3f37b2bbf260a587b7d2e4e31) | Released 23 March 2026; commit `6e8ec61405239cf3f37b2bbf260a587b7d2e4e31` | Maintained open-source CA/provisioner/revocation/lab reference with signed/checksummed artifacts | Not selected for production; UAM Windows/realm/clone/network operations differ |
| S54 | SPIFFE, [`spire` v1.15.2 release](https://github.com/spiffe/spire/releases/tag/v1.15.2) and [commit](https://github.com/spiffe/spire/tree/e78e2eeca03a8a420bfe1b23b6eaf3db0db78630) | Released 9 July 2026; commit `e78e2eeca03a8a420bfe1b23b6eaf3db0db78630` | Node attestation, X.509 identity rotation, CA continuity, trust-domain/state-machine reference | Workload-identity/plugin architecture and threat model differ; reference only |
| S55 | cert-manager, [`v1.21.1` release](https://github.com/cert-manager/cert-manager/releases/tag/v1.21.1) and [commit](https://github.com/cert-manager/cert-manager/tree/24e33194fb39488eff2bbf10c6dc640f407cad44) | Released 29 July 2026; commit `24e33194fb39488eff2bbf10c6dc640f407cad44` | Certificate reconciliation/renewal/controller failure and security-maintenance reference | Kubernetes Secret/controller model is not UAM endpoint key custody or server architecture |
| S56 | Envoy, [`v1.39.0` release](https://github.com/envoyproxy/envoy/releases/tag/v1.39.0) and [commit](https://github.com/envoyproxy/envoy/tree/8eea3285d6bdb89f8ea34632cfe7ce1608a8f374) | Released 14 July 2026; commit `8eea3285d6bdb89f8ea34632cfe7ce1608a8f374` | Maintained mTLS gateway/TLS/header/security-test implementation candidate | Large operational/supply-chain surface; XFCC alone insufficient; conditional only |
| S57 | Google, [`go-attestation` v0.6.1 release](https://github.com/google/go-attestation/releases/tag/v0.6.1) and [commit](https://github.com/google/go-attestation/tree/b6e905e7ae52937f02b5ca494dd1c6a3ac7a1003) | Released 19 June 2026; commit `b6e905e7ae52937f02b5ca494dd1c6a3ac7a1003` | TPM attestation/key/device-identity reference and independent parser/threat input | Windows support described as relatively immature; Go/runtime mismatch; reference only |
| S58 | Microsoft, [.NET and .NET Core support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) | Reviewed 31 July 2026; .NET 10 active LTS and current servicing captured at execution time | Confirms accepted .NET family has an active supported line at research date | Exact patch must be reselected/locked at implementation and release; lifecycle is time-sensitive |
| S59 | IETF, [RFC 9562 — Universally Unique IDentifiers](https://www.rfc-editor.org/rfc/rfc9562.html) | May 2024 | UUIDv7 standard used for new UAM installation/credential/request/audit identifiers | UUID timestamp is not business time, ordering authority, authentication, or privacy approval |

## 15.3 Source-quality conclusions and conflicts

1. Microsoft documentation establishes Windows CNG, TPM, AD CS, ASP.NET, WinHTTP, VPN, and VDI capabilities. It does not prove the proposed composition under UAM’s exact Windows builds, enterprise GPO/EDR, CA, gateway, proxy, VPN, hypervisor, or support organization.
2. The Windows native AD CS TPM-attestation profile is materially constrained: RSA, Microsoft Platform Crypto Provider, Enterprise CA, and no nonpersistent certificate processing. This is a reason to keep attestation optional and measured, not to weaken assurance labels.
3. PKIX/OCSP/TLS standards establish protocol semantics, but rapid deny, realm mapping, request-bound gateway assertions, clone hold, and restore anti-rollback are UAM application controls.
4. Official VDI/agent guidance from adjacent Microsoft products repeatedly warns against cloning enrolled identity state. This supports the pre-enrollment-image recommendation but cannot prove every UAM platform.
5. Open-source CA, workload-identity, lifecycle-controller, gateway, and TPM libraries provide concrete design and adversarial input. Their different execution languages, platforms, trust domains, key custody, policy engines, and operations prevent architectural copy-by-analogy.
6. No public source establishes the production certificate lifetime, allowed software-key population, realm definition, CA/MDM owner, proxy/VPN support matrix, deny freshness, capacity, budget, staffing, or production approval. Those remain measurements and human decisions.
7. The accepted Batch 02 review remains deliberately unconsumed because it was not in this chat’s explicit allowlist. That evidence conflict is a mandatory Batch 03 reviewer gate, not an invitation to infer its decisions.

# 16. Confidence table for every major conclusion

Confidence describes the strength of the architecture conclusion, not the probability of a production incident. It combines the accepted project evidence, current primary sources, protocol maturity, and how much UAM-specific lab evidence is still missing. A **High** conclusion can still be blocked by a human decision or a named CLI gate.

| ID | Major conclusion | Confidence | Why | Evidence that would change the conclusion |
|---|---|---|---|---|
| C-01 | Each installed UAM instance needs a UAM-owned, immutable `installation_id` and its own credential lineage; machine name, hardware hash, directory object, certificate subject, serial number, or tenant-provided label is not the primary identity. | **High** | Stable UAM identity is required for retry, clone detection, transfer, audit, realm isolation, and replacement without treating mutable external attributes as authority. This is consistent with the accepted stable-identity and authenticated-context invariants. | A governed external system proving immutable, globally unique, non-reused installation identity across rebuild, clone, transfer, deletion, and restore, together with a migration and outage model that is simpler and preserves all invariants. |
| C-02 | Realm and device authority must be derived from the authenticated credential-to-installation registration record at the server, never from request body, ordinary HTTP headers, cache keys, URL paths, certificate display names, or endpoint database values. | **High** | It directly enforces the accepted rule that one realm cannot submit as another and prevents body/header/cache/store confusion. | A formally reviewed alternative authenticated-context mechanism that has equal issuer/audience/realm binding, no client-controlled authority, negative cross-plane tests, and a safe migration path. |
| C-03 | Initial enrollment must use a one-use, installation-scoped, realm-bound bootstrap authorization with a short validity window, explicit audience/product/release bounds, atomic consumption, and proof of possession of the newly generated key. | **High** | A reusable bootstrap secret becomes a shared fleet credential and cannot safely distinguish clones or replay. One-use atomic consumption gives a falsifiable boundary. | Evidence that an enterprise-managed authenticated enrollment channel provides stronger per-device freshness and identity with no bearer token at rest, while preserving offline deployment, re-enrollment, audit, and clone controls. |
| C-04 | UAM must never introduce a shared fleet secret as a fallback for failed certificate, TPM, proxy, VPN, or clock behavior. | **High** | One compromise would scale to the fleet, undermine per-installation revocation, and violate the primary G7 gate. | No ordinary evidence should reverse this. A baseline change would require a materially different non-shared asymmetric design, not a password/API key relabelled as a fallback. |
| C-05 | A machine CNG key created through the Microsoft Platform Crypto Provider is the preferred Windows assurance profile where the exact supported environment proves TPM-backed, nonexportable, usable behavior. | **High for direction; Medium for estate coverage** | Microsoft documents the platform provider and TPM assurance properties, but provider availability, firmware, virtualization, policy, and effective nonexportability vary. | G7 results showing unacceptable failure rate, support cost, provider defects, or incompatibility in an approved estate; or a stronger supported Windows key-isolation mechanism with lower operational risk. |
| C-06 | Provider name or a successful certificate request alone is not proof of TPM assurance; effective provider/key properties, negative export tests, key-use tests, and—where selected—attestation evidence must support the recorded assurance tier. | **High** | Configuration intent and certificate issuance do not establish actual key storage or export behavior. | A platform attestation API or managed enrollment contract that cryptographically and independently establishes the same facts, with verified failure semantics and deployment evidence. |
| C-07 | Native AD CS TPM key attestation is an optional higher-assurance profile, not the universal enrollment baseline. | **High** | The documented profile has material constraints: Enterprise CA, RSA, Microsoft Platform Crypto Provider, and no nonpersistent certificate processing. UAM must support non-AD-CS and VDI cases without mislabelling them. | A supported, broadly deployable enterprise attestation service that works across the approved CA/MDM/VDI estate, has acceptable privacy and operations, and passes the same clone/renewal/recovery gates. |
| C-08 | A software-protected nonexportable machine key is a lower-assurance exception, not an automatic fallback; it requires an approved policy, visible assurance label, bounded population, compensating controls, and migration path. | **High** | Software key state is more cloneable and more exposed to privileged compromise. Silent fallback would erase the assurance distinction. | A Windows/platform mechanism proving software-key clone resistance equivalent to the approved TPM profile, or a human decision prohibiting all lower-assurance enrollment and accepting the resulting coverage loss. |
| C-09 | Private keys must be generated and used in the endpoint key provider and must never be exported into enrollment messages, diagnostics, evidence, backups, support bundles, golden images, or migration packages. | **High** | Export would collapse proof of possession, clone containment, and device-specific revocation. | No ordinary evidence should change this. Ownership transfer and recovery must mint a new key instead. |
| C-10 | Certificate lifetime, renewal lead time, overlap, retry cadence, clock tolerance, and offline grace are policy/measurement decisions; the architecture should encode them as signed/configured bounds rather than timeless constants. | **High** | The prompt explicitly reserves lifetime/support policy to humans, and actual outage/clock/rollout distributions are unavailable. | Approved field measurements, support commitments, PKI capacity tests, and a human risk decision may replace bootstrap estimates with exact values. |
| C-11 | Renewal should normally keep the installation identity and enrollment epoch while issuing a new credential generation; key rotation should be supported and should not create a new device merely because the certificate changes. | **High** | It separates logical installation continuity from key/certificate lifecycle and supports overlap/retry without duplicate devices. | Evidence that the selected CA/enrollment service cannot support safe proof-of-possession renewal or that compliance requires every renewal to create a new installation lineage, with migration consequences reviewed. |
| C-12 | Re-enrollment after compromise, clone ambiguity, destructive repair, ownership transfer, or deleted local identity must create a new enrollment epoch and normally a new key/credential generation; old epochs stay denied and auditable. | **High** | Epoch separation prevents stale credentials or restored local state from silently rejoining the current lineage. | A formally reviewed recovery protocol proving equivalent anti-rollback and clone containment without a new epoch. |
| C-13 | PKIX path validation, certificate validity, CRL, and OCSP are necessary inputs but are not sufficient for rapid UAM deny; the ingestion boundary also needs a fresh application status/credential-generation check. | **High** | TLS sessions can be long-lived, revocation data can be cached or unavailable, and business decommission/clone hold may not map immediately to CA revocation. | A selected gateway/server stack proving bounded per-request revocation and UAM status freshness across connection reuse, outage, cache, and failover without a separate status plane. |
| C-14 | Rapid deny status must fail closed according to a measured freshness policy; stale or unavailable status cannot silently become allow, though the precise outage behavior and emergency procedure remain human decisions. | **High for security rule; Medium for operational profile** | Allow-on-stale makes decommission and clone containment non-deterministic. Fail-closed can create availability incidents and therefore needs explicit operations. | A risk-approved bounded stale-allow design with quantified exposure, immutable audit, constrained source/capability scope, and a successful incident exercise; absent that, fail closed remains the conservative rule. |
| C-15 | Certificate validation and device-status authorization must run for every new authenticated request context even when TLS connections are pooled or resumed; connection establishment alone cannot authorize an unlimited request stream. | **High** | Status, realm, epoch, credential generation, and policy can change while a TLS connection remains open. | A transport/gateway architecture that cryptographically constrains connection lifetime and proves immediate deny on all supported protocols and pools with lower complexity. |
| C-16 | Direct mTLS termination at the UAM ingestion boundary is the simplest initial topology where network architecture permits it. | **High** | It minimizes identity hops, header/assertion surfaces, cache confusion, and gateway key operations. | Measured scale, network segmentation, WAF/routing requirements, or organizational separation proving direct termination is infeasible or operationally worse than a controlled gateway. |
| C-17 | L4/TCP pass-through is acceptable when it preserves end-to-end TLS and the ingestion service remains the sole endpoint-certificate authenticator. | **High** | The load balancer does not reinterpret device identity, so the trust model stays close to direct termination. | A platform limitation that prevents source-independent health/routing or introduces connection handling that breaks mTLS, validated by the compatibility tests. |
| C-18 | L7 TLS termination is acceptable only through an explicitly trusted gateway that validates endpoint mTLS/status and sends a backend-mTLS-protected, request-bound, short-lived signed assertion; plain forwarded certificate or identity headers are not authority. | **High for security requirement; Medium for implementation choice** | Ordinary headers are spoofable/replayable and certificate forwarding alone is not bound to the exact request or fresh device status. | A standardized, fully verified gateway-to-backend mechanism with equivalent request binding, realm isolation, replay control, key rotation, and audit that is simpler than the proposed assertion. |
| C-19 | Backend code must strip/reject all endpoint-identity headers from untrusted paths and construct `AuthenticatedDeviceContext` only in one authentication boundary before routing to realm-specific stores, caches, queues, or logs. | **High** | Central construction prevents controller-specific parsing and cross-plane inconsistencies. | A verifiably equivalent framework mechanism with generated architecture tests and no user-controlled identity surface. |
| C-20 | An ordinary explicit HTTP proxy can coexist with origin mTLS only when it creates an end-to-end CONNECT tunnel and does not inspect TLS; this requires exact WinHTTP/.NET/customer-network tests. | **High for protocol principle; Medium for estate compatibility** | A CONNECT tunnel preserves the client-origin TLS handshake; authentication, PAC, proxy versions, policy, and client APIs can still fail. | Exact lab evidence showing the selected endpoint transport cannot use a required supported proxy mode, or a stronger approved non-tunnelling proof-of-possession design. |
| C-21 | Enterprise TLS inspection that terminates origin TLS breaks origin mTLS by design. UAM should initially require an inspection bypass for ingestion and enrollment endpoints. | **High** | The inspecting proxy, not the UAM server, becomes the TLS peer; the origin no longer receives the device certificate handshake. | A separately approved and implemented end-to-end asymmetric request proof profile that survives inspection, binds body/method/target/nonce/time/credential/realm, passes replay and canonicalization tests, and does not depend on a shared secret. |
| C-22 | Certificate-bound OAuth tokens, DPoP, or HTTP Message Signatures are useful future options for inspected or tokenized networks but add an issuer, token cache, request canonicalization, nonce, clock, and key-lifecycle plane; they are not needed for the first direct-mTLS slice. | **Medium-High** | Standards exist, but UAM’s initial bounded upload protocol can be simpler. | A mandatory customer network profile that cannot bypass TLS inspection and for which a bounded proof-of-possession prototype passes all security, privacy, operations, and compatibility gates. |
| C-23 | PAC/WPAD or user-browser proxy discovery must not silently become machine-service identity/network authority; supported proxy discovery/configuration modes need an explicit capability matrix. | **High** | The low-privilege machine Coordinator does not automatically share user/browser proxy state, and autodiscovery adds DNS/DHCP/policy/security variability. | A supported Windows enterprise configuration proving one safe, deterministic machine proxy policy across the approved estate, including credential and failover behavior. |
| C-24 | VPN transitions must be treated as transport state changes, not identity changes. The client should reconnect/retry idempotently, revalidate server identity, and retain unacknowledged data; VPN metadata must not select realm. | **High** | Network location is mutable and spoofable; the authenticated registration remains the realm authority. | A human-approved architecture in which a separate authenticated network access system provides stronger realm binding, with explicit migration and failure handling. |
| C-25 | Server certificate identity and trust must follow standard hostname/service-identity validation; enterprise inspection roots or private names are separate trust-distribution decisions and cannot be accepted by disabling validation. | **High** | Disabling hostname/chain checks turns network compatibility into interception vulnerability. | A different mutually authenticated secure channel with equivalent peer identity and rotation evidence. |
| C-26 | Golden images must contain only unenrolled UAM binaries/configuration and no live installation ID, certificate, private key, bootstrap token, pending enrollment transaction, device-status cache, or endpoint data. | **High** | Cloning enrolled identity creates duplicate credentials and ambiguous authority. Adjacent Microsoft product guidance also warns against cloning onboarded state. | A nonpersistent-pool identity service that deliberately supplies unique per-instance identity after clone and proves no copied secret/state, with separate lifecycle controls. |
| C-27 | Clone detection must immediately place involved installations/credentials in a bounded hold or deny state; it must not choose a winner based only on hostname, last-seen time, IP, or payload claims. | **High** | Those attributes are mutable and can let an attacker win a race. Hold preserves evidence and prevents two machines acting under one authority. | A cryptographically stronger freshness/attestation mechanism that can prove which instance retained authorized state and safely invalidate the other without ambiguity. |
| C-28 | Concurrent duplicate use is detectable through credential, epoch, nonce, boot/instance, and request evidence, but a perfectly sequential clone of a software key can be impossible to distinguish through PKI alone. | **High** | Two copies possessing the same software private key can take turns producing valid signatures. This is a fundamental observation limit, not a logging defect. | Hardware/vTPM attestation and monotonic state proving non-migratable uniqueness in every approved environment, or an external authoritative inventory signal with equivalent anti-clone properties. |
| C-29 | Persistent VDI can use the ordinary per-installation lifecycle only if the VM identity, key protection, rollback behavior, and ownership remain stable and pass the exact platform profile. | **Medium** | Persistent VMs resemble physical installations but snapshots, vTPM migration, rollback, and cloning can violate assumptions. | G7 platform evidence across snapshot/restore/migration/recompose proving stable nonduplicated keys and monotonic epoch/credential state; otherwise use a dedicated VDI profile or mark unsupported. |
| C-30 | Nonpersistent pooled VDI must not clone an enrolled persistent identity. It requires either per-instance enrollment with guaranteed cleanup and unique protected keying or a separately approved pool/broker identity profile; otherwise it remains unsupported. | **High for prohibition; Medium for feasible alternative** | Native AD CS TPM-attestation limitations and ephemeral lifecycle make ordinary device-certificate semantics unsafe. | A named VDI platform/profile passing repeated create/delete/recompose/concurrency/cleanup tests with unique identity, bounded CA/status load, no residual key, and approved ownership/cost. |
| C-31 | vTPM presence does not automatically equal physical TPM assurance; migration, export, backup, host trust, snapshot, and rollback properties must be recorded in a separate assurance profile. | **High** | Virtualization changes the key-protection and clone threat model. | Vendor/platform evidence plus G7 migration/restore tests proving nonexportable, nonduplicable, rollback-resistant behavior equivalent to the approved physical TPM tier. |
| C-32 | Decommission must deny the UAM installation/status first, then trigger certificate revocation and cleanup; CA revocation alone must not be the only rapid-control path. | **High** | Application deny can be faster and covers business states such as transfer or clone hold even before CRL/OCSP propagation. | A CA/gateway profile proving bounded immediate revocation on every request and connection, with no availability or cache gap. |
| C-33 | Ownership transfer or realm transfer is a controlled decommission plus fresh enrollment into the destination realm; changing a realm field on an existing credential is prohibited. | **High** | Reusing a credential across realms risks data, cache, status, and audit confusion. New enrollment creates a clear authority boundary. | A cryptographically authorized cross-realm transfer protocol that creates equivalent new credential lineage and proves no old-realm access, effectively preserving the same semantics under another implementation. |
| C-34 | Clock uncertainty must be an explicit state. Certificate/policy checks cannot treat a badly wrong endpoint clock as trustworthy; bootstrap/renewal recovery needs bounded server-time evidence and operator procedures rather than disabling validation. | **High** | Certificates, assertions, tokens, and replay controls are time-sensitive. Silent tolerance creates stale-credential exposure. | A protocol using hardware monotonic counters or trusted time attestation that reduces dependence on wall-clock state and passes offline/rollback tests. |
| C-35 | Offline devices may continue only within the still-valid credential/policy and approved offline rules; they cannot renew while disconnected, and expiry/deny recovery requires network or controlled re-enrollment. | **High** | PKI cannot issue or confirm current authority without a channel. Infinite grace would defeat revocation and expiry. | A formally approved offline credential hierarchy with bounded delegation, revocation exposure, secure time, and recovery evidence. |
| C-36 | CA/issuer/server trust rollover must be consumer-first: distribute and activate new trust before issuing or serving exclusively from it; retain old trust only for a bounded measured window; rollback republishes authorized state rather than accepting stale versions. | **High** | Prevents fleet-wide lockout and downgrade/freeze behavior. | A selected enterprise PKI mechanism with atomic dual-trust rollout and proven simpler semantics. |
| C-37 | Product release authorization, enrollment authorization, device credential issuance, gateway assertion signing, and CA trust are separate key purposes and should not share unrestricted keys or administration paths. | **High** | Purpose separation limits compromise blast radius and audit ambiguity. | A hardware-backed key-management design proving equivalent least privilege and independent revocation despite consolidation. |
| C-38 | Identity diagnostics and metrics must remain value-safe and bounded: no certificate, subject, SAN, key handle, bootstrap token, raw proxy/VPN configuration, internal address, or unbounded realm/device label in ordinary logs/metrics. | **High** | Device identity and enterprise network data are sensitive and high-cardinality; support evidence does not need raw secrets. | A narrowly approved restricted incident artifact with explicit purpose, access, expiry, deletion, and no-private-key rule—not a general logging change. |
| C-39 | Every supported combination of Windows build, key provider/TPM/vTPM, CA/enrollment route, proxy, VPN, gateway, protocol, EDR, and VDI must be a named compatibility profile with exact evidence; documentation cannot justify a universal support claim. | **High** | Platform and network composition determines behavior, and the supplied lab capability proves only that a connection path exists. | A vendor-supported conformance program covering the exact composition and UAM behavior, still supplemented by release canaries. |
| C-40 | A synthetic 6,000-endpoint enrollment/renewal/status/revocation exercise is useful for sizing but is not production capacity, SLO, support, or cost proof. | **High** | Device count alone omits retry storms, outage distributions, certificate sizes, cryptographic profile, network, HA, storage, operator procedures, and SLOs. | Representative approved measurements, identical production-shaped infrastructure benchmark, restore/incident drills, operations evidence, and human SLO/budget decisions. |
| C-41 | Smallstep `certificates` is suitable as a lab/reference CA candidate, not an automatic UAM production dependency. | **Medium-High** | It is maintained and relevant, but language, provisioner, operations, policy, support, and enterprise integration differ. | A formal dependency/service selection showing it best meets CA ownership, HSM, HA, audit, support, licensing, restore, and customer-integration requirements. |
| C-42 | SPIRE and cert-manager are reference-only for attestation and certificate lifecycle state machines; their workload/Kubernetes trust models should not be copied into the Windows endpoint architecture. | **High** | Their controller/plugin/workload identities, key storage, and deployment assumptions materially differ from per-installation Windows endpoint identity. | A deliberate platform change adopting their environment and threat model, with full baseline change proposal and migration evidence. |
| C-43 | Envoy is a conditional gateway implementation candidate only if the L7 topology is selected; its XFCC support does not remove the need for trusted-header stripping, backend mTLS, request binding, status freshness, and UAM-specific assertion verification. | **High** | Gateway certificate forwarding is not intrinsically authoritative or request-bound. | A selected Envoy profile and tested extension/filter that satisfies every assertion, replay, realm, status, rotation, capacity, and operations criterion. |
| C-44 | `go-attestation` and Microsoft sample/TSS repositories are reference/test inputs, not Windows endpoint runtime dependencies for the initial C#/.NET design. | **High** | Language/platform and support differences are large; Windows native APIs and official documentation remain the implementation authority. | A narrow independently verified helper providing indispensable parsing/attestation value with accepted supply-chain, ABI, support, and sandbox boundaries. |
| C-45 | The accepted Batch 01 review is valid predecessor context for contracts, Windows boundaries, strict parsing, repository/release, and evidence rules; this result does not reopen those decisions. | **High** | It is explicitly allowlisted and accepted with mandatory conditions. | A passed explicit baseline change proposal with stronger primary evidence and migration impact. |
| C-46 | The accepted Batch 02 review cannot be silently consumed in this chat because it was not allowlisted; the Batch 03 reviewer must reconcile this topic result with Batch 02 before promoting a combined baseline. | **High** | File allowlists are an evidence-authority boundary. Mentioning the missing predecessor does not authorize using its conclusions. | A reviewer prompt that explicitly allowlists both results and performs the required reconciliation. |
| C-47 | Passing G7 proves only the exact tested capability profile and primary identity/network claims; it is not legal, PKI ownership, lower-assurance, lifetime, realm-definition, pilot, or production approval. | **High** | The prompt and accepted evidence rules reserve those decisions to accountable humans and later gates. | Only designated authorities plus all applicable technical, operational, support, capacity, restore, and production-risk gates can change the status. |

# Final residual risk, blocked dependencies, and next stop/go gate

## Residual risk that research and G7 cannot eliminate

**FACT.** PKI authenticates possession of an authorized key and its registered lineage. It does not prove that endpoint telemetry is true, complete, lawful, correctly attributed, or uncompromised. A validly enrolled device, privileged local administrator, malicious or vulnerable signed release, kernel/EDR compromise, hypervisor or vTPM administrator, CA operator, gateway operator, status-store administrator, build/signing compromise, or server compromise can still cause false submission, misuse, denial, or disclosure within that authority.

**UNKNOWN.** The largest remaining technical and operational risks are:

- sequential clones of software-protected credentials may remain indistinguishable until an external inventory, concurrency signal, attestation change, owner report, or policy event exposes them;
- TPM and vTPM behavior varies by firmware, Windows build, virtualization platform, migration/backup settings, enterprise policy, and hardware failure mode;
- a CA, status service, gateway, DNS, proxy, VPN, time, or trust-distribution outage can create fleet-wide fail-closed loss of ingestion or enrollment;
- TLS inspection remains incompatible with origin mTLS unless bypassed or replaced by a future, separately proved asymmetric request-proof profile;
- certificate revocation, application deny, connection reuse, caches, replicas, and offline endpoints can create different propagation times unless the exact freshness contract is implemented and measured;
- nonpersistent VDI can create high enrollment, issuance, revocation, audit, and cleanup load and may be operationally or economically unsuitable even when technically possible;
- certificate/key recovery without export can increase support cost and require re-enrollment after TPM, OS, disk, motherboard, VM, or registry loss;
- fail-closed clone, status, clock, policy, or network behavior can cause legitimate data backlog and support incidents; operators may be tempted to add unsafe bypasses unless runbooks and authorization are enforced;
- metrics and support evidence can still leak organizational structure through rare counts or bounded identifiers if access, aggregation, retention, and incident handling are poorly governed;
- every customer proxy, VPN, gateway, CA, Windows, VDI, and security-product composition can differ from the lab; unsupported combinations may fail after updates;
- key lifetimes, lower-assurance population, realm semantics, CA ownership, support scope, staffing, cost, SLO/RPO/RTO, and production risk remain human-owned and cannot be proved by architecture prose;
- this topic result has not been reconciled with the accepted Batch 02 review because that file was outside this chat’s allowlist.

**Containment.** The proposed design limits those risks through per-installation asymmetric identity, proof-of-possession enrollment, explicit assurance labels, no key export, server-derived realm authority, monotonic epochs and credential generations, application status deny, certificate revocation, clone hold, strict gateway trust, request binding, bounded caches, privacy-safe evidence, exact capability profiles, kill switches, and stop-on-failure experiments. These controls reduce blast radius and ambiguity; they do not make the endpoint, PKI, network, or operators infallible.

## Blocked dependencies and human authority

The following remain blocking before production identity or customer-network enablement:

1. **HUMAN DECISION:** enterprise CA/MDM/PKI ownership, hierarchy, HSM/key custody, availability, backup, restore, audit, incident, and decommission responsibilities;
2. **HUMAN DECISION:** whether lower-assurance software keys are permitted, for which devices/realms, with what compensating controls and migration deadline;
3. **HUMAN DECISION:** certificate lifetime, renewal window, overlap, offline expiry/recovery, deny/status freshness, clock tolerance, and support policy;
4. **HUMAN DECISION:** authoritative realm definition, creation/merge/split/transfer rules, enrollment routing, and ownership of realm-to-issuer/policy mapping;
5. approved supported Windows/TPM/vTPM/VDI/proxy/VPN/gateway/CA profiles and assigned support owners;
6. an admitted enrollment/CA/status/gateway implementation stack with exact source/binary/license/SBOM/provenance/support evidence;
7. signing and trust-distribution authorities for bootstrap, product policy, issuer bundles, gateway assertions, release, emergency deny, and recovery;
8. approved network endpoints/names, DNS/trust model, TLS-inspection bypass or alternative proof profile, and customer compatibility process;
9. measured enrollment, renewal, status, revocation, reconnect, outage, and recovery behavior—including a production-shaped load and restore exercise after the synthetic gate;
10. incident and support exercises for CA compromise, gateway compromise, key compromise, clone, clock failure, proxy/VPN outage, trust rollover, VDI cleanup, and realm misrouting;
11. Batch 03 reviewer reconciliation with the accepted Batch 02 result and all parallel Batch 03 topics;
12. later durable-ingestion, capacity, long-outage, deletion, restore, replay, release, and production-risk gates from the accepted program sequence.

## Exact next stop/go gate

**GO now** only for repository-scoped pure contracts and models; T1 fictional enrollment/certificate/realm fixtures; strict parsers and negative vectors; CNG/TPM capability inventory code; lab-CA and disposable-VM harnesses; gateway-assertion prototypes; status/revocation state machines; clone/clock/proxy/VPN simulations; evidence schemas; architecture tests; and placeholder-only customer compatibility scripts. These activities must use synthetic identities and must never export a private key or include connection material, internal addresses, credentials, personal data, or production activity in evidence.

**STOP** before creating or integrating a production CA/template/provisioner, production bootstrap route, production trust bundle, customer proxy/VPN exception, production gateway assertion key, real realm mapping, enrolled golden image, lower-assurance automatic fallback, pilot, or production deployment.

The next technical stop/go gate is **G7 / global proof gate 08 — device identity and enterprise-network compatibility**. It passes only when an immutable `g7-device-identity-gate.json` binds the exact source tree, contracts, release, Windows images, key providers, TPM/vTPM/VDI profiles, CA/enrollment/status/gateway implementations, proxy/VPN/TLS profiles, T1 fixtures, experiments, primary-source/dependency records, owners, runbooks, first failures, canary scans, and cleanup receipts, and all of the following are true:

```text
G7_PRIMARY_PASS =
    SHARED_FLEET_SECRET_PATHS = 0
    AND PRIVATE_KEY_EXPORTS_OR_EVIDENCE = 0
    AND DUPLICATE_BOOTSTRAP_SUCCESS = 0
    AND PROOF_OF_POSSESSION_BYPASSES = 0
    AND UNKNOWN_OR_WRONG_REALM_ACCEPTED = 0
    AND REVOKED_OR_DENIED_CREDENTIAL_REQUESTS_ACCEPTED_AFTER_FRESHNESS_BOUND = 0
    AND EXPIRED_CREDENTIAL_REQUESTS_ACCEPTED_OUTSIDE_APPROVED_CLOCK_PROFILE = 0
    AND CLONED_IDENTITY_REQUESTS_ACCEPTED_AFTER_CLONE_HOLD = 0
    AND STALE_OR_LOWER_EPOCH_ACCEPTED = 0
    AND UNTRUSTED_IDENTITY_HEADER_OR_ASSERTION_ACCEPTED = 0
    AND CROSS_REALM_CACHE_STORE_ROUTE_RESULTS = 0
    AND ENROLLED_GOLDEN_IMAGE_OR_RESIDUAL_PRIVATE_IDENTITY = 0
    AND TLS_INSPECTION_MISCLASSIFIED_AS_ORIGIN_MTLS = 0
    AND UNSUPPORTED_CAPABILITY_RECORDED_AS_PASS = 0
    AND PRIMARY_CANARY_MISSES = 0
    AND CLEANUP_RESIDUE = 0
    AND BLOCKING_OWNER_COUNT = 0
    AND BLOCKING_ADR_COUNT = 0
```

A G7 pass applies only to the named profiles and proves only those statements. The eventual Batch 03 reviewer must then reconcile this result with the accepted Batch 02 review and the parallel durability/release/diagnostic topics. Production remains stopped until the four mandatory human decisions, applicable later proof gates, support/incident readiness, capacity/restore evidence, and designated production-risk approval are complete.
