# Symbol Names

Source: https://leanprover-community.github.io/contribute/naming.html

Use this dictionary when translating theorem statements into names.

## Logic

| Symbol | Name |
| --- | --- |
| `∨` | `or` |
| `∧` | `and` |
| `→` | `of` / `imp` |
| `↔` | `iff` |
| `¬` | `not` |
| `∃` | `exists` |
| `∀` | `all` / `forall` |
| `=` | `eq`, often omitted |
| `≠` | `ne` |
| `∘` | `comp` |

`ball` and `bex` still appear in Lean core but should not be used in mathlib
names.

## Sets

| Symbol | Name |
| --- | --- |
| `∈` | `mem` |
| `∉` | `notMem` |
| `∪` | `union` |
| `∩` | `inter` |
| `⋃` | `iUnion` / `biUnion` |
| `⋂` | `iInter` / `biInter` |
| `⋃₀` | `sUnion` |
| `⋂₀` | `sInter` |
| `\` | `sdiff` |
| `ᶜ` | `compl` |
| `{x | p x}` | `setOf` |
| `{x}` | `singleton` |
| `{x, y}` | `pair` |

## Algebra

| Symbol | Name |
| --- | --- |
| `0` | `zero` |
| `+` | `add` |
| unary `-` | `neg` |
| binary `-` | `sub` |
| `1` | `one` |
| `*` | `mul` |
| `^` | `pow` |
| `/` | `div` |
| `•` | `smul` |
| `⁻¹` | `inv` |
| `⅟` | `invOf` |
| `∣` | `dvd` |
| `∑` | `sum` |
| `∏` | `prod` |

## Order and Lattices

| Symbol | Name |
| --- | --- |
| `<` | `lt` / `gt` |
| `≤` | `le` / `ge` |
| `⊔` | `sup` |
| `⊓` | `inf` |
| `⨆` | `iSup` / `biSup` / `ciSup` |
| `⨅` | `iInf` / `biInf` / `ciInf` |
| `⊥` | `bot` |
| `⊤` | `top` |

Use `ge`/`gt` when argument order is swapped or when it matches another
relation's argument order.

## Hypotheses

Use `of` to separate hypotheses, in statement order:

```text
A → B → C   becomes   C_of_A_of_B
```
