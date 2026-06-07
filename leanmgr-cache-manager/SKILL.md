---
name: leanmgr-cache-manager
description: Use when managing many Lean 4 projects with LeanMgr, especially .lake disk usage, cache cleanup, restore, gitignore, doctor, toolchain, or worktree workflows.
---

# LeanMgr Cache Manager

Use LeanMgr as a local project-fleet tool for Lean 4 cache lifecycle work.

## Rules

- Treat `.lake` as disposable, recoverable cache.
- Do not modify Lean source files unless the user explicitly asks.
- Do not rewrite Git history.
- Run dry-runs before destructive cleanup.
- Prefer `leanmgr doctor`, `leanmgr size`, and `leanmgr clean --dry-run` before deletion.
- Use `leanmgr restore` to call `lake exe cache get` after cache deletion.
- Use `leanmgr gitignore` to ensure `.lake/` is ignored before recommending cleanup.

## Workflow

1. Inspect indexed projects:

```sh
leanmgr list
leanmgr size --all
leanmgr doctor
```

2. Check project hygiene:

```sh
leanmgr gitignore --all --dry-run
leanmgr toolchain check
leanmgr worktree doctor
```

3. Plan cleanup before deleting:

```sh
leanmgr clean --tag archived --level hard --dry-run
leanmgr clean <project> --level soft --dry-run
```

4. Execute only after the user accepts the plan or explicitly requests execution:

```sh
leanmgr clean --tag archived --level hard
```

5. Restore cache when returning to a project:

```sh
leanmgr restore <project>
leanmgr restore --tag active
```

## AI Context

Use AI-oriented context output before making recommendations:

```sh
leanmgr ai context --format codex
leanmgr ai context --format claude
leanmgr ai context --format json
```

Prefer `--format json` for programmatic pipelines and `--format codex` or `--format claude`
for coding-agent prompts.

## Boundaries

LeanMgr complements official tools:

- Lake owns build, dependency, and artifact cache behavior.
- Elan owns Lean toolchain installation and selection.
- Git owns repositories and worktrees.
- LeanMgr owns cross-project indexing, reporting, dry-run cleanup planning, and safe orchestration.

Do not propose shared local mathlib or symlinked `.lake/packages/mathlib` as a default fix.
That belongs in an explicit experimental workflow because it can break reproducibility across
projects pinned to different Lean or mathlib versions.
