local View = require("UITransportLevelTip/UITransportLevelTipView")
local DataModel = require("UITransportLevelTip/UITransportLevelTipDataModel")
local ViewFunction = require("UITransportLevelTip/UITransportLevelTipViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.InitData()
    DataModel.RefreshOnShow()
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
