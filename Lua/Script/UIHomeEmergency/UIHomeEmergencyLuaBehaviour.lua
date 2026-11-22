local View = require("UIHomeEmergency/UIHomeEmergencyView")
local DataModel = require("UIHomeEmergency/UIHomeEmergencyDataModel")
local ViewFunction = require("UIHomeEmergency/UIHomeEmergencyViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams then
      DataModel.ufid = tostring(Json.decode(initParams).ufid)
    end
    DataModel.InitData()
    DataModel.RefreshOnShow()
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
