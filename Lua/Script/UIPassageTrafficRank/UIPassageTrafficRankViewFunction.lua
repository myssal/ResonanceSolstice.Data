local View = require("UIPassageTrafficRank/UIPassageTrafficRankView")
local DataModel = require("UIPassageTrafficRank/UIPassageTrafficRankDataModel")
local ViewFunction = {
  PassageTrafficRank_Btn_BG_Click = function(btn, str)
    UIManager:GoBack()
  end,
  PassageTrafficRank_Btn_Passenger_Click = function(btn, str)
    UIManager:Open("UI/Passenger/Passenger")
  end,
  PassageTrafficRank_Btn_Prisoner_Click = function(btn, str)
    local prisonData = PrisonData.GetSeverPrisonData()
    if not prisonData then
      CommonTips.OpenTips(80607925)
      return
    end
    UIManager:Open("UI/Prison/PrisonerList/PrisonerList", Json.encode({Mode = "Coach"}))
  end,
  PassageTrafficRank_Btn_Pet_Click = function(btn, str)
    local mainUIDataModel = require("UIMainUI/UIMainUIDataModel")
    if MainManager.bgSceneName == mainUIDataModel.SceneNameEnum.Home then
      DataModel.ExitTo()
      PlayerData.TempCache.BeginDecorateTimeStamp = TimeUtil:GetServerTimeStamp()
      UIManager:Open("UI/HomePet/PetManage")
    else
      CommonTips.OpenTips(80609031)
    end
  end,
  PassageTrafficRank_Btn_ZhuangBan_Click = function(btn, str)
    local mainUIDataModel = require("UIMainUI/UIMainUIDataModel")
    if MainManager.bgSceneName == mainUIDataModel.SceneNameEnum.Home then
      if CommonTips.GuideAsset() then
        return
      end
      DataModel.ExitTo()
      PlayerData.TempCache.BeginDecorateTimeStamp = TimeUtil:GetServerTimeStamp()
      UIManager:Open("UI/Home/HomeCoach")
    else
      CommonTips.OpenTips(80609031)
    end
  end,
  PassageTrafficRank_Btn_ZhaoLan_Click = function(btn, str)
    local TradeDataModel = require("UIHome/UIHomeTradeDataModel")
    if not PlayerData.IsSolicitFunOpen() then
      CommonTips.OpenFlierConditionTips({
        showType = EnumDefine.FlierConditionShowType.functionLock,
        stationId = TradeDataModel.CurStayCity
      })
      return
    end
    local stationCA = PlayerData:GetFactoryData(TradeDataModel.CurStayCity, "HomeStationFactory")
    if not stationCA.isLeaflet then
      local txtCA = PlayerData:GetFactoryData(80601667, "TextFactory")
      CommonTips.OpenTips(string.format(txtCA.text, stationCA.name))
      return
    end
    Net:SendProto("station.psg_source_info", function(json)
      PlayerData.RefreshSolicitData(json)
      UIManager:Open("UI/Flier/FlierMain", Json.encode({
        StationId = TradeDataModel.CurStayCity
      }))
      DataModel.ExitTo()
    end)
  end,
  PassageTrafficRank_Btn_Help_Click = function(btn, str)
    DataModel.ExitTo()
    local cfg = PlayerData:GetFactoryData(80300339, "ListFactory")
    UIManager:Open("UI/Notebook/NotebookEnter", Json.encode({
      dataTab = cfg.dataTab
    }))
  end,
  PassageTrafficRank_Btn_Rank_Click = function(btn, str)
    local passengerRankList = {
      {id = 84300019}
    }
    UIManager:Open("UI/RankList/RankList", Json.encode({rankList = passengerRankList}))
  end,
  PassageTrafficRank_Group_TopRight_Group_Transport_Btn_Tips_Click = function(btn, str)
    UIManager:Open("UI/MainUI/keyun_guanli/keyun_Lv/TransportLevelTip")
  end,
  PassageTrafficRank_Group_Grade_Group_GradeNum_Group_clean_Btn_Clean_Click = function(btn, str)
    DataModel.refreshNetData = true
    CommonTips.OpenToHomeCarriageeditor()
  end
}
return ViewFunction
