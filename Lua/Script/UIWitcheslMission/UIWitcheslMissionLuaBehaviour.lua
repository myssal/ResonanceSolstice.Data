local View = require("UIWitcheslMission/UIWitcheslMissionView")
local DataModel = require("UIWitcheslMission/UIWitcheslMissionDataModel")
local ViewFunction = require("UIWitcheslMission/UIWitcheslMissionViewFunction")
local Controller = require("UIWitcheslMission/UIWitcheslMissionController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.SetJsonData(initParams)
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
