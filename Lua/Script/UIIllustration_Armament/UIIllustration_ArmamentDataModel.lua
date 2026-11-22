local DataModel = {
  ArmList = {},
  AllArmList = {},
  NowShowList = {},
  EnumArmTypeList = {},
  Element = {},
  RightIndex = -1,
  Tweens = {},
  SortState = {
    index = 1,
    currentBtn = nil,
    currentDown = true
  },
  UnlockCount = 0,
  TotalCount = 0
}
DataModel.QualityCfg = {
  Blue = {
    qualityIndex = 1,
    bgPath = "UI/Book/Armament_Illustration/Card_R",
    iconColor = "#73AFDB"
  },
  Purple = {
    qualityIndex = 2,
    bgPath = "UI/Book/Armament_Illustration/Card_SR",
    iconColor = "#AE8CD7"
  },
  Golden = {
    qualityIndex = 3,
    bgPath = "UI/Book/Armament_Illustration/Card_SSR",
    iconColor = "#D7A30C"
  },
  Orange = {
    qualityIndex = 4,
    bgPath = "UI/Book/Armament_Illustration/Card_UR",
    iconColor = "#D78101"
  }
}
return DataModel
