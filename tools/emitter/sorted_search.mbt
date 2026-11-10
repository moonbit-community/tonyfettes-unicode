///|
/// Write the function `name`, which looks a key up in the sorted
/// `ReadOnlyArray[Int]` named `values` by binary search and returns its
/// index, or -1 when the array does not hold it.
///
/// The array is named in the function body rather than passed in: on
/// wasm-gc, passing it measurably slowed down the lookup.
pub fn Emitter::write_sorted_search(
  self : Emitter,
  name~ : String,
  values~ : String,
) -> Unit {
  self.write(
    (
      $|///|
      $|/// Index of `key` in the sorted array `\{values}`, or -1 if it is absent.
      $|fn \{name}(key : Int) -> Int {
      $|  let mut left = 0
      $|  let mut right = \{values}.length() - 1
      $|  while left <= right {
      $|    let mid = (left + right) / 2
      $|    let value = \{values}[mid]
      $|    if key < value {
      $|      right = mid - 1
      $|    } else if key > value {
      $|      left = mid + 1
      $|    } else {
      $|      return mid
      $|    }
      $|  }
      $|  -1
      $|}
      $|
    ),
  )
}
