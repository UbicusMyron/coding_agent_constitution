# Project Governance Rules

- Treat `AGENTS.md` as the shared project instruction source.
- Check changes against `docs/SPEC.md`, `docs/ARCH.md`, and `docs/RULES.md`.
- Read the relevant `docs/TASKS/*.md` before implementation.
- Flag changes that cross module boundaries without updating `docs/ARCH.md`.
- Flag public API, schema, event, or file format changes without a matching `docs/CONTRACTS/` update.
- Flag new behavior without acceptance criteria or tests.
- Ask before changing public APIs, database schemas, auth, billing, destructive operations, or production deployment architecture.
