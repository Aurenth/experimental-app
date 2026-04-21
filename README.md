# experimental-app

Experimental application managed by [Gas Town](https://github.com/gastownhall/gastown) multi-agent orchestration.

## Overview

This repository is configured as a Gas Town **rig** — a project container for coordinating AI coding agents (Claude Code, Codex, Copilot, etc.) with persistent work tracking.

## Gas Town Setup

### Prerequisites

- Go 1.24+
- Git 2.20+
- Dolt 1.82.4+
- beads (bd) 0.55.4+
- tmux 3.0+ (recommended)
- Claude Code CLI 2.0.20+

### Install Gas Town

```bash
# Via Homebrew (macOS)
brew install gastown

# Or build from source
git clone https://github.com/steveyegge/gastown.git && cd gastown
make build && mv gt $HOME/go/bin/
```

### Initialize Workspace

```bash
gt install ~/gt --git
cd ~/gt

# Add this project as a rig
gt rig add experimental-app https://github.com/Aurenth/experimental-app.git

# Create your crew workspace
gt crew add yourname --rig experimental-app
cd experimental-app/crew/yourname

# Start the Mayor
gt mayor attach
```

### Docker Compose

```bash
export GIT_USER="<your name>"
export GIT_EMAIL="<your email>"
export FOLDER="/Users/you/code"

docker compose build
docker compose up -d
docker compose exec gastown zsh

gt up
gt mayor attach
```

## Key Commands

```bash
gt mayor attach          # Start Mayor coordinator
gt agents                # List active agents
gt convoy list           # Track work progress
gt feed                  # Real-time activity dashboard
gt dashboard             # Web dashboard (localhost:8080)
```

## Project Structure

```
experimental-app/
├── CLAUDE.md            # Agent instructions (Gas Town)
├── AGENTS.md            # Compatibility alias for CLAUDE.md
├── settings/
│   └── config.json      # Gas Town runtime configuration
├── .claude/
│   └── settings.json    # Claude Code hooks
└── .beads/
    └── PRIME.md         # Worker context
```

## Documentation

- [Gas Town README](https://github.com/gastownhall/gastown)
- [Installation Guide](https://github.com/gastownhall/gastown/blob/main/docs/INSTALLING.md)
- [Hooks Reference](https://github.com/gastownhall/gastown/blob/main/docs/HOOKS.md)
