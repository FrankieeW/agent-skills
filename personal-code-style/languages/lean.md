# Lean Style Guide

**mathlib style.**

## Tier 1: Essential

```lean
/-!
# Module Name

Brief description of what this module contains.
-/

import Mathlib.Algebra.Group.Basic
-- other imports

/-!
## Main definitions
-/

def my_function (n : ℕ) : ℕ := n + 1

/-!
## Main theorems
-/

theorem my_theorem (n : ℕ) : my_function n > n := by
  simp [my_function]
```

**Required:**
- Module docstring `/-! ... -/` at top
- UpperCamelCase for types/props
- snake_case for theorems/definitions

## Tier 2: Naming Conventions

| Category | Convention | Example |
|----------|------------|---------|
| Types/Props | UpperCamelCase | `Group`, `Nat` |
| Theorems | snake_case | `group_eq_of_eq` |
| Definitions | snake_case | `my_function` |
| Lemmas | snake_case, descriptive | `map_comp_of_map_comp` |

## Tier 2: File Structure

```lean
/-!
# Module Title

Summary of what this file contains.
-/

import Mathlib.Algebra.Group.Basic
-- other imports

/-!
## Main definitions
-/

/--
Short doc string for a function.
More details about parameters and behavior.
-/
def example (n : ℕ) : ℕ := n + 1

/-!
## Main theorems
-/

theorem example_theorem (n : ℕ) : example n > n := by
  simp [example]
```

## Tier 3: Tactic Reference

| Tactic | Use |
|--------|-----|
| `rfl` | Prove `x = x` by reflexivity |
| `simp` | Simplify using lemmas |
| `rw [eq]` | Rewrite using equation |
| `exact h` | Provide exact proof term |
| `have` | Introduce intermediate lemma |
| `calc` | Chain of equalities |

```lean
theorem example_calc (a b : ℕ) : a + b = b + a := by
  calc
    a + b = b + a := Nat.add_comm a b
```

## Tier 3: Proof Structure

```lean
-- Definition
def add_one (n : ℕ) : ℕ := n + 1

-- Theorem with proof
theorem add_one_succ (n : ℕ) : add_one n = n + 1 := by
  rfl

-- Lemma for intermediate results
lemma auxiliary_lemma (h : n > 0) : n ≥ 1 := by
  exact Nat.succ_le_of_lt h
```

## Common Mistakes

- ❌ Wrong case for theorems → use `snake_case`
- ❌ No module docstring → add `/-! ... -/` at top
- ❌ Missing imports → add `import Mathlib....`
