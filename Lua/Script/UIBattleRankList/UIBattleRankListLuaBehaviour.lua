local View = require("UIBattleRankList/UIBattleRankListView")
local DataModel = require("UIBattleRankList/UIBattleRankListDataModel")
local ViewFunction = require("UIBattleRankList/UIBattleRankListViewFunction")
local Luabehaviour = {
  serialize = function()
    local data = {}
    data.lastIdx = DataModel.levelAreaIndex
    data.rankList = DataModel.serverRankList
    data.selfRank = DataModel.serverSelfRank
    data.stationId = DataModel.stationId
    return Json.encode(data)
  end,
  deserialize = function(initParams)
    DataModel.SetJsonData(initParams)
    DataModel.SortServerData()
    DataModel.InitData()
    DataModel.RefreshOnShow()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
    if DataModel.giveLiveC then
      View.self:StopC(DataModel.giveLiveC)
      DataModel.giveLiveC = nil
    end
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
