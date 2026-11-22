local DataModel = {}

local function FindParentQuestId(nextQuest)
  for i, v in ipairs(nextQuest) do
    local cfg = PlayerData:GetFactoryData(v.id)
    if next(cfg.childQuestList) then
      return v.id
    end
  end
end

local function GetLastQuest(questId)
  local cfg = PlayerData:GetFactoryData(questId)
  local findCount = 0
  while next(cfg.nextQuest) and findCount < 100 do
    findCount = findCount + 1
    if #cfg.nextQuest == 1 then
      questId = cfg.nextQuest[1].id
      cfg = PlayerData:GetFactoryData(questId)
    else
      questId = FindParentQuestId(cfg.nextQuest)
      cfg = PlayerData:GetFactoryData(questId)
    end
  end
  return questId
end

function DataModel.Init()
  local anecdoteList = PlayerData:GetFactoryData(99900078).AnecdoteList
  local nowTime = -1
  local data = anecdoteList[1]
  for i, v in ipairs(anecdoteList) do
    local startTime = TimeUtil:TimeStamp(v.startTime)
    if nowTime <= startTime and startTime <= TimeUtil.GetServerTimeStamp() then
      nowTime = startTime
      data = v
    end
  end
  DataModel.anecdoteData = data
  local lastQuestId = GetLastQuest(data.id)
  DataModel.tokenTipsPath = nil
  DataModel.tokenName = nil
  local cfg = PlayerData:GetFactoryData(lastQuestId)
  for i, v in ipairs(cfg.rewardsList) do
    local ca = PlayerData:GetFactoryData(v.id)
    if ca.isKeepSake then
      DataModel.tokenTipsPath = ca.tipsPath
      DataModel.tokenName = ca.name
      break
    end
  end
end

function DataModel.GetRedDotStatus()
  local anecdoteList = PlayerData:GetFactoryData(99900078).AnecdoteList
  local nowTime = -1
  local data
  for i, v in ipairs(anecdoteList) do
    local startTime = TimeUtil:TimeStamp(v.startTime)
    if nowTime <= startTime and startTime <= TimeUtil.GetServerTimeStamp() then
      nowTime = startTime
      data = v
    end
  end
  if data == nil then
    return false
  end
  local redStatus = PlayerData:GetPlayerPrefs("int", data.id .. "Activity")
  return redStatus ~= 1
end

return DataModel
