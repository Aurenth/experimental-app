# Agent Instructions

> **Recovery**: Run `gt prime` after compaction, clear, or new session

## Gas Town Multi-Agent Environment

This workspace is part of a **Gas Town** multi-agent environment. You communicate with other agents via mailboxes and coordinate work through convoys and beads.

### Your Identity

- Run `gt whoami` to confirm your identity and role
- Run `gt prime` to get full context injected at session start

### Startup Protocol

1. Check your hook: `gt mol status`
2. If work is hooked → **EXECUTE** (no announcement, no waiting)
3. If hook empty → Check mail: `gt mail inbox`
4. Still nothing? Wait for user instructions

## The Propulsion Principle (GUPP)

**If you find work on your hook, YOU RUN IT.**

No confirmation. No waiting. No announcements. The hook having work IS the assignment.
This is physics, not politeness. Gas Town is a steam engine — you are a piston.

## Beads Workflow Integration

This project uses [beads](https://github.com/steveyegge/beads) for issue tracking. Issues live in `.beads/` and are tracked in git.

Two CLIs: **bd** (issue CRUD) and **bv** (graph-aware triage, read-only).

### bd: Issue Management

```bash
bd ready              # Unblocked issues ready to work
bd list --status=open # All open issues
bd show <id>          # Full details with dependencies
bd create --title="..." --type=task --priority=2
bd update <id> --status=in_progress
bd close <id>         # Mark complete
bd sync               # Sync with git
```

### bv: Graph Analysis (read-only)

**NEVER run bare `bv`** — it launches interactive TUI. Always use `--robot-*` flags:

```bash
bv --robot-triage     # Ranked picks, quick wins, blockers, health
bv --robot-next       # Single top pick + claim command
bv --robot-plan       # Parallel execution tracks
bv --robot-alerts     # Stale issues, cascades, mismatches
```

### Workflow

1. **Start**: `bd ready`
2. **Claim**: `bd update <id> --status=in_progress`
3. **Work**: Implement the task
4. **Complete**: `bd close <id>`
5. **Sync**: `bd sync` at session end

### Session Close Protocol

```bash
git status            # Check what changed
git add <files>       # Stage code changes
bd sync               # Commit beads changes
git commit -m "..."   # Commit code
bd sync               # Commit any new beads changes
git push              # Push to remote
```

## Gas Town Communication

```bash
gt mail inbox               # Check incoming messages
gt mail send <addr> "msg"   # Send a message
gt escalate -s HIGH "desc"  # Escalate a blocker
gt prime                    # Recover full context
gt mol status               # Check hooked work
gt done                     # Signal completion (polecats only)
```

## Key Concepts

- **Bead ID format**: `prefix-xxxxx` (e.g., `ea-abc12`) — prefix is `ea` for this rig
- **Priority**: P0=critical, P1=high, P2=medium, P3=low, P4=backlog
- **Types**: task, bug, feature, epic, question, docs
- **Work is not done until pushed** — always `git push` before saying done

<!-- beads-agent-instructions-v2 -->
<!-- gastown-agent-instructions-v1 -->
