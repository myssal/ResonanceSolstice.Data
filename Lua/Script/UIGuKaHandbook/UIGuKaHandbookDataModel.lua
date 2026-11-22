local DataModel = {
  ActivityId = WitchData.GetActivityId(),
  GuKaList = {},
  CurSelectGuKaIdx = 1,
  CurSelectEventIdx = 1,
  SealList = {},
  EventList = {},
  GuKaUnlockCount = 0,
  GuKaTotalCount = 0,
  EventUnlockCount = 0,
  EventTotalCount = 0,
  SealUnlockCount = 0,
  SealTotalCount = 0,
  GuKaUnReadCount = 0,
  SealUnReadCount = 0,
  EventUnReadCount = 0
}

function DataModel.SetJsonData(json)
  if json then
    local data = Json.decode(json)
    DataModel.ActivityId = tonumber(data.activityId) or WitchData.GetActivityId()
  else
    DataModel.ActivityId = WitchData.GetActivityId()
  end
end

DataModel.SealItems = {
  "11400421",
  "11400422",
  "11400423",
  "11400424"
}

function DataModel.Init()
  DataModel.CurSelectGuKaIdx = 1
  DataModel.CurSelectEventIdx = 1
  DataModel.InitGuKaData()
  DataModel.InitSealData()
  DataModel.InitEventData()
end

function DataModel.InitGuKaData()
  DataModel.GuKaUnReadCount = 0
  DataModel.GuKaUnlockCount = 0
  DataModel.GuKaTotalCount = 0
  DataModel.GuKaList = {}
  local witchesData = WitchData.GetWitchesData(DataModel.ActivityId)
  local serverData = witchesData.guka or {}
  local listCfg = WitchData.GetParkMapCA(DataModel.ActivityId).gukaList
  for i, v in ipairs(listCfg) do
    table.insert(DataModel.GuKaList, {
      id = v.id,
      unlock = 0,
      lv = 1,
      read = 0
    })
    if serverData[tostring(v.id)] then
      DataModel.GuKaList[i].lv = serverData[tostring(v.id)].lv
      DataModel.GuKaList[i].unlock = 1
      DataModel.GuKaList[i].read = serverData[tostring(v.id)].read and serverData[tostring(v.id)].read == 1 and 1 or 0
    end
    if DataModel.GuKaList[i].unlock == 1 then
      DataModel.GuKaUnlockCount = DataModel.GuKaUnlockCount + 1
    end
    if DataModel.GuKaList[i].read == 0 and DataModel.GuKaList[i].unlock == 1 then
      DataModel.GuKaUnReadCount = DataModel.GuKaUnReadCount + 1
    end
    DataModel.GuKaTotalCount = DataModel.GuKaTotalCount + 1
  end
  table.sort(DataModel.GuKaList, function(a, b)
    if a.unlock == b.unlock then
      return a.id < b.id
    end
    return a.unlock > b.unlock
  end)
end

function DataModel.InitSealData()
  DataModel.SealUnReadCount = 0
  DataModel.SealUnlockCount = 0
  DataModel.SealTotalCount = 0
  DataModel.SealList = {}
  local witchesData = WitchData.GetWitchesData(DataModel.ActivityId)
  local serverData = witchesData.seal_handbook or {}
  local singleList = WitchData.GetParkMapCA(DataModel.ActivityId).singleSealList
  for i, v in ipairs(singleList) do
    table.insert(DataModel.SealList, {
      id = v.id,
      skillId = PlayerData:GetFactoryData(v.id).skillId,
      unlock = 0,
      read = 0
    })
    DataModel.SealTotalCount = DataModel.SealTotalCount + 1
  end
  local combineList = WitchData.GetParkMapCA(DataModel.ActivityId).combineSealList
  for i, v in ipairs(combineList) do
    table.insert(DataModel.SealList, {
      id = v.id,
      skillId = PlayerData:GetFactoryData(v.id).combineSkillId,
      unlock = 0,
      read = 0
    })
    DataModel.SealTotalCount = DataModel.SealTotalCount + 1
  end
  for i, v in ipairs(DataModel.SealList) do
    if serverData[tostring(v.id)] then
      v.unlock = 1
      v.read = serverData[tostring(v.id)].read and serverData[tostring(v.id)].read == 1 and 1 or 0
    end
    if v.unlock == 1 then
      DataModel.SealUnlockCount = DataModel.SealUnlockCount + 1
    end
    if v.read == 0 and v.unlock == 1 then
      DataModel.SealUnReadCount = DataModel.SealUnReadCount + 1
    end
  end
  table.sort(DataModel.SealList, function(a, b)
    if a.unlock == b.unlock then
      return a.id < b.id
    end
    return a.unlock > b.unlock
  end)
end

function DataModel.InitEventData()
  DataModel.EventUnReadCount = 0
  DataModel.EventUnlockCount = 0
  DataModel.EventTotalCount = 0
  DataModel.EventList = {}
  local cfgList = WitchData.GetParkMapCA(DataModel.ActivityId).singleDialogList
  local witchesData = WitchData.GetWitchesData(DataModel.ActivityId)
  local serverData = witchesData.npc_handbook or {}
  for i, v in ipairs(cfgList) do
    local eventCfg = PlayerData:GetFactoryData(v.id)
    DataModel.EventList[i] = {
      id = v.id,
      name = v.name,
      tabPath = v.tabPath,
      dialogList = {}
    }
    for index, data in ipairs(eventCfg.NPCdialogList) do
      DataModel.EventList[i].dialogList[index] = {
        id = data.id,
        unlock = 0,
        read = 0
      }
      DataModel.EventTotalCount = DataModel.EventTotalCount + 1
    end
  end
  for i, v in ipairs(DataModel.EventList) do
    for index, data in ipairs(v.dialogList) do
      if serverData[tostring(data.id)] then
        data.unlock = 1
        data.read = serverData[tostring(data.id)].read and serverData[tostring(data.id)].read == 1 and 1 or 0
      end
      if data.unlock == 1 then
        DataModel.EventUnlockCount = DataModel.EventUnlockCount + 1
      end
      if data.read == 0 and data.unlock == 1 then
        DataModel.EventUnReadCount = DataModel.EventUnReadCount + 1
      end
    end
  end
  table.sort(DataModel.EventList, function(a, b)
    if a.dialogList[1].unlock + a.dialogList[2].unlock == b.dialogList[1].unlock + b.dialogList[2].unlock then
      return a.id < b.id
    end
    return a.dialogList[1].unlock + a.dialogList[2].unlock > b.dialogList[1].unlock + b.dialogList[2].unlock
  end)
end

function DataModel.CheckRedPoint(activityId)
  DataModel.ActivityId = tonumber(activityId) or DataModel.ActivityId
  return DataModel.CheckGuKaRedPoint() or DataModel.CheckSealRedPoint() or DataModel.CheckEventRedPoint()
end

function DataModel.GetHandbookPercent(activityId)
  DataModel.ActivityId = tonumber(activityId) or DataModel.ActivityId
  DataModel.InitGuKaData()
  DataModel.InitSealData()
  DataModel.InitEventData()
  local unlock = DataModel.SealUnlockCount + DataModel.EventUnlockCount + DataModel.GuKaUnlockCount
  local total = DataModel.SealTotalCount + DataModel.EventTotalCount + DataModel.GuKaTotalCount
  return unlock / total
end

function DataModel.CheckGuKaRedPoint()
  DataModel.InitGuKaData()
  return DataModel.GuKaUnReadCount > 0
end

function DataModel.CheckSealRedPoint()
  DataModel.InitSealData()
  return DataModel.SealUnReadCount > 0
end

function DataModel.CheckEventRedPoint()
  DataModel.InitEventData()
  return DataModel.EventUnReadCount > 0
end

return DataModel
