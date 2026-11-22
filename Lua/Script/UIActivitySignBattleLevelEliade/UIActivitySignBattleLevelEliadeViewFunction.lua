local View = require("UIActivitySignBattleLevelEliade/UIActivitySignBattleLevelEliadeView")
local ActivityMainController = require("UIActivityMain/UIActivityMainController")
local DataModel = require("UIActivitySignBattleLevelEliade/UIActivitySignBattleLevelEliadeDataModel")
local BtnItem = require("Common/BtnItem")
local ViewFunction = {
  ActivitySignBattleLevelEliade_Group_Main_Btn_Start_Click = function(btn, str)
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
    UIManager:Open("UI/Activity/ActivitySignBattle/SignBattleLevelEliade", Json.encode({
      activityId = DataModel.initParams.activityId
    }))
  end,
  ActivitySignBattleLevelEliade_Group_Main_Group_Reward_Btn_Reward_Click = function(btn, str)
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
  ActivitySignBattleLevelEliade_Group_Main_Btn_Video_Click = function(btn, str)
  end,
  ActivitySignBattleLevelEliade_Group_Main_Btn_Rank_Click = function(btn, str)
    local t = {}
    t.activityId = DataModel.activityId
    UIManager:Open("UI/Activity/ActivitySignBattle/ActivitySignBattleRanking", Json.encode(t))
  end,
  ActivitySignBattleLevelEliade_Group_Main_Btn_Gacha_Click = function(btn, str)
    if TimeUtil:IsActive(DataModel.activityCA.startTime, DataModel.activityCA.endTime) then
      local t = {}
      t.poolId = 80500225
      UIManager:Open("UI/Gacha/GachaNew", Json.encode(t))
    end
  end
}
return ViewFunction
