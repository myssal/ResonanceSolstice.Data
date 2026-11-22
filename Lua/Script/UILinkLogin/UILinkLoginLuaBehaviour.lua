local View = require("UILinkLogin/UILinkLoginView")
local DataModel = require("UILinkLogin/UILinkLoginDataModel")
local ViewFunction = require("UILinkLogin/UILinkLoginViewFunction")
local ViewController = require("UILinkLogin/UILinkLoginViewController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    ViewController:DeserializeView()
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
