///|
test "general_category: ASCII letters" {
  // Uppercase letters
  inspect(@ucd.general_category('A'), content="Lu")
  inspect(@ucd.general_category('Z'), content="Lu")
  // Lowercase letters
  inspect(@ucd.general_category('a'), content="Ll")
  inspect(@ucd.general_category('z'), content="Ll")
}

///|
test "general_category: digits" {
  inspect(@ucd.general_category('0'), content="Nd")
  inspect(@ucd.general_category('9'), content="Nd")
}

///|
test "general_category: punctuation" {
  inspect(@ucd.general_category('!'), content="Po")
  inspect(@ucd.general_category('('), content="Ps")
  inspect(@ucd.general_category(')'), content="Pe")
  inspect(@ucd.general_category('-'), content="Pd")
}

///|
test "general_category: symbols" {
  inspect(@ucd.general_category('$'), content="Sc")
  inspect(@ucd.general_category('+'), content="Sm")
  inspect(@ucd.general_category('<'), content="Sm")
}

///|
test "general_category: control characters" {
  inspect(@ucd.general_category('\u{00}'), content="Cc") // NUL
  inspect(@ucd.general_category('\t'), content="Cc") // TAB
  inspect(@ucd.general_category('\n'), content="Cc") // LF
  inspect(@ucd.general_category('\r'), content="Cc") // CR
}

///|
test "general_category: space" {
  inspect(@ucd.general_category(' '), content="Zs") // SPACE
}

///|
test "general_category: CJK ideographs" {
  inspect(@ucd.general_category('\u{4E00}'), content="Lo") // First CJK Unified Ideograph
  inspect(@ucd.general_category('\u{4E01}'), content="Lo") // Interior range member
  inspect(@ucd.general_category('\u{9FFF}'), content="Lo") // Last CJK Unified Ideograph (approx)
  inspect(@ucd.general_category('\u{20001}'), content="Lo") // Supplementary range member
}

///|
test "general_category: Hangul syllables" {
  inspect(@ucd.general_category('\u{AC00}'), content="Lo")
  inspect(@ucd.general_category('\u{B098}'), content="Lo")
  inspect(@ucd.general_category('\u{D7A3}'), content="Lo")
}

///|
test "general_category: marks" {
  inspect(@ucd.general_category('\u{0300}'), content="Mn") // COMBINING GRAVE ACCENT
  inspect(@ucd.general_category('\u{0301}'), content="Mn") // COMBINING ACUTE ACCENT
  inspect(@ucd.general_category('\u{0903}'), content="Mc") // DEVANAGARI SIGN VISARGA
}

///|
test "general_category: private use" {
  inspect(@ucd.general_category('\u{E000}'), content="Co") // Private Use Area start
  inspect(@ucd.general_category('\u{E001}'), content="Co") // Interior range member
  inspect(@ucd.general_category('\u{F0001}'), content="Co") // Supplementary private use
}

///|
test "general_category: format characters (Cf)" {
  // Format (Cf) characters embedded in ordinary text (joiners, direction
  // marks, the BOM) must resolve to Cf without panicking.
  inspect(@ucd.general_category('\u{00AD}'), content="Cf") // SOFT HYPHEN
  inspect(@ucd.general_category('\u{0600}'), content="Cf") // ARABIC NUMBER SIGN
  inspect(@ucd.general_category('\u{200B}'), content="Cf") // ZERO WIDTH SPACE
  inspect(@ucd.general_category('\u{200C}'), content="Cf") // ZERO WIDTH NON-JOINER
  inspect(@ucd.general_category('\u{200D}'), content="Cf") // ZERO WIDTH JOINER
  inspect(@ucd.general_category('\u{200E}'), content="Cf") // LEFT-TO-RIGHT MARK
  inspect(@ucd.general_category('\u{2060}'), content="Cf") // WORD JOINER
  inspect(@ucd.general_category('\u{FEFF}'), content="Cf") // ZERO WIDTH NO-BREAK SPACE (BOM)
}

///|
test "GeneralCategory::group" {
  // Letters
  assert_eq(@ucd.general_category('A').group(), L)
  assert_eq(@ucd.general_category('a').group(), L)
  // Numbers
  assert_eq(@ucd.general_category('0').group(), N)
  assert_eq(@ucd.general_category('9').group(), N)
  // Marks
  assert_eq(@ucd.general_category('\u{0300}').group(), M) // COMBINING GRAVE ACCENT
  // Separators
  assert_eq(@ucd.general_category(' ').group(), Z)
  // Punctuation
  assert_eq(@ucd.general_category('!').group(), P)
  // Symbols
  assert_eq(@ucd.general_category('$').group(), S)
  // Other
  assert_eq(@ucd.general_category('\u{00}').group(), C) // NUL
}

///|
test "XID_Start and XID_Continue" {
  inspect(@ucd.is_xid_start('A'), content="true")
  inspect(@ucd.is_xid_continue('A'), content="true")
  inspect(@ucd.is_xid_start('中'), content="true")
  inspect(@ucd.is_xid_continue('中'), content="true")
  inspect(@ucd.is_xid_start('0'), content="false")
  inspect(@ucd.is_xid_continue('0'), content="true")
  inspect(@ucd.is_xid_start('_'), content="false")
  inspect(@ucd.is_xid_continue('_'), content="true")
  inspect(@ucd.is_xid_start('\u{0301}'), content="false")
  inspect(@ucd.is_xid_continue('\u{0301}'), content="true")
  inspect(@ucd.is_xid_start('\u{2118}'), content="true")
  inspect(@ucd.is_xid_continue('\u{00B7}'), content="true")
  inspect(@ucd.is_xid_start('-'), content="false")
  inspect(@ucd.is_xid_continue('-'), content="false")
  inspect(@ucd.is_xid_start('\u{1F600}'), content="false")
  inspect(@ucd.is_xid_continue('\u{1F600}'), content="false")
}

///|
test "White_Space" {
  inspect(@ucd.is_white_space(' '), content="true")
  inspect(@ucd.is_white_space('\t'), content="true")
  inspect(@ucd.is_white_space('\n'), content="true")
  inspect(@ucd.is_white_space('\u{0B}'), content="true") // LINE TABULATION
  inspect(@ucd.is_white_space('\r'), content="true")
  inspect(@ucd.is_white_space('\u{85}'), content="true") // NEXT LINE
  inspect(@ucd.is_white_space('\u{A0}'), content="true") // NO-BREAK SPACE
  inspect(@ucd.is_white_space('\u{2028}'), content="true") // LINE SEPARATOR
  inspect(@ucd.is_white_space('\u{3000}'), content="true") // IDEOGRAPHIC SPACE
  inspect(@ucd.is_white_space('a'), content="false")
  inspect(@ucd.is_white_space('\u{1C}'), content="false") // FILE SEPARATOR
  inspect(@ucd.is_white_space('\u{200B}'), content="false") // ZERO WIDTH SPACE
  inspect(@ucd.is_white_space('\u{FEFF}'), content="false") // ZERO WIDTH NO-BREAK SPACE
}

///|
test "Alphabetic" {
  inspect(@ucd.is_alphabetic('A'), content="true")
  inspect(@ucd.is_alphabetic('z'), content="true")
  inspect(@ucd.is_alphabetic('中'), content="true")
  inspect(@ucd.is_alphabetic('\u{01C5}'), content="true") // Lt
  inspect(@ucd.is_alphabetic('\u{2160}'), content="true") // ROMAN NUMERAL ONE (Nl)
  inspect(@ucd.is_alphabetic('\u{093E}'), content="true") // DEVANAGARI VOWEL SIGN AA (Mc)
  inspect(@ucd.is_alphabetic('\u{20001}'), content="true") // CJK Extension B
  inspect(@ucd.is_alphabetic('0'), content="false")
  inspect(@ucd.is_alphabetic('_'), content="false")
  inspect(@ucd.is_alphabetic('\u{0301}'), content="false") // COMBINING ACUTE ACCENT
  inspect(@ucd.is_alphabetic('\u{1F600}'), content="false")
  inspect(@ucd.is_alphabetic('\u{E0100}'), content="false")
}

///|
test "Lowercase and Uppercase" {
  inspect(@ucd.is_lowercase('a'), content="true")
  inspect(@ucd.is_lowercase('A'), content="false")
  inspect(@ucd.is_uppercase('A'), content="true")
  inspect(@ucd.is_uppercase('a'), content="false")
  inspect(@ucd.is_lowercase('\u{00DF}'), content="true") // LATIN SMALL LETTER SHARP S
  // Other_Lowercase characters outside General_Category Ll
  inspect(@ucd.is_lowercase('\u{00AA}'), content="true") // FEMININE ORDINAL INDICATOR (Lo)
  inspect(@ucd.is_lowercase('\u{02B0}'), content="true") // MODIFIER LETTER SMALL H (Lm)
  inspect(@ucd.is_lowercase('\u{2170}'), content="true") // SMALL ROMAN NUMERAL ONE (Nl)
  inspect(@ucd.is_lowercase('\u{24D0}'), content="true") // CIRCLED LATIN SMALL LETTER A (So)
  // Other_Uppercase characters outside General_Category Lu
  inspect(@ucd.is_uppercase('\u{2160}'), content="true") // ROMAN NUMERAL ONE (Nl)
  inspect(@ucd.is_uppercase('\u{24B6}'), content="true") // CIRCLED LATIN CAPITAL LETTER A (So)
  inspect(@ucd.is_uppercase('\u{1F130}'), content="true") // SQUARED LATIN CAPITAL LETTER A
  // Titlecase letters are neither
  inspect(@ucd.is_lowercase('\u{01C5}'), content="false")
  inspect(@ucd.is_uppercase('\u{01C5}'), content="false")
  // Caseless characters
  inspect(@ucd.is_lowercase('中'), content="false")
  inspect(@ucd.is_uppercase('中'), content="false")
  inspect(@ucd.is_lowercase('0'), content="false")
  inspect(@ucd.is_uppercase('0'), content="false")
}

///|
test "to_simple_uppercase: basic" {
  inspect(@ucd.to_simple_uppercase('a'), content="A")
  inspect(@ucd.to_simple_uppercase('z'), content="Z")
  inspect(@ucd.to_simple_uppercase('A'), content="A") // unchanged
  inspect(@ucd.to_simple_uppercase('0'), content="0") // unchanged
}

///|
test "to_simple_lowercase: basic" {
  inspect(@ucd.to_simple_lowercase('A'), content="a")
  inspect(@ucd.to_simple_lowercase('Z'), content="z")
  inspect(@ucd.to_simple_lowercase('a'), content="a") // unchanged
  inspect(@ucd.to_simple_lowercase('0'), content="0") // unchanged
}

///|
test "to_simple_titlecase: basic" {
  // For most characters, titlecase == uppercase
  inspect(@ucd.to_simple_titlecase('a'), content="A")
  inspect(@ucd.to_simple_titlecase('A'), content="A") // unchanged
}

///|
test "case mapping: Greek letters" {
  inspect(@ucd.to_simple_uppercase('\u{03B1}'), content="Α") // alpha -> ALPHA
  inspect(@ucd.to_simple_lowercase('\u{0391}'), content="α") // ALPHA -> alpha
}

///|
test "case mapping: German sharp s" {
  // LATIN SMALL LETTER SHARP S has simple uppercase to itself
  // (full uppercase is "SS" but simple mapping is same)
  inspect(@ucd.to_simple_uppercase('\u{00DF}'), content="ß") // sharp s -> sharp s
}

///|
test "case mapping: roundtrip for ASCII" {
  // Test uppercase letters A-Z
  for i = 0; i < 26; i = i + 1 {
    let cp = 'A'.to_int() + i
    let c = cp.unsafe_to_char()
    let lower = @ucd.to_simple_lowercase(c)
    let back_to_upper = @ucd.to_simple_uppercase(lower)
    assert_eq(back_to_upper, c)
  }
  // Test lowercase letters a-z
  for i = 0; i < 26; i = i + 1 {
    let cp = 'a'.to_int() + i
    let c = cp.unsafe_to_char()
    let upper = @ucd.to_simple_uppercase(c)
    let back_to_lower = @ucd.to_simple_lowercase(upper)
    assert_eq(back_to_lower, c)
  }
}

///|
test "to_uppercase: German sharp s" {
  // LATIN SMALL LETTER SHARP S -> "SS"
  inspect(@ucd.to_uppercase('\u{00DF}'), content="SS")
}

///|
test "to_uppercase: ligatures" {
  // LATIN SMALL LIGATURE FF -> "FF"
  inspect(@ucd.to_uppercase('\u{FB00}'), content="FF")
  // LATIN SMALL LIGATURE FFI -> "FFI"
  inspect(@ucd.to_uppercase('\u{FB03}'), content="FFI")
  // LATIN SMALL LIGATURE FFL -> "FFL"
  inspect(@ucd.to_uppercase('\u{FB04}'), content="FFL")
}

///|
test "to_titlecase: German sharp s" {
  // LATIN SMALL LETTER SHARP S -> "Ss"
  inspect(@ucd.to_titlecase('\u{00DF}'), content="Ss")
}

///|
test "to_titlecase: ligatures" {
  // LATIN SMALL LIGATURE FF -> "Ff"
  inspect(@ucd.to_titlecase('\u{FB00}'), content="Ff")
  // LATIN SMALL LIGATURE FFI -> "Ffi"
  inspect(@ucd.to_titlecase('\u{FB03}'), content="Ffi")
}

///|
test "to_lowercase: I with dot above" {
  // LATIN CAPITAL LETTER I WITH DOT ABOVE -> "i" + combining dot above
  inspect(@ucd.to_lowercase('\u{0130}'), content="i\u{0307}")
}

///|
test "full case: regular letters" {
  // Regular letters should go through simple mappings
  inspect(@ucd.to_uppercase('a'), content="A")
  inspect(@ucd.to_uppercase('z'), content="Z")
  inspect(@ucd.to_lowercase('A'), content="a")
  inspect(@ucd.to_lowercase('Z'), content="z")
  inspect(@ucd.to_titlecase('a'), content="A")
}

///|
test "full case: no mapping returns identity" {
  // Characters without mappings return themselves
  inspect(@ucd.to_uppercase('0'), content="0")
  inspect(@ucd.to_lowercase('0'), content="0")
  inspect(@ucd.to_titlecase('!'), content="!")
}

///|
test "east_asian_width: each value" {
  inspect(@ucd.east_asian_width('\u{00A1}'), content="A") // INVERTED EXCLAMATION MARK
  inspect(@ucd.east_asian_width('\u{FF21}'), content="F") // FULLWIDTH LATIN CAPITAL LETTER A
  inspect(@ucd.east_asian_width('\u{FF71}'), content="H") // HALFWIDTH KATAKANA LETTER A
  inspect(@ucd.east_asian_width('\u{05D0}'), content="N") // HEBREW LETTER ALEF
  inspect(@ucd.east_asian_width('a'), content="Na")
  inspect(@ucd.east_asian_width('\u{4E2D}'), content="W") // CJK UNIFIED IDEOGRAPH-4E2D
}

///|
test "east_asian_width: ASCII is Narrow except controls" {
  inspect(@ucd.east_asian_width(' '), content="Na")
  inspect(@ucd.east_asian_width('~'), content="Na")
  inspect(@ucd.east_asian_width('\n'), content="N")
  inspect(@ucd.east_asian_width('\u{7F}'), content="N")
}

///|
test "east_asian_width: East Asian scripts" {
  inspect(@ucd.east_asian_width('\u{3042}'), content="W") // HIRAGANA LETTER A
  inspect(@ucd.east_asian_width('\u{AC00}'), content="W") // HANGUL SYLLABLE GA
  inspect(@ucd.east_asian_width('\u{3000}'), content="F") // IDEOGRAPHIC SPACE
  inspect(@ucd.east_asian_width('\u{20A9}'), content="H") // WON SIGN
  inspect(@ucd.east_asian_width('\u{1F600}'), content="W") // GRINNING FACE
}

///|
test "east_asian_width: a mark keeps its own value" {
  // East_Asian_Width is not a column count: a combining mark is Ambiguous
  // even though it occupies no column of its own.
  inspect(@ucd.east_asian_width('\u{0300}'), content="A") // COMBINING GRAVE ACCENT
}

///|
test "east_asian_width: unassigned code points" {
  inspect(@ucd.east_asian_width('\u{0378}'), content="N") // reserved
  inspect(@ucd.east_asian_width('\u{2FFFD}'), content="W") // reserved, plane 2
  inspect(@ucd.east_asian_width('\u{3FFFD}'), content="W") // reserved, plane 3
}

///|
test "east_asian_width: planes above the trie" {
  inspect(@ucd.east_asian_width('\u{40000}'), content="N") // reserved, plane 4
  inspect(@ucd.east_asian_width('\u{E0001}'), content="N") // LANGUAGE TAG
  inspect(@ucd.east_asian_width('\u{E0100}'), content="A") // VARIATION SELECTOR-17
  inspect(@ucd.east_asian_width('\u{F0000}'), content="A") // private use, plane 15
  inspect(@ucd.east_asian_width('\u{10FFFD}'), content="A") // private use, plane 16
  inspect(@ucd.east_asian_width('\u{10FFFF}'), content="N") // noncharacter
}

///|
test "Default_Ignorable_Code_Point" {
  inspect(@ucd.is_default_ignorable_code_point('\u{00AD}'), content="true") // SOFT HYPHEN
  inspect(@ucd.is_default_ignorable_code_point('\u{034F}'), content="true") // COMBINING GRAPHEME JOINER
  inspect(@ucd.is_default_ignorable_code_point('\u{115F}'), content="true") // HANGUL CHOSEONG FILLER
  inspect(@ucd.is_default_ignorable_code_point('\u{200B}'), content="true") // ZERO WIDTH SPACE
  inspect(@ucd.is_default_ignorable_code_point('\u{200D}'), content="true") // ZERO WIDTH JOINER
  inspect(@ucd.is_default_ignorable_code_point('\u{202E}'), content="true") // RIGHT-TO-LEFT OVERRIDE
  inspect(@ucd.is_default_ignorable_code_point('\u{FE0F}'), content="true") // VARIATION SELECTOR-16
  inspect(@ucd.is_default_ignorable_code_point('\u{FEFF}'), content="true") // ZERO WIDTH NO-BREAK SPACE
  inspect(@ucd.is_default_ignorable_code_point('\u{E0001}'), content="true") // LANGUAGE TAG
  inspect(@ucd.is_default_ignorable_code_point('\u{E0100}'), content="true") // VARIATION SELECTOR-17
  inspect(@ucd.is_default_ignorable_code_point('\u{E0FFF}'), content="true") // reserved
  inspect(@ucd.is_default_ignorable_code_point('a'), content="false")
  inspect(@ucd.is_default_ignorable_code_point(' '), content="false")
  inspect(@ucd.is_default_ignorable_code_point('\u{0301}'), content="false") // COMBINING ACUTE ACCENT
  inspect(@ucd.is_default_ignorable_code_point('\u{0600}'), content="false") // ARABIC NUMBER SIGN
  inspect(@ucd.is_default_ignorable_code_point('\u{E1000}'), content="false") // reserved
}

///|
test "Grapheme_Extend" {
  inspect(@ucd.is_grapheme_extend('\u{0301}'), content="true") // COMBINING ACUTE ACCENT (Mn)
  inspect(@ucd.is_grapheme_extend('\u{20DD}'), content="true") // COMBINING ENCLOSING CIRCLE (Me)
  inspect(@ucd.is_grapheme_extend('\u{200C}'), content="true") // ZERO WIDTH NON-JOINER (Cf)
  inspect(@ucd.is_grapheme_extend('\u{09BE}'), content="true") // BENGALI VOWEL SIGN AA (Mc)
  inspect(@ucd.is_grapheme_extend('\u{E0020}'), content="true") // TAG SPACE
  inspect(@ucd.is_grapheme_extend('\u{E0100}'), content="true") // VARIATION SELECTOR-17
  inspect(@ucd.is_grapheme_extend('\u{200D}'), content="false") // ZERO WIDTH JOINER
  // Grapheme_Cluster_Break=Extend also covers the emoji modifiers, which are
  // not Grapheme_Extend.
  inspect(@ucd.is_grapheme_extend('\u{1F3FB}'), content="false") // EMOJI MODIFIER FITZPATRICK TYPE-1-2
  inspect(@ucd.is_grapheme_extend('\u{093E}'), content="false") // DEVANAGARI VOWEL SIGN AA (Mc)
  inspect(@ucd.is_grapheme_extend('\u{00AD}'), content="false") // SOFT HYPHEN
  inspect(@ucd.is_grapheme_extend('a'), content="false")
}

///|
test "Regional_Indicator" {
  inspect(@ucd.is_regional_indicator('\u{1F1E6}'), content="true") // REGIONAL INDICATOR SYMBOL LETTER A
  inspect(@ucd.is_regional_indicator('\u{1F1FF}'), content="true") // REGIONAL INDICATOR SYMBOL LETTER Z
  inspect(@ucd.is_regional_indicator('\u{1F1E5}'), content="false")
  inspect(@ucd.is_regional_indicator('\u{1F200}'), content="false")
  inspect(@ucd.is_regional_indicator('A'), content="false")
}

///|
test "Prepended_Concatenation_Mark" {
  inspect(@ucd.is_prepended_concatenation_mark('\u{0600}'), content="true") // ARABIC NUMBER SIGN
  inspect(@ucd.is_prepended_concatenation_mark('\u{06DD}'), content="true") // ARABIC END OF AYAH
  inspect(@ucd.is_prepended_concatenation_mark('\u{070F}'), content="true") // SYRIAC ABBREVIATION MARK
  inspect(@ucd.is_prepended_concatenation_mark('\u{110BD}'), content="true") // KAITHI NUMBER SIGN
  inspect(@ucd.is_prepended_concatenation_mark('\u{0606}'), content="false") // ARABIC-INDIC CUBE ROOT
  inspect(@ucd.is_prepended_concatenation_mark('\u{061C}'), content="false") // ARABIC LETTER MARK
  inspect(@ucd.is_prepended_concatenation_mark('a'), content="false")
}

///|
test "Emoji_Presentation" {
  inspect(@ucd.is_emoji_presentation('\u{231A}'), content="true") // WATCH
  inspect(@ucd.is_emoji_presentation('\u{1F600}'), content="true") // GRINNING FACE
  inspect(@ucd.is_emoji_presentation('\u{1F1E6}'), content="true") // REGIONAL INDICATOR SYMBOL LETTER A
  inspect(@ucd.is_emoji_presentation('\u{1F3FB}'), content="true") // EMOJI MODIFIER FITZPATRICK TYPE-1-2
  // Emoji whose default presentation is text
  inspect(@ucd.is_emoji_presentation('#'), content="false")
  inspect(@ucd.is_emoji_presentation('0'), content="false")
  inspect(@ucd.is_emoji_presentation('\u{00A9}'), content="false") // COPYRIGHT SIGN
  inspect(@ucd.is_emoji_presentation('\u{2764}'), content="false") // HEAVY BLACK HEART
  inspect(@ucd.is_emoji_presentation('\u{261D}'), content="false") // WHITE UP POINTING INDEX
  inspect(@ucd.is_emoji_presentation('a'), content="false")
}

///|
test "Emoji_Modifier and Emoji_Modifier_Base" {
  inspect(@ucd.is_emoji_modifier('\u{1F3FB}'), content="true") // EMOJI MODIFIER FITZPATRICK TYPE-1-2
  inspect(@ucd.is_emoji_modifier('\u{1F3FF}'), content="true") // EMOJI MODIFIER FITZPATRICK TYPE-6
  inspect(@ucd.is_emoji_modifier('\u{1F3FA}'), content="false") // AMPHORA
  inspect(@ucd.is_emoji_modifier('\u{1F44D}'), content="false") // THUMBS UP SIGN
  inspect(@ucd.is_emoji_modifier_base('\u{1F44D}'), content="true") // THUMBS UP SIGN
  inspect(@ucd.is_emoji_modifier_base('\u{261D}'), content="true") // WHITE UP POINTING INDEX
  inspect(@ucd.is_emoji_modifier_base('\u{1F9D1}'), content="true") // ADULT
  inspect(@ucd.is_emoji_modifier_base('\u{1F600}'), content="false") // GRINNING FACE
  inspect(@ucd.is_emoji_modifier_base('\u{1F3FB}'), content="false")
}

///|
test "joining_type: each value" {
  inspect(@ucd.joining_type('a'), content="NonJoining")
  inspect(@ucd.joining_type('\u{200D}'), content="JoinCausing") // ZERO WIDTH JOINER
  inspect(@ucd.joining_type('\u{0640}'), content="JoinCausing") // ARABIC TATWEEL
  inspect(@ucd.joining_type('\u{0628}'), content="DualJoining") // ARABIC LETTER BEH
  inspect(@ucd.joining_type('\u{A872}'), content="LeftJoining") // PHAGS-PA SUPERFIXED LETTER RA
  inspect(@ucd.joining_type('\u{0627}'), content="RightJoining") // ARABIC LETTER ALEF
  inspect(@ucd.joining_type('\u{064B}'), content="Transparent") // ARABIC FATHATAN
}

///|
test "joining_type: non-joining and transparent characters" {
  inspect(@ucd.joining_type('\u{200C}'), content="NonJoining") // ZERO WIDTH NON-JOINER
  inspect(@ucd.joining_type('\u{0621}'), content="NonJoining") // ARABIC LETTER HAMZA
  inspect(@ucd.joining_type('\u{0378}'), content="NonJoining") // reserved
  inspect(@ucd.joining_type('\u{00AD}'), content="Transparent") // SOFT HYPHEN
  inspect(@ucd.joining_type('\u{0301}'), content="Transparent") // COMBINING ACUTE ACCENT
  inspect(@ucd.joining_type('\u{0338}'), content="Transparent") // COMBINING LONG SOLIDUS OVERLAY
}

///|
test "joining_type: planes above the trie" {
  inspect(@ucd.joining_type('\u{40000}'), content="NonJoining") // reserved, plane 4
  inspect(@ucd.joining_type('\u{E0001}'), content="Transparent") // LANGUAGE TAG
  inspect(@ucd.joining_type('\u{E0100}'), content="Transparent") // VARIATION SELECTOR-17
  inspect(@ucd.joining_type('\u{E01F0}'), content="NonJoining") // reserved
  inspect(@ucd.joining_type('\u{10FFFF}'), content="NonJoining") // noncharacter
}

///|
test "emoji variation sequences" {
  // Text by default: VARIATION SELECTOR-16 asks for the emoji presentation.
  inspect(@ucd.has_emoji_variation_sequence('#'), content="true")
  inspect(@ucd.has_emoji_variation_sequence('0'), content="true")
  inspect(@ucd.has_emoji_variation_sequence('\u{00A9}'), content="true") // COPYRIGHT SIGN
  inspect(@ucd.has_emoji_variation_sequence('\u{2764}'), content="true") // HEAVY BLACK HEART
  // Emoji by default: VARIATION SELECTOR-15 asks for the text presentation.
  inspect(@ucd.has_emoji_variation_sequence('\u{231A}'), content="true") // WATCH
  inspect(@ucd.has_emoji_variation_sequence('\u{1F004}'), content="true") // MAHJONG TILE RED DRAGON
  // Emoji without a text presentation to select
  inspect(@ucd.has_emoji_variation_sequence('\u{1F600}'), content="false") // GRINNING FACE
  inspect(@ucd.has_emoji_variation_sequence('\u{1F1E6}'), content="false") // REGIONAL INDICATOR SYMBOL LETTER A
  inspect(@ucd.has_emoji_variation_sequence('\u{1F3FB}'), content="false") // EMOJI MODIFIER FITZPATRICK TYPE-1-2
  inspect(@ucd.has_emoji_variation_sequence('a'), content="false")
  inspect(@ucd.has_emoji_variation_sequence('\u{FE0F}'), content="false") // VARIATION SELECTOR-16
}

///|
test "hangul_syllable_type: each value" {
  inspect(@ucd.hangul_syllable_type('a'), content="NotApplicable")
  inspect(@ucd.hangul_syllable_type('\u{1100}'), content="LeadingJamo") // HANGUL CHOSEONG KIYEOK
  inspect(@ucd.hangul_syllable_type('\u{1161}'), content="VowelJamo") // HANGUL JUNGSEONG A
  inspect(@ucd.hangul_syllable_type('\u{11A8}'), content="TrailingJamo") // HANGUL JONGSEONG KIYEOK
  inspect(@ucd.hangul_syllable_type('\u{AC00}'), content="LVSyllable") // HANGUL SYLLABLE GA
  inspect(@ucd.hangul_syllable_type('\u{AC01}'), content="LVTSyllable") // HANGUL SYLLABLE GAG
}

///|
test "hangul_syllable_type: jamo blocks and syllable boundaries" {
  inspect(@ucd.hangul_syllable_type('\u{115F}'), content="LeadingJamo") // HANGUL CHOSEONG FILLER
  inspect(@ucd.hangul_syllable_type('\u{1160}'), content="VowelJamo") // HANGUL JUNGSEONG FILLER
  inspect(@ucd.hangul_syllable_type('\u{A960}'), content="LeadingJamo") // HANGUL CHOSEONG TIKEUT-MIEUM
  inspect(@ucd.hangul_syllable_type('\u{D7B0}'), content="VowelJamo") // HANGUL JUNGSEONG O-YEO
  inspect(@ucd.hangul_syllable_type('\u{D7CB}'), content="TrailingJamo") // HANGUL JONGSEONG NIEUN-RIEUL
  inspect(@ucd.hangul_syllable_type('\u{AC1C}'), content="LVSyllable") // HANGUL SYLLABLE GAE
  inspect(@ucd.hangul_syllable_type('\u{D7A3}'), content="LVTSyllable") // HANGUL SYLLABLE HIH
  inspect(@ucd.hangul_syllable_type('\u{D7A4}'), content="NotApplicable") // reserved
}

///|
test "hangul_syllable_type: characters outside the conjoining jamo" {
  inspect(@ucd.hangul_syllable_type('\u{3131}'), content="NotApplicable") // HANGUL LETTER KIYEOK
  inspect(@ucd.hangul_syllable_type('\u{FFA1}'), content="NotApplicable") // HALFWIDTH HANGUL LETTER KIYEOK
  // Grapheme_Cluster_Break=V outside Hangul
  inspect(@ucd.hangul_syllable_type('\u{16D63}'), content="NotApplicable") // KIRAT RAI VOWEL SIGN AA
  inspect(@ucd.hangul_syllable_type('\u{E0100}'), content="NotApplicable") // VARIATION SELECTOR-17
}

///|
test "line_break: common classes" {
  inspect(@ucd.line_break('a'), content="AL")
  inspect(@ucd.line_break('0'), content="NU")
  inspect(@ucd.line_break(' '), content="SP")
  inspect(@ucd.line_break('\n'), content="LF")
  inspect(@ucd.line_break('\r'), content="CR")
  inspect(@ucd.line_break('\u{0C}'), content="BK") // FORM FEED
  inspect(@ucd.line_break('\u{85}'), content="NL") // NEXT LINE
  inspect(@ucd.line_break('('), content="OP")
  inspect(@ucd.line_break(')'), content="CP")
  inspect(@ucd.line_break('}'), content="CL")
  inspect(@ucd.line_break('!'), content="EX")
  inspect(@ucd.line_break('"'), content="QU")
  inspect(@ucd.line_break('-'), content="HY")
  inspect(@ucd.line_break('/'), content="SY")
  inspect(@ucd.line_break(','), content="IS")
  inspect(@ucd.line_break('$'), content="PR")
  inspect(@ucd.line_break('%'), content="PO")
  inspect(@ucd.line_break('\u{A0}'), content="GL") // NO-BREAK SPACE
  inspect(@ucd.line_break('\u{0301}'), content="CM") // COMBINING ACUTE ACCENT
  inspect(@ucd.line_break('\u{200B}'), content="ZW") // ZERO WIDTH SPACE
  inspect(@ucd.line_break('\u{200D}'), content="ZWJ") // ZERO WIDTH JOINER
  inspect(@ucd.line_break('\u{2060}'), content="WJ") // WORD JOINER
  inspect(@ucd.line_break('\u{2014}'), content="B2") // EM DASH
  inspect(@ucd.line_break('\u{FFFC}'), content="CB") // OBJECT REPLACEMENT CHARACTER
}

///|
test "line_break: East Asian and Hangul classes" {
  inspect(@ucd.line_break('\u{4E2D}'), content="ID") // CJK UNIFIED IDEOGRAPH-4E2D
  inspect(@ucd.line_break('\u{3042}'), content="ID") // HIRAGANA LETTER A
  inspect(@ucd.line_break('\u{3041}'), content="CJ") // HIRAGANA LETTER SMALL A
  inspect(@ucd.line_break('\u{3005}'), content="NS") // IDEOGRAPHIC ITERATION MARK
  inspect(@ucd.line_break('\u{3001}'), content="CL") // IDEOGRAPHIC COMMA
  inspect(@ucd.line_break('\u{1100}'), content="JL") // HANGUL CHOSEONG KIYEOK
  inspect(@ucd.line_break('\u{1161}'), content="JV") // HANGUL JUNGSEONG A
  inspect(@ucd.line_break('\u{11A8}'), content="JT") // HANGUL JONGSEONG KIYEOK
  inspect(@ucd.line_break('\u{AC00}'), content="H2") // HANGUL SYLLABLE GA
  inspect(@ucd.line_break('\u{AC01}'), content="H3") // HANGUL SYLLABLE GAG
}

///|
test "line_break: classes rule LB1 resolves are returned unresolved" {
  inspect(@ucd.line_break('\u{00A7}'), content="AI") // SECTION SIGN
  inspect(@ucd.line_break('\u{2460}'), content="AI") // CIRCLED DIGIT ONE
  inspect(@ucd.line_break('\u{0E01}'), content="SA") // THAI CHARACTER KO KAI
  inspect(@ucd.line_break('\u{0378}'), content="XX") // reserved
  inspect(@ucd.line_break('\u{E000}'), content="XX") // private use
}

///|
test "line_break: emoji, Hebrew, and Brahmic classes" {
  inspect(@ucd.line_break('\u{1F1E6}'), content="RI") // REGIONAL INDICATOR SYMBOL LETTER A
  inspect(@ucd.line_break('\u{1F44D}'), content="EB") // THUMBS UP SIGN
  inspect(@ucd.line_break('\u{1F3FB}'), content="EM") // EMOJI MODIFIER FITZPATRICK TYPE-1-2
  inspect(@ucd.line_break('\u{1F600}'), content="ID") // GRINNING FACE
  inspect(@ucd.line_break('\u{05D0}'), content="HL") // HEBREW LETTER ALEF
  inspect(@ucd.line_break('\u{2010}'), content="HH") // HYPHEN
  inspect(@ucd.line_break('\u{1B05}'), content="AK") // BALINESE LETTER AKARA
  inspect(@ucd.line_break('\u{1B44}'), content="VI") // BALINESE ADEG ADEG
  inspect(@ucd.line_break('\u{1BF2}'), content="VF") // BATAK PANGOLAT
  inspect(@ucd.line_break('\u{1B50}'), content="AS") // BALINESE DIGIT ZERO
  inspect(@ucd.line_break('\u{11003}'), content="AP") // BRAHMI SIGN JIHVAMULIYA
}

///|
test "line_break: unassigned code points" {
  inspect(@ucd.line_break('\u{20CF}'), content="PR") // reserved, Currency Symbols
  inspect(@ucd.line_break('\u{2FFFD}'), content="ID") // reserved, plane 2
  inspect(@ucd.line_break('\u{3FFFD}'), content="ID") // reserved, plane 3
  inspect(@ucd.line_break('\u{1FAFF}'), content="ID") // reserved
  inspect(@ucd.line_break('\u{2FFFE}'), content="XX") // noncharacter
}

///|
test "line_break: planes above the trie" {
  inspect(@ucd.line_break('\u{40000}'), content="XX") // reserved, plane 4
  inspect(@ucd.line_break('\u{E0001}'), content="CM") // LANGUAGE TAG
  inspect(@ucd.line_break('\u{E0100}'), content="CM") // VARIATION SELECTOR-17
  inspect(@ucd.line_break('\u{F0000}'), content="XX") // private use, plane 15
  inspect(@ucd.line_break('\u{10FFFF}'), content="XX") // noncharacter
}

///|
test "joining_group: letters sharing a shape share a group" {
  inspect(@ucd.joining_group('\u{0628}'), content="Beh") // ARABIC LETTER BEH
  inspect(@ucd.joining_group('\u{062A}'), content="Beh") // ARABIC LETTER TEH
  inspect(@ucd.joining_group('\u{062B}'), content="Beh") // ARABIC LETTER THEH
  inspect(@ucd.joining_group('\u{0627}'), content="Alef") // ARABIC LETTER ALEF
  inspect(@ucd.joining_group('\u{0622}'), content="Alef") // ARABIC LETTER ALEF WITH MADDA ABOVE
  inspect(@ucd.joining_group('\u{0644}'), content="Lam") // ARABIC LETTER LAM
}

///|
test "joining_group: names of several words" {
  inspect(@ucd.joining_group('\u{06D2}'), content="YehBarree") // ARABIC LETTER YEH BARREE
  inspect(@ucd.joining_group('\u{0629}'), content="TehMarbuta") // ARABIC LETTER TEH MARBUTA
  inspect(@ucd.joining_group('\u{06C3}'), content="TehMarbutaGoal") // ARABIC LETTER TEH MARBUTA GOAL
  inspect(@ucd.joining_group('\u{0710}'), content="Alaph") // SYRIAC LETTER ALAPH
  inspect(@ucd.joining_group('\u{10AC0}'), content="ManichaeanAleph") // MANICHAEAN LETTER ALEPH
}

///|
test "joining_group: characters outside the groups" {
  inspect(@ucd.joining_group('a'), content="NoJoiningGroup")
  // Joining characters without a group
  inspect(@ucd.joining_group('\u{0640}'), content="NoJoiningGroup") // ARABIC TATWEEL
  inspect(@ucd.joining_group('\u{064B}'), content="NoJoiningGroup") // ARABIC FATHATAN
  inspect(@ucd.joining_group('\u{200D}'), content="NoJoiningGroup") // ZERO WIDTH JOINER
  inspect(@ucd.joining_group('\u{0378}'), content="NoJoiningGroup") // reserved
  inspect(@ucd.joining_group('\u{E0100}'), content="NoJoiningGroup") // VARIATION SELECTOR-17
  inspect(@ucd.joining_group('\u{10FFFF}'), content="NoJoiningGroup") // noncharacter
}

///|
test "joining_group: Pe is told apart from the General_Category value" {
  inspect(
    @ucd.joining_group('\u{0726}') == @ucd.JoiningGroup::Pe,
    content="true",
  ) // SYRIAC LETTER PE
  inspect(
    @ucd.general_category(')') == @ucd.GeneralCategory::Pe,
    content="true",
  )
  // The type is known from the other operand, so the name alone is enough.
  inspect(@ucd.joining_group('\u{0726}') == Pe, content="true")
  inspect(@ucd.general_category(')') == Pe, content="true")
}
