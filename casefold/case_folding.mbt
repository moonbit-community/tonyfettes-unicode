///|
/// Unicode default full case folding (section 3.13, R4).
/// Locale-independent: uses the C and F mappings in CaseFolding.txt, including
/// expansions such as ß -> ss. Does not normalize or apply Turkic tailoring.
pub fn case_fold(s : StringView) -> String {
  let index = Full.first_change(s)
  if index == s.length() {
    s.to_owned()
  } else {
    Full.fold_from(s, index)
  }
}

///|
/// The folding tables of this package. Both fold ASCII alike, mapping only
/// A-Z, to a-z; the generator checks this.
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
/// The number of UTF-16 code units of `cp`.
fn utf16_width(cp : Int32) -> Int32 {
  if cp >= 0x10000 {
    2
  } else {
    1
  }
}

///|
/// What the ASCII code point `cp` folds to, under either folding.
fn ascii_fold(cp : Int32) -> Int32 {
  if cp >= 'A' && cp <= 'Z' {
    cp + 32
  } else {
    cp
  }
}

///|
/// The single code point `cp` folds to, itself included, or None when its
/// mapping is found with `Folding::lookup`.
fn Folding::fold_code_point(self : Folding, cp : Int32) -> Int32? {
  if cp < 0x80 {
    return Some(ascii_fold(cp))
  }
  match self.kind(cp.unsafe_to_char()) {
    KindIdentity => Some(cp)
    KindSearched => None
    kind => Some(cp + self.delta(kind))
  }
}

///|
/// `Full.fold_code_point(cp)`, without the dispatch on the folding.
/// `caseless_match` calls it for every pair of code points that differ, and
/// there the dispatch costs about a fifth of the time.
fn simple_fold(cp : Int32) -> Int32? {
  if cp < 0x80 {
    return Some(ascii_fold(cp))
  }
  match case_folding_kind(cp.unsafe_to_char()) {
    KindIdentity => Some(cp)
    KindSearched => None
    kind => Some(cp + case_folding_deltas[kind])
  }
}

///|
/// The offset of the first code point of `s` that does not fold to itself,
/// or the length of `s` when there is none.
fn Folding::first_change(self : Folding, s : StringView) -> Int32 {
  let length = s.length()
  let mut index = 0
  while index < length {
    // ASCII, most of most text, needs neither decoding nor the tables.
    // SAFETY: index < length.
    let unit = s.unsafe_get(index).to_int()
    if unit < 0x80 {
      if ascii_fold(unit) != unit {
        break
      }
      index += 1
      continue
    }
    let cp = code_point_at(s, index, length)
    if !(self.fold_code_point(cp) is Some(target) && target == cp) {
      break
    }
    index += utf16_width(cp)
  }
  index
}

///|
/// Fold `s`, whose code points before `index` fold to themselves. Runs of
/// code points that fold to themselves are copied at once.
fn Folding::fold_from(self : Folding, s : StringView, index : Int32) -> String {
  let length = s.length()
  let out = StringBuilder(size_hint=length)
  // Code units before `copied` are in `out`.
  let mut copied = 0
  for index = index; index < length; {
    // SAFETY: index < length.
    let unit = s.unsafe_get(index).to_int()
    if unit < 0x80 {
      let target = ascii_fold(unit)
      if target != unit {
        // SAFETY: copied <= index < length, both on code point boundaries.
        out.write_view(s.unsafe_view(start=copied, end=index))
        out.write_char(target.unsafe_to_char())
        copied = index + 1
      }
      continue index + 1
    }
    let cp = code_point_at(s, index, length)
    let width = utf16_width(cp)
    match self.fold_code_point(cp) {
      Some(target) if target == cp => ()
      folded => {
        // SAFETY: copied <= index < length, both on code point boundaries.
        out.write_view(s.unsafe_view(start=copied, end=index))
        if folded is Some(target) {
          out.write_char(target.unsafe_to_char())
        } else {
          let c = cp.unsafe_to_char()
          // Every code point of kind 1 has a mapping; a missing one would
          // mean identity.
          if self.lookup(c) is Some(mapping) {
            out.write_view(mapping)
          } else {
            out.write_char(c)
          }
        }
        copied = index + width
      }
    }
    continue index + width
  }
  // SAFETY: copied <= length, on a code point boundary.
  out.write_view(s.unsafe_view(start=copied, end=length))
  out.to_string()
}
