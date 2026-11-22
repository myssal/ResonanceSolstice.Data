local View = require("UIToWitchHouse/UIToWitchHouseView")
local DataModel = require("UIToWitchHouse/UIToWitchHouseDataModel")
local ViewFunction = {
  ToWitchHouse_Btn_Close_Click = function(btn, str)
    local UIWitchMainDataModel = require("UIWitchMain/UIWitchMainDataModel")
    if WitchData.GetStamina() < UIWitchMainDataModel.move_consume then
      UIManager:Open(WitchData.GetUIPath("UI/Witches/Main/MainFinish"), Json.encode({showTempLeft = 0, showRevive = 1}))
      return
    end
    UIManager:ClosePanel()
    local witchDataController = require("UIWitchMain/UIWitchMainDataController")
    witchDataController:ReqMoveForWitchHouse()
  end
}
return ViewFunction
