local View = require("UIBuildLevel/UIBuildLevelView")
local DataModel = {
  constAutoBattleTime = 3,
  remainAutoBattleTime = 3,
  monsterLevelAutoBattle = false
}

function DataModel:Init()
  local group = View.Group_Title
  group.Img_Icon:SetSprite(self.BuildCA.levelIconPath)
  group.Txt_Name:SetText(GetText(self.BuildCA.buildLevelName))
  self:InitLevel()
  self:RefreshEnergy()
  self:RefreshActivityConstruction()
end

function DataModel:UpdateEnergy()
  if self.curFrame == nil then
    self.curFrame = 0
  end
  if self.curFrame >= 60 then
    self.curFrame = self.curFrame - 60
    self:RefreshEnergy()
  end
  self.curFrame = self.curFrame + 1
end

function DataModel:RefreshEnergy()
  if self.maxEnergy == nil then
    self.maxEnergy = PlayerData:GetUserInfo().max_energy
  end
  View.Group_Ding.Btn_Energy.Txt_Num:SetText(PlayerData:GetUserInfo().energy .. "/" .. self.maxEnergy)
end

function DataModel:InitLevel()
  local levelList = self.BuildCA.constructionLevelList
  local groupLevel = View.Group_Level
  local count = #levelList
  self.levelList = levelList
  for i = 1, count do
    self:InitLevelGroup(i)
  end
  for i = count + 1, 5 do
    groupLevel["Group_Level" .. i]:SetActive(false)
  end
  local groupDecorate = View.Group_Decorate
  for i = 1, 5 do
    if i == count then
      groupDecorate["Group_Decorate" .. i]:SetActive(true)
    else
      groupDecorate["Group_Decorate" .. i]:SetActive(false)
    end
  end
  if 0 < count then
    self:SelectLevel(math.min(self.initIndex, count), true)
  end
end

function DataModel:InitLevelGroup(index)
  local element = View.Group_Level["Group_Level" .. index]
  element:SetActive(true)
  element.Img_Select:SetActive(false)
  local levelData = self.levelList[index]
  local bossCA = PlayerData:GetFactoryData(levelData.bossId)
  element.Img_Type.Txt_Name:SetText(bossCA.name)
  element.Txt_NameEN:SetText(bossCA.EnglishName)
  local campCA = PlayerData:GetFactoryData(bossCA.sideId)
  element.Img_Icon.Img_Type:SetSprite(campCA.iconPath)
  element.Img_Type.Img_Icon:SetSprite(levelData.icon)
  local isUnlock = self:IsLevelUnlock(index)
  if isUnlock then
    element.Img_Icon:SetSprite(levelData.levelPng)
  else
    element.Img_Icon:SetSprite(levelData.levelPngLock)
  end
  element.self.transform.anchoredPosition = Vector2(levelData.levelX, levelData.levelY)
  element.Img_Complete:SetActive(PlayerData:GetLevelFirstRewardsReceived(levelData.id))
end

function DataModel:SelectLevel(index, isInit)
  local lastIndex = self.curLevelIndex
  if lastIndex ~= nil then
    View.Group_Level["Group_Level" .. lastIndex].Img_Select:SetActive(false)
  end
  View.Group_Level["Group_Level" .. index].Img_Select:SetActive(true)
  self.curLevelIndex = index
  if isInit ~= true then
    PlayerData.TempCache.MonsterLevelAutoBattle = false
    DataModel.remainAutoBattleTime = DataModel.constAutoBattleTime
  end
  local info = self.levelList[self.curLevelIndex]
  local levelId = info.id
  if PlayerData.TempCache.MonsterLevelAutoBattle == true and CommonTips.OpenBuyEnergyTips(levelId) then
    PlayerData.TempCache.MonsterLevelAutoBattle = false
    DataModel.remainAutoBattleTime = DataModel.constAutoBattleTime
  end
  local levelCA = PlayerData:GetFactoryData(levelId)
  local levelData = PlayerData.ServerData.chapter_level[tostring(levelId)]
  if levelCA.limitNum > 0 and levelData ~= nil and levelData.challenge_times ~= nil and levelData.challenge_times >= levelCA.limitNum then
    PlayerData.TempCache.MonsterLevelAutoBattle = false
    DataModel.remainAutoBattleTime = DataModel.constAutoBattleTime
  end
  DataModel.monsterLevelAutoBattle = PlayerData.TempCache.MonsterLevelAutoBattle
  View.Group_Right.Group_Auto.self:SetActive(true)
  View.Group_Right.Group_Auto.Btn_Auto.Group_Off.self:SetActive(not DataModel.monsterLevelAutoBattle)
  View.Group_Right.Group_Auto.Btn_Auto.Group_On.self:SetActive(DataModel.monsterLevelAutoBattle)
  View.Group_Right.Group_Auto.Txt_Time:SetActive(DataModel.monsterLevelAutoBattle)
  self:RefreshRemainTime()
  self:RefreshLevelDetail()
end

function DataModel:RefreshLevelDetail()
  local levelData = self.levelList[self.curLevelIndex]
  local bossCA = PlayerData:GetFactoryData(levelData.bossId)
  local levelCA = PlayerData:GetFactoryData(levelData.id)
  local group = View.Group_Right
  local sideCA = PlayerData:GetFactoryData(bossCA.sideId)
  if sideCA then
    group.Img_Icon:SetSprite(sideCA.iconPath)
  end
  local campCA = PlayerData:GetFactoryData(bossCA.enemyCamp)
  if campCA then
    group.Img_Type:SetSprite(campCA.iconPath)
    group.Txt_TypeName:SetText(campCA.sideName)
  end
  group.Txt_Name:SetText(bossCA.name)
  group.ScrollView_Describe.Viewport.Txt_Describe:SetText(bossCA.safeInformation)
  self.ChooseRewardList = {}
  local isReceived = PlayerData:GetLevelFirstRewardsReceived(levelData.id)
  local firstPassAward = levelCA.firstPassAward
  for i = 1, #firstPassAward do
    table.insert(DataModel.ChooseRewardList, {
      num = firstPassAward[i].num,
      id = firstPassAward[i].itemId,
      type = 1,
      isFinish = isReceived,
      index = #DataModel.ChooseRewardList
    })
  end
  local dropListNew = PlayerData:GetLevelDropList(levelCA)
  for i = 1, #dropListNew do
    table.insert(DataModel.ChooseRewardList, {
      num = dropListNew[i].num,
      id = dropListNew[i].id,
      type = 2,
      index = #DataModel.ChooseRewardList
    })
  end
  if isReceived == true then
    table.sort(DataModel.ChooseRewardList, function(a, b)
      if a.type == b.type then
        return a.index < b.index
      end
      return a.type > b.type
    end)
  else
    table.sort(DataModel.ChooseRewardList, function(a, b)
      if a.type == b.type then
        return a.index < b.index
      end
      return a.type < b.type
    end)
  end
  group.ScrollGrid_Reward.grid.self:SetDataCount(#DataModel.ChooseRewardList)
  group.ScrollGrid_Reward.grid.self:RefreshAllElement()
  group.ScrollGrid_Reward.grid.self:MoveToTop()
  local isLevelUnlock, isCstMet, isLevelMet = self:IsLevelUnlock(self.curLevelIndex)
  local levelServerData = PlayerData.ServerData.chapter_level[tostring(levelData.id)]
  local isChallengeCompleted = false
  if levelCA.limitNum > 0 and levelServerData ~= nil and levelServerData.challenge_times ~= nil and levelServerData.challenge_times >= levelCA.limitNum then
    isChallengeCompleted = true
  end
  group.Group_Fight.Group_Can:SetActive(isLevelUnlock and not isChallengeCompleted)
  group.Group_Fight.Group_Lock:SetActive(not isLevelUnlock)
  group.Group_Fight.Group_Complete:SetActive(isLevelUnlock and isChallengeCompleted)
  group.Group_Fight.Txt_Num:SetActive(isLevelUnlock and levelCA.limitNum > 0)
  if isLevelUnlock and levelCA.limitNum > 0 then
    local challengeNum = 0
    if levelServerData ~= nil then
      challengeNum = levelServerData.challenge_times or 0
    end
    local remainNum = levelCA.limitNum - challengeNum
    local formatStr
    if levelCA.limitBattleType == "Forever" then
      formatStr = GetText(80606936)
    elseif levelCA.limitBattleType == "Daily" then
      formatStr = GetText(80606937)
    elseif levelCA.limitBattleType == "Weekly" then
      formatStr = GetText(80606938)
    elseif levelCA.limitBattleType == "Monthly" then
      formatStr = GetText(80606939)
    end
    group.Group_Fight.Txt_Num:SetText(string.format(formatStr, remainNum))
  end
  if not isLevelUnlock then
    if not isLevelMet then
      local conditionId = levelData.conditionId
      local condLevelCA = PlayerData:GetFactoryData(conditionId)
      group.Group_Fight.Group_Lock.Txt_Lock:SetText(string.format(GetText(80606909), condLevelCA.levelName))
    elseif not isCstMet then
      local curNum = levelData.allConstruction
      local activeCA = PlayerData:GetFactoryData(self.BuildCA.correspondingActivity)
      local prog = math.floor(100 * curNum / activeCA.constructionLimit)
      group.Group_Fight.Group_Lock.Txt_Lock:SetText(string.format(GetText(80606908), activeCA.name, prog))
    end
  end
  group.Group_Fight.Img_Cost.Txt_Cost:SetText(levelCA.energyEnd)
  if levelCA.isEnemyLvEquilsPlayer then
    group.Txt_Grade:SetText(string.format(GetText(80601531), PlayerData:GetUserInfo().lv))
  else
    group.Txt_Grade:SetText(string.format(GetText(80601531), levelCA.recomGrade))
  end
end

function DataModel:IsLevelUnlock(index)
  local levelData = self.levelList[index]
  local curNum = PlayerData:GetActivityServerConstructionCstNum(self.BuildCA.correspondingActivity)
  local cstNumEnough = curNum >= levelData.allConstruction
  local conditionId = levelData.conditionId
  local isCondMet = conditionId == nil or conditionId <= 0 or PlayerData:GetLevelFirstRewardsReceived(conditionId)
  if cstNumEnough and isCondMet then
    return true
  else
    return false, cstNumEnough, isCondMet
  end
end

function DataModel:TryBattle(isAutoBattle)
  if not self:IsLevelUnlock(self.curLevelIndex) then
    return
  end
  local info = self.levelList[self.curLevelIndex]
  local levelId = info.id
  local levelCA = PlayerData:GetFactoryData(levelId)
  local levelData = PlayerData.ServerData.chapter_level[tostring(levelId)]
  local isChallengeCompleted = false
  if levelCA.limitNum > 0 and levelData ~= nil and levelData.challenge_times ~= nil and levelData.challenge_times >= levelCA.limitNum then
    isChallengeCompleted = true
  end
  if isChallengeCompleted then
    return
  end
  
  local function detailDo()
    if CommonTips.OpenBuyEnergyTips(levelId) then
      return
    end
    local status = {
      Current = "Chapter",
      squadIndex = PlayerData.BattleInfo.squadIndex,
      hasOpenThreeView = false
    }
    local t = {}
    t.IsActivityMainIn = DataModel.IsActivityMainIn
    t.IsCityMapIn = DataModel.IsCityMapIn
    t.buildingId = DataModel.BuildCA.id
    t.initIndex = self.curLevelIndex
    status.extraUIParamData = t
    status.isAutoBattle = isAutoBattle
    PlayerData.BattleInfo.battleStageId = levelId
    PlayerData.BattleCallBackPage = "UI/BuildLevel/BuildLevel"
    UIManager:Open("UI/Squads/Squads", Json.encode(status))
  end
  
  if not isAutoBattle and not levelCA.isEnemyLvEquilsPlayer and levelCA.recomGrade - PlayerData:GetPlayerLevel() >= 5 then
    local checkTipParam = {}
    checkTipParam.isCheckTip = true
    checkTipParam.checkTipKey = "ActiveBuildLevelTip"
    checkTipParam.checkTipType = 1
    checkTipParam.showSafe = true
    CommonTips.OnPrompt(80601227, nil, nil, detailDo, nil, nil, nil, nil, checkTipParam)
  else
    detailDo()
  end
end

function DataModel:OnClickBtnAuto()
  if not self:IsLevelUnlock(self.curLevelIndex) then
    return
  end
  local info = self.levelList[self.curLevelIndex]
  local levelId = info.id
  if not PlayerData:GetLevelPass(levelId) then
    CommonTips.OpenTips(80607473)
    return
  end
  local levelCA = PlayerData:GetFactoryData(levelId)
  local levelData = PlayerData.ServerData.chapter_level[tostring(levelId)]
  if levelCA.limitNum > 0 and levelData ~= nil and levelData.challenge_times ~= nil and levelData.challenge_times >= levelCA.limitNum then
    CommonTips.OpenTips(80607474)
    return
  end
  if not PlayerData.TempCache.MonsterLevelAutoBattle and CommonTips.OpenBuyEnergyTips(levelId, nil, nil, nil, nil, true) then
    CommonTips.OpenTips(80607116)
    return
  end
  PlayerData.TempCache.MonsterLevelAutoBattle = not PlayerData.TempCache.MonsterLevelAutoBattle
  DataModel.monsterLevelAutoBattle = PlayerData.TempCache.MonsterLevelAutoBattle
  View.Group_Right.Group_Auto.Btn_Auto.Group_Off.self:SetActive(not DataModel.monsterLevelAutoBattle)
  View.Group_Right.Group_Auto.Btn_Auto.Group_On.self:SetActive(DataModel.monsterLevelAutoBattle)
  View.Group_Right.Group_Auto.Txt_Time:SetActive(DataModel.monsterLevelAutoBattle)
  self:RefreshRemainTime()
end

function DataModel:RefreshRemainTime()
  if DataModel.remainAutoBattleTime <= 0 then
    DataModel.monsterLevelAutoBattle = false
    DataModel.remainAutoBattleTime = DataModel.constAutoBattleTime
    PlayerData.SquadsTempData = nil
    self:TryBattle(true)
    return
  end
  View.Group_Right.Group_Auto.Txt_Time:SetText(string.format(GetText(80607112), math.ceil(DataModel.remainAutoBattleTime)))
end

function DataModel:RefreshActivityConstruction()
  local group = View.Group_Construction
  group.self:SetActive(true)
  local ServerConstructionDataModel = require("UIServerConstruction/UIServerConstructionDataModel")
  local redPointAll = ServerConstructionDataModel:GetRedPointState("all", self.BuildCA.correspondingActivity)
  local redPointOne = ServerConstructionDataModel:GetRedPointState("one", self.BuildCA.correspondingActivity)
  local CardPackDataModel = require("UICardPack_Open/UICardPack_OpenDataModel")
  local activeCA = PlayerData:GetFactoryData(self.BuildCA.correspondingActivity)
  local cardPackInfo = CardPackDataModel.GetCardPackInfo(activeCA.activityCardPack)
  group.Img_RedPoint:SetActive(redPointAll or redPointOne or cardPackInfo and cardPackInfo.extraCardStatus == 1)
  local curNum = PlayerData:GetActivityServerConstructionCstNum(self.BuildCA.correspondingActivity)
  local prog = math.min(curNum / activeCA.constructionLimit, 1)
  group.Txt_Num:SetText(string.format(GetText(80606881), math.floor(prog * 100)))
  group.Group_All.Img_Progress:SetFilledImgAmount(prog)
  curNum = PlayerData:GetActivityPersonalConstructionCstNum(self.BuildCA.correspondingActivity)
  local personlist = activeCA.personalConstructionList
  if personlist and 0 < #personlist then
    prog = math.min(curNum / personlist[#personlist].construction, 1)
  else
    prog = 1
  end
  group.Txt_PersonalNum:SetText(string.format(GetText(80606881), math.floor(prog * 100)))
  group.Group_Personal.Img_Progress:SetFilledImgAmount(prog)
end

function DataModel:OpenActivityPanel()
  local activityId = self.BuildCA.correspondingActivity
  local ActivityMainDataModel = require("UIActivityMain/UIActivityMainDataModel")
  local activeList = ActivityMainDataModel:GetActivityCAList()
  for k, v in ipairs(activeList) do
    if v.id == activityId then
      UIManager:Open("UI/Activity/ActivityMain", Json.encode({index = k, id = activityId}))
      break
    end
  end
end

return DataModel
