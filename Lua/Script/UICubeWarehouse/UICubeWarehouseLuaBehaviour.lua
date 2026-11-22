local View = require("UICubeWarehouse/UICubeWarehouseView")
local DataModel = require("UICubeWarehouse/UICubeWarehouseDataModel")
local ViewFunction = require("UICubeWarehouse/UICubeWarehouseViewFunction")
local Controller = require("UICubeWarehouse/UICubeWarehouseController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams then
      local data = Json.decode(initParams)
      DataModel.InitIndex = data.index
    else
      DataModel.InitIndex = 1
    end
    Controller:Init()
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
