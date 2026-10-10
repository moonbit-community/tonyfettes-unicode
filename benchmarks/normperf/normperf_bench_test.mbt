///|
// Keep the matrix in one block so bare moon bench runs every case sequentially.
test "ICU normperf full corpus matrix" (b : @bench.T) {
  for fixture in fixtures() {
    for
      (form_name, form, expected) in [
        ("NFC", @normalization.NFC, fixture.nfc),
        ("NFD", @normalization.NFD, fixture.nfd),
      ] {
      for
        (state, input) in [
          ("orig", fixture.original),
          ("nfc", fixture.nfc),
          ("nfd", fixture.nfd),
        ] {
        assert_eq(@normalization.normalize(input, form), expected)
        assert_eq(@normalization.is_normalized(input, form), input == expected)
        let name = "\{fixture.name}/\{state}/\{form_name}"
        b.bench(name="\{name}/normalize", fn() {
          b.keep(@normalization.normalize(input, form))
        })
        b.bench(name="\{name}/check", fn() {
          b.keep(@normalization.is_normalized(input, form))
        })
      }
    }
  }
}
