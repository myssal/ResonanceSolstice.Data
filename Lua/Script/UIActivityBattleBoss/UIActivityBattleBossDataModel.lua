local DataModel = {
  ActivityId = nil,
  ActivityCA = {},
  CloseTime = nil,
  RewardList = {},
  StationCA = {},
  TurntableCA = {}
}

function DataModel:Init(initParams)
  if initParams then
    local parms = Json.decode(initParams)
    DataModel.ActivityId = parms.activityId
    DataModel.CloseTime = parms.closeTime
    DataModel.ActivityCA = PlayerData:GetFactoryData(DataModel.ActivityId)
    local stationId = DataModel.ActivityCA.correspondingCity[1].id
    local stationCA = PlayerData:GetFactoryData(stationId)
    DataModel.StationCA = stationCA
    DataModel.TurntableCA = PlayerData:GetFactoryData(DataModel.StationCA.turntableId)
  end
end

return DataModel
