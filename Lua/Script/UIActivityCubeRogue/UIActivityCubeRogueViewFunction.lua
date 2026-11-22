local View = require("UIActivityCubeRogue/UIActivityCubeRogueView")
local DataModel = require("UIActivityCubeRogue/UIActivityCubeRogueDataModel")
local Controller = require("UIActivityCubeRogue/UIActivityCubeRogueController")
local ViewFunction = {
  ActivityCubeRogue_Group_Join_Group_Enter_Btn__Click = function(btn, str)
    Net:SendProto("cube.info", function(json)
      PlayerData.TempCache.CubeRogueData = json.cube
      UIManager:Open("UI/CubeRogue/OverView/CubeRogueOverView", Json.encode({
        activityId = DataModel.activityId
      }))
    end)
  end,
  ActivityCubeRogue_Group_Preview_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:RewardSetElemnt(element, elementIndex)
  end,
  ActivityCubeRogue_Group_Preview_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:RewardClickElemnt(str)
  end,
  ActivityCubeRogue_Group_NotJoin_Group_Cannot_Btn__Click = function(btn, str)
  end,
  ActivityCubeRogue_Group_NotJoin_Group_Can_Btn__Click = function(btn, str)
    Controller:AddActivity()
  end,
  ActivityCubeRogue_Group_Join_Group_WeeklyRewards_Btn__Click = function(btn, str)
    UIManager:Open("UI/CubeRogue/WeeklyRewards/WeeklyRewards", nil, function()
      Controller:RefreshWeeklyRewards()
    end)
  end,
  ActivityCubeRogue_Group_Join_Group_CommonRewards_Btn__Click = function(btn, str)
    UIManager:Open("UI/CubeRogue/CommonRewards/CommonRewards", nil, function()
      Controller:RefreshCommonRewards()
    end)
  end
}
return ViewFunction
