local View = require("UIWake/UIWakeView")
local DataModel = require("UIWake/UIWakeDataModel")
local ViewFunction = require("UIWake/UIWakeViewFunction")
local Controller = require("UIWake/UIWakeController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams then
      local data = Json.decode(initParams)
      DataModel.eventId = data.eventId
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
