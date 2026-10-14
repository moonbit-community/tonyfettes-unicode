///|
/// Apply UAX #14 revision 57 in rule order at a significant boundary.
/// LB1, LB9, and LB10 are resolved in prepare_units; LB2/LB3 in the cursor.
/// Context summaries make each decision constant-time, including long runs
/// of spaces, numeric punctuation, combining marks, and regional indicators.
fn boundary(units : Array[BreakUnit], index : Int32) -> BreakOpportunity? {
  let left = units[index - 1]
  let right = units[index]
  let a = left.class_
  let b = right.class_
  let before = class_at(units, index - 2)
  let after = class_at(units, index + 1)
  // LB4-LB6: mandatory breaks, with CR LF kept together.
  if a == @ucd.CR && b == @ucd.LF {
    return None
  }
  if a is (BK | CR | LF | NL) {
    return Some(Mandatory)
  }
  if b is (BK | CR | LF | NL) {
    return None
  }
  // LB7-LB8a: explicit spaces and zero-width controls precede LB9.
  if b is (SP | ZW) {
    return None
  }
  let base_index = left.space_base
  let base = class_at(units, base_index)
  if base == @ucd.ZW {
    return Some(Allowed)
  }
  if left.ends_with_zwj {
    return None
  }
  // LB11-LB12a.
  if a == @ucd.WJ || b == @ucd.WJ || a == @ucd.GL {
    return None
  }
  if b == @ucd.GL && !(a is (SP | HY | HH)) {
    return None
  }
  // LB13-LB14.
  if b is (CL | CP | EX | SY) {
    return None
  }
  if base == @ucd.OP {
    return None
  }
  // LB15a: initial quote after start, a hard break, or permitted context.
  if base == @ucd.QU &&
    units[base_index].initial_quote &&
    class_at(units, base_index - 1)
    is (XX | BK | CR | LF | NL | OP | QU | GL | SP | ZW) {
    return None
  }
  // LB15b: final quote before end or the listed following context.
  if b == @ucd.QU &&
    right.final_quote &&
    after
    is (XX
    | SP
    | GL
    | WJ
    | CL
    | QU
    | CP
    | EX
    | IS
    | SY
    | BK
    | CR
    | LF
    | NL
    | ZW) {
    return None
  }
  // LB15c-LB15d.
  if a == @ucd.SP && b == @ucd.IS && after == @ucd.NU {
    return Some(Allowed)
  }
  if b == @ucd.IS {
    return None
  }
  // LB16-LB18.
  if base is (CL | CP) && b == @ucd.NS {
    return None
  }
  if base == @ucd.B2 && b == @ucd.B2 {
    return None
  }
  if a == @ucd.SP {
    return Some(Allowed)
  }
  // LB19-LB19a: unresolved quotes and their East Asian surroundings.
  if (b == @ucd.QU && !right.initial_quote) ||
    (a == @ucd.QU && !left.final_quote) {
    return None
  }
  if b == @ucd.QU &&
    (
      !left.east_asian ||
      !units.get(index + 1).map(u => u.east_asian).unwrap_or(false)
    ) {
    return None
  }
  if a == @ucd.QU &&
    (
      !right.east_asian ||
      !units.get(index - 2).map(u => u.east_asian).unwrap_or(false)
    ) {
    return None
  }
  // LB20-LB20a.
  if a == @ucd.CB || b == @ucd.CB {
    return Some(Allowed)
  }
  if a is (HY | HH) &&
    b is (AL | HL) &&
    before is (XX | BK | CR | LF | NL | SP | ZW | CB | GL) {
    return None
  }
  // LB21-LB22.
  if b is (BA | HH | HY | NS) || a == @ucd.BB {
    return None
  }
  if before == @ucd.HL && a is (HY | HH) && b != @ucd.HL {
    return None
  }
  if a == @ucd.SY && b == @ucd.HL {
    return None
  }
  if b == @ucd.IN {
    return None
  }
  // LB23-LB24.
  if (a is (AL | HL) && b == @ucd.NU) || (a == @ucd.NU && b is (AL | HL)) {
    return None
  }
  if (a == @ucd.PR && b is (ID | EB | EM)) ||
    (a is (ID | EB | EM) && b == @ucd.PO) {
    return None
  }
  if (a is (PR | PO) && b is (AL | HL)) || (a is (AL | HL) && b is (PR | PO)) {
    return None
  }
  // LB25: numeric prefixes/suffixes, parentheses, decimals and separators.
  if b is (PO | PR) &&
    (
      left.numeric ||
      (
        a is (CL | CP) &&
        units.get(index - 2).map(u => u.numeric).unwrap_or(false)
      )
    ) {
    return None
  }
  if a is (PO | PR) &&
    (
      b == @ucd.NU ||
      (
        b == @ucd.OP &&
        (
          after == @ucd.NU ||
          (after == @ucd.IS && class_at(units, index + 2) == @ucd.NU)
        )
      )
    ) {
    return None
  }
  if b == @ucd.NU && (a is (HY | IS) || left.numeric) {
    return None
  }
  // LB26-LB27: Korean syllable blocks.
  if (a == @ucd.JL && b is (JL | JV | H2 | H3)) ||
    (a is (JV | H2) && b is (JV | JT)) ||
    (a is (JT | H3) && b == @ucd.JT) {
    return None
  }
  if (a is (JL | JV | JT | H2 | H3) && b == @ucd.PO) ||
    (a == @ucd.PR && b is (JL | JV | JT | H2 | H3)) {
    return None
  }
  // LB28-LB28a: alphabetics and Brahmic orthographic syllables.
  if a is (AL | HL) && b is (AL | HL) {
    return None
  }
  if a == @ucd.AP && right.aksara() {
    return None
  }
  if left.aksara() && b is (VF | VI) {
    return None
  }
  if a == @ucd.VI &&
    (b == @ucd.AK || right.code_point == 0x25CC) &&
    units.get(index - 2).map(u => u.aksara()).unwrap_or(false) {
    return None
  }
  if left.aksara() && right.aksara() && after == @ucd.VF {
    return None
  }
  // LB29-LB30.
  if a == @ucd.IS && b is (AL | HL) {
    return None
  }
  if (a is (AL | HL | NU) && b == @ucd.OP && !right.east_asian) ||
    (a == @ucd.CP && !left.east_asian && b is (AL | HL | NU)) {
    return None
  }
  // LB30a-LB30b.
  if a == @ucd.RI && b == @ucd.RI && left.regional_count % 2 == 1 {
    return None
  }
  if b == @ucd.EM && (a == @ucd.EB || left.potential_emoji) {
    return None
  }
  // LB31.
  Some(Allowed)
}
