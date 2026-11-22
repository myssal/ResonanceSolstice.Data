local View = require("UITeam_Battle/UITeam_BattleView")
local DataModel = require("UITeam_Battle/UITeam_BattleDataModel")
local Controller = require("UITeam_Battle/UITeam_BattleController")
local ViewFunction = {
  Team_Battle_Btn_Back_Click = function(btn, str)
    Controller:OnClickReturn()
  end,
  Team_Battle_Group_Team_StaticGrid_RoleList_SetGrid = function(element, elementIndex)
    Controller:OnSetLevelRoleGrid(element, elementIndex)
  end,
  Team_Battle_Group_Team_StaticGrid_RoleList_Group_BattleTeamRole_Group_Info_Group_Break_StaticGrid_BK_SetGrid = function(element, elementIndex)
  end,
  Team_Battle_Group_Team_StaticGrid_RoleList_Group_BattleTeamRole_Btn_Click_Click = function(btn, str)
    Controller:OnClickLevelRole(str)
  end,
  Team_Battle_Btn_Clear_Click = function(btn, str)
    Controller:OnClickLevelBtn()
  end,
  Team_Battle_Btn_Setting_Click = function(btn, str)
    Controller:OnClickBtnAuto()
  end,
  Team_Battle_Btn_Battle_Click = function(btn, str)
    Controller:OnBtnBattle()
  end,
  Team_Battle_Group_Team_StaticGrid_RoleList_Group_BattleTeamRole_Btn_Click_LongPress = function(btn, str)
    Controller:BeginDrag(1, tonumber(str))
  end,
  Team_Battle_Group_RoleTemp_Group_Info_Group_Break_StaticGrid_BK_SetGrid = function(element, elementIndex)
  end,
  Team_Battle_Group_RoleTemp_Btn_Click_Click = function(btn, str)
  end,
  Team_Battle_ScrollGrid_RoleList_SetGrid = function(element, elementIndex)
    Controller:OnSetRoleGrid(element, elementIndex)
  end,
  Team_Battle_ScrollGrid_RoleList_Group_RoleFace_Btn_Click_Click = function(btn, str)
    Controller:OnClickRoleBtn(str)
  end
}
return ViewFunction
