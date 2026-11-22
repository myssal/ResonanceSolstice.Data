local DataModel = {
  param = {},
  SelectType = {
    ViewDetail = 1,
    GachaRecord = 2,
    GachaProbability = 3
  },
  curSelect = 0,
  extractCA = nil,
  gachaRecordTable = {},
  maxPageNum = 100000,
  curSelectPage = 0,
  defaultClientPageNum = 5,
  defaultToServerPageNum = 25,
  ServerGacheConfig = {}
}

function DataModel.SetProtectInfo(protect_info)
  DataModel.ProtectInfo = protect_info
end

function DataModel.GetProtectInfoNum()
  if DataModel.ProtectInfo == nil or DataModel.ProtectInfo[tostring(DataModel.extractCA.protectTag)] == nil then
    return 0
  end
  return DataModel.ProtectInfo[tostring(DataModel.extractCA.protectTag)].num
end

return DataModel
