local DataModel = {
  questInfo = {},
  curSelectTabType = 1
}

function DataModel.Init()
  local ca = PlayerData:GetFactoryData(86000026)
  local rogueCA = PlayerData:GetFactoryData(ca.rogueId)
  DataModel.questInfo = {}
  for i, v in ipairs(rogueCA.questTypeList) do
    local t = {
      name = v.typeName,
      questList = {},
      completeCount = 0
    }
    local questListCA = PlayerData:GetFactoryData(v.questList)
    for idx, questInfo in ipairs(questListCA.questList) do
      local questCA = PlayerData:GetFactoryData(questInfo.id)
      local t1 = {
        id = questCA.id,
        name = questCA.name,
        desc = questCA.desc,
        rewardsList = questCA.rewardsList,
        story = questCA.story,
        maxPcnt = questCA.num,
        conditionList = questCA.conditionList,
        idx = idx
      }
      t1.state, t1.pcnt = PlayerData.GetQuestState(questInfo.id, true)
      if t1.state == EnumDefine.EQuestState.Receive then
        t.completeCount = t.completeCount + 1
      end
      table.insert(t.questList, t1)
    end
    DataModel.SortQuest(t.questList)
    table.insert(DataModel.questInfo, t)
  end
end

function DataModel.SortQuest(questList)
  table.sort(questList, function(a, b)
    if a.state == EnumDefine.EQuestState.Finish and b.state ~= EnumDefine.EQuestState.Finish then
      return true
    elseif a.state ~= EnumDefine.EQuestState.Finish and b.state == EnumDefine.EQuestState.Finish then
      return false
    end
    if a.state == EnumDefine.EQuestState.Receive and b.state ~= EnumDefine.EQuestState.Receive then
      return false
    elseif a.state ~= EnumDefine.EQuestState.Receive and b.state == EnumDefine.EQuestState.Receive then
      return true
    end
    return a.idx < b.idx
  end)
end

function DataModel.IsType1CanRecevive()
  local ca = PlayerData:GetFactoryData(86000026)
  local rogueCA = PlayerData:GetFactoryData(ca.rogueId)
  local count = #rogueCA.questTypeList
  if 1 <= count then
    local questListCA = PlayerData:GetFactoryData(rogueCA.questTypeList[1].questList)
    for idx, questInfo in ipairs(questListCA.questList) do
      local type = PlayerData.GetQuestState(questInfo.id, true)
      if type == EnumDefine.EQuestState.Finish then
        return true
      end
    end
  end
  return false
end

function DataModel.IsType2CanRecevive()
  local ca = PlayerData:GetFactoryData(86000026)
  local rogueCA = PlayerData:GetFactoryData(ca.rogueId)
  local count = #rogueCA.questTypeList
  if 1 <= count then
    local questListCA = PlayerData:GetFactoryData(rogueCA.questTypeList[count].questList)
    for idx, questInfo in ipairs(questListCA.questList) do
      local type = PlayerData.GetQuestState(questInfo.id, true)
      if type == EnumDefine.EQuestState.Finish then
        return true
      end
    end
  end
  return false
end

function DataModel.IsShowRed()
  return DataModel.IsType1CanRecevive() or DataModel.IsType2CanRecevive()
end

return DataModel
