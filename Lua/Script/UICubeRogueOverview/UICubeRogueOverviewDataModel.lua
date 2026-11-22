local BookListDataModel = require("UIBookList/UIBookListDataModel")
local CubeSkillDataModel = require("UICubeSkill/UICubeSkillDataModel")
local CommonRewardsDataModel = require("UICommonRewards/UICommonRewardsDataModel")
local WeeklyRewardsDataModel = require("UIWeeklyRewards/UIWeeklyRewardsDataModel")
local CubeRogueMissionDataModel = require("UICubeRogueMission/UICubeRogueMissionDataModel")
local DataModel = {
  configCubeId = 89400002,
  configCubeCA = nil,
  stopTime = nil,
  diffTime = nil,
  weeklyRewardTime = nil,
  cubeId = ""
}

function DataModel.Init(initParams)
  local params = Json.decode(initParams)
  DataModel.activityId = params.activityId
  DataModel.isBattleReturn = params.isBattleReturn
  DataModel.activityCA = PlayerData:GetFactoryData(DataModel.activityId)
  DataModel.SetLevelStageListStartTime()
  DataModel.SetHaveCubeId()
  local remainTime = TimeUtil:GetNextWeekTime(1, 5) - TimeUtil:GetServerTimeStamp()
  if remainTime <= 0 then
    WeeklyRewardsDataModel.SetRewardHasGetIndex(-1)
    WeeklyRewardsDataModel.ResetCurScore()
  end
  DataModel.weeklyRewardTime = remainTime
end

function DataModel.SetLevelStageListStartTime()
  local cubeConfig = PlayerData:GetFactoryData(DataModel.configCubeId, "CubeRogueFactory")
  DataModel.configCubeCA = cubeConfig
  if not cubeConfig or not cubeConfig.commonLevelStageList then
    return
  end
  for i = 1, #cubeConfig.commonLevelStageList do
    local startTime = os.time(TimeUtil:GetNewTimeTable(cubeConfig.commonLevelStageList[i].startTime))
    local stopTime
    if i < #cubeConfig.commonLevelStageList then
      stopTime = os.time(TimeUtil:GetNewTimeTable(cubeConfig.commonLevelStageList[i + 1].startTime))
    end
    if stopTime and startTime <= TimeUtil:GetServerTimeStamp() and stopTime > TimeUtil:GetServerTimeStamp() then
      DataModel.stopTime = stopTime
      DataModel.diffTime = DataModel.stopTime - TimeUtil:GetServerTimeStamp()
      break
    end
  end
end

function DataModel.SetHaveCubeId()
  DataModel.isJoin = false
  if PlayerData.TempCache.CubeRogueData and PlayerData.TempCache.CubeRogueData.cube_id and PlayerData.TempCache.CubeRogueData.cube_id ~= "" then
    DataModel.isJoin = true
    DataModel.cubeId = PlayerData.TempCache.CubeRogueData.cube_id
  end
end

function DataModel:GetAllRedPoint()
  if CommonRewardsDataModel.GetRedDotStatus() == true then
    return true
  end
  if CubeSkillDataModel.GetRedDotStatus() == true then
    return true
  end
  if BookListDataModel.GetRedDotStatus() == true then
    return true
  end
  if WeeklyRewardsDataModel.GetRedDotStatus() == true then
    return true
  end
  if CubeRogueMissionDataModel.IsShowRed() == true then
    return true
  end
  return false
end

function DataModel:GetEveryRedPoint(name)
  if name == "Group_CommonLevel" then
    return CommonRewardsDataModel.GetRedDotStatus()
  end
  if name == "Group_Book" then
    return BookListDataModel.GetRedDotStatus()
  end
  if name == "Group_WeeklyRewards" then
    return WeeklyRewardsDataModel.GetRedDotStatus()
  end
  if name == "Group_Skill" then
    return CubeSkillDataModel.GetRedDotStatus()
  end
  if name == "Group_Quest" then
    return CubeRogueMissionDataModel.IsShowRed()
  end
  return false
end

return DataModel
