RegProperty("EngineCoreFactory", {
  {
    name = "electricLimit",
    type = "Int",
    des = "\231\148\181\229\138\155\231\173\137\231\186\167\233\153\144\229\136\182|\231\148\181\229\138\155\232\190\190\229\136\176\229\164\154\229\176\145\231\186\167\229\144\142\230\137\141\229\143\175\229\188\128\229\144\175\230\160\184\229\191\131",
    arg0 = "0"
  },
  {
    name = "coreExpList",
    type = "Array",
    des = "\229\143\145\229\138\168\230\156\186\229\141\135\231\186\167\229\136\151\232\161\168",
    detail = "num#id#isBreak#effects"
  },
  {
    name = "num",
    type = "Int",
    des = "\229\141\149\229\156\186\230\156\128\233\171\152\230\172\161\230\149\176",
    arg0 = "1"
  },
  {
    name = "id",
    type = "Factory",
    des = "\229\141\135\231\186\167\231\155\184\229\133\179",
    arg0 = "ListFactory",
    arg1 = "\229\143\145\229\138\168\230\156\186\230\160\184\229\191\131"
  },
  {
    name = "isBreak",
    type = "Bool",
    des = "\230\152\175\229\144\166\233\156\128\232\166\129\231\170\129\231\160\180",
    arg0 = "False"
  },
  {
    name = "effects",
    type = "String",
    des = "\230\152\190\231\164\186\231\137\185\230\149\136",
    arg0 = "",
    pyIgnore = true
  },
  {name = "end"},
  {
    name = "coreLevelList",
    type = "Array",
    des = "\230\160\184\229\191\131\229\133\179\229\141\161\229\136\151\232\161\168|\230\160\184\229\191\131\228\184\141\229\144\140\231\173\137\231\186\167\229\140\186\233\151\180\229\134\133\233\133\141\231\189\174\231\154\132\229\133\179\229\141\161",
    detail = "grade#id#profileId"
  },
  {
    name = "grade",
    type = "Int",
    des = "\230\160\184\229\191\131\231\173\137\231\186\167",
    arg0 = "10"
  },
  {
    name = "id",
    type = "Factory",
    des = "\229\175\185\229\186\148\229\133\179\229\141\161",
    arg0 = "LevelFactory"
  },
  {
    name = "profileId",
    type = "Factory",
    des = "\229\175\185\229\186\148\230\128\170\231\137\169",
    arg0 = "UnitFactory"
  },
  {name = "end"},
  {
    name = "",
    type = "SysLine",
    des = "\230\150\135\230\156\172\233\131\168\229\136\134"
  },
  {
    name = "name",
    type = "Factory",
    des = "\229\144\141\231\167\176",
    arg0 = "TextFactory",
    pyIgnore = true
  },
  {
    name = "nameEN",
    type = "Factory",
    des = "\232\139\177\230\150\135\229\144\141\231\167\176",
    arg0 = "TextFactory",
    pyIgnore = true
  },
  {
    name = "record",
    type = "Factory",
    des = "\229\189\147\229\137\141\230\140\145\230\136\152\232\174\176\229\189\149",
    arg0 = "TextFactory",
    pyIgnore = true
  },
  {
    name = "challengeTips",
    type = "Factory",
    des = "\230\140\145\230\136\152\229\134\133\229\174\185\230\143\144\231\164\186",
    arg0 = "TextFactory",
    pyIgnore = true
  },
  {
    name = "mvpNum",
    type = "Factory",
    des = "MVP\230\172\161\230\149\176",
    arg0 = "TextFactory",
    pyIgnore = true
  },
  {
    name = "settlementNum",
    type = "Factory",
    des = "\231\187\147\231\174\151\230\140\145\230\136\152\232\174\176\229\189\149",
    arg0 = "TextFactory",
    pyIgnore = true
  },
  {
    name = "battleNum",
    type = "Factory",
    des = "\230\136\152\230\150\151\232\191\135\231\168\139\232\174\176\229\189\149",
    arg0 = "TextFactory",
    pyIgnore = true
  },
  {
    name = "battleName",
    type = "Factory",
    des = "\230\136\152\230\150\151\229\134\133\229\133\179\229\141\161\229\144\141\231\167\176",
    arg0 = "TextFactory",
    pyIgnore = true
  },
  {
    name = "rewardDes",
    type = "Factory",
    des = "\229\165\150\229\138\177\231\149\140\233\157\162\230\143\143\232\191\176",
    arg0 = "TextFactory",
    pyIgnore = true
  },
  {
    name = "",
    type = "SysLine",
    des = "\231\180\160\230\157\144\233\131\168\229\136\134"
  },
  {
    name = "coreIconPath",
    type = "Png",
    des = "\230\160\184\229\191\131\229\155\190\230\160\135",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  },
  {
    name = "coreIconPathW",
    type = "Png",
    des = "\230\160\184\229\191\131\230\157\161\228\187\182\229\155\190\230\160\135",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  },
  {
    name = "breakPath",
    type = "Png",
    des = "\231\170\129\231\160\180\230\157\161",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  },
  {
    name = "informationPath",
    type = "Png",
    des = "\228\191\161\230\129\175\229\186\149",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  },
  {
    name = "breakIconPath",
    type = "Png",
    des = "\231\170\129\231\160\180\229\186\149\231\148\168\229\155\190\230\160\135",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  },
  {
    name = "breakDi1Path",
    type = "Png",
    des = "\231\170\129\231\160\180\229\186\1491",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  },
  {
    name = "breakDi2Path",
    type = "Png",
    des = "\231\170\129\231\160\180\229\186\1492",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  },
  {
    name = "gradePath",
    type = "Png",
    des = "\229\141\135\231\186\167\229\144\142\229\186\149",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  },
  {
    name = "settlementIconPath",
    type = "Png",
    des = "\231\187\147\231\174\151\229\155\190\230\160\135",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  },
  {
    name = "overviewBgPath",
    type = "Png",
    des = "\230\128\187\232\167\136\232\131\140\230\153\175",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  },
  {
    name = "overviewSelectPath",
    type = "Png",
    des = "\230\128\187\232\167\136\233\128\137\230\139\169\229\155\190\230\161\136",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  },
  {
    name = "rewardBgPath",
    type = "Png",
    des = "\229\165\150\229\138\177\232\131\140\230\153\175\229\155\190\230\161\136",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  },
  {
    name = "rewardIconPath",
    type = "Png",
    des = "\229\165\150\229\138\177\231\149\140\233\157\162\229\155\190\230\160\135",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  },
  {
    name = "rewardGetPath",
    type = "Png",
    des = "\229\165\150\229\138\177\231\149\140\233\157\162\232\142\183\229\190\151\229\155\190\231\137\135",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  },
  {
    name = "rewardNotPath",
    type = "Png",
    des = "\229\165\150\229\138\177\231\149\140\233\157\162\230\156\170\232\142\183\229\190\151\229\155\190\231\137\135",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  },
  {
    name = "color",
    type = "String",
    des = "\229\173\151\228\189\147\233\162\156\232\137\178",
    arg0 = "",
    pyIgnore = true
  },
  {
    name = "",
    type = "SysLine",
    des = "\229\141\135\231\186\167\231\137\185\230\149\136\233\131\168\229\136\134"
  },
  {
    name = "upEffects",
    type = "String",
    des = "\229\141\135\231\186\167\231\137\185\230\149\136",
    arg0 = "",
    pyIgnore = true
  },
  {
    name = "",
    type = "SysLine",
    des = "\231\170\129\231\160\180\231\137\185\230\149\136\233\131\168\229\136\134"
  },
  {
    name = "breakEffects1",
    type = "String",
    des = "\231\170\129\231\160\180\231\137\185\230\149\1361",
    arg0 = "",
    pyIgnore = true
  },
  {
    name = "breakEffects2",
    type = "String",
    des = "\231\170\129\231\160\180\231\137\185\230\149\1362",
    arg0 = "",
    pyIgnore = true
  },
  {
    name = "breakEffects3",
    type = "String",
    des = "\231\170\129\231\160\180\231\137\185\230\149\1363",
    arg0 = "",
    pyIgnore = true
  }
})
