local View = require("UIActivitySignBattleLevelLivia/UIActivitySignBattleLevelLiviaView")
local ActivityMainController = require("UIActivityMain/UIActivityMainController")
local DataModel = require("UIActivitySignBattleLevelLivia/UIActivitySignBattleLevelLiviaDataModel")
local ViewFunction = {
  ActivitySignBattleLevelLivia_Group_Main_Btn_Start_Click = function(btn, str)
    if DataModel.end_Ts and TimeUtil:GetServerTimeStamp() >= os.time(TimeUtil:GetNewTimeTable(DataModel.end_Ts)) then
      return
    end
    UIManager:Open("UI/Activity/ActivitySignBattle/SignBattleLevelLivia", Json.encode({
      activityId = DataModel.initParams.activityId
    }))
  end,
  ActivitySignBattleLevelLivia_Group_Main_Group_Reward_Btn_Reward_Click = function(btn, str)
    if DataModel:GetRewardButtonIsActive() ~= DataModel.BtnEnm.finish then
      return
    end
    Net:SendProto("activity.rec_cs_reward", function(json)
      CommonTips.OpenShowItem(json.reward)
      local state = DataModel:GetRewardButtonIsActive()
      View.Group_Main.Group_Reward.Btn_Reward.Img_On:SetActive(state == DataModel.BtnEnm.finish)
      View.Group_Main.Group_Reward.Btn_Reward.Img_Mask:SetActive(state == DataModel.BtnEnm.receive)
      if state == DataModel.BtnEnm.unFinish then
        View.Group_Main.Group_Reward.Btn_Reward.Txt_T:SetText(GetText(80610023))
      elseif state == DataModel.BtnEnm.finish then
        View.Group_Main.Group_Reward.Btn_Reward.Txt_T:SetText(GetText(80610024))
      end
      ActivityMainController:RefreshLeftRedState()
    end, DataModel.activityCA.id)
  end
}
return ViewFunction
