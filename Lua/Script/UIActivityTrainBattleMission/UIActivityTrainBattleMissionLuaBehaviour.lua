local View = require("UIActivityTrainBattleMission/UIActivityTrainBattleMissionView")
local DataModel = require("UIActivityTrainBattleMission/UIActivityTrainBattleMissionDataModel")
local ViewFunction = require("UIActivityTrainBattleMission/UIActivityTrainBattleMissionViewFunction")
local Controller = require("UIActivityTrainBattleMission/UIActivityTrainBattleMissionController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.initParams = initParams
    DataModel.decodeParams = Json.decode(initParams)
    Controller:Init()
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
  end,
  update = function()
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
