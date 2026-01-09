///|
pub(all) suberror Invalid derive(Show, ToJson)

///|
struct CodePoint(Int)

///|
pub fn CodePoint::to_int(self : CodePoint) -> Int {
  self.0
}

///|
#as_free_fn
pub fn CodePoint::of_int(self : Int) -> CodePoint raise Invalid {
  if self < 0 || self > 0x10FFFF {
    raise Invalid
  }
  CodePoint(self)
}

///|
#as_free_fn
pub fn CodePoint::of_int_unchecked(self : Int) -> CodePoint {
  CodePoint(self)
}

///|
pub impl ToJson for CodePoint with to_json(self : CodePoint) -> Json {
  self.0.to_json()
}

///|
pub impl Show for CodePoint with output(self : CodePoint, logger : &Logger) -> Unit {
  match self.0.to_char() {
    None => {
      logger.write_string("U+")
      logger.write_string(self.0.to_string(radix=16).pad_start(4, '0'))
    }
    Some(c) => logger.write_char(c)
  }
}

///|
/// Convert array of code points to string
pub fn codepoints_to_string(codepoints : Array[Int]) -> String {
  let sb = StringBuilder::new()
  for cp in codepoints {
    // Handle surrogate pairs for code points > 0xFFFF
    if cp <= 0xFFFF {
      sb.write_char(cp.unsafe_to_char())
    } else {
      // Encode as surrogate pair
      let adjusted = cp - 0x10000
      let high = 0xD800 + (adjusted >> 10)
      let low = 0xDC00 + (adjusted & 0x3FF)
      sb.write_char(high.unsafe_to_char())
      sb.write_char(low.unsafe_to_char())
    }
  }
  sb.to_string()
}

///|
/// Convert string to array of code points (handling surrogates)
pub fn string_to_codepoints(s : String) -> Array[Int] {
  let result : Array[Int] = []
  for c in s {
    result.push(c.to_int())
  }
  result
}
