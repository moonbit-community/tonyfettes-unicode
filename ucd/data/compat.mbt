///|
#deprecated("Import moonbit-community/ucd/decomposition instead")
pub using @decomposition {get_canonical_decomposition, get_compat_decomposition}

///|
#deprecated("Import moonbit-community/ucd/composition instead")
pub using @composition {lookup_composition, is_composition_excluded}

///|
#deprecated("Import moonbit-community/ucd/ccc instead")
pub using @ccc {lookup_ccc}

///|
#deprecated("Import moonbit-community/ucd/general_category instead")
pub using @general_category {lookup_general_category, is_mark}

///|
#deprecated("Import moonbit-community/ucd/case_mapping instead")
pub using @case_mapping {
  lookup_simple_uppercase,
  lookup_simple_lowercase,
  lookup_simple_titlecase,
  lookup_full_uppercase,
  lookup_full_lowercase,
  lookup_full_titlecase,
}

///|
#deprecated("Import moonbit-community/ucd/xid instead")
pub using @xid {is_xid_start, is_xid_continue}

///|
#deprecated("Import moonbit-community/ucd/alphabetic instead")
pub using @alphabetic {is_alphabetic}

///|
#deprecated("Import moonbit-community/ucd/lowercase instead")
pub using @lowercase {is_lowercase}

///|
#deprecated("Import moonbit-community/ucd/uppercase instead")
pub using @uppercase {is_uppercase}

///|
#deprecated("Import moonbit-community/ucd/white_space instead")
pub using @white_space {is_white_space}

///|
pub using @ccc {lookup_normalization_properties}
