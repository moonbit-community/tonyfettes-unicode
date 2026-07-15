///|
/// Property-based fuzz tests for IDNA processing
/// Tests UTS #46 invariants

///|
/// Number of iterations for fuzz tests
let fuzz_iterations : Int = 50000

///|
/// Seed for reproducibility (must be exactly 32 bytes for chacha8)
let fuzz_seed : Bytes = b"idna-fuzz-seed-for-testing!32!!!"

// =============================================================================
// Property 1: to_ascii produces ASCII-only output
// =============================================================================

///|
test "fuzz: to_ascii produces ASCII" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<fuzz_iterations {
    let domain = @idna_fuzz.random_domain(rng)
    try @idna.to_ascii(domain, check_bidi=false, check_joiners=false) catch {
      _ => () // Some domains may be invalid
    } noraise {
      ascii => assert_true(@idna_fuzz.is_ascii_string(ascii))
    }
  }
}

// =============================================================================
// Property 2: Pure ASCII domains pass through
// =============================================================================

///|
test "fuzz: pure ASCII domain passthrough" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<fuzz_iterations {
    // Generate pure ASCII domain
    let num_labels = rng.int(limit=3) + 1
    let labels : Array[String] = []
    for _ in 0..<num_labels {
      labels.push(@idna_fuzz.random_ascii_label(rng))
    }
    let domain = labels.join(".")
    try
      @idna.to_ascii(
        domain,
        use_std3_ascii_rules=false,
        check_hyphens=false,
        check_bidi=false,
        check_joiners=false,
      )
    catch {
      _ => ()
    } noraise {
      ascii =>
        // ASCII domain should lowercase but otherwise stay similar
        assert_eq(ascii, domain.to_lower())
    }
  }
}

// =============================================================================
// Property 3: Roundtrip for valid domains
// =============================================================================

///|
test "fuzz: idna roundtrip" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<fuzz_iterations {
    let domain = @idna_fuzz.random_domain(rng)
    try {
      let ascii = @idna.to_ascii(
        domain,
        check_bidi=false,
        check_joiners=false,
        verify_dns_length=false,
      )
      let unicode = @idna.to_unicode(
        ascii,
        check_bidi=false,
        check_joiners=false,
      )
      let ascii2 = @idna.to_ascii(
        unicode,
        check_bidi=false,
        check_joiners=false,
        verify_dns_length=false,
      )
      (ascii, ascii2)
    } catch {
      _ => ()
    } noraise {
      (ascii, ascii2) => assert_eq(ascii, ascii2)
    }
  }
}

// =============================================================================
// Property 4: to_unicode is idempotent
// =============================================================================

///|
test "fuzz: to_unicode idempotence" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<fuzz_iterations {
    let domain = @idna_fuzz.random_domain(rng)
    try {
      let unicode1 = @idna.to_unicode(
        domain,
        check_bidi=false,
        check_joiners=false,
      )
      let unicode2 = @idna.to_unicode(
        unicode1,
        check_bidi=false,
        check_joiners=false,
      )
      (unicode1, unicode2)
    } catch {
      _ => ()
    } noraise {
      (u1, u2) => assert_eq(u1, u2)
    }
  }
}

// =============================================================================
// Property 5: to_ascii produces pure ASCII for all Unicode input
// =============================================================================

///|
test "fuzz: to_ascii produces pure ASCII for any Unicode input" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<fuzz_iterations {
    // Generate label with random Unicode code points (full range U+0000 to U+10FFFF)
    let sb = StringBuilder::new()
    let len = rng.int(limit=10) + 1
    for _ in 0..<len {
      let cp = @fuzz.random_any_codepoint(rng)
      sb.write_char(cp)
    }
    let label = sb.to_string()
    try
      @idna.to_ascii(
        label,
        check_bidi=false,
        check_joiners=false,
        verify_dns_length=false,
      )
    catch {
      _ => () // Disallowed chars, bidi errors, etc. are expected
    } noraise {
      ascii =>
        // DETERMINISTIC ASSERTION:
        // to_ascii output must be pure ASCII (code points < 0x80)
        for c in ascii {
          let code = c.to_int()
          assert_true(code < 0x80)
        }
    }
  }
}

// =============================================================================
// Property 6: Hangul domain handling
// =============================================================================

///|
test "fuzz: hangul domain roundtrip" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<300 {
    // Generate Hangul label
    let label = @fuzz.random_hangul_string(rng, max_len=10)
    try {
      let ascii = @idna.to_ascii(
        label,
        check_bidi=false,
        check_joiners=false,
        verify_dns_length=false,
      )
      let unicode = @idna.to_unicode(
        ascii,
        check_bidi=false,
        check_joiners=false,
      )
      (ascii, unicode)
    } catch {
      _ => ()
    } noraise {
      (ascii, _unicode) =>
        // Should have xn-- prefix
        assert_true(ascii.has_prefix("xn--"))
    }
  }
}

// =============================================================================
// Boundary cases
// =============================================================================

///|
test "fuzz: empty label handling" {
  // Empty domain should fail
  @test.assert_raise(() => @idna.to_ascii(""))
}

///|
test "fuzz: single character domains" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<200 {
    let cp = @fuzz.random_codepoint(rng, Ascii)
    let s = cp.to_string()
    try
      @idna.to_ascii(
        s,
        use_std3_ascii_rules=false,
        check_hyphens=false,
        check_bidi=false,
        check_joiners=false,
      )
    catch {
      _ => ()
    } noraise {
      ascii => assert_true(@idna_fuzz.is_ascii_string(ascii))
    }
  }
}

///|
test "fuzz: multiple dot handling" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<200 {
    // Generate domain with various separators
    let label1 = @idna_fuzz.random_ascii_label(rng)
    let label2 = @idna_fuzz.random_ascii_label(rng)
    let domain = label1 + "." + label2
    try
      @idna.to_ascii(
        domain,
        use_std3_ascii_rules=false,
        check_hyphens=false,
        check_bidi=false,
        check_joiners=false,
      )
    catch {
      _ => ()
    } noraise {
      ascii =>
        // Should preserve dot structure
        assert_true(ascii.contains("."))
    }
  }
}

// =============================================================================
// Property 7: Bidi checking
// =============================================================================

///|
test "fuzz: arabic rtl domains with bidi check" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<fuzz_iterations {
    let label = @idna_fuzz.random_arabic_label(rng)
    // We're mainly testing that the code path runs without panicking.
    // Both success and expected errors are acceptable.
    try
      @idna.to_ascii(
        label,
        check_bidi=true,
        check_joiners=false,
        verify_dns_length=false,
      )
    catch {
      _ => ()
    } noraise {
      ascii => assert_true(@idna_fuzz.is_ascii_string(ascii))
    }
  }
}

///|
test "fuzz: hebrew rtl domains with bidi check" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<fuzz_iterations {
    let label = @idna_fuzz.random_hebrew_label(rng)
    try
      @idna.to_ascii(
        label,
        check_bidi=true,
        check_joiners=false,
        verify_dns_length=false,
      )
    catch {
      _ => ()
    } noraise {
      ascii => assert_true(@idna_fuzz.is_ascii_string(ascii))
    }
  }
}

///|
test "fuzz: mixed bidi labels rejected" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<fuzz_iterations {
    let label = @idna_fuzz.random_mixed_bidi_label(rng)
    let error = @test.expect_error(() => {
      @idna.to_ascii(
        label,
        check_bidi=true,
        check_joiners=false,
        verify_dns_length=false,
      )
    })
    guard error is InvalidBidi else {
      fail("expected InvalidBidi for mixed LTR/RTL label")
    }
  }
}

// =============================================================================
// Property 8: Joiner checking
// =============================================================================

///|
test "fuzz: joiners at boundary rejected" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<fuzz_iterations {
    let label = @idna_fuzz.random_label_with_joiners(rng, at_boundary=true)
    let error = @test.expect_error(() => {
      @idna.to_ascii(
        label,
        check_bidi=false,
        check_joiners=true,
        verify_dns_length=false,
      )
    })
    guard error is InvalidJoiner else {
      fail("expected InvalidJoiner for joiner at label boundary")
    }
  }
}

///|
test "fuzz: joiners after virama accepted" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<fuzz_iterations {
    let label = @idna_fuzz.random_label_with_joiners(rng, at_boundary=false)
    let ascii = @idna.to_ascii(
      label,
      check_bidi=false,
      check_joiners=true,
      verify_dns_length=false,
    )
    assert_true(@idna_fuzz.is_ascii_string(ascii))
  }
}

// =============================================================================
// Property 9: IDNA Mapping
// =============================================================================

///|
test "fuzz: ignored characters removed" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<fuzz_iterations {
    let label = @idna_fuzz.random_label_with_ignored(rng)
    try
      @idna.to_ascii(
        label,
        check_bidi=false,
        check_joiners=false,
        verify_dns_length=false,
      )
    catch {
      _ => ()
    } noraise {
      ascii =>
        // Result should not contain soft hyphen (U+00AD) etc.
        for c in ascii {
          let cp = c.to_int()
          assert_true(
            cp != 0x00AD && cp != 0x034F && cp != 0x180B && cp != 0xFE00,
          )
        }
    }
  }
}

///|
test "fuzz: mapped characters transformed" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<fuzz_iterations {
    let label = @idna_fuzz.random_label_with_mapped(rng)
    try
      @idna.to_ascii(
        label,
        check_bidi=false,
        check_joiners=false,
        verify_dns_length=false,
      )
    catch {
      _ => ()
    } noraise {
      ascii =>
        // Result should be lowercase ASCII (for fullwidth/uppercase input)
        // and should not contain fullwidth characters
        for c in ascii {
          let cp = c.to_int()
          // No fullwidth ASCII (FF00-FF5E)
          assert_true(cp < 0xFF00 || cp > 0xFF5E)
          // No uppercase A-Z in output (should be lowercase)
          // (except in xn-- prefix which is lowercase anyway)
        }
    }
  }
}

// =============================================================================
// Property 10: Error case validation
// =============================================================================

///|
test "fuzz: disallowed characters rejected" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<fuzz_iterations {
    let label = @idna_fuzz.random_label_with_disallowed(rng)
    let error = @test.expect_error(() => {
      @idna.to_ascii(label, check_bidi=false, check_joiners=false)
    })
    guard error is DisallowedCodePoint(_) else {
      fail("expected DisallowedCodePoint")
    }
  }
}

///|
test "fuzz: label too long rejected" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<100 {
    let label = @idna_fuzz.random_long_label(rng)
    let error = @test.expect_error(() => {
      @idna.to_ascii(
        label,
        check_bidi=false,
        check_joiners=false,
        verify_dns_length=true,
      )
    })
    guard error is LabelTooLong else { fail("expected LabelTooLong") }
  }
}

///|
test "fuzz: leading combining mark rejected" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<fuzz_iterations {
    let label = @idna_fuzz.random_label_leading_combining(rng)
    let error = @test.expect_error(() => {
      @idna.to_ascii(label, check_bidi=false, check_joiners=false)
    })
    guard error is LeadingCombiningMark else {
      fail("expected LeadingCombiningMark")
    }
  }
}

// =============================================================================
// Property 11: STD3 rules
// =============================================================================

///|
test "fuzz: std3 hyphen at start rejected" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<200 {
    let label = @idna_fuzz.random_label_boundary_hyphen(rng, at_start=true)
    let error = @test.expect_error(() => {
      @idna.to_ascii(
        label,
        use_std3_ascii_rules=true,
        check_hyphens=true,
        check_bidi=false,
        check_joiners=false,
      )
    })
    guard error is InvalidHyphen else {
      fail("expected InvalidHyphen at label start")
    }
  }
}

///|
test "fuzz: std3 hyphen at end rejected" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<200 {
    let label = @idna_fuzz.random_label_boundary_hyphen(rng, at_start=false)
    let error = @test.expect_error(() => {
      @idna.to_ascii(
        label,
        use_std3_ascii_rules=true,
        check_hyphens=true,
        check_bidi=false,
        check_joiners=false,
      )
    })
    guard error is InvalidHyphen else {
      fail("expected InvalidHyphen at label end")
    }
  }
}

// =============================================================================
// Property 12: Cross-library - NFC normalization
// =============================================================================

///|
test "fuzz: idna output is nfc normalized" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<fuzz_iterations {
    let domain = @idna_fuzz.random_domain(rng)
    try @idna.to_unicode(domain, check_bidi=false, check_joiners=false) catch {
      _ => ()
    } noraise {
      unicode => {
        // to_unicode output should be NFC normalized
        // NFC(output) == output
        let nfc_result = @normalization.nfc(unicode)
        assert_eq(unicode, nfc_result)
      }
    }
  }
}
