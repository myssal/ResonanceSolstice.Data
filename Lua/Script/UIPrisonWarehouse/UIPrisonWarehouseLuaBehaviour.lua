local View = require("UIPrisonWarehouse/UIPrisonWarehouseView")
local DataModel = require("UIPrisonWarehouse/UIPrisonWarehouseDataModel")
local ViewFunction = require("UIPrisonWarehouse/UIPrisonWarehouseViewFunction")
local Controller = require("UIPrisonWarehouse/UIPrisonWarehouseController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Controller:InitView()
  end,
  awake = function()
  end,
  start = function()
    DataModel.CurExchangeType = DataModel.ExchangeType.MaterialAndProduct
  end,
  update = function()
  end,
  ondestroy = function()
  end,
  enable = function()
    View.self:PlayAnim("01", function()
      Controller:PlayExchangeAnim()
    end)
  end,
  disenable = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
