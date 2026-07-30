# Prompt 07 — final synthesis and technical baseline

You are the chief architect chairing a design review. Today is July 2026. I will attach six independent research results:

- `01-architecture-result.md`
- `02-language-stack-result.md`
- `03-security-privacy-result.md`
- `04-windows-feasibility-result.md`
- `05-scale-reliability-result.md`
- `06-requirements-migration-result.md`

Read every result completely. Preserve its citations. Do not resolve disagreements by majority vote or by choosing the most confident wording. Trace claims back to evidence quality, constraints, and explicit assumptions.

## Task

Produce one coherent, decision-ready technical baseline for UAM. Identify agreements, contradictions, missing evidence, and recommendations that depend on unknown business policy or production measurements. Reconcile terminology and component boundaries.

## Required output

1. Executive recommendation in easy language.
2. Requirements and constraints that all designs must satisfy.
3. Recommended endpoint, ingestion, data, control-plane, and portal architecture with a text diagram.
4. Recommended language/stack by component, including supported versions and replacement review dates.
5. Decision register: decision, chosen option, alternatives, rationale, evidence, confidence, owner, review trigger, and ADR status.
6. Contradiction register showing which research packs disagree, why, and the proposed resolution or experiment.
7. Risk register combining architectural, Windows, security/privacy, scale, migration, and operational risks without duplicates.
8. Minimal proof program on the Windows VM and server test environment, ordered by ability to invalidate the design. Give pass/fail gates.
9. First Browser History vertical-slice scope: included, excluded, interfaces, data contract, privacy rules, tests, telemetry, and acceptance criteria.
10. Phased roadmap with dependencies and decision gates, not calendar promises unsupported by staffing.
11. “Decide now”, “measure first”, “ask stakeholders”, and “defer safely” lists.
12. Source-quality appendix noting stale, vendor-only, conflicting, or weakly supported claims.

Rules:

- Never describe the system as bulletproof; state residual risk.
- Prefer the simplest design that satisfies measured requirements and failure containment.
- Do not turn estimates into requirements.
- Do not silently choose legal, privacy, ownership, retention, or budget policy.
- If a recommendation lacks evidence, convert it into a bounded experiment.
- End with the exact first ten actions for the project team.

