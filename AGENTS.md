# AGENTS.md

This file provides guidance to code agents (Claude Code, Codex, etc.) when working with code in this repository.

## Project Overview

A MoonBit library implementing Unicode standards: text normalization (UAX #15), Punycode (RFC 3492), and IDNA (UTS #46). Targets Unicode 16.0.0.

## Build Commands

```bash
moon check          # Type check
moon test           # Run all tests
moon test -p <pkg>  # Test specific package (e.g., moon test -p punycode)
moon fmt            # Format code
moon build          # Build project
moon info           # Regenerate pkg.generated.mbti files
```

## Architecture

### Public Packages

- **punycode/**: RFC 3492 Punycode encoding/decoding
  - `encode(String) -> String raise PunycodeError`
  - `decode(String) -> String raise PunycodeError`

- **normalization/**: UAX #15 Unicode normalization
  - `nfc()`, `nfd()`, `nfkc()`, `nfkd()` - normalization forms
  - `normalize()`, `is_normalized()` - general API

- **idna/**: UTS #46 IDNA processing
  - `to_ascii()` - convert domain to ASCII (Punycode)
  - `to_unicode()` - convert domain from Punycode

- **Root package**: Case mapping and general category
  - `to_simple_uppercase/lowercase/titlecase(Char) -> Char`
  - `general_category(Char) -> GeneralCategory`

### Internal Data Packages (auto-generated)

- **internal/ucd/**: Unicode Character Database lookup tables (CCC, decomposition, composition, case mapping, general category)
- **internal/idna/**: IDNA-specific data (mapping, bidi, joining rules)

### Dependencies

```
idna -> normalization -> internal/ucd
idna -> punycode
idna -> internal/idna
```

## Code Generation

Unicode data tables are generated from official Unicode source files:

```bash
moon run --target native tools/gen data   # Generate all Unicode lookup tables
moon run --target native tools/gen tests  # Generate all conformance tests
moon run --target native tools/gen all    # Generate tables and tests
```

Individual commands are `ucd`, `idna`, `bidi`, `normalization-tests`,
`idna-tests`, and `bidi-tests`. Downloaded Unicode data is cached in
`tools/.cache/`.

## Publishing

```bash
moon publish --dry-run  # Verify files selected by moon.mod exclusions
```

## Testing Notes

- Unit tests: `*_test.mbt` files with `test` blocks and `inspect()` assertions
- Conformance tests: Large generated test files (millions of lines) from Unicode test suites
- Fuzz tests: `fuzz_test.mbt` files for property-based testing

## Commit Convention

Uses conventional commits: `fix:`, `feat:`, `refactor:`, `test:`, `chore:`, `release:`
