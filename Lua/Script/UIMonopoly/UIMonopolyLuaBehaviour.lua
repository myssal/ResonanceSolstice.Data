local View = require("UIMonopoly/UIMonopolyView")
local DataModel = require("UIMonopoly/UIMonopolyDataModel")
local ViewFunction = require("UIMonopoly/UIMonopolyViewFunction")
local Manager = require("UIMonopoly/LuaMonopolyManager")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Manager.Init()
  end,
  awake = function()
  end,
  start = function()
    DataModel.lastFps = CS.UnityEngine.Application.targetFrameRate
    CS.UnityEngine.Application.targetFrameRate = 60
  end,
  update = function()
    Manager.OnUpdate()
  end,
  perupdate = function()
  end,
  ondestroy = function()
    Manager.Release()
    CS.UnityEngine.Application.targetFrameRate = DataModel.lastFps
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
