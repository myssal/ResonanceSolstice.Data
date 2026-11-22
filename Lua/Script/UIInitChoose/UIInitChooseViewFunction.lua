local View = require("UIInitChoose/UIInitChooseView")
local DataModel = require("UIInitChoose/UIInitChooseDataModel")
local Controller = require("UIInitChoose/UIInitChooseController")
local ViewFunction = {
  InitChoose_Group_Choose_Group_Role_Group_Role_Group_Character_Group_Break_StaticGrid_BK_SetGrid = function(element, elementIndex)
  end,
  InitChoose_Group_Choose_Group_Role_Group_Role_Group_Character_Btn_Item_Click = function(btn, str)
  end,
  InitChoose_Group_Choose_Group_Role_Group_Role_Btn_Select_Click = function(btn, str)
  end,
  InitChoose_Group_Choose_Group_Role_StaticGrid_Role_SetGrid = function(element, elementIndex)
    Controller:OnSetChooseRoleGrid(element, elementIndex)
  end,
  InitChoose_Group_Choose_Group_Role_StaticGrid_Role_Group_Role_Group_Character_Group_Break_StaticGrid_BK_SetGrid = function(element, elementIndex)
  end,
  InitChoose_Group_Choose_Group_Role_StaticGrid_Role_Group_Role_Group_Character_Btn_Item_Click = function(btn, str)
    Controller:OnClickPreRole(str)
  end,
  InitChoose_Group_Choose_Group_Role_StaticGrid_Role_Group_Role_Btn_Select_Click = function(btn, str)
    Controller:OnChooseRole(btn, str)
  end,
  InitChoose_Group_Choose_Group_Equipment_Group_Item_Btn_Select_Click = function(btn, str)
  end,
  InitChoose_Group_Choose_Group_Equipment_StaticGrid_Equipment_SetGrid = function(element, elementIndex)
    Controller:OnSetChooseEquipGrid(element, elementIndex)
  end,
  InitChoose_Group_Choose_Group_Equipment_StaticGrid_Equipment_Group_Item_Btn_Select_Click = function(btn, str)
    Controller:OnChooseEquip(btn, str)
  end,
  InitChoose_Group_Captain_Group_Role_Group_Character_Group_Break_StaticGrid_BK_SetGrid = function(element, elementIndex)
  end,
  InitChoose_Group_Captain_Group_Role_Group_Character_Btn_Item_Click = function(btn, str)
  end,
  InitChoose_Group_Captain_Group_Role_Btn_Select_Click = function(btn, str)
  end,
  InitChoose_Group_Captain_StaticGrid_Team_SetGrid = function(element, elementIndex)
    Controller:OnSetTeamCaptainGrid(element, elementIndex)
  end,
  InitChoose_Group_Captain_StaticGrid_Team_Group_Role_Group_Character_Group_Break_StaticGrid_BK_SetGrid = function(element, elementIndex)
  end,
  InitChoose_Group_Captain_StaticGrid_Team_Group_Role_Group_Character_Btn_Item_Click = function(btn, str)
    Controller:OnChooseCaptain(btn, str)
  end,
  InitChoose_Group_Captain_StaticGrid_Team_Group_Role_Btn_Select_Click = function(btn, str)
    Controller:OnChooseCaptain(btn, str)
  end,
  InitChoose_Group_Choose_Group_Equipment_Group_Item_Group_Character_Btn_Item_Click = function(btn, str)
  end,
  InitChoose_Group_Choose_Group_Equipment_StaticGrid_Equipment_Group_Item_Group_Character_Btn_Item_Click = function(btn, str)
    Controller:OnClickPreEquip(str)
  end,
  InitChoose_Group_Choose_Group_Team_StaticGrid_Team_SetGrid = function(element, elementIndex)
    Controller:OnSetChooseTeamGrid(element, elementIndex)
  end,
  InitChoose_Group_Captain_Group_Role_Group_Equipment_Group_Equipment_Group_Have_Btn_Item_Click = function(btn, str)
  end,
  InitChoose_Group_Captain_Group_Role_Group_Equipment_StaticGrid_Equipment_SetGrid = function(element, elementIndex)
  end,
  InitChoose_Group_Captain_Group_Role_Group_Equipment_StaticGrid_Equipment_Group_Equipment_Group_Have_Btn_Item_Click = function(btn, str)
  end,
  InitChoose_Group_Captain_StaticGrid_Team_Group_Role_Group_Equipment_Group_Equipment_Group_Have_Btn_Item_Click = function(btn, str)
  end,
  InitChoose_Group_Captain_StaticGrid_Team_Group_Role_Group_Equipment_StaticGrid_Equipment_SetGrid = function(element, elementIndex)
    Controller:OnSetTeamEquipGrid(element, elementIndex)
  end,
  InitChoose_Group_Captain_StaticGrid_Team_Group_Role_Group_Equipment_StaticGrid_Equipment_Group_Equipment_Group_Have_Btn_Item_Click = function(btn, str)
    Controller:OnClickTeamEquip(str)
  end,
  InitChoose_Group_Captain_Group_Confirm_Btn_Confirm_Click = function(btn, str)
    Controller:OnCaptainConfrim()
  end,
  InitChoose_Group_Captain_Group_Confirm_Group_Role_Btn_Role_Click = function(btn, str)
    Controller:OnClickBtnRole()
  end
}
return ViewFunction
