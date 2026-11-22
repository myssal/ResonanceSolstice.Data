local View = require("UIPublicizeSendSuccess/UIPublicizeSendSuccessView")
local DataModel = require("UIPublicizeSendSuccess/UIPublicizeSendSuccessDataModel")
local ViewFunction = require("UIPublicizeSendSuccess/UIPublicizeSendSuccessViewFunction")
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
