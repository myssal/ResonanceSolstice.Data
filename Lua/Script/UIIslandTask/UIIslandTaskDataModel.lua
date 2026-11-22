local DataModel = {
  initParams = {},
  questInfos = {},
  npcId = 0,
  curQuestTraceId = 0,
  inCompletePath = "UI/Island_Task/Btm1",
  plotInCompletePath = "UI/Island_Task/Btm3",
  cancelBg = "UI/Island_Task/CancelBg",
  plotCancelBg = "UI/Island_Task/CancelBg2"
}

function DataModel.Init()
  DataModel.curQuestTraceId = PlayerData:GetPlayerPrefs("int", "PlaygroundQuestTrace" .. DataModel.initParams.playgroundId)
  local playgroundCA = PlayerData:GetFactoryData(DataModel.initParams.playgroundId)
  DataModel.npcId = playgroundCA.npcId
  DataModel.questInfos = {}
  local questConfig = PlayerData:GetFactoryData(99900009)
  local cacheLocalQuest = {}
  for i, v in ipairs(questConfig.addScore) do
    cacheLocalQuest[v.id] = 1
  end
  local roomData = CommonCoachData.GetRoomData(DataModel.initParams.playgroundId, true)
  local totalScoreInfo = {
    pet = 0,
    fish = 0,
    comfort = 0,
    plant = 0,
    food = 0,
    play = 0,
    medical = 0
  }
  for i, v in ipairs(roomData) do
    for i1, v1 in ipairs(v.location) do
      local scoreInfo = PlayerData.GetFurScoreWithAllBuff(v1.id, playgroundCA.bag)
      totalScoreInfo.pet = totalScoreInfo.pet + scoreInfo.pet
      totalScoreInfo.fish = totalScoreInfo.fish + scoreInfo.fish
      totalScoreInfo.comfort = totalScoreInfo.comfort + scoreInfo.comfort
      totalScoreInfo.plant = totalScoreInfo.plant + scoreInfo.plant
      totalScoreInfo.food = totalScoreInfo.food + scoreInfo.food
      totalScoreInfo.play = totalScoreInfo.play + scoreInfo.play
      totalScoreInfo.medical = totalScoreInfo.medical + scoreInfo.medical
    end
  end
  local serverInfo = CommonCoachData.GetCurPlaygroundServerInfo(DataModel.initParams.playgroundId) or {}
  local playgroundLv = serverInfo.lv or 1
  local idx = 1
  for i, v in ipairs(playgroundCA.questList) do
    local questCA = PlayerData:GetFactoryData(v.id)
    if not questCA.playgroundLv or not (playgroundLv < questCA.playgroundLv) then
      local state, pcnt = PlayerData.GetQuestState(v.id)
      if state ~= EnumDefine.EQuestState.Lock then
        local t = {}
        t.id = v.id
        t.name = questCA.name
        t.describe = questCA.describeNew
        t.rewardsList = questCA.rewardsList
        t.isPlotTask = questCA.IsPlotTask or false
        t.maxPcnt = questCA.num
        t.state = state
        t.pcnt = pcnt or 0
        if cacheLocalQuest[v.id] then
          local checkOk = true
          for i1, v1 in ipairs(questCA.conditionList) do
            local val = tonumber(v1.val)
            if v1.key == "groundId" then
              checkOk = checkOk and val == DataModel.initParams.playgroundId
            elseif v1.key == "comfortScores" then
              checkOk = checkOk and val <= totalScoreInfo.comfort
            elseif v1.key == "foodScores" then
              checkOk = checkOk and val <= totalScoreInfo.food
            elseif v1.key == "playScores" then
              checkOk = checkOk and val <= totalScoreInfo.play
            elseif v1.key == "plantScores" then
              checkOk = checkOk and val <= totalScoreInfo.plant
            end
          end
          if checkOk then
            t.pcnt = 1
            if t.state ~= EnumDefine.EQuestState.Receive then
              if t.maxPcnt > t.pcnt then
                t.state = EnumDefine.EQuestState.UnFinish
              else
                t.state = EnumDefine.EQuestState.Finish
              end
            end
          end
        end
        t.tabUI = questCA.questTab
        t.isShowProgress = questCA.isShowProgress
        t.idx = i
        if t.state == EnumDefine.EQuestState.Receive then
          t.tabUI = questCA.completeTab
          table.insert(DataModel.questInfos, t)
        else
          if t.state == EnumDefine.EQuestState.Finish then
            t.tabUI = questCA.completeTab
          end
          table.insert(DataModel.questInfos, idx, t)
          idx = idx + 1
        end
      end
    end
  end
  DataModel.SortQuest()
end

function DataModel.SortQuest()
  table.sort(DataModel.questInfos, function(a, b)
    if a.state == EnumDefine.EQuestState.Receive and b.state ~= EnumDefine.EQuestState.Receive then
      return false
    end
    if a.state ~= EnumDefine.EQuestState.Receive and b.state == EnumDefine.EQuestState.Receive then
      return true
    end
    return a.idx < b.idx
  end)
end

function DataModel.IsCanReceive(reset, playgroundId)
  if reset == nil then
    reset = false
  end
  if playgroundId ~= nil then
    if DataModel.initParams == nil then
      DataModel.initParams = {}
    end
    DataModel.initParams.playgroundId = playgroundId
  end
  if reset then
    DataModel.Init()
  end
  for i, v in ipairs(DataModel.questInfos) do
    if v.state == EnumDefine.EQuestState.Finish then
      return true
    end
  end
  return false
end

return DataModel
