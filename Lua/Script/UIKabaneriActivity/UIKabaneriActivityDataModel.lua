local DataModel = {}

function DataModel.Init(id, closeTime)
  DataModel.activityId = id
  DataModel.closeTimeStamp = TimeUtil:TimeStamp(closeTime)
  local cfg = PlayerData:GetFactoryData(id)
  DataModel.shopId = cfg.activityStoreList[1].id
  DataModel.questId = cfg.questId
  DataModel.gameQuestId = cfg.gameQuestLimit
  DataModel.gameUnlockTipsId = cfg.gameUnlockTips
  DataModel.levelQuestId = cfg.levelQuestLimit
  DataModel.cardPackId = cfg.activityCardPack
  DataModel.activityName = cfg.name
  DataModel.SkipStationId = cfg.skipStationStart
  DataModel.startTime = cfg.startTime
  DataModel.endTime = cfg.endTime
  DataModel.rewardPreviewList = cfg.rewardPreviewList
  DataModel.isJoin = PlayerData:GetActivityAct(DataModel.activityId)
  DataModel.helpId = cfg.helpId
  DataModel.plotId = cfg.joinPlotId
  local questName = PlayerData:GetFactoryData(DataModel.questId).name
  DataModel.unlockTip = string.format(GetText(cfg.unlockTips), questName)
  DataModel.isCanJoin = false
  DataModel.gameQuestIsComplete = false
  DataModel.levelQuestIsComplete = false
  DataModel.continue = cfg.isTriggerTime
  DataModel.gameOpen = cfg.gameOpen
  DataModel.levelId = cfg.ActivityLevelId
end

function DataModel.JoinActivity()
  DataModel.isJoin = true
end

function DataModel.SetIsCanJoin(isCanJoin)
  DataModel.isCanJoin = isCanJoin
end

function DataModel.SetGameQuestStatus(isComplete)
  DataModel.gameQuestIsComplete = isComplete
end

function DataModel.SetlevelQuestStatus(isComplete)
  DataModel.levelQuestIsComplete = isComplete
end

function DataModel.ActivityOver()
  if DataModel.continue then
    return false
  end
  local serverTime = TimeUtil:GetServerTimeStamp()
  local enTime = TimeUtil:TimeStamp(DataModel.endTime)
  return enTime - serverTime <= 0
end

function DataModel.GetRemainDays()
  local day = 0
  local seconds_in_day = 86400
  local seconds_remaining = TimeUtil:TimeStamp(DataModel.endTime) - TimeUtil:GetServerTimeStamp()
  day = math.ceil(seconds_remaining / seconds_in_day)
  return day
end

function DataModel.GetCloseTimeInfo()
  local seconds_remaining = DataModel.closeTimeStamp - TimeUtil:GetServerTimeStamp()
  if seconds_remaining <= 0 then
    return string.format(GetText(80609541), 0, 0)
  end
  local seconds_in_day = 86400
  local seconds_in_hour = 3600
  local seconds_in_minute = 60
  if seconds_remaining > seconds_in_day then
    local days = math.floor(seconds_remaining / seconds_in_day)
    local hours = math.floor(seconds_remaining % seconds_in_day / seconds_in_hour)
    return string.format(GetText(80609541), days, hours)
  else
    local hours = math.floor(seconds_remaining / seconds_in_hour)
    local minutes = math.floor(seconds_remaining % seconds_in_hour / seconds_in_minute)
    return string.format(GetText(80609540), hours, minutes)
  end
end

function DataModel.GetGameUnlockTips()
  local questName = PlayerData:GetFactoryData(DataModel.gameQuestId).name
  local info = string.format(GetText(DataModel.gameUnlockTipsId), questName)
  return info
end

return DataModel
