///|
/// Number of low bits holding the status code in a packed trie value or range.
const IdnaStatusBits : Int32 = 3

///|
/// Status code of code points the mapping table does not list.
const IdnaDisallowed : Int32 = 4

///|
priv struct MappingEntry {
  start : Int32
  end : Int32
  status : String
  mapping : Array[Int32]
}

///|
fn parse_mapping_table(content : String) -> Array[MappingEntry] raise {
  let entries : Array[MappingEntry] = []
  for fields in @parsing.data_lines(content) {
    guard fields is [range, status, .. rest] else { continue }
    let range = @parsing.parse_code_point_range(range)
    let status = status.to_owned().to_lower().replace_all(old=" ", new="_")
    let mapping = if rest is [mapping, ..] {
      @parsing.parse_code_point_sequence(mapping)
    } else {
      []
    }
    entries.push({ start: range.start, end: range.end, status, mapping, })
  }
  entries
}

///|
/// IDNA status values in the order of the `IdnaStatus` enum: the
/// constructor, the status IdnaMappingTable.txt writes (in lowercase, with
/// underscores for spaces), and a description.
let idna_statuses : ReadOnlyArray[(String, String, String)] = [
  ("Valid", "valid", "Valid character"),
  ("Ignored", "ignored", "Character is removed"),
  ("Mapped", "mapped", "Character is replaced by its mapping"),
  ("Deviation", "deviation", "Treated as valid in nontransitional mode"),
  ("Disallowed", "disallowed", "Character is not allowed"),
  (
    "DisallowedSTD3Valid", "disallowed_std3_valid", "Valid only without UseSTD3ASCIIRules",
  ),
  (
    "DisallowedSTD3Mapped", "disallowed_std3_mapped", "Mapped only without UseSTD3ASCIIRules",
  ),
]

///|
/// Status code of a status: its index in `idna_statuses`. Unknown statuses
/// are disallowed.
fn status_code(status : String) -> Int32 {
  idna_statuses.search_by(entry => entry.1 == status).unwrap_or(IdnaDisallowed)
}

///|
/// Emit the IDNA mapping table as a value trie.
///
/// Every code point has a packed value `mapping << 3 | status`, where
/// `mapping` numbers the distinct mappings (0 is the empty mapping). The
/// higher planes, which the trie does not cover, hold statuses without
/// mappings.
pub fn emit_mapping(content : String) -> String raise {
  // Mapping `i` is `mapping_data[mapping_offsets[i]:mapping_offsets[i + 1]]`.
  let mapping_ids : Map[Array[Int32], Int32] = Map([([], 0)])
  let mapping_offsets : Array[Int32] = [0, 0]
  let mapping_data : Array[Int32] = []
  let values = FixedArray::make(@emitter.MaxCodePoint + 1, IdnaDisallowed)
  for entry in parse_mapping_table(content) {
    let mapping = match mapping_ids.get(entry.mapping) {
      Some(id) => id
      None => {
        let id = mapping_ids.length()
        mapping_ids[entry.mapping] = id
        mapping_data.append(entry.mapping)
        mapping_offsets.push(mapping_data.length())
        id
      }
    }
    let value = (mapping << IdnaStatusBits) | status_code(entry.status)
    for code_point in entry.start..<=entry.end {
      values[code_point] = value
    }
  }
  let status_mask = (1 << IdnaStatusBits) - 1
  let out = @emitter.Emitter::new()
  out.write_file_header("IDNA Mapping Table (UTS #46)", "IdnaMappingTable.txt")
  out.write_enum(
    type_name="IdnaStatus",
    doc=["IDNA status values"],
    converter="idna_status_from_ordinal",
    values=idna_statuses
      .iter()
      .map(entry => @emitter.EnumValue::{ name: entry.0, comment: entry.2, })
      .collect(),
    fallback="Disallowed",
  )
  out.write_value_trie(
    property="IDNA",
    prefix="idna",
    lookup="fn lookup_idna_value",
    lookup_doc=["Look up the packed mapping table entry of a character."],
    value_bits=16,
    range_value_bits=IdnaStatusBits,
    values,
  )
  out.write_int_array(
    "Mapping `i` is `idna_mapping_data[idna_mapping_offsets[i]:idna_mapping_offsets[i + 1]]`",
    "idna_mapping_offsets",
    mapping_offsets,
    hex=false,
  )
  out.write_int_array(
    "Mapping data (flattened code points)",
    "idna_mapping_data",
    mapping_data,
    hex=true,
  )
  out.write(
    (
      $|///|
      $|/// Mapping table entry of a character, packed as
      $|/// `mapping << \{IdnaStatusBits} | status`. Looking one up allocates nothing.
      $|struct IdnaEntry(Int)
      $|
      $|///|
      $|/// Look up the mapping table entry of a character.
      $|pub fn lookup_idna_entry(c : Char) -> IdnaEntry {
      $|  IdnaEntry(lookup_idna_value(c))
      $|}
      $|
      $|///|
      $|pub fn IdnaEntry::status(self : IdnaEntry) -> IdnaStatus {
      $|  idna_status_from_ordinal(self.0 & \{status_mask})
      $|}
      $|
      $|///|
      $|/// Append the entry's mapping, which is empty unless the status is
      $|/// `Mapped`, `Deviation` or `DisallowedSTD3Mapped`.
      $|pub fn IdnaEntry::write_mapping(self : IdnaEntry, output : StringBuilder) -> Unit {
      $|  let index = self.0 >> \{IdnaStatusBits}
      $|  for code_point in idna_mapping_data.exact_view(
      $|    start=idna_mapping_offsets[index],
      $|    end=idna_mapping_offsets[index + 1],
      $|  ) {
      $|    output.write_char(code_point.unsafe_to_char())
      $|  }
      $|}
      $|
    ),
  )
  out.finish()
}
