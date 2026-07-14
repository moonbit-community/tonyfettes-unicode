///|
/// Unicode Bidi Algorithm Conformance Tests - BidiTest.txt Part 1540
/// Generated from BidiTest.txt (Unicode 16.0.0)
///
/// Tests the implementation against official Unicode bidi test data.
/// Each test verifies resolved embedding levels and visual reordering.
///|
test "0" {
  let input = "\u{2068}\u{0021}\u{202B}\u{0061}\u{202C}\u{05D0}\u{2069}"
  let para_level = 0
  let expected_levels = [0, 2, -1, 4, -1, 3, 0]
  let expected_reorder = [0, 1, 5, 3, 6]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2068}\u{0021}\u{0660}\u{0061}\u{05D0}\u{2069}"
  let para_level = 1
  let expected_levels = [1, 2, 4, 2, 3, 1]
  let expected_reorder = [5, 1, 2, 3, 4, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2068}\u{0021}\u{202E}\u{0061}\u{202C}\u{05D0}\u{2069}"
  let para_level = 1
  let expected_levels = [1, 2, -1, 3, -1, 3, 1]
  let expected_reorder = [6, 1, 5, 3, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2068}\u{0021}\u{202B}\u{0061}\u{202C}\u{05D0}\u{2069}"
  let para_level = 1
  let expected_levels = [1, 2, -1, 4, -1, 3, 1]
  let expected_reorder = [6, 1, 5, 3, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2068}\u{0021}\u{0030}\u{05D0}\u{0061}\u{2069}"
  let para_level = 1
  let expected_levels = [1, 3, 4, 3, 4, 1]
  let expected_reorder = [5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2068}\u{0021}\u{202D}\u{05D0}\u{202C}\u{0061}\u{2069}"
  let para_level = 1
  let expected_levels = [1, 3, -1, 4, -1, 4, 1]
  let expected_reorder = [6, 3, 5, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2068}\u{0021}\u{202A}\u{05D0}\u{202C}\u{0061}\u{2069}"
  let para_level = 1
  let expected_levels = [1, 3, -1, 5, -1, 4, 1]
  let expected_reorder = [6, 3, 5, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{05D0}\u{05D0}\u{0020}\u{0024}\u{0030}\u{0030}"
  let para_level = -1
  let expected_levels = [1, 1, 1, 1, 2, 2, 2]
  let expected_reorder = [4, 5, 6, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{05D0}\u{05D0}\u{0020}\u{0024}\u{0030}\u{0030}"
  let para_level = 0
  let expected_levels = [1, 1, 1, 1, 2, 2, 2]
  let expected_reorder = [4, 5, 6, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{05D0}\u{05D0}\u{0020}\u{0024}\u{0030}\u{0030}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 1, 2, 2, 2]
  let expected_reorder = [4, 5, 6, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{05D0}"
  let para_level = 0
  let expected_levels = [0, 0, 2, 0, 0, 2, 0, 1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{05D0}"
  let para_level = -1
  let expected_levels = [1, 1, 2, 1, 1, 2, 1, 1]
  let expected_reorder = [7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{05D0}"
  let para_level = 1
  let expected_levels = [1, 1, 2, 1, 1, 2, 1, 1]
  let expected_reorder = [7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{2068}\u{05D0}\u{0627}\u{2069}\u{2067}\u{05D0}\u{0627}\u{2069}"
  let para_level = -1
  let expected_levels = [0, 0, 1, 1, 0, 0, 1, 1, 0]
  let expected_reorder = [0, 1, 3, 2, 4, 5, 7, 6, 8]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{2068}\u{05D0}\u{0627}\u{2069}\u{2067}\u{05D0}\u{0627}\u{2069}"
  let para_level = 0
  let expected_levels = [0, 0, 1, 1, 0, 0, 1, 1, 0]
  let expected_reorder = [0, 1, 3, 2, 4, 5, 7, 6, 8]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{2068}\u{05D0}\u{0627}\u{2069}\u{2067}\u{05D0}\u{0627}\u{2069}"
  let para_level = 1
  let expected_levels = [1, 1, 3, 3, 1, 1, 3, 3, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0024}\u{2066}\u{2069}\u{0030}\u{2067}\u{2069}\u{0024}\u{2068}\u{2069}\u{0030}"
  let para_level = -1
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0024}\u{2066}\u{2069}\u{0030}\u{2067}\u{2069}\u{0024}\u{2068}\u{2069}\u{0030}"
  let para_level = 0
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2068}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{05D0}\u{2069}"
  let para_level = -1
  let expected_levels = [0, 1, 1, 2, 1, 1, 2, 1, 1, 0]
  let expected_reorder = [0, 8, 7, 6, 5, 4, 3, 2, 1, 9]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2068}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{05D0}\u{2069}"
  let para_level = 0
  let expected_levels = [0, 1, 1, 2, 1, 1, 2, 1, 1, 0]
  let expected_reorder = [0, 8, 7, 6, 5, 4, 3, 2, 1, 9]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2068}\u{0021}\u{2068}\u{05D0}\u{2069}\u{2067}\u{05D0}\u{2069}\u{0061}\u{2069}"
  let para_level = -1
  let expected_levels = [0, 2, 2, 3, 2, 2, 3, 2, 2, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2068}\u{0021}\u{2068}\u{05D0}\u{2069}\u{2067}\u{05D0}\u{2069}\u{0061}\u{2069}"
  let para_level = 0
  let expected_levels = [0, 2, 2, 3, 2, 2, 3, 2, 2, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0024}\u{2066}\u{2069}\u{0030}\u{2067}\u{2069}\u{0024}\u{2068}\u{2069}\u{0030}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 2, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2068}\u{0021}\u{2068}\u{05D0}\u{2069}\u{2067}\u{05D0}\u{2069}\u{0061}\u{2069}"
  let para_level = 1
  let expected_levels = [1, 2, 2, 3, 2, 2, 3, 2, 2, 1]
  let expected_reorder = [9, 1, 2, 3, 4, 5, 6, 7, 8, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2068}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{05D0}\u{2069}"
  let para_level = 1
  let expected_levels = [1, 3, 3, 4, 3, 3, 4, 3, 3, 1]
  let expected_reorder = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202A}\u{0021}\u{202B}\u{0021}\u{202D}\u{05D0}\u{202E}\u{0061}\u{2069}\u{0061}\u{202C}\u{05D0}"
  let para_level = 0
  let expected_levels = [0, -1, 2, -1, 3, -1, 4, -1, 5, 5, 5, -1, 4]
  let expected_reorder = [0, 2, 6, 10, 9, 8, 12, 4]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202A}\u{0021}\u{202B}\u{0021}\u{202D}\u{05D0}\u{202E}\u{0061}\u{2069}\u{0061}\u{202C}\u{05D0}"
  let para_level = -1
  let expected_levels = [1, -1, 2, -1, 3, -1, 4, -1, 5, 5, 5, -1, 4]
  let expected_reorder = [2, 6, 10, 9, 8, 12, 4, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202A}\u{0021}\u{202B}\u{0021}\u{202D}\u{05D0}\u{202E}\u{0061}\u{2069}\u{0061}\u{202C}\u{05D0}"
  let para_level = 1
  let expected_levels = [1, -1, 2, -1, 3, -1, 4, -1, 5, 5, 5, -1, 4]
  let expected_reorder = [2, 6, 10, 9, 8, 12, 4, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{0030}\u{0030}\u{0021}\u{0020}\u{0627}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0627}"
  let para_level = 0
  let expected_levels = [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [0, 1, 2, 3, 4, 10, 9, 8, 7, 6, 5]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{2066}\u{05D0}\u{2069}\u{2068}\u{05D0}\u{2069}\u{2067}\u{05D0}\u{2069}\u{05D0}"
  let para_level = -1
  let expected_levels = [0, 0, 3, 0, 0, 1, 0, 0, 1, 0, 1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{2066}\u{05D0}\u{2069}\u{2068}\u{05D0}\u{2069}\u{2067}\u{05D0}\u{2069}\u{05D0}"
  let para_level = 0
  let expected_levels = [0, 0, 3, 0, 0, 1, 0, 0, 1, 0, 1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0061}"
  let para_level = 0
  let expected_levels = [1, 0, 2, 0, 0, 2, 0, 0, 2, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0030}\u{0030}\u{0021}"
  let para_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 0]
  let expected_reorder = [8, 9, 7, 6, 5, 4, 3, 2, 1, 0, 10]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0030}\u{0030}\u{0021}"
  let para_level = -1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1]
  let expected_reorder = [10, 8, 9, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0030}\u{0030}\u{0021}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1]
  let expected_reorder = [10, 8, 9, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0061}"
  let para_level = -1
  let expected_levels = [1, 1, 2, 1, 1, 2, 1, 1, 4, 1, 2]
  let expected_reorder = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0061}"
  let para_level = 1
  let expected_levels = [1, 1, 2, 1, 1, 2, 1, 1, 4, 1, 2]
  let expected_reorder = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{0030}\u{0030}\u{0021}\u{0020}\u{0627}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0627}"
  let para_level = -1
  let expected_levels = [1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [10, 9, 8, 7, 6, 5, 4, 3, 1, 2, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{0030}\u{0030}\u{0021}\u{0020}\u{0627}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0627}"
  let para_level = 1
  let expected_levels = [1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [10, 9, 8, 7, 6, 5, 4, 3, 1, 2, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{2066}\u{05D0}\u{2069}\u{2068}\u{05D0}\u{2069}\u{2067}\u{05D0}\u{2069}\u{05D0}"
  let para_level = 1
  let expected_levels = [2, 1, 3, 1, 1, 3, 1, 1, 3, 1, 1]
  let expected_reorder = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202B}\u{202A}\u{202E}\u{202D}\u{2067}\u{0021}\u{202D}\u{05D0}\u{202C}\u{0021}\u{202C}\u{0021}\u{2069}\u{05D0}"
  let para_level = 0
  let expected_levels = [-1, -1, -1, -1, 4, 5, -1, 6, -1, 5, -1, 5, 4, 4]
  let expected_reorder = [4, 11, 9, 7, 5, 12, 13]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202B}\u{202A}\u{202E}\u{202D}\u{2068}\u{05D0}\u{202D}\u{05D0}\u{202C}\u{0021}\u{202C}\u{0021}\u{2069}\u{05D0}"
  let para_level = 0
  let expected_levels = [-1, -1, -1, -1, 4, 5, -1, 6, -1, 5, -1, 5, 4, 4]
  let expected_reorder = [4, 11, 9, 7, 5, 12, 13]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202A}\u{202B}\u{202D}\u{202E}\u{2066}\u{0021}\u{202E}\u{0061}\u{202C}\u{0021}\u{202C}\u{0021}\u{2069}\u{0061}"
  let para_level = -1
  let expected_levels = [-1, -1, -1, -1, 5, 6, -1, 7, -1, 6, -1, 6, 5, 5]
  let expected_reorder = [13, 12, 5, 7, 9, 11, 4]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202A}\u{202B}\u{202D}\u{202E}\u{2066}\u{0021}\u{202E}\u{0061}\u{202C}\u{0021}\u{202C}\u{0021}\u{2069}\u{0061}"
  let para_level = 0
  let expected_levels = [-1, -1, -1, -1, 5, 6, -1, 7, -1, 6, -1, 6, 5, 5]
  let expected_reorder = [13, 12, 5, 7, 9, 11, 4]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202A}\u{202B}\u{202D}\u{202E}\u{2066}\u{0021}\u{202E}\u{0061}\u{202C}\u{0021}\u{202C}\u{0021}\u{2069}\u{0061}"
  let para_level = 1
  let expected_levels = [-1, -1, -1, -1, 5, 6, -1, 7, -1, 6, -1, 6, 5, 5]
  let expected_reorder = [13, 12, 5, 7, 9, 11, 4]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202B}\u{202A}\u{202E}\u{202D}\u{2067}\u{0021}\u{202D}\u{05D0}\u{202C}\u{0021}\u{202C}\u{0021}\u{2069}\u{05D0}"
  let para_level = -1
  let expected_levels = [-1, -1, -1, -1, 6, 7, -1, 8, -1, 7, -1, 7, 6, 6]
  let expected_reorder = [4, 11, 9, 7, 5, 12, 13]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202B}\u{202A}\u{202E}\u{202D}\u{2067}\u{0021}\u{202D}\u{05D0}\u{202C}\u{0021}\u{202C}\u{0021}\u{2069}\u{05D0}"
  let para_level = 1
  let expected_levels = [-1, -1, -1, -1, 6, 7, -1, 8, -1, 7, -1, 7, 6, 6]
  let expected_reorder = [4, 11, 9, 7, 5, 12, 13]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202B}\u{202A}\u{202E}\u{202D}\u{2068}\u{05D0}\u{202D}\u{05D0}\u{202C}\u{0021}\u{202C}\u{0021}\u{2069}\u{05D0}"
  let para_level = -1
  let expected_levels = [-1, -1, -1, -1, 6, 7, -1, 8, -1, 7, -1, 7, 6, 6]
  let expected_reorder = [4, 11, 9, 7, 5, 12, 13]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202B}\u{202A}\u{202E}\u{202D}\u{2068}\u{05D0}\u{202D}\u{05D0}\u{202C}\u{0021}\u{202C}\u{0021}\u{2069}\u{05D0}"
  let para_level = 1
  let expected_levels = [-1, -1, -1, -1, 6, 7, -1, 8, -1, 7, -1, 7, 6, 6]
  let expected_reorder = [4, 11, 9, 7, 5, 12, 13]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202B}\u{0021}\u{2066}\u{0021}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}"
  let para_level = -1
  let expected_levels = [0, -1, 1, 1, 2, -1, 3, -1, 2, 1, 1, -1, 0]
  let expected_reorder = [0, 10, 9, 4, 6, 8, 3, 2, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202B}\u{0021}\u{2066}\u{0021}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}"
  let para_level = 0
  let expected_levels = [0, -1, 1, 1, 2, -1, 3, -1, 2, 1, 1, -1, 0]
  let expected_reorder = [0, 10, 9, 4, 6, 8, 3, 2, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202B}\u{0021}\u{2067}\u{0021}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}"
  let para_level = -1
  let expected_levels = [0, -1, 1, 1, 3, -1, 5, -1, 3, 1, 1, -1, 0]
  let expected_reorder = [0, 10, 9, 8, 6, 4, 3, 2, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202B}\u{0021}\u{2067}\u{0021}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}"
  let para_level = 0
  let expected_levels = [0, -1, 1, 1, 3, -1, 5, -1, 3, 1, 1, -1, 0]
  let expected_reorder = [0, 10, 9, 8, 6, 4, 3, 2, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202A}\u{0021}\u{2067}\u{0021}\u{202D}\u{05D0}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}"
  let para_level = -1
  let expected_levels = [0, -1, 2, 2, 3, -1, 4, -1, 3, 2, 2, -1, 0]
  let expected_reorder = [0, 2, 3, 8, 6, 4, 9, 10, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202A}\u{0021}\u{2067}\u{0021}\u{202D}\u{05D0}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}"
  let para_level = 0
  let expected_levels = [0, -1, 2, 2, 3, -1, 4, -1, 3, 2, 2, -1, 0]
  let expected_reorder = [0, 2, 3, 8, 6, 4, 9, 10, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202A}\u{0021}\u{2066}\u{0021}\u{202D}\u{05D0}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}"
  let para_level = -1
  let expected_levels = [0, -1, 2, 2, 4, -1, 6, -1, 4, 2, 2, -1, 0]
  let expected_reorder = [0, 2, 3, 4, 6, 8, 9, 10, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202A}\u{0021}\u{2066}\u{0021}\u{202D}\u{05D0}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}"
  let para_level = 0
  let expected_levels = [0, -1, 2, 2, 4, -1, 6, -1, 4, 2, 2, -1, 0]
  let expected_reorder = [0, 2, 3, 4, 6, 8, 9, 10, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202A}\u{0021}\u{2067}\u{0021}\u{202D}\u{05D0}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}"
  let para_level = 1
  let expected_levels = [1, -1, 2, 2, 3, -1, 4, -1, 3, 2, 2, -1, 1]
  let expected_reorder = [12, 2, 3, 8, 6, 4, 9, 10, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202A}\u{0021}\u{2066}\u{0021}\u{202D}\u{05D0}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}"
  let para_level = 1
  let expected_levels = [1, -1, 2, 2, 4, -1, 6, -1, 4, 2, 2, -1, 1]
  let expected_reorder = [12, 2, 3, 4, 6, 8, 9, 10, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202B}\u{0021}\u{2066}\u{0021}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}"
  let para_level = 1
  let expected_levels = [1, -1, 3, 3, 4, -1, 5, -1, 4, 3, 3, -1, 1]
  let expected_reorder = [12, 10, 9, 4, 6, 8, 3, 2, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202B}\u{0021}\u{2067}\u{0021}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}"
  let para_level = 1
  let expected_levels = [1, -1, 3, 3, 5, -1, 7, -1, 5, 3, 3, -1, 1]
  let expected_reorder = [12, 10, 9, 8, 6, 4, 3, 2, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202B}\u{0021}\u{2068}\u{0021}\u{0061}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}"
  let para_level = -1
  let expected_levels = [0, -1, 1, 1, 2, 2, -1, 3, -1, 2, 1, 1, -1, 0]
  let expected_reorder = [0, 11, 10, 4, 5, 7, 9, 3, 2, 13]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202B}\u{0021}\u{2068}\u{0021}\u{0061}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}"
  let para_level = 0
  let expected_levels = [0, -1, 1, 1, 2, 2, -1, 3, -1, 2, 1, 1, -1, 0]
  let expected_reorder = [0, 11, 10, 4, 5, 7, 9, 3, 2, 13]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202B}\u{0021}\u{2068}\u{0021}\u{05D0}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}"
  let para_level = -1
  let expected_levels = [0, -1, 1, 1, 3, 3, -1, 5, -1, 3, 1, 1, -1, 0]
  let expected_reorder = [0, 11, 10, 9, 7, 5, 4, 3, 2, 13]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202B}\u{0021}\u{2068}\u{0021}\u{05D0}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}"
  let para_level = 0
  let expected_levels = [0, -1, 1, 1, 3, 3, -1, 5, -1, 3, 1, 1, -1, 0]
  let expected_reorder = [0, 11, 10, 9, 7, 5, 4, 3, 2, 13]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202B}\u{0021}\u{2068}\u{0021}\u{0061}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}"
  let para_level = 1
  let expected_levels = [1, -1, 3, 3, 4, 4, -1, 5, -1, 4, 3, 3, -1, 1]
  let expected_reorder = [13, 11, 10, 4, 5, 7, 9, 3, 2, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{202B}\u{0021}\u{2068}\u{0021}\u{05D0}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}"
  let para_level = 1
  let expected_levels = [1, -1, 3, 3, 5, 5, -1, 7, -1, 5, 3, 3, -1, 1]
  let expected_reorder = [13, 11, 10, 9, 7, 5, 4, 3, 2, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0030}\u{002B}\u{2066}\u{2069}\u{0030}\u{002B}\u{2067}\u{2069}\u{0030}\u{002B}\u{2068}\u{2069}\u{0030}"
  let para_level = -1
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0030}\u{002B}\u{2066}\u{2069}\u{0030}\u{002B}\u{2067}\u{2069}\u{0030}\u{002B}\u{2068}\u{2069}\u{0030}"
  let para_level = 0
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{202D}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{202C}"
  let para_level = -1
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, -1, 2, 2, 2, 2, -1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{202D}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{202C}"
  let para_level = 0
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, -1, 2, 2, 2, 2, -1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0021}\u{2068}\u{05D0}\u{2069}\u{2067}\u{05D0}\u{2069}\u{2066}\u{0627}\u{2069}\u{0021}\u{0061}"
  let para_level = -1
  let expected_levels = [0, 0, 0, 1, 0, 0, 1, 0, 0, 3, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0021}\u{2068}\u{05D0}\u{2069}\u{2067}\u{05D0}\u{2069}\u{2066}\u{0627}\u{2069}\u{0021}\u{0061}"
  let para_level = 0
  let expected_levels = [0, 0, 0, 1, 0, 0, 1, 0, 0, 3, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{2068}\u{05D0}\u{0020}\u{2069}\u{0020}\u{2067}\u{0020}\u{2066}\u{0020}\u{2069}\u{2069}\u{0020}"
  let para_level = -1
  let expected_levels = [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{2068}\u{05D0}\u{0020}\u{2069}\u{0020}\u{2067}\u{0020}\u{2066}\u{0020}\u{2069}\u{2069}\u{0020}"
  let para_level = 0
  let expected_levels = [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{2066}\u{0021}\u{2067}\u{0021}\u{2068}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}"
  let para_level = -1
  let expected_levels = [0, 0, 2, 2, 3, 3, 4, 3, 3, 2, 2, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 8, 7, 6, 5, 4, 9, 10, 11, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{2066}\u{0021}\u{2067}\u{0021}\u{2068}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}"
  let para_level = 0
  let expected_levels = [0, 0, 2, 2, 3, 3, 4, 3, 3, 2, 2, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 8, 7, 6, 5, 4, 9, 10, 11, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{2068}\u{0061}\u{0020}\u{2069}\u{0020}\u{2066}\u{0020}\u{2067}\u{0020}\u{2069}\u{2069}\u{0020}"
  let para_level = 0
  let expected_levels = [1, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0021}\u{05D0}"
  let para_level = 0
  let expected_levels = [1, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{0021}\u{2066}\u{0061}\u{2069}\u{2068}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0021}\u{0030}"
  let para_level = 0
  let expected_levels = [1, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2]
  let expected_reorder = [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0021}\u{05D0}"
  let para_level = -1
  let expected_levels = [1, 1, 1, 2, 1, 1, 2, 1, 1, 4, 1, 1, 1]
  let expected_reorder = [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0021}\u{05D0}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 2, 1, 1, 2, 1, 1, 4, 1, 1, 1]
  let expected_reorder = [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{0021}\u{2066}\u{0061}\u{2069}\u{2068}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0021}\u{0030}"
  let para_level = -1
  let expected_levels = [1, 1, 1, 2, 1, 1, 2, 1, 1, 4, 1, 1, 2]
  let expected_reorder = [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{0021}\u{2066}\u{0061}\u{2069}\u{2068}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0021}\u{0030}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 2, 1, 1, 2, 1, 1, 4, 1, 1, 2]
  let expected_reorder = [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{2068}\u{0061}\u{0020}\u{2069}\u{0020}\u{2066}\u{0020}\u{2067}\u{0020}\u{2069}\u{2069}\u{0020}"
  let para_level = -1
  let expected_levels = [1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{2068}\u{0061}\u{0020}\u{2069}\u{0020}\u{2066}\u{0020}\u{2067}\u{0020}\u{2069}\u{2069}\u{0020}"
  let para_level = 1
  let expected_levels = [1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{2066}\u{0021}\u{2067}\u{0021}\u{2068}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}"
  let para_level = 1
  let expected_levels = [1, 1, 2, 2, 3, 3, 4, 3, 3, 2, 2, 1, 1]
  let expected_reorder = [12, 11, 2, 3, 8, 7, 6, 5, 4, 9, 10, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0030}\u{002B}\u{2066}\u{2069}\u{0030}\u{002B}\u{2067}\u{2069}\u{0030}\u{002B}\u{2068}\u{2069}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 2]
  let expected_reorder = [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0660}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0021}\u{0627}"
  let para_level = 0
  let expected_levels = [2, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 1]
  let expected_reorder = [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0660}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0021}\u{0627}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2, 1, 1, 2, 1, 1, 4, 1, 1, 1]
  let expected_reorder = [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0660}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0021}\u{0627}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2, 1, 1, 2, 1, 1, 4, 1, 1, 1]
  let expected_reorder = [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{2068}\u{05D0}\u{0020}\u{2069}\u{0020}\u{2067}\u{0020}\u{2066}\u{0020}\u{2069}\u{2069}\u{0020}"
  let para_level = 1
  let expected_levels = [2, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{202D}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{202C}"
  let para_level = 1
  let expected_levels = [2, 2, 2, 2, 2, 2, 2, 2, -1, 2, 2, 2, 2, -1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0021}\u{2068}\u{05D0}\u{2069}\u{2067}\u{05D0}\u{2069}\u{2066}\u{0627}\u{2069}\u{0021}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 2, 2, 3, 2, 2, 3, 2, 2, 3, 2, 2, 2]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{2067}\u{0021}\u{2068}\u{0021}\u{05D0}\u{2066}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}"
  let para_level = -1
  let expected_levels = [0, 0, 1, 1, 3, 3, 3, 4, 3, 3, 1, 1, 0, 0]
  let expected_reorder = [0, 1, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 12, 13]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{2067}\u{0021}\u{2068}\u{0021}\u{05D0}\u{2066}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}"
  let para_level = 0
  let expected_levels = [0, 0, 1, 1, 3, 3, 3, 4, 3, 3, 1, 1, 0, 0]
  let expected_reorder = [0, 1, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 12, 13]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{05D0}\u{2069}\u{0021}\u{0024}\u{0030}"
  let para_level = 0
  let expected_levels = [1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2]
  let expected_reorder = [13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{05D0}\u{2069}\u{0021}\u{0024}\u{0030}"
  let para_level = -1
  let expected_levels = [1, 1, 1, 2, 1, 1, 2, 1, 1, 3, 1, 1, 1, 2]
  let expected_reorder = [13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{05D0}\u{2069}\u{0021}\u{0024}\u{0030}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 2, 1, 1, 2, 1, 1, 3, 1, 1, 1, 2]
  let expected_reorder = [13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{2067}\u{0021}\u{2068}\u{0021}\u{05D0}\u{2066}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}"
  let para_level = 1
  let expected_levels = [1, 1, 3, 3, 5, 5, 5, 6, 5, 5, 3, 3, 1, 1]
  let expected_reorder = [13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0020}\u{202D}\u{202C}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{002B}"
  let para_level = -1
  let expected_levels = [0, 0, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 1, 14, 13, 12, 11, 8, 7, 6, 5, 4, 3, 2, 15]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0020}\u{202D}\u{202C}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{002B}"
  let para_level = 0
  let expected_levels = [0, 0, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 1, 14, 13, 12, 11, 8, 7, 6, 5, 4, 3, 2, 15]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0020}\u{202D}\u{202C}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, 1, 1, 1]
  let expected_reorder = [15, 14, 13, 12, 11, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{202A}\u{202C}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0021}"
  let para_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, 1, 1, 0]
  let expected_reorder = [15, 14, 13, 12, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 16]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{202A}\u{202C}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0021}"
  let para_level = -1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, 1, 1, 1]
  let expected_reorder = [16, 15, 14, 13, 12, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{202A}\u{202C}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0021}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, 1, 1, 1]
  let expected_reorder = [16, 15, 14, 13, 12, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0061}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0009}\u{05D0}\u{0030}\u{0020}\u{0009}\u{0009}\u{0061}\u{0061}\u{0061}"
  let para_level = -1
  let expected_levels = [0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 2, 0, 0, 0, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 7, 6, 5, 4, 8, 10, 9, 11, 12, 13, 14, 15, 16]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0061}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0009}\u{05D0}\u{0030}\u{0020}\u{0009}\u{0009}\u{0061}\u{0061}\u{0061}"
  let para_level = 0
  let expected_levels = [0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 2, 0, 0, 0, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 7, 6, 5, 4, 8, 10, 9, 11, 12, 13, 14, 15, 16]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{05D0}\u{0627}\u{0020}\u{202B}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{202A}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0061}\u{0061}\u{0061}"
  let para_level = 0
  let expected_levels = [1, 1, 1, 1, -1, 2, 2, 2, 2, 2, -1, 3, 3, 3, 2, 2, 2, 2]
  let expected_reorder = [5, 6, 7, 8, 9, 13, 12, 11, 14, 15, 16, 17, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{05D0}\u{0627}\u{0020}\u{202B}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{202A}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0061}\u{0061}\u{0061}"
  let para_level = -1
  let expected_levels = [1, 1, 1, 1, -1, 4, 4, 4, 4, 4, -1, 5, 5, 5, 4, 4, 4, 4]
  let expected_reorder = [5, 6, 7, 8, 9, 13, 12, 11, 14, 15, 16, 17, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{05D0}\u{0627}\u{0020}\u{202B}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{202A}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0061}\u{0061}\u{0061}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 1, -1, 4, 4, 4, 4, 4, -1, 5, 5, 5, 4, 4, 4, 4]
  let expected_reorder = [5, 6, 7, 8, 9, 13, 12, 11, 14, 15, 16, 17, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0061}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0009}\u{05D0}\u{0030}\u{0020}\u{0009}\u{0009}\u{0061}\u{0061}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 2, 2]
  let expected_reorder = [14, 15, 16, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 0, 1, 2]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{0627}\u{05D0}\u{0020}\u{0627}\u{0020}\u{202D}\u{05D0}\u{0627}\u{0627}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}"
  let para_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 0, -1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]
  let expected_reorder = [4, 3, 2, 1, 0, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{0627}\u{05D0}\u{0020}\u{0627}\u{0020}\u{202D}\u{05D0}\u{0627}\u{0627}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}"
  let para_level = -1
  let expected_levels = [1, 1, 1, 1, 1, 1, -1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]
  let expected_reorder = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{0627}\u{05D0}\u{0020}\u{0627}\u{0020}\u{202D}\u{05D0}\u{0627}\u{0627}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, -1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]
  let expected_reorder = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{0030}\u{0020}\u{0627}\u{0627}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0627}"
  let para_level = 0
  let expected_levels = [0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [0, 1, 2, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{0030}\u{0020}\u{0627}\u{0627}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0627}"
  let para_level = -1
  let expected_levels = [1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{0030}\u{0020}\u{0627}\u{0627}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0627}"
  let para_level = 1
  let expected_levels = [1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{0061}\u{0030}\u{0030}\u{0030}\u{0021}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0021}\u{002B}\u{0061}\u{0030}\u{0030}\u{0030}\u{0021}"
  let para_level = -1
  let expected_levels = [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 11, 10, 9, 8, 7, 6, 12, 13, 14, 15, 16, 17, 18]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{0061}\u{0030}\u{0030}\u{0030}\u{0021}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0021}\u{002B}\u{0061}\u{0030}\u{0030}\u{0030}\u{0021}"
  let para_level = 0
  let expected_levels = [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 11, 10, 9, 8, 7, 6, 12, 13, 14, 15, 16, 17, 18]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{05D0}\u{0030}\u{0030}\u{0030}\u{0021}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0021}\u{002B}\u{05D0}\u{0030}\u{0030}\u{0030}\u{0021}"
  let para_level = 0
  let expected_levels = [0, 1, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 0]
  let expected_reorder = [0, 2, 3, 4, 1, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 16, 17, 14, 18]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0030}\u{002B}\u{0030}\u{002B}\u{002B}\u{0030}"
  let para_level = -1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2]
  let expected_reorder = [18, 17, 16, 13, 14, 15, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0030}\u{002B}\u{0030}\u{002B}\u{002B}\u{0030}"
  let para_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2]
  let expected_reorder = [18, 17, 16, 13, 14, 15, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0030}\u{002B}\u{0030}\u{002B}\u{002B}\u{0030}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2]
  let expected_reorder = [18, 17, 16, 13, 14, 15, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{05D0}\u{0030}\u{0030}\u{0030}\u{0021}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0021}\u{002B}\u{05D0}\u{0030}\u{0030}\u{0030}\u{0021}"
  let para_level = -1
  let expected_levels = [1, 1, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1, 1, 1, 2, 2, 2, 1]
  let expected_reorder = [18, 15, 16, 17, 14, 13, 12, 6, 7, 8, 9, 10, 11, 5, 2, 3, 4, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{05D0}\u{0030}\u{0030}\u{0030}\u{0021}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0021}\u{002B}\u{05D0}\u{0030}\u{0030}\u{0030}\u{0021}"
  let para_level = 1
  let expected_levels = [1, 1, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1, 1, 1, 2, 2, 2, 1]
  let expected_reorder = [18, 15, 16, 17, 14, 13, 12, 6, 7, 8, 9, 10, 11, 5, 2, 3, 4, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0021}\u{0061}\u{0030}\u{0030}\u{0030}\u{0021}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0021}\u{002B}\u{0061}\u{0030}\u{0030}\u{0030}\u{0021}"
  let para_level = 1
  let expected_levels = [1, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 1]
  let expected_reorder = [18, 14, 15, 16, 17, 13, 12, 11, 10, 9, 8, 7, 6, 5, 1, 2, 3, 4, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0020}\u{202A}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{202E}\u{0061}\u{0061}\u{05D0}\u{05D0}\u{202C}\u{0020}\u{0061}\u{0061}\u{202C}\u{0061}\u{0061}"
  let para_level = -1
  let expected_levels = [0, 0, -1, 2, 2, 2, 2, 2, 2, 2, -1, 3, 3, 3, 3, -1, 2, 2, 2, -1, 0, 0]
  let expected_reorder = [0, 1, 3, 4, 5, 6, 7, 8, 9, 14, 13, 12, 11, 16, 17, 18, 20, 21]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0020}\u{202A}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{202E}\u{0061}\u{0061}\u{05D0}\u{05D0}\u{202C}\u{0020}\u{0061}\u{0061}\u{202C}\u{0061}\u{0061}"
  let para_level = 0
  let expected_levels = [0, 0, -1, 2, 2, 2, 2, 2, 2, 2, -1, 3, 3, 3, 3, -1, 2, 2, 2, -1, 0, 0]
  let expected_reorder = [0, 1, 3, 4, 5, 6, 7, 8, 9, 14, 13, 12, 11, 16, 17, 18, 20, 21]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0020}\u{202A}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{202E}\u{0061}\u{0061}\u{05D0}\u{05D0}\u{202C}\u{0020}\u{0061}\u{0061}\u{202C}\u{0061}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 2, -1, 2, 2, 2, 2, 2, 2, 2, -1, 3, 3, 3, 3, -1, 2, 2, 2, -1, 2, 2]
  let expected_reorder = [0, 1, 3, 4, 5, 6, 7, 8, 9, 14, 13, 12, 11, 16, 17, 18, 20, 21]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0020}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202E}\u{0061}\u{0061}\u{0061}"
  let para_level = -1
  let expected_levels = [0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 63, 63, 63]
  let expected_reorder = [0, 1, 36, 35, 34]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0020}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202E}\u{0061}\u{0061}\u{0061}"
  let para_level = 0
  let expected_levels = [0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 63, 63, 63]
  let expected_reorder = [0, 1, 36, 35, 34]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0020}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202E}\u{0061}\u{0061}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 63, 63, 63]
  let expected_reorder = [36, 35, 34, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0030}\u{0021}\u{0030}\u{0020}\u{0030}\u{0021}\u{0030}\u{0020}\u{0030}\u{002B}\u{0030}\u{0020}\u{0030}\u{0024}\u{0030}"
  let para_level = -1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2]
  let expected_reorder = [20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0030}\u{0021}\u{0030}\u{0020}\u{0030}\u{0021}\u{0030}\u{0020}\u{0030}\u{002B}\u{0030}\u{0020}\u{0030}\u{0024}\u{0030}"
  let para_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2]
  let expected_reorder = [20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0030}\u{0021}\u{0030}\u{0020}\u{0030}\u{0021}\u{0030}\u{0020}\u{0030}\u{002B}\u{0030}\u{0020}\u{0030}\u{0024}\u{0030}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2]
  let expected_reorder = [20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0061}\u{0061}\u{202D}\u{0020}\u{0061}\u{0061}\u{202C}\u{202C}\u{202C}\u{0020}\u{202E}\u{0020}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{202C}"
  let para_level = -1
  let expected_levels = [0, 0, 0, 0, -1, 2, 2, 2, -1, -1, -1, 0, -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1]
  let expected_reorder = [0, 1, 2, 3, 5, 6, 7, 11, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0061}\u{0061}\u{202D}\u{0020}\u{0061}\u{0061}\u{202C}\u{202C}\u{202C}\u{0020}\u{202E}\u{0020}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{202C}"
  let para_level = 0
  let expected_levels = [0, 0, 0, 0, -1, 2, 2, 2, -1, -1, -1, 0, -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1]
  let expected_reorder = [0, 1, 2, 3, 5, 6, 7, 11, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0061}\u{0061}\u{202D}\u{0020}\u{0061}\u{0061}\u{202C}\u{202C}\u{202C}\u{0020}\u{202E}\u{0020}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{202C}"
  let para_level = 1
  let expected_levels = [2, 2, 2, 2, -1, 2, 2, 2, -1, -1, -1, 1, -1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, -1]
  let expected_reorder = [23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 11, 0, 1, 2, 3, 5, 6, 7]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0660}\u{0660}\u{202B}\u{202C}\u{0660}\u{0660}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0021}"
  let para_level = -1
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, -1, -1, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0660}\u{0660}\u{202B}\u{202C}\u{0660}\u{0660}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0021}"
  let para_level = 0
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, -1, -1, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0660}\u{0660}\u{202B}\u{202C}\u{0660}\u{0660}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, -1, -1, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 1]
  let expected_reorder = [23, 16, 17, 18, 19, 20, 21, 22, 15, 9, 10, 13, 14, 8, 0, 1, 2, 3, 4, 5, 6, 7]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202E}\u{202B}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{202D}\u{05D0}\u{05D0}\u{0627}\u{202C}\u{0020}\u{05D0}\u{05D0}\u{0020}"
  let para_level = -1
  let expected_levels = [-1, -1, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, -1, 4, 4, 4, -1, 3, 3, 3, 0]
  let expected_reorder = [23, 22, 21, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 18, 19, 2, 24]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202E}\u{202B}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{202D}\u{05D0}\u{05D0}\u{0627}\u{202C}\u{0020}\u{05D0}\u{05D0}\u{0020}"
  let para_level = 0
  let expected_levels = [-1, -1, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, -1, 4, 4, 4, -1, 3, 3, 3, 0]
  let expected_reorder = [23, 22, 21, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 18, 19, 2, 24]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202E}\u{202B}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{202D}\u{05D0}\u{05D0}\u{0627}\u{202C}\u{0020}\u{05D0}\u{05D0}\u{0020}"
  let para_level = 1
  let expected_levels = [-1, -1, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, -1, 6, 6, 6, -1, 5, 5, 5, 1]
  let expected_reorder = [24, 23, 22, 21, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 18, 19, 2]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0627}\u{0627}\u{05D0}\u{0020}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}"
  let para_level = -1
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 13, 12, 11, 10, 9, 8, 7, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0627}\u{0627}\u{05D0}\u{0020}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}"
  let para_level = 0
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 13, 12, 11, 10, 9, 8, 7, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0627}\u{0627}\u{05D0}\u{0020}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2]
  let expected_reorder = [15, 16, 17, 18, 19, 20, 21, 22, 23, 14, 13, 12, 11, 10, 9, 8, 7, 6, 0, 1, 2, 3, 4, 5]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{202A}\u{2067}\u{202A}\u{202B}\u{202D}\u{202E}\u{2069}\u{202C}\u{0061}\u{202C}\u{0021}"
  let para_level = -1
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 60, -1, 61, -1, 62, -1, -1, -1, -1, 62, -1, 61, -1, 60]
  let expected_reorder = [30, 41, 34, 39, 32, 43]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{202A}\u{2067}\u{202A}\u{202B}\u{202D}\u{202E}\u{2069}\u{202C}\u{0061}\u{202C}\u{0021}"
  let para_level = 0
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 60, -1, 61, -1, 62, -1, -1, -1, -1, 62, -1, 61, -1, 60]
  let expected_reorder = [30, 41, 34, 39, 32, 43]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{202A}\u{2067}\u{202A}\u{202B}\u{202D}\u{202E}\u{2069}\u{202C}\u{0061}\u{202C}\u{0021}"
  let para_level = 1
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 60, -1, 61, -1, 62, -1, -1, -1, -1, 62, -1, 61, -1, 60]
  let expected_reorder = [30, 41, 34, 39, 32, 43]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0627}\u{0020}\u{202A}\u{0020}\u{202C}\u{0020}\u{0030}\u{0030}\u{0030}\u{0021}\u{0030}\u{0030}\u{0660}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}"
  let para_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 0, -1, 2, -1, 0, 0, 0, 0, 0, 0, 0, 2, 1, 1, 1, 1, 1]
  let expected_reorder = [8, 7, 6, 5, 4, 3, 2, 1, 0, 9, 11, 13, 14, 15, 16, 17, 18, 19, 25, 24, 23, 22, 21, 20]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0627}\u{0020}\u{202A}\u{0020}\u{202C}\u{0020}\u{0030}\u{0030}\u{0030}\u{0021}\u{0030}\u{0030}\u{0660}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}"
  let para_level = -1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, 2, -1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1]
  let expected_reorder = [25, 24, 23, 22, 21, 11, 13, 14, 15, 16, 17, 18, 19, 20, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0627}\u{0020}\u{202A}\u{0020}\u{202C}\u{0020}\u{0030}\u{0030}\u{0030}\u{0021}\u{0030}\u{0030}\u{0660}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, 2, -1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1]
  let expected_reorder = [25, 24, 23, 22, 21, 11, 13, 14, 15, 16, 17, 18, 19, 20, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{05D0}"
  let para_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [5, 4, 3, 2, 1, 0, 6, 7, 8, 9, 10, 11, 12, 13, 14, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{05D0}"
  let para_level = -1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 7, 8, 9, 10, 11, 12, 13, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{05D0}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 7, 8, 9, 10, 11, 12, 13, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{2066}\u{202B}\u{202A}\u{202E}\u{202D}\u{0021}\u{2069}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}"
  let para_level = -1
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 58, -1, 59, -1, -1, -1, -1, 64, 59, 59, 59, 59, -1, 58]
  let expected_reorder = [29, 40, 39, 38, 37, 36, 31, 42]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{2066}\u{202B}\u{202A}\u{202E}\u{202D}\u{0021}\u{2069}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}"
  let para_level = 0
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 58, -1, 59, -1, -1, -1, -1, 64, 59, 59, 59, 59, -1, 58]
  let expected_reorder = [29, 40, 39, 38, 37, 36, 31, 42]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{2066}\u{202B}\u{202A}\u{202E}\u{202D}\u{0021}\u{2069}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}"
  let para_level = 1
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 58, -1, 59, -1, -1, -1, -1, 64, 59, 59, 59, 59, -1, 58]
  let expected_reorder = [29, 40, 39, 38, 37, 36, 31, 42]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2067}\u{0021}\u{202D}\u{202B}\u{202E}\u{202A}\u{0021}\u{2069}\u{05D0}\u{202C}\u{0021}"
  let para_level = -1
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 59, -1, 60, 60, 61, -1, -1, -1, -1, 66, 60, 60, -1, 59]
  let expected_reorder = [43, 32, 33, 39, 34, 40, 41, 30]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2067}\u{0021}\u{202D}\u{202B}\u{202E}\u{202A}\u{0021}\u{2069}\u{05D0}\u{202C}\u{0021}"
  let para_level = 0
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 59, -1, 60, 60, 61, -1, -1, -1, -1, 66, 60, 60, -1, 59]
  let expected_reorder = [43, 32, 33, 39, 34, 40, 41, 30]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2067}\u{0021}\u{202D}\u{202B}\u{202E}\u{202A}\u{0021}\u{2069}\u{05D0}\u{202C}\u{0021}"
  let para_level = 1
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 59, -1, 60, 60, 61, -1, -1, -1, -1, 66, 60, 60, -1, 59]
  let expected_reorder = [43, 32, 33, 39, 34, 40, 41, 30]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2066}\u{05D0}\u{202A}\u{202B}\u{202D}\u{202E}\u{05D0}\u{2069}\u{05D0}\u{202C}\u{0021}"
  let para_level = -1
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 59, -1, 60, 60, 63, -1, -1, -1, -1, 67, 60, 60, -1, 59]
  let expected_reorder = [43, 32, 33, 39, 34, 40, 41, 30]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2066}\u{05D0}\u{202A}\u{202B}\u{202D}\u{202E}\u{05D0}\u{2069}\u{05D0}\u{202C}\u{0021}"
  let para_level = 0
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 59, -1, 60, 60, 63, -1, -1, -1, -1, 67, 60, 60, -1, 59]
  let expected_reorder = [43, 32, 33, 39, 34, 40, 41, 30]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2066}\u{05D0}\u{202A}\u{202B}\u{202D}\u{202E}\u{05D0}\u{2069}\u{05D0}\u{202C}\u{0021}"
  let para_level = 1
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 59, -1, 60, 60, 63, -1, -1, -1, -1, 67, 60, 60, -1, 59]
  let expected_reorder = [43, 32, 33, 39, 34, 40, 41, 30]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{2066}\u{0061}\u{202B}\u{202A}\u{202E}\u{202D}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}"
  let para_level = -1
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 60, -1, 61, 61, 62, -1, -1, -1, -1, 66, 61, 61, -1, 60]
  let expected_reorder = [30, 41, 40, 34, 39, 33, 32, 43]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{2066}\u{0061}\u{202B}\u{202A}\u{202E}\u{202D}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}"
  let para_level = 0
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 60, -1, 61, 61, 62, -1, -1, -1, -1, 66, 61, 61, -1, 60]
  let expected_reorder = [30, 41, 40, 34, 39, 33, 32, 43]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{2066}\u{0061}\u{202B}\u{202A}\u{202E}\u{202D}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}"
  let para_level = 1
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 60, -1, 61, 61, 62, -1, -1, -1, -1, 66, 61, 61, -1, 60]
  let expected_reorder = [30, 41, 40, 34, 39, 33, 32, 43]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{0061}\u{0061}\u{0020}\u{202B}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0660}\u{0660}\u{0660}\u{202D}\u{05D0}\u{05D0}\u{0627}\u{202E}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{202C}\u{0020}\u{0061}\u{05D0}\u{0627}\u{002C}"
  let para_level = 0
  let expected_levels = [1, 0, 0, 0, -1, 1, 2, 2, 2, 1, 2, 2, 2, -1, 2, 2, 2, -1, 3, 3, 3, 3, 3, -1, 2, 2, 2, 2, 2]
  let expected_reorder = [0, 1, 2, 3, 10, 11, 12, 14, 15, 16, 22, 21, 20, 19, 18, 24, 25, 26, 27, 28, 9, 6, 7, 8, 5]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{0061}\u{0061}\u{0020}\u{202B}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0660}\u{0660}\u{0660}\u{202D}\u{05D0}\u{05D0}\u{0627}\u{202E}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{202C}\u{0020}\u{0061}\u{05D0}\u{0627}\u{002C}"
  let para_level = -1
  let expected_levels = [1, 2, 2, 1, -1, 3, 4, 4, 4, 3, 4, 4, 4, -1, 4, 4, 4, -1, 5, 5, 5, 5, 5, -1, 4, 4, 4, 4, 4]
  let expected_reorder = [10, 11, 12, 14, 15, 16, 22, 21, 20, 19, 18, 24, 25, 26, 27, 28, 9, 6, 7, 8, 5, 3, 1, 2, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{0061}\u{0061}\u{0020}\u{202B}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0660}\u{0660}\u{0660}\u{202D}\u{05D0}\u{05D0}\u{0627}\u{202E}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{202C}\u{0020}\u{0061}\u{05D0}\u{0627}\u{002C}"
  let para_level = 1
  let expected_levels = [1, 2, 2, 1, -1, 3, 4, 4, 4, 3, 4, 4, 4, -1, 4, 4, 4, -1, 5, 5, 5, 5, 5, -1, 4, 4, 4, 4, 4]
  let expected_reorder = [10, 11, 12, 14, 15, 16, 22, 21, 20, 19, 18, 24, 25, 26, 27, 28, 9, 6, 7, 8, 5, 3, 1, 2, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = -1
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 25, 24, 23, 22, 15, 16, 17, 18, 19, 20, 21, 14, 13, 12, 11, 10, 9, 26]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = 0
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 25, 24, 23, 22, 15, 16, 17, 18, 19, 20, 21, 14, 13, 12, 11, 10, 9, 26]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = -1
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 25, 24, 23, 22, 15, 16, 17, 18, 19, 20, 21, 14, 13, 12, 11, 10, 9, 26]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = 0
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 25, 24, 23, 22, 15, 16, 17, 18, 19, 20, 21, 14, 13, 12, 11, 10, 9, 26]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1]
  let expected_reorder = [26, 25, 24, 23, 22, 15, 16, 17, 18, 19, 20, 21, 14, 13, 12, 11, 10, 9, 8, 7, 0, 1, 2, 3, 4, 5, 6]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1]
  let expected_reorder = [26, 25, 24, 23, 22, 15, 16, 17, 18, 19, 20, 21, 14, 13, 12, 11, 10, 9, 8, 7, 0, 1, 2, 3, 4, 5, 6]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0020}\u{0030}\u{0030}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = -1
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 26, 25, 24, 23, 20, 21, 22, 19, 18, 15, 16, 17, 14, 13, 12, 11, 10, 9, 27]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0020}\u{0030}\u{0030}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = 0
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 26, 25, 24, 23, 20, 21, 22, 19, 18, 15, 16, 17, 14, 13, 12, 11, 10, 9, 27]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = -1
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 26, 25, 24, 23, 20, 21, 22, 19, 18, 15, 16, 17, 14, 13, 12, 11, 10, 9, 27]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = 0
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 26, 25, 24, 23, 20, 21, 22, 19, 18, 15, 16, 17, 14, 13, 12, 11, 10, 9, 27]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{0061}\u{0627}\u{0020}\u{0061}\u{05D0}\u{0061}\u{202D}\u{0020}\u{0627}\u{0061}\u{05D0}\u{0061}\u{05D0}\u{002C}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0660}\u{0660}\u{0660}\u{0020}\u{0061}\u{05D0}\u{0061}\u{05D0}\u{202C}"
  let para_level = 0
  let expected_levels = [1, 0, 1, 0, 0, 1, 0, -1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, -1]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0020}\u{0030}\u{0030}\u{0660}\u{002C}\u{0020}\u{0061}\u{0061}\u{0021}"
  let para_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0061}\u{0061}\u{0021}"
  let para_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 1, 1, 2, 2, 2, 0, 0, 0, 0, 0]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8, 9, 10, 11, 12, 13, 14, 20, 21, 22, 19, 18, 15, 16, 17, 23, 24, 25, 26, 27]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0061}\u{0061}\u{0021}"
  let para_level = -1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 2, 2, 1]
  let expected_reorder = [27, 25, 26, 24, 23, 20, 21, 22, 19, 18, 15, 16, 17, 14, 9, 10, 11, 12, 13, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0061}\u{0061}\u{0021}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 2, 2, 1]
  let expected_reorder = [27, 25, 26, 24, 23, 20, 21, 22, 19, 18, 15, 16, 17, 14, 9, 10, 11, 12, 13, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0020}\u{0030}\u{0030}\u{0660}\u{002C}\u{0020}\u{0061}\u{0061}\u{0021}"
  let para_level = -1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 2, 1]
  let expected_reorder = [27, 25, 26, 24, 23, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0020}\u{0030}\u{0030}\u{0660}\u{002C}\u{0020}\u{0061}\u{0061}\u{0021}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 2, 1]
  let expected_reorder = [27, 25, 26, 24, 23, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{0061}\u{0627}\u{0020}\u{0061}\u{05D0}\u{0061}\u{202D}\u{0020}\u{0627}\u{0061}\u{05D0}\u{0061}\u{05D0}\u{002C}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0660}\u{0660}\u{0660}\u{0020}\u{0061}\u{05D0}\u{0061}\u{05D0}\u{202C}"
  let para_level = -1
  let expected_levels = [1, 2, 1, 1, 2, 1, 2, -1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, -1]
  let expected_reorder = [6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{0061}\u{0627}\u{0020}\u{0061}\u{05D0}\u{0061}\u{202D}\u{0020}\u{0627}\u{0061}\u{05D0}\u{0061}\u{05D0}\u{002C}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0660}\u{0660}\u{0660}\u{0020}\u{0061}\u{05D0}\u{0061}\u{05D0}\u{202C}"
  let para_level = 1
  let expected_levels = [1, 2, 1, 1, 2, 1, 2, -1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, -1]
  let expected_reorder = [6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0020}\u{0030}\u{0030}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1]
  let expected_reorder = [27, 26, 25, 24, 23, 20, 21, 22, 19, 18, 15, 16, 17, 14, 13, 12, 11, 10, 9, 8, 7, 0, 1, 2, 3, 4, 5, 6]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1]
  let expected_reorder = [27, 26, 25, 24, 23, 20, 21, 22, 19, 18, 15, 16, 17, 14, 13, 12, 11, 10, 9, 8, 7, 0, 1, 2, 3, 4, 5, 6]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0627}\u{0020}\u{202A}\u{202C}\u{0020}\u{0030}\u{0030}\u{0030}\u{0021}\u{0030}\u{0030}\u{0660}\u{0020}\u{05D0}\u{05D0}\u{0627}\u{0627}\u{0020}\u{05D0}\u{05D0}\u{0627}\u{0021}"
  let para_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [28, 27, 26, 25, 24, 23, 22, 21, 20, 17, 18, 19, 16, 13, 14, 15, 12, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 29]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0627}\u{0020}\u{202A}\u{202C}\u{0020}\u{0030}\u{0030}\u{0030}\u{0021}\u{0030}\u{0030}\u{0660}\u{0020}\u{05D0}\u{05D0}\u{0627}\u{0627}\u{0020}\u{05D0}\u{05D0}\u{0627}\u{0021}"
  let para_level = -1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 17, 18, 19, 16, 13, 14, 15, 12, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0627}\u{0020}\u{202A}\u{202C}\u{0020}\u{0030}\u{0030}\u{0030}\u{0021}\u{0030}\u{0030}\u{0660}\u{0020}\u{05D0}\u{05D0}\u{0627}\u{0627}\u{0020}\u{05D0}\u{05D0}\u{0627}\u{0021}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 17, 18, 19, 16, 13, 14, 15, 12, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = -1
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 27, 26, 25, 24, 23, 16, 17, 18, 19, 20, 21, 22, 15, 14, 13, 12, 11, 10, 9, 28]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = 0
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 27, 26, 25, 24, 23, 16, 17, 18, 19, 20, 21, 22, 15, 14, 13, 12, 11, 10, 9, 28]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0660}\u{0660}\u{0660}\u{002C}\u{0660}\u{0660}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = -1
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 27, 26, 25, 24, 23, 16, 17, 18, 19, 20, 21, 22, 15, 14, 13, 12, 11, 10, 9, 28]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0660}\u{0660}\u{0660}\u{002C}\u{0660}\u{0660}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = 0
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 27, 26, 25, 24, 23, 16, 17, 18, 19, 20, 21, 22, 15, 14, 13, 12, 11, 10, 9, 28]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [28, 27, 26, 25, 24, 23, 16, 17, 18, 19, 20, 21, 22, 15, 14, 13, 12, 11, 10, 9, 8, 7, 0, 1, 2, 3, 4, 5, 6]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0660}\u{0660}\u{0660}\u{002C}\u{0660}\u{0660}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [28, 27, 26, 25, 24, 23, 16, 17, 18, 19, 20, 21, 22, 15, 14, 13, 12, 11, 10, 9, 8, 7, 0, 1, 2, 3, 4, 5, 6]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0030}\u{0030}\u{0030}\u{002C}\u{0020}\u{0030}\u{0030}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = -1
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 28, 27, 26, 25, 24, 21, 22, 23, 20, 19, 16, 17, 18, 15, 14, 13, 12, 11, 10, 9, 29]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0030}\u{0030}\u{0030}\u{002C}\u{0020}\u{0030}\u{0030}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = 0
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 28, 27, 26, 25, 24, 21, 22, 23, 20, 19, 16, 17, 18, 15, 14, 13, 12, 11, 10, 9, 29]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0660}\u{0660}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = -1
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 28, 27, 26, 25, 24, 21, 22, 23, 20, 19, 16, 17, 18, 15, 14, 13, 12, 11, 10, 9, 29]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0660}\u{0660}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = 0
  let expected_levels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1, 0]
  let expected_reorder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 28, 27, 26, 25, 24, 21, 22, 23, 20, 19, 16, 17, 18, 15, 14, 13, 12, 11, 10, 9, 29]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0021}\u{0021}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}"
  let para_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 29, 28, 27, 26, 25, 24, 23]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "207" {
  let input = "\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{002C}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}"
  let para_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2]
  let expected_reorder = [14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "208" {
  let input = "\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{002C}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}"
  let para_level = -1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]
  let expected_reorder = [17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "209" {
  let input = "\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{002C}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]
  let expected_reorder = [17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "210" {
  let input = "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0021}\u{0021}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}"
  let para_level = -1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "211" {
  let input = "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0021}\u{0021}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "212" {
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0030}\u{0030}\u{0030}\u{002C}\u{0020}\u{0030}\u{0030}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [29, 28, 27, 26, 25, 24, 21, 22, 23, 20, 19, 16, 17, 18, 15, 14, 13, 12, 11, 10, 9, 8, 7, 0, 1, 2, 3, 4, 5, 6]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "213" {
  let input = "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0660}\u{0660}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [29, 28, 27, 26, 25, 24, 21, 22, 23, 20, 19, 16, 17, 18, 15, 14, 13, 12, 11, 10, 9, 8, 7, 0, 1, 2, 3, 4, 5, 6]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "214" {
  let input = "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0021}\u{0061}\u{0021}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}"
  let para_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [6, 5, 4, 3, 2, 1, 0, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 30, 29, 28, 27, 26, 25, 24]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "215" {
  let input = "\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{002C}\u{0020}\u{0030}\u{0030}\u{0030}\u{0024}\u{002C}\u{0030}\u{0030}\u{0660}"
  let para_level = -1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 1, 2, 2, 2]
  let expected_reorder = [28, 29, 30, 27, 23, 24, 25, 26, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "216" {
  let input = "\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{002C}\u{0020}\u{0030}\u{0030}\u{0030}\u{0024}\u{002C}\u{0030}\u{0030}\u{0660}"
  let para_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 1, 2, 2, 2]
  let expected_reorder = [28, 29, 30, 27, 23, 24, 25, 26, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "217" {
  let input = "\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{002C}\u{0020}\u{0030}\u{0030}\u{0030}\u{0024}\u{002C}\u{0030}\u{0030}\u{0660}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 1, 2, 2, 2]
  let expected_reorder = [28, 29, 30, 27, 23, 24, 25, 26, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "218" {
  let input = "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0021}\u{0061}\u{0021}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}"
  let para_level = -1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [30, 29, 28, 27, 26, 25, 24, 23, 22, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "219" {
  let input = "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0021}\u{0061}\u{0021}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  let expected_reorder = [30, 29, 28, 27, 26, 25, 24, 23, 22, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "220" {
  let input = "\u{0627}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{002C}\u{0020}\u{0627}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}"
  let para_level = -1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2]
  let expected_reorder = [25, 26, 27, 28, 29, 30, 31, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "221" {
  let input = "\u{0627}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{002C}\u{0020}\u{0627}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}"
  let para_level = 0
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2]
  let expected_reorder = [25, 26, 27, 28, 29, 30, 31, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "222" {
  let input = "\u{0627}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{002C}\u{0020}\u{0627}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}"
  let para_level = 1
  let expected_levels = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2]
  let expected_reorder = [25, 26, 27, 28, 29, 30, 31, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "223" {
  let input = "\u{0061}\u{0020}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202E}\u{0061}\u{0061}\u{0061}"
  let para_level = -1
  let expected_levels = [0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 124, 124, 124]
  let expected_reorder = [0, 1, 66, 67, 68]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "224" {
  let input = "\u{0061}\u{0020}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202E}\u{0061}\u{0061}\u{0061}"
  let para_level = 0
  let expected_levels = [0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 124, 124, 124]
  let expected_reorder = [0, 1, 66, 67, 68]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "225" {
  let input = "\u{0061}\u{0020}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202E}\u{0061}\u{0061}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 124, 124, 124]
  let expected_reorder = [0, 1, 66, 67, 68]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "226" {
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{202A}\u{2067}\u{202A}\u{202B}\u{202D}\u{202E}\u{2069}\u{202C}\u{0061}\u{202C}\u{0021}"
  let para_level = -1
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 124, -1, 125, -1, 125, -1, -1, -1, -1, 125, -1, 125, -1, 124]
  let expected_reorder = [62, 73, 71, 66, 64, 75]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "227" {
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{202A}\u{2067}\u{202A}\u{202B}\u{202D}\u{202E}\u{2069}\u{202C}\u{0061}\u{202C}\u{0021}"
  let para_level = 0
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 124, -1, 125, -1, 125, -1, -1, -1, -1, 125, -1, 125, -1, 124]
  let expected_reorder = [62, 73, 71, 66, 64, 75]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "228" {
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{202A}\u{2067}\u{202A}\u{202B}\u{202D}\u{202E}\u{2069}\u{202C}\u{0061}\u{202C}\u{0021}"
  let para_level = 1
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 124, -1, 125, -1, 125, -1, -1, -1, -1, 125, -1, 125, -1, 124]
  let expected_reorder = [62, 73, 71, 66, 64, 75]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "229" {
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{2066}\u{202B}\u{202A}\u{202E}\u{202D}\u{0021}\u{2069}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}"
  let para_level = -1
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 122, -1, 123, -1, -1, -1, -1, 125, 123, 123, 123, 123, -1, 122]
  let expected_reorder = [61, 72, 71, 70, 69, 68, 63, 74]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "230" {
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{2066}\u{202B}\u{202A}\u{202E}\u{202D}\u{0021}\u{2069}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}"
  let para_level = 0
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 122, -1, 123, -1, -1, -1, -1, 125, 123, 123, 123, 123, -1, 122]
  let expected_reorder = [61, 72, 71, 70, 69, 68, 63, 74]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "231" {
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{2066}\u{202B}\u{202A}\u{202E}\u{202D}\u{0021}\u{2069}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}"
  let para_level = 1
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 122, -1, 123, -1, -1, -1, -1, 125, 123, 123, 123, 123, -1, 122]
  let expected_reorder = [61, 72, 71, 70, 69, 68, 63, 74]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "232" {
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2066}\u{05D0}\u{202A}\u{202B}\u{202D}\u{202E}\u{05D0}\u{2069}\u{05D0}\u{202C}\u{0021}"
  let para_level = -1
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 123, -1, 124, 124, 124, -1, -1, -1, -1, 124, 124, 124, -1, 123]
  let expected_reorder = [75, 64, 65, 66, 71, 72, 73, 62]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "233" {
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2066}\u{05D0}\u{202A}\u{202B}\u{202D}\u{202E}\u{05D0}\u{2069}\u{05D0}\u{202C}\u{0021}"
  let para_level = 0
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 123, -1, 124, 124, 124, -1, -1, -1, -1, 124, 124, 124, -1, 123]
  let expected_reorder = [75, 64, 65, 66, 71, 72, 73, 62]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "234" {
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2066}\u{05D0}\u{202A}\u{202B}\u{202D}\u{202E}\u{05D0}\u{2069}\u{05D0}\u{202C}\u{0021}"
  let para_level = 1
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 123, -1, 124, 124, 124, -1, -1, -1, -1, 124, 124, 124, -1, 123]
  let expected_reorder = [75, 64, 65, 66, 71, 72, 73, 62]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "235" {
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2067}\u{0021}\u{202D}\u{202B}\u{202E}\u{202A}\u{0021}\u{2069}\u{05D0}\u{202C}\u{0021}"
  let para_level = -1
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 123, -1, 124, 124, 125, -1, -1, -1, -1, 125, 124, 124, -1, 123]
  let expected_reorder = [75, 64, 65, 71, 66, 72, 73, 62]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "236" {
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2067}\u{0021}\u{202D}\u{202B}\u{202E}\u{202A}\u{0021}\u{2069}\u{05D0}\u{202C}\u{0021}"
  let para_level = 0
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 123, -1, 124, 124, 125, -1, -1, -1, -1, 125, 124, 124, -1, 123]
  let expected_reorder = [75, 64, 65, 71, 66, 72, 73, 62]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "237" {
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2067}\u{0021}\u{202D}\u{202B}\u{202E}\u{202A}\u{0021}\u{2069}\u{05D0}\u{202C}\u{0021}"
  let para_level = 1
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 123, -1, 124, 124, 125, -1, -1, -1, -1, 125, 124, 124, -1, 123]
  let expected_reorder = [75, 64, 65, 71, 66, 72, 73, 62]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "238" {
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{2066}\u{0061}\u{202B}\u{202A}\u{202E}\u{202D}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}"
  let para_level = -1
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 124, -1, 125, 125, 125, -1, -1, -1, -1, 125, 125, 125, -1, 124]
  let expected_reorder = [62, 73, 72, 71, 66, 65, 64, 75]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "239" {
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{2066}\u{0061}\u{202B}\u{202A}\u{202E}\u{202D}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}"
  let para_level = 0
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 124, -1, 125, 125, 125, -1, -1, -1, -1, 125, 125, 125, -1, 124]
  let expected_reorder = [62, 73, 72, 71, 66, 65, 64, 75]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "240" {
  let input = "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{2066}\u{0061}\u{202B}\u{202A}\u{202E}\u{202D}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}"
  let para_level = 1
  let expected_levels = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 124, -1, 125, 125, 125, -1, -1, -1, -1, 125, 125, 125, -1, 124]
  let expected_reorder = [62, 73, 72, 71, 66, 65, 64, 75]

  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
