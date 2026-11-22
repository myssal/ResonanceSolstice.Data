local DataModel = {
  studyData = {},
  studyingId = 0,
  studyingEndTime = 0,
  studyingCA = {},
  isUpdateStudying = false,
  totalNum = 0,
  firstFrame = false,
  cacheStudiedId = {},
  engLvInfo = {},
  itemCost = {},
  txtColor = "#FFFFFF",
  txtLimitColor = "#DA5F4B",
  lineColor = "#3F7EFF",
  lineCantStudyColor = "#656970",
  lineLimitColor = "#FFFFFF",
  selectTreeIdx = 0,
  lastSelectTreeIdx = 0,
  selectNodeIdx = 0,
  lastSelectNodeIdx = 0,
  autoSelectStudyId = -1,
  autoSelectTreeIdx = -1,
  autoSelectNodeIdx = -1,
  cacheCanStudied = {},
  viewLoadComplete = false
}

function DataModel.Init()
  DataModel.firstFrame = true
  DataModel.cacheCanStudied = {}
  DataModel.cacheStudiedId = {}
  DataModel.studyData = {}
  DataModel.autoSelectTreeIdx = -1
  DataModel.autoSelectNodeIdx = -1
  local defaultConfig = PlayerData:GetFactoryData(99900044)
  local cacheTreeIdx = {}
  local treeIdx = 1
  for _, v in ipairs(defaultConfig.studyList) do
    local ca = PlayerData:GetFactoryData(v.id)
    if ca.treeStudy > 0 then
      if cacheTreeIdx[ca.treeStudy] == nil then
        cacheTreeIdx[ca.treeStudy] = treeIdx
        treeIdx = treeIdx + 1
      end
      local idx = cacheTreeIdx[ca.treeStudy]
      if DataModel.studyData[idx] == nil then
        local t = {}
        t.id = ca.treeStudy
        local treeCA = PlayerData:GetFactoryData(t.id)
        t.ca = treeCA
        t.studyList = {}
        t.studiedCount = 0
        DataModel.studyData[idx] = t
      end
      local t = DataModel.studyData[idx]
      table.insert(t.studyList, ca)
      if ca.reward and 0 < #ca.reward then
        local itemId = ca.reward[1].id
        if itemId and 0 < itemId and 0 < PlayerData:GetGoodsById(itemId).num then
          DataModel.cacheStudiedId[v.id] = 1
          t.studiedCount = t.studiedCount + 1
        end
      end
    end
  end
  for _, v in ipairs(DataModel.studyData) do
    table.sort(v.studyList, function(a, b)
      return a.order < b.order
    end)
  end
  table.sort(DataModel.studyData, function(a, b)
    return a.ca.order < b.ca.order
  end)
  DataModel.totalNum = #defaultConfig.studyList
  DataModel.RefreshStudyingInfo()
  if 0 < DataModel.autoSelectStudyId then
    for iTree, v in ipairs(DataModel.studyData) do
      for iNode, v1 in ipairs(v.studyList) do
        if v1.id == DataModel.autoSelectStudyId then
          DataModel.autoSelectNodeIdx = iNode
          DataModel.autoSelectTreeIdx = iTree
          break
        end
      end
      if DataModel.autoSelectTreeIdx > 0 then
        break
      end
    end
    DataModel.autoSelectStudyId = -1
  end
end

function DataModel.RefreshStudyingInfo()
  local studyInfo = PlayerData:GetHomeInfo().studying or {}
  local key, v = next(studyInfo)
  if key ~= nil then
    DataModel.studyingCA = PlayerData:GetFactoryData(v.id)
    local endTime = v.create_time + DataModel.studyingCA.timeCost
    DataModel.studyingId = tonumber(v.id)
    DataModel.studyingEndTime = endTime
    DataModel.isUpdateStudying = 0 < endTime
  else
    DataModel.studyingCA = {}
    DataModel.studyingId = 0
    DataModel.studyingEndTime = 0
  end
end

function DataModel.SetAutoSelect(studyId)
  DataModel.autoSelectStudyId = studyId
end

function DataModel.CheckCanStudy(studyId)
  if studyId <= 0 then
    return false
  end
  if DataModel.cacheCanStudied[studyId] ~= nil then
    return DataModel.cacheCanStudied[studyId]
  end
  local studyCA = PlayerData:GetFactoryData(studyId)
  local checkLimit = false
  local curLv = PlayerData:GetPlayerLevel()
  checkLimit = checkLimit or curLv < studyCA.levelPrepare
  curLv = PlayerData:GetHomeInfo().electric_lv + 1
  checkLimit = checkLimit or curLv < studyCA.powerPrepare
  local homeCommon = require("Common/HomeCommon")
  local stationId = studyCA.cityPrepare[1].id
  curLv = homeCommon.GetRepLv(stationId)
  checkLimit = checkLimit or curLv < studyCA.cityPrepare[1].lv
  for _, v in ipairs(studyCA.energyPrepare) do
    local serverInfo = PlayerData.ServerData.engines[tostring(v.id)]
    checkLimit = checkLimit or serverInfo.lv < v.lv
  end
  for _, v in ipairs(studyCA.itemCost) do
    if PlayerData:GetGoodsById(v.id).num < v.num then
      checkLimit = true
      break
    end
  end
  DataModel.cacheCanStudied[studyId] = not checkLimit
  return DataModel.cacheCanStudied[studyId]
end

return DataModel
