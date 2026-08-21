# MoonBit Unicode Generators

Status: completed on 2026-07-15.

## Final Design

- Generator code lives in the separate `tools/` MoonBit module, keeping its
  native async dependency out of the published library.
- `tools/gen` is the single native CLI for UCD, IDNA, Bidi, and conformance
  generation.
- Parsing and emission are separate packages. Pure generator functions return
  source strings or lazily produced Bidi parts so they can be tested directly.
- `tools/emitter` owns generated-source writing. Other tool packages do not use
  `StringBuilder` directly.
- Unicode downloads are cached in `tools/.cache/`.
- Bidi conformance output is streamed by part, then formatted and followed by a
  targeted `moon info` run.

## Packages

- `moonbit-community/unicode-tools/emitter`
- `moonbit-community/unicode-tools/support`
- `moonbit-community/unicode-tools/ucd`
- `moonbit-community/unicode-tools/idna_data`
- `moonbit-community/unicode-tools/bidi_data`
- `moonbit-community/unicode-tools/normalization_tests`
- `moonbit-community/unicode-tools/idna_tests`
- `moonbit-community/unicode-tools/bidi_tests`
- `moonbit-community/unicode-tools/gen`

## Commands

```bash
moon run --target native tools/gen data
moon run --target native tools/gen tests
moon run --target native tools/gen all
```

The previous Python generators and publishing collector were removed. Package
selection is handled by the root `moon.mod` exclusions and can be checked with
`moon publish --dry-run`.
