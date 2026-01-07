///|
/// Punycode encoding/decoding (RFC 3492)
/// Used for Internationalized Domain Names in Applications (IDNA)

///|
/// Error type for Punycode operations
pub(all) suberror PunycodeError {
  Overflow
  InvalidInput
  BadInput
} derive(Show)

// RFC 3492 constants

///|
let base : Int = 36

///|
let tmin : Int = 1

///|
let tmax : Int = 26

///|
let skew : Int = 38

///|
let damp : Int = 700

///|
let initial_bias : Int = 72

///|
let initial_n : Int = 0x80

///|
let delimiter : Char = '-'

///|
/// Bias adaptation function (RFC 3492 Section 3.4)
fn adapt(delta : Int, numpoints : Int, firsttime : Bool) -> Int {
  let mut delta = delta
  if firsttime {
    delta = delta / damp
  } else {
    delta = delta / 2
  }
  delta = delta + delta / numpoints
  let mut k = 0
  while delta > (base - tmin) * tmax / 2 {
    delta = delta / (base - tmin)
    k = k + base
  }
  k + (base - tmin + 1) * delta / (delta + skew)
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
    base // Invalid
  }
}

///|
/// Check if a character is a basic ASCII character (0-127)
fn is_basic(cp : Int) -> Bool {
  cp < 0x80
}

///|
/// Encode a Unicode string to Punycode
pub fn encode(input : String) -> String raise PunycodeError {
  let output = StringBuilder::new()

  // Convert input to array of code points
  let codepoints : Array[Int] = []
  for c in input {
    codepoints.push(c.to_int())
  }

  // Copy all basic code points to output
  let mut basic_count = 0
  for cp in codepoints {
    if is_basic(cp) {
      output.write_char(cp.unsafe_to_char())
      basic_count = basic_count + 1
    }
  }

  // Add delimiter if there were basic characters
  let handled = basic_count
  if basic_count > 0 {
    output.write_char(delimiter)
  }
  let mut n = initial_n
  let mut delta = 0
  let mut bias = initial_bias
  let mut handled = handled
  while handled < codepoints.length() {
    // Find the minimum code point >= n
    let mut m = 0x10FFFF + 1
    for cp in codepoints {
      if cp >= n && cp < m {
        m = cp
      }
    }

    // Increase delta enough to advance the decoder's <n,i> state to <m,0>
    let delta_increment = (m - n) * (handled + 1)
    if delta > 0x7FFFFFFF - delta_increment {
      raise Overflow
    }
    delta = delta + delta_increment
    n = m
    for cp in codepoints {
      if cp < n {
        delta = delta + 1
        if delta == 0 {
          raise Overflow
        }
      } else if cp == n {
        // Represent delta as a generalized variable-length integer
        let mut q = delta
        let mut k = base
        while true {
          let t = if k <= bias {
            tmin
          } else if k >= bias + tmax {
            tmax
          } else {
            k - bias
          }
          if q < t {
            break
          }
          output.write_char(encode_digit(t + (q - t) % (base - t)))
          q = (q - t) / (base - t)
          k = k + base
        }
        output.write_char(encode_digit(q))
        bias = adapt(delta, handled + 1, handled == basic_count)
        delta = 0
        handled = handled + 1
      }
    }
    delta = delta + 1
    n = n + 1
  }
  output.to_string()
}

///|
/// Decode a Punycode string to Unicode
pub fn decode(input : String) -> String raise PunycodeError {
  let output : Array[Int] = []

  // Find the last delimiter
  let mut basic_end = -1
  let mut i = 0
  for c in input {
    if c == delimiter {
      basic_end = i
    }
    i = i + 1
  }

  // Copy basic code points before the last delimiter
  if basic_end > 0 {
    let mut j = 0
    for c in input {
      if j >= basic_end {
        break
      }
      let cp = c.to_int()
      if not(is_basic(cp)) {
        raise BadInput
      }
      output.push(cp)
      j = j + 1
    }
  }

  // Main decoding loop
  let mut n = initial_n
  let mut i_val = 0
  let mut bias = initial_bias
  let mut in_pos = if basic_end >= 0 { basic_end + 1 } else { 0 }

  // Convert input to array for easier indexing
  let input_chars : Array[Char] = []
  for c in input {
    input_chars.push(c)
  }
  while in_pos < input_chars.length() {
    let oldi = i_val
    let mut w = 1
    let mut k = base
    while true {
      if in_pos >= input_chars.length() {
        raise BadInput
      }
      let digit = decode_digit(input_chars[in_pos].to_int())
      in_pos = in_pos + 1
      if digit >= base {
        raise BadInput
      }
      if digit > (0x7FFFFFFF - i_val) / w {
        raise Overflow
      }
      i_val = i_val + digit * w
      let t = if k <= bias {
        tmin
      } else if k >= bias + tmax {
        tmax
      } else {
        k - bias
      }
      if digit < t {
        break
      }
      if w > 0x7FFFFFFF / (base - t) {
        raise Overflow
      }
      w = w * (base - t)
      k = k + base
    }
    let out_len = output.length() + 1
    bias = adapt(i_val - oldi, out_len, oldi == 0)
    if i_val / out_len > 0x7FFFFFFF - n {
      raise Overflow
    }
    n = n + i_val / out_len
    i_val = i_val % out_len

    // Insert n at position i_val
    output.insert(i_val, n)
    i_val = i_val + 1
  }

  // Convert code points to string
  codepoints_to_string(output)
}

///|
/// Convert array of code points to string
fn codepoints_to_string(codepoints : Array[Int]) -> String {
  let sb = StringBuilder::new()
  for cp in codepoints {
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
