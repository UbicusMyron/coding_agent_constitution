<!--
Owner: feedback-team
Last Reviewed: 2026-05-12
Status: Active
-->

# ARCH: Feedback Inbox

## Architecture Summary

A single TypeScript service backed by Postgres. Public form is a thin static page that posts to the same API. Server-side rendering is used for the authenticated dashboard. A background worker handles outbound events to Slack and Zapier. No microservices, no message queue for v1; the worker reads `feedback_events` table rows with a polling cursor.

```text
[Browser: public form]      ----HTTP POST---->  [api]
[Browser: admin dashboard]  ----HTTPS-------->  [api] -- Postgres
                                                  \--> [event-worker] --> Slack/Zapier
[CLI: feedback]             ----HTTPS-------->  [api]
```

## Technology Stack

- Runtime/language: Node.js 22, TypeScript 5.
- Frameworks: Fastify (HTTP), Drizzle (ORM), Vite (web bundle), htmx (dashboard interactions).
- Storage: Postgres 15.
- External services: Slack webhook, Zapier inbound webhook.
- Deployment: single container, Fly.io as default target. Postgres on Neon or self-hosted.

## Module Boundaries

| Module | Responsibility | Owns | Must Not Own |
| --- | --- | --- | --- |
| `api/http` | HTTP routes, validation, auth middleware | request/response shapes | domain rules, persistence details |
| `api/feedback` | Domain logic for feedback lifecycle | tagging, grouping, candidate-task generation | direct SQL, HTTP concerns |
| `api/persistence` | Postgres access via Drizzle | SQL, migrations, transactions | HTTP, business rules |
| `api/events` | Event emit + consume | `feedback_events` writes, worker polling | HTTP, Slack formatting |
| `integrations/slack` | Slack message formatting and sending | webhook URL config, retry logic | event semantics, domain logic |
| `integrations/zapier` | Zapier outbound webhook | webhook URL config, retry logic | event semantics, domain logic |
| `web/dashboard` | Server-rendered HTML + htmx fragments | UI markup, dashboard routes | direct DB access |
| `cli/feedback` | `feedback` CLI commands | argument parsing, output formatting | direct DB access |

## Data Model

Entities:

- `feedback` -- one submission (see `docs/CONTRACTS/db-schema.sql`).
- `tag` -- normalized tag string per submission, many-to-many via `feedback_tags`.
- `theme` -- group of related submissions; submissions belong to 0 or 1 theme.
- `feedback_event` -- outbox row for downstream emission.

Source of truth: Postgres. No secondary cache in v1.

## Interfaces

- Internal APIs: `api/feedback` exposes a TypeScript service interface consumed by `api/http`, `web/dashboard`, and `cli/feedback`. Other modules do not bypass it.
- External APIs: REST under `/v1/...`. See `docs/CONTRACTS/feedback-api.openapi.yaml`.
- Events: `feedback.submitted`, `feedback.theme.created`. See `docs/CONTRACTS/events.md` once authored; until then see contract examples in the skill.
- File formats: JSONL export per `docs/CONTRACTS/file-format.md`.
- CLI: `feedback list`, `feedback export`. See `docs/CONTRACTS/cli.md`.

## Dependency Rules

- `api/http` may depend on `api/feedback`. Reverse is forbidden.
- `api/feedback` may depend on `api/persistence`. Reverse is forbidden.
- `integrations/*` may depend only on `api/events`. They must not depend on `api/feedback` or `api/persistence`.
- `web/dashboard` and `cli/feedback` must go through `api/feedback`, not `api/persistence`.

## Operational Concerns

- Configuration: environment variables prefixed `FEEDBACK_`. No secrets in source.
- Observability: structured JSON logs to stdout. Request ID propagated as `x-request-id`. Metrics via Prometheus `/metrics`.
- Failure handling: any external-service call has 3 retries with jitter. After that, log and drop.
- Backups/migrations: Drizzle migrations are forward-only. Backups daily, retained 7 days.
- Security: TLS terminated at platform load balancer. Tokens stored hashed (Argon2id).

## Tradeoffs

- **Outbox via DB poll vs broker**: chose DB outbox to avoid running RabbitMQ/Kafka for a small team. Acceptable while volume is < 5 RPS sustained. Revisit at 50 RPS.
- **htmx vs SPA**: chose server-rendered + htmx to ship a usable dashboard with one team. SPA tooling overhead not justified at this scale.
- **Single service vs split**: kept all backend code in one service. Splitting `integrations/*` into a worker process is acceptable later; modules are already isolated.

Rejected alternatives:

- Hosted form provider (Typeform/Google Form) -- rejected because workflow (tagging, themes, candidate tasks) requires custom UI.
- NoSQL store -- rejected because tag, theme, and join queries dominate access patterns.

## Open Technical Questions

- Should we add row-level encryption for the `email` column? Decision pending privacy review.
- When to introduce a real broker? Likely tied to volume; deferred.
