local View = require("UIActivitySignBattleLevelWensheng/UIActivitySignBattleLevelWenshengView")
local DataModel = require("UIActivitySignBattleLevelWensheng/UIActivitySignBattleLevelWenshengDataModel")
local ViewFunction = require("UIActivitySignBattleLevelWensheng/UIActivitySignBattleLevelWenshengViewFunction")
local Luabehaviour = {
  serialize = function()
    return Json.encode(DataModel.initParams)
  end,
  deserialize = function(initParams)
    DataModel.initParams = Json.decode(initParams)
    DataModel.activityId = DataModel.initParams.activityId
    DataModel.eventId = DataModel.initParams.eventId
    DataModel.isBattleReturn = DataModel.initParams.isBattleReturn
    DataModel:Init()
    View.Group_Main.Group_Reward.Btn_Reward.Img_On:SetActive(false)
    View.Group_Main.Group_Reward.Btn_Reward.Img_Mask:SetActive(false)
    View.Group_Main.Btn_Start.Txt_Time:SetText("")
    View.Group_Bg.Img_Logo:SetSprite(GetResPath(88300166))
    Net:SendProto("activity.get_cs_activity", function(json)
      DataModel:SetSignBattleData(json)
      View.Group_Main.Group_Reward.Btn_Reward.Group_Text.StaticGrid_Progress.grid.self:RefreshAllElement()
      local state = DataModel:GetRewardButtonIsActive()
      if DataModel.signBattleData[tostring(DataModel.activityCA.id)] then
        local end_ts = DataModel.signBattleData[tostring(DataModel.activityCA.id)].end_ts
        DataModel.end_Ts = end_ts
        local time = TimeUtil:GetNewTimeTable(end_ts)
        local show_time = time.month .. "/" .. time.day .. " " .. time.hour .. ":" .. time.min
        View.Group_Main.Btn_Start.Txt_Time:SetText(string.format(GetText(80610042), tostring(show_time)))
      end
      View.Group_Main.Group_Reward.Btn_Reward.Img_On:SetActive(state == DataModel.BtnEnm.finish)
      View.Group_Main.Group_Reward.Btn_Reward.Img_Mask:SetActive(state == DataModel.BtnEnm.receive)
      View.Group_Main.Group_Reward.Btn_Reward.Group_Text.StaticGrid_Progress.self:SetActive(state == DataModel.BtnEnm.unFinish)
      if state == DataModel.BtnEnm.unFinish then
        View.Group_Main.Group_Reward.Btn_Reward.Txt_T:SetText(GetText(80610023))
      elseif state == DataModel.BtnEnm.finish then
        View.Group_Main.Group_Reward.Btn_Reward.Txt_T:SetText(GetText(80610024))
      elseif state == DataModel.BtnEnm.receive then
        View.Group_Main.Group_Reward.Btn_Reward.Txt_T:SetText(GetText(80610513))
      end
    end)
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
  end,
  update = function()
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
