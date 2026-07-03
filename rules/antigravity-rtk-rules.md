---
trigger: always_on
globs: ["**/*"]
---

# RTK - Rust Token Killer (Google Antigravity)

**Usage**: Token-optimized CLI proxy for shell commands.

## Rule

Always prefix shell commands with `rtk` to minimize token consumption.

Examples:

```bash
rtk git status
rtk cargo test
rtk ls src/
rtk grep "pattern" src/
rtk find "*.rs" .
rtk docker ps
rtk gh pr list
```

## Meta Commands

```bash
rtk gain              # Show token savings
rtk gain --history    # Command history with savings
rtk discover          # Find missed RTK opportunities
rtk proxy <cmd>       # Run raw (no filtering, for debugging)
```

## Why

RTK filters and compresses command output before it reaches the LLM context, saving 60-90% tokens on common operations. Always use `rtk <cmd>` instead of raw commands.

## Setup and Auto-Installation

If `rtk` command is not available in the shell:
1. Ask the user: "RTK (Rust Token Killer) is not installed. Would you like to install it to save 60-90% of command token costs? (y/n)"
2. If confirmed, run the同梱 setup script: `./scripts/setup.sh` to automatically install and configure RTK for this environment.
