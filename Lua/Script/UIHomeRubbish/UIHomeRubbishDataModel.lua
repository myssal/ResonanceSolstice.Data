local DataModel = {}

local function CalPetRubbishCnt(fur)
  local cnt = 0
  local furCA = PlayerData:GetFactoryData(fur.id)
  local petList = fur.house.pets or {}
  for i = 1, furCA.PetNum do
    petList[i] = petList[i] or ""
    if petList[i] ~= "" then
      local petId = PlayerData:GetHomeInfo().pet[petList[i]].id
      local cfg = PlayerData:GetFactoryData(petId)
      cnt = cnt + cfg.wasteoutput
    end
  end
  return cnt
end

function DataModel.CalFurRubbishCnt(tempfurniture)
  local furCA = PlayerData:GetFactoryData(tempfurniture.id)
  local furRubbishNum = 0
  if furCA.functionType == 12600199 then
    if tempfurniture.roles then
      for i, v in pairs(tempfurniture.roles) do
        if v ~= "" then
          local unitCA = PlayerData:GetFactoryData(v, "UnitFactory")
          furRubbishNum = furRubbishNum + unitCA.WasteCoefficient * furCA.wasteoutput
        end
      end
    end
  else
    furRubbishNum = furRubbishNum + furCA.wasteoutput
  end
  if furCA.functionType == 12600464 then
    furRubbishNum = furRubbishNum + CalPetRubbishCnt(tempfurniture)
  end
  if tempfurniture.water then
    furRubbishNum = furRubbishNum + (tempfurniture.water.volume or 0)
  end
  return furRubbishNum
end

function DataModel.CalCoachRubbishCnt(fur_list)
  local furniture = CommonCoachData.GetFurData(DataModel.bag)
  local rubbishNum = 0
  for k, v in pairs(fur_list) do
    local tempfurniture = furniture[tostring(v.id)]
    if tempfurniture then
      rubbishNum = rubbishNum + DataModel.CalFurRubbishCnt(tempfurniture)
    end
  end
  return rubbishNum
end

local function CalRubbishChannelCnt(level)
  local homeCfg = PlayerData:GetFactoryData(99900014)
  local channelCnt = 1
  local channelAllCnt = 1
  for i, v in ipairs(homeCfg.openLevelList) do
    if level >= v.Level then
      channelCnt = v.Num
    end
    channelAllCnt = v.Num
  end
  DataModel.channelAllCnt = channelAllCnt
  return channelCnt
end

function DataModel._init(u_fid)
  DataModel.u_fid = u_fid
  local f_id = CommonCoachData.GetFurData(DataModel.bag)[u_fid].id
  local f_cfg = PlayerData:GetFactoryData(f_id)
  local home_cfg = PlayerData:GetFactoryData(99900014)
  local skin_id = CommonCoachData.GetFurData(DataModel.bag)[u_fid].u_skin
  DataModel.skin_id = (skin_id == "" or skin_id == nil) and f_cfg.defaultSkin or skin_id
  DataModel.channel_cnt = CalRubbishChannelCnt(f_cfg.Level)
  DataModel.fur_level = f_cfg.Level
  local addCapaticy = PlayerData:GetHomeSkillIncrease(EnumDefine.HomeSkillEnum.RiseTrashStagingLimited)
  DataModel.rubbish_bock_capaticy = f_cfg.StoreRubbish + addCapaticy
  DataModel.rubbish_compress_limit = f_cfg.StoreRubbishMax + 2 * addCapaticy
  DataModel.unit_cost_time = f_cfg.compressionTime
  DataModel.unit_cost_cnt = home_cfg.CompressNum
  DataModel.compress_mincnt = DataModel.channel_cnt * DataModel.unit_cost_cnt
  DataModel.coach_list = {}
  DataModel.unit_waste = {}
  DataModel.create_rubbish = 0
  DataModel.playgroundId = nil
  if DataModel.island then
    DataModel.playgroundId = CommonCoachData.GetPlaygroundId()
    local roomList = CommonCoachData.roomID
    local coach_store = CommonCoachData.GetRoomData()
    for i, v in ipairs(roomList) do
      for k1, v1 in pairs(coach_store) do
        if v1.id == tostring(v) then
          local coach_cfg = PlayerData:GetFactoryData(v1.id)
          local recv_time = v1.collect_ts or TimeUtil:GetServerTimeStamp() - 86400
          if recv_time == "" then
            recv_time = TimeUtil:GetServerTimeStamp() - 86400
          end
          table.insert(DataModel.coach_list, {
            goods_coach = false,
            recv_time = recv_time,
            coach_id = k1
          })
          DataModel.unit_waste[k1] = coach_cfg.carriageRubbish
          DataModel.unit_waste[k1] = DataModel.unit_waste[k1] + DataModel.CalCoachRubbishCnt(v1.location)
          DataModel.create_rubbish = DataModel.create_rubbish + DataModel.unit_waste[k1]
          break
        end
      end
    end
  else
    local roomList = PlayerData:GetHomeInfo().coach_template
    local coach_store = PlayerData:GetHomeInfo().coach_store
    for i, v in ipairs(roomList) do
      local cfgId = coach_store[v].id
      local coach_cfg = PlayerData:GetFactoryData(cfgId)
      local coachType = coach_cfg.coachType
      local tagCA = PlayerData:GetFactoryData(coachType)
      local goods_coach = true
      if not tagCA.stopCarriage then
        goods_coach = false
      end
      local recv_time = coach_store[v].collect_ts or TimeUtil:GetServerTimeStamp() - 86400
      table.insert(DataModel.coach_list, {
        goods_coach = goods_coach,
        recv_time = recv_time,
        coach_id = v
      })
      DataModel.unit_waste[v] = coach_cfg.carriageRubbish
      DataModel.unit_waste[v] = DataModel.unit_waste[v] + DataModel.CalCoachRubbishCnt(coach_store[v].location)
      DataModel.create_rubbish = DataModel.create_rubbish + DataModel.unit_waste[v]
    end
  end
  DataModel.serverTime = TimeUtil:GetServerTimeStamp() or 1682175600
  local rubbish_info = PlayerData:GetHomeInfo().rubbish_area or {}
  if DataModel.island then
    rubbish_info = CommonCoachData.GetCurPlaygroundServerInfo().rubbish_area or {}
  end
  DataModel.now_bock_cnt = rubbish_info.waste_block
  DataModel.wait_cnt = rubbish_info.waste_num
  DataModel.compress_ts = rubbish_info.compress_ts
  DataModel.remain_ts = DataModel.GetRemainCompressTs(DataModel.serverTime)
end

function DataModel.CalDaysBetweenTimestamps(timestamp1, timestamp2)
  local date1 = os.date("*t", timestamp1 or timestamp2)
  local date2 = os.date("*t", timestamp2)
  local refresh_ts = PlayerData:GetFactoryData(99900001).dailyRefreshTime
  local hours = string.split(refresh_ts, ":")[1] or 0
  local time1 = os.time({
    year = date1.year,
    month = date1.month,
    day = date1.day,
    hour = hours
  })
  local time2 = os.time({
    year = date2.year,
    month = date2.month,
    day = date2.day,
    hour = date2.hour
  })
  local days = math.floor(math.abs(time2 - time1) / 86400)
  return days
end

function DataModel.UpdateRecvTime(coachId, recv_time)
  local coach_Info = DataModel.coach_list[coachId]
  if coach_Info then
    coach_Info.recv_time = recv_time
    if DataModel.island then
      local coach_store = CommonCoachData.GetRoomData()
      coach_store[coach_Info.coach_id].collect_ts = recv_time
    else
      PlayerData:GetHomeInfo().coach[coachId].collect_ts = recv_time
    end
  end
end

function DataModel.UpdateWaitCnt(delta)
  DataModel.wait_cnt = DataModel.wait_cnt + delta
  DataModel.wait_cnt = DataModel.wait_cnt >= 0 and DataModel.wait_cnt or 0
end

function DataModel.GetRemainCompressTs(now_time)
  local remain_ts = DataModel.unit_cost_time - (now_time - DataModel.compress_ts)
  return MathEx.Clamp(remain_ts, 0, DataModel.compress_ts)
end

function DataModel.IsCanLevelUp()
  if DataModel.u_fid then
    local f_id = CommonCoachData.GetFurData(DataModel.bag)[DataModel.u_fid].id
    local f_cfg = PlayerData:GetFactoryData(f_id)
    return f_cfg.upgrade > 0
  end
end

return DataModel
