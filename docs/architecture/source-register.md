# Repository-practice source register

**Reviewed:** 2026-08-01  
**Use:** guidance, not project proof. Current vendor details must be rechecked when repository tooling changes.

| Primary source | Applied lesson | Project interpretation |
| --- | --- | --- |
| [OpenAI: AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md) | Agents read repository instructions from root to the working directory; closer files override. | One concise root agreement; nested files only for real local differences. |
| [GitHub: repository custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/add-custom-instructions/add-repository-instructions) | Repository and path-specific instructions should explain structure, build, test, and validation. | `.github/copilot-instructions.md` points to the shared agreement instead of duplicating it. |
| [GitHub: README guidance](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes) | A root README should help a visitor understand and start using the project. | Root contains the shortest reading path; details live under `docs/`. |
| [GitHub: contributing guidelines](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/setting-guidelines-for-repository-contributors) | A contribution guide reduces avoidable rework and is surfaced by GitHub. | People and agents use one contribution and validation path. |
| [GitHub: issue and pull-request templates](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-request-templates/about-issue-and-pull-request-templates) | Templates prompt contributors for consistent information. | Task, experiment, and review templates require evidence, safety, rollback, and human decisions. |
| [GitHub: CODEOWNERS](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners) | Code owners can identify responsible reviewers and support protected review. | An example exists, but no active owners are invented before real teams accept responsibility. |
| [GitHub: secure use of Actions](https://docs.github.com/en/actions/reference/security/secure-use) | Use least privilege and immutable action references; workflow changes deserve careful ownership. | Workflows have read-only default permission and third-party/action references are pinned to reviewed commits. |
| [Google: small changes](https://google.github.io/eng-practices/review/developer/small-cls.html) | Small, self-contained changes are easier to review, test, and roll back. | One useful outcome per task; unrelated cleanup/refactoring is separate. |
| [Google: what reviewers look for](https://google.github.io/eng-practices/review/reviewer/looking-for.html) | Review design, behavior, complexity, tests, and documentation; avoid speculative complexity. | Review template asks for behavior, proof, operations, documentation, and exclusions. |
| [NuGet: central package management](https://learn.microsoft.com/en-gb/nuget/consume-packages/central-package-management) | PackageReference versions can be managed in a root `Directory.Packages.props`. | Reserve this for the .NET solution; do not add dependencies before code exists. |

## Human judgment retained

These sources do not decide UAM architecture, owners, privacy policy, branch protection, technology admission, or whether a gate passes. They only support a repository workflow that makes those decisions visible and reviewable.
