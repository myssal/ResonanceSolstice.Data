local DataModel = {
  showExpelInfo = {},
  showBattleInfo = {},
  totalExpelPercent = 0,
  totalBattlePercent = 0,
  panelType = {Expel = 1, Battle = 2},
  curSelectType = 0
}

function DataModel.Init()
  DataModel.showExpelInfo = {}
  DataModel.showBattleInfo = {}
end

function DataModel.InitBuildingInfo()
  if #DataModel.showExpelInfo > 0 then
    return
  end
  local entrustConfig = PlayerData:GetFactoryData(99900069, "ConfigFactory")
  local cacheEntrustQueueId = {}
  for i, v in ipairs(entrustConfig.entrustQueueList) do
    cacheEntrustQueueId[v.id] = 1
  end
  local curExpel = 0
  local maxExpel = 0
  local buildingInfo = PlayerData.ServerData.security_levels
  if buildingInfo then
    for i, v in ipairs(entrustConfig.openBuildingList) do
      local strId = tostring(v.id)
      local t = {}
      local buildingCA = PlayerData:GetFactoryData(v.id, "BuildingFactory")
      local stationCA = PlayerData:GetFactoryData(buildingCA.stationId, "HomeStationFactory")
      t.name = stationCA.name
      t.cityMapIconPath = stationCA.cityMapIconPath
      t.curExpel = 0
      t.maxExpel = 0
      t.isEntrustQueue = cacheEntrustQueueId[v.id] ~= nil
      t.ponds = {}
      for i1, v1 in ipairs(buildingCA.createQuestList) do
        local serverInfo = buildingInfo[strId] and buildingInfo[strId][tostring(v1.id)] or {}
        local tempPond = {}
        tempPond.id = v1.id
        tempPond.curExpel = serverInfo and serverInfo.expel_num or 0
        local pondCA = PlayerData:GetFactoryData(v1.id)
        tempPond.maxExpel = pondCA.expelNum
        tempPond.seriesName = pondCA.seriesName
        t.curExpel = t.curExpel + tempPond.curExpel
        t.maxExpel = t.maxExpel + tempPond.maxExpel
        table.insert(t.ponds, tempPond)
      end
      table.insert(DataModel.showExpelInfo, t)
      curExpel = curExpel + t.curExpel
      maxExpel = maxExpel + t.maxExpel
    end
  end
  DataModel.totalExpelPercent = math.floor(curExpel / maxExpel * 100)
end

function DataModel.InitBattleCenterInfo()
  if #DataModel.showBattleInfo > 0 then
    return
  end
  local homeConfig = PlayerData:GetFactoryData(99900014)
  local curPcnt = 0
  local maxPcnt = 0
  for i, stationId in ipairs(homeConfig.stationList) do
    local stationCA = PlayerData:GetFactoryData(stationId.id)
    if stationCA.isOpen and stationCA.isHomeBattleCentre then
      local t = {}
      t.name = stationCA.name
      t.battleLevelName = stationCA.battleLevelName
      t.cityMapIconPath = stationCA.cityMapIconPath
      t.curPcnt = 0
      t.maxPcnt = #stationCA.battleLevelList
      for i1, battleLevelId in ipairs(stationCA.battleLevelList) do
        if PlayerData:GetLevelPass(battleLevelId.id) then
          t.curPcnt = t.curPcnt + 1
        end
      end
      table.insert(DataModel.showBattleInfo, t)
      curPcnt = curPcnt + t.curPcnt
      maxPcnt = maxPcnt + t.maxPcnt
    end
  end
  DataModel.totalBattlePercent = math.floor(curPcnt / maxPcnt * 100)
end

return DataModel
