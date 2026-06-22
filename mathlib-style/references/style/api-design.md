# API Design, Normal Forms, Deprecation

Source: https://leanprover-community.github.io/contribute/style.html

## Transparency

Default `def`s are semireducible. Use `abbrev` for reducible definitions.

Avoid using `irreducible` as an API seal. Prefer structures, explicit API
lemmas, or a clearer abstraction boundary.

Avoid `nonrec` unless it is genuinely needed; prefer restructuring so the
recursive reference is not required.

If a proof needs `erw` or `rfl` after `simp` or `rw`, consider whether the API
is missing a theorem in the right normal form.

## Normal Forms

Mathlib prefers stable normal forms in statements and theorem conclusions. For
example, use established forms such as `s.Nonempty` when local API and simp
normalization expect them.

Before adding theorem variants, inspect nearby files for the canonical statement
shape and simp direction.

## Comments

Use module doc comments `/-! ... -/` for documentation that should appear in
generated docs, including section headers.

Use ordinary comments `/- ... -/` for technical implementation notes and `--`
for short inline comments.

## Performance

Be careful with changes that add instances, add simp lemmas, alter imports, or
touch widely imported definitions. For mathlib PRs, benchmark significant
performance-sensitive changes proactively when appropriate.

## Deprecation

When removing or renaming public declarations, provide a transition path:

```lean
theorem new_name : ... := ...

@[deprecated (since := "YYYY-MM-DD")]
alias old_name := new_name
```

Rules:
- `@[deprecated]` requires a `since` date.
- Use an alias when there is a direct replacement.
- Use a message when migration needs explanation.
- Named instances do not require deprecations.
- Deprecated declarations may be deleted after the upstream waiting period.
