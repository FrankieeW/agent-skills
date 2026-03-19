# AGENTS.md

Guidelines for working with this skill repository.

## Overview

This repository stores AI coding agent skills — markdown files with YAML frontmatter. Not a traditional app codebase.

## Structure

```
./
├── README.md                      # Skill catalog
├── AGENTS.md                      # This file
├── CLAUDE.md                      # Claude Code config
├── code-rules/                    # Universal coding rules
│   ├── SKILL.md
│   └── languages/
├── pre-init/                      # Project scaffolding
│   ├── SKILL.md
│   ├── init.sh
│   └── templates/{python,lean4}/
├── mathlib-style/                 # Lean style guide
├── mathlib-workflow/              # Lean contribution
├── tmux/, ssh/, lmfdb-cli/        # Utility skills
└── openclaw-rss/
```

## Where to Look

| Task | Location |
|------|----------|
| New skill development | Create `*/SKILL.md` with frontmatter |
| Lean 4 work | `mathlib-style/`, `mathlib-workflow/` |
| Python project setup | `pre-init/templates/python/` |
| Git worktree + PR | `pr-worktree-workflow/SKILL.md` |
| Coding standards | `code-rules/SKILL.md` |

## Conventions

- Skill names: `kebab-case`
- SKILL.md frontmatter: `name` + `description` fields required
- Descriptions: English, concise, include "Use when:" triggers
- Examples: Practical, runnable

## Anti-Patterns

- ❌ Killing tmux sessions outside current project
- ❌ Using `$` instead of `<|` in Lean
- ❌ `fun x ↦ x` instead of `fun x => x` in Lean
- ❌ Empty lines inside Lean declarations
- ❌ Committing without checking if docs need updating

## Git Workflow

Use `pr-worktree-workflow` skill for changes to this repo:

```bash
gh pr create --fill
```

## Pre-Commit Check

Before committing code-rules or any skill:
1. Add something new → Is it documented?
2. Remove/rename → Old refs cleaned?
3. Change behavior → Docs updated?
4. Add dependencies → Recorded?
5. Add code needing docstring → Written?

## Notes

- Templates in `pre-init/templates/` are defaults; users override via `~/.config/pre-init/`
- All skill directories are self-contained
- No build step — skills are markdown files discovered by the agent
