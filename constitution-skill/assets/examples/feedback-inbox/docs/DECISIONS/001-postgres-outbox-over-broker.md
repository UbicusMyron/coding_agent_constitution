<!--
Owner: feedback-team
Last Reviewed: 2026-05-12
Status: Active
-->

# Decision: Use Postgres Outbox Over A Message Broker

## Status

Accepted

## Date

2026-05-12

## Context

The product needs to emit `feedback.submitted` and `feedback.theme.created` events for downstream Slack and Zapier integrations. Options considered for the transport layer.

## Decision

Use a `feedback_events` table in the same Postgres database as durable storage, polled by a small worker. No message broker (RabbitMQ, NATS, Kafka, SQS) in v1.

## Consequences

- Positive:
  - One fewer infrastructure dependency to operate.
  - Strong consistency: event row is inserted in the same transaction as the feedback row.
  - Easy to introspect: events are queryable rows.
- Negative:
  - Polling adds modest latency (default 2s loop).
  - Will not scale past ~50 RPS sustained without changes.
- Follow-up:
  - Add a smoke metric for polling lag.
  - Set a review reminder when sustained traffic exceeds 5 RPS.

## Alternatives Considered

- RabbitMQ topic exchange: rejected because it adds an operational service for a team of 3-15.
- SQS: rejected because it ties us to AWS in v1, violating "self-hosted MIT" goal.
- In-memory pub/sub: rejected because process restarts would lose events.

## Supersedes

None.
