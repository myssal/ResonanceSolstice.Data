local DataModel = {
  BagData = {},
  CurSelectGuKaIndex = 1,
  CurSelectGuKaId = 0,
  RemainUpgradeCount = 0,
  IsClosing = false,
  IsZhanBu = false
}

function DataModel:Init()
  DataModel.IsZhanBu = false
  DataModel.IsClosing = false
  DataModel.InitBagData()
  DataModel.RemainUpgradeCount = WitchData.GetWitchesData().guka_num or 0
end

function DataModel.InitBagData()
  DataModel.BagData = WitchData.GetUpgradeGuKaList()
end

return DataModel
