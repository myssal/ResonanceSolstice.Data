local View = require("UIGamingShop/UIGamingShopView")
local DataModel = require("UIGamingShop/UIGamingShopDataModel")
local ViewFunction = require("UIGamingShop/UIGamingShopViewFunction")
local Controller = require("UIGamingShop/UIGamingShopController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams then
      local data = Json.decode(initParams)
      DataModel.isTriggerClose = data.triggerWhenClose
    end
    Net:SendProto("cube.open_ui", function(json)
      Controller:Init(json.shops)
    end)
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
