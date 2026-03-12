# Agent Skills

A collection of custom skills for AI coding agents (pi/coding agent).

## Overview

This repository contains reusable skills that provide specialized instructions for specific tasks. Skills can be invoked by AI agents during coding sessions to handle common workflows efficiently.

## Available Skills

| Skill | Description |
|-------|-------------|
| [mathlib-workflow](./mathlib-workflow/) | Contribution workflow for mathlib (Lean 4) - setup, git workflow, PR conventions, and review process |
| [mathlib-style](./mathlib-style/) | Code style guide for mathlib (Lean 4) - naming conventions, formatting, and documentation |
| [pr-worktree-workflow](./pr-worktree-workflow/) | Complete workflow for creating worktree and PR based on tasks |
| [lmfdb-cli](./lmfdb-cli/) | Query LMFDB to verify number field properties, elliptic curve data, and algebraic number theory results |

## Adding New Skills

1. Create a new directory for the skill
2. Add `SKILL.md` with the skill definition
3. Include:
   - `name`: Skill identifier
   - `description`: When to use this skill
   - Full documentation in Markdown

## Skill Structure

```markdown
---
name: skill-name
description: >
  What the skill does. Use when: specific triggers.
---

# Skill Title

## Overview
## Usage
## Examples
```

## Installation

### Global Installation (for all agents)
```bash
npx -g skills add FrankieeW/agent-skills
```

### Project Installation
```bash
npx skills add FrankieeW/agent-skills
```

### List Available Skills
```bash
npx skills add FrankieeW/agent-skills --list
```

Skills are automatically discovered by the AI agent from this repository.

## License

MIT
