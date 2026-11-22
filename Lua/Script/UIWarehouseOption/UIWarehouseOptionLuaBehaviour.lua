local View = require("UIWarehouseOption/UIWarehouseOptionView")
local DataModel = require("UIWarehouseOption/UIWarehouseOptionDataModel")
local Controller = require("UIWarehouseOption/UIWarehouseOptionController")
local ViewFunction = require("UIWarehouseOption/UIWarehouseOptionViewFunction")
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
