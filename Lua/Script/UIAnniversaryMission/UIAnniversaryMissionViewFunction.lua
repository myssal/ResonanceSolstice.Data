local View = require("UIAnniversaryMission/UIAnniversaryMissionView")
local DataModel = require("UIAnniversaryMission/UIAnniversaryMissionDataModel")
local Controller = require("UIAnniversaryMission/UIAnniversaryMissionController")
local ViewFunction = {
  AnniversaryMission_NewScrollGrid_Mission_SetGrid = function(element, elementIndex)
    Controller:SetQuestElement(element, elementIndex)
  end,
  AnniversaryMission_NewScrollGrid_Mission_Group_Item_Btn_Completed_Click = function(btn, str)
    Controller:ClickComplete(btn, str)
  end,
  AnniversaryMission_NewScrollGrid_Mission_Group_Item_ScrollGrid_Rewards_SetGrid = function(element, elementIndex)
    Controller:SetRewardElement(element, elementIndex)
  end,
  AnniversaryMission_NewScrollGrid_Mission_Group_Item_ScrollGrid_Rewards_Group_Item_Group_CommonItem_Btn_Item_Click = function(btn, str)
    Controller:ClickRewardItem(btn, str)
  end,
  AnniversaryMission_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller:Return()
  end,
  AnniversaryMission_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    Controller:Home()
  end,
  AnniversaryMission_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  AnniversaryMission_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  AnniversaryMission_Group_Gold_Btn__Click = function(btn, str)
  end,
  AnniversaryMission_Group_Tab_Group_Tab1_Btn__Click = function(btn, str)
    Controller:ClickShowQuest(1)
  end,
  AnniversaryMission_Group_Tab_Group_Tab2_Btn__Click = function(btn, str)
    Controller:ClickShowQuest(2)
  end
}
return ViewFunction
