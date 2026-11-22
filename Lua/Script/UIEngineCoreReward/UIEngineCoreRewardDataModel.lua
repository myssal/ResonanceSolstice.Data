local DataModel = {
  DefaultConfigId = 99900001,
  rewardState = {
    canNot = 1,
    canGet = 2,
    hasGet = 3
  },
  isOpenedByActivityPanel = false
}

function DataModel.GetDefaultConfig()
  return PlayerData:GetFactoryData(DataModel.DefaultConfigId)
end

function DataModel.GetCoreList()
  local defaultConfig = DataModel.GetDefaultConfig()
  if not defaultConfig then
    return nil
  end
  return defaultConfig.coreList
end

function DataModel.GetCurCoreLevel(coreId)
  if not PlayerData.ServerData or not PlayerData.ServerData.engines then
    return 1
  end
  local serverInfo = PlayerData.ServerData.engines[tostring(coreId)]
  if not serverInfo then
    return 1
  end
  return serverInfo.lv
end

function DataModel.GetIsHasRedDotByCoreId(coreId)
  local coreLvList = DataModel.GetCoreLvListById(coreId) or {}
  for i = 1, #coreLvList do
    local rewardState = DataModel.GetLvRewardStateByIdAndLv(coreId, coreLvList[i].lv)
    if rewardState == DataModel.rewardState.canGet then
      return true
    end
  end
  return false
end

function DataModel.GetLvRewardStateByIdAndLv(coreId, lv)
  if not PlayerData.ServerData or not PlayerData.ServerData.engines then
    return DataModel.rewardState.canNot
  end
  local serverInfo = PlayerData.ServerData.engines[tostring(coreId)]
  if not serverInfo then
    return DataModel.rewardState.canNot
  end
  local curLv = serverInfo.lv or 1
  if lv > curLv then
    return DataModel.rewardState.canNot
  else
    local lvRewardList = serverInfo.lv_reward or {}
    for i = 1, #lvRewardList do
      if lvRewardList[i] == lv - 1 then
        return DataModel.rewardState.hasGet
      end
    end
    return DataModel.rewardState.canGet
  end
  return DataModel.rewardState.canNot
end

function DataModel.GetCoreLvListById(coreId)
  local coreConfig = PlayerData:GetFactoryData(coreId, "EngineCoreFactory")
  if not coreConfig then
    return {}
  end
  local coreExpList = coreConfig.coreExpList
  if not coreExpList then
    return {}
  end
  local list = {}
  for i = 1, #coreExpList do
    local info = coreExpList[i]
    if info and info.id > 0 then
      local tempListCA = PlayerData:GetFactoryData(info.id, "ListFactory")
      if tempListCA and 0 < #tempListCA.EngineRewardList then
        info.lv = i
        table.insert(list, info)
      end
    end
  end
  local finalList = {}
  if list and 0 < #list then
    local canGetList = {}
    local canNotList = {}
    local hasGetList = {}
    for i = 1, #list do
      local info = list[i]
      if info then
        local getState = DataModel.GetLvRewardStateByIdAndLv(coreId, info.lv)
        if getState == DataModel.rewardState.canGet then
          table.insert(canGetList, info)
        elseif getState == DataModel.rewardState.canNot then
          table.insert(canNotList, info)
        elseif getState == DataModel.rewardState.hasGet then
          table.insert(hasGetList, info)
        end
      end
    end
    for i = 1, #canGetList do
      table.insert(finalList, canGetList[i])
    end
    for i = 1, #canNotList do
      table.insert(finalList, canNotList[i])
    end
    for i = 1, #hasGetList do
      table.insert(finalList, hasGetList[i])
    end
  end
  return finalList
end

function DataModel.GetHasGetRewardCount()
  local coreList = DataModel.GetCoreList() or {}
  local hasGetCount = 0
  for i = 1, #coreList do
    local lvList = DataModel.GetCoreLvListById(coreList[i].id) or {}
    for j = 1, #lvList do
      local getState = DataModel.GetLvRewardStateByIdAndLv(coreList[i].id, lvList[j].lv)
      if getState == DataModel.rewardState.hasGet then
        hasGetCount = hasGetCount + 1
      end
    end
  end
  return hasGetCount * 100
end

function DataModel.GetCoreRewardRedState()
  local coreList = DataModel.GetCoreList() or {}
  for i = 1, #coreList do
    local lvList = DataModel.GetCoreLvListById(coreList[i].id) or {}
    for j = 1, #lvList do
      local getState = DataModel.GetLvRewardStateByIdAndLv(coreList[i].id, lvList[j].lv)
      if getState == DataModel.rewardState.canGet then
        return true
      end
    end
  end
  return false
end

function DataModel.GetIsAllRewardHasGet()
  local coreList = DataModel.GetCoreList() or {}
  for i = 1, #coreList do
    local lvList = DataModel.GetCoreLvListById(coreList[i].id) or {}
    for j = 1, #lvList do
      local getState = DataModel.GetLvRewardStateByIdAndLv(coreList[i].id, lvList[j].lv)
      if getState == DataModel.rewardState.canGet or getState == DataModel.rewardState.canNot then
        return false
      end
    end
  end
  return true
end

return DataModel
