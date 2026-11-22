local DataModel = {
  ActivityId = 86000016,
  ActivityCA = nil,
  RewardList = {},
  IsOpen = false
}

function DataModel.InitData(initParams)
  if initParams then
    local parms = Json.decode(initParams)
    DataModel.ActivityId = parms.activityId
    DataModel.ChooseLeftIndex = parms.index or 1
    DataModel.ActivityCA = PlayerData:GetFactoryData(DataModel.ActivityId)
    DataModel.IsOpen = PlayerData.ServerData.user_prison_info
  end
end

function DataModel:QuestIsFinish(questId)
  if questId == nil then
    return false
  end
  local type = PlayerData.GetQuestState(questId)
  if type == EnumDefine.EQuestState.UnFinish or type == EnumDefine.EQuestState.Lock then
    return false
  end
  return true
end

return DataModel
