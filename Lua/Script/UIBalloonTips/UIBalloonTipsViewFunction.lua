local DataModel = require("UIBalloonTips/UIBalloonTipsDataModel")
local Controller = require("UIBalloonTips/UIBalloonTipsController")
local ViewFunction = {
  BalloonTips_Btn_BG_Click = function(btn, str)
  end,
  BalloonTips_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  BalloonTips_Btn_Min_Click = function(btn, str)
    DataModel:SetCurrNum(1)
    Controller:RefreshShow(true)
  end,
  BalloonTips_Btn_Dec_Click = function(btn, str)
    DataModel:SetCurrNum(math.max(1, DataModel.CurrNum - 1))
    Controller:RefreshShow(true)
  end,
  BalloonTips_Group_Slider_Slider_Value_Slider = function(slider, value)
    DataModel:SetCurrNum(value)
    Controller:RefreshShow(false)
    DataModel:SetSliderRefreshState(false)
  end,
  BalloonTips_Group_Slider_Slider_Value_SliderDown = function(slider)
  end,
  BalloonTips_Group_Slider_Slider_Value_SliderUp = function(slider)
  end,
  BalloonTips_Btn_Add_Click = function(btn, str)
    DataModel:SetCurrNum(math.min(DataModel.CurrNum + 1, DataModel.MaxNum))
    Controller:RefreshShow(true)
  end,
  BalloonTips_Btn_Max_Click = function(btn, str)
    DataModel:SetCurrNum(DataModel.MaxNum)
    Controller:RefreshShow(true)
  end,
  BalloonTips_Btn_Cancel_Click = function(btn, str)
    UIManager:CloseTip("UI/MainUI/BalloonTips")
  end,
  BalloonTips_Btn_Sale_Click = function(btn, str)
    if DataModel.CanClickBalloon then
      return
    end
    DataModel.CanClickBalloon = 1
    BugLogReporter:AddKeyValueTail(BugLogReporter.ReportNames.TrainLineEvents, "\232\175\183\230\177\130\230\176\148\231\144\131", DataModel.TrainEventId)
    Net:SendProto("events.bait_through", function(json)
      DataModel.CanClickBalloon = nil
      local useItem = {}
      useItem[DataModel.BalloonItemId] = math.floor(DataModel.CurrNum)
      PlayerData:RefreshUseItems(useItem)
      if json.info == 1 then
        PlayerData.TempCache.EventFinish = true
        local mainController = require("UIMainUI/UIMainUIController")
        local mainDataModel = require("UIMainUI/UIMainUIDataModel")
        local mainView = require("UIMainUI/UIMainUIView")
        local tradeDataModel = require("UIHome/UIHomeTradeDataModel")
        TrainManager:ChangeState(TrainState.EventFinish, function()
          mainController.ShowWarning(false)
          mainController:InitCommonShow()
          mainDataModel.SetTrainEventBasicId()
          mainDataModel.SetTrainEventBgmId()
          mainController.PlayTrainBgm()
          local curID = BugLogReporter.GetCurEventID()
          BugLogReporter:AddKeyValueTail(BugLogReporter.ReportNames.TrainLineEvents, "\230\176\148\231\144\131Remove", curID)
          local cityID
          local innerTrainMa = CS.FRef.getProperty(TrainManager, "InternalTrainManager")
          if innerTrainMa and innerTrainMa.PathInfos and innerTrainMa.PathInfos[innerTrainMa.InnerPathIndex] then
            cityID = innerTrainMa.PathInfos[innerTrainMa.InnerPathIndex].targetId
          end
          if curID and cityID then
            PlayerData.RemoveLineEvent(cityID, curID)
          end
          TrainManager:LevelEventFinish()
          mainView.self:PlayAnimOnce("BattleEnd", function()
            local data = {}
            data.isRward = DataModel.IsRward
            UIManager:Open("UI/MainUI/Balloon_Success", Json.encode(data))
            mainController.SetCamera(1)
            mainController:RunBtnState(true)
            mainController.MainLineEventShow(DataModel.TrainEventId, false)
            mainController.BackShow(true)
            tradeDataModel.StateEnter = EnumDefine.TrainStateEnter.Refresh
            mainController:ShowPosterGirl(PlayerData.showPosterGirl == 1, PlayerData.TempCache.MainUIShowState == mainDataModel.UIShowEnum.Adjutant)
          end)
        end)
      else
        CommonTips.OpenTips(80601886)
      end
      if json.reward then
        PlayerData.TempCache.balloonReward = json.reward
      end
      UIManager:CloseTip("UI/MainUI/BalloonChoose")
      UIManager:CloseTip("UI/MainUI/BalloonTips")
    end, function(json)
      DataModel.CanClickBalloon = nil
      local rc = json and tostring(json.rc) or ""
      BugLogReporter:AddTail(BugLogReporter.ReportNames.TrainLineEvents, "\230\176\148\231\144\131Remove\229\164\177\232\180\165 rc:" .. rc)
    end, DataModel.TrainEventId, math.floor(DataModel.CurrNum), DataModel.BalloonItemId)
  end
}
return ViewFunction
