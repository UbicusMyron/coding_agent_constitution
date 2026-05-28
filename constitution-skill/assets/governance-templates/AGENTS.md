# AGENTS

This is the shared project instruction file for coding agents. Codex can read this directly. Cursor may read it alongside `.cursor/rules/`. Claude Code should read it through `CLAUDE.md` using `@AGENTS.md`.

## Project Context

Before implementation, read:

- `docs/SPEC.md`
- `docs/ARCH.md`
- `docs/RULES.md`
- `docs/CONTRACTS/`
- the relevant file in `docs/TASKS/`

## Agent Roles

- Codex: implement bounded tasks, edit files, run checks, and produce reviewable diffs.
- Cursor: review diffs, enforce architecture rules, inspect risky areas, and apply small local refinements.
- Claude Code: implement or review bounded tasks using the same governance docs and Claude-specific adapters.
- Human: define intent, approve risky decisions, and decide what merges.

## Work Rules

- Keep one main editor per change.
- Prefer small vertical slices over broad rewrites.
- Preserve existing code style and project conventions.
- Do not overwrite durable docs without understanding existing decisions.
- Promote repeated instructions into durable files.

## Approval Required

Ask before changing:

- public APIs
- database schemas or migrations
- authentication or authorization
- billing, payments, legal, privacy, or compliance behavior
- destructive data operations
- production deployment architecture

## Handoff Format

After implementation, report:

- files changed
- behavior changed
- checks run
- known risks or skipped checks
- what Cursor should review
- what the human should decide
