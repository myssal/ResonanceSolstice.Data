local View = require("UIIllustration_Source/UIIllustration_SourceView")
local DataModel = require("UIIllustration_Source/UIIllustration_SourceDataModel")
local ViewFunction = require("UIIllustration_Source/UIIllustration_SourceViewFunction")
local Controller = require("UIIllustration_Source/UIIllustration_SourceController")
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
