# CONTRACTS

Contracts define stable interfaces between modules, services, tools, agents, or external systems. They are the most expensive durable assets to change, so they must be precise.

## Contract Index

| Contract | File | Owner | Consumers | Status |
| --- | --- | --- | --- | --- |
|  |  |  |  | draft |

## What Goes Here

Create one file per contract. Pick the format that matches the interface type.

| Interface Type | Preferred Format | File Suffix |
| --- | --- | --- |
| REST or GraphQL API | OpenAPI 3.x or GraphQL SDL | `.openapi.yaml`, `.graphql` |
| Validation rules and payloads | JSON Schema | `.schema.json` |
| Event / message payload | Markdown with JSON Schema or Avro | `<event>.md` |
| Database schema | SQL DDL or migration file | `.sql` |
| File format (CSV, JSONL, parquet headers) | Markdown spec with example file | `<format>.md` |
| CLI tool input/output | Markdown spec with example invocations | `<tool>.md` |
| Internal module interface (in-process) | Typed source file (header/`.d.ts`/Protocol class) checked in here | language-specific |

For concrete worked examples of each format, see `../contracts-examples/`.

## Required Sections Per Contract File

Every contract file should include:

1. **Purpose** -- one paragraph: what this interface is for and who owns it.
2. **Schema** -- the machine-checkable definition (OpenAPI, JSON Schema, SQL DDL, etc.). Inline or linked.
3. **Examples** -- at least one valid example. At least one invalid example or error case.
4. **Errors** -- error envelope, status codes, and at least three named failure modes.
5. **Validation Rules** -- constraints not captured by the schema (e.g., "email must be unique", "amount must be positive integer cents").
6. **Compatibility** -- what changes are breaking. Default: any change is breaking unless explicitly listed as additive.
7. **Versioning** -- how versions are signaled (URL prefix, header, schema version field).
8. **Open Questions** -- unresolved interface concerns.

## Contract Rules

- Treat any change as breaking unless explicitly listed as additive.
- Update the contract in the same PR that changes the implementation.
- Add at least one example payload for every request, response, event, or file format.
- Define error behavior, not just happy path.
- Update implementation tasks when a contract changes.
- Run `scripts/check-governance.sh` (or equivalent) to detect handler/contract drift.

## Backward Compatibility Categories

Use these labels in commit messages or PR titles when a contract changes.

| Label | Meaning |
| --- | --- |
| `contract:add` | Pure addition (new optional field, new endpoint). Non-breaking. |
| `contract:relax` | Loosens validation (e.g., field becomes optional). Often non-breaking but check consumers. |
| `contract:tighten` | Adds constraint (e.g., field becomes required). Breaking. |
| `contract:remove` | Removes field, endpoint, or event. Breaking. |
| `contract:rename` | Renames field or endpoint. Breaking unless aliased. |
| `contract:semantic` | Same shape, different meaning. Breaking. The most dangerous category. |

## Breaking Change Workflow

When a breaking change is required:

1. Add a new ADR in `docs/DECISIONS/` describing why.
2. Bump the contract version explicitly.
3. Provide a migration plan in the same PR: deprecation window, dual-write or dual-read strategy, removal date.
4. Notify all listed `Consumers` in the index.

## Open Contract Questions

- 
