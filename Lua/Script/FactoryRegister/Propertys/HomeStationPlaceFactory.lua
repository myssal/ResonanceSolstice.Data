RegProperty("HomeStationPlaceFactory", {
  {
    name = "npcList",
    type = "Array",
    des = "NPC\229\136\151\232\161\168",
    detail = "id#npcX#npcZ#tree"
  },
  {
    name = "id",
    type = "Factory",
    des = "NPC\232\167\146\232\137\178",
    arg0 = "HomeCharacterFactory",
    pyIgnore = true
  },
  {
    name = "npcX",
    type = "Double",
    des = "\229\136\157\229\167\139\228\189\141\231\189\174X",
    arg0 = "1",
    pyIgnore = true
  },
  {
    name = "npcZ",
    type = "Double",
    des = "\229\136\157\229\167\139\228\189\141\231\189\174Z",
    arg0 = "1",
    pyIgnore = true
  },
  {
    name = "tree",
    type = "String",
    des = "\232\161\140\228\184\186\230\160\145",
    arg0 = "",
    pyIgnore = true
  },
  {
    name = "isRandom",
    type = "Bool",
    des = "\228\189\141\231\189\174\233\154\143\230\156\186",
    arg0 = "True"
  },
  {name = "end"},
  {
    name = "resId",
    type = "Factory",
    des = "\229\175\185\229\186\148\232\189\166\229\142\162",
    arg0 = "HomeCoachFactory"
  },
  {
    name = "serverId",
    type = "Factory",
    des = "\230\156\141\229\138\161\229\145\152\232\167\146\232\137\178",
    arg0 = "HomeCharacterFactory",
    pyIgnore = true
  },
  {
    name = "bgm",
    type = "Factory",
    des = "\232\131\140\230\153\175\233\159\179\228\185\144",
    arg0 = "SoundFactory",
    pyIgnore = true
  },
  {
    name = "npcRefreshList",
    type = "Array",
    des = "NPC\229\136\183\230\150\176\229\136\151\232\161\168",
    detail = "id#npcX#npcZ#tree"
  },
  {
    name = "id",
    type = "Factory",
    des = "NPC\232\167\146\232\137\178",
    arg0 = "HomeCharacterFactory",
    pyIgnore = true
  },
  {
    name = "npcX",
    type = "Double",
    des = "\229\136\157\229\167\139\228\189\141\231\189\174X",
    arg0 = "1",
    pyIgnore = true
  },
  {
    name = "npcZ",
    type = "Double",
    des = "\229\136\157\229\167\139\228\189\141\231\189\174Z",
    arg0 = "1",
    pyIgnore = true
  },
  {
    name = "tree",
    type = "String",
    des = "\232\161\140\228\184\186\230\160\145",
    arg0 = "",
    pyIgnore = true
  },
  {
    name = "isRandom",
    type = "Bool",
    des = "\228\189\141\231\189\174\233\154\143\230\156\186",
    arg0 = "True"
  },
  {name = "end"},
  {
    name = "entranceList",
    type = "Array",
    des = "\229\186\151\233\157\162\229\133\165\229\143\163\228\189\141\231\189\174\229\136\151\232\161\168",
    detail = "entranceX#entranceY"
  },
  {
    name = "entranceX",
    type = "Double",
    des = "X\228\189\141\231\189\174",
    arg0 = "0",
    pyIgnore = true
  },
  {
    name = "entranceY",
    type = "Double",
    des = "Y\228\189\141\231\189\174",
    arg0 = "0",
    pyIgnore = true
  },
  {name = "end"},
  {
    name = "exitList",
    type = "Array",
    des = "\229\186\151\233\157\162\229\135\186\229\143\163\228\189\141\231\189\174\229\136\151\232\161\168",
    detail = "exitX#exitY"
  },
  {
    name = "exitX",
    type = "Double",
    des = "X\228\189\141\231\189\174",
    arg0 = "0",
    pyIgnore = true
  },
  {
    name = "exitY",
    type = "Double",
    des = "Y\228\189\141\231\189\174",
    arg0 = "0",
    pyIgnore = true
  },
  {name = "end"},
  {
    name = "eventList",
    type = "Array",
    des = "NPC\228\186\139\228\187\182\229\136\151\232\161\168",
    detail = "questId#eventType#eventId#isAuto#startTime#endTime#activityId",
    pyIgnore = true
  },
  {
    name = "questId",
    type = "Factory",
    des = "\230\139\165\230\156\137\228\187\187\229\138\161|\232\167\163\233\148\129\230\156\170\229\174\140\230\136\144",
    arg0 = "QuestFactory",
    pyIgnore = true
  },
  {
    name = "homeQId",
    type = "Factory",
    des = "Q\231\137\136\232\167\146\232\137\178ID",
    arg0 = "HomeCharacterFactory",
    pyIgnore = true
  },
  {
    name = "qXPos",
    type = "Int",
    des = "\229\176\143\228\186\186X\229\157\144\230\160\135",
    arg0 = "0",
    pyIgnore = true
  },
  {
    name = "qYPos",
    type = "Int",
    des = "\229\176\143\228\186\186Y\229\157\144\230\160\135",
    arg0 = "0",
    pyIgnore = true
  },
  {
    name = "bubbleString",
    type = "String",
    des = "\230\176\148\230\179\161\232\183\175\229\190\132",
    arg0 = "",
    pyIgnore = true
  },
  {
    name = "eventType",
    type = "Enum",
    des = "\228\186\139\228\187\182\231\177\187\229\158\139||Dialog:\229\137\167\230\131\133,Level:\229\133\179\229\141\161",
    arg0 = "Dialog#Level",
    arg1 = "Dialog",
    pyIgnore = true
  },
  {
    name = "eventId",
    type = "Factory",
    des = "\228\186\139\228\187\182ID",
    arg0 = "ParagraphFactory#LevelFactory",
    pyIgnore = true
  },
  {
    name = "isAuto",
    type = "Bool",
    des = "\232\135\170\229\138\168\230\137\167\232\161\140",
    arg0 = "False",
    pyIgnore = true
  },
  {
    name = "activityId",
    type = "Factory",
    des = "\229\156\168\230\180\187\229\138\168\230\156\159\233\151\180\230\152\190\231\164\186|\230\180\187\229\138\168ID",
    arg0 = "ActivityFactory",
    pyIgnore = true
  },
  {
    name = "startTime",
    type = "String",
    des = "\229\188\128\229\167\139\230\151\182\233\151\180|\228\184\142\230\180\187\229\138\168\230\151\182\233\151\180\228\186\146\230\150\165",
    arg0 = "",
    pyIgnore = true
  },
  {
    name = "endTime",
    type = "String",
    des = "\231\187\147\230\157\159\230\151\182\233\151\180|\228\184\142\230\180\187\229\138\168\230\151\182\233\151\180\228\186\146\230\150\165",
    arg0 = "",
    pyIgnore = true
  },
  {name = "end", pyIgnore = true},
  {
    name = "",
    type = "SysLine",
    des = "\229\188\128\230\148\190\231\173\137\231\186\167",
    pyIgnore = true
  },
  {
    name = "levelOpen",
    type = "Int",
    des = "\229\188\128\229\144\175\231\173\137\231\186\167|\230\156\170\232\190\190\229\136\176\232\175\165\231\173\137\231\186\167\230\151\160\230\179\149\232\191\155\229\133\165\232\175\165\229\186\151\233\157\162",
    arg0 = "10"
  },
  {
    name = "lockedTip",
    type = "Factory",
    des = "\230\156\170\229\188\128\229\144\175\230\143\144\231\164\186|\230\156\170\232\190\190\229\136\176\232\175\165\231\173\137\231\186\167\231\130\185\229\135\187\229\186\151\233\157\162\231\187\153\231\154\132\230\143\144\231\164\186\232\175\173",
    arg0 = "TextFactory"
  },
  {
    name = "",
    type = "SysLine",
    des = "\230\145\132\229\131\143\230\156\186\228\189\141\231\189\174",
    pyIgnore = true
  },
  {
    name = "cameraLeft",
    type = "Double",
    des = "\233\149\156\229\164\180\233\148\129\229\174\154\229\183\166",
    arg0 = ""
  },
  {
    name = "cameraRight",
    type = "Double",
    des = "\233\149\156\229\164\180\233\148\129\229\174\154\229\143\179",
    arg0 = ""
  },
  {
    name = "animationCameraX",
    type = "Double",
    des = "\230\188\148\229\135\186\233\149\156\229\164\180X",
    arg0 = ""
  },
  {
    name = "animationCameraY",
    type = "Double",
    des = "\230\188\148\229\135\186\233\149\156\229\164\180Y",
    arg0 = ""
  },
  {
    name = "animationCameraZ",
    type = "Double",
    des = "\230\188\148\229\135\186\233\149\156\229\164\180Z",
    arg0 = ""
  },
  {
    name = "animationCameraRot",
    type = "Double",
    des = "\230\188\148\229\135\186\233\149\156\229\164\180\229\128\190\232\167\146",
    arg0 = ""
  },
  {
    name = "animationFieldOfView",
    type = "Double",
    des = "\230\188\148\229\135\186\233\149\156\229\164\180\229\185\191\232\167\146",
    arg0 = ""
  },
  {
    name = "",
    type = "SysLine",
    des = "\230\188\148\229\135\186\229\138\168\231\148\187",
    pyIgnore = true
  },
  {
    name = "animationPrefab",
    type = "String",
    des = "\230\146\173\230\148\190\229\138\168\231\148\187\233\162\132\229\136\182\228\189\147\232\183\175\229\190\132",
    arg0 = ""
  },
  {
    name = "dressStoreList",
    type = "Array",
    des = "\230\156\141\232\163\133\229\186\151\229\136\151\232\161\168",
    detail = "id"
  },
  {
    name = "id",
    type = "Factory",
    des = "\229\188\128\229\144\175\229\149\134\229\186\151",
    arg0 = "StoreFactory"
  },
  {name = "end"},
  {
    name = "bgStore",
    type = "Png",
    des = "\230\156\141\232\163\133\229\186\151\232\131\140\230\153\175",
    arg0 = ""
  },
  {
    name = "",
    type = "SysLine",
    des = "\232\143\156\229\141\149",
    pyIgnore = true
  },
  {
    name = "keepSingleMealList",
    type = "Array",
    des = "\229\141\149\228\186\186\233\164\144\232\143\156\229\141\149",
    detail = "id"
  },
  {
    name = "id",
    type = "Factory",
    des = "\229\141\149\228\186\186\233\164\144\232\143\156\229\141\149",
    arg0 = "FoodFactory"
  },
  {name = "end"},
  {
    name = "keepTeamMealList",
    type = "Array",
    des = "\229\155\162\233\152\159\233\164\144\232\143\156\229\141\149",
    detail = "id"
  },
  {
    name = "id",
    type = "Factory",
    des = "\229\155\162\233\152\159\233\164\144\232\143\156\229\141\149",
    arg0 = "FoodFactory"
  },
  {name = "end"},
  {
    name = "inviteTimes",
    type = "Int",
    des = "\232\175\183\229\174\162\233\130\128\232\175\183\230\172\161\230\149\176",
    arg0 = "6"
  },
  {
    name = "titleBuffDesLCZ",
    type = "Factory",
    des = "\229\136\151\232\189\166\233\149\191buff\230\160\135\233\162\152",
    arg0 = "TextFactory"
  },
  {
    name = "bgBuffDesLCZ",
    type = "Png",
    des = "\229\136\151\232\189\166\233\149\191buff\232\131\140\230\153\175",
    arg0 = ""
  },
  {
    name = "decBuffDesLCZ",
    type = "Png",
    des = "\229\136\151\232\189\166\233\149\191buff\231\171\150\231\186\191\232\163\133\233\165\176",
    arg0 = "100|100"
  },
  {
    name = "titleBuffDesMember",
    type = "Factory",
    des = "\233\152\159\229\145\152buff\230\160\135\233\162\152",
    arg0 = "TextFactory"
  },
  {
    name = "bgBuffDesMember",
    type = "Png",
    des = "\233\152\159\229\145\152buff\232\131\140\230\153\175",
    arg0 = ""
  },
  {
    name = "decBuffDesMember",
    type = "Png",
    des = "\233\152\159\229\145\152buff\231\171\150\231\186\191\232\163\133\233\165\176",
    arg0 = "100|100"
  },
  {
    name = "",
    type = "SysLine",
    des = "\232\143\156\229\141\149UI\229\184\131\229\177\128",
    pyIgnore = true
  },
  {
    name = "bgTop",
    type = "Png",
    des = "\228\184\138\233\131\168\232\131\140\230\153\175\230\168\170\229\185\133",
    arg0 = ""
  },
  {
    name = "nameSingle",
    type = "StringT",
    des = "\233\161\181\231\173\190\229\141\149\228\186\186\233\164\144\229\144\141\231\167\176",
    arg0 = ""
  },
  {
    name = "iconSingleOn",
    type = "Png",
    des = "\233\161\181\231\173\190\229\141\149\228\186\186\233\164\144\229\155\190\230\160\135\229\188\128\229\144\175\231\138\182\230\128\129",
    arg0 = "100|100"
  },
  {
    name = "iconSingleOff",
    type = "Png",
    des = "\233\161\181\231\173\190\229\141\149\228\186\186\233\164\144\229\155\190\230\160\135\229\133\179\233\151\173\231\138\182\230\128\129",
    arg0 = "100|100"
  },
  {
    name = "nameTeam",
    type = "StringT",
    des = "\233\161\181\231\173\190\229\155\162\233\152\159\233\164\144\229\144\141\231\167\176",
    arg0 = ""
  },
  {
    name = "iconTeamOn",
    type = "Png",
    des = "\233\161\181\231\173\190\229\155\162\233\152\159\233\164\144\229\155\190\230\160\135\229\188\128\229\144\175\231\138\182\230\128\129",
    arg0 = "100|100"
  },
  {
    name = "iconTeamOff",
    type = "Png",
    des = "\233\161\181\231\173\190\229\155\162\233\152\159\233\164\144\229\155\190\230\160\135\229\133\179\233\151\173\231\138\182\230\128\129",
    arg0 = "100|100"
  },
  {
    name = "bgRight",
    type = "Png",
    des = "\229\143\179\232\190\185\232\131\140\230\153\175",
    arg0 = ""
  },
  {
    name = "picRightTip",
    type = "Png",
    des = "\229\143\179\232\190\185\230\156\170\233\128\137\228\184\173\230\143\144\231\164\186\229\155\190",
    arg0 = ""
  },
  {
    name = "textRightTip",
    type = "Factory",
    des = "\229\143\179\232\190\185\230\156\170\233\128\137\228\184\173\230\150\135\229\173\151",
    arg0 = "TextFactory"
  },
  {
    name = "listPrefab",
    type = "String",
    des = "\232\143\156\229\141\149\233\157\162\230\157\191\233\162\132\229\136\182\228\187\182",
    arg0 = ""
  },
  {
    name = "",
    type = "SysLine",
    des = "\231\187\147\231\174\151UI\229\184\131\229\177\128",
    pyIgnore = true
  },
  {
    name = "bgSettlement",
    type = "Png",
    des = "\231\187\147\231\174\151\232\131\140\230\153\175",
    arg0 = ""
  },
  {
    name = "iconSettlement",
    type = "Png",
    des = "\231\187\147\231\174\151\229\155\190\230\160\135",
    arg0 = ""
  },
  {
    name = "textTitle",
    type = "Factory",
    des = "\231\187\147\231\174\151\230\160\135\233\162\152",
    arg0 = "TextFactory"
  },
  {
    name = "textSettlement",
    type = "Factory",
    des = "\229\143\179\232\190\185\230\156\170\233\128\137\228\184\173\230\150\135\229\173\151",
    arg0 = "TextFactory"
  },
  {
    name = "animeName",
    type = "String",
    des = "\229\138\168\231\148\187\229\144\141\231\167\176",
    arg0 = ""
  },
  {
    name = "animeEndName",
    type = "String",
    des = "\230\148\182\229\176\190\229\138\168\231\148\187\229\144\141\231\167\176",
    arg0 = ""
  },
  {
    name = "isPickFood",
    type = "Bool",
    des = "\230\152\175\229\144\166\230\139\191\232\181\183\233\163\159\231\137\169",
    arg0 = "false"
  },
  {
    name = "bgPhoto",
    type = "Png",
    des = "\230\139\141\231\133\167\232\131\140\230\153\175",
    arg0 = ""
  }
})
