# Cross-Agent Compatibility

Use this guide when making the generated governance assets work across Codex, Cursor, and Claude Code.

## Compatibility Principle

Keep one shared source of truth and create thin adapters for each tool:

- Shared canonical instructions: `AGENTS.md`
- Product/architecture/rules/contracts: `docs/SPEC.md`, `docs/ARCH.md`, `docs/RULES.md`, `docs/CONTRACTS/`
- Codex adapter: `AGENTS.md`
- Cursor adapter: `.cursor/rules/project-governance.mdc`
- Claude Code adapter: `CLAUDE.md` plus optional `.claude/rules/*.md`

Avoid copying long rules into three places. Duplicated rules drift.

## Skill Installation Targets

For project-local installation, prefer the tool-native path the user is actually using:

- Codex: copy the skill folder into the user's Codex skills directory or the repo's supported skill location.
- Claude Code: `.claude/skills/constitution-skill/SKILL.md`
- Cursor: `.cursor/skills/constitution-skill/SKILL.md`

For open-source distribution, keep the package itself as a plain skill folder with `SKILL.md`, `references/`, and `assets/`. Users or installers can copy it into the right tool directory.

## Codex

Use `AGENTS.md` for repository instructions:

- Keep it concise and agent-focused.
- Include setup, test, coding, review, and approval rules.
- Reference durable docs instead of pasting large specs into `AGENTS.md`.
- Use nested `AGENTS.md` files only when subdirectories need distinct rules.

## Cursor

Use Cursor Project Rules for persistent project behavior:

- Store rules under `.cursor/rules/`.
- Prefer `.mdc` files with YAML frontmatter.
- Use `alwaysApply: true` for governance rules that must be included every session.
- Use `globs` for path-scoped rules.
- Use Cursor skills under `.cursor/skills/<skill-name>/SKILL.md` for task-specific workflows.

Cursor is based on VS Code, but `.vscode/` is not the main agent-governance location. Use `.vscode/` only for editor settings, extensions, launch configs, or tasks.

## Claude Code

Use `CLAUDE.md` for project instructions:

- Keep root `CLAUDE.md` thin.
- Import shared instructions with `@AGENTS.md` when `AGENTS.md` already exists.
- Add Claude-specific guidance below the import only when necessary.
- Use `.claude/rules/*.md` for modular rules; rules without `paths` frontmatter are loaded broadly.
- Use path-scoped frontmatter when a rule only applies to certain files.

## File Map

Create this set for maximum compatibility:

```text
project-root/
├─ AGENTS.md
├─ CLAUDE.md
├─ docs/
│  ├─ SPEC.md
│  ├─ ARCH.md
│  ├─ RULES.md
│  ├─ CONTRACTS/
│  │  └─ README.md
│  └─ TASKS/
│     └─ 001-<slug>.md
├─ .cursor/
│  └─ rules/
│     └─ project-governance.mdc
└─ .claude/
   └─ rules/
      └─ project-governance.md
```

If a repo needs the constitution skill itself to be project-local, add one of:

```text
.cursor/skills/constitution-skill/SKILL.md
.claude/skills/constitution-skill/SKILL.md
```

Use one project-local skill copy rather than multiple duplicated copies when the user's toolchain can discover a shared location.
