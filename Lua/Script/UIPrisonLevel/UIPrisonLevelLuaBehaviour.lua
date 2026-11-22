local View = require("UIPrisonLevel/UIPrisonLevelView")
local DataModel = require("UIPrisonLevel/UIPrisonLevelDataModel")
local ViewFunction = require("UIPrisonLevel/UIPrisonLevelViewFunction")
local Controller = require("UIPrisonLevel/UIPrisonLevelController")
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
