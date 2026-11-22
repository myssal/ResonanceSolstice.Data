local DataModel = {
  SortState = {
    index = 1,
    currentBtn = nil,
    currentDown = true
  },
  LowestScore = 0,
  RoomPayParam = 0,
  PrisonerPayParam = 0,
  PrisonerList = {},
  SortShowList = {},
  ChoosePrisonerList = {},
  MaxScore = 100,
  RoomLevel = 1,
  LawyerList = {},
  CanParoleCount = 0,
  CanParolePrisonerData = {},
  CantParolePrisonerData = {},
  SortCanParolePrisonerData = {},
  SortCantParolePrisonerData = {},
  CantShowPrisonerPidList = {},
  CurLawyerData = {},
  TitleGridHeight = 40,
  PrisonerGridHeight = 180
}

function DataModel.InitData()
  DataModel.isFirst = true
  local serverBuildList = PrisonData.GetBuildList()
  local serverData = serverBuildList["87500016"]
  DataModel.RoomLevel = serverData.lv
  local roomLevelId = PlayerData:GetFactoryData(87500016).roomList[DataModel.RoomLevel].config
  local roomCfg = PlayerData:GetFactoryData(roomLevelId)
  DataModel.LowestScore = roomCfg.lowestScore
  DataModel.RoomPayParam = roomCfg.parolePayParam
  DataModel.CollectCantShowPrisonerList()
  DataModel.CollectPrisonerList()
  DataModel.InitCurLawyerData()
  DataModel.InitLawyerList()
end

function DataModel.InitCurLawyerData()
  DataModel.CurLawyerData = {}
  if DataModel.HasLawyer() then
    local lawyerCfg = PrisonData.GetPrisonCA().lawyerList
    local lawyer = PlayerData.ServerData.user_prison_info.cur_lawyer
    DataModel.CurLawyerData = {
      id = lawyer.lawyer_id,
      day = lawyer.days,
      cfg = lawyerCfg[tonumber(lawyer.lawyer_id)],
      employ_ts = lawyer.employ_ts
    }
  end
end

function DataModel.InitLawyerList()
  DataModel.LawyerList = {}
  local lawyerCfg = PrisonData.GetPrisonCA().lawyerList
  local lawyers = PlayerData.ServerData.user_prison_info.lawyers
  for i, v in pairs(lawyers) do
    local row = {
      id = i,
      day = v,
      cfg = lawyerCfg[tonumber(i)]
    }
    table.insert(DataModel.LawyerList, row)
  end
end

function DataModel.CollectCantShowPrisonerList()
  DataModel.CantShowPrisonerPidList = {}
  local serverData = PlayerData.ServerData.user_prison_info.workshops_product_plant or {}
  for roomIndex, data in pairs(serverData) do
    for pos, detail in pairs(data) do
      if detail then
        local curPlacedPrisoner = PlayerData.ServerData.user_prison_info.workshops_front[tostring(roomIndex)][tostring(pos)]
        if curPlacedPrisoner and curPlacedPrisoner ~= "" then
          DataModel.CantShowPrisonerPidList[curPlacedPrisoner] = curPlacedPrisoner
        end
      end
    end
  end
  local materialData = PlayerData.ServerData.user_prison_info.raw_material_workshops or {}
  for roomIndex, data in pairs(materialData) do
    if data and data.start_ts and data.start_ts ~= 0 then
      for i, v in pairs(data.u_pid_list) do
        DataModel.CantShowPrisonerPidList[v] = v
      end
    end
    if data and data.pre_u_pid_list and 0 < table.count(data.pre_u_pid_list) then
      for i, v in pairs(data.pre_u_pid_list) do
        DataModel.CantShowPrisonerPidList[v] = v
      end
    end
  end
  local detentionServerData = PlayerData.ServerData.user_prison_info.detention_room or {}
  for u_pid, data in pairs(detentionServerData) do
    DataModel.CantShowPrisonerPidList[u_pid] = u_pid
  end
  local medicalServerData = PlayerData.ServerData.user_prison_info.medical_room or {}
  for u_pid, data in pairs(medicalServerData) do
    DataModel.CantShowPrisonerPidList[u_pid] = u_pid
  end
end

function DataModel.CollectPrisonerList()
  DataModel.CanParolePrisonerData = {}
  DataModel.CantParolePrisonerData = {}
  local allPrisoner = Clone(PlayerData.ServerData.user_prison_info.prison_backpack)
  for k, v in pairs(allPrisoner) do
    if not DataModel.CantShowPrisonerPidList[k] then
      local cfg = PlayerData:GetFactoryData(v.prisoner_id)
      local row = {
        u_pid = k,
        id = v.prisoner_id,
        remainTime = v.imprisonment_ts + v.days * 86400 - TimeUtil:GetServerTimeStamp(),
        days = v.days,
        score = v.score,
        payParam = cfg.prisonParolePayParam,
        enterTime = v.imprisonment_ts,
        clint_num = v.clint_num
      }
      if row.score >= DataModel.LowestScore then
        table.insert(DataModel.CanParolePrisonerData, row)
      else
        table.insert(DataModel.CantParolePrisonerData, row)
      end
    end
  end
  DataModel.CanParoleCount = table.count(DataModel.CanParolePrisonerData)
end

function DataModel.HasLawyer()
  local hasLawyer = false
  if PlayerData.ServerData.user_prison_info.cur_lawyer and next(PlayerData.ServerData.user_prison_info.cur_lawyer) ~= nil then
    local remainTime = DataModel.GetCurLawyerRemainTime()
    if 0 < remainTime then
      hasLawyer = true
    end
  end
  return hasLawyer
end

function DataModel.IsCurLawyer(lid)
  if PlayerData.ServerData.user_prison_info.cur_lawyer and PlayerData.ServerData.user_prison_info.cur_lawyer.lawyer_id == lid then
    local remainTime = DataModel.GetCurLawyerRemainTime()
    if 0 < remainTime then
      return true
    end
    return false
  end
  return false
end

function DataModel.GetCurLawyerRemainTime()
  local lawyerData = PlayerData.ServerData.user_prison_info.cur_lawyer
  if not lawyerData or next(lawyerData) == nil then
    return 0
  end
  local remainTime = lawyerData.employ_ts + lawyerData.days * 86400 - TimeUtil:GetServerTimeStamp()
  return remainTime < 0 and 0 or remainTime
end

function DataModel.GetLawyerCost()
  if not DataModel.HasLawyer() then
    return 0
  end
  local cfg = PrisonData.GetPrisonCA().lawyerList[tonumber(PlayerData.ServerData.user_prison_info.cur_lawyer.lawyer_id)]
  return cfg.moneyCostPer
end

function DataModel.IsPrisonerChoose(u_pid)
  return DataModel.ChoosePrisonerList[u_pid] ~= nil
end

function DataModel.CalParoleMoney(score, prisonerParam)
  local rlt = 0
  if DataModel.HasLawyer() then
    rlt = math.floor(DataModel.RoomPayParam * DataModel.CurLawyerData.cfg.moneyAdd * prisonerParam * 10000 / (score * score) * (1 - DataModel.CurLawyerData.cfg.moneyCostPer))
  else
    rlt = math.floor(DataModel.RoomPayParam * prisonerParam * 10000 / (score * score) + 0.5) or 0
  end
  return rlt
end

return DataModel
