local View = require("UIIslandTask/UIIslandTaskView")
local DataModel = require("UIIslandTask/UIIslandTaskDataModel")
local Controller = require("UIIslandTask/UIIslandTaskController")
local ViewFunction = require("UIIslandTask/UIIslandTaskViewFunction")
local Luabehaviour = {
  serialize = function()
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
