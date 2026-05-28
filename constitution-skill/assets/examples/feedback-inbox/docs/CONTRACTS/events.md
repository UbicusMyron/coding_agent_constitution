<!--
Owner: feedback-team
Last Reviewed: 2026-05-12
Status: Active
-->

# Event Contracts: Feedback Inbox

## Transport

- Source: `feedback_events` table in Postgres (`docs/CONTRACTS/db-schema.sql`).
- Delivery: `event-worker` polls pending rows every 2 seconds, calls each integration target, marks `emitted_at` on success.
- Idempotency: each event row carries a unique id; downstream consumers must dedupe.

## Events

### `feedback.submitted`

Emitted after a feedback row is persisted.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "FeedbackSubmittedEvent",
  "type": "object",
  "required": ["eventId", "eventVersion", "occurredAt", "feedback"],
  "additionalProperties": false,
  "properties": {
    "eventId":      { "type": "string", "format": "uuid" },
    "eventVersion": { "type": "string", "const": "1" },
    "occurredAt":   { "type": "string", "format": "date-time" },
    "feedback": {
      "type": "object",
      "required": ["id", "source", "message", "tags", "createdAt"],
      "properties": {
        "id":        { "type": "string", "format": "uuid" },
        "source":    { "type": "string", "enum": ["web", "mobile", "zapier", "api"] },
        "email":     { "type": ["string", "null"], "format": "email" },
        "message":   { "type": "string" },
        "tags":      { "type": "array", "items": { "type": "string" } },
        "createdAt": { "type": "string", "format": "date-time" }
      }
    }
  }
}
```

Example:

```json
{
  "eventId": "5b9f7a4c-19b3-4c8d-8e2a-9a3c0f1b2d77",
  "eventVersion": "1",
  "occurredAt": "2026-05-12T10:14:22.187Z",
  "feedback": {
    "id": "a3a18b8e-3a05-4f33-9f15-2a51bb0adb31",
    "source": "web",
    "email": "alice@example.com",
    "message": "Dark mode toggle would be great.",
    "tags": ["ui", "accessibility"],
    "createdAt": "2026-05-12T10:14:22.000Z"
  }
}
```

### `feedback.theme.created`

Emitted after a PM groups feedback into a theme.

```json
{
  "type": "object",
  "required": ["eventId", "eventVersion", "occurredAt", "theme"],
  "properties": {
    "eventId":      { "type": "string", "format": "uuid" },
    "eventVersion": { "type": "string", "const": "1" },
    "occurredAt":   { "type": "string", "format": "date-time" },
    "theme": {
      "type": "object",
      "required": ["id", "name", "feedbackIds"],
      "properties": {
        "id":          { "type": "string", "format": "uuid" },
        "name":        { "type": "string" },
        "feedbackIds": { "type": "array", "items": { "type": "string", "format": "uuid" } }
      }
    }
  }
}
```

## Failure Modes

| Failure | Worker Behavior | Consumer Expectation |
| --- | --- | --- |
| Integration HTTP 5xx | Retry up to 3 times with jitter, then mark `emitted_at` to avoid blocking queue; log error. | May miss the event. |
| Integration HTTP 4xx | Do not retry. Mark `emitted_at`. Log error with redacted payload. | Will not be retried. |
| Worker crash | Row remains pending; another worker picks it up. | At-least-once semantics. |

## Compatibility

- Add optional field on `feedback` or `theme` -> additive (no version bump).
- Add new event type -> additive.
- Remove or rename field -> breaking; bump `eventVersion`, run worker in dual-emit mode.

## Open Questions

- Should `email` be hashed in the event payload to reduce blast radius if a webhook URL leaks?
