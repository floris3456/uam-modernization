# Prompt 02 — language and technology stack

You are a staff engineer selecting a long-lived implementation stack for a Windows endpoint product and its server platform. Today is July 2026. Research current supported versions and roadmaps using primary sources. I attached `code-reference.md`; inspect the legacy agent, PSU app, and DDL to understand the real migration surface.

## Need

Select the best language(s) and complete stack for a system with at least 6,000 Windows endpoints. The endpoint needs a Windows Service, safe updater, browser/recent-item/process collectors, SQLite outbox, signed modular tasks, HTTPS uploads, low idle resource use, diagnostics, and reliable deployment. The server needs device/control APIs, asynchronous processing where justified, relational storage, observability, and a modern admin portal.

The current proposal assumes C#/.NET for endpoint and APIs, SQLite locally, PostgreSQL centrally, and a modern web client. This is a hypothesis, not a decision.

## Compare

Compare C#/.NET, Rust, Go, and a realistic mixed approach. Explain whether PowerShell has any bounded compatibility role. Add another candidate only if it is genuinely competitive.

Evaluate with weighted criteria:

- Windows APIs, Services, security descriptors, code signing, installers, ETW/Event Log, user-session access, and enterprise deployment.
- Browser SQLite/profile access and filesystem edge cases.
- Memory, startup, deployment size, native/AOT options, crash containment, and debugging.
- Local SQLite maturity and transaction correctness.
- Async networking, retry libraries, serialization/schema evolution, telemetry, and testing.
- Plugin/task isolation and compatibility across upgrades.
- Supply-chain security, dependency health, LTS policy, tooling, CI, developer availability, and maintainability for 7–10 years.
- Server API/worker ecosystem, queue choices, database access, portal options, authentication/RBAC, and operations.
- Migration cost from the existing PowerShell/SQL behaviour.

## Required output

1. One recommended default stack, with exact responsibility by language/component.
2. Weighted decision matrix with weights justified and sensitivity analysis showing what would change the winner.
3. Endpoint stack: runtime/deployment mode, service hosting, installer/updater, SQLite library, serialization/contracts, HTTP/resilience, logging/telemetry, testing, packaging/signing, and task isolation.
4. Server stack: API, authentication, queue/inbox, workers, database/access layer, migrations, portal, observability, deployment, and testing.
5. Supported-version/LTS table valid in July 2026, with primary citations and warnings about upcoming end-of-support dates.
6. Where not to share code or technology between endpoint and server.
7. Risks and mitigations of the chosen stack.
8. Two viable fallback stacks and conditions that favour them.
9. A two-week proof-of-technology plan with pass/fail measurements.
10. ADRs required before implementation.

Do not select a language because it is popular. Do not treat synthetic benchmarks as product performance. Mark facts, estimates, assumptions, and recommendations separately.

