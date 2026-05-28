# AGENTS

Shared instructions for any coding agent working on Feedback Inbox. Codex reads this directly. Cursor reads it alongside `.cursor/rules/`. Claude Code reads it via `CLAUDE.md` using `@AGENTS.md`.

## Project Context

Before implementation, read:

- `docs/SPEC.md` -- product goals and acceptance criteria.
- `docs/ARCH.md` -- module boundaries and dependency rules.
- `docs/RULES.md` -- coding, testing, contract, and security rules.
- `docs/CONTRACTS/` -- API, schema, event, file, and CLI contracts.
- the relevant file in `docs/TASKS/` -- the bounded task to execute.

## Commands

- Install: `pnpm install`
- Lint: `pnpm lint`
- Typecheck: `pnpm typecheck`
- Unit + integration tests: `pnpm test`
- Contract tests (validate OpenAPI vs handlers): `pnpm test:contract`
- Local dev server: `pnpm dev`
- Migrate: `pnpm db:migrate`

## Agent Roles

- Codex: implement bounded tasks, edit files, run checks, produce reviewable diffs.
- Cursor: review diffs, enforce architecture and dependency rules, inspect risky areas.
- Claude Code: implement or review bounded tasks using the same governance docs.
- Human: define intent, approve risky decisions, decide what merges.

## Work Rules

- One main editor per change. Do not run multiple agents on the same module simultaneously.
- Prefer small vertical slices. If a task touches more than five production files or 300 changed lines, stop and split.
- Preserve existing code style and module boundaries.
- Do not overwrite durable docs without first understanding the existing decision.
- Promote repeated instructions into durable files (`RULES.md`, `AGENTS.md`, scoped rules).

## Sensitive Surfaces

Ask the human before changing any of:

- Public API shape (`docs/CONTRACTS/feedback-api.openapi.yaml`).
- Database schema or migrations (`docs/CONTRACTS/db-schema.sql`, `src/api/persistence/migrations/`).
- Authentication or token handling.
- Outbound webhook adapters (`integrations/slack`, `integrations/zapier`).
- Destructive operations (bulk purge, schema drops).
- Production deployment configuration.

## Pre-Handoff Checks

After implementation, report:

- Files changed.
- Behavior changed.
- Checks run (lint, typecheck, tests).
- Known risks or skipped checks.
- What Cursor should review.
- What the human should decide.

## Cross-Cutting Reminders

- Never log raw email. Hash with SHA-256.
- No `any` types in production code.
- All time values: `Date` in code, RFC 3339 strings at boundaries.
- All env access goes through `src/config/env.ts`.
