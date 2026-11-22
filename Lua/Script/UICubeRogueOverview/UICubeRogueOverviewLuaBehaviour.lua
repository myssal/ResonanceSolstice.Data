local Timer = require("Common/Timer")
local View = require("UICubeRogueOverview/UICubeRogueOverviewView")
local DataModel = require("UICubeRogueOverview/UICubeRogueOverviewDataModel")
local Controller = require("UICubeRogueOverview/UICubeRogueOverviewController")
local ViewFunction = require("UICubeRogueOverview/UICubeRogueOverviewViewFunction")
local params
local Luabehaviour = {
  serialize = function()
    return params
  end,
  deserialize = function(initParams)
    params = initParams
    DataModel.Init(initParams)
    Controller:Init()
    View.timer = Timer.New(1, function()
      if DataModel.diffTime and DataModel.diffTime > 0 then
        Controller:RefreshCommonLevelTime()
        DataModel.diffTime = DataModel.diffTime - 1
      end
      if DataModel.weeklyRewardTime and 0 < DataModel.weeklyRewardTime then
        Controller:RefreshWeeklyRewardsTime()
        DataModel.weeklyRewardTime = DataModel.weeklyRewardTime - 1
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
