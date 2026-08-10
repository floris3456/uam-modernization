# Agent-system external source register

**Accessed:** 2026-08-10
**Rule:** Reverify volatile model, connector, and tool configuration immediately before activation.

| First-party source | Supports |
| --- | --- |
| https://opencode.ai/docs/agents/ | Markdown agent definitions under `.opencode/agents/`, primary mode, provider options such as `reasoningEffort`, permission configuration. |
| https://opencode.ai/docs/config/ | `default_agent`, disabled sharing, permissions, configuration precedence. |
| https://opencode.ai/docs/skills | `.opencode/skills/<name>/SKILL.md`, on-demand loading, recognized frontmatter, naming rules. |
| Local `opencode models` and `opencode debug agent` on OpenCode 1.18.15 | The installed configured provider exposes `openai/gpt-5.6-luna` and `openai/gpt-5.6-sol`; project config and agent definitions resolve with task permission denied. |
| https://github.com/anomalyco/opencode/pull/36543 | Current GPT-5.6 reasoning variants are derived from provider metadata, including the maximum tier where exposed. |
| https://git-scm.com/docs/githooks | Hook locations, executable requirement, `pre-commit`, `post-commit`, and `pre-push` behavior and exit semantics. |
| https://git-scm.com/docs/git-config#Documentation/git-config.txt-corehooksPath | Tracked hook activation through `core.hooksPath`. |
| https://help.openai.com/en/articles/10169521-projects-in-chatgpt | Project instructions, project sources, persistent project context, and connected apps in project chats. |
| https://docs.github.com/en/rest/git/refs | Public GitHub ref creation/update concepts used by the future orchestration-branch smoke test. |
| https://docs.github.com/en/rest/repos/contents | Public GitHub file create/update concepts used by the future orchestration-state smoke test. |
| https://docs.github.com/en/rest/commits/commits#compare-two-commits | Commit-range comparison capability assumed by MCP-ON remote review. |

## Human requirements not established by vendor documentation

- ChatGPT Project skill folder organization is an accepted operating capability supplied by the human.
- The exact connected GitHub MCP tool surface for direct writes was not live-tested during this MCP-OFF bootstrap.
- `web-orchestration` direct writes therefore require the smoke test in `migration/project-installation.md` before activation.
