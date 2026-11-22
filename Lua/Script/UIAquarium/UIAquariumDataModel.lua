local DataModel = {
  TradeType = {Buy = 1, Sell = 2},
  CurTradeType = 1,
  ShopDataConfigId = "84400108",
  ShopDataConfig = {},
  BuyConfigId = "",
  SellConfigId = "",
  SellStoreList = {},
  BuyCount = {},
  SellCount = {},
  NpcId = 0,
  BuildingId = 0,
  StationId = 0,
  NPCDialogEnum = {
    enterText = "enterText",
    talkText = "talkText",
    fishStoreText = "fishStoreText",
    fishSellText = "fishSellText"
  },
  batchOpen = false,
  batchList = {},
  batchBuyMoney = 0,
  batchSaleMoney = 0
}

function DataModel.InitData()
  DataModel.ShopDataConfig = PlayerData:GetFactoryData(DataModel.ShopDataConfigId)
  DataModel.BuyConfigId = tostring(DataModel.ShopDataConfig.StoreList[1].id)
  DataModel.SellConfigId = tostring(DataModel.ShopDataConfig.RecycleStoreList[1].id)
  DataModel.batchOpen = false
  DataModel.batchList = {}
  DataModel.batchBuyMoney = 0
  DataModel.batchSaleMoney = 0
end

function DataModel.InitShopData()
  DataModel.SellStoreList = {}
  local sellListData = PlayerData:GetFactoryData(DataModel.ShopDataConfig.RecycleStoreList[1].id).recycleShopList
  for i, v in ipairs(sellListData) do
    local cfg = PlayerData:GetFactoryData(v.id)
    DataModel.SellStoreList[tostring(cfg.recycleItem)] = {
      commodityId = v.id
    }
  end
end

function DataModel.InitServerBuyData()
  DataModel.BuyCount = {}
  local severStoreValue = PlayerData.ServerData.shops[tostring(DataModel.BuyConfigId)].items
  for i, v in ipairs(severStoreValue) do
    DataModel.BuyCount[i] = {
      id = v.id,
      buyCount = v.py_cnt
    }
  end
end

function DataModel.InitSellData()
  DataModel.SellCount = {}
  local serverData = PlayerData:GetHomeInfo().creatures
  for k1, v1 in pairs(serverData) do
    local id = tonumber(k1)
    if DataModel.SellStoreList[tostring(id)] and v1.num and v1.num > 0 then
      local t = {
        data = v1,
        id = id,
        commodityId = DataModel.SellStoreList[tostring(id)].commodityId,
        num = v1.num
      }
      table.insert(DataModel.SellCount, t)
    end
  end
end

function DataModel.GetItemBuyCount(idx)
  local data = DataModel.BuyCount[idx].buyCount
  return data or 0
end

return DataModel
