# Prompt 04 — Windows feasibility and prototype plan

You are a senior Windows systems engineer. Today is July 2026. Determine what must be proven on real Windows machines before committing to the UAM design. Use current Microsoft, browser-vendor, SQLite, and runtime primary sources. Inspect the attached legacy agent in `code-reference.md` for actual behaviours and edge cases.

## Context

The new agent may be a Windows Service coordinating separate tasks for Chromium/Firefox history, Windows Recent/Quick Access, process inventory, and later browser-extension inventory. It must work across user sessions, operate offline using SQLite, update atomically, rollback safely, and use low privileges. A Windows VM is available for experiments.

## Questions

- Can a service safely and reliably discover active/local profiles and read user-owned browser/history data without excessive privilege?
- Which work belongs in the service versus a per-user process/session agent?
- How should locked SQLite browser databases, WAL files, profile changes, timestamp formats, sleep/reboot, fast user switching, RDP, multiple users, profile containers, and browsers being updated be handled?
- What Windows account, filesystem ACLs, service recovery options, job objects, named-pipe security, and process isolation should be used?
- How should MSI/MSIX/custom bootstrapper, Authenticode, atomic directory switching, service replacement, rollback, and enterprise deployment interact?
- How should local SQLite survive power loss, full disks, antivirus interference, corruption, schema migration failure, and long backlogs?
- Which claims require physical Windows devices rather than only a VM?

## Required output

1. Recommended Windows process/session architecture with reasons.
2. Compatibility matrix covering supported Windows versions, x64/ARM64 where relevant, browsers, single/multi-user sessions, domain/Entra scenarios, and profile technologies.
3. Experiment backlog ordered by architectural risk. Each experiment must state hypothesis, setup, steps, instrumentation, pass/fail threshold, cleanup, and expected duration.
4. Detailed first five prototypes that can run on the available Windows VM without production credentials or real user data.
5. Fault-injection matrix: reboot, kill, disk full, locked files, corrupted DB, network loss, clock change, update interruption, signature failure, and rollback.
6. Recommended tools/APIs and APIs to avoid, with primary citations.
7. Permissions and least-privilege table.
8. Known unknowns requiring enterprise environment access.
9. Go/no-go gates before building the full Browser History vertical slice.

Prefer reproducible tests over confident prose. Clearly label browser/version-dependent behaviour.

