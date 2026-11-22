local View = require("UIMistSequenceMission/UIMistSequenceMissionView")
local DataModel = require("UIMistSequenceMission/UIMistSequenceMissionDataModel")
local Controller = require("UIMistSequenceMission/UIMistSequenceMissionController")
local ViewFunction = {
  MistSequenceMission_NewScrollGrid_Mission_SetGrid = function(element, elementIndex)
    Controller:SetQuestElement(element, elementIndex)
  end,
  MistSequenceMission_NewScrollGrid_Mission_Group_Item_Btn_Completed_Click = function(btn, str)
    Controller:ClickComplete(btn, str)
  end,
  MistSequenceMission_NewScrollGrid_Mission_Group_Item_ScrollGrid_Rewards_SetGrid = function(element, elementIndex)
    Controller:SetRewardElement(element, elementIndex)
  end,
  MistSequenceMission_NewScrollGrid_Mission_Group_Item_ScrollGrid_Rewards_Group_Item_Group_CommonItem_Btn_Item_Click = function(btn, str)
    Controller:ClickRewardItem(btn, str)
  end,
  MistSequenceMission_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller:Return()
  end,
  MistSequenceMission_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    Controller:Home()
  end,
  MistSequenceMission_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  MistSequenceMission_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end
}
return ViewFunction
