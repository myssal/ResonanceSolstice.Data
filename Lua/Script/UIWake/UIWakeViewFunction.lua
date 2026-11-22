local View = require("UIWake/UIWakeView")
local DataModel = require("UIWake/UIWakeDataModel")
local Controller = require("UIWake/UIWakeController")
local ViewFunction = {
  Wake_Btn_Back_Click = function(btn, str)
    UIManager:GoBack()
  end,
  Wake_ScrollGrid_RoleList_SetGrid = function(element, elementIndex)
    Controller:OnSetRoleGrid(element, elementIndex)
  end,
  Wake_ScrollGrid_RoleList_Group_Character_Group_Break_StaticGrid_BK_SetGrid = function(element, elementIndex)
  end,
  Wake_ScrollGrid_RoleList_Group_Character_Btn_Click_Click = function(btn, str)
    Controller:OnSelectRole(tonumber(str))
  end,
  Wake_Btn_Confirm_Click = function(btn, str)
    Controller:OnBtnAwake()
  end,
  Wake_Group_Icon1_Group_SkillIcon1_Btn_SkillIcon1_Click = function(btn, str)
    Controller:SelectAwake(1)
  end,
  Wake_Group_Icon1_Group_SkillIcon2_Btn_SkillIcon2_Click = function(btn, str)
    Controller:SelectAwake(2)
  end,
  Wake_Group_Icon1_Group_SkillIcon3_Btn_SkillIcon3_Click = function(btn, str)
    Controller:SelectAwake(3)
  end,
  Wake_Group_Icon1_Group_SkillIcon4_Btn_SkillIcon4_Click = function(btn, str)
    Controller:SelectAwake(4)
  end,
  Wake_Group_Icon1_Group_SkillIcon5_Btn_SkillIcon5_Click = function(btn, str)
    Controller:SelectAwake(5)
  end,
  Wake_Group_BK_Group_Current_StaticGrid_BK_SetGrid = function(element, elementIndex)
  end,
  Wake_Group_BK_Group_Next_StaticGrid_BK_SetGrid = function(element, elementIndex)
  end
}
return ViewFunction
