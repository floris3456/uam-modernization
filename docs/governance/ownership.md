# Ownership and required human decisions

No real repository or product owner is inferred from filenames, Git history, research, or organization data. `UNASSIGNED` means work needing that authority must stop at its gate.

| Responsibility | Accountable owner | Needed before |
| --- | --- | --- |
| Product purpose and scope | UNASSIGNED | Accepting G0 and any production use |
| Architecture and gate acceptance | UNASSIGNED | Accepting initial ADRs and G0 |
| Privacy/legal ceiling | UNASSIGNED | Freezing G0 transformation examples |
| Security and threat acceptance | UNASSIGNED | Accepting G0; required again at every live boundary |
| Endpoint engineering | UNASSIGNED | G1 lab implementation |
| Data/contracts | UNASSIGNED | Freezing first contract version |
| Test/oracle independence | UNASSIGNED | G0 implementation review |
| Operations/support | UNASSIGNED | Live deployment design |
| Portal authorization | UNASSIGNED | Portal milestone |
| Legacy system/decommissioning | UNASSIGNED | Discovery, cutover, and removal |

After real GitHub teams accept ownership, copy `.github/CODEOWNERS.example` to `.github/CODEOWNERS`, replace every placeholder, protect it through branch rules, and record the approval here.
