local View = require("UICubeSkill/UICubeSkillView")
local DataModel = require("UICubeSkill/UICubeSkillDataModel")
local Controller = require("UICubeSkill/UICubeSkillController")
local ViewFunction = {
  CubeSkill_ScrollView_SkillList_Viewport_Content_Group_Skill_Group_Item_Btn_Skill_Click = function(btn, str)
  end,
  CubeSkill_ScrollView_SkillList_Viewport_Content_Group_Skill_StaticGrid_SkillList_SetGrid = function(element, elementIndex)
    Controller.RefreshSkillItemElement(element, elementIndex)
  end,
  CubeSkill_ScrollView_SkillList_Viewport_Content_Group_Skill_StaticGrid_SkillList_Group_Item_Btn_Skill_Click = function(btn, str)
  end,
  CubeSkill_Group_Bottom_Group_Btn_Group_Unlockable_Btn_Unlock_Click = function(btn, str)
    Controller.OnUnlockAbleBtnClick()
  end,
  CubeSkill_Group_Coin_Btn_GoldCoin_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreItemTips({itemId = itemId})
  end,
  CubeSkill_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
    View.self:Confirm()
  end,
  CubeSkill_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  CubeSkill_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  CubeSkill_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end
}
return ViewFunction
