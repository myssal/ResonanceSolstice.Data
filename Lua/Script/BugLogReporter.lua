local BugLogReporter = {
  InfoDic = {},
  ReportNames = {TrainLineEvents = 1, TrainBoxDeleteErrorCheck = 2},
  TabStr = "      "
}

function BugLogReporter:GetTime()
  return "[" .. os.date("%Y-%m-%d %H:%M:%S") .. "]  "
end

function BugLogReporter:ParseTable(t, tabCount)
  local result
  local tempLine = ""
  local _space = ""
  for c = 1, tabCount - 1 do
    _space = _space .. self.TabStr
  end
  if #t ~= 0 then
    result = "\n" .. _space .. "["
    for i, v in ipairs(t) do
      tempLine = self:ParseValue(v, tabCount)
      result = result .. "\n" .. _space .. self.TabStr .. tempLine .. (i == #t and "" or ",")
    end
    result = result .. "\n" .. _space .. "]"
  else
    result = "\n" .. _space .. "{"
    local hasAdd = false
    for k, v in pairs(t) do
      tempLine = self:ConnectKV(k, v, tabCount)
      result = result .. "\n" .. tempLine
      hasAdd = true
    end
    if hasAdd then
      result = string.sub(result, 1, #result - 1)
    end
    result = result .. "\n" .. _space .. "}"
  end
  return result
end

function BugLogReporter:ParseValue(v, tabCount)
  local result = ""
  if type(v) == "table" then
    result = self:ParseTable(v, tabCount + 1)
  elseif type(v) == "number" or type(v) == "boolean" then
    result = tostring(v)
  elseif type(v) == "string" then
    result = "\"" .. v .. "\""
  end
  return result
end

function BugLogReporter:ConnectKV(k, v, tabCount)
  if type(k) == "number" then
    k = tostring(k)
  end
  assert(type(k) == "string" and k ~= "", "key\229\191\133\233\161\187\228\184\186\233\157\158\231\169\186\231\154\132\229\173\151\231\172\166\228\184\178 keyType:" .. type(k))
  local _space = ""
  for c = 1, tabCount do
    _space = _space .. self.TabStr
  end
  return _space .. "\"" .. k .. "\": " .. self:ParseValue(v, tabCount) .. ","
end

function BugLogReporter:AddTable(rName, key, t, needTime)
  if t == nil then
    self:AddKeyValueTail(key, t, needTime)
    return
  end
  if type(t) ~= "table" then
    return
  end
  local result = self:ConnectKV(key, t, 0)
  self:AddTail(rName, result, needTime)
end

function BugLogReporter:AddKeyValueHead(rName, key, value, needTime)
  value = value == nil and "nil" or value
  if type(value) == "function" or type(value) == "table" then
    return
  end
  local result = self:ConnectKV(key, value, 0)
  self:AddHead(rName, result, needTime)
end

function BugLogReporter:AddKeyValueTail(rName, key, value, needTime)
  value = value == nil and "nil" or value
  if type(value) == "function" or type(value) == "table" then
    return
  end
  local result = self:ConnectKV(key, value, 0)
  self:AddTail(rName, result, needTime)
end

function BugLogReporter:AddHead(rName, str, needTime)
  needTime = needTime == nil and true or needTime
  if needTime then
    str = self:GetTime() .. str
  end
  local logInfo = self.InfoDic[rName] == nil and "" or self.InfoDic[rName]
  local temp = logInfo == "" and "" or "\n"
  logInfo = str .. temp .. logInfo
  self.InfoDic[rName] = logInfo
end

function BugLogReporter:AddTail(rName, str, needTime)
  needTime = needTime == nil and true or needTime
  if needTime then
    str = self:GetTime() .. str
  end
  local logInfo = self.InfoDic[rName] == nil and "" or self.InfoDic[rName]
  local temp = logInfo == "" and "" or "\n"
  logInfo = logInfo .. temp .. str
  self.InfoDic[rName] = logInfo
end

function BugLogReporter.AddTailCS(rName, str, needTime)
  BugLogReporter:AddTail(rName, str, needTime)
  BugLogReporter:Report(rName)
end

function BugLogReporter:Clear(rName)
  if rName and self.InfoDic[rName] ~= nil then
    self.InfoDic[rName] = nil
  else
    self.InfoDic = {}
  end
end

function BugLogReporter:Report(reportName)
  if reportName and self.InfoDic[reportName] ~= nil and self.InfoDic[reportName] ~= "" then
    self:AddHead(reportName, "App: " .. HotfixSetting.clientAppVersion .. [[

Res: ]] .. HotfixSetting.serverPatchVersion, false)
    Net:SendProto("main.store_client", function()
    end, self.InfoDic[reportName])
    self:Clear(reportName)
  end
end

function BugLogReporter:Print(rName)
  if rName and self.InfoDic[rName] then
    CS.UnityEngine.Debug.LogError(self.InfoDic[rName])
  else
    for k, v in pairs(self.InfoDic) do
      self:Print(k)
    end
  end
end

function BugLogReporter:Test()
  local t = {
    a = 1,
    b = 2,
    c = "3",
    d = {
      d1 = 11,
      d2 = 22,
      d3 = {
        [1] = 111,
        [2] = 222,
        [3] = 333
      },
      d4 = {
        d41 = "d41",
        d42 = {name = "name"},
        d43 = false
      }
    }
  }
  self:AddTable(self.ReportNames.TrainLineEvents, "testTable", t)
  self:AddKeyValueTail(self.ReportNames.TrainLineEvents, "testAddKeyValueTail", true)
  self:AddKeyValueTail(self.ReportNames.TrainLineEvents, "testAddKeyValueTail", 1)
  self:AddKeyValueTail(self.ReportNames.TrainLineEvents, "testAddKeyValueTail", 0.146)
  self:AddTable(self.ReportNames.TrainLineEvents, "testTable", t)
  self:AddKeyValueHead(self.ReportNames.TrainLineEvents, "testAddKeyValueHead", "test")
  self:AddKeyValueHead(self.ReportNames.TrainLineEvents, "testAddKeyValueHead", false)
  self:Print(self.ReportNames.TrainLineEvents)
end

function BugLogReporter:ReportTrainEvent()
  local rName = BugLogReporter.ReportNames.TrainLineEvents
  self:Print(rName)
  self:Report(rName)
end

function BugLogReporter.GetCurTargetCity()
  local cityID, index
  local innerTrainMa = CS.FRef.getProperty(TrainManager, "InternalTrainManager")
  if innerTrainMa then
    index = innerTrainMa.InnerPathIndex
    if innerTrainMa.PathInfos and innerTrainMa.PathInfos[innerTrainMa.InnerPathIndex] then
      cityID = innerTrainMa.PathInfos[innerTrainMa.InnerPathIndex].targetId
    end
  end
  return cityID, index
end

function BugLogReporter.GetCurEventID()
  local innerManager = CS.FRef.getProperty(TrainManager, "InternalTrainManager")
  if innerManager == nil then
    return "nil"
  end
  local curEvent = innerManager.EventCtrl.LevelCtrl.CurrEvent
  if curEvent == nil then
    return "nil"
  end
  return tostring(curEvent.id)
end

function BugLogReporter.ParaseJson(json)
  if json == nil or json.line_events == nil then
    return "nil"
  end
  local str = [[

Events: {
]]
  for k, v in pairs(json.line_events) do
    str = str .. "                   \232\189\166\231\171\153" .. k .. "#\231\186\191\232\183\175" .. v.line_id .. ": ["
    if v.events ~= nil then
      for m, n in ipairs(v.events) do
        str = str .. n.id .. (m == #v.events and "" or ", ")
      end
    end
    str = str .. "]\n"
  end
  str = str .. "}"
  return str
end

return BugLogReporter
