local DataModel = {
  initParams = {},
  levelInfo = {},
  deepRemainTime = 0,
  curPos = 0,
  preLevelIdx = 0,
  curLevelIdx = 0,
  ChooseRewardList = {},
  constAutoBattleTime = 3,
  remainAutoBattleTime = 3,
  monsterLevelAutoBattle = false,
  toPlayFirstPassAnim = false,
  waitToShowComplete = true
}

function DataModel.Init()
  DataModel.curPos = DataModel.initParams.curPos or 0
  DataModel.curLevelIdx = DataModel.initParams.curLevelIdx or 0
  DataModel.monsterLevelAutoBattle = false
  DataModel.remainAutoBattleTime = DataModel.constAutoBattleTime
  DataModel.levelInfo = {}
  local activityCA = PlayerData:GetFactoryData(86000009)
  for i, v in ipairs(activityCA.levelTypeList) do
    local t = {}
    local activityListCA = PlayerData:GetFactoryData(v.id)
    DataModel.levelInfo[i] = {}
    DataModel.levelInfo[i].levelList = t
    if v.startTime and v.startTime ~= "" then
      DataModel.levelInfo[i].startTime = TimeUtil:TimeStamp(v.startTime)
    else
      DataModel.levelInfo[i].startTime = 0
    end
    for j, v1 in ipairs(activityListCA.levelList) do
      t[j] = v1.id
    end
  end
  local serverTimeStamp = TimeUtil:GetServerTimeStamp()
  DataModel.deepRemainTime = DataModel.levelInfo[2].startTime - serverTimeStamp
end

function DataModel.InitRewardList(levelId)
  local levelCA = PlayerData:GetFactoryData(levelId)
  local firstPassAward = levelCA.firstPassAward
  local dropListNew = PlayerData:GetLevelDropList(levelCA)
  local state = PlayerData:GetLevelPass(levelId)
  DataModel.ChooseRewardList = {}
  for i, v in ipairs(firstPassAward) do
    table.insert(DataModel.ChooseRewardList, {
      num = v.num,
      id = v.itemId,
      type = 1,
      isFinish = state,
      index = i
    })
  end
  for i, v in ipairs(dropListNew) do
    table.insert(DataModel.ChooseRewardList, {
      num = v.num,
      id = v.id,
      type = 2,
      index = i
    })
  end
  if state == true then
    table.sort(DataModel.ChooseRewardList, function(a, b)
      if a.type == b.type then
        return a.index < b.index
      end
      return a.type > b.type
    end)
  else
    table.sort(DataModel.ChooseRewardList, function(a, b)
      if a.type == b.type then
        return a.index < b.index
      end
      return a.type < b.type
    end)
  end
end

function DataModel.GetCurSquadIdx()
  local squadIdx = 1
  local cacheSquadIdx = PlayerData:GetPlayerPrefs("int", "LastBattleSquadIndex")
  if 0 < cacheSquadIdx then
    squadIdx = cacheSquadIdx
  elseif PlayerData.BattleInfo and PlayerData.BattleInfo.squadIndex and 0 < PlayerData.BattleInfo.squadIndex then
    squadIdx = PlayerData.BattleInfo.squadIndex
  end
  return squadIdx
end

return DataModel
