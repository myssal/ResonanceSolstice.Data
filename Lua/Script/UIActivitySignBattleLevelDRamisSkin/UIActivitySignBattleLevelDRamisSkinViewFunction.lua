local View = require("UIActivitySignBattleLevelDRamisSkin/UIActivitySignBattleLevelDRamisSkinView")
local DataModel = require("UIActivitySignBattleLevelDRamisSkin/UIActivitySignBattleLevelDRamisSkinDataModel")
local ActivityMainController = require("UIActivityMain/UIActivityMainController")
local ViewFunction = {
  ActivitySignBattleLevelDRamisSkin_Group_Main_Group_RewardRole_Btn_Reward_Click = function(btn, str)
    if DataModel.rewardState2 ~= DataModel.BtnEnm.finish then
      return
    end
    Net:SendProto("activity.rec_cs_reward", function(json)
      DataModel.rewardState2 = DataModel.BtnEnm.receive
      CommonTips.OpenShowItem(json.reward)
      View.Group_Main.Group_RewardRole.Btn_Reward.Group_On.self:SetActive(false)
      View.Group_Main.Group_RewardRole.Btn_Reward.Group_Got.self:SetActive(true)
      ActivityMainController:RefreshLeftRedState()
    end, DataModel.activityId2)
  end,
  ActivitySignBattleLevelDRamisSkin_Group_Main_Group_RewardSkin_Btn_Reward_Click = function(btn, str)
    if DataModel.rewardState ~= DataModel.BtnEnm.finish then
      return
    end
    Net:SendProto("activity.rec_cs_reward", function(json)
      DataModel.rewardState = DataModel.BtnEnm.receive
      CommonTips.OpenShowItem(json.reward)
      View.Group_Main.Group_RewardSkin.Btn_Reward.Group_On.self:SetActive(false)
      View.Group_Main.Group_RewardSkin.Btn_Reward.Group_Got.self:SetActive(true)
      ActivityMainController:RefreshLeftRedState()
    end, DataModel.activityId)
  end,
  ActivitySignBattleLevelDRamisSkin_Group_Main_Btn_StartRole_Click = function(btn, str)
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
    UIManager:Open("UI/Activity/ActivitySignBattle/SignBattleLevelDRamis", Json.encode({
      activityId = DataModel.activityId2,
      mainActivityId = DataModel.activityId
    }))
  end,
  ActivitySignBattleLevelDRamisSkin_Group_Main_Btn_StartSkin_Click = function(btn, str)
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
    UIManager:Open("UI/Activity/ActivitySignBattle/SignBattleLevelDRamisSkin", Json.encode({
      activityId = DataModel.initParams.activityId
    }))
  end,
  ActivitySignBattleLevelDRamisSkin_Group_Main_Btn_Rank_Click = function(btn, str)
    local t = {}
    t.activityId = DataModel.activityId2
    UIManager:Open("UI/Activity/ActivitySignBattle/ActivitySignBattleRanking", Json.encode(t))
  end,
  ActivitySignBattleLevelDRamisSkin_Group_Main_Btn_Gacha_Click = function(btn, str)
    local t = {}
    t.poolId = DataModel.activityCA2.signBattleExtract
    UIManager:Open("UI/Gacha/GachaNew", Json.encode(t))
  end,
  ActivitySignBattleLevelDRamisSkin_Group_Main_Btn_Video_Click = function(btn, str)
    local path = DataModel.activityCA.videoHttp
    if path and path ~= "" then
      CS.UnityEngine.Application.OpenURL(path)
    end
  end
}
return ViewFunction
