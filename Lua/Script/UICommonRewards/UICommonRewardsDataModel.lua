local DataModel = {
  cubeId = 89400002,
  lvRewardList = {},
  lvState = {
    canNotGet = 1,
    canGet = 2,
    hasGet = 3
  }
}

function DataModel.Init()
  DataModel.InitLevelList()
end

function DataModel.InitLevelList()
  DataModel.lvRewardList = {}
  local cubeConfig = PlayerData:GetFactoryData(DataModel.cubeId, "CubeRogueFactory")
  if not cubeConfig or not cubeConfig.commonLevelStageList then
    return
  end
  local timeNow = TimeUtil:GetServerTimeStamp() or 0
  local openIds = {}
  for i = 1, #cubeConfig.commonLevelStageList do
    local timeStr = cubeConfig.commonLevelStageList[i].startTime
    if not string.nilorempty(timeStr) then
      local startTime = TimeUtil:TimeStamp(cubeConfig.commonLevelStageList[i].startTime) or 0
      if timeNow >= startTime then
        table.insert(openIds, cubeConfig.commonLevelStageList[i].stageList)
      end
    end
  end
  for i = 1, #openIds do
    local actInfo = PlayerData:GetFactoryData(openIds[i], "ActivityListFactory")
    if actInfo then
      local rewList = actInfo.rewardsList
      if rewList then
        for j = 1, #rewList do
          table.insert(DataModel.lvRewardList, rewList[j])
        end
      end
    end
  end
end

function DataModel.GetCubeRewardLv()
  if not PlayerData.TempCache or not PlayerData.TempCache.CubeRogueData then
    return 0
  end
  return PlayerData.TempCache.CubeRogueData.lv or 0
end

function DataModel.SetCubeRewardLv(lv)
  if not (lv and PlayerData.TempCache) or not PlayerData.TempCache.CubeRogueData then
    return
  end
  PlayerData.TempCache.CubeRogueData.lv = lv
end

function DataModel.GetCubeRewardIsGet()
  if not PlayerData.TempCache or not PlayerData.TempCache.CubeRogueData then
    return false
  end
  local gotLv = PlayerData.TempCache.CubeRogueData.lv_reward or 0
  local nowLv = DataModel.GetCubeRewardLv() or 0
  if 0 < nowLv and nowLv == gotLv then
    return true
  end
  return false
end

function DataModel.SetCubeRewardGotLv(lv)
  if not PlayerData.TempCache or not PlayerData.TempCache.CubeRogueData then
    return
  end
  PlayerData.TempCache.CubeRogueData.lv_reward = lv
end

function DataModel.GetExpItemInfo()
  local cubeConfig = PlayerData:GetFactoryData(DataModel.cubeId, "CubeRogueFactory")
  if not cubeConfig then
    return nil
  end
  return PlayerData:GetFactoryData(cubeConfig.commonExperienceItem, "ItemFactory")
end

function DataModel.GetShowExpCount()
  local lv = DataModel.GetCubeRewardLv()
  if DataModel.lvRewardList and lv >= #DataModel.lvRewardList then
    return DataModel.lvRewardList[#DataModel.lvRewardList].requiredNum or 0
  end
  return DataModel.GetExpCount()
end

function DataModel.GetExpCount()
  if not PlayerData.TempCache or not PlayerData.TempCache.CubeRogueData then
    return 0
  end
  return PlayerData.TempCache.CubeRogueData.exp or 0
end

function DataModel.SetExpCount(count)
  if not PlayerData.TempCache or not PlayerData.TempCache.CubeRogueData then
    return
  end
  PlayerData.TempCache.CubeRogueData.exp = count
end

function DataModel.GetLvCostExpByIndex(index)
  if not index then
    return 0
  end
  if not DataModel.lvRewardList then
    return 0
  end
  if index > #DataModel.lvRewardList then
    return DataModel.lvRewardList[#DataModel.lvRewardList].requiredNum or 0
  end
  local lvInfo = DataModel.lvRewardList[index]
  if not lvInfo then
    return 0
  end
  return lvInfo.requiredNum
end

function DataModel.GetTotalExpByLv(lv)
  if not DataModel.lvRewardList then
    return 0
  end
  if lv > #DataModel.lvRewardList then
    return 0
  end
  local count = 0
  for i = 1, lv do
    local lvInfo = DataModel.lvRewardList[i]
    if lvInfo then
      local requiredNum = lvInfo.requiredNum or 0
      count = count + requiredNum
    end
  end
  return count
end

function DataModel.GetLvRewardState(index)
  local lv = DataModel.GetCubeRewardLv() or 0
  local isGet = DataModel.GetCubeRewardIsGet()
  local gotLv = 0
  if PlayerData.TempCache and PlayerData.TempCache.CubeRogueData then
    gotLv = PlayerData.TempCache.CubeRogueData.lv_reward or 0
  end
  if isGet then
    if index <= lv then
      return DataModel.lvState.hasGet
    else
      return DataModel.lvState.canNotGet
    end
  elseif index <= gotLv then
    return DataModel.lvState.hasGet
  elseif index <= lv then
    return DataModel.lvState.canGet
  else
    return DataModel.lvState.canNotGet
  end
  return DataModel.lvState.canNotGet
end

function DataModel.GetFirstOpenIndex()
  if not DataModel.lvRewardList then
    return 0
  end
  local canNotIndex = 0
  for i = 1, #DataModel.lvRewardList do
    local state = DataModel.GetLvRewardState(i)
    if state == DataModel.lvState.canGet then
      return i
    elseif state == DataModel.lvState.canNotGet and canNotIndex == 0 then
      canNotIndex = i
    end
  end
  if canNotIndex == 0 then
    return #DataModel.lvRewardList
  else
    return canNotIndex
  end
end

function DataModel.AddCubeExp(count)
  if not count or count == 0 then
    return
  end
  if not DataModel.lvRewardList then
    return
  end
  local lv = DataModel.GetCubeRewardLv() or 0
  local nowExp = DataModel.GetExpCount() or 0
  local totalNowExp = nowExp + count
  if lv < #DataModel.lvRewardList then
    for i = lv + 1, #DataModel.lvRewardList do
      local cost = totalNowExp - DataModel.lvRewardList[i]
      if 0 <= cost then
        lv = lv + 1
        totalNowExp = totalNowExp - cost
      else
        break
      end
    end
  end
  DataModel.SetCubeRewardLv(lv)
  DataModel.SetExpCount(totalNowExp)
end

function DataModel.GetRedDotStatus()
  if not DataModel.lvRewardList or #DataModel.lvRewardList == 0 then
    DataModel.InitLevelList()
  end
  if not DataModel.lvRewardList then
    return false
  end
  for i = 1, #DataModel.lvRewardList do
    local state = DataModel.GetLvRewardState(i)
    if state == DataModel.lvState.canGet then
      return true
    end
  end
  return false
end

return DataModel
