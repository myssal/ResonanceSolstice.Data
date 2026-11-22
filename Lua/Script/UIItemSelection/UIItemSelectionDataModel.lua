local OutSideData = require("UICubeSkill/UICubeSkillDataModel")
local DataModel = {}

function DataModel.GetRefreshMaxCount()
  local result = OutSideData.IsRefreshBuffSelectUnlock() or 0
  return result
end

return DataModel
