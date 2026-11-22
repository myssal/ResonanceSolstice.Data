local View = require("UIRevive/UIReviveView")
local DataModel = require("UIRevive/UIReviveDataModel")
local Controller = require("UIRevive/UIReviveController")
local ViewFunction = {
  Revive_Btn_Back_Click = function(btn, str)
    UIManager:GoBack()
  end,
  Revive_ScrollGrid_RoleList_SetGrid = function(element, elementIndex)
    Controller:OnSetRoleGrid(element, elementIndex)
  end,
  Revive_ScrollGrid_RoleList_Group_BattleTeamRole_Group_Info_Group_Break_StaticGrid_BK_SetGrid = function(element, elementIndex)
  end,
  Revive_ScrollGrid_RoleList_Group_BattleTeamRole_Btn_Click_Click = function(btn, str)
    Controller:OnClickRoleBtn(str)
  end,
  Revive_Btn_Confirm_Click = function(btn, str)
    Controller:OnBtnRevive()
  end,
  Revive_ScrollGrid_RoleList_Group_BattleTeamRole_Btn_Click_LongPress = function(btn, str)
  end
}
return ViewFunction
