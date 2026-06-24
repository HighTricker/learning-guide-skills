# 学习指导 Skills 包

> 一个 Claude Code skills 包，把日常学习的完整路径拆解为 6 个互相协作的 skill：**注入学习目标 → 制定学习计划 → 写理解/应用 → 大模型批注 → 大模型出题 → 用户答题 → 大模型评判 → 学习总结**。装上之后，你和 Claude 一起完成学习。

---

## 安装

> **Windows 用户请注意**：下面的命令是 bash 脚本，需在 **Git Bash** 或 **WSL** 中执行（PowerShell / cmd 不能直接跑）。macOS / Linux 用系统自带终端即可。

### 方式 1：一行命令（推荐）

```bash
curl -sL https://raw.githubusercontent.com/HighTricker/learning-guide-skills/main/install.sh | bash
```

脚本会交互式问你装到项目级还是用户级。

### 方式 2：本地安装

```bash
git clone https://github.com/HighTricker/learning-guide-skills.git
cd learning-guide-skills
bash install.sh
```

也可以用参数跳过交互：

```bash
bash install.sh --user      # 用户级 ~/.claude/skills/
bash install.sh --project   # 项目级 ./.claude/skills/
```

### 验证安装

新开一个 Claude Code 终端窗口（让框架重新扫描 skills），输入 `/` 看自动补全列表，应该出现：

- `/学习信息注入`
- `/学习计划制定`

如果没出现，检查 `~/.claude/skills/` 或 `./.claude/skills/` 下是否有对应目录。

---

## 6 个 Skill 简介

| Skill | 类型 | 触发方式 | 作用 |
|---|---|---|---|
| **学习信息注入** | 任务型 | `/学习信息注入` 手动 | 创建 `学习目标.md`，记录你的学习目标、背景、偏好 |
| **学习计划制定** | 任务型 | `/学习计划制定` 手动 | 对比目标和资料，生成 `学习计划.md` + `学习笔记.md` 骨架 |
| **理解批注** | 参考型 | Claude 自动（你写完「我的理解」时） | 批注用户的理解，标注 ✅⚠️❌💡 |
| **应用批注** | 参考型 | Claude 自动（你写完「我的应用」时） | 批注用户的应用方案，结合实际项目 |
| **出题** | 参考型 | Claude 自动（你表达想做题时） | 基于批注查漏补缺出题，并评判答案 |
| **学习总结** | 参考型 | Claude 自动（所有答题评判完成时） | 汇总本章学习要点（已掌握 / 需复习 / 拓展建议 / 整体评估） |

---

## 典型使用流程

假设你想学某个领域，例如 Claude Code Skills：

### Step 1: 准备学习目录

```bash
mkdir 学习-Claude-Skills
cd 学习-Claude-Skills
mkdir 资料
# 把学习资料 md 文件放进 资料/ 下
```

### Step 2: 启动 Claude Code

```bash
claude
```

### Step 3: 注入学习目标

```
/学习信息注入
```

Claude 会渐进式问你：
- 学习目标是什么？想达到什么水平？
- 当前已有的应用场景 / 项目背景？
- 期望的学习周期？

回答后会生成 `学习目标.md`。

### Step 4: 制定学习计划

```
/学习计划制定
```

Claude 读取你的目标和资料，生成两个文件：
- `学习计划.md` —— 章节清单 + 学习顺序
- `学习笔记.md` —— 所有章节的空骨架，等你填

### Step 5: 学一章 — 写理解

打开 `学习笔记.md`，找到第 1 章，在「我的理解」下写下你的理解：

```markdown
### 我的理解
HTTP 是无状态的请求-响应协议…
```

保存。回到 Claude Code 说一句"我写完第 1 章的理解了"。

Claude 自动触发 **理解批注** skill，在「大模型批注（理解）」下写批注。

### Step 6: 写应用

在「我的应用」下写你的应用方案（例如"在我的电商项目里我用 fetch 调后端 API…"）。保存后告诉 Claude，自动触发 **应用批注** skill。

### Step 7: 做题

告诉 Claude："出几道题考我"。

Claude 自动触发 **出题** skill，在「出题与答题」下生成 3-5 道针对查漏点的题目。

### Step 8: 答题

在每道题的「我的答案 N」下写答案。保存后告诉 Claude，自动触发 **出题** 的评判分支。

### Step 9: 看本章总结，继续下一章

本章所有题目评判完成后，Claude 自动触发 **学习总结** skill，在「学习总结」下汇总本章「已掌握 / 需重点复习 / 拓展建议 / 整体评估」。看完回到 Step 5，处理第 2 章。

---

## 目录结构

### 仓库根

```
learning-guide-skills/
├── PRD.md              # 产品需求文档
├── 技术细则.md         # 共享契约 + 6 个 skill 完整设计
├── CLAUDE.md           # 项目协作规范
├── 开发计划.md         # 9 个开发任务清单
├── README.md           # 本文件
├── install.sh          # 一行命令安装脚本
└── skills/             # 6 个 skill 源码
    ├── 学习信息注入/SKILL.md
    ├── 学习计划制定/
    │   ├── SKILL.md
    │   └── templates/学习计划模板.md
    ├── 理解批注/SKILL.md
    ├── 应用批注/SKILL.md
    ├── 出题/SKILL.md
    └── 学习总结/SKILL.md
```

### 用户的学习项目目录

```
你的学习项目/
├── 学习目标.md         # 学习信息注入 创建
├── 学习计划.md         # 学习计划制定 创建
├── 学习笔记.md         # 学习计划制定 创建骨架；后续 4 个 skill 填内容
└── 资料/               # 你自己放学习材料
    ├── 章节1.md
    └── 章节2.md
```

---

## 设计文档

| 文档 | 用途 |
|---|---|
| [`PRD.md`](./PRD.md) | 产品需求文档 |
| [`技术细则.md`](./技术细则.md) | **改 skill 之前必读**：共享契约 + 6 个 skill 设计稿 |
| [`CLAUDE.md`](./CLAUDE.md) | 项目协作规范（每次启动自动加载） |
| [`开发计划.md`](./开发计划.md) | 开发任务清单 + 风险点 |

---

## V2 路线（暂未实现）

- 发布到 Claude Code plugin registry，支持 `claude plugin install 学习指导`
- 给出题 skill 加 `context: fork`（如果实际 token 消耗 > 5k）
- 学习进度可视化 / 自动统计
- examples/ 子文件（如果端到端测试发现示例必要）

---

## 卸载

直接删除安装位置的 skill 目录：

```bash
# 用户级
rm -rf ~/.claude/skills/{学习信息注入,学习计划制定,理解批注,应用批注,出题,学习总结}

# 项目级
rm -rf ./.claude/skills/{学习信息注入,学习计划制定,理解批注,应用批注,出题,学习总结}
```

---

## 反馈

仓库 issue 区：https://github.com/HighTricker/learning-guide-skills/issues
