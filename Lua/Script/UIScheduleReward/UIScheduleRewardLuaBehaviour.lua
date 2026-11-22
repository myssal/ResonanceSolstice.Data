local View = require("UIScheduleReward/UIScheduleRewardView")
local DataModel = require("UIScheduleReward/UIScheduleRewardDataModel")
local Controller = require("UIScheduleReward/UIScheduleRewardController")
local ViewFunction = require("UIScheduleReward/UIScheduleRewardViewFunction")
local Luabehaviour = {
  serialize = function()
    return Json.encode(DataModel.data)
  end,
  deserialize = function(initParams)
    local data
    if initParams then
      data = Json.decode(initParams)
    end
    DataModel.InitData(data)
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
