# Contract Examples

Concrete, copy-ready examples of contract files. Use them as a starting point when creating real entries under `docs/CONTRACTS/`.

Each example is a fully filled instance, not a skeleton. The goal is to remove guesswork about field shape, error envelope, and example payloads.

| Format | File | Use For |
| --- | --- | --- |
| OpenAPI 3.x | `openapi-rest.yaml` | REST APIs (HTTP + JSON) |
| JSON Schema | `json-schema-validation.json` | Validation rules for any JSON payload |
| Event payload | `event-payload.md` | Queue messages, webhooks, internal events |
| SQL schema | `db-schema.sql` | Persistent tables and migrations |
| CLI contract | `cli-contract.md` | Command-line tool inputs and outputs |
| File format | `file-format.md` | CSV / JSONL / fixed-format files |

Copy the file into `docs/CONTRACTS/<your-name>.<suffix>` and edit. Replace the example domain (feedback inbox) with your own.
