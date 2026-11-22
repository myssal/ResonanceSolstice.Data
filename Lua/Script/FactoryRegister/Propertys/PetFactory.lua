RegProperty("PetFactory", {
  {
    name = "petName",
    type = "StringT",
    des = "\229\144\141\229\173\151",
    arg0 = ""
  },
  {
    name = "petIconPath",
    type = "Png",
    des = "\229\155\190\230\160\135",
    arg0 = "",
    arg1 = "100|100",
    pyIgnore = true
  },
  {
    name = "petVarity",
    type = "Factory",
    des = "\231\137\169\231\167\141",
    arg0 = "TagFactory",
    arg1 = "\229\174\160\231\137\169\231\137\169\231\167\141"
  },
  {
    name = "petSpecies",
    type = "Factory",
    des = "\229\147\129\231\167\141",
    arg0 = "TagFactory",
    arg1 = "\229\174\160\231\137\169\229\147\129\231\167\141"
  },
  {
    name = "petFoodInt",
    type = "Int",
    des = "\229\143\163\231\178\174\230\182\136\232\128\151",
    arg0 = "0"
  },
  {
    name = "wasteoutput",
    type = "Int",
    des = "\229\158\131\229\156\190\228\186\167\229\135\186",
    arg0 = "0"
  },
  {
    name = "petBaseScore",
    type = "Int",
    des = "\229\159\186\231\161\128\232\175\132\229\136\134",
    arg0 = "0"
  },
  {
    name = "petState",
    type = "Int",
    des = "\231\138\182\230\128\129",
    arg0 = "8"
  },
  {
    name = "ties",
    type = "Array",
    des = "\229\174\160\231\137\169\231\190\129\231\187\138",
    detail = "tiesId"
  },
  {
    name = "tiesId",
    type = "Factory",
    des = "\229\174\160\231\137\169\231\190\129\231\187\138",
    arg0 = "TagFactory",
    arg1 = "\229\174\160\231\137\169\231\190\129\231\187\138"
  },
  {name = "end"},
  {
    name = "unlockedItem",
    type = "Array",
    des = "\232\167\163\233\148\129\233\129\147\229\133\183",
    detail = "itemId#itemNum"
  },
  {
    name = "itemId",
    type = "Factory",
    des = "\232\167\163\233\148\129\233\129\147\229\133\183",
    arg0 = "ItemFactory#SourceMaterialFactory"
  },
  {
    name = "itemNum",
    type = "Int",
    des = "\233\129\147\229\133\183\230\149\176\233\135\143",
    arg0 = "1"
  },
  {name = "end"},
  {
    name = "homeCharacter",
    type = "Factory",
    des = "\229\175\185\229\186\148\229\174\182\229\155\173\232\167\146\232\137\178",
    arg0 = "HomeCharacterFactory"
  },
  {
    name = "des",
    type = "TextT",
    des = "\230\143\143\232\191\176",
    arg0 = "",
    pyIgnore = true
  }
})
