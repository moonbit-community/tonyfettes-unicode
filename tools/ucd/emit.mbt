///|
pub fn emit_ccc() -> String {
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Canonical Combining Class (CCC) lookup", "UnicodeData.txt",
  )
  out.write(
    (
      #|///|
      #|pub using @normalization_data {lookup_normalization_properties}
      #|
      #|///|
      #|/// Look up Canonical Combining Class; 0 denotes a starter.
      #|pub fn lookup_ccc(c : Char) -> Int {
      #|  @normalization_data.lookup_normalization_properties(c) & 255
      #|}
      #|
    ),
  )
  out.finish()
}

///|
/// Bits of a packed decomposition entry: the code point occupies the low
/// 21 bits and its Canonical_Combining_Class the eight above them.
const DecompositionCccShift : Int32 = 21

///|
const DecompositionCodePointMask : Int32 = 0x1FFFFF

///|
/// A packed decomposition entry: `code_point` and its combining class.
fn packed_entry(data : UnicodeData, code_point : Int32) -> Int32 {
  code_point | (data.ccc[code_point] << DecompositionCccShift)
}

///|
/// Append the full decomposition of `code_point` to `dest` as packed
/// entries: its mapping, applied recursively, where a compatibility mapping
/// applies only when `compatibility` is set.
fn append_full_decomposition(
  data : UnicodeData,
  mappings : Map[Int32, Decomposition],
  code_point : Int32,
  compatibility : Bool,
  dest : Array[Int32],
) -> Unit raise {
  // Hangul syllables decompose algorithmically. The runtime does not look
  // them up, so a mapping that produced one would leave it composed.
  guard code_point < 0xAC00 || code_point > 0xD7A3 else {
    fail("A decomposition mapping produces a Hangul syllable")
  }
  if mappings.get(code_point) is Some(entry) &&
    (compatibility || !entry.compatibility) {
    for target in entry.code_points {
      append_full_decomposition(data, mappings, target, compatibility, dest)
    }
  } else {
    dest.push(packed_entry(data, code_point))
  }
}

///|
pub fn emit_decomposition(data : UnicodeData) -> String raise {
  let mappings : Map[Int32, Decomposition] = Map([])
  for entry in data.decompositions {
    mappings[entry.code_point] = entry
  }
  // Each row's entries are its full canonical decomposition (canonical
  // mappings only), its full compatibility decomposition (compatibility
  // mappings, or canonical ones whose full compatibility decomposition
  // differs), and its own mapping, when that differs from the full
  // decomposition of its kind.
  let starts : Array[Int32] = []
  let canonical_lens : Array[Int32] = []
  let compat_lens : Array[Int32] = []
  let mapping_lens : Array[Int32] = []
  let entries : Array[Int32] = []
  for entry in data.decompositions {
    starts.push(entries.length())
    let compat : Array[Int32] = []
    append_full_decomposition(data, mappings, entry.code_point, true, compat)
    let full = if entry.compatibility {
      canonical_lens.push(0)
      compat_lens.push(compat.length())
      entries.append(compat)
      compat
    } else {
      let canonical : Array[Int32] = []
      append_full_decomposition(
        data,
        mappings,
        entry.code_point,
        false,
        canonical,
      )
      canonical_lens.push(canonical.length())
      entries.append(canonical)
      if compat == canonical {
        compat_lens.push(0)
      } else {
        compat_lens.push(compat.length())
        entries.append(compat)
      }
      canonical
    }
    let mapping = entry.code_points.map(code_point => {
      packed_entry(data, code_point)
    })
    if mapping == full {
      mapping_lens.push(0)
    } else {
      mapping_lens.push(mapping.length())
      entries.append(mapping)
    }
  }
  guard canonical_lens.all(len => len <= 255) &&
    compat_lens.all(len => len <= 255) &&
    mapping_lens.all(len => len <= 255) else {
    fail("Decomposition length exceeds its encoded byte width")
  }
  let out = @emitter.Emitter::new()
  out.write_file_header("Decomposition mapping data", "UnicodeData.txt")
  out.write_int_array(
    "Start of each decomposition row's entries",
    "decomp_data_starts",
    starts,
    hex=false,
  )
  out.write_byte_array(
    "Length of the full canonical decomposition (0 for a compatibility mapping)",
    "decomp_canonical_lens", canonical_lens,
  )
  out.write_byte_array(
    "Length of the full compatibility decomposition (0 if it is the canonical one)",
    "decomp_compat_lens", compat_lens,
  )
  out.write_byte_array(
    "Length of the mapping itself (0 if it is the full decomposition)", "decomp_mapping_lens",
    mapping_lens,
  )
  out.write_int_array(
    "Packed entries: code point in bits 0..20, its CCC in bits 21..28",
    "decomp_data",
    entries,
    hex=true,
  )
  // Lets the lookup skip everything below the first character with a mapping.
  let first_decomposable = data.decompositions.fold(
    init=@emitter.MaxCodePoint + 1,
    (first, entry) => Int32::min(first, entry.code_point),
  )
  out.write(
    (
      $|///|
      $|/// The mapping of row `idx` itself, which is canonical when the row has
      $|/// a full canonical decomposition.
      $|fn mapping_entries(idx : Int) -> ArrayView[Int] {
      $|  let start = decomp_data_starts[idx]
      $|  let canonical_len = decomp_canonical_lens[idx].to_int()
      $|  let full_len = if canonical_len != 0 {
      $|    canonical_len
      $|  } else {
      $|    decomp_compat_lens[idx].to_int()
      $|  }
      $|  let mapping_len = decomp_mapping_lens[idx].to_int()
      $|  if mapping_len == 0 {
      $|    return decomp_data.exact_view(start~, end=start + full_len)
      $|  }
      $|  let mapping_start = start +
      $|    canonical_len +
      $|    decomp_compat_lens[idx].to_int()
      $|  decomp_data.exact_view(
      $|    start=mapping_start,
      $|    end=mapping_start + mapping_len,
      $|  )
      $|}
      $|
      $|///|
      $|fn unpack_code_points(entries : ArrayView[Int]) -> Array[Char] {
      $|  entries.map(entry => (entry & \{@emitter.hex_literal(DecompositionCodePointMask)}).unsafe_to_char())
      $|}
      $|
      $|///|
      $|/// Get canonical decomposition for a character
      $|/// Returns None if no decomposition exists
      $|pub fn get_canonical_decomposition(c : Char) -> Array[Char]? {
      $|  let idx = decomposition_row(@normalization_data.lookup_normalization_record(c))
      $|  if idx < 0 || decomp_canonical_lens[idx] == 0 {
      $|    return None
      $|  }
      $|  Some(unpack_code_points(mapping_entries(idx)))
      $|}
      $|
      $|///|
      $|/// Get compatibility decomposition for a character
      $|/// Returns None if no decomposition exists
      $|pub fn get_compat_decomposition(c : Char) -> Array[Char]? {
      $|  let idx = decomposition_row(@normalization_data.lookup_normalization_record(c))
      $|  if idx < 0 || decomp_canonical_lens[idx] != 0 {
      $|    return None
      $|  }
      $|  Some(unpack_code_points(mapping_entries(idx)))
      $|}
      $|
    ),
  )
  out.write(
    (
      $|///|
      $|pub using @normalization_data {lookup_normalization_record}
      $|
      $|///|
      $|/// The decomposition row of a character with normalization record
      $|/// `record`, or -1 without one.
      $|fn decomposition_row(record : Int) -> Int {
      $|  (record >> 16) - 1
      $|}
      $|
      $|///|
      $|/// The full decomposition of a character: its canonical mapping, or its
      $|/// compatibility mapping when asked for and present, applied
      $|/// recursively. `record` is the character's `lookup_normalization_record`,
      $|/// which tells where its decomposition is. Each entry packs a code point
      $|/// in bits 0..20 and its Canonical_Combining_Class in bits 21..28. The
      $|/// view is empty when the character has no such mapping.
      $|///
      $|/// Hangul syllables decompose algorithmically and have no mapping
      $|/// here.
      $|pub fn packed_decomposition(
      $|  record : Int,
      $|  compatibility~ : Bool,
      $|) -> ArrayView[Int] {
      $|  let idx = decomposition_row(record)
      $|  if idx < 0 {
      $|    return decomp_data.exact_view(start=0, end=0)
      $|  }
      $|  let start = decomp_data_starts[idx]
      $|  let canonical_len = decomp_canonical_lens[idx].to_int()
      $|  let compat_len = decomp_compat_lens[idx].to_int()
      $|  if compatibility && compat_len != 0 {
      $|    decomp_data.exact_view(
      $|      start=start + canonical_len,
      $|      end=start + canonical_len + compat_len,
      $|    )
      $|  } else {
      $|    // Empty for a compatibility mapping, which has no canonical part.
      $|    decomp_data.exact_view(start~, end=start + canonical_len)
      $|  }
      $|}
      $|
      $|///|
      $|/// Append the full decomposition of a character: its canonical mapping,
      $|/// or its compatibility mapping when asked for and present, applied
      $|/// recursively. A character without a mapping is appended as it is.
      $|///
      $|/// Hangul syllables decompose algorithmically and have no mapping
      $|/// here, so they are appended unchanged.
      $|pub fn append_decomposition(
      $|  c : Char,
      $|  dest : Array[Char],
      $|  compatibility~ : Bool,
      $|) -> Unit {
      $|  // No character below this one has a decomposition.
      $|  if c.to_int() < \{@emitter.hex_literal(first_decomposable)} {
      $|    dest.push(c)
      $|    return
      $|  }
      $|  let entries = packed_decomposition(
      $|    lookup_normalization_record(c),
      $|    compatibility~,
      $|  )
      $|  if entries.length() == 0 {
      $|    dest.push(c)
      $|    return
      $|  }
      $|  for entry in entries {
      $|    dest.push((entry & \{@emitter.hex_literal(DecompositionCodePointMask)}).unsafe_to_char())
      $|  }
      $|}
      $|
    ),
  )
  out.finish()
}

///|
/// Emit the canonical composition pairs and the full composition exclusions.
/// `exclusions` are the code points `CompositionExclusions.txt` lists.
pub fn emit_composition(
  data : UnicodeData,
  exclusions : Array[Int32],
) -> String {
  let compositions = build_composition_table(data, exclusions)
  let exclusions = build_full_composition_exclusions(data, exclusions)
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Composition lookup data", "UnicodeData.txt and CompositionExclusions.txt",
  )
  out.write_int_array(
    "Composition candidate group offsets, with an end sentinel",
    "comp_group_offsets",
    composition_group_offsets(compositions),
    hex=false,
  )
  out.write_int_array(
    "Second code points of composition pairs",
    "comp_seconds",
    compositions.map(entry => entry.second),
    hex=true,
  )
  out.write_int_array(
    "Composed result code points",
    "comp_results",
    compositions.map(entry => entry.result),
    hex=true,
  )
  out.write_int_array(
    "Composition exclusions (sorted for binary search)",
    "comp_exclusions",
    exclusions,
    hex=true,
  )
  out.write(
    (
      #|///|
      #|/// Look up composition for a pair of characters
      #|/// Returns Some(composed) if composition exists, None otherwise
      #|pub fn lookup_composition(starter : Char, combining : Char) -> Char? {
      #|  let group = @normalization_data.normalization_composition_group(starter)
      #|  if group < 0 {
      #|    return None
      #|  }
      #|  let combining_cp = combining.to_int()
      #|  // Search only this starter's candidates, not the global pair table.
      #|  let mut left = comp_group_offsets[group]
      #|  let mut right = comp_group_offsets[group + 1] - 1
      #|
      #|  while left <= right {
      #|    let mid = (left + right) / 2
      #|    let mid_second = comp_seconds[mid]
      #|
      #|    if combining_cp < mid_second {
      #|      right = mid - 1
      #|    } else if combining_cp > mid_second {
      #|      left = mid + 1
      #|    } else {
      #|      return Some(comp_results[mid].unsafe_to_char())
      #|    }
      #|  }
      #|
      #|  None
      #|}
      #|
      #|///|
      #|/// Check if a character is excluded from composition
      #|pub fn is_composition_excluded(c : Char) -> Bool {
      #|  find_composition_exclusion(c.to_int()) >= 0
      #|}
      #|
    ),
  )
  out.write_sorted_search(
    name="find_composition_exclusion",
    values="comp_exclusions",
  )
  out.finish()
}
