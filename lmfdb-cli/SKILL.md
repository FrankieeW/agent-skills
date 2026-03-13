---
name: lmfdb-cli
description: Query LMFDB to verify number theory results, including number field properties, elliptic curve data, and algebraic number theory computations.
---

# Querying LMFDB for Mathematical Verification

Use `lmfdb` CLI to look up concrete examples and verify results against the [LMFDB](https://www.lmfdb.org/) database.

## Installation

```bash
brew tap frankieew/tap && brew install lmfdb-cli
# or build from source: go build -o lmfdb ./cmd/lmfdb
```

## Number Fields (`nf`)

### Quick Reference

```bash
lmfdb nf [options]
```

| Flag | Meaning | Example |
|------|---------|---------|
| `-d <n>` | Degree [Q(α):Q] | `-d 3` (cubic fields) |
| `-n <n>` | Number of results | `-n 50` |
| `--disc <val>` | Discriminant | `--disc -23` |
| `--class <n>` | Class number h(K) | `--class 1` |
| `--sig <r1,r2>` | Signature (r₁,r₂) | `--sig 0,1` (totally imaginary) |
| `--id <label>` | Specific field by LMFDB label | `--id 2.0.3.1` |
| `--sort <field>` | Sort (prefix `-` for desc) | `--sort -disc` |
| `-f <fields>` | Select specific fields | `-f label,disc,class_number` |
| `--fmt json` | Output as JSON | `--fmt json` |
| `-o <file>` | Save to file | `-o results.csv --fmt csv` |
| `--browser` | Bypass reCAPTCHA | for large queries |

### Common Verification Tasks

**Find all quadratic fields with class number 1:**
```bash
lmfdb nf -d 2 --class 1 -n 100
```

**Check imaginary quadratic fields (signature (0,1)):**
```bash
lmfdb nf -d 2 --sig 0,1 -n 50
```

**Look up a specific number field by label:**
```bash
lmfdb nf --id 2.0.3.1
# Returns full record: discriminant, class number, Galois group, regulator, etc.
```

**Cubic fields sorted by discriminant:**
```bash
lmfdb nf -d 3 --sort disc -n 20
```

**Totally real quartic fields:**
```bash
lmfdb nf -d 4 --sig 4,0 -n 20
```

**Export for further analysis:**
```bash
lmfdb nf -d 2 -n 200 -f label,disc,class_number,regulator --fmt json -o quadratic_fields.json
```

### LMFDB Number Field Labels

Format: `d.r.D.n` where:
- `d` = degree
- `r` = number of real embeddings (0 or positive)
- `D` = absolute discriminant
- `n` = index among fields with same (d, r, D)

Example: `2.0.3.1` = degree 2, no real embeddings, |disc| = 3, first such field = Q(√-3)

### Available Fields for `-f`

Key fields in `nf_fields` collection:
- `label` — LMFDB label
- `degree` — [K:Q]
- `disc` — discriminant Δ_K
- `class_number` — h(K)
- `class_group` — structure of Cl(K)
- `signature` — [r₁, r₂]
- `regulator` — regulator R_K
- `galt` — Galois group (transitive group label)
- `subfields` — subfield labels
- `zk` — integral basis
- `coeffs` — minimal polynomial coefficients

## Elliptic Curves (`ec`)

### Quick Reference

```bash
lmfdb ec [options]
```

| Flag | Meaning | Example |
|------|---------|---------|
| `-r <n>` | Mordell-Weil rank | `-r 2` |
| `-t <n>` | Torsion order | `-t 7` |
| `--conductor <n>` | Conductor N | `--conductor 11` |
| `-n <n>` | Number of results | `-n 50` |
| `--sort <field>` | Sort | `--sort conductor` |
| `-f <fields>` | Select fields | `-f lmfdb_label,rank,conductor` |

### Common Verification Tasks

**Find rank 2 elliptic curves:**
```bash
lmfdb ec -r 2 -n 20
```

**Curves with torsion group of order 7:**
```bash
lmfdb ec -t 7 -n 10
```

**Curves of conductor 11:**
```bash
lmfdb ec --conductor 11 --fmt json
```

**Export rank data for analysis:**
```bash
lmfdb ec -r 0 -n 100 -f lmfdb_label,conductor,torsion_structure --fmt csv -o rank0_curves.csv
```

## Other Collections

```bash
lmfdb list   # Show all available collections
```

Available: number fields, elliptic curves, genus 2 curves, Dirichlet characters, Maass forms, modular forms, local fields, Artin representations, Belyi maps.

## Tips

- **reCAPTCHA blocking**: For large queries (n > 50), use `--browser` flag. Run `lmfdb install-browser` first to download Chromium.
- **JSON for parsing**: Use `--fmt json` when you need to process results programmatically.
- **Pagination**: Combine `-n` and `--offset` to page through large result sets.
- **Specific fields**: Use `-f` to request only the fields you need — makes output cleaner and queries faster.
