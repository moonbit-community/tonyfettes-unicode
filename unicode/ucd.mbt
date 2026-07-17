///|
pub using @impl {
  is_xid_continue,
  is_xid_start,
  to_lowercase,
  to_simple_lowercase,
  to_simple_titlecase,
  to_simple_uppercase,
  to_titlecase,
  to_uppercase,
}

///|
pub(all) enum GeneralCategoryGroup {
  L
  M
  N
  Z
  P
  S
  C
} derive(Debug, Eq)

///|
pub impl Show for GeneralCategoryGroup with fn output(self, logger) {
  match self {
    L => logger.write_string("L")
    M => logger.write_string("M")
    N => logger.write_string("N")
    Z => logger.write_string("Z")
    P => logger.write_string("P")
    S => logger.write_string("S")
    C => logger.write_string("C")
  }
}

///|
pub(all) enum GeneralCategory {
  Lu
  Ll
  Lt
  Lm
  Lo
  Mn
  Mc
  Me
  Nd
  Nl
  No
  Zs
  Zl
  Zp
  Pc
  Pd
  Ps
  Pe
  Pi
  Pf
  Po
  Sm
  Sc
  Sk
  So
  Cc
  Cf
  Cs
  Co
  Cn
} derive(Eq)

///|
pub impl Show for GeneralCategory with fn output(self, logger) {
  match self {
    Lu => logger.write_string("Lu")
    Ll => logger.write_string("Ll")
    Lt => logger.write_string("Lt")
    Lm => logger.write_string("Lm")
    Lo => logger.write_string("Lo")
    Mn => logger.write_string("Mn")
    Mc => logger.write_string("Mc")
    Me => logger.write_string("Me")
    Nd => logger.write_string("Nd")
    Nl => logger.write_string("Nl")
    No => logger.write_string("No")
    Zs => logger.write_string("Zs")
    Zl => logger.write_string("Zl")
    Zp => logger.write_string("Zp")
    Pc => logger.write_string("Pc")
    Pd => logger.write_string("Pd")
    Ps => logger.write_string("Ps")
    Pe => logger.write_string("Pe")
    Pi => logger.write_string("Pi")
    Pf => logger.write_string("Pf")
    Po => logger.write_string("Po")
    Sm => logger.write_string("Sm")
    Sc => logger.write_string("Sc")
    Sk => logger.write_string("Sk")
    So => logger.write_string("So")
    Cc => logger.write_string("Cc")
    Cf => logger.write_string("Cf")
    Cs => logger.write_string("Cs")
    Co => logger.write_string("Co")
    Cn => logger.write_string("Cn")
  }
}

///|
fn general_category_from_impl(
  category : @impl.GeneralCategory,
) -> GeneralCategory {
  match category {
    @impl.Lu => Lu
    @impl.Ll => Ll
    @impl.Lt => Lt
    @impl.Lm => Lm
    @impl.Lo => Lo
    @impl.Mn => Mn
    @impl.Mc => Mc
    @impl.Me => Me
    @impl.Nd => Nd
    @impl.Nl => Nl
    @impl.No => No
    @impl.Zs => Zs
    @impl.Zl => Zl
    @impl.Zp => Zp
    @impl.Pc => Pc
    @impl.Pd => Pd
    @impl.Ps => Ps
    @impl.Pe => Pe
    @impl.Pi => Pi
    @impl.Pf => Pf
    @impl.Po => Po
    @impl.Sm => Sm
    @impl.Sc => Sc
    @impl.Sk => Sk
    @impl.So => So
    @impl.Cc => Cc
    @impl.Cf => Cf
    @impl.Cs => Cs
    @impl.Co => Co
    @impl.Cn => Cn
  }
}

///|
pub fn general_category(c : Char) -> GeneralCategory {
  general_category_from_impl(@impl.general_category(c))
}

///|
pub fn GeneralCategory::group(self : GeneralCategory) -> GeneralCategoryGroup {
  match self {
    Lu | Ll | Lt | Lm | Lo => L
    Mn | Mc | Me => M
    Nd | Nl | No => N
    Zs | Zl | Zp => Z
    Pc | Pd | Ps | Pe | Pi | Pf | Po => P
    Sm | Sc | Sk | So => S
    Cc | Cf | Cs | Co | Cn => C
  }
}
