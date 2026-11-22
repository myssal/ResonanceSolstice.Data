local View = require("UIItemPrompt_Witches/UIItemPrompt_WitchesView")
local DataModel = require("UIItemPrompt_Witches/UIItemPrompt_WitchesDataModel")
local ViewFunction = require("UIItemPrompt_Witches/UIItemPrompt_WitchesViewFunction")
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
