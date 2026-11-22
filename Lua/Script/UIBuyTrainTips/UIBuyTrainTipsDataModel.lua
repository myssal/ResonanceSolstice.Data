local DataModel = {
  weaponId = 0,
  curCount = 0,
  maxCount = 100,
  minCount = 1,
  goodsCA = nil,
  shopId = 40300082
}

function DataModel.GetShopGoodId()
  local storeCA = PlayerData:GetFactoryData(DataModel.shopId, "StoreFactory")
  if not storeCA then
    return nil
  end
  local shopList = storeCA.shopList
  if not shopList or not shopList[1] then
    return nil
  end
  return shopList[1].id
end

return DataModel
