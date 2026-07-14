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

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "1" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{0061}\u{005B}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 0, 0, 1, 0, 0, 0, 0, 1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "2" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{0061}\u{005B}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 2, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "3" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0061}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 0, 0, 1, 0, 0, 1, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "4" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0061}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "5" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0061}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 0, 0, 1, 0, 0, 0, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "6" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0061}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "7" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0061}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 0, 0, 1, 0, 0, 0, 0, 1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "8" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0061}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "9" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 0, 1, 0]
  let expected_reorder = [5, 4, 3, 2, 1, 0, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "10" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "11" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 0, 0, 1]
  let expected_reorder = [5, 4, 3, 2, 1, 0, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "12" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "13" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0061}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 0, 0, 0, 1, 0, 1, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "14" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0061}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "15" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0061}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 0, 0, 0, 1, 0, 0, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "16" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0061}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "17" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0061}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 0, 0, 0, 1, 0, 0, 0, 1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "18" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0061}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "19" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 0, 1, 0]
  let expected_reorder = [5, 4, 3, 2, 1, 0, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "20" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "21" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 0, 0, 1]
  let expected_reorder = [5, 4, 3, 2, 1, 0, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "22" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "23" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{0029}\u{05D1}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 0, 1, 0]
  let expected_reorder = [5, 4, 3, 2, 1, 0, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "24" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{0029}\u{05D1}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "25" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{0029}\u{05D1}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 0, 0, 1]
  let expected_reorder = [5, 4, 3, 2, 1, 0, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "26" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{0029}\u{05D1}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "27" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{0061}\u{05D2}\u{005B}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 1, 0, 1, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "28" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{0061}\u{05D2}\u{005B}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 2, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "29" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{0061}\u{005B}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 1, 0, 0, 1, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "30" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{0061}\u{005B}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 2, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "31" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{0061}\u{005B}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 1, 0, 0, 0, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "32" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{0061}\u{005B}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 2, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "33" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{0061}\u{005B}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 1, 0, 0, 0, 0, 1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "34" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{0061}\u{005B}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 2, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "35" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0061}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 1, 0, 0, 1, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "36" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0061}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "37" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0061}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 1, 0, 0, 0, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "38" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0061}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "39" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0061}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 1, 0, 0, 0, 0, 1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "40" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0061}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "41" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 0, 1, 0]
  let expected_reorder = [0, 5, 4, 3, 2, 1, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "42" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "43" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 0, 0, 1]
  let expected_reorder = [0, 5, 4, 3, 2, 1, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "44" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "45" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0061}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 0, 1, 0, 1, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "46" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0061}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "47" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0061}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 0, 1, 0, 0, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "48" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0061}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "49" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0061}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 0, 1, 0, 0, 0, 1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "50" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0061}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "51" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 0, 1, 0]
  let expected_reorder = [0, 5, 4, 3, 2, 1, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "52" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "53" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 0, 0, 1]
  let expected_reorder = [0, 5, 4, 3, 2, 1, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "54" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "55" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{0029}\u{05D1}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 0, 1, 0]
  let expected_reorder = [0, 5, 4, 3, 2, 1, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "56" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{0029}\u{05D1}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "57" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{0029}\u{05D1}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 0, 0, 1]
  let expected_reorder = [0, 5, 4, 3, 2, 1, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "58" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{0029}\u{05D1}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "59" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0061}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 0, 1, 0, 0]
  let expected_reorder = [0, 1, 4, 3, 2, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "60" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0061}\u{05D2}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "61" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0061}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 0, 0, 1, 0]
  let expected_reorder = [0, 1, 4, 3, 2, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "62" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0061}\u{0029}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "63" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0061}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 0, 0, 0, 1]
  let expected_reorder = [0, 1, 4, 3, 2, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "64" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0061}\u{0029}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "65" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 0, 0, 1, 0]
  let expected_reorder = [0, 1, 4, 3, 2, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "66" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "67" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 0, 0, 0, 1]
  let expected_reorder = [0, 1, 4, 3, 2, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "68" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "69" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{0029}\u{05D1}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 0, 0, 1, 0, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "70" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{0029}\u{05D1}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "71" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{0029}\u{05D1}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 0, 0, 1, 0, 0, 1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "72" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{0029}\u{05D1}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "73" {
  let input = "\u{0028}\u{0028}\u{005B}\u{05D0}\u{0029}\u{05D1}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 0, 1, 0, 1, 0, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "74" {
  let input = "\u{0028}\u{0028}\u{005B}\u{05D0}\u{0029}\u{05D1}\u{0061}\u{05D2}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "75" {
  let input = "\u{0028}\u{0028}\u{005B}\u{05D0}\u{0029}\u{05D1}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 0, 1, 0, 1, 0, 0, 1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "76" {
  let input = "\u{0028}\u{0028}\u{005B}\u{05D0}\u{0029}\u{05D1}\u{0061}\u{005D}\u{05D2}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "77" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{2680}\u{005B}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [7, 6, 5, 4, 3, 2, 1, 0, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "78" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{2680}\u{005B}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "79" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{2680}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [7, 6, 5, 4, 3, 2, 1, 0, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "80" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{2680}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "81" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{2680}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "82" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{2680}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "83" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{005D}\u{2680}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "84" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{005D}\u{2680}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "85" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{2680}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [7, 6, 5, 4, 3, 2, 1, 0, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "86" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{2680}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "87" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{2680}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "88" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{2680}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "89" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{005D}\u{2680}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "90" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{005D}\u{2680}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "91" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "92" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "93" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "94" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "95" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{2680}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [7, 6, 5, 4, 3, 2, 1, 0, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "96" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{2680}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "97" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{2680}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "98" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{2680}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "99" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{2680}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "100" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{2680}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "101" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "102" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "103" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "104" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "105" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "106" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "107" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "108" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "109" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{2680}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 7, 6, 5, 4, 3, 2, 1, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "110" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{2680}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "111" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{2680}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "112" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{2680}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "113" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{2680}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "114" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{2680}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "115" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "116" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "117" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "118" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "119" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "120" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "121" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "122" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "123" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 0, 1, 0, 0]
  let expected_reorder = [0, 1, 4, 3, 2, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "124" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{2680}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "125" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 0, 1, 0, 0]
  let expected_reorder = [0, 1, 4, 3, 2, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "126" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{2680}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "127" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{0061}\u{005B}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 0, 1, 0, 0, 0, 0]
  let expected_reorder = [2, 1, 0, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "128" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{0061}\u{005B}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "129" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0061}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 0, 1, 0, 0, 0, 0]
  let expected_reorder = [2, 1, 0, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "130" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0061}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "131" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{0061}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "132" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{0061}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "133" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{005D}\u{0061}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "134" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{005D}\u{0061}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "135" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0061}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 0, 0, 1, 0, 0, 0]
  let expected_reorder = [2, 1, 0, 3, 4, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "136" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0061}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "137" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{0061}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "138" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{0061}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "139" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{005D}\u{0061}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "140" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{005D}\u{0061}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "141" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "142" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "143" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "144" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "145" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0061}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 0, 0, 1, 1, 1, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 5, 4, 3, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "146" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0061}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "147" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{0061}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "148" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{0061}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "149" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{0061}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "150" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{0061}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "151" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "152" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "153" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "154" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "155" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "156" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "157" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "158" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "159" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0061}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 0, 1, 1, 1, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 5, 4, 3, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "160" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0061}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "161" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{0061}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "162" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{0061}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "163" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{0061}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "164" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{0061}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "165" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "166" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "167" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "168" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "169" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "170" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "171" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 0, 0]
  let expected_reorder = [0, 6, 5, 4, 3, 2, 1, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "172" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "173" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 0, 1, 0, 0]
  let expected_reorder = [0, 1, 4, 3, 2, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "174" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{0061}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "175" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 0, 1, 0, 0]
  let expected_reorder = [0, 1, 4, 3, 2, 5, 6, 7, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "176" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{0061}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "177" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{05D3}\u{0029}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [7, 6, 5, 4, 3, 2, 1, 0, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "178" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{05D3}\u{0029}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "179" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{05D3}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [7, 6, 5, 4, 3, 2, 1, 0, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "180" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{05D3}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "181" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{005D}\u{05D3}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "182" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{05D2}\u{005B}\u{0029}\u{005D}\u{05D3}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "183" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{05D3}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [7, 6, 5, 4, 3, 2, 1, 0, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "184" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{05D3}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "185" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{005D}\u{05D3}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "186" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{05D2}\u{0029}\u{005D}\u{05D3}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "187" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "188" {
  let input = "\u{05D0}\u{0028}\u{05D1}\u{0028}\u{005B}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "189" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{05D3}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [7, 6, 5, 4, 3, 2, 1, 0, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "190" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{05D3}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "191" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{05D3}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "192" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{05D3}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "193" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "194" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "195" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "196" {
  let input = "\u{05D0}\u{0028}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "197" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{05D3}\u{005D}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 7, 6, 5, 4, 3, 2, 1, 8]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "198" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{05D3}\u{005D}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "199" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{05D3}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [0, 8, 7, 6, 5, 4, 3, 2, 1]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "200" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{05D2}\u{0029}\u{005D}\u{05D3}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "201" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [0, 8, 7, 6, 5, 4, 3, 2, 1]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "202" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{05D1}\u{005B}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "203" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [0, 8, 7, 6, 5, 4, 3, 2, 1]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "204" {
  let input = "\u{0028}\u{05D0}\u{0028}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "205" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 0
  let expected_base_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 0, 1, 1, 1]
  let expected_reorder = [0, 1, 4, 3, 2, 5, 8, 7, 6]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
///|
test "206" {
  let input = "\u{0028}\u{0028}\u{05D0}\u{005B}\u{05D1}\u{0029}\u{05D2}\u{005D}\u{05D3}"
  let para_dir = 1
  let expected_base_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = match para_dir {
    0 => @bidi.process_with_base_level(input, 0)
    1 => @bidi.process_with_base_level(input, 1)
    _ => @bidi.process(input)
  }

  assert_eq(result.base_level, expected_base_level)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      assert_eq(result.levels[index], expected_level)
    }
  }

  let actual_reorder = @bidi.reorder(result)
  assert_eq(actual_reorder.length(), expected_reorder.length())
  for index, expected_index in expected_reorder {
    assert_eq(actual_reorder[index], expected_index)
  }
}
