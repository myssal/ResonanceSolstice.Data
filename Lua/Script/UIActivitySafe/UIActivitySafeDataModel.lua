local DataModel = {
  activityId = 86000096,
  quickId = 99900149,
  configId = 99900014,
  NPCDialogEnum = {enterText = "enterText", talkText = "talkText"},
  totalExpelPercent = 0,
  battleStationList = {}
}

function DataModel.GetActivityConfig()
  return PlayerData:GetFactoryData(DataModel.activityId, "ActivityFactory")
end

function DataModel.GetQuickConfig()
  return PlayerData:GetFactoryData(DataModel.quickId, "ConfigFactory")
end

function DataModel.GetAllBattleStationList()
  local list = {}
  local ca = PlayerData:GetFactoryData(99900069, "ConfigFactory")
  if ca then
    local stationList = ca.openCityList or {}
    for i = 1, #stationList do
      local stationCA = PlayerData:GetFactoryData(stationList[i].id, "HomeStationFactory")
      if stationCA and stationCA.isOpen and stationCA.isHomeBattleCentre and stationCA.battleLevelList and #stationCA.battleLevelList > 0 then
        table.insert(list, stationCA)
      end
    end
  end
  local unlockList = {}
  local lockList = {}
  local finalList = {}
  for i = 1, #list do
    local isUnlock = DataModel.GetBattleStationIsUnlock(list[i].id)
    if isUnlock then
      table.insert(unlockList, list[i])
    else
      table.insert(lockList, list[i])
    end
  end
  for i = 1, #unlockList do
    table.insert(finalList, unlockList[i])
  end
  for i = 1, #lockList do
    table.insert(finalList, lockList[i])
  end
  return finalList or {}
end

function DataModel.GetAllSafeStationList()
  local entrustConfig = PlayerData:GetFactoryData(99900069, "ConfigFactory")
  if not entrustConfig or not entrustConfig.openBuildingList then
    return {}
  end
  local unlockList = {}
  local lockList = {}
  local finalList = {}
  for i = 1, #entrustConfig.openBuildingList do
    local isUnlock = DataModel.GetSafeStationIsUnlock(entrustConfig.openBuildingList[i].id)
    if isUnlock then
      table.insert(unlockList, entrustConfig.openBuildingList[i])
    else
      table.insert(lockList, entrustConfig.openBuildingList[i])
    end
  end
  for i = 1, #unlockList do
    table.insert(finalList, unlockList[i])
  end
  for i = 1, #lockList do
    table.insert(finalList, lockList[i])
  end
  return finalList or {}
end

function DataModel.GetSafeStationIsUnlock(buildId)
  local buildInfo = PlayerData:GetFactoryData(buildId, "BuildingFactory")
  if not buildInfo then
    return false
  end
  if not PlayerData:GetHomeInfo() then
    return false
  end
  local homeStations = PlayerData:GetHomeInfo().stations or {}
  local stationInfo = homeStations[tostring(buildInfo.stationId)]
  if stationInfo then
    if stationInfo.is_first == 1 then
      return false
    else
      return true
    end
  end
  return false
end

function DataModel.GetBattleStationIsUnlock(buildId)
  if not PlayerData:GetHomeInfo() then
    return false
  end
  local homeStations = PlayerData:GetHomeInfo().stations or {}
  local stationInfo = homeStations[tostring(buildId)]
  if stationInfo then
    if stationInfo.is_first == 1 then
      return false
    else
      return true
    end
  end
  return false
end

function DataModel.GetSafeProgressValue()
  local entrustConfig = PlayerData:GetFactoryData(99900069, "ConfigFactory")
  if not entrustConfig then
    return 0
  end
  local cacheEntrustQueueId = {}
  for i, v in ipairs(entrustConfig.entrustQueueList) do
    cacheEntrustQueueId[v.id] = 1
  end
  local curExpel = 0
  local maxExpel = 0
  local buildingInfo = PlayerData.ServerData.security_levels
  local safeList = DataModel.GetAllSafeStationList()
  if buildingInfo then
    for i, v in ipairs(safeList) do
      local strId = tostring(v.id)
      local t = {}
      local buildingCA = PlayerData:GetFactoryData(v.id, "BuildingFactory")
      t.curExpel = 0
      t.maxExpel = 0
      if buildingCA and buildingCA.createQuestList then
        for i1, v1 in ipairs(buildingCA.createQuestList) do
          local serverInfo = buildingInfo[strId] and buildingInfo[strId][tostring(v1.id)] or {}
          local tempPond = {}
          tempPond.curExpel = serverInfo and serverInfo.expel_num or 0
          local pondCA = PlayerData:GetFactoryData(v1.id)
          tempPond.maxExpel = pondCA.expelNum
          t.curExpel = t.curExpel + tempPond.curExpel
          t.maxExpel = t.maxExpel + tempPond.maxExpel
        end
      end
      curExpel = curExpel + t.curExpel
      maxExpel = maxExpel + t.maxExpel
    end
  end
  maxExpel = maxExpel == 0 and 1 or maxExpel
  return math.floor(curExpel / maxExpel * 100)
end

function DataModel.GetSafeStationProgressById(stationId)
  if not PlayerData.ServerData then
    return 0
  end
  local buildingInfo = PlayerData.ServerData.security_levels
  if not buildingInfo then
    return 0
  end
  local buildingCA = PlayerData:GetFactoryData(stationId, "BuildingFactory")
  local strId = tostring(stationId)
  local curExpel = 0
  local maxExpel = 0
  if buildingCA.createQuestList then
    for i1, v1 in ipairs(buildingCA.createQuestList) do
      local serverInfo = buildingInfo[strId] and buildingInfo[strId][tostring(v1.id)] or {}
      local tempPond = {}
      tempPond.curExpel = serverInfo and serverInfo.expel_num or 0
      local pondCA = PlayerData:GetFactoryData(v1.id)
      tempPond.maxExpel = pondCA and pondCA.expelNum or 0
      curExpel = curExpel + tempPond.curExpel
      maxExpel = maxExpel + tempPond.maxExpel
    end
  end
  maxExpel = maxExpel == 0 and 1 or maxExpel
  return math.floor(curExpel / maxExpel * 100 + 0.5)
end

function DataModel.GetSafetTips1Count()
  local openBuildingList = DataModel.GetAllSafeStationList() or {}
  return #openBuildingList * 10
end

function DataModel.GetSafetTips2Count()
  local openBuildingList = DataModel.GetAllSafeStationList() or {}
  return #openBuildingList * 300
end

function DataModel.GetSafeIsUnlock()
  local quickCa = DataModel.GetQuickConfig()
  if quickCa then
    local isFinish = PlayerData.IsQuestComplete(quickCa.safeLevelLimit)
    if isFinish == false then
      return false
    end
  end
  return true
end

function DataModel.GetMainSafeIsUnlock()
  local quickCa = DataModel.GetQuickConfig()
  if quickCa then
    local playerLv = PlayerData:GetPlayerLevel() or 0
    if quickCa.mainQuestCloseLimit and quickCa.mainQuestCloseLimit ~= -1 and PlayerData.IsQuestComplete(quickCa.mainQuestCloseLimit) then
      return false
    end
    if quickCa.mainGradeCloseLimit and quickCa.mainGradeCloseLimit ~= 0 and quickCa.mainGradeCloseLimit ~= -1 and playerLv >= quickCa.mainGradeCloseLimit then
      return false
    end
    if quickCa.mainQuestOpenLimit and quickCa.mainQuestOpenLimit ~= -1 and not PlayerData.IsQuestComplete(quickCa.mainQuestOpenLimit) then
      return false
    end
    if quickCa.mainGradeOpenLimit and playerLv < quickCa.mainGradeOpenLimit then
      return false
    end
  end
  return true
end

function DataModel.GetFirstSafeBuildId()
  local entrustConfig = PlayerData:GetFactoryData(99900069, "ConfigFactory")
  if not entrustConfig then
    return nil
  end
  local openBuildingList = DataModel.GetAllSafeStationList() or {}
  if openBuildingList[1] then
    return openBuildingList[1].id
  end
  return nil
end

function DataModel.GetBattleProgressValue()
  local homeConfig = PlayerData:GetFactoryData(99900014)
  if not homeConfig or not homeConfig.stationList then
    return 0
  end
  local curPcnt = 0
  local maxPcnt = 0
  for i, stationId in ipairs(homeConfig.stationList) do
    local stationCA = PlayerData:GetFactoryData(stationId.id)
    if stationCA.isOpen and stationCA.isHomeBattleCentre then
      local t = {}
      t.curPcnt = 0
      t.maxPcnt = #stationCA.battleLevelList
      for i1, battleLevelId in ipairs(stationCA.battleLevelList) do
        if PlayerData:GetLevelPass(battleLevelId.id) then
          t.curPcnt = t.curPcnt + 1
        end
      end
      curPcnt = curPcnt + t.curPcnt
      maxPcnt = maxPcnt + t.maxPcnt
    end
  end
  maxPcnt = maxPcnt == 0 and 1 or maxPcnt
  return math.floor(curPcnt / maxPcnt * 100)
end

function DataModel.GetBattleStationProgressById(stationId)
  local curPcnt = 0
  local maxPcnt = 0
  local stationCA = PlayerData:GetFactoryData(stationId)
  if stationCA and stationCA.battleLevelList then
    maxPcnt = #stationCA.battleLevelList
    for i1, battleLevelId in ipairs(stationCA.battleLevelList) do
      if PlayerData:GetLevelPass(battleLevelId.id) then
        curPcnt = curPcnt + 1
      end
    end
  end
  maxPcnt = maxPcnt == 0 and 1 or maxPcnt
  return math.floor(curPcnt / maxPcnt * 100)
end

function DataModel.GetBattleTipsCount()
  local count = 0
  local allBattleStationList = DataModel.GetAllBattleStationList() or {}
  for i = 1, #allBattleStationList do
    local stationInfo = allBattleStationList[i]
    if stationInfo.battleLevelList and 0 < #stationInfo.battleLevelList then
      for j = 1, #stationInfo.battleLevelList do
        local levelInfo = PlayerData:GetFactoryData(stationInfo.battleLevelList[j].id, "LevelFactory")
        if levelInfo and levelInfo.firstPassAward and 0 < #levelInfo.firstPassAward then
          for k = 1, #levelInfo.firstPassAward do
            if levelInfo.firstPassAward[k].itemId == 11400005 then
              count = count + (levelInfo.firstPassAward[k].num or 0)
            end
          end
        else
          local abyLevelInfo = PlayerData:GetFactoryData(stationInfo.battleLevelList[j].id, "AbyssFactory")
          if abyLevelInfo and abyLevelInfo.levelList and 0 < #abyLevelInfo.levelList then
            for k = 1, #abyLevelInfo.levelList do
              local levelInfo1 = PlayerData:GetFactoryData(abyLevelInfo.levelList[k].id, "LevelFactory")
              if levelInfo1 and levelInfo1.firstPassAward then
                for m = 1, #levelInfo1.firstPassAward do
                  if levelInfo1.firstPassAward[m].itemId == 11400005 then
                    count = count + (levelInfo1.firstPassAward[m].num or 0)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  return count
end

function DataModel.GetBattleIsUnlock()
  local quickCa = DataModel.GetQuickConfig()
  if quickCa then
    local isFinish = PlayerData.IsQuestComplete(quickCa.battleLevelLimit)
    if isFinish == false then
      return false
    end
  end
  return true
end

function DataModel.SafeBuildId2Index(id)
  local allSafeList = DataModel.GetAllSafeStationList() or {}
  for i = 1, #allSafeList do
    if allSafeList[i].id == id and DataModel.GetSafeStationIsUnlock(id) then
      return i
    end
  end
  return 0
end

function DataModel.BattleBuildId2Index(id)
  local allBattleList = DataModel.GetAllBattleStationList() or {}
  for i = 1, #allBattleList do
    if allBattleList[i].id == id and DataModel.GetBattleStationIsUnlock(id) then
      return i
    end
  end
  return 0
end

return DataModel
