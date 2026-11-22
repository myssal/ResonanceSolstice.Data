local View = require("UIActivityMonthlyCard/UIActivityMonthlyCardView")
local DataModel = require("UIActivityMonthlyCard/UIActivityMonthlyCardDataModel")
local Controller = require("UIActivityMonthlyCard/UIActivityMonthlyCardController")
local ViewFunction = require("UIActivityMonthlyCard/UIActivityMonthlyCardViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
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
