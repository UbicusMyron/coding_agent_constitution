<!--
Owner: feedback-team
Last Reviewed: 2026-05-12
Status: Active
-->

# CLI Contract: `feedback`

## Purpose

Operator-facing CLI for querying and exporting the feedback inbox. Used by support staff and scheduled cron jobs.

## Invocation

```text
feedback <command> [flags]
```

## Commands

### `feedback list`

| Flag | Type | Default | Description |
| --- | --- | --- | --- |
| `--source` | enum (`web`, `mobile`, `zapier`, `api`) | none | Filter by source. |
| `--tag` | string | none | Filter by tag. |
| `--since` | RFC 3339 timestamp | 24h ago | Lower bound (inclusive). |
| `--limit` | int 1..1000 | 50 | Max rows. |
| `--format` | enum (`table`, `json`, `jsonl`, `csv`) | `table` | Output format. |

### `feedback export`

| Flag | Type | Default | Description |
| --- | --- | --- | --- |
| `--out` | path | required | Output file. Refuses to overwrite unless `--force`. |
| `--format` | enum (`json`, `jsonl`, `csv`) | `jsonl` | Output format. |
| `--since` | timestamp | 30d ago | Lower bound. |
| `--until` | timestamp | now | Upper bound. |
| `--redact` | bool | false | Use redacted format (see `file-format.md`). Required for external sharing. |
| `--force` | bool | false | Allow overwrite. |

Writes atomically: `<out>.tmp` then rename to `<out>`. Removes the temp file on non-zero exit.

## Configuration

Reads in order (later wins): built-in defaults -> `~/.config/feedback/config.toml` -> env (`FEEDBACK_API_URL`, `FEEDBACK_API_TOKEN`) -> command-line flags.

## Exit Codes

| Code | Meaning |
| --- | --- |
| 0 | Success (including zero rows). |
| 2 | Invalid flag or argument. |
| 3 | Authentication or authorization failure. |
| 4 | Transient backend error (safe to retry). |
| 5 | Permanent backend error (do not retry). |

## Compatibility

- New flag with default that preserves old behavior -> additive.
- Remove or rename flag, change default, or change exit code semantics -> breaking.
- Add column at end of `csv` / `table` output -> additive only when consumers use header lookup, not positional parsing. Document explicitly.

## Examples

```sh
feedback list --source web --limit 10 --format json
feedback export --out feedback.jsonl --since 2026-04-01 --redact --force
```
