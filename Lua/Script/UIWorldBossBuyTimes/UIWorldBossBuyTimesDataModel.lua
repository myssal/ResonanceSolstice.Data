local DataModel = {}

function DataModel.InitData(data)
  DataModel.activityId = data.activityId
  DataModel.cfg = PlayerData:GetFactoryData(DataModel.activityId)
  DataModel.levelId = data.levelId
end

return DataModel
