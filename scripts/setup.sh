#!/bin/bash

# gravity-boots RTK & Language Setup Script

echo "========================================="
echo "🥾 gravity-boots Initial Setup"
echo "========================================="

# 1. RTK Installation Check
echo "Checking RTK environment..."
if command -v rtk &> /dev/null; then
    echo "RTK is already installed."
else
    echo "RTK not found. Starting installation..."
    
    # Check OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            echo "Installing RTK via Homebrew..."
            brew install rtk
        else
            echo "Installing RTK via raw shell script..."
            curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        echo "Installing RTK via raw shell script..."
        curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
    else
        echo "Unsupported OS. Please install RTK manually: https://github.com/rtk-ai/rtk"
        exit 1
    fi
fi

# Configure RTK for Google Antigravity
if command -v rtk &> /dev/null; then
    echo "Configuring RTK for Antigravity..."
    rtk init --agent antigravity --auto-patch
else
    echo "RTK installation failed or not found in PATH."
    exit 1
fi

# 2. Select Language Mode
echo ""
echo "Select Terse Mode language / 言語モードを選択してください:"
echo "1: Japanese (Genshijin / 原始人 + Quality Gates)"
echo "2: English (Caveman + Quality Gates)"
read -p "Enter number (1 or 2): " LANG_CHOICE

# Get script parent directory to resolve absolute paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Frontmatter template to inject
FRONTMATTER=$(cat <<EOF
---
trigger: always_on
globs: ["**/*"]
---

EOF
)

# Output rules path
RULES_OUT="$REPO_DIR/rules/quality-gate-rules.md"

if [ "$LANG_CHOICE" == "1" ]; then
    echo "Activating Japanese (Genshijin) mode..."
    echo "$FRONTMATTER" > "$RULES_OUT"
    cat "$REPO_DIR/rules/templates/quality-gate-rules-ja.md" >> "$RULES_OUT"
    echo "Japanese rules activated at rules/quality-gate-rules.md"
elif [ "$LANG_CHOICE" == "2" ]; then
    echo "Activating English (Caveman) mode..."
    echo "$FRONTMATTER" > "$RULES_OUT"
    cat "$REPO_DIR/rules/templates/quality-gate-rules-en.md" >> "$RULES_OUT"
    echo "English rules activated at rules/quality-gate-rules.md"
else
    echo "Invalid choice. Defaulting to English (Caveman) mode..."
    echo "$FRONTMATTER" > "$RULES_OUT"
    cat "$REPO_DIR/rules/templates/quality-gate-rules-en.md" >> "$RULES_OUT"
    echo "English rules activated at rules/quality-gate-rules.md"
fi

echo "========================================="
echo "🎉 gravity-boots setup completed!"
echo "========================================="
