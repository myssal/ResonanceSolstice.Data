local View = require("UITokenPayTips/UITokenPayTipsView")
local DataModel = require("UITokenPayTips/UITokenPayTipsDataModel")
local ViewFunction = require("UITokenPayTips/UITokenPayTipsViewFunction")
local ViewController = require("UITokenPayTips/UITokenPayTipsViewController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    ViewController:DeserializeView(initParams)
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
