# Bootstrap Question Bank

Use these questions when the user has a vague idea and the project lacks durable governance assets. Ask only the smallest useful set; do not interrogate the user with every question.

## Product Intent

- Who is the primary user?
- What painful workflow or decision does the product improve?
- What outcome should exist after the first useful version?
- What is explicitly out of scope for the first version?
- What existing tool, spreadsheet, process, or competitor is this replacing?

## Scope And Priority

- What is the smallest demo that would prove the idea works?
- Which feature must be correct on day one?
- Which feature can be mocked, manual, or deferred?
- What data should the product never lose or corrupt?
- What should happen when external services fail?

## Technical Direction

- Is there an existing repo, framework, deployment target, or database to preserve?
- Does the project need a web app, CLI, API service, background job, mobile app, or a mix?
- Does the user prefer speed of iteration, long-term maintainability, local-first behavior, or scale?
- Which integrations or APIs are required?
- Are there constraints around hosting, auth, cost, privacy, or offline usage?

## Architecture Boundaries

- What modules should be independent?
- What data owns the source of truth?
- What are the public interfaces between modules?
- Which parts should remain replaceable?
- Which decisions are irreversible or expensive to change?

## Contracts

- What API endpoints, events, file formats, database schemas, or tool interfaces must exist?
- Which contract is consumed by another team, app, agent, or external service?
- What compatibility promises matter?
- What validation rules must reject bad input?
- What sample payloads prove the contract is clear?

## Agent Workflow

- What should Codex be allowed to modify without asking?
- What should require human approval?
- What should Cursor review after Codex changes it?
- Which checks must pass before a change is considered ready?
- What repeated instruction should become `RULES.md`, `AGENTS.md`, or `.cursor/rules/`?

## Default Assumptions

Use these defaults when the user is unsure and the decision is reversible:

- Prefer the repo's existing stack and conventions.
- Prefer `docs/` for governance files.
- Prefer small vertical slices over broad rewrites.
- Prefer explicit contracts before implementation when two modules or systems interact.
- Prefer boring, maintainable architecture over speculative scale.
- Prefer local checks that can run in the workspace.

Require explicit confirmation for:

- Public API shape
- Database schema that may need migration
- Authentication and authorization model
- Payment, billing, legal, compliance, or privacy behavior
- Data deletion or destructive operations
- Production deployment architecture
