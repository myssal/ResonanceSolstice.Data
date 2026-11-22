local View = require("UITrailerSpeedAddSuccess/UITrailerSpeedAddSuccessView")
local DataModel = require("UITrailerSpeedAddSuccess/UITrailerSpeedAddSuccessDataModel")
local ViewFunction = require("UITrailerSpeedAddSuccess/UITrailerSpeedAddSuccessViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local trailerLv = PlayerData:GetHomeInfo().back_lv
    View.Txt_LevelPre:SetText(trailerLv - 1)
    View.Txt_Level:SetText(trailerLv)
    View.self:PlayAnimOnce("TrailerSpeedAddSuccess", function()
      local trailerConfig = PlayerData:GetFactoryData(99900060, "ConfigFactory")
      local trailerMaxLv = trailerConfig.trailerMaxLv
      UIManager:GoBack(trailerMaxLv > PlayerData:GetHomeInfo().back_lv)
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
