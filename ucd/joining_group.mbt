///|
/// Joining_Group values and lookup
/// Generated from DerivedJoiningGroup.txt

///|
/// Unicode Joining_Group values
/// See the Unicode Standard, section 9.2, Arabic:
/// https://www.unicode.org/versions/latest/core-spec/chapter-9/#G7480
#derive(Debug, Eq)
pub(all) enum JoiningGroup {
  AfricanFeh // African_Feh
  AfricanNoon // African_Noon
  AfricanQaf // African_Qaf
  Ain // Ain
  Alaph // Alaph
  Alef // Alef
  Beh // Beh
  Beth // Beth
  BurushaskiYehBarree // Burushaski_Yeh_Barree
  CrownAin // Crown_Ain
  CrownBeh // Crown_Beh
  CrownFeh // Crown_Feh
  CrownHah // Crown_Hah
  CrownHeh // Crown_Heh
  CrownKaf // Crown_Kaf
  CrownMeem // Crown_Meem
  CrownSad // Crown_Sad
  CrownSeen // Crown_Seen
  CrownTah // Crown_Tah
  Dal // Dal
  DalathRish // Dalath_Rish
  E // E
  FarsiYeh // Farsi_Yeh
  Fe // Fe
  Feh // Feh
  FinalSemkath // Final_Semkath
  Gaf // Gaf
  Gamal // Gamal
  Hah // Hah
  HanifiRohingyaKinnaYa // Hanifi_Rohingya_Kinna_Ya
  HanifiRohingyaPa // Hanifi_Rohingya_Pa
  He // He
  Heh // Heh
  HehGoal // Heh_Goal
  Heth // Heth
  Kaf // Kaf
  Kaph // Kaph
  KashmiriYeh // Kashmiri_Yeh
  Khaph // Khaph
  KnottedHeh // Knotted_Heh
  Lam // Lam
  Lamadh // Lamadh
  MalayalamBha // Malayalam_Bha
  MalayalamJa // Malayalam_Ja
  MalayalamLla // Malayalam_Lla
  MalayalamLlla // Malayalam_Llla
  MalayalamNga // Malayalam_Nga
  MalayalamNna // Malayalam_Nna
  MalayalamNnna // Malayalam_Nnna
  MalayalamNya // Malayalam_Nya
  MalayalamRa // Malayalam_Ra
  MalayalamSsa // Malayalam_Ssa
  MalayalamTta // Malayalam_Tta
  ManichaeanAleph // Manichaean_Aleph
  ManichaeanAyin // Manichaean_Ayin
  ManichaeanBeth // Manichaean_Beth
  ManichaeanDaleth // Manichaean_Daleth
  ManichaeanDhamedh // Manichaean_Dhamedh
  ManichaeanFive // Manichaean_Five
  ManichaeanGimel // Manichaean_Gimel
  ManichaeanHeth // Manichaean_Heth
  ManichaeanHundred // Manichaean_Hundred
  ManichaeanKaph // Manichaean_Kaph
  ManichaeanLamedh // Manichaean_Lamedh
  ManichaeanMem // Manichaean_Mem
  ManichaeanNun // Manichaean_Nun
  ManichaeanOne // Manichaean_One
  ManichaeanPe // Manichaean_Pe
  ManichaeanQoph // Manichaean_Qoph
  ManichaeanResh // Manichaean_Resh
  ManichaeanSadhe // Manichaean_Sadhe
  ManichaeanSamekh // Manichaean_Samekh
  ManichaeanTaw // Manichaean_Taw
  ManichaeanTen // Manichaean_Ten
  ManichaeanTeth // Manichaean_Teth
  ManichaeanThamedh // Manichaean_Thamedh
  ManichaeanTwenty // Manichaean_Twenty
  ManichaeanWaw // Manichaean_Waw
  ManichaeanYodh // Manichaean_Yodh
  ManichaeanZayin // Manichaean_Zayin
  Meem // Meem
  Mim // Mim
  NoJoiningGroup // No_Joining_Group
  Noon // Noon
  Nun // Nun
  Nya // Nya
  Pe // Pe
  Qaf // Qaf
  Qaph // Qaph
  Reh // Reh
  ReversedPe // Reversed_Pe
  RohingyaYeh // Rohingya_Yeh
  Sad // Sad
  Sadhe // Sadhe
  Seen // Seen
  Semkath // Semkath
  Shin // Shin
  StraightWaw // Straight_Waw
  SwashKaf // Swash_Kaf
  SyriacWaw // Syriac_Waw
  Tah // Tah
  Taw // Taw
  TehMarbuta // Teh_Marbuta
  TehMarbutaGoal // Teh_Marbuta_Goal
  Teth // Teth
  ThinNoon // Thin_Noon
  ThinYeh // Thin_Yeh
  VerticalTail // Vertical_Tail
  Waw // Waw
  Yeh // Yeh
  YehBarree // Yeh_Barree
  YehWithTail // Yeh_With_Tail
  Yudh // Yudh
  YudhHe // Yudh_He
  Zain // Zain
  Zhain // Zhain
}

///|
#deprecated("Use `Debug::to_repr` instead", skip_current_package=true)
#doc(hidden)
pub extend JoiningGroup with Debug::{to_repr}

///|
pub extend JoiningGroup with Eq::{not_equal, equal}

///|
pub extend JoiningGroup with Show::{to_string, output}

///|
pub impl Show for JoiningGroup with fn output(self, logger) {
  logger.write_string(
    match self {
      AfricanFeh => "AfricanFeh"
      AfricanNoon => "AfricanNoon"
      AfricanQaf => "AfricanQaf"
      Ain => "Ain"
      Alaph => "Alaph"
      Alef => "Alef"
      Beh => "Beh"
      Beth => "Beth"
      BurushaskiYehBarree => "BurushaskiYehBarree"
      CrownAin => "CrownAin"
      CrownBeh => "CrownBeh"
      CrownFeh => "CrownFeh"
      CrownHah => "CrownHah"
      CrownHeh => "CrownHeh"
      CrownKaf => "CrownKaf"
      CrownMeem => "CrownMeem"
      CrownSad => "CrownSad"
      CrownSeen => "CrownSeen"
      CrownTah => "CrownTah"
      Dal => "Dal"
      DalathRish => "DalathRish"
      E => "E"
      FarsiYeh => "FarsiYeh"
      Fe => "Fe"
      Feh => "Feh"
      FinalSemkath => "FinalSemkath"
      Gaf => "Gaf"
      Gamal => "Gamal"
      Hah => "Hah"
      HanifiRohingyaKinnaYa => "HanifiRohingyaKinnaYa"
      HanifiRohingyaPa => "HanifiRohingyaPa"
      He => "He"
      Heh => "Heh"
      HehGoal => "HehGoal"
      Heth => "Heth"
      Kaf => "Kaf"
      Kaph => "Kaph"
      KashmiriYeh => "KashmiriYeh"
      Khaph => "Khaph"
      KnottedHeh => "KnottedHeh"
      Lam => "Lam"
      Lamadh => "Lamadh"
      MalayalamBha => "MalayalamBha"
      MalayalamJa => "MalayalamJa"
      MalayalamLla => "MalayalamLla"
      MalayalamLlla => "MalayalamLlla"
      MalayalamNga => "MalayalamNga"
      MalayalamNna => "MalayalamNna"
      MalayalamNnna => "MalayalamNnna"
      MalayalamNya => "MalayalamNya"
      MalayalamRa => "MalayalamRa"
      MalayalamSsa => "MalayalamSsa"
      MalayalamTta => "MalayalamTta"
      ManichaeanAleph => "ManichaeanAleph"
      ManichaeanAyin => "ManichaeanAyin"
      ManichaeanBeth => "ManichaeanBeth"
      ManichaeanDaleth => "ManichaeanDaleth"
      ManichaeanDhamedh => "ManichaeanDhamedh"
      ManichaeanFive => "ManichaeanFive"
      ManichaeanGimel => "ManichaeanGimel"
      ManichaeanHeth => "ManichaeanHeth"
      ManichaeanHundred => "ManichaeanHundred"
      ManichaeanKaph => "ManichaeanKaph"
      ManichaeanLamedh => "ManichaeanLamedh"
      ManichaeanMem => "ManichaeanMem"
      ManichaeanNun => "ManichaeanNun"
      ManichaeanOne => "ManichaeanOne"
      ManichaeanPe => "ManichaeanPe"
      ManichaeanQoph => "ManichaeanQoph"
      ManichaeanResh => "ManichaeanResh"
      ManichaeanSadhe => "ManichaeanSadhe"
      ManichaeanSamekh => "ManichaeanSamekh"
      ManichaeanTaw => "ManichaeanTaw"
      ManichaeanTen => "ManichaeanTen"
      ManichaeanTeth => "ManichaeanTeth"
      ManichaeanThamedh => "ManichaeanThamedh"
      ManichaeanTwenty => "ManichaeanTwenty"
      ManichaeanWaw => "ManichaeanWaw"
      ManichaeanYodh => "ManichaeanYodh"
      ManichaeanZayin => "ManichaeanZayin"
      Meem => "Meem"
      Mim => "Mim"
      NoJoiningGroup => "NoJoiningGroup"
      Noon => "Noon"
      Nun => "Nun"
      Nya => "Nya"
      Pe => "Pe"
      Qaf => "Qaf"
      Qaph => "Qaph"
      Reh => "Reh"
      ReversedPe => "ReversedPe"
      RohingyaYeh => "RohingyaYeh"
      Sad => "Sad"
      Sadhe => "Sadhe"
      Seen => "Seen"
      Semkath => "Semkath"
      Shin => "Shin"
      StraightWaw => "StraightWaw"
      SwashKaf => "SwashKaf"
      SyriacWaw => "SyriacWaw"
      Tah => "Tah"
      Taw => "Taw"
      TehMarbuta => "TehMarbuta"
      TehMarbutaGoal => "TehMarbutaGoal"
      Teth => "Teth"
      ThinNoon => "ThinNoon"
      ThinYeh => "ThinYeh"
      VerticalTail => "VerticalTail"
      Waw => "Waw"
      Yeh => "Yeh"
      YehBarree => "YehBarree"
      YehWithTail => "YehWithTail"
      Yudh => "Yudh"
      YudhHe => "YudhHe"
      Zain => "Zain"
      Zhain => "Zhain"
    },
  )
}

///|
/// Convert a JoiningGroup ordinal, below 116, to the enum value.
///
/// A constructor without arguments is its ordinal on every backend. A
/// `match` or a table would cost a jump table or a load on wasm, wasm-gc
/// and JS, slower there than the trie lookup itself.
fn ordinal_to_joining_group(ordinal : Int32) -> JoiningGroup = "%identity"

///|
/// Get the Joining_Group for a character.
///
/// Joining_Group classifies the letters of cursive scripts such as Arabic,
/// Syriac, and Manichaean by the shape they join with: letters that
/// differ only in their dots, like U+0628 ARABIC LETTER BEH and U+062A
/// ARABIC LETTER TEH, share a group. Characters that are not such
/// letters, including unassigned code points, are NoJoiningGroup.
///
/// The value `Pe` shares its name with a `GeneralCategory` value: write
/// `JoiningGroup::Pe` or `GeneralCategory::Pe` where the type is not
/// known from the context.
pub fn joining_group(c : Char) -> JoiningGroup {
  ordinal_to_joining_group(@joining_group.lookup_joining_group(c))
}
