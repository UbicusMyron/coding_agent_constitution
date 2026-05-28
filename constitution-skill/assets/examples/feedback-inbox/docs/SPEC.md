<!--
Owner: feedback-team
Last Reviewed: 2026-05-12
Status: Active
-->

# SPEC: Feedback Inbox

## Product Intent

A lightweight SaaS tool that lets small product teams (3-15 people) collect customer feedback from a public form, group it into themes, and turn high-signal items into development tasks. The product replaces a typical mix of Google Form + spreadsheet + Slack channel with one durable inbox.

## Users

- Primary user: product manager at a small team. Triages feedback, decides what becomes a task.
- Secondary user: engineer reviewing the task backlog produced by triage.
- Tertiary user: end-customer submitting feedback via the public form.

## Goals

- Capture feedback from multiple sources (web form, mobile webview, Zapier, API) into one inbox.
- Tag and group submissions; surface duplicates and themes.
- Produce structured "candidate tasks" the team can copy into their issue tracker.
- Keep submission private by default; redact email when shared internally.

## Non-Goals

- Replacing the team's issue tracker. Tasks are exported, not managed inside the product.
- Public-facing roadmaps or status pages.
- AI agents that respond to customers directly.
- Realtime collaboration on a single feedback item.
- On-premise deployment in v1.

## Core Workflows

### Workflow 1: Customer Submits Feedback

1. Customer opens the team's public form.
2. Customer types feedback, optionally provides email.
3. Submission persisted, customer sees confirmation.
4. Event emitted for downstream notification and analytics.

### Workflow 2: Triage Inbox

1. PM opens inbox dashboard.
2. PM filters by source, tag, or date.
3. PM applies one or more tags to each submission.
4. PM groups duplicate submissions into a theme.

### Workflow 3: Promote To Candidate Task

1. PM selects 1-N submissions in a theme.
2. PM clicks "Create Candidate Task".
3. Product generates a markdown candidate task with cited submission IDs.
4. PM copies the markdown into their issue tracker.

## Requirements

### Functional

- Submissions must be persisted within 500ms of POST under nominal load.
- Tagging and grouping must be reversible without data loss.
- Candidate tasks must include source submission IDs and verbatim quotes (max 200 chars each).
- An import job must accept JSONL files matching the export contract.
- Email addresses must be redacted in any export shared externally.

### Non-Functional

- All durable data hosted in a single Postgres database.
- All endpoints respond within p95 < 400ms under nominal load (100 RPS).
- Public form available without authentication; all other endpoints require authentication.
- The product is single-tenant per deployment in v1.

## Constraints

- Technical: TypeScript stack (server + web) to minimize cognitive load. Postgres for storage.
- Business: target self-hosted MIT licensing for v1.
- Compliance/privacy: never log raw email at INFO level. Hash email for analytics events.
- Time/cost: first usable demo in 6 weeks.

## Acceptance Criteria

- A customer can submit feedback via the public form and see a confirmation page.
- A logged-in PM can list, filter by source/tag/date, and tag feedback items.
- A logged-in PM can group submissions into a theme and undo the grouping.
- A logged-in PM can produce a candidate task markdown for selected submissions.
- An ops user can run `feedback export --format jsonl` and get a file that matches the file-format contract.

## Assumptions

- One product team per deployment in v1; multi-tenancy can be added later without changing public-facing APIs.
- Volume per team: under 1000 submissions/day. Optimize for clarity, not throughput.
- The team already has an issue tracker; we do not need to build one.

## Open Questions

- Should anonymous submissions allow a follow-up channel (token-based reply link)?
- How long should redacted exports retain hashed emails before purge?

## Changelog

- 2026-05-12: initial SPEC.
