local View = require("UIExtendTips/UIExtendTipsView")
local DataModel = require("UIExtendTips/UIExtendTipsDataModel")
local Controller = require("UIExtendTips/UIExtendTipsController")
local ViewFunction = require("UIExtendTips/UIExtendTipsViewFunction")
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
