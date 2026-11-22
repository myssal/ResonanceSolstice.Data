local View = require("UIActivityBattleBoss/UIActivityBattleBossView")
local DataModel = require("UIActivityBattleBoss/UIActivityBattleBossDataModel")
local Controller = require("UIActivityBattleBoss/UIActivityBattleBossController")
local ViewFunction = require("UIActivityBattleBoss/UIActivityBattleBossViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Controller:Init(initParams)
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
