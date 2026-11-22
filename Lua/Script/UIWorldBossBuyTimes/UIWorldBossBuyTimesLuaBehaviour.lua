local View = require("UIWorldBossBuyTimes/UIWorldBossBuyTimesView")
local DataModel = require("UIWorldBossBuyTimes/UIWorldBossBuyTimesDataModel")
local ViewFunction = require("UIWorldBossBuyTimes/UIWorldBossBuyTimesViewFunction")
local Controller = require("UIWorldBossBuyTimes/UIWorldBossBuyTimesController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local data = Json.decode(initParams)
    DataModel.InitData(data)
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
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
