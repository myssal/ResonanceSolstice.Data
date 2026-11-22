local View = require("UICubeRogueQuit/UICubeRogueQuitView")
local DataModel = require("UICubeRogueQuit/UICubeRogueQuitDataModel")
local ViewFunction = require("UICubeRogueQuit/UICubeRogueQuitViewFunction")
local RogueMain = require("UICubeRogueMain/UICubeRoguewMainController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
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
