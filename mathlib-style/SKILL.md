---
name: mathlib-style
description: Use when writing or reviewing Lean 4 mathlib code for style, naming, docs, and lint.
---

# mathlib Style

Use this skill to make Lean code acceptable for mathlib review. Treat the upstream
guides as the source of truth and use this file as an execution checklist.

Sources:
- Style: https://leanprover-community.github.io/contribute/style.html
- Naming: https://leanprover-community.github.io/contribute/naming.html
- Documentation: https://leanprover-community.github.io/contribute/doc.html

## Progressive Disclosure Workflow

Start narrow, then open only the references needed for the task.

1. **Triage the change.** Identify whether the work is mainly formatting, naming,
   documentation, API design, proof maintenance, or lint cleanup.
2. **Load the minimum reference.**
   - Unsure which topic applies: read `references/README.md`.
   - File headers/imports: read `references/style/header-imports.md`.
   - Declaration/proof layout: read `references/style/declaration-layout.md`.
   - Tactic proof style: read `references/style/tactic-proofs.md`.
   - API, normal forms, transparency, deprecation: read `references/style/api-design.md`.
   - Declaration names: read `references/naming/capitalization.md`.
   - Theorem-name atoms and symbols: read `references/naming/symbols.md`.
   - Structural theorem naming: read `references/naming/structural-lemmas.md`.
   - Module docs: read `references/docs/module-docs.md`.
   - Declaration doc strings: read `references/docs/docstrings.md`.
   - Citations and generated docs: read `references/docs/citations-and-sections.md`.
   - Linter commands and responses: read `references/lint/checks.md`.
3. **Inspect nearby mathlib code.** Match local conventions in adjacent files before
   introducing a new pattern.
4. **Apply the relevant checklist below.** Prefer small edits and avoid unrelated
   refactors.
5. **Run executable checks.** Use the command checklist that matches the repository
   and the files touched.

## Core Review Checklist

Use this first for every mathlib edit.

- File names are `UpperCamelCase.lean`, except rare Zulip-discussed exceptions.
- New mathlib files start with copyright/authors, then `module`, then imports,
  then a module docstring.
- `public import` and `import` declarations are grouped separately and kept
  alphabetic within each block.
- Lines are at most 100 characters unless there is a compelling local exception.
- Top-level commands and declarations are flush-left, even inside namespaces.
- Use `namespace`, `section`, `open`, and `variable` for ownership and scope;
  keep broad effects close to the declarations that need them.
- Declaration arguments and return types are explicit enough to read on GitHub.
- Multi-line theorem statements indent continuation lines by 4 spaces; proofs
  indent by 2 spaces.
- `:= by` and tactic-mode `by` stay on the preceding line, never alone.
- Focusing bullets use `·` for subgoals.
- Do not use `$`; use `<|`, `|>`, or parentheses.
- Write anonymous functions with `fun` (not `λ`) and prefer `↦` over `=>`.
- In `rw`/`simp`, write `← ` with a following space.
- Avoid empty lines inside declarations; use a short comment if separation matters.
- Do not squeeze terminal `simp` unless performance or brittleness requires it.
- Prefer API lemmas over forcing unfolding with `erw` or `rfl` after `simp`/`rw`.
- Use `where` syntax for structures and instances.
- Add deprecation aliases/messages with `@[deprecated (since := "YYYY-MM-DD")]`
  when renaming or removing public declarations.

## Naming Checklist

- Proofs/theorems/terms of `Prop`: `snake_case`.
- `Prop`, `Type`, `Sort`, structures, classes, and inductives: `UpperCamelCase`.
- Functions are named like their return values.
- Other terms of `Type`: `lowerCamelCase`.
- When an `UpperCamelCase` name appears inside a theorem name, lower-camel it
  inside the `snake_case` name, e.g. `neZero_iff`.
- Declaration names use American English spelling.
- Use mathlib's symbol dictionary: `and`, `or`, `iff`, `ne`, `le`, `lt`, `mem`,
  `union`, `inter`, `smul`, `dvd`, `iSup`, `iInf`, and so on.
- Name hypotheses with `of` in statement order: `C_of_A_of_B`.
- Use namespace-qualified structural names where appropriate: `.ext`, `.ext_iff`,
  `.inj`, `.inj_iff`, `.rec`, `.recOn`, `.induction`, `.induction_on`.
- Predicates normally appear as prefixes, except established suffix families
  such as `_injective`, `_surjective`, `_mono`, `_monotone`, `_strictMono`.

## Documentation Checklist

- Every file has a module docstring `/-! ... -/` after imports.
- Module docs include a title and summary; add sections only when useful:
  `Main definitions`, `Main statements`, `Notation`, `Implementation notes`,
  `References`, `Tags`.
- New bibliography entries go in `docs/references.bib`; cite with mathlib's
  bracket style.
- Every definition and major theorem has a doc string. Lemmas with mathematical
  content should usually have one too.
- Doc strings use `/-- ... -/`, Markdown, and LaTeX where helpful.
- Complete-sentence doc strings end with periods.
- Named theorems in prose are bold, for example `**Mean Value Theorem**`.
- Multi-line declaration doc strings are not indented after the first line.
- Use sectioning comments `/-! ### Section title -/` for generated docs; use
  ordinary comments for implementation-only notes.

## Executable Checks

Run the narrowest checks that prove the edit. In mathlib itself, prefer:

```bash
lake build Mathlib.Path.To.Module
lake exe lint-style
lake exe mk_all
```

Use `lake exe mk_all` when adding, deleting, moving, or renaming modules.

For focused declaration linting while editing a Lean file, temporarily add one
of these commands near the end of the file, run the file, then remove it before
committing unless the project intentionally keeps it:

```lean
#lint
#lint only docBlame docBlameThm
#list_linters
```

For downstream projects configured with a Lake lint driver, run:

```bash
lake lint
lake test
```

If `lake lint` is unavailable downstream, the project likely needs a `lintDriver`
such as `batteries/runLinter`; do not add project configuration unless the task
explicitly includes downstream setup.

## Lint Response Hints

- `docBlame`: add a doc string to the reported definition.
- `docBlameThm`: add a doc string to a theorem or lemma with reusable
  mathematical content.
- Naming lints: rename the declaration and add a deprecation alias if it is public.
- Style lints on whitespace/line endings/unicode: fix the source text rather than
  silencing the linter.
- Unused argument or generated-name lints: prefer strengthening the statement,
  naming arguments intentionally, or using local conventions over adding `nolint`.
- Use `@[nolint ...]` only for justified false positives; include a nearby comment
  when the reason is not obvious.

## Common Anti-Patterns

- Do not introduce a new abstraction just to make a short proof prettier.
- Do not replace a stable terminal `simp` with a long squeezed `simp only`.
- Do not change neighboring naming schemes without checking adjacent files.
- Do not add broad imports when a narrower import builds.
- Do not leave temporary `#check`, `#eval`, `#lint`, or search commands in PR code.
- Do not use `irreducible` to seal an API; prefer structures or explicit lemmas.
- Do not reach for `nonrec` unless required; prefer restructuring the declaration.
