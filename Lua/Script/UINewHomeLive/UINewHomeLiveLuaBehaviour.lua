local View = require("UINewHomeLive/UINewHomeLiveView")
local DataModel = require("UINewHomeLive/UINewHomeLiveDataModel")
local ViewFunction = require("UINewHomeLive/UINewHomeLiveViewFunction")
local Controller = require("UINewHomeLive/UINewHomeLiveController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.SetJsonData(initParams)
    DataModel.InitData()
    Controller.RefreshOnShow()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    Controller.RefreshCurFurAutoSleep()
    if not UIManager:IsPanelOpened("UI/MainUI/MainUI") then
      Controller.RoleSleepTimeUpdate()
    end
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
