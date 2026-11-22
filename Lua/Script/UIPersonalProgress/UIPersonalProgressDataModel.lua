local DataModel = {}
DataModel.allStage = {}
DataModel.stageIndexMap = {}
DataModel.curNum = 0
DataModel.finalTargetNum = 100

function DataModel.InitData()
  DataModel.curNum = 0
  DataModel.finalTargetNum = 100
  local activityCfg = PlayerData:GetFactoryData(86000001, "ActivityFactory")
  local allStage = activityCfg.PersonalProgressList or {}
  for i, v in ipairs(allStage) do
    DataModel.stageIndexMap[v.id] = i
  end
  local id = allStage[#allStage] and allStage[#allStage].id
  if id then
    local finalQuestCfg = PlayerData:GetFactoryData(id, "QuestFactory")
    DataModel.finalTargetNum = finalQuestCfg.num
  end
  DataModel.curNum = DataModel.GetCurNum()
end

function DataModel.SortStage()
  local notReceiveStage = {}
  local receiveStage = {}
  local sortAllStage = {}
  local activityCfg = PlayerData:GetFactoryData(86000001, "ActivityFactory")
  local allStage = activityCfg.PersonalProgressList or {}
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

function DataModel.GetCurNum()
  if PlayerData:GetActivityAct(86000001) then
    local activityData = PlayerData.ServerData.all_activities.ing["86000001"]
    if activityData.goods and activityData.goods["82900046"] then
      return activityData.goods["82900046"].carton_num or 0
    end
  end
  return 0
end

function DataModel.GetRedPointState()
  local activityCfg = PlayerData:GetFactoryData(86000001, "ActivityFactory")
  local allStage = activityCfg.PersonalProgressList or {}
  for i, v in ipairs(allStage) do
    local state = PlayerData.GetQuestState(v.id)
    if state == EnumDefine.EQuestState.Finish then
      return true
    end
  end
  return false
end

return DataModel
