local View = require("UICharacterInfo/UICharacterInfoView")
local DataModel = require("UICharacterInfo/DataModel")
local UpgradePlanner = require("UICharacterInfo/ResonanceUpgradePlanner")
local UICache = {}
local Group_TATop
local module = {
  Init = function(self)
    UICache = {}
  end,
  Load = function(self, RoleData, isUpgrade)
    DataModel.ResonanceDetailMode = nil
    DataModel.OneKeyResonancePlan = nil
    Group_TATop = {}
    DataModel.TabResonance_Lock = true
    DataModel.RightResonanceIndex = nil
    DataModel.tempLevel = DataModel.RoleData.re_lv
    DataModel.tempExp = DataModel.RoleData.re_exp
    if RoleData then
      DataModel.RoleData = RoleData
    end
    if isUpgrade ~= true then
      DataModel.isSkillDescShow = false
      DataModel.isNextSkillShow = false
      View.self:SelectPlayAnim(View.Group_SkillTree.Group_Awake.self, "close")
      self:Refresh(false)
    else
      self:Refresh(true)
    end
  end,
  Refresh = function(self, isUpDate)
    local level = DataModel.RoleData.resonance_lv
    UIManager:LoadSplitPrefab(View, "UI/CharacterInfo/CharacterInfo", "Group_SkillTree")
    View.self:SetRaycastBlock(true)
    local group_SkillTree = View.Group_SkillTree
    local Group_AwakeIcon = group_SkillTree.Group_Awake
    local isMax = false
    group_SkillTree.Group_AwakeDetails.self:SetActive(isUpDate)
    View.Group_Middle.Img_BlackMask:SetActive(false)
    local isRnLock = PlayerData:IsRoleResonanceLock(DataModel.RoleCA.id)
    Group_AwakeIcon.Group_Stage05.SpineNode_TalentLock:SetActive(false)
    Group_AwakeIcon.Group_Stage04.SpineNode_TalentLock:SetActive(false)
    if level == table.count(DataModel.RoleCA.awakeList) - 1 then
      isMax = true
      if isRnLock then
        Group_AwakeIcon["Group_Stage0" .. level].SpineNode_TalentLock:SetActive(true)
        if isUpDate then
          Group_AwakeIcon["Group_Stage0" .. level].SpineNode_TalentLock:SetAction("gongzheng_suo01", false, true)
          local sound = SoundManager:CreateSound(30002469)
          if sound ~= nil then
            sound:Play()
          end
        else
          Group_AwakeIcon["Group_Stage0" .. level].SpineNode_TalentLock:SetAction("gongzheng_suo02", false, true)
        end
      elseif isUpDate then
        local sound = SoundManager:CreateSound(30002466)
        if sound ~= nil then
          sound:Play()
        end
        Group_AwakeIcon["Group_Stage0" .. level].SpineNode_TalentLock:SetActive(true)
        Group_AwakeIcon["Group_Stage0" .. level].SpineNode_TalentLock:SetAction("gongzheng_suo03", false, true)
      end
    end
    for i = 1, #DataModel.RoleCA.talentList do
      local talentId = DataModel.RoleCA.talentList[i].talentId
      local data = PlayerData:GetFactoryData(talentId, "AwakeFactory")
      local img = "Group_Stage0" .. i
      local Group_Stage = Group_AwakeIcon[img].Group_Stage
      local Img_resonanceselect = Group_AwakeIcon[img].Img_resonanceselect
      Img_resonanceselect:SetActive(false)
      Group_Stage.Group_Talent.Img_Mask.Img_Icon:SetSprite(data.path)
      if level < i then
        if Group_AwakeIcon["Group_Line" .. i] ~= nil then
          Group_AwakeIcon["Group_Line" .. i]:SetActive(false)
        end
        Group_Stage.Group_Talent.Img_Mask.Img_Icon:SetColor("#4D4D4D")
        if Group_Stage.Group_Talent.Img_IconBg ~= nil then
          Group_Stage.Group_Talent.Img_IconBg:SetColor("#4D4D4D")
        end
        local awakeId = DataModel.RoleCA.awakeList[i].awakeId
        local rData = PlayerData:GetFactoryData(awakeId, "AwakeFactory")
        Group_Stage.Group_Tips:SetActive(level == i - 1 and rData.level <= DataModel.RoleData.lv)
        Group_Stage.Img_RedPoint:SetActive(rData.level <= DataModel.RoleData.lv)
        if level == i - 1 and rData.level <= DataModel.RoleData.lv then
          local isItemEnough = self:CheckResonanceItemEnough(i)
          Group_Stage.Group_Tips.Group_Unlock:SetActive(not isItemEnough)
          Group_Stage.Group_Tips.Group_Enough:SetActive(isItemEnough)
        end
      else
        Group_Stage.Img_RedPoint:SetActive(false)
        if Group_AwakeIcon["Group_Line" .. i] ~= nil then
          Group_AwakeIcon["Group_Line" .. i]:SetActive(true)
        end
        Group_Stage.Group_Talent.Img_Mask.Img_Icon:SetColor("#FFFFFF")
        if Group_Stage.Group_Talent.Img_IconBg ~= nil then
          Group_Stage.Group_Talent.Img_IconBg:SetColor("#FFFFFF")
        end
        Group_Stage.Group_Tips:SetActive(false)
      end
      self:RefreshSkillAndAttribute(i)
    end
    if isMax ~= true then
      DataModel.TabResonance_Lock = false
    end
    if #DataModel.RoleCA.talentList < 5 then
      Group_AwakeIcon.Group_Stage05.Group_Stage.Group_Talent.Img_Mask.Img_Icon:SetSprite(UIConfig.CharacterResonanceFive)
      Group_AwakeIcon.Group_Stage05.Group_Attribute:SetActive(false)
      if Group_AwakeIcon.Group_Line5 ~= nil then
        Group_AwakeIcon.Group_Line5:SetActive(false)
      end
    end
    self:RefreshFinalSkill()
    local update = View.Group_SkillTree.Group_Update
    update.Group_Stage.Group_Talent.Img_Mask.Img_Icon:SetColor(UpgradePlanner.IsUnlocked(DataModel.RoleData, DataModel.RoleCA) and "#FFFFFF" or "#4D4D4D")
    update.Group_Stage.Group_Tips:SetActive(false)
    update.Img_resonanceselect:SetActive(false)
  end,
  RefreshSkillAndAttribute = function(self, talentIndex)
    local group_SkillTree = View.Group_SkillTree
    local Group_AwakeIcon = group_SkillTree.Group_Awake
    local group_stage = Group_AwakeIcon["Group_Stage0" .. talentIndex]
    local talentCA = PlayerData:GetFactoryData(DataModel.RoleCA.talentList[talentIndex].talentId)
    local skillCA = PlayerData:GetFactoryData(talentCA.skillIntensify)
    local group_skill = group_stage.Group_Skill
    local skillLv = self:GetResonanceSkillLevel(talentIndex)
    group_skill.Group_Line:SetActive(0 < skillLv)
    if skillLv <= 0 then
      group_skill.Group_Skill.Img_Mask.Img_Icon:SetColor("#4D4D4D")
      group_skill.Group_Skill.Img_IconBg:SetColor("#4D4D4D")
    else
      group_skill.Group_Skill.Img_Mask.Img_Icon:SetColor("#FFFFFF")
      group_skill.Group_Skill.Img_IconBg:SetColor("#FFFFFF")
    end
    group_skill.Img_resonanceselect:SetActive(false)
    local isResonanceUnlock = talentIndex <= DataModel.RoleData.resonance_lv
    if skillCA ~= nil then
      if group_skill ~= nil then
        group_skill.Group_Skill.Img_Mask.Img_Icon:SetSprite(skillCA.iconPath)
        group_skill.Group_Lv:SetActive(0 < skillLv)
        group_skill.Group_Lv.Txt_Lv:SetText(string.format(GetText(80610083), skillLv, #skillCA.attributeIntensify))
      end
      local isSkillUnlock = isResonanceUnlock and DataModel.RoleData.lv >= (skillCA.playerLevel or 1)
      local isSkillLevelMax = self:CheckResonanceSkillMaxLevel(talentIndex)
      group_skill.Group_Tips:SetActive(isSkillUnlock and not isSkillLevelMax)
      if isSkillUnlock and not isSkillLevelMax then
        local isSkillItemEnough = self:CheckResonanceSkillItemEnough(talentIndex)
        group_skill.Group_Tips.Group_Unlock:SetActive(not isSkillItemEnough)
        group_skill.Group_Tips.Group_Enough:SetActive(isSkillItemEnough)
        if 0 < skillLv and isSkillItemEnough then
          group_skill.Group_Skill.Img_Mask.Img_Icon:SetColor("#B5B5B5")
          group_skill.Group_Skill.Img_IconBg:SetColor("#B5B5B5")
        end
      end
    end
    group_stage.Group_Attribute:SetActive(true)
    local attrGrid = group_stage.Group_Attribute.StaticGrid_List.grid
    attrGrid.self:SetDataCount(#talentCA.attributeIntensify)
    for i = 1, 3 do
      group_stage.Group_Attribute["Group_Line" .. i]:SetActive(false)
    end
    for i = 1, #talentCA.attributeIntensify do
      local attrLv = self:GetResonanceAttributeLevel(talentIndex, i)
      group_stage.Group_Attribute["Group_Line" .. i]:SetActive(0 < attrLv)
      if 0 < attrLv then
        attrGrid[i].Group_Attribute.Img_Mask.Img_Icon:SetColor("#FFFFFF")
        attrGrid[i].Group_Attribute.Img_IconBg:SetColor("#FFFFFF")
      else
        attrGrid[i].Group_Attribute.Img_Mask.Img_Icon:SetColor("#4D4D4D")
        attrGrid[i].Group_Attribute.Img_IconBg:SetColor("#4D4D4D")
      end
      local listCA = PlayerData:GetFactoryData(talentCA.attributeIntensify[i].id)
      local attrCA = PlayerData:GetFactoryData(listCA.attributeGradeList[math.max(attrLv, 1)].id)
      attrGrid[i].Img_resonanceselect:SetActive(false)
      attrGrid[i].Group_Attribute.Img_Mask.Img_Icon:SetSprite(attrCA.iconPath)
      attrGrid[i].Group_Lv:SetActive(0 < attrLv)
      attrGrid[i].Group_Lv.Txt_Lv:SetText(string.format(GetText(80610083), attrLv, #listCA.attributeGradeList))
      attrGrid[i].Btn_Stage:SetClickParam(i)
      local isAttrUnlock = isResonanceUnlock and DataModel.RoleData.lv >= (attrCA.playerLevel or 1)
      local isAttrLevelMax = self:CheckResonanceAttributeMaxLevel(talentIndex, i)
      local isPreAttrUnlock = self:IsPreAttributeUnlock(talentIndex, i)
      attrGrid[i].Group_Tips:SetActive(isAttrUnlock and isPreAttrUnlock and not isAttrLevelMax)
      if isAttrUnlock and isPreAttrUnlock and not isAttrLevelMax then
        local isAttrItemEnough = self:CheckResonanceAttributeItemEnough(talentIndex, i)
        attrGrid[i].Group_Tips.Group_Unlock:SetActive(not isAttrItemEnough)
        attrGrid[i].Group_Tips.Group_Enough:SetActive(isAttrItemEnough)
        if 0 < attrLv and isAttrItemEnough then
          attrGrid[i].Group_Attribute.Img_Mask.Img_Icon:SetColor("#B5B5B5")
          attrGrid[i].Group_Attribute.Img_IconBg:SetColor("#B5B5B5")
        end
      end
    end
  end,
  RefreshFinalSkill = function(self)
    local group_SkillTree = View.Group_SkillTree
    local Group_FinalSkill = group_SkillTree.Group_FinalSkill
    local isFinalSkillUnlock = self:GetResonanceFinalSkillUnlock()
    if isFinalSkillUnlock then
      Group_FinalSkill.Group_Stage.Group_Talent.Img_Mask.Img_Icon:SetColor("#FFFFFF")
      Group_FinalSkill.Group_Stage.Group_Talent.Img_IconBg:SetColor("#FFFFFF")
    else
      Group_FinalSkill.Group_Stage.Group_Talent.Img_Mask.Img_Icon:SetColor("#4D4D4D")
      Group_FinalSkill.Group_Stage.Group_Talent.Img_IconBg:SetColor("#4D4D4D")
    end
    local skillCA = PlayerData:GetFactoryData(DataModel.RoleCA.finalSkill)
    if skillCA == nil then
      Group_FinalSkill.self:SetActive(false)
      return
    end
    Group_FinalSkill.self:SetActive(true)
    Group_FinalSkill.Group_Stage.Group_Talent.Img_Mask.Img_Icon:SetSprite(skillCA.iconPath)
  end,
  CheckResonanceItemEnough = function(self, index)
    local talentId = DataModel.RoleCA.awakeList[index].awakeId
    local talentCA = PlayerData:GetFactoryData(talentId)
    local materialList = talentCA.materialList
    for i = 1, #materialList do
      local itemId = materialList[i].itemId
      local needNum = materialList[i].num
      if not self.CheckItemEnough(itemId, needNum) then
        return false
      end
    end
    return true
  end,
  CheckResonanceSkillItemEnough = function(self, index)
    local talentId = DataModel.RoleCA.talentList[index].talentId
    local talentCA = PlayerData:GetFactoryData(talentId)
    local skillId = talentCA.skillIntensify
    local data = PlayerData:GetFactoryData(skillId)
    local level = self:GetResonanceSkillLevel(index)
    local nextLevel = math.min(level + 1, #data.attributeIntensify)
    local materialListCA = PlayerData:GetFactoryData(data.attributeIntensify[nextLevel].id)
    local items = {}
    for i = 1, #materialListCA.materialList do
      local itemId = materialListCA.materialList[i].id
      local needNum = materialListCA.materialList[i].num
      if not self.CheckItemEnough(itemId, needNum) then
        return false
      end
      items[itemId] = needNum
    end
    return true, items
  end,
  CheckResonanceAttributeItemEnough = function(self, index, attrIndex)
    local talentId = DataModel.RoleCA.talentList[index].talentId
    local talentCA = PlayerData:GetFactoryData(talentId)
    local listCA = PlayerData:GetFactoryData(talentCA.attributeIntensify[attrIndex].id)
    local level = self:GetResonanceAttributeLevel(index, attrIndex)
    local nextLevel = math.min(level + 1, #listCA.attributeGradeList)
    local skillId = listCA.attributeGradeList[nextLevel].id
    local data = PlayerData:GetFactoryData(skillId)
    local materialListCA = PlayerData:GetFactoryData(data.attributeIntensify[1].id)
    local items = {}
    if materialListCA.materialList ~= nil then
      for i = 1, #materialListCA.materialList do
        local itemId = materialListCA.materialList[i].id
        local needNum = materialListCA.materialList[i].num
        if not self.CheckItemEnough(itemId, needNum) then
          return false
        end
        items[itemId] = needNum
      end
    end
    return true, items
  end,
  CheckItemEnough = function(itemId, needNum)
    local haveNum = PlayerData:GetGoodsById(itemId).num
    return needNum <= haveNum
  end,
  CheckResonanceSkillMaxLevel = function(self, index)
    local talentId = DataModel.RoleCA.talentList[index].talentId
    local talentCA = PlayerData:GetFactoryData(talentId)
    local skillId = talentCA.skillIntensify
    local data = PlayerData:GetFactoryData(skillId)
    local level = self:GetResonanceSkillLevel(index)
    return level >= #data.attributeIntensify
  end,
  CheckResonanceAttributeMaxLevel = function(self, index, attrIndex)
    local talentId = DataModel.RoleCA.talentList[index].talentId
    local talentCA = PlayerData:GetFactoryData(talentId)
    local listCA = PlayerData:GetFactoryData(talentCA.attributeIntensify[attrIndex].id)
    local level = self:GetResonanceAttributeLevel(index, attrIndex)
    return level >= #listCA.attributeGradeList
  end,
  GetResonanceSkillLevel = function(self, index)
    return PlayerData:GetRoleResonanceSkillLevel(DataModel.RoleCA.id, index)
  end,
  GetResonanceAttributeLevel = function(self, index, attrIndex)
    return PlayerData:GetRoleResonanceAttributeLevel(DataModel.RoleCA.id, index, attrIndex)
  end,
  GetResonanceFinalSkillUnlock = function(self)
    return PlayerData:IsRoleFinalSkillUnlock(DataModel.RoleCA.id)
  end,
  IsPreAttributeUnlock = function(self, index, attrIndex)
    return attrIndex == 1 or self:GetResonanceAttributeLevel(index, attrIndex - 1) > 0
  end
}
return module
