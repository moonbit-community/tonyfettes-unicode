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
