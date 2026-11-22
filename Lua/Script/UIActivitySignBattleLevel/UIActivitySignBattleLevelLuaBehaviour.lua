local View = require("UIActivitySignBattleLevel/UIActivitySignBattleLevelView")
local DataModel = require("UIActivitySignBattleLevel/UIActivitySignBattleLevelDataModel")
local ViewFunction = require("UIActivitySignBattleLevel/UIActivitySignBattleLevelViewFunction")
local Luabehaviour = {
  serialize = function()
    return Json.encode(DataModel.initParams)
  end,
  deserialize = function(initParams)
    DataModel.initParams = Json.decode(initParams)
    DataModel.activityId = DataModel.initParams.activityId
    DataModel:Init()
    View.Group_Main.Group_Reward.Btn_Reward.Img_On:SetActive(false)
    View.Group_Main.Group_Reward.Btn_Reward.Img_Mask:SetActive(false)
    View.Group_Main.Btn_Start.Txt_Time:SetText("")
    Net:SendProto("activity.get_cs_activity", function(json)
      DataModel:SetSignBattleData(json)
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
      if state == DataModel.BtnEnm.unFinish then
        View.Group_Main.Group_Reward.Btn_Reward.Txt_T:SetText(GetText(80610023))
      elseif state == DataModel.BtnEnm.finish then
        View.Group_Main.Group_Reward.Btn_Reward.Txt_T:SetText(GetText(80610024))
      end
    end)
  end,
  awake = function()
  end,
  start = function()
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
