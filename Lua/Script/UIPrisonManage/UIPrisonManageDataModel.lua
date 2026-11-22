local MainData = require("UIPrisonMain/PrisonData")
local DataModel = {
  workMachineInfo = {},
  workPrisonerInfo = {},
  bagMachineData = {},
  machineBagGridData = {},
  designRowCount = 3,
  designColCount = 6,
  machineTypes = {},
  machineCellSize = {x = 300, y = 180},
  curMachineTypeSelect = -1,
  isFirst = true,
  allMachine = {},
  allPrisoner = {},
  prisonerData = {},
  monitorData = {},
  filterPrisoner = {},
  workShopsData = {},
  unLockAreaCount = {},
  machineTypes = {},
  roomMachineType = {},
  roomEditDirty = {},
  PrisonerPersonalityList = {},
  PrisonerSpecialityList = {},
  curRoomIndex = 1,
  curChoosePosIndex = -1,
  totalRoomCount = 0,
  Sort = EnumDefine.EPrisonerSortType.State,
  StateSort = EnumDefine.StateSort.State,
  EfficiencySort = EnumDefine.EfficiencySort.EfficiencyDesc,
  EnergySort = EnumDefine.EnergySort.EnergyDesc,
  DayCountSort = EnumDefine.DayCountSort.DayCountDesc,
  PrisonerFilter = nil,
  PrisonerSort = nil,
  PrisonerSortState = nil,
  isDirty = false,
  PrisonerFilterTarget = 1,
  triggerEventList = {},
  CurBottomTab = -1,
  CurSelectMachineUId = "",
  CurSelectPrisonerUId = ""
}
DataModel.EDirectionType = {
  Up = 1,
  Right = 2,
  Down = 3,
  Left = 4
}
local EWorkStateType = {
  NoPlace = 1,
  Rest = 2,
  Working = 3,
  Preparing = 4
}

function DataModel.ResetPrisonerFilter()
  DataModel.PrisonerFilter = nil
  DataModel.PrisonerSort = nil
  DataModel.PrisonerSortState = nil
end

function DataModel.InitEditData()
  DataModel.CurSelectMachineUId = ""
  DataModel.CurSelectPrisonerUId = ""
  DataModel.CurBottomTab = -1
  DataModel.ResetPrisonerFilter()
  DataModel.totalRoomCount = table.count(MainData.GetProductRoomList())
  DataModel.machineTypes = {}
  local machineTypes = PlayerData:GetFactoryData(99900014).prisonMachineList
  for i, v in ipairs(machineTypes) do
    table.insert(DataModel.machineTypes, v.id)
  end
  local data = PlayerData.ServerData.user_home_info.furniture
  for i, v in pairs(data) do
    v.u_fid = i
    v.id = tonumber(v.id)
    local cfg = PlayerData:GetFactoryData(v.id)
    for index, type in ipairs(DataModel.machineTypes) do
      if cfg.type == type then
        DataModel.allMachine[v.u_fid] = v
      end
    end
  end
  local serverPData = Clone(PrisonData.GetPrisonPrisoners())
  for i, v in pairs(serverPData) do
    if DataModel.CheckPrisonerIsInTime(i) then
      v.u_pid = i
      v.id = tonumber(v.prisoner_id)
      local cfg = PlayerData:GetFactoryData(v.id)
      v.personalityIdx = DataModel.SearchPrisonerPersonalityInt(v.personality_id)
      v.rarityIdx = DataModel.SearchPrisonerRarityInt(cfg.prisonerRarity)
      v.speciality = cfg.PrisonerSpeciality
      v.specialityIdx = DataModel.SearchPrisonerSpecialityInt(cfg.PrisonerSpeciality)
      v.monitor = cfg.monitor
      v.efficiency = cfg.efficiency
      DataModel.allPrisoner[v.u_pid] = v
    end
  end
  local totalCellCount = DataModel.designRowCount * DataModel.designColCount
  for i = 1, DataModel.totalRoomCount do
    DataModel.workMachineInfo[i] = {}
    DataModel.workPrisonerInfo[i] = {}
    for j = 1, totalCellCount do
      DataModel.workMachineInfo[i][j] = ""
      DataModel.workPrisonerInfo[i][j] = ""
    end
  end
  DataModel.monitorData = {}
  for i = 1, DataModel.totalRoomCount do
    DataModel.monitorData[i] = ""
  end
  local masterServerData = Clone(PrisonData.GetPrisonMasterList())
  for i, v in pairs(masterServerData) do
    if DataModel.CheckPrisonerIsInTime(v) then
      DataModel.monitorData[tonumber(i)] = v
    end
  end
  DataModel.workShopsData = Clone(MainData.GetProductRoomList())
  DataModel.InitMachineAndPrisonerData()
end

function DataModel.UpdateWorkShopData(workshopsData, masterData)
  if workshopsData then
    for roomIndex, data in pairs(workshopsData) do
      DataModel.workShopsData[roomIndex] = Clone(data)
    end
  end
  if masterData then
    for roomIndex, data in pairs(masterData) do
      DataModel.monitorData[tonumber(roomIndex)] = data or ""
    end
  end
  DataModel.InitMachineAndPrisonerData()
end

function DataModel.UpdateMachineData(u_fid)
  local furData = Clone(PlayerData.ServerData.user_home_info.furniture[tostring(u_fid)])
  furData.id = tonumber(furData.id)
  DataModel.allMachine[u_fid] = furData
end

function DataModel.InitMachineAndPrisonerData()
  local allMachineCache = Clone(DataModel.allMachine)
  local allPrisonerCache = Clone(DataModel.allPrisoner)
  DataModel.roomMachineType = {}
  DataModel.roomMachineCount = {}
  DataModel.roomEditDirty = {}
  DataModel.prisonerData = {}
  DataModel.filterPrisoner = {}
  for i = 1, DataModel.totalRoomCount do
    table.insert(DataModel.roomMachineType, -1)
    table.insert(DataModel.roomMachineCount, 0)
  end
  for roomIndex, data in pairs(DataModel.workShopsData) do
    for posIndex, worker in pairs(data) do
      if worker.u_fid ~= "" then
        local mData = allMachineCache[worker.u_fid]
        if mData then
          DataModel.SetWorkMachineInfo(roomIndex, posIndex, mData.u_fid)
        end
      end
      if worker.u_pid ~= "" then
        local pData = DataModel.allPrisoner[worker.u_pid]
        if not pData then
          worker.u_pid = ""
          allPrisonerCache[worker.u_pid] = nil
        else
          DataModel.prisonerData[worker.u_pid] = {
            roomIndex = tonumber(roomIndex),
            posIndex = tonumber(posIndex),
            server = pData
          }
          DataModel.SetWorkPrisonerInfo(roomIndex, posIndex, pData.u_pid)
          allPrisonerCache[worker.u_pid] = nil
        end
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

function DataModel.PrisonerToWork(pData, toIdx)
  if not pData or toIdx == -1 then
    return false
  end
  local roomIndex, posIndex = DataModel.GetPrisonerWorkingRoomAndPos(pData.u_pid)
  local isWorking = roomIndex ~= -1 and posIndex ~= -1
  if isWorking then
    DataModel.SetWorkPrisonerInfo(roomIndex, posIndex, "")
    if DataModel.IsRoomMonitor(pData.u_pid, tonumber(roomIndex)) and roomIndex ~= DataModel.curRoomIndex then
      DataModel.monitorData[tonumber(roomIndex)] = ""
    end
    DataModel.SetDirty(roomIndex)
  end
  local curPrisoner = DataModel.GetWorkPrisonerInfo(DataModel.curRoomIndex, toIdx)
  if next(curPrisoner) ~= nil then
    if DataModel.IsRoomMonitor(curPrisoner.u_pid) then
      DataModel.monitorData[DataModel.curRoomIndex] = ""
    end
    DataModel.prisonerData[curPrisoner.u_pid].roomIndex = -1
    DataModel.prisonerData[curPrisoner.u_pid].posIndex = -1
    DataModel.SetWorkPrisonerInfo(DataModel.curRoomIndex, toIdx, "")
  end
  DataModel.prisonerData[pData.u_pid].roomIndex = DataModel.curRoomIndex
  DataModel.prisonerData[pData.u_pid].posIndex = toIdx
  DataModel.SetWorkPrisonerInfo(DataModel.curRoomIndex, toIdx, pData.u_pid)
  DataModel.SetDirty()
  return true
end

function DataModel.PrisonerToRest(u_pid, idx)
  if not u_pid or idx == -1 or u_pid == "" then
    return false
  end
  DataModel.SetWorkPrisonerInfo(DataModel.curRoomIndex, idx, "")
  DataModel.prisonerData[u_pid].roomIndex = -1
  DataModel.prisonerData[u_pid].posIndex = -1
  if DataModel.IsRoomMonitor(u_pid) then
    DataModel.monitorData[DataModel.curRoomIndex] = ""
  end
  DataModel.SetDirty()
  return true
end

function DataModel.SwapMachine(dragIdx, toIdx)
  local fid1 = DataModel.GetWorkMachineUid(DataModel.curRoomIndex, dragIdx)
  local fid2 = DataModel.GetWorkMachineUid(DataModel.curRoomIndex, toIdx)
  DataModel.SetWorkMachineInfo(DataModel.curRoomIndex, dragIdx, fid2)
  DataModel.SetWorkMachineInfo(DataModel.curRoomIndex, toIdx, fid1)
  DataModel.SetDirty()
  return true
end

function DataModel.SwapPrison(dragIdx, toIdx)
  if not DataModel.HasWorkingMachine(DataModel.curRoomIndex, toIdx) then
    return false
  end
  if not DataModel.HasWorkingPrisoner(DataModel.curRoomIndex, dragIdx) and not DataModel.HasWorkingPrisoner(DataModel.curRoomIndex, toIdx) then
    return false
  end
  local pid1 = DataModel.GetWorkPrisonerUid(DataModel.curRoomIndex, dragIdx)
  local pid2 = DataModel.GetWorkPrisonerUid(DataModel.curRoomIndex, toIdx)
  DataModel.SetWorkPrisonerInfo(DataModel.curRoomIndex, dragIdx, pid2)
  DataModel.SetWorkPrisonerInfo(DataModel.curRoomIndex, toIdx, pid1)
  if pid1 ~= "" then
    DataModel.prisonerData[pid1].posIndex = toIdx
  end
  if pid2 ~= "" then
    DataModel.prisonerData[pid2].posIndex = dragIdx
  end
  DataModel.SetDirty()
  return true
end

function DataModel.SortBagInfo()
  local function sortFunc(t)
    table.sort(t, function(a, b)
      return a.id > b.id
    end)
  end
  
  sortFunc(DataModel.machineBagGridData)
end

function DataModel.RemoveCurMachineBagInfo(u_fid)
  local id = DataModel.allMachine[u_fid].id
  for index, value in ipairs(DataModel.bagMachineData) do
    if value.id == id then
      for i, v in ipairs(value.machines) do
        if v == u_fid then
          table.remove(DataModel.bagMachineData[index].machines, i)
          break
        end
      end
    end
    if #DataModel.bagMachineData[index].machines == 0 then
      table.remove(DataModel.bagMachineData, index)
    end
  end
  DataModel.SortBagInfo()
end

function DataModel.GetCurMachineBagInfo(idx)
  return DataModel.machineBagGridData[idx].machines[1]
end

function DataModel.SetDirty(roomIndex)
  roomIndex = roomIndex or DataModel.curRoomIndex
  if not DataModel.roomEditDirty[tostring(roomIndex)] then
    DataModel.roomEditDirty[tostring(roomIndex)] = true
  end
end

function DataModel.GetRoomMachineType(roomIndex)
  if roomIndex <= 0 or roomIndex > DataModel.totalRoomCount then
    return -1
  end
  return DataModel.roomMachineType[roomIndex] or -1
end

function DataModel.GetCurRoomMachineType()
  return DataModel.roomMachineType[DataModel.curRoomIndex] or -1
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

function DataModel.GetPrisonerWorkStateType(pid)
  if DataModel.prisonerData[pid].roomIndex and DataModel.prisonerData[pid].posIndex == -1 then
    return EWorkStateType.NoPlace
  else
    return EWorkStateType.Working
  end
end

function DataModel.GetUnlockGridCount(roomIndex)
  roomIndex = roomIndex or DataModel.curRoomIndex
  local unlockGridCount = table.count(MainData.GetRoomData(roomIndex))
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

function DataModel.CheckMachineTypeCorrect(type)
  return DataModel.GetCurRoomMachineType() == -1 or type == DataModel.GetCurRoomMachineType()
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
    if v.id == specialityId then
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

function DataModel.IsRoomMonitor(pid, roomIndex)
  roomIndex = roomIndex or DataModel.curRoomIndex
  local curMonitorPid = DataModel.monitorData[roomIndex] or ""
  return curMonitorPid == pid and curMonitorPid ~= ""
end

function DataModel.ConvertEnergyToShow(energy)
  return math.floor(energy / 3600 + 0.5)
end

function DataModel.CalEnergy(pData)
  if not pData or not pData.energy then
    return
  end
  if not pData.last_cal_ts or pData.last_cal_ts == "" or tonumber(pData.last_cal_ts) <= 0 then
    pData.energy = pData.maxEnergy
  else
    local curServerTime = TimeUtil:GetServerTimeStamp()
    local deltaTime = curServerTime - tonumber(pData.last_cal_ts)
    pData.energy = pData.energy + deltaTime >= pData.maxEnergy and pData.maxEnergy or pData.energy + deltaTime
  end
  return pData.energy
end

function DataModel.CheckNextAreaCanUnlock()
  local lv = PrisonData.GetPrisonLv()
  local cfg = PlayerData:GetFactoryData("86800014").lvList[lv]
  if not cfg then
    return false
  end
  if DataModel.curRoomIndex > cfg.workshopNum then
    return false
  end
  local targetLockArea
  local roomData = PrisonData.GetRoomData(DataModel.curRoomIndex)
  local unlockAreaCount = table.count(roomData) // 3
  if 6 <= unlockAreaCount then
    return false
  end
  targetLockArea = unlockAreaCount + 1
  local idx = (DataModel.curRoomIndex - 1) * 6 + targetLockArea
  return idx <= cfg.SpaceNum, targetLockArea
end

function DataModel.RoomIsWorking(roomIndex)
  local roomProducts = PrisonData.GetRoomProducts(roomIndex)
  return roomProducts and table.count(roomProducts) > 0
end

function DataModel.CheckPrisonerIsInTime(u_pid)
  if not u_pid or u_pid == "" then
    return false
  end
  local pData = PrisonData.GetPrisoner(u_pid)
  if not pData then
    return false
  end
  local releaseTime = tonumber(pData.imprisonment_ts) + pData.days * 86400
  return releaseTime > TimeUtil:GetServerTimeStamp()
end

function DataModel.GetPosIndexByDirection(posIndex, direction)
  local rlt = -1
  local areaIndex = (posIndex - 1) // 3
  local cellIndex = (posIndex - 1) % 3 + 1
  if direction == DataModel.EDirectionType.Up then
    if 1 < cellIndex then
      return posIndex - 1
    end
  elseif direction == DataModel.EDirectionType.Right then
    if areaIndex < 6 then
      return (areaIndex + 1) * 3 + cellIndex
    end
  elseif direction == DataModel.EDirectionType.Down then
    if cellIndex < 3 then
      return posIndex + 1
    end
  elseif direction == DataModel.EDirectionType.Left and 1 < areaIndex then
    return (areaIndex - 1) * 3 + cellIndex
  end
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

return DataModel
