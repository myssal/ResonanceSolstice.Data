local View = require("UIPrisonLevel/UIPrisonLevelView")
local DataModel = require("UIPrisonLevel/UIPrisonLevelDataModel")
local Controller = require("UIPrisonLevel/UIPrisonLevelController")
local ViewFunction = {
  PrisonLevel_Group_Left_Group_Reputation_Btn_Reputation_Click = function(btn, str)
  end,
  PrisonLevel_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  PrisonLevel_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  PrisonLevel_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  PrisonLevel_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  PrisonLevel_Img_Level_ScrollGrid_Level_SetGrid = function(element, elementIndex)
    Controller:SetLevelElement(element, elementIndex)
  end,
  PrisonLevel_Img_Level_ScrollGrid_Level_Group_Item_Btn__Click = function(btn, str)
    Controller:SelectLevel(tonumber(str))
  end,
  PrisonLevel_Img_Mask_Group_Right_StaticGrid_Pic_SetGrid = function(element, elementIndex)
  end,
  PrisonLevel_Img_Mask_Group_Right_ScrollGrid_Content_SetGrid = function(element, elementIndex)
    Controller:SetRoomDeltaElement(element, elementIndex)
  end,
  PrisonLevel_Img_Reward_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:SetLevelRewardElement(element, elementIndex)
  end,
  PrisonLevel_Img_Reward_ScrollGrid_Reward_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  PrisonLevel_Group_BtnReward_Btn_Available_Click = function(btn, str)
    Controller:TryGetLevelReward()
  end,
  PrisonLevel_Group_BtnReward_Btn_Unavailable_Click = function(btn, str)
    local isGet = DataModel.LevelRewardGetData[DataModel.CurSelectLevel] ~= nil
    local isNotLevel = DataModel.Level < DataModel.CurSelectLevel
    if isNotLevel then
      CommonTips.OpenTips(GetText(80608252))
    elseif isGet then
      CommonTips.OpenTips(GetText(80608250))
    end
  end,
  PrisonLevel_Img_Mask_Group_RightExpand_ScrollGrid_Content_SetGrid = function(element, elementIndex)
    Controller:SetRoomDeltaExpandElement(element, elementIndex)
  end
}
return ViewFunction
