///|
/// Check whether a character has the Unicode XID_Start property.
///
/// XID_Start is the recommended start class for Unicode default identifiers.
pub fn is_xid_start(c : Char) -> Bool {
  @ucd_data.is_xid_start(c)
}

///|
/// Check whether a character has the Unicode XID_Continue property.
///
/// XID_Continue is the recommended continuation class for Unicode default
/// identifiers and includes every XID_Start character.
pub fn is_xid_continue(c : Char) -> Bool {
  @ucd_data.is_xid_continue(c)
}
