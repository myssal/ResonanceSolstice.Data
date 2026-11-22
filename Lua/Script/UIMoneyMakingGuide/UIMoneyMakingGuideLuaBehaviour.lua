local View = require("UIMoneyMakingGuide/UIMoneyMakingGuideView")
local DataModel = require("UIMoneyMakingGuide/UIMoneyMakingGuideDataModel")
local ViewFunction = require("UIMoneyMakingGuide/UIMoneyMakingGuideViewFunction")
local Controller = require("UIMoneyMakingGuide/UIMoneyMakingGuideController")
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
