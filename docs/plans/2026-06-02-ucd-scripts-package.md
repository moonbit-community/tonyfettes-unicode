# UCD Scripts Package

## Goal

Create a scripts-local MoonBit UCD package that holds pure parsing, table-building, and emit logic currently embedded in `scripts/generate_ucd.py`.

## Accepted Design

- Add a separate MoonBit project under `scripts/` so generator dependencies and tests do not affect the root Unicode library package.
- Add `scripts/ucd/` as a library package.
- Keep this first step pure: no downloading, no filesystem writes, and no CLI entrypoint.
- Model parsed UCD records and generated table inputs as package-local structs where possible, exposing only the functions future generator commands need.
- Emit functions return `String` so they can be tested directly and later written by a CLI package.

## Target Files And Surfaces

- `scripts/moon.mod`
- `scripts/ucd/moon.pkg`
- `scripts/ucd/*.mbt`
- `scripts/ucd/*_test.mbt`

## API / Interface Diff

New package: `tonyfettes/unicode-scripts/ucd`.

Expected public functions:

- `parse_unicode_data(String) -> UnicodeData raise`
- `parse_composition_exclusions(String) -> Array[Int] raise`
- `parse_special_casing(String) -> SpecialCasingData raise`
- `build_composition_table(UnicodeData, Array[Int]) -> Array[CompositionEntry]`
- `compress_ccc_ranges(UnicodeData) -> Array[CccRange]`
- `compress_mark_ranges(UnicodeData) -> Array[CodePointRange]`
- `compress_general_category_ranges(UnicodeData) -> Array[GeneralCategoryRange]`
- emit functions that return generated `.mbt` source as `String`

No root package API changes are intended.

## Open Questions

- Whether the final generator should expose one `cmd/gen` CLI with subcommands or compatibility wrapper scripts for the old Python filenames.
- Whether download support should use `moonbitlang/async/http` directly or stay separate from pure generator logic.

## Next Implementation Step

Create the `scripts/` MoonBit project and implement the UCD package with focused unit tests for parsing, range compression, composition derivation, and small emitter snapshots.

## Validation Plan

- `moon -C scripts check`
- `moon -C scripts test`
- `moon -C scripts fmt`
- `moon -C scripts info`
- Review `scripts/ucd/pkg.generated.mbti` to confirm only intentional API is exposed.

## Checkpoint: Emitter Refactor

Goal: centralize generated-source writing helpers in a reusable package so UCD emit functions do not pass raw `StringBuilder` values around or duplicate integer-array formatting.

Accepted design:

- Add a separate `scripts/emitter/` package.
- Expose an opaque `Emitter` type from `tonyfettes/unicode-scripts/emitter`.
- Move raw text writing, generated-file header writing, integer array emission, and finish-to-string behavior onto `Emitter`.
- Keep existing public `emit_*` functions and generated output unchanged.

Target files/surfaces:

- `scripts/emitter/moon.pkg`
- `scripts/emitter/emitter.mbt`
- `scripts/ucd/emit.mbt`
- `scripts/ucd/moon.pkg`

API/interface diff:

- New package: `tonyfettes/unicode-scripts/emitter`.
- `scripts/ucd/pkg.generated.mbti` should not add UCD public functions or expose UCD internals.
- `scripts/ucd/moon.pkg` imports `tonyfettes/unicode-scripts/emitter`.

Open questions:

- Whether later packages should import `emitter` directly or whether a broader `scripts/common` package should re-export it.

Next implementation step:

- Move `Emitter` into `scripts/emitter/` and refactor UCD emit functions to call `@emitter.Emitter` methods.

Validation plan:

- `moon -C scripts check`
- `moon -C scripts test`
- `moon -C scripts fmt`
- `moon -C scripts info`
- Review `scripts/emitter/pkg.generated.mbti` and `scripts/ucd/pkg.generated.mbti` for intentional public API only.
