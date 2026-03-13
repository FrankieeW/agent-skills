---
name: tmux
description: >
  Terminal multiplexer patterns for controlling interactive applications. Use when: running interactive REPLs (python, node), debugging with gdb/lldb, running dev servers, working with vim/git rebase, or monitoring Claude Code sessions.
---

# tmux Skill

## Overview

Use tmux to control interactive terminal applications by sending keystrokes and capturing output. This skill provides patterns for managing REPLs, dev servers, debuggers, and Claude Code sessions.

## When to Use

**Use tmux when:**
- Running interactive REPLs (python, node, psql)
- Debugging with gdb/lldb
- Running dev servers and file watchers
- Interactive CLI tools (vim, git rebase -i)
- Claude Code session monitoring
- Any process requiring TTY interaction

**Don't use for:**
- Simple one-shot commands (<10s)
- Non-interactive scripts
- Commands with stdin redirection

## Core Pattern

```bash
# Create detached session with interactive shell
tmux new-session -d -s "$SESSION" -n main

# Send commands (use send-keys, not inline command)
tmux send-keys -t "$SESSION:main" 'python3 -i' Enter

# Capture output
tmux capture-pane -t "$SESSION" -p

# Wait for prompt (poll)
for i in {1..30}; do
  output=$(tmux capture-pane -t "$SESSION" -p)
  if echo "$output" | grep -q ">>>"; then break; fi
  sleep 0.5
done

# Cleanup
tmux kill-session -t "$SESSION"
```

## Session Naming Convention

Always derive session name from the project:

```bash
SESSION=$(basename $(git rev-parse --show-toplevel 2>/dev/null) || basename "$PWD")
```

## Idempotent Process Start

**Always check before creating sessions:**

```bash
SESSION=$(basename $(git rev-parse --show-toplevel 2>/dev/null) || basename "$PWD")

# Create session only if it doesn't exist
if ! tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux new-session -d -s "$SESSION" -n main
  tmux send-keys -t "$SESSION:main" '<command>' Enter
else
  echo "Session $SESSION already exists"
fi
```

## Multiple Processes (Windows)

For multiple processes in one project, use **windows** not separate sessions:

```bash
SESSION=$(basename $(git rev-parse --show-toplevel 2>/dev/null) || basename "$PWD")

# Create session if needed
if ! tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux new-session -d -s "$SESSION" -n server
  tmux send-keys -t "$SESSION:server" 'npm run dev' Enter
fi

# Add window if it doesn't exist
if ! tmux list-windows -t "$SESSION" -F '#{window_name}' | grep -q "^tests$"; then
  tmux new-window -t "$SESSION" -n tests
  tmux send-keys -t "$SESSION:tests" 'npm run test:watch' Enter
fi
```

## Common Commands

### Session Management
```bash
# List sessions
tmux list-sessions
tmux ls

# Check if session exists
tmux has-session -t "$SESSION" 2>/dev/null

# Kill session (only this project's session)
tmux kill-session -t "$SESSION"

# Kill specific window
tmux kill-window -t "$SESSION:tests"

# Never use: tmux kill-server (kills ALL sessions)
```

### Sending Input
```bash
# Send text + Enter
tmux send-keys -t "$SESSION" 'y' Enter

# Send text without Enter
tmux send-keys -t "$SESSION" -l -- 'some text'

# Send special keys
tmux send-keys -t "$SESSION" Enter
tmux send-keys -t "$SESSION" Escape
tmux send-keys -t "$SESSION" C-c          # Ctrl+C
tmux send-keys -t "$SESSION" C-d          # Ctrl+D (EOF)
tmux send-keys -t "$SESSION" C-z          # Ctrl+Z (suspend)
tmux send-keys -t "$SESSION" Space
tmux send-keys -t "$SESSION" BSpace       # Backspace

# For Claude Code prompts, split Enter to avoid paste issues
tmux send-keys -t "$SESSION" -l -- 'text to send'
sleep 0.1
tmux send-keys -t "$SESSION" Enter
```

### Capture Output
```bash
# Last 20 lines of pane
tmux capture-pane -t "$SESSION" -p | tail -20

# Entire scrollback
tmux capture-pane -t "$SESSION" -p -S -

# Specific pane in window
tmux capture-pane -t "$SESSION:0.0" -p
```

### Window/Pane Navigation
```bash
# Select window
tmux select-window -t "$SESSION:0"

# Select pane
tmux select-pane -t "$SESSION:0.1"

# List windows
tmux list-windows -t "$SESSION"

# Rename session
tmux rename-session -t old new
```

## Interactive Shell Requirement

**Use send-keys pattern** for reliable shell initialization:

```bash
# WRONG - inline command bypasses shell init, breaks PATH/direnv
tmux new-session -d -s "$SESSION" -n main 'npm run dev'

# CORRECT - create session, then send command to interactive shell
tmux new-session -d -s "$SESSION" -n main
tmux send-keys -t "$SESSION:main" 'npm run dev' Enter
```

## Common Patterns

### Python REPL
```bash
tmux new-session -d -s python python3 -i
tmux send-keys -t python 'import math' Enter
tmux send-keys -t python 'print(math.pi)' Enter
tmux capture-pane -t python -p
tmux kill-session -t python
```

### Debugging with lldb
```bash
tmux new-session -d -s lldb 'lldb ./a.out'
tmux send-keys -t lldb 'set pagination off' Enter
# break with C-c, issue bt, info locals
tmux send-keys -t lldb 'bt' Enter
tmux send-keys -t lldb 'quit' Enter
```

### Vim Editing
```bash
tmux new-session -d -s vim vim /tmp/file.txt
sleep 0.3
tmux send-keys -t vim 'i' 'Hello World' Escape ':wq' Enter
```

### Interactive Git Rebase
```bash
tmux new-session -d -s rebase -c /repo/path 'git rebase -i HEAD~3'
sleep 0.5
tmux capture-pane -t rebase -p
tmux send-keys -t rebase 'Down' 'squash' Escape
tmux send-keys -t rebase ':wq' Enter
```

## Checking Process Status

```bash
# Check session exists
tmux has-session -t "$SESSION" 2>/dev/null && echo "exists" || echo "none"

# List windows and their commands
tmux list-windows -t "$SESSION" -F '#{window_name}: #{pane_current_command}'

# Check for specific window
tmux list-windows -t "$SESSION" -F '#{window_name}' | grep -q "^server$"

# Check for ready indicators
tmux capture-pane -p -t "$SESSION:server" -S -50 | rg -i "listening|ready|started"

# Check for errors
tmux capture-pane -p -t "$SESSION" -S -100 | rg -i "error|fail|exception"
```

## Claude Code Session Patterns

### Check if Session Needs Input
```bash
tmux capture-pane -t worker-3 -p | tail -10 | grep -E "❯|Yes.*No|proceed|permission"
```

### Approve Claude Code Prompt
```bash
tmux send-keys -t worker-3 'y' Enter
# Or select numbered option
tmux send-keys -t worker-3 '2' Enter
```

### Check All Sessions
```bash
for s in shared worker-2 worker-3 worker-4; do
  echo "=== $s ==="
  tmux capture-pane -t $s -p 2>/dev/null | tail -5
done
```

## Restarting a Process
```bash
# Send Ctrl+C then restart
tmux send-keys -t "$SESSION:server" C-c
sleep 1
tmux send-keys -t "$SESSION:server" 'npm run dev' Enter
```

## Common Mistakes

### Not Waiting After Session Start
```bash
# Problem: Capturing immediately shows blank
tmux new-session -d -s sess command
tmux capture-pane -t sess -p  # Too early!

# Fix: Add brief sleep
tmux new-session -d -s sess command
sleep 0.3
tmux capture-pane -t sess -p
```

### Forgetting Enter Key
```bash
# Problem: Command typed but not executed
tmux send-keys -t sess 'print("hello")'  # Missing Enter!

# Fix: Add Enter
tmux send-keys -t sess 'print("hello")' Enter
```

### Using Wrong Key Names
```bash
# Problem: \n doesn't work
tmux send-keys -t sess 'text\n'

# Fix: Use tmux key names
tmux send-keys -t sess 'text' Enter
```

### Not Cleaning Up Sessions
```bash
# Fix: Always kill when done
tmux kill-session -t session_name

# Or check first
tmux has-session -t name 2>/dev/null && tmux kill-session -t name
```

## Wait for Ready Pattern

```bash
for i in {1..30}; do
  if tmux capture-pane -p -t "$SESSION:server" -S -20 | rg -q "listening|ready"; then
    echo "Server ready"
    break
  fi
  sleep 1
done
```

## When to Use tmux

| Scenario | Use tmux? |
|----------|-----------|
| Dev server (`npm run dev`, `rails s`) | Yes |
| File watcher (`npm run watch`) | Yes |
| Test watcher (`npm run test:watch`) | Yes |
| Database server | Yes |
| `tilt up` | Yes |
| One-shot build (`npm run build`) | No |
| Quick command (<10s) | No |
| Need stdout in conversation | No |

## Isolation Rules

- **Never** use `tmux kill-server`
- **Never** kill sessions not matching current project
- **Always** derive session name from git root or pwd
- **Always** verify session name before kill operations
- Other Claude Code instances may have their own sessions

## User Notification

After starting a session, ALWAYS tell the user:

```
To monitor: tmux attach -t $SESSION
To capture: tmux capture-pane -t $SESSION -p
To stop: tmux kill-session -t $SESSION
```
