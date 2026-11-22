local View = require("UIEquipment_Illustration/UIEquipment_IllustrationView")
local DataModel = require("UIEquipment_Illustration/UIEquipment_IllustrationDataModel")
local Controller = require("UIEquipment_Illustration/UIEquipment_IllustrationController")
local BookListController = require("UIBookList/UIBookListController")
local ViewFunction = {
  Equipment_Illustration_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller.Close()
  end,
  Equipment_Illustration_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  Equipment_Illustration_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Equipment_Illustration_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  Equipment_Illustration_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Controller.RefreshEquipElement(element, elementIndex)
  end,
  Equipment_Illustration_ScrollGrid_List_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  Equipment_Illustration_Group_Filter_Btn_All_Click = function(btn, str)
    Controller.OnTabBtnClick(1)
  end,
  Equipment_Illustration_Group_Filter_Btn_Unlock_Click = function(btn, str)
    Controller.OnTabBtnClick(2)
  end,
  Equipment_Illustration_Group_Filter_Btn_Lock_Click = function(btn, str)
    Controller.OnTabBtnClick(3)
  end,
  Equipment_Illustration_Group_Filter_Group_Quality_Btn_Off_Click = function(btn, str)
    Controller.OnCloseFilterBtnClick()
  end,
  Equipment_Illustration_Group_Filter_Group_Quality_Group_Active_Btn_All_Click = function(btn, str)
    Controller.OnQualitySelectClick(0)
  end,
  Equipment_Illustration_Group_Filter_Group_Quality_Group_Active_Btn_Blue_Click = function(btn, str)
    Controller.OnQualitySelectClick(1)
  end,
  Equipment_Illustration_Group_Filter_Group_Quality_Group_Active_Btn_Purple_Click = function(btn, str)
    Controller.OnQualitySelectClick(2)
  end,
  Equipment_Illustration_Group_Filter_Group_Quality_Group_Active_Btn_Golden_Click = function(btn, str)
    Controller.OnQualitySelectClick(3)
  end,
  Equipment_Illustration_Group_Filter_Group_Quality_Group_Active_Btn_Orange_Click = function(btn, str)
    Controller.OnQualitySelectClick(4)
  end,
  Equipment_Illustration_Group_Filter_Group_Quality_Group_Active_Btn_Debuff_Click = function(btn, str)
    Controller.OnQualitySelectClick(5)
  end,
  Equipment_Illustration_Group_Filter_Group_Quality_Btn_On_Click = function(btn, str)
    Controller.OnFilterBtnClick()
  end,
  Equipment_Illustration_Btn_Rewards_Click = function(btn, str)
    Controller.OnEquipRewardClick()
  end
}
return ViewFunction
