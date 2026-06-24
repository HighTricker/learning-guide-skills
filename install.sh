#!/bin/bash
# 学习指导 Skills 包 — 一行命令安装脚本
#
# 远程安装（curl pipe bash）：
#   curl -sL https://raw.githubusercontent.com/HighTricker/learning-guide-skills/main/install.sh | bash
#
# 本地安装（已 git clone 后在仓库目录运行）：
#   bash install.sh                # 交互式
#   bash install.sh --user         # 安装到 ~/.claude/skills/
#   bash install.sh --project      # 安装到 ./.claude/skills/

set -e

REPO_URL="${LEARN_SKILLS_REPO:-https://github.com/HighTricker/learning-guide-skills.git}"
SKILLS=("学习信息注入" "学习计划制定" "理解批注" "应用批注" "出题" "学习总结")

echo "=== 学习指导 Skills 包 安装脚本 ==="
echo ""

# ---------- 1. 解析命令行参数 ----------
INSTALL_MODE=""
case "${1:-}" in
    --user)    INSTALL_MODE="user" ;;
    --project) INSTALL_MODE="project" ;;
    --help|-h)
        echo "用法: bash install.sh [--user|--project]"
        echo "  --user     安装到用户级 ~/.claude/skills/（所有目录都能用）"
        echo "  --project  安装到项目级 ./.claude/skills/（仅当前目录可用）"
        echo "  无参数     交互式选择"
        exit 0
        ;;
esac

# ---------- 2. 检测源文件位置（本地 or 远程） ----------
CLEANUP_TMP=false
if [ -d "./skills" ] && [ -d "./skills/学习信息注入" ]; then
    SOURCE_DIR="./skills"
    echo "📁 检测到本地 skills/，使用本地文件"
else
    if ! command -v git >/dev/null 2>&1; then
        echo "❌ 未检测到 git。请先安装 git，或 git clone 后在仓库目录运行 bash install.sh"
        exit 1
    fi
    TMP_DIR=$(mktemp -d)
    CLEANUP_TMP=true
    echo "📥 远程模式，正在 clone $REPO_URL ..."
    if ! git clone --depth 1 --quiet "$REPO_URL" "$TMP_DIR" 2>/dev/null; then
        echo "❌ git clone 失败。请检查 REPO_URL 是否正确，或网络是否通畅。"
        echo "   当前 URL: $REPO_URL"
        rm -rf "$TMP_DIR"
        exit 1
    fi
    SOURCE_DIR="$TMP_DIR/skills"
fi

# ---------- 3. 交互式选择安装位置（如果没指定参数） ----------
if [ -z "$INSTALL_MODE" ]; then
    echo ""
    echo "请选择安装位置："
    echo "  1) 用户级 ~/.claude/skills/（推荐，所有 Claude Code 会话都能用）"
    echo "  2) 项目级 ./.claude/skills/（仅当前目录的 Claude Code 会话可用）"

    # 从 /dev/tty 读取以兼容 curl pipe bash 模式
    if [ -t 0 ]; then
        read -p "输入 1 或 2: " choice
    else
        read -p "输入 1 或 2: " choice </dev/tty
    fi

    case "$choice" in
        1) INSTALL_MODE="user" ;;
        2) INSTALL_MODE="project" ;;
        *)
            echo "❌ 无效选择: $choice"
            [ "$CLEANUP_TMP" = "true" ] && rm -rf "$TMP_DIR"
            exit 1
            ;;
    esac
fi

# ---------- 4. 确定目标路径 ----------
case "$INSTALL_MODE" in
    user)    TARGET="$HOME/.claude/skills" ;;
    project) TARGET="./.claude/skills" ;;
esac

mkdir -p "$TARGET"
echo ""
echo "📁 安装到: $TARGET"
echo ""

# ---------- 5. 复制 6 个 skill ----------
INSTALLED=0
SKIPPED=0
for skill in "${SKILLS[@]}"; do
    if [ ! -d "$SOURCE_DIR/$skill" ]; then
        echo "  ❌ 源文件未找到: $skill（跳过）"
        SKIPPED=$((SKIPPED + 1))
        continue
    fi

    if [ -d "$TARGET/$skill" ]; then
        if [ -t 0 ]; then
            read -p "  ⚠️  $skill 已存在，覆盖？[y/N]: " overwrite
        else
            read -p "  ⚠️  $skill 已存在，覆盖？[y/N]: " overwrite </dev/tty
        fi
        if [ "$overwrite" != "y" ] && [ "$overwrite" != "Y" ]; then
            echo "  ⊘ 跳过 $skill"
            SKIPPED=$((SKIPPED + 1))
            continue
        fi
        rm -rf "$TARGET/$skill"
    fi

    cp -r "$SOURCE_DIR/$skill" "$TARGET/"
    echo "  ✓ $skill"
    INSTALLED=$((INSTALLED + 1))
done

# ---------- 6. 清理临时目录 ----------
if [ "$CLEANUP_TMP" = "true" ]; then
    rm -rf "$TMP_DIR"
fi

# ---------- 7. 结果汇报 ----------
echo ""
echo "✅ 安装完成！已安装 $INSTALLED 个 skill，跳过 $SKIPPED 个。"
echo ""
echo "下一步："
echo "  1. 新开一个 Claude Code 终端窗口（让框架重新扫描 skills）"
echo "  2. cd 到你的学习项目目录"
echo "  3. 运行 /学习信息注入 开始第一步"
echo "  4. 详细使用流程见 README.md"
echo ""
