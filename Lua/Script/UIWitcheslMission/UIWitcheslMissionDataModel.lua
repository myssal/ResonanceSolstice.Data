local DataModel = {
  MissionList = {},
  ActivityId = WitchData.GetActivityId()
}

function DataModel.SetJsonData(json)
  if json then
    local data = Json.decode(json)
    DataModel.ActivityId = tonumber(data.activityId) or DataModel.ActivityId
  end
end

DataModel.QuestState = {
  Receive = 1,
  UnFinish = 2,
  Finish = 3
}

function DataModel.Init()
  DataModel.CurSetMissionElementIndex = 0
  DataModel.InitMission()
end

function DataModel.InitMission(activityId)
  DataModel.MissionList = {}
  local list = DataModel.GetShowQuest(activityId or DataModel.ActivityId)
  for i, v in ipairs(list) do
    local quest = {
      id = v,
      state = DataModel.QuestState.UnFinish
    }
    local s = PlayerData.GetQuestState(v)
    if s == EnumDefine.EQuestState.Receive then
      quest.state = DataModel.QuestState.Receive
    elseif s == EnumDefine.EQuestState.UnFinish then
      quest.state = DataModel.QuestState.UnFinish
    else
      quest.state = DataModel.QuestState.Finish
    end
    table.insert(DataModel.MissionList, quest)
  end
  table.sort(DataModel.MissionList, function(a, b)
    if a.state == b.state then
      return a.id < b.id
    end
    return a.state > b.state
  end)
end

function DataModel.GetShowQuest(activityId)
  local questList = {}
  local cfg = WitchData.GetParkMapCA(activityId or DataModel.ActivityId)
  for i, v in ipairs(cfg.taskInitialList) do
    local questCA = PlayerData:GetFactoryData(v.id, "QuestFactory")
    table.insert(questList, v.id)
    local state = PlayerData.GetQuestState(v.id)
    if state == EnumDefine.EQuestState.Receive then
      for _, v1 in ipairs(questCA.nextQuest) do
        DataModel.SetNextQuest(questList, v1.id)
      end
    end
  end
  return questList
end

function DataModel.SetNextQuest(questList, questId)
  local questCA = PlayerData:GetFactoryData(questId, "QuestFactory")
  local state = PlayerData.GetQuestState(questId)
  if state ~= EnumDefine.EQuestState.Lock then
    table.insert(questList, questId)
  end
  if state == EnumDefine.EQuestState.Receive then
    for i, v in ipairs(questCA.nextQuest) do
      DataModel.SetNextQuest(questList, v.id)
    end
  end
end

function DataModel.CheckMissionRedPoint(activityId)
  DataModel.InitMission(activityId)
  for i, v in ipairs(DataModel.MissionList) do
    if v.state == DataModel.QuestState.Finish then
      return true
    end
  end
  return false
end

function DataModel.GetMissionFinishPercent(activityId)
  local finishNum = 0
  local totalNum = 0
  local missionList = WitchData.GetActivityCA(activityId or DataModel.ActivityId).PersonalProgressList
  totalNum = #missionList
  for i, v in ipairs(missionList) do
    local s = PlayerData.GetQuestState(v.id)
    if s == EnumDefine.EQuestState.Receive then
      finishNum = finishNum + 1
    end
  end
  return finishNum / totalNum
end

return DataModel
