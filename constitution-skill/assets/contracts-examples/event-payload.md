# Event Contract: `feedback.submitted`

## Purpose

Emitted whenever a feedback submission is persisted. Used by:

- Notification worker (sends Slack alert for high-priority tags).
- Analytics pipeline (daily aggregation).
- Zapier outbound integration.

Owner: feedback-team.

## Transport

- Queue: `events.feedback` (RabbitMQ topic exchange).
- Routing key: `feedback.submitted`.
- Encoding: UTF-8 JSON, one event per message.
- Headers: `x-event-version`, `x-event-id`, `x-correlation-id`.

## Schema

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
      "required": ["id", "source", "message", "createdAt"],
      "additionalProperties": false,
      "properties": {
        "id":        { "type": "string", "format": "uuid" },
        "source":    { "type": "string", "enum": ["web", "mobile", "zapier", "api"] },
        "email":     { "type": ["string", "null"], "format": "email" },
        "message":   { "type": "string", "maxLength": 4000 },
        "tags":      { "type": "array", "items": { "type": "string" }, "maxItems": 8 },
        "createdAt": { "type": "string", "format": "date-time" }
      }
    }
  }
}
```

## Example Payload

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

## Failure Modes

| Failure | Producer Behavior | Consumer Expectation |
| --- | --- | --- |
| Broker unreachable | Retry with exponential backoff up to 5 minutes; then log + skip. Submission still persisted. | None; consumers may miss this event. |
| Schema validation fails at producer | Do not emit. Log error. Alert. | Never observed by consumers. |
| Consumer cannot decode | Move to dead-letter queue `events.feedback.dlq`. | Manual replay only. |

## Ordering And Idempotency

- No global ordering guarantee.
- `eventId` is unique per emission. Consumers must dedupe.
- Re-delivery is possible on broker restart. Idempotent handlers required.

## Compatibility

- Adding a new optional field on `feedback` -> additive, allowed without version bump.
- Removing or renaming any field -> breaking; bump `eventVersion` to `2`, run producers in dual-emit mode until consumers cut over.

## Open Questions

- Should `email` be hashed before emission for privacy?
