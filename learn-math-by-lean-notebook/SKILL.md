---
name: learn-math-by-lean-notebook
description: Generate Jupyter notebooks that teach mathematics through Lean 4 and mathlib by interleaving compact bilingual-capable explanations, runnable Lean code cells, proof experiments, and small exercises. Use when the user asks to learn a math topic with Lean, wants a Lean 4/mathlib tutorial notebook, requests Chinese or English math-learning notebooks, or wants a theory-plus-formalization lesson in .ipynb form.
---

# Learn Math by Lean Notebook

Create a real `.ipynb` tutorial for a user-chosen mathematics topic using Lean 4 and mathlib as the executable medium. Match the rhythm of a theory-practice notebook: explain one idea, run or inspect a small Lean fragment, then build toward a modest theorem or proof pattern.

Default to Chinese prose when the user writes in Chinese, English prose when the user writes in English, and bilingual prose only when the user asks for it or says "中英文", "bilingual", or similar. Lean code, theorem names, identifiers, comments, and error labels should stay in English.

## Workflow

1. Infer the topic, target level, and requested language. If unclear, assume a curious beginner who can read basic Lean syntax.
2. Read `references/notebook-style.md` before generating a notebook unless the task is only a quick outline.
3. Choose one concrete end point: a formalized theorem, a reusable proof pattern, a small computation, a structure/API tour, or a Lean/mathlib translation of a familiar mathematical argument.
4. Build the notebook as a sequence:
   - Title cell with the topic and language-appropriate subtitle.
   - Environment cell explaining the expected Lean 4/Jupyter setup.
   - Roadmap cell with 3-6 steps.
   - Concept blocks: short math explanation, then a focused Lean cell.
   - Proof blocks: definitions or examples first, lemmas next, final theorem last.
   - Debugging blocks: common Lean errors and how to read them.
   - Exercises: 3-5 small modifications or proofs.
5. Save a valid `.ipynb` file. Prefer notebook-native JSON over prose-only drafts when the user asks to create the notebook.

When the user asks to register, create, debug, or document a project-specific Lean 4 Jupyter kernel, use `scripts/register_lean4_jupyter_kernel.py` as the canonical helper and read the kernel registration section in `references/notebook-style.md`.

## Notebook Rules

- Keep markdown cells short. Do not write a textbook chapter before the first Lean cell.
- Put every abstract idea near a runnable Lean example, `#check`, `#eval`, `example`, `lemma`, or `theorem`.
- Prefer mathlib's existing names and APIs. Use `#check`, `#find`, or local search when working in a real Lean project.
- Avoid fake Lean. If a proof is likely hard, mark it as an exercise or use an honest intermediate theorem instead of inventing unsupported code.
- Keep code cells focused. One cell should introduce one definition, API, proof move, or theorem.
- Use comments only where they orient the learner.
- Include expected outcomes in markdown near cells that may require an external Lean kernel.

## Lean Style

- Use Lean 4 syntax: `fun x => ...`, `<|` when it improves readability, and no empty lines inside declarations.
- Name examples and lemmas in English when names matter.
- Prefer small proofs with `by`, `simp`, `rw`, `ring`, `omega`, `linarith`, and explicit intermediate lemmas when appropriate.
- Do not hide hard formalization gaps behind `set_option maxHeartbeats`.

## Bundled Reference

Read `references/notebook-style.md` for the recommended notebook shape, language modes, Lean cell patterns, and validation checklist.
