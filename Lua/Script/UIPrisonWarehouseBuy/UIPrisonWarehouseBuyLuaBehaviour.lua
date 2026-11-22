local View = require("UIPrisonWarehouseBuy/UIPrisonWarehouseBuyView")
local DataModel = require("UIPrisonWarehouseBuy/UIPrisonWarehouseBuyDataModel")
local ViewFunction = require("UIPrisonWarehouseBuy/UIPrisonWarehouseBuyViewFunction")
local Controller = require("UIPrisonWarehouseBuy/UIPrisonWarehouseBuyController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.initParams = Json.decode(initParams)
    DataModel.BuyType = DataModel.initParams.buyType
    DataModel.GoldMaxSpace = DataModel.initParams.goldMaxSpace
    DataModel.DiamondMaxSpace = DataModel.initParams.diamondMaxSpace
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
