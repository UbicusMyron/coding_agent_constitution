<div align="center">

# Coding Agent Constitution

**將模糊的軟件想法，先變成可重用的項目前置治理資產，再交給智能體寫程式碼。**

[English](README.md) · [簡體中文](README_CN.md)

[![Agent Skill](https://img.shields.io/badge/Agent%20Skill-SKILL.md-111827)](#)
[![Codex](https://img.shields.io/badge/Codex-compatible-10a37f)](#)
[![Cursor](https://img.shields.io/badge/Cursor-compatible-5b5bf7)](#)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-d97706)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

</div>

---

## 這是甚麼？

這是一個給 **Codex、Cursor、Claude Code** 使用的開源 Agent Skill。

它不會一開始就急着寫程式碼。它會先幫你把一句很模糊的說法：

> 我想做一個工具，幫我把這個項目做起來。

整理成真正可以重用的倉庫檔案：

```text
docs/SPEC.md                  產品目標、功能邊界、非目標
docs/ARCH.md                  架構、模組邊界、技術選擇
docs/RULES.md                 編碼規則、測試規則、安全邊界
docs/CONTRACTS/README.md      API、資料結構、事件、介面約束
docs/TASKS/001-*.md           可執行的小任務
AGENTS.md                     Codex / 多智能體共享規則
CLAUDE.md                     Claude Code 入口
.cursor/rules/*.mdc           Cursor Project Rules
.claude/rules/*.md            Claude Code 模組化規則
```

一句話：

> 它把「聊天入面的想法」變成「倉庫入面的資產」。

## 為甚麼需要它？

直接叫智能體寫程式碼，常見問題是：

- 需求還未清楚，程式碼已經開始長出來
- 架構判斷藏在聊天記錄入面，下一輪就不見了
- API、資料模型、測試標準沒有人寫低
- Cursor、Codex、Claude Code 各自讀不同上下文
- 人類審查時不知道智能體到底跟了甚麼規則

這個 skill 的思路是：

```text
模糊意圖
-> 前置治理檔案
-> 有邊界的小任務
-> 智能體實現
-> Cursor / Claude / 人類審查
-> 決策再沉澱回檔案
```

## 甚麼時候適合用？

適合：

- 你只有一個產品想法，但未知道技術棧
- 你不知道應該先做哪個功能
- 你想讓 Codex / Cursor / Claude Code 協同工作
- 你想建立 `SPEC.md`、`ARCH.md`、`RULES.md`
- 你想把聊天入面的規則沉澱到倉庫入面
- 你要把一個大需求拆成多個安全的小任務

不適合：

- 已經很清楚的小 bug
- 只改一個函數
- 純粹格式化程式碼
- 取代人類做產品或架構最終決策

## 三大智能體兼容方式

| 智能體 | 建議入口 | 用途 |
| --- | --- | --- |
| Codex | `AGENTS.md` + `constitution-skill/SKILL.md` | 實現 bounded tasks、執行檢查、產出 reviewable changes |
| Cursor | `.cursor/rules/*.mdc` + optional `.cursor/skills/` | 做 IDE review、架構邊界檢查、局部修正 |
| Claude Code | `CLAUDE.md` + `.claude/rules/*.md` + optional `.claude/skills/` | 實現或 review bounded tasks，讀取 Claude 項目記憶 |

注意：

Cursor 雖然建基於 VS Code，但 agent 規則不應該主要放在 `.vscode/`。Cursor 的規則入口是 `.cursor/rules/`，skill 入口是 `.cursor/skills/`。

## 安裝方式

### Codex

將 skill 目錄放到你的 Codex skills 目錄：

```bash
mkdir -p ~/.codex/skills
cp -R constitution-skill ~/.codex/skills/constitution-skill
```

然後對 Codex 說：

```text
Use constitution-skill to turn this software idea into governance docs before coding.
```

### Cursor

項目級安裝：

```bash
mkdir -p .cursor/skills
cp -R constitution-skill .cursor/skills/constitution-skill
```

Cursor 項目規則建議使用生成出來的：

```text
.cursor/rules/project-governance.mdc
```

### Claude Code

項目級安裝：

```bash
mkdir -p .claude/skills
cp -R constitution-skill .claude/skills/constitution-skill
```

Claude Code 的項目入口建議使用：

```text
CLAUDE.md
```

其中 `CLAUDE.md` 可以直接導入共享規則：

```markdown
@AGENTS.md

## Claude Code

- Read the governance docs before implementation.
- Ask before changing risky surfaces.
```

## 最簡單的使用方式

直接把你的想法告訴 agent：

```text
我想做一個 SaaS 工具，幫小團隊追蹤客戶反饋、自動總結需求、生成開發任務。
我還不知道技術棧、資料庫、API 應該怎樣設計。
請先用 constitution-skill 做前置治理，不要急着寫程式碼。
```

理想輸出不是一堆程式碼，而是：

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

## 文件生成之後，怎樣真正開始實現？

當前置治理檔案已經生成，不要直接對智能體說「把整個 app 做出來」。這樣項目很容易再次失控。正確做法是：把第一個任務檔案當成由規劃進入實現的橋。

1. 打開第一個任務。

   通常由類似這個檔案開始：

   ```text
   docs/TASKS/001-bootstrap-feedback-inbox.md
   ```

   這個檔案應該只描述一個細小、清楚、方便 review 的實現切片。

2. 讓一個編碼智能體只實現這個任務。

   可以這樣說：

   ```text
   Read AGENTS.md, docs/SPEC.md, docs/ARCH.md, docs/RULES.md,
   and docs/TASKS/001-bootstrap-feedback-inbox.md.

   Implement only this task.
   Do not change public APIs, database schemas, auth, billing,
   or destructive behavior unless the task explicitly says so.

   Run the listed verification checks.
   Then summarize files changed, checks run, risks, and what needs review.
   ```

3. 做完之後先 review，再做下一個任務。

   你可以用 Cursor、Claude Code、Codex review mode，或者自己人工檢查：

   - diff 是否符合任務？
   - 智能體有沒有改到範圍外的檔案？
   - 有沒有測試或驗證步驟？
   - 有沒有改變架構、契約、產品決策？

4. 把長期有用的新發現寫回檔案。

   如果實現過程中發現了之後還會用到的規則、介面、架構選擇或產品澄清，就更新：

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

5. 再進入下一個小任務。

   循環很簡單：

   ```text
   選擇一個任務
   -> 實現它
   -> 執行檢查
   -> review diff
   -> 必要時更新長期文件
   -> 選擇下一個任務
   ```

對新手來說，最安全的規則是：

> 一次只做一個任務，一次只讓一個智能體主實現，一次 review 之後再繼續。

## 核心原則

```text
Human owns intent.
Agents implement bounded work.
Review layers inspect diffs.
Durable knowledge belongs in files.
Disposable plans can be replaced.
```

中文解釋：

```text
人類定義意圖。
智能體只做有邊界的改動。
review 工具檢查 diff。
長期知識寫進檔案。
一次性執行計劃可以丟掉。
```

## 倉庫結構

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

## 授權

MIT License。放心使用、fork、改造，令你的編碼智能體少一點混亂，多一點秩序。
