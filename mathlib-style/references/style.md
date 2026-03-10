# Library Style Guidelines

> Source: https://leanprover-community.github.io/contribute/style.html

In addition to the naming conventions,
files in the Lean library generally adhere to the following guidelines
and conventions. Having a uniform style makes it easier to browse the
library and read the contents, but these are meant to be guidelines
rather than rigid rules.

## Variable conventions

- `u`, `v`, `w`, ... for universes
- `α`, `β`, `γ`, ... for generic types
- `a`, `b`, `c`, ... for propositions
- `x`, `y`, `z`, ... for elements of a generic type
- `h`, `h₁`, ... for assumptions
- `p`, `q`, `r`, ... for predicates and relations
- `s`, `t`, ... for lists
- `s`, `t`, ... for sets
- `m`, `n`, `k`, ... for natural numbers
- `i`, `j`, `k`, ... for integers

Types with a mathematical content are expressed with the usual
mathematical notation, often with an upper case letter
(`G` for a group, `R` for a ring, `K` or `𝕜` for a field, `E` for a vector space, ...).
This convention is not followed in older files, where greek letters are used
for all types. Pull requests renaming type variables in these files are welcome.

## Line length

Lines should not be longer than 100 characters. This makes files
easier to read, especially on a small screen or in a small window.
If you are editing with VS Code, there is a visual marker which
will indicate a 100 character limit.

## Header and imports

The file header should contain copyright information, a list of all
the authors who have made significant contributions to the file, and
a description of the contents. Do all `import`s right after the header,
without a line break, on separate lines.

```
/-
Copyright (c) 2024 Joe Cool. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Joe Cool
-/
import Mathlib.Data.Nat.Basic
import Mathlib.Algebra.Group.Defs
```

(Tip: If you're editing mathlib in VS Code, you can write `copy`
and then press `TAB` to generate a skeleton of the copyright header.)

Regarding the list of authors: use `Authors` even when there is only a single author.
Don't end the line with a period, and use commas (`,` ) to separate all author names
(so don't use `and` between the penultimate and final author.)
We don't have strict rules on what contributions qualify for inclusion there.
The general idea is that the people listed there should be the ones we would
reach out to if we had questions about the design or development of the Lean code.

## Module docstrings

After the copyright header and the imports,
please add a module docstring (delimited with `/-!` and `-/`) containing

- a title of the file,
- a summary of the contents (the main definitions and theorems, proof techniques, etc…)
- notation that has been used in the file (if any)
- references to the literature (if any)

In total, the module docstring should look something like this:

```
/-!
# Foos and bars

In this file we introduce `foo` and `bar`,
two main concepts in the theory of xyzzyology.

## Main results

- `exists_foo`: the main existence theorem of `foo`s.
- `bar_of_foo_of_baz`: a construction of a `bar`, given a `foo` and a `baz`.
  If this doc-string is longer than one line, subsequent lines should be indented by two spaces
  (as required by markdown syntax).
- `bar_eq`    : the main classification theorem of `bar`s.

## Notation

 - `|_|` : The barrification operator, see `bar_of_foo`.

## References

See [Thales600BC] for the original account on Xyzzyology.
-/
```

New bibliography entries should be added to `docs/references.bib`.

See our documentation requirements for more suggestions and examples.

## Structuring definitions and theorems

All declarations (e.g., `def`, `lemma`, `theorem`, `class`, `structure`, `inductive`, `instance`, etc.)
and commands (e.g., `variable`, `open`, `section`, `namespace`, `notation`, etc.) are considered
top-level and these words should appear flush-left in the document. In particular, opening a
namespace or section does not result in indenting the contents of that namespace or section.
(Note: within VS Code, hovering over any declaration such as `def Foo ...` will show the fully
qualified name, like `MyNamespace Foo` if `Foo` is declared while the namespace `MyNamespace` is open.)

These guidelines hold for declarations starting with `def`, `lemma` and `theorem`.
For "theorem statement", also read "type of a definition" and for "proof" also read
"definition body".

Use spaces on both sides of ":", ":=" or infix operators. Put them before a line break
rather than at the beginning of the next line.

In what follows, "indent" without an explicit indication of the amount means
"indent by 2 additional spaces".

After stating the theorem, we indent the lines in the subsequent proof by 2 spaces.

```
open Nat
theorem nat_case {P : Nat → Prop} (n : Nat) (H1 : P 0) (H2 : ∀ m, P (succ m)) : P n :=
  Nat.recOn n H1 (fun m IH ↦ H2 m)
```

If the theorem statement requires multiple lines, indent the subsequent lines by 4 spaces.
The proof is still indented only 2 spaces (_not_ 6 = 4 + 2).
When providing a proof in tactic mode, the `by` is placed on the line _prior_ to the
first tactic; however, `by` should not be placed on a line by itself.
In practice this means you will often see `:= by` at the end of a theorem statement.

```
import Mathlib.Data.Nat.Basic

theorem le_induction {P : Nat → Prop} {m}
    (h0 : P m) (h1 : ∀ n, m ≤ n → P n → P (n + 1)) :
    ∀ n, m ≤ n → P n := by
  apply Nat.le.rec
  · exact h0
  · exact h1 _

def decreasingInduction {P : ℕ → Sort*} (h : ∀ n, P (n + 1) → P n) {m n : ℕ} (mn : m ≤ n)
    (hP : P n) : P m :=
  Nat.leRecOn mn (fun {k} ih hsk => ih <| h k hsk) (fun h => h) hP
```

When a proof term takes multiple arguments, it is sometimes clearer, and often
necessary, to put some of the arguments on subsequent lines. In that case,
indent each argument. This rule, i.e., indent an additional two spaces, applies
more generally whenever a term spans multiple lines.

```
open Nat
axiom zero_or_succ (n : Nat) : n = zero ∨ n = succ (pred n)
theorem nat_discriminate {B : Prop} {n : Nat} (H1: n = 0 → B) (H2 : ∀ m, n = succ m → B) : B :=
  Or.elim (zero_or_succ n)
    (fun H3 : n = zero ↦ H1 H3)
    (fun H3 : n = succ (pred n) ↦ H2 (pred n) H3)
```

Don't orphan parentheses; keep them with their arguments.

A short declaration can be written on a single line:

```
open Nat
theorem succ_pos : ∀ n : Nat, 0 < succ n := zero_lt_succ

def square (x : Nat) : Nat := x * x
```

A `have` can be put on a single line when the justification is short.

```
example (n k : Nat) (h : n < k) : ... :=
  have h1 : n ≠ k := ne_of_lt h
  ...
```

When the justification is too long, you should put it on the next line,
indented by an additional two spaces.

```
example (n k : Nat) (h : n < k) : ... :=
  have h1 : n ≠ k :=
    ne_of_lt h
  ...
```

When the justification of the `have` uses tactic mode, the `by` should
be placed on the same line, regardless of whether the justification
spans multiple lines.

```
example (n k : Nat) (h : n < k) : ... :=
  have h1 : n ≠ k := by apply ne_of_lt; exact h
  ...

example (n k : Nat) (h : n < k) : ... :=
  have h1 : n ≠ k := by
    apply ne_of_lt
    exact h
  ...
```

### Instances

When providing terms of structures or instances of classes, the `where`
syntax should be used to avoid the need for enclosing braces, as in:

```
instance instOrderBot : OrderBot ℕ where
  bot := 0
  bot_le := Nat.zero_le
```

If there is already an instance `instBot`, then one can write

```
instance instOrderBot : OrderBot ℕ where
  __ := instBot
  bot_le := Nat.zero_le
```

### Hypotheses Left of Colon

Generally, having arguments to the left of the colon is preferred
over having arguments in universal quantifiers or implications,
if the proof starts by introducing these variables.

### Binders

Use a space after binders.

### Anonymous functions

Lean has several nice syntax options for declaring anonymous functions. For very simple
functions, one can use the centered dot as the function argument, as in `(· ^ 2)` to
represent the squaring function. However, sometimes it is necessary to refer to the
arguments by name (e.g., if they appear in multiple places in the function body). The
Lean default for this is `fun x => x * x`, but the `↦` arrow (inserted with `\mapsto`)
is also valid. In mathlib the pretty printer displays `↦`, and we slightly prefer this
in the source as well. The lambda notation `λ x ↦ x * x`, while syntactically valid,
is disallowed in mathlib in favor of the `fun` keyword.

## Calculations

There is some flexibility in how you write calculational proofs. As with `by`, the `calc` keyword
should be placed on the line _prior_ to the start of the calculation, with the calculation indented.
Whichever relations are involved (e.g., `=` or `≤`) should be aligned from one line to the next.
The underscores `_` used as placeholders for terms indicating the continuation of the calculation
should be left-justified.

## Tactic mode

As we have already mentioned, when opening a tactic block,
`by` is placed at the end of the line
_preceding_ the start of the tactic block, but not on its own line.
Everything within the tactic block is indented.

When new goals arise as side conditions or steps, they are indented and preceded by
a focusing dot `·` (inserted as `\.`); the dot is not indented.

Certain tactics, such as `refine`, can create _named_ subgoals which
can be proven in whichever order is desired using `case`. This feature
is also useful in aiding readability. However, it is not required to
use this instead of the focusing dot (`·`).

Often `t0 <;> t1` is used to execute `t0` and then `t1` on all new goals.
Either write the tactics in one line, or indent the following tactic.

For single line tactic proofs (or short tactic proofs embedded in a term),
it is acceptable to use `by tac1; tac2; tac3` with semicolons instead of
a new line with indentation.

## Squeezing simp calls

Unless performance is particularly poor or the proof breaks otherwise, _terminal `simp` calls_
(a `simp` call is terminal if it closes the current goal or is only followed by flexible tactics
such as `ring`, `field_simp`, `aesop`) should not be _squeezed_ (replaced by the output of `simp?`).

There are two main reasons for this:

1. A squeezed `simp` call might be several lines longer than the corresponding unsqueezed one, and
   therefore drown the useful information of what key lemmas were added to the unsqueezed `simp` call
   to close the goal in a sea of basic simp lemmas.
2. A squeezed `simp` call refers to many lemmas by name, meaning that it will break when one such
   lemma gets renamed. Lemma renamings happen often enough for this to matter on a maintenance level.

## Profiling for performance

When contributing to mathlib, authors should be aware of the performance impacts
of their contributions. The Lean FRO maintains benchmarking infrastructure which
can be accessed by commenting `!bench` on a PR.

Authors should assure that their contributions do not cause significant
performance regressions. In particular, if the PR touches significant components
of the language like adding instances, adding `simp` lemmas, changing imports,
or creating new definitions, then authors should benchmark their changes
proactively.

## Transparency and API design

Central to Lean being a practically performant proof assistant is avoiding
checking of definitional equality for very large terms. In the elaborator (the
component of the language that converts syntax to terms), the notion of
transparency is the main mechanism to avoid unfolding large definitions when
unnecessary. Excluding `opaque` definitions, there are three levels of
transparency:

- `reducible` definitions are always unfolded
- `semireducible` definitions (the default) are usually not unfolded in main tactics like
  `rw` and `simp`, but can be unfolded with a little effort like explicitly
  calling `rfl` or `erw`. Semireducible definitions are also not unfolded during the
  computation of keys for storing instances in the instance cache or simp
  lemmas in the simp cache.
- `irreducible` definitions are never unfolded unless the user explicitly
  requests it (e.g using the `unfold` tactic, or by using the `unseal` command).

`def` by default creates `semireducible` definitions and `abbrev` creates
`reducible` (and `@[inline]`) definitions.

Use of `erw` or `rfl` after tactics like `simp` or `rw` that operate at
reducible transparency is an indication that there is missing API.
Consider adding the necessary lemmas to the API to avoid this.

## Whitespace and delimiters

Lean is whitespace-sensitive, and in general we opt for a style which avoids
delimiting code. For instance, when writing tactics, it is possible to write
them as `tac1; tac2; tac3`, separated by `;`, in order to override the default
whitespace sensitivity. However, as mentioned above, we generally try to avoid
this except in a few special cases.

Similarly, sometimes parentheses can be avoided by judicious use of the `<|`
operator (or its cousin `|>`). Note: while `$` is a synonym for `<|`, its
use in mathlib is disallowed in favor of `<|` for consistency as well as
because of the symmetry with `|>`. These operators have the effect of
parenthesizing everything to the right of `<|` (note that `(` is curved the
same direction as `<`) or to the left of `|>` (and `)` curves the same way
as `>`).

When using the tactics `rw` or `simp` there should be a space after the left arrow `←`.
For instance `rw [← add_comm a b]` or `simp [← and_or_left]`.
(There should also be a space between the tactic name and its arguments, as in `rw [h]`.)
This rule applies the `do` notation as well: `do return (← f) + (← g)`

## Empty lines inside declarations

Empty lines inside declarations are discouraged and there is a linter that enforces
that they are not present. This helps maintaining a uniform code style throughout
all of mathlib.

You are however encouraged to add comments to your code: even a short sentence communicates
_much_ more than an empty line in the middle of a proof ever will!

## Normal forms

Some statements are equivalent. For instance, there are several equivalent
ways to require that a subset `s` of a type is nonempty. For another example, given
`a : α`, the corresponding element of `Option α` can be equivalently written
as `Some a` or `(a : Option α)`. In general, we try to settle
on one standard form, called the normal form, and use it both in statements and
conclusions of theorems. In the above examples, this would be `s.Nonempty` (which
gives access to dot notation) and `(a : Option α)`. Often, simp lemmas will be
registered to convert the other equivalent forms to the normal form.

Use module doc delimiters `/-! -/` to provide section headers and
separators since these get incorporated into the auto-generated docs,
and use `/- -/` for more technical comments (e.g. TODOs and
implementation notes) or for comments in proofs.
Use `--` for short or in-line comments.

Documentation strings for declarations are delimited with `/-- -/`.
When a documentation string for a declaration spans multiple lines, do not indent
subsequent lines.

## Expressions in error or trace messages

Inside all printed messages (such as, in linters, custom elaborators or other metaprogrammes),
names and interpolated data should either be

- inline and surrounded by backticks (e.g., `m!"`{foo}`must have type`{bar}`"`), or
- on their own line and indented (via e.g. `indentD`)

## Deprecation

Deleting, renaming, or changing declarations can cause downstreams projects that rely on these
definitions to fail to compile.
Any publicly exposed theorems and definitions that are being removed should be gracefully
transitioned by keeping the old declaration with a `@[deprecated]` attribute.
This warns downstream projects about the change and gives them the opportunity to adjust before the
declarations are deleted.

```
theorem new_name : ... := ...
@[deprecated (since := "YYYY-MM-DD")] alias old_name := new_name

@[deprecated "This theorem is deprecated in favor of using ... with ..." (since := "YYYY-MM-DD")]
theorem example_thm ...
```

The `@[deprecated]` attribute requires the deprecation date, and an alias to the new declaration
or a string to explain how transition away from the old definition when a new version is no longer
being provided.

We allow, but discourage, contributors from simultaneously renaming declarations X to Y and W to X.
In this case, no deprecation attribute is required for X, but it is for W.

Named instances do not require deprecations. Deprecated declarations can be deleted after 6 months.
