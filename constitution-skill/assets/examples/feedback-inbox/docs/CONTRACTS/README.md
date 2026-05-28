<!--
Owner: feedback-team
Last Reviewed: 2026-05-12
Status: Active
-->

# CONTRACTS Index: Feedback Inbox

Stable interfaces between modules, services, and external consumers. Update each file in the same PR as the implementation it covers.

| Contract | File | Owner | Consumers | Status |
| --- | --- | --- | --- | --- |
| Feedback REST API v1 | `feedback-api.openapi.yaml` | feedback-team | web dashboard, public form, mobile webview, Zapier | Active |
| Feedback storage schema | `db-schema.sql` | feedback-team | api service, analytics export | Active |
| `feedback.submitted` event | `events-feedback-submitted.md` | feedback-team | Slack worker, Zapier worker, analytics | Active |
| Feedback export JSONL format | `file-format-export-jsonl.md` | feedback-team | analytics pipeline, archival job | Active |
| `feedback` CLI | `cli.md` | feedback-team | support scripts, internal cron | Active |

## Contract Rules

- Any contract change requires implementation and test changes in the same PR.
- Treat changes as breaking unless explicitly listed under `## Compatibility`.
- Breaking changes require an ADR under `docs/DECISIONS/` and a migration plan.
- Run `scripts/check-governance.sh` before push to detect contract/code drift.

## Adding A New Contract

1. Copy the closest example from `assets/contracts-examples/` in the skill.
2. Fill all required sections: Purpose, Schema, Examples, Errors, Validation Rules, Compatibility, Versioning, Open Questions.
3. Add a row to the index above.
4. Reference the new contract from `docs/ARCH.md` under `## Interfaces`.

## Open Contract Questions

- Outbound webhook contract for Slack/Zapier consumers: currently undocumented because we own both ends; promote to a real contract file when an external integrator joins.
