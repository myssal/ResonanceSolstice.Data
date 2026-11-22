local View = require("UIKabaneriSettlement/UIKabaneriSettlementView")
local DataModel = require("UIKabaneriSettlement/UIKabaneriSettlementDataModel")
local Controller = require("UIKabaneriSettlement/UIKabaneriSettlementController")
local ViewFunction = {
  KabaneriSettlement_ScrollView_Select_Viewport_Content_Group_Select_Btn_Return_Click = function(btn, str)
  end,
  KabaneriSettlement_ScrollView_Select_Viewport_Content_Group_Select_Group_Level_Group_Level_Btn_Select_Click = function(btn, str)
  end,
  KabaneriSettlement_ScrollView_Select_Viewport_Content_Group_Select_Group_Level_StaticGrid_Level_SetGrid = function(element, elementIndex)
    Controller:SetLevelGrid(element, elementIndex)
  end,
  KabaneriSettlement_ScrollView_Select_Viewport_Content_Group_Select_Group_Level_StaticGrid_Level_Group_Level_Btn_Select_Click = function(btn, str)
    Controller:ShowParamInfo(str)
    View.ScrollView_Select.Viewport.Content.Group_Select.Group_Level.StaticGrid_Level.grid.self:RefreshAllElement()
  end,
  KabaneriSettlement_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
    if MainManager.bgSceneName == "Kabaneri" then
      CommonTips.OpenLoading(nil, "", nil, function()
        CBus:ChangeScene("Main", function()
          UIManager:Open("UI/Activity/ActivityMain", Json.encode({id = 86000031}))
        end)
      end)
    end
  end,
  KabaneriSettlement_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  KabaneriSettlement_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  KabaneriSettlement_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    local data = {helpId = 80305457}
    UIManager:Open("UI/Kabaneri/Group_Help", Json.encode(data))
  end,
  KabaneriSettlement_Group_readiness_Group_FixButton_Btn_Fix_Click = function(btn, str)
    Controller:ConfirmRepair()
  end,
  KabaneriSettlement_Group_readiness_Group_OilButton_Btn_Oil_Click = function(btn, str)
    Controller:ConfirmOil()
  end,
  KabaneriSettlement_Group_readiness_Btn_Button_Click = function(btn, str)
    Controller:AutoFix()
  end,
  KabaneriSettlement_Group_readiness_Group_battery_Group_ammoNum_Btn_ammoNum_Click = function(btn, str)
  end,
  KabaneriSettlement_Btn_Build_Click = function(btn, str)
    Controller:TryOpenCarriageEditor()
  end,
  KabaneriSettlement_Group_Right_Btn_Close_Click = function(btn, str)
    Controller:RefreshAutoBtn(false)
    Controller:HideParamInfo()
    View.ScrollView_Select.Viewport.Content.Group_Select.Group_Level.StaticGrid_Level.grid.self:RefreshAllElement()
  end,
  KabaneriSettlement_Group_Right_Img_infoPath_Group_Drop_ScrollGrid_Item_SetGrid = function(element, elementIndex)
    Controller:SetLevelRewardGrid(element, elementIndex)
  end,
  KabaneriSettlement_Group_Right_Img_infoPath_Group_Drop_ScrollGrid_Item_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  KabaneriSettlement_Group_Right_Img_infoPath_Group_Fight_Btn_StartFight_Click = function(btn, str)
    Controller:TryLevelGo()
  end,
  KabaneriSettlement_Group_Right_Img_infoPath_Group_Auto_Btn_Auto_Click = function(btn, str)
    Controller:OnClickBtnAuto()
  end,
  KabaneriSettlement_Group_Right_Img_infoPath_Group_Cost_Btn_Energy_Click = function(btn, str)
    Controller:OpenEnergyBuy()
  end,
  KabaneriSettlement_Group_Right_Img_infoPath_Group_Cost_Btn_Energy_Btn_Add_Click = function(btn, str)
  end,
  KabaneriSettlement_Group_TrainOverview_Btn_All_Click = function(btn, str)
    Controller:SetTrainOverViewShow(true)
  end,
  KabaneriSettlement_Group_TrainOverview_Group_Overview_Btn_CloseOverview_Click = function(btn, str)
    Controller:SetTrainOverViewShow(false)
  end,
  KabaneriSettlement_Group_Open_Btn_Close_Click = function(btn, str)
    View.Group_Open:SetActive(false)
  end
}
return ViewFunction
