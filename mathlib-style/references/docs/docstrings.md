# Declaration Doc Strings

Source: https://leanprover-community.github.io/contribute/doc.html

Every definition and major theorem needs a doc string. Lemma doc strings are
encouraged when the lemma has mathematical content or is likely to be reused.

Use `/-- ... -/` immediately above the declaration.

```lean
/-- If `q ≠ 0`, the `p`-adic norm of a rational `q` is
`p ^ (-padicValRat p q)`. If `q = 0`, the `p`-adic norm of `q` is `0`. -/
def padicNorm (p : ℕ) (q : ℚ) : ℚ :=
  if q = 0 then 0 else (p : ℚ) ^ (-padicValRat p q)
```

Rules:
- Doc strings should explain the mathematical meaning.
- They may simplify implementation details if the mathematical description is
  accurate for users.
- Use Markdown and LaTeX where helpful.
- Put Lean identifiers and variables in backticks.
- Complete-sentence doc strings end with periods.
- Bold named theorems in prose, for example `**Mean Value Theorem**`.
- Do not indent subsequent lines of a multi-line declaration doc string.

Focused lint command:

```lean
#lint only docBlame docBlameThm
```
