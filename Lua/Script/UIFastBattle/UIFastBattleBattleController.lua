local View = require("UIFastBattle/UIFastBattleView")
local DataModel = require("UIFastBattle/UIFastBattleBattleDataModel")
local MainDataModel = require("UIFastBattle/UIFastBattleDataModel")
local CommonItem = require("Common/BtnItem")
local Controller = {refreshResourceFunc = nil}

function Controller.OpenBattlePage(refreshResourceFunc)
  DataModel.StationId = MainDataModel.BuildingId
  local stationCA = PlayerData:GetFactoryData(DataModel.StationId, "HomeStationFactory")
  if not stationCA then
    return
  end
  DataModel.StationCA = stationCA
  DataModel.battleLevelList = DataModel.StationCA.battleLevelList
  Controller.refreshResourceFunc = refreshResourceFunc
  DataModel.Index_OutSide = 1
  DataModel.Index_Battle = nil
  DataModel.Index_Init = nil
  DataModel.isHomeBattleMax = false
  DataModel.ShowBattleLevelList = {}
  local tagId = stationCA.battleTypeId
  DataModel.tagCfg = PlayerData:GetFactoryData(tagId)
  local count = 1
  for k, v in pairs(DataModel.battleLevelList) do
    local ca = PlayerData:GetFactoryData(v.id)
    if DataManager:GetFactoryNameById(tonumber(ca.id)) == "AbyssFactory" then
      ca = PlayerData:GetFactoryData(ca.levelList[#ca.levelList].id)
    end
    if ca.constructLimit <= PlayerData:GetConstructionProportion(DataModel.StationId) then
      DataModel.ShowBattleLevelList[count] = Clone(v)
      count = count + 1
    end
  end
  DataModel:GetNewLevel()
  View.Group_Battle.Group_Battle.Group_1.ScrollGrid_List.grid.self:SetDataCount(#DataModel.ShowBattleLevelList)
  View.Group_Battle.Group_Battle.Group_1.ScrollGrid_List.grid.self:RefreshAllElement()
  View.Group_Battle.Group_Battle.Group_1.Group_Top.Txt_Name:SetText(DataModel.StationCA.battleLevelName)
  View.Group_Battle.Group_Battle.Group_1.Group_Top.Img_Icon:SetSprite(DataModel.StationCA.battleIconPath)
  if DataModel.Index_Init == nil or DataModel.ShowBattleLevelList[DataModel.Index_Init] == nil then
    DataModel.Index_Init = 1
  end
  View.Group_Battle.Group_Battle.Group_1.ScrollGrid_List.grid.self:MoveToPos(DataModel.Index_Init)
  Controller.ChooseBattleLevel(DataModel.Index_Init)
  if Controller.refreshResourceFunc then
    Controller.refreshResourceFunc(3)
  end
  if DataModel.tagCfg then
    View.Group_Battle.Group_Battle.Group_1.Img_:SetSprite(DataModel.tagCfg.battlePage)
  end
end

function Controller.RefreshBattleElementShow(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  local row = DataModel.ShowBattleLevelList[elementIndex]
  if not row then
    return
  end
  local ca = PlayerData:GetFactoryData(row.id)
  if not ca then
    return
  end
  if DataManager:GetFactoryNameById(tonumber(ca.id)) == "AbyssFactory" then
    ca = PlayerData:GetFactoryData(ca.levelList[#ca.levelList].id)
  end
  row.ca = ca
  element:SetActive(true)
  element.Img_Di:SetSprite(DataModel.difficultyBg[row.difficulty])
  element.Txt_Grade:SetText(elementIndex)
  element.Txt_THREAT:SetActive(not CommonTips.IsResEN())
  element.Txt_LEVEL:SetActive(not CommonTips.IsResEN())
  element.Btn_:SetClickParam(elementIndex)
  element.Group_Limit:SetActive(not PlayerData:GetLevelPass(row.id))
  element.Group_Clear:SetActive(PlayerData:GetLevelPass(row.id))
  element.Img_Select:SetActive(tonumber(elementIndex) == DataModel.Index_Battle)
  element.Img_SelectDi:SetActive(false)
  if tonumber(elementIndex) == 1 then
    element.Group_Limit:SetActive(false)
    row.isBattle = true
  end
  element.Group_Limit:SetActive(not row.isBattle)
  if DataModel.Index_Battle and elementIndex == DataModel.Index_Battle then
    element.Img_Select:SetActive(true)
  end
  if DataModel.tagCfg then
    element.Group_Clear.Img_Clear:SetSprite(DataModel.tagCfg.battleClear)
    if row.difficulty == 1 then
      element.Img_Di:SetSprite(DataModel.tagCfg.easyBottom)
      element.Img_Select:SetSprite(DataModel.tagCfg.easySelectBottom)
    elseif row.difficulty == 2 then
      element.Img_Di:SetSprite(DataModel.tagCfg.normalBottom)
      element.Img_Select:SetSprite(DataModel.tagCfg.normalSelectBottom)
    elseif row.difficulty == 3 then
      element.Img_Di:SetSprite(DataModel.tagCfg.difficultBottom)
      element.Img_Select:SetSprite(DataModel.tagCfg.difficultSelectBottom)
    end
  end
end

function Controller.ChooseBattleLevel(index)
  if DataModel.Index_Battle and index and DataModel.Index_Battle == index then
    return
  end
  if DataModel.Index_Battle and DataModel.ShowBattleLevelList[DataModel.Index_Battle] then
    local old_element = View.Group_Battle.Group_Battle.Group_1.ScrollGrid_List.grid.self:GetElementByIndex(DataModel.Index_Battle - 1)
    if old_element then
      old_element.Img_Select:SetActive(false)
    end
  end
  local row = DataModel.ShowBattleLevelList[index]
  local element = View.Group_Battle.Group_Battle.Group_1.ScrollGrid_List.grid.self:GetElementByIndex(index - 1)
  if element then
    element.Img_Select:SetActive(true)
  end
  local Group_Information = View.Group_Battle.Group_Battle.Group_1.Group_Information
  Group_Information.Txt_Name:SetText(row.ca.levelName)
  Group_Information.Txt_Dec:SetText(row.ca.description)
  local isShowPrisonLogo = MainDataModel.GetLevelIsShowPrisonLogo(row.ca.id)
  print(row.ca.levelName .. " \230\152\175\229\144\166\230\152\190\231\164\186\231\155\145\231\139\177\229\155\190\230\160\135\239\188\154" .. tostring(isShowPrisonLogo))
  Group_Information.Img_Prisoner:SetActive(isShowPrisonLogo)
  local difficulty = 1
  local isCustomDifficulty = row.ca.isCustomDifficulty and row.isBattle
  local groupDifficult = Group_Information.Group_Difficult
  groupDifficult.self:SetActive(isCustomDifficulty)
  if isCustomDifficulty then
    difficulty = PlayerData:GetLevelDifficulty(row.ca.id)
    groupDifficult.Btn_Difficult.Txt_Difficult:SetText(GetText(DataModel.DifficultyTextWithColorId[difficulty]))
    groupDifficult.Img_Difficult.Img_Num:SetSprite(DataModel.DifficultyNumPath[difficulty])
    groupDifficult.Img_Difficult:SetSprite(DataModel.DifficultyBtnImgPath[difficulty])
  end
  local firstPassAward = row.ca.firstPassAward
  local dropListNew = PlayerData:GetLevelDropList(row.ca, difficulty)
  local state = PlayerData:GetLevelPass(row.id)
  Group_Information.Group_Auto.self:SetActive(row.isBattle)
  DataModel.ChooseRewardList = {}
  for i = 1, 20 do
    if firstPassAward[i] then
      table.insert(DataModel.ChooseRewardList, {
        num = firstPassAward[i].num,
        id = firstPassAward[i].itemId,
        type = 1,
        isFinish = state,
        index = #DataModel.ChooseRewardList
      })
    end
    if dropListNew[i] then
      table.insert(DataModel.ChooseRewardList, {
        num = dropListNew[i].num,
        id = dropListNew[i].id,
        type = 2,
        index = #DataModel.ChooseRewardList
      })
    end
  end
  if state == true then
    table.sort(DataModel.ChooseRewardList, function(a, b)
      if a.type == b.type then
        return a.index < b.index
      end
      return a.type > b.type
    end)
    Controller.RefreshAutoBtn(DataModel.isInitAuto)
    if DataModel.isInitAuto then
      Controller.RefreshRemainTime()
    end
    DataModel.isInitAuto = false
  else
    table.sort(DataModel.ChooseRewardList, function(a, b)
      if a.type == b.type then
        return a.index < b.index
      end
      return a.type < b.type
    end)
    Controller.RefreshAutoBtn(false)
  end
  Group_Information.ScrollGrid_Reward.grid.self:SetDataCount(#DataModel.ChooseRewardList)
  Group_Information.ScrollGrid_Reward.grid.self:RefreshAllElement()
  Group_Information.ScrollGrid_Reward.grid.self:MoveToTop()
  local costEnergy = row.ca.energyEnd + row.ca.extraEnergy * (difficulty - 1)
  if DataManager:GetFactoryNameById(tonumber(row.id)) == "AbyssFactory" then
    local abyssCA = PlayerData:GetFactoryData(row.id)
    costEnergy = 0
    for i = 1, #abyssCA.levelList do
      local ca = PlayerData:GetFactoryData(abyssCA.levelList[i].id, "LevelFactory")
      costEnergy = costEnergy + ca.energyStart + ca.energyEnd + ca.extraEnergy * (difficulty - 1)
    end
    Group_Information.Img_Tuijian:SetActive(false)
  else
    Group_Information.Img_Tuijian:SetActive(true)
    local level = PlayerData:GetUserInfo().lv
    if not row.ca.isEnemyLvEquilsPlayer then
      level = row.ca.recomGrade + row.ca.extraLevelOffset * (difficulty - 1)
    end
    Group_Information.Img_Tuijian.Txt_Grade:SetText(level)
  end
  Group_Information.Group_TZ.Txt_Cost:SetText(costEnergy)
  Group_Information.Group_TZ.self:SetActive(row.isBattle)
  Group_Information.Group_Limit.self:SetActive(not row.isBattle)
  DataModel.Index_Battle = index
  MainDataModel.curBattleIndex = index
end

function Controller.RefreshRewardElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  local row = DataModel.ChooseRewardList[elementIndex]
  element.Group_Item.Btn_Item:SetClickParam(elementIndex)
  element.Group_First.self:SetActive(false)
  element.Group_Allready.self:SetActive(false)
  if row.type == 1 then
    element.Group_First.self:SetActive(true)
    if row.isFinish == true then
      element.Group_Allready.self:SetActive(true)
    end
  end
  CommonItem:SetItem(element.Group_Item, row)
end

function Controller.RefreshAutoBtn(isAuto)
  PlayerData.TempCache.MonsterLevelAutoBattle = isAuto
  DataModel.monsterLevelAutoBattle = PlayerData.TempCache.MonsterLevelAutoBattle
  View.Group_Battle.Group_Battle.Group_1.Group_Information.Group_Auto.Btn_Auto.Group_Off.self:SetActive(not DataModel.monsterLevelAutoBattle)
  View.Group_Battle.Group_Battle.Group_1.Group_Information.Group_Auto.Btn_Auto.Group_On.self:SetActive(DataModel.monsterLevelAutoBattle)
  View.Group_Battle.Group_Battle.Group_1.Group_Information.Group_Auto.Txt_Time:SetActive(DataModel.monsterLevelAutoBattle)
end

function Controller.OnDifficultyBtnClick()
  local index = DataModel.Index_Battle
  local row = DataModel.ShowBattleLevelList[index]
  if not row or not row.ca then
    return
  end
  local isCustomDifficulty = row.ca.isCustomDifficulty
  if isCustomDifficulty then
    local t = {}
    t.levelId = row.ca.id
    t.difficulty = PlayerData:GetLevelDifficulty(t.levelId)
    UIManager:Open("UI/DiffficultSwitch/DiffficultSwitch", Json.encode(t), function()
      DataModel.Index_Battle = nil
      Controller.ChooseBattleLevel(index)
    end)
  end
end

function Controller.TryBattle(isAutoBattle)
  if not DataModel.Index_Battle then
    return
  end
  local index_battle = tonumber(DataModel.Index_Battle)
  local info = DataModel.ShowBattleLevelList[index_battle]
  if not DataModel.ShowBattleLevelList or not info then
    return
  end
  local levelId = info.id
  local levelCA = info.ca
  local isAbyss = false
  if DataManager:GetFactoryNameById(tonumber(levelId)) == "AbyssFactory" then
    levelId = info.ca.id
    isAbyss = true
  end
  local levelDifficulty = PlayerData:GetLevelDifficulty(levelId)
  
  local function doDoubleTeam()
    local holdNum = PlayerData.ServerData.user_info.energy
    local abyssCA = PlayerData:GetFactoryData(info.id)
    local costEnergyNum = 0
    for i = 1, #abyssCA.levelList do
      local ca = PlayerData:GetFactoryData(abyssCA.levelList[i].id, "LevelFactory")
      costEnergyNum = costEnergyNum + ca.energyStart + ca.energyEnd + ca.extraEnergy * (levelDifficulty - 1)
    end
    if holdNum < costEnergyNum then
      local recordTime = PlayerData:GetPlayerPrefs("int", "battleEnergy")
      local severTime = TimeUtil:GetServerTimeStamp()
      local reallyTime = recordTime == 0 and severTime or recordTime
      local newDate = os.date("*t", reallyTime)
      local resetTime = os.time({
        year = newDate.year,
        month = newDate.month,
        day = newDate.day,
        hour = 0,
        minute = 0,
        second = 0
      })
      local days = (severTime - resetTime) / 24 / 60 / 60
      if 1 <= days or recordTime == 0 then
        UIManager:Open("UI/Energy/EnergyBuyTips", nil, function()
          UIManager:Open("UI/Energy/Energy", nil, nil, nil)
        end, nil)
      else
        UIManager:Open("UI/Energy/Energy", nil, nil, nil)
      end
      return
    end
    local status = {
      callBackPage = "UI/Activity/ActivitySafe/FastBattle",
      abyssId = info.id,
      isDoubleTeam = true,
      difficulty = levelDifficulty,
      isAutoBattle = isAutoBattle,
      pathBtnBattle = 88300031,
      numText = 80607079
    }
    local extraParam = {
      openType = 2,
      curSelectIndex = MainDataModel.curSelectIndex,
      isMainActivityIn = false,
      curBattleIndex = MainDataModel.curBattleIndex
    }
    status.extraUIParamData = extraParam
    if isAutoBattle then
      PlayerData.TempCache.isAutoBattleCenter = isAutoBattle
      PlayerData.TempCache.curIndex = tonumber(DataModel.Index_Battle)
    else
      PlayerData.TempCache.isAutoBattleCenter = nil
      PlayerData.TempCache.curIndex = nil
    end
    if DataModel.isHomeBattleMax then
      PlayerData:SetPlayerPrefs("int", "BattleCenterIndex" .. DataModel.StationId, DataModel.Index_Battle)
    end
    UIManager:Open("UI/Chapter/Battle_Abyss/Team_Double", Json.encode(status))
  end
  
  local function doSquad()
    if CommonTips.OpenBuyEnergyTips(levelId, nil, nil, nil, levelDifficulty) then
      return
    end
    local status = {
      Current = "Chapter",
      squadIndex = PlayerData.BattleInfo.squadIndex,
      hasOpenThreeView = false,
      stationId = DataModel.StationId,
      npcId = DataModel.NpcId,
      bgPath = DataModel.BgPath,
      autoShowLevel = 1,
      name = DataModel.StationName,
      isBattleCenter = true,
      difficulty = levelDifficulty,
      isAutoBattle = isAutoBattle
    }
    local t = {}
    t.openType = 2
    t.curSelectIndex = MainDataModel.curSelectIndex
    t.isMainActivityIn = false
    t.curBattleIndex = MainDataModel.curBattleIndex
    status.extraUIParamData = t
    if isAutoBattle then
      PlayerData.TempCache.isAutoBattleCenter = isAutoBattle
      PlayerData.TempCache.curIndex = tonumber(DataModel.Index_Battle)
    else
      PlayerData.TempCache.isAutoBattleCenter = nil
      PlayerData.TempCache.curIndex = nil
    end
    PlayerData.BattleInfo.battleStageId = levelId
    PlayerData.BattleCallBackPage = "UI/Activity/ActivitySafe/FastBattle"
    if DataModel.isHomeBattleMax then
      PlayerData:SetPlayerPrefs("int", "BattleCenterIndex" .. DataModel.StationId, DataModel.Index_Battle)
    end
    UIManager:Open("UI/Squads/Squads", Json.encode(status))
  end
  
  local function detailDo()
    if isAbyss then
      doDoubleTeam()
    else
      doSquad()
    end
  end
  
  if not levelCA.isEnemyLvEquilsPlayer and levelCA.recomGrade + levelCA.extraLevelOffset * (levelDifficulty - 1) - PlayerData:GetPlayerLevel() >= 5 then
    local checkTipParam = {}
    checkTipParam.isCheckTip = true
    checkTipParam.checkTipKey = "HomeBattleCenterHardTip"
    checkTipParam.checkTipType = 1
    checkTipParam.showDanger = true
    CommonTips.OnPrompt(80601227, nil, nil, detailDo, nil, nil, nil, nil, checkTipParam)
  else
    detailDo()
  end
end

function Controller.OnClickBtnAuto()
  if not DataModel.Index_Battle then
    return
  end
  local battleIndex = tonumber(DataModel.Index_Battle)
  local info = DataModel.ShowBattleLevelList[battleIndex]
  if not info then
    return
  end
  local levelId = info.id
  if not PlayerData:GetLevelPass(levelId) then
    CommonTips.OpenTips(80607473)
    return
  end
  local isAbyss = false
  if DataManager:GetFactoryNameById(tonumber(levelId)) == "AbyssFactory" then
    levelId = info.ca.id
    isAbyss = true
  end
  local levelCA = PlayerData:GetFactoryData(levelId)
  local levelData = PlayerData.ServerData.chapter_level[tostring(levelId)]
  if levelCA.limitNum > 0 and levelData ~= nil and levelData.challenge_times ~= nil and levelData.challenge_times >= levelCA.limitNum then
    CommonTips.OpenTips(80607474)
    return
  end
  if not PlayerData.TempCache.MonsterLevelAutoBattle then
    if isAbyss then
      local holdNum = PlayerData.ServerData.user_info.energy
      local abyssCA = PlayerData:GetFactoryData(info.id)
      local costEnergy = 0
      local difficulty = PlayerData:GetLevelDifficulty(levelId)
      for i = 1, #abyssCA.levelList do
        local ca = PlayerData:GetFactoryData(abyssCA.levelList[i].id, "LevelFactory")
        costEnergy = costEnergy + ca.energyStart + ca.energyEnd + ca.extraEnergy * (difficulty - 1)
      end
      if holdNum < costEnergy then
        local recordTime = PlayerData:GetPlayerPrefs("int", "battleEnergy")
        local severTime = TimeUtil:GetServerTimeStamp()
        local reallyTime = recordTime == 0 and severTime or recordTime
        local newDate = os.date("*t", reallyTime)
        local resetTime = os.time({
          year = newDate.year,
          month = newDate.month,
          day = newDate.day,
          hour = 0,
          minute = 0,
          second = 0
        })
        local days = (severTime - resetTime) / 24 / 60 / 60
        if 1 <= days or recordTime == 0 then
          UIManager:Open("UI/Energy/EnergyBuyTips", nil, function()
            UIManager:Open("UI/Energy/Energy", nil, nil, nil)
          end, nil)
        else
          UIManager:Open("UI/Energy/Energy", nil, nil, nil)
        end
        CommonTips.OpenTips(80607116)
        return
      end
    elseif CommonTips.OpenBuyEnergyTips(levelId, nil, nil, nil, nil, true) then
      CommonTips.OpenTips(80607116)
      return
    end
  end
  DataModel.remainAutoBattleTime = DataModel.constAutoBattleTime
  Controller.RefreshAutoBtn(not PlayerData.TempCache.MonsterLevelAutoBattle)
  Controller.RefreshRemainTime()
end

function Controller.RefreshAutoBtn(isAuto)
  PlayerData.TempCache.MonsterLevelAutoBattle = isAuto
  DataModel.monsterLevelAutoBattle = PlayerData.TempCache.MonsterLevelAutoBattle
  View.Group_Battle.Group_Battle.Group_1.Group_Information.Group_Auto.Btn_Auto.Group_Off.self:SetActive(not DataModel.monsterLevelAutoBattle)
  View.Group_Battle.Group_Battle.Group_1.Group_Information.Group_Auto.Btn_Auto.Group_On.self:SetActive(DataModel.monsterLevelAutoBattle)
  View.Group_Battle.Group_Battle.Group_1.Group_Information.Group_Auto.Txt_Time:SetActive(DataModel.monsterLevelAutoBattle)
end

function Controller.RefreshRemainTime()
  if DataModel.remainAutoBattleTime <= 0 then
    DataModel.monsterLevelAutoBattle = false
    DataModel.remainAutoBattleTime = DataModel.constAutoBattleTime
    PlayerData.SquadsTempData = nil
    Controller.TryBattle(true)
    return
  end
  View.Group_Battle.Group_Battle.Group_1.Group_Information.Group_Auto.Txt_Time:SetText(string.format(GetText(80607112), math.ceil(DataModel.remainAutoBattleTime)))
end

return Controller
