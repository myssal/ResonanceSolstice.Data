local View = require("UIWitchesRanking/UIWitchesRankingView")
local DataModel = require("UIWitchesRanking/UIWitchesRankingDataModel")
local ViewFunction = require("UIWitchesRanking/UIWitchesRankingViewFunction")
local Controller = require("UIWitchesRanking/UIWitchesRankingController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.SetJsonData(initParams)
    DataModel.Init()
    Controller:Init()
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
  end,
  update = function()
    DataModel.QuickClickTime = DataModel.QuickClickTime + 1
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
