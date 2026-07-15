///|
pub(all) suberror PunycodeError {
  Overflow
  InvalidInput
  BadInput
}

///|
pub impl Show for PunycodeError with fn output(self, logger) {
  match self {
    Overflow => logger.write_string("Overflow")
    InvalidInput => logger.write_string("InvalidInput")
    BadInput => logger.write_string("BadInput")
  }
}

///|
fn legacy_error(error : @impl.PunycodeError) -> PunycodeError {
  match error {
    @impl.Overflow => Overflow
    @impl.InvalidInput => InvalidInput
    @impl.BadInput => BadInput
  }
}

///|
pub fn encode(input : String) -> String raise PunycodeError {
  @impl.encode(input) catch {
    error => raise legacy_error(error)
  }
}

///|
pub fn decode(input : String) -> String raise PunycodeError {
  @impl.decode(input) catch {
    error => raise legacy_error(error)
  }
}
