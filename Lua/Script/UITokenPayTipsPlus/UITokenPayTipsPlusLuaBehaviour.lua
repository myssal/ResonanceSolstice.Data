local View = require("UITokenPayTipsPlus/UITokenPayTipsPlusView")
local DataModel = require("UITokenPayTipsPlus/UITokenPayTipsPlusDataModel")
local ViewFunction = require("UITokenPayTipsPlus/UITokenPayTipsPlusViewFunction")
local ViewController = require("UITokenPayTipsPlus/UITokenPayTipsPlusViewController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    ViewController:Deserialize(initParams)
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
