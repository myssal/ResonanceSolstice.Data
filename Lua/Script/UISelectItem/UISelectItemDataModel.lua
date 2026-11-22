local DataModel = {}
DataModel.Id = 11400003
DataModel.showSelectDetail = 0

function DataModel.SetJsonData(initParams)
  if initParams then
    local data = Json.decode(initParams)
    DataModel.Id = data.itemId and tonumber(data.itemId) or DataModel.Id
    DataModel.showSelectDetail = data.showSelectDetail and tonumber(data.showSelectDetail) or 0
  end
end

return DataModel
