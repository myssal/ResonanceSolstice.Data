local View = require("UIItem_Illustration/UIItem_IllustrationView")
local DataModel = require("UIItem_Illustration/UIItem_IllustrationDataModel")
local Controller = require("UIItem_Illustration/UIItem_IllustrationController")
local ViewFunction = {
  Item_Illustration_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Controller.RefreshItemElement(element, elementIndex)
  end,
  Item_Illustration_ScrollGrid_List_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  Item_Illustration_Group_Filter_Btn_All_Click = function(btn, str)
    Controller.OnTabBtnClick(1)
  end,
  Item_Illustration_Group_Filter_Btn_Unlock_Click = function(btn, str)
    Controller.OnTabBtnClick(2)
  end,
  Item_Illustration_Group_Filter_Btn_Lock_Click = function(btn, str)
    Controller.OnTabBtnClick(3)
  end,
  Item_Illustration_Group_Filter_Group_Quality_Btn_Off_Click = function(btn, str)
  end,
  Item_Illustration_Group_Filter_Group_Quality_Group_Active_Btn_All_Click = function(btn, str)
  end,
  Item_Illustration_Group_Filter_Group_Quality_Group_Active_Btn_Blue_Click = function(btn, str)
  end,
  Item_Illustration_Group_Filter_Group_Quality_Group_Active_Btn_Purple_Click = function(btn, str)
  end,
  Item_Illustration_Group_Filter_Group_Quality_Group_Active_Btn_Golden_Click = function(btn, str)
  end,
  Item_Illustration_Group_Filter_Group_Quality_Group_Active_Btn_Orange_Click = function(btn, str)
  end,
  Item_Illustration_Group_Filter_Group_Quality_Group_Active_Btn_Debuff_Click = function(btn, str)
  end,
  Item_Illustration_Group_Filter_Group_Quality_Btn_On_Click = function(btn, str)
  end,
  Item_Illustration_Btn_Rewards_Click = function(btn, str)
    Controller.OnItemRewardClick()
  end,
  Item_Illustration_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller.Close()
  end,
  Item_Illustration_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  Item_Illustration_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Item_Illustration_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end
}
return ViewFunction
