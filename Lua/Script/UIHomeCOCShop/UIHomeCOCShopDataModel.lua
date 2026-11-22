local DataModel = {
  initParams = {},
  stationId = 0,
  CanSaleList = {},
  CanBuyList = {},
  itemList = {},
  Now_List = {},
  curIndex = 1,
  curTradeType = 0,
  ShopIdToRecycle = {},
  TradeType = {Buy = 1, Sale = 2}
}

function DataModel.InitShopData()
  local stationConfig = PlayerData:GetFactoryData(DataModel.stationId, "HomeStationFactory")
  DataModel.CanBuyList = {}
  DataModel.AutoRefreshTime = {}
  local count = 1
  for k, v in pairs(stationConfig.cocStoreList) do
    local storeFactory = PlayerData:GetFactoryData(v.id)
    local severStoreValue = PlayerData.ServerData.shops[tostring(v.id)]
    DataModel.CanBuyList[count] = {}
    if severStoreValue then
      DataModel.CanBuyList[count].server = severStoreValue
    end
    DataModel.CanBuyList[count].storeType = storeFactory.storeType
    DataModel.CanBuyList[count].shopId = v.id
    DataModel.CanBuyList[count].name = storeFactory.name
    DataModel.CanBuyList[count].isAutoRefresh = storeFactory.autoRefresh
    local t = {}
    local idxRecord = {}
    if storeFactory.storeType == "Random" and severStoreValue then
      for k1, v1 in pairs(severStoreValue.items) do
        table.insert(t, {
          id = tonumber(v1.id),
          idx = k1,
          storeType = storeFactory.storeType
        })
      end
      for k1, v1 in pairs(storeFactory.commodityFixedList) do
        idxRecord[v1.id] = k1 - 100
      end
      for k1, v1 in pairs(storeFactory.shopList) do
        if idxRecord[v1.id] == nil then
          idxRecord[v1.id] = k1
        end
      end
    else
      for k1, v1 in pairs(storeFactory.shopList) do
        table.insert(t, {
          id = v1.id,
          idx = k1,
          storeType = storeFactory.storeType
        })
      end
    end
    DataModel.CanBuyList[count].idxRecord = idxRecord
    DataModel.CanBuyList[count].shopList = t
    count = count + 1
  end
end

function DataModel.InitCanBuyList()
  for i, j in pairs(DataModel.Now_List.shopList) do
    local row = j
    local data = PlayerData:GetFactoryData(row.id)
    if DataModel.Now_List.server then
      if DataModel.Now_List.storeType == "Random" then
        for k, v in pairs(DataModel.Now_List.server.items) do
          if k == row.idx and tonumber(v.id) == tonumber(row.id) then
            row.py_cnt = v.py_cnt
          end
        end
      else
        for k, v in pairs(DataModel.Now_List.server.items) do
          if tonumber(v.id) == tonumber(row.id) then
            row.py_cnt = v.py_cnt
          end
        end
      end
    end
    if data.purchase then
      local StoreDataModel = require("UIStore/UIStoreDataModel")
      local maxNum = StoreDataModel:GetPurchaseNum(data)
      row.residue = maxNum - (row.py_cnt or 0)
      if row.residue < 0 then
        row.residue = 0
      end
    else
      row.residue = 100
    end
    row.buyLimit = false
    row.limitRep = 0
    row.limitGrade = 0
    if data.isBuyCondition then
      if 0 < data.repGradeCondition then
        local stationId = DataModel.stationId
        if 0 < data.stationCondition then
          stationId = data.stationCondition
          local stationCA = PlayerData:GetFactoryData(stationId, "HomeStationFactory")
          if 0 < stationCA.attachedToCity then
            stationId = stationCA.attachedToCity
          end
        end
        local curRep = PlayerData:GetHomeInfo().stations[tostring(stationId)].rep_lv
        if curRep < data.repGradeCondition then
          row.buyLimit = true
          row.limitRep = data.repGradeCondition
        end
      end
      if 0 < data.gradeCondition then
        local curLv = PlayerData:GetPlayerLevel()
        if curLv < data.gradeCondition then
          row.buyLimit = true
          row.limitGrade = data.gradeCondition
        end
      end
    end
  end
  local idxRecord = DataModel.Now_List.idxRecord
  local isLocalSort = DataModel.Now_List.storeType == "Regular"
  table.sort(DataModel.Now_List.shopList, function(a, b)
    if a.residue == 0 and b.residue > 0 then
      return false
    end
    if a.residue > 0 and b.residue == 0 then
      return true
    end
    if a.buyLimit and not b.buyLimit then
      return false
    end
    if not a.buyLimit and b.buyLimit then
      return true
    end
    if isLocalSort then
      return a.idx < b.idx
    elseif idxRecord[a.id] < idxRecord[b.id] then
      return true
    end
    return false
  end)
end

local function GetShopIdRecycleList(shopId)
  if DataModel.ShopIdToRecycle[shopId] then
    return DataModel.ShopIdToRecycle[shopId]
  end
  local storeCA = PlayerData:GetFactoryData(shopId, "StoreFactory")
  local recycleListIdRecord = {}
  for k1, v1 in pairs(storeCA.recycleShopList) do
    local commodityCA = PlayerData:GetFactoryData(v1.id, "CommodityFactory")
    recycleListIdRecord[commodityCA.recycleItem] = v1.id
  end
  DataModel.ShopIdToRecycle[shopId] = recycleListIdRecord
  return recycleListIdRecord
end

local function InitFurnitureSaleData(shopId, savedTab)
  local recycleListIdRecord = GetShopIdRecycleList(shopId)
  local tabData = {}
  tabData.shopId = shopId
  tabData.commodityList = {}
  local index = 1
  local serverData = PlayerData:GetHomeInfo().furniture
  local idToIndex = {}
  for k1, v1 in pairs(serverData) do
    if v1.u_cid == "" then
      local id = tonumber(v1.id)
      if idToIndex[id] then
        local t = tabData.commodityList[idToIndex[id]]
        t.num = t.num + 1
        table.insert(t.uids, k1)
      elseif recycleListIdRecord[id] then
        local t = {}
        t.data = v1
        t.uids = {}
        table.insert(t.uids, k1)
        t.id = id
        t.commodityId = recycleListIdRecord[id]
        t.num = 1
        tabData.commodityList[index] = t
        idToIndex[id] = index
        index = index + 1
      end
    end
  end
  DataModel.CanSaleList[savedTab] = tabData
end

function DataModel.InitCanSaleData()
  if table.count(DataModel.CanSaleList) > 0 then
    return
  end
  DataModel.CanSaleList = {}
  local stationCA = PlayerData:GetFactoryData(DataModel.stationId, "HomeStationFactory")
  for k, v in pairs(stationCA.cocRecycleStoreList) do
    InitFurnitureSaleData(v.id, k)
  end
  for k, v in ipairs(stationCA.cocStoreList) do
    if DataModel.CanSaleList[k] == nil then
      local t = {}
      t.commodityList = {}
      DataModel.CanSaleList[k] = t
    end
  end
end

function DataModel.RefreshSpecialTypeData(idx)
  local stationCA = PlayerData:GetFactoryData(DataModel.stationId, "HomeStationFactory")
  local shopId = stationCA.cocRecycleStoreList[idx].id
  InitFurnitureSaleData(shopId, idx)
end

return DataModel
