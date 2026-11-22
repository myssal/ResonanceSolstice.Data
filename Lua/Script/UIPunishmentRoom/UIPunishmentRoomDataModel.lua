local DataModel = {
  CurSortDown = false,
  PrisonerList = {},
  RoomLevel = 1,
  CountDownHandler = {},
  DefaultOpenGrid = 12,
  PunishPrisonerList = {},
  ReleasePrisonerList = {},
  ReportTimeHandler = {},
  isFirst = true
}

function DataModel.InitData()
  local serverBuildList = PrisonData.GetBuildList()
  local serverData = serverBuildList["87500014"]
  DataModel.RoomLevel = serverData.lv or 0
  DataModel.CollectPrisonerList()
  DataModel.CollectReportData()
end

function DataModel.CollectPrisonerList()
  DataModel.PrisonerList = {}
  local roomData = PlayerData.ServerData.user_prison_info.detention_room
  for i, v in pairs(roomData) do
    local prisonerData = PrisonData.GetPrisoner(i)
    if prisonerData then
      local row = {
        id = prisonerData.prisoner_id,
        u_pid = i,
        clint_num = prisonerData.clint_num,
        days = prisonerData.days,
        frisk_count = v.frisk_count,
        start_ts = v.start_ts,
        eventId = v.event_id,
        punishTime = v.detention_ts,
        remainPunishTime = v.start_ts + v.detention_ts - TimeUtil:GetServerTimeStamp()
      }
      if row.remainPunishTime > 0 then
        table.insert(DataModel.PrisonerList, row)
      end
    end
  end
end

function DataModel.CollectReportData()
  DataModel.PunishPrisonerList = {}
  DataModel.ReleasePrisonerList = {}
  local reportData = PlayerData.ServerData.user_prison_info.detention_report
  for i, v in pairs(reportData) do
    if v == "in" then
      local row = {}
      row.u_pid = i
      local serData = PlayerData.ServerData.user_prison_info.detention_room[tostring(i)]
      local prisonerData = PrisonData.GetPrisoner(tostring(i))
      if serData and prisonerData then
        row.startTime = serData.start_ts
        row.punishTime = serData.detention_ts
        row.id = prisonerData.prisoner_id
        row.eventId = serData.event_id
        row.clint_num = prisonerData.clint_num
      end
    elseif v == "out" then
      local prisonerData = PrisonData.GetPrisoner(tostring(i))
      local row = {}
      if prisonerData then
        row.u_pid = i
        row.id = prisonerData.prisoner_id
        row.clint_num = prisonerData.clint_num
        table.insert(DataModel.ReleasePrisonerList, row)
      end
    end
  end
end

return DataModel
