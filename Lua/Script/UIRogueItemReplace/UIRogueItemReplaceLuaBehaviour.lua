local View = require("UIRogueItemReplace/UIRogueItemReplaceView")
local DataModel = require("UIRogueItemReplace/UIRogueItemReplaceDataModel")
local ViewFunction = require("UIRogueItemReplace/UIRogueItemReplaceViewFunction")
local Controller = require("UIRogueItemReplace/UIRogueItemReplaceController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.InitData()
    Controller.ShowPanel()
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
