# Lessons from the previous research suite

## What worked

- Adversarial expert roles prevented automatic agreement with the proposed design.
- Primary-source requirements produced a strong evidence base.
- Explicit alternatives, failure scenarios, acceptance gates, and a final synthesis made contradictions visible.
- The Windows feasibility result was especially useful because it required hypotheses, setup, instrumentation, pass/fail, cleanup, and environment limitations.
- Separating facts, assumptions, recommendations, unknowns, human decisions, and experiments kept the final baseline honest.

## What needs improvement

- The six broad prompts overlapped heavily on session architecture, SQLite, update security, device identity, privacy, database choice, and reliability. The implementation suite gives each decision one primary owner prompt and uses batch reviewers for cross-topic conflicts.
- The full 392 KB code attachment was costly and too broad for focused chats. The implementation suite uses small sanitized attachments and no raw code by default.
- Some answers used overly precise confidence percentages without a defensible statistical basis. New prompts require qualitative confidence plus evidence and change conditions.
- Exact patch versions and fast-moving frontend/database claims became stale quickly. New prompts require current verification and lifecycle policy, not timeless commitment to a patch number.
- Some recommendations were premature: database engine, retention periods, local caps, encryption, portal details, and capacity numbers. New prompts classify them as human decisions or CLI measurements.
- Broad prompts sometimes produced strong architecture prose but not exact schemas, message framing, state machines, transaction boundaries, compatibility rules, or recovery algorithms. Those are now mandatory.
- Open-source references lacked consistent commit, license, maintenance, test, security, and reuse assessment. Every relevant prompt now requires it.
- Research occasionally answered questions only real Windows, browser, fault, load, restore, or operations evidence can settle. New prompts explicitly convert those claims into CLI experiments.

## Applied prompt rules

1. One primary decision area per prompt; adjacent concerns are constraints, not invitations to redesign everything.
2. Every conclusion is labeled and includes its evidence basis and change trigger.
3. Every load-bearing recommendation includes failure/recovery behavior, a falsifying prototype, and acceptance criteria.
4. Human policy and legal decisions are presented as options with consequences, never silently selected.
5. Numerical values are hypotheses until measured and approved.
6. Stable interfaces and invariants are specified more strongly than replaceable technologies.
7. Batch reviewers reconcile conflicts before their results become baseline inputs.
8. Only final accepted batch decisions and real CLI evidence enter the next technical baseline.
