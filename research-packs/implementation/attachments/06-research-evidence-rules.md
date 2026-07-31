# Research evidence rules

**Classification:** safe research instructions; contains no source values.
**Source:** lessons from the previous UAM research suite and current package requirements.
**Generation:** deterministic text from `scripts/generate-implementation-research-packs.mjs`.
**Limitation:** governs research quality; it is not evidence that any technical claim is true.

Use these labels consistently:

- **FACT** — directly supported by supplied evidence or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proven.
- **INFERENCE** — reasoned from facts; explain the chain.
- **ESTIMATE** — numerical hypothesis with replaceable inputs.
- **RECOMMENDATION** — proposed decision with alternatives and trade-offs.
- **UNKNOWN** — missing evidence.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, or business authority.
- **CLI EXPERIMENT** — must be established by code, lab work, or measurement.

Do not use invented numerical confidence percentages. Give High/Medium/Low confidence per major conclusion, state why, and name the evidence that would change it. If you conflict with the accepted baseline, create an explicit change proposal: affected decision, new evidence, impact, smallest falsifying experiment, migration consequence, and ADR action. Do not silently redesign adjacent components. Never call the result “bulletproof”; state residual risk and containment.

## Source quality

Verify time-sensitive claims as of the research date. Prefer official specifications, standards, Microsoft/.NET/Windows documentation, browser and database source/documentation, RFCs, regulator publications, maintained source repositories, and original engineering publications. Cite direct, stable links and record document/release dates and versions. Vendor marketing, search snippets, popularity, and synthetic benchmarks are not proof. Clearly distinguish documented capability from UAM-specific fitness.

## Boundaries

- Research cannot approve purpose, legal basis, prohibited uses, identity level, retention, access, budget, SLO/RPO/RTO, ownership, staffing, or production deployment.
- Research cannot prove Windows/browser behavior, durability, performance, capacity, restore, supportability, or operational competence without a CLI/lab experiment.
- Internal source names, addresses, credentials, personal data, raw activity, confidential configuration, and SSH material must not appear in research packages or answers.
- Open-source references are evidence and design input, not automatic dependencies.
