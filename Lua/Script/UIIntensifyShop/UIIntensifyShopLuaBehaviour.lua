local View = require("UIIntensifyShop/UIIntensifyShopView")
local DataModel = require("UIIntensifyShop/UIIntensifyShopDataModel")
local ViewFunction = require("UIIntensifyShop/UIIntensifyShopViewFunction")
local Controller = require("UIIntensifyShop/UIIntensifyShopController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Controller.ShowPanel()
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
    Controller.Clear()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
