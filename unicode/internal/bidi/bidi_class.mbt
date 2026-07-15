///|
pub(all) enum BidiClass {
  L
  R
  AL
  EN
  ES
  ET
  AN
  CS
  NSM
  BN
  B
  S
  WS
  ON
  LRE
  LRO
  RLE
  RLO
  PDF
  LRI
  RLI
  FSI
  PDI
} derive(Eq)

///|
pub impl Show for BidiClass with fn output(self, logger) {
  match self {
    L => logger.write_string("L")
    R => logger.write_string("R")
    AL => logger.write_string("AL")
    EN => logger.write_string("EN")
    ES => logger.write_string("ES")
    ET => logger.write_string("ET")
    AN => logger.write_string("AN")
    CS => logger.write_string("CS")
    NSM => logger.write_string("NSM")
    BN => logger.write_string("BN")
    B => logger.write_string("B")
    S => logger.write_string("S")
    WS => logger.write_string("WS")
    ON => logger.write_string("ON")
    LRE => logger.write_string("LRE")
    LRO => logger.write_string("LRO")
    RLE => logger.write_string("RLE")
    RLO => logger.write_string("RLO")
    PDF => logger.write_string("PDF")
    LRI => logger.write_string("LRI")
    RLI => logger.write_string("RLI")
    FSI => logger.write_string("FSI")
    PDI => logger.write_string("PDI")
  }
}

///|
pub fn BidiClass::is_strong(self : BidiClass) -> Bool {
  self is (L | R | AL)
}

///|
pub fn BidiClass::is_strong_rtl(self : BidiClass) -> Bool {
  self is (R | AL)
}

///|
pub fn BidiClass::is_weak(self : BidiClass) -> Bool {
  self is (EN | ES | ET | AN | CS | NSM | BN)
}

///|
pub fn BidiClass::is_neutral(self : BidiClass) -> Bool {
  self is (B | S | WS | ON)
}

///|
pub fn BidiClass::is_explicit(self : BidiClass) -> Bool {
  self is (LRE | LRO | RLE | RLO | PDF | LRI | RLI | FSI | PDI)
}

///|
pub fn BidiClass::is_isolate_initiator(self : BidiClass) -> Bool {
  self is (LRI | RLI | FSI)
}

///|
pub fn BidiClass::is_x9_removed(self : BidiClass) -> Bool {
  self is (LRE | RLE | LRO | RLO | PDF | BN)
}

///|
pub fn BidiClass::is_neutral_or_isolate(self : BidiClass) -> Bool {
  self is (B | S | WS | ON | FSI | LRI | RLI | PDI)
}
