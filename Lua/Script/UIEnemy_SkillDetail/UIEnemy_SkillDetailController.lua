local View = require("UIEnemy_SkillDetail/UIEnemy_SkillDetailView")
local DataModel = require("UIEnemy_SkillDetail/UIEnemy_SkillDetailDataModel")
local DetailController = require("UIEnemy_Detail/UIEnemy_DetailController")
local DetailDataModel = require("UIEnemy_Detail/UIEnemy_DetailDataModel")
local Controller = {}

function Controller:Init()
  local enemyList = {}
  local enemyMap = {}
  local initIndex = 1
  if DataModel.levelId ~= nil then
    local levelCA = PlayerData:GetFactoryData(DataModel.levelId)
    for i = 1, #levelCA.enemyWaveList do
      local waveCA = PlayerData:GetFactoryData(levelCA.enemyWaveList[i].enemyWaveId)
      for j = 1, #waveCA.enemyList do
        local enemyId = waveCA.enemyList[j].id
        if enemyMap[enemyId] ~= true then
          local enemyData = Controller:GetEnemyData(enemyId)
          if enemyData ~= nil then
            enemyList[#enemyList + 1] = enemyData
            if enemyId == DataModel.enemyId then
              initIndex = #enemyList
            end
          end
          enemyMap[enemyId] = true
        end
      end
    end
  elseif DataModel.enemyId ~= nil then
    local enemyData = Controller:GetEnemyData(DataModel.enemyId)
    if enemyData ~= nil then
      enemyList[#enemyList + 1] = enemyData
    end
  end
  DataModel.enemyList = enemyList
  View.ScrollGrid_Left.grid.self:SetDataCount(#enemyList)
  DataModel.enemyIndex = nil
  Controller:OnSelectEnemy(initIndex)
  View.ScrollGrid_Left.grid.self:MoveToTop()
end

function Controller:GetEnemyData(enemyId)
  local row = {}
  local ca = PlayerData:GetFactoryData(enemyId)
  if #ca.enemySkillList <= 0 then
    return nil
  end
  row.id = enemyId
  row.hpGrade = PlayerData:GetEnemyHpGrade(ca.hp_SN)
  row.defGrade = PlayerData:GetEnemyDefGrade(ca.def_SN)
  row.atkGrade = PlayerData:GetEnemyAtkGrade(ca.atk_SN)
  return row
end

function Controller:OnSelectEnemy(index)
  if DataModel.enemyIndex == index then
    return
  end
  DataModel.enemyIndex = index
  View.ScrollGrid_Left.grid.self:RefreshAllElement()
  DetailDataModel.Content = DataModel.enemyList[index]
  DetailController:SetView(View)
  DetailController:Init(DataModel.enemyList[index].id)
  Controller:RefreshSkillUI(View.ScrollView_Right.Viewport.Content)
end

function Controller:RefreshSkillUI(content)
  local enemyId = DataModel.enemyList[DataModel.enemyIndex].id
  local enemyCA = PlayerData:GetFactoryData(enemyId)
  if #enemyCA.enemySkillList <= 0 then
    content.Img_ActionSkills:SetActive(false)
    content.Img_PassiveSkills:SetActive(false)
    return
  end
  local skillListCA = PlayerData:GetFactoryData(enemyCA.enemySkillList[1].id)
  local hasActionSkill = 0 < #skillListCA.actionSkillList
  if hasActionSkill then
    DataModel.actionSkillList = skillListCA.actionSkillList
    content.Img_ActionSkills.StaticGrid_Des.grid.self:SetDataCount(#skillListCA.actionSkillList)
    content.Img_ActionSkills.StaticGrid_Des.grid.self:RefreshAllElement()
  end
  content.Img_ActionSkills:SetActive(hasActionSkill)
  local hasPassiveSkill = 0 < #skillListCA.passivSkillList
  if hasPassiveSkill then
    DataModel.passiveSkillList = skillListCA.passivSkillList
    content.Img_PassiveSkills.StaticGrid_Des.grid.self:SetDataCount(#skillListCA.passivSkillList)
    content.Img_PassiveSkills.StaticGrid_Des.grid.self:RefreshAllElement()
  end
  content.Img_PassiveSkills:SetActive(hasPassiveSkill)
end

function Controller:OnSetActiveGrid(element, elementIndex)
  local data = DataModel.actionSkillList[elementIndex]
  self:SetSkillText(element, data)
end

function Controller:OnSetPassiveGrid(element, elementIndex)
  local data = DataModel.passiveSkillList[elementIndex]
  self:SetSkillText(element, data)
end

function Controller:SetSkillText(item, data)
  local str = string.format(GetText(80607505), data.skillName, data.skillText)
  item:SetText(str)
end

function Controller:OnsetEnemyGrid(element, elementIndex)
  local enemyId = DataModel.enemyList[elementIndex].id
  element.Img_Selected:SetActive(DataModel.enemyIndex == elementIndex)
  element.Img_Mask:SetActive(DataModel.enemyIndex ~= elementIndex)
  local enemyCA = PlayerData:GetFactoryData(enemyId)
  local enemyViewCA = PlayerData:GetFactoryData(enemyCA.viewId)
  element.Group_Face.Img_Face:SetSprite(enemyViewCA.face)
  element.Btn_:SetClickParam(elementIndex)
end

return Controller
