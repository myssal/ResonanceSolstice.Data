local DataModel = {}

function DataModel.Init(shopData)
  DataModel.shopId = "88800088"
  DataModel.itemList = {}
  local itemData
  for k, v in pairs(shopData) do
    DataModel.shopId = k
    itemData = v
    break
  end
  local goodsList = PlayerData:GetFactoryData(DataModel.shopId).goodsList
  for i, v in ipairs(goodsList) do
    local data = itemData[tostring(v.id)]
    if data then
      local info = {
        id = v.id,
        num = data.num or 0,
        moneyId = v.currencyId,
        price = v.currencyNum
      }
      table.insert(DataModel.itemList, info)
    end
  end
  DataModel.itemList = DataModel.itemList or {}
  DataModel.ownMaxNum = PlayerData:GetFactoryData(PlayerData.GetMonopolyControlId()).itemLimit
end

return DataModel
