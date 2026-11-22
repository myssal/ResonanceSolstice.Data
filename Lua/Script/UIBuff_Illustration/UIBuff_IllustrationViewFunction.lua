local View = require("UIBuff_Illustration/UIBuff_IllustrationView")
local DataModel = require("UIBuff_Illustration/UIBuff_IllustrationDataModel")
local Controller = require("UIBuff_Illustration/UIBuff_IllustrationController")
local ViewFunction = {
  Buff_Illustration_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller.Close()
  end,
  Buff_Illustration_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  Buff_Illustration_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Buff_Illustration_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  Buff_Illustration_ScrollGrid_Filter_SetGrid = function(element, elementIndex)
    Controller.RefreshTabElement(element, elementIndex)
  end,
  Buff_Illustration_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Controller.RefreshBuffElement(element, elementIndex)
  end,
  Buff_Illustration_ScrollGrid_List_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  Buff_Illustration_Btn_Rewards_Click = function(btn, str)
    Controller.OnBuffRewardClick()
  end,
  Buff_Illustration_ScrollGrid_Filter_Group_Type_Btn__Click = function(btn, str)
  end,
  Buff_Illustration_ScrollGrid_Filter_Group_Item_Btn_Tactics_Click = function(btn, str)
  end
}
return ViewFunction
