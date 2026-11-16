///|
test "legacy IDNA repertoire option checks both conversions" {
  inspect(@unicode/idna.to_ascii("☕.example"), content="xn--53h.example")
  inspect(@unicode/idna.to_unicode("xn--53h.example"), content="☕.example")
  try @unicode/idna.to_ascii("☕.example", check_idna2008=true) catch {
    @unicode/idna.DisallowedCodePoint(cp~) => inspect(cp, content="9749")
    error => raise error
  } noraise {
    _ => fail("expected the IDNA2008 repertoire check to reject U+2615")
  }
  try @unicode/idna.to_unicode("xn--53h.example", check_idna2008=true) catch {
    @unicode/idna.DisallowedCodePoint(cp~) => inspect(cp, content="9749")
    error => raise error
  } noraise {
    _ =>
      fail("expected the decoded label to fail the IDNA2008 repertoire check")
  }
}

///|
test "legacy IDNA ContextO option preserves its error" {
  inspect(@unicode/idna.to_unicode("a·b.example"), content="a·b.example")
  try @unicode/idna.to_ascii("a·b.example", check_contexto=true) catch {
    @unicode/idna.InvalidContextO(cp~) => inspect(cp, content="183")
    error => raise error
  } noraise {
    _ => fail("expected the ContextO check to reject the middle dot")
  }
  try @unicode/idna.to_unicode("a·b.example", check_contexto=true) catch {
    @unicode/idna.InvalidContextO(cp~) => inspect(cp, content="183")
    error => raise error
  } noraise {
    _ => fail("expected the ContextO check to reject the middle dot")
  }
  let error : @unicode/idna.IdnaError = @unicode/idna.InvalidContextO(cp=0xB7)
  inspect(error, content="InvalidContextO(cp=183)")
}
