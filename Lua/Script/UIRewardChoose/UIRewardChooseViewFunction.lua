local View = require("UIRewardChoose/UIRewardChooseView")
local DataModel = require("UIRewardChoose/UIRewardChooseDataModel")
local Controller = require("UIRewardChoose/UIRewardChooseController")
local ViewFunction = {
  RewardChoose_Group_Equipment_Group_Item_Btn_Select_Click = function(btn, str)
  end,
  RewardChoose_Group_Equipment_StaticGrid_Equipment_SetGrid = function(element, elementIndex)
    Controller:SetEquipGrid(element, elementIndex)
  end,
  RewardChoose_Group_Equipment_StaticGrid_Equipment_Group_Item_Btn_Select_Click = function(btn, str)
    Controller:OnClickEquip(btn, str)
  end,
  RewardChoose_Group_Equip_Group_Role_Group_Character_Group_Break_StaticGrid_BK_SetGrid = function(element, elementIndex)
  end,
  RewardChoose_Group_Equip_Group_Role_Group_Character_Btn_Item_Click = function(btn, str)
  end,
  RewardChoose_Group_Equip_Group_Role_Btn_Select_Click = function(btn, str)
  end,
  RewardChoose_Group_Equip_StaticGrid_Team_SetGrid = function(element, elementIndex)
    Controller:SetRoleGrid(element, elementIndex)
  end,
  RewardChoose_Group_Equip_StaticGrid_Team_Group_Role_Group_Character_Group_Break_StaticGrid_BK_SetGrid = function(element, elementIndex)
  end,
  RewardChoose_Group_Equip_StaticGrid_Team_Group_Role_Group_Character_Btn_Item_Click = function(btn, str)
    Controller:OnClickRole(btn, str)
  end,
  RewardChoose_Group_Equip_StaticGrid_Team_Group_Role_Btn_Select_Click = function(btn, str)
    Controller:OnClickRole(btn, str)
  end,
  RewardChoose_Group_Equipment_Group_Item_Group_Character_Btn_Item_Click = function(btn, str)
  end,
  RewardChoose_Group_Equipment_StaticGrid_Equipment_Group_Item_Group_Character_Btn_Item_Click = function(btn, str)
    Controller:OnClickPreEquip(str)
  end,
  RewardChoose_Group_Equip_Group_Role_Group_Equipment_Group_Equipment_Group_Have_Btn_Item_Click = function(btn, str)
  end,
  RewardChoose_Group_Equip_Group_Role_Group_Equipment_StaticGrid_Equipment_SetGrid = function(element, elementIndex)
  end,
  RewardChoose_Group_Equip_Group_Role_Group_Equipment_StaticGrid_Equipment_Group_Equipment_Group_Have_Btn_Item_Click = function(btn, str)
  end,
  RewardChoose_Group_Equip_StaticGrid_Team_Group_Role_Group_Equipment_Group_Equipment_Group_Have_Btn_Item_Click = function(btn, str)
  end,
  RewardChoose_Group_Equip_StaticGrid_Team_Group_Role_Group_Equipment_StaticGrid_Equipment_SetGrid = function(element, elementIndex)
    Controller:SetRoleEquipGrid(element, elementIndex)
  end,
  RewardChoose_Group_Equip_StaticGrid_Team_Group_Role_Group_Equipment_StaticGrid_Equipment_Group_Equipment_Group_Have_Btn_Item_Click = function(btn, str)
    Controller:OnClickRoleEquip(str)
  end,
  RewardChoose_Group_Equip_Group_Confirm_Group_Equipment_Btn_Item_Click = function(btn, str)
  end,
  RewardChoose_Group_Equip_Group_Confirm_Btn_Confirm_Click = function(btn, str)
    Controller:OnConfirmReplqceEquip()
  end,
  RewardChoose_Btn_Back_Click = function(btn, str)
    Net:SendProto("battle.replace_equip", function()
      UIManager:GoBack()
    end, "", "", DataModel.levelIndex)
  end
}
return ViewFunction
