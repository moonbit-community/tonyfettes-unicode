///|
/// Number of bits holding a Joining_Group ordinal in the packed high ranges.
const JoiningGroupBits : Int32 = 7

///|
/// Order two value names as a dictionary does. `String::compare` orders by
/// length first.
fn dictionary_order(a : String, b : String) -> Int32 {
  for i in 0..<Int32::min(a.length(), b.length()) {
    let order = a[i].compare(b[i])
    if order != 0 {
      return order
    }
  }
  a.length().compare(b.length())
}

///|
/// Enum constructor for a Joining_Group value: the value name without its
/// underscores, so that `Yeh_Barree` becomes `YehBarree`.
fn joining_group_constructor(value : String) -> String {
  value.replace_all(old="_", new="")
}

///|
/// The Joining_Group value of every code point, and the values occurring in
/// `DerivedJoiningGroup.txt` in dictionary order, which is the order of the
/// `JoiningGroup` enum.
fn parse_joining_groups(
  content : String,
) -> (FixedArray[String], Array[String]) raise {
  let names = @parsing.parse_enumerated_property(
    content,
    default="No_Joining_Group",
  )
  let distinct : Map[String, Unit] = Map([])
  for name in names {
    distinct[name] = ()
  }
  let sorted = distinct.keys().collect()
  sorted.sort_by(dictionary_order)
  guard sorted.length() <= 1 << JoiningGroupBits else {
    fail("Joining_Group values do not fit in \{JoiningGroupBits} bits")
  }
  (names, sorted)
}

///|
/// Emit Joining_Group data from `DerivedJoiningGroup.txt` as a three-level
/// trie for planes 0-3, with packed ranges for the remaining planes.
pub fn emit_joining_group(content : String) -> String raise {
  let (names, sorted) = parse_joining_groups(content)
  let ordinals : Map[String, Int32] = Map([])
  for ordinal, name in sorted {
    ordinals[name] = ordinal
  }
  let values = property_ordinals(property="Joining_Group", names, name => {
    ordinals.get(name.to_owned())
  })
  let out = @emitter.Emitter::new()
  out.write_file_header("Joining_Group lookup data", "DerivedJoiningGroup.txt")
  out.write_value_trie(
    property="Joining_Group",
    prefix="joining_group",
    lookup="pub fn lookup_joining_group",
    lookup_doc=[
      "Look up Joining_Group ordinal for a character",
      "Returns ordinal value (0-\{sorted.length() - 1}) corresponding to JoiningGroup enum",
    ],
    value_bits=JoiningGroupBits,
    values,
  )
  out.finish()
}

///|
/// Emit the `JoiningGroup` enum and the `joining_group` lookup of the root
/// package, which reads the ordinals `emit_joining_group` stores.
///
/// The enum lists the values occurring in `DerivedJoiningGroup.txt` in
/// dictionary order.
pub fn emit_joining_group_enum(content : String) -> String raise {
  let (_, sorted) = parse_joining_groups(content)
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Joining_Group values and lookup", "DerivedJoiningGroup.txt",
  )
  write_property_enum(
    out,
    type_name="JoiningGroup",
    doc=[
      "Unicode Joining_Group values", "See the Unicode Standard, section 9.2, Arabic:",
      "https://www.unicode.org/versions/latest/core-spec/chapter-9/#G7480",
    ],
    converter="ordinal_to_joining_group",
    values=sorted.map(name => {
      name: joining_group_constructor(name),
      comment: name,
    }),
    fallback="NoJoiningGroup",
  )
  out.write(
    (
      #|///|
      #|/// Get the Joining_Group for a character.
      #|///
      #|/// Joining_Group classifies the letters of cursive scripts such as Arabic,
      #|/// Syriac, and Manichaean by the shape they join with: letters that
      #|/// differ only in their dots, like U+0628 ARABIC LETTER BEH and U+062A
      #|/// ARABIC LETTER TEH, share a group. Characters that are not such
      #|/// letters, including unassigned code points, are NoJoiningGroup.
      #|///
      #|/// The value `Pe` shares its name with a `GeneralCategory` value: write
      #|/// `JoiningGroup::Pe` or `GeneralCategory::Pe` where the type is not
      #|/// known from the context.
      #|pub fn joining_group(c : Char) -> JoiningGroup {
      #|  ordinal_to_joining_group(@joining_group.lookup_joining_group(c))
      #|}
      #|
    ),
  )
  out.finish()
}
