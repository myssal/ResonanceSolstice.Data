local View = require("UIBattleSkipTips/UIBattleSkipTipsView")
local DataModel = require("UIBattleSkipTips/UIBattleSkipTipsDataModel")
local Controller = require("UIBattleSkipTips/UIBattleSkipTipsController")
local ViewFunction = {
  BattleSkipTips_Btn_BG_Click = function(btn, str)
    UIManager:GoBack()
  end,
  BattleSkipTips_Group_Team_Group_Role_Btn_Click_Click = function(btn, str)
  end,
  BattleSkipTips_Group_Team_Group_Role_Btn_Click_LongPress = function(btn, str)
  end,
  BattleSkipTips_Group_Team_StaticGrid_RoleList_SetGrid = function(element, elementIndex)
    Controller:SetElementRole(element, elementIndex)
  end,
  BattleSkipTips_Group_Team_StaticGrid_RoleList_Group_Role_Btn_Click_Click = function(btn, str)
  end,
  BattleSkipTips_Group_Team_StaticGrid_RoleList_Group_Role_Btn_Click_LongPress = function(btn, str)
  end,
  BattleSkipTips_ScrollGrid_Tab_SetGrid = function(element, elementIndex)
    Controller:SetElementTab(element, elementIndex)
  end,
  BattleSkipTips_ScrollGrid_Tab_Group_Item_Btn_Tab_Click = function(btn, str)
    Controller:ClickBtnTab(tonumber(str))
  end,
  BattleSkipTips_Group_Tab_Btn_Tab_01_Click = function(btn, str)
  end,
  BattleSkipTips_Group_Tab_Btn_Tab_02_Click = function(btn, str)
  end,
  BattleSkipTips_Group_Tab_Btn_Tab_03_Click = function(btn, str)
  end,
  BattleSkipTips_Group_Tab_Btn_Tab_04_Click = function(btn, str)
  end,
  BattleSkipTips_Group_Tab_Btn_Expand_Click = function(btn, str)
  end,
  BattleSkipTips_Img_Base_ScrollGrid_Btn_SetGrid = function(element, elementIndex)
  end,
  BattleSkipTips_Img_Base_ScrollGrid_Btn_Group_Item_Btn_Tab_Click = function(btn, str)
  end,
  BattleSkipTips_Btn_Confirm_Click = function(btn, str)
    Controller:StartSkipWin()
  end,
  BattleSkipTips_Btn_Close_Click = function(btn, str)
    UIManager:GoBack()
  end
}
return ViewFunction
