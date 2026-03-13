---
name: mathlib-style
description: Code style guide for mathlib (Lean 4), including naming conventions, formatting rules, and documentation requirements.
---

# Code Style Guide for mathlib

Code formatting, naming conventions, and documentation requirements for mathlib4.

## Required Guidelines

Follow these three key guides:
1. **[Style Guide](https://leanprover-community.github.io/contribute/style.html)** - Code formatting
2. **[Naming Conventions](https://leanprover-community.github.io/contribute/naming.html)** - Naming scheme
3. **[Documentation](https://leanprover-community.github.io/contribute/doc.html)** - Doc requirements

## File Organization

```lean
/-!
# Module Title

Summary of what this file contains.
-/

import Mathlib.Algebra.Group.Basic
-- other imports

-- definitions and theorems
```

## Code Style

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
- No `$` - use `<|` or `|>` instead
- Space after `←` in `rw [← lemma]`
- No empty lines inside declarations

#### Simp
- Don't squeeze terminal `simp` calls
- Squeezed simp breaks on lemma renames

#### Transparency
- Default: `semireducible`
- Use `@[reducible]` for definitions that should unfold
- Use structures (not `irreducible`) for sealed APIs

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

- [Style Guide](https://leanprover-community.github.io/contribute/style.html)
- [Naming Conventions](https://leanprover-community.github.io/contribute/naming.html)
- [Documentation Guide](https://leanprover-community.github.io/contribute/doc.html)
- [mathlib4 Docs](https://leanprover-community.github.io/mathlib4_docs/)
