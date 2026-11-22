local View = require("UIBattleBossTip/UIBattleBossTipView")
local DataModel = require("UIBattleBossTip/UIBattleBossTipDataModel")
local ViewFunction = require("UIBattleBossTip/UIBattleBossTipViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.Init(initParams)
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
