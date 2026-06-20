# Lean 4 Mathematics Notebook Style

Use this reference when generating `.ipynb` lessons for mathematics with Lean 4 and mathlib.

## Language Modes

- `zh`: Chinese explanations, English Lean identifiers and comments.
- `en`: English explanations and English Lean code.
- `bilingual`: Chinese first, then compact English. Keep bilingual cells short; do not duplicate long paragraphs.

If the user does not specify a language, infer it from the user's prompt. If mixed, use the dominant language and mention how to switch.

## Recommended Notebook Shape

1. Title and promise:
   - State the topic plainly.
   - Say what the learner will be able to formalize by the end.
2. Setup:
   - Mention Lean 4, mathlib, and the expected Jupyter Lean kernel or project-backed notebook setup.
   - Include a first smoke-test cell such as `#check Nat`, `#check Int`, or a topic-specific imported theorem.
   - When targeting `lean4_jupyter`, mention that the kernel is named `lean4` and is backed by Lean's `repl`.
3. Roadmap:
   - Use 3-6 bullets.
   - Make each bullet a visible notebook section.
4. Concept blocks:
   - Explain the math idea in 3-8 sentences.
   - Immediately include a Lean cell that inspects or tests it.
5. Translation blocks:
   - Show how paper notation maps to Lean names and types.
   - Include `#check` cells for important constants, theorems, and coercions.
6. Proof blocks:
   - Start with `example` before named `lemma` or `theorem`.
   - Prefer one proof idea per cell.
   - Build the final theorem from earlier lemmas.
7. Debugging blocks:
   - Include at least one likely error message or mismatch pattern.
   - Explain what Lean wanted and what the learner supplied.
8. Exercises:
   - Include 3-5 exercises.
   - Mix small edits, fill-in proofs, theorem variants, and exploration tasks.

## Cell Patterns

Use Lean 4 notebook metadata when creating an `.ipynb` file:

```json
"kernelspec": {
  "display_name": "Lean 4",
  "language": "lean4",
  "name": "lean4"
}
```

Use topic-specific imports when known. Otherwise keep imports minimal and visible:

```lean
import Mathlib
```

Use `#check` to connect math names with Lean objects:

```lean
#check Nat.succ
#check Nat.add_comm
```

Use `example` for first proofs:

```lean
example (a b : Nat) : a + b = b + a := by
  exact Nat.add_comm a b
```

Use named lemmas only after the learner has seen the pattern:

```lean
lemma add_self_even (n : Nat) : ∃ k, n + n = 2 * k := by
  refine ⟨n, ?_⟩
  ring
```

If a tactic depends on imports or algebraic structure, explain that dependency near the cell.

## Lean4 Jupyter Kernel Tips

These notes are based on `utensil/lean4_jupyter`, a Lean 4 Jupyter kernel implemented through `repl`.

Basic install and smoke-test guidance:

```bash
lean --version
lake --help | head -n 1
pip install lean4_jupyter
python -m lean4_jupyter.install
jupyter kernelspec list
```

The kernel needs a working `repl` executable. A direct smoke test is:

```bash
echo '{"cmd": "#eval Lean.versionString"}' | repl
```

Prefer notebook cells that exploit the kernel's interaction model:

- Use `#check`, `#print`, and `#eval` as short inspection cells.
- Use `%cd <project-root>` at the top of project-backed notebooks so Lean picks up the right `lean-toolchain`, Lake package paths, and dependencies.
- Run `lake exe cache get` and `lake build` in the shell before notebooks that import large mathlib-backed projects.
- Put imports at the beginning of the current Lean environment. If importing in the middle of a notebook, reset first with `%env`, then import again.
- Explain that `%env` resets the Lean environment and loses prior imports/definitions unless they are reloaded.
- Use a deliberately `sorry`-based theorem only as a teaching device when demonstrating proof-state exploration, then replace it with a real proof.
- After a `sorry` theorem, use `% prove <n>` / `% proof <n>` / `%p<n>` to enter a proof state and demonstrate tactics step by step.
- Use `% env <n>` / `%e<n>` to backtrack to an earlier environment state when showing alternate paths or debugging.
- Use `%load <file.lean>` when a lesson benefits from loading an external Lean file instead of pasting a long block into the notebook.

Good notebook teaching moves:

```lean
#eval Lean.versionString
```

```lean
%cd path/to/lake/project
import Mathlib
```

```lean
theorem add_comm_demo {x y : Nat} : x + y = y + x := sorry
```

```lean
% prove 0
exact Nat.add_comm x y
```

Keep warnings about `sorry` explicit. In finished lessons, use `sorry` only in exercise cells or in clearly labeled proof-state demos.

## Project Kernel Registration

Jupyter and VS Code discover kernels by scanning kernelspec directories. A project-specific Lean kernel is just a `kernel.json` whose `argv` points to a stable launcher script.

Use the bundled helper when registering such kernels:

```bash
python scripts/register_lean4_jupyter_kernel.py \
  --project-root /path/to/lake/project \
  --venv /path/to/lake/project/.venv \
  --kernel-name project-lean4 \
  --display-name "Lean 4 Project (.venv)"
```

Preview without writing:

```bash
python scripts/register_lean4_jupyter_kernel.py \
  --project-root /path/to/lake/project \
  --venv /path/to/lake/project/.venv \
  --kernel-name project-lean4 \
  --display-name "Lean 4 Project (.venv)" \
  --dry-run
```

The helper writes:

- `<venv>/bin/<kernel-name>-jupyter-kernel`, a launcher that `cd`s to the Lake project, prepends useful PATH entries, and executes `python -m lean4_jupyter`.
- A user-level Jupyter kernelspec at `~/Library/Jupyter/kernels/<kernel-name>/kernel.json` on macOS, or the equivalent user data directory on other platforms.

For projects whose `repl` executable is not globally available, pass `--repl-bin /path/to/repl`. If omitted, the helper automatically uses `<project-root>/.lake/packages/repl/.lake/build/bin` when that directory exists.

Check registration:

```bash
jupyter kernelspec list
```

Remove it:

```bash
jupyter kernelspec remove project-lean4
```

## Math Topic Handling

For algebra:
- Emphasize types, structures, instances, and notation.
- Use `#check Group`, `#check Monoid`, or more specific APIs.

For number theory:
- Show the difference between `Nat`, `Int`, and coercions.
- Prefer small divisibility and congruence examples before deep theorems.

For analysis:
- Introduce filters, limits, topology, and metric assumptions slowly.
- Use API inspection cells before proofs.

For linear algebra:
- Separate informal vectors/matrices from Lean's typeclass-heavy vector spaces.
- Show the scalar field/ring explicitly.

For logic and set theory:
- Use propositions-as-types, quantifiers, rewriting, and extensionality as the main story.

## Bilingual Style

In bilingual mode, keep the rhythm:

```markdown
中文：这一步把交换律作为一个 Lean 定理来调用。

English: This step calls commutativity as an existing Lean theorem.
```

Avoid writing two full lessons in one notebook. The English line should clarify terminology, not double the length.

## Validation Checklist

Before finishing:

- The output is valid `.ipynb` JSON if the task asks for a file.
- The notebook has markdown and Lean code cells, not markdown only.
- The first Lean cell is a setup or smoke test.
- Each major concept has a nearby Lean cell.
- Hard formalization boundaries are named honestly.
- Language mode matches the user's request.
- Exercises are concrete and small enough to attempt.

## Reference Links

- `lean4_jupyter`: https://github.com/utensil/lean4_jupyter
- PyPI package: https://pypi.org/project/lean4-jupyter/
- Tutorial notebook: https://github.com/utensil/lean4_jupyter/blob/main/examples/00_tutorial.ipynb
- Project import notebook: https://github.com/utensil/lean4_jupyter/blob/main/examples/03_import.ipynb
