///|
test "hangul syllable detection" {
  // 가 (U+AC00) is the first Hangul syllable
  assert_true(@normalization.is_hangul_syllable(0xAC00))
  // 힣 (U+D7A3) is the last Hangul syllable
  assert_true(@normalization.is_hangul_syllable(0xD7A3))
  // ASCII is not a Hangul syllable
  assert_false(@normalization.is_hangul_syllable(0x41))
  // Just before Hangul block
  assert_false(@normalization.is_hangul_syllable(0xABFF))
  // Just after Hangul block
  assert_false(@normalization.is_hangul_syllable(0xD7A4))
}

///|
test "hangul jamo detection" {
  // Leading consonant jamo (L)
  assert_true(@normalization.is_hangul_l(0x1100)) // ᄀ
  assert_true(@normalization.is_hangul_l(0x1112)) // ᄒ (last L)
  assert_false(@normalization.is_hangul_l(0x1113)) // Beyond L range
  // Vowel jamo (V)
  assert_true(@normalization.is_hangul_v(0x1161)) // ᅡ
  assert_true(@normalization.is_hangul_v(0x1175)) // ᅵ (last V)
  assert_false(@normalization.is_hangul_v(0x1176)) // Beyond V range
  // Trailing consonant jamo (T)
  assert_false(@normalization.is_hangul_t(0x11A7)) // T_BASE itself is not valid
  assert_true(@normalization.is_hangul_t(0x11A8)) // ᆨ (first T)
  assert_true(@normalization.is_hangul_t(0x11C2)) // ᇂ (last T)
}

///|
test "hangul LV syllable detection" {
  // 가 (U+AC00) is LV (no trailing)
  assert_true(@normalization.is_hangul_lv(0xAC00))
  // 각 (U+AC01) is LVT (has trailing ᆨ)
  assert_false(@normalization.is_hangul_lv(0xAC01))
  // 나 (U+B098) is LV
  assert_true(@normalization.is_hangul_lv(0xB098))
}

///|
test "hangul decomposition LV" {
  // 가 (U+AC00) = ᄀ (U+1100) + ᅡ (U+1161)
  let result = @normalization.decompose_hangul(0xAC00)
  inspect(result, content="[4352, 4449]") // [0x1100, 0x1161]
}

///|
test "hangul decomposition LVT" {
  // 각 (U+AC01) = ᄀ (U+1100) + ᅡ (U+1161) + ᆨ (U+11A8)
  let result = @normalization.decompose_hangul(0xAC01)
  inspect(result, content="[4352, 4449, 4520]") // [0x1100, 0x1161, 0x11A8]
}

///|
test "hangul decomposition various" {
  // 한 (U+D55C) = ᄒ (U+1112) + ᅡ (U+1161) + ᆫ (U+11AB)
  let result = @normalization.decompose_hangul(0xD55C)
  inspect(result, content="[4370, 4449, 4523]") // [0x1112, 0x1161, 0x11AB]
}

///|
test "hangul composition L+V" {
  // ᄀ + ᅡ -> 가
  let result = @normalization.try_compose_hangul(0x1100, 0x1161)
  inspect(result, content="Some(44032)") // Some(0xAC00)
}

///|
test "hangul composition LV+T" {
  // 가 + ᆨ -> 각
  let result = @normalization.try_compose_hangul(0xAC00, 0x11A8)
  inspect(result, content="Some(44033)") // Some(0xAC01)
}

///|
test "hangul composition invalid" {
  // L + T should not compose
  let result = @normalization.try_compose_hangul(0x1100, 0x11A8)
  inspect(result, content="None")
  // V + V should not compose
  let result2 = @normalization.try_compose_hangul(0x1161, 0x1162)
  inspect(result2, content="None")
  // ASCII should not compose
  let result3 = @normalization.try_compose_hangul(0x41, 0x42)
  inspect(result3, content="None")
}

///|
test "hangul roundtrip" {
  // Decompose and recompose should give same result
  let original = 0xAC01 // 각
  let decomposed = @normalization.decompose_hangul(original)
  // Compose L + V first
  let lv = @normalization.try_compose_hangul(decomposed[0], decomposed[1])
  guard lv is Some(lv_val) else { fail("L+V should compose") }
  // Then compose LV + T
  let lvt = @normalization.try_compose_hangul(lv_val, decomposed[2])
  inspect(lvt, content="Some(44033)") // Same as original
}
