local CommonItem = require("Common/BtnItem")
local View = require("UIBlackLevel/UIBlackLevelView")
local DataModel = require("UIBlackLevel/UIBlackLevelDataModel")
local Controller = require("UIBlackLevel/UIBlackLevelController")
local ViewFunction = {
  BlackLevel_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller:CloseChoose()
    if DataModel.initParams.isBattleReturn then
      UIManager:Open("UI/Activity/ActivityMain", Json.encode({
        id = DataModel.activityCA.id
      }))
    else
      UIManager:GoBack()
    end
  end,
  BlackLevel_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    Controller:CloseChoose()
    UIManager:GoHome()
  end,
  BlackLevel_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  BlackLevel_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  BlackLevel_Group_SpLevelDetails_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
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
  BlackLevel_Group_SpLevelDetails_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    if str == nil then
      return
    end
    CommonTips.OpenPreRewardDetailTips(str, nil, true)
  end,
  BlackLevel_Group_SpLevelDetails_Btn_Fight_Click = function(btn, str)
    Controller:TryBattle()
  end,
  BlackLevel_Group_SpLevelDetails_Group_Ding_Btn_Energy_Click = function(btn, str)
    local function callback()
      DataModel.maxEnergy = PlayerData:GetUserInfo().max_energy or DataModel.maxEnergy
      
      View.Group_SpLevelDetails.Group_Ding.Btn_Energy.Txt_Num:SetText(DataModel.GetEnergy() .. "/" .. DataModel.maxEnergy)
    end
    
    CommonTips.OpenEnergy(callback)
  end,
  BlackLevel_Group_SpLevelDetails_Group_Ding_Btn_Energy_Btn_Add_Click = function(btn, str)
  end,
  BlackLevel_Group_SpLevelDetails_Group_Auto_Btn_Auto_Click = function(btn, str)
    Controller:OnClickBtnAuto()
  end,
  BlackLevel_ScrollView_Map_Viewport_Group_BG_StaticGrid_List_SetGrid = function(element, elementIndex)
    local row = DataModel.blackLevelList[tonumber(elementIndex)]
    element.Btn_:SetClickParam(elementIndex)
    element.Img_Icon:SetSprite(row.icon)
    element.Img_Monster:SetSprite(row.png)
    element.Group_Title.Txt_Des:SetText(row.name)
    element.Group_On:SetActive(DataModel.openIndex == tonumber(elementIndex))
  end,
  BlackLevel_ScrollView_Map_Viewport_Group_BG_StaticGrid_List_Group_Level_Btn__Click = function(btn, str)
    Controller:OpenRightPage(tonumber(str))
  end,
  BlackLevel_ScrollView_Map_Viewport_Group_BG_Group_Level_Btn__Click = function(btn, str)
  end,
  BlackLevel_ScrollView_Map_Viewport_Group_BG_Btn_Close_Click = function(btn, str)
    Controller:CloseChoose()
  end,
  BlackLevel_Group_SpLevelDetails_Group_Skip_Btn_Skip_Click = function(btn, str)
    Controller:ClickSkipWin()
  end,
  BlackLevel_Group_SpLevelDetails_Group_Skip_Btn_Fight_Click = function(btn, str)
    Controller:TryBattle()
  end
}
return ViewFunction
