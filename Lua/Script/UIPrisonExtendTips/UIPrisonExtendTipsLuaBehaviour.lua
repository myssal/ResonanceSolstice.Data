local View = require("UIPrisonExtendTips/UIPrisonExtendTipsView")
local DataModel = require("UIPrisonExtendTips/UIPrisonExtendTipsDataModel")
local ViewFunction = require("UIPrisonExtendTips/UIPrisonExtendTipsViewFunction")
local Controller = require("UIPrisonExtendTips/UIPrisonExtendTipsController")
local Luabehaviour = {
  serialize = function()
    return Json.encode(DataModel.initParams)
  end,
  deserialize = function(initParams)
    DataModel.initParams = Json.decode(initParams)
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
