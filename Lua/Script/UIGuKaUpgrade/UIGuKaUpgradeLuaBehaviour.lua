local View = require("UIGuKaUpgrade/UIGuKaUpgradeView")
local DataModel = require("UIGuKaUpgrade/UIGuKaUpgradeDataModel")
local ViewFunction = require("UIGuKaUpgrade/UIGuKaUpgradeViewFunction")
local Controller = require("UIGuKaUpgrade/UIGuKaUpgradeController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if table.count(WitchData.GetUpgradeGuKaList()) <= 0 then
      UIManager:GoBack()
      return
    end
    Controller:Init()
    local DataController = require("UIWitchMain/UIWitchMainDataController")
    DataController:SetCameraActive(false)
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
    local DataController = require("UIWitchMain/UIWitchMainDataController")
    DataController:SetCameraActive(true)
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
