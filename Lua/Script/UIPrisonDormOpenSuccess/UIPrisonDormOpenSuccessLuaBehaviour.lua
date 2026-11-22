local View = require("UIPrisonDormOpenSuccess/UIPrisonDormOpenSuccessView")
local DataModel = require("UIPrisonDormOpenSuccess/UIPrisonDormOpenSuccessDataModel")
local ViewFunction = require("UIPrisonDormOpenSuccess/UIPrisonDormOpenSuccessViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
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
