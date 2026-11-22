local DataModel = {}
DataModel.allStage = {}
DataModel.stageIndexMap = {}
DataModel.curStageIndex = 0
DataModel.curStageCfg = {}
DataModel.curNum = 0
DataModel.finalTargetNum = 100

function DataModel.InitData()
  DataModel.stageIndexMap = {}
  DataModel.curStageIndex = 0
  DataModel.curStageCfg = {}
  DataModel.curNum = 0
  DataModel.finalTargetNum = 100
  local activityCfg = PlayerData:GetFactoryData(86000001, "ActivityFactory")
  local allStage = activityCfg.ServerProgressList or {}
  for i, v in ipairs(allStage) do
    DataModel.stageIndexMap[v.id] = i
  end
  local id = allStage[#allStage] and allStage[#allStage].id
  if id then
    local finalQuestCfg = PlayerData:GetFactoryData(id, "QuestFactory")
    DataModel.finalTargetNum = finalQuestCfg.num
  end
  DataModel.curNum = DataModel.GetCurNum()
  local info = DataModel.GetCurStageInfo()
  DataModel.curStageIndex = info.index or 0
  DataModel.curStageCfg = info.cfg
end

function DataModel.SortStage()
  local notReceiveStage = {}
  local receiveStage = {}
  local sortAllStage = {}
  local activityCfg = PlayerData:GetFactoryData(86000001, "ActivityFactory")
  local allStage = activityCfg.ServerProgressList or {}
  for i, v in ipairs(allStage) do
    if PlayerData.GetQuestState(v.id) == EnumDefine.EQuestState.Receive then
      table.insert(receiveStage, v)
    else
      table.insert(notReceiveStage, v)
    end
  end
  for i, v in ipairs(notReceiveStage) do
    table.insert(sortAllStage, v)
  end
  for i, v in ipairs(receiveStage) do
    table.insert(sortAllStage, v)
  end
  DataModel.allStage = sortAllStage
end

function DataModel.GetCurStageInfo()
  local curNum = DataModel.GetCurNum()
  return DataModel.GetStageInfo(curNum)
end

function DataModel.GetNextStageInfo()
  local info = {}
  local curNum = DataModel.GetCurNum()
  local activityCfg = PlayerData:GetFactoryData(86000001, "ActivityFactory")
  local allStage = activityCfg.ServerProgressList or {}
  for i, v in ipairs(allStage) do
    local questCfg = PlayerData:GetFactoryData(v.id, "QuestFactory")
    if curNum < questCfg.num then
      info.cfg = v
      info.index = i
      break
    end
  end
  return info
end

function DataModel.GetStageInfo(num)
  local info = {}
  local activityCfg = PlayerData:GetFactoryData(86000001, "ActivityFactory")
  local allStage = activityCfg.ServerProgressList or {}
  for i, v in ipairs(allStage) do
    local questCfg = PlayerData:GetFactoryData(v.id, "QuestFactory")
    if num >= questCfg.num then
      info.cfg = v
      info.index = i
    else
      break
    end
  end
  if not info.cfg then
    info.cfg = allStage[1]
    info.index = 0
  end
  return info
end

function DataModel.GetCurNum()
  local curNum = 0
  local serverQuests = PlayerData.ServerData.server_quests or {}
  for i, v in pairs(serverQuests) do
    curNum = math.max(curNum, v.pcnt)
  end
  return curNum
end

function DataModel.GetRedPointState()
  local activityCfg = PlayerData:GetFactoryData(86000001, "ActivityFactory")
  local allStage = activityCfg.ServerProgressList or {}
  for i, v in ipairs(allStage) do
    if v.limit and v.limit > 0 then
      local limitQuestState = PlayerData.GetQuestState(v.limit)
      if limitQuestState == EnumDefine.EQuestState.Lock or limitQuestState == EnumDefine.EQuestState.UnFinish then
        return false
      end
    end
    local state = PlayerData.GetQuestState(v.id)
    if state == EnumDefine.EQuestState.Finish then
      return true
    end
  end
  return false
end

return DataModel
