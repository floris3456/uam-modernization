# G0 — Fictional evidence and test-oracle foundation

**Status:** ready for human decisions, then implementation  
**Why first:** every later component needs trustworthy contracts, fixtures, and failure cases.

## Useful result

A developer can run one deterministic command and see that fictional activity flows through agreed transformations and state transitions, with independently generated expected answers. Failures are reproducible and contain no real user data.

## Work included

- Versioned fictional personas, realms, devices, applications, browser records, clocks, and fault schedules.
- Small, reviewable contract schemas and valid/invalid examples.
- An oracle implementation that does not call production transformation code.
- Stable scenario identifiers and seeds.
- Golden expected outcomes with explicit comparison rules.
- Cases for duplicates, reordered input, cursor boundaries, crashes, retries, privacy transformation, realm isolation, and time behavior.
- A deterministic runner suitable for local use and CI.
- A minimal capability boundary tested only with fictional identities; no organizational role system.

## Not included

- Reading a real browser profile.
- Installing a Windows service or scheduled task.
- Connecting to the Windows VM or a server.
- Real people, tenants, application addresses, credentials, or policies.
- Production database, portal, deployment, capacity, retention, or access-control implementation.

## Required human decisions before coding

1. Name the accountable G0 gate owner and reviewers for architecture, security, privacy, and test quality.
2. Confirm the initial product privacy ceiling expressed as testable fictional transformations.
3. Accept or amend ADR-FS-001 through ADR-FS-005, ADR-FS-030, and ADR-FS-032.
4. Confirm the initial contract vocabulary and whether the research baseline’s open contradictions need experiments before fixture design.

## Gate evidence

- All G0 scenarios pass twice with byte-equivalent generated outputs.
- The oracle is demonstrably independent from production implementations.
- Mutation or deliberately incorrect implementations are caught by the oracle suite.
- Invalid contracts fail with stable error categories.
- Cross-realm and privacy-negative cases fail closed.
- No secrets, personal data, internal addresses, or raw catalogue values appear in fixtures or logs.
- The full repository validator passes on Linux and the planned Windows validation command is defined before G1.
- A signed gate record lists evidence hashes, untested risks, and the accountable acceptance.

## Failure and recovery behavior

A failed scenario must preserve its scenario ID, seed, sanitized inputs, expected output, actual output, and stable error category. Rerunning it must reproduce the failure. Corrupt or unknown fixture versions are rejected rather than guessed.

## First ordered backlog

1. Resolve and record the four human decisions above.
2. Convert the G0 research conclusions into small accepted ADR amendments where needed.
3. Define the first contract schemas and deliberately invalid examples.
4. Implement the fictional scenario model and deterministic generator.
5. Implement the independent oracle.
6. Add privacy, cursor, deduplication, time, realm, and controlled-fault scenarios.
7. Add mutation/falsification checks and CI.
8. Produce and review the G0 gate record.

The active task brief is [G0-001](../work/current/G0-001-foundation-decisions.md).
