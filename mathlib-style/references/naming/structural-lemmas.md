# Structural Lemma Names

Source: https://leanprover-community.github.io/contribute/naming.html

## Namespaces and Dot Notation

Use namespaces for generated and structural operations when appropriate:

- `And.intro`, `And.left`, `And.right`
- `Or.inl`, `Or.inr`, `Or.elim`
- `Iff.mp`, `Iff.mpr`, `Iff.symm`
- `Eq.refl`, `Eq.symm`, `Eq.trans`
- `LE.trans`, `LT.trans_le`, `LE.trans_lt`

Do not force namespace style for established axiomatic arithmetic names such as
`mul_comm` or `and_assoc`.

## Axiomatic Names

Some theorems are named by property rather than by spelling out the conclusion:

- `def`
- `refl`
- `irrefl`
- `symm`
- `trans`
- `antisymm`
- `asymm`
- `congr`
- `comm`
- `assoc`
- `left_comm`
- `right_comm`
- `mul_left_cancel`
- `mul_right_cancel`
- `inj`

## Extensionality

A theorem of the shape `(∀ x, f x = g x) → f = g` should usually be named
`.ext` and tagged with `@[ext]`.

A theorem of the shape `f = g ↔ ∀ x, f x = g x` should usually be named
`.ext_iff`.

## Injectivity

Prefer `Function.Injective f` statements named with the full word
`injective`, typically `f_injective`.

Bidirectional injectivity lemmas of the shape `f x = f y ↔ x = y` should be
named `f_inj`, or `.inj` in an appropriate namespace. These are often good
`@[simp]` candidates.

`left` and `right` in injectivity names refer to the argument that changes.

## Induction and Recursion

Use `induction` when the motive eliminates into `Prop`; use `rec` when it
eliminates into `Sort` or `Type`.

Use `on` iff the value comes before the constructors in argument order.

| Motive | Value first | Constructors first |
| --- | --- | --- |
| `Prop` | `T.induction_on` | `T.induction` |
| `Sort` / `Type` | `T.recOn` | `T.rec` |

## Predicates

Most predicates are prefixes: `isClosed_Icc`, not `Icc_isClosed`.

Established suffix families include `_injective`, `_surjective`, `_bijective`,
`_mono`, `_anti`, `_monotone`, `_antitone`, `_strictMono`, and `_strictAnti`.

## Function Variants

For function-valued operations, distinguish unexpanded and expanded forms when
both are needed:

```lean
Continuous.mul      -- Continuous (f * g)
Continuous.fun_mul  -- Continuous fun x ↦ f x * g x
```
