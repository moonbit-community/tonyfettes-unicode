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
pub fn emit_xid(properties : DerivedCoreProperties) -> String raise {
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "XID_Start and XID_Continue lookup data", "DerivedCoreProperties.txt",
  )
  write_binary_property_trie(out, property="XID_Start", properties.xid_start)
  write_binary_property_trie(
    out,
    property="XID_Continue",
    properties.xid_continue,
  )
  out.finish()
}

///|
pub fn emit_decomposition(data : UnicodeData) -> String raise {
  let entries = decomposition_entries(data)
  let starts : Array[Int] = []
  let canonical_lens : Array[Int] = []
  let compat_lens : Array[Int] = []
  let flattened : Array[Int] = []
  for entry in entries {
    starts.push(flattened.length())
    match
      data.canonical_decompositions.search_by(item => {
        item.code_point == entry.code_point
      }) {
      Some(index) => {
        let canonical = data.canonical_decompositions[index].code_points
        canonical_lens.push(canonical.length())
        flattened.append(canonical)
      }
      None => canonical_lens.push(0)
    }
    match
      data.compatibility_decompositions.search_by(item => {
        item.code_point == entry.code_point
      }) {
      Some(index) => {
        let compat = data.compatibility_decompositions[index].code_points
        compat_lens.push(compat.length())
        flattened.append(compat)
      }
      None => compat_lens.push(0)
    }
  }
  guard canonical_lens.iter().all(len => len <= 255) &&
    compat_lens.iter().all(len => len <= 255) else {
    fail("Decomposition length exceeds its encoded byte width")
  }
  let out = @emitter.Emitter::new()
  out.write_file_header("Decomposition mapping data", "UnicodeData.txt")
  out.write_int_array(
    "Data start index for each code point",
    "decomp_data_starts",
    starts,
    hex=false,
  )
  out.write_byte_array(
    "Canonical decomposition length (0 if none)", "decomp_canonical_lens", canonical_lens,
  )
  out.write_byte_array(
    "Compatibility decomposition length (0 if none)", "decomp_compat_lens", compat_lens,
  )
  out.write_int_array(
    "Decomposition data (flattened code points)",
    "decomp_data",
    flattened,
    hex=true,
  )
  out.write(
    (
      #|///|
      #|/// Get canonical decomposition for a character
      #|/// Returns None if no decomposition exists
      #|pub fn get_canonical_decomposition(c : Char) -> Array[Char]? {
      #|  let idx = @normalization_data.normalization_decomposition_index(c)
      #|  if idx < 0 {
      #|    return None
      #|  }
      #|
      #|  let len = decomp_canonical_lens[idx].to_int()
      #|  if len == 0 {
      #|    return None
      #|  }
      #|
      #|  let start = decomp_data_starts[idx]
      #|  let result : Array[Char] = []
      #|  for code_point in decomp_data.exact_view(start=start, end=start + len) {
      #|    result.push(code_point.unsafe_to_char())
      #|  }
      #|  Some(result)
      #|}
      #|
      #|///|
      #|/// Get compatibility decomposition for a character
      #|/// Returns None if no decomposition exists
      #|pub fn get_compat_decomposition(c : Char) -> Array[Char]? {
      #|  let idx = @normalization_data.normalization_decomposition_index(c)
      #|  if idx < 0 {
      #|    return None
      #|  }
      #|
      #|  let compat_len = decomp_compat_lens[idx].to_int()
      #|  if compat_len == 0 {
      #|    return None
      #|  }
      #|
      #|  // Compat data comes after canonical data
      #|  let canonical_len = decomp_canonical_lens[idx].to_int()
      #|  let start = decomp_data_starts[idx] + canonical_len
      #|  let result : Array[Char] = []
      #|  for code_point in decomp_data.exact_view(
      #|    start=start,
      #|    end=start + compat_len,
      #|  ) {
      #|    result.push(code_point.unsafe_to_char())
      #|  }
      #|  Some(result)
      #|}
      #|
    ),
  )
  // Lets the lookup skip everything below the first character with a mapping.
  let first_decomposable = entries.fold(init=MaxCodePoint + 1, (first, entry) => {
    Int::min(first, entry.code_point)
  })
  out.write(
    (
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
      $|  if c.to_int() < \{hex_literal(first_decomposable)} {
      $|    dest.push(c)
      $|    return
      $|  }
      $|  let idx = @normalization_data.normalization_decomposition_index(c)
      $|  if idx < 0 {
      $|    dest.push(c)
      $|    return
      $|  }
      $|  let canonical_len = decomp_canonical_lens[idx].to_int()
      $|  let compat_len = decomp_compat_lens[idx].to_int()
      $|  let use_compat = compatibility && compat_len != 0
      $|  // Compat data comes after canonical data
      $|  let start = if use_compat {
      $|    decomp_data_starts[idx] + canonical_len
      $|  } else {
      $|    decomp_data_starts[idx]
      $|  }
      $|  let len = if use_compat { compat_len } else { canonical_len }
      $|  if len == 0 {
      $|    dest.push(c)
      $|    return
      $|  }
      $|  for i in start..<(start + len) {
      $|    append_decomposition(decomp_data[i].unsafe_to_char(), dest, compatibility~)
      $|  }
      $|}
      $|
    ),
  )
  out.finish()
}

///|
pub fn emit_composition(
  compositions : Array[CompositionEntry],
  exclusions : Array[Int],
) -> String {
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
      #|  let cp = c.to_int()
      #|  // Binary search in exclusions
      #|  let mut left = 0
      #|  let mut right = comp_exclusions.length() - 1
      #|
      #|  while left <= right {
      #|    let mid = (left + right) / 2
      #|    let mid_cp = comp_exclusions[mid]
      #|
      #|    if cp < mid_cp {
      #|      right = mid - 1
      #|    } else if cp > mid_cp {
      #|      left = mid + 1
      #|    } else {
      #|      return true
      #|    }
      #|  }
      #|
      #|  false
      #|}
      #|
    ),
  )
  out.finish()
}
