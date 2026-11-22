local View = require("UIHelpRoleBattleSelect/UIHelpRoleBattleSelectView")
local DataModel = require("UIHelpRoleBattleSelect/UIHelpRoleBattleSelectDataModel")
local Controller = require("UIHelpRoleBattleSelect/UIHelpRoleBattleSelectController")
local ViewFunction = {
  HelpRoleBattleSelect_ScrollGrid_CharacterList_SetGrid = function(element, elementIndex)
    Controller:SetRoleElement(element, elementIndex)
  end,
  HelpRoleBattleSelect_ScrollGrid_CharacterList_Group_Character_Btn_Mask_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_ScrollGrid_CharacterList_Group_Character_Group_Break_StaticGrid_BK_SetGrid = function(element, elementIndex)
  end,
  HelpRoleBattleSelect_ScrollGrid_CharacterList_Group_Character_Btn_Item_Click = function(btn, str)
    Controller:OnClickRole(tonumber(str))
  end,
  HelpRoleBattleSelect_ScrollGrid_HelpRoleList_SetGrid = function(element, elementIndex)
    Controller:SetHelpRoleElement(element, elementIndex)
  end,
  HelpRoleBattleSelect_ScrollGrid_HelpRoleList_Group_Character_Group_Break_StaticGrid_BK_SetGrid = function(element, elementIndex)
  end,
  HelpRoleBattleSelect_ScrollGrid_HelpRoleList_Group_Character_Group_Equip_Group_Equipment_Btn_Item_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_ScrollGrid_HelpRoleList_Group_Character_Group_Equip_Group_Equipment_Group_Equipment_Btn_Item_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_ScrollGrid_HelpRoleList_Group_Character_Group_Equip_StaticGrid_Equip_SetGrid = function(element, elementIndex)
    Controller:OnSetHelpRoleEquipGrid(element, elementIndex)
  end,
  HelpRoleBattleSelect_ScrollGrid_HelpRoleList_Group_Character_Group_Equip_StaticGrid_Equip_Group_Equipment_Btn_Item_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_ScrollGrid_HelpRoleList_Group_Character_Group_Equip_StaticGrid_Equip_Group_Equipment_Group_Equipment_Btn_Item_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_ScrollGrid_HelpRoleList_Group_Character_Btn_Item_Click = function(btn, str)
    Controller:OnClickHelpRole(tonumber(str))
  end,
  HelpRoleBattleSelect_Group_Detail_Btn_Captain_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_Group_Detail_Btn_Check_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_Group_Detail_Btn_InTeam_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_Group_Detail_Btn_OutTeam_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_Group_Detail_Group_Property_Btn_Attribute_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_Group_Detail_Group_Attribute_StaticGrid_Item_SetGrid = function(element, elementIndex)
  end,
  HelpRoleBattleSelect_Group_Detail_Btn_Confirm_Click = function(btn, str)
    Controller:OnSetHelpSquad()
    UIManager:GoBack()
  end,
  HelpRoleBattleSelect_Group_Detail_Group_Card_Btn_Close_Des_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_Group_Detail_Group_Card_StaticGrid_Card_SetGrid = function(element, elementIndex)
    Controller:OnsetRoleCardGrid(element, elementIndex)
  end,
  HelpRoleBattleSelect_Group_Detail_Group_Card_StaticGrid_Card_Group_IconSkill_Btn_Skill_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_Group_Detail_Group_CardDesCharacter_Btn_Close_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_Group_Detail_Group_Equip_StaticGrid_Equip_SetGrid = function(element, elementIndex)
  end,
  HelpRoleBattleSelect_Group_Detail_Group_Equip_StaticGrid_Equip_Group_Equip_Btn_Equip_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_Group_Detail_Btn_Role_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_Common_Filter_Group_TabBtn_Btn_Level_Click = function(btn, str)
    Controller:OnClickSort("Level")
  end,
  HelpRoleBattleSelect_Common_Filter_Group_TabBtn_Btn_Rarity_Click = function(btn, str)
    Controller:OnClickSort("Rarity")
  end,
  HelpRoleBattleSelect_Common_Filter_Group_TabBtn_Btn_Time_Click = function(btn, str)
    Controller:OnClickSort("Time")
  end,
  HelpRoleBattleSelect_Common_Filter_Group_TabBtn_Btn_Screen_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_Common_Filter_Group_Filter_Btn_BG_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_Common_Filter_Group_Filter_StaticGrid_Title_SetGrid = function(element, elementIndex)
  end,
  HelpRoleBattleSelect_Common_Filter_Group_Filter_StaticGrid_1_SetGrid = function(element, elementIndex)
  end,
  HelpRoleBattleSelect_Common_Filter_Group_Filter_StaticGrid_1_Group_BtnT_Btn_Item_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_Common_Filter_Group_Filter_StaticGrid_2_SetGrid = function(element, elementIndex)
  end,
  HelpRoleBattleSelect_Common_Filter_Group_Filter_StaticGrid_2_Group_BtnT_Btn_Item_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_Common_Filter_Group_Filter_StaticGrid_3_SetGrid = function(element, elementIndex)
  end,
  HelpRoleBattleSelect_Common_Filter_Group_Filter_StaticGrid_3_Group_BtnT_Btn_Item_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_Common_Filter_Group_Filter_Btn_OK_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_Common_Filter_Group_Filter_Btn_Cancel_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack(false)
  end,
  HelpRoleBattleSelect_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  HelpRoleBattleSelect_Btn_Refresh_Click = function(btn, str)
    Controller:OnClickBtnRefresh()
  end
}
return ViewFunction
