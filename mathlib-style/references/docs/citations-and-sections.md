# Citations, Section Docs, Generated Docs

Source: https://leanprover-community.github.io/contribute/doc.html

## Section Documentation

Use module documentation comments for section headers that should appear in
generated docs:

```lean
/-! ### Declarations about `BinderInfo` -/
```

These comments are for display and readability; they do not need to match a
Lean `section` or `namespace`.

Use third-level headers `###` for section titles inside a file.

## Markdown and LaTeX

- Put Lean declarations and variables in backticks.
- Use fully qualified names when a generated-doc link is useful.
- Put raw URLs in angle brackets: `<https://example.com>`.
- Use `$ ... $`, `$$ ... $$`, or LaTeX environments for mathematics.

## Citations

New bibliography entries belong in `docs/references.bib`.

Use citation keys in square brackets:

```text
The proof can be found in [Boole1854].
```

Or use custom text followed by the citation key:

```text
See [Grundlagen der Geometrie][hilbert1999].
```

Do not put a closing square bracket `]` inside the custom link text.
