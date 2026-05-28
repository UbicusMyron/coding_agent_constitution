<!--
Owner: feedback-team
Last Reviewed: 2026-05-12
Status: Active
-->

# File Format Contract: Feedback Export JSONL

## Purpose

Bulk export format produced by `feedback export --format jsonl`. Consumed by the analytics pipeline and the customer-success archival job.

## Format

- Encoding: UTF-8, no BOM.
- Line terminator: `\n`.
- One JSON object per line; matches the `Feedback` schema from `docs/CONTRACTS/feedback-api.openapi.yaml`.
- Records ordered by `createdAt` ascending, then `id` ascending.

## Example

```text
{"id":"a3a18b8e-3a05-4f33-9f15-2a51bb0adb31","source":"web","email":"alice@example.com","message":"Dark mode toggle would be great.","tags":["ui","accessibility"],"themeId":null,"createdAt":"2026-05-12T10:14:22.000Z"}
{"id":"7c8e9f12-58a4-4c92-9a7e-d2b1e8c6f5a0","source":"api","email":null,"message":"Anonymous test.","tags":[],"themeId":null,"createdAt":"2026-05-12T10:15:00.000Z"}
```

## Validation

- Each line must be valid JSON; a malformed line aborts the whole file.
- Duplicate `id` values are forbidden.
- Empty file (zero lines) is valid and means "no records in range".

## Redacted Variant

`feedback export --redact` produces the same shape but:

- `email` is replaced with `sha256(lowercased_email)` and a constant suffix `:r1`.
- `message` is unchanged.

The redacted variant is the only format permitted for external sharing.

## Compatibility

- Add optional field -> additive; consumers must ignore unknown fields.
- Remove or rename any field -> breaking.
- Changing line terminator, encoding, or ordering -> breaking.

## File Naming

`feedback-YYYY-MM-DD.jsonl` for daily exports, UTC day boundary.
