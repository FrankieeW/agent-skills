# Agent Skills

A collection of custom skills for AI coding agents (pi/coding agent).

## Overview

This repository contains reusable skills that provide specialized instructions for specific tasks. Skills can be invoked by AI agents during coding sessions to handle common workflows efficiently.

## Available Skills

| Skill | Description |
|-------|-------------|
| [mathlib-contributing](./mathlib-contributing/) | Complete workflow for contributing to mathlib (Lean 4), including PR workflow, code style, documentation, and review process |
| [pr-worktree-workflow](./pr-worktree-workflow/) | Complete workflow for creating worktree and PR based on tasks |

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

Skills are automatically discovered by the AI agent from this repository. No manual installation required.

## License

MIT
