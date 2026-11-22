local View = require("UIWitchBag/UIWitchBagView")
local DataModel = require("UIWitchBag/UIWitchBagDataModel")
local Controller = require("UIWitchBag/UIWitchBagController")
local ViewFunction = require("UIWitchBag/UIWitchBagViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.InitData()
    Controller.RefreshOnShow()
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
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
