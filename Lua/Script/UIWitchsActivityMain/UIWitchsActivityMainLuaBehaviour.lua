local View = require("UIWitchsActivityMain/UIWitchsActivityMainView")
local DataModel = require("UIWitchsActivityMain/UIWitchsActivityMainDataModel")
local ViewFunction = require("UIWitchsActivityMain/UIWitchsActivityMainViewFunction")
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
