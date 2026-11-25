///|
/// I1-I2: Implicit Level Calculation
///
/// These rules adjust embedding levels based on resolved types.

///|
/// Apply implicit level rules
fn apply_implicit_levels(
  types : Array[BidiClass],
  levels : Array[Int32],
) -> Unit {
  let len = types.length()
  for i in 0..<len {
    let bc = types.unsafe_get(i)

    // Skip removed characters (BN)
    if bc is BN {
      continue
    }

    let level = levels.unsafe_get(i)

    // I1: For characters at even (LTR) levels
    // R -> level + 1
    // AN, EN -> level + 2
    if (level & 1) == 0 {
      match bc {
        R => levels.unsafe_set(i, level + 1)
        AN | EN => levels.unsafe_set(i, level + 2)
        _ => ()
      }
    } else {
      // I2: For characters at odd (RTL) levels
      // L, EN, AN -> level + 1
      match bc {
        L | EN | AN => levels.unsafe_set(i, level + 1)
        _ => ()
      }
    }
  }
}
