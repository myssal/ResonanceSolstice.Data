local View = require("UIEnemy_SkillDetail/UIEnemy_SkillDetailView")
local DataModel = require("UIEnemy_SkillDetail/UIEnemy_SkillDetailDataModel")
local Controller = require("UIEnemy_SkillDetail/UIEnemy_SkillDetailController")
local DetailController = require("UIEnemy_Detail/UIEnemy_DetailController")
local DetailDataModel = require("UIEnemy_Detail/UIEnemy_DetailDataModel")
local ViewFunction = {
  Enemy_SkillDetail_Btn_BG_Click = function(btn, str)
    if DataModel.isInBattle then
      local BattleControlManager = CBus:GetManager(CS.ManagerName.BattleControlManager)
      BattleControlManager:Pause(false)
      DataModel.isInBattle = nil
    end
    UIManager:GoBack(false)
  end,
  Enemy_SkillDetail_ScrollView_Right_Viewport_Content_Group_Icon_Group_Identity_ScrollGrid_Identity_SetGrid = function(element, elementIndex)
    local row = DetailDataModel.IdentityList[tonumber(elementIndex)]
    DetailController:SetRightElement(element, row)
  end,
  Enemy_SkillDetail_ScrollView_Right_Viewport_Content_Group_Icon_Group_Resistance_ScrollGrid_Resistance_SetGrid = function(element, elementIndex)
    local row = DetailDataModel.ResistanceList[tonumber(elementIndex)]
    DetailController:SetRightElement(element, row)
  end,
  Enemy_SkillDetail_ScrollView_Right_Viewport_Content_Group_Icon_Group_Weakness_ScrollGrid_Weakness_SetGrid = function(element, elementIndex)
    local row = DetailDataModel.WeaknessList[tonumber(elementIndex)]
    DetailController:SetRightElement(element, row)
  end,
  Enemy_SkillDetail_ScrollView_Right_Viewport_Content_Group_Drop_StaticGrid_DropItem_SetGrid = function(element, elementIndex)
    local row = DetailDataModel.DropRewardList[tonumber(elementIndex)]
    DetailController:SetDropElement(element, row)
    element.Btn_Item:SetClickParam(elementIndex)
  end,
  Enemy_SkillDetail_ScrollView_Right_Viewport_Content_Group_Drop_StaticGrid_DropItem_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(DetailDataModel.DropRewardList[tonumber(str)].id, DetailDataModel.DropRewardList[tonumber(str)])
  end,
  Enemy_SkillDetail_ScrollGrid_Left_SetGrid = function(element, elementIndex)
    Controller:OnsetEnemyGrid(element, elementIndex)
  end,
  Enemy_SkillDetail_ScrollGrid_Left_Group_Item_Btn__Click = function(btn, str)
    Controller:OnSelectEnemy(tonumber(str))
  end,
  Enemy_SkillDetail_ScrollView_Right_Viewport_Content_Img_ActionSkills_StaticGrid_Des_SetGrid = function(element, elementIndex)
    Controller:OnSetActiveGrid(element, elementIndex)
  end,
  Enemy_SkillDetail_ScrollView_Right_Viewport_Content_Img_PassiveSkills_StaticGrid_Des_SetGrid = function(element, elementIndex)
    Controller:OnSetPassiveGrid(element, elementIndex)
  end
}
return ViewFunction
