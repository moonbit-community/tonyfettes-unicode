///|
/// One significant code point plus any marks ignored by LB9. Auxiliary
/// properties belong to the base; only the end and the last raw ZWJ flag
/// change when a combining mark is attached.
priv struct BreakUnit {
  class_ : @ucd.LineBreak
  code_point : Int32
  initial_quote : Bool
  final_quote : Bool
  east_asian : Bool
  potential_emoji : Bool
  mut end : Int32
  mut ends_with_zwj : Bool
  // Last non-SP unit, including this unit. -1 means start of text.
  space_base : Int32
  // Whether the significant prefix ends in NU (SY | IS)*.
  numeric : Bool
  // Length of the significant RI suffix (LB9 marks do not count).
  regional_count : Int32
}

///|
fn prepare_units(text : StringView) -> Array[BreakUnit] {
  let units : Array[BreakUnit] = []
  let mut offset = 0
  while offset < text.length() {
    // SAFETY: offset is in the view; a second code unit is checked below.
    let first = text.unsafe_get(offset)
    let mut cp = first.to_int()
    offset += 1
    if first.is_leading_surrogate() && offset < text.length() {
      let second = text.unsafe_get(offset)
      if second.is_trailing_surrogate() {
        cp = 0x10000 + ((cp - 0xD800) << 10) + second.to_int() - 0xDC00
        offset += 1
      }
    }
    // Unpaired surrogates have SG, which LB1 resolves to AL. They cannot
    // participate in the auxiliary-property rules, so use A as their proxy.
    let char = (if cp >= 0xD800 && cp <= 0xDFFF { 0x41 } else { cp }).unsafe_to_char()
    let original = @ucd.line_break(char)
    let category = @ucd.general_category(char)
    // LB1: default resolution only; never alter the UCD property query.
    let mut class_ = match original {
      AI | SG | XX => @ucd.AL
      CJ => @ucd.NS
      SA => if category is (Mn | Mc) { @ucd.CM } else { @ucd.AL }
      _ => original
    }
    let last = units.last()
    if class_ is (CM | ZWJ) {
      // LB9. Keep the raw final ZWJ separately for the earlier rule LB8a.
      if last is Some(base) && !(base.class_ is (BK | CR | LF | NL | SP | ZW)) {
        base.end = offset
        base.ends_with_zwj = class_ == @ucd.ZWJ
        continue
      }
    }
    // LB10 replaces *all* auxiliary properties of remaining marks with A's.
    let remaining_mark = class_ is (CM | ZWJ)
    if remaining_mark {
      class_ = @ucd.AL
    }
    let effective_char = if remaining_mark { 'A' } else { char }
    let east_asian = @ucd.east_asian_width(effective_char) is (F | W | H)
    let index = units.length()
    units.push({
      class_,
      code_point: effective_char.to_int(),
      initial_quote: !remaining_mark && category == @ucd.Pi,
      final_quote: !remaining_mark && category == @ucd.Pf,
      east_asian,
      potential_emoji: !remaining_mark &&
      category == @ucd.Cn &&
      @ucd.is_extended_pictographic(char),
      end: offset,
      ends_with_zwj: original == @ucd.ZWJ,
      space_base: if class_ == @ucd.SP {
        last.map(u => u.space_base).unwrap_or(-1)
      } else {
        index
      },
      numeric: class_ == @ucd.NU ||
      (class_ is (SY | IS) && last.map(u => u.numeric).unwrap_or(false)),
      regional_count: if class_ == @ucd.RI {
        last.map(u => u.regional_count).unwrap_or(0) + 1
      } else {
        0
      },
    })
  }
  units
}

///|
/// XX is a sentinel here: LB1 has removed it from the actual input.
fn class_at(units : Array[BreakUnit], index : Int32) -> @ucd.LineBreak {
  units.get(index).map(u => u.class_).unwrap_or(@ucd.XX)
}

///|
fn BreakUnit::aksara(self : BreakUnit) -> Bool {
  self.class_ is (AK | AS) || self.code_point == 0x25CC
}
