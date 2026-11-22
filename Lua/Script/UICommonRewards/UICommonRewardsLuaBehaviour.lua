local View = require("UICommonRewards/UICommonRewardsView")
local DataModel = require("UICommonRewards/UICommonRewardsDataModel")
local ViewFunction = require("UICommonRewards/UICommonRewardsViewFunction")
local Controller = require("UICommonRewards/UICommonRewardsController")
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
