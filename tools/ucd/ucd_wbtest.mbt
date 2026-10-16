///|
let sample_unicode_data : String =
  #|0041;LATIN CAPITAL LETTER A;Lu;0;L;;;;;N;;;;0061;
  #|0061;LATIN SMALL LETTER A;Ll;0;L;;;;;N;;;0041;;0041
  #|00A0;NO-BREAK SPACE;Zs;0;CS;<noBreak> 0020;;;;N;;;;;
  #|00C0;LATIN CAPITAL LETTER A WITH GRAVE;Lu;0;L;0041 0300;;;;N;;;;00E0;
  #|0300;COMBINING GRAVE ACCENT;Mn;230;NSM;;;;;N;;;;;
  #|0301;COMBINING ACUTE ACCENT;Mn;230;NSM;;;;;N;;;;;
  #|3400;<CJK Ideograph Extension A, First>;Lo;0;L;;;;;N;;;;;
  #|3402;<CJK Ideograph Extension A, Last>;Lo;0;L;;;;;N;;;;;
  #|AC00;<Hangul Syllable, First>;Lo;0;L;;;;;N;;;;;
  #|AC02;<Hangul Syllable, Last>;Lo;0;L;;;;;N;;;;;

///|
test "parse UnicodeData fields" {
  let data = parse_unicode_data(sample_unicode_data)
  inspect(data.ccc_entries.length(), content="2")
  inspect(data.canonical_decompositions.length(), content="1")
  inspect(data.compatibility_decompositions.length(), content="1")
  inspect(data.mark_code_points.length(), content="2")
  inspect(data.mark_code_points[0], content="768")
  inspect(data.mark_code_points[1], content="769")
  inspect(data.simple_uppercase.length(), content="1")
  inspect(data.simple_lowercase.length(), content="2")
  inspect(data.simple_titlecase.length(), content="1")
  inspect(
    data.general_categories.any(entry => entry.code_point == 0x3401),
    content="true",
  )
  inspect(
    data.general_categories.any(entry => entry.code_point == 0xAC01),
    content="true",
  )
}

///|
test "parse CompositionExclusions ranges" {
  let input =
    #|# comment
    #|0340
    #|0958..0959 # DEVANAGARI LETTER QA..KHHA
  let exclusions = parse_composition_exclusions(input)
  inspect(exclusions.length(), content="3")
  inspect(exclusions[0], content="832")
  inspect(exclusions[1], content="2392")
  inspect(exclusions[2], content="2393")
}

///|
test "parse SpecialCasing unconditional mappings only" {
  let input =
    #|00DF; 0073 0073; 0053 0073; 0053 0053; # LATIN SMALL LETTER SHARP S
    #|03A3; 03C3; 03A3; 03A3; Final_Sigma; # conditional, skipped
  let special = parse_special_casing(input)
  inspect(special.lower_mapping.length(), content="1")
  inspect(special.title_mapping[0].targets.length(), content="2")
  inspect(special.title_mapping[0].targets[0], content="83")
  inspect(special.title_mapping[0].targets[1], content="115")
  inspect(special.upper_mapping[0].targets.length(), content="2")
  inspect(special.upper_mapping[0].targets[0], content="83")
  inspect(special.upper_mapping[0].targets[1], content="83")
}

///|
test "parse XID properties" {
  let input =
    #|0030..0039 ; XID_Continue # Nd
    #|0041..005A ; XID_Start # Lu
    #|0041..005A ; XID_Continue # Lu
    #|005F ; XID_Continue # Pc
    #|00B7 ; XID_Continue # Other_ID_Continue
    #|2118 ; XID_Start # Other_ID_Start
    #|2118 ; XID_Continue # Other_ID_Start
    #|212E ; ID_Start # ignored
    #|0041..005A ; Alphabetic # Lu
    #|0061..007A ; Alphabetic # Ll
    #|0061..007A ; Lowercase # Ll
    #|00AA ; Lowercase # Lo
    #|0041..005A ; Uppercase # Lu
    #|00AD ; Default_Ignorable_Code_Point # Cf
    #|200C..200F ; Default_Ignorable_Code_Point # Cf
    #|0300..036F ; Grapheme_Extend # Mn
    #|200C ; Grapheme_Extend # Cf
    #|200D ; Grapheme_Base # ignored
  let properties = parse_derived_core_properties(input)
  inspect(properties.xid_start.length(), content="2")
  inspect(properties.xid_start[0].start, content="65")
  inspect(properties.xid_start[0].end, content="90")
  inspect(properties.xid_continue.length(), content="5")
  inspect(properties.xid_continue[3].start, content="183")
  inspect(properties.alphabetic.length(), content="2")
  inspect(properties.lowercase.length(), content="2")
  inspect(properties.lowercase[1].start, content="170")
  inspect(properties.uppercase.length(), content="1")
  inspect(properties.default_ignorable_code_point.length(), content="2")
  inspect(properties.default_ignorable_code_point[1].end, content="8207")
  inspect(properties.grapheme_extend.length(), content="2")
  inspect(properties.grapheme_extend[1].start, content="8204")
}

///|
test "parse White_Space from PropList" {
  let input =
    #|0009..000D    ; White_Space # Cc   [5] <control-0009>..<control-000D>
    #|0020          ; White_Space # Zs       SPACE
    #|002D          ; Dash # Pd       HYPHEN-MINUS
    #|3000          ; White_Space # Zs       IDEOGRAPHIC SPACE
    #|0600..0605    ; Prepended_Concatenation_Mark # Cf   [6] ARABIC NUMBER SIGN..ARABIC NUMBER MARK ABOVE
    #|06DD          ; Prepended_Concatenation_Mark # Cf       ARABIC END OF AYAH
    #|1F1E6..1F1FF  ; Regional_Indicator # So  [26] REGIONAL INDICATOR SYMBOL LETTER A..REGIONAL INDICATOR SYMBOL LETTER Z
  let properties = parse_prop_list(input)
  inspect(properties.white_space.length(), content="3")
  inspect(properties.white_space[0].start, content="9")
  inspect(properties.white_space[0].end, content="13")
  inspect(properties.white_space[2].start, content="12288")
  inspect(properties.prepended_concatenation_mark.length(), content="2")
  inspect(properties.prepended_concatenation_mark[1].start, content="1757")
  inspect(properties.regional_indicator.length(), content="1")
  inspect(properties.regional_indicator[0].end, content="127487")
}

///|
test "parse emoji-data properties" {
  let input =
    #|0023          ; Emoji                # E0.0   [1] (#️)       hash sign
    #|231A..231B    ; Emoji_Presentation   # E0.6   [2] (⌚..⌛)    watch..hourglass done
    #|1F600         ; Emoji_Presentation   # E1.0   [1] (😀)       grinning face
    #|1F3FB..1F3FF  ; Emoji_Modifier       # E1.0   [5] (🏻..🏿)    light skin tone..dark skin tone
    #|261D          ; Emoji_Modifier_Base  # E0.6   [1] (☝️)       index pointing up
    #|1F44D         ; Emoji_Modifier_Base  # E0.6   [1] (👍)       thumbs up
    #|00A9          ; Extended_Pictographic# E0.6   [1] (©️)       copyright
  let properties = parse_emoji_data(input)
  inspect(properties.extended_pictographic[0].start, content="169")
  inspect(properties.emoji_presentation.length(), content="2")
  inspect(properties.emoji_presentation[0].end, content="8987")
  inspect(properties.emoji_modifier.length(), content="1")
  inspect(properties.emoji_modifier[0].start, content="127995")
  inspect(properties.emoji_modifier_base.length(), content="2")
  inspect(properties.emoji_modifier_base[1].start, content="128077")
}

///|
test "reject missing White_Space" {
  try parse_prop_list("0020 ; Dash") catch {
    Failure::Failure(message) =>
      assert_true(message.contains("Missing White_Space ranges"))
    error => raise error
  } noraise {
    _ => fail("expected PropList without White_Space to fail")
  }
}

///|
test "reject XID_Start outside XID_Continue" {
  let input =
    #|0041 ; XID_Start
    #|0042 ; XID_Continue
    #|0041..0042 ; Alphabetic
    #|0061 ; Lowercase
    #|0041 ; Uppercase
  try parse_derived_core_properties(input) catch {
    Failure::Failure(message) =>
      assert_true(
        message.contains("XID_Start must be a subset of XID_Continue"),
      )
    error => raise error
  } noraise {
    _ => fail("expected invalid XID data to fail")
  }
}

///|
test "compress ranges and build composition data" {
  let data = parse_unicode_data(sample_unicode_data)
  let ccc_ranges = compress_ccc_ranges(data)
  inspect(ccc_ranges.length(), content="1")
  inspect(ccc_ranges[0].start, content="768")
  inspect(ccc_ranges[0].end, content="769")
  inspect(ccc_ranges[0].value, content="230")
  let mark_ranges = compress_mark_ranges(data)
  inspect(mark_ranges[0].start, content="768")
  inspect(mark_ranges[0].end, content="769")
  let gc_ranges = compress_general_category_ranges(data)
  inspect(gc_ranges[0].start, content="0")
  inspect(gc_ranges[0].end, content="64")
  inspect(gc_ranges[0].value, content="29")
  let compositions = build_composition_table(data, [])
  inspect(compositions[0].first, content="65")
  inspect(compositions[0].second, content="768")
  inspect(compositions[0].result, content="192")
}

///|
test "build full composition exclusions" {
  let input =
    #|0300;COMBINING GRAVE ACCENT;Mn;230;NSM;;;;;N;;;;;
    #|0340;COMBINING GRAVE TONE MARK;Mn;230;NSM;0300;;;;N;;;;;
    #|0958;DEVANAGARI LETTER QA;Lo;0;L;0915 093C;;;;N;;;;;
  let data = parse_unicode_data(input)
  let exclusions = build_full_composition_exclusions(data, [0x0958])
  inspect(exclusions.length(), content="2")
  inspect(exclusions[0], content="832")
  inspect(exclusions[1], content="2392")
}

///|
test "emit CCC lookup through shared normalization properties" {
  let source = emit_ccc()
  assert_true(
    source.contains(
      "@normalization_data.lookup_normalization_properties(c) & 255",
    ),
  )
}

///|
test "emit XID table" {
  let properties = parse_derived_core_properties(
    (
      #|0041..005A ; XID_Start
      #|0041..005A ; XID_Continue
      #|005F ; XID_Continue
      #|E0100..E01EF ; XID_Continue
      #|0041..005A ; Alphabetic
      #|0061..007A ; Lowercase
      #|0041..005A ; Uppercase
      #|00AD ; Default_Ignorable_Code_Point
      #|0300..036F ; Grapheme_Extend
    ),
  )
  let source = emit_xid(properties)
  inspect(
    source.contains("let xid_start_trie_leaf : Bytes = ["),
    content="true",
  )
  inspect(
    source.contains("pub fn is_xid_continue(c : Char) -> Bool"),
    content="true",
  )
  inspect(source.contains("    return false\n"), content="true")
  inspect(
    source.contains("    return (cp >= 0xE0100 && cp <= 0xE01EF)\n"),
    content="true",
  )
}

///|
test "binary property trie shares identical blocks" {
  let out = @emitter.Emitter::new()
  write_binary_property_trie(out, property="Test", [{ start: 0x41, end: 0x5A, }])
  let source = out.finish()
  // One leaf block holds A-Z; every other block is the shared empty block.
  inspect(
    source.contains(
      (
        #|let test_trie_mid : Bytes = [
        #|  0,
        #|  1,
        #|  1,
        #|  1,
        #|  1,
        #|  1,
        #|  1,
        #|  1,
        #|  1,
        #|  1,
        #|  1,
        #|  1,
        #|  1,
        #|  1,
        #|  1,
        #|  1,
        #|]
      ),
    ),
    content="true",
  )
}

///|
test "emit decomposition arrays" {
  let data = parse_unicode_data(sample_unicode_data)
  let source = emit_decomposition(data)
  for
    expected in [
      "let decomp_data_starts : ReadOnlyArray[Int]", "pub fn get_canonical_decomposition(c : Char) -> Array[Char]?",
      "pub fn append_decomposition(",
      // U+00A0 is the first character with a mapping in the sample data.
       "  if c.to_int() < 0xA0 {",
    ] {
    guard source.contains(expected) else {
      fail("Generated source is missing: \{expected}")
    }
  }
}

///|
test "emit decomposition without any mapping" {
  let source = emit_decomposition(parse_unicode_data(""))
  // Every character is below the first one with a mapping.
  inspect(source.contains("  if c.to_int() < 0x110000 {"), content="true")
}

///|
test "emit case mapping records and special mappings" {
  let data = parse_unicode_data(sample_unicode_data)
  let special = parse_special_casing(
    (
      #|00DF; 00DF; 0053 0073; 0053 0053; # LATIN SMALL LETTER SHARP S
      #|0061; 0061; 0041; 0041; # agrees with the simple mappings
    ),
  )
  let source = emit_case_mapping(data, special)
  for
    expected in [
      "let case_trie_top : Bytes", "let case_trie_mid : Bytes", "let case_trie_leaf : Bytes",
      // Records in order of first use: no mapping, U+0041 (shared with
      // U+00C0), U+0061, and U+00DF with special upper and title mappings.
       "let case_upper_deltas : ReadOnlyArray[Int] = [\n  0,\n  0,\n  -32,\n  0,\n]",
      "let case_lower_deltas : ReadOnlyArray[Int] = [\n  0,\n  32,\n  0,\n  0,\n]",
      "let case_title_deltas : ReadOnlyArray[Int] = [\n  0,\n  0,\n  -32,\n  0,\n]",
      "let case_special_flags : Bytes = [\n  0,\n  0,\n  0,\n  5,\n]", "let special_upper_cps : ReadOnlyArray[Int] = [\n  0x00DF,\n]",
      "let special_upper_strings : ReadOnlyArray[String] = [\n  \"\\u{0053}\\u{0053}\",\n]",
      "let special_lower_cps : ReadOnlyArray[Int] = [\n]", "let special_title_strings : ReadOnlyArray[String] = [\n  \"\\u{0053}\\u{0073}\",\n]",
      "let ascii_strings : ReadOnlyArray[String] = [\n  \"\\u{0000}\",\n", "pub fn lookup_simple_uppercase(c : Char) -> Char",
      "pub fn full_lowercase(c : Char) -> String", "pub fn lookup_full_titlecase(c : Char) -> Array[Char]?",
    ] {
    guard source.contains(expected) else {
      fail("Generated source is missing: \{expected}")
    }
  }
}

///|
test "case mappings above the trie are rejected" {
  let data = parse_unicode_data(
    "20000;TEST CAPITAL LETTER;Lu;0;L;;;;;N;;;;20001;\n",
  )
  try emit_case_mapping(data, parse_special_casing("")) catch {
    Failure::Failure(message) =>
      assert_true(message.contains("needs trie coverage"))
    error => raise error
  } noraise {
    _ => fail("expected a case mapping above the trie to be rejected")
  }
}

///|
test "emit White_Space table" {
  let source = emit_white_space(
    parse_prop_list(
      (
        #|0009..000D ; White_Space
        #|0020 ; White_Space
        #|0600..0605 ; Prepended_Concatenation_Mark
        #|1F1E6..1F1FF ; Regional_Indicator
      ),
    ),
  )
  inspect(source.contains("/// White_Space lookup data\n"), content="true")
  inspect(source.contains("/// Generated from PropList.txt\n"), content="true")
  inspect(
    source.contains("let white_space_trie_top : Bytes = ["),
    content="true",
  )
  inspect(
    source.contains("pub fn is_white_space(c : Char) -> Bool"),
    content="true",
  )
}

///|
test "emit East_Asian_Width table" {
  let source = emit_east_asian_width(
    (
      #|# @missing: 0000..10FFFF; N
      #|0041 ; Na
      #|4E00 ; W
      #|E0100 ; A
      #|
    ),
  )
  for
    expected in [
      "/// East_Asian_Width lookup data\n/// Generated from EastAsianWidth.txt\n",
      "let eaw_trie_top : Bytes = [", "let eaw_trie_mid : Bytes = [", "let eaw_trie_leaf : Bytes = [",
      // Planes 4 and up: N from U+40000, A at U+E0100, N again from U+E0101.
       "  0x200003,\n  0x700800,\n  0x70080B,\n]", "pub fn lookup_east_asian_width(c : Char) -> Int {",
    ] {
    guard source.contains(expected) else {
      fail("Generated source is missing: \{expected}")
    }
  }
}

///|
test "unknown East_Asian_Width is rejected" {
  try emit_east_asian_width("0041 ; X\n") catch {
    error =>
      inspect(
        error.to_string().contains("Unknown East_Asian_Width: X"),
        content="true",
      )
  } noraise {
    _ => fail("expected an unknown East_Asian_Width to be rejected")
  }
}

///|
test "emit Emoji tables" {
  let source = emit_emoji(
    parse_emoji_data(
      (
        #|231A..231B ; Emoji_Presentation
        #|1F3FB..1F3FF ; Emoji_Modifier
        #|1F44D ; Emoji_Modifier_Base
        #|00A9 ; Extended_Pictographic
      ),
    ),
    parse_emoji_variation_sequences(
      (
        #|0023 FE0E  ; text style;  # (1.1) NUMBER SIGN
        #|0023 FE0F  ; emoji style; # (1.1) NUMBER SIGN
      ),
    ),
  )
  for
    expected in [
      "/// Generated from emoji-data.txt and emoji-variation-sequences.txt\n", "let emoji_presentation_trie_top : Bytes = [",
      "pub fn is_emoji_presentation(c : Char) -> Bool", "let emoji_modifier_trie_leaf : Bytes = [",
      "pub fn is_emoji_modifier(c : Char) -> Bool", "pub fn is_emoji_modifier_base(c : Char) -> Bool",
      "pub fn is_extended_pictographic(c : Char) -> Bool", "/// Check whether a character starts an emoji variation sequence\npub fn has_emoji_variation_sequence(c : Char) -> Bool",
    ] {
    guard source.contains(expected) else {
      fail("Generated source is missing: \{expected}")
    }
  }
}

///|
test "emit Joining_Type table" {
  let source = emit_joining_type(
    (
      #|# @missing: 0000..10FFFF; Non_Joining
      #|0620 ; D
      #|0627 ; R
      #|200D ; C
      #|E0100..E01EF ; T
      #|
    ),
  )
  for
    expected in [
      "/// Joining_Type lookup data\n/// Generated from DerivedJoiningType.txt\n",
      "let joining_type_trie_top : Bytes = [", "let joining_type_trie_leaf : Bytes = [",
      // Planes 4 and up: U from U+40000, T at U+E0100..U+E01EF, U again after.
       "  0x200000,\n  0x700805,\n  0x700F80,\n]", "pub fn lookup_joining_type(c : Char) -> Int {",
    ] {
    guard source.contains(expected) else {
      fail("Generated source is missing: \{expected}")
    }
  }
}

///|
test "unknown Joining_Type is rejected" {
  try emit_joining_type("0041 ; X\n") catch {
    error =>
      inspect(
        error.to_string().contains("Unknown Joining_Type: X"),
        content="true",
      )
  } noraise {
    _ => fail("expected an unknown Joining_Type to be rejected")
  }
}

///|
test "parse emoji variation sequences into ranges" {
  let ranges = parse_emoji_variation_sequences(
    (
      #|0023 FE0E  ; text style;  # (1.1) NUMBER SIGN
      #|0023 FE0F  ; emoji style; # (1.1) NUMBER SIGN
      #|0030 FE0E  ; text style;  # (1.1) DIGIT ZERO
      #|0030 FE0F  ; emoji style; # (1.1) DIGIT ZERO
      #|0031 FE0E  ; text style;  # (1.1) DIGIT ONE
      #|0031 FE0F  ; emoji style; # (1.1) DIGIT ONE
    ),
  )
  debug_inspect(
    ranges,
    content=(
      #|[{ start: 35, end: 35 }, { start: 48, end: 49 }]
    ),
  )
}

///|
test "emoji variation sequences must come in pairs" {
  try
    parse_emoji_variation_sequences(
      (
        #|0023 FE0E  ; text style;  # (1.1) NUMBER SIGN
        #|0023 FE0F  ; emoji style; # (1.1) NUMBER SIGN
        #|0030 FE0F  ; emoji style; # (1.1) DIGIT ZERO
      ),
    )
  catch {
    error =>
      inspect(
        error.to_string().contains("have different base characters"),
        content="true",
      )
  } noraise {
    _ => fail("expected an unpaired variation sequence to be rejected")
  }
  try parse_emoji_variation_sequences("0023 FE0F ; text style;\n") catch {
    error =>
      inspect(
        error.to_string().contains("Unexpected emoji variation sequence"),
        content="true",
      )
  } noraise {
    _ => fail("expected a mismatched selector to be rejected")
  }
}

///|
test "emit Hangul_Syllable_Type table" {
  let source = emit_hangul_syllable_type(
    (
      #|# @missing: 0000..10FFFF; Not_Applicable
      #|1100..115F ; L
      #|AC00 ; LV
      #|AC01..AC1B ; LVT
      #|
    ),
  )
  for
    expected in [
      "/// Hangul_Syllable_Type lookup data\n/// Generated from HangulSyllableType.txt\n",
      "let hangul_syllable_type_trie_leaf : Bytes = [", "pub fn lookup_hangul_syllable_type(c : Char) -> Int {",
    ] {
    guard source.contains(expected) else {
      fail("Generated source is missing: \{expected}")
    }
  }
  try emit_hangul_syllable_type("1100 ; X\n") catch {
    error =>
      inspect(
        error.to_string().contains("Unknown Hangul_Syllable_Type: X"),
        content="true",
      )
  } noraise {
    _ => fail("expected an unknown Hangul_Syllable_Type to be rejected")
  }
}

///|
test "emit Joining_Group table and enum in dictionary order" {
  let input =
    #|# @missing: 0000..10FFFF; No_Joining_Group
    #|0629 ; Teh_Marbuta
    #|0628 ; Beh
    #|06C3 ; Teh_Marbuta_Goal
    #|0647 ; Heh
    #|062D ; Hah
    #|
  let source = emit_joining_group(input)
  for
    expected in [
      "/// Joining_Group lookup data\n/// Generated from DerivedJoiningGroup.txt\n",
      "let joining_group_trie_leaf : Bytes = [", "/// Returns ordinal value (0-5) corresponding to JoiningGroup enum\n",
      "pub fn lookup_joining_group(c : Char) -> Int {",
    ] {
    guard source.contains(expected) else {
      fail("Generated source is missing: \{expected}")
    }
  }
  let api = emit_joining_group_enum(input)
  for
    expected in [
      // Dictionary order, not the length-first order of `String::compare`.
      "pub(all) enum JoiningGroup {\n  Beh // Beh\n  Hah // Hah\n  Heh // Heh\n  NoJoiningGroup // No_Joining_Group\n  TehMarbuta // Teh_Marbuta\n  TehMarbutaGoal // Teh_Marbuta_Goal\n} derive(Debug, Eq)",
      "#deprecated(\"Use `Debug::to_repr` instead\", skip_current_package=true)\n#doc(hidden)\npub extend JoiningGroup with Debug::{to_repr}\n",
      "      TehMarbutaGoal => \"TehMarbutaGoal\"\n", "    0 => Beh\n    1 => Hah\n    2 => Heh\n    4 => TehMarbuta\n    5 => TehMarbutaGoal\n    _ => NoJoiningGroup // 3 or any unknown\n",
      "  ordinal_to_joining_group(@joining_group.lookup_joining_group(c))\n",
    ] {
    guard api.contains(expected) else {
      fail("Generated source is missing: \{expected}")
    }
  }
}

///|
test "emit Line_Break table and enum" {
  let lines = StringBuilder()
  lines.write_string("# @missing: 0000..10FFFF; XX\n")
  for cp, entry in line_break_values {
    lines.write_string("\{@emitter.hex_upper(0x100 + cp)} ; \{entry.0}\n")
  }
  let source = emit_line_break(lines.to_string())
  for
    expected in [
      "/// Line_Break lookup data\n/// Generated from LineBreak.txt\n", "let line_break_trie_leaf : Bytes = [",
      "/// Returns ordinal value (0-48) corresponding to LineBreak enum\n", "pub fn lookup_line_break(c : Char) -> Int {",
    ] {
    guard source.contains(expected) else {
      fail("Generated source is missing: \{expected}")
    }
  }
  let api = emit_line_break_enum()
  for
    expected in [
      "pub(all) enum LineBreak {\n  AI // Ambiguous (Alphabetic or Ideographic)\n",
      "  ZWJ // Zero Width Joiner\n} derive(Debug, Eq)", "#deprecated(\"Use `Debug::to_repr` instead\", skip_current_package=true)\n#doc(hidden)\npub extend LineBreak with Debug::{to_repr}\n",
      "    45 => WJ\n    47 => ZW\n    48 => ZWJ\n    _ => XX // 46 or any unknown\n",
      "  ordinal_to_line_break(@line_break.lookup_line_break(c))\n",
    ] {
    guard api.contains(expected) else {
      fail("Generated source is missing: \{expected}")
    }
  }
}

///|
test "Line_Break values must match the data" {
  try emit_line_break("0041 ; QQ\n") catch {
    error =>
      inspect(
        error.to_string().contains("Unknown Line_Break: QQ"),
        content="true",
      )
  } noraise {
    _ => fail("expected an unknown Line_Break to be rejected")
  }
  try emit_line_break("0041 ; AL\n") catch {
    error =>
      inspect(
        error.to_string().contains("does not occur in LineBreak.txt"),
        content="true",
      )
  } noraise {
    _ =>
      fail("expected a Line_Break value missing from the data to be rejected")
  }
}
