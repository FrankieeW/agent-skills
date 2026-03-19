---
name: code-rules
description: Use when writing code, to follow personal code style and ensure documentation is consistent.
---

# Code Rules

Universal rules for all languages + index to language-specific guides.

## Tier 1: Essential (Universal)

**ALWAYS follow these. No exceptions.**

- **Format before commit**: Run the language-specific formatter
- **Type hints / annotations**: Required on all public functions
- **No magic**: No hidden side effects, no implicit behavior
- **Tests**: Write tests for new functionality
- **Docstrings**: On modules, classes, and public functions

## Pre-Commit Documentation Check

Before committing, verify if the changes require documentation updates:

1. **New skill added?** → Add to `README.md` → Available Skills table
2. **New file in skill directory?** → Check if skill's `SKILL.md` or `AGENTS.md` mentions it
3. **New language/feature?** → Update `languages/` index or tool reference
4. **File renamed/moved?** → Update all references in `README.md`, `AGENTS.md`, and skill docs
5. **CLI command added?** → Update tool quick reference

If documentation needs updating → update first, then commit all together.

## Language Index

| Language | Guide File | Key Tools |
|----------|------------|-----------|
| Python | `languages/python.md` | uv, ruff, pytest |
| Lean | `languages/lean.md` | lake, mathlib style |

## Tier 2: Project Structure

```
Python:
my_project/
├── pyproject.toml
├── src/
│   └── my_project/
└── tests/

Lean:
MyProject/
├── src/
│   └── MyProject/
└── Test/
    └── MyProject.lean
```

## Tier 3: Tool Quick Reference

| Language | Format | Lint | Test | Run |
|----------|--------|------|------|-----|
| Python | `uv run ruff format` | `uv run ruff check` | `uv run pytest` | `uv run python` |
| Lean | `lake build` | — | `lake runtests` | `lake run` |

## Common Mistakes (All Languages)

- ❌ Skipping format/lint before commit
- ❌ Missing type annotations on public APIs
- ❌ No docstrings on modules and classes
- ❌ Writing code before writing tests
- ❌ Committing without checking if docs need updating
