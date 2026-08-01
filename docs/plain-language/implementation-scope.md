# UAM implementation scope

This page explains what we intend to build now, what we only prepare for, and what remains later work. It should be updated whenever the delivery scope changes.

## Access control decision

The first implementation will **prepare a secure authorization boundary**, but it will **not build the organization’s final role and access system**.

This avoids expensive rework later without making roles, portal administration, or organizational access workflows part of the first delivery.

## Build or enforce now

- Keep realm and tenant data separated from the beginning.
- Put authorization decisions behind one clear service or module.
- Deny an action when authorization information is missing or unknown.
- Describe protected actions as capabilities, such as `ViewDeviceHealth` or `ManageApplicationRegistry`.
- Require protected entry points to ask the authorization boundary before doing work.
- Include the actor, realm, capability, target and outcome in the audit contract.
- Use fictional actors, realms and capabilities in automated tests.
- Keep organization-specific role names and assignments out of source code.

The central question is:

> May this actor use this capability on this target in this realm?

During early development, a small test-only implementation may answer that question. Production access must remain disabled until the later access-control work is approved and tested.

## Prepare now, but do not complete now

- A small authorization interface and result type.
- A closed capability catalogue owned by the product release.
- Test helpers for allowed, denied, unknown and cross-realm cases.
- Audit fields that can later explain why access was allowed or denied.
- Architecture tests preventing direct bypass of the authorization boundary.

Preparation must stay small. It must not introduce a policy engine, administration portal, workflow system or real organization mappings before they are needed.

## Build later

- Real organizational roles and ownership.
- Role-to-person or group assignments.
- Identity-provider integration.
- Final RBAC or ABAC policy evaluation.
- Just-in-time access.
- Approval and separation-of-duty workflows.
- Break-glass access.
- Access reviews and administration screens.
- Production audit, support and incident procedures for access control.

These features require human decisions about purposes, users, responsibilities, approvals, risk and support. Research or code cannot approve those decisions.

## Out of scope for the first delivery

- Deciding which real people receive which permissions.
- Recreating current organizational roles without owner validation.
- Hard-coding department, job-title or employee mappings.
- Person-level activity views, exports or cross-realm oversight.
- Treating a successful login as sufficient authorization.

## Done criteria for the early preparation

The preparation is complete when:

1. protected operations use the central authorization boundary;
2. missing and unknown authorization fails closed;
3. cross-realm requests are denied in automated tests;
4. fictional capability tests cover allowed and denied outcomes;
5. audit contracts can record the decision without sensitive values;
6. no real role, person, group or organization mapping exists; and
7. production portal access remains disabled.

## Reconsideration trigger

Start the later access-control implementation only when portal administration is an approved delivery milestone and accountable owners have decided the real purposes, capabilities, roles, assignments, approvals, support model and audit requirements.
