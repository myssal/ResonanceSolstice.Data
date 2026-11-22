local Time = {}

function Time:TimeStamp(timeStr)
  if timeStr == "" or timeStr == nil then
    return -1
  end
  return TimeTool.TimeStamp(timeStr) - PlayerData.TimeZone * 3600
end

function Time:IsActive(startTime, endTime)
  if startTime == "" then
    return true
  end
  if endTime == "" then
    if self:TimeStamp(startTime) <= self:GetServerTimeStamp() then
      return true
    else
      return false
    end
  end
  if self:TimeStamp(startTime) <= self:GetServerTimeStamp() and self:GetServerTimeStamp() < self:TimeStamp(endTime) then
    return true
  end
  return false
end

function Time:TimeIsActive(startTime, endTime)
  if startTime == "" then
    return true
  end
  if endTime == "" or endTime == nil then
    if os.time(TimeUtil:GetNewTimeTable(startTime)) - PlayerData.ServerTimeZoneOffset <= self:GetServerTimeStamp() then
      return true
    else
      return false
    end
  end
  if os.time(TimeUtil:GetNewTimeTable(startTime)) - PlayerData.ServerTimeZoneOffset <= self:GetServerTimeStamp() and self:GetServerTimeStamp() < os.time(TimeUtil:GetNewTimeTable(endTime)) - PlayerData.ServerTimeZoneOffset then
    return true
  end
  return false
end

function Time:GetTimeTable(timeStr)
  local t = {}
  for w in string.gmatch(timeStr, "%d+") do
    table.insert(t, w)
  end
  return {
    year = t[1],
    month = tonumber(t[2]),
    day = t[3],
    hour = t[4],
    minute = t[5],
    second = t[6]
  }
end

function Time:GetNewTimeTable(timeStr)
  local t = {}
  for w in string.gmatch(timeStr, "%d+") do
    table.insert(t, w)
  end
  return {
    year = t[1],
    month = tonumber(t[2]),
    day = t[3],
    hour = t[4],
    min = t[5],
    sec = t[6]
  }
end

function Time:LastTime(timeStr)
  return self:TimeStamp(timeStr) - self:GetServerTimeStamp()
end

function Time:SecondToTable(second)
  if second < 0 then
    return {
      day = 0,
      hour = 0,
      minute = 0,
      second = 0
    }
  end
  local day = math.floor(second / 86400)
  local lastSecond = math.floor(second % 86400)
  local hour = math.floor(lastSecond / 3600)
  lastSecond = math.floor(lastSecond % 3600)
  local minute = math.floor(lastSecond / 60)
  lastSecond = math.floor(lastSecond % 60)
  return {
    day = day,
    hour = hour,
    minute = minute,
    second = lastSecond
  }
end

function Time:SecondToTableHMS(second)
  if second < 0 then
    return {
      hour = 0,
      minute = 0,
      second = 0
    }
  end
  local hour = math.floor(second / 3600)
  second = math.floor(second % 3600)
  local minute = math.floor(second / 60)
  second = math.floor(second % 60)
  return {
    hour = hour,
    minute = minute,
    second = second
  }
end

function Time:GetCommonDesc(timeTable)
  if timeTable.day > 0 then
    return string.format(GetText(80600014), timeTable.day, timeTable.hour)
  end
  if 0 < timeTable.hour then
    return string.format(GetText(80600016), timeTable.hour, timeTable.minute)
  end
  if 0 < timeTable.minute then
    return string.format(GetText(80600016), timeTable.hour, timeTable.minute)
  end
  if 0 < timeTable.second then
    return string.format(GetText(80600017), timeTable.second)
  end
  return GetText(80600019)
end

function Time:GetGachaDesc(timeTable)
  if timeTable.day > 0 then
    return string.format(GetText(80600006), timeTable.day, timeTable.hour, timeTable.minute)
  end
  if 0 < timeTable.hour then
    return string.format(GetText(80600007), timeTable.hour, timeTable.minute)
  end
  if 0 < timeTable.minute then
    return string.format(GetText(80600008), timeTable.minute)
  end
  if 0 < timeTable.second then
    return string.format(GetText(80600009), timeTable.second)
  end
  return "0"
end

function Time:GetActivityOpenLeftTime(second)
  local timeTable = self:SecondToTable(second)
  if timeTable.day > 0 then
    return string.format(GetText(80609204), timeTable.day)
  end
  if 0 < timeTable.hour then
    return string.format(GetText(80609205), timeTable.hour)
  end
  return string.format(GetText(80609205), 1)
end

function Time:GetServerTimeStamp(changeLocalTimeZone)
  local serverTimeStamp = TimeTool.UnixTimeStamp() - PlayerData.serverTimeOffset
  if changeLocalTimeZone then
    serverTimeStamp = serverTimeStamp - (PlayerData.TimeZone - Time:GetLocalTimeZone()) * 3600
    serverTimeStamp = math.modf(serverTimeStamp)
  end
  return serverTimeStamp
end

function Time:GetLocalTimeZone()
  local now = os.time()
  local diffTime = os.difftime(now, os.time(os.date("!*t", now)))
  local timeZone, temp = math.modf(diffTime / 3600)
  if 0.9999 < temp then
    timeZone = timeZone + 1
  elseif temp < -0.9999 then
    timeZone = timeZone - 1
  end
  return timeZone
end

function Time:GetMailCommonDesc(second)
  local timeTable = Time:SecondToTable(second)
  if timeTable.day > 0 then
    return string.format(GetText(80600080), timeTable.day)
  end
  if 0 < timeTable.hour then
    return string.format(GetText(80600081), timeTable.hour)
  end
  if 0 < timeTable.minute then
    return string.format(GetText(80600082), timeTable.minute)
  end
  if 0 < timeTable.second then
    return string.format(GetText(80600083), timeTable.second)
  end
  return GetText(80600019)
end

function Time:GetFriendDesc(logintime)
  local now_time = PlayerData.ServerData.server_now
  local login_time = logintime
  local timeTable = Time:SecondToTable(now_time - login_time)
  if timeTable.day > 30 then
    return GetText(80600122), false
  end
  if timeTable.day <= 30 and timeTable.day > 1 then
    return string.format(GetText(80600121), timeTable.day), false
  end
  if 1 < timeTable.hour and timeTable.hour <= 24 then
    return GetText(80600125), false
  end
  if 1 >= timeTable.hour and timeTable.minute > 0 then
    return GetText(80600124), false
  end
  if timeTable.second == 0 and timeTable.minute == 0 then
    return GetText(80600123), true
  end
  return "", false
end

function Time:GetAntiAddicitionCommonDesc(timeTable)
  if timeTable.day > 0 then
    return string.format(GetText(80600014), timeTable.day, timeTable.hour)
  end
  if 0 < timeTable.hour then
    return string.format(GetText(80600138), timeTable.hour, timeTable.minute)
  end
  if 0 < timeTable.minute then
    return string.format(GetText(80600138), timeTable.hour, timeTable.minute)
  end
  if 0 < timeTable.second then
    return string.format(GetText(80600139), timeTable.second)
  end
  return GetText(80600019)
end

function Time:GetBattlePassTime(timeTable)
  if timeTable.day > 0 then
    return string.format(GetText(80601195), timeTable.day, timeTable.hour)
  end
  if 0 < timeTable.hour then
    return string.format(GetText(80601230), timeTable.hour, timeTable.minute)
  end
  if 0 < timeTable.minute then
    return string.format(GetText(80601231), timeTable.hour, timeTable.minute)
  end
  return GetText(80600019)
end

function Time:GetFutureTimeBySomeTimeStamp(futureDays, hour, time_input)
  local date_table
  local curTimestamp = time_input or TimeUtil.GetServerTimeStamp()
  local dayTimestamp = 86400
  local newTime = curTimestamp + dayTimestamp * futureDays
  local newDate = os.date("*t", newTime)
  date_table = os.time({
    year = newDate.year,
    month = newDate.month,
    day = newDate.day,
    hour = hour,
    minute = newDate.minute,
    second = newDate.second
  })
  if time_input and time_input < date_table then
    date_table = os.time({
      year = newDate.year,
      month = newDate.month,
      day = newDate.day - 1,
      hour = hour,
      minute = newDate.minute,
      second = newDate.second
    })
  end
  return date_table
end

function Time:GetFutureTime(futureDays, hour)
  local curTimestamp = PlayerData:GetSeverTime()
  local dayTimestamp = 86400
  local newTime = curTimestamp + dayTimestamp * futureDays
  local newDate = os.date("*t", newTime)
  return os.time({
    year = newDate.year,
    month = newDate.month,
    day = newDate.day,
    hour = hour,
    minute = newDate.minute,
    second = newDate.second
  })
end

function Time:GetFutureTimeByServerTimeStamp(futureDays, hour)
  local curTimestamp = TimeUtil.GetServerTimeStamp()
  local dayTimestamp = 86400
  local newTime = curTimestamp + dayTimestamp * futureDays
  local newDate = os.date("*t", newTime)
  return os.time({
    year = newDate.year,
    month = newDate.month,
    day = newDate.day,
    hour = hour,
    minute = newDate.minute,
    second = newDate.second
  })
end

function Time:GetFutureTimeByTimeZone(futureDays, hour)
  local curTimestamp = PlayerData:GetSeverTime()
  local dayTimestamp = 86400
  local newTime = curTimestamp + dayTimestamp * futureDays
  local newDate = os.date("*t", newTime)
  newTime = os.time({
    year = newDate.year,
    month = newDate.month,
    day = newDate.day,
    hour = hour,
    minute = newDate.minute,
    second = newDate.second
  })
  newTime = newTime - (PlayerData.TimeZone - self:GetLocalTimeZone() + (newDate.isdst and -1 or 0)) * 3600
  return newTime
end

function Time:GetStandardTime(timeTable)
  local hour = 0
  if 0 < timeTable.day then
    hour = hour + timeTable.day * 24
  end
  if 0 < timeTable.hour then
    hour = hour + timeTable.hour
  end
  return string.format("%02d:%02d:%02d", hour, timeTable.minute, timeTable.second)
end

function Time:FormatUnixTime2Date(unixTime)
  if unixTime and 0 <= unixTime then
    local tb = {}
    tb.year = tonumber(os.date("%Y", unixTime))
    tb.month = tonumber(os.date("%m", unixTime))
    tb.day = tonumber(os.date("%d", unixTime))
    tb.hour = tonumber(os.date("%H", unixTime))
    tb.minute = tonumber(os.date("%M", unixTime))
    tb.second = tonumber(os.date("%S", unixTime))
    return tb
  end
end

function Time:GetNextSpecialTimeStamp(h, m, s, compareTime)
  local nextTime = 0
  if h ~= nil then
    nextTime = nextTime + h * 3600
  end
  if m ~= nil then
    nextTime = nextTime + m * 60
  end
  if s ~= nil then
    nextTime = nextTime + s
  end
  local curTime = compareTime or Time:GetServerTimeStamp()
  local timeZoneTime = PlayerData.TimeZone * 3600
  local dayTimeStamp = 86400
  local days = math.modf((curTime + timeZoneTime) / dayTimeStamp)
  local targetTimeStamp = days * dayTimeStamp + nextTime - timeZoneTime
  if curTime >= targetTimeStamp then
    targetTimeStamp = targetTimeStamp + dayTimeStamp
  end
  if curTime >= targetTimeStamp then
    targetTimeStamp = targetTimeStamp + dayTimeStamp
  end
  return targetTimeStamp
end

function Time:GetNextWeekTime(wDay, h, compareTime)
  if 7 < wDay then
    wDay = 1
  end
  if compareTime == nil then
    compareTime = TimeUtil:GetServerTimeStamp()
  end
  if h == nil then
    h = 0
  end
  local date = os.date("!*t", compareTime)
  date.hour = date.hour + PlayerData.TimeZone
  if date.hour >= 24 then
    date.hour = date.hour - 24
    date.wday = date.wday + 1
  end
  if date.wday == 8 then
    date.wday = 1
  end
  local wDayToLuaWDay = {
    [1] = 2,
    [2] = 3,
    [3] = 4,
    [4] = 5,
    [5] = 6,
    [6] = 7,
    [7] = 1
  }
  local remainDay = 0
  local targetwday = wDayToLuaWDay[wDay]
  if targetwday == date.wday then
    if h > date.hour then
      remainDay = 0
    else
      remainDay = 7
    end
  else
    remainDay = targetwday - date.wday
    if remainDay < 0 then
      remainDay = remainDay + 7
    end
  end
  local dayTime = remainDay * 86400
  local hourTime = (h - date.hour) * 3600
  local minTime = 0 - date.min * 60
  local secTime = 0 - date.sec
  local newTime = compareTime + dayTime + hourTime + minTime + secTime
  return newTime
end

function Time:GetNextMonthTime(day, h, m, s, compareTime)
  if compareTime == nil then
    compareTime = TimeUtil:GetServerTimeStamp()
  end
  if h == nil then
    h = 0
  end
  if m == nil then
    m = 0
  end
  if s == nil then
    s = 0
  end
  local localDate = os.date("*t", compareTime)
  local newDate = os.date("!*t", compareTime)
  if newDate.hour + PlayerData.TimeZone >= 24 then
    if newDate.day == 31 then
      newDate.month = newDate.month + 1
      if newDate.month == 13 then
        newDate.year = newDate.year + 1
        newDate.month = 1
      end
    elseif newDate.day == 30 and (newDate.month == 4 or newDate.month == 6 or newDate.month == 9 or newDate.month == 11) then
      newDate.month = newDate.month + 1
    elseif (newDate.day == 29 or newDate.day == 28) and newDate.month == 2 then
      if newDate.year % 400 == 0 or newDate.year % 4 == 0 and newDate.year % 100 ~= 0 then
        if newDate.day == 29 then
          newDate.month = newDate.month + 1
        end
      elseif newDate.day == 28 then
        newDate.month = newDate.month + 1
      end
    end
    if h <= newDate.hour + PlayerData.TimeZone - 24 then
      newDate.month = newDate.month + 1
    end
  else
    newDate.month = newDate.month + 1
    if newDate.month == 13 then
      newDate.year = newDate.year + 1
      newDate.month = 1
    end
  end
  local newTime = os.time({
    year = newDate.year,
    month = newDate.month,
    day = day,
    hour = h,
    min = m,
    sec = s,
    isdst = localDate.isdst
  })
  newTime = newTime - (PlayerData.TimeZone - self:GetLocalTimeZone() + (localDate.isdst and -1 or 0)) * 3600
  return newTime
end

function Time:CheckWDay(wDay, h, compareTime)
  if 7 < wDay then
    wDay = 1
  end
  if compareTime == nil then
    compareTime = TimeUtil:GetServerTimeStamp()
  end
  if h == nil then
    h = 0
  end
  local date = os.date("!*t", compareTime)
  date.hour = date.hour + PlayerData.TimeZone
  if date.hour >= 24 then
    date.hour = date.hour - 24
    date.wday = date.wday + 1
  end
  if date.wday == 8 then
    date.wday = 1
  end
  local wDayToLuaWDay = {
    [1] = 2,
    [2] = 3,
    [3] = 4,
    [4] = 5,
    [5] = 6,
    [6] = 7,
    [7] = 1
  }
  local targetwday = wDayToLuaWDay[wDay]
  local nextDay = targetwday + 1
  if nextDay == 8 then
    nextDay = 1
  end
  if date.wday == targetwday and h <= date.hour then
    return true
  elseif date.wday == nextDay and h > date.hour then
    return true
  end
  return false
end

function Time:GetTimeStampTotalDays(timeStamp)
  local day = math.modf((timeStamp + PlayerData.TimeZone * 3600) / 86400)
  return day
end

function Time:GetDailyRefreshTimeHour()
  local defaultConfig = PlayerData:GetFactoryData(99900001, "ConfigFactory")
  local h = tonumber(string.sub(defaultConfig.dailyRefreshTime, 1, 2)) or 0
  local m = tonumber(string.sub(defaultConfig.dailyRefreshTime, 4, 5)) or 0
  local s = tonumber(string.sub(defaultConfig.dailyRefreshTime, 7, 8)) or 0
  return {
    hour = h,
    minute = m,
    second = s
  }
end

function Time:GetMonthCardRemainTime()
  if PlayerData.ServerData.monthly_card and PlayerData.ServerData.monthly_card["11400018"] then
    local t = PlayerData.ServerData.monthly_card["11400018"]
    local diff = 0
    local isYesterday = TimeUtil:IsLogicYesterday()
    local timeStamp = TimeUtil:GetFutureTimeStampByUTC(isYesterday and -1 or 0, 5)
    diff = t.deadline - timeStamp
    return diff
  end
  return -1
end

function Time:GetServerTimeStampByUTC()
  local UTCTimeStamp = TimeTool.UnixTimeStamp() - PlayerData.serverTimeOffset
  local serverTimeStamp = UTCTimeStamp + PlayerData.TimeZone * 3600
  return serverTimeStamp
end

function Time:UnixTime2TimeTable(unixTime)
  if unixTime and 0 <= unixTime then
    local tb = {}
    tb.year = tonumber(os.date("!%Y", unixTime))
    tb.month = tonumber(os.date("!%m", unixTime))
    tb.day = tonumber(os.date("!%d", unixTime))
    tb.hour = tonumber(os.date("!%H", unixTime))
    tb.minute = tonumber(os.date("!%M", unixTime))
    tb.second = tonumber(os.date("!%S", unixTime))
    return tb
  end
end

function Time:GetFutureTimeStampByUTC(futureDays, hour, min, sec)
  local curTimestamp = Time:GetServerTimeStampByUTC()
  local dayTimestamp = 86400
  local newTime = curTimestamp + dayTimestamp * futureDays
  local newDate = os.date("!*t", newTime)
  return os.time({
    year = newDate.year,
    month = newDate.month,
    day = newDate.day,
    hour = hour and hour or newDate.hour,
    min = min and min or newDate.min,
    sec = sec and sec or newDate.sec
  }) + TimeUtil:GetLocalTimeZone() * 3600
end

function Time:IsLogicYesterday()
  local refreshHour = 5
  local serverTimeStamp = Time:GetServerTimeStampByUTC()
  local timeTable = Time:UnixTime2TimeTable(serverTimeStamp)
  return refreshHour > timeTable.hour
end

function Time:GetLogicServerDayTable()
  local isLogicYesterday = Time:IsLogicYesterday()
  local logicTimeStamp = Time:GetFutureTimeStampByUTC(isLogicYesterday and -1 or 0)
  return Time:UnixTime2TimeTable(logicTimeStamp)
end

function Time:GetServerDayTableWith5AM()
  local ts = Time:GetSvrTsAddTzOffest()
  local date = os.date("!*t", ts)
  local isToday = date.hour >= 5
  if not isToday then
    ts = ts - 86400
  end
  return Time:UnixTime2TimeTable(ts)
end

function Time:GetServerTimeTable()
  local serverTimeStamp = Time:GetServerTimeStampByUTC()
  local timeTable = Time:UnixTime2TimeTable(serverTimeStamp)
  return timeTable
end

function Time:SecondsToTimeFormat(seconds)
  local minutes = math.floor(seconds / 60)
  local remainingSeconds = math.floor(seconds % 60)
  return string.format("%02d:%02d", minutes, remainingSeconds)
end

function Time:GetSvrTimeZone()
  return PlayerData.TimeZone
end

function Time:GetSvrTsAddTzOffest()
  return Time:GetServerTimeStamp() + Time:GetSvrTimeZone() * 3600
end

function Time:GetSvrTimeFormatStr1()
  return os.date("!%Y-%m-%d %H:%M:%S", Time:GetSvrTsAddTzOffest())
end

function Time:GetSvrTimeFormatStr2()
  return os.date("!%H:%M:%S", Time:GetSvrTsAddTzOffest())
end

function Time:GetSvrTimeFormatStr3()
  return os.date("!%H:%M:%S", Time:GetSvrTsAddTzOffest()) .. " UTC+" .. Time:GetSvrTimeZone()
end

function Time:GetSvrTimeFormatStr4()
  return os.date("!%H:%M", Time:GetSvrTsAddTzOffest())
end

function Time:TodayIsHoliday()
  local curTime = self:GetServerTimeStamp()
  local holidayList = PlayerData:GetFactoryData(99900013).holidayList
  for k, v in pairs(holidayList) do
    local timeStamp = self:TimeStamp(v.day .. " 05:00:00")
    if 0 < curTime - timeStamp and curTime - timeStamp <= 86400 then
      return true
    end
  end
  return false
end

return Time
