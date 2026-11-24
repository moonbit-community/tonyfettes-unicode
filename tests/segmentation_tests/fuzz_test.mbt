///|
/// Property-based fuzz tests for UAX #29 (grapheme, word, sentence) and
/// UAX #14 (line break) segmentation.

///|
let seg_fuzz_seed : Bytes = b"segmentation-fuzz-seed-test!32!!"

///|
/// Stress-test code units and scalar values spanning every tricky UAX #29 and
/// UAX #14 class (controls, newlines, spaces, quotes, hyphens, combining marks,
/// Indic aksaras/virama, Hangul jamo/syllables, Hebrew, CJK, emoji/ZWJ/RI,
/// unassigned Extended_Pictographic, and unpaired surrogates).
let stress_pool : ReadOnlyArray[Int32] = [
  // ASCII letters, digits, punctuation, spaces, controls
  0x000A, 0x000D, 0x000B, 0x000C, 0x0020, 0x0021, 0x0022, 0x0024, 0x0025, 0x0027,
  0x0028, 0x0029, 0x002C, 0x002D, 0x002E, 0x002F, 0x0030, 0x0039, 0x003A, 0x003B,
  0x003F, 0x0041, 0x005A, 0x005F, 0x0061, 0x007A,
  // Latin-1 / controls / soft hyphen / NEL / NBSP
   0x0085, 0x00A0, 0x00AD, 0x00E9,
  // Combining marks, Prepend, Hebrew, Devanagari Aksara/Virama
   0x0300, 0x0301, 0x0308, 0x05D0, 0x05D1, 0x0600, 0x0915, 0x093E, 0x094D,
  // Thai (SA / Mn)
   0x0E01, 0x0E31,
  // Hangul L, V, T, LV, LVT
   0x1100, 0x1161, 0x11A8, 0xAC00, 0xAC01,
  // ZW, ZWNJ, ZWJ, hyphens, quotes, WJ, LS, PS, Dotted Circle
   0x200B, 0x200C, 0x200D, 0x2010, 0x2014, 0x2018, 0x2019, 0x201C, 0x201D, 0x2024,
  0x2028, 0x2029, 0x2060, 0x25CC,
  // CJK, Katakana, East Asian brackets/quotes, fullwidth
   0x3001, 0x3002, 0x3008, 0x3009, 0x30A2, 0x4E2D, 0xFF08, 0xFF09, 0xFFFC,
  // Regional indicators, emoji, skin tone modifier, unassigned Extended_Pictographic
   0x1F1FA, 0x1F1F8, 0x1F469, 0x1F52C, 0x1F3FD, 0x1FFFD,
]

///|
fn random_stress_string(
  rng : @random.Rand,
  max_len~ : Int32,
  include_unpaired_surrogates~ : Bool,
) -> String {
  let len = rng.int(limit=max_len + 1)
  let units : Array[UInt16] = Array(capacity=len * 2)
  for _ in 0..<len {
    if include_unpaired_surrogates && rng.int(limit=20) == 0 {
      // Unpaired leading or trailing surrogate
      let surr = if rng.int(limit=2) == 0 {
        0xD800 + rng.int(limit=0x400)
      } else {
        0xDC00 + rng.int(limit=0x400)
      }
      units.push(surr.to_uint16())
      continue
    }
    let cp = if rng.int(limit=5) == 0 {
      // Broad Unicode scalar value (BMP or supplementary)
      let raw = rng.int(limit=0x22000)
      if raw >= 0xD800 && raw <= 0xDFFF {
        raw + 0x800
      } else {
        raw
      }
    } else {
      stress_pool[rng.int(limit=stress_pool.length())]
    }
    if cp >= 0x10000 {
      let off = cp - 0x10000
      units.push((0xD800 + (off >> 10)).to_uint16())
      units.push((0xDC00 + (off & 0x3FF)).to_uint16())
    } else {
      units.push(cp.to_uint16())
    }
  }
  string_from_units(units)
}

///|
/// Build a string directly from raw UTF-16 code units, preserving unpaired
/// surrogates.
fn string_from_units(units : Array[UInt16]) -> String {
  let sb = StringBuilder(capacity=2 * units.length())
  let mut i = 0
  while i < units.length() {
    let first = units[i]
    if first.is_leading_surrogate() &&
      i + 1 < units.length() &&
      units[i + 1].is_trailing_surrogate() {
      let cp = 0x10000 +
        ((first.to_int() - 0xD800) << 10) +
        units[i + 1].to_int() -
        0xDC00
      sb.write_char(cp.unsafe_to_char())
      i += 2
    } else {
      sb.write_char(first.to_int().unsafe_to_char())
      i += 1
    }
  }
  sb.to_string()
}

///|
fn random_utf16_string(rng : @random.Rand, max_len~ : Int32) -> String {
  let len = rng.int(limit=max_len + 1)
  let units : Array[UInt16] = Array(capacity=len * 2)
  for _ in 0..<len {
    let choice = rng.int(limit=25)
    if choice == 0 {
      units.push((0xD800 + rng.int(limit=0x400)).to_uint16())
    } else if choice == 1 {
      units.push((0xDC00 + rng.int(limit=0x400)).to_uint16())
    } else if choice < 6 {
      let raw = rng.int(limit=0x22000)
      let cp = if raw >= 0xD800 && raw <= 0xDFFF { raw + 0x800 } else { raw }
      if cp >= 0x10000 {
        let off = cp - 0x10000
        units.push((0xD800 + (off >> 10)).to_uint16())
        units.push((0xDC00 + (off & 0x3FF)).to_uint16())
      } else {
        units.push(cp.to_uint16())
      }
    } else {
      let cp = stress_pool[rng.int(limit=stress_pool.length())]
      if cp >= 0x10000 {
        let off = cp - 0x10000
        units.push((0xD800 + (off >> 10)).to_uint16())
        units.push((0xDC00 + (off & 0x3FF)).to_uint16())
      } else {
        units.push(cp.to_uint16())
      }
    }
  }
  string_from_units(units)
}

///|
/// Verify exact UTF-16 coverage, contiguity, non-emptiness, and that no valid
/// surrogate pair in `view` is split across a segment boundary.
fn check_covering_segments(
  view : StringView,
  segments : Array[StringView],
  label : String,
) -> Unit raise {
  let base = view.start_offset()
  let mut cursor = base
  for seg in segments {
    assert_false(seg.is_empty(), msg="\{label}: empty segment")
    assert_eq(seg.start_offset(), cursor, msg="\{label}: non-contiguous offset")
    let rel_end = cursor - base + seg.length()
    if rel_end < view.length() &&
      view[rel_end - 1].is_leading_surrogate() &&
      view[rel_end].is_trailing_surrogate() {
      fail("\{label}: boundary at \{rel_end} split a valid surrogate pair")
    }
    cursor += seg.length()
  }
  assert_eq(cursor, base + view.length(), msg="\{label}: incomplete coverage")
}

///|
fn segment_is_word_like(seg : StringView) -> Bool {
  let mut offset = 0
  let len = seg.length()
  while offset < len {
    let first = seg[offset]
    let mut cp = first.to_int()
    offset += 1
    if first.is_leading_surrogate() && offset < len {
      let second = seg[offset]
      if second.is_trailing_surrogate() {
        cp = 0x10000 + ((cp - 0xD800) << 10) + second.to_int() - 0xDC00
        offset += 1
      }
    }
    if cp >= 0xD800 && cp <= 0xDFFF {
      continue
    }
    let c = cp.unsafe_to_char()
    if @ucd.is_alphabetic(c) ||
      @ucd.general_category(c) is (@ucd.Nd | @ucd.Nl | @ucd.No) {
      return true
    }
  }
  false
}

///|
test "fuzz: covering, surrogate integrity, word filter, and grapheme/line_break consistency" {
  let rng = @random.Rand::chacha8(seed=seg_fuzz_seed)
  for _ in 0..<600 {
    let text = random_utf16_string(rng, max_len=40)
    let view = text.to_string_view()
    // 1. Graphemes
    let g_segs = @segmentation.graphemes(view).iter().collect()
    check_covering_segments(view, g_segs, "graphemes")
    // 2. Word segments & words filter
    let w_segs = @segmentation.word_segments(view).iter().collect()
    check_covering_segments(view, w_segs, "word_segments")
    let expected_words = w_segs
      .filter(segment_is_word_like)
      .map(s => s.to_owned())
    let actual_words = @segmentation.words(view)
      .iter()
      .map(s => s.to_owned())
      .collect()
    @debug.assert_eq(actual_words, expected_words)
    // 3. Sentences
    let s_segs = @segmentation.sentences(view).iter().collect()
    check_covering_segments(view, s_segs, "sentences")
    // 4. Line breaks and opportunity invariants
    let lb = @segmentation.line_breaks(view)
    @debug.assert_eq(lb.opportunity(), @segmentation.Prohibited)
    let lb_segs : Array[StringView] = []
    let lb_ends : Array[Int32] = []
    let lb_kinds : Array[@segmentation.BreakOpportunity] = []
    for seg in lb {
      let opp = lb.opportunity()
      assert_true(opp != @segmentation.Prohibited)
      lb_segs.push(seg)
      lb_ends.push(seg.start_offset() - view.start_offset() + seg.length())
      lb_kinds.push(opp)
    }
    check_covering_segments(view, lb_segs, "line_breaks")
    if view.length() == 0 {
      @debug.assert_eq(lb.opportunity(), @segmentation.Prohibited)
    } else {
      @debug.assert_eq(lb.opportunity(), @segmentation.Mandatory)
      @debug.assert_eq(lb_kinds[lb_kinds.length() - 1], @segmentation.Mandatory)
    }
    // Exhaustion preserves last opportunity and returns empty view at end.
    let last_opp = lb.opportunity()
    let tail = lb.next()
    assert_true(tail.is_empty())
    assert_eq(tail.start_offset(), view.start_offset() + view.length())
    @debug.assert_eq(lb.opportunity(), last_opp)
    // 5. Graphemes::line_break consistency (both full and randomly skipped queries)
    let g_all = @segmentation.graphemes(view)
    let g_skip = @segmentation.graphemes(view)
    @debug.assert_eq(g_all.line_break(), @segmentation.Prohibited)
    let mut p = 0
    for cluster in g_all {
      let skipped = g_skip.next()
      assert_eq(skipped.start_offset(), cluster.start_offset())
      assert_eq(skipped.length(), cluster.length())
      let end = cluster.start_offset() - view.start_offset() + cluster.length()
      while p < lb_ends.length() && lb_ends[p] < end {
        p += 1
      }
      let expected_kind = if p < lb_ends.length() && lb_ends[p] == end {
        lb_kinds[p]
      } else {
        @segmentation.Prohibited
      }
      @debug.assert_eq(g_all.line_break(), expected_kind)
      // Repeated query must not advance the cursor.
      @debug.assert_eq(g_all.line_break(), expected_kind)
      if rng.int(limit=3) == 0 {
        @debug.assert_eq(g_skip.line_break(), expected_kind)
      }
    }
  }
}

///|
test "fuzz: sub-view context independence and UTF-16 offset preservation" {
  let rng = @random.Rand::chacha8(seed=b"seg-subview-fuzz-seed-testing32!")
  for _ in 0..<300 {
    let prefix = random_stress_string(
      rng,
      max_len=8,
      include_unpaired_surrogates=false,
    )
    let middle = random_stress_string(
      rng,
      max_len=24,
      include_unpaired_surrogates=false,
    )
    let suffix = random_stress_string(
      rng,
      max_len=8,
      include_unpaired_surrogates=false,
    )
    let combined = prefix + middle + suffix
    let start = prefix.length()
    let sub = combined.unsafe_view(start~, end=start + middle.length())
    // Graphemes
    let g_sub = @segmentation.graphemes(sub).iter().collect()
    let g_dir = @segmentation.graphemes(middle).iter().collect()
    assert_eq(g_sub.length(), g_dir.length())
    for i in 0..<g_dir.length() {
      assert_eq(g_sub[i].to_owned(), g_dir[i].to_owned())
      assert_eq(g_sub[i].start_offset(), g_dir[i].start_offset() + start)
    }
    // Word segments
    let w_sub = @segmentation.word_segments(sub).iter().collect()
    let w_dir = @segmentation.word_segments(middle).iter().collect()
    assert_eq(w_sub.length(), w_dir.length())
    for i in 0..<w_dir.length() {
      assert_eq(w_sub[i].to_owned(), w_dir[i].to_owned())
      assert_eq(w_sub[i].start_offset(), w_dir[i].start_offset() + start)
    }
    // Words
    @debug.assert_eq(
      @segmentation.words(sub).iter().map(s => s.to_owned()).collect(),
      @segmentation.words(middle).iter().map(s => s.to_owned()).collect(),
    )
    // Sentences
    let s_sub = @segmentation.sentences(sub).iter().collect()
    let s_dir = @segmentation.sentences(middle).iter().collect()
    assert_eq(s_sub.length(), s_dir.length())
    for i in 0..<s_dir.length() {
      assert_eq(s_sub[i].to_owned(), s_dir[i].to_owned())
      assert_eq(s_sub[i].start_offset(), s_dir[i].start_offset() + start)
    }
    // Line breaks (segments + opportunities)
    let lb_sub = @segmentation.line_breaks(sub)
    let lb_dir = @segmentation.line_breaks(middle)
    for ;; {
      let a = lb_sub.next()
      let b = lb_dir.next()
      assert_eq(a.to_owned(), b.to_owned())
      assert_eq(a.start_offset(), b.start_offset() + start)
      @debug.assert_eq(lb_sub.opportunity(), lb_dir.opportunity())
      if a.is_empty() {
        break
      }
    }
  }
}

///|
test "fuzz: next() and iter() interleaving equivalence" {
  let rng = @random.Rand::chacha8(seed=b"seg-interleave-fuzz-seed-test32!")
  for _ in 0..<250 {
    let text = random_utf16_string(rng, max_len=35)
    // LineBreaks interleaving
    let lb_ref = @segmentation.line_breaks(text)
    let ref_segs : Array[(String, @segmentation.BreakOpportunity)] = []
    for seg in lb_ref {
      ref_segs.push((seg.to_owned(), lb_ref.opportunity()))
    }
    let lb_mix = @segmentation.line_breaks(text)
    let mix_segs : Array[(String, @segmentation.BreakOpportunity)] = []
    for ;; {
      if rng.int(limit=2) == 0 {
        let seg = lb_mix.next()
        if seg.is_empty() {
          break
        }
        mix_segs.push((seg.to_owned(), lb_mix.opportunity()))
      } else {
        let take_n = rng.int(limit=3) + 1
        let mut taken = 0
        for seg in lb_mix.iter().take(take_n) {
          mix_segs.push((seg.to_owned(), lb_mix.opportunity()))
          taken += 1
        }
        if taken < take_n {
          break
        }
      }
    }
    @debug.assert_eq(mix_segs, ref_segs)
    // WordSegments interleaving
    let w_ref = @segmentation.word_segments(text)
      .iter()
      .map(s => s.to_owned())
      .collect()
    let w_mix = @segmentation.word_segments(text)
    let w_out : Array[String] = []
    for ;; {
      if rng.int(limit=2) == 0 {
        let seg = w_mix.next()
        if seg.is_empty() {
          break
        }
        w_out.push(seg.to_owned())
      } else {
        let take_n = rng.int(limit=3) + 1
        let mut taken = 0
        for seg in w_mix.iter().take(take_n) {
          w_out.push(seg.to_owned())
          taken += 1
        }
        if taken < take_n {
          break
        }
      }
    }
    @debug.assert_eq(w_out, w_ref)
    // Sentences interleaving
    let s_ref = @segmentation.sentences(text)
      .iter()
      .map(s => s.to_owned())
      .collect()
    let s_mix = @segmentation.sentences(text)
    let s_out : Array[String] = []
    for ;; {
      if rng.int(limit=2) == 0 {
        let seg = s_mix.next()
        if seg.is_empty() {
          break
        }
        s_out.push(seg.to_owned())
      } else {
        let take_n = rng.int(limit=3) + 1
        let mut taken = 0
        for seg in s_mix.iter().take(take_n) {
          s_out.push(seg.to_owned())
          taken += 1
        }
        if taken < take_n {
          break
        }
      }
    }
    @debug.assert_eq(s_out, s_ref)
  }
}
