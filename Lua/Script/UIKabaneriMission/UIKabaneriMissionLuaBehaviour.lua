local View = require("UIKabaneriMission/UIKabaneriMissionView")
local DataModel = require("UIKabaneriMission/UIKabaneriMissionDataModel")
local Controller = require("UIKabaneriMission/UIKabaneriMissionController")
local ViewFunction = require("UIKabaneriMission/UIKabaneriMissionViewFunction")
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
