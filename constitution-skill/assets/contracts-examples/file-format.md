# File Format Contract: Feedback Export JSONL

## Purpose

Exchange format for bulk feedback exports between the API service and downstream analytics. Consumed by the BI pipeline daily.

Owner: feedback-team. Consumers: analytics pipeline, customer-success archival job.

## Format

- Encoding: UTF-8, no BOM.
- Line terminator: `\n` (LF).
- One JSON object per line.
- No trailing newline required, but allowed.
- Object schema matches `Feedback` from `openapi-rest.yaml`.

## Required Fields Per Line

```json
{
  "id": "uuid",
  "source": "web|mobile|zapier|api",
  "email": "string|null",
  "message": "string",
  "tags": ["string", "..."],
  "createdAt": "RFC 3339 timestamp"
}
```

## Example File

```text
{"id":"a3a18b8e-3a05-4f33-9f15-2a51bb0adb31","source":"web","email":"alice@example.com","message":"Dark mode toggle would be great.","tags":["ui","accessibility"],"createdAt":"2026-05-12T10:14:22.000Z"}
{"id":"7c8e9f12-58a4-4c92-9a7e-d2b1e8c6f5a0","source":"api","email":null,"message":"Anonymous submission test.","tags":[],"createdAt":"2026-05-12T10:15:00.000Z"}
```

## Ordering

- Records sorted by `createdAt` ascending.
- Within the same `createdAt`, sorted by `id` ascending.

## Validation Rules

- Each line must be valid JSON. A malformed line aborts the whole file.
- Duplicate `id` values are forbidden.
- Empty file (zero lines) is valid and represents "no records in range".

## Compatibility

- Adding optional fields -> additive; consumers must ignore unknown fields.
- Removing or renaming any field -> breaking.
- Changing line terminator, encoding, or ordering -> breaking.
- Schema changes are coordinated with the OpenAPI contract; both update in the same PR.

## File Naming Convention

`feedback-YYYY-MM-DD.jsonl` for daily exports, where the date is the UTC day boundary.

## Open Questions

- Should compressed variants (`.jsonl.gz`) be defined as a separate format file or as a transport option here?
