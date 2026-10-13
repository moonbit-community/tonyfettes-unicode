///|
/// The scan flags the generator derives from packed properties.
fn expected_scan_flags(c : Char) -> Int32 {
  let properties = @ccc.lookup_normalization_properties(c)
  let quick_check = properties >> 8 << 1
  if (properties & 255) != 0 {
    quick_check | 1
  } else {
    quick_check
  }
}

///|
// The scan tables are a second copy of data that unicode-data also carries.
// Check every code point, so a data update that regenerates only one of the
// two modules cannot go unnoticed.
test "BMP scan flags agree with the packed properties" {
  for cp in 0..<0x10000 {
    let block = normalization_scan_index[cp >> NormalizationScanShift].to_int()
    let flags = normalization_scan_flags[(block << NormalizationScanShift) |
    (cp & NormalizationScanBlockMask)].to_int()
    let expected = if cp >= 0xD800 && cp < 0xDC00 {
      NormalizationScanLeadSurrogate
    } else {
      expected_scan_flags(cp.unsafe_to_char())
    }
    guard flags == expected else {
      fail("scan flags \{flags} != \{expected} at code point \{cp}")
    }
  }
}

///|
test "supplementary scan flags agree with the packed properties" {
  for lead in 0..<1024 {
    let generated = if lead < normalization_lead_flags.length() {
      normalization_lead_flags[lead].to_int()
    } else {
      0
    }
    let mut summary = 0
    for trail in 0..<1024 {
      let cp = 0x10000 + (lead << 10) + trail
      let expected = expected_scan_flags(cp.unsafe_to_char())
      let default_tail = lead > NormalizationTailLeadIndex ||
        (
          lead == NormalizationTailLeadIndex &&
          0xDC00 + trail >= NormalizationTailTrail
        )
      guard !default_tail || expected == 0 else {
        fail("code point \{cp} in the default tail has scan flags \{expected}")
      }
      summary = summary | expected
      // The scan reads a pair's own flags whenever its group summary is set.
      if generated != 0 {
        let slot = normalization_lead_slots[lead].to_int()
        let block = normalization_pair_index[(
          slot << (10 - NormalizationPairShift)
        ) |
        (trail >> NormalizationPairShift)].to_int()
        let flags = normalization_pair_flags[(block << NormalizationPairShift) |
        (trail & NormalizationPairBlockMask)].to_int()
        guard flags == expected else {
          fail("pair flags \{flags} != \{expected} at code point \{cp}")
        }
      }
    }
    guard generated == summary else {
      fail("lead flags \{generated} != \{summary} for lead index \{lead}")
    }
  }
}

///|
/// The scan masks of NFC, NFKC, NFD and NFKD.
#cfg(any(target="native", target="wasm"))
fn form_scan_masks() -> Array[Int32] {
  [(8, 3), (10, 3), (12, 1), (13, 1)].map(form => {
    let (shift, mask) = form
    (255 | (mask << shift)) >> 7
  })
}

///|
// The block scan skips code units below a fixed limit without reading their
// flags, so a data update that lowers a limit must not go unnoticed.
#cfg(any(target="native", target="wasm"))
test "code units below the clean limit have no scan flags" {
  for scan_mask in form_scan_masks() {
    let limit = clean_unit_limit(scan_mask)
    for cp in 0..<=limit {
      let block = normalization_scan_index[cp >> NormalizationScanShift].to_int()
      let flags = normalization_scan_flags[(block << NormalizationScanShift) |
      (cp & NormalizationScanBlockMask)].to_int()
      let clean = (flags & (scan_mask | NormalizationScanLeadSurrogate)) == 0
      guard clean == (cp < limit) else {
        fail("code unit \{cp} breaks the clean limit \{limit}")
      }
    }
  }
}

///|
/// Reference for the block skip: step over blocks of eight code units from
/// `start` while a whole block is left and all its units are below `limit`.
#cfg(any(target="native", target="wasm"))
fn reference_skip_clean_blocks(
  s : String,
  start : Int32,
  limit : Int32,
) -> Int32 {
  let length = s.length()
  let mut offset = start
  while offset + 8 <= length {
    for i in offset..<(offset + 8) {
      if s.unsafe_get(i).to_int() >= limit {
        return offset
      }
    }
    offset += 8
  }
  offset
}

///|
/// Check the block skip against the reference at every start offset of `s`,
/// with the limit of every form.
#cfg(any(target="native", target="wasm"))
fn check_skip_clean_blocks(s : String, source : String) -> Unit raise {
  let length = s.length()
  for scan_mask in form_scan_masks() {
    let limit = clean_unit_limit(scan_mask)
    for start in 0..<=length {
      let actual = skip_clean_blocks(s, start, length, scan_mask)
      let expected = reference_skip_clean_blocks(s, start, limit)
      guard actual == expected else {
        fail(
          "skip_clean_blocks(\{source}, \{start}) with limit \{limit} = \{actual}, expected \{expected}",
        )
      }
    }
  }
}

///|
/// Build a string from raw UTF-16 code units, which lets a test spell an
/// unpaired surrogate that a literal cannot.
#cfg(any(target="native", target="wasm"))
fn unit_string(units : Array[Int32]) -> String {
  let out = StringBuilder()
  for unit in units {
    out.write_char(unit.unsafe_to_char())
  }
  out.to_string()
}

///|
/// The next value of a small linear congruential generator, used to build
/// mixed text without depending on a random package.
#cfg(any(target="native", target="wasm"))
fn probe_random(state : Int32) -> Int32 {
  (state * 1103515245 + 12345) & 0x7FFFFFFF
}

///|
#cfg(any(target="native", target="wasm"))
test "block skip agrees with the scan one code unit at a time" {
  check_skip_clean_blocks("", "empty")
  check_skip_clean_blocks("abcdefg", "seven ASCII")
  check_skip_clean_blocks("abcdefgh", "eight ASCII")
  check_skip_clean_blocks("abcdefghijklmnop", "sixteen ASCII")
  check_skip_clean_blocks("Hello, world! ".repeat(16), "repeated ASCII")
  check_skip_clean_blocks("世界hello世界", "mixed BMP and ASCII")
  check_skip_clean_blocks(
    "Crème brûlée, naïve façade ".repeat(8),
    "Latin-1",
  )
  check_skip_clean_blocks(
    unit_string([0x61, 0x62, 0xDC00, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69]),
    "surrogate inside ASCII",
  )
  check_skip_clean_blocks("ab😀cd".repeat(8), "supplementary inside ASCII")
  // Put the last code unit below each limit and the limit itself in every
  // lane of a block.
  for unit in [0x7F, 0x80, 0x9F, 0xA0, 0xBF, 0xC0, 0x2FF, 0x300, 0xFFFF] {
    for ascii in 0..<=20 {
      check_skip_clean_blocks(
        "a".repeat(ascii) + unit_string([unit]) + "b".repeat(40 - ascii),
        "code unit \{unit} inside ASCII runs",
      )
    }
  }
}

///|
#cfg(any(target="native", target="wasm"))
test "block skip agrees on random mixed text" {
  let mut state = 20261013
  for _ in 0..<64 {
    let out = StringBuilder()
    state = probe_random(state)
    let count = 8 + state % 200
    for _ in 0..<count {
      state = probe_random(state)
      let pick = state % 100
      if pick < 60 {
        out.write_char((0x20 + state % 0x5F).unsafe_to_char())
      } else if pick < 80 {
        out.write_char((0x80 + state % 0x700).unsafe_to_char())
      } else if pick < 90 {
        out.write_char((0x800 + state % 0xD000).unsafe_to_char())
      } else {
        // A well-formed surrogate pair for a supplementary code point.
        let code_point = 0x10000 + state % 0x1000
        out.write_char(code_point.unsafe_to_char())
      }
    }
    check_skip_clean_blocks(out.to_string(), "random text")
  }
}
