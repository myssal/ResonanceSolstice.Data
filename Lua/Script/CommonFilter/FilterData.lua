local DataModel = {}
DataModel.View = {}
DataModel.SortData = {}
DataModel.FilterData = {}
DataModel.isInit = true
DataModel.FromView = EnumDefine.CommonFilterType.SquadView
DataModel.tempData = {}
DataModel.temp_Filter_Sort_Data = {}
DataModel.callback = nil
DataModel.EnumSort = {
  up_off = 1,
  up_on = 2,
  down_off = 3,
  down_on = 4
}
DataModel.EnumFilter = {open = 1, close = 2}
DataModel.RoleSort = {
  [1] = EnumDefine.SortType.level,
  [2] = EnumDefine.SortType.rarity,
  [3] = EnumDefine.SortType.time,
  [4] = EnumDefine.SortType.filter
}
DataModel.RoleFilter = {
  [1] = {
    name = "\232\129\140\228\184\154",
    isImg = false,
    filters = {
      [1] = "\229\133\168\233\131\168",
      [2] = "\230\150\165\229\128\153",
      [3] = "\231\155\190\229\141\171",
      [4] = "\232\190\133\229\138\169",
      [5] = "\229\188\186\229\135\187",
      [6] = "\230\136\152\229\140\187",
      [7] = "\229\136\169\229\136\131",
      [8] = "\229\147\168\230\136\146",
      [9] = "\229\133\136\233\148\139",
      [10] = "\230\143\180\229\135\187"
    }
  },
  [2] = {
    name = "\233\152\181\232\144\165",
    isImg = false,
    filters = {
      [1] = "\229\133\168\233\131\168",
      [2] = "\233\152\191\229\166\174\229\161\148\229\133\168\231\144\131\232\131\189\230\186\144",
      [3] = "\229\156\176\231\144\131\232\129\148\229\144\136\229\174\170\231\171\160",
      [4] = "\233\187\145\230\156\136\233\147\190\230\157\161",
      [5] = "\230\183\183\229\147\141\232\128\133",
      [6] = "\231\167\145\228\188\166\229\183\180\229\149\134\228\188\154",
      [7] = "\230\155\188\230\157\156\230\150\175\229\184\157\229\155\189",
      [8] = "\233\147\129\231\155\159",
      [9] = "\229\173\166\228\188\154",
      [10] = "\229\155\173\228\184\129"
    }
  },
  [3] = {
    name = "\231\168\128\230\156\137\229\186\166",
    isImg = true,
    filters = {
      [1] = "\229\133\168\233\131\168"
    }
  }
}
return DataModel
