local View = require("UIHelpRoleSelect/UIHelpRoleSelectView")
local DataModel = require("UIHelpRoleSelect/UIHelpRoleSelectDataModel")
local Controller = require("UIHelpRoleSelect/UIHelpRoleSelectController")
local ViewFunction = {
  HelpRoleSelect_ScrollGrid_CharacterList_SetGrid = function(element, elementIndex)
    Controller:SetRoleElement(element, elementIndex)
  end,
  HelpRoleSelect_ScrollGrid_CharacterList_Group_Character_Btn_Mask_Click = function(btn, str)
  end,
  HelpRoleSelect_ScrollGrid_CharacterList_Group_Character_Group_Break_StaticGrid_BK_SetGrid = function(element, elementIndex)
  end,
  HelpRoleSelect_ScrollGrid_CharacterList_Group_Character_Btn_Item_Click = function(btn, str)
    Controller:OnClickRole(tonumber(str))
  end,
  HelpRoleSelect_Group_Detail_Btn_Captain_Click = function(btn, str)
  end,
  HelpRoleSelect_Group_Detail_Btn_Check_Click = function(btn, str)
  end,
  HelpRoleSelect_Group_Detail_Btn_InTeam_Click = function(btn, str)
  end,
  HelpRoleSelect_Group_Detail_Btn_OutTeam_Click = function(btn, str)
  end,
  HelpRoleSelect_Group_Detail_Group_Property_Btn_Attribute_Click = function(btn, str)
  end,
  HelpRoleSelect_Group_Detail_Group_Attribute_StaticGrid_Item_SetGrid = function(element, elementIndex)
  end,
  HelpRoleSelect_Group_Detail_Btn_Confirm_Click = function(btn, str)
    Controller:TryAddHelpRoles()
  end,
  HelpRoleSelect_Group_Detail_Group_Card_Btn_Close_Des_Click = function(btn, str)
  end,
  HelpRoleSelect_Group_Detail_Group_Card_StaticGrid_Card_SetGrid = function(element, elementIndex)
    Controller:OnsetRoleCardGrid(element, elementIndex)
  end,
  HelpRoleSelect_Group_Detail_Group_Card_StaticGrid_Card_Group_IconSkill_Btn_Skill_Click = function(btn, str)
  end,
  HelpRoleSelect_Group_Detail_Group_Equip_StaticGrid_Equip_SetGrid = function(element, elementIndex)
  end,
  HelpRoleSelect_Group_Detail_Group_Equip_StaticGrid_Equip_Group_Equip_Btn_Equip_Click = function(btn, str)
  end,
  HelpRoleSelect_Group_Detail_Btn_Role_Click = function(btn, str)
    Controller:OnClickBtnRole()
  end,
  HelpRoleSelect_Common_Filter_Group_TabBtn_Btn_Level_Click = function(btn, str)
    Controller:OnClickSort("Level")
  end,
  HelpRoleSelect_Common_Filter_Group_TabBtn_Btn_Rarity_Click = function(btn, str)
    Controller:OnClickSort("Rarity")
  end,
  HelpRoleSelect_Common_Filter_Group_TabBtn_Btn_Time_Click = function(btn, str)
    Controller:OnClickSort("Time")
  end,
  HelpRoleSelect_Common_Filter_Group_TabBtn_Btn_Screen_Click = function(btn, str)
  end,
  HelpRoleSelect_Common_Filter_Group_Filter_Btn_BG_Click = function(btn, str)
  end,
  HelpRoleSelect_Common_Filter_Group_Filter_StaticGrid_Title_SetGrid = function(element, elementIndex)
  end,
  HelpRoleSelect_Common_Filter_Group_Filter_StaticGrid_1_SetGrid = function(element, elementIndex)
  end,
  HelpRoleSelect_Common_Filter_Group_Filter_StaticGrid_1_Group_BtnT_Btn_Item_Click = function(btn, str)
  end,
  HelpRoleSelect_Common_Filter_Group_Filter_StaticGrid_2_SetGrid = function(element, elementIndex)
  end,
  HelpRoleSelect_Common_Filter_Group_Filter_StaticGrid_2_Group_BtnT_Btn_Item_Click = function(btn, str)
  end,
  HelpRoleSelect_Common_Filter_Group_Filter_StaticGrid_3_SetGrid = function(element, elementIndex)
  end,
  HelpRoleSelect_Common_Filter_Group_Filter_StaticGrid_3_Group_BtnT_Btn_Item_Click = function(btn, str)
  end,
  HelpRoleSelect_Common_Filter_Group_Filter_Btn_OK_Click = function(btn, str)
  end,
  HelpRoleSelect_Common_Filter_Group_Filter_Btn_Cancel_Click = function(btn, str)
  end,
  HelpRoleSelect_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  HelpRoleSelect_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  HelpRoleSelect_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  HelpRoleSelect_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end
}
return ViewFunction
