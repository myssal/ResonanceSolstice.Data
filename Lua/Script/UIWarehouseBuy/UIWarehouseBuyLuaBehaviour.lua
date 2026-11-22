local View = require("UIWarehouseBuy/UIWarehouseBuyView")
local DataModel = require("UIWarehouseBuy/UIWarehouseBuyDataModel")
local Controller = require("UIWarehouseBuy/UIWarehouseBuyController")
local ViewFunction = require("UIWarehouseBuy/UIWarehouseBuyViewFunction")
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
