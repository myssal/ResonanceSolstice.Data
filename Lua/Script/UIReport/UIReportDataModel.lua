local DataModel = {
  params = nil,
  decodeParams = nil,
  weekDayCoefficient = 1,
  battlePassCoefficient = 1
}

function DataModel.Init()
  local entrustConfig = PlayerData:GetFactoryData(99900069)
  DataModel.weekDayCoefficient = entrustConfig.weekDayCoefficient
  DataModel.battlePassCoefficient = entrustConfig.battlePassCoefficient
end

return DataModel
