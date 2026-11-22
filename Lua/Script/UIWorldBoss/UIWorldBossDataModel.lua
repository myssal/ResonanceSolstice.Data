local DataModel = {}

function DataModel.InitData(data)
  DataModel.activityId = data.activityId
  DataModel.cfg = PlayerData:GetFactoryData(DataModel.activityId)
end

return DataModel
