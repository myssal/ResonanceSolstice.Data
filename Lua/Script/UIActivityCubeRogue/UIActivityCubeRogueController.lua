local CommonItem = require("Common/BtnItem")
local View = require("UIActivityCubeRogue/UIActivityCubeRogueView")
local DataModel = require("UIActivityCubeRogue/UIActivityCubeRogueDataModel")
local WeeklyRewardsDataModel = require("UIWeeklyRewards/UIWeeklyRewardsDataModel")
local CommonRewardsDataModel = require("UICommonRewards/UICommonRewardsDataModel")
local CubeRogueOverviewDataModel = require("UICubeRogueOverview/UICubeRogueOverviewDataModel")
local Controller = {}

function Controller:Init(initParams)
  DataModel:Init(initParams)
  View.Group_Join.self:SetActive(DataModel.isAdd)
  View.Group_NotJoin.self:SetActive(not DataModel.isAdd)
  View.Img_Title:SetSprite(PlayerData:GetFactoryData(88300179).filePath)
  if DataModel.activityCA.rewardPreviewList and table.count(DataModel.activityCA.rewardPreviewList) > 0 then
    DataModel.RewardList = {}
    for k, v in pairs(DataModel.activityCA.rewardPreviewList) do
      table.insert(DataModel.RewardList, v)
    end
    View.Group_Preview.self:SetActive(true)
    View.Group_Preview.ScrollGrid_Reward.grid.self:SetDataCount(table.count(DataModel.RewardList))
    View.Group_Preview.ScrollGrid_Reward.grid.self:RefreshAllElement()
  end
  if not DataModel.isAdd then
    View.Group_NotJoin.Group_Pre.self:SetActive(false)
    View.Group_NotJoin.Group_Cannot.self:SetActive(true)
    View.Group_NotJoin.Group_Can.self:SetActive(false)
    if DataModel.activityCA.questId ~= -1 and DataModel:QuestIsFinish(DataModel.activityCA.questId) == false then
      DataModel.ConstructionType = DataModel.TypeList.Lock
      View.Group_NotJoin.Group_Pre.self:SetActive(true)
      local questCA = PlayerData:GetFactoryData(DataModel.activityCA.questId)
      View.Group_NotJoin.Group_Pre.Txt_PreCondition:SetText(string.format(GetText(DataModel.activityCA.unlockTips), questCA.name))
      return
    end
    View.Group_NotJoin.Group_Cannot.self:SetActive(false)
    View.Group_NotJoin.Group_Can.self:SetActive(true)
    DataModel.ConstructionType = DataModel.TypeList.NotEnabled
  else
    Net:SendProto("cube.info", function(json)
      PlayerData.TempCache.CubeRogueData = json.cube
      PlayerData.TempCache.CubeRogueData.reward = json.reward
      Controller:RefreshJoinPage()
    end)
  end
end

function Controller:RefreshJoinPage()
  View.Group_Join.self:SetActive(true)
  View.Group_NotJoin.self:SetActive(false)
  Controller:RefreshWeeklyRewards()
  Controller:RefreshCommonRewards()
  View.Group_Join.Group_Enter.Group_RedPoint.self:SetActive(CubeRogueOverviewDataModel.GetAllRedPoint())
end

function Controller:RefreshWeeklyRewards()
  View.Group_Join.Group_WeeklyRewards.Group_Num.Txt_Current:SetText(tostring(WeeklyRewardsDataModel.GetCurScore()))
  View.Group_Join.Group_WeeklyRewards.Group_Num.Txt_All:SetText(tostring(WeeklyRewardsDataModel.GetLimitScore()))
  local remainTime = TimeUtil:GetNextWeekTime(1, 5) - TimeUtil:GetServerTimeStamp()
  if remainTime <= 0 then
    WeeklyRewardsDataModel.SetRewardHasGetIndex(-1)
    WeeklyRewardsDataModel.ResetCurScore()
  end
  DataModel.weeklyRewardTime = remainTime
  if 0 < remainTime then
    Controller.RefreshWeeklyRewardsTime()
  end
  View.Group_Join.Group_WeeklyRewards.Group_RedPoint.self:SetActive(WeeklyRewardsDataModel.GetRedDotStatus())
end

function Controller.RefreshWeeklyRewardsTime()
  local dayList = TimeUtil:SecondToTable(DataModel.weeklyRewardTime)
  if dayList.day > 0 then
    View.Group_Join.Group_WeeklyRewards.Txt_Time:SetText(string.format(GetText(80610640), dayList.day, dayList.hour))
  else
    View.Group_Join.Group_WeeklyRewards.Txt_Time:SetText(string.format(GetText(80610674), dayList.hour, dayList.minute))
  end
end

function Controller:RefreshCommonRewards()
  CubeRogueOverviewDataModel.SetLevelStageListStartTime()
  DataModel.commonRewardTime = CubeRogueOverviewDataModel.diffTime
  View.Group_Join.Group_CommonRewards.Txt_Time:SetActive(DataModel.commonRewardTime and DataModel.commonRewardTime > 0)
  if DataModel.commonRewardTime and DataModel.commonRewardTime > 0 then
    Controller:RefreshCommonRewardsTime()
  end
  View.Group_Join.Group_CommonRewards.Txt_Level:SetText(CommonRewardsDataModel.GetCubeRewardLv())
  View.Group_Join.Group_CommonRewards.Group_RedPoint.self:SetActive(CommonRewardsDataModel.GetRedDotStatus())
end

function Controller.RefreshCommonRewardsTime()
  local diffTime = TimeUtil:SecondToTable(DataModel.commonRewardTime)
  if diffTime.day > 0 then
    View.Group_Join.Group_CommonRewards.Txt_Time:SetText(string.format(GetText(80610642), diffTime.day, diffTime.hour))
  else
    View.Group_Join.Group_CommonRewards.Txt_Time:SetText(string.format(GetText(80610673), diffTime.hour, diffTime.minute))
  end
end

function Controller:RewardSetElemnt(element, elementIndex)
  local row = DataModel.RewardList[elementIndex]
  CommonItem:SetActivityPreviewItem(element.Group_Item, row)
  element.Group_Item.Btn_Item:SetClickParam(row.id)
end

function Controller:RewardClickElemnt(id)
  CommonTips.OpenPreRewardDetailTips(id)
end

function Controller:AddActivity()
  if DataModel.ConstructionType == DataModel.TypeList.Lock then
    CommonTips.OpenTips(80602587)
  end
  if TimeUtil:IsActive(DataModel.activityCA.startTime, DataModel.activityCA.endTime) == false then
    return
  end
  if DataModel.ConstructionType == DataModel.TypeList.NotEnabled then
    local function callBack()
      Net:SendProto("main.participate", function(Jsons)
        if Jsons.activity then
          PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityCA.id)] = Jsons.activity
        end
        DataModel.isAdd = true
        Controller:RefreshJoinPage()
      end, DataModel.activityCA.id)
    end
    
    if DataModel.activityCA.joinPlotId and DataModel.activityCA.joinPlotId ~= "" then
      UIManager:Open("UI/Dialog/Dialog", Json.encode({
        id = DataModel.activityCA.joinPlotId
      }), callBack, callBack)
    end
  end
end

return Controller
