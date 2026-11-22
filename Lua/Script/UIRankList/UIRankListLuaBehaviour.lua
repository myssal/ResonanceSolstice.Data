local View = require("UIRankList/UIRankListView")
local DataModel = require("UIRankList/UIRankListDataModel")
local Controller = require("UIRankList/UIRankListController")
local ViewFunction = require("UIRankList/UIRankListViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local info = Json.decode(initParams)
    DataModel.StationId = info.stationId
    DataModel.RankList = info.rankList
    DataModel.QuickClickTime = DataModel.QuickClickLimit
    Controller:Init()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    DataModel.QuickClickTime = DataModel.QuickClickTime + 1
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
