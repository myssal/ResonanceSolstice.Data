local View = require("UIActivityBattleBossNew/UIActivityBattleBossNewView")
local DataModel = require("UIActivityBattleBossNew/UIActivityBattleBossNewDataModel")
local Controller = require("UIActivityBattleBossNew/UIActivityBattleBossNewController")
local ViewFunction = require("UIActivityBattleBossNew/UIActivityBattleBossNewViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel:Init(initParams)
    Controller:Init()
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
  end,
  update = function()
    DataModel.remainTime = DataModel.remainTime - 0.02
    if DataModel.remainTime <= 0 then
      DataModel.remainTime = 1
      Controller:RefreshAbyssTime()
    end
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
