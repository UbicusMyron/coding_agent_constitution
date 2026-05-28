# Retrofit Mode

Use this guide when introducing governance into a repository that already has substantial code, mixed conventions, no SPEC, no ARCH, and tribal knowledge in heads or scattered notes.

The greenfield workflow (`SKILL.md` step 3) does not fit here. Trying to write a complete SPEC for a legacy codebase up front will fail: nobody remembers the original intent, and the document becomes fiction.

## Core Principle

Do not try to retroactively document the whole repo at once. Retrofit governance one boundary at a time, starting from where work is actually about to happen.

The order is:

1. Inventory what already exists.
2. Pin down the seam you are about to change.
3. Write governance only for that seam.
4. Promote governance outward as work expands.

## Phase 0: Inventory

Spend one session purely reading. Produce a short `docs/inventory.md` (disposable) with:

- Repo layout (top-level folders, what they roughly do).
- Build, test, lint, deploy commands actually in use.
- Existing partial docs (README sections, comments, wikis).
- Known sensitive surfaces: payments, auth, migrations, external integrations.
- Known fragile areas: tests that flake, modules everyone fears to touch.

Do not write SPEC or ARCH yet. The inventory is scaffolding; archive or delete it once durable docs cover its content.

## Phase 1: Root AGENTS.md First

Before writing SPEC.md, write a thin `AGENTS.md` at the repo root. This unblocks every other agent immediately.

Include only:

- Where to find docs, even if they are partial.
- Commands for build, test, lint, run.
- Which folders or files are sensitive ("ask before touching `services/payments/*`").
- Which behaviors require human approval (auth, schema, billing, destructive ops).
- A `## Conventions In Doubt` section listing patterns the agent should follow when it sees ambiguity.

Keep it under 100 lines. Resist the urge to write a complete project description.

## Phase 2: Seam-First Governance

Pick the next module you intend to change. Write governance for that module only.

Produce, in this order:

1. `docs/CONTRACTS/<module>.md` -- the interfaces this module exposes today. Capture reality, not aspiration. Mark behavior you discovered as `## Observed Behavior`. Mark behavior you intend to change as `## Planned Changes`.
2. `docs/ARCH.md` -- start with a one-paragraph system overview and a single module entry for the seam. Use `## Modules` as a growing table, not a finished document.
3. `docs/RULES.md` -- only the rules you are about to enforce in the upcoming task. Add more later when you discover them.
4. `docs/SPEC.md` -- only the user-visible behavior of the seam. Mark `## Scope: <module>` so it does not pretend to cover the whole product.

The first task can then reference real durable context, even if the rest of the repo is still undocumented.

## Phase 3: Promote As You Expand

Each subsequent task expands the governance footprint:

- New module touched -> add a row to the `ARCH.md` module table and a brief responsibility note.
- New contract surface used by two callers -> promote into `docs/CONTRACTS/`.
- Rule violated twice in review -> promote into `docs/RULES.md`.
- Recurring agent confusion -> promote into `AGENTS.md`.

After ~5-10 tasks, the governance set will cover the active surface area of the repo. The rest stays undocumented until it becomes work.

## Phase 4: Decide When To Stop

Governance does not need to reach 100% coverage of a legacy repo. Stop when:

- Every active modification path has durable docs upstream of it.
- Every sensitive surface has an explicit approval rule.
- New contributors (human or agent) can start the next task without verbal handoff.

Modules untouched for >6 months can remain undocumented. Mark them as `## Frozen` in `ARCH.md` and require an explicit task to thaw them.

## Anti-Pattern: Documenting Everything First

A frequent mistake is to try to write the full SPEC.md, ARCH.md, and CONTRACTS for the entire legacy repo before any task. This fails because:

- Original intent is unknown; you will invent plausible fiction.
- The document is too large to keep accurate.
- Implementation drift will outpace doc maintenance immediately.
- The team loses appetite for governance before any work happens.

Always prefer seam-first.

## Retrofit Checklist

Before the first retrofit task:

- [ ] Root `AGENTS.md` exists and lists commands + sensitive surfaces.
- [ ] One module has a contract file.
- [ ] `ARCH.md` lists that module and its boundaries.
- [ ] `RULES.md` exists, even if minimal.
- [ ] One bounded task references the above files.
- [ ] No durable doc claims to cover the whole legacy repo.

When all six are true, run the first task. Repeat the cycle.

## Special Cases

### Forking An Internal Tool

Treat the fork as legacy from day one. Run retrofit. Do not assume original docs map to your fork.

### Vendor Or Generated Code

Do not include vendor/generated code in module tables. Mark its directory as `## Generated` in `ARCH.md` and forbid edits in `RULES.md`.

### Active Production Code With No Tests

Phase 0.5: before any retrofit task changes behavior, add characterization tests. Treat "add tests around module X" as its own retrofit task.
