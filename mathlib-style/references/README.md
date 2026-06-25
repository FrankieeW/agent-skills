# mathlib Style References

This directory is split for progressive disclosure. Open only the file that
matches the current review question, then fall back to the upstream pages if the
local summary is insufficient.

Upstream sources:
- Style: https://leanprover-community.github.io/contribute/style.html
- Naming: https://leanprover-community.github.io/contribute/naming.html
- Documentation: https://leanprover-community.github.io/contribute/doc.html

## Routing

- `style/header-imports.md`: file names, copyright header, `module`, imports,
  line length, unicode.
- `style/declaration-layout.md`: top-level layout, theorem statements,
  namespace/section/open/variable scope, explicit types, structures, instances,
  binders, calculations.
- `style/tactic-proofs.md`: `by`, tactic indentation, focusing bullets,
  semicolons, `simp`.
- `style/api-design.md`: normal forms, transparency, comments, deprecation,
  performance-sensitive changes.
- `naming/capitalization.md`: file and declaration capitalization rules.
- `naming/symbols.md`: theorem-name atoms for logical, set, algebraic, and
  order symbols.
- `naming/structural-lemmas.md`: `.ext`, injectivity, induction/recursion,
  predicate suffixes, function theorem variants.
- `docs/module-docs.md`: file-level module documentation structure.
- `docs/docstrings.md`: declaration doc string rules and examples.
- `docs/citations-and-sections.md`: BibTeX citations, section docs, generated
  documentation notes.
- `lint/checks.md`: executable checks, `#lint`, `lake lint`, and lint response
  patterns.
