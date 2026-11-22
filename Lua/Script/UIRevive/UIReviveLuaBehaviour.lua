local View = require("UIRevive/UIReviveView")
local DataModel = require("UIRevive/UIReviveDataModel")
local ViewFunction = require("UIRevive/UIReviveViewFunction")
local Controller = require("UIRevive/UIReviveController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams then
      local openData = Json.decode(initParams)
      Controller:Init(openData)
    end
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
