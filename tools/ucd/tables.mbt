///|
/// Collect the maximal runs of code points whose value satisfies `keep`.
fn ranges_where(
  values : FixedArray[Int32],
  keep : (Int32) -> Bool,
) -> Array[@parsing.CodePointRange] {
  let ranges : Array[@parsing.CodePointRange] = []
  for cp, value in values {
    if !keep(value) {
      continue
    }
    if ranges.last() is Some(range) && range.end + 1 == cp {
      ranges[ranges.length() - 1] = { start: range.start, end: cp, }
    } else {
      ranges.push({ start: cp, end: cp, })
    }
  }
  ranges
}

///|
fn contains_int(values : Array[Int32], target : Int32) -> Bool {
  values.any(value => value == target)
}

///|
fn build_composition_table(
  data : UnicodeData,
  exclusions : Array[Int32],
) -> Array[CompositionEntry] {
  let compositions : Array[CompositionEntry] = []
  for decomp in data.canonical_decompositions {
    if decomp.code_points.length() == 2 &&
      !contains_int(exclusions, decomp.code_point) {
      compositions.push({
        first: decomp.code_points[0],
        second: decomp.code_points[1],
        result: decomp.code_point,
      })
    }
  }
  compositions.sort_by((left, right) => {
    let first_order = left.first - right.first
    if first_order != 0 {
      first_order
    } else {
      left.second - right.second
    }
  })
  compositions
}

///|
fn build_full_composition_exclusions(
  data : UnicodeData,
  explicit_exclusions : Array[Int32],
) -> Array[Int32] {
  let exclusions = explicit_exclusions.copy()
  for decomp in data.canonical_decompositions {
    // Singletons and decompositions starting with a non-starter never
    // recompose.
    let excluded = match decomp.code_points {
      [_] => true
      [first, ..] => data.ccc[first] > 0
      [] => false
    }
    if excluded && !contains_int(exclusions, decomp.code_point) {
      exclusions.push(decomp.code_point)
    }
  }
  exclusions.sort()
  exclusions
}

///|
/// Shared row order for the decomposition arrays and norm16 record indices.
fn decomposition_entries(data : UnicodeData) -> Array[DecompositionEntry] {
  let entries = data.canonical_decompositions.copy()
  for compat in data.compatibility_decompositions {
    if entries.search_by(entry => entry.code_point == compat.code_point) is None {
      entries.push({ code_point: compat.code_point, code_points: [], })
    }
  }
  entries.sort_by((left, right) => left.code_point - right.code_point)
  entries
}

///|
/// Shared group order for norm16 records and the composition candidate table.
fn composition_group_offsets(
  compositions : Array[CompositionEntry],
) -> Array[Int32] {
  let offsets : Array[Int32] = []
  let mut previous = -1
  for index, entry in compositions {
    if entry.first != previous {
      offsets.push(index)
      previous = entry.first
    }
  }
  offsets.push(compositions.length())
  offsets
}
