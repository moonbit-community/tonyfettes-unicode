///|
/// Number of low bits holding the Grapheme_Cluster_Break code in a packed
/// value.
const GcbBits : Int32 = 4

///|
/// Number of bits holding the Indic_Conjunct_Break code, above the
/// Grapheme_Cluster_Break code.
const InCBBits : Int32 = 2

///|
/// Total number of bits in a packed value: Grapheme_Cluster_Break,
/// Indic_Conjunct_Break, and the Extended_Pictographic flag.
const ValueBits : Int32 = 7

///|
/// Grapheme_Cluster_Break values in code order. `Other` is the default for
/// code points GraphemeBreakProperty.txt does not list; the generated source
/// has no constant for it.
let grapheme_cluster_break_names : ReadOnlyArray[String] = [
  "Other", "CR", "LF", "Control", "Extend", "ZWJ", "Regional_Indicator", "Prepend",
  "SpacingMark", "L", "V", "T", "LV", "LVT",
]

///|
/// Indic_Conjunct_Break values in code order. `None` is the default for code
/// points DerivedCoreProperties.txt does not list; the generated source has no
/// constant for it.
let indic_conjunct_break_names : ReadOnlyArray[String] = [
  "None", "Consonant", "Extend", "Linker",
]

///|
/// Code of a property value: its index in `names`.
fn name_code(names : ReadOnlyArray[String], name : StringView) -> Int32? {
  for code, candidate in names {
    if name == candidate {
      return Some(code)
    }
  }
  None
}

///|
/// Combine `bits` into the packed value of every code point in `range`.
fn set_range_bits(
  values : FixedArray[Int32],
  range : @parsing.CodePointRange,
  bits : Int32,
) -> Unit {
  for code_point in range.start..<=range.end {
    values[code_point] = values[code_point] | bits
  }
}

///|
/// Compute the packed value of every code point:
/// `extended_pictographic << 6 | indic_conjunct_break << 4 |
/// grapheme_cluster_break`.
fn parse_grapheme_break_values(
  grapheme_break_property : String,
  emoji_data : String,
  derived_core_properties : String,
) -> FixedArray[Int32] raise {
  let values = @parsing.parse_enumerated_ordinals(
    grapheme_break_property,
    property="Grapheme_Cluster_Break",
    default="Other",
    name => name_code(grapheme_cluster_break_names, name),
  )
  for raw_line in derived_core_properties.split("\n") {
    let line = @parsing.strip_comment(raw_line)
    guard line.split(";").collect() is [range, property, name, ..] &&
      property.trim() == "InCB" else {
      continue
    }
    guard name_code(indic_conjunct_break_names, name.trim()) is Some(code) else {
      fail("Unknown Indic_Conjunct_Break: \{name.trim()}")
    }
    set_range_bits(
      values,
      @parsing.parse_code_point_range(range),
      code << GcbBits,
    )
  }
  for raw_line in emoji_data.split("\n") {
    let line = @parsing.strip_comment(raw_line)
    guard line.split(";").collect() is [range, property, ..] &&
      property.trim() == "Extended_Pictographic" else {
      continue
    }
    set_range_bits(
      values,
      @parsing.parse_code_point_range(range),
      1 << (GcbBits + InCBBits),
    )
  }
  values
}

///|
/// Emit the grapheme cluster break properties as a three-level trie for
/// planes 0-3, with packed ranges for the remaining planes.
pub fn emit_grapheme_break(
  grapheme_break_property : String,
  emoji_data : String,
  derived_core_properties : String,
) -> String raise {
  let values = parse_grapheme_break_values(
    grapheme_break_property, emoji_data, derived_core_properties,
  )
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Grapheme cluster break properties for Unicode Text Segmentation (UAX #29)",
    "GraphemeBreakProperty.txt, emoji-data.txt, and DerivedCoreProperties.txt",
  )
  for code, name in grapheme_cluster_break_names {
    if code == 0 {
      continue
    }
    out.write(
      (
        $|///|
        $|/// Grapheme_Cluster_Break=\{name}
        $|const Gcb\{name.replace_all(old="_", new="")} : Int = \{code}
        $|
        $|
      ),
    )
  }
  for code, name in indic_conjunct_break_names {
    if code == 0 {
      continue
    }
    out.write(
      (
        $|///|
        $|/// Indic_Conjunct_Break=\{name}
        $|const InCB\{name} : Int = \{code}
        $|
        $|
      ),
    )
  }
  out.write(
    (
      $|///|
      $|/// Mask selecting the Grapheme_Cluster_Break code of a packed value.
      $|const GcbMask : Int = \{(1 << GcbBits) - 1}
      $|
      $|///|
      $|/// Shift moving the Indic_Conjunct_Break code of a packed value to bit 0.
      $|const InCBShift : Int = \{GcbBits}
      $|
      $|///|
      $|/// Mask selecting the Indic_Conjunct_Break code after shifting.
      $|const InCBMask : Int = \{(1 << InCBBits) - 1}
      $|
      $|///|
      $|/// Bit set in a packed value for Extended_Pictographic code points.
      $|const ExtendedPictographicBit : Int = \{1 << (GcbBits + InCBBits)}
      $|
      $|
    ),
  )
  out.write_value_trie(
    property="Grapheme break",
    prefix="grapheme_break",
    lookup="fn grapheme_break_value",
    lookup_doc=[
      "Look up the packed grapheme cluster break properties of a code point:",
      "`extended_pictographic << \{GcbBits + InCBBits} | indic_conjunct_break << \{GcbBits} |",
      "grapheme_cluster_break`.",
    ],
    value_bits=ValueBits,
    takes_code_point=true,
    values,
  )
  out.finish()
}
