local View = require("UIHomeTradeUpgrade/UIHomeTradeUpgradeView")
local DataModel = require("UIHomeTradeUpgrade/UIHomeTradeUpgradeDataModel")
local ViewFunction = require("UIHomeTradeUpgrade/UIHomeTradeUpgradeViewFunction")
local Controller = require("UIHomeTradeUpgrade/UIHomeTradeUpdateController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Controller.Init()
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
    Controller.Release()
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
