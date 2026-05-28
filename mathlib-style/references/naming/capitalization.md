# Naming Capitalization

Source: https://leanprover-community.github.io/contribute/naming.html

## Core Rules

Mathlib Lean 4 uses `snake_case`, `lowerCamelCase`, and `UpperCamelCase`.

1. Terms of `Prop`, including proofs and theorem names, use `snake_case`.
2. `Prop`s and `Type`s, including structures, classes, and inductives, use
   `UpperCamelCase`.
3. Functions are named like their return values.
4. Other terms of `Type` use `lowerCamelCase`.
5. When an `UpperCamelCase` name appears inside a `snake_case` theorem name,
   lower-camel it.
6. Acronyms such as `LE` are cased as a group.
7. The same rules apply to structure fields and inductive constructors.

## Examples

```lean
structure OneHom (M : Type _) (N : Type _) [One M] [One N] where
  toFun : M → N
  map_one' : toFun 1 = 1

theorem MonoidHom.toOneHom_injective [MulOneClass M] [MulOneClass N] :
    Function.Injective (MonoidHom.toOneHom : (M →* N) → OneHom M N) := by
  ...

theorem neZero_iff {R : Type _} [Zero R] {n : R} : NeZero n ↔ n ≠ 0 := by
  ...
```

## Spelling

Declaration names use American English: `factorization`, `Localization`,
`FiberBundle`.

Documentation prose may use other common English spellings.

## Variable Names

Common conventions:
- `u`, `v`, `w` for universes.
- `α`, `β`, `γ` for generic types.
- `a`, `b`, `c` for propositions.
- `x`, `y`, `z` for elements.
- `h`, `h₁` for assumptions.
- `p`, `q`, `r` for predicates and relations.
- `s`, `t` for lists or sets.
- `m`, `n`, `k` for natural numbers.
- `i`, `j`, `k` for integers.
- `G`, `R`, `K`, `𝕜`, `E` for mathematically meaningful types.
