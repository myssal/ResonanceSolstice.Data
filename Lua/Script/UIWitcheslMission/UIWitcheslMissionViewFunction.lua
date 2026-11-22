local View = require("UIWitcheslMission/UIWitcheslMissionView")
local DataModel = require("UIWitcheslMission/UIWitcheslMissionDataModel")
local Controller = require("UIWitcheslMission/UIWitcheslMissionController")
local ViewFunction = {
  WitcheslMission_NewScrollGrid_Mission_SetGrid = function(element, elementIndex)
    Controller:SetMissionElement(element, elementIndex)
  end,
  WitcheslMission_NewScrollGrid_Mission_Group_Item_Btn_Completed_Click = function(btn, str)
    Controller:TryFinishMission(tonumber(str))
  end,
  WitcheslMission_NewScrollGrid_Mission_Group_Item_ScrollGrid_Rewards_SetGrid = function(element, elementIndex)
    Controller:SetMissionRewardElement(element, elementIndex)
  end,
  WitcheslMission_NewScrollGrid_Mission_Group_Item_ScrollGrid_Rewards_Group_Item_Group_CommonItem_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  WitcheslMission_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  WitcheslMission_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  WitcheslMission_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  WitcheslMission_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end
}
return ViewFunction
