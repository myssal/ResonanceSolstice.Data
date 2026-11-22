local DataModel = {}
DataModel.buildCA = PlayerData:GetFactoryData(84400137, "PrisonFactory")
DataModel.orders = {}
DataModel.recordOrders = {}
DataModel.useTime = 0
DataModel.orderIndex = 0
DataModel.RefreshType = {Diamond = 1, Other = 2}

function DataModel.InitData()
  DataModel.refreshType = DataModel.RefreshType.Diamond
  DataModel.orderTabTimeList = {}
end

function DataModel.SetOrderData(data)
  if data then
    DataModel.orders = {}
    for i, v in pairs(data) do
      table.insert(DataModel.orders, {serverIndex = i, data = v})
    end
  end
end

function DataModel.SetOrderIndex(orderIndex)
  if orderIndex and orderIndex > #DataModel.orders or not orderIndex then
    orderIndex = 1
    for i, v in ipairs(DataModel.orders) do
      local remainTime = DataModel.GetRemainRefreshTime(i)
      if remainTime <= 0 then
        orderIndex = i
        break
      end
    end
  end
  DataModel.orderIndex = orderIndex
end

function DataModel.GetRedPoint()
  for i, v in ipairs(DataModel.orders) do
    if DataModel.GetOrderRedPoint(i) then
      return true
    end
  end
  return false
end

function DataModel.GetOrderRedPoint(orderIndex)
  if DataModel.GetOrderState(orderIndex) == 0 and 0 >= DataModel.GetRemainRefreshTime(orderIndex) then
    return true
  elseif DataModel.IsOrderCanDeliver(orderIndex) then
    return true
  end
  return false
end

function DataModel.SetOrderState(orderIndex, status)
  local orderInfo = DataModel.orders[tonumber(orderIndex)]
  local key = "PrisonHYOrder" .. orderInfo.serverIndex
  if status == 1 then
    if DataModel.GetRemainRefreshTime(orderIndex) <= 0 then
      PlayerData:SetPlayerPrefs("int", key, 1)
    end
  elseif status == 0 then
    PlayerData:SetPlayerPrefs("int", key, 0)
  end
end

function DataModel.GetOrderState(orderIndex)
  local orderInfo = DataModel.orders[tonumber(orderIndex)]
  local key = "PrisonHYOrder" .. orderInfo.serverIndex
  return PlayerData:GetPlayerPrefs("int", key)
end

function DataModel.SortOrderList()
  local function GetRemainTime(orderInfo)
    local buildCA = DataModel.buildCA
    
    local orderData = orderInfo.data
    if orderData.status == 1 then
      return 0
    end
    return orderInfo.data.refresh_ts + buildCA.refreshOrderPrisonTime - TimeUtil:GetServerTimeStamp()
  end
  
  local function SortFun(a, b)
    local remainTime1 = GetRemainTime(a)
    local remainTime2 = GetRemainTime(b)
    if 0 < remainTime1 then
      if 0 < remainTime2 then
        return remainTime1 < remainTime2
      else
        return false
      end
    elseif remainTime2 <= 0 then
      if a.data.refresh_ts == b.data.refresh_ts then
        return tonumber(a.serverIndex) > tonumber(b.serverIndex)
      else
        return a.data.refresh_ts > b.data.refresh_ts
      end
    else
      return true
    end
  end
  
  table.sort(DataModel.orders, SortFun)
end

function DataModel.GetRemainRefreshTime(orderIndex)
  local buildCA = DataModel.buildCA
  local orderInfo = DataModel.orders[tonumber(orderIndex)]
  local orderData = orderInfo.data
  if orderData.status == 1 then
    return 0
  end
  return orderInfo.data.refresh_ts + buildCA.refreshOrderPrisonTime - TimeUtil:GetServerTimeStamp()
end

function DataModel.IsOrderCanDeliver(orderIndex)
  local orderInfo = DataModel.orders[tonumber(orderIndex)]
  local orderData = orderInfo.data
  local orderId = orderData.oid
  local remainTime = DataModel.GetRemainRefreshTime(orderIndex)
  if 0 < remainTime then
    return false
  end
  local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
  for i, v in ipairs(orderCA.requireItemList) do
    local haveNum = PrisonData.GetGoodsById(v.id)
    if haveNum < v.num then
      return false
    end
  end
  return true
end

return DataModel
