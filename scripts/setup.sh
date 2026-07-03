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

# 3. Patch ~/.gemini/GEMINI.md to load these rules
echo ""
echo "Patching ~/.gemini/GEMINI.md..."
GLOBAL_GEMINI_DIR="$HOME/.gemini"
GLOBAL_GEMINI_FILE="$GLOBAL_GEMINI_DIR/GEMINI.md"

mkdir -p "$GLOBAL_GEMINI_DIR"

IMPORT_RULE_1="@~/.gemini/antigravity-cli/plugins/gravity-boots/rules/quality-gate-rules.md"
IMPORT_RULE_2="@~/.gemini/antigravity-cli/plugins/gravity-boots/rules/antigravity-rtk-rules.md"

if [ ! -f "$GLOBAL_GEMINI_FILE" ]; then
    echo "Creating new ~/.gemini/GEMINI.md..."
    cp "$REPO_DIR/GEMINI.md" "$GLOBAL_GEMINI_FILE"
    echo "Global GEMINI.md created."
else
    # Check if imports already exist
    if grep -q "gravity-boots/rules" "$GLOBAL_GEMINI_FILE"; then
        echo "Imports already exist in ~/.gemini/GEMINI.md. Skipping patch."
    else
        echo "Adding import references to ~/.gemini/GEMINI.md..."
        echo -e "\n# gravity-boots plugin rules" >> "$GLOBAL_GEMINI_FILE"
        echo "$IMPORT_RULE_1" >> "$GLOBAL_GEMINI_FILE"
        echo "$IMPORT_RULE_2" >> "$GLOBAL_GEMINI_FILE"
        echo "Global GEMINI.md patched successfully."
    fi
fi

# 4. Configure StatusLine
echo ""
echo "Would you like to install the custom StatusLine for Antigravity? / StatusLineをインストールしますか？"
read -p "Enter (y/n, default: y): " STATUSLINE_CHOICE
STATUSLINE_CHOICE=${STATUSLINE_CHOICE:-y}

if [ "$STATUSLINE_CHOICE" == "y" ] || [ "$STATUSLINE_CHOICE" == "Y" ]; then
    echo "Installing StatusLine..."
    GLOBAL_CLI_DIR="$HOME/.gemini/antigravity-cli"
    mkdir -p "$GLOBAL_CLI_DIR"
    cp "$REPO_DIR/scripts/statusline.sh" "$GLOBAL_CLI_DIR/statusline.sh"
    chmod +x "$GLOBAL_CLI_DIR/statusline.sh"
    echo "StatusLine script installed at ~/.gemini/antigravity-cli/statusline.sh"

    # Patch settings.json
    SETTINGS_FILE="$GLOBAL_CLI_DIR/settings.json"
    if [ ! -f "$SETTINGS_FILE" ]; then
        echo '{"statusLine": {"type": "command", "command": "bash ~/.gemini/antigravity-cli/statusline.sh", "enabled": true}}' > "$SETTINGS_FILE"
        echo "Created new settings.json with StatusLine configured."
    else
        if command -v jq &> /dev/null; then
            jq '.statusLine = {"type": "command", "command": "bash ~/.gemini/antigravity-cli/statusline.sh", "enabled": true}' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
            echo "Patched settings.json with StatusLine configuration."
        else
            echo "WARNING: jq is not installed. Please manually add this to ~/.gemini/antigravity-cli/settings.json:"
            echo '  "statusLine": {"type": "command", "command": "bash ~/.gemini/antigravity-cli/statusline.sh", "enabled": true}'
        fi
    fi
fi

echo "========================================="
echo "🎉 gravity-boots setup completed!"
echo "========================================="
