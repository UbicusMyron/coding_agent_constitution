# Project Governance Rules

- Treat `AGENTS.md` as the shared instruction source.
- Check changes against `docs/SPEC.md`, `docs/ARCH.md`, and `docs/RULES.md`.
- Read the relevant `docs/TASKS/*.md` before implementation.
- Flag changes crossing module boundaries without an `docs/ARCH.md` update.
- Flag public API, schema, event, file format, or CLI changes without a matching `docs/CONTRACTS/` update.
- Flag handlers bypassing `api/feedback` to access `api/persistence` from `web/dashboard` or `cli/`.
- Flag `integrations/*` code importing from `api/feedback` or `api/persistence`.
- Flag any log statement that includes a raw email field.
- Flag any new `any` type in production code.
- Ask before changing public APIs, database schemas, authentication, billing, destructive operations, or production deployment.
