local View = require("UIHYOrderRecord/UIHYOrderRecordView")
local DataModel = {}
DataModel.recordOrders = {}
DataModel.OrderType = {Normal = 1, Week = 2}

function DataModel.SetJsonData(json)
  DataModel.recordOrders = {}
  if not json then
    return
  end
  local data = Json.decode(json)
  if data.weekOrders then
    for i, orderId in pairs(data.weekOrders) do
      table.insert(DataModel.recordOrders, {
        orderId = orderId,
        orderType = DataModel.OrderType.Week
      })
    end
  end
  if data.normalOrders then
    for i, v in pairs(data.normalOrders) do
      table.insert(DataModel.recordOrders, {
        severIndex = i,
        orderId = v.oid,
        orderType = DataModel.OrderType.Normal
      })
    end
  end
end

function DataModel.InitData()
end

function DataModel.RefreshOnShow()
  local record = table.count(DataModel.recordOrders) > 0
  View.Img_BGNoOrder:SetActive(not record)
  View.Group_Location:SetActive(record)
  View.ScrollGrid_.grid.self:SetActive(record)
  if record then
    View.ScrollGrid_.grid.self:SetDataCount(table.count(DataModel.recordOrders))
    View.ScrollGrid_.grid.self:RefreshAllElement()
    local buildCA = PlayerData:GetFactoryData(84400137, "BuildingFactory")
    View.Group_Location.Group_Content.Txt_:SetText(buildCA.name)
  end
end

function DataModel.IsOrderCanDeliver(orderId, orderType)
  if orderType == DataModel.OrderType.Normal then
    local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
    for i, v in ipairs(orderCA.requireItemList) do
      local haveNum = PrisonData.GetGoodsById(v.id)
      if haveNum < v.num then
        return false
      end
    end
  elseif orderType == DataModel.OrderType.Week then
    local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
    local itemCfg = orderCA.weekRequireItemList[1]
    if not itemCfg then
      return false
    end
    local haveNum = PrisonData.GetGoodsById(itemCfg.id)
    return haveNum >= itemCfg.perNum
  end
  return true
end

return DataModel
