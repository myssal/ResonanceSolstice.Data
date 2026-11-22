local DataModel = {
  initParams = {},
  itemId = 0,
  canUseNum = 0,
  oneAddNum = 0,
  hadNum = 0,
  curUseNum = 1,
  expandIndex = 0
}

function DataModel.Init()
  DataModel.curUseNum = 1
  local prisonCfg = PrisonData.GetPrisonCA()
  local extraCfg = prisonCfg.buyWarehouseExtra[1]
  DataModel.itemId = extraCfg.id
  DataModel.oneAddNum = extraCfg.wareNum
  DataModel.hadNum = PlayerData:GetGoodsById(DataModel.itemId).num
end

return DataModel
