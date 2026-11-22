local CoreRew_Model = require("UIEngineCoreReward/UIEngineCoreRewardDataModel")
local DataModel = {activityId = 86000092}

function DataModel.GetSkipPanelStr()
  local activityCfg = PlayerData:GetFactoryData(DataModel.activityId, "ActivityFactory")
  if activityCfg then
    return activityCfg.openUi
  end
  return nil
end

return DataModel
