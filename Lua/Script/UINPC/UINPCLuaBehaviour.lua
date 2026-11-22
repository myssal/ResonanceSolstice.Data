local View = require("UINPC/UINPCView")
local DataModel = require("UINPC/UINPCDataModel")
local Controller = require("UINPC/UINPCController")
local ViewFunction = require("UINPC/UINPCViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.initParams = Json.decode(initParams)
    Controller:SelfInit()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if DataModel.autoUpdateOrder then
      DataModel.autoUpdateOrder = false
      if DataModel.parentView then
        View.self:SetCanvasOrder(DataModel.parentView.CurrOrder)
        View.self.IsDisableUIOrder = true
      end
    end
  end,
  ondestroy = function()
    Controller:ViewClosedCall()
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
