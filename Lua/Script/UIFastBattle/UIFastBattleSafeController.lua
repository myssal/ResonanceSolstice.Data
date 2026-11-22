local View = require("UIFastBattle/UIFastBattleView")
local DataModel = require("UIFastBattle/UIFastBattleDataModel")
local XS_Controller = require("UIFastBattle/UIFastBattleXSController")
local Controller = {refreshResourceFunc = nil}
Controller.DifficultyTextId = {
  80601525,
  80601526,
  80601527,
  80601528,
  80601529,
  80601574
}
Controller.DifficultyTextWithColorId = {
  80601782,
  80601783,
  80601784,
  80601785,
  80601786,
  80601787
}
Controller.DifficultyBgPath = {
  "UI/Home/HomeSafe/Difficulty/page_bg_1",
  "UI/Home/HomeSafe/Difficulty/page_bg_2",
  "UI/Home/HomeSafe/Difficulty/page_bg_3",
  "UI/Home/HomeSafe/Difficulty/page_bg_4",
  "UI/Home/HomeSafe/Difficulty/page_bg_5",
  "UI/Home/HomeSafe/Difficulty/page_bg_6"
}
Controller.DifficultyIconPath = {
  "UI/Home/HomeSafe/Difficulty/icon_grade_1",
  "UI/Home/HomeSafe/Difficulty/icon_grade_2",
  "UI/Home/HomeSafe/Difficulty/icon_grade_3",
  "UI/Home/HomeSafe/Difficulty/icon_grade_4",
  "UI/Home/HomeSafe/Difficulty/icon_grade_5",
  "UI/Home/HomeSafe/Difficulty/icon_grade_6"
}
Controller.DifficultyNumPath = {
  "UI/Home/HomeSafe/Difficulty/icon_num_1",
  "UI/Home/HomeSafe/Difficulty/icon_num_2",
  "UI/Home/HomeSafe/Difficulty/icon_num_3",
  "UI/Home/HomeSafe/Difficulty/icon_num_4",
  "UI/Home/HomeSafe/Difficulty/icon_num_5",
  "UI/Home/HomeSafe/Difficulty/icon_num_6"
}
Controller.DifficultyIconBgPath = {
  "UI/Home/HomeSafe/Difficulty/icon_bg_1",
  "UI/Home/HomeSafe/Difficulty/icon_bg_2",
  "UI/Home/HomeSafe/Difficulty/icon_bg_3",
  "UI/Home/HomeSafe/Difficulty/icon_bg_4",
  "UI/Home/HomeSafe/Difficulty/icon_bg_5",
  "UI/Home/HomeSafe/Difficulty/icon_bg_6"
}
Controller.DifficultyBtnImgPath = {
  "UI/Home/HomeSafe/Difficulty/btn_grade_1",
  "UI/Home/HomeSafe/Difficulty/btn_grade_2",
  "UI/Home/HomeSafe/Difficulty/btn_grade_3",
  "UI/Home/HomeSafe/Difficulty/btn_grade_4",
  "UI/Home/HomeSafe/Difficulty/btn_grade_5",
  "UI/Home/HomeSafe/Difficulty/btn_grade_6"
}

function Controller:ClickShowLevelPanel(refreshResourceFunc, openIndex)
  if refreshResourceFunc then
    Controller.refreshResourceFunc = refreshResourceFunc
  end
  if not DataModel.levels or not DataModel.levels[DataModel.BuildingId] then
    return
  end
  DataModel.curLevelInfo = DataModel.levels[DataModel.BuildingId]
  DataModel.curLevelSelectIdx = openIndex or 1
  Controller:ShowLevelPanel()
  if Controller.refreshResourceFunc then
    Controller.refreshResourceFunc(1)
  end
end

function Controller:ShowLevelPanel()
  View.Group_Safa.Group_Level.Group_Tips.self:SetActive(false)
  View.Group_Safa.Group_Level.Group_Difficulty.self:SetActive(false)
  if #DataModel.curLevelInfo > 0 then
    View.Group_Safa.Group_Level.Group_Information:SetActive(true)
    View.Group_Safa.Group_Level.ScrollGrid_List.self:SetActive(#DataModel.curLevelInfo > 1)
    if #DataModel.curLevelInfo > 1 then
      View.Group_Safa.Group_Level.ScrollGrid_List.grid.self:SetDataCount(#DataModel.curLevelInfo)
    end
    Controller:ClickLevelBtn(DataModel.curLevelSelectIdx, true)
  else
    View.Group_Safa.Group_Level.Group_Information:SetActive(false)
    View.Group_Safa.Group_Level.ScrollGrid_List.self:SetActive(false)
  end
end

function Controller:Update()
  if DataModel.DayRefreshTime > 0 then
    local curTime = TimeUtil:GetServerTimeStamp()
    local isShowReward = View.Group_Safa.Group_XS.self ~= nil and View.Group_Safa.Group_XS.self.IsActive
    if isShowReward then
      XS_Controller:RefreshEmptyTimeTxt(DataModel.DayRefreshTime - curTime)
    end
    if curTime >= DataModel.DayRefreshTime then
      DataModel.InitDayRefreshTime()
      if View.Group_Safa.Group_Level.self.IsActive then
        Controller:ClickShowLevelPanel()
      end
    end
  end
end

function Controller:SetSliderViewTargetValue(val)
  DataModel._targetSliderValue = val
end

function Controller:UpdateSliderView()
  if not View.Group_Safa.Group_Level.IsActive then
    return
  end
  if not View.Group_Safa.Group_Level.Group_Difficulty.IsActive then
    return
  end
  local targetVal = DataModel._targetSliderValue
  if targetVal == nil then
    return
  end
  local sliderView = View.Group_Safa.Group_Level.Group_Difficulty.Slider_BG
  local curSliderVal = sliderView.slider.value
  if curSliderVal ~= targetVal then
    local distance = targetVal - curSliderVal
    local valPreFrame = CS.GameSetting.Instance.frameTime * 3
    local isAdd = 0 < distance
    DataModel.isSliderAdd = isAdd
    if valPreFrame >= math.abs(distance) then
      sliderView:SetSliderValue(targetVal)
    elseif isAdd then
      sliderView:SetSliderValue(curSliderVal + valPreFrame)
    elseif not isAdd then
      sliderView:SetSliderValue(curSliderVal - valPreFrame)
    end
  end
end

function Controller:UpdateBgGroupByDifficulty(element, difficulty)
  local index = math.min(difficulty, #Controller.DifficultyBgPath)
  element.Img_BG:SetSprite(Controller.DifficultyBgPath[index])
  element.Img_Icon:SetSprite(Controller.DifficultyIconPath[index])
  element.Img_Num:SetSprite(Controller.DifficultyNumPath[index])
  element.Group_Text.Txt_Difficulty:SetText(GetText(Controller.DifficultyTextId[index]))
end

function Controller:OnSliderViewValChanged(value)
  local progList = DataModel.difficultyProgList
  local difficulty = 1
  for i = 1, #progList - 1 do
    if value > progList[i] and value <= progList[i + 1] then
      difficulty = i
      break
    end
  end
  local centre = (progList[difficulty] + progList[difficulty + 1]) / 2
  local info = DataModel.curLevelInfo[DataModel.curLevelSelectIdx]
  local levelConfig = PlayerData:GetFactoryData(info.levelId, "ListFactory")
  local mutiple
  if value > centre then
    mutiple = difficulty
  else
    mutiple = difficulty - 1
  end
  local groupBottom = View.Group_Safa.Group_Level.Group_Difficulty.Group_Di
  groupBottom.Group_Energy.Txt_Energy:SetText(string.format(GetText(80601530), levelConfig.energyEnd + levelConfig.extraEnergy * mutiple))
  groupBottom.Group_Difficulty.Txt_Difficulty:SetText(string.format(GetText(80601531), levelConfig.recomGrade + levelConfig.extraLevelOffset * mutiple))
  local iconBgPath = Controller.DifficultyIconBgPath[mutiple + 1]
  groupBottom.Img_BG:SetSprite(iconBgPath)
  local stepProg = (value - progList[difficulty]) * (#progList - 1)
  local groupBG = View.Group_Safa.Group_Level.Group_Difficulty.Group_BG
  local groupBGFade = View.Group_Safa.Group_Level.Group_Difficulty.Group_BG_Fade
  groupBG:GetComponent(typeof(CS.UnityEngine.CanvasGroup)).alpha = 1 - stepProg
  groupBGFade:GetComponent(typeof(CS.UnityEngine.CanvasGroup)).alpha = stepProg
  local groupSchedule = View.Group_Safa.Group_Level.Group_Difficulty.Slider_BG.Group_Schedule
  local staticGridSelect = View.Group_Safa.Group_Level.Group_Difficulty.StaticGrid_Select.grid
  for i = 1, difficulty - 1 do
    groupSchedule["Img_Grade_" .. i]:SetAlpha(0)
    local gridSelect = staticGridSelect[i]
    gridSelect.Group_Off.Txt_Difficulty:SetAlpha(1)
    gridSelect.Group_Off.Txt_Num:SetAlpha(1)
    gridSelect.Group_On.Txt_Difficulty:SetAlpha(0)
    gridSelect.Group_On.Txt_Num:SetAlpha(0)
  end
  for i = difficulty + 2, #progList do
    groupSchedule["Img_Grade_" .. i]:SetAlpha(0)
    local gridSelect = staticGridSelect[i]
    gridSelect.Group_Off.Txt_Difficulty:SetAlpha(1)
    gridSelect.Group_Off.Txt_Num:SetAlpha(1)
    gridSelect.Group_On.Txt_Difficulty:SetAlpha(0)
    gridSelect.Group_On.Txt_Num:SetAlpha(0)
  end
  groupSchedule["Img_Grade_" .. difficulty]:SetAlpha(1 - stepProg)
  groupSchedule["Img_Grade_" .. difficulty + 1]:SetAlpha(stepProg)
  local homeConfig = PlayerData:GetFactoryData(99900014, "ConfigFactory")
  if not DataModel.isSliderAdd then
    stepProg = 1 - (progList[difficulty + 1] - value) * (#progList - 1) * homeConfig.difficultyTransMutiple
  else
    stepProg = stepProg * homeConfig.difficultyTransMutiple
  end
  local gridNow = staticGridSelect[difficulty]
  gridNow.Group_Off.Txt_Difficulty:SetAlpha(stepProg)
  gridNow.Group_Off.Txt_Num:SetAlpha(stepProg)
  gridNow.Group_On.Txt_Difficulty:SetAlpha(1 - stepProg)
  gridNow.Group_On.Txt_Num:SetAlpha(1 - stepProg)
  local gridNext = staticGridSelect[difficulty + 1]
  gridNext.Group_Off.Txt_Difficulty:SetAlpha(1 - stepProg)
  gridNext.Group_Off.Txt_Num:SetAlpha(1 - stepProg)
  gridNext.Group_On.Txt_Difficulty:SetAlpha(stepProg)
  gridNext.Group_On.Txt_Num:SetAlpha(stepProg)
  if difficulty == DataModel.curSliderIndex then
    return
  end
  DataModel.curSliderIndex = difficulty
  Controller:UpdateBgGroupByDifficulty(groupBG, difficulty)
  Controller:UpdateBgGroupByDifficulty(groupBGFade, difficulty + 1)
end

function Controller:SetDifficulty(index, difficulty)
  local info = DataModel.curLevelInfo[index]
  PlayerData:SetLevelDifficulty(index, difficulty)
  info.difficulty = difficulty
  Controller:ShowLevelDetail(DataModel.curLevelSelectIdx)
end

function Controller:ClickRewardBox(btn, str)
  local info = DataModel.curLevelInfo[tonumber(str)]
  local t = {}
  t.buildingId = DataModel.BuildingId
  t.pondId = info.pondId
  UIManager:Open("UI/Home/HomeSafe/ScheduleReward/ScheduleReward", Json.encode(t), function()
    local rewards = PlayerData.ServerData.security_levels[tostring(DataModel.BuildingId)][tostring(info.pondId)].rewards or {}
    local pondCA = PlayerData:GetFactoryData(info.pondId)
    info.canGet = info.canGetCount > 0 and #rewards ~= info.canGetCount
    info.received = #rewards == #pondCA.expelRewardList
    local element = View.Group_Safa.Group_Level.ScrollGrid_List.grid.self:GetElementByIndex(DataModel.curLevelSelectIdx - 1)
    if element then
      element.Img_RedPoint:SetActive(0 < RedpointTree:GetRedpointCnt(RedPointNodeStr.RedPointNodeStr.HomeSafeLevel .. DataModel.BuildingId .. "|" .. info.pondId))
    end
    Controller:ShowLevelDetail(DataModel.curLevelSelectIdx)
  end)
end

function Controller:RefreshLevelElement(element, elementIndex)
  local info = DataModel.curLevelInfo[elementIndex]
  local isSelect = DataModel.curLevelSelectIdx == elementIndex
  element.Img_RedPoint:SetActive(RedpointTree:GetRedpointCnt(RedPointNodeStr.RedPointNodeStr.HomeSafeLevel .. DataModel.BuildingId .. "|" .. info.pondId) > 0)
  element.Group_Off:SetActive(not isSelect)
  element.Group_On:SetActive(isSelect)
  local refreshElement = isSelect and element.Group_On or element.Group_Off
  refreshElement.Txt_Name:SetText(info.levelName)
  if info.seriesType == "Official" then
    refreshElement.Txt_Schedule:SetText(GetText(80602086))
    local expel = info.curExpel / info.maxExpel
    if 1 < expel then
      expel = 1
    end
    refreshElement.Txt_Num:SetText(string.format(GetText(80602089), math.ceil(expel * 100)))
  else
    refreshElement.Txt_Schedule:SetText(GetText(80602085))
    local expel = info.curNum / info.seriesCompleteNum
    if 1 < expel then
      expel = 1
    end
    refreshElement.Txt_Num:SetText(string.format(GetText(80602089), math.ceil(expel * 100)))
  end
  element.Btn_Click:SetClickParam(elementIndex)
end

function Controller:ClickLevelBtn(idx, force)
  if not force and DataModel.curLevelSelectIdx == idx then
    return
  end
  if idx > #DataModel.curLevelInfo then
    idx = 1
  end
  DataModel.curLevelSelectIdx = idx
  if #DataModel.curLevelInfo > 1 then
    View.Group_Safa.Group_Level.ScrollGrid_List.grid.self:RefreshAllElement()
  end
  Controller:ShowLevelDetail(idx)
end

function Controller:ShowLevelDetail(idx)
  local info = DataModel.curLevelInfo[idx]
  if not info then
    return
  end
  local element = View.Group_Safa.Group_Level.Group_Information
  local levelConfig = PlayerData:GetFactoryData(info.levelId, "LevelFactory")
  local starInt = levelConfig.levelStarInt + 1
  for i = 1, 5 do
    local star = element.Group_Star["Img_Star" .. i]
    star:SetActive(i <= starInt)
  end
  element.Group_Name.Txt_Name:SetText(levelConfig.levelName)
  local isNormal = levelConfig.levelBgType == "Normal"
  element.Img_Icon:SetSprite(isNormal and "UI/Home/HomeSafe/Level/level_icon_normal" or "UI/Home/HomeSafe/Level/level_icon_hua")
  local curStationRepLv = DataModel.GetCurStationRepLv(DataModel.BuildingId) or 0
  local isLimitRep = curStationRepLv < info.limitRepLv
  local isCustomDifficulty = levelConfig.isCustomDifficulty == true
  local difficulty = info.difficulty
  if isCustomDifficulty then
    element.Group_Difficult.Btn_Difficult.Txt_Difficult:SetText(GetText(Controller.DifficultyTextWithColorId[difficulty]))
  end
  local expel = 0
  if info.seriesType == "Official" then
    element.Group_Schedule.Txt_Name:SetText(string.format(GetText(80602087), info.seriesName))
    expel = info.curExpel / info.maxExpel
    if 1 < expel then
      expel = 1
    end
    element.Group_Wei:SetActive(not isCustomDifficulty)
    element.Group_Difficult:SetActive(isCustomDifficulty)
    element.Group_Test:SetActive(false)
    if isCustomDifficulty then
      element.Group_Difficult.Img_Difficult.Img_Num:SetSprite(Controller.DifficultyNumPath[difficulty])
      element.Group_Difficult.Img_Difficult:SetSprite(Controller.DifficultyBtnImgPath[difficulty])
      element.Group_Difficult.Btn_Difficult:SetClickParam(idx)
    end
    element.Group_Progress.Group_Schedule.Group_Right.Group_Reward:SetActive(true)
    element.Group_Progress.Group_Schedule.Group_Right.Group_Jindu:SetActive(false)
    local box = element.Group_Progress.Group_Schedule.Group_Right.Group_Reward.Group_Box
    local isCanGet = info.canGet
    local received = info.received
    box.Group_Not:SetActive(not isCanGet)
    box.Group_Can:SetActive(isCanGet and not received)
    box.Group_Already:SetActive(received)
    element.Group_Progress.Group_Schedule.Group_Right.Group_Reward.Btn_:SetClickParam(idx)
  else
    element.Group_Schedule.Txt_Name:SetText(GetText(80602085))
    expel = info.curNum / info.seriesCompleteNum
    if 1 < expel then
      expel = 1
    end
    element.Group_Wei:SetActive(false)
    element.Group_Difficult:SetActive(false)
    element.Group_Test:SetActive(true)
    element.Group_Progress.Group_Schedule.Group_Right.Group_Reward:SetActive(false)
    element.Group_Progress.Group_Schedule.Group_Right.Group_Jindu:SetActive(true)
    element.Group_Progress.Group_Schedule.Group_Right.Group_Jindu.Txt_Num:SetText(string.format(GetText(80601235), info.curNum, info.seriesCompleteNum))
  end
  element.Group_Schedule.Txt_Schedule:SetText(string.format(GetText(80602089), math.ceil(expel * 100)))
  element.Group_Progress.Group_Schedule.Img_Di.Img_Progress:SetFilledImgAmount(expel)
  element.Group_Progress.Txt_Dec:SetText(levelConfig.description)
  local dropTableList = levelConfig.dropTableList
  local dropTable = dropTableList[difficulty]
  if dropTable == nil then
    error("\229\133\179\229\141\161id:" .. levelConfig.id .. " \231\188\186\229\176\145\233\154\190\229\186\166" .. difficulty .. "\231\154\132\230\142\137\232\144\189\233\133\141\231\189\174")
  end
  local dropList = PlayerData:GetLevelDropList(levelConfig, difficulty, Clone(info.waves))
  DataModel.dropList = dropList
  element.ScrollGrid_Reward.grid.self:SetDataCount(#dropList)
  element.ScrollGrid_Reward.grid.self:RefreshAllElement()
  element.ScrollGrid_Reward.grid.self:MoveToTop()
  element.Img_Limit:SetActive(isLimitRep)
  element.Group_Battle:SetActive(not isLimitRep)
  if isLimitRep then
    element.Img_Limit.Txt_Rep:SetText(string.format(GetText(80601015), info.limitRepLv))
  else
    element.Group_Battle.Group_Start.Btn_Battle.self:SetClickParam(idx)
    element.Group_Battle.Group_Start.Btn_Battle.Img_Cost.Txt_Cost:SetText(levelConfig.energyEnd + levelConfig.extraEnergy * (difficulty - 1))
    local level = PlayerData:GetUserInfo().lv
    if not levelConfig.isEnemyLvEquilsPlayer then
      level = levelConfig.recomGrade + levelConfig.extraLevelOffset * (difficulty - 1)
    end
    element.Group_Battle.Img_Recommend.Txt_Grade:SetText(level)
  end
  if levelConfig.saleLevelType == "Daily" then
    element.Group_Battle.Group_Start.Group_Auto.self:SetActive(true)
    if PlayerData.TempCache.isAutoBattleSafe then
      Controller:RefreshAutoBtn(true)
    else
      Controller:RefreshAutoBtn(false)
    end
  else
    element.Group_Battle.Group_Start.Group_Auto.self:SetActive(false)
    Controller:RefreshAutoBtn(false)
  end
  PlayerData.TempCache.isAutoBattleSafe = nil
  local buildingCA = PlayerData:GetFactoryData(DataModel.BuildingId)
  element.Img_Di:SetSprite(buildingCA.expelBgPath)
  local isShowPrisonLogo = DataModel.GetLevelIsShowPrisonLogo(info.levelId)
  element.Img_Prisoner:SetActive(isShowPrisonLogo)
end

function Controller:RefreshReward(element, elementIndex)
  local dropList = DataModel.dropList
  local dropInfo = dropList[elementIndex]
  local BtnItem = require("Common/BtnItem")
  BtnItem:SetItem(element.Group_Item, {
    id = dropInfo.id,
    num = ""
  })
  element.Group_Item.Btn_Item:SetClickParam(dropInfo.id)
end

function Controller:ClickBattle(str, isAutoBattle)
  local info = DataModel.curLevelInfo[tonumber(str)]
  local levelId = info.levelId
  local levelCA = PlayerData:GetFactoryData(levelId, "LevelFactory")
  
  local function detailDo()
    if CommonTips.OpenBuyEnergyTips(levelId, function()
      if Controller.refreshResourceFunc then
        Controller.refreshResourceFunc(1)
      end
    end, nil, nil, info.difficulty) then
      return
    end
    local enemyWaveStr = ""
    if info.waves ~= nil then
      for i = 1, #info.waves do
        if 3 < i then
          break
        end
        if enemyWaveStr ~= "" then
          enemyWaveStr = enemyWaveStr .. ","
        end
        enemyWaveStr = enemyWaveStr .. info.waves[i].enemyWaveId
      end
    end
    local status = {
      Current = "Chapter",
      squadIndex = PlayerData.BattleInfo.squadIndex,
      hasOpenThreeView = false,
      difficulty = info.difficulty,
      enemy_ids = enemyWaveStr
    }
    local t = {}
    t.openType = 1
    t.curSafeType = 1
    t.curSelectIndex = DataModel.curSelectIndex
    t.curLevelIndex = DataModel.curLevelSelectIdx
    t.isMainActivityIn = false
    status.extraUIParamData = t
    status.isAutoBattle = isAutoBattle
    if isAutoBattle then
      PlayerData.TempCache.isAutoBattleSafe = isAutoBattle
    else
      PlayerData.TempCache.isAutoBattleSafe = nil
    end
    PlayerData.Last_Chapter_Parms = nil
    PlayerData.BattleInfo.battleStageId = levelId
    PlayerData.BattleCallBackPage = "UI/Activity/ActivitySafe/FastBattle"
    UIManager:Open("UI/Squads/Squads", Json.encode(status))
  end
  
  if not levelCA.isEnemyLvEquilsPlayer and levelCA.recomGrade + levelCA.extraLevelOffset * (info.difficulty - 1) - PlayerData:GetPlayerLevel() >= 5 then
    local checkTipParam = {}
    checkTipParam.isCheckTip = true
    checkTipParam.checkTipKey = "HomeSafeLevelHardTip"
    checkTipParam.checkTipType = 1
    checkTipParam.showDanger = true
    CommonTips.OnPrompt(80601227, nil, nil, detailDo, nil, nil, nil, nil, checkTipParam)
  else
    detailDo()
  end
end

function Controller:RefreshRemainTime()
  if DataModel.remainAutoBattleTime <= 0 then
    DataModel.monsterLevelAutoBattle = false
    DataModel.remainAutoBattleTime = DataModel.constAutoBattleTime
    PlayerData.SquadsTempData = nil
    Controller:ClickBattle(DataModel.curLevelSelectIdx, true)
    return
  end
  View.Group_Safa.Group_Level.Group_Information.Group_Battle.Group_Start.Group_Auto.Txt_Time:SetText(string.format(GetText(80607112), math.ceil(DataModel.remainAutoBattleTime)))
end

function Controller:RefreshAutoBtn(isAuto)
  PlayerData.TempCache.MonsterLevelAutoBattle = isAuto
  DataModel.monsterLevelAutoBattle = PlayerData.TempCache.MonsterLevelAutoBattle
  View.Group_Safa.Group_Level.Group_Information.Group_Battle.Group_Start.Group_Auto.Btn_Auto.Group_Off.self:SetActive(not DataModel.monsterLevelAutoBattle)
  View.Group_Safa.Group_Level.Group_Information.Group_Battle.Group_Start.Group_Auto.Btn_Auto.Group_On.self:SetActive(DataModel.monsterLevelAutoBattle)
  View.Group_Safa.Group_Level.Group_Information.Group_Battle.Group_Start.Group_Auto.Txt_Time:SetActive(DataModel.monsterLevelAutoBattle)
end

function Controller:OnClickBtnAuto()
  local info = DataModel.curLevelInfo[tonumber(DataModel.curLevelSelectIdx)]
  local levelId = info.levelId
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
  DataModel.remainAutoBattleTime = DataModel.constAutoBattleTime
  Controller:RefreshAutoBtn(not PlayerData.TempCache.MonsterLevelAutoBattle)
  Controller:RefreshRemainTime()
end

return Controller
