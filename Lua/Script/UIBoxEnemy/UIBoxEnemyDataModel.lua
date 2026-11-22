local DataModel = {
  gridId = nil,
  eventId = nil,
  difficulty = nil,
  dialogEvent = nil,
  isInit = nil,
  costNum = 0,
  costMaxNum = 0,
  rewardList = {},
  costItemId = nil,
  levelOnceAddCostNum = 0,
  addLevel = 0,
  maxShowLevel = 0,
  isFightCDIng = false,
  effectCoroutines = {}
}

function DataModel.GetBossLevel()
  local eventInfo = PlayerData:GetFactoryData(tonumber(DataModel.eventId), "MonopolyEventFactory")
  if not eventInfo then
    return 0, false
  end
  local addLv = eventInfo.addLv or 1
  local maxLv = eventInfo.boxLvLitmit or 0
  local roleLv = PlayerData:GetUserInfo().lv or 1
  local bossLv = roleLv + DataModel.difficulty * addLv
  bossLv = maxLv < bossLv and maxLv or bossLv
  return bossLv, maxLv <= bossLv
end

function DataModel.AddCoroutine(ct)
  if not ct then
    return
  end
  table.insert(DataModel.effectCoroutines, ct)
end

return DataModel
