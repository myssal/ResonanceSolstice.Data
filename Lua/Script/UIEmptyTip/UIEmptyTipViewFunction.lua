local View = require("UIEmptyTip/UIEmptyTipView")
local DataModel = require("UIEmptyTip/UIEmptyTipDataModel")
local Controller = require("UIEmptyTip/UIEmptyTipController")
local HomeMapController = require("UIHome/UIHomeMapController")
local MainDataModel = require("UIMainUI/UIMainUIDataModel")
local ViewFunction = {
  EmptyTip_Btn_BG_Click = function(btn, str)
    View.self:PlayAnimOnce("Animation_out", function()
      View.self:SetEnableAnimator(false)
      View.self:SetAlpha(1)
      UIManager:CloseTip("UI/MainUI/EmptyTip")
    end)
    MainDataModel.isGoMapStation = nil
    MainDataModel.initMapStation = nil
    Controller:SaveCheckType()
    HomeMapController:RefreshEmptyTip()
  end,
  EmptyTip_Group_DayTip_Btn_Tip_Click = function(btn, str)
    Controller:SetCheckTip(not DataModel.CheckTip)
  end,
  EmptyTip_Group_WeekTip_Btn_Tip_Click = function(btn, str)
    Controller:SetCheckWeekTip(not DataModel.CheckWeekTip)
  end,
  EmptyTip_Group_Btn_Btn_Trade_Click = function(btn, str)
    if not DataModel.hasLoadageEmpty then
      return
    end
    local homeCommon = require("Common/HomeCommon")
    local station_info = PlayerData:GetHomeInfo().station_info
    if station_info.status == -1 then
      local cityMapId = homeCommon.GetCityStateInfo(station_info.sid).cityMapId
      local bubbleList = PlayerData:GetFactoryData(cityMapId).bubbleList
      for i = 1, #bubbleList do
        local ca = PlayerData:GetFactoryData(bubbleList[i].id)
        if ca.btnType == "HomeTrade" then
          require("UICityMap/UICityMapDataModel").stationId = station_info.sid
          require("UICityMap/UICityMapController"):ClickBtn(nil, {
            bubbleId = bubbleList[i].id
          })
          Controller:SaveCheckType()
        end
      end
    end
  end,
  EmptyTip_Group_Btn_Btn_Passenger_Click = function(btn, str)
    local isPassengerMaskShow = not DataModel.hasPassengerEmpty
    if isPassengerMaskShow then
      return
    end
    local station_info = PlayerData:GetHomeInfo().station_info
    if station_info.status == -1 then
      local vf = require("UIPassageTrafficRank/UIPassageTrafficRankViewFunction")
      vf:PassageTrafficRank_Btn_ZhaoLan_Click()
      Controller:SaveCheckType()
    end
  end,
  EmptyTip_Group_Btn_Btn_Quest_Click = function(btn, str)
    local homeCommon = require("Common/HomeCommon")
    local station_info = PlayerData:GetHomeInfo().station_info
    if station_info.status == -1 then
      local cityMapId = homeCommon.GetCityStateInfo(station_info.sid).cityMapId
      local bubbleList = PlayerData:GetFactoryData(cityMapId).bubbleList
      for i = 1, #bubbleList do
        local ca = PlayerData:GetFactoryData(bubbleList[i].id)
        if ca.btnType == "HomeCOC" then
          require("UICityMap/UICityMapDataModel").stationId = station_info.sid
          require("UICityMap/UICityMapController"):ClickBtn(nil, {
            bubbleId = bubbleList[i].id
          })
          Controller:SaveCheckType()
        end
      end
    end
  end,
  EmptyTip_Btn_Go_Click = function(btn, str)
    UIManager:CloseTip("UI/MainUI/EmptyTip")
    if DataModel.CheckWeekTip == true then
      PlayerData:SetNoPrompt("EmptyTip", 2, DataModel.CheckWeekTip)
      PlayerData:SetPlayerPrefs("int", "EmptyTipCheckParam", 2)
    else
      PlayerData:SetNoPrompt("EmptyTip", 1, DataModel.CheckTip)
      PlayerData:SetPlayerPrefs("int", "EmptyTipCheckParam", DataModel.CheckTip and 1 or 0)
    end
    PlayerData:SetPlayerPrefs("int", "EmptyTipCheckType", 0)
    View.self:Confirm()
  end,
  EmptyTip_Group_Btn_Btn_Trade_Btn_Check_Click = function(btn, str)
    local isJudge = not DataModel.isTradeJudge
    Controller:SetTradeJudge(isJudge)
    PlayerData:SetPlayerPrefs("int", "isIgnoreTradeEmpty", isJudge and 0 or 1)
  end,
  EmptyTip_Group_Btn_Btn_Passenger_Btn_Check_Click = function(btn, str)
    local isJudge = not DataModel.isPassengerJudge
    Controller:SetPassengerJudge(isJudge)
    PlayerData:SetPlayerPrefs("int", "isIgnorePassengerEmpty", isJudge and 0 or 1)
  end
}
return ViewFunction
