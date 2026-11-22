local View = require("UIRevenueOverview/UIRevenueOverviewView")
local DataModel = require("UIRevenueOverview/UIRevenueOverviewDataModel")
local ViewFunction = require("UIRevenueOverview/UIRevenueOverviewViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.SetJsonData(initParams)
    DataModel.InitData()
    DataModel.RefreshOnShow()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    DataModel.RefreshRankRedPointTime()
    DataModel.RefreshRankRedPoint()
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
