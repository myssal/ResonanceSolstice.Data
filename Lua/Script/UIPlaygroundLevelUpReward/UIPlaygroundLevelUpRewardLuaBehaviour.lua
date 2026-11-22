local View = require("UIPlaygroundLevelUpReward/UIPlaygroundLevelUpRewardView")
local DataModel = require("UIPlaygroundLevelUpReward/UIPlaygroundLevelUpRewardDataModel")
local Controller = require("UIPlaygroundLevelUpReward/UIPlaygroundLevelUpRewardController")
local ViewFunction = require("UIPlaygroundLevelUpReward/UIPlaygroundLevelUpRewardViewFunction")
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
