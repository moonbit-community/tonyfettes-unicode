# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MoonBit Unicode library (`tonyfettes/unicode`) implementing Unicode standards:

- **Normalization** (UAX #15): NFD, NFC, NFKD, NFKC forms
- **Punycode** (RFC 3492): Encoding/decoding for internationalized domain names
- **IDNA** (UTS #46): Internationalized Domain Names in Applications processing

## Build and Test Commands

```bash
moon check          # Type check the project
moon test           # Run all tests
moon test -p <pkg>  # Run tests for a specific package (e.g., moon test -p normalization)
moon fmt            # Format code
moon doc            # Generate documentation
```

## Architecture

### Public Packages

- `codepoint/` - CodePoint type wrapper around Int with validation
- `normalization/` - Unicode normalization (NFD/NFC/NFKD/NFKC)
- `punycode/` - RFC 3492 Punycode encoding/decoding
- `idna/` - UTS #46 domain name processing (uses punycode + normalization)

### Internal Packages

- `internal/ucd/` - Unicode Character Database lookup tables (CCC, decomposition, composition)
- `internal/idna/` - IDNA-specific data (mapping, bidi class, joining type)
- `internal/fuzz/` - Shared fuzz testing utilities

### Generated Data Files

Unicode data tables in `internal/ucd/` and `internal/idna/` are **generated** from official Unicode data files by Python scripts:

```bash
python3 scripts/generate_ucd.py   # Generates internal/ucd/*.mbt (CCC, decomposition, composition)
python3 scripts/generate_idna.py  # Generates internal/idna/*.mbt (mapping, bidi, joining)
```

Downloaded Unicode data is cached in `scripts/.cache/`. Data files target Unicode 16.0.0.

### Key Implementation Details

- **Hangul syllables**: Handled algorithmically (not in lookup tables) - see `normalization/hangul.mbt`
- **Binary search**: All lookup functions use binary search over sorted ranges. **Critical**: Generated data arrays must be sorted by start code point - the generation scripts sort entries before writing.
- **Fuzz testing**: Property-based tests in `*_test.mbt` files verify invariants (idempotence, canonical equivalence, CCC ordering)
- **IDNA nontransitional mode**: Deviation characters (like ZWNJ U+200C) are kept, not removed

## Package Dependencies

```
idna -> punycode, normalization, internal/idna, internal/ucd
normalization -> internal/ucd
```
