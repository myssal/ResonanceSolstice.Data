local View = require("UIStopTips/UIStopTipsView")
local DataModel = require("UIStopTips/UIStopTipsDataModel")
local ViewFunction = require("UIStopTips/UIStopTipsViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
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
