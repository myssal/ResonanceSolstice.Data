local DataModel = {
  initParams = {},
  GoldMaxSpace = 0,
  DiamondMaxSpace = 0,
  expandInfo = {
    isUnlock = false,
    repLock = 0,
    numLock = 0,
    expandNum = 0
  },
  EnumType = {
    Buy = 1,
    Expand = 2,
    Transport = 3
  }
}

function DataModel.RefreshRemainStationSpace()
  DataModel.GoldMaxSpace = DataModel.GetRemainBuySpace(DataModel.initParams.type, false)
  DataModel.DiamondMaxSpace = DataModel.GetRemainBuySpace(DataModel.initParams.type, true)
end

function DataModel.RefreshExpandInfo()
end

function DataModel.GetRemainBuySpace(tab, isExpand)
  tab = tab or DataModel.initParams.type
  isExpand = isExpand or false
  local prisonLevel = PrisonData.GetPrisonLv()
  local prisonCfg = PrisonData.GetPrisonCA()
  local lvCfg = prisonCfg.lvList[prisonLevel]
  local curLvSpace, remainGoodSpace
  local itemMExtra = PlayerData.ServerData.user_prison_info.item_material_space or 0
  local itemPExtra = PlayerData.ServerData.user_prison_info.item_product_space or 0
  local curMax = tab == 1 and PrisonData.GetRawMaterialWarehouseMaxCapacity() or PrisonData.GetProductWarehouseMaxCapacity()
  local cfgMax = tab == 1 and lvCfg.materialWare + lvCfg.extraMaterialWare + itemMExtra or lvCfg.commodityWare + lvCfg.extraCommodityWare + itemPExtra
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
      curTotalSpace = curTotalSpace - itemMExtra
      remainGoodSpace = curLvSpace - (curTotalSpace - curBuyExtra)
    end
  elseif tab == 2 then
    local curBuyExtra = PlayerData.ServerData.user_prison_info.product_space or 0
    if isExpand then
      remainGoodSpace = lvCfg.extraCommodityWare - curBuyExtra
    else
      curLvSpace = lvCfg.commodityWare
      local curTotalSpace = PlayerData:GetUserInfo().space_info.max_prison_product_num or 0
      curTotalSpace = curTotalSpace - itemPExtra
      remainGoodSpace = curLvSpace - (curTotalSpace - curBuyExtra)
    end
  end
  remainGoodSpace = remainGoodSpace < 0 and 0 or remainGoodSpace
  return remainGoodSpace
end

return DataModel
