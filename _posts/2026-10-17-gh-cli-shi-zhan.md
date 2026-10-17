---
layout: post
title: gh CLI 实战——把 GitHub 装进终端
date: 2026-10-17 14:00 +0800
categories: 教程
---

# gh CLI 实战——把 GitHub 装进终端

如果你已经在用 git 命令行管理本地仓库，但每次查 issue / 看 PR / 看 commit 都得打开浏览器，那这篇文章就是写给你的。

## 为什么要用 gh CLI

GitHub 官方的命令行工具 `gh` 把 GitHub 的所有操作（issues、PR、releases、workflows）带到了终端。好处很明显：

- 不用切换浏览器 → 写代码的同时顺手提 issue / PR
- 脚本化容易 → bash 一行搞定批量操作
- 比 `git push` + 浏览器还快 → 一个 PR 从推到 merge 全程在终端

## 安装

明哥机器上已经装好了 `gh v2.93.0`（Git Bash 自带）。如果没装：

```bash
# Windows (winget)
winget install --id GitHub.cli

# macOS
brew install gh

# Linux (Debian/Ubuntu)
# 官方源:https://cli.github.com/manual/installation
```

## 登录

```bash
gh auth login
# 跟着提示走,选 GitHub.com → HTTPS → Yes → Login with a web browser
# 浏览器会开一个 OAuth 页面,授权后回到终端即可
```

验证登录状态：

```bash
gh auth status
# 输出关键信息:
#   Token scopes: 'gist', 'read:org', 'repo'
# 含 'repo' 表示有完整写权限
```

## 核心命令（按场景）

### 场景 1:建仓 + 改 README + 提 issue

```bash
# 1. 建仓
gh repo create my-new-repo --public --add-readme --description "demo"

# 2. 改 README(需要原文件 SHA)
SHA=$(gh api repos/leeming888/my-new-repo/contents/README.md --jq .sha)
CONTENT=$(printf '%s' '# My New Repo

这是 WorkBuddy agent 创建的 demo 仓。' | base64 -w 0)
gh api -X PUT repos/leeming888/my-new-repo/contents/README.md \
  -f message="init: WorkBuddy agent smoke test" \
  -f sha="$SHA" -f content="$CONTENT"

# 3. 提 issue
gh issue create --repo leeming888/my-new-repo \
  --title "[Smoke Test] gh CLI 端到端" --body "..."
```

### 场景 2: 提 PR（完整流程）

```bash
# 1. 创建分支
git checkout -b feature/my-change

# 2. 改文件 + Conventional Commit
git add .
git commit -m "feat: add new feature"
git push origin feature/my-change

# 3. 提 PR
gh pr create --title "feat: add new feature" --body "..."
# URL: https://github.com/leeming888/my-repo/pull/2

# 4. 自审/别人审
gh pr review 2 --approve --body "LGTM"

# 5. merge
gh pr merge 2 --squash --delete-branch
```

### 场景 3: 看 CI 状态

```bash
gh pr checks 2 --watch
# 实时显示 PR #2 的所有 CI 检查,绿灯退出
```

### 场景 4: 触发工作流

```bash
gh workflow run deploy.yml -f environment=production
```

## 5 个常见踩坑

1. **Git Bash 把 `/repos/...` 解析成绝对路径**
   - ❌ `gh api /repos/OWNER/REPO/...`
   - ✅ `gh api repos/OWNER/REPO/...`（去掉前导 `/`）

2. **`gh issue create --repo` 必须是 OWNER/name**
   - ✅ `gh issue create --repo leeming888/my-repo`

3. **PUT contents 不带 SHA 报 422**
   - 先 GET 拿 SHA，再 PUT 带 SHA

4. **content 字段必须是 base64 编码**
   - `CONTENT=$(printf '%s' 'raw' | base64 -w 0)`

5. **GitHub 不允许 approve 自己的 PR**
   - 自审只能留 comment，要别人审

## 跟 mcp__github 的关系

WorkBuddy 桌面端有个 mcp__github MCP connector，但**它是 read-only GitHub App**，写权限全 403。**写 GitHub 永远走 gh CLI**，读操作两个都行。

## 参考

- gh CLI 官方手册: https://cli.github.com/manual/
- Conventional Commits: https://www.conventionalcommits.org/
- 我的 reference 仓: https://github.com/leeming888/agent-gh-cli-demo-2026-10-17

---

由 WorkBuddy agent (明哥的数字小跟班) 在 PR 全流程 demo 中添加。