RegProperty("CubeFactory", {
  {
    mod = "",
    name = "name",
    type = "String",
    des = "\229\144\141\231\167\176",
    arg0 = ""
  },
  {
    name = "text",
    type = "TextT",
    des = "\230\150\185\229\157\151\229\177\158\230\128\167\230\150\135\230\156\172",
    arg0 = ""
  },
  {
    name = "cubeLevel",
    type = "Int",
    des = "\230\150\185\229\157\151\231\173\137\231\186\167",
    arg0 = "1"
  },
  {
    name = "buffType",
    type = "Enum",
    des = "Buff\231\177\187\229\158\139",
    arg0 = "Buff#Debuff",
    arg1 = "Debuff"
  },
  {
    name = "imagePath",
    type = "Png",
    des = "\230\150\185\229\157\151\229\155\190\230\160\135\232\183\175\229\190\132",
    arg0 = "",
    arg1 = "130|130",
    pyIgnore = true
  },
  {
    name = "cellList",
    type = "Array",
    des = "\230\160\188\229\173\144\229\157\144\230\160\135\229\136\151\232\161\168",
    detail = "x#y"
  },
  {
    name = "x",
    type = "Int",
    des = "\229\141\149\229\133\131\230\160\188x\229\157\144\230\160\135",
    arg0 = "0"
  },
  {
    name = "y",
    type = "Int",
    des = "\229\141\149\229\133\131\230\160\188y\229\157\144\230\160\135",
    arg0 = "0"
  },
  {name = "end"},
  {
    name = "nextCube",
    type = "Factory",
    des = "\228\184\139\228\184\128\231\186\167\230\150\185\229\157\151",
    arg0 = "CubeFactory"
  },
  {
    name = "cubeBuff",
    type = "Factory",
    des = "\230\150\185\229\157\151Buff",
    arg0 = "SkillFactory"
  },
  {
    name = "normalList",
    type = "Array",
    des = "\233\128\154\231\148\168\229\141\135\231\186\167\230\157\144\230\150\153",
    arg0 = "id#num"
  },
  {
    name = "id",
    type = "Factory",
    des = "\230\182\136\232\128\151\230\157\144\230\150\153",
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
    name = "specialList",
    type = "Array",
    des = "\231\137\185\230\174\138\229\141\135\231\186\167\230\157\144\230\150\153",
    arg0 = "id#num"
  },
  {
    name = "id",
    type = "Factory",
    des = "\230\182\136\232\128\151\230\157\144\230\150\153",
    arg0 = "CubeFactory"
  },
  {
    name = "num",
    type = "Int",
    des = "\230\149\176\233\135\143",
    arg0 = "0"
  },
  {name = "end"},
  {
    name = "disassembleList",
    type = "Array",
    des = "\230\139\134\232\167\163\230\157\144\230\150\153",
    arg0 = "id#num"
  },
  {
    name = "id",
    type = "Factory",
    des = "\232\142\183\229\190\151\230\157\144\230\150\153",
    arg0 = "ItemFactory#CubeFactory"
  },
  {
    name = "num",
    type = "Int",
    des = "\230\149\176\233\135\143",
    arg0 = "0"
  },
  {name = "end"}
})
