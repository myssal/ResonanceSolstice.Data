local Act_DataModel = require("UIActivitySafe/UIActivitySafeDataModel")
local DataModel = {
  openType = 1,
  curSelectIndex = 1,
  curSafeType = 1,
  IsMainActivityIn = false,
  curLevelSelectIdx = 1,
  curBattleIndex = 0,
  curXsIndex = 1,
  curSafeSelectIndex = 1,
  curBattleSelectIndex = 1,
  levels = {},
  curLevelInfo = nil,
  BuildingId = 0,
  monsterLevelAutoBattle = false,
  NpcId = 0,
  constAutoBattleTime = 3,
  remainAutoBattleTime = 3,
  DayRefreshTime = 0,
  battleStationList = {}
}

function DataModel.GetAllSafeStationList()
  return Act_DataModel.GetAllSafeStationList()
end

function DataModel.GetAllBattleStationList()
  return Act_DataModel.GetAllBattleStationList()
end

function DataModel.GetSafeStationProgressById(id)
  return Act_DataModel.GetSafeStationProgressById(id)
end

function DataModel.GetBattleStationProgressById(id)
  return Act_DataModel.GetBattleStationProgressById(id)
end

function DataModel.GetCurStationRepLv(buildId)
  local buildInfo = PlayerData:GetFactoryData(buildId, "BuildingFactory")
  if not buildInfo then
    return 0
  end
  if not PlayerData:GetHomeInfo() then
    return 0
  end
  local homeStations = PlayerData:GetHomeInfo().stations or {}
  local stationInfo = homeStations[tostring(buildInfo.stationId)]
  if not stationInfo then
    return 0
  end
  return stationInfo.rep_lv or 0
end

function DataModel.GetXSTaskIsUnlock(buildId)
  local buildInfo = PlayerData:GetFactoryData(buildId, "BuildingFactory")
  if not buildInfo then
    return false
  end
  if not PlayerData:GetHomeInfo() then
    return false
  end
  local homeStations = PlayerData:GetHomeInfo().stations or {}
  local stationInfo = homeStations[tostring(buildInfo.stationId)]
  if not stationInfo then
    return false
  end
  local curRepLv = stationInfo.rep_lv or 0
  if curRepLv < buildInfo.offerPrestige then
    return false
  else
    return true
  end
end

function DataModel.GetSafeStationIsUnlock(buildId)
  return Act_DataModel.GetSafeStationIsUnlock(buildId)
end

function DataModel.GetBattleStationIsUnlock(buildId)
  return Act_DataModel.GetBattleStationIsUnlock(buildId)
end

function DataModel.InitLevelData()
  DataModel.levels = DataModel.levels or {}
  local buildList = DataModel.GetAllSafeStationList()
  if not buildList or #buildList == 0 then
    return
  end
  if not PlayerData.ServerData then
    return
  end
  local levels = PlayerData.ServerData.security_levels
  if not levels then
    return
  end
  for i = 1, #buildList do
    if buildList[i] and buildList[i].id then
      DataModel.levels[buildList[i].id] = {}
      local pondData = {}
      local buildingCA = PlayerData:GetFactoryData(buildList[i].id, "BuildingFactory")
      if buildingCA and buildingCA.createQuestList then
        for k, v in pairs(buildingCA.createQuestList) do
          pondData[v.id] = v
          pondData[v.id].index = k
        end
      end
      local pondsValue = levels[tostring(buildList[i].id)]
      if pondsValue ~= nil then
        for k1, v1 in pairs(pondsValue) do
          local curNum = 0
          local notReceived = false
          local tempLevels = v1.branch_levels or {}
          local levelId = 0
          local waves = {}
          curNum = table.count(tempLevels)
          for k2, v2 in pairs(tempLevels) do
            if v2.status ~= 1 then
              levelId = tonumber(k2)
              curNum = curNum - 1
              if v2.waves ~= nil then
                for i = 1, #v2.waves do
                  waves[#waves + 1] = {
                    enemyWaveId = tonumber(v2.waves[i])
                  }
                end
              end
              break
            end
          end
          if levelId == 0 then
            tempLevels = v1.daily_levels or {}
            curNum = curNum + table.count(tempLevels)
            for k2, v2 in pairs(tempLevels) do
              if v2.status ~= 1 then
                levelId = tonumber(k2)
                curNum = curNum - 1
                if v2.waves ~= nil then
                  for i = 1, #v2.waves do
                    waves[#waves + 1] = {
                      enemyWaveId = tonumber(v2.waves[i])
                    }
                  end
                end
                break
              end
            end
          end
          if levelId ~= 0 then
            local pondId = tonumber(k1)
            local pondCA = PlayerData:GetFactoryData(pondId, "ListFactory")
            local levelCA = PlayerData:GetFactoryData(levelId, "LevelFactory")
            local t = {}
            t.pondId = pondId
            t.seriesType = pondCA.seriesType
            t.seriesName = pondCA.seriesName
            t.seriesCompleteNum = pondCA.seriesCompleteNum
            t.deterrence = pondCA.deterrence
            t.maxExpel = pondCA.expelNum
            t.curExpel = v1.expel_num
            t.limitRepLv = pondData[pondId].repCondition
            t.levelId = levelId
            t.levelName = levelCA.levelName
            t.curNum = curNum
            t.difficulty = 1
            t.waves = waves
            local canGetCount = 0
            for i, expelRewardInfo in pairs(pondCA.expelRewardList) do
              if t.curExpel >= expelRewardInfo.expel then
                canGetCount = canGetCount + 1
              end
            end
            local rewards = v1.rewards or {}
            t.canGetCount = canGetCount
            t.canGet = 0 < canGetCount and #rewards ~= canGetCount
            t.received = #rewards == #pondCA.expelRewardList
            table.insert(DataModel.levels[buildList[i].id], t)
            if t.canGet and not t.received then
              notReceived = true
            end
          end
          if notReceived then
            local nodeName = RedPointNodeStr.RedPointNodeStr.HomeSafeLevel .. buildList[i].id .. "|" .. k1
            RedpointTree:InsertNode(nodeName)
            RedpointTree:ChangeRedpointCnt(nodeName, 1)
          end
        end
      end
      table.sort(DataModel.levels[buildList[i].id], function(a, b)
        return pondData[a.pondId].index < pondData[b.pondId].index
      end)
      for j = 1, #DataModel.levels[buildList[i].id] do
        local levelConfig = PlayerData:GetFactoryData(DataModel.levels[buildList[i].id][j].levelId, "LevelFactory")
        if levelConfig.isCustomDifficulty then
          DataModel.levels[buildList[i].id][j].difficulty = PlayerData:GetLevelDifficulty(j)
        end
      end
    end
  end
end

function DataModel.GetEnergy()
  return PlayerData:GetGoodsById(11400006).num
end

function DataModel.InitDayRefreshTime()
  local defaultConfig = PlayerData:GetFactoryData(99900001, "ConfigFactory")
  local h = tonumber(string.sub(defaultConfig.dailyRefreshTime, 1, 2))
  local m = tonumber(string.sub(defaultConfig.dailyRefreshTime, 4, 5))
  local s = tonumber(string.sub(defaultConfig.dailyRefreshTime, 7, 8))
  DataModel.DayRefreshTime = TimeUtil:GetNextSpecialTimeStamp(h, m, s)
end

function DataModel.GetLeverRewardRedDotState(buildId)
  return RedPointNodeStr.IsHaveRed(RedPointNodeStr.RedPointNodeStr.HomeSafeLevel .. buildId)
end

function DataModel.GetLeverRewardRedDotStateById(buildId, pondId)
  return RedpointTree:GetRedpointCnt(RedPointNodeStr.RedPointNodeStr.HomeSafeLevel .. buildId .. "|" .. pondId) > 0
end

function DataModel.GetAllLeverRewardRedDotState()
  if not Act_DataModel.GetSafeIsUnlock() then
    return false
  end
  local buildList = DataModel.GetAllSafeStationList() or {}
  for i = 1, #buildList do
    if DataModel.GetLeverRewardRedDotState(buildList[i].id) then
      return true
    end
  end
  return false
end

function DataModel.GetMainActivityRedDotState()
  if not Act_DataModel.GetSafeIsUnlock() then
    return false
  end
  local levelRedState = DataModel.GetAllLeverRewardRedDotState()
  if levelRedState then
    return true
  end
  local timeTable = TimeUtil:GetLogicServerDayTable()
  if timeTable.hour < 5 then
    return false
  end
  local safeProValue = Act_DataModel.GetSafeProgressValue() or 0
  local battleProValue = Act_DataModel.GetBattleProgressValue() or 0
  if safeProValue < 100 or battleProValue < 100 then
    local defaultConfig = PlayerData:GetFactoryData(99900149)
    if not defaultConfig then
      return false
    end
    local redDay = defaultConfig.safeDayRedPoint or 0
    local regisTime = PlayerData:GetUserInfo().add_time or 0
    local nowTime = TimeUtil:GetServerTimeStamp() or 0
    local time = TimeUtil:SecondToTable(nowTime - regisTime)
    if redDay >= time.day then
      local nowDay = TimeUtil:GetLogicServerDayTable().day or 0
      local lastDay = PlayerData:GetPlayerPrefs("int", "LastFastBattleLoginDay")
      if lastDay == 0 or lastDay ~= nowDay then
        PlayerData:SetPlayerPrefs("int", "ActivitySafeRedDotState", 0)
      end
      if PlayerData:GetPlayerPrefs("int", "ActivitySafeRedDotState") == 0 then
        return true
      end
    end
  end
  return false
end

function DataModel.IsJoinedActivity()
  return PlayerData:GetActivityAct(Act_DataModel.activityId)
end

function DataModel.GetBattleTargetTab(id)
  local result = 0
  local stationList = DataModel.GetAllBattleStationList()
  local levelList = stationList[DataModel.curSelectIndex].battleLevelList
  for i, lv in ipairs(levelList) do
    if tonumber(lv.id) == tonumber(id) then
      result = i
      if PlayerData:GetLevelPass(lv.id) == false then
        result = 0
      end
      break
    end
  end
  return result
end

function DataModel.GetLevelIsShowPrisonLogo(levelId)
  if not levelId then
    return false
  end
  local ca = PlayerData:GetFactoryData(levelId, "LevelFactory")
  if not ca then
    return false
  end
  local isPrisonOpen = PlayerData.ServerData and PlayerData.ServerData.user_prison_info
  if not isPrisonOpen then
    return false
  end
  local prisonCa = PrisonData.GetPrisonCA()
  if not prisonCa then
    return false
  end
  local itemId = prisonCa.arrestItem
  local itemNum = PlayerData:GetGoodsById(itemId).num or 0
  if itemNum <= 0 then
    return false
  end
  if ca.mod == "\230\178\187\229\174\137\229\133\179\229\141\161" then
    local randWaveList = ca.randWaveList or {}
    for i = 1, #randWaveList do
      local waveCa = PlayerData:GetFactoryData(randWaveList[i].waveListId, "EnemyWaveFactory")
      if waveCa and waveCa.enemyRandWaveList and 0 < #waveCa.enemyRandWaveList then
        for j = 1, #waveCa.enemyRandWaveList do
          local unitCa = PlayerData:GetFactoryData(waveCa.enemyRandWaveList[j].id, "UnitFactory")
          if unitCa and unitCa.prisonerDrop and 0 < #unitCa.prisonerDrop then
            return true
          end
        end
      end
    end
  end
  local enemyList = ca.enemyWaveList or {}
  for i = 1, #enemyList do
    local waveCa = PlayerData:GetFactoryData(enemyList[i].enemyWaveId, "EnemyWaveFactory")
    if waveCa and waveCa.enemyList and 0 < #waveCa.enemyList then
      for j = 1, #waveCa.enemyList do
        local unitCa = PlayerData:GetFactoryData(waveCa.enemyList[j].id, "UnitFactory")
        if unitCa and unitCa.prisonerDrop and 0 < #unitCa.prisonerDrop then
          return true
        end
      end
    end
  end
  return false
end

function DataModel.SavePanelOpenCachedParams()
  if DataModel.openType == 1 then
    PlayerData:SetPlayerPrefs("string", "FastBattle_PanelParams_Cache_Safe", DataModel.curSafeSelectIndex .. "|" .. DataModel.curSafeType .. "|" .. DataModel.curLevelSelectIdx .. "|" .. DataModel.curXsIndex)
  elseif DataModel.openType == 2 then
    PlayerData:SetPlayerPrefs("string", "FastBattle_PanelParams_Cache_Battle", DataModel.curBattleSelectIndex .. "|" .. DataModel.curBattleIndex)
  end
end

function DataModel.GetPanelOpenCachedParams(panelType)
  if panelType == 1 then
    local paramStr = PlayerData:GetPlayerPrefs("string", "FastBattle_PanelParams_Cache_Safe")
    if string.nilorempty(paramStr) then
      return nil
    end
    local paramList = string.split(paramStr, "|")
    if not paramList or #paramList <= 0 then
      return nil
    end
    local paramTab = {}
    paramTab.selectIndex = tonumber(paramList[1]) or 1
    paramTab.safeType = tonumber(paramList[2]) or 1
    paramTab.levelIndex = tonumber(paramList[3]) or 1
    paramTab.xsIndex = tonumber(paramList[4]) or 1
    return paramTab
  elseif panelType == 2 then
    local paramStr = PlayerData:GetPlayerPrefs("string", "FastBattle_PanelParams_Cache_Battle")
    if string.nilorempty(paramStr) then
      return nil
    end
    local paramList = string.split(paramStr, "|")
    if not paramList or #paramList <= 0 then
      return nil
    end
    local paramTab = {}
    paramTab.selectIndex = tonumber(paramList[1]) or 1
    paramTab.battleIndex = tonumber(paramList[2]) or 1
    return paramTab
  end
end

return DataModel
