///|
/// Hangul syllable constants (from Unicode Chapter 3.12)
/// These enable algorithmic decomposition/composition without lookup tables

///|
/// First Hangul syllable (가)
let hangul_s_base : Int = 0xAC00

///|
/// First leading consonant jamo (ᄀ)
let hangul_l_base : Int = 0x1100

///|
/// First vowel jamo (ᅡ)
let hangul_v_base : Int = 0x1161

///|
/// First trailing consonant jamo (ᆨ) - note: T_BASE itself represents no trailing
let hangul_t_base : Int = 0x11A7

///|
/// Number of leading consonant jamo (19)
let hangul_l_count : Int = 19

///|
/// Number of vowel jamo (21)
let hangul_v_count : Int = 21

///|
/// Number of trailing consonant jamo including none (28)
let hangul_t_count : Int = 28

///|
/// V_COUNT * T_COUNT = 588
let hangul_n_count : Int = 588

///|
/// Total number of Hangul syllables (11172)
let hangul_s_count : Int = 11172

///|
/// Check if a code point is a precomposed Hangul syllable
pub fn is_hangul_syllable(cp : Int) -> Bool {
  cp >= hangul_s_base && cp < hangul_s_base + hangul_s_count
}

///|
/// Check if a code point is a leading consonant jamo (L)
pub fn is_hangul_l(cp : Int) -> Bool {
  cp >= hangul_l_base && cp < hangul_l_base + hangul_l_count
}

///|
/// Check if a code point is a vowel jamo (V)
pub fn is_hangul_v(cp : Int) -> Bool {
  cp >= hangul_v_base && cp < hangul_v_base + hangul_v_count
}

///|
/// Check if a code point is a trailing consonant jamo (T)
/// Note: T_BASE (0x11A7) itself is not a valid trailing jamo
pub fn is_hangul_t(cp : Int) -> Bool {
  cp > hangul_t_base && cp < hangul_t_base + hangul_t_count
}

///|
/// Check if a code point is an LV syllable (no trailing consonant)
pub fn is_hangul_lv(cp : Int) -> Bool {
  if not(is_hangul_syllable(cp)) {
    return false
  }
  (cp - hangul_s_base) % hangul_t_count == 0
}

///|
/// Algorithmically decompose a Hangul syllable into jamo
/// Returns L + V for LV syllables, L + V + T for LVT syllables
pub fn decompose_hangul(syllable : Int) -> Array[Int] {
  let s_index = syllable - hangul_s_base
  let l = hangul_l_base + s_index / hangul_n_count
  let v = hangul_v_base + s_index % hangul_n_count / hangul_t_count
  let t_index = s_index % hangul_t_count
  if t_index == 0 {
    [l, v] // LV syllable
  } else {
    [l, v, hangul_t_base + t_index] // LVT syllable
  }
}

///|
/// Try to compose two code points into a Hangul syllable
/// Returns Some(syllable) if composition is possible, None otherwise
pub fn try_compose_hangul(first : Int, second : Int) -> Int? {
  // L + V -> LV syllable
  if is_hangul_l(first) && is_hangul_v(second) {
    let l_index = first - hangul_l_base
    let v_index = second - hangul_v_base
    return Some(
      hangul_s_base + (l_index * hangul_v_count + v_index) * hangul_t_count,
    )
  }
  // LV + T -> LVT syllable
  if is_hangul_lv(first) && is_hangul_t(second) {
    return Some(first + (second - hangul_t_base))
  }
  None
}
