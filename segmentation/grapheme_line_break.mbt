///|
/// Return the default UAX #14 break kind after the last grapheme returned by
/// next() or iter(). Before the first grapheme, including for empty input,
/// returns Prohibited. Exhaustion preserves the last kind (Mandatory for
/// nonempty text). Repeated queries do not advance the grapheme cursor.
///
/// Only complete grapheme ends are queried; default line break opportunities
/// inside a cluster are not exposed. This does not change UAX #29 segmentation
/// or recompute line breaking classes per cluster.
///
/// The first query after a grapheme prepares line breaking context for the
/// whole input in O(n) time and space. Subsequent queries scan that context
/// forward, taking O(n) total time over a complete traversal. Traversal without
/// this query does not initialize or run the line breaking algorithm.
///
/// ```mbt check
/// test {
///   let graphemes = @segmentation.graphemes("ab c")
///   let kinds = []
///   for grapheme in graphemes {
///     kinds.push((grapheme.to_owned(), graphemes.line_break()))
///   }
///   debug_inspect(
///     kinds,
///     content=(
///       #|[
///       #|  ("a", Prohibited),
///       #|  ("b", Prohibited),
///       #|  (" ", Allowed),
///       #|  ("c", Mandatory),
///       #|]
///     ),
///   )
/// }
/// ```
pub fn Graphemes::line_break(self : Graphemes) -> BreakOpportunity {
  if self.offset == 0 {
    return Prohibited
  }
  let breaks = if self.breaks is Some(breaks) {
    breaks
  } else {
    let breaks = line_breaks(self.text)
    self.breaks = Some(breaks)
    breaks
  }
  // The cursors share the same input, whose final boundary is Mandatory.
  // Consequently this scan always reaches or passes the current cluster end.
  while breaks.offset < self.offset {
    ignore(breaks.next())
  }
  if breaks.offset == self.offset {
    breaks.opportunity()
  } else {
    Prohibited
  }
}
