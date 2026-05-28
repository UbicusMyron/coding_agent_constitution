@AGENTS.md

## Claude Code

- Treat `AGENTS.md` as the shared instruction source. Do not duplicate it.
- Always read `docs/SPEC.md`, `docs/ARCH.md`, `docs/RULES.md`, and the relevant `docs/TASKS/*.md` before implementation.
- Use modular rules under `.claude/rules/` for additional Claude-specific behavior.
- Keep CLAUDE.md under 50 lines; promote anything longer into a scoped rule file.
- Ask before changing public APIs, database schemas, authentication, billing, destructive operations, or production deployment.
