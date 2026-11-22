local View = require("UIStabilityTips/UIStabilityTipsView")
local DataModel = require("UIStabilityTips/UIStabilityTipsDataModel")
local ViewFunction = require("UIStabilityTips/UIStabilityTipsViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
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
