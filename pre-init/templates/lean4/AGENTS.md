# AGENTS.md - Lean 4 Project

Agent guidelines and configurations for this Lean 4 project.

## When to Use Agents

### lean4 Agent (Recommended)

Use the `lean4` skill for:
- Debugging type mismatches
- Understanding proof states
- Finding lemmas in mathlib
- Resolving build errors
- Performance profiling proofs

**Trigger**: Anytime you're stuck on a Lean 4 proof or build issue.

```bash
/lean4
```

### Exploration Agent

Use when you need to:
- Find related theorems or lemmas
- Understand proof patterns in mathlib
- Search for similar proofs

## Proof Writing Workflow

1. **Plan** - Sketch the proof structure
2. **Type Check** - Use `#check` for intermediate steps
3. **Write** - Implement the proof
4. **Test** - Run `lake build` to verify
5. **Refactor** - Simplify and document

## Common Issues

### Type Mismatch

When you see "type mismatch" errors:
1. Check expected type with `#check`
2. Verify theorem statement is correct
3. Look for coercion issues
4. Ask claude-code for help

### Missing Instances

For "failed to synthesize instance" errors:
1. Check if instance exists in mathlib
2. Look for typeclass resolution chains
3. May need to add explicit instance
4. Use `lean_leansearch` to find similar

### Compiler Warnings

Before pushing:
- Run `lake build` with no warnings
- Check for `sorry` in proofs
- Verify all imports are used

## Resources

- [Lean 4 Manual](https://lean-lang.org/lean4/doc/)
- [Mathlib4 Docs](https://mathlib4.readthedocs.io/)
- [Lean Community](https://leanprover-community.github.io/)

## Project-Specific Notes

<!-- Add notes about this specific project -->
-
