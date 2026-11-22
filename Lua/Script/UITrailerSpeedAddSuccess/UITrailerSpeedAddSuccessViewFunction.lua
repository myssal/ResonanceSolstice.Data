local View = require("UITrailerSpeedAddSuccess/UITrailerSpeedAddSuccessView")
local DataModel = require("UITrailerSpeedAddSuccess/UITrailerSpeedAddSuccessDataModel")
local ViewFunction = {
  TrailerSpeedAddSuccess_Btn_Back_Click = function(btn, str)
    local trailerConfig = PlayerData:GetFactoryData(99900060, "ConfigFactory")
    local trailerMaxLv = trailerConfig.trailerMaxLv
    UIManager:GoBack(trailerMaxLv > PlayerData:GetHomeInfo().back_lv)
  end
}
return ViewFunction
