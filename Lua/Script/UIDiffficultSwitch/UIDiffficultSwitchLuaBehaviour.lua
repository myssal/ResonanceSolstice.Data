local View = require("UIDiffficultSwitch/UIDiffficultSwitchView")
local DataModel = require("UIDiffficultSwitch/UIDiffficultSwitchDataModel")
local ViewFunction = require("UIDiffficultSwitch/UIDiffficultSwitchViewFunction")
local Controller = require("UIDiffficultSwitch/UIDiffficultSwitchController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local data = Json.decode(initParams)
      DataModel.levelId = data.levelId
      DataModel.difficulty = data.difficulty
      Controller:Init()
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    Controller:UpdateSliderView()
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
