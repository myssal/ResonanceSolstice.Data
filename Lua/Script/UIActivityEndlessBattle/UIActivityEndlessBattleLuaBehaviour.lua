local View = require("UIActivityEndlessBattle/UIActivityEndlessBattleView")
local DataModel = require("UIActivityEndlessBattle/UIActivityEndlessBattleDataModel")
local ViewFunction = require("UIActivityEndlessBattle/UIActivityEndlessBattleViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local data = Json.decode(initParams)
      DataModel.activityId = data.activityId
    end
    DataModel.user_endless = nil
    local activityCA = PlayerData:GetFactoryData(DataModel.activityId)
    local rewardList = activityCA.rewardPreviewList
    View.Group_Main.Group_Preview.ScrollGrid_Reward.grid.self:SetDataCount(#rewardList)
    View.Group_Main.Group_Preview.ScrollGrid_Reward.grid.self:RefreshAllElement()
    View.Group_Main.Group_Preview.ScrollGrid_Reward.grid.self:MoveToTop()
    View.Group_Main.Group_Time.Txt_Time:SetText(string.format(GetText(80610580), activityCA.endTime))
    View.Group_Main.Group_CommomBottomLeft.Group_Score.Txt_Num:SetText(0)
    if activityCA.endlessBattleLv > PlayerData:GetUserInfo().lv then
      View.Group_Main.Btn_Start:SetActive(false)
      View.Group_Main.Group_Lv:SetActive(true)
      View.Group_Main.Group_Lv.Txt_Num:SetText(activityCA.endlessBattleLv)
    else
      View.Group_Main.Btn_Start:SetActive(true)
      View.Group_Main.Group_Lv:SetActive(false)
      if TimeUtil:IsActive(activityCA.startTime, activityCA.endTime) then
        Net:SendProto("endless.activity_main", function(json)
          DataModel.user_endless = json.user_endless
          View.Group_Main.Group_CommomBottomLeft.Group_Score.Txt_Num:SetText(DataModel.user_endless.coin or 0)
          local coinCA = PlayerData:GetFactoryData(activityCA.endlessBattleCoinId)
          View.Group_Main.Group_CommomBottomLeft.Group_Score.Img_Icon:SetSprite(coinCA.iconPath)
        end, DataModel.activityId)
      else
        View.Group_Main.Btn_Start:SetActive(false)
        CommonTips.OpenTips(80609542)
      end
    end
    local powerRoleList = activityCA.powerRoleList
    DataModel.powerRoleList = powerRoleList
    View.Group_Main.Group_PowerRole.StaticGrid_RoleList.grid.self:SetDataCount(#powerRoleList)
    View.Group_Main.Group_PowerRole.StaticGrid_RoleList.grid.self:RefreshAllElement()
    View.Group_Main.Group_PowerRole.Group_Help:SetActive(false)
    DataModel.isHelpOpen = false
    View.Group_Main.Group_PowerRole.Group_Help.Txt_D:SetText(string.format(GetText(80610693), activityCA.powerLv))
    View.Group_Bg.Img_Logo:SetSprite(GetResPath(88300246))
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
