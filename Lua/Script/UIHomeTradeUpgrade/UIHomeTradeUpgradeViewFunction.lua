local View = require("UIHomeTradeUpgrade/UIHomeTradeUpgradeView")
local DataModel = require("UIHomeTradeUpgrade/UIHomeTradeUpgradeDataModel")
local Controller = require("UIHomeTradeUpgrade/UIHomeTradeUpdateController")
local ViewFunction = {
  HomeTradeUpgrade_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  HomeTradeUpgrade_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  HomeTradeUpgrade_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  HomeTradeUpgrade_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  HomeTradeUpgrade_Group_Trade_Group_Help_Btn_icon_Click = function(btn, str)
    UIManager:Open("UI/Common/Group_Help", Json.encode({helpId = 80307992}))
  end,
  HomeTradeUpgrade_Group_Trade_Group_TradeLv_Btn_Tips_Click = function(btn, str)
    UIManager:Open("UI/TradeLevelTip/TradeLevelTip")
  end,
  HomeTradeUpgrade_Group_Trade_Group_GoldCoin_Btn_GoldCoin_Click = function(btn, str)
  end,
  HomeTradeUpgrade_Group_Trade_Group_GoldCoin_Btn_Add_Click = function(btn, str)
  end,
  HomeTradeUpgrade_Group_Trade_Group_Energy_Btn_Add_Click = function(btn, str)
    local homeCommon = require("Common/HomeCommon")
    homeCommon.OpenMoveEnergyUseItem(function()
      Controller.RefreshActionValue()
    end)
  end,
  HomeTradeUpgrade_Group_Trade_Group_Energy_Btn_Icon_Click = function(btn, str)
  end,
  HomeTradeUpgrade_Group_Left_ScrollGrid_Left_SetGrid = function(element, elementIndex)
    Controller.RefreshGoodElementShow(element, elementIndex)
  end,
  HomeTradeUpgrade_Group_Right_Group_NotMax_Btn_confirm_Click = function(btn, str)
    Controller.OnConfirmUpBtnClick()
  end,
  HomeTradeUpgrade_ScrollGrid_down_SetGrid = function(element, elementIndex)
    Controller.RefreshStationListElementShow(element, elementIndex)
  end,
  HomeTradeUpgrade_ScrollGrid_down_Group_Item_Btn__Click = function(btn, str)
  end,
  HomeTradeUpgrade_Group_Left_ScrollGrid_Left_Group_Item_Btn__Click = function(btn, str)
  end,
  HomeTradeUpgrade_Group_Right_Img_Item_Btn__Click = function(btn, str)
  end,
  HomeTradeUpgrade_Group_Right_Group_NotMax_Btn_Min_Click = function(btn, str)
    Controller.OnLvMinBtnClick()
  end,
  HomeTradeUpgrade_Group_Right_Group_NotMax_Btn_Down_Click = function(btn, str)
    Controller.OnLvDownBtnClick()
  end,
  HomeTradeUpgrade_Group_Right_Group_NotMax_Btn_Up_Click = function(btn, str)
    Controller.OnLvUpBtnClick()
  end,
  HomeTradeUpgrade_Group_Right_Group_NotMax_Btn_Max_Click = function(btn, str)
    Controller.OnLvMaxBtnClick()
  end,
  HomeTradeUpgrade_Group_Right_Img_BarBG_Btn__Click = function(btn, str)
    UIManager:Open("UI/HomeTrade/Update/TradeUpdateDetail")
  end
}
return ViewFunction
