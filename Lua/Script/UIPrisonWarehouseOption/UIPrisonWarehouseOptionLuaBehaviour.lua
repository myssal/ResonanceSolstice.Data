local View = require("UIPrisonWarehouseOption/UIPrisonWarehouseOptionView")
local DataModel = require("UIPrisonWarehouseOption/UIPrisonWarehouseOptionDataModel")
local ViewFunction = require("UIPrisonWarehouseOption/UIPrisonWarehouseOptionViewFunction")
local Controller = require("UIPrisonWarehouseOption/UIPrisonWarehouseOptionController")
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
