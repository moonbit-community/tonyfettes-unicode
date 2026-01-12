///|
/// Unicode Bidi Algorithm Conformance Tests - BidiCharacterTest.txt Part 183
/// Generated from BidiCharacterTest.txt (Unicode 16.0.0)
///
/// Tests the implementation with actual Unicode characters including
/// bracket pairs and other character-specific behaviors.

///|
test "0" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{0061}\u{005B}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 2, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "1" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{0061}\u{005B}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 0, 0, 1, 0, 0, 0, 0, 1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "2" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{0061}\u{005B}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 2, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "3" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0061}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 0, 0, 1, 0, 0, 1, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "4" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0061}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "5" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0061}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 0, 0, 1, 0, 0, 0, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "6" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0061}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "7" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0061}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 0, 0, 1, 0, 0, 0, 0, 1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "8" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0061}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "9" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 0, 1, 0]
  let expected_reorder = [5, 4, 3, 2, 1, 0, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "10" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "11" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 0, 0, 1]
  let expected_reorder = [5, 4, 3, 2, 1, 0, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "12" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "13" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0061}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 0, 0, 0, 1, 0, 1, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "14" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0061}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "15" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0061}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 0, 0, 0, 1, 0, 0, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "16" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0061}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "17" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0061}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 0, 0, 0, 1, 0, 0, 0, 1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "18" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0061}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "19" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 0, 1, 0]
  let expected_reorder = [5, 4, 3, 2, 1, 0, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "20" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "21" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 0, 0, 1]
  let expected_reorder = [5, 4, 3, 2, 1, 0, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "22" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "23" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{0029}\u{05D1}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 0, 1, 0]
  let expected_reorder = [5, 4, 3, 2, 1, 0, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "24" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{0029}\u{05D1}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "25" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{0029}\u{05D1}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 0, 0, 1]
  let expected_reorder = [5, 4, 3, 2, 1, 0, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "26" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{0029}\u{05D1}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "27" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{0061}\u{05D2}\u{005B}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 1, 0, 1, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "28" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{0061}\u{05D2}\u{005B}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 2, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "29" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{0061}\u{005B}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 1, 0, 0, 1, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "30" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{0061}\u{005B}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 2, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "31" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{0061}\u{005B}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 1, 0, 0, 0, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "32" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{0061}\u{005B}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 2, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "33" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{0061}\u{005B}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 1, 0, 0, 0, 0, 1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "34" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{0061}\u{005B}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 2, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "35" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0061}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 1, 0, 0, 1, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "36" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0061}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "37" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0061}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 1, 0, 0, 0, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "38" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0061}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "39" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0061}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 1, 0, 0, 0, 0, 1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "40" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0061}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "41" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 0, 1, 0]
  let expected_reorder = [0, 5, 4, 3, 2, 1, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "42" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "43" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 0, 0, 1]
  let expected_reorder = [0, 5, 4, 3, 2, 1, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "44" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "45" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0061}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 0, 1, 0, 1, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "46" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0061}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "47" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0061}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 0, 1, 0, 0, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "48" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0061}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "49" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0061}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 0, 1, 0, 0, 0, 1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "50" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0061}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "51" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 0, 1, 0]
  let expected_reorder = [0, 5, 4, 3, 2, 1, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "52" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "53" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 0, 0, 1]
  let expected_reorder = [0, 5, 4, 3, 2, 1, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "54" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "55" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{0029}\u{05D1}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 0, 1, 0]
  let expected_reorder = [0, 5, 4, 3, 2, 1, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "56" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{0029}\u{05D1}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "57" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{0029}\u{05D1}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 0, 0, 1]
  let expected_reorder = [0, 5, 4, 3, 2, 1, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "58" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{0029}\u{05D1}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "59" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0061}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 0, 1, 0, 0]
  let expected_reorder = [0, 1, 4, 3, 2, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "60" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0061}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "61" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0061}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 0, 0, 1, 0]
  let expected_reorder = [0, 1, 4, 3, 2, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "62" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0061}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "63" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0061}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 0, 0, 0, 1]
  let expected_reorder = [0, 1, 4, 3, 2, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "64" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0061}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "65" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 0, 0, 1, 0]
  let expected_reorder = [0, 1, 4, 3, 2, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "66" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "67" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 0, 0, 0, 1]
  let expected_reorder = [0, 1, 4, 3, 2, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "68" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "69" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{0029}\u{05D1}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 0, 0, 1, 0, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "70" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{0029}\u{05D1}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "71" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{0029}\u{05D1}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 0, 0, 1, 0, 0, 1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "72" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{0029}\u{05D1}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "73" {
  let input = "\u{0028}\u{0028}\u{005B}\u{05D0}\u{0029}\u{05D1}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 0, 1, 0, 1, 0, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "74" {
  let input = "\u{0028}\u{0028}\u{005B}\u{05D0}\u{0029}\u{05D1}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "75" {
  let input = "\u{0028}\u{0028}\u{005B}\u{05D0}\u{0029}\u{05D1}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 0, 1, 0, 1, 0, 0, 1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "76" {
  let input = "\u{0028}\u{0028}\u{005B}\u{05D0}\u{0029}\u{05D1}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "77" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{2680}\u{005B}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [7, 6, 5, 4, 3, 2, 1, 0, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "78" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{2680}\u{005B}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "79" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{2680}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [7, 6, 5, 4, 3, 2, 1, 0, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "80" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{2680}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "81" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{2680}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "82" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{2680}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "83" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{005D}\u{2680}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "84" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{005D}\u{2680}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "85" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{2680}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [7, 6, 5, 4, 3, 2, 1, 0, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "86" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{2680}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "87" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{2680}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "88" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{2680}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "89" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{005D}\u{2680}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "90" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{005D}\u{2680}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "91" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "92" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "93" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "94" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "95" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{2680}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [7, 6, 5, 4, 3, 2, 1, 0, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "96" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{2680}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "97" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{2680}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "98" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{2680}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "99" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{2680}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "100" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{2680}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "101" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "102" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "103" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "104" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "105" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "106" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "107" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "108" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "109" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{2680}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 7, 6, 5, 4, 3, 2, 1, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "110" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{2680}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "111" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{2680}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "112" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{2680}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "113" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{2680}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "114" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{2680}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "115" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "116" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "117" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "118" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "119" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "120" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "121" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "122" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "123" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 0, 1, 0, 0]
  let expected_reorder = [0, 1, 4, 3, 2, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "124" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "125" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 0, 1, 0, 0]
  let expected_reorder = [0, 1, 4, 3, 2, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "126" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "127" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{0061}\u{005B}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 0, 1, 0, 0, 0, 0]
  let expected_reorder = [2, 1, 0, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "128" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{0061}\u{005B}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "129" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0061}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 0, 1, 0, 0, 0, 0]
  let expected_reorder = [2, 1, 0, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "130" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0061}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "131" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{0061}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "132" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{0061}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "133" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{005D}\u{0061}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "134" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{005D}\u{0061}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "135" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0061}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 0, 0, 1, 0, 0, 0]
  let expected_reorder = [2, 1, 0, 3, 4, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "136" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0061}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "137" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{0061}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "138" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{0061}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "139" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{005D}\u{0061}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "140" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{005D}\u{0061}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "141" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "142" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "143" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "144" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "145" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0061}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 0, 0, 1, 1, 1, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 5, 4, 3, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "146" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0061}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "147" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{0061}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "148" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{0061}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "149" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{0061}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "150" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{0061}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "151" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "152" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "153" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "154" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "155" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "156" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "157" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "158" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "159" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0061}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 1, 1, 1, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 5, 4, 3, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "160" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0061}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "161" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{0061}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "162" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{0061}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "163" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{0061}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "164" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{0061}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "165" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "166" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "167" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "168" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "169" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "170" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "171" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "172" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "173" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 0, 1, 0, 0]
  let expected_reorder = [0, 1, 4, 3, 2, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "174" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "175" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 0, 1, 0, 0]
  let expected_reorder = [0, 1, 4, 3, 2, 5, 6, 7, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "176" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "177" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{05D3}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [7, 6, 5, 4, 3, 2, 1, 0, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "178" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{05D3}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "179" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{05D3}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [7, 6, 5, 4, 3, 2, 1, 0, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "180" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{05D3}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "181" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{005D}\u{05D3}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "182" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{005D}\u{05D3}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "183" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{05D3}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [7, 6, 5, 4, 3, 2, 1, 0, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "184" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{05D3}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "185" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{005D}\u{05D3}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "186" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{005D}\u{05D3}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "187" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "188" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "189" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{05D3}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [7, 6, 5, 4, 3, 2, 1, 0, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "190" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{05D3}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "191" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{05D3}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "192" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{05D3}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "193" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "194" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "195" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "196" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "197" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{05D3}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 7, 6, 5, 4, 3, 2, 1, 8]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "198" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{05D3}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "199" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{05D3}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [0, 8, 7, 6, 5, 4, 3, 2, 1]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "200" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{05D3}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "201" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [0, 8, 7, 6, 5, 4, 3, 2, 1]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "202" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "203" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [0, 8, 7, 6, 5, 4, 3, 2, 1]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "204" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "205" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 0, 1, 1, 1]
  let expected_reorder = [0, 1, 4, 3, 2, 5, 8, 7, 6]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

///|
test "206" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  // Process with appropriate paragraph direction
  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)  // LTR
    1 => @bidi.process_with_base_level(input, 1)  // RTL
    _ => @bidi.process(input)                      // Auto
  }

  // Verify base level
  assert_eq(result.base_level, expected_base_level)

  // Verify levels (skip 'x' positions marked as -1)
  for j = 0; j < expected_levels.length(); j = j + 1 {
    if expected_levels[j] >= 0 {
      assert_eq(result.levels[j], expected_levels[j])
    }
  }

  // Verify reordering
  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for j = 0; j < expected_reorder.length(); j = j + 1 {
    assert_eq(actual_reorder[j], expected_reorder[j])
  }
}

