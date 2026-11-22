local View = require("UIRoguehelp/UIRoguehelpView")
local DataModel = require("UIRoguehelp/UIRoguehelpDataModel")
local ViewFunction = require("UIRoguehelp/UIRoguehelpViewFunction")
local Controller = require("UIRoguehelp/UIRoguehelpController")
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
