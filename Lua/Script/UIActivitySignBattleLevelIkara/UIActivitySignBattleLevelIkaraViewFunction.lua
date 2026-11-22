local View = require("UIActivitySignBattleLevelIkara/UIActivitySignBattleLevelIkaraView")
local ActivityMainController = require("UIActivityMain/UIActivityMainController")
local DataModel = require("UIActivitySignBattleLevelIkara/UIActivitySignBattleLevelIkaraDataModel")
local BtnItem = require("Common/BtnItem")
local ViewFunction = {
  ActivitySignBattleLevelIkara_Group_Main_Btn_Start_Click = function(btn, str)
    if DataModel.end_Ts and TimeUtil:GetServerTimeStamp() >= os.time(TimeUtil:GetNewTimeTable(DataModel.end_Ts)) then
      return
    end
    if DataModel.isQuestFinish == false then
      if DataModel.activityCA.questId ~= -1 then
        local questCA = PlayerData:GetFactoryData(DataModel.activityCA.questId, "QuestFactory")
        CommonTips.OpenTips(string.format(GetText(80611017), questCA.name))
      end
      return
    end
    UIManager:Open("UI/Activity/ActivitySignBattle/SignBattleLevelIkara", Json.encode({
      activityId = DataModel.initParams.activityId
    }))
  end,
  ActivitySignBattleLevelIkara_Group_Main_Group_Reward_Btn_Reward_Click = function(btn, str)
    if DataModel:GetRewardButtonIsActive() ~= DataModel.BtnEnm.finish then
      return
    end
    Net:SendProto("activity.rec_cs_reward", function(json)
      CommonTips.OpenShowItem(json.reward)
      local state = DataModel:GetRewardButtonIsActive()
      View.Group_Main.Group_Reward.Btn_Reward.Group_On.self:SetActive(state == DataModel.BtnEnm.finish)
      View.Group_Main.Group_Reward.Btn_Reward.Group_Got.self:SetActive(state == DataModel.BtnEnm.receive)
      ActivityMainController:RefreshLeftRedState()
    end, DataModel.activityCA.id)
  end,
  ActivitySignBattleLevelIkara_Group_Main_Btn_Video_Click = function(btn, str)
    if TimeUtil:IsActive(DataModel.activityCA.startTime, DataModel.activityCA.endTime) then
      UIManager:Open("UI/Activity/ActivitySignBattle/SignBattleTipIkara")
    end
  end,
  ActivitySignBattleLevelIkara_Group_Main_Btn_Rank_Click = function(btn, str)
    local t = {}
    t.activityId = DataModel.activityId
    UIManager:Open("UI/Activity/ActivitySignBattle/ActivitySignBattleRanking", Json.encode(t))
  end,
  ActivitySignBattleLevelIkara_Group_Main_Btn_Gacha_Click = function(btn, str)
    if TimeUtil:IsActive(DataModel.activityCA.startTime, DataModel.activityCA.endTime) then
      local t = {}
      t.poolId = 80500209
      UIManager:Open("UI/Gacha/GachaNew", Json.encode(t))
    end
  end,
  ActivitySignBattleLevelIkara_Group_Main_Group_Preview_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local data = DataModel.previewRewardList[elementIndex]
    BtnItem:SetActivityPreviewItem(element.Group_Item, data)
    element.Group_Item.Btn_Item:SetClickParam(data.id)
  end,
  ActivitySignBattleLevelIkara_Group_Main_Group_Preview_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(str)
  end
}
return ViewFunction
