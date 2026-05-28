# Tactic Proof Style

Source: https://leanprover-community.github.io/contribute/style.html

## `by`

When opening tactic mode, put `by` at the end of the preceding line. Do not put
`by` on a line by itself.

```lean
theorem continuous_uncurry_of_discreteTopology [DiscreteTopology α]
    {f : α → β → γ} (hf : ∀ a, Continuous (f a)) :
    Continuous (Function.uncurry f) := by
  apply continuous_iff_continuousAt.2
  intro x
  exact (hf x.1).continuousAt
```

## Goals and Focus

Use the focusing bullet `·` for generated subgoals.

Use `case` for named subgoals when it improves readability, especially after
`refine` or induction.

## Semicolons and `<;>`

Short single-line tactic proofs may use semicolons:

```lean
by constructor <;> simp
```

For longer proofs, prefer line breaks and indentation. If `t0 <;> t1` spans
multiple lines, indent the continuation tactic.

## `simp`

Do not squeeze terminal `simp` calls unless there is a concrete reason such as
performance or proof fragility. Long squeezed `simp only` proofs are more likely
to break under lemma renames and can obscure the useful local simp lemmas.

## Whitespace Details

- Do not use `$`; use `<|`, `|>`, or parentheses.
- In `rw` and `simp`, write a space after `←`: `rw [← add_comm a b]`.
- Do not leave empty lines inside declarations.
- Use comments for meaningful proof separation instead of blank lines.
