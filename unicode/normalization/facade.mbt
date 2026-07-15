///|
pub using @impl {nfc, nfd, nfkc, nfkd}

///|
pub(all) enum NormalizationForm {
  NFD
  NFC
  NFKD
  NFKC
} derive(Eq)

///|
pub impl Show for NormalizationForm with fn output(self, logger) {
  match self {
    NFD => logger.write_string("NFD")
    NFC => logger.write_string("NFC")
    NFKD => logger.write_string("NFKD")
    NFKC => logger.write_string("NFKC")
  }
}

///|
fn NormalizationForm::to_impl(
  self : NormalizationForm,
) -> @impl.NormalizationForm {
  match self {
    NFD => @impl.NFD
    NFC => @impl.NFC
    NFKD => @impl.NFKD
    NFKC => @impl.NFKC
  }
}

///|
pub fn normalize(s : String, form : NormalizationForm) -> String {
  @impl.normalize(s, form.to_impl())
}

///|
pub fn is_normalized(s : String, form : NormalizationForm) -> Bool {
  @impl.is_normalized(s, form.to_impl())
}
