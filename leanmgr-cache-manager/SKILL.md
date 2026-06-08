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
- Prefer `leanmgr gc --dry-run` for fleet-wide reclamation; it skips
  unrecoverable caches (no `lake-manifest.json`, no `lakefile.toml`/
  `lakefile.lean`, or empty `lean-toolchain`) unless `--include-unrecoverable`
  is given.
- Use `leanmgr restore` to call `lake exe cache get` after cache deletion.
- Use `leanmgr gitignore` to ensure `.lake/` is ignored before recommending cleanup.
- A project selector must name an indexed project; `clean`, `restore`, and
  `gitignore <project>` error out on an unknown selector rather than no-op.

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
leanmgr worktree prune --dry-run
```

`leanmgr worktree doctor` and `worktree prune` operate across every indexed
project, so they surface and clear stale worktrees fleet-wide, not just in the
current directory.

3. Plan cleanup before deleting:

```sh
leanmgr clean --tag archived --level hard --dry-run
leanmgr clean <project> --level soft --dry-run
leanmgr gc --unused-days 90 --dry-run
leanmgr gc --target 20GiB --dry-run
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

## Skill Installation

`leanmgr ai skill show --format <codex|claude>` adapts this SKILL.md body to
the receiving agent's task contract header. The `codex` flag ensures the body
opens with `# Codex Task Contract`; `claude` opens with
`# Claude Code Task Context`. If the body already starts with the matching
header it is passed through; a different leading heading is replaced; a
missing leading heading is prepended.

## Boundaries

LeanMgr complements official tools:

- Lake owns build, dependency, and artifact cache behavior.
- Elan owns Lean toolchain installation and selection.
- Git owns repositories and worktrees.
- LeanMgr owns cross-project indexing, reporting, dry-run cleanup planning, and safe orchestration.

Do not propose shared local mathlib or symlinked `.lake/packages/mathlib` as a default fix.
That belongs in an explicit experimental workflow because it can break reproducibility across
projects pinned to different Lean or mathlib versions.
