# AGENTS.md

This file provides guidance to code agents (Claude Code, Codex, etc.) when working with code in this repository.

## Project Overview

A MoonBit library implementing Unicode standards: text normalization (UAX #15), Punycode (RFC 3492), IDNA (UTS #46), bidirectional text (UAX #9), and text segmentation (UAX #29). Targets Unicode 18.0.0.

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

- **ucd/** (`moonbit-community/unicode-data`): Unicode Character Database lookup,
  case mapping, and general category APIs
- **normalization/** (`moonbit-community/unicode-normalization`): UAX #15 Unicode
  normalization
- **casefold/** (`moonbit-community/unicode-casefold`): full case folding,
  canonical caseless matching, and NFKC_Casefold
- **punycode/** (`moonbit-community/punycode`): RFC 3492 Punycode encoding/decoding
  - `encode(String) -> String raise PunycodeError`
  - `decode(String) -> String raise PunycodeError`
- **bidi/** (`moonbit-community/unicode-bidi`): UAX #9 bidirectional text processing
- **segmentation/** (`moonbit-community/unicode-segmentation`): UAX #29 text segmentation
  - `graphemes(StringView) -> Graphemes` - cursor over extended grapheme clusters
    (`iter()` for `for .. in`, `next()` returning an empty view at the end)
- **idna/** (`moonbit-community/unicode-idna`): UTS #46 IDNA processing
  - `to_ascii()` - convert domain to ASCII (Punycode)
  - `to_unicode()` - convert domain from Punycode
- **unicode/** (`moonbit-community/unicode`): compatibility umbrella preserving the old
  package paths
- **tests/** (`moonbit-community/unicode-tests`): workspace-only conformance tests.
  They read the official Unicode test data files committed under `tests/data/`
  directly at run time with `moonbitlang/async`; no test code is generated

- **bench/** (`local/unicode-bench`): workspace-only benchmarks. `normperf/`
  measures normalization with `moon bench`; `xlang/` compares every module with
  other languages' libraries (`moon run --target native bench/xlang`), with one
  standalone harness per language in its subdirectories

### Internal Data Packages (auto-generated)

- **ucd/data/**: Unicode Character Database lookup tables
- **casefold/case_folding_data.mbt**, **casefold/nfkc_casefold_data.mbt**:
  full default case folding and NFKC_CF mappings
- **ucd/line_break.mbt**, **ucd/joining_group.mbt**: the `LineBreak` and
  `JoiningGroup` enums of the root package, generated so that they stay in
  step with the ordinals in `ucd/line_break/` and `ucd/joining_group/`
- **idna/internal/idna/**: IDNA mapping table (Joining_Type comes from
  `unicode-data`)
- **bidi/internal/bidi/**: Bidi mirroring and bracket tables
- **segmentation/grapheme_break_property.mbt**: grapheme cluster break properties

### Dependencies

```
unicode-normalization -> unicode-data
unicode-casefold -> unicode-normalization
unicode-idna -> unicode-data
unicode-idna -> unicode-normalization
unicode-idna -> punycode
unicode-idna -> unicode-bidi
```

## Code Generation

Unicode data tables are generated from official Unicode source files:

```bash
moon run --target native tools/gen data   # Generate all Unicode lookup tables
moon run --target native tools/gen all    # Alias for `data`
```

Individual commands are `ucd`, `casefold`, `idna`, `bidi`, and `segmentation`.
`casefold` regenerates folding tables only and is also included in `data` / `all`. Downloaded
Unicode data is cached per version in `tools/.cache/<version>/`.

## Conformance Tests

Conformance tests live in the workspace-only `tests/` module and read the
official Unicode test files (`BidiTest.txt`, `BidiCharacterTest.txt`,
`NormalizationTest.txt`, `IdnaTestV2.txt`, `GraphemeBreakTest.txt`) directly at
test time via
`moonbitlang/async`. The data files are committed under `tests/data/`, so the
test module keeps its `moonbitlang/async` dependency separate from the
published modules.

Case folding conformance tests also read `CaseFolding.txt` and
`DerivedNormalizationProps.txt`, checking every Unicode scalar value against
the full default folding and NFKC_CF mappings.

## Publishing

```bash
moon -C unicode package --list  # Verify the compatibility umbrella
moon -C bidi package --list     # Verify an individual feature module
```

## Testing Notes

- Unit tests: `*_test.mbt` files with `test` blocks and `inspect()` assertions
- Conformance tests: `tests/` module (`moonbit-community/unicode-tests`), which
  reads the Unicode test data files in `tests/data/` at run time
- Fuzz tests: `fuzz_test.mbt` files for property-based testing

## Commit Convention

Uses conventional commits: `fix:`, `feat:`, `refactor:`, `test:`, `chore:`, `release:`
