local View = require("UIWitchesEvent/UIWitchesEventView")
local DataModel = require("UIWitchesEvent/UIWitchesEventDataModel")
local ViewFunction = require("UIWitchesEvent/UIWitchesEventViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.SetJsonData(initParams)
    DataModel.InitData()
    DataModel.RefreshOnShow()
    View.Img_BG.SoftMask_Character:MaskAllManaged()
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
