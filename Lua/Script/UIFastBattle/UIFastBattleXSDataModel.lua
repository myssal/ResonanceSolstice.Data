local MainDataModel = require("UIFastBattle/UIFastBattleDataModel")
local homeCommon = require("Common/HomeCommon")
local DataModel = {
  rewardLevels = {},
  curLeverReward = {},
  recordAllRewardLevelInfo = {},
  CurRepInfo = {},
  IsShowEmpty = false,
  CurSelectIdx = 0,
  StarBgPath = "UI/Home/HomeSafe/bg_%s",
  EnemyBgPath = "UI/Home/HomeSafe/name_%s",
  CurShowDrop = {},
  NextRefreshTime = 0
}

function DataModel.InitRewardLevels(serverLevels)
  DataModel.rewardLevels = DataModel.rewardLevels or {}
  DataModel.recordAllRewardLevelInfo = {}
  if not serverLevels then
    return
  end
  local buildList = MainDataModel.GetAllSafeStationList()
  if not buildList or #buildList == 0 then
    return
  end
  for i = 1, #buildList do
    local buildingCA = PlayerData:GetFactoryData(buildList[i].id, "BuildingFactory")
    local detailLevels = serverLevels[tostring(buildList[i].id)]
    if buildingCA and detailLevels then
      DataModel.rewardLevels[buildList[i].id] = {}
      for k, v in pairs(buildingCA.offerQuestList) do
        local t = {}
        t.bossId = v.bossId
        t.id = v.id
        t.index = k
        DataModel.recordAllRewardLevelInfo[t.id] = t
      end
      for k, v in pairs(detailLevels.levels) do
        local levelId, recomGrade
        if tonumber(v) ~= nil then
          levelId = tonumber(v)
        else
          levelId = tonumber(v.id)
          recomGrade = v.lv
        end
        local info = DataModel.recordAllRewardLevelInfo[levelId]
        local t = Clone(info)
        t.serverIdx = k
        if recomGrade then
          t.recomGrade = recomGrade
        end
        table.insert(DataModel.rewardLevels[buildList[i].id], t)
      end
      table.sort(DataModel.rewardLevels[buildList[i].id], function(a, b)
        return a.index < b.index
      end)
    end
  end
  if MainDataModel.BuildingId ~= nil and MainDataModel.BuildingId ~= 0 then
    DataModel.curLeverReward = DataModel.rewardLevels[MainDataModel.BuildingId]
  end
end

function DataModel.GetRewardLevels(serverLevels)
  if not serverLevels then
    return {}
  end
  local buildList = MainDataModel.GetAllSafeStationList()
  if not buildList or #buildList == 0 then
    return {}
  end
  local result = {}
  local recordAllRewardLevelInfo = {}
  for i = 1, #buildList do
    local buildingCA = PlayerData:GetFactoryData(buildList[i].id, "BuildingFactory")
    local detailLevels = serverLevels[tostring(buildList[i].id)]
    if buildingCA and detailLevels then
      result[buildList[i].id] = {}
      for k, v in pairs(buildingCA.offerQuestList) do
        local t = {}
        t.bossId = v.bossId
        t.id = v.id
        t.index = k
        recordAllRewardLevelInfo[t.id] = t
      end
      for k, v in pairs(detailLevels.levels) do
        local levelId, recomGrade
        if tonumber(v) ~= nil then
          levelId = tonumber(v)
        else
          levelId = tonumber(v.id)
          recomGrade = v.lv
        end
        local info = recordAllRewardLevelInfo[levelId]
        local t = Clone(info)
        t.serverIdx = k
        if recomGrade then
          t.recomGrade = recomGrade
        end
        table.insert(result[buildList[i].id], t)
      end
      table.sort(result[buildList[i].id], function(a, b)
        return a.index < b.index
      end)
    end
  end
  return result
end

function DataModel.SortRewardLevels()
  table.sort(DataModel.rewardLevels, function(a, b)
    return a.index < b.index
  end)
end

function DataModel.GetCurRepInfo()
  if not MainDataModel.BuildingId then
    return {}
  end
  local buildingCA = PlayerData:GetFactoryData(MainDataModel.BuildingId, "BuildingFactory")
  if buildingCA and buildingCA.stationId then
    return homeCommon.GetCurLvRepData(buildingCA.stationId) or 0
  end
  return {}
end

return DataModel
