# Governance Asset Guide

Use this guide to decide what to create, update, or leave alone.

## Durable Assets

Durable assets should compound across sessions and survive individual implementation tasks.

### SPEC.md

Use for product-level truth:

- target users
- goals and non-goals
- core workflows
- requirements
- constraints
- acceptance criteria
- open product questions

Avoid implementation details unless they constrain product behavior.

### ARCH.md

Use for technical structure:

- system overview
- module boundaries
- data ownership
- interface boundaries
- dependency choices
- deployment assumptions
- tradeoffs and rejected alternatives

Avoid repeating every feature requirement from `SPEC.md`.

### RULES.md

Use for repeated engineering rules:

- code style that matters to this repo
- testing expectations
- dependency rules
- migration rules
- security and safety rails
- review requirements

Avoid generic programming advice.

### CONTRACTS/

Use when systems, modules, or agents depend on a stable interface:

- REST or GraphQL APIs
- database schemas
- event payloads
- file formats
- CLI inputs/outputs
- external service adapters

Contracts should include examples and validation rules whenever possible.

### AGENTS.md

Use for persistent agent behavior:

- where agents should look first
- what commands to run
- what files are sensitive
- what requires approval
- how to produce handoff notes

Treat `AGENTS.md` as the shared cross-agent instruction source when the project is used by Codex, Cursor, and other agents that support it.

Avoid project marketing copy.

### CLAUDE.md

Use as the Claude Code adapter:

- import shared guidance with `@AGENTS.md`
- add Claude-specific behavior only when needed
- keep it under 200 lines when possible
- move longer or scoped instructions into `.claude/rules/`

Avoid duplicating the whole `AGENTS.md` content.

### .cursor/rules/

Use for IDE review rules:

- architectural boundaries Cursor should enforce
- forbidden coupling
- test expectations
- review heuristics
- local rewrite constraints

Keep Cursor rules short and inspectable.

Use `.mdc` files with frontmatter for Cursor Project Rules. Do not use `.vscode/` for Cursor agent governance.

### .claude/rules/

Use for modular Claude Code rules:

- broad project governance
- path-scoped rules
- topic-specific coding, testing, security, or API rules

Keep `CLAUDE.md` as the entrypoint and `.claude/rules/` as modular detail.

## Disposable Assets

Disposable assets are execution materials. They can be replaced when the task is complete.

### TASKS/*.md

Use for bounded implementation units:

- one goal
- one scope
- clear constraints
- acceptance criteria
- verification commands
- handoff notes

### Implementation Notes

Use for temporary analysis, migration checklists, experiment logs, and branch-specific plans. Do not let long-term decisions live only here.

## Promotion Rule

If information matters repeatedly, promote it:

- task detail repeated twice -> `RULES.md` or `AGENTS.md`
- interface detail used by multiple files -> `CONTRACTS/`
- architectural concern seen in review -> `ARCH.md`
- product clarification affecting behavior -> `SPEC.md`

## Update Discipline

When editing existing assets:

- preserve the user's terminology where it encodes product intent
- add assumptions explicitly
- move stale decisions to a short "Superseded" note only when necessary
- avoid rewriting unrelated sections for style
- keep docs concise enough that future agents will actually read them
