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

Before committing, ask yourself:

1. **Did I add something new?** (feature, file, module, command) → Is it documented?
2. **Did I remove or rename something?** → Are old references cleaned up?
3. **Did I change behavior?** (API, output, flags) → Are docs updated?
4. **Did I add dependencies?** → Are they recorded? (requirements, package.json, etc.)
5. **Did I add code that needs a docstring?** → Did I write it?

If any answer is "needs update" → update docs first, then commit everything together.

## Language Index
PLEASE FOLLOW THE LANGUAGE-SPECIFIC GUIDES FOR EACH LANGUAGE YOU USE. They contain important style rules and tool recommendations.
| Language | Guide File | Key Tools |
|----------|------------|-----------|
| Python | `languages/python.md` | uv, ruff, pytest |
| Lean | `languages/lean.md` | lake, mathlib style |

## Common Mistakes (All Languages)

- ❌ Skipping format/lint before commit
- ❌ Missing type annotations on public APIs
- ❌ No docstrings on modules and classes
- ❌ Writing code before writing tests
- ❌ Committing without checking if docs need updating
