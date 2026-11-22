local DataModel = {}

local function ConvertToTimestamp(dateTimeString)
  local year, month, day, hour, min, sec = dateTimeString:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
  local timeTable = {
    year = year,
    month = month,
    day = day,
    hour = hour,
    min = min,
    sec = sec
  }
  local timestamp = os.time(timeTable)
  return timestamp
end

local function IsTimeInRange(startTime, endTime)
  local currentTimeStamp = TimeUtil.GetServerTimeStamp()
  local startTimeStamp = ConvertToTimestamp(startTime)
  local endTimeStamp = ConvertToTimestamp(endTime)
  if currentTimeStamp >= startTimeStamp and currentTimeStamp <= endTimeStamp then
    return true
  end
  return false
end

local function FindNowTimeInfo(list)
  local data = {}
  for i, v in ipairs(list) do
    if IsTimeInRange(v.startTime, v.endTime) then
      table.insert(data, v)
    end
  end
  return data
end

function DataModel.Init(activityId)
  DataModel.acitityId = activityId
  local activityIdCfg = PlayerData:GetFactoryData(DataModel.acitityId)
  DataModel.npcId = activityIdCfg.npcId
  DataModel.nowInterviewNpcInfo = FindNowTimeInfo(activityIdCfg.interviewNpcList)
  DataModel.nowTitleInfo = FindNowTimeInfo(activityIdCfg.titleTextList)
  DataModel.nowcircleTextInfo = FindNowTimeInfo(activityIdCfg.circleTextList)
  local year, month, day, hour, min, sec = activityIdCfg.startTime:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
  DataModel.startTime = string.format("%02d/%02d/%02d:%02d", month, day, hour, min)
  local year, month, day, hour, min, sec = activityIdCfg.endTime:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
  DataModel.endTime = string.format("%02d/%02d/%02d:%02d", month, day, hour, min)
  DataModel.helpId = activityIdCfg.helpId
  DataModel.nowTradList = {}
  DataModel.nowQueatList = {}
  DataModel.nowManufactureList = {}
  local recordTime = TimeUtil:GetServerTimeStamp()
  PlayerData:SetPlayerPrefs("int", "GoldWeekRedDotInfo", recordTime)
end

function DataModel.GetTradData()
  if next(DataModel.nowTradList) == nil then
    local activityIdCfg = PlayerData:GetFactoryData(DataModel.acitityId)
    DataModel.nowTradList = FindNowTimeInfo(activityIdCfg.goodsList)
  end
  return DataModel.nowTradList
end

function DataModel.GetQueatData()
  if next(DataModel.nowQueatList) == nil then
    local activityIdCfg = PlayerData:GetFactoryData(DataModel.acitityId)
    DataModel.nowQueatList = FindNowTimeInfo(activityIdCfg.activityPassengerList)
    local data = FindNowTimeInfo(activityIdCfg.activityLeafletList)
    for i, v in ipairs(data) do
      table.insert(DataModel.nowQueatList, v)
    end
    data = FindNowTimeInfo(activityIdCfg.activityGradeList)
    for i, v in ipairs(data) do
      local cfg = PlayerData:GetFactoryData(v.id)
      for i, v in ipairs(cfg.passengerBufflList) do
        table.insert(DataModel.nowQueatList, {
          id = v.id,
          isGrade = true
        })
      end
    end
  end
  return DataModel.nowQueatList
end

function DataModel.GetManufactureData()
  if next(DataModel.nowManufactureList) == nil then
    local activityIdCfg = PlayerData:GetFactoryData(DataModel.acitityId)
    local data = FindNowTimeInfo(activityIdCfg.recycleCityList)
    local ownList = {}
    for i, v in ipairs(data) do
      local cfg = PlayerData:GetFactoryData(v.materialList)
      for i1, v1 in ipairs(cfg.materialList) do
        if ownList[v1.id] == nil then
          table.insert(DataModel.nowManufactureList, {
            id = v1.id,
            highCoefficient = v.highCoefficient
          })
        end
        ownList[v1.id] = 1
      end
    end
  end
  return DataModel.nowManufactureList
end

DataModel.IsTimeInRange = IsTimeInRange
return DataModel
