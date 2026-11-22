local CommonItem = require("Common/BtnItem")
local View = require("UISignBattleLevelWensheng/UISignBattleLevelWenshengView")
local Controller = require("UISignBattleLevelWensheng/UISignBattleLevelWenshengController")
local DataModel = require("UISignBattleLevelWensheng/UISignBattleLevelWenshengDataModel")
local ViewFunction = {
  SignBattleLevelWensheng_Img_Bg2_StaticGrid_Progress_SetGrid = function(element, elementIndex)
    element.Img_Off:SetActive(elementIndex > DataModel.GetCurrentIndex())
    element.Img_On:SetActive(elementIndex <= DataModel.GetCurrentIndex())
  end,
  SignBattleLevelWensheng_ScrollGrid_Map_SetGrid = function(element, elementIndex)
    Controller:SetElement(element, elementIndex)
  end,
  SignBattleLevelWensheng_ScrollGrid_Map_Group_Level_Group_Level_Group_Current_Btn_Level_Click = function(btn, str)
    Controller:OpenRightPage(tonumber(str))
  end,
  SignBattleLevelWensheng_Group_SpLevelDetails_Btn_Close_Click = function(btn, str)
    Controller:CloseChoose()
  end,
  SignBattleLevelWensheng_Group_SpLevelDetails_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local row = DataModel.dropList[elementIndex]
    element.Group_Item.Btn_Item:SetClickParam(row.id)
    element.Group_First.self:SetActive(false)
    element.Group_Allready.self:SetActive(false)
    if row.type == 1 then
      element.Group_First.self:SetActive(true)
      if row.isFinish == true then
        element.Group_Allready.self:SetActive(true)
      end
    end
    CommonItem:SetItem(element.Group_Item, row)
  end,
  SignBattleLevelWensheng_Group_SpLevelDetails_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    if str == nil then
      return
    end
    CommonTips.OpenPreRewardDetailTips(str, nil, true)
  end,
  SignBattleLevelWensheng_Group_SpLevelDetails_Btn_Fight_Click = function(btn, str)
    Controller:TryBattle()
  end,
  SignBattleLevelWensheng_Group_CommonTopLeft_Withces_Btn_Return_Click = function(btn, str)
    if DataModel.initParams.isBattleReturn then
      UIManager:Open("UI/Activity/ActivityMain", Json.encode({
        id = DataModel.activityCA.id,
        backToHome = true
      }))
    else
      UIManager:GoBack()
    end
  end,
  SignBattleLevelWensheng_Group_CommonTopLeft_Withces_Btn_Help_Click = function(btn, str)
  end
}
return ViewFunction
