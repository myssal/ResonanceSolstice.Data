local View = require("UIActivityEngineCore/UIActivityEngineCoreView")
local DataModel = require("UIActivityEngineCore/UIActivityEngineCoreDataModel")
local ViewFunction = require("UIActivityEngineCore/UIActivityEngineCoreViewFunction")
local Controller = require("UIActivityEngineCore/UIActivityEngineCoreController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Controller.Init()
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
