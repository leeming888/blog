#!/bin/bash
# 小明（⚡）在线安装器 — 面向新版 OpenClaw
# 用法: 直接在新 OpenClaw 的聊天里说：
#   "帮我执行 https://raw.githubusercontent.com/leeming888/blog/main/install-xiaoming.sh"
#  或者把本文件丢给 OpenClaw 让它跑
# ============================================================

set -e

echo "⚡ 正在安装小明（⚡）..."
echo ""

# 1. 检查 OpenClaw
if ! command -v openclaw &>/dev/null; then
  echo "❌ 未检测到 OpenClaw"
  echo "请先安装: npm install -g openclaw"
  exit 1
fi

# 2. 从 GitHub Releases 下载完整包
echo "📥 下载小明数据包..."
RELEASE_URL="https://github.com/leeming888/blog/releases/download/v1.0-bootstrap/bootstrap-xiaoming.sh"
curl -L -o /tmp/bootstrap-xiaoming.sh "$RELEASE_URL" 2>&1

if [ ! -f /tmp/bootstrap-xiaoming.sh ] || [ $(wc -c < /tmp/bootstrap-xiaoming.sh) -lt 1000 ]; then
  echo "❌ 下载失败，请检查网络"
  exit 1
fi

echo "✅ 下载完成 ($(du -h /tmp/bootstrap-xiaoming.sh | cut -f1))"

# 3. 运行安装
echo ""
echo "🚀 开始安装..."
bash /tmp/bootstrap-xiaoming.sh

# 4. 清理
rm -f /tmp/bootstrap-xiaoming.sh

echo ""
echo "🎉 安装完成！请编辑 secrets.env 填入 API Key"
