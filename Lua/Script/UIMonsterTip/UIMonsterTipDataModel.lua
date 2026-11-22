local DataModel = {}

function DataModel.Init(initParams)
  DataModel.activityId = Json.decode(initParams).id
  DataModel.activityCA = PlayerData:GetFactoryData(DataModel.activityId)
  local ActivityMainDataModel = require("UIActivityMain/UIActivityMainDataModel")
  local index = ActivityMainDataModel.GetActivityTipsIndex(DataModel.activityId)
  DataModel.index = index
end

return DataModel
