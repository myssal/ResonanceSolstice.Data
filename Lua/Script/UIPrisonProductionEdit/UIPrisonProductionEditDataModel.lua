local DataModel = {
  DesignRowCount = 3,
  DesignColumnCount = 6,
  CurRoomIndex = 0,
  UnlockGridCountData = {},
  CurSelectFormulaType = -1,
  CurRoomFormulaType = {},
  RecentFormulaGroup = {},
  CurRoomFormulaGroup = {},
  CurSelectFormulaId = -1,
  CurSelectFormulaProductionCfg = {},
  CurSelectTimeIdx = 1,
  TotalRoomCount = 0,
  IsExpand = false,
  WorkPlacedData = {},
  AllMachine = {},
  AllPrisoner = {},
  MonitorData = {},
  ProductPlantData = {},
  CountDownHandler = {},
  Tweens = {},
  SelectPosIndex = {},
  CurPower = 0,
  MaxPower = 0,
  NameScrollSpeed = 0.8,
  RecentFormulaGroupCount = 10,
  MaxRoomCount = 0
}
local TradeDataModel = require("UIHome/UIHomeTradeDataModel")

function DataModel.InitData()
  DataModel.SelectPosIndex = {}
  DataModel.CurSelectTimeIdx = 1
  DataModel.CurSelectFormulaId = -1
  DataModel.CurSelectFormulaType = -1
  DataModel.IsExpand = false
  DataModel.TotalRoomCount = table.count(PrisonData.GetProductRoomList())
  DataModel.CurPower = PrisonData.GetUsePower()
  DataModel.MaxPower = PrisonData.GetCurPower()
  local cfg = PrisonData.GetPrisonCA()
  local maxLevel = #cfg.lvList
  DataModel.MaxRoomCount = cfg.lvList[maxLevel].workshopNum
  DataModel.InitWorkerData()
  DataModel.InitPlantData()
  DataModel.InitRecentFormulaGroup()
  DataModel.InitRoomUnlockCount()
  DataModel.ResetRoomData()
end

function DataModel.ResetRoomData()
  DataModel.RefreshFormulaTypeData()
  DataModel.RefreshFormulaGroupData()
end

function DataModel.InitWorkerData()
  DataModel.WorkPlacedData = {}
  local allFurnitureData = PlayerData.ServerData.user_prison_info.furniture
  for i, v in pairs(allFurnitureData) do
    v.u_fid = i
    v.id = tonumber(v.id)
    local cfg = PlayerData:GetFactoryData(v.id)
    if cfg.isPrison then
      DataModel.AllMachine[v.u_fid] = v
    end
  end
  local serverPData = Clone(PrisonData.GetPrisonPrisoners())
  for i, v in pairs(serverPData) do
    DataModel.AllPrisoner[i] = v
  end
  for i = 1, DataModel.TotalRoomCount do
    for j = 1, 18 do
      if not DataModel.WorkPlacedData[i] then
        DataModel.WorkPlacedData[i] = {}
      end
      DataModel.WorkPlacedData[i][j] = {u_fid = "", u_pid = ""}
    end
  end
  DataModel.MonitorData = {}
  for i = 1, DataModel.TotalRoomCount do
    DataModel.MonitorData[i] = ""
  end
  local masterServerData = Clone(PrisonData.GetPrisonMasterList())
  for i, v in pairs(masterServerData) do
    if DataModel.AllPrisoner[v] then
      DataModel.MonitorData[tonumber(i)] = v
    end
  end
  local serverFurnitureData = PlayerData.ServerData.user_prison_info.workshops_furniture
  local serverPrisonerData = PlayerData.ServerData.user_prison_info.workshops_front
  local serverProgrammeData = PlayerData.ServerData.user_prison_info.workshops_programme
  for i = 1, DataModel.TotalRoomCount do
    local programmeIndex = serverProgrammeData[tostring(i)] or "1"
    if serverFurnitureData[tostring(DataModel.CurRoomIndex)] ~= nil then
      for posIndex, data in pairs(serverFurnitureData[tostring(DataModel.CurRoomIndex)]) do
        DataModel.SetWorkMachineInfo(i, posIndex, data[tostring(programmeIndex)])
      end
    end
    if serverPrisonerData[tostring(DataModel.CurRoomIndex)] ~= nil then
      for posIndex, data in pairs(serverPrisonerData[tostring(DataModel.CurRoomIndex)]) do
        DataModel.SetWorkPrisonerInfo(i, posIndex, data)
      end
    end
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

function DataModel.InitRecentFormulaGroup()
  DataModel.RecentFormulaGroup = {}
  local localSaveData = PlayerPrefs.GetString("PrisonRecentFormulaGroup")
  if localSaveData == nil or localSaveData == "" then
    DataModel.RecentFormulaGroup = {}
  else
    DataModel.RecentFormulaGroup = Json.decode(localSaveData)
  end
end

function DataModel.RefreshFormulaTypeData()
  DataModel.CurRoomFormulaType = {}
  local formulaTypeList = PrisonData.GetPrisonCA().sewingMachineProductList
  for i, v in ipairs(formulaTypeList) do
    local row = {
      id = v.id
    }
    table.insert(DataModel.CurRoomFormulaType, row)
  end
end

function DataModel.RefreshFormulaGroupData()
  DataModel.CurRoomFormulaGroup = {}
  DataModel.CurRoomFormulaGroup["-1"] = {}
  DataModel.CurRoomFormulaGroup["0"] = {}
  local formulaGroupList = PlayerData:GetFactoryData(81300373).formulaGroup
  for i, v in ipairs(formulaGroupList) do
    local row = {
      id = v.id,
      unlock = DataModel.CheckUnlockFormula(v.id) and 1 or 0
    }
    local cfg = PlayerData:GetFactoryData(v.id)
    local formulaType = cfg.formulaType
    table.insert(DataModel.CurRoomFormulaGroup["-1"], row)
    if not DataModel.CurRoomFormulaGroup[tostring(formulaType)] then
      DataModel.CurRoomFormulaGroup[tostring(formulaType)] = {}
    end
    table.insert(DataModel.CurRoomFormulaGroup[tostring(formulaType)], row)
  end
  DataModel.SortFormula()
  local machineType = PlayerData:GetFactoryData(81300373).type
  local recentData = DataModel.RecentFormulaGroup[tostring(machineType)] or {}
  for i, v in ipairs(recentData) do
    local row = {
      id = v.id
    }
    table.insert(DataModel.CurRoomFormulaGroup["0"], row)
  end
end

function DataModel.InitRoomUnlockCount()
  DataModel.UnlockGridCountData = {}
  local totalRoomCount = table.count(PrisonData.GetProductRoomList())
  for i = 1, totalRoomCount do
    DataModel.UnlockGridCountData[i] = PrisonData.GetRoomData(i) ~= nil and table.count(PrisonData.GetRoomData(i)) or 0
  end
end

function DataModel.GetUnlockGridCount(roomIndex)
  roomIndex = roomIndex or DataModel.CurRoomIndex
  local unlockGridCount = DataModel.UnlockGridCountData[tonumber(roomIndex)] or 0
  return unlockGridCount
end

function DataModel.GetMachineDataByUid(u_fid)
  return DataModel.AllMachine[u_fid]
end

function DataModel.GetPrisonerDataByUid(u_pid)
  if not u_pid or u_pid == "" then
    return {}
  end
  return DataModel.AllPrisoner[u_pid] or {}
end

function DataModel.HasWorkingPrisoner(roomIndex, posIndex)
  return DataModel.GetWorkPrisonerUid(roomIndex, posIndex) ~= ""
end

function DataModel.GetWorkMachineUid(roomIndex, posIndex)
  return DataModel.WorkPlacedData[tonumber(roomIndex)][tonumber(posIndex)].u_fid or ""
end

function DataModel.GetWorkMachineInfo(roomIndex, posIndex)
  local u_fid = DataModel.GetWorkMachineUid(roomIndex, posIndex)
  return DataModel.GetMachineDataByUid(u_fid)
end

function DataModel.GetWorkPrisonerUid(roomIndex, posIndex)
  return DataModel.WorkPlacedData[tonumber(roomIndex)][tonumber(posIndex)].u_pid or ""
end

function DataModel.GetWorkPrisonerInfo(roomIndex, posIndex)
  local u_pid = DataModel.GetWorkPrisonerUid(roomIndex, posIndex)
  return DataModel.GetPrisonerDataByUid(u_pid)
end

function DataModel.SetWorkMachineInfo(roomIndex, posIndex, u_fid)
  DataModel.WorkPlacedData[tonumber(roomIndex)][tonumber(posIndex)].u_fid = u_fid
end

function DataModel.SetWorkPrisonerInfo(roomIndex, posIndex, u_pid)
  DataModel.WorkPlacedData[tonumber(roomIndex)][tonumber(posIndex)].u_pid = u_pid
end

function DataModel.IsWorkPlaceHasPlant(roomIndex, posIndex)
  local plantData = DataModel.ProductPlantData[tostring(roomIndex)]
  if plantData and plantData[tostring(posIndex)] then
    local data = plantData[tostring(posIndex)]
    local perCountTimeCost = PlayerData:GetFactoryData(data.formulaGroupId).perTime * 60
    local totalCostTime = perCountTimeCost * data.count
    local finishTime = data.startTime + totalCostTime
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

function DataModel.IsRoomMonitor(pid, roomIndex)
  roomIndex = roomIndex or DataModel.CurRoomIndex
  local curMonitorPid = DataModel.MonitorData[roomIndex] or ""
  return curMonitorPid == pid and curMonitorPid ~= ""
end

function DataModel.CalExpectedProductNum()
  local perProductCount = DataModel.CurSelectFormulaProductionCfg.perNum
  local productCount = DataModel.CurSelectFormulaProductionCfg.programmeList[DataModel.CurSelectTimeIdx].count
  local selectPrisonerCount = table.count(DataModel.SelectPosIndex)
  return perProductCount * productCount * selectPrisonerCount
end

function DataModel.CalWorkerPlaceProductNum(posIndex)
  local plantData = DataModel.GetWorkPlacePlantData(DataModel.CurRoomIndex, posIndex)
  if not plantData then
    return 0
  end
  local num = 0
  local formulaGroupCfg = PlayerData:GetFactoryData(plantData.formulaGroupId)
  local perFormulaProductTime = formulaGroupCfg.perTime * 60
  local workTime = PrisonData.GetProductWorkTime(DataModel.CurRoomIndex, posIndex)
  num = math.floor(workTime / (formulaGroupCfg.perTime * 60)) * formulaGroupCfg.perNum
  return num
end

function DataModel.GetGoodsNumById(id)
  if not id then
    return 0
  end
  local count = 0
  if PlayerData.ServerData.user_prison_info.raw_material[tostring(id)] then
    count = count + PlayerData.ServerData.user_prison_info.raw_material[tostring(id)].num
  end
  if PlayerData.ServerData.user_prison_info.product[tostring(id)] then
    count = count + PlayerData.ServerData.user_prison_info.product[tostring(id)].num
  end
  local curCity = TradeDataModel.EndCity
  if curCity == 83000017 then
    local data = PlayerData:GetGoodsById(id)
    if data then
      count = count + data.num or 0
    end
  end
  return count
end

function DataModel.CheckNextAreaCanUnlock()
  local lv = PrisonData.GetPrisonLv()
  local cfg = PrisonData.GetPrisonCA().lvList[lv]
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

function DataModel.GetRoomFormulaTypeList()
end

function DataModel.GetFormulaGroupList(type)
  return DataModel.CurRoomFormulaType[tostring(type)]
end

function DataModel.RecordRecentFormulaGroup(formulaGroupId)
  local machineType = PlayerData:GetFactoryData(DataModel.GetWorkMachineInfo(DataModel.CurRoomIndex, 1).id).type
  if DataModel.RecentFormulaGroup[tostring(machineType)] == nil then
    DataModel.RecentFormulaGroup[tostring(machineType)] = {}
  end
  local row = {id = formulaGroupId}
  local hasRecord = false
  local recordPos = 0
  for i = 1, DataModel.RecentFormulaGroupCount do
    local data = DataModel.RecentFormulaGroup[tostring(machineType)][i]
    if data and data.id == formulaGroupId then
      hasRecord = true
      recordPos = i
    end
  end
  if hasRecord then
    table.remove(DataModel.RecentFormulaGroup[tostring(machineType)], recordPos)
    table.insert(DataModel.RecentFormulaGroup[tostring(machineType)], 1, row)
  else
    if table.count(DataModel.RecentFormulaGroup[tostring(machineType)]) >= DataModel.RecentFormulaGroupCount then
      table.remove(DataModel.RecentFormulaGroup[tostring(machineType)], DataModel.RecentFormulaGroupCount)
    end
    table.insert(DataModel.RecentFormulaGroup[tostring(machineType)], 1, row)
  end
  DataModel.RefreshFormulaGroupData()
  PlayerPrefs.SetString("PrisonRecentFormulaGroup", Json.encode(DataModel.RecentFormulaGroup))
end

function DataModel.CheckUnlockFormula(id)
  local cfg = PlayerData:GetFactoryData(id)
  if cfg.unlock == -1 then
    return true
  else
    local ownList = PlayerData.ServerData.formula_items or {}
    local isOwn = false
    for k1, v1 in pairs(ownList) do
      if v1 == tostring(cfg.unlock) then
        return true
      end
    end
  end
  return false
end

function DataModel.SortFormula()
  for type, list in pairs(DataModel.CurRoomFormulaGroup) do
    if tonumber(type) ~= 0 then
      table.sort(list, function(a, b)
        if a.unlock == b.unlock then
          return a.id < b.id
        end
        return a.unlock > b.unlock
      end)
    end
  end
end

return DataModel
