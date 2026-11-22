local View = require("UIPrisonEntrance/UIPrisonEntranceView")
local DataModel = require("UIPrisonEntrance/UIPrisonEntranceDataModel")
local ViewFunction = require("UIPrisonEntrance/UIPrisonEntranceViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.RefreshOnShow()
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
