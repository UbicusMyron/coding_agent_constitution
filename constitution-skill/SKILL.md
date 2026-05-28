---
name: constitution-skill
description: Transform vague software product intent into durable repo-native governance assets before coding, with adapters for Codex, Cursor, and Claude Code. Use when a user has an unclear idea, incomplete technical direction, undefined architecture, missing API/data contracts, unclear feature boundaries, or wants to establish SPEC.md, ARCH.md, RULES.md, CONTRACTS/, AGENTS.md, CLAUDE.md, .cursor/rules/*.mdc, .claude/rules/*.md, and bounded TASKS before implementation. Also use when converting chat-only requirements into reusable project files, designing a Codex/Cursor/Claude Code/Human collaboration workflow, or preparing a project so coding agents can implement safely in reviewable units. Supports three modes: standard (greenfield), retrofit (legacy repo), and minimal (solo or throwaway). Do not use for already-scoped small code changes unless the user asks to update governance assets first.
---

# Constitution Skill

## Purpose

Turn ambiguous software intent into durable project files before implementation. Treat specs, architecture, contracts, and rules as reusable assets; treat task plans, implementation notes, and one-off agent prompts as consumables.

This skill follows the portable `SKILL.md` shape so it can be installed as a Codex skill, Claude Code skill, or Cursor Agent Skill. The governance assets it creates should also work when different agents rotate through the same repository.

## Modes

Pick the mode that matches the project before doing anything else.

| Mode | When | Output Footprint | Reference |
| --- | --- | --- | --- |
| Standard | Greenfield or growing project, multiple agents, real users expected | Full file set (~9 files) | This document, sections below |
| Retrofit | Existing codebase with no governance, mixed conventions, legacy code | Incremental, seam-first | `references/retrofit-mode.md` |
| Minimal | Solo, weekend, throwaway, no production traffic | 1-3 files | `references/minimal-mode.md` |

Default to Standard. Drop to Minimal only when at least three of these are true: single contributor, lifespan under 3 months, one coding agent, no external API, no auth, no persistent user data. Switch to Retrofit when the repo already has substantial code without governance assets.

## Operating Model

Use this role split:

- Human owns product intent, boundaries, architecture decisions, risk approval, and merge decisions.
- Codex implements bounded units, edits files, runs checks, and produces reviewable changes.
- Cursor reviews diffs, checks architecture compliance, catches hidden coupling, and helps with local refinements.
- Claude Code can implement or review bounded units when it has the same governance files and tool-specific adapter files.

Keep one main editor per work cycle. Let Codex perform the main modification, then hand off a clean review surface to Cursor and the human.

## Workflow

1. Discover existing context.
   - Read durable assets if present: `SPEC.md`, `docs/SPEC.md`, `ARCH.md`, `docs/ARCH.md`, `RULES.md`, `docs/RULES.md`, `CONTRACTS/`, `docs/CONTRACTS/`, `AGENTS.md`, `CLAUDE.md`, `.cursor/rules/`, `.claude/rules/`.
   - Identify disposable assets if present: `TASKS/`, `docs/TASKS/`, implementation notes, migration checklists, experiment logs.
   - Preserve existing project conventions and avoid overwriting durable assets without first understanding them.

2. Classify the request.
   - If the user asks for direct implementation and the task is already bounded, proceed with normal coding behavior and only update governance files if the task reveals durable knowledge.
   - If requirements, architecture, technology choices, contracts, or acceptance criteria are unclear, pause coding and create or update governance assets first.
   - If the user only wants planning, produce files or proposed file diffs rather than implementation code.

3. Convert vague intent into bounded project context.
   - Capture product goals, users, non-goals, constraints, risks, and acceptance criteria in `SPEC.md`.
   - Capture architecture, module boundaries, data ownership, dependency choices, deployment assumptions, and tradeoffs in `ARCH.md`.
   - Capture coding rules, testing expectations, security/safety rails, and agent behavior in `RULES.md` and `AGENTS.md`.
   - Use `AGENTS.md` as the shared cross-agent instruction source when possible.
   - Use `CLAUDE.md` as the Claude Code adapter, usually importing `@AGENTS.md` and adding Claude-specific guidance.
   - Use `.cursor/rules/*.mdc` as the Cursor adapter for always-on or scoped project rules.
   - Use `.claude/rules/*.md` as the Claude Code adapter for modular or path-scoped rules.
   - Capture APIs, schemas, events, database rules, and external integrations in `CONTRACTS/` when interfaces matter.
   - Capture implementation slices in `TASKS/*.md`; keep them disposable and specific.
   - Use `references/governance-asset-guide.md` when deciding whether information belongs in a durable asset or a disposable task artifact.
   - Use `references/cross-agent-compatibility.md` when creating tool-specific adapters.
   - Use `references/anti-patterns.md` to avoid common failure modes in each governance file.
   - Use `references/governance-evolution.md` for versioning, ADR superseded chains, and archival.
   - Point first-time product builders to `references/rookie-onboarding.md` so the engineering vocabulary in the generated files is approachable.

4. Ask only the questions needed to remove dangerous ambiguity.
   - Prefer 3 to 7 high-leverage questions.
   - Offer reasonable defaults when the user is unsure.
   - If a decision is reversible, choose a conservative default and mark it as an assumption.
   - If a decision affects data models, public APIs, auth, payments, destructive operations, compliance, or deployment architecture, require explicit human confirmation.
   - Use `references/bootstrap-question-bank.md` for optional question prompts.

5. Produce a governance asset set.
   - Prefer `docs/` for new projects unless the repo already uses root-level docs.
   - Use the templates in `assets/governance-templates/` when creating new files.
   - Keep `AGENTS.md` canonical and keep `CLAUDE.md`, `.cursor/rules/*.mdc`, and `.claude/rules/*.md` thin unless tool-specific behavior is truly needed.
   - Write concise, decision-oriented files. Avoid turning governance docs into generic essays.
   - Mark unresolved items as `Open Questions` or `Assumptions`, not hidden prose.

6. Create bounded implementation tasks.
   - Each task must have one clear goal, explicit constraints, limited touched surface area, acceptance criteria, and verification commands.
   - Apply the quantifiable sizing rules in `references/task-sizing.md`:
     - touched files <= 5, diff <= ~300 lines, new top-level modules <= 1, public API changes <= 2, schema changes <= 1, verification commands <= 3.
     - Crossing one limit is acceptable; crossing two means consider splitting; crossing three means split now.
   - Acceptance criteria: 2-6 items. Verification: 1-3 exact commands (not "manually verify").
   - Do not create broad tasks like "clean up the codebase" or "improve reliability everywhere".

7. Handoff for implementation and review.
   - Before coding, name the governance files that define the task.
   - After coding, summarize what changed, checks run, residual risks, and what Cursor/human should review.
   - Promote repeated review feedback into `RULES.md`, `.cursor/rules/`, or `AGENTS.md`.

8. Validate before declaring done.
   - Run `scripts/check-governance.sh` from the project root.
   - The script verifies adapter orphans, required sections in TASKS/SPEC/ARCH/RULES, contract references, adapter duplication, and `Last Reviewed` staleness.
   - Any reported `ERROR` blocks completion; `WARN` items should be addressed or explicitly accepted in handoff notes.

## Output Contract

The file set depends on mode.

### Standard Mode (default)

- `docs/SPEC.md`
- `docs/ARCH.md`
- `docs/RULES.md`
- `docs/CONTRACTS/README.md` plus one file per real interface (see `assets/contracts-examples/` for format choices)
- `docs/TASKS/001-<slug>.md`
- `docs/DECISIONS/001-<slug>.md` for any irreversible decision discovered during bootstrap
- `AGENTS.md`
- `CLAUDE.md`
- `.cursor/rules/project-governance.mdc`
- `.claude/rules/project-governance.md`

A fully filled example of this set lives in `assets/examples/feedback-inbox/`. Use it as a reference for what good looks like, not as a starter template.

### Retrofit Mode

Follow `references/retrofit-mode.md`. Produce, in order:

1. `AGENTS.md` at root (under 100 lines).
2. `docs/CONTRACTS/<seam>.md` for the next module about to change.
3. `docs/ARCH.md` with a single-module entry.
4. `docs/RULES.md` with only the rules relevant to the seam.
5. `docs/SPEC.md` scoped to the seam (mark `## Scope`).
6. `docs/TASKS/001-<slug>.md` referencing all of the above.

Do not try to document the whole legacy repo at once.

### Minimal Mode

Follow `references/minimal-mode.md`. Produce only:

- `AGENTS.md` (under ~60 lines).
- `docs/PLAN.md` (combined SPEC + TASKS + decisions log).
- Optionally `CLAUDE.md` if Claude Code is the active agent.

Promote out of Minimal Mode immediately when any of these happen: new contributor, real user data, public API, second active coding agent, deployment to production.

### Location Note

Do not use `.vscode/` as the primary place for agent governance. Cursor is VS Code-based, but Cursor agent rules live in Cursor-specific locations such as `.cursor/rules/` and `.cursor/skills/`.

## Asset Hierarchy

Durable assets:

- `SPEC.md` or `docs/SPEC.md`: product goals, boundaries, non-goals.
- `ARCH.md` or `docs/ARCH.md`: architecture, module boundaries, design constraints.
- `CONTRACTS/` or `docs/CONTRACTS/`: API schemas, database rules, event formats, interfaces.
- `RULES.md` or `docs/RULES.md`: coding rules, testing rules, safety rails.
- `AGENTS.md`: shared cross-agent instructions.
- `CLAUDE.md` and `.claude/rules/`: Claude Code persistent instructions and modular rules.
- `.cursor/rules/`: Cursor persistent project rules.

Disposable assets:

- `TASKS/*.md` or `docs/TASKS/*.md`
- implementation notes
- one-off plans
- temporary migration checklists
- experiment logs

## Bounded Task Format

Use this shape for every implementation task:

```markdown
# Task: <action-oriented title>

## Goal
<one outcome>

## Source Context
- <SPEC/ARCH/RULES/CONTRACTS links or sections>

## Scope
- Touch: <files/modules>
- Do not touch: <files/modules/APIs/schemas>

## Requirements
- <behavioral requirement>

## Acceptance Criteria
- <observable outcome>

## Verification
- <commands/checks/manual review>

## Handoff Notes
- Cursor should review: <architecture/risk hotspots>
- Human should decide: <open product/merge/risk decisions>
```

## Quality Bar

The skill succeeds when a fresh coding agent can implement the next task by reading files in the repo instead of relying on hidden chat context.

Before finishing, check:

- Major requirements are written in files, not only in chat.
- Every bounded task points to durable source context.
- Risky decisions are explicit and assigned to the human.
- Contracts exist before implementation when interfaces matter.
- Repeated standards are promoted into persistent rules.
- Codex, Cursor, and Claude Code each have a readable entrypoint into the same governance source of truth.
- `scripts/check-governance.sh` reports zero `ERROR` items.

## Anti-Patterns To Avoid

Read `references/anti-patterns.md` for the full catalog. The most common pitfalls:

- SPEC written as sprint backlog or implementation manual.
- ARCH module table with no `Must Not Own` column.
- RULES file full of generic programming advice rather than repo-specific rules.
- CONTRACTS expressed as prose instead of schemas; no error envelope defined.
- Tasks named after whole features, with no `Do Not Touch` and no verification command.
- Three near-identical copies of the same rules in `AGENTS.md`, `CLAUDE.md`, and `.cursor/rules/`.
- Governance files created at bootstrap and never updated again.

## File Map

This skill ships:

```text
constitution-skill/
├── SKILL.md
├── agents/
│   └── openai.yaml
├── references/
│   ├── bootstrap-question-bank.md       # which questions to ask the user
│   ├── cross-agent-compatibility.md     # Codex/Cursor/Claude adapter mapping
│   ├── governance-asset-guide.md        # durable vs disposable, promotion rules
│   ├── anti-patterns.md                 # common failure modes to avoid
│   ├── task-sizing.md                   # quantifiable bounded-task rules
│   ├── retrofit-mode.md                 # applying governance to legacy repos
│   ├── governance-evolution.md          # versioning, ADRs, archival
│   ├── minimal-mode.md                  # solo/throwaway lightweight setup
│   └── rookie-onboarding.md             # concept primer for first-time product builders
├── assets/
│   ├── governance-templates/            # blank starters for each file
│   ├── contracts-examples/              # filled OpenAPI / JSON Schema / event / SQL / CLI / file-format
│   └── examples/
│       └── feedback-inbox/              # fully filled worked example
└── scripts/
    └── check-governance.sh              # drift and missing-section detector
```
