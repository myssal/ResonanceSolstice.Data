local DataModel = {
  TrainGoods = {},
  ProductGoods = {},
  MaterialGoods = {},
  ExchangeType = {
    MaterialAndTrain = 1,
    MaterialAndProduct = 2,
    ProductAndTrain = 3
  },
  GoodsPlaceType = {
    Material = 1,
    Product = 2,
    Train = 3
  },
  CurExchangeType = 1,
  ChangeGoods = {
    [1] = {},
    [2] = {}
  },
  NPCId = "83700087",
  BatchInfo = 0,
  BatchIdx = 0,
  TrainGoodsBatchMode = 0,
  MaterialGoodsBatchMode = 0,
  ProductGoodsBatchMode = 0,
  TrainGoodsSpace = 0,
  TrainGoodsMaxSpace = 0,
  StationGoodsMaterialSpace = 0,
  StationGoodsMaterialMaxSpace = 0,
  StationGoodsProductSpace = 0,
  StationGoodsProductMaxSpace = 0,
  BuySpaceNum = 0,
  FormulaList = {},
  CanBuySpace = false,
  SortFunc = function(a, b)
    if a.type == b.type then
      return a.info.id < b.info.id
    end
    return a.type < b.type
  end,
  CurCapacityBuyMode = 1,
  CurExpandPanelType = 1
}
DataModel.PropType = {
  None = 0,
  Material = 1,
  Item = 2,
  Goods = 3
}
local TradeDataModel = require("UIHome/UIHomeTradeDataModel")

function DataModel.InitWarehouseData()
  DataModel.CurStation = TradeDataModel.CurStayCity
  DataModel.InTravel = TradeDataModel.InTravel
  local space_info = PlayerData:GetUserInfo().space_info
  DataModel.TrainGoodsSpace = space_info.now_train_goods_num
  DataModel.TrainGoodsMaxSpace = PlayerData.GetMaxTrainGoodsNum()
  DataModel.ProductGoodsBatchMode = DataModel.ProductGoodsBatchMode == 0 and 2 or DataModel.ProductGoodsBatchMode
  DataModel.TrainGoodsBatchMode = DataModel.TrainGoodsBatchMode == 0 and 2 or DataModel.TrainGoodsBatchMode
  DataModel.StationGoodsMaterialSpace = PrisonData.GetRawMaterialWarehouseCapacity()
  DataModel.StationGoodsMaterialMaxSpace = PrisonData.GetRawMaterialWarehouseMaxCapacity()
  DataModel.StationGoodsProductSpace = PrisonData.GetProductWarehouseCapacity()
  DataModel.StationGoodsProductMaxSpace = PrisonData.GetProductWarehouseMaxCapacity()
  local materialData = PrisonData.GetRawMaterialWarehouse()
  local productData = PrisonData.GetProductWareHouse()
  DataModel.TrainGoods = {}
  DataModel.ProductGoods = {}
  DataModel.MaterialGoods = {}
  for id, value in pairs(materialData) do
    if 0 < value.num then
      local cfg = PlayerData:GetFactoryData(id)
      if cfg and cfg.isDisplayInMaterialWare then
        local row = {
          info = cfg,
          type = DataModel.GetPropType(id),
          num = value.num
        }
        table.insert(DataModel.MaterialGoods, row)
      end
    end
  end
  for id, value in pairs(productData) do
    if 0 < value.num then
      local cfg = PlayerData:GetFactoryData(id)
      if cfg and cfg.isDisplayInFinishedlWare then
        local row = {
          info = cfg,
          type = DataModel.GetPropType(id),
          num = value.num
        }
        table.insert(DataModel.ProductGoods, row)
      end
    end
  end
  local curMaterials = PlayerData:GetMaterials()
  for i, v in pairs(curMaterials) do
    local cfg = PlayerData:GetFactoryData(i)
    if v.num ~= 0 and cfg and (cfg.isDisplayInMaterialWare or cfg.isDisplayInFinishedlWare) then
      local row = {
        info = cfg,
        type = DataModel.PropType.Material,
        num = v.num
      }
      table.insert(DataModel.TrainGoods, row)
    end
  end
  local curGoods = PlayerData:GetGoods()
  for i, v in pairs(curGoods) do
    if 0 < v.num then
      local cfg = PlayerData:GetFactoryData(i)
      if cfg and (cfg.isDisplayInMaterialWare or cfg.isDisplayInFinishedlWare) then
        local row = {
          info = cfg,
          type = DataModel.PropType.Goods,
          num = v.num
        }
        table.insert(DataModel.TrainGoods, row)
      end
    end
  end
  local curItems = PlayerData:GetItems()
  for i, v in pairs(curItems) do
    if 0 < v.num then
      local cfg = PlayerData:GetFactoryData(i)
      if cfg and (cfg.isDisplayInMaterialWare or cfg.isDisplayInFinishedlWare) then
        local row = {
          info = cfg,
          type = DataModel.PropType.Item,
          num = v.num
        }
        table.insert(DataModel.TrainGoods, row)
      end
    end
  end
  table.sort(DataModel.ProductGoods, DataModel.SortFunc)
  table.sort(DataModel.MaterialGoods, DataModel.SortFunc)
  table.sort(DataModel.TrainGoods, DataModel.SortFunc)
end

function DataModel.GetRemainGoodSpace(tab, isExpand)
  if not tab then
    return 0
  end
  isExpand = isExpand or false
  local prisonLevel = PrisonData.GetPrisonLv()
  local prisonCfg = PrisonData.GetPrisonCA()
  local lvCfg = prisonCfg.lvList[prisonLevel]
  local curLvSpace, remainGoodSpace
  local curMax = tab == 1 and PrisonData.GetRawMaterialWarehouseMaxCapacity() or PrisonData.GetProductWarehouseMaxCapacity()
  local cfgMax = tab == 1 and lvCfg.materialWare + lvCfg.extraMaterialWare or lvCfg.commodityWare + lvCfg.extraCommodityWare
  if curMax >= cfgMax then
    return 0
  end
  if tab == 1 then
    local curBuyExtra = PlayerData.ServerData.user_prison_info.material_space or 0
    if isExpand then
      remainGoodSpace = lvCfg.extraMaterialWare - curBuyExtra
    else
      curLvSpace = lvCfg.materialWare
      local curTotalSpace = PlayerData:GetUserInfo().space_info.max_prison_material_num or 0
      remainGoodSpace = curLvSpace - (curTotalSpace - curBuyExtra)
    end
  elseif tab == 2 then
    local curBuyExtra = PlayerData.ServerData.user_prison_info.product_space or 0
    if isExpand then
      remainGoodSpace = lvCfg.extraCommodityWare - curBuyExtra
    else
      curLvSpace = lvCfg.commodityWare
      local curTotalSpace = PlayerData:GetUserInfo().space_info.max_prison_product_num or 0
      remainGoodSpace = curLvSpace - (curTotalSpace - curBuyExtra)
    end
  end
  remainGoodSpace = remainGoodSpace < 0 and 0 or remainGoodSpace
  return remainGoodSpace
end

function DataModel.ExchangeGoods(from, to, idx, num)
  local fromData = DataModel.GetGoodsDataByType(from)
  local toData = DataModel.GetGoodsDataByType(to)
  local goodsId = fromData[idx].info.id
  fromData[idx].num = fromData[idx].num - num
  if fromData[idx].num == 0 then
    table.remove(fromData, idx)
  end
  local itemInfo = PlayerData:GetFactoryData(goodsId)
  local factoryName = DataManager:GetFactoryNameById(goodsId)
  local isAdd = false
  for i, v in ipairs(toData) do
    if v.info.id == goodsId then
      toData[i].num = toData[i].num + num
      isAdd = true
      break
    end
  end
  if not isAdd then
    table.insert(toData, {
      info = itemInfo,
      type = DataModel.GetPropType(goodsId),
      num = num
    })
  end
  if from == DataModel.GoodsPlaceType.Material then
    if DataModel.ChangeGoods[1][goodsId] == nil then
      DataModel.ChangeGoods[1][goodsId] = 0
    end
    DataModel.ChangeGoods[1][goodsId] = DataModel.ChangeGoods[1][goodsId] - num
    DataModel.StationGoodsMaterialSpace = DataModel.StationGoodsMaterialSpace - num
    if to == DataModel.GoodsPlaceType.Product then
      if not DataModel.ChangeGoods[2][goodsId] then
        DataModel.ChangeGoods[2][goodsId] = 0
      end
      DataModel.ChangeGoods[2][goodsId] = DataModel.ChangeGoods[2][goodsId] + num
      DataModel.StationGoodsProductSpace = DataModel.StationGoodsProductSpace + num
    elseif to == DataModel.GoodsPlaceType.Train and factoryName == "HomeGoodsFactory" then
      DataModel.TrainGoodsSpace = DataModel.TrainGoodsSpace + num
    end
  elseif from == DataModel.GoodsPlaceType.Product then
    if DataModel.ChangeGoods[2][goodsId] == nil then
      DataModel.ChangeGoods[2][goodsId] = 0
    end
    DataModel.ChangeGoods[2][goodsId] = DataModel.ChangeGoods[2][goodsId] - num
    DataModel.StationGoodsProductSpace = DataModel.StationGoodsProductSpace - num
    if to == DataModel.GoodsPlaceType.Material then
      if not DataModel.ChangeGoods[1][goodsId] then
        DataModel.ChangeGoods[1][goodsId] = 0
      end
      DataModel.ChangeGoods[1][goodsId] = DataModel.ChangeGoods[1][goodsId] + num
      DataModel.StationGoodsMaterialSpace = DataModel.StationGoodsMaterialSpace + num
    elseif to == DataModel.GoodsPlaceType.Train and factoryName == "HomeGoodsFactory" then
      DataModel.TrainGoodsSpace = DataModel.TrainGoodsSpace + num
    end
  elseif from == DataModel.GoodsPlaceType.Train then
    if to == DataModel.GoodsPlaceType.Material then
      if not DataModel.ChangeGoods[1][goodsId] then
        DataModel.ChangeGoods[1][goodsId] = 0
      end
      DataModel.ChangeGoods[1][goodsId] = DataModel.ChangeGoods[1][goodsId] + num
      DataModel.StationGoodsMaterialSpace = DataModel.StationGoodsMaterialSpace + num
    elseif to == DataModel.GoodsPlaceType.Product then
      if not DataModel.ChangeGoods[2][goodsId] then
        DataModel.ChangeGoods[2][goodsId] = 0
      end
      DataModel.ChangeGoods[2][goodsId] = DataModel.ChangeGoods[2][goodsId] + num
      DataModel.StationGoodsProductSpace = DataModel.StationGoodsProductSpace + num
    end
    if factoryName == "HomeGoodsFactory" then
      DataModel.TrainGoodsSpace = DataModel.TrainGoodsSpace - num
    end
  end
  return true
end

function DataModel.DealWithGoods(cb)
  local materialArr = ""
  local productArr = ""
  local materialCache = {}
  local productCache = {}
  if table.count(DataModel.ChangeGoods[1]) == 0 and table.count(DataModel.ChangeGoods[2]) == 0 then
    return
  end
  for k, v in pairs(DataModel.ChangeGoods[1]) do
    if v ~= 0 then
      materialCache[tostring(k)] = v
    end
  end
  materialArr = table.count(materialCache) > 0 and Json.encode(materialCache) or "{}"
  for k, v in pairs(DataModel.ChangeGoods[2]) do
    if v ~= 0 then
      productCache[tostring(k)] = v
    end
  end
  productArr = table.count(productCache) > 0 and Json.encode(productCache) or "{}"
  if materialArr == "{}" and productArr == "{}" then
    if cb then
      cb()
    end
    DataModel.ChangeGoods = {
      [1] = {},
      [2] = {}
    }
    return
  end
  Net:SendProto("prison.unload", function(json)
    local deltaDic = {}
    for k, v in pairs(materialCache) do
      local materialData = PrisonData.GetRawMaterialWarehouse()[tostring(k)]
      if 0 < v then
        if materialData == nil then
          PrisonData.GetRawMaterialWarehouse()[tostring(k)] = {num = v}
        else
          materialData.num = materialData.num + v
        end
      elseif v < 0 then
        materialData.num = materialData.num + v
        if materialData.num == 0 then
          PrisonData.GetRawMaterialWarehouse()[tostring(k)] = nil
        end
      end
      if deltaDic[tostring(k)] ~= nil then
        deltaDic[tostring(k)] = deltaDic[tostring(k)] + v
      else
        deltaDic[tostring(k)] = v
      end
    end
    for k, v in pairs(productCache) do
      local productData = PrisonData.GetProductWareHouse()[tostring(k)]
      if 0 < v then
        if productData == nil then
          PrisonData.GetProductWareHouse()[tostring(k)] = {num = v}
        else
          productData.num = productData.num + v
        end
      elseif v < 0 then
        productData.num = productData.num + v
        if productData.num == 0 then
          PrisonData.GetProductWareHouse()[tostring(k)] = nil
        end
      end
      if deltaDic[tostring(k)] ~= nil then
        deltaDic[tostring(k)] = deltaDic[tostring(k)] + v
      else
        deltaDic[tostring(k)] = v
      end
    end
    for i, v in pairs(deltaDic) do
      if v ~= 0 then
        local factoryName = DataManager:GetFactoryNameById(i)
        if factoryName == "SourceMaterialFactory" then
          local warehouseGoods = PlayerData:GetMaterials()[tostring(i)]
          if warehouseGoods then
            warehouseGoods.num = warehouseGoods.num - v
          else
            PlayerData.ServerData.materials[tostring(i)] = {
              dead_line = "",
              id = tostring(i),
              num = -v,
              obtain_time = TimeUtil:GetServerTimeStamp()
            }
          end
        elseif factoryName == "HomeGoodsFactory" then
          local warehouseGoods = PlayerData:GetGoods()[tostring(i)]
          if warehouseGoods then
            warehouseGoods.num = warehouseGoods.num - v
          else
            PlayerData.ServerData.user_home_info.warehouse[tostring(i)] = {
              acg_price = 0,
              num = -v,
              stations = {}
            }
          end
        elseif factoryName == "ItemFactory" then
          local warehouseGoods = PlayerData:GetItems()[tostring(i)]
          if warehouseGoods then
            warehouseGoods.num = warehouseGoods.num - v
          else
            PlayerData.ServerData.items[tostring(i)] = {
              acg_price = 0,
              num = -v,
              stations = {}
            }
          end
        end
      end
    end
    if cb then
      cb()
    end
  end, materialArr, productArr)
  DataModel.ChangeGoods = {
    [1] = {},
    [2] = {}
  }
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

function DataModel.GetPropType(id)
  local type = DataModel.PropType.None
  local factoryName = DataManager:GetFactoryNameById(id)
  if factoryName == "SourceMaterialFactory" then
    type = DataModel.PropType.Material
  elseif factoryName == "HomeGoodsFactory" then
    type = DataModel.PropType.Goods
  elseif factoryName == "ItemFactory" then
    type = DataModel.PropType.Item
  end
  return type
end

function DataModel.GetGoodsDataByType(type)
  local data
  if type == DataModel.GoodsPlaceType.Material then
    return DataModel.MaterialGoods
  elseif type == DataModel.GoodsPlaceType.Product then
    return DataModel.ProductGoods
  elseif type == DataModel.GoodsPlaceType.Train then
    return DataModel.TrainGoods
  end
end

function DataModel.GetRemainSpaceByType(type)
  local rlt = 0
  if type == DataModel.GoodsPlaceType.Material then
    return DataModel.StationGoodsMaterialMaxSpace - DataModel.StationGoodsMaterialSpace
  elseif type == DataModel.GoodsPlaceType.Product then
    return DataModel.StationGoodsProductMaxSpace - DataModel.StationGoodsProductSpace
  elseif type == DataModel.GoodsPlaceType.Train then
    return DataModel.TrainGoodsMaxSpace - DataModel.TrainGoodsSpace
  end
end

return DataModel
