local DataModel = {}
DataModel.orders = {}
DataModel.deliverRecordOrders = {}
DataModel.recordOrders = {}
DataModel.totalRewardCanGet = nil
DataModel.orderIndex = nil
DataModel.perNum = 0
DataModel.maxDeliverNum = 0
DataModel.deliverNum = 0

function DataModel.SetNewOrders()
  local time = PlayerData:GetPlayerPrefs("int", "PrisonHYWeekOrderRefreshTime")
  if time <= TimeUtil:GetServerTimeStamp() then
    for i = 1, table.count(DataModel.orders) do
      DataModel.SetOrderState(i, 1)
    end
    PlayerData:SetPlayerPrefs("int", "PrisonHYWeekOrderRefreshTime", TimeUtil:GetNextWeekTime(1, 5))
  end
end

function DataModel.SortOrders()
  table.sort(DataModel.orders, function(a, b)
    local orderCA = PlayerData:GetFactoryData(a, "PrisonProcurementFactory")
    local orderCA1 = PlayerData:GetFactoryData(b, "PrisonProcurementFactory")
    if orderCA.rarity == orderCA1.rarity then
      return tonumber(a) > tonumber(b)
    else
      return orderCA.rarity > orderCA1.rarity
    end
  end)
end

function DataModel.SetOrderIndex(orderIndex)
  if orderIndex and orderIndex > #DataModel.orders or not orderIndex then
    orderIndex = 1
    for i, orderId in ipairs(DataModel.orders) do
      if not DataModel.IsOrderLock(orderId) then
        orderIndex = i
        break
      end
    end
  end
  DataModel.orderIndex = orderIndex
end

function DataModel.GetOrderRedPoint(orderIndex)
  local orderId = DataModel.orders[tonumber(orderIndex)]
  if DataModel.GetOrderState(orderIndex) == 1 and not DataModel.IsOrderLock(orderId) then
    return true
  end
  return false
end

function DataModel.SetOrderState(orderIndex, status)
  local orderId = DataModel.orders[tonumber(orderIndex)]
  local key = "PrisonHYWeekOrder" .. orderId
  PlayerData:SetPlayerPrefs("int", key, status)
end

function DataModel.GetOrderState(orderIndex)
  local orderId = DataModel.orders[tonumber(orderIndex)]
  local key = "PrisonHYWeekOrder" .. orderId
  return PlayerData:GetPlayerPrefs("int", key)
end

function DataModel.GetCompletedOrderNum()
  local completedNum = 0
  for orderId, num in pairs(DataModel.deliverRecordOrders) do
    if DataModel.IsOrderCompleted(orderId) then
      completedNum = completedNum + 1
    end
  end
  return completedNum
end

function DataModel.IsDeliverItemEnough(orderId)
  local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
  local itemCfg = orderCA.weekRequireItemList[1]
  if not itemCfg then
    return false
  end
  local haveNum = PrisonData.GetGoodsById(itemCfg.id)
  return haveNum >= itemCfg.perNum
end

function DataModel.IsOrderLock(orderId)
  local prisonCA = PlayerData:GetFactoryData(86800014, "PrisonFactory")
  if table.count(DataModel.deliverRecordOrders) == prisonCA.weekOrdercompleteNum and not DataModel.deliverRecordOrders[tostring(orderId)] then
    return true
  end
  return false
end

function DataModel.IsOrderCompleted(orderId)
  local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
  local deliverNum = DataModel.deliverRecordOrders[tostring(orderId)] or 0
  local itemCfg = orderCA.weekRequireItemList[1]
  return itemCfg and deliverNum == itemCfg.totalNum
end

function DataModel.IsOrderCanDeliver(orderId)
  return not DataModel.IsOrderCompleted(orderId) and not DataModel.IsOrderLock(orderId) and DataModel.IsDeliverItemEnough(orderId)
end

function DataModel.IsOrderRecorded(orderId)
  for i, v in pairs(DataModel.recordOrders) do
    if v == tostring(orderId) then
      return true
    end
  end
  return false
end

return DataModel
