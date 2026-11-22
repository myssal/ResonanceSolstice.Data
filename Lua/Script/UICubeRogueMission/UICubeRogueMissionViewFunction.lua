local View = require("UICubeRogueMission/UICubeRogueMissionView")
local DataModel = require("UICubeRogueMission/UICubeRogueMissionDataModel")
local Controller = require("UICubeRogueMission/UICubeRogueMissionController")
local ViewFunction = {
  CubeRogueMission_NewScrollGrid_Mission_SetGrid = function(element, elementIndex)
    Controller:RefreshQuestElement(element, elementIndex)
  end,
  CubeRogueMission_NewScrollGrid_Mission_Group_Item_Btn_Completed_Click = function(btn, str)
    Controller:ClickQuestComplete(str)
  end,
  CubeRogueMission_NewScrollGrid_Mission_Group_Item_ScrollGrid_Rewards_SetGrid = function(element, elementIndex)
    Controller:RefreshRewardElement(element, elementIndex)
  end,
  CubeRogueMission_NewScrollGrid_Mission_Group_Item_ScrollGrid_Rewards_Group_Item_Group_CommonItem_Btn_Item_Click = function(btn, str)
    Controller:ClickRewardItem(str)
  end,
  CubeRogueMission_Group_Tab_Group_Tab1_Btn__Click = function(btn, str)
    Controller:ClickTab(1)
  end,
  CubeRogueMission_Group_Tab_Group_Tab2_Btn__Click = function(btn, str)
    Controller:ClickTab(2)
  end,
  CubeRogueMission_Btn_Back_Click = function(btn, str)
    Controller:Return()
  end
}
return ViewFunction
