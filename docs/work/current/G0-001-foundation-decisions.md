# G0-001 — Approve the fictional evidence foundation

**Status:** Blocked on named human decisions  
**Gate/milestone:** [G0 fictional evidence foundation](../../milestones/G0-fictional-evidence-foundation.md)  
**Accountable human:** UNASSIGNED

## Useful outcome

The small set of decisions that controls G0 is explicitly accepted or amended, so fixture and oracle implementation can start without an agent inventing policy or ownership.

## In scope

- Assign the G0 gate owner and reviewers.
- Review the seven initial ADRs.
- Express the initial privacy ceiling as testable fictional examples.
- Resolve or assign experiments for contract contradictions that affect the first fixtures.
- Record dated decisions and owners.

## Out of scope

- Writing the G0 implementation.
- Approving production monitoring, retention, access, deployment, or rollout.
- Choosing unmeasured numeric settings.

## Inputs and source of truth

- [Initial ADRs](../../adr/README.md)
- [G0 milestone](../../milestones/G0-fictional-evidence-foundation.md)
- [Implementation scope](../../plain-language/implementation-scope.md)
- [Final research baseline](../../../research/implementation/synthesis/result-implementation-technical-baseline.md)

## Acceptance evidence

1. Accountable owner and required reviewers are named.
2. Each initial ADR has an explicit dated disposition.
3. Privacy transformations needed by the first fixtures have approved examples.
4. Unresolved technical claims have a named experiment, owner, and decision deadline.
5. No production or later-gate approval is implied.

## Failure, recovery, and rollback

An unclear or disputed decision remains `Proposed`; implementation does not guess. A decision can be superseded through a new ADR that states migration and fixture effects.

## Validation commands

```bash
./scripts/validate-repository.sh
```

## Next safe task

Create G0-002 for the first versioned contract schemas and invalid examples after this task is accepted.
