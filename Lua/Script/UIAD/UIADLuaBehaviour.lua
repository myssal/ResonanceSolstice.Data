local View = require("UIAD/UIADView")
local DataModel = require("UIAD/UIADDataModel")
local Controller = require("UIAD/UIADController")
local ViewFunction = require("UIAD/UIADViewFunction")
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
    DataModel.curInfo = nil
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
