local View = require("UIActivitySafe/UIActivitySafeView")
local DataModel = require("UIActivitySafe/UIActivitySafeDataModel")
local ViewFunction = require("UIActivitySafe/UIActivitySafeViewFunction")
local Controller = require("UIActivitySafe/UIActivitySafeController")
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
