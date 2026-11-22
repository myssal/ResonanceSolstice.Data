local DataModel = {}

local function FindParentQuestId(nextQuest)
  for i, v in ipairs(nextQuest) do
    local cfg = PlayerData:GetFactoryData(v.id)
    if next(cfg.childQuestList) then
      return v.id
    end
  end
end

local function GetSeriesQuest(questId)
  local cfg = PlayerData:GetFactoryData(questId)
  local findCount = 0
  local data = {}
  table.insert(data, questId)
  while next(cfg.nextQuest) and findCount < 100 do
    findCount = findCount + 1
    if #cfg.nextQuest == 1 then
      questId = cfg.nextQuest[1].id
      table.insert(data, questId)
      cfg = PlayerData:GetFactoryData(questId)
    else
      questId = FindParentQuestId(cfg.nextQuest)
      table.insert(data, questId)
      cfg = PlayerData:GetFactoryData(questId)
    end
  end
  return data
end

local function SortData()
  table.sort(DataModel.seriesQuestList, function(t1, t2)
    if t1.info.status ~= t2.info.status then
      return t1.info.status > t2.info.status
    end
    return t1.idx < t2.idx
  end)
end

function DataModel.Init(nowAnecdoteQuestId)
  DataModel.anecdoteList = PlayerData:GetFactoryData(99900078).AnecdoteList
  DataModel.seriesQuestList = {}
  for i, v in ipairs(DataModel.anecdoteList) do
    if TimeUtil:TimeStamp(v.startTime) <= TimeUtil.GetServerTimeStamp() then
      local data = GetSeriesQuest(v.id)
      data.idx = i
      table.insert(DataModel.seriesQuestList, data)
    end
  end
  DataModel.nowJionIdx = -1
  for i, v in ipairs(DataModel.seriesQuestList) do
    v.info = DataModel.GetSeriesQuestInfo(i)
  end
  DataModel.selectSeriesIdx = 1
  SortData()
  DataModel.isActivityJump = false
  if nowAnecdoteQuestId then
    for i, v in ipairs(DataModel.seriesQuestList) do
      if v[1] == nowAnecdoteQuestId then
        DataModel.selectSeriesIdx = i
        break
      end
    end
    DataModel.isActivityJump = true
  end
end

function DataModel.RefreshQuestStatus(status)
  local info = DataModel.seriesQuestList[DataModel.selectSeriesIdx].info
  info.status = status
  DataModel.nowJionIdx = status == 5 and DataModel.seriesQuestList[DataModel.selectSeriesIdx].idx or -1
  local branch_quests = PlayerData.ServerData.quests.branch_quests
  if branch_quests then
    if branch_quests[tostring(info.nowQuestId)] then
      branch_quests[tostring(info.nowQuestId)].unlock = status == 5 and 1 or 0
    else
      branch_quests[tostring(info.nowQuestId)] = {
        pcnt = 0,
        recv = 0,
        unlock = 1
      }
    end
  else
    PlayerData.ServerData.quests.branch_quests = {
      pcnt = 0,
      recv = 0,
      unlock = 1
    }
  end
end

function DataModel.GetSeriesQuestInfo(seriesIdx)
  local data = DataModel.seriesQuestList[seriesIdx]
  local info = {
    status = 3,
    process = 0,
    nowQuestId = data[1]
  }
  local branch_quests = PlayerData.ServerData.quests.branch_quests
  local count = #data
  local questId = PlayerData:GetFactoryData(data[1]).preQuestId
  local isFinish = PlayerData.IsQuestComplete(questId)
  if isFinish == false then
    info.status = 2
    return info
  end
  for i = count, 1, -1 do
    local branch_quests = branch_quests[tostring(data[i])]
    if branch_quests then
      local status = 1
      if 0 < branch_quests.recv then
        status = 1
      elseif branch_quests.unlock == 0 then
        status = 4
      elseif branch_quests.unlock == 1 then
        status = 5
        DataModel.nowJionIdx = data.idx
      end
      local nowQuestId = data[i]
      info.status = status
      info.process = status == 1 and 1 or (i - 1) / count
      info.nowQuestId = nowQuestId
      break
    end
  end
  return info
end

return DataModel
