///|
/// Every `step`-th scalar value below `limit`, skipping surrogates.
fn sample(step : Int32, limit : Int32) -> Array[Char] {
  let chars : Array[Char] = []
  for cp = 0; cp < limit; cp = cp + step {
    if cp < 0xD800 || cp > 0xDFFF {
      chars.push(cp.unsafe_to_char())
    }
  }
  chars
}

///|
test "table lookups" (b : @bench.T) {
  // One code point per 97 scalar values covers every plane; one per 7 in the
  // BMP hits the dense regions of the smaller tables more often.
  let corpora = [("all", sample(97, 0x110000)), ("bmp", sample(7, 0x10000))]
  for (label, chars) in corpora {
    let name = "\{label}-\{chars.length()}"
    b.bench(name="is_mark/\{name}", fn() {
      let mut found = 0
      for c in chars {
        if @general_category.is_mark(c) {
          found += 1
        }
      }
      b.keep(found)
    })
    b.bench(name="is_composition_excluded/\{name}", fn() {
      let mut found = 0
      for c in chars {
        if @composition.is_composition_excluded(c) {
          found += 1
        }
      }
      b.keep(found)
    })
    b.bench(name="get_mirrored/\{name}", fn() {
      let mut sum = 0
      for c in chars {
        sum += @bidi.get_mirrored(c, 1).to_int()
      }
      b.keep(sum)
    })
    b.bench(name="general_category_ordinal/\{name}", fn() {
      let mut sum = 0
      for c in chars {
        sum += @general_category.lookup_general_category(c)
      }
      b.keep(sum)
    })
    b.bench(name="general_category_is_Ll/\{name}", fn() {
      let mut found = 0
      for c in chars {
        if @ucd.general_category(c) is Ll {
          found += 1
        }
      }
      b.keep(found)
    })
    b.bench(name="general_category_group_is_P/\{name}", fn() {
      let mut found = 0
      for c in chars {
        if @ucd.general_category(c).group() is P {
          found += 1
        }
      }
      b.keep(found)
    })
  }
}
