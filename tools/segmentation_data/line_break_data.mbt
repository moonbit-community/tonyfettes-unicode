///|
/// Resolved UAX #14 Line_Break classes for the segmentation engine.
///
/// LB1 has already removed AI, CJ, SA, SG, and XX. QU is split into QU, QUPi,
/// and QUPf (for LB15a/LB15b/LB19), OP/CP are split by East Asian width (for
/// LB30), and U+25CC (DOTTED CIRCLE) has its own class (for LB28a). CM and ZWJ
/// sit at the end (`>= LbCM`) so LB9/LB10 checks are a single comparison and
/// the 2D pair table only covers the 48 non-mark classes (`0..47`).
let resolved_lb_names : ReadOnlyArray[String] = [
  "None", "AK", "AL", "AP", "AS", "B2", "BA", "BB", "BK", "CB", "CL", "CP", "CPEA",
  "CR", "DottedCircle", "EB", "EM", "EX", "GL", "H2", "H3", "HH", "HL", "HY", "ID",
  "IN", "IS", "JL", "JT", "JV", "LF", "NL", "NS", "NU", "OP", "OPEA", "PO", "PR",
  "QU", "QUPi", "QUPf", "RI", "SP", "SY", "VF", "VI", "WJ", "ZW", "CM", "ZWJ",
]

///|
/// Number of classes in the 2D pair table (`None` + all non-CM/non-ZWJ classes).
const LbPairClassCount : Int32 = 48

///|
/// Packed line break value bits:
/// - bits 0..5: resolved class (0..49)
/// - bit 6: East_Asian_Width in {F, W, H}
/// - bit 7: General_Category == Cn && Extended_Pictographic
const LbEastAsianBit : Int32 = 64

///|
const LbPotentialEmojiBit : Int32 = 128

///|
const LbPairProhibited : Int32 = 0

///|
const LbPairAllowed : Int32 = 1

///|
const LbPairMandatory : Int32 = 2

///|
const LbPairContext : Int32 = 3

///|
fn lb_code(name : String) -> Int32 {
  match resolved_lb_names.search_by(n => n == name) {
    Some(code) => code
    None => abort("Unknown resolved line break class: \{name}")
  }
}

///|
/// Parse General_Category from UnicodeData.txt as compact codes needed by
/// segmentation: 0=other, 1=Mn/Mc, 2=Pi, 3=Pf, 4=Cn, 5=Nd/Nl/No.
fn parse_unicode_data_gc_tags(content : String) -> FixedArray[Int32] raise {
  // Default for unlisted code points is Cn (tag 4).
  let tags = FixedArray::make(@emitter.MaxCodePoint + 1, 4)
  let mut range_start : (Int32, Int32)? = None
  for fields in @parsing.data_lines(content) {
    if fields.length() < 3 {
      continue
    }
    let cp = @parsing.parse_hex_int(fields[0])
    let name = fields[1]
    let tag = match fields[2] {
      "Mn" | "Mc" => 1
      "Pi" => 2
      "Pf" => 3
      "Cn" => 4
      "Nd" | "Nl" | "No" => 5
      _ => 0
    }
    if name.has_suffix(", First>") {
      guard range_start is None else { fail("Nested UnicodeData First range") }
      range_start = Some((cp, tag))
      continue
    }
    if name.has_suffix(", Last>") {
      guard range_start is Some((start, start_tag)) && start_tag == tag else {
        fail("Mismatched UnicodeData First/Last range")
      }
      for range_cp in start..<=cp {
        tags[range_cp] = tag
      }
      range_start = None
      continue
    }
    tags[cp] = tag
  }
  if range_start is Some(_) {
    fail("Unterminated UnicodeData First range")
  }
  tags
}

///|
fn parse_line_break_values(
  line_break_source : String,
  unicode_data : String,
  east_asian_width : String,
  emoji_data : String,
) -> FixedArray[Int32] raise {
  let gc_tags = parse_unicode_data_gc_tags(unicode_data)
  let ea_wide = FixedArray::make(@emitter.MaxCodePoint + 1, false)
  for fields in @parsing.data_lines(east_asian_width) {
    guard fields is [range, value, ..] else { continue }
    if value is ("F" | "W" | "H") {
      let range = @parsing.parse_code_point_range(range)
      for cp in range.start..<=range.end {
        ea_wide[cp] = true
      }
    }
  }
  let ext_pic = FixedArray::make(@emitter.MaxCodePoint + 1, false)
  for fields in @parsing.data_lines(emoji_data) {
    guard fields is [range, "Extended_Pictographic", ..] else { continue }
    let range = @parsing.parse_code_point_range(range)
    for cp in range.start..<=range.end {
      ext_pic[cp] = true
    }
  }
  let raw_lb = @parsing.parse_enumerated_property(
    line_break_source,
    default="XX",
  )
  let c_al = lb_code("AL")
  let c_ns = lb_code("NS")
  let c_cm = lb_code("CM")
  let c_qu = lb_code("QU")
  let c_qu_pi = lb_code("QUPi")
  let c_qu_pf = lb_code("QUPf")
  let c_op = lb_code("OP")
  let c_op_ea = lb_code("OPEA")
  let c_cp = lb_code("CP")
  let c_cp_ea = lb_code("CPEA")
  let c_dc = lb_code("DottedCircle")
  let values = FixedArray::make(@emitter.MaxCodePoint + 1, 0)
  for cp in 0..<=@emitter.MaxCodePoint {
    let gc = gc_tags[cp]
    let ea = ea_wide[cp]
    let resolved = if cp == 0x25CC {
      c_dc
    } else {
      match raw_lb[cp] {
        "AI" | "SG" | "XX" => c_al
        "CJ" => c_ns
        "SA" => if gc == 1 { c_cm } else { c_al }
        "QU" => if gc == 2 { c_qu_pi } else if gc == 3 { c_qu_pf } else { c_qu }
        "OP" => if ea { c_op_ea } else { c_op }
        "CP" => if ea { c_cp_ea } else { c_cp }
        name =>
          match resolved_lb_names.search_by(n => n == name) {
            Some(code) => code
            None => fail("Unknown Line_Break value: \{name}")
          }
      }
    }
    let mut packed = resolved
    if ea {
      packed = packed | LbEastAsianBit
    }
    if gc == 4 && ext_pic[cp] {
      packed = packed | LbPotentialEmojiBit
    }
    values[cp] = packed
  }
  values
}

///|
/// Compute the context-free pair action for resolved classes `(a, b)` assuming
/// `left_ends_with_zwj == false` and neither class is `CM` or `ZWJ`.
fn compute_lb_pair_action(a : Int32, b : Int32) -> Int32 {
  if a == 0 || b == 0 {
    return LbPairContext
  }
  let name_a = resolved_lb_names[a]
  let name_b = resolved_lb_names[b]
  // LB4-LB6
  if name_a == "CR" && name_b == "LF" {
    return LbPairProhibited
  }
  if name_a is ("BK" | "CR" | "LF" | "NL") {
    return LbPairMandatory
  }
  if name_b is ("BK" | "CR" | "LF" | "NL") {
    return LbPairProhibited
  }
  // LB7
  if name_b is ("SP" | "ZW") {
    return LbPairProhibited
  }
  // LB8
  if name_a == "ZW" {
    return LbPairAllowed
  }
  // Spaces carry the base class before SP* (ZW, OP, QUPi, CL/CP, B2, etc.),
  // which can fire LB8 before LB11/LB13.
  if name_a == "SP" {
    return LbPairContext
  }
  // LB11-LB12a
  if name_a == "WJ" || name_b == "WJ" || name_a == "GL" {
    return LbPairProhibited
  }
  if name_b == "GL" && !(name_a is ("HY" | "HH")) {
    return LbPairProhibited
  }
  // LB13-LB14
  if name_b is ("CL" | "CP" | "CPEA" | "EX" | "SY") {
    return LbPairProhibited
  }
  if name_a is ("OP" | "OPEA") {
    return LbPairProhibited
  }
  // LB15a-LB15b
  if name_a == "QUPi" || name_b == "QUPf" {
    return LbPairContext
  }
  // LB15d (LB15c only applies when a == SP)
  if name_b == "IS" {
    return LbPairProhibited
  }
  // LB16-LB17 (LB18 only applies when a == SP)
  if name_a is ("CL" | "CP" | "CPEA") && name_b == "NS" {
    return LbPairProhibited
  }
  if name_a == "B2" && name_b == "B2" {
    return LbPairProhibited
  }
  // LB19-LB19a
  if name_b is ("QU" | "QUPf") || name_a is ("QU" | "QUPi") {
    return LbPairProhibited
  }
  if name_b == "QUPi" || name_a == "QUPf" {
    // LB21 and LB22 unconditionally prohibit these pairs regardless of LB19a,
    // and LB20 (CB) does not apply to them.
    if name_b is ("BA" | "HH" | "HY" | "NS" | "IN") || name_a == "BB" {
      return LbPairProhibited
    }
    return LbPairContext
  }
  // LB20 (the last rule that can return Allowed before LB31)
  if name_a == "CB" || name_b == "CB" {
    return LbPairAllowed
  }
  // Every rule from LB20a..LB30b only prohibits breaks, so check all
  // unconditional prohibitions before returning LbPairContext.
  // LB21, LB21b, LB22
  if name_b is ("BA" | "HH" | "HY" | "NS" | "IN") || name_a == "BB" {
    return LbPairProhibited
  }
  if name_a == "SY" && name_b == "HL" {
    return LbPairProhibited
  }
  // LB23-LB24
  let a_alhl = name_a is ("AL" | "DottedCircle" | "HL")
  let b_alhl = name_b is ("AL" | "DottedCircle" | "HL")
  if (a_alhl && name_b == "NU") || (name_a == "NU" && b_alhl) {
    return LbPairProhibited
  }
  if (name_a == "PR" && name_b is ("ID" | "EB" | "EM")) ||
    (name_a is ("ID" | "EB" | "EM") && name_b == "PO") {
    return LbPairProhibited
  }
  if (name_a is ("PR" | "PO") && b_alhl) || (a_alhl && name_b is ("PR" | "PO")) {
    return LbPairProhibited
  }
  // LB25 unconditional prohibitions
  if (name_b is ("PO" | "PR") && name_a == "NU") ||
    (name_a is ("PO" | "PR") && name_b == "NU") ||
    (name_b == "NU" && name_a is ("HY" | "IS" | "NU")) {
    return LbPairProhibited
  }
  // LB26-LB27
  if (name_a == "JL" && name_b is ("JL" | "JV" | "H2" | "H3")) ||
    (name_a is ("JV" | "H2") && name_b is ("JV" | "JT")) ||
    (name_a is ("JT" | "H3") && name_b == "JT") {
    return LbPairProhibited
  }
  if (name_a is ("JL" | "JV" | "JT" | "H2" | "H3") && name_b == "PO") ||
    (name_a == "PR" && name_b is ("JL" | "JV" | "JT" | "H2" | "H3")) {
    return LbPairProhibited
  }
  // LB28-LB28a unconditional prohibitions
  if a_alhl && b_alhl {
    return LbPairProhibited
  }
  let a_aksara = name_a is ("AK" | "AS" | "DottedCircle")
  let b_aksara = name_b is ("AK" | "AS" | "DottedCircle")
  if name_a == "AP" && b_aksara {
    return LbPairProhibited
  }
  if a_aksara && name_b is ("VF" | "VI") {
    return LbPairProhibited
  }
  // LB29-LB30
  if name_a == "IS" && b_alhl {
    return LbPairProhibited
  }
  if ((a_alhl || name_a == "NU") && name_b == "OP") ||
    (name_a == "CP" && (b_alhl || name_b == "NU")) {
    return LbPairProhibited
  }
  // LB30b unconditional prohibition
  if name_a == "EB" && name_b == "EM" {
    return LbPairProhibited
  }
  // Context-dependent rules in LB20a..LB30b:
  // LB20a, LB21a
  if name_a is ("HY" | "HH") {
    return LbPairContext
  }
  // LB25 context cases
  if (name_b is ("PO" | "PR") && name_a is ("SY" | "IS" | "CL" | "CP" | "CPEA")) ||
    (name_a is ("PO" | "PR") && name_b is ("OP" | "OPEA")) ||
    (name_a == "SY" && name_b == "NU") {
    return LbPairContext
  }
  // LB28a context cases
  if (name_a == "VI" && name_b is ("AK" | "DottedCircle")) ||
    (a_aksara && b_aksara) {
    return LbPairContext
  }
  // LB30a, LB30b context cases
  if (name_a == "RI" && name_b == "RI") || name_b == "EM" {
    return LbPairContext
  }
  // LB31
  LbPairAllowed
}

///|
/// Generate the packed line breaking property trie and 2D pair table.
pub fn emit_line_break(
  line_break_source : String,
  unicode_data : String,
  east_asian_width : String,
  emoji_data : String,
) -> String raise {
  let values = parse_line_break_values(
    line_break_source, unicode_data, east_asian_width, emoji_data,
  )
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Packed UAX #14 line break properties and pair table", "LineBreak.txt, UnicodeData.txt, EastAsianWidth.txt, and emoji-data.txt",
  )
  // Emit only the class constants referenced by the streaming context rules;
  // all other classes (AP, BA, BB, H2, H3, ID, IN, JL, JT, JV) are decided
  // entirely by `line_break_pair_table`.
  for code, name in resolved_lb_names {
    if name
      is ("AP" | "BA" | "BB" | "H2" | "H3" | "ID" | "IN" | "JL" | "JT" | "JV") {
      continue
    }
    out.write_line("///|")
    out.write_line("const Lb\{name} : Int = \{code}\n")
  }
  out.write(
    (
      $|///|
      $|const LbClassMask : Int = 63
      $|
      $|///|
      $|const LbEastAsianBit : Int = \{LbEastAsianBit}
      $|
      $|///|
      $|const LbPotentialEmojiBit : Int = \{LbPotentialEmojiBit}
      $|
      $|///|
      $|const LbPairClasses : Int = \{LbPairClassCount}
      $|
      $|///|
      $|const LbPairProhibited : Int = \{LbPairProhibited}
      $|
      $|///|
      $|const LbPairAllowed : Int = \{LbPairAllowed}
      $|
      $|///|
      $|const LbPairMandatory : Int = \{LbPairMandatory}
      $|
      $|///|
      $|const LbPairContext : Int = \{LbPairContext}
      $|
      $|
    ),
  )
  let pair_table : Array[Int32] = Array(
    capacity=LbPairClassCount * LbPairClassCount,
  )
  for a in 0..<LbPairClassCount {
    for b in 0..<LbPairClassCount {
      pair_table.push(compute_lb_pair_action(a, b))
    }
  }
  out.write_byte_array(
    "UAX #14 pair table indexed by `a * LbPairClasses + b`", "line_break_pair_table",
    pair_table,
  )
  out.write_value_trie(
    property="Line break",
    prefix="line_break",
    lookup="fn line_break_value",
    lookup_doc=[
      "Look up the packed UAX #14 line break properties of a code point:", "`potential_emoji << 7 | east_asian << 6 | resolved_class`.",
    ],
    value_bits=8,
    takes_code_point=true,
    values,
  )
  out.finish()
}
