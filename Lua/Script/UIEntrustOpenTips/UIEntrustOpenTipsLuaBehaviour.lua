local View = require("UIEntrustOpenTips/UIEntrustOpenTipsView")
local DataModel = require("UIEntrustOpenTips/UIEntrustOpenTipsDataModel")
local ViewFunction = require("UIEntrustOpenTips/UIEntrustOpenTipsViewFunction")
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
