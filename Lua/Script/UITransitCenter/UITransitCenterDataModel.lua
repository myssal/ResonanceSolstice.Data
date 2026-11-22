local DataModel = {
  RoomLevel = 1,
  UnlockRouteId = {},
  RouteList = {},
  UnlockRouteList = {},
  LockRouteList = {},
  FleetList = {},
  TotalRouteNum = 0,
  TransitTime = 0,
  TransitGoodsCost = 0,
  TransitPrisonerCost = 0,
  RoomLevel = 1,
  CurStation = "",
  InTravel = false,
  FleetLevel2CountRecord = {},
  FleetCount2LevelRecord = {},
  MaxFleetCount = 0,
  LevelCfg = {},
  PrisonMaxLevel = 0,
  CurSelectRouteId = "",
  CurSelectRouteIndex = -1,
  CurSelectFleetIdx = "",
  MaterialGoods = {},
  ProductGoods = {},
  MaterialGoodsSpace = 0,
  ProductGoodsSpace = 0,
  CurBatchType = 1,
  CurWarehouseTab = -1,
  CurPickRouteId = "",
  SelectMaterialGoods = {},
  SelectMaterialGoodsSpace = 0,
  SelectProductGoods = {},
  SelectProductGoodsSpace = 0,
  SelectRouteDistance = 0,
  CarryingPrisoner = {},
  SelectPrisoner = {},
  MaxPrisonerCount = 0,
  CurPrisonerCount = 0,
  TempPrisonerCount = 0,
  FleetCountDownHandler = {},
  IsFirst = true
}
DataModel.GoodsFailTips = {
  [1] = "80607645",
  [2] = "80607646",
  [3] = "80607647",
  [4] = "80607845"
}
DataModel.PrisonerFailTips = {
  [1] = "80607648",
  [2] = "80607649",
  [3] = "80607650",
  [4] = "80607651"
}
local MapDataModel = require("UIHome/UIHomeMapDataModel")
local TradeDataModel = require("UIHome/UIHomeTradeDataModel")

function DataModel.InitData()
  DataModel.RoomLevel = PrisonData.GetBuildList()["87500021"].lv
  DataModel.TotalRouteNum = 0
  DataModel.TransitTime = 0
  DataModel.TransitGoodsCost = 0
  DataModel.TransitPrisonerCost = 0
  DataModel.CurSelectRouteId = ""
  DataModel.CurBatchType = 1
  DataModel.SelectPrisoner = {}
  DataModel.CurStation = TradeDataModel.CurStayCity
  DataModel.InTravel = TradeDataModel.InTravel
  local roomCfg = PlayerData:GetFactoryData(87500021).roomList
  local levelCfgId = roomCfg[DataModel.RoomLevel].config
  DataModel.LevelCfg = PlayerData:GetFactoryData(levelCfgId)
  DataModel.PrisonMaxLevel = table.count(PrisonData.GetPrisonCA().lvList)
  DataModel.TransitTime = DataModel.LevelCfg.transitTime
  DataModel.TransitGoodsCost = DataModel.LevelCfg.transitGoodsCostList[1].num
  DataModel.TransitPrisonerCost = DataModel.LevelCfg.transitPrisonerCostList[1].num
  DataModel.InitWarehouseData()
  DataModel.InitCarryingPrisonerData()
  DataModel.InitRouteData()
  DataModel.InitFleetData()
end

function DataModel.InitRouteData()
  DataModel.UnlockRouteList = {}
  DataModel.LockRouteList = {}
  DataModel.UnlockRouteId = {}
  DataModel.RouteList = {}
  DataModel.TotalRouteNum = 0
  local unlockData = PlayerData.ServerData.user_prison_info.routes
  for _, v in ipairs(unlockData) do
    DataModel.UnlockRouteId[tostring(v)] = tostring(v)
    DataModel.TotalRouteNum = DataModel.TotalRouteNum + 1
  end
  local stationList = PlayerData:GetFactoryData("99900014").stationList
  for i, v in ipairs(stationList) do
    if v.id ~= 83000017 then
      local stationCfg = PlayerData:GetFactoryData(v.id)
      if stationCfg.isWarehouse then
        local isUnlock = PlayerData:GetHomeInfo().stations[tostring(v.id)].is_unlock == 1
        if isUnlock then
          local row = {
            id = v.id,
            unlock = DataModel.UnlockRouteId[tostring(v.id)] ~= nil,
            curSpace = PlayerData.GetStationCurrentGoodsNum(v.id) + PlayerData.GetStationCurrentTransitGoodsNum(v.id),
            maxSpace = PlayerData:GetHomeInfo().stations[tostring(v.id)].max_goods_space or 0
          }
          row.spacePer = DataModel.CalCanTransPer(row.curSpace, row.maxSpace)
          if row.unlock then
            table.insert(DataModel.UnlockRouteList, row)
          elseif not row.unlock then
            table.insert(DataModel.LockRouteList, row)
          end
        end
      end
    end
  end
  table.sort(DataModel.UnlockRouteList, function(a, b)
    return tonumber(a.id) < tonumber(b.id)
  end)
  table.sort(DataModel.LockRouteList, function(a, b)
    return tonumber(a.id) < tonumber(b.id)
  end)
  for i, v in ipairs(DataModel.UnlockRouteList) do
    table.insert(DataModel.RouteList, v)
  end
  for i, v in ipairs(DataModel.LockRouteList) do
    table.insert(DataModel.RouteList, v)
  end
end

function DataModel.GetCanUnlockRouteCount()
  return DataModel.LevelCfg.routeLimited - DataModel.TotalRouteNum
end

function DataModel.InitFleetData()
  DataModel.FleetList = {}
  DataModel.FleetLevel2CountRecord = {}
  DataModel.FleetCount2LevelRecord = {}
  local roomLvCfg = PlayerData:GetFactoryData(87500021).roomList
  for i, v in ipairs(roomLvCfg) do
    local cfg = PlayerData:GetFactoryData(v.config)
    DataModel.FleetLevel2CountRecord[cfg.roomLevel] = cfg.fleetLimited
    if DataModel.FleetCount2LevelRecord[cfg.fleetLimited] == nil then
      for level, count in ipairs(DataModel.FleetLevel2CountRecord) do
        if count >= cfg.fleetLimited then
          DataModel.FleetCount2LevelRecord[cfg.fleetLimited] = level
          break
        end
      end
    end
    if cfg.fleetLimited > DataModel.MaxFleetCount then
      DataModel.MaxFleetCount = cfg.fleetLimited
    end
  end
  local serverFleetData = PlayerData.ServerData.user_prison_info.fleet_list
  local unlockCount = table.count(serverFleetData)
  for i = 1, DataModel.MaxFleetCount do
    local row = {
      idx = i,
      isUnlock = i <= unlockCount,
      isFree = DataModel.IsFleetFree(i)
    }
    table.insert(DataModel.FleetList, row)
  end
end

function DataModel.InitWarehouseData()
  local materialData = PrisonData.GetRawMaterialWarehouse()
  local productData = PrisonData.GetProductWareHouse()
  DataModel.MaterialGoods = {}
  DataModel.ProductGoods = {}
  DataModel.ProductGoodsSpace = 0
  DataModel.MaterialGoodsSpace = 0
  DataModel.SelectRouteDistance = 0
  for id, value in pairs(materialData) do
    if 0 < value.num then
      local cfg = PlayerData:GetFactoryData(id)
      if cfg and cfg.isDisplayInMaterialWare then
        local row = {
          info = cfg,
          num = value.num
        }
        table.insert(DataModel.MaterialGoods, row)
        DataModel.MaterialGoodsSpace = DataModel.MaterialGoodsSpace + value.num
      end
    end
  end
  for id, value in pairs(productData) do
    if 0 < value.num then
      local cfg = PlayerData:GetFactoryData(id)
      if cfg and cfg.isDisplayInFinishedlWare then
        local row = {
          info = cfg,
          num = value.num
        }
        table.insert(DataModel.ProductGoods, row)
        DataModel.ProductGoodsSpace = DataModel.ProductGoodsSpace + value.num
      end
    end
  end
end

function DataModel.InitCarryingPrisonerData()
  DataModel.CarryingPrisoner = {}
  local data = PlayerData.ServerData.user_prison_info.carrying_backpack
  for i, v in pairs(data) do
    local cfg = PlayerData:GetFactoryData(v.prisoner_id)
    local row = {
      id = v.prisoner_id,
      placeId = v.place_id,
      personalityId = v.personality_id,
      specialityId = v.speciality_id,
      rarityIdx = DataModel.SearchPrisonerRarityInt(cfg.prisonerRarity),
      u_pid = i
    }
    table.insert(DataModel.CarryingPrisoner, row)
  end
  table.sort(DataModel.CarryingPrisoner, function(a, b)
    return a.rarityIdx > b.rarityIdx
  end)
  local prisonCfg = PrisonData.GetPrisonCA()
  local cellRoomList = PrisonData.GetCellRoomList()
  local totalNum = 0
  for i, v in pairs(cellRoomList) do
    totalNum = totalNum + table.count(v) * prisonCfg.roomPrisonerNum
  end
  DataModel.MaxPrisonerCount = totalNum
  DataModel.CurPrisonerCount = table.count(PrisonData.GetPrisonPrisoners())
  DataModel.TempPrisonerCount = table.count(PlayerData.ServerData.user_prison_info.temporary_backpack)
end

function DataModel.GetFleetCount()
  return table.count(PlayerData.ServerData.user_prison_info.fleet_list)
end

function DataModel.IsFleetFree(idx)
  local fleetData = PlayerData.ServerData.user_prison_info.fleet_work_info[tostring(idx)]
  if fleetData == nil then
    return true
  end
  local finishTime = fleetData.start_ts + fleetData.a_way_ts * 2
  return finishTime <= TimeUtil:GetServerTimeStamp()
end

function DataModel.GetMaxFleetCount()
  return DataModel.LevelCfg.fleetLimited
end

function DataModel.CheckCanTransGoods()
  if table.count(DataModel.UnlockRouteList) == 0 then
    return false, 1
  elseif DataModel.MaterialGoodsSpace == 0 and DataModel.ProductGoodsSpace == 0 then
    return false, 4
  else
    if DataModel.FleetList[1].isUnlock == false then
      return false, 2
    end
    for i, v in ipairs(DataModel.FleetList) do
      if v.isUnlock and v.isFree then
        return true
      end
    end
    return false, 3
  end
  return false, 1
end

function DataModel.CheckCanTransPrisoner()
  if DataModel.InTravel then
    return false, 4
  elseif not DataModel.InTravel and tonumber(DataModel.CurStation) == 83000017 then
    return false, 4
  else
    if table.count(DataModel.RouteList) == 0 then
      return false, 1
    else
      for i, v in ipairs(DataModel.RouteList) do
        if v.id == tonumber(DataModel.CurStation) and not v.unlock then
          return false, 1
        end
      end
    end
    if table.count(DataModel.FleetList) == 0 then
      return false, 2
    else
      for i, v in ipairs(DataModel.FleetList) do
        if v.isUnlock and v.isFree then
          return true
        end
      end
      return false, 3
    end
  end
  return false, 1
end

function DataModel.CalCanTransPer(curSpace, maxSpace)
  local wareHouseGoodsCount = DataModel.MaterialGoodsSpace + DataModel.ProductGoodsSpace
  local emptySpace = maxSpace - curSpace
  if emptySpace <= 0 then
    return 0
  end
  if wareHouseGoodsCount <= emptySpace then
    return 100
  end
  return math.floor(emptySpace / wareHouseGoodsCount * 100 + 0.5)
end

function DataModel.GetDistanceFromPrison(stationId)
  stationId = stationId or DataModel.CurSelectRouteId
  local homeConfig = PlayerData:GetFactoryData(99900014, "ConfigFactory")
  local distance = math.ceil(MapDataModel.GetTargetStationDistance(tonumber(stationId), 83000017) * homeConfig.disRatio)
  DataModel.SelectRouteDistance = distance
  return distance
end

function DataModel.GetDistanceToPrison()
  local homeConfig = PlayerData:GetFactoryData(99900014, "ConfigFactory")
  local distance = math.ceil(MapDataModel.GetTargetStationDistance(tonumber(83000017)) * homeConfig.disRatio)
  return distance
end

function DataModel.GetCanUseFleet()
  for i = 1, DataModel.MaxFleetCount do
    local row = DataModel.FleetList[i]
    if row.isUnlock and row.isFree then
      return i
    end
  end
  return -1
end

function DataModel.NumRound(num)
  if 0 < num then
    return DataModel.NumFloorPrecision(num + 0.5)
  elseif num < 0 then
    return DataModel.NumFloorPrecision(num - 0.5)
  end
  return 0
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

return DataModel
