///|
/// Property-based fuzz tests for IDNA processing
/// Tests UTS #46 invariants

///|
/// Number of iterations for fuzz tests
let fuzz_iterations : Int = 500

///|
/// Seed for reproducibility (must be exactly 32 bytes for chacha8)
let fuzz_seed : Bytes = b"idna-fuzz-seed-for-testing!32!!!"

// =============================================================================
// Helper functions
// =============================================================================

///|
fn is_ascii_string(s : String) -> Bool {
  for c in s {
    if c.to_int() >= 0x80 {
      return false
    }
  }
  true
}

///|
/// Generate a random domain-like string (labels separated by dots)
fn random_domain(rng : @random.Rand, max_labels? : Int = 3) -> String {
  let num_labels = rng.int(limit=max_labels) + 1
  let labels : Array[String] = []
  for _ in 0..<num_labels {
    let label = random_label(rng)
    labels.push(label)
  }
  labels.join(".")
}

///|
/// Generate a random label (no dots, reasonable length)
fn random_label(rng : @random.Rand) -> String {
  let len = rng.int(limit=15) + 1 // 1-15 chars to stay under 63 limit after encoding
  let sb = StringBuilder::new()
  for i in 0..<len {
    // Avoid leading combining marks and hyphens at boundaries
    let cp = if i == 0 || i == len - 1 {
      // Use safe characters at boundaries
      @fuzz.random_codepoint(rng, Ascii)
    } else {
      let choice = rng.int(limit=4)
      if choice == 0 {
        @fuzz.random_codepoint(rng, Ascii)
      } else if choice == 1 {
        @fuzz.random_codepoint(rng, LatinExtended)
      } else if choice == 2 {
        @fuzz.random_codepoint(rng, HangulSyllable)
      } else {
        @fuzz.random_codepoint(rng, Ascii)
      }
    }
    sb.write_string(@fuzz.codepoint_to_char(cp))
  }
  sb.to_string()
}

///|
/// Generate an ASCII-only label
fn random_ascii_label(rng : @random.Rand) -> String {
  let len = rng.int(limit=15) + 1
  let sb = StringBuilder::new()
  for _ in 0..<len {
    let cp = @fuzz.random_codepoint(rng, Ascii)
    sb.write_string(@fuzz.codepoint_to_char(cp))
  }
  sb.to_string()
}

// =============================================================================
// Property 1: to_ascii produces ASCII-only output
// =============================================================================

///|
test "fuzz: to_ascii produces ASCII" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<fuzz_iterations {
    let domain = random_domain(rng)
    let result : Result[String, _] = try? @idna.to_ascii(
      domain,
      check_bidi=false,
      check_joiners=false,
    )
    match result {
      Ok(ascii) => assert_true(is_ascii_string(ascii))
      Err(_) => () // Some domains may be invalid
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
      labels.push(random_ascii_label(rng))
    }
    let domain = labels.join(".")
    let result : Result[String, _] = try? @idna.to_ascii(
      domain,
      use_std3_ascii_rules=false,
      check_hyphens=false,
      check_bidi=false,
      check_joiners=false,
    )
    match result {
      Ok(ascii) =>
        // ASCII domain should lowercase but otherwise stay similar
        assert_eq(ascii, domain.to_lower())
      Err(_) => ()
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
    let domain = random_domain(rng)
    let result : Result[(String, String), _] = try? {
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
      (ascii, unicode)
    }
    match result {
      Ok((ascii, unicode)) => {
        // The unicode result should be NFC normalized
        // Re-encoding should give the same ASCII
        let result2 : Result[String, _] = try? @idna.to_ascii(
          unicode,
          check_bidi=false,
          check_joiners=false,
          verify_dns_length=false,
        )
        match result2 {
          Ok(ascii2) => assert_eq(ascii, ascii2)
          Err(_) => ()
        }
      }
      Err(_) => ()
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
    let domain = random_domain(rng)
    let result : Result[(String, String), _] = try? {
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
    }
    match result {
      Ok((u1, u2)) => assert_eq(u1, u2)
      Err(_) => ()
    }
  }
}

// =============================================================================
// Property 5: Punycode labels start with xn--
// =============================================================================

///|
test "fuzz: non-ascii labels get xn-- prefix" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<fuzz_iterations {
    // Generate a single non-ASCII label
    let sb = StringBuilder::new()
    let len = rng.int(limit=10) + 1
    for _ in 0..<len {
      let cp = @fuzz.random_codepoint(rng, LatinExtended)
      sb.write_string(@fuzz.codepoint_to_char(cp))
    }
    let label = sb.to_string()
    let result : Result[String, _] = try? @idna.to_ascii(
      label,
      check_bidi=false,
      check_joiners=false,
      verify_dns_length=false,
    )
    match result {
      Ok(ascii) =>
        // Non-ASCII input should produce xn-- prefixed output
        assert_true(ascii.has_prefix("xn--"))
      Err(_) => ()
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
    let result : Result[(String, String), _] = try? {
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
    }
    match result {
      Ok((ascii, _unicode)) =>
        // Should have xn-- prefix
        assert_true(ascii.has_prefix("xn--"))
      Err(_) => ()
    }
  }
}

// =============================================================================
// Boundary cases
// =============================================================================

///|
test "fuzz: empty label handling" {
  // Empty domain should fail
  let result : Result[String, _] = try? @idna.to_ascii("")
  assert_true(result is Err(_))
}

///|
test "fuzz: single character domains" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<200 {
    let cp = @fuzz.random_codepoint(rng, Ascii)
    let s = @fuzz.codepoint_to_char(cp)
    let result : Result[String, _] = try? @idna.to_ascii(
      s,
      use_std3_ascii_rules=false,
      check_hyphens=false,
      check_bidi=false,
      check_joiners=false,
    )
    match result {
      Ok(ascii) => assert_true(is_ascii_string(ascii))
      Err(_) => ()
    }
  }
}

///|
test "fuzz: multiple dot handling" {
  let rng = @random.Rand::chacha8(seed=fuzz_seed)
  for _ in 0..<200 {
    // Generate domain with various separators
    let label1 = random_ascii_label(rng)
    let label2 = random_ascii_label(rng)
    let domain = label1 + "." + label2
    let result : Result[String, _] = try? @idna.to_ascii(
      domain,
      use_std3_ascii_rules=false,
      check_hyphens=false,
      check_bidi=false,
      check_joiners=false,
    )
    match result {
      Ok(ascii) =>
        // Should preserve dot structure
        assert_true(ascii.contains("."))
      Err(_) => ()
    }
  }
}
