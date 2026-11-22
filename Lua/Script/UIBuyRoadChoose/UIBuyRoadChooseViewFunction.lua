local View = require("UIBuyRoadChoose/UIBuyRoadChooseView")
local DataModel = require("UIBuyRoadChoose/UIBuyRoadChooseDataModel")
local ViewFunction = {
  BuyRoadChoose_Btn_BG_Click = function(btn, str)
    UIManager:CloseTip("UI/MainUI/BuyRoadChoose")
  end,
  BuyRoadChoose_Group_BuyRoad_Group_Choose1_Btn_Bg_Click = function(btn, str)
    local nowGold = PlayerData:GetUserInfo().gold
    if nowGold < DataModel.needGold then
      CommonTips.OpenTips(80600260)
      return
    end
    BugLogReporter:AddKeyValueTail(BugLogReporter.ReportNames.TrainLineEvents, "\232\175\183\230\177\130\228\185\176\232\183\1751", DataModel.TrainEventId)
    Net:SendProto("events.money_through", function(json)
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
        mainController.ShowStrikeTip(false, false)
        mainController:ShowMBDurability(false)
        local curID = BugLogReporter.GetCurEventID()
        BugLogReporter:AddKeyValueTail(BugLogReporter.ReportNames.TrainLineEvents, "\228\185\176\232\183\1751Remove", curID)
        local cityID
        local innerTrainMa = CS.FRef.getProperty(TrainManager, "InternalTrainManager")
        if innerTrainMa and innerTrainMa.PathInfos and innerTrainMa.PathInfos[innerTrainMa.InnerPathIndex] then
          cityID = innerTrainMa.PathInfos[innerTrainMa.InnerPathIndex].targetId
        end
        if curID ~= "nil" and cityID then
          PlayerData.RemoveLineEvent(cityID, curID)
        end
        TrainManager:LevelEventFinish()
        UIManager:Open("UI/MainUI/BuyRoad_Success")
        mainController.MainLineEventShow(DataModel.TrainEventId, false)
        mainView.self:PlayAnimOnce("BattleEnd", function()
          mainController.SetCamera(1)
          mainController:RunBtnState(true)
          mainController.BackShow(true)
          tradeDataModel.StateEnter = EnumDefine.TrainStateEnter.Refresh
          mainController:ShowPosterGirl(PlayerData.showPosterGirl == 1, PlayerData.TempCache.MainUIShowState == mainDataModel.UIShowEnum.Adjutant)
        end)
      end)
    end, DataModel.TrainEventId)
    UIManager:CloseTip("UI/MainUI/BuyRoadChoose")
  end,
  BuyRoadChoose_Group_BuyRoad_Group_Choose2_Btn_Bg_Click = function(btn, str)
  end
}
return ViewFunction
