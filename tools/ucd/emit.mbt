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
fn merged_full_mapping(
  simple : Array[SimpleMappingEntry],
  special : Array[FullMappingEntry],
) -> Array[FullMappingEntry] {
  let result : Array[FullMappingEntry] = []
  for entry in simple {
    result.push({ code_point: entry.code_point, targets: [entry.target], })
  }
  for entry in special {
    match
      result.search_by(existing => existing.code_point == entry.code_point) {
      Some(index) => result[index] = entry
      None => result.push(entry)
    }
  }
  result.sort_by((left, right) => left.code_point - right.code_point)
  result
}

///|
fn write_simple_case_arrays(
  out : @emitter.Emitter,
  name : String,
  mappings : Array[SimpleMappingEntry],
) -> Unit {
  let (mapping_label, target_label) = match name {
    "upper" => ("uppercase", "Uppercase")
    "lower" => ("lowercase", "Lowercase")
    "title" => ("titlecase", "Titlecase")
    _ => (name, name)
  }
  let sorted = mappings.copy()
  sorted.sort_by((left, right) => left.code_point - right.code_point)
  out.write_int_array(
    "Code points with " + mapping_label + " mappings (sorted for binary search)",
    name + "_cps",
    sorted.map(entry => entry.code_point),
    hex=true,
  )
  out.write_int_array(
    target_label + " mapping targets",
    name + "_targets",
    sorted.map(entry => entry.target),
    hex=true,
  )
}

///|
fn write_full_case_arrays(
  out : @emitter.Emitter,
  name : String,
  mappings : Array[FullMappingEntry],
) -> Unit {
  let sorted = mappings.copy()
  sorted.sort_by((left, right) => left.code_point - right.code_point)
  let starts : Array[Int] = []
  let lens : Array[Int] = []
  let data : Array[Int] = []
  for entry in sorted {
    starts.push(data.length())
    lens.push(entry.targets.length())
    data.append(entry.targets)
  }
  out.write_int_array(
    "Code points with full " + name + " mappings (sorted for binary search)",
    "full_" + name + "_cps",
    sorted.map(entry => entry.code_point),
    hex=true,
  )
  out.write_int_array(
    "Data start index for each full " + name + " mapping",
    "full_" + name + "_data_starts",
    starts,
    hex=false,
  )
  out.write_int_array(
    "Length of each full " + name + " mapping",
    "full_" + name + "_lens",
    lens,
    hex=false,
  )
  out.write_int_array(
    "Flattened full " + name + " mapping target code points",
    "full_" + name + "_data",
    data,
    hex=true,
  )
}

///|
pub fn emit_case_mapping(
  data : UnicodeData,
  special_casing : SpecialCasingData,
) -> String {
  let out = @emitter.Emitter::new()
  out.write_file_header("Simple case mapping lookup data", "UnicodeData.txt")
  write_simple_case_arrays(out, "upper", data.simple_uppercase)
  write_simple_case_arrays(out, "lower", data.simple_lowercase)
  write_simple_case_arrays(out, "title", data.simple_titlecase)
  out.write(
    (
      #|///|
      #|/// Binary search helper - returns index if found, -1 otherwise
      #|fn binary_search_case(arr : ReadOnlyArray[Int], cp : Int) -> Int {
      #|  let mut left = 0
      #|  let mut right = arr.length() - 1
      #|
      #|  while left <= right {
      #|    let mid = (left + right) / 2
      #|    let mid_cp = arr[mid]
      #|
      #|    if cp < mid_cp {
      #|      right = mid - 1
      #|    } else if cp > mid_cp {
      #|      left = mid + 1
      #|    } else {
      #|      return mid
      #|    }
      #|  }
      #|
      #|  -1
      #|}
      #|
      #|///|
      #|/// Look up simple uppercase mapping for a character
      #|/// Returns the character itself if no mapping exists
      #|pub fn lookup_simple_uppercase(c : Char) -> Char {
      #|  let cp = c.to_int()
      #|  let idx = binary_search_case(upper_cps, cp)
      #|  if idx >= 0 {
      #|    upper_targets[idx].unsafe_to_char()
      #|  } else {
      #|    c
      #|  }
      #|}
      #|
      #|///|
      #|/// Look up simple lowercase mapping for a character
      #|/// Returns the character itself if no mapping exists
      #|pub fn lookup_simple_lowercase(c : Char) -> Char {
      #|  let cp = c.to_int()
      #|  let idx = binary_search_case(lower_cps, cp)
      #|  if idx >= 0 {
      #|    lower_targets[idx].unsafe_to_char()
      #|  } else {
      #|    c
      #|  }
      #|}
      #|
      #|///|
      #|/// Look up simple titlecase mapping for a character
      #|/// Returns the character itself if no mapping exists
      #|pub fn lookup_simple_titlecase(c : Char) -> Char {
      #|  let cp = c.to_int()
      #|  let idx = binary_search_case(title_cps, cp)
      #|  if idx >= 0 {
      #|    title_targets[idx].unsafe_to_char()
      #|  } else {
      #|    c
      #|  }
      #|}
      #|
    ),
  )
  out.write("\n")
  write_full_case_arrays(
    out,
    "upper",
    merged_full_mapping(data.simple_uppercase, special_casing.upper_mapping),
  )
  write_full_case_arrays(
    out,
    "lower",
    merged_full_mapping(data.simple_lowercase, special_casing.lower_mapping),
  )
  write_full_case_arrays(
    out,
    "title",
    merged_full_mapping(data.simple_titlecase, special_casing.title_mapping),
  )
  out.write(
    (
      #|///|
      #|/// Look up full uppercase mapping for a character
      #|/// Returns Some(array of chars) if a mapping exists, None otherwise
      #|pub fn lookup_full_uppercase(c : Char) -> Array[Char]? {
      #|  let cp = c.to_int()
      #|  let idx = binary_search_case(full_upper_cps, cp)
      #|  if idx < 0 {
      #|    return None
      #|  }
      #|  let start = full_upper_data_starts[idx]
      #|  let len = full_upper_lens[idx]
      #|  let result : Array[Char] = []
      #|  for code_point in full_upper_data.exact_view(start=start, end=start + len) {
      #|    result.push(code_point.unsafe_to_char())
      #|  }
      #|  Some(result)
      #|}
      #|
      #|///|
      #|/// Look up full lowercase mapping for a character
      #|/// Returns Some(array of chars) if a mapping exists, None otherwise
      #|pub fn lookup_full_lowercase(c : Char) -> Array[Char]? {
      #|  let cp = c.to_int()
      #|  let idx = binary_search_case(full_lower_cps, cp)
      #|  if idx < 0 {
      #|    return None
      #|  }
      #|  let start = full_lower_data_starts[idx]
      #|  let len = full_lower_lens[idx]
      #|  let result : Array[Char] = []
      #|  for code_point in full_lower_data.exact_view(start=start, end=start + len) {
      #|    result.push(code_point.unsafe_to_char())
      #|  }
      #|  Some(result)
      #|}
      #|
      #|///|
      #|/// Look up full titlecase mapping for a character
      #|/// Returns Some(array of chars) if a mapping exists, None otherwise
      #|pub fn lookup_full_titlecase(c : Char) -> Array[Char]? {
      #|  let cp = c.to_int()
      #|  let idx = binary_search_case(full_title_cps, cp)
      #|  if idx < 0 {
      #|    return None
      #|  }
      #|  let start = full_title_data_starts[idx]
      #|  let len = full_title_lens[idx]
      #|  let result : Array[Char] = []
      #|  for code_point in full_title_data.exact_view(start=start, end=start + len) {
      #|    result.push(code_point.unsafe_to_char())
      #|  }
      #|  Some(result)
      #|}
      #|
    ),
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
