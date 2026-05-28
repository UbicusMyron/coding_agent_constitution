# CLI Contract: `feedback`

## Purpose

Command-line tool for operators to query and export the feedback inbox. Used by support, on-call, and scripted exports.

Owner: feedback-team. Consumers: support scripts, internal cron jobs.

## Invocation

```text
feedback <command> [flags]
```

## Commands

### `feedback list`

List recent feedback.

| Flag | Type | Default | Description |
| --- | --- | --- | --- |
| `--source` | string enum (`web`, `mobile`, `zapier`, `api`) | none | Filter by submission source. |
| `--since` | RFC 3339 timestamp | 24h ago | Lower bound (inclusive). |
| `--limit` | int (1..1000) | 50 | Maximum rows returned. |
| `--format` | enum (`table`, `json`, `jsonl`, `csv`) | `table` | Output format. |

Stdin: not read.

Stdout:
- `table` -- human-readable, fixed column order: `created_at`, `source`, `email`, `message`.
- `json` -- single array of feedback objects matching the OpenAPI `Feedback` schema.
- `jsonl` -- one feedback object per line.
- `csv` -- header row `created_at,source,email,message,tags`, RFC 4180 quoting.

Stderr: human-readable messages and warnings only.

Exit codes:

| Code | Meaning |
| --- | --- |
| 0 | Success (including zero rows). |
| 2 | Invalid flag or argument. |
| 3 | Authentication or authorization failure. |
| 4 | Transient backend error (retry safe). |
| 5 | Permanent backend error (do not retry). |

### `feedback export`

Bulk export to a file.

| Flag | Type | Default | Description |
| --- | --- | --- | --- |
| `--out` | path | required | Destination file. Refuses to overwrite unless `--force` is set. |
| `--format` | enum (`json`, `jsonl`, `csv`) | `jsonl` | Output format. |
| `--since` | timestamp | 30d ago | Lower bound. |
| `--until` | timestamp | now | Upper bound. |
| `--force` | bool | false | Overwrite existing output. |

Behavior:
- Writes atomically: `<out>.tmp` then rename to `<out>`.
- On non-zero exit, the temp file is removed.

## Configuration

Reads in this order, later wins:

1. Built-in defaults.
2. `~/.config/feedback/config.toml`.
3. Environment variables: `FEEDBACK_API_URL`, `FEEDBACK_API_TOKEN`.
4. Command-line flags.

`--api-url` and `--api-token` flags override env vars.

## Examples

```sh
feedback list --source web --limit 10 --format json
feedback export --out feedback.jsonl --since 2026-04-01 --force
echo $?  # 0 on success
```

## Compatibility

- New flags with defaults that preserve old behavior -> additive.
- Removing a flag, renaming a flag, or changing a default -> breaking; bump major version.
- Changing exit code semantics -> breaking; bump major version.
- New columns appended at the end of CSV/table output -> additive only if scripts use header lookup, not positional parsing. Document explicitly.

## Open Questions

- Should `feedback delete` ever exist? Currently no, deletion is database-side only.
