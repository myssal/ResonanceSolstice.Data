local View = require("UIPrisonShop/UIPrisonShopView")
local DataModel = require("UIPrisonShop/UIPrisonShopDataModel")
local ViewFunction = require("UIPrisonShop/UIPrisonShopViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.SetJsonData(initParams)
    DataModel.InitData()
    DataModel.RefreshOnShow()
    DataModel.JumpOpenExchangeTip()
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
