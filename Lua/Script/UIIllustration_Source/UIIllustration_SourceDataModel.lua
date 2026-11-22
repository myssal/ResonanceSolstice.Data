local DataModel = {
  SourceList = {},
  AllSourceList = {},
  NowShowList = {},
  EnumEnemyCampList = {},
  Element = {},
  RightIndex = -1,
  Tweens = {},
  SortState = {
    index = 1,
    currentBtn = nil,
    currentDown = true
  }
}
DataModel.QualityCfg = {
  White = {
    qualityIndex = 1,
    bgPath = "UI/Book/Armament_Illustration/Card_N",
    iconColor = "#8A8A8A"
  },
  Blue = {
    qualityIndex = 2,
    bgPath = "UI/Book/Armament_Illustration/Card_R",
    iconColor = "#73AFDB"
  },
  Purple = {
    qualityIndex = 3,
    bgPath = "UI/Book/Armament_Illustration/Card_SR",
    iconColor = "#AE8CD7"
  },
  Golden = {
    qualityIndex = 4,
    bgPath = "UI/Book/Armament_Illustration/Card_SSR",
    iconColor = "#D7A30C"
  },
  Orange = {
    qualityIndex = 5,
    bgPath = "UI/Book/Armament_Illustration/Card_UR",
    iconColor = "#D78101"
  }
}
return DataModel
