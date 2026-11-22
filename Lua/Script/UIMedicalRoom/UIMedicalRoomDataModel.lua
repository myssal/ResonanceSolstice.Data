local DataModel = {
  PrisonerList = {},
  RoomLevel = 1,
  RoomLevelCfg = {},
  FakePrisoner = {},
  TotalBedNum = 0,
  UsedBedNum = 0,
  DefaultOpenGrid = 12,
  HealingPrisonerData = {},
  WaitingPrisonerData = {},
  PrisonerList = {},
  CountDownHandler = {},
  isFirst = true,
  Ill2TimeCache = {}
}

function DataModel.InitData()
  DataModel.RoomLevel = PrisonData.GetBuildList()["87500015"].lv or 0
  local roomLevelId = PlayerData:GetFactoryData("87500015").roomList[DataModel.RoomLevel].config
  local roomCfg = PlayerData:GetFactoryData(roomLevelId)
  DataModel.RoomLevelCfg = roomCfg
  DataModel.TotalBedNum = roomCfg.bedNum
  DataModel.InitIllTime()
  DataModel.InitHealingPrisonerData()
  DataModel.InitWaitingPrisonerData()
  DataModel.CollectReportData()
end

function DataModel.InitIllTime()
  DataModel.Ill2TimeCache = {}
  for i, v in ipairs(DataModel.RoomLevelCfg.cureTimeList) do
    DataModel.Ill2TimeCache[tostring(v.illID)] = v.cureTime
    DataModel.Ill2TimeCache[tostring(v.otherID)] = v.cureTime
  end
end

function DataModel.InitHealingPrisonerData()
  DataModel.HealingPrisonerData = {}
  local serverData = PlayerData.ServerData.user_prison_info.medical_room or {}
  for i, v in pairs(serverData) do
    local row = {
      u_pid = i,
      medicalTime = v.medical_ts,
      start_ts = v.start_ts,
      illness = v.ill_id
    }
    local finishTime = v.start_ts + v.medical_ts
    if finishTime > TimeUtil:GetServerTimeStamp() then
      table.insert(DataModel.HealingPrisonerData, row)
    end
  end
end

function DataModel.InitWaitingPrisonerData()
  DataModel.WaitingPrisonerData = {}
  local serverData = PlayerData.ServerData.user_prison_info.medical_room_temporary or {}
  for i, v in pairs(serverData) do
    local row = {
      u_pid = i,
      illness = v.ill_id
    }
    table.insert(DataModel.WaitingPrisonerData, row)
  end
end

function DataModel.CollectReportData()
  DataModel.ReportCurePrisonerList = {}
  DataModel.ReportReleasePrisonerList = {}
  local reportData = PlayerData.ServerData.user_prison_info.medical_report or {}
  for i, v in pairs(reportData) do
    if v == "in" then
      local row = {}
      row.u_pid = i
      local serData = PlayerData.ServerData.user_prison_info.medical_room[tostring(i)]
      local prisonerData = PrisonData.GetPrisoner(tostring(i))
      if serData and prisonerData then
        row.startTime = serData.start_ts
        row.medicalTime = serData.medical_ts
        row.id = prisonerData.prisoner_id
        row.illness = serData.ill_id
        row.clint_num = prisonerData.clint_num
      end
      table.insert(DataModel.ReportCurePrisonerList, row)
    elseif v == "out" then
      local prisonerData = PrisonData.GetPrisoner(tostring(i))
      local row = {}
      if prisonerData then
        row.u_pid = i
        row.id = prisonerData.prisoner_id
        table.insert(DataModel.ReportReleasePrisonerList, row)
      end
    end
  end
end

return DataModel
