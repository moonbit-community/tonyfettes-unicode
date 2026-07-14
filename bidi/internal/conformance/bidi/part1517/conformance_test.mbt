///|
/// Unicode Bidi Algorithm Conformance Tests - BidiTest.txt Part 1517
/// Generated from BidiTest.txt (Unicode 16.0.0)
///
/// Tests the implementation against official Unicode bidi test data.
/// Each test verifies resolved embedding levels and visual reordering.
///|
test "0" {
  let input = "\u{0660}\u{2069}\u{0021}\u{05D0}"
  let para_level = 0
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{0021}\u{05D0}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{0021}\u{0627}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{0021}\u{0627}"
  let para_level = 0
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{0021}\u{0627}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{0021}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{0021}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{0021}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{0021}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{0021}\u{000A}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{0021}\u{0009}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{0021}\u{0020}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{0021}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{0021}\u{2066}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{0021}\u{2067}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{0021}\u{2068}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{0021}\u{2069}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2066}\u{000A}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2066}\u{0009}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2066}\u{0020}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2066}\u{2066}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2066}\u{2067}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2066}\u{2068}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2066}\u{2069}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2067}\u{000A}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2067}\u{0009}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2067}\u{0020}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2067}\u{2066}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2067}\u{2067}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2067}\u{2068}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2067}\u{2069}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2068}\u{000A}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2068}\u{0009}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2068}\u{0020}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2068}\u{2066}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2068}\u{2067}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2068}\u{2068}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2068}\u{2069}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2069}\u{05D0}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2069}\u{05D0}"
  let para_level = 0
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2069}\u{05D0}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2069}\u{0627}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2069}\u{0627}"
  let para_level = 0
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2069}\u{0627}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2069}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2069}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2069}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2069}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2069}\u{000A}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2069}\u{0009}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2069}\u{0020}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2069}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2069}\u{2066}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2069}\u{2067}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2069}\u{2068}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0660}\u{2069}\u{2069}\u{2069}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 1]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{05D0}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{05D0}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{05D0}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{0627}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{0627}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{0627}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{002B}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{002B}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{002B}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{0024}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{0024}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{002C}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{002C}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{002C}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{0300}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{0300}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{0300}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{0009}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{0009}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{0009}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{0020}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{0020}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{0020}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{0021}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{0021}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{0021}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{2066}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{2066}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{2066}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{2066}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{2066}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{2066}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{2066}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{2068}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{2068}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{2068}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{2068}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{2068}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{2068}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{2068}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{2069}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{2069}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{05D0}\u{2069}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{05D0}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{05D0}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{05D0}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{0627}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{0627}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{0627}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{002B}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{002B}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{002B}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{0024}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{0024}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{0024}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{002C}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{002C}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{002C}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{0300}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{0300}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{0300}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{0009}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{0009}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{0009}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{0020}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{0020}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{0020}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{0021}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{0021}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{0021}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{2066}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{2066}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{2066}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{2066}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{2066}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{2066}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{2066}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{2068}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{2068}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{2068}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{2068}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{2068}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{2068}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{2068}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{2069}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{2069}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0627}\u{2069}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{05D0}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{05D0}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{05D0}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{0627}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{0627}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{0627}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{002B}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{0024}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{002C}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{0300}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{0009}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{0020}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{0021}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{2066}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{2066}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{2066}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{2066}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{2066}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{2066}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{2066}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{2068}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{2068}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{2068}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{2068}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{2068}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{2068}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{2068}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002B}\u{2069}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{05D0}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{05D0}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{05D0}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{0627}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{0627}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{0627}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{002B}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{0024}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{002C}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{0300}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{0009}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{0020}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{0021}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{2066}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{2066}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{2066}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{2066}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{2066}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{2066}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{2066}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{2068}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{2068}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{2068}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{2068}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{2068}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{2068}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{2068}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0024}\u{2069}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{05D0}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{05D0}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{05D0}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{0627}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{0627}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{0627}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{002B}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{0024}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{002C}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{0300}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{0009}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{0020}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{0021}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{2066}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{2066}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{2066}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{2066}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{2066}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{2066}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{2066}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{2068}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{2068}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{2068}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{2068}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{2068}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{2068}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{2068}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{002C}\u{2069}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0009}\u{05D0}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0009}\u{05D0}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0009}\u{05D0}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0009}\u{0627}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0009}\u{0627}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0009}\u{0627}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0009}\u{002B}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0009}\u{0024}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0009}\u{002C}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0009}\u{0300}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0009}\u{0009}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0009}\u{0009}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0009}\u{0009}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
  let input = "\u{0061}\u{0009}\u{0020}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "241" {
  let input = "\u{0061}\u{0009}\u{0021}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "242" {
  let input = "\u{0061}\u{0009}\u{2066}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "243" {
  let input = "\u{0061}\u{0009}\u{2066}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "244" {
  let input = "\u{0061}\u{0009}\u{2066}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "245" {
  let input = "\u{0061}\u{0009}\u{2066}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "246" {
  let input = "\u{0061}\u{0009}\u{2066}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "247" {
  let input = "\u{0061}\u{0009}\u{2066}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "248" {
  let input = "\u{0061}\u{0009}\u{2066}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "249" {
  let input = "\u{0061}\u{0009}\u{2068}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "250" {
  let input = "\u{0061}\u{0009}\u{2068}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "251" {
  let input = "\u{0061}\u{0009}\u{2068}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "252" {
  let input = "\u{0061}\u{0009}\u{2068}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "253" {
  let input = "\u{0061}\u{0009}\u{2068}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "254" {
  let input = "\u{0061}\u{0009}\u{2068}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "255" {
  let input = "\u{0061}\u{0009}\u{2068}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "256" {
  let input = "\u{0061}\u{0009}\u{2069}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "257" {
  let input = "\u{0061}\u{0020}\u{05D0}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "258" {
  let input = "\u{0061}\u{0020}\u{05D0}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "259" {
  let input = "\u{0061}\u{0020}\u{05D0}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "260" {
  let input = "\u{0061}\u{0020}\u{0627}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "261" {
  let input = "\u{0061}\u{0020}\u{0627}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "262" {
  let input = "\u{0061}\u{0020}\u{0627}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "263" {
  let input = "\u{0061}\u{0020}\u{002B}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "264" {
  let input = "\u{0061}\u{0020}\u{0024}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "265" {
  let input = "\u{0061}\u{0020}\u{002C}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "266" {
  let input = "\u{0061}\u{0020}\u{0300}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "267" {
  let input = "\u{0061}\u{0020}\u{0009}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "268" {
  let input = "\u{0061}\u{0020}\u{0009}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "269" {
  let input = "\u{0061}\u{0020}\u{0009}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "270" {
  let input = "\u{0061}\u{0020}\u{0020}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "271" {
  let input = "\u{0061}\u{0020}\u{0021}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "272" {
  let input = "\u{0061}\u{0020}\u{2066}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "273" {
  let input = "\u{0061}\u{0020}\u{2066}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "274" {
  let input = "\u{0061}\u{0020}\u{2066}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "275" {
  let input = "\u{0061}\u{0020}\u{2066}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "276" {
  let input = "\u{0061}\u{0020}\u{2066}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "277" {
  let input = "\u{0061}\u{0020}\u{2066}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "278" {
  let input = "\u{0061}\u{0020}\u{2066}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "279" {
  let input = "\u{0061}\u{0020}\u{2068}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "280" {
  let input = "\u{0061}\u{0020}\u{2068}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "281" {
  let input = "\u{0061}\u{0020}\u{2068}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "282" {
  let input = "\u{0061}\u{0020}\u{2068}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "283" {
  let input = "\u{0061}\u{0020}\u{2068}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "284" {
  let input = "\u{0061}\u{0020}\u{2068}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "285" {
  let input = "\u{0061}\u{0020}\u{2068}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "286" {
  let input = "\u{0061}\u{0020}\u{2069}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "287" {
  let input = "\u{0061}\u{0021}\u{05D0}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "288" {
  let input = "\u{0061}\u{0021}\u{05D0}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "289" {
  let input = "\u{0061}\u{0021}\u{05D0}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "290" {
  let input = "\u{0061}\u{0021}\u{0627}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "291" {
  let input = "\u{0061}\u{0021}\u{0627}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "292" {
  let input = "\u{0061}\u{0021}\u{0627}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "293" {
  let input = "\u{0061}\u{0021}\u{002B}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "294" {
  let input = "\u{0061}\u{0021}\u{0024}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "295" {
  let input = "\u{0061}\u{0021}\u{002C}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "296" {
  let input = "\u{0061}\u{0021}\u{0300}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "297" {
  let input = "\u{0061}\u{0021}\u{0009}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "298" {
  let input = "\u{0061}\u{0021}\u{0020}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "299" {
  let input = "\u{0061}\u{0021}\u{0021}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "300" {
  let input = "\u{0061}\u{0021}\u{2066}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "301" {
  let input = "\u{0061}\u{0021}\u{2066}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "302" {
  let input = "\u{0061}\u{0021}\u{2066}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "303" {
  let input = "\u{0061}\u{0021}\u{2066}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "304" {
  let input = "\u{0061}\u{0021}\u{2066}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "305" {
  let input = "\u{0061}\u{0021}\u{2066}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "306" {
  let input = "\u{0061}\u{0021}\u{2066}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "307" {
  let input = "\u{0061}\u{0021}\u{2068}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "308" {
  let input = "\u{0061}\u{0021}\u{2068}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "309" {
  let input = "\u{0061}\u{0021}\u{2068}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "310" {
  let input = "\u{0061}\u{0021}\u{2068}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "311" {
  let input = "\u{0061}\u{0021}\u{2068}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "312" {
  let input = "\u{0061}\u{0021}\u{2068}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "313" {
  let input = "\u{0061}\u{0021}\u{2068}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "314" {
  let input = "\u{0061}\u{0021}\u{2069}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "315" {
  let input = "\u{0061}\u{2066}\u{0009}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "316" {
  let input = "\u{0061}\u{2066}\u{0009}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "317" {
  let input = "\u{0061}\u{2066}\u{0009}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "318" {
  let input = "\u{0061}\u{2066}\u{0009}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "319" {
  let input = "\u{0061}\u{2066}\u{0009}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "320" {
  let input = "\u{0061}\u{2066}\u{0009}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "321" {
  let input = "\u{0061}\u{2066}\u{0009}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "322" {
  let input = "\u{0061}\u{2066}\u{2069}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "323" {
  let input = "\u{0061}\u{2067}\u{2069}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "324" {
  let input = "\u{0061}\u{2068}\u{0009}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "325" {
  let input = "\u{0061}\u{2068}\u{0009}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "326" {
  let input = "\u{0061}\u{2068}\u{0009}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "327" {
  let input = "\u{0061}\u{2068}\u{0009}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "328" {
  let input = "\u{0061}\u{2068}\u{0009}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "329" {
  let input = "\u{0061}\u{2068}\u{0009}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "330" {
  let input = "\u{0061}\u{2068}\u{0009}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "331" {
  let input = "\u{0061}\u{2068}\u{2069}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "332" {
  let input = "\u{0061}\u{2069}\u{05D0}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "333" {
  let input = "\u{0061}\u{2069}\u{05D0}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "334" {
  let input = "\u{0061}\u{2069}\u{05D0}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "335" {
  let input = "\u{0061}\u{2069}\u{0627}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "336" {
  let input = "\u{0061}\u{2069}\u{0627}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "337" {
  let input = "\u{0061}\u{2069}\u{0627}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "338" {
  let input = "\u{0061}\u{2069}\u{002B}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "339" {
  let input = "\u{0061}\u{2069}\u{0024}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "340" {
  let input = "\u{0061}\u{2069}\u{002C}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "341" {
  let input = "\u{0061}\u{2069}\u{0300}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "342" {
  let input = "\u{0061}\u{2069}\u{0009}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "343" {
  let input = "\u{0061}\u{2069}\u{0009}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "344" {
  let input = "\u{0061}\u{2069}\u{0009}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "345" {
  let input = "\u{0061}\u{2069}\u{0020}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "346" {
  let input = "\u{0061}\u{2069}\u{0021}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "347" {
  let input = "\u{0061}\u{2069}\u{2066}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "348" {
  let input = "\u{0061}\u{2069}\u{2066}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "349" {
  let input = "\u{0061}\u{2069}\u{2066}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "350" {
  let input = "\u{0061}\u{2069}\u{2066}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "351" {
  let input = "\u{0061}\u{2069}\u{2066}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "352" {
  let input = "\u{0061}\u{2069}\u{2066}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "353" {
  let input = "\u{0061}\u{2069}\u{2066}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "354" {
  let input = "\u{0061}\u{2069}\u{2068}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "355" {
  let input = "\u{0061}\u{2069}\u{2068}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "356" {
  let input = "\u{0061}\u{2069}\u{2068}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "357" {
  let input = "\u{0061}\u{2069}\u{2068}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "358" {
  let input = "\u{0061}\u{2069}\u{2068}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "359" {
  let input = "\u{0061}\u{2069}\u{2068}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "360" {
  let input = "\u{0061}\u{2069}\u{2068}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "361" {
  let input = "\u{0061}\u{2069}\u{2069}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "362" {
  let input = "\u{0030}\u{05D0}\u{05D0}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "363" {
  let input = "\u{0030}\u{05D0}\u{05D0}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "364" {
  let input = "\u{0030}\u{05D0}\u{05D0}\u{0030}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "365" {
  let input = "\u{0030}\u{05D0}\u{05D0}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "366" {
  let input = "\u{0030}\u{05D0}\u{05D0}\u{0660}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "367" {
  let input = "\u{0030}\u{05D0}\u{05D0}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "368" {
  let input = "\u{0030}\u{05D0}\u{0627}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "369" {
  let input = "\u{0030}\u{05D0}\u{0627}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "370" {
  let input = "\u{0030}\u{05D0}\u{0627}\u{0030}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "371" {
  let input = "\u{0030}\u{05D0}\u{0627}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "372" {
  let input = "\u{0030}\u{05D0}\u{0627}\u{0660}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "373" {
  let input = "\u{0030}\u{05D0}\u{0627}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "374" {
  let input = "\u{0030}\u{05D0}\u{002B}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "375" {
  let input = "\u{0030}\u{05D0}\u{002B}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "376" {
  let input = "\u{0030}\u{05D0}\u{002B}\u{0030}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "377" {
  let input = "\u{0030}\u{05D0}\u{002B}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "378" {
  let input = "\u{0030}\u{05D0}\u{002B}\u{0660}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "379" {
  let input = "\u{0030}\u{05D0}\u{002B}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "380" {
  let input = "\u{0030}\u{05D0}\u{0024}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "381" {
  let input = "\u{0030}\u{05D0}\u{0024}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "382" {
  let input = "\u{0030}\u{05D0}\u{0024}\u{0660}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "383" {
  let input = "\u{0030}\u{05D0}\u{0024}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "384" {
  let input = "\u{0030}\u{05D0}\u{002C}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "385" {
  let input = "\u{0030}\u{05D0}\u{002C}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "386" {
  let input = "\u{0030}\u{05D0}\u{002C}\u{0030}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "387" {
  let input = "\u{0030}\u{05D0}\u{002C}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "388" {
  let input = "\u{0030}\u{05D0}\u{002C}\u{0660}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "389" {
  let input = "\u{0030}\u{05D0}\u{002C}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "390" {
  let input = "\u{0030}\u{05D0}\u{0300}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "391" {
  let input = "\u{0030}\u{05D0}\u{0300}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "392" {
  let input = "\u{0030}\u{05D0}\u{0300}\u{0030}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "393" {
  let input = "\u{0030}\u{05D0}\u{0300}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "394" {
  let input = "\u{0030}\u{05D0}\u{0300}\u{0660}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "395" {
  let input = "\u{0030}\u{05D0}\u{0300}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "396" {
  let input = "\u{0030}\u{05D0}\u{0009}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "397" {
  let input = "\u{0030}\u{05D0}\u{0009}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "398" {
  let input = "\u{0030}\u{05D0}\u{0009}\u{0030}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "399" {
  let input = "\u{0030}\u{05D0}\u{0009}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "400" {
  let input = "\u{0030}\u{05D0}\u{0009}\u{0660}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "401" {
  let input = "\u{0030}\u{05D0}\u{0009}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "402" {
  let input = "\u{0030}\u{05D0}\u{0020}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "403" {
  let input = "\u{0030}\u{05D0}\u{0020}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "404" {
  let input = "\u{0030}\u{05D0}\u{0020}\u{0030}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "405" {
  let input = "\u{0030}\u{05D0}\u{0020}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "406" {
  let input = "\u{0030}\u{05D0}\u{0020}\u{0660}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "407" {
  let input = "\u{0030}\u{05D0}\u{0020}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "408" {
  let input = "\u{0030}\u{05D0}\u{0021}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "409" {
  let input = "\u{0030}\u{05D0}\u{0021}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "410" {
  let input = "\u{0030}\u{05D0}\u{0021}\u{0030}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "411" {
  let input = "\u{0030}\u{05D0}\u{0021}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "412" {
  let input = "\u{0030}\u{05D0}\u{0021}\u{0660}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "413" {
  let input = "\u{0030}\u{05D0}\u{0021}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "414" {
  let input = "\u{0030}\u{05D0}\u{2066}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "415" {
  let input = "\u{0030}\u{05D0}\u{2066}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "416" {
  let input = "\u{0030}\u{05D0}\u{2066}\u{0030}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "417" {
  let input = "\u{0030}\u{05D0}\u{2066}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "418" {
  let input = "\u{0030}\u{05D0}\u{2066}\u{002B}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "419" {
  let input = "\u{0030}\u{05D0}\u{2066}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "420" {
  let input = "\u{0030}\u{05D0}\u{2066}\u{0024}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "421" {
  let input = "\u{0030}\u{05D0}\u{2066}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "422" {
  let input = "\u{0030}\u{05D0}\u{2066}\u{002C}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "423" {
  let input = "\u{0030}\u{05D0}\u{2066}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "424" {
  let input = "\u{0030}\u{05D0}\u{2066}\u{0300}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "425" {
  let input = "\u{0030}\u{05D0}\u{2066}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "426" {
  let input = "\u{0030}\u{05D0}\u{2066}\u{0021}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "427" {
  let input = "\u{0030}\u{05D0}\u{2066}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "428" {
  let input = "\u{0030}\u{05D0}\u{2068}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "429" {
  let input = "\u{0030}\u{05D0}\u{2068}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "430" {
  let input = "\u{0030}\u{05D0}\u{2068}\u{0030}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "431" {
  let input = "\u{0030}\u{05D0}\u{2068}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "432" {
  let input = "\u{0030}\u{05D0}\u{2068}\u{002B}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "433" {
  let input = "\u{0030}\u{05D0}\u{2068}\u{002B}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "434" {
  let input = "\u{0030}\u{05D0}\u{2068}\u{0024}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "435" {
  let input = "\u{0030}\u{05D0}\u{2068}\u{0024}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "436" {
  let input = "\u{0030}\u{05D0}\u{2068}\u{002C}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "437" {
  let input = "\u{0030}\u{05D0}\u{2068}\u{002C}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "438" {
  let input = "\u{0030}\u{05D0}\u{2068}\u{0300}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "439" {
  let input = "\u{0030}\u{05D0}\u{2068}\u{0300}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "440" {
  let input = "\u{0030}\u{05D0}\u{2068}\u{0021}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "441" {
  let input = "\u{0030}\u{05D0}\u{2068}\u{0021}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "442" {
  let input = "\u{0030}\u{05D0}\u{2069}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "443" {
  let input = "\u{0030}\u{05D0}\u{2069}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "444" {
  let input = "\u{0030}\u{05D0}\u{2069}\u{0030}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "445" {
  let input = "\u{0030}\u{05D0}\u{2069}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "446" {
  let input = "\u{0030}\u{05D0}\u{2069}\u{0660}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "447" {
  let input = "\u{0030}\u{05D0}\u{2069}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "448" {
  let input = "\u{0030}\u{0627}\u{05D0}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "449" {
  let input = "\u{0030}\u{0627}\u{05D0}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "450" {
  let input = "\u{0030}\u{0627}\u{05D0}\u{0030}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "451" {
  let input = "\u{0030}\u{0627}\u{05D0}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "452" {
  let input = "\u{0030}\u{0627}\u{05D0}\u{0660}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "453" {
  let input = "\u{0030}\u{0627}\u{05D0}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "454" {
  let input = "\u{0030}\u{0627}\u{0627}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "455" {
  let input = "\u{0030}\u{0627}\u{0627}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "456" {
  let input = "\u{0030}\u{0627}\u{0627}\u{0030}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "457" {
  let input = "\u{0030}\u{0627}\u{0627}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "458" {
  let input = "\u{0030}\u{0627}\u{0627}\u{0660}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "459" {
  let input = "\u{0030}\u{0627}\u{0627}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "460" {
  let input = "\u{0030}\u{0627}\u{002B}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "461" {
  let input = "\u{0030}\u{0627}\u{002B}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "462" {
  let input = "\u{0030}\u{0627}\u{002B}\u{0030}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "463" {
  let input = "\u{0030}\u{0627}\u{002B}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "464" {
  let input = "\u{0030}\u{0627}\u{002B}\u{0660}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "465" {
  let input = "\u{0030}\u{0627}\u{002B}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "466" {
  let input = "\u{0030}\u{0627}\u{0024}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "467" {
  let input = "\u{0030}\u{0627}\u{0024}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "468" {
  let input = "\u{0030}\u{0627}\u{0024}\u{0030}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "469" {
  let input = "\u{0030}\u{0627}\u{0024}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "470" {
  let input = "\u{0030}\u{0627}\u{0024}\u{0660}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "471" {
  let input = "\u{0030}\u{0627}\u{0024}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "472" {
  let input = "\u{0030}\u{0627}\u{002C}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "473" {
  let input = "\u{0030}\u{0627}\u{002C}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "474" {
  let input = "\u{0030}\u{0627}\u{002C}\u{0030}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "475" {
  let input = "\u{0030}\u{0627}\u{002C}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "476" {
  let input = "\u{0030}\u{0627}\u{002C}\u{0660}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "477" {
  let input = "\u{0030}\u{0627}\u{002C}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "478" {
  let input = "\u{0030}\u{0627}\u{0300}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "479" {
  let input = "\u{0030}\u{0627}\u{0300}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "480" {
  let input = "\u{0030}\u{0627}\u{0300}\u{0030}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "481" {
  let input = "\u{0030}\u{0627}\u{0300}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "482" {
  let input = "\u{0030}\u{0627}\u{0300}\u{0660}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "483" {
  let input = "\u{0030}\u{0627}\u{0300}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "484" {
  let input = "\u{0030}\u{0627}\u{0009}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "485" {
  let input = "\u{0030}\u{0627}\u{0009}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "486" {
  let input = "\u{0030}\u{0627}\u{0009}\u{0030}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "487" {
  let input = "\u{0030}\u{0627}\u{0009}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "488" {
  let input = "\u{0030}\u{0627}\u{0009}\u{0660}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "489" {
  let input = "\u{0030}\u{0627}\u{0009}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "490" {
  let input = "\u{0030}\u{0627}\u{0020}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "491" {
  let input = "\u{0030}\u{0627}\u{0020}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "492" {
  let input = "\u{0030}\u{0627}\u{0020}\u{0030}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "493" {
  let input = "\u{0030}\u{0627}\u{0020}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "494" {
  let input = "\u{0030}\u{0627}\u{0020}\u{0660}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "495" {
  let input = "\u{0030}\u{0627}\u{0020}\u{0660}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "496" {
  let input = "\u{0030}\u{0627}\u{0021}\u{0061}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "497" {
  let input = "\u{0030}\u{0627}\u{0021}\u{0061}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "498" {
  let input = "\u{0030}\u{0627}\u{0021}\u{0030}"
  let para_level = -1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
test "499" {
  let input = "\u{0030}\u{0627}\u{0021}\u{0030}"
  let para_level = 1
  let expected_levels = [2, 1, 1, 2]
  let expected_reorder = [3, 2, 1, 0]

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
