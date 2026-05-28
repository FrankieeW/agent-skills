# Module Documentation

Source: https://leanprover-community.github.io/contribute/doc.html

Each mathlib file should start with:

1. A copyright/authors header.
2. The `module` keyword.
3. Grouped imports.
4. A module docstring.

Use `/-!` and `-/` on their own lines for file-level module docs.

```lean
/-!
# p-adic norm

This file defines the `p`-adic norm on `ℚ`.

## Main definitions

- `padicNorm`: the `p`-adic norm on `ℚ`.

## Implementation notes

Most results assume `[Fact p.Prime]`.

## References

* [F. Q. Gouvêa, *p-adic numbers*][gouvea1997]

## Tags

p-adic, norm, valuation
-/
```

## Sections

After the title and summary, use second-level headers in this order when they
are relevant:

1. `Main definitions`
2. `Main statements`
3. `Notation`
4. `Implementation notes`
5. `References`
6. `Tags`

Omit sections that add no value. A concise summary can cover small files.
