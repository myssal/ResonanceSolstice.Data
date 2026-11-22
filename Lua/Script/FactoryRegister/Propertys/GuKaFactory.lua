RegProperty("GuKaFactory", {
  {
    name = "name",
    type = "StringT",
    des = "\229\144\141\231\167\176",
    arg0 = "",
    pyIgnore = true
  },
  {
    name = "des",
    type = "TextT",
    des = "\230\143\143\232\191\176",
    arg0 = "",
    pyIgnore = true
  },
  {
    name = "longDes",
    type = "TextT",
    des = "\233\149\191\230\143\143\232\191\176",
    arg0 = "",
    pyIgnore = true
  },
  {
    name = "tipsPath",
    type = "Png",
    des = "Tips\229\155\190\230\160\135",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  },
  {
    name = "iconPath",
    type = "Png",
    des = "Icon\229\155\190\230\160\135|\229\176\143\229\155\190\230\160\135",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  },
  {
    name = "gukaImg",
    type = "Png",
    des = "\229\146\149\229\141\161\229\155\190",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  },
  {
    name = "symbol",
    type = "Png",
    des = "\229\141\160\230\160\188\229\177\149\231\164\186\229\155\190",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  },
  {
    name = "imgXOffset",
    type = "Double",
    des = "\229\146\149\229\141\161\229\155\190x\229\129\143\231\167\187",
    arg0 = "0",
    pyIgnore = true
  },
  {
    name = "imgYOffset",
    type = "Double",
    des = "\229\146\149\229\141\161\229\155\190y\229\129\143\231\167\187",
    arg0 = "0",
    pyIgnore = true
  },
  {
    name = "x",
    type = "Int",
    des = "X\232\189\180\230\160\188\230\149\176",
    arg0 = "1",
    pyIgnore = true
  },
  {
    name = "y",
    type = "Int",
    des = "y\232\189\180\230\160\188\230\149\176",
    arg0 = "1",
    pyIgnore = true
  },
  {
    name = "HoleList",
    type = "Array",
    des = "\229\141\160\228\189\141\230\140\150\230\180\158",
    detail = "startX#startY#xLength#yLength",
    pyIgnore = true
  },
  {
    name = "startX",
    type = "Int",
    des = "\229\188\128\229\167\139X\228\189\141\231\189\174",
    arg0 = "0",
    pyIgnore = true
  },
  {
    name = "startY",
    type = "Int",
    des = "\229\188\128\229\167\139Y\228\189\141\231\189\174",
    arg0 = "0",
    pyIgnore = true
  },
  {
    name = "xLength",
    type = "Int",
    des = "x\233\149\191\229\186\166",
    arg0 = "0",
    pyIgnore = true
  },
  {
    name = "yLength",
    type = "Int",
    des = "y\233\149\191\229\186\166",
    arg0 = "0",
    pyIgnore = true
  },
  {name = "end", pyIgnore = true},
  {
    name = "skillList",
    type = "Array",
    des = "\229\133\179\232\129\148\230\138\128\232\131\189|\229\159\186\231\161\128\232\175\141\230\157\161"
  },
  {
    name = "skillId",
    type = "Factory",
    des = "\230\138\128\232\131\189",
    arg0 = "SkillFactory",
    pythonName = "id"
  },
  {name = "end"},
  {
    name = "upgradeCostList",
    type = "Array",
    des = "\229\141\135\231\186\167\230\182\136\232\128\151\229\136\151\232\161\168",
    detail = "id"
  },
  {
    name = "id",
    type = "Factory",
    des = "\229\141\135\231\186\167\230\182\136\232\128\151\230\157\144\230\150\153",
    arg0 = "ListFactory",
    agr1 = "\230\182\136\232\128\151\231\155\184\229\133\179"
  },
  {name = "end"},
  {
    name = "convertItem",
    type = "Array",
    des = "\231\155\184\229\144\140\229\146\149\229\141\161\232\189\172\230\141\162",
    detail = "id#num"
  },
  {
    name = "id",
    type = "Factory",
    des = "\233\129\147\229\133\183ID",
    arg0 = "ItemFactory"
  },
  {
    name = "num",
    type = "Int",
    des = "\230\149\176\233\135\143",
    arg0 = "50"
  },
  {name = "end"},
  {
    name = "maxLv",
    type = "Int",
    des = "\229\146\149\229\141\161\230\156\128\229\164\167\231\173\137\231\186\167",
    arg0 = "10"
  }
})
