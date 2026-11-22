local View = require("UILinkPasswordSet/UILinkPasswordSetView")
local DataModel = require("UILinkPasswordSet/UILinkPasswordSetDataModel")
local ViewFunction = require("UILinkPasswordSet/UILinkPasswordSetViewFunction")
local ViewController = require("UILinkPasswordSet/UILinkPasswordSetViewController")
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
