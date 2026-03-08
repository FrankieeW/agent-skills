---
name: mathlib-contributing
description: >
  Complete workflow for contributing to mathlib (Lean 4). Use when: creating PRs to leanprover-community/mathlib4, submitting theorems/lemmas, fixing bugs, or requesting reviews.
---

# Contributing to mathlib

A comprehensive guide for contributing to mathlib4, the standard library for Lean 4.

## Quick Start

### One-time Setup

```bash
# Fork and clone using GitHub CLI (recommended)
gh repo fork leanprover-community/mathlib4 --default-branch-only --clone
cd mathlib4

# Or manually:
# 1. Fork on GitHub
# 2. Clone your fork: git clone https://github.com/YOUR_USERNAME/mathlib4.git
# 3. Add upstream: git remote add upstream https://github.com/leanprover-community/mathlib4.git
```

### Daily Workflow

```bash
# Update master
git switch master
git pull

# Create feature branch
git switch -c my-feature-branch

# Make changes, commit, push
git add .
git commit -m "feat: add theorem X"
git push

# Open PR on GitHub or via CLI
gh pr create --fill
```

## What to Contribute

### Welcome Contributions
- **Small fixes**: docstring fixes, typo corrections
- **Single lemma additions**: to existing theories
- **Extended theories**: new theorems extending existing areas
- **New theories**: if within mathlib's scope

### Scope Check
Ask before contributing new theories:
1. Is this typically taught in a mathematics department?
2. Does it align with maintainers' mathematical interests?
3. Can you find a reviewer?

If unsure, ask on [Zulip](https://leanprover.zulipchat.com/) in `#mathlib`.

### External Projects
Consider creating a standalone repository with mathlib as a dependency if your work is outside scope.

## Essential Guidelines

### Communication
- Use [Zulip](https://leanprover.zulipchat.com/) to discuss before and during work
- Add GitHub username to Zulip profile
- Set display name to real name

### Required Guidelines
Follow these three key guides:
1. **[Style Guide](https://leanprover-community.github.io/contribute/style.html)** - Code formatting
2. **[Naming Conventions](https://leanprover-community.github.io/contribute/naming.html)** - Naming scheme
3. **[Documentation](https://leanprover-community.github.io/contribute/doc.html)** - Doc requirements

## Code Style

### File Organization
```lean
/-!
# Module Title

Summary of what this file contains.
-/

import Mathlib.Algebra.Group.Basic
-- other imports

-- definitions and theorems
```

### Key Style Rules

#### Capitalization
- **Props/Types**: `UpperCamelCase` (e.g., `Group`, `Ring`)
- **Theorems/Proofs**: `snake_case` (e.g., `group_eq_of_eq`)
- **Functions**: Same as return type
- **Fields/Constructors**: Follow same rules

#### Tactic Mode
```lean
theorem example [Group G] (a b : G) : a * b = b * a := by
  apply comm_monoid_to_comm_group
  infer_instance
```

- `by` goes at end of preceding line, not its own line
- Indent within tactic blocks
- Use focusing dot `·` for subgoals (insert as `\.`)

#### Whitespace
- No `$` - use `<|` or`|>` instead
- Space after `←` in `rw [← lemma]`
- No empty lines inside declarations

#### Simp
- Don't squeeze terminal `simp` calls
- Squeezed simp breaks on lemma renames

#### Transparency
- Default: `semireducible`
- Use `@[reducible]` for definitions that should unfold
- Use structures (not `irreducible`) for sealed APIs

## Documentation Requirements

### File Header
```lean
/-!
# p-adic Norm

This file defines the `p`-adic norm on `ℚ`.

## Main Definitions

- `padicNorm`

## References

* [F. Q. Gouvêa, *p-adic numbers*][gouvea1997]

## Tags

p-adic, norm, valuation
-/
```

### Doc Strings
```lean
/-- If `q ≠ 0`, the `p`-adic norm of `q` is `p ^ (-padicValRat p q)`. -/
def padicNorm (p : ℕ) (q : ℚ) : ℚ := ...
```

Requirements:
- Every definition needs a doc string
- Use `/-- ... -/` delimiters
- End sentences with periods
- Use Markdown and LaTeX
- Bold full theorem names: `**Mean Value Theorem**`

## Naming Conventions

### Capitalization Rules
| Type | Convention | Example |
|------|------------|---------|
| Props/Types | UpperCamelCase | `Group`, `Ring` |
| Theorems | snake_case | `group_eq_of_eq` |
| Functions | Like return type | `a → B → C` → like C |
| Fields/Constructors | Follow type rules | |

### Symbol Names
| Symbol | Name |
|--------|------|
| `∨` | `or` |
| `∧` | `and` |
| `→` | `of` / `imp` |
| `↔` | `iff` |
| `≠` | `ne` |
| `≤` | `le` |
| `≥` | `ge` |

### Spelling
- Use **American English**: `factorization`, `Localization`, `FiberBundle`

## PR Conventions

### Title Format
```
<type>(<optional-scope>): <subject>
```

Types: `feat`, `fix`, `doc`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`

Examples:
```
feat(Data/Nat): add factorial function
fix(Algebra/Group): resolve instance synthesis issue
doc: improve module documentation
```

### Description
- Use imperative, present tense
- Explain motivation and contrast with previous behavior
- Include `:` for breaking changes

### Dependencies
```
Depends on: #1234
```

## Git Workflow

### Setup Remotes
```bash
git remote -v
# Should show:
# origin    https://github.com/YOUR_USERNAME/mathlib4.git
# upstream  https://github.com/leanprover-community/mathlib4.git
```

### Creating PRs
```bash
# Keep master updated
git switch master
git pull

# Create branch
git switch -c my-feature

# Push and create PR
git push
gh pr create --fill
```

### Working on Others' PRs
```bash
# Via GitHub CLI
gh pr checkout 1234

# Manually
git remote add contributor https://github.com/USERNAME/mathlib4.git
git fetch contributor
git checkout contributor/branch-name
```

## Review Process

### Finding Reviewers
- **Anyone can review** - not just maintainers
- Seek out reviewers yourself
- Partial reviews are helpful
- History of reviews → eligibility for reviewer/maintainer teams

### What Reviewers Check
1. **Style** - follows naming, formatting
2. **Documentation** - doc strings present
3. **Location** - correct file/module
4. **Improvements** - can be simplified
5. **Library integration** - fits with existing API

### Being Reviewed
- Be respectful and encouraging
- Leave room for alternative approaches
- Recognize you may be wrong
- Helpful reviews criteria for maintainer eligibility

## Performance

### Benchmarking
- Comment `!bench` on PR to trigger benchmarking
- Significant changes need proactive benchmarking:
  - New classes/instances
  - New `simp` lemmas
  - Changed imports
  - New definitions

### Avoiding Regressions
- Profile before submitting
- Check impact on compilation time

## Deprecation

When removing/renaming:
```lean
@[deprecated (since := "YYYY-MM-DD")]
alias old_name := new_name
```

- Require deprecation date
- Provide transition path
- Delete after 6 months

## Resources

- [Main Contribution Guide](https://leanprover-community.github.io/contribute/)
- [Style Guide](https://leanprover-community.github.io/contribute/style.html)
- [Naming Conventions](https://leanprover-community.github.io/contribute/naming.html)
- [Documentation](https://leanprover-community.github.io/contribute/doc.html)
- [Git Guide](https://leanprover-community.github.io/contribute/git.html)
- [Commit Conventions](https://leanprover-community.github.io/contribute/commit.html)
- [PR Review Guide](https://leanprover-community.github.io/contribute/pr-review.html)
- [Zulip Chat](https://leanprover.zulipchat.com/)
- [Loogle (Declaration Search)](https://loogle.lean-lang.org/)
- [mathlib4 Docs](https://leanprover-community.github.io/mathlib4_docs/)
