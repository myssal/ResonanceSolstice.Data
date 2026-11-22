local View = require("UIMonsterLevel/UIMonsterLevelView")
local DataModel = require("UIMonsterLevel/UIMonsterLevelDataModel")
local BtnItem = require("Common/BtnItem")
local Controller = {}

function Controller:Init()
  DataModel.Init()
  View.Btn_Store.Txt_Num:SetText(PlayerData:GetGoodsById(11400112).num)
  if DataModel.curPos > 0 then
    local isDeep = DataModel.curPos == 2
    local cacheLevelIdx = DataModel.curLevelIdx
    Controller:SwitchDeep(isDeep)
    if 0 < cacheLevelIdx then
      if not PlayerData.TempCache.MonsterLevelPassedCache then
        PlayerData.TempCache.MonsterLevelPassedCache = true
        local levelId = DataModel.levelInfo[DataModel.curPos].levelList[DataModel.curLevelIdx]
        local levelPass = PlayerData:GetLevelPass(levelId)
        if levelPass then
          if LoadingManager.isLoading then
            DataModel.toPlayFirstPassAnim = true
          else
            Controller:DoFirstPassAnim()
          end
          return
        end
      end
      Controller:ClickLevelBtn(cacheLevelIdx, true)
    end
  else
    local isDeep = 0 >= DataModel.deepRemainTime
    local pos = PlayerData:GetPlayerPrefs("int", "MonsterLevelPos")
    if 0 < pos then
      isDeep = pos == 2
    end
    Controller:SwitchDeep(isDeep)
  end
end

function Controller:SwitchDeep(isDeep)
  View.Group_ShiftBtn.Btn_In:SetActive(isDeep)
  View.Group_ShiftBtn.Btn_Out:SetActive(not isDeep)
  View.Group_BG.Group_1:SetActive(not isDeep)
  View.Group_BG.Group_2:SetActive(isDeep)
  if isDeep then
    Controller:RefreshLevelDeep()
  else
    Controller:RefreshLevel()
  end
end

function Controller:RefreshLevel()
  DataModel.waitToShowComplete = false
  View.self:PlayAnimOnce("MonsterLevel_01", function()
    DataModel.waitToShowComplete = true
  end)
  DataModel.curPos = 1
  local isDeepOpened = DataModel.deepRemainTime <= 0
  View.Group_ShiftBtn.Btn_Out.Group_Locked:SetActive(not isDeepOpened)
  View.Group_ShiftBtn.Btn_Out.Group_Unlock:SetActive(isDeepOpened)
  if not isDeepOpened then
    local t = TimeUtil:SecondToTable(DataModel.deepRemainTime)
    if 0 < t.day then
      View.Group_ShiftBtn.Btn_Out.Group_Locked.Txt_Time:SetText(string.format(GetText(80607115), t.day, t.hour + 1))
    else
      View.Group_ShiftBtn.Btn_Out.Group_Locked.Txt_Time:SetText(string.format(GetText(80607114), t.hour, t.minute + 1))
    end
  end
  Controller:RefreshLevelListShow()
end

function Controller:RefreshLevelDeep()
  DataModel.waitToShowComplete = false
  View.self:PlayAnimOnce("MonsterLevel_02", function()
    DataModel.waitToShowComplete = true
  end)
  DataModel.curPos = 2
  Controller:RefreshLevelListShow()
end

function Controller:RefreshLevelListShow()
  local levelList = DataModel.levelInfo[DataModel.curPos].levelList
  local parentElement = View.Group_BG["Group_" .. DataModel.curPos]
  local firstUnlock = false
  for i, id in ipairs(levelList) do
    local element = parentElement["Group_Level" .. i]
    if element then
      local isUnlock = false
      if 1 < i then
        isUnlock = firstUnlock
      else
        isUnlock = true
      end
      element:SetActive(isUnlock)
      firstUnlock = PlayerData:GetLevelPass(id)
      if i == DataModel.curLevelIdx then
        parentElement.Group_Fog["Img_" .. i]:SetActive(not firstUnlock or not PlayerData.TempCache.MonsterLevelPassedCache)
      else
        parentElement.Group_Fog["Img_" .. i]:SetActive(not firstUnlock)
      end
      if isUnlock then
        element.Group_First:SetActive(not firstUnlock)
        element.Group_Select:SetActive(false)
        local levelCA = PlayerData:GetFactoryData(id)
        element.Btn_Level.Txt_LevelName:SetText(levelCA.levelName)
        element.Btn_Level:SetClickParam(i)
        if i ~= DataModel.curLevelIdx + 1 or not not PlayerData.TempCache.MonsterLevelPassedCache then
          element:SetEnableAnimator(false)
          element:SetAlpha(1)
        end
      end
    end
  end
end

function Controller:BtnOutClick()
  if DataModel.deepRemainTime > 0 then
    return
  end
  Controller:SwitchDeep(true)
end

function Controller:BtnInClick()
  Controller:SwitchDeep(false)
end

function Controller:ClickLevelBtn(str, force)
  local idx = tonumber(str)
  if not force and DataModel.curLevelIdx == idx then
    return
  end
  if not force then
    PlayerData.TempCache.MonsterLevelAutoBattle = false
  end
  DataModel.preLevelIdx = DataModel.curLevelIdx
  DataModel.curLevelIdx = idx
  local parentElement
  if DataModel.curPos == 1 then
    parentElement = View.Group_BG.Group_1
  else
    parentElement = View.Group_BG.Group_2
  end
  if DataModel.preLevelIdx > 0 then
    local preLevelElement = parentElement["Group_Level" .. DataModel.preLevelIdx]
    if preLevelElement then
      preLevelElement.Group_Select:SetActive(false)
    end
  end
  local curLevelElement = parentElement["Group_Level" .. idx]
  if curLevelElement then
    curLevelElement.Group_Select:SetActive(true)
    curLevelElement.transform:SetAsLastSibling()
  end
  Controller:ShowLevelDetail(idx)
end

function Controller:CancelLevelClick()
  if DataModel.curPos > 0 and 0 < DataModel.curLevelIdx then
    local levelElement = View.Group_BG["Group_" .. DataModel.curPos]["Group_Level" .. DataModel.curLevelIdx]
    levelElement.Group_Select:SetActive(false)
  end
  DataModel.curLevelIdx = 0
  PlayerData.TempCache.MonsterLevelAutoBattle = false
  DataModel.monsterLevelAutoBattle = false
  View.Group_LevelDetails:SetActive(false)
  if View.Group_SpLevelDetails ~= nil then
    View.Group_SpLevelDetails:SetActive(false)
  end
end

function Controller:ShowLevelDetail(idx, isRefresh)
  local levelId = DataModel.levelInfo[DataModel.curPos].levelList[idx]
  local levelCA = PlayerData:GetFactoryData(levelId)
  local levelGroup = View.Group_LevelDetails
  local diff = 0
  local hideLockDiff = false
  if levelCA.isAutoDifficulty then
    local levelData = PlayerData.ServerData.chapter_level[tostring(levelId)] or {}
    local maxDiff = levelCA.autoDifficultyMax or 1
    if not DataModel.isLockDiff then
      diff = math.min(levelData.auto_diff or 0, maxDiff - 1)
    else
      diff = math.max((levelData.auto_diff or 1) - 1, 0)
    end
    if maxDiff <= (levelData.auto_diff or 0) then
      hideLockDiff = true
    end
    if View.Group_SpLevelDetails ~= nil then
      levelGroup:SetActive(false)
      levelGroup = View.Group_SpLevelDetails
      levelGroup.Img_DifficultyMax:SetActive(maxDiff <= diff + 1)
      levelGroup.Group_Diff.Txt_:SetText(string.format(GetText(80609196), diff + 1, maxDiff))
    end
  end
  if isRefresh ~= true then
    if hideLockDiff then
      Controller:LockDiffClick(false, true)
      if levelGroup.Group_Lock ~= nil then
        levelGroup.Group_Lock.Btn_Lock.self:SetActive(false)
        levelGroup.Group_Lock.Txt_On:SetActive(false)
        levelGroup.Group_Lock.Txt_Off:SetActive(false)
      end
    else
      local initLock = PlayerData:GetPlayerPrefs("int", "MonsterSpLevelLock") ~= 1
      Controller:LockDiffClick(initLock, true)
    end
  elseif hideLockDiff then
    Controller:LockDiffClick(false, true)
    if levelGroup.Group_Lock ~= nil then
      levelGroup.Group_Lock.Btn_Lock.self:SetActive(false)
      levelGroup.Group_Lock.Txt_On:SetActive(false)
      levelGroup.Group_Lock.Txt_Off:SetActive(false)
    end
  end
  levelGroup:SetActive(true)
  levelGroup.Txt_LevelName:SetText(levelCA.levelName)
  local lv = PlayerData:GetPlayerLevel()
  if not levelCA.isEnemyLvEquilsPlayer then
    lv = levelCA.recomGrade + diff * levelCA.extraLevelOffset
  end
  levelGroup.Txt_Grade:SetText(string.format(GetText(80607113), lv))
  levelGroup.ScrollView_Describe.Viewport.Txt_Describe:SetText(levelCA.description)
  DataModel.InitRewardList(levelId)
  levelGroup.ScrollGrid_Reward.grid.self:SetDataCount(#DataModel.ChooseRewardList)
  levelGroup.ScrollGrid_Reward.grid.self:RefreshAllElement()
  Controller:RefreshEnergy()
  local energy = levelCA.energyEnd + diff * levelCA.extraEnergy
  if levelGroup.Group_Skip then
    local isPass = PlayerData:GetLevelPassBySelf(levelId)
    levelGroup.Btn_Fight.self:SetActive(not isPass)
    levelGroup.Group_Skip.self:SetActive(isPass)
    levelGroup.Group_Skip.Btn_Fight.Group_Cost.Txt_Num:SetText("-" .. energy)
    levelGroup.Group_Skip.Btn_Skip.Group_Cost.Txt_Num:SetText("-" .. energy)
  end
  levelGroup.Btn_Fight.Img_Cost.Txt_Cost:SetText(energy)
  DataModel.monsterLevelAutoBattle = PlayerData.TempCache.MonsterLevelAutoBattle
  if DataModel.monsterLevelAutoBattle and CommonTips.OpenBuyEnergyTips(levelId, nil, nil, nil, nil, true) then
    PlayerData.TempCache.MonsterLevelAutoBattle = false
    DataModel.monsterLevelAutoBattle = false
  end
  if levelGroup.Group_Auto ~= nil then
    levelGroup.Group_Auto.Btn_Auto.Group_On:SetActive(DataModel.monsterLevelAutoBattle)
    levelGroup.Group_Auto.Btn_Auto.Group_Off:SetActive(not DataModel.monsterLevelAutoBattle)
    levelGroup.Group_Auto.Txt_Time:SetActive(DataModel.monsterLevelAutoBattle)
  end
  if DataModel.monsterLevelAutoBattle then
    Controller:RefreshAutoBattleRemainTime()
  end
end

function Controller:CheckRoleList(squadIdx, isShowTip)
  local curRoleList = PlayerData.ServerData.squad[squadIdx].role_list
  if #curRoleList <= 0 then
    for i = 1, 12 do
      if i ~= squadIdx and #PlayerData.ServerData.squad[i].role_list > 0 then
        curRoleList = PlayerData.ServerData.squad[i].role_list
        squadIdx = i
        break
      end
    end
  end
  if #curRoleList <= 0 then
    if isShowTip then
      CommonTips.OpenTips(80607162)
    end
    return -1
  end
  return squadIdx
end

function Controller:RefreshAutoBattleRemainTime()
  if DataModel.remainAutoBattleTime <= 0 then
    DataModel.monsterLevelAutoBattle = false
    DataModel.remainAutoBattleTime = DataModel.constAutoBattleTime
    PlayerData.SquadsTempData = nil
    local levelId = DataModel.levelInfo[DataModel.curPos].levelList[DataModel.curLevelIdx]
    local status = {
      Current = "Chapter",
      squadIndex = DataModel.GetCurSquadIdx(),
      hasOpenThreeView = false
    }
    local t = {}
    t.curPos = DataModel.curPos
    t.curLevelIdx = DataModel.curLevelIdx
    t.isBattleReturn = true
    status.extraUIParamData = t
    status.isAutoBattle = true
    PlayerData.BattleInfo.battleStageId = levelId
    PlayerData.BattleCallBackPage = "UI/Activity/Monster/MonsterLevel"
    UIManager:Open("UI/Squads/Squads", Json.encode(status))
    return
  end
  View.Group_LevelDetails.Group_Auto.Txt_Time:SetText(string.format(GetText(80607112), math.ceil(DataModel.remainAutoBattleTime)))
end

function Controller:RefreshRewardElement(element, elementIndex)
  local info = DataModel.ChooseRewardList[elementIndex]
  BtnItem:SetItem(element.Group_Item, {
    id = info.id,
    num = info.num
  })
  element.Group_Item.Btn_Item:SetClickParam(info.id)
  element.Group_First:SetActive(info.type == 1 and not info.isFinish)
  element.Group_Allready:SetActive(info.type == 1 and info.isFinish)
end

function Controller:ClickRewardItem(str)
  local itemId = tonumber(str)
  CommonTips.OpenPreRewardDetailTips(itemId)
end

function Controller:RefreshEnergy()
  local user_info = PlayerData:GetUserInfo()
  local initConfig = PlayerData:GetFactoryData(99900007, "ConfigFactory")
  local maxEnergy = user_info.max_energy or initConfig.energyMax
  local currEnergy = user_info.energy or 0
  View.Group_LevelDetails.Group_Ding.Btn_Energy.Txt_Num:SetText(currEnergy .. "/" .. maxEnergy)
  if View.Group_SpLevelDetails ~= nil then
    View.Group_SpLevelDetails.Group_Ding.Btn_Energy.Txt_Num:SetText(currEnergy .. "/" .. maxEnergy)
  end
end

function Controller:ClickEnergy()
  PlayerData.TempCache.MonsterLevelAutoBattle = false
  UIManager:Open("UI/Energy/Energy", nil, function()
    Controller:RefreshEnergy()
  end)
end

function Controller:ClickSkipWin()
  local levelId = DataModel.levelInfo[DataModel.curPos].levelList[DataModel.curLevelIdx]
  local levelCA = PlayerData:GetFactoryData(levelId, "LevelFactory")
  local res = CommonTips.OpenBuyEnergyTips(levelId, function()
    Controller:RefreshEnergy()
  end)
  if res then
    return
  end
  if DataModel.monsterLevelAutoBattle == true then
    PlayerData.TempCache.MonsterLevelAutoBattle = false
    DataModel.monsterLevelAutoBattle = false
    View.Group_LevelDetails.Group_Auto.Btn_Auto.Group_On:SetActive(DataModel.monsterLevelAutoBattle)
    View.Group_LevelDetails.Group_Auto.Btn_Auto.Group_Off:SetActive(not DataModel.monsterLevelAutoBattle)
    View.Group_LevelDetails.Group_Auto.Txt_Time:SetActive(DataModel.monsterLevelAutoBattle)
  end
  
  local function doSquad()
    local curDiff = 1
    local isAutoDiff = levelCA.isAutoDifficulty
    if isAutoDiff then
      local levelData = PlayerData.ServerData.chapter_level[tostring(levelId)] or {}
      if not DataModel.isLockDiff then
        curDiff = curDiff + math.min(levelData.auto_diff or 0, (levelCA.autoDifficultyMax or 1) - 1)
      else
        curDiff = math.max(levelData.auto_diff or 1, 1)
      end
    end
    local status = {
      Current = "Chapter",
      squadIndex = PlayerData.BattleInfo.squadIndex,
      hasOpenThreeView = false,
      difficulty = curDiff,
      isLockDiff = DataModel.isLockDiff
    }
    local t = {}
    t.curPos = DataModel.curPos
    t.curLevelIdx = DataModel.curLevelIdx
    t.isBattleReturn = true
    status.extraUIParamData = t
    PlayerData.BattleInfo.battleStageId = levelId
    PlayerData.BattleCallBackPage = "UI/Activity/Monster/MonsterLevel"
    PlayerData.TempCache.MonsterLevelPassedCache = PlayerData:GetLevelPass(levelId)
    UIManager:Open("UI/Common/BattleSkipTips", Json.encode(status))
  end
  
  doSquad()
end

function Controller:StartBattle()
  local levelId = DataModel.levelInfo[DataModel.curPos].levelList[DataModel.curLevelIdx]
  local levelCA = PlayerData:GetFactoryData(levelId, "LevelFactory")
  
  local function detailDo()
    local res = CommonTips.OpenBuyEnergyTips(levelId, function()
      Controller:RefreshEnergy()
    end)
    if res then
      return
    end
    local curDiff = 1
    local isAutoDiff = levelCA.isAutoDifficulty
    if isAutoDiff then
      local levelData = PlayerData.ServerData.chapter_level[tostring(levelId)] or {}
      if not DataModel.isLockDiff then
        curDiff = curDiff + math.min(levelData.auto_diff or 0, (levelCA.autoDifficultyMax or 1) - 1)
      else
        curDiff = math.max(levelData.auto_diff or 1, 1)
      end
    end
    local status = {
      Current = "Chapter",
      squadIndex = PlayerData.BattleInfo.squadIndex,
      hasOpenThreeView = false,
      difficulty = curDiff,
      isLockDiff = DataModel.isLockDiff
    }
    local t = {}
    t.curPos = DataModel.curPos
    t.curLevelIdx = DataModel.curLevelIdx
    t.isBattleReturn = true
    status.extraUIParamData = t
    PlayerData.BattleInfo.battleStageId = levelId
    PlayerData.BattleCallBackPage = "UI/Activity/Monster/MonsterLevel"
    PlayerData.TempCache.MonsterLevelPassedCache = PlayerData:GetLevelPass(levelId)
    UIManager:Open("UI/Squads/Squads", Json.encode(status))
  end
  
  if not levelCA.isEnemyLvEquilsPlayer and levelCA.recomGrade - PlayerData:GetPlayerLevel() >= 5 then
    local checkTipParam = {}
    checkTipParam.isCheckTip = true
    checkTipParam.checkTipKey = "HomeSafeLevelHardTip"
    checkTipParam.checkTipType = 1
    checkTipParam.showDanger = true
    checkTipParam.showSafe = true
    CommonTips.OnPrompt(80601227, nil, nil, detailDo, nil, nil, nil, nil, checkTipParam)
  else
    detailDo()
  end
end

function Controller:ClickStartBattle()
  PlayerData.TempCache.MonsterLevelAutoBattle = false
  Controller:StartBattle()
end

function Controller:AutoBattleClick()
  local levelId = DataModel.levelInfo[DataModel.curPos].levelList[DataModel.curLevelIdx]
  if not PlayerData:GetLevelPass(levelId) then
    CommonTips.OpenTips(80607117)
    return
  end
  if not PlayerData.TempCache.MonsterLevelAutoBattle and CommonTips.OpenBuyEnergyTips(levelId, nil, nil, nil, nil, true) then
    CommonTips.OpenTips(80607116)
    return
  end
  PlayerData.TempCache.MonsterLevelAutoBattle = not PlayerData.TempCache.MonsterLevelAutoBattle
  DataModel.monsterLevelAutoBattle = PlayerData.TempCache.MonsterLevelAutoBattle
  View.Group_LevelDetails.Group_Auto.Btn_Auto.Group_On:SetActive(DataModel.monsterLevelAutoBattle)
  View.Group_LevelDetails.Group_Auto.Btn_Auto.Group_Off:SetActive(not DataModel.monsterLevelAutoBattle)
  View.Group_LevelDetails.Group_Auto.Txt_Time:SetActive(DataModel.monsterLevelAutoBattle)
  if DataModel.monsterLevelAutoBattle then
    DataModel.remainAutoBattleTime = DataModel.constAutoBattleTime
    Controller:RefreshAutoBattleRemainTime()
  end
end

function Controller:BtnStoreClick()
  PlayerData.TempCache.MonsterLevelAutoBattle = false
  local parms = {}
  parms.activityId = 86000009
  parms.shopId = 40300060
  Net:SendProto("shop.info", function(json)
    UIManager:Open("UI/Activity/Monster/MonsterStore", Json.encode(parms))
  end)
end

function Controller:DoFirstPassAnim()
  View.Img_EffectBg:SetActive(true)
  local parentElement = View.Group_BG["Group_" .. DataModel.curPos]
  local fogElement = parentElement.Group_Fog["Img_" .. DataModel.curLevelIdx]
  fogElement:SetActive(true)
  local levelCount = #DataModel.levelInfo[DataModel.curPos].levelList
  local levelElement
  if levelCount > DataModel.curLevelIdx then
    levelElement = parentElement["Group_Level" .. DataModel.curLevelIdx + 1]
    levelElement:SetActive(false)
  end
  View.self:SelectPlayAnim(fogElement, "MonsterLevel_img01", function()
    fogElement:SetActive(false)
    if levelElement then
      levelElement:SetActive(true)
      View.self:SelectPlayAnim(levelElement.self, "Group_Level" .. DataModel.curLevelIdx + 1, function()
        View.Img_EffectBg:SetActive(false)
        Controller:ClickLevelBtn(DataModel.curLevelIdx + 1, true)
      end)
    else
      View.Img_EffectBg:SetActive(false)
      DataModel.curLevelIdx = 0
    end
  end)
end

function Controller:Return()
  Controller:CancelLevelClick()
  if DataModel.initParams.isBattleReturn then
    local ActivityMainDataModel = require("UIActivityMain/UIActivityMainDataModel")
    local activeList = ActivityMainDataModel:GetActivityCAList()
    for k, v in ipairs(activeList) do
      if v.id == 86000009 then
        UIManager:Open("UI/Activity/ActivityMain", Json.encode({
          index = k,
          id = 86000009,
          backToHome = true
        }))
      end
    end
  else
    UIManager:GoBack()
  end
end

function Controller:Home()
  Controller:CancelLevelClick()
  UIManager:GoHome()
end

function Controller:LockDiffClick(isLock, isInit)
  DataModel.isLockDiff = isLock
  if View.Group_SpLevelDetails ~= nil then
    View.Group_SpLevelDetails.Group_Lock.Btn_Lock.Group_On.self:SetActive(isLock)
    View.Group_SpLevelDetails.Group_Lock.Txt_On:SetActive(isLock)
    View.Group_SpLevelDetails.Group_Lock.Txt_Off:SetActive(not isLock)
  end
  if isInit ~= true then
    Controller:ShowLevelDetail(DataModel.curLevelIdx, true)
  end
  PlayerData:SetPlayerPrefs("int", "MonsterSpLevelLock", isLock and 0 or 1)
end

return Controller
