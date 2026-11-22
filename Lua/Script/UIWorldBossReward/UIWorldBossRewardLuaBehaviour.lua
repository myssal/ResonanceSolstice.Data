local View = require("UIWorldBossReward/UIWorldBossRewardView")
local DataModel = require("UIWorldBossReward/UIWorldBossRewardDataModel")
local ViewFunction = require("UIWorldBossReward/UIWorldBossRewardViewFunction")
local Controller = require("UIWorldBossReward/UIWorldBossRewardController")
local Luabehaviour = {
  serialize = function()
    return Json.encode({
      activityId = DataModel.activityId
    })
  end,
  deserialize = function(initParams)
    local data = Json.decode(initParams)
    DataModel.activityId = data.activityId
    DataModel.cfg = PlayerData:GetFactoryData(data.activityId)
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
