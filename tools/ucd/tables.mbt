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
fn build_composition_table(
  data : UnicodeData,
  exclusions : Array[Int32],
) -> Array[CompositionEntry] {
  let compositions : Array[CompositionEntry] = []
  for decomp in data.decompositions {
    if !decomp.compatibility &&
      decomp.code_points.length() == 2 &&
      !exclusions.contains(decomp.code_point) {
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
  for decomp in data.decompositions {
    if decomp.compatibility {
      continue
    }
    // Singletons and decompositions starting with a non-starter never
    // recompose.
    let excluded = match decomp.code_points {
      [_] => true
      [first, ..] => data.ccc[first] > 0
      [] => false
    }
    if excluded && !exclusions.contains(decomp.code_point) {
      exclusions.push(decomp.code_point)
    }
  }
  exclusions.sort()
  exclusions
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
