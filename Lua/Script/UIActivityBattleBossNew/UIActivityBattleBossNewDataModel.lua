local DataModel = {
  ActivityId = nil,
  ActivityCA = {},
  StationCA = {},
  TurntableCA = {},
  BatterInfo = {},
  remainTime = 1,
  TowerScore = 0
}

function DataModel:Init(initParams)
  DataModel.remainTime = 1
  if initParams then
    local parms = Json.decode(initParams)
    DataModel.ActivityId = parms.activityId
    DataModel.ActivityCA = PlayerData:GetFactoryData(DataModel.ActivityId)
    local stationId = DataModel.ActivityCA.correspondingCity[1].id
    local stationCA = PlayerData:GetFactoryData(stationId)
    DataModel.StationCA = stationCA
    DataModel.TurntableCA = PlayerData:GetFactoryData(DataModel.StationCA.turntableId)
  end
end

function DataModel:GetCurrentLevelData(index, max)
  local count = 0
  local currentInfo = DataModel.BatterInfo[tostring(index)]
  if currentInfo then
    count = currentInfo.cnt
  end
  return max < count and max or count
end

return DataModel
