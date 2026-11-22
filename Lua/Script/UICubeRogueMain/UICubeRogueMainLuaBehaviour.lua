local View = require("UICubeRogueMain/UICubeRogueMainView")
local DataModel = require("UICubeRogueMain/UICubeRogueMainDataModel")
local ViewFunction = require("UICubeRogueMain/UICubeRogueMainViewFunction")
local Controller = require("UICubeRogueMain/UICubeRoguewMainController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Controller.ResetPanel()
    if initParams then
      local param = Json.decode(initParams)
      Controller.delayContinue = param.delayContinue
    end
  end,
  awake = function()
  end,
  start = function()
    Controller.OnPanelOpen()
  end,
  update = function()
    Controller:Update()
  end,
  ondestroy = function()
    Controller.ClearData()
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
