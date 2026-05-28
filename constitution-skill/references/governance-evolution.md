# Governance Evolution

Use this guide to keep durable assets accurate as the project evolves. Governance docs are only useful if they reflect reality. The patterns below keep them honest without turning maintenance into a second job.

## Update Cadence

Update durable docs at these moments. If none apply, do not touch them.

| Trigger | Update Target |
| --- | --- |
| Product behavior changed | `SPEC.md` |
| Module boundary, dependency, or deployment changed | `ARCH.md` |
| Interface (API, schema, event, file format, CLI) changed | `docs/CONTRACTS/` |
| Repeated rule emerged from review | `RULES.md` or scoped `.cursor/rules/` / `.claude/rules/` |
| Agent confused or misled across two sessions | `AGENTS.md` |
| Irreversible or expensive decision made | `docs/DECISIONS/NNN-*.md` |

Updates should land in the same PR as the behavior change, not later.

## File-Level Headers

Add a small header to every durable file so reviewers can tell at a glance whether it is fresh.

```markdown
<!--
Owner: <team or person>
Last Reviewed: 2026-05-01
Status: Active
-->
```

Statuses:

- `Active` -- in force.
- `Draft` -- not yet authoritative; agents should ignore until promoted.
- `Superseded` -- replaced; see `Superseded By`.
- `Frozen` -- the underlying module is not being changed; doc accuracy not guaranteed.

`Last Reviewed` is updated whenever a human reads the file end-to-end and confirms it still matches reality, even if no edits were made.

## DECISIONS As ADRs

Use `docs/DECISIONS/NNN-<slug>.md` for any decision that is hard to reverse. The decision file is durable; the discussion that led to it is disposable.

Template (also see `assets/governance-templates/DECISION.md`):

```markdown
# Decision: <title>

## Status
Proposed | Accepted | Superseded by ADR-NNN | Rejected

## Date
2026-05-01

## Context
What problem required the decision.

## Decision
What we chose. One paragraph max.

## Consequences
- Positive
- Negative
- Follow-up tasks

## Alternatives Considered
- Option A: rejected because ...
- Option B: rejected because ...
```

### Superseded Chain

When a decision is replaced, do not delete the old file. Instead:

1. Change old file's `Status` to `Superseded by ADR-NNN`.
2. In the new ADR, link back: `Supersedes ADR-MMM`.
3. Keep both files in `docs/DECISIONS/`.

This preserves history. Agents reading the new ADR can trace why the old one was wrong.

### When To Write An ADR

Write an ADR when the decision:

- Affects more than one module.
- Touches an external interface or contract.
- Is expensive to reverse (data model, auth, payments, deployment shape).
- Was contentious or had close alternatives.

Do not write an ADR for reversible local choices ("use map vs forEach"). Those belong in `RULES.md` or nowhere.

## SPEC Versioning

Most projects do not need semantic versioning for SPEC. Use these instead:

- A `## Changelog` at the bottom of `SPEC.md` with one line per meaningful change.
- A `Last Reviewed` header (above).
- Section-level superseded notes when behavior changes:

```markdown
### Workflow 3: Bulk Import

> Superseded 2026-04-12: replaced by streaming ingestion. See `docs/DECISIONS/014-streaming-ingestion.md`.
```

Avoid copy-paste-rewriting the whole SPEC for any new release. Edit in place; record the why in the changelog or ADR.

## Archival Rules

When a module, feature, or contract is fully removed:

1. Move the relevant section into `docs/archive/<slug>.md`.
2. Mark `Status: Archived` and add the removal date.
3. Leave a one-line breadcrumb in the original file pointing to the archive.
4. Do not delete archived files for at least one release cycle.

Archive files are not authoritative. Agents should not treat them as governance.

## Drift Detection

Signs that durable docs have drifted from reality:

- Reviewers repeatedly say "the doc says X but the code does Y".
- New contributors ask the same orientation questions every week.
- Tests pass but the SPEC's acceptance criteria are not actually checked anywhere.
- ARCH.md mentions a module that no longer exists, or omits one that now does.
- Contracts in `docs/CONTRACTS/` do not match generated OpenAPI or running migrations.

When you observe drift, file a task: `docs/TASKS/NNN-reconcile-<doc>.md`. Treat drift like a bug.

## Promotion Examples

Concrete promotion paths to internalize:

- A code reviewer says: "we don't allow direct DB calls from controllers". Said once -> code review only. Said in two reviews -> promote to `RULES.md` under `Architecture Rules`. Said in three reviews -> add a `.cursor/rules/no-db-in-controller.mdc` with `globs: "src/controllers/**"` to catch it during agent work.
- An agent invents a JSON shape twice in a row. -> Write a `docs/CONTRACTS/` entry for that endpoint with example payloads.
- The human keeps re-explaining "we always run lint before pushing". -> Add to `AGENTS.md` under `## Pre-handoff Checks`.

## What Not To Update

Avoid editing durable docs for:

- Cosmetic rephrasing without behavior change.
- Renaming sections to match personal style.
- Adding aspirational rules that no PR will enforce.
- Reflowing whitespace.

Cosmetic churn destroys git history and signals false significance to agents reading the diffs.

## Yearly Garbage Collection

Once or twice a year, do a pass:

- Re-read every durable file end-to-end.
- Update `Last Reviewed` if accurate; otherwise file a reconcile task.
- Archive sections that are no longer true.
- Promote any rule that lived only in code reviews.
- Delete any disposable file in `docs/TASKS/` whose work is shipped and whose lessons have been promoted.

A short `docs/governance-changelog.md` of these passes is helpful.
