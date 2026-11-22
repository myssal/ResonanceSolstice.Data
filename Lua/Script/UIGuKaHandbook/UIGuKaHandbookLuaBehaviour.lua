local View = require("UIGuKaHandbook/UIGuKaHandbookView")
local DataModel = require("UIGuKaHandbook/UIGuKaHandbookDataModel")
local ViewFunction = require("UIGuKaHandbook/UIGuKaHandbookViewFunction")
local Controller = require("UIGuKaHandbook/UIGuKaHandbookController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.SetJsonData(initParams)
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
