<!--
Owner: feedback-team
Last Reviewed: 2026-05-12
Status: Active
-->

# RULES: Feedback Inbox

## Coding Rules

- TypeScript strict mode is mandatory. No `any` in production code; `unknown` plus narrowing is acceptable.
- Each domain function in `api/feedback` must return a typed result; do not throw for expected errors.
- Public functions in `api/feedback` and `api/persistence` carry JSDoc summarizing intent and side effects.
- Time values are always `Date` in code, RFC 3339 strings at boundaries.

## Testing Rules

- Required checks before a PR is mergeable: `pnpm lint`, `pnpm typecheck`, `pnpm test`, `pnpm test:contract`.
- Every new endpoint requires one happy-path test and one validation-error test under `tests/api/`.
- Domain logic in `api/feedback` requires unit tests; coverage threshold 80% lines for this module.
- Integration tests in `tests/integration/` may use a real Postgres via testcontainers. No mocking of Drizzle.

## Architecture Rules

- `web/dashboard` and `cli/feedback` must call `api/feedback` services; direct DB access from those modules is forbidden and flagged in review.
- `integrations/*` modules must not import from `api/feedback` or `api/persistence`. They consume events only.
- New external services require an entry under `docs/CONTRACTS/` before implementation.

## Contract Rules

- Any change to a file under `docs/CONTRACTS/` requires a matching code change and a corresponding test update in the same PR.
- Breaking contract changes require an ADR under `docs/DECISIONS/` and a dual-write or dual-read migration plan.

## Security And Safety Rules

- Never log raw email at any level. Hash with SHA-256 before logging.
- Tokens stored hashed with Argon2id; never store plaintext.
- All external-service URLs come from environment, not source.
- Destructive operations (delete by ID, bulk purge, schema change) require explicit human approval and a dry-run flag.
- Secrets must not be committed; pre-commit hook checks for `.env*` and common key patterns.

## Dependency Rules

- New runtime dependency requires justification in the PR description: why this library, license, size impact.
- License allowlist: MIT, Apache-2.0, BSD-2/3, ISC. Anything else needs human approval.
- Pin dependencies in `pnpm-lock.yaml`; no `latest` in `package.json`.

## Agent Rules

- Read `AGENTS.md`, `docs/SPEC.md`, `docs/ARCH.md`, and the relevant `docs/TASKS/*.md` before implementation.
- Implement only the requested task; do not opportunistically refactor adjacent code.
- Run the verification commands listed in the task before declaring it complete.
- Summarize files changed, checks run, residual risks, and what Cursor/human should review.
- Do not change public APIs, database schemas, authentication, billing, destructive operations, or production deployment without explicit human approval.

## Review Rules

- Cursor enforces architectural boundaries via `.cursor/rules/project-governance.mdc`.
- Claude Code review uses `.claude/rules/project-governance.md`.
- Human reviewer must check: contract drift, dependency justification, security rule compliance, and verification evidence.
- A PR is not mergeable until at least one human review has approved.
