local View = require("UIActivitySignBattleLevelWensheng/UIActivitySignBattleLevelWenshengView")
local DataModel = require("UIActivitySignBattleLevelWensheng/UIActivitySignBattleLevelWenshengDataModel")
local ActivityMainController = require("UIActivityMain/UIActivityMainController")
local ViewFunction = {
  ActivitySignBattleLevelWensheng_Group_Main_Btn_Start_Click = function(btn, str)
    if DataModel.end_Ts and TimeUtil:GetServerTimeStamp() >= os.time(TimeUtil:GetNewTimeTable(DataModel.end_Ts)) then
      return
    end
    UIManager:Open("UI/Activity/ActivitySignBattle/SignBattleLevelWensheng", Json.encode({
      activityId = DataModel.activityId,
      eventId = DataModel.eventId
    }))
  end,
  ActivitySignBattleLevelWensheng_Group_Main_Group_Reward_Btn_Reward_Click = function(btn, str)
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
    end, DataModel.activityCA.id)
  end,
  ActivitySignBattleLevelWensheng_Group_Main_Group_Reward_Btn_Reward_Group_Text_StaticGrid_Progress_SetGrid = function(element, elementIndex)
    element.Img_Off:SetActive(elementIndex > DataModel.GetCurrentIndex())
    element.Img_ON:SetActive(elementIndex <= DataModel.GetCurrentIndex())
  end,
  ActivitySignBattleLevelWensheng_Group_CommonTopLeft_Withces_Btn_Return_Click = function(btn, str)
    local gridData = WitchData.GetGridData(WitchData.GetGridId())
    if gridData and gridData.com == 0 and DataModel.eventId then
      WitchData.ReqEndOverEvent(DataModel.eventId)
    end
    View.self:CloseUI()
  end,
  ActivitySignBattleLevelWensheng_Group_CommonTopLeft_Withces_Btn_Help_Click = function(btn, str)
  end
}
return ViewFunction
