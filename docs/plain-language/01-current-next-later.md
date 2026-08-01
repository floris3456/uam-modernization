# Current, next, and later

This is the fastest way to understand the delivery boundary. “Later” ideas are recorded so that today’s design does not block them; recording them does not put them in today’s scope.

| When | What we do | What we do not do |
| --- | --- | --- |
| Current: preparation | Freeze research evidence, keep decisions readable, sanitize source profiles, define task/validation rules, and assign required human decisions. | No production client, server, portal, VM changes, or live data. |
| Next: G0 | Build fictional scenarios, independent expected answers, contract fixtures, fault cases, and a deterministic test runner. | No browser collection, Windows service, network ingestion, or real identity. |
| After G0 gate: G1 | Prototype the Windows coordinator, user host, task host, session/identity handling, and secure IPC on the lab VM. | No broad rollout and no claim of compatibility without measurements. |
| G2–G5 | Acquire browser evidence safely, transform it, and persist/retry it locally. | No production rollout until privacy, durability, and compatibility gates pass. |
| Server/platform | Add authenticated ingestion, durable inbox processing, lifecycle operations, deployment, and device identity. | Numeric capacity or database choices are not accepted without experiments. |
| Portal/governance | Add administration workflows and real authorization only after owners define purpose, roles, approvals, and audit access. | Early code must not invent organizational permissions. |
| Migration | Discover consumers, compare old/new outputs, cut over reversibly, monitor residue, then remove legacy credentials and components. | Never decommission from research confidence alone. |

## Gate rule

Only the current gate may be implemented. A gate passes when its named evidence exists, validation succeeds, residual risks are recorded, and an accountable human accepts the gate record.

## Human decisions still required

- legal and organizational purpose and privacy ceiling;
- accountable product, security, privacy, data, endpoint, and operations owners;
- supported Windows/browser/virtualization matrix;
- production retention and deletion policy;
- real roles, capabilities, approvals, and break-glass rules;
- signing, deployment, certificate, database, hosting, licensing, and budget choices;
- measured service levels, capacity thresholds, and rollout risk acceptance.

Use [implementation scope](implementation-scope.md) for the specific early access-control boundary.
