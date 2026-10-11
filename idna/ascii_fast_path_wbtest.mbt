///|
/// A label the fast path always hands to the general algorithm.
fn has_ace_label(domain : String) -> Bool {
  domain.split(".").any(label => label.to_owned().to_lower().has_prefix("xn--"))
}

///|
/// Compare the fast path with the general algorithm under every combination
/// of the flags it depends on. It may only answer when the general algorithm
/// succeeds with the same result, and it must answer for every valid ASCII
/// domain without A-labels.
fn check_fast_path(domain : String) -> Unit raise {
  let plain = domain.all(c => c.to_int() < 0x80) && !has_ace_label(domain)
  for use_std3_ascii_rules in [true, false] {
    for check_hyphens in [true, false] {
      for verify_dns_length in [true, false] {
        let fast = ascii_fast_path(
          domain,
          use_std3_ascii_rules~,
          check_hyphens~,
          verify_dns_length~,
        )
        let flags = "\{repr(domain)} std3=\{use_std3_ascii_rules} hyphens=\{check_hyphens} dns=\{verify_dns_length}"
        try
          to_ascii_general(
            domain,
            use_std3_ascii_rules~,
            check_hyphens~,
            check_bidi=true,
            check_joiners=true,
            verify_dns_length~,
          )
        catch {
          _ =>
            if fast is Some(_) {
              fail("fast path accepted an invalid domain: \{flags}")
            }
        } noraise {
          expected =>
            if fast is Some(actual) {
              assert_eq(actual, expected)
            } else if plain {
              fail("fast path missed a valid domain: \{flags}")
            }
        }
      }
      let fast = ascii_fast_path(
        domain,
        use_std3_ascii_rules~,
        check_hyphens~,
        verify_dns_length=false,
      )
      let flags = "\{repr(domain)} std3=\{use_std3_ascii_rules} hyphens=\{check_hyphens}"
      try
        to_unicode_general(
          domain,
          use_std3_ascii_rules~,
          check_hyphens~,
          check_bidi=true,
          check_joiners=true,
        )
      catch {
        _ =>
          if fast is Some(_) {
            fail("fast path accepted an invalid domain: \{flags}")
          }
      } noraise {
        expected =>
          if fast is Some(actual) {
            assert_eq(actual, expected)
          } else if plain {
            fail("fast path missed a valid domain: \{flags}")
          }
      }
    }
  }
}

///|
test "ASCII fast path agrees with the general algorithm on short domains" {
  // Every string up to five characters over an alphabet that reaches each
  // branch: letters in both cases, a digit, hyphens (including "xn--"),
  // label separators and a non-LDH character.
  let alphabet = ['a', 'X', 'n', '1', '-', '.', '_']
  let mut domains = [""]
  for _ in 0..<=5 {
    let longer = []
    for domain in domains {
      check_fast_path(domain)
      for c in alphabet {
        longer.push("\{domain}\{c}")
      }
    }
    domains = longer
  }
}

///|
test "ASCII fast path agrees with the general algorithm on every ASCII character" {
  for code in 0..<0x80 {
    let c = code.unsafe_to_char()
    for domain in ["\{c}", "\{c}a", "a\{c}", "a\{c}b", "ab\{c}\{c}c"] {
      check_fast_path(domain)
    }
  }
}

///|
test "ASCII fast path agrees with the general algorithm at DNS length limits" {
  let label_63 = "a".repeat(63)
  let label_64 = "a".repeat(64)
  // Three 63-character labels and one of 61 make 253 characters with dots.
  let domain_253 = "\{label_63}.\{label_63}.\{label_63}.\{"b".repeat(61)}"
  for
    domain in [
      label_63,
      label_64,
      "\{label_63}.com",
      "\{label_64}.com",
      "www.\{label_64}",
      domain_253,
      "\{domain_253}c",
      "\{domain_253}.",
      "example.com.",
      "example.com..",
      ".example.com",
      "example..com",
    ] {
    check_fast_path(domain)
  }
}

///|
test "ASCII fast path leaves other input to the general algorithm" {
  for
    domain in [
      "bücher.example", "example。com", "example.😀", "a\u{00AD}b.com", "xn--bcher-kva.example",
      "XN--BCHER-KVA.example", "www.xn--bcher-kva",
    ] {
    check_fast_path(domain)
    assert_true(
      ascii_fast_path(
        domain,
        use_std3_ascii_rules=false,
        check_hyphens=false,
        verify_dns_length=false,
      )
      is None,
    )
  }
}

///|
test "ASCII fast path lowercases and keeps a trailing dot" {
  inspect(to_ascii("www.example.com"), content="www.example.com")
  inspect(to_ascii("WWW.Example.COM"), content="www.example.com")
  inspect(to_unicode("WWW.Example.COM."), content="www.example.com.")
  inspect(
    to_ascii("_dmarc.Example.com", use_std3_ascii_rules=false),
    content="_dmarc.example.com",
  )
}
