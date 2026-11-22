local CubeRogueOverviewDataModel = require("UICubeRogueOverview/UICubeRogueOverviewDataModel")
local DataModel = {
  activityId = nil,
  activityCA = {},
  RewardList = {},
  isAdd = false,
  ConstructionType = nil,
  VolleyballType = nil,
  SkipType = nil,
  LevelType = nil,
  LevelLastTime = nil,
  TypeList = {
    NotEnabled = 1,
    Enabled = 2,
    Lock = 3
  }
}

function DataModel:Init(initParams)
  if initParams ~= nil then
    local data = Json.decode(initParams)
    local activityId = data.activityId
    local ca = PlayerData:GetFactoryData(activityId)
    local rogueId = ca.rogueId
    if rogueId == nil or rogueId <= 0 then
      rogueId = 89400002
    end
    if PlayerData.TempCache.RogueCache == nil then
      PlayerData.TempCache.RogueCache = {}
    end
    PlayerData.TempCache.RogueCache.cubeId = rogueId
    DataModel.activityId = activityId
    DataModel.activityCA = PlayerData:GetFactoryData(activityId)
    DataModel.isAdd = PlayerData:GetActivityAct(DataModel.activityId)
  end
end

function DataModel:QuestIsFinish(questId)
  if questId == nil then
    return false
  end
  local type = PlayerData.GetQuestState(questId)
  if type == EnumDefine.EQuestState.UnFinish or type == EnumDefine.EQuestState.Lock then
    return false
  end
  return true
end

function DataModel.GetRedState(activityId)
  if activityId == nil then
    return false
  end
  local activityCA = PlayerData:GetFactoryData(activityId)
  if activityCA.questId ~= "" then
    local type = PlayerData.GetQuestState(activityCA.questId)
    if type ~= EnumDefine.EQuestState.Finish and type ~= EnumDefine.EQuestState.Receive then
      return false
    end
  end
  if TimeUtil:IsActive(activityCA.startTime, activityCA.endTime) and PlayerData.ServerData.all_activities.ing and PlayerData.ServerData.all_activities.ing[tostring(activityId)] == nil then
    return true
  end
  if CubeRogueOverviewDataModel.GetAllRedPoint() == true then
    return true
  end
  return false
end

return DataModel
