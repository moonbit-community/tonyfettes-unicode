///|
pub fn emit_marks(mark_ranges : Array[@parsing.CodePointRange]) -> String {
  let out = @emitter.Emitter::new()
  out.write_file_header("Mark character lookup data", "UnicodeData.txt")
  out.write_int_array(
    "Mark character range start code points (General_Category = M)",
    "mark_starts",
    mark_ranges.map(range => range.start),
    hex=true,
  )
  out.write_int_array(
    "Mark character range end code points (inclusive)",
    "mark_ends",
    mark_ranges.map(range => range.end),
    hex=true,
  )
  out.write(
    (
      #|///|
      #|/// Check if a character is a Mark character (General_Category = Mn, Mc, or Me)
      #|/// This is used for the IDNA "no leading combining mark" validation (V5/V6)
      #|pub fn is_mark(c : Char) -> Bool {
      #|  let cp = c.to_int()
      #|  // Binary search through mark ranges
      #|  let mut left = 0
      #|  let mut right = mark_starts.length() - 1
      #|
      #|  while left <= right {
      #|    let mid = (left + right) / 2
      #|    let start = mark_starts[mid]
      #|    let end = mark_ends[mid]
      #|
      #|    if cp < start {
      #|      right = mid - 1
      #|    } else if cp > end {
      #|      left = mid + 1
      #|    } else {
      #|      return true
      #|    }
      #|  }
      #|
      #|  false
      #|}
      #|
    ),
  )
  out.finish()
}
