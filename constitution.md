# AI-Native Dev Workflow
**Codex for implementation. Cursor for review. Human for control.**

## Core Principle

Use a **two-layer agent workflow**:

- **Codex** is the implementation agent  
  It reads the repo, executes scoped tasks, edits code, runs checks, and produces reviewable changes.

- **Cursor** is the IDE review layer  
  It helps with local reasoning, diff review, targeted refactors, rule enforcement, and human-in-the-loop intervention.

- **Human** owns product intent, architecture, and merge decisions.

## One-Line Workflow

**Human defines intent and constraints → Codex implements in bounded units → Cursor reviews and refines → Human approves and merges**

---

# 1. Role Split

## Human
Responsible for:
- defining product intent
- setting boundaries
- writing durable project docs
- approving risky changes
- deciding what gets merged

## Codex
Best used for:
- first-pass implementation
- contract-driven feature work
- mechanical refactors
- bug fixing
- test generation and repair
- localized iteration on a clearly defined task

## Cursor
Best used for:
- reviewing diffs
- checking architecture compliance
- spotting coupling and hidden risks
- doing small local rewrites
- helping humans inspect critical files and decisions

---

# 2. Asset Hierarchy

Not all project documents matter equally.

## Core assets
These should remain stable and compound in value over time:

- `SPEC.md` — product goals, boundaries, non-goals
- `ARCH.md` — architecture, module boundaries, design constraints
- `CONTRACTS/` — API schemas, DB rules, event formats, interfaces
- `RULES.md` — coding rules, testing rules, safety rails
- `.cursor/rules/` and `AGENTS.md` — persistent agent instructions

## Disposable assets
These are execution artifacts and can be replaced freely:

- `TASKS/*.md`
- implementation notes
- one-off plans
- temporary migration checklists
- experiment logs

## Rule of thumb

**Specs, architecture, contracts, and rules are assets.  
Tasks and implementation plans are consumables.**

---

# 3. Operating Rules

## Rule 1: Document before implementation
Never let major requirements live only in chat.

Every real task should be grounded in written project context.

## Rule 2: Give Codex bounded work
Codex should receive:
- one clear goal
- explicit constraints
- limited surface area
- clear acceptance criteria

Bad:
- “clean up the whole codebase”
- “refactor this app to be better”
- “add payments and improve reliability everywhere”

Good:
- “Implement login flow from `SPEC.md` section 2, do not change public API, add tests, run lint/typecheck/tests”
- “Integrate provider using `CONTRACTS/payment-api.yaml`, only touch `services/payments/*` and tests”
- “Refactor repository layer without changing controller signatures or database schema”

## Rule 3: One main editor per change
In a single work cycle:
- let **Codex** do the main modification
- let **Cursor** review or do local patching

Avoid having both agents actively rewriting the same area at the same time.

## Rule 4: Review before merge
No direct merge from agent output.

Every meaningful change should pass:
- architectural review
- diff review
- human approval on risky surfaces

## Rule 5: Push knowledge into files, not prompts
If a rule matters repeatedly, write it down.

Do not rely on re-explaining the same standards in every session.

---

# 4. Recommended Repository Structure

```text
project-root/
├─ docs/
│  ├─ SPEC.md
│  ├─ ARCH.md
│  ├─ RULES.md
│  ├─ DECISIONS/
│  ├─ TASKS/
│  └─ CONTRACTS/
├─ .cursor/
│  └─ rules/
├─ AGENTS.md
├─ README.md
└─ src/