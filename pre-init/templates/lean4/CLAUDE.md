# CLAUDE.md - Lean 4 Project

Personal rules for Claude Code in this Lean 4 project.

## Project Type

Lean 4 mathematical proofs and theorem proving.

## Coding Standards

### Naming Conventions

- **Theorems**: `theorem_name_describes_statement`
- **Definitions**: `camelCase` for types, snake_case for values
- **Lemmas**: `lemma_step_in_proof`
- **Variables**: `lowercase_with_underscores`

### Code Organization

- Group related theorems by topic
- Use namespaces for organization
- Keep proofs focused (< 50 lines ideal)
- Extract helper lemmas for reusable proof patterns

### Documentation

```lean
/-- Brief description of what this proves.

More detailed explanation if needed.
-/
theorem my_theorem : statement := by
  sorry
```

## Git Workflow

### Commits

```
<type>: <description>

<optional body explaining why>
```

Types: `feat`, `fix`, `refactor`, `docs`, `chore`, `proof`

Example:
```
proof: add Fermat's Little Theorem

Proves FLT for prime p using group theory
```

### Branch Naming

- `proof/theorem-name` for new proofs
- `fix/compiler-issue` for bug fixes
- `refactor/module-name` for refactoring

## Testing

- **Unit tests**: Verify individual lemmas with `#check`
- **Integration**: Run `lake build` to verify whole project
- **CI**: All proofs must compile without sorries

## Tool Preferences

- **Proof assistant**: Lean 4
- **Build system**: Lake
- **Documentation**: Mathdoc or Mathlib docs
- **Tactics**: Standard mathlib tactics, avoid experimental ones

## When to Ask for Help

- Type mismatch errors you can't resolve
- Stuck on proof after 30 minutes
- Compiler warnings about decidability
- Need to understand complex lemma chains
