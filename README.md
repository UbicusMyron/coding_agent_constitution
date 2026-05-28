<div align="center">

# Coding Agent Constitution

**Turn vague software ideas into durable project governance before any agent starts coding.**

**把模糊的软件想法，先变成可复用的项目前置治理资产，再交给智能体写代码。**

[![Agent Skill](https://img.shields.io/badge/Agent%20Skill-SKILL.md-111827)](#)
[![Codex](https://img.shields.io/badge/Codex-compatible-10a37f)](#)
[![Cursor](https://img.shields.io/badge/Cursor-compatible-5b5bf7)](#)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-d97706)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

</div>

---

## 中文

### 这是什么？

这是一个给 **Codex、Cursor、Claude Code** 使用的开源 Agent Skill。

它不急着写代码。它先帮你把一句很模糊的话：

> 我想做一个工具，帮我把这个项目搞起来。

整理成这些真正能复用的仓库文件：

```text
docs/SPEC.md                  产品目标、功能边界、非目标
docs/ARCH.md                  架构、模块边界、技术选择
docs/RULES.md                 编码规则、测试规则、安全边界
docs/CONTRACTS/README.md      API、数据结构、事件、接口约束
docs/TASKS/001-*.md           可执行的小任务
AGENTS.md                     Codex / 多智能体共享规则
CLAUDE.md                     Claude Code 入口
.cursor/rules/*.mdc           Cursor Project Rules
.claude/rules/*.md            Claude Code 模块化规则
```

一句话：

> 它把“聊天里的想法”变成“仓库里的资产”。

### 为什么需要它？

直接让智能体写代码，常见问题是：

- 需求还没清楚，代码已经开始长出来了
- 架构判断藏在聊天记录里，下一轮就丢了
- API、数据模型、测试标准没人写下来
- Cursor、Codex、Claude Code 各读各的上下文
- 人类 review 时不知道智能体到底按什么规则做的

这个 skill 的思路是：

```text
模糊意图
→ 前置治理文件
→ 有边界的小任务
→ 智能体实现
→ Cursor / Claude / 人类 review
→ 决策再沉淀回文件
```

### 它适合什么时候用？

适合：

- 你只有一个产品想法，但不知道技术栈
- 你不知道该先写什么功能
- 你想让 Codex / Cursor / Claude Code 协同工作
- 你想创建 `SPEC.md`、`ARCH.md`、`RULES.md`
- 你想把聊天里的规则沉淀到仓库里
- 你要把一个大需求拆成多个安全的小任务

不适合：

- 已经很明确的小 bug
- 只改一个函数
- 纯粹格式化代码
- 替代人类做产品或架构最终决策

### 三大智能体兼容方式

| 智能体 | 推荐入口 | 用途 |
| --- | --- | --- |
| Codex | `AGENTS.md` + `constitution-skill/SKILL.md` | 实现 bounded tasks，运行检查，产出 reviewable changes |
| Cursor | `.cursor/rules/*.mdc` + optional `.cursor/skills/` | 做 IDE review、架构边界检查、局部修正 |
| Claude Code | `CLAUDE.md` + `.claude/rules/*.md` + optional `.claude/skills/` | 实现或 review bounded tasks，读取 Claude 项目记忆 |

注意：

Cursor 虽然基于 VS Code，但 agent 规则不应该主要放在 `.vscode/`。  
Cursor 的规则入口是 `.cursor/rules/`，skill 入口是 `.cursor/skills/`。

### 安装方式

#### Codex

把 skill 目录放到你的 Codex skills 目录：

```bash
mkdir -p ~/.codex/skills
cp -R constitution-skill ~/.codex/skills/constitution-skill
```

然后对 Codex 说：

```text
Use constitution-skill to turn this software idea into governance docs before coding.
```

#### Cursor

项目级安装：

```bash
mkdir -p .cursor/skills
cp -R constitution-skill .cursor/skills/constitution-skill
```

Cursor 项目规则建议使用生成出来的：

```text
.cursor/rules/project-governance.mdc
```

#### Claude Code

项目级安装：

```bash
mkdir -p .claude/skills
cp -R constitution-skill .claude/skills/constitution-skill
```

Claude Code 的项目入口建议使用：

```text
CLAUDE.md
```

其中 `CLAUDE.md` 可以直接导入共享规则：

```markdown
@AGENTS.md

## Claude Code

- Read the governance docs before implementation.
- Ask before changing risky surfaces.
```

### 最简单的使用姿势

把你的想法直接告诉 agent：

```text
我想做一个 SaaS 工具，帮小团队追踪客户反馈、自动总结需求、生成开发任务。
我还不知道技术栈、数据库、API 怎么设计。
请先用 constitution-skill 做前置治理，不要急着写代码。
```

理想输出不是一堆代码，而是：

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

### 核心原则

```text
Human defines intent.
Agent writes bounded changes.
Review tools inspect diffs.
Durable knowledge goes into files.
Temporary execution plans can be thrown away.
```

中文翻译：

```text
人类定义意图。
智能体只做有边界的改动。
review 工具检查 diff。
长期知识写进文件。
一次性执行计划可以丢掉。
```

### 仓库结构

```text
.
├─ README.md
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

---

## English

### What is this?

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

### Why does this exist?

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
→ governance assets
→ bounded tasks
→ agent implementation
→ Cursor / Claude / human review
→ durable decisions go back into files
```

### When should I use it?

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

### Compatibility

| Agent | Recommended entrypoint | Best role |
| --- | --- | --- |
| Codex | `AGENTS.md` + `constitution-skill/SKILL.md` | Implement bounded tasks and run checks |
| Cursor | `.cursor/rules/*.mdc` + optional `.cursor/skills/` | Review diffs and enforce project rules |
| Claude Code | `CLAUDE.md` + `.claude/rules/*.md` + optional `.claude/skills/` | Implement or review bounded tasks with Claude project memory |

Important note:

Cursor is based on VS Code, but agent governance does not primarily live in `.vscode/`.  
Use `.cursor/rules/` for Cursor rules and `.cursor/skills/` for Cursor Agent Skills.

### Installation

#### Codex

```bash
mkdir -p ~/.codex/skills
cp -R constitution-skill ~/.codex/skills/constitution-skill
```

Then ask:

```text
Use constitution-skill to turn this software idea into governance docs before coding.
```

#### Cursor

Project-local installation:

```bash
mkdir -p .cursor/skills
cp -R constitution-skill .cursor/skills/constitution-skill
```

Recommended generated Cursor rule:

```text
.cursor/rules/project-governance.mdc
```

#### Claude Code

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

### The simplest prompt

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

### Mental model

```text
Human owns intent.
Agents implement bounded work.
Review layers inspect diffs.
Durable knowledge belongs in files.
Disposable plans can be replaced.
```

### License

MIT License. Use it, fork it, remix it, and make your agents less chaotic.
