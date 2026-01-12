///|
/// Unicode Bidi Algorithm Conformance Tests - BidiTest.txt Part 57
/// Generated from BidiTest.txt (Unicode 16.0.0)
///
/// Tests the implementation against official Unicode bidi test data.
/// Each test verifies resolved embedding levels and visual reordering.

///|
test "0" {
  let input = "\u{2066}\u{202C}\u{200B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202A}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202A}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202A}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202A}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202A}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202A}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202D}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202D}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202D}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202D}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202D}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202D}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202E}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202E}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202E}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202E}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202E}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202E}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202C}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202C}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202C}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202C}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202C}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{202C}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{200B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{200B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{200B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{200B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{200B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2066}\u{200B}\u{200B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202A}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202A}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202A}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202A}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202A}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202A}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202D}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202D}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202D}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202D}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202D}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202D}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202E}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202E}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202E}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202E}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202E}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202E}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202C}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202C}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202C}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202C}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202C}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{202C}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{200B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{200B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{200B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{200B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{200B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202A}\u{200B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202A}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202A}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202A}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202A}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202A}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202A}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202D}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202D}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202D}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202D}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202D}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202D}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202E}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202E}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202E}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202E}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202E}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202E}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202C}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202C}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202C}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202C}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202C}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{202C}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{200B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{200B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{200B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{200B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{200B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202D}\u{200B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202A}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202A}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202A}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202A}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202A}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202A}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202D}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202D}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202D}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202D}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202D}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202D}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202E}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202E}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202E}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202E}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202E}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202E}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202C}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202C}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202C}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202C}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202C}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{202C}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{200B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{200B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{200B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{200B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{200B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202B}\u{200B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202A}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202A}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202A}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202A}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202A}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202A}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202D}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202D}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202D}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202D}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202D}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202D}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202E}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202E}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202E}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202E}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202E}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202E}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202C}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202C}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202C}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202C}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202C}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{202C}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{200B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{200B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{200B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{200B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{200B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202E}\u{200B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202A}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202A}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202A}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202A}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202A}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202A}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202D}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202D}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202D}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202D}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202D}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202D}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202E}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202E}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202E}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202E}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202E}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202E}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202C}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
  let input = "\u{2067}\u{202C}\u{202C}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "207" {
  let input = "\u{2067}\u{202C}\u{202C}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "208" {
  let input = "\u{2067}\u{202C}\u{202C}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "209" {
  let input = "\u{2067}\u{202C}\u{202C}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "210" {
  let input = "\u{2067}\u{202C}\u{202C}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "211" {
  let input = "\u{2067}\u{202C}\u{200B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "212" {
  let input = "\u{2067}\u{202C}\u{200B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "213" {
  let input = "\u{2067}\u{202C}\u{200B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "214" {
  let input = "\u{2067}\u{202C}\u{200B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "215" {
  let input = "\u{2067}\u{202C}\u{200B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "216" {
  let input = "\u{2067}\u{202C}\u{200B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "217" {
  let input = "\u{2067}\u{200B}\u{202A}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "218" {
  let input = "\u{2067}\u{200B}\u{202A}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "219" {
  let input = "\u{2067}\u{200B}\u{202A}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "220" {
  let input = "\u{2067}\u{200B}\u{202A}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "221" {
  let input = "\u{2067}\u{200B}\u{202A}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "222" {
  let input = "\u{2067}\u{200B}\u{202A}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "223" {
  let input = "\u{2067}\u{200B}\u{202D}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "224" {
  let input = "\u{2067}\u{200B}\u{202D}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "225" {
  let input = "\u{2067}\u{200B}\u{202D}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "226" {
  let input = "\u{2067}\u{200B}\u{202D}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "227" {
  let input = "\u{2067}\u{200B}\u{202D}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "228" {
  let input = "\u{2067}\u{200B}\u{202D}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "229" {
  let input = "\u{2067}\u{200B}\u{202B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "230" {
  let input = "\u{2067}\u{200B}\u{202B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "231" {
  let input = "\u{2067}\u{200B}\u{202B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "232" {
  let input = "\u{2067}\u{200B}\u{202B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "233" {
  let input = "\u{2067}\u{200B}\u{202B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "234" {
  let input = "\u{2067}\u{200B}\u{202B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "235" {
  let input = "\u{2067}\u{200B}\u{202E}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "236" {
  let input = "\u{2067}\u{200B}\u{202E}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "237" {
  let input = "\u{2067}\u{200B}\u{202E}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "238" {
  let input = "\u{2067}\u{200B}\u{202E}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "239" {
  let input = "\u{2067}\u{200B}\u{202E}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "240" {
  let input = "\u{2067}\u{200B}\u{202E}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "241" {
  let input = "\u{2067}\u{200B}\u{202C}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "242" {
  let input = "\u{2067}\u{200B}\u{202C}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "243" {
  let input = "\u{2067}\u{200B}\u{202C}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "244" {
  let input = "\u{2067}\u{200B}\u{202C}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "245" {
  let input = "\u{2067}\u{200B}\u{202C}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "246" {
  let input = "\u{2067}\u{200B}\u{202C}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "247" {
  let input = "\u{2067}\u{200B}\u{200B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "248" {
  let input = "\u{2067}\u{200B}\u{200B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "249" {
  let input = "\u{2067}\u{200B}\u{200B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "250" {
  let input = "\u{2067}\u{200B}\u{200B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "251" {
  let input = "\u{2067}\u{200B}\u{200B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "252" {
  let input = "\u{2067}\u{200B}\u{200B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "253" {
  let input = "\u{2068}\u{202A}\u{202A}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "254" {
  let input = "\u{2068}\u{202A}\u{202A}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "255" {
  let input = "\u{2068}\u{202A}\u{202A}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "256" {
  let input = "\u{2068}\u{202A}\u{202A}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "257" {
  let input = "\u{2068}\u{202A}\u{202A}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "258" {
  let input = "\u{2068}\u{202A}\u{202A}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "259" {
  let input = "\u{2068}\u{202A}\u{202D}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "260" {
  let input = "\u{2068}\u{202A}\u{202D}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "261" {
  let input = "\u{2068}\u{202A}\u{202D}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "262" {
  let input = "\u{2068}\u{202A}\u{202D}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "263" {
  let input = "\u{2068}\u{202A}\u{202D}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "264" {
  let input = "\u{2068}\u{202A}\u{202D}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "265" {
  let input = "\u{2068}\u{202A}\u{202B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "266" {
  let input = "\u{2068}\u{202A}\u{202B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "267" {
  let input = "\u{2068}\u{202A}\u{202B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "268" {
  let input = "\u{2068}\u{202A}\u{202B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "269" {
  let input = "\u{2068}\u{202A}\u{202B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "270" {
  let input = "\u{2068}\u{202A}\u{202B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "271" {
  let input = "\u{2068}\u{202A}\u{202E}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "272" {
  let input = "\u{2068}\u{202A}\u{202E}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "273" {
  let input = "\u{2068}\u{202A}\u{202E}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "274" {
  let input = "\u{2068}\u{202A}\u{202E}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "275" {
  let input = "\u{2068}\u{202A}\u{202E}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "276" {
  let input = "\u{2068}\u{202A}\u{202E}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "277" {
  let input = "\u{2068}\u{202A}\u{202C}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "278" {
  let input = "\u{2068}\u{202A}\u{202C}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "279" {
  let input = "\u{2068}\u{202A}\u{202C}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "280" {
  let input = "\u{2068}\u{202A}\u{202C}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "281" {
  let input = "\u{2068}\u{202A}\u{202C}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "282" {
  let input = "\u{2068}\u{202A}\u{202C}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "283" {
  let input = "\u{2068}\u{202A}\u{200B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "284" {
  let input = "\u{2068}\u{202A}\u{200B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "285" {
  let input = "\u{2068}\u{202A}\u{200B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "286" {
  let input = "\u{2068}\u{202A}\u{200B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "287" {
  let input = "\u{2068}\u{202A}\u{200B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "288" {
  let input = "\u{2068}\u{202A}\u{200B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "289" {
  let input = "\u{2068}\u{202D}\u{202A}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "290" {
  let input = "\u{2068}\u{202D}\u{202A}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "291" {
  let input = "\u{2068}\u{202D}\u{202A}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "292" {
  let input = "\u{2068}\u{202D}\u{202A}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "293" {
  let input = "\u{2068}\u{202D}\u{202A}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "294" {
  let input = "\u{2068}\u{202D}\u{202A}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "295" {
  let input = "\u{2068}\u{202D}\u{202D}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "296" {
  let input = "\u{2068}\u{202D}\u{202D}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "297" {
  let input = "\u{2068}\u{202D}\u{202D}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "298" {
  let input = "\u{2068}\u{202D}\u{202D}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "299" {
  let input = "\u{2068}\u{202D}\u{202D}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "300" {
  let input = "\u{2068}\u{202D}\u{202D}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "301" {
  let input = "\u{2068}\u{202D}\u{202B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "302" {
  let input = "\u{2068}\u{202D}\u{202B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "303" {
  let input = "\u{2068}\u{202D}\u{202B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "304" {
  let input = "\u{2068}\u{202D}\u{202B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "305" {
  let input = "\u{2068}\u{202D}\u{202B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "306" {
  let input = "\u{2068}\u{202D}\u{202B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "307" {
  let input = "\u{2068}\u{202D}\u{202E}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "308" {
  let input = "\u{2068}\u{202D}\u{202E}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "309" {
  let input = "\u{2068}\u{202D}\u{202E}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "310" {
  let input = "\u{2068}\u{202D}\u{202E}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "311" {
  let input = "\u{2068}\u{202D}\u{202E}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "312" {
  let input = "\u{2068}\u{202D}\u{202E}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "313" {
  let input = "\u{2068}\u{202D}\u{202C}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "314" {
  let input = "\u{2068}\u{202D}\u{202C}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "315" {
  let input = "\u{2068}\u{202D}\u{202C}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "316" {
  let input = "\u{2068}\u{202D}\u{202C}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "317" {
  let input = "\u{2068}\u{202D}\u{202C}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "318" {
  let input = "\u{2068}\u{202D}\u{202C}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "319" {
  let input = "\u{2068}\u{202D}\u{200B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "320" {
  let input = "\u{2068}\u{202D}\u{200B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "321" {
  let input = "\u{2068}\u{202D}\u{200B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "322" {
  let input = "\u{2068}\u{202D}\u{200B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "323" {
  let input = "\u{2068}\u{202D}\u{200B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "324" {
  let input = "\u{2068}\u{202D}\u{200B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "325" {
  let input = "\u{2068}\u{202B}\u{202A}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "326" {
  let input = "\u{2068}\u{202B}\u{202A}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "327" {
  let input = "\u{2068}\u{202B}\u{202A}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "328" {
  let input = "\u{2068}\u{202B}\u{202A}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "329" {
  let input = "\u{2068}\u{202B}\u{202A}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "330" {
  let input = "\u{2068}\u{202B}\u{202A}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "331" {
  let input = "\u{2068}\u{202B}\u{202D}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "332" {
  let input = "\u{2068}\u{202B}\u{202D}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "333" {
  let input = "\u{2068}\u{202B}\u{202D}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "334" {
  let input = "\u{2068}\u{202B}\u{202D}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "335" {
  let input = "\u{2068}\u{202B}\u{202D}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "336" {
  let input = "\u{2068}\u{202B}\u{202D}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "337" {
  let input = "\u{2068}\u{202B}\u{202B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "338" {
  let input = "\u{2068}\u{202B}\u{202B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "339" {
  let input = "\u{2068}\u{202B}\u{202B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "340" {
  let input = "\u{2068}\u{202B}\u{202B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "341" {
  let input = "\u{2068}\u{202B}\u{202B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "342" {
  let input = "\u{2068}\u{202B}\u{202B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "343" {
  let input = "\u{2068}\u{202B}\u{202E}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "344" {
  let input = "\u{2068}\u{202B}\u{202E}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "345" {
  let input = "\u{2068}\u{202B}\u{202E}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "346" {
  let input = "\u{2068}\u{202B}\u{202E}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "347" {
  let input = "\u{2068}\u{202B}\u{202E}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "348" {
  let input = "\u{2068}\u{202B}\u{202E}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "349" {
  let input = "\u{2068}\u{202B}\u{202C}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "350" {
  let input = "\u{2068}\u{202B}\u{202C}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "351" {
  let input = "\u{2068}\u{202B}\u{202C}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "352" {
  let input = "\u{2068}\u{202B}\u{202C}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "353" {
  let input = "\u{2068}\u{202B}\u{202C}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "354" {
  let input = "\u{2068}\u{202B}\u{202C}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "355" {
  let input = "\u{2068}\u{202B}\u{200B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "356" {
  let input = "\u{2068}\u{202B}\u{200B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "357" {
  let input = "\u{2068}\u{202B}\u{200B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "358" {
  let input = "\u{2068}\u{202B}\u{200B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "359" {
  let input = "\u{2068}\u{202B}\u{200B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "360" {
  let input = "\u{2068}\u{202B}\u{200B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "361" {
  let input = "\u{2068}\u{202E}\u{202A}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "362" {
  let input = "\u{2068}\u{202E}\u{202A}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "363" {
  let input = "\u{2068}\u{202E}\u{202A}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "364" {
  let input = "\u{2068}\u{202E}\u{202A}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "365" {
  let input = "\u{2068}\u{202E}\u{202A}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "366" {
  let input = "\u{2068}\u{202E}\u{202A}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "367" {
  let input = "\u{2068}\u{202E}\u{202D}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "368" {
  let input = "\u{2068}\u{202E}\u{202D}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "369" {
  let input = "\u{2068}\u{202E}\u{202D}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "370" {
  let input = "\u{2068}\u{202E}\u{202D}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "371" {
  let input = "\u{2068}\u{202E}\u{202D}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "372" {
  let input = "\u{2068}\u{202E}\u{202D}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "373" {
  let input = "\u{2068}\u{202E}\u{202B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "374" {
  let input = "\u{2068}\u{202E}\u{202B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "375" {
  let input = "\u{2068}\u{202E}\u{202B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "376" {
  let input = "\u{2068}\u{202E}\u{202B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "377" {
  let input = "\u{2068}\u{202E}\u{202B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "378" {
  let input = "\u{2068}\u{202E}\u{202B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "379" {
  let input = "\u{2068}\u{202E}\u{202E}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "380" {
  let input = "\u{2068}\u{202E}\u{202E}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "381" {
  let input = "\u{2068}\u{202E}\u{202E}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "382" {
  let input = "\u{2068}\u{202E}\u{202E}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "383" {
  let input = "\u{2068}\u{202E}\u{202E}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "384" {
  let input = "\u{2068}\u{202E}\u{202E}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "385" {
  let input = "\u{2068}\u{202E}\u{202C}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "386" {
  let input = "\u{2068}\u{202E}\u{202C}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "387" {
  let input = "\u{2068}\u{202E}\u{202C}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "388" {
  let input = "\u{2068}\u{202E}\u{202C}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "389" {
  let input = "\u{2068}\u{202E}\u{202C}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "390" {
  let input = "\u{2068}\u{202E}\u{202C}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "391" {
  let input = "\u{2068}\u{202E}\u{200B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "392" {
  let input = "\u{2068}\u{202E}\u{200B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "393" {
  let input = "\u{2068}\u{202E}\u{200B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "394" {
  let input = "\u{2068}\u{202E}\u{200B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "395" {
  let input = "\u{2068}\u{202E}\u{200B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "396" {
  let input = "\u{2068}\u{202E}\u{200B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "397" {
  let input = "\u{2068}\u{202C}\u{202A}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "398" {
  let input = "\u{2068}\u{202C}\u{202A}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "399" {
  let input = "\u{2068}\u{202C}\u{202A}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "400" {
  let input = "\u{2068}\u{202C}\u{202A}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "401" {
  let input = "\u{2068}\u{202C}\u{202A}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "402" {
  let input = "\u{2068}\u{202C}\u{202A}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "403" {
  let input = "\u{2068}\u{202C}\u{202D}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "404" {
  let input = "\u{2068}\u{202C}\u{202D}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "405" {
  let input = "\u{2068}\u{202C}\u{202D}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "406" {
  let input = "\u{2068}\u{202C}\u{202D}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "407" {
  let input = "\u{2068}\u{202C}\u{202D}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "408" {
  let input = "\u{2068}\u{202C}\u{202D}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "409" {
  let input = "\u{2068}\u{202C}\u{202B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "410" {
  let input = "\u{2068}\u{202C}\u{202B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "411" {
  let input = "\u{2068}\u{202C}\u{202B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "412" {
  let input = "\u{2068}\u{202C}\u{202B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "413" {
  let input = "\u{2068}\u{202C}\u{202B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "414" {
  let input = "\u{2068}\u{202C}\u{202B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "415" {
  let input = "\u{2068}\u{202C}\u{202E}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "416" {
  let input = "\u{2068}\u{202C}\u{202E}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "417" {
  let input = "\u{2068}\u{202C}\u{202E}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "418" {
  let input = "\u{2068}\u{202C}\u{202E}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "419" {
  let input = "\u{2068}\u{202C}\u{202E}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "420" {
  let input = "\u{2068}\u{202C}\u{202E}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "421" {
  let input = "\u{2068}\u{202C}\u{202C}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "422" {
  let input = "\u{2068}\u{202C}\u{202C}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "423" {
  let input = "\u{2068}\u{202C}\u{202C}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "424" {
  let input = "\u{2068}\u{202C}\u{202C}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "425" {
  let input = "\u{2068}\u{202C}\u{202C}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "426" {
  let input = "\u{2068}\u{202C}\u{202C}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "427" {
  let input = "\u{2068}\u{202C}\u{200B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "428" {
  let input = "\u{2068}\u{202C}\u{200B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "429" {
  let input = "\u{2068}\u{202C}\u{200B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "430" {
  let input = "\u{2068}\u{202C}\u{200B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "431" {
  let input = "\u{2068}\u{202C}\u{200B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "432" {
  let input = "\u{2068}\u{202C}\u{200B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "433" {
  let input = "\u{2068}\u{200B}\u{202A}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "434" {
  let input = "\u{2068}\u{200B}\u{202A}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "435" {
  let input = "\u{2068}\u{200B}\u{202A}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "436" {
  let input = "\u{2068}\u{200B}\u{202A}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "437" {
  let input = "\u{2068}\u{200B}\u{202A}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "438" {
  let input = "\u{2068}\u{200B}\u{202A}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "439" {
  let input = "\u{2068}\u{200B}\u{202D}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "440" {
  let input = "\u{2068}\u{200B}\u{202D}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "441" {
  let input = "\u{2068}\u{200B}\u{202D}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "442" {
  let input = "\u{2068}\u{200B}\u{202D}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "443" {
  let input = "\u{2068}\u{200B}\u{202D}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "444" {
  let input = "\u{2068}\u{200B}\u{202D}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "445" {
  let input = "\u{2068}\u{200B}\u{202B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "446" {
  let input = "\u{2068}\u{200B}\u{202B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "447" {
  let input = "\u{2068}\u{200B}\u{202B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "448" {
  let input = "\u{2068}\u{200B}\u{202B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "449" {
  let input = "\u{2068}\u{200B}\u{202B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "450" {
  let input = "\u{2068}\u{200B}\u{202B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "451" {
  let input = "\u{2068}\u{200B}\u{202E}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "452" {
  let input = "\u{2068}\u{200B}\u{202E}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "453" {
  let input = "\u{2068}\u{200B}\u{202E}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "454" {
  let input = "\u{2068}\u{200B}\u{202E}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "455" {
  let input = "\u{2068}\u{200B}\u{202E}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "456" {
  let input = "\u{2068}\u{200B}\u{202E}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "457" {
  let input = "\u{2068}\u{200B}\u{202C}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "458" {
  let input = "\u{2068}\u{200B}\u{202C}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "459" {
  let input = "\u{2068}\u{200B}\u{202C}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "460" {
  let input = "\u{2068}\u{200B}\u{202C}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "461" {
  let input = "\u{2068}\u{200B}\u{202C}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "462" {
  let input = "\u{2068}\u{200B}\u{202C}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "463" {
  let input = "\u{2068}\u{200B}\u{200B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "464" {
  let input = "\u{2068}\u{200B}\u{200B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "465" {
  let input = "\u{2068}\u{200B}\u{200B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "466" {
  let input = "\u{2068}\u{200B}\u{200B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "467" {
  let input = "\u{2068}\u{200B}\u{200B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "468" {
  let input = "\u{2068}\u{200B}\u{200B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "469" {
  let input = "\u{2069}\u{202A}\u{202A}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "470" {
  let input = "\u{2069}\u{202A}\u{202A}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "471" {
  let input = "\u{2069}\u{202A}\u{202A}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "472" {
  let input = "\u{2069}\u{202A}\u{202A}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "473" {
  let input = "\u{2069}\u{202A}\u{202A}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "474" {
  let input = "\u{2069}\u{202A}\u{202A}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "475" {
  let input = "\u{2069}\u{202A}\u{202D}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "476" {
  let input = "\u{2069}\u{202A}\u{202D}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "477" {
  let input = "\u{2069}\u{202A}\u{202D}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "478" {
  let input = "\u{2069}\u{202A}\u{202D}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "479" {
  let input = "\u{2069}\u{202A}\u{202D}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "480" {
  let input = "\u{2069}\u{202A}\u{202D}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "481" {
  let input = "\u{2069}\u{202A}\u{202B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "482" {
  let input = "\u{2069}\u{202A}\u{202B}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "483" {
  let input = "\u{2069}\u{202A}\u{202B}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "484" {
  let input = "\u{2069}\u{202A}\u{202B}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "485" {
  let input = "\u{2069}\u{202A}\u{202B}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "486" {
  let input = "\u{2069}\u{202A}\u{202B}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "487" {
  let input = "\u{2069}\u{202A}\u{202E}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "488" {
  let input = "\u{2069}\u{202A}\u{202E}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "489" {
  let input = "\u{2069}\u{202A}\u{202E}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "490" {
  let input = "\u{2069}\u{202A}\u{202E}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "491" {
  let input = "\u{2069}\u{202A}\u{202E}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "492" {
  let input = "\u{2069}\u{202A}\u{202E}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "493" {
  let input = "\u{2069}\u{202A}\u{202C}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "494" {
  let input = "\u{2069}\u{202A}\u{202C}\u{202D}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "495" {
  let input = "\u{2069}\u{202A}\u{202C}\u{202B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "496" {
  let input = "\u{2069}\u{202A}\u{202C}\u{202E}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "497" {
  let input = "\u{2069}\u{202A}\u{202C}\u{202C}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "498" {
  let input = "\u{2069}\u{202A}\u{202C}\u{200B}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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
test "499" {
  let input = "\u{2069}\u{202A}\u{200B}\u{202A}"
  let para_level = 1
  let expected_levels = [1, -1, -1, -1]
  let expected_reorder = [0]

  // Process with appropriate paragraph level
  let result = if para_level < 0 {
    @bidi.process(input)
  } else {
    @bidi.process_with_base_level(input, para_level)
  }

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

