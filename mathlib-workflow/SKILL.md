---
name: mathlib-workflow
description: Complete workflow for contributing to mathlib (Lean 4), including repo setup, git workflow, PR creation, and review process.
---

# Contributing Workflow for mathlib

A guide for the contribution process to mathlib4, the standard library for Lean 4.

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

## Communication

- Use [Zulip](https://leanprover.zulipchat.com/) to discuss before and during work
- Add GitHub username to Zulip profile
- Set display name to real name

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

## Resources

- [Main Contribution Guide](https://leanprover-community.github.io/contribute/)
- [Git Guide](https://leanprover-community.github.io/contribute/git.html)
- [Commit Conventions](https://leanprover-community.github.io/contribute/commit.html)
- [PR Review Guide](https://leanprover-community.github.io/contribute/pr-review.html)
- [Zulip Chat](https://leanprover.zulipchat.com/)
- [Loogle (Declaration Search)](https://loogle.lean-lang.org/)
- [mathlib4 Docs](https://leanprover-community.github.io/mathlib4_docs/)
