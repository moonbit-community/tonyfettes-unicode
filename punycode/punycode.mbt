///|
/// Punycode encoding/decoding (RFC 3492)
/// Used for Internationalized Domain Names in Applications (IDNA)

///|
/// Error type for Punycode operations
pub(all) suberror PunycodeError {
  Overflow
  InvalidInput
  BadInput
}

///|
pub extend PunycodeError with Show::{to_string, output}

///|
pub impl Show for PunycodeError with fn output(self, logger) {
  match self {
    Overflow => logger.write_string("Overflow")
    InvalidInput => logger.write_string("InvalidInput")
    BadInput => logger.write_string("BadInput")
  }
}

// RFC 3492 constants (Section 4)

///|
/// Base for variable-length integer encoding. Punycode uses base-36
/// (letters a-z represent 0-25, digits 0-9 represent 26-35).
const Base : Int = 36

///|
/// Minimum threshold for variable-length integer encoding.
/// Ensures at least one digit is always output.
const Tmin : Int = 1

///|
/// Maximum threshold for variable-length integer encoding.
/// Equals the number of lowercase letters (a-z).
const Tmax : Int = 26

///|
/// Skew parameter for bias adaptation function.
/// Controls how quickly the bias adjusts to character frequencies.
const Skew : Int = 38

///|
/// Damping factor applied only to the first delta value.
/// Prevents the bias from changing too rapidly at the start.
const Damp : Int = 700

///|
/// Initial bias value for the adaptation algorithm.
/// Chosen to work well for typical internationalized domain names.
const InitialBias : Int = 72

///|
/// Initial value of n, the threshold between basic ASCII (0-127)
/// and non-basic code points that require encoding.
const InitialN : Int = 0x80

///|
/// Delimiter character separating the basic ASCII portion
/// from the Punycode-encoded portion in the output.
const Delimiter : Char = '-'

///|
/// Largest positive value representable by MoonBit's signed Int type.
const MaxInt : Int = 0x7FFFFFFF

///|
/// Bias adaptation function (RFC 3492 Section 3.4)
fn adapt(delta : Int, numpoints : Int, firsttime : Bool) -> Int {
  let mut delta = delta
  if firsttime {
    delta = delta / Damp
  } else {
    delta = delta / 2
  }
  delta = delta + delta / numpoints
  let mut k = 0
  while delta > (Base - Tmin) * Tmax / 2 {
    delta = delta / (Base - Tmin)
    k = k + Base
  }
  k + (Base - Tmin + 1) * delta / (delta + Skew)
}

///|
/// Encode a digit to a basic code point (a-z for 0-25, 0-9 for 26-35)
fn encode_digit(d : Int) -> Char {
  if d < 26 {
    (d + 'a'.to_int()).unsafe_to_char()
  } else {
    (d - 26 + '0'.to_int()).unsafe_to_char()
  }
}

///|
/// Decode a basic code point to a digit
fn decode_digit(cp : Int) -> Int {
  if cp >= 'a'.to_int() && cp <= 'z'.to_int() {
    cp - 'a'.to_int()
  } else if cp >= 'A'.to_int() && cp <= 'Z'.to_int() {
    cp - 'A'.to_int()
  } else if cp >= '0'.to_int() && cp <= '9'.to_int() {
    cp - '0'.to_int() + 26
  } else {
    Base // Invalid
  }
}

///|
/// Encode a Unicode string to Punycode
pub fn encode(input : String) -> String raise PunycodeError {
  // The UTF-16 length bounds the number of code points.
  let code_points : FixedArray[Int] = FixedArray::make(input.length(), 0)
  let mut count = 0
  let mut basic_count = 0
  for c in input {
    let cp = c.to_int()
    code_points[count] = cp
    count = count + 1
    if cp < InitialN {
      basic_count = basic_count + 1
    }
  }
  if basic_count == count {
    // Only basic code points: they are copied, followed by the delimiter.
    return if basic_count == 0 { "" } else { input + "-" }
  }

  // Reserve the basic code points, the delimiter and a few digits for each
  // other code point; the size hint counts bytes, two per UTF-16 code unit.
  let output = StringBuilder(
    size_hint=2 * (basic_count + 1 + 4 * (count - basic_count)),
  )

  // Copy all basic code points to output
  for i in 0..<count {
    let cp = code_points[i]
    if cp < InitialN {
      output.write_char(cp.unsafe_to_char())
    }
  }

  // Add delimiter if there were basic characters
  if basic_count > 0 {
    output.write_char(Delimiter)
  }
  let mut n = InitialN
  let mut delta = 0
  let mut bias = InitialBias
  let mut handled = basic_count
  while handled < count {
    // Find the minimum code point >= n
    let mut m = 0x10FFFF + 1
    for i in 0..<count {
      let cp = code_points[i]
      if cp >= n && cp < m {
        m = cp
      }
    }

    // Increase delta enough to advance the decoder's <n,i> state to <m,0>
    let code_point_step = m - n
    let point_count = handled + 1
    if code_point_step > (MaxInt - delta) / point_count {
      raise Overflow
    }
    delta = delta + code_point_step * point_count
    n = m
    for i in 0..<count {
      let cp = code_points[i]
      if cp < n {
        if delta == MaxInt {
          raise Overflow
        }
        delta = delta + 1
      } else if cp == n {
        // Represent delta as a generalized variable-length integer
        let mut q = delta
        let mut k = Base
        while true {
          let t = if k <= bias {
            Tmin
          } else if k >= bias + Tmax {
            Tmax
          } else {
            k - bias
          }
          if q < t {
            break
          }
          output.write_char(encode_digit(t + (q - t) % (Base - t)))
          q = (q - t) / (Base - t)
          k = k + Base
        }
        output.write_char(encode_digit(q))
        bias = adapt(delta, handled + 1, handled == basic_count)
        delta = 0
        handled = handled + 1
      }
    }
    if delta == MaxInt {
      raise Overflow
    }
    delta = delta + 1
    n = n + 1
  }
  output.to_string()
}

///|
/// Decode a Punycode string to Unicode
pub fn decode(input : String) -> String raise PunycodeError {
  // Valid input is ASCII, so it is read as UTF-16 code units; any other
  // unit is rejected where it is reached.
  let length = input.length()

  // Find the last delimiter
  let mut basic_end = -1
  for i = length - 1; i >= 0; i = i - 1 {
    if input[i].to_int() == Delimiter.to_int() {
      basic_end = i
      break
    }
  }

  // Code points of the output. Each one consumes at least one code unit of
  // input, so the input length bounds their number.
  let output : FixedArray[Int] = FixedArray::make(length, 0)
  let mut output_length = 0

  // Copy basic code points before the last delimiter
  for i in 0..<basic_end {
    let unit = input[i].to_int()
    if unit >= InitialN {
      raise BadInput
    }
    output[i] = unit
    output_length = i + 1
  }

  // Main decoding loop
  let mut n = InitialN
  let mut i_val = 0
  let mut bias = InitialBias
  let mut in_pos = if basic_end >= 0 { basic_end + 1 } else { 0 }
  // UTF-16 length of the output
  let mut output_units = output_length
  while in_pos < length {
    let oldi = i_val
    let mut w = 1
    let mut k = Base
    while true {
      if in_pos >= length {
        raise BadInput
      }
      let digit = decode_digit(input[in_pos].to_int())
      in_pos = in_pos + 1
      if digit >= Base {
        raise BadInput
      }
      if digit > (MaxInt - i_val) / w {
        raise Overflow
      }
      i_val = i_val + digit * w
      let t = if k <= bias {
        Tmin
      } else if k >= bias + Tmax {
        Tmax
      } else {
        k - bias
      }
      if digit < t {
        break
      }
      if w > MaxInt / (Base - t) {
        raise Overflow
      }
      w = w * (Base - t)
      k = k + Base
    }
    let out_len = output_length + 1
    bias = adapt(i_val - oldi, out_len, oldi == 0)
    if i_val / out_len > MaxInt - n {
      raise Overflow
    }
    n = n + i_val / out_len
    i_val = i_val % out_len

    // Reject values that are not valid Unicode scalar values before building
    // the output string. Int::to_char also rejects surrogate code points.
    guard n.to_char() is Some(_) else { raise BadInput }
    // Insert n at position i_val.
    output.blit_to(
      output,
      len=output_length - i_val,
      src_offset=i_val,
      dst_offset=i_val + 1,
    )
    output[i_val] = n
    output_length = out_len
    output_units += if n > 0xFFFF { 2 } else { 1 }
    i_val = i_val + 1
  }

  // The size hint counts bytes, so the builder is filled exactly.
  let result = StringBuilder(size_hint=2 * output_units)
  for i in 0..<output_length {
    result.write_char(output[i].unsafe_to_char())
  }
  result.to_string()
}
