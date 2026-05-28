# Lint and Executable Checks

Sources:
- https://leanprover-community.github.io/contribute/doc.html
- Mathlib4 wiki: Setting up linting and testing for your Lean project
- https://leanprover-community.github.io/mathlib4_docs/Mathlib/Tactic/Linter/TextBased.html

## Mathlib Checks

Run the narrowest checks that prove the edit:

```bash
lake build Mathlib.Path.To.Module
lake exe lint-style
```

Run this when adding, deleting, moving, or renaming modules:

```bash
lake exe mk_all
```

## In-File Lint Commands

Use temporary commands while editing, then remove them before committing unless
the project intentionally keeps them:

```lean
#lint
#lint only docBlame docBlameThm
#list_linters
```

## Downstream Projects

If a downstream Lake project has a lint driver, use:

```bash
lake lint
lake test
```

If `lake lint` is unavailable, the project may need `lintDriver` configured,
for example `batteries/runLinter`. Do not change project configuration unless
the task asks for setup.

## Response Hints

- `docBlame`: add a doc string to the reported definition.
- `docBlameThm`: add a doc string to a theorem or lemma with reusable content.
- Naming lint: rename the declaration and add a deprecation alias if public.
- Style lint: fix source text for whitespace, line endings, Unicode, or module
  names; avoid silencing it.
- Unused argument lint: strengthen the statement, rename intentionally, or
  follow the local theorem shape before reaching for `nolint`.
- Use `@[nolint ...]` only for justified false positives.
