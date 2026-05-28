# Header, Imports, Line Length, Unicode

Source: https://leanprover-community.github.io/contribute/style.html

## File Names

Mathlib `.lean` files should generally be named in `UpperCamelCase`.
Rare lower-case exceptions, such as files named after a specifically lower-case
mathematical object, should be discussed upstream first.

## Unicode

Use mathematical Unicode when it improves notation and readability. Avoid
characters that change text direction, invisible characters other than spaces
and newlines, and characters that modify other characters. Mathlib has Unicode
allow-list linting.

## Line Length

Keep lines at or below 100 characters unless local context strongly justifies an
exception.

## Header and Imports

New mathlib files use this order:

```lean
/-
Copyright (c) 2024 Joe Cool. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Joe Cool
-/
module

public import Mathlib.Logic.Defs

import Mathlib.Algebra.Group.Defs
import Mathlib.Data.Nat.Basic

/-!
# Module title

Module summary.
-/
```

Rules:
- Use `Authors` even for one author.
- Do not end the `Authors` line with a period.
- Separate author names with commas, not `and`.
- Put `module` immediately after the copyright header.
- Group `public import`s separately from regular `import`s.
- Keep imports alphabetic within each block when practical.
