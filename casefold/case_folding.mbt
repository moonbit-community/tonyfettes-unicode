///|
/// Unicode default full case folding (section 3.13, R4).
/// Locale-independent: uses the C and F mappings in CaseFolding.txt, including
/// expansions such as ß -> ss. Does not normalize or apply Turkic tailoring.
pub fn case_fold(s : StringView) -> String {
  fold(s, Full)
}

///|
/// The folding tables of this package. Both fold ASCII alike, mapping only
/// A-Z, to a-z.
priv enum Folding {
  /// Full default case folding, from CaseFolding.txt.
  Full
  /// NFKC_Casefold, before the final NFC.
  Nfkc
}

///|
/// The generated kind of a code point that folds to itself.
const KindIdentity : Int32 = 0

///|
/// The generated kind of a code point whose mapping `Folding::lookup` finds.
const KindSearched : Int32 = 1

///|
fn Folding::kind(self : Folding, c : Char) -> Int32 {
  match self {
    Full => case_folding_kind(c)
    Nfkc => nfkc_casefold_kind(c)
  }
}

///|
/// The code point delta of a kind from 2 on.
fn Folding::delta(self : Folding, kind : Int32) -> Int32 {
  match self {
    Full => case_folding_deltas[kind]
    Nfkc => nfkc_casefold_deltas[kind]
  }
}

///|
/// The mapping of a code point of kind `KindSearched`.
fn Folding::lookup(self : Folding, c : Char) -> StringView? {
  match self {
    Full => lookup_case_folding(c)
    Nfkc => lookup_nfkc_casefold(c)
  }
}

///|
/// The code point starting at `index`. An unpaired surrogate is returned as
/// it is, as iterating over the view does.
fn code_point_at(s : StringView, index : Int32, length : Int32) -> Int32 {
  // SAFETY: callers guarantee 0 <= index < length.
  let first = s.unsafe_get(index)
  if first.is_leading_surrogate() && index + 1 < length {
    // SAFETY: index + 1 < length is checked above.
    let second = s.unsafe_get(index + 1)
    if second.is_trailing_surrogate() {
      return 0x10000 +
        ((first.to_int() - 0xD800) << 10) +
        second.to_int() -
        0xDC00
    }
  }
  first.to_int()
}

///|
/// Whether the code point `cp` folds to something other than itself.
fn Folding::changes(self : Folding, cp : Int32) -> Bool {
  if cp < 0x80 {
    cp >= 'A' && cp <= 'Z'
  } else {
    self.kind(cp.unsafe_to_char()) != KindIdentity
  }
}

///|
/// Fold `s` with `folding`. Runs of code points that fold to themselves are
/// copied at once, and input that does not change is copied without a builder.
fn fold(s : StringView, folding : Folding) -> String {
  let length = s.length()
  let mut index = 0
  while index < length {
    let cp = code_point_at(s, index, length)
    if folding.changes(cp) {
      break
    }
    index += if cp >= 0x10000 { 2 } else { 1 }
  }
  if index == length {
    return s.to_owned()
  }
  let out = StringBuilder(size_hint=length)
  // Code units before `copied` are in `out`.
  let mut copied = 0
  while index < length {
    let cp = code_point_at(s, index, length)
    if cp < 0x80 {
      if cp >= 'A' && cp <= 'Z' {
        // SAFETY: copied <= index < length, both on code point boundaries.
        out.write_view(s.unsafe_view(start=copied, end=index))
        out.write_char((cp + 32).unsafe_to_char())
        copied = index + 1
      }
      index += 1
      continue
    }
    let width = if cp >= 0x10000 { 2 } else { 1 }
    let kind = folding.kind(cp.unsafe_to_char())
    if kind != KindIdentity {
      // SAFETY: copied <= index < length, both on code point boundaries.
      out.write_view(s.unsafe_view(start=copied, end=index))
      if kind == KindSearched {
        // The tables give every code point of this kind a mapping; a missing
        // one would mean identity.
        let c = cp.unsafe_to_char()
        if folding.lookup(c) is Some(mapping) {
          out.write_view(mapping)
        } else {
          out.write_char(c)
        }
      } else {
        out.write_char((cp + folding.delta(kind)).unsafe_to_char())
      }
      copied = index + width
    }
    index += width
  }
  // SAFETY: copied <= length, on a code point boundary.
  out.write_view(s.unsafe_view(start=copied, end=length))
  out.to_string()
}

///|
/// The single code point `cp` folds to under full case folding, or None when
/// its folding has several code points.
fn simple_fold(cp : Int32) -> Int32? {
  if cp < 0x80 {
    return Some(if cp >= 'A' && cp <= 'Z' { cp + 32 } else { cp })
  }
  match case_folding_kind(cp.unsafe_to_char()) {
    KindIdentity => Some(cp)
    KindSearched => None
    kind => Some(cp + case_folding_deltas[kind])
  }
}
