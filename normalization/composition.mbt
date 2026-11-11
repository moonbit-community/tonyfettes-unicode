///|
/// Try to compose two characters into one
/// Handles both Hangul and general composition
fn try_compose(first : Char, second : Char) -> Char? {
  // Try Hangul composition first (algorithmic, no table lookup)
  if try_compose_hangul(first, second) is Some(h) {
    return Some(h)
  }

  // Look up in composition table
  @composition.lookup_composition(first, second)
}
