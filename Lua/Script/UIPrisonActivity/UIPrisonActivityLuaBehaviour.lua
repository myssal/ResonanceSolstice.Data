local View = require("UIPrisonActivity/UIPrisonActivityView")
local DataModel = require("UIPrisonActivity/UIPrisonActivityDataModel")
local ViewFunction = require("UIPrisonActivity/UIPrisonActivityViewFunction")
local Controller = require("UIPrisonActivity/UIPrisonActivityController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Controller:Init(initParams)
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
