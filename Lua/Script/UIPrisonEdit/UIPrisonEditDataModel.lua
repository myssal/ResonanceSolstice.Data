local DataModel = {
  workMachineInfo = {},
  workPrisonerInfo = {},
  roomProgrammeInfo = {},
  designRowCount = 3,
  designColCount = 6,
  allMachine = {},
  allPrisoner = {},
  filterPrisoner = {},
  SortFilterPrisoner = {},
  monitorData = {},
  ProductPlantData = {},
  machineCellSize = {x = 300, y = 180},
  machineTypes = {},
  CurRoomIndex = 1,
  curChoosePosIndex = -1,
  UnlockGridCountData = {},
  TotalRoomCount = 0,
  PrisonerPersonalityList = {},
  PrisonerSpecialityList = {},
  CurSelectWorkerIndex = 1,
  roomEditDirty = {},
  roomProgrammeDirty = {},
  CountDownHandler = {},
  PrisonerFilter = nil,
  PrisonerSort = nil,
  PrisonerSortState = nil,
  SortState = {
    index = 1,
    currentBtn = nil,
    currentDown = true
  },
  SelectPrisonerPid2Index = {},
  SelectPrisonerIndex2Pid = {},
  IsQuickSquad = false,
  isFirst = true,
  MaterialWorkingCache = {},
  PrisonerState = {
    Free = 1,
    InPrepare = 2,
    InProduct = 3,
    InPunish = 4,
    InMedical = 5
  },
  MachineLevelCache = {},
  UpgradeEffList = {},
  UpgradeCostList = {}
}

function DataModel.InitData()
  for i, v in pairs(DataModel.UpgradeEffList) do
    Object.Destroy(v)
  end
  DataModel.UpgradeEffList = {}
  DataModel.UpgradeCostList = {}
  DataModel.roomEditDirty = {}
  DataModel.TotalRoomCount = table.count(PrisonData.GetProductRoomList())
  DataModel.InitRoomUnlockCount()
  DataModel.allPrisoner = {}
  local serverPData = Clone(PrisonData.GetPrisonPrisoners())
  for i, v in pairs(serverPData) do
    if DataModel.CheckPrisonerIsInTime(i) then
      v.u_pid = i
      v.id = tonumber(v.prisoner_id)
      local cfg = PlayerData:GetFactoryData(v.id)
      v.personalityIdx = DataModel.SearchPrisonerPersonalityInt(v.personality_id)
      v.rarityIdx = DataModel.SearchPrisonerRarityInt(cfg.prisonerRarity)
      v.specialityIdx = DataModel.SearchPrisonerSpecialityInt(v.speciality_id)
      v.monitor = cfg.monitor
      v.remainTime = DataModel.CalcPrisonerRemainTime(v.u_pid)
      v.extraOutputProbability = cfg.extraOutputProbability
      DataModel.allPrisoner[v.u_pid] = v
    end
  end
  DataModel.workMachineInfo = {}
  local totalCellCount = DataModel.designRowCount * DataModel.designColCount
  for i = 1, DataModel.TotalRoomCount do
    DataModel.workMachineInfo[i] = {}
    DataModel.workPrisonerInfo[i] = {}
    for j = 1, totalCellCount do
      DataModel.workMachineInfo[i][j] = ""
      DataModel.workPrisonerInfo[i][j] = ""
    end
  end
  DataModel.monitorData = {}
  for i = 1, DataModel.TotalRoomCount do
    DataModel.monitorData[i] = ""
  end
  local masterServerData = Clone(PrisonData.GetPrisonMasterList())
  for i, v in pairs(masterServerData) do
    if DataModel.CheckPrisonerIsInTime(v) then
      DataModel.monitorData[tonumber(i)] = v
    end
  end
  DataModel.InitMachineLevelCache()
  DataModel.InitProgrammeData()
  DataModel.InitMachineData()
  DataModel.InitPrisonerData()
  DataModel.InitPlantData()
  DataModel.InitMaterialWorkingCache()
end

function DataModel.InitMachineLevelCache()
  DataModel.MachineLevelCache = {}
  local roomListCfg = PlayerData:GetFactoryData(87500010).roomList
  for i, v in ipairs(roomListCfg) do
    local roomCfg = PlayerData:GetFactoryData(v.config)
    if DataModel.MachineLevelCache[tonumber(roomCfg.unlockMachineList[1].id)] == nil then
      DataModel.MachineLevelCache[tonumber(roomCfg.unlockMachineList[1].id)] = i
    end
  end
end

function DataModel.InitProgrammeData()
  DataModel.roomProgrammeInfo = {}
  local serverProgrammeData = PlayerData.ServerData.user_prison_info.workshops_programme
  for i = 1, DataModel.TotalRoomCount do
    DataModel.roomProgrammeInfo[tostring(i)] = serverProgrammeData[tostring(i)] == nil and "1" or serverProgrammeData[tostring(i)]
  end
end

function DataModel.InitMachineData()
  local serverData = PlayerData.ServerData.user_prison_info.furniture
  if serverData then
    for i, v in pairs(serverData) do
      v.u_fid = i
      v.id = tonumber(v.id)
      local cfg = PlayerData:GetFactoryData(v.id)
      if cfg.isPrison then
        DataModel.allMachine[v.u_fid] = v
      end
    end
  end
  DataModel.roomMachineCount = {}
  local serverMachineData = PlayerData.ServerData.user_prison_info.workshops_furniture
  for roomIndex, data in pairs(serverMachineData) do
    local programme = DataModel.GetRoomProgramme(roomIndex)
    for posIndex, machines in pairs(data) do
      local u_fid = machines[tostring(programme)] or ""
      DataModel.SetWorkMachineInfo(roomIndex, posIndex, u_fid)
    end
  end
end

function DataModel.InitPrisonerData()
  DataModel.prisonerData = {}
  DataModel.filterPrisoner = {}
  local allPrisonerCache = Clone(DataModel.allPrisoner)
  local serverFrontData = PlayerData.ServerData.user_prison_info.workshops_front
  for roomIndex, data in pairs(serverFrontData) do
    for posIndex, worker in pairs(data) do
      if worker ~= "" then
        local pData = DataModel.allPrisoner[worker]
        if not pData then
          worker = ""
          allPrisonerCache[worker] = nil
        else
          DataModel.prisonerData[worker] = {
            roomIndex = tonumber(roomIndex),
            posIndex = tonumber(posIndex),
            server = pData
          }
          DataModel.SetWorkPrisonerInfo(roomIndex, posIndex, pData.u_pid)
          allPrisonerCache[worker] = nil
        end
      else
        DataModel.SetWorkPrisonerInfo(roomIndex, posIndex, "")
      end
    end
  end
  for pid, data in pairs(allPrisonerCache) do
    DataModel.prisonerData[pid] = {
      roomIndex = -1,
      posIndex = -1,
      server = data
    }
  end
end

function DataModel.InitPlantData()
  DataModel.ProductPlantData = {}
  local serverPlantData = PlayerData.ServerData.user_prison_info.workshops_product_plant
  for roomIndex, roomData in pairs(serverPlantData) do
    for posIndex, data in pairs(roomData) do
      local row = {
        formulaGroupId = data.formula_group_id,
        count = data.count,
        startTime = data.start_ts,
        speedTime = data.speed_ts,
        sts = data.sts,
        tts = data.tts
      }
      if not DataModel.ProductPlantData[tostring(roomIndex)] then
        DataModel.ProductPlantData[tostring(roomIndex)] = {}
      end
      DataModel.ProductPlantData[tostring(roomIndex)][tostring(posIndex)] = row
    end
  end
end

function DataModel.InitMaterialWorkingCache()
  DataModel.MaterialWorkingCache = {}
  local serverMaterialData = PlayerData.ServerData.user_prison_info.raw_material_workshops or {}
  for roomType, roomData in pairs(serverMaterialData) do
    if roomData.u_pid_list and table.count(roomData.u_pid_list) > 0 then
      for index, u_pid in ipairs(roomData.u_pid_list) do
        DataModel.MaterialWorkingCache[u_pid] = {
          isWorking = roomData.start_ts and 0 < roomData.start_ts
        }
      end
    end
    if roomData.pre_u_pid_list and 0 < table.count(roomData.pre_u_pid_list) then
      for index, u_pid in ipairs(roomData.pre_u_pid_list) do
        DataModel.MaterialWorkingCache[u_pid] = {isWorking = true}
      end
    end
  end
end

function DataModel.InitRoomUnlockCount()
  DataModel.UnlockGridCountData = {}
  local TotalRoomCount = table.count(PrisonData.GetProductRoomList())
  for i = 1, TotalRoomCount do
    DataModel.UnlockGridCountData[i] = PrisonData.GetRoomData(i) ~= nil and table.count(PrisonData.GetRoomData(i)) or 0
  end
end

function DataModel.GetUnlockGridCount(roomIndex)
  roomIndex = roomIndex or DataModel.CurRoomIndex
  local unlockGridCount = DataModel.UnlockGridCountData[tonumber(roomIndex)] or 0
  return unlockGridCount
end

function DataModel.HasWorkingMachine(roomIndex, posIndex)
  return DataModel.GetWorkMachineUid(roomIndex, posIndex) ~= ""
end

function DataModel.HasWorkingPrisoner(roomIndex, posIndex)
  return DataModel.GetWorkPrisonerUid(roomIndex, posIndex) ~= ""
end

function DataModel.GetWorkMachineUid(roomIndex, posIndex)
  return DataModel.workMachineInfo[tonumber(roomIndex)][tonumber(posIndex)] or ""
end

function DataModel.GetWorkMachineInfo(roomIndex, posIndex)
  local u_fid = DataModel.GetWorkMachineUid(roomIndex, posIndex)
  return DataModel.GetMachineDataByUid(u_fid)
end

function DataModel.GetWorkPrisonerUid(roomIndex, posIndex)
  return DataModel.workPrisonerInfo[tonumber(roomIndex)][tonumber(posIndex)] or ""
end

function DataModel.GetWorkPrisonerInfo(roomIndex, posIndex)
  local u_pid = DataModel.workPrisonerInfo[tonumber(roomIndex)][tonumber(posIndex)] or ""
  return DataModel.GetPrisonerDataByUid(u_pid)
end

function DataModel.SetWorkMachineInfo(roomIndex, posIndex, u_fid)
  DataModel.workMachineInfo[tonumber(roomIndex)][tonumber(posIndex)] = u_fid
end

function DataModel.SetWorkPrisonerInfo(roomIndex, posIndex, u_pid)
  DataModel.workPrisonerInfo[tonumber(roomIndex)][tonumber(posIndex)] = u_pid
end

function DataModel.GetMachineDataByUid(u_fid)
  return DataModel.allMachine[u_fid]
end

function DataModel.GetPrisonerDataByUid(u_pid)
  if not u_pid or u_pid == "" then
    return {}
  end
  return DataModel.prisonerData[u_pid].server or {}
end

function DataModel.GetRoomProgramme(roomIndex)
  roomIndex = roomIndex or DataModel.CurRoomIndex
  return DataModel.roomProgrammeInfo[tostring(roomIndex)] or "1"
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

function DataModel.PrisonerToWork(u_pid, toIdx, needKeepMonitor)
  if not u_pid or toIdx == -1 then
    return false
  end
  local roomIndex, posIndex = DataModel.GetPrisonerWorkingRoomAndPos(u_pid)
  local isWorking = roomIndex ~= -1 and posIndex ~= -1
  if isWorking then
    DataModel.SetWorkPrisonerInfo(roomIndex, posIndex, "")
    if DataModel.IsRoomMonitor(u_pid, tonumber(roomIndex)) and roomIndex ~= DataModel.CurRoomIndex then
      DataModel.monitorData[tonumber(roomIndex)] = ""
    end
    DataModel.SetDirty(roomIndex)
  end
  local curPrisoner = DataModel.GetWorkPrisonerInfo(DataModel.CurRoomIndex, toIdx)
  if next(curPrisoner) ~= nil then
    if DataModel.IsRoomMonitor(curPrisoner.u_pid) and not needKeepMonitor then
      DataModel.monitorData[DataModel.CurRoomIndex] = ""
    end
    DataModel.prisonerData[curPrisoner.u_pid].roomIndex = -1
    DataModel.prisonerData[curPrisoner.u_pid].posIndex = -1
    DataModel.SetWorkPrisonerInfo(DataModel.CurRoomIndex, toIdx, "")
  end
  DataModel.prisonerData[u_pid].roomIndex = DataModel.CurRoomIndex
  DataModel.prisonerData[u_pid].posIndex = toIdx
  DataModel.SetWorkPrisonerInfo(DataModel.CurRoomIndex, toIdx, u_pid)
  DataModel.SetDirty()
  return true
end

function DataModel.PrisonerToRest(u_pid, idx, needKeepMonitor)
  if not u_pid or idx == -1 or u_pid == "" then
    return false
  end
  DataModel.SetWorkPrisonerInfo(DataModel.CurRoomIndex, idx, "")
  DataModel.prisonerData[u_pid].roomIndex = -1
  DataModel.prisonerData[u_pid].posIndex = -1
  if DataModel.IsRoomMonitor(u_pid) and not needKeepMonitor then
    DataModel.monitorData[DataModel.CurRoomIndex] = ""
  end
  DataModel.SetDirty()
  return true
end

function DataModel.GetPrisonerWorkingRoomAndPos(pid)
  if not pid then
    return -1, -1
  end
  if not DataModel.prisonerData[pid] then
    return -1, -1
  end
  return DataModel.prisonerData[pid].roomIndex, DataModel.prisonerData[pid].posIndex
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

function DataModel.IsRoomMonitor(pid, roomIndex)
  roomIndex = roomIndex or DataModel.CurRoomIndex
  local curMonitorPid = DataModel.monitorData[roomIndex] or ""
  return curMonitorPid == pid and curMonitorPid ~= ""
end

function DataModel.SetDirty(roomIndex)
  roomIndex = roomIndex or DataModel.CurRoomIndex
  if not DataModel.roomEditDirty[tostring(roomIndex)] then
    DataModel.roomEditDirty[tostring(roomIndex)] = true
  end
end

function DataModel.CheckNextAreaCanUnlock()
  local lv = PrisonData.GetPrisonLv()
  local cfg = PlayerData:GetFactoryData("86800014").lvList[lv]
  if not cfg then
    return false
  end
  if DataModel.CurRoomIndex > cfg.workshopNum then
    return false
  end
  local targetLockArea
  local roomData = PrisonData.GetRoomData(DataModel.CurRoomIndex)
  local unlockAreaCount = table.count(roomData) // 3
  if 6 <= unlockAreaCount then
    return false
  end
  targetLockArea = unlockAreaCount + 1
  local idx = (DataModel.CurRoomIndex - 1) * 6 + targetLockArea
  return idx <= cfg.SpaceNum, targetLockArea
end

function DataModel.PosIsWorking(roomIndex, posIndex)
  local hasPlant = DataModel.IsWorkPlaceHasPlant(roomIndex, posIndex)
  return hasPlant
end

function DataModel.CheckPrisonerIsInTime(u_pid)
  return true
end

function DataModel.GetRoomPrisonerCount(roomIndex)
  local count = 0
  if not DataModel.workPrisonerInfo[roomIndex] then
    return 0
  end
  local unlockGridCount = DataModel.GetUnlockGridCount(roomIndex)
  for i = 1, unlockGridCount do
    if DataModel.HasWorkingPrisoner(roomIndex, i) then
      count = count + 1
    end
  end
  return count
end

function DataModel.UpdateMachineData(u_fid)
  local furData = Clone(PlayerData.ServerData.user_prison_info.furniture[tostring(u_fid)])
  furData.id = tonumber(furData.id)
  DataModel.allMachine[u_fid] = furData
end

function DataModel.AddDragInfo(id, isMachine)
  local info = {}
  local cfg = PlayerData:GetFactoryData(id)
  if cfg then
    if isMachine then
      info.thumbnail = cfg.iconPath
    else
      info.thumbnail = cfg.prisonerIconPath
    end
  end
  return info
end

function DataModel.SwapPrison(dragIdx, toIdx)
  if not DataModel.HasWorkingMachine(DataModel.CurRoomIndex, toIdx) then
    return false
  end
  if not DataModel.HasWorkingPrisoner(DataModel.CurRoomIndex, dragIdx) and not DataModel.HasWorkingPrisoner(DataModel.CurRoomIndex, toIdx) then
    return false
  end
  local pid1 = DataModel.GetWorkPrisonerUid(DataModel.CurRoomIndex, dragIdx)
  local pid2 = DataModel.GetWorkPrisonerUid(DataModel.CurRoomIndex, toIdx)
  DataModel.SetWorkPrisonerInfo(DataModel.CurRoomIndex, dragIdx, pid2)
  DataModel.SetWorkPrisonerInfo(DataModel.CurRoomIndex, toIdx, pid1)
  if pid1 ~= "" then
    DataModel.prisonerData[pid1].posIndex = toIdx
  end
  if pid2 ~= "" then
    DataModel.prisonerData[pid2].posIndex = dragIdx
  end
  DataModel.SetDirty()
  return true
end

function DataModel.IsWorkPlaceHasPlant(roomIndex, posIndex)
  if not (roomIndex and posIndex) or roomIndex < 0 or posIndex < 0 then
    return false
  end
  local plantData = DataModel.ProductPlantData[tostring(roomIndex)]
  if plantData and plantData[tostring(posIndex)] then
    local data = plantData[tostring(posIndex)]
    local perCountTimeCost = PlayerData:GetFactoryData(data.formulaGroupId).perTime * 60
    local totalCostTime = perCountTimeCost * data.count
    local finishTime = data.startTime + totalCostTime - data.speedTime
    local remainTime = finishTime - TimeUtil:GetServerTimeStamp()
    return true, remainTime <= 0, remainTime
  end
  return false
end

function DataModel.GetWorkPlacePlantData(roomIndex, posIndex)
  if not DataModel.ProductPlantData[tostring(roomIndex)] then
    return nil
  end
  return DataModel.ProductPlantData[tostring(roomIndex)][tostring(posIndex)]
end

function DataModel.CalWorkerPlaceProductNum(posIndex)
  local plantData = DataModel.GetWorkPlacePlantData(DataModel.CurRoomIndex, posIndex)
  if not plantData then
    return 0
  end
  local formulaGroupCfg = PlayerData:GetFactoryData(plantData.formulaGroupId)
  local workTime = PrisonData.GetProductWorkTime(DataModel.CurRoomIndex, posIndex)
  local count = math.floor(workTime / (formulaGroupCfg.perTime * 60)) * formulaGroupCfg.perNum
  return count
end

function DataModel.GetRemainProductTime(roomIndex, posIndex)
  local hasPlant, isFinish, remainTime = DataModel.IsWorkPlaceHasPlant(roomIndex, posIndex)
  if not hasPlant then
    return -1
  elseif isFinish then
    return -1
  end
  return remainTime
end

function DataModel.GetPrisonerState(u_pid)
  local room, pos = DataModel.GetPrisonerWorkingRoomAndPos(u_pid)
  if 0 < room and 0 < pos then
    local hasPlant = DataModel.IsWorkPlaceHasPlant(room, pos)
    if hasPlant then
      return DataModel.PrisonerState.InProduct
    else
      return DataModel.PrisonerState.InPrepare
    end
    if PrisonData.IsAccidentHappen(room, pos) then
      return DataModel.PrisonerState.InProduct
    end
  end
  if DataModel.MaterialWorkingCache[u_pid] then
    return DataModel.MaterialWorkingCache[u_pid].isWorking and DataModel.PrisonerState.InProduct or DataModel.PrisonerState.InPrepare
  end
  if PlayerData.ServerData.user_prison_info.detention_room and PlayerData.ServerData.user_prison_info.detention_room[tostring(u_pid)] ~= nil then
    return DataModel.PrisonerState.InPunish
  end
  if PlayerData.ServerData.user_prison_info.medical_room and PlayerData.ServerData.user_prison_info.medical_room_temporary and (PlayerData.ServerData.user_prison_info.medical_room[tostring(u_pid)] ~= nil or PlayerData.ServerData.user_prison_info.medical_room_temporary[tostring(u_pid)] ~= nil) then
    return DataModel.PrisonerState.InMedical
  end
  if PrisonData.IsIllHappen(tostring(u_pid)) then
    return DataModel.PrisonerState.InMedical
  end
  return DataModel.PrisonerState.Free
end

function DataModel.CheckRoomCanEnter(roomIndex)
  if roomIndex < 1 or roomIndex > DataModel.TotalRoomCount then
    return
  end
  local unlockGridCount = DataModel.GetUnlockGridCount(roomIndex)
  for i = 1, unlockGridCount do
    if not DataModel.IsWorkPlaceHasPlant(roomIndex, i) then
      return true, i
    end
  end
  return false
end

return DataModel
