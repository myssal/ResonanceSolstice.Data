local DataModel = {
  Level = 0,
  Exp = 0,
  CurSelectLevel = 0,
  MaxLevel = 0,
  DesDefaultList = {},
  DesNotDefaultList = {},
  DeltaData = {},
  LevelRewardGetData = {},
  OverviewPanelData = {},
  LevelRewardData = {},
  RoomLevelCache = {}
}

function DataModel.InitData()
  DataModel.LevelRewardGetData = {}
  local serverLvReward = PlayerData.ServerData.user_prison_info.lv_reward
  for i, v in ipairs(serverLvReward) do
    DataModel.LevelRewardGetData[v] = true
  end
  DataModel.Level = PrisonData.GetPrisonLv()
  DataModel.Exp = PlayerData.ServerData.user_prison_info.exp
  DataModel.CurSelectLevel = DataModel.Level
  DataModel.MaxLevel = #PlayerData:GetFactoryData("86800014").lvList
  DataModel.DesDefaultList = {}
  DataModel.DesNotDefaultList = {}
  local desList = PlayerData:GetFactoryData("86800014").lvDesList
  for i, v in ipairs(desList) do
    if v.isDefault then
      local row = {
        name = v.name,
        text = PlayerData:GetFactoryData(v.textid).text
      }
      table.insert(DataModel.DesDefaultList, row)
    else
      local row = {
        name = v.name,
        text = PlayerData:GetFactoryData(v.textid).text
      }
      table.insert(DataModel.DesNotDefaultList, row)
    end
  end
  DataModel.InitRoomLevelCache()
end

function DataModel.InitRoomLevelCache()
  DataModel.RoomLevelCache = {}
  local roomsCfg = PlayerData:GetFactoryData("86800014").prison
  for i, roomId in ipairs(roomsCfg) do
    DataModel.RoomLevelCache[i] = {}
    local roomCfg = PlayerData:GetFactoryData(roomId.id)
    for index, lvData in ipairs(roomCfg.roomList) do
      local cfg = PlayerData:GetFactoryData(lvData.config)
      DataModel.RoomLevelCache[i][lvData.level] = {
        roomId = roomId.id,
        roomLevel = cfg.roomLevel
      }
    end
  end
end

function DataModel.GetPrisonLevelCfgByLevel(level)
  local cfg = PlayerData:GetFactoryData("86800014").lvList
  local levelCfg = cfg[level]
  return levelCfg
end

function DataModel.GetLevelDeltaData()
  local rlt = {}
  local record = {
    hasWorkShopNum = false,
    hasSpaceNum = false,
    hasCellNum = false,
    hasRoomNum = false
  }
  local curCfg = DataModel.GetPrisonLevelCfgByLevel(DataModel.CurSelectLevel)
  local lastCfg = DataModel.GetPrisonLevelCfgByLevel(DataModel.CurSelectLevel - 1)
  if DataModel.CurSelectLevel == 1 then
    for i, v in ipairs(DataModel.DesNotDefaultList) do
      local curValue = curCfg[v.name]
      if v.name == "machineId" then
        local curMachineCfg = PlayerData:GetFactoryData(curCfg.machineId)
        if curMachineCfg then
          local row = {
            delta = curMachineCfg.Level,
            text = string.format(GetText(80608236), curMachineCfg.name),
            isMachineDelta = true
          }
          table.insert(rlt, row)
        end
      elseif 0 < curValue then
        local row = {
          text = v.text,
          delta = curValue,
          isLevelDelta = true
        }
        if v.name == "workshopNum" then
          record.hasWorkShopNum = true
        elseif v.name == "SpaceNum" then
          record.hasSpaceNum = true
        elseif v.name == "cellNum" then
          record.hasCellNum = true
        elseif v.name == "roomNum" then
          record.hasRoomNum = true
        end
        table.insert(rlt, row)
      end
    end
  elseif curCfg and lastCfg then
    for i, v in ipairs(DataModel.DesNotDefaultList) do
      local curValue = curCfg[v.name]
      local lastValue = lastCfg[v.name]
      if v.name == "machineId" then
        local curMachineCfg = PlayerData:GetFactoryData(curCfg.machineId)
        local lastMachineCfg = PlayerData:GetFactoryData(lastCfg.machineId)
        if curMachineCfg ~= lastMachineCfg then
          local row = {
            delta = curMachineCfg.Level,
            text = string.format(GetText(80608236), curMachineCfg.name),
            isMachineDelta = true
          }
          table.insert(rlt, row)
        end
      elseif v.name == "materialWare" then
        curValue = curCfg.materialWare + curCfg.extraMaterialWare
        lastValue = lastCfg.materialWare + lastCfg.extraMaterialWare
        local row = {
          text = v.text,
          delta = curValue - lastValue,
          isLevelDelta = true
        }
        table.insert(rlt, row)
      elseif v.name == "commodityWare" then
        curValue = curCfg.commodityWare + curCfg.extraCommodityWare
        lastValue = lastCfg.commodityWare + lastCfg.extraCommodityWare
        local row = {
          text = v.text,
          delta = curValue - lastValue,
          isLevelDelta = true
        }
        table.insert(rlt, row)
      elseif 0 < curValue - lastValue then
        local row = {
          text = v.text,
          delta = curValue - lastValue,
          isLevelDelta = true
        }
        if v.name == "workshopNum" then
          record.hasWorkShopNum = true
        elseif v.name == "SpaceNum" then
          record.hasSpaceNum = true
        elseif v.name == "cellNum" then
          record.hasCellNum = true
        elseif v.name == "roomNum" then
          record.hasRoomNum = true
        end
        table.insert(rlt, row)
      end
    end
  end
  return rlt, record
end

function DataModel.GetRoomDeltaData()
  local rlt = {}
  for i, room in ipairs(DataModel.RoomLevelCache) do
    if room[DataModel.CurSelectLevel] then
      local row = {
        unlockLevel = room[DataModel.CurSelectLevel].roomLevel,
        roomId = room[DataModel.CurSelectLevel].roomId,
        isLevelDelta = false
      }
      if row.unlockLevel > 0 then
        table.insert(rlt, row)
      end
    end
  end
  return rlt
end

function DataModel.CheckHasRedPoint()
  if not PlayerData.ServerData.user_prison_info then
    return false
  end
  local serverLvReward = PlayerData.ServerData.user_prison_info.lv_reward
  local getRecord = {}
  for i, v in ipairs(serverLvReward) do
    getRecord[v] = true
  end
  local curLevel = PrisonData.GetPrisonLv()
  for i = 1, curLevel do
    if getRecord[i] == nil then
      return true
    end
  end
  return false
end

return DataModel
