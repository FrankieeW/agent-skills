# Declaration Layout

Source: https://leanprover-community.github.io/contribute/style.html

## Top-Level Layout

Declarations and commands are flush-left, even inside namespaces and sections.
This applies to `def`, `lemma`, `theorem`, `class`, `structure`, `inductive`,
`instance`, `variable`, `open`, `section`, `namespace`, `notation`, and similar
commands.

Use spaces around `:`, `:=`, and infix operators. Put these tokens before a line
break rather than at the start of the next line.

## Statements and Proofs

- Continuation lines in a multi-line theorem statement are indented 4 spaces.
- The proof body is indented 2 spaces, not 6.
- Give declaration arguments explicit types.
- Give declarations explicit return types when possible.
- Separate ordinary declarations by one blank line.
- Groups of similar one-line declarations may be adjacent.

```lean
theorem le_induction {P : Nat → Prop} {m}
    (h0 : P m) (h1 : ∀ n, m ≤ n → P n → P (n + 1)) :
    ∀ n, m ≤ n → P n := by
  apply Nat.le.rec
  · exact h0
  · exact h1 _
```

## `have`

A short `have` can stay on one line:

```lean
have h1 : n ≠ k := ne_of_lt h
```

Longer justifications go on following lines with an additional 2-space indent.
If the justification uses tactic mode, keep `:= by` on the same line as the
`have`.

## Structures and Instances

Use `where` syntax for structures and instances. Give fields doc strings when
they are part of a public structure or class.

```lean
instance instOrderBot : OrderBot Nat where
  bot := 0
  bot_le := Nat.zero_le
```

## Binders and Hypotheses

Prefer hypotheses to the left of the colon when the proof starts by introducing
them:

```lean
example (n : R) (h : 1 < n) : 0 < n := by
  linarith
```

Use a space after binders, and generally write binder types explicitly.

## Calculations

Place `calc` on the line before the calculation. Align relation symbols when it
improves readability. The continuation underscore `_` should be left-justified
within the calculation.
