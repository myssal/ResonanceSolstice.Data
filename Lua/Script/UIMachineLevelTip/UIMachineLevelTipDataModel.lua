local DataModel = {}

function DataModel.init()
  DataModel.makeLv = PlayerData:GetHomeInfo().compound_lv
  DataModel.makeExp = PlayerData:GetHomeInfo().compound_exp
  DataModel.machiningExpList = PlayerData:GetFactoryData(99900173).MachiningExpList
end

return DataModel
