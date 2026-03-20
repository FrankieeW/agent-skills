---
name: ccswitch
description: Manage CC Switch providers for Claude Code and OpenCode from AI agents. Switch providers, list configurations, and check health status.
---

# CC Switch Provider Management

Use `ccswitch-cli` to manage AI provider configurations for Claude Code and OpenCode when working in SSH environments.

## Installation

```bash
# Install CLI
brew tap FrankieeW/homebrew-tap && brew install ccswitch-cli

# Install skill for AI agents
npx -g skills add https://github.com/FrankieeW/agent-skills
```

## Usage

### CLI Commands

```bash
# List available providers
ccswitch-cli list claude
ccswitch-cli list opencode

# Switch provider (dry-run first)
ccswitch-cli switch claude --provider openrouter --dry-run

# Apply switch
ccswitch-cli switch claude --provider openrouter

# Show current configuration
ccswitch-cli current claude

# Check provider health
ccswitch-cli health claude
```

### AI Mode

For AI agents, use XML output mode for better parsing:

```bash
ccswitch-cli --ai list claude
ccswitch-cli --ai switch claude --provider openrouter --dry-run
```

## Supported Apps

| App | Description |
|-----|-------------|
| `claude` | Claude Code (Anthropic) |
| `opencode` | OpenCode |

## Provider Switching Workflow

1. List available providers: `ccswitch-cli list <app>`
2. Preview changes with `--dry-run`
3. Apply with `ccswitch-cli switch <app> --provider <id>`

## Examples

### Switching to OpenRouter for Claude Code

```bash
# Check current
ccswitch-cli --ai current claude

# Preview switch
ccswitch-cli --ai switch claude --provider openrouter --dry-run

# Apply
ccswitch-cli --ai switch claude --provider openrouter
```

### Checking Health Status

```bash
ccswitch-cli --ai health claude
```

## Database

The CLI reads from CC Switch's SQLite database at `~/.cc-switch/cc-switch.db`.