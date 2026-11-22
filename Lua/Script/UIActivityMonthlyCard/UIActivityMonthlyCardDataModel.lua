local DataModel = {
  rewardList = {},
  totalCount = 0,
  endTimeStamp = 0
}

function DataModel.Init()
  local ca = PlayerData:GetFactoryData(11400018)
  if ca then
    DataModel.rewardList = ca.monthList
  end
  ca = PlayerData:GetFactoryData(86000069)
  DataModel.totalCount = ca.num or 0
  DataModel.endTimeStamp = TimeUtil:TimeStamp(ca.endTime)
end

function DataModel.GetRemainCount()
  local data = PlayerData:GetActivityData(86000069)
  if data then
    return DataModel.totalCount - (data.rec_total_count or 0)
  end
  return DataModel.totalCount
end

function DataModel.GetRedState(id)
  local data = PlayerData:GetActivityData(id)
  local ca = PlayerData:GetFactoryData(id)
  if data and ca then
    local count = ca.num - (data.rec_total_count or 0)
    if 0 < count then
      if data.rec_today then
        return TimeUtil:GetServerTimeStamp() > data.rec_today
      else
        return true
      end
    else
      return false
    end
  end
  return false
end

return DataModel
