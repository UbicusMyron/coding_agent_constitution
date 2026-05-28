<div align="center">

# Coding Agent Constitution

**Turn vague software ideas into durable project governance before any agent starts coding.**

[Simplified Chinese](README_CN.md) · [Traditional Chinese (Hong Kong)](README_HK.md)

[![Agent Skill](https://img.shields.io/badge/Agent%20Skill-SKILL.md-111827)](#)
[![Codex](https://img.shields.io/badge/Codex-compatible-10a37f)](#)
[![Cursor](https://img.shields.io/badge/Cursor-compatible-5b5bf7)](#)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-d97706)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

</div>

---

## What Is This?

Coding Agent Constitution is an open-source Agent Skill for **Codex, Cursor, and Claude Code**.

It helps coding agents slow down before implementation and turn unclear software intent into durable repo-native governance files.

Instead of jumping from:

> I have an idea. Please build it.

straight into code, this skill creates:

```text
docs/SPEC.md                  product goals, boundaries, non-goals
docs/ARCH.md                  architecture, module boundaries, technical choices
docs/RULES.md                 coding, testing, and safety rules
docs/CONTRACTS/README.md      APIs, schemas, events, interfaces
docs/TASKS/001-*.md           small executable implementation tasks
AGENTS.md                     shared instructions for Codex and other agents
CLAUDE.md                     Claude Code entrypoint
.cursor/rules/*.mdc           Cursor Project Rules
.claude/rules/*.md            Claude Code modular rules
```

In one sentence:

> It turns chat-only intent into reusable repository assets.

## Why Does This Exist?

Coding agents are powerful, but starting with code too early creates drift:

- requirements live only in chat
- architecture decisions disappear between sessions
- interfaces are implemented before they are agreed on
- tests and review rules are inconsistent
- Codex, Cursor, and Claude Code each see different context
- humans cannot easily review what the agent was following

This skill creates a safer flow:

```text
vague intent
-> governance assets
-> bounded tasks
-> agent implementation
-> Cursor / Claude / human review
-> durable decisions go back into files
```

## When Should I Use It?

Use it when:

- the product idea is still fuzzy
- the tech stack is undecided
- architecture boundaries are unclear
- APIs or data contracts are missing
- you want Codex, Cursor, and Claude Code to share one project context
- you want to create `SPEC.md`, `ARCH.md`, `RULES.md`, or `AGENTS.md`
- a big request needs to become smaller reviewable tasks

Do not use it for:

- tiny already-scoped bug fixes
- single-function edits
- pure formatting
- replacing human product or architecture decisions

## Compatibility

| Agent | Recommended entrypoint | Best role |
| --- | --- | --- |
| Codex | `AGENTS.md` + `constitution-skill/SKILL.md` | Implement bounded tasks and run checks |
| Cursor | `.cursor/rules/*.mdc` + optional `.cursor/skills/` | Review diffs and enforce project rules |
| Claude Code | `CLAUDE.md` + `.claude/rules/*.md` + optional `.claude/skills/` | Implement or review bounded tasks with Claude project memory |

Important note:

Cursor is based on VS Code, but agent governance does not primarily live in `.vscode/`. Use `.cursor/rules/` for Cursor rules and `.cursor/skills/` for Cursor Agent Skills.

## Installation

### Codex

```bash
mkdir -p ~/.codex/skills
cp -R constitution-skill ~/.codex/skills/constitution-skill
```

Then ask:

```text
Use constitution-skill to turn this software idea into governance docs before coding.
```

### Cursor

Project-local installation:

```bash
mkdir -p .cursor/skills
cp -R constitution-skill .cursor/skills/constitution-skill
```

Recommended generated Cursor rule:

```text
.cursor/rules/project-governance.mdc
```

### Claude Code

Project-local installation:

```bash
mkdir -p .claude/skills
cp -R constitution-skill .claude/skills/constitution-skill
```

Recommended Claude Code entrypoint:

```text
CLAUDE.md
```

Example:

```markdown
@AGENTS.md

## Claude Code

- Read governance docs before implementation.
- Ask before changing risky surfaces.
```

## The Simplest Prompt

```text
I want to build a SaaS tool for small teams to collect customer feedback,
summarize feature requests, and generate development tasks.
I do not know the stack, architecture, database, or API design yet.
Use constitution-skill to create governance assets before coding.
```

Expected output:

```text
docs/SPEC.md
docs/ARCH.md
docs/RULES.md
docs/CONTRACTS/README.md
docs/TASKS/001-bootstrap-feedback-inbox.md
AGENTS.md
CLAUDE.md
.cursor/rules/project-governance.mdc
.claude/rules/project-governance.md
```

## After The Docs Exist, How Do I Actually Build The Thing?

Once the governance files exist, do not ask the agent to "build the whole app". That is how projects get messy again. Instead, use the first task file as the bridge from planning to implementation.

1. Open the first task.

   Start with something like:

   ```text
   docs/TASKS/001-bootstrap-feedback-inbox.md
   ```

   This file should describe one small, reviewable implementation slice.

2. Ask one coding agent to implement only that task.

   Example prompt:

   ```text
   Read AGENTS.md, docs/SPEC.md, docs/ARCH.md, docs/RULES.md,
   and docs/TASKS/001-bootstrap-feedback-inbox.md.

   Implement only this task.
   Do not change public APIs, database schemas, auth, billing,
   or destructive behavior unless the task explicitly says so.

   Run the listed verification checks.
   Then summarize files changed, checks run, risks, and what needs review.
   ```

3. Review the change before doing the next task.

   Use Cursor, Claude Code, Codex review mode, or a human reviewer to check:

   - does the diff match the task?
   - did the agent change files outside the allowed scope?
   - are tests or verification steps present?
   - did any architecture, contract, or product decision change?

4. Promote durable discoveries back into files.

   If implementation reveals a rule, contract, architecture choice, or product clarification that should matter later, update:

   ```text
   docs/SPEC.md
   docs/ARCH.md
   docs/RULES.md
   docs/CONTRACTS/
   AGENTS.md
   CLAUDE.md
   .cursor/rules/
   .claude/rules/
   ```

5. Repeat with the next small task.

   The loop is simple:

   ```text
   pick one task
   -> implement it
   -> run checks
   -> review the diff
   -> update durable docs if needed
   -> pick the next task
   ```

For beginners, the safest rule is:

> One task, one agent implementation pass, one review pass, then move on.

## Mental Model

```text
Human owns intent.
Agents implement bounded work.
Review layers inspect diffs.
Durable knowledge belongs in files.
Disposable plans can be replaced.
```

## Repository Structure

```text
.
├─ README.md
├─ README_CN.md
├─ README_HK.md
├─ LICENSE
├─ constitution.md
└─ constitution-skill/
   ├─ SKILL.md
   ├─ agents/
   │  └─ openai.yaml
   ├─ references/
   │  ├─ bootstrap-question-bank.md
   │  ├─ cross-agent-compatibility.md
   │  └─ governance-asset-guide.md
   └─ assets/
      └─ governance-templates/
         ├─ AGENTS.md
         ├─ CLAUDE.md
         ├─ SPEC.md
         ├─ ARCH.md
         ├─ RULES.md
         ├─ TASK.md
         ├─ CONTRACTS_README.md
         ├─ cursor-project-governance.mdc
         └─ claude-project-governance.md
```

## License

MIT License. Use it, fork it, remix it, and make your agents less chaotic.
