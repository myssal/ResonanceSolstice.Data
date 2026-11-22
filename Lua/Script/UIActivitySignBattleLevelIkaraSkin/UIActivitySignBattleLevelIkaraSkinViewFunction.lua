local View = require("UIActivitySignBattleLevelIkaraSkin/UIActivitySignBattleLevelIkaraSkinView")
local ActivityMainController = require("UIActivityMain/UIActivityMainController")
local DataModel = require("UIActivitySignBattleLevelIkaraSkin/UIActivitySignBattleLevelIkaraSkinDataModel")
local ViewFunction = {
  ActivitySignBattleLevelIkaraSkin_Group_Main_Group_Reward_Btn_Reward_Click = function(btn, str)
    if DataModel:GetRewardButtonIsActive() ~= DataModel.BtnEnm.finish then
      return
    end
    Net:SendProto("activity.rec_cs_reward", function(json)
      CommonTips.OpenShowItem(json.reward)
      local state = DataModel:GetRewardButtonIsActive()
      View.Group_Main.Group_Reward.Btn_Reward.Group_Lock.self:SetActive(false)
      View.Group_Main.Group_Reward.Btn_Reward.Group_On.self:SetActive(false)
      View.Group_Main.Group_Reward.Btn_Reward.Group_Got.self:SetActive(true)
      ActivityMainController:RefreshLeftRedState()
    end, DataModel.activityCA.id)
  end,
  ActivitySignBattleLevelIkaraSkin_Group_Main_Btn_Start_Click = function(btn, str)
    if DataModel.end_Ts and TimeUtil:GetServerTimeStamp() >= os.time(TimeUtil:GetNewTimeTable(DataModel.end_Ts)) then
      return
    end
    UIManager:Open("UI/Activity/ActivitySignBattle/SignBattleLevelIkaraSkin", Json.encode({
      activityId = DataModel.initParams.activityId
    }))
  end
}
return ViewFunction
