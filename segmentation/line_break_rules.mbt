///|
/// Summary of the non-SP base preceding a run of spaces (for LB8, LB14, LB15a,
/// LB16, LB17).
const SpaceRuleNone : Int32 = 0

///|
const SpaceRuleZW : Int32 = 1

///|
/// Covers both LB14 (`OP SP* ×`) and LB15a (`... QUPi SP* ×`).
const SpaceRuleOP : Int32 = 2

///|
const SpaceRuleCLCP : Int32 = 3

///|
const SpaceRuleB2 : Int32 = 4

///|
fn update_space_rule(
  prev_cls : Int32,
  new_cls : Int32,
  current : Int32,
) -> Int32 {
  if new_cls == LbSP {
    return current
  }
  match new_cls {
    LbZW => SpaceRuleZW
    LbOP | LbOPEA => SpaceRuleOP
    LbQUPi =>
      if prev_cls
        is (LbNone
        | LbBK
        | LbCR
        | LbLF
        | LbNL
        | LbOP
        | LbOPEA
        | LbQU
        | LbQUPi
        | LbQUPf
        | LbGL
        | LbSP
        | LbZW) {
        SpaceRuleOP
      } else {
        SpaceRuleNone
      }
    LbCL | LbCP | LbCPEA => SpaceRuleCLCP
    LbB2 => SpaceRuleB2
    _ => SpaceRuleNone
  }
}

///|
fn is_lb15b_after(cls : Int32) -> Bool {
  cls
  is (LbNone
  | LbSP
  | LbGL
  | LbWJ
  | LbCL
  | LbQU
  | LbQUPi
  | LbQUPf
  | LbCP
  | LbCPEA
  | LbEX
  | LbIS
  | LbSY
  | LbBK
  | LbCR
  | LbLF
  | LbNL
  | LbZW)
}

///|
fn lb_is_aksara(cls : Int32) -> Bool {
  cls is (LbAK | LbAS | LbDottedCircle)
}

///|
/// Peek the next significant unit starting after a base of class `prev_cls`
/// whose base code point ended at `pos`, skipping any LB9 marks absorbed by
/// `prev_cls` and applying LB10 if the next unit is a remaining CM/ZWJ.
/// Returns `(val, base_end)` with `val == 0` (`LbNone`) at end of text.
fn lb_peek_next_unit(
  text : StringView,
  pos : Int32,
  prev_cls : Int32,
) -> (Int32, Int32) {
  let length = text.length()
  let mut offset = pos
  let absorb = !(prev_cls is (LbBK | LbCR | LbLF | LbNL | LbSP | LbZW))
  while offset < length {
    let cp = code_point_at(text, offset, length)
    let next_offset = offset + (if cp >= 0x10000 { 2 } else { 1 })
    let raw_val = line_break_value(cp)
    let raw_cls = raw_val & LbClassMask
    if raw_cls >= LbCM {
      if absorb {
        offset = next_offset
        continue
      }
      return (LbAL, next_offset)
    }
    return (raw_val, next_offset)
  }
  (0, length)
}

///|
/// Resolve UAX #14 revision 57 context-dependent boundaries (pairs marked
/// `LbPairContext` in `line_break_pair_table`, with `left_ends_with_zwj == false`).
fn lb_context_boundary(
  text : StringView,
  right_base_end : Int32,
  left_val : Int32,
  right_val : Int32,
  before_val : Int32,
  left_numeric : Bool,
  before_numeric : Bool,
  space_rule : Int32,
  regional_odd : Bool,
) -> Int32 {
  let a = left_val & LbClassMask
  let b = right_val & LbClassMask
  // Fast path for SP (by far the most frequent context pair in prose).
  // LB6 (b in BK|CR|LF|NL) and LB7 (b in SP|ZW) are already decided by the
  // pair table before reaching here.
  if a == LbSP {
    if space_rule == SpaceRuleNone {
      if b == LbIS {
        let (after_val, _) = lb_peek_next_unit(text, right_base_end, b)
        return if (after_val & LbClassMask) == LbNU {
          LbPairAllowed
        } else {
          LbPairProhibited
        }
      }
      if b == LbQUPf {
        let (after_val, _) = lb_peek_next_unit(text, right_base_end, b)
        if is_lb15b_after(after_val & LbClassMask) {
          return LbPairProhibited
        }
        return LbPairAllowed
      }
      return if b is (LbWJ | LbCL | LbCP | LbCPEA | LbEX | LbSY) {
        LbPairProhibited
      } else {
        LbPairAllowed
      }
    }
    // LB8: ZW SP* ÷
    if space_rule == SpaceRuleZW {
      return LbPairAllowed
    }
    // LB11, LB13
    if b is (LbWJ | LbCL | LbCP | LbCPEA | LbEX | LbSY) {
      return LbPairProhibited
    }
    // LB14 & LB15a: (OP | ... QUPi) SP* ×
    if space_rule == SpaceRuleOP {
      return LbPairProhibited
    }
    // LB15b
    if b == LbQUPf {
      let (after_val, _) = lb_peek_next_unit(text, right_base_end, b)
      if is_lb15b_after(after_val & LbClassMask) {
        return LbPairProhibited
      }
    }
    // LB15c-LB15d
    if b == LbIS {
      let (after_val, _) = lb_peek_next_unit(text, right_base_end, b)
      return if (after_val & LbClassMask) == LbNU {
        LbPairAllowed
      } else {
        LbPairProhibited
      }
    }
    // LB16-LB17
    if (space_rule == SpaceRuleCLCP && b == LbNS) ||
      (space_rule == SpaceRuleB2 && b == LbB2) {
      return LbPairProhibited
    }
    // LB18: SP ÷
    return LbPairAllowed
  }
  // Non-SP context pairs (all rules through LB14 are already decided by the
  // pair table). Evaluate LB15a..LB31 in exact rule order.
  let before = before_val & LbClassMask
  // LB15a: initial quote after permitted context.
  if a == LbQUPi && space_rule == SpaceRuleOP {
    return LbPairProhibited
  }
  // LB15b: final quote before permitted context.
  if b == LbQUPf {
    let (after_val, _) = lb_peek_next_unit(text, right_base_end, b)
    if is_lb15b_after(after_val & LbClassMask) {
      return LbPairProhibited
    }
  }
  // LB15d
  if b == LbIS {
    return LbPairProhibited
  }
  // LB16-LB17
  if (a is (LbCL | LbCP | LbCPEA) && b == LbNS) || (a == LbB2 && b == LbB2) {
    return LbPairProhibited
  }
  // LB19-LB19a: unresolved quotes and East Asian surroundings.
  if b is (LbQU | LbQUPf) || a is (LbQU | LbQUPi) {
    return LbPairProhibited
  }
  if b == LbQUPi {
    if (left_val & LbEastAsianBit) == 0 {
      return LbPairProhibited
    }
    let (after_val, _) = lb_peek_next_unit(text, right_base_end, b)
    if (after_val & LbEastAsianBit) == 0 {
      return LbPairProhibited
    }
  }
  if a == LbQUPf &&
    ((right_val & LbEastAsianBit) == 0 || (before_val & LbEastAsianBit) == 0) {
    return LbPairProhibited
  }
  // LB20-LB20a
  if a == LbCB || b == LbCB {
    return LbPairAllowed
  }
  if a is (LbHY | LbHH) &&
    b is (LbAL | LbDottedCircle | LbHL) &&
    before is (LbNone | LbBK | LbCR | LbLF | LbNL | LbSP | LbZW | LbCB | LbGL) {
    return LbPairProhibited
  }
  // LB21a
  if before == LbHL && a is (LbHY | LbHH) && b != LbHL {
    return LbPairProhibited
  }
  // LB25: numeric sequences.
  if b is (LbPO | LbPR) &&
    (left_numeric || (a is (LbCL | LbCP | LbCPEA) && before_numeric)) {
    return LbPairProhibited
  }
  if a is (LbPO | LbPR) && b is (LbOP | LbOPEA) {
    let (after_val, after_end) = lb_peek_next_unit(text, right_base_end, b)
    let after = after_val & LbClassMask
    if after == LbNU {
      return LbPairProhibited
    }
    if after == LbIS {
      let (after2_val, _) = lb_peek_next_unit(text, after_end, LbIS)
      if (after2_val & LbClassMask) == LbNU {
        return LbPairProhibited
      }
    }
  }
  if b == LbNU && (a is (LbHY | LbIS) || left_numeric) {
    return LbPairProhibited
  }
  // LB28a: Brahmic orthographic syllables.
  if a == LbVI && b is (LbAK | LbDottedCircle) && lb_is_aksara(before) {
    return LbPairProhibited
  }
  if lb_is_aksara(a) && lb_is_aksara(b) {
    let (after_val, _) = lb_peek_next_unit(text, right_base_end, b)
    if (after_val & LbClassMask) == LbVF {
      return LbPairProhibited
    }
  }
  // LB30a-LB30b
  if a == LbRI && b == LbRI && regional_odd {
    return LbPairProhibited
  }
  if b == LbEM && (a == LbEB || (left_val & LbPotentialEmojiBit) != 0) {
    return LbPairProhibited
  }
  // LB31
  LbPairAllowed
}
