local View = require("UITestLevelDetail/UITestLevelDetailView")
local DataModel = require("UITestLevelDetail/UITestLevelDetailDataModel")
local Controller = {}
local BattleControlManager, currentRoleIndex, LevelManager

function Controller.OpenRoleCardList(hasOpen)
  View.Group_CharacterCard:SetActive(hasOpen)
end

function Controller.InitView(data)
  DataModel.cardList = {}
  DataModel.roles = {}
  local expConfig = PlayerData:GetFactoryData(99900003, "ConfigFactory").expList
  local duration
  if data.roles ~= nil and #data.roles > 0 then
    local index = 1
    for i = 1, #data.roles do
      local temp = Controller.GetRoleTempByData(data.roles[i], expConfig, data)
      DataModel.roles[index] = temp
      index = index + 1
    end
    duration = data.duration
  else
    BattleControlManager = CBus:GetManager(CS.ManagerName.BattleControlManager)
    BattleControlManager:Pause(true)
    local info
    LevelManager = CBus:GetManager(CS.ManagerName.LevelManager)
    if LevelManager.IsGameOver then
      info = PlayerData.BattleInfo.BattleResult
    else
      info = BattleControlManager.currentPlayerTeamData.battleData.BattleResult
    end
    if info ~= nil then
      local index = 1
      local temp = {}
      for key, value in pairs(info.cardOrder) do
        temp[index] = Controller.GetCardTemp(value)
        index = index + 1
      end
      DataModel.cardList = temp
      index = 1
      for key, value in pairs(info.roleInfoList) do
        temp = Controller.GetRoleTemp(key, value, expConfig, info)
        DataModel.roles[index] = temp
        index = index + 1
      end
      data.healTotal = info.healTotal
      data.getHitTotal = info.getHitTotal
      duration = (BattleControlManager:GetBattleFrame() - data.duration) / GameSetting.fps
    end
  end
  local hours = math.floor(duration / 3600)
  local minutes = math.floor(duration % 3600 / 60)
  local remainingSeconds = math.floor(duration % 60)
  data.duration = string.format("%02d:%02d:%02d", hours, minutes, remainingSeconds)
  if DataModel.cardList ~= nil then
    View.Group_Card.ScrollGrid_Card.grid.self:SetDataCount(#DataModel.cardList)
    View.Group_Card.ScrollGrid_Card.grid.self:RefreshAllElement()
  end
  if DataModel.roles ~= nil then
    View.Group_Character.StaticGrid_Character.grid.self:SetDataCount(#DataModel.roles)
    View.Group_Character.StaticGrid_Character.grid.self:RefreshAllElement()
  end
  Controller.OpenRoleCardList(false)
  local group = View.Group_Statistics
  group.Txt_TotalTimeNum:SetText(data.duration)
  group.Txt_SkillTotalNum:SetText(PlayerData:NumToFormatString(data.skillDamageNow, 2))
  group.Txt_SkillDamageNum:SetText(PlayerData:NumToFormatString(data.skillDamageMax, 2))
  group.Txt_10sDamageNum:SetText(PlayerData:NumToFormatString(data.damageTotalAt10s, 2))
  group.Txt_UseCardNum:SetText(data.usedCards)
  group.Txt_CostNum:SetText(data.usedCost)
  local groupCharacter = View.Group_Character
  groupCharacter.Txt_TotalNum:SetText(PlayerData:NumToFormatString(data.damageTotal, 2))
  groupCharacter.Txt_TotalHealNum:SetText(PlayerData:NumToFormatString(data.healTotal, 2))
  groupCharacter.Txt_TotalHitNum:SetText(PlayerData:NumToFormatString(data.getHitTotal, 2))
  DataModel.curLevelId = data.levelId
  if DataModel.curLevelId == nil then
    DataModel.curLevelId = PlayerData.BattleInfo.battleStageId
  end
  Controller.UpdateBossName()
end

function Controller.UpdateBossName()
  if View.Img_BGTitleBack.Group_Title.Txt_Name == nil then
    return
  end
  local isShow = false
  local serverCA = PlayerData:GetFactoryData(99900053)
  if GameSetting.currentTextLanguage == "zh" and serverCA and serverCA.bossNameUI then
    isShow = true
  end
  View.Img_BGTitleBack.Group_Title.Txt_Name:SetActive(isShow)
  if isShow then
    local levelCA = PlayerData:GetFactoryData(DataModel.curLevelId)
    if levelCA ~= nil and levelCA.bossName ~= nil then
      View.Img_BGTitleBack.Group_Title.Txt_Name:SetText(levelCA.bossName)
    end
  end
end

local function SetCardInfo(view, data)
  view.Img_MaskCharacter.Img_Character:SetSprite(data.roleResPath)
  view.Img_CardType:SetSprite(data.cardTypePath)
  view.Group_SkillIcon.Img_MaskSkill.Img_Skill:SetSprite(data.iconPath)
  local isDouble = data.cost1Path ~= ""
  local cost1 = view.Group_Cost.Img_Cost1
  cost1:SetActive(isDouble)
  local x1 = data.x1
  local x2 = data.x2
  if isDouble then
    local width = data.width2 + data.width1 + DataManager.battleConfig.cardCostNormalCA.interval
    x1 = data.width1 / 2 - width / 2
    x2 = width / 2 - data.width1 / 2
    cost1:SetSprite(data.cost1Path)
    cost1:SetLocalPosition(Vector3(x1, 0, 0))
    cost1:SetWidthHeight(data.width1, data.height1)
  end
  local cost2 = view.Group_Cost.Img_Cost2
  cost2:SetSprite(data.cost2Path)
  cost2:SetLocalPosition(Vector3(x2, 0, 0))
  cost2:SetWidthHeight(data.width2, data.height2)
  view.Img_NoCostSign:SetActive(false)
  view.Img_LeaderCardSign:SetActive(false)
end

function Controller.GetCardTemp(cardData)
  local roleResPath = cardData.roleResPath
  if roleResPath == nil or cardData.roleResPath == "" then
    local ownerId = cardData.ownerId
    local curRole = PlayerData.ServerData.roles[tostring(ownerId)]
    if curRole and curRole.current_skin then
      roleResPath = PlayerData:GetFactoryData(curRole.current_skin[1]).roleListResUrl
    else
      local viewId = PlayerData:GetFactoryData(ownerId).viewId
      local viewCA = PlayerData:GetFactoryData(viewId)
      if viewCA ~= nil and viewCA.roleListResUrl ~= nil and viewCA.roleListResUrl ~= "" then
        roleResPath = PlayerData:GetFactoryData(viewId).roleListResUrl
      else
        roleResPath = PlayerData:GetFactoryData(99900008, "ConfigFactory").teamCardPath
      end
    end
  end
  return {
    cardTypePath = cardData.cardTypePath,
    cost1Path = cardData.cost1Path,
    cost2Path = cardData.cost2Path,
    hasLeaderCardSign = cardData.hasLeaderCardSign,
    hasNoCostSign = cardData.hasNoCostSign,
    height1 = cardData.height1,
    height2 = cardData.height2,
    iconPath = cardData.iconPath,
    roleResPath = roleResPath,
    width1 = cardData.width1,
    width2 = cardData.width2,
    x1 = cardData.x1,
    x2 = cardData.x2
  }
end

function Controller.GetRoleTempByData(temp, expConfig, info)
  local roleCA = PlayerData:GetFactoryData(temp.id)
  temp.name = roleCA.name
  temp.face = PlayerData:GetFactoryData(temp.face).face
  temp.expValue = temp.exp / expConfig[temp.lv].levelUpExp
  if info.damageTotal > 0 then
    temp.damagePercent = temp.damage / info.damageTotal
  else
    temp.damagePercent = 0
  end
  if 0 < info.healTotal then
    temp.healPercent = temp.heal / info.healTotal
  else
    temp.healPercent = 0
  end
  if 0 < info.getHitTotal then
    temp.getHitPercent = temp.getHit / info.getHitTotal
  else
    temp.getHitPercent = 0
  end
  temp.cardList = {}
  return temp
end

function Controller.GetRoleTemp(key, value, expConfig, info, isSkinId)
  local temp = {}
  temp.name = value.name
  local skinId = PlayerData:GetFactoryData(key).viewId
  if table.count(PlayerData:GetRoleById(key)) > 0 then
    skinId = PlayerData:GetRoleById(key).current_skin[1]
  end
  temp.face = isSkinId == true and tonumber(skinId) or PlayerData:GetFactoryData(skinId).face
  local roleId = tostring(key)
  local role = PlayerData.ServerData.roles[roleId] == nil and PlayerData:GetFactoryData(roleId) or PlayerData.ServerData.roles[roleId]
  temp.lv = role.lv or 1
  role.exp = role.exp or 0
  if expConfig ~= nil then
    temp.expValue = role.exp / expConfig[temp.lv].levelUpExp
  else
    temp.exp = role.exp
  end
  temp.damage = value.damage
  temp.heal = value.heal
  temp.getHit = value.getHit
  if info ~= nil then
    if 0 < info.damageTotal then
      temp.damagePercent = value.damage / info.damageTotal
    else
      temp.damagePercent = 0
    end
    if 0 < info.healTotal then
      temp.healPercent = value.heal / info.healTotal
    else
      temp.healPercent = 0
    end
    if 0 < info.getHitTotal then
      temp.getHitPercent = value.getHit / info.getHitTotal
    else
      temp.getHitPercent = 0
    end
  end
  local count = 1
  temp.cardList = {}
  for key1, value1 in pairs(value.cardOrder) do
    temp.cardList[count] = Controller.GetCardTemp(value1)
    count = count + 1
  end
  return temp
end

function Controller.SetElement(element, elementIndex)
  SetCardInfo(element, DataModel.cardList[elementIndex])
end

function Controller.SetRolesElement(element, elementIndex)
  local data = DataModel.roles[elementIndex]
  element.Img_Mask.Img_Face:SetSprite(data.face)
  element.Img_Exp.Img_Now:SetFilledImgAmount(data.expValue)
  element.Group_Lv.Txt_Num:SetText(data.lv)
  element.Img_Damage.Txt_Num:SetText(PlayerData:NumToFormatString(data.damage, 2))
  element.Img_Damage.Txt_Percent:SetText(math.floor(data.damagePercent * 100 + 0.5) .. "%")
  element.Img_Damage.Img_Now:SetFilledImgAmount(data.damagePercent)
  element.Img_Heal.Txt_Num:SetText(PlayerData:NumToFormatString(data.heal, 2))
  element.Img_Heal.Txt_Percent:SetText(math.floor(data.healPercent * 100 + 0.5) .. "%")
  element.Img_Heal.Img_Now:SetFilledImgAmount(data.healPercent)
  element.Img_Hit.Txt_Num:SetText(PlayerData:NumToFormatString(data.getHit, 2))
  element.Img_Hit.Txt_Percent:SetText(math.floor(data.getHitPercent * 100 + 0.5) .. "%")
  element.Img_Hit.Img_Now:SetFilledImgAmount(data.getHitPercent)
  element.Txt_Name:SetText(data.name)
end

function Controller.OnClickRole(index)
  currentRoleIndex = index
  Controller.OpenRoleCardList(true)
  View.Group_CharacterCard.ScrollGrid_Card.grid.self:SetDataCount(#DataModel.roles[index].cardList)
  View.Group_CharacterCard.ScrollGrid_Card.grid.self:RefreshAllElement()
end

function Controller.SetRoleCardElement(element, elementIndex)
  SetCardInfo(element, DataModel.roles[currentRoleIndex].cardList[elementIndex])
end

function Controller.Destroy()
  if BattleControlManager == nil then
    return
  end
  BattleControlManager:Pause(false)
  BattleControlManager = nil
end

return Controller
