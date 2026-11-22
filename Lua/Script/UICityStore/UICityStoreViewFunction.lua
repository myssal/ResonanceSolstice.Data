local View = require("UICityStore/UICityStoreView")
local DataModel = require("UICityStore/UICityStoreDataModel")
local ViewFunction = {
  CityStore_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if DataModel.forbidReturn == true then
      return
    end
    HomeStationStoreManager:QuitStationStore()
    TrainCameraManager:OpenCamera(-1)
    UIManager:GoBack()
    DataModel.CloseStore()
  end,
  CityStore_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    if DataModel.forbidReturn == true then
      return
    end
    HomeStationStoreManager:QuitStationStore()
    DataModel.CloseStore()
    local TradeDataModel = require("UIHome/UIHomeTradeDataModel")
    if TradeDataModel.GetInTravel() and DataModel.PlaceId == "81500008" and MapSessionManager.currentSession then
      MapSessionManager:GobackToMainScene()
    else
      UIManager:GoHome()
    end
  end,
  CityStore_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  CityStore_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    local data = {helpId = 80301262}
    UIManager:Open("UI/Common/Group_Help", Json.encode(data))
  end
}
return ViewFunction
