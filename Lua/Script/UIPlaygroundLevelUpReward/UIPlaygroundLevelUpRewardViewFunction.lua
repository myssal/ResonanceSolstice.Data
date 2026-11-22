local View = require("UIPlaygroundLevelUpReward/UIPlaygroundLevelUpRewardView")
local DataModel = require("UIPlaygroundLevelUpReward/UIPlaygroundLevelUpRewardDataModel")
local Controller = require("UIPlaygroundLevelUpReward/UIPlaygroundLevelUpRewardController")
local ViewFunction = {
  PlaygroundLevelUpReward_StaticGrid_List_SetGrid = function(element, elementIndex)
    Controller:RefreshElement(element, elementIndex)
  end,
  PlaygroundLevelUpReward_Btn_OK_Click = function(btn, str)
    Controller:Close()
  end
}
return ViewFunction
