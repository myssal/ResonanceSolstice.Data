local DataModel = {
  selectIndex = nil,
  items = {}
}

function DataModel.InitData()
  local parkMapCA = WitchData.GetParkMapCA()
  local items = {}
  local witchItems = WitchData.GetItems()
  if witchItems then
    for itemId, v in pairs(witchItems) do
      table.insert(items, itemId)
    end
  end
  if parkMapCA.parkBagList then
    for i, v in ipairs(parkMapCA.parkBagList) do
      if WitchData.GetItemNumById(v.id) > 0 then
        table.insert(items, v.id)
      end
    end
  end
  DataModel.items = items
  DataModel.selectIndex = 1
end

local CanUseInBagTypeList = {
  floatInquiry = 1,
  Broom = 1,
  SealInquiry = 1,
  Sealconvert = 1,
  guka = 1,
  energizer = 1
}

function DataModel.IsItemCanUseInBag(itemId)
  local itemCA = PlayerData:GetFactoryData(itemId, "ItemFactory")
  return CanUseInBagTypeList[itemCA.playerParkItemType]
end

return DataModel
