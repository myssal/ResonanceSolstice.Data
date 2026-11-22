local MapDataModel = require("UIHome/UIHomeMapDataModel")
local MainDataModel = require("UIMainUI/UIMainUIDataModel")
local HomeView = require("UIMainUI/UIMainUIView")
local DataModel = {
  CurStayCity = 0,
  StartCity = 0,
  EndCity = 0,
  InTravel = false,
  DelayPer = 0,
  Speed = 100,
  NextCityPath = {},
  GoOtherCity = false,
  DistanceToLastStation = 0,
  TravelTotalDistance = 0,
  CurRemainDistance = 0,
  StartEndTotalDistance = 0,
  StartTime = 0,
  StockInfo = {},
  MaxSpace = 0,
  CurUseSpace = 0,
  GarbageId = {82900012},
  DriveState = "Drive",
  Path = {},
  EndTime = 0,
  StateEnter = EnumDefine.TrainStateEnter.None,
  CurrDriveDistance = 0,
  DisplayTrainState = DisplayTrainState.None,
  lastStopDistance = -1
}

local function applyDisplayTrainState()
  local ctrl = TrainManager.DisplayTrainCtrl
  if ctrl.PlayerData == nil or ctrl.FirstTrain == nil then
    DataModel.DisplayTrainState = DisplayTrainState.None
  end
  TrainManager:ChangeDisplayState(DataModel.DisplayTrainState)
end

function DataModel.InitModel()
  DataModel.CurStayCity = 0
  DataModel.StartCity = 0
  DataModel.EndCity = 0
  DataModel.InTravel = false
  DataModel.DelayPer = 0
  DataModel.Speed = 100
  DataModel.NextCityPath = {}
  DataModel.GoOtherCity = false
  DataModel.DistanceToLastStation = 0
  DataModel.TravelTotalDistance = 0
  DataModel.CurRemainDistance = 0
  DataModel.StartEndTotalDistance = 0
  DataModel.StartTime = 0
  DataModel.StockInfo = {}
  DataModel.MaxSpace = 0
  DataModel.CurUseSpace = 0
  DataModel.GarbageId = {82900012}
  DataModel.DriveState = "Drive"
  DataModel.GoOtherCity = false
  DataModel.Speed = nil
  DataModel.DriveLine = {}
  DataModel.Path = {}
  DataModel.EndTime = 0
  DataModel.StateEnter = EnumDefine.TrainStateEnter.None
  DataModel.CurrDriveDistance = 0
  DataModel.DisplayTrainState = DisplayTrainState.None
end

function DataModel.GetDriveLine(station_info)
  local driveLine = {}
  for i, v in pairs(station_info.arrive_status) do
    table.insert(driveLine, {
      id = tonumber(i),
      time = tonumber(v.time)
    })
  end
  table.sort(driveLine, function(a, b)
    if a.time > b.time then
      return true
    end
    return false
  end)
  DataModel.DriveLine = driveLine
  DataModel.NextCityPath = {}
  for i = #DataModel.DriveLine, 1, -1 do
    table.insert(DataModel.NextCityPath, DataModel.DriveLine[i].id)
  end
  return driveLine
end

function DataModel.GetInTravel()
  return PlayerData:GetHomeInfo().station_info.is_arrived ~= 2
end

function DataModel.GetCurrTravelDis()
  if DataModel.GetInTravel() then
    if PlayerData:GetHomeInfo().station_info.status ~= -1 and PlayerData:GetHomeInfo().station_info.status ~= -2 then
      DataModel.CurrDriveDistance = DataModel.TravelTotalDistance - TrainManager.RemainDistance + PlayerData:GetHomeInfo().drive_distance
      return DataModel.TravelTotalDistance - TrainManager.RemainDistance + PlayerData:GetHomeInfo().drive_distance
    end
    local currDriveDistance = DataModel.TravelTotalDistance - TrainManager.RemainDistance + PlayerData:GetHomeInfo().drive_distance
    if currDriveDistance < DataModel.CurrDriveDistance then
      return DataModel.CurrDriveDistance
    else
      return currDriveDistance
    end
  else
    return PlayerData:GetHomeInfo().drive_distance
  end
end

function DataModel.RefreshDisplayTrainInfo(stateEnter)
  if stateEnter == EnumDefine.TrainStateEnter.DriveNew then
    DataModel.DisplayTrainState = DisplayTrainState.None
    local stations = PlayerData:GetHomeInfo().stations
    local stationCfg = PlayerData:GetFactoryData(DataModel.StartCity)
    local drive_num = stations[tostring(DataModel.StartCity)].drive_num
    if drive_num > #stationCfg.trainList then
      local display_train = PlayerData:GetHomeInfo().display_train
      local allData = {}
      for i, v in ipairs(display_train) do
        local skins = {}
        for _, b in ipairs(v.coach_info) do
          if b.skin ~= nil and b.skin ~= "" then
            table.insert(skins, tonumber(b.skin))
          end
        end
        if 0 < #skins then
          local last = PlayerData:GetFactoryData(skins[#skins])
          local defaultCfg = PlayerData:GetFactoryData(99900044)
          for m, n in pairs(defaultCfg.skinList) do
            if last.skinTag == n.tag then
              skins[#skins] = n.trainTail
              break
            end
          end
        end
        table.insert(allData, {
          isSameDirection = true,
          skinIds = skins,
          triggerPos = 0,
          bornPos = 0,
          title = v.role_name,
          bornPathIndex = 0,
          targetSpeed = v.speed,
          speedAdd = 2,
          speedDec = 5
        })
      end
      local json = Json.encode({
        isPlayer = true,
        triggerPos = 0,
        isSameDirection = true
      })
      PlayerData:SetPlayerPrefs("string", "displayTrain", json)
      if 0 < #allData then
        if TrainManager.DisplayTrainCtrl.CarLength == 0 then
          TrainManager.DisplayTrainCtrl.CarLength = -1
        end
        local internal = CS.FRef.getProperty(TrainManager, "InternalTrainManager")
        if internal.DisplayTrainCtrl.Owner.InnerTrainCtrl.FirstTrain.PathIndex < internal.DisplayTrainCtrl.Owner.PathInfos.Count then
          print_r("pathIndex:" .. internal.DisplayTrainCtrl.Owner.InnerTrainCtrl.FirstTrain.PathIndex .. ",PathInfo.Count:" .. internal.DisplayTrainCtrl.Owner.PathInfos.Count)
          TrainManager:NextPlayerDisplayTrainEnv(allData, 1)
          DataModel.DisplayTrainState = DisplayTrainState.AddSpeed
        else
          print_r("\229\177\149\231\164\186\229\136\151\232\189\166\230\149\176\231\187\132\232\182\138\231\149\140\230\149\176\231\187\132\232\182\138\231\149\140,pathIndex:" .. internal.DisplayTrainCtrl.Owner.InnerTrainCtrl.FirstTrain.PathIndex .. ",PathInfo.Count:" .. internal.DisplayTrainCtrl.Owner.PathInfos.Count)
          DataModel.DisplayTrainState = DisplayTrainState.None
        end
      else
        DataModel.DisplayTrainState = DisplayTrainState.None
      end
    else
      local curr = stationCfg.trainList[drive_num]
      local triggerPos
      local bornPos, bornPathIndex = 0, 0
      if curr.type == 0 then
        triggerPos = DataModel.TravelTotalDistance - curr.trainDistance
      elseif curr.type == 1 then
        triggerPos = curr.trainDistance
      end
      local posStart = curr.posStart
      local startPos
      if curr.type == 0 then
        startPos = DataModel.TravelTotalDistance - posStart
        for i, v in ipairs(DataModel.Path) do
          if posStart > v.length then
            posStart = posStart - v.length
          elseif bornPathIndex == 0 then
            bornPathIndex = i - 1
            bornPos = v.length - posStart
          end
        end
      elseif curr.type == 1 then
        startPos = posStart
        for i = #DataModel.Path, 1, -1 do
          local v = DataModel.Path[i]
          if posStart > v.length then
            posStart = posStart - v.length
          elseif bornPathIndex == 0 then
            bornPathIndex = i - 1
            bornPos = posStart
          end
        end
      end
      if curr.type == 0 or curr.type == 1 then
        local isSameDirection
        if curr.endType == 0 then
          isSameDirection = true
        elseif curr.endType == 1 then
          isSameDirection = false
        end
        local currTrain = PlayerData:GetFactoryData(curr.trainId, "ListFactory")
        local trains = currTrain.trainLook
        local trainSkins = {}
        for _, v in ipairs(trains) do
          table.insert(trainSkins, v.id)
        end
        if 0 < #trainSkins then
          local last = PlayerData:GetFactoryData(trainSkins[#trainSkins])
          local defaultCfg = PlayerData:GetFactoryData(99900044)
          for m, n in pairs(defaultCfg.skinList) do
            if last.skinTag == n.tag then
              trainSkins[#trainSkins] = n.trainTail
              break
            end
          end
        end
        local text = currTrain.trainName
        local cacheData = {}
        local targetSpeed = math.random(curr.speedMin, curr.speedMax)
        cacheData.targetSpeed = targetSpeed
        cacheData.trainSkins = trainSkins
        cacheData.isSameDirection = isSameDirection
        cacheData.speedAdd = curr.speedAdd
        cacheData.speedDec = curr.speedDec
        cacheData.triggerPos = triggerPos
        cacheData.bornPathIndex = bornPathIndex
        cacheData.bornPos = bornPos
        cacheData.isPlayer = false
        cacheData.text = GetText(text)
        local json = Json.encode(cacheData)
        PlayerData:SetPlayerPrefs("string", "displayTrain", json)
        DataModel.DisplayTrainState = DisplayTrainState.Waiting
        TrainManager:InitBasicDisplayTrainEnv({
          {
            isSameDirection = cacheData.isSameDirection,
            skinIds = cacheData.trainSkins,
            triggerPos = cacheData.triggerPos,
            bornPos = cacheData.bornPos,
            title = cacheData.text,
            speedAdd = cacheData.speedAdd,
            speedDec = cacheData.speedDec,
            bornPathIndex = cacheData.bornPathIndex,
            targetSpeed = cacheData.targetSpeed
          }
        })
      elseif stateEnter == EnumDefine.TrainStateEnter.FirstLogin then
        local json = PlayerData:GetPlayerPrefs("string", "displayTrain")
        if json == 0 or json == "" or json == nil then
          DataModel.DisplayTrainState = DisplayTrainState.None
          return
        end
        local cacheData = Json.decode(json)
        local stations = PlayerData:GetHomeInfo().stations
        local stationCfg = PlayerData:GetFactoryData(DataModel.StartCity)
        local drive_num = stations[tostring(DataModel.StartCity)].drive_num
        if cacheData.trainSkins and 0 < #cacheData.trainSkins then
          local last = PlayerData:GetFactoryData(cacheData.trainSkins[#cacheData.trainSkins])
          local defaultCfg = PlayerData:GetFactoryData(99900044)
          for m, n in pairs(defaultCfg.skinList) do
            if last.skinTag == n.tag then
              cacheData.trainSkins[#cacheData.trainSkins] = n.trainTail
              break
            end
          end
        end
        if cacheData.isPlayer or drive_num > #stationCfg.trainList then
          local display_train = PlayerData:GetHomeInfo().display_train
          local allData = {}
        elseif TrainManager.RemainDistance < cacheData.triggerPos then
          DataModel.DisplayTrainState = DisplayTrainState.Waiting
          TrainManager:InitBasicDisplayTrainEnv({
            {
              isSameDirection = cacheData.isSameDirection,
              skinIds = cacheData.trainSkins or {},
              triggerPos = cacheData.triggerPos or 0,
              bornPos = cacheData.bornPos or 0,
              title = cacheData.text or "test",
              speedAdd = cacheData.speedAdd or 1,
              speedDec = cacheData.speedDec or 1,
              bornPathIndex = cacheData.bornPathIndex or cacheData.bornIndex or 0,
              targetSpeed = cacheData.targetSpeed or 50
            }
          })
        else
          DataModel.DisplayTrainState = DisplayTrainState.None
        end
      end
      local json = PlayerData:GetPlayerPrefs("string", "displayTrain")
      print_r("\229\189\147\229\137\141\229\177\149\231\164\186\229\136\151\232\189\166\231\154\132\229\133\183\228\189\147\230\149\176\230\141\174" .. json)
      if TrainManager.IsInTrainMap and (stateEnter == EnumDefine.TrainStateEnter.FirstLogin or stateEnter == EnumDefine.TrainStateEnter.DriveNew) then
        applyDisplayTrainState()
        TrainManager:InitDisplayTrainSkin()
      end
    end
  end
end

function DataModel.IsReturn()
  local station_info = PlayerData:GetHomeInfo().station_info
  if station_info.is_arrived == 1 and station_info.is_return == 1 then
    return true
  else
    return false
  end
end

function DataModel.RefreshRushStatus()
  if DataModel.GetInTravel() == false then
    return
  end
  if DataModel.TrainState ~= TrainState.Rush then
    return
  end
  local UIMainUIDataModelTemp = require("UIMainUI/UIMainUIDataModel")
  local remainTime = UIMainUIDataModelTemp.RushServerTime - TimeUtil:GetServerTimeStamp()
  if remainTime < 0 then
    remainTime = 0
  end
  local internal = CS.FRef.getProperty(TrainManager, "InternalTrainManager")
  local curFsm = CS.FRef.getProperty(internal.InnerTrainCtrl.StateCtrl, "CurrFsm")
  local rushFsm = CS.FRef.getProperty(curFsm, "_currState")
  local passTime = CS.FRef.getProperty(rushFsm, "_passTime")
  if passTime == nil then
    return
  end
  CS.FRef.setProperty(rushFsm, "_passTime", remainTime)
end

local tempBugLog = {}

function DataModel.Refresh3DTravelInfoNew(stateEnter, isAstern)
  local station_info = PlayerData:GetHomeInfo().station_info
  local curTime = TimeUtil:GetServerTimeStamp()
  local acc_speed = PlayerData:GetHomeInfo().readiness.fuel.acc_speed
  TrainManager:SetRushSpeed(acc_speed)
  DataModel.DistanceToLastStation = tonumber(station_info.distance or 0)
  DataModel.GetServerSpeed(station_info)
  DataModel.GetDriveLine(station_info)
  local startLine = DataModel.DriveLine[#DataModel.DriveLine]
  local endLine = DataModel.DriveLine[1]
  DataModel.StartTime = startLine.time
  DataModel.CurStayCity = startLine.id
  DataModel.StartCity = startLine.id
  DataModel.EndCity = endLine.id
  DataModel.EndTime = endLine.time
  local currSpeed, targetSpeed = DataModel.GetClientSpeed(stateEnter)
  local remainDis, index, currEvent = DataModel.GetPath(stateEnter)
  local trainState
  if station_info.status == -2 or station_info.status == -3 then
    if DataModel.IsReturn() then
      trainState = TrainState.Back
      currSpeed = 0
      targetSpeed = 0
      index = 0
      remainDis = DataModel.Path[1].length
      currEvent = nil
      DataModel.EndCity = DataModel.CurStayCity
    elseif curTime >= DataModel.EndTime then
      if currEvent then
        remainDis = currEvent.distance
        currSpeed = 0
        trainState = TrainState.Event
      else
        remainDis = 0
        trainState = TrainState.Arrive
      end
    elseif currEvent then
      remainDis = currEvent.distance
      currSpeed = 0
      trainState = TrainState.Event
    elseif currSpeed == targetSpeed then
      trainState = TrainState.Running
      local UIMainUIDataModelTemp = require("UIMainUI/UIMainUIDataModel")
      if UIMainUIDataModelTemp.RushServerTime then
        local remainTime = UIMainUIDataModelTemp.RushServerTime - TimeUtil:GetServerTimeStamp()
        trainState = 0 < remainTime and TrainState.Rush or TrainState.Running
      end
    elseif targetSpeed < currSpeed then
      trainState = TrainState.ReduceSpeed
    elseif targetSpeed > currSpeed then
      trainState = TrainState.AddSpeed
    end
  elseif station_info.status == -1 then
    DataModel.CurStayCity = tonumber(station_info.stop_info[1])
    DataModel.EndCity = DataModel.CurStayCity
    trainState = TrainState.None
    currSpeed = 0
    targetSpeed = 0
  elseif isAstern then
    currSpeed = 0
    trainState = TrainState.Astern
  elseif currEvent then
    currSpeed = 0
    remainDis = currEvent.distance
    trainState = TrainState.Event
  elseif station_info.status == -3 then
    trainState = TrainState.Arrive
    remainDis = 0
  else
    trainState = TrainState.Stop
    currSpeed = 0
    targetSpeed = 0
  end
  DataModel.DelayPer = 30
  TrainManager:MaskAllEvent(false)
  if trainState == TrainState.None then
    return
  elseif trainState == TrainState.Arrive then
    TrainManager:MaskAllEvent(true)
  end
  DataModel.StateEnter = stateEnter
  DataModel.TrainState = trainState
  DataModel.Index = index
  DataModel.RemainDis = remainDis
  DataModel.CurrSpeed = currSpeed
  DataModel.TargetSpeed = targetSpeed
  if stateEnter == EnumDefine.TrainStateEnter.ApplicationQuit and trainState == TrainState.Astern then
    return
  end
  local UIMainUIDataModel = require("UIMainUI/UIMainUIDataModel")
  if stateEnter ~= EnumDefine.TrainStateEnter.Refresh then
    local strike = PlayerData.CurTrainSkinIsSpecial() and {} or PlayerData.GetStrike()
    TrainManager:InitBasicEnv(UIMainUIDataModel.roomSkinIds, strike, DataModel.Path, index, remainDis)
    if not HasAddGloableTrainUpdate then
      HasAddGloableTrainUpdate = true
      local TimerHelper = require("Common/Timer/TimerHelper")
      local mainUICtrl = require("UIMainUI/UIMainUIController")
      TimerHelper.Start("TrainGloableUpdate", 0.02, mainUICtrl.GloableUpdate)
      TimerHelper.Start("TrainWheelUpdate", 0.02, Train.TrainWheelUpdate)
    end
    local bugLog = {}
    for _k, _v in ipairs(DataModel.Path) do
      local key = tostring(_v.targetId) .. "_" .. _k
      bugLog[key] = {}
      if _v and _v.events then
        for _m, _n in ipairs(_v.events) do
          table.insert(bugLog[key], _n.id)
        end
      end
    end
    local needReport = false
    for _k, _v in pairs(bugLog) do
      if tempBugLog[_k] == nil or #tempBugLog[_k] ~= #_v then
        needReport = true
        break
      end
    end
    BugLogReporter:AddTail(BugLogReporter.ReportNames.TrainLineEvents, "\229\136\183\230\150\176C# PathIndex:" .. index)
    if needReport then
      BugLogReporter:AddTable(BugLogReporter.ReportNames.TrainLineEvents, "\228\186\139\228\187\182\229\136\151\232\161\168 events:", bugLog)
      tempBugLog = bugLog
    end
  end
  if DataModel.StateEnter == EnumDefine.TrainStateEnter.FirstLogin then
    if DataModel.TrainState == TrainState.Stop or DataModel.TrainState == TrainState.Arrive then
      TrainManager:SetData({IsNotPlayMusic = true})
    end
    PlayerData:SetAutoTrailerIds()
  end
  if TrainManager.IsInTrainMap then
    TrainManager:ChangeBasicState(trainState, index, remainDis, currSpeed, targetSpeed)
    local FirstTrain = CS.FRef.getProperty(TrainManager.TrainCtrl, "FirstTrain")
    local Trains = CS.FRef.getProperty(TrainManager.TrainCtrl, "Trains")
    local CoachSkinFactory = CBus:GetFactory(CS.FactoryName.HomeCoachSkinFactory, false, true)
    local offset = 0
    local index = 0
    local TrainPosition = {}
    local isForward = FirstTrain.Direction.value__ == 0
    for i, v in pairs(Trains) do
      local pos = 0
      if isForward == true then
        pos = FirstTrain.Spline.Length - DataModel.RemainDis
      else
        pos = DataModel.RemainDis
      end
      local ca = CoachSkinFactory:GetCA(v.SkinId)
      if index ~= 0 then
        if isForward then
          offset = offset - (ca.skinSize / 2 + ca.rightPointX) * 3.5
        else
          offset = offset + (ca.skinSize / 2 + ca.rightPointX) * 3.5
        end
        pos = pos + offset
      end
      table.insert(TrainPosition, pos)
      if isForward then
        offset = offset - (ca.skinSize / 2 + ca.leftPointX) * 3.5
      else
        offset = offset + (ca.skinSize / 2 + ca.leftPointX) * 3.5
      end
      index = index + 1
    end
    local lastPos = TrainPosition[#TrainPosition]
    if lastPos ~= nil then
      if isForward == false then
        if 0 > FirstTrain.Spline.Length - lastPos then
          local sub = lastPos - FirstTrain.Spline.Length + 1
          for i, v in pairs(TrainPosition) do
            TrainPosition[i] = v - sub
          end
        end
      elseif lastPos < 0 then
        local sub = 0 - lastPos + 1
        for i, v in pairs(TrainPosition) do
          TrainPosition[i] = v + sub
        end
      end
    end
    index = 1
    for i, v in pairs(Trains) do
      if isForward == true then
        v:SetPosition(FirstTrain.Spline.Length - TrainPosition[index])
      else
        v:SetPosition(TrainPosition[index])
      end
      index = index + 1
    end
  end
  local serverTime = TimeUtil:GetServerTimeStamp()
  local todayZeroStamp = TimeUtil:GetFutureTime(0, 0)
  local deltaTime = serverTime - todayZeroStamp
  local dayScaleCA = PlayerData:GetFactoryData(99900014, "ConfigFactory")
  local dayScale = dayScaleCA.dayScale
  TrainManager:SetTrainMapDayTime(deltaTime / 3600, dayScale * 60 * 60)
  DataModel.CalcTravelTotalDistance()
  DataModel.RefreshDisplayTrainInfo(stateEnter)
end

function DataModel.GetClientSpeed(stateEnter)
  local currSpeed, targetSpeed
  if stateEnter == EnumDefine.TrainStateEnter.DriveNew or stateEnter == EnumDefine.TrainStateEnter.BattleFinish then
    currSpeed = 0
    targetSpeed = DataModel.Speed
  else
    local curTime = TimeUtil:GetServerTimeStamp()
    local cfg = PlayerData:GetFactoryData(99900037, "ConfigFactory")
    local speedAdd = cfg.speedAdd
    local speedReduce = cfg.speedReduce
    local needAddTime = DataModel.Speed / speedAdd
    if needAddTime <= curTime - DataModel.StartTime then
      currSpeed = DataModel.Speed
    else
      currSpeed = speedAdd * (curTime - DataModel.StartTime)
    end
    targetSpeed = DataModel.Speed
    local needReduceTime = DataModel.Speed / speedReduce
    local diffTime = DataModel.EndTime - curTime
    if needReduceTime > diffTime and 0 <= diffTime then
      currSpeed = DataModel.Speed - (needReduceTime - diffTime) * speedReduce
      targetSpeed = 0
    elseif diffTime <= 0 then
      currSpeed = 0
      targetSpeed = 0
    else
      currSpeed = DataModel.Speed
      targetSpeed = DataModel.Speed
    end
  end
  return currSpeed, targetSpeed
end

function DataModel.GetServerSpeed()
  local station_info = PlayerData:GetHomeInfo().station_info
  local curTime = TimeUtil:GetServerTimeStamp()
  local speed
  if station_info.speed_status and table.count(station_info.speed_status) ~= 0 then
    local currIndex
    table.sort(station_info.speed_status, function(a, b)
      if a[1] < b[1] then
        return true
      end
      return false
    end)
    for i = 1, #station_info.speed_status - 1 do
      if curTime >= station_info.speed_status[i][1] and curTime < station_info.speed_status[i + 1][1] then
        currIndex = i
        break
      end
    end
    if currIndex == nil then
      currIndex = #station_info.speed_status
    end
    speed = station_info.speed_status[currIndex][2]
  else
    speed = PlayerData:GetHomeInfo().speed
  end
  DataModel.Speed = speed
  return speed
end

function DataModel.GetStartDriveTime()
  local station_info = PlayerData:GetHomeInfo().station_info
  if station_info.speed_status == nil or station_info.speed_status[1] == nil or station_info.speed_status[1][1] == nil then
    return 0
  end
  return station_info.speed_status[1][1]
end

function DataModel.GetRemainDistance()
  local curTime = TimeUtil:GetServerTimeStamp()
  local remainDis = DataModel.GetRemainDistanceStop(curTime) or -1
  if 0 <= remainDis then
    return remainDis
  else
    remainDis = DataModel.GetRemainDistanceRun(curTime)
    return remainDis
  end
end

function DataModel.GetRemainDistanceStop(time)
  if (time or 0) >= DataModel.EndTime then
    return 0
  end
  local total = 0
  for i = #DataModel.Path, 1, -1 do
    total = total + DataModel.Path[i].length
  end
  local station_info = PlayerData:GetHomeInfo().station_info
  if station_info.stop_info == nil or station_info.stop_info[2] == nil or station_info.stop_info[1] == nil or station_info.stop_info[1] == "" then
    return -1
  end
  local curStation = tonumber(station_info.stop_info[1])
  local remains = 0
  for i = 1, #DataModel.Path do
    if DataModel.Path[i].targetId ~= curStation then
      remains = remains + DataModel.Path[i].length
    else
      remains = remains + (DataModel.Path[i].length - station_info.stop_info[2])
    end
  end
  remains = total - remains
  return remains
end

function DataModel.GetRemainDistanceRun(time)
  do return DataModel.GetRemainDistanceByEndtime(time) end
  return DataModel.GetRemainDistanceBySpeed(time)
end

function DataModel.GetRemainDistanceBySpeed(time)
  if time >= DataModel.EndTime then
    return 0
  end
  local station_info = PlayerData:GetHomeInfo().station_info
  local speedRatio = DataModel.SpeedRatio or PlayerData:GetFactoryData(99900014, "ConfigFactory").speedRatio
  local distance = 0
  local total = 0
  for i = #DataModel.Path, 1, -1 do
    total = total + DataModel.Path[i].length
  end
  if station_info.passed ~= nil then
    total = total - station_info.passed
  end
  local spCnt = #station_info.speed_status
  if spCnt == 0 then
    return total
  end
  if time <= station_info.speed_status[1][1] then
    return total
  end
  local currIndex
  if station_info.speed_status and table.count(station_info.speed_status) ~= 0 then
    table.sort(station_info.speed_status, function(a, b)
      if a[1] < b[1] then
        return true
      end
      return false
    end)
    for i = 1, #station_info.speed_status - 1 do
      if time > station_info.speed_status[i][1] and time >= station_info.speed_status[i + 1][1] then
        distance = distance + station_info.speed_status[i][2] * (station_info.speed_status[i + 1][1] - station_info.speed_status[i][1]) / speedRatio
      elseif time >= station_info.speed_status[i][1] and time <= station_info.speed_status[i + 1][1] then
        distance = distance + station_info.speed_status[i][2] * (time - station_info.speed_status[i][1]) / speedRatio
        currIndex = i
        break
      end
    end
    if time >= station_info.speed_status[spCnt][1] then
      currIndex = spCnt
      distance = distance + station_info.speed_status[spCnt][2] * (time - station_info.speed_status[spCnt][1]) / speedRatio
    end
    if currIndex == nil then
      distance = distance + station_info.speed_status[1][2] * (time - station_info.speed_status[1][1]) / speedRatio
    end
  else
    distance = 0
  end
  return total - distance < 0 and 0 or total - distance, currIndex or 0
end

function DataModel.GetRemainDistanceByEndtime(time)
  if time >= DataModel.EndTime then
    return 0
  end
  if DataModel.DirectSetDisAtStart then
    local total = 0
    for i = #DataModel.Path, 1, -1 do
      total = total + DataModel.Path[i].length
    end
    DataModel.DirectSetDisAtStart = false
    return total, 1
  end
  local station_info = PlayerData:GetHomeInfo().station_info
  local speedRatio = 0 >= (DataModel.SpeedRatio or 0) and PlayerData:GetFactoryData(99900014, "ConfigFactory").speedRatio or DataModel.SpeedRatio
  local distance = 0
  local currIndex
  if station_info.speed_status and table.count(station_info.speed_status) ~= 0 then
    table.sort(station_info.speed_status, function(a, b)
      if a[1] < b[1] then
        return true
      end
      return false
    end)
    local curEndTime = DataModel.EndTime
    local tempSpeed = 0
    for i = #station_info.speed_status, 1, -1 do
      tempSpeed = station_info.speed_status[i][2] / speedRatio
      if time < station_info.speed_status[i][1] then
        if curEndTime > station_info.speed_status[i][1] then
          distance = distance + (curEndTime - station_info.speed_status[i][1]) * tempSpeed
          curEndTime = station_info.speed_status[i][1]
        end
      else
        distance = distance + (curEndTime - time) * tempSpeed
        currIndex = i
        break
      end
    end
  else
    distance = 0
  end
  return distance, currIndex or 0
end

function DataModel.ExitLineEvent()
  local curPathIndex = TrainManager.TrainCtrl.Owner.InnerPathIndex + 1
  local pathCount = #DataModel.Path
  if curPathIndex >= #DataModel.Path then
    return false
  end
  for i = curPathIndex + 1, pathCount do
    if DataModel.Path[i] ~= nil and DataModel.Path[i].events ~= nil and #DataModel.Path[i].events > 0 then
      return true
    end
  end
  return false
end

function DataModel.GetPath(stateEnter)
  local station_info = PlayerData:GetHomeInfo().station_info
  local index = 0
  local count = #DataModel.DriveLine
  if stateEnter ~= EnumDefine.TrainStateEnter.Refresh and stateEnter ~= EnumDefine.TrainStateEnter.ApplicationQuit and stateEnter ~= EnumDefine.TrainStateEnter.BattleFinish then
    DataModel.Path = {}
  end
  if stateEnter == EnumDefine.TrainStateEnter.ApplicationQuit and BugLogReporter.SendTrainEvent == 1 then
    DataModel.Path = {}
    BugLogReporter.SendTrainEvent = 2
  end
  local currEvent
  for i = 1, count - 1 do
    local station01 = DataModel.DriveLine[i].id
    local station02 = DataModel.DriveLine[i + 1].id
    local distance = MapDataModel.AllStationPathRecord[station01][station02].distance
    local lineId = MapDataModel.AllStationPathRecord[station01][station02].id
    if stateEnter ~= EnumDefine.TrainStateEnter.Refresh and stateEnter ~= EnumDefine.TrainStateEnter.ApplicationQuit and stateEnter ~= EnumDefine.TrainStateEnter.BattleFinish or stateEnter == EnumDefine.TrainStateEnter.ApplicationQuit and BugLogReporter.SendTrainEvent == 2 then
      local cfg1 = PlayerData:GetFactoryData(station01)
      local cfg2 = PlayerData:GetFactoryData(station02)
      local isForward = false
      local name
      if cfg2.pos > cfg1.pos then
        isForward = false
        name = cfg1.pos .. "-" .. cfg2.pos
      else
        isForward = true
        name = cfg2.pos .. "-" .. cfg1.pos
      end
      local line_events = station_info.line_events[tostring(station01)]
      local events, box_events, click_level_events, needleEvents
      if line_events ~= nil then
        events = line_events.events
        needleEvents = MapNeedleEventData.GenerateServerEventData(line_events.line_id)
        box_events = line_events.box_events
        click_level_events = line_events.click_level_events
      end
      if events ~= nil then
        table.sort(events, function(a, b)
          return a.distance > b.distance
        end)
      end
      if needleEvents ~= nil then
        table.sort(needleEvents, function(a, b)
          return a.distance > b.distance
        end)
      end
      if box_events ~= nil then
        table.sort(box_events, function(a, b)
          return a.distance > b.distance
        end)
      end
      table.insert(DataModel.Path, 1, {
        name = name,
        isForward = isForward,
        targetId = station01,
        beginId = station02,
        length = distance,
        events = events,
        needleEvents = needleEvents,
        box_events = box_events,
        click_level_events = click_level_events,
        lineId = lineId
      })
      if i == count - 1 and BugLogReporter.SendTrainEvent == 2 then
        BugLogReporter.SendTrainEvent = 3
      end
    end
  end
  local remainDis = 0
  if DataModel.DistanceToLastStation ~= 0 then
    remainDis = DataModel.DistanceToLastStation
  else
    remainDis = DataModel.GetRemainDistance()
  end
  remainDis = stateEnter == EnumDefine.TrainStateEnter.BattleFinish and remainDis < TrainManager.RemainDistance and TrainManager.RemainDistance or remainDis
  for i = #DataModel.Path, 1, -1 do
    local length = DataModel.Path[i].length
    if length < remainDis - 1 then
      remainDis = remainDis - length
    else
      index = i - 1
      break
    end
  end
  for i, v in ipairs(DataModel.Path) do
    local line_events = station_info.line_events[tostring(v.targetId)]
    local events, box_events, click_level_events, needleEvents
    if line_events ~= nil then
      events = line_events.events
      needleEvents = MapNeedleEventData.GenerateServerEventData(line_events.line_id)
      box_events = line_events.box_events
      click_level_events = line_events.click_level_events
    end
    if events ~= nil then
      table.sort(events, function(a, b)
        return a.distance > b.distance
      end)
    end
    if needleEvents ~= nil then
      table.sort(needleEvents, function(a, b)
        return a.distance > b.distance
      end)
    end
    if box_events ~= nil then
      table.sort(box_events, function(a, b)
        return a.distance > b.distance
      end)
    end
    v.events = events
    v.box_events = box_events
    v.click_level_events = click_level_events
    v.needleEvents = needleEvents
  end
  local cfg = PlayerData:GetFactoryData(99900037, "ConfigFactory")
  local speedReduce = cfg.speedReduce
  local homeConfig = PlayerData:GetFactoryData(99900014, "ConfigFactory")
  local speedRatio = homeConfig.speedRatio
  local time = DataModel.Speed / speedRatio / speedReduce
  local offset = 0.5 * speedReduce * time * time
  offset = 1
  for i, v in ipairs(DataModel.Path) do
    if i < index + 1 and v.events and 0 < #v.events then
      currEvent = v.events[1]
      index = i - 1
      break
    elseif i == index + 1 and v.events and 0 < #v.events then
      for a, b in ipairs(v.events) do
        if remainDis <= b.distance + offset then
          currEvent = b
          break
        end
      end
      break
    end
  end
  if currEvent then
    if DataModel.Path[index + 1] and DataModel.Path[index + 1].needleEvents and 0 < #DataModel.Path[index + 1].needleEvents and currEvent.distance < DataModel.Path[index + 1].needleEvents[1].distance then
      currEvent = DataModel.Path[index + 1].needleEvents[1]
      MapNeedleEventData.event = currEvent.id
    end
  else
    for i, v in ipairs(DataModel.Path) do
      if i < index + 1 and v.needleEvents and 0 < #v.needleEvents then
        currEvent = v.needleEvents[1]
        index = i - 1
        MapNeedleEventData.event = currEvent.id
        break
      elseif i == index + 1 and v.needleEvents and 0 < #v.needleEvents then
        for a, b in ipairs(v.needleEvents) do
          if remainDis <= b.distance + offset then
            currEvent = b
            MapNeedleEventData.event = currEvent.id
            break
          end
        end
        break
      end
    end
  end
  local resultRemainDis = currEvent and currEvent.distance or remainDis
  return resultRemainDis, index, currEvent
end

function DataModel.SetMapGlobalNeedles()
  MapSessionManager:ClearGlobalNeedles()
  DataModel.ClearGloabalNeedls()
  for needleId, v in pairs(MapNeedleData.GlobalNeedleList) do
    MapSessionManager:SetGlobalNeedle(needleId)
  end
  MapSessionManager:ResetCamera(false)
end

function DataModel.ClearGloabalNeedls()
  local globalMapNeedleParent
  local scene = CS.UnityEngine.SceneManagement.SceneManager.GetSceneAt(0)
  if scene == nil and scene.name ~= "Main" then
    return
  end
  local objs = scene:GetRootGameObjects()
  for i = 1, objs.Length do
    if objs[i - 1].name == "Env_UI" then
      globalMapNeedleParent = objs[i - 1]
      break
    end
  end
  if globalMapNeedleParent ~= nil then
    globalMapNeedleParent = globalMapNeedleParent.transform
    for i = 1, globalMapNeedleParent.childCount do
      CS.UnityEngine.GameObject.Destroy(globalMapNeedleParent:GetChild(i - 1).gameObject)
    end
  end
end

function DataModel.ResetTrainPos()
  if DataModel.RemainDis == nil then
    return
  end
  local FirstTrain = CS.FRef.getProperty(TrainManager.TrainCtrl, "FirstTrain")
  local Trains = CS.FRef.getProperty(TrainManager.TrainCtrl, "Trains")
  if FirstTrain == nil or Trains == nil then
    return
  end
  local CoachSkinFactory = CBus:GetFactory(CS.FactoryName.HomeCoachSkinFactory, false, true)
  local offset = 0
  local index = 0
  local TrainPosition = {}
  local isForward = FirstTrain.Direction.value__ == 0
  for i, v in pairs(Trains) do
    local pos = 0
    if isForward == true then
      pos = FirstTrain.Spline.Length - DataModel.RemainDis
    else
      pos = DataModel.RemainDis
    end
    local ca = CoachSkinFactory:GetCA(v.SkinId)
    if index ~= 0 then
      if isForward then
        offset = offset - (ca.skinSize / 2 + ca.rightPointX) * 3.5
      else
        offset = offset + (ca.skinSize / 2 + ca.rightPointX) * 3.5
      end
      pos = pos + offset
    end
    table.insert(TrainPosition, pos)
    if isForward then
      offset = offset - (ca.skinSize / 2 + ca.leftPointX) * 3.5
    else
      offset = offset + (ca.skinSize / 2 + ca.leftPointX) * 3.5
    end
    index = index + 1
  end
  local lastPos = TrainPosition[#TrainPosition]
  if lastPos ~= nil then
    if isForward == false then
      if 0 > FirstTrain.Spline.Length - lastPos then
        local sub = lastPos - FirstTrain.Spline.Length + 1
        for i, v in pairs(TrainPosition) do
          TrainPosition[i] = v - sub
        end
      end
    elseif lastPos < 0 then
      local sub = 0 - lastPos + 1
      for i, v in pairs(TrainPosition) do
        TrainPosition[i] = v + sub
      end
    end
  end
  index = 1
  for i, v in pairs(Trains) do
    if isForward == true then
      v:SetPosition(FirstTrain.Spline.Length - TrainPosition[index])
    else
      v:SetPosition(TrainPosition[index])
    end
    index = index + 1
  end
end

local function SetAntiAliasing(camera)
  if camera ~= nil then
    print_r("\232\191\155\229\133\165\230\138\151\233\148\175\233\189\191\233\133\141\231\189\174")
    local isMSAA = PlayerPrefs.GetInt("currentMSAA")
    local uber = camera:GetComponent(typeof(CS.RgEffect.RGUBer))
    if uber ~= nil and uber.indexAntialiasing ~= nil then
      if isMSAA == 3 then
        uber.indexAntialiasing = 1
      else
        uber.indexAntialiasing = 0
      end
    end
  end
end

function DataModel.SetTrainMode(callback)
  local stationCA = PlayerData:GetFactoryData(DataModel.CurStayCity)
  MainManager:SetTrainViewFilter(DataModel.DelayPer, true)
  if not DataModel.GetInTravel() then
    SafeReleaseScene(true)
  end
  local camera = MapDataModel:FindCamera()
  SetAntiAliasing(camera)
  MainManager:SetTrainMode(DataModel.GetInTravel(), DataModel.GetInTravel() and "TrainMap" or MainDataModel.CurShowSceneInfo.stationScene, DataModel.DelayPer, function()
    EffectFactory:Clear()
    HomeView.self:StartC(LuaUtil.cs_generator(function()
      coroutine.yield(CS.UnityEngine.WaitForSeconds(2))
      PlayerData.canAuto = 1
    end))
    PlayerData.RefreshStriker(DataModel.GetInTravel())
    MainManager:SetTrainViewFilter(DataModel.DelayPer, false)
    MapSessionManager:ClearGlobalNeedles()
    DataModel.ClearGloabalNeedls()
    if not DataModel.GetInTravel() then
      local TimeLine = require("Common/TimeLine")
      for k, v in pairs(stationCA.timeLineList) do
        TimeLine.LoadTimeLine(v.id, nil, true)
      end
      if UIManager:IsPanelOpened("UI/MainUI/MainUI") then
        TrainCameraManager:OpenCamera(1)
      end
      TrainCameraManager:SetPostProcessing(1, MainDataModel.CurShowSceneInfo.postProcessingPath)
      FixAdBoard()
      local MainDataModel = require("UIMainUI/UIMainUIDataModel")
      if MainDataModel.justArrived == true then
        local path = TrainWeaponTag.GetTrainTimelineList()
        for i, v in pairs(path) do
          if 0 < v then
            local timeLine = require("Common/TimeLine")
            timeLine.LoadTimeLine(v)
          end
        end
        MainDataModel.justArrived = false
      end
    else
      local MainController = require("UIMainUI/UIMainUIController")
      MainController.SetCamera(1)
      if (not (DataModel.StateEnter ~= EnumDefine.TrainStateEnter.FirstLogin and DataModel.StateEnter ~= EnumDefine.TrainStateEnter.DriveNew or TrainManager.IsRunning) and TrainManager.CurrTrainState ~= TrainState.Arrive or DataModel.StateEnter == EnumDefine.TrainStateEnter.BattleFinish) and not PlayerData.TempCache.SendArrive and not PlayerData.GetIsTest() then
        TrainManager:ChangeBasicState(DataModel.TrainState, DataModel.Index, DataModel.RemainDis, DataModel.CurrSpeed, DataModel.TargetSpeed)
        DataModel.ResetTrainPos()
        local mainController = require("UIMainUI/UIMainUIController")
        mainController:InitTrainEffect()
        if DataModel.StateEnter == EnumDefine.TrainStateEnter.BattleFinish then
          DataModel.StateEnter = EnumDefine.TrainStateEnter.DriveNew
        end
      end
      PlayerData.SetIsTest()
      if DataModel.StateEnter == EnumDefine.TrainStateEnter.DriveNew then
        local t = DataModel.GetAnnouncementList(EnumDefine.Announcement.Start)
        SoundManager:PlaySoundList(t)
      end
      TrainManager:UpdateTrainAcceleratedSpeed()
      applyDisplayTrainState()
      local homeController = require("UIMainUI/UIMainUIController")
      homeController.ChangeDriveBtnState()
      local SkyRenderSettingController = require("UIMainUI/UIMainUIRenderSettingController")
      SkyRenderSettingController.SetSkyRender()
      TrainCameraManager:OpenCamera(0)
      DataModel.SetMapGlobalNeedles()
      if TrainManager ~= nil and TrainManager.FreeCamera ~= nil then
        local camConfig = PlayerData:GetFactoryData(99900054, "ConfigFactory")
        TrainManager.FreeCamera.lookSpeed = camConfig.lookSpeed
      end
      if PlayerData.TempCache.Yaw and PlayerData.TempCache.Pitch then
        TrainManager:SetCameraAngle(PlayerData.TempCache.Yaw, PlayerData.TempCache.Pitch)
        PlayerData.TempCache.Yaw = nil
        PlayerData.TempCache.Pitch = nil
      end
    end
    local UIMainUIDataModelTemp = require("UIMainUI/UIMainUIDataModel")
    if UIMainUIDataModelTemp.RushServerTime then
      local remainTime = UIMainUIDataModelTemp.RushServerTime - TimeUtil:GetServerTimeStamp()
      if 0 < remainTime then
        Train.PlayTrainAnim("rushing")
      end
    end
    local cam = MapDataModel:FindCamera()
    SetAntiAliasing(cam)
    if callback then
      callback()
    end
  end)
end

function DataModel.GetAnnouncementList(type, isBack)
  local soundID
  if PlayerData and PlayerData.ServerData and PlayerData.ServerData.user_home_info and PlayerData.ServerData.user_home_info.train_sound then
    soundID = tonumber(PlayerData.ServerData.user_home_info.train_sound)
  end
  soundID = soundID or 88100001
  local cfg = PlayerData:GetFactoryData(soundID, "TrainSoundFactory")
  local voice
  if type == EnumDefine.Announcement.Start then
    if PlayerData:GetCurPassengerNum() > 0 then
      voice = cfg.voiceDeparturePassenger
    else
      voice = cfg.voiceDeparture
    end
  elseif type == EnumDefine.Announcement.Arriving then
    if PlayerData.IsSendPassengerOver(DataModel.EndCity) then
      voice = cfg.voiceWillArrivePassenger
    else
      voice = cfg.voiceWillArrive
    end
  elseif type == EnumDefine.Announcement.Arrive then
    if PlayerData.IsSendPassengerOver(DataModel.EndCity) then
      voice = cfg.voiceArrivePassenger
    else
      voice = cfg.voiceArrive
    end
  elseif type == EnumDefine.Announcement.Enter then
    if PlayerData.IsSendPassengerOver(DataModel.EndCity) then
      voice = cfg.voiceGetInPassenger
    else
      voice = cfg.voiceGetIn
    end
  end
  local t = {}
  for i, v in ipairs(voice) do
    if v.id ~= -1 then
      table.insert(t, v.id)
    elseif v.type then
      local array = string.split(v.type, ",")
      if array[1] == "stationStart" then
        local station = PlayerData:GetFactoryData(DataModel.StartCity, "HomeStationFactory")
        if station.trainSoundList and station.trainSoundList[cfg.soundIndex] then
          table.insert(t, station.trainSoundList[cfg.soundIndex][array[2]])
        end
      elseif array[1] == "stationEnd" then
        local station = PlayerData:GetFactoryData(isBack and DataModel.StartCity or DataModel.EndCity, "HomeStationFactory")
        if station.trainSoundList and station.trainSoundList[cfg.soundIndex] then
          table.insert(t, station.trainSoundList[cfg.soundIndex][array[2]])
        end
      end
    end
  end
  return t
end

function DataModel.ClearTrainAttr()
  DataModel.StateEnter = nil
  DataModel.TrainState = nil
  DataModel.Index = nil
  DataModel.RemainDis = nil
  DataModel.CurrSpeed = nil
  DataModel.TargetSpeed = nil
end

function DataModel.GetTrainCurDistance()
  local remainDis = DataModel.CurRemainDistance
  if remainDis < 0 then
    remainDis = 0
  end
  if PlayerData:GetHomeInfo().station_info.is_arrived == 1 then
    local id = tonumber(PlayerData:GetHomeInfo().station_info.sid or 0)
    if id == DataModel.NextCityPath[1] then
      remainDis = DataModel.TravelTotalDistance
    else
      remainDis = 0
    end
  end
  local curDis = DataModel.TravelTotalDistance - remainDis
  return curDis
end

function DataModel.CalcTravelTotalDistance()
  DataModel.TravelTotalDistance = 0
  local count = #DataModel.NextCityPath
  for i = 1, count - 1 do
    local station01 = DataModel.NextCityPath[i]
    local station02 = DataModel.NextCityPath[i + 1]
    local distance = MapDataModel.AllStationPathRecord[station01][station02].distance
    DataModel.TravelTotalDistance = DataModel.TravelTotalDistance + distance
  end
end

function DataModel.CalcSpaceInfo()
  DataModel.MaxSpace = 0
  for k, v in pairs(PlayerData:GetHomeInfo().coach) do
    local homeCoachCA = PlayerData:GetFactoryData(v.id, "HomeCoachFactory")
    DataModel.MaxSpace = DataModel.MaxSpace + homeCoachCA.space
    DataModel.MaxSpace = DataModel.NumFloorPrecision(DataModel.MaxSpace)
  end
  DataModel.CurUseSpace = 0
  local stockInfo = PlayerData.ServerData.user_home_info.warehouse
  for k, v in pairs(stockInfo) do
    local ca = PlayerData:GetFactoryData(tonumber(k), "HomeGoodsFactory")
    DataModel.CurUseSpace = DataModel.CurUseSpace + v.num * ca.space
    DataModel.CurUseSpace = DataModel.NumCeilPrecision(DataModel.CurUseSpace)
  end
end

function DataModel.RefreshStockInfo()
  local stockInfo = PlayerData.ServerData.user_home_info.warehouse
  DataModel.StockInfo = {}
  for k, v in pairs(stockInfo) do
    local t = {}
    t.id = tonumber(k)
    t.price = v.avg_price or 0
    t.num = v.num
    table.insert(DataModel.StockInfo, t)
  end
end

function DataModel.GetMoney()
  return PlayerData:GetUserInfo().furniture_coins
end

function DataModel.GetActionValue()
  return PlayerData:GetUserInfo().move_energy or 0
end

function DataModel.GetIsTravel()
  local isTravel = PlayerData:GetHomeInfo().station_info.is_arrived == 0
  return isTravel
end

function DataModel.GetIsStop()
  local isStop = not DataModel.GetInTravel()
  return isStop
end

function DataModel.ReachNewCity(notRefreshInfo)
  if not notRefreshInfo then
    DataModel.RefreshTravelInfo(nil, false, true)
  end
  local homeController = require("UIMainUI/UIMainUIController")
  homeController.InitEnvironment()
end

function DataModel.ConfirmHandleGarbage(handleTable)
  local space = 0
  for k, v in pairs(handleTable) do
    space = space + v.num * v.space
  end
  local isFind = false
  for k, v in pairs(handleTable) do
    for k1, v1 in pairs(DataModel.StockInfo) do
      if v.id == v1.id then
        isFind = true
        v1.num = v1.num - v.num
        if PlayerData.ServerData.user_home_info.warehouse[tostring(v.id)] ~= nil then
          PlayerData.ServerData.user_home_info.warehouse[tostring(v.id)].num = v1.num
        end
        if 0 >= v1.num then
          PlayerData.ServerData.user_home_info.warehouse[tostring(v.id)] = nil
          table.remove(DataModel.StockInfo, k1)
        end
        break
      end
    end
  end
  if isFind then
    DataModel.CurUseSpace = DataModel.CurUseSpace - space
    CommonTips.OpenTips(80600292)
  end
end

function DataModel.GetNextDayTime()
  local todayInfo = os.date("*t", TimeUtil:GetServerTimeStamp())
  return os.time({
    year = todayInfo.year,
    month = todayInfo.month,
    day = todayInfo.day + 1,
    hour = 0,
    min = 0,
    sec = 0
  })
end

function DataModel.NumFloorPrecision(num)
  local a, b = math.modf(num)
  if 0 <= num then
    if b + 1.0E-4 > 1 then
      a = a + 1
    else
      return a
    end
  elseif b - 1.0E-4 < -1 then
    a = a - 1
  else
    return a
  end
  return a
end

function DataModel.NumCeilPrecision(num)
  local a, b = math.modf(num)
  if 0 <= num then
    if 0 > b - 1.0E-4 then
      return a
    else
      return a + 1
    end
  elseif 0 < b + 1.0E-4 then
    return a
  else
    return a - 1
  end
  return a + 1
end

function DataModel.GetPreciseDecimal(nNum, n)
  if type(nNum) ~= "number" then
    return nNum
  end
  n = n or 0
  n = math.floor(n)
  if n < 0 then
    n = 0
  end
  local nDecimal = 10 ^ n
  local nTemp = math.floor(nNum * nDecimal)
  local nRet = nTemp / nDecimal
  return nRet
end

function DataModel.NumRound(num)
  if 0 < num then
    return DataModel.NumFloorPrecision(num + 0.5)
  elseif num < 0 then
    return DataModel.NumFloorPrecision(num - 0.5)
  end
  return 0
end

return DataModel
