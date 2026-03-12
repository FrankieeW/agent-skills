---
name: lmfdb-cli
description: >
  Use lmfdb-cli to query the LMFDB database for verifying number field conjectures and results. Use when: verifying number field properties (discriminants, class numbers, Galois groups, signatures), checking elliptic curve data, or validating algebraic number theory computations against LMFDB.
---

# lmfdb-cli Development Guide

A pure Go CLI for querying the [LMFDB](https://www.lmfdb.org/) mathematical database. Single-file architecture with chromedp for reCAPTCHA bypass.

## Architecture

```
cmd/lmfdb/main.go    # All CLI logic (single file)
go.mod               # Go 1.24+, chromedp dependency
.github/workflows/   # CI: cross-platform builds
```

**Design decisions:**
- Single-file CLI (`cmd/lmfdb/main.go`) — keeps distribution simple
- `flag.NewFlagSet` per subcommand (no cobra/urfave)
- Two-tier API: direct HTTP first, headless Chrome fallback for reCAPTCHA
- ANSI color output for JSON syntax highlighting (no external library)

## Build & Run

```bash
# Build
go build -o lmfdb ./cmd/lmfdb

# Quick test
./lmfdb nf -d 2 -n 5
./lmfdb ec -r 2 --fmt json
./lmfdb list
./lmfdb version
```

## LMFDB API Patterns

### URL Construction

LMFDB API uses type-prefixed query parameters:

```
https://www.lmfdb.org/api/<collection>/?_format=json&_limit=N&field=<type><value>
```

**Type prefixes:**
| Prefix | Type    | Example              |
|--------|---------|----------------------|
| `i`    | integer | `degree=i2`          |
| `s`    | string  | `label=s2.0.3.1`     |
| `li`   | int list| `signature=li0;1`    |
| `ls`   | str list| `...=lsa;b`          |

**Collections:** `nf_fields` (number fields), `ec_curvedata` (elliptic curves), and many more via `lmfdb list`.

### Adding a New Collection

Follow the existing pattern in `main.go`:

1. **Define options struct:**
```go
type NewCollectionOptions struct {
    Limit, Offset int
    Sort, Fields   string
    Output, Format string
    Quiet, Browser bool
    // collection-specific fields...
}
```

2. **Add subcommand parsing** in `main()`:
```go
case "newcmd":
    cmd := flag.NewFlagSet("newcmd", flag.ExitOnError)
    cmd.IntVar(&limit, "n", 10, "Number of results")
    // ... more flags
    cmd.Parse(os.Args[2:])
    queryNewCollection(opts)
```

3. **Implement query function** following `queryNumberFields` / `queryEllipticCurves` pattern:
```go
func queryNewCollection(opts NewCollectionOptions) {
    url := "https://www.lmfdb.org/api/collection_name/?_format=json"
    url += fmt.Sprintf("&_limit=%d", opts.Limit)
    // Build query params with type prefixes
    if opts.SomeField != "" {
        url += "&field=" + opts.SomeField
    }
    // Use queryAPI(url) or queryWithBrowser(url) based on opts.Browser
}
```

4. **Register in help text** and `list` command output.

## Output Formatting

Three formats via `--fmt` flag:

| Format  | Function       | Notes                          |
|---------|----------------|--------------------------------|
| `table` | `printTable()` | Auto-selects up to 6 columns, truncates at 14 chars |
| `json`  | `printColorJSON()` | ANSI syntax highlighting (cyan/green/yellow/magenta) |
| `csv`   | `writeCSV()`   | Standard encoding/csv          |

When adding output, reuse `printTable()` — it auto-adapts columns from JSON keys.

## reCAPTCHA Bypass

The `--browser` flag activates headless Chrome via chromedp:

```go
func queryWithBrowser(url string) ([]byte, error) {
    ctx, cancel := chromedp.NewContext(context.Background())
    defer cancel()
    // Navigate, wait for JSON content, extract body
}
```

- `queryAPI()` tries direct HTTP first
- If response contains reCAPTCHA HTML, suggest `--browser` flag
- `install-browser` subcommand downloads Chromium

## Cross-Platform Build

GitHub Actions builds for 5 targets:

```yaml
matrix:
  include:
    - {goos: linux,   goarch: amd64}
    - {goos: linux,   goarch: arm64}
    - {goos: darwin,  goarch: amd64}
    - {goos: darwin,  goarch: arm64}
    - {goos: windows, goarch: amd64}
```

**Release flow:** git tag `v*` → builds → GitHub Release with binaries.

**Homebrew:** `brew tap frankieew/tap && brew install lmfdb-cli`

## Testing Guidelines

Currently no tests. When adding tests:

```go
// cmd/lmfdb/main_test.go or extract to packages

func TestBuildURL(t *testing.T) {
    tests := []struct {
        name     string
        opts     NumberFieldOptions
        expected string
    }{
        {"degree 2", NumberFieldOptions{Degree: 2}, "...degree=i2..."},
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got := buildNumberFieldURL(tt.opts)
            if got != tt.expected {
                t.Errorf("got %s, want %s", got, tt.expected)
            }
        })
    }
}
```

**Priority test targets:** URL construction, JSON parsing, output formatting, reCAPTCHA detection.

## Common Tasks

| Task | Approach |
|------|----------|
| Add query filter | Add flag to options struct + URL builder |
| New output column | Modify `printTable()` column selection |
| New collection | Follow "Adding a New Collection" pattern above |
| Fix reCAPTCHA | Debug in `queryWithBrowser()`, check chromedp selectors |
| Update version | Change `version` const in `main.go`, tag with `git tag v*` |

## Resources

- [LMFDB API Docs](https://www.lmfdb.org/api/)
- [LMFDB Website](https://www.lmfdb.org/)
- [chromedp Documentation](https://pkg.go.dev/github.com/chromedp/chromedp)
- [Homebrew Tap](https://github.com/frankieew/homebrew-tap)
