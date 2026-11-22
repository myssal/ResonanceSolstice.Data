local View = require("UIHomeCOCShop/UIHomeCOCShopView")
local DataModel = require("UIHomeCOCShop/UIHomeCOCShopDataModel")
local Controller = require("UIHomeCOCShop/UIHomeCOCShopController")
local ViewFunction = require("UIHomeCOCShop/UIHomeCOCShopViewFunction")
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
