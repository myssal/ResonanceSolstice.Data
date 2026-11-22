local View = require("UIPrisonPowerRoomPrompt/UIPrisonPowerRoomPromptView")
local DataModel = require("UIPrisonPowerRoomPrompt/UIPrisonPowerRoomPromptDataModel")
local ViewFunction = require("UIPrisonPowerRoomPrompt/UIPrisonPowerRoomPromptViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.SetJsoData(initParams)
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
