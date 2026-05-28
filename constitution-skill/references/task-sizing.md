# Task Sizing

Use this guide to keep bounded tasks small enough for one agent pass and one review pass. A "task" here means one `docs/TASKS/NNN-*.md` file.

## Hard Limits

A task is too large if any of these are true. Split it.

| Signal | Limit |
| --- | --- |
| Files touched | > 5 production files |
| Diff size | > ~300 changed lines (excluding generated files, lockfiles, fixtures) |
| New top-level modules introduced | > 1 |
| Public API endpoints added or changed | > 2 |
| Database tables created or altered | > 1 |
| Verification commands | > 3 distinct commands |
| Distinct review concerns | > 1 (e.g., auth AND payments) |

These are guidelines, not laws. Crossing one signal is acceptable. Crossing two is a split candidate. Crossing three means split now.

## Soft Limits

A task is on the edge if any of these are true. Consider splitting; if not, document the reason in `Risks`.

- Adds a new dependency that affects deployment, security, or licensing.
- Touches both UI and backend in the same task.
- Requires a data migration.
- Introduces a new external service integration.
- Crosses two `ARCH.md` module boundaries.

## Sizing Anchors

Useful mental anchors when scoping the next task.

| Task Type | Typical Size |
| --- | --- |
| Schema-aligned endpoint implementation | 1-3 files, ~80-200 lines, 2-3 tests |
| Add one form to existing UI | 2-4 files, ~100-250 lines, 1-2 tests |
| Wire one external service adapter | 2-3 files, ~100-200 lines, contract test + integration test |
| Refactor with no behavior change | 3-5 files, ~100-300 lines, no new tests required, must pass existing |
| Bug fix with regression test | 1-2 production files, 1 test file, ~30-80 lines |

If the next task does not fit any anchor, ask: "can it be reframed as one of these?" If not, it is likely too coarse.

## Splitting Patterns

### Pattern 1: Slice By Layer

Bad: `001-add-feedback-feature.md` (DB + API + UI + tests + docs).

Good:
- `001-add-feedback-db-schema.md`
- `002-add-feedback-api-endpoints.md`
- `003-add-feedback-list-ui.md`
- `004-add-feedback-submit-form.md`

Each task ends with a working, reviewable slice. Earlier tasks must not depend on later ones for correctness.

### Pattern 2: Slice By Vertical

Bad: `001-implement-auth.md` (signup + login + reset + 2FA + session + middleware).

Good:
- `001-bootstrap-auth-session-model.md` (only data + middleware + one login endpoint)
- `002-add-auth-signup-endpoint.md`
- `003-add-auth-password-reset.md`
- `004-add-auth-2fa.md`

Each task delivers a complete vertical feature, end to end, but small.

### Pattern 3: Slice Out The Risky Decision

Bad: `001-refactor-payments-and-add-stripe.md`.

Good:
- `001-stabilize-payments-tests.md` (no behavior change)
- `002-introduce-payment-provider-interface.md` (contract only, no provider yet)
- `003-implement-stripe-adapter.md` (one provider, behind feature flag)
- `004-cutover-default-provider-to-stripe.md`

Risky decisions become their own task with explicit acceptance criteria.

### Pattern 4: Carve Out The Migration

Bad: `001-move-from-rest-to-graphql.md`.

Good:
- `001-introduce-graphql-gateway-alongside-rest.md`
- `002-migrate-resource-foo-to-graphql.md`
- ... one task per resource ...
- `NNN-remove-rest-endpoints.md`

Long-running migrations become a series of small, reversible tasks.

## When You Cannot Split Further

Some tasks legitimately need more lines. Acceptable reasons:

- Generated code, schema diff, or vendored file.
- Single mechanical rename across many files.
- One large fixture or seed dataset.

In those cases:

- Add a `## Size Justification` section to the task.
- Quote which limit was crossed and why.
- Ask Cursor or a human reviewer to spot-check rather than line-by-line review.

## Acceptance Criteria Sizing

Each task should have 2-6 acceptance criteria. Fewer means under-specified. More means under-scoped.

- 0-1: cannot verify, expand.
- 2-3: typical.
- 4-6: complex but acceptable.
- 7+: task is doing too much; split.

## Verification Sizing

Each task should have 1-3 verification commands. Examples of good verification commands:

- `npm test -- src/feedback/api.test.ts`
- `pytest tests/test_feedback_repo.py -x`
- `curl -fsS http://localhost:3000/api/feedback -d '@fixtures/sample.json'`

Bad verification: "manually click around" or "make sure it works".

## Smell Tests

Run these checks before handing the task to an agent.

1. Can a fresh agent execute this task without re-reading chat? If no, copy missing context into the task.
2. Could two reviewers reach the same conclusion about whether the task is done? If no, the criteria are too vague.
3. Could the task be reverted with a single `git revert`? If no, it is too entangled.
4. Does the task name describe one action? "Implement feedback list endpoint" is good. "Improve feedback system" is bad.
