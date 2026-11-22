local View = require("UIPrompt_Witches/UIPrompt_WitchesView")
local DataModel = require("UIPrompt_Witches/UIPrompt_WitchesDataModel")
local ViewFunction = require("UIPrompt_Witches/UIPrompt_WitchesViewFunction")
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
  perupdate = function()
  end,
  update = function()
    if DataModel.timer then
      DataModel.timer:Update()
    end
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
