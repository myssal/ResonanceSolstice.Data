local View = require("UIWitchesMap/UIWitchesMapView")
local DataModel = require("UIWitchesMap/UIWitchesMapDataModel")
local Controller = require("UIWitchesMap/UIWitchesMapController")
local ViewFunction = require("UIWitchesMap/UIWitchesMapViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
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
