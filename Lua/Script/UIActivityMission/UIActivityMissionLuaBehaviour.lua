local View = require("UIActivityMission/UIActivityMissionView")
local DataModel = require("UIActivityMission/UIActivityMissionDataModel")
local Controller = require("UIActivityMission/UIActivityMissionController")
local ViewFunction = require("UIActivityMission/UIActivityMissionViewFunction")
local Luabehaviour = {
  serialize = function()
    return DataModel.initParams
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
