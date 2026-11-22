local DataModel = {}
DataModel.SizeInfo = ""
DataModel.Hint = ""
DataModel.IsDownloading = false
DataModel.IsRetry = false
local reward = {}

function DataModel.GetRewardList()
  if next(reward) == nil then
    local config = PlayerData:GetFactoryData(99900007, "ConfigFactory")
    if config ~= nil then
      reward = config.packageRewardList
    end
  end
  return reward
end

return DataModel
