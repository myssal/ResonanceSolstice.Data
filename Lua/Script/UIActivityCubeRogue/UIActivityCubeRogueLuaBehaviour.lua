local Timer = require("Common/Timer")
local View = require("UIActivityCubeRogue/UIActivityCubeRogueView")
local DataModel = require("UIActivityCubeRogue/UIActivityCubeRogueDataModel")
local Controller = require("UIActivityCubeRogue/UIActivityCubeRogueController")
local ViewFunction = require("UIActivityCubeRogue/UIActivityCubeRogueViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Controller:Init(initParams)
    View.timer = Timer.New(1, function()
      if DataModel.weeklyRewardTime and DataModel.weeklyRewardTime > 0 then
        Controller:RefreshWeeklyRewardsTime()
        DataModel.weeklyRewardTime = DataModel.weeklyRewardTime - 1
      end
      if DataModel.commonRewardTime and 0 < DataModel.commonRewardTime then
        Controller:RefreshCommonRewardsTime()
        DataModel.commonRewardTime = DataModel.commonRewardTime - 1
      end
    end)
    View.timer:Start()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if View.timer then
      View.timer:Update()
    end
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
