local Act_DataModel = require("UIActivitySafe/UIActivitySafeDataModel")
local DataModel = {
  data = nil,
  rewardInfo = {},
  allBuildList = {},
  curPondList = {},
  curBuildId = nil,
  curPondId = nil,
  rewardState = {
    canNot = 1,
    canGet = 2,
    hasGet = 3
  }
}

function DataModel.Init()
  local serverInfo = PlayerData.ServerData.security_levels[tostring(DataModel.data.buildingId)]
  local pondServerInfo = serverInfo[tostring(DataModel.data.pondId)]
  local pondCA = PlayerData:GetFactoryData(DataModel.data.pondId)
  local rewards = pondServerInfo.rewards or {}
  local cacheReward = {}
  for k, v in pairs(rewards) do
    cacheReward[v + 1] = true
  end
  DataModel.rewardInfo = {}
  for k, v in ipairs(pondCA.expelRewardList) do
    local t = {}
    t.idx = k
    t.needExpel = v.expel
    t.expelPercent = t.needExpel / pondCA.expelNum * 100
    t.expelPercent = math.floor(t.expelPercent + 1.0E-4)
    local ca = PlayerData:GetFactoryData(v.id)
    t.rewardItems = ca.rewardList
    t.received = cacheReward[k] ~= nil
    t.canGet = pondServerInfo.expel_num >= t.needExpel
    table.insert(DataModel.rewardInfo, t)
  end
  DataModel.Sort()
end

function DataModel.Sort()
  table.sort(DataModel.rewardInfo, function(a, b)
    if a.received and not b.received then
      return false
    end
    if not a.received and b.received then
      return true
    end
    if a.canGet and not b.canGet then
      return true
    end
    if not a.canGet and b.canGet then
      return false
    end
    return a.idx < b.idx
  end)
end

function DataModel.InitData(data)
  data = data or {}
  DataModel.curBuildId = data.buildingId or DataModel.GetFirstBuild()
  DataModel.curPondId = data.pondId or DataModel.GetFirstPondId()
end

function DataModel.RefreshRewardInfo()
  if not DataModel.curBuildId or not DataModel.curPondId then
    return
  end
  local serverInfo = PlayerData.ServerData.security_levels[tostring(DataModel.curBuildId)]
  local pondServerInfo = serverInfo[tostring(DataModel.curPondId)]
  local pondCA = PlayerData:GetFactoryData(DataModel.curPondId)
  local rewards = pondServerInfo.rewards or {}
  local cacheReward = {}
  for k, v in pairs(rewards) do
    cacheReward[v + 1] = true
  end
  DataModel.rewardInfo = {}
  for k, v in ipairs(pondCA.expelRewardList) do
    local t = {}
    t.idx = k
    t.needExpel = v.expel
    t.expelPercent = t.needExpel / pondCA.expelNum * 100
    t.expelPercent = math.floor(t.expelPercent + 1.0E-4)
    local ca = PlayerData:GetFactoryData(v.id)
    t.rewardItems = ca.rewardList
    t.received = cacheReward[k] ~= nil
    t.canGet = pondServerInfo.expel_num >= t.needExpel
    table.insert(DataModel.rewardInfo, t)
  end
  DataModel.Sort()
end

function DataModel.GetAllSafeStationList()
  return Act_DataModel.GetAllSafeStationList()
end

function DataModel.GetFirstBuild()
  local allBuildList = DataModel.GetAllSafeStationList() or {}
  if allBuildList[1] then
    return allBuildList[1].id
  end
  return nil
end

function DataModel.GetFirstPondId()
  local buildId = DataModel.GetFirstBuild()
  if not buildId then
    return nil
  end
  local pondId
  local buildingCA = PlayerData:GetFactoryData(buildId)
  if buildingCA and buildingCA.createQuestList then
    pondId = buildingCA.createQuestList[1].id
  end
  return pondId
end

return DataModel
