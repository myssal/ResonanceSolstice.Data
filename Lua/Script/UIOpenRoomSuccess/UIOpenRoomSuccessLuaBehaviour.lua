local View = require("UIOpenRoomSuccess/UIOpenRoomSuccessView")
local DataModel = require("UIOpenRoomSuccess/UIOpenRoomSuccessDataModel")
local ViewFunction = require("UIOpenRoomSuccess/UIOpenRoomSuccessViewFunction")
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
