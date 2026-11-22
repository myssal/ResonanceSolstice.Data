local View = require("UIPrisonOpenSuccess/UIPrisonOpenSuccessView")
local DataModel = require("UIPrisonOpenSuccess/UIPrisonOpenSuccessDataModel")
local ViewFunction = require("UIPrisonOpenSuccess/UIPrisonOpenSuccessViewFunction")
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
