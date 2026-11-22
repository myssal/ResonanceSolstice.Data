local View = require("UIChangeSealEvent/UIChangeSealEventView")
local DataModel = require("UIChangeSealEvent/UIChangeSealEventDataModel")
local ViewFunction = require("UIChangeSealEvent/UIChangeSealEventViewFunction")
local Controller = require("UIChangeSealEvent/UIChangeSealEventController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.SetJsonData(initParams)
    Controller:Init()
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
