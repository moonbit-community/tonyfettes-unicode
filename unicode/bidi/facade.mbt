///|
pub using @impl {get_mirrored, requires_bidi}

///|
pub using @legacy_data {type BidiClass}

///|
pub(all) suberror BidiError {
  InvalidIsolate(String)
  StackOverflow
}

///|
pub(all) enum Direction {
  LTR
  RTL
} derive(Eq)

///|
pub impl Show for Direction with fn output(self, logger) {
  match self {
    LTR => logger.write_string("LTR")
    RTL => logger.write_string("RTL")
  }
}

///|
pub(all) struct BidiParagraph {
  chars : Array[Char]
  original_classes : Array[BidiClass]
  resolved_classes : Array[BidiClass]
  levels : Array[Int]
  base_level : Int
}

///|
fn bidi_class_from_impl(class : @impl.BidiClass) -> BidiClass {
  match class {
    @impl.L => @legacy_data.L
    @impl.R => @legacy_data.R
    @impl.AL => @legacy_data.AL
    @impl.EN => @legacy_data.EN
    @impl.ES => @legacy_data.ES
    @impl.ET => @legacy_data.ET
    @impl.AN => @legacy_data.AN
    @impl.CS => @legacy_data.CS
    @impl.NSM => @legacy_data.NSM
    @impl.BN => @legacy_data.BN
    @impl.B => @legacy_data.B
    @impl.S => @legacy_data.S
    @impl.WS => @legacy_data.WS
    @impl.ON => @legacy_data.ON
    @impl.LRE => @legacy_data.LRE
    @impl.LRO => @legacy_data.LRO
    @impl.RLE => @legacy_data.RLE
    @impl.RLO => @legacy_data.RLO
    @impl.PDF => @legacy_data.PDF
    @impl.LRI => @legacy_data.LRI
    @impl.RLI => @legacy_data.RLI
    @impl.FSI => @legacy_data.FSI
    @impl.PDI => @legacy_data.PDI
  }
}

///|
fn bidi_class_to_impl(class : BidiClass) -> @impl.BidiClass {
  match class {
    @legacy_data.L => @impl.L
    @legacy_data.R => @impl.R
    @legacy_data.AL => @impl.AL
    @legacy_data.EN => @impl.EN
    @legacy_data.ES => @impl.ES
    @legacy_data.ET => @impl.ET
    @legacy_data.AN => @impl.AN
    @legacy_data.CS => @impl.CS
    @legacy_data.NSM => @impl.NSM
    @legacy_data.BN => @impl.BN
    @legacy_data.B => @impl.B
    @legacy_data.S => @impl.S
    @legacy_data.WS => @impl.WS
    @legacy_data.ON => @impl.ON
    @legacy_data.LRE => @impl.LRE
    @legacy_data.LRO => @impl.LRO
    @legacy_data.RLE => @impl.RLE
    @legacy_data.RLO => @impl.RLO
    @legacy_data.PDF => @impl.PDF
    @legacy_data.LRI => @impl.LRI
    @legacy_data.RLI => @impl.RLI
    @legacy_data.FSI => @impl.FSI
    @legacy_data.PDI => @impl.PDI
  }
}

///|
fn Direction::to_impl(self : Direction) -> @impl.Direction {
  match self {
    LTR => @impl.LTR
    RTL => @impl.RTL
  }
}

///|
fn direction_from_impl(direction : @impl.Direction) -> Direction {
  match direction {
    @impl.LTR => LTR
    @impl.RTL => RTL
  }
}

///|
fn paragraph_from_impl(paragraph : @impl.BidiParagraph) -> BidiParagraph {
  {
    chars: paragraph.chars,
    original_classes: paragraph.original_classes.map(bidi_class_from_impl),
    resolved_classes: paragraph.resolved_classes.map(bidi_class_from_impl),
    levels: paragraph.levels,
    base_level: paragraph.base_level,
  }
}

///|
fn BidiParagraph::to_impl(self : BidiParagraph) -> @impl.BidiParagraph {
  {
    chars: self.chars,
    original_classes: self.original_classes.map(bidi_class_to_impl),
    resolved_classes: self.resolved_classes.map(bidi_class_to_impl),
    levels: self.levels,
    base_level: self.base_level,
  }
}

///|
pub fn bidi_class(c : Char) -> BidiClass {
  bidi_class_from_impl(@impl.bidi_class(c))
}

///|
pub fn detect_direction(text : String) -> Direction {
  direction_from_impl(@impl.detect_direction(text))
}

///|
pub fn process(text : String, direction? : Direction) -> BidiParagraph {
  let impl_direction = direction.map(direction => direction.to_impl())
  paragraph_from_impl(@impl.process(text, direction?=impl_direction))
}

///|
pub fn reorder(paragraph : BidiParagraph) -> Array[Int] {
  @impl.reorder(paragraph.to_impl())
}

///|
pub fn reorder_string(paragraph : BidiParagraph) -> String {
  @impl.reorder_string(paragraph.to_impl())
}

///|
pub fn Direction::level(self : Direction) -> Int {
  match self {
    LTR => 0
    RTL => 1
  }
}

///|
pub fn direction_from_level(level : Int) -> Direction {
  if level % 2 == 0 {
    LTR
  } else {
    RTL
  }
}

///|
#deprecated("Use process(text, direction=direction) instead")
pub fn process_with_direction(
  text : String,
  direction : Direction,
) -> BidiParagraph {
  process(text, direction~)
}

///|
#deprecated("Use process(text, direction=LTR or RTL) instead")
pub fn process_with_base_level(
  text : String,
  base_level : Int,
) -> BidiParagraph {
  process(text, direction=direction_from_level(base_level))
}
