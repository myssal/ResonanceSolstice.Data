local CardPackDataModel = require("UICardPack_Open/UICardPack_OpenDataModel")
local IslandTaskDataModel = require("UIIslandTask/UIIslandTaskDataModel")
local DataModel = {
  ChooseLeftIndex = nil,
  ActivityId = nil,
  ActivityCA = {},
  CloseTime = nil,
  RewardList = {},
  IsAdd = false,
  ConstructionType = nil,
  VolleyballType = nil,
  SkipType = nil,
  LevelType = nil,
  LevelLastTime = nil,
  TypeList = {
    NotEnabled = 1,
    Enabled = 2,
    Lock = 3
  },
  BtnTypeList = {
    TimeOut = 1,
    NotFinish = 2,
    Finish = 3
  },
  VolleyballFurniture = nil,
  VolleyballTypeList = {
    TimeOut = 1,
    NotFinishQuest = 2,
    NotHaveFurniture = 3,
    NotArrivedGrade = 4,
    Finish = 5
  }
}

function DataModel:Init(initParams)
  if initParams then
    local parms = Json.decode(initParams)
    DataModel.ActivityId = parms.activityId
    DataModel.CloseTime = parms.closeTime
    DataModel.ChooseLeftIndex = parms.index or 1
    DataModel.ActivityCA = PlayerData:GetFactoryData(DataModel.ActivityId)
    DataModel.IsAdd = PlayerData:GetActivityAct(DataModel.ActivityId)
    DataModel.VolleyballFurniture = nil
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

function DataModel.GetIsLandRedState(activityId)
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
  if activityCA.activityCardPack > -1 then
    DataModel.CardPackInfo = CardPackDataModel.GetCardPackInfo(activityCA.activityCardPack)
    if DataModel.CardPackInfo.extraCardStatus == 1 then
      return true
    end
  end
  if IslandTaskDataModel.IsCanReceive(true, activityCA.correspondingScene) == true then
    return true
  end
  if TimeUtil:IsActive(activityCA.startTime, activityCA.endTime) and PlayerData.ServerData.all_activities.ing and PlayerData.ServerData.all_activities.ing[tostring(activityId)] == nil then
    return true
  end
  return false
end

return DataModel
