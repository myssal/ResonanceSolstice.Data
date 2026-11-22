local DataModel = {
  initParams = {},
  decodeParams = {},
  questInfo = {},
  curShowQuest = {},
  curShowType = 1
}

function DataModel.InitQuestInfo()
  DataModel.curShowType = 1
  DataModel.questInfo = {}
  local activityCA = PlayerData:GetFactoryData(DataModel.decodeParams.activityId)
  local serverActivityQuest = PlayerData.ServerData.quests.activity_quests
  for i, v in ipairs(activityCA.PersonalProgressList) do
    local detailServer = serverActivityQuest[tostring(v.id)]
    local questCA = PlayerData:GetFactoryData(v.id)
    local t = {}
    t.id = v.id
    t.pcnt = detailServer and detailServer.pcnt or 0
    t.idx = i
    t.state = PlayerData.GetQuestState(t.id)
    t.isAllTask = questCA.isAllTask or false
    DataModel.questInfo[i] = t
  end
  DataModel.SortQuestInfo(DataModel.questInfo)
end

function DataModel.SortQuestInfo(questList)
  table.sort(questList, function(a, b)
    if a.state == EnumDefine.EQuestState.Finish and b.state ~= EnumDefine.EQuestState.Finish then
      return true
    end
    if a.state ~= EnumDefine.EQuestState.Finish and b.state == EnumDefine.EQuestState.Finish then
      return false
    end
    if a.state == EnumDefine.EQuestState.UnFinish and b.state ~= EnumDefine.EQuestState.UnFinish then
      return true
    end
    if a.state ~= EnumDefine.EQuestState.UnFinish and b.state == EnumDefine.EQuestState.UnFinish then
      return false
    end
    if a.state == EnumDefine.EQuestState.Receive and b.state ~= EnumDefine.EQuestState.Receive then
      return false
    end
    if a.state ~= EnumDefine.EQuestState.Receive and b.state == EnumDefine.EQuestState.Receive then
      return true
    end
    return a.idx < b.idx
  end)
end

function DataModel.GetCurShowQuest(showType)
  DataModel.curShowQuest = {}
  local isAllTask = false
  if showType == 2 then
    isAllTask = true
  end
  for _, v in ipairs(DataModel.questInfo) do
    if v.isAllTask == isAllTask then
      table.insert(DataModel.curShowQuest, v)
    end
  end
  return DataModel.curShowQuest
end

function DataModel.GetTabIsHadQuestCanGet()
  local state1 = false
  local state2 = false
  for _, v in ipairs(DataModel.questInfo) do
    if v.state == EnumDefine.EQuestState.Finish then
      if v.isAllTask then
        state2 = true
      else
        state1 = true
      end
      if state1 and state2 then
        break
      end
    end
  end
  return state1, state2
end

function DataModel.IsHadQuestCanGet(activityId)
  local activityCA = PlayerData:GetFactoryData(activityId)
  if activityCA then
    for i, v in ipairs(activityCA.PersonalProgressList) do
      if PlayerData.GetQuestState(v.id) == EnumDefine.EQuestState.Finish then
        return true
      end
    end
  end
  return false
end

function DataModel.GetQuestCompletePercent(activityId)
  local activityCA = PlayerData:GetFactoryData(activityId)
  local totalCount = 1
  local completeCount = 0
  if activityCA then
    totalCount = #activityCA.PersonalProgressList
    for i, v in ipairs(activityCA.PersonalProgressList) do
      if PlayerData.GetQuestState(v.id) == EnumDefine.EQuestState.Receive then
        completeCount = completeCount + 1
      end
    end
  end
  return completeCount / totalCount
end

return DataModel
