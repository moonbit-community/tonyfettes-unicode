///|
test "packed values combine the three properties" {
  let values = parse_grapheme_break_values(
    (
      #|000D          ; CR # Cc       <control-000D>
      #|0300..0301    ; Extend # Mn   [2] COMBINING GRAVE ACCENT..COMBINING ACUTE ACCENT
      #|094D          ; Extend # Mn       DEVANAGARI SIGN VIRAMA
      #|
    ),
    (
      #|00A9          ; Extended_Pictographic# E0.6   [1] (©️)       copyright
      #|0023          ; Emoji                # E0.0   [1] (#️)       hash sign
      #|
    ),
    (
      #|0041..0042    ; Alphabetic # L&   [2] LATIN CAPITAL LETTER A..LATIN CAPITAL LETTER B
      #|094D          ; InCB; Linker # Mn       DEVANAGARI SIGN VIRAMA
      #|0915          ; InCB; Consonant # Lo       DEVANAGARI LETTER KA
      #|0300..0301    ; InCB; Extend # Mn   [2] COMBINING GRAVE ACCENT..COMBINING ACUTE ACCENT
      #|
    ),
  )
  inspect(values.length(), content="1114112")
  debug_inspect(
    [0x0D, 0x23, 0x41, 0xA9, 0x300, 0x301, 0x302, 0x915, 0x94D].map(code_point => {
      values[code_point]
    }),
    content=(
      #|[1, 0, 0, 64, 36, 36, 0, 16, 52]
    ),
  )
}

///|
test "grapheme break trie, high ranges, and constants" {
  let source = emit_grapheme_break(
    (
      #|000D          ; CR # Cc       <control-000D>
      #|E0001         ; Control # Cf       LANGUAGE TAG
      #|1F1E6..1F1FF  ; Regional_Indicator # So  [26] REGIONAL INDICATOR SYMBOL LETTER A..REGIONAL INDICATOR SYMBOL LETTER Z
      #|
    ),
    "",
    "",
  )
  for
    expected in [
      "let grapheme_break_bmp_index : Bytes", "let grapheme_break_bmp_leaf : Bytes",
      "let grapheme_break_supp_top : Bytes", "let grapheme_break_high_ranges : ReadOnlyArray[Int]",
      // Planes 4 and up: Other from U+40000, Control at U+E0001, Other again
      // from U+E0002.
       "  0x2000000,\n  0x7000083,\n  0x7000100,\n]", "const GcbCR : Int = 1", "const GcbRegionalIndicator : Int = 6",
      "const GcbLVT : Int = 13", "const InCBLinker : Int = 3", "const GcbMask : Int = 15",
      "const InCBShift : Int = 4", "const InCBMask : Int = 3", "const ExtendedPictographicBit : Int = 64",
      "fn grapheme_break_value(cp : Int) -> Int",
    ] {
    guard source.contains(expected) else {
      fail("Generated source is missing: \{expected}")
    }
  }
  // The default values need no constants.
  for unexpected in ["const GcbOther", "const InCBNone"] {
    guard !source.contains(unexpected) else {
      fail("Generated source should not contain: \{unexpected}")
    }
  }
}

///|
test "unknown property values are rejected" {
  try emit_grapheme_break("0041; XX\n", "", "") catch {
    error =>
      inspect(
        error.to_string().contains("Unknown Grapheme_Cluster_Break: XX"),
        content="true",
      )
  } noraise {
    _ => fail("expected an unknown Grapheme_Cluster_Break to be rejected")
  }
  try emit_grapheme_break("", "", "0041; InCB; XX\n") catch {
    error =>
      inspect(
        error.to_string().contains("Unknown Indic_Conjunct_Break: XX"),
        content="true",
      )
  } noraise {
    _ => fail("expected an unknown Indic_Conjunct_Break to be rejected")
  }
}

///|
test "line break packing resolves LB1, subtypes, and auxiliary bits" {
  let values = parse_line_break_values(
    (
      #|0028          ; OP
      #|0041          ; AL
      #|2018          ; QU
      #|2019          ; QU
      #|25CC          ; AL
      #|3008          ; OP
      #|0E01          ; SA
      #|0E31          ; SA
      #|1FFFD         ; ID
      #|
    ),
    (
      #|0028;LEFT PARENTHESIS;Ps;0;ON;;;;;Y;;;;;
      #|0041;LATIN CAPITAL LETTER A;Lu;0;L;;;;;N;;;;0061;
      #|2018;LEFT SINGLE QUOTATION MARK;Pi;0;ON;;;;;N;;;;;
      #|2019;RIGHT SINGLE QUOTATION MARK;Pf;0;ON;;;;;N;;;;;
      #|25CC;DOTTED CIRCLE;So;0;ON;;;;;N;;;;;
      #|3008;LEFT ANGLE BRACKET;Ps;0;ON;;;;;Y;;;;;
      #|0E01;THAI CHARACTER KO KAI;Lo;0;L;;;;;N;;;;;
      #|0E31;THAI CHARACTER MAI HAN-AKAT;Mn;0;NSM;;;;;N;;;;;
      #|
    ),
    (
      #|3008          ; W
      #|
    ),
    (
      #|1FFFD         ; Extended_Pictographic
      #|
    ),
  )
  inspect(values[0x28], content=lb_code("OP").to_string())
  inspect(
    values[0x3008],
    content=(lb_code("OPEA") | LbEastAsianBit).to_string(),
  )
  inspect(values[0x2018], content=lb_code("QUPi").to_string())
  inspect(values[0x2019], content=lb_code("QUPf").to_string())
  inspect(values[0x25CC], content=lb_code("DottedCircle").to_string())
  inspect(values[0x0E01], content=lb_code("AL").to_string())
  inspect(values[0x0E31], content=lb_code("CM").to_string())
  inspect(
    values[0x1FFFD],
    content=(lb_code("ID") | LbPotentialEmojiBit).to_string(),
  )
}

///|
test "word break packing includes word-like and extended pictographic bits" {
  let source = emit_word_break(
    (
      #|0041          ; ALetter
      #|0030          ; Numeric
      #|
    ),
    (
      #|0030;DIGIT ZERO;Nd;0;EN;;0;0;0;N;;;;;
      #|
    ),
    (
      #|0041          ; Alphabetic
      #|
    ),
    (
      #|00A9          ; Extended_Pictographic
      #|
    ),
  )
  for
    expected in [
      "const WbClassMask : Int = 31", "const WbWordLikeBit : Int = 32", "const WbExtendedPictographicBit : Int = 64",
      "fn word_break_value(cp : Int) -> Int",
    ] {
    guard source.contains(expected) else {
      fail("Generated word break source is missing: \{expected}")
    }
  }
}
