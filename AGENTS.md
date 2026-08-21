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

### Public Modules

- **ucd/** (`moonbit-community/ucd`): Unicode Character Database lookup, case mapping,
  and general category APIs
- **normalization/** (`moonbit-community/normalization`): UAX #15 Unicode normalization
- **punycode/** (`moonbit-community/punycode`): RFC 3492 Punycode encoding/decoding
  - `encode(String) -> String raise PunycodeError`
  - `decode(String) -> String raise PunycodeError`
- **bidi/** (`moonbit-community/bidi`): UAX #9 bidirectional text processing
- **idna/** (`moonbit-community/idna`): UTS #46 IDNA processing
  - `to_ascii()` - convert domain to ASCII (Punycode)
  - `to_unicode()` - convert domain from Punycode
- **unicode/** (`moonbit-community/unicode`): compatibility umbrella preserving the old
  package paths
- **conformance/** (`moonbit-community/unicode-conformance`): workspace-only generated
  conformance tests; it is not a published dependency

### Internal Data Packages (auto-generated)

- **ucd/data/**: Unicode Character Database lookup tables
- **idna/internal/idna/**: IDNA mapping and joining tables
- **bidi/internal/bidi/**: Bidi mirroring and bracket tables

### Dependencies

```
normalization -> ucd
idna -> ucd
idna -> normalization
idna -> punycode
idna -> bidi
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
moon package --list          # Verify the compatibility umbrella
moon -C bidi package --list  # Verify an individual feature module
```

## Testing Notes

- Unit tests: `*_test.mbt` files with `test` blocks and `inspect()` assertions
- Conformance tests: Large generated test files (millions of lines) from Unicode test suites
- Fuzz tests: `fuzz_test.mbt` files for property-based testing

## Commit Convention

Uses conventional commits: `fix:`, `feat:`, `refactor:`, `test:`, `chore:`, `release:`
