local View = require("UIActivityTrainBattleMission/UIActivityTrainBattleMissionView")
local DataModel = require("UIActivityTrainBattleMission/UIActivityTrainBattleMissionDataModel")
local Controller = require("UIActivityTrainBattleMission/UIActivityTrainBattleMissionController")
local ViewFunction = {
  ActivityTrainBattleMission_NewScrollGrid_Mission_SetGrid = function(element, elementIndex)
    Controller:SetQuestElement(element, elementIndex)
  end,
  ActivityTrainBattleMission_NewScrollGrid_Mission_Group_Item_Btn_Completed_Click = function(btn, str)
    Controller:ClickComplete(btn, str)
  end,
  ActivityTrainBattleMission_NewScrollGrid_Mission_Group_Item_ScrollGrid_Rewards_SetGrid = function(element, elementIndex)
    Controller:SetRewardElement(element, elementIndex)
  end,
  ActivityTrainBattleMission_NewScrollGrid_Mission_Group_Item_ScrollGrid_Rewards_Group_Item_Group_CommonItem_Btn_Item_Click = function(btn, str)
    Controller:ClickRewardItem(btn, str)
  end,
  ActivityTrainBattleMission_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller:Return()
  end,
  ActivityTrainBattleMission_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    Controller:Home()
  end,
  ActivityTrainBattleMission_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  ActivityTrainBattleMission_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  ActivityTrainBattleMission_Group_Title_Group_Item11_Btn_Completed_Click = function(btn, str)
  end,
  ActivityTrainBattleMission_Group_Title_Group_Item11_ScrollGrid_Rewards_SetGrid = function(element, elementIndex)
  end,
  ActivityTrainBattleMission_Group_Title_Group_Item11_ScrollGrid_Rewards_Group_Item_Group_CommonItem_Btn_Item_Click = function(btn, str)
  end,
  ActivityTrainBattleMission_NewScrollGrid_Mission_Group_Item_Group_finish_Btn__Click = function(btn, str)
    Controller:ClickComplete(btn, str)
  end
}
return ViewFunction
