# Prompt 03 — security and privacy threat model

Act as a product security architect and privacy engineer. Today is July 2026. Build a practical threat model for the UAM replacement using current primary sources and standards. Inspect the attached `UAM-CODE-REFERENCE.md`, but never reproduce internal identifiers or potentially sensitive example content unnecessarily.

UAM is a Windows endpoint agent collecting specifically approved browser, recent-item, and process usage signals. Proposed flow: signed updater and service, local SQLite outbox, endpoint-side allowlisting/redaction, authenticated HTTPS batches, ingestion/queue/workers/database, and an RBAC admin portal. Scale is at least 6,000 endpoints. The legacy system placed database access and too much trust on endpoints.

## Research task

Model assets, actors, trust boundaries, attacker capabilities, privacy harms, abuse cases, and supply-chain risks. Cover compromised endpoints, malicious local users/admins, stolen device identity, replay, rogue task packages, update-key compromise, API abuse, tenant confusion, insider/admin misuse, queue/database exposure, telemetry leakage, diagnostic escalation, and deletion/retention failures.

Evaluate:

- mTLS, managed device certificates, hardware-backed keys, and short-lived token designs.
- Package signing, offline roots, online signing, rotation, revocation, downgrade prevention, and recovery.
- Windows service account/privileges and access to per-user browser data.
- SQLite protection, DPAPI options, metadata leakage, tampering, quotas, and secure deletion limitations.
- Endpoint minimization rules for URLs, paths, query strings, process details, usernames, and diagnostic data.
- API authorization, anti-replay/idempotency, schema validation, decompression bombs, rate limiting, and logging redaction.
- Portal capability RBAC, approval, break-glass access, scoped detail access, immutable audit, and support workflows.
- Retention, data-subject handling, purpose limitation, exports, backups, and cryptographic deletion boundaries.

## Required output

1. System/trust-boundary description and prioritized asset list.
2. Threat register with likelihood, impact, affected boundary, prevention, detection, response, residual risk, owner, and verification test.
3. Misuse/abuse cases, including authorized administrators using data for an unintended purpose.
4. Recommended device identity and update-signing designs with alternatives.
5. Endpoint data-minimization specification with safe defaults.
6. Security logging versus privacy table: what to record, redact, hash, restrict, retain, or never collect.
7. Minimum security controls for pilot and additional controls before broad rollout.
8. Incident and key-compromise recovery scenarios.
9. Security/privacy acceptance tests suitable for CI, lab, pilot, and operational exercises.
10. Unresolved legal/policy questions clearly separated from technical advice.

Use applicable standards and official platform guidance, but do not present legal advice. State residual risks plainly.

