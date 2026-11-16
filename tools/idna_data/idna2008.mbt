///|
/// The character classes needed by IDNA2008 validation. Contextual rules
/// themselves are checked against the complete label, not in this table.
fn parse_idna2008_properties(
  idna2008 : String,
  scripts : String,
) -> FixedArray[Int32] raise {
  let values = @parsing.parse_enumerated_ordinals(
    idna2008,
    property="IDNA2008 category",
    default="UNASSIGNED",
    category => {
      match category {
        "PVALID" | "CONTEXTJ" | "CONTEXTO" => Some(1)
        "DISALLOWED" | "UNASSIGNED" => Some(0)
        _ => None
      }
    },
  )
  // These are Script values, not Script_Extensions: in particular, U+30FB
  // KATAKANA MIDDLE DOT must not satisfy its own CONTEXTO condition.
  for
    code_point, script in @parsing.parse_enumerated_property(
      scripts,
      default="Unknown",
    ) {
    let flag = match script {
      "Greek" => 2
      "Hebrew" => 4
      "Hiragana" | "Katakana" | "Han" => 8
      _ => 0
    }
    values[code_point] = values[code_point] | flag
  }
  values
}

///|
/// Emit the IDNA2008 allowed character set and the Script predicates used
/// by RFC 5892 Appendix A's CONTEXTO rules in one shared value trie.
pub fn emit_idna2008(idna2008 : String, scripts : String) -> String raise {
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "IDNA2008 character validity and CONTEXTO Script data", "Idna2008.txt and Scripts.txt",
  )
  out.write_value_trie(
    property="IDNA2008",
    prefix="idna2008",
    lookup="fn lookup_idna2008_properties",
    lookup_doc=[
      "Bits for IDNA2008 allowed characters (1), Greek (2), Hebrew (4),", "and Hiragana, Katakana or Han (8).",
    ],
    value_bits=4,
    parse_idna2008_properties(idna2008, scripts),
  )
  for
    (name, flag, description) in [
      (
        "is_idna2008_allowed", 1, "Whether a character is PVALID, CONTEXTJ or CONTEXTO in IDNA2008.",
      ),
      ("is_greek", 2, "Whether a character has Script=Greek."),
      ("is_hebrew", 4, "Whether a character has Script=Hebrew."),
      (
        "is_japanese", 8, "Whether a character has Script=Hiragana, Katakana or Han.",
      ),
    ] {
    out.write(
      (
        $|///|
        $|/// \{description}
        $|pub fn \{name}(c : Char) -> Bool {
        $|  (lookup_idna2008_properties(c) & \{flag}) != 0
        $|}
        $|
      ),
    )
  }
  out.finish()
}
