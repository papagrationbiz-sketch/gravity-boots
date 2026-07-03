#!/bin/bash

# gravity-boots RTK auto-setup script

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
    echo "RTK configuration completed successfully."
else
    echo "RTK installation failed or not found in PATH."
    exit 1
fi
