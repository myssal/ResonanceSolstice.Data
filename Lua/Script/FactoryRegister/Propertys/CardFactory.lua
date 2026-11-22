RegProperty("CardFactory", {
  {
    name = "ExCondList",
    type = "Array",
    des = "\229\143\175\233\128\137AI\230\157\161\228\187\182",
    detail = "des#condId"
  },
  {
    name = "des",
    type = "Factory",
    des = "\230\157\161\228\187\182\230\143\143\232\191\176",
    arg0 = "TextFactory"
  },
  {
    name = "condId",
    type = "Factory",
    des = "AI\230\157\161\228\187\182",
    arg0 = "CardAIConditionFactory"
  },
  {
    name = "isNumCond",
    type = "Bool",
    des = "\230\152\175\229\144\166\228\184\186\230\149\176\229\128\188\230\157\161\228\187\182",
    arg0 = "true"
  },
  {
    name = "typeEnum",
    type = "Enum",
    des = "\230\149\176\229\128\188\231\177\187\229\158\139||addProfit:\229\155\186\229\174\154\229\128\188,percent:\231\153\190\229\136\134\230\175\148",
    arg0 = "number#percent",
    arg1 = ","
  },
  {
    name = "minNum",
    type = "Int",
    des = "\230\156\128\229\176\143\229\128\188",
    arg0 = 0
  },
  {
    name = "numDuration",
    type = "Int",
    des = "\229\140\186\233\151\180\229\128\188",
    arg0 = 1
  },
  {
    name = "interValNum",
    type = "Int",
    des = "\229\140\186\233\151\180\230\149\176\233\135\143",
    arg0 = 1
  },
  {name = "end"},
  {
    name = "ExActList",
    type = "Array",
    des = "\229\143\175\233\128\137AI\232\161\140\228\184\186",
    detail = "des#condId"
  },
  {
    name = "des",
    type = "Factory",
    des = "\232\161\140\228\184\186\230\143\143\232\191\176",
    arg0 = "TextFactory"
  },
  {
    name = "condId",
    type = "Factory",
    des = "AI\232\161\140\228\184\186",
    arg0 = "CardAIActionFactory"
  },
  {
    name = "isNumCond",
    type = "Bool",
    des = "\230\152\175\229\144\166\228\184\186\230\149\176\229\128\188\232\161\140\228\184\186",
    arg0 = "false"
  },
  {
    name = "typeEnum",
    type = "Enum",
    des = "\230\149\176\229\128\188\231\177\187\229\158\139||addProfit:\229\155\186\229\174\154\229\128\188,percent:\231\153\190\229\136\134\230\175\148",
    arg0 = "number#percent",
    arg1 = "number"
  },
  {
    name = "minNum",
    type = "Int",
    des = "\230\156\128\229\176\143\229\128\188",
    arg0 = 0
  },
  {
    name = "numDuration",
    type = "Int",
    des = "\229\140\186\233\151\180\229\128\188",
    arg0 = 1
  },
  {
    name = "interValNum",
    type = "Int",
    des = "\229\140\186\233\151\180\230\149\176\233\135\143",
    arg0 = 1
  },
  {name = "end"},
  {
    name = "linkCardId",
    type = "Array",
    des = "\229\133\179\232\129\148\229\141\161\231\137\140id",
    detail = "Id"
  },
  {
    name = "Id",
    type = "Factory",
    des = "\229\141\161\231\137\140id",
    arg0 = "CardFactory"
  },
  {name = "end"}
})
