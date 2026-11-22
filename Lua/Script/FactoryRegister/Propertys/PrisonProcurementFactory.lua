RegProperty("PrisonProcurementFactory", {
  {
    name = "name",
    type = "StringT",
    des = "\232\174\162\229\141\149\229\144\141\231\167\176",
    arg0 = ""
  },
  {
    mod = "\233\187\152\232\174\164",
    name = "rarity",
    type = "Int",
    des = "\231\168\128\230\156\137\229\186\166|\232\174\162\229\141\149\231\154\132\231\168\128\230\156\137\229\186\166\239\188\140\228\187\142\228\189\142\229\136\176\233\171\152\228\184\1861-5",
    arg0 = "1"
  },
  {
    mod = "\233\187\152\232\174\164",
    name = "target",
    type = "Factory",
    des = "\233\135\135\232\180\173\231\155\174\230\160\135",
    arg0 = "ItemFactory#HomeGoodsFactory#SourceMaterialFactory"
  },
  {
    mod = "\233\187\152\232\174\164",
    name = "targetNum",
    type = "Int",
    des = "\233\135\135\232\180\173\230\149\176\233\135\143",
    arg0 = "0"
  },
  {
    mod = "\233\187\152\232\174\164",
    name = "costTime",
    type = "Int",
    des = "\233\135\135\232\180\173\230\151\182\233\151\180|\229\136\134\233\146\159",
    arg0 = "60"
  },
  {
    mod = "\233\187\152\232\174\164",
    name = "costList",
    type = "Array",
    des = "\231\180\160\230\157\144\230\182\136\232\128\151\229\136\151\232\161\168|\228\184\141\229\144\140\230\151\182\233\151\180\233\156\128\232\166\129\230\182\136\232\128\151\231\154\132\230\151\182\233\151\180\227\128\129\231\180\160\230\157\144\229\146\140\232\167\163\233\148\129\230\157\161\228\187\182",
    detail = "id#num"
  },
  {
    name = "id",
    type = "Factory",
    des = "\231\180\160\230\157\144",
    arg0 = "ItemFactory#HomeGoodsFactory#SourceMaterialFactory"
  },
  {
    name = "num",
    type = "Int",
    des = "\231\180\160\230\157\144\230\149\176\233\135\143",
    arg0 = "0"
  },
  {name = "end"},
  {
    mod = "\228\186\164\232\180\167\232\174\162\229\141\149",
    name = "requireItemList",
    type = "Array",
    des = "\233\156\128\230\177\130\231\137\169\229\147\129\229\136\151\232\161\168",
    detail = "id#num"
  },
  {
    name = "id",
    type = "Factory",
    des = "\233\156\128\230\177\130\231\137\169\229\147\129",
    arg0 = "ItemFactory#EquipmentFactory#HomeGoodsFactory#SourceMaterialFactory"
  },
  {
    name = "num",
    type = "Int",
    des = "\230\149\176\233\135\143",
    arg0 = "1"
  },
  {name = "end"},
  {
    mod = "\228\186\164\232\180\167\232\174\162\229\141\149",
    name = "rewardsList",
    type = "Array",
    des = "\229\165\150\229\138\177\229\136\151\232\161\168",
    detail = "id#num"
  },
  {
    name = "id",
    type = "Factory",
    des = "\231\137\169\229\147\129",
    arg0 = "ItemFactory#SourceMaterialFactory#EquipmentFactory#UnitFactory#HomeGoodsFactory#HomeFurnitureFactory#FridgeItemFactory#HomeCharacterSkinFactory#HomeWeaponFactory#CollectionCardPackFactory"
  },
  {
    name = "num",
    type = "Int",
    des = "\230\149\176\233\135\143",
    arg0 = "1"
  },
  {name = "end"},
  {
    mod = "\228\186\164\232\180\167\232\174\162\229\141\149",
    name = "levelLimited",
    type = "Int",
    des = "\231\173\137\231\186\167\233\153\144\229\136\182|\232\174\162\229\141\149\231\173\137\231\186\167\232\167\163\233\148\129",
    arg0 = "1"
  },
  {
    mod = "\228\186\164\232\180\167\232\174\162\229\141\149",
    name = "requireProduction",
    type = "Factory",
    des = "\229\175\185\229\186\148\233\133\141\230\150\185\229\155\190\231\186\184|\228\186\164\232\180\167\232\180\167\231\137\169\231\154\132\229\175\185\229\186\148\233\133\141\230\150\185",
    arg0 = "ProductionFactory"
  },
  {
    mod = "\233\187\152\232\174\164",
    name = "expGet",
    type = "Array",
    des = "\231\187\143\233\170\140\229\128\188\232\142\183\229\143\150\229\136\151\232\161\168|\231\187\143\233\170\140\229\128\188\232\142\183\229\143\150\229\136\151\232\161\168",
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
    arg0 = "0"
  },
  {name = "end"},
  {
    mod = "\230\175\143\229\145\168\232\174\162\229\141\149",
    name = "weekRequireItemList",
    type = "Array",
    des = "\230\175\143\229\145\168\232\174\162\229\141\149\233\156\128\230\177\130\231\137\169\229\147\129\229\136\151\232\161\168",
    detail = "id#perNum#totalNum"
  },
  {
    name = "id",
    type = "Factory",
    des = "\233\156\128\230\177\130\231\137\169\229\147\129",
    arg0 = "ItemFactory#EquipmentFactory#HomeGoodsFactory#SourceMaterialFactory"
  },
  {
    name = "perNum",
    type = "Int",
    des = "\230\175\143\228\187\189\230\143\144\228\186\164\230\149\176\233\135\143",
    arg0 = "1"
  },
  {
    name = "totalNum",
    type = "Int",
    des = "\232\174\162\229\141\149\233\156\128\230\177\130\230\128\187\230\149\176\233\135\143",
    arg0 = "1"
  },
  {name = "end"},
  {
    mod = "\230\175\143\229\145\168\232\174\162\229\141\149",
    name = "weekPerRewardsList",
    type = "Array",
    des = "\230\175\143\228\187\189\229\165\150\229\138\177\229\136\151\232\161\168",
    detail = "id#num"
  },
  {
    name = "id",
    type = "Factory",
    des = "\231\137\169\229\147\129",
    arg0 = "ItemFactory#SourceMaterialFactory#EquipmentFactory#UnitFactory#HomeGoodsFactory#HomeFurnitureFactory#FridgeItemFactory#HomeCharacterSkinFactory#HomeWeaponFactory#CollectionCardPackFactory"
  },
  {
    name = "num",
    type = "Int",
    des = "\230\149\176\233\135\143",
    arg0 = "1"
  },
  {name = "end"},
  {
    mod = "\230\175\143\229\145\168\232\174\162\229\141\149",
    name = "weekTotalRewardsList",
    type = "Array",
    des = "\229\174\140\230\136\144\232\174\162\229\141\149\229\165\150\229\138\177\229\136\151\232\161\168",
    detail = "id#num"
  },
  {
    name = "id",
    type = "Factory",
    des = "\231\137\169\229\147\129",
    arg0 = "ItemFactory#SourceMaterialFactory#EquipmentFactory#UnitFactory#HomeGoodsFactory#HomeFurnitureFactory#FridgeItemFactory#HomeCharacterSkinFactory#HomeWeaponFactory#CollectionCardPackFactory"
  },
  {
    name = "num",
    type = "Int",
    des = "\230\149\176\233\135\143",
    arg0 = "1"
  },
  {name = "end"},
  {
    mod = "\230\175\143\229\145\168\232\174\162\229\141\149",
    name = "weekRequireProduction",
    type = "Factory",
    des = "\229\175\185\229\186\148\233\133\141\230\150\185\229\155\190\231\186\184|\228\186\164\232\180\167\232\180\167\231\137\169\231\154\132\229\175\185\229\186\148\233\133\141\230\150\185",
    arg0 = "ProductionFactory"
  },
  {
    mod = "\230\175\143\229\145\168\232\174\162\229\141\149",
    name = "rarity",
    type = "Int",
    des = "\231\168\128\230\156\137\229\186\166|\232\174\162\229\141\149\231\154\132\231\168\128\230\156\137\229\186\166\239\188\140\228\187\142\228\189\142\229\136\176\233\171\152\228\184\1861-5",
    arg0 = "1"
  },
  {
    mod = "\230\175\143\229\145\168\232\174\162\229\141\149",
    name = "recommendedLevel",
    type = "Int",
    des = "\230\142\168\232\141\144\231\160\148\229\143\145\228\184\173\229\191\131\231\173\137\231\186\167|\230\142\168\232\141\144\231\160\148\229\143\145\228\184\173\229\191\131\231\173\137\231\186\167\239\188\136\229\137\141\231\171\175\231\148\168\239\188\137",
    arg0 = "1"
  }
})
