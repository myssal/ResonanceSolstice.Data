local View = require("UIInvestmentRankList/UIInvestmentRankListView")
local DataModel = require("UIInvestmentRankList/UIInvestmentRankListDataModel")
local ViewFunction = require("UIInvestmentRankList/UIInvestmentRankListViewFunction")
local Controller = require("UIInvestmentRankList/UIInvestmentRankListController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local info = Json.decode(initParams)
    DataModel.StationId = info.stationId
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
