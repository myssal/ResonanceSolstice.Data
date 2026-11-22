local DataModel = {
  RoomTypeId = 0,
  RoomLevel = 1,
  RoomTypeCfg = {},
  RoomLevelCfg = {},
  FormulaList = {},
  PlacedPrisonerList = {},
  BackupPrisonerList = {},
  SelectFormulaId = 0,
  CurPower = 0,
  MaxPower = 0,
  LevelPrisonerCountCache = {},
  PrisonerPersonalityList = {},
  PrisonerSpecialityList = {},
  allPrisoner = {},
  SelectPrisoner = {},
  filterPrisoner = {},
  SortFilterPrisoner = {},
  PrisonerUid2Plant = {},
  PrisonerUid2RoomPos = {},
  PrisonerUid2Monitor = {},
  PrisonerUid2CurMaterialPlaced = {},
  PrisonerUid2OtherMaterialPlaced = {},
  PrisonerUid2CurMaterialBackup = {},
  PrisonerUid2OtherMaterialBackup = {},
  PrisonerFilter = nil,
  PrisonerSort = nil,
  PrisonerSortState = nil,
  SortState = {
    index = 1,
    currentBtn = nil,
    currentDown = true
  },
  PrisonerState = {
    Free = 1,
    InPrepare = 2,
    InProduct = 3,
    InPunish = 4,
    InMedical = 5
  },
  BatchNum = 0,
  IsInProduct = false,
  TimeCount = {},
  PrisonerTab = 1,
  JumpFormulaId = 0
}

function DataModel.InitData()
  DataModel.PrisonerTab = 1
  DataModel.RoomTypeCfg = PlayerData:GetFactoryData(DataModel.RoomTypeId)
  local serverBuildList = PrisonData.GetBuildList()
  local serverData = serverBuildList[tostring(DataModel.RoomTypeId)]
  DataModel.RoomLevel = serverData.lv or 0
  if DataModel.RoomLevel == 0 then
    UIManager:GoBack()
  end
  DataModel.RoomLevelCfg = PlayerData:GetFactoryData(DataModel.RoomTypeCfg.roomList[DataModel.RoomLevel].config)
  DataModel.PlacedPrisonerList = {}
  DataModel.SelectPrisoner = {}
  DataModel.FormulaList = {}
  local curLevelUnlockCount = #DataModel.RoomLevelCfg.formulaList
  local maxLevelCfg = PlayerData:GetFactoryData(DataModel.RoomTypeCfg.roomList[#DataModel.RoomTypeCfg.roomList].config)
  for i, v in ipairs(maxLevelCfg.formulaList) do
    local row = {
      id = v.id,
      unlock = DataModel.CheckFormulaUnlock(v.id)
    }
    table.insert(DataModel.FormulaList, row)
  end
  DataModel.MaxPower = PrisonData.GetCurPower()
  DataModel.LevelPrisonerCountCache = {}
  for i, v in ipairs(DataModel.RoomTypeCfg.roomList) do
    DataModel.LevelPrisonerCountCache[i] = PlayerData:GetFactoryData(DataModel.RoomTypeCfg.roomList[i].config).prisonerNum
  end
  DataModel.InitPrisonerData()
  DataModel.CheckProductState()
  if DataModel.IsInProduct then
    for i, v in ipairs(DataModel.FormulaList) do
      if v.id == tonumber(DataModel.GetRoomData().formula_group_id) then
        DataModel.SelectFormulaId = v.id
        break
      end
    end
  else
    local roomData = DataModel.GetRoomData()
    local hasFormula = false
    if roomData then
      if roomData.formula_group_id and roomData.formula_group_id ~= "" then
        if 0 < roomData.st_ts then
          hasFormula = true
        end
        DataModel.SelectFormulaId = tonumber(roomData.formula_group_id)
      else
        DataModel.SelectFormulaId = DataModel.FormulaList[1].id
      end
    else
      DataModel.SelectFormulaId = DataModel.FormulaList[1].id
    end
    if 0 < DataModel.JumpFormulaId and not hasFormula then
      if not DataModel.CheckFormulaUnlock(DataModel.JumpFormulaId) then
        CommonTips.OpenTips(80608624)
      end
      DataModel.SelectFormulaId = DataModel.JumpFormulaId
    end
  end
  DataModel.JumpFormulaId = 0
end

function DataModel.InitPrisonerData()
  DataModel.allPrisoner = {}
  local allPrisonerCache = Clone(PlayerData.ServerData.user_prison_info.prison_backpack)
  local serverFrontData = PlayerData.ServerData.user_prison_info.workshops_front
  DataModel.PrisonerUid2RoomPos = {}
  for roomIndex, data in pairs(serverFrontData) do
    for posIndex, worker in pairs(data) do
      if worker ~= "" then
        DataModel.PrisonerUid2RoomPos[worker] = {room = roomIndex, pos = posIndex}
      end
    end
  end
  DataModel.PrisonerUid2Monitor = {}
  local serverMonitorData = PlayerData.ServerData.user_prison_info.workshops_master
  for roomIndex, uid in pairs(serverMonitorData) do
    DataModel.PrisonerUid2Monitor[uid] = {room = roomIndex}
  end
  DataModel.PrisonerUid2Plant = {}
  local serverPlantData = PlayerData.ServerData.user_prison_info.workshops_product_plant
  for roomIndex, data in pairs(serverPlantData) do
    for posIndex, detail in pairs(data) do
      local curPlacePid = serverFrontData[roomIndex][posIndex] or ""
      if curPlacePid and curPlacePid ~= "" and curPlacePid ~= detail.u_pid then
        DataModel.PrisonerUid2Plant[curPlacePid] = true
      else
        DataModel.PrisonerUid2Plant[detail.u_pid] = true
      end
    end
  end
  DataModel.PrisonerUid2CurMaterialPlaced = {}
  DataModel.PrisonerUid2OtherMaterialPlaced = {}
  local serverMaterialsData = PlayerData.ServerData.user_prison_info.raw_material_workshops or {}
  for roomType, roomData in pairs(serverMaterialsData) do
    if roomData.u_pid_list and table.count(roomData.u_pid_list) > 0 then
      if tonumber(roomType) ~= tonumber(DataModel.RoomTypeId) then
        for index, u_pid in ipairs(roomData.u_pid_list or {}) do
          DataModel.PrisonerUid2OtherMaterialPlaced[u_pid] = {
            isWorking = roomData.start_ts and 0 < roomData.start_ts
          }
        end
      else
        for index, u_pid in ipairs(roomData.u_pid_list or {}) do
          DataModel.PrisonerUid2CurMaterialPlaced[u_pid] = {
            isWorking = roomData.start_ts and 0 < roomData.start_ts
          }
        end
      end
    end
  end
  DataModel.PrisonerUid2CurMaterialBackup = {}
  DataModel.PrisonerUid2OtherMaterialBackup = {}
  for roomType, roomData in pairs(serverMaterialsData) do
    if roomData.pre_u_pid_list and 0 < table.count(roomData.pre_u_pid_list) then
      if tonumber(roomType) ~= tonumber(DataModel.RoomTypeId) then
        for index, u_pid in ipairs(roomData.pre_u_pid_list or {}) do
          DataModel.PrisonerUid2OtherMaterialBackup[u_pid] = true
        end
      else
        for index, u_pid in ipairs(roomData.pre_u_pid_list or {}) do
          DataModel.PrisonerUid2CurMaterialBackup[u_pid] = true
        end
      end
    end
  end
  for i, v in pairs(allPrisonerCache) do
    if DataModel.CheckPrisonerIsInTime(i) then
      v.u_pid = i
      v.id = tonumber(v.prisoner_id)
      local cfg = PlayerData:GetFactoryData(v.id)
      v.workingIdx = DataModel.SearchPrisonerWorkingInt(v.u_pid)
      v.personalityIdx = DataModel.SearchPrisonerPersonalityInt(v.personality_id)
      v.rarityIdx = DataModel.SearchPrisonerRarityInt(cfg.prisonerRarity)
      v.specialityIdx = DataModel.SearchPrisonerSpecialityInt(v.speciality_id)
      v.remainTime = DataModel.CalcPrisonerRemainTime(v.u_pid)
      v.extraOutputProbability = cfg.extraOutputProbability
      DataModel.allPrisoner[v.u_pid] = v
    end
  end
end

function DataModel.GetRoomData()
  return PlayerData.ServerData.user_prison_info.raw_material_workshops[tostring(DataModel.RoomTypeId)]
end

function DataModel.UpdateRoomData(data)
  for i, v in pairs(data) do
    if PlayerData.ServerData.user_prison_info and PlayerData.ServerData.user_prison_info.raw_material_workshops then
      PlayerData.ServerData.user_prison_info.raw_material_workshops[tostring(i)] = v
    end
  end
  DataModel.InitCurPlacedData()
  DataModel.InitCurBackupData()
end

function DataModel.GetNextUnlockPrisonerLevel()
  local curPrisonerCount = DataModel.RoomLevelCfg.prisonerNum
  for i = DataModel.RoomLevel, #DataModel.RoomTypeCfg.roomList do
    if curPrisonerCount < DataModel.LevelPrisonerCountCache[i] then
      return i
    end
  end
  return -1
end

function DataModel.CalPrisonerCost()
  local cost = 0
  local formulaCfg = PlayerData:GetFactoryData(DataModel.SelectFormulaId)
  local perCost = formulaCfg.costList[1].num
  local prisonerCount = table.count(DataModel.PlacedPrisonerList)
  cost = perCost * prisonerCount
  return cost
end

function DataModel.CalcPrisonerRemainTime(u_pid)
  if not u_pid then
    return -1
  end
  local pData = PrisonData.GetPrisoner(u_pid)
  if not pData then
    return -1
  end
  local remainSec = math.floor(pData.imprisonment_ts + pData.days * 86400 - TimeUtil:GetServerTimeStamp())
  return remainSec
end

function DataModel.CalExpectProductCountAndTime()
  if DataModel.SelectFormulaId == 0 or table.count(DataModel.PlacedPrisonerList) == 0 or DataModel.GetStorageCoin() == 0 then
    return 0, 0
  end
  local formulaCfg = PlayerData:GetFactoryData(DataModel.SelectFormulaId)
  local perCost = formulaCfg.costList[1].num
  local perTime = formulaCfg.programmeList[1].count * formulaCfg.perTime * 60
  local prisonerCount = table.count(DataModel.PlacedPrisonerList)
  local canProductCount = DataModel.GetStorageCoin() // (perCost * prisonerCount)
  return canProductCount * formulaCfg.perNum, canProductCount * perTime
end

function DataModel.GetPrisonerState(u_pid)
  if DataModel.PrisonerUid2Plant[u_pid] then
    return DataModel.PrisonerState.InProduct
  end
  if PrisonData.IsIllHappen(tostring(u_pid)) then
    return DataModel.PrisonerState.InMedical
  end
  if DataModel.PrisonerUid2RoomPos[u_pid] then
    local data = DataModel.PrisonerUid2RoomPos[u_pid]
    if PrisonData.IsAccidentHappen(data.room, data.pos) then
      return DataModel.PrisonerState.InProduct
    end
    return DataModel.PrisonerState.InPrepare
  end
  if DataModel.PrisonerUid2OtherMaterialBackup[u_pid] then
    return DataModel.PrisonerState.InProduct
  end
  if DataModel.PrisonerUid2CurMaterialPlaced[u_pid] then
    return DataModel.PrisonerUid2CurMaterialPlaced[u_pid].isWorking and DataModel.PrisonerState.InProduct or DataModel.PrisonerState.InPrepare
  end
  if DataModel.PrisonerUid2OtherMaterialPlaced[u_pid] then
    return DataModel.PrisonerUid2OtherMaterialPlaced[u_pid].isWorking and DataModel.PrisonerState.InProduct or DataModel.PrisonerState.InPrepare
  end
  if PlayerData.ServerData.user_prison_info.detention_room and PlayerData.ServerData.user_prison_info.detention_room[tostring(u_pid)] ~= nil then
    return DataModel.PrisonerState.InPunish
  end
  if PlayerData.ServerData.user_prison_info.medical_room and PlayerData.ServerData.user_prison_info.medical_room_temporary and (PlayerData.ServerData.user_prison_info.medical_room[tostring(u_pid)] ~= nil or PlayerData.ServerData.user_prison_info.medical_room_temporary[tostring(u_pid)] ~= nil) then
    return DataModel.PrisonerState.InMedical
  end
  return DataModel.PrisonerState.Free
end

function DataModel.GetStorageCoin()
  local roomData = DataModel.GetRoomData(tostring(DataModel.RoomTypeId))
  return roomData and roomData.gold or 0
end

function DataModel.CheckProductState()
  local roomData = DataModel.GetRoomData()
  DataModel.IsInProduct = roomData and roomData.start_ts > 0
  return DataModel.IsInProduct
end

function DataModel.CheckPrisonerIsInTime(u_pid)
  return true
end

function DataModel.InitCurPlacedData()
  DataModel.PrisonerUid2CurMaterialPlaced = {}
  local serverMaterialsData = PlayerData.ServerData.user_prison_info.raw_material_workshops or {}
  for roomType, roomData in pairs(serverMaterialsData) do
    if roomData.u_pid_list and table.count(roomData.u_pid_list) > 0 and tonumber(roomType) == tonumber(DataModel.RoomTypeId) then
      for index, u_pid in ipairs(roomData.u_pid_list) do
        DataModel.PrisonerUid2CurMaterialPlaced[u_pid] = {
          isWorking = roomData.start_ts and 0 < roomData.start_ts
        }
      end
    end
  end
end

function DataModel.InitCurBackupData()
  DataModel.PrisonerUid2CurMaterialBackup = {}
  local serverMaterialsData = PlayerData.ServerData.user_prison_info.raw_material_workshops or {}
  for roomType, roomData in pairs(serverMaterialsData) do
    if roomData.pre_u_pid_list and table.count(roomData.pre_u_pid_list) > 0 and tonumber(roomType) == tonumber(DataModel.RoomTypeId) then
      for index, u_pid in ipairs(roomData.pre_u_pid_list) do
        DataModel.PrisonerUid2CurMaterialBackup[u_pid] = true
      end
    end
  end
end

function DataModel.CheckFormulaUnlock(id)
  if not PlayerData.ServerData.user_prison_info.rooms or not PlayerData.ServerData.user_prison_info.rooms[tostring(87500010)] then
    return false
  end
  local curShopLevel = PlayerData.ServerData.user_prison_info.rooms[tostring(87500010)].lv
  local shopLevelCfg = PlayerData:GetFactoryData(PlayerData:GetFactoryData(87500010).roomList[curShopLevel].config)
  if shopLevelCfg then
    for i, v in ipairs(shopLevelCfg.unlockFormulaList) do
      if v.id == id then
        return true
      end
    end
  end
  return false
end

function DataModel.SearchPrisonerWorkingInt(u_pid)
  local state = DataModel.GetPrisonerState(u_pid)
  if state == DataModel.PrisonerState.Free then
    return 1
  elseif state == DataModel.PrisonerState.InPrepare then
    return 2
  end
  return 3
end

function DataModel.SearchPrisonerPersonalityInt(personalityId)
  personalityId = tonumber(personalityId)
  if table.count(DataModel.PrisonerPersonalityList) == 0 then
    DataModel.PrisonerPersonalityList = PlayerData:GetFactoryData(99900017).prisonPersonalityNameList
  end
  for k, v in pairs(DataModel.PrisonerPersonalityList) do
    if v.id == personalityId then
      return k
    end
  end
  return -1
end

function DataModel.SearchPrisonerSpecialityInt(specialityId)
  if table.count(DataModel.PrisonerSpecialityList) == 0 then
    DataModel.PrisonerSpecialityList = PlayerData:GetFactoryData(99900017).prisonSpecialityList
  end
  for k, v in pairs(DataModel.PrisonerSpecialityList) do
    if tonumber(v.id) == tonumber(specialityId) then
      return k
    end
  end
  return -1
end

function DataModel.SearchPrisonerRarityInt(rarityId)
  local config = {
    [1] = {id = 12601046},
    [2] = {id = 12601047},
    [3] = {id = 12601048}
  }
  for i, v in ipairs(config) do
    if rarityId == v.id then
      return i
    end
  end
  return -1
end

function DataModel.NumFloorPrecision(num)
  local a, b = math.modf(num)
  if 0 <= num then
    if b + 1.0E-4 > 1 then
      a = a + 1
    else
      return a
    end
  elseif b - 1.0E-4 < -1 then
    a = a - 1
  else
    return a
  end
  return a
end

function DataModel.NumRound(num)
  if 0 < num then
    return DataModel.NumFloorPrecision(num + 0.5)
  elseif num < 0 then
    return DataModel.NumFloorPrecision(num - 0.5)
  end
  return 0
end

return DataModel
