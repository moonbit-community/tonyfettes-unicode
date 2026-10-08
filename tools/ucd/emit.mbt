///|
pub fn emit_ccc(ccc_ranges : Array[CccRange]) -> String {
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Canonical Combining Class (CCC) lookup data", "UnicodeData.txt",
  )
  out.write_int_array(
    "CCC range start code points",
    "ccc_starts",
    ccc_ranges.map(range => range.start),
    hex=true,
  )
  out.write_int_array(
    "CCC range end code points (inclusive)",
    "ccc_ends",
    ccc_ranges.map(range => range.end),
    hex=true,
  )
  out.write_int_array(
    "CCC values for each range",
    "ccc_values",
    ccc_ranges.map(range => range.value),
    hex=false,
  )
  out.write(
    (
      #|///|
      #|/// Look up Canonical Combining Class for a character
      #|/// Returns 0 (starter) for most characters
      #|pub fn lookup_ccc(c : Char) -> Int {
      #|  let cp = c.to_int()
      #|  // Binary search through ranges
      #|  let mut left = 0
      #|  let mut right = ccc_starts.length() - 1
      #|
      #|  while left <= right {
      #|    let mid = (left + right) / 2
      #|    let start = ccc_starts[mid]
      #|    let end = ccc_ends[mid]
      #|
      #|    if cp < start {
      #|      right = mid - 1
      #|    } else if cp > end {
      #|      left = mid + 1
      #|    } else {
      #|      return ccc_values[mid]
      #|    }
      #|  }
      #|
      #|  0 // Not found, default CCC is 0 (starter)
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
pub fn emit_decomposition(data : UnicodeData) -> String {
  // The low bit distinguishes canonical (0) from compatibility (1).
  let entries : Array[(Int, Array[Int])] = []
  for entry in data.canonical_decompositions {
    entries.push((entry.code_point << 1, entry.code_points))
  }
  for entry in data.compatibility_decompositions {
    entries.push(((entry.code_point << 1) | 1, entry.code_points))
  }
  entries.sort_by((left, right) => left.0 - right.0)
  let keys : Array[Int] = []
  let offsets : Array[Int] = [0]
  let flattened : Array[Int] = []
  for (key, code_points) in entries {
    keys.push(key)
    flattened.append(code_points)
    offsets.push(flattened.length())
  }
  let out = @emitter.Emitter::new()
  out.write_file_header("Decomposition mapping data", "UnicodeData.txt")
  out.write_int_array(
    "Sorted keys: `code_point << 1 | kind` (canonical = 0, compatibility = 1)",
    "decomp_keys",
    keys,
    hex=true,
  )
  out.write_int_array(
    "Data offsets, including a final sentinel; mapping i is offsets[i]..<offsets[i + 1]",
    "decomp_offsets",
    offsets,
    hex=false,
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
      #|/// Look up an exact (code point, decomposition kind) key.
      #|fn get_decomposition(key : Int) -> Array[Char]? {
      #|  let mut left = 0
      #|  let mut right = decomp_keys.length() - 1
      #|  while left <= right {
      #|    let mid = (left + right) / 2
      #|    let mid_key = decomp_keys[mid]
      #|    if key < mid_key {
      #|      right = mid - 1
      #|    } else if key > mid_key {
      #|      left = mid + 1
      #|    } else {
      #|      let start = decomp_offsets[mid]
      #|      let end = decomp_offsets[mid + 1]
      #|      let result : Array[Char] = []
      #|      for code_point in decomp_data.exact_view(start=start, end=end) {
      #|        result.push(code_point.unsafe_to_char())
      #|      }
      #|      return Some(result)
      #|    }
      #|  }
      #|  None
      #|}
      #|
      #|///|
      #|/// Get canonical decomposition for a character
      #|/// Returns None if no decomposition exists
      #|pub fn get_canonical_decomposition(c : Char) -> Array[Char]? {
      #|  get_decomposition(c.to_int() << 1)
      #|}
      #|
      #|///|
      #|/// Get compatibility decomposition for a character
      #|/// Returns None if no decomposition exists
      #|pub fn get_compat_decomposition(c : Char) -> Array[Char]? {
      #|  get_decomposition((c.to_int() << 1) | 1)
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
    "First code points of composition pairs (sorted)",
    "comp_firsts",
    compositions.map(entry => entry.first),
    hex=true,
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
      #|  let starter_cp = starter.to_int()
      #|  let combining_cp = combining.to_int()
      #|  // Binary search for the pair
      #|  let mut left = 0
      #|  let mut right = comp_firsts.length() - 1
      #|
      #|  while left <= right {
      #|    let mid = (left + right) / 2
      #|    let mid_first = comp_firsts[mid]
      #|    let mid_second = comp_seconds[mid]
      #|
      #|    if starter_cp < mid_first ||
      #|      (starter_cp == mid_first && combining_cp < mid_second) {
      #|      right = mid - 1
      #|    } else if starter_cp > mid_first ||
      #|      (starter_cp == mid_first && combining_cp > mid_second) {
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
