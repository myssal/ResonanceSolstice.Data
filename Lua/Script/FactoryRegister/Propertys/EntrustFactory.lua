RegProperty("EntrustFactory", {
  {
    name = "name",
    type = "StringT",
    des = "\229\167\148\230\137\152\229\144\141\231\167\176",
    arg0 = "",
    pyIgnore = true
  },
  {
    name = "describe",
    type = "TextT",
    des = "\229\167\148\230\180\190\230\143\143\232\191\176",
    arg0 = "",
    pyIgnore = true
  },
  {
    mod = "",
    name = "",
    type = "SysLine",
    des = "\228\187\187\229\138\161\229\165\150\229\138\177"
  },
  {
    name = "rewardType",
    type = "Enum",
    des = "\229\165\150\229\138\177\231\177\187\229\158\139||Coin:\231\186\175\233\147\129\231\155\159\229\184\129,Other:\233\147\129\231\155\159\229\184\129+\229\133\182\228\187\150",
    arg0 = "Coin#Other",
    arg1 = "Coin"
  },
  {
    name = "rewardList",
    type = "Array",
    des = "\229\165\150\229\138\177\229\136\151\232\161\168",
    detail = "id#basicsNum#png"
  },
  {
    name = "id",
    type = "Factory",
    des = "\231\137\169\229\147\129",
    arg0 = "ItemFactory#SourceMaterialFactory#EquipmentFactory#UnitFactory#HomeGoodsFactory#HomeFurnitureFactory#FridgeItemFactory#HomeCharacterSkinFactory#HomeWeaponFactory#CollectionCardPackFactory"
  },
  {
    name = "basicsNum",
    type = "Double",
    des = "\230\149\176\233\135\143\229\159\186\230\149\176",
    arg0 = "1"
  },
  {
    name = "png",
    type = "Png",
    des = "\229\165\150\229\138\177\229\155\190\230\160\135",
    arg0 = "",
    pyIgnore = true
  },
  {name = "end"},
  {
    mod = "",
    name = "",
    type = "SysLine",
    des = "\230\142\168\232\141\144\233\152\181\232\144\165"
  },
  {
    name = "recommendSideList",
    type = "Array",
    des = "\230\142\168\232\141\144\233\152\181\232\144\165\229\136\151\232\161\168",
    detail = "id"
  },
  {
    name = "id",
    type = "Factory",
    des = "\233\152\181\232\144\165id",
    arg0 = "TagFactory"
  },
  {name = "end"},
  {
    name = "",
    type = "SysLine",
    des = "\232\161\140\232\181\176\229\140\186\229\159\159"
  },
  {
    name = "walkWidth",
    type = "Double",
    des = "\232\161\140\232\181\176\229\140\186\229\159\159\229\174\189\229\186\166",
    arg0 = "0",
    pyIgnore = true
  },
  {
    name = "walkHeight",
    type = "Double",
    des = "\232\161\140\232\181\176\229\140\186\229\159\159\233\171\152\229\186\166",
    arg0 = "0",
    pyIgnore = true
  },
  {
    name = "offsetY",
    type = "Double",
    des = "\229\144\145\228\184\138\229\129\143\231\167\187\229\128\188",
    arg0 = "0",
    pyIgnore = true
  },
  {
    name = "",
    type = "SysLine",
    des = "\231\180\160\230\157\144\233\131\168\229\136\134"
  },
  {
    name = "scenePath",
    type = "Png",
    des = "\229\156\186\230\153\175\229\155\190",
    arg0 = "",
    pyIgnore = true
  },
  {
    name = "bgPath",
    type = "Png",
    des = "\232\131\140\230\153\175\229\155\190\231\137\135",
    arg0 = "",
    pyIgnore = true
  },
  {
    name = "notPath",
    type = "Png",
    des = "\230\156\170\229\188\128\229\167\139\229\155\190\231\137\135",
    arg0 = "",
    pyIgnore = true
  },
  {
    name = "onPath",
    type = "Png",
    des = "\232\191\155\232\161\140\228\184\173\229\155\190\231\137\135",
    arg0 = "",
    pyIgnore = true
  },
  {
    name = "completePath",
    type = "Png",
    des = "\229\174\140\230\136\144\229\155\190\231\137\135",
    arg0 = "",
    pyIgnore = true
  }
})
