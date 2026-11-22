local View = require("UIAnniversaryMission/UIAnniversaryMissionView")
local DataModel = require("UIAnniversaryMission/UIAnniversaryMissionDataModel")
local ViewFunction = require("UIAnniversaryMission/UIAnniversaryMissionViewFunction")
local Controller = require("UIAnniversaryMission/UIAnniversaryMissionController")
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
