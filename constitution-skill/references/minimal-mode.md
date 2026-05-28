# Minimal Mode

Use this guide when full governance is overkill: solo projects, weekend prototypes, single-person scripts, throwaway research code. Producing nine governance files for a 200-line CLI is wasteful and signals to future readers that the project is heavier than it is.

This mode keeps the same principles (document before implementation, bounded tasks, cross-agent compatibility) at the smallest possible footprint.

## When To Use Minimal Mode

Choose minimal mode when at least three of these are true:

- Single contributor.
- Expected lifespan under 3 months.
- One coding agent in active use (not three).
- No external API consumers.
- No production deployment.
- No persistent user data.
- No auth, payments, or destructive operations.

If any of the excluded items appear later (you add auth, you onboard a teammate, you start receiving real user data), upgrade to standard mode by promoting the minimal file into split governance files.

## The Minimal File Set

Produce exactly two files:

```text
AGENTS.md
docs/PLAN.md
```

Optionally, one more if the active agent is Claude Code:

```text
CLAUDE.md
```

Skip everything else. Specifically, do not create:

- `SPEC.md`, `ARCH.md`, `RULES.md`, `CONTRACTS/` as separate files.
- `.cursor/rules/`, `.claude/rules/`.
- `TASKS/` folder.
- `DECISIONS/`.

The reduction is intentional. Each file you add has a maintenance tax.

## AGENTS.md In Minimal Mode

Keep under ~60 lines. Suggested shape:

```markdown
# AGENTS

## Project
One paragraph: what this is, who uses it, why it exists.

## Stack
- Language / runtime:
- Key dependencies:
- How to run:
- How to test:

## Conventions
- <2-5 repo-specific rules>

## Sensitive
- <files or behaviors that need human confirmation, if any>

## Workflow
- Read `docs/PLAN.md` for current task scope.
- After each change, summarize files touched, checks run, residual risk.
```

## docs/PLAN.md In Minimal Mode

`docs/PLAN.md` plays the role of SPEC + TASKS combined.

```markdown
# Plan

## Intent
What problem this codebase solves. Update when product direction shifts.

## Current Slice
The single thing being worked on right now. Replace as work progresses.

### Goal
One outcome.

### Scope
- Touch:
- Do not touch:

### Acceptance
- Observable result.

### Verification
- Exact command.

## Backlog
- Short bulleted list of next things, no detail until they become the current slice.

## Decisions Log
- 2026-05-01: chose SQLite over Postgres for simplicity. Revisit if multi-user.
- 2026-05-12: skipping auth for now. Add before any deploy.
```

The `Decisions Log` is the minimal-mode ADR. One line per decision is enough at this scale.

## Promotion Triggers

Move out of minimal mode as soon as one of these happens. Do not delay.

| Trigger | Promotion |
| --- | --- |
| You hire a contributor or invite reviewers | Split `AGENTS.md` into proper SPEC/ARCH/RULES |
| You add real user data | Add `RULES.md` with data rules; add `CONTRACTS/` if any storage schema is defined |
| You add a public API or webhook | Add `docs/CONTRACTS/` |
| You add a second active coding agent | Add tool-specific adapter files (`CLAUDE.md`, `.cursor/rules/`) |
| `docs/PLAN.md` grows past ~200 lines | Split into `SPEC.md` + `docs/TASKS/` |
| You deploy to production | Add `ARCH.md` with operational concerns |

Promotion is a one-task job: file `docs/TASKS/001-promote-governance.md`, split, retire `docs/PLAN.md` into specific files.

## Minimal Mode Workflow

The flow is identical in shape to standard mode, just shorter:

1. Update the `Current Slice` section of `docs/PLAN.md`.
2. Ask the agent to implement only that slice.
3. After implementation, append to `Decisions Log` if anything irreversible happened.
4. Move next item up from `Backlog` into `Current Slice`.

The skill's standard rules still apply: ask before changing public APIs, auth, schemas, billing, destructive ops, deployment. In minimal mode those usually do not exist, so the constraint is light by default.

## What You Lose

Be honest about the tradeoff. Minimal mode gives up:

- Strong cross-agent compatibility (only one adapter file).
- Long-term historical clarity (no ADR chain).
- Explicit module boundaries (single-file project assumed).
- Drift detection scripts (too little surface to be worth running).

This is acceptable for the target use cases. Do not use minimal mode for anything that handles real user data, money, or production traffic.
