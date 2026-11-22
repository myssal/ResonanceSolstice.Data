local View = require("UIOverview/UIOverviewView")
local DataModel = require("UIOverview/UIOverviewDataModel")
local Controller = require("UIOverview/UIOverviewController")
local ViewFunction = require("UIOverview/UIOverviewViewFunction")
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
