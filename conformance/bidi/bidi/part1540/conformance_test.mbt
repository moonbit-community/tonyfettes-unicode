///|
/// Unicode Bidi Algorithm Conformance Tests - BidiTest.txt Part 1540
/// Generated from BidiTest.txt (Unicode 16.0.0)
///
/// Tests the implementation against official Unicode bidi test data.
/// Each test verifies resolved embedding levels and visual reordering.

///|
struct TestCase {
  number : Int
  input : String
  direction : @bidi.Direction?
  expected_levels : Array[Int]
  expected_reorder : Array[Int]
}

///|
let test_cases : Array[TestCase] = [
  {
    number: 770000,
    input: "\u{2068}\u{0021}\u{202B}\u{0061}\u{202C}\u{05D0}\u{2069}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, 2, -1, 4, -1, 3, 0],
    expected_reorder: [0, 1, 5, 3, 6],
  },
  {
    number: 770001,
    input: "\u{2068}\u{0021}\u{0660}\u{0061}\u{05D0}\u{2069}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 2, 4, 2, 3, 1],
    expected_reorder: [5, 1, 2, 3, 4, 0],
  },
  {
    number: 770002,
    input: "\u{2068}\u{0021}\u{202E}\u{0061}\u{202C}\u{05D0}\u{2069}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 2, -1, 3, -1, 3, 1],
    expected_reorder: [6, 1, 5, 3, 0],
  },
  {
    number: 770003,
    input: "\u{2068}\u{0021}\u{202B}\u{0061}\u{202C}\u{05D0}\u{2069}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 2, -1, 4, -1, 3, 1],
    expected_reorder: [6, 1, 5, 3, 0],
  },
  {
    number: 770004,
    input: "\u{2068}\u{0021}\u{0030}\u{05D0}\u{0061}\u{2069}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 3, 4, 3, 4, 1],
    expected_reorder: [5, 4, 3, 2, 1, 0],
  },
  {
    number: 770005,
    input: "\u{2068}\u{0021}\u{202D}\u{05D0}\u{202C}\u{0061}\u{2069}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 3, -1, 4, -1, 4, 1],
    expected_reorder: [6, 3, 5, 1, 0],
  },
  {
    number: 770006,
    input: "\u{2068}\u{0021}\u{202A}\u{05D0}\u{202C}\u{0061}\u{2069}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 3, -1, 5, -1, 4, 1],
    expected_reorder: [6, 3, 5, 1, 0],
  },
  {
    number: 770007,
    input: "\u{05D0}\u{05D0}\u{05D0}\u{0020}\u{0024}\u{0030}\u{0030}",
    direction: None,
    expected_levels: [1, 1, 1, 1, 2, 2, 2],
    expected_reorder: [4, 5, 6, 3, 2, 1, 0],
  },
  {
    number: 770008,
    input: "\u{05D0}\u{05D0}\u{05D0}\u{0020}\u{0024}\u{0030}\u{0030}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [1, 1, 1, 1, 2, 2, 2],
    expected_reorder: [4, 5, 6, 3, 2, 1, 0],
  },
  {
    number: 770009,
    input: "\u{05D0}\u{05D0}\u{05D0}\u{0020}\u{0024}\u{0030}\u{0030}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 1, 1, 1, 2, 2, 2],
    expected_reorder: [4, 5, 6, 3, 2, 1, 0],
  },
  {
    number: 770010,
    input: "\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{05D0}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, 0, 2, 0, 0, 2, 0, 1],
    expected_reorder: [0, 1, 2, 3, 4, 5, 6, 7],
  },
  {
    number: 770011,
    input: "\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{05D0}",
    direction: None,
    expected_levels: [1, 1, 2, 1, 1, 2, 1, 1],
    expected_reorder: [7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770012,
    input: "\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{05D0}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 1, 2, 1, 1, 2, 1, 1],
    expected_reorder: [7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770013,
    input: "\u{0021}\u{2068}\u{05D0}\u{0627}\u{2069}\u{2067}\u{05D0}\u{0627}\u{2069}",
    direction: None,
    expected_levels: [0, 0, 1, 1, 0, 0, 1, 1, 0],
    expected_reorder: [0, 1, 3, 2, 4, 5, 7, 6, 8],
  },
  {
    number: 770014,
    input: "\u{0021}\u{2068}\u{05D0}\u{0627}\u{2069}\u{2067}\u{05D0}\u{0627}\u{2069}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, 0, 1, 1, 0, 0, 1, 1, 0],
    expected_reorder: [0, 1, 3, 2, 4, 5, 7, 6, 8],
  },
  {
    number: 770015,
    input: "\u{0021}\u{2068}\u{05D0}\u{0627}\u{2069}\u{2067}\u{05D0}\u{0627}\u{2069}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 1, 3, 3, 1, 1, 3, 3, 1],
    expected_reorder: [8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770016,
    input: "\u{0024}\u{2066}\u{2069}\u{0030}\u{2067}\u{2069}\u{0024}\u{2068}\u{2069}\u{0030}",
    direction: None,
    expected_levels: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    expected_reorder: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
  },
  {
    number: 770017,
    input: "\u{0024}\u{2066}\u{2069}\u{0030}\u{2067}\u{2069}\u{0024}\u{2068}\u{2069}\u{0030}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    expected_reorder: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
  },
  {
    number: 770018,
    input: "\u{2068}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{05D0}\u{2069}",
    direction: None,
    expected_levels: [0, 1, 1, 2, 1, 1, 2, 1, 1, 0],
    expected_reorder: [0, 8, 7, 6, 5, 4, 3, 2, 1, 9],
  },
  {
    number: 770019,
    input: "\u{2068}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{05D0}\u{2069}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, 1, 1, 2, 1, 1, 2, 1, 1, 0],
    expected_reorder: [0, 8, 7, 6, 5, 4, 3, 2, 1, 9],
  },
  {
    number: 770020,
    input: "\u{2068}\u{0021}\u{2068}\u{05D0}\u{2069}\u{2067}\u{05D0}\u{2069}\u{0061}\u{2069}",
    direction: None,
    expected_levels: [0, 2, 2, 3, 2, 2, 3, 2, 2, 0],
    expected_reorder: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
  },
  {
    number: 770021,
    input: "\u{2068}\u{0021}\u{2068}\u{05D0}\u{2069}\u{2067}\u{05D0}\u{2069}\u{0061}\u{2069}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, 2, 2, 3, 2, 2, 3, 2, 2, 0],
    expected_reorder: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
  },
  {
    number: 770022,
    input: "\u{0024}\u{2066}\u{2069}\u{0030}\u{2067}\u{2069}\u{0024}\u{2068}\u{2069}\u{0030}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 1, 1, 2, 1, 1, 1, 1, 1, 2],
    expected_reorder: [9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770023,
    input: "\u{2068}\u{0021}\u{2068}\u{05D0}\u{2069}\u{2067}\u{05D0}\u{2069}\u{0061}\u{2069}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 2, 2, 3, 2, 2, 3, 2, 2, 1],
    expected_reorder: [9, 1, 2, 3, 4, 5, 6, 7, 8, 0],
  },
  {
    number: 770024,
    input: "\u{2068}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{05D0}\u{2069}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 3, 3, 4, 3, 3, 4, 3, 3, 1],
    expected_reorder: [9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770025,
    input: "\u{0021}\u{202A}\u{0021}\u{202B}\u{0021}\u{202D}\u{05D0}\u{202E}\u{0061}\u{2069}\u{0061}\u{202C}\u{05D0}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, -1, 2, -1, 3, -1, 4, -1, 5, 5, 5, -1, 4],
    expected_reorder: [0, 2, 6, 10, 9, 8, 12, 4],
  },
  {
    number: 770026,
    input: "\u{0021}\u{202A}\u{0021}\u{202B}\u{0021}\u{202D}\u{05D0}\u{202E}\u{0061}\u{2069}\u{0061}\u{202C}\u{05D0}",
    direction: None,
    expected_levels: [1, -1, 2, -1, 3, -1, 4, -1, 5, 5, 5, -1, 4],
    expected_reorder: [2, 6, 10, 9, 8, 12, 4, 0],
  },
  {
    number: 770027,
    input: "\u{0021}\u{202A}\u{0021}\u{202B}\u{0021}\u{202D}\u{05D0}\u{202E}\u{0061}\u{2069}\u{0061}\u{202C}\u{05D0}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, -1, 2, -1, 3, -1, 4, -1, 5, 5, 5, -1, 4],
    expected_reorder: [2, 6, 10, 9, 8, 12, 4, 0],
  },
  {
    number: 770028,
    input: "\u{0021}\u{0030}\u{0030}\u{0021}\u{0020}\u{0627}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0627}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1],
    expected_reorder: [0, 1, 2, 3, 4, 10, 9, 8, 7, 6, 5],
  },
  {
    number: 770029,
    input: "\u{0061}\u{2066}\u{05D0}\u{2069}\u{2068}\u{05D0}\u{2069}\u{2067}\u{05D0}\u{2069}\u{05D0}",
    direction: None,
    expected_levels: [0, 0, 3, 0, 0, 1, 0, 0, 1, 0, 1],
    expected_reorder: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
  },
  {
    number: 770030,
    input: "\u{0061}\u{2066}\u{05D0}\u{2069}\u{2068}\u{05D0}\u{2069}\u{2067}\u{05D0}\u{2069}\u{05D0}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, 0, 3, 0, 0, 1, 0, 0, 1, 0, 1],
    expected_reorder: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
  },
  {
    number: 770031,
    input: "\u{05D0}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0061}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [1, 0, 2, 0, 0, 2, 0, 0, 2, 0, 0],
    expected_reorder: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
  },
  {
    number: 770032,
    input: "\u{0627}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0030}\u{0030}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 0],
    expected_reorder: [8, 9, 7, 6, 5, 4, 3, 2, 1, 0, 10],
  },
  {
    number: 770033,
    input: "\u{0627}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0030}\u{0030}\u{0021}",
    direction: None,
    expected_levels: [1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1],
    expected_reorder: [10, 8, 9, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770034,
    input: "\u{0627}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0030}\u{0030}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1],
    expected_reorder: [10, 8, 9, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770035,
    input: "\u{05D0}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0061}",
    direction: None,
    expected_levels: [1, 1, 2, 1, 1, 2, 1, 1, 4, 1, 2],
    expected_reorder: [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770036,
    input: "\u{05D0}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0061}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 1, 2, 1, 1, 2, 1, 1, 4, 1, 2],
    expected_reorder: [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770037,
    input: "\u{0021}\u{0030}\u{0030}\u{0021}\u{0020}\u{0627}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0627}",
    direction: None,
    expected_levels: [1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1],
    expected_reorder: [10, 9, 8, 7, 6, 5, 4, 3, 1, 2, 0],
  },
  {
    number: 770038,
    input: "\u{0021}\u{0030}\u{0030}\u{0021}\u{0020}\u{0627}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0627}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1],
    expected_reorder: [10, 9, 8, 7, 6, 5, 4, 3, 1, 2, 0],
  },
  {
    number: 770039,
    input: "\u{0061}\u{2066}\u{05D0}\u{2069}\u{2068}\u{05D0}\u{2069}\u{2067}\u{05D0}\u{2069}\u{05D0}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [2, 1, 3, 1, 1, 3, 1, 1, 3, 1, 1],
    expected_reorder: [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770040,
    input: "\u{202B}\u{202A}\u{202E}\u{202D}\u{2067}\u{0021}\u{202D}\u{05D0}\u{202C}\u{0021}\u{202C}\u{0021}\u{2069}\u{05D0}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [-1, -1, -1, -1, 4, 5, -1, 6, -1, 5, -1, 5, 4, 4],
    expected_reorder: [4, 11, 9, 7, 5, 12, 13],
  },
  {
    number: 770041,
    input: "\u{202B}\u{202A}\u{202E}\u{202D}\u{2068}\u{05D0}\u{202D}\u{05D0}\u{202C}\u{0021}\u{202C}\u{0021}\u{2069}\u{05D0}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [-1, -1, -1, -1, 4, 5, -1, 6, -1, 5, -1, 5, 4, 4],
    expected_reorder: [4, 11, 9, 7, 5, 12, 13],
  },
  {
    number: 770042,
    input: "\u{202A}\u{202B}\u{202D}\u{202E}\u{2066}\u{0021}\u{202E}\u{0061}\u{202C}\u{0021}\u{202C}\u{0021}\u{2069}\u{0061}",
    direction: None,
    expected_levels: [-1, -1, -1, -1, 5, 6, -1, 7, -1, 6, -1, 6, 5, 5],
    expected_reorder: [13, 12, 5, 7, 9, 11, 4],
  },
  {
    number: 770043,
    input: "\u{202A}\u{202B}\u{202D}\u{202E}\u{2066}\u{0021}\u{202E}\u{0061}\u{202C}\u{0021}\u{202C}\u{0021}\u{2069}\u{0061}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [-1, -1, -1, -1, 5, 6, -1, 7, -1, 6, -1, 6, 5, 5],
    expected_reorder: [13, 12, 5, 7, 9, 11, 4],
  },
  {
    number: 770044,
    input: "\u{202A}\u{202B}\u{202D}\u{202E}\u{2066}\u{0021}\u{202E}\u{0061}\u{202C}\u{0021}\u{202C}\u{0021}\u{2069}\u{0061}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [-1, -1, -1, -1, 5, 6, -1, 7, -1, 6, -1, 6, 5, 5],
    expected_reorder: [13, 12, 5, 7, 9, 11, 4],
  },
  {
    number: 770045,
    input: "\u{202B}\u{202A}\u{202E}\u{202D}\u{2067}\u{0021}\u{202D}\u{05D0}\u{202C}\u{0021}\u{202C}\u{0021}\u{2069}\u{05D0}",
    direction: None,
    expected_levels: [-1, -1, -1, -1, 6, 7, -1, 8, -1, 7, -1, 7, 6, 6],
    expected_reorder: [4, 11, 9, 7, 5, 12, 13],
  },
  {
    number: 770046,
    input: "\u{202B}\u{202A}\u{202E}\u{202D}\u{2067}\u{0021}\u{202D}\u{05D0}\u{202C}\u{0021}\u{202C}\u{0021}\u{2069}\u{05D0}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [-1, -1, -1, -1, 6, 7, -1, 8, -1, 7, -1, 7, 6, 6],
    expected_reorder: [4, 11, 9, 7, 5, 12, 13],
  },
  {
    number: 770047,
    input: "\u{202B}\u{202A}\u{202E}\u{202D}\u{2068}\u{05D0}\u{202D}\u{05D0}\u{202C}\u{0021}\u{202C}\u{0021}\u{2069}\u{05D0}",
    direction: None,
    expected_levels: [-1, -1, -1, -1, 6, 7, -1, 8, -1, 7, -1, 7, 6, 6],
    expected_reorder: [4, 11, 9, 7, 5, 12, 13],
  },
  {
    number: 770048,
    input: "\u{202B}\u{202A}\u{202E}\u{202D}\u{2068}\u{05D0}\u{202D}\u{05D0}\u{202C}\u{0021}\u{202C}\u{0021}\u{2069}\u{05D0}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [-1, -1, -1, -1, 6, 7, -1, 8, -1, 7, -1, 7, 6, 6],
    expected_reorder: [4, 11, 9, 7, 5, 12, 13],
  },
  {
    number: 770049,
    input: "\u{0021}\u{202B}\u{0021}\u{2066}\u{0021}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}",
    direction: None,
    expected_levels: [0, -1, 1, 1, 2, -1, 3, -1, 2, 1, 1, -1, 0],
    expected_reorder: [0, 10, 9, 4, 6, 8, 3, 2, 12],
  },
  {
    number: 770050,
    input: "\u{0021}\u{202B}\u{0021}\u{2066}\u{0021}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, -1, 1, 1, 2, -1, 3, -1, 2, 1, 1, -1, 0],
    expected_reorder: [0, 10, 9, 4, 6, 8, 3, 2, 12],
  },
  {
    number: 770051,
    input: "\u{0021}\u{202B}\u{0021}\u{2067}\u{0021}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}",
    direction: None,
    expected_levels: [0, -1, 1, 1, 3, -1, 5, -1, 3, 1, 1, -1, 0],
    expected_reorder: [0, 10, 9, 8, 6, 4, 3, 2, 12],
  },
  {
    number: 770052,
    input: "\u{0021}\u{202B}\u{0021}\u{2067}\u{0021}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, -1, 1, 1, 3, -1, 5, -1, 3, 1, 1, -1, 0],
    expected_reorder: [0, 10, 9, 8, 6, 4, 3, 2, 12],
  },
  {
    number: 770053,
    input: "\u{0021}\u{202A}\u{0021}\u{2067}\u{0021}\u{202D}\u{05D0}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}",
    direction: None,
    expected_levels: [0, -1, 2, 2, 3, -1, 4, -1, 3, 2, 2, -1, 0],
    expected_reorder: [0, 2, 3, 8, 6, 4, 9, 10, 12],
  },
  {
    number: 770054,
    input: "\u{0021}\u{202A}\u{0021}\u{2067}\u{0021}\u{202D}\u{05D0}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, -1, 2, 2, 3, -1, 4, -1, 3, 2, 2, -1, 0],
    expected_reorder: [0, 2, 3, 8, 6, 4, 9, 10, 12],
  },
  {
    number: 770055,
    input: "\u{0021}\u{202A}\u{0021}\u{2066}\u{0021}\u{202D}\u{05D0}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}",
    direction: None,
    expected_levels: [0, -1, 2, 2, 4, -1, 6, -1, 4, 2, 2, -1, 0],
    expected_reorder: [0, 2, 3, 4, 6, 8, 9, 10, 12],
  },
  {
    number: 770056,
    input: "\u{0021}\u{202A}\u{0021}\u{2066}\u{0021}\u{202D}\u{05D0}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, -1, 2, 2, 4, -1, 6, -1, 4, 2, 2, -1, 0],
    expected_reorder: [0, 2, 3, 4, 6, 8, 9, 10, 12],
  },
  {
    number: 770057,
    input: "\u{0021}\u{202A}\u{0021}\u{2067}\u{0021}\u{202D}\u{05D0}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, -1, 2, 2, 3, -1, 4, -1, 3, 2, 2, -1, 1],
    expected_reorder: [12, 2, 3, 8, 6, 4, 9, 10, 0],
  },
  {
    number: 770058,
    input: "\u{0021}\u{202A}\u{0021}\u{2066}\u{0021}\u{202D}\u{05D0}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, -1, 2, 2, 4, -1, 6, -1, 4, 2, 2, -1, 1],
    expected_reorder: [12, 2, 3, 4, 6, 8, 9, 10, 0],
  },
  {
    number: 770059,
    input: "\u{0021}\u{202B}\u{0021}\u{2066}\u{0021}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, -1, 3, 3, 4, -1, 5, -1, 4, 3, 3, -1, 1],
    expected_reorder: [12, 10, 9, 4, 6, 8, 3, 2, 0],
  },
  {
    number: 770060,
    input: "\u{0021}\u{202B}\u{0021}\u{2067}\u{0021}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, -1, 3, 3, 5, -1, 7, -1, 5, 3, 3, -1, 1],
    expected_reorder: [12, 10, 9, 8, 6, 4, 3, 2, 0],
  },
  {
    number: 770061,
    input: "\u{0021}\u{202B}\u{0021}\u{2068}\u{0021}\u{0061}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}",
    direction: None,
    expected_levels: [0, -1, 1, 1, 2, 2, -1, 3, -1, 2, 1, 1, -1, 0],
    expected_reorder: [0, 11, 10, 4, 5, 7, 9, 3, 2, 13],
  },
  {
    number: 770062,
    input: "\u{0021}\u{202B}\u{0021}\u{2068}\u{0021}\u{0061}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, -1, 1, 1, 2, 2, -1, 3, -1, 2, 1, 1, -1, 0],
    expected_reorder: [0, 11, 10, 4, 5, 7, 9, 3, 2, 13],
  },
  {
    number: 770063,
    input: "\u{0021}\u{202B}\u{0021}\u{2068}\u{0021}\u{05D0}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}",
    direction: None,
    expected_levels: [0, -1, 1, 1, 3, 3, -1, 5, -1, 3, 1, 1, -1, 0],
    expected_reorder: [0, 11, 10, 9, 7, 5, 4, 3, 2, 13],
  },
  {
    number: 770064,
    input: "\u{0021}\u{202B}\u{0021}\u{2068}\u{0021}\u{05D0}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, -1, 1, 1, 3, 3, -1, 5, -1, 3, 1, 1, -1, 0],
    expected_reorder: [0, 11, 10, 9, 7, 5, 4, 3, 2, 13],
  },
  {
    number: 770065,
    input: "\u{0021}\u{202B}\u{0021}\u{2068}\u{0021}\u{0061}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, -1, 3, 3, 4, 4, -1, 5, -1, 4, 3, 3, -1, 1],
    expected_reorder: [13, 11, 10, 4, 5, 7, 9, 3, 2, 0],
  },
  {
    number: 770066,
    input: "\u{0021}\u{202B}\u{0021}\u{2068}\u{0021}\u{05D0}\u{202E}\u{0061}\u{202C}\u{0021}\u{2069}\u{0021}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, -1, 3, 3, 5, 5, -1, 7, -1, 5, 3, 3, -1, 1],
    expected_reorder: [13, 11, 10, 9, 7, 5, 4, 3, 2, 0],
  },
  {
    number: 770067,
    input: "\u{0030}\u{002B}\u{2066}\u{2069}\u{0030}\u{002B}\u{2067}\u{2069}\u{0030}\u{002B}\u{2068}\u{2069}\u{0030}",
    direction: None,
    expected_levels: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    expected_reorder: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
  },
  {
    number: 770068,
    input: "\u{0030}\u{002B}\u{2066}\u{2069}\u{0030}\u{002B}\u{2067}\u{2069}\u{0030}\u{002B}\u{2068}\u{2069}\u{0030}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    expected_reorder: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
  },
  {
    number: 770069,
    input: "\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{202D}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{202C}",
    direction: None,
    expected_levels: [0, 0, 0, 0, 0, 0, 0, 0, -1, 2, 2, 2, 2, -1],
    expected_reorder: [0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12],
  },
  {
    number: 770070,
    input: "\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{202D}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{202C}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, 0, 0, 0, 0, 0, 0, 0, -1, 2, 2, 2, 2, -1],
    expected_reorder: [0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12],
  },
  {
    number: 770071,
    input: "\u{0061}\u{0021}\u{2068}\u{05D0}\u{2069}\u{2067}\u{05D0}\u{2069}\u{2066}\u{0627}\u{2069}\u{0021}\u{0061}",
    direction: None,
    expected_levels: [0, 0, 0, 1, 0, 0, 1, 0, 0, 3, 0, 0, 0],
    expected_reorder: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
  },
  {
    number: 770072,
    input: "\u{0061}\u{0021}\u{2068}\u{05D0}\u{2069}\u{2067}\u{05D0}\u{2069}\u{2066}\u{0627}\u{2069}\u{0021}\u{0061}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, 0, 0, 1, 0, 0, 1, 0, 0, 3, 0, 0, 0],
    expected_reorder: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
  },
  {
    number: 770073,
    input: "\u{0061}\u{2068}\u{05D0}\u{0020}\u{2069}\u{0020}\u{2067}\u{0020}\u{2066}\u{0020}\u{2069}\u{2069}\u{0020}",
    direction: None,
    expected_levels: [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    expected_reorder: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
  },
  {
    number: 770074,
    input: "\u{0061}\u{2068}\u{05D0}\u{0020}\u{2069}\u{0020}\u{2067}\u{0020}\u{2066}\u{0020}\u{2069}\u{2069}\u{0020}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    expected_reorder: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
  },
  {
    number: 770075,
    input: "\u{0021}\u{2066}\u{0021}\u{2067}\u{0021}\u{2068}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}",
    direction: None,
    expected_levels: [0, 0, 2, 2, 3, 3, 4, 3, 3, 2, 2, 0, 0],
    expected_reorder: [0, 1, 2, 3, 8, 7, 6, 5, 4, 9, 10, 11, 12],
  },
  {
    number: 770076,
    input: "\u{0021}\u{2066}\u{0021}\u{2067}\u{0021}\u{2068}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, 0, 2, 2, 3, 3, 4, 3, 3, 2, 2, 0, 0],
    expected_reorder: [0, 1, 2, 3, 8, 7, 6, 5, 4, 9, 10, 11, 12],
  },
  {
    number: 770077,
    input: "\u{05D0}\u{2068}\u{0061}\u{0020}\u{2069}\u{0020}\u{2066}\u{0020}\u{2067}\u{0020}\u{2069}\u{2069}\u{0020}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [1, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    expected_reorder: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
  },
  {
    number: 770078,
    input: "\u{05D0}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0021}\u{05D0}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [1, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 1],
    expected_reorder: [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770079,
    input: "\u{05D0}\u{0021}\u{2066}\u{0061}\u{2069}\u{2068}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0021}\u{0030}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [1, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2],
    expected_reorder: [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770080,
    input: "\u{05D0}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0021}\u{05D0}",
    direction: None,
    expected_levels: [1, 1, 1, 2, 1, 1, 2, 1, 1, 4, 1, 1, 1],
    expected_reorder: [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770081,
    input: "\u{05D0}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0021}\u{05D0}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 1, 1, 2, 1, 1, 2, 1, 1, 4, 1, 1, 1],
    expected_reorder: [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770082,
    input: "\u{05D0}\u{0021}\u{2066}\u{0061}\u{2069}\u{2068}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0021}\u{0030}",
    direction: None,
    expected_levels: [1, 1, 1, 2, 1, 1, 2, 1, 1, 4, 1, 1, 2],
    expected_reorder: [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770083,
    input: "\u{05D0}\u{0021}\u{2066}\u{0061}\u{2069}\u{2068}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0021}\u{0030}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 1, 1, 2, 1, 1, 2, 1, 1, 4, 1, 1, 2],
    expected_reorder: [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770084,
    input: "\u{05D0}\u{2068}\u{0061}\u{0020}\u{2069}\u{0020}\u{2066}\u{0020}\u{2067}\u{0020}\u{2069}\u{2069}\u{0020}",
    direction: None,
    expected_levels: [1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    expected_reorder: [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770085,
    input: "\u{05D0}\u{2068}\u{0061}\u{0020}\u{2069}\u{0020}\u{2066}\u{0020}\u{2067}\u{0020}\u{2069}\u{2069}\u{0020}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    expected_reorder: [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770086,
    input: "\u{0021}\u{2066}\u{0021}\u{2067}\u{0021}\u{2068}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 1, 2, 2, 3, 3, 4, 3, 3, 2, 2, 1, 1],
    expected_reorder: [12, 11, 2, 3, 8, 7, 6, 5, 4, 9, 10, 1, 0],
  },
  {
    number: 770087,
    input: "\u{0030}\u{002B}\u{2066}\u{2069}\u{0030}\u{002B}\u{2067}\u{2069}\u{0030}\u{002B}\u{2068}\u{2069}\u{0030}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [2, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 2],
    expected_reorder: [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770088,
    input: "\u{0660}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0021}\u{0627}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [2, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 1],
    expected_reorder: [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770089,
    input: "\u{0660}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0021}\u{0627}",
    direction: None,
    expected_levels: [2, 1, 1, 2, 1, 1, 2, 1, 1, 4, 1, 1, 1],
    expected_reorder: [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770090,
    input: "\u{0660}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{0061}\u{2069}\u{0021}\u{0627}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [2, 1, 1, 2, 1, 1, 2, 1, 1, 4, 1, 1, 1],
    expected_reorder: [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770091,
    input: "\u{0061}\u{2068}\u{05D0}\u{0020}\u{2069}\u{0020}\u{2067}\u{0020}\u{2066}\u{0020}\u{2069}\u{2069}\u{0020}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [2, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    expected_reorder: [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770092,
    input: "\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{202D}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{202C}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [2, 2, 2, 2, 2, 2, 2, 2, -1, 2, 2, 2, 2, -1],
    expected_reorder: [0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12],
  },
  {
    number: 770093,
    input: "\u{0061}\u{0021}\u{2068}\u{05D0}\u{2069}\u{2067}\u{05D0}\u{2069}\u{2066}\u{0627}\u{2069}\u{0021}\u{0061}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [2, 2, 2, 3, 2, 2, 3, 2, 2, 3, 2, 2, 2],
    expected_reorder: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
  },
  {
    number: 770094,
    input: "\u{0021}\u{2067}\u{0021}\u{2068}\u{0021}\u{05D0}\u{2066}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}",
    direction: None,
    expected_levels: [0, 0, 1, 1, 3, 3, 3, 4, 3, 3, 1, 1, 0, 0],
    expected_reorder: [0, 1, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 12, 13],
  },
  {
    number: 770095,
    input: "\u{0021}\u{2067}\u{0021}\u{2068}\u{0021}\u{05D0}\u{2066}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, 0, 1, 1, 3, 3, 3, 4, 3, 3, 1, 1, 0, 0],
    expected_reorder: [0, 1, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 12, 13],
  },
  {
    number: 770096,
    input: "\u{0627}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{05D0}\u{2069}\u{0021}\u{0024}\u{0030}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2],
    expected_reorder: [13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770097,
    input: "\u{0627}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{05D0}\u{2069}\u{0021}\u{0024}\u{0030}",
    direction: None,
    expected_levels: [1, 1, 1, 2, 1, 1, 2, 1, 1, 3, 1, 1, 1, 2],
    expected_reorder: [13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770098,
    input: "\u{0627}\u{0021}\u{2068}\u{0061}\u{2069}\u{2066}\u{0061}\u{2069}\u{2067}\u{05D0}\u{2069}\u{0021}\u{0024}\u{0030}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 1, 1, 2, 1, 1, 2, 1, 1, 3, 1, 1, 1, 2],
    expected_reorder: [13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770099,
    input: "\u{0021}\u{2067}\u{0021}\u{2068}\u{0021}\u{05D0}\u{2066}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}\u{2069}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 1, 3, 3, 5, 5, 5, 6, 5, 5, 3, 3, 1, 1],
    expected_reorder: [13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770100,
    input: "\u{0061}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0020}\u{202D}\u{202C}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{002B}",
    direction: None,
    expected_levels: [0, 0, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, 1, 1, 0],
    expected_reorder: [0, 1, 14, 13, 12, 11, 8, 7, 6, 5, 4, 3, 2, 15],
  },
  {
    number: 770101,
    input: "\u{0061}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0020}\u{202D}\u{202C}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{002B}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, 0, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, 1, 1, 0],
    expected_reorder: [0, 1, 14, 13, 12, 11, 8, 7, 6, 5, 4, 3, 2, 15],
  },
  {
    number: 770102,
    input: "\u{0061}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0020}\u{202D}\u{202C}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{002B}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [2, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, 1, 1, 1],
    expected_reorder: [15, 14, 13, 12, 11, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770103,
    input: "\u{0627}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{202A}\u{202C}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, 1, 1, 0],
    expected_reorder: [15, 14, 13, 12, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 16],
  },
  {
    number: 770104,
    input: "\u{0627}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{202A}\u{202C}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0021}",
    direction: None,
    expected_levels: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, 1, 1, 1],
    expected_reorder: [16, 15, 14, 13, 12, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770105,
    input: "\u{0627}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{202A}\u{202C}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, 1, 1, 1],
    expected_reorder: [16, 15, 14, 13, 12, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  },
  {
    number: 770106,
    input: "\u{0061}\u{0061}\u{0061}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0009}\u{05D0}\u{0030}\u{0020}\u{0009}\u{0009}\u{0061}\u{0061}\u{0061}",
    direction: None,
    expected_levels: [0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 2, 0, 0, 0, 0, 0, 0],
    expected_reorder: [0, 1, 2, 3, 7, 6, 5, 4, 8, 10, 9, 11, 12, 13, 14, 15, 16],
  },
  {
    number: 770107,
    input: "\u{0061}\u{0061}\u{0061}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0009}\u{05D0}\u{0030}\u{0020}\u{0009}\u{0009}\u{0061}\u{0061}\u{0061}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 2, 0, 0, 0, 0, 0, 0],
    expected_reorder: [0, 1, 2, 3, 7, 6, 5, 4, 8, 10, 9, 11, 12, 13, 14, 15, 16],
  },
  {
    number: 770108,
    input: "\u{05D0}\u{05D0}\u{0627}\u{0020}\u{202B}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{202A}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0061}\u{0061}\u{0061}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [1, 1, 1, 1, -1, 2, 2, 2, 2, 2, -1, 3, 3, 3, 2, 2, 2, 2],
    expected_reorder: [5, 6, 7, 8, 9, 13, 12, 11, 14, 15, 16, 17, 3, 2, 1, 0],
  },
  {
    number: 770109,
    input: "\u{05D0}\u{05D0}\u{0627}\u{0020}\u{202B}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{202A}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0061}\u{0061}\u{0061}",
    direction: None,
    expected_levels: [1, 1, 1, 1, -1, 4, 4, 4, 4, 4, -1, 5, 5, 5, 4, 4, 4, 4],
    expected_reorder: [5, 6, 7, 8, 9, 13, 12, 11, 14, 15, 16, 17, 3, 2, 1, 0],
  },
  {
    number: 770110,
    input: "\u{05D0}\u{05D0}\u{0627}\u{0020}\u{202B}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{202A}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0061}\u{0061}\u{0061}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 1, 1, 1, -1, 4, 4, 4, 4, 4, -1, 5, 5, 5, 4, 4, 4, 4],
    expected_reorder: [5, 6, 7, 8, 9, 13, 12, 11, 14, 15, 16, 17, 3, 2, 1, 0],
  },
  {
    number: 770111,
    input: "\u{0061}\u{0061}\u{0061}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0009}\u{05D0}\u{0030}\u{0020}\u{0009}\u{0009}\u{0061}\u{0061}\u{0061}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 2, 2],
    expected_reorder: [14, 15, 16, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 0, 1, 2],
  },
  {
    number: 770112,
    input: "\u{05D0}\u{0627}\u{05D0}\u{0020}\u{0627}\u{0020}\u{202D}\u{05D0}\u{0627}\u{0627}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [1, 1, 1, 1, 1, 0, -1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
    expected_reorder: [
      4, 3, 2, 1, 0, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
    ],
  },
  {
    number: 770113,
    input: "\u{05D0}\u{0627}\u{05D0}\u{0020}\u{0627}\u{0020}\u{202D}\u{05D0}\u{0627}\u{0627}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}",
    direction: None,
    expected_levels: [1, 1, 1, 1, 1, 1, -1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
    expected_reorder: [
      7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770114,
    input: "\u{05D0}\u{0627}\u{05D0}\u{0020}\u{0627}\u{0020}\u{202D}\u{05D0}\u{0627}\u{0627}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 1, 1, 1, 1, 1, -1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
    expected_reorder: [
      7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770115,
    input: "\u{0021}\u{0030}\u{0020}\u{0627}\u{0627}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0627}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    expected_reorder: [
      0, 1, 2, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3,
    ],
  },
  {
    number: 770116,
    input: "\u{0021}\u{0030}\u{0020}\u{0627}\u{0627}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0627}",
    direction: None,
    expected_levels: [1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    expected_reorder: [
      17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770117,
    input: "\u{0021}\u{0030}\u{0020}\u{0627}\u{0627}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0627}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    expected_reorder: [
      17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770118,
    input: "\u{0021}\u{0061}\u{0030}\u{0030}\u{0030}\u{0021}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0021}\u{002B}\u{0061}\u{0030}\u{0030}\u{0030}\u{0021}",
    direction: None,
    expected_levels: [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 11, 10, 9, 8, 7, 6, 12, 13, 14, 15, 16, 17, 18,
    ],
  },
  {
    number: 770119,
    input: "\u{0021}\u{0061}\u{0030}\u{0030}\u{0030}\u{0021}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0021}\u{002B}\u{0061}\u{0030}\u{0030}\u{0030}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 11, 10, 9, 8, 7, 6, 12, 13, 14, 15, 16, 17, 18,
    ],
  },
  {
    number: 770120,
    input: "\u{0021}\u{05D0}\u{0030}\u{0030}\u{0030}\u{0021}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0021}\u{002B}\u{05D0}\u{0030}\u{0030}\u{0030}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [0, 1, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 0],
    expected_reorder: [
      0, 2, 3, 4, 1, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 16, 17, 14, 18,
    ],
  },
  {
    number: 770121,
    input: "\u{05D0}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0030}\u{002B}\u{0030}\u{002B}\u{002B}\u{0030}",
    direction: None,
    expected_levels: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2],
    expected_reorder: [
      18, 17, 16, 13, 14, 15, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770122,
    input: "\u{05D0}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0030}\u{002B}\u{0030}\u{002B}\u{002B}\u{0030}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2],
    expected_reorder: [
      18, 17, 16, 13, 14, 15, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770123,
    input: "\u{05D0}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0030}\u{002B}\u{0030}\u{002B}\u{002B}\u{0030}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2],
    expected_reorder: [
      18, 17, 16, 13, 14, 15, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770124,
    input: "\u{0021}\u{05D0}\u{0030}\u{0030}\u{0030}\u{0021}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0021}\u{002B}\u{05D0}\u{0030}\u{0030}\u{0030}\u{0021}",
    direction: None,
    expected_levels: [1, 1, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1, 1, 1, 2, 2, 2, 1],
    expected_reorder: [
      18, 15, 16, 17, 14, 13, 12, 6, 7, 8, 9, 10, 11, 5, 2, 3, 4, 1, 0,
    ],
  },
  {
    number: 770125,
    input: "\u{0021}\u{05D0}\u{0030}\u{0030}\u{0030}\u{0021}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0021}\u{002B}\u{05D0}\u{0030}\u{0030}\u{0030}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 1, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1, 1, 1, 2, 2, 2, 1],
    expected_reorder: [
      18, 15, 16, 17, 14, 13, 12, 6, 7, 8, 9, 10, 11, 5, 2, 3, 4, 1, 0,
    ],
  },
  {
    number: 770126,
    input: "\u{0021}\u{0061}\u{0030}\u{0030}\u{0030}\u{0021}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0021}\u{002B}\u{0061}\u{0030}\u{0030}\u{0030}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [1, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 1],
    expected_reorder: [
      18, 14, 15, 16, 17, 13, 12, 11, 10, 9, 8, 7, 6, 5, 1, 2, 3, 4, 0,
    ],
  },
  {
    number: 770127,
    input: "\u{0061}\u{0020}\u{202A}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{202E}\u{0061}\u{0061}\u{05D0}\u{05D0}\u{202C}\u{0020}\u{0061}\u{0061}\u{202C}\u{0061}\u{0061}",
    direction: None,
    expected_levels: [
      0, 0, -1, 2, 2, 2, 2, 2, 2, 2, -1, 3, 3, 3, 3, -1, 2, 2, 2, -1, 0, 0,
    ],
    expected_reorder: [
      0, 1, 3, 4, 5, 6, 7, 8, 9, 14, 13, 12, 11, 16, 17, 18, 20, 21,
    ],
  },
  {
    number: 770128,
    input: "\u{0061}\u{0020}\u{202A}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{202E}\u{0061}\u{0061}\u{05D0}\u{05D0}\u{202C}\u{0020}\u{0061}\u{0061}\u{202C}\u{0061}\u{0061}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      0, 0, -1, 2, 2, 2, 2, 2, 2, 2, -1, 3, 3, 3, 3, -1, 2, 2, 2, -1, 0, 0,
    ],
    expected_reorder: [
      0, 1, 3, 4, 5, 6, 7, 8, 9, 14, 13, 12, 11, 16, 17, 18, 20, 21,
    ],
  },
  {
    number: 770129,
    input: "\u{0061}\u{0020}\u{202A}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{202E}\u{0061}\u{0061}\u{05D0}\u{05D0}\u{202C}\u{0020}\u{0061}\u{0061}\u{202C}\u{0061}\u{0061}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      2, 2, -1, 2, 2, 2, 2, 2, 2, 2, -1, 3, 3, 3, 3, -1, 2, 2, 2, -1, 2, 2,
    ],
    expected_reorder: [
      0, 1, 3, 4, 5, 6, 7, 8, 9, 14, 13, 12, 11, 16, 17, 18, 20, 21,
    ],
  },
  {
    number: 770130,
    input: "\u{0061}\u{0020}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202E}\u{0061}\u{0061}\u{0061}",
    direction: None,
    expected_levels: [
      0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 63, 63, 63,
    ],
    expected_reorder: [0, 1, 36, 35, 34],
  },
  {
    number: 770131,
    input: "\u{0061}\u{0020}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202E}\u{0061}\u{0061}\u{0061}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 63, 63, 63,
    ],
    expected_reorder: [0, 1, 36, 35, 34],
  },
  {
    number: 770132,
    input: "\u{0061}\u{0020}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202E}\u{0061}\u{0061}\u{0061}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      2, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 63, 63, 63,
    ],
    expected_reorder: [36, 35, 34, 1, 0],
  },
  {
    number: 770133,
    input: "\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0030}\u{0021}\u{0030}\u{0020}\u{0030}\u{0021}\u{0030}\u{0020}\u{0030}\u{002B}\u{0030}\u{0020}\u{0030}\u{0024}\u{0030}",
    direction: None,
    expected_levels: [
      1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2,
    ],
    expected_reorder: [
      20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770134,
    input: "\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0030}\u{0021}\u{0030}\u{0020}\u{0030}\u{0021}\u{0030}\u{0020}\u{0030}\u{002B}\u{0030}\u{0020}\u{0030}\u{0024}\u{0030}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2,
    ],
    expected_reorder: [
      20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770135,
    input: "\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0030}\u{0021}\u{0030}\u{0020}\u{0030}\u{0021}\u{0030}\u{0020}\u{0030}\u{002B}\u{0030}\u{0020}\u{0030}\u{0024}\u{0030}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2,
    ],
    expected_reorder: [
      20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770136,
    input: "\u{0061}\u{0061}\u{0061}\u{0061}\u{202D}\u{0020}\u{0061}\u{0061}\u{202C}\u{202C}\u{202C}\u{0020}\u{202E}\u{0020}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{202C}",
    direction: None,
    expected_levels: [
      0, 0, 0, 0, -1, 2, 2, 2, -1, -1, -1, 0, -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      -1,
    ],
    expected_reorder: [
      0, 1, 2, 3, 5, 6, 7, 11, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13,
    ],
  },
  {
    number: 770137,
    input: "\u{0061}\u{0061}\u{0061}\u{0061}\u{202D}\u{0020}\u{0061}\u{0061}\u{202C}\u{202C}\u{202C}\u{0020}\u{202E}\u{0020}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{202C}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      0, 0, 0, 0, -1, 2, 2, 2, -1, -1, -1, 0, -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      -1,
    ],
    expected_reorder: [
      0, 1, 2, 3, 5, 6, 7, 11, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13,
    ],
  },
  {
    number: 770138,
    input: "\u{0061}\u{0061}\u{0061}\u{0061}\u{202D}\u{0020}\u{0061}\u{0061}\u{202C}\u{202C}\u{202C}\u{0020}\u{202E}\u{0020}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{202C}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      2, 2, 2, 2, -1, 2, 2, 2, -1, -1, -1, 1, -1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
      -1,
    ],
    expected_reorder: [
      23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 11, 0, 1, 2, 3, 5, 6, 7,
    ],
  },
  {
    number: 770139,
    input: "\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0660}\u{0660}\u{202B}\u{202C}\u{0660}\u{0660}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0021}",
    direction: None,
    expected_levels: [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, -1, -1, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,
    ],
  },
  {
    number: 770140,
    input: "\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0660}\u{0660}\u{202B}\u{202C}\u{0660}\u{0660}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, -1, -1, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,
    ],
  },
  {
    number: 770141,
    input: "\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0660}\u{0660}\u{202B}\u{202C}\u{0660}\u{0660}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, -1, -1, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 1,
    ],
    expected_reorder: [
      23, 16, 17, 18, 19, 20, 21, 22, 15, 9, 10, 13, 14, 8, 0, 1, 2, 3, 4, 5, 6,
      7,
    ],
  },
  {
    number: 770142,
    input: "\u{202E}\u{202B}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{202D}\u{05D0}\u{05D0}\u{0627}\u{202C}\u{0020}\u{05D0}\u{05D0}\u{0020}",
    direction: None,
    expected_levels: [
      -1, -1, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, -1, 4, 4, 4, -1, 3, 3, 3,
      0,
    ],
    expected_reorder: [
      23, 22, 21, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 18, 19, 2, 24,
    ],
  },
  {
    number: 770143,
    input: "\u{202E}\u{202B}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{202D}\u{05D0}\u{05D0}\u{0627}\u{202C}\u{0020}\u{05D0}\u{05D0}\u{0020}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      -1, -1, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, -1, 4, 4, 4, -1, 3, 3, 3,
      0,
    ],
    expected_reorder: [
      23, 22, 21, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 18, 19, 2, 24,
    ],
  },
  {
    number: 770144,
    input: "\u{202E}\u{202B}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{202D}\u{05D0}\u{05D0}\u{0627}\u{202C}\u{0020}\u{05D0}\u{05D0}\u{0020}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      -1, -1, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, -1, 6, 6, 6, -1, 5, 5, 5,
      1,
    ],
    expected_reorder: [
      24, 23, 22, 21, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 18, 19, 2,
    ],
  },
  {
    number: 770145,
    input: "\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0627}\u{0627}\u{05D0}\u{0020}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}",
    direction: None,
    expected_levels: [
      0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 13, 12, 11, 10, 9, 8, 7, 14, 15, 16, 17, 18, 19, 20, 21,
      22, 23,
    ],
  },
  {
    number: 770146,
    input: "\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0627}\u{0627}\u{05D0}\u{0020}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 13, 12, 11, 10, 9, 8, 7, 14, 15, 16, 17, 18, 19, 20, 21,
      22, 23,
    ],
  },
  {
    number: 770147,
    input: "\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{0627}\u{0627}\u{05D0}\u{0020}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2,
    ],
    expected_reorder: [
      15, 16, 17, 18, 19, 20, 21, 22, 23, 14, 13, 12, 11, 10, 9, 8, 7, 6, 0, 1, 2,
      3, 4, 5,
    ],
  },
  {
    number: 770148,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{202A}\u{2067}\u{202A}\u{202B}\u{202D}\u{202E}\u{2069}\u{202C}\u{0061}\u{202C}\u{0021}",
    direction: None,
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 60, -1, 61, -1, 62, -1, -1, -1,
      -1, 62, -1, 61, -1, 60,
    ],
    expected_reorder: [30, 41, 34, 39, 32, 43],
  },
  {
    number: 770149,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{202A}\u{2067}\u{202A}\u{202B}\u{202D}\u{202E}\u{2069}\u{202C}\u{0061}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 60, -1, 61, -1, 62, -1, -1, -1,
      -1, 62, -1, 61, -1, 60,
    ],
    expected_reorder: [30, 41, 34, 39, 32, 43],
  },
  {
    number: 770150,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{202A}\u{2067}\u{202A}\u{202B}\u{202D}\u{202E}\u{2069}\u{202C}\u{0061}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 60, -1, 61, -1, 62, -1, -1, -1,
      -1, 62, -1, 61, -1, 60,
    ],
    expected_reorder: [30, 41, 34, 39, 32, 43],
  },
  {
    number: 770151,
    input: "\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0627}\u{0020}\u{202A}\u{0020}\u{202C}\u{0020}\u{0030}\u{0030}\u{0030}\u{0021}\u{0030}\u{0030}\u{0660}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 0, -1, 2, -1, 0, 0, 0, 0, 0, 0, 0, 2, 1, 1, 1, 1,
      1,
    ],
    expected_reorder: [
      8, 7, 6, 5, 4, 3, 2, 1, 0, 9, 11, 13, 14, 15, 16, 17, 18, 19, 25, 24, 23, 22,
      21, 20,
    ],
  },
  {
    number: 770152,
    input: "\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0627}\u{0020}\u{202A}\u{0020}\u{202C}\u{0020}\u{0030}\u{0030}\u{0030}\u{0021}\u{0030}\u{0030}\u{0660}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}",
    direction: None,
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, 2, -1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1,
      1,
    ],
    expected_reorder: [
      25, 24, 23, 22, 21, 11, 13, 14, 15, 16, 17, 18, 19, 20, 9, 8, 7, 6, 5, 4, 3,
      2, 1, 0,
    ],
  },
  {
    number: 770153,
    input: "\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0627}\u{0020}\u{202A}\u{0020}\u{202C}\u{0020}\u{0030}\u{0030}\u{0030}\u{0021}\u{0030}\u{0030}\u{0660}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, 2, -1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1,
      1,
    ],
    expected_reorder: [
      25, 24, 23, 22, 21, 11, 13, 14, 15, 16, 17, 18, 19, 20, 9, 8, 7, 6, 5, 4, 3,
      2, 1, 0,
    ],
  },
  {
    number: 770154,
    input: "\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{05D0}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    ],
    expected_reorder: [
      5, 4, 3, 2, 1, 0, 6, 7, 8, 9, 10, 11, 12, 13, 14, 24, 23, 22, 21, 20, 19, 18,
      17, 16, 15,
    ],
  },
  {
    number: 770155,
    input: "\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{05D0}",
    direction: None,
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    ],
    expected_reorder: [
      24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 7, 8, 9, 10, 11, 12, 13, 6, 5,
      4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770156,
    input: "\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{05D0}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    ],
    expected_reorder: [
      24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 7, 8, 9, 10, 11, 12, 13, 6, 5,
      4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770157,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{2066}\u{202B}\u{202A}\u{202E}\u{202D}\u{0021}\u{2069}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}",
    direction: None,
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 58, -1, 59, -1, -1, -1, -1, 64, 59,
      59, 59, 59, -1, 58,
    ],
    expected_reorder: [29, 40, 39, 38, 37, 36, 31, 42],
  },
  {
    number: 770158,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{2066}\u{202B}\u{202A}\u{202E}\u{202D}\u{0021}\u{2069}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 58, -1, 59, -1, -1, -1, -1, 64, 59,
      59, 59, 59, -1, 58,
    ],
    expected_reorder: [29, 40, 39, 38, 37, 36, 31, 42],
  },
  {
    number: 770159,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{2066}\u{202B}\u{202A}\u{202E}\u{202D}\u{0021}\u{2069}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 58, -1, 59, -1, -1, -1, -1, 64, 59,
      59, 59, 59, -1, 58,
    ],
    expected_reorder: [29, 40, 39, 38, 37, 36, 31, 42],
  },
  {
    number: 770160,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2067}\u{0021}\u{202D}\u{202B}\u{202E}\u{202A}\u{0021}\u{2069}\u{05D0}\u{202C}\u{0021}",
    direction: None,
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 59, -1, 60, 60, 61, -1, -1, -1,
      -1, 66, 60, 60, -1, 59,
    ],
    expected_reorder: [43, 32, 33, 39, 34, 40, 41, 30],
  },
  {
    number: 770161,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2067}\u{0021}\u{202D}\u{202B}\u{202E}\u{202A}\u{0021}\u{2069}\u{05D0}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 59, -1, 60, 60, 61, -1, -1, -1,
      -1, 66, 60, 60, -1, 59,
    ],
    expected_reorder: [43, 32, 33, 39, 34, 40, 41, 30],
  },
  {
    number: 770162,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2067}\u{0021}\u{202D}\u{202B}\u{202E}\u{202A}\u{0021}\u{2069}\u{05D0}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 59, -1, 60, 60, 61, -1, -1, -1,
      -1, 66, 60, 60, -1, 59,
    ],
    expected_reorder: [43, 32, 33, 39, 34, 40, 41, 30],
  },
  {
    number: 770163,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2066}\u{05D0}\u{202A}\u{202B}\u{202D}\u{202E}\u{05D0}\u{2069}\u{05D0}\u{202C}\u{0021}",
    direction: None,
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 59, -1, 60, 60, 63, -1, -1, -1,
      -1, 67, 60, 60, -1, 59,
    ],
    expected_reorder: [43, 32, 33, 39, 34, 40, 41, 30],
  },
  {
    number: 770164,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2066}\u{05D0}\u{202A}\u{202B}\u{202D}\u{202E}\u{05D0}\u{2069}\u{05D0}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 59, -1, 60, 60, 63, -1, -1, -1,
      -1, 67, 60, 60, -1, 59,
    ],
    expected_reorder: [43, 32, 33, 39, 34, 40, 41, 30],
  },
  {
    number: 770165,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2066}\u{05D0}\u{202A}\u{202B}\u{202D}\u{202E}\u{05D0}\u{2069}\u{05D0}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 59, -1, 60, 60, 63, -1, -1, -1,
      -1, 67, 60, 60, -1, 59,
    ],
    expected_reorder: [43, 32, 33, 39, 34, 40, 41, 30],
  },
  {
    number: 770166,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{2066}\u{0061}\u{202B}\u{202A}\u{202E}\u{202D}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}",
    direction: None,
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 60, -1, 61, 61, 62, -1, -1, -1,
      -1, 66, 61, 61, -1, 60,
    ],
    expected_reorder: [30, 41, 40, 34, 39, 33, 32, 43],
  },
  {
    number: 770167,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{2066}\u{0061}\u{202B}\u{202A}\u{202E}\u{202D}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 60, -1, 61, 61, 62, -1, -1, -1,
      -1, 66, 61, 61, -1, 60,
    ],
    expected_reorder: [30, 41, 40, 34, 39, 33, 32, 43],
  },
  {
    number: 770168,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{2066}\u{0061}\u{202B}\u{202A}\u{202E}\u{202D}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 60, -1, 61, 61, 62, -1, -1, -1,
      -1, 66, 61, 61, -1, 60,
    ],
    expected_reorder: [30, 41, 40, 34, 39, 33, 32, 43],
  },
  {
    number: 770169,
    input: "\u{0627}\u{0061}\u{0061}\u{0020}\u{202B}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0660}\u{0660}\u{0660}\u{202D}\u{05D0}\u{05D0}\u{0627}\u{202E}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{202C}\u{0020}\u{0061}\u{05D0}\u{0627}\u{002C}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      1, 0, 0, 0, -1, 1, 2, 2, 2, 1, 2, 2, 2, -1, 2, 2, 2, -1, 3, 3, 3, 3, 3, -1,
      2, 2, 2, 2, 2,
    ],
    expected_reorder: [
      0, 1, 2, 3, 10, 11, 12, 14, 15, 16, 22, 21, 20, 19, 18, 24, 25, 26, 27, 28,
      9, 6, 7, 8, 5,
    ],
  },
  {
    number: 770170,
    input: "\u{0627}\u{0061}\u{0061}\u{0020}\u{202B}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0660}\u{0660}\u{0660}\u{202D}\u{05D0}\u{05D0}\u{0627}\u{202E}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{202C}\u{0020}\u{0061}\u{05D0}\u{0627}\u{002C}",
    direction: None,
    expected_levels: [
      1, 2, 2, 1, -1, 3, 4, 4, 4, 3, 4, 4, 4, -1, 4, 4, 4, -1, 5, 5, 5, 5, 5, -1,
      4, 4, 4, 4, 4,
    ],
    expected_reorder: [
      10, 11, 12, 14, 15, 16, 22, 21, 20, 19, 18, 24, 25, 26, 27, 28, 9, 6, 7, 8,
      5, 3, 1, 2, 0,
    ],
  },
  {
    number: 770171,
    input: "\u{0627}\u{0061}\u{0061}\u{0020}\u{202B}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0660}\u{0660}\u{0660}\u{202D}\u{05D0}\u{05D0}\u{0627}\u{202E}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{202C}\u{0020}\u{0061}\u{05D0}\u{0627}\u{002C}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      1, 2, 2, 1, -1, 3, 4, 4, 4, 3, 4, 4, 4, -1, 4, 4, 4, -1, 5, 5, 5, 5, 5, -1,
      4, 4, 4, 4, 4,
    ],
    expected_reorder: [
      10, 11, 12, 14, 15, 16, 22, 21, 20, 19, 18, 24, 25, 26, 27, 28, 9, 6, 7, 8,
      5, 3, 1, 2, 0,
    ],
  },
  {
    number: 770172,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: None,
    expected_levels: [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1,
      1, 0,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 25, 24, 23, 22, 15, 16, 17, 18, 19, 20, 21, 14,
      13, 12, 11, 10, 9, 26,
    ],
  },
  {
    number: 770173,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1,
      1, 0,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 25, 24, 23, 22, 15, 16, 17, 18, 19, 20, 21, 14,
      13, 12, 11, 10, 9, 26,
    ],
  },
  {
    number: 770174,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: None,
    expected_levels: [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1,
      1, 0,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 25, 24, 23, 22, 15, 16, 17, 18, 19, 20, 21, 14,
      13, 12, 11, 10, 9, 26,
    ],
  },
  {
    number: 770175,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1,
      1, 0,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 25, 24, 23, 22, 15, 16, 17, 18, 19, 20, 21, 14,
      13, 12, 11, 10, 9, 26,
    ],
  },
  {
    number: 770176,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1,
      1, 1,
    ],
    expected_reorder: [
      26, 25, 24, 23, 22, 15, 16, 17, 18, 19, 20, 21, 14, 13, 12, 11, 10, 9, 8, 7,
      0, 1, 2, 3, 4, 5, 6,
    ],
  },
  {
    number: 770177,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1,
      1, 1,
    ],
    expected_reorder: [
      26, 25, 24, 23, 22, 15, 16, 17, 18, 19, 20, 21, 14, 13, 12, 11, 10, 9, 8, 7,
      0, 1, 2, 3, 4, 5, 6,
    ],
  },
  {
    number: 770178,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0020}\u{0030}\u{0030}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: None,
    expected_levels: [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1,
      1, 1, 0,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 26, 25, 24, 23, 20, 21, 22, 19, 18, 15, 16, 17,
      14, 13, 12, 11, 10, 9, 27,
    ],
  },
  {
    number: 770179,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0020}\u{0030}\u{0030}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1,
      1, 1, 0,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 26, 25, 24, 23, 20, 21, 22, 19, 18, 15, 16, 17,
      14, 13, 12, 11, 10, 9, 27,
    ],
  },
  {
    number: 770180,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: None,
    expected_levels: [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1,
      1, 1, 0,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 26, 25, 24, 23, 20, 21, 22, 19, 18, 15, 16, 17,
      14, 13, 12, 11, 10, 9, 27,
    ],
  },
  {
    number: 770181,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1,
      1, 1, 0,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 26, 25, 24, 23, 20, 21, 22, 19, 18, 15, 16, 17,
      14, 13, 12, 11, 10, 9, 27,
    ],
  },
  {
    number: 770182,
    input: "\u{0627}\u{0061}\u{0627}\u{0020}\u{0061}\u{05D0}\u{0061}\u{202D}\u{0020}\u{0627}\u{0061}\u{05D0}\u{0061}\u{05D0}\u{002C}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0660}\u{0660}\u{0660}\u{0020}\u{0061}\u{05D0}\u{0061}\u{05D0}\u{202C}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      1, 0, 1, 0, 0, 1, 0, -1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
      2, 2, 2, -1,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
      22, 23, 24, 25, 26, 27,
    ],
  },
  {
    number: 770183,
    input: "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0020}\u{0030}\u{0030}\u{0660}\u{002C}\u{0020}\u{0061}\u{0061}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0,
      0, 0, 0,
    ],
    expected_reorder: [
      6, 5, 4, 3, 2, 1, 0, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
      22, 23, 24, 25, 26, 27,
    ],
  },
  {
    number: 770184,
    input: "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0061}\u{0061}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 1, 1, 2, 2, 2, 0, 0,
      0, 0, 0,
    ],
    expected_reorder: [
      6, 5, 4, 3, 2, 1, 0, 7, 8, 9, 10, 11, 12, 13, 14, 20, 21, 22, 19, 18, 15, 16,
      17, 23, 24, 25, 26, 27,
    ],
  },
  {
    number: 770185,
    input: "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0061}\u{0061}\u{0021}",
    direction: None,
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1,
      2, 2, 1,
    ],
    expected_reorder: [
      27, 25, 26, 24, 23, 20, 21, 22, 19, 18, 15, 16, 17, 14, 9, 10, 11, 12, 13,
      8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770186,
    input: "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0061}\u{0061}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1,
      2, 2, 1,
    ],
    expected_reorder: [
      27, 25, 26, 24, 23, 20, 21, 22, 19, 18, 15, 16, 17, 14, 9, 10, 11, 12, 13,
      8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770187,
    input: "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0020}\u{0030}\u{0030}\u{0660}\u{002C}\u{0020}\u{0061}\u{0061}\u{0021}",
    direction: None,
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1,
      2, 2, 1,
    ],
    expected_reorder: [
      27, 25, 26, 24, 23, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
      8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770188,
    input: "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0020}\u{0030}\u{0030}\u{0660}\u{002C}\u{0020}\u{0061}\u{0061}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1,
      2, 2, 1,
    ],
    expected_reorder: [
      27, 25, 26, 24, 23, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
      8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770189,
    input: "\u{0627}\u{0061}\u{0627}\u{0020}\u{0061}\u{05D0}\u{0061}\u{202D}\u{0020}\u{0627}\u{0061}\u{05D0}\u{0061}\u{05D0}\u{002C}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0660}\u{0660}\u{0660}\u{0020}\u{0061}\u{05D0}\u{0061}\u{05D0}\u{202C}",
    direction: None,
    expected_levels: [
      1, 2, 1, 1, 2, 1, 2, -1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
      2, 2, 2, -1,
    ],
    expected_reorder: [
      6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,
      27, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770190,
    input: "\u{0627}\u{0061}\u{0627}\u{0020}\u{0061}\u{05D0}\u{0061}\u{202D}\u{0020}\u{0627}\u{0061}\u{05D0}\u{0061}\u{05D0}\u{002C}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0660}\u{0660}\u{0660}\u{0020}\u{0061}\u{05D0}\u{0061}\u{05D0}\u{202C}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      1, 2, 1, 1, 2, 1, 2, -1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
      2, 2, 2, -1,
    ],
    expected_reorder: [
      6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,
      27, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770191,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0030}\u{0030}\u{0030}\u{002C}\u{0020}\u{0030}\u{0030}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1,
      1, 1, 1,
    ],
    expected_reorder: [
      27, 26, 25, 24, 23, 20, 21, 22, 19, 18, 15, 16, 17, 14, 13, 12, 11, 10, 9,
      8, 7, 0, 1, 2, 3, 4, 5, 6,
    ],
  },
  {
    number: 770192,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1,
      1, 1, 1,
    ],
    expected_reorder: [
      27, 26, 25, 24, 23, 20, 21, 22, 19, 18, 15, 16, 17, 14, 13, 12, 11, 10, 9,
      8, 7, 0, 1, 2, 3, 4, 5, 6,
    ],
  },
  {
    number: 770193,
    input: "\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0627}\u{0020}\u{202A}\u{202C}\u{0020}\u{0030}\u{0030}\u{0030}\u{0021}\u{0030}\u{0030}\u{0660}\u{0020}\u{05D0}\u{05D0}\u{0627}\u{0627}\u{0020}\u{05D0}\u{05D0}\u{0627}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 0,
    ],
    expected_reorder: [
      28, 27, 26, 25, 24, 23, 22, 21, 20, 17, 18, 19, 16, 13, 14, 15, 12, 9, 8, 7,
      6, 5, 4, 3, 2, 1, 0, 29,
    ],
  },
  {
    number: 770194,
    input: "\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0627}\u{0020}\u{202A}\u{202C}\u{0020}\u{0030}\u{0030}\u{0030}\u{0021}\u{0030}\u{0030}\u{0660}\u{0020}\u{05D0}\u{05D0}\u{0627}\u{0627}\u{0020}\u{05D0}\u{05D0}\u{0627}\u{0021}",
    direction: None,
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 1,
    ],
    expected_reorder: [
      29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 17, 18, 19, 16, 13, 14, 15, 12, 9,
      8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770195,
    input: "\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0627}\u{0020}\u{202A}\u{202C}\u{0020}\u{0030}\u{0030}\u{0030}\u{0021}\u{0030}\u{0030}\u{0660}\u{0020}\u{05D0}\u{05D0}\u{0627}\u{0627}\u{0020}\u{05D0}\u{05D0}\u{0627}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 1,
    ],
    expected_reorder: [
      29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 17, 18, 19, 16, 13, 14, 15, 12, 9,
      8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770196,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: None,
    expected_levels: [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1,
      1, 1, 1, 0,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 27, 26, 25, 24, 23, 16, 17, 18, 19, 20, 21, 22,
      15, 14, 13, 12, 11, 10, 9, 28,
    ],
  },
  {
    number: 770197,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1,
      1, 1, 1, 0,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 27, 26, 25, 24, 23, 16, 17, 18, 19, 20, 21, 22,
      15, 14, 13, 12, 11, 10, 9, 28,
    ],
  },
  {
    number: 770198,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0660}\u{0660}\u{0660}\u{002C}\u{0660}\u{0660}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: None,
    expected_levels: [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1,
      1, 1, 1, 0,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 27, 26, 25, 24, 23, 16, 17, 18, 19, 20, 21, 22,
      15, 14, 13, 12, 11, 10, 9, 28,
    ],
  },
  {
    number: 770199,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0660}\u{0660}\u{0660}\u{002C}\u{0660}\u{0660}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1,
      1, 1, 1, 0,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 27, 26, 25, 24, 23, 16, 17, 18, 19, 20, 21, 22,
      15, 14, 13, 12, 11, 10, 9, 28,
    ],
  },
  {
    number: 770200,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1,
      1, 1, 1, 1,
    ],
    expected_reorder: [
      28, 27, 26, 25, 24, 23, 16, 17, 18, 19, 20, 21, 22, 15, 14, 13, 12, 11, 10,
      9, 8, 7, 0, 1, 2, 3, 4, 5, 6,
    ],
  },
  {
    number: 770201,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0660}\u{0660}\u{0660}\u{002C}\u{0660}\u{0660}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1,
      1, 1, 1, 1,
    ],
    expected_reorder: [
      28, 27, 26, 25, 24, 23, 16, 17, 18, 19, 20, 21, 22, 15, 14, 13, 12, 11, 10,
      9, 8, 7, 0, 1, 2, 3, 4, 5, 6,
    ],
  },
  {
    number: 770202,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0030}\u{0030}\u{0030}\u{002C}\u{0020}\u{0030}\u{0030}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: None,
    expected_levels: [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1,
      1, 1, 1, 1, 0,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 28, 27, 26, 25, 24, 21, 22, 23, 20, 19, 16, 17,
      18, 15, 14, 13, 12, 11, 10, 9, 29,
    ],
  },
  {
    number: 770203,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0030}\u{0030}\u{0030}\u{002C}\u{0020}\u{0030}\u{0030}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1,
      1, 1, 1, 1, 0,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 28, 27, 26, 25, 24, 21, 22, 23, 20, 19, 16, 17,
      18, 15, 14, 13, 12, 11, 10, 9, 29,
    ],
  },
  {
    number: 770204,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0660}\u{0660}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: None,
    expected_levels: [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1,
      1, 1, 1, 1, 0,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 28, 27, 26, 25, 24, 21, 22, 23, 20, 19, 16, 17,
      18, 15, 14, 13, 12, 11, 10, 9, 29,
    ],
  },
  {
    number: 770205,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0660}\u{0660}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1,
      1, 1, 1, 1, 0,
    ],
    expected_reorder: [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 28, 27, 26, 25, 24, 21, 22, 23, 20, 19, 16, 17,
      18, 15, 14, 13, 12, 11, 10, 9, 29,
    ],
  },
  {
    number: 770206,
    input: "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0021}\u{0021}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
      1, 1, 1, 1, 1,
    ],
    expected_reorder: [
      6, 5, 4, 3, 2, 1, 0, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
      22, 29, 28, 27, 26, 25, 24, 23,
    ],
  },
  {
    number: 770207,
    input: "\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{002C}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 2,
    ],
    expected_reorder: [
      14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 15, 16, 17, 18, 19, 20, 21,
      22, 23, 24, 25, 26, 27, 28, 29,
    ],
  },
  {
    number: 770208,
    input: "\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{002C}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}",
    direction: None,
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2,
      2, 2, 2, 2, 2,
    ],
    expected_reorder: [
      17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 16, 15, 14, 13, 12, 11,
      10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770209,
    input: "\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{002C}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0061}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2,
      2, 2, 2, 2, 2,
    ],
    expected_reorder: [
      17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 16, 15, 14, 13, 12, 11,
      10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770210,
    input: "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0021}\u{0021}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}",
    direction: None,
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 1,
    ],
    expected_reorder: [
      29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 9, 10, 11, 12, 13, 14, 15, 16, 17,
      18, 19, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770211,
    input: "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0021}\u{0021}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 1,
    ],
    expected_reorder: [
      29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 9, 10, 11, 12, 13, 14, 15, 16, 17,
      18, 19, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770212,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0030}\u{0030}\u{0030}\u{002C}\u{0020}\u{0030}\u{0030}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1,
      1, 1, 1, 1, 1,
    ],
    expected_reorder: [
      29, 28, 27, 26, 25, 24, 21, 22, 23, 20, 19, 16, 17, 18, 15, 14, 13, 12, 11,
      10, 9, 8, 7, 0, 1, 2, 3, 4, 5, 6,
    ],
  },
  {
    number: 770213,
    input: "\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0061}\u{0020}\u{0021}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{0020}\u{0021}\u{0660}\u{0660}\u{0660}\u{002C}\u{0020}\u{0660}\u{0660}\u{0660}\u{0021}\u{002C}\u{0020}\u{05D0}\u{05D0}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1,
      1, 1, 1, 1, 1,
    ],
    expected_reorder: [
      29, 28, 27, 26, 25, 24, 21, 22, 23, 20, 19, 16, 17, 18, 15, 14, 13, 12, 11,
      10, 9, 8, 7, 0, 1, 2, 3, 4, 5, 6,
    ],
  },
  {
    number: 770214,
    input: "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0021}\u{0061}\u{0021}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
      1, 1, 1, 1, 1, 1,
    ],
    expected_reorder: [
      6, 5, 4, 3, 2, 1, 0, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
      22, 23, 30, 29, 28, 27, 26, 25, 24,
    ],
  },
  {
    number: 770215,
    input: "\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{002C}\u{0020}\u{0030}\u{0030}\u{0030}\u{0024}\u{002C}\u{0030}\u{0030}\u{0660}",
    direction: None,
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2,
      2, 2, 1, 2, 2, 2,
    ],
    expected_reorder: [
      28, 29, 30, 27, 23, 24, 25, 26, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12,
      11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770216,
    input: "\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{002C}\u{0020}\u{0030}\u{0030}\u{0030}\u{0024}\u{002C}\u{0030}\u{0030}\u{0660}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2,
      2, 2, 1, 2, 2, 2,
    ],
    expected_reorder: [
      28, 29, 30, 27, 23, 24, 25, 26, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12,
      11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770217,
    input: "\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{002C}\u{0020}\u{0030}\u{0030}\u{0030}\u{0024}\u{002C}\u{0030}\u{0030}\u{0660}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2,
      2, 2, 1, 2, 2, 2,
    ],
    expected_reorder: [
      28, 29, 30, 27, 23, 24, 25, 26, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12,
      11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770218,
    input: "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0021}\u{0061}\u{0021}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}",
    direction: None,
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1,
      1, 1, 1, 1, 1, 1,
    ],
    expected_reorder: [
      30, 29, 28, 27, 26, 25, 24, 23, 22, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18,
      19, 20, 21, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770219,
    input: "\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}\u{0627}\u{0020}\u{0021}\u{0061}\u{0061}\u{0020}\u{0061}\u{0061}\u{0020}\u{0061}\u{0020}\u{0061}\u{0061}\u{0061}\u{0021}\u{0061}\u{0021}\u{0020}\u{0627}\u{05D0}\u{0627}\u{0020}\u{05D0}\u{0627}\u{05D0}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1,
      1, 1, 1, 1, 1, 1,
    ],
    expected_reorder: [
      30, 29, 28, 27, 26, 25, 24, 23, 22, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18,
      19, 20, 21, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770220,
    input: "\u{0627}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{002C}\u{0020}\u{0627}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}",
    direction: None,
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      2, 2, 2, 2, 2, 2, 2,
    ],
    expected_reorder: [
      25, 26, 27, 28, 29, 30, 31, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13,
      12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770221,
    input: "\u{0627}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{002C}\u{0020}\u{0627}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      2, 2, 2, 2, 2, 2, 2,
    ],
    expected_reorder: [
      25, 26, 27, 28, 29, 30, 31, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13,
      12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770222,
    input: "\u{0627}\u{05D0}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{0020}\u{0627}\u{05D0}\u{05D0}\u{0020}\u{05D0}\u{0627}\u{0627}\u{05D0}\u{0020}\u{05D0}\u{05D0}\u{05D0}\u{0627}\u{05D0}\u{002C}\u{0020}\u{0627}\u{0030}\u{0030}\u{0030}\u{002C}\u{0030}\u{0030}\u{0660}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      2, 2, 2, 2, 2, 2, 2,
    ],
    expected_reorder: [
      25, 26, 27, 28, 29, 30, 31, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13,
      12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,
    ],
  },
  {
    number: 770223,
    input: "\u{0061}\u{0020}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202E}\u{0061}\u{0061}\u{0061}",
    direction: None,
    expected_levels: [
      0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, 124, 124, 124,
    ],
    expected_reorder: [0, 1, 66, 67, 68],
  },
  {
    number: 770224,
    input: "\u{0061}\u{0020}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202E}\u{0061}\u{0061}\u{0061}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, 124, 124, 124,
    ],
    expected_reorder: [0, 1, 66, 67, 68],
  },
  {
    number: 770225,
    input: "\u{0061}\u{0020}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202D}\u{202E}\u{0061}\u{0061}\u{0061}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      2, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, 124, 124, 124,
    ],
    expected_reorder: [0, 1, 66, 67, 68],
  },
  {
    number: 770226,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{202A}\u{2067}\u{202A}\u{202B}\u{202D}\u{202E}\u{2069}\u{202C}\u{0061}\u{202C}\u{0021}",
    direction: None,
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, 124, -1, 125, -1, 125, -1, -1, -1, -1, 125, -1, 125, -1,
      124,
    ],
    expected_reorder: [62, 73, 71, 66, 64, 75],
  },
  {
    number: 770227,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{202A}\u{2067}\u{202A}\u{202B}\u{202D}\u{202E}\u{2069}\u{202C}\u{0061}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, 124, -1, 125, -1, 125, -1, -1, -1, -1, 125, -1, 125, -1,
      124,
    ],
    expected_reorder: [62, 73, 71, 66, 64, 75],
  },
  {
    number: 770228,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{202A}\u{2067}\u{202A}\u{202B}\u{202D}\u{202E}\u{2069}\u{202C}\u{0061}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, 124, -1, 125, -1, 125, -1, -1, -1, -1, 125, -1, 125, -1,
      124,
    ],
    expected_reorder: [62, 73, 71, 66, 64, 75],
  },
  {
    number: 770229,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{2066}\u{202B}\u{202A}\u{202E}\u{202D}\u{0021}\u{2069}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}",
    direction: None,
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, 122, -1, 123, -1, -1, -1, -1, 125, 123, 123, 123, 123, -1,
      122,
    ],
    expected_reorder: [61, 72, 71, 70, 69, 68, 63, 74],
  },
  {
    number: 770230,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{2066}\u{202B}\u{202A}\u{202E}\u{202D}\u{0021}\u{2069}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, 122, -1, 123, -1, -1, -1, -1, 125, 123, 123, 123, 123, -1,
      122,
    ],
    expected_reorder: [61, 72, 71, 70, 69, 68, 63, 74],
  },
  {
    number: 770231,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{2066}\u{202B}\u{202A}\u{202E}\u{202D}\u{0021}\u{2069}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, 122, -1, 123, -1, -1, -1, -1, 125, 123, 123, 123, 123, -1,
      122,
    ],
    expected_reorder: [61, 72, 71, 70, 69, 68, 63, 74],
  },
  {
    number: 770232,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2066}\u{05D0}\u{202A}\u{202B}\u{202D}\u{202E}\u{05D0}\u{2069}\u{05D0}\u{202C}\u{0021}",
    direction: None,
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, 123, -1, 124, 124, 124, -1, -1, -1, -1, 124, 124, 124,
      -1, 123,
    ],
    expected_reorder: [75, 64, 65, 66, 71, 72, 73, 62],
  },
  {
    number: 770233,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2066}\u{05D0}\u{202A}\u{202B}\u{202D}\u{202E}\u{05D0}\u{2069}\u{05D0}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, 123, -1, 124, 124, 124, -1, -1, -1, -1, 124, 124, 124,
      -1, 123,
    ],
    expected_reorder: [75, 64, 65, 66, 71, 72, 73, 62],
  },
  {
    number: 770234,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2066}\u{05D0}\u{202A}\u{202B}\u{202D}\u{202E}\u{05D0}\u{2069}\u{05D0}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, 123, -1, 124, 124, 124, -1, -1, -1, -1, 124, 124, 124,
      -1, 123,
    ],
    expected_reorder: [75, 64, 65, 66, 71, 72, 73, 62],
  },
  {
    number: 770235,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2067}\u{0021}\u{202D}\u{202B}\u{202E}\u{202A}\u{0021}\u{2069}\u{05D0}\u{202C}\u{0021}",
    direction: None,
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, 123, -1, 124, 124, 125, -1, -1, -1, -1, 125, 124, 124,
      -1, 123,
    ],
    expected_reorder: [75, 64, 65, 71, 66, 72, 73, 62],
  },
  {
    number: 770236,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2067}\u{0021}\u{202D}\u{202B}\u{202E}\u{202A}\u{0021}\u{2069}\u{05D0}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, 123, -1, 124, 124, 125, -1, -1, -1, -1, 125, 124, 124,
      -1, 123,
    ],
    expected_reorder: [75, 64, 65, 71, 66, 72, 73, 62],
  },
  {
    number: 770237,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202B}\u{0021}\u{202D}\u{05D0}\u{2067}\u{0021}\u{202D}\u{202B}\u{202E}\u{202A}\u{0021}\u{2069}\u{05D0}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, 123, -1, 124, 124, 125, -1, -1, -1, -1, 125, 124, 124,
      -1, 123,
    ],
    expected_reorder: [75, 64, 65, 71, 66, 72, 73, 62],
  },
  {
    number: 770238,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{2066}\u{0061}\u{202B}\u{202A}\u{202E}\u{202D}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}",
    direction: None,
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, 124, -1, 125, 125, 125, -1, -1, -1, -1, 125, 125, 125,
      -1, 124,
    ],
    expected_reorder: [62, 73, 72, 71, 66, 65, 64, 75],
  },
  {
    number: 770239,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{2066}\u{0061}\u{202B}\u{202A}\u{202E}\u{202D}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::LTR),
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, 124, -1, 125, 125, 125, -1, -1, -1, -1, 125, 125, 125,
      -1, 124,
    ],
    expected_reorder: [62, 73, 72, 71, 66, 65, 64, 75],
  },
  {
    number: 770240,
    input: "\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{202A}\u{0021}\u{202E}\u{0061}\u{2066}\u{0061}\u{202B}\u{202A}\u{202E}\u{202D}\u{0061}\u{2069}\u{0061}\u{202C}\u{0021}",
    direction: Some(@bidi.Direction::RTL),
    expected_levels: [
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, 124, -1, 125, 125, 125, -1, -1, -1, -1, 125, 125, 125,
      -1, 124,
    ],
    expected_reorder: [62, 73, 72, 71, 66, 65, 64, 75],
  },
]

///|
test "BidiTest.txt part 1540" {
  for case in test_cases {
    let direction = case.direction
    let result = @bidi.process(case.input, direction?)
    for index, expected_level in case.expected_levels {
      if expected_level >= 0 {
        @debug.assert_eq(
          result.levels[index],
          expected_level,
          msg="case \{case.number}: resolved level at index \{index}",
        )
      }
    }
    @debug.assert_eq(
      @bidi.reorder(result),
      case.expected_reorder,
      msg="case \{case.number}: visual reorder",
    )
  }
}
