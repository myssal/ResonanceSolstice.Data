local DataModel = {}
local goldenWeekDataModel = require("UIGoldenWeek/UIGoldenWeekDataModel")

function DataModel.FindNowWeekActivity()
  local ActivityMainDataModel = require("UIActivityMain/UIActivityMainDataModel")
  local activityList = ActivityMainDataModel:GetActivityCAList()
  local nowActivityList = PlayerData:GetFactoryData(99900074).activityUiCommon
  local needCloseActivityList = {}
  local startActivitylist = {}
  for i, v in ipairs(nowActivityList) do
    local open = false
    for i1, v1 in ipairs(activityList) do
      if v1.id == v.id then
        open = TimeUtil:IsActive(v1.startTime, v1.endTime)
        break
      end
    end
    if open then
      table.insert(startActivitylist, v)
      local activeCA = PlayerData:GetFactoryData(v.id)
      needCloseActivityList[activeCA.isOnly] = 1
    end
  end
  local data = {}
  for i, v in ipairs(startActivitylist) do
    if not needCloseActivityList[v.id] then
      data.passengerIcon = v.passengerIcon
      data.recycleIcon = v.recycleId
      data.activityId = v.id
      data.limitedTime = PlayerData:GetFactoryData(v.id).isOnly == 86000010
      data.activityItemCorner = v.activityItemCorner
      data.activitySkipUi = v.activitySkipUi
      if not data.limitedTime then
        data.refresh = true
        if PlayerData.ServerData.server_resident then
          data.refresh = TimeUtil:GetServerTimeStamp() >= PlayerData.ServerData.server_resident["86000010"].ti
        end
      end
    end
  end
  return data
end

function DataModel.GetGradelList(data)
  if data.limitedTime then
    local cfg = PlayerData:GetFactoryData(data.activityId) or {}
    for i, v in ipairs(cfg.activityGradeList) do
      if goldenWeekDataModel.IsTimeInRange(v.startTime, v.endTime) then
        local cfg = PlayerData:GetFactoryData(v.id)
        return cfg.passengerBufflList
      end
    end
  elseif PlayerData.ServerData.server_resident then
    local activityListId = PlayerData.ServerData.server_resident["86000010"].id
    if activityListId then
      return PlayerData:GetFactoryData(activityListId).activityGradeList
    end
  end
  return {}
end

function DataModel.GetRecycleCityList(data, StationId)
  local materialList = {}
  local StationId = tonumber(StationId)
  if data.limitedTime then
    local cfg = PlayerData:GetFactoryData(data.activityId) or {}
    for i, v in ipairs(cfg.recycleCityList) do
      if goldenWeekDataModel.IsTimeInRange(v.startTime, v.endTime) and v.cityId == StationId then
        materialList = PlayerData:GetFactoryData(v.materialList).materialList
        return materialList, v.highCoefficient
      end
    end
  elseif PlayerData.ServerData.server_resident then
    local activityListId = PlayerData.ServerData.server_resident["86000010"].id
    if activityListId then
      local cfg = PlayerData:GetFactoryData(activityListId) or {}
      for i, v in ipairs(cfg.recycleCityList) do
        if v.cityId == StationId then
          materialList = PlayerData:GetFactoryData(v.materialList).materialList
          return materialList, v.highCoefficient
        end
      end
    end
  end
  return materialList, 1
end

function DataModel.GetPassengerBufflList(data)
  local passengerList = {}
  if data.limitedTime then
    local cfg = PlayerData:GetFactoryData(data.activityId) or {}
    for i, v in ipairs(cfg.activityPassengerList) do
      if goldenWeekDataModel.IsTimeInRange(v.startTime, v.endTime) then
        table.insert(passengerList, {
          cityId = v.cityId
        })
      end
    end
  elseif PlayerData.ServerData.server_resident then
    local activityListId = PlayerData.ServerData.server_resident["86000010"].id
    if activityListId then
      return PlayerData:GetFactoryData(activityListId).activityPassengerList
    end
  end
  return passengerList
end

function DataModel.GetTradeData(data)
  local tradeData = {}
  if data.limitedTime then
    local cfg = PlayerData:GetFactoryData(data.activityId) or {}
    for i, v in ipairs(cfg.goodsList) do
      if goldenWeekDataModel.IsTimeInRange(v.startTime, v.endTime) then
        tradeData[v.goodsId] = 1
      end
    end
  elseif PlayerData.ServerData.server_resident then
    local activityListId = PlayerData.ServerData.server_resident["86000010"].id
    if activityListId then
      local activityListCfg = PlayerData:GetFactoryData(activityListId)
      for i, v in ipairs(activityListCfg.goodsList) do
        tradeData[v.goodsId] = 1
      end
      for i, v in ipairs(activityListCfg.RareTradeData) do
        tradeData[v.id] = 1
      end
    end
  end
  return tradeData
end

function DataModel.GetOrderData(data)
  local orderData = {}
  if data.limitedTime then
    local cfg = PlayerData:GetFactoryData(data.activityId) or {}
    for i, v in ipairs(cfg.orderUpList) do
      if goldenWeekDataModel.IsTimeInRange(v.startTime, v.endTime) then
        orderData[v.id] = {
          id = v.id,
          param = v.param
        }
      end
    end
  elseif PlayerData.ServerData.server_resident then
    local activityListId = PlayerData.ServerData.server_resident["86000010"].id
    if activityListId then
      local activityListCfg = PlayerData:GetFactoryData(activityListId)
      for i, v in ipairs(activityListCfg.orderUpList) do
        orderData[v.id] = {
          id = v.id,
          param = v.param
        }
      end
    end
  end
  return orderData
end

return DataModel
