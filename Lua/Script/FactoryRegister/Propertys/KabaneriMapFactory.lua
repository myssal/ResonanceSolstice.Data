RegProperty("KabaneriMapFactory", {
  {
    name = "rewardLimit",
    type = "Array",
    des = "\229\165\150\229\138\177\233\153\144\229\136\182",
    detail = "time#pointLimit"
  },
  {
    name = "time",
    type = "Int",
    des = "\230\184\184\230\136\143\230\151\182\233\151\180",
    arg0 = "300"
  },
  {
    name = "pointLimit",
    type = "Int",
    des = "\229\133\179\229\141\161\231\167\175\229\136\134\232\142\183\229\143\150\228\184\138\233\153\144",
    arg0 = "10000"
  },
  {name = "end"},
  {
    name = "completeAwardS",
    type = "Array",
    des = "\233\128\154\229\133\179\229\165\150\229\138\177",
    detail = "id#num"
  },
  {
    name = "id",
    type = "Factory",
    des = "\231\137\169\229\147\129id",
    arg0 = "ItemFactory#SourceMaterialFactory"
  },
  {
    name = "num",
    type = "Int",
    des = "\230\149\176\233\135\143",
    arg0 = "1"
  },
  {name = "end"},
  {
    name = "tokenRatio",
    type = "Double",
    des = "\231\167\175\229\136\134\229\133\145\230\141\162\228\187\163\229\184\129\231\179\187\230\149\176",
    arg0 = "1"
  },
  {
    name = "tokenId",
    type = "Factory",
    des = "\228\187\163\229\184\129\233\129\147\229\133\183",
    arg0 = "ItemFactory"
  },
  {
    name = "fatigueStart",
    type = "Int",
    des = "\229\188\128\229\167\139\230\182\136\232\128\151\231\150\178\229\138\179",
    arg0 = "0"
  },
  {
    name = "itemCost",
    type = "Array",
    des = "\230\182\136\232\128\151\233\129\147\229\133\183",
    detail = "id#num"
  },
  {
    name = "id",
    type = "Factory",
    des = "\233\129\147\229\133\183",
    arg0 = "ItemFactory"
  },
  {
    name = "num",
    type = "Int",
    des = "\230\149\176\233\135\143",
    arg0 = "1"
  },
  {name = "end"},
  {
    name = "weatherPool",
    type = "Array",
    des = "\229\164\169\230\176\148\230\177\160",
    detail = "id#weight",
    pyIgnore = true
  },
  {
    name = "id",
    type = "Factory",
    des = "\229\164\169\230\176\148id",
    arg0 = "TrainRoadMsgFactory",
    pyIgnore = true
  },
  {
    name = "weight",
    type = "Int",
    des = "\230\157\131\233\135\141",
    arg0 = "1",
    pyIgnore = true
  },
  {name = "end", pyIgnore = true},
  {
    name = "luaEventList",
    type = "Array",
    des = "\228\186\139\228\187\182\230\177\160",
    detail = "eventid#eventType#eventVal#isLoop#loopTime#loopFloat#loopOver",
    pyIgnore = true
  },
  {
    name = "eventid",
    type = "Factory",
    des = "\228\186\139\228\187\182",
    arg0 = "KabaneriEventFactory",
    pyIgnore = true
  },
  {
    name = "eventType",
    type = "Enum",
    des = "\232\167\166\229\143\145\231\177\187\229\158\139",
    arg0 = "none#grid#time#killnum",
    arg1 = "none",
    pyIgnore = true
  },
  {
    name = "eventVal",
    type = "Int",
    des = "\229\128\188",
    arg0 = "0",
    pyIgnore = true
  },
  {
    name = "isLoop",
    type = "Bool",
    des = "\230\152\175\229\144\166\229\190\170\231\142\175|\229\139\190\233\128\137\232\175\165\228\186\139\228\187\182\229\156\168\232\167\166\229\143\145\229\144\142\229\176\134\228\187\165\229\190\170\231\142\175\230\151\182\233\151\180\233\151\180\233\154\148\232\167\166\229\143\145",
    arg0 = "False",
    pyIgnore = true
  },
  {
    name = "loopTime",
    type = "Int",
    des = "\229\190\170\231\142\175\233\151\180\233\154\148",
    arg0 = "0",
    pyIgnore = true
  },
  {
    name = "loopFloat",
    type = "Int",
    des = "\229\190\170\231\142\175\233\151\180\233\154\148\230\181\174\229\138\168\229\128\188",
    arg0 = "0",
    pyIgnore = true
  },
  {
    name = "loopOver",
    type = "Int",
    des = "\229\190\170\231\142\175\231\187\147\230\157\159",
    arg0 = "0",
    pyIgnore = true
  },
  {name = "end", pyIgnore = true},
  {
    name = "levelId",
    type = "StringT",
    des = "\229\133\179\229\141\161\229\186\143\229\143\183",
    arg0 = "",
    pyIgnore = true
  },
  {
    name = "levelName",
    type = "StringT",
    des = "\229\133\179\229\141\161\229\144\141\231\167\176",
    arg0 = "",
    pyIgnore = true
  },
  {
    name = "levelIcon",
    type = "Png",
    des = "\229\133\179\229\141\161\229\155\190\230\160\135",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  }
})
