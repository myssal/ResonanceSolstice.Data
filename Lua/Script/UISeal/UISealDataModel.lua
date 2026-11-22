local DataModel = {
  SealNumMax = 0,
  SealList = {},
  OtherSeal = nil,
  NewSealId = 0,
  CurSelectPos = 0,
  IsConvert = false,
  ConvertIndex = 0,
  TargetId = 0,
  IsSelected = false,
  WitchEventNextId = nil
}

function DataModel.Init()
  DataModel.IsSelected = false
  DataModel.CurSelectPos = 0
  DataModel.SealNumMax = WitchData.GetParkMapCA().sealNumMax
  DataModel.InitSealData()
  if table.count(WitchData.GetWitchesData().other_seal) == 0 then
    if DataModel.IsConvert then
      DataModel.NewSealId = DataModel.TargetId
      DataModel.CurSealNum = table.count(DataModel.SealList)
    else
      DataModel.NewSealId = WitchData.GetWitchesData().user_seal[#WitchData.GetWitchesData().user_seal]
      DataModel.CurSealNum = table.count(DataModel.SealList) - 1
    end
  elseif DataModel.IsConvert then
    DataModel.NewSealId = DataModel.TargetId
    DataModel.CurSealNum = DataModel.SealNumMax
  else
    DataModel.NewSealId = WitchData.GetWitchesData().other_seal[1]
    DataModel.CurSealNum = DataModel.SealNumMax
  end
end

function DataModel.InitSealData()
  DataModel.SealList = {}
  local witchesData = WitchData.GetWitchesData()
  if witchesData.user_seal == nil then
    witchesData.user_seal = {}
  end
  for i, v in ipairs(witchesData.user_seal) do
    local seal = {id = v}
    table.insert(DataModel.SealList, seal)
  end
  if witchesData.other_seal and next(witchesData.other_seal) then
    DataModel.OtherSeal = witchesData.other_seal[1]
  end
end

return DataModel
