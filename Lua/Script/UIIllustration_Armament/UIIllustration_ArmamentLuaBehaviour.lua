local View = require("UIIllustration_Armament/UIIllustration_ArmamentView")
local DataModel = require("UIIllustration_Armament/UIIllustration_ArmamentDataModel")
local ViewFunction = require("UIIllustration_Armament/UIIllustration_ArmamentViewFunction")
local Controller = require("UIIllustration_Armament/UIIllustration_ArmamentController")
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
