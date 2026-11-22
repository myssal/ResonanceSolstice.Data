local DataModel = {}

function DataModel.InitData(data)
  DataModel.activityId = data.activityId
  DataModel.cfg = PlayerData:GetFactoryData(DataModel.activityId)
  DataModel.netData = PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)]
end

return DataModel
