<div align="center">

# Coding Agent Constitution

**把模糊的软件想法，先变成可复用的项目前置治理资产，再交给智能体写代码。**

[English](README.md) · [繁體中文（香港）](README_HK.md)

[![Agent Skill](https://img.shields.io/badge/Agent%20Skill-SKILL.md-111827)](#)
[![Codex](https://img.shields.io/badge/Codex-compatible-10a37f)](#)
[![Cursor](https://img.shields.io/badge/Cursor-compatible-5b5bf7)](#)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-d97706)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

</div>

---

## 这是什么？

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

如果上面这些文件名你大部分都不熟悉，没关系。先读 [`constitution-skill/references/rookie-onboarding.md`](constitution-skill/references/rookie-onboarding.md)，这是给“第一次做软件产品的人”准备的简短入门，读完再回来这里。

## 为什么需要它？

直接让智能体写代码，常见问题是：

- 需求还没清楚，代码已经开始长出来了
- 架构判断藏在聊天记录里，下一轮就丢了
- API、数据模型、测试标准没人写下来
- Cursor、Codex、Claude Code 各读各的上下文
- 人类 review 时不知道智能体到底按什么规则做的

这个 skill 的思路是：

```text
模糊意图
-> 前置治理文件
-> 有边界的小任务
-> 智能体实现
-> Cursor / Claude / 人类 review
-> 决策再沉淀回文件
```

## 适合谁？

这是一个**阶段性工具**：在“我有一个软件产品的想法”和“我已经有一位工程师把这个项目完全接管下来”之间这段窗口里有用。它的设计是锋利、专注，不试图覆盖所有事。

可能适合你，如果你是：

- 一位准备启动新项目的产品经理，希望文档比 kickoff 聊天活得更久
- 在做副业项目、之后会拉协作者进来的人
- 领域专家（设计师、分析师、运营）第一次做软件产品
- 愿意学一点工程的非技术 founder，让产物可移交
- 想在 agent 动代码之前先把基线立好的工程师

如果你对生成出来的文件里的工程术语还很陌生，请先读 [`constitution-skill/references/rookie-onboarding.md`](constitution-skill/references/rookie-onboarding.md)。这是面向“第一次做软件产品的人”的简短概念入门，不要求你会写代码。

## 它适合什么时候用？

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
- 想完全不接触任何工程概念（这是学习脚手架，不是 no-code 平台）

## 什么时候应该停止使用它？

这个 skill 的设计是：当项目稳定下来后，它会主动退出日常工作流。合理的“毕业”信号包括：

- 已经有一位全职工程师在维护 `docs/SPEC.md`、`docs/ARCH.md`、`docs/RULES.md`
- 每个改动都在走人工 code review
- 团队已经有自己的 onboarding 文档，能替代 rookie primer

到这一步之后，那些长期文件仍然在跑，但 skill 本身已经不再是你每天的入口。

## 三大智能体兼容方式

| 智能体 | 推荐入口 | 用途 |
| --- | --- | --- |
| Codex | `AGENTS.md` + `constitution-skill/SKILL.md` | 实现 bounded tasks，运行检查，产出 reviewable changes |
| Cursor | `.cursor/rules/*.mdc` + optional `.cursor/skills/` | 做 IDE review、架构边界检查、局部修正 |
| Claude Code | `CLAUDE.md` + `.claude/rules/*.md` + optional `.claude/skills/` | 实现或 review bounded tasks，读取 Claude 项目记忆 |

注意：

Cursor 虽然基于 VS Code，但 agent 规则不应该主要放在 `.vscode/`。Cursor 的规则入口是 `.cursor/rules/`，skill 入口是 `.cursor/skills/`。

## 安装方式

### Codex

把 skill 目录放到你的 Codex skills 目录：

```bash
mkdir -p ~/.codex/skills
cp -R constitution-skill ~/.codex/skills/constitution-skill
```

然后对 Codex 说：

```text
Use constitution-skill to turn this software idea into governance docs before coding.
```

### Cursor

项目级安装：

```bash
mkdir -p .cursor/skills
cp -R constitution-skill .cursor/skills/constitution-skill
```

Cursor 项目规则建议使用生成出来的：

```text
.cursor/rules/project-governance.mdc
```

### Claude Code

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

## 最简单的使用姿势

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

## 文档生成以后，怎么真正开始实现？

当前置治理文件已经生成，不要直接对智能体说“把整个 app 做出来”。这样项目很容易再次失控。正确做法是：把第一个任务文件当成从规划进入实现的桥。

1. 打开第一个任务。

   通常从类似这个文件开始：

   ```text
   docs/TASKS/001-bootstrap-feedback-inbox.md
   ```

   这个文件应该只描述一个小而清楚、方便 review 的实现切片。

2. 让一个编码智能体只实现这个任务。

   可以这样说：

   ```text
   Read AGENTS.md, docs/SPEC.md, docs/ARCH.md, docs/RULES.md,
   and docs/TASKS/001-bootstrap-feedback-inbox.md.

   Implement only this task.
   Do not change public APIs, database schemas, auth, billing,
   or destructive behavior unless the task explicitly says so.

   Run the listed verification checks.
   Then summarize files changed, checks run, risks, and what needs review.
   ```

3. 做完以后先 review，再做下一个任务。

   你可以用 Cursor、Claude Code、Codex review mode，或者自己人工检查：

   - diff 是否符合任务？
   - 智能体有没有改到范围外的文件？
   - 有没有测试或验证步骤？
   - 有没有改变架构、契约、产品决策？

4. 把长期有用的新发现写回文件。

   如果实现过程中发现了以后还会用到的规则、接口、架构选择或产品澄清，就更新：

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

5. 再进入下一个小任务。

   循环很简单：

   ```text
   选择一个任务
   -> 实现它
   -> 运行检查
   -> review diff
   -> 必要时更新长期文档
   -> 选择下一个任务
   ```

对新手来说，最安全的规则是：

> 一次只做一个任务，一次只让一个智能体主实现，一次 review 之后再继续。

## 核心原则

```text
Human owns intent.
Agents implement bounded work.
Review layers inspect diffs.
Durable knowledge belongs in files.
Disposable plans can be replaced.
```

中文解释：

```text
人类定义意图。
智能体只做有边界的改动。
review 工具检查 diff。
长期知识写进文件。
一次性执行计划可以丢掉。
```

## 仓库结构

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
   │  ├─ rookie-onboarding.md          # 给第一次做软件产品的人的概念入门
   │  ├─ bootstrap-question-bank.md    # 该问什么问题
   │  ├─ cross-agent-compatibility.md  # Codex / Cursor / Claude Code 适配映射
   │  ├─ governance-asset-guide.md     # 长期 vs 一次性资产、提升规则
   │  ├─ anti-patterns.md              # 常见的治理反模式
   │  ├─ task-sizing.md                # 量化的 bounded task 限制
   │  ├─ retrofit-mode.md              # 把治理引入 legacy 仓库
   │  ├─ governance-evolution.md       # 版本演进、ADR、归档
   │  └─ minimal-mode.md               # 单人 / 极简项目的轻量模式
   ├─ assets/
   │  ├─ governance-templates/
   │  │  ├─ AGENTS.md
   │  │  ├─ CLAUDE.md
   │  │  ├─ SPEC.md
   │  │  ├─ ARCH.md
   │  │  ├─ RULES.md
   │  │  ├─ TASK.md
   │  │  ├─ DECISION.md
   │  │  ├─ CONTRACTS_README.md
   │  │  ├─ cursor-project-governance.mdc
   │  │  └─ claude-project-governance.md
   │  ├─ contracts-examples/           # 填好的 OpenAPI / JSON Schema / event / SQL / CLI / 文件格式范例
   │  └─ examples/
   │     └─ feedback-inbox/            # 完整填好的样例项目
   └─ scripts/
      └─ check-governance.sh           # 漂移与缺失段落检测脚本
```

## 许可证

MIT License。随便用、fork、改造，让你的编码智能体少一点混乱，多一点秩序。
