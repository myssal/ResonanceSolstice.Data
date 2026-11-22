local View = require("UIPrisonerEscape/UIPrisonerEscapeView")
local DataModel = require("UIPrisonerEscape/UIPrisonerEscapeDataModel")
local ViewFunction = require("UIPrisonerEscape/UIPrisonerEscapeViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.SetJsonData(initParams)
    DataModel.InitData()
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
