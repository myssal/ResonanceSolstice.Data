local DataModel = {}

function DataModel.Init(isActivity)
  local volleyballConfig = PlayerData:GetFactoryData(99900067)
  DataModel.startTime = TimeUtil:TimeStamp(volleyballConfig.startTime)
  DataModel.endTime = TimeUtil:TimeStamp(volleyballConfig.endTime)
  DataModel.maxCnt = volleyballConfig.rewardNum
  DataModel.remainCnt = volleyballConfig.rewardNum - PlayerData:GetHomeInfo().vb_num
  DataModel.currentSceneName = nil
  DataModel.playGroupBackParams = nil
  if isActivity then
    DataModel.currentSceneName = MainManager.bgSceneName
  else
    DataModel.playGroupBackParams = require("UIPlayground/UIPlaygroundDataModel").initParams
  end
end

function DataModel.GameModeIsStart()
  local serverTime = TimeUtil:GetServerTimeStamp()
  local isStart = serverTime >= DataModel.startTime and serverTime <= DataModel.endTime
  return isStart
end

function DataModel.GetRemainTime()
  local seconds_remaining = DataModel.endTime - TimeUtil:GetServerTimeStamp()
  if seconds_remaining <= 0 then
    return string.format(GetText(80607858), 0, 0)
  end
  local seconds_in_day = 86400
  local seconds_in_hour = 3600
  local seconds_in_minute = 60
  if seconds_remaining > seconds_in_day then
    local days = math.floor(seconds_remaining / seconds_in_day)
    local hours = math.floor(seconds_remaining % seconds_in_day / seconds_in_hour)
    return string.format(GetText(80607859), days, hours)
  else
    local hours = math.floor(seconds_remaining / seconds_in_hour)
    local minutes = math.floor(seconds_remaining % seconds_in_hour / seconds_in_minute)
    return string.format(GetText(80607858), hours, minutes)
  end
end

return DataModel
