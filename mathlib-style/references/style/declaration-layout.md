# Declaration Layout

Source: https://leanprover-community.github.io/contribute/style.html

## Top-Level Layout

Declarations and commands are flush-left, even inside namespaces and sections.
This applies to `def`, `lemma`, `theorem`, `class`, `structure`, `inductive`,
`instance`, `variable`, `open`, `section`, `namespace`, `notation`, and similar
commands.

Use spaces around `:`, `:=`, and infix operators. Put these tokens before a line
break rather than at the start of the next line.

## Namespaces, Sections, Opens, and Variables

Use these commands to control API ownership and local scope, not just to shorten
text. Match nearby mathlib files before introducing a different pattern.

- Use `namespace Foo` when the declarations conceptually belong to `Foo` and
  should have names like `Foo.bar`. This is the usual home for API attached to a
  structure, class, construction, or domain namespace.
- Use `section` to localize shared variables, typeclass assumptions, local
  attributes, options, notation, or a family of declarations. Name the section
  when it marks a durable topic, and use an anonymous `section` for short
  scoping blocks.
- Do not make Lean `section`s mirror documentation headers mechanically.
  Documentation headers such as `/-! ### ... -/` are for generated docs and may
  cut across Lean scopes.
- Put `variable` declarations as close as practical to the declarations that use
  them. Broad file-level variables are fine for genuinely global parameters, but
  move specialized assumptions down into a `section` so later declarations do
  not inherit unused context.
- Prefer explicit variable types. Group stable ambient parameters first, then
  more specialized typeclass assumptions and term variables near the block that
  needs them.
- Use `variable (x)` or `variable {x}` near a declaration when only the binder
  explicitness changes. Avoid changing binder explicitness while also declaring
  unrelated new variables.
- Use `open scoped Foo` for notation or scoped attributes. File-level or
  namespace-level scoped opens are acceptable when the whole file uses that
  notation; otherwise prefer a narrower scope or `open scoped Foo in`.
- Use ordinary `open Foo` when it removes repeated qualified names without
  obscuring ownership. For one declaration or proof, prefer `open Foo in` over a
  broad open.
- Prefer local mechanisms such as `variable ... in`, `include ... in`, `omit ...
  in`, or `open ... in` when only one declaration needs the extra context.

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

## Lambdas

Write anonymous functions with `fun`; do not use `λ`. Prefer the `↦` arrow over
`=>` in lambdas:

```lean
fun x ↦ x + 1
```

## Calculations

Place `calc` on the line before the calculation. Align relation symbols when it
improves readability. The continuation underscore `_` should be left-justified
within the calculation.
