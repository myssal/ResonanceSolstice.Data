local View = require("UIEngineCoreReward/UIEngineCoreRewardView")
local DataModel = require("UIEngineCoreReward/UIEngineCoreRewardDataModel")
local ViewFunction = require("UIEngineCoreReward/UIEngineCoreRewardViewFunction")
local Controller = require("UIEngineCoreReward/UIEngineCoreRewardController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams then
      local data = Json.decode(initParams)
      if data then
        DataModel.isOpenedByActivityPanel = data.isOpenedByActivityPanel
      end
    end
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
