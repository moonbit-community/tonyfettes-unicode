///|
test "deduplicate_blocks shares identical blocks" {
  let values = [1, 2, 3, 4, 1, 2, 5, 6, 3, 4, 1, 2]
  let deduped = deduplicate_blocks(values, 2)
  debug_inspect(deduped.ids, content="[0, 1, 0, 2, 1, 0]")
  debug_inspect(deduped.blocks, content="[1, 2, 3, 4, 5, 6]")
  for index, value in values {
    assert_eq(deduped.blocks[deduped.ids[index / 2] * 2 + index % 2], value)
  }
}
