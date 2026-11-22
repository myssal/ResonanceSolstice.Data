local View = require("UIGloablePanel/UIGloablePanelView")
local DataModel = require("UIGloablePanel/UIGloablePanelDataModel")
local ViewFunction = require("UIGloablePanel/UIGloablePanelViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
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
  end,
  refresh = function()
    local mainUI = require("UIMainUI/UIMainUILuaBehaviour")[1]
    if mainUI and mainUI.onAppResume then
      mainUI.onAppResume()
    end
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
