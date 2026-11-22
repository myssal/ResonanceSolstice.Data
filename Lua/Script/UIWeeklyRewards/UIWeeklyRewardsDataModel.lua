local DataModel = {
  cubeId = 89400002,
  rewardList = {},
  rewardState = {
    canNotGet = 1,
    canGet = 2,
    hasGet = 3
  }
}

function DataModel.Init()
  DataModel.rewardList = {}
  local cubeConfig = PlayerData:GetFactoryData(DataModel.cubeId, "CubeRogueFactory")
  if cubeConfig then
    DataModel.rewardList = cubeConfig.weeklyRewardsList
  end
end

function DataModel.GetCurScore()
  local score = 0
  local cubeConfig = PlayerData:GetFactoryData(DataModel.cubeId, "CubeRogueFactory")
  if cubeConfig then
    score = PlayerData:GetGoodsById(cubeConfig.weeklyExperienceItem).num or 0
  end
  return score
end

function DataModel.ResetCurScore()
  local cubeConfig = PlayerData:GetFactoryData(DataModel.cubeId, "CubeRogueFactory")
  if cubeConfig then
    PlayerData:RefreshUseItems({
      [cubeConfig.weeklyExperienceItem] = DataModel.GetCurScore()
    })
  end
end

function DataModel.GetLimitScore()
  local cubeConfig = PlayerData:GetFactoryData(DataModel.cubeId, "CubeRogueFactory")
  if cubeConfig then
    DataModel.rewardList = cubeConfig.weeklyRewardsList or {}
  end
  local num = 0
  for i = 1, #DataModel.rewardList do
    if DataModel.rewardList[i] and DataModel.rewardList[i].requiredNum then
      num = num + DataModel.rewardList[i].requiredNum
    end
  end
  return num
end

function DataModel.GetRewardHasGetIndex()
  if not (PlayerData.TempCache and PlayerData.TempCache.CubeRogueData) or not PlayerData.TempCache.CubeRogueData.weekly_reward then
    return 0
  end
  return PlayerData.TempCache.CubeRogueData.weekly_reward + 1
end

function DataModel.SetRewardHasGetIndex(index)
  if not PlayerData.TempCache or not PlayerData.TempCache.CubeRogueData then
    return 0
  end
  PlayerData.TempCache.CubeRogueData.weekly_reward = index
end

function DataModel.GetRewardStateByIndex(index)
  if not index or not DataModel.rewardList then
    return DataModel.rewardState.canNotGet
  end
  local config = DataModel.rewardList[index]
  if not config then
    return DataModel.rewardState.canNotGet
  end
  local curNum = DataModel.GetCurScore() or 0
  local hasGetIndex = DataModel.GetRewardHasGetIndex() or 0
  if index <= hasGetIndex then
    return DataModel.rewardState.hasGet
  end
  local needNum = DataModel.GetCostNumByIndex(index)
  if curNum >= needNum then
    return DataModel.rewardState.canGet
  end
  return DataModel.rewardState.canNotGet
end

function DataModel.GetCostNumByIndex(index)
  if not DataModel.rewardList then
    return 0
  end
  local needNum = 0
  for i = 1, index do
    if DataModel.rewardList[i] then
      local num = DataModel.rewardList[i].requiredNum or 0
      needNum = needNum + num
    end
  end
  return needNum
end

function DataModel.GetRefreshTimeRemain()
  return TimeUtil:GetNextWeekTime(1, 5) - TimeUtil:GetServerTimeStamp()
end

function DataModel.GetCountCanGetReward()
  local score = DataModel.GetCurScore() or 0
  local rewardList = DataModel.rewardList or {}
  local count = 0
  for i = 1, #rewardList do
    score = score - rewardList[i].requiredNum
    if 0 <= score then
      count = count + 1
    end
  end
  return count
end

function DataModel.GetFirstOpenIndex()
  if not DataModel.rewardList then
    return 0
  end
  local canNotIndex = 0
  for i = 1, #DataModel.rewardList do
    local state = DataModel.GetRewardStateByIndex(i)
    if state == DataModel.rewardState.canGet then
      return i
    elseif state == DataModel.rewardState.canNotGet and canNotIndex == 0 then
      canNotIndex = i
    end
  end
  if canNotIndex == 0 then
    return #DataModel.rewardList
  else
    return canNotIndex
  end
end

function DataModel.GetRedDotStatus()
  if not DataModel.rewardList or #DataModel.rewardList == 0 then
    DataModel.Init()
    return false
  end
  if not DataModel.rewardList then
    return false
  end
  for i = 1, #DataModel.rewardList do
    local state = DataModel.GetRewardStateByIndex(i)
    if state == DataModel.rewardState.canGet then
      return true
    end
  end
  return false
end

return DataModel
