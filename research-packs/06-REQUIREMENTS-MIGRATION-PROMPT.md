# Prompt 06 — requirements, acceptance, and migration

You are a business analyst and migration architect experienced with endpoint platforms. Today is July 2026. Turn the supplied evidence into an implementation-ready requirements and transition framework. Inspect `UAM-CODE-REFERENCE.md`; treat legacy behaviour as evidence, not automatically as a requirement.

## Situation

The legacy UAM agent collects browser history, Recent/Quick Access, and processes; maintains checkpoints; buffers failed SQL work; produces detail and minimal/aggregate logging; supports global settings and user overrides; and reports errors. A PowerShell Universal app manages users, logging data, organization views, settings, exclusions, application matches, scripts/schedules, errors, and audit. The new design aims for endpoint minimization, modular tasks, safe updates, offline outbox, API ingestion, modern portal, typed versioned policy, capability RBAC, and at least 6,000 endpoints.

## Research task

Create a method for deciding what to preserve, redesign, or remove. Identify stakeholders and decisions that code cannot answer. Define a safe migration that does not silently change privacy, reporting, checkpoints, aggregates, operational support, or administrative authority.

Assess configuration migration, application matching, exclusions-to-allowlists, schedules/scripts, minimal aggregates, detail archives, errors/audit, customer HR/AD data, parallel operation, canary rollout, comparison tolerances, rollback, legacy read-only operation, credential removal, archival, and final decommissioning.

## Required output

1. Stakeholder and decision-owner map.
2. Requirement catalogue grouped into functional, privacy, security, reliability, operations, data, portal, deployment, and support requirements. Give each an ID, rationale, evidence, priority, acceptance test, and owner-to-confirm.
3. Legacy behaviour disposition matrix: preserve, deliberately change, retire, or investigate.
4. Open-question interview guide written in easy language for product owner, privacy/security, administrators, support, infrastructure, data/reporting, and representative users.
5. Data/configuration migration matrix with provenance, transformation, validation, rollback, retention, and “do not migrate automatically” flags.
6. Phased pilot/canary plan with entry/exit criteria and automatic rollback limits.
7. Parallel-run comparison method that avoids unnecessary sensitive detail duplication.
8. Operational readiness checklist, ownership model, runbooks, training, and support handover.
9. Decommission checklist proving endpoint credentials, schedules, writes, buffers, portal functions, and retained data are handled safely.
10. Definition of Ready for the first Browser History vertical slice and Definition of Done for production rollout.

Do not invent business or legal decisions. Mark them as questions with a proposed default and consequence.

