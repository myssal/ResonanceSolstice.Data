local View = require("UIWeeklyRewards/UIWeeklyRewardsView")
local DataModel = require("UIWeeklyRewards/UIWeeklyRewardsDataModel")
local ViewFunction = require("UIWeeklyRewards/UIWeeklyRewardsViewFunction")
local Controller = require("UIWeeklyRewards/UIWeeklyRewardController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.Init()
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
