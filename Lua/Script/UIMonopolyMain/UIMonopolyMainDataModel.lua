local DataModel = {nextRefreshTime = 0, nextRefreshTime_night = 0}

function DataModel.InitDayRefreshTime()
  local defaultConfig = PlayerData:GetFactoryData(99900001, "ConfigFactory")
  local h = tonumber(string.sub(defaultConfig.dailyRefreshTime, 1, 2))
  local m = tonumber(string.sub(defaultConfig.dailyRefreshTime, 4, 5))
  local s = tonumber(string.sub(defaultConfig.dailyRefreshTime, 7, 8))
  local targetTime = TimeUtil:GetNextSpecialTimeStamp(h, m, s)
  DataModel.nextRefreshTime = targetTime
end

function DataModel.InitDayRefreshTime_Night()
  DataModel.nextRefreshTime_night = TimeUtil:GetNextSpecialTimeStamp(20, 0, 0)
end

function DataModel.GetGetBtnState(index)
  if index == 1 then
    return 1
  end
  if PlayerData.GetLvIndexRewardInGotList(index - 1) then
    return 3
  end
  local mpyLv = PlayerData.GetUserMonopolyLv() or 1
  if index <= mpyLv then
    return 2
  end
  return 1
end

function DataModel.GetIsHasCanGetReward()
  local mapId = PlayerData.GetUserMonopolyId()
  local ca = PlayerData:GetFactoryData(mapId, "MonopolyGameMapFactory")
  if not ca then
    return false
  end
  local gameGradeList = ca.gameGradeList or {}
  for i = 1, #gameGradeList do
    local getState = DataModel.GetGetBtnState(i)
    if getState == 2 then
      return true
    end
  end
  return false
end

return DataModel
