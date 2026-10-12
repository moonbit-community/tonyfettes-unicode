///|
/// One trie level: a table split into fixed-size blocks with duplicates
/// removed.
pub struct DedupedBlocks {
  /// For each block of the input, the index of its copy in `blocks`.
  ids : Array[Int32]
  /// The distinct blocks, concatenated. Block `i` starts at
  /// `i * block_size`.
  blocks : Array[Int32]
}

///|
/// Split `values` into blocks of `block_size` and keep one copy of each
/// distinct block, so `values[k]` is
/// `blocks[ids[k / block_size] * block_size + k % block_size]`.
pub fn deduplicate_blocks(
  values : Array[Int32],
  block_size : Int32,
) -> DedupedBlocks {
  let seen : Map[ArrayView[Int32], Int32] = Map([])
  let ids = []
  let blocks = []
  for start = 0; start < values.length(); start = start + block_size {
    let block = values[start:start + block_size]
    let id = match seen.get(block) {
      Some(id) => id
      None => {
        let id = seen.length()
        seen[block] = id
        blocks.append(block)
        id
      }
    }
    ids.push(id)
  }
  { ids, blocks, }
}
