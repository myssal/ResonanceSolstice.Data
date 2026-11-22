local View = require("UIActivitySignBattleLevelChloe/UIActivitySignBattleLevelChloeView")
local ActivityMainController = require("UIActivityMain/UIActivityMainController")
local DataModel = require("UIActivitySignBattleLevelChloe/UIActivitySignBattleLevelChloeDataModel")
local BtnItem = require("Common/BtnItem")
local ViewFunction = {
  ActivitySignBattleLevelChloe_Group_Main_Btn_Start_Click = function(btn, str)
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
    UIManager:Open("UI/Activity/ActivitySignBattle/SignBattleLevelChloe", Json.encode({
      activityId = DataModel.initParams.activityId
    }))
  end,
  ActivitySignBattleLevelChloe_Group_Main_Group_Reward_Btn_Reward_Click = function(btn, str)
    if DataModel.rewardState ~= DataModel.BtnEnm.finish then
      return
    end
    Net:SendProto("activity.rec_cs_reward", function(json)
      DataModel.rewardState = DataModel.BtnEnm.receive
      CommonTips.OpenShowItem(json.reward)
      local state = DataModel:GetRewardButtonIsActive()
      View.Group_Main.Group_Reward.Btn_Reward.Group_On.self:SetActive(state == DataModel.BtnEnm.finish)
      View.Group_Main.Group_Reward.Btn_Reward.Group_Got.self:SetActive(state == DataModel.BtnEnm.receive)
      ActivityMainController:RefreshLeftRedState()
    end, DataModel.activityCA.id)
  end,
  ActivitySignBattleLevelChloe_Group_Main_Btn_Video_Click = function(btn, str)
    UIManager:Open("UI/Activity/ActivitySignBattle/SignBattleTipChloe")
  end,
  ActivitySignBattleLevelChloe_Group_Main_Btn_Gacha_Click = function(btn, str)
    local t = {}
    t.poolId = 80500174
    UIManager:Open("UI/Gacha/GachaNew", Json.encode(t))
  end,
  ActivitySignBattleLevelChloe_Group_Main_Group_Preview_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local data = DataModel.previewRewardList[elementIndex]
    BtnItem:SetActivityPreviewItem(element.Group_Item, data)
    element.Group_Item.Btn_Item:SetClickParam(data.id)
  end,
  ActivitySignBattleLevelChloe_Group_Main_Group_Preview_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(str)
  end,
  ActivitySignBattleLevelChloe_Group_Bg_Video_Main_Skip_Click = function(btn, str)
  end,
  ActivitySignBattleLevelChloe_Group_Main_Btn_Rank_Click = function(btn, str)
    local t = {}
    t.activityId = DataModel.activityId
    UIManager:Open("UI/Activity/ActivitySignBattle/ActivitySignBattleRanking", Json.encode(t))
  end
}
return ViewFunction
