local View = require("UICubeRogueMission/UICubeRogueMissionView")
local DataModel = require("UICubeRogueMission/UICubeRogueMissionDataModel")
local Controller = require("UICubeRogueMission/UICubeRogueMissionController")
local ViewFunction = require("UICubeRogueMission/UICubeRogueMissionViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
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
