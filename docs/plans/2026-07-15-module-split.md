# Unicode Module Split

Status: Validated

## Outcome

Split the published `moonbit-community/unicode` module into independently consumable
modules so users only download the Unicode functionality they use:

- `moonbit-community/ucd`
- `moonbit-community/normalization`
- `moonbit-community/punycode`
- `moonbit-community/bidi`
- `moonbit-community/idna`

Keep `moonbit-community/unicode` as a compatibility umbrella whose existing package
paths forward to the new modules.

## Boundaries

- Each feature module owns its public types and implementation data.
- `moonbit-community/ucd/data` exposes the low-level table lookups required by
  normalization and IDNA; user-facing case and category APIs remain at
  `moonbit-community/ucd`.
- `BidiClass` is owned by the public `moonbit-community/bidi` package rather than an
  internal package.
- `moonbit-community/idna` depends on UCD, normalization, Punycode, and Bidi.
- No persistence, wire-format, security-policy, or third-party dependency
  changes are included.

## Tests and generation

Unit and fuzz tests stay with their owning feature modules. Large generated
Unicode, IDNA, and Bidi conformance fixtures move to a workspace-only
`moonbit-community/unicode-conformance` module. They remain part of local and CI test
runs but are excluded from published `.mooncakes` archives.

The existing `moonbit-community/unicode-tools` module remains workspace-only and is
updated to emit data, interfaces, and conformance fixtures at the new paths.

## Compatibility

The umbrella module keeps the existing public package paths:

- `moonbit-community/unicode`
- `moonbit-community/unicode/normalization`
- `moonbit-community/unicode/punycode`
- `moonbit-community/unicode/bidi`
- `moonbit-community/unicode/idna`

These packages are thin facades over the new modules. New consumers should
depend directly on the feature module they need.

## Validation

1. Run `moon fmt` and `moon info` for the workspace.
2. Run `moon check` and `moon test` for every feature module and for the whole
   workspace.
3. Regenerate all Unicode data and conformance fixtures, then repeat checks.
4. Run `moon package --list` in every published module.
5. Record archive sizes and verify conformance fixtures are absent.

## Validation evidence

- `moon run --target native tools/gen all` completed with cached Unicode 16.0.0
  source data and the default Bidi part size of 500.
- `moon fmt`, `moon info`, and `moon check` completed without warnings.
- `moon test` passed all 8422 tests, including the workspace-only generated
  conformance suites and legacy-package compatibility tests.
- The five compatibility `.mbti` files are identical to the interfaces at
  commit `f3e356f1`.
- `moon package --list` and zip integrity checks passed for all six published
  modules. No archive contains a conformance path.
- Archive sizes are 16 KB (`unicode`), 137 KB (`ucd`), 15 KB
  (`normalization`), 10 KB (`punycode`), 27 KB (`bidi`), and 107 KB (`idna`).

## Rollback

The split is delivered in coherent commits. Before publication, rollback is a
normal Git revert to the original single-module layout; no external state or
stored data migration is involved.
