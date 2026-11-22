local DataModel = {}

function DataModel.Init()
  local data = PlayerData:GetFactoryData(84400105)
  DataModel.openList = data.openPageList
  DataModel.StationId = data.stationId
  DataModel.NpcId = data.npcId
  DataModel.BgPath = data.bgPath
  DataModel.BgColor = data.bgColor or "FFFFFF"
  DataModel.buildingIconPath = data.buildingIconPath
  DataModel.name = data.name
end

return DataModel
